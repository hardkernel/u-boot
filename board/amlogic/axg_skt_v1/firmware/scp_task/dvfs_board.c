
/*
 * board/amlogic/txl_skt_v1/firmware/scp_task/dvfs_board.c
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

#include "pwm_ctrl.h"

#define CHIP_ADJUST 20
#define RIPPLE_ADJUST 30
struct scpi_opp_entry cpu_dvfs_tbl[] = {
	DVFS( 100000000,  860),
	DVFS( 250000000,  860+CHIP_ADJUST),
	DVFS( 500000000,  860+RIPPLE_ADJUST),
	DVFS( 667000000,  860+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS(1000000000,  910+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS(1200000000,  940+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS(1296000000,  980+CHIP_ADJUST+RIPPLE_ADJUST),
	DVFS(1416000000, 1050+CHIP_ADJUST+RIPPLE_ADJUST),
};

void pwm_init(void)
{
	unsigned int reg;

	/*
	 * TODO: support more pwm controllers, right now only support
	 */

	reg = readl(AO_PWM_MISC_REG_AB);
	reg &= ~(0x7f << 16);
	reg |=  ((1 << 23) | (1 << 1));
	writel(reg, AO_PWM_MISC_REG_AB);
	/*
	 * default set to max voltage
	 */
	reg  = readl(AO_RTI_PINMUX_REG0);
	reg &= ~(0xf << 8);
	writel(reg | (0x3 << 8), AO_RTI_PINMUX_REG0);

	_udelay(200);
}


int dvfs_get_voltage(void)
{
	int i = 0;
	unsigned int reg_val;

	reg_val = readl(AO_PWM_PWM_B);
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
		pwm_init();
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
		writel(pwm_voltage_table[to][0], AO_PWM_PWM_B);
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
		writel(pwm_voltage_table[cur][0], AO_PWM_PWM_B);
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
