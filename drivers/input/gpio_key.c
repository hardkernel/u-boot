/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <dm.h>
#include <adc.h>
#include <common.h>
#include <console.h>
#include <dm.h>
#include <errno.h>
#include <fdtdec.h>
#include <malloc.h>
#include <key.h>
#include <linux/input.h>
#include <errno.h>
#include <dm/read.h>
#include <irq-generic.h>
#include <irq-platform.h>

#define MAX_KEY_NR	10

struct gpio_key_priv {
	u32 key_nr;
};

static void gpio_irq_handler(int irq, void *data)
{
	struct udevice *dev = data;
	struct gpio_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	int i;

	for (i = 0; i < priv->key_nr; i++) {
		if (key[i].irq != irq)
			continue;

		/* up event */
		if (irq_get_gpio_level(irq)) {
			key[i].up_t = key_get_timer(0);
			debug("%s: key down: %llu ms\n",
			      key[i].name, key[i].down_t);
		/* down event */
		} else {
			key[i].down_t = key_get_timer(0);
			debug("%s: key up: %llu ms\n",
			      key[i].name, key[i].up_t);
		}
		/* Must delay */
		mdelay(10);
		irq_revert_irq_type(irq);
	}
}

static int gpio_key_ofdata_to_platdata(struct udevice *dev)
{
	struct gpio_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	u32 gpios[2], i = 0;
	ofnode node;
	int irq;

	dev_for_each_subnode(node, dev) {
		key[i].name = ofnode_read_string(node, "label");
		if (ofnode_read_u32(node, "linux,code", &key[i].code)) {
			printf("failed read 'linux,code' of %s key\n",
			       key[i].name);
			return -EINVAL;
		}
		if (ofnode_read_u32_array(node, "gpios", gpios, 2)) {
			printf("failed to read 'gpios' of %s key\n",
			       key[i].name);
			return -EINVAL;
		}

		/* Must register as interrupt, be able to wakeup system */
		irq = phandle_gpio_to_irq(gpios[0], gpios[1]);
		if (irq < 0) {
			printf("failed to request irq for gpio, ret=%d\n", irq);
			return irq;
		}
		key[i].irq = irq;
		irq_install_handler(irq, gpio_irq_handler, dev);
		irq_handler_enable(irq);
		irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);

		debug("%s: name=%s: code=%d\n",
		      __func__, key[i].name, key[i].code);

		/* Next node */
		i++;
		priv->key_nr = i;
		if (i >= MAX_KEY_NR) {
			printf("Too many keys, Max support: %d\n", MAX_KEY_NR);
			return -EINVAL;
		}
	}

	return 0;
}

static int gpio_key_read(struct udevice *dev, int code)
{
	struct gpio_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	u32 report = KEY_NOT_EXIST;
	int i = 0;

	for (i = 0; i < priv->key_nr; i++) {
		if (key[i].code != code)
			continue;
		report = key_parse_gpio_event(&key[i]);
		break;
	}

	return report;
}

static const struct dm_key_ops key_ops = {
	.name = "gpio-keys",
	.read = gpio_key_read,
};

static const struct udevice_id gpio_key_ids[] = {
	{ .compatible = "gpio-keys" },
	{ },
};

U_BOOT_DRIVER(gpio_keys) = {
	.name   = "gpio-keys",
	.id     = UCLASS_KEY,
	.of_match = gpio_key_ids,
	.ops	= &key_ops,
	.ofdata_to_platdata = gpio_key_ofdata_to_platdata,
	.platdata_auto_alloc_size = sizeof(struct input_key) * MAX_KEY_NR,
	.priv_auto_alloc_size = sizeof(struct gpio_key_priv),
};
