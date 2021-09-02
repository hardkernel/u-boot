// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020 Grandstream Networks, Inc
 *
 * Authors:
 *	Carl <xjxia@grandstream.cn>
 */

#ifndef __UBOOT__
#include <linux/device.h>
#include <linux/kernel.h>
#endif
#include <linux/mtd/spinand.h>

#define SPINAND_MFR_SILICONGO		0xEA

static SPINAND_OP_VARIANTS(read_cache_variants,
		SPINAND_PAGE_READ_FROM_CACHE_QUADIO_OP(0, 2, NULL, 0),
		SPINAND_PAGE_READ_FROM_CACHE_X4_OP(0, 1, NULL, 0),
		SPINAND_PAGE_READ_FROM_CACHE_DUALIO_OP(0, 1, NULL, 0),
		SPINAND_PAGE_READ_FROM_CACHE_X2_OP(0, 1, NULL, 0),
		SPINAND_PAGE_READ_FROM_CACHE_OP(true, 0, 1, NULL, 0),
		SPINAND_PAGE_READ_FROM_CACHE_OP(false, 0, 1, NULL, 0));

static SPINAND_OP_VARIANTS(write_cache_variants,
		SPINAND_PROG_LOAD_X4(true, 0, NULL, 0),
		SPINAND_PROG_LOAD(true, 0, NULL, 0));

static SPINAND_OP_VARIANTS(update_cache_variants,
		SPINAND_PROG_LOAD_X4(false, 0, NULL, 0),
		SPINAND_PROG_LOAD(false, 0, NULL, 0));

static int sgm7000i_ooblayout_ecc(struct mtd_info *mtd, int section,
				  struct mtd_oob_region *region)
{
	return -ERANGE;
}

static int sgm7000i_ooblayout_free(struct mtd_info *mtd, int section,
				   struct mtd_oob_region *region)
{
	if (section)
		return -ERANGE;

	region->offset = 2;
	region->length = mtd->oobsize - 2;

	return 0;
}

static const struct mtd_ooblayout_ops sgm7000i_ooblayout = {
	.ecc = sgm7000i_ooblayout_ecc,
	.rfree = sgm7000i_ooblayout_free,
};

static const struct spinand_info silicongo_spinand_table[] = {
	SPINAND_INFO("SGM7000I-S24W1GH", 0xC1,
		     NAND_MEMORG(1, 2048, 64, 64, 1024, 1, 1, 1),
		     NAND_ECCREQ(4, 512),
		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
					      &write_cache_variants,
					      &update_cache_variants),
		     SPINAND_HAS_QE_BIT,
		     SPINAND_ECCINFO(&sgm7000i_ooblayout, NULL)),
};

/**
 * silicongo_spinand_detect - initialize device related part in spinand_device
 * struct if it is a silicongo device.
 * @spinand: SPI NAND device structure
 */
static int silicongo_spinand_detect(struct spinand_device *spinand)
{
	u8 *id = spinand->id.data;
	int ret;

	/*
	 * silicongo SPI NAND read ID need a dummy byte,
	 * so the first byte in raw_id is dummy.
	 */
	if (id[1] != SPINAND_MFR_SILICONGO)
		return 0;

	ret = spinand_match_and_init(spinand, silicongo_spinand_table,
				     ARRAY_SIZE(silicongo_spinand_table), id[2]);
	/* Not Only SILICONGO Nands MFR equals C8h */
	if (ret)
		return 0;

	return 1;
}

static int silicongo_spinand_init(struct spinand_device *spinand)
{
	return 0;
}

static const struct spinand_manufacturer_ops silicongo_spinand_manuf_ops = {
	.detect = silicongo_spinand_detect,
	.init = silicongo_spinand_init,
};

const struct spinand_manufacturer silicongo_spinand_manufacturer = {
	.id = SPINAND_MFR_SILICONGO,
	.name = "silicongo",
	.ops = &silicongo_spinand_manuf_ops,
};
