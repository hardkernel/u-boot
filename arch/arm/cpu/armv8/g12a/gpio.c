
/*
 * arch/arm/cpu/armv8/txl/gpio.c
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

static unsigned int gpio_to_pin[][7] = {
		[PIN_BOOT_0] = {PK(7, 31), NE, NE, NE, NE, NE, NE,},
		[PIN_BOOT_1] = {PK(7, 31), NE, NE, NE, NE, PK(7, 1), NE,},
		[PIN_BOOT_2] = {PK(7, 31), NE, NE, NE, NE, NE, NE,},
		[PIN_BOOT_3] = {PK(7, 31), NE, NE, NE, NE, PK(7, 23), NE,},
		[PIN_BOOT_4] = {PK(7, 31), PK(7, 13), NE, NE, NE, PK(7, 22), NE,},
		[PIN_BOOT_5] = {PK(7, 31), PK(7, 12), NE, NE, NE, PK(7, 21), NE,},
		[PIN_BOOT_6] = {PK(7, 31), PK(7, 11), NE, NE, NE, PK(7, 20), NE,},
		[PIN_BOOT_7] = {PK(7, 31), NE, NE, NE, NE, NE, NE,},
		[PIN_BOOT_8] = {PK(7, 30), NE, NE, NE, NE, NE, NE,},
		[PIN_BOOT_9] = {NE, NE, NE, NE, NE, NE, NE,},
		[PIN_BOOT_10] = {PK(7, 29), NE, NE, NE, NE, NE, NE,},
		[PIN_BOOT_11] = {PK(7, 28), PK(7, 10), NE, NE, NE, NE, NE,},

		[PIN_GPIOH_0] = {PK(0, 31), PK(0, 20), PK(0, 19), PK(0, 18), PK(0, 11), NE, NE,},
		[PIN_GPIOH_1] = {PK(0, 30), NE, PK(0, 23), NE, NE, NE, NE,},
		[PIN_GPIOH_2] = {PK(0, 29), PK(0, 2), PK(0, 22), NE, NE, NE, NE,},
		[PIN_GPIOH_3] = {PK(0, 28), PK(0, 1), PK(0, 21), NE, NE, NE, NE,},
		[PIN_GPIOH_4] = {PK(0, 27), PK(0, 26), NE, PK(0, 17), PK(0, 10), NE, NE,},
		[PIN_GPIOH_5] = {PK(0, 0), PK(10, 3), PK(0, 25), PK(0, 16), PK(0, 9), NE, NE,},
		[PIN_GPIOH_6] = {PK(10, 4), NE, PK(10, 2), PK(0, 24), PK(0, 15), PK(0, 8), NE,},
		[PIN_GPIOH_7] = {PK(10, 1), PK(10, 0), PK(0, 5), PK(0, 14), PK(0, 7), NE, NE,},
		[PIN_GPIOH_8] = {NE, NE, PK(0, 4), PK(0, 13), PK(0, 6), NE, NE,},
		[PIN_GPIOH_9] = {NE, NE, PK(0, 3), PK(0, 12), NE, NE, NE,},
		[PIN_GPIOH_10] = {NE, NE, NE, NE, NE, NE, NE,},

		[PIN_GPIOZ_0] = {PK(4, 31), PK(4, 25), NE, PK(3, 21), PK(3, 16), PK(10, 31), PK(10, 16),},
		[PIN_GPIOZ_1] = {PK(4, 30), PK(4, 24), NE, PK(3, 21), PK(3, 15), NE, PK(10, 16),},
		[PIN_GPIOZ_2] = {PK(4, 29), PK(4, 23), PK(4, 21), PK(3, 21), PK(3, 14), NE, PK(10, 16),},
		[PIN_GPIOZ_3] = {PK(4, 28), PK(4, 22), PK(4, 20), PK(3, 21), PK(3, 13), NE, PK(10, 16),},
		[PIN_GPIOZ_4] = {PK(4, 27), PK(4, 19), PK(10, 28), PK(3, 21), NE, NE, PK(10, 16),},
		[PIN_GPIOZ_5] = {PK(4, 26), PK(4, 17), PK(1, 12), PK(3, 21), NE, NE, PK(10, 16),},
		[PIN_GPIOZ_6] = {NE, PK(4, 16), PK(4, 15), PK(3, 21), NE, NE, PK(10, 16),},
		[PIN_GPIOZ_7] = {NE, PK(4, 14), PK(4, 13), PK(3, 21), NE, NE, PK(10, 16),},
		[PIN_GPIOZ_8] = {PK(4, 12), PK(10, 25), PK(10, 27), PK(3, 21), NE, PK(10, 22), PK(10, 16),},
		[PIN_GPIOZ_9] = {PK(4, 11), PK(10, 24), PK(10, 26), PK(3, 21), NE, PK(10, 21), PK(10, 16),},
		[PIN_GPIOZ_10] = {PK(4, 10), NE, PK(3, 20), PK(3, 21), NE, PK(10, 20), PK(10, 16),},
		[PIN_GPIOZ_11] = {PK(4, 9), NE, PK(3, 19), PK(3, 21), PK(3, 6), PK(10, 19), PK(10, 16),},
		[PIN_GPIOZ_12] = {PK(4, 8), NE, PK(3, 18), PK(3, 21), PK(3, 5), PK(10, 18), PK(10, 16),},
		[PIN_GPIOZ_13] = {NE, PK(4, 1), PK(3, 17), PK(3, 21), PK(3, 4), PK(10, 17), PK(10, 16),},
		[PIN_GPIOZ_14] = {PK(4, 7), NE, PK(4, 0), PK(3, 21), PK(3, 3), NE, PK(10, 16),},
		[PIN_GPIOZ_15] = {PK(4, 6), PK(3, 0), PK(3, 25), PK(3, 21), NE, NE, PK(10, 16),},
		[PIN_GPIOZ_16] = {PK(4, 5), PK(3, 31), PK(3, 24), PK(3, 21), NE, NE, NE,},
		[PIN_GPIOZ_17] = {PK(3, 30), NE, NE, PK(3, 21), NE, NE, NE,},
		[PIN_GPIOZ_18] = {PK(10, 23), PK(3, 2), PK(3, 23), PK(3, 29), NE, NE, NE,},
		[PIN_GPIOZ_19] = {PK(4, 4), PK(3, 1), PK(3, 22), PK(3, 28), PK(3, 27), NE, NE,},

		[PIN_GPIODV_0] = {PK(2, 25), PK(9, 17), NE, PK(2, 31), NE, NE, NE,},
		[PIN_GPIODV_1] = {PK(2, 24), PK(9, 16), NE, PK(2, 31), NE, NE, NE,},
		[PIN_GPIODV_2] = {PK(2, 22), PK(2, 23), PK(2, 20), PK(2, 31), PK(9, 25), NE, NE,},
		[PIN_GPIODV_3] = {PK(9, 31), PK(2, 21), PK(2, 17), PK(2, 31), PK(9, 30), PK(9, 23), NE,},
		[PIN_GPIODV_4] = {PK(2, 16), NE, NE, PK(2, 31), PK(9, 29), PK(9, 22), NE,},
		[PIN_GPIODV_5] = {PK(2, 15), NE, NE, PK(2, 31), PK(9, 28), PK(9, 21), NE,},
		[PIN_GPIODV_6] = {NE, PK(9, 14),PK(9, 24),  PK(2, 31), PK(9, 27), PK(9, 20), NE,},
		[PIN_GPIODV_7] = {NE, NE, NE, PK(2, 30), PK(9, 26), PK(2, 14), NE,},
		[PIN_GPIODV_8] = {NE, NE, NE, PK(2, 29), NE, PK(2, 13), NE,},
		[PIN_GPIODV_9] = {NE, NE, NE, PK(2, 28), NE, PK(2, 12), NE,},
		[PIN_GPIODV_10] = {PK(9, 19), PK(9, 18), PK(9, 15), PK(2, 27), NE, PK(2, 11), NE,},

		[GPIOAO_0] = {PK(AO, 12), PK(AO, 26), NE, NE, NE, NE, NE,},
		[GPIOAO_1] = {PK(AO, 11), PK(AO, 25), NE, NE, NE, NE, NE,},
		[GPIOAO_2] = {PK(AO, 10), PK(AO, 8), PK(AO, 28), PK(AO2, 10), NE, NE, NE,},
		[GPIOAO_3] = {PK(AO, 9), PK(AO, 7), NE, PK(AO, 22), NE, NE, NE,},
		[GPIOAO_4] = {PK(AO, 24), PK(AO, 6), PK(AO, 2), NE, NE, NE, NE,},
		[GPIOAO_5] = {PK(AO, 23), PK(AO, 5), PK(AO, 1), NE, NE, NE, NE,},
		[GPIOAO_6] = {PK(AO, 0), PK(AO, 21), NE, NE, NE, NE, NE,},
		[GPIOAO_7] = {PK(AO, 15), PK(AO, 13), PK(AO, 14), PK(AO, 17), NE, NE, NE,},
		[GPIOAO_8] = {PK(AO2, 16), PK(AO2, 17), PK(AO2, 14), PK(AO, 27), NE, NE, NE,},
		[GPIOAO_9] = {NE, NE, NE, PK(AO, 3), NE, NE, NE,},
		[GPIOAO_10] = {PK(AO2, 7), PK(AO2, 6), PK(AO2, 9), PK(AO2, 5), NE, NE, NE,},
		[GPIOAO_11] = {PK(AO2, 4), PK(AO2, 3), PK(AO2, 8), PK(AO2, 18), NE, NE, NE,},
		[GPIOAO_12] = {PK(AO2, 12), PK(AO2, 12), NE, PK(AO2, 2), NE, NE, NE,},
		[GPIOAO_13] = {PK(AO2, 11), PK(AO2, 15), PK(AO2, 19), PK(AO2, 1), NE, NE, NE,},

		[PIN_GPIO_TEST_N] = {PK(AO, 20),NE, NE, NE, NE, NE, NE,},

		[PIN_GPIOW_0] = {PK(5, 31), NE, NE, NE, NE, NE, NE,},
		[PIN_GPIOW_1] = {PK(5, 30), NE, NE, NE, NE, NE, NE,},
		[PIN_GPIOW_2] = {PK(5, 29), PK(5, 15), NE, NE, NE, NE, NE,},
		[PIN_GPIOW_3] = {PK(5, 28), PK(5, 14), NE, NE, NE, NE, NE,},
		[PIN_GPIOW_4] = {PK(5, 27), NE, NE, NE, NE, NE, NE,},
		[PIN_GPIOW_5] = {PK(5, 26), NE, NE, NE, NE, NE, NE,},
		[PIN_GPIOW_6] = {PK(5, 25), PK(5, 13), NE, NE, NE, NE, NE,},
		[PIN_GPIOW_7] = {PK(5, 24), PK(5, 12), NE, NE, NE, NE, NE,},
		[PIN_GPIOW_8] = {PK(5, 23), NE, NE, NE, NE, NE, NE,},
		[PIN_GPIOW_9] = {PK(5, 22), NE, NE, NE, NE, NE, NE,},
		[PIN_GPIOW_10] = {PK(5, 21), PK(5, 11), NE, NE, NE, NE, NE,},
		[PIN_GPIOW_11] = {PK(5, 20), PK(5, 10), NE, NE, NE, NE, NE,},
		[PIN_GPIOW_12] = {PK(5, 19), NE, NE, NE, NE, NE, NE,},
		[PIN_GPIOW_13] = {PK(5, 18), NE, NE, NE, NE, NE, NE,},
		[PIN_GPIOW_14] = {PK(5, 17), PK(5, 9), NE, NE, NE, NE, NE,},
		[PIN_GPIOW_15] = {PK(5, 16), PK(5, 8), NE, NE, NE, NE, NE,},

		[PIN_GPIOC_0] = {PK(6, 5), NE, NE, PK(6, 15), PK(6, 21), PK(6, 31), NE,},
		[PIN_GPIOC_1] = {PK(6, 4), NE, NE, PK(6, 14), PK(6, 20), PK(6, 30), NE,},
		[PIN_GPIOC_2] = {PK(6, 3), NE, NE, PK(6, 13), PK(6, 19), PK(6, 29), NE,},
		[PIN_GPIOC_3] = {PK(6, 2), NE, NE, PK(6, 12), PK(6, 18), PK(6, 28), NE,},
		[PIN_GPIOC_4] = {PK(6, 0), PK(6, 9), PK(6, 11), NE, PK(6, 17), PK(6, 27), NE,},
		[PIN_GPIOC_5] = {PK(6, 1), PK(6, 8), PK(6, 10), NE, PK(6, 16), PK(6, 26), NE,},

		[PIN_GPIOY_0] = {PK(8, 29), PK(8, 21), PK(1, 18), NE, NE, NE, NE,},
		[PIN_GPIOY_1] = {PK(8, 29), PK(8, 20), PK(1, 17), NE, NE, NE, NE,},
		[PIN_GPIOY_2] = {PK(8, 28), NE, PK(1, 16), NE, NE, NE, NE,},
		[PIN_GPIOY_3] = {PK(8, 28), NE, PK(1, 15), NE, NE, NE, NE,},
		[PIN_GPIOY_4] = {PK(8, 28), NE, PK(8, 12), PK(1, 8), NE, NE, NE,},
		[PIN_GPIOY_5] = {PK(8, 28), NE, PK(8, 5), PK(1, 7), NE, NE, NE,},
		[PIN_GPIOY_6] = {PK(8, 28), NE, PK(8, 4), PK(1, 14), NE, NE, NE,},
		[PIN_GPIOY_7] = {PK(8, 28), NE, PK(8, 3), PK(1, 13), NE, NE, NE,},
		[PIN_GPIOY_8] = {PK(8, 27), PK(8, 19), PK(8, 2), PK(1, 12), NE, NE, NE,},
		[PIN_GPIOY_9] = {PK(8, 27), PK(8, 13), PK(8, 1), PK(1, 11), NE, NE, NE,},
		[PIN_GPIOY_10] = {PK(8, 26), NE, PK(1, 30), PK(1, 10), NE, NE, NE,},
		[PIN_GPIOY_11] = {PK(8, 26), NE, PK(1, 26), PK(1, 9), NE, NE, NE,},
		[PIN_GPIOY_12] = {PK(8, 26), NE, PK(1, 25), PK(1, 6), NE, NE, NE,},
		[PIN_GPIOY_13] = {PK(8, 26), NE, PK(1, 24), PK(1, 5), NE, NE, NE,},
		[PIN_GPIOY_14] = {PK(8, 26), NE, PK(1, 23), PK(1, 4), NE, NE, NE,},
		[PIN_GPIOY_15] = {PK(8, 26), NE, PK(1, 22), PK(1, 3), NE, NE, NE,},
		[PIN_GPIOY_16] = {PK(8, 25), NE, PK(1, 29), PK(1, 2), NE, NE, NE,},
		[PIN_GPIOY_17] = {PK(8, 25), NE, PK(1, 21), PK(1, 1), NE, NE, NE,},
		[PIN_GPIOY_18] = {PK(8, 24), NE, PK(1, 28), NE, NE, NE, NE,},
		[PIN_GPIOY_19] = {PK(8, 24), NE, PK(1, 20), NE, NE, NE, NE,},
		[PIN_GPIOY_20] = {PK(8, 24), NE, PK(1, 19), NE, NE, NE, NE,},
		[PIN_GPIOY_21] = {PK(8, 24), NE, PK(8, 9), NE, NE, NE, NE,},
		[PIN_GPIOY_22] = {PK(8, 24), NE, PK(1, 27), NE, NE, NE, NE,},
		[PIN_GPIOY_23] = {PK(8, 24), NE, PK(8, 11), NE, NE, NE, NE,},
		[PIN_GPIOY_24] = {PK(8, 23), PK(8, 18), PK(8, 10), NE, NE, NE, NE,},
		[PIN_GPIOY_25] = {PK(8, 22), NE, PK(8, 8), NE, NE, NE, NE,},
		[PIN_GPIOY_26] = {PK(8, 30), PK(8, 14), PK(8, 7), NE, NE, NE, NE,},
		[PIN_GPIOY_27] = {PK(8, 31), NE, PK(8, 6), NE, NE, NE, NE,},

};

#define BANK(n, f, l, per, peb, pr, pb, dr, db, or, ob, ir, ib)		\
	{								\
		.name	= n,						\
		.first	= f,						\
		.last	= l,						\
		.regs	= {						\
			[REG_PULLEN]	= { (0xff634520 + (per<<2)), peb },			\
			[REG_PULL]	= { (0xff6344e8 + (pr<<2)), pb },			\
			[REG_DIR]	= { (0xff634430 + (dr<<2)), db },			\
			[REG_OUT]	= { (0xff634430 + (or<<2)), ob },			\
			[REG_IN]	= { (0xff634430 + (ir<<2)), ib },			\
		},							\
	 }
#define AOBANK(n, f, l, per, peb, pr, pb, dr, db, or, ob, ir, ib)		\
	{								\
		.name	= n,						\
		.first	= f,						\
		.last	= l,						\
		.regs	= {						\
			[REG_PULLEN]	= { (0xff80002c + (per<<2)), peb },			\
			[REG_PULL]	= { (0xff80002c + (pr<<2)), pb },			\
			[REG_DIR]	= { (0xff800024 + (dr<<2)), db },			\
			[REG_OUT]	= { (0xff800024 + (or<<2)), ob },			\
			[REG_IN]	= { (0xff800024 + (ir<<2)), ib },			\
		},							\
	 }

/*
gpioDV_10~0 : GPIO_REG0[10:0]
gpioH_10~0 : GPIO_REG1[30:20]
gpioW_15~0 : GPIO_REG1[15:0]
gpioC_5~0 : GPIO_REG2[25:20]
boot_11~0 : GPIO_REG2[11:0]
gpioZ_19~0 : GPIO_REG3[19:0]
gpioY_27~0 : GPIO_REG4[27:0]
*/
static struct meson_bank mesongxbb_banks[] = {
	/*   name    first         last
	 *   pullen  pull     dir     out     in  */
	BANK("GPIODV_",  PIN_GPIODV_0, PIN_GPIODV_10,
		0,  0,  0,  0,   /*gpioDV_10~0 : GPIO_REG0[10:0]*/
		0,  0,
		1,  0,
		2,  0),

