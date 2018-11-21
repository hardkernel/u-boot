
/*
 * board/amlogic/txl_skt_v1/firmware/scp_task/pwr_ctrl.c
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

#include <gpio.h>
#include "pwm_ctrl.h"
#ifdef CONFIG_CEC_WAKEUP
#include <cec_tx_reg.h>
#endif

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

static void set_vddee_voltage(unsigned int target_voltage)
{
	unsigned int to;

	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table_ee); to++) {
		if (pwm_voltage_table_ee[to][1] >= target_voltage) {
			break;
		}
	}

	if (to >= ARRAY_SIZE(pwm_voltage_table_ee)) {
		to = ARRAY_SIZE(pwm_voltage_table_ee) - 1;
	}

	writel(pwm_voltage_table_ee[to][0],AO_PWM_PWM_B);
}

static void power_off_ddr(unsigned int flag)
{
	if (flag) {
		/*set test_n high to power on VDDQ1.5*/
		writel(readl(AO_GPIO_TEST_N) | (1 << 31), AO_GPIO_TEST_N);
		writel(readl(AO_GPIO_TEST_N) & (~(0xf << 8)), AO_GPIO_TEST_N);
	} else {
		/*set test_n low to power off VDDQ1.5*/
		writel(readl(AO_GPIO_TEST_N) & (~(1 << 31)), AO_GPIO_TEST_N);
		writel(readl(AO_GPIO_TEST_N) & (~(0xf << 8)), AO_GPIO_TEST_N);

	}
}

static void power_off_at_24M(unsigned int suspend_from)
{
	/*set gpiaoao_2 low to power on VDDCPU*/
	writel(readl(AO_GPIO_O) & (~(1 << 2)), AO_GPIO_O);
	writel(readl(AO_GPIO_O_EN_N) & (~(1 << 2)), AO_GPIO_O_EN_N);
	writel(readl(AO_RTI_PIN_MUX_REG) & (~(0xf << 8)), AO_RTI_PIN_MUX_REG);
	_udelay(100);
	/*step down ee voltage*/
	set_vddee_voltage(CONFIG_VDDEE_SLEEP_VOLTAGE);
	if (suspend_from == SYS_POWEROFF) {
		power_off_ddr(0);
	}
}

static void power_on_at_24M(unsigned int suspend_from)
{
	/*step up ee voltage*/
	set_vddee_voltage(CONFIG_VDDEE_INIT_VOLTAGE);
	_udelay(100);

	/*set gpiaoao_2 high to power on VDDCPU*/
	writel(readl(AO_GPIO_O) | (1 << 2), AO_GPIO_O);
	writel(readl(AO_GPIO_O_EN_N) & (~(1 << 2)), AO_GPIO_O_EN_N);
	writel(readl(AO_RTI_PIN_MUX_REG) & (~(0xf << 8)), AO_RTI_PIN_MUX_REG);
	_udelay(10000);

	if (suspend_from == SYS_POWEROFF) {
		power_off_ddr(1);
	}

}

void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;
	unsigned i = 0;

	p->status = RESPONSE_OK;
	val = (POWER_KEY_WAKEUP_SRC | AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC |
	       ETH_PHY_WAKEUP_SRC | BT_WAKEUP_SRC | CECB_WAKEUP_SRC);

	p->sources = val;
	p->gpio_info_count = i;

}
extern void __switch_idle_task(void);

static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	unsigned *irq = (unsigned *)WAKEUP_SRC_IRQ_ADDR_BASE;
	init_remote();
#ifdef CONFIG_CEC_WAKEUP
		if (hdmi_cec_func_config & 0x1) {
			remote_cec_hw_reset();
			cec_node_init();
		}
#endif

	do {
		#ifdef CONFIG_CEC_WAKEUP
		if (irq[IRQ_AO_CECB] == IRQ_AO_CEC2_NUM) {
			irq[IRQ_AO_CECB] = 0xFFFFFFFF;
			if (cec_power_on_check())
				exit_reason = CEC_WAKEUP;
		}
		#endif
		if (irq[IRQ_AO_IR_DEC] == IRQ_AO_IR_DEC_NUM) {
			irq[IRQ_AO_IR_DEC] = 0xFFFFFFFF;
			if (remote_detect_key())
				exit_reason = REMOTE_WAKEUP;
		}

		if (exit_reason)
			break;
		else
			__switch_idle_task();
	} while (1);

	return exit_reason;
}

static void pwr_op_init(struct pwr_op *pwr_op)
{
	pwr_op->power_off_at_24M = power_off_at_24M;
	pwr_op->power_on_at_24M = power_on_at_24M;
	pwr_op->detect_key = detect_key;
	pwr_op->get_wakeup_source = get_wakeup_source;
}
