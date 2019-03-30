
/*
 * arch/arm/include/asm/arch-txl/eth_setup.h
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

#include <asm/arch/io.h>

/*
 *board configuration interface.
 * */
struct eth_clock_conf{
	int enable;
	int clock_50MHZ_phase;
	//add ... as you need.
};

struct eth_board_socket{
char *name ;
int (*eth_clock_configure)(struct eth_clock_conf);
int (*eth_pinmux_setup)(void);
int (*eth_hw_reset)(void);

};



/*
 *clock define part
 */

#define ETH_BASE                                (0xff3f0000)
#define ETH_PLL_CNTL                            CBUS_REG_ADDR(0x2050)
 /* Ethernet ctrl */
#define ETH_PLL_CNTL_DIVEN                      (1<<0)
#define ETH_PLL_CNTL_MACSPD                     (1<<1)
#define ETH_PLL_CNTL_DATEND                     (1<<2)
#define ETH_PLL_CNTL_DESEND                     (1<<3)


/*
	please refer following doc for detail
	@AppNote-M3-ClockTrees.docx

	select clk: -> CBUS_REG(0x1076)

	7-sys_pll_div2
	6-vid2_pll_clk
	5-vid_pll_clk
	4-aud_pll_clk
	3-ddr_pll_clk
	2-misc_pll_clk
	1-sys_pll_clk
	0-XTAL

	clk_freq:800MHz
	output_clk:50MHz
	aways,maybe changed for others?
*/

#define ETH_CLKSRC_XTAL             (0)
#define ETH_CLKSRC_SYS_PLL_CLK      (1)
#define ETH_CLKSRC_MISC_PLL_CLK     (2)
#define ETH_CLKSRC_DDR_PLL_CLK      (3)
#define ETH_CLKSRC_AUD_PLL_CLK      (
#define ETH_CLKSRC_VID_PLL_CLK      (5)
#define ETH_CLKSRC_VID2_PLL_CLK     (6)
#define ETH_CLKSRC_SYS_PLL_DIV2_CLK (7)
#define CLK_1M						(1000000)

typedef union eth_aml_reg0 {
    /** raw register data */
    unsigned int d32;
    /** register bits */
	struct {
        unsigned phy_intf_sel:3;
        unsigned rx_clk_rmii_invert:1;
        unsigned rgmii_tx_clk_src:1;
        unsigned rgmii_tx_clk_phase:2;
        unsigned rgmii_tx_clk_ratio:3;
        unsigned phy_ref_clk_enable:1;
        unsigned clk_rmii_i_invert:1;
        unsigned clk_en:1;
        unsigned adj_enable:1;
        unsigned adj_setup:1;
        unsigned adj_delay:5;
        unsigned adj_skew:5;
        unsigned cali_start:1;
        unsigned cali_rise:1;
        unsigned cali_sel:3;
        unsigned rgmii_rx_reuse:1;
        unsigned eth_urgent:1;
		} b;
} eth_aml_reg0_t;

#define ETH_VALIDE_CLKSRC(clk,out_clk) ((clk%out_clk)==0)

int  eth_clk_set(int selectclk,unsigned long clk_freq,unsigned long out_clk);

