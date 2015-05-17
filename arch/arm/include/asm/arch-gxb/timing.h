
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

struct ddr_set{
	/* common and function defines */
	unsigned       ddr_channel_set;
	unsigned       ddr_base_addr;
	unsigned       ddr_start_offset;
	unsigned       ddr_size; //define in header file
	unsigned       ddr_pll_ctrl;
	unsigned       ddr_dmc_ctrl;
	unsigned       ddr0_addrmap[5];
	unsigned       ddr1_addrmap[5];
	unsigned short ddr_2t_mode;
	unsigned short ddr_full_test;

	/* pub defines */
	unsigned       t_pub_ptr[5];  //PUB PTR0-3
	unsigned       t_pub_odtcr;
	unsigned short t_pub_mr[4];   //PUB MR0-3
	unsigned       t_pub_dtpr[4]; //PUB DTPR0-3
	unsigned       t_pub_pgcr1;   //PUB PGCR1
	unsigned       t_pub_pgcr2;   //PUB PGCR2
	unsigned       t_pub_pgcr3;   //PUB PGCR3
	unsigned       t_pub_dxccr;   //PUB DXCCR
	unsigned       t_pub_dtcr;    //PUB DTCR
	unsigned       t_pub_aciocr[5];  //PUB ACIOCRx
	unsigned       t_pub_dx0gcr[3];  //PUB DX0GCRx
	unsigned       t_pub_dx1gcr[3];  //PUB DX1GCRx
	unsigned       t_pub_dx2gcr[3];  //PUB DX2GCRx
	unsigned       t_pub_dx3gcr[3];  //PUB DX3GCRx
	unsigned       t_pub_dcr;     //PUB DCR
	unsigned       t_pub_dtar;
	unsigned       t_pub_dsgcr;   //PUB DSGCR
	unsigned       t_pub_zq0pr;   //PUB ZQ0PR
	unsigned       t_pub_zq1pr;   //PUB ZQ1PR
	unsigned       t_pub_zq2pr;   //PUB ZQ2PR
	unsigned       t_pub_zq3pr;   //PUB ZQ3PR

	/* pctl0 defines */
	unsigned short t_pctl0_1us_pck;   //PCTL TOGCNT1U
	unsigned short t_pctl0_100ns_pck; //PCTL TOGCNT100N
	unsigned short t_pctl0_init_us;   //PCTL TINIT
	unsigned short t_pctl0_rsth_us;   //PCTL TRSTH
	unsigned       t_pctl0_mcfg;   //PCTL MCFG
	unsigned       t_pctl0_mcfg1;  //PCTL MCFG1
	unsigned short t_pctl0_trfc;   //PCTL TRFC 36..374
	unsigned short t_pctl0_trefi_mem_ddr3; //PCTL TREFI MEM DDR3
	unsigned short t_pctl0_tmrd;   //PCTL TMRD 2..4
	unsigned short t_pctl0_trp;    //PCTL TRP  0
	unsigned short t_pctl0_tal;    //PCTL TAL 0,CL-1,CL-2
	unsigned short t_pctl0_tcwl;   //PCTL TCWL
	unsigned short t_pctl0_tcl;    //PCTL TCL
	unsigned short t_pctl0_tras;   //PCTL TRAS 15..38
	unsigned short t_pctl0_trc;    //PCTL TRC   20..52
	unsigned short t_pctl0_trcd;   //PCTL TRCD 5..14
	unsigned short t_pctl0_trrd;   //PCTL TRRD 4..8
	unsigned short t_pctl0_trtp;   //PCTL TRTP 3..8
	unsigned short t_pctl0_twr;    //PCTL TWR  6..16
	unsigned short t_pctl0_twtr;   //PCTL TWTR 3..8
	unsigned short t_pctl0_texsr;  //PCTL TEXSR 512
	unsigned short t_pctl0_txp;    //PCTL TXP  1..7
	unsigned short t_pctl0_tdqs;   //PCTL TDQS 1..12
	unsigned short t_pctl0_trtw;   //PCTL TRTW 2..10
	unsigned short t_pctl0_tcksre; //PCTL TCKSRE 5..15
	unsigned short t_pctl0_tcksrx; //PCTL TCKSRX 5..15
	unsigned short t_pctl0_tmod;   //PCTL TMOD 0..31
	unsigned short t_pctl0_tcke;   //PCTL TCKE 3..6
	unsigned short t_pctl0_tzqcs;  //PCTL TZQCS 64
	unsigned short t_pctl0_tzqcl;  //PCTL TZQCL 0..1023
	unsigned short t_pctl0_txpdll; //PCTL TXPDLL 3..63
	unsigned short t_pctl0_tzqcsi; //PCTL TZQCSI 0..4294967295
	unsigned short t_pctl0_scfg;   //PCTL SCFG
	unsigned short t_pctl0_sctl;   //PCTL SCTL
	unsigned       t_pctl0_ppcfg;
	unsigned short t_pctl0_dfistcfg0;
	unsigned short t_pctl0_dfistcfg1;
	unsigned short t_pctl0_dfitctrldelay;
	unsigned short t_pctl0_dfitphywrdata;
	unsigned short t_pctl0_dfitphywrlta;
	unsigned short t_pctl0_dfitrddataen;
	unsigned short t_pctl0_dfitphyrdlat;
	unsigned short t_pctl0_dfitdramclkdis;
	unsigned short t_pctl0_dfitdramclken;
	unsigned short t_pctl0_dfitphyupdtype1;
	unsigned short t_pctl0_dfitctrlupdmin;
	unsigned short t_pctl0_cmdtstaten;
	unsigned       t_pctl0_dfiodtcfg;
	unsigned       t_pctl0_dfiodtcfg1;
	unsigned       t_pctl0_dfilpcfg0;

