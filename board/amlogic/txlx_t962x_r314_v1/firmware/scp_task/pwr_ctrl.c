
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


#ifdef CONFIG_CEC_WAKEUP
#include <asm/arch/cec_tx_reg.h>
#include <hdmi_cec_arc.h>
#include <amlogic/aml_cec.h>
#endif
#include <gpio-gxbb.h>
#include "pwm_ctrl.h"

#define P_AO_PWM_PWM_B1			(*((volatile unsigned *)(0xff807000 + (0x01   << 2))))
#define P_EE_TIMER_E			(*((volatile unsigned *)(0xffd00000 + (0x3c62 << 2))))
#define P_PWM_PWM_A			(*((volatile unsigned *)(0xffd1b000 + (0x0  << 2))))
#define ON 1
#define OFF 0

static int pwm_voltage_table_ee[][2] = {
	{ 0x1c0000,  810},
	{ 0x1b0001,  820},
	{ 0x1a0002,  830},
	{ 0x190003,  840},
	{ 0x180004,  850},
	{ 0x170005,  860},
	{ 0x160006,  870},
	{ 0x150007,  880},
	{ 0x140008,  890},
	{ 0x130009,  900},
	{ 0x12000a,  910},
	{ 0x11000b,  920},
	{ 0x10000c,  930},
	{ 0x0f000d,  940},
	{ 0x0e000e,  950},
	{ 0x0d000f,  960},
	{ 0x0c0010,  970},
	{ 0x0b0011,  980},
	{ 0x0a0012,  990},
	{ 0x090013, 1000},
	{ 0x080014, 1010},
	{ 0x070015, 1020},
	{ 0x060016, 1030},
	{ 0x050017, 1040},
	{ 0x040018, 1050},
	{ 0x030019, 1060},
	{ 0x02001a, 1070},
	{ 0x01001b, 1080},
	{ 0x00001c, 1090}
};


#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

static void power_on_ddr(void);
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

#if 0
static void power_switch_to_ee(unsigned int pwr_ctrl)
{
	if (pwr_ctrl == ON) {
		writel(readl(AO_RTI_PWR_CNTL_REG0) | (0x1 << 9), AO_RTI_PWR_CNTL_REG0);
		_udelay(1000);
		writel(readl(AO_RTI_PWR_CNTL_REG0)
			& (~((0x3 << 3) | (0x1 << 1))), AO_RTI_PWR_CNTL_REG0);
	} else {
		writel(readl(AO_RTI_PWR_CNTL_REG0)
		       | ((0x3 << 3) | (0x1 << 1)), AO_RTI_PWR_CNTL_REG0);

		writel(readl(AO_RTI_PWR_CNTL_REG0) & (~(0x1 << 9)),
		       AO_RTI_PWR_CNTL_REG0);

	}
}
#endif

static void pwm_set_voltage(unsigned int id, unsigned int voltage)
{
	int to;
	switch (id) {
	case pwm_a:
		for (to = 0; to < ARRAY_SIZE(pwm_voltage_table); to++) {
			if (pwm_voltage_table[to][1] >= voltage) {
				break;
			}
		}
		if (to >= ARRAY_SIZE(pwm_voltage_table)) {
			to = ARRAY_SIZE(pwm_voltage_table) - 1;
		}
		uart_puts("set vcck to 0x");
		uart_put_hex(to, 16);
		uart_puts("mv\n");
		P_PWM_PWM_A = pwm_voltage_table[to][0];
		break;

	case pwm_ao_b:
		for (to = 0; to < ARRAY_SIZE(pwm_voltage_table_ee); to++) {
			if (pwm_voltage_table_ee[to][1] >= voltage) {
				break;
			}
		}
		if (to >= ARRAY_SIZE(pwm_voltage_table_ee)) {
			to = ARRAY_SIZE(pwm_voltage_table_ee) - 1;
		}
		uart_puts("set vddee to 0x");
		uart_put_hex(to, 16);
		uart_puts("mv\n");
		P_AO_PWM_PWM_B1 = pwm_voltage_table_ee[to][0];
		break;
	default:
		break;
	}
	_udelay(200);
}

static void power_off_3v3_5v(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 18, 0);
}

