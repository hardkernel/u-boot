
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/ddr/ddr.c
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

#include <stdio.h>
#include "ddr_pctl_define.h"
#include "ddr_pub_define.h"
#include "dmc_define.h"
#include "mmc_define.h"
#include "sec_mmc_define.h"
#include <timer.h>
#include <asm/arch/ddr.h>
#include <asm/arch/secure_apb.h>
#include <pll.h>
#include <config.h>
#include <asm/arch/cpu.h>
#include <asm/arch/timing.h>
#include <memtest.h>
#include <asm/arch/watchdog.h>
#include <cache.h>
#include "timing.c"

static ddr_set_t * p_ddr_set = &__ddr_setting;
static ddr_timing_t * p_ddr_timing = NULL;
static unsigned int ddr0_enabled;
static unsigned int ddr1_enabled;

unsigned int ddr_init(void){
	/*detect hot boot or cold boot*/
	//if(hot_boot()){
	//	printf("hot boot, skip ddr init!\n");
	//	return 0;
	//}

	ddr_init_pll();
	ddr_pre_init();
	ddr_init_pctl();
	ddr_init_dmc();
	ddr_print_info();
	ddr_test();
	return 0;
}

unsigned int ddr_init_pll(void){
	wr_reg(P_AM_ANALOG_TOP_REG1, rd_reg(P_AM_ANALOG_TOP_REG1) | (1<<0));
	wr_reg(P_HHI_MPLL_CNTL5, rd_reg(P_HHI_MPLL_CNTL5) | (1<<0));

	/* DDR PLL BANDGAP */
	wr_reg(AM_DDR_PLL_CNTL4, rd_reg(AM_DDR_PLL_CNTL4) & (~(1<<12)));
	wr_reg(AM_DDR_PLL_CNTL4, rd_reg(AM_DDR_PLL_CNTL4)|(1<<12));
	_udelay(10);

	/* set ddr pll reg */
	if ((p_ddr_set->ddr_clk >= CONFIG_DDR_CLK_LOW) && (p_ddr_set->ddr_clk < 750)) {
		//							OD			N					M
		p_ddr_set->ddr_pll_ctrl = (2 << 16) | (1 << 9) | ((((p_ddr_set->ddr_clk/6)*6)/12) << 0);
	}
	else if((p_ddr_set->ddr_clk >= 750) && (p_ddr_set->ddr_clk < CONFIG_DDR_CLK_HIGH)) {
		//							OD			N					M
		p_ddr_set->ddr_pll_ctrl = (1 << 16) | (1 << 9) | ((((p_ddr_set->ddr_clk/12)*12)/24) << 0);
	}

	/* if enabled, change ddr pll setting */
#ifdef CONFIG_CMD_DDR_TEST
	printf("P_PREG_STICKY_REG0: 0x%8x\n", rd_reg(P_PREG_STICKY_REG0));
	printf("P_PREG_STICKY_REG1: 0x%8x\n", rd_reg(P_PREG_STICKY_REG1));
	if ((rd_reg(P_PREG_STICKY_REG0)>>20) == 0xf13) {
		unsigned zqcr = rd_reg(P_PREG_STICKY_REG0) & 0xfffff;
		if (0 == zqcr)
			zqcr = p_ddr_set->t_pub_zq0pr;
		printf("Change ZQCR: 0x%8x -> 0x%8x\n", p_ddr_set->t_pub_zq0pr, zqcr);
		p_ddr_set->t_pub_zq0pr = zqcr;
		p_ddr_set->t_pub_zq1pr = zqcr;
		p_ddr_set->t_pub_zq2pr = zqcr;
		p_ddr_set->t_pub_zq3pr = zqcr;
		printf("Change PLL : 0x%8x -> 0x%8x\n", p_ddr_set->ddr_pll_ctrl, rd_reg(P_PREG_STICKY_REG1));
		p_ddr_set->ddr_pll_ctrl = rd_reg(P_PREG_STICKY_REG1);
		wr_reg(P_PREG_STICKY_REG0,0);
		wr_reg(P_PREG_STICKY_REG1,0);
	}
#endif

	/* ddr pll init */
	do {
		//wr_reg(AM_DDR_PLL_CNTL1, 0x1);
		wr_reg(AM_DDR_PLL_CNTL, (1<<29));
		wr_reg(AM_DDR_PLL_CNTL1, CFG_DDR_PLL_CNTL_1);
		wr_reg(AM_DDR_PLL_CNTL2, CFG_DDR_PLL_CNTL_2);
		wr_reg(AM_DDR_PLL_CNTL3, CFG_DDR_PLL_CNTL_3);
		wr_reg(AM_DDR_PLL_CNTL4, CFG_DDR_PLL_CNTL_4);
		wr_reg(AM_DDR_PLL_CNTL, ((1<<29) | (p_ddr_set->ddr_pll_ctrl)));
		wr_reg(AM_DDR_PLL_CNTL, rd_reg(AM_DDR_PLL_CNTL)&(~(1<<29)));
		_udelay(200);
	}while(pll_lock_check(AM_DDR_PLL_CNTL, "DDR PLL"));

	/* Enable the DDR DLL clock input from PLL */
	wr_reg(DDR_CLK_CNTL, 0xb0000000);
	wr_reg(DDR_CLK_CNTL, 0xb0000000);

	/* update ddr_clk */
	unsigned int ddr_pll = rd_reg(AM_DDR_PLL_CNTL)&(~(1<<29));
	unsigned int ddr_clk = 2*(((24 * (ddr_pll&0x1ff))/((ddr_pll>>9)&0x1f))>>((ddr_pll>>16)&0x3));
	p_ddr_set->ddr_clk = ddr_clk;

	return 0;
}

void ddr_print_info(void){
	unsigned int dmc_reg = rd_reg(DMC_DDR_CTRL);
	unsigned int chl0_size_reg = (dmc_reg & 0x7);
	unsigned int chl1_size_reg = ((dmc_reg>>3) & 0x7);
	unsigned int chl0_size = 1 << (chl0_size_reg+7); //MB
	unsigned int chl1_size = 1 << (chl1_size_reg+7); //MB

	if (ddr0_enabled)
		printf("DDR0: %4dMB @ %dMHz(%s)-%d\n", \
			(chl0_size_reg)>5?0:chl0_size, (chl0_size_reg)>5?0:p_ddr_set->ddr_clk, \
			((p_ddr_set->ddr_channel_set == CONFIG_DDR01_SHARE_AC)?"F1T":(((rd_reg(DDR0_PCTL_MCFG) >> 3) & 0x1)?"2T":"1T")), \
			p_ddr_set->ddr_timing_ind);
	if (ddr1_enabled)
		printf("DDR1: %4dMB @ %dMHz(%s)-%d\n", \
			(chl1_size_reg)>5?0:chl1_size, (chl1_size_reg)>5?0:p_ddr_set->ddr_clk, \
			((p_ddr_set->ddr_channel_set == CONFIG_DDR01_SHARE_AC)?"F1T":(((rd_reg(DDR1_PCTL_MCFG) >> 3) & 0x1)?"2T":"1T")), \
			p_ddr_set->ddr_timing_ind);

	/* write ddr size to reg */
	wr_reg(SEC_AO_SEC_GP_CFG0, ((rd_reg(SEC_AO_SEC_GP_CFG0) & 0x0000ffff) | ((p_ddr_set->ddr_size) << 16)));
}

