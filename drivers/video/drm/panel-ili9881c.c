// SPDX-License-Identifier: GPL-2.0+
/*
 * (C) Copyright 2023 Hardkernel Co., Ltd
 */
#include <config.h>
#include <common.h>
#include <backlight.h>
#include <errno.h>
#include <malloc.h>
#include <video.h>

#include <asm/gpio.h>
#include <dm/device.h>
#include <dm/read.h>
#include <dm/uclass-id.h>
#include <drm/drm_mipi_dsi.h>
#include <linux/media-bus-format.h>
#include <power/regulator.h>

#include "rockchip_display.h"
#include "rockchip_connector.h"
#include "rockchip_panel.h"

#define msleep(a) udelay(a * 1000)

enum ili9881c_op {
	ILI9881C_SWITCH_PAGE,
	ILI9881C_COMMAND,
};

struct ili9881c_instr {
	enum ili9881c_op        op;

	union arg {
		struct cmd {
			u8      cmd;
			u8      data;
		} cmd;
		u8      page;
	} arg;
};

struct ili9881c;

struct ili9881c_desc {
	const struct ili9881c_instr *init;
	const size_t init_length;
	const struct drm_display_mode *mode;
};

struct ili9881c {
	bool prepared;
	bool enabled;

	struct udevice *power_supply;
	struct gpio_desc reset_gpio;

	struct udevice *backlight;

	const struct ili9881c_desc *desc;
};

static int ili9881c_switch_page(struct mipi_dsi_device *dsi, u8 page)
{
	u8 buf[4] = { 0xff, 0x98, 0x81, page };
	int ret;

	ret = mipi_dsi_dcs_write_buffer(dsi, buf, sizeof(buf));
	if (ret < 0)
		return ret;

	return 0;
}

static int ili9881c_send_cmd_data(struct mipi_dsi_device *dsi, u8 cmd, u8 data)
{
	u8 buf[2] = { cmd, data };
	int ret;

	ret = mipi_dsi_dcs_write_buffer(dsi, buf, sizeof(buf));
	if (ret < 0)
		return ret;

	return 0;
}

static void panel_ili9881c_prepare(struct rockchip_panel *panel)
{
	struct ili9881c *priv = dev_get_priv(panel->dev);
	struct mipi_dsi_device *dsi = dev_get_parent_platdata(panel->dev);
	unsigned int i;
	int ret;

	/* Power the panel */
	if (priv->power_supply) {
		regulator_set_enable(priv->power_supply, true);
		msleep(5);
	}

	/* Reset */
	if (dm_gpio_is_valid(&priv->reset_gpio)) {
		dm_gpio_set_value(&priv->reset_gpio, 1);
		msleep(20);
		dm_gpio_set_value(&priv->reset_gpio, 0);
		msleep(20);
	}

	for (i = 0; i < priv->desc->init_length; i++) {
		const struct ili9881c_instr *instr = &priv->desc->init[i];

		if (instr->op == ILI9881C_SWITCH_PAGE)
			ret = ili9881c_switch_page(dsi, instr->arg.page);
		else if (instr->op == ILI9881C_COMMAND)
			ret = ili9881c_send_cmd_data(dsi, instr->arg.cmd.cmd,
					instr->arg.cmd.data);

		if (ret)
			return;
	}

	ret = ili9881c_switch_page(dsi, 0);
	if (ret)
		return;

	ret = mipi_dsi_dcs_set_tear_on(dsi, MIPI_DSI_DCS_TEAR_MODE_VBLANK);
	if (ret)
		return;

	ret = mipi_dsi_dcs_exit_sleep_mode(dsi);
	if (ret)
		return;

	priv->prepared = true;
}

static void panel_ili9881c_unprepare(struct rockchip_panel *panel)
{
	struct ili9881c *priv = dev_get_priv(panel->dev);

	if (dm_gpio_is_valid(&priv->reset_gpio))
		dm_gpio_set_value(&priv->reset_gpio, 1);

	if (priv->power_supply)
		regulator_set_enable(priv->power_supply, false);

	priv->prepared = false;
}

static void panel_ili9881c_enable(struct rockchip_panel *panel)
{
	struct ili9881c *priv = dev_get_priv(panel->dev);
	struct mipi_dsi_device *dsi = dev_get_parent_platdata(panel->dev);

	if (priv->enabled)
		return;

	msleep(120);
	mipi_dsi_dcs_set_display_on(dsi);

	if (priv->backlight)
		backlight_enable(priv->backlight);

	priv->enabled = true;
}

static void panel_ili9881c_disable(struct rockchip_panel *panel)
{
	struct ili9881c *priv = dev_get_priv(panel->dev);
	struct mipi_dsi_device *dsi = dev_get_parent_platdata(panel->dev);

	if (!priv->enabled)
		return;

	if (priv->backlight)
		backlight_disable(priv->backlight);

	mipi_dsi_dcs_set_display_off(dsi);

	priv->enabled = false;
}

static const struct rockchip_panel_funcs panel_ili9881c_funcs = {
	.prepare = panel_ili9881c_prepare,
	.unprepare = panel_ili9881c_unprepare,
	.enable = panel_ili9881c_enable,
	.disable = panel_ili9881c_disable,
};

