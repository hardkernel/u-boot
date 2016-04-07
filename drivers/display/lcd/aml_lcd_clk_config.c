/*
 * drivers/display/lcd/lcd_clk_config.c
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
#include <asm/arch/gpio.h>
#include <amlogic/aml_lcd.h>
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"

static const unsigned int od_table[4] = {
	1, 2, 4, 8
};
static const unsigned int div_pre_table[6] = {
	1, 2, 3, 4, 5, 6
};
static const unsigned int edp_div0_table[15] = {
	1, 2, 3, 4, 5, 7, 8, 9, 11, 13, 17, 19, 23, 29, 31
};
static const unsigned int edp_div1_table[8] = {
	1, 2, 4, 5, 6, 7, 9, 13
};

static char *lcd_clk_div_sel_table[] = {
	"1",
	"2",
	"3",
	"3.5",
	"3.75",
	"4",
	"5",
	"6",
	"6.25",
	"7",
	"7.5",
	"12",
	"14",
	"15",
	"2.5",
	"invalid",
};

static char *lcd_pll_ss_table_m8[] = {
	"0, disable",
	"1, +/-0.25%",
	"2, +/-0.5%",
	"3, +/-0.75%",
	"4, +/-1.0%",
};

static char *lcd_pll_ss_table_m8b[] = {
	"0, disable",
	"1, +/-0.25%",
	"2, +/-0.5%",
	"3, +/-0.75%",
	"4, +/-1.0%",
};

static char *lcd_pll_ss_table_g9tv[] = {
	"0, disable",
	"1, +/-0.2%",
	"2, +/-0.35%",
	"3, +/-0.85%",
	"4, +/-1.5%",
};

static char *lcd_pll_ss_table_g9bb[] = {
	"0, disable",
	"1, +/-0.25%",
	"2, +/-0.5%",
};

static char *lcd_pll_ss_table_gxtvbb[] = {
	"0, disable",
	"1, +/-0.3%",
	"2, +/-0.5%",
	"3, +/-0.9%",
	"4, +/-1.2%",
};

static struct lcd_clk_config_s clk_conf = { /* unit: kHz */
	/* IN-OUT parameters */
	.fin = FIN_FREQ,
	.fout = 0,

	/* pll parameters */
	.pll_m = 0,
	.pll_n = 0,
	.pll_od1_sel = 0,
	.pll_od2_sel = 0,
	.pll_od3_sel = 0,
	.pll_level = 0,
	.ss_level = 0,
	.edp_div0 = 0,
	.edp_div1 = 0,
	.div_pre = 0, /* m6, m8, m8b */
	.div_post = 0, /* m6, m8, m8b */
	.div_sel = 0, /* g9tv, g9bb, gxtvbb */
	.xd = 0,
	.pll_fout = 0,

	/* clk path node parameters */
	.pll_m_max = 0,
	.pll_m_min = 0,
	.pll_n_max = 0,
	.pll_n_min = 0,
	.pll_frac_range = 0,
	.pll_od_sel_max = 0,
	.ss_level_max = 0,
	.div_pre_sel_max = 0, /* m6, m8, m8b */
	.div_post_sel_max = 0, /* m6, m8, m8b */
	.div_sel_max = 0, /* g9tv, g9bb, gxtvbb */
	.xd_max = 0,
	.pll_ref_fmax = 0,
	.pll_ref_fmin = 0,
	.pll_vco_fmax = 0,
	.pll_vco_fmin = 0,
	.pll_out_fmax = 0,
	.pll_out_fmin = 0,
	.div_pre_in_fmax = 0, /* m6, m8, m8b */
	.div_pre_out_fmax = 0, /* m6, m8, m8b */
	.div_post_out_fmax = 0, /* m6, m8, m8b */
	.div_in_fmax = 0, /* g9tv, g9bb, gxtvbb */
	.div_out_fmax = 0, /* g9tv, g9bb, gxtvbb */
	.xd_out_fmax = 0,
};

struct lcd_clk_config_s *get_lcd_clk_config(void)
{
	return &clk_conf;
}

static void lcd_clk_config_init_print(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
	case LCD_CHIP_M8B:
		LCDPR("lcd clk config init:\n"
			"pll_m_max:      %d\n"
			"pll_m_min:      %d\n"
			"pll_n_max:      %d\n"
			"pll_n_min:      %d\n"
			"pll_frac_range: %d\n"
			"pll_od_sel_max: %d\n"
			"ss_level_max:   %d\n"
			"pll_ref_fmax:      %d\n"
			"pll_ref_fmin:      %d\n"
			"pll_vco_fmax:      %d\n"
			"pll_vco_fmin:      %d\n"
			"pll_out_fmax:      %d\n"
			"pll_out_fmin:      %d\n"
			"div_pre_in_fmax:   %d\n"
			"div_pre_out_fmax:  %d\n"
			"div_post_out_fmax: %d\n"
			"xd_out_fmax:       %d\n\n",
			clk_conf.pll_m_max, clk_conf.pll_m_min,
			clk_conf.pll_n_max, clk_conf.pll_n_min,
			clk_conf.pll_frac_range,
			clk_conf.pll_od_sel_max, clk_conf.ss_level_max,
			clk_conf.pll_ref_fmax, clk_conf.pll_ref_fmin,
			clk_conf.pll_vco_fmax, clk_conf.pll_vco_fmin,
			clk_conf.pll_out_fmax, clk_conf.pll_out_fmin,
			clk_conf.div_pre_in_fmax, clk_conf.div_pre_out_fmax,
			clk_conf.div_post_out_fmax, clk_conf.xd_out_fmax);
		break;
	case LCD_CHIP_G9TV:
	case LCD_CHIP_G9BB:
	case LCD_CHIP_GXTVBB:
		LCDPR("lcd clk config:\n"
			"pll_m_max:      %d\n"
			"pll_m_min:      %d\n"
			"pll_n_max:      %d\n"
			"pll_n_min:      %d\n"
			"pll_frac_range: %d\n"
			"pll_od_sel_max: %d\n"
			"ss_level_max:   %d\n"
			"pll_ref_fmax:      %d\n"
			"pll_ref_fmin:      %d\n"
			"pll_vco_fmax:      %d\n"
			"pll_vco_fmin:      %d\n"
			"pll_out_fmax:      %d\n"
			"pll_out_fmin:      %d\n"
			"div_in_fmax:       %d\n"
			"div_out_fmax:      %d\n"
			"xd_out_fmax:       %d\n\n",
			clk_conf.pll_m_max, clk_conf.pll_m_min,
			clk_conf.pll_n_max, clk_conf.pll_n_min,
			clk_conf.pll_frac_range,
			clk_conf.pll_od_sel_max, clk_conf.ss_level_max,
			clk_conf.pll_ref_fmax, clk_conf.pll_ref_fmin,
			clk_conf.pll_vco_fmax, clk_conf.pll_vco_fmin,
			clk_conf.pll_out_fmax, clk_conf.pll_out_fmin,
			clk_conf.div_in_fmax, clk_conf.div_out_fmax,
			clk_conf.xd_out_fmax);
		break;
	default:
		break;
	}
}

void lcd_clk_config_print(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
	case LCD_CHIP_M8B:
		LCDPR("lcd clk config:\n"
			"pll_m:        %d\n"
			"pll_n:        %d\n"
			"pll_frac:     0x%03x\n"
			"pll_fvco:     %dkHz\n"
			"pll_od:       %d\n"
			"pll_out:      %dkHz\n"
			"div_pre:      %d\n"
			"div_post:     %d\n"
			"xd:           %d\n"
			"fout:         %dkHz\n"
			"ss_level:     %d\n\n",
			clk_conf.pll_m, clk_conf.pll_n,
			clk_conf.pll_frac, clk_conf.pll_fvco,
			clk_conf.pll_od1_sel, clk_conf.pll_fout,
			clk_conf.div_pre, clk_conf.div_post,
			clk_conf.xd, clk_conf.fout, clk_conf.ss_level);
		break;
	case LCD_CHIP_G9TV:
	case LCD_CHIP_G9BB:
	case LCD_CHIP_GXTVBB:
		LCDPR("lcd clk config:\n"
			"pll_m:        %d\n"
			"pll_n:        %d\n"
			"pll_frac:     0x%03x\n"
			"pll_fvco:     %dkHz\n"
			"pll_od1:      %d\n"
			"pll_od2:      %d\n"
			"pll_od3:      %d\n"
			"pll_out:      %dkHz\n"
			"div_sel:      %s(index %d)\n"
			"xd:           %d\n"
			"fout:         %dkHz\n"
			"ss_level:     %d\n\n",
			clk_conf.pll_m, clk_conf.pll_n,
			clk_conf.pll_frac, clk_conf.pll_fvco,
			clk_conf.pll_od1_sel, clk_conf.pll_od2_sel,
			clk_conf.pll_od3_sel, clk_conf.pll_fout,
			lcd_clk_div_sel_table[clk_conf.div_sel],
			clk_conf.div_sel, clk_conf.xd,
			clk_conf.fout, clk_conf.ss_level);
		break;
	default:
		break;
	}
}