unsigned int ddr_init_dmc(void){
	wr_reg(DMC_DDR_CTRL, p_ddr_set->ddr_dmc_ctrl);
	if ((p_ddr_set->ddr_channel_set == CONFIG_DDR01_SHARE_AC)||
		(p_ddr_set->ddr_channel_set == CONFIG_DDR0_ONLY_16BIT))//jiaxing find use 16bit channel 0 only must write map0-4?
	{
		//CONIFG DDR PHY comamnd address map to 32bits linear address.
	   //DDR0 ROW 14:0.   DDR1 ROW 13:0.   COL 9:0.
		wr_reg( DDR0_ADDRMAP_0, ( 0 | 5 << 5 | 6 << 10 | 7 << 15 | 8 << 20 | 9 << 25 ));
		wr_reg( DDR0_ADDRMAP_1, ( 13| 0 << 5 | 0 << 10 | 10 << 15 | 11 << 20 | 12 << 25 ));
		//wr_reg( DDR0_ADDRMAP_1, ( 0| 0 << 5 | 0 << 10 | 10 << 15 | 11 << 20 | 12 << 25 ));
		wr_reg( DDR0_ADDRMAP_2, ( 16| 17 << 5 | 18 << 10 | 19 << 15 | 20 << 20 | 21 << 25 ));
		wr_reg( DDR0_ADDRMAP_3, ( 22| 23 << 5 | 24 << 10 | 25 << 15 | 26 << 20 | 27 << 25 ));
		wr_reg( DDR0_ADDRMAP_4, ( 0 | 14 << 5 | 15 << 10 | 28 << 15 | 0 << 20 | 0 << 25 ));

		wr_reg( DDR1_ADDRMAP_0, ( 0 | 5 << 5 | 6 << 10 | 7 << 15 | 8 << 20 | 9 << 25 ));
		wr_reg( DDR1_ADDRMAP_1, ( 13| 0 << 5 | 0 << 10 | 10 << 15 | 11 << 20 | 12 << 25 ));
		//wr_reg( DDR1_ADDRMAP_1, ( 13| 0 << 5 | 0 << 10 | 10 << 15 | 11 << 20 | 12 << 25 ));
		wr_reg( DDR1_ADDRMAP_2, ( 16| 17 << 5 | 18 << 10 | 19 << 15 | 20 << 20 | 21 << 25 ));
		wr_reg( DDR1_ADDRMAP_3, ( 22| 23 << 5 | 24 << 10 | 25 << 15 | 26 << 20 | 27 << 25 ));
		wr_reg( DDR1_ADDRMAP_4, ( 0 | 14 << 5 | 15 << 10 | 28 << 15 | 0 << 20 | 0 << 25 ));
	}

	wr_reg(DMC_PCTL_LP_CTRL, 0x440620);
	//wr_reg(DDR0_APD_CTRL, 0x45);
	wr_reg(DDR0_APD_CTRL, (0x20<<8)|(0x20));
	wr_reg(DDR0_CLK_CTRL, 0x5);

	//  disable AXI port0 (CPU) IRQ/FIQ security control.
	wr_reg(DMC_AXI0_QOS_CTRL1, 0x11);

	//CONFIG DMC security register to enable the all reqeust can access all DDR region.
	wr_reg(DMC_SEC_RANGE_CTRL, 0x0 );
	wr_reg(DMC_SEC_CTRL, 0x80000000 );
	wr_reg(DMC_SEC_AXI_PORT_CTRL, 0x55555555);
	wr_reg(DMC_DEV_SEC_READ_CTRL, 0x55555555 );
	wr_reg(DMC_DEV_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_GE2D_SEC_CTRL, 0x15);
	wr_reg(DMC_PARSER_SEC_CTRL, 0x5);
	wr_reg(DMC_VPU_SEC_CFG, 0xffffffff);
	wr_reg(DMC_VPU_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_VPU_SEC_READ_CTRL, 0x55555555 );
	wr_reg(DMC_VDEC_SEC_CFG, 0xffffffff);
	wr_reg(DMC_VDEC_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_VDEC_SEC_READ_CTRL, 0x55555555 );
	wr_reg(DMC_HCODEC_SEC_CFG, 0xffffffff);
	wr_reg(DMC_HCODEC_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_HCODEC_SEC_READ_CTRL, 0x55555555 );
	wr_reg(DMC_HEVC_SEC_CFG, 0xffffffff);
	wr_reg(DMC_HEVC_SEC_WRITE_CTRL, 0x55555555 );
	wr_reg(DMC_HEVC_SEC_READ_CTRL, 0x55555555 );

	//// ENABLE THE DC_REQS.
	wr_reg(DMC_REQ_CTRL, 0xFFFF);

	// SCRATCH1
	wr_reg(0xC1107d40, 0xbaadf00d);

	// PUT SOME CODE HERE TO TRY TO STOP BUS TRAFFIC
	__asm__ volatile("NOP");
	__asm__ volatile("DMB SY");
	__asm__ volatile("ISB");

	//  REMAP THE ADDRESS SPACE BY WRITING TO NIC400 REMAP REGISTER
	//wr_reg(0xC1300000, 0x00000001);
	//__asm__ volatile("ISB");
	//__asm__ volatile("DMB SY");

	//change PL310 address filtering to allow DRAM reads to go to M1
	wr_reg(0xc4200c04, 0xbff00000);
	wr_reg(0xc4200c00, 0x00000001);

	return 0;
}

