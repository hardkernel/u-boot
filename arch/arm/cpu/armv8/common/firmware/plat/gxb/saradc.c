
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/saradc.c
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

#include <string.h>
#include <stdio.h>
#include <saradc.h>
#include <asm/arch/secure_apb.h>
#include <timer.h>

#define 	SAMP_COUNT			9
const unsigned int  sam_val[SAMP_COUNT] = {0,  0x80, 0x100, 0x180, 0x200, 0x280, 0x300, 0x380, 0x400};

unsigned int saradc_ch1_get(void)
{
	unsigned int val = 0;
	unsigned int cnt=0;
	unsigned int idx=0;

	Wr(P_SAR_ADC_CHAN_LIST, 		0x00000001);	//
	Wr(P_SAR_ADC_AVG_CNTL,  		0x00003000);
	Wr(P_SAR_ADC_REG3,  			0xc3a8500a);
	Wr(P_SAR_ADC_DELAY,  		0x010a000a);
	Wr(P_SAR_ADC_AUX_SW,  	 	0x03eb1a0c);
	Wr(P_SAR_ADC_CHAN_10_SW, 	0x008c000c);
	Wr(P_SAR_ADC_DETECT_IDLE_SW, 	0x008e038c);
	Wr(P_SAR_ADC_DELTA_11,  		0x0c00c400);
	Wr(P_SAR_ADC_CLOCK,  		0x00000114);
	Wr(P_SAR_ADC_TEMP_SES, 		0x00002000);
	Wr(P_SAR_SAR_ADC_REG0, 		0x84064040);
	_udelay(20);
	Wr(P_SAR_SAR_ADC_REG0, 		0x84064041);
	_udelay(20);
	Wr(P_SAR_SAR_ADC_REG0, 		0x84064045);
	_udelay(20);

	while ( (  Rd(P_SAR_SAR_ADC_REG0)& 0x70000000) && (cnt++ <100)) ;
	if (cnt >= 100)
		printf(" Get saradc sample Error. Cnt_%d \n", cnt);
	val = Rd(P_SAR_FIFO_READ) & 0x3ff;
	for (idx=0; idx<SAMP_COUNT; idx++)
	{
		if (val <= sam_val[idx]+0x3f)
			break;
	}

	Wr(SEC_AO_SEC_GP_CFG0, ((Rd(SEC_AO_SEC_GP_CFG0) & 0xFFFF00ff) | (idx << 8)));
	printf("Board ID = %d\n", idx);
	return idx;
}

