
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
	unsigned char  ddr_channel_set;
	unsigned char  ddr_type;
	unsigned char  ddr_2t_mode;
	unsigned char  ddr_full_test;
	unsigned char  ddr_size_detect;
	unsigned char  ddr_drv;
	unsigned char  ddr_odt;
	unsigned char  ddr_timing_ind;
	unsigned short ddr_size; //define in header file
	unsigned short ddr_clk;
	unsigned int   ddr_base_addr;
	unsigned int   ddr_start_offset;
	unsigned int   ddr_pll_ctrl;
	unsigned int   ddr_dmc_ctrl;
	unsigned int   ddr0_addrmap[5];
	unsigned int   ddr1_addrmap[5];

	/* pub defines */
	unsigned int   t_pub_ptr[5];  //PUB PTR0-3
	unsigned short t_pub_mr[8];   //PUB MR0-3
	unsigned int   t_pub_odtcr;
	unsigned int   t_pub_dtpr[8]; //PUB DTPR0-3
	unsigned int   t_pub_pgcr0;   //PUB PGCR0
	unsigned int   t_pub_pgcr1;   //PUB PGCR1
	unsigned int   t_pub_pgcr2;   //PUB PGCR2
	unsigned int   t_pub_pgcr3;   //PUB PGCR3
	unsigned int   t_pub_dxccr;   //PUB DXCCR
	unsigned int   t_pub_dtcr0;    //PUB DTCR
	unsigned int   t_pub_dtcr1;    //PUB DTCR
	unsigned int   t_pub_aciocr[5];  //PUB ACIOCRx
	unsigned int   t_pub_dx0gcr[3];  //PUB DX0GCRx
	unsigned int   t_pub_dx1gcr[3];  //PUB DX1GCRx
	unsigned int   t_pub_dx2gcr[3];  //PUB DX2GCRx
	unsigned int   t_pub_dx3gcr[3];  //PUB DX3GCRx
	unsigned int   t_pub_dcr;     //PUB DCR
	unsigned int   t_pub_dtar;
	unsigned int   t_pub_dsgcr;   //PUB DSGCR
	unsigned int   t_pub_zq0pr;   //PUB ZQ0PR
	unsigned int   t_pub_zq1pr;   //PUB ZQ1PR
	unsigned int   t_pub_zq2pr;   //PUB ZQ2PR
	unsigned int   t_pub_zq3pr;   //PUB ZQ3PR
	unsigned int   t_pub_vtcr1;

	/* pctl0 defines */
	unsigned short t_pctl0_1us_pck;   //PCTL TOGCNT1U
	unsigned short t_pctl0_100ns_pck; //PCTL TOGCNT100N
	unsigned short t_pctl0_init_us;   //PCTL TINIT
	unsigned short t_pctl0_rsth_us;   //PCTL TRSTH
	unsigned int   t_pctl0_mcfg;   //PCTL MCFG
	unsigned int   t_pctl0_mcfg1;  //PCTL MCFG1
	unsigned short t_pctl0_scfg;   //PCTL SCFG
	unsigned short t_pctl0_sctl;   //PCTL SCTL
	unsigned int   t_pctl0_ppcfg;
	unsigned short t_pctl0_dfistcfg0;
	unsigned short t_pctl0_dfistcfg1;
	unsigned short t_pctl0_dfitctrldelay;
	unsigned short t_pctl0_dfitphywrdata;
	unsigned short t_pctl0_dfitphywrlta;
	unsigned short t_pctl0_dfitrddataen;
	unsigned short t_pctl0_dfitphyrdlat;
	unsigned short t_pctl0_dfitdramclkdis;
	unsigned short t_pctl0_dfitdramclken;
	unsigned short t_pctl0_dfitphyupdtype0;
	unsigned short t_pctl0_dfitphyupdtype1;
	unsigned short t_pctl0_dfitctrlupdmin;
	unsigned short t_pctl0_dfitctrlupdmax; //TODO - check 16/32
	unsigned short t_pctl0_dfiupdcfg; //TODO - check 16/32
	unsigned short t_pctl0_cmdtstaten;
	unsigned short t_ddr_align;
	unsigned int   t_pctl0_dfiodtcfg;
	unsigned int   t_pctl0_dfiodtcfg1;
	unsigned int   t_pctl0_dfilpcfg0;

	//PUB CLK fine tune
	unsigned int   t_pub_acbdlr0; //2015.09.21 CK0 delay for different board PCB design
	unsigned int   t_pub_aclcdlr;

	/* ddr functions */
	unsigned int   ddr_func;
	/* dqs correction */
	unsigned char  wr_adj_per[6];
	unsigned char  rd_adj_per[6];

	/* aligned */
	/* 2016.04.12 update */
	unsigned long  t_rsv_int64_0;
	unsigned long  t_rsv_int64_1;
	unsigned long  t_rsv_int64_2;
}__attribute__ ((packed));

