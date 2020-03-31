/*
 * ODROID cfgload command to load boot.ini from FAT partiton
 *
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 *   Dongjin Kim <tobetter@gmail.com>
 *
 * This driver has been modified to support ODROID-N1.
 *   Modified by Joy Cho <joycho78@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <fs.h>

static int do_load_cfgload(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	ulong addr;
	char cmd[256];
	const char *scripts[] = {
		"boot.ini",
		"boot.scr",
	};
	int i;

	if (argc < 2) {
		addr = CONFIG_SYS_LOAD_ADDR;
		debug("cfgload: default load address = 0x%08lx\n", addr);
	} else {
		addr = simple_strtoul(argv[1], NULL, 16);
		debug("cfgload: cmdline image address = 0x%08lx\n", addr);
	}

	for (i = 0; i < ARRAY_SIZE(scripts); i++) {
		if (file_exists("mmc", "1", scripts[i], FS_TYPE_ANY)) {
			snprintf(cmd, sizeof(cmd),
				"load mmc 1:1 0x%08lx %s; source 0x%08lx",
				addr, scripts[i], addr);
			if (run_command(cmd, 0) == 0)
				return 0;
		}
	}

	return -1;
}

U_BOOT_CMD(
		cfgload,		1,		0,		do_load_cfgload,
		"read 'boot.ini' from FAT partiton",
		"\n"
		"    - read boot.ini from the first partiton treated as FAT partiton"
);
