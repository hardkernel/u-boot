/*
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
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
 */

#ifndef __BL2_IO_H_
#define __BL2_IO_H_

#define writel(val,reg) (*((volatile unsigned *)(reg)))=(val)
#define readl(reg)		(*((volatile unsigned *)(reg)))
#define setbits_le32(reg,val)	(*((volatile unsigned *)(reg)))|=(val)
#define clrbits_le32(reg,val)	(*((volatile unsigned *)(reg)))&=(~(val))
#define clrsetbits_le32(reg,clr,set)	{unsigned __v=readl(reg);__v&=(~(clr));__v|=(set);writel(__v,reg);}

typedef unsigned int uint32_t;

#endif /*__BL2_IO_H_*/