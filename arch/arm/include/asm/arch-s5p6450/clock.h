/*
 * (C) Copyright 2009 Samsung Electronics
 * Minkyu Kang <mk7.kang@samsung.com>
 * Heungjun Kim <riverful.kim@samsung.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 *
 */

#ifndef __ASM_ARM_ARCH_CLOCK_H_
#define __ASM_ARM_ARCH_CLOCK_H_

#ifndef __ASSEMBLY__
struct s5p6450_clock {
	unsigned int	apll_lock;
	unsigned int	mpll_lock;
	unsigned int	epll_lock;
	unsigned int	apll_con;
	unsigned int	mpll_con;
	unsigned int	epll_con;
	unsigned int	epll_con_k;
	unsigned int	src0;
	unsigned int	div0;
	unsigned int	div1;
	unsigned int	div2;
	unsigned int	clk_out0;
	unsigned int	gate_hclk_0;
	unsigned int	gate_pclk;
	unsigned int	gate_sclk_0;
	unsigned int	gate_mem_0;
	unsigned int	div3;
	unsigned int	gate_hclk_1;
	unsigned int	gate_sclk_1;
	unsigned int	clk_out1;
	unsigned int	dpll_con;
	unsigned int	dpll_con_k;
	unsigned int	dpll_lock;
        unsigned int    res[44];
	unsigned int	src1;
};
#endif

#endif
