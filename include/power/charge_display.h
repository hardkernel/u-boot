/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _CHARGE_DISPLAY_H_
#define _CHARGE_DISPLAY_H_

struct dm_charge_display_ops {
	int (*get_power_on_soc)(struct udevice *dev);
	int (*get_power_on_voltage)(struct udevice *dev);
	int (*get_screen_on_voltage)(struct udevice *dev);
	int (*set_power_on_soc)(struct udevice *dev, int val);
	int (*set_power_on_voltage)(struct udevice *dev, int val);
	int (*set_screen_on_voltage)(struct udevice *dev, int val);
	int (*show)(struct udevice *dev);
};

int charge_display_get_power_on_soc(struct udevice *dev);
int charge_display_get_power_on_voltage(struct udevice *dev);
int charge_display_get_screen_on_voltage(struct udevice *dev);
int charge_display_set_power_on_soc(struct udevice *dev, int val);
int charge_display_set_power_on_voltage(struct udevice *dev, int val);
int charge_display_set_screen_on_voltage(struct udevice *dev, int val);

int charge_display_show(struct udevice *dev);

#endif
