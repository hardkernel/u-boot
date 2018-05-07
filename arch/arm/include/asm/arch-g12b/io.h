
/*
 * arch/arm/include/asm/arch-txl/io.h
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

#ifndef __MACH_MESSON_REGS_IO_H
#define __MACH_MESSON_REGS_IO_H

#ifndef __ASSEMBLY__

#include <asm/io.h>
#define IO_CBUS_BASE                    (0xFFD00000L)
#define IO_AXI_BUS_BASE                 (0xFFB00000L) /* gpv */
#define IO_AHB_BUS_BASE                 (0xFF500000L) /* usb0 */
#define IO_APB_BUS_BASE                 (0xFFFC0000L) /* AHB SRAM, sec/sys ahb? txlx_mem_map.xlsx */
#define IO_APB_HDMI_BUS_BASE            (0xFFE00000L) /*  */
#define IO_VPU_BUS_BASE                 (0xFF900000L) /* VPU */

#define CBUS_REG_OFFSET(reg) ((reg) << 2)
#define CBUS_REG_ADDR(reg)	 (IO_CBUS_BASE + CBUS_REG_OFFSET(reg))

#define AXI_REG_OFFSET(reg)  ((reg) << 2)
#define AXI_REG_ADDR(reg)	 (IO_AXI_BUS_BASE + AXI_REG_OFFSET(reg))

#define AHB_REG_OFFSET(reg)  ((reg) << 2)
#define AHB_REG_ADDR(reg)	 (IO_AHB_BUS_BASE + AHB_REG_OFFSET(reg))

#define VPU_REG_OFFSET(reg)  ((reg) << 2)
#define VPU_REG_ADDR(reg)	 (IO_VPU_BUS_BASE + VPU_REG_OFFSET(reg))


#define APB_REG_OFFSET(reg)  (reg)
#define APB_REG_ADDR(reg)	 (IO_APB_BUS_BASE + APB_REG_OFFSET(reg))
#define APB_REG_ADDR_VALID(reg) (((unsigned long)(reg) & 3) == 0)

#define APB_HDMI_REG_OFFSET(reg)  (reg)
#define APB_HDMI_REG_ADDR(reg)	 (IO_APB_HDMI_BUS_BASE + APB_HDMI_REG_OFFSET(reg))
#define APB_HDMI_REG_ADDR_VALID(reg) (((unsigned long)(reg) & 3) == 0)


#define WRITE_CBUS_REG(reg, val) __raw_writel(val, CBUS_REG_ADDR(reg))
#define READ_CBUS_REG(reg) (__raw_readl(CBUS_REG_ADDR(reg)))
#define WRITE_CBUS_REG_BITS(reg, val, start, len) \
    WRITE_CBUS_REG(reg,	(READ_CBUS_REG(reg) & ~(((1L<<(len))-1)<<(start)) )| ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define READ_CBUS_REG_BITS(reg, start, len) \
    ((READ_CBUS_REG(reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_CBUS_REG_MASK(reg, mask) WRITE_CBUS_REG(reg, (READ_CBUS_REG(reg)&(~(mask))))
#define SET_CBUS_REG_MASK(reg, mask)   WRITE_CBUS_REG(reg, (READ_CBUS_REG(reg)|(mask)))

#define WRITE_AXI_REG(reg, val) __raw_writel(val, AXI_REG_ADDR(reg))
#define READ_AXI_REG(reg) (__raw_readl(AXI_REG_ADDR(reg)))
#define WRITE_AXI_REG_BITS(reg, val, start, len) \
    WRITE_AXI_REG(reg,	(READ_AXI_REG(reg) & ~(((1L<<(len))-1)<<(start)) )| ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define READ_AXI_REG_BITS(reg, start, len) \
    ((READ_AXI_REG(reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_AXI_REG_MASK(reg, mask) WRITE_AXI_REG(reg, (READ_AXI_REG(reg)&(~(mask))))
#define SET_AXI_REG_MASK(reg, mask)   WRITE_AXI_REG(reg, (READ_AXI_REG(reg)|(mask)))

#define WRITE_AHB_REG(reg, val) __raw_writel(val, AHB_REG_ADDR(reg))
#define READ_AHB_REG(reg) (__raw_readl(AHB_REG_ADDR(reg)))
#define WRITE_AHB_REG_BITS(reg, val, start, len) \
    WRITE_AHB_REG(reg,	(READ_AHB_REG(reg) & ~(((1L<<(len))-1)<<(start)) )| ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define READ_AHB_REG_BITS(reg, start, len) \
    ((READ_AHB_REG(reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_AHB_REG_MASK(reg, mask) WRITE_AHB_REG(reg, (READ_AHB_REG(reg)&(~(mask))))
#define SET_AHB_REG_MASK(reg, mask)   WRITE_AHB_REG(reg, (READ_AHB_REG(reg)|(mask)))

#define WRITE_APB_REG(reg, val) __raw_writel(val, APB_REG_ADDR(reg))
#define READ_APB_REG(reg) (__raw_readl(APB_REG_ADDR(reg)))
#define WRITE_APB_REG_BITS(reg, val, start, len) \
    WRITE_APB_REG(reg,	(READ_APB_REG(reg) & ~(((1L<<(len))-1)<<(start)) )| ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define READ_APB_REG_BITS(reg, start, len) \
    ((READ_APB_REG(reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_APB_REG_MASK(reg, mask) WRITE_APB_REG(reg, (READ_APB_REG(reg)&(~(mask))))
#define SET_APB_REG_MASK(reg, mask)   WRITE_APB_REG(reg, (READ_APB_REG(reg)|(mask)))

#define WRITE_APB_HDMI_REG(reg, val) __raw_writel(val, APB_HDMI_REG_ADDR(reg))
#define READ_APB_HDMI_REG(reg) (__raw_readl(APB_HDMI_REG_ADDR(reg)))
#define WRITE_APB_HDMI_REG_BITS(reg, val, start, len) \
    WRITE_APB_HDMI_REG(reg,	(READ_APB_HDMI_REG(reg) & ~(((1L<<(len))-1)<<(start)) )| ((unsigned)((val)&((1L<<(len))-1)) << (start)))
#define READ_APB_HDMI_REG_BITS(reg, start, len) \
    ((READ_APB_HDMI_REG(reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_APB_HDMI_REG_MASK(reg, mask) WRITE_APB_HDMI_REG(reg, (READ_APB_HDMI_REG(reg)&(~(mask))))
#define SET_APB_HDMI_REG_MASK(reg, mask)   WRITE_APB_HDMI_REG(reg, (READ_APB_HDMI_REG(reg)|(mask)))

/* for back compatible alias */
#define WRITE_MPEG_REG(reg, val) \
	WRITE_CBUS_REG(reg, val)
#define READ_MPEG_REG(reg) \
	READ_CBUS_REG(reg)
#define WRITE_MPEG_REG_BITS(reg, val, start, len) \
	WRITE_CBUS_REG_BITS(reg, val, start, len)
#define READ_MPEG_REG_BITS(reg, start, len) \
	READ_CBUS_REG_BITS(reg, start, len)
#define CLEAR_MPEG_REG_MASK(reg, mask) \
	CLEAR_CBUS_REG_MASK(reg, mask)
#define SET_MPEG_REG_MASK(reg, mask) \
	SET_CBUS_REG_MASK(reg, mask)
#endif


#endif
