
/*
 * drivers/efuse/efuse_regs.h
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

#ifndef __EFUSE_REG_H
#define __EFUSE_REG_H
#include <asm/io.h>
//#define EFUSE_DEBUG

#define WRITE_EFUSE_REG(reg, val)  __raw_writel(val, reg)
#define READ_EFUSE_REG(reg)  (__raw_readl(reg))
#define WRITE_EFUSE_REG_BITS(reg, val, start, len) \
	WRITE_EFUSE_REG(reg,	(READ_EFUSE_REG(reg) & ~(((1L<<(len))-1)<<(start)) )| ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define READ_EFUSE_REG_BITS(reg, start, len) \
	((READ_EFUSE_REG(reg) >> (start)) & ((1L<<(len))-1))

// EFUSE version constant definition

#define GXBB_EFUSE_VERSION_SERIALNUM_V1	0 /*TO DO*/
#define GXBB_EFUSE_VERSION_OFFSET 0 /*TO DO*/
#define GXBB_EFUSE_VERSION_ENC_LEN 0 /*TO DO*/
#define GXBB_EFUSE_VERSION_DATA_LEN 0 /*TO DO*/

typedef enum {
	EFUSE_SOC_CHIP_GXBB,
	EFUSE_SOC_CHIP_UNKNOW,
}efuse_socchip_type_e;

#endif

