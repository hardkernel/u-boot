
/*
 * drivers/vpu/aml_vpu_ctrl.h
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

#ifndef __VPU_CTRL_H__
#define __VPU_CTRL_H__
#include "aml_vpu.h"

/* #define LIMIT_VPU_CLK_LOW */

/* ************************************************ */
/* VPU frequency table, important. DO NOT modify!! */
/* ************************************************ */
/* fixed pll frequency */
#define FCLK_2000M    2000 /* unit: MHz */

/* GXBB */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_GXBB     7
#define CLK_LEVEL_MAX_GXBB     8
/* GXTVBB */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_GXTVBB   7
#define CLK_LEVEL_MAX_GXTVBB   8
/* GXL */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_GXL      7
#define CLK_LEVEL_MAX_GXL      8
/* GXM */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_GXM      7
#define CLK_LEVEL_MAX_GXM      8
/* TXL */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_TXL      7
#define CLK_LEVEL_MAX_TXL      8

/* TXLX */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_TXLX     7
#define CLK_LEVEL_MAX_TXLX     8

/* AXG */
/* freq max=250M, default=250M */
#define CLK_LEVEL_DFT_AXG      3
#define CLK_LEVEL_MAX_AXG      4

/* TXHD */
/* freq max=400M, default=400M */
#define CLK_LEVEL_DFT_TXHD     5
#define CLK_LEVEL_MAX_TXHD     6

/* G12A */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_G12A     7
#define CLK_LEVEL_MAX_G12A     8


/* vpu clk setting */
enum vpu_mux_e {
	FCLK_DIV4 = 0,
	FCLK_DIV3,
	FCLK_DIV5,
	FCLK_DIV7,
	MPLL_CLK1,
	VID_PLL_CLK,
	VID2_PLL_CLK,
	GPLL_CLK,
	FCLK_DIV_MAX,
};

static struct fclk_div_s fclk_div_table_gxb[] = {
	/* id,         mux,  div */
	{FCLK_DIV4,    0,    4},
	{FCLK_DIV3,    1,    3},
	{FCLK_DIV5,    2,    5},
	{FCLK_DIV7,    3,    7},
	{FCLK_DIV_MAX, 8,    1},
};

static struct fclk_div_s fclk_div_table_g12a[] = {
	/* id,         mux,  div */
	{FCLK_DIV3,    0,    3},
	{FCLK_DIV4,    1,    4},
	{FCLK_DIV5,    2,    5},
	{FCLK_DIV7,    3,    7},
	{FCLK_DIV_MAX, 8,    1},
};

static struct vpu_clk_s vpu_clk_table[] = {
	/* frequency   clk_mux       div */
	{100000000,    FCLK_DIV5,    3}, /* 0 */
	{166667000,    FCLK_DIV3,    3}, /* 1 */
	{200000000,    FCLK_DIV5,    1}, /* 2 */
	{250000000,    FCLK_DIV4,    1}, /* 3 */
	{333333000,    FCLK_DIV3,    1}, /* 4 */
	{400000000,    FCLK_DIV5,    0}, /* 5 */
	{500000000,    FCLK_DIV4,    0}, /* 6 */
	{666667000,    FCLK_DIV3,    0}, /* 7 */
	{696000000,    GPLL_CLK,     0}, /* 8 */ /* invalid */
	{850000000,    GPLL_CLK,     0}, /* 9 */ /* invalid */
};

/* ******************************************************* */
/*              VPU memory power down table                */
/* ******************************************************* */
static struct vpu_ctrl_s vpu_mem_pd_gxb[] = {
	/* reg,                val, bit, len */
	{HHI_VPU_MEM_PD_REG0,  1,   0,   32},
	{HHI_VPU_MEM_PD_REG1,  1,   0,   32},
	{VPU_REG_END,          0,   0,    0},
};

static struct vpu_ctrl_s vpu_mem_pd_axg[] = {
	/* reg,                val, bit, len */
	{HHI_VPU_MEM_PD_REG0,  1,   0,   32},
	{VPU_REG_END,          0,   0,    0},
};

static struct vpu_ctrl_s vpu_mem_pd_txhd[] = {
	/* reg,               val, bit, len */
	{HHI_VPU_MEM_PD_REG0, 1,   0,   32},
	{HHI_VPU_MEM_PD_REG1, 1,   0,   32},
	{HHI_VPU_MEM_PD_REG2, 1,   2,    2}, /* tcon memory */
	{VPU_REG_END,         0,   0,    0},
};

