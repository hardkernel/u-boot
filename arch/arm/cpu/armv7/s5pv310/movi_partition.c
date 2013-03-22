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

	/* init raw_area will be 16MB */
	raw_area_control.start_blk = 16*1024*1024/MOVI_BLKSIZE;
	raw_area_control.next_raw_area = 0;
	strcpy(raw_area_control.description, "initial raw table");

	image = raw_area_control.image;

	/* For eMMC partition BLOCK Change*/

	/* image 0 should be fwbl1 */
	image[0].start_blk = location;
	image[0].used_blk = MOVI_FWBL1_BLKCNT;
	image[0].size = PART_SIZE_FWBL1;
	image[0].attribute = 0x0;
	strcpy(image[0].description, "fwbl1");
	dbg("fwbl1: %d\n", image[0].start_blk);

	/* image 1 should be bl1 */
	image[1].start_blk = image[0].start_blk + MOVI_FWBL1_BLKCNT;
	image[1].used_blk = MOVI_BL1_BLKCNT;
	image[1].size = PART_SIZE_BL1;
	image[1].attribute = 0x1;
	strcpy(image[1].description, "u-boot parted");
	dbg("iram block: %d\n", image[1].start_blk);

	/* image 2 should be u-boot */
	image[2].start_blk = image[1].start_blk + MOVI_BL1_BLKCNT;
	image[2].used_blk = MOVI_UBOOT_BLKCNT;
	image[2].size = PART_SIZE_UBOOT;
	image[2].attribute = 0x2;
	strcpy(image[2].description, "u-boot");
	dbg("u-boot: %d\n", image[2].start_blk);

	/* image 3 should be TrustZone S/W */
	image[3].start_blk = image[2].start_blk + MOVI_UBOOT_BLKCNT;
	image[3].used_blk = MOVI_TZSW_BLKCNT;
	image[3].size = PART_SIZE_TZSW;
	image[3].attribute = 0x9;
	strcpy(image[3].description, "TrustZone S/W");
	dbg("TrustZone S/W: %d\n", image[3].start_blk);

	/* image 4 should be environment */
	image[4].start_blk = image[3].start_blk + MOVI_TZSW_BLKCNT;
	image[4].used_blk = MOVI_ENV_BLKCNT;
	image[4].size = CONFIG_ENV_SIZE;
	image[4].attribute = 0x10;
	strcpy(image[4].description, "environment");
	dbg("env: %d\n", image[4].start_blk);


	/* For eMMC partition BLOCK Change*/
	if (location == 0)
		image[4].start_blk = image[3].start_blk + 1;

	/* image 5 should be kernel */
	image[5].start_blk = image[4].start_blk + MOVI_ENV_BLKCNT;
	image[5].used_blk = MOVI_ZIMAGE_BLKCNT;
	image[5].size = PART_SIZE_KERNEL;
	image[5].attribute = 0x4;
	strcpy(image[5].description, "kernel");
	dbg("knl: %d\n", image[5].start_blk);

	/* image 6 should be RFS */
	image[6].start_blk = image[5].start_blk + MOVI_ZIMAGE_BLKCNT;
	image[6].used_blk = MOVI_ROOTFS_BLKCNT;
	image[6].size = PART_SIZE_ROOTFS;
	image[6].attribute = 0x8;
	strcpy(image[6].description, "rfs");
	dbg("rfs: %d\n", image[6].start_blk);

	/* image 7 should be bl2 */
	image[7].start_blk = image[0].start_blk + MOVI_FWBL1_BLKCNT;
	image[7].used_blk = MOVI_BL1_BLKCNT;
	image[7].size = PART_SIZE_BL1;
	image[7].attribute = 0x3;
	strcpy(image[7].description, "bl2");
	dbg("bl2: %d\n", image[7].start_blk);

	for (i=8; i<15; i++) {
		raw_area_control.image[i].start_blk = 0;
		raw_area_control.image[i].used_blk = 0;
	}
}

