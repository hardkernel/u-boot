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
	KEY_NOT_EXIST,
};

struct dm_key_ops {
	int type;
	const char *name;
	int (*read)(struct udevice *dev, int code);
	int (*exist)(struct udevice *dev, int code);
};

struct input_key {
	const char *name;
	u32 code;
	u32 channel;
	u32 value;
	u32 margin;
	u32 vref;
	int flag;

	u32 irq;
	u64 up_t;
	u64 down_t;
};

uint64_t key_get_timer(uint64_t base);
int platform_key_read(int code);

#endif
