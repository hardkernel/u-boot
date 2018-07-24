/*
 * Copyright (C) 2015-2018 Hardkernel Co,. Ltd
 *
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <linux/ctype.h>    /* isalpha, isdigit */
#include <linux/err.h>
#include <part.h>
#include <mmc.h>

static int isstring(const char *p)
{
	if (!isalpha(*p))
		return 0;

	++p;
	while (isalnum(*p))
		++p;

	return *p == '\0';
}

static int do_movi(cmd_tbl_t* cmdtp, int flag, int argc, char *const argv[])
{
	disk_partition_t info;
	ulong addr;
	lbaint_t start = 0, size = 0;
	char cmd[128] = { 0, };
	int ret;

	struct mmc *mmc = find_mmc_device(board_current_mmc());
	if (!mmc) {
		printf("failed to access valid storage mmc%d\n", board_current_mmc());
		return -ENODEV;
	}

	if ((argc < 2) ||
			(strcmp(argv[1], "read") && strcmp(argv[1], "write")))
		goto err_usage;

	if (isstring(argv[2])) {
		if (argc < 5)
			goto err_usage;

		ret = -EINVAL;
#if defined(CONFIG_MPT_PARTITION)
		ret = get_partition_info_mpt_by_name(&mmc->block_dev, argv[2], &info);
#else
#error No partition type is defined to run 'movi' command
#endif
		if (ret < 0) {
			printf("movi: not registered partition name, %s\n", argv[2]);
			goto err_usage;
		}
		start = info.start;
		size = info.size;
	} else {
		if (argc < 6)
			goto err_usage;

		start = simple_strtoul(argv[2], NULL, 16);
		size = simple_strtoul(argv[5], NULL, 16);
	}

	start += simple_strtoul(argv[3], NULL, 16);
	addr = simple_strtoul(argv[4], NULL, 16);

	if (argc >= 6) {
		ulong len = simple_strtoul(argv[5], NULL, 16);
		if (len == 0) {
			printf("movi: zero-length is ignored.\n");
			return -EINVAL;
		}

		size = len / 512;
		if (len % 512)
			size++;

		if (size > info.size)
			size = info.size;
	}

	sprintf(cmd, "mmc %s 0x%x 0x%x 0x%x",
			argv[1], (unsigned int)addr, (unsigned int)start,
			(unsigned int)size);

	/* Accessing the storage by partition name */
	printf("movi: the partiton '%s' is %sing...\n", info.name, argv[1]);

	return run_command(cmd, 0);

err_usage:
	cmd_usage(cmdtp);
	return -EINVAL;
}

U_BOOT_CMD(	movi,			7,		0,		do_movi,
		"Read/write command from/to SD/MMC for ODROID board",
		"<read|write> <partition|sector> <offset> <address> [<length>]\n"
		"    - <read|write>  the command to access the storage\n"
		"    - <offset>  the offset from the start of given partiton in lba\n"
		"    - <address>  the memory address to load/store from/to the storage device\n"
		"    - [<length>]  the size of the block to read/write in bytes\n"
		"    - all parameters must be hexa-decimal only\n"
);

/* vim: set ts=4 sw=4 tw=80: */
