/*
 * Copyright (C) 2009 Samsung Electronics
 * Minkyu Kang <mk7.kang@samsung.com>
 * Heungjun Kim <riverful.kim@samsung.com>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
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
 */

#include <common.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/clk.h>
#include <asm/arch/cpu.h>

unsigned long (*get_uart_clk)(int dev_index);
unsigned long (*get_pwm_clk)(void);
unsigned long (*get_arm_clk)(void);
unsigned long (*get_pll_clk)(int);

/* s5p6450: return pll clock frequency */
static unsigned long s5p6450_get_pll_clk(int pllreg)
{
	struct s5p6450_clock *clk =
		(struct s5p6450_clock *)samsung_get_base_clock();
	unsigned long r, m, p, s, mask, fout;
	unsigned int freq;

	switch (pllreg) {
	case APLL:
		r = readl(&clk->apll_con);
		break;
	case MPLL:
		r = readl(&clk->mpll_con);
		break;
	case EPLL:
		r = readl(&clk->epll_con);
		break;
	case DPLL:
		r = readl(&clk->dpll_con);
		break;
	default:
		printf("Unsupported PLL (%d)\n", pllreg);
		return 0;
	}

	/*
	 * APLL_CON: MIDV [25:16]
	 * MPLL_CON: MIDV [23:16]
	 * EPLL_CON: MIDV [23:16]
	 * HPLL_CON: MIDV [23:16]
	 */
	if (pllreg == APLL)
		mask = 0x3ff;
	else
		mask = 0x3ff;

	m = (r >> 16) & mask;

	/* PDIV [13:8] */
	p = (r >> 8) & 0x3f;
	/* SDIV [2:0] */
	s = r & 0x7;

	/* FOUT = MDIV * FIN / (PDIV * 2^SDIV) */
	freq = CONFIG_SYS_CLK_FREQ;
	fout = m * (freq / (p * (1 << s)));

	return fout;
}

/* s5p6450: return ARM clock frequency */
static unsigned long s5p6450_get_arm_clk(void)
{
	struct s5p6450_clock *clk =
		(struct s5p6450_clock *)samsung_get_base_clock();
	unsigned long div;
	unsigned long dout_apll, armclk;
	unsigned int apll_ratio;

	div = readl(&clk->div3);

	/* APLL_RATIO: [2:0] */
	apll_ratio = div & 0x7;

	dout_apll = get_pll_clk(APLL) / (apll_ratio + 1);
	armclk = dout_apll;

	return armclk;
}


/* s5p6450: return HCLKD0 frequency */
static unsigned long get_hclk(void)
{
	struct s5p6450_clock *clk =
		(struct s5p6450_clock *)samsung_get_base_clock();
	unsigned long hclkd0;
	uint div, d0_bus_ratio;

	div = readl(&clk->div0);
	/* D0_BUS_RATIO: [10:8] */
	d0_bus_ratio = (div >> 8) & 0x7;

	hclkd0 = get_arm_clk() / (d0_bus_ratio + 1);

	return hclkd0;
}

/* s5p6450: return HCLKs frequency */
static unsigned long get_hclk_sys_low(void)
{
	struct s5p6450_clock *clk =
		(struct s5p6450_clock *)samsung_get_base_clock();
	unsigned long hclk;
	unsigned int div;
	unsigned int offset;
	unsigned int hclk_sys_ratio;

	div = readl(&clk->div3);

	offset = 8;

	hclk_sys_ratio = (div >> offset) & 0xf;

	hclk = get_pll_clk(MPLL) / (hclk_sys_ratio + 1);

	return hclk;
}

/* s5p6450: return PCLKs frequency */
static unsigned long get_pclk_sys(void)
{
	struct s5p6450_clock *clk =
		(struct s5p6450_clock *)samsung_get_base_clock();
	unsigned long pclk;
	unsigned int div;
	unsigned int offset;
	unsigned int pclk_sys_ratio;

	div = readl(&clk->div3);

	offset = 12;

	pclk_sys_ratio = (div >> offset) & 0xf;

	pclk = get_hclk_sys_low() / (pclk_sys_ratio + 1);

	return pclk;
}

/* s5p6450: return PCLKs frequency */
static unsigned long get_pclk_pwm(void)
{
	struct s5p6450_clock *clk =
		(struct s5p6450_clock *)samsung_get_base_clock();
	unsigned long pclk;
	unsigned int div;
	unsigned int pclk_div0;
	unsigned int pclk_div1;

	div = readl(&clk->div3);

	pclk_div0 = ((div >> 16) & 0xf) + 1;

	pclk_div1 = ((div >> 20) & 0xf) + 1;

	pclk =  get_pll_clk(MPLL) / (pclk_div0 * pclk_div1);

	return pclk;
}

/* s5p6450: return peripheral clock frequency */
static unsigned long s5p6450_get_pclk(void)
{
	return get_pclk_sys();
}

/* s5p6450: return uart clock frequency */
static unsigned long s5p6450_get_uart_clk(int dev_index)
{
	return s5p6450_get_pclk();
}

/* s5p6450: return pwm clock frequency */
static unsigned long s5p6450_get_pwm_clk(void)
{
	return get_pclk_pwm();
}

void s5p_clock_init(void)
{
	get_pll_clk = s5p6450_get_pll_clk;
	get_arm_clk = s5p6450_get_arm_clk;

	get_uart_clk = s5p6450_get_uart_clk;
	get_pwm_clk = s5p6450_get_pwm_clk;
}

ulong get_APLL_CLK(void)
{
	return (s5p6450_get_pll_clk(APLL));
}

ulong get_MPLL_CLK(void)
{
	return (s5p6450_get_pll_clk(MPLL));
}
