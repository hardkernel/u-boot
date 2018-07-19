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
	int i, ret;
	u32 key_code[] = {
		KEY_VOLUMEUP,
		KEY_VOLUMEDOWN,
		KEY_POWER,
		KEY_MENU,
		KEY_ESC,
		KEY_HOME,
	};
	const char *key_name[] = {
		"volume up",
		"volume down",
		"power",
		"menu",
		"esc",
		"home",
	};

	while (!ctrlc()) {
		for (i = 0; i < ARRAY_SIZE(key_code); i++) {
			mdelay(20);
			ret = key_read(key_code[i]);
			if (ret == KEY_PRESS_DOWN)
				printf("'%s' key pressed...\n", key_name[i]);
			else if (ret == KEY_PRESS_LONG_DOWN)
				printf("'%s' key long pressed...\n", key_name[i]);
		}
	}

	return 0;
}