unsigned int ddr_init_pctl(void){
	ddr0_enabled = !(((p_ddr_set->ddr_dmc_ctrl) >> 7) & 0x1); //check if ddr1 only enabled
	ddr1_enabled = !(((p_ddr_set->ddr_dmc_ctrl) >> 6) & 0x1); //check if ddr0 only enabled

	// RELEASE THE DDR DLL RESET PIN.
	wr_reg(DMC_SOFT_RST, 0xFFFFFFFF);
	wr_reg(DMC_SOFT_RST1, 0xFFFFFFFF);

	// ENABLE UPCTL AND PUB CLOCK AND RESET.
	//@@@ enable UPCTL and PUB clock and reset.
	wr_reg(DMC_PCTL_LP_CTRL, 0x550620);
	wr_reg(DDR0_SOFT_RESET, 0xf);

	// INITIALIZATION PHY.
	// FOR SIMULATION TO REDUCE THE INIT TIME.
	//wr_reg(DDR0_PUB_PTR0, p_ddr_set->t_pub_ptr[0]);
	//wr_reg(DDR0_PUB_PTR1, p_ddr_set->t_pub_ptr[1]);
	//wr_reg(DDR0_PUB_PTR3, p_ddr_set->t_pub_ptr[3]);
	//wr_reg(DDR0_PUB_PTR4, p_ddr_set->t_pub_ptr[4]);

	wr_reg(DDR0_PUB_IOVCR0, 0x49494949);
	wr_reg(DDR0_PUB_IOVCR1, 0x49494949);

	// CONFIGURE DDR PHY PUBL REGISTERS.
	wr_reg(DDR0_PUB_ODTCR, p_ddr_set->t_pub_odtcr);

	// PROGRAM PUB MRX REGISTERS.
	wr_reg(DDR0_PUB_MR0, p_ddr_set->t_pub_mr[0]);
	wr_reg(DDR0_PUB_MR1, p_ddr_set->t_pub_mr[1]);
	wr_reg(DDR0_PUB_MR2, p_ddr_set->t_pub_mr[2]);
	wr_reg(DDR0_PUB_MR3, p_ddr_set->t_pub_mr[3]);

	// PROGRAM DDR SDRAM TIMING PARAMETER.
	wr_reg(DDR0_PUB_DTPR0, p_ddr_set->t_pub_dtpr[0]);
	wr_reg(DDR0_PUB_DTPR1, p_ddr_set->t_pub_dtpr[1]);
	//wr_reg(DDR0_PUB_PGCR0, p_ddr_set->t_pub_pgcr0); //Jiaxing debug low freq issue
	wr_reg(DDR0_PUB_PGCR1, p_ddr_set->t_pub_pgcr1);
	wr_reg(DDR0_PUB_PGCR2, p_ddr_set->t_pub_pgcr2);
	//printf("\nDDR0_PUB_PGCR2: 0x%8x\n", rd_reg(DDR0_PUB_PGCR2));
	//wr_reg(DDR0_PUB_PGCR2, 0x00f05f97);
	wr_reg(DDR0_PUB_PGCR3, p_ddr_set->t_pub_pgcr3);
	wr_reg(DDR0_PUB_DXCCR, p_ddr_set->t_pub_dxccr);

	wr_reg(DDR0_PUB_DTPR2, p_ddr_set->t_pub_dtpr[2]);
	wr_reg(DDR0_PUB_DTPR3, p_ddr_set->t_pub_dtpr[3]);
	wr_reg(DDR0_PUB_DTCR, p_ddr_set->t_pub_dtcr|(1<<6)); //use mpr

	//DDR0_DLL_LOCK_WAIT
	wait_set(DDR0_PUB_PGSR0, 0);

	//wr_reg(DDR0_PUB_DTCR, 0x430030c7);
	//wr_reg(DDR0_PUB_DTPR3, 0x2010a902); //tmp disable
	wr_reg(DDR0_PUB_ACIOCR1, 0);
	wr_reg(DDR0_PUB_ACIOCR2, 0);
	wr_reg(DDR0_PUB_ACIOCR3, 0);
	wr_reg(DDR0_PUB_ACIOCR4, 0);
	wr_reg(DDR0_PUB_ACIOCR5, 0);
	wr_reg(DDR0_PUB_DX0GCR1, 0);
	wr_reg(DDR0_PUB_DX0GCR2, 0);
	wr_reg(DDR0_PUB_DX0GCR3, (0x1<<10)|(0x2<<12)); //power down dm recevier
	wr_reg(DDR0_PUB_DX1GCR1, 0);
	wr_reg(DDR0_PUB_DX1GCR2, 0);
	wr_reg(DDR0_PUB_DX1GCR3, (0x1<<10)|(0x2<<12));//power down dm recevier
	wr_reg(DDR0_PUB_DX2GCR1, 0);
	wr_reg(DDR0_PUB_DX2GCR2, 0);
	wr_reg(DDR0_PUB_DX2GCR3, (0x1<<10)|(0x2<<12));//power down dm recevier
	wr_reg(DDR0_PUB_DX3GCR1, 0);
	wr_reg(DDR0_PUB_DX3GCR2, 0);
	wr_reg(DDR0_PUB_DX3GCR3, (0x1<<10)|(0x2<<12));//power down dm recevier

	//   2:0   011: DDR0_ MODE.   100:   LPDDR2 MODE.
	//   3:    8 BANK.
	//   7;    MPR FOR DATA TRAINING.
	wr_reg(DDR0_PUB_DCR, p_ddr_set->t_pub_dcr|(1<<7)); //use mpr

	wr_reg(DDR0_PUB_DTAR0, p_ddr_set->t_pub_dtar);
	wr_reg(DDR0_PUB_DTAR1, (0X8 | p_ddr_set->t_pub_dtar));
	wr_reg(DDR0_PUB_DTAR2, (0X10 | p_ddr_set->t_pub_dtar));
	wr_reg(DDR0_PUB_DTAR3, (0X18 | p_ddr_set->t_pub_dtar));

	//// DDR PHY INITIALIZATION
	//wr_reg(DDR0_PUB_PIR, 0X581);
	wr_reg(DDR0_PUB_DSGCR, p_ddr_set->t_pub_dsgcr);

	//DDR0_SDRAM_INIT_WAIT :
	wait_set(DDR0_PUB_PGSR0, 0);

	if (ddr0_enabled) {
		// configure DDR0 IP.
		wr_reg(DDR0_PCTL_TOGCNT1U, p_ddr_set->t_pctl0_1us_pck);
		wr_reg(DDR0_PCTL_TOGCNT100N, p_ddr_set->t_pctl0_100ns_pck);
		wr_reg(DDR0_PCTL_TINIT, p_ddr_set->t_pctl0_init_us); //20
		wr_reg(DDR0_PCTL_TRSTH, p_ddr_set->t_pctl0_rsth_us); //50
		wr_reg(DDR0_PCTL_MCFG, (p_ddr_set->t_pctl0_mcfg)|((p_ddr_set->ddr_2t_mode)?(1<<3):(0<<3)));
		wr_reg(DDR0_PCTL_MCFG1, p_ddr_set->t_pctl0_mcfg1);
	}

	if (ddr1_enabled) {
		// configure DDR1 IP.
		wr_reg(DDR1_PCTL_TOGCNT1U, p_ddr_set->t_pctl0_1us_pck);
		wr_reg(DDR1_PCTL_TOGCNT100N, p_ddr_set->t_pctl0_100ns_pck);
		wr_reg(DDR1_PCTL_TINIT, p_ddr_set->t_pctl0_init_us); //20
		wr_reg(DDR1_PCTL_TRSTH, p_ddr_set->t_pctl0_rsth_us); //50
		wr_reg(DDR1_PCTL_MCFG, (p_ddr_set->t_pctl0_mcfg)|((p_ddr_set->ddr_2t_mode)?(1<<3):(0<<3)));
		wr_reg(DDR1_PCTL_MCFG1, p_ddr_set->t_pctl0_mcfg1);
	}

	_udelay(500);

	// MONITOR DFI INITIALIZATION STATUS.
	if (ddr0_enabled) {
		wait_set(DDR0_PCTL_DFISTSTAT0, 0);
		wr_reg(DDR0_PCTL_POWCTL, 1);
		//DDR0_POWER_UP_WAIT
		wait_set(DDR0_PCTL_POWSTAT, 0);
	}
	if (ddr1_enabled) {
		wait_set(DDR1_PCTL_DFISTSTAT0, 0);
		wr_reg(DDR1_PCTL_POWCTL, 1);
		//DDR0_POWER_UP_WAIT
		wait_set(DDR1_PCTL_POWSTAT, 0);
	}

	if (ddr0_enabled) {
		wr_reg(DDR0_PCTL_TRFC, p_ddr_timing->cfg_ddr_rfc);
		wr_reg(DDR0_PCTL_TREFI_MEM_DDR3, p_ddr_timing->cfg_ddr_refi_mddr3);
		wr_reg(DDR0_PCTL_TMRD, p_ddr_timing->cfg_ddr_mrd);
		wr_reg(DDR0_PCTL_TRP, p_ddr_timing->cfg_ddr_rp);
		wr_reg(DDR0_PCTL_TAL, p_ddr_timing->cfg_ddr_al);
		wr_reg(DDR0_PCTL_TCWL, p_ddr_timing->cfg_ddr_cwl);
		wr_reg(DDR0_PCTL_TCL, p_ddr_timing->cfg_ddr_cl);
		wr_reg(DDR0_PCTL_TRAS, p_ddr_timing->cfg_ddr_ras);
		wr_reg(DDR0_PCTL_TRC, p_ddr_timing->cfg_ddr_rc);
		wr_reg(DDR0_PCTL_TRCD, p_ddr_timing->cfg_ddr_rcd);
		wr_reg(DDR0_PCTL_TRRD, p_ddr_timing->cfg_ddr_rrd);
		wr_reg(DDR0_PCTL_TRTP, p_ddr_timing->cfg_ddr_rtp);
		wr_reg(DDR0_PCTL_TWR, p_ddr_timing->cfg_ddr_wr);
		wr_reg(DDR0_PCTL_TWTR, p_ddr_timing->cfg_ddr_wtr);
		wr_reg(DDR0_PCTL_TEXSR, p_ddr_timing->cfg_ddr_exsr);
		wr_reg(DDR0_PCTL_TXP, p_ddr_timing->cfg_ddr_xp);
		wr_reg(DDR0_PCTL_TDQS, p_ddr_timing->cfg_ddr_dqs);
		wr_reg(DDR0_PCTL_TRTW, p_ddr_timing->cfg_ddr_rtw);
		wr_reg(DDR0_PCTL_TCKSRE, p_ddr_timing->cfg_ddr_cksre);
		wr_reg(DDR0_PCTL_TCKSRX, p_ddr_timing->cfg_ddr_cksrx);
		wr_reg(DDR0_PCTL_TMOD, p_ddr_timing->cfg_ddr_mod);
		wr_reg(DDR0_PCTL_TCKE, p_ddr_timing->cfg_ddr_cke);
		wr_reg(DDR0_PCTL_TZQCS, p_ddr_timing->cfg_ddr_zqcs);
		wr_reg(DDR0_PCTL_TZQCL, p_ddr_timing->cfg_ddr_zqcl);
		wr_reg(DDR0_PCTL_TXPDLL, p_ddr_timing->cfg_ddr_xpdll);
		wr_reg(DDR0_PCTL_TZQCSI, p_ddr_timing->cfg_ddr_zqcsi);
	}

	if (ddr1_enabled) {
		wr_reg(DDR1_PCTL_TRFC, p_ddr_timing->cfg_ddr_rfc);
		wr_reg(DDR1_PCTL_TREFI_MEM_DDR3, p_ddr_timing->cfg_ddr_refi_mddr3);
		wr_reg(DDR1_PCTL_TMRD, p_ddr_timing->cfg_ddr_mrd);
		wr_reg(DDR1_PCTL_TRP, p_ddr_timing->cfg_ddr_rp);
		wr_reg(DDR1_PCTL_TAL, p_ddr_timing->cfg_ddr_al);
		wr_reg(DDR1_PCTL_TCWL, p_ddr_timing->cfg_ddr_cwl);
		wr_reg(DDR1_PCTL_TCL, p_ddr_timing->cfg_ddr_cl);
		wr_reg(DDR1_PCTL_TRAS, p_ddr_timing->cfg_ddr_ras);
		wr_reg(DDR1_PCTL_TRC, p_ddr_timing->cfg_ddr_rc);
		wr_reg(DDR1_PCTL_TRCD, p_ddr_timing->cfg_ddr_rcd);
		wr_reg(DDR1_PCTL_TRRD, p_ddr_timing->cfg_ddr_rrd);
		wr_reg(DDR1_PCTL_TRTP, p_ddr_timing->cfg_ddr_rtp);
		wr_reg(DDR1_PCTL_TWR, p_ddr_timing->cfg_ddr_wr);
		wr_reg(DDR1_PCTL_TWTR, p_ddr_timing->cfg_ddr_wtr);
		wr_reg(DDR1_PCTL_TEXSR, p_ddr_timing->cfg_ddr_exsr);
		wr_reg(DDR1_PCTL_TXP, p_ddr_timing->cfg_ddr_xp);
		wr_reg(DDR1_PCTL_TDQS, p_ddr_timing->cfg_ddr_dqs);
		wr_reg(DDR1_PCTL_TRTW, p_ddr_timing->cfg_ddr_rtw);
		wr_reg(DDR1_PCTL_TCKSRE, p_ddr_timing->cfg_ddr_cksre);
		wr_reg(DDR1_PCTL_TCKSRX, p_ddr_timing->cfg_ddr_cksrx);
		wr_reg(DDR1_PCTL_TMOD, p_ddr_timing->cfg_ddr_mod);
		wr_reg(DDR1_PCTL_TCKE, p_ddr_timing->cfg_ddr_cke);
		wr_reg(DDR1_PCTL_TZQCS, p_ddr_timing->cfg_ddr_zqcs);
		wr_reg(DDR1_PCTL_TZQCL, p_ddr_timing->cfg_ddr_zqcl);
		wr_reg(DDR1_PCTL_TXPDLL, p_ddr_timing->cfg_ddr_xpdll);
		wr_reg(DDR1_PCTL_TZQCSI, p_ddr_timing->cfg_ddr_zqcsi);
	}

	if (ddr0_enabled) {
		wr_reg(DDR0_PCTL_SCFG, p_ddr_set->t_pctl0_scfg);
		wr_reg(DDR0_PCTL_SCTL, p_ddr_set->t_pctl0_sctl);
	}

	if (ddr1_enabled) {
		wr_reg(DDR1_PCTL_SCFG, p_ddr_set->t_pctl0_scfg);
		wr_reg(DDR1_PCTL_SCTL, p_ddr_set->t_pctl0_sctl);
	}

	// SCRATCH1
	wr_reg(0xC1107d40, 0xdeadbeef);

	// NEW HIU
	wr_reg(0xC883c010, 0x88776655);

	//DDR0_STAT_CONFIG_WAIT
	if (ddr0_enabled)
		wait_set(DDR0_PCTL_STAT, 0);
	if (ddr1_enabled)
		wait_set(DDR1_PCTL_STAT, 0);

	if (ddr0_enabled) {
		wr_reg(DDR0_PCTL_PPCFG, p_ddr_set->t_pctl0_ppcfg); /* 16bit or 32bit mode */
		wr_reg(DDR0_PCTL_DFISTCFG0, p_ddr_set->t_pctl0_dfistcfg0);
		wr_reg(DDR0_PCTL_DFISTCFG1, p_ddr_set->t_pctl0_dfistcfg1);
		wr_reg(DDR0_PCTL_DFITCTRLDELAY, p_ddr_set->t_pctl0_dfitctrldelay);
		wr_reg(DDR0_PCTL_DFITPHYWRDATA, p_ddr_set->t_pctl0_dfitphywrdata);
		wr_reg(DDR0_PCTL_DFITPHYWRLAT, p_ddr_set->t_pctl0_dfitphywrlta);
		wr_reg(DDR0_PCTL_DFITRDDATAEN, p_ddr_set->t_pctl0_dfitrddataen);
		wr_reg(DDR0_PCTL_DFITPHYRDLAT, p_ddr_set->t_pctl0_dfitphyrdlat);
		wr_reg(DDR0_PCTL_DFITDRAMCLKDIS, p_ddr_set->t_pctl0_dfitdramclkdis);
		wr_reg(DDR0_PCTL_DFITDRAMCLKEN, p_ddr_set->t_pctl0_dfitdramclken);
		wr_reg(DDR0_PCTL_DFILPCFG0, p_ddr_set->t_pctl0_dfilpcfg0);
		wr_reg(DDR0_PCTL_DFITPHYUPDTYPE1, p_ddr_set->t_pctl0_dfitphyupdtype1);
		wr_reg(DDR0_PCTL_DFITCTRLUPDMIN, p_ddr_set->t_pctl0_dfitctrlupdmin);
		wr_reg(DDR0_PCTL_DFIODTCFG, p_ddr_set->t_pctl0_dfiodtcfg);
		wr_reg(DDR0_PCTL_DFIODTCFG1, p_ddr_set->t_pctl0_dfiodtcfg1);
		wr_reg(DDR0_PCTL_CMDTSTATEN, p_ddr_set->t_pctl0_cmdtstaten);
	}

	if (ddr1_enabled) {
		wr_reg(DDR1_PCTL_PPCFG, p_ddr_set->t_pctl0_ppcfg); /* 16bit or 32bit mode */
		wr_reg(DDR1_PCTL_DFISTCFG0, p_ddr_set->t_pctl0_dfistcfg0);
		wr_reg(DDR1_PCTL_DFISTCFG1, p_ddr_set->t_pctl0_dfistcfg1);
		wr_reg(DDR1_PCTL_DFITCTRLDELAY, p_ddr_set->t_pctl0_dfitctrldelay);
		wr_reg(DDR1_PCTL_DFITPHYWRDATA, p_ddr_set->t_pctl0_dfitphywrdata);
		wr_reg(DDR1_PCTL_DFITPHYWRLAT, p_ddr_set->t_pctl0_dfitphywrlta);
		wr_reg(DDR1_PCTL_DFITRDDATAEN, p_ddr_set->t_pctl0_dfitrddataen);
		wr_reg(DDR1_PCTL_DFITPHYRDLAT, p_ddr_set->t_pctl0_dfitphyrdlat);
		wr_reg(DDR1_PCTL_DFITDRAMCLKDIS, p_ddr_set->t_pctl0_dfitdramclkdis);
		wr_reg(DDR1_PCTL_DFITDRAMCLKEN, p_ddr_set->t_pctl0_dfitdramclken);
		wr_reg(DDR1_PCTL_DFILPCFG0, p_ddr_set->t_pctl0_dfilpcfg0);
		wr_reg(DDR1_PCTL_DFITPHYUPDTYPE1, p_ddr_set->t_pctl0_dfitphyupdtype1);
		wr_reg(DDR1_PCTL_DFITCTRLUPDMIN, p_ddr_set->t_pctl0_dfitctrlupdmin);
		wr_reg(DDR1_PCTL_DFIODTCFG, p_ddr_set->t_pctl0_dfiodtcfg);
		wr_reg(DDR1_PCTL_DFIODTCFG1, p_ddr_set->t_pctl0_dfiodtcfg1);
		wr_reg(DDR1_PCTL_CMDTSTATEN, p_ddr_set->t_pctl0_cmdtstaten);
	}

#ifndef CONFIG_PXP_EMULATOR
	wr_reg(DDR0_PUB_ZQ0PR, p_ddr_set->t_pub_zq0pr);
	wr_reg(DDR0_PUB_ZQ1PR, p_ddr_set->t_pub_zq1pr);
	wr_reg(DDR0_PUB_ZQ2PR, p_ddr_set->t_pub_zq2pr);
	wr_reg(DDR0_PUB_ZQ3PR, p_ddr_set->t_pub_zq3pr);

	wr_reg(DDR0_PUB_PIR, 3);
	wait_set(DDR0_PUB_PGSR0, 0);
	wr_reg(DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))|(1<<2)|(1<<27)); //jiaxing debug must force update
	_udelay(10);
	wr_reg(DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))&(~((1<<2)|(1<<27))));
	_udelay(30);
	if (p_ddr_set->ddr_channel_set == CONFIG_DDR0_ONLY_16BIT)
	{
		wr_reg(DDR0_PUB_DX2GCR0, (0xfffffffe&rd_reg(DDR0_PUB_DX2GCR0)));
		wr_reg(DDR0_PUB_DX3GCR0, (0xfffffffe&rd_reg(DDR0_PUB_DX3GCR0)));
	}

