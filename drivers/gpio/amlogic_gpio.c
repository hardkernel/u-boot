/*
 * Copyright (C) 2015 Amlogic Inc
 * Written by Xing Xu <xing.xu@amlogic.com>
 */
#include <common.h>
#include <dm.h>
#include <asm/gpio.h>
#include <asm/io.h>
#include <asm/errno.h>
#include <aml_gpio.h>
extern int  clear_pinmux(unsigned int pin);
/* set GPIO pin 'gpio' as an input */
static int aml_gpio_direction_input(struct udevice *dev, unsigned offset)
{
	struct meson_bank *plat = dev_get_platdata(dev);
	unsigned int reg = plat->regs[REG_DIR].reg;
	unsigned int bit = plat->regs[REG_DIR].bit + offset;
	regmap_update_bits(reg,BIT(bit),BIT(bit));
	return 0;
}

/* set GPIO pin 'gpio' as an output, with polarity 'value' */
static int aml_gpio_direction_output(struct udevice *dev, unsigned offset,
				       int value)
{
	struct meson_bank *plat = dev_get_platdata(dev);
	unsigned long reg = plat->regs[REG_OUT].reg;
	unsigned int bit = plat->regs[REG_OUT].bit + offset;
	regmap_update_bits(reg,BIT(bit),value ? BIT(bit) : 0);
	reg = plat->regs[REG_DIR].reg;
	bit = plat->regs[REG_DIR].bit + offset;
	regmap_update_bits(reg,BIT(bit),0);

	return 0;
}

/* read GPIO IN value of pin 'gpio' */
static int aml_gpio_get_value(struct udevice *dev, unsigned offset)
{
	struct meson_bank *plat = dev_get_platdata(dev);
	unsigned long reg = plat->regs[REG_IN].reg;
	unsigned int bit = plat->regs[REG_IN].bit + offset;
	unsigned int val;
	val = readl(reg);

	return !!(val & BIT(bit));
}

/* write GPIO OUT value to pin 'gpio' */
static int aml_gpio_set_value(struct udevice *dev, unsigned offset,
				 int value)
{
	struct meson_bank *plat = dev_get_platdata(dev);
	unsigned int reg = plat->regs[REG_OUT].reg;
	unsigned int bit = plat->regs[REG_OUT].bit + offset;
	regmap_update_bits(reg,BIT(bit),value ? BIT(bit) : 0);

	return 0;
}

static int aml_gpio_get_function(struct udevice *dev, unsigned offset)
{

	struct meson_bank *plat = dev_get_platdata(dev);
	unsigned long reg = plat->regs[REG_DIR].reg;
	unsigned int bit = plat->regs[REG_DIR].bit + offset;
	unsigned int val;
	val = readl(reg);
	bool dir = !!(val * BIT(bit));


	/* GPIOF_FUNC is not implemented yet */
	if (dir)
		return GPIOF_INPUT;
	else
		return GPIOF_OUTPUT;
}
static int aml_gpio_request(struct udevice *dev, unsigned offset, const char *label)
{
	struct meson_bank *plat = dev_get_platdata(dev);
	clear_pinmux(plat->first + offset);
	return 0;
}
static const struct dm_gpio_ops gpio_aml_ops = {
	.request			= aml_gpio_request,
	.direction_input	= aml_gpio_direction_input,
	.direction_output	= aml_gpio_direction_output,
	.get_value		= aml_gpio_get_value,
	.set_value		= aml_gpio_set_value,
	.get_function		= aml_gpio_get_function,
};

static int aml_gpio_probe(struct udevice *dev)
{
	struct meson_bank *plat = dev_get_platdata(dev);
	struct gpio_dev_priv *uc_priv = dev->uclass_priv;

	uc_priv->bank_name = plat->name;
	uc_priv->gpio_base = plat->first;
	uc_priv->gpio_count = plat->last - plat->first +1;

	return 0;
}

U_BOOT_DRIVER(gpio_aml) = {
	.name	= "gpio_aml",
	.id	= UCLASS_GPIO,
	.ops	= &gpio_aml_ops,
	.probe	= aml_gpio_probe,
};

