/*
 * Copyright (C) 2015 Google, Inc
 * Written by Simon Glass <sjg@chromium.org>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <errno.h>
#include <irq-generic.h>
#include <power/rk8xx_pmic.h>
#include <power/pmic.h>

DECLARE_GLOBAL_DATA_PTR;

#if defined(CONFIG_IRQ) && !defined(CONFIG_SPL_BUILD)
/* RK805 */
static const struct virq_reg rk805_irqs[] = {
	[RK8XX_IRQ_PWRON_FALL] = {
		.mask = RK805_IRQ_PWRON_FALL_MSK,
		.reg_offset = 0,
	},
	[RK8XX_IRQ_PWRON_RISE] = {
		.mask = RK805_IRQ_PWRON_RISE_MSK,
		.reg_offset = 0,
	},
};

static struct virq_chip rk805_irq_chip = {
	.status_base		= RK805_INT_STS_REG,
	.mask_base		= RK805_INT_MSK_REG,
	.num_regs		= 1,
	.i2c_read		= pmic_reg_read,
	.i2c_write		= pmic_reg_write,
	.irqs			= rk805_irqs,
	.num_irqs		= ARRAY_SIZE(rk805_irqs),
};

/* RK808 */
static const struct virq_reg rk808_irqs[] = {
	[RK8XX_IRQ_PLUG_OUT] = {
		.mask = RK808_IRQ_PLUG_OUT_MSK,
		.reg_offset = 1,
	},
};

static struct virq_chip rk808_irq_chip = {
	.status_base		= RK808_INT_STS_REG1,
	.mask_base		= RK808_INT_MSK_REG1,
	.irq_reg_stride		= 2,
	.num_regs		= 2,
	.i2c_read		= pmic_reg_read,
	.i2c_write		= pmic_reg_write,
	.irqs			= rk808_irqs,
	.num_irqs		= ARRAY_SIZE(rk808_irqs),
};

/* RK816 */
static const struct virq_reg rk816_irqs[] = {
	[RK8XX_IRQ_PWRON_FALL] = {
		.mask = RK816_IRQ_PWRON_FALL_MSK,
		.reg_offset = 0,
	},
	[RK8XX_IRQ_PWRON_RISE] = {
		.mask = RK816_IRQ_PWRON_RISE_MSK,
		.reg_offset = 0,
	},
	[RK8XX_IRQ_PLUG_OUT] = {
		.mask = RK816_IRQ_PLUG_OUT_MSK,
		.reg_offset = 2,
	},
	[RK8XX_IRQ_CHG_OK] = {
		.mask = RK816_IRQ_CHR_OK_MSK,
		.reg_offset = 2,
	},
};

static struct virq_chip rk816_irq_chip = {
	.status_base		= RK816_INT_STS_REG1,
	.mask_base		= RK816_INT_MSK_REG1,
	.irq_unalign_reg_idx	= 1,	/* idx <= 1, stride = 3 */
	.irq_unalign_reg_stride	= 3,
	.irq_reg_stride		= 2,	/* idx > 1, stride = 2 */
	.num_regs		= 3,
	.i2c_read		= pmic_reg_read,
	.i2c_write		= pmic_reg_write,
	.irqs			= rk816_irqs,
	.num_irqs		= ARRAY_SIZE(rk816_irqs),
};

/* RK818 */
static const struct virq_reg rk818_irqs[] = {
	[RK8XX_IRQ_PLUG_OUT] = {
		.mask = RK818_IRQ_PLUG_OUT_MSK,
		.reg_offset = 1,
	},
	[RK8XX_IRQ_CHG_OK] = {
		.mask = RK818_IRQ_CHR_OK_MSK,
		.reg_offset = 1,
	},
};

static struct virq_chip rk818_irq_chip = {
	.status_base		= RK818_INT_STS_REG1,
	.mask_base		= RK818_INT_MSK_REG1,
	.irq_reg_stride		= 2,
	.num_regs		= 2,
	.i2c_read		= pmic_reg_read,
	.i2c_write		= pmic_reg_write,
	.irqs			= rk818_irqs,
	.num_irqs		= ARRAY_SIZE(rk818_irqs),
};

/* RK817/RK809 */
static const struct virq_reg rk817_irqs[] = {
	[RK8XX_IRQ_PWRON_FALL] = {
		.mask = RK817_IRQ_PWRON_FALL_MSK,
		.reg_offset = 0,
	},
	[RK8XX_IRQ_PWRON_RISE] = {
		.mask = RK817_IRQ_PWRON_RISE_MSK,
		.reg_offset = 0,
	},
	[RK8XX_IRQ_PLUG_OUT] = {
		.mask = RK817_IRQ_PLUG_OUT_MSK,
		.reg_offset = 1,
	},
	[RK8XX_IRQ_PLUG_IN] = {
		.mask = RK817_IRQ_PLUG_IN_MSK,
		.reg_offset = 1,
	},
};

