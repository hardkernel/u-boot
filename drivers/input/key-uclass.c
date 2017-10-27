/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <dm.h>
#include <key.h>

int key_read(struct udevice *dev)
{
	const struct dm_key_ops *ops = dev_get_driver_ops(dev);

	if (!ops || !ops->read)
		return -ENOSYS;

	return ops->read(dev);
}

int key_type(struct udevice *dev)
{
	const struct dm_key_ops *ops = dev_get_driver_ops(dev);

	if (!ops || !ops->type)
		return -ENOSYS;

	return ops->type;
}

const char *key_name(struct udevice *dev)
{
	const struct dm_key_ops *ops = dev_get_driver_ops(dev);

	if (!ops || !ops->name)
		return NULL;

	return ops->name;
}

UCLASS_DRIVER(key) = {
	.id		= UCLASS_KEY,
	.name		= "key",
};