struct ddr_timing{
	//Identifier
	unsigned char  identifier; //refer ddr.h

	//DTPR0
	unsigned char  cfg_ddr_rtp;
	unsigned char  cfg_ddr_wtr;
	unsigned char  cfg_ddr_rp;
	unsigned char  cfg_ddr_rcd;
	unsigned char  cfg_ddr_ras;
	unsigned char  cfg_ddr_rrd;
	unsigned char  cfg_ddr_rc;

	//DTPR1
	unsigned char  cfg_ddr_mrd;
	unsigned char  cfg_ddr_mod;
	unsigned char  cfg_ddr_faw;
	unsigned char  cfg_ddr_wlmrd;
	unsigned char  cfg_ddr_wlo;

	//DTPR2
	unsigned char  cfg_ddr_xp;

	//DTPR1
	unsigned short cfg_ddr_rfc;

	//DTPR2
	unsigned short cfg_ddr_xs;
	unsigned short cfg_ddr_dllk;
	unsigned char  cfg_ddr_cke;
	unsigned char  cfg_ddr_rtodt;
	unsigned char  cfg_ddr_rtw;

	unsigned char  cfg_ddr_refi;
	unsigned char  cfg_ddr_refi_mddr3;
	unsigned char  cfg_ddr_cl;
	unsigned char  cfg_ddr_wr;
	unsigned char  cfg_ddr_cwl;
	unsigned char  cfg_ddr_al;
	unsigned char  cfg_ddr_dqs;
	unsigned char  cfg_ddr_cksre;
	unsigned char  cfg_ddr_cksrx;
	unsigned char  cfg_ddr_zqcs;
	unsigned char  cfg_ddr_xpdll;
	unsigned short cfg_ddr_exsr;
	unsigned short cfg_ddr_zqcl;
	unsigned short cfg_ddr_zqcsi;

	/* aligned */
	/* 2016.04.12 update */
	unsigned char  cfg_ddr_tccdl;
	unsigned char  cfg_ddr_tdqsck;
	unsigned char  cfg_ddr_tdqsckmax;
	unsigned char  rsv_char;

	/* reserved */
	unsigned int   rsv_int;
}__attribute__ ((packed));

typedef struct ddr_set ddr_set_t;
typedef struct ddr_timing ddr_timing_t;

struct pll_set{
	unsigned short cpu_clk;
	unsigned short pxp;
	unsigned int spi_ctrl;
	unsigned short vddee;
	unsigned short vcck;
	unsigned char szPad[4];
	unsigned long  lCustomerID;
	unsigned short	debug_mode;
	unsigned short	ddr_clk_debug;
	unsigned short	cpu_clk_debug;
	unsigned short	rsv_s1;
	/* align */
	unsigned long	rsv_l2;
	unsigned long	rsv_l3;
	unsigned long	rsv_l4;
	unsigned long	rsv_l5;
}__attribute__ ((packed));

typedef struct pll_set pll_set_t;

#endif //__AML_TIMING_H_