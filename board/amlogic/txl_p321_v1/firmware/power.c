
/*
 * board/amlogic/txl_p321_v1/firmware/power.c
 *
 * Copyright (C) 2016 Amlogic, Inc. All rights reserved.
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

#include "config.h"
#include <serial.h>
//#include <stdio.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

static int pwm_voltage_table[][2] = {
	{ 0x1c0000,  870},
	{ 0x1b0001,  880},
	{ 0x1a0002,  890},
	{ 0x190003,  900},
	{ 0x180004,  910},
	{ 0x170005,  920},
	{ 0x160006,  930},
	{ 0x150007,  940},
	{ 0x140008,  950},
	{ 0x130009,  960},
	{ 0x12000a,  970},
	{ 0x11000b,  980},
	{ 0x10000c,  990},
	{ 0x0f000d, 1000},
	{ 0x0e000e, 1010},
	{ 0x0d000f, 1020},
	{ 0x0c0010, 1030},
	{ 0x0b0011, 1040},
	{ 0x0a0012, 1050},
	{ 0x090013, 1060},
	{ 0x080014, 1070},
	{ 0x070015, 1080},
	{ 0x060016, 1090},
	{ 0x050017, 1100},
	{ 0x040018, 1110},
	{ 0x030019, 1120},
	{ 0x02001a, 1130},
	{ 0x01001b, 1140},
	{ 0x00001c, 1150}
};


#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG4		(*((volatile unsigned *)(0xda834400 + (0x30 << 2))))

#define P_PWM_PWM_A		(*((volatile unsigned *)(0xc1100000 + (0x2154 << 2))))
#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))

#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))

enum pwm_id {
    pwm_a = 0,
    pwm_ao_b,
};

unsigned int _get_time(void)
{
	return P_EE_TIMER_E;
}

void _udelay_(unsigned int us)
{
	unsigned int t0 = _get_time();

	while (_get_time() - t0 <= us)
		;
}

void pwm_init(int id)
{
	unsigned int reg;
	int vol;

	switch (id) {
	case pwm_a:
		reg = P_PWM_MISC_REG_AB;
		reg &= ~(0x7f << 8);
		reg |=  ((1 << 15) | (1 << 0));
		P_PWM_MISC_REG_AB = reg;
		/*
		 * default set to max voltage
		 */
		//P_PWM_PWM_A = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_REG3;
		reg &= ~(1 << 21);
		P_PIN_MUX_REG3 = reg;

		reg  = P_PIN_MUX_REG4;
		reg &= ~(1 << 26);
		reg |=  (1 << 17);
		P_PIN_MUX_REG4 = reg;
		break;

	case pwm_ao_b:
		reg = readl(AO_PWM_MISC_REG_AB);
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1));
		writel(reg, AO_PWM_MISC_REG_AB);
		/*
		 * default set to max voltage
		 */
		//vol = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];
		//writel(vol ,AO_PWM_PWM_B);
		reg  = readl(AO_RTI_PIN_MUX_REG);
		reg |= (1 << 3);
		writel(reg, AO_RTI_PIN_MUX_REG);
		break;
	default:
		break;
	}

	_udelay_(200);
}

void pwm_set_voltage(unsigned int id, unsigned int voltage)
{
	int to;

	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table); to++) {
		if (pwm_voltage_table[to][1] >= voltage) {
			break;
		}
	}
	if (to >= ARRAY_SIZE(pwm_voltage_table)) {
		to = ARRAY_SIZE(pwm_voltage_table) - 1;
	}
	switch (id) {
	case pwm_a:
		P_PWM_PWM_A = pwm_voltage_table[to][0];
		break;

	case pwm_ao_b:
		writel(pwm_voltage_table[to][0], AO_PWM_PWM_B);
		break;
	default:
		break;
	}
	_udelay_(200);
}

void power_init(int mode)
{

	serial_puts("set vcck to ");
	serial_put_dec(CONFIG_VCCK_INIT_VOLTAGE);
	serial_puts(" mv\n");
	pwm_set_voltage(pwm_a, CONFIG_VCCK_INIT_VOLTAGE);
	serial_puts("set vddee to ");
	serial_put_dec(CONFIG_VDDEE_INIT_VOLTAGE);
	serial_puts(" mv\n");
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_INIT_VOLTAGE);
	pwm_init(pwm_a);
	pwm_init(pwm_ao_b);
}
