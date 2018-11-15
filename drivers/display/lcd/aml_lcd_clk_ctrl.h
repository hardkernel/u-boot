/*
 * drivers/display/lcd/aml_lcd_clk_ctrl.h
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

#ifndef _LCD_CLK_CONFIG_CTRL_H
#define _LCD_CLK_CONFIG_CTRL_H

#include "aml_lcd_reg.h"
#include "aml_lcd_clk_config.h"

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
#define PLL_OD_FB_GXTVBB            0
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


/************** GXL **************** */
/* ******** register bit ******** */
/* PLL_CNTL 0x10c8 */
#define LCD_PLL_LOCK_GXL            31
#define LCD_PLL_EN_GXL              30
#define LCD_PLL_RST_GXL             28
#define LCD_PLL_N_GXL               9
#define LCD_PLL_M_GXL               0

#define LCD_PLL_OD3_GXL             19
#define LCD_PLL_OD2_GXL             23
#define LCD_PLL_OD1_GXL             21

/* ******** frequency limit (unit: kHz) ******** */
#define PLL_OD_FB_GXL               1
#define PLL_M_MIN_GXL               2
#define PLL_M_MAX_GXL               511
#define PLL_N_MIN_GXL               1
#define PLL_N_MAX_GXL               1
#define PLL_FRAC_RANGE_GXL          (1 << 10)
#define PLL_OD_SEL_MAX_GXL          3
#define PLL_FREF_MIN_GXL            (5 * 1000)
#define PLL_FREF_MAX_GXL            (25 * 1000)
#define PLL_VCO_MIN_GXL             (3000 * 1000)
#define PLL_VCO_MAX_GXL             (6000 * 1000)

/* video */
#define CLK_DIV_IN_MAX_GXL          (3100 * 1000)
#define CRT_VID_CLK_IN_MAX_GXL      (3100 * 1000)
#define ENCL_CLK_IN_MAX_GXL         (620 * 1000)

/*******  TXL ********************* */
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
#define PLL_OD_FB_TXL               1
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

/* **********************************
 * TXLX
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL 0x10c8 */
#define LCD_PLL_LOCK_TXLX            31
#define LCD_PLL_EN_TXLX              30
#define LCD_PLL_RST_TXLX             28
#define LCD_PLL_N_TXLX               9
#define LCD_PLL_M_TXLX               0

#define LCD_PLL_OD3_TXLX             19
#define LCD_PLL_OD2_TXLX             23
#define LCD_PLL_OD1_TXLX             21

/* ******** frequency limit (unit: kHz) ******** */
#define PLL_OD_FB_TXLX               0
#define PLL_M_MIN_TXLX               2
#define PLL_M_MAX_TXLX               511
#define PLL_N_MIN_TXLX               1
#define PLL_N_MAX_TXLX               1
#define PLL_FRAC_RANGE_TXLX          (1 << 10)
#define PLL_OD_SEL_MAX_TXLX          3
#define PLL_FREF_MIN_TXLX            (5 * 1000)
#define PLL_FREF_MAX_TXLX            (25 * 1000)
#define PLL_VCO_MIN_TXLX             (3000 * 1000)
#define PLL_VCO_MAX_TXLX             (6000 * 1000)

/* video */
#define CLK_DIV_IN_MAX_TXLX          (3100 * 1000)
#define CRT_VID_CLK_IN_MAX_TXLX      (3100 * 1000)
#define ENCL_CLK_IN_MAX_TXLX         (620 * 1000)

/* AXG */
/* ******** register bit ******** */
/* PLL_CNTL */
#define LCD_PLL_LOCK_AXG            31
#define LCD_PLL_EN_AXG              30
#define LCD_PLL_RST_AXG             29
#define LCD_PLL_OD_AXG              16
#define LCD_PLL_N_AXG               9
#define LCD_PLL_M_AXG               0

/* ******** frequency limit (unit: kHz) ******** */
#define PLL_OD_FB_AXG               0
#define PLL_M_MIN_AXG               2
#define PLL_M_MAX_AXG               511
#define PLL_N_MIN_AXG               1
#define PLL_N_MAX_AXG               1
#define PLL_FRAC_RANGE_AXG          (1 << 10)
#define PLL_OD_SEL_MAX_AXG          3
#define PLL_FREF_MIN_AXG            (5 * 1000)
#define PLL_FREF_MAX_AXG            (25 * 1000)
#define PLL_VCO_MIN_AXG             (960 * 1000)
#define PLL_VCO_MAX_AXG             (1920 * 1000)

