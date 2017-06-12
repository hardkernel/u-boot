/*
 * arch/arm/cpu/armv8/axg/irblaster.c
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

#include <asm/arch/io.h>
#include <asm/cpu_id.h>
#include <common.h>
#include <config.h>
#include <asm/arch/secure_apb.h>

void irblaster_pinmux_config(void)
{
	int val;

	/*GPIOAO_7|REMOTE_INPUT-ao_reg0|REMOTE_OUTPUT-ao_reg21*/
	val = (readl(AO_RTI_PIN_MUX_REG) & ~(1 << 0)) | (1 <<21);
	writel(val, AO_RTI_PIN_MUX_REG);
	printf("gxl config irblaster pinmux well\n");

}
