/*
 * Copyright (C) 2017 Álvaro Fernández Rojas <noltari@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <power-domain-uclass.h>
#include <asm/io.h>

#define MAX_DOMAINS	32

struct bcm6328_power_domain {
	void __iomem *regs;
};

static int bcm6328_power_domain_request(struct power_domain *power_domain)
{
	if (power_domain->id >= MAX_DOMAINS)
		return -EINVAL;

	return 0;
}

static int bcm6328_power_domain_on(struct power_domain *power_domain)
{
	struct bcm6328_power_domain *priv = dev_get_priv(power_domain->dev);

	clrbits_be32(priv->regs, BIT(power_domain->id));

	return 0;
}

static int bcm6328_power_domain_off(struct power_domain *power_domain)
{
	struct bcm6328_power_domain *priv = dev_get_priv(power_domain->dev);

	setbits_be32(priv->regs, BIT(power_domain->id));

	return 0;
}

static int bcm6328_power_domain_probe(struct udevice *dev)
{
	struct bcm6328_power_domain *priv = dev_get_priv(dev);
	fdt_addr_t addr;
	fdt_size_t size;

	addr = devfdt_get_addr_size_index(dev, 0, &size);
	if (addr == FDT_ADDR_T_NONE)
		return -EINVAL;

	priv->regs = ioremap(addr, size);

	return 0;
}

static const struct udevice_id bcm6328_power_domain_ids[] = {
	{ .compatible = "brcm,bcm6328-power-domain" },
	{ /* sentinel */ }
};

struct power_domain_ops bcm6328_power_domain_ops = {
	.off = bcm6328_power_domain_off,
	.on = bcm6328_power_domain_on,
	.request = bcm6328_power_domain_request,
};

U_BOOT_DRIVER(bcm6328_power_domain) = {
	.name = "bcm6328_power_domain",
	.id = UCLASS_POWER_DOMAIN,
	.of_match = bcm6328_power_domain_ids,
	.ops = &bcm6328_power_domain_ops,
	.priv_auto_alloc_size = sizeof(struct bcm6328_power_domain),
	.probe = bcm6328_power_domain_probe,
};
