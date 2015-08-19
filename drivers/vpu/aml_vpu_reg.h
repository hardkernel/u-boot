
/*
 * drivers/vpu/aml_vpu_reg.h
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

#ifndef __VPU_REG_H__
#define __VPU_REG_H__
#include <asm/arch/io.h>
#include "aml_vpu.h"

/* ********************************
 * register define
 * ********************************* */
/* base & offset */
#define REG_BASE_AOBUS                  (0xc8100000L)
#define REG_BASE_CBUS                   (0xc1100000L)
#define REG_BASE_HIU                    (0xc883c000L)
#define REG_BASE_VCBUS                  (0xd0100000L)
#define REG_OFFSET_AOBUS(reg)           ((reg))
#define REG_OFFSET_CBUS(reg)            ((reg) << 2)
#define REG_OFFSET_HIU(reg)             ((reg) << 2)
#define REG_OFFSET_VCBUS(reg)           ((reg) << 2)
/* memory mapping */
#define REG_ADDR_AOBUS(reg)             (REG_BASE_AOBUS + REG_OFFSET_AOBUS(reg))
#define REG_ADDR_CBUS(reg)              (REG_BASE_CBUS + REG_OFFSET_CBUS(reg))
#define REG_ADDR_HIU(reg)               (REG_BASE_HIU + REG_OFFSET_HIU(reg))
#define REG_ADDR_RST(reg)               (REG_BASE_RST + REG_OFFSET_RST(reg))
#define REG_ADDR_VCBUS(reg)             (REG_BASE_VCBUS + REG_OFFSET_VCBUS(reg))


/* offset address */
#define AO_RTI_GEN_PWR_SLEEP0           ((0x00 << 10) | (0x3a << 2))

/* M8M2 register */
#define HHI_GP_PLL_CNTL                 0x1010
/* G9TV register */
#define HHI_GP1_PLL_CNTL                0x1016
#define HHI_GP1_PLL_CNTL2               0x1017
#define HHI_GP1_PLL_CNTL3               0x1018
#define HHI_GP1_PLL_CNTL4               0x1019

#define HHI_MEM_PD_REG0                 0x1040
#define HHI_VPU_MEM_PD_REG0             0x1041
#define HHI_VPU_MEM_PD_REG1             0x1042
/* GX register */
#define HHI_MEM_PD_REG0_GX              0x40
#define HHI_VPU_MEM_PD_REG0_GX          0x41
#define HHI_VPU_MEM_PD_REG1_GX          0x42

#define HHI_VPU_CLK_CNTL                0x106f
/* GX register */
#define HHI_VPU_CLK_CNTL_GX             0x6f
#define HHI_VPU_CLKB_CNTL_GX            0x83
#define HHI_VAPBCLK_CNTL_GX             0x7d

#define RESET0_REGISTER                 0x1101
#define RESET1_REGISTER                 0x1102
#define RESET2_REGISTER                 0x1103
#define RESET3_REGISTER                 0x1104
#define RESET4_REGISTER                 0x1105
#define RESET5_REGISTER                 0x1106
#define RESET6_REGISTER                 0x1107
#define RESET7_REGISTER                 0x1108
#define RESET0_MASK                     0x1110
#define RESET1_MASK                     0x1111
#define RESET2_MASK                     0x1112
#define RESET3_MASK                     0x1113
#define RESET4_MASK                     0x1114
#define RESET5_MASK                     0x1115
#define RESET6_MASK                     0x1116
#define RESET7_MASK                     0x1118
#define RESET0_LEVEL                    0x1120
#define RESET1_LEVEL                    0x1121
#define RESET2_LEVEL                    0x1122
#define RESET3_LEVEL                    0x1123
#define RESET4_LEVEL                    0x1124
#define RESET5_LEVEL                    0x1125
#define RESET6_LEVEL                    0x1126
#define RESET7_LEVEL                    0x1127

/* ********************************
 * register access api
 * ********************************* */
enum vpu_chip_e vpu_chip_type;

/* use offset address */
static inline unsigned int vpu_hiu_read(unsigned int _reg)
{
	//return __raw_readl(REG_ADDR_CBUS(_reg));
	//printf("read reg=0x%x\n", REG_ADDR_HIU(_reg));
	if (vpu_chip_type >= VPU_CHIP_GXBB)
		return *(volatile unsigned int *)(REG_ADDR_HIU(_reg));
	else
		return *(volatile unsigned int *)(REG_ADDR_CBUS(_reg));
};

static inline void vpu_hiu_write(unsigned int _reg, unsigned int _value)
{
	//__raw_writel(_value, REG_ADDR_CBUS(_reg));
	//printf("write reg=%u\n", REG_ADDR_HIU(_reg));
	if (vpu_chip_type >= VPU_CHIP_GXBB)
		*(volatile unsigned int *)REG_ADDR_HIU(_reg) = (_value);
	else
		*(volatile unsigned int *)REG_ADDR_CBUS(_reg) = (_value);
};

static inline void vpu_hiu_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	vpu_hiu_write(_reg, ((vpu_hiu_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int vpu_hiu_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (vpu_hiu_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void vpu_hiu_set_mask(unsigned int _reg, unsigned int _mask)
{
	vpu_hiu_write(_reg, (vpu_hiu_read(_reg) | (_mask)));
}

static inline void vpu_hiu_clr_mask(unsigned int _reg, unsigned int _mask)
{
	vpu_hiu_write(_reg, (vpu_hiu_read(_reg) & (~(_mask))));
}

static inline unsigned int vpu_cbus_read(unsigned int _reg)
{
	//return __raw_readl(REG_ADDR_CBUS(_reg));
	return (*(volatile unsigned int *)REG_ADDR_CBUS(_reg));
};

static inline void vpu_cbus_write(unsigned int _reg, unsigned int _value)
{
	//__raw_writel(_value, REG_ADDR_CBUS(_reg));
	*(volatile unsigned int *)REG_ADDR_CBUS(_reg) = (_value);
};

static inline void vpu_cbus_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	vpu_cbus_write(_reg, ((vpu_cbus_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int vpu_cbus_getb(unsigned int _reg,
		unsigned int _start, unsigned int _len)
{
	return (vpu_cbus_read(_reg) >> (_start)) & ((1L << (_len)) - 1);
}

static inline void vpu_cbus_set_mask(unsigned int _reg, unsigned int _mask)
{
	vpu_cbus_write(_reg, (vpu_cbus_read(_reg) | (_mask)));
}

static inline void vpu_cbus_clr_mask(unsigned int _reg, unsigned int _mask)
{
	vpu_cbus_write(_reg, (vpu_cbus_read(_reg) & (~(_mask))));
}

static inline unsigned int vpu_aobus_read(unsigned int _reg)
{
	//return readl(REG_ADDR_AOBUS(_reg));
	return (*(volatile unsigned int *)REG_ADDR_AOBUS(_reg));
};

static inline void vpu_aobus_write(unsigned int _reg, unsigned int _value)
{
	//writel(_value, REG_ADDR_AOBUS(_reg));
	*(volatile unsigned int *)REG_ADDR_AOBUS(_reg) = (_value);
};

static inline void vpu_ao_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	vpu_aobus_write(_reg, ((vpu_aobus_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int vpu_vcbus_read(unsigned int _reg)
{
	return (*(volatile unsigned int *)REG_ADDR_VCBUS(_reg));
};

static inline void vpu_vcbus_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_VCBUS(_reg) = (_value);
};

#endif
