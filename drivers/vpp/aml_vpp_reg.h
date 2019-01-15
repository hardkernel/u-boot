
/*
 * drivers/vpp/aml_vpu_reg.h
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

#ifndef __VPP_REG_H__
#define __VPP_REG_H__
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>

/* ********************************
 * register define
 * ********************************* */
/* base & offset */
//#define REG_BASE_VCBUS                  (0xd0100000L)
#define REG_OFFSET_VCBUS(reg)           ((reg) << 2)
/* memory mapping */
#define REG_ADDR_VCBUS(reg)             (REG_BASE_VCBUS + REG_OFFSET_VCBUS(reg))

#ifdef VPP_EOTF_CTL
#define VIU_EOTF_CTL VPP_EOTF_CTL
#endif

#ifdef VPP_EOTF_LUT_ADDR_PORT
#define VIU_EOTF_LUT_ADDR_PORT VPP_EOTF_LUT_ADDR_PORT
#endif

#ifdef VPP_EOTF_LUT_DATA_PORT
#define VIU_EOTF_LUT_DATA_PORT VPP_EOTF_LUT_DATA_PORT
#endif

/* ********************************
 * dummy registers *
 * ********************************* */
#ifndef VPP_POST2_MATRIX_PRE_OFFSET0_1
#define VPP_POST2_MATRIX_PRE_OFFSET0_1             0x39ab
#endif

#ifndef VPP_POST2_MATRIX_PRE_OFFSET2
#define VPP_POST2_MATRIX_PRE_OFFSET2               0x39ac
#endif

#ifndef VPP_POST2_MATRIX_COEF00_01
#define VPP_POST2_MATRIX_COEF00_01                 0x39a0
#endif

#ifndef VPP_POST2_MATRIX_COEF02_10
#define VPP_POST2_MATRIX_COEF02_10                 0x39a1
#endif

#ifndef VPP_POST2_MATRIX_COEF11_12
#define VPP_POST2_MATRIX_COEF11_12                 0x39a2
#endif

#ifndef VPP_POST2_MATRIX_COEF20_21
#define VPP_POST2_MATRIX_COEF20_21                 0x39a3
#endif

#ifndef VPP_POST2_MATRIX_COEF22
#define VPP_POST2_MATRIX_COEF22                    0x39a4
#endif

#ifndef VPP_POST2_MATRIX_OFFSET0_1
#define VPP_POST2_MATRIX_OFFSET0_1                 0x39a9
#endif

#ifndef VPP_POST2_MATRIX_OFFSET2
#define VPP_POST2_MATRIX_OFFSET2                   0x39aa
#endif

#ifndef VPP_POST2_MATRIX_EN_CTRL
#define VPP_POST2_MATRIX_EN_CTRL                   0x39ad
#endif


#ifndef VPP_WRAP_OSD1_MATRIX_PRE_OFFSET0_1
#define VPP_WRAP_OSD1_MATRIX_PRE_OFFSET0_1         0x3d6b
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_PRE_OFFSET2
#define VPP_WRAP_OSD1_MATRIX_PRE_OFFSET2           0x3d6c
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_COEF00_01
#define VPP_WRAP_OSD1_MATRIX_COEF00_01             0x3d60
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_COEF02_10
#define VPP_WRAP_OSD1_MATRIX_COEF02_10             0x3d61
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_COEF11_12
#define VPP_WRAP_OSD1_MATRIX_COEF11_12             0x3d62
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_COEF20_21
#define VPP_WRAP_OSD1_MATRIX_COEF20_21             0x3d63
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_COEF22
#define VPP_WRAP_OSD1_MATRIX_COEF22                0x3d64
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_OFFSET0_1
#define VPP_WRAP_OSD1_MATRIX_OFFSET0_1             0x3d69
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_OFFSET2
#define VPP_WRAP_OSD1_MATRIX_OFFSET2               0x3d6a
#endif

