/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <asm/io.h>
#include <common.h>
#include <common.h>
#include <dm.h>
#include <power/pmic.h>
#include <power/regulator.h>
#include "test-rockchip.h"

static void regulator_show_dt(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;

	uc_pdata = dev_get_uclass_platdata(dev);

	printf("\t%s@%s: \t[", dev->name, uc_pdata->name);
	if (uc_pdata->flags & REGULATOR_FLAG_AUTOSET_UV)
		printf("%d uV", uc_pdata->min_uV);
	else
		printf("%d ~ %d uV", uc_pdata->min_uV, uc_pdata->max_uV);

	printf("; %s]\n", uc_pdata->boot_on ? "enable" : "disabled");
}

static void regulator_show_state(struct udevice *dev)
{
	struct dm_regulator_uclass_platdata *uc_pdata;
	int enable, uV;
	int same = 1;

	uc_pdata = dev_get_uclass_platdata(dev);
	enable = regulator_get_enable(dev);
	uV = regulator_get_value(dev);

	if (uc_pdata->flags & REGULATOR_FLAG_AUTOSET_UV)
		same = (enable == uc_pdata->boot_on) &&
		       (uV == uc_pdata->min_uV);

	printf("\t%s@%s: \t[", dev->name, uc_pdata->name);
	printf("%d uV", uV);
	printf("; %s] <%s>\n", enable ? "enable" : "disabled",
	       same ? "same" : "Not same");
}

static int regulator_confirm_dt(void)
{
	struct udevice *dev;
	struct uclass *uc;
	int ret;

	ret = uclass_get(UCLASS_REGULATOR, &uc);
	if (ret)
		return ret;

	printf("<FDT config>:\n");
	for (uclass_first_device(UCLASS_REGULATOR, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		regulator_show_dt(dev);
	}

	printf("\n\n\n<NOW state>:\n");
	for (uclass_first_device(UCLASS_REGULATOR, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		regulator_show_state(dev);
	}

	printf("\n\n\n");
	printf("1. Please compare <NOW state> and <FDT config>.\n");
	printf("2. Please measure the volatge of all regulators "
	       "and compare with <Now state> voltage.\n\n");
	printf("After above done, you can hit any key to continue test case2...\n\n\n\n");

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
	    !regulator_get_enable(dev))
		return 0;

	/* save for restore after test done */
	save_uV = regulator_get_value(dev);

	for (i = 1; i < 4; i++) {
		uV = regulator_get_value(dev);
		printf("[%s] ", uc_pdata->name);
		printf("Try: %d uV --> %d uV;  ", uV, uV + step_uV * i);
		uV += (step_uV * i);
		regulator_set_value(dev, uV);
		printf("Now: %d uV.\n\n", regulator_get_value(dev));
		printf("Please measure voltage of [%s].\n"
		       "After done, hit any key to continue...\n\n\n\n",
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
	printf("REGULATOR test case 1: regulator fdt config confirm\n");
	printf("----------------------------------------------------\n\n");
	regulator_confirm_dt();

	printf("----------------------------------------------------\n");
	printf("REGULATOR test case 2: regulator voltage accuracy confirm\n");
	printf("----------------------------------------------------\n\n");
	regulator_confirm_voltage_accuracy();

	return 0;
}
