
/*
 * drivers/display/lcd/lcd_tablet/lcd_tablet.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
*/

#ifndef __AML_LCD_TABLET_H__
#define __AML_LCD_TABLET_H__

//**********************************
//lcd driver version
//**********************************
#define LCD_DRV_TYPE      "tablet"

#define LCD_DRV_VERSION    "20160630"
//**********************************

extern void lcd_tablet_driver_init_pre(void);
extern int lcd_tablet_driver_init(void);
extern void lcd_tablet_driver_disable(void);

#endif
