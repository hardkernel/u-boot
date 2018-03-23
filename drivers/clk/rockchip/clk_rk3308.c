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
#include <asm/arch/cru_rk3308.h>
#include <asm/arch/hardware.h>
#include <asm/io.h>
#include <dm/lists.h>
#include <dt-bindings/clock/rk3308-cru.h>

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

static const struct pll_div apll_816_cfg = PLL_DIVISORS(816 * MHz, 1, 2, 1);

static u8 pll_mode_shift[PLL_COUNT] = {
	APLL_MODE_SHIFT, DPLL_MODE_SHIFT, VPLL0_MODE_SHIFT,
	VPLL1_MODE_SHIFT
};

static u32 pll_mode_mask[PLL_COUNT] = {
	APLL_MODE_MASK, DPLL_MODE_MASK, VPLL0_MODE_MASK,
	VPLL1_MODE_MASK
};

static ulong apll_hz, dpll_hz, vpll0_hz;

/*
 * How to calculate the PLL:
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

static void rkclk_set_pll(struct rk3308_cru *cru, enum rk3308_pll_id pll_id,
			  const struct pll_div *div)
{
	struct rk3308_pll *pll;
	unsigned int *mode;
	/* All PLLs have same VCO and output frequency range restrictions. */
	uint vco_hz = OSC_HZ / 1000 * div->fbdiv / div->refdiv * 1000;
	uint output_hz = vco_hz / div->postdiv1 / div->postdiv2;

	pll = &cru->pll[pll_id];
	mode = &cru->mode;

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
	while (!(readl(&pll->con1) & (1 << PLL_LOCK_STATUS_SHIFT)))
		udelay(1);

	rk_clrsetreg(mode, pll_mode_mask[pll_id],
		     PLLMUX_FROM_PLL << pll_mode_shift[pll_id]);
}

static uint32_t rkclk_pll_get_rate(struct rk3308_cru *cru,
				   enum rk3308_pll_id pll_id)
{
	u32 refdiv, fbdiv, postdiv1, postdiv2;
	u32 con;
	struct rk3308_pll *pll;
	uint shift;
	uint mask;