static void lcd_clk_config_chip_init(void)
{
	struct lcd_clk_config_s *cConf;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	cConf = get_lcd_clk_config();
	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
		cConf->ss_level_max = SS_LEVEL_MAX_M8;
		cConf->pll_m_max = PLL_M_MAX_M8;
		cConf->pll_m_min = PLL_M_MIN_M8;
		cConf->pll_n_max = PLL_N_MAX_M8;
		cConf->pll_n_min = PLL_N_MIN_M8;
		cConf->pll_frac_range = PLL_FRAC_RANGE_M8;
		cConf->pll_od_sel_max = PLL_OD_SEL_MAX_M8;
		cConf->pll_ref_fmax = PLL_FREF_MAX_M8;
		cConf->pll_ref_fmin = PLL_FREF_MIN_M8;
		cConf->pll_vco_fmax = PLL_VCO_MAX_M8;
		cConf->pll_vco_fmin = PLL_VCO_MIN_M8;
		cConf->pll_out_fmax = DIV_PRE_CLK_IN_MAX_M8;
		cConf->pll_out_fmin = cConf->pll_vco_fmin /
			od_table[cConf->pll_od_sel_max - 1];
		cConf->div_pre_in_fmax = DIV_PRE_CLK_IN_MAX_M8;
		cConf->div_pre_out_fmax = DIV_POST_CLK_IN_MAX_M8;
		cConf->div_post_out_fmax = CRT_VID_CLK_IN_MAX_M8;
		cConf->xd_out_fmax = ENCL_CLK_IN_MAX_M8;
		break;
	case LCD_CHIP_M8B:
		cConf->ss_level_max = SS_LEVEL_MAX_M8B;
		cConf->pll_m_max = PLL_M_MAX_M8B;
		cConf->pll_m_min = PLL_M_MIN_M8B;
		cConf->pll_n_max = PLL_N_MAX_M8B;
		cConf->pll_n_min = PLL_N_MIN_M8B;
		cConf->pll_frac_range = PLL_FRAC_RANGE_M8B;
		cConf->pll_od_sel_max = PLL_OD_SEL_MAX_M8B;
		cConf->pll_ref_fmax = PLL_FREF_MAX_M8B;
		cConf->pll_ref_fmin = PLL_FREF_MIN_M8B;
		cConf->pll_vco_fmax = PLL_VCO_MAX_M8B;
		cConf->pll_vco_fmin = PLL_VCO_MIN_M8B;
		cConf->pll_out_fmax = DIV_PRE_CLK_IN_MAX_M8B;
		cConf->pll_out_fmin = cConf->pll_vco_fmin /
			od_table[cConf->pll_od_sel_max - 1];
		cConf->div_pre_in_fmax = DIV_PRE_CLK_IN_MAX_M8B;
		cConf->div_pre_out_fmax = DIV_POST_CLK_IN_MAX_M8B;
		cConf->div_post_out_fmax = CRT_VID_CLK_IN_MAX_M8B;
		cConf->xd_out_fmax = ENCL_CLK_IN_MAX_M8B;
		break;
	case LCD_CHIP_G9TV:
		cConf->ss_level_max = SS_LEVEL_MAX_G9TV;
		cConf->pll_m_max = PLL_M_MAX_G9TV;
		cConf->pll_m_min = PLL_M_MIN_G9TV;
		cConf->pll_n_max = PLL_N_MAX_G9TV;
		cConf->pll_n_min = PLL_N_MIN_G9TV;
		cConf->pll_frac_range = PLL_FRAC_RANGE_G9TV;
		cConf->pll_od_sel_max = PLL_OD_SEL_MAX_G9TV;
		cConf->pll_ref_fmax = PLL_FREF_MAX_G9TV;
		cConf->pll_ref_fmin = PLL_FREF_MIN_G9TV;
		cConf->pll_vco_fmax = PLL_VCO_MAX_G9TV;
		cConf->pll_vco_fmin = PLL_VCO_MIN_G9TV;
		cConf->pll_out_fmax = CLK_DIV_IN_MAX_G9TV;
		cConf->pll_out_fmin = cConf->pll_vco_fmin /
			od_table[cConf->pll_od_sel_max - 1];
		cConf->div_in_fmax = CLK_DIV_IN_MAX_G9TV;
		cConf->div_out_fmax = CRT_VID_CLK_IN_MAX_G9TV;
		cConf->xd_out_fmax = ENCL_CLK_IN_MAX_G9TV;
		break;
	case LCD_CHIP_G9BB:
		cConf->ss_level_max = SS_LEVEL_MAX_G9BB;
		cConf->pll_m_max = PLL_M_MAX_G9BB;
		cConf->pll_m_min = PLL_M_MIN_G9BB;
		cConf->pll_n_max = PLL_N_MAX_G9BB;
		cConf->pll_n_min = PLL_N_MIN_G9BB;
		cConf->pll_frac_range = PLL_FRAC_RANGE_G9BB;
		cConf->pll_od_sel_max = PLL_OD_SEL_MAX_G9BB;
		cConf->pll_ref_fmax = PLL_FREF_MAX_G9BB;
		cConf->pll_ref_fmin = PLL_FREF_MIN_G9BB;
		cConf->pll_vco_fmax = PLL_VCO_MAX_G9BB;
		cConf->pll_vco_fmin = PLL_VCO_MIN_G9BB;
		cConf->pll_out_fmax = CLK_DIV_IN_MAX_G9BB;
		cConf->pll_out_fmin = cConf->pll_vco_fmin /
			od_table[cConf->pll_od_sel_max - 1];
		cConf->div_in_fmax = CLK_DIV_IN_MAX_G9BB;
		cConf->div_out_fmax = CRT_VID_CLK_IN_MAX_G9BB;
		cConf->xd_out_fmax = ENCL_CLK_IN_MAX_G9BB;
		break;
	case LCD_CHIP_GXTVBB:
		cConf->ss_level_max = SS_LEVEL_MAX_GXTVBB;
		cConf->pll_m_max = PLL_M_MAX_GXTVBB;
		cConf->pll_m_min = PLL_M_MIN_GXTVBB;
		cConf->pll_n_max = PLL_N_MAX_GXTVBB;
		cConf->pll_n_min = PLL_N_MIN_GXTVBB;
		cConf->pll_frac_range = PLL_FRAC_RANGE_GXTVBB;
		cConf->pll_od_sel_max = PLL_OD_SEL_MAX_GXTVBB;
		cConf->pll_ref_fmax = PLL_FREF_MAX_GXTVBB;
		cConf->pll_ref_fmin = PLL_FREF_MIN_GXTVBB;
		cConf->pll_vco_fmax = PLL_VCO_MAX_GXTVBB;
		cConf->pll_vco_fmin = PLL_VCO_MIN_GXTVBB;
		cConf->pll_out_fmax = CLK_DIV_IN_MAX_GXTVBB;
		cConf->pll_out_fmin = cConf->pll_vco_fmin /
			od_table[cConf->pll_od_sel_max - 1];
		cConf->div_in_fmax = CLK_DIV_IN_MAX_GXTVBB;
		cConf->div_out_fmax = CRT_VID_CLK_IN_MAX_GXTVBB;
		cConf->xd_out_fmax = ENCL_CLK_IN_MAX_GXTVBB;
		break;
	default:
		LCDPR("%s invalid chip type\n", __func__);
		break;
	}
	if (lcd_debug_print_flag > 0)
		lcd_clk_config_init_print();
}

/* **********************************
 * lcd controller operation
 * ********************************** */
static int lcd_pll_wait_lock(unsigned int reg, unsigned int lock_bit)
{
	unsigned int pll_lock;
	int wait_loop = PLL_WAIT_LOCK_CNT;
	int ret = 0;

	do {
		udelay(50);
		pll_lock = lcd_hiu_getb(reg, lock_bit, 1);
		wait_loop--;
	} while ((pll_lock == 0) && (wait_loop > 0));
	if (wait_loop == 0)
		ret = -1;
	return ret;
}

static void lcd_set_pll_ss_m8(struct lcd_clk_config_s *cConf)
{
	LCDPR("set pll spread spectrum: %s, to do\n",
		lcd_pll_ss_table_m8[cConf->ss_level]);
}

