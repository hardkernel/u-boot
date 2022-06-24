/*
 * board/hardkernel/odroidgou/recovery.h
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 */

#ifndef _RECOVERY_H_
#define _RECOVERY_H_

#include <asm/arch/gpio.h>

#define KEY_SHOULDER_LEFT1	GPIOEE(GPIOX_14)
#define KEY_SHOULDER_LEFT2	GPIOEE(GPIOX_19)

#define KEY_SHOULDER_RIGHT1	GPIOEE(GPIOX_15)
#define KEY_SHOULDER_RIGHT2	GPIOEE(GPIOX_18)

#define BOOTMODE_NORMAL		0
#define BOOTMODE_TEST		1
#define BOOTMODE_RECOVERY	2

int board_check_recovery(void);
int get_bootmode(void);

#endif

