
/*
 * arch/arm/cpu/armv8/gxb/gpio.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <common.h>
#include <dm.h>
#include <linux/compiler.h>
#include <aml_gpio.h>
#include <asm/arch/gpio.h>

#define NE 0xffffffff
#define PK(reg, bit) ((reg<<5)|bit)
/*AO REG */
#define AO 0x10
#define AO2 0x11

static unsigned int gpio_to_pin[][6] = {
	[PIN_GPIOX_0] = {PK(8, 5), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_1] = {PK(8, 4), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_2] = {PK(8, 3), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_3] = {PK(8, 2), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_4] = {PK(8, 1), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_5] = {PK(8, 0), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_6] = {PK(3, 9), PK(3, 17), NE, NE, NE, NE,},
	[PIN_GPIOX_7] = {PK(8, 11), PK(3, 8), PK(3, 18), NE, NE, NE,},
	[PIN_GPIOX_8] = {PK(3, 10), PK(4, 7), PK(3, 30), NE, NE, NE,},
	[PIN_GPIOX_9] = {PK(3, 7), PK(4, 6), PK(3, 29), NE, NE, NE,},
	[PIN_GPIOX_10] = {PK(3, 13), PK(3, 28), NE, NE, NE, NE,},
	[PIN_GPIOX_11] = {PK(3, 12), PK(3, 27), NE, NE, NE, NE,},
	[PIN_GPIOX_12] = {PK(4, 13), PK(4, 17), PK(3, 12), NE, NE, NE,},
	[PIN_GPIOX_13] = {PK(4, 12), PK(4, 16), PK(3, 12), NE, NE, NE,},
	[PIN_GPIOX_14] = {PK(4, 11), PK(4, 15), PK(3, 12), NE, NE, NE,},
	[PIN_GPIOX_15] = {PK(4, 10), PK(4, 14), PK(3, 12), NE, NE, NE,},
	[PIN_GPIOX_16] = {PK(2, 25), PK(3, 12), PK(4, 2), NE, NE, NE,},
	[PIN_GPIOX_17] = {PK(2, 24), PK(3, 12), PK(4, 3), NE, NE, NE,},
	[PIN_GPIOX_18] = {PK(2, 23), PK(3, 16), PK(2, 31), NE, NE, NE,},
	[PIN_GPIOX_19] = {PK(2, 22), PK(3, 15), PK(2, 30), NE, NE, NE,},
	[PIN_GPIOX_20] = {PK(3, 14), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_21] = {PK(3, 24), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_22] = {PK(3, 6), NE, NE, NE, NE, NE,},
	[PIN_BOOT_0] = {PK(4, 30), NE, NE, NE, NE, NE,},
	[PIN_BOOT_1] = {PK(4, 30), NE, NE, NE, NE, NE,},
	[PIN_BOOT_2] = {PK(4, 30), NE, NE, NE, NE, NE,},
	[PIN_BOOT_3] = {PK(4, 30), NE, NE, NE, NE, NE,},
	[PIN_BOOT_4] = {PK(4, 30), NE, NE, NE, NE, NE,},
	[PIN_BOOT_5] = {PK(4, 30), NE, NE, NE, NE, NE,},
	[PIN_BOOT_6] = {PK(4, 30), NE, NE, NE, NE, NE,},
	[PIN_BOOT_7] = {PK(4, 30), NE, NE, NE, NE, NE,},
	[PIN_BOOT_8] = {PK(4, 26), PK(4, 18), NE, NE, NE, NE,},
	[PIN_BOOT_9] = {PK(4, 27), NE, NE, NE, NE, NE,},
	[PIN_BOOT_10] = {PK(4, 25), PK(4, 19), NE, NE, NE, NE,},
	[PIN_BOOT_11] = {PK(4, 24), PK(5, 1), NE, NE, NE, NE,},
	[PIN_BOOT_12] = {PK(4, 23), PK(5, 3), NE, NE, NE, NE,},
	[PIN_BOOT_13] = {PK(4, 22), PK(5, 2), NE, NE, NE, NE,},
	[PIN_BOOT_14] = {PK(4, 21), NE, NE, NE, NE, NE,},
	[PIN_BOOT_15] = {PK(4, 20), PK(4, 31), PK(5, 0), NE, NE, NE,},
	[PIN_BOOT_16] = {PK(4, 28), NE, NE, NE, NE, NE,},
	[PIN_BOOT_17] = {PK(4, 29), NE, NE, NE, NE, NE,},
	[PIN_GPIOH_0] = {PK(1, 26), NE, NE, NE, NE, NE,},
	[PIN_GPIOH_1] = {PK(1, 25), NE, NE, NE, NE, NE,},
	[PIN_GPIOH_2] = {PK(1, 24), NE, NE, NE, NE, NE,},
	[PIN_GPIOH_3] = {NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOZ_0] = {PK(6, 0), PK(5, 5), NE, NE, NE, NE,},
	[PIN_GPIOZ_1] = {PK(6, 1), PK(5, 6), NE, NE, NE, NE,},
	[PIN_GPIOZ_2] = {PK(6, 13), NE, NE, NE, NE, NE,},
	[PIN_GPIOZ_3] = {PK(6, 12), PK(5, 7), NE, NE, NE, NE,},
	[PIN_GPIOZ_4] = {PK(6, 11), PK(5, 4), NE, NE, NE, NE,},
	[PIN_GPIOZ_5] = {PK(6, 10), PK(5, 4), NE, NE, NE, NE,},
	[PIN_GPIOZ_6] = {PK(6, 9), PK(5, 4), PK(5, 27), PK(4, 9), NE, NE,},
	[PIN_GPIOZ_7] = {PK(6, 8), PK(5, 4), PK(5, 26), PK(4, 8), NE, NE,},
	[PIN_GPIOZ_8] = {PK(6, 7), PK(5, 4), NE, NE, NE, NE,},
	[PIN_GPIOZ_9] = {PK(6, 6), PK(5, 4), NE, NE, NE, NE,},
	[PIN_GPIOZ_10] = {PK(6, 5), PK(5, 4), NE, NE, NE, NE,},
	[PIN_GPIOZ_11] = {PK(6, 4), PK(5, 4), NE, NE, NE, NE,},
	[PIN_GPIOZ_12] = {PK(6, 3), PK(5, 28), NE, NE, NE, NE,},
	[PIN_GPIOZ_13] = {PK(6, 2), PK(5, 29), NE, NE, NE, NE,},
	[PIN_GPIOZ_14] = {NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOZ_15] = {PK(6, 15), NE, NE, NE, NE, NE,},
	[PIN_GPIODV_0] = {PK(0, 0), PK(0, 8), PK(5, 15), PK(7, 0),
		PK(0, 18), NE,},
	[PIN_GPIODV_1] = {PK(0, 0), PK(0, 8), PK(7, 1), PK(2, 0),
		PK(0, 18), NE,},
	[PIN_GPIODV_2] = {PK(0, 1), PK(0, 8), PK(7, 2), PK(0, 18), NE, NE,},
	[PIN_GPIODV_3] = {PK(0, 1), PK(0, 8), PK(7, 3), PK(0, 18), NE, NE,},
	[PIN_GPIODV_4] = {PK(0, 1), PK(0, 8), PK(7, 4), PK(0, 18), NE, NE,},
	[PIN_GPIODV_5] = {PK(0, 1), PK(0, 8), PK(7, 5), PK(0, 18), NE, NE,},
	[PIN_GPIODV_6] = {PK(0, 1), PK(0, 8), PK(7, 6), PK(0, 18), NE, NE,},
	[PIN_GPIODV_7] = {PK(0, 1), PK(0, 8), PK(7, 7), PK(0, 18), NE, NE,},
	[PIN_GPIODV_8] = {PK(0, 2), PK(0, 8), PK(5, 14), PK(7, 8),
		PK(0, 18), NE,},
	[PIN_GPIODV_9] = {PK(0, 2), PK(0, 8), PK(3, 19), PK(7, 9),
		PK(0, 18), NE,},
	[PIN_GPIODV_10] = {PK(0, 3), PK(0, 8), PK(7, 10), PK(0, 18), NE, NE,},
	[PIN_GPIODV_11] = {PK(0, 3), PK(0, 8), PK(7, 11), PK(0, 18), NE, NE,},
	[PIN_GPIODV_12] = {PK(0, 3), PK(0, 8), PK(7, 12), PK(0, 18), NE, NE,},
	[PIN_GPIODV_13] = {PK(0, 3), PK(0, 8), PK(7, 13), PK(0, 18), NE, NE,},
	[PIN_GPIODV_14] = {PK(0, 3), PK(0, 8), PK(7, 14), PK(0, 18), NE, NE,},
	[PIN_GPIODV_15] = {PK(0, 3), PK(0, 8), PK(7, 15), PK(0, 18), NE, NE,},
	[PIN_GPIODV_16] = {PK(0, 4), PK(0, 8), PK(5, 13), PK(2, 1),
		PK(0, 17), NE,},
	[PIN_GPIODV_17] = {PK(0, 4), PK(0, 8), PK(2, 2), PK(0, 16), NE, NE,},
	[PIN_GPIODV_18] = {PK(0, 5), PK(0, 8), PK(2, 5), NE, NE, NE,},
	[PIN_GPIODV_19] = {PK(0, 5), PK(0, 8), PK(2, 4), NE, NE, NE,},
	[PIN_GPIODV_20] = {PK(0, 5), PK(0, 8), PK(2, 3), NE, NE, NE,},
	[PIN_GPIODV_21] = {PK(0, 5), PK(0, 8), PK(2, 6), NE, NE, NE,},
	[PIN_GPIODV_22] = {PK(0, 5), PK(0, 8), PK(2, 7), NE, NE, NE,},
	[PIN_GPIODV_23] = {PK(0, 5), PK(0, 8), PK(2, 8), NE, NE, NE,},
	[PIN_GPIODV_24] = {PK(0, 7), PK(0, 12), PK(5, 12), PK(7, 26),
		PK(2, 29), NE,},
	[PIN_GPIODV_25] = {PK(0, 6), PK(0, 11), PK(5, 11), PK(7, 27),
		PK(2, 28), NE,},
	[PIN_GPIODV_26] = {PK(0, 10), PK(5, 10), PK(7, 24), PK(2, 27), NE, NE,},
	[PIN_GPIODV_27] = {PK(0, 9), PK(5, 9), PK(5, 8), PK(7, 25),
		PK(2, 26), NE,},
	[PIN_GPIODV_28] = {PK(3, 20), PK(7, 22), NE, NE, NE, NE,},
	[PIN_GPIODV_29] = {PK(3, 22), PK(3, 21), PK(7, 23), NE, NE, NE,},
	[GPIOAO_0] = {PK(AO, 12), PK(AO, 26), NE, NE, NE, NE,},
	[GPIOAO_1] = {PK(AO, 11), PK(AO, 25), NE, NE, NE, NE,},
	[GPIOAO_2] = {PK(AO, 10), PK(AO, 8), NE, NE, NE, NE,},
	[GPIOAO_3] = {PK(AO, 9), PK(AO, 7), PK(AO, 22), NE, NE, NE,},
	[GPIOAO_4] = {PK(AO, 24), PK(AO, 6), PK(AO, 2), NE, NE, NE,},
	[GPIOAO_5] = {PK(AO, 25), PK(AO, 5), PK(AO, 1), NE, NE, NE,},
	[GPIOAO_6] = {PK(AO, 18), PK(AO, 16), NE, NE, NE, NE,},
	[GPIOAO_7] = {PK(AO, 0), PK(AO, 21), NE, NE, NE, NE,},
	[GPIOAO_8] = {PK(AO, 30), NE, NE, NE, NE, NE,},
	[GPIOAO_9] = {PK(AO, 29), NE, NE, NE, NE, NE,},
	[GPIOAO_10] = {PK(AO, 28), NE, NE, NE, NE, NE,},
	[GPIOAO_11] = {PK(AO, 27), PK(AO, 15), PK(AO, 14), PK(AO, 17),
		PK(AO2, 0), NE,},
	[GPIOAO_13] = {PK(AO, 31), PK(AO, 3), PK(AO, 4), PK(AO2, 1),
		PK(AO, 19), PK(AO2, 2),},
	[PIN_CARD_0] = {PK(2, 14), NE, NE, NE, NE, NE,},
	[PIN_CARD_1] = {PK(2, 15), NE, NE, NE, NE, NE,},
	[PIN_CARD_2] = {PK(2, 11), NE, NE, NE, NE, NE,},
	[PIN_CARD_3] = {PK(2, 10), NE, NE, NE, NE, NE,},
	[PIN_CARD_4] = {PK(2, 12), PK(8, 10), PK(8, 18), NE, NE, NE,},
	[PIN_CARD_5] = {PK(2, 13), PK(8, 17), PK(8, 9), NE, NE, NE,},
	[PIN_CARD_6] = {NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOY_0] = {PK(2, 19), PK(3, 2), PK(1, 0), NE, NE, NE,},
	[PIN_GPIOY_1] = {PK(2, 18), PK(3, 1), PK(1, 1), NE, NE, NE,},
	[PIN_GPIOY_2] = {PK(2, 17), PK(3, 0), NE, NE, NE, NE,},
	[PIN_GPIOY_3] = {PK(2, 16), PK(3, 4), PK(1, 2), NE, NE, NE,},
	[PIN_GPIOY_4] = {PK(2, 16), PK(3, 5), PK(1, 12), NE, NE, NE,},
	[PIN_GPIOY_5] = {PK(2, 16), PK(3, 5), PK(1, 13), NE, NE, NE,},
	[PIN_GPIOY_6] = {PK(2, 16), PK(3, 5), PK(1, 3), NE, NE, NE,},
	[PIN_GPIOY_7] = {PK(2, 16), PK(3, 5), PK(1, 4), NE, NE, NE,},
	[PIN_GPIOY_8] = {PK(2, 16), PK(3, 5), PK(1, 5), NE, NE, NE,},
	[PIN_GPIOY_9] = {PK(2, 16), PK(3, 5), PK(1, 6), NE, NE, NE,},
	[PIN_GPIOY_10] = {PK(2, 16), PK(3, 5), PK(1, 7), NE, NE, NE,},
	[PIN_GPIOY_11] = {PK(3, 3), PK(1, 19), PK(1, 8), NE, NE, NE,},
	[PIN_GPIOY_12] = {PK(1, 18), PK(1, 9), NE, NE, NE, NE,},
	[PIN_GPIOY_13] = {PK(1, 17), PK(1, 10), NE, NE, NE, NE,},
	[PIN_GPIOY_14] = {PK(1, 16), PK(1, 11), NE, NE, NE, NE,},
	[PIN_GPIOY_15] = {PK(2, 20), PK(1, 20), PK(1, 22), NE, NE, NE,},
	[PIN_GPIOY_16] = {PK(2, 21), PK(1, 21), NE, NE, NE, NE,},
	[PIN_GPIO_TEST_N] = {PK(AO, 19), PK(AO2, 2), NE, NE, NE, NE,},
};