	/* pctl1 defines */
	unsigned short t_pctl1_1us_pck;   //PCTL TOGCNT1U
	unsigned short t_pctl1_100ns_pck; //PCTL TOGCNT100N
	unsigned short t_pctl1_init_us;   //PCTL TINIT
	unsigned short t_pctl1_rsth_us;   //PCTL TRSTH
	unsigned       t_pctl1_mcfg;   //PCTL MCFG
	unsigned       t_pctl1_mcfg1;  //PCTL MCFG1
	unsigned short t_pctl1_trfc;   //PCTL TRFC 36..374
	unsigned short t_pctl1_trefi_mem_ddr3; //PCTL TREFI MEM DDR3
	unsigned short t_pctl1_tmrd;   //PCTL TMRD 2..4
	unsigned short t_pctl1_trp;    //PCTL TRP  0
	unsigned short t_pctl1_tal;    //PCTL TAL 0,CL-1,CL-2
	unsigned short t_pctl1_tcwl;   //PCTL TCWL
	unsigned short t_pctl1_tcl;    //PCTL TCL
	unsigned short t_pctl1_tras;   //PCTL TRAS 15..38
	unsigned short t_pctl1_trc;    //PCTL TRC   20..52
	unsigned short t_pctl1_trcd;   //PCTL TRCD 5..14
	unsigned short t_pctl1_trrd;   //PCTL TRRD 4..8
	unsigned short t_pctl1_trtp;   //PCTL TRTP 3..8
	unsigned short t_pctl1_twr;    //PCTL TWR  6..16
	unsigned short t_pctl1_twtr;   //PCTL TWTR 3..8
	unsigned short t_pctl1_texsr;  //PCTL TEXSR 512
	unsigned short t_pctl1_txp;    //PCTL TXP  1..7
	unsigned short t_pctl1_tdqs;   //PCTL TDQS 1..12
	unsigned short t_pctl1_trtw;   //PCTL TRTW 2..10
	unsigned short t_pctl1_tcksre; //PCTL TCKSRE 5..15
	unsigned short t_pctl1_tcksrx; //PCTL TCKSRX 5..15
	unsigned short t_pctl1_tmod;   //PCTL TMOD 0..31
	unsigned short t_pctl1_tcke;   //PCTL TCKE 3..6
	unsigned short t_pctl1_tzqcs;  //PCTL TZQCS 64
	unsigned short t_pctl1_tzqcl;  //PCTL TZQCL 0..1023
	unsigned short t_pctl1_txpdll; //PCTL TXPDLL 3..63
	unsigned short t_pctl1_tzqcsi; //PCTL TZQCSI 0..4294967295
	unsigned short t_pctl1_scfg;   //PCTL SCFG
	unsigned short t_pctl1_sctl;   //PCTL SCTL
	unsigned       t_pctl1_ppcfg;
	unsigned short t_pctl1_dfistcfg0;
	unsigned short t_pctl1_dfistcfg1;
	unsigned short t_pctl1_dfitctrldelay;
	unsigned short t_pctl1_dfitphywrdata;
	unsigned short t_pctl1_dfitphywrlta;
	unsigned short t_pctl1_dfitrddataen;
	unsigned short t_pctl1_dfitphyrdlat;
	unsigned short t_pctl1_dfitdramclkdis;
	unsigned short t_pctl1_dfitdramclken;
	unsigned short t_pctl1_dfitphyupdtype1;
	unsigned short t_pctl1_dfitctrlupdmin;
	unsigned short t_pctl1_cmdtstaten;
	unsigned       t_pctl1_dfiodtcfg;
	unsigned       t_pctl1_dfiodtcfg1;
	unsigned       t_pctl1_dfilpcfg0;

#if 0
	unsigned       t_ddr_apd_ctrl;
	unsigned       t_ddr_clk_ctrl;
	unsigned short t_pctl_rstl_us;   //PCTL TRSTL
	unsigned short t_pad1;        //padding for 4 bytes alignment
	unsigned       t_pub_acbdlr0; //PUB ACBDLR0

	unsigned short t_pctl_trefi;  //PCTL TREFI
	unsigned       t_mmc_ddr_ctrl;
	unsigned       t_ddr_pll_cntl;
	unsigned       t_ddr_clk;
	unsigned       t_mmc_ddr_timming0;
	unsigned       t_mmc_ddr_timming1;
	unsigned       t_mmc_ddr_timming2;
	unsigned       t_mmc_arefr_ctrl;
#endif
}__attribute__ ((packed));

typedef struct ddr_set ddr_set_t;

struct pll_set{
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

//DDR PLL
#define CFG_DDR_PLL_CNTL_1 (0x69c80000)
#define CFG_DDR_PLL_CNTL_2 (0xca463823)
#define CFG_DDR_PLL_CNTL_3 (0x00c00023)
#define CFG_DDR_PLL_CNTL_4 (0x00303500)

#endif //__AML_TIMING_H_