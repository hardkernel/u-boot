
/*
 * arch/arm/include/asm/arch-gxb/clock.h
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

#ifndef __ARCH_ARM_MESON_CLOCK_H_U_BOOT_
#define __ARCH_ARM_MESON_CLOCK_H_U_BOOT_

/* below clk is M8, it is placed here for compiling pass */
#define CTS_PWM_A_CLK                  (45)
#define CTS_PWM_B_CLK                  (44)
#define CTS_PWM_C_CLK                  (43)
#define CTS_PWM_D_CLK                  (42)
#define CTS_ETH_RX_TX                  (41)
#define CTS_PCM_MCLK                   (40)
#define CTS_PCM_SCLK                   (39)
#define CTS_VDIN_MEAS_CLK              (38)
#define CTS_VDAC_CLK1                  (37)
#define CTS_HDMI_TX_PIXEL_CLK          (36)
#define CTS_MALI_CLK                   (35)
#define CTS_SDHC_CLK1                  (34)
#define CTS_SDHC_CLK0                  (33)
#define CTS_AUDAC_CLKPI                (32)
#define CTS_A9_CLK                     (31)
#define CTS_DDR_CLK                    (30)
#define CTS_VDAC_CLK0                  (29)
#define CTS_SAR_ADC_CLK                (28)
#define CTS_ENCI_CLK                   (27)
#define SC_CLK_INT                     (26)
#define USB_CLK_12MHZ                  (25)
#define LVDS_FIFO_CLK                  (24)
#define HDMI_CH3_TMDSCLK               (23)
#define MOD_ETH_CLK50_I                (22)
#define MOD_AUDIN_AMCLK_I              (21)
#define CTS_BTCLK27                    (20)
#define CTS_HDMI_SYS_CLK               (19)
#define CTS_LED_PLL_CLK                (18)
#define CTS_VGHL_PLL_CLK               (17)
#define CTS_FEC_CLK_2                  (16)
#define CTS_FEC_CLK_1                  (15)
#define CTS_FEC_CLK_0                  (14)
#define CTS_AMCLK                      (13)
#define VID2_PLL_CLK                   (12)
#define CTS_ETH_RMII                   (11)
#define CTS_ENCT_CLK                   (10)
#define CTS_ENCL_CLK                   (9)
#define CTS_ENCP_CLK                   (8)
#define CLK81                          (7)
#define VID_PLL_CLK                    (6)
#define AUD_PLL_CLK                    (5)
#define MISC_PLL_CLK                   (4)
#define DDR_PLL_CLK                    (3)
#define SYS_PLL_CLK                    (2)
#define AM_RING_OSC_CLK_OUT1           (1)
#define AM_RING_OSC_CLK_OUT0           (0)

int clk_get_rate(unsigned clksrc);
unsigned long clk_util_clk_msr( unsigned long   clk_mux );
__u32 get_cpu_clk(void);
__u32 get_clk_ddr(void);
__u32 get_clk81(void);
__u32 get_misc_pll_clk(void);


#endif /* __ARCH_ARM_MESON_CLOCK_H_U_BOOT_ */

