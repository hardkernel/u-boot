
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

#include "ddr_pctl_define.h"
#include "ddr_pub_define.h"
#include "dmc_define.h"
#include "mmc_define.h"
#include "sec_mmc_define.h"
#include <asm/arch/timer.h>
#include <asm/arch/ddr.h>
#include <asm/arch/secure_apb.h>
#include <pll.h>
#include <config.h>
#include <asm/arch/cpu.h>
#include <asm/arch/timing.h>
#include <memtest.h>
#include <watchdog.h>
#include <cache.h>
#include "timing.c"

static ddr_set_t * p_ddr_set = &__ddr_setting;

unsigned int ddr_init(void){
	/*detect hot boot or cold boot*/
	//if(hot_boot()){
	//	printf("hot boot, skip ddr init!\n");
	//	return 0;
	//}

	ddr_pre_init();
	ddr_init_pll();
	ddr_init_pctl();
	ddr_init_dmc();
	ddr_print_info();
	mem_test();
	return 0;
}

#ifdef CONFIG_CMD_DDR_TEST
static unsigned zqcr = 0;
#endif

unsigned int ddr_init_pll(void){
	wr_reg(P_AM_ANALOG_TOP_REG1, rd_reg(P_AM_ANALOG_TOP_REG1) | (1<<0));
	wr_reg(P_HHI_MPLL_CNTL5, rd_reg(P_HHI_MPLL_CNTL5) | (1<<0));

	/* DDR PLL BANDGAP*/
	wr_reg(AM_DDR_PLL_CNTL4, rd_reg(AM_DDR_PLL_CNTL4) & (~(1<<12)));
	wr_reg(AM_DDR_PLL_CNTL4, rd_reg(AM_DDR_PLL_CNTL4)|(1<<12));
	udelay(10);
	//static unsigned short ddr_clk;
#ifdef CONFIG_CMD_DDR_TEST
	static unsigned ddr_pll;
	printf("PREG_STICKY_REG0: 0x%8x\n", rd_reg(PREG_STICKY_REG0));
	printf("PREG_STICKY_REG1: 0x%8x\n", rd_reg(PREG_STICKY_REG1));
	if ((rd_reg(PREG_STICKY_REG0)>>20) == 0xf13) {
		zqcr = rd_reg(PREG_STICKY_REG0) & 0xfffff;
		ddr_pll = rd_reg(P_PREG_STICKY_REG1);
		//writel(ddr_pll|(1<<29),AM_DDR_PLL_CNTL);
		printf("PREG_STICKY_REG0: 0x%8x\n", rd_reg(PREG_STICKY_REG0));
		printf("PREG_STICKY_REG1: 0x%8x\n", rd_reg(PREG_STICKY_REG1));
		wr_reg(PREG_STICKY_REG0,0);
		wr_reg(PREG_STICKY_REG1,0);
	}
	else {
		ddr_pll=0x00010885;
		printf("PREG_STICKY_REG0: 0x%8x\n", rd_reg(PREG_STICKY_REG0));
	}
#endif

	/* ddr pll init*/
	do {
		//wr_reg(AM_DDR_PLL_CNTL1, 0x1);
		wr_reg(AM_DDR_PLL_CNTL, (1<<29));
		wr_reg(AM_DDR_PLL_CNTL1, CFG_DDR_PLL_CNTL_1);
		wr_reg(AM_DDR_PLL_CNTL2, CFG_DDR_PLL_CNTL_2);
		wr_reg(AM_DDR_PLL_CNTL3, CFG_DDR_PLL_CNTL_3);
		wr_reg(AM_DDR_PLL_CNTL4, CFG_DDR_PLL_CNTL_4);
		wr_reg(AM_DDR_PLL_CNTL, ((1<<29) | (p_ddr_set->ddr_pll_ctrl)));
		wr_reg(AM_DDR_PLL_CNTL, rd_reg(AM_DDR_PLL_CNTL)&(~(1<<29)));
		udelay(200);
	}while(pll_lock_check(AM_DDR_PLL_CNTL, "DDR PLL"));

	/* Enable the DDR DLL clock input from PLL */
	wr_reg(DDR_CLK_CNTL, 0xb0000000);
	wr_reg(DDR_CLK_CNTL, 0xb0000000);

	print_ddr_info();
	return 0;
}

