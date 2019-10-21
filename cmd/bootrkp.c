/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <boot_rkimg.h>
#include <keymaster.h>
#include <malloc.h>
#include <android_bootloader.h>
#include <attestation_key.h>

static int do_boot_rockchip(cmd_tbl_t *cmdtp, int flag, int argc,
			    char *const argv[])
{
	char *boot_partname = PART_BOOT;
	disk_partition_t part_info;
	struct blk_desc *dev_desc;
	int i, ret;
	int mode;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return CMD_RET_FAILURE;
	}

#ifdef CONFIG_ANDROID_KEYMASTER_CA
	/* load attestation key from misc partition. */
	ret = part_get_info_by_name(dev_desc, PART_MISC, &part_info);
	if (ret < 0)
		printf("%s: Could not find misc partition\n", __func__);
	else
		load_attestation_key(dev_desc, &part_info);
#endif

#ifdef CONFIG_FASTBOOT_OEM_UNLOCK
	/* read oem unlock status and attach to bootargs */
	char oem_unlock[30] = {0};
	TEEC_Result result;
	uint8_t unlock = 0;

	result = trusty_read_oem_unlock(&unlock);
	if (result) {
		printf("%s: Read oem unlock status failed: %d\n",
		       __func__, result);
	} else {
		snprintf(oem_unlock, sizeof(oem_unlock),
			 "androidboot.oem_unlocked=%d", unlock);
		env_update("bootargs", oem_unlock);
	}
#endif

	mode = rockchip_get_boot_mode();
	if (mode == BOOT_MODE_RECOVERY)
		boot_partname = PART_RECOVERY;

	for (i = 0; i < argc; i++) {
		if (!strcmp(argv[i], "boot-recovery")) {
			boot_partname = PART_RECOVERY;
			printf("Boot from Recovery partition\n");
		}
	}

	ret = part_get_info_by_name(dev_desc, boot_partname, &part_info);
	if (ret < 0) {
		printf("%s: Could not find %s part\n", __func__, part_info.name);
		return CMD_RET_FAILURE;
	}

	return boot_rockchip_image(dev_desc, &part_info) ? CMD_RET_FAILURE : 0;
}

U_BOOT_CMD(
	bootrkp,  CONFIG_SYS_MAXARGS,     1,      do_boot_rockchip,
	"Boot Linux Image from rockchip image type",
	"kernel.img: zImage/Image\n"
	"boot.img: ramdisk\n"
	"resource.img: dtb, u-boot logo, kernel logo"
);

static int do_rkimg_test(cmd_tbl_t *cmdtp, int flag, int argc,
			 char *const argv[])
{
	struct blk_desc *dev_desc;
	u32 *buffer;
	int ret;

	dev_desc = blk_get_dev(argv[1], simple_strtoul(argv[2], NULL, 16));
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return CMD_RET_FAILURE;
	}

	/* Read one block from beginning of IDB data */
	buffer = memalign(ARCH_DMA_MINALIGN, 1024);
	ret = blk_dread(dev_desc, 64, 2, buffer);
	if (ret != 2) {
		printf("%s: Fail to read data from IDB\n", __func__);
		free(buffer);
		return CMD_RET_FAILURE;
	}

	if (buffer[0] == 0xFCDC8C3B) {
		ret = CMD_RET_SUCCESS;

		if (!strcmp("mmc", argv[1]))
			printf("Found IDB in SDcard\n");
		else
			printf("Found IDB in U-disk\n");

		/* TAG in IDB */
		if (0 == buffer[128 + 104 / 4]) {
			if (!strcmp("mmc", argv[1]))
				env_update("bootargs", "sdfwupdate");
			else
				env_update("bootargs", "usbfwupdate");
		}
	} else {
		ret = CMD_RET_FAILURE;
	}

	free(buffer);

	return ret;
}

U_BOOT_CMD(
	rkimgtest, 3, 0,    do_rkimg_test,
	"Test if storage media have rockchip image",
	""
);
