
/*
 * board/amlogic/txl_p321_v1/firmware/scp_task/dvfs_board.c
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

#include "pwm_ctrl.h"

#define CHIP_ADJUST 20
#define RIPPLE_ADJUST 30

struct scpi_opp_entry cpu_dvfs_tbl[] = {
	DVFS( 100000000,  1000+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS( 250000000,  1000+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS( 500000000,  1000+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS( 667000000,  1000+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS(1000000000,  1000+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS(1200000000,  1000+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS(1296000000,  1000+CHIP_ADJUST+RIPPLE_ADJUST),
};



#define P_PIN_MUX_REG3         (*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG4         (*((volatile unsigned *)(0xda834400 + (0x30 << 2))))

#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_A		(*((volatile unsigned *)(0xc1100000 + (0x2154 << 2))))

/*
 * gpioao_9 pwm_ao_b is used to adjust VDD_EE
 */
#define P_PIN_MUX_AO_REG	(*((volatile unsigned *)(0xc8100000 + (0x5 << 2))))

#define P_AO_PWM_MISC_REG_AB1	(*((volatile unsigned *)(0xc8100400 + (0x56 << 2))))
#define P_AO_PWM_PWM_B1 (*((volatile unsigned *)(0xc8100400 + (0x55 << 2))))

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
//vddee vcck together
	/*
	 * TODO: support more pwm controllers, right now only support PWM_B
	 */
	unsigned int reg;

	uart_puts("pwm init in M3\n");
	reg = P_AO_PWM_MISC_REG_AB1;
	reg &= ~(0x7f << 16);
	reg |=  ((1 << 23) | (1 << 1));
	P_AO_PWM_MISC_REG_AB1 = reg;
	/*
	 * default set to max voltage
	 */

	P_AO_PWM_PWM_B1 = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 8][0];
	reg  = P_PIN_MUX_AO_REG;
	reg |= (1 << 3);
	P_PIN_MUX_AO_REG = reg;
	_udelay(200);
}

int dvfs_get_voltage(void)
{
	int i = 0;
	unsigned int reg_val;

	reg_val = P_AO_PWM_PWM_B1;
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
		pwm_init(pwm_ao_b);
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
		P_AO_PWM_PWM_B1 = pwm_voltage_table[to][0];
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
		P_AO_PWM_PWM_B1 = pwm_voltage_table[cur][0];
		_udelay(100);
	}
	_udelay(200);
}
void get_dvfs_info_board(unsigned int domain,
		unsigned char *info_out, unsigned int *size_out)
{
	unsigned int cnt;
	cnt = ARRAY_SIZE(cpu_dvfs_tbl);

	buf_opp.latency = 200;
	buf_opp.count = cnt;
	memset(&buf_opp.opp[0], 0,
	       MAX_DVFS_OPPS * sizeof(struct scpi_opp_entry));

	memcpy(&buf_opp.opp[0], cpu_dvfs_tbl ,
		cnt * sizeof(struct scpi_opp_entry));

	memcpy(info_out, &buf_opp, sizeof(struct scpi_opp));
	*size_out = sizeof(struct scpi_opp);
	return;
}
