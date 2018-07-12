/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <asm/io.h>
#include <common.h>
#include <console.h>
#include <dm.h>
#include <power/pmic.h>
#include <power/regulator.h>
#include "test-rockchip.h"

static void regulator_show_dt(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;
	int uV;

	uc_pdata = dev_get_uclass_platdata(dev);
	uV = regulator_get_value(dev);

	printf("%25s@%15s: ", dev->name, uc_pdata->name);
	printf("%7duV <-> %7duV, set %7duV, %s",
	       uc_pdata->min_uV, uc_pdata->max_uV, uV,
	       (uc_pdata->always_on || uc_pdata->boot_on) ?
	       "enabling" : "disabled");

	printf(" | supsend %7duV, %s",
	       uc_pdata->suspend_uV,
	       uc_pdata->suspend_on ? "enabling" : "disabled");
	if (uc_pdata->init_uV != -ENODATA)
		printf("; init %7duV", uc_pdata->init_uV);

	printf("\n");

}

static void regulator_show_state(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;
	int enable, uV, suspend_enable, suspend_uV;

	uc_pdata = dev_get_uclass_platdata(dev);

	enable = regulator_get_enable(dev);
	uV = regulator_get_value(dev);

	suspend_enable = regulator_get_suspend_enable(dev);
	suspend_uV = regulator_get_suspend_value(dev);

	printf("%25s@%15s: set %7duV, %s | suspend %7duV, %s\n",
	       dev->name, uc_pdata->name, uV,
	       enable ? "enabling" : "disabled", suspend_uV,
	       suspend_enable ? "enabling" : "disabled");
}

static int regulator_confirm_dt(void)
{
	struct udevice *dev;
	struct uclass *uc;
	int ret;

	ret = uclass_get(UCLASS_REGULATOR, &uc);
	if (ret)
		return ret;

	printf("<Board dts config>:\n");
	for (uclass_first_device(UCLASS_REGULATOR, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		regulator_show_dt(dev);
	}

	printf("\n<Board current status>:\n");
	for (uclass_first_device(UCLASS_REGULATOR, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		regulator_show_state(dev);
	}

	printf("\n");

	while (!getc())
		;

	return 0;
}

static int regulator_adjust_voltage(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;
	int i, uV, save_uV, step_uV = 12500;

	uc_pdata = dev_get_uclass_platdata(dev);

	/* only not fix voltage regulator will be tested! */
	if ((uc_pdata->max_uV == uc_pdata->min_uV) ||
	    !regulator_get_enable(dev) || strncmp("DCDC", dev->name, 4))
		return 0;

	/* save for restore after test done */
	save_uV = regulator_get_value(dev);

	for (i = 1; i < 4; i++) {
		uV = regulator_get_value(dev);
		printf("[%s@%s] set: %d uV -> %d uV;  ",
		       dev->name, uc_pdata->name, uV, uV + step_uV * i);
		uV += (step_uV * i);
		regulator_set_value(dev, uV);
		printf("ReadBack: %d uV\n\n", regulator_get_value(dev));
		printf("Confirm '%s' voltage, then hit any key to continue...\n\n",
		       uc_pdata->name);

		while (!getc())
			;
	}

	/* restore voltage */
	regulator_set_value(dev, save_uV);

	return 0;
}

static int regulator_confirm_voltage_accuracy(void)
{
	struct udevice *dev;
	struct uclass *uc;
	int ret;

	ret = uclass_get(UCLASS_REGULATOR, &uc);
	if (ret)
		return ret;

	for (uclass_first_device(UCLASS_REGULATOR, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		regulator_adjust_voltage(dev);
	}

	return 0;
}

int board_regulator_test(int argc, char * const argv[])
{
	printf("----------------------------------------------------\n");
	printf("REGULATOR: status show\n");
	printf("----------------------------------------------------\n\n");
	regulator_confirm_dt();

	printf("----------------------------------------------------\n");
	printf("REGULATOR: voltage accuracy confirm\n");
	printf("----------------------------------------------------\n\n");
	regulator_confirm_voltage_accuracy();

	return 0;
}