	pll = &cru->pll[pll_id];
	con = readl(&cru->mode);

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

static void rkclk_init(struct rk3308_cru *cru)
{
	u32 aclk_div, hclk_div, pclk_div;

	/* init pll */
	rkclk_set_pll(cru, APLL, &apll_816_cfg);

	/*
	 * select apll as cpu/core clock pll source and
	 * set up dependent divisors for PCLK and ACLK clocks.
	 * core hz : apll = 1:1
	 */
	apll_hz = rkclk_pll_get_rate(cru, APLL);
	aclk_div = apll_hz / CORE_ACLK_HZ - 1;
	pclk_div = apll_hz / CORE_DBG_HZ - 1;
	rk_clrsetreg(&cru->clksel_con[0],
		     CORE_ACLK_DIV_MASK | CORE_DBG_DIV_MASK |
		     CORE_CLK_PLL_SEL_MASK | CORE_DIV_CON_MASK,
		     aclk_div << CORE_ACLK_DIV_SHIFT |
		     pclk_div << CORE_DBG_DIV_SHIFT |
		     CORE_CLK_PLL_SEL_APLL << CORE_CLK_PLL_SEL_SHIFT |
		     0 << CORE_DIV_CON_SHIFT);

	/*
	 * select dpll as pd_bus bus clock source and
	 * set up dependent divisors for PCLK/HCLK and ACLK clocks.
	 */
	dpll_hz = rkclk_pll_get_rate(cru, DPLL);
	aclk_div = dpll_hz / BUS_ACLK_HZ - 1;
	hclk_div = dpll_hz / BUS_HCLK_HZ - 1;
	pclk_div = dpll_hz / BUS_PCLK_HZ - 1;
	rk_clrsetreg(&cru->clksel_con[5],
		     BUS_PLL_SEL_MASK | BUS_ACLK_DIV_MASK,
		     BUS_PLL_SEL_DPLL << BUS_PLL_SEL_SHIFT |
		     aclk_div << BUS_ACLK_DIV_SHIFT);
	rk_clrsetreg(&cru->clksel_con[6],
		     BUS_PCLK_DIV_MASK | BUS_HCLK_DIV_MASK,
		     pclk_div << BUS_PCLK_DIV_SHIFT |
		     hclk_div << BUS_HCLK_DIV_SHIFT);

	/*
	 * select vpll0 as pd_peri bus clock source and
	 * set up dependent divisors for PCLK/HCLK and ACLK clocks.
	 */
	vpll0_hz = rkclk_pll_get_rate(cru, VPLL0);
	aclk_div = vpll0_hz / PERI_ACLK_HZ - 1;
	hclk_div = vpll0_hz / PERI_HCLK_HZ - 1;
	pclk_div = vpll0_hz / PERI_PCLK_HZ - 1;
	rk_clrsetreg(&cru->clksel_con[36],
		     PERI_PLL_SEL_MASK | PERI_ACLK_DIV_MASK,
		     PERI_PLL_VPLL0 << PERI_PLL_SEL_SHIFT |
		     aclk_div << PERI_ACLK_DIV_SHIFT);
	rk_clrsetreg(&cru->clksel_con[37],
		     PERI_PCLK_DIV_MASK | PERI_HCLK_DIV_MASK,
		     pclk_div << PERI_PCLK_DIV_SHIFT |
		     hclk_div << PERI_HCLK_DIV_SHIFT);
}

static ulong rk3308_i2c_get_clk(struct rk3308_cru *cru, ulong clk_id)
{
	u32 div, con, con_id;

	switch (clk_id) {
	case SCLK_I2C0:
		con_id = 25;
		break;
	case SCLK_I2C1:
		con_id = 26;
		break;
	case SCLK_I2C2:
		con_id = 27;
		break;
	case SCLK_I2C3:
		con_id = 28;
		break;
	default:
		printf("do not support this i2c bus\n");
		return -EINVAL;
	}

	con = readl(&cru->clksel_con[con_id]);
	div = con >> CLK_I2C_DIV_CON_SHIFT & CLK_I2C_DIV_CON_MASK;

	return DIV_TO_RATE(dpll_hz, div);
}

static ulong rk3308_i2c_set_clk(struct rk3308_cru *cru, ulong clk_id, uint hz)
{
	u32 src_clk_div, con_id;

	src_clk_div = dpll_hz / hz;
	assert(src_clk_div - 1 < 127);

	switch (clk_id) {
	case SCLK_I2C0:
		con_id = 25;
		break;
	case SCLK_I2C1:
		con_id = 26;
		break;
	case SCLK_I2C2:
		con_id = 27;
		break;
	case SCLK_I2C3:
		con_id = 28;
		break;
	default:
		printf("do not support this i2c bus\n");
		return -EINVAL;
	}
	rk_clrsetreg(&cru->clksel_con[con_id],
		     CLK_I2C_PLL_SEL_MASK | CLK_I2C_DIV_CON_MASK,
		     CLK_I2C_PLL_SEL_DPLL << CLK_I2C_PLL_SEL_SHIFT |
		     (src_clk_div - 1) << CLK_I2C_DIV_CON_SHIFT);

	return rk3308_i2c_get_clk(cru, clk_id);
}

static ulong rk3308_mmc_get_clk(struct rk3308_cru *cru, uint clk_id)
{
	u32 div, con, con_id;

	switch (clk_id) {
	case HCLK_SDMMC:
	case SCLK_SDMMC:
		con_id = 39;
		break;
	case HCLK_EMMC:
	case SCLK_EMMC:
	case SCLK_EMMC_SAMPLE:
		con_id = 41;
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
		return DIV_TO_RATE(vpll0_hz, div) / 2;
}

static ulong rk3308_mmc_set_clk(struct rk3308_cru *cru,
				ulong clk_id, ulong set_rate)
{
	int src_clk_div;
	u32 con_id;

	debug("%s %ld %ld\n", __func__, clk_id, set_rate);

	switch (clk_id) {
	case HCLK_SDMMC:
	case SCLK_SDMMC:
		con_id = 39;
		break;
	case HCLK_EMMC:
	case SCLK_EMMC:
		con_id = 41;
		break;
	default:
		return -EINVAL;
	}
	/* Select clk_sdmmc/emmc source from VPLL0 by default */
	/* mmc clock defaulg div 2 internal, need provide double in cru */
	src_clk_div = DIV_ROUND_UP(vpll0_hz / 2, set_rate);

	if (src_clk_div > 127) {
		/* use 24MHz source for 400KHz clock */
		src_clk_div = DIV_ROUND_UP(OSC_HZ / 2, set_rate);
		rk_clrsetreg(&cru->clksel_con[con_id],
			     EMMC_PLL_MASK | EMMC_DIV_MASK | EMMC_CLK_SEL_MASK,
			     EMMC_CLK_SEL_EMMC << EMMC_CLK_SEL_SHIFT |
			     EMMC_SEL_24M << EMMC_PLL_SHIFT |
			     (src_clk_div - 1) << EMMC_DIV_SHIFT);
	} else {
		rk_clrsetreg(&cru->clksel_con[con_id],
			     EMMC_PLL_MASK | EMMC_DIV_MASK | EMMC_CLK_SEL_MASK,
			     EMMC_CLK_SEL_EMMC << EMMC_CLK_SEL_SHIFT |
			     EMMC_SEL_VPLL0 << EMMC_PLL_SHIFT |
			     (src_clk_div - 1) << EMMC_DIV_SHIFT);
	}

	return rk3308_mmc_get_clk(cru, clk_id);
}

static ulong rk3308_saradc_get_clk(struct rk3308_cru *cru)
{
	u32 div, con;

	con = readl(&cru->clksel_con[34]);
	div = con >> CLK_SARADC_DIV_CON_SHIFT & CLK_SARADC_DIV_CON_MASK;

	return DIV_TO_RATE(OSC_HZ, div);
}

static ulong rk3308_saradc_set_clk(struct rk3308_cru *cru, uint hz)
{
	int src_clk_div;

	src_clk_div = OSC_HZ / hz;
	assert(src_clk_div - 1 < 2047);

	rk_clrsetreg(&cru->clksel_con[34],
		     CLK_SARADC_DIV_CON_MASK,
		     (src_clk_div - 1) << CLK_SARADC_DIV_CON_SHIFT);

	return rk3308_saradc_get_clk(cru);
}

static ulong rk3308_spi_get_clk(struct rk3308_cru *cru, ulong clk_id)
{
	u32 div, con, con_id;

	switch (clk_id) {
	case SCLK_SPI0:
		con_id = 30;
		break;
	case SCLK_SPI1:
		con_id = 31;
		break;
	case SCLK_SPI2:
		con_id = 32;
		break;
	default:
		printf("do not support this spi bus\n");
		return -EINVAL;
	}

	con = readl(&cru->clksel_con[con_id]);
	div = con >> CLK_SPI_DIV_CON_SHIFT & CLK_SPI_DIV_CON_MASK;

	return DIV_TO_RATE(dpll_hz, div);
}

static ulong rk3308_spi_set_clk(struct rk3308_cru *cru, ulong clk_id, uint hz)
{
	u32 src_clk_div, con_id;

	src_clk_div = dpll_hz / hz;
	assert(src_clk_div - 1 < 127);

	switch (clk_id) {
	case SCLK_SPI0:
		con_id = 30;
		break;
	case SCLK_SPI1:
		con_id = 31;
		break;
	case SCLK_SPI2:
		con_id = 32;
		break;
	default:
		printf("do not support this spi bus\n");
		return -EINVAL;
	}

	rk_clrsetreg(&cru->clksel_con[con_id],
		     CLK_SPI_PLL_SEL_MASK | CLK_SPI_DIV_CON_MASK,
		     CLK_SPI_PLL_SEL_DPLL << CLK_SPI_PLL_SEL_SHIFT |
		     (src_clk_div - 1) << CLK_SPI_DIV_CON_SHIFT);

	return rk3308_spi_get_clk(cru, clk_id);
}

static ulong rk3308_pwm_get_clk(struct rk3308_cru *cru)
{
	u32 div, con;

	con = readl(&cru->clksel_con[29]);
	div = con >> CLK_PWM_DIV_CON_SHIFT & CLK_PWM_DIV_CON_MASK;

	return DIV_TO_RATE(dpll_hz, div);
}

static ulong rk3308_pwm_set_clk(struct rk3308_cru *cru, uint hz)
{
	int src_clk_div;

	src_clk_div = dpll_hz / hz;
	assert(src_clk_div - 1 < 127);

	rk_clrsetreg(&cru->clksel_con[29],
		     CLK_PWM_PLL_SEL_MASK | CLK_PWM_DIV_CON_MASK,
		     CLK_PWM_PLL_SEL_DPLL << CLK_PWM_PLL_SEL_SHIFT |
		     (src_clk_div - 1) << CLK_PWM_DIV_CON_SHIFT);

	return rk3308_pwm_get_clk(cru);
}

static ulong rk3308_clk_get_rate(struct clk *clk)
{
	struct rk3308_clk_priv *priv = dev_get_priv(clk->dev);
	ulong rate = 0;

	debug("%s id:%ld\n", __func__, clk->id);

	switch (clk->id) {
	case 0 ... 15:
		return 0;
	case HCLK_SDMMC:
	case HCLK_EMMC:
	case SCLK_SDMMC:
	case SCLK_EMMC:
	case SCLK_EMMC_SAMPLE:
		rate = rk3308_mmc_get_clk(priv->cru, clk->id);
		break;
	case SCLK_I2C0:
	case SCLK_I2C1:
	case SCLK_I2C2:
	case SCLK_I2C3:
		rate = rk3308_i2c_get_clk(priv->cru, clk->id);
		break;
	case SCLK_SARADC:
		rate = rk3308_saradc_get_clk(priv->cru);
		break;
	case SCLK_SPI0:
	case SCLK_SPI1:
		rate = rk3308_spi_get_clk(priv->cru, clk->id);
		break;
	case SCLK_PWM:
		rate = rk3308_pwm_get_clk(priv->cru);
		break;
	default:
		return -ENOENT;
	}

	return rate;
}

static ulong rk3308_clk_set_rate(struct clk *clk, ulong rate)
{
	struct rk3308_clk_priv *priv = dev_get_priv(clk->dev);
	ulong ret = 0;

	debug("%s %ld %ld\n", __func__, clk->id, rate);
	switch (clk->id) {
	case 0 ... 15:
		return 0;
	case HCLK_SDMMC:
	case HCLK_EMMC:
	case SCLK_SDMMC:
	case SCLK_EMMC:
		ret = rk3308_mmc_set_clk(priv->cru, clk->id, rate);
		break;
	case SCLK_I2C0:
	case SCLK_I2C1:
	case SCLK_I2C2:
	case SCLK_I2C3:
		ret = rk3308_i2c_set_clk(priv->cru, clk->id, rate);
		break;
	case SCLK_SARADC:
		ret = rk3308_saradc_set_clk(priv->cru, rate);
		break;
	case SCLK_SPI0:
	case SCLK_SPI1:
		ret = rk3308_spi_set_clk(priv->cru, clk->id, rate);
		break;
	case SCLK_PWM:
		ret = rk3308_pwm_set_clk(priv->cru, rate);
		break;
	default:
		return -ENOENT;
	}

	return ret;
}

#define ROCKCHIP_MMC_DELAY_SEL		BIT(11)
#define ROCKCHIP_MMC_DEGREE_OFFSET	1
#define ROCKCHIP_MMC_DEGREE_MASK	(0x3 << ROCKCHIP_MMC_DEGREE_OFFSET)
#define ROCKCHIP_MMC_DELAYNUM_OFFSET	3
#define ROCKCHIP_MMC_DELAYNUM_MASK	(0xff << ROCKCHIP_MMC_DELAYNUM_OFFSET)

#define PSECS_PER_SEC 1000000000000LL
/*
 * Each fine delay is between 44ps-77ps. Assume each fine delay is 60ps to
 * simplify calculations. So 45degs could be anywhere between 33deg and 57.8deg.
 */
#define ROCKCHIP_MMC_DELAY_ELEMENT_PSEC 60

int rockchip_mmc_get_phase(struct clk *clk)
{
	struct rk3308_clk_priv *priv = dev_get_priv(clk->dev);
	struct rk3308_cru *cru = priv->cru;
	u32 raw_value, delay_num;
	u16 degrees = 0;
	ulong rate;

	rate = rk3308_clk_get_rate(clk);

	if (rate < 0)
		return rate;

	if (clk->id == SCLK_EMMC_SAMPLE)
		raw_value = readl(&cru->emmc_con[1]);
	else
		raw_value = readl(&cru->sdmmc_con[1]);

	raw_value &= ROCKCHIP_MMC_DEGREE_MASK;
	degrees = (raw_value >>  ROCKCHIP_MMC_DEGREE_OFFSET) * 90;

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
	struct rk3308_clk_priv *priv = dev_get_priv(clk->dev);
	struct rk3308_cru *cru = priv->cru;
	u8 nineties, remainder, delay_num;
	u32 raw_value, delay;
	ulong rate;

	rate = rk3308_clk_get_rate(clk);

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
	raw_value |= nineties << ROCKCHIP_MMC_DEGREE_OFFSET;

	if (clk->id == SCLK_EMMC_SAMPLE)
		writel(raw_value | 0xffff0000, &cru->emmc_con[1]);
	else
		writel(raw_value | 0xffff0000, &cru->sdmmc_con[1]);

	debug("mmc set_phase(%d) delay_nums=%u reg=%#x actual_degrees=%d\n",
	      degrees, delay_num, raw_value, rockchip_mmc_get_phase(clk));

	return 0;

}

static int rk3308_clk_get_phase(struct clk *clk)
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

static int rk3308_clk_set_phase(struct clk *clk, int degrees)
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

static struct clk_ops rk3308_clk_ops = {
	.get_rate = rk3308_clk_get_rate,
	.set_rate = rk3308_clk_set_rate,
	.get_phase	= rk3308_clk_get_phase,
	.set_phase	= rk3308_clk_set_phase,
};

static int rk3308_clk_probe(struct udevice *dev)
{
	struct rk3308_clk_priv *priv = dev_get_priv(dev);

	rkclk_init(priv->cru);

	return 0;
}

static int rk3308_clk_ofdata_to_platdata(struct udevice *dev)
{
	struct rk3308_clk_priv *priv = dev_get_priv(dev);

	priv->cru = dev_read_addr_ptr(dev);

	return 0;
}

static int rk3308_clk_bind(struct udevice *dev)
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
		priv->glb_srst_fst_value = offsetof(struct rk3308_cru,
						    glb_srst_fst);
		priv->glb_srst_snd_value = offsetof(struct rk3308_cru,
						    glb_srst_snd);
		sys_child->priv = priv;
	}

	ret = device_bind_driver_to_node(dev, "rockchip_reset", "reset",
					 dev_ofnode(dev), &sf_child);
	if (ret) {
		debug("Warning: No rockchip reset driver: ret=%d\n", ret);
	} else {
		sf_priv = malloc(sizeof(struct softreset_reg));
		sf_priv->sf_reset_offset = offsetof(struct rk3308_cru,
						    softrst_con[0]);
		sf_priv->sf_reset_num = 12;
		sf_child->priv = sf_priv;
	}

	return 0;
}

static const struct udevice_id rk3308_clk_ids[] = {
	{ .compatible = "rockchip,rk3308-cru" },
	{ }
};

U_BOOT_DRIVER(rockchip_rk3308_cru) = {
	.name		= "rockchip_rk3308_cru",
	.id		= UCLASS_CLK,
	.of_match	= rk3308_clk_ids,
	.priv_auto_alloc_size = sizeof(struct rk3308_clk_priv),
	.ofdata_to_platdata = rk3308_clk_ofdata_to_platdata,
	.ops		= &rk3308_clk_ops,
	.bind		= rk3308_clk_bind,
	.probe		= rk3308_clk_probe,
};