#define BANK(n, f, l, per, peb, pr, pb, dr, db, or, ob, ir, ib)		\
	{								\
		.name	= n,						\
		.first	= f,						\
		.last	= l,						\
		.regs	= {						\
			[REG_PULLEN]	= { (0xc8834120 + (per<<2)), peb },			\
			[REG_PULL]	= { (0xc88344e8 + (pr<<2)), pb },			\
			[REG_DIR]	= { (0xc8834430 + (dr<<2)), db },			\
			[REG_OUT]	= { (0xc8834430 + (or<<2)), ob },			\
			[REG_IN]	= { (0xc8834430 + (ir<<2)), ib },			\
		},							\
	 }
#define AOBANK(n, f, l, per, peb, pr, pb, dr, db, or, ob, ir, ib)		\
	{								\
		.name	= n,						\
		.first	= f,						\
		.last	= l,						\
		.regs	= {						\
			[REG_PULLEN]	= { (0xc810002c + (per<<2)), peb },			\
			[REG_PULL]	= { (0xc810002c + (pr<<2)), pb },			\
			[REG_DIR]	= { (0xc8100024 + (dr<<2)), db },			\
			[REG_OUT]	= { (0xc8100024 + (or<<2)), ob },			\
			[REG_IN]	= { (0xc8100024 + (ir<<2)), ib },			\
		},							\
	 }