static void lcd_set_pll_m8(struct lcd_clk_config_s *cConf)
{
	unsigned int pll_reg;
	unsigned int pll_ctrl2, pll_ctrl3, pll_ctrl4, od_fb;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int ret;

	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);
	pll_reg = ((1 << LCD_PLL_EN_M8) |
		(cConf->pll_od1_sel << LCD_PLL_OD_M8) |
		(cConf->pll_n << LCD_PLL_N_M8) |
		(cConf->pll_m << LCD_PLL_M_M8));

	if (cConf->pll_frac == 0)
		pll_ctrl2 = 0x0421a000;
	else
		pll_ctrl2 = (0x0431a000 | cConf->pll_frac);

	pll_ctrl4 = (0xd4000d67 & ~((1<<13) | (0xf<<14) | (0xf<<18)));
	switch (cConf->ss_level) {
	case 1: /* 0.5% */
		pll_ctrl4 |= ((1<<13) | (2<<18) | (1<<14));
		break;
	case 2: /* 1% */
		pll_ctrl4 |= ((1<<13) | (1<<18) | (1<<14));
		break;
	case 3: /* 1.5% */
		pll_ctrl4 |= ((1<<13) | (8<<18) | (1<<14));
		break;
	case 4: /* 2% */
		pll_ctrl4 |= ((1<<13) | (0<<18) | (1<<14));
		break;
	case 0:
	default:
		cConf->ss_level = 0;
		break;
	}

	switch (cConf->pll_level) {
	case 1: /* <=1.7G */
		/* special adjust for M8M2 vid2 pll 1.2G lock failed */
		if (lcd_drv->chip_type == LCD_CHIP_M8M2)
			pll_ctrl2 &= ~(0xf << 12);
		pll_ctrl3 = (cConf->ss_level > 0) ? 0xca7e3823 : 0xca45b823;
		od_fb = 0;
		break;
	case 2: /* 1.7G~2.0G */
		pll_ctrl2 |= (1 << 19); /* special adjust */
		pll_ctrl3 = (cConf->ss_level > 0) ? 0xca7e3823 : 0xca49b823;
		od_fb = 1;
		break;
	case 3: /* 2.0G~2.5G */
		pll_ctrl3 = (cConf->ss_level > 0) ? 0xca7e3823 : 0xca49b823;
		od_fb = 1;
		break;
	case 4: /* >=2.5G */
		pll_ctrl3 = (cConf->ss_level > 0) ? 0xca7e3823 : 0xce49c022;
		od_fb = 1;
		break;
	default:
		pll_ctrl3 = 0xca7e3823;
		od_fb = 0;
		break;
	}
	lcd_hiu_setb(HHI_VID_PLL_CNTL5, 1, 16, 1); /* enable bandgap */
	lcd_hiu_write(HHI_VID2_PLL_CNTL2, pll_ctrl2);
	lcd_hiu_write(HHI_VID2_PLL_CNTL3, pll_ctrl3);
	lcd_hiu_write(HHI_VID2_PLL_CNTL4, pll_ctrl4);
	/* bit[8] od_fb */
	lcd_hiu_write(HHI_VID2_PLL_CNTL5, (0x00700001 | (od_fb << 8)));
	lcd_hiu_write(HHI_VID2_PLL_CNTL, pll_reg | (1 << LCD_PLL_RST_M8));
	lcd_hiu_write(HHI_VID2_PLL_CNTL, pll_reg);
	ret = lcd_pll_wait_lock(HHI_VID2_PLL_CNTL, LCD_PLL_LOCK_M8);
	if (ret) { /* adjust pll for lock */
		if (cConf->pll_level == 2) {
			/* change setting if can't lock */
			lcd_hiu_setb(HHI_VID2_PLL_CNTL2, 1, 18, 1);
			lcd_hiu_setb(HHI_VID2_PLL_CNTL, 1, LCD_PLL_RST_M8, 1);
			udelay(5);
			lcd_hiu_setb(HHI_VID2_PLL_CNTL, 0, LCD_PLL_RST_M8, 1);
			LCDPR("change setting for vid2_pll stability\n");
		}
		ret = lcd_pll_wait_lock(HHI_VID2_PLL_CNTL, LCD_PLL_LOCK_M8);
	}
	if (ret)
		LCDERR("vid2_pll lock failed\n");
}

static void lcd_update_pll_frac_m8(struct lcd_clk_config_s *cConf)
{
	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);

	if (cConf->pll_frac > 0) {
		lcd_hiu_setb(HHI_VID2_PLL_CNTL2, 1, 20, 1);
		lcd_hiu_setb(HHI_VID2_PLL_CNTL2, cConf->pll_frac, 0, 12);
	} else {
		lcd_hiu_setb(HHI_VID2_PLL_CNTL2, 0, 20, 1);
		lcd_hiu_setb(HHI_VID2_PLL_CNTL2, 0, 0, 12);
	}
}

static void lcd_set_pll_ss_m8b(struct lcd_clk_config_s *cConf)
{
	LCDPR("set pll spread spectrum: %s, to do\n",
		lcd_pll_ss_table_m8b[cConf->ss_level]);
}

static void lcd_set_pll_m8b(struct lcd_clk_config_s *cConf)
{
	unsigned int pll_reg;
	unsigned int pll_ctrl2, pll_ctrl3, pll_ctrl4, od_fb;
	int ret;

	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);
	pll_reg = ((1 << LCD_PLL_EN_M8B) |
		(cConf->pll_od1_sel << LCD_PLL_OD_M8B) |
		(cConf->pll_n << LCD_PLL_N_M8B) |
		(cConf->pll_m << LCD_PLL_M_M8B));

	if (cConf->pll_frac == 0)
		pll_ctrl2 = 0x59c88000;
	else
		pll_ctrl2 = (0x59c8c000 | cConf->pll_frac);

	pll_ctrl4 = (0x00238100 & ~((1<<9) | (0xf<<4) | (0xf<<0)));
	switch (cConf->ss_level) {
	case 1: /* 0.5% */
		pll_ctrl4 |= ((1<<9) | (2<<4) | (1<<0));
		break;
	case 2: /* 1% */
		pll_ctrl4 |= ((1<<9) | (1<<4) | (1<<0));
		break;
	case 3: /* 1.5% */
		pll_ctrl4 |= ((1<<9) | (8<<4) | (1<<0));
		break;
	case 4: /* 2% */
		pll_ctrl4 |= ((1<<9) | (0<<4) | (1<<0));
		break;
	case 0:
	default:
		cConf->ss_level = 0;
		break;
	}

	switch (cConf->pll_level) {
	case 1: /* <=1.7G */
		pll_ctrl3 = (cConf->ss_level > 0) ? 0xca7e3823 : 0xca49b022;
		od_fb = 0;
		break;
	case 2: /* 1.7G~2.0G */
		pll_ctrl2 |= (1 << 19); /* special adjust */
		pll_ctrl3 = (cConf->ss_level > 0) ? 0xca7e3823 : 0xca493822;
		od_fb = 1;
		break;
	case 3: /* 2.0G~2.5G */
		pll_ctrl3 = (cConf->ss_level > 0) ? 0xca7e3823 : 0xca493822;
		od_fb = 1;
		break;
	case 4: /* >=2.5G */
		pll_ctrl3 = (cConf->ss_level > 0) ? 0xca7e3823 : 0xce49c022;
		od_fb = 1;
		break;
	default:
		pll_ctrl3 = 0xca7e3823;
		od_fb = 0;
		break;
	}
	lcd_hiu_setb(HHI_VID2_PLL_CNTL2, 1, 16, 1); /* enable ext LDO */
	lcd_hiu_write(HHI_VID_PLL_CNTL2, pll_ctrl2);
	lcd_hiu_write(HHI_VID_PLL_CNTL3, pll_ctrl3);
	/* cntl4 bit[24] od_fb */
	lcd_hiu_write(HHI_VID_PLL_CNTL4, (pll_ctrl4 | (od_fb << 24)));
	lcd_hiu_write(HHI_VID_PLL_CNTL5, 0x00012385);
	lcd_hiu_write(HHI_VID_PLL_CNTL, pll_reg | (1 << LCD_PLL_RST_M8B));
	lcd_hiu_write(HHI_VID_PLL_CNTL, pll_reg);
	ret = lcd_pll_wait_lock(HHI_VID_PLL_CNTL, LCD_PLL_LOCK_M8B);
	if (ret) { /* adjust pll for can't lock */
		if (cConf->pll_level == 2) {
			/* change setting if can't lock */
			lcd_hiu_setb(HHI_VID_PLL_CNTL2, 1, 12, 1);
			lcd_hiu_setb(HHI_VID_PLL_CNTL, 1, LCD_PLL_RST_M8B, 1);
			udelay(5);
			lcd_hiu_setb(HHI_VID_PLL_CNTL, 0, LCD_PLL_RST_M8B, 1);
			LCDPR("change setting for vid2_pll stability\n");
		}
		ret = lcd_pll_wait_lock(HHI_VID_PLL_CNTL, LCD_PLL_LOCK_M8B);
	}
	if (ret)
		LCDERR("vid2_pll lock failed\n");
}

static void lcd_update_pll_frac_m8b(struct lcd_clk_config_s *cConf)
{
	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);

	if (cConf->pll_frac > 0) {
		lcd_hiu_setb(HHI_VID_PLL_CNTL2, 1, 14, 1);
		lcd_hiu_setb(HHI_VID_PLL_CNTL2, cConf->pll_frac, 0, 12);
	} else {
		lcd_hiu_setb(HHI_VID_PLL_CNTL2, 0, 14, 1);
		lcd_hiu_setb(HHI_VID_PLL_CNTL2, 0, 0, 12);
	}
}

#if 0
static void hpll_load_initial(void)
{
	lcd_hiu_setb(HHI_VID_CLK_CNTL2, 1, 3, 1);
	lcd_hiu_write(HHI_VIID_CLK_CNTL, 0x0);
	lcd_hiu_setb(HHI_VIID_CLK_DIV, 3, 0, 8);
	lcd_hiu_setb(HHI_VIID_CLK_DIV, 8, 12, 4);
	lcd_hiu_write(HHI_VID_LOCK_CLK_CNTL, 0x80);

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
	lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 1, 18, 1);
	lcd_hiu_setb(HHI_VIID_CLK_DIV, 3, 0, 8);
	lcd_hiu_setb(HHI_VIID_CLK_DIV, 8, 12, 4);
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 1, 19, 1);
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 1, 0, 1);
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 1, 16, 3); /* tmp use fclk_div4 */
	lcd_vcbus_write(ENCL_VIDEO_EN, 0x1);
	udelay(10);
	lcd_vcbus_write(ENCL_VIDEO_EN, 0x0);
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, 16, 3); /* use vid_pll */
	udelay(20);
}
#endif

