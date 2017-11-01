/*
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
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
 */

#define P_EE_TIMER_E		(*((volatile unsigned *)(0xffd00000 + (0x3c62 << 2))))
#define P_AO_TIMER_E		(*((volatile unsigned *)(0xff800000 + (0x15 << 2))))
#define P_EE_TIMER_CTRL		(*((volatile unsigned *)(0xff800000 + (0x13 << 2))))
unsigned int get_time(void)
{
	return P_AO_TIMER_E;
}

void _udelay(unsigned int us)
{
	unsigned int t0 = get_time();
	P_EE_TIMER_CTRL |= (0x1 << 4);

	while (get_time() - t0 <= us)
		;
}

