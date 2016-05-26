
/*
 * drivers/vpp/aml_vpp.c
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

#include <asm/cpu_id.h>
#include <config.h>
#include <common.h>
#include <vpp.h>
#include "aml_vpp_reg.h"

#define VPP_PR(fmt, args...)     printf("vpp: "fmt"", ## args)

/* OSD csc defines */

enum vpp_matrix_sel_e {
	VPP_MATRIX_0 = 0,	/* OSD convert matrix - new from GXL */
	VPP_MATRIX_1,		/* vd1 matrix before post-blend */
	VPP_MATRIX_2,		/* post matrix */
	VPP_MATRIX_3,		/* xvycc matrix */
	VPP_MATRIX_4,		/* in video eotf - new from GXL */
	VPP_MATRIX_5,		/* in osd eotf - new from GXL */
	VPP_MATRIX_6		/* vd2 matrix before pre-blend */
};
#define NUM_MATRIX 6

/* matrix names */
#define VPP_MATRIX_OSD		VPP_MATRIX_0
#define VPP_MATRIX_VD1		VPP_MATRIX_1
#define VPP_MATRIX_POST		VPP_MATRIX_2
#define VPP_MATRIX_XVYCC	VPP_MATRIX_3
#define VPP_MATRIX_EOTF		VPP_MATRIX_4
#define VPP_MATRIX_OSD_EOTF	VPP_MATRIX_5
#define VPP_MATRIX_VD2		VPP_MATRIX_6

#define CSC_ON              1
#define CSC_OFF             0

enum vpp_lut_sel_e {
	VPP_LUT_OSD_EOTF = 0,
	VPP_LUT_OSD_OETF,
	VPP_LUT_EOTF,
	VPP_LUT_OETF
};
#define NUM_LUT 4

/* matrix registers */
struct matrix_s {
	u16 pre_offset[3];
	u16 matrix[3][3];
	u16 offset[3];
	u16 right_shift;
};

/* OSD csc defines end */

static void vpp_set_matrix_ycbcr2rgb(int vd1_or_vd2_or_post, int mode)
{
	//VPP_PR("%s: %d, %d\n", __func__, vd1_or_vd2_or_post, mode);

	if (vd1_or_vd2_or_post == 0) { //vd1
		vpp_reg_setb(VPP_MATRIX_CTRL, 1, 5, 1);
		vpp_reg_setb(VPP_MATRIX_CTRL, 1, 8, 2);
	} else if (vd1_or_vd2_or_post == 1) { //vd2
		vpp_reg_setb(VPP_MATRIX_CTRL, 1, 4, 1);
		vpp_reg_setb(VPP_MATRIX_CTRL, 2, 8, 2);
	} else {
		vpp_reg_setb(VPP_MATRIX_CTRL, 1, 0, 1);
		vpp_reg_setb(VPP_MATRIX_CTRL, 0, 8, 2);
		if (mode == 0)
			vpp_reg_setb(VPP_MATRIX_CTRL, 1, 1, 2);
		else if (mode == 1)
			vpp_reg_setb(VPP_MATRIX_CTRL, 0, 1, 2);
	}

	if (mode == 0) { /* 601 limit to RGB */
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0064C8FF);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET2, 0x006400C8);
		//1.164     0       1.596
		//1.164   -0.392    -0.813
		//1.164   2.017     0
		vpp_reg_write(VPP_MATRIX_COEF00_01, 0x04A80000);
		vpp_reg_write(VPP_MATRIX_COEF02_10, 0x066204A8);
		vpp_reg_write(VPP_MATRIX_COEF11_12, 0x1e701cbf);
		vpp_reg_write(VPP_MATRIX_COEF20_21, 0x04A80812);
		vpp_reg_write(VPP_MATRIX_COEF22, 0x00000000);
		vpp_reg_write(VPP_MATRIX_OFFSET0_1, 0x00000000);
		vpp_reg_write(VPP_MATRIX_OFFSET2, 0x00000000);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0FC00E00);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET2, 0x00000E00);
	} else if (mode == 1) { /* 601 limit to RGB  */
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0000E00);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET2, 0x0E00);
		//	1	0			1.402
		//	1	-0.34414	-0.71414
		//	1	1.772		0
		vpp_reg_write(VPP_MATRIX_COEF00_01, (0x400 << 16) |0);
		vpp_reg_write(VPP_MATRIX_COEF02_10, (0x59c << 16) |0x400);
		vpp_reg_write(VPP_MATRIX_COEF11_12, (0x1ea0 << 16) |0x1d24);
		vpp_reg_write(VPP_MATRIX_COEF20_21, (0x400 << 16) |0x718);
		vpp_reg_write(VPP_MATRIX_COEF22, 0x0);
		vpp_reg_write(VPP_MATRIX_OFFSET0_1, 0x0);
		vpp_reg_write(VPP_MATRIX_OFFSET2, 0x0);
	} else if (mode == 2) { /* 709F to RGB */
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0000E00);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET2, 0x0E00);
		//	1	0			1.402
		//	1	-0.34414	-0.71414
		//	1	1.772		0
		vpp_reg_write(VPP_MATRIX_COEF00_01, 0x04000000);
		vpp_reg_write(VPP_MATRIX_COEF02_10, 0x064D0400);
		vpp_reg_write(VPP_MATRIX_COEF11_12, 0x1F411E21);
		vpp_reg_write(VPP_MATRIX_COEF20_21, 0x0400076D);
		vpp_reg_write(VPP_MATRIX_COEF22, 0x0);
		vpp_reg_write(VPP_MATRIX_OFFSET0_1, 0x0);
		vpp_reg_write(VPP_MATRIX_OFFSET2, 0x0);
	} else if (mode == 3) { /* 709L to RGB */
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0FC00E00);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET2, 0x00000E00);
		/* ycbcr limit range, 709 to RGB */
		/* -16      1.164  0      1.793  0 */
		/* -128     1.164 -0.213 -0.534  0 */
		/* -128     1.164  2.115  0      0 */
		vpp_reg_write(VPP_MATRIX_COEF00_01, 0x04A80000);
		vpp_reg_write(VPP_MATRIX_COEF02_10, 0x072C04A8);
		vpp_reg_write(VPP_MATRIX_COEF11_12, 0x1F261DDD);
		vpp_reg_write(VPP_MATRIX_COEF20_21, 0x04A80876);
		vpp_reg_write(VPP_MATRIX_COEF22, 0x0);
		vpp_reg_write(VPP_MATRIX_OFFSET0_1, 0x0);
		vpp_reg_write(VPP_MATRIX_OFFSET2, 0x0);
	}
	vpp_reg_setb(VPP_MATRIX_CLIP, 0, 5, 3);
}

