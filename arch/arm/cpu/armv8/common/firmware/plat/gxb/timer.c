
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/timer.c
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
#include <asm/arch/romboot.h>
#include <timer.h>

#define P_EE_TIMER_E		P_ISA_TIMERE

uint32_t time_start = 0;
uint32_t time_end = 0;

uint32_t get_time(void)
{
	return readl(P_EE_TIMER_E);
}

void _udelay(unsigned int us)
{
	uint32_t t0 = get_time();

	while (get_time() - t0 <= us)
		;
}

void timer_start(void)
{
	time_start = get_time();
}

void timer_end(const char * name)
{
	time_end = get_time();
	printf("%s Time: %d us\n", name, (time_end - time_start));
}