static struct vpu_ctrl_s vpu_mem_pd_g12a[] = {
	/* reg,               val, bit, len */
	{HHI_VPU_MEM_PD_REG0, 1,   0,   32},
	{HHI_VPU_MEM_PD_REG1, 1,   0,   32},
	{HHI_VPU_MEM_PD_REG2, 1,   0,    2},
	{HHI_VPU_MEM_PD_REG2, 1,   4,   14},
	{HHI_VPU_MEM_PD_REG2, 1,  30,    2},
	{VPU_REG_END,         0,   0,    0},
};

static struct vpu_ctrl_s vpu_mem_pd_tl1[] = {
	/* reg,               val, bit, len */
	{HHI_VPU_MEM_PD_REG0, 1,   0,   32},
	{HHI_VPU_MEM_PD_REG1, 1,   0,   32},
	{HHI_VPU_MEM_PD_REG2, 1,   0,   32},
	{HHI_VPU_MEM_PD_REG3, 1,   0,   32},
	{HHI_VPU_MEM_PD_REG4, 1,   0,    4},
	{VPU_REG_END,         0,   0,    0},
};

/* ******************************************************* */
/*              VPU_HDMI ISO                */
/* ******************************************************* */
static struct vpu_ctrl_s vpu_hdmi_iso_gxb[] = {
	/* reg,                val, bit, len */
	{AO_RTI_GEN_PWR_SLEEP0,  1,   9,   1},
	{VPU_REG_END,            0,   0,   0},
};

static struct vpu_ctrl_s vpu_hdmi_iso_sm1[] = {
	/* reg,                val, bit, len */
	{AO_RTI_GEN_PWR_ISO0,    1,   8,   1},
	{VPU_REG_END,            0,   0,   0},
};

/* ******************************************************* */
/*                 VPU module init table                 */
/* ******************************************************* */
static struct vpu_ctrl_s vpu_module_init_gxm[] = {
	/* reg,                     val,        bit, len */
	{DOLBY_CORE1_CLKGATE_CTRL,  0x55555555, 0,   32},
	{DOLBY_CORE2A_CLKGATE_CTRL, 0x55555555, 0,   32},
	{DOLBY_CORE3_CLKGATE_CTRL,  0x55555555, 0,   32},
	{VPU_REG_END,               0,          0,   0},
};

static struct vpu_ctrl_s vpu_module_init_txlx[] = {
	/* reg,                     val, bit, len */
	{DOLBY_TV_CLKGATE_CTRL,     1,   10,  2},
	{DOLBY_TV_CLKGATE_CTRL,     1,   2,   2},
	{DOLBY_TV_CLKGATE_CTRL,     1,   4,   2},
	{DOLBY_CORE2A_CLKGATE_CTRL, 1,   10,  2},
	{DOLBY_CORE2A_CLKGATE_CTRL, 1,   2,   2},
	{DOLBY_CORE2A_CLKGATE_CTRL, 1,   4,   2},
	{DOLBY_CORE3_CLKGATE_CTRL,  0,   1,   1},
	{DOLBY_CORE3_CLKGATE_CTRL,  1,   2,   2},
	{VPU_REG_END,               0,   0,   0},
};

/* ******************************************************* */
/*                 VPU reset table                    */
/* ******************************************************* */
static struct vpu_reset_s vpu_reset_gx[] = {
	/* reg,        mask */
	{RESET0_LEVEL, ((1<<5) | (1<<10) | (1<<19) | (1<<13))},
	{RESET1_LEVEL, (1<<5)},
	{RESET2_LEVEL, (1<<15)},
	{RESET4_LEVEL, ((1<<6) | (1<<7) | (1<<13) | (1<<5) | (1<<9) | (1<<4) | (1<<12))},
	{RESET7_LEVEL, (1<<7)},
	{VPU_REG_END,  0},
};

static struct vpu_reset_s vpu_reset_txhd[] = {
	/* reg,        mask */
	{RESET0_LEVEL, ((1<<5) | (1<<10) | (1<<19) | (1<<13))},
	{RESET1_LEVEL, (1<<5)},
	{RESET2_LEVEL, (1<<15)},
	{RESET4_LEVEL, ((1<<6) | (1<<7) | (1<<13) | (1<<5) | (1<<9) | (1<<4) | (1<<12))},
	{RESET7_LEVEL, ((1<<7) | (1<<12))}, /* bit[12]:tcon */
	{VPU_REG_END,  0},
};

static struct vpu_reset_s vpu_reset_tl1[] = {
	/* reg,        mask */
	{RESET0_LEVEL, ((1<<5) | (1<<10) | (1<<19) | (1<<13))},
	{RESET1_LEVEL, ((1<<5) | (1<<4))},
	{RESET2_LEVEL, (1<<15)},
	{RESET4_LEVEL, ((1<<6) | (1<<7) | (1<<13) | (1<<5) | (1<<9) | (1<<4) | (1<<12))},
	{RESET7_LEVEL, (1<<7)},
	{VPU_REG_END,  0},
};

#endif
