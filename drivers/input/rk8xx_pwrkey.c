/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <key.h>
#include <linux/input.h>
#include <power/pmic.h>
#include <power/rk8xx_pmic.h>

#define	RK816_INT_STS_REG1	0x49
#define	RK816_INT_MSK_REG1	0x4a
#define RK816_PWRON_RISE_INT	(1 << 6)
#define RK816_PWRON_FALL_INT	(1 << 5)

#define	RK805_INT_STS_REG	0x4c
#define	RK805_INT_MSK_REG	0x4d
#define RK805_PWRON_RISE_INT	(1 << 0)
#define RK805_PWRON_FALL_INT	(1 << 7)

struct key_data {
	u8 int_sts_reg;
	u8 int_msk_reg;
	u8 pwron_rise_int;
	u8 pwron_fall_int;
};

static int rk8xx_pwrkey_read(struct udevice *dev)
{
	struct key_data *key = dev_get_priv(dev);
	int status = KEY_PRESS_NONE;
	int ret, val;

	val = pmic_reg_read(dev->parent, key->int_sts_reg);
	if (val < 0) {
		printf("%s: i2c read failed, ret=%d\n", __func__, val);
		return val;
	}

	if (val & key->pwron_fall_int)
		status = KEY_PRESS_DOWN;

	/* Must check pwron rise behind of fall !! */
	if (val & key->pwron_rise_int) {
		/* Clear fall when detect rise */
		ret = pmic_reg_write(dev->parent, key->int_sts_reg,
				     key->pwron_fall_int | key->pwron_rise_int);
		if (ret < 0) {
			printf("%s: i2c write failed, ret=%d\n", __func__, val);
			return ret;
		}

		status = KEY_PRESS_UP;
	}

	debug("%s: int sts = 0x%x msk = 0x%x\n",
	      __func__, pmic_reg_read(dev->parent, key->int_sts_reg),
	      pmic_reg_read(dev->parent, key->int_msk_reg));

	return status;
}

static const struct dm_key_ops key_ops = {
	.type = KEY_POWER,
	.name = "pmic-pwrkey",
	.read = rk8xx_pwrkey_read,
};

static int rk8xx_pwrkey_probe(struct udevice *dev)
{
	struct rk8xx_priv *rk8xx = dev_get_priv(dev->parent);
	struct key_data *key = dev_get_priv(dev);
	int ret, val;

	switch (rk8xx->variant) {
	case RK805_ID:
		key->int_sts_reg = RK805_INT_STS_REG;
		key->int_msk_reg = RK805_INT_MSK_REG;
		key->pwron_rise_int = RK805_PWRON_RISE_INT;
		key->pwron_fall_int = RK805_PWRON_FALL_INT;
		break;

	case RK816_ID:
		key->int_sts_reg = RK816_INT_STS_REG1;
		key->int_msk_reg = RK816_INT_MSK_REG1;
		key->pwron_rise_int = RK816_PWRON_RISE_INT;
		key->pwron_fall_int = RK816_PWRON_FALL_INT;
		break;

	default:
		return -EINVAL;
	}

	/* Clear states */
	ret = pmic_reg_write(dev->parent, key->int_sts_reg,
			     key->pwron_rise_int | key->pwron_fall_int);
	if (ret < 0) {
		printf("%s: i2c write failed, ret=%d\n", __func__, ret);
		return ret;
	}

	val = pmic_reg_read(dev->parent, key->int_msk_reg);
	if (val < 0) {
		printf("%s: i2c read failed, ret=%d\n", __func__, val);
		return val;
	}

	/* enable fall and rise interrupt */
	val = 0xff;
	val &= ~(key->pwron_rise_int | key->pwron_fall_int);
	ret = pmic_reg_write(dev->parent, key->int_msk_reg, val);
	if (ret < 0) {
		printf("%s: i2c write failed, ret=%d\n", __func__, val);
		return ret;
	}

	return 0;
}

U_BOOT_DRIVER(rk8xx_pwrkey) = {
	.name   = "rk8xx_pwrkey",
	.id     = UCLASS_KEY,
	.probe  = rk8xx_pwrkey_probe,
	.ops	= &key_ops,
	.priv_auto_alloc_size = sizeof(struct key_data),
};