/* video */
#define CRT_VID_CLK_IN_MAX_AXG      (1920 * 1000)
#define ENCL_CLK_IN_MAX_AXG         (200 * 1000)

/* **********************************
 * TXHD
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL 0x10c8 */
#define LCD_PLL_LOCK_TXHD            31
#define LCD_PLL_EN_TXHD              30
#define LCD_PLL_RST_TXHD             28
#define LCD_PLL_N_TXHD               9
#define LCD_PLL_M_TXHD               0

#define LCD_PLL_OD3_TXHD             19
#define LCD_PLL_OD2_TXHD             23
#define LCD_PLL_OD1_TXHD             21

/* ******** frequency limit (unit: kHz) ******** */
#define PLL_OD_FB_TXHD               0
#define PLL_M_MIN_TXHD               2
#define PLL_M_MAX_TXHD               511
#define PLL_N_MIN_TXHD               1
#define PLL_N_MAX_TXHD               1
#define PLL_FRAC_RANGE_TXHD          (1 << 10)
#define PLL_OD_SEL_MAX_TXHD          3
#define PLL_FREF_MIN_TXHD            (5 * 1000)
#define PLL_FREF_MAX_TXHD            (25 * 1000)
#define PLL_VCO_MIN_TXHD             (3000 * 1000)
#define PLL_VCO_MAX_TXHD             (6000 * 1000)

/* video */
#define CLK_DIV_IN_MAX_TXHD          (3100 * 1000)
#define CRT_VID_CLK_IN_MAX_TXHD      (3100 * 1000)
#define ENCL_CLK_IN_MAX_TXHD         (400 * 1000)

/* G12A */
/* ******** register bit ******** */
/* PLL_CNTL bit: GP0 */
#define LCD_PLL_LOCK_GP0_G12A        31
#define LCD_PLL_EN_GP0_G12A          28
#define LCD_PLL_RST_GP0_G12A         29
#define LCD_PLL_OD_GP0_G12A          16
#define LCD_PLL_N_GP0_G12A           10
#define LCD_PLL_M_GP0_G12A           0

/* ******** frequency limit (unit: kHz) ******** */
#define PLL_OD_FB_GP0_G12A           0
#define PLL_FRAC_RANGE_GP0_G12A      (1 << 17)
#define PLL_OD_SEL_MAX_GP0_G12A      5
#define PLL_VCO_MIN_GP0_G12A         (3000 * 1000)
#define PLL_VCO_MAX_GP0_G12A         (6000 * 1000)

/* PLL_CNTL bit: hpll */
#define LCD_PLL_LOCK_HPLL_G12A       31
#define LCD_PLL_EN_HPLL_G12A         28
#define LCD_PLL_RST_HPLL_G12A        29
#define LCD_PLL_N_HPLL_G12A          10
#define LCD_PLL_M_HPLL_G12A          0

#define LCD_PLL_OD3_HPLL_G12A        20
#define LCD_PLL_OD2_HPLL_G12A        18
#define LCD_PLL_OD1_HPLL_G12A        16

/* ******** frequency limit (unit: kHz) ******** */
#define PLL_OD_FB_HPLL_G12A          0
#define PLL_FRAC_RANGE_HPLL_G12A     (1 << 17)
#define PLL_OD_SEL_MAX_HPLL_G12A     3
#define PLL_VCO_MIN_HPLL_G12A        (3000 * 1000)
#define PLL_VCO_MAX_HPLL_G12A        (6000 * 1000)

/* video */
#define PLL_M_MIN_G12A               2
#define PLL_M_MAX_G12A               511
#define PLL_N_MIN_G12A               1
#define PLL_N_MAX_G12A               1
#define PLL_FREF_MIN_G12A            (5 * 1000)
#define PLL_FREF_MAX_G12A            (25 * 1000)
#define CRT_VID_CLK_IN_MAX_G12A      (6000 * 1000)
#define ENCL_CLK_IN_MAX_G12A         (200 * 1000)

/* **********************************
 * TL1
 * ********************************** */
/* ******** register bit ******** */
/* PLL_CNTL 0x20 */
#define LCD_PLL_LOCK_TL1             31
#define LCD_PLL_EN_TL1               28
#define LCD_PLL_RST_TL1              29
#define LCD_PLL_N_TL1                10
#define LCD_PLL_M_TL1                0

#define LCD_PLL_OD3_TL1              19
#define LCD_PLL_OD2_TL1              23
#define LCD_PLL_OD1_TL1              21

