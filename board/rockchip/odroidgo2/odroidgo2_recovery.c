/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <rksfc.h>
#include <fs.h>
#include <rockchip_display_cmds.h>
#include <odroidgo2_status.h>

int recovery_check_mandatory_files(void)
{
	if (!file_exists("mmc", "1", "spi_recovery.img", FS_TYPE_FAT))
		return -1;

	if (!file_exists("mmc", "1", "spi_recovery.img.md5sum", FS_TYPE_FAT))
		return -1;

	return 0;
}

int board_check_recovery(void)
{
	char *bootdev = env_get("devtype");

	/* only available with SD boot */
	if (strncmp(bootdev, "mmc", 3))
		return -1;

	if (recovery_check_mandatory_files())
		return -1;

	odroid_display_status(LOGO_MODE_RECOVERY, LOGO_STORAGE_ANYWHERE, NULL);

	return 0;
}

#define WRITE_UNIT	(32 * 512)
void board_odroid_recovery(void)
{
	char cmd[128];
	char str[64];
	char *saddr;
	char *md5sum_readback;
	char md5sum_org[64];
	int ret, loop;
	int offs, unit;
	int filesize;
	int progress;
	float percentage = 0;
	unsigned long addr;

	/* check spi flash */
	if (rksfc_scan_namespace()) {
		printf("spi flash probe fail!\n");
		odroid_display_status(LOGO_MODE_SYSTEM_ERR, LOGO_STORAGE_ANYWHERE,
				"spi flash probe fail");
		odroid_wait_pwrkey();
	}

	/* probe spi flash */
	run_command("rksfc dev 1", 0);

	/* load img and write */
	run_command( "fatload mmc 1:1 $loadaddr spi_recovery.img", 0);
	filesize = env_get_ulong("filesize", 16, 0);
	saddr = env_get("loadaddr");
	addr = simple_strtoul(saddr, NULL, 16);
	offs = 0;
	progress = 0;
	while (progress < filesize) {
		if ((filesize - progress) > WRITE_UNIT)
			unit = WRITE_UNIT / 512;
		else
			unit = (filesize - progress) / 512;

		sprintf(cmd, "rksfc write %p 0x%x 0x%x", (void *)addr, offs, unit);
		run_command(cmd, 0);

		percentage = progress * 100 / filesize;
		sprintf(str, "recovery progress :%3d %%", (int) percentage);
		lcd_printf(0, 18, 1, "%s", str);

		offs += unit;
		addr += unit * 512;
		progress += unit * 512;
	}

	sprintf(str, "recovery progress :%3d %%", (int) percentage);
	lcd_printf(0, 18, 1, "%s", str);

	/* readback & calculate md5sum */
	run_command("rksfc read $loadaddr 0x0 $sz_total", 0);
	run_command("md5sum $loadaddr $filesize md5sum_readback", 0);
	md5sum_readback = env_get("md5sum_readback");

	/* check spi_recovery.img.md5sum and compare */
	sprintf(cmd, "fatload mmc 1:1 %p spi_recovery.img.md5sum", (void *)md5sum_org);
	run_command(cmd, 0);

	ret = strncmp(md5sum_org, md5sum_readback, 32);
	if (ret) {
		printf("checksum fail! ret %d\n", ret);
		odroid_display_status(LOGO_MODE_SYSTEM_ERR, LOGO_STORAGE_ANYWHERE,
				"checksum fail!");
		odroid_wait_pwrkey();
	}

	/* check manufacture file */
	ret = run_command("fatload mmc 1:1 $loadaddr manufacture", 0);
	if (ret != CMD_RET_SUCCESS) {
		printf("no manufacture flag in sd card, remove boot loaders\n");
		/* remove boot loaders of sd card */
		run_command("mmc rescan", 0);
		run_command("mmc dev 1", 0);
		run_command("mmc erase 0x1 0x7FFF", 0);
		sprintf(cmd, "reset");
	} else {
		sprintf(cmd, "poweroff");
	}

	/* recovery done */
	loop = 3;
	while (loop) {
		sprintf(str, "recovery done! system %s in %d sec", cmd, loop);
		/* there is no vfat mbr in sd card now */
		odroid_display_status(LOGO_MODE_RECOVERY, LOGO_STORAGE_ANYWHERE, str);
		mdelay(1000);
		loop--;
	};

	run_command(cmd, 0);
}