#ifndef VPP_WRAP_OSD1_MATRIX_EN_CTRL
#define VPP_WRAP_OSD1_MATRIX_EN_CTRL               0x3d6d
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_PRE_OFFSET0_1
#define VPP_WRAP_OSD2_MATRIX_PRE_OFFSET0_1         0x3d7b
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_PRE_OFFSET2
#define VPP_WRAP_OSD2_MATRIX_PRE_OFFSET2           0x3d7c
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_COEF00_01
#define VPP_WRAP_OSD2_MATRIX_COEF00_01             0x3d70
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_COEF02_10
#define VPP_WRAP_OSD2_MATRIX_COEF02_10             0x3d71
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_COEF11_12
#define VPP_WRAP_OSD2_MATRIX_COEF11_12             0x3d72
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_COEF20_21
#define VPP_WRAP_OSD2_MATRIX_COEF20_21             0x3d73
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_COEF22
#define VPP_WRAP_OSD2_MATRIX_COEF22                0x3d74
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_OFFSET0_1
#define VPP_WRAP_OSD2_MATRIX_OFFSET0_1             0x3d79
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_OFFSET2
#define VPP_WRAP_OSD2_MATRIX_OFFSET2               0x3d7a
#endif

#ifndef VPP_WRAP_OSD2_MATRIX_EN_CTRL
#define VPP_WRAP_OSD2_MATRIX_EN_CTRL               0x3d7d
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_PRE_OFFSET0_1
#define VPP_WRAP_OSD3_MATRIX_PRE_OFFSET0_1         0x3dbb
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_PRE_OFFSET2
#define VPP_WRAP_OSD3_MATRIX_PRE_OFFSET2           0x3dbc
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_COEF00_01
#define VPP_WRAP_OSD3_MATRIX_COEF00_01             0x3db0
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_COEF02_10
#define VPP_WRAP_OSD3_MATRIX_COEF02_10             0x3db1
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_COEF11_12
#define VPP_WRAP_OSD3_MATRIX_COEF11_12             0x3db2
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_COEF20_21
#define VPP_WRAP_OSD3_MATRIX_COEF20_21             0x3db3
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_COEF22
#define VPP_WRAP_OSD3_MATRIX_COEF22                0x3db4
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_OFFSET0_1
#define VPP_WRAP_OSD3_MATRIX_OFFSET0_1             0x3db9
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_OFFSET2
#define VPP_WRAP_OSD3_MATRIX_OFFSET2               0x3dba
#endif

#ifndef VPP_WRAP_OSD3_MATRIX_EN_CTRL
#define VPP_WRAP_OSD3_MATRIX_EN_CTRL               0x3dbd
#endif

#ifndef DOLBY_PATH_CTRL
#define DOLBY_PATH_CTRL                            0x1a0c
#endif

