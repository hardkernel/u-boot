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
#include <irq-generic.h>
#include <asm/arch/periph.h>
#include <dm/pinctrl.h>

#define	RK816_INT_STS_REG1	0x49
#define	RK816_INT_MSK_REG1	0x4a
#define	RK816_INT_STS_REG2	0x4c
#define	RK816_INT_MSK_REG2	0x4d
#define	RK816_INT_STS_REG3	0x4e
#define	RK816_INT_MSK_REG3	0x4f
#define RK816_PWRON_RISE_INT	(1 << 6)
#define RK816_PWRON_FALL_INT	(1 << 5)

#define	RK805_INT_STS_REG	0x4c
#define	RK805_INT_MSK_REG	0x4d
#define RK805_PWRON_RISE_INT	(1 << 0)
#define RK805_PWRON_FALL_INT	(1 << 7)

struct reg_data {
	u8 reg;
	u8 val;
};

struct rk8xx_key_priv {
	u8 int_sts_reg;
	u8 int_msk_reg;
	u8 pwron_rise_int;
	u8 pwron_fall_int;
	struct reg_data *init_reg;
	u32 init_reg_num;
	struct reg_data *irq_reg;
	u32 irq_reg_num;
};

static struct reg_data rk816_init_reg[] = {
	/* only enable rise/fall interrupt */
	{ RK816_INT_MSK_REG1, 0x9f },
	{ RK816_INT_MSK_REG2, 0xff },
	{ RK816_INT_MSK_REG3, 0xff },
	/* clear all interrupt states */
	{ RK816_INT_STS_REG1, 0xff },
	{ RK816_INT_STS_REG2, 0xff },
	{ RK816_INT_STS_REG3, 0xff },
};

static struct reg_data rk816_irq_reg[] = {
	/* clear all interrupt states */
	{ RK816_INT_STS_REG1, 0xff },
	{ RK816_INT_STS_REG2, 0xff },
	{ RK816_INT_STS_REG3, 0xff },
};

static struct reg_data rk805_irq_reg[] = {
	/* clear all interrupt states */
	{ RK805_INT_STS_REG, 0xff },
};

static struct reg_data rk805_init_reg[] = {
	/* only enable rise/fall interrupt */
	{ RK805_INT_MSK_REG, 0x7e },
	/* clear all interrupt states */
	{ RK805_INT_STS_REG, 0xff },
};

static int rk8xx_pwrkey_read(struct udevice *dev, int code)
{
	struct input_key *key = dev_get_platdata(dev);
	u32 report = KEY_NOT_EXIST;

	if (key->code != code)
		goto out;

	debug("%s: long key ms: %llu\n",
	      __func__, key->up_t - key->down_t);

	if ((key->up_t > key->down_t) &&
	    (key->up_t - key->down_t) >= KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		report = KEY_PRESS_LONG_DOWN;
		printf("'%s' key long pressed down\n", key->name);
	} else if (key->down_t &&
		   key_get_timer(key->down_t) >= KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		report = KEY_PRESS_LONG_DOWN;
		printf("'%s' key long pressed down(hold)\n", key->name);
	} else if ((key->up_t > key->down_t) &&
		   (key->up_t - key->down_t) < KEY_LONG_DOWN_MS) {
		key->up_t = 0;
		key->down_t = 0;
		report = KEY_PRESS_DOWN;
		printf("'%s' key pressed down\n", key->name);
	} else {
		report = KEY_PRESS_NONE;
	}

out:
	return report;
}

