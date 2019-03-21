
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/suspend.h
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

typedef unsigned int uint32_t;

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
#define	REMOTE_CUS_WAKEUP		9
#define ETH_PMT_WAKEUP      10
#define CECB_WAKEUP		11
#define ETH_PHY_GPIO    12
/* wake up source*/
#define UDEFINED_WAKEUP_SRC	(1<<0)
#define CHARGING_WAKEUP_SRC (1<<1)
#define REMOTE_WAKEUP_SRC (1<<2)
#define RTC_WAKEUP_SRC	(1<<3)
#define BT_WAKEUP_SRC	(1<<4)
#define WIFI_WAKEUP_SRC	(1<<5)
#define POWER_KEY_WAKEUP_SRC	(1<<6)
#define AUTO_WAKEUP_SRC	(1<<7)
#define CEC_WAKEUP_SRC	(1<<8)
#define ETH_PMT_WAKEUP_SRC (1<<9)
#define CECB_WAKEUP_SRC    (1<<10)
#define ETH_PHY_GPIO_SRC   (1<<12)

struct pwr_op {
	void (*power_off_at_24M)(unsigned int);
	void (*power_on_at_24M)(unsigned int);
	void (*shut_down)(void);
	unsigned int (*detect_key)(unsigned int);
	void (*get_wakeup_source)(void *, unsigned int);
};
static void inline aml_update_bits(unsigned int  reg, unsigned int mask, unsigned int val)
{
	unsigned int tmp, orig;
	orig = readl(reg);
	tmp = orig & ~mask;
	tmp |= val & mask;
	writel(tmp, reg);
}

#define IRQ_VRTC_NUM		127
/* GPIO trigger type*/
#define GPIO_IRQ_LOW_LEVEL		0
#define GPIO_IRQ_HIGH_LEVEL		1
#define GPIO_IRQ_FALLING_EDGE	2
#define GPIO_IRQ_RISING_EDGE		3
/*for sm1,tm2 or later */
#define GPIO_IRQ_BOTH_EDGE		4

enum {
	IRQ_TIMERA = 0,
	IRQ_GPIO0,
	IRQ_GPIO1,
	IRQ_GPIO2,
	IRQ_GPIO3,
	IRQ_AO_IR_DEC,
	IRQ_AO_CEC,
	IRQ_AO_GPIO0,
	IRQ_AO_GPIO1,
	IRQ_AO_TIMERA,
	IRQ_ETH_PHY,
	IRQ_AO_CECB,
	IRQ_ETH_PTM,
	IRQ_VRTC = 31,
	WAKE_UP_MAX = 32,
};

/* M3 CPU has 2 ao-gpio-irq, 4 gpio-irq*/
#define GPIO_WAKEUP_MAX		6
struct wakeup_gpio_info {
	int wakeup_id;
	int gpio_in_idx;
	int gpio_in_ao;
	int gpio_out_idx;
	int gpio_out_ao;
	int irq;
	int trig_type;
};
struct wakeup_info {
	unsigned status;
	unsigned sources;
	unsigned gpio_info_count;
	struct wakeup_gpio_info gpio_info[GPIO_WAKEUP_MAX];
};

#define DIRECTION_IN		1
#define DIRECTION_OUT	0

#define SYS_SUSPEND 1
#define SYS_POWEROFF 0

#endif
