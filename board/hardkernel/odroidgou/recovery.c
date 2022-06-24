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
#include <asm-generic/gpio.h>
#include <../odroid-common/odroid-common.h>

#include "recovery.h"

int boot_device(void)
{
	int dev = get_boot_device();

	if (dev == BOOT_DEVICE_EMMC)
		return 0;
	else if (dev == BOOT_DEVICE_SD)
		return 1;

	return -1;
}

int check_hotkey(void)
{
	int left1,left2,right1,right2;
	int boot_mode = 0;
	
	gpio_request(KEY_SHOULDER_LEFT1, "left1");
	gpio_request(KEY_SHOULDER_LEFT2, "left2");
	gpio_request(KEY_SHOULDER_RIGHT1, "right1");
	gpio_request(KEY_SHOULDER_RIGHT2, "right2");

	gpio_direction_input(KEY_SHOULDER_LEFT1);
	gpio_direction_input(KEY_SHOULDER_LEFT2);
	gpio_direction_input(KEY_SHOULDER_RIGHT1);
	gpio_direction_input(KEY_SHOULDER_RIGHT2);
	
	//key active low
	left1 = !gpio_get_value(KEY_SHOULDER_LEFT1);
	left2 = !gpio_get_value(KEY_SHOULDER_LEFT2);
	right1 = !gpio_get_value(KEY_SHOULDER_RIGHT1);
	right2 = !gpio_get_value(KEY_SHOULDER_RIGHT2);

	if (left1 && right1) {
		boot_mode = BOOTMODE_TEST;
		printf("bootmode : Auto-test mode. \n");
	} else if (left2 && right2) {
		boot_mode = BOOTMODE_RECOVERY;
		printf("bootmode : Recovery mode. \n");
	} else {
		boot_mode = BOOTMODE_NORMAL;
		printf("bootmode : Nomal boot. \n");
	}
	return boot_mode;
}


int board_check_recovery(void)
{
	int dev = boot_device();
	int boot_mode = 0;

	if(dev) {
		if (board_check_recovery_image() == 0) {
			run_command("mmc dev 0", 0);
			setenv("bootmode", "recovery");
			printf("bootmode : uSD image is recovery_image \n");
			goto recovery;
		}
	}
	boot_mode = check_hotkey();
	
	if (boot_mode != BOOTMODE_NORMAL) {
		if (board_check_odroidbios(dev) == 0) {
			/* TODO: WHY?
			 * eMMC must be initiated once, otherwise SPI flash memory cannot be
			 * accessible in the Linux kernel.
			 */
			run_command("mmc dev 0", 0);
		} else return -1;
	}
	
	switch (boot_mode) {
		case BOOTMODE_RECOVERY :
			setenv("bootmode", "recovery");
		break;
		case BOOTMODE_TEST :
			setenv("bootmode", "test");
		break;
		case BOOTMODE_NORMAL :
		default :
			setenv("bootmode", "normal");
		break;
	}

recovery:
	return 0;
}

int get_bootmode(void)
{
	int ret = 0;
	char *pmode = getenv("bootmode");
	
	if (!strcmp("normal", pmode)) ret = BOOTMODE_NORMAL;
	else if (!strcmp("test", pmode)) ret = BOOTMODE_TEST;
	else if (!strcmp("recovery", pmode)) ret = BOOTMODE_RECOVERY;
	else ret = BOOTMODE_NORMAL;
		
	return ret;
}