#ifdef CONFIG_DDR_CMD_BDL_TUNE
	wr_reg(DDR0_PUB_ACLCDLR, DDR_AC_LCDLR);  //ck0
	wr_reg(DDR0_PUB_ACBDLR0, DDR_CK0_BDL);  //ck0
	wr_reg(DDR0_PUB_ACBDLR1, (DDR_WE_BDL<<16)|(DDR_CAS_BDL<<8)|(DDR_RAS_BDL)); //ras cas we
	wr_reg(DDR0_PUB_ACBDLR2, ((DDR_ACPDD_BDL<<24)|(DDR_BA2_BDL<<16)|(DDR_BA1_BDL<<8)|(DDR_BA0_BDL))); //ba0 ba1 ba2
	wr_reg(DDR0_PUB_ACBDLR3, ((DDR_CS1_BDL<<8)|(DDR_CS0_BDL)));  //cs0 cs1
	wr_reg(DDR0_PUB_ACBDLR4, ((DDR_ODT1_BDL<<8)|(DDR_ODT0_BDL))); //odt0 odt1
	wr_reg(DDR0_PUB_ACBDLR5, ((DDR_CKE1_BDL<<8)|(DDR_CKE0_BDL)));  //cke0 cke1
	wr_reg(DDR0_PUB_ACBDLR6, ((DDR_A3_BDL<<24)|(DDR_A2_BDL<<16)|(DDR_A1_BDL<<8)|(DDR_A0_BDL))); //a0 a1 a2 a3
	wr_reg(DDR0_PUB_ACBDLR7, ((DDR_A7_BDL<<24)|(DDR_A6_BDL<<16)|(DDR_A5_BDL<<8)|(DDR_A4_BDL))); //a4 a5 a6 a7
	wr_reg(DDR0_PUB_ACBDLR8, ((DDR_A11_BDL<<24)|(DDR_A10_BDL<<16)|(DDR_A9_BDL<<8)|(DDR_A8_BDL)));  //a8 a9 a10 a11
	wr_reg(DDR0_PUB_ACBDLR9, ((DDR_A15_BDL<<24)|(DDR_A14_BDL<<16)|(DDR_A13_BDL<<8)|(DDR_A12_BDL)));  //a12 a13 a14 a15
