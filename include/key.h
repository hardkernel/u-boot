/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _KEY_H_
#define _KEY_H_

#define KEY_LONG_DOWN_MS	2000

enum key_state {
	KEY_PRESS_NONE,
	KEY_PRESS_UP,
	KEY_PRESS_DOWN,
	KEY_PRESS_LONG_DOWN,
};

struct dm_key_ops {
	int type;
	const char *name;
	int (*read)(struct udevice *dev);
};

int key_read(struct udevice *dev);
int key_type(struct udevice *dev);
const char *key_label(struct udevice *dev);

#endif
