
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
#include <io.h>

#ifndef __BL2_PLL_H_
#define __BL2_PLL_H_

#define PLL_lOCK_CHECK_LOOP 10
#define PLL_LOCK_BIT_OFFSET 31

#define Wr(reg, val) writel(val, reg)
#define Rd(reg) readl(reg)

#define CFG_SYS_PLL_CNTL_2 (0x5ac80000)
#define CFG_SYS_PLL_CNTL_3 (0x8e452015)
#define CFG_SYS_PLL_CNTL_4 (0x0401d40c)
#define CFG_SYS_PLL_CNTL_5 (0x00000870)

#define CFG_MPLL_CNTL_2 (0x59C80000)
#define CFG_MPLL_CNTL_3 (0xCA45B822)
#define CFG_MPLL_CNTL_4 (0x00018007)
#define CFG_MPLL_CNTL_5 (0xB5500E1A)
#define CFG_MPLL_CNTL_6 (0xFC454545)
#define CFG_MPLL_CNTL_7 (0)
#define CFG_MPLL_CNTL_8 (0)
#define CFG_MPLL_CNTL_9 (0)

//DDR PLL
#define CFG_DDR_PLL_CNTL_1 (0x69c80000)
#define CFG_DDR_PLL_CNTL_2 (0xca463823)
#define CFG_DDR_PLL_CNTL_3 (0x00c00023)
#define CFG_DDR_PLL_CNTL_4 (0x00303500)

unsigned int pll_init(void);
void clocks_set_sys_cpu_clk(uint32_t freq, \
	uint32_t pclk_ratio, \
	uint32_t aclkm_ratio, \
	uint32_t atclk_ratio );
unsigned pll_lock_check(unsigned long pll_reg, const char *pll_name);

#endif /*__BL2_PLL_H_*/