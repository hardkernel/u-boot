/*
 * (C) Copyright 2018 Rockchip Electronics Co., Ltd.
 *
 * SPDX-License-Identifier:     GPL-2.0
 */

#include <common.h>
#include <dm.h>
#include <ram.h>
#include <syscon.h>
#include <asm/arch/clock.h>
#include <asm/arch/grf_rk3308.h>
#include <asm/arch/sdram_common.h>

DECLARE_GLOBAL_DATA_PTR;

struct dram_info {
	struct ram_info info;
};

static int rk3308_dmc_probe(struct udevice *dev)
{
	struct dram_info *priv = dev_get_priv(dev);
	struct rk3308_grf *grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);

	priv->info.base = CONFIG_SYS_SDRAM_BASE;
	priv->info.size = rockchip_sdram_size((phys_addr_t)&grf->os_reg2);

	return 0;
}

static int rk3308_dmc_get_info(struct udevice *dev, struct ram_info *info)
{
	struct dram_info *priv = dev_get_priv(dev);

	*info = priv->info;

	return 0;
}

static struct ram_ops rk3308_dmc_ops = {
	.get_info = rk3308_dmc_get_info,
};


static const struct udevice_id rk3308_dmc_ids[] = {
	{ .compatible = "rockchip,rk3308-dmc" },
	{ }
};

U_BOOT_DRIVER(dmc_rk3308) = {
	.name = "rockchip_rk3308_dmc",
	.id = UCLASS_RAM,
	.of_match = rk3308_dmc_ids,
	.ops = &rk3308_dmc_ops,
	.probe = rk3308_dmc_probe,
	.priv_auto_alloc_size = sizeof(struct dram_info),
};
