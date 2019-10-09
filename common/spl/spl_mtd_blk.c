// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <blk.h>
#include <dm.h>
#include <errno.h>
#include <image.h>
#include <malloc.h>
#include <part.h>
#include <spl.h>
#include <spl_ab.h>
#include <spl_rkfw.h>
#include <asm/u-boot.h>
#include <dm/device-internal.h>
#include <linux/compiler.h>
#include <linux/mtd/mtd.h>

static int spl_mtd_get_device_index(u32 boot_device)
{
	switch (boot_device) {
	case BOOT_DEVICE_MTD_BLK_NAND:
		return 0;
	case BOOT_DEVICE_MTD_BLK_SPI_NAND:
		return 1;
	case BOOT_DEVICE_MTD_BLK_SPI_NOR:
		return 2;
	}

#ifdef CONFIG_SPL_LIBCOMMON_SUPPORT
	printf("spl: unsupported mtd boot device.\n");
#endif

	return -ENODEV;
}

struct blk_desc *find_mtd_device(int dev_num)
{
	struct udevice *dev;
	struct blk_desc *desc;
	int ret;

	ret = blk_find_device(IF_TYPE_MTD, dev_num, &dev);

	if (ret) {
#if !defined(CONFIG_SPL_BUILD) || defined(CONFIG_SPL_LIBCOMMON_SUPPORT)
		printf("MTD Device %d not found\n", dev_num);
#endif
		return NULL;
	}

	ret = device_probe(dev);
	if (ret) {
#if !defined(CONFIG_SPL_BUILD) || defined(CONFIG_SPL_LIBCOMMON_SUPPORT)
		printf("MTD Device %d not found\n", dev_num);
#endif
		return NULL;
	}

	desc = dev_get_uclass_platdata(dev);
	if (!desc)
		return NULL;

	return desc;
}

#ifdef CONFIG_SPL_LOAD_RKFW
static ulong mtd_spl_load_read(struct spl_load_info *load, ulong sector,
			       ulong count, void *buf)
{
	struct blk_desc *desc = load->dev;

	return blk_dread(desc, sector, count, buf);
}

int spl_mtd_load_rkfw(struct spl_image_info *spl_image, struct blk_desc *desc)
{
	int ret = -1;

	u32 trust_sectors = CONFIG_RKFW_TRUST_SECTOR;
	u32 uboot_sectors = CONFIG_RKFW_U_BOOT_SECTOR;
	struct spl_load_info load;

	load.dev = desc;
	load.priv = NULL;
	load.filename = NULL;
	load.bl_len = desc->blksz;
	load.read = mtd_spl_load_read;

#ifdef CONFIG_SPL_AB
	char trust_partition[] = "trust";
	char uboot_partition[] = "uboot";

	spl_get_partitions_sector(desc, trust_partition,
				  &trust_sectors);
	spl_get_partitions_sector(desc, uboot_partition,
				  &uboot_sectors);
#endif

	ret = spl_load_rkfw_image(spl_image, &load,
				  trust_sectors,
				  uboot_sectors);
	if (ret) {
#ifdef CONFIG_SPL_LIBCOMMON_SUPPORT
		puts("spl_mtd_load_rkfw: mtd block read error\n");
#endif
		return -1;
	}

	return ret;
}
#endif

int spl_mtd_load_image(struct spl_image_info *spl_image,
		       struct spl_boot_device *bootdev)
{
	struct blk_desc *desc;
	int ret = 0;

	desc = find_mtd_device(spl_mtd_get_device_index(bootdev->boot_device));
	if (!desc)
		return -ENODEV;
#ifdef CONFIG_SPL_LOAD_RKFW
	ret = spl_mtd_load_rkfw(spl_image, desc);
#endif
	return ret;
}

SPL_LOAD_IMAGE_METHOD("MTD1", 0, BOOT_DEVICE_MTD_BLK_NAND, spl_mtd_load_image);
SPL_LOAD_IMAGE_METHOD("MTD2", 0, BOOT_DEVICE_MTD_BLK_SPI_NAND, spl_mtd_load_image);
SPL_LOAD_IMAGE_METHOD("MTD3", 0, BOOT_DEVICE_MTD_BLK_SPI_NOR, spl_mtd_load_image);
