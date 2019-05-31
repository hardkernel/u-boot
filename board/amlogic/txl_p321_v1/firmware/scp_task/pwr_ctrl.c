
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
#include <hdmi_cec_arc.h>
#include <amlogic/aml_cec.h>
#endif
#include <gpio-gxbb.h>
#include "pwm_ctrl.h"

#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))

#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_B		(*((volatile unsigned *)(0xc1100000 + (0x2155 << 2))))
#define P_PWM_MISC_REG_CD	(*((volatile unsigned *)(0xc1100000 + (0x2196 << 2))))
#define P_PWM_PWM_D		(*((volatile unsigned *)(0xc1100000 + (0x2195 << 2))))
#define P_AO_PWM_PWM_B1		(*((volatile unsigned *)(0xc8100400 + (0x55 << 2))))
#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))

#define ON 1
#define OFF 0


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

static unsigned int ao_timer_ctrl;
static unsigned int ao_timera;

static void reset_ao_timera(void)
{
	unsigned int val;
	ao_timer_ctrl = readl(AO_TIMER_REG);
	ao_timera = readl(AO_TIMERA_REG);
	/* set ao timera work mode and interrrupt time 100us resolution*/
	val = (1 << 2) | (3 << 0) | (1 << 3);
	writel(val, AO_TIMER_REG);
	/* periodic time 10ms */
	writel(100,AO_TIMERA_REG);
}

static void restore_ao_timer(void)
{
	writel(ao_timer_ctrl,AO_TIMER_REG);
	writel(ao_timera,AO_TIMERA_REG);
}

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
#define P_PWM_PWM_A		(*((volatile unsigned *)(0xc1100000 + (0x2154 << 2))))
static void pwm_set_voltage(unsigned int id, unsigned int voltage)
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
		uart_puts("set vcck to 0x");
		uart_put_hex(to, 16);
		uart_puts("mv\n");
		P_PWM_PWM_A = pwm_voltage_table[to][0];
		break;

	case pwm_ao_b:
		uart_puts("set vddee to 0x");
		uart_put_hex(to, 16);
		uart_puts("mv\n");
		P_AO_PWM_PWM_B1 = pwm_voltage_table[to][0];
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
	unsigned int hwid = 1;

	//CLEAR PINMUX
	aml_update_bits(AO_RTI_PIN_MUX_REG, (1<<23)|(1<<5)|(1<<1), 0); //AO_5
	aml_update_bits(PERIPHS_PIN_MUX_2, (1<<13)|(1<<5)|(1<<28), 0); //DV_9
	//SET GPIOAO_5 OUTPUT 0
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 5, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 21, 0);
	//SET GPIODV_9 OUTPUT 0
	aml_update_bits(PREG_PAD_GPIO0_EN_N, 1 << 9, 0);
	aml_update_bits(PREG_PAD_GPIO0_O, 1 << 9, 0);

	return ;
	#if 0
	//v1
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 4, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 20, 0);
	//v2
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 10, 0);
    aml_update_bits(AO_GPIO_O_EN_N, 1 << 26, 0);
	#endif

	/* enable 5V for USB, panel, wifi */
	hwid = (readl(P_AO_SEC_GP_CFG0) >> 8) & 0xFF;
	switch (hwid) {
		case 1:
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 4, 0);
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 20, 0);
			uart_puts("poweroff 5v - hwid 1\n");
			break;
		case 2:
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 10, 0);
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 26, 0);
			uart_puts("poweroff 5v - hwid 2\n");
			break;
		default:
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 10, 0);
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 26, 0);
			uart_puts("poweroff 5v - invalid hwid\n");
			break;
	}
}

static void power_on_usb5v(void)
{
	unsigned int hwid = 1;

	//SET GPIOAO_5 OUTPUT 1
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 5, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 21, 1 << 21);
	//SET GPIODV_9 OUTPUT 1
	aml_update_bits(PREG_PAD_GPIO0_EN_N, 1 << 9, 0);
	aml_update_bits(PREG_PAD_GPIO0_O, 1 << 9, 1 << 9);

	return ;
	#if 0
	//v1
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 4, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 20, 1 << 20);
	//v2
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 10, 0);
    aml_update_bits(AO_GPIO_O_EN_N, 1 << 26, 1 << 26);
	#endif

	/* enable 5V for USB, panel, wifi */
	hwid = (readl(P_AO_SEC_GP_CFG0) >> 8) & 0xFF;
	switch (hwid) {
		case 1:
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 4, 0);
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 20, 1 << 20);
			uart_puts("poweron 5v - hwid 1\n");
			break;
		case 2:
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 10, 0);
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 26, 1 << 26);
			uart_puts("poweron 5v - hwid 2\n");
			break;
		default:
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 10, 0);
			aml_update_bits(AO_GPIO_O_EN_N, 1 << 26, 1 << 26);
			uart_puts("poweron 5v - invalid hwid\n");
			break;
	}
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
static void power_off_ee(void)
{
	return;
	power_switch_to_ee(OFF);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 8, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 24, 0);
}

static void power_on_ee(void)
{
	return;
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 8, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 24, 1 << 24);
	_udelay(10000);
	_udelay(10000);
}

static void power_off_at_32k(unsigned int suspend_from)
{
	power_off_usb5v();
	_udelay(5000);
	power_off_3v3_5v();
	_udelay(5000);
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_SLEEP_VOLTAGE);	/* reduce power */
	if (suspend_from == SYS_POWEROFF) {
		power_off_ee();
		power_off_ddr();
	}
}

static void power_on_at_32k(unsigned int suspend_from)
{
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_INIT_VOLTAGE);
	_udelay(10000);
	power_on_3v3_5v();
	_udelay(5000);
	pwm_set_voltage(pwm_a, CONFIG_VCCK_INIT_VOLTAGE);
	_udelay(10000);
	_udelay(10000);
	power_on_usb5v();

	if (suspend_from == SYS_POWEROFF) {
		power_on_ddr();
		power_on_ee();

	}
}

void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;

	p->status = RESPONSE_OK;
	val = (POWER_KEY_WAKEUP_SRC | AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC |
	       ETH_PHY_WAKEUP_SRC | BT_WAKEUP_SRC);
#ifdef CONFIG_CEC_WAKEUP
	//if (suspend_from != SYS_POWEROFF)
		val |= CEC_WAKEUP_SRC;
#endif
	p->sources = val;
	p->gpio_info_count = 0;
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
	unsigned char adc_key_cnt = 0;
	unsigned *irq = (unsigned *)WAKEUP_SRC_IRQ_ADDR_BASE;
	/* unsigned *wakeup_en = (unsigned *)SECURE_TASK_RESPONSE_WAKEUP_EN; */
	/*unsigned int cec_wait_addr = 0;*/
	/* setup wakeup resources*/
	/*auto suspend: timerA 10ms resolution*/
	if (time_out_ms != 0)
		wakeup_timer_setup();
	saradc_enable();
	reset_ao_timera();
	init_remote();
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		cec_hw_reset();
		cec_node_init();
	}
#endif

	/* *wakeup_en = 1;*/
	do {
#ifdef CONFIG_CEC_WAKEUP
		cec_suspend_wakeup_chk();
		if (irq[IRQ_AO_CEC] == IRQ_AO_CEC_NUM) {
			irq[IRQ_AO_CEC] = 0xFFFFFFFF;
			if (cec_suspend_handle())
				exit_reason = CEC_WAKEUP;
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
	restore_ao_timer();
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
