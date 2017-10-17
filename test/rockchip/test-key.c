/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <asm/io.h>
#include <adc.h>
#include <common.h>
#include <dm.h>
#include <errno.h>
#include <fdtdec.h>
#include <malloc.h>
#include <irq-generic.h>
#include <irq-platform.h>
#include <key.h>
#include "test-rockchip.h"

enum {
	INVAL_KEY = 0,
	ADC_KEY,
	GPIO_KEY,
	PMIC_KEY,
};

struct adc_key {
	u8 channel;
	int value;
	int microvolt;
	int margin;
	int vref;
};

struct gpio_key {
	int irq;
};

struct key_info {
	const char *name;
	int type;
	struct adc_key adc;
	struct gpio_key gpio;
};

#define ADC_MARGIN		30
#define PMIC_PWRKEY_CNT		1

static int g_key_count;

static void gpio_irq_handler(int irq, void *data)
{
	struct key_info *key = data;

	printf("gpio_irq_handler: irq=%d, key name=%s\n", irq, key->name);
}

static struct key_info *parse_dt_adc_key_node(const void *blob,
					      int adc_key_node,
					      struct key_info *keys)
{
	struct key_info *key = keys;
	u32 adc_channels[2];
	int node, vref, err;

	/* Get vref */
	vref = fdtdec_get_int(blob, adc_key_node,
			      "keyup-threshold-microvolt", -1);
	if (vref < 0) {
		printf("failed read 'keyup-threshold-microvolt', ret=%d\n", vref);
		return NULL;
	}

	/* Get io channel */
	err = fdtdec_get_int_array(blob, adc_key_node, "io-channels",
				   adc_channels, 2);
	if (err) {
		printf("failed read 'io-channels' of %s key, ret=%d\n", key->name, err);
		return NULL;
	}

	/* Parse every adc key data */
	for (node = fdt_first_subnode(blob, adc_key_node);
	     node >= 0;
	     node = fdt_next_subnode(blob, node), key++) {
		key->name = fdt_getprop(blob, node, "label", NULL);
		key->type = ADC_KEY;
		key->adc.vref = vref;
		key->adc.margin = ADC_MARGIN;
		key->adc.channel = adc_channels[1];
		key->adc.microvolt = fdtdec_get_int(blob, node,
				      "press-threshold-microvolt", -1);
		if (key->adc.microvolt < 0) {
			printf("failed read 'press-threshold-microvolt' of %s key, ret=%d\n",
			       key->name, key->adc.microvolt);
			return NULL;
		}
		/* Convert microvolt to adc value */
		key->adc.value = key->adc.microvolt / (key->adc.vref / 1024);
	}

	return key;
}

static struct key_info *parse_dt_rockchip_key_node(const void *blob,
						   int rockchip_key_node,
						   struct key_info *keys)
{
	struct key_info *key = keys;
	u32 gpios[2], adc_channels[2];
	int node, err, adcval, irq;

	/* Get io channel */
	err = fdtdec_get_int_array(blob, rockchip_key_node, "io-channels",
				   adc_channels, 2);
	if (err) {
		printf("failed read 'io-channels' of %s key, ret=%d\n", key->name, err);
		return NULL;
	}

	/* Parse every adc/gpio key data */
	for (node = fdt_first_subnode(blob, rockchip_key_node);
	     node >= 0;
	     node = fdt_next_subnode(blob, node), key++) {
		adcval = fdtdec_get_int(blob, node,
					"rockchip,adc_value", -1);
		/* This is a adc key */
		if (adcval >= 0) {
			key->name = fdt_getprop(blob, node, "label", NULL);
			key->type = ADC_KEY;
			key->adc.value = adcval;
			key->adc.margin = ADC_MARGIN;
			key->adc.channel = adc_channels[1];
		/* This is a gpio key */
		} else {
			key->name = fdt_getprop(blob, node, "label", NULL);
			key->type = GPIO_KEY;
			err = fdtdec_get_int_array(blob, node, "gpios", gpios, 2);
			if (err) {
				printf("failed read 'gpios' of %s key, ret=%d\n", key->name, err);
				return NULL;
			}
			irq = phandle_gpio_to_irq(gpios[0], gpios[1]);
			key->gpio.irq = irq;
			irq_install_handler(irq, gpio_irq_handler, key);
			irq_handler_enable(irq);
			irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
		}
	}

