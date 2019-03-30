
/*
 * arch/arm/cpu/armv8/txl/hdmitx20/reg_ops.c
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

#include <common.h>
#include <asm/arch/io.h>
#include <asm/io.h>
#include "mach_reg.h"
#include "hdmitx_reg.h"
#include <amlogic/hdmi.h>


static int dbg_en;

void hd_write_reg(unsigned long addr, unsigned long val)
{
	if ((addr >= HDMITX_DWC_BASE_OFFSET) &&
		(addr <=HDMITX_TOP_BASE_OFFSET))
		writeb(val & 0xff, addr);
	else
		writel(val, addr);
	if (dbg_en)
		printk("W: 0x%08lx  0x%08lx %s 0x%08lx\n", addr, val, (val == hd_read_reg(addr)) ? "==" : "!=", hd_read_reg(addr));
}

unsigned long hd_read_reg(unsigned long addr)
{
	unsigned long val = 0;

	if ((addr >= HDMITX_DWC_BASE_OFFSET) &&
		(addr <=HDMITX_TOP_BASE_OFFSET))
		val = readb(addr);
	else
		val = readl(addr);
	if (dbg_en)
		printk("R: 0x%08lx   0x%08lx\n", addr, val);
	return val;
}

void hd_set_reg_bits(unsigned long addr, unsigned long value,
	unsigned long offset, unsigned long len)
{
	unsigned long data = 0;

	data = hd_read_reg(addr);
	data &= ~(((1L << len) - 1) << offset);
	data |= (value & ((1L << len) - 1)) << offset;
	hd_write_reg(addr, data);
}

#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"

unsigned int hdmitx_rd_reg(unsigned int addr)
{
	unsigned int large_offset = addr >> 24;
	unsigned int small_offset = addr & ((1 << 24)  - 1);
	unsigned int data;

	if (large_offset == 0x10)
		large_offset = HDMITX_DWC_BASE_OFFSET;
	else {
		large_offset = HDMITX_TOP_BASE_OFFSET;
		small_offset = small_offset << 2;
	}
	data = hd_read_reg(large_offset + small_offset);
	if (dbg_en)
		pr_info("%s wr[0x%x] 0x%x\n", large_offset ? "DWC" : "TOP",
			addr, data);
	return data;
}

void hdmitx_wr_reg(unsigned int addr, unsigned int data)
{
	unsigned int large_offset = addr >> 24;
	unsigned int small_offset = addr & ((1 << 24)  - 1);

	if (large_offset == 0x10)
		large_offset = HDMITX_DWC_BASE_OFFSET;
	else {
		large_offset = HDMITX_TOP_BASE_OFFSET;
		small_offset = small_offset << 2;
	}
	hd_write_reg(large_offset + small_offset, data);

	if (dbg_en)
		pr_info("%s wr[0x%x] 0x%x\n", large_offset ? "DWC" : "TOP",
			addr, data);
}

void hdmitx_set_reg_bits(unsigned int addr, unsigned int value,
	unsigned int offset, unsigned int len)
{
	unsigned int data32 = 0;

	data32 = hdmitx_rd_reg(addr);
	data32 &= ~(((1 << len) - 1) << offset);
	data32 |= (value & ((1 << len) - 1)) << offset;
	hdmitx_wr_reg(addr, data32);
}

void hdmitx_poll_reg(unsigned int addr, unsigned int val, unsigned long timeout)
{
	udelay(2000);
	if (!(hdmitx_rd_reg(addr) & val))
		pr_info("hdmitx poll:0x%x  val:0x%x t=%dms timeout\n",
			addr, val, 2000);
}

void hdmitx_rd_check_reg (unsigned long addr, unsigned long exp_data, unsigned long mask)
{
    unsigned long rd_data;
    rd_data = hdmitx_rd_reg(addr);
    if ((rd_data | mask) != (exp_data | mask)) {
        pr_info("HDMITX-DWC addr=0x%04x rd_data=0x%02x\n", (unsigned int)addr, (unsigned int)rd_data);
        pr_info("Error: HDMITX-DWC exp_data=0x%02x mask=0x%02x\n", (unsigned int)exp_data, (unsigned int)mask);
    }
}
