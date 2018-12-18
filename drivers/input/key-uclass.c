/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <adc.h>
#include <dm.h>
#include <key.h>

static LIST_HEAD(key_list);

const char *evt_name[] = {
	"Not down",
	"Down",
	"Long down",
	"Not exist",
};

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

uint64_t key_timer(uint64_t base)
{
	uint64_t cntpct;

	cntpct = arch_counter_get_cntpct() / 24000UL;
	return (cntpct > base) ? (cntpct - base) : 0;
}

/*
 * What's simple and complex event mean?
 *
 * simple event:   key press down or none;
 * complext event: key press down, long down or none;
 */
static int key_read_adc_simple_event(struct input_key *key, unsigned int adcval)
{
	int max, min, margin = 30;
	int keyval;

	/* Get min, max */
	max = key->adcval + margin;
	if (key->adcval > margin)
		min = key->adcval - margin;
	else
		min = 0;

	debug("%s: '%s' configure adc=%d: range[%d~%d]; hw adcval=%d\n",
	      __func__, key->name, key->adcval, min, max, adcval);

	/* Check */
	if ((adcval <= max) && (adcval >= min)) {
		keyval = KEY_PRESS_DOWN;
		debug("%s key pressed..\n", key->name);
	} else {
		keyval = KEY_PRESS_NONE;
	}

	return keyval;
}

static int key_read_gpio_simple_event(struct input_key *key)
{
	if (!dm_gpio_is_valid(&key->gpio)) {
		printf("%s: invalid gpio\n", key->name);
		return KEY_PRESS_NONE;
	}

	return dm_gpio_get_value(&key->gpio) ? KEY_PRESS_DOWN : KEY_PRESS_NONE;
}

static int key_read_gpio_complex_event(struct input_key *key)
{
	int keyval;

	debug("%s: %s: up=%llu, down=%llu, delta=%llu\n",
	      __func__, key->name, key->up_t, key->down_t,
	      key->up_t - key->down_t);

	/* Possible this is machine power-on long pressed, so ignore this */
	if (key->down_t == 0 && key->up_t != 0) {
		keyval = KEY_PRESS_NONE;
		goto out;
	}

	if ((key->up_t > key->down_t) &&
	    (key->up_t - key->down_t) >= KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		keyval = KEY_PRESS_LONG_DOWN;
		debug("%s key long pressed..\n", key->name);
	} else if (key->down_t &&
		   key_timer(key->down_t) >= KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		keyval = KEY_PRESS_LONG_DOWN;
		debug("%s key long pressed(hold)..\n", key->name);
	} else if ((key->up_t > key->down_t) &&
		   (key->up_t - key->down_t) < KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		keyval = KEY_PRESS_DOWN;
		debug("%s key short pressed..\n", key->name);
	/* Possible in charge animation, we enable irq after fuel gauge updated */
	} else if (key->up_t && key->down_t && (key->up_t == key->down_t)){
		key->up_t = 0;
		key->down_t = 0;
		keyval = KEY_PRESS_DOWN;
		debug("%s key short pressed..\n", key->name);
	} else {
		keyval = KEY_PRESS_NONE;
	}

out:
	return keyval;
}

static int key_read_gpio_interrupt_event(struct input_key *key)
{
	debug("%s: %s\n", __func__, key->name);

	return key_read_gpio_complex_event(key);
}

int key_is_pressed(int keyval)
{
	return (keyval == KEY_PRESS_DOWN || keyval == KEY_PRESS_LONG_DOWN);
}

void key_add(struct input_key *key)
{
	if (!key)
		return;

	if (!key->parent) {
		printf("Err: Can't find key(code=%d) device\n", key->code);
		return;
	}

	key->pre_reloc = dev_read_bool(key->parent, "u-boot,dm-pre-reloc");
	list_add_tail(&key->link, &key_list);
}

static int __key_read(struct input_key *key)
{
	unsigned int adcval;
	int keyval = KEY_NOT_EXIST;
	int ret;

	/* Is a adc key? */
	if (key->type & ADC_KEY) {
		ret = adc_channel_single_shot("saradc",
					      key->channel, &adcval);
		if (ret)
			printf("%s: failed to read saradc, ret=%d\n",
			       key->name, ret);
		else
			keyval = key_read_adc_simple_event(key, adcval);
	/* Is a gpio key? */
	} else if (key->type & GPIO_KEY) {
		/* All pwrkey must register as an interrupt event */
		if (key->code == KEY_POWER)
			keyval = key_read_gpio_interrupt_event(key);
		else
			keyval = key_read_gpio_simple_event(key);
	} else {
		printf("%s: invalid key type!\n", __func__);
	}

	debug("%s: '%s'(code=%d) is %s\n",
	      __func__, key->name, key->code, evt_name[keyval]);

	return keyval;
}

int key_read(int code)
{
	struct udevice *dev;
	struct input_key *key;
	static int initialized;
	int keyval = KEY_NOT_EXIST;

	/* Initialize all key drivers */
	if (!initialized) {
		for (uclass_first_device(UCLASS_KEY, &dev);
		     dev;
		     uclass_next_device(&dev)) {
			debug("%s: have found key driver '%s'\n\n",
			      __func__, dev->name);
		}
	}

	/* The key from kernel dtb has higher priority */
	debug("Reading key from kernel\n");
	list_for_each_entry(key, &key_list, link) {
		if (key->pre_reloc || (key->code != code))
			continue;

		keyval = __key_read(key);
		if (key_is_pressed(keyval))
			return keyval;
	}

	/* If not found any key from kernel dtb, reading from U-Boot dtb */
	if (keyval == KEY_NOT_EXIST) {
		debug("Reading key from U-Boot\n");
		list_for_each_entry(key, &key_list, link) {
			if (!key->pre_reloc || (key->code != code))
				continue;

			keyval = __key_read(key);
			if (key_is_pressed(keyval))
				return keyval;
		}
	}

	return keyval;
}

UCLASS_DRIVER(key) = {
	.id		= UCLASS_KEY,
	.name		= "key",
};
