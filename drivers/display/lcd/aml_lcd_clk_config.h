/*
 * drivers/display/lcd/aml_lcd_clk_config.h
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

#ifndef _LCD_CLK_CONFIG_H
#define _LCD_CLK_CONFIG_H

#include <linux/types.h>
#include <amlogic/aml_lcd.h>

/* **********************************
 * clk config
 * ********************************** */
#define LCD_CLK_CTRL_EN      0
#define LCD_CLK_CTRL_RST     1
#define LCD_CLK_CTRL_FRAC    2
#define LCD_CLK_CTRL_END     0xffff

#define LCD_CLK_REG_END      0xffff
#define LCD_CLK_CTRL_CNT_MAX 10
struct lcd_clk_ctrl_s {
	unsigned int flag;
	unsigned int reg;
	unsigned int bit;
	unsigned int len;
};

struct lcd_clk_data_s {
	/* clk path node parameters */
	unsigned int ss_level_max;
	unsigned int pll_od_fb;
	unsigned int pll_m_max;
	unsigned int pll_m_min;
	unsigned int pll_n_max;
	unsigned int pll_n_min;
	unsigned int pll_frac_range;
	unsigned int pll_od_sel_max;
	unsigned int pll_ref_fmax;
	unsigned int pll_ref_fmin;
	unsigned int pll_vco_fmax;
	unsigned int pll_vco_fmin;
	unsigned int pll_out_fmax;
	unsigned int pll_out_fmin;
	unsigned int div_in_fmax;
	unsigned int div_out_fmax;
	unsigned int xd_out_fmax;

	unsigned char clk_path_valid;
	unsigned char vclk_sel;
	struct lcd_clk_ctrl_s *pll_ctrl_table;
	char **pll_ss_table;

	void (*clk_generate_parameter)(struct lcd_config_s *pconf);
	void (*pll_frac_generate)(struct lcd_config_s *pconf);
	void (*set_spread_spectrum)(unsigned int ss_level);
	void (*clk_set)(struct lcd_config_s *pconf);
	void (*clk_config_init_print)(void);
	void (*clk_config_print)(void);
};

struct lcd_clk_config_s { /* unit: kHz */
	/* IN-OUT parameters */
	unsigned int fin;
	unsigned int fout;

	/* pll parameters */
	unsigned int pll_mode; /* txl */
	unsigned int pll_od_fb;
	unsigned int pll_m;
	unsigned int pll_n;
	unsigned int pll_fvco;
	unsigned int pll_od1_sel;
	unsigned int pll_od2_sel;
	unsigned int pll_od3_sel;
	unsigned int pll_pi_div_sel; /* for tcon */
	unsigned int pll_level;
	unsigned int pll_frac;
	unsigned int pll_fout;
	unsigned int ss_level;
	unsigned int div_sel;
	unsigned int xd;
	unsigned int div_sel_max;
	unsigned int xd_max;
	unsigned int err_fmin;

	struct lcd_clk_data_s *data;
};

/* ******** api ******** */
extern struct lcd_clk_config_s *get_lcd_clk_config(void);
extern void lcd_clk_config_print(void);

extern char *lcd_get_spread_spectrum(void);
extern void lcd_set_spread_spectrum(unsigned int ss_level);
extern void lcd_clk_update(struct lcd_config_s *pconf);
extern void lcd_clk_set(struct lcd_config_s *pconf);
extern void lcd_clk_disable(void);

extern void lcd_clk_generate_parameter(struct lcd_config_s *pconf);
extern void lcd_clk_config_probe(void);

#endif
