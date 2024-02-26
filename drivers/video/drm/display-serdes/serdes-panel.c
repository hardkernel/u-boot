// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * serdes-panel.c  --  display panel for different serdes chips
 *
 * Copyright (c) 2023 Rockchip Electronics Co. Ltd.
 *
 * Author: luowei <lw@rock-chips.com>
 */

#include <serdes-display-core.h>

static void serdes_panel_init(struct serdes *serdes)
{
	if (serdes->vpower_supply)
		regulator_set_enable(serdes->vpower_supply, true);

	if (dm_gpio_is_valid(&serdes->enable_gpio))
		dm_gpio_set_value(&serdes->enable_gpio, 1);

	mdelay(5);

	if (serdes->chip_data->panel_ops->init)
		serdes->chip_data->panel_ops->init(serdes);

	serdes_i2c_set_sequence(serdes);

	SERDES_DBG_MFD("%s: %s %s\n", __func__, serdes->dev->name,
		       serdes->chip_data->name);
}

static void serdes_panel_prepare(struct rockchip_panel *panel)
{
	struct udevice *dev = panel->dev;
	struct serdes *serdes = dev_get_priv(dev);

	if (serdes->chip_data->panel_ops->prepare)
		serdes->chip_data->panel_ops->prepare(serdes);

	SERDES_DBG_MFD("%s: %s %s\n", __func__, serdes->dev->name,
		       serdes->chip_data->name);
}

static void serdes_panel_unprepare(struct rockchip_panel *panel)
{
	struct udevice *dev = panel->dev;
	struct serdes *serdes = dev_get_priv(dev);

	if (serdes->chip_data->panel_ops->unprepare)
		serdes->chip_data->panel_ops->unprepare(serdes);

	SERDES_DBG_MFD("%s: %s %s\n", __func__, serdes->dev->name,
		       serdes->chip_data->name);
}

static void serdes_panel_enable(struct rockchip_panel *panel)
{
	struct udevice *dev = panel->dev;
	struct serdes *serdes = dev_get_priv(dev);

	if (serdes->chip_data->panel_ops->enable)
		serdes->chip_data->panel_ops->enable(serdes);

	serdes_panel_init(serdes);

	if (serdes->serdes_panel->backlight)
		backlight_enable(serdes->serdes_panel->backlight);

	if (serdes->chip_data->panel_ops->backlight_enable)
		serdes->chip_data->panel_ops->backlight_enable(serdes);

	SERDES_DBG_MFD("%s: %s %s\n", __func__, serdes->dev->name,
		       serdes->chip_data->name);
}

static void serdes_panel_disable(struct rockchip_panel *panel)
{
	struct udevice *dev = panel->dev;
	struct serdes *serdes = dev_get_priv(dev);

	if (serdes->chip_data->panel_ops->backlight_disable)
		serdes->chip_data->panel_ops->backlight_disable(serdes);

	if (serdes->serdes_panel->backlight)
		backlight_disable(serdes->serdes_panel->backlight);

	if (serdes->chip_data->panel_ops->disable)
		serdes->chip_data->panel_ops->disable(serdes);

	SERDES_DBG_MFD("%s: %s %s\n", __func__, serdes->dev->name,
		       serdes->chip_data->name);
}

static struct rockchip_panel_funcs serdes_panel_ops = {
	.prepare = serdes_panel_prepare,
	.unprepare = serdes_panel_unprepare,
	.enable = serdes_panel_enable,
	.disable = serdes_panel_disable,
};

static int serdes_panel_probe(struct udevice *dev)
{
	struct serdes *serdes = dev_get_priv(dev);
	struct serdes_panel *serdes_panel = NULL;
	struct rockchip_panel *panel;
	int ret;

	ret = i2c_set_chip_offset_len(dev, 2);
	if (ret)
		return ret;

	serdes->dev = dev;
	serdes->chip_data = (struct serdes_chip_data *)dev_get_driver_data(dev);
	serdes->type = serdes->chip_data->serdes_type;

	SERDES_DBG_MFD("%s: %s %s start\n", __func__, serdes->dev->name,
		       serdes->chip_data->name);

	if (!serdes->chip_data->panel_ops) {
		printf("%s %s no panel ops\n",
		       __func__, serdes->chip_data->name);
		return -1;
	}

	if (serdes->chip_data->serdes_type != TYPE_DES)
		printf("warning: this chip is not des type\n");

	serdes_panel = calloc(1, sizeof(*serdes_panel));
	if (!serdes_panel)
		return -ENOMEM;

	serdes->serdes_panel = serdes_panel;

	ret = uclass_get_device_by_phandle(UCLASS_PANEL_BACKLIGHT, dev,
					   "backlight",
					   &serdes->serdes_panel->backlight);
	if (ret && ret != -ENOENT)
		printf("%s: Cannot get backlight: %d\n", __func__, ret);

	panel = calloc(1, sizeof(*panel));
	if (!panel)
		return -ENOMEM;

	ret = serdes_get_init_seq(serdes);
	if (ret)
		goto free_panel;

	dev->driver_data = (ulong)panel;
	panel->dev = dev;
	panel->bus_format = MEDIA_BUS_FMT_RGB888_1X24;
	panel->funcs = &serdes_panel_ops;

	serdes->serdes_panel->panel = panel;

	ret = serdes_pinctrl_register(dev, serdes);
	if (ret)
		return ret;

	printf("%s %s successful, version %s\n",
	       __func__,
	       serdes->dev->name,
	       SERDES_UBOOT_DISPLAY_VERSION);

	return 0;

free_panel:
	free(panel);

	return ret;
}

static const struct udevice_id serdes_of_match[] = {
#if IS_ENABLED(CONFIG_SERDES_DISPLAY_CHIP_MAXIM_MAX96752)
	{ .compatible = "maxim,max96752", .data = (ulong)&serdes_max96752_data },
#endif
#if IS_ENABLED(CONFIG_SERDES_DISPLAY_CHIP_MAXIM_MAX96772)
	{ .compatible = "maxim,max96772", .data = (ulong)&serdes_max96772_data },
#endif
#if IS_ENABLED(CONFIG_SERDES_DISPLAY_CHIP_ROCKCHIP_RKX121)
	{ .compatible = "rockchip,rkx121", .data = (ulong)&serdes_rkx121_data },
#endif
	{ }
};

U_BOOT_DRIVER(serdes_panel) = {
	.name = "serdes-panel",
	.id = UCLASS_PANEL,
	.of_match = serdes_of_match,
	.probe = serdes_panel_probe,
	.priv_auto_alloc_size = sizeof(struct serdes),
};