/***************************** gxl hdr ****************************/

#define EOTF_LUT_SIZE 33
static unsigned int osd_eotf_r_mapping[EOTF_LUT_SIZE] = {
	0x0000,	0x0200,	0x0400, 0x0600,
	0x0800, 0x0a00, 0x0c00, 0x0e00,
	0x1000, 0x1200, 0x1400, 0x1600,
	0x1800, 0x1a00, 0x1c00, 0x1e00,
	0x2000, 0x2200, 0x2400, 0x2600,
	0x2800, 0x2a00, 0x2c00, 0x2e00,
	0x3000, 0x3200, 0x3400, 0x3600,
	0x3800, 0x3a00, 0x3c00, 0x3e00,
	0x4000
};

static unsigned int osd_eotf_g_mapping[EOTF_LUT_SIZE] = {
	0x0000,	0x0200,	0x0400, 0x0600,
	0x0800, 0x0a00, 0x0c00, 0x0e00,
	0x1000, 0x1200, 0x1400, 0x1600,
	0x1800, 0x1a00, 0x1c00, 0x1e00,
	0x2000, 0x2200, 0x2400, 0x2600,
	0x2800, 0x2a00, 0x2c00, 0x2e00,
	0x3000, 0x3200, 0x3400, 0x3600,
	0x3800, 0x3a00, 0x3c00, 0x3e00,
	0x4000
};

static unsigned int osd_eotf_b_mapping[EOTF_LUT_SIZE] = {
	0x0000,	0x0200,	0x0400, 0x0600,
	0x0800, 0x0a00, 0x0c00, 0x0e00,
	0x1000, 0x1200, 0x1400, 0x1600,
	0x1800, 0x1a00, 0x1c00, 0x1e00,
	0x2000, 0x2200, 0x2400, 0x2600,
	0x2800, 0x2a00, 0x2c00, 0x2e00,
	0x3000, 0x3200, 0x3400, 0x3600,
	0x3800, 0x3a00, 0x3c00, 0x3e00,
	0x4000
};

static unsigned int video_eotf_r_mapping[EOTF_LUT_SIZE] = {
	0x0000,	0x0200,	0x0400, 0x0600,
	0x0800, 0x0a00, 0x0c00, 0x0e00,
	0x1000, 0x1200, 0x1400, 0x1600,
	0x1800, 0x1a00, 0x1c00, 0x1e00,
	0x2000, 0x2200, 0x2400, 0x2600,
	0x2800, 0x2a00, 0x2c00, 0x2e00,
	0x3000, 0x3200, 0x3400, 0x3600,
	0x3800, 0x3a00, 0x3c00, 0x3e00,
	0x4000
};

static unsigned int video_eotf_g_mapping[EOTF_LUT_SIZE] = {
	0x0000,	0x0200,	0x0400, 0x0600,
	0x0800, 0x0a00, 0x0c00, 0x0e00,
	0x1000, 0x1200, 0x1400, 0x1600,
	0x1800, 0x1a00, 0x1c00, 0x1e00,
	0x2000, 0x2200, 0x2400, 0x2600,
	0x2800, 0x2a00, 0x2c00, 0x2e00,
	0x3000, 0x3200, 0x3400, 0x3600,
	0x3800, 0x3a00, 0x3c00, 0x3e00,
	0x4000
};

static unsigned int video_eotf_b_mapping[EOTF_LUT_SIZE] = {
	0x0000,	0x0200,	0x0400, 0x0600,
	0x0800, 0x0a00, 0x0c00, 0x0e00,
	0x1000, 0x1200, 0x1400, 0x1600,
	0x1800, 0x1a00, 0x1c00, 0x1e00,
	0x2000, 0x2200, 0x2400, 0x2600,
	0x2800, 0x2a00, 0x2c00, 0x2e00,
	0x3000, 0x3200, 0x3400, 0x3600,
	0x3800, 0x3a00, 0x3c00, 0x3e00,
	0x4000
};

#define EOTF_COEFF_NORM(a) ((int)((((a) * 4096.0) + 1) / 2))
#define EOTF_COEFF_SIZE 10
#define EOTF_COEFF_RIGHTSHIFT 1
static int osd_eotf_coeff[EOTF_COEFF_SIZE] = {
	EOTF_COEFF_NORM(1.0), EOTF_COEFF_NORM(0.0), EOTF_COEFF_NORM(0.0),
	EOTF_COEFF_NORM(0.0), EOTF_COEFF_NORM(1.0), EOTF_COEFF_NORM(0.0),
	EOTF_COEFF_NORM(0.0), EOTF_COEFF_NORM(0.0), EOTF_COEFF_NORM(1.0),
	EOTF_COEFF_RIGHTSHIFT /* right shift */
};

