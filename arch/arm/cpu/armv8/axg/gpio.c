
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

struct pin_mux_desc {
	unsigned char domain;
	unsigned char reg;
	unsigned char bit;
};

#define MUX_AO_DOMAIN 0
#define MUX_EE_DOMAIN 1

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
	[PIN_GPIOZ_0] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 0),
	[PIN_GPIOZ_1] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 4),
	[PIN_GPIOZ_2] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 8),
	[PIN_GPIOZ_3] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 12),
	[PIN_GPIOZ_4] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 16),
	[PIN_GPIOZ_5] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 20),
	[PIN_GPIOZ_6] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 24),
	[PIN_GPIOZ_7] = PIN_MUX(MUX_EE_DOMAIN, 0x2, 28),
	[PIN_GPIOZ_8] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 0),
	[PIN_GPIOZ_9] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 4),
	[PIN_GPIOZ_10] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 8),
	[PIN_BOOT_0] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 0),
	[PIN_BOOT_1] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 4),
	[PIN_BOOT_2] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 8),
	[PIN_BOOT_3] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 12),
	[PIN_BOOT_4] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 16),
	[PIN_BOOT_5] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 20),
	[PIN_BOOT_6] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 24),
	[PIN_BOOT_7] = PIN_MUX(MUX_EE_DOMAIN, 0x0, 28),
	[PIN_BOOT_8] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 0),
	[PIN_BOOT_9] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 4),
	[PIN_BOOT_10] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 8),
	[PIN_BOOT_11] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 12),
	[PIN_BOOT_12] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 16),
	[PIN_BOOT_13] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 20),
	[PIN_BOOT_14] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 24),
	[PIN_GPIOA_0] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 0),
	[PIN_GPIOA_1] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 4),
	[PIN_GPIOA_2] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 8),
	[PIN_GPIOA_3] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 12),
	[PIN_GPIOA_4] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 16),
	[PIN_GPIOA_5] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 20),
	[PIN_GPIOA_6] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 24),
	[PIN_GPIOA_7] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 28),
	[PIN_GPIOA_8] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 0),
	[PIN_GPIOA_9] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 4),
	[PIN_GPIOA_10] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 8),
	[PIN_GPIOA_11] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 12),
	[PIN_GPIOA_12] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 16),
	[PIN_GPIOA_13] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 20),
	[PIN_GPIOA_14] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 24),
	[PIN_GPIOA_15] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 28),
	[PIN_GPIOA_16] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 0),
	[PIN_GPIOA_17] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 4),
	[PIN_GPIOA_18] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 8),
	[PIN_GPIOA_19] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 12),
	[PIN_GPIOA_20] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 16),
	[PIN_GPIOX_0] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 0),
	[PIN_GPIOX_1] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 4),
	[PIN_GPIOX_2] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 8),
	[PIN_GPIOX_3] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 12),
	[PIN_GPIOX_4] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 16),
	[PIN_GPIOX_5] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 20),
	[PIN_GPIOX_6] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 24),
	[PIN_GPIOX_7] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 28),
	[PIN_GPIOX_8] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 0),
	[PIN_GPIOX_9] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 4),
	[PIN_GPIOX_10] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 8),
	[PIN_GPIOX_11] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 12),
	[PIN_GPIOX_12] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 16),
	[PIN_GPIOX_13] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 20),
	[PIN_GPIOX_14] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 24),
	[PIN_GPIOX_15] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 28),
	[PIN_GPIOX_16] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 0),
	[PIN_GPIOX_17] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 4),
	[PIN_GPIOX_18] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 8),
	[PIN_GPIOX_19] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 12),
	[PIN_GPIOX_20] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 16),
	[PIN_GPIOX_21] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 20),
	[PIN_GPIOX_22] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 24),
	[PIN_GPIOY_0] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 0),
	[PIN_GPIOY_1] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 4),
	[PIN_GPIOY_2] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 8),
	[PIN_GPIOY_3] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 12),
	[PIN_GPIOY_4] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 16),
	[PIN_GPIOY_5] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 20),
	[PIN_GPIOY_6] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 24),
	[PIN_GPIOY_7] = PIN_MUX(MUX_EE_DOMAIN, 0x8, 28),
	[PIN_GPIOY_8] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 0),
	[PIN_GPIOY_9] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 4),
	[PIN_GPIOY_10] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 8),
	[PIN_GPIOY_11] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 12),
	[PIN_GPIOY_12] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 16),
	[PIN_GPIOY_13] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 20),
	[PIN_GPIOY_14] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 24),
	[PIN_GPIOY_15] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 28),
};
/*sequence of banks keep same as arch-axg/gpio.h*/
static struct meson_bank mesonaxg_banks[] = {
    /*name   first  last   pullen   pull   dir   out  in*/
	AOBANK("GPIOAO_", GPIOAO_0,   GPIOAO_13,
		0,  16, 0,  0,  0,  0,  0,  16, 1,  0),
	BANK("GPIOZ_",  PIN_GPIOZ_0,  PIN_GPIOZ_10,
		3,  0,  3,  0,  9,  0,  10, 0,  11, 0),
	BANK("BOOT_",	PIN_BOOT_0,   PIN_BOOT_14,
		4,  0,  4,  0,  12, 0,  13, 0,  14, 0),
	BANK("GPIOA_",  PIN_GPIOA_0, PIN_GPIOA_20,
		0,  0,  0,  0,  0,  0,  1,  0,  2,  0),
	BANK("GPIOX_",  PIN_GPIOX_0,  PIN_GPIOX_22,
		2,  0,  2,  0,  6,  0,  7,  0,  8,  0),
	BANK("GPIOY_",  PIN_GPIOY_0,  PIN_GPIOY_15,
		1,  0,  1,  0,  3,  0,  4,  0,  5,  0),
};

U_BOOT_DEVICES(axg_gpios) = {
	{ "gpio_aml", &mesonaxg_banks[0] },
	{ "gpio_aml", &mesonaxg_banks[1] },
	{ "gpio_aml", &mesonaxg_banks[2] },
	{ "gpio_aml", &mesonaxg_banks[3] },
	{ "gpio_aml", &mesonaxg_banks[4] },
	{ "gpio_aml", &mesonaxg_banks[5] },
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
