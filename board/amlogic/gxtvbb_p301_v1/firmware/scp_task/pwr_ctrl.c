
/*
 * board/amlogic/gxtvbb_skt_v1/firmware/scp_task/pwr_ctrl.c
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

#ifdef CONFIG_AML_LED
#include <aml_led.c>
#include <aml_led_pwm.c>
#endif
#include <config.h>
#define ON 1
#define OFF 0
static unsigned int pwm_voltage_table[][2] = {
	{0x180004, 900},
	{0x040018, 1100},
};

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
#ifdef CONFIG_CEC_WAKEUP
#include <cec_tx_reg.h>
#endif
#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))

#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_B		(*((volatile unsigned *)(0xc1100000 + (0x2155 << 2))))
#define P_PWM_MISC_REG_CD	(*((volatile unsigned *)(0xc1100000 + (0x2196 << 2))))
#define P_PWM_PWM_D		(*((volatile unsigned *)(0xc1100000 + (0x2195 << 2))))
#define P_AO_PWM_PWM_B1		(*((volatile unsigned *)(0xc8100400 + (0x55 << 2))))
#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))

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
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 18, 1 << 18);
}

static void power_on_3v3_5v(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 18, 0);
}

static void power_off_usb5v(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 5, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 21, 0);
}

static void power_on_usb5v(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 5, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 21, 1 << 21);
}

static void power_off_at_clk81(void)
{
	power_off_3v3_5v();
	power_off_usb5v();
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_SLEEP_VOLTAGE);	/* reduce power */
}

static void power_on_at_clk81(unsigned int suspend_from)
{
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_INIT_VOLTAGE);
	power_on_usb5v();
	power_on_3v3_5v();
	_udelay(10000);
	_udelay(10000);
	_udelay(10000);
	_udelay(10000);
	pwm_set_voltage(pwm_a, CONFIG_VCCK_INIT_VOLTAGE);
#if 0
	if (suspend_from == SYS_POWEROFF) {
		power_switch_to_ee(ON);
	}
#endif
}

static void power_off_at_24M(void)
{
}

static void power_on_at_24M(void)
{
}

static void power_off_ddr(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 3, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 19, 0);
}

static void power_on_ddr(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 3, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 19, 1 << 19);
	_udelay(10000);
}

static void power_off_ee(void)
{
	return;
	power_switch_to_ee(OFF);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 8, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 24, 1 << 24);
}

static void power_on_ee(void)
{
	return;
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 8, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1 << 24, 0);
	_udelay(10000);
	_udelay(10000);
}

static void power_off_at_32k(unsigned int suspend_from)
{

	if (suspend_from == SYS_POWEROFF) {
		power_off_ee();
		power_off_ddr();
	}
}

static void power_on_at_32k(unsigned int suspend_from)
{

	if (suspend_from == SYS_POWEROFF) {
		power_on_ddr();
		power_on_ee();

	}
}

static void wakeup_timer_setup(void)
{
	/* 1ms resolution */
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value |= ((0x3 << 0) | (0x1 << 12) | (0x1 << 16));
	writel(value, P_ISA_TIMER_MUX);
	writel(10, P_ISA_TIMERA);
}

static void wakeup_timer_clear(void)
{
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value &= ~((0x1 << 12) | (0x1 << 16));
	writel(value, P_ISA_TIMER_MUX);
}

static void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;
	p->gpio_info_count = 0;
	p->status = RESPONSE_OK;
	val = (AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC);
#ifdef CONFIG_BT_WAKEUP
	val |= BT_WAKEUP_SRC;
#endif

#ifdef CONFIG_CEC_WAKEUP
	val |= CEC_WAKEUP_SRC;
#endif
#ifdef CONFIG_WIFI_WAKEUP
	if (suspend_from != SYS_POWEROFF)
		val |= WIFI_WAKEUP_SRC;
#endif

	p->sources = val;

#ifdef CONFIG_BT_WAKEUP
	{
		struct wakeup_gpio_info *gpio;
		/* BT Wakeup: IN: GPIOX[21], OUT: GPIOX[20] */
		gpio = &(p->gpio_info[1]);
		gpio->wakeup_id = BT_WAKEUP;
		gpio->gpio_in_idx = GPIOX_21;
		gpio->gpio_in_ao = 0;
		gpio->gpio_out_idx = GPIOX_20;
		gpio->gpio_out_ao = 0;
		gpio->irq = IRQ_GPIO0_NUM;
		gpio->trig_type = GPIO_IRQ_FALLING_EDGE;
		p->gpio_info_count++;
	}
#endif

