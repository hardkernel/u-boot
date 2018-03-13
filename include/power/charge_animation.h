/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef _CHARGE_ANIMATION_H_
#define _CHARGE_ANIMATION_H_

struct charge_animation_pdata {
	int android_charge;
	int uboot_charge;

	int exit_charge_voltage;
	int exit_charge_level;
	int low_power_voltage;
	int screen_on_voltage;

	int system_suspend;
	int auto_wakeup_interval;
	int auto_wakeup_screen_invert;
	int auto_off_screen_interval;
};

#endif
