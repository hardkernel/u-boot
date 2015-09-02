/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef FASTBOOT_H
#define FASTBOOT_H

#include <common.h>
#include <command.h>
#include <environment.h>
#include <linux/usb/ch9.h>
#include <linux/usb/gadget.h>

#ifdef CONFIG_CMD_FASTBOOT

typedef struct fastboot_ptentry fastboot_ptentry;

/*
 * fastboot partitions entry
 */
struct fastboot_ptentry {
	char name[16];		/* partitin name, null terminated */
	unsigned int start;	/* start of partition, must be multiple of block
				   size */
	unsigned int length;	/* length of partiton, must be multiple of block
				   size in bytes */
	unsigned int flags;	/* partition details for control */
};

/* Lower byte shows if the read/write/erase operation in
   repeated.  The base address is incremented.
   Either 0 or 1 is ok for a default */

#define FASTBOOT_PTENTRY_FLAGS_REPEAT_MASK(n)		(n & 0x0f)
#define FASTBOOT_PTENTRY_FLAGS_REPEAT_4			0x00000004

/* Writes happen a block at a time.
   If the write fails, go to next block
   NEXT_GOOD_BLOCK and CONTIGOUS_BLOCK can not both be set */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_NEXT_GOOD_BLOCK	0x00000010

/* Find a contiguous block big enough for a the whole file
   NEXT_GOOD_BLOCK and CONTIGOUS_BLOCK can not both be set */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_CONTIGUOUS_BLOCK	0x00000020

/* Sets the ECC to software before writing
   HW and SW ECC should not both be set. */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_SW_ECC		0x00000040

/* Sets the ECC to hardware before writing
   HW and SW ECC should not both be set. */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_HW_ECC		0x00000080

/* Sets the ECC to hardware before writing
   HW and SW ECC should not both be set. */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_HW_BCH4_ECC	0x00000100

/* Sets the ECC to hardware before writing
   HW and SW ECC should not both be set. */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_HW_BCH8_ECC	0x00000200

/* Sets the ECC to hardware before writing
   HW and SW ECC should not both be set. */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_HW_BCH16_ECC	0x00000400

/* Write the file with write.i */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_I			0x00000800

/* Write the file with write.jffs2 */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_JFFS2		0x00001000

/* Write the file as a series of variable/value pairs
   using the setenv and saveenv commands */
#define FASTBOOT_PTENTRY_FLAGS_WRITE_ENV		0x00002000

/*
 * Fastboot tool functions
 */
void fastboot_flash_reset_ptn(void);
void fastboot_flash_add_ptn(fastboot_ptentry *ptn);
void fastboot_flash_dump_ptn(void);
unsigned int fastboot_flash_get_ptn_count(void);
fastboot_ptentry *fastboot_flash_find_ptn(const char *name);
fastboot_ptentry *fastboot_flash_get_ptn(unsigned n);
int fastboot_load_dos_partition(void);

int do_format(void);

int board_partition_init(void);
char *board_dos_partition_name(int part, char* name);
lbaint_t board_dos_partition_start(void);
lbaint_t board_dos_partition_next(int *part, u8* type);
__weak int board_fastboot_pre_flash(block_dev_desc_t *dev_desc, lbaint_t start,
		void *buffer);

#endif
#endif
