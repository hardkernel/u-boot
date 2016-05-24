
/*
 * arch/arm/include/asm/arch-gxb/reboot.h
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
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#ifndef __REBOOT_H
#define __REBOOT_H

/*
Reboot reason AND corresponding env setting:
0:  Cold boot                 cold_boot
1:  Normal boot               normal
2:  Factory reset             factory_reset
3:  Upgrade system            update
4:  USB Burning               usb_burning
5:  Suspend                   suspend_off
6:  Hibernate                 hibernate
7~10: reserved
11:  Crash dump               crash_dump
12~15: reserved
*/
#define AMLOGIC_COLD_BOOT				0
#define	AMLOGIC_NORMAL_BOOT				1
#define	AMLOGIC_FACTORY_RESET_REBOOT	2
#define	AMLOGIC_UPDATE_REBOOT			3
#define AMLOGIC_USB_BURNING_REBOOT		4
#define AMLOGIC_SUSPEND_REBOOT			5
#define AMLOGIC_HIBERNATE_REBOOT		6
#define	AMLOGIC_CRASH_REBOOT			11
#define AMLOGIC_KERNEL_PANIC			12
#define AMLOGIC_WATCHDOG_REBOOT			13

/*
old version env
0x01010101, normal
0x02020202, factory_reset
0x03030303, update
0x09090909, usb_burning
0x0b0b0b0b, suspend_off
*/

#endif

