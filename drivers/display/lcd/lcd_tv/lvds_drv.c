/*
 * drivers/display/lcd/lcd_tv/lvds_drv.c
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
*/

#include <common.h>
#include <malloc.h>
#include <asm/arch/io.h>
#include <amlogic/aml_lcd.h>
#include "../aml_lcd_reg.h"
#include "../aml_lcd_common.h"
#include "lcd_tv.h"

static void set_lvds_tcon(void)
{
	vpp_set_matrix_ycbcr2rgb(2, 0);

	lcd_vcbus_write(L_RGB_BASE_ADDR, 0);
	lcd_vcbus_write(L_RGB_COEFF_ADDR, 0x400);

	lcd_vcbus_write(L_DITH_CNTL_ADDR,  0x400);

	lcd_vcbus_write(VPP_MISC, lcd_vcbus_read(VPP_MISC) & ~(VPP_OUT_SATURATE));
}

static void set_lvds_phy(int status)
{
	if (status) {
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL1, 0x6c6cca80);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL2, 0x0000006c);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL3, 0x0fff0800);
	} else {
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL1, 0x0);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL2, 0x0);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL3, 0x0);
	}
}

static void set_lvds_clk_util(struct lcd_config_s *pconf)
{
	unsigned int fifo_mode, phy_div, dual_port;

	dual_port = pconf->lcd_control.lvds_config->dual_port;
	if (dual_port) {
		fifo_mode = 0x3;
		phy_div = 2;
	} else {
		fifo_mode = 0x1;
		phy_div = 1;
	}

	lcd_vcbus_write(LVDS_GEN_CNTL, (lcd_vcbus_read(LVDS_GEN_CNTL)| (1 << 4) | (fifo_mode << 0)));
	lcd_vcbus_setb(LVDS_GEN_CNTL, 1, 3, 1);

	/* set fifo_clk_sel: div 7 */
	lcd_hiu_write(HHI_LVDS_TX_PHY_CNTL0, (1 << 6));
	/* set cntl_ser_en:  8-channel to 1 */
	lcd_hiu_setb(HHI_LVDS_TX_PHY_CNTL0, 0xfff, 16, 12);

	/* decoupling fifo enable, gated clock enable */
	lcd_hiu_write(HHI_LVDS_TX_PHY_CNTL1,
		(1 << 30) | ((phy_div - 1) << 25) | (1 << 24));
	/* decoupling fifo write enable after fifo enable */
	lcd_hiu_setb(HHI_LVDS_TX_PHY_CNTL1, 1, 31, 1);
}

static void set_lvds_control(struct lcd_config_s *pconf)
{
	unsigned int bit_num = 1;
	unsigned int pn_swap = 0;
	unsigned int dual_port = 1;
	unsigned int lvds_repack = 1;
	unsigned int port_swap = 0;

	set_lvds_clk_util(pconf);

	lvds_repack = (pconf->lcd_control.lvds_config->lvds_repack) & 0x1;
	pn_swap   = (pconf->lcd_control.lvds_config->pn_swap) & 0x1;
	dual_port = (pconf->lcd_control.lvds_config->dual_port) & 0x1;
	port_swap = (pconf->lcd_control.lvds_config->port_swap) & 0x1;

	switch (pconf->lcd_basic.lcd_bits) {
	case 10:
		bit_num=0;
		break;
	case 8:
		bit_num=1;
		break;
	case 6:
		bit_num=2;
		break;
	case 4:
		bit_num=3;
		break;
	default:
		bit_num=1;
		break;
	}

	lcd_vcbus_write(LVDS_PACK_CNTL_ADDR,
			( lvds_repack<<0 ) | // repack
			( port_swap<<2) | // odd_even
			( 0<<3 ) |		// reserve
			( 0<<4 ) |		// lsb first
			( pn_swap<<5 ) |	// pn swap
			( dual_port<<6 ) |	// dual port
			( 0<<7 ) |		// use tcon control
			( bit_num<<8 ) |	// 0:10bits, 1:8bits, 2:6bits, 3:4bits.
			( 0<<10 ) |		//r_select  //0:R, 1:G, 2:B, 3:0
			( 1<<12 ) |		//g_select  //0:R, 1:G, 2:B, 3:0
			( 2<<14 ));		//b_select  //0:R, 1:G, 2:B, 3:0;
}

