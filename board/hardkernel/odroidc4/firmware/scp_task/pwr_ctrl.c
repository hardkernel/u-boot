/*
 * board/hardkernel/odroidc4/firmware/scp_task/pwr_ctrl.c
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
#ifdef CONFIG_GPIO_WAKEUP
#include <gpio_key.h>
#endif

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

unsigned int enable_wol = 0;   /* disable Wake-On-Lan by default*/
unsigned int enable_5V_system_power = 0;	/* disable 5V system power (USB) by default*/

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

static void power_off_at_24M(unsigned int suspend_from)
{
	if (!enable_5V_system_power) {
		/*set gpioH_8 low to power off vcc 5v*/
		writel(readl(PREG_PAD_GPIO3_EN_N) & (~(1 << 8)), PREG_PAD_GPIO3_EN_N);
		writel(readl(PERIPHS_PIN_MUX_C) & (~(0xf)), PERIPHS_PIN_MUX_C);
	}

	if (!enable_wol) {
		/*set test_n low to power off vcck_b & vcc 3.3v*/
		writel(readl(AO_GPIO_O) & (~(1 << 31)), AO_GPIO_O);
		writel(readl(AO_GPIO_O_EN_N) & (~(1 << 31)), AO_GPIO_O_EN_N);
		writel(readl(AO_RTI_PIN_MUX_REG1) & (~(0xf << 28)), AO_RTI_PIN_MUX_REG1);
	}

	/*step down ee voltage*/
	set_vddee_voltage(CONFIG_VDDEE_SLEEP_VOLTAGE);
}

static void power_on_at_24M(unsigned int suspend_from)
{
	/*step up ee voltage*/
	set_vddee_voltage(CONFIG_VDDEE_INIT_VOLTAGE);

	if (!enable_wol) {
		/*set test_n high to power on vcck_b & vcc 3.3v*/
		writel(readl(AO_GPIO_O) | (1 << 31), AO_GPIO_O);
		writel(readl(AO_GPIO_O_EN_N) & (~(1 << 31)), AO_GPIO_O_EN_N);
		writel(readl(AO_RTI_PIN_MUX_REG1) & (~(0xf << 28)), AO_RTI_PIN_MUX_REG1);
		_udelay(100);
	}

	if (!enable_5V_system_power) {
		/*set gpioH_8 low to power on vcc 5v*/
		writel(readl(PREG_PAD_GPIO3_EN_N) | (1 << 8), PREG_PAD_GPIO3_EN_N);
		writel(readl(PERIPHS_PIN_MUX_C) & (~(0xf)), PERIPHS_PIN_MUX_C);
	}

	_udelay(10000);
}

void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	struct wakeup_gpio_info *gpio;
	unsigned val;
	unsigned i = 0;

	p->status = RESPONSE_OK;
	val = (POWER_KEY_WAKEUP_SRC | AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC |
			RTC_WAKEUP_SRC | BT_WAKEUP_SRC | ETH_PHY_GPIO_SRC);

#ifdef CONFIG_CEC_WAKEUP
	val |= CECB_WAKEUP_SRC;
#endif

	p->sources = val;

	/* Power Key: AO_GPIO[3]*/
	gpio = &(p->gpio_info[i]);
	gpio->wakeup_id = POWER_KEY_WAKEUP_SRC;
	gpio->gpio_in_idx = GPIOAO_3;
	gpio->gpio_in_ao = 1;
	gpio->gpio_out_idx = -1;
	gpio->gpio_out_ao = -1;
	gpio->irq = IRQ_AO_GPIO0_NUM;
	gpio->trig_type = GPIO_IRQ_FALLING_EDGE;
	p->gpio_info_count = ++i;

	if (enable_wol) {
		/*Eth:GPIOZ_14*/
		gpio = &(p->gpio_info[i]);
		gpio->wakeup_id = ETH_PHY_GPIO_SRC;
		gpio->gpio_in_idx = GPIOZ_14;
		gpio->gpio_in_ao = 0;
		gpio->gpio_out_idx = -1;
		gpio->gpio_out_ao = -1;
		gpio->irq = IRQ_GPIO1_NUM;
		gpio->trig_type = GPIO_IRQ_FALLING_EDGE;
		p->gpio_info_count = ++i;
	}
}
extern void __switch_idle_task(void);

static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	unsigned *irq = (unsigned *)WAKEUP_SRC_IRQ_ADDR_BASE;
#ifdef CONFIG_ADC_KEY
	unsigned char adc_key_cnt = 0;
	saradc_enable();
#endif
#ifdef CONFIG_GPIO_WAKEUP
	unsigned int is_gpiokey = 0;
#endif

	backup_remote_register();
	init_remote();
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		remote_cec_hw_reset();
		cec_node_init();
	}
#endif

#ifdef CONFIG_GPIO_WAKEUP
	is_gpiokey = init_gpio_key();
#endif

	do {
#ifdef CONFIG_CEC_WAKEUP
		if (!cec_msg.log_addr)
			cec_node_init();
		else {
			if (readl(AO_CECB_INTR_STAT) & CECB_IRQ_RX_EOM) {
				if (cec_power_on_check())
					exit_reason = CEC_WAKEUP;
			}
		}
#endif

		if (irq[IRQ_AO_IR_DEC] == IRQ_AO_IR_DEC_NUM) {
			irq[IRQ_AO_IR_DEC] = 0xFFFFFFFF;
			if (remote_detect_key())
				exit_reason = REMOTE_WAKEUP;
		}

#ifdef CONFIG_ADC_KEY
		if (irq[IRQ_AO_TIMERA] == IRQ_AO_TIMERA_NUM) {
			irq[IRQ_AO_TIMERA] = 0xFFFFFFFF;
			if (check_adc_key_resume()) {
				adc_key_cnt++;
				/*using variable 'adc_key_cnt' to eliminate the dithering of the key*/
				if (2 == adc_key_cnt)
					exit_reason = POWER_KEY_WAKEUP;
			} else {
				adc_key_cnt = 0;
			}
		}
#endif

#ifdef CONFIG_GPIO_POWER_KEY
		if (irq[IRQ_AO_GPIO0] == IRQ_AO_GPIO0_NUM) {
			irq[IRQ_AO_GPIO0] = 0xFFFFFFFF;
			if ((readl(AO_GPIO_I) & (1<<3)) == 0)
				exit_reason = POWER_KEY_WAKEUP;
		}
#endif

		if (enable_wol && (irq[IRQ_GPIO1] == IRQ_GPIO1_NUM)) {
			irq[IRQ_GPIO1] = 0xFFFFFFFF;
			if (!(readl(PREG_PAD_GPIO4_I) & (0x01 << 14))
					&& (readl(PREG_PAD_GPIO4_EN_N) & (0x01 << 14)))
				exit_reason = ETH_PHY_GPIO;
		}

#ifdef CONFIG_GPIO_WAKEUP
		if (is_gpiokey) {
			if (gpio_detect_key())
				exit_reason = GPIO_WAKEUP;
		}
#endif
		if (exit_reason)
			break;
		else
			__switch_idle_task();
	} while (1);

#ifdef CONFIG_ADC_KEY
	saradc_disable();
#endif

	restore_remote_register();

	return exit_reason;
}

static void pwr_op_init(struct pwr_op *pwr_op)
{
	pwr_op->power_off_at_24M = power_off_at_24M;
	pwr_op->power_on_at_24M = power_on_at_24M;
	pwr_op->detect_key = detect_key;
	pwr_op->get_wakeup_source = get_wakeup_source;
}
