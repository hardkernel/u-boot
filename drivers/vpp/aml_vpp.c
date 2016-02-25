
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

#if ((defined CONFIG_AML_HDMITX20) || (defined CONFIG_AML_CVBS))
static void vpp_set_post_matrix_rgb2ycbcr (void)
{
	/* enable post matrix */
	vpp_reg_setb(VPP_MATRIX_CTRL, 1, 0, 1);
	vpp_reg_setb(VPP_MATRIX_CTRL, 0, 8, 2);
	vpp_reg_setb(VPP_MATRIX_CTRL, 0, 1, 2);

	/* 602 limit to rgb */
	vpp_reg_write(VPP_MATRIX_PRE_OFFSET0_1, 0x0);
	vpp_reg_write(VPP_MATRIX_PRE_OFFSET2, 0x0);

	//0.257     0.504   0.098
	//-0.148    -0.291  0.439
	//0.439     -0.368 -0.071
	vpp_reg_write(VPP_MATRIX_COEF00_01, (0x107 << 16) | 0x204);
	vpp_reg_write(VPP_MATRIX_COEF02_10, (0x64 << 16) | 0x1f68);
	vpp_reg_write(VPP_MATRIX_COEF11_12, (0x1ed6 << 16) | 0x1c2);
	vpp_reg_write(VPP_MATRIX_COEF20_21, (0x1c2 << 16) | 0x1e87);
	vpp_reg_write(VPP_MATRIX_COEF22, 0x1fb7);
	vpp_reg_write(VPP_MATRIX_OFFSET0_1, (0x40 << 16) | 0x0200);
	vpp_reg_write(VPP_MATRIX_OFFSET2, 0x0200);

}
#endif

void vpp_init(void)
{
	VPP_PR("%s\n", __func__);
	vpp_set_matrix_ycbcr2rgb(0, 0); /* 601 to RGB */
	vpp_reg_write(VPP_DUMMY_DATA1, 0x0); /* set dummy data default RGB black */
#if ((defined CONFIG_AML_HDMITX20) || (defined CONFIG_AML_CVBS))
	vpp_set_post_matrix_rgb2ycbcr();
#endif
}