static struct virq_chip rk817_irq_chip = {
	.status_base		= RK817_INT_STS_REG0,
	.mask_base		= RK817_INT_MSK_REG0,
	.irq_reg_stride		= 2,
	.num_regs		= 3,
	.i2c_read		= pmic_reg_read,
	.i2c_write		= pmic_reg_write,
	.irqs			= rk817_irqs,
	.num_irqs		= ARRAY_SIZE(rk817_irqs),
};
#endif

static struct reg_data rk817_init_reg[] = {
/* enable the under-voltage protection,
 * the under-voltage protection will shutdown the LDO3 and reset the PMIC
 */
	{ RK817_BUCK4_CMIN, 0x60, 0x60},
/*
 * Only when system suspend while U-Boot charge needs this config support
 */
#ifdef CONFIG_DM_CHARGE_DISPLAY
	/* Set pmic_sleep as sleep function */
	{ RK817_PMIC_SYS_CFG3, 0x08, 0x18 },
	/* Set pmic_int active low */
	{ RK817_GPIO_INT_CFG,  0x00, 0x02 },
#endif
};

static struct reg_data rk818_init_current[] = {
	{ REG_USB_CTRL, 0x07, 0x0f}, /* 2A */
};

static const struct pmic_child_info pmic_children_info[] = {
	{ .prefix = "DCDC", .driver = "rk8xx_buck"},
	{ .prefix = "LDO", .driver = "rk8xx_ldo"},
	{ .prefix = "SWITCH", .driver = "rk8xx_switch"},
	{ },
};

static const struct pmic_child_info power_key_info[] = {
	{ .prefix = "pwrkey", .driver = "rk8xx_pwrkey"},
	{ },
};

static const struct pmic_child_info rtc_info[] = {
	{ .prefix = "rtc", .driver = "rk8xx_rtc"},
	{ },
};

static const struct pmic_child_info fuel_gauge_info[] = {
	{ .prefix = "battery", .driver = "rk818_fg"},
	{ .prefix = "battery", .driver = "rk817_fg"},
	{ .prefix = "battery", .driver = "rk816_fg"},
	{ },
};

static const struct pmic_child_info rk817_codec_info[] = {
	{ .prefix = "codec", .driver = "rk817_codec"},
	{ },
};

static int rk8xx_reg_count(struct udevice *dev)
{
	return RK808_NUM_OF_REGS;
}

static int rk8xx_write(struct udevice *dev, uint reg, const uint8_t *buff,
			  int len)
{
	int ret;

	ret = dm_i2c_write(dev, reg, buff, len);
	if (ret) {
		printf("%s: write reg 0x%02x failed, ret=%d\n", __func__, reg, ret);
		return ret;
	}

	return 0;
}

static int rk8xx_read(struct udevice *dev, uint reg, uint8_t *buff, int len)
{
	int ret;

	ret = dm_i2c_read(dev, reg, buff, len);
	if (ret) {
		printf("%s: read reg 0x%02x failed, ret=%d\n", __func__, reg, ret);
		return ret;
	}

	return 0;
}

static int rk8xx_shutdown(struct udevice *dev)
{
	struct rk8xx_priv *priv = dev_get_priv(dev);
	u8 val, dev_off, devctrl_reg;
	int ret = 0;

	switch (priv->variant) {
	case RK808_ID:
		devctrl_reg = REG_DEVCTRL;
		dev_off = BIT(3);
		break;
	case RK805_ID:
	case RK816_ID:
	case RK818_ID:
		devctrl_reg = REG_DEVCTRL;
		dev_off = BIT(0);
		break;
	case RK809_ID:
	case RK817_ID:
		devctrl_reg = RK817_REG_SYS_CFG3;
		dev_off = BIT(0);
		break;
	default:
		printf("Unknown PMIC: RK%x\n", priv->variant);
		return -EINVAL;
	}

	ret = dm_i2c_read(dev, devctrl_reg, &val, 1);
	if (ret) {
		printf("%s: read reg 0x%02x failed, ret=%d\n",
		       __func__, devctrl_reg, ret);
		return ret;
	}

	val |= dev_off;
	ret = dm_i2c_write(dev, devctrl_reg, &val, 1);
	if (ret) {
		printf("%s: write reg 0x%02x failed, ret=%d\n",
		       __func__, devctrl_reg, ret);
		return ret;
	}

	return 0;
}

/*
 * When system suspend during U-Boot charge, make sure the plugout event
 * be able to wakeup cpu in wfi/wfe state.
 */
