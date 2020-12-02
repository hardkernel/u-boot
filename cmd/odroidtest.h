/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#ifndef _CMD_ODROIDTEST_H_
#define _CMD_ODROIDTEST_H_

#include <common.h>
#include <dm.h>
#include <console.h>
#include <key.h>
#include <adc.h>
#include <pwm.h>
#include <odroidgoa_status.h>
#include <rockchip_display_cmds.h>
#ifdef CONFIG_DM_CHARGE_DISPLAY
#include <power/charge_display.h>
#endif
#include <power/fuel_gauge.h>
#include <sound.h>

struct key_arrays {
	const char * name;
	u32 code;
	u32 x;
	u32 y;
	u32 chk; /* 0:red, 1:blue */
};

#define NUMGPIOKEYS_GO2		18
#define NUMGPIOKEYS_GO3		20

struct key_arrays *gpiokeys;
struct key_arrays gpiokeys_go3[NUMGPIOKEYS_GO3] = {
	{"[sw1]", BTN_DPAD_UP, 170, 13, 0},
	{"[sw2]", BTN_DPAD_DOWN, 170, 17, 0},
	{"[sw3]", BTN_DPAD_LEFT, 85, 15, 0},
	{"[sw4]", BTN_DPAD_RIGHT, 255, 15, 0},
	{"[sw5]", BTN_EAST, 702, 15, 0},
	{"[sw6]", BTN_SOUTH, 617, 17, 0},
	{"[sw7]", BTN_WEST, 532, 15, 0},
	{"[sw8]", BTN_NORTH, 617, 13, 0},
	{"[sw9]", KEY_VOLUMEUP, 457, 5, 0},
	{"[sw10]", KEY_VOLUMEDOWN, 350, 5, 0},
	{"[sw11]", BTN_TRIGGER_HAPPY3, 85, 25, 0},
	{"[sw12]", BTN_TRIGGER_HAPPY4, 170, 25, 0},
	{"[sw13]", BTN_TRIGGER_HAPPY5, 617, 25, 0},
	{"[sw14]", BTN_TRIGGER_HAPPY6, 702, 25, 0},
	{"[sw15]", BTN_TL, 85, 5, 0},
	{"[sw16]", BTN_TR, 702, 5, 0},
	{"[sw20]", BTN_TR2, 617, 5, 0},
	{"[sw21]", BTN_TL2, 170, 5, 0},
	{"[sw19]", BTN_TRIGGER_HAPPY1, 260, 9, 0},
	{"[sw22]", BTN_TRIGGER_HAPPY2, 532, 9, 0},
};

struct key_arrays gpiokeys_go2[NUMGPIOKEYS_GO2] = {
	{"[sw1]", BTN_DPAD_UP, 96, 7, 0},
	{"[sw2]", BTN_DPAD_DOWN, 96, 11, 0},
	{"[sw3]", BTN_DPAD_LEFT, 48, 9, 0},
	{"[sw4]", BTN_DPAD_RIGHT, 144, 9, 0},
	{"[sw5]", BTN_EAST, 384, 9, 0},
	{"[sw6]", BTN_SOUTH, 336, 11, 0},
	{"[sw7]", BTN_WEST, 288, 9, 0},
	{"[sw8]", BTN_NORTH, 336, 7, 0},
	{"[sw9]", BTN_TRIGGER_HAPPY1, 50, 14, 0},
	{"[sw10]", BTN_TRIGGER_HAPPY2, 96, 14, 0},
	{"[sw11]", BTN_TRIGGER_HAPPY3, 188, 14, 0},
	{"[sw12]", BTN_TRIGGER_HAPPY4, 242, 14, 0},
	{"[sw13]", BTN_TRIGGER_HAPPY5, 332, 14, 0},
	{"[sw14]", BTN_TRIGGER_HAPPY6, 386, 14, 0},
	{"[sw15]", BTN_TL, 48, 5, 0},
	{"[sw16]", BTN_TR, 384, 5, 0},
	{"[sw20]", BTN_TL2, 48, 3, 0},
	{"[sw21]", BTN_TR2, 384, 3, 0},
};

static struct key_arrays *adckeys;
struct key_arrays adckeys_go3[8] = {
	/* LEFT */
	{"[WEST]", 0, 85, 11, 0},
	{"[EAST]", 0, 275, 11, 0},
	{"[NORTH]", 0, 180, 6, 0},
	{"[SOUTH]", 0, 180, 16, 0},
	/* RIGHT */
	{"[WEST]", 0, 500, 11, 0},
	{"[EAST]", 0, 690, 11, 0},
	{"[NORTH]", 0, 595, 6, 0},
	{"[SOUTH]", 0, 595, 16, 0},
};

struct key_arrays adckeys_go2[4] = {
	{"[WEST]", 0, 90, 7, 0},
	{"[EAST]", 0, 340, 7, 0},
	{"[NORTH]", 0, 218, 3, 0},
	{"[SOUTH]", 0, 218, 11, 0},
};
#endif /* _CMD_ODROIDTEST_ */