static void lcd_set_pll_ss_g9tv(struct lcd_clk_config_s *cConf)
{
	switch (cConf->ss_level) {
	case 1: /* +/- 0.2% */
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x1bdc5091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xa0b1a72c);
		break;
	case 2: /* +/- 0.35% */
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x1bd05091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xbcb1a72c);
		break;
	case 3: /* +/- 0.85% */
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x1bc85091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xbcb1a72c);
		break;
	case 4: /* +/- 1.5% */
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x1bc45091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xbcb1a72c);
		break;
	default: /* disable */
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x135c5091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
		break;
	}
	if ((lcd_debug_print_flag > 0) || (cConf->ss_level > 0)) {
		LCDPR("set pll spread spectrum: %s\n",
			lcd_pll_ss_table_g9tv[cConf->ss_level]);
	}
}

static void lcd_set_pll_g9tv(struct lcd_clk_config_s *cConf)
{
	unsigned int pll_ctrl, pll_ctrl2;
	int ret;

	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);
	//hpll_load_initial();

	pll_ctrl = ((1 << LCD_PLL_EN_G9TV) |
		(cConf->pll_n << LCD_PLL_N_G9TV) |
		(cConf->pll_m << LCD_PLL_M_G9TV));

	pll_ctrl2 = ((cConf->pll_od3_sel << LCD_PLL_OD3_G9TV) |
		(cConf->pll_od2_sel << LCD_PLL_OD2_G9TV) |
		(cConf->pll_od1_sel << LCD_PLL_OD1_G9TV));
	if (cConf->pll_frac > 0)
		pll_ctrl2 |= ((1 << 14) | (cConf->pll_frac << 0));

	lcd_hiu_write(HHI_HDMI_PLL_CNTL, pll_ctrl | (1 << LCD_PLL_RST_G9TV));
	lcd_hiu_write(HHI_HDMI_PLL_CNTL2, pll_ctrl2);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x135c5091);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x71486900);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00000a55);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL, pll_ctrl);

	//hpll_load_en();
	ret = lcd_pll_wait_lock(HHI_HDMI_PLL_CNTL, LCD_PLL_LOCK_G9TV);
	if (ret)
		LCDERR("hpll lock failed\n");

	lcd_set_pll_ss_g9tv(cConf);
}

static void lcd_set_pll_ss_g9bb(struct lcd_clk_config_s *cConf)
{
	switch (cConf->ss_level) {
	case 1: /* +/- 0.25% */
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0X1ba45091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x80bda72c);
		break;
	case 2: /* +/- 0.5% */
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x1ba05091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x80bda72c);
		break;
	default: /* disable */
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
		break;
	}
	if ((lcd_debug_print_flag > 0) || (cConf->ss_level > 0)) {
		LCDPR("set pll spread spectrum: %s\n",
			lcd_pll_ss_table_g9bb[cConf->ss_level]);
	}
}

static void lcd_set_pll_g9bb(struct lcd_clk_config_s *cConf)
{
	unsigned int pll_ctrl, pll_ctrl2;
	int ret;

	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);
	pll_ctrl = ((1 << LCD_PLL_EN_G9BB) |
		(cConf->pll_n << LCD_PLL_N_G9BB) |
		(cConf->pll_m << LCD_PLL_M_G9BB));

	pll_ctrl2 = ((cConf->pll_od3_sel << LCD_PLL_OD3_G9BB) |
		(cConf->pll_od2_sel << LCD_PLL_OD2_G9BB) |
		(cConf->pll_od1_sel << LCD_PLL_OD1_G9BB));
	if (cConf->pll_frac > 0)
		pll_ctrl2 |= ((1 << 14) | (cConf->pll_frac << 0));

	lcd_hiu_write(HHI_HDMI_PLL_CNTL, pll_ctrl | (1 << LCD_PLL_RST_G9BB));
	lcd_hiu_write(HHI_HDMI_PLL_CNTL2, pll_ctrl2);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x714869c0);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00000a55);
	lcd_hiu_write(HHI_HDMI_PLL_CNTL, pll_ctrl);

	ret = lcd_pll_wait_lock(HHI_HDMI_PLL_CNTL, LCD_PLL_LOCK_G9BB);
	if (ret)
		LCDERR("hpll lock failed\n");

	/* lcd_set_pll_ss_g9bb(cConf); */
}

static void lcd_update_pll_frac_g9(struct lcd_clk_config_s *cConf)
{
	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);

	if (cConf->pll_frac > 0) {
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL2, 1, 14, 1);
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL2, cConf->pll_frac, 0, 12);
	} else {
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL2, 0, 14, 1);
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL2, 0, 0, 12);
	}
}

static void lcd_set_pll_ss_gxtvbb(struct lcd_clk_config_s *cConf)
{
	if ((cConf->pll_fvco >= 5500000) && (cConf->pll_fvco <= 6000000)) {
		switch (cConf->ss_level) {
		case 1: /* +/- 0.3% */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x12dc5080);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xb01da72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x51486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00082a55);
			break;
		case 2: /* +/- 0.5% */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x12dc5080);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xa85da72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x51486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00082a55);
			break;
		case 3: /* +/- 0.9% */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x12dc5080);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xb09da72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x51486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00082a55);
			break;
		case 4: /* +/- 1.2% */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x12dc5080);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xb0dda72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x51486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00082a55);
			break;
		default: /* disable */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x12dc5081);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x71486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00002a55);
			break;
		}
	} else {
		switch (cConf->ss_level) {
		case 1: /* +/- 0.3% */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d1c5090);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xb01da72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x51486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00082a55);
			break;
		case 2: /* +/- 0.5% */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d1c5090);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xa85da72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x51486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00082a55);
			break;
		case 3: /* +/- 0.9% */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d1c5090);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xb09da72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x51486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00082a55);
			break;
		case 4: /* +/- 1.2% */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d1c5090);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0xb0dda72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x51486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00082a55);
			break;
		default: /* disable */
			lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x71486980);
			lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00002a55);
			break;
		}
	}
	if ((lcd_debug_print_flag > 0) || (cConf->ss_level > 0)) {
		LCDPR("set pll spread spectrum: %s\n",
			lcd_pll_ss_table_gxtvbb[cConf->ss_level]);
	}
}

static void lcd_set_pll_gxtvbb(struct lcd_clk_config_s *cConf)
{
	unsigned int pll_ctrl, pll_ctrl2;
	int ret;

	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);
	pll_ctrl = ((1 << LCD_PLL_EN_GXTVBB) |
		(1 << 27) | /* DPLL_BGP_EN */
		(cConf->pll_n << LCD_PLL_N_GXTVBB) |
		(cConf->pll_m << LCD_PLL_M_GXTVBB));

	pll_ctrl2 = ((cConf->pll_od3_sel << LCD_PLL_OD3_GXTVBB) |
		(cConf->pll_od2_sel << LCD_PLL_OD2_GXTVBB) |
		(cConf->pll_od1_sel << LCD_PLL_OD1_GXTVBB));
	pll_ctrl2 |= ((1 << 14) | (cConf->pll_frac << 0));

	lcd_hiu_write(HHI_HDMI_PLL_CNTL, pll_ctrl | (1 << LCD_PLL_RST_GXTVBB));
	lcd_hiu_write(HHI_HDMI_PLL_CNTL2, pll_ctrl2);
	if ((cConf->pll_fvco >= 5500000) && (cConf->pll_fvco <= 6000000)) {
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x12dc5081);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x71486980);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00002a55);
	} else {
		lcd_hiu_write(HHI_HDMI_PLL_CNTL3, 0x0d5c5091);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL4, 0x801da72c);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL5, 0x71486980);
		lcd_hiu_write(HHI_HDMI_PLL_CNTL6, 0x00002a55);
	}
	lcd_hiu_write(HHI_HDMI_PLL_CNTL, pll_ctrl);

	ret = lcd_pll_wait_lock(HHI_HDMI_PLL_CNTL, LCD_PLL_LOCK_GXTVBB);
	if (ret)
		LCDERR("hpll lock failed\n");

	/* if (cConf->ss_level > 0)
		lcd_set_pll_ss_gxtvbb(cConf); */
}

static void lcd_update_pll_frac_gxtvbb(struct lcd_clk_config_s *cConf)
{
	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);

	if (cConf->pll_frac > 0) {
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL2, 1, 14, 1);
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL2, cConf->pll_frac, 0, 12);
	} else {
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL2, 0, 14, 1);
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL2, 0, 0, 12);
	}
}