static void set_lvds_venc(struct lcd_config_s *pconf)
{
//	lcd_vcbus_write(VPU_VIU_VENC_MUX_CTRL, (0<<0)|(0<<2));     // viu1 select encl  | viu2 select encl
	lcd_vcbus_write(ENCL_VIDEO_EN, 0);
	lcd_vcbus_write(VPU_VIU_VENC_MUX_CTRL, (0<<0)|(0<<2) );    // viu1 select encl | viu2 select encl
	lcd_vcbus_write(ENCL_VIDEO_MODE, 0); // Enable Hsync and equalization pulse switch in center; bit[14] cfg_de_v = 1
	lcd_vcbus_write(ENCL_VIDEO_MODE_ADV, 0x0418); // Sampling rate: 1

	// bypass filter
	lcd_vcbus_write(ENCL_VIDEO_FILT_CTRL, 	0x1000);
	lcd_vcbus_write(ENCL_VIDEO_MAX_PXCNT, 	pconf->lcd_basic.h_period - 1);
	lcd_vcbus_write(ENCL_VIDEO_MAX_LNCNT,	pconf->lcd_basic.v_period - 1);
	lcd_vcbus_write(ENCL_VIDEO_HAVON_BEGIN,	pconf->lcd_timing.video_on_pixel);
	lcd_vcbus_write(ENCL_VIDEO_HAVON_END,	pconf->lcd_basic.h_active - 1 + pconf->lcd_timing.video_on_pixel);
	lcd_vcbus_write(ENCL_VIDEO_VAVON_BLINE,	pconf->lcd_timing.video_on_line);
	lcd_vcbus_write(ENCL_VIDEO_VAVON_ELINE,	pconf->lcd_basic.v_active - 1  + pconf->lcd_timing.video_on_line);

	lcd_vcbus_write(ENCL_VIDEO_HSO_BEGIN,	pconf->lcd_timing.hs_he_addr);
	lcd_vcbus_write(ENCL_VIDEO_HSO_END,	pconf->lcd_timing.hs_hs_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_BEGIN,	pconf->lcd_timing.vs_hs_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_END,	pconf->lcd_timing.vs_he_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_BLINE,	pconf->lcd_timing.vs_vs_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_ELINE,	pconf->lcd_timing.vs_ve_addr);
	lcd_vcbus_write(ENCL_VIDEO_RGBIN_CTRL,  3);

	lcd_vcbus_write(ENCL_VIDEO_EN, 1);
}

#if 0
static void clocks_set_vid_clk_div(int div_sel)
{
	int shift_val = 0;
	int shift_sel = 0;

	//printf("lcd: %s[%d] div = %d\n", __func__, __LINE__, div_sel);
	// Disable the output clock
	lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 19, 1);
	lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 15, 1);

	switch (div_sel) {
	case CLK_DIV_SEL_1:      shift_val = 0xFFFF; shift_sel = 0; break;
	case CLK_DIV_SEL_2:      shift_val = 0x0aaa; shift_sel = 0; break;
	case CLK_DIV_SEL_3:      shift_val = 0x0db6; shift_sel = 0; break;
	case CLK_DIV_SEL_3p5:    shift_val = 0x36cc; shift_sel = 1; break;
	case CLK_DIV_SEL_3p75:   shift_val = 0x6666; shift_sel = 2; break;
	case CLK_DIV_SEL_4:      shift_val = 0x0ccc; shift_sel = 0; break;
	case CLK_DIV_SEL_5:      shift_val = 0x739c; shift_sel = 2; break;
	case CLK_DIV_SEL_6:      shift_val = 0x0e38; shift_sel = 0; break;
	case CLK_DIV_SEL_6p25:   shift_val = 0x0000; shift_sel = 3; break;
	case CLK_DIV_SEL_7:      shift_val = 0x3c78; shift_sel = 1; break;
	case CLK_DIV_SEL_7p5:    shift_val = 0x78f0; shift_sel = 2; break;
	case CLK_DIV_SEL_12:     shift_val = 0x0fc0; shift_sel = 0; break;
	case CLK_DIV_SEL_14:     shift_val = 0x3f80; shift_sel = 1; break;
	case CLK_DIV_SEL_15:     shift_val = 0x7f80; shift_sel = 2; break;
	case CLK_DIV_SEL_2p5:    shift_val = 0x5294; shift_sel = 2; break;
	default:
		printf("lcd error: clocks_set_vid_clk_div:  Invalid parameter\n");
	break;
	}

	if (shift_val == 0xffff ) {      // if divide by 1
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 1, 18, 1);
	} else {
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 16, 2);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 15, 1);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 0, 14);

		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, shift_sel, 16, 2);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 1, 15, 1);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, shift_val, 0, 14);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 15, 1);
	}
	// Enable the final output clock
	lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 1, 19, 1);
}

