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

#include <common.h>
#include <asm/arch/movi_partition.h>

#ifdef DEBUG_MOVI_PARTITION
#define dbg(x...)       printf(x)
#else
#define dbg(x...)       do { } while (0)
#endif

raw_area_t raw_area_control;

int init_raw_area_table(block_dev_desc_t * dev_desc, int location)
{	
	int i;
	member_t *image;
	u32 capacity;
	
	/* init raw_area will be 16MB */
	raw_area_control.start_blk = 16*1024*1024/MOVI_BLKSIZE;
	raw_area_control.next_raw_area = 0;
	strcpy(raw_area_control.description, "initial raw table");

	image = raw_area_control.image;

#if defined(CONFIG_EVT1) && defined(CONFIG_S5PC110)
	#if defined(CONFIG_SECURE_BOOT) || defined(CONFIG_SECURE_BL1_ONLY)
	/* image 0 should be fwbl1 */
	image[0].start_blk = location;
	image[0].used_blk = MOVI_FWBL1_BLKCNT;
	image[0].size = FWBL1_SIZE;
	image[0].attribute = 0x0;
	strcpy(image[0].description, "fwbl1");
	dbg("fwbl1: %d\n", image[0].start_blk);
	#endif
#endif

	/* image 1 should be bl2 */
#if defined(CONFIG_EVT1) && defined(CONFIG_S5PC110)
	#if defined(CONFIG_SECURE_BOOT) || defined(CONFIG_SECURE_BL1_ONLY)
	image[1].start_blk = image[0].start_blk + MOVI_FWBL1_BLKCNT;
	#else
	image[1].start_blk = location;
	#endif
#else
	image[1].start_blk = capacity - (eFUSE_SIZE/MOVI_BLKSIZE) - MOVI_BL1_BLKCNT;
#endif
	image[1].used_blk = MOVI_BL1_BLKCNT;
	image[1].size = SS_SIZE;
	#if defined(CONFIG_SECURE_BOOT)
	image[1].attribute = 0x3;
	#else
	image[1].attribute = 0x1;
	#endif
	strcpy(image[1].description, "u-boot parted");
	dbg("bl1: %d\n", image[1].start_blk);

	/* image 2 should be environment */
#if defined(CONFIG_EVT1) && defined(CONFIG_S5PC110)
	image[2].start_blk = image[1].start_blk + MOVI_BL1_BLKCNT;
#else
	image[2].start_blk = image[1].start_blk - MOVI_ENV_BLKCNT;
#endif
	image[2].used_blk = MOVI_ENV_BLKCNT;
	image[2].size = CONFIG_ENV_SIZE;
	image[2].attribute = 0x10;
	strcpy(image[2].description, "environment");
	dbg("env: %d\n", image[2].start_blk);

	/* image 3 should be u-boot */
#if defined(CONFIG_EVT1) && defined(CONFIG_S5PC110)
	#if defined(CONFIG_EMMC)
	image[3].start_blk = image[2].start_blk;
	#else
	image[3].start_blk = image[2].start_blk + MOVI_ENV_BLKCNT;
	#endif
#else
	image[3].start_blk = image[2].start_blk - MOVI_BL2_BLKCNT;
#endif
	image[3].used_blk = MOVI_BL2_BLKCNT;
	image[3].size = PART_SIZE_BL;
	image[3].attribute = 0x2;
	strcpy(image[3].description, "u-boot");
	dbg("bl2: %d\n", image[3].start_blk);

	/* image 4 should be kernel */
#if defined(CONFIG_EVT1) && defined(CONFIG_S5PC110)
	image[4].start_blk = image[3].start_blk + MOVI_BL2_BLKCNT;
#else
	image[4].start_blk = image[3].start_blk - MOVI_ZIMAGE_BLKCNT;
#endif
	image[4].used_blk = MOVI_ZIMAGE_BLKCNT;
	image[4].size = PART_SIZE_KERNEL;
	image[4].attribute = 0x4;
	strcpy(image[4].description, "kernel");
	dbg("knl: %d\n", image[4].start_blk);

	/* image 5 should be RFS */
#if defined(CONFIG_EVT1) && defined(CONFIG_S5PC110)
	image[5].start_blk = image[4].start_blk + MOVI_ZIMAGE_BLKCNT;
#else
	image[5].start_blk = image[4].start_blk - MOVI_ROOTFS_BLKCNT;
#endif
	image[5].used_blk = MOVI_ROOTFS_BLKCNT;
	image[5].size = PART_SIZE_ROOTFS;
	image[5].attribute = 0x8;
	strcpy(image[5].description, "rfs");
	dbg("rfs: %d\n", image[5].start_blk);

	for (i=6; i<15; i++) {
		raw_area_control.image[i].start_blk = 0;
		raw_area_control.image[i].used_blk = 0;
	}
}