static void lcd_set_clk_div_m8(int lcd_type, struct lcd_clk_config_s *cConf)
{
	unsigned int div_reg;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);

	/* select pll */
	if (lcd_drv->chip_type == LCD_CHIP_M8B)
		div_reg = (0 << DIV_CLK_SEL);
	else
		div_reg = (1 << DIV_CLK_SEL);
	div_reg |= ((1 << DIV_CLK_IN_EN) | (0x3 << 0)); /* enable clk */
	div_reg |= (cConf->div_pre << DIV_PRE_SEL); /* set div_pre */
	/* set div_post */
	if (cConf->div_post > 0) {/* div_post > 1 */
		div_reg |= ((1 << DIV_POST_SEL) |
			(cConf->div_post << DIV_POST_TCNT));
	}
	if (lcd_type == LCD_LVDS) /* enable lvds_clk */
		div_reg |= (1 << DIV_LVDS_CLK_EN);

	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, VCLK2_EN, 1);
	udelay(5);

	if ((lcd_drv->chip_type == LCD_CHIP_M8) ||
		(lcd_drv->chip_type == LCD_CHIP_M8M2)) {
		/* select vclk from pll */
		switch (lcd_type) {
		case LCD_MIPI:
			/* pll_out mux to mipi-dsi phy & vid2_pll */
			lcd_hiu_setb(HHI_VID2_PLL_CNTL5, 3, 23, 3);
			lcd_hiu_setb(HHI_DSI_LVDS_EDP_CNTL1, 0, 4, 1);
			break;
		case LCD_EDP:
			/* reset edp tx phy */
			lcd_hiu_write(HHI_EDP_TX_PHY_CNTL0, (1 << 16));

			/* pll_out mux to edp phy */
			lcd_hiu_setb(HHI_VID2_PLL_CNTL5, 4, 23, 3);
			lcd_hiu_setb(HHI_DSI_LVDS_EDP_CNTL1, 1, 4, 1);

			/* enable edp phy channel & serializer clk,
			and release reset */
			lcd_hiu_write(HHI_EDP_TX_PHY_CNTL0,
				((0xf << 0) | (1 << 4)));
			/* set edptx_phy_clk_div0, div1 */
			lcd_hiu_setb(HHI_EDP_TX_PHY_CNTL0,
				cConf->edp_div0, 20, 4);
			lcd_hiu_setb(HHI_EDP_TX_PHY_CNTL0,
				cConf->edp_div1, 24, 3);
			/* enable divider N, for vid2_pll_in */
			lcd_hiu_setb(HHI_EDP_TX_PHY_CNTL0, 1, 5, 1);
			break;
		case LCD_LVDS:
		case LCD_TTL:
		default:
			/* pll_out mux to vid2_pll */
			lcd_hiu_setb(HHI_VID2_PLL_CNTL5, 2, 23, 3);
			lcd_hiu_setb(HHI_DSI_LVDS_EDP_CNTL1, 0, 4, 1);
			break;
		}
		udelay(10);
	}

	/* pll_div2 */
	lcd_hiu_write(HHI_VIID_DIVIDER_CNTL, div_reg);
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 1, DIV_POST_SOFT_RST, 1);
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 1, DIV_PRE_SOFT_RST, 1);
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 0, DIV_POST_RST, 1);
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 0, DIV_PRE_RST, 1);
	udelay(5);
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 0, DIV_PRE_SOFT_RST, 1);
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 0, DIV_POST_SOFT_RST, 1);
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 1, DIV_PRE_RST, 1);
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 1, DIV_POST_RST, 1);
	udelay(5);
}

static unsigned int lcd_clk_div_g9_gxtvbb[][3] = {
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

static void lcd_set_clk_div_g9_gxtvbb(struct lcd_clk_config_s *cConf)
{
	unsigned int shift_val, shift_sel;
	int i;

	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);

	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, VCLK2_EN, 1);
	udelay(5);

	/* Disable the div output clock */
	lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 19, 1);
	lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 15, 1);

	i = 0;
	while (lcd_clk_div_g9_gxtvbb[i][0] != CLK_DIV_SEL_MAX) {
		if (cConf->div_sel == lcd_clk_div_g9_gxtvbb[i][0])
			break;
		i++;
	}
	if (lcd_clk_div_g9_gxtvbb[i][0] == CLK_DIV_SEL_MAX)
		LCDERR("invalid clk divider\n");
	shift_val = lcd_clk_div_g9_gxtvbb[i][1];
	shift_sel = lcd_clk_div_g9_gxtvbb[i][2];

	if (shift_val == 0xffff) { /* if divide by 1 */
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 1, 18, 1);
	} else {
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 18, 1);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 16, 2);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 15, 1);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 0, 14);

		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, shift_sel, 16, 2);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 1, 15, 1);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, shift_val, 0, 14);
		lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 0, 15, 1);
	}
	/* Enable the final output clock */
	lcd_hiu_setb(HHI_VID_PLL_CLK_DIV, 1, 19, 1);
}

static void lcd_set_vclk_crt(int lcd_type, struct lcd_clk_config_s *cConf)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	if (lcd_debug_print_flag == 2)
		LCDPR("%s\n", __func__);

	/* setup the XD divider value */
	lcd_hiu_setb(HHI_VIID_CLK_DIV, (cConf->xd-1), VCLK2_XD, 8);
	udelay(5);
	/* Bit[18:16] - v2_cntl_clk_in_sel */
	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
		/* select vid_pll2_clk */
		lcd_hiu_setb(HHI_VIID_CLK_CNTL, 4, VCLK2_CLK_IN_SEL, 3);
		break;
	case LCD_CHIP_M8B:
	case LCD_CHIP_G9TV:
	case LCD_CHIP_G9BB:
	case LCD_CHIP_GXTVBB:
		/* select vid_pll_clk */
		lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, VCLK2_CLK_IN_SEL, 3);
		break;
	default:
		break;
	}
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 1, VCLK2_EN, 1);
	udelay(2);

	/* [15:12] encl_clk_sel, select vclk2_div1 */
	lcd_hiu_setb(HHI_VIID_CLK_DIV, 8, ENCL_CLK_SEL, 4);
	/* release vclk2_div_reset and enable vclk2_div */
	lcd_hiu_setb(HHI_VIID_CLK_DIV, 1, VCLK2_XD_EN, 2);
	udelay(5);

	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 1, VCLK2_DIV1_EN, 1);
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 1, VCLK2_SOFT_RST, 1);
	udelay(10);
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, VCLK2_SOFT_RST, 1);
	udelay(5);

	/* enable CTS_ENCL clk gate, new added in m8b & m8m2 */
	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8B:
	case LCD_CHIP_M8M2:
	case LCD_CHIP_G9TV:
	case LCD_CHIP_G9BB:
	case LCD_CHIP_GXTVBB:
		lcd_hiu_setb(HHI_VID_CLK_CNTL2, 1, ENCL_GATE_VCLK, 1);
		break;
	default:
		break;
	}
}

/* **********************************
 * lcd config operation
 * ********************************** */
static int check_pll_m8(struct lcd_clk_config_s *cConf,
		unsigned int pll_fout)
{
	unsigned int m, n, od_sel, od;
	unsigned int pll_fvco;
	unsigned int od_fb = 0, pll_frac, pll_level = 0;
	int done = 0;

	if ((pll_fout > cConf->pll_out_fmax) ||
		(pll_fout < cConf->pll_out_fmin)) {
		return done;
	}
	for (od_sel = cConf->pll_od_sel_max; od_sel > 0; od_sel--) {
		od = od_table[od_sel - 1];
		pll_fvco = pll_fout * od;
		if ((pll_fvco < cConf->pll_vco_fmin) ||
			(pll_fvco > cConf->pll_vco_fmax)) {
			continue;
		}
		cConf->pll_od1_sel = od_sel - 1;
		cConf->pll_fout = pll_fout;
		if (lcd_debug_print_flag == 2) {
			LCDPR("od_sel=%d, pll_fvco=%d\n",
				(od_sel - 1), pll_fvco);
		}
		if ((pll_fvco >= 2500000) &&
			(pll_fvco <= cConf->pll_vco_fmax)) {
			od_fb = 1;
			pll_level = 4;
		} else if ((pll_fvco >= 2000000) && (pll_fvco < 2500000)) {
			od_fb = 1;
			pll_level = 3;
		} else if ((pll_fvco >= 1700000) && (pll_fvco < 2000000)) {
			/* special adjust */
			od_fb = 1;
			pll_level = 2;
		} else if ((pll_fvco >= cConf->pll_vco_fmin) &&
			(pll_fvco < 1700000)) {
			od_fb = 0;
			pll_level = 1;
		}
		cConf->pll_fvco = pll_fvco;
		n = 1;
		pll_fvco = pll_fvco / (od_fb + 1);
		m = pll_fvco / cConf->fin;
		pll_frac = (pll_fvco % cConf->fin) * 4096 / cConf->fin;
		cConf->pll_m = m;
		cConf->pll_n = n;
		cConf->pll_frac = pll_frac;
		cConf->pll_level = pll_level;
		if (lcd_debug_print_flag == 2) {
			LCDPR("pll_m=%d, pll_n=%d\n", m, n);
			LCDPR("pll_frac=0x%03x, pll_level=%d\n",
				pll_frac, pll_level);
		}
		done = 1;
		break;
	}
	return done;
}

static unsigned int error_abs(unsigned int num1, int unsigned num2)
{
	if (num1 >= num2)
		return num1 - num2;
	else
		return num2 - num1;
}

static int check_divider(struct lcd_clk_config_s *cConf,
		unsigned int div_clk_in)
{
	int done;
	unsigned int div_pre_sel;
	unsigned int div_pre, div_post;
	unsigned int div_pre_out, div_post_out;
	unsigned int xd, final_freq;
	unsigned int error;

	done = 0;
	if (div_clk_in > cConf->div_pre_in_fmax)
		return done;
	for (div_pre_sel = 0; div_pre_sel < cConf->div_pre_sel_max;
		div_pre_sel++) {
		div_pre = div_pre_table[div_pre_sel];
		div_pre_out = div_clk_in / div_pre;
		if (div_pre_out > cConf->div_pre_out_fmax)
			continue;
		div_post = cConf->div_post + 1;
		div_post_out = div_pre_out / div_post;
		if (div_post_out > cConf->div_post_out_fmax)
			continue;
		cConf->div_pre = div_pre_sel;
		if (lcd_debug_print_flag == 2) {
			LCDPR("div_pre=%d, div_pre_fout=%d, div_post_fout=%d\n",
				div_pre, div_pre_out, div_post_out);
		}
		for (xd = 1; xd <= cConf->xd_max; xd++) {
			final_freq = div_post_out / xd;
			if (final_freq > cConf->xd_out_fmax)
				continue;
			/* error = cConf->fout - final_freq; */ /* for edp */
			error = error_abs(final_freq, cConf->fout);
			if (error < cConf->err_fmin) {
				cConf->err_fmin = error;
				cConf->xd = xd;
				if (lcd_debug_print_flag == 2) {
					LCDPR("xd=%d, final_freq=%d\n",
						xd, final_freq);
				}
				done = 1;
			}
		}
	}
	return done;
}

