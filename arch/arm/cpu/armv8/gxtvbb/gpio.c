
/*
 * arch/arm/cpu/armv8/gxtvbb/gpio.c
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

static unsigned int gpio_to_pin[][11] = {

	[GPIOAO_0] = {PK(AO, 0), PK(AO, 4), NE, NE, NE,
			NE, NE, NE, NE, NE, NE,},
	[GPIOAO_1] = {PK(AO, 1), PK(AO, 5), NE, NE, NE,
			NE, NE, NE, NE, NE, NE,},
	[GPIOAO_2] = {PK(AO, 2), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[GPIOAO_3] = {PK(AO, 3), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[GPIOAO_4] = {NE, PK(AO, 6), PK(AO, 8), PK(AO, 10), NE,
			NE, NE, NE, NE, NE, NE,},
	[GPIOAO_5] = {NE, PK(AO, 7), PK(AO, 9), PK(AO, 11), NE, NE,
			NE, NE, NE, NE, NE,},
	[GPIOAO_6] = {NE, NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[GPIOAO_7] = {PK(AO, 12), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[GPIOAO_8] = {NE, NE, PK(AO, 13), PK(AO, 15), PK(AO, 14),
			NE, NE, NE, NE, NE, NE,},
	[GPIOAO_9] = {NE, NE, PK(AO, 16), PK(AO, 18), PK(AO, 17),
			NE, NE, NE, NE, NE, NE,},
	[GPIOAO_10] = {NE, NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[GPIOAO_11] = {NE, NE, PK(AO, 19), PK(AO, 20), NE, NE, NE,
			NE, NE, NE, NE,},
	[GPIOAO_12] = {NE, NE, PK(AO, 21), PK(AO, 22), NE, NE, NE, NE, NE, NE,
		NE,},
	[GPIOAO_13] = {PK(AO, 23), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},


	[PIN_GPIO_TEST_N] = {PK(AO, 24), PK(AO, 25), PK(AO, 26), PK(AO, 27),
		NE, NE, NE, NE, NE, NE, NE,},


	[PIN_BOOT_0] = {PK(5, 12), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_1] = {PK(5, 12), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_2] = {PK(5, 12), NE, NE, NE, NE, NE, NE, NE,
			PK(9, 18), PK(10, 9), NE,},
	[PIN_BOOT_3] = {PK(5, 12), NE, NE, NE, NE, NE, NE, NE,
			PK(9, 19), PK(10, 9), NE,},
	[PIN_BOOT_4] = {PK(5, 12), NE, NE, NE, NE, NE, NE, NE,
			PK(9, 20), PK(10, 9), NE,},
	[PIN_BOOT_5] = {PK(5, 12), NE, NE, NE, NE, NE, NE, NE,
			PK(9, 21), PK(10, 9), NE,},
	[PIN_BOOT_6] = {PK(5, 12), NE, NE, NE, NE, NE, NE, NE,
			PK(9, 22), PK(10, 9), NE,},
	[PIN_BOOT_7] = {PK(5, 12), NE, NE, NE, NE, NE, NE, NE,
			PK(9, 23), PK(10, 9), NE,},
	/* no boot_8 */
	[PIN_BOOT_9] = {NE, NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	/* no boot_10 */
	[PIN_BOOT_11] = {NE, PK(5, 16), NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_12] = {NE, PK(5, 17), NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_13] = {NE, PK(5, 18), NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_14] = {NE, NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_15] = {PK(5, 13), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_16] = {PK(5, 14), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_17] = {PK(5, 15), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_BOOT_18] = {NE, PK(5, 19), NE, NE, NE, NE, NE, NE, NE, NE, NE,},


	[PIN_CARD_0] = {PK(5, 1), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_CARD_1] = {PK(5, 2), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_CARD_2] = {PK(5, 3), NE, PK(5, 7), NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_CARD_3] = {PK(5, 4), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_CARD_4] = {PK(5, 5), NE, NE, PK(5, 8), PK(5, 9), NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_CARD_5] = {PK(5, 6), NE, NE, PK(5, 10), PK(5, 11), NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_CARD_6] = {NE, NE, NE, NE, NE, NE, NE, NE, NE, PK(10, 9), NE,},
	/* no card_7 */
	/* no card_8 */

	[PIN_GPIOW_0] = {PK(5, 20), PK(5, 22), NE, NE, NE, NE,
			NE, NE, NE, NE, NE,},
	[PIN_GPIOW_1] = {PK(5, 21), PK(5, 23), NE, NE, NE, NE,
			NE, NE, NE, NE, NE,},
	[PIN_GPIOW_2] = {NE, NE, PK(5, 25), PK(5, 26), PK(5, 24),
			PK(5, 27), NE, NE, NE, NE, NE,},
	[PIN_GPIOW_3] = {NE, NE, PK(6, 1), PK(6, 2), PK(6, 0), PK(6, 3),
			PK(6, 4), PK(9, 30), NE, NE, NE,},
	[PIN_GPIOW_4] = {PK(6, 6), PK(6, 5), NE, NE, NE, NE, NE,
			NE, NE, NE, NE,},
	[PIN_GPIOW_5] = {PK(6, 7), NE, NE, NE, NE, NE, NE, NE,
			NE, NE, NE,},
	[PIN_GPIOW_6] = {PK(6, 8), NE, NE, NE, NE, NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOW_7] = {PK(6, 9), PK(10, 1), NE, NE, NE, NE,
			NE, NE, NE, NE, NE,},
	[PIN_GPIOW_8] = {PK(6, 10), PK(6, 11), NE, NE, NE, NE, NE,
			NE, NE, NE, NE,},
	[PIN_GPIOW_9] = {PK(6, 12), NE, NE, NE, NE, NE, NE,
			NE, NE, NE, NE,},
	[PIN_GPIOW_10] = {PK(6, 13), NE, NE, NE, NE, NE, NE,
			NE, NE, NE, NE,},
	[PIN_GPIOW_11] = {PK(6, 14), PK(10, 2), NE, NE, NE, NE,
			NE, NE, NE, NE, NE,},
	[PIN_GPIOW_12] = {PK(6, 15), PK(6, 16), NE, NE, NE, NE,
			NE, NE, NE, NE, NE,},
	[PIN_GPIOW_13] = {PK(6, 17), NE, NE, NE, NE, NE, NE, NE,
			NE, NE, NE,},
	[PIN_GPIOW_14] = {PK(6, 18), NE, NE, NE, NE, NE, NE, NE,
			NE, NE, NE,},
	[PIN_GPIOW_15] = {PK(6, 19), PK(10, 3), NE, NE, NE, NE,
			NE, NE, NE, NE, NE,},
	[PIN_GPIOW_16] = {PK(6, 20), PK(6, 21), NE, NE, NE, NE,
			NE, NE, NE, NE, NE,},
	[PIN_GPIOW_17] = {PK(6, 22), NE, NE, NE, NE, NE, NE,
			NE, NE, NE, NE,},
	[PIN_GPIOW_18] = {PK(6, 23), NE, NE, NE, NE, NE, NE,
			NE, NE, NE, NE,},
	[PIN_GPIOW_19] = {PK(6, 24), PK(10, 4), NE, NE, NE, NE,
			NE, NE, NE, NE, NE,},
	[PIN_GPIOW_20] = {PK(6, 25), PK(6, 26), NE, NE, NE, NE,
			NE, NE,	NE, NE, NE,},


	[PIN_GPIOZ_0] = {PK(8, 5), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_1] = {PK(8, 6), NE, PK(8, 13), NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_2] = {PK(8, 7), PK(8, 11), NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_3] = {PK(8, 8), PK(8, 12), NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_4] = {PK(8, 9), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_5] = {NE, PK(8, 10), NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_6] = {PK(8, 14), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_7] = {PK(8, 15), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_8] = {PK(8, 16), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_9] = {PK(8, 17), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_10] = {PK(8, 18), NE, NE, NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_11] = {PK(8, 19), NE, PK(8, 29), NE, NE, NE, NE, NE, NE,
			PK(10, 9), NE,},
	[PIN_GPIOZ_12] = {PK(8, 20), NE, PK(8, 30), PK(9, 0), NE, NE, NE,
			NE, NE, NE, NE,},
	[PIN_GPIOZ_13] = {NE, PK(8, 21), NE, NE, NE, NE, NE, NE,
			PK(9, 24), NE, NE,},
	[PIN_GPIOZ_14] = {NE, PK(8, 22), NE, NE, PK(9, 1), NE, NE, NE,
			PK(9, 25), NE, NE,},
	[PIN_GPIOZ_15] = {NE, PK(8, 23), NE, NE, NE, NE, NE, NE,
			PK(9, 26), NE, NE,},
	[PIN_GPIOZ_16] = {NE, PK(8, 24), NE, NE, PK(9, 2), NE, NE, NE,
			PK(9, 27), NE, NE,},
	[PIN_GPIOZ_17] = {NE, PK(8, 25), PK(9, 9), PK(9, 3), NE, PK(9, 4),
			PK(9, 7), NE, PK(9, 28), PK(10, 0), NE,},
	[PIN_GPIOZ_18] = {NE, PK(8, 26), PK(9, 10), PK(9, 5), NE, PK(9, 6),
			PK(9, 8), NE, PK(9, 29), PK(10, 0), NE,},
	[PIN_GPIOZ_19] = {NE, PK(8, 27), PK(9, 11), NE, NE, NE, NE, NE, NE,
			PK(10, 0), NE,},
	[PIN_GPIOZ_20] = {NE, PK(8, 28), PK(9, 12), NE, NE, NE, NE, NE, NE,
			PK(10, 0), NE,},


	[PIN_GPIOH_0] = {PK(7, 0), PK(7, 4), PK(7, 15), PK(7, 8), NE,
			NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOH_1] = {PK(7, 1), NE, NE, NE, NE,
			PK(7, 9), PK(7, 10), PK(7, 11), NE, NE, NE,},
	[PIN_GPIOH_2] = {PK(7, 2), NE, NE, NE, NE, NE, NE,
			PK(7, 12), NE, NE, NE,},
	[PIN_GPIOH_3] = {NE, NE, NE, PK(7, 19), PK(7, 6),
			NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOH_4] = {NE, NE, NE, PK(7, 20), PK(7, 7),
			NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOH_5] = {NE, NE, NE, PK(7, 21), PK(7, 23),
			NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOH_6] = {PK(7, 3), PK(7, 5), PK(7, 16), PK(7, 22), PK(7, 24),
			NE, NE, NE, NE, NE, NE,},
	[PIN_GPIOH_7] = {NE, PK(7, 25), PK(7, 17), NE, NE,
			PK(7, 27), PK(7, 28), NE, NE, NE, NE,},
	[PIN_GPIOH_8] = {NE, PK(7, 26), PK(7, 18), NE, NE,
			PK(7, 29), PK(7, 30), NE, NE, NE, NE,},
	[PIN_GPIOH_9] = {PK(8, 3), NE, PK(7, 13), NE, NE,
			PK(7, 31), PK(8, 0), PK(8, 1), NE, NE, NE,},
	[PIN_GPIOH_10] = {PK(8, 4), NE, PK(7, 14), NE, NE, NE, NE,
			PK(8, 2), NE, NE, NE,},


	[PIN_GPIOX_0] = {PK(0, 0), PK(1, 0), PK(0, 23), PK(2, 0), PK(1, 10),
			PK(0, 10), PK(1, 22), PK(1, 24), NE, NE, NE,},
	[PIN_GPIOX_1] = {PK(0, 1), PK(1, 0), PK(0, 23), PK(2, 1), NE,
			PK(0, 11), PK(1, 23), PK(1, 25), NE, NE, NE,},
	[PIN_GPIOX_2] = {PK(0, 2), PK(1, 1), PK(0, 23), PK(2, 2), NE,
			PK(0, 12), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_3] = {PK(0, 3), PK(1, 1), PK(0, 23), PK(2, 3), NE,
			PK(0, 13), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_4] = {PK(0, 4), PK(1, 1), PK(0, 23), PK(2, 4), NE,
			PK(0, 14), PK(1, 18), PK(1, 26), NE, NE, NE,},
	[PIN_GPIOX_5] = {PK(0, 5), PK(1, 1), PK(0, 23), PK(2, 5), NE,
			PK(0, 15), PK(1, 19), PK(1, 27), NE, NE, NE,},
	[PIN_GPIOX_6] = {PK(0, 6), PK(1, 1), PK(0, 23), PK(2, 6), NE,
			PK(0, 16), PK(1, 20), PK(1, 28), NE, NE, NE,},
	[PIN_GPIOX_7] = {PK(0, 7), PK(1, 1), PK(0, 23), PK(2, 7), NE,
			PK(0, 17), PK(1, 21), PK(1, 29), NE, NE, NE,},
	[PIN_GPIOX_8] = {PK(0, 8), PK(1, 2), PK(0, 23), PK(2, 8), PK(1, 11),
			PK(0, 18), NE, NE, NE, NE, NE,},
	[PIN_GPIOX_9] = {PK(0, 9), PK(1, 2), PK(0, 23), PK(2, 9), NE,
			PK(0, 19), PK(2, 18), NE, NE, NE, NE,},
	[PIN_GPIOX_10] = {NE, PK(1, 3), PK(0, 23), PK(2, 10), NE, PK(0, 20),
			PK(2, 20), PK(2, 21), PK(2, 19), PK(3, 29), NE,},
	[PIN_GPIOX_11] = {NE, PK(1, 3), PK(0, 23), PK(2, 11), NE, PK(0, 21),
			PK(2, 23), NE, NE, PK(3, 29), NE,},
	[PIN_GPIOX_12] = {PK(2, 24), PK(1, 3), PK(0, 23), PK(2, 12), NE,
			PK(3, 0), PK(0, 28), NE, NE, PK(3, 29), NE,},
	[PIN_GPIOX_13] = {PK(2, 25), PK(1, 3), PK(0, 23), PK(2, 13), NE,
			PK(3, 1), PK(0, 29), NE, NE, PK(3, 29), NE,},
	[PIN_GPIOX_14] = {PK(2, 26), PK(1, 3), PK(0, 23), PK(2, 14), NE,
			PK(3, 2), PK(0, 30), NE, NE, PK(3, 29), NE,},
	[PIN_GPIOX_15] = {PK(2, 27), PK(1, 3), PK(0, 23), PK(2, 15), NE,
			PK(3, 3), PK(0, 31), NE, NE, PK(3, 29), NE,},
	[PIN_GPIOX_16] = {NE, PK(1, 4), PK(0, 23), PK(2, 16), PK(1, 12),
			PK(3, 4), NE, PK(2, 28), NE, PK(3, 29), NE,},
	[PIN_GPIOX_17] = {NE, PK(1, 4), PK(0, 23), PK(2, 17), NE,
			PK(3, 5), NE, PK(2, 28), NE, PK(3, 29), NE,},
	[PIN_GPIOX_18] = {NE, PK(1, 5), PK(0, 23), NE, NE, PK(3, 6), NE,
			PK(2, 28), NE, PK(3, 29), NE,},
	[PIN_GPIOX_19] = {NE, PK(1, 5), PK(0, 23), NE, NE, PK(3, 7), NE,
			PK(2, 28), NE, PK(3, 29), NE,},
	[PIN_GPIOX_20] = {PK(3, 20), PK(1, 5), PK(0, 23), PK(3, 12), NE,
			PK(3, 8), NE, PK(2, 28), NE, PK(3, 29), NE,},
	[PIN_GPIOX_21] = {PK(3, 21), PK(1, 5), PK(0, 23), PK(3, 13), NE,
			PK(3, 9), PK(3, 17), PK(2, 28), NE, PK(3, 29), NE,},
	[PIN_GPIOX_22] = {NE, PK(1, 5), PK(0, 23), PK(3, 14), NE, PK(3, 10),
			PK(3, 18), PK(2, 28), NE, PK(3, 29), NE,},
	[PIN_GPIOX_23] = {NE, PK(1, 5), PK(0, 23), PK(3, 15), NE,
			PK(3, 11), NE, PK(2, 28), NE, PK(3, 29), NE,},
	[PIN_GPIOX_24] = {NE, PK(1, 6), PK(0, 24), PK(3, 16), PK(1, 13),
			NE, NE, NE, PK(3, 22), PK(3, 29), NE,},
	[PIN_GPIOX_25] = {NE, PK(1, 7), PK(0, 25), NE, PK(1, 14), NE,
			PK(3, 19), NE, PK(3, 23), PK(3, 29), NE,},
	[PIN_GPIOX_26] = {PK(3, 27), NE, PK(0, 26), NE, PK(1, 15), NE,  NE,
			PK(3, 24), PK(3, 25), PK(3, 30), PK(3, 26),},
	[PIN_GPIOX_27] = {PK(3, 28), NE, PK(0, 27), NE, PK(1, 16),
			PK(1, 17), NE, NE, NE, PK(3, 31), NE,},


	[PIN_GPIOY_0] = {NE, NE, NE, PK(10, 26), NE,
			PK(4, 4), NE, NE, NE, NE, NE,},
	[PIN_GPIOY_1] = {NE, NE, NE, PK(10, 27), NE,
			PK(4, 5), NE, PK(4, 0), NE, NE, NE,},
	[PIN_GPIOY_2] = {PK(4, 16), NE, NE, NE, NE, PK(4, 6), NE,
			PK(4, 1), NE, NE, NE,},
	[PIN_GPIOY_3] = {PK(4, 17), NE, NE, NE, NE, PK(4, 7), NE,
			PK(4, 2), PK(4, 18), PK(4, 19), NE,},
	[PIN_GPIOY_4] = {NE, PK(4, 20), NE, NE, NE, PK(4, 8), NE,
			PK(4, 3), NE, NE, NE,},
	[PIN_GPIOY_5] = {NE, PK(4, 21), NE, NE, NE, PK(4, 9), NE,
			PK(4, 3), NE, NE, NE,},
	[PIN_GPIOY_6] = {NE, PK(4, 22), NE, NE, NE, PK(4, 10), NE,
			PK(4, 3), NE, NE, NE,},
	[PIN_GPIOY_7] = {PK(4, 26), PK(4, 23), PK(4, 28), NE, NE,
			PK(4, 11), NE, PK(4, 3), PK(10, 16), PK(10, 17), NE,},
	[PIN_GPIOY_8] = {PK(4, 27), PK(4, 24), PK(4, 29), NE, NE,
			PK(4, 12), NE, PK(4, 3), PK(10, 18), NE, NE,},
	[PIN_GPIOY_9] = {NE, PK(4, 25), NE, NE, NE, PK(4, 13), NE,
			PK(4, 3), PK(10, 19), PK(10, 20), NE,},
	[PIN_GPIOY_10] = {PK(4, 30), NE, PK(10, 10), NE, NE,
			PK(4, 14), NE, PK(4, 3), NE, NE, NE,},
	[PIN_GPIOY_11] = {PK(4, 31), NE, PK(10, 11), NE, NE,
			PK(4, 15), NE, PK(4, 3), NE, NE, NE,},
	[PIN_GPIOY_12] = {PK(10, 12), NE, PK(10, 14), NE, NE, NE, NE, NE,
			PK(10, 21), PK(10, 22), NE,},
	[PIN_GPIOY_13] = {PK(10, 13), NE, PK(10, 15), NE, NE, NE, NE, NE,
			PK(10, 23), PK(10, 24), NE,},


	[PIN_GPIOCLK_0] = {NE, NE, PK(10, 6), NE, NE, NE, NE, NE, NE, NE, NE,},
};

