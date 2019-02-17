/*
 * board/hardkernel/odroid-common/usb.c
 *
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <errno.h>
#include <asm/arch/secure_apb.h>
#include <asm-generic/gpio.h>
#include <asm/arch/gpio.h>
#include <odroid-common.h>

static bool usbhost_init = 0;
static int __usbhost_early_power = 0;

int board_usbhost_early_power(void)
{
	return __usbhost_early_power;
}

int usbhost_early_poweron(void)
{
	__usbhost_early_power = 1;

	run_command("usb start", 0);
	/* TODO: do something here */
	run_command("usb stop", 0);

	__usbhost_early_power = 0;

	return 0;
}

static bool usbhost_requested(void)
{
	return usbhost_init;
}

static int usbhost_gpio_request(void)
{
	int ret;

	/* Already GPIO for USB Host power is allocated */
	if (usbhost_requested())
		return 0;

	/* usb host hub reset */
	ret = gpio_request(CONFIG_USB_HUB_RST_N, CONFIG_USB_HUB_RST_N_NAME);
	if (ret && ret != -EBUSY) {
		debug("gpio: requesting pin %u failed\n", CONFIG_USB_HUB_RST_N);
		return ret;
	}

	/* usb host hub chip enable */
	ret = gpio_request(CONFIG_USB_HUB_CHIP_EN, CONFIG_USB_HUB_CHIP_EN_NAME);
	if (ret && ret != -EBUSY) {
		debug("gpio: requesting pin %u failed\n", CONFIG_USB_HUB_CHIP_EN);
		gpio_free(CONFIG_USB_HUB_RST_N);
		return ret;
	}

	usbhost_init = true;

	return 0;
}

static int usbhost_gpio_free(void)
{
	gpio_free(CONFIG_USB_HUB_CHIP_EN);
	gpio_free(CONFIG_USB_HUB_RST_N);

	return 0;
}

int usbhost_set_power(int on)
{
	if (on) {
		if (usbhost_gpio_request() == 0) {
			gpio_direction_output(CONFIG_USB_HUB_CHIP_EN, 1);
			udelay(100);
			gpio_direction_output(CONFIG_USB_HUB_RST_N, 1);
		}
	} else {
		if (usbhost_requested()) {
			gpio_direction_output(CONFIG_USB_HUB_RST_N, 0);
			gpio_direction_output(CONFIG_USB_HUB_CHIP_EN, 0);
		}

		usbhost_gpio_free();
	}

	return 0;
}
