// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2021 Rockchip Electronics Co., Ltd
 *
 * Authors:
 *	Dingqiang Lin <jon.lin@rock-chips.com>
 */

#ifndef __UBOOT__
#include <linux/device.h>
#include <linux/kernel.h>
#endif
#include <linux/mtd/spinand.h>

#define SPINAND_MFR_UNIM		0xA1

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

static int tx25g01_ooblayout_ecc(struct mtd_info *mtd, int section,
				 struct mtd_oob_region *region)
{
	if (section > 3)
		return -ERANGE;

	region->offset = (16 * section) + 8;
	region->length = 8;

	return 0;
}

static int tx25g01_ooblayout_free(struct mtd_info *mtd, int section,
				  struct mtd_oob_region *region)
{
	if (section > 3)
		return -ERANGE;

	region->offset = (16 * section) + 2;
	region->length = 6;

	return 0;
}

static const struct mtd_ooblayout_ops tx25g01_ooblayout = {
	.ecc = tx25g01_ooblayout_ecc,
	.rfree = tx25g01_ooblayout_free,
};

/*
 * ecc bits: 0xC0[4,6]
 * [0b000], No bit errors were detected;
 * [0b001, 0b011], 1~3 Bit errors were detected and corrected. Not
 *	reach Flipping Bits;
 * [0b100], Bit error count equals the bit flip
 *	detection threshold
 * others, Reserved.
 */
static int tx25g01_ecc_get_status(struct spinand_device *spinand,
				  u8 status)
{
	u8 eccsr = (status & GENMASK(6, 4)) >> 2;

	if (eccsr <= 7)
		return eccsr;
	else if (eccsr == 12)
		return 8;
	else
		return -EBADMSG;
}

static const struct spinand_info unim_spinand_table[] = {
	SPINAND_INFO("TX25G01", 0xF1,
		     NAND_MEMORG(1, 2048, 64, 64, 1024, 1, 1, 1),
		     NAND_ECCREQ(4, 512),
		     SPINAND_INFO_OP_VARIANTS(&read_cache_variants,
					      &write_cache_variants,
					      &update_cache_variants),
		     SPINAND_HAS_QE_BIT,
		     SPINAND_ECCINFO(&tx25g01_ooblayout, tx25g01_ecc_get_status)),
};

/**
 * unim_spinand_detect - initialize device related part in spinand_device
 * struct if it is a UNIM device.
 * @spinand: SPI NAND device structure
 */
static int unim_spinand_detect(struct spinand_device *spinand)
{
	u8 *id = spinand->id.data;
	int ret;

	/*
	 * UNIM SPI NAND read ID need a dummy byte,
	 * so the first byte in raw_id is dummy.
	 */
	if (id[1] != SPINAND_MFR_UNIM)
		return 0;

	ret = spinand_match_and_init(spinand, unim_spinand_table,
				     ARRAY_SIZE(unim_spinand_table),
				     id[2]);
	/* Not Only UNIM Nands MFR equals A1h */
	if (ret)
		return 0;

	return 1;
}

static const struct spinand_manufacturer_ops unim_spinand_manuf_ops = {
	.detect = unim_spinand_detect,
};

const struct spinand_manufacturer unim_spinand_manufacturer = {
	.id = SPINAND_MFR_UNIM,
	.name = "UNIM",
	.ops = &unim_spinand_manuf_ops,
};
