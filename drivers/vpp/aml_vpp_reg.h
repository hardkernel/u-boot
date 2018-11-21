
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