static void lcd_clk_generate_m8(struct lcd_config_s *pconf)
{
	unsigned int pll_fout;
	unsigned int edp_phy_out;
	unsigned int div_pre_in, div_pre_out, div_post_out;
	unsigned int m, n, od_sel, pll_level, pll_frac;
	unsigned int edp_div0, edp_div1, edp_div0_sel, edp_div1_sel;
	unsigned int div_pre_sel, div_pre, div_post, xd;
	unsigned int dsi_bit_rate_max = 0, dsi_bit_rate_min = 0;
	unsigned int tmp;
	struct lcd_clk_config_s *cConf;
	int done;

	done = 0;
	cConf = get_lcd_clk_config();
	cConf->fout = pconf->lcd_timing.lcd_clk / 1000; /* kHz */
	cConf->err_fmin = MAX_ERROR;

	if (cConf->fout > cConf->xd_out_fmax) {
		LCDERR("%s: wrong lcd_clk value %dkHz\n",
			__func__, cConf->fout);
		goto generate_clk_done_m8;
	}

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_MIPI:
		cConf->div_pre_sel_max = DIV_PRE_SEL_MAX;
		div_post = 1;
		cConf->xd_max = CRT_VID_DIV_MAX;
		tmp = pconf->lcd_control.mipi_config->bit_rate_max;
		dsi_bit_rate_max = tmp * 1000; /* change to kHz */
		dsi_bit_rate_min = dsi_bit_rate_max - cConf->fout;
		break;
	case LCD_EDP:
		cConf->div_pre_sel_max = 1;
		div_post = 1;
		cConf->xd_max = 1;
		cConf->err_fmin = 30 * 1000;
		break;
	case LCD_LVDS:
		cConf->div_pre_sel_max = DIV_PRE_SEL_MAX;
		div_post = 7;
		cConf->xd_max = 1;
		break;
	case LCD_TTL:
		cConf->div_pre_sel_max = DIV_PRE_SEL_MAX;
		div_post = 1;
		cConf->xd_max = CRT_VID_DIV_MAX;
		break;
	default:
		cConf->div_pre_sel_max = DIV_PRE_SEL_MAX;
		div_post = 1;
		cConf->xd_max = 1;
		break;
	}
	cConf->div_post = div_post - 1;

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_MIPI:
		for (xd = 1; xd <= cConf->xd_max; xd++) {
			div_post_out = cConf->fout * xd;
			if (div_post_out > cConf->div_post_out_fmax)
				continue;
			div_pre_out = div_post_out * div_post;
			if (div_pre_out > cConf->div_pre_out_fmax)
				continue;
			cConf->xd = xd;
			if (lcd_debug_print_flag == 2) {
				LCDPR("fout=%d, xd=%d\n", cConf->fout, xd);
				LCDPR("div_post_fout=%d, div_pre_fout=%d\n",
					div_post_out, div_pre_out);
			}
			for (div_pre_sel = 0;
				div_pre_sel < cConf->div_pre_sel_max;
				div_pre_sel++) {
				div_pre = div_pre_table[div_pre_sel];
				div_pre_in = div_pre_out * div_pre;
				if (div_pre_in > cConf->div_pre_in_fmax)
					continue;
				pll_fout = div_pre_in;
				if ((pll_fout > dsi_bit_rate_max) ||
					(pll_fout < dsi_bit_rate_min)) {
					continue;
				}
				cConf->div_pre = div_pre_sel;
				if (lcd_debug_print_flag == 2) {
					LCDPR("div_pre=%d, pll_fout=%d\n",
						div_pre, pll_fout);
				}
				done = check_pll_m8(cConf, pll_fout);
				if (done)
					goto generate_clk_done_m8;
			}
		}
		break;
	case LCD_EDP:
		switch (pconf->lcd_control.edp_config->link_rate) {
		case 0:
			n = 1;
			m = 67;
			od_sel = 0;
			pll_level = 1;
			pll_frac = 0x800;
			pll_fout = 1620000;
			cConf->pll_fvco = 1620000;
			break;
		case 1:
		default:
			n = 1;
			m = 56;
			od_sel = 0;
			pll_level = 4;
			pll_frac = 0x400;
			pll_fout = 2700000;
			cConf->pll_fvco = 2700000;
			break;
		}
		cConf->pll_m = m;
		cConf->pll_n = n;
		cConf->pll_frac = pll_frac;
		cConf->pll_level = pll_level;
		cConf->pll_od1_sel = od_sel;
		cConf->pll_fout = pll_fout;
		for (edp_div1_sel = 0; edp_div1_sel < EDP_DIV1_SEL_MAX;
			edp_div1_sel++) {
			edp_div1 = edp_div1_table[edp_div1_sel];
			cConf->edp_div1 = edp_div1_sel;
			for (edp_div0_sel = 0; edp_div0_sel < EDP_DIV0_SEL_MAX;
				edp_div0_sel++) {
				edp_div0 = edp_div0_table[edp_div0_sel];
				edp_phy_out = pll_fout / (edp_div0 * edp_div1);
				cConf->edp_div0 = edp_div0_sel;
				div_pre_in = edp_phy_out;
				done = check_divider(cConf, div_pre_in);
				if (done)
					goto generate_clk_done_m8;
			}
		}
		break;
	case LCD_LVDS:
	case LCD_TTL:
		for (xd = 1; xd <= cConf->xd_max; xd++) {
			div_post_out = cConf->fout * xd;
			if (div_post_out > cConf->div_post_out_fmax)
				continue;
			div_pre_out = div_post_out * div_post;
			if (div_pre_out <= cConf->div_pre_out_fmax)
				continue;
			cConf->xd = xd;
			if (lcd_debug_print_flag == 2) {
				LCDPR("fout=%d, xd=%d\n", cConf->fout, xd);
				LCDPR("div_post_out=%d, div_pre_out=%d\n",
					div_post_out, div_pre_out);
			}
			for (div_pre_sel = 0;
				div_pre_sel < cConf->div_pre_sel_max;
				div_pre_sel++) {
				div_pre = div_pre_table[div_pre_sel];
				div_pre_in = div_pre_out * div_pre;
				if (div_pre_in > cConf->div_pre_in_fmax)
					continue;
				cConf->div_pre = div_pre_sel;
				pll_fout = div_pre_in;
				if (lcd_debug_print_flag == 2) {
					LCDPR("div_pre=%d, pll_fout=%d\n",
						div_pre, pll_fout);
				}
				done = check_pll_m8(cConf, pll_fout);
				if (done)
					goto generate_clk_done_m8;
			}
		}
		break;
	default:
		break;
	}

generate_clk_done_m8:
	if (done) {
		pconf->lcd_timing.pll_ctrl =
			(cConf->pll_od1_sel << PLL_CTRL_OD1) |
			(cConf->pll_n << PLL_CTRL_N) |
			(cConf->pll_m << PLL_CTRL_M);
		pconf->lcd_timing.div_ctrl =
			(cConf->edp_div1 << DIV_CTRL_EDP_DIV1) |
			(cConf->edp_div0 << DIV_CTRL_EDP_DIV0) |
			(cConf->div_post << DIV_CTRL_DIV_POST) |
			(cConf->div_pre << DIV_CTRL_DIV_PRE) |
			(cConf->xd << DIV_CTRL_XD);
		tmp = (pconf->lcd_timing.clk_ctrl &
			~((0x7 << CLK_CTRL_LEVEL) | (0xfff << CLK_CTRL_FRAC)));
		pconf->lcd_timing.clk_ctrl = (tmp |
			(cConf->pll_level << CLK_CTRL_LEVEL) |
			(cConf->pll_frac << CLK_CTRL_FRAC));
	} else {
		pconf->lcd_timing.pll_ctrl = (1 << PLL_CTRL_OD1) |
			(1 << PLL_CTRL_N) | (50 << PLL_CTRL_M);
		pconf->lcd_timing.div_ctrl =
			(0 << DIV_CTRL_EDP_DIV1) | (0 << DIV_CTRL_EDP_DIV0) |
			(1 << DIV_CTRL_DIV_PRE) | (1 << DIV_CTRL_DIV_PRE) |
			(7 << DIV_CTRL_XD);
		tmp = (pconf->lcd_timing.clk_ctrl &
			~((0x7 << CLK_CTRL_LEVEL) | (0xfff << CLK_CTRL_FRAC)));
		pconf->lcd_timing.clk_ctrl |= (1 << CLK_CTRL_LEVEL);
		LCDERR("Out of clock range, reset to default setting!\n");
	}
}

static void lcd_pll_frac_generate_m8(struct lcd_config_s *pconf)
{
	LCDPR("to do\n");
}