void print_ddr_info(void){
	unsigned int ddr_pll = rd_reg(AM_DDR_PLL_CNTL)&(~(1<<29));
	unsigned int ddr_clk = 2*(((24 * (ddr_pll&0x1ff))/((ddr_pll>>9)&0x1f))>>((ddr_pll>>16)&0x3));
	printf("DDR clk: %dMHz\n",ddr_clk);
}

unsigned int ddr_init_dmc(void){
	wr_reg(DMC_DDR_CTRL, p_ddr_set->ddr_dmc_ctrl);
	printf("DMC_DDR_CTRL: 0x%8x\n", rd_reg(DMC_DDR_CTRL));
	if (p_ddr_set->ddr_channel_set == CONFIG_DDR01_SHARE_AC) {
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

	//// ENABLE THE DMC AUTO REFRESH FUNCTION
	wr_reg(DMC_REFR_CTRL2, 0X20109A27);
	wr_reg(DMC_REFR_CTRL1, 0X8800191);

	wr_reg(DMC_PCTL_LP_CTRL, 0x440620);
	wr_reg(DDR0_APD_CTRL, 0x45);
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
	writel(0xbff00000, 0xc4200c04);
	writel(0x00000001, 0xc4200c00);

	return 0;
}

unsigned int ddr_init_pctl(void){
	unsigned int ddr0_enabled = !(((p_ddr_set->ddr_dmc_ctrl) >> 7) & 0x1); //check if ddr1 only enabled
	unsigned int ddr1_enabled = !(((p_ddr_set->ddr_dmc_ctrl) >> 6) & 0x1); //check if ddr0 only enabled

	printf("ddr0_enabled: %d\n", ddr0_enabled);
	printf("ddr1_enabled: %d\n", ddr1_enabled);

	// RELEASE THE DDR DLL RESET PIN.
	wr_reg(DMC_SOFT_RST, 0xFFFFFFFF);
	wr_reg(DMC_SOFT_RST1, 0xFFFFFFFF);

	// ENABLE UPCTL AND PUB CLOCK AND RESET.
	//@@@ enable UPCTL and PUB clock and reset.
	wr_reg(DMC_PCTL_LP_CTRL, 0x550620);
	wr_reg(DDR0_SOFT_RESET, 0xf);

	// INITIALIZATION PHY.
	// FOR SIMULATION TO REDUCE THE INIT TIME.
	wr_reg(DDR0_PUB_PTR0, p_ddr_set->t_pub_ptr[0]);
	wr_reg(DDR0_PUB_PTR1, p_ddr_set->t_pub_ptr[1]);
	wr_reg(DDR0_PUB_PTR3, p_ddr_set->t_pub_ptr[3]);
	wr_reg(DDR0_PUB_PTR4, p_ddr_set->t_pub_ptr[4]);

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

	wr_reg(DDR0_PUB_PGCR2, p_ddr_set->t_pub_pgcr2);
	//printf("\nDDR0_PUB_PGCR2: 0x%8x\n", rd_reg(DDR0_PUB_PGCR2));
	//wr_reg(DDR0_PUB_PGCR2, 0x00f05f97);
	wr_reg(DDR0_PUB_PGCR3, p_ddr_set->t_pub_pgcr3);
	wr_reg(DDR0_PUB_DXCCR, p_ddr_set->t_pub_dxccr);

	wr_reg(DDR0_PUB_DTPR2, p_ddr_set->t_pub_dtpr[2]);
	wr_reg(DDR0_PUB_DTPR3, p_ddr_set->t_pub_dtpr[3]);
	wr_reg(DDR0_PUB_DTCR, p_ddr_set->t_pub_dtcr);

	//DDR0_DLL_LOCK_WAIT
	wait_set(DDR0_PUB_PGSR0, 0);

	wr_reg(DDR0_PUB_PGCR1, p_ddr_set->t_pub_pgcr1);
	//wr_reg(DDR0_PUB_DTCR, 0x430030c7);
	//wr_reg(DDR0_PUB_DTPR3, 0x2010a902); //tmp disable
	wr_reg(DDR0_PUB_ACIOCR1, 0);
	wr_reg(DDR0_PUB_ACIOCR2, 0);
	wr_reg(DDR0_PUB_ACIOCR3, 0);
	wr_reg(DDR0_PUB_ACIOCR4, 0);
	wr_reg(DDR0_PUB_ACIOCR5, 0);
	wr_reg(DDR0_PUB_DX0GCR1, 0);
	wr_reg(DDR0_PUB_DX0GCR2, 0);
	wr_reg(DDR0_PUB_DX0GCR3, 0);
	wr_reg(DDR0_PUB_DX1GCR1, 0);
	wr_reg(DDR0_PUB_DX1GCR2, 0);
	wr_reg(DDR0_PUB_DX1GCR3, 0);
	wr_reg(DDR0_PUB_DX2GCR1, 0);
	wr_reg(DDR0_PUB_DX2GCR2, 0);
	wr_reg(DDR0_PUB_DX2GCR3, 0);
	wr_reg(DDR0_PUB_DX3GCR1, 0);
	wr_reg(DDR0_PUB_DX3GCR2, 0);
	wr_reg(DDR0_PUB_DX3GCR3, 0);

	//   2:0   011: DDR0_ MODE.   100:   LPDDR2 MODE.
	//   3:    8 BANK.
	//   7;    MPR FOR DATA TRAINING.
	wr_reg(DDR0_PUB_DCR, p_ddr_set->t_pub_dcr);

	wr_reg(DDR0_PUB_DTAR0, p_ddr_set->t_pub_dtar);
	wr_reg(DDR0_PUB_DTAR1, (0X8 | p_ddr_set->t_pub_dtar));
	wr_reg(DDR0_PUB_DTAR2, (0X10 | p_ddr_set->t_pub_dtar));
	wr_reg(DDR0_PUB_DTAR3, (0X18 | p_ddr_set->t_pub_dtar));

	//// DDR PHY INITIALIZATION
	wr_reg(DDR0_PUB_PIR, 0X581);
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
		wr_reg(DDR1_PCTL_TOGCNT1U, p_ddr_set->t_pctl1_1us_pck);
		wr_reg(DDR1_PCTL_TOGCNT100N, p_ddr_set->t_pctl1_100ns_pck);
		wr_reg(DDR1_PCTL_TINIT, p_ddr_set->t_pctl1_init_us); //20
		wr_reg(DDR1_PCTL_TRSTH, p_ddr_set->t_pctl1_rsth_us); //50
		wr_reg(DDR1_PCTL_MCFG, (p_ddr_set->t_pctl1_mcfg)|((p_ddr_set->ddr_2t_mode)?(1<<3):(0<<3)));
		wr_reg(DDR1_PCTL_MCFG1, p_ddr_set->t_pctl1_mcfg1);
	}

	printf("DDR0 2T mode: %d\n", ((rd_reg(DDR0_PCTL_MCFG) >> 3) & 0x1));
	printf("DDR1 2T mode: %d\n", ((rd_reg(DDR1_PCTL_MCFG) >> 3) & 0x1));

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
		wr_reg(DDR0_PCTL_TRFC, p_ddr_set->t_pctl0_trfc);
		wr_reg(DDR0_PCTL_TREFI_MEM_DDR3, p_ddr_set->t_pctl0_trefi_mem_ddr3);
		wr_reg(DDR0_PCTL_TMRD, p_ddr_set->t_pctl0_tmrd);
		wr_reg(DDR0_PCTL_TRP, p_ddr_set->t_pctl0_trp);
		wr_reg(DDR0_PCTL_TAL, p_ddr_set->t_pctl0_tal);
		wr_reg(DDR0_PCTL_TCWL, p_ddr_set->t_pctl0_tcwl);
		wr_reg(DDR0_PCTL_TCL, p_ddr_set->t_pctl0_tcl);
		wr_reg(DDR0_PCTL_TRAS, p_ddr_set->t_pctl0_tras);
		wr_reg(DDR0_PCTL_TRC, p_ddr_set->t_pctl0_trc);
		wr_reg(DDR0_PCTL_TRCD, p_ddr_set->t_pctl0_trcd);
		wr_reg(DDR0_PCTL_TRRD, p_ddr_set->t_pctl0_trrd);
		wr_reg(DDR0_PCTL_TRTP, p_ddr_set->t_pctl0_trtp);
		wr_reg(DDR0_PCTL_TWR, p_ddr_set->t_pctl0_twr);
		wr_reg(DDR0_PCTL_TWTR, p_ddr_set->t_pctl0_twtr);
		wr_reg(DDR0_PCTL_TEXSR, p_ddr_set->t_pctl0_texsr);
		wr_reg(DDR0_PCTL_TXP, p_ddr_set->t_pctl0_txp);
		wr_reg(DDR0_PCTL_TDQS, p_ddr_set->t_pctl0_tdqs);
		wr_reg(DDR0_PCTL_TRTW, p_ddr_set->t_pctl0_trtw);
		wr_reg(DDR0_PCTL_TCKSRE, p_ddr_set->t_pctl0_tcksre);
		wr_reg(DDR0_PCTL_TCKSRX, p_ddr_set->t_pctl0_tcksrx);
		wr_reg(DDR0_PCTL_TMOD, p_ddr_set->t_pctl0_tmod);
		wr_reg(DDR0_PCTL_TCKE, p_ddr_set->t_pctl0_tcke);
		wr_reg(DDR0_PCTL_TZQCS, p_ddr_set->t_pctl0_tzqcs);
		wr_reg(DDR0_PCTL_TZQCL, p_ddr_set->t_pctl0_tzqcl);
		wr_reg(DDR0_PCTL_TXPDLL, p_ddr_set->t_pctl0_txpdll);
		wr_reg(DDR0_PCTL_TZQCSI, p_ddr_set->t_pctl0_tzqcsi);
		wr_reg(DDR0_PCTL_SCFG, p_ddr_set->t_pctl0_scfg);
		wr_reg(DDR0_PCTL_SCTL, p_ddr_set->t_pctl0_sctl);
	}

	if (ddr1_enabled) {
		wr_reg(DDR1_PCTL_TRFC, p_ddr_set->t_pctl1_trfc);
		wr_reg(DDR1_PCTL_TREFI_MEM_DDR3, p_ddr_set->t_pctl1_trefi_mem_ddr3);
		wr_reg(DDR1_PCTL_TMRD, p_ddr_set->t_pctl1_tmrd);
		wr_reg(DDR1_PCTL_TRP, p_ddr_set->t_pctl1_trp);
		wr_reg(DDR1_PCTL_TAL, p_ddr_set->t_pctl1_tal);
		wr_reg(DDR1_PCTL_TCWL, p_ddr_set->t_pctl1_tcwl);
		wr_reg(DDR1_PCTL_TCL, p_ddr_set->t_pctl1_tcl);
		wr_reg(DDR1_PCTL_TRAS, p_ddr_set->t_pctl1_tras);
		wr_reg(DDR1_PCTL_TRC, p_ddr_set->t_pctl1_trc);
		wr_reg(DDR1_PCTL_TRCD, p_ddr_set->t_pctl1_trcd);
		wr_reg(DDR1_PCTL_TRRD, p_ddr_set->t_pctl1_trrd);
		wr_reg(DDR1_PCTL_TRTP, p_ddr_set->t_pctl1_trtp);
		wr_reg(DDR1_PCTL_TWR, p_ddr_set->t_pctl1_twr);
		wr_reg(DDR1_PCTL_TWTR, p_ddr_set->t_pctl1_twtr);
		wr_reg(DDR1_PCTL_TEXSR, p_ddr_set->t_pctl1_texsr);
		wr_reg(DDR1_PCTL_TXP, p_ddr_set->t_pctl1_txp);
		wr_reg(DDR1_PCTL_TDQS, p_ddr_set->t_pctl1_tdqs);
		wr_reg(DDR1_PCTL_TRTW, p_ddr_set->t_pctl1_trtw);
		wr_reg(DDR1_PCTL_TCKSRE, p_ddr_set->t_pctl1_tcksre);
		wr_reg(DDR1_PCTL_TCKSRX, p_ddr_set->t_pctl1_tcksrx);
		wr_reg(DDR1_PCTL_TMOD, p_ddr_set->t_pctl1_tmod);
		wr_reg(DDR1_PCTL_TCKE, p_ddr_set->t_pctl1_tcke);
		wr_reg(DDR1_PCTL_TZQCS, p_ddr_set->t_pctl1_tzqcs);
		wr_reg(DDR1_PCTL_TZQCL, p_ddr_set->t_pctl1_tzqcl);
		wr_reg(DDR1_PCTL_TXPDLL, p_ddr_set->t_pctl1_txpdll);
		wr_reg(DDR1_PCTL_TZQCSI, p_ddr_set->t_pctl1_tzqcsi);
		wr_reg(DDR1_PCTL_SCFG, p_ddr_set->t_pctl1_scfg);
		wr_reg(DDR1_PCTL_SCTL, p_ddr_set->t_pctl1_sctl);
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
		wr_reg(DDR1_PCTL_PPCFG, p_ddr_set->t_pctl1_ppcfg); /* 16bit or 32bit mode */
		wr_reg(DDR1_PCTL_DFISTCFG0, p_ddr_set->t_pctl1_dfistcfg0);
		wr_reg(DDR1_PCTL_DFISTCFG1, p_ddr_set->t_pctl1_dfistcfg1);
		wr_reg(DDR1_PCTL_DFITCTRLDELAY, p_ddr_set->t_pctl1_dfitctrldelay);
		wr_reg(DDR1_PCTL_DFITPHYWRDATA, p_ddr_set->t_pctl1_dfitphywrdata);
		wr_reg(DDR1_PCTL_DFITPHYWRLAT, p_ddr_set->t_pctl1_dfitphywrlta);
		wr_reg(DDR1_PCTL_DFITRDDATAEN, p_ddr_set->t_pctl1_dfitrddataen);
		wr_reg(DDR1_PCTL_DFITPHYRDLAT, p_ddr_set->t_pctl1_dfitphyrdlat);
		wr_reg(DDR1_PCTL_DFITDRAMCLKDIS, p_ddr_set->t_pctl1_dfitdramclkdis);
		wr_reg(DDR1_PCTL_DFITDRAMCLKEN, p_ddr_set->t_pctl1_dfitdramclken);
		wr_reg(DDR1_PCTL_DFILPCFG0, p_ddr_set->t_pctl1_dfilpcfg0);
		wr_reg(DDR1_PCTL_DFITPHYUPDTYPE1, p_ddr_set->t_pctl1_dfitphyupdtype1);
		wr_reg(DDR1_PCTL_DFITCTRLUPDMIN, p_ddr_set->t_pctl1_dfitctrlupdmin);
		wr_reg(DDR1_PCTL_DFIODTCFG, p_ddr_set->t_pctl1_dfiodtcfg);
		wr_reg(DDR1_PCTL_DFIODTCFG1, p_ddr_set->t_pctl1_dfiodtcfg1);
		wr_reg(DDR1_PCTL_CMDTSTATEN, p_ddr_set->t_pctl1_cmdtstaten);
	}

