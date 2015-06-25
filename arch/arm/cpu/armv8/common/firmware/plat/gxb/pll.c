
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/pll.c
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

#include <pll.h>
#include <string.h>
#include <asm/arch/watchdog.h>
#include <stdio.h>
#include <asm/arch/secure_apb.h>
#include <timer.h>
#include <stdio.h>
#include <asm/arch/timing.h>

unsigned lock_check_loop = 0;
extern pll_set_t __pll_setting;
static pll_set_t * p_pll_set = &__pll_setting;

unsigned int pll_init(void){
	// Switch clk81 to the oscillator input
	// romcode might have already programmed clk81 to a PLL
	Wr( HHI_MPEG_CLK_CNTL, Rd(HHI_MPEG_CLK_CNTL) & ~(1 << 8) );
	// Switch sys clk to oscillator, the SYS CPU might have already been programmed
	clocks_set_sys_cpu_clk( 0, 0, 0, 0);

	//SYS PLL,FIX PLL bangap
	Wr(HHI_MPLL_CNTL6, Rd(HHI_MPLL_CNTL6)|(1<<26));
	_udelay(100);

	unsigned int sys_pll_cntl = 0;
	if ((p_pll_set->cpu_clk >= 600) && (p_pll_set->cpu_clk <= 1200)) {
		sys_pll_cntl = (1<<16/*OD*/) | (1<<9/*N*/) | (p_pll_set->cpu_clk / 12/*M*/);
	}
	else if ((p_pll_set->cpu_clk > 1200) && (p_pll_set->cpu_clk <= 2000)) {
		sys_pll_cntl = (0<<16/*OD*/) | (1<<9/*N*/) | (p_pll_set->cpu_clk / 24/*M*/);
	}
	//Init SYS pll
	do {
		Wr(HHI_SYS_PLL_CNTL, Rd(HHI_SYS_PLL_CNTL)|(1<<29));
		Wr(HHI_SYS_PLL_CNTL2, CFG_SYS_PLL_CNTL_2);
		Wr(HHI_SYS_PLL_CNTL3, CFG_SYS_PLL_CNTL_3);
		Wr(HHI_SYS_PLL_CNTL4, CFG_SYS_PLL_CNTL_4);
		Wr(HHI_SYS_PLL_CNTL5, CFG_SYS_PLL_CNTL_5);
		Wr(HHI_SYS_PLL_CNTL, ((1<<30)|(1<<29)|sys_pll_cntl)); // A9 clock
		Wr(HHI_SYS_PLL_CNTL, Rd(HHI_SYS_PLL_CNTL)&(~(1<<29)));
		_udelay(20);
	} while(pll_lock_check(HHI_SYS_PLL_CNTL, "SYS PLL"));
	clocks_set_sys_cpu_clk( 1, 0, 0, 0); // Connect SYS CPU to the PLL divider output

	sys_pll_cntl = Rd(HHI_SYS_PLL_CNTL);
	/* cpu clk = 24/N*M/2^OD */
	printf("CPU clk: %dMHz\n", \
		(24/ \
		((sys_pll_cntl>>9)&0x1F)* \
		(sys_pll_cntl&0x1FF)/ \
		(1<<((sys_pll_cntl>>16)&0x3))));

	//FIXED PLL
	Wr(HHI_MPLL_CNTL4, CFG_MPLL_CNTL_4);
	Wr(HHI_MPLL_CNTL, Rd(HHI_MPLL_CNTL)|(1<<29));
	_udelay(200);
	Wr(HHI_MPLL_CNTL2, CFG_MPLL_CNTL_2);
	Wr(HHI_MPLL_CNTL3, CFG_MPLL_CNTL_3);
	//Wr(HHI_MPLL_CNTL4, CFG_MPLL_CNTL_4);
	Wr(HHI_MPLL_CNTL5, CFG_MPLL_CNTL_5);
	Wr(HHI_MPLL_CNTL6, CFG_MPLL_CNTL_6);
	Wr(HHI_MPLL_CNTL, ((1 << 30) | (1<<29) | (3 << 9) | (250 << 0)) );
	Wr(HHI_MPLL_CNTL, Rd(HHI_MPLL_CNTL)&(~(1<<29)));	//set reset bit to 0
	_udelay(800);
	Wr(HHI_MPLL_CNTL4, Rd(HHI_MPLL_CNTL4)|(1<<14));
	do {
		if ((Rd(HHI_MPLL_CNTL)&(1<<31)) != 0)
			break;
		Wr(HHI_MPLL_CNTL,Rd(HHI_MPLL_CNTL) | (1<<29));
		_udelay(1000);
		Wr(HHI_MPLL_CNTL, Rd(HHI_MPLL_CNTL)&(~(1<<29)));
		_udelay(1000);
	}while(pll_lock_check(HHI_MPLL_CNTL, "FIX PLL"));

	// Enable the separate fclk_div2 and fclk_div3
	//		.MPLL_CLK_OUT_DIV2_EN		( hi_mpll_cntl10[7:0]		),
	//		.MPLL_CLK_OUT_DIV3_EN		( hi_mpll_cntl10[11:8]		),
	Wr( HHI_MPLL_CNTL10, (0xFFF << 16) );

	// -------------------------------
	// Set Multi-Phase PLL0 = 350Mhz
	// -------------------------------
	Wr( HHI_MPLL_CNTL7, ((7 << 16) | (1 << 15) | (1 << 14) | (4681 << 0)) );

	// -------------------------
	// set CLK81 to 166.6Mhz Fixed
	// -------------------------
	Wr( HHI_MPEG_CLK_CNTL, ((Rd(HHI_MPEG_CLK_CNTL) & (~((0x7 << 12) | (1 << 7) | (0x7F << 0)))) | ((5 << 12) | (1 << 7)	| (2 << 0))) );
	// Connect clk81 to the PLL divider output
	Wr( HHI_MPEG_CLK_CNTL, Rd(HHI_MPEG_CLK_CNTL) | (1 << 8) );

	// -------------------------------
	// Set Multi-Phase PLL1 = 442.368 Mhz
	// -------------------------------
	//											+----------------------------------------+
	//											|		 <<< Clock Reset Test >>>		|
	//	+-------------------------------------+ +------+-----------+---------------------+	+------------
	//	|		 Multi-Phase PLL			 | | CRT	|	 Final |				Ideal	|	| HIU Reg
	//	|	FIn	|	N2	SDM_IN |		CLKMP | |	XD	|	 Clock |	Error	 Clock	|	| 0x10a7
	//	+---------+--------------+------------| |------+-----------+---------------------+	+------------
	//	| 24.0000 |	5	 12524 |	442.3701 | |	1	|	442.3701 |	0.000% ( 442.368) |	| 0x0005f0ec
	//		.MPLL_SDM_IN1			( hi_mpll_cntl8[13:0]	),
	//		.MPLL_CH1_EN			( hi_mpll_cntl8[14]	 ),
	//		.MPLL_SDM_EN1			( hi_mpll_cntl8[15]	 ),
	//		.MPLL_N_IN1			 ( hi_mpll_cntl8[22:16]	),
	//		.MPLL_I160CTR1			( hi_mpll_cntl8[25:24]	),
	//		.MPLL_R_SW1			 ( hi_mpll_cntl8[27:26]	),
	Wr( HHI_MPLL_CNTL8, ((5 << 16) | (1 << 15) | (1 << 14) | (12524 << 0)) );

	return 0;
}

