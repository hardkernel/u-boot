/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _FUEL_GAUGE_H_
#define _FUEL_GAUGE_H_

struct dm_fuel_gauge_ops {
	int (*get_soc)(struct udevice *dev);
	int (*get_voltage)(struct udevice *dev);
	int (*get_current)(struct udevice *dev);
	bool (*get_chrg_online)(struct udevice *dev);
};

int fuel_gauge_get_soc(struct udevice *dev);
int fuel_gauge_get_voltage(struct udevice *dev);
int fuel_gauge_get_current(struct udevice *dev);
bool fuel_gauge_get_chrg_online(struct udevice *dev);

#endif