/* ******** frequency limit (unit: kHz) ******** */
#define PLL_OD_FB_TL1                0
#define PLL_M_MIN_TL1                2
#define PLL_M_MAX_TL1                511
#define PLL_N_MIN_TL1                1
#define PLL_N_MAX_TL1                1
#define PLL_FRAC_RANGE_TL1           (1 << 17)
#define PLL_OD_SEL_MAX_TL1           3
#define PLL_FREF_MIN_TL1             (5 * 1000)
#define PLL_FREF_MAX_TL1             (25 * 1000)
#define PLL_VCO_MIN_TL1              (3000 * 1000)
#define PLL_VCO_MAX_TL1              (6000 * 1000)

/* video */
#define CLK_DIV_IN_MAX_TL1           (3100 * 1000)
#define CRT_VID_CLK_IN_MAX_TL1       (3100 * 1000)
#define ENCL_CLK_IN_MAX_TL1          (750 * 1000)


/* **********************************
 * Spread Spectrum
 * **********************************
 */
#define LCD_SS_STEP_BASE            500 /* ppm */

#define SS_LEVEL_MAX_GXL            0
#define SS_LEVEL_MAX_AXG            0
#define SS_LEVEL_MAX_GP0_G12A       0
#define SS_LEVEL_MAX_HPLL_G12A      0

#define SS_LEVEL_MAX_GXTVBB         5
static char *lcd_pll_ss_table_gxtvbb[] = {
	"0, disable",
	"1, +/-0.3%",
	"2, +/-0.5%",
	"3, +/-0.9%",
	"4, +/-1.2%",
};

#define SS_LEVEL_MAX_TXL            5
static char *lcd_pll_ss_table_txl[] = {
	"0, disable",
	"1, +/-0.3%",
	"2, +/-0.4%",
	"3, +/-0.9%",
	"4, +/-1.2%",
};

#define SS_LEVEL_MAX_TXLX           6
static char *lcd_pll_ss_table_txlx[] = {
	"0, disable",
	"1, +/-0.3%",
	"2, +/-0.5%",
	"3, +/-1.0%",
	"4, +/-1.6%",
	"5, +/-3.0%",
};

#define SS_LEVEL_MAX_TXHD           6
static char *lcd_pll_ss_table_txhd[] = {
	"0, disable",
	"1, +/-0.3%",
	"2, +/-0.5%",
	"3, +/-1.0%",
	"4, +/-2.0%",
	"5, +/-3.0%",
};

#define SS_LEVEL_MAX_TL1            0


static unsigned int pll_ss_reg_gxtvbb_high[][4] = {
	/* cntl3     cntl4       cntl5       cntl6 */
	{0x12dc5081, 0x801da72c, 0x71486980, 0x00002a55}, /* disable */
	{0x12dc5080, 0xb01da72c, 0x51486980, 0x00082a55}, /* 1 */
	{0x12dc5080, 0xa85da72c, 0x51486980, 0x00082a55}, /* 2 */
	{0x12dc5080, 0xb09da72c, 0x51486980, 0x00082a55}, /* 3 */
	{0x12dc5080, 0xb0dda72c, 0x51486980, 0x00082a55}, /* 4 */
};

static unsigned int pll_ss_reg_gxtvbb_low[][4] = {
	/* cntl3     cntl4       cntl5       cntl6 */
	{0x0d5c5091, 0x801da72c, 0x71486980, 0x00002a55}, /* disable */
	{0x0d1c5090, 0xb01da72c, 0x51486980, 0x00082a55}, /* 1 */
	{0x0d1c5090, 0xa85da72c, 0x51486980, 0x00082a55}, /* 2 */
	{0x0d1c5090, 0xb09da72c, 0x51486980, 0x00082a55}, /* 3 */
	{0x0d1c5090, 0xb0dda72c, 0x51486980, 0x00082a55}, /* 4 */
};

static unsigned int pll_ss_reg_txl[][2] = {
	/* dep_sel,  str_m  */
	{ 0,          0}, /* disable */
	{12,          0}, /* 1: +/-0.3% */
	{ 8,          1}, /* 2: +/-0.4% */
	{12,          2}, /* 3: +/-0.9% */
	{12,          3}, /* 4: +/-1.2% */
};

