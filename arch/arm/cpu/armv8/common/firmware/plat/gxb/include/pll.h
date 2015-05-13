
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/include/pll.h
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

#include <stdint.h>

#ifndef __BL2_PLL_H_
#define __BL2_PLL_H_

#define PLL_lOCK_CHECK_LOOP 100
#define PLL_LOCK_BIT_OFFSET 31

unsigned int pll_init(void);
void clocks_set_sys_cpu_clk(uint32_t freq, \
	uint32_t pclk_ratio, \
	uint32_t aclkm_ratio, \
	uint32_t atclk_ratio );
unsigned pll_lock_check(unsigned long pll_reg, const char *pll_name);

#endif /*__BL2_PLL_H_*/