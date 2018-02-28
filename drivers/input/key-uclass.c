/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <dm.h>
#include <key.h>
#include <common.h>
#include <dm.h>

static inline uint64_t arch_counter_get_cntpct(void)
{
	uint64_t cval = 0;

	isb();
#ifdef CONFIG_ARM64
	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
#else
	asm volatile ("mrrc p15, 0, %Q0, %R0, c14" : "=r" (cval));
#endif
	return cval;
}

uint64_t key_get_timer(uint64_t base)
{
	uint64_t cntpct;

	cntpct = arch_counter_get_cntpct() / 24000UL;
	return (cntpct > base) ? (cntpct - base) : 0;
}

static int key_state_valid(int state)
{
	return (state >= KEY_PRESS_NONE && state < KEY_NOT_EXIST);
}

static int key_read(struct udevice *dev, int code)
{
	const struct dm_key_ops *ops = dev_get_driver_ops(dev);

	if (!ops || !ops->read)
		return -ENOSYS;

	return ops->read(dev, code);
}

int key_parse_adc_event(struct input_key *key, unsigned int adcval)
{
	int report = KEY_NOT_EXIST;
	int max, min;

	debug("%s: %s: max=%d, min=%d, adcval=%d\n",
	      __func__, key->name, max, min, adcval);

	/* Get min, max */
	max = key->value + key->margin;
	if (key->value > key->margin)
		min = key->value - key->margin;
	else
		min = key->value;

	/* Check */
	if ((adcval <= max) && (adcval >= min)) {
		report = KEY_PRESS_DOWN;
		printf("%s key pressed..\n", key->name);
	} else {
		report = KEY_PRESS_NONE;
	}

	return report;
}

int key_parse_gpio_event(struct input_key *key)
{
	u32 report = KEY_NOT_EXIST;

	debug("%s: %s: up=%llu, down=%llu, delta=%llu\n",
	      __func__, key->name, key->up_t, key->down_t,
	      key->up_t - key->down_t);

	/* Possible this is machine power-on long pressed, so ignore this */
	if (key->down_t == 0 && key->up_t != 0) {
		report = KEY_PRESS_NONE;
		goto out;
	}

	if ((key->up_t > key->down_t) &&
	    (key->up_t - key->down_t) >= KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		report = KEY_PRESS_LONG_DOWN;
		printf("%s key long pressed(hold)..\n", key->name);
	} else if (key->down_t &&
		   key_get_timer(key->down_t) >= KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		report = KEY_PRESS_LONG_DOWN;
		printf("%s key long pressed..\n", key->name);
	} else if ((key->up_t > key->down_t) &&
		   (key->up_t - key->down_t) < KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		report = KEY_PRESS_DOWN;
		printf("%s key short pressed..\n", key->name);
	} else {
		report = KEY_PRESS_NONE;
	}

out:
	return report;
}

int platform_key_read(int code)
{
	struct udevice *dev;
	int report = KEY_NOT_EXIST;

	for (uclass_first_device(UCLASS_KEY, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		debug("key dev.name = %s, code = %d\n", dev->name, code);
		report = key_read(dev, code);
		if (key_state_valid(report)) {
			debug("key dev.name = %s, state=%d\n", dev->name, report);
			break;
		}
	}

	return report;
}

UCLASS_DRIVER(key) = {
	.id		= UCLASS_KEY,
	.name		= "key",
};
