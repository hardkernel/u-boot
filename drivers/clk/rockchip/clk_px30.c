/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0
 */

#include <common.h>
#include <bitfield.h>
#include <clk-uclass.h>
#include <dm.h>
#include <errno.h>
#include <syscon.h>
#include <asm/arch/clock.h>
#include <asm/arch/cru_px30.h>
#include <asm/arch/hardware.h>
#include <asm/io.h>
#include <dm/lists.h>
#include <dt-bindings/clock/px30-cru.h>

DECLARE_GLOBAL_DATA_PTR;

enum {
	VCO_MAX_HZ	= 3200U * 1000000,
	VCO_MIN_HZ	= 800 * 1000000,
	OUTPUT_MAX_HZ	= 3200U * 1000000,
	OUTPUT_MIN_HZ	= 24 * 1000000,
};

#define DIV_TO_RATE(input_rate, div)    ((input_rate) / ((div) + 1))

#define PLL_DIVISORS(hz, _refdiv, _postdiv1, _postdiv2) {\
	.refdiv = _refdiv,\
	.fbdiv = (u32)((u64)hz * _refdiv * _postdiv1 * _postdiv2 / OSC_HZ),\
	.postdiv1 = _postdiv1, .postdiv2 = _postdiv2};
static const struct pll_div gpll_init_cfg = PLL_DIVISORS(GPLL_HZ, 1, 1, 1);

static const struct pll_div apll_816_cfg = PLL_DIVISORS(816 * MHz, 1, 2, 1);
static const struct pll_div apll_600_cfg = PLL_DIVISORS(600 * MHz, 1, 3, 1);

static const struct pll_div *apll_cfgs[] = {
	[APLL_816_MHZ] = &apll_816_cfg,
	[APLL_600_MHZ] = &apll_600_cfg,
};

static u8 pll_mode_shift[PLL_COUNT] = {
	APLL_MODE_SHIFT, DPLL_MODE_SHIFT, CPLL_MODE_SHIFT,
	NPLL_MODE_SHIFT, GPLL_MODE_SHIFT
};
static u32 pll_mode_mask[PLL_COUNT] = {
	APLL_MODE_MASK, DPLL_MODE_MASK, CPLL_MODE_MASK,
	NPLL_MODE_MASK, GPLL_MODE_MASK
};

/*
 *  the div restructions of pll in integer mode, these are defined in
 *  * CRU_*PLL_CON0 or PMUCRU_*PLL_CON0
 */
#define PLL_DIV_MIN	16
#define PLL_DIV_MAX	3200

/*
 * How to calculate the PLL(from TRM V0.3 Part 1 Page 63):
 * Formulas also embedded within the Fractional PLL Verilog model:
 * If DSMPD = 1 (DSM is disabled, "integer mode")
 * FOUTVCO = FREF / REFDIV * FBDIV
 * FOUTPOSTDIV = FOUTVCO / POSTDIV1 / POSTDIV2
 * Where:
 * FOUTVCO = Fractional PLL non-divided output frequency
 * FOUTPOSTDIV = Fractional PLL divided output frequency
 *               (output of second post divider)
 * FREF = Fractional PLL input reference frequency, (the OSC_HZ 24MHz input)
 * REFDIV = Fractional PLL input reference clock divider
 * FBDIV = Integer value programmed into feedback divide
 *
 */