static int video_eotf_coeff[EOTF_COEFF_SIZE] = {
	EOTF_COEFF_NORM(1.0), EOTF_COEFF_NORM(0.0), EOTF_COEFF_NORM(0.0),
	EOTF_COEFF_NORM(0.0), EOTF_COEFF_NORM(1.0), EOTF_COEFF_NORM(0.0),
	EOTF_COEFF_NORM(0.0), EOTF_COEFF_NORM(0.0), EOTF_COEFF_NORM(1.0),
	EOTF_COEFF_RIGHTSHIFT /* right shift */
};

/******************** osd oetf **************/

#define OSD_OETF_LUT_SIZE 41
static unsigned int osd_oetf_r_mapping[OSD_OETF_LUT_SIZE] = {
		0, 150, 250, 330,
		395, 445, 485, 520,
		544, 632, 686, 725,
		756, 782, 803, 822,
		839, 854, 868, 880,
		892, 902, 913, 922,
		931, 939, 947, 954,
		961, 968, 974, 981,
		986, 993, 998, 1003,
		1009, 1014, 1018, 1023,
		0
};

static unsigned int osd_oetf_g_mapping[OSD_OETF_LUT_SIZE] = {
		0, 0, 0, 0,
		0, 32, 64, 96,
		128, 160, 196, 224,
		256, 288, 320, 352,
		384, 416, 448, 480,
		512, 544, 576, 608,
		640, 672, 704, 736,
		768, 800, 832, 864,
		896, 928, 960, 992,
		1023, 1023, 1023, 1023,
		1023
};

static unsigned int osd_oetf_b_mapping[OSD_OETF_LUT_SIZE] = {
		0, 0, 0, 0,
		0, 32, 64, 96,
		128, 160, 196, 224,
		256, 288, 320, 352,
		384, 416, 448, 480,
		512, 544, 576, 608,
		640, 672, 704, 736,
		768, 800, 832, 864,
		896, 928, 960, 992,
		1023, 1023, 1023, 1023,
		1023
};

/************ video oetf ***************/

#define VIDEO_OETF_LUT_SIZE 289
static unsigned int video_oetf_r_mapping[VIDEO_OETF_LUT_SIZE] = {
	   0,    0,    0,    0,    0,    0,    0,    0,
	   0,    0,    0,    0,    0,    0,    0,    0,
	   4,    8,   12,   16,   20,   24,   28,   32,
	  36,   40,   44,   48,   52,   56,   60,   64,
	  68,   72,   76,   80,   84,   88,   92,   96,
	 100,  104,  108,  112,  116,  120,  124,  128,
	 132,  136,  140,  144,  148,  152,  156,  160,
	 164,  168,  172,  176,  180,  184,  188,  192,
	 196,  200,  204,  208,  212,  216,  220,  224,
	 228,  232,  236,  240,  244,  248,  252,  256,
	 260,  264,  268,  272,  276,  280,  284,  288,
	 292,  296,  300,  304,  308,  312,  316,  320,
	 324,  328,  332,  336,  340,  344,  348,  352,
	 356,  360,  364,  368,  372,  376,  380,  384,
	 388,  392,  396,  400,  404,  408,  412,  416,
	 420,  424,  428,  432,  436,  440,  444,  448,
	 452,  456,  460,  464,  468,  472,  476,  480,
	 484,  488,  492,  496,  500,  504,  508,  512,
	 516,  520,  524,  528,  532,  536,  540,  544,
	 548,  552,  556,  560,  564,  568,  572,  576,
	 580,  584,  588,  592,  596,  600,  604,  608,
	 612,  616,  620,  624,  628,  632,  636,  640,
	 644,  648,  652,  656,  660,  664,  668,  672,
	 676,  680,  684,  688,  692,  696,  700,  704,
	 708,  712,  716,  720,  724,  728,  732,  736,
	 740,  744,  748,  752,  756,  760,  764,  768,
	 772,  776,  780,  784,  788,  792,  796,  800,
	 804,  808,  812,  816,  820,  824,  828,  832,
	 836,  840,  844,  848,  852,  856,  860,  864,
	 868,  872,  876,  880,  884,  888,  892,  896,
	 900,  904,  908,  912,  916,  920,  924,  928,
	 932,  936,  940,  944,  948,  952,  956,  960,
	 964,  968,  972,  976,  980,  984,  988,  992,
	 996, 1000, 1004, 1008, 1012, 1016, 1020, 1023,
	1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023,
	1023
};

