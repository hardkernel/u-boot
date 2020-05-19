/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <errno.h>
#include <malloc.h>
#include <linux/sizes.h>

static int do_load_cfgload(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	int i, n, devno = 0;
	char* scripts[] = {
		"/boot.ini",
		"/boot/boot.ini",
		"/boot.scr",
	};

	ulong addr;
	char cmd[1024];

	if (argc < 2) {
		addr = CONFIG_SYS_LOAD_ADDR;
		debug ("*  cfgload: default load address = 0x%08lx\n", addr);
	} else {
		addr = simple_strtoul(argv[1], NULL, 16);
		debug ("*  cfgload: cmdline image address = 0x%08lx\n", addr);
	}

	setenv("devtype", "mmc");
	setenv("devnum", simple_itoa(devno));
	setenv("devno", simple_itoa(devno));

	for (i = 1; i <= 2; i++) {
		setenv("partition", simple_itoa(i));
		for (n = 0; n < ARRAY_SIZE(scripts); n++) {
			snprintf(cmd, sizeof(cmd),
					"load mmc %d:%d 0x%08lx %s; source 0x%08lx",
					devno, i, addr, scripts[n], addr);
			run_command(cmd, 0);
		}
	}

	return 1;
}

U_BOOT_CMD(
		cfgload,		2,		0,		do_load_cfgload,
		"read 'boot.ini' from FAT partiton",
		"\n"
		"    - read boot.ini from the first partiton treated as FAT partiton"
);

/* vim: set ts=4 sw=4 tw=80: */
