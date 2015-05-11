/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * Timer related routine defines
 */

#ifndef __TIMER_H
#define __TIMER_H

#include <stdint.h>

/**
 * Get the current timestamp from the system timer.
 */
uint32_t get_time(void);

/**
 * Busy-wait.
 *
 * @param us            Number of microseconds to delay.
 */
void udelay(unsigned int us);

/**
 * time counter
 * usage:
 *     timer_start();
 *     func(); //func that you want measure time consumption
 *     timer_end("func"); //will print "func Time: xxxx us"
 */
void timer_start(void);
void timer_end(const char * name);

#endif /* __TIMER_H */