static void power_on_3v3_5v(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 18, 1 << 18);
}

static void power_off_usb5v(void)
{
	return;
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 10, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 26, 0);
}

static void power_on_usb5v(void)
{
	return;
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 10, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 26, 1 << 26);
}

static void power_off_at_clk81(void)
{

}

static void power_on_at_clk81(unsigned int suspend_from)
{

}

static void power_off_at_24M(void)
{
}
static void power_on_at_24M(void)
{
}

static void power_off_ddr(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 11, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 27, 0);
}

static void power_on_ddr(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 11, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 27, 1 << 27);
	_udelay(10000);
}

/*timing request:
 *poweroff vddio3.3v-->delay 20ms-->poweroff vddee
 */
static void power_off_vddee(void)
{
	unsigned int val;

	/*set test n output low level */
	_udelay(10000);/*the other 10ms in power_off_at_32k()*/
	val = readl(AO_GPIO_O_EN_N);
	val &= ~(0x1 << 31);
	writel(val, AO_GPIO_O_EN_N);

}

/*timing request:
 *poweron vddee-->delay 20ms-->poweron vddio3.3v
 */
static void power_on_vddee(void)
{
	unsigned int val;

	/*set test n output high level */
	val = readl(AO_GPIO_O_EN_N);
	val |= 0x1 << 31;
	writel(val, AO_GPIO_O_EN_N);
	_udelay(10000);/*the other 10ms in power_on_at_32k()*/
}

static void power_off_at_32k(unsigned int suspend_from)
{
	power_off_usb5v();
	_udelay(5000);
	power_off_3v3_5v();
	_udelay(5000);
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_SLEEP_VOLTAGE);	/* reduce power */
	if (suspend_from == SYS_POWEROFF) {
		power_off_vddee();
		power_off_ddr();
	}
}

static void power_on_at_32k(unsigned int suspend_from)
{
	if (suspend_from == SYS_POWEROFF)
		power_on_vddee();
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_INIT_VOLTAGE);
	_udelay(10000);
	power_on_3v3_5v();
	_udelay(10000);
	pwm_set_voltage(pwm_a, CONFIG_VCCK_INIT_VOLTAGE);
	_udelay(10000);
	_udelay(10000);
	power_on_usb5v();

	if (suspend_from == SYS_POWEROFF)
		power_on_ddr();
}

void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;
	unsigned i = 0;

	p->status = RESPONSE_OK;
	p->gpio_info_count = i;
	val = (POWER_KEY_WAKEUP_SRC | AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC |
	       ETH_PHY_WAKEUP_SRC | BT_WAKEUP_SRC);
#ifdef CONFIG_CEC_WAKEUP
	val |= CECB_WAKEUP_SRC;
#endif

#ifdef CONFIG_BT_WAKEUP
	{
		struct wakeup_gpio_info *gpio;
		/* BT Wakeup: IN: GPIOX[21], OUT: GPIOX[20] */
		gpio = &(p->gpio_info[i]);
		gpio->wakeup_id = BT_WAKEUP_SRC;
		gpio->gpio_in_idx = GPIOAO_12;
		gpio->gpio_in_ao = 1;
		gpio->gpio_out_idx = -1;
		gpio->gpio_out_ao = -1;
		gpio->irq = IRQ_AO_GPIO0_NUM;
		gpio->trig_type = GPIO_IRQ_FALLING_EDGE;
		p->gpio_info_count = ++i;
	}
#endif
	p->sources = val;

}
void wakeup_timer_setup(void)
{
	/* 1ms resolution*/
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value |= ((0x3<<0) | (0x1<<12) | (0x1<<16));
	writel(value, P_ISA_TIMER_MUX);
	/*10ms generate an interrupt*/
	writel(9, P_ISA_TIMERA);
}
void wakeup_timer_clear(void)
{
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value &= ~((0x1<<12) | (0x1<<16));
	writel(value, P_ISA_TIMER_MUX);
}
static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	unsigned int time_out = readl(AO_DEBUG_REG2);
	unsigned time_out_ms = time_out*100;
	unsigned int cec_wait_addr = 0;
	unsigned char adc_key_cnt = 0;
	unsigned *irq = (unsigned *)WAKEUP_SRC_IRQ_ADDR_BASE;
	/* unsigned *wakeup_en = (unsigned *)SECURE_TASK_RESPONSE_WAKEUP_EN; */

	/* setup wakeup resources*/
	/*auto suspend: timerA 10ms resolution*/
	if (time_out_ms != 0)
		wakeup_timer_setup();
	init_remote();
	saradc_enable();
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		cec_hw_reset();
		cec_node_init();
		/*if (suspend_from == SYS_SUSPEND)
			check_standby();*/
	}
