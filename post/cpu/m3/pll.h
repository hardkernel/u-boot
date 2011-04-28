/*
 *  arch/arm/mach-meson/include/mach/clock.h
 *
 *  Copyright (C) 2010 AMLOGIC, INC.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#ifndef __ARCH_ARM_MESON_SYSTEST_PLL_H_U_BOOT_
#define __ARCH_ARM_MESON_SYSTEST_PLL_H_U_BOOT_
#include <common.h>
#include <asm/arch/io.h>
#include <asm/types.h>

struct pll_param{
	unsigned M;
	unsigned N;
	unsigned OD;
	unsigned XD;
};

struct range{
	unsigned  min;
	unsigned max;
};

struct clk {
	unsigned middle;  //MHz
	
	struct range N_range;
	struct range M_range;
	struct range OD_range;
	struct range XD_range;
	
	struct range Fref;
	struct range Fvco;
		
	void (*pll_set)(unsigned n, unsigned m, unsigned od, unsigned xd);

};

struct clk_lookup{
	const char *dev_id;
	struct clk *pclk;
	int (*pll_test)(void);
};

struct test_info {
	unsigned M;
	unsigned N;
	unsigned OD;
	unsigned XD;
	unsigned long freq;
};

#endif
