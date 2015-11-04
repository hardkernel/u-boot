/*
 * drivers/display/lcd/aml_lcd_common.c
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
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"

static char *lcd_type_table[] = {
	"ttl",
	"lvds",
	"vbyone",
	"mipi",
	"edp",
	"invalid",
};

int lcd_type_str_to_type(const char *str)
{
	int type;

	for (type = 0; type < ARRAY_SIZE(lcd_type_table); type++) {
		if (!strcmp(str, lcd_type_table[type]))
			break;
	}
	return type;
}

char *lcd_type_type_to_str(int type)
{
	return lcd_type_table[type];
}

static char *lcd_mode_table[] = {
	"tv",
	"tablet",
	"invalid",
};

int lcd_mode_str_to_mode(const char *str)
{
	int mode;

	for (mode = 0; mode < ARRAY_SIZE(lcd_mode_table); mode++) {
		if (!strcmp(str, lcd_mode_table[mode]))
			break;
	}
	return mode;
}

void vpp_set_matrix_ycbcr2rgb(int vd1_or_vd2_or_post, int mode)
{
	if (vd1_or_vd2_or_post == 0) { //vd1
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 5, 1);
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 8, 2);
	} else if (vd1_or_vd2_or_post == 1) { //vd2
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 4, 1);
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 2, 8, 2);
	} else {
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 0, 1);
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 0, 8, 2);
		if (mode == 0)
			lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 1, 2);
		else if (mode == 1)
			lcd_vcbus_setb(VPP_MATRIX_CTRL, 0, 1, 2);
	}

	if (mode == 0) { //ycbcr not full range, 601 conversion
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0064C8FF);
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET2, 0x006400C8);
		//1.164     0       1.596
		//1.164   -0.392    -0.813
		//1.164   2.017     0
		lcd_vcbus_write(VPP_MATRIX_COEF00_01, 0x04A80000);
		lcd_vcbus_write(VPP_MATRIX_COEF02_10, 0x066204A8);
		lcd_vcbus_write(VPP_MATRIX_COEF11_12, 0x1e701cbf);
		lcd_vcbus_write(VPP_MATRIX_COEF20_21, 0x04A80812);
		lcd_vcbus_write(VPP_MATRIX_COEF22, 0x00000000);
		lcd_vcbus_write(VPP_MATRIX_OFFSET0_1, 0x00000000);
		lcd_vcbus_write(VPP_MATRIX_OFFSET2, 0x00000000);
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0FC00E00);
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET2, 0x00000E00);
	} else if (mode == 1) {//ycbcr full range, 601 conversion
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0000E00);
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET2, 0x0E00);
		//	1	0			1.402
		//	1	-0.34414	-0.71414
		//	1	1.772		0
		lcd_vcbus_write(VPP_MATRIX_COEF00_01, (0x400 << 16) |0);
		lcd_vcbus_write(VPP_MATRIX_COEF02_10, (0x59c << 16) |0x400);
		lcd_vcbus_write(VPP_MATRIX_COEF11_12, (0x1ea0 << 16) |0x1d24);
		lcd_vcbus_write(VPP_MATRIX_COEF20_21, (0x400 << 16) |0x718);
		lcd_vcbus_write(VPP_MATRIX_COEF22, 0x0);
		lcd_vcbus_write(VPP_MATRIX_OFFSET0_1, 0x0);
		lcd_vcbus_write(VPP_MATRIX_OFFSET2, 0x0);
	}
}

#if 0
static unsigned od_table[4] = {1, 2, 4, 8};

#if 0
static void hpll_load_initial(void)
{
	//printf("lcd: %s\n", __func__);
	//hdmi load initial
	lcd_hiu_write(HHI_VID_CLK_CNTL2, 0x2c);
	lcd_hiu_write(HHI_VID_CLK_DIV, 0x100);
	lcd_hiu_write(HHI_VIID_CLK_CNTL, 0x0);
	lcd_hiu_write(HHI_VIID_CLK_DIV, 0x101);
	lcd_hiu_write(HHI_VID_LOCK_CLK_CNTL, 0x80);

	//    lcd_hiu_write(HHI_VPU_CLK_CNTL, 25);
	//    lcd_hiu_write(HHI_VPU_CLK_CNTL, 1, 8, 1);
	lcd_aobus_write(AO_RTI_GEN_PWR_SLEEP0, 0x0);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x100);

	lcd_vcbus_write(VPU_CLK_GATE, 0xffff);
	lcd_vcbus_write(ENCL_VIDEO_VSO_BLINE, 0x0);
	lcd_vcbus_write(ENCL_VIDEO_VSO_BEGIN, 0x0);
	lcd_vcbus_write(VPU_VLOCK_GCLK_EN, 0x7);
	lcd_vcbus_write(VPU_VLOCK_ADJ_EN_SYNC_CTRL, 0x108010ff);
	lcd_vcbus_write(VPU_VLOCK_CTRL, 0xe0f50f1b);
}

static void hpll_load_en(void)
{
	//printf("lcd: %s\n", __func__);
	//hdmi load gen
	lcd_hiu_setb(HHI_VID_CLK_CNTL, 1, 19, 1);
	lcd_hiu_setb(HHI_VID_CLK_CNTL, 7, 0 , 3);
	lcd_hiu_setb(HHI_VID_CLK_CNTL, 1, 16, 3);  // tmp use fclk_div4
	lcd_vcbus_write(ENCL_VIDEO_EN, 0x1);
	//    msleep(20);
	lcd_vcbus_write(ENCL_VIDEO_EN, 0x0);
	//    msleep(20);
	//    printk("read Addr: 0x%x[0x%x]  Data: 0x%x\n", P_HHI_HDMI_PLL_CNTL, (P_HHI_HDMI_PLL_CNTL & 0xffff) >> 2, aml_read_reg32(P_HHI_HDMI_PLL_CNTL));
	lcd_hiu_setb(HHI_VID_CLK_CNTL, 0, 16, 3);  // use vid_pll
}
#endif

static void lcd_set_pll(unsigned int pll_reg, unsigned int clk_reg)
{
	unsigned m, n, od1, od2, od3, frac;
	int wait_loop = 10;
	unsigned pll_lock = 0;
	unsigned pll_ctrl, pll_ctrl2;

	m = (pll_reg >> PLL_CTRL_M) & 0x1ff;
	n = (pll_reg >> PLL_CTRL_N) & 0x1f;
	od1 = (pll_reg >> PLL_CTRL_OD1) & 0x3;
	od2 = (pll_reg >> PLL_CTRL_OD2) & 0x3;
	od3 = (pll_reg >> PLL_CTRL_OD3) & 0x3;
	frac = (clk_reg >> CLK_CTRL_FRAC) & 0xfff;

	pll_ctrl = ((1 << 30) | (n << 9) | (m << 0));
	pll_ctrl2 = ((od1 << 16) | (od2 << 18) | (od3 << 22));
	if (frac > 0)
		pll_ctrl2 |= ((1 << 14) | (frac << 0));

	//hpll_load_initial();

	lcd_hiu_write(HHI_HDMI_PLL_CNTL, pll_ctrl | (1 << 28));
	lcd_hiu_write(HHI_HDMI_PLL_CNTL2, pll_ctrl2);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x714869c0);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00000a55);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL, pll_ctrl);
	do {
		//hpll_load_en();
		mdelay(10);
		pll_lock = (lcd_hiu_read(HHI_HDMI_PLL_CNTL) >> 31) & 0x1;
		wait_loop--;
	} while ((pll_lock == 0) && (wait_loop > 0));
	if (wait_loop == 0)
		LCDPR("error: hpll lock failed\n");
}

#if 0
static unsigned int lcd_clk_div_table[][3] = {
	/* divider,        shift_val,  shift_sel */
	{CLK_DIV_SEL_1,    0xffff,     0,},
	{CLK_DIV_SEL_2,    0x0aaa,     0,},
	{CLK_DIV_SEL_3,    0x0db6,     0,},
	{CLK_DIV_SEL_3p5,  0x36cc,     1,},
	{CLK_DIV_SEL_3p75, 0x6666,     2,},
	{CLK_DIV_SEL_4,    0x0ccc,     0,},
	{CLK_DIV_SEL_5,    0x739c,     2,},
	{CLK_DIV_SEL_6,    0x0e38,     0,},
	{CLK_DIV_SEL_6p25, 0x0000,     3,},
	{CLK_DIV_SEL_7,    0x3c78,     1,},
	{CLK_DIV_SEL_7p5,  0x78f0,     2,},
	{CLK_DIV_SEL_12,   0x0fc0,     0,},
	{CLK_DIV_SEL_14,   0x3f80,     1,},
	{CLK_DIV_SEL_15,   0x7f80,     2,},
	{CLK_DIV_SEL_2p5,  0x5294,     2,},
	{CLK_DIV_SEL_MAX,  0xffff,     0,},
};

