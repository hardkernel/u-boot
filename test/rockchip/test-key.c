/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <asm/io.h>
#include <common.h>
#include <console.h>
#include <dm.h>
#include <key.h>
#include <linux/input.h>
#include "test-rockchip.h"

int board_key_test(int argc, char * const argv[])
{
	while (!ctrlc()) {
		mdelay(100);
		platform_key_read(KEY_VOLUMEUP);
		platform_key_read(KEY_VOLUMEDOWN);
		platform_key_read(KEY_POWER);
		platform_key_read(KEY_HOME);
		platform_key_read(KEY_MENU);
		platform_key_read(KEY_ESC);
	}

	return 0;
}
