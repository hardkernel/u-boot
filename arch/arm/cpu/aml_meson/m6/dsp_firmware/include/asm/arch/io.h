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
#ifdef __KERNEL__
#include <asm/io.h>
#else
#if 0
_Asm unsigned READ_VOLATILE_UINT32_(unsigned addr)
{
    % reg addr
    ld.di %r0, [addr]
    add  %r0, %r0, 0
}
#else
//static unsigned READ_VOLATILE_UINT32_(unsigned addr)
//{
//	return (*((volatile unsigned int*)(addr)));
//}
#endif
//#define READ_VOLATILE_UINT32(addr)  READ_VOLATILE_UINT32_((unsigned)(addr))
void __raw_writel(unsigned val,unsigned reg);
unsigned __raw_readl(unsigned reg);

#define writel __raw_writel
#define readl __raw_readl

#define setbits_le32(reg,mask)  writel(readl(reg)|(mask),reg)
#define clrbits_le32(reg,mask)  writel(readl(reg)&(~(mask)),reg)
#define clrsetbits_le32(reg,clr,mask)  writel((readl(reg)&(~(clr)))|(mask),reg)
#endif
#define IO_CBUS_BASE			0xc1100000
#define IO_AXI_BUS_BASE			0xc1300000
#define IO_AHB_BUS_BASE			0xc9000000
#define IO_APB_BUS_BASE			0xc8000000
#define IO_USB_A_BASE			0xc9040000
#define IO_USB_B_BASE			0xc90C0000

#define MESON_PERIPHS1_VIRT_BASE	0xc1108400
#define MESON_PERIPHS1_PHYS_BASE	0xc1108400

#define CBUS_REG_OFFSET(reg) ((reg) << 2)
#define CBUS_REG_ADDR(reg)	 (IO_CBUS_BASE + CBUS_REG_OFFSET(reg))

#define AXI_REG_OFFSET(reg)  ((reg) << 2)
#define AXI_REG_ADDR(reg)	 (IO_AXI_BUS_BASE + AXI_REG_OFFSET(reg))

#define AHB_REG_OFFSET(reg)  ((reg) << 2)
#define AHB_REG_ADDR(reg)	 (IO_AHB_BUS_BASE + AHB_REG_OFFSET(reg))

#define APB_REG_OFFSET(reg)  (reg)
#define APB_REG_ADDR(reg)	 (IO_APB_BUS_BASE + APB_REG_OFFSET(reg))
#define APB_REG_ADDR_VALID(reg) (((unsigned long)(reg) & 3) == 0)


#define WRITE_CBUS_REG(reg, val) __raw_writel(val, P_##reg)
#define READ_CBUS_REG(reg) (__raw_readl(P_##reg))
#define WRITE_CBUS_REG_BITS(reg, val, start, len) \
    clrsetbits_le32(P_##reg,~(((1L<<(len))-1)<<(start)), \
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
    clrsetbits_le32(P_##reg,~(((1L<<(len))-1)<<(start)), \
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
    clrsetbits_le32(P_##reg,~(((1L<<(len))-1)<<(start)), \
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
    clrsetbits_le32(P_##reg,~(((1L<<(len))-1)<<(start)), \
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