void lcd_set_clk_div(unsigned long vid_div_reg)
{
	unsigned int  clk_div;
	unsigned int shift_val, shift_sel;
	int i;

	clk_div = (vid_div_reg >> DIV_CTRL_CLK_DIV) & 0xf;

	aml_set_reg32_bits(P_HHI_VIID_CLK_CNTL, 0, 19, 1);
	udelay(5);

	/* Disable the div output clock */
	aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 0, 19, 1);
	aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 0, 15, 1);

	i = 0;
	while (lcd_clk_div_table[i][0] != CLK_DIV_SEL_MAX) {
		if (clk_div == lcd_clk_div_table[i][0])
			break;
		i++;
	}
	if (lcd_clk_div_table[i][0] == CLK_DIV_SEL_MAX)
		printf("lcd error: invalid clk divider\n");
	shift_val = lcd_clk_div_table[i][1];
	shift_sel = lcd_clk_div_table[i][2];

	if (shift_val == 0xffff ) {      // if divide by 1
		aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 1, 18, 1);
	} else {
		aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 0, 16, 2);
		aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 0, 15, 1);
		aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 0, 0, 14);

		aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, shift_sel, 16, 2);
		aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 1, 15, 1);
		aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, shift_val, 0, 14);
		aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 0, 15, 1);
	}
	/* Enable the final output clock */
	aml_set_reg32_bits(P_HHI_VID_PLL_CLK_DIV, 1, 19, 1);
}