static unsigned int pll_ss_reg_txlx[][2] = {
	/* dep_sel,  str_m  */
	{ 0,          0}, /* disable */
	{12,          0}, /* 1: +/-0.3% */
	{10,          2}, /* 2: +/-0.5% */
	{10,          4}, /* 3: +/-1.0% */
	{ 8,          8}, /* 4: +/-1.6% */
	{12,         10}, /* 5: +/-3.0% */
};

static unsigned int pll_ss_reg_txhd[][2] = {
	/* dep_sel,  str_m  */
	{ 0,          0}, /* disable */
	{ 6,          1}, /* 1: +/-0.3% */
	{10,          2}, /* 2: +/-0.5% */
	{10,          4}, /* 3: +/-1.0% */
	{10,          8}, /* 4: +/-2.0% */
	{12,         10}, /* 5: +/-3.0% */
};

/* **********************************
 * pll control
 * **********************************
 */
struct lcd_clk_ctrl_s pll_ctrl_table_gxtvbb[] = {
	/* flag             reg              bit                len*/
	{LCD_CLK_CTRL_EN,   HHI_HPLL_CNTL,   LCD_PLL_EN_GXTVBB,  1},
	{LCD_CLK_CTRL_EN,   HHI_HPLL_CNTL5,                 30,  1}, /* bandgap */
	{LCD_CLK_CTRL_FRAC, HHI_HPLL_CNTL2,                  0, 12},
	{LCD_CLK_CTRL_END,  LCD_CLK_REG_END,                 0,  0},
};

struct lcd_clk_ctrl_s pll_ctrl_table_txl[] = {
	/* flag             reg              bit             len*/
	{LCD_CLK_CTRL_EN,   HHI_HPLL_CNTL,   LCD_PLL_EN_TXL,  1},
	{LCD_CLK_CTRL_FRAC, HHI_HPLL_CNTL2,               0, 12},
	{LCD_CLK_CTRL_END,  LCD_CLK_REG_END,              0,  0},
};

struct lcd_clk_ctrl_s pll_ctrl_table_axg[] = {
	/* flag             reg               bit              len*/
	{LCD_CLK_CTRL_EN,   HHI_GP0_PLL_CNTL, LCD_PLL_EN_AXG,   1},
	{LCD_CLK_CTRL_FRAC, HHI_GP0_PLL_CNTL1,              0, 12},
	{LCD_CLK_CTRL_END,  LCD_CLK_REG_END,                0,  0},
};

struct lcd_clk_ctrl_s pll_ctrl_table_txhd[] = {
	/* flag             reg              bit              len*/
	{LCD_CLK_CTRL_EN,   HHI_HPLL_CNTL,   LCD_PLL_EN_TXHD,  1},
	{LCD_CLK_CTRL_FRAC, HHI_HPLL_CNTL2,                0, 12},
	{LCD_CLK_CTRL_END,  LCD_CLK_REG_END,               0,  0},
};

struct lcd_clk_ctrl_s pll_ctrl_table_g12a_path0[] = {
	/* flag             reg                 bit                   len*/
	{LCD_CLK_CTRL_EN,   HHI_HDMI_PLL_CNTL0, LCD_PLL_EN_HPLL_G12A,  1},
	{LCD_CLK_CTRL_FRAC, HHI_HDMI_PLL_CNTL1,                    0, 19},
	{LCD_CLK_CTRL_END,  LCD_CLK_REG_END,                       0,  0},
};

struct lcd_clk_ctrl_s pll_ctrl_table_g12a_path1[] = {
	/* flag             reg                bit                  len*/
	{LCD_CLK_CTRL_EN,   HHI_GP0_PLL_CNTL0, LCD_PLL_EN_GP0_G12A,  1},
	{LCD_CLK_CTRL_FRAC, HHI_GP0_PLL_CNTL1,                   0, 19},
	{LCD_CLK_CTRL_END,  LCD_CLK_REG_END,                     0,  0},
};

struct lcd_clk_ctrl_s pll_ctrl_table_tl1[] = {
	/* flag             reg                 bit              len*/
	{LCD_CLK_CTRL_EN,   HHI_TCON_PLL_CNTL0, LCD_PLL_EN_TL1,   1},
	{LCD_CLK_CTRL_FRAC, HHI_TCON_PLL_CNTL1,               0, 17},
	{LCD_CLK_CTRL_END,  LCD_CLK_REG_END,                  0,  0},
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

static const unsigned int od_fb_table[2] = {1, 2};

static const unsigned int od_table[6] = {1, 2, 4, 8, 16, 32};

static const unsigned int pi_div_table[2] = {2, 4};

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

#endif
