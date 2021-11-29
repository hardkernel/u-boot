/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 *  This driver has been modified to support ODROID-N2.
 *      Modified by Joy Cho <joy.cho@hardkernel.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <asm/errno.h>
#include <vsprintf.h>
#include <linux/kernel.h>
#include <../odroid-common/odroid-common.h>
#include "display.h"

static int boot_partition(void)
{
	int dev = get_boot_device();

	if (dev == BOOT_DEVICE_EMMC)
		return 0;
	else if (dev == BOOT_DEVICE_SD)
		return 1;

	return -1;
}

int gou_display_env_init(void)
{
	setenv("display_width", simple_itoa(480));
	setenv("display_height", simple_itoa(854));
	setenv("fb_width", simple_itoa(480));
	setenv("fb_height", simple_itoa(854));

	setenv("bootlogo_addr", getenv("loadaddr")); /* 0x1080000 */

	setenv("fb_addr", "0x3d800000");
	setenv("display_bpp", "32");
	setenv("display_color_index", "32");
	setenv("display_layer", "osd0");
	setenv("display_color_fg", "0xffffff");
	setenv("display_color_bg", "0");
	setenv("outputmode", "panel");
	run_command("osd open; osd clear", 0);
	run_command("vout output ${outputmode}", 0);
	return 0;
}

int gou_bmp_display(unsigned idx)
{
	char str[64];
	int bootdev;

	/* check boot device */
	bootdev = boot_partition();

	setenv("bootlogo_addr", getenv("loadaddr")); /* 0x1080000 */
	switch (idx) {
		case DISP_LOGO:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/logo.bmp", bootdev);
		break;
		case DISP_BATT_0:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/batt_0.bmp", bootdev);
		break;
		case DISP_BATT_1:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/batt_1.bmp", bootdev);
		break;
		case DISP_BATT_2:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/batt_2.bmp", bootdev);
		break;
		case DISP_BATT_3:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/batt_3.bmp", bootdev);
		break;
		case DISP_BATT_FAIL:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/batt_fail.bmp", bootdev);
		break;
		case DISP_BATT_LOW:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/batt_low.bmp", bootdev);
		break;
		case DISP_RECOVERY:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/recovery.bmp", bootdev);
		break;
		case DISP_SYS_ERR:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/sys_err.bmp", bootdev);
		break;
		default:
			sprintf(str, "load mmc %d ${bootlogo_addr} res/logo.bmp", bootdev);
		break;
	}
	run_command(str, 0);
	run_command("bmp display ${bootlogo_addr}", 0);
//	run_command("bmp scale", 0);
	return 0;
}

