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
#include <asm/io.h>
#include <mmc.h>
#include <asm/arch/cpu.h>
#include <asm/arch/s3c_hsmmc.h>

void clear_hsmmc_clock_div(void)
{
#if defined(CONFIG_EXYNOS4212) || defined(CONFIG_ARCH_EXYNOS5)
	CLK_DIV_FSYS1 = 0x000f000f;
	CLK_DIV_FSYS2 = 0x000f000f;
	CLK_DIV_FSYS3 = 0x00000300;
#else
	CLK_DIV_FSYS1 = 0x00070007;
	CLK_DIV_FSYS2 = 0x00070007;
	CLK_DIV_FSYS3 = 0x00000400;
#endif
}

void set_hsmmc_pre_ratio (struct sdhci_host *host, uint clock)
{
	u32 div;
	u32 tmp;
	u32 clk;
	u32 i;

#ifdef USE_MMC0
	/* MMC2 clock div */
	div = CLK_DIV_FSYS1 & ~(0xff000000);
	tmp = CLK_DIV_FSYS1 & (0x000f0000);

	clk = get_MPLL_CLK();
	clk = clk / (tmp + 1);
	for(i=0 ; i<=0xff; i++)
	{
		if((clk /(i+1)) <= clock) {
			CLK_DIV_FSYS1 = tmp | i<<24;
			break;
		}
	}
#endif
#ifdef USE_MMC2
	/* MMC2 clock div */
	div = CLK_DIV_FSYS2 & ~(0x0000ff00);
	tmp = CLK_DIV_FSYS2 & (0x0000000f);

	clk = get_MPLL_CLK();
#if 1
	clk = clk / (tmp + 1);

	for(i=0 ; i<=0xff; i++)
	{
		if((clk /(i+1)) <= clock) {
			CLK_DIV_FSYS2 = tmp | i<<8;
			break;
		}
	}
#else 
	CLK_DIV_FSYS2 = 0x000f000f;
#endif 
#endif
}

