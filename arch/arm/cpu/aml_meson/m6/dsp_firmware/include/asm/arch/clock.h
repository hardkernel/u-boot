/*

 *  arch/arm/mach-meson/include/mach/clock.h

 *

 *  Copyright (C) 2010 AMLOGIC, INC.

 *

 * This program is free software; you can redistribute it and/or modify

 * it under the terms of the GNU General Public License as published by

 * the Free Software Foundation; either version 2 of the License, or

 * (at your option) any later version.

 *

 * This program is distributed in the hope that it will be useful,

 * but WITHOUT ANY WARRANTY; without even the implied warranty of

 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

 * GNU General Public License for more details.

 *

 * You should have received a copy of the GNU General Public License

 * along with this program; if not, write to the Free Software

 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 */



#ifndef __ARCH_ARM_MESON_CLOCK_H_U_BOOT_

#define __ARCH_ARM_MESON_CLOCK_H_U_BOOT_

#include "reg_addr.h"

// -----------------------------------------

// clk_util_clk_msr

// -----------------------------------------

// from periphs_top

//

// .clk0           ( am_ring_osc_clk_out[0]    ),       // ring oscilator

#define CLK_OUT_AM_RING_OSC_CLK				0

// .clk1           ( am_ring_osc_clk_out[1]    ),       // ring oscilator

// .clk2           ( ext_clk_to_msr_i          ),       // external audio I2S AMLCLK

// .clk3           ( cts_a9_clk                ),       // A9 clock

#define CLK_A9								3

// .clk4           ( cts_a9_periph_clk         ),

// .clk5           ( cts_a9_axi_clk            ),

// .clk6           ( cts_a9_at_clk             ),

// .clk7           ( cts_a9_apb_clk            ),

// .clk8           ( cts_arc625_clk            ),       //  ARC625 clock

// .clk9           ( sys_pll_div3              ),

#define CLK_SYS_PLL_DIV3						9

// .clk10          ( ddr_pll_clk               ),       // DDR clock

#define CLK_DDR_PLL_CLK							10

// .clk11          ( other_pll_clk             ),       // Other PL output clock

#define CLK_OTHER_PLL_CLK						11

// .clk12          ( aud_pll_clk               ),       // Audio PLL output clock

// .clk13          ( demod_pll_clk240          ),       // DEMOD PLL output clock

// .clk14          ( demod_pll_adc_clk         ),       // DEMOD PLL output clock

// .clk15          ( demod_pll_wifi_adc_clk    ),       // DEMOD PLL output clock

// .clk16          ( demod_pll_adc_clk_57      ),       // DEMOD PLL output clock

// .clk17          ( demod_pll_clk400          ),       // DEMOD PLL output clock

// .clk18          ( demod_pll_wifi_dac_clk    ),       // DEMOD PLL output clock

// .clk19          ( vid_pll_clk               ),       // Video Clock

// .clk20          ( vid_pll_ref_clk           ),

// .clk21          ( HDMI_CH0_TMDSCLK          ),       // HDMI clock



#define CLK_CLK81                               32

/**

    <0 error

    >0 return clk in COUNTER per CONFIG_SYS_HZ counter

*/

int clk_get_rate(unsigned clksrc);







#endif