#endif

	wr_reg(DDR0_PUB_PIR, (DDR_PIR | PUB_PIR_INIT));
	do {
		_udelay(20);
	} while(DDR_PGSR0_CHECK());
#endif

	if ((p_ddr_set->ddr_channel_set == CONFIG_DDR0_RANK0_ONLY) || (p_ddr_set->ddr_channel_set == CONFIG_DDR0_RANK01_SAME))
	{
		unsigned int i=0, j=0;
		i=(rd_reg(DDR0_PUB_DX2LCDLR0));
		wr_reg(DDR0_PUB_DX2LCDLR0,((i>>8)|(i&(0xffffff00))));
		i=(((rd_reg(DDR0_PUB_DX2GTR))>>3)&((7<<0)));
		j=(((rd_reg(DDR0_PUB_DX2GTR))>>14)&((3<<0)));
		wr_reg(DDR0_PUB_DX2GTR,i|(i<<3)|(j<<12)|(j<<14));
		i=(rd_reg(DDR0_PUB_DX2LCDLR2));
		wr_reg(DDR0_PUB_DX2LCDLR2,((i>>8)|(i&(0xffffff00))));
		i=(rd_reg(DDR0_PUB_DX3LCDLR0));
		wr_reg(DDR0_PUB_DX3LCDLR0,((i>>8)|(i&(0xffffff00))));
		i=(((rd_reg(DDR0_PUB_DX3GTR))>>3)&((7<<0)));
		j=(((rd_reg(DDR0_PUB_DX3GTR))>>14)&((3<<0)));
		wr_reg(DDR0_PUB_DX3GTR,i|(i<<3)|(j<<12)|(j<<14));
		i=(rd_reg(DDR0_PUB_DX3LCDLR2));
		wr_reg(DDR0_PUB_DX3LCDLR2,((i>>8)|(i&(0xffffff00))));
		i=(rd_reg(DDR0_PUB_DX0LCDLR0));
		wr_reg(DDR0_PUB_DX0LCDLR0,((i<<8)|(i&(0xffff00ff))));
		i=(((rd_reg(DDR0_PUB_DX0GTR))<<0)&((7<<0)));
		j=(((rd_reg(DDR0_PUB_DX0GTR))>>12)&((3<<0)));
		wr_reg(DDR0_PUB_DX0GTR,i|(i<<3)|(j<<12)|(j<<14));
		i=(rd_reg(DDR0_PUB_DX0LCDLR2));
		wr_reg(DDR0_PUB_DX0LCDLR2,((i<<8)|(i&(0xffff00ff))));
		i=(rd_reg(DDR0_PUB_DX1LCDLR0));
		wr_reg(DDR0_PUB_DX1LCDLR0,((i<<8)|(i&(0xffff00ff))));
		i=(((rd_reg(DDR0_PUB_DX1GTR))<<0)&((7<<0)));
		j=(((rd_reg(DDR0_PUB_DX1GTR))>>12)&((3<<0)));
		wr_reg(DDR0_PUB_DX1GTR,i|(i<<3)|(j<<12)|(j<<14));
		i=(rd_reg(DDR0_PUB_DX1LCDLR2));
		wr_reg(DDR0_PUB_DX1LCDLR2,((i<<8)|(i&(0xffff00ff))));
		//wr_reg(DDR0_PUB_PGCR2,((((1<<28))|p_ddr_set->t_pub_pgcr2)));
		wr_reg(DDR0_PUB_PGCR2,(((~(1<<28))&p_ddr_set->t_pub_pgcr2)));
	}

	if ((p_ddr_set->ddr_2t_mode) && \
		(p_ddr_set->ddr_channel_set != CONFIG_DDR01_SHARE_AC) && \
		(((p_ddr_set->t_pub_dcr)&0x7)== 0x3)) {
		//jiaxing mark----must place after training ,because training is 1t mode  ,if delay too much training will not ok
		wr_reg(DDR0_PUB_ACLCDLR, 0x1f);  //delay cmd/address 2t signle not effect cs cke odt
		//wr_reg(DDR0_PUB_ACBDLR0, 0x10);  //ck0
		/*
		wr_reg(DDR0_PUB_ACBDLR1, (0x18<<16)|(0x18<<8)|(0x18)); //ras cas we
		wr_reg(DDR0_PUB_ACBDLR2, ((0x18<<16)|(0x18<<8)|(0x18))); //ba0 ba1 ba2
		//wr_reg(DDR0_PUB_ACBDLR3, ((0<<8)|(0)));  //cs0 cs1
		//wr_reg(DDR0_PUB_ACBDLR4, ((0<<8)|(0))); //odt0 odt1
		//wr_reg(DDR0_PUB_ACBDLR5, ((0<<8)|(0)));  //cke0 cke1
		wr_reg(DDR0_PUB_ACBDLR6, ((0x18<<24)|(0x18<<16)|(0x18<<8)|(0x18))); //a0 a1 a2 a3
		wr_reg(DDR0_PUB_ACBDLR7, ((0x18<<24)|(0x18<<16)|(0x18<<8)|(0x18))); //a4 a5 a6 a7
		wr_reg(DDR0_PUB_ACBDLR8, ((0x18<<24)|(0x18<<16)|(0x18<<8)|(0x18)));  //a8 a9 a10 a11
		wr_reg(DDR0_PUB_ACBDLR9, ((0x18<<24)|(0x18<<16)|(0x18<<8)|(0x18)));  //a12 a13 a14 a15
		*/
	}
	//DDR0_CMD_TIMER_WAIT
	if (ddr0_enabled)
		wait_set(DDR0_PCTL_CMDTSTAT, 0);
	if (ddr1_enabled)
		wait_set(DDR1_PCTL_CMDTSTAT, 0);

	////APB_WR(PCTL_PCTL_SCTL, 2); // INIT: 0, CFG: 1, GO: 2, SLEEP: 3, WAKEUP: 4
	if (ddr0_enabled)
		wr_reg(DDR0_PCTL_SCTL, UPCTL_CMD_GO);
	if (ddr1_enabled)
		wr_reg(DDR1_PCTL_SCTL, UPCTL_CMD_GO);

	////WHILE ((APB_RD(DDR0_PCTL_STAT) & 0x7 ) != 3 ) {}
	//DDR0_STAT_GO_WAIT:
	if (ddr0_enabled)
		wait_equal(DDR0_PCTL_STAT, UPCTL_STAT_ACCESS);
	if (ddr1_enabled)
		wait_equal(DDR1_PCTL_STAT, UPCTL_STAT_ACCESS);

	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))|(1<<2));
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))&(~(1<<2)));