	return key;
}

static struct key_info *parse_dt_gpio_key_node(const void *blob,
					       int gpio_key_node,
					       struct key_info *keys)
{
	struct key_info *key = keys;
	u32 gpios[2];
	int node, irq, err;

	for (node = fdt_first_subnode(blob, gpio_key_node);
	     node >= 0;
	     node = fdt_next_subnode(blob, node), key++) {
		key->name = fdt_getprop(blob, node, "label", NULL);
		key->type = GPIO_KEY;
		err = fdtdec_get_int_array(blob, node, "gpios", gpios, 2);
		if (err) {
			printf("failed read 'gpios' of %s key, ret=%d\n", key->name, err);
			return NULL;
		}
		irq = phandle_gpio_to_irq(gpios[0], gpios[1]);
		key->gpio.irq = irq;
		irq_install_handler(irq, gpio_irq_handler, key);
		irq_handler_enable(irq);
		irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
	}

	return key;
}

static struct key_info *keys_init(void)
{
	const char *key_name = "pmic-power";
	const void *blob = gd->fdt_blob;
	struct key_info *key, *keys;
	struct udevice *dev;
	int adc_key_node, rockchip_key_node, gpio_key_node, i;
	int adc_key_compat = 0, rockchip_key_compat = 0, gpio_key_compat = 0;
	int count = 0;
	const char *label[4] = { "INVAL", "ADC", "GPIO", "PMIC", };
	/*
	 * "rockchip,key": rockchip inner version;
	 * "adc-keys": upsteam version;
	 */
	adc_key_node = fdt_node_offset_by_compatible(blob, 0, "adc-keys");
	if (adc_key_node >= 0) {
		if (!fdtdec_get_is_enabled(blob, adc_key_node)) {
			printf("'adc-keys' node is disabled\n");
		} else {
			adc_key_compat = 1;
			count += fdtdec_get_child_count(blob, adc_key_node);
			printf("find 'adc-keys', board total %d keys\n", count);
		}
	}

	rockchip_key_node = fdt_node_offset_by_compatible(blob, 0, "rockchip,key");
	if (rockchip_key_node >= 0) {
		if (!fdtdec_get_is_enabled(blob, rockchip_key_node)) {
			printf("'rockchip,key' node is disabled\n");
		} else {
			rockchip_key_compat = 1;
			count += fdtdec_get_child_count(blob, rockchip_key_node);
			printf("find 'rockchip,key', board total %d keys\n", count);
		}
	}

	gpio_key_node = fdt_node_offset_by_compatible(blob, 0, "gpio-keys");
	if (gpio_key_node >= 0) {
		if (!fdtdec_get_is_enabled(blob, gpio_key_node)) {
			printf("'gpio-keys' node is disabled\n");
		} else {
			gpio_key_compat = 1;
			count += fdtdec_get_child_count(blob, gpio_key_node);
			printf("find 'gpio-key', board total %d keys\n", count);
		}
	}

	/* reserve more for pmic pwrkey or gpio pwrkey */
	g_key_count = count + PMIC_PWRKEY_CNT;
	keys = calloc(g_key_count, sizeof(*key));
	if (!keys) {
		printf("calloc for key failed\n");
		return NULL;
	}

	key = keys;