static unsigned int video_oetf_g_mapping[VIDEO_OETF_LUT_SIZE] = {
	   0,    0,    0,    0,    0,    0,    0,    0,
	   0,    0,    0,    0,    0,    0,    0,    0,
	   4,    8,   12,   16,   20,   24,   28,   32,
	  36,   40,   44,   48,   52,   56,   60,   64,
	  68,   72,   76,   80,   84,   88,   92,   96,
	 100,  104,  108,  112,  116,  120,  124,  128,
	 132,  136,  140,  144,  148,  152,  156,  160,
	 164,  168,  172,  176,  180,  184,  188,  192,
	 196,  200,  204,  208,  212,  216,  220,  224,
	 228,  232,  236,  240,  244,  248,  252,  256,
	 260,  264,  268,  272,  276,  280,  284,  288,
	 292,  296,  300,  304,  308,  312,  316,  320,
	 324,  328,  332,  336,  340,  344,  348,  352,
	 356,  360,  364,  368,  372,  376,  380,  384,
	 388,  392,  396,  400,  404,  408,  412,  416,
	 420,  424,  428,  432,  436,  440,  444,  448,
	 452,  456,  460,  464,  468,  472,  476,  480,
	 484,  488,  492,  496,  500,  504,  508,  512,
	 516,  520,  524,  528,  532,  536,  540,  544,
	 548,  552,  556,  560,  564,  568,  572,  576,
	 580,  584,  588,  592,  596,  600,  604,  608,
	 612,  616,  620,  624,  628,  632,  636,  640,
	 644,  648,  652,  656,  660,  664,  668,  672,
	 676,  680,  684,  688,  692,  696,  700,  704,
	 708,  712,  716,  720,  724,  728,  732,  736,
	 740,  744,  748,  752,  756,  760,  764,  768,
	 772,  776,  780,  784,  788,  792,  796,  800,
	 804,  808,  812,  816,  820,  824,  828,  832,
	 836,  840,  844,  848,  852,  856,  860,  864,
	 868,  872,  876,  880,  884,  888,  892,  896,
	 900,  904,  908,  912,  916,  920,  924,  928,
	 932,  936,  940,  944,  948,  952,  956,  960,
	 964,  968,  972,  976,  980,  984,  988,  992,
	 996, 1000, 1004, 1008, 1012, 1016, 1020, 1023,
	1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023,
	1023
};

static unsigned int video_oetf_b_mapping[VIDEO_OETF_LUT_SIZE] = {
	   0,    0,    0,    0,    0,    0,    0,    0,
	   0,    0,    0,    0,    0,    0,    0,    0,
	   4,    8,   12,   16,   20,   24,   28,   32,
	  36,   40,   44,   48,   52,   56,   60,   64,
	  68,   72,   76,   80,   84,   88,   92,   96,
	 100,  104,  108,  112,  116,  120,  124,  128,
	 132,  136,  140,  144,  148,  152,  156,  160,
	 164,  168,  172,  176,  180,  184,  188,  192,
	 196,  200,  204,  208,  212,  216,  220,  224,
	 228,  232,  236,  240,  244,  248,  252,  256,
	 260,  264,  268,  272,  276,  280,  284,  288,
	 292,  296,  300,  304,  308,  312,  316,  320,
	 324,  328,  332,  336,  340,  344,  348,  352,
	 356,  360,  364,  368,  372,  376,  380,  384,
	 388,  392,  396,  400,  404,  408,  412,  416,
	 420,  424,  428,  432,  436,  440,  444,  448,
	 452,  456,  460,  464,  468,  472,  476,  480,
	 484,  488,  492,  496,  500,  504,  508,  512,
	 516,  520,  524,  528,  532,  536,  540,  544,
	 548,  552,  556,  560,  564,  568,  572,  576,
	 580,  584,  588,  592,  596,  600,  604,  608,
	 612,  616,  620,  624,  628,  632,  636,  640,
	 644,  648,  652,  656,  660,  664,  668,  672,
	 676,  680,  684,  688,  692,  696,  700,  704,
	 708,  712,  716,  720,  724,  728,  732,  736,
	 740,  744,  748,  752,  756,  760,  764,  768,
	 772,  776,  780,  784,  788,  792,  796,  800,
	 804,  808,  812,  816,  820,  824,  828,  832,
	 836,  840,  844,  848,  852,  856,  860,  864,
	 868,  872,  876,  880,  884,  888,  892,  896,
	 900,  904,  908,  912,  916,  920,  924,  928,
	 932,  936,  940,  944,  948,  952,  956,  960,
	 964,  968,  972,  976,  980,  984,  988,  992,
	 996, 1000, 1004, 1008, 1012, 1016, 1020, 1023,
	1023, 1023, 1023, 1023, 1023, 1023, 1023, 1023,
	1023
};

#define COEFF_NORM(a) ((int)((((a) * 2048.0) + 1) / 2))
#define MATRIX_5x3_COEF_SIZE 24
/******* osd1 matrix0 *******/
/* default rgb to yuv_limit */
static int osd_matrix_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(0.2126),	COEFF_NORM(0.7152),	COEFF_NORM(0.0722),
	COEFF_NORM(-0.11457),	COEFF_NORM(-0.38543),	COEFF_NORM(0.5),
	COEFF_NORM(0.5),	COEFF_NORM(-0.45415),	COEFF_NORM(-0.045847),
	0, 0, 0, /* 30/31/32 */
	0, 0, 0, /* 40/41/42 */
	0, 512, 512, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};

