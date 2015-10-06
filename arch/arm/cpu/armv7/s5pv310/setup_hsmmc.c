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
	CLK_DIV_FSYS1 = 0x00070007;
	CLK_DIV_FSYS2 = 0x00070007;
	CLK_DIV_FSYS3 = 0x00000400;
}

void set_hsmmc_pre_ratio (struct sdhci_host *host, uint clock)
{
	u32 div;
	u32 tmp;
	/* XXX: we assume that clock is between 40MHz and 50MHz */
	if (clock <= 400000)
		div = 127;
	else if (clock <= 20000000)
		div = 3;
	else if (clock <= 26000000)
		div = 1;
	else
		div = 0;

#ifdef USE_MMC0
	tmp = CLK_DIV_FSYS1 & ~(0x0000ff00);
	CLK_DIV_FSYS1 = tmp | (div << 8);
#endif
#ifdef USE_MMC2
	tmp = CLK_DIV_FSYS2 & ~(0x0000ff00);
	CLK_DIV_FSYS2 = tmp | (div << 8);
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
	clock = 800;//get_MPLL_CLK()/1000000;
	for(i=0; i<= 0xf; i++)
	{
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
	clock = 800;//get_MPLL_CLK()/1000000;
	for(i=0; i<= 0xf; i++)
	{
		if((clock / (i+1)) <= 50) {
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
	clock = 800;//get_MPLL_CLK()/1000000;
	for(i=0 ; i<=0xf; i++)
	{
		if((clock /(i+1)) <= 160) {
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
	writel(0x02222222, 0x11000040);
	writel(0x00003FF0, 0x11000048);
	writel(0x00003FFF, 0x1100004C);
#endif

#ifdef USE_MMC1
#endif

#ifdef USE_MMC2
	writel(0x02222222, 0x11000080);
	writel(0x00003FF0, 0x11000088);
	writel(0x00003FFF, 0x1100008C);
	/* 8 bit supprot */
	writel(0x03333000, 0x110000A0);
	writel(0x00003FF0, 0x110000A8);
	writel(0x00003FFF, 0x110000AC);
#endif

#ifdef USE_MMC3
#endif

#ifdef USE_MMC4
	writel(0x03333333, 0x11000040);
	writel(0x00003FF0, 0x11000048);
	writel(0x00002AAA, 0x1100004C);	
	writel(0x04444000, 0x11000060);
	writel(0x00003FC0, 0x11000068);
	writel(0x00002A80, 0x1100006C);	

	/* Drive Strength */
	writel(0x00010001, 0x1255009C);	
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
		/* Feedback Delay Disable */
		ctrl2 &= ~(S3C_SDHCI_CTRL2_ENFBCLKTX |
			S3C_SDHCI_CTRL2_ENFBCLKRX);
		/* Feedback Delay Rx Enable */
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKRX);
		ctrl3 &= ~(1 << 31 | 1 << 23 | 1 << 15 | 1 << 7);
		ctrl3 |= (1 << 15 | 1 << 7);
	} else
		printf("This CLOCK is Not Support: %d\n", host->clock);

	writel(ctrl2, host->ioaddr + S3C_SDHCI_CONTROL2);
	writel(ctrl3, host->ioaddr + S3C_SDHCI_CONTROL3);
}

