/*
 * drivers/display/lcd/lcd_tablet/lcd_drv.c
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
#include "lcd_tablet.h"

static int lcd_type_supported(struct lcd_config_s *pconf)
{
	int lcd_type = pconf->lcd_basic.lcd_type;
	int ret = -1;

	switch (lcd_type) {
	case LCD_TTL:
	case LCD_LVDS:
		ret = 0;
		break;
	default:
		LCDPR("invalid lcd type: %s(%d)\n",
			lcd_type_type_to_str(lcd_type), lcd_type);
		break;
	}
	return ret;
}

static unsigned int ttl_pinmux_set_rgb_8bit[][2] = {
	{1, 0x0000003f}, /* 8bit */
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_set_rgb_6bit[][2] = {
	{1, 0x0000002a}, /* 6bit */
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_clr_rgb_8bit[][2] = {
	{0, 0xf0bfffff},
	{1, 0x00fc1c00},
	{2, 0x1fbfffff},
	{3, 0x2016ffff},
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_clr_rgb_6bit[][2] = {
	{0, 0xf0b3f0fc},
	{1, 0x003c0000},
	{2, 0x1fb8fcfc},
	{3, 0x2016ffcf},
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_set_de[][2] = {
	{1, 0x00018000}, /* DE */
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_set_hvsync[][2] = {
	{1, 0x0000e000}, /* hvsync */
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_set_de_hvsync[][2] = {
	{1, 0x0001e000}, /* DE + hvsync */
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_clr_de[][2] = {
	{0, 0x0c000000},
	{1, 0x00020000},
	{3, 0xdf000000},
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_clr_hvsync[][2] = {
	{0, 0x07000000},
	{1, 0x000000c0},
	{3, 0x6fc90000},
	{LCD_PINMUX_END, 0x0},
};

static unsigned int ttl_pinmux_clr_de_hvsync[][2] = {
	{0, 0x0f000000},
	{1, 0x000200c0},
	{3, 0xffc90000},
	{LCD_PINMUX_END, 0x0},
};

static void lcd_pinmux_set(unsigned int (*lcd_pinmux)[2], int status)
{
	int i = 0;

	if (status) {
		while (i < LCD_PINMUX_NUM) {
			if (lcd_pinmux[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_set_mask(lcd_pinmux[i][0], lcd_pinmux[i][1]);
			i++;
		}
	} else {
		while (i < LCD_PINMUX_NUM) {
			if (lcd_pinmux[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_clr_mask(lcd_pinmux[i][0], lcd_pinmux[i][1]);
			i++;
		}
	}
}

static void lcd_ttl_pinmux_set(int status)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_config_s *pconf;

	if (lcd_debug_print_flag)
		LCDPR("%s: %d\n", __func__, status);

	pconf = lcd_drv->lcd_config;
	if (status) {
		if (pconf->lcd_basic.lcd_bits == 6) {
			lcd_pinmux_set(ttl_pinmux_clr_rgb_6bit, 0);
			lcd_pinmux_set(ttl_pinmux_set_rgb_6bit, 1);
		} else {
			lcd_pinmux_set(ttl_pinmux_clr_rgb_8bit, 0);
			lcd_pinmux_set(ttl_pinmux_set_rgb_8bit, 1);
		}
		switch (pconf->lcd_control.ttl_config->sync_valid) {
		case 0x1: /* hvsync */
			lcd_pinmux_set(ttl_pinmux_clr_hvsync, 0);
			lcd_pinmux_set(ttl_pinmux_set_hvsync, 1);
			break;
		case 0x2: /* de */
			lcd_pinmux_set(ttl_pinmux_clr_de, 0);
			lcd_pinmux_set(ttl_pinmux_set_de, 1);
			break;
		case 0x3: /* de + hvsync */
		default:
			lcd_pinmux_set(ttl_pinmux_clr_de_hvsync, 0);
			lcd_pinmux_set(ttl_pinmux_set_de_hvsync, 1);
			break;
		}
	} else {
		if (pconf->lcd_basic.lcd_bits == 6)
			lcd_pinmux_set(ttl_pinmux_set_rgb_6bit, 0);
		else
			lcd_pinmux_set(ttl_pinmux_set_rgb_8bit, 0);
		switch (pconf->lcd_control.ttl_config->sync_valid) {
		case 0x1: /* hvsync */
			lcd_pinmux_set(ttl_pinmux_set_hvsync, 0);
			break;
		case 0x2: /* de */
			lcd_pinmux_set(ttl_pinmux_set_de, 0);
			break;
		case 0x3: /* de + hvsync */
		default:
			lcd_pinmux_set(ttl_pinmux_set_de_hvsync, 0);
			break;
		}
	}
}

static void lcd_lvds_phy_set(struct lcd_config_s *pconf, int status)
{
	unsigned int vswing, preem;
	unsigned int data32;

	if (lcd_debug_print_flag)
		LCDPR("%s: %d\n", __func__, status);

	if (status) {
		vswing = pconf->lcd_control.lvds_config->phy_vswing;
		preem = pconf->lcd_control.lvds_config->phy_preem;
		if (vswing > 7) {
			LCDERR("%s: wrong vswing_level=%d, use default\n",
				__func__, vswing);
			vswing = LVDS_PHY_VSWING_DFT;
		}
		if (preem > 7) {
			LCDERR("%s: wrong preemphasis_level=%d, use default\n",
				__func__, preem);
			preem = LVDS_PHY_PREEM_DFT;
		}
		data32 = 0x606cca80 | (vswing << 26) | (preem << 0);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL1, data32);
		/*lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL1, 0x6c6cca80);*/
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL2, 0x0000006c);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL3, 0x0fff0800);
	} else {
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL1, 0x0);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL2, 0x0);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL3, 0x0);
	}
}

#define STV2_SEL         5
#define STV1_SEL         4
static void lcd_tcon_set(struct lcd_config_s *pconf)
{
	struct lcd_timing_s *tcon_adr = &pconf->lcd_timing;

	lcd_vcbus_write(L_RGB_BASE_ADDR, 0);
	lcd_vcbus_write(L_RGB_COEFF_ADDR, 0x400);

	if (pconf->lcd_basic.lcd_bits == 6)
		lcd_vcbus_write(L_DITH_CNTL_ADDR,  0x600);
	else if (pconf->lcd_basic.lcd_bits == 8)
		lcd_vcbus_write(L_DITH_CNTL_ADDR,  0x400);

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_LVDS:
		lcd_vcbus_setb(L_POL_CNTL_ADDR, 1, 0, 1);
		if (pconf->lcd_timing.vsync_pol)
			lcd_vcbus_setb(L_POL_CNTL_ADDR, 1, 1, 1);
		break;
	default:
		break;
	}

	/* DE signal for TTL m8,m8m2 */
	lcd_vcbus_write(L_OEH_HS_ADDR, tcon_adr->de_hs_addr);
	lcd_vcbus_write(L_OEH_HE_ADDR, tcon_adr->de_he_addr);
	lcd_vcbus_write(L_OEH_VS_ADDR, tcon_adr->de_vs_addr);
	lcd_vcbus_write(L_OEH_VE_ADDR, tcon_adr->de_ve_addr);
	/* DE signal for TTL m8b */
	lcd_vcbus_write(L_OEV1_HS_ADDR,  tcon_adr->de_hs_addr);
	lcd_vcbus_write(L_OEV1_HE_ADDR,  tcon_adr->de_he_addr);
	lcd_vcbus_write(L_OEV1_VS_ADDR,  tcon_adr->de_vs_addr);
	lcd_vcbus_write(L_OEV1_VE_ADDR,  tcon_adr->de_ve_addr);

	/* Hsync signal for TTL m8,m8m2 */
	if (tcon_adr->hsync_pol == 0) {
		lcd_vcbus_write(L_STH1_HS_ADDR, tcon_adr->hs_he_addr);
		lcd_vcbus_write(L_STH1_HE_ADDR, tcon_adr->hs_hs_addr);
	} else {
		lcd_vcbus_write(L_STH1_HS_ADDR, tcon_adr->hs_hs_addr);
		lcd_vcbus_write(L_STH1_HE_ADDR, tcon_adr->hs_he_addr);
	}
	lcd_vcbus_write(L_STH1_VS_ADDR, tcon_adr->hs_vs_addr);
	lcd_vcbus_write(L_STH1_VE_ADDR, tcon_adr->hs_ve_addr);

	/* Vsync signal for TTL m8,m8m2 */
	lcd_vcbus_write(L_STV1_HS_ADDR, tcon_adr->vs_hs_addr);
	lcd_vcbus_write(L_STV1_HE_ADDR, tcon_adr->vs_he_addr);
	if (tcon_adr->vsync_pol == 0) {
		lcd_vcbus_write(L_STV1_VS_ADDR, tcon_adr->vs_ve_addr);
		lcd_vcbus_write(L_STV1_VE_ADDR, tcon_adr->vs_vs_addr);
	} else {
		lcd_vcbus_write(L_STV1_VS_ADDR, tcon_adr->vs_vs_addr);
		lcd_vcbus_write(L_STV1_VE_ADDR, tcon_adr->vs_ve_addr);
	}

	/* DE signal */
	lcd_vcbus_write(L_DE_HS_ADDR,    tcon_adr->de_hs_addr);
	lcd_vcbus_write(L_DE_HE_ADDR,    tcon_adr->de_he_addr);
	lcd_vcbus_write(L_DE_VS_ADDR,    tcon_adr->de_vs_addr);
	lcd_vcbus_write(L_DE_VE_ADDR,    tcon_adr->de_ve_addr);

	/* Hsync signal */
	lcd_vcbus_write(L_HSYNC_HS_ADDR,  tcon_adr->hs_hs_addr);
	lcd_vcbus_write(L_HSYNC_HE_ADDR,  tcon_adr->hs_he_addr);
	lcd_vcbus_write(L_HSYNC_VS_ADDR,  tcon_adr->hs_vs_addr);
	lcd_vcbus_write(L_HSYNC_VE_ADDR,  tcon_adr->hs_ve_addr);

	/* Vsync signal */
	lcd_vcbus_write(L_VSYNC_HS_ADDR,  tcon_adr->vs_hs_addr);
	lcd_vcbus_write(L_VSYNC_HE_ADDR,  tcon_adr->vs_he_addr);
	lcd_vcbus_write(L_VSYNC_VS_ADDR,  tcon_adr->vs_vs_addr);
	lcd_vcbus_write(L_VSYNC_VE_ADDR,  tcon_adr->vs_ve_addr);

	lcd_vcbus_write(L_INV_CNT_ADDR, 0);
	lcd_vcbus_write(L_TCON_MISC_SEL_ADDR, ((1 << STV1_SEL) | (1 << STV2_SEL)));

	lcd_vcbus_write(VPP_MISC, lcd_vcbus_read(VPP_MISC) & ~(VPP_OUT_SATURATE));
}

static void lcd_ttl_control_set(struct lcd_config_s *pconf)
{
	unsigned int clk_pol, rb_swap, bit_swap;

	clk_pol = pconf->lcd_control.ttl_config->clk_pol;
	rb_swap = (pconf->lcd_control.ttl_config->swap_ctrl >> 1) & 1;
	bit_swap = (pconf->lcd_control.ttl_config->swap_ctrl >> 0) & 1;

	lcd_vcbus_setb(L_POL_CNTL_ADDR, clk_pol, 6, 1);
	lcd_vcbus_setb(L_DUAL_PORT_CNTL_ADDR, rb_swap, 1, 1);
	lcd_vcbus_setb(L_DUAL_PORT_CNTL_ADDR, bit_swap, 0, 1);
}

static void lcd_lvds_clk_util_set(struct lcd_config_s *pconf)
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

	lcd_vcbus_write(LVDS_GEN_CNTL, (lcd_vcbus_read(LVDS_GEN_CNTL) | (1 << 4) | (fifo_mode << 0)));
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

static void lcd_lvds_control_set(struct lcd_config_s *pconf)
{
	unsigned int bit_num = 1;
	unsigned int pn_swap = 0;
	unsigned int dual_port = 1;
	unsigned int lvds_repack = 1;
	unsigned int port_swap = 0;

	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	lcd_lvds_clk_util_set(pconf);

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
			(lvds_repack << 0) | // repack
			(port_swap << 2) | // odd_even
			(0 << 3) |		// reserve
			(0 << 4) |		// lsb first
			(pn_swap << 5) |	// pn swap
			(dual_port << 6) |	// dual port
			(0 << 7) |		// use tcon control
			(bit_num << 8) |	// 0:10bits, 1:8bits, 2:6bits, 3:4bits.
			(0 << 10) |		//r_select  //0:R, 1:G, 2:B, 3:0
			(1 << 12) |		//g_select  //0:R, 1:G, 2:B, 3:0
			(2 << 14));		//b_select  //0:R, 1:G, 2:B, 3:0;
}

static void lcd_venc_set(struct lcd_config_s *pconf)
{
	unsigned int h_active, v_active;
	unsigned int video_on_pixel, video_on_line;

	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	h_active = pconf->lcd_basic.h_active;
	v_active = pconf->lcd_basic.v_active;
	video_on_pixel = pconf->lcd_timing.video_on_pixel;
	video_on_line = pconf->lcd_timing.video_on_line;

	lcd_vcbus_write(ENCL_VIDEO_EN, 0);

	lcd_vcbus_write(VPU_VIU_VENC_MUX_CTRL, (0 << 0) | (0 << 2));    // viu1 select encl | viu2 select encl
	lcd_vcbus_write(ENCL_VIDEO_MODE, 0); // Enable Hsync and equalization pulse switch in center; bit[14] cfg_de_v = 1
	lcd_vcbus_write(ENCL_VIDEO_MODE_ADV, 0x0418); // Sampling rate: 1

	// bypass filter
	lcd_vcbus_write(ENCL_VIDEO_FILT_CTRL, 0x1000);
	lcd_vcbus_write(ENCL_VIDEO_MAX_PXCNT, pconf->lcd_basic.h_period - 1);
	lcd_vcbus_write(ENCL_VIDEO_MAX_LNCNT, pconf->lcd_basic.v_period - 1);
	lcd_vcbus_write(ENCL_VIDEO_HAVON_BEGIN, video_on_pixel);
	lcd_vcbus_write(ENCL_VIDEO_HAVON_END,   h_active - 1 + video_on_pixel);
	lcd_vcbus_write(ENCL_VIDEO_VAVON_BLINE, video_on_line);
	lcd_vcbus_write(ENCL_VIDEO_VAVON_ELINE, v_active - 1  + video_on_line);

	lcd_vcbus_write(ENCL_VIDEO_HSO_BEGIN, pconf->lcd_timing.hs_hs_addr);
	lcd_vcbus_write(ENCL_VIDEO_HSO_END,   pconf->lcd_timing.hs_he_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_BEGIN, pconf->lcd_timing.vs_hs_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_END,   pconf->lcd_timing.vs_he_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_BLINE, pconf->lcd_timing.vs_vs_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_ELINE, pconf->lcd_timing.vs_ve_addr);
	lcd_vcbus_write(ENCL_VIDEO_RGBIN_CTRL, 3);

	lcd_vcbus_write(ENCL_VIDEO_EN, 1);
}

int lcd_tablet_driver_init(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_config_s *pconf;
	int ret;

	LCDPR("tablet driver init\n");
	pconf = lcd_drv->lcd_config;
	ret = lcd_type_supported(pconf);
	if (ret)
		return -1;

	/* init driver */
	lcd_clk_set(pconf);
	lcd_venc_set(pconf);
	lcd_tcon_set(pconf);
	switch (pconf->lcd_basic.lcd_type) {
	case LCD_TTL:
		lcd_ttl_control_set(pconf);
		lcd_ttl_pinmux_set(1);
		break;
	case LCD_LVDS:
		lcd_lvds_control_set(pconf);
		lcd_lvds_phy_set(pconf, 1);
		break;
	default:
		break;
	}
	if (pconf->lcd_timing.ss_level > 0)
		lcd_set_spread_spectrum();

	lcd_vcbus_write(VENC_INTCTRL, 0x200);

	if (lcd_debug_print_flag)
		LCDPR("%s finished\n", __func__);
	return 0;
}

void lcd_tablet_driver_disable(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_config_s *pconf;
	int ret;

	LCDPR("disable driver\n");
	pconf = lcd_drv->lcd_config;
	ret = lcd_type_supported(pconf);
	if (ret)
		return;

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_TTL:
		lcd_ttl_pinmux_set(0);
		break;
	case LCD_LVDS:
		lcd_lvds_phy_set(pconf, 0);
		lcd_vcbus_setb(LVDS_GEN_CNTL, 0, 3, 1); /* disable lvds fifo */
		break;
	default:
		break;
	}

	lcd_vcbus_write(ENCL_VIDEO_EN, 0);

	lcd_clk_disable();

	if (lcd_debug_print_flag)
		LCDPR("%s finished\n", __func__);
}

