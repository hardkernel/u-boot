/*
 * (C) Copyright 2008-2015 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#include <common.h>
#include <asm/gpio.h>
#include <dm.h>
#include <dm/device.h>
#include <errno.h>
#include <fdtdec.h>
#include <i2c.h>
#include <linux/usb/phy-rockchip-inno-usb2.h>
#include <malloc.h>
#include <power/battery.h>
#include <power/fuel_gauge.h>
#include <power/pmic.h>
#include "fg_regs.h"

DECLARE_GLOBAL_DATA_PTR;

#define COMPAT_ROCKCHIP_CW201X "cw201x"

#define REG_VERSION		0x0
#define REG_VCELL		0x2
#define REG_SOC			0x4
#define REG_RRT_ALERT		0x6
#define REG_CONFIG		0x8
#define REG_MODE		0xA
#define REG_BATINFO		0x10

#define MODE_SLEEP_MASK		(0x3 << 6)
#define MODE_SLEEP		(0x3 << 6)
#define MODE_NORMAL		(0x0 << 6)
#define MODE_QUICK_START	(0x3 << 4)
#define MODE_RESTART		(0xf << 0)

#define CONFIG_UPDATE_FLG	(0x1 << 1)
#define ATHD			(0x0 << 3)

enum charger_type {
	CHARGER_TYPE_NO = 0,
	CHARGER_TYPE_USB,
	CHARGER_TYPE_AC,
	CHARGER_TYPE_DC,
	CHARGER_TYPE_UNDEF,
};

struct cw201x_info {
	struct udevice *dev;
	int capacity;
	u32 *cw_bat_config_info;
	int divider_res1;
	int divider_res2;
	int hw_id_check;
	int hw_id0;
	int hw_id1;
	int support_dc_adp;
	int dc_det_gpio;
	int dc_det_flag;
};

static u8 cw201x_read(struct cw201x_info *cw201x, u8 reg)
{
	u8 val;
	int ret;

	ret = dm_i2c_read(cw201x->dev, reg, &val, 1);
	if (ret) {
		debug("write error to device: %p register: %#x!",
		      cw201x->dev, reg);
		return ret;
	}

	return val;
}

static int cw201x_write(struct cw201x_info *cw201x, u8 reg, u8 val)
{
	int ret;

	ret = dm_i2c_write(cw201x->dev, reg, &val, 1);
	if (ret) {
		debug("write error to device: %p register: %#x!",
		      cw201x->dev, reg);
		return ret;
	}

	return 0;
}

static u16 cw201x_read_half_word(struct cw201x_info *cw201x, int reg)
{
	u8 vall, valh;
	u16 val;

	valh = cw201x_read(cw201x, reg);
	vall = cw201x_read(cw201x, reg + 1);
	val = ((u16)valh << 8) | vall;

	return val;
}

static int cw201x_ofdata_to_platdata(struct udevice *dev)
{
	const void *blob = gd->fdt_blob;
	int node = dev_of_offset(dev);
	struct cw201x_info *cw201x = dev_get_priv(dev);
	int ret;
	int len, size;
	int hw_id0_val, hw_id1_val;

	if (fdt_getprop(blob, node, "bat_config_info", &len)) {
		len /= sizeof(u32);
		size = sizeof(*cw201x->cw_bat_config_info) * len;
		cw201x->cw_bat_config_info = calloc(size, 1);
		if (!cw201x->cw_bat_config_info) {
			debug("calloc cw_bat_config_info fail\n");
			return -EINVAL;
		}
		ret = fdtdec_get_int_array(blob, node,
					   "bat_config_info",
					   cw201x->cw_bat_config_info, len);
		if (ret) {
			debug("fdtdec_get cw_bat_config_info fail\n");
			return -EINVAL;
		}
	}

	cw201x->support_dc_adp = fdtdec_get_int(blob, node,
						"support_dc_adp", 0);
	if (cw201x->support_dc_adp) {
		cw201x->dc_det_gpio = fdtdec_get_int(blob, node,
						     "dc_det_gpio", 0);
		if (!cw201x->dc_det_gpio)
			return -EINVAL;
		gpio_request(cw201x->dc_det_gpio, "dc_det_gpio");
		gpio_direction_input(cw201x->dc_det_gpio);

		cw201x->dc_det_flag = fdtdec_get_int(blob, node,
						     "dc_det_flag", 0);
	}

	cw201x->hw_id_check = fdtdec_get_int(blob, node, "hw_id_check", 0);
	if (cw201x->hw_id_check) {
		cw201x->hw_id0 = fdtdec_get_int(blob, node, "hw_id0_gpio", 0);
		if (!cw201x->hw_id0)
			return -EINVAL;
		gpio_request(cw201x->hw_id0, "hw_id0_gpio");
		gpio_direction_input(cw201x->hw_id0);
		hw_id0_val = gpio_get_value(cw201x->hw_id0);

		cw201x->hw_id1 = fdtdec_get_int(blob, node, "hw_id1_gpio", 0);
		if (!cw201x->hw_id1)
			return -EINVAL;
		gpio_request(cw201x->hw_id1, "hw_id1_gpio");
		gpio_direction_input(cw201x->hw_id1);
		hw_id1_val = gpio_get_value(cw201x->hw_id1);

		/* ID1 = 0, ID0 = 1 : Battery */
		if (!hw_id0_val || hw_id1_val)
			return -EINVAL;
	}

	cw201x->divider_res1 = fdtdec_get_int(blob, node, "divider_res1", 0);
	cw201x->divider_res2 = fdtdec_get_int(blob, node, "divider_res2", 0);

	return 0;
}

