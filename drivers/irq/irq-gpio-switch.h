/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _IRQ_GPIO_SWITCH_H_
#define _IRQ_GPIO_SWITCH_H_

#include <asm/io.h>
#include <common.h>
#include <irq-platform.h>

/* bank and pin bit mask */
#define GPIO_BANK_MASK		0xFFFFFF00
#define GPIO_BANK_OFFSET	8
#define GPIO_PIN_MASK		0x000000FF
#define GPIO_PIN_OFFSET		0

#define EINVAL_GPIO		-1
#define PIN_BASE		GIC_IRQS_NR

struct gpio_bank {
	char *name;
	void __iomem *regbase;
	int id;
	int irq_base;
	int ngpio;
	int use_count;
};

#define GPIO_BANK_REGISTER(ID, GPIO_BANK_NUM)	\
	{								\
		.name	  = __stringify(gpio##ID),			\
		.regbase  = (unsigned char __iomem *)GPIO##ID##_PHYS,	\
		.id	  = ID,						\
		.irq_base = PIN_BASE + (ID) * (GPIO_BANK_NUM),		\
		.ngpio    = GPIO_BANK_NUM,				\
		.use_count = 0						\
	}

/* gpio bank[31:8] and pin[7:0] */
#define GPIO_BANK(gpio)		((gpio & GPIO_BANK_MASK) >> GPIO_BANK_OFFSET)
#define GPIO_PIN(gpio)		((gpio & GPIO_PIN_MASK) >> GPIO_PIN_OFFSET)
#define GPIO_BANK_VALID(gpio)	(GPIO_BANK(gpio) < GPIO_BANK_NUM)
#define GPIO_PIN_VALID(gpio)	(GPIO_PIN(gpio) < GPIO_BANK_PINS)

int hard_gpio_to_irq(u32 gpio);
int irq_to_gpio(int irq);

struct gpio_bank *gpio_id_to_bank(unsigned int id);
struct gpio_bank *gpio_to_bank(unsigned gpio);

#endif	/* _IRQ_GPIO_SWITCH_H_ */
