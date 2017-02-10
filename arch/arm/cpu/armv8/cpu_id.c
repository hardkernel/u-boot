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

#include <common.h>
#include <asm/cpu_id.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/io.h>

/**
 * TODO: This should be moved to a RO region of registers or SRAM that
 * provides static system information that's needed across all software
 *
 * Chip ID copy to avoid unnecessary message exchange.
 */
chip_id_t aml_chip_id = { 0, { 0 } };

cpu_id_t get_cpu_id(void)
{
	cpu_id_t cpu_id;
	unsigned int cpu_id_reg = readl(P_AO_SEC_SD_CFG8);

	cpu_id.family_id = (cpu_id_reg >> 24) & (0XFF);
	cpu_id.package_id = (cpu_id_reg >> 16) & (0XF0);
	cpu_id.chip_rev = (cpu_id_reg >> 8) & (0XFF);
	cpu_id.layout_ver = (cpu_id_reg) & (0XF);
	return cpu_id;
}

int get_chip_id(unsigned char *buff, unsigned int size)
{
	int rc = 0;

	if (buff == NULL || size < 16)
		return -1;

	if (aml_chip_id.version == 0) {
		/* Chip ID has not been fetched yet */
		rc = __get_chip_id(&aml_chip_id.chipid[0], 16);

		/* Mark version if chip ID is fetched successfully */
		if (rc == 0)
			aml_chip_id.version = 2;
	}

	memcpy(buff, &aml_chip_id.chipid[0], 16);
	return rc;
}
