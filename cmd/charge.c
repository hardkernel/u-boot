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
	int ret;
	struct udevice *dev;

	if (argc != 1)
		return CMD_RET_USAGE;

	ret = uclass_get_device(UCLASS_CHARGE_DISPLAY, 0, &dev);
	if (ret) {
		if (ret != -ENODEV) {
			printf("Get UCLASS CHARGE DISPLAY failed: %d\n", ret);
			return ret;
		}

		return 0;
	}

	return charge_display_show(dev);
}

U_BOOT_CMD(
	charge, 1, 0, charge_display,
	"Charge display",
	""
);
