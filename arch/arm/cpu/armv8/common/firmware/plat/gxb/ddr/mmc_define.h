
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
#define AM_DDR_PLL_CNTL1					0xc8836804
#define AM_DDR_PLL_CNTL2					0xc8836808
#define AM_DDR_PLL_CNTL3					0xc883680c
#define AM_DDR_PLL_CNTL4					0xc8836810
#define AM_DDR_PLL_STS						0xc8836814
  //bit 31. DDR_PLL lock.
  // bit 6:0.  DDR_PLL analog output for test.

#define DDR_CLK_CNTL						0xc8836818
  //bit 31     ddr_pll_clk enable. enable the clock from DDR_PLL to clock generateion.
  // whenever change the DDR_PLL frequency, disable the clock, after the DDR_PLL locked, then enable it again.
  //bit 30.    ddr_pll_prod_test_en.  enable the clock to clock/32 which to clock frequency measurement and production test pin.
  //bit 29.    clock setting update. becasue the register is in PCLK domain. use this pin to update the clock divider setting.
  //bit 28.    clock generation logic soft reset. 0 = reset.
  //bit 15:8   second level divider control.
  //bit 15.    second level divider clock selection. 0 : from first stage clock divider. 1: from second stage clock divider.
  //bit 14.    enable the  first stage clock output to the second stage clock output.
  //bit 13.    second stage clock counter enable.
  //bit 12.    enable the second stage divider clock ouput.
  //bit 11.    enable the 4xclk to DDR PHY.
  //bit 8.     second stage divider selection. 0: /2.  1: /4.
  //bit 7:0.   first stage clock control.
  //bit 7.     first stage clock selection. 0 : DDR_PLL clock output.  1: divider.
  //bit 6.     pll_clk_en.  enable the pll clock output to the first stage clock output selection.
  //bit 3.     first stage clock counter enable.
  //bit 2.     first stage clock divider output enable.
  //bit 1:0.   00:  /2.  01: /4. 10: /8. 11: /16.

#define DDR_CLK_STS							0xc883681c
  //not used.


#define  DDR0_CLK_CTRL						0xc8836c00
//bit 9. invert the DDR PHY n_clk.   ( RF mode).
//bit 8. disable the DDR PHY n_clk.
//bit 7. not used.
//bit 6. force to disable PUB n_clk.
//bit 5. PUB auto clock gating enable. when the IP detected PCTL enter power down mode, use this bit to gating PUB n_clk.
//bit 4. force to disable PCTL n_clk.
//bit 3.  PCTL n_clk auto clock gating enable.  when the IP detected PCTL enter power down mode, use this bit to gating pctl n_clk.
//bit 2. force to disable PUB PCLK.
//bit 1. PUB pclk auto clock gating enable.  when the IP detected PCTL enter power down mode,  use this bit to gating pub pclk.
//bit 0   PCTL PCLK enable.   When never configure PCTL register, we need to enable the APB clock 24 cycles earlier. after finished configure PCTL, 24 cycles later, we should disable this bit to save power.
#define  DDR0_SOFT_RESET					0xc8836c04
//bit 3. pub n_clk domain soft reset.  1 active.
//bit 2. pub p_clk domain soft reset.
//bit 1. pctl n_clk domain soft reset.
//bit 0. pctl p_clk domain soft reset.
#define  DDR0_APD_CTRL						0xc8836c08
//bit 15:8.   power down enter latency. when IP checked the dfi_lp_req && dfi_lp_ack,  give PCTL and pub additional latency let them settle down, then gating the clock.
//bit 7:0.  no active latency.  after c_active_in become to low, wait additional latency to check the pctl low power state.
