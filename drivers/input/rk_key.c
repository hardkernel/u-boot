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

static int rk_keys_ofdata_to_platdata(struct udevice *dev)
{
	struct input_key *key;
	u32 adc_channels[2], gpios[2], adcval;
	int irq, ret;
	ofnode node;

	/* Get IO channel */
	if (dev_read_u32_array(dev, "io-channels", adc_channels, 2)) {
		printf("%s: failed to read 'io-channels'\n", __func__);
		return -EINVAL;
	}

	dev_for_each_subnode(node, dev) {
		key = calloc(1, sizeof(struct input_key));
		if (!key)
			return -ENOMEM;

		/* This is an ACD key */
		if (!ofnode_read_u32(node, "rockchip,adc_value", &adcval)) {
			key->parent = dev;
			key->name = ofnode_read_string(node, "label");
			key->type = ADC_KEY;
			key->adcval = adcval;
			key->channel = adc_channels[1];
			if (ofnode_read_u32(node, "linux,code", &key->code)) {
				printf("%s: failed to read 'linux,code'\n",
				       key->name);
				free(key);
				continue;
			}
			key_add(key);
		/* This is a GPIO key */
		} else {
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
				ret = ofnode_read_u32_array(node, "gpios",
							    gpios, 2);
				if (ret) {
					printf("%s: failed to read 'gpios', ret=%d\n",
					       key->name, ret);
					free(key);
					continue;
				}

				/* Request irq */
				irq = phandle_gpio_to_irq(gpios[0], gpios[1]);
				if (irq < 0) {
					printf("%s: failed to request irq, ret=%d\n",
					       __func__, irq);
					free(key);
					continue;
				}
				key->irq = irq;
				key_add(key);
				irq_install_handler(irq, gpio_irq_handler, key);
				irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
				irq_handler_enable(irq);
			} else {
				ret = gpio_request_by_name_nodev(node, "gpios",
						0, &key->gpio, GPIOD_IS_IN);
				if (ret) {
					printf("%s: failed to request gpio, ret=%d\n",
					       key->name, ret);
					free(key);
					continue;
				}
				key_add(key);
			}
		}

		debug("%s: name=%s: code=%d, adcval=%d, channel=%d, type=%d\n",
		      __func__, key->name, key->code, key->adcval,
		      key->channel, key->type);
	}

	return 0;
}

static const struct dm_key_ops key_ops = {
	.name = "rk-keys",
};

static const struct udevice_id rk_keys_ids[] = {
	{ .compatible = "rockchip,key" },
	{ },
};

U_BOOT_DRIVER(rk_keys) = {
	.name   = "rk-keys",
	.id     = UCLASS_KEY,
	.ops	= &key_ops,
	.of_match = rk_keys_ids,
	.ofdata_to_platdata = rk_keys_ofdata_to_platdata,
};
