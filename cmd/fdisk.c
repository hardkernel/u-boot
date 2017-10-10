/*
 * fdisk command to set up mbr based on odroid-n1 partitions
 *
 * Copyright (C) 2017 Hardkernel Co,. Ltd
 *   Joy Cho <joycho78@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <linux/errno.h>
#include <disk.h>

static int do_fdisk(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	if (0 == do_format())
		printf("fdisk success\n");

	return 0;
}

U_BOOT_CMD(
		fdisk,		1,		0,		do_fdisk,
		"make MBR based on odroid-n1 partition",
		"\n"
		"    - make MBR based on odroid-n1 partition"
);