void setup_hsmmc_clock(void)
{
	u32 tmp;
	u32 clock;
	u32 i;

#ifdef USE_MMC0
	/* MMC0 clock src = SCLKMPLL */
	tmp = CLK_SRC_FSYS & ~(0x0000000f);
	CLK_SRC_FSYS = tmp | 0x00000006;

	/* MMC0 clock div */
	tmp = CLK_DIV_FSYS1 & ~(0x0000000f);
	clock = get_MPLL_CLK()/1000000;
	for(i=0; i<= 0xf; i++)
	{
	//	if((clock / (i+1)) <= 90) {
		if((clock / (i+1)) <= 50) {
			CLK_DIV_FSYS1 = tmp | i<<0;
			break;
		}
	}
#endif

#ifdef USE_MMC1
#endif	

#ifdef USE_MMC2
	/* MMC2 clock src = SCLKMPLL */
	tmp = CLK_SRC_FSYS & ~(0x00000f00);
	CLK_SRC_FSYS = tmp | 0x00000600;

	/* MMC2 clock div */
	tmp = CLK_DIV_FSYS2 & ~(0x0000000f);
	clock = get_MPLL_CLK()/1000000;
	for(i=0; i<= 0xf; i++)
	{
		if((clock / (i+1)) <= 90) {
		//if((clock / (i+1)) <= 50) {
		//if((clock / (i+1)) <= 40) {
			CLK_DIV_FSYS2 = tmp | i<<0;
			break;
		}
	}
#endif

#ifdef USE_MMC3
#endif	

#ifdef USE_MMC4
	/* MMC4 clock src = SCLKMPLL */
	tmp = CLK_SRC_FSYS & ~(0x000f0000);
	CLK_SRC_FSYS = tmp | 0x00060000;

	/* MMC4 clock div */
	tmp = CLK_DIV_FSYS3 & ~(0x0000ff0f);
	clock = get_MPLL_CLK()/1000000;
	for(i=0 ; i<=0xf; i++)
	{
#if defined(CONFIG_EXYNOS4212) || defined(CONFIG_EXYNOS5)
		if((clock /(i+1)) <= 170) {
#else
		if((clock /(i+1)) <= 160) {
#endif
			CLK_DIV_FSYS3 = tmp | i<<8;
			break;
		}
	}
#endif
}

/*
 * this will set the GPIO for hsmmc ch0
 * GPG0[0:6] = CLK, CMD, CDn, DAT[0:3]
 */
void setup_hsmmc_cfg_gpio(void)
{
#ifdef USE_MMC0
	writel(0x02222222, GPIO_CON_MMC0_1);
	writel(0x00003FF0, GPIO_CON_MMC0_1 + GPIO_PUD_OFFSET);
	writel(0x00003FFF, GPIO_CON_MMC0_1 + GPIO_DRV_OFFSET);

	writel(0x03333000, GPIO_CON_MMC0_2);
	writel(0x00003FF0, GPIO_CON_MMC0_2 + GPIO_PUD_OFFSET);
	writel(0x00003FFF, GPIO_CON_MMC0_2 + GPIO_DRV_OFFSET);
#endif

#ifdef USE_MMC1
#endif

#ifdef USE_MMC2
	writel(0x02222222, GPIO_CON_MMC2_1);
	writel(0x00003FF0, GPIO_CON_MMC2_1 + GPIO_PUD_OFFSET);
	writel(0x00003FFF, GPIO_CON_MMC2_1 + GPIO_DRV_OFFSET);
	/* 8 bit supprot */
	writel(0x03333000, GPIO_CON_MMC2_2);
	writel(0x00003FF0, GPIO_CON_MMC2_2 + GPIO_PUD_OFFSET);
	writel(0x00003FFF, GPIO_CON_MMC2_2 + GPIO_DRV_OFFSET);
#endif

#ifdef USE_MMC3
#endif

#ifdef USE_MMC4
	writel(0x03333333, GPIO_CON_MMC4_1);
	writel(0x00003FF0, GPIO_CON_MMC4_1 + GPIO_PUD_OFFSET);
	writel(0x00002AAA, GPIO_CON_MMC4_1 + GPIO_DRV_OFFSET);

#if defined(CONFIG_HKDK4212)
	writel(0x04444100, GPIO_CON_MMC4_2);
	writel(0x00003FF0, GPIO_CON_MMC4_2 + GPIO_PUD_OFFSET);
	writel(0x00002AA0, GPIO_CON_MMC4_2 + GPIO_DRV_OFFSET);
#else
	writel(0x04444000, GPIO_CON_MMC4_2);
	writel(0x00003FC0, GPIO_CON_MMC4_2 + GPIO_PUD_OFFSET);
	writel(0x00002A80, GPIO_CON_MMC4_2 + GPIO_DRV_OFFSET);
#endif

#ifndef	CONFIG_ARCH_EXYNOS5
	/* Drive Strength */
	writel(0x00010001, 0x1255009C);	
#endif

#endif
}


void setup_sdhci0_cfg_card(struct sdhci_host *host)
{
	u32 ctrl2;
	u32 ctrl3;

	/* don't need to alter anything acording to card-type */
	writel(S3C_SDHCI_CONTROL4_DRIVE_9mA, host->ioaddr + S3C_SDHCI_CONTROL4);

	ctrl2 = readl(host->ioaddr + S3C_SDHCI_CONTROL2);
	ctrl3 = readl(host->ioaddr + S3C_SDHCI_CONTROL3);

	ctrl2 |= (S3C_SDHCI_CTRL2_ENSTAASYNCCLR |
		S3C_SDHCI_CTRL2_ENCMDCNFMSK |
		S3C_SDHCI_CTRL2_DFCNT_NONE |
		S3C_SDHCI_CTRL2_ENCLKOUTHOLD);

	if (0 <= host->clock && host->clock < 25000000) {
		/* Feedback Delay Disable */
		ctrl2 &= ~(S3C_SDHCI_CTRL2_ENFBCLKTX |
			S3C_SDHCI_CTRL2_ENFBCLKRX);
		ctrl3 &= ~(1 << 31 | 1 << 23 | 1 << 15 | 1 << 7);

	} else if (25000000 <= host->clock && host->clock <= 52000000) {
#ifdef CONFIG_HKDK4412
		/* Feedback Delay Enable */
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKTX | S3C_SDHCI_CTRL2_ENFBCLKRX);

		ctrl3 |= (1 << 31 | 1 << 23 | 1 << 15 | 1 << 7);
#else
		/* Feedback Delay Disable */
		ctrl2 &= ~(S3C_SDHCI_CTRL2_ENFBCLKTX |
			S3C_SDHCI_CTRL2_ENFBCLKRX);
		/* Feedback Delay Rx Enable */
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKRX);
		ctrl3 &= ~(1 << 31 | 1 << 23 | 1 << 15 | 1 << 7);
		ctrl3 |= (1 << 15 | 1 << 7);
#endif
		
	} else
		printf("This CLOCK is Not Support: %d\n", host->clock);

	writel(ctrl2, host->ioaddr + S3C_SDHCI_CONTROL2);
	writel(ctrl3, host->ioaddr + S3C_SDHCI_CONTROL3);
}

