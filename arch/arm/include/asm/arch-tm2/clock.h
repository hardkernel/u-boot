
/*
 * arch/arm/include/asm/arch-txlx/clock.h
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

#ifndef __ARCH_ARM_MESON_CLOCK_H_U_BOOT_
#define __ARCH_ARM_MESON_CLOCK_H_U_BOOT_

/* add define if needed */
#define CLK81                          (7)

#if 0
__u32 get_cpu_clk(void);
__u32 get_clk_ddr(void);
__u32 get_misc_pll_clk(void);
#endif

__u32 get_clk81(void);
int clk_get_rate(unsigned clksrc);
unsigned long clk_util_clk_msr(unsigned long clk_mux);
unsigned long clk_util_ring_msr(unsigned long clk_mux);

int clk_msr(int index);
int ring_msr(int index);

#endif /* __ARCH_ARM_MESON_CLOCK_H_U_BOOT_ */

