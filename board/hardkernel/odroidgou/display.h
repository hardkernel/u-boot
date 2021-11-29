/*
 * board/amlogic/g12a_u200_v1/lcd_extern.h
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

#ifndef _DISPLAY_H_
#define _DISPLAY_H_

enum disp_index_e {
	DISP_LOGO = 0,
	DISP_BATT_0,
	DISP_BATT_1,
	DISP_BATT_2,
	DISP_BATT_3,
	DISP_BATT_FAIL,
	DISP_BATT_LOW,
	DISP_RECOVERY,
	DISP_SYS_ERR,
	DISP__MAX,
};

extern int gou_display_env_init(void);
extern int gou_bmp_display(unsigned idx);

#endif