static int vd1_matrix_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(1.0),	COEFF_NORM(0.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(1.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(0.0),	COEFF_NORM(1.0),
	0, 0, 0, /* 30/31/32 */
	0, 0, 0, /* 40/41/42 */
	0, 0, 0, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};

static int vd2_matrix_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(1.0),	COEFF_NORM(0.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(1.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(0.0),	COEFF_NORM(1.0),
	0, 0, 0, /* 30/31/32 */
	0, 0, 0, /* 40/41/42 */
	0, 0, 0, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};

static int post_matrix_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(1.0),	COEFF_NORM(0.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(1.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(0.0),	COEFF_NORM(1.0),
	0, 0, 0, /* 30/31/32 */
	0, 0, 0, /* 40/41/42 */
	0, 0, 0, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};

static int xvycc_matrix_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(1.0),	COEFF_NORM(0.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(1.0),	COEFF_NORM(0.0),
	COEFF_NORM(0.0),	COEFF_NORM(0.0),	COEFF_NORM(1.0),
	0, 0, 0, /* 30/31/32 */
	0, 0, 0, /* 40/41/42 */
	0, 0, 0, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};

static int RGB709_to_YUV709l_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(0.181873),	COEFF_NORM(0.611831),	COEFF_NORM(0.061765),
	COEFF_NORM(-0.100251),	COEFF_NORM(-0.337249),	COEFF_NORM(0.437500),
	COEFF_NORM(0.437500),	COEFF_NORM(-0.397384),	COEFF_NORM(-0.040116),
	0, 0, 0, /* 10'/11'/12' */
	0, 0, 0, /* 20'/21'/22' */
	64, 512, 512, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};

/*  eotf matrix: bypass */
static int eotf_bypass_coeff[EOTF_COEFF_SIZE] = {
	EOTF_COEFF_NORM(1.0),	EOTF_COEFF_NORM(0.0),	EOTF_COEFF_NORM(0.0),
	EOTF_COEFF_NORM(0.0),	EOTF_COEFF_NORM(1.0),	EOTF_COEFF_NORM(0.0),
	EOTF_COEFF_NORM(0.0),	EOTF_COEFF_NORM(0.0),	EOTF_COEFF_NORM(1.0),
	EOTF_COEFF_RIGHTSHIFT /* right shift */
};

/* eotf lut: linear */
static unsigned int eotf_33_linear_mapping[EOTF_LUT_SIZE] = {
	0x0000,	0x0200,	0x0400, 0x0600,
	0x0800, 0x0a00, 0x0c00, 0x0e00,
	0x1000, 0x1200, 0x1400, 0x1600,
	0x1800, 0x1a00, 0x1c00, 0x1e00,
	0x2000, 0x2200, 0x2400, 0x2600,
	0x2800, 0x2a00, 0x2c00, 0x2e00,
	0x3000, 0x3200, 0x3400, 0x3600,
	0x3800, 0x3a00, 0x3c00, 0x3e00,
	0x4000
};

/* osd oetf lut: linear */
static unsigned int oetf_41_linear_mapping[OSD_OETF_LUT_SIZE] = {
	0, 0, 0, 0,
	0, 32, 64, 96,
	128, 160, 196, 224,
	256, 288, 320, 352,
	384, 416, 448, 480,
	512, 544, 576, 608,
	640, 672, 704, 736,
	768, 800, 832, 864,
	896, 928, 960, 992,
	1023, 1023, 1023, 1023,
	1023
};

#define SIGN(a) ((a < 0) ? "-" : "+")
#define DECI(a) ((a) / 1024)
#define FRAC(a) ((((a) >= 0) ? \
	((a) & 0x3ff) : ((~(a) + 1) & 0x3ff)) * 10000 / 1024)

