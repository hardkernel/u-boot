
/*
 * arch/arm/cpu/armv8/g12a/gpio.c
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
		[REG_DIR]	= { (0xff634440 + (dr<<2)), db },			\
		[REG_OUT]	= { (0xff634440 + (or<<2)), ob },			\
		[REG_IN]	= { (0xff634440 + (ir<<2)), ib },			\
	},							\
 }
#define AOBANK(n, f, l, per, peb, pr, pb, dr, db, or, ob, ir, ib)		\
{								\
	.name	= n,						\
	.first	= f,						\
	.last	= l,						\
	.regs	= {						\
		[REG_PULLEN]	= { (0xff800024 + (per<<2)), peb },			\
		[REG_PULL]	= { (0xff800024 + (pr<<2)), pb },			\
		[REG_DIR]	= { (0xff800024 + (dr<<2)), db },			\
		[REG_OUT]	= { (0xff800024 + (or<<2)), ob },			\
		[REG_IN]	= { (0xff800024 + (ir<<2)), ib },			\
	},							\
 }

static struct pin_mux_desc pin_to_gpio[] = {
	[GPIOAO(GPIOAO_0)] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 0),
	[GPIOAO(GPIOAO_1)] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 4),
	[GPIOAO(GPIOAO_2)] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 8),
	[GPIOAO(GPIOAO_3)] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 12),
	[GPIOAO(GPIOAO_4)] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 16),
	[GPIOAO(GPIOAO_5)] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 20),
	[GPIOAO(GPIOAO_6)] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 24),
	[GPIOAO(GPIOAO_7)] = PIN_MUX(MUX_AO_DOMAIN, 0x0, 28),
	[GPIOAO(GPIOAO_8)] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 0),
	[GPIOAO(GPIOAO_9)] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 4),
	[GPIOAO(GPIOAO_10)] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 8),
	[GPIOAO(GPIOAO_11)] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 12),
	[GPIOAO(GPIOE_0)] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 16),
	[GPIOAO(GPIOE_1)] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 20),
	[GPIOAO(GPIOE_2)] = PIN_MUX(MUX_AO_DOMAIN, 0x1, 24),
	[GPIOEE(GPIOZ_0)] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 0),
	[GPIOEE(GPIOZ_1)] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 4),
	[GPIOEE(GPIOZ_2)] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 8),
	[GPIOEE(GPIOZ_3)] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 12),
	[GPIOEE(GPIOZ_4)] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 16),
	[GPIOEE(GPIOZ_5)] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 20),
	[GPIOEE(GPIOZ_6)] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 24),
	[GPIOEE(GPIOZ_7)] = PIN_MUX(MUX_EE_DOMAIN, 0x6, 28),
	[GPIOEE(GPIOZ_8)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 0),
	[GPIOEE(GPIOZ_9)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 4),
	[GPIOEE(GPIOZ_10)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 8),
	[GPIOEE(GPIOZ_11)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 12),
	[GPIOEE(GPIOZ_12)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 16),
	[GPIOEE(GPIOZ_13)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 20),
	[GPIOEE(GPIOZ_14)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 24),
	[GPIOEE(GPIOZ_15)] = PIN_MUX(MUX_EE_DOMAIN, 0x7, 28),
	[GPIOEE(GPIOH_0)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 0),
	[GPIOEE(GPIOH_1)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 4),
	[GPIOEE(GPIOH_2)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 8),
	[GPIOEE(GPIOH_3)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 12),
	[GPIOEE(GPIOH_4)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 16),
	[GPIOEE(GPIOH_5)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 20),
	[GPIOEE(GPIOH_6)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 24),
	[GPIOEE(GPIOH_7)] = PIN_MUX(MUX_EE_DOMAIN, 0xb, 28),
	[GPIOEE(GPIOH_8)] = PIN_MUX(MUX_EE_DOMAIN, 0xc, 0),
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
	[GPIOEE(BOOT_13)] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 20),
	[GPIOEE(BOOT_14)] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 24),
	[GPIOEE(BOOT_15)] = PIN_MUX(MUX_EE_DOMAIN, 0x1, 28),
	[GPIOEE(GPIOC_0)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 0),
	[GPIOEE(GPIOC_1)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 4),
	[GPIOEE(GPIOC_2)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 8),
	[GPIOEE(GPIOC_3)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 12),
	[GPIOEE(GPIOC_4)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 16),
	[GPIOEE(GPIOC_5)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 20),
	[GPIOEE(GPIOC_6)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 24),
	[GPIOEE(GPIOC_7)] = PIN_MUX(MUX_EE_DOMAIN, 0x9, 28),
	[GPIOEE(GPIOA_0)] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 0),
	[GPIOEE(GPIOA_1)] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 4),
	[GPIOEE(GPIOA_2)] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 8),
	[GPIOEE(GPIOA_3)] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 12),
	[GPIOEE(GPIOA_4)] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 16),
	[GPIOEE(GPIOA_5)] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 20),
	[GPIOEE(GPIOA_6)] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 24),
	[GPIOEE(GPIOA_7)] = PIN_MUX(MUX_EE_DOMAIN, 0xd, 28),
	[GPIOEE(GPIOA_8)] = PIN_MUX(MUX_EE_DOMAIN, 0xe, 0),
	[GPIOEE(GPIOA_9)] = PIN_MUX(MUX_EE_DOMAIN, 0xe, 4),
	[GPIOEE(GPIOA_10)] = PIN_MUX(MUX_EE_DOMAIN, 0xe, 8),
	[GPIOEE(GPIOA_11)] = PIN_MUX(MUX_EE_DOMAIN, 0xe, 12),
	[GPIOEE(GPIOA_12)] = PIN_MUX(MUX_EE_DOMAIN, 0xe, 16),
	[GPIOEE(GPIOA_13)] = PIN_MUX(MUX_EE_DOMAIN, 0xe, 20),
	[GPIOEE(GPIOA_14)] = PIN_MUX(MUX_EE_DOMAIN, 0xe, 24),
	[GPIOEE(GPIOA_15)] = PIN_MUX(MUX_EE_DOMAIN, 0xe, 28),
	[GPIOEE(GPIOX_0)] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 0),
	[GPIOEE(GPIOX_1)] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 4),
	[GPIOEE(GPIOX_2)] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 8),
	[GPIOEE(GPIOX_3)] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 12),
	[GPIOEE(GPIOX_4)] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 16),
	[GPIOEE(GPIOX_5)] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 20),
	[GPIOEE(GPIOX_6)] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 24),
	[GPIOEE(GPIOX_7)] = PIN_MUX(MUX_EE_DOMAIN, 0x3, 28),
	[GPIOEE(GPIOX_8)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 0),
	[GPIOEE(GPIOX_9)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 4),
	[GPIOEE(GPIOX_10)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 8),
	[GPIOEE(GPIOX_11)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 12),
	[GPIOEE(GPIOX_12)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 16),
	[GPIOEE(GPIOX_13)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 20),
	[GPIOEE(GPIOX_14)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 24),
	[GPIOEE(GPIOX_15)] = PIN_MUX(MUX_EE_DOMAIN, 0x4, 28),
	[GPIOEE(GPIOX_16)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 0),
	[GPIOEE(GPIOX_17)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 4),
	[GPIOEE(GPIOX_18)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 8),
	[GPIOEE(GPIOX_19)] = PIN_MUX(MUX_EE_DOMAIN, 0x5, 12),
};
/*sequence of banks keep same as arch-g12a/gpio.h*/
static struct meson_bank mesontxhd_banks[] = {
    /*name   first  last   pullen   pull   dir   out  in*/
	AOBANK("GPIOAO_", GPIOAO(GPIOAO_0),   GPIOAO(GPIOAO_11),
	3,  0, 2,  0,  0,  0,  4,  0, 1,  0),
	AOBANK("GPIOE_", GPIOAO(GPIOE_0),   GPIOAO(GPIOE_2),
	3,  16, 2,  16,  0,  16,  4,  16, 1,  16),
	BANK("GPIOZ_", GPIOEE(GPIOZ_0), GPIOEE(GPIOZ_15),
	4, 0,  4,  0,  12,  0,  13, 0,  14, 0),
	BANK("GPIOH_", GPIOEE(GPIOH_0), GPIOEE(GPIOH_8),
	3, 0,  3,  0,  9,  0,  10, 0,  11, 0),
	BANK("BOOT_", GPIOEE(BOOT_0), GPIOEE(BOOT_15),
	0, 0,  0,  0,  0,  0,  1, 0,  2, 0),
	BANK("GPIOC_", GPIOEE(GPIOC_0), GPIOEE(GPIOC_7),
	1, 0,  1,  0,  3,  0, 4, 0, 5, 0),
	BANK("GPIOA_", GPIOEE(GPIOA_0), GPIOEE(GPIOA_15),
	5, 0,  5,  0,  16,  0, 17, 0, 18, 0),
	BANK("GPIOX_", GPIOEE(GPIOX_0), GPIOEE(GPIOX_19),
	2, 0,  2,  0,  6,  0, 7, 0, 8, 0),
};

