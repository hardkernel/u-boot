
/*
 * arch/arm/cpu/armv8/gxtvbb/firmware/scp_task/suspend.h
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

#ifndef __SCP_SUSPEND_H_
#define __SCP_SUSPEND_H_
/* wake up reason*/
#define	UDEFINED_WAKEUP	0
#define	CHARGING_WAKEUP	1
#define	REMOTE_WAKEUP		2
#define	RTC_WAKEUP			3
#define	BT_WAKEUP			4
#define	WIFI_WAKEUP			5
#define	POWER_KEY_WAKEUP	6
#define	AUTO_WAKEUP			7
#define CEC_WAKEUP		8

struct pwr_op {
	void (*power_off_at_clk81)(void);
	void (*power_on_at_clk81)(void);

	void (*power_off_at_24M)(void);
	void (*power_on_at_24M)(void);

	void (*power_off_at_32k)(void);
	void (*power_on_at_32k)(void);

	void (*shut_down)(void);

	unsigned int (*detect_key)(unsigned int);
};
static void inline aml_update_bits(unsigned int  reg, unsigned int mask, unsigned int val)
{
	unsigned int tmp, orig;
	orig = readl(reg);
	tmp = orig & ~mask;
	tmp |= val & mask;
	writel(tmp, reg);
}

#endif


