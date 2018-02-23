/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#ifndef _ASM_ARCH_CRU_px30_H
#define _ASM_ARCH_CRU_px30_H

#include <common.h>

#define MHz		1000000
#define OSC_HZ		(24 * MHz)

#define APLL_HZ		(816 * MHz)
#define GPLL_HZ		(600 * MHz)
#define CPLL_HZ		(594 * MHz)

#define CORE_PERI_HZ	204000000
#define CORE_ACLK_HZ	408000000

#define BUS_ACLK_HZ	148500000
#define BUS_HCLK_HZ	148500000
#define BUS_PCLK_HZ	74250000

#define PERI_ACLK_HZ	148500000
#define PERI_HCLK_HZ	148500000
#define PERI_PCLK_HZ	74250000

enum apll_frequencies {
	APLL_816_MHZ,
	APLL_600_MHZ,
};

/* Private data for the clock driver - used by rockchip_get_cru() */
struct px30_clk_priv {
	struct px30_cru *cru;
	ulong rate;
};

/* PX30 pll id */
enum px30_pll_id {
	APLL,
	DPLL,
	CPLL,
	NPLL,
	GPLL,
	PLL_COUNT,
};

struct px30_cru {
	struct px30_pll {
		unsigned int con0;
		unsigned int con1;
		unsigned int con2;
		unsigned int con3;
		unsigned int con4;
		unsigned int reserved0[3];
	} pll[4];
	unsigned int reserved1[8];
	unsigned int mode;
	unsigned int misc;
	unsigned int reserved2[2];
	unsigned int glb_cnt_th;
	unsigned int glb_rst_st;
	unsigned int glb_srst_fst;
	unsigned int glb_srst_snd;
	unsigned int glb_rst_con;
	unsigned int reserved3[7];
	unsigned int hwffc_con0;
	unsigned int reserved4;
	unsigned int hwffc_th;
	unsigned int hwffc_intst;
	unsigned int apll_con0_s;
	unsigned int apll_con1_s;
	unsigned int clksel_con0_s;
	unsigned int reserved5;
	unsigned int clksel_con[60];
	unsigned int reserved6[4];
	unsigned int clkgate_con[18];
	unsigned int reserved7[(0x280 - 0x244) / 4 - 1];
	unsigned int ssgtbl[32];
	unsigned int softrst_con[12];
	unsigned int reserved8[(0x380 - 0x32c) / 4 - 1];
	unsigned int sdmmc_con[2];
	unsigned int sdio_con[2];
	unsigned int emmc_con[2];
	unsigned int reserved9[(0x400 - 0x394) / 4 - 1];
	unsigned int autocs_con[8];
	unsigned int reserved10[(0xc000 - 0x41c) / 4 - 1];
	struct px30_pll gpll;
	unsigned int pmu_mode;
	unsigned int reserved11[7];
	unsigned int pmu_clksel_con[6];
	unsigned int pmu_clkgate_con[2];
	unsigned int reserved12[(0xc0c0 - 0xc05c) / 4 - 1];
	unsigned int pmu_autocs_con[2];
};
check_member(px30_cru, pmu_autocs_con[1], 0xc0c4);

struct pll_div {
	u32 refdiv;
	u32 fbdiv;
	u32 postdiv1;
	u32 postdiv2;
	u32 frac;
};

enum {
	/* PLLCON0*/
	PLL_BP_SHIFT		= 15,
	PLL_POSTDIV1_SHIFT	= 12,
	PLL_POSTDIV1_MASK	= 7 << PLL_POSTDIV1_SHIFT,
	PLL_FBDIV_SHIFT		= 0,
	PLL_FBDIV_MASK		= 0xfff,

	/* PLLCON1 */
	PLL_PDSEL_SHIFT		= 15,
	PLL_PD1_SHIFT		= 14,
	PLL_PD_SHIFT		= 13,
	PLL_PD_MASK		= 1 << PLL_PD_SHIFT,
	PLL_DSMPD_SHIFT		= 12,
	PLL_DSMPD_MASK		= 1 << PLL_DSMPD_SHIFT,
	PLL_LOCK_STATUS_SHIFT	= 10,
	PLL_LOCK_STATUS_MASK	= 1 << PLL_LOCK_STATUS_SHIFT,
	PLL_POSTDIV2_SHIFT	= 6,
	PLL_POSTDIV2_MASK	= 7 << PLL_POSTDIV2_SHIFT,
	PLL_REFDIV_SHIFT	= 0,
	PLL_REFDIV_MASK		= 0x3f,

	/* PLLCON2 */
	PLL_FOUT4PHASEPD_SHIFT	= 27,
	PLL_FOUTVCOPD_SHIFT	= 26,
	PLL_FOUTPOSTDIVPD_SHIFT	= 25,
	PLL_DACPD_SHIFT		= 24,
	PLL_FRAC_DIV	= 0xffffff,

