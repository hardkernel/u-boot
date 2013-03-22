/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */
 
#ifndef __MOVI_PARTITION_H__
#define __MOVI_PARTITION_H__

#define eFUSE_SIZE		(1 * 512)	// 512 Byte eFuse, 512 Byte reserved

#define MOVI_BLKSIZE		(1<<9) /* 512 bytes */

/* partition information */
#if defined(CONFIG_SECURE_BOOT) || defined(CONFIG_SECURE_BL1_ONLY)
#define PART_SIZE_FWBL1		(8 * 1024)
#else
#define PART_SIZE_FWBL1		0
#endif
#define PART_SIZE_BL1		(16 * 1024)
#define PART_SIZE_UBOOT		(512 * 1024)
#define PART_SIZE_KERNEL	(4 * 1024 * 1024)
#define PART_SIZE_ROOTFS	(6 * 1024 * 1024)
#define PART_SIZE_TZSW		(512 * 1024)

#define MOVI_FWBL1_BLKCNT	(PART_SIZE_FWBL1 / MOVI_BLKSIZE)
#define MOVI_BL1_BLKCNT		(PART_SIZE_BL1 / MOVI_BLKSIZE)
#define MOVI_ENV_BLKCNT		(CONFIG_ENV_SIZE / MOVI_BLKSIZE)	/* 16KB */
#define MOVI_UBOOT_BLKCNT	(PART_SIZE_UBOOT / MOVI_BLKSIZE)	/* 512KB */
#define MOVI_ZIMAGE_BLKCNT	(PART_SIZE_KERNEL / MOVI_BLKSIZE)	/* 4MB */
#define MOVI_ROOTFS_BLKCNT	(PART_SIZE_ROOTFS / MOVI_BLKSIZE)	/* 26MB */
#define MOVI_TZSW_BLKCNT	(PART_SIZE_TZSW / MOVI_BLKSIZE)		/* 512KB */

#define MOVI_UBOOT_POS		((eFUSE_SIZE / MOVI_BLKSIZE) + MOVI_FWBL1_BLKCNT + MOVI_BL1_BLKCNT)

/*
 *
 * start_blk: start block number for image
 * used_blk: blocks occupied by image
 * size: image size in bytes
 * attribute: attributes of image
 *            0x1: u-boot parted (BL1)
 *            0x2: u-boot (BL2)
 *            0x4: kernel
 *            0x8: root file system
 *            0x10: environment area
 *            0x20: reserved
 * description: description for image
 * by scsuh
 */
typedef struct member {
	uint start_blk;
	uint used_blk;
	uint size;
	uint attribute; /* attribute of image */
	char description[16];
} member_t; /* 32 bytes */

/*
 * start_blk: start block number for raw area
 * total_blk: total block number of card
 * next_raw_area: add next raw_area structure
 * description: description for raw_area
 * image: several image that is controlled by raw_area structure
 * by scsuh
 */
typedef struct raw_area {
	uint start_blk; /* compare with PT on coherency test */
	uint total_blk;
	uint next_raw_area; /* should be sector number */
	char description[16];
	member_t image[15];
} raw_area_t; /* 512 bytes */

extern raw_area_t raw_area_control;

#endif /*__MOVI_PARTITION_H__*/
