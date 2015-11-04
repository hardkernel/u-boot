/*
 * drivers/display/lcd/lcd_tv/vbyone_drv.c
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

//set VX1_LOCKN && VX1_HTPDN
static void set_vbyone_pinmux(int status)
{
	if (status) {
		lcd_pinmux_clr_mask(7, ((1 << 1) | (1 << 2) | (1 << 9) | (1 << 10)));
		lcd_pinmux_set_mask(7, ((1 << 11) | (1 << 12)));
	} else {
		lcd_pinmux_clr_mask(7, ((1 << 11) | (1 << 12)));
	}
}

static void set_vbyone_tcon(void)
{
	vpp_set_matrix_ycbcr2rgb(2, 0);
	lcd_vcbus_write(L_RGB_BASE_ADDR, 0);
	lcd_vcbus_write(L_RGB_COEFF_ADDR, 0x400);

	lcd_vcbus_write(VPP_MISC, lcd_vcbus_read(VPP_MISC) & ~(VPP_OUT_SATURATE));
}

static void set_vbyone_phy(int status)
{
	if (status) {
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL1, 0x6e0ec918);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL2, 0x00000a7c);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL3, 0x00ff0800);
	} else {
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL1, 0x0);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL2, 0x0);
		lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL3, 0x0);
	}
}

#if 0
static void set_vbyone_ctlbits(int p3d_en, int p3d_lr, int mode)
{
	if (mode == 0) { /* insert at the first pixel */
		lcd_vcbus_setb(VBO_PXL_CTRL,
			(1 << p3d_en) | (p3d_lr & 0x1), 0, 4);
	} else {
		lcd_vcbus_setb(VBO_VBK_CTRL_0,
			(1 << p3d_en) | (p3d_lr & 0x1), 0, 2);
	}
}
#endif

static void set_vbyone_sync_pol(int hsync_pol, int vsync_pol)
{
	lcd_vcbus_setb(VBO_VIN_CTRL, hsync_pol, 4, 1);
	lcd_vcbus_setb(VBO_VIN_CTRL, vsync_pol, 5, 1);

	lcd_vcbus_setb(VBO_VIN_CTRL, hsync_pol, 6, 1);
	lcd_vcbus_setb(VBO_VIN_CTRL, vsync_pol, 7, 1);
}

static void set_vbyone_clk_util(struct lcd_config_s *pconf)
{
	unsigned int lcd_bits;
	unsigned int div_sel, phy_div;

	phy_div = pconf->lcd_control.vbyone_config->phy_div;

	lcd_bits = 10;
	switch (lcd_bits) {
	case 6:
		div_sel = 0;
		break;
	case 8:
		div_sel = 2;
		break;
	case 10:
		div_sel = 3;
		break;
	default:
		div_sel = 3;
		break;
	}
	/* set fifo_clk_sel */
	lcd_hiu_write(HHI_LVDS_TX_PHY_CNTL0, (div_sel << 6));
	/* set cntl_ser_en:  8-channel to 1 */
	lcd_hiu_setb(HHI_LVDS_TX_PHY_CNTL0, 0xfff, 16, 12);

	/* decoupling fifo enable, gated clock enable */
	lcd_hiu_write(HHI_LVDS_TX_PHY_CNTL1,
		(1 << 30) | ((phy_div - 1) << 25) | (1 << 24));
	/* decoupling fifo write enable after fifo enable */
	lcd_hiu_setb(HHI_LVDS_TX_PHY_CNTL1, 1, 31, 1);
}