void set_vpp_matrix(int m_select, int *s, int on)
{
	int *m = NULL;
	int size = 0;
	int i;

	if (m_select == VPP_MATRIX_OSD) {
		m = osd_matrix_coeff;
		size = MATRIX_5x3_COEF_SIZE;
	} else if (m_select == VPP_MATRIX_POST) {
		m = post_matrix_coeff;
		size = MATRIX_5x3_COEF_SIZE;
	} else if (m_select == VPP_MATRIX_VD1) {
		m = vd1_matrix_coeff;
		size = MATRIX_5x3_COEF_SIZE;
	} else if (m_select == VPP_MATRIX_VD2) {
		m = vd2_matrix_coeff;
		size = MATRIX_5x3_COEF_SIZE;
	} else if (m_select == VPP_MATRIX_XVYCC) {
		m = xvycc_matrix_coeff;
		size = MATRIX_5x3_COEF_SIZE;
	} else if (m_select == VPP_MATRIX_EOTF) {
		m = video_eotf_coeff;
		size = EOTF_COEFF_SIZE;
	} else if (m_select == VPP_MATRIX_OSD_EOTF) {
		m = osd_eotf_coeff;
		size = EOTF_COEFF_SIZE;
	} else
		return;

	if (s)
		for (i = 0; i < size; i++)
			m[i] = s[i];

	if (m_select == VPP_MATRIX_OSD) {
		/* osd matrix, VPP_MATRIX_0 */
		vpp_reg_write(VIU_OSD1_MATRIX_PRE_OFFSET0_1,
			((m[0] & 0xfff) << 16) | (m[1] & 0xfff));
		vpp_reg_write(VIU_OSD1_MATRIX_PRE_OFFSET2,
			m[2] & 0xfff);
		vpp_reg_write(VIU_OSD1_MATRIX_COEF00_01,
			((m[3] & 0x1fff) << 16) | (m[4] & 0x1fff));
		vpp_reg_write(VIU_OSD1_MATRIX_COEF02_10,
			((m[5] & 0x1fff) << 16) | (m[6] & 0x1fff));
		vpp_reg_write(VIU_OSD1_MATRIX_COEF11_12,
			((m[7] & 0x1fff) << 16) | (m[8] & 0x1fff));
		vpp_reg_write(VIU_OSD1_MATRIX_COEF20_21,
			((m[9] & 0x1fff) << 16) | (m[10] & 0x1fff));
		if (m[21]) {
			vpp_reg_write(VIU_OSD1_MATRIX_COEF22_30,
				((m[11] & 0x1fff) << 16) | (m[12] & 0x1fff));
			vpp_reg_write(VIU_OSD1_MATRIX_COEF31_32,
				((m[13] & 0x1fff) << 16) | (m[14] & 0x1fff));
			vpp_reg_write(VIU_OSD1_MATRIX_COEF40_41,
				((m[15] & 0x1fff) << 16) | (m[16] & 0x1fff));
			vpp_reg_write(VIU_OSD1_MATRIX_COLMOD_COEF42,
				m[17] & 0x1fff);
		} else {
			vpp_reg_write(VIU_OSD1_MATRIX_COEF22_30,
				(m[11] & 0x1fff) << 16);
		}
		vpp_reg_write(VIU_OSD1_MATRIX_OFFSET0_1,
			((m[18] & 0xfff) << 16) | (m[19] & 0xfff));
		vpp_reg_write(VIU_OSD1_MATRIX_OFFSET2,
			m[20] & 0xfff);
		vpp_reg_setb(VIU_OSD1_MATRIX_COLMOD_COEF42,
			m[21], 30, 2);
		vpp_reg_setb(VIU_OSD1_MATRIX_COLMOD_COEF42,
			m[22], 16, 3);
		/* 23 reserved for clipping control */
		vpp_reg_setb(VIU_OSD1_MATRIX_CTRL, on, 0, 1);
		vpp_reg_setb(VIU_OSD1_MATRIX_CTRL, 0, 1, 1);
	} else if (m_select == VPP_MATRIX_EOTF) {
		/* eotf matrix, VPP_MATRIX_EOTF */
		for (i = 0; i < 5; i++)
			vpp_reg_write(VIU_EOTF_CTL + i + 1,
				((m[i * 2] & 0x1fff) << 16)
				| (m[i * 2 + 1] & 0x1fff));

		vpp_reg_setb(VIU_EOTF_CTL, on, 30, 1);
		vpp_reg_setb(VIU_EOTF_CTL, on, 31, 1);
	} else if (m_select == VPP_MATRIX_OSD_EOTF) {
		/* osd eotf matrix, VPP_MATRIX_OSD_EOTF */
		for (i = 0; i < 5; i++)
			vpp_reg_write(VIU_OSD1_EOTF_CTL + i + 1,
				((m[i * 2] & 0x1fff) << 16)
				| (m[i * 2 + 1] & 0x1fff));

		vpp_reg_setb(VIU_OSD1_EOTF_CTL, on, 30, 1);
		vpp_reg_setb(VIU_OSD1_EOTF_CTL, on, 31, 1);
	} else {
		/* vd1 matrix, VPP_MATRIX_1 */
		/* post matrix, VPP_MATRIX_2 */
		/* xvycc matrix, VPP_MATRIX_3 */
		/* vd2 matrix, VPP_MATRIX_6 */
		if (m_select == VPP_MATRIX_POST) {
			/* post matrix */
			m = post_matrix_coeff;
			vpp_reg_setb(VPP_MATRIX_CTRL, on, 0, 1);
			vpp_reg_setb(VPP_MATRIX_CTRL, 0, 8, 2);
		} else if (m_select == VPP_MATRIX_VD1) {
			/* vd1 matrix */
			m = vd1_matrix_coeff;
			vpp_reg_setb(VPP_MATRIX_CTRL, on, 5, 1);
			vpp_reg_setb(VPP_MATRIX_CTRL, 1, 8, 2);
		} else if (m_select == VPP_MATRIX_VD2) {
			/* vd2 matrix */
			m = vd2_matrix_coeff;
			vpp_reg_setb(VPP_MATRIX_CTRL, on, 4, 1);
			vpp_reg_setb(VPP_MATRIX_CTRL, 2, 8, 2);
		} else if (m_select == VPP_MATRIX_XVYCC) {
			/* xvycc matrix */
			m = xvycc_matrix_coeff;
			vpp_reg_setb(VPP_MATRIX_CTRL, on, 6, 1);
			vpp_reg_setb(VPP_MATRIX_CTRL, 3, 8, 2);
		}
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1,
			((m[0] & 0xfff) << 16) | (m[1] & 0xfff));
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET2,
			m[2] & 0xfff);
		vpp_reg_write(VPP_MATRIX_COEF00_01,
			((m[3] & 0x1fff) << 16) | (m[4] & 0x1fff));
		vpp_reg_write(VPP_MATRIX_COEF02_10,
			((m[5]  & 0x1fff) << 16) | (m[6] & 0x1fff));
		vpp_reg_write(VPP_MATRIX_COEF11_12,
			((m[7] & 0x1fff) << 16) | (m[8] & 0x1fff));
		vpp_reg_write(VPP_MATRIX_COEF20_21,
			((m[9] & 0x1fff) << 16) | (m[10] & 0x1fff));
		vpp_reg_write(VPP_MATRIX_COEF22,
			m[11] & 0x1fff);
		if (m[21]) {
			vpp_reg_write(VPP_MATRIX_COEF13_14,
				((m[12] & 0x1fff) << 16) | (m[13] & 0x1fff));
			vpp_reg_write(VPP_MATRIX_COEF15_25,
				((m[14] & 0x1fff) << 16) | (m[17] & 0x1fff));
			vpp_reg_write(VPP_MATRIX_COEF23_24,
				((m[15] & 0x1fff) << 16) | (m[16] & 0x1fff));
		}
		vpp_reg_write(VPP_MATRIX_OFFSET0_1,
			((m[18] & 0xfff) << 16) | (m[19] & 0xfff));
		vpp_reg_write(VPP_MATRIX_OFFSET2,
			m[20] & 0xfff);
		vpp_reg_setb(VPP_MATRIX_CLIP,
			m[21], 3, 2);
		vpp_reg_setb(VPP_MATRIX_CLIP,
			m[22], 5, 3);
	}
}

