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

#define	RK817_INT_STS_REG0	0xf8
#define	RK817_INT_MSK_REG0	0xf9
#define	RK817_INT_STS_REG1	0xfa
#define	RK817_INT_MSK_REG1	0xfb
#define	RK817_INT_STS_REG2	0xfc
#define	RK817_INT_MSK_REG2	0xfd
#define RK817_PWRON_RISE_INT	(1 << 1)
#define RK817_PWRON_FALL_INT	(1 << 0)
#define RK817_PLUG_OUT_INT	(1 << 1)

#define	RK816_INT_STS_REG1	0x49
#define	RK816_INT_MSK_REG1	0x4a
#define	RK816_INT_STS_REG2	0x4c
#define	RK816_INT_MSK_REG2	0x4d
#define	RK816_INT_STS_REG3	0x4e
#define	RK816_INT_MSK_REG3	0x4f
#define RK816_PWRON_RISE_INT	(1 << 6)
#define RK816_PWRON_FALL_INT	(1 << 5)
#define RK816_PLUG_OUT_INT	(1 << 1)

#define	RK805_INT_STS_REG	0x4c
#define	RK805_INT_MSK_REG	0x4d
#define RK805_PWRON_RISE_INT	(1 << 0)
#define RK805_PWRON_FALL_INT	(1 << 7)

struct rk8xx_key_priv {
	u8 key_int_sts_reg;
	u8 key_int_msk_reg;
	u8 plug_int_sts_reg;
	u8 plug_int_msk_reg;
	u8 pwron_rise_int;
	u8 pwron_fall_int;
	u8 plug_out_int;
	struct reg_data *init_reg;
	u32 init_reg_num;
	struct reg_data *irq_reg;
	u32 irq_reg_num;
};

static struct reg_data rk817_init_reg[] = {
	/* only enable rise/fall interrupt, plugout */
	{ RK817_INT_MSK_REG0, 0xfc },
	{ RK817_INT_MSK_REG1, 0xfd },
	{ RK817_INT_MSK_REG2, 0xff },
	/* clear all interrupt states */
	{ RK817_INT_STS_REG0, 0xff },
	{ RK817_INT_STS_REG1, 0xff },
	{ RK817_INT_STS_REG2, 0xff },
};

static struct reg_data rk817_irq_reg[] = {
	/* clear all interrupt states */
	{ RK817_INT_STS_REG0, 0xff },
	{ RK817_INT_STS_REG1, 0xff },
	{ RK817_INT_STS_REG2, 0xff },
};