static int set_vbyone_lanes(int lane_num, int byte_mode, int region_num,
		int hsize, int vsize)
{
	int sublane_num;
	int region_size[4];
	int tmp;

	switch (lane_num) {
	case 1:
	case 2:
	case 4:
	case 8:
		break;
	default:
		return -1;
	}
	switch (region_num) {
	case 1:
	case 2:
	case 4:
		break;
	default:
		return -1;
	}
	if (lane_num % region_num)
		return -1;
	switch (byte_mode) {
	case 3:
	case 4:
		break;
	default:
		return -1;
	}
	LCDPR("byte_mode=%d, lane_num=%d, region_num=%d\n",
		byte_mode, lane_num, region_num);

	sublane_num = lane_num / region_num; /* lane num in each region */
	lcd_vcbus_setb(VBO_LANES, (lane_num - 1), 0, 3);
	lcd_vcbus_setb(VBO_LANES, (region_num - 1), 4, 2);
	lcd_vcbus_setb(VBO_LANES, (sublane_num - 1), 8, 3);
	lcd_vcbus_setb(VBO_LANES, (byte_mode - 1), 11, 2);

	if (region_num > 1) {
		region_size[3] = (hsize / lane_num) * sublane_num;
		tmp = (hsize % lane_num);
		region_size[0] = region_size[3] + (((tmp / sublane_num) > 0) ?
			sublane_num : (tmp % sublane_num));
		region_size[1] = region_size[3] + (((tmp / sublane_num) > 1) ?
			sublane_num : (tmp % sublane_num));
		region_size[2] = region_size[3] + (((tmp / sublane_num) > 2) ?
			sublane_num : (tmp % sublane_num));
		lcd_vcbus_write(VBO_REGION_00, region_size[0]);
		lcd_vcbus_write(VBO_REGION_01, region_size[1]);
		lcd_vcbus_write(VBO_REGION_02, region_size[2]);
		lcd_vcbus_write(VBO_REGION_03, region_size[3]);
	}
	lcd_vcbus_write(VBO_ACT_VSIZE, vsize);
	/* different from FBC code!!! */
	/* lcd_vcbus_setb(VBO_CTRL_H,0x80,11,5); */
	/* different from simulation code!!! */
	lcd_vcbus_setb(VBO_CTRL_H, 0x0, 0, 4);
	lcd_vcbus_setb(VBO_CTRL_H, 0x1, 9, 1);
	/* lcd_vcbus_setb(VBO_CTRL_L,enable,0,1); */

	return 0;
}

static void set_vbyone_control(struct lcd_config_s *pconf)
{
	int hsize, vsize;
	int lane_count, byte_mode, region_num;
	//int color_fmt;
	int vin_color, vin_bpp;

	hsize = pconf->lcd_basic.h_active;
	vsize = pconf->lcd_basic.v_active;
	lane_count = pconf->lcd_control.vbyone_config->lane_count; /* 8 */
	region_num = pconf->lcd_control.vbyone_config->region_num; /* 2 */
	byte_mode = pconf->lcd_control.vbyone_config->byte_mode; /* 4 */
	//color_fmt = pconf->lcd_control.vbyone_config->color_fmt; /* 4 */

	set_vbyone_clk_util(pconf);
#if 0
	switch (color_fmt) {
	case 0://SDVT_VBYONE_18BPP_RGB
		vin_color = 4;
		vin_bpp   = 2;
		break;
	case 1://SDVT_VBYONE_18BPP_YCBCR444
		vin_color = 0;
		vin_bpp   = 2;
		break;
	case 2://SDVT_VBYONE_24BPP_RGB
		vin_color = 4;
		vin_bpp   = 1;
		break;
	case 3://SDVT_VBYONE_24BPP_YCBCR444
		vin_color = 0;
		vin_bpp   = 1;
		break;
	case 4://SDVT_VBYONE_30BPP_RGB
		vin_color = 4;
		vin_bpp   = 0;
		break;
	case 5://SDVT_VBYONE_30BPP_YCBCR444
		vin_color = 0;
		vin_bpp   = 0;
		break;
	default:
		LCDPR("error: vbyone COLOR_FORMAT unsupport\n");
		return;
	}
#else
	vin_color = 4; /* fixed RGB */
	vin_bpp   = 0; /* fixed 30bbp 4:4:4 */
#endif

	/* set Vbyone vin color format */
	lcd_vcbus_setb(VBO_VIN_CTRL, vin_color, 8, 3);
	lcd_vcbus_setb(VBO_VIN_CTRL, vin_bpp, 11, 2);

	set_vbyone_lanes(lane_count, byte_mode, region_num, hsize, vsize);
	/*set hsync/vsync polarity to let the polarity is low active
	inside the VbyOne */
	set_vbyone_sync_pol(0, 0);

	/* below line copy from simulation */
	/* gate the input when vsync asserted */
	lcd_vcbus_setb(VBO_VIN_CTRL, 1, 0, 2);
	/* lcd_vcbus_write(VBO_VBK_CTRL_0,0x13);
	//lcd_vcbus_write(VBO_VBK_CTRL_1,0x56);
	//lcd_vcbus_write(VBO_HBK_CTRL,0x3478);
	//lcd_vcbus_setb(VBO_PXL_CTRL,0x2,0,4);
	//lcd_vcbus_setb(VBO_PXL_CTRL,0x3,VBO_PXL_CTR1_BIT,VBO_PXL_CTR1_WID);
	//set_vbyone_ctlbits(1,0,0); */

	/* PAD select: */
	if ((lane_count == 1) || (lane_count == 2))
		lcd_vcbus_setb(LCD_PORT_SWAP, 1, 9, 2);
	else if (lane_count == 4)
		lcd_vcbus_setb(LCD_PORT_SWAP, 2, 9, 2);
	else
		lcd_vcbus_setb(LCD_PORT_SWAP, 0, 9, 2);
	/* lcd_vcbus_setb(LCD_PORT_SWAP, 1, 8, 1);//reverse lane output order */

	/* Mux pads in combo-phy: 0 for dsi; 1 for lvds or vbyone; 2 for edp */
	lcd_hiu_write(HHI_DSI_LVDS_EDP_CNTL0, 0x1);
	lcd_vcbus_setb(VBO_CTRL_L, 1, 0, 1);

	/*force vencl clk enable, otherwise, it might auto turn off by mipi DSI
	//lcd_vcbus_setb(VPU_MISC_CTRL, 1, 0, 1); */
}

