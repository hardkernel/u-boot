
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
#include <config.h>

static unsigned int pwm_voltage_table[][2] = {
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

static void pwm_set_voltage(unsigned int id, unsigned int voltage)
{
	int to;

	uart_puts("set vddee to 0x");
	uart_put_hex(voltage, 16);
	uart_puts("mv\n");
	for (to = 0; to < ARRAY_SIZE(pwm_voltage_table); to++) {
		if (pwm_voltage_table[to][1] >= voltage) {
			break;
		}
	}
	if (to >= ARRAY_SIZE(pwm_voltage_table)) {
		to = ARRAY_SIZE(pwm_voltage_table) - 1;
	}
	switch (id) {
	case pwm_b:
		P_PWM_PWM_B = pwm_voltage_table[to][0];
		break;

	case pwm_ao_b:
		P_AO_PWM_PWM_B1 = pwm_voltage_table[to][0];
		break;
	case pwm_d:
		P_PWM_PWM_D = pwm_voltage_table[to][0];
		break;
	default:
		break;
	}
	_udelay(200);
}


/*p310:GPIOAO_2: L= POWER on mode, H = standby mode*/

static void power_off_3v3_5v(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 1<<18);
}
static void power_on_3v3_5v(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 0);
}

/*p310	GPIOAO_3  powr on	:1, standby	:0*/
static void power_off_vcck(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<3, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<19, 0);
}
static void power_on_vcck(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<3, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<19, 1<<19);
}


static void power_off_at_clk81(void)
{
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_SLEEP_VOLTAGE);	// reduce power
	power_off_3v3_5v();
	power_off_vcck();
}

static void power_on_at_clk81(unsigned int suspend_from)
{
	pwm_set_voltage(pwm_ao_b, CONFIG_VDDEE_INIT_VOLTAGE);
	power_on_vcck();
	power_on_3v3_5v();
}

static void power_off_at_24M(void)
{
}
static void power_on_at_24M(void)
{
}

static void power_off_at_32k(unsigned int suspend_from)
{
}
static void power_on_at_32k(unsigned int suspend_from)
{
}

static void wakeup_timer_setup(void)
{
	/* 1ms resolution*/
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value |= ((0x3<<0) | (0x1<<12) | (0x1<<16));
	writel(value, P_ISA_TIMER_MUX);
	writel(10, P_ISA_TIMERA);
}
static void wakeup_timer_clear(void)
{
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value &= ~((0x1<<12) | (0x1<<16));
	writel(value, P_ISA_TIMER_MUX);
}

static void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;
	p->gpio_info_count = 0;
	p->status = RESPONSE_OK;
	val = (AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC);

#ifdef CONFIG_CEC_WAKEUP
	val |= CEC_WAKEUP_SRC;
#endif

	p->sources = val;

}
static unsigned int detect_key(unsigned int suspend_from)
{
	int exit_reason = 0;
	unsigned int time_out = readl(AO_DEBUG_REG2);
	unsigned time_out_ms = time_out*100;
	unsigned *irq = (unsigned *)SECURE_TASK_SHARE_IRQ;
	/* unsigned *wakeup_en = (unsigned *)SECURE_TASK_RESPONSE_WAKEUP_EN; */

	/* setup wakeup resources*/
	/*auto suspend: timerA 10ms resolution*/
	if (time_out_ms != 0)
		wakeup_timer_setup();

	init_remote();
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		remote_cec_hw_reset();
		cec_node_init();
	}
#endif

	/* *wakeup_en = 1;*/
	do {
		switch (*irq) {
#ifdef CONFIG_CEC_WAKEUP
		case IRQ_AO_CEC_NUM:
			if (cec_msg.log_addr) {
				if (hdmi_cec_func_config & 0x1) {
					cec_handler();
					if (cec_msg.cec_power == 0x1) {
						/*cec power key*/
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

		case IRQ_AO_IR_DEC_NUM:
			if (remote_detect_key())
				exit_reason = REMOTE_WAKEUP;
			break;

		default:
			break;
		}
		*irq = 0xffffffff;
		if (exit_reason)
			break;
		else
			asm volatile("wfi");
	} while (1);

	wakeup_timer_clear();
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
