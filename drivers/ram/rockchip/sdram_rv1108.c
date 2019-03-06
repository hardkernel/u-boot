/*
 * Copyright (C) 2018 Rockchip Electronics Co., Ltd
 * Author: Zhihuan He <huan.he@rock-chips.com>
 * SPDX-License-Identifier:	GPL-2.0+
 */
#include <common.h>
#include <dm.h>
#include <dm/root.h>
#include <dt-structs.h>
#include <regmap.h>
#include <asm/io.h>
#include <asm/types.h>
#include <asm/arch/hardware.h>
#include <asm/arch/sdram_rv1108.h>
#include <asm/arch/timer.h>
#include <asm/arch/sdram_common.h>

struct dram_info info;

struct rockchip_dmc_plat {
#if CONFIG_IS_ENABLED(OF_PLATDATA)
	struct dtd_rockchip_rv1108_dmc dtplat;
#else
	struct sdram_params params;
#endif
	struct regmap *map;
};

void enable_ddr_io_ret(struct dram_info *priv)
{
	writel(DDR_IO_RET_EN, &priv->pmu->sft_con);
	rk_clrsetreg(&priv->pmu_grf->soc_con[0],
		     DDRPHY_BUFFEREN_CORE_MASK,
		     DDRPHY_BUFFEREN_CORE_EN);
}

void rkdclk_init(struct dram_info *priv,
		 struct sdram_params *params_priv)
{
	rk_clrsetreg(&priv->cru->pll[1].con3, WORK_MODE_MASK,
		     WORK_MODE_SLOW << WORK_MODE_SHIFT);
	rk_clrsetreg(&priv->cru->pll[1].con3, GLOBAL_POWER_DOWN_MASK,
		     GLOBAL_POWER_DOWN << GLOBAL_POWER_DOWN_SHIFT);
	rk_clrsetreg(&priv->cru->pll[1].con3, DSMPD_MASK,
		     INTEGER_MODE << DSMPD_SHIFT);
	rk_clrsetreg(&priv->cru->pll[1].con0, FBDIV_MASK,
		     params_priv->dpll_init_cfg.fbdiv << FBDIV_SHIFT);
	rk_clrsetreg(&priv->cru->pll[1].con1,
		     POSTDIV2_MASK | POSTDIV1_MASK | REFDIV_MASK,
		     params_priv->dpll_init_cfg.postdiv2 << POSTDIV2_SHIFT |
		     params_priv->dpll_init_cfg.postdiv1 << POSTDIV1_SHIFT |
		     params_priv->dpll_init_cfg.refdiv << REFDIV_SHIFT);
	rk_clrsetreg(&priv->cru->pll[1].con3, GLOBAL_POWER_DOWN_MASK,
		     GLOBAL_POWER_UP << GLOBAL_POWER_DOWN_SHIFT);
	while (!(readl(&priv->cru->pll[1].con2) & (1u << LOCK_STA_SHIFT)))
		udelay(1);

	rk_clrsetreg(&priv->cru->clksel_con[4], CLK_DDR_PLL_SEL_MASK |
		     CLK_DDR_DIV_CON_MASK, 0 << CLK_DDR_PLL_SEL_SHIFT |
		     0 << CLK_DDR_DIV_CON_SHIFT);
	rk_clrsetreg(&priv->cru->pll[1].con3, WORK_MODE_MASK,
		     WORK_MODE_NORMAL << WORK_MODE_SHIFT);
}