static void lcd_set_vclk_crt(unsigned int clk_ctrl_reg)
{
	unsigned int xd;
/*	printf("lcd: %s\n", __func__); */

	xd = (clk_ctrl_reg >> CLK_CTRL_XD) & 0xff;
	/* setup the XD divider value */
	aml_set_reg32_bits(P_HHI_VIID_CLK_DIV, (xd-1), 0, 8);
	udelay(5);
	/* Bit[18:16] - v2_cntl_clk_in_sel */
	aml_set_reg32_bits(P_HHI_VIID_CLK_CNTL, 0, 16, 3);
	aml_set_reg32_bits(P_HHI_VIID_CLK_CNTL, 1, 19, 1);
	udelay(2);

	/* [15:12] encl_clk_sel, select vclk2_div1 */
	aml_set_reg32_bits(P_HHI_VIID_CLK_DIV, 8, 12, 4);
	/* release vclk2_div_reset and enable vclk2_div */
	aml_set_reg32_bits(P_HHI_VIID_CLK_DIV, 1, 16, 2);
	udelay(5);

	aml_set_reg32_bits(P_HHI_VIID_CLK_CNTL, 1, 0, 1);
	aml_set_reg32_bits(P_HHI_VIID_CLK_CNTL, 1, 15, 1);
	udelay(10);
	aml_set_reg32_bits(P_HHI_VIID_CLK_CNTL, 0, 15, 1);
	udelay(5);

	aml_set_reg32_bits(P_HHI_VID_CLK_CNTL2, 1, 3, 1);
}
#endif