static void set_crt_video_enc(int vIdx, int inSel, int DivN)
{
	if (vIdx == 0) { //V1
		lcd_hiu_setb(HHI_VID_CLK_CNTL, 0, 19, 1); //[19] -disable clk_div0
		udelay(2);
		lcd_hiu_setb(HHI_VID_CLK_CNTL, inSel,   16, 3); // [18:16] - cntl_clk_in_sel
		lcd_hiu_setb(HHI_VID_CLK_DIV, (DivN-1), 0, 8); // [7:0]   - cntl_xd0
		udelay(5);
		lcd_hiu_setb(HHI_VID_CLK_CNTL, 1, 19, 1);//[19] -enable clk_div0
	} else { //V2
		lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, 19, 1); //[19] -disable clk_div0
		udelay(2);
		lcd_hiu_setb(HHI_VIID_CLK_CNTL, inSel,  16, 3); // [18:16] - cntl_clk_in_sel
		lcd_hiu_setb(HHI_VIID_CLK_DIV, (DivN-1),0, 8); // [7:0]   - cntl_xd0
		udelay(5);
		lcd_hiu_setb(HHI_VIID_CLK_CNTL, 1, 19, 1); //[19] -enable clk_div0
	}
	udelay(5);
}

static void enable_crt_video_encl(int enable, int inSel)
{
	lcd_hiu_setb(HHI_VIID_CLK_DIV,inSel,  12, 4); //encl_clk_sel:hi_viid_clk_div[15:12]

	if (inSel <= 4) //V1
		lcd_hiu_setb(HHI_VID_CLK_CNTL,1, inSel, 1);
	else
		lcd_hiu_setb(HHI_VIID_CLK_CNTL,1, (inSel-5),1);

	lcd_hiu_setb(HHI_VID_CLK_CNTL2,enable, 3, 1); //gclk_encl_clk:hi_vid_clk_cntl2[3]

#ifndef NO_EDP_DSI
	lcd_vcbus_setb(VPU_MISC_CTRL, 1, 0, 1);    // vencl_clk_en_force: vpu_misc_ctrl[0]
#endif
}

static void lcd_set_clk_pll(void)
{
	unsigned int pll_lock;
	int wait_loop = 100;

	lcd_hiu_write(HHI_HDMI_PLL_CNTL, 0x58000256);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL2, 0x00444280);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x71486980);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00000e55);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL, 0x48000256);
	do {
		mdelay(10);
		pll_lock = (lcd_hiu_read(HHI_HDMI_PLL_CNTL) >> 31) & 0x1;
		wait_loop--;
	} while ((pll_lock == 0) && (wait_loop > 0));
	if (wait_loop == 0)
		LCDPR("error: hpll lock failed\n");
}
#endif

static void set_lvds_clk(struct lcd_config_s *pconf)
{
#if 1
	lcd_clk_set(pconf);
#else
	lcd_set_clk_pll(pconf);
	clocks_set_vid_clk_div(CLK_DIV_SEL_7);
	set_crt_video_enc(0, 0, 1);  //configure crt_video V1: inSel=vid_pll_clk(0),DivN=xd)
	enable_crt_video_encl(1, 0); //select and enable the output
#endif
}

int lvds_init(struct lcd_config_s *pconf)
{
	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	set_lvds_clk(pconf);
	set_lvds_venc(pconf);
	set_lvds_control(pconf);
	set_lvds_tcon();
	set_lvds_phy(1);

	return 0;
}

int lvds_disable(struct lcd_config_s *pconf)
{
	set_lvds_phy(0);

	return 0;
}

