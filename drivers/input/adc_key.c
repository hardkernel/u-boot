/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <dm.h>
#include <dm/read.h>
#include <adc.h>
#include <common.h>
#include <console.h>
#include <errno.h>
#include <fdtdec.h>
#include <malloc.h>
#include <key.h>
#include <linux/input.h>

#define ADC_MARGIN		30
#define MAX_KEY_NR		10

struct adc_key_priv {
	u32 key_nr;
};

static int adc_keys_ofdata_to_platdata(struct udevice *dev)
{
	struct adc_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	u32 adc_channels[2], i = 0, microvolt;
	int vref, err;
	ofnode node;

	/* Get vref */
	vref = dev_read_u32_default(dev, "keyup-threshold-microvolt", -1);
	if (vref < 0) {
		printf("failed to read 'keyup-threshold-microvolt', ret=%d\n",
		       vref);
		return -EINVAL;
	}

	/* Get IO channel */
	err = dev_read_u32_array(dev, "io-channels", adc_channels, 2);
	if (err) {
		printf("failed to read 'io-channels' of %s key, ret=%d\n",
		       key->name, err);
		return -EINVAL;
	}

	/* Parse every adc key data */
	dev_for_each_subnode(node, dev) {
		key[i].name = ofnode_read_string(node, "label");
		key[i].vref = vref;
		key[i].margin = ADC_MARGIN;
		key[i].channel = adc_channels[1];
		if (ofnode_read_u32(node, "linux,code", &key[i].code)) {
			printf("%s: failed to read 'linux,code', ret=%d\n",
			       key[i].name, key[i].code);
			return -EINVAL;
		}
		if (ofnode_read_u32(node, "press-threshold-microvolt",
				    &microvolt)) {
			printf("%s: failed read 'press-threshold-microvolt', ret=%d\n",
			       key[i].name, microvolt);
			return -EINVAL;
		}
		/* Convert microvolt to adc value */
		key[i].value = microvolt / (key[i].vref / 1024);

		debug("%s: name=%s: code=%d, vref=%d, margin=%d, channel=%d, val=%d\n",
		      __func__, key[i].name, key[i].code, key[i].vref,
		      key[i].margin, key[i].channel, key[i].value);

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

static int adc_keys_read(struct udevice *dev, int code)
{
	struct adc_key_priv *priv = dev_get_priv(dev);
	struct input_key *key = dev_get_platdata(dev);
	int report = KEY_NOT_EXIST;
	int max, min, i = 0;
	unsigned int adcval;

	for (i = 0; i < priv->key_nr; i++) {
		if (key[i].code != code)
			continue;

		if (adc_channel_single_shot("saradc",
					    key[i].channel, &adcval)) {
			printf("%s: failed to read saradc\n", key[i].name);
		} else {
			/* Get min, max */
			max = key[i].value + key[i].margin;
			if (key[i].value > key[i].margin)
				min = key[i].value - key[i].margin;
			else
				min = key[i].value;

			/* Check */
			if ((adcval <= max) && (adcval >= min)) {
				report = KEY_PRESS_DOWN;
				printf("'%s' key pressed down\n",
				       key[i].name);
			} else {
				report = KEY_PRESS_NONE;
			}
		}
		break;
	}

	return report;
}

static const struct dm_key_ops key_ops = {
	.name = "adc_keys",
	.read = adc_keys_read,
};

static const struct udevice_id adc_keys_ids[] = {
	{ .compatible = "adc-keys" },
	{ },
};

U_BOOT_DRIVER(adc_keys) = {
	.name   = "adc-keys",
	.id     = UCLASS_KEY,
	.ops	= &key_ops,
	.of_match = adc_keys_ids,
	.ofdata_to_platdata = adc_keys_ofdata_to_platdata,
	.platdata_auto_alloc_size = sizeof(struct input_key) * MAX_KEY_NR,
	.priv_auto_alloc_size = sizeof(struct adc_key_priv),
};