static void rkclk_set_pll(struct px30_cru *cru, enum px30_pll_id pll_id,
			  const struct pll_div *div)
{
	struct px30_pll *pll;
	unsigned int *mode;
	/* All PLLs have same VCO and output frequency range restrictions. */
	uint vco_hz = OSC_HZ / 1000 * div->fbdiv / div->refdiv * 1000;
	uint output_hz = vco_hz / div->postdiv1 / div->postdiv2;

	if (pll_id == GPLL) {
		pll = &cru->gpll;
		mode = &cru->pmu_mode;
	} else {
		pll = &cru->pll[pll_id];
		mode = &cru->mode;
	};

	debug("PLL at %p: fb=%d, ref=%d, pst1=%d, pst2=%d, vco=%u Hz, output=%u Hz\n",
	      pll, div->fbdiv, div->refdiv, div->postdiv1,
	      div->postdiv2, vco_hz, output_hz);
	assert(vco_hz >= VCO_MIN_HZ && vco_hz <= VCO_MAX_HZ &&
	       output_hz >= OUTPUT_MIN_HZ && output_hz <= OUTPUT_MAX_HZ);

	/*
	 * When power on or changing PLL setting,
	 * we must force PLL into slow mode to ensure output stable clock.
	 */
	rk_clrsetreg(mode, pll_mode_mask[pll_id],
		     PLLMUX_FROM_XIN24M << pll_mode_shift[pll_id]);

	/* use integer mode */
	rk_setreg(&pll->con1, 1 << PLL_DSMPD_SHIFT);
	/* Power down */
	rk_setreg(&pll->con1, 1 << PLL_PD_SHIFT);

	rk_clrsetreg(&pll->con0,
		     PLL_POSTDIV1_MASK | PLL_FBDIV_MASK,
		     (div->postdiv1 << PLL_POSTDIV1_SHIFT) | div->fbdiv);
	rk_clrsetreg(&pll->con1, PLL_POSTDIV2_MASK | PLL_REFDIV_MASK,
		     (div->postdiv2 << PLL_POSTDIV2_SHIFT |
		     div->refdiv << PLL_REFDIV_SHIFT));

	/* Power Up */
	rk_clrreg(&pll->con1, 1 << PLL_PD_SHIFT);

	/* waiting for pll lock */
	while (readl(&pll->con1) & (1 << PLL_LOCK_STATUS_SHIFT))
		udelay(1);

	rk_clrsetreg(mode, pll_mode_mask[pll_id],
		     PLLMUX_FROM_PLL << pll_mode_shift[pll_id]);

	return;
}

static uint32_t rkclk_pll_get_rate(struct px30_cru *cru,
				   enum px30_pll_id pll_id)
{
	u32 refdiv, fbdiv, postdiv1, postdiv2;
	u32 con;
	struct px30_pll *pll;
	uint shift;
	uint mask;

	if (pll_id == GPLL) {
		pll = &cru->gpll;
		con = readl(&cru->pmu_mode);
	} else {
		pll = &cru->pll[pll_id];
		con = readl(&cru->mode);
	}

	shift = pll_mode_shift[pll_id];
	mask = pll_mode_mask[pll_id];

	switch ((con & mask) >> shift) {
	case PLLMUX_FROM_XIN24M:
		return OSC_HZ;
	case PLLMUX_FROM_PLL:
		/* normal mode */
		con = readl(&pll->con0);
		postdiv1 = (con & PLL_POSTDIV1_MASK) >> PLL_POSTDIV1_SHIFT;
		fbdiv = (con & PLL_FBDIV_MASK) >> PLL_FBDIV_SHIFT;
		con = readl(&pll->con1);
		postdiv2 = (con & PLL_POSTDIV2_MASK) >> PLL_POSTDIV2_SHIFT;
		refdiv = (con & PLL_REFDIV_MASK) >> PLL_REFDIV_SHIFT;
		return (24 * fbdiv / (refdiv * postdiv1 * postdiv2)) * 1000000;
	case PLLMUX_FROM_RTC32K:
	default:
		return 32768;
	}
}

static int pll_para_config(u32 freq_hz, struct pll_div *div)
{
	u32 ref_khz = OSC_HZ / KHz, refdiv, fbdiv = 0;
	u32 postdiv1, postdiv2 = 1;
	u32 fref_khz;
	u32 diff_khz, best_diff_khz;
	const u32 max_refdiv = 63, max_fbdiv = 3200, min_fbdiv = 16;
	const u32 max_postdiv1 = 7, max_postdiv2 = 7;
	u32 vco_khz;
	u32 freq_khz = freq_hz / KHz;

	if (!freq_hz) {
		printf("%s: the frequency can't be 0 Hz\n", __func__);
		return -1;
	}

	postdiv1 = DIV_ROUND_UP(VCO_MIN_HZ / 1000, freq_khz);
	if (postdiv1 > max_postdiv1) {
		postdiv2 = DIV_ROUND_UP(postdiv1, max_postdiv1);
		postdiv1 = DIV_ROUND_UP(postdiv1, postdiv2);
	}

	vco_khz = freq_khz * postdiv1 * postdiv2;

	if (vco_khz < (VCO_MIN_HZ / KHz) || vco_khz > (VCO_MAX_HZ / KHz) ||
	    postdiv2 > max_postdiv2) {
		printf("%s: Cannot find out a supported VCO for Freq (%uHz)\n",
		       __func__, freq_hz);
		return -1;
	}

	div->postdiv1 = postdiv1;
	div->postdiv2 = postdiv2;

	best_diff_khz = vco_khz;
	for (refdiv = 1; refdiv < max_refdiv && best_diff_khz; refdiv++) {
		fref_khz = ref_khz / refdiv;

		fbdiv = vco_khz / fref_khz;
		if ((fbdiv >= max_fbdiv) || (fbdiv <= min_fbdiv))
			continue;
		diff_khz = vco_khz - fbdiv * fref_khz;
		if (fbdiv + 1 < max_fbdiv && diff_khz > fref_khz / 2) {
			fbdiv++;
			diff_khz = fref_khz - diff_khz;
		}

		if (diff_khz >= best_diff_khz)
			continue;

		best_diff_khz = diff_khz;
		div->refdiv = refdiv;
		div->fbdiv = fbdiv;
	}

	if (best_diff_khz > 4 * (MHz / KHz)) {
		printf("%s: Failed to match output frequency %u bestis %u Hz\n",
		       __func__, freq_hz,
		       best_diff_khz * KHz);
		return -1;
	}
	return 0;
}

