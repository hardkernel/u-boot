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

static void gpio_irq_handler(int irq, void *data)
{
	struct input_key *key = data;

	if (key->irq != irq)
		return;

	/* up event */
	if (irq_get_gpio_level(irq)) {
		key->up_t = key_timer(0);
		debug("%s: key down: %llu ms\n", key->name, key->down_t);
	/* down event */
	} else {
		key->down_t = key_timer(0);
		debug("%s: key up: %llu ms\n", key->name, key->up_t);
	}
	/* Must delay */
	mdelay(10);
	irq_revert_irq_type(irq);
}

static int gpio_key_ofdata_to_platdata(struct udevice *dev)
{
	struct input_key *key;
	u32 gpios[2];
	ofnode node;
	int irq, ret;

	dev_for_each_subnode(node, dev) {
		key = calloc(1, sizeof(struct input_key));
		if (!key)
			return -ENOMEM;

		key->parent = dev;
		key->type = GPIO_KEY;
		key->name = ofnode_read_string(node, "label");
		ret = ofnode_read_u32(node, "linux,code", &key->code);
		if (ret) {
			printf("%s: failed read 'linux,code', ret=%d\n",
			       key->name, ret);
			free(key);
			continue;
		}

		/* Only register power key as interrupt */
		if (key->code == KEY_POWER) {
			ret = ofnode_read_u32_array(node, "gpios", gpios, 2);
			if (ret) {
				printf("%s: failed to read 'gpios', ret=%d\n",
				       key->name, ret);
				free(key);
				continue;
			}

			/* Must register as interrupt, be able to wakeup system */
			irq = phandle_gpio_to_irq(gpios[0], gpios[1]);
			if (irq < 0) {
				printf("%s: failed to request irq, ret=%d\n",
				       key->name, irq);
				free(key);
				continue;
			}
			key->irq = irq;
			key_add(key);
			irq_install_handler(irq, gpio_irq_handler, key);
			irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
			irq_handler_enable(irq);
		} else {
			ret = gpio_request_by_name_nodev(node, "gpios", 0,
							 &key->gpio,
							 GPIOD_IS_IN);
			if (ret) {
				printf("%s: failed to request gpio, ret=%d\n",
				       key->name, ret);
			}

			key_add(key);
		}

		debug("%s: name=%s: code=%d\n", __func__, key->name, key->code);
	}

	return 0;
}

static const struct dm_key_ops key_ops = {
	.name = "gpio-keys",
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
};
