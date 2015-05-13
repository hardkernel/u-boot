
/*
 * arch/arm/include/asm/arch-gxb/timing.h
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

#ifndef __AML_TIMING_H_
#define __AML_TIMING_H_

#ifndef __ASSEMBLY__
struct ddr_set{
	unsigned       ddr_test;
	unsigned       phy_memory_start;
	unsigned       phy_memory_size;
	unsigned       t_pub0_dtar;
	unsigned       t_pub1_dtar;
	unsigned       t_ddr_apd_ctrl;
	unsigned       t_ddr_clk_ctrl;
	unsigned short t_pctl_1us_pck;   //PCTL TOGCNT1U
	unsigned short t_pctl_100ns_pck; //PCTL TOGCNT100N
	unsigned short t_pctl_init_us;   //PCTL TINIT
	unsigned short t_pctl_rsth_us;   //PCTL TRSTH
	unsigned short t_pctl_rstl_us;   //PCTL TRSTL
	unsigned short t_pad1;        //padding for 4 bytes alignment
	unsigned       t_pctl_mcfg;   //PCTL MCFG
	unsigned       t_pctl_mcfg1;  //PCTL MCFG1
	unsigned       t_pub_zq0pr;   //PUB ZQ0PR
	unsigned       t_pub_dxccr;   //PUB DXCCR
	unsigned       t_pub_acbdlr0; //PUB ACBDLR0
	unsigned       t_pub_dcr;     //PUB DCR
	unsigned short t_pub_mr[4];   //PUB MR0-3
	unsigned       t_pub_dtpr[4]; //PUB DTPR0-3
	unsigned       t_pub_pgcr2;   //PUB PGCR2
	unsigned       t_pub_dtcr;    //PUB DTCR
	unsigned       t_pub_ptr[5];  //PUB PTR0-3
	unsigned       t_pub_aciocr;  //PUB ACIOCR
	unsigned       t_pub_dsgcr;   //PUB DSGCR
	unsigned short t_pctl_trefi;  //PCTL TREFI
	unsigned short t_pctl_trefi_mem_ddr3; //PCTL TREFI MEM DDR3
	unsigned short t_pctl_tmrd;   //PCTL TMRD 2..4
	unsigned short t_pctl_trfc;   //PCTL TRFC 36..374
	unsigned short t_pctl_trp;    //PCTL TRP  0
	unsigned short t_pctl_tal;    //PCTL TAL 0,CL-1,CL-2
	unsigned short t_pctl_tcwl;   //PCTL TCWL
	unsigned short t_pctl_tcl;    //PCTL TCL
	unsigned short t_pctl_tras;   //PCTL TRAS 15..38
	unsigned short t_pctl_trc;    //PCTL TRC   20..52
	unsigned short t_pctl_trcd;   //PCTL TRCD 5..14
	unsigned short t_pctl_trrd;   //PCTL TRRD 4..8
	unsigned short t_pctl_trtp;   //PCTL TRTP 3..8
	unsigned short t_pctl_twr;    //PCTL TWR  6..16
	unsigned short t_pctl_twtr;   //PCTL TWTR 3..8
	unsigned short t_pctl_texsr;  //PCTL TEXSR 512
	unsigned short t_pctl_txp;    //PCTL TXP  1..7
	unsigned short t_pctl_tdqs;   //PCTL TDQS 1..12
	unsigned short t_pctl_trtw;   //PCTL TRTW 2..10
	unsigned short t_pctl_tcksre; //PCTL TCKSRE 5..15
	unsigned short t_pctl_tcksrx; //PCTL TCKSRX 5..15
	unsigned short t_pctl_tmod;   //PCTL TMOD 0..31
	unsigned short t_pctl_tcke;   //PCTL TCKE 3..6
	unsigned short t_pctl_tzqcs;  //PCTL TZQCS 64
	unsigned short t_pctl_tzqcl;  //PCTL TZQCL 0..1023
	unsigned short t_pctl_txpdll; //PCTL TXPDLL 3..63
	unsigned short t_pctl_tzqcsi; //PCTL TZQCSI 0..4294967295
	unsigned short t_pctl_scfg;   //PCTL
	unsigned       t_mmc_ddr_ctrl;
	unsigned       t_ddr_pll_cntl;
	unsigned       t_ddr_clk;
	unsigned       t_mmc_ddr_timming0;
	unsigned       t_mmc_ddr_timming1;
	unsigned       t_mmc_ddr_timming2;
	unsigned       t_mmc_arefr_ctrl;
	int            (* init_pctl)(struct ddr_set *);
}__attribute__ ((packed));

struct pll_clk_settings{
	unsigned sys_pll_cntl;  //HHI_SYS_PLL_CNTL
	unsigned sys_clk_cntl;  //HHI_SYS_CPU_CLK_CNTL0
	unsigned sys_clk_cntl1;  //HHI_SYS_CPU_CLK_CNTL1
	unsigned sys_clk;
	unsigned a9_clk;
	unsigned mpll_cntl;
	unsigned mpeg_clk_cntl;
	unsigned vid_pll_cntl;
	unsigned vid2_pll_cntl;
	unsigned spi_setting;
	unsigned nfc_cfg;
	unsigned sdio_cmd_clk_divide;
	unsigned sdio_time_short;
	unsigned uart;
	unsigned clk81;
	unsigned gp_pll_cntl;
	unsigned gp2_pll_cntl;
}__attribute__ ((packed));

/*pll settings*/

//DDR PLL
#define CFG_DDR_PLL_CNTL_2 (0x59C88000)
#define CFG_DDR_PLL_CNTL_3 (0xCA463823)
#define CFG_DDR_PLL_CNTL_4 (0x0286A027)
#define CFG_DDR_PLL_CNTL_5 (0x00003800)

//SYS PLL
#define CFG_SYS_PLL_CNTL_2 (0x5ac82000)
#define CFG_SYS_PLL_CNTL_3 (0x8e452015)
#define CFG_SYS_PLL_CNTL_4 (0x0001d40c)
#define CFG_SYS_PLL_CNTL_5 (0x00000870)

//FIXED PLL(MPLL)
#define CFG_MPLL_CNTL_2 (0x59C80000)
#define CFG_MPLL_CNTL_3 (0xCA45B822)
#define CFG_MPLL_CNTL_4 (0x00014007)
#define CFG_MPLL_CNTL_5 (0xB5500E1A)
#define CFG_MPLL_CNTL_6 (0xF4454545)
#define CFG_MPLL_CNTL_7 (0)
#define CFG_MPLL_CNTL_8 (0)
#define CFG_MPLL_CNTL_9 (0)

#endif //__ASSEMBLY__
#endif //__AML_TIMING_H_