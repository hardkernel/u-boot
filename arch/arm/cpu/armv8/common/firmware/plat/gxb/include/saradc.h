
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

#ifndef __SARADC_H_
#define __SARADC_H_

#define Wr(reg, val) writel(val, reg)
#define Rd(reg) readl(reg)

#define P_SAR_SAR_ADC_REG0		(volatile unsigned int *)0xc1108680
#define P_SAR_ADC_CHAN_LIST		(volatile unsigned int *)0xc1108684
#define P_SAR_ADC_AVG_CNTL		(volatile unsigned int *)0xc1108688
#define P_SAR_ADC_REG3				(volatile unsigned int *)0xc110868c
#define P_SAR_ADC_DELAY			(volatile unsigned int *)0xc1108690
#define P_SAR_ADC_AUX_SW			(volatile unsigned int *)0xc110869c
#define P_SAR_ADC_CHAN_10_SW		(volatile unsigned int *)0xc11086a0
#define P_SAR_ADC_DETECT_IDLE_SW	(volatile unsigned int *)0xc11086a4
#define P_SAR_ADC_DELTA_11		(volatile unsigned int *)0xc11086a8
#define P_SAR_ADC_TEMP_SES		(volatile unsigned int *)0xc11086ac
#define P_SAR_ADC_CLOCK			(volatile unsigned int *)0xc883c3d8
#define P_SAR_FIFO_READ			(volatile unsigned int *)0xc1108698


unsigned int saradc_ch1_get(void);


#endif /*__BL2_PLL_H_*/