static void rkclk_init(struct px30_cru *cru)
{
	u32 aclk_div;
	u32 hclk_div;
	u32 pclk_div;

	/* init pll */
	rkclk_set_pll(cru, APLL, apll_cfgs[APLL_816_MHZ]);
	rkclk_set_pll(cru, GPLL, &gpll_init_cfg);

	/*
	 * select apll as cpu/core clock pll source and
	 * set up dependent divisors for PERI and ACLK clocks.
	 * core hz : apll = 1:1
	 */
	aclk_div = APLL_HZ / CORE_ACLK_HZ - 1;
	rk_clrsetreg(&cru->clksel_con[0],
		     CORE_CLK_PLL_SEL_MASK | CORE_DIV_CON_MASK |
		     CORE_ACLK_DIV_MASK,
		     aclk_div << CORE_ACLK_DIV_SHIFT |
		     CORE_CLK_PLL_SEL_APLL << CORE_CLK_PLL_SEL_SHIFT |
		     0 << CORE_DIV_CON_SHIFT);

	/*
	 * select gpll as pd_bus bus clock source and
	 * set up dependent divisors for PCLK/HCLK and ACLK clocks.
	 */
	aclk_div = GPLL_HZ / BUS_ACLK_HZ - 1;
	hclk_div = GPLL_HZ / BUS_HCLK_HZ - 1;
	pclk_div = BUS_ACLK_HZ / BUS_PCLK_HZ - 1;

	rk_clrsetreg(&cru->clksel_con[23],
		     BUS_PLL_SEL_MASK | BUS_ACLK_DIV_MASK,
		     BUS_PLL_SEL_GPLL << BUS_PLL_SEL_SHIFT |
		     aclk_div << BUS_ACLK_DIV_SHIFT);

	rk_clrsetreg(&cru->clksel_con[24],
		     BUS_PCLK_DIV_MASK | BUS_HCLK_DIV_MASK,
		     pclk_div << BUS_PCLK_DIV_SHIFT |
		     hclk_div << BUS_HCLK_DIV_SHIFT);

	/*
	 * select gpll as pd_peri bus clock source and
	 * set up dependent divisors for PCLK/HCLK and ACLK clocks.
	 */
	aclk_div = GPLL_HZ / PERI_ACLK_HZ - 1;
	hclk_div = GPLL_HZ / PERI_HCLK_HZ - 1;

	rk_clrsetreg(&cru->clksel_con[14],
		     PERI_PLL_SEL_MASK |
		     PERI_HCLK_DIV_MASK | PERI_ACLK_DIV_MASK,
		     PERI_PLL_GPLL << PERI_PLL_SEL_SHIFT |
		     hclk_div << PERI_HCLK_DIV_SHIFT |
		     aclk_div << PERI_ACLK_DIV_SHIFT);
}

static ulong px30_i2c_get_clk(struct px30_cru *cru, ulong clk_id)
{
	u32 div, con;

	switch (clk_id) {
	case SCLK_I2C0:
		con = readl(&cru->clksel_con[49]);
		div = con >> CLK_I2C0_DIV_CON_SHIFT & CLK_I2C_DIV_CON_MASK;
		break;
	case SCLK_I2C1:
		con = readl(&cru->clksel_con[49]);
		div = con >> CLK_I2C1_DIV_CON_SHIFT & CLK_I2C_DIV_CON_MASK;
		break;
	case SCLK_I2C2:
		con = readl(&cru->clksel_con[50]);
		div = con >> CLK_I2C2_DIV_CON_SHIFT & CLK_I2C_DIV_CON_MASK;
		break;
	case SCLK_I2C3:
		con = readl(&cru->clksel_con[50]);
		div = con >> CLK_I2C3_DIV_CON_SHIFT & CLK_I2C_DIV_CON_MASK;
		break;
	default:
		printf("do not support this i2c bus\n");
		return -EINVAL;
	}

	return DIV_TO_RATE(GPLL_HZ, div);
}

