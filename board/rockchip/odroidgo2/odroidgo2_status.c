/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <rockchip_display_cmds.h>
#include "odroidgo2_status.h"

static const char *st_logo_modes[] = {
	"st_logo_hardkernel",
	"st_logo_boot",
	"st_logo_lowbatt",
	"st_logo_recovery",
	"st_logo_err",
	"st_logo_nosdcard",
};

static const char *logo_bmp_names[] = {
	"logo.bmp",
	"logo_boot.bmp",
	"low_battery.bmp",
	"recovery.bmp",
	"system_error.bmp",
	"no_sdcard.bmp",
};

int odroid_display_status(int logo_mode, int logo_storage, const char *str)
{
	unsigned long bmp_mem, bmp_copy;
	char cmd[128];

	if (lcd_init()) {
		printf("[%s] lcd init fail!\n", __func__);
		return -1;
	}

	/* draw logo bmp */
	bmp_mem = lcd_get_mem();
	bmp_copy = bmp_mem + LCD_LOGO_SIZE;

	switch (logo_storage) {
	case LOGO_STORAGE_SPIFLASH:
		sprintf(cmd, "rksfc read %p %s %s", (void *)bmp_copy,
			env_get(st_logo_modes[logo_mode]),
			env_get("sz_logo"));
		run_command(cmd, 0);

		sprintf(cmd, "unzip %p %p", (void *)bmp_copy, (void *)bmp_mem);
		run_command(cmd, 0);
		break;
	case LOGO_STORAGE_SDCARD:
		sprintf(cmd, "fatload mmc 1:1 %p %s", (void *)bmp_mem,
			logo_bmp_names[logo_mode]);
		run_command(cmd, 0);
		break;
	default:
		break;
	}

	if (show_bmp(bmp_mem)) {
		printf("[%s] show_bmp Fail!\n", __func__);
		return -1;
	}

	/* draw text */
	if (str) {
		lcd_setfg(255, 255, 0);
		lcd_printf(0, 18, 1, "%s", str);
	}

	return 0;
}

void odroid_wait_pwrkey(void)
{
	/* check power key and ctrl+c */
	while (1) {
		/* TODO */
	}
}