	/* Parse adc_key_compat node */
	if (adc_key_compat) {
		key = parse_dt_adc_key_node(blob, adc_key_node, key);
		if (!key) {
			printf("parse_dt_adc_key_node failed\n");
			goto out;
		}
	}
	/* Parse rockchip_key_compat node */
	if (rockchip_key_compat) {
		key = parse_dt_rockchip_key_node(blob, rockchip_key_node, key);
		if (!key) {
			printf("parse_dt_rockchip_key_node failed\n");
			goto out;
		}
	}
	/* Parse gpio_key_compat node */
	if (gpio_key_compat) {
		key = parse_dt_gpio_key_node(blob, gpio_key_node, key);
		if (!key) {
			printf("parse_dt_gpio_key_node failed\n");
			goto out;
		}
	}

	/* Parse PMIC pwrkey */
	if (uclass_get_device_by_name(UCLASS_KEY, "pwrkey", &dev)) {
		/* PMIC pwrkey not included */
		g_key_count -= PMIC_PWRKEY_CNT;
		printf("PMIC pwrkey not found, and will not be tested\n");
	} else {
		key->name = key_name;
		key->type = PMIC_KEY;
		printf("find 'pmic-power', board total %d keys\n", g_key_count);
	}

	printf("Support %d keys are:\n", g_key_count);
	for (i = 0; i < g_key_count; i++) {
		printf("\tkey-%d: name=%s, type=%s, "
		       "[ADC]: channel=%d, vref=%d, "
		       "microvolt=%d, value=%d, margin=%d "
		       "[GPIO]: IRQ=%d:\n",
		       i, keys[i].name, label[keys[i].type],
		       keys[i].adc.channel, keys[i].adc.vref,
		       keys[i].adc.microvolt, keys[i].adc.value,
		       keys[i].adc.margin, keys[i].gpio.irq);
	}

	return keys;

out:
	free(keys);

	return NULL;
}

static int key_test(struct key_info *keys)
{
	struct udevice *dev = NULL;
	struct key_info *key;
	unsigned int adcval;
	int adc_h, adc_l;
	int err, i;
	ulong start;

	if (g_key_count == 0) {
		printf("Find total 0 keys, finish test\n");
		goto out;
	}

	printf("\nYou have 30s to test keys, press or release them, start!\n");

	start = get_timer(0);
	while (get_timer(start) <= 30000) {
		mdelay(100);
		for (i = 0, key = keys; i < g_key_count; i++, key++) {
			if (key->type == ADC_KEY) {
				err = adc_channel_single_shot("saradc",
						key->adc.channel, &adcval);
				if (err) {
					printf("\t%s: read saradc value failed\n", key->name);
				} else {
					adc_h = key->adc.value + key->adc.margin;
					if (key->adc.value > key->adc.margin)
						adc_l = key->adc.value - key->adc.margin;
					else
						adc_l = key->adc.value;

					if ((adcval <= adc_h) && (adcval >= adc_l))
						printf("\t%s: pressed down\n", key->name);
				}
			} else if (key->type == GPIO_KEY) {
				/* it is a irq, so nothing to do */
			} else if (key->type == PMIC_KEY) {
				if (!dev) {
					err = uclass_get_device_by_name(UCLASS_KEY, "pwrkey", &dev);
					if (err) {
						printf("get %s key failed\n", key->name);
						goto out;
					}
				}
				if (key_read(dev) == KEY_PRESS_DOWN)
					printf("\t%s: pressed down\n", key->name);
			} else {
				printf("%s: Unknown key type!\n", key->name);
			}
		}
	}

	for (i = 0, key = keys; i < g_key_count; i++, key++) {
		if (key->type == GPIO_KEY) {
			printf("release irq of %s key\n", key->name);
			irq_free_handler(key->gpio.irq);
		}
	}

	return 0;

out:
	free(keys);

	return -EINVAL;
}

int board_key_test(int argc, char * const argv[])
{
	struct key_info *keys;

	keys = keys_init();
	if (!keys) {
		printf("%s: keys init failed\n", __func__);
		return -EINVAL;
	}

	return key_test(keys);
}
