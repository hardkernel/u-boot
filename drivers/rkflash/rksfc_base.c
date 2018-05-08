/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier: (GPL-2.0+ OR MIT)
 */

#include <common.h>
#include <clk.h>
#include <dm.h>
#include <dm/device-internal.h>
#include <asm/arch/clock.h>

#include "rkflash_blk.h"
#include "rkflash_api.h"

static struct flash_operation spi_flash_op = {
#ifdef	CONFIG_RKSFC_NOR
	FLASH_TYPE_SFC_NOR,
	rk_snor_init,
	rk_snor_get_capacity,
	rk_snor_read,
	rk_snor_write,
#else
	-1, NULL, NULL, NULL, NULL,
#endif
};

int rksfc_scan_namespace(void)
{
	struct uclass *uc;
	struct udevice *dev;
	int ret;

	ret = uclass_get(UCLASS_SPI_FLASH, &uc);
	if (ret)
		return ret;

	uclass_foreach_dev(dev, uc) {
		debug("%s %d %p\n", __func__, __LINE__, dev);
		ret = device_probe(dev);
		if (ret)
			return ret;
	}

	return 0;
}

static int rksfc_blk_bind(struct udevice *udev)
{
	struct udevice *bdev;
	int ret;

	ret = blk_create_devicef(udev, "rkflash_blk", "blk",
				 IF_TYPE_RKSFC,
				 0, 512, 0, &bdev);
	if (ret) {
		debug("Cannot create block device\n");
		return ret;
	}

	return 0;
}

static int rockchip_rksfc_ofdata_to_platdata(struct udevice *dev)
{
	struct rkflash_info *priv = dev_get_priv(dev);

	priv->ioaddr = dev_read_addr_ptr(dev);

	return 0;
}

static int rockchip_rksfc_probe(struct udevice *udev)
{
	int ret;
	struct rkflash_info *priv = dev_get_priv(udev);

	debug("%s %d %p ndev = %p\n", __func__, __LINE__, udev, priv);

	sfc_init(priv->ioaddr);
	if (spi_flash_op.id == -1) {
		debug("%s no optional spi flash\n", __func__);
		return 0;
	}
	ret = spi_flash_op.flash_init(udev);
	if (!ret) {
		priv->flash_con_type = FLASH_CON_TYPE_SFC;
		priv->density = spi_flash_op.flash_get_capacity(udev);
		priv->read = spi_flash_op.flash_read;
		priv->write = spi_flash_op.flash_write;
	}

	return ret;
}

UCLASS_DRIVER(rksfc) = {
	.id		= UCLASS_SPI_FLASH,
	.name		= "rksfc",
	.flags		= DM_UC_FLAG_SEQ_ALIAS,
};

static const struct udevice_id rockchip_sfc_ids[] = {
	{ .compatible = "rockchip,rksfc" },
	{ }
};

U_BOOT_DRIVER(rksfc) = {
	.name		= "rksfc",
	.id		= UCLASS_SPI_FLASH,
	.of_match	= rockchip_sfc_ids,
	.bind		= rksfc_blk_bind,
	.probe		= rockchip_rksfc_probe,
	.priv_auto_alloc_size = sizeof(struct rkflash_info),
	.ofdata_to_platdata = rockchip_rksfc_ofdata_to_platdata,
};

