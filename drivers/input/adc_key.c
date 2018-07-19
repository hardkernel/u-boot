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

static int adc_keys_ofdata_to_platdata(struct udevice *dev)
{
	struct input_key *key;
	u32 adc_channels[2], microvolt;
	int vref, ret;
	ofnode node;

	/* Get vref */
	vref = dev_read_u32_default(dev, "keyup-threshold-microvolt", -1);
	if (vref < 0) {
		printf("failed to read 'keyup-threshold-microvolt', ret=%d\n",
		       vref);
		return -EINVAL;
	}

	/* Get IO channel */
	ret = dev_read_u32_array(dev, "io-channels", adc_channels, 2);
	if (ret) {
		printf("failed to read 'io-channels', ret=%d\n", ret);
		return -EINVAL;
	}

	/* Parse every adc key data */
	dev_for_each_subnode(node, dev) {
		key = calloc(1, sizeof(struct input_key));
		if (!key)
			return -ENOMEM;

		key->parent = dev;
		key->type = ADC_KEY;
		key->vref = vref;
		key->channel = adc_channels[1];
		key->name = ofnode_read_string(node, "label");
		ret = ofnode_read_u32(node, "linux,code", &key->code);
		if (ret) {
			printf("%s: failed to read 'linux,code', ret=%d\n",
			       key->name, ret);
			free(key);
			continue;
		}

		ret = ofnode_read_u32(node, "press-threshold-microvolt",
				      &microvolt);
		if (ret) {
			printf("%s: failed to read 'press-threshold-microvolt', ret=%d\n",
			       key->name, ret);
			free(key);
			continue;
		}

		/* Convert microvolt to adc value */
		key->adcval = microvolt / (key->vref / 1024);
		key_add(key);

		debug("%s: name=%s: code=%d, vref=%d, channel=%d, microvolt=%d, adcval=%d\n",
		      __func__, key->name, key->code, key->vref,
		      key->channel, microvolt, key->adcval);
	}

	return 0;
}

static const struct dm_key_ops key_ops = {
	.name = "adc-keys",
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
};