// --------------------------------------------------
//              clocks_set_vid_clk_div
// --------------------------------------------------
// wire            clk_final_en    = control[19];
// wire            clk_div1        = control[18];
// wire    [1:0]   clk_sel         = control[17:16];
// wire            set_preset      = control[15];
// wire    [14:0]  shift_preset    = control[14:0];
void clocks_set_vid_clk_div(int div_sel)
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

void set_crt_video_enc(int vIdx, int inSel, int DivN)
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

void enable_crt_video_encl(int enable, int inSel)
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

void set_vclk_lcd(struct lcd_config_s *pconf)
{
	unsigned int pll_reg, div_reg, clk_reg;
	unsigned int div, xd;

	pll_reg = pconf->lcd_timing.pll_ctrl;
	div_reg = pconf->lcd_timing.div_ctrl;
	clk_reg = pconf->lcd_timing.clk_ctrl;
	div = (div_reg >> DIV_CTRL_CLK_DIV) & 0xff;
	xd = (clk_reg >> CLK_CTRL_XD) & 0xff;

	lcd_set_pll(pll_reg, clk_reg);
	//lcd_set_clk_div(div_reg);
	//lcd_set_vclk_crt(clk_reg);
	clocks_set_vid_clk_div(div);
	set_crt_video_enc(0, 0, xd);  //configure crt_video V1: inSel=vid_pll_clk(0),DivN=xd)
	enable_crt_video_encl(1, 0); //select and enable the output
}

void _enable_vsync_interrupt(void)
{
	if (lcd_vcbus_read(ENCL_VIDEO_EN) & 1)
		lcd_vcbus_write(VENC_INTCTRL, 0x200);
	else
		lcd_vcbus_write(VENC_INTCTRL, 0x2);
}

void vpp_set_matrix_ycbcr2rgb(int vd1_or_vd2_or_post, int mode)
{
	if (vd1_or_vd2_or_post == 0) { //vd1
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 5, 1);
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 8, 2);
	} else if (vd1_or_vd2_or_post == 1) { //vd2
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 4, 1);
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 2, 8, 2);
	} else {
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 0, 1);
		lcd_vcbus_setb(VPP_MATRIX_CTRL, 0, 8, 2);
		if (mode == 0)
			lcd_vcbus_setb(VPP_MATRIX_CTRL, 1, 1, 2);
		else if (mode == 1)
			lcd_vcbus_setb(VPP_MATRIX_CTRL, 0, 1, 2);
	}

	if (mode == 0) { //ycbcr not full range, 601 conversion
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0064C8FF);
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET2, 0x006400C8);
		//1.164     0       1.596
		//1.164   -0.392    -0.813
		//1.164   2.017     0
		lcd_vcbus_write(VPP_MATRIX_COEF00_01, 0x04A80000);
		lcd_vcbus_write(VPP_MATRIX_COEF02_10, 0x066204A8);
		lcd_vcbus_write(VPP_MATRIX_COEF11_12, 0x1e701cbf);
		lcd_vcbus_write(VPP_MATRIX_COEF20_21, 0x04A80812);
		lcd_vcbus_write(VPP_MATRIX_COEF22, 0x00000000);
		lcd_vcbus_write(VPP_MATRIX_OFFSET0_1, 0x00000000);
		lcd_vcbus_write(VPP_MATRIX_OFFSET2, 0x00000000);
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0FC00E00);
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET2, 0x00000E00);
	} else if (mode == 1) {//ycbcr full range, 601 conversion
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0000E00);
		lcd_vcbus_write(VPP_MATRIX_PRE_OFFSET2, 0x0E00);
		//	1	0			1.402
		//	1	-0.34414	-0.71414
		//	1	1.772		0
		lcd_vcbus_write(VPP_MATRIX_COEF00_01, (0x400 << 16) |0);
		lcd_vcbus_write(VPP_MATRIX_COEF02_10, (0x59c << 16) |0x400);
		lcd_vcbus_write(VPP_MATRIX_COEF11_12, (0x1ea0 << 16) |0x1d24);
		lcd_vcbus_write(VPP_MATRIX_COEF20_21, (0x400 << 16) |0x718);
		lcd_vcbus_write(VPP_MATRIX_COEF22, 0x0);
		lcd_vcbus_write(VPP_MATRIX_OFFSET0_1, 0x0);
		lcd_vcbus_write(VPP_MATRIX_OFFSET2, 0x0);
	}
}

