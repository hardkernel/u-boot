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
#if defined(CONFIG_MACH_ODROIDC2)
#include <usb.h>
#endif
#include <usb/fastboot.h>

static int do_fastboot(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret;

#if defined(CONFIG_MACH_ODROIDC2)
	/* Initiate USB device port for fastboot */
	if (board_usb_init(0, USB_INIT_DEVICE)) {
		error("Couldn't init USB controller.");
		return CMD_RET_FAILURE;
	}
#endif

	board_partition_init();

	g_dnl_clear_detach();
	ret = g_dnl_register("usb_dnl_fastboot");
	if (ret)
		return ret;

	fastboot_flash_dump_ptn();

	while (1) {
		if (g_dnl_detach())
			break;
		if (ctrlc())
			break;
		usb_gadget_handle_interrupts();
	}

	g_dnl_unregister();
	g_dnl_clear_detach();
	return CMD_RET_SUCCESS;
}

U_BOOT_CMD(
	fastboot,	1,	0,	do_fastboot,
	"use USB Fastboot protocol",
	"\n"
	"    - run as a fastboot usb device"
);
