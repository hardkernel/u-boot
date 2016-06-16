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
struct lcd_clk_config_s { /* unit: kHz */
	/* IN-OUT parameters */
	unsigned int fin;
	unsigned int fout;

	/* pll parameters */
	unsigned int pll_m;
	unsigned int pll_n;
	unsigned int pll_fvco;
	unsigned int pll_od1_sel;
	unsigned int pll_od2_sel;
	unsigned int pll_od3_sel;
	unsigned int pll_level;
	unsigned int pll_frac;
	unsigned int pll_fout;
	unsigned int ss_level;
	unsigned int edp_div0;
	unsigned int edp_div1;
	unsigned int div_pre; /* m6, m8, m8b */
	unsigned int div_post; /* m6, m8, m8b */
	unsigned int div_sel; /* g9tv, g9bb, gxbb */
	unsigned int xd;

	/* clk path node parameters */
	unsigned int ss_level_max;
	unsigned int pll_m_max;
	unsigned int pll_m_min;
	unsigned int pll_n_max;
	unsigned int pll_n_min;
	unsigned int pll_frac_range;
	unsigned int pll_od_sel_max;
	unsigned int div_pre_sel_max; /* m6, m8, m8b */
	unsigned int div_post_sel_max; /* m6, m8, m8b */
	unsigned int div_sel_max; /* g9tv, g9bb, gxbb */
	unsigned int xd_max;
	unsigned int pll_ref_fmax;
	unsigned int pll_ref_fmin;
	unsigned int pll_vco_fmax;
	unsigned int pll_vco_fmin;
	unsigned int pll_out_fmax;
	unsigned int pll_out_fmin;
	unsigned int div_pre_in_fmax; /* m6, m8, m8b */
	unsigned int div_pre_out_fmax; /* m6, m8, m8b */
	unsigned int div_post_out_fmax; /* m6, m8, m8b */
	unsigned int div_in_fmax; /* g9tv, g9bb, gxbb */
	unsigned int div_out_fmax; /* g9tv, g9bb, gxbb */
	unsigned int xd_out_fmax;
	unsigned int err_fmin;
};

/* **********************************
 * pll & clk parameter
 * ********************************** */
/* ******** clk calculation ******** */
#define PLL_WAIT_LOCK_CNT           200
 /* frequency unit: kHz */
#define FIN_FREQ                    (24 * 1000)
/* clk max error */
#define MAX_ERROR                   (2 * 1000)

/* ******** register bit ******** */
/* divider */
#define CRT_VID_DIV_MAX             255

#define DIV_PRE_SEL_MAX             6
#define EDP_DIV0_SEL_MAX            15
#define EDP_DIV1_SEL_MAX            8

/* g9tv, g9bb, gxbb divider */
#define CLK_DIV_I2O     0
#define CLK_DIV_O2I     1
enum div_sel_e {
	CLK_DIV_SEL_1 = 0,
	CLK_DIV_SEL_2,    /* 1 */
	CLK_DIV_SEL_3,    /* 2 */
	CLK_DIV_SEL_3p5,  /* 3 */
	CLK_DIV_SEL_3p75, /* 4 */
	CLK_DIV_SEL_4,    /* 5 */
	CLK_DIV_SEL_5,    /* 6 */
	CLK_DIV_SEL_6,    /* 7 */
	CLK_DIV_SEL_6p25, /* 8 */
	CLK_DIV_SEL_7,    /* 9 */
	CLK_DIV_SEL_7p5,  /* 10 */
	CLK_DIV_SEL_12,   /* 11 */
	CLK_DIV_SEL_14,   /* 12 */
	CLK_DIV_SEL_15,   /* 13 */
	CLK_DIV_SEL_2p5,  /* 14 */
	CLK_DIV_SEL_MAX,
};


/* **********************************
 * M8
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL */
#define LCD_PLL_LOCK_M8             31
#define LCD_PLL_EN_M8               30
#define LCD_PLL_RST_M8              29
#define LCD_PLL_N_M8                24
#define LCD_PLL_OD_M8               9
#define LCD_PLL_M_M8                0