/*hdr2 register*/
#define VD1_HDR2_CTRL                      0x3800
#define VD1_HDR2_CLK_GATE                  0x3801
#define VD1_HDR2_MATRIXI_COEF00_01         0x3802
#define VD1_HDR2_MATRIXI_COEF02_10         0x3803
#define VD1_HDR2_MATRIXI_COEF11_12         0x3804
#define VD1_HDR2_MATRIXI_COEF20_21         0x3805
#define VD1_HDR2_MATRIXI_COEF22            0x3806
#define VD1_HDR2_MATRIXI_COEF30_31         0x3807
#define VD1_HDR2_MATRIXI_COEF32_40         0x3808
#define VD1_HDR2_MATRIXI_COEF41_42         0x3809
#define VD1_HDR2_MATRIXI_OFFSET0_1         0x380a
#define VD1_HDR2_MATRIXI_OFFSET2           0x380b
#define VD1_HDR2_MATRIXI_PRE_OFFSET0_1     0x380c
#define VD1_HDR2_MATRIXI_PRE_OFFSET2       0x380d
#define VD1_HDR2_MATRIXO_COEF00_01         0x380e
#define VD1_HDR2_MATRIXO_COEF02_10         0x380f
#define VD1_HDR2_MATRIXO_COEF11_12         0x3810
#define VD1_HDR2_MATRIXO_COEF20_21         0x3811
#define VD1_HDR2_MATRIXO_COEF22            0x3812
#define VD1_HDR2_MATRIXO_COEF30_31         0x3813
#define VD1_HDR2_MATRIXO_COEF32_40         0x3814
#define VD1_HDR2_MATRIXO_COEF41_42         0x3815
#define VD1_HDR2_MATRIXO_OFFSET0_1         0x3816
#define VD1_HDR2_MATRIXO_OFFSET2           0x3817
#define VD1_HDR2_MATRIXO_PRE_OFFSET0_1     0x3818
#define VD1_HDR2_MATRIXO_PRE_OFFSET2       0x3819
#define VD1_HDR2_MATRIXI_CLIP              0x381a
#define VD1_HDR2_MATRIXO_CLIP              0x381b
#define VD1_HDR2_CGAIN_OFFT                0x381c
#define VD1_EOTF_LUT_ADDR_PORT             0x381e
#define VD1_EOTF_LUT_DATA_PORT             0x381f
#define VD1_OETF_LUT_ADDR_PORT             0x3820
#define VD1_OETF_LUT_DATA_PORT             0x3821
#define VD1_CGAIN_LUT_ADDR_PORT            0x3822
#define VD1_CGAIN_LUT_DATA_PORT            0x3823
#define VD1_HDR2_CGAIN_COEF0               0x3824
#define VD1_HDR2_CGAIN_COEF1               0x3825
#define VD1_OGAIN_LUT_ADDR_PORT            0x3826
#define VD1_OGAIN_LUT_DATA_PORT            0x3827
#define VD1_HDR2_ADPS_CTRL                 0x3828
#define VD1_HDR2_ADPS_ALPHA0               0x3829
#define VD1_HDR2_ADPS_ALPHA1               0x382a
#define VD1_HDR2_ADPS_BETA0                0x382b
#define VD1_HDR2_ADPS_BETA1                0x382c
#define VD1_HDR2_ADPS_BETA2                0x382d
#define VD1_HDR2_ADPS_COEF0                0x382e
#define VD1_HDR2_ADPS_COEF1                0x382f
#define VD1_HDR2_GMUT_CTRL                 0x3830
#define VD1_HDR2_GMUT_COEF0                0x3831
#define VD1_HDR2_GMUT_COEF1                0x3832
#define VD1_HDR2_GMUT_COEF2                0x3833
#define VD1_HDR2_GMUT_COEF3                0x3834
#define VD1_HDR2_GMUT_COEF4                0x3835
#define VD1_HDR2_PIPE_CTRL1                0x3836
#define VD1_HDR2_PIPE_CTRL2                0x3837
#define VD1_HDR2_PIPE_CTRL3                0x3838
#define VD1_HDR2_PROC_WIN1                 0x3839
#define VD1_HDR2_PROC_WIN2                 0x383a
#define VD1_HDR2_MATRIXI_EN_CTRL           0x383b
#define VD1_HDR2_MATRIXO_EN_CTRL           0x383c

