/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <dm.h>
#include <errno.h>
#include <linux/input.h>
#include <rc.h>

#include "test-rockchip.h"

static int ir_test(void)
{
	int ret;
	ulong start;
	int last_keycode, last_repeat;
	int keycode, repeat;
	struct udevice *dev;

	printf("\nYou have 30s to test ir, press them, start!\n");

	ret = uclass_get_device(UCLASS_RC, 0, &dev);
	if (ret) {
		printf("get rc device failed: %d\n", ret);
		goto out;
	}

	keycode = rc_get_keycode(dev);
	if (keycode == -ENOSYS) {
		printf("ir_test: failed to bind driver\n");
		goto out;
	}

	last_keycode = KEY_RESERVED;
	last_repeat = KEY_RESERVED;
	start = get_timer(0);
	while (get_timer(start) <= 30000) {
		mdelay(100);

		keycode = rc_get_keycode(dev);
		repeat = rc_get_repeat(dev);
		if (keycode == KEY_RESERVED)
			continue;

		if (keycode != last_keycode || repeat != last_repeat) {
			printf("ir_test: press key:0x%x repeat:%d\n",
			       keycode, repeat);
			last_keycode = keycode;
			last_repeat = repeat;
		}
	}

	return 0;

out:
	return -EINVAL;
}

int board_ir_test(int argc, char * const argv[])
{
	return ir_test();
}
