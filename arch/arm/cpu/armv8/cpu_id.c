
/*
 * arch/arm/cpu/armv8/cpu_id.c
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

#include <asm/cpu_id.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/io.h>

cpu_id_t get_cpu_id(void) {
	cpu_id_t cpu_id;
	unsigned int cpu_id_reg = readl(P_AO_SEC_SD_CFG8);
	cpu_id.family_id = (cpu_id_reg >> 24) & (0XFF);
	cpu_id.package_id = (cpu_id_reg >> 16) & (0XF0);
	cpu_id.chip_rev = (cpu_id_reg >> 8) & (0XFF);
	cpu_id.layout_ver = (cpu_id_reg) & (0XF);
	return cpu_id;
}