static int cw201x_get_vol(struct cw201x_info *cw201x)
{
	u16 value16, value16_1, value16_2, value16_3;
	int voltage;
	int res1, res2;

	value16 = cw201x_read_half_word(cw201x, REG_VCELL);
	if (value16 < 0)
		return -1;

	value16_1 = cw201x_read_half_word(cw201x, REG_VCELL);
	if (value16_1 < 0)
		return -1;

	value16_2 = cw201x_read_half_word(cw201x, REG_VCELL);
	if (value16_2 < 0)
		return -1;

	if (value16 > value16_1) {
		value16_3 = value16;
		value16 = value16_1;
		value16_1 = value16_3;
	}

	if (value16_1 > value16_2) {
		value16_3 = value16_1;
		value16_1 = value16_2;
		value16_2 = value16_3;
	}

	if (value16 > value16_1) {
		value16_3 = value16;
		value16 = value16_1;
		value16_1 = value16_3;
	}

	voltage = value16_1 * 312 / 1024;

	if (cw201x->divider_res1 &&
	    cw201x->divider_res2) {
		res1 = cw201x->divider_res1;
		res2 = cw201x->divider_res2;
		voltage = voltage * (res1 + res2) / res2;
	}

	debug("the cw201x voltage=%d\n", voltage);
	return voltage;
}

static int cw201x_dwc_otg_check_dpdm(void)
{
#ifdef CONFIG_PHY_ROCKCHIP_INNO_USB2
	return rockchip_chg_get_type();
#else
	debug("rockchip_chg_get_type() is not implement\n");
	return CHARGER_TYPE_NO;
#endif
}

static int cw201x_get_usb_state(struct cw201x_info *cw201x)
{
	int charger_type;

	switch (cw201x_dwc_otg_check_dpdm()) {
	case 0:
		charger_type = CHARGER_TYPE_NO;
		break;
	case 1:
	case 3:
		charger_type = CHARGER_TYPE_USB;
		break;
	case 2:
		charger_type = CHARGER_TYPE_AC;
		break;
	default:
		charger_type = CHARGER_TYPE_NO;
		break;
	}

	return charger_type;
}

static bool cw201x_get_dc_state(struct cw201x_info *cw201x)
{
	if (gpio_get_value(cw201x->dc_det_gpio) == cw201x->dc_det_flag)
		return true;

	return false;
}

static bool cw201x_check_charge(struct cw201x_info *cw201x)
{
	if (cw201x_get_usb_state(cw201x) != CHARGER_TYPE_NO)
		return true;
	if (cw201x_get_dc_state(cw201x))
		return true;

	return false;
}

static int cw201x_get_soc(struct cw201x_info *cw201x)
{
	int cap;

	cap = cw201x_read(cw201x, REG_SOC);
	if ((cap < 0) || (cap > 100))
		cap = cw201x->capacity;

	cw201x->capacity = cap;
	return cw201x->capacity;
}

static int cw201x_update_get_soc(struct udevice *dev)
{
	struct cw201x_info *cw201x = dev_get_priv(dev);

	return cw201x_get_soc(cw201x);
}

static int cw201x_update_get_voltage(struct udevice *dev)
{
	struct cw201x_info *cw201x = dev_get_priv(dev);

	return cw201x_get_vol(cw201x);
}

static bool cw201x_update_get_chrg_online(struct udevice *dev)
{
	struct cw201x_info *cw201x = dev_get_priv(dev);

	return cw201x_check_charge(cw201x);
}

static struct dm_fuel_gauge_ops cw201x_fg_ops = {
	.get_soc = cw201x_update_get_soc,
	.get_voltage = cw201x_update_get_voltage,
	.get_chrg_online = cw201x_update_get_chrg_online,
};

static int cw201x_fg_cfg(struct cw201x_info *cw201x)
{
	u8 val = MODE_SLEEP;
	int i;

	if ((val & MODE_SLEEP_MASK) == MODE_SLEEP) {
		val = MODE_NORMAL;
		cw201x_write(cw201x, REG_MODE, val);
	}

	for (i = 0; i < 64; i++) {
		cw201x_write(cw201x, REG_BATINFO + i,
			     (u8)cw201x->cw_bat_config_info[i]);
	}

	return 0;
}

static int cw201x_fg_probe(struct udevice *dev)
{
	struct cw201x_info *cw201x = dev_get_priv(dev);

	cw201x->dev = dev;
	cw201x_fg_cfg(cw201x);

	debug("vol: %d, soc: %d\n",
	      cw201x_get_vol(cw201x), cw201x_get_soc(cw201x));

	return 0;
}

static const struct udevice_id cw201x_ids[] = {
	{ .compatible = "cw201x" },
	{ }
};

U_BOOT_DRIVER(cw201x_fg) = {
	.name = "cw201x_fg",
	.id = UCLASS_FG,
	.of_match = cw201x_ids,
	.probe = cw201x_fg_probe,
	.ofdata_to_platdata = cw201x_ofdata_to_platdata,
	.ops = &cw201x_fg_ops,
	.priv_auto_alloc_size = sizeof(struct cw201x_info),
};
