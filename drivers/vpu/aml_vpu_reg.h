
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
#include <asm/arch/secure_apb.h>
#include "aml_vpu.h"
#include "aml_vpu_dummy_reg.h"

/* ********************************
 * register define
 * ********************************* */
/* offset */
#define REG_OFFSET_CBUS(reg)        (((reg) << 2))
#define REG_OFFSET_VCBUS(reg)       (((reg) << 2))

/* memory mapping */
#define REG_ADDR_AOBUS(reg)         (reg + 0L)
#define REG_ADDR_HIU(reg)           (reg + 0L)
#define REG_ADDR_CBUS(reg)          (REG_BASE_CBUS + REG_OFFSET_CBUS(reg))
#define REG_ADDR_VCBUS(reg)         (REG_BASE_VCBUS + REG_OFFSET_VCBUS(reg))

/* ********************************
 * register access api
 * ********************************* */
static inline unsigned int vpu_hiu_read(unsigned int _reg)
{
	unsigned int val = 0;

	val = *(volatile unsigned int *)(REG_ADDR_HIU(_reg));

	return val;
};

static inline void vpu_hiu_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_HIU(_reg) = (_value);
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

static inline unsigned int vpu_vcbus_read(unsigned int _reg)
{
	unsigned int val = 0;
	val = *(volatile unsigned int *)(REG_ADDR_VCBUS(_reg));
	return val;
};

static inline void vpu_vcbus_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_VCBUS(_reg) = (_value);
};

static inline void vpu_vcbus_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	vpu_vcbus_write(_reg, ((vpu_vcbus_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

static inline unsigned int vpu_cbus_read(unsigned int _reg)
{
	unsigned int val = 0;
	val = *(volatile unsigned int *)(REG_ADDR_CBUS(_reg));
	return val;
};

static inline void vpu_cbus_write(unsigned int _reg, unsigned int _value)
{
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
	unsigned int val = 0;

	val = *(volatile unsigned int *)(REG_ADDR_AOBUS(_reg));
	return val;
};

static inline void vpu_aobus_write(unsigned int _reg, unsigned int _value)
{
	*(volatile unsigned int *)REG_ADDR_AOBUS(_reg) = (_value);
};

static inline void vpu_ao_setb(unsigned int _reg, unsigned int _value,
		unsigned int _start, unsigned int _len)
{
	vpu_aobus_write(_reg, ((vpu_aobus_read(_reg) &
			~(((1L << (_len))-1) << (_start))) |
			(((_value)&((1L<<(_len))-1)) << (_start))));
}

#endif
