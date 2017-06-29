
/*
 * arch/arm/cpu/armv8/txl/gate_init.c
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

#include "power_gate.h"

void save_power_post(void)
{
	/* Close clk81 useless gate
	 * please refer to clock tree doc for more details
	 */
	/*Leave audio & USB general gate for kernel boot up*/
	clrbits_le32(P_HHI_GCLK_MPEG0, 0xb1777c1a);
	clrbits_le32(P_HHI_GCLK_MPEG1, 0x1b7ffffe);
	clrbits_le32(P_HHI_GCLK_MPEG2, 0xbbfff7f9);

	/*Close PCIE PHY and PCIE PLL*/
	setbits_le32(P_EE_PCIE_PHY_CTRL, 1 << 0);
	clrbits_le32(P_HHI_PCIE_PLL_CNTL, 0xffffffff);
	clrbits_le32(P_HHI_PCIE_PLL_CNTL6, 0xffffffff);
	/*Close USB*/
	/*writel(0x652069,0xffe09020);*/
	setbits_le32(0xffe09020, 1 << 22);
}

void ee_gate_off(void)
{
	printf("save_power_post ...\n");
	save_power_post();
	return;
}

void ee_gate_on(void)
{
	return;
}