/* ******** frequency limit (unit: kHz) ******** */
/* pll */
#define SS_LEVEL_MAX_M8             5
#define PLL_M_MIN_M8                2
#define PLL_M_MAX_M8                511
#define PLL_N_MIN_M8                1
#define PLL_N_MAX_M8                1
#define PLL_FRAC_RANGE_M8           (1 << 12)
#define PLL_OD_SEL_MAX_M8           3
#define PLL_FREF_MIN_M8             (5 * 1000)
#define PLL_FREF_MAX_M8             (25 * 1000)
#define PLL_VCO_MIN_M8              (1200 * 1000)
#define PLL_VCO_MAX_M8              (3000 * 1000)

/* video */
#define DIV_PRE_CLK_IN_MAX_M8       (1500 * 1000)
#define DIV_POST_CLK_IN_MAX_M8      (1000 * 1000)
#define CRT_VID_CLK_IN_MAX_M8       (1300 * 1000)
#define ENCL_CLK_IN_MAX_M8          (333 * 1000)

/* **********************************
 * M8B
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL */
#define LCD_PLL_LOCK_M8B            31
#define LCD_PLL_EN_M8B              30
#define LCD_PLL_RST_M8B             29
#define LCD_PLL_OD_M8B              16
#define LCD_PLL_N_M8B               10
#define LCD_PLL_M_M8B               0

/* ******** frequency limit (unit: kHz) ******** */
/* pll */
#define SS_LEVEL_MAX_M8B            5
#define PLL_M_MIN_M8B               2
#define PLL_M_MAX_M8B               511
#define PLL_N_MIN_M8B               1
#define PLL_N_MAX_M8B               1
#define PLL_FRAC_RANGE_M8B          (1 << 12)
#define PLL_OD_SEL_MAX_M8B          3
#define PLL_FREF_MIN_M8B            (5 * 1000)
#define PLL_FREF_MAX_M8B            (25 * 1000)
#define PLL_VCO_MIN_M8B             (1200 * 1000)
#define PLL_VCO_MAX_M8B             (3000 * 1000)

/* video */
#define DIV_PRE_CLK_IN_MAX_M8B      (1500 * 1000)
#define DIV_POST_CLK_IN_MAX_M8B     (1000 * 1000)
#define CRT_VID_CLK_IN_MAX_M8B      (1300 * 1000)
#define ENCL_CLK_IN_MAX_M8B         (333 * 1000)

/* **********************************
 * G9TV
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL */
#define LCD_PLL_LOCK_G9TV           31
#define LCD_PLL_EN_G9TV             30
#define LCD_PLL_RST_G9TV            28
#define LCD_PLL_N_G9TV              9
#define LCD_PLL_M_G9TV              0

#define LCD_PLL_OD3_G9TV            18
#define LCD_PLL_OD2_G9TV            22
#define LCD_PLL_OD1_G9TV            16

/* ******** frequency limit (unit: kHz) ******** */
/* pll */
#define SS_LEVEL_MAX_G9TV           5
#define PLL_M_MIN_G9TV              2
#define PLL_M_MAX_G9TV              511
#define PLL_N_MIN_G9TV              1
#define PLL_N_MAX_G9TV              1
#define PLL_FRAC_RANGE_G9TV         (1 << 12)
#define PLL_OD_SEL_MAX_G9TV         3
#define PLL_FREF_MIN_G9TV           (5 * 1000)
#define PLL_FREF_MAX_G9TV           (25 * 1000)
#define PLL_VCO_MIN_G9TV            (3000 * 1000)
#define PLL_VCO_MAX_G9TV            (6000 * 1000)

/* video */
#define CLK_DIV_IN_MAX_G9TV         (3000 * 1000)
#define CRT_VID_CLK_IN_MAX_G9TV     (3000 * 1000)
#define ENCL_CLK_IN_MAX_G9TV        (600 * 1000)

/* **********************************
 * G9BB
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL */
#define LCD_PLL_LOCK_G9BB           31
#define LCD_PLL_EN_G9BB             30
#define LCD_PLL_RST_G9BB            28
#define LCD_PLL_N_G9BB              9
#define LCD_PLL_M_G9BB              0

#define LCD_PLL_OD3_G9BB            18
#define LCD_PLL_OD2_G9BB            22
#define LCD_PLL_OD1_G9BB            16

