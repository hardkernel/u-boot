
/*
 * board/amlogic/gxtvbb_skt_v1/firmware/scp_task/dvfs_board.c
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

static int pwm_voltage_table[][2] = {
	{ 0x1c0000,  860},
	{ 0x1b0001,  870},
	{ 0x1a0002,  880},
	{ 0x190003,  890},
	{ 0x180004,  900},
	{ 0x170005,  910},
	{ 0x160006,  920},
	{ 0x150007,  930},
	{ 0x140008,  940},
	{ 0x130009,  950},
	{ 0x12000a,  960},
	{ 0x11000b,  970},
	{ 0x10000c,  980},
	{ 0x0f000d,  990},
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
	{ 0x00001c, 1140}
};

struct scpi_opp_entry cpu_dvfs_tbl[] = {
	DVFS( 100000000,  860+50),
	DVFS( 250000000,  860+50),
	DVFS( 500000000,  860+50),
	DVFS( 667000000,  900+50),
	DVFS(1000000000,  940+50),
	DVFS(1200000000,  980+50),
	DVFS(1296000000, 1000+50),
	DVFS(1416000000, 1020+50),
	DVFS(1536000000, 1050+50),
	DVFS(1800000000, 1050+50),
};



#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))
#define P_PWM_MISC_REG_EF (*((volatile unsigned *)(0xc1100000 + (0x21b2 << 2))))
#define P_PWM_PWM_E		(*((volatile unsigned *)(0xc1100000 + (0x21b0 << 2))))

enum pwm_id {
	pwm_a = 0,
	pwm_b,
	pwm_c,
	pwm_d,
	pwm_e,
	pwm_f,
};


void pwm_init(int id)
{
	/*
	 * TODO: support more pwm controllers, right now only support PWM_B
	 */
	unsigned int reg;

	reg = P_PWM_MISC_REG_EF;
	reg &= ~(0x7f << 8);
	reg |=  ((1 << 15) | (1 << 1) |(1 << 0));
	P_PWM_MISC_REG_EF = reg;

	/*
	 * default set to max voltage
	 */
	P_PWM_PWM_E = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];

	reg  = P_PIN_MUX_REG7;
	reg &= ~((1 << 26)| (1 << 18)|(1 << 30));
	P_PIN_MUX_REG7 = reg;

	reg  = P_PIN_MUX_REG7;
	reg |=  (1 << 29);      // enable PWM_E
	P_PIN_MUX_REG7 = reg;

	_udelay(200);
}

int dvfs_get_voltage(void)
{
	int i = 0;
	unsigned int reg_val;

	reg_val = P_PWM_PWM_E;
	for (i = 0; i < ARRAY_SIZE(pwm_voltage_table); i++) {
		if (pwm_voltage_table[i][0] == reg_val) {
			return i;
		}
	}
	if (i >= ARRAY_SIZE(pwm_voltage_table)) {
	    return -1;
	}
	return -1;
}

void set_dvfs(unsigned int domain, unsigned int index)
{
	int cur, to;
	static int init_flag = 0;

	if (!init_flag) {
		pwm_init(pwm_b);
		init_flag = 1;
	}
	cur = dvfs_get_voltage();
	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table); to++) {
		if (pwm_voltage_table[to][1] >= cpu_dvfs_tbl[index].volt_mv) {
			break;
		}
	}
	if (to >= ARRAY_SIZE(pwm_voltage_table)) {
		to = ARRAY_SIZE(pwm_voltage_table) - 1;
	}
	if (cur < 0 || cur >=ARRAY_SIZE(pwm_voltage_table)) {
		P_PWM_PWM_E = pwm_voltage_table[to][0];
		_udelay(200);
		return ;
	}
	while (cur != to) {
		/*
		 * if target step is far away from current step, don't change
		 * voltage by one-step-done. You should change voltage step by
		 * step to make sure voltage output is stable
		 */
		if (cur < to) {
			if (cur < to - 3) {
				cur += 3;
			} else {
				cur = to;
			}
		} else {
			if (cur > to + 3) {
				cur -= 3;
			} else {
				cur = to;
			}
		}
		P_PWM_PWM_E = pwm_voltage_table[cur][0];
		_udelay(100);
	}
}