static ulong px30_i2c_set_clk(struct px30_cru *cru, ulong clk_id, uint hz)
{
	int src_clk_div;

	src_clk_div = GPLL_HZ / hz;
	assert(src_clk_div - 1 < 127);

	switch (clk_id) {
	case SCLK_I2C0:
		rk_clrsetreg(&cru->clksel_con[49],
			     CLK_I2C_DIV_CON_MASK << CLK_I2C0_DIV_CON_SHIFT |
			     CLK_I2C_PLL_SEL_MASK << CLK_I2C0_PLL_SEL_SHIFT,
			     (src_clk_div - 1) << CLK_I2C0_DIV_CON_SHIFT |
			     CLK_I2C_PLL_SEL_GPLL << CLK_I2C0_PLL_SEL_SHIFT);
		break;
	case SCLK_I2C1:
		rk_clrsetreg(&cru->clksel_con[49],
			     CLK_I2C_DIV_CON_MASK << CLK_I2C1_DIV_CON_SHIFT |
			     CLK_I2C_PLL_SEL_MASK << CLK_I2C1_PLL_SEL_SHIFT,
			     (src_clk_div - 1) << CLK_I2C1_DIV_CON_SHIFT |
			     CLK_I2C_PLL_SEL_GPLL << CLK_I2C1_PLL_SEL_SHIFT);
		break;
	case SCLK_I2C2:
		rk_clrsetreg(&cru->clksel_con[50],
			     CLK_I2C_DIV_CON_MASK << CLK_I2C2_DIV_CON_SHIFT |
			     CLK_I2C_PLL_SEL_MASK << CLK_I2C2_PLL_SEL_SHIFT,
			     (src_clk_div - 1) << CLK_I2C2_DIV_CON_SHIFT |
			     CLK_I2C_PLL_SEL_GPLL << CLK_I2C2_PLL_SEL_SHIFT);
		break;
	case SCLK_I2C3:
		rk_clrsetreg(&cru->clksel_con[50],
			     CLK_I2C_DIV_CON_MASK << CLK_I2C3_DIV_CON_SHIFT |
			     CLK_I2C_PLL_SEL_MASK << CLK_I2C3_PLL_SEL_SHIFT,
			     (src_clk_div - 1) << CLK_I2C3_DIV_CON_SHIFT |
			     CLK_I2C_PLL_SEL_GPLL << CLK_I2C3_PLL_SEL_SHIFT);
		break;
	default:
		printf("do not support this i2c bus\n");
		return -EINVAL;
	}

	return px30_i2c_get_clk(cru, clk_id);
}

static ulong px30_mmc_get_clk(struct px30_cru *cru, uint clk_id)
{
	u32 div, con, con_id;

	switch (clk_id) {
	case HCLK_SDMMC:
	case SCLK_SDMMC:
		con_id = 16;
		break;
	case HCLK_EMMC:
	case SCLK_EMMC:
	case SCLK_EMMC_SAMPLE:
		con_id = 20;
		break;
	default:
		return -EINVAL;
	}

	con = readl(&cru->clksel_con[con_id]);
	div = (con & EMMC_DIV_MASK) >> EMMC_DIV_SHIFT;

	if ((con & EMMC_PLL_MASK) >> EMMC_PLL_SHIFT
	    == EMMC_SEL_24M)
		return DIV_TO_RATE(OSC_HZ, div) / 2;
	else
		return DIV_TO_RATE(GPLL_HZ, div) / 2;

}

static ulong px30_mmc_set_clk(struct px30_cru *cru,
				ulong clk_id, ulong set_rate)
{
	int src_clk_div;
	u32 con_id;

	debug("%s %ld %ld\n", __func__, clk_id, set_rate);
	switch (clk_id) {
	case HCLK_SDMMC:
	case SCLK_SDMMC:
		con_id = 16;
		break;
	case HCLK_EMMC:
	case SCLK_EMMC:
		con_id = 20;
		break;
	default:
		return -EINVAL;
	}
	/* Select clk_sdmmc/emmc source from GPLL by default */
	/* mmc clock defaulg div 2 internal, need provide double in cru */
	src_clk_div = DIV_ROUND_UP(GPLL_HZ / 2, set_rate);

	if (src_clk_div > 127) {
		/* use 24MHz source for 400KHz clock */
		src_clk_div = DIV_ROUND_UP(OSC_HZ / 2, set_rate);
		rk_clrsetreg(&cru->clksel_con[con_id],
			     EMMC_PLL_MASK | EMMC_DIV_MASK,
			     EMMC_SEL_24M << EMMC_PLL_SHIFT |
			     (src_clk_div - 1) << EMMC_DIV_SHIFT);
	} else {
		rk_clrsetreg(&cru->clksel_con[con_id],
			     EMMC_PLL_MASK | EMMC_DIV_MASK,
			     EMMC_SEL_GPLL << EMMC_PLL_SHIFT |
			     (src_clk_div - 1) << EMMC_DIV_SHIFT);
	}
	rk_clrsetreg(&cru->clksel_con[con_id +1], EMMC_CLK_SEL_MASK,
		     EMMC_CLK_SEL_EMMC);

	return px30_mmc_get_clk(cru, clk_id);
}

