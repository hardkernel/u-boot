/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0
 */

#include <common.h>
#include <dm.h>
#include <dm/device-internal.h>
#include <dm/lists.h>
#include <dm/root.h>

#include "rkflash_blk.h"
#include "rkflash_debug.h"

void ftl_free(void *buf)
{
	kfree(buf);
}

ulong rkflash_bread(struct udevice *udev, lbaint_t start,
		    lbaint_t blkcnt, void *dst)
{
	struct blk_desc *block_dev = dev_get_uclass_platdata(udev);
	struct rkflash_info *priv = dev_get_priv(udev->parent);

	debug("%s lba %x cnt %x", __func__, (u32)start, (u32)blkcnt);
	if (blkcnt == 0)
		return -EINVAL;

	if ((start + blkcnt) > block_dev->lba)
		return -EINVAL;

	if (!priv->read)
		return -EINVAL;

	return (ulong)priv->read(udev->parent, (u32)start, (u32)blkcnt, dst);
}

ulong rkflash_bwrite(struct udevice *udev, lbaint_t start,
		     lbaint_t blkcnt, const void *src)
{
	struct blk_desc *block_dev = dev_get_uclass_platdata(udev);
	struct rkflash_info *priv = dev_get_priv(udev->parent);

	if (blkcnt == 0)
		return -EINVAL;

	if ((start + blkcnt) > block_dev->lba)
		return -EINVAL;

	if (!priv->write)
		return -EINVAL;

	return (ulong)priv->write(udev->parent, (u32)start, (u32)blkcnt, src);
}

ulong rkflash_berase(struct udevice *udev, lbaint_t start,
		     lbaint_t blkcnt)
{
	struct blk_desc *block_dev = dev_get_uclass_platdata(udev);
	struct rkflash_info *priv = dev_get_priv(udev->parent);

	if (blkcnt == 0)
		return -EINVAL;

	if ((start + blkcnt) > block_dev->lba)
		return -EINVAL;

	if (!priv->erase)
		return -EINVAL;

	return (ulong)priv->erase(udev->parent, (u32)start, (u32)blkcnt);
}

static int rkflash_blk_probe(struct udevice *udev)
{
	struct rkflash_info *priv = dev_get_priv(udev->parent);
	struct blk_desc *desc = dev_get_uclass_platdata(udev);

	debug("%s %d %p ndev = %p %p\n", __func__, __LINE__,
	      udev, priv, udev->parent);
	priv->child_dev = udev;
	if (priv->flash_con_type == FLASH_CON_TYPE_SFC)
		desc->if_type = IF_TYPE_RKSFC;
	else if (priv->flash_con_type == FLASH_CON_TYPE_NANDC)
		desc->if_type = IF_TYPE_RKNAND;

	desc->lba = priv->density;
	desc->log2blksz = 9;
	desc->blksz = 512;
	desc->bdev = udev;
	desc->devnum = 0;
	sprintf(desc->vendor, "0x%.4x", 0x0308);
	memcpy(desc->product, "rkflash", sizeof("rkflash"));
	memcpy(desc->revision, "V1.00", sizeof("V1.00"));
	part_init(desc);
	rkflash_test(udev);

	return 0;
}

static const struct blk_ops rkflash_blk_ops = {
	.read	= rkflash_bread,
	.write	= rkflash_bwrite,
	.erase	= rkflash_berase,
};

U_BOOT_DRIVER(rkflash_blk) = {
	.name		= "rkflash_blk",
	.id		= UCLASS_BLK,
	.ops		= &rkflash_blk_ops,
	.probe		= rkflash_blk_probe,
};

