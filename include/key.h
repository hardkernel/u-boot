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

enum key_event {
	KEY_PRESS_NONE,	/* press without release */
	KEY_PRESS_DOWN,	/* press -> release */
	KEY_PRESS_LONG_DOWN,
	KEY_NOT_EXIST,
};

struct dm_key_uclass_platdata {
	const char *name;
	bool pre_reloc;
	u32 code;
	u8 type;

	/* ADC key */
	u8 channel;
	u32 adcval;
	u32 min;
	u32 max;

	/* GPIO key */
	u32 irq;
	u32 gpios[2];
	struct gpio_desc gpio;

	u64 rise_ms;
	u64 fall_ms;
};

/* Use it instead of get_timer() in key interrupt handler */
uint64_t key_timer(uint64_t base);

/* Confirm if your key value is a press event */
int key_is_pressed(int keyval);

/* Read key */
int key_read(int code);

int key_bind_children(struct udevice *dev, const char *drv_name);

#endif
