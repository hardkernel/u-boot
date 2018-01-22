/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0
 */

#include <common.h>
#include <dm.h>
#include <ram.h>
#include <syscon.h>
#include <asm/arch/clock.h>
#include <asm/arch/grf_px30.h>
#include <asm/arch/sdram_common.h>

DECLARE_GLOBAL_DATA_PTR;
struct dram_info {
	struct ram_info info;
	struct px30_pmugrf *pmugrf;
};

static int px30_dmc_probe(struct udevice *dev)
{
	struct dram_info *priv = dev_get_priv(dev);

	priv->pmugrf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	debug("%s: pmugrf=%p\n", __func__, priv->pmugrf);
	priv->info.base = CONFIG_SYS_SDRAM_BASE;
	priv->info.size = rockchip_sdram_size(
				(phys_addr_t)&priv->pmugrf->os_reg[2]);

	return 0;
}

static int px30_dmc_get_info(struct udevice *dev, struct ram_info *info)
{
	struct dram_info *priv = dev_get_priv(dev);

	*info = priv->info;

	return 0;
}

static struct ram_ops px30_dmc_ops = {
	.get_info = px30_dmc_get_info,
};


static const struct udevice_id px30_dmc_ids[] = {
	{ .compatible = "rockchip,px30-dmc" },
	{ }
};

U_BOOT_DRIVER(dmc_px30) = {
	.name = "rockchip_px30_dmc",
	.id = UCLASS_RAM,
	.of_match = px30_dmc_ids,
	.ops = &px30_dmc_ops,
	.probe = px30_dmc_probe,
	.priv_auto_alloc_size = sizeof(struct dram_info),
};
