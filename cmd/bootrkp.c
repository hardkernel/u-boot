/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <android_bootloader.h>
#include <boot_rkimg.h>

static int do_boot_rockchip(cmd_tbl_t *cmdtp, int flag, int argc,
		      char * const argv[])
{
	disk_partition_t part_info;
	struct blk_desc *dev_desc;
	int mode = 0;
	char *boot_partname = PART_BOOT;
	int ret = 0;

	dev_desc = rockchip_get_bootdev();
	mode = rockchip_get_boot_mode();
	if (mode == BOOT_MODE_RECOVERY)
		boot_partname = PART_RECOVERY;
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