#if 0
#define TV_LCD_ENC_TST_NUM_MAX    8
static char *lcd_enc_tst_str[] = {
	"0-None",        /* 0 */
	"1-Color Bar",   /* 1 */
	"2-Thin Line",   /* 2 */
	"3-Dot Grid",    /* 3 */
	"4-Gray",        /* 4 */
	"5-Blue",         /* 5 */
	"6-Red",       /* 6 */
	"7-Green",        /* 7 */
};

static unsigned int lcd_enc_tst[][7] = {
/*tst_mode,    Y,       Cb,     Cr,     tst_en,  vfifo_en  rgbin*/
	{0,    0x200,   0x200,  0x200,   0,      1,        3},  /* 0 */
	{1,    0x200,   0x200,  0x200,   1,      0,        1},  /* 1 */
	{2,    0x200,   0x200,  0x200,   1,      0,        1},  /* 2 */
	{3,    0x200,   0x200,  0x200,   1,      0,        1},  /* 3 */
	{0,    0x200,   0x200,  0x200,   1,      0,        1},  /* 4 */
	{0,    0x130,   0x153,  0x3fd,   1,      0,        1},  /* 5 */
	{0,    0x256,   0x0ae,  0x055,   1,      0,        1},  /* 6 */
	{0,    0x074,   0x3fd,  0x1ad,   1,      0,        1},  /* 7 */
};

void lcd_test(unsigned int num, struct lcd_config_s *pconf)
{
	num = (num >= TV_LCD_ENC_TST_NUM_MAX) ? 0 : num;
	if (num >= 0) {
		lcd_vcbus_write(ENCL_VIDEO_RGBIN_CTRL, lcd_enc_tst[num][6]);
		lcd_vcbus_write(ENCL_TST_MDSEL, lcd_enc_tst[num][0]);
		lcd_vcbus_write(ENCL_TST_Y, lcd_enc_tst[num][1]);
		lcd_vcbus_write(ENCL_TST_CB, lcd_enc_tst[num][2]);
		lcd_vcbus_write(ENCL_TST_CR, lcd_enc_tst[num][3]);
		lcd_vcbus_write(ENCL_TST_CLRBAR_STRT, pconf->lcd_basic.video_on_pixel);
		lcd_vcbus_write(ENCL_TST_CLRBAR_WIDTH, (pconf->lcd_basic.h_active / 9));
		lcd_vcbus_write(ENCL_TST_EN, lcd_enc_tst[num][4]);
		lcd_vcbus_setb(ENCL_VIDEO_MODE_ADV, lcd_enc_tst[num][5], 3, 1);
		printf("lcd: show test pattern: %s\n", lcd_enc_tst_str[num]);
	} else {
		printf("lcd: disable test pattern\n");
	}
}
#endif
static int check_pll(struct pll_para_s *pll, unsigned int pll_fout)
{
	unsigned int fin, m, n;
	unsigned int od1_sel, od2_sel, od3_sel, od1, od2, od3;
	unsigned int pll_fod2_in, pll_fod3_in, pll_fvco;
	unsigned int od_fb = 0;
	unsigned int pll_frac = 0;
	int done;

	done = 0;
	fin = FIN_FREQ; /* kHz */
	/* od3 >= od2 */
	for (od3_sel = OD_SEL_MAX; od3_sel > 0; od3_sel--) {
		od3 = od_table[od3_sel - 1];
		pll_fod3_in = pll_fout * od3;
		for (od2_sel = od3_sel; od2_sel > 0; od2_sel--) {
			od2 = od_table[od2_sel - 1];
			pll_fod2_in = pll_fod3_in * od2;
			for (od1_sel = OD_SEL_MAX; od1_sel > 0; od1_sel--) {
				od1 = od_table[od1_sel - 1];
				pll_fvco = pll_fod2_in * od1;

				if ((pll_fvco < PLL_VCO_MIN) ||
					(pll_fvco > PLL_VCO_MAX)) {
					continue;
				}
				pll->od1_sel = od1_sel - 1;
				pll->od2_sel = od2_sel - 1;
				pll->od3_sel = od3_sel - 1;

				n = 1;
				od_fb = 0; /* pll default */
				pll_fvco = pll_fvco / ((od_fb + 1) * 2);

				m = pll_fvco / fin;
				pll_frac = (pll_fvco % fin) * 4096 / fin;

				pll->m = m;
				pll->n = n;
				pll->frac = pll_frac;
/*				printf("od1_sel=%d, od2_sel=%d, od3_sel=%d, pll_fvco=%d",
									(od1_sel - 1), (od2_sel - 1),
									(od3_sel - 1),	pll_fvco);
				printf(" pll_m=%d, pll_n=%d, pll_frac=%d\n",pll->m, pll->n, pll_frac);
*/				done = 1;
				return done;
			}
		}
	}

	return done;
}

