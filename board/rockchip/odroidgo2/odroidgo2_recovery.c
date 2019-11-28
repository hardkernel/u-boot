/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <rksfc.h>
#include "odroidgo2_status.h"

int board_check_recovery(void)
{
	char *bootdev = env_get("devtype");

	/* only available with SD boot */
	if (strncmp(bootdev, "mmc", 3))
		return -1;

	odroid_display_status(LOGO_MODE_RECOVERY, LOGO_STORAGE_SDCARD, NULL);

	return 0;
}

void board_odroid_recovery(void)
{
	char cmd[128];
	char *md5sum_readback;
	char md5sum_org[64];
	int ret, loop;

	/* check spi flash */
	if (rksfc_scan_namespace()) {
		printf("spi flash probe fail!\n");
		odroid_display_status(LOGO_MODE_SYSTEM_ERR, LOGO_STORAGE_SDCARD,
				"spi flash probe fail");
		odroid_wait_pwrkey();
	}

	/* probe spi flash */
	run_command("rksfc dev 1", 0);

	/* check spi_recovery.img and update */
	ret = run_command( "fatload mmc 1:1 $loadaddr spi_recovery.img", 0);
	if (ret != CMD_RET_SUCCESS) {
		printf("no spi_recovery.img in sd card\n");
		odroid_display_status(LOGO_MODE_SYSTEM_ERR, LOGO_STORAGE_SDCARD,
				"no spi_recovery.img");
		odroid_wait_pwrkey();
	}

	run_command("rksfc write $loadaddr 0x0 $sz_total", 0);

	/* readback & calculate md5sum */
	run_command("rksfc read $loadaddr 0x0 $sz_total", 0);
	run_command("md5sum $loadaddr $filesize md5sum_readback", 0);
	md5sum_readback = env_get("md5sum_readback");

	/* check spi_recovery.img.md5sum and compare */
	sprintf(cmd, "fatload mmc 1:1 %p spi_recovery.img.md5sum", (void *)md5sum_org);
	ret = run_command(cmd, 0);
	if (ret != CMD_RET_SUCCESS) {
		printf("no spi_recovery.img.md5sum in sd card\n");
		odroid_display_status(LOGO_MODE_SYSTEM_ERR, LOGO_STORAGE_SDCARD,
				"no spi_recovery.img.md5sum");
		odroid_wait_pwrkey();
	}

	ret = strncmp(md5sum_org, md5sum_readback, 32);
	if (ret) {
		printf("checksum fail! ret %d\n", ret);
		odroid_display_status(LOGO_MODE_SYSTEM_ERR, LOGO_STORAGE_SDCARD,
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
	}

	/* recovery done */
	loop = 3;
	while (loop) {
		sprintf(cmd, "recovery done! system reboot in %d sec", loop);
		/* there is no vfat mbr in sd card now */
		odroid_display_status(LOGO_MODE_RECOVERY, LOGO_STORAGE_SPIFLASH, cmd);
		mdelay(1000);
		loop--;
	};

	run_command("reset", 0);
}