static struct meson_bank mesongxbb_banks[] = {
	/*   name    first         last
	 *   pullen  pull     dir     out     in  */
	BANK("GPIOX_",    PIN_GPIOX_0,  PIN_GPIOX_22,
	     4,  0,  4,  0,  12,  0,  13,  0,  14,  0),
	BANK("GPIOY_",    PIN_GPIOY_0,  PIN_GPIOY_16,
	     1,  0,  1,  0,  3,  0,  4,  0,  5,  0),
	BANK("GPIODV_",  PIN_GPIODV_0, PIN_GPIODV_29,
	     0,  0,  0,  0,  0,  0,  1,  0,  2,  0),
	BANK("GPIOH_",    PIN_GPIOH_0,  PIN_GPIOH_3,
	    1, 20,  1, 20,  3, 20, 4, 20, 5, 20),
	BANK("GPIOZ_",    PIN_GPIOZ_0,  PIN_GPIOZ_15,
	     3,  0,  3,  0,  9, 0,  10, 0,  11, 0),
	BANK("CARD_", PIN_CARD_0,   PIN_CARD_6,
	     2, 20,  2, 20,  6, 20,  7, 20,  8, 20),
	BANK("BOOT_", PIN_BOOT_0,   PIN_BOOT_17,
	     2,  0,  2,  0,  6,  0, 7,  0, 8,  0),
	BANK("GPIOCLK_", PIN_GPIOCLK_0,   PIN_GPIOCLK_3,
	     3,  28,  3,  28,  9,  28, 10,  28, 11,  28),
	AOBANK("GPIOAO_",   GPIOAO_0, GPIOAO_13,
	     0,  0,  0, 16,  0,  0,  0, 16,  1,  0),
};

