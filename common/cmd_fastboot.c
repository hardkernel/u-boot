/*
 * Copyright 2008 - 2009 Windriver, <www.windriver.com>
 * Author: Tom Rix <Tom.Rix@windriver.com>
 *
 * (C) Copyright 2014 Linaro, Ltd.
 * Rob Herring <robh@kernel.org>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#include <common.h>
#include <command.h>
#include <g_dnl.h>
#include <mmc.h>

#if defined(CONFIG_ODROID_COMMON)
extern int board_partition_list(void);
#endif

static int do_fastboot(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret;

#if defined(CONFIG_ODROID_COMMON)
	board_partition_list();

	int mmc_dev = board_current_mmc();
	struct mmc *mmc = find_mmc_device(mmc_dev);
	if (mmc == NULL)
		return -ENODEV;
	block_dev_desc_t *dev_desc = &mmc->block_dev;
#endif

#ifdef CONFIG_MPT_PARTITION
	if (test_part_mpt(dev_desc) == 0) {
		printf("%s() %d: PART_TYPE_MPT\n", __func__, __LINE__);
		dev_desc->part_type = PART_TYPE_MPT;
	}
#endif

	g_dnl_clear_detach();
	ret = g_dnl_register("usb_dnl_fastboot");
	if (ret)
		return ret;

	while (1) {
		if (g_dnl_detach())
			break;
		if (ctrlc())
			break;
		usb_gadget_handle_interrupts();
	}

	g_dnl_unregister();
	g_dnl_clear_detach();

#ifdef CONFIG_DOS_PARTITION
	if (test_part_dos(dev_desc) == 0) {
		printf("%s() %d: PART_TYPE_DOS\n", __func__, __LINE__);
		dev_desc->part_type = PART_TYPE_DOS;
	}
#endif

	return CMD_RET_SUCCESS;
}

U_BOOT_CMD(
	fastboot,	1,	0,	do_fastboot,
	"use USB Fastboot protocol",
	"\n"
	"    - run as a fastboot usb device"
);
