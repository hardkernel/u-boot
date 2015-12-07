/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#include <linux/ctype.h>    /* isalpha, isdigit */
#include <linux/err.h>
#include <usb/fastboot.h>
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
	fastboot_ptentry *ptn = NULL;
	unsigned long addr, start, length;
	char cmd[128];

	if ((argc < 2) ||
			(strcmp(argv[1], "read") && strcmp(argv[1], "write")))
		goto err_usage;

	if (isstring(argv[2])) {
		if (argc < 5)
			goto err_usage;

		ptn = fastboot_flash_find_ptn(argv[2]);
		if (ptn == NULL) {
			printf("movi: not registered partition name, %s\n", argv[2]);
			goto err_usage;
		}

		start = ptn->start;
		length = ptn->length;
	} else {
		if (argc < 6)
			goto err_usage;

		start = simple_strtoul(argv[2], NULL, 16);
		length = simple_strtoul(argv[5], NULL, 16);
	}

	start += simple_strtoul(argv[3], NULL, 16);
	addr = simple_strtoul(argv[4], NULL, 16);

	if (argc >= 6) {
		length = simple_strtoul(argv[5], NULL, 16) / 512;
		if (0 == length) {
			printf("movi: zero-length is ignored.\n");
			return -EINVAL;
		}
	}

	sprintf(cmd, "mmc %s 0x%08x 0x%08x 0x%08x",
			argv[1], (unsigned int)addr, (unsigned int)start,
			(unsigned int)length);

	/* Accessing the storage by partition name */
	if (ptn)
		printf("movi: the partiton '%s' is %sing...\n", ptn->name, argv[1]);

	return run_command(cmd, 0);

err_usage:
	cmd_usage(cmdtp);
	return -EINVAL;
}

U_BOOT_CMD(
		movi,			7,		0,		do_movi,
		"Read/write command from/to SD/MMC for ODROID-C board",
		"<read|write> <parition|sector> <offset> <address> [<length>]\n"
		"    - read the partitoin/sector of storage to memory\n"
		"    - write the partiton/sector of storage from memory\n"
		"    - all parameters must be hexa-decimal only\n"
);

#define		_1GB_BLOCK_CNT  		(2*1024*1024)

/////////////////////////////////////////////////////////////////
int get_mmc_block_count(char *device_name)
{
	struct mmc *mmc;
	int block_count = 0;
	int dev_num;

	dev_num = simple_strtoul(device_name, NULL, 0);

	mmc = find_mmc_device(dev_num);
	if (!mmc)
	{
		printf("mmc/sd device is NOT founded.\n");
		return -1;
	}

	block_count = mmc->capacity / mmc->read_bl_len;

	return block_count;
}

static int do_get_mmc_size(cmd_tbl_t* cmdtp, int flag, int argc, char *const argv[])
{
	int total_block_count = 0;
	char   mmc_size[5];

	if ( argc == 2 )
	{
		total_block_count = get_mmc_block_count(argv[1]);
		memset(mmc_size, 0x00, sizeof(mmc_size));

		if 	(total_block_count > (200 * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 256);
		else if (total_block_count > (100 * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 128);
		else if (total_block_count > (50  * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 64);
		else if (total_block_count > (25  * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 32);
		else if (total_block_count > (10  * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 16);
		else if (total_block_count > (5   * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 8);
		else if (total_block_count > (3   * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 4);
		else if (total_block_count > (1   * _1GB_BLOCK_CNT))    sprintf(mmc_size, "%d", 2);
		else 							sprintf(mmc_size, "%d", 1);

		if (total_block_count < 0)  {
			printf("error total block count == 0\n");
			return -1;
		}
		setenv("mmc_size_gb", mmc_size);
	}
	else
	{
	           printf("Usage:\nget_mmc_size <device_num>\n");
	}
	return 0;
}

U_BOOT_CMD(
	get_mmc_size, 2, 0, do_get_mmc_size,
	"get_mmc_size\t- mmc size check for sd/mmc.\n",
	"env mmc_size_gb = 1, 2, 4, 8, 16, 32, 64, 128.\n"
	"get_mmc_size <device_num>\n"
);

/* vim: set ts=4 sw=4 tw=80: */