static unsigned int clk_div_calc(unsigned int clk,unsigned int div_sel, int dir)
{
	unsigned int clk_ret;

	switch (div_sel) {
	case CLK_DIV_SEL_1:
		clk_ret = clk;
		break;
	case CLK_DIV_SEL_2:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 2;
		else
			clk_ret = clk * 2;
		break;
	case CLK_DIV_SEL_3:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 3;
		else
			clk_ret = clk * 3;
		break;
	case CLK_DIV_SEL_3p5:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk * 2 / 7;
		else
			clk_ret = clk * 7 / 2;
		break;
	case CLK_DIV_SEL_3p75:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk * 4 / 15;
		else
			clk_ret = clk * 15 / 4;
		break;
	case CLK_DIV_SEL_4:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 4;
		else
			clk_ret = clk * 4;
		break;
	case CLK_DIV_SEL_5:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 5;
		else
			clk_ret = clk * 5;
		break;
	case CLK_DIV_SEL_6:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 6;
		else
			clk_ret = clk * 6;
		break;
	case CLK_DIV_SEL_6p25:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk * 4 / 25;
		else
			clk_ret = clk * 25 / 4;
		break;
	case CLK_DIV_SEL_7:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 7;
		else
			clk_ret = clk * 7;
		break;
	case CLK_DIV_SEL_7p5:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk * 2 / 15;
		else
			clk_ret = clk * 15 / 2;
		break;
	case CLK_DIV_SEL_12:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 12;
		else
			clk_ret = clk * 12;
		break;
	case CLK_DIV_SEL_14:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 14;
		else
			clk_ret = clk * 14;
		break;
	case CLK_DIV_SEL_15:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk / 15;
		else
			clk_ret = clk * 15;
		break;
	case CLK_DIV_SEL_2p5:
		if (dir == CLK_DIV_I2O)
			clk_ret = clk * 2 / 5;
		else
			clk_ret = clk * 5 / 2;
		break;
	default:
		clk_ret = clk;
		printf("lcd error: clk_div_sel: Invalid parameter\n");
		break;
	}

	return clk_ret;
}

static unsigned int clk_div_get(unsigned int divN)
{ /* div * 100 */
	unsigned int div_sel;

	switch (divN) {
	case 375:
		div_sel = CLK_DIV_SEL_3p75;
		break;
	case 750:
		div_sel = CLK_DIV_SEL_7p5;
		break;
	case 1500:
		div_sel = CLK_DIV_SEL_15;
		break;
	case 500:
		div_sel = CLK_DIV_SEL_5;
		break;
	default:
		div_sel = CLK_DIV_SEL_MAX;
		break;
	}
	return div_sel;
}

