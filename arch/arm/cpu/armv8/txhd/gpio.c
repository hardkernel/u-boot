
/*
 * arch/arm/cpu/armv8/txhd/gpio.c
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

struct pin_mux_desc {
	unsigned char domain;
	unsigned char reg;
	unsigned char bit;
};

#define MUX_AO_DOMAIN 0
#define MUX_EE_DOMAIN 1

#define GPIOEE(x) (EE_OFFSET + x)

#define PIN_MUX(d, r, b)     \
{                            \
	.domain = d,             \
	.reg    = r,             \
	.bit    = b,             \
}

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

static struct pin_mux_desc pin_to_gpio[] = {
	[GPIOAO_0] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 0),
	[GPIOAO_1] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 4),
	[GPIOAO_2] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 8),
	[GPIOAO_3] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 12),
	[GPIOAO_4] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 16),
	[GPIOAO_5] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 20),
	[GPIOAO_6] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 24),
	[GPIOAO_7] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 28),
	[GPIOAO_8] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 0),
	[GPIOAO_9] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 4),
	[GPIOAO_10] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 8),
	[GPIOAO_11] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 12),
	[GPIOAO_12] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 16),
	[GPIOAO_13] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 20),
	[GPIOEE(GPIOZ_0)] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 0),
	[GPIOEE(GPIOZ_1)] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 4),
	[GPIOEE(GPIOZ_2)] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 8),
	[GPIOEE(GPIOZ_3)] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 12),
	[GPIOEE(GPIOZ_4)] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 16),
	[GPIOEE(GPIOZ_5)] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 20),
	[GPIOEE(GPIOZ_6)] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 24),
	[GPIOEE(GPIOZ_7)] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 28),
	[GPIOEE(GPIOH_0)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 0),
	[GPIOEE(GPIOH_1)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 4),
	[GPIOEE(GPIOH_2)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 8),
	[GPIOEE(GPIOH_3)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 12),
	[GPIOEE(GPIOH_4)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 16),
	[GPIOEE(GPIOH_5)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 20),
	[GPIOEE(GPIOH_6)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 24),
	[GPIOEE(GPIOH_7)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 28),
	[GPIOEE(GPIOH_8)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 0),
	[GPIOEE(GPIOH_9)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 4),
	[GPIOEE(GPIOH_10)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 8),
	[GPIOEE(GPIOH_11)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 12),
	[GPIOEE(GPIOH_12)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 16),
	[GPIOEE(GPIOH_13)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 20),
	[GPIOEE(GPIOH_14)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 24),
	[GPIOEE(GPIOH_15)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 28),
	[GPIOEE(BOOT_0)] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 0),
	[GPIOEE(BOOT_1)] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 4),
	[GPIOEE(BOOT_2)] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 8),
	[GPIOEE(BOOT_3)] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 12),
	[GPIOEE(BOOT_4)] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 16),
	[GPIOEE(BOOT_5)] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 20),
	[GPIOEE(BOOT_6)] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 24),
	[GPIOEE(BOOT_7)] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 28),
	[GPIOEE(BOOT_8)] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 0),
	[GPIOEE(BOOT_9)] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 4),
	[GPIOEE(BOOT_10)] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 8),
	[GPIOEE(BOOT_11)] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 12),
	[GPIOEE(BOOT_12)] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 16),
	[GPIOEE(GPIOC_0)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 0),
	[GPIOEE(GPIOC_1)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 4),
	[GPIOEE(GPIOC_2)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 8),
	[GPIOEE(GPIOC_3)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 12),
	[GPIOEE(GPIOC_4)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 16),
	[GPIOEE(GPIOC_5)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 20),
	[GPIOEE(GPIOC_6)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 24),
	[GPIOEE(GPIOC_7)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 28),
	[GPIOEE(GPIOC_8)] = PIN_MUX(MUX_EE_DOMAIN, 0xa, 0),
	[GPIOEE(GPIOC_9)] = PIN_MUX(MUX_EE_DOMAIN, 0xa, 4),
	[GPIOEE(GPIOC_10)] = PIN_MUX(MUX_EE_DOMAIN, 0xa, 8),
	[GPIOEE(GPIODV_0)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 0),
	[GPIOEE(GPIODV_1)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 4),
	[GPIOEE(GPIODV_2)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 8),
	[GPIOEE(GPIODV_3)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 12),
	[GPIOEE(GPIODV_4)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 16),
	[GPIOEE(GPIODV_5)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 20),
	[GPIOEE(GPIODV_6)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 24),
	[GPIOEE(GPIODV_7)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 28),
	[GPIOEE(GPIODV_8)] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 0),
	[GPIOEE(GPIODV_9)] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 4),
	[GPIOEE(GPIOW_0)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 0),
	[GPIOEE(GPIOW_1)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 4),
	[GPIOEE(GPIOW_2)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 8),
	[GPIOEE(GPIOW_3)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 12),
	[GPIOEE(GPIOW_4)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 16),
	[GPIOEE(GPIOW_5)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 20),
	[GPIOEE(GPIOW_6)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 24),
	[GPIOEE(GPIOW_7)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 28),
	[GPIOEE(GPIOW_8)] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 0),
	[GPIOEE(GPIOW_9)] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 4),
	[GPIOEE(GPIOW_10)] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 8),
	[GPIOEE(GPIOW_11)] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 12),
};
/*sequence of banks keep same as arch-axg/gpio.h*/
static struct meson_bank mesontxhd_banks[] = {
    /*name   first  last   pullen   pull   dir   out  in*/
	AOBANK("GPIOAO_", GPIOAO_0,   GPIOAO_13,
		0,  16, 0,  0,  0,  0,  0,  16, 1,  0),
	BANK("GPIOZ_", GPIOEE(GPIOZ_0), GPIOEE(GPIOZ_7),
		3, 0,  3,  0,  9,  0,  10, 0,  11, 0),
	BANK("GPIOH_", GPIOEE(GPIOH_0), GPIOEE(GPIOH_15),
		1, 16,  1,  16,  3,  16,  4, 16,  5, 16),
	BANK("BOOT_", GPIOEE(BOOT_0), GPIOEE(BOOT_12),
		2, 0,  2,  0,  6,  0,  7, 0,  8, 0),
	BANK("GPIOC_", GPIOEE(GPIOC_0), GPIOEE(GPIOC_10),
		2, 16,  2,  16,  6,  16, 7, 16, 8, 16),
	BANK("GPIODV_", GPIOEE(GPIODV_0), GPIOEE(GPIODV_9),
		0, 0,  0,  0,  0,  0, 1, 0, 2, 0),
	BANK("GPIOW_", GPIOEE(GPIOW_0), GPIOEE(GPIOW_11),
		1, 0,  1,  0,  3,  0, 4, 0, 5, 0),
};

U_BOOT_DEVICES(txhd_gpios) = {
	{ "gpio_aml", &mesontxhd_banks[0] },
	{ "gpio_aml", &mesontxhd_banks[1] },
	{ "gpio_aml", &mesontxhd_banks[2] },
	{ "gpio_aml", &mesontxhd_banks[3] },
	{ "gpio_aml", &mesontxhd_banks[4] },
	{ "gpio_aml", &mesontxhd_banks[5] },
	{ "gpio_aml", &mesontxhd_banks[6] },
};

static unsigned long domain[]={
	[MUX_AO_DOMAIN] = 0xff800014,
	[MUX_EE_DOMAIN] = 0xff634480,
};

int clear_pinmux(unsigned int pin)
{
	struct pin_mux_desc *pmux_desc = &pin_to_gpio[pin];

	regmap_update_bits(domain[pmux_desc->domain] + (pmux_desc->reg << 2),
			0xf << (pmux_desc->bit), 0 << (pmux_desc->bit));

	return 0;
}
