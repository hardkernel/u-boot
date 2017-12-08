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

struct key_data {
	u8 int_sts_reg;
	u8 int_msk_reg;
	u8 pwron_rise_int;
	u8 pwron_fall_int;
	struct reg_data *init_reg;
	u32 init_reg_num;
	struct reg_data *irq_reg;
	u32 irq_reg_num;
	uint64_t key_down_t;
	uint64_t key_up_t;
};

struct reg_data {
	u8 reg;
	u8 val;
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

static inline uint64_t arch_counter_get_cntpct(void)
{
	uint64_t cval = 0;

	isb();
#ifdef CONFIG_ARM64
	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
#else
	asm volatile ("mrrc p15, 0, %Q0, %R0, c14" : "=r" (cval));
#endif
	return cval;
}

static uint64_t get_ms(uint64_t base)
{
	return (arch_counter_get_cntpct() / 24000UL) - base;
}

static int rk8xx_pwrkey_read(struct udevice *dev)
{
	struct key_data *key = dev_get_priv(dev);
	u32 report = KEY_PRESS_NONE;

	if ((key->key_up_t > key->key_down_t) &&
	    (key->key_up_t - key->key_down_t) >= KEY_LONG_DOWN_MS) {
		debug("%s: long key ms: %llu\n", __func__, key->key_up_t - key->key_down_t);
		key->key_up_t = 0;
		key->key_down_t = 0;
		report = KEY_PRESS_LONG_DOWN;
	} else if (key->key_down_t && get_ms(key->key_down_t) >= KEY_LONG_DOWN_MS) {
		debug("%s: long key (hold) ms: %llu\n", __func__, key->key_up_t - key->key_down_t);
		key->key_up_t = 0;
		key->key_down_t = 0;
		report = KEY_PRESS_LONG_DOWN;
	} else if ((key->key_up_t > key->key_down_t) &&
		   (key->key_up_t - key->key_down_t) < KEY_LONG_DOWN_MS) {
		debug("%s: short key ms: %llu\n", __func__, key->key_up_t - key->key_down_t);
		key->key_up_t = 0;
		key->key_down_t = 0;
		report = KEY_PRESS_DOWN;
	} else {
		debug("%s: key up: %llu, down: %llu\n", __func__, key->key_up_t, key->key_down_t);
	}

	return report;
}

static void pwrkey_irq_handler(int irq, void *data)
{
	struct udevice *dev = data;
	struct key_data *key = dev_get_priv(dev);
	int ret, val, i;

	/* read status */
	val = pmic_reg_read(dev->parent, key->int_sts_reg);
	if (val < 0) {
		printf("%s: i2c read failed, ret=%d\n", __func__, val);
		return;
	}

	/* fall event */
	if (val & key->pwron_fall_int) {
		key->key_down_t = get_ms(0);
		debug("%s: key down: %llu ms\n", __func__, key->key_down_t);
	}

	/* rise event */
	if (val & key->pwron_rise_int) {
		key->key_up_t = get_ms(0);
		debug("%s: key up: %llu ms\n", __func__, key->key_up_t);
	}

	/* clear intertup */
	for (i = 0; i < key->irq_reg_num; i++) {
		ret = pmic_reg_write(dev->parent,
				     key->irq_reg[i].reg,
				     key->irq_reg[i].val);
		if (ret < 0) {
			printf("%s: i2c write reg 0x%x failed, ret=%d\n",
			       __func__, key->irq_reg[i].reg, ret);
		}
	}
}

static int pwrkey_interrupt_init(struct udevice *dev)
{
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

	irq = phandle_gpio_to_irq(phandle, interrupt[0]);
	irq_install_handler(irq, pwrkey_irq_handler, dev);
	irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
	irq_handler_enable(irq);

	return 0;
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
	int ret, i;

	switch (rk8xx->variant) {
	case RK805_ID:
		key->int_sts_reg = RK805_INT_STS_REG;
		key->int_msk_reg = RK805_INT_MSK_REG;
		key->pwron_rise_int = RK805_PWRON_RISE_INT;
		key->pwron_fall_int = RK805_PWRON_FALL_INT;
		key->init_reg = rk805_init_reg;
		key->init_reg_num = ARRAY_SIZE(rk805_init_reg);
		key->irq_reg = rk805_irq_reg;
		key->irq_reg_num = ARRAY_SIZE(rk805_irq_reg);
		break;

	case RK816_ID:
		key->int_sts_reg = RK816_INT_STS_REG1;
		key->int_msk_reg = RK816_INT_MSK_REG1;
		key->pwron_rise_int = RK816_PWRON_RISE_INT;
		key->pwron_fall_int = RK816_PWRON_FALL_INT;
		key->init_reg = rk816_init_reg;
		key->init_reg_num = ARRAY_SIZE(rk816_init_reg);
		key->irq_reg = rk816_irq_reg;
		key->irq_reg_num = ARRAY_SIZE(rk816_irq_reg);
		break;

	default:
		return -EINVAL;
	}

	/* mask and clear intertup */
	for (i = 0; i < key->init_reg_num; i++) {
		ret = pmic_reg_write(dev->parent,
				     key->init_reg[i].reg,
				     key->init_reg[i].val);
		if (ret < 0) {
			printf("%s: i2c write reg 0x%x failed, ret=%d\n",
			       __func__, key->init_reg[i].reg, ret);
			return ret;
		}
	}

	return pwrkey_interrupt_init(dev);
}

U_BOOT_DRIVER(rk8xx_pwrkey) = {
	.name   = "rk8xx_pwrkey",
	.id     = UCLASS_KEY,
	.probe  = rk8xx_pwrkey_probe,
	.ops	= &key_ops,
	.priv_auto_alloc_size = sizeof(struct key_data),
};
