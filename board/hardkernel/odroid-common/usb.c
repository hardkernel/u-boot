/*
 * board/hardkernel/odroid-common/usb.c
 *
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>

static int __usbhost_early_power = 0;

int board_usbhost_early_power(void)
{
	return __usbhost_early_power;
}

int usbhost_early_poweron(void)
{
	__usbhost_early_power = 1;

	run_command("usb start", 0);
	/* TODO: do something here */
	run_command("usb stop", 0);

	__usbhost_early_power = 0;

	return 0;
}


