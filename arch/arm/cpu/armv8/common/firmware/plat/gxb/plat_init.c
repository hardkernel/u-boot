
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/plat_init.c
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

#include <io.h>
#include <stdio.h>
#include <stdint.h>
#include <timer.h>
#include <asm/arch/secure_apb.h>

void pinmux_init(void) {
	//detect sdio debug board
	unsigned pinmux_2 = readl(P_PERIPHS_PIN_MUX_2);
	// clear sdio pinmux
	setbits_le32(P_PREG_PAD_GPIO2_O,0x3f<<20);
	setbits_le32(P_PREG_PAD_GPIO2_EN_N,0x3f<<20);
	clrbits_le32(P_PERIPHS_PIN_MUX_2,7<<12);  //clear sd d1~d3 pinmux
	if (!(readl(P_PREG_PAD_GPIO2_I)&(1<<24))) {  //sd_d3 low, debug board in
		clrbits_le32(P_AO_RTI_PIN_MUX_REG,3<<11);   //clear AO uart pinmux
		setbits_le32(P_PERIPHS_PIN_MUX_8,3<<9);
		serial_puts("\nsdio debug board detected ");
	}
	else{
		writel(pinmux_2,P_PERIPHS_PIN_MUX_2);
		serial_puts("\nno sdio debug board detected ");
	}
}