static struct reg_data rk816_init_reg[] = {
	/* only enable rise/fall interrupt, plugout */
	{ RK816_INT_MSK_REG1, 0x9f },
	{ RK816_INT_MSK_REG2, 0xff },
	{ RK816_INT_MSK_REG3, 0xfd },
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

static void pwrkey_irq_handler(int irq, void *data)
{
	struct udevice *dev = data;
	struct rk8xx_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	int ret, val, i;

	debug("%s: irq = %d\n", __func__, irq);

	/*
	 * This plug out interrupt only used to wakeup cpu while U-Boot
	 * charging and system suspend. Because we need to detect charger
	 * plug out event and then shutdown system.
	 */
	if (priv->plug_int_sts_reg) {
		val = pmic_reg_read(dev->parent, priv->plug_int_sts_reg);
		if (val < 0) {
			printf("%s: i2c read failed, ret=%d\n", __func__, val);
			return;
		}

		if (val & priv->plug_out_int)
			printf("Plug out interrupt\n");
	}

	/* read key status */
	val = pmic_reg_read(dev->parent, priv->key_int_sts_reg);
	if (val < 0) {
		printf("%s: i2c read failed, ret=%d\n", __func__, val);
		return;
	}

	/* fall event */
	if (val & priv->pwron_fall_int) {
		key->down_t = key_timer(0);
		debug("%s: key down: %llu ms\n", __func__, key->down_t);
	}

	/* rise event */
	if (val & priv->pwron_rise_int) {
		key->up_t = key_timer(0);
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

		debug("%s: reg[0x%x] = 0x%x\n", __func__, priv->irq_reg[i].reg,
		      pmic_reg_read(dev->parent, priv->irq_reg[i].reg));
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

	key->parent = dev;
	key->name = "rk8xx_pwrkey";
	key->code = KEY_POWER;
	key->type = GPIO_KEY;
	irq = phandle_gpio_to_irq(phandle, interrupt[0]);
	if (irq < 0) {
		printf("%s: failed to request irq, ret=%d\n", key->name, irq);
		return irq;
	}
	key->irq = irq;
	key_add(key);
	irq_install_handler(irq, pwrkey_irq_handler, dev);
	irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
	irq_handler_enable(irq);

	return 0;
}

static const struct dm_key_ops key_ops = {
	.name = "rk8xx-pwrkey",
};

static int rk8xx_pwrkey_probe(struct udevice *dev)
{
	struct rk8xx_priv *rk8xx = dev_get_priv(dev->parent);
	struct rk8xx_key_priv *priv = dev_get_priv(dev);
	int ret, i;

	switch (rk8xx->variant) {
	case RK805_ID:
		priv->key_int_sts_reg = RK805_INT_STS_REG;
		priv->key_int_msk_reg = RK805_INT_MSK_REG;
		priv->pwron_rise_int = RK805_PWRON_RISE_INT;
		priv->pwron_fall_int = RK805_PWRON_FALL_INT;
		priv->init_reg = rk805_init_reg;
		priv->init_reg_num = ARRAY_SIZE(rk805_init_reg);
		priv->irq_reg = rk805_irq_reg;
		priv->irq_reg_num = ARRAY_SIZE(rk805_irq_reg);
		break;

	case RK816_ID:
		priv->key_int_sts_reg = RK816_INT_STS_REG1;
		priv->key_int_msk_reg = RK816_INT_MSK_REG1;
		priv->plug_int_sts_reg = RK816_INT_STS_REG3;
		priv->plug_int_msk_reg = RK816_INT_MSK_REG3;
		priv->pwron_rise_int = RK816_PWRON_RISE_INT;
		priv->pwron_fall_int = RK816_PWRON_FALL_INT;
		priv->plug_out_int = RK816_PLUG_OUT_INT;
		priv->init_reg = rk816_init_reg;
		priv->init_reg_num = ARRAY_SIZE(rk816_init_reg);
		priv->irq_reg = rk816_irq_reg;
		priv->irq_reg_num = ARRAY_SIZE(rk816_irq_reg);
		break;
	case RK809_ID:
	case RK817_ID:
		priv->key_int_sts_reg = RK817_INT_STS_REG0;
		priv->key_int_msk_reg = RK817_INT_MSK_REG0;
		priv->plug_int_sts_reg = RK817_INT_STS_REG1;
		priv->plug_int_msk_reg = RK817_INT_MSK_REG1;
		priv->pwron_rise_int = RK817_PWRON_RISE_INT;
		priv->pwron_fall_int = RK817_PWRON_FALL_INT;
		priv->plug_out_int = RK817_PLUG_OUT_INT;
		priv->init_reg = rk817_init_reg;
		priv->init_reg_num = ARRAY_SIZE(rk817_init_reg);
		priv->irq_reg = rk817_irq_reg;
		priv->irq_reg_num = ARRAY_SIZE(rk817_irq_reg);
		break;
	default:
		return -EINVAL;
	}

	/* mask and clear interrupt */
	for (i = 0; i < priv->init_reg_num; i++) {
		ret = pmic_reg_write(dev->parent,
				     priv->init_reg[i].reg,
				     priv->init_reg[i].val);
		if (ret < 0) {
			printf("%s: i2c write reg 0x%x failed, ret=%d\n",
			       __func__, priv->init_reg[i].reg, ret);
			return ret;
		}

		debug("%s: reg[%x] = 0x%x\n", __func__, priv->init_reg[i].reg,
		      pmic_reg_read(dev->parent, priv->init_reg[i].reg));
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
