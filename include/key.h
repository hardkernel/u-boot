/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _KEY_H_
#define _KEY_H_

enum key_state {
	KEY_PRESS_NONE,
	KEY_PRESS_UP,
	KEY_PRESS_DOWN,
};

struct dm_key_ops {
	int (*read)(struct udevice *dev);
};

int key_read(struct udevice *dev);

#endif