const char lut_name[4][16] = {
	"OSD_EOTF",
	"OSD_OETF",
	"EOTF",
	"OETF",
};

void set_vpp_lut(
	enum vpp_lut_sel_e lut_sel,
	unsigned int *r,
	unsigned int *g,
	unsigned int *b,
	int on)
{
	unsigned int *r_map = NULL;
	unsigned int *g_map = NULL;
	unsigned int *b_map = NULL;
	unsigned int addr_port;
	unsigned int data_port;
	unsigned int ctrl_port;
	int i;

	if (lut_sel == VPP_LUT_OSD_EOTF) {
		r_map = osd_eotf_r_mapping;
		g_map = osd_eotf_g_mapping;
		b_map = osd_eotf_b_mapping;
		addr_port = VIU_OSD1_EOTF_LUT_ADDR_PORT;
		data_port = VIU_OSD1_EOTF_LUT_DATA_PORT;
		ctrl_port = VIU_OSD1_EOTF_CTL;
	} else if (lut_sel == VPP_LUT_EOTF) {
		r_map = video_eotf_r_mapping;
		g_map = video_eotf_g_mapping;
		b_map = video_eotf_b_mapping;
		addr_port = VIU_EOTF_LUT_ADDR_PORT;
		data_port = VIU_EOTF_LUT_DATA_PORT;
		ctrl_port = VIU_EOTF_CTL;
	} else if (lut_sel == VPP_LUT_OSD_OETF) {
		r_map = osd_oetf_r_mapping;
		g_map = osd_oetf_g_mapping;
		b_map = osd_oetf_b_mapping;
		addr_port = VIU_OSD1_OETF_LUT_ADDR_PORT;
		data_port = VIU_OSD1_OETF_LUT_DATA_PORT;
		ctrl_port = VIU_OSD1_OETF_CTL;
	} else if (lut_sel == VPP_LUT_OETF) {
#if 0
		load_knee_lut(on);
		return;
#else
		r_map = video_oetf_r_mapping;
		g_map = video_oetf_g_mapping;
		b_map = video_oetf_b_mapping;
		addr_port = XVYCC_LUT_R_ADDR_PORT;
		data_port = XVYCC_LUT_R_DATA_PORT;
		ctrl_port = XVYCC_LUT_CTL;
#endif
	} else
		return;

	if (lut_sel == VPP_LUT_OSD_OETF) {
		if (r && r_map)
			for (i = 0; i < OSD_OETF_LUT_SIZE; i++)
				r_map[i] = r[i];
		if (g && g_map)
			for (i = 0; i < OSD_OETF_LUT_SIZE; i++)
				g_map[i] = g[i];
		if (r && r_map)
			for (i = 0; i < OSD_OETF_LUT_SIZE; i++)
				b_map[i] = b[i];
		vpp_reg_write(addr_port, 0);
		for (i = 0; i < 20; i++)
			vpp_reg_write(data_port,
				r_map[i * 2]
				| (r_map[i * 2 + 1] << 16));
		vpp_reg_write(data_port,
			r_map[OSD_OETF_LUT_SIZE - 1]
			| (g_map[0] << 16));
		for (i = 0; i < 20; i++)
			vpp_reg_write(data_port,
				g_map[i * 2 + 1]
				| (g_map[i * 2 + 2] << 16));
		for (i = 0; i < 20; i++)
			vpp_reg_write(data_port,
				b_map[i * 2]
				| (b_map[i * 2 + 1] << 16));
		vpp_reg_write(data_port,
			b_map[OSD_OETF_LUT_SIZE - 1]);
		if (on)
			vpp_reg_setb(ctrl_port, 7, 29, 3);
		else
			vpp_reg_setb(ctrl_port, 0, 29, 3);
	} else if ((lut_sel == VPP_LUT_OSD_EOTF) || (lut_sel == VPP_LUT_EOTF)) {
		if (r && r_map)
			for (i = 0; i < EOTF_LUT_SIZE; i++)
				r_map[i] = r[i];
		if (g && g_map)
			for (i = 0; i < EOTF_LUT_SIZE; i++)
				g_map[i] = g[i];
		if (r && r_map)
			for (i = 0; i < EOTF_LUT_SIZE; i++)
				b_map[i] = b[i];
		vpp_reg_write(addr_port, 0);
		for (i = 0; i < 16; i++)
			vpp_reg_write(data_port,
				r_map[i * 2]
				| (r_map[i * 2 + 1] << 16));
		vpp_reg_write(data_port,
			r_map[EOTF_LUT_SIZE - 1]
			| (g_map[0] << 16));
		for (i = 0; i < 16; i++)
			vpp_reg_write(data_port,
				g_map[i * 2 + 1]
				| (b_map[i * 2 + 2] << 16));
		for (i = 0; i < 16; i++)
			vpp_reg_write(data_port,
				b_map[i * 2]
				| (b_map[i * 2 + 1] << 16));
		vpp_reg_write(data_port, b_map[EOTF_LUT_SIZE - 1]);
		if (on)
			vpp_reg_setb(ctrl_port, 7, 27, 3);
		else
			vpp_reg_setb(ctrl_port, 0, 27, 3);
		vpp_reg_setb(ctrl_port, 1, 31, 1);
	} else if (lut_sel == VPP_LUT_OETF) {
		if (r && r_map)
			for (i = 0; i < VIDEO_OETF_LUT_SIZE; i++)
				r_map[i] = r[i];
		if (g && g_map)
			for (i = 0; i < VIDEO_OETF_LUT_SIZE; i++)
				g_map[i] = g[i];
		if (r && r_map)
			for (i = 0; i < VIDEO_OETF_LUT_SIZE; i++)
				b_map[i] = b[i];
		vpp_reg_write(ctrl_port, 0x0);
		vpp_reg_write(addr_port, 0);
		for (i = 0; i < VIDEO_OETF_LUT_SIZE; i++)
			vpp_reg_write(data_port, r_map[i]);
		vpp_reg_write(addr_port + 2, 0);
		for (i = 0; i < VIDEO_OETF_LUT_SIZE; i++)
			vpp_reg_write(data_port + 2, g_map[i]);
		vpp_reg_write(addr_port + 4, 0);
		for (i = 0; i < VIDEO_OETF_LUT_SIZE; i++)
			vpp_reg_write(data_port + 4, b_map[i]);
		if (on)
			vpp_reg_write(ctrl_port, 0x7f);
		else
			vpp_reg_write(ctrl_port, 0x0);
	}
}

