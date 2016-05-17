
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

	if (mode == 0) { //ycbcr not full range, 601 conversion
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
	} else if (mode == 1) {//ycbcr full range, 601 conversion
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
	} else if (mode == 2) {/*709F to RGB*/
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
	}
}

#define COEFF_NORM(a) ((int)((((a) * 2048.0) + 1) / 2))
#define MATRIX_5x3_COEF_SIZE 24
static int RGB709_to_YUV709l_coeff[MATRIX_5x3_COEF_SIZE] = {
	0, 0, 0, /* pre offset */
	COEFF_NORM(0.181873),	COEFF_NORM(0.611831),	COEFF_NORM(0.061765),
	COEFF_NORM(-0.100251),	COEFF_NORM(-0.337249),	COEFF_NORM(0.437500),
	COEFF_NORM(0.437500),	COEFF_NORM(-0.397384),	COEFF_NORM(-0.040116),
	0, 0, 0, /* 10'/11'/12' */
	0, 0, 0, /* 20'/21'/22' */
	0, 512, 512, /* offset */
	0, 0, 0 /* mode, right_shift, clip_en */
};

static void set_osd1_rgb2yuv(bool on)
{
	int *m = NULL;

	m = RGB709_to_YUV709l_coeff;

	return;/* osd_hw.c has changed data to yuv */
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

	/* set osd2 output range to full */
	vpp_reg_setb(VIU_OSD2_CTRL_STAT2, 1, 3, 1);
}



#if ((defined CONFIG_AML_HDMITX20) || (defined CONFIG_AML_CVBS))
static void vpp_set_post_matrix_rgb2ycbcr (void)
{
	/* enable post matrix */
	vpp_reg_setb(VPP_MATRIX_CTRL, 1, 0, 1);
	vpp_reg_setb(VPP_MATRIX_CTRL, 0, 8, 2);
	vpp_reg_setb(VPP_MATRIX_CTRL, 0, 1, 2);

	/* RGB -> 709F*/
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
#endif

void vpp_init(void)
{
	VPP_PR("%s\n", __func__);

	if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXTVBB) {
		/* 601 to RGB */
		vpp_set_matrix_ycbcr2rgb(0, 0);
		/* set dummy data default RGB black */
		vpp_reg_write(VPP_DUMMY_DATA1, 0x0);

	#if ((defined CONFIG_AML_HDMITX20) || (defined CONFIG_AML_CVBS))
		vpp_set_post_matrix_rgb2ycbcr();
	#endif
	} else if (get_cpu_id().family_id == MESON_CPU_MAJOR_ID_GXM) {
		vpp_reg_setb(VIU_MISC_CTRL1, 0xff, 16, 8);
		vpp_reg_write(VPP_DOLBY_CTRL, 0x20000);
		/* set dummy data default YUV black;
		bit width change to 10bit in gxm */
		vpp_reg_write(VPP_DUMMY_DATA1, 0x1020080);
		/* osd1: rgb->yuv , osd2: yuv*/
		set_osd1_rgb2yuv(1);
	} else {
		/* set dummy data default RGB black */
		vpp_reg_write(VPP_DUMMY_DATA1, 0x8080);
		/* osd1: rgb->yuv , osd2: yuv*/
		set_osd1_rgb2yuv(1);
	}
}