static void vbyone_wait_stable(void)
{
	int i = 1000;

	while ((lcd_vcbus_read(VBO_STATUS_L) & 0x3f) != 0x20) {
		udelay(5);
		if (i-- == 0)
			break;
	}
	LCDPR("%s status: 0x%x\n", __func__, lcd_vcbus_read(VBO_STATUS_L));
}

static void set_vbyone_venc(struct lcd_config_s *pconf)
{
	lcd_vcbus_write(ENCL_VIDEO_EN, 0);

	lcd_vcbus_write(VPU_VIU_VENC_MUX_CTRL, (0<<0)|(3<<2)); // viu1 select encl  | viu2 select encl
	lcd_vcbus_write(ENCL_VIDEO_MODE,       40); //0); // Enable Hsync and equalization pulse switch in center; bit[14] cfg_de_v = 1
	lcd_vcbus_write(ENCL_VIDEO_MODE_ADV,   0x18); //0x0418); // Sampling rate: 1

	// bypass filter
	lcd_vcbus_write(ENCL_VIDEO_FILT_CTRL, 0x1000);
	lcd_vcbus_write(ENCL_VIDEO_MAX_PXCNT, pconf->lcd_basic.h_period - 1);
	lcd_vcbus_write(ENCL_VIDEO_MAX_LNCNT, pconf->lcd_basic.v_period - 1);

	lcd_vcbus_write(ENCL_VIDEO_HAVON_BEGIN, pconf->lcd_timing.video_on_pixel);
	lcd_vcbus_write(ENCL_VIDEO_HAVON_END,   pconf->lcd_basic.h_active - 1 + pconf->lcd_timing.video_on_pixel);
	lcd_vcbus_write(ENCL_VIDEO_VAVON_BLINE, pconf->lcd_timing.video_on_line);
	lcd_vcbus_write(ENCL_VIDEO_VAVON_ELINE, pconf->lcd_basic.v_active - 1  + pconf->lcd_timing.video_on_line);

	lcd_vcbus_write(ENCL_VIDEO_HSO_BEGIN,   pconf->lcd_timing.hs_hs_addr);
	lcd_vcbus_write(ENCL_VIDEO_HSO_END,     pconf->lcd_timing.hs_he_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_BEGIN,   pconf->lcd_timing.vs_hs_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_END,     pconf->lcd_timing.vs_he_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_BLINE,   pconf->lcd_timing.vs_vs_addr);
	lcd_vcbus_write(ENCL_VIDEO_VSO_ELINE,   pconf->lcd_timing.vs_ve_addr);

	lcd_vcbus_write(ENCL_VIDEO_RGBIN_CTRL, 3);

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

static void set_clk_pll(struct lcd_config_s *pconf)
{
	unsigned int pll_lock;
	int wait_loop = 100;

	lcd_hiu_write(HHI_HDMI_PLL_CNTL, 0x5800027b);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL2, 0x00404300);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x71486980);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00000e55);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL, 0x4800027b);
	do {
		mdelay(10);
		pll_lock = (lcd_hiu_read(HHI_HDMI_PLL_CNTL) >> 31) & 0x1;
		wait_loop--;
	} while ((pll_lock == 0) && (wait_loop > 0));
	if (wait_loop == 0)
		LCDPR("error: hpll lock failed\n");
}
#endif
static void set_vbyone_clk(struct lcd_config_s *pconf)
{
#if 1
	lcd_clk_set(pconf);
#else
	set_clk_pll(pconf);
	clocks_set_vid_clk_div(CLK_DIV_SEL_5);
	set_crt_video_enc(0, 0, 1);  //configure crt_video V1: inSel=vid_pll_clk(0),DivN=xd)
	enable_crt_video_encl(1, 0); //select and enable the output
#endif
}