void generate_clk_parameter(struct lcd_config_s *pconf)
{
	struct pll_para_s pll;
	int ret = 0;
	unsigned clk_div_sel, crt_xd;
	//unsigned crt_xd_max = CRT_VID_DIV_MAX;
	unsigned fout_pll, clk_div_out;
	unsigned tmp;
	unsigned fout;

	pll.frac = 0;
	pll.m = 0;
	pll.n = 0;
	pll.od1_sel = 0;
	pll.od2_sel = 0;
	pll.od3_sel = 0;

	//printf("lcd: lcd_clk = %dHz\n", pconf->lcd_timing.lcd_clk);
	fout = pconf->lcd_timing.lcd_clk / 1000; /* kHz */

	if (fout > ENCL_MAX_CLK_IN)
		goto generate_clk_done;

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_DIGITAL_LVDS:
		clk_div_sel = CLK_DIV_SEL_7; // CLK_DIV_SEL_1; 0
		//crt_xd_max = CRT_VID_DIV_MAX; //255
		crt_xd = 1;
		clk_div_out = fout * crt_xd;
		if (clk_div_out > CRT_VID_MAX_CLK_IN)
			goto generate_clk_done;

		fout_pll = clk_div_calc(clk_div_out,clk_div_sel, CLK_DIV_O2I);
		if (fout_pll > CLK_DIV_MAX_CLK_IN)
			goto generate_clk_done;

		ret = check_pll(&pll, fout_pll);
/* printf("fout_pll=%d , clk_div_sel=%d clk_div_out=%d\n", fout_pll,clk_div_sel,clk_div_out); */
/* printf("od1_sel=%x od2_sel=%x od3_sel=%x n=%x m=%x  \n",
		pll.od1_sel,pll.od2_sel,pll.od3_sel,pll.n,pll.m);
 */
		if (ret)
			goto generate_clk_done;
		break;
	case LCD_DIGITAL_VBYONE:
		fout_pll = pconf->lcd_control.vbyone_config->bit_rate / 1000;
		if (fout_pll > CLK_DIV_MAX_CLK_IN)
			goto generate_clk_done;

		tmp = fout_pll * 100 / fout;
		clk_div_sel = clk_div_get(tmp);
		//crt_xd_max = CRT_VID_DIV_MAX; //255
		crt_xd = 1;
		clk_div_out = fout * crt_xd;
		if (clk_div_out > CRT_VID_MAX_CLK_IN)
			goto generate_clk_done;

		ret = check_pll(&pll, fout_pll);
		if (ret)
			goto generate_clk_done;
		break;
	default:
		break;
	}

generate_clk_done:
	if (ret) {
		pconf->lcd_timing.pll_ctrl =
			(pll.od1_sel << PLL_CTRL_OD1) |
			(pll.od2_sel << PLL_CTRL_OD2) |
			(pll.od3_sel << PLL_CTRL_OD3) |
			(pll.n << PLL_CTRL_N) |
			(pll.m << PLL_CTRL_M);
		pconf->lcd_timing.div_ctrl = (clk_div_sel << DIV_CTRL_CLK_DIV);
		tmp = (pconf->lcd_timing.clk_ctrl &
			~((0xff << CLK_CTRL_XD) | (0xfff << CLK_CTRL_FRAC)));
		pconf->lcd_timing.clk_ctrl = (tmp |
			((crt_xd << CLK_CTRL_XD) |
			(pll.frac << CLK_CTRL_FRAC)));

		//printf("lcd: pll_ctrl=0x%x, div_ctrl=0x%x, clk_ctrl=0x%x\n",
		//	pconf->lcd_timing.pll_ctrl, pconf->lcd_timing.div_ctrl,pconf->lcd_timing.clk_ctrl);

	} else {
		pconf->lcd_timing.pll_ctrl = (0 << PLL_CTRL_OD1) |
			(1 << PLL_CTRL_OD2) | (1 << PLL_CTRL_OD3) |
			(1 << PLL_CTRL_N) | (65 << PLL_CTRL_M);
		pconf->lcd_timing.div_ctrl =
			(CLK_DIV_SEL_1 << DIV_CTRL_CLK_DIV);
		pconf->lcd_timing.clk_ctrl = (pconf->lcd_timing.clk_ctrl &
			~(0xff << CLK_CTRL_XD)) | (7 << CLK_CTRL_XD);
		printf("lcd error: Out of clock range, reset to default setting\n");
	}
}
#endif

