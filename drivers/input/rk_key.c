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

#define ADC_MARGIN		30
#define MAX_KEY_NR		10

struct rk_key_priv {
	u32 key_nr;
};

enum {
	INVAL_KEY = 0,
	ADC_KEY,
	GPIO_KEY,
};

static void gpio_irq_handler(int irq, void *data)
{
	struct udevice *dev = data;
	struct rk_key_priv *priv = dev_get_priv(dev);
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

static int rk_keys_ofdata_to_platdata(struct udevice *dev)
{
	struct rk_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	u32 adc_channels[2], gpios[2], adcval, i = 0;
	ofnode node;
	int irq;

	/* Get IO channel */
	if (dev_read_u32_array(dev, "io-channels", adc_channels, 2)) {
		printf("%s: failed to read 'io-channels'\n", __func__);
		return -EINVAL;
	}

	dev_for_each_subnode(node, dev) {
		/* This is an ACD key */
		if (!ofnode_read_u32(node, "rockchip,adc_value", &adcval)) {
			key[i].name = ofnode_read_string(node, "label");
			key[i].flag = ADC_KEY;
			key[i].margin = ADC_MARGIN;
			key[i].value = adcval;
			key[i].channel = adc_channels[1];
			if (ofnode_read_u32(node, "linux,code", &key[i].code)) {
				printf("%s: failed to read 'linux,code'\n",
				       key[i].name);
				return -EINVAL;
			}
		/* This is a GPIO key */
		} else {
			key[i].name = ofnode_read_string(node, "label");
			key[i].flag = GPIO_KEY;
			if (ofnode_read_u32_array(node, "gpios", gpios, 2)) {
				printf("%s: failed to read 'gpios'\n",
				       key[i].name);
				return -EINVAL;
			}
			if (ofnode_read_u32(node, "linux,code", &key[i].code)) {
				printf("%s: failed read 'linux,code'\n",
				       key[i].name);
				return -EINVAL;
			}

			/* Request irq */
			irq = phandle_gpio_to_irq(gpios[0], gpios[1]);
			if (irq < 0) {
				printf("%s: failed to request irq, ret=%d\n",
				       __func__, irq);
				return irq;
			}
			key[i].irq = irq;
			irq_install_handler(irq, gpio_irq_handler, dev);
			irq_handler_enable(irq);
			irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
		}

		debug("%s: name=%s: code=%d, val=%d, channel=%d, flag=%d, margin=%d\n",
		      __func__, key[i].name, key[i].code, key[i].value,
		      key[i].channel, key[i].flag, key[i].margin);

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

static int rk_keys_read(struct udevice *dev, int code)
{
	struct rk_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	int report = KEY_NOT_EXIST;
	int max, min, i = 0;
	unsigned int adcval;

	for (i = 0; i < priv->key_nr; i++) {
		if (key[i].code != code)
			continue;

		if (key[i].flag == ADC_KEY) {
			if (adc_channel_single_shot("saradc",
						    key[i].channel, &adcval)) {
				printf("%s: failed to read saradc\n",
				       key[i].name);
			} else {
				report = key_parse_adc_event(key[i], adcval);
			}
		} else {
			report = key_parse_gpio_event(key[i]);
		}
		break;
	}

	return report;
}

static const struct dm_key_ops key_ops = {
	.name = "rk-keys",
	.read = rk_keys_read,
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
	.platdata_auto_alloc_size = sizeof(struct input_key) * MAX_KEY_NR,
	.priv_auto_alloc_size = sizeof(struct rk_key_priv),
};
