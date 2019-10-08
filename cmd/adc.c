/*
 * Copyright (c) 2017 Google, Inc
 * Written by Simon Glass <sjg@chromium.org>
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <dm.h>
#include <adc.h>
#include <dm/uclass-internal.h>

int do_adc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct udevice *dev;
	unsigned int val = 0, channel;

	/* default value write */
	env_set_ulong("r_adc", val);

	/* Validate arguments */
	if (argc != 2)
		return CMD_RET_USAGE;

	channel = simple_strtoul(argv[1], NULL, 10);

	/* odroidgo2(rk3326) has 3 adc channel(0,1,2) */
	if (channel > 2) {
		printf("unsupport channel %d, prop r_adc = 0\n", channel);
		return CMD_RET_FAILURE;
	}

	if (!uclass_get_device(UCLASS_ADC, 0, &dev)) {
		if (adc_channel_single_shot("saradc", channel, &val)) {
			printf("%s adc_channel_single_shot fail!\n",
				__func__);
			return CMD_RET_FAILURE;
		}
		/* adc data save to r_adc prop */
		env_set_ulong("r_adc", val);
	}
	else {
		printf("%s : UCLASS_ADC load fail\n", __func__);
		return CMD_RET_FAILURE;
	}
	return 0;
}

U_BOOT_CMD(
	adc, 2, 1, do_adc,
	"saradc channel read",
	" [<read channel>]\t read adc data & save data to r_adc prop."
);
