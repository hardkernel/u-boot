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

#define NUMGPIOKEYS	16

struct key_arrays {
	const char * name;
	u32 code;
	u32 x;
	u32 y;
	u32 chk; /* 0:red, 1:blue */
};

struct key_arrays gpiokeys[NUMGPIOKEYS] = {
	{"sw1", BTN_DPAD_UP, 50, 7, 0},
	{"sw2", BTN_DPAD_DOWN, 50, 11, 0},
	{"sw3", BTN_DPAD_LEFT, 10, 9, 0},
	{"sw4", BTN_DPAD_RIGHT, 90, 9, 0},
	{"sw5", BTN_EAST, 320, 9, 0},
	{"sw6", BTN_SOUTH, 280, 11, 0},
	{"sw7", BTN_WEST, 240, 9, 0},
	{"sw8", BTN_NORTH, 280, 7, 0},
	{"sw9", BTN_TRIGGER_HAPPY1, 10, 15, 0},
	{"sw10", BTN_TRIGGER_HAPPY2, 50, 15, 0},
	{"sw11", BTN_TRIGGER_HAPPY3, 140, 15, 0},
	{"sw12", BTN_TRIGGER_HAPPY4, 180, 15, 0},
	{"sw13", BTN_TRIGGER_HAPPY5, 270, 15, 0},
	{"sw14", BTN_TRIGGER_HAPPY6, 320, 15, 0},
	{"sw15", BTN_TL, 10, 3, 0},
	{"sw16", BTN_TR, 320, 3, 0},
};

struct key_arrays adckeys[4] = {
	{"LEFT", 0, 90, 10, 0},
	{"RIGHT", 0, 320, 10, 0},
	{"UP", 0, 215, 5, 0},
	{"DOWN", 0, 210, 15, 0},
};

#endif /* _CMD_ODROIDTEST_ */
