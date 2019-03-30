
/*
 * arch/arm/include/asm/arch-txl/watchdog.h
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

#ifndef _BOOT_ROM_WATCHDOG_H
#define _BOOT_ROM_WATCHDOG_H

#include <asm/arch/secure_apb.h>

//#include "common.h"

void watchdog_init(uint32_t msec);
void watchdog_reset(void);
void reset_system(void);
void watchdog_disable(void);

/* uboot reset interface */
void reset_cpu(unsigned long flag);

#endif /* _BOOT_ROM_WATCHDOG_H */