	/* CRU_MODE */
	PLLMUX_FROM_XIN24M	= 0,
	PLLMUX_FROM_PLL,
	PLLMUX_FROM_RTC32K,
	USBPHY480M_MODE_SHIFT	= 8,
	USBPHY480M_MODE_MASK	= 3 << USBPHY480M_MODE_SHIFT,
	NPLL_MODE_SHIFT		= 6,
	NPLL_MODE_MASK		= 3 << NPLL_MODE_SHIFT,
	DPLL_MODE_SHIFT		= 4,
	DPLL_MODE_MASK		= 3 << DPLL_MODE_SHIFT,
	CPLL_MODE_SHIFT		= 2,
	CPLL_MODE_MASK		= 3 << CPLL_MODE_SHIFT,
	APLL_MODE_SHIFT		= 0,
	APLL_MODE_MASK		= 3 << APLL_MODE_SHIFT,

	/* CRU_CLK_SEL0_CON */
	CORE_ACLK_DIV_SHIFT	= 12,
	CORE_ACLK_DIV_MASK	= 0x07 << CORE_ACLK_DIV_SHIFT,
	CORE_DBG_DIV_SHIFT	= 8,
	CORE_DBG_DIV_MASK	= 0x03 << CORE_DBG_DIV_SHIFT,
	CORE_CLK_PLL_SEL_SHIFT	= 7,
	CORE_CLK_PLL_SEL_MASK	= 1 << CORE_CLK_PLL_SEL_SHIFT,
	CORE_CLK_PLL_SEL_APLL	= 0,
	CORE_CLK_PLL_SEL_GPLL,
	CORE_DIV_CON_SHIFT	= 0,
	CORE_DIV_CON_MASK	= 0x0f << CORE_DIV_CON_SHIFT,

	/* CRU_CLK_SEL14_CON */
	PERI_PLL_SEL_SHIFT	=15,
	PERI_PLL_SEL_MASK	= 3 << PERI_PLL_SEL_SHIFT,
	PERI_PLL_GPLL		= 0,
	PERI_PLL_CPLL,
	PERI_HCLK_DIV_SHIFT	= 8,
	PERI_HCLK_DIV_MASK	= 0x1f << PERI_HCLK_DIV_SHIFT,
	PERI_ACLK_DIV_SHIFT	= 0,
	PERI_ACLK_DIV_MASK	= 0x1f << PERI_ACLK_DIV_SHIFT,

	/* CRU_CLKSEL20_CON */
	EMMC_PLL_SHIFT		= 14,
	EMMC_PLL_MASK		= 3 << EMMC_PLL_SHIFT,
	EMMC_SEL_GPLL		= 0,
	EMMC_SEL_CPLL,
	EMMC_SEL_NPLL,
	EMMC_SEL_24M,
	EMMC_DIV_SHIFT		= 0,
	EMMC_DIV_MASK		= 0xff << EMMC_DIV_SHIFT,

	/* CRU_CLKSEL21_CON */
	EMMC_CLK_SEL_SHIFT	= 15,
	EMMC_CLK_SEL_MASK	= 1 << EMMC_CLK_SEL_SHIFT,
	EMMC_CLK_SEL_EMMC	= 0,
	EMMC_CLK_SEL_EMMC_DIV50,
	EMMC_DIV50_SHIFT	= 0,
	EMMC_DIV50_MASK		= 0xff << EMMC_DIV_SHIFT,

	/* CRU_CLKSEL22_CON */
	GMAC_PLL_SEL_SHIFT	= 14,
	GMAC_PLL_SEL_MASK	= 3 << GMAC_PLL_SEL_SHIFT,
	GMAC_PLL_SEL_GPLL	= 0,
	GMAC_PLL_SEL_CPLL,
	GMAC_PLL_SEL_NPLL,
	CLK_GMAC_DIV_SHIFT	= 8,
	CLK_GMAC_DIV_MASK	= 0x1f << CLK_GMAC_DIV_SHIFT,
	SFC_PLL_SEL_SHIFT	= 7,
	SFC_PLL_SEL_MASK	= 1 << SFC_PLL_SEL_SHIFT,
	SFC_DIV_CON_SHIFT	= 0,
	SFC_DIV_CON_MASK	= 0x7f,