static ulong px30_pwm_get_clk(struct px30_cru *cru, ulong clk_id)
{
	u32 div, con;

	switch (clk_id) {
	case SCLK_PWM0:
		con = readl(&cru->clksel_con[52]);
		div = con >> CLK_PWM0_DIV_CON_SHIFT & CLK_PWM_DIV_CON_MASK;
		break;
	case SCLK_PWM1:
		con = readl(&cru->clksel_con[52]);
		div = con >> CLK_PWM1_DIV_CON_SHIFT & CLK_PWM_DIV_CON_MASK;
		break;
	default:
		printf("do not support this pwm bus\n");
		return -EINVAL;
	}

	return DIV_TO_RATE(GPLL_HZ, div);
}

static ulong px30_pwm_set_clk(struct px30_cru *cru, ulong clk_id, uint hz)
{
	int src_clk_div;

	src_clk_div = GPLL_HZ / hz;
	assert(src_clk_div - 1 < 127);

	switch (clk_id) {
	case SCLK_PWM0:
		rk_clrsetreg(&cru->clksel_con[52],
			     CLK_PWM_DIV_CON_MASK << CLK_PWM0_DIV_CON_SHIFT |
			     CLK_PWM_PLL_SEL_MASK << CLK_PWM0_PLL_SEL_SHIFT,
			     (src_clk_div - 1) << CLK_PWM0_DIV_CON_SHIFT |
			     CLK_PWM_PLL_SEL_GPLL << CLK_PWM0_PLL_SEL_SHIFT);
		break;
	case SCLK_PWM1:
		rk_clrsetreg(&cru->clksel_con[52],
			     CLK_PWM_DIV_CON_MASK << CLK_PWM1_DIV_CON_SHIFT |
			     CLK_PWM_PLL_SEL_MASK << CLK_PWM1_PLL_SEL_SHIFT,
			     (src_clk_div - 1) << CLK_PWM1_DIV_CON_SHIFT |
			     CLK_PWM_PLL_SEL_GPLL << CLK_PWM1_PLL_SEL_SHIFT);
		break;
	default:
		printf("do not support this pwm bus\n");
		return -EINVAL;
	}

	return px30_pwm_get_clk(cru, clk_id);
}

static ulong px30_saradc_get_clk(struct px30_cru *cru)
{
	u32 div, con;

	con = readl(&cru->clksel_con[55]);
	div = con >> CLK_SARADC_DIV_CON_SHIFT & CLK_PWM_DIV_CON_MASK;

	return DIV_TO_RATE(OSC_HZ, div);
}

static ulong px30_saradc_set_clk(struct px30_cru *cru, uint hz)
{
	int src_clk_div;

	src_clk_div = OSC_HZ / hz;
	assert(src_clk_div - 1 < 2047);

	rk_clrsetreg(&cru->clksel_con[55],
		     CLK_SARADC_DIV_CON_MASK,
		     (src_clk_div - 1) << CLK_SARADC_DIV_CON_SHIFT);

	return px30_saradc_get_clk(cru);
}

static ulong px30_spi_get_clk(struct px30_cru *cru, ulong clk_id)
{
	u32 div, con;

	switch (clk_id) {
	case SCLK_SPI0:
		con = readl(&cru->clksel_con[53]);
		div = con >> CLK_SPI0_DIV_CON_SHIFT & CLK_SPI_DIV_CON_MASK;
		break;
	case SCLK_SPI1:
		con = readl(&cru->clksel_con[53]);
		div = con >> CLK_SPI1_DIV_CON_SHIFT & CLK_SPI_DIV_CON_MASK;
		break;
	default:
		printf("do not support this pwm bus\n");
		return -EINVAL;
	}

	return DIV_TO_RATE(GPLL_HZ, div);
}

