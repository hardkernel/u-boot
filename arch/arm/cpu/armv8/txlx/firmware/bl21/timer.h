
/*
 * arch/arm/cpu/armv8/txl/firmware/bl21/timer.h
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

#ifndef __TIMER_H
#define __TIMER_H

/**
 * Get the current timestamp from the system timer.
 */
unsigned int get_time(void);

/**
 * Busy-wait.
 *
 * @param us            Number of microseconds to delay.
 */
void _udelay(unsigned int us);

/**
 * time counter
 * usage:
 *     timer_start();
 *     func(); //func that you want measure time consumption
 *     timer_end("func"); //will print "func Time: xxxx us"
 */
//void timer_start(void);
//void timer_end(const char * name);

#endif /* __TIMER_H */