static int ili9881c_probe(struct udevice *dev)
{
	struct ili9881c *priv = dev_get_priv(dev);
	struct rockchip_panel *panel;
	int ret;

	ret = gpio_request_by_name(dev, "reset-gpios", 0,
				   &priv->reset_gpio, GPIOD_IS_OUT);
	if (ret && ret != -ENOENT) {
		printf("%s: Cannot get reset GPIO: %d\n", __func__, ret);
		return ret;
	}

	ret = uclass_get_device_by_phandle(UCLASS_PANEL_BACKLIGHT, dev,
					   "backlight", &priv->backlight);
	if (ret && ret != -ENOENT) {
		printf("%s: Cannot get backlight: %d\n", __func__, ret);
		return ret;
	}

	ret = uclass_get_device_by_phandle(UCLASS_REGULATOR, dev,
					   "power-supply", &priv->power_supply);
	if (ret && ret != -ENOENT) {
		printf("%s: Cannot get power supply: %d\n", __func__, ret);
		return ret;
	}

	priv->desc = (const struct ili9881c_desc *)dev_get_driver_data(dev);

	ret = uclass_get_device_by_phandle(UCLASS_PANEL_BACKLIGHT, dev,
					   "backlight", &priv->backlight);
	if (ret && ret != -ENOENT) {
		dev_err(dev, "%s: Cannot get backlight: %d\n", __func__, ret);
		return ret;
	}

	panel = calloc(1, sizeof(*panel));
	if (!panel)
		return -ENOMEM;

	dev->driver_data = (ulong)panel;
	panel->dev = dev;
	panel->bus_format = MEDIA_BUS_FMT_RGB888_1X24;
	panel->bpc = 8;
	panel->funcs = &panel_ili9881c_funcs;
	panel->data = priv->desc->mode;

	return 0;
}

#define ILI9881C_SWITCH_PAGE_INSTR(_page)	\
	{					\
		.op = ILI9881C_SWITCH_PAGE,	\
		.arg = {			\
			.page = (_page),	\
		},				\
	}

#define ILI9881C_COMMAND_INSTR(_cmd, _data)		\
	{						\
		.op = ILI9881C_COMMAND,		\
		.arg = {				\
			.cmd = {			\
				.cmd = (_cmd),		\
				.data = (_data),	\
			},				\
		},					\
	}