static ulong px30_spi_set_clk(struct px30_cru *cru, ulong clk_id, uint hz)
{
	int src_clk_div;

	src_clk_div = GPLL_HZ / hz;
	assert(src_clk_div - 1 < 127);

	switch (clk_id) {
	case SCLK_SPI0:
		rk_clrsetreg(&cru->clksel_con[53],
			     CLK_SPI_DIV_CON_MASK << CLK_SPI0_DIV_CON_SHIFT |
			     CLK_SPI_PLL_SEL_MASK << CLK_SPI0_PLL_SEL_SHIFT,
			     (src_clk_div - 1) << CLK_SPI0_DIV_CON_SHIFT |
			     CLK_SPI_PLL_SEL_GPLL << CLK_SPI0_PLL_SEL_SHIFT);
		break;
	case SCLK_SPI1:
		rk_clrsetreg(&cru->clksel_con[53],
			     CLK_SPI_DIV_CON_MASK << CLK_SPI1_DIV_CON_SHIFT |
			     CLK_SPI_PLL_SEL_MASK << CLK_SPI1_PLL_SEL_SHIFT,
			     (src_clk_div - 1) << CLK_SPI1_DIV_CON_SHIFT |
			     CLK_SPI_PLL_SEL_GPLL << CLK_SPI1_PLL_SEL_SHIFT);
		break;
	default:
		printf("do not support this pwm bus\n");
		return -EINVAL;
	}

	return px30_spi_get_clk(cru, clk_id);
}

static ulong px30_vop_get_clk(struct px30_cru *cru, ulong clk_id)
{
	u32 div, con, parent;

	switch (clk_id) {
	case ACLK_VOPB:
		con = readl(&cru->clksel_con[3]);
		div = con & ACLK_VO_DIV_MASK;
		parent = GPLL_HZ;
		break;
	case DCLK_VOPB:
		con = readl(&cru->clksel_con[5]);
		div = con & DCLK_VOPB_DIV_MASK;
		parent = rkclk_pll_get_rate(cru, CPLL);
		break;
	default:
		return -ENOENT;
	}

	return DIV_TO_RATE(parent, div);
}

static ulong px30_vop_set_clk(struct px30_cru *cru, ulong clk_id, uint hz)
{
	int src_clk_div;
	struct pll_div cpll_config = {0};

	src_clk_div = GPLL_HZ / hz;
	assert(src_clk_div - 1 < 31);

	switch (clk_id) {
	case ACLK_VOPB:
		rk_clrsetreg(&cru->clksel_con[3],
			     ACLK_VO_PLL_MASK | ACLK_VO_DIV_MASK,
			     ACLK_VO_SEL_GPLL << ACLK_VO_PLL_SHIFT |
			     (src_clk_div - 1) << ACLK_VO_DIV_SHIFT);
		break;
	case DCLK_VOPB:
		/*
		 * vopb dclk source from cpll, and equals to
		 * cpll(means div == 1)
		 */
		if (pll_para_config(hz, &cpll_config))
			return -1;
		rkclk_set_pll(cru, CPLL, &cpll_config);

		rk_clrsetreg(&cru->clksel_con[5],
			     DCLK_VOPB_SEL_MASK | DCLK_VOPB_PLL_SEL_MASK |
			     DCLK_VOPB_DIV_MASK,
			     DCLK_VOPB_SEL_DIVOUT << DCLK_VOPB_SEL_SHIFT |
			     DCLK_VOPB_PLL_SEL_CPLL << DCLK_VOPB_PLL_SEL_SHIFT |
			     (1 - 1) << DCLK_VOPB_DIV_SHIFT);
		break;
	default:
		printf("do not support this vop freq\n");
		return -EINVAL;
	}

	return hz;
}

static ulong px30_clk_get_rate(struct clk *clk)
{
	struct px30_clk_priv *priv = dev_get_priv(clk->dev);
	ulong rate = 0;

	switch (clk->id) {
	case 0 ... 15:
		return 0;
	case HCLK_SDMMC:
	case HCLK_EMMC:
	case SCLK_SDMMC:
	case SCLK_EMMC:
	case SCLK_EMMC_SAMPLE:
		rate = px30_mmc_get_clk(priv->cru, clk->id);
		break;
	case SCLK_I2C0:
	case SCLK_I2C1:
	case SCLK_I2C2:
	case SCLK_I2C3:
		rate = px30_i2c_get_clk(priv->cru, clk->id);
		break;
	case SCLK_PWM0:
	case SCLK_PWM1:
		rate = px30_pwm_get_clk(priv->cru, clk->id);
		break;
	case SCLK_SARADC:
		rate = px30_saradc_get_clk(priv->cru);
		break;
	case SCLK_SPI0:
	case SCLK_SPI1:
		rate = px30_spi_get_clk(priv->cru, clk->id);
		break;
	case ACLK_VOPB:
	case DCLK_VOPB:
		rate = px30_vop_get_clk(priv->cru, clk->id);
		break;
	default:
		return -ENOENT;
	}

	return rate;
}