static unsigned int clk_div_calc_g9_gxtvbb(unsigned int clk,
		unsigned int div_sel, int dir)
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
		LCDERR("clk_div_sel: Invalid parameter\n");
		break;
	}

	return clk_ret;
}

static unsigned int clk_div_get_g9_gxtvbb(unsigned int clk_div)
{
	unsigned int div_sel;

	/* div * 100 */
	switch (clk_div) {
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

static int check_pll_g9_gxtvbb(struct lcd_clk_config_s *cConf,
		unsigned int pll_fout)
{
	unsigned int m, n;
	unsigned int od1_sel, od2_sel, od3_sel, od1, od2, od3;
	unsigned int pll_fod2_in, pll_fod3_in, pll_fvco;
	unsigned int od_fb = 0, pll_frac;
	int done;

	done = 0;
	if ((pll_fout > cConf->pll_out_fmax) ||
		(pll_fout < cConf->pll_out_fmin)) {
		return done;
	}
	for (od3_sel = cConf->pll_od_sel_max; od3_sel > 0; od3_sel--) {
		od3 = od_table[od3_sel - 1];
		pll_fod3_in = pll_fout * od3;
		for (od2_sel = od3_sel; od2_sel > 0; od2_sel--) {
			od2 = od_table[od2_sel - 1];
			pll_fod2_in = pll_fod3_in * od2;
			for (od1_sel = od2_sel; od1_sel > 0; od1_sel--) {
				od1 = od_table[od1_sel - 1];
				pll_fvco = pll_fod2_in * od1;
				if ((pll_fvco < cConf->pll_vco_fmin) ||
					(pll_fvco > cConf->pll_vco_fmax)) {
					continue;
				}
				cConf->pll_od1_sel = od1_sel - 1;
				cConf->pll_od2_sel = od2_sel - 1;
				cConf->pll_od3_sel = od3_sel - 1;
				cConf->pll_fout = pll_fout;
				if (lcd_debug_print_flag == 2) {
					LCDPR("od1=%d, od2=%d, od3=%d\n",
						(od1_sel - 1), (od2_sel - 1),
						(od3_sel - 1));
					LCDPR("pll_fvco=%d\n", pll_fvco);
				}
				cConf->pll_fvco = pll_fvco;
				n = 1;
				od_fb = 0; /* pll default */
				pll_fvco = pll_fvco / ((od_fb + 1) * 2);
				m = pll_fvco / cConf->fin;
				pll_frac = (pll_fvco % cConf->fin) *
					cConf->pll_frac_range / cConf->fin;
				cConf->pll_m = m;
				cConf->pll_n = n;
				cConf->pll_frac = pll_frac;
				if (lcd_debug_print_flag == 2) {
					LCDPR("m=%d, n=%d, frac=%d\n",
						m, n, pll_frac);
				}
				done = 1;
				break;
			}
		}
	}
	return done;
}

static void lcd_clk_generate_g9_gxtvbb(struct lcd_config_s *pconf)
{
	unsigned int pll_fout;
	unsigned int clk_div_in, clk_div_out;
	unsigned int clk_div_sel, xd;
	struct lcd_clk_config_s *cConf;
	int done;

	done = 0;
	cConf = get_lcd_clk_config();
	cConf->fout = pconf->lcd_timing.lcd_clk / 1000; /* kHz */
	cConf->err_fmin = MAX_ERROR;

	if (cConf->fout > cConf->xd_out_fmax) {
		LCDERR("%s: wrong lcd_clk value %dkHz\n",
			__func__, cConf->fout);
		goto generate_clk_done_g9_gxtvbb;
	}

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_TTL:
		clk_div_sel = CLK_DIV_SEL_1;
		cConf->xd_max = CRT_VID_DIV_MAX;
		for (xd = 1; xd <= cConf->xd_max; xd++) {
			clk_div_out = cConf->fout * xd;
			if (clk_div_out > cConf->div_out_fmax)
				continue;
			if (lcd_debug_print_flag == 2) {
				LCDPR("fout=%d, xd=%d, clk_div_out=%d\n",
					cConf->fout, xd, clk_div_out);
			}
			clk_div_in = clk_div_calc_g9_gxtvbb(clk_div_out,
					clk_div_sel, CLK_DIV_O2I);
			if (clk_div_in > cConf->div_in_fmax)
				continue;
			cConf->xd = xd;
			cConf->div_sel = clk_div_sel;
			pll_fout = clk_div_in;
			if (lcd_debug_print_flag == 2) {
				LCDPR("clk_div_sel=%s(index %d), pll_fout=%d\n",
					lcd_clk_div_sel_table[clk_div_sel],
					clk_div_sel, pll_fout);
			}
			done = check_pll_g9_gxtvbb(cConf, pll_fout);
			if (done)
				goto generate_clk_done_g9_gxtvbb;
		}
		break;
	case LCD_LVDS:
		clk_div_sel = CLK_DIV_SEL_7;
		xd = 1;
		clk_div_out = cConf->fout * xd;
		if (clk_div_out > cConf->div_out_fmax)
			goto generate_clk_done_g9_gxtvbb;
		if (lcd_debug_print_flag == 2) {
			LCDPR("fout=%d, xd=%d, clk_div_out=%d\n",
				cConf->fout, xd, clk_div_out);
		}
		clk_div_in = clk_div_calc_g9_gxtvbb(clk_div_out,
				clk_div_sel, CLK_DIV_O2I);
		if (clk_div_in > cConf->div_in_fmax)
			goto generate_clk_done_g9_gxtvbb;
		cConf->xd = xd;
		cConf->div_sel = clk_div_sel;
		pll_fout = clk_div_in;
		if (lcd_debug_print_flag == 2) {
			LCDPR("clk_div_sel=%s(index %d), pll_fout=%d\n",
				lcd_clk_div_sel_table[clk_div_sel],
				clk_div_sel, pll_fout);
		}
		done = check_pll_g9_gxtvbb(cConf, pll_fout);
		if (done)
			goto generate_clk_done_g9_gxtvbb;
		break;
	case LCD_VBYONE:
		cConf->div_sel_max = CLK_DIV_SEL_MAX;
		cConf->xd_max = CRT_VID_DIV_MAX;
		pll_fout = pconf->lcd_control.vbyone_config->bit_rate / 1000;
		clk_div_in = pll_fout;
		if (clk_div_in > cConf->div_in_fmax)
			goto generate_clk_done_g9_gxtvbb;
		if (lcd_debug_print_flag == 2)
			LCDPR("pll_fout=%d\n", pll_fout);
		cConf->xd = 1;
		clk_div_out = cConf->fout;
		if (clk_div_out > cConf->div_out_fmax)
			goto generate_clk_done_g9_gxtvbb;
		clk_div_sel = clk_div_get_g9_gxtvbb(
				clk_div_in * 100 / clk_div_out);
		cConf->div_sel = clk_div_sel;
		if (lcd_debug_print_flag == 2) {
			LCDPR("clk_div_sel=%s(index %d)\n",
				lcd_clk_div_sel_table[clk_div_sel],
				cConf->div_sel);
		}
		done = check_pll_g9_gxtvbb(cConf, pll_fout);
		break;
	default:
		break;
	}

generate_clk_done_g9_gxtvbb:
	if (done) {
		pconf->lcd_timing.pll_ctrl =
			(cConf->pll_od1_sel << PLL_CTRL_OD1) |
			(cConf->pll_od2_sel << PLL_CTRL_OD2) |
			(cConf->pll_od3_sel << PLL_CTRL_OD3) |
			(cConf->pll_n << PLL_CTRL_N)         |
			(cConf->pll_m << PLL_CTRL_M);
		pconf->lcd_timing.div_ctrl =
			(cConf->div_sel << DIV_CTRL_DIV_SEL) |
			(cConf->xd << DIV_CTRL_XD);
		pconf->lcd_timing.clk_ctrl =
			(cConf->pll_frac << CLK_CTRL_FRAC);
	} else {
		pconf->lcd_timing.pll_ctrl =
			(1 << PLL_CTRL_OD1) |
			(1 << PLL_CTRL_OD2) |
			(1 << PLL_CTRL_OD3) |
			(1 << PLL_CTRL_N)   |
			(50 << PLL_CTRL_M);
		pconf->lcd_timing.div_ctrl =
			(CLK_DIV_SEL_1 << DIV_CTRL_DIV_SEL) |
			(7 << DIV_CTRL_XD);
		pconf->lcd_timing.clk_ctrl = (0 << CLK_CTRL_FRAC);
		LCDERR("Out of clock range, reset to default setting\n");
	}
}

static void lcd_pll_frac_generate_g9_gxtvbb(struct lcd_config_s *pconf)
{
	unsigned int pll_fout;
	unsigned int clk_div_in, clk_div_out, clk_div_sel;
	unsigned int od1, od2, od3, pll_fvco;
	unsigned int m, n, od_fb, frac, offset, temp;
	struct lcd_clk_config_s *cConf;

	cConf = get_lcd_clk_config();
	cConf->fout = pconf->lcd_timing.lcd_clk / 1000; /* kHz */
	clk_div_sel = cConf->div_sel;
	od1 = od_table[cConf->pll_od1_sel];
	od2 = od_table[cConf->pll_od2_sel];
	od3 = od_table[cConf->pll_od3_sel];
	m = cConf->pll_m;
	n = cConf->pll_n;

	if (lcd_debug_print_flag == 2) {
		LCDPR("m=%d, n=%d, od1=%d, od2=%d, od3=%d\n",
			m, n, cConf->pll_od1_sel, cConf->pll_od2_sel,
			cConf->pll_od3_sel);
		LCDPR("clk_div_sel=%s(index %d), xd=%d\n",
			lcd_clk_div_sel_table[clk_div_sel],
			clk_div_sel, cConf->xd);
	}
	if (cConf->fout > cConf->xd_out_fmax) {
		LCDERR("%s: wrong lcd_clk value %dkHz\n",
			__func__, cConf->fout);
		return;
	}
	if (lcd_debug_print_flag == 2)
		LCDPR("%s pclk=%d\n", __func__, cConf->fout);

	clk_div_out = cConf->fout * cConf->xd;
	if (clk_div_out > cConf->div_out_fmax) {
		LCDERR("%s: wrong clk_div_out value %dkHz\n",
			__func__, clk_div_out);
		return;
	}

	clk_div_in =
		clk_div_calc_g9_gxtvbb(clk_div_out, clk_div_sel, CLK_DIV_O2I);
	if (clk_div_in > cConf->div_in_fmax) {
		LCDERR("%s: wrong clk_div_in value %dkHz\n",
			__func__, clk_div_in);
		return;
	}

	pll_fout = clk_div_in;
	if ((pll_fout > cConf->pll_out_fmax) ||
		(pll_fout < cConf->pll_out_fmin)) {
		LCDERR("%s: wrong pll_fout value %dkHz\n", __func__, pll_fout);
		return;
	}
	if (lcd_debug_print_flag == 2)
		LCDPR("%s pll_fout=%d\n", __func__, pll_fout);

	pll_fvco = pll_fout * od1 * od2 * od3;
	if ((pll_fvco < cConf->pll_vco_fmin) ||
		(pll_fvco > cConf->pll_vco_fmax)) {
		LCDERR("%s: wrong pll_fvco value %dkHz\n", __func__, pll_fvco);
		return;
	}
	if (lcd_debug_print_flag == 2)
		LCDPR("%s pll_fvco=%d\n", __func__, pll_fvco);

	cConf->pll_fvco = pll_fvco;
	od_fb = 0; /* pll default */
	pll_fvco = pll_fvco / ((od_fb + 1) * 2);
	temp = cConf->fin * m / n;
	if (pll_fvco >= temp) {
		temp = pll_fvco - temp;
		offset = 0;
	} else {
		temp = temp - pll_fvco;
		offset = 1;
	}
	if (temp >= (2 * cConf->fin)) {
		LCDERR("%s: pll changing %dkHz is too much\n",
			__func__, temp);
		return;
	}
	frac = temp * cConf->pll_frac_range * n / cConf->fin;
	cConf->pll_frac = frac | (offset << 11);
	if (lcd_debug_print_flag)
		LCDPR("lcd_pll_frac_generate frac=%d\n", frac);
}

void lcd_clk_generate_parameter(struct lcd_config_s *pconf)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8B:
	case LCD_CHIP_M8M2:
		lcd_clk_generate_m8(pconf);
		break;
	case LCD_CHIP_G9TV:
	case LCD_CHIP_G9BB:
	case LCD_CHIP_GXTVBB:
		lcd_clk_generate_g9_gxtvbb(pconf);
		break;
	default:
		break;
	}
}