/* power down zq for power saving */
#ifdef CONFIG_DDR_ZQ_POWER_DOWN
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))|(1<<2));
#endif

/* power down phy vref for power saving */
#ifdef CONFIG_DDR_POWER_DOWN_PHY_VREF
	wr_reg(DDR0_PUB_IOVCR0, 0);
	wr_reg(DDR0_PUB_IOVCR1, 0);
#endif

	//// ENABLE THE DMC AUTO REFRESH FUNCTION
	if (ddr0_enabled) {
		wr_reg(DMC_REFR_CTRL1, 0X8800191|(0x3<<2)|(0x1<<0));
		rd_reg(DDR0_PCTL_MCFG);
	}
	if (ddr1_enabled) {
		wr_reg(DMC_REFR_CTRL1, 0X8800191|(0x3<<2)|(0x1<<1));
		rd_reg(DDR1_PCTL_MCFG);
	}
	wr_reg(DMC_REFR_CTRL2, 0X20100000|(p_ddr_set->ddr_clk/20)|(39<<8));

	return 0;
}

void ddr_pre_init(void){
	/* find match ddr timing */
	if ((p_ddr_set->ddr_clk >= CONFIG_DDR_CLK_LOW) && (p_ddr_set->ddr_clk < 533)) {
		p_ddr_set->ddr_timing_ind = CONFIG_DDR_TIMMING_DDR3_7;
	}
	else if ((p_ddr_set->ddr_clk >= 533) && (p_ddr_set->ddr_clk < 667)) {
		p_ddr_set->ddr_timing_ind = CONFIG_DDR_TIMMING_DDR3_9;
	}
	else if ((p_ddr_set->ddr_clk >= 667) && (p_ddr_set->ddr_clk < 800)) {
		p_ddr_set->ddr_timing_ind = CONFIG_DDR_TIMMING_DDR3_11;
	}
	else if ((p_ddr_set->ddr_clk >= 800) && (p_ddr_set->ddr_clk < 933)) {
		p_ddr_set->ddr_timing_ind = CONFIG_DDR_TIMMING_DDR3_13;
	}
	else if ((p_ddr_set->ddr_clk >= 933) && (p_ddr_set->ddr_clk < CONFIG_DDR_CLK_HIGH)) {
		p_ddr_set->ddr_timing_ind = CONFIG_DDR_TIMMING_DDR3_14;
	}
	else {
		printf("DDR clk setting error! Reset...\n");
		reset_system();
	}

	p_ddr_set->t_pctl0_1us_pck = (p_ddr_set->ddr_clk / 2);
	p_ddr_set->t_pctl0_100ns_pck = (p_ddr_set->ddr_clk / 20);

	/* get match timing config */
	unsigned loop;
	for (loop = 0; loop < (sizeof(__ddr_timming)/sizeof(ddr_timing_t)); loop++) {
		if (__ddr_timming[loop].identifier == p_ddr_set->ddr_timing_ind) {
			p_ddr_timing = &__ddr_timming[loop];
			break;
		}
	}
	if (NULL == p_ddr_timing) {
		printf("Can't find ddr timing setting! Reset...\n");
		reset_system();
	}

	unsigned int ddr_rank_set = 0;
	unsigned int ddr_chl_interface = 0;
	unsigned int ddr_chl_select = 0;
	unsigned int ddr_dual_rank_sel = 0;
	unsigned int ddr0_size = 0, ddr1_size = 0;
	unsigned int ddr0_size_reg = 0, ddr1_size_reg = 0;
	unsigned int i=0, j=0, convert_reg_size = 6;

	//BIT22. 1:RANK1 IS SAME AS RANK0
	//BIT21. 0:SEC RANK DISABLE, 1:SEC RANK ENABLE
	//BIT20. SHARE AC MODE, 0:DISABLE, 1:ENABLE
	if (p_ddr_set->ddr_channel_set == CONFIG_DDR0_RANK0_ONLY) {
		printf("DDR channel setting: DDR0 Rank0 only\n");
		ddr_rank_set = 0x2; //b'010: BIT22, BIT21, BIT20
		ddr_chl_interface = 0; //BIT[17:16], DDR0_DDR1 DATA WIDTH, 0:32BIT, 1:16BIT
		ddr_chl_select = 1; //b'00:DDR0_DDR1, b'01: DDR0_ONLY, b'10:DDR1_ONLY
		ddr_dual_rank_sel = 0; //SET PGCR2[28], RANK0 AND RANK1 USE SAME RANK SELECT SIGNAL
		ddr0_size = p_ddr_set->ddr_size;
		ddr1_size = 0x1<<(7+convert_reg_size); //the purpose is convert ddr1_size_reg bigger than 0x5(reserve as 0MB)
		p_ddr_set->t_pctl0_ppcfg = (0xF0 << 1);
		p_ddr_set->t_pctl0_dfiodtcfg = 0x0808;
	}
	else if (p_ddr_set->ddr_channel_set == CONFIG_DDR0_RANK01_SAME) {
		printf("DDR channel setting: DDR0 Rank0+1 same\n");
		ddr_rank_set = 0x4;
		ddr_chl_interface = 0;
		ddr_chl_select = 1;
		ddr_dual_rank_sel = 1;
		ddr0_size = p_ddr_set->ddr_size;
		ddr1_size = 0x1<<(7+convert_reg_size);
		p_ddr_set->t_pctl0_ppcfg = (0xF0 << 1);
		p_ddr_set->t_pctl0_dfiodtcfg = 0x08;
	}
	else if (p_ddr_set->ddr_channel_set == CONFIG_DDR0_ONLY_16BIT) {
		printf("DDR channel setting: ONLY DDR0 16bit mode\n");
		ddr_rank_set = 0x2;
		//ddr_chl_interface = 0;
		//ddr_chl_select = 1;
		ddr_chl_interface = 3;
		ddr_chl_select = 1;
		ddr_dual_rank_sel = 0;
		ddr0_size = p_ddr_set->ddr_size;
		ddr1_size = 0x1<<(7+convert_reg_size);
		//p_ddr_set->t_pctl0_ppcfg = (0xF0 << 1);
		p_ddr_set->t_pctl0_ppcfg =(0x1fc | 1 );
		p_ddr_set->t_pctl0_dfiodtcfg = 0x08;
	}
	else if (p_ddr_set->ddr_channel_set == CONFIG_DDR01_SHARE_AC) {
		printf("DDR channel setting: DDR0+1 share ac\n");
		ddr_rank_set = 0x1;
		ddr_chl_interface = 3;
		ddr_chl_select = 0;
		ddr_dual_rank_sel = 1;
		/* calculate ddr size and assign each channel */
		for (i=p_ddr_set->ddr_size; i; i>>=1) {
			j += 1;
			if (i & 0x1)
				break;
		}
		/* if ddr0 and ddr1 size different */
		if (1 == i) {
			ddr0_size = 1<<(j-2);
			ddr1_size = 1<<(j-2);
		}
		else if(3 == i){
			ddr0_size = 1<<(j);
			ddr1_size = 1<<(j-1);
		}
		p_ddr_set->t_pctl0_ppcfg = (0x1fc | 1 );
		p_ddr_set->t_pctl0_dfiodtcfg = 0x08;
		p_ddr_set->ddr_dmc_ctrl	|= (5 << 8);
		p_ddr_set->ddr_2t_mode = 1;
	}

	/* config ddr size reg */
	ddr0_size = ddr0_size>>convert_reg_size;
	while (!((ddr0_size>>=1)&0x1))
		ddr0_size_reg++;
	ddr1_size = ddr1_size>>convert_reg_size;
	while (!((ddr1_size>>=1)&0x1))
		ddr1_size_reg++;
	p_ddr_set->ddr_dmc_ctrl	|= ((ddr_rank_set << 20)	|
							(ddr_chl_interface << 16)	|
							(ddr_chl_select << 6)		|
							(ddr1_size_reg << 3)		|
							(ddr0_size_reg << 0));
	/* config t_pub_pgcr2[28] share-ac-dual */
	p_ddr_set->t_pub_pgcr2 |= (ddr_dual_rank_sel << 28);

/*
	if ((p_ddr_set->ddr_2t_mode) &&(p_ddr_set->ddr_channel_set != CONFIG_DDR01_SHARE_AC)) {
		p_ddr_timing->cfg_ddr_cl=p_ddr_timing->cfg_ddr_cl-1;
	}
*/

	/* update pctl timing */
	int tmp_val = 0;
	tmp_val =( p_ddr_timing->cfg_ddr_cwl + p_ddr_timing->cfg_ddr_al);
	tmp_val = (tmp_val - ((tmp_val%2) ? 3:4))/2;
	p_ddr_set->t_pctl0_dfitphywrlta=tmp_val;

	tmp_val = p_ddr_timing->cfg_ddr_cl + p_ddr_timing->cfg_ddr_al;
	tmp_val = (tmp_val - ((tmp_val%2) ? 3:4))/2;
	p_ddr_set->t_pctl0_dfitrddataen=tmp_val;

	//p_ddr_set->t_pctl0_dfitphyrdlat=16;
	if ((p_ddr_timing->cfg_ddr_cl+p_ddr_timing->cfg_ddr_al)%2) {
		p_ddr_set->t_pctl0_dfitphyrdlat=14;
	}

	/* update pub mr */
	p_ddr_set->t_pub_mr[0] = ((((p_ddr_timing->cfg_ddr_cl - 4) & 0x8)>>1)		|
						(((p_ddr_timing->cfg_ddr_cl - 4) & 0x7) <<  4)		|
						((((p_ddr_timing->cfg_ddr_wr <= 8)?(p_ddr_timing->cfg_ddr_wr - 4):(p_ddr_timing->cfg_ddr_wr>>1)) & 7) << 9) |
						(0x0) | (0x0 << 3) | (0x0 << 7) | (0x0 << 8) | (0x6 << 9) | (1 << 12)),
	p_ddr_set->t_pub_mr[1] = ( ((p_ddr_set->ddr_drv<<1)|((p_ddr_set->ddr_odt&1)<<2) |
						(((p_ddr_set->ddr_odt&2)>>1)<<6)				|
						(((p_ddr_set->ddr_odt&4)>>2)<<9)				|
						(1<<7) 									|
						((p_ddr_timing->cfg_ddr_al ? ((p_ddr_timing->cfg_ddr_cl - p_ddr_timing->cfg_ddr_al)&3): 0) << 3 ))),
	p_ddr_set->t_pub_mr[2] = ((1<<6)	|
					(((p_ddr_timing->cfg_ddr_cwl-5)&0x7)<<3)),
	p_ddr_set->t_pub_mr[3] = 0x0,
	/* update pub dtpr */
	p_ddr_set->t_pub_dtpr[0] = (p_ddr_timing->cfg_ddr_rtp			|
								(p_ddr_timing->cfg_ddr_wtr << 4)		|
								(p_ddr_timing->cfg_ddr_rp << 8)		|
								(p_ddr_timing->cfg_ddr_ras << 16)		|
								(p_ddr_timing->cfg_ddr_rrd << 22)		|
								(p_ddr_timing->cfg_ddr_rcd << 26));
	p_ddr_set->t_pub_dtpr[1] = ((p_ddr_timing->cfg_ddr_mod << 2)	|
								(p_ddr_timing->cfg_ddr_faw << 5)		|
								(p_ddr_timing->cfg_ddr_rfc << 11)		|
								(p_ddr_timing->cfg_ddr_wlmrd << 20)	|
								(p_ddr_timing->cfg_ddr_wlo << 26)		|
								(0 << 30) ); //TAOND
	p_ddr_set->t_pub_dtpr[2] = (p_ddr_timing->cfg_ddr_xs			|
								(p_ddr_timing->cfg_ddr_xp << 10)		|
								(p_ddr_timing->cfg_ddr_dllk << 19)	|
								(0 << 29)				| //TRTODT ADDITIONAL
								(0 << 30)				| //TRTW ADDITIONAL
								(0 << 31 )); //TCCD ADDITIONAL
	p_ddr_set->t_pub_dtpr[3] = (0 | (0 << 3)			|
								(p_ddr_timing->cfg_ddr_rc << 6)		|
								(p_ddr_timing->cfg_ddr_cke << 13)		|
								(p_ddr_timing->cfg_ddr_mrd << 18)		|
								(0 << 29)); //tAOFDx
	p_ddr_set->t_pctl0_mcfg = ((p_ddr_set->t_pctl0_mcfg)&(~(0x3<<18)))	|
								(((((p_ddr_timing->cfg_ddr_faw+p_ddr_timing->cfg_ddr_rrd-1)/p_ddr_timing->cfg_ddr_rrd)-4)&0x3)<<18);
	p_ddr_set->t_pctl0_mcfg1 |= ((((p_ddr_timing->cfg_ddr_faw%p_ddr_timing->cfg_ddr_rrd)?(p_ddr_timing->cfg_ddr_rrd-(p_ddr_timing->cfg_ddr_faw%p_ddr_timing->cfg_ddr_rrd)):0)&0x7)<<8);
}

