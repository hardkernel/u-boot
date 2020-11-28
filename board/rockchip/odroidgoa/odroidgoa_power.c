/*
 * (C) Copyright 2020 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <asm/gpio.h>
#include <power/fuel_gauge.h>
#include <odroidgoa_status.h>

#define MIN_VOL_LEVEL	3500	/* 3.5V */

#define PWR_LED_GPIO	18	/* GPIO0_C2 */
#define DC_DET_GPIO	11	/* GPIO0_B3 */
#define CHG_LED_GPIO	13	/* GPIO0_B5 */

void board_chg_led(void)
{
	gpio_request(CHG_LED_GPIO, "chg_led");
	/* default off, controlled by charge animation logic */
	gpio_direction_output(CHG_LED_GPIO, 0);
	gpio_free(CHG_LED_GPIO);
}

void board_pwr_led(bool on)
{
	gpio_request(PWR_LED_GPIO, "pwr_led");
	gpio_direction_output(PWR_LED_GPIO, on);
	gpio_free(PWR_LED_GPIO);
}

int odroid_check_dcjack(void)
{
	/* set pwr led on by default */
	board_pwr_led(true);

	gpio_request(DC_DET_GPIO, "dc_det_gpio");
	if (gpio_get_value(DC_DET_GPIO)) {
		debug("dc jack is connected\n");
		return 1;
	} else {
		debug("dc jack is NOT connected\n");
		return 0;
	}
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

	debug("BATTERY %d\n", *battery);

	return *battery < MIN_VOL_LEVEL ? 0 : 1;
}

int board_check_power(void)
{
	int battery = 0;
	int dcpower = 0;
	char str[32];

	board_chg_led();

	dcpower = odroid_check_dcjack();

	if (odroid_check_battery(&battery) || dcpower)
		return 0;

	debug("low battery (%d) without dc jack connected\n", battery);
	sprintf(str, "voltage level : %d.%dV", (battery / 1000), (battery % 1000));
	odroid_display_status(LOGO_MODE_LOW_BATT, LOGO_STORAGE_ANYWHERE, str);
	odroid_wait_pwrkey();

	return -1;
}
