/*
 * Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier: (GPL-2.0+ OR MIT)
 */
#include <common.h>
#include <dm.h>

#include "rkflash_api.h"
#include "rkflash_blk.h"

#ifdef CONFIG_RKSFC_NOR
int rk_snor_init(struct udevice *udev)
{
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	return snor_init(p_dev);
}

u32 rk_snor_get_capacity(struct udevice *udev)
{
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	return snor_get_capacity(p_dev);
}

int rk_snor_read(struct udevice *udev, u32 sec, u32 n_sec, void *p_data)
{
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	return snor_read(p_dev, sec, n_sec, p_data);
}

int rk_snor_write(struct udevice *udev, u32 sec, u32 n_sec, const void *p_data)
{
	struct rkflash_info *priv = dev_get_priv(udev);
	struct SFNOR_DEV *p_dev = (struct SFNOR_DEV *)&priv->flash_dev_info;

	return snor_write(p_dev, sec, n_sec, p_data);
}
#endif