#endif

	/* *wakeup_en = 1;*/
	do {
#ifdef CONFIG_CEC_WAKEUP
		/*if receive wake up message, wait for the port*/
		if ((cec_msg.cec_power == 0x1) &&
		    (hdmi_cec_func_config & 0x1)) {
			if (cec_wait_addr++ < 100) {
				if (cec_msg.active_source) {
					cec_save_port_id();
					exit_reason = CEC_WAKEUP;
					uart_puts("check wakeup\n");
				}
			} else {
				exit_reason = CEC_WAKEUP;
				uart_puts("timeout wakeup\n");
			}
		}
		if (irq[IRQ_AO_CECB] == IRQ_AO_CECB_NUM) {
			irq[IRQ_AO_CECB] = 0xFFFFFFFF;
			/* if (suspend_from == SYS_POWEROFF) */
			/* continue; */
			if (cec_msg.log_addr) {
				if (hdmi_cec_func_config & 0x1) {
					cec_handler();
					if (cec_msg.cec_power == 0x1) {
						if (cec_msg.active_source) {
							cec_save_port_id();
							/*cec power key*/
							exit_reason = CEC_WAKEUP;
							uart_puts("message wakeup\n");
						}
					}
				}
			} else if (hdmi_cec_func_config & 0x1)
				cec_node_init();
		}
#endif
		if (irq[IRQ_TIMERA] == IRQ_TIMERA_NUM) {
			irq[IRQ_TIMERA] = 0xFFFFFFFF;
			if (time_out_ms != 0)
				time_out_ms--;
			if (time_out_ms == 0) {
				exit_reason = AUTO_WAKEUP;
			}
		}

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
#ifdef CONFIG_BT_WAKEUP
		if (irq[IRQ_AO_GPIO0] == IRQ_AO_GPIO0_NUM) {
			irq[IRQ_AO_GPIO0] = 0xFFFFFFFF;
			if (!(readl(P_AO_GPIO_O_EN_N)
				& (0x01 << 8)) && (readl(P_AO_GPIO_O_EN_N)
				& (0x01 << 24)) &&
				!(readl(P_AO_GPIO_I)
				& (0x01 << 12)))
				exit_reason = BT_WAKEUP;
		}
#endif

		if (irq[IRQ_AO_IR_DEC] == IRQ_AO_IR_DEC_NUM) {
			irq[IRQ_AO_IR_DEC] = 0xFFFFFFFF;
				if (remote_detect_key())
					exit_reason = REMOTE_WAKEUP;
		}
		if (irq[IRQ_ETH_PHY] == IRQ_ETH_PHY_NUM) {
			irq[IRQ_ETH_PHY] = 0xFFFFFFFF;
				exit_reason = ETH_PHY_WAKEUP;
		}
		if (exit_reason) {
			set_cec_val2(exit_reason);
			break;
		} else
			asm volatile("wfi");
	} while (1);

	wakeup_timer_clear();
	saradc_disable();

	return exit_reason;
}

static void pwr_op_init(struct pwr_op *pwr_op)
{
	pwr_op->power_off_at_clk81 = power_off_at_clk81;
	pwr_op->power_on_at_clk81 = power_on_at_clk81;
	pwr_op->power_off_at_24M = power_off_at_24M;
	pwr_op->power_on_at_24M = power_on_at_24M;
	pwr_op->power_off_at_32k = power_off_at_32k;
	pwr_op->power_on_at_32k = power_on_at_32k;

	pwr_op->detect_key = detect_key;
	pwr_op->get_wakeup_source = get_wakeup_source;
}
