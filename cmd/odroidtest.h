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
#include <odroidgo2_status.h>
#include <rockchip_display_cmds.h>

#define NUMGPIOKEYS	18

struct key_arrays {
	const char * name;
	u32 code;
	u32 x;
	u32 y;
	u32 chk; /* 0:red, 1:blue */
};

struct key_arrays gpiokeys[NUMGPIOKEYS] = {
	{"[sw1]", BTN_DPAD_UP, 96, 7, 0},
	{"[sw2]", BTN_DPAD_DOWN, 96, 11, 0},
	{"[sw3]", BTN_DPAD_LEFT, 48, 9, 0},
	{"[sw4]", BTN_DPAD_RIGHT, 144, 9, 0},
	{"[sw5]", BTN_EAST, 384, 9, 0},
	{"[sw6]", BTN_SOUTH, 336, 11, 0},
	{"[sw7]", BTN_WEST, 288, 9, 0},
	{"[sw8]", BTN_NORTH, 336, 7, 0},
	{"[sw9]", BTN_TRIGGER_HAPPY1, 52, 15, 0},
	{"[sw10]", BTN_TRIGGER_HAPPY2, 96, 15, 0},
	{"[sw11]", BTN_TRIGGER_HAPPY3, 190, 15, 0},
	{"[sw12]", BTN_TRIGGER_HAPPY4, 240, 15, 0},
	{"[sw13]", BTN_TRIGGER_HAPPY5, 334, 15, 0},
	{"[sw14]", BTN_TRIGGER_HAPPY6, 384, 15, 0},
	{"[sw15]", BTN_TL, 48, 5, 0},
	{"[sw16]", BTN_TR, 384, 5, 0},
	{"[sw20]", BTN_TL2, 48, 3, 0},
	{"[sw21]", BTN_TR2, 384, 3, 0},
};

struct key_arrays adckeys[4] = {
	{"[LEFT]", 0, 90, 9, 0},
	{"[RIGHT]", 0, 340, 9, 0},
	{"[UP]", 0, 220, 4, 0},
	{"[DOWN]", 0, 218, 14, 0},
};

#endif /* _CMD_ODROIDTEST_ */
