/*
 * watchdog.c - driver for Amlogic s905 on-chip watchdog
 *
 * Licensed under the GPL-2 or later.
 */
#include <common.h>
#include <watchdog.h>
#include <asm/arch/watchdog.h>

#define WDT_HW_TIMEOUT 60

void hw_watchdog_init(void)
{
  printf("HW WDT Timeout %d Seconds\n", WDT_HW_TIMEOUT);
  watchdog_init(WDT_HW_TIMEOUT * 1000);
}

void hw_watchdog_reset(void)
{
  watchdog_reset();
}
