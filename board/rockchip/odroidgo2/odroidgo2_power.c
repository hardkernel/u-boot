/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <asm/gpio.h>
#include <power/fuel_gauge.h>
#include <odroidgo2_status.h>

#define MIN_VOL_LEVEL	3500	/* 3.5V */

#define DC_DET_GPIO	11	/* GPIO0_B3 */
#define CHG_LED_GPIO	13	/* GPIO0_B5 */

void board_chg_led(void)
{
	gpio_request(CHG_LED_GPIO, "chg_led");
	/* default on */
	gpio_direction_output(CHG_LED_GPIO, 1);
	gpio_free(CHG_LED_GPIO);
}

int odroid_check_dcjack(void)
{
	gpio_request(DC_DET_GPIO, "dc_det_gpio");

	return gpio_get_value(DC_DET_GPIO) ? 0 : -1;
}

int odroid_check_battery(int *battery)
{
	int ret;
	struct udevice *fg;

	ret = uclass_get_device(UCLASS_FG, 0, &fg);
	if (ret) {
		if (ret == -ENODEV)
			debug("Can't find FG\n");
		else
			debug("Get UCLASS FG failed: %d\n", ret);
		return ret;
	}

	*battery = fuel_gauge_get_voltage(fg);

	return *battery < MIN_VOL_LEVEL ? -1 : 0;
}

int board_check_power(void)
{
	int battery = 0;
	char str[32];

	board_chg_led();

	if (odroid_check_battery(&battery) && odroid_check_dcjack()) {
		debug("low battery (%d) without dc jack connected\n", battery);
		sprintf(str, "voltage level : %d.%dV", (battery / 1000), (battery % 1000));
		odroid_display_status(LOGO_MODE_LOW_BATT, LOGO_STORAGE_ANYWHERE, str);
		odroid_wait_pwrkey();
		return -1;
	}

	debug("power condition OK!\n");
	return 0;
}
