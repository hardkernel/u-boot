
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
}