#define OSD1_HDR2_CTRL                      0x38a0
#define OSD1_HDR2_CLK_GATE                  0x38a1
#define OSD1_HDR2_MATRIXI_COEF00_01         0x38a2
#define OSD1_HDR2_MATRIXI_COEF02_10         0x38a3
#define OSD1_HDR2_MATRIXI_COEF11_12         0x38a4
#define OSD1_HDR2_MATRIXI_COEF20_21         0x38a5
#define OSD1_HDR2_MATRIXI_COEF22            0x38a6
#define OSD1_HDR2_MATRIXI_COEF30_31         0x38a7
#define OSD1_HDR2_MATRIXI_COEF32_40         0x38a8
#define OSD1_HDR2_MATRIXI_COEF41_42         0x38a9
#define OSD1_HDR2_MATRIXI_OFFSET0_1         0x38aa
#define OSD1_HDR2_MATRIXI_OFFSET2           0x38ab
#define OSD1_HDR2_MATRIXI_PRE_OFFSET0_1     0x38ac
#define OSD1_HDR2_MATRIXI_PRE_OFFSET2       0x38ad
#define OSD1_HDR2_MATRIXO_COEF00_01         0x38ae
#define OSD1_HDR2_MATRIXO_COEF02_10         0x38af
#define OSD1_HDR2_MATRIXO_COEF11_12         0x38b0
#define OSD1_HDR2_MATRIXO_COEF20_21         0x38b1
#define OSD1_HDR2_MATRIXO_COEF22            0x38b2
#define OSD1_HDR2_MATRIXO_COEF30_31         0x38b3
#define OSD1_HDR2_MATRIXO_COEF32_40         0x38b4
#define OSD1_HDR2_MATRIXO_COEF41_42         0x38b5
#define OSD1_HDR2_MATRIXO_OFFSET0_1         0x38b6
#define OSD1_HDR2_MATRIXO_OFFSET2           0x38b7
#define OSD1_HDR2_MATRIXO_PRE_OFFSET0_1     0x38b8
#define OSD1_HDR2_MATRIXO_PRE_OFFSET2       0x38b9
#define OSD1_HDR2_MATRIXI_CLIP              0x38ba
#define OSD1_HDR2_MATRIXO_CLIP              0x38bb
#define OSD1_HDR2_CGAIN_OFFT                0x38bc
#define OSD1_EOTF_LUT_ADDR_PORT             0x38be
#define OSD1_EOTF_LUT_DATA_PORT             0x38bf
#define OSD1_OETF_LUT_ADDR_PORT             0x38c0
#define OSD1_OETF_LUT_DATA_PORT             0x38c1
#define OSD1_CGAIN_LUT_ADDR_PORT            0x38c2
#define OSD1_CGAIN_LUT_DATA_PORT            0x38c3
#define OSD1_HDR2_CGAIN_COEF0               0x38c4
#define OSD1_HDR2_CGAIN_COEF1               0x38c5
#define OSD1_OGAIN_LUT_ADDR_PORT            0x38c6
#define OSD1_OGAIN_LUT_DATA_PORT            0x38c7
#define OSD1_HDR2_ADPS_CTRL                 0x38c8
#define OSD1_HDR2_ADPS_ALPHA0               0x38c9
#define OSD1_HDR2_ADPS_ALPHA1               0x38ca
#define OSD1_HDR2_ADPS_BETA0                0x38cb
#define OSD1_HDR2_ADPS_BETA1                0x38cc
#define OSD1_HDR2_ADPS_BETA2                0x38cd
#define OSD1_HDR2_ADPS_COEF0                0x38ce
#define OSD1_HDR2_ADPS_COEF1                0x38cf
#define OSD1_HDR2_GMUT_CTRL                 0x38d0
#define OSD1_HDR2_GMUT_COEF0                0x38d1
#define OSD1_HDR2_GMUT_COEF1                0x38d2
#define OSD1_HDR2_GMUT_COEF2                0x38d3
#define OSD1_HDR2_GMUT_COEF3                0x38d4
#define OSD1_HDR2_GMUT_COEF4                0x38d5
#define OSD1_HDR2_PIPE_CTRL1                0x38d6
#define OSD1_HDR2_PIPE_CTRL2                0x38d7
#define OSD1_HDR2_PIPE_CTRL3                0x38d8
#define OSD1_HDR2_PROC_WIN1                 0x38d9
#define OSD1_HDR2_PROC_WIN2                 0x38da
#define OSD1_HDR2_MATRIXI_EN_CTRL           0x38db
#define OSD1_HDR2_MATRIXO_EN_CTRL           0x38dc

/*hdr2 register end*/

//#define GAMMA_CNTL_PORT                            0x1400
#define  GAMMA_VCOM_POL    7     /* RW */
#define  GAMMA_RVS_OUT     6     /* RW */
#define  ADR_RDY           5     /* Read Only */
#define  WR_RDY            4     /* Read Only */
#define  RD_RDY            3     /* Read Only */
#define  GAMMA_TR          2     /* RW */
#define  GAMMA_SET         1     /* RW */
#define  GAMMA_EN          0     /* RW */

//#define GAMMA_DATA_PORT                            0x1401
//#define GAMMA_ADDR_PORT                            0x1402
#define  H_RD              12
#define  H_AUTO_INC        11
#define  H_SEL_R           10
#define  H_SEL_G           9
#define  H_SEL_B           8
#define  HADR_MSB          7            /* 7:0 */
#define  HADR              0            /* 7:0 */

/* ********************************
 * register access api
 * ********************************* */

static inline unsigned int vpp_reg_read(unsigned int _reg)
{
	return (*(volatile unsigned int *)REG_ADDR_VCBUS(_reg));
};

static inline void vpp_reg_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_VCBUS(_reg) = (_value);
};

static inline void vpp_reg_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	vpp_reg_write(_reg, ((vpp_reg_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int vpp_reg_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (vpp_reg_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

#endif