static const struct ili9881c_instr odroid_vu8m_init[] = {
	ILI9881C_SWITCH_PAGE_INSTR(3),
	ILI9881C_COMMAND_INSTR(0x01, 0x00),
	ILI9881C_COMMAND_INSTR(0x02, 0x00),
	ILI9881C_COMMAND_INSTR(0x03, 0x53),
	ILI9881C_COMMAND_INSTR(0x04, 0x53),
	ILI9881C_COMMAND_INSTR(0x05, 0x13),
	ILI9881C_COMMAND_INSTR(0x06, 0x04),
	ILI9881C_COMMAND_INSTR(0x07, 0x02),
	ILI9881C_COMMAND_INSTR(0x08, 0x02),
	ILI9881C_COMMAND_INSTR(0x09, 0x00),
	ILI9881C_COMMAND_INSTR(0x0a, 0x00),
	ILI9881C_COMMAND_INSTR(0x0b, 0x00),
	ILI9881C_COMMAND_INSTR(0x0c, 0x00),
	ILI9881C_COMMAND_INSTR(0x0d, 0x00),
	ILI9881C_COMMAND_INSTR(0x0e, 0x00),
	ILI9881C_COMMAND_INSTR(0x0f, 0x00),
	ILI9881C_COMMAND_INSTR(0x10, 0x00),
	ILI9881C_COMMAND_INSTR(0x11, 0x00),
	ILI9881C_COMMAND_INSTR(0x12, 0x00),
	ILI9881C_COMMAND_INSTR(0x13, 0x00),
	ILI9881C_COMMAND_INSTR(0x14, 0x00),
	ILI9881C_COMMAND_INSTR(0x15, 0x00),
	ILI9881C_COMMAND_INSTR(0x16, 0x00),
	ILI9881C_COMMAND_INSTR(0x17, 0x00),
	ILI9881C_COMMAND_INSTR(0x18, 0x00),
	ILI9881C_COMMAND_INSTR(0x19, 0x00),
	ILI9881C_COMMAND_INSTR(0x1a, 0x00),
	ILI9881C_COMMAND_INSTR(0x1b, 0x00),
	ILI9881C_COMMAND_INSTR(0x1c, 0x00),
	ILI9881C_COMMAND_INSTR(0x1d, 0x00),

	ILI9881C_COMMAND_INSTR(0x1e, 0xc0),
	ILI9881C_COMMAND_INSTR(0x1f, 0x80),
	ILI9881C_COMMAND_INSTR(0x20, 0x02),
	ILI9881C_COMMAND_INSTR(0x21, 0x09),
	ILI9881C_COMMAND_INSTR(0x22, 0x00),
	ILI9881C_COMMAND_INSTR(0x23, 0x00),
	ILI9881C_COMMAND_INSTR(0x24, 0x00),
	ILI9881C_COMMAND_INSTR(0x25, 0x00),
	ILI9881C_COMMAND_INSTR(0x26, 0x00),
	ILI9881C_COMMAND_INSTR(0x27, 0x00),
	ILI9881C_COMMAND_INSTR(0x28, 0x55),
	ILI9881C_COMMAND_INSTR(0x29, 0x03),
	ILI9881C_COMMAND_INSTR(0x2a, 0x00),
	ILI9881C_COMMAND_INSTR(0x2b, 0x00),
	ILI9881C_COMMAND_INSTR(0x2c, 0x00),
	ILI9881C_COMMAND_INSTR(0x2d, 0x00),
	ILI9881C_COMMAND_INSTR(0x2e, 0x00),
	ILI9881C_COMMAND_INSTR(0x2f, 0x00),
	ILI9881C_COMMAND_INSTR(0x30, 0x00),
	ILI9881C_COMMAND_INSTR(0x31, 0x00),
	ILI9881C_COMMAND_INSTR(0x32, 0x00),
	ILI9881C_COMMAND_INSTR(0x33, 0x00),
	ILI9881C_COMMAND_INSTR(0x34, 0x00),
	ILI9881C_COMMAND_INSTR(0x35, 0x00),
	ILI9881C_COMMAND_INSTR(0x36, 0x00),
	ILI9881C_COMMAND_INSTR(0x37, 0x00),

	ILI9881C_COMMAND_INSTR(0x38, 0x3C), /* VDD1&2 toggle 1sec */
	ILI9881C_COMMAND_INSTR(0x39, 0x00),
	ILI9881C_COMMAND_INSTR(0x3a, 0x00),
	ILI9881C_COMMAND_INSTR(0x3b, 0x00),
	ILI9881C_COMMAND_INSTR(0x3c, 0x00),
	ILI9881C_COMMAND_INSTR(0x3d, 0x00),
	ILI9881C_COMMAND_INSTR(0x3e, 0x00),
	ILI9881C_COMMAND_INSTR(0x3f, 0x00),
	ILI9881C_COMMAND_INSTR(0x40, 0x00),
	ILI9881C_COMMAND_INSTR(0x41, 0x00),
	ILI9881C_COMMAND_INSTR(0x42, 0x00),
	ILI9881C_COMMAND_INSTR(0x43, 0x00),
	ILI9881C_COMMAND_INSTR(0x44, 0x00),
// GIP 2
	ILI9881C_COMMAND_INSTR(0x50, 0x01),
	ILI9881C_COMMAND_INSTR(0x51, 0x23),
	ILI9881C_COMMAND_INSTR(0x52, 0x45),
	ILI9881C_COMMAND_INSTR(0x53, 0x67),
	ILI9881C_COMMAND_INSTR(0x54, 0x89),
	ILI9881C_COMMAND_INSTR(0x55, 0xab),
	ILI9881C_COMMAND_INSTR(0x56, 0x01),
	ILI9881C_COMMAND_INSTR(0x57, 0x23),
	ILI9881C_COMMAND_INSTR(0x58, 0x45),
	ILI9881C_COMMAND_INSTR(0x59, 0x67),
	ILI9881C_COMMAND_INSTR(0x5a, 0x89),
	ILI9881C_COMMAND_INSTR(0x5b, 0xab),
	ILI9881C_COMMAND_INSTR(0x5c, 0xcd),
	ILI9881C_COMMAND_INSTR(0x5d, 0xef),
// GIP 3
	ILI9881C_COMMAND_INSTR(0x5e, 0x01),
	ILI9881C_COMMAND_INSTR(0x5f, 0x08), /* FW_GOUT_L1   STV2_ODD */
	ILI9881C_COMMAND_INSTR(0x60, 0x02), /* FW_GOUT_L2 */
	ILI9881C_COMMAND_INSTR(0x61, 0x02), /* FW_GOUT_L3 */
	ILI9881C_COMMAND_INSTR(0x62, 0x0A), /* FW_GOUT_L4   RESET_ODD */
	ILI9881C_COMMAND_INSTR(0x63, 0x15), /* FW_GOUT_L5 */
	ILI9881C_COMMAND_INSTR(0x64, 0x14), /* FW_GOUT_L6 */
	ILI9881C_COMMAND_INSTR(0x65, 0x02), /* FW_GOUT_L7 */
	ILI9881C_COMMAND_INSTR(0x66, 0x11), /* FW_GOUT_L8    CK11 */
	ILI9881C_COMMAND_INSTR(0x67, 0x10), /* FW_GOUT_L9    CK9 */
	ILI9881C_COMMAND_INSTR(0x68, 0x02), /* FW_GOUT_L10 */
	ILI9881C_COMMAND_INSTR(0x69, 0x0F), /* FW_GOUT_L11   CK7 */
	ILI9881C_COMMAND_INSTR(0x6a, 0x0E), /* FW_GOUT_L12   CK5 */
	ILI9881C_COMMAND_INSTR(0x6b, 0x02), /* FW_GOUT_L13 */
	ILI9881C_COMMAND_INSTR(0x6c, 0x0D), /* FW_GOUT_L14   CK3 */
	ILI9881C_COMMAND_INSTR(0x6d, 0x0C), /* FW_GOUT_L15   CK1 */
	ILI9881C_COMMAND_INSTR(0x6e, 0x06), /* FW_GOUT_L16   STV1_ODD */
	ILI9881C_COMMAND_INSTR(0x6f, 0x02), /* FW_GOUT_L17 */
	ILI9881C_COMMAND_INSTR(0x70, 0x02), /* FW_GOUT_L18 */
	ILI9881C_COMMAND_INSTR(0x71, 0x02), /* FW_GOUT_L19 */
	ILI9881C_COMMAND_INSTR(0x72, 0x02), /* FW_GOUT_L20 */
	ILI9881C_COMMAND_INSTR(0x73, 0x02), /* FW_GOUT_L21 */
	ILI9881C_COMMAND_INSTR(0x74, 0x02), /* FW_GOUT_L22 */

	ILI9881C_COMMAND_INSTR(0x75, 0x06), /* BW_GOUT_L1   STV2_ODD */
	ILI9881C_COMMAND_INSTR(0x76, 0x02), /* BW_GOUT_L2 */
	ILI9881C_COMMAND_INSTR(0x77, 0x02), /* BW_GOUT_L3 */
	ILI9881C_COMMAND_INSTR(0x78, 0x0A), /* BW_GOUT_L4   RESET_ODD */
	ILI9881C_COMMAND_INSTR(0x79, 0x15), /* BW_GOUT_L5 */
	ILI9881C_COMMAND_INSTR(0x7a, 0x14), /* BW_GOUT_L6 */
	ILI9881C_COMMAND_INSTR(0x7b, 0x02), /* BW_GOUT_L7 */
	ILI9881C_COMMAND_INSTR(0x7c, 0x10), /* BW_GOUT_L8  CK11 */
	ILI9881C_COMMAND_INSTR(0x7d, 0x11), /* BW_GOUT_L9  CK9 */
	ILI9881C_COMMAND_INSTR(0x7e, 0x02), /* BW_GOUT_L10 */
	ILI9881C_COMMAND_INSTR(0x7f, 0x0C), /* BW_GOUT_L11 CK7 */
	ILI9881C_COMMAND_INSTR(0x80, 0x0D), /* BW_GOUT_L12 CK5 */
	ILI9881C_COMMAND_INSTR(0x81, 0x02), /* BW_GOUT_L13 */
	ILI9881C_COMMAND_INSTR(0x82, 0x0E), /* BW_GOUT_L14 CK3 */
	ILI9881C_COMMAND_INSTR(0x83, 0x0F), /* BW_GOUT_L15 CK1 */
	ILI9881C_COMMAND_INSTR(0x84, 0x08), /* BW_GOUT_L16 STV1_ODD */
	ILI9881C_COMMAND_INSTR(0x85, 0x02), /* BW_GOUT_L17 */
	ILI9881C_COMMAND_INSTR(0x86, 0x02), /* BW_GOUT_L18 */
	ILI9881C_COMMAND_INSTR(0x87, 0x02), /* BW_GOUT_L19 */
	ILI9881C_COMMAND_INSTR(0x88, 0x02), /* BW_GOUT_L20 */
	ILI9881C_COMMAND_INSTR(0x89, 0x02), /* BW_GOUT_L21 */
	ILI9881C_COMMAND_INSTR(0x8A, 0x02), /* BW_GOUT_L22 */
	ILI9881C_SWITCH_PAGE_INSTR(4),
	ILI9881C_COMMAND_INSTR(0x6C, 0x15),
	ILI9881C_COMMAND_INSTR(0x6E, 0x30), /* VGH clamp 16.08V */
	ILI9881C_COMMAND_INSTR(0x6F, 0x33), /* reg vcl + pumping ratio VGH=3x VGL=-3x */
	ILI9881C_COMMAND_INSTR(0x8D, 0x1F), /* VGL clamp -12.03V */
	ILI9881C_COMMAND_INSTR(0x87, 0xBA),
	ILI9881C_COMMAND_INSTR(0x26, 0x76),
	ILI9881C_COMMAND_INSTR(0xB2, 0xD1),
	ILI9881C_COMMAND_INSTR(0x35, 0x1F),
	ILI9881C_COMMAND_INSTR(0x33, 0x14),
	ILI9881C_COMMAND_INSTR(0x3A, 0xA9),
	ILI9881C_COMMAND_INSTR(0x3B, 0x3D),
	ILI9881C_COMMAND_INSTR(0x38, 0x01),
	ILI9881C_COMMAND_INSTR(0x39, 0x00),
	ILI9881C_SWITCH_PAGE_INSTR(1),
	ILI9881C_COMMAND_INSTR(0x22, 0x0A),
	ILI9881C_COMMAND_INSTR(0x31, 0x00), /* column inversion */
	ILI9881C_COMMAND_INSTR(0x40, 0x53),
	ILI9881C_COMMAND_INSTR(0x50, 0xC0), /* VREG1OUT=5.508V */
	ILI9881C_COMMAND_INSTR(0x51, 0xC0), /* VREG2OUT=-5.508V */
	ILI9881C_COMMAND_INSTR(0x53, 0x47), /* VCOM1 */
	ILI9881C_COMMAND_INSTR(0x55, 0x46), /* VCOM2 */
	ILI9881C_COMMAND_INSTR(0x60, 0x28), /* SDT */
	ILI9881C_COMMAND_INSTR(0x2E, 0xC8), /* 1280 GATE NL SEL */

	ILI9881C_COMMAND_INSTR(0xA0, 0x01), /* VP255 */
	ILI9881C_COMMAND_INSTR(0xA1, 0x10), /* VP251 */
	ILI9881C_COMMAND_INSTR(0xA2, 0x1B), /* VP247 */
	ILI9881C_COMMAND_INSTR(0xA3, 0x0C), /* VP243 */
	ILI9881C_COMMAND_INSTR(0xA4, 0x14), /* VP239 */
	ILI9881C_COMMAND_INSTR(0xA5, 0x25), /* VP231 */
	ILI9881C_COMMAND_INSTR(0xA6, 0x1A), /* VP219 */
	ILI9881C_COMMAND_INSTR(0xA7, 0x1D), /* VP203 */
	ILI9881C_COMMAND_INSTR(0xA8, 0x68), /* VP175 */
	ILI9881C_COMMAND_INSTR(0xA9, 0x1B), /* VP144 */
	ILI9881C_COMMAND_INSTR(0xAA, 0x26), /* VP111 */
	ILI9881C_COMMAND_INSTR(0xAB, 0x5B), /* VP80 */
	ILI9881C_COMMAND_INSTR(0xAC, 0x1B), /* VP52 */
	ILI9881C_COMMAND_INSTR(0xAD, 0x17), /* VP36 */
	ILI9881C_COMMAND_INSTR(0xAE, 0x4F), /* VP24 */
	ILI9881C_COMMAND_INSTR(0xAF, 0x24), /* VP16 */
	ILI9881C_COMMAND_INSTR(0xB0, 0x2A), /* VP12 */
	ILI9881C_COMMAND_INSTR(0xB1, 0x4E), /* VP8 */
	ILI9881C_COMMAND_INSTR(0xB2, 0x5F), /* VP4 */
	ILI9881C_COMMAND_INSTR(0xB3, 0x39), /* VP0 */

	ILI9881C_COMMAND_INSTR(0xC0, 0x0F), /* VN255 GAMMA N */
	ILI9881C_COMMAND_INSTR(0xC1, 0x1B), /* VN251 */
	ILI9881C_COMMAND_INSTR(0xC2, 0x27), /* VN247 */
	ILI9881C_COMMAND_INSTR(0xC3, 0x16), /* VN243 */
	ILI9881C_COMMAND_INSTR(0xC4, 0x14), /* VN239 */
	ILI9881C_COMMAND_INSTR(0xC5, 0x28), /* VN231 */
	ILI9881C_COMMAND_INSTR(0xC6, 0x1D), /* VN219 */
	ILI9881C_COMMAND_INSTR(0xC7, 0x21), /* VN203 */
	ILI9881C_COMMAND_INSTR(0xC8, 0x6C), /* VN175 */
	ILI9881C_COMMAND_INSTR(0xC9, 0x1B), /* VN144 */
	ILI9881C_COMMAND_INSTR(0xCA, 0x26), /* VN111 */
	ILI9881C_COMMAND_INSTR(0xCB, 0x5B), /* VN80 */
	ILI9881C_COMMAND_INSTR(0xCC, 0x1B), /* VN52 */
	ILI9881C_COMMAND_INSTR(0xCD, 0x1B), /* VN36 */
	ILI9881C_COMMAND_INSTR(0xCE, 0x4F), /* VN24 */
	ILI9881C_COMMAND_INSTR(0xCF, 0x24), /* VN16 */
	ILI9881C_COMMAND_INSTR(0xD0, 0x2A), /* VN12 */
	ILI9881C_COMMAND_INSTR(0xD1, 0x4E), /* VN8 */
	ILI9881C_COMMAND_INSTR(0xD2, 0x5F), /* VN4 */
	ILI9881C_COMMAND_INSTR(0xD3, 0x39), /* VN0 */
	ILI9881C_SWITCH_PAGE_INSTR(2),
	ILI9881C_COMMAND_INSTR(0x04, 0x17),
	ILI9881C_COMMAND_INSTR(0x05, 0x12),
	ILI9881C_COMMAND_INSTR(0x06, 0x40),
	ILI9881C_COMMAND_INSTR(0x07, 0x0B),

	ILI9881C_SWITCH_PAGE_INSTR(0),
	ILI9881C_COMMAND_INSTR(0x35, 0x00),
};

