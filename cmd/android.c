/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <android_image.h>
#include <blk.h>
#include <boot_rkimg.h>
#include <command.h>
#include <malloc.h>

static int do_android_print_hdr(cmd_tbl_t *cmdtp, int flag,
				int argc, char * const argv[])
{
	struct blk_desc *dev_desc;
	struct andr_img_hdr *hdr;
	disk_partition_t part_info;
	const char *part_name;
	int blkcnt, ret;

	if (argc != 2)
		return CMD_RET_USAGE;

	part_name = argv[1];

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("dev_desc is NULL!\n");
		return -ENODEV;
	}

	ret = part_get_info_by_name(dev_desc, part_name, &part_info);
	if (ret < 0) {
		printf("Failed to get \"%s\" part, ret=%d\n", part_name, ret);
		return -ENODEV;
	}

	blkcnt = DIV_ROUND_UP(sizeof(*hdr), dev_desc->blksz);
	hdr = memalign(ARCH_DMA_MINALIGN, dev_desc->blksz * blkcnt);
	if (!hdr) {
		printf("%s: out of memory!\n", __func__);
		return -ENOMEM;
	}

	ret = blk_dread(dev_desc, part_info.start, blkcnt, hdr);
	if (ret != blkcnt) {
		printf("Failed to read %s sector, ret=%d\n", part_info.name, ret);
		free(hdr);
		return -EIO;
	}

	if (!android_image_check_header(hdr)) {
		printf("Partition \"%s\"\n", part_info.name);
		android_print_contents(hdr);
	} else {
		printf("Not an android image\n");
	}

	free(hdr);

	return 0;
}

U_BOOT_CMD(
	android_print_hdr, 2, 1, do_android_print_hdr,
	"print android image header", "<partition name>"
);