static void pwrkey_irq_handler(int irq, void *data)
{
	struct udevice *dev = data;
	struct rk8xx_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	int ret, val, i;

	/* read status */
	val = pmic_reg_read(dev->parent, priv->int_sts_reg);
	if (val < 0) {
		printf("%s: i2c read failed, ret=%d\n", __func__, val);
		return;
	}

	/* fall event */
	if (val & priv->pwron_fall_int) {
		key->down_t = key_get_timer(0);
		debug("%s: key down: %llu ms\n", __func__, key->down_t);
	}

	/* rise event */
	if (val & priv->pwron_rise_int) {
		key->up_t = key_get_timer(0);
		debug("%s: key up: %llu ms\n", __func__, key->up_t);
	}

	/* clear intertup */
	for (i = 0; i < priv->irq_reg_num; i++) {
		ret = pmic_reg_write(dev->parent,
				     priv->irq_reg[i].reg,
				     priv->irq_reg[i].val);
		if (ret < 0) {
			printf("%s: i2c write reg 0x%x failed, ret=%d\n",
			       __func__, priv->irq_reg[i].reg, ret);
		}
	}
}

static int pwrkey_interrupt_init(struct udevice *dev)
{
	struct input_key *key = dev_get_platdata(dev);
	u32 interrupt[2], phandle;
	int irq, ret;

	phandle = dev_read_u32_default(dev->parent, "interrupt-parent", -1);
	if (phandle < 0) {
		printf("failed get 'interrupt-parent', ret=%d\n", phandle);
		return phandle;
	}

	ret = dev_read_u32_array(dev->parent, "interrupts", interrupt, 2);
	if (ret) {
		printf("failed get 'interrupt', ret=%d\n", ret);
		return ret;
	}

	key->name = "pwrkey";
	key->code = KEY_POWER;
	irq = phandle_gpio_to_irq(phandle, interrupt[0]);
	irq_install_handler(irq, pwrkey_irq_handler, dev);
	irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
	irq_handler_enable(irq);

	return 0;
}

static const struct dm_key_ops key_ops = {
	.name = "rk8xx-pwrkey",
	.read = rk8xx_pwrkey_read,
};

static int rk8xx_pwrkey_probe(struct udevice *dev)
{
	struct rk8xx_priv *rk8xx = dev_get_priv(dev->parent);
	struct rk8xx_key_priv *priv = dev_get_priv(dev);
	int ret, i;

	switch (rk8xx->variant) {
	case RK805_ID:
		priv->int_sts_reg = RK805_INT_STS_REG;
		priv->int_msk_reg = RK805_INT_MSK_REG;
		priv->pwron_rise_int = RK805_PWRON_RISE_INT;
		priv->pwron_fall_int = RK805_PWRON_FALL_INT;
		priv->init_reg = rk805_init_reg;
		priv->init_reg_num = ARRAY_SIZE(rk805_init_reg);
		priv->irq_reg = rk805_irq_reg;
		priv->irq_reg_num = ARRAY_SIZE(rk805_irq_reg);
		break;

	case RK816_ID:
		priv->int_sts_reg = RK816_INT_STS_REG1;
		priv->int_msk_reg = RK816_INT_MSK_REG1;
		priv->pwron_rise_int = RK816_PWRON_RISE_INT;
		priv->pwron_fall_int = RK816_PWRON_FALL_INT;
		priv->init_reg = rk816_init_reg;
		priv->init_reg_num = ARRAY_SIZE(rk816_init_reg);
		priv->irq_reg = rk816_irq_reg;
		priv->irq_reg_num = ARRAY_SIZE(rk816_irq_reg);
		break;

	default:
		return -EINVAL;
	}

	/* mask and clear intertup */
	for (i = 0; i < priv->init_reg_num; i++) {
		ret = pmic_reg_write(dev->parent,
				     priv->init_reg[i].reg,
				     priv->init_reg[i].val);
		if (ret < 0) {
			printf("%s: i2c write reg 0x%x failed, ret=%d\n",
			       __func__, priv->init_reg[i].reg, ret);
			return ret;
		}
	}

	return pwrkey_interrupt_init(dev);
}

U_BOOT_DRIVER(rk8xx_pwrkey) = {
	.name   = "rk8xx_pwrkey",
	.id     = UCLASS_KEY,
	.ops	= &key_ops,
	.probe  = rk8xx_pwrkey_probe,
	.platdata_auto_alloc_size = sizeof(struct input_key),
	.priv_auto_alloc_size = sizeof(struct rk8xx_key_priv),
};