// --------------------------------------------------
//				clocks_set_sys_cpu_clk
// --------------------------------------------------
// This function sets the System CPU clock muxing and the
// sub-clocks related to the System CPU (AXI, PCLK,...)
//
// Parameters:
//		freq:
//						0:	24Mhz Crystal
//						1:	System PLL
//						1275, 850, 637,....
//		pclk_ratio:	 0 = no change to the existing setting.	2,3,...8 = the clock ratio relative to the system CPU clock
//		aclkm_ratio:	0 = no change to the existing setting.	2,3,...8 = the clock ratio relative to the system CPU clock
//		atclk_ratio:	0 = no change to the existing setting.	2,3,...8 = the clock ratio relative to the system CPU clock
// --------------------------------
//	freq = 0:	24Mhz Crystal
//	freq = 1:	System PLL
//	freq = 1000, 667, 500, 333, 250...
// Pass 0 to pclk_ratio or aclkm_ratio or atclk_ratio if nothing changes
void clocks_set_sys_cpu_clk(uint32_t freq, uint32_t pclk_ratio, uint32_t aclkm_ratio, uint32_t atclk_ratio )
{
	uint32_t	control = 0;
	uint32_t	dyn_pre_mux = 0;
	uint32_t	dyn_post_mux = 0;
	uint32_t	dyn_div = 0;

	// Make sure not busy from last setting and we currently match the last setting
	do {
		control = Rd(HHI_SYS_CPU_CLK_CNTL);
	} while( (control & (1 << 28)) );

	control = control | (1 << 26);				// Enable

	// Switching to System PLL...just change the final mux
	if ( freq == 1 ) {
		// wire			cntl_final_mux_sel		= control[11];
		control = control | (1 << 11);
	} else {
		switch ( freq ) {
			case	0:		// If Crystal
							dyn_pre_mux		= 0;
							dyn_post_mux	= 0;
							dyn_div			= 0;	// divide by 1
							break;
			case	1000:	// fclk_div2
							dyn_pre_mux		= 1;
							dyn_post_mux	= 0;
							dyn_div			= 0;	// divide by 1
							break;
			case	667:	// fclk_div3
							dyn_pre_mux		= 2;
							dyn_post_mux	= 0;
							dyn_div			= 0;	// divide by 1
							break;
			case	500:	// fclk_div2/2
							dyn_pre_mux		= 1;
							dyn_post_mux	= 1;
							dyn_div			= 1;	// Divide by 2
							break;
			case	333:	// fclk_div3/2
							dyn_pre_mux		= 2;
							dyn_post_mux	= 1;
							dyn_div			= 1;	// divide by 2
							break;
			case	250:	// fclk_div2/4
							dyn_pre_mux		= 1;
							dyn_post_mux	= 1;
							dyn_div			= 3;	// divide by 4
							break;
		}
		if ( control & (1 << 10) ) { 	// if using Dyn mux1, set dyn mux 0
			// Toggle bit[10] indicating a dynamic mux change
			control = (control & ~((1 << 10) | (0x3f << 4)	| (1 << 2)	| (0x3 << 0)))
					| ((0 << 10)
					| (dyn_div << 4)
					| (dyn_post_mux << 2)
					| (dyn_pre_mux << 0));
		} else {
			// Toggle bit[10] indicating a dynamic mux change
			control = (control & ~((1 << 10) | (0x3f << 20) | (1 << 18) | (0x3 << 16)))
					| ((1 << 10)
					| (dyn_div << 20)
					| (dyn_post_mux << 18)
					| (dyn_pre_mux << 16));
		}
		// Select Dynamic mux
		control = control & ~(1 << 11);
	}
	Wr(HHI_SYS_CPU_CLK_CNTL,control);
	//
	// Now set the divided clocks related to the System CPU
	//
	// This function changes the clock ratios for the
	// PCLK, ACLKM (AXI) and ATCLK
	//		.clk_clken0_i	( {clk_div2_en,clk_div2}	),
	//		.clk_clken1_i	( {clk_div3_en,clk_div3}	),
	//		.clk_clken2_i	( {clk_div4_en,clk_div4}	),
	//		.clk_clken3_i	( {clk_div5_en,clk_div5}	),
	//		.clk_clken4_i	( {clk_div6_en,clk_div6}	),
	//		.clk_clken5_i	( {clk_div7_en,clk_div7}	),
	//		.clk_clken6_i	( {clk_div8_en,clk_div8}	),

	uint32_t	control1 = Rd(HHI_SYS_CPU_CLK_CNTL1);

	//		.cntl_PCLK_mux				( hi_sys_cpu_clk_cntl1[5:3]	 ),
	if ( (pclk_ratio >= 2) && (pclk_ratio <= 8) ) { control1 = (control1 & ~(0x7 << 3)) | ((pclk_ratio-2) << 3) ; }
	//		.cntl_ACLKM_clk_mux		 ( hi_sys_cpu_clk_cntl1[11:9]	),	// AXI matrix
	if ( (aclkm_ratio >= 2) && (aclkm_ratio <= 8) ) { control1 = (control1 & ~(0x7 << 9)) | ((aclkm_ratio-2) << 9) ; }
	//		.cntl_ATCLK_clk_mux		 ( hi_sys_cpu_clk_cntl1[8:6]	 ),
	if ( (atclk_ratio >= 2) && (atclk_ratio <= 8) ) { control1 = (control1 & ~(0x7 << 6)) | ((atclk_ratio-2) << 6) ; }
	Wr( HHI_SYS_CPU_CLK_CNTL1, control1 );
}

unsigned pll_lock_check(unsigned long pll_reg, const char *pll_name){
	/*locked: return 0, else return 1*/
	unsigned lock = ((Rd(pll_reg) >> PLL_LOCK_BIT_OFFSET) & 0x1);
	if (lock) {
		lock_check_loop = 0;
		//printf("%s lock ok!\n", pll_name);
	}
	else{
		lock_check_loop++;
		printf("%s lock check %d\n", pll_name, lock_check_loop);
		if (lock_check_loop >= PLL_lOCK_CHECK_LOOP) {
			printf("%s lock failed! reset...\n", pll_name);
			reset_system();
			while (1) ;
		}
	}
	return !lock;
}