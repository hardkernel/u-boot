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

#define SPINAND_MFR_FORESEE		0xCD

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

static int fsxxndxxg_ooblayout_ecc(struct mtd_info *mtd, int section,
				   struct mtd_oob_region *region)
{
	if (section)
		return -ERANGE;

	region->offset = 64;
	region->length = 64;

	return 0;
}

static int fsxxndxxg_ooblayout_free(struct mtd_info *mtd, int section,
				    struct mtd_oob_region *region)
{
	if (section)
		return -ERANGE;

	/* Reserve 1 bytes for the BBM. */
	region->offset = 1;
	region->length = 63;

	return 0;
}

static const struct mtd_ooblayout_ops fsxxndxxg_ooblayout = {
	.ecc = fsxxndxxg_ooblayout_ecc,
	.rfree = fsxxndxxg_ooblayout_free,
};

static const struct spinand_info foresee_spinand_table[] = {
	SPINAND_INFO("FS35ND01G-S1Y2", 0xEA,
		     NAND_MEMORG(1, 2048, 64, 64, 1024, 1, 1, 1),
		     NAND_ECCREQ(4, 512),
		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
					      &write_cache_variants,
					      &update_cache_variants),
		     0,
		     SPINAND_ECCINFO(&fsxxndxxg_ooblayout, NULL)),
};

/**
 * foresee_spinand_detect - initialize device related part in spinand_device
 * struct if it is a foresee device.
 * @spinand: SPI NAND device structure
 */
static int foresee_spinand_detect(struct spinand_device *spinand)
{
	u8 *id = spinand->id.data;
	int ret;

	/*
	 * foresee SPI NAND read ID need a dummy byte,
	 * so the first byte in raw_id is dummy.
	 */
	if (id[1] != SPINAND_MFR_FORESEE)
		return 0;

	ret = spinand_match_and_init(spinand, foresee_spinand_table,
				     ARRAY_SIZE(foresee_spinand_table), id[2]);
	if (ret)
		return ret;

	return 1;
}

static int foresee_spinand_init(struct spinand_device *spinand)
{
	return 0;
}

static const struct spinand_manufacturer_ops foresee_spinand_manuf_ops = {
	.detect = foresee_spinand_detect,
	.init = foresee_spinand_init,
};

const struct spinand_manufacturer foresee_spinand_manufacturer = {
	.id = SPINAND_MFR_FORESEE,
	.name = "foresee",
	.ops = &foresee_spinand_manuf_ops,
};
