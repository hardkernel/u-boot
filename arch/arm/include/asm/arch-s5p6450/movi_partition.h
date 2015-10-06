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

#define MOVI_TOTAL_BLKCNT       *((volatile unsigned int*)(SDMMC_BLK_SIZE))

#if defined(CONFIG_SECURE_BOOT) || defined(CONFIG_FUSED)
#define FWBL1_SIZE		(8 * 1024)
#endif

#if defined(CONFIG_S5P6450)
        #if defined(CONFIG_S5P6460_IP_TEST)
                #define SS_SIZE			(100 * 1024)
        #else
                #define SS_SIZE			(16 * 1024)
        #endif
#else
#define SS_SIZE			(8 * 1024)
#endif

#if defined(CONFIG_EVT1)
#define eFUSE_SIZE		(1 * 512)	// 512 Byte eFuse, 512 Byte reserved
#else
#define eFUSE_SIZE		(1 * 1024)	// 1 KB eFuse, 1 KB reserved
#endif

#define MOVI_BLKSIZE		(1<<9) /* 512 bytes */

/* partition information */
#define PART_SIZE_BL		(512 * 1024)
#define PART_SIZE_KERNEL	(4 * 1024 * 1024)
#define PART_SIZE_ROOTFS	(26 * 1024 * 1024)

#define MOVI_LAST_BLKPOS	(MOVI_TOTAL_BLKCNT - (eFUSE_SIZE / MOVI_BLKSIZE))

/* Add block count at fused chip */
#if defined(CONFIG_SECURE_BOOT) || defined(CONFIG_FUSED)
#define MOVI_FWBL1_BLKCNT	(FWBL1_SIZE / MOVI_BLKSIZE)     	/* 4KB */
#endif
#define MOVI_BL1_BLKCNT		(SS_SIZE / MOVI_BLKSIZE)        	/* 16KB */
#define MOVI_ENV_BLKCNT		(CONFIG_ENV_SIZE / MOVI_BLKSIZE)	/* 16KB */
#define MOVI_UBOOT_BLKCNT	(PART_SIZE_BL / MOVI_BLKSIZE)   	/* 512KB */
#define MOVI_ZIMAGE_BLKCNT	(PART_SIZE_KERNEL / MOVI_BLKSIZE)	/* 4MB */

/* Change writing block position at fused chip */
#if defined(CONFIG_EVT1)
	#if defined(CONFIG_SECURE) || defined(CONFIG_FUSED)
		#if defined(CONFIG_EMMC)
#define MOVI_UBOOT_POS		((FWBL1_SIZE / MOVI_BLKSIZE) + MOVI_BL1_BLKCNT)
		#else
#define MOVI_UBOOT_POS		((eFUSE_SIZE / MOVI_BLKSIZE) + (FWBL1_SIZE / MOVI_BLKSIZE) + MOVI_BL1_BLKCNT + MOVI_ENV_BLKCNT)
		#endif
	#else
#define MOVI_UBOOT_POS		((eFUSE_SIZE / MOVI_BLKSIZE) + MOVI_BL1_BLKCNT + MOVI_ENV_BLKCNT)
	#endif
#else
#define MOVI_UBOOT_POS		(MOVI_LAST_BLKPOS - MOVI_BL1_BLKCNT - MOVI_BL2_BLKCNT - MOVI_ENV_BLKCNT)
#endif
#define MOVI_ROOTFS_BLKCNT	(PART_SIZE_ROOTFS / MOVI_BLKSIZE)

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