static unsigned int vbyone_lane_num[] = {
	1,
	2,
	4,
	8,
	8,
};

#define VBYONE_BIT_RATE_MAX		2970 //MHz
#define VBYONE_BIT_RATE_MIN		600
void set_vbyone_config(struct lcd_config_s *pconf)
{
	unsigned int band_width, bit_rate, pclk, phy_div;
	unsigned int byte_mode, lane_count, minlane;
	unsigned int lcd_bits;
	unsigned int temp, i;

	//auto calculate bandwidth, clock
	lane_count = pconf->lcd_control.vbyone_config->lane_count;
	lcd_bits = 10;
	byte_mode = (lcd_bits == 10) ? 4 : 3;
	/* byte_mode * byte2bit * 8/10_encoding * pclk =
	   byte_mode * 8 * 10 / 8 * pclk */
	pclk = pconf->lcd_timing.lcd_clk / 1000; /* kHz */
	band_width = byte_mode * 10 * pclk;

	temp = VBYONE_BIT_RATE_MAX * 1000;
	temp = (band_width + temp - 1) / temp;
	for (i = 0; i < 4; i++) {
		if (temp <= vbyone_lane_num[i])
			break;
	}
	minlane = vbyone_lane_num[i];
	if (lane_count < minlane) {
		LCDPR("error: vbyone lane_num(%d) is less than min(%d)\n",
			lane_count, minlane);
		lane_count = minlane;
		pconf->lcd_control.vbyone_config->lane_count = lane_count;
		LCDPR("change to min lane_num %d\n", minlane);
	}

	bit_rate = band_width / minlane;
	phy_div = lane_count / minlane;
	if (phy_div == 8) {
		phy_div /= 2;
		bit_rate /= 2;
	}
	if (bit_rate > (VBYONE_BIT_RATE_MAX * 1000)) {
		LCDPR("error: vbyone bit rate(%dKHz) is out of max(%dKHz)\n",
			bit_rate, (VBYONE_BIT_RATE_MAX * 1000));
	}
	if (bit_rate < (VBYONE_BIT_RATE_MIN * 1000)) {
		LCDPR("error: vbyone bit rate(%dKHz) is out of min(%dKHz)\n",
			bit_rate, (VBYONE_BIT_RATE_MIN * 1000));
	}
	bit_rate = bit_rate * 1000; /* Hz */

	pconf->lcd_control.vbyone_config->phy_div = phy_div;
	pconf->lcd_control.vbyone_config->bit_rate = bit_rate;
	//LCDPR("lane_count=%u, bit_rate = %uMHz, pclk=%u.%03uMhz\n",
	//	lane_count, (bit_rate / 1000000), (pclk / 1000), (pclk % 1000));
}

int vbyone_init(struct lcd_config_s *pconf)
{
	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	set_vbyone_clk(pconf);
	set_vbyone_venc(pconf);
	set_vbyone_tcon();
	set_vbyone_control(pconf);
	set_vbyone_phy(1);
	set_vbyone_pinmux(1);
	vbyone_wait_stable();

	return 0;
}

int vbyone_disable(struct lcd_config_s *pconf)
{
	set_vbyone_pinmux(0);
	set_vbyone_phy(0);

	return 0;
}

