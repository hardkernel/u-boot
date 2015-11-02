/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * Watchdog related routine defines
 */

#ifndef _BOOT_ROM_WATCHDOG_H
#define _BOOT_ROM_WATCHDOG_H

//#include "common.h"

void watchdog_init(uint32_t msec);
void watchdog_reset(void);
void reset_system(void);
void watchdog_disable(void);

/* uboot reset interface */
void reset_cpu(unsigned long flag);

#endif /* _BOOT_ROM_WATCHDOG_H */
