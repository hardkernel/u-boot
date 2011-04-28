/*
 *
 * arch/arm/include/asm/arch-m1/am_regs.h
 *
 *  Copyright (C) 2010 AMLOGIC, INC.
 *
 * License terms: GNU General Public License (GPL) version 2
 * Basic register address definitions in physical memory and
 * some block defintions for core devices like the timer.
 * copy from linux kernel
 */

#ifndef __MACH_MESSON_REGS_IO_H
#define __MACH_MESSON_REGS_IO_H

#ifndef __ASSEMBLY__

#include <asm/io.h>




#define WRITE_CBUS_REG(reg, val) __raw_writel(val, P_##reg)
#define READ_CBUS_REG(reg) (__raw_readl(P_##reg))
#define WRITE_CBUS_REG_BITS(reg, val, start, len) \
    clrsetbits_le32(P_##reg, (((1L<<(len))-1)<<(start)), \
    ((unsigned)((val)&((1L<<(len))-1)) << (start)))    
    
#define READ_CBUS_REG_BITS(reg, start, len) \
    ((__raw_readl(P_##reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_CBUS_REG_MASK(reg, mask) \
    clrbits_le32(P_##reg,mask)
#define SET_CBUS_REG_MASK(reg, mask)   \
    setbits_le32(P_##reg,mask)

#define WRITE_AXI_REG(reg, val) __raw_writel(val, P_##reg)
#define READ_AXI_REG(reg) (__raw_readl(P_##reg))
#define WRITE_AXI_REG_BITS(reg, val, start, len) \
    clrsetbits_le32(P_##reg, (((1L<<(len))-1)<<(start)), \
    ((unsigned)((val)&((1L<<(len))-1)) << (start)))
    
#define READ_AXI_REG_BITS(reg, start, len) \
    ((__raw_readl(P_##reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_AXI_REG_MASK(reg, mask) \
    clrbits_le32(P_##reg,mask)
#define SET_AXI_REG_MASK(reg, mask)   \
    setbits_le32(P_##reg,mask)


#define WRITE_AHB_REG(reg, val) __raw_writel(val, P_##reg)
#define READ_AHB_REG(reg) (__raw_readl(P_##reg))
#define WRITE_AHB_REG_BITS(reg, val, start, len) \
    clrsetbits_le32(P_##reg, (((1L<<(len))-1)<<(start)), \
    ((unsigned)((val)&((1L<<(len))-1)) << (start)))
    
#define READ_AHB_REG_BITS(reg, start, len) \
    ((__raw_readl(P_##reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_AHB_REG_MASK(reg, mask) \
    clrbits_le32(P_##reg,mask)
#define SET_AHB_REG_MASK(reg, mask)   \
    setbits_le32(P_##reg,mask)


#define WRITE_APB_REG(reg, val) __raw_writel(val, P_##reg)
#define READ_APB_REG(reg) (__raw_readl(P_##reg))
#define WRITE_APB_REG_BITS(reg, val, start, len) \
    clrsetbits_le32(P_##reg, (((1L<<(len))-1)<<(start)), \
    ((unsigned)((val)&((1L<<(len))-1)) << (start)))
    
#define READ_APB_REG_BITS(reg, start, len) \
    ((__raw_readl(P_##reg) >> (start)) & ((1L<<(len))-1))
#define CLEAR_APB_REG_MASK(reg, mask) \
    clrbits_le32(P_##reg,mask)
#define SET_APB_REG_MASK(reg, mask)   \
    setbits_le32(P_##reg,mask)


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

#include "reg_addr.h"

#endif
