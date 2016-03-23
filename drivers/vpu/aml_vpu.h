
/*
 * drivers/vpu/aml_vpu.h
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

#ifndef __VPU_PARA_H__
#define __VPU_PARA_H__

//#define VPU_DEBUG_PRINT
#define VPUPR(fmt, args...)     printf("vpu: "fmt"", ## args)
#define VPUERR(fmt, args...)    printf("vpu: error: "fmt"", ## args)

enum vpu_chip_e {
	VPU_CHIP_M8 = 0,
	VPU_CHIP_M8B,
	VPU_CHIP_M8M2,
	VPU_CHIP_G9TV,
	VPU_CHIP_G9BB,
	VPU_CHIP_GXBB,
	VPU_CHIP_GXTVBB,
	VPU_CHIP_GXL,
	VPU_CHIP_MAX,
};

/*
static char *vpu_chip_name[] = {
	"m8",
	"m8baby",
	"m8m2",
	"g9tv",
	"g9baby",
	"gxbaby",
	"gxtvbaby",
	"invalid",
};
*/

struct vpu_conf_s {
	unsigned int     clk_level_dft;
	unsigned int     clk_level_max;
	unsigned int     clk_level;
	unsigned int     fclk_type;
};

/* #define LIMIT_VPU_CLK_LOW */

/* ************************************************ */
/* VPU frequency table, important. DO NOT modify!! */
/* ************************************************ */
/* fixed pll frequency */
enum fclk_type_e {
	FCLK_2550M = 0,
	FCLK_2000M,
	FCLK_MAX,
};
static unsigned int fclk_table[] = { /* unit: MHz */
	2550,
	2000,
};

/* M8: */
/* freq Max=364M, default=255M */
#define CLK_LEVEL_DFT_M8       3
#define CLK_LEVEL_MAX_M8       5
#define FCLK_TYPE_M8           FCLK_2550M
/* M8M2: */
/* freq Max=364M, default=255M */
#define CLK_LEVEL_DFT_M8M2     3
#define CLK_LEVEL_MAX_M8M2     5
#define FCLK_TYPE_M8M2         FCLK_2550M
/* M8baby */
/* freq max=212MHz, default=212MHz. */
#define CLK_LEVEL_DFT_M8B      2
#define CLK_LEVEL_MAX_M8B      3
#define FCLK_TYPE_M8B          FCLK_2550M
/* G9TV */
/* freq max=696M, default=637M */
#define CLK_LEVEL_DFT_G9TV     7
#define CLK_LEVEL_MAX_G9TV     9
#define FCLK_TYPE_G9TV         FCLK_2550M
/* G9BB */
/* freq max=212M, default=212M */
#define CLK_LEVEL_DFT_G9BB     2
#define CLK_LEVEL_MAX_G9BB     3
#define FCLK_TYPE_G9BB         FCLK_2550M
/* GXBB */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_GXBB     7
#define CLK_LEVEL_MAX_GXBB     8
#define FCLK_TYPE_GXBB         FCLK_2000M
/* GXTVBB */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_GXTVBB     7
#define CLK_LEVEL_MAX_GTVXBB     8
#define FCLK_TYPE_GXTVBB         FCLK_2000M
/* GXL */
/* freq max=666M, default=666M */
#define CLK_LEVEL_DFT_GXL     7
#define CLK_LEVEL_MAX_GXL     8
#define FCLK_TYPE_GXL         FCLK_2000M

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
};

static unsigned int fclk_div_table[] = {
	4, /* mux 0 */
	3, /* mux 1 */
	5, /* mux 2 */
	7, /* mux 3 */
	2, /* invalid */
};

static unsigned int vpu_clk_table[2][12][3] = {/* compatible for all chip */
	{ /* m8, m8m2, g9tv, g9bb, fpll=2550M */
		/* frequency   clk_mux       div */
		{106250000,    FCLK_DIV3,    7}, /* 0 */
		{159375000,    FCLK_DIV4,    3}, /* 1 */
		{212500000,    FCLK_DIV3,    3}, /* 2 */
		{255000000,    FCLK_DIV5,    1}, /* 3 */
		{364300000,    FCLK_DIV7,    0}, /* 4 */ /* M8M2 use gp_pll */
		{425000000,    FCLK_DIV3,    1}, /* 5 */
		{510000000,    FCLK_DIV5,    0}, /* 6 */
		{637500000,    FCLK_DIV4,    0}, /* 7 */
		{696000000,    GPLL_CLK,     0}, /* 8 */ /* G9TV use gp1_pll */
		{850000000,    FCLK_DIV3,    0}, /* 9 */
	},
	{ /* gxbb, gxtvbb, fpll=2000M */
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
	},
};

/* ************************************************ */
/* extern function */
/* ************************************************ */
extern void udelay(unsigned long usec);
extern int printf(const char *fmt, ...);
/* ************************************************ */

#endif