static ulong px30_clk_set_rate(struct clk *clk, ulong rate)
{
	struct px30_clk_priv *priv = dev_get_priv(clk->dev);
	ulong ret = 0;

	debug("%s %ld %ld\n", __func__, clk->id, rate);
	switch (clk->id) {
	case 0 ... 15:
		return 0;
	case HCLK_SDMMC:
	case HCLK_EMMC:
	case SCLK_SDMMC:
	case SCLK_EMMC:
		ret = px30_mmc_set_clk(priv->cru, clk->id, rate);
		break;
	case SCLK_I2C0:
	case SCLK_I2C1:
	case SCLK_I2C2:
	case SCLK_I2C3:
		ret = px30_i2c_set_clk(priv->cru, clk->id, rate);
		break;
	case SCLK_PWM0:
	case SCLK_PWM1:
		ret = px30_pwm_set_clk(priv->cru, clk->id, rate);
		break;
	case SCLK_SARADC:
		ret = px30_saradc_set_clk(priv->cru, rate);
		break;
	case SCLK_SPI0:
	case SCLK_SPI1:
		ret = px30_spi_set_clk(priv->cru, clk->id, rate);
		break;
	case ACLK_VOPB:
	case DCLK_VOPB:
		ret = px30_vop_set_clk(priv->cru, clk->id, rate);
		break;
	default:
		return -ENOENT;
	}

	return ret;
}

#define ROCKCHIP_MMC_DELAY_SEL		BIT(10)
#define ROCKCHIP_MMC_DEGREE_MASK	0x3
#define ROCKCHIP_MMC_DELAYNUM_OFFSET	2
#define ROCKCHIP_MMC_DELAYNUM_MASK	(0xff << ROCKCHIP_MMC_DELAYNUM_OFFSET)

#define PSECS_PER_SEC 1000000000000LL
/*
 * Each fine delay is between 44ps-77ps. Assume each fine delay is 60ps to
 * simplify calculations. So 45degs could be anywhere between 33deg and 57.8deg.
 */
#define ROCKCHIP_MMC_DELAY_ELEMENT_PSEC 60

int rockchip_mmc_get_phase(struct clk *clk)
{
	struct px30_clk_priv *priv = dev_get_priv(clk->dev);
	struct px30_cru *cru = priv->cru;
	u32 raw_value, delay_num;
	u16 degrees = 0;
	ulong rate;

	rate = px30_clk_get_rate(clk);

	if (rate < 0)
		return rate;

	if (clk->id == SCLK_EMMC_SAMPLE)
		raw_value = readl(&cru->emmc_con[1]);
	else
		raw_value = readl(&cru->sdmmc_con[1]);

	raw_value >>= 1;
	degrees = (raw_value & ROCKCHIP_MMC_DEGREE_MASK) * 90;

	if (raw_value & ROCKCHIP_MMC_DELAY_SEL) {
		/* degrees/delaynum * 10000 */
		unsigned long factor = (ROCKCHIP_MMC_DELAY_ELEMENT_PSEC / 10) *
					36 * (rate / 1000000);

		delay_num = (raw_value & ROCKCHIP_MMC_DELAYNUM_MASK);
		delay_num >>= ROCKCHIP_MMC_DELAYNUM_OFFSET;
		degrees += DIV_ROUND_CLOSEST(delay_num * factor, 10000);
	}

	return degrees % 360;
}

