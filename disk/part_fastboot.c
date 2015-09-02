/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <malloc.h>
#include <usb/fastboot.h>
#include <linux/usb/ch9.h>
#include <linux/usb/gadget.h>
#include <environment.h>
#include <mmc.h>
#include <dfu.h>
#include <part_dos.h>

#define NR_PARTITIONS		4

static struct mmc *mmc = NULL;

static block_dev_desc_t *fastboot_block_dev(void)
{
#if defined(CONFIG_FASTBOOT_FLASH_MMC_DEV)
	if (mmc == NULL)
		mmc = find_mmc_device(CONFIG_FASTBOOT_FLASH_MMC_DEV);

	if (mmc == NULL) {
		printf("fastboot: no mmc device at slot %d", CONFIG_FASTBOOT_FLASH_MMC_DEV);
		return NULL;
	}

	if (&mmc->block_dev == NULL) {
		printf("fastboot: block device mmc %d not supported\n",
				CONFIG_FASTBOOT_FLASH_MMC_DEV);
	}

	return &mmc->block_dev;
#else
	return NULL;
#endif
}

static void print_fastboot_dev(void)
{
	if (mmc) {
		printf("fastboot: mmc capacity is: %llu\n", mmc->capacity);
		printf("fastboot: number of blocks:%lu\n", mmc->block_dev.lba);
		printf("fastboot: block size:%lu\n", mmc->block_dev.blksz);
	}
}

int fastboot_load_dos_partition(void)
{
	int n;
	int nr_parts = 0;
	block_dev_desc_t *dev_desc = fastboot_block_dev();

	if (dev_desc == NULL)
		return -EIO;

	for (n = 1; n <= NR_PARTITIONS; n++) {
		fastboot_ptentry ptn;
		disk_partition_t part_info;

		if (get_partition_info(dev_desc, n, &part_info))
			continue;

		if (board_dos_partition_name(n, ptn.name) == NULL)
			sprintf(ptn.name, "part-%d", n);

		ptn.start = part_info.start;
		ptn.length = part_info.size;

		fastboot_flash_add_ptn(&ptn);
		nr_parts++;
	}

	return nr_parts;
}

static void dos_partition_entry(dos_partition_t *part,
		u32 start, u32 size, u8 type)
{
	part->boot_ind = 0x00;
	part->head = 0;
	part->sector = 1;
	part->cyl = 1;
	part->sys_ind = type;
	part->end_head = 0;
	part->end_sector = 0;
	part->end_cyl = 0;

	u32 *p = (u32 *)part->start4;
	*p = start;
	p = (u32 *)part->size4;
	*p = size;
}

int do_format(void)
{
	u8 mbr[512];
	lbaint_t next;
	int n;
	block_dev_desc_t *dev_desc = fastboot_block_dev();

	/* Read the first sector, MBR, to buffer */
	if (dev_desc && dev_desc->block_read(dev_desc->dev, 0, 1, mbr) != 1) {
		printf("fastboot: can't read MBR from device %d\n",
				dev_desc->dev);
		return -EIO;
	}

	/* Initiate MBR sector for parititons and its type */
	memset(mbr + 0x1be, 0, sizeof(dos_partition_t) * NR_PARTITIONS);
	mbr[0x1fe] = 0x55;
	mbr[0x1ff] = 0xaa;

	print_fastboot_dev();

	next = board_dos_partition_start();

	for (n = 1; n <= NR_PARTITIONS; n++) {
		lbaint_t sz = 0;
		int part;
		u8 type;
		dos_partition_t *ptn;

		sz = board_dos_partition_next(&part, &type);
		if (sz == 0)
			continue;

		if (sz == -1)
			sz = dev_desc->lba - next;

		ptn = (dos_partition_t*)(mbr + 0x1be
			+ (sizeof(dos_partition_t) * (part - 1)));

		dos_partition_entry(ptn, next, sz, type);

		next += sz;
	}

	/* Write the MBR with new partition details */
	if (dev_desc->block_write(dev_desc->dev, 0, 1, mbr) != 1) {
		printf("fastboot: can't write MBR to device %d\n",
				dev_desc->dev);
		return -EIO;
	}

	return 0;
}
