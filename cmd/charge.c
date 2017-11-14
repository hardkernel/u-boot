/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <dm.h>
#include <power/charge_display.h>

static int charge_display(cmd_tbl_t *cmdtp, int flag, int argc,
			  char *const argv[])
{
	int on_soc, on_voltage, screen_voltage;
	int ret, save[3];
	struct udevice *dev;

	if (argc != 4 && argc != 1)
		return CMD_RET_USAGE;

	ret = uclass_get_device(UCLASS_CHARGE_DISPLAY, 0, &dev);
	if (ret) {
		if (ret != -ENODEV) {
			printf("Get UCLASS CHARGE DISPLAY failed: %d\n", ret);
			return ret;
		}

		return 0;
	}

	if (argc == 4) {
		save[0] = charge_display_get_power_on_soc(dev);
		save[1] = charge_display_get_power_on_voltage(dev);
		save[2] = charge_display_get_screen_on_voltage(dev);

		on_soc = simple_strtoul(argv[1], NULL, 0);
		on_voltage = simple_strtoul(argv[2], NULL, 0);
		screen_voltage = simple_strtoul(argv[3], NULL, 0);
		debug("new: on_soc=%d, on_voltage=%d, screen_voltage=%d\n",
		      on_soc, on_voltage, screen_voltage);

		charge_display_set_power_on_soc(dev, on_soc);
		charge_display_set_power_on_voltage(dev, on_voltage);
		charge_display_set_screen_on_voltage(dev, screen_voltage);

		charge_display_show(dev);

		charge_display_set_power_on_soc(dev, save[0]);
		charge_display_set_power_on_voltage(dev, save[1]);
		charge_display_set_screen_on_voltage(dev, save[2]);

	} else if (argc == 1) {
		charge_display_show(dev);
	} else {
		return CMD_RET_USAGE;
	}

	return 0;
}

U_BOOT_CMD(charge, 4, 0, charge_display,
	   "Charge display",
	   "-charge\n"
	   "-charge <power on soc> <power on voltage> <screen on voltage>"
);