#ifdef CONFIG_WIFI_WAKEUP
	if (suspend_from != SYS_POWEROFF) {
		struct wakeup_gpio_info *gpio;
		/*WIFI Wakeup: IN: GPIOX[7], OUT: GPIOX[6] */
		gpio = &(p->gpio_info[2]);
		gpio->wakeup_id = WIFI_WAKEUP;
		gpio->gpio_in_idx = GPIOX_7;
		gpio->gpio_in_ao = 0;
		gpio->gpio_out_idx = GPIOX_6;
		gpio->gpio_out_ao = 0;
		gpio->irq = IRQ_GPIO1_NUM;
		gpio->trig_type = GPIO_IRQ_FALLING_EDGE;
		p->gpio_info_count++;
	}
#endif

}
static unsigned int ao_timer_ctrl;
static unsigned int ao_timera;
static void reset_ao_timera(void)
{
	unsigned int val;
	ao_timer_ctrl = readl(AO_TIMER_REG);
	ao_timera = readl(AO_TIMERA_REG);
/* set ao timera work mode and interrrupt time
 * 100us resolution
 */
	val = (1 << 2) | (3 << 0) | (1 << 3);
	writel(val, AO_TIMER_REG);

/* 	periodic time 10m
 */
	writel(100,AO_TIMERA_REG);
}
static void restore_ao_timer(void)
{
	writel(ao_timer_ctrl,AO_TIMER_REG);
	writel(ao_timera,AO_TIMERA_REG);
}

static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	unsigned int time_out = readl(AO_DEBUG_REG2);
	unsigned time_out_ms = time_out * 100;
	unsigned *irq = (unsigned *)SECURE_TASK_SHARE_IRQ;
	/* unsigned *wakeup_en = (unsigned *)SECURE_TASK_RESPONSE_WAKEUP_EN; */
	uart_puts("enter detect key\n");

	_udelay(10000);
	reset_ao_timera();
	/* setup wakeup resources */
	/*auto suspend: timerA 10ms resolution */
	if (time_out_ms != 0) {
		wakeup_timer_setup();
		if (suspend_from == SYS_POWEROFF) {
			time_out_ms = time_out * 1000;
			while (1) {
				_udelay(1000);
				time_out_ms--;
				if (time_out_ms == 0)
					return AUTO_WAKEUP;

			}
		}
	}
	init_remote();
#ifdef CONFIG_AML_LED
	pled_suspend_init();
#endif
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		remote_cec_hw_reset();
		cec_node_init();
	}
#endif

	/* *wakeup_en = 1; */
	do {
		switch (*irq) {
#ifdef CONFIG_CEC_WAKEUP
		case IRQ_AO_CEC_NUM:
			if (cec_msg.log_addr) {
				if (hdmi_cec_func_config & 0x1) {
					cec_handler();
					if (cec_msg.cec_power == 0x1) {
						/*cec power key */
						exit_reason = CEC_WAKEUP;
						break;
					}
				}
			} else if (hdmi_cec_func_config & 0x1)
				cec_node_init();
			break;
#endif
		case IRQ_TIMERA_NUM:
			if (time_out_ms != 0)
				time_out_ms--;
			if (time_out_ms == 0) {
				wakeup_timer_clear();
				exit_reason = AUTO_WAKEUP;
			}
			break;
		case IRQ_AO_TIMERA_NUM:
#ifdef CONFIG_AML_LED
			pled_suspend_timer_proc();
#endif
			break;
		case IRQ_AO_IR_DEC_NUM:
			if (remote_detect_key())
				exit_reason = REMOTE_WAKEUP;
			break;

#ifdef CONFIG_BT_WAKEUP
		case IRQ_GPIO0_NUM:
			if (!(readl(PREG_PAD_GPIO4_EN_N)
			      & (0x01 << 20)) && (readl(PREG_PAD_GPIO4_O)
						  & (0x01 << 20)) &&
			    !(readl(PREG_PAD_GPIO4_I)
			      & (0x01 << 21)))
				exit_reason = BT_WAKEUP;
			break;
#endif
#ifdef CONFIG_WIFI_WAKEUP
		case IRQ_GPIO1_NUM:
			if (suspend_from) {
				if (!(readl(PREG_PAD_GPIO4_EN_N)
				      & (0x01 << 6)) && (readl(PREG_PAD_GPIO4_O)
							 & (0x01 << 6)) &&
				    !(readl(PREG_PAD_GPIO4_I)
				      & (0x01 << 7)))
					exit_reason = WIFI_WAKEUP;
			}
			break;
#endif
		default:
			break;
		}
		*irq = 0xffffffff;
		if (exit_reason)
			break;
		else
			asm volatile ("wfi");
	} while (1);
	wakeup_timer_clear();
	restore_ao_timer();
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
#ifdef CONFIG_AML_LED
	scp_led_register(&pwm_scp_led);
#endif
}
