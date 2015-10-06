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

extern ulong get_MPLL_CLK(void);

void set_hsmmc_pre_ratio (struct sdhci_host *host, uint clock)
{
	u32 div, clk;

	clk = readw(host->ioaddr + SDHCI_CLOCK_CONTROL);

	/* XXX: we assume that clock is between 40MHz and 50MHz */
	if (clock <= 400000)
		div = 0x40;
	else if (clock <= 20000000)
		div = 2;
	else if (clock <= 26000000)
		div = 1;
	else
		div = 0;
	clk = div << SDHCI_DIVIDER_SHIFT;

	writew(clk, host->ioaddr + SDHCI_CLOCK_CONTROL);
}
void setup_hsmmc_clock(void)
{
	u32 tmp;
	u32 clock;
	u32 i;

	/* MMC0 clock src = SCLKMPLL */
	tmp = CLK_SRC0_REG & ~(0x3<<18);
	CLK_SRC0_REG = tmp | (0x1<<18);

	/* MMC0 clock div */
	tmp = CLK_DIV1_REG & ~(0x0000000f);
	clock = get_MPLL_CLK()/1000000;

	for(i=0; i<0xf; i++)
	{
		if((clock / (i+1)) <= 50) {
			CLK_DIV1_REG = tmp | i<<0;
			break;
		}
	}

#ifdef USE_MMC1
	/* MMC1 clock src = SCLKMPLL */
	tmp = CLK_SRC0_REG & ~(0x3<<20);
	CLK_SRC0_REG = tmp | (0x1<<20);

	/* MMC1 clock div */
	tmp = CLK_DIV1_REG & ~(0x000000f0);
	for(i=0; i<0xf; i++)
	{
		if((clock / (i+1)) <= 50) {
			CLK_DIV1_REG = tmp | i<<4;
			break;
		}
	}
#endif

#ifdef USE_MMC2
	/* MMC2 clock src = SCLKMPLL */
	tmp = CLK_SRC0_REG & ~(0x3<<22);
	CLK_SRC0_REG = tmp | (0x1<<22);

	/* MMC2 clock div */
	tmp = CLK_DIV1_REG & ~(0x00000f00);
	for(i=0; i<0xf; i++)
	{
		if((clock / (i+1)) <= 50) {
			CLK_DIV1_REG = tmp | i<<8;
			break;
		}
	}
#endif

#ifdef USE_MMC3
	/* MMC2 clock src = SCLKMPLL */
	tmp = CLK_SRC0_REG & ~(0x7<<6);
	CLK_SRC0_REG = tmp | (0x1<<6);

	/* MMC2 clock div */
	tmp = CLK_DIV1_REG & ~(0xf<<28);
	for(i=0; i<0xf; i++)
	{
		if((clock / (i+1)) <= 50) {
			CLK_DIV1_REG = tmp | i<<28;
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
	ulong reg;

	/* MMC channel 0 */
	/* 7 pins will be assigned - GPG0[0:6] = CLK, CMD, CDn, DAT[0:3] */
	reg = readl(GPGCON0) & 0xf0000000;
	writel(reg | 0x02222222, GPGCON0);
	reg = readl(GPGPUD) & 0xffffc000;
	writel(reg | 0x00002aaa, GPGPUD);

#ifdef USE_MMC1
	/* MMC channel 1 */
	/* 7 pins will be assigned - GPG1[0:6] = CLK, CMD, CDn, DAT[0:3] */
#ifdef CONFIG_S5P6460
	reg = readl(GPGCON0) & 0x00ffffff;
	writel(reg | 0x20000000, GPGCON0);

	reg = readl(GPGCON1) & 0xff000000;
	writel(reg | 0x00122222, GPGCON1);

	reg = readl(GPGPUD) & 0x00002fff;
	writel(reg | 0x0aaa8000, GPGPUD);
#else
	reg = readl(GPHCON0) & 0xffffffff;
	writel(reg | 0x22222222, GPHCON0);

	reg = readl(GPHCON1) & 0x000000ff;
	writel(reg | 0x00000022, GPHCON1);

	reg = readl(GPHPUD) & 0x0003ffff;
	writel(reg | 0x00002aaa, GPHPUD);
#endif

#endif

#ifdef USE_MMC2
	/* MMC channel 2 */
	/* 7 pins will be assigned - GPG2[0:6] = CLK, CMD, CDn, DAT[0:3] */
	reg = readl(GPGCON0) & 0xf0000000;
	writel(reg | 0x30000000, GPGCON0);

	reg = readl(GPGCON1) & 0x000fffff;
	writel(reg | 0x00033333, GPGCON1);

	reg = readl(GPGPUD) & 0x03ffc000;
	writel(reg | 0x02aa8000, GPGPUD);
#endif

#ifdef USE_MMC3
	/* MMC channel 3 */
	/* 7 pins will be assigned - GPG0[0:6] = CLK, CMD, CDn, DAT[0:3] */
	reg = readl(GPGCON0) & 0xf0000000;
	writel(reg | 0x20000000, GPGCON0);

	reg = readl(GPGCON1) & 0x000fffff;
	writel(reg | 0x00022222, GPGCON1);

	reg = readl(GPGPUD) & 0x0fffc000;
	writel(reg | 0x0aaa8000, GPGPUD);
#endif
}


void setup_sdhci0_cfg_card(struct sdhci_host *host)
{
	u32 ctrl2;
	u32 ctrl3 = 0;

	/* don't need to alter anything acording to card-type */
	writel(S3C_SDHCI_CONTROL4_DRIVE_9mA, host->ioaddr + S3C_SDHCI_CONTROL4);

	ctrl2 = readl(host->ioaddr + S3C_SDHCI_CONTROL2);

	ctrl2 |= (S3C_SDHCI_CTRL2_ENSTAASYNCCLR |
		  S3C_SDHCI_CTRL2_ENCMDCNFMSK |
		  //S3C_SDHCI_CTRL2_ENFBCLKTX |
		  S3C_SDHCI_CTRL2_ENFBCLKRX |
		  S3C_SDHCI_CTRL2_DFCNT_NONE |
		  S3C_SDHCI_CTRL2_ENCLKOUTHOLD);

	/*
	if(host->mmc->clock == 52*1000000)
		ctrl3 = 0;
	else
		ctrl3 = S3C_SDHCI_CTRL3_FCSEL0 | S3C_SDHCI_CTRL3_FCSEL1;
	*/
	ctrl3 = 0x7f5f3f1f;
			//| S3C_SDHCI_CTRL3_FCSEL0
			//| S3C_SDHCI_CTRL3_FCSEL1);

	writel(ctrl2, host->ioaddr + S3C_SDHCI_CONTROL2);
	writel(ctrl3, host->ioaddr + S3C_SDHCI_CONTROL3);
}

