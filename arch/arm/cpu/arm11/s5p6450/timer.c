/*
 * (C) Copyright 2003
 * Texas Instruments <www.ti.com>
 *
 * (C) Copyright 2002
 * Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Marius Groeger <mgroeger@sysgo.de>
 *
 * (C) Copyright 2002
 * Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Alex Zuepke <azu@sysgo.de>
 *
 * (C) Copyright 2002-2004
 * Gary Jennejohn, DENX Software Engineering, <garyj@denx.de>
 *
 * (C) Copyright 2004
 * Philippe Robin, ARM Ltd. <philippe.robin@arm.com>
 *
 * (C) Copyright 2008
 * Guennadi Liakhovetki, DENX Software Engineering, <lg@denx.de>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <asm/proc-armv/ptrace.h>
#include <asm/arch/cpu.h>
#include <asm/arch/clk.h>
#include <asm/arch/pwm.h>
#include <div64.h>

static ulong count_value;

#define PRESCALER	0xf

/* macro to read the 16 bit timer */
static inline ulong read_timer(void)
{
	s5p6450_timer *const timers = samsung_get_base_timers();

	return timers->tcnto4;
}

/* Internal tick units */
/* Last decremneter snapshot */
static unsigned long lastdec;
/* Monotonic incrementing timer */
static unsigned long long timestamp;

int timer_init(void)
{
	unsigned int cnt=0;
	s5p6450_timer *const timers = (s5p6450_timer *)samsung_get_base_timers();
	u32 val;

	/*
	 * @ PWM Timer 4
	 * Timer Freq(HZ) =
	 *	PWM_CLK / { (prescaler_value + 1) * (divider_value) }
	 */

	/* set prescaler : 16 */
	timers->tcfg0 = PRESCALER << 8;

	count_value = get_pwm_clk() / (PRESCALER + 1);

	/* count_value / 100 = 41700(HZ) (per 10msec)*/
	count_value = count_value / 100;

	/* load value for 10 ms timeout */
	lastdec = count_value;
	writel(count_value, &timers->tcntb4);

	/* auto load, manual update of Timer 4 */
	val = (readl(&timers->tcon) & ~0x00700000) | TCON_4_AUTO | TCON_4_UPDATE;

	writel(val, &timers->tcon);

	/* auto load, start Timer 4 */
	writel((readl(&timers->tcon) & ~0x00700000) |TCON_4_AUTO | COUNT_4_ON,&timers->tcon);

	timestamp = 0;

	return 0;
}

/*
 * timer without interrupts
 */

void reset_timer(void)
{
	reset_timer_masked();
}

unsigned long get_timer(unsigned long base)
{
	return get_timer_masked() - base;
}

void set_timer(unsigned long t)
{
	timestamp = t;
}

/* delay x useconds */
void __udelay(unsigned long usec)
{
	s5p6450_timer *const timers = (s5p6450_timer *)samsung_get_base_timers();
	unsigned long tmo, tmp;

	count_value = readl(&timers->tcntb4);

	if (usec >= 1000) {
		/*
		 * if "big" number, spread normalization
		 * to seconds
		 * 1. start to normalize for usec to ticks per sec
		 * 2. find number of "ticks" to wait to achieve target
		 * 3. finish normalize.
		 */
		tmo = usec / 1000;
		tmo *= (CONFIG_SYS_HZ * count_value / 10);
		tmo /= 1000;
	} else {
		/* else small number, don't kill it prior to HZ multiply */
		tmo = usec * CONFIG_SYS_HZ * count_value / 10;
		tmo /= (1000 * 1000);
	}

	/* get current timestamp */
	tmp = get_timer(0);

	/* if setting this fordward will roll time stamp */
	/* reset "advancing" timestamp to 0, set lastdec value */
	/* else, set advancing stamp wake up time */
	if ((tmo + tmp + 1) < tmp)
		reset_timer_masked();
	else
		tmo += tmp;

	/* loop till event */
	while (get_timer_masked() < tmo)
		;	/* nop */
}

void reset_timer_masked(void)
{
	s5p6450_timer *const timers = (s5p6450_timer *)samsung_get_base_timers();
	/* reset time */
	lastdec = readl(&timers->tcnto4);
	timestamp = 0;
}

unsigned long get_timer_masked(void)
{
	s5p6450_timer *const timers = (s5p6450_timer *)samsung_get_base_timers();
	unsigned long now = readl(&timers->tcnto4);

	if (lastdec >= now)
		timestamp += lastdec - now;
	else
		timestamp += lastdec + count_value - now;

	lastdec = now;

	return timestamp;
}

/*
 * This function is derived from PowerPC code (read timebase as long long).
 * On ARM it just returns the timer value.
 */
unsigned long long get_ticks(void)
{
	return get_timer(0);
}

/*
 * This function is derived from PowerPC code (timebase clock frequency).
 * On ARM it returns the number of timer ticks per second.
 */
unsigned long get_tbclk(void)
{
	return CONFIG_SYS_HZ;
}