#ifdef CONFIG_CMD_DDR_TEST
	printf("zqcr: 0x%8x\n", zqcr);
	if (zqcr) {
		writel(zqcr, DDR0_PUB_ZQ0PR);
		writel(zqcr, DDR0_PUB_ZQ1PR);
		writel(zqcr, DDR0_PUB_ZQ2PR);
		writel(zqcr, DDR0_PUB_ZQ3PR);
	}
	else {
		writel(p_ddr_set->t_pub_zq0pr, DDR0_PUB_ZQ0PR);
		writel(p_ddr_set->t_pub_zq1pr, DDR0_PUB_ZQ1PR);
		writel(p_ddr_set->t_pub_zq2pr, DDR0_PUB_ZQ2PR);
		writel(p_ddr_set->t_pub_zq3pr, DDR0_PUB_ZQ3PR);
	}
#endif
	wr_reg(DDR0_PUB_PIR, 3);
	wait_set(DDR0_PUB_PGSR0, 0);
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))|(1<<2)|(1<<27)); //jiaxing debug must force update
	udelay(10);
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))&(~((1<<2)|(1<<27))));
	udelay(10);
#ifdef CONFIG_CMD_DDR_TEST
	printf("DDR0_PUB_ZQ0DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ0DR));
	printf("DDR0_PUB_ZQ1DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ1DR));
	printf("DDR0_PUB_ZQ2DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ2DR));
#endif

	wr_reg(DDR0_PUB_PIR, DDR_PIR | PUB_PIR_INIT);
	do {
		printf("DDR_PIR: 0X%8X\n", DDR_PIR);
		udelay(100);
	} while(DDR_PGSR0_CHECK());

	printf("DDR0_PUB_PGSR0: 0X%8X\n", rd_reg(DDR0_PUB_PGSR0));

	//DDR0_CMD_TIMER_WAIT
	if (ddr0_enabled)
		wait_set(DDR0_PCTL_CMDTSTAT, 0);
	if (ddr1_enabled)
		wait_set(DDR1_PCTL_CMDTSTAT, 0);

	////APB_WR(PCTL_PCTL_SCTL, 2); // INIT: 0, CFG: 1, GO: 2, SLEEP: 3, WAKEUP: 4
	if (ddr0_enabled)
		wr_reg(DDR0_PCTL_SCTL, 2);
	if (ddr1_enabled)
		wr_reg(DDR1_PCTL_SCTL, 2);

	////WHILE ((APB_RD(DDR0_PCTL_STAT) & 0x7 ) != 3 ) {}
	//DDR0_STAT_GO_WAIT:
	if (ddr0_enabled)
		wait_set(DDR0_PCTL_STAT, 1);
	if (ddr1_enabled)
		wait_set(DDR1_PCTL_STAT, 1);

#ifdef CONFIG_CMD_DDR_TEST
	printf("DDR0_PUB_PIR: 0x%8x\n", rd_reg(DDR0_PUB_PIR));
	printf("DDR0_PUB_PGSR0: 0x%8x\n", rd_reg(DDR0_PUB_PGSR0));
	printf("DDR0_PUB_DX0GSR2: 0x%8x\n", rd_reg(DDR0_PUB_DX0GSR2));
	printf("DDR0_PUB_DX1GSR2: 0x%8x\n", rd_reg(DDR0_PUB_DX1GSR2));
	printf("DDR0_PUB_DX2GSR2: 0x%8x\n", rd_reg(DDR0_PUB_DX2GSR2));
	printf("DDR0_PUB_DX3GSR2: 0x%8x\n", rd_reg(DDR0_PUB_DX3GSR2));
	printf("DDR0_PUB_ZQ0DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ0DR));
	printf("DDR0_PUB_ZQ1DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ1DR));
	printf("DDR0_PUB_ZQ2DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ2DR));
#endif

	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))|(1<<2));
	wr_reg( DDR0_PUB_ZQCR,(rd_reg(DDR0_PUB_ZQCR))&(~(1<<2)));

#ifdef CONFIG_CMD_DDR_TEST
	printf("DDR0_PUB_ZQ0DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ0DR));
	printf("DDR0_PUB_ZQ1DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ1DR));
	printf("DDR0_PUB_ZQ2DR: 0x%8x\n", rd_reg(DDR0_PUB_ZQ2DR));
#endif
	return 0;
}

void ddr_pre_init(void){
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
		p_ddr_set->t_pctl1_ppcfg = (0x1fc | 1 );
		p_ddr_set->t_pctl0_dfiodtcfg = 0x08;
		p_ddr_set->t_pctl1_dfiodtcfg = 0x08;
		p_ddr_set->ddr_dmc_ctrl	|= (5 << 8);
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
}

void ddr_print_info(void){
	unsigned int dmc_reg = rd_reg(DMC_DDR_CTRL);
	unsigned int chl0_size_reg = (dmc_reg & 0x7);
	unsigned int chl1_size_reg = ((dmc_reg>>3) & 0x7);
	unsigned int chl0_size = 1 << (chl0_size_reg+7); //MB
	printf("ddr0 size: %dMB\n", (chl0_size_reg)>5?0:chl0_size);
	unsigned int chl1_size = 1 << (chl1_size_reg+7); //MB
	printf("ddr1 size: %dMB\n", (chl1_size_reg)>5?0:chl1_size);
}

void mem_test(void){
	if (memTestDataBus((volatile unsigned int *)(uint64_t) \
		(p_ddr_set->ddr_base_addr + p_ddr_set->ddr_start_offset)))
		printf("memTestDataBus failed!!!\n");
	else
		printf("memTestDataBus pass!\n");
	if (memTestAddressBus((volatile unsigned int *)(uint64_t) \
		(p_ddr_set->ddr_base_addr + p_ddr_set->ddr_start_offset), \
		((p_ddr_set->ddr_size << 20) - p_ddr_set->ddr_start_offset)))
		printf("memTestAddressBus failed!!!\n");
	else
		printf("memTestAddressBus pass!\n");
	if (p_ddr_set->ddr_full_test) {
		extern void watchdog_disable(void);
		//disable_mmu_el1();
		watchdog_disable();
		if (memTestDevice((volatile unsigned int *)(uint64_t) \
			(p_ddr_set->ddr_base_addr + p_ddr_set->ddr_start_offset), \
			((p_ddr_set->ddr_size << 20) - p_ddr_set->ddr_start_offset)))
			printf("memTestDevice failed!!!\n");
		else
			printf("memTestDevice pass!\n");
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