char *lcd_get_spread_spectrum(void)
{
	char *ss_str;
	int ss_level;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	ss_level = lcd_drv->lcd_config->lcd_timing.ss_level;
	ss_level = (ss_level >= clk_conf.ss_level_max) ? 0 : ss_level;
	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
		ss_str = lcd_pll_ss_table_m8[ss_level];
		break;
	case LCD_CHIP_M8B:
		ss_str = lcd_pll_ss_table_m8b[ss_level];
		break;
	case LCD_CHIP_G9TV:
		ss_str = lcd_pll_ss_table_g9tv[ss_level];
		break;
	case LCD_CHIP_G9BB:
		ss_str = lcd_pll_ss_table_g9bb[ss_level];
		break;
	case LCD_CHIP_GXTVBB:
		ss_str = lcd_pll_ss_table_gxtvbb[ss_level];
		break;
	default:
		ss_str = "unknown";
		break;
	}

	return ss_str;
}

void lcd_set_spread_spectrum(void)
{
	int ss_level;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	ss_level = lcd_drv->lcd_config->lcd_timing.ss_level;
	clk_conf.ss_level = (ss_level >= clk_conf.ss_level_max) ? 0 : ss_level;
	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
		lcd_set_pll_ss_m8(&clk_conf);
		break;
	case LCD_CHIP_M8B:
		lcd_set_pll_ss_m8b(&clk_conf);
		break;
	case LCD_CHIP_G9TV:
		lcd_set_pll_ss_g9tv(&clk_conf);
		break;
	case LCD_CHIP_G9BB:
		lcd_set_pll_ss_g9bb(&clk_conf);
		break;
	case LCD_CHIP_GXTVBB:
		lcd_set_pll_ss_gxtvbb(&clk_conf);
		break;
	default:
		break;
	}
}

/* for frame rate change */
void lcd_clk_update(struct lcd_config_s *pconf)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	LCDPR("%s\n", __func__);

	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
		lcd_pll_frac_generate_m8(pconf);
		lcd_update_pll_frac_m8(&clk_conf);
		break;
	case LCD_CHIP_M8B:
		lcd_pll_frac_generate_m8(pconf);
		lcd_update_pll_frac_m8b(&clk_conf);
		break;
	case LCD_CHIP_G9TV:
		lcd_pll_frac_generate_g9_gxtvbb(pconf);
		lcd_update_pll_frac_g9(&clk_conf);
		break;
	case LCD_CHIP_G9BB:
		lcd_pll_frac_generate_g9_gxtvbb(pconf);
		lcd_update_pll_frac_g9(&clk_conf);
		break;
	case LCD_CHIP_GXTVBB:
		lcd_pll_frac_generate_g9_gxtvbb(pconf);
		lcd_update_pll_frac_gxtvbb(&clk_conf);
		break;
	default:
		break;
	}
}

/* for timing change */
void lcd_clk_set(struct lcd_config_s *pconf)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
		lcd_set_pll_m8(&clk_conf);
		lcd_set_clk_div_m8(pconf->lcd_basic.lcd_type, &clk_conf);
		break;
	case LCD_CHIP_M8B:
		lcd_set_pll_m8b(&clk_conf);
		lcd_set_clk_div_m8(pconf->lcd_basic.lcd_type, &clk_conf);
		break;
	case LCD_CHIP_G9TV:
		lcd_set_pll_g9tv(&clk_conf);
		lcd_set_clk_div_g9_gxtvbb(&clk_conf);
		break;
	case LCD_CHIP_G9BB:
		lcd_set_pll_g9bb(&clk_conf);
		lcd_set_clk_div_g9_gxtvbb(&clk_conf);
		break;
	case LCD_CHIP_GXTVBB:
		lcd_set_pll_gxtvbb(&clk_conf);
		lcd_set_clk_div_g9_gxtvbb(&clk_conf);
		break;
	default:
		break;
	}
	lcd_set_vclk_crt(pconf->lcd_basic.lcd_type, &clk_conf);
}

void lcd_clk_disable(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	/* disable CTS_ENCL clk gate, new added in m8m2 */
	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8M2:
	case LCD_CHIP_M8B:
	case LCD_CHIP_G9TV:
	case LCD_CHIP_G9BB:
	case LCD_CHIP_GXTVBB:
		lcd_hiu_setb(HHI_VID_CLK_CNTL2, 0, ENCL_GATE_VCLK, 1);
		break;
	default:
		break;
	}

	/* close vclk2_div gate: 0x104b[4:0] */
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, 0, 5);
	lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, VCLK2_EN, 1);

	/* close vid2_pll gate: 0x104c[16] */
	lcd_hiu_setb(HHI_VIID_DIVIDER_CNTL, 0, DIV_CLK_IN_EN, 1);

	/* disable pll */
	switch (lcd_drv->chip_type) {
	case LCD_CHIP_M8:
	case LCD_CHIP_M8M2:
		/* disable pll_out mux */
		lcd_hiu_setb(HHI_VID2_PLL_CNTL5, 0, 23, 3);
		/* disable vid2_pll: 0x10e0[30] */
		lcd_hiu_setb(HHI_VID2_PLL_CNTL, 0, LCD_PLL_EN_M8, 1);
		break;
	case LCD_CHIP_M8B:
		/* disable vid_pll: 0x10c8[30] */
		lcd_hiu_setb(HHI_VID_PLL_CNTL, 0, LCD_PLL_EN_M8B, 1);
		break;
	case LCD_CHIP_G9TV:
		/* disable hdmi_pll: 0x10c8[30] */
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL, 0, LCD_PLL_EN_G9TV, 1);
		break;
	case LCD_CHIP_G9BB:
		/* disable hdmi_pll: 0x10c8[30] */
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL, 0, LCD_PLL_EN_G9BB, 1);
		break;
	case LCD_CHIP_GXTVBB:
		/* disable hdmi_pll: 0x10c8[30] */
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL, 0, LCD_PLL_EN_GXTVBB, 1);
		lcd_hiu_setb(HHI_HDMI_PLL_CNTL5, 0, 30, 1); /* bandgap */
		break;
	default:
		break;
	}
}

void lcd_clk_config_probe(void)
{
	lcd_clk_config_chip_init();
}