#ifdef CONFIG_DM_CHARGE_DISPLAY
static void rk8xx_plug_out_handler(int irq, void *data)
{
	printf("Plug out interrupt\n");
}
#endif

#if CONFIG_IS_ENABLED(PMIC_CHILDREN)
static int rk8xx_bind(struct udevice *dev)
{
	ofnode regulators_node;
	int children;

	regulators_node = dev_read_subnode(dev, "regulators");
	if (!ofnode_valid(regulators_node)) {
		debug("%s: %s regulators subnode not found!\n", __func__,
		      dev->name);
		return -ENXIO;
	}

	debug("%s: '%s' - found regulators subnode\n", __func__, dev->name);

	children = pmic_bind_children(dev, regulators_node, pmic_children_info);
	if (!children)
		debug("%s: %s - no child found\n", __func__, dev->name);

	children = pmic_bind_children(dev, dev->node, power_key_info);
	if (!children)
		debug("%s: %s - no child found\n", __func__, dev->name);

	children = pmic_bind_children(dev, dev->node, rtc_info);
	if (!children)
		debug("%s: %s - no child found\n", __func__, dev->name);

	children = pmic_bind_children(dev, dev->node, fuel_gauge_info);
	if (!children)
		debug("%s: %s - no child found\n", __func__, dev->name);

	children = pmic_bind_children(dev, dev->node, rk817_codec_info);
	if (!children)
		debug("%s: %s - no child found\n", __func__, dev->name);

	/* Always return success for this device */
	return 0;
}
#endif

#if defined(CONFIG_IRQ) && !defined(CONFIG_SPL_BUILD)
static int rk8xx_ofdata_to_platdata(struct udevice *dev)
{
	struct rk8xx_priv *rk8xx = dev_get_priv(dev);
	u32 interrupt, phandle;
	int ret;

	phandle = dev_read_u32_default(dev, "interrupt-parent", -ENODATA);
	if (phandle == -ENODATA) {
		printf("Read 'interrupt-parent' failed, ret=%d\n", phandle);
		return phandle;
	}

	ret = dev_read_u32_array(dev, "interrupts", &interrupt, 1);
	if (ret) {
		printf("Read 'interrupts' failed, ret=%d\n", ret);
		return ret;
	}

	rk8xx->irq = phandle_gpio_to_irq(phandle, interrupt);
	if (rk8xx->irq < 0) {
		printf("Failed to request rk8xx irq, ret=%d\n", rk8xx->irq);
		return rk8xx->irq;
	}

	return 0;
}

static int rk8xx_irq_chip_init(struct udevice *dev)
{
	struct rk8xx_priv *priv = dev_get_priv(dev);
	struct virq_chip *irq_chip = NULL;
	int ret;

	switch (priv->variant) {
	case RK808_ID:
		irq_chip = &rk808_irq_chip;
		break;
	case RK805_ID:
		irq_chip = &rk805_irq_chip;
		break;
	case RK816_ID:
		irq_chip = &rk816_irq_chip;
		break;
	case RK818_ID:
		irq_chip = &rk818_irq_chip;
		break;
	case RK809_ID:
	case RK817_ID:
		irq_chip = &rk817_irq_chip;
		break;
	default:
		return -EINVAL;
	}

	if (irq_chip) {
		ret = virq_add_chip(dev, irq_chip, priv->irq);
		if (ret) {
			printf("Failed to add irqchip(irq=%d), ret=%d\n",
			       priv->irq, ret);
			return ret;
		}

		priv->irq_chip = irq_chip;

#ifdef CONFIG_DM_CHARGE_DISPLAY
		int irq;

		irq = virq_to_irq(irq_chip, RK8XX_IRQ_PLUG_OUT);
		if (irq < 0) {
			printf("Failed to register plugout irq, ret=%d\n", irq);
			return irq;
		}
		irq_install_handler(irq, rk8xx_plug_out_handler, dev);
		irq_handler_enable_suspend_only(irq);
#endif
	}

	return 0;
}
#else
static inline int rk8xx_ofdata_to_platdata(struct udevice *dev) { return 0; }
static inline int rk8xx_irq_chip_init(struct udevice *dev) { return 0; }
#endif

