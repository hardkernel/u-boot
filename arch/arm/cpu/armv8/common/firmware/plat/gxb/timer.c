/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * Timer related routine
 */

#include <io.h>
#include <stdio.h>
#include <asm/arch/romboot.h>
#include <asm/arch/timer.h>

#define P_EE_TIMER_E		P_ISA_TIMERE

uint32_t time_start = 0;
uint32_t time_end = 0;

uint32_t get_time(void)
{
	return readl(P_EE_TIMER_E);
}

void udelay(unsigned int us)
{
	uint32_t t0 = get_time();

	while (get_time() - t0 <= us)
		;
}

void timer_start(void)
{
	time_start = get_time();
}

void timer_end(const char * name)
{
	time_end = get_time();
	printf("%s Time: %d us\n", name, (time_end - time_start));
}