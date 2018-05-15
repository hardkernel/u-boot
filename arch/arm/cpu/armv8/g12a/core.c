
/*
 * arch/arm/cpu/armv8/g12a/core.c
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

#include <asm/arch/secure_apb.h>
#include <asm/types.h>
#include <asm/arch/cpu.h>
#include <common.h>

const unsigned int core_map[] = {
	0x0,
	0x1,
	0x2,
	0x3,
};

int get_core_mpidr(unsigned int cpuid)
{
	unsigned int coremax = (unsigned int)(sizeof(core_map)/sizeof(unsigned int));

	if (cpuid >= coremax)
		return -1;
	return core_map[cpuid];
}

int get_core_idx(unsigned int mpidr)
{
	unsigned int clusterid, cpuid;

	cpuid = mpidr & 0xff;
	clusterid = mpidr & 0xff00;

	cpuid += (clusterid >> 6);

	if (cpuid >= NR_CPUS)
		return -1;

	return cpuid;
}

int get_core_max(void)
{
	return (sizeof(core_map)/sizeof(unsigned int));
}