#define BANK(n, f, l, per, peb, pr, pb, dr, db, or, ob, ir, ib)		\
	{								\
		.name	= n,						\
		.first	= f,						\
		.last	= l,						\
		.regs	= {						\
			[REG_PULLEN]	= { (0xc8834520 + (per<<2)), peb },			\
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
	BANK("GPIOW_",	PIN_GPIOW_0,	PIN_GPIOW_20,
			0,		0, /* PULL_UP_EN_REG0	[20-0] */
			0,		0, /* PULL_UP_REG0	[20-0] */
			0,		0, /* gpioW_20~0 : GPIO_REG0[20:0] */
			1,		0,
			2,		0),

	BANK("GPIOH_",	PIN_GPIOH_0,	PIN_GPIOH_10,
			1,		20, /* PULL_UP_EN_REG1	[30-20] */
			1,		20, /* PULL_UP_REG1	[30-20] */
			3,		20, /* gpioH_10~0 : GPIO_REG1[30:20] */
			4,		20,
			5,		20),

	BANK("GPIOY_",	PIN_GPIOY_0,	PIN_GPIOY_13,
			1,		0, /* PULL_UP_EN_REG1	[13-0] */
			1,		0, /* PULL_UP_REG1	[13-0] */
			3,		0, /* gpioY_13~0 : GPIO_REG1[13:0] */
			4,		0,
			5,		0),

	BANK("CARD_",	PIN_CARD_0,	PIN_CARD_6,
			2,		20, /* PULL_UP_EN_REG2	[26-20] */
			2,		20, /* PULL_UP_REG2	[26-20] */
			6,		20, /* card_6~0 : GPIO_REG2[26:20] */
			7,		20,
			8,		20),

	BANK("BOOT_",	PIN_BOOT_0,	PIN_BOOT_18,
			2,		0, /* PULL_UP_EN_REG2	[18-0] */
			2,		0, /* PULL_UP_REG2	[18-0] */
			6,		0, /* boot_18~0 : GPIO_REG2[18:0] */
			7,		0, /* (no boot_8 and boot_10) */
			8,		0),

	BANK("GPIOCLK_",	PIN_GPIOCLK_0,	PIN_GPIOCLK_0,
			3,		24, /* PULL_UP_EN_REG3	[24] */
			3,		24, /* PULL_UP_REG3	[24] */
			9,		24, /* gpioCLK0 : GPIO_REG3[24] */
			10,		24,
			11,		24),

	BANK("GPIOZ_",	PIN_GPIOZ_0,	PIN_GPIOZ_20,
			3,		0, /* PULL_UP_EN_REG3	[20-0] */
			3,		0, /* PULL_UP_REG3	[20-0] */
			9,		0, /* gpioZ_20~0 : GPIO_REG3[20:0] */
			10,		0,
			11,		0),

	BANK("GPIOX_",	PIN_GPIOX_0,	PIN_GPIOX_27,
			4,		0, /* PULL_UP_EN_REG4	[27-0] */
			4,		0, /* PULL_UP_REG4	[27-0] */
			12,		0, /* gpioX_27~0 : GPIO_REG4[27:0] */
			13,		0,
			14,		0),

	AOBANK("GPIOAO_",	GPIOAO_0,	GPIOAO_13,
			0,		0,  /* AO_RTI_PULL_UP_REG [13-0] */
			0,		16, /* AO_RTI_PULL_UP_REG [29-16] */
			0,		0,  /* O_GPIO_O_EN_N [29-16] */
			0,		16, /* O_GPIO_O_EN_N [13-0] */
			1,		0), /* AO_GPIO_I */

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