	/* CRU_CLK_SEL23_CON */
	BUS_PLL_SEL_SHIFT	=15,
	BUS_PLL_SEL_MASK	= 3 << BUS_PLL_SEL_SHIFT,
	BUS_PLL_SEL_GPLL	= 0,
	BUS_PLL_SEL_CPLL,
	BUS_ACLK_DIV_SHIFT	= 8,
	BUS_ACLK_DIV_MASK	= 0x1f << BUS_ACLK_DIV_SHIFT,
	RMII_CLK_SEL_SHIFT	= 7,
	RMII_CLK_SEL_MASK	= 1 << RMII_CLK_SEL_SHIFT,
	RMII_CLK_SEL_10M	= 0,
	RMII_CLK_SEL_100M,
	RMII_EXTCLK_SEL_SHIFT	= 6,
	RMII_EXTCLK_SEL_MASK	= 1 << RMII_EXTCLK_SEL_SHIFT,
	RMII_EXTCLK_SEL_INT	= 0,
	RMII_EXTCLK_SEL_EXT,
	PCLK_GMAC_DIV_SHIFT	= 0,
	PCLK_GMAC_DIV_MASK	= 0x0f << PCLK_GMAC_DIV_SHIFT,

	/* CRU_CLK_SEL24_CON */
	BUS_PCLK_DIV_SHIFT	= 8,
	BUS_PCLK_DIV_MASK	= 3 << BUS_PCLK_DIV_SHIFT,
	BUS_HCLK_DIV_SHIFT	= 0,
	BUS_HCLK_DIV_MASK	= 0x1f << BUS_HCLK_DIV_SHIFT,

	/* CRU_CLK_SEL24_CON */
	UART2_PLL_SEL_SHIFT	= 14,
	UART2_PLL_SEL_MASK	= 3 << UART2_PLL_SEL_SHIFT,
	UART2_PLL_SEL_GPLL	= 0,
	UART2_PLL_SEL_24M,
	UART2_PLL_SEL_480M,
	UART2_PLL_SEL_NPLL,
	UART2_DIV_CON_SHIFT	= 0,
	UART2_DIV_CON_MASK	= 0x1f << UART2_DIV_CON_SHIFT,

	/* CRU_CLK_SEL25_CON */
	UART2_CLK_SEL_SHIFT	= 14,
	UART2_CLK_SEL_MASK	= 3 << UART2_PLL_SEL_SHIFT,
	UART2_CLK_SEL_UART2	= 0,
	UART2_CLK_SEL_UART2_NP5,
	UART2_CLK_SEL_UART2_FRAC,
	UART2_DIVNP5_SHIFT	= 0,
	UART2_DIVNP5_MASK	= 0x1f << UART2_DIVNP5_SHIFT,

	/* CRU_CLK_SEL49_CON */
	CLK_I2C_PLL_SEL_GPLL		= 0,
	CLK_I2C_PLL_SEL_24M,
	CLK_I2C_DIV_CON_MASK		= 0x7f,
	CLK_I2C_PLL_SEL_MASK		= 1,
	CLK_I2C1_PLL_SEL_SHIFT		= 15,
	CLK_I2C1_DIV_CON_SHIFT		= 8,
	CLK_I2C0_PLL_SEL_SHIFT		= 7,
	CLK_I2C0_DIV_CON_SHIFT		= 0,

	/* CRU_CLK_SEL50_CON */
	CLK_I2C3_PLL_SEL_SHIFT		= 15,
	CLK_I2C3_DIV_CON_SHIFT		= 8,
	CLK_I2C2_PLL_SEL_SHIFT		= 7,
	CLK_I2C2_DIV_CON_SHIFT		= 0,

	/* CRU_CLK_SEL52_CON */
	CLK_PWM_PLL_SEL_GPLL		= 0,
	CLK_PWM_PLL_SEL_24M,
	CLK_PWM_DIV_CON_MASK		= 0x7f,
	CLK_PWM_PLL_SEL_MASK		= 1,
	CLK_PWM1_PLL_SEL_SHIFT		= 15,
	CLK_PWM1_DIV_CON_SHIFT		= 8,
	CLK_PWM0_PLL_SEL_SHIFT		= 7,
	CLK_PWM0_DIV_CON_SHIFT		= 0,

	/* CRU_CLK_SEL53_CON */
	CLK_SPI_PLL_SEL_GPLL		= 0,
	CLK_SPI_PLL_SEL_24M,
	CLK_SPI_DIV_CON_MASK		= 0x7f,
	CLK_SPI_PLL_SEL_MASK		= 1,
	CLK_SPI1_PLL_SEL_SHIFT		= 15,
	CLK_SPI1_DIV_CON_SHIFT		= 8,
	CLK_SPI0_PLL_SEL_SHIFT		= 7,
	CLK_SPI0_DIV_CON_SHIFT		= 0,

	/* CRU_CLK_SEL55_CON */
	CLK_SARADC_DIV_CON_SHIFT	= 0,
	CLK_SARADC_DIV_CON_MASK		= 0x7ff,

	/* CRU_PMU_MODE */
	GPLL_MODE_SHIFT		= 0,
	GPLL_MODE_MASK		= 3 << GPLL_MODE_SHIFT,
	
};
#endif
