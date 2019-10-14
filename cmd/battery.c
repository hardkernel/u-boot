/*
 *  (C) Copyright 2019 Hardkernel Co., Ltd
 *
 *  SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <dm.h>
#include <power/fuel_gauge.h>

static int get_battery_info(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int ret, battery;
	struct udevice *fg;

	if (argc != 1)
		return CMD_RET_USAGE;

	ret = uclass_get_device(UCLASS_FG, 0, &fg);
	if (ret) {
		if (ret == -ENODEV)
			debug("Can't find FG\n");
		else
			debug("Get UCLASS FG failed: %d\n", ret);
		return ret;
	}

	if (argc == 1) {
		battery = fuel_gauge_get_voltage(fg);
		env_set_ulong("bat_voltage", battery);
		debug("Battery voltage %d\n", battery);
	}

	return 0;

}

U_BOOT_CMD(
	battery, 2, 0, get_battery_info,
	"Battery voltage read",
	""
);