U_BOOT_DEVICES(gxbb_gpios) = {
	{ "gpio_aml", &mesongxbb_banks[0] },
	{ "gpio_aml", &mesongxbb_banks[1] },
	{ "gpio_aml", &mesongxbb_banks[2] },
	{ "gpio_aml", &mesongxbb_banks[3] },
	{ "gpio_aml", &mesongxbb_banks[4] },
	{ "gpio_aml", &mesongxbb_banks[5] },
	{ "gpio_aml", &mesongxbb_banks[6] },
	{ "gpio_aml", &mesongxbb_banks[7] },
	{ "gpio_aml", &mesongxbb_banks[8] },
};
static unsigned long domain[]={
	[0] = 0xc88344b0,
	[1] = 0xc8100014,
};
int  clear_pinmux(unsigned int pin)
{
	unsigned int *gpio_reg =  &gpio_to_pin[pin][0];
	int i, dom, reg, bit;
	for (i = 0;
	     i < sizeof(gpio_to_pin[pin])/sizeof(gpio_to_pin[pin][0]); i++) {
		if (gpio_reg[i] != NE) {
			reg = GPIO_REG(gpio_reg[i])&0xf;
			bit = GPIO_BIT(gpio_reg[i]);
			dom = GPIO_REG(gpio_reg[i])>>4;
			regmap_update_bits(domain[dom]+reg*4,BIT(bit),0);
		}
	}
	return 0;

}


