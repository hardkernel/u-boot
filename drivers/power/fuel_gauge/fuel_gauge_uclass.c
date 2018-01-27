/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <errno.h>
#include <dm.h>
#include <power/fuel_gauge.h>

DECLARE_GLOBAL_DATA_PTR;

int fuel_gauge_get_current(struct udevice *dev)
{
	const struct dm_fuel_gauge_ops *ops = dev_get_driver_ops(dev);

	if (!ops || !ops->get_current)
		return -ENOSYS;

	return ops->get_current(dev);
}

int fuel_gauge_get_voltage(struct udevice *dev)
{
	const struct dm_fuel_gauge_ops *ops = dev_get_driver_ops(dev);

	if (!ops || !ops->get_voltage)
		return -ENOSYS;

	return ops->get_voltage(dev);
}

int fuel_gauge_get_soc(struct udevice *dev)
{
	const struct dm_fuel_gauge_ops *ops = dev_get_driver_ops(dev);

	if (!ops || !ops->get_soc)
		return -ENOSYS;

	return ops->get_soc(dev);
}

bool fuel_gauge_get_chrg_online(struct udevice *dev)
{
	const struct dm_fuel_gauge_ops *ops = dev_get_driver_ops(dev);

	if (!ops || !ops->get_chrg_online)
		return -ENOSYS;

	return ops->get_chrg_online(dev);
}

UCLASS_DRIVER(fuel_guage) = {
	.id		= UCLASS_FG,
	.name		= "fuel_gauge",
};
