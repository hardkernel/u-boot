/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>

static int do_load_cfgload(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	ulong addr;
	char cmd[1024];
	int devno = getenv_ulong("devno", 10, 0);

	if (argc < 2) {
		addr = CONFIG_SYS_LOAD_ADDR;
		debug ("*  cfgload: default load address = 0x%08lx\n", addr);
	} else {
		addr = simple_strtoul(argv[1], NULL, 16);
		debug ("*  cfgload: cmdline image address = 0x%08lx\n", addr);
	}

	snprintf(cmd, sizeof(cmd), "fatload mmc %d:1 0x%08lx boot.ini; source 0x%08lx",
			devno, addr, addr);
	return run_command(cmd, 0);
}

U_BOOT_CMD(
		cfgload,		2,		0,		do_load_cfgload,
		"read 'boot.ini' from FAT partiton",
		"\n"
		"    - read boot.ini from the first partiton treated as FAT partiton"
);

/* vim: set ts=4 sw=4 tw=80: */
