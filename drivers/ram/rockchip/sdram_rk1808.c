// SPDX-License-Identifier: GPL-2.0
/*
 * (C) Copyright 2018 Rockchip Electronics Co., Ltd.
 */

#include <common.h>
#include <dm.h>
#include <ram.h>
#include <syscon.h>
#include <asm/arch/clock.h>
#include <asm/arch/grf_rk1808.h>
#include <asm/arch/sdram_common.h>

DECLARE_GLOBAL_DATA_PTR;

struct dram_info {
	struct ram_info info;
	struct rk1808_pmugrf *pmugrf;
};

static int rk1808_dmc_probe(struct udevice *dev)
{
	struct dram_info *priv = dev_get_priv(dev);

	priv->pmugrf = syscon_get_first_range(ROCKCHIP_SYSCON_PMUGRF);
	debug("%s: pmugrf=%p\n", __func__, priv->pmugrf);
	priv->info.base = CONFIG_SYS_SDRAM_BASE;
	priv->info.size =
		rockchip_sdram_size((phys_addr_t)&priv->pmugrf->os_reg[2]);

	return 0;
}

static int rk1808_dmc_get_info(struct udevice *dev, struct ram_info *info)
{
	struct dram_info *priv = dev_get_priv(dev);

	*info = priv->info;

	return 0;
}

static struct ram_ops rk1808_dmc_ops = {
	.get_info = rk1808_dmc_get_info,
};

static const struct udevice_id rk1808_dmc_ids[] = {
	{ .compatible = "rockchip,rk1808-dmc" },
	{ }
};

U_BOOT_DRIVER(dmc_rk1808) = {
	.name = "rockchip_rk1808_dmc",
	.id = UCLASS_RAM,
	.of_match = rk1808_dmc_ids,
	.ops = &rk1808_dmc_ops,
	.probe = rk1808_dmc_probe,
	.priv_auto_alloc_size = sizeof(struct dram_info),
};
