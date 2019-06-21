/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <errno.h>
#include <nand.h>
#include <dm/device-internal.h>

ulong mtd_dread(struct udevice *udev, lbaint_t start,
		lbaint_t blkcnt, void *dst)
{
	struct blk_desc *desc = dev_get_uclass_platdata(udev);

	if (!desc)
		return 0;

	if (blkcnt == 0)
		return 0;

	if (desc->devnum == BLK_MTD_NAND) {
		int ret = 0;
		size_t rwsize = blkcnt * 512;
		struct mtd_info *mtd = dev_get_priv(udev->parent);
		struct nand_chip *chip = mtd_to_nand(mtd);
		loff_t off = (loff_t)(start * 512);

		if (!mtd) {
			puts("\nno mtd available\n");
			return 0;
		}

		if (!chip) {
			puts("\nno chip available\n");
			return 0;
		}

		ret = nand_read_skip_bad(&chip->mtd, off, &rwsize,
					 NULL, chip->mtd.size,
					 (u_char *)(dst));
		if (ret)
			return 0;
		else
			return blkcnt;
	} else if (desc->devnum == BLK_MTD_SPI_NAND) {
		/* Not implemented */
		return 0;
	} else if (desc->devnum == BLK_MTD_SPI_NOR) {
		/* Not implemented */
		return 0;
	} else {
		return 0;
	}
}

ulong mtd_dwrite(struct udevice *udev, lbaint_t start,
		 lbaint_t blkcnt, const void *src)
{
	/* Not implemented */
	return 0;
}

ulong mtd_derase(struct udevice *udev, lbaint_t start,
		 lbaint_t blkcnt)
{
	/* Not implemented */
	return 0;
}

static int mtd_blk_probe(struct udevice *udev)
{
	struct blk_desc *desc = dev_get_uclass_platdata(udev);
	struct mtd_info *mtd = dev_get_priv(udev->parent);

	sprintf(desc->vendor, "0x%.4x", 0x2207);
	memcpy(desc->product, mtd->name, strlen(mtd->name));
	memcpy(desc->revision, "V1.00", sizeof("V1.00"));
	if (mtd->type == MTD_NANDFLASH) {
		/* Reserve 4 blocks for BBT(Bad Block Table) */
		desc->lba = (mtd->size >> 9) - (mtd->erasesize >> 9) * 4;
	} else {
		desc->lba = mtd->size >> 9;
	}

	return 0;
}

static const struct blk_ops mtd_blk_ops = {
	.read	= mtd_dread,
#ifndef CONFIG_SPL_BUILD
	.write	= mtd_dwrite,
	.erase	= mtd_derase,
#endif
};

U_BOOT_DRIVER(mtd_blk) = {
	.name		= "mtd_blk",
	.id		= UCLASS_BLK,
	.ops		= &mtd_blk_ops,
	.probe		= mtd_blk_probe,
};