/* ******** frequency limit (unit: kHz) ******** */
/* pll */
#define SS_LEVEL_MAX_G9BB           3
#define PLL_M_MIN_G9BB              2
#define PLL_M_MAX_G9BB              511
#define PLL_N_MIN_G9BB              1
#define PLL_N_MAX_G9BB              1
#define PLL_FRAC_RANGE_G9BB         (1 << 12)
#define PLL_OD_SEL_MAX_G9BB         3
#define PLL_FREF_MIN_G9BB           (5 * 1000)
#define PLL_FREF_MAX_G9BB           (25 * 1000)
#define PLL_VCO_MIN_G9BB            (3000 * 1000)
#define PLL_VCO_MAX_G9BB            (6000 * 1000)

/* video */
#define CLK_DIV_IN_MAX_G9BB         (3000 * 1000)
#define CRT_VID_CLK_IN_MAX_G9BB     (3000 * 1000)
#define ENCL_CLK_IN_MAX_G9BB        (333 * 1000)

/* **********************************
 * GXTVBB
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL 0x10c8 */
#define LCD_PLL_LOCK_GXTVBB         31
#define LCD_PLL_EN_GXTVBB           30
#define LCD_PLL_RST_GXTVBB          28
#define LCD_PLL_N_GXTVBB            9
#define LCD_PLL_M_GXTVBB            0

#define LCD_PLL_OD3_GXTVBB          18
#define LCD_PLL_OD2_GXTVBB          22
#define LCD_PLL_OD1_GXTVBB          16

/* ******** frequency limit (unit: kHz) ******** */
/* pll */
#define SS_LEVEL_MAX_GXTVBB         5
#define PLL_M_MIN_GXTVBB            2
#define PLL_M_MAX_GXTVBB            511
#define PLL_N_MIN_GXTVBB            1
#define PLL_N_MAX_GXTVBB            1
#define PLL_FRAC_RANGE_GXTVBB       (1 << 10)
#define PLL_OD_SEL_MAX_GXTVBB       3
#define PLL_FREF_MIN_GXTVBB         (5 * 1000)
#define PLL_FREF_MAX_GXTVBB         (25 * 1000)
#define PLL_VCO_MIN_GXTVBB          (3000 * 1000)
#define PLL_VCO_MAX_GXTVBB          (6000 * 1000)

/* video */
#define CLK_DIV_IN_MAX_GXTVBB       (3100 * 1000)
#define CRT_VID_CLK_IN_MAX_GXTVBB   (3100 * 1000)
#define ENCL_CLK_IN_MAX_GXTVBB      (620 * 1000)

/* **********************************
 * TXL
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL 0x10c8 */
#define LCD_PLL_LOCK_TXL            31
#define LCD_PLL_EN_TXL              30
#define LCD_PLL_RST_TXL             28
#define LCD_PLL_N_TXL               9
#define LCD_PLL_M_TXL               0

#define LCD_PLL_OD3_TXL             19
#define LCD_PLL_OD2_TXL             23
#define LCD_PLL_OD1_TXL             21

/* ******** frequency limit (unit: kHz) ******** */
/* pll */
#define SS_LEVEL_MAX_TXL            5
#define PLL_M_MIN_TXL               2
#define PLL_M_MAX_TXL               511
#define PLL_N_MIN_TXL               1
#define PLL_N_MAX_TXL               1
#define PLL_FRAC_RANGE_TXL          (1 << 10)
#define PLL_OD_SEL_MAX_TXL          3
#define PLL_FREF_MIN_TXL            (5 * 1000)
#define PLL_FREF_MAX_TXL            (25 * 1000)
#define PLL_VCO_MIN_TXL             (3000 * 1000)
#define PLL_VCO_MAX_TXL             (6000 * 1000)

/* video */
#define CLK_DIV_IN_MAX_TXL          (3100 * 1000)
#define CRT_VID_CLK_IN_MAX_TXL      (3100 * 1000)
#define ENCL_CLK_IN_MAX_TXL         (620 * 1000)


extern struct lcd_clk_config_s *get_lcd_clk_config(void);
extern void lcd_clk_config_print(void);

extern char *lcd_get_spread_spectrum(void);
extern void lcd_set_spread_spectrum(void);
extern void lcd_clk_update(struct lcd_config_s *pconf);
extern void lcd_clk_set(struct lcd_config_s *pconf);
extern void lcd_clk_disable(void);

extern void lcd_clk_generate_parameter(struct lcd_config_s *pconf);
extern void lcd_clk_config_probe(void);

#endif
