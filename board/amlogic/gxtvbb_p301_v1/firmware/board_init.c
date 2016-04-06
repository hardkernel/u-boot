
/*
 * board/amlogic/gxtvbb_p301_v1/firmware/board_init.c
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

#include "power.c"

/* bl2 customer code */

#define PNL_AO_GPIO_O_EN_N                0x09
#define PNL_AO_GPIO_I                     0x0a

#define PNL_PREG_PAD_GPIO1_EN_N           0x0f
#define PNL_PREG_PAD_GPIO1_O              0x10
#define PNL_PREG_PAD_GPIO1_I              0x11

#define PNL_PREG_PAD_GPIO4_EN_N           0x18
#define PNL_PREG_PAD_GPIO4_O              0x19
#define PNL_PREG_PAD_GPIO4_I              0x1a

#define PNL_REG_BASE               (0xc8834400L)
#define PNL_REG(reg)               (PNL_REG_BASE + (reg << 2))
#define PNL_REG_R(_reg)            (*(volatile unsigned int *)PNL_REG(_reg))
#define PNL_REG_W(_reg, _value)    *(volatile unsigned int *)PNL_REG(_reg) = (_value);
void panel_power_init(void)
{
	serial_puts("init panel power\n");
	/* GPIOX_3 */
	PNL_REG_W(PNL_PREG_PAD_GPIO4_O,
		(PNL_REG_R(PNL_PREG_PAD_GPIO4_O) & ~(1 << 3)));
	PNL_REG_W(PNL_PREG_PAD_GPIO4_EN_N,
		(PNL_REG_R(PNL_PREG_PAD_GPIO4_EN_N) & ~(1 << 3)));
	/* GPIOH_0 */
/*	PNL_REG_W(PNL_PREG_PAD_GPIO1_O,
		(PNL_REG_R(PNL_PREG_PAD_GPIO1_O) & ~(1 << 20)));
	PNL_REG_W(PNL_PREG_PAD_GPIO1_EN_N,
		(PNL_REG_R(PNL_PREG_PAD_GPIO1_EN_N) & ~(1 << 20)));
*/
	/* GPIOAO_4 */
	PNL_REG_W(PNL_AO_GPIO_O_EN_N,
		(PNL_REG_R(PNL_AO_GPIO_O_EN_N) & ~(1 << 20)));
	PNL_REG_W(PNL_AO_GPIO_O_EN_N,
		(PNL_REG_R(PNL_AO_GPIO_O_EN_N) & ~(1 << 4)));
	/* GPIOY_13 */
	PNL_REG_W(PNL_PREG_PAD_GPIO1_O,
		(PNL_REG_R(PNL_PREG_PAD_GPIO1_O) & ~(1 << 13)));
	PNL_REG_W(PNL_PREG_PAD_GPIO1_EN_N,
		(PNL_REG_R(PNL_PREG_PAD_GPIO1_EN_N) & ~(1 << 13)));
}

void board_init(void)
{
	power_init(0);

	/* dram 1.5V reset */
	serial_puts("DRAM reset...\n");
	/* power off ddr */
	//aml_update_bits(P_AO_GPIO_O_EN_N, 1 << 3, 0);
	//aml_update_bits(P_AO_GPIO_O_EN_N, 1 << 19, 0);
	writel((readl(P_AO_GPIO_O_EN_N) & (~((1 << 3) | (1 << 19)))),P_AO_GPIO_O_EN_N);
	/* need delay */
	_udelay(40000);
	/* power on ddr */
	//aml_update_bits(P_AO_GPIO_O_EN_N, 1 << 3, 0);
	//aml_update_bits(P_AO_GPIO_O_EN_N, 1 << 19, 1 << 19);
	writel((readl(P_AO_GPIO_O_EN_N) | (1 << 19)),P_AO_GPIO_O_EN_N);

	panel_power_init();
}
