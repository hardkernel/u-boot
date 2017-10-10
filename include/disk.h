/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 *   Dongjin Kim <tobetter@gmail.com>
 *
 * This driver has been modified to support ODROID-N1
 *   Modified by Joy Cho <joycho78@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef DISK_H
#define DISK_H

#include <common.h>
#include <command.h>
#include <environment.h>
#include <blk.h>

typedef struct disk_ptentry disk_ptentry;

/*
 * disk partitions entry
 */
struct disk_ptentry {
	char name[16];		/* partitin name, null terminated */
	unsigned int start;	/* start of partition, must be multiple of block
				   size */
	unsigned int length;	/* length of partiton, must be multiple of block
				   size in bytes */
	unsigned int flags;	/* partition details for control */
};

/*
 * disk functions
 */
void disk_flash_reset_ptn(void);
void disk_flash_add_ptn(disk_ptentry *ptn);
void disk_flash_dump_ptn(void);
unsigned int disk_flash_get_ptn_count(void);
disk_ptentry *disk_flash_find_ptn(const char *name);
disk_ptentry *disk_flash_get_ptn(unsigned n);
int disk_load_dos_partition(void);

int do_format(void);

int board_partition_init(void);
char *board_dos_partition_name(int part, char* name);
lbaint_t board_dos_partition_start(void);
lbaint_t board_dos_partition_next(int *part, u8* type);
__weak int board_disk_pre_flash(struct blk_desc *dev_desc, lbaint_t start,
		void *buffer);

#endif
