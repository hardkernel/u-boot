/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 *   Dongjin Kim <tobetter@gmail.com>
 *
 * This driver has been modified to support ODROID-N1
 *   Modified by Joy Cho <joycho78@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <malloc.h>
#include <disk.h>
#include <environment.h>
#include <mmc.h>
#include <dfu.h>
#include "part_dos.h"

#define NR_PARTITIONS		4

static struct mmc *mmc = NULL;
static u32 boot_devno;

static void print_disk_info(struct blk_desc *dev_desc)
{
	if (mmc) {
		printf("mmc capacity is: %llu\n", mmc->capacity);
		printf("number of blocks:%lu\n", dev_desc->lba);
		printf("block size:%lu\n", dev_desc->blksz);
	}
}

int disk_load_dos_partition(void)
{
	int n;
	int nr_parts = 0;
	struct blk_desc *dev_desc;

	if (mmc == NULL)
		mmc = find_mmc_device(boot_devno);

	if (mmc == NULL) {
		printf("disk: no mmc device at slot %d", boot_devno);
		return -EIO;
	}

	dev_desc = blk_get_dev("mmc", boot_devno);
	if (!dev_desc || dev_desc->type == DEV_TYPE_UNKNOWN) {
		error("invalid mmc device");
		return -EIO;
	}

	for (n = 1; n <= NR_PARTITIONS; n++) {
		disk_ptentry ptn;
		disk_partition_t part_info;

		if (part_get_info(dev_desc, n, &part_info))
			continue;

		if (board_dos_partition_name(n, ptn.name) == NULL)
			sprintf(ptn.name, "part-%d", n);

		ptn.start = part_info.start;
		ptn.length = part_info.size;

		disk_flash_add_ptn(&ptn);
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
	struct blk_desc *dev_desc;

	if (mmc == NULL)
		mmc = find_mmc_device(boot_devno);

	if (mmc == NULL) {
		printf("disk: no mmc device at slot %d\n", boot_devno);
		return -EIO;
	}

	dev_desc = blk_get_dev("mmc", boot_devno);
	if (!dev_desc || dev_desc->type == DEV_TYPE_UNKNOWN) {
		error("invalid mmc device");
		return -EIO;
	}

	/* Read the first sector, MBR, to buffer */
	if (dev_desc && blk_dread(dev_desc, 0, 1, mbr) != 1) {
		printf("disk: can't read MBR from device %d\n",
				dev_desc->devnum);
		return -EIO;
	}

	/* Initiate MBR sector for parititons and its type */
	memset(mbr + 0x1be, 0, sizeof(dos_partition_t) * NR_PARTITIONS);
	mbr[0x1fe] = 0x55;
	mbr[0x1ff] = 0xaa;

	print_disk_info(dev_desc);

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
	if (blk_dwrite(dev_desc, 0, 1, mbr) != 1) {
		printf("disk: can't write MBR to device %d\n",
				dev_desc->devnum);
		return -EIO;
	}

	return 0;
}

#define FASTBOOT_MAXPENTRY		16

static disk_ptentry ptable[FASTBOOT_MAXPENTRY];
static unsigned int pcount;

void disk_flash_reset_ptn(void)
{
	pcount = 0;

	/* Get boot storage device number */
	boot_devno = getenv_ulong("bootdev", 10, 0);
}

void disk_flash_add_ptn(disk_ptentry *ptn)
{
	if (pcount < FASTBOOT_MAXPENTRY) {
		memcpy((ptable + pcount), ptn, sizeof(*ptn));
		pcount++;
	}
}

disk_ptentry *disk_flash_find_ptn(const char *name)
{
	unsigned int n;

	for (n = 0; n < pcount; n++) {
		/* Make sure a substring is not accepted */
		if (strlen(name) == strlen(ptable[n].name)) {
			if (0 == strcmp(ptable[n].name, name))
				return ptable + n;
		}
	}
	return 0;
}

void disk_flash_dump_ptn(void)
{
	unsigned int n;

	for (n = 0; n < pcount; n++) {
		disk_ptentry *ptn = ptable + n;
		printf("ptn %d name='%s'", n, ptn->name);
		printf(" start=%d len=%d\n", ptn->start, ptn->length);
	}
}
