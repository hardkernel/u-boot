/*
 * (C) Copyright 2020 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <adc.h>

#define check_range(min,max,val) (val > 0 && val > min && val < max ? 1 : 0)

int do_hwrev(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	unsigned int hwrev_adc;

	if (adc_channel_single_shot("saradc", 0, &hwrev_adc)) {
		printf("board hw rev failed\n");
		return CMD_RET_FAILURE;
	}

	/* GO2 rev 1.1 */
	if (check_range(655, 695, hwrev_adc)) {
		env_set("hwrev", "v11");
		env_set("dtb_name", "rk3326-odroidgo2-linux-v11.dtb");
	}
	/* GO2 rev 1.0 */
	else if (check_range(816, 896, hwrev_adc)) {
		env_set("hwrev", "v10");
		env_set("dtb_name", "rk3326-odroidgo2-linux.dtb");
	}
	/* GO3 rev 0.1 */
	else if (check_range(40, 126, hwrev_adc)) {
		env_set("hwrev", "v10-go3");
		env_set("dtb_name", "rk3326-odroidgo3-linux-v01.dtb");
	}
	/* engineer samples */
	else {
		env_set("hwrev", "v00");
		env_set("dtb_name", "rk3326-odroidgo2-linux.dtb");
	}

	printf("adc0 (hw rev) %d\n", hwrev_adc);

	return CMD_RET_SUCCESS;
}

U_BOOT_CMD(
	hwrev, 1, 1, do_hwrev,
	"check hw revision of OGA",
	""
);