U_BOOT_DEVICES(txhd_gpios) = {
	{ "gpio_aml", &mesontxhd_banks[0] },
	{ "gpio_aml", &mesontxhd_banks[1] },
	{ "gpio_aml", &mesontxhd_banks[2] },
	{ "gpio_aml", &mesontxhd_banks[3] },
	{ "gpio_aml", &mesontxhd_banks[4] },
	{ "gpio_aml", &mesontxhd_banks[5] },
	{ "gpio_aml", &mesontxhd_banks[6] },
	{ "gpio_aml", &mesontxhd_banks[7] },
};

static unsigned long domain[]={
	[MUX_AO_DOMAIN] = 0xff800014,
	[MUX_EE_DOMAIN] = 0xff6346c0,
};

int clear_pinmux(unsigned int pin)
{
	struct pin_mux_desc *pmux_desc = &pin_to_gpio[pin];

	regmap_update_bits(domain[pmux_desc->domain] + (pmux_desc->reg << 2),
			0xf << (pmux_desc->bit), 0 << (pmux_desc->bit));

	return 0;
}

#ifdef CONFIG_AML_SPICC
#include <asm/arch/secure_apb.h>
/* generic pins control for spicc1.
 * if deleted, you have to add it into all g12a board files as necessary.
 * GPIOH_4: MOSI:regB[19:16]=3
 * GPIOH_5: MISO:regB[23:20]=3
 * GPIOH_7: CLK:regB[31:28]=3
 */
int spicc1_pinctrl_enable(bool enable)
{
	unsigned int val;

	val = readl(P_PERIPHS_PIN_MUX_B);
	val &= ~(0xf0ff << 16);
	if (enable)
		val |= 0x3033 << 16;
	writel(val, P_PERIPHS_PIN_MUX_B);
	return 0;
}
#endif /* CONFIG_AML_SPICC */
