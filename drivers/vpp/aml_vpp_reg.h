
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

/* ********************************
 * register define
 * ********************************* */
/* base & offset */
#define REG_BASE_VCBUS                  (0xd0100000L)
#define REG_OFFSET_VCBUS(reg)           ((reg) << 2)
/* memory mapping */
#define REG_ADDR_VCBUS(reg)             (REG_BASE_VCBUS + REG_OFFSET_VCBUS(reg))


/* ********************************
 * Video post-processing:  VPP_VCBUS_BASE = 0x1d
 * ******************************** */
/* Bit 31  vd1_bgosd_exchange_en for preblend
// Bit 30  vd1_bgosd_exchange_en for postblend
// bit 28   color management enable
// Bit 27,  reserved
// Bit 26:18, reserved
// Bit 17, osd2 enable for preblend
// Bit 16, osd1 enable for preblend
// Bit 15, reserved
// Bit 14, vd1 enable for preblend
// Bit 13, osd2 enable for postblend
// Bit 12, osd1 enable for postblend
// Bit 11, reserved
// Bit 10, vd1 enable for postblend
// Bit 9,  if true, osd1 is alpha premultipiled
// Bit 8,  if true, osd2 is alpha premultipiled
// Bit 7,  postblend module enable
// Bit 6,  preblend module enable
// Bit 5,  if true, osd2 foreground compared with osd1 in preblend
// Bit 4,  if true, osd2 foreground compared with osd1 in postblend
// Bit 3,
// Bit 2,  if true, disable resetting async fifo every vsync, otherwise every
//           vsync the aync fifo will be reseted.
// Bit 1,
// Bit 0    if true, the output result of VPP is saturated */
#define VPP2_MISC                                  0x1926
/* Bit 31  vd1_bgosd_exchange_en for preblend
// Bit 30  vd1_bgosd_exchange_en for postblend
// Bit 28   color management enable
// Bit 27,  if true, vd2 use viu2 output as the input, otherwise use normal
//            vd2 from memory
// Bit 26:18, vd2 alpha
// Bit 17, osd2 enable for preblend
// Bit 16, osd1 enable for preblend
// Bit 15, vd2 enable for preblend
// Bit 14, vd1 enable for preblend
// Bit 13, osd2 enable for postblend
// Bit 12, osd1 enable for postblend
// Bit 11, vd2 enable for postblend
// Bit 10, vd1 enable for postblend
// Bit 9,  if true, osd1 is alpha premultipiled
// Bit 8,  if true, osd2 is alpha premultipiled
// Bit 7,  postblend module enable
// Bit 6,  preblend module enable
// Bit 5,  if true, osd2 foreground compared with osd1 in preblend
// Bit 4,  if true, osd2 foreground compared with osd1 in postblend
// Bit 3,
// Bit 2,  if true, disable resetting async fifo every vsync, otherwise every
//           vsync the aync fifo will be reseted.
// Bit 1,
// Bit 0	if true, the output result of VPP is saturated */
#define VPP_MISC                                   0x1d26

#define VPP2_POSTBLEND_H_SIZE                      0x1921
#define VPP_POSTBLEND_H_SIZE                       0x1d21
/* Bit 3	minus black level enable for vadj2
 * Bit 2	Video adjustment enable for vadj2
 * Bit 1	minus black level enable for vadj1
 * Bit 0	Video adjustment enable for vadj1 */
#define VPP_VADJ_CTRL                              0x1d40
/* Bit 16:8  brightness, signed value
 * Bit 7:0	contrast, unsigned value, contrast from  0 <= contrast <2 */
#define VPP_VADJ1_Y                                0x1d41
/* cb' = cb*ma + cr*mb
 * cr' = cb*mc + cr*md
 * all are bit 9:0, signed value, -2 < ma/mb/mc/md < 2 */
#define VPP_VADJ1_MA_MB                            0x1d42
#define VPP_VADJ1_MC_MD                            0x1d43
/* Bit 16:8  brightness, signed value
 * Bit 7:0   contrast, unsigned value, contrast from  0 <= contrast <2 */
#define VPP_VADJ2_Y                                0x1d44
/* cb' = cb*ma + cr*mb
 * cr' = cb*mc + cr*md
 * all are bit 9:0, signed value, -2 < ma/mb/mc/md < 2 */
#define VPP_VADJ2_MA_MB                            0x1d45
#define VPP_VADJ2_MC_MD                            0x1d46

#define VPP_MATRIX_CTRL                            0x1d5f
/* Bit 28:16 coef00 */
/* Bit 12:0  coef01 */
#define VPP_MATRIX_COEF00_01                       0x1d60
/* Bit 28:16 coef02 */
/* Bit 12:0  coef10 */
#define VPP_MATRIX_COEF02_10                       0x1d61
/* Bit 28:16 coef11 */
/* Bit 12:0  coef12 */
#define VPP_MATRIX_COEF11_12                       0x1d62
/* Bit 28:16 coef20 */
/* Bit 12:0  coef21 */
#define VPP_MATRIX_COEF20_21                       0x1d63
#define VPP_MATRIX_COEF22                          0x1d64
/* Bit 26:16 offset0 */
/* Bit 10:0  offset1 */
#define VPP_MATRIX_OFFSET0_1                       0x1d65
/* Bit 10:0  offset2 */
#define VPP_MATRIX_OFFSET2                         0x1d66
/* Bit 26:16 pre_offset0 */
/* Bit 10:0  pre_offset1 */
#define VPP_MATRIX_PRE_OFFSET0_1                   0x1d67
/* Bit 10:0  pre_offset2 */
#define VPP_MATRIX_PRE_OFFSET2                     0x1d68
/* dummy data used in the VPP postblend */
/* Bit 23:16    Y */
/* Bit 15:8     CB */
/* Bit 7:0      CR */
#define VPP_DUMMY_DATA1                            0x1d69
/* gxm has no super-core */
#define VPP_DOLBY_CTRL 0x1d93
#define VIU_MISC_CTRL1 0x1a07

#define VIU_OSD1_MATRIX_CTRL 0x1a90
#define VIU_OSD1_MATRIX_COEF00_01 0x1a91
#define VIU_OSD1_MATRIX_COEF02_10 0x1a92
#define VIU_OSD1_MATRIX_COEF11_12 0x1a93
#define VIU_OSD1_MATRIX_COEF20_21 0x1a94
#define VIU_OSD1_MATRIX_COLMOD_COEF42 0x1a95
#define VIU_OSD1_MATRIX_OFFSET0_1 0x1a96
#define VIU_OSD1_MATRIX_OFFSET2 0x1a97
#define VIU_OSD1_MATRIX_PRE_OFFSET0_1 0x1a98
#define VIU_OSD1_MATRIX_PRE_OFFSET2 0x1a99
#define VIU_OSD1_MATRIX_COEF22_30 0x1a9d
#define VIU_OSD1_MATRIX_COEF31_32 0x1a9e
#define VIU_OSD1_MATRIX_COEF40_41 0x1a9f

#define VIU_OSD2_CTRL_STAT2				0x1a4d
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
