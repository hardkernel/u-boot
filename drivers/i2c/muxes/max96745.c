// SPDX-License-Identifier: GPL-2.0+
/*
 * (C) Copyright 2022 Rockchip Electronics Co., Ltd
 */

#include <asm-generic/gpio.h>
#include <common.h>
#include <dm.h>
#include <errno.h>
#include <i2c.h>
#include <max96745.h>

struct max96745_priv {
	struct udevice *dev;
	struct gpio_desc enable_gpio;
};

static int max96745_select(struct udevice *mux, struct udevice *bus,
			   uint channel)
{
	if (channel == 1)
		dm_i2c_reg_clrset(mux, 0x0086, DIS_REM_CC,
				  FIELD_PREP(DIS_REM_CC, 0));
	else
		dm_i2c_reg_clrset(mux, 0x0076, DIS_REM_CC,
				  FIELD_PREP(DIS_REM_CC, 0));

	return 0;
}

static int max96745_deselect(struct udevice *mux, struct udevice *bus,
			     uint channel)
{
	if (channel == 1)
		dm_i2c_reg_clrset(mux, 0x0086, DIS_REM_CC,
				  FIELD_PREP(DIS_REM_CC, 1));
	else
		dm_i2c_reg_clrset(mux, 0x0076, DIS_REM_CC,
				  FIELD_PREP(DIS_REM_CC, 1));

	return 0;
}

static const struct i2c_mux_ops max96745_ops = {
	.select = max96745_select,
	.deselect = max96745_deselect,
};

static int max96745_power_on(struct max96745_priv *priv)
{
	int ret;

	if (dm_gpio_is_valid(&priv->enable_gpio)) {
		dm_gpio_set_value(&priv->enable_gpio, 1);
		mdelay(100);
	}

	ret = dm_i2c_reg_clrset(priv->dev, 0x0010, RESET_ALL,
				FIELD_PREP(RESET_ALL, 1));
	if (ret < 0)
		return ret;

	mdelay(100);

	return 0;
}

static int max96745_power_off(struct max96745_priv *priv)
{
	if (dm_gpio_is_valid(&priv->enable_gpio))
		dm_gpio_set_value(&priv->enable_gpio, 0);

	return 0;
}

static int max96745_probe(struct udevice *dev)
{
	struct max96745_priv *priv = dev_get_priv(dev);
	int ret;

	ret = i2c_set_chip_offset_len(dev, 2);
	if (ret)
		return ret;

	priv->dev = dev;

	ret = gpio_request_by_name(dev, "enable-gpios", 0,
				   &priv->enable_gpio, GPIOD_IS_OUT);
	if (ret && ret != -ENOENT) {
		dev_err(dev, "%s: failed to get enable GPIO: %d\n", __func__, ret);
		return ret;
	}

	ret = max96745_power_on(priv);
	if (ret) {
		dev_err(dev, "%s: failed to power on: %d\n", __func__, ret);
		return ret;
	}

	ret = dm_i2c_reg_read(dev, 0x002a);
	if (ret < 0 || !FIELD_GET(LINK_LOCKED, ret)) {
		max96745_power_off(priv);
		dev_err(dev, "%s: GMSL link not locked\n", __func__);
		return -ENODEV;
	}

	dm_i2c_reg_clrset(dev, 0x0076, DIS_REM_CC, FIELD_PREP(DIS_REM_CC, 1));
	dm_i2c_reg_clrset(dev, 0x0086, DIS_REM_CC, FIELD_PREP(DIS_REM_CC, 1));

	return 0;
}

static const struct udevice_id max96745_of_match[] = {
	{ .compatible = "maxim,max96745" },
	{}
};

U_BOOT_DRIVER(max96745) = {
	.name = "max96745",
	.id = UCLASS_I2C_MUX,
	.of_match = max96745_of_match,
	.bind = dm_scan_fdt_dev,
	.probe = max96745_probe,
	.ops = &max96745_ops,
	.priv_auto_alloc_size = sizeof(struct max96745_priv),
};