void ddr_test(void){
	if (memTestDataBus((volatile unsigned int *)(uint64_t) \
		(p_ddr_set->ddr_base_addr + p_ddr_set->ddr_start_offset))) {
		printf("DataBus test failed!!!\n");
		reset_system();
	}
	else
		printf("DataBus test pass!\n");
	if (memTestAddressBus((volatile unsigned int *)(uint64_t) \
		(p_ddr_set->ddr_base_addr + p_ddr_set->ddr_start_offset), \
		((p_ddr_set->ddr_size << 20) - p_ddr_set->ddr_start_offset))) {
		printf("AddrBus test failed!!!\n");
		reset_system();
	}
	else
		printf("AddrBus test pass!\n");
	if (p_ddr_set->ddr_full_test) {
		extern void watchdog_disable(void);
		//disable_mmu_el1();
		watchdog_disable();
		if (memTestDevice((volatile unsigned int *)(uint64_t) \
			(p_ddr_set->ddr_base_addr + p_ddr_set->ddr_start_offset), \
			((p_ddr_set->ddr_size << 20) - p_ddr_set->ddr_start_offset))) {
			printf("Device test failed!!!\n");
			reset_system();
		}
		else
			printf("Device test pass!\n");
	}
}

unsigned int hot_boot(void){
	if (((rd_reg(SCRATCH0) >> 24) & 0xFF) == 0x11) {
		/*hot boot*/
		return 0;
	}
	else{
		return 1;
	}
}

