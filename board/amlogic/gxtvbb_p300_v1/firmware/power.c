
/*
 * board/amlogic/gxtvbb_p300_v1/firmware/power.c
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

#include "config.h"
#include <serial.h>
//#include <stdio.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

static int pwm_voltage_table[][2] = {
	{ 0x180004, 900},
	{ 0x170005, 910},
	{ 0x160006, 920},
	{ 0x150007, 930},
	{ 0x140008, 940},
	{ 0x130009, 950},
	{ 0x12000a, 960},
	{ 0x11000b, 970},
	{ 0x10000c, 980},
	{ 0x0f000d, 990},
	{ 0x0e000e, 1000},
	{ 0x0d000f, 1010},
	{ 0x0c0010, 1020},
	{ 0x0b0011, 1030},
	{ 0x0a0012, 1040},
	{ 0x090013, 1050},
	{ 0x080014, 1060},
	{ 0x070015, 1070},
	{ 0x060016, 1080},
	{ 0x050017, 1090},
	{ 0x040018, 1100},
	{ 0x030019, 1110},
	{ 0x02001a, 1120},
	{ 0x01001b, 1130},
	{ 0x00001c, 1140},
};

#define P_PIN_MUX_AO		(*((volatile unsigned *)(0xc8100000 + (0x05 << 2))))
#define P_PIN_MUX_REG10		(*((volatile unsigned *)(0xda834400 + (0x36 << 2))))

#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_A		(*((volatile unsigned *)(0xc1100000 + (0x2154 << 2))))

#define P_PWM_MISC_REG_EF	(*((volatile unsigned *)(0xc1100000 + (0x21b2 << 2))))
#define P_PWM_PWM_F		(*((volatile unsigned *)(0xc1100000 + (0x21b1 << 2))))

#ifdef P_AO_PWM_MISC_REG_AB
#undef P_AO_PWM_MISC_REG_AB
#endif
#define P_AO_PWM_MISC_REG_AB (*((volatile unsigned *)(0xc8100400 + (0x56 << 2))))
#ifdef P_AO_PWM_PWM_B
#undef P_AO_PWM_PWM_B
#endif
#define P_AO_PWM_PWM_B (*((volatile unsigned *)(0xc8100400 + (0x55 << 2))))

enum pwm_id {
    pwm_a = 0,
    pwm_b,
    pwm_c,
    pwm_d,
    pwm_e,
    pwm_f,
    pwm_ao_a,
    pwm_ao_b,
};

void pwm_init(int id)
{
	unsigned int reg;

	/*
	 * TODO: support more pwm controllers, right now only support
	 * PWM_A, PWM_AO_B,PWM_F
	 */

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

		reg  = P_PIN_MUX_REG10;
		reg &= ~((1 << 12)|(1<<14)|(1<<22));
		P_PIN_MUX_REG10 = reg;

		reg  = P_PIN_MUX_REG10;
		reg |=  (1 << 21);		// enable PWM_A
		P_PIN_MUX_REG10 = reg;
		break;

	case pwm_ao_b:
		reg = P_AO_PWM_MISC_REG_AB;
		reg &= ~(0x7f << 16);
		reg |=	((1 << 23) | (1 << 1)|(1<<0));

		P_AO_PWM_MISC_REG_AB = reg;
		/*
		 * default set to max voltage
		 */
		//P_AO_PWM_PWM_B = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];

		reg  = P_PIN_MUX_AO;
		reg &= ~(1 << 22);
		P_PIN_MUX_AO = reg;

		reg  = P_PIN_MUX_AO;
		reg |=  (1 << 21);		// enable PWM_AO_B
		P_PIN_MUX_AO = reg;

		break;

	case pwm_f:
		reg = P_PWM_MISC_REG_EF;
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1) |(1 << 0));
		P_PWM_MISC_REG_EF = reg;
		/*
		 * default set to max voltage
		 */
		P_PWM_PWM_F =  pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];

		reg  = P_PIN_MUX_AO;
		reg &= ~(1 << 21);
		P_PIN_MUX_AO = reg;

		reg  = P_PIN_MUX_AO;
		reg |=	(1 << 22);		// enable PWM_f
		P_PIN_MUX_AO = reg;

		break;

	default:
		break;
	}

	_udelay(200);
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

	//serial_put_dec( pwm_voltage_table[to][1]);
	//serial_puts(" mv\n");

	//serial_put_dec( pwm_voltage_table[to][0]);
	//serial_puts(" mv\n");

	switch (id) {
	case pwm_a:
		P_PWM_PWM_A = pwm_voltage_table[to][0];
		break;

	case pwm_ao_b:
		P_AO_PWM_PWM_B = pwm_voltage_table[to][0];
		break;

	case pwm_f:
		P_PWM_PWM_F = pwm_voltage_table[to][0];
		break;
	default:
		break;
	}

	_udelay(200);
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