static const struct ili9881c_instr odroid_vu8s_init[] = {
	ILI9881C_SWITCH_PAGE_INSTR(3),
	ILI9881C_COMMAND_INSTR(0x01, 0x00),
	ILI9881C_COMMAND_INSTR(0x02, 0x00),
	ILI9881C_COMMAND_INSTR(0x03, 0x54),
	ILI9881C_COMMAND_INSTR(0x04, 0xD4),
	ILI9881C_COMMAND_INSTR(0x05, 0x00),
	ILI9881C_COMMAND_INSTR(0x06, 0x11),
	ILI9881C_COMMAND_INSTR(0x07, 0x09),
	ILI9881C_COMMAND_INSTR(0x08, 0x00),
	ILI9881C_COMMAND_INSTR(0x09, 0x00),
	ILI9881C_COMMAND_INSTR(0x0a, 0x00),
	ILI9881C_COMMAND_INSTR(0x0b, 0x00),
	ILI9881C_COMMAND_INSTR(0x0c, 0x00),
	ILI9881C_COMMAND_INSTR(0x0d, 0x00),
	ILI9881C_COMMAND_INSTR(0x0e, 0x00),
	ILI9881C_COMMAND_INSTR(0x0f, 0x26),
	ILI9881C_COMMAND_INSTR(0x10, 0x26),
	ILI9881C_COMMAND_INSTR(0x11, 0x00),
	ILI9881C_COMMAND_INSTR(0x12, 0x00),
	ILI9881C_COMMAND_INSTR(0x13, 0x00),
	ILI9881C_COMMAND_INSTR(0x14, 0x00),
	ILI9881C_COMMAND_INSTR(0x15, 0x00),
	ILI9881C_COMMAND_INSTR(0x16, 0x00),
	ILI9881C_COMMAND_INSTR(0x17, 0x00),
	ILI9881C_COMMAND_INSTR(0x18, 0x00),
	ILI9881C_COMMAND_INSTR(0x19, 0x00),
	ILI9881C_COMMAND_INSTR(0x1a, 0x00),
	ILI9881C_COMMAND_INSTR(0x1b, 0x00),
	ILI9881C_COMMAND_INSTR(0x1c, 0x00),
	ILI9881C_COMMAND_INSTR(0x1d, 0x00),
	ILI9881C_COMMAND_INSTR(0x1e, 0x40),
	ILI9881C_COMMAND_INSTR(0x1f, 0x80),
	ILI9881C_COMMAND_INSTR(0x20, 0x06),
	ILI9881C_COMMAND_INSTR(0x21, 0x01),
	ILI9881C_COMMAND_INSTR(0x22, 0x00),
	ILI9881C_COMMAND_INSTR(0x23, 0x00),
	ILI9881C_COMMAND_INSTR(0x24, 0x00),
	ILI9881C_COMMAND_INSTR(0x25, 0x00),
	ILI9881C_COMMAND_INSTR(0x26, 0x00),
	ILI9881C_COMMAND_INSTR(0x27, 0x00),
	ILI9881C_COMMAND_INSTR(0x28, 0x33),
	ILI9881C_COMMAND_INSTR(0x29, 0x33),
	ILI9881C_COMMAND_INSTR(0x2a, 0x00),
	ILI9881C_COMMAND_INSTR(0x2b, 0x00),
	ILI9881C_COMMAND_INSTR(0x2c, 0x00),
	ILI9881C_COMMAND_INSTR(0x2d, 0x00),
	ILI9881C_COMMAND_INSTR(0x2e, 0x00),
	ILI9881C_COMMAND_INSTR(0x2f, 0x00),
	ILI9881C_COMMAND_INSTR(0x30, 0x00),
	ILI9881C_COMMAND_INSTR(0x31, 0x00),
	ILI9881C_COMMAND_INSTR(0x32, 0x00),
	ILI9881C_COMMAND_INSTR(0x33, 0x00),
	ILI9881C_COMMAND_INSTR(0x34, 0x03),
	ILI9881C_COMMAND_INSTR(0x35, 0x00),
	ILI9881C_COMMAND_INSTR(0x36, 0x00),
	ILI9881C_COMMAND_INSTR(0x37, 0x00),
	ILI9881C_COMMAND_INSTR(0x38, 0x96),
	ILI9881C_COMMAND_INSTR(0x39, 0x00),
	ILI9881C_COMMAND_INSTR(0x3a, 0x00),
	ILI9881C_COMMAND_INSTR(0x3b, 0x00),
	ILI9881C_COMMAND_INSTR(0x3c, 0x00),
	ILI9881C_COMMAND_INSTR(0x3d, 0x00),
	ILI9881C_COMMAND_INSTR(0x3e, 0x00),
	ILI9881C_COMMAND_INSTR(0x3f, 0x00),
	ILI9881C_COMMAND_INSTR(0x40, 0x00),
	ILI9881C_COMMAND_INSTR(0x41, 0x00),
	ILI9881C_COMMAND_INSTR(0x42, 0x00),
	ILI9881C_COMMAND_INSTR(0x43, 0x00),
	ILI9881C_COMMAND_INSTR(0x44, 0x00),
	//GIP 2
	ILI9881C_COMMAND_INSTR(0x50, 0x00),
	ILI9881C_COMMAND_INSTR(0x51, 0x23),
	ILI9881C_COMMAND_INSTR(0x52, 0x45),
	ILI9881C_COMMAND_INSTR(0x53, 0x67),
	ILI9881C_COMMAND_INSTR(0x54, 0x89),
	ILI9881C_COMMAND_INSTR(0x55, 0xab),
	ILI9881C_COMMAND_INSTR(0x56, 0x01),
	ILI9881C_COMMAND_INSTR(0x57, 0x23),
	ILI9881C_COMMAND_INSTR(0x58, 0x45),
	ILI9881C_COMMAND_INSTR(0x59, 0x67),
	ILI9881C_COMMAND_INSTR(0x5a, 0x89),
	ILI9881C_COMMAND_INSTR(0x5b, 0xab),
	ILI9881C_COMMAND_INSTR(0x5c, 0xcd),
	ILI9881C_COMMAND_INSTR(0x5d, 0xef),
	//GIP 3
	ILI9881C_COMMAND_INSTR(0x5e, 0x00),
	ILI9881C_COMMAND_INSTR(0x5f, 0x0D),
	ILI9881C_COMMAND_INSTR(0x60, 0x0D),
	ILI9881C_COMMAND_INSTR(0x61, 0x0C),
	ILI9881C_COMMAND_INSTR(0x62, 0x0C),
	ILI9881C_COMMAND_INSTR(0x63, 0x0F),
	ILI9881C_COMMAND_INSTR(0x64, 0x0F),
	ILI9881C_COMMAND_INSTR(0x65, 0x0E),
	ILI9881C_COMMAND_INSTR(0x66, 0x0E),
	ILI9881C_COMMAND_INSTR(0x67, 0x08),
	ILI9881C_COMMAND_INSTR(0x68, 0x02),
	ILI9881C_COMMAND_INSTR(0x69, 0x02),
	ILI9881C_COMMAND_INSTR(0x6a, 0x02),
	ILI9881C_COMMAND_INSTR(0x6b, 0x02),
	ILI9881C_COMMAND_INSTR(0x6c, 0x02),
	ILI9881C_COMMAND_INSTR(0x6d, 0x02),
	ILI9881C_COMMAND_INSTR(0x6e, 0x02),
	ILI9881C_COMMAND_INSTR(0x6f, 0x02),
	ILI9881C_COMMAND_INSTR(0x70, 0x14),
	ILI9881C_COMMAND_INSTR(0x71, 0x15),
	ILI9881C_COMMAND_INSTR(0x72, 0x06),
	ILI9881C_COMMAND_INSTR(0x73, 0x02),
	ILI9881C_COMMAND_INSTR(0x74, 0x02),

	ILI9881C_COMMAND_INSTR(0x75, 0x0D),
	ILI9881C_COMMAND_INSTR(0x76, 0x0D),
	ILI9881C_COMMAND_INSTR(0x77, 0x0C),
	ILI9881C_COMMAND_INSTR(0x78, 0x0C),
	ILI9881C_COMMAND_INSTR(0x79, 0x0F),
	ILI9881C_COMMAND_INSTR(0x7a, 0x0F),
	ILI9881C_COMMAND_INSTR(0x7b, 0x0E),
	ILI9881C_COMMAND_INSTR(0x7c, 0x0E),
	ILI9881C_COMMAND_INSTR(0x7d, 0x08),
	ILI9881C_COMMAND_INSTR(0x7e, 0x02),
	ILI9881C_COMMAND_INSTR(0x7f, 0x02),
	ILI9881C_COMMAND_INSTR(0x80, 0x02),
	ILI9881C_COMMAND_INSTR(0x81, 0x02),
	ILI9881C_COMMAND_INSTR(0x82, 0x02),
	ILI9881C_COMMAND_INSTR(0x83, 0x02),
	ILI9881C_COMMAND_INSTR(0x84, 0x02),
	ILI9881C_COMMAND_INSTR(0x85, 0x02),
	ILI9881C_COMMAND_INSTR(0x86, 0x14),
	ILI9881C_COMMAND_INSTR(0x87, 0x15),
	ILI9881C_COMMAND_INSTR(0x88, 0x06),
	ILI9881C_COMMAND_INSTR(0x89, 0x02),
	ILI9881C_COMMAND_INSTR(0x8A, 0x02),
	ILI9881C_SWITCH_PAGE_INSTR(4),
	ILI9881C_COMMAND_INSTR(0x6E, 0x3B),
	ILI9881C_COMMAND_INSTR(0x6F, 0x57),
	ILI9881C_COMMAND_INSTR(0x3A, 0x24),
	ILI9881C_COMMAND_INSTR(0x8D, 0x1F),
	ILI9881C_COMMAND_INSTR(0x87, 0xBA),
	ILI9881C_COMMAND_INSTR(0xB2, 0xD1),
	ILI9881C_COMMAND_INSTR(0x88, 0x0B),
	ILI9881C_COMMAND_INSTR(0x38, 0x01),
	ILI9881C_COMMAND_INSTR(0x39, 0x00),
	ILI9881C_COMMAND_INSTR(0xB5, 0x07),
	ILI9881C_COMMAND_INSTR(0x31, 0x75),
	ILI9881C_COMMAND_INSTR(0x3B, 0x98),
	ILI9881C_SWITCH_PAGE_INSTR(1),
	ILI9881C_COMMAND_INSTR(0x22, 0x0A),
	ILI9881C_COMMAND_INSTR(0x31, 0x09),
	ILI9881C_COMMAND_INSTR(0x35, 0x07),
	ILI9881C_COMMAND_INSTR(0x53, 0x7B),
	ILI9881C_COMMAND_INSTR(0x55, 0x40),
	ILI9881C_COMMAND_INSTR(0x50, 0x86),
	ILI9881C_COMMAND_INSTR(0x51, 0x82),
	ILI9881C_COMMAND_INSTR(0x60, 0x27),
	ILI9881C_COMMAND_INSTR(0x62, 0x20),
	// Gamma Start
	ILI9881C_COMMAND_INSTR(0xA0, 0x00),
	ILI9881C_COMMAND_INSTR(0xA1, 0x12),
	ILI9881C_COMMAND_INSTR(0xA2, 0x20),
	ILI9881C_COMMAND_INSTR(0xA3, 0x13),
	ILI9881C_COMMAND_INSTR(0xA4, 0x14),
	ILI9881C_COMMAND_INSTR(0xA5, 0x27),
	ILI9881C_COMMAND_INSTR(0xA6, 0x1D),
	ILI9881C_COMMAND_INSTR(0xA7, 0x1F),
	ILI9881C_COMMAND_INSTR(0xA8, 0x7C),
	ILI9881C_COMMAND_INSTR(0xA9, 0x1D),
	ILI9881C_COMMAND_INSTR(0xAA, 0x2A),
	ILI9881C_COMMAND_INSTR(0xAB, 0x6B),
	ILI9881C_COMMAND_INSTR(0xAC, 0x1A),
	ILI9881C_COMMAND_INSTR(0xAD, 0x18),
	ILI9881C_COMMAND_INSTR(0xAE, 0x4E),
	ILI9881C_COMMAND_INSTR(0xAF, 0x24),
	ILI9881C_COMMAND_INSTR(0xB0, 0x2A),
	ILI9881C_COMMAND_INSTR(0xB1, 0x4D),
	ILI9881C_COMMAND_INSTR(0xB2, 0x5B),
	ILI9881C_COMMAND_INSTR(0xB3, 0x23),
	// Neg Register
	ILI9881C_COMMAND_INSTR(0xC0, 0x00),
	ILI9881C_COMMAND_INSTR(0xC1, 0x13),
	ILI9881C_COMMAND_INSTR(0xC2, 0x20),
	ILI9881C_COMMAND_INSTR(0xC3, 0x12),
	ILI9881C_COMMAND_INSTR(0xC4, 0x15),
	ILI9881C_COMMAND_INSTR(0xC5, 0x28),
	ILI9881C_COMMAND_INSTR(0xC6, 0x1C),
	ILI9881C_COMMAND_INSTR(0xC7, 0x1E),
	ILI9881C_COMMAND_INSTR(0xC8, 0x7B),
	ILI9881C_COMMAND_INSTR(0xC9, 0x1E),
	ILI9881C_COMMAND_INSTR(0xCA, 0x29),
	ILI9881C_COMMAND_INSTR(0xCB, 0x6C),
	ILI9881C_COMMAND_INSTR(0xCC, 0x1A),
	ILI9881C_COMMAND_INSTR(0xCD, 0x19),
	ILI9881C_COMMAND_INSTR(0xCE, 0x4D),
	ILI9881C_COMMAND_INSTR(0xCF, 0x22),
	ILI9881C_COMMAND_INSTR(0xD0, 0x2A),
	ILI9881C_COMMAND_INSTR(0xD1, 0x4D),
	ILI9881C_COMMAND_INSTR(0xD2, 0x5B),
	ILI9881C_COMMAND_INSTR(0xD3, 0x23),
	ILI9881C_SWITCH_PAGE_INSTR(0),
	ILI9881C_COMMAND_INSTR(0x35, 0x00),
};

