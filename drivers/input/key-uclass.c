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