	BANK("GPIOW_",    PIN_GPIOW_0,  PIN_GPIOW_15,
		1,  0,   1,  0, /*gpioW_15~0 : GPIO_REG1[15:0]*/
		3,  0,
		4,  0,
		5,  0),
	BANK("GPIOH_",    PIN_GPIOH_0,  PIN_GPIOH_10,
		1, 20,  1, 20, /*gpioH_10~0 : GPIO_REG1[30:20]*/
		3, 20,
		4, 20,
		5, 20),

	BANK("BOOT_", PIN_BOOT_0,   PIN_BOOT_11,
		2,  0,  2,  0, /*boot_11~0 : GPIO_REG2[11:0]*/
		6,  0,
		7,  0,
		8,  0),
	BANK("GPIOC_", GPIOC_0,   GPIOC_5,
		2, 20,  2, 20, /*gpioC_5~0 : GPIO_REG2[25:20]*/
		6, 20,
		7, 20,
		8, 20),

	BANK("GPIOZ_", GPIOZ_0,   GPIOZ_19,
		3,  0,  3,  0,/*gpioZ_19~0 : GPIO_REG3[19:0]*/
		9,  0,
		10, 0,
		11, 0),

	BANK("GPIOY_", GPIOY_0,   GPIOY_27,
		4,  0,  3,  0, /*gpioY_27~0 : GPIO_REG4[27:0]*/
		12, 0,
		13, 0,
		14, 0),

	AOBANK("GPIOAO_", GPIOAO_0, GPIOAO_13,
		0,  16,  0, 0,/**/
		0,  0,
		0, 16,
		1,  0),
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
};
static unsigned long domain[]={
	[0] = 0xff6344b0,
	[1] = 0xff800014,
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