static const struct drm_display_mode odroid_vu8m_default_mode = {
	.clock          = 66000,
	.hdisplay       = 800,
	.hsync_start    = 800 + 32,
	.hsync_end      = 800 + 32 + 24,
	.htotal         = 800 + 32 + 24 + 24,
	.vdisplay       = 1280,
	.vsync_start    = 1280 + 8,
	.vsync_end      = 1280 + 8 + 4,
	.vtotal         = 1280 + 8 + 4 + 8,
	.flags		= DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC
		| DRM_BUS_FLAG_DE_LOW | DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE,
};

static const struct drm_display_mode odroid_vu8s_default_mode = {
	.clock          = 66000,
	.hdisplay       = 800,
	.hsync_start    = 800 + 32,
	.hsync_end      = 800 + 32 + 24,
	.htotal         = 800 + 32 + 24 + 24,
	.vdisplay       = 1280,
	.vsync_start    = 1280 + 8,
	.vsync_end      = 1280 + 8 + 4,
	.vtotal         = 1280 + 8 + 4 + 8,
	.flags		= DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC
		| DRM_BUS_FLAG_DE_LOW | DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE,
};

static const struct ili9881c_desc odroid_vu8m_desc = {
	.init		= odroid_vu8m_init,
	.init_length	= ARRAY_SIZE(odroid_vu8m_init),
	.mode		= &odroid_vu8m_default_mode,
};

static const struct ili9881c_desc odroid_vu8s_desc = {
	.init		= odroid_vu8s_init,
	.init_length	= ARRAY_SIZE(odroid_vu8s_init),
	.mode		= &odroid_vu8s_default_mode,
};

static const struct udevice_id ili9881c_of_match[] = {
	{ .compatible = "odroid,vu8s", .data = (ulong)&odroid_vu8s_desc },
	{ .compatible = "odroid,vu8m", .data = (ulong)&odroid_vu8m_desc },
	{}
};

U_BOOT_DRIVER(ili9881c) = {
	.name = "ili9881c",
	.id = UCLASS_PANEL,
	.of_match = ili9881c_of_match,
	.probe = ili9881c_probe,
	.priv_auto_alloc_size = sizeof(struct ili9881c),
	.platdata_auto_alloc_size = sizeof(struct ili9881c_desc),
};
