/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <dm.h>
#include <irq-generic.h>
#include "irq-gpio-switch.h"

static struct gpio_bank gpio_banks[GPIO_BANK_NUM] = {
#if GPIO_BANK_NUM >= 1
	GPIO_BANK_REGISTER(0, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 2
	GPIO_BANK_REGISTER(1, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 3
	GPIO_BANK_REGISTER(2, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 4
	GPIO_BANK_REGISTER(3, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 5
	GPIO_BANK_REGISTER(4, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 6
	GPIO_BANK_REGISTER(5, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 7
	GPIO_BANK_REGISTER(6, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 8
	GPIO_BANK_REGISTER(7, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 9
	GPIO_BANK_REGISTER(8, GPIO_BANK_PINS),
#endif
#if GPIO_BANK_NUM >= 10
	GPIO_BANK_REGISTER(9, GPIO_BANK_PINS),
#endif
};

static int gpio_is_valid(u32 gpio)
{
	if ((gpio == EINVAL_GPIO) || !GPIO_BANK_VALID(gpio) ||
	    !GPIO_PIN_VALID(gpio)) {
		printf("gpio = 0x%x is not valid!\n", gpio);
		return 0;
	}

	return 1;
}

static int _hard_gpio_to_irq(u32 gpio)
{
	int idx, bank = 0, pin = 0;

	if (!gpio_is_valid(gpio))
		return -EINVAL;

	bank = (gpio & GPIO_BANK_MASK) >> GPIO_BANK_OFFSET;
	pin = (gpio & GPIO_PIN_MASK) >> GPIO_PIN_OFFSET;

	for (idx = 0; idx < ARRAY_SIZE(gpio_banks); idx++) {
		if (gpio_banks[idx].id == bank)
			return (gpio_banks[idx].irq_base + pin);
	}

	return -EINVAL;
}

static int _irq_to_gpio(int irq)
{
	int bank, pin, idx;

	bank = (irq - PIN_BASE) / GPIO_BANK_PINS;
	pin = (irq - PIN_BASE) % GPIO_BANK_PINS;

	for (idx = 0; idx < ARRAY_SIZE(gpio_banks); idx++) {
		if (gpio_banks[idx].id == bank) {
			return (bank << GPIO_BANK_OFFSET) |
				(pin << GPIO_PIN_OFFSET);
		}
	}

	return -EINVAL;
}

int gpio_to_irq(struct gpio_desc *gpio)
{
	int irq_gpio, bank;
	bool found;
	char *name;

	if (!gpio->dev->name) {
		printf("can't find device name for the gpio bank\n");
		return EINVAL_GPIO;
	}

	name = strtok((char *)gpio->dev->name, "@");
	if (!name) {
		printf("can't find correct device name for the gpio bank\n");
		return EINVAL_GPIO;
	}

	for (bank = 0; bank < ARRAY_SIZE(gpio_banks); bank++) {
		if (!strcmp(gpio_banks[bank].name, name)) {
			found = true;
			break;
		}
	}

	if (!found) {
		printf("irq gpio framework can't find %s\n", name);
		return EINVAL_GPIO;
	}

	irq_gpio = RK_IRQ_GPIO(bank, gpio->offset);
	if (!gpio_is_valid(irq_gpio))
		return EINVAL_GPIO;

	return _hard_gpio_to_irq(irq_gpio);
}

int hard_gpio_to_irq(u32 gpio)
{
	if (!gpio_is_valid(gpio))
		return EINVAL_GPIO;

	return _hard_gpio_to_irq(gpio);
}

int irq_to_gpio(int irq)
{
	return _irq_to_gpio(irq);
}

struct gpio_bank *gpio_id_to_bank(u32 id)
{
	int idx;

	for (idx = 0; idx < ARRAY_SIZE(gpio_banks); idx++) {
		if (gpio_banks[idx].id == id)
			return &gpio_banks[idx];
	}

	return NULL;
}

struct gpio_bank *gpio_to_bank(u32 gpio)
{
	int id;

	if (!gpio_is_valid(gpio))
		return NULL;

	id = (gpio & GPIO_BANK_MASK) >> GPIO_BANK_OFFSET;

	return gpio_id_to_bank(id);
}
