/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _KEY_H_
#define _KEY_H_

#include <asm-generic/gpio.h>
#include <dt-bindings/input/linux-event-codes.h>

#define KEY_LONG_DOWN_MS	2000

enum {
	INVAL_KEY = 0x0,
	ADC_KEY   = 0x1,
	GPIO_KEY  = 0x2,
};

enum key_state {
	KEY_PRESS_NONE,	/* press without release */
	KEY_PRESS_DOWN,	/* press -> release */
	KEY_PRESS_LONG_DOWN,
	KEY_NOT_EXIST,
};

struct input_key {
	struct udevice *parent;
	struct list_head link;
	const char *name;
	u32 code;
	u8 type;

	/* ADC key */
	u32 adcval;
	u32 vref;
	u8 channel;

	/* GPIO key */
	u32 irq;
	struct gpio_desc gpio;

	/* Event */
	u64 up_t;
	u64 down_t;
};

struct dm_key_ops {
	const char *name;
};

/* Use it instead of get_timer() in key interrupt handler */
uint64_t key_timer(uint64_t base);

/* Reister you key to dm key framework */
void key_add(struct input_key *key);

/* Confirm if your key value is a press event */
int key_is_pressed(int keyval);

/* Read key */
int key_read(int code);

#endif