static int rk8xx_probe(struct udevice *dev)
{
	struct rk8xx_priv *priv = dev_get_priv(dev);
	struct reg_data *init_current = NULL;
	struct reg_data *init_data = NULL;
	int init_current_num = 0;
	int init_data_num = 0;
	int ret = 0, i, show_variant;
	uint8_t msb, lsb, id_msb, id_lsb;
	uint8_t on_source = 0, off_source = 0;
	uint8_t power_en0, power_en1, power_en2, power_en3;
	uint8_t value;

	/* read Chip variant */
	if (device_is_compatible(dev, "rockchip,rk817") ||
	    device_is_compatible(dev, "rockchip,rk809")) {
		id_msb = RK817_ID_MSB;
		id_lsb = RK817_ID_LSB;
	} else {
		id_msb = ID_MSB;
		id_lsb = ID_LSB;
	}

	ret = rk8xx_read(dev, id_msb, &msb, 1);
	if (ret)
		return ret;
	ret = rk8xx_read(dev, id_lsb, &lsb, 1);
	if (ret)
		return ret;

	priv->variant = ((msb << 8) | lsb) & RK8XX_ID_MSK;
	show_variant = priv->variant;
	switch (priv->variant) {
	case RK808_ID:
		show_variant = 0x808;	/* RK808 hardware ID is 0 */
		break;
	case RK805_ID:
	case RK816_ID:
		on_source = RK8XX_ON_SOURCE;
		off_source = RK8XX_OFF_SOURCE;
		break;
	case RK818_ID:
		on_source = RK8XX_ON_SOURCE;
		off_source = RK8XX_OFF_SOURCE;
		/* set current if no fuel gauge */
		if (!ofnode_valid(dev_read_subnode(dev, "battery"))) {
			init_current = rk818_init_current;
			init_current_num = ARRAY_SIZE(rk818_init_current);
		}
		break;
	case RK809_ID:
	case RK817_ID:
		on_source = RK817_ON_SOURCE;
		off_source = RK817_OFF_SOURCE;
		init_data = rk817_init_reg;
		init_data_num = ARRAY_SIZE(rk817_init_reg);
		power_en0 = pmic_reg_read(dev, RK817_POWER_EN0);
		power_en1 = pmic_reg_read(dev, RK817_POWER_EN1);
		power_en2 = pmic_reg_read(dev, RK817_POWER_EN2);
		power_en3 = pmic_reg_read(dev, RK817_POWER_EN3);

		value = (power_en0 & 0x0f) | ((power_en1 & 0x0f) << 4);
		pmic_reg_write(dev, RK817_POWER_EN_SAVE0, value);
		value = (power_en2 & 0x0f) | ((power_en3 & 0x0f) << 4);
		pmic_reg_write(dev, RK817_POWER_EN_SAVE1, value);
		break;
	default:
		printf("Unknown PMIC: RK%x!!\n", priv->variant);
		return -EINVAL;
	}

	/* common init */
	for (i = 0; i < init_data_num; i++) {
		ret = pmic_clrsetbits(dev,
				      init_data[i].reg,
				      init_data[i].mask,
				      init_data[i].val);
		if (ret < 0) {
			printf("%s: i2c set reg 0x%x failed, ret=%d\n",
			       __func__, init_data[i].reg, ret);
		}
	}

	/* current init */
	for (i = 0; i < init_current_num; i++) {
		ret = pmic_clrsetbits(dev,
				      init_current[i].reg,
				      init_current[i].mask,
				      init_current[i].val);
		if (ret < 0) {
			printf("%s: i2c set reg 0x%x failed, ret=%d\n",
			       __func__, init_current[i].reg, ret);
		}
	}

	printf("PMIC:  RK%x ", show_variant);

	if (on_source && off_source)
		printf("(on=0x%02x, off=0x%02x)",
		       pmic_reg_read(dev, on_source),
		       pmic_reg_read(dev, off_source));
	printf("\n");

	ret = rk8xx_irq_chip_init(dev);
	if (ret) {
		printf("IRQ chip initial failed\n");
		return ret;
	}

	return 0;
}

static struct dm_pmic_ops rk8xx_ops = {
	.reg_count = rk8xx_reg_count,
	.read = rk8xx_read,
	.write = rk8xx_write,
	.shutdown = rk8xx_shutdown,
};

static const struct udevice_id rk8xx_ids[] = {
	{ .compatible = "rockchip,rk805" },
	{ .compatible = "rockchip,rk808" },
	{ .compatible = "rockchip,rk809" },
	{ .compatible = "rockchip,rk816" },
	{ .compatible = "rockchip,rk817" },
	{ .compatible = "rockchip,rk818" },
	{ }
};

U_BOOT_DRIVER(pmic_rk8xx) = {
	.name = "rk8xx pmic",
	.id = UCLASS_PMIC,
	.of_match = rk8xx_ids,
#if CONFIG_IS_ENABLED(PMIC_CHILDREN)
	.bind = rk8xx_bind,
#endif
	.ofdata_to_platdata = rk8xx_ofdata_to_platdata,
	.priv_auto_alloc_size = sizeof(struct rk8xx_priv),
	.probe = rk8xx_probe,
	.ops = &rk8xx_ops,
};