int rockchip_mmc_set_phase(struct clk *clk, u32 degrees)
{
	struct px30_clk_priv *priv = dev_get_priv(clk->dev);
	struct px30_cru *cru = priv->cru;
	u8 nineties, remainder, delay_num;
	u32 raw_value, delay;
	ulong rate;

	rate = px30_clk_get_rate(clk);

	if (rate < 0)
		return rate;

	nineties = degrees / 90;
	remainder = (degrees % 90);

	/*
	 * Convert to delay; do a little extra work to make sure we
	 * don't overflow 32-bit / 64-bit numbers.
	 */
	delay = 10000000; /* PSECS_PER_SEC / 10000 / 10 */
	delay *= remainder;
	delay = DIV_ROUND_CLOSEST(delay, (rate / 1000) * 36 *
				(ROCKCHIP_MMC_DELAY_ELEMENT_PSEC / 10));

	delay_num = (u8)min_t(u32, delay, 255);

	raw_value = delay_num ? ROCKCHIP_MMC_DELAY_SEL : 0;
	raw_value |= delay_num << ROCKCHIP_MMC_DELAYNUM_OFFSET;
	raw_value |= nineties;

	raw_value <<= 1;
	if (clk->id == SCLK_EMMC_SAMPLE)
		writel(raw_value | 0xffff0000, &cru->emmc_con[1]);
	else
		writel(raw_value | 0xffff0000, &cru->sdmmc_con[1]);

	debug("mmc set_phase(%d) delay_nums=%u reg=%#x actual_degrees=%d\n",
	      degrees, delay_num, raw_value, rockchip_mmc_get_phase(clk));

	return 0;
}

static int px30_clk_get_phase(struct clk *clk)
{
	int ret;

	switch (clk->id) {
	case SCLK_EMMC_SAMPLE:
	case SCLK_SDMMC_SAMPLE:
		ret = rockchip_mmc_get_phase(clk);
		break;
	default:
		return -ENOENT;
	}

	return ret;
}

static int px30_clk_set_phase(struct clk *clk, int degrees)
{
	int ret;

	switch (clk->id) {
	case SCLK_EMMC_SAMPLE:
	case SCLK_SDMMC_SAMPLE:
		ret = rockchip_mmc_set_phase(clk, degrees);
		break;
	default:
		return -ENOENT;
	}

	return ret;
}

static struct clk_ops px30_clk_ops = {
	.get_rate = px30_clk_get_rate,
	.set_rate = px30_clk_set_rate,
	.get_phase	= px30_clk_get_phase,
	.set_phase	= px30_clk_set_phase,
};

static int px30_clk_probe(struct udevice *dev)
{
	struct px30_clk_priv *priv = dev_get_priv(dev);
	u32 reg = readl(&priv->cru->clksel_con[23]);

	/* Only do the rkclk_init() one time for boot up */
	if (((reg & BUS_ACLK_DIV_MASK) >> BUS_ACLK_DIV_SHIFT) !=
	    (GPLL_HZ / BUS_ACLK_HZ - 1))
		rkclk_init(priv->cru);

	return 0;
}

static int px30_clk_ofdata_to_platdata(struct udevice *dev)
{
	struct px30_clk_priv *priv = dev_get_priv(dev);

	priv->cru = dev_read_addr_ptr(dev);

	return 0;
}

static int px30_clk_bind(struct udevice *dev)
{
	int ret;
	struct udevice *sys_child, *sf_child;
	struct sysreset_reg *priv;
	struct softreset_reg *sf_priv;

	/* The reset driver does not have a device node, so bind it here */
	ret = device_bind_driver(dev, "rockchip_sysreset", "sysreset",
				 &sys_child);
	if (ret) {
		debug("Warning: No sysreset driver: ret=%d\n", ret);
	} else {
		priv = malloc(sizeof(struct sysreset_reg));
		priv->glb_srst_fst_value = offsetof(struct px30_cru,
						    glb_srst_fst);
		priv->glb_srst_snd_value = offsetof(struct px30_cru,
						    glb_srst_snd);
		sys_child->priv = priv;
	}

	ret = device_bind_driver_to_node(dev, "rockchip_reset", "reset",
					 dev_ofnode(dev), &sf_child);
	if (ret) {
		debug("Warning: No rockchip reset driver: ret=%d\n", ret);
	} else {
		sf_priv = malloc(sizeof(struct softreset_reg));
		sf_priv->sf_reset_offset = offsetof(struct px30_cru,
						    softrst_con[0]);
		sf_priv->sf_reset_num = 12;
		sf_child->priv = sf_priv;
	}

	return 0;
}

static const struct udevice_id px30_clk_ids[] = {
	{ .compatible = "rockchip,px30-cru" },
	{ }
};

U_BOOT_DRIVER(rockchip_px30_cru) = {
	.name		= "rockchip_px30_cru",
	.id		= UCLASS_CLK,
	.of_match	= px30_clk_ids,
	.priv_auto_alloc_size = sizeof(struct px30_clk_priv),
	.ofdata_to_platdata = px30_clk_ofdata_to_platdata,
	.ops		= &px30_clk_ops,
	.bind		= px30_clk_bind,
	.probe		= px30_clk_probe,
};
