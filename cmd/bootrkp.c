/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <android_bootloader.h>
#include <attestation_key.h>
#include <boot_rkimg.h>

static int do_boot_rockchip(cmd_tbl_t *cmdtp, int flag, int argc,
		      char * const argv[])
{
	disk_partition_t part_info;
	struct blk_desc *dev_desc;
	int mode = 0;
	char *boot_partname = PART_BOOT;
	int ret = 0;
	int i = 0;

	dev_desc = rockchip_get_bootdev();

#ifdef CONFIG_OPTEE_CLIENT
	disk_partition_t misc_part_info;

	/* load attestation key from misc partition. */
	ret = part_get_info_by_name(dev_desc, "misc",
				    &misc_part_info);
	if (ret < 0)
		printf("%s Could not find misc partition\n", __func__);
	else
		load_attestation_key(dev_desc, &misc_part_info);
#endif

	mode = rockchip_get_boot_mode();
	if (mode == BOOT_MODE_RECOVERY) {
		boot_partname = PART_RECOVERY;
		printf("%s boot from Recovery partition!\n", __func__);
	}

	for (i = 0; i < argc; i++) {
		if (!strcmp(argv[i], "boot-recovery")) {
			boot_partname = PART_RECOVERY;
			printf("%s argv%d:%s boot from Recovery partition!\n",
				__func__, i, argv[i]);
		}
	}

	ret = part_get_info_by_name(dev_desc, boot_partname, &part_info);

	if(boot_rockchip_image(dev_desc, &part_info))
		ret = CMD_RET_FAILURE;

	return ret;
}

U_BOOT_CMD(
	bootrkp,  CONFIG_SYS_MAXARGS,     1,      do_boot_rockchip,
	"Boot Linux Image from rockchip image type",
	"kernel.img: zImage/Image\n"
	"boot.img: ramdisk\n"
	"resource.img: dtb, u-boot logo, kernel logo"
);