#if 0
void ddr_debug(void){
	/*debug ddr and print info*/
	printf("DDR debug information:\n");
	printf("	ZQ0DR:    0x%8x    ZQ1DR: 0x%8x    ZQ2DR: 0x%8x\n", \
			rd_reg(DDR0_PUB_ZQ0DR), rd_reg(DDR0_PUB_ZQ1DR), rd_reg(DDR0_PUB_ZQ2DR));
	printf("	PIR:      0x%8x    PGSR0: 0x%8x\n", rd_reg(DDR0_PUB_PIR), rd_reg(DDR0_PUB_PGSR0));
	printf("	DX0GSR2:  0x%8x\n", rd_reg(DDR0_PUB_DX0GSR2));
	printf("	DX1GSR2:  0x%8x\n", rd_reg(DDR0_PUB_DX1GSR2));
	printf("	DX2GSR2:  0x%8x\n", rd_reg(DDR0_PUB_DX2GSR2));
	printf("	DX3GSR2:  0x%8x\n", rd_reg(DDR0_PUB_DX3GSR2));
	printf("	DMC_CTRL: 0x%8x\n", rd_reg(DMC_DDR_CTRL));
	printf("	MAP_0_0:  0x%8x    MAP_1_0:  0x%8x\n", rd_reg(DDR0_ADDRMAP_0), rd_reg(DDR1_ADDRMAP_0));
	printf("	MAP_0_1:  0x%8x    MAP_1_1:  0x%8x\n", rd_reg(DDR0_ADDRMAP_1), rd_reg(DDR1_ADDRMAP_1));
	printf("	MAP_0_2:  0x%8x    MAP_1_2:  0x%8x\n", rd_reg(DDR0_ADDRMAP_2), rd_reg(DDR1_ADDRMAP_2));
	printf("	MAP_0_3:  0x%8x    MAP_1_3:  0x%8x\n", rd_reg(DDR0_ADDRMAP_3), rd_reg(DDR1_ADDRMAP_3));
	printf("	MAP_0_4:  0x%8x    MAP_1_4:  0x%8x\n", rd_reg(DDR0_ADDRMAP_4), rd_reg(DDR1_ADDRMAP_4));
}
#endif