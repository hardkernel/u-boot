/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 *
 * Amlogic PLL module
 * Author: xiaobo.gu@amlogic.com
 * Created time: 2015.04.30
 *
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