void phy_pctrl_reset_cru(struct dram_info *priv)
{
	rk_clrsetreg(&priv->cru->softrst_con[2], DDRUPCTL_PSRSTN_REQ_MASK |
		     DDRUPCTL_NSRSTN_REQ_MASK,
		     DDRUPCTL_PSRSTN_REQ << DDRUPCTL_PSRSTN_REQ_SHIFT |
		     DDRUPCTL_NSRSTN_REQ << DDRUPCTL_NSRSTN_REQ_SHIFT);
	rk_clrsetreg(&priv->cru->softrst_con[1],
		     DDRPHY_SRSTN_CLKDIV_REQ_MASK | DDRPHY_SRSTN_REQ_MASK |
		     DDRPHY_PSRSTN_REQ_MASK,
		     DDRPHY_SRSTN_CLKDIV_REQ << DDRPHY_SRSTN_CLKDIV_REQ_SHIFT |
		     DDRPHY_SRSTN_REQ << DDRPHY_SRSTN_REQ_SHIFT |
		     DDRPHY_PSRSTN_REQ << DDRPHY_PSRSTN_REQ_SHIFT);

	udelay(10);

	rk_clrsetreg(&priv->cru->softrst_con[1],
		     DDRPHY_SRSTN_CLKDIV_REQ_MASK | DDRPHY_SRSTN_REQ_MASK |
		     DDRPHY_PSRSTN_REQ_MASK,
		     DDRPHY_SRSTN_CLKDIV_DIS << DDRPHY_SRSTN_CLKDIV_REQ_SHIFT |
		     DDRPHY_PSRSTN_DIS << DDRPHY_PSRSTN_REQ_SHIFT |
		     DDRPHY_SRSTN_DIS << DDRPHY_SRSTN_REQ_SHIFT);
	udelay(10);

	rk_clrsetreg(&priv->cru->softrst_con[2], DDRUPCTL_PSRSTN_REQ_MASK |
		     DDRUPCTL_NSRSTN_REQ_MASK,
		     DDRUPCTL_PSRSTN_DIS << DDRUPCTL_PSRSTN_REQ_SHIFT |
		     DDRUPCTL_NSRSTN_DIS << DDRUPCTL_NSRSTN_REQ_SHIFT);
	udelay(10);
}

void set_bw_grf(struct dram_info *priv)
{
	rk_clrsetreg(&priv->grf->soc_con0,
		     MSCH_MAINPARTIALPOP_MASK,
		     MSCH_MAINPARTIALPOP);
}

void pctl_cfg_grf(struct dram_info *priv)
{
	writel(RK_SETBITS(MSCH_MAINDDR3 | MSCH_MAINPARTIALPOP),
	       &priv->grf->soc_con0);
}

void *get_base_addr(unsigned int *reg, unsigned int offset)
{
	u32 p = *(reg + 2 * offset);

	return (void *)p;
}

void get_ddr_param(struct dram_info *sdram_priv,
		   struct ddr_param *ddr_param)
{
	size_t ram_size =
		rockchip_sdram_size((phys_addr_t)&sdram_priv->grf->os_reg2);

	ddr_param->count = 1;
	ddr_param->para[0] = CONFIG_SYS_SDRAM_BASE;
	ddr_param->para[1] = ram_size;
}

int sdram_init(void)
{
	int ret;
	struct ddr_param ddr_param;
	struct dram_info *sdram_priv = &info;
	struct driver_info *info =
		ll_entry_start(struct driver_info, driver_info);
#if CONFIG_IS_ENABLED(OF_PLATDATA)
	struct dtd_rockchip_rv1108_dmc *dtplat = (void *)info->platdata;
	struct sdram_params *params = (void *)dtplat->rockchip_sdram_params;

	sdram_priv->pctl = get_base_addr((void *)dtplat->reg, 0);
	sdram_priv->phy = get_base_addr((void *)dtplat->reg, 1);
	sdram_priv->service_msch = get_base_addr((void *)dtplat->reg, 2);
	sdram_priv->grf = get_base_addr((void *)dtplat->reg, 3);
	sdram_priv->pmu_grf = get_base_addr((void *)dtplat->reg, 4);
	sdram_priv->cru = get_base_addr((void *)dtplat->reg, 5);
	sdram_priv->pmu = get_base_addr((void *)dtplat->reg, 6);
#else
	struct sdram_params *params = (void *)info->platdata;
#endif
	ret = rv1108_sdram_init(sdram_priv, params);
	if (ret)
		debug("rv1108_sdram_init() fail!");

	get_ddr_param(sdram_priv, &ddr_param);
	rockchip_setup_ddr_param(&ddr_param);

	return ret;
}
