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
		r = MPLL_CON_REG;
		m = (r>>16) & 0x3ff;
	} else if (pllreg == EPLL) {
		r = EPLL_CON_REG;
		m = (r>>16) & 0x1ff;
	} else
		hang();

	p = (r>>8) & 0x3f;
	s = r & 0x7;

	if (pllreg == APLL) 
		s= s-1;
	
	return (m * (CONFIG_SYS_CLK_FREQ / (p * (1 << s))));
}

/* return ARMCORE frequency */
ulong get_ARMCLK(void)
{
	ulong div,apll_ratio;

	div = CLK_DIV0_REG;
	apll_ratio = ((div>>0) & 0x7);

	return ((get_PLLCLK(APLL)) / (apll_ratio + 1));

}

/* return FCLK frequency */
ulong get_FCLK(void)
{
	return (get_PLLCLK(APLL));
}

/* return FCLK frequency */
ulong get_MPLL_CLK(void)
{
	return (get_PLLCLK(MPLL));
}


/* return HCLK frequency */
ulong get_HCLK(void)
{
	ulong fclk;
	uint mux_stat = CLK_MUX_STAT0_REG;
	uint div,hclk_msys_ratio,apll_ratio;

	div = CLK_DIV0_REG;

	apll_ratio = ((div>>0) & 0x7);
	hclk_msys_ratio = ((div>>8)&0x7);

	switch ((mux_stat>>16) & 0x7) {
	case 2: //SCLKMPLL source
		fclk = get_MPLL_CLK();
		break;
	case 1:	//SCLKAPLL source
	default:
		fclk = get_FCLK();
		break;
	}

	return fclk/((apll_ratio+1)*(hclk_msys_ratio+1));
}

/* return PCLK frequency */
ulong get_PCLK(void)
{
	ulong hclk;
	uint div = CLK_DIV0_REG;
	uint pclk_msys_ratio = ((div>>12) & 0x7);

	hclk = get_HCLK();	

	return hclk/(pclk_msys_ratio+1);
}

/* return HCLKDSYS frequency */
ulong get_HCLKD(void)
{
	ulong fclk;
	uint mux_stat = CLK_MUX_STAT0_REG;

	uint div,a2m_ratio,hclk_dsys_ratio;

	div = CLK_DIV0_REG;

	a2m_ratio = ((div >>4) & 0x7);
	hclk_dsys_ratio = ((div >>16) & 0xf);
	
	switch ((mux_stat>>20) & 0x7) {
	case 2: //SCLKA2M source
		fclk = get_FCLK()/(a2m_ratio+1);
		break;
	case 1:	//SCLKMPLL source
	default:
		fclk = get_MPLL_CLK();
		break;
	}

	return fclk/(hclk_dsys_ratio+1);
}

/* return PCLKDSYS frequency */
ulong get_PCLKD(void)
{
	ulong fclk;
	uint div = CLK_DIV0_REG;
	uint pclk_dsys_ratio = ((div>>20) & 0x7);

	fclk = get_HCLKD();	

	return fclk/(pclk_dsys_ratio+1);
}

/* return HCLKPSYS frequency */
ulong get_HCLKP(void)
{
	ulong fclk;
	uint mux_stat = CLK_MUX_STAT0_REG;
	uint div,hclk_psys_ratio,a2m_ratio;

	div = CLK_DIV0_REG;
	a2m_ratio = ((div >>4) & 0x7);
	hclk_psys_ratio = ((div>>24)&0xf);
	
	switch ((mux_stat>>20) & 0x7) {
	case 2: //SCLKA2M source
		fclk = get_FCLK()/(a2m_ratio+1);
		break;
	case 1:	//SCLKMPLL source
	default:
		fclk = get_MPLL_CLK();
		break;
	}


	return fclk/(hclk_psys_ratio+1);
}

/* return PCLKPSYS frequency */
ulong get_PCLKP(void)
{
	ulong fclk;
	uint div = CLK_DIV0_REG;
	uint pclk_psys_ratio = ((div>>28) & 0x7);

	fclk = get_HCLKP();	

	return fclk/(pclk_psys_ratio+1);
}

/* return SCLKA2M frequency */
ulong get_SCLKA2M(void)
{
	ulong fclk;
	uint div = CLK_DIV0_REG;
	uint a2m_ratio = ((div>>4) & 0x7);

	fclk = get_FCLK();	

	return fclk/(a2m_ratio+1);
}/* return UCLK frequency */
ulong get_UCLK(void)
{
	return (get_PLLCLK(EPLL));
}