static void set_osd1_rgb2yuv(bool on)
{
	/* set osd1 csc: RGB */
	vpp_reg_setb(VIU_OSD1_BLK0_CFG_W0, 0, 7, 1);

	/* set osd2 luma range: Full */
	/* vpp_reg_setb(VIU_OSD2_CTRL_STAT2, 1, 3, 1); */

	/* eotf lut bypass */
	set_vpp_lut(VPP_LUT_OSD_EOTF,
		eotf_33_linear_mapping, /* R */
		eotf_33_linear_mapping, /* G */
		eotf_33_linear_mapping, /* B */
		CSC_OFF);
	/* eotf matrix bypass */
	set_vpp_matrix(VPP_MATRIX_OSD_EOTF,
		eotf_bypass_coeff,
		CSC_OFF);
	/* oetf lut bypass */
	set_vpp_lut(VPP_LUT_OSD_OETF,
		oetf_41_linear_mapping, /* R */
		oetf_41_linear_mapping, /* G */
		oetf_41_linear_mapping, /* B */
		CSC_OFF);
	/* osd matrix RGB709 to YUV709 limit */
	set_vpp_matrix(VPP_MATRIX_OSD,
		RGB709_to_YUV709l_coeff,
		CSC_ON);
}


#if ((defined CONFIG_AML_HDMITX20) || (defined CONFIG_AML_CVBS))
static void vpp_set_post_matrix_rgb2ycbcr(int mode)
{
	/* enable post matrix */
	vpp_reg_setb(VPP_MATRIX_CTRL, 1, 0, 1);
	vpp_reg_setb(VPP_MATRIX_CTRL, 0, 8, 2);
	vpp_reg_setb(VPP_MATRIX_CTRL, 0, 1, 2);

	if (mode  == 0) {
		/* RGB -> 709 limit */
		vpp_reg_write(VPP_MATRIX_COEF00_01, 0x00bb0275);
		vpp_reg_write(VPP_MATRIX_COEF02_10, 0x003f1f99);
		vpp_reg_write(VPP_MATRIX_COEF11_12, 0x1ea601c2);
		vpp_reg_write(VPP_MATRIX_COEF20_21, 0x01c21e67);
		vpp_reg_write(VPP_MATRIX_COEF22, 0x00001fd7);
		vpp_reg_write(VPP_MATRIX_OFFSET0_1, 0x00400200);
		vpp_reg_write(VPP_MATRIX_OFFSET2, 0x00000200);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET2, 0x0);
	} else {
		/* RGB -> 709 full */
		vpp_reg_write(VPP_MATRIX_COEF00_01, 0xda02dc);
		vpp_reg_write(VPP_MATRIX_COEF02_10, 0x4a1f8a);
		vpp_reg_write(VPP_MATRIX_COEF11_12, 0x1e760200);
		vpp_reg_write(VPP_MATRIX_COEF20_21, 0x2001e2f);
		vpp_reg_write(VPP_MATRIX_COEF22, 0x1fd1);
		vpp_reg_write(VPP_MATRIX_OFFSET0_1, 0x200);
		vpp_reg_write(VPP_MATRIX_OFFSET2, 0x200);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0);
		vpp_reg_write(VPP_MATRIX_PRE_OFFSET2, 0x0);
	}
}
#endif

void vpp_init(void)
{
	VPP_PR("%s\n", __func__);

	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXTVBB) {
		/* 709 limit to RGB */
		vpp_set_matrix_ycbcr2rgb(0, 3);
		/* set dummy data default RGB black */
		vpp_reg_write(VPP_DUMMY_DATA1, 0x0);

	#if ((defined CONFIG_AML_HDMITX20) || (defined CONFIG_AML_CVBS))
		/* RGB to 709 limit */
		vpp_set_post_matrix_rgb2ycbcr(0);
	#endif
	} else if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXM) {
		vpp_reg_setb(VIU_MISC_CTRL1, 0xff, 16, 8);
		vpp_reg_write(VPP_DOLBY_CTRL, 0x20000);
		/* set dummy data default YUV black;
		bit width change to 10bit in gxm */
		vpp_reg_write(VPP_DUMMY_DATA1, 0x1020080);
		/* osd1: rgb->yuv limit , osd2: yuv limit */
		set_osd1_rgb2yuv(1);
	} else {
		/* set dummy data default YUV black */
		vpp_reg_write(VPP_DUMMY_DATA1, 0x108080);
		/* osd1: rgb->yuv limit , osd2: yuv limit */
		set_osd1_rgb2yuv(1);
	}
}
