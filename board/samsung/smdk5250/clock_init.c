/*
 * Clock setup for SMDK5250 board based on EXYNOS5
 *
 * Copyright (C) 2012 Samsung Electronics
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

#include <config.h>
#include <version.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/power.h>
#include <asm/arch/cpu.h>
#include <asm/arch/gpio.h>
#include "setup.h"

void system_clock_init()
{
	struct exynos5_clock *clk = (struct exynos5_clock *)EXYNOS5_CLOCK_BASE;
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;

	/*
	 * MUX_APLL_SEL[0]: FINPLL = 0
	 * MUX_CPU_SEL[6]: MOUTAPLL = 0
	 * MUX_HPM_SEL[20]: MOUTAPLL = 0
	 */
	writel(readl(&clk->src_cpu) & ~(0x1), &clk->src_cpu);

	/* MUX_MPLL_SEL[8]: 0*/
	writel(readl(&clk->src_core1) & ~(0x100), &clk->src_core1);

	/*
	 * VPLLSRC_SEL[0]: FINPLL = 0
	 * MUX_{CPLL[8]}|{EPLL[12]}|{VPLL[16]|{GPLL[28]}_SEL: FINPLL = 0
	 */
	writel(readl(&clk->src_top2) & ~(0x10011100), &clk->src_top2);

	/* MUX_BPLL_SEL[0]: 0 */
	writel(readl(&clk->src_cdrex) & ~(0x1), &clk->src_cdrex);

	/* PLL locktime */
	writel(APLL_LOCK_VAL, &clk->apll_lock);

	writel(MPLL_LOCK_VAL, &clk->mpll_lock);

	writel(BPLL_LOCK_VAL, &clk->bpll_lock);

	writel(CPLL_LOCK_VAL, &clk->cpll_lock);

	writel(GPLL_LOCK_VAL, &clk->gpll_lock);

	writel(EPLL_LOCK_VAL, &clk->epll_lock);

	writel(VPLL_LOCK_VAL, &clk->vpll_lock);

	sdelay(0x10000);

	/* Set BPLL, MPLL fixed Divider 2 */
	writel(0x0, &clk->pll_div2_sel);

	/*
	 * MUX_APLL_SEL[0]: FINPLL = 0
	 * MUX_CPU_SEL[6]: MOUTAPLL = 0
	 * MUX_HPM_SEL[20]: MOUTAPLL = 0
	 */
	writel(0x00100000, &clk->src_cpu);

	/* Set Clock Ratios */
	writel(CLK_DIV_CPU0_VAL, &clk->div_cpu0);

	/* Set COPY and HPM Ratio */
	writel(CLK_DIV_CPU1_VAL, &clk->div_cpu1);

	/* Set APLL */
	writel(APLL_CON1_VAL, &clk->apll_con1);
	writel(APLL_CON0_VAL, &clk->apll_con0);
	sdelay(0x30000);

	/* Set MPLL */
	writel(MPLL_CON1_VAL, &clk->mpll_con1);
	writel(MPLL_CON0_VAL, &clk->mpll_con0);
	sdelay(0x30000);
	writel(BPLL_CON1_VAL, &clk->bpll_con1);
	writel(BPLL_CON0_VAL, &clk->bpll_con0);
	sdelay(0x30000);

	/* Set CPLL */
	writel(CPLL_CON1_VAL, &clk->cpll_con1);
	writel(CPLL_CON0_VAL, &clk->cpll_con0);
	sdelay(0x30000);

	/* Set CPLL */
	writel(GPLL_CON1_VAL, &clk->gpll_con1);
	writel(GPLL_CON0_VAL, &clk->gpll_con0);
	sdelay(0x30000);

	/* Set EPLL */
	writel(EPLL_CON2_VAL, &clk->epll_con2);
	writel(EPLL_CON1_VAL, &clk->epll_con1);
	writel(EPLL_CON0_VAL, &clk->epll_con0);
	sdelay(0x30000);

	/* Set VPLL */
	writel(VPLL_CON2_VAL, &clk->vpll_con2);
	writel(VPLL_CON1_VAL, &clk->vpll_con1);
	writel(VPLL_CON0_VAL, &clk->vpll_con0);
	sdelay(0x30000);

	/* MUX_PWI_SEL[19:16]: XXTI = 0 */
	writel(CLK_SRC_CORE0_VAL, &clk->src_core0);

	/* CORED_RATIO, COREP_RATIO */
	writel(CLK_DIV_CORE0_VAL, &clk->div_core0);

	/* PWI_RATIO[11:8], DVSEM_RATIO[22:16], DPM_RATIO[24:20] */
	writel(CLK_DIV_CORE1_VAL, &clk->div_core1);

	/*
	 * ACLK_C2C_200_RATIO[10:8]
	 * C2C_CLK_400_RATIO[6:4]
	 * ACLK_R1BX_RATIO[2:0]
	 */
	writel(CLK_DIV_SYSRGT_VAL, &clk->div_sysrgt);

	/* ACLK|PLCK_ACP_RATIO */
	writel(CLK_DIV_ACP_VAL, &clk->div_acp);

	/*
	 * EFCLK_SYSLFT_RATIO[11:8]
	 * PCLK_SYSLFT_RATIO[6:4]
	 * ACLK_SYSLFT_RATIO[2:0]
	 */
	writel(CLK_DIV_SYSLFT_VAL, &clk->div_syslft);

	/* MUX_ACLK_* Clock Selection */
	writel(CLK_SRC_TOP0_VAL, &clk->src_top0);

	/* MUX_ACLK_* Clock Selection */
	writel(CLK_SRC_TOP1_VAL, &clk->src_top1);

	/* MUX_ACLK_* Clock Selection */
	writel(0x01100000, &clk->src_top2);

	/* MUX_ACLK_* Clock Selection */
	writel(CLK_SRC_TOP3_VAL, &clk->src_top3);

	/* ACLK_*_RATIO */
	writel(CLK_DIV_TOP0_VAL, &clk->div_top0);

	/* ACLK_*_RATIO */
	writel(CLK_DIV_TOP1_VAL, &clk->div_top1);

	/* MUX_ATCLK_LEX[0]: ACLK_200 = 0 */
	writel(readl(&clk->src_lex) | CLK_SRC_LEX_VAL, &clk->src_lex);

	/* {PCLK[4:6]|ATCLK[10:8]}_RATIO */
	writel(CLK_DIV_LEX_VAL, &clk->div_lex);

	/* PCLK_R0X_RATIO[3:0] */
	writel(CLK_DIV_R0X_VAL, &clk->div_r0x);

	/* PCLK_R1X_RATIO[3:0] */
	writel(CLK_DIV_R1X_VAL, &clk->div_r1x);

	/* MUX_BPLL_SEL[0]: FINPLL = 0*/
	writel(CLK_SRC_CDREX_INIT_VAL, &clk->src_cdrex);

	/* CDREX Ratio */
	writel(CLK_DIV_CDREX_INIT_VAL, &clk->div_cdrex);

	/* After Initiallising th PLL select the sources accordingly */
	/* MUX_APLL_SEL[0]: MOUTAPLLFOUT = 1 */
	writel(readl(&clk->src_cpu) | CLK_SRC_CPU_VAL, &clk->src_cpu);

	/*
	 * VPLLSRC_SEL[0]: FINPLL = 0
	 * MUX_{CPLL[8]}|{EPLL[12]}|{VPLL[16]}_SEL: MOUT{CPLL|EPLL|VPLL} = 1
	 * MUX_{MPLL[20]}|{BPLL[24]}_USER_SEL: FOUT{MPLL|BPLL} = 1
	 */
	writel(readl(&clk->src_top2) | CLK_SRC_TOP2_VAL, &clk->src_top2);

	/* MUX_MPLL_SEL[8]: MOUTMPLLFOUT = 1 */
	writel(readl(&clk->src_core1) | CLK_SRC_CORE1_VAL, &clk->src_core1);

	/* Set Clock Ratios */
	/* SATA[24]: SCLKMPLL=0, MMC[0-4]: SCLKMPLL = 6 */
	writel(CLK_SRC_FSYS_VAL, &clk->src_fsys);

	/* SATA_RATIO, USB_DRD_RATIO */
	writel(CLK_DIV_FSYS0_VAL, &clk->div_fsys0);

	/* UART [0-5]: SCLKMPLL = 6 */
	writel(CLK_SRC_PERIC0_VAL, &clk->src_peric0);

	/* UART[0-4] */
	writel(CLK_DIV_PERIC0_VAL, &clk->div_peric0);

	/* disable CLKOUT_CMU */
	writel(0x0, &clk->clkout_cmu_cpu);
	writel(0x0, &clk->clkout_cmu_core);
	writel(0x0, &clk->clkout_cmu_acp);
	writel(0x0, &clk->clkout_cmu_top);
	writel(0x0, &clk->clkout_cmu_lex);
	writel(0x0, &clk->clkout_cmu_r0x);
	writel(0x0, &clk->clkout_cmu_r1x);
	writel(0x0, &clk->clkout_cmu_cdrex);
	writel(0x0, &pmu->fsys_arm_configuration);
	writel(0x0, &pmu->sata_phy_control);

}
