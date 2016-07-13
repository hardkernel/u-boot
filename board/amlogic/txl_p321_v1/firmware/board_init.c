
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

#define PNL_PREG_PAD_GPIO1_EN_N           0x0f
#define PNL_PREG_PAD_GPIO1_O              0x10
#define PNL_PREG_PAD_GPIO1_I              0x11

#define PNL_PREG_PAD_GPIO3_EN_N           0x15
#define PNL_PREG_PAD_GPIO3_O              0x16
#define PNL_PREG_PAD_GPIO3_I              0x17

#define PNL_REG_BASE               (0xc8834400L)
#define PNL_REG(reg)               (PNL_REG_BASE + (reg << 2))
#define PNL_REG_R(_reg)            (*(volatile unsigned int *)PNL_REG(_reg))
#define PNL_REG_W(_reg, _value)    *(volatile unsigned int *)PNL_REG(_reg) = (_value);
void panel_power_init(void)
{
	serial_puts("init panel power\n");
	/* GPIOZ_3 */
	PNL_REG_W(PNL_PREG_PAD_GPIO3_O,
		(PNL_REG_R(PNL_PREG_PAD_GPIO3_O) & ~(1 << 3)));
	PNL_REG_W(PNL_PREG_PAD_GPIO3_EN_N,
		(PNL_REG_R(PNL_PREG_PAD_GPIO3_EN_N) & ~(1 << 3)));
	/* GPIOH_4/5/6/7 */
	PNL_REG_W(PNL_PREG_PAD_GPIO1_O,
		(PNL_REG_R(PNL_PREG_PAD_GPIO1_O) & ~(0xf << 24)));
	PNL_REG_W(PNL_PREG_PAD_GPIO1_EN_N,
		(PNL_REG_R(PNL_PREG_PAD_GPIO1_EN_N) & ~(0xf << 24)));

	/* GPIOZ_2/6/7 */
	PNL_REG_W(PNL_PREG_PAD_GPIO3_O,
		(PNL_REG_R(PNL_PREG_PAD_GPIO3_O) & ~((1 << 2) | (0x3 << 6))));
	PNL_REG_W(PNL_PREG_PAD_GPIO3_EN_N,
		(PNL_REG_R(PNL_PREG_PAD_GPIO3_EN_N) & ~((1 << 2) | (0x3 << 6))));
}

#define SEC_AO_SEC_GP_CFG0			(0xda100000 + (0x90 << 2))
static int check_is_ddr_inited(void)
{
	return ((readl(SEC_AO_SEC_GP_CFG0) >> 16) & 0xffff);
}

void board_init(void)
{
	power_init(0);

	//only run once before ddr inited.
	if (!check_is_ddr_inited()) {
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
	}

	panel_power_init();
}
