
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/ddr/mmc_define.h
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

#define AM_DDR_PLL_CNTL						0xc8836800
  //bit 31.  PLL lock.  read only
  //bit 30.  PLL power down. 1 = PLL powerdown. 0 = PLL enable.
  //bit 29.  PLL reset.
  //bit 28.  SSEN
  //bit 27:24. SS_AMP
  //bit 23:20.  SS_CLK
  //bit 17:16.  OD.
  //bit 15:14.  OD1.
  //bit 13:9.    N.
  //bit 8:0      M
#define AM_DDR_PLL_CNTL1					0xc8836804
  //bit 31:28.  DPLL_LM_W
  //bit 27:22.  DPLL_LM_S.
  //bit 21.     DPFD_LMODE
  //bit 20:19.  DC_VC_IN.
  //bit 18:17.  DCO_SDMCK_SEL
  //bit 16.     DCO_M_EN.
  //bit 15.     SDM_PR_EN.
  //bit 14      DIV_MODE.
  //bit 13:2   DIV_FRAC
  //bit 1       AFC_DSEL_BYPASS.
  //bit 0.      AFC_DSEL_IN.
#define AM_DDR_PLL_CNTL2					0xc8836808
  //bit 29:26.  FILTER_PVT2.
  //bit 25:22.  FILTER PVT1.
  //bit 21:11.  FILTER ACQ2.
  //bit 10:0.   FILTER ACQ1.
#define AM_DDR_PLL_CNTL3					0xc883680c
  //bit 31:20.  DPLL REVE.
  //bit 13:6.  TDC_BUF.
  //bit 5.     PVT_FIX_EN.
  //bit 4:3.   DCO_IUP.
  //bit 2.     IIR_BYPASS_N.
  //bit 1      TDC_EN
#define AM_DDR_PLL_CNTL4					0xc8836810
 //bit 21:20.  DPLL_CLK_EN.
 //bit 13.     DCO_SDM_EN
 //bit 12.     BGP_EN.
 //bit 11:8.   GPB_C
#define AM_DDR_PLL_STS						0xc8836814
  //bit 31. DDR_PLL lock.
  //bit 8:1.  DPLL_OUT_RSV
  //bit 0.   AFC DONE.

#define DDR_CLK_CNTL						0xc8836818
  //bit 31     ddr_pll_clk enable. enable the clock from DDR_PLL to clock generateion.
  // whenever change the DDR_PLL frequency, disable the clock, after the DDR_PLL locked, then enable it again.
  //bit 30.    ddr_pll_prod_test_en.  enable the clock to clock/32 which to clock frequency measurement and production test pin.
  //bit 29.    ddr_phy_ctl_clk enable.
  //bit 28.    clock generation logic soft reset. 0 = reset.
  //bit 27.    phy_4xclk phase inverter..
  //bit 26.    pll_freq divide/2. 1:  use pll div/2 clock as the n_clk. 0: use pll clock as n_clk.  this setting is used for the synopsys DDR PHY PLL fast lock mode.

#define  DDR0_CLK_CTRL						0xc8836c00
//bit 3. force to disable PUB PCLK.
//bit 2. PUB auto ctrl n_clk clock gating enable. when the DFI_LP_REQ and DFI_LP_ACK detected , auto gated PUB n_clk.
//bit 1. force to disable PUB PCLK.
//bit 0. PUB pclk auto clock gating enable.  when the IP detected PCTL enter power down mode,  use this bit to gating pub pclk.
#define  DDR0_SOFT_RESET					0xc8836c04
//bit 3. pub n_clk domain soft reset.  1 active.
//bit 2. pub p_clk domain soft reset.

#define  DDR0_APD_CTRL						0xc8836c08
//bit 15:8.   power down enter latency. when IP checked the dfi_lp_req && dfi_lp_ack,  give PCTL and pub additional latency let them settle down, then gating the clock.
//bit 7:0.  no active latency.  after c_active_in become to low, wait additional latency to check the pctl low power state.
