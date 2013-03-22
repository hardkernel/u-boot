/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */
 
#include <common.h>
#include <asm/arch/cpu.h>

unsigned long (*get_uart_clk)(int dev_index);
unsigned long (*get_pwm_clk)(void);
unsigned long (*get_arm_clk)(void);
unsigned long (*get_pll_clk)(int);

void s5p_clock_init(void)
{
}

#define APLL 0
#define MPLL 1
#define EPLL 2
#define VPLL 3


/* ------------------------------------------------------------------------- */
/* NOTE: This describes the proper use of this file.
 *
 * CONFIG_SYS_CLK_FREQ should be defined as the input frequency of the PLL.
 *
 * get_FCLK(), get_HCLK(), get_PCLK() and get_UCLK() return the clock of
 * the specified bus in HZ.
 */
/* ------------------------------------------------------------------------- */

static ulong get_PLLCLK(int pllreg)
{
	ulong r, m, p, s;

	if (pllreg == APLL) {
		r = APLL_CON0_REG;
		m = (r>>16) & 0x3ff;
	} else if (pllreg == MPLL) {
		r = MPLL_CON0_REG;
		m = (r>>16) & 0x3ff;
	} else
		hang();

	p = (r>>8) & 0x3f;
	s = r & 0x7;

	if ((pllreg == APLL) || (pllreg == MPLL)) 
		s= s-1;
	
	return (m * (CONFIG_SYS_CLK_FREQ / (p * (1 << s))));
}

ulong get_APLL_CLK(void)
{
	return (get_PLLCLK(APLL));
}

ulong get_MPLL_CLK(void)
{
	return (get_PLLCLK(MPLL));
}

