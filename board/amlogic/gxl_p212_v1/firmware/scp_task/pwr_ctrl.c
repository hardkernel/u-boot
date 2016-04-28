/*p200/201	GPIOAO_2  powr on	:0, power_off	:1*/

#define __SUSPEND_FIRMWARE__
#include <config.h>
#undef __SUSPEND_FIRMWARE__

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

#ifdef CONFIG_CEC_WAKEUP
#include <cec_tx_reg.h>
#endif
#include <gpio-gxbb.h>

extern int pwm_voltage_table[31][2];

#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))

#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_B		(*((volatile unsigned *)(0xc1100000 + (0x2155 << 2))))
#define P_PWM_MISC_REG_CD	(*((volatile unsigned *)(0xc1100000 + (0x2192 << 2))))
#define P_PWM_PWM_D		(*((volatile unsigned *)(0xc1100000 + (0x2191 << 2))))

#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))
#define ON 1
#define OFF 0
enum pwm_id {
    pwm_a = 0,
    pwm_b,
    pwm_c,
    pwm_d,
    pwm_e,
    pwm_f,
};

void pwm_set_voltage(unsigned int id, unsigned int voltage)
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

	case pwm_d:
		P_PWM_PWM_D = pwm_voltage_table[to][0];
		break;
	default:
		break;
	}
	_udelay(200);
}
/*GPIOH_3*/
static void hdmi_5v_ctrl(unsigned int ctrl)
{
	if (ctrl == ON) {
		aml_update_bits(PREG_PAD_GPIO1_EN_N, 1 << 23, 0);
		aml_update_bits(PREG_PAD_GPIO1_O, 1 << 23, 0);
	} else {
		aml_update_bits(PREG_PAD_GPIO1_EN_N, 1 << 23, 0);
		aml_update_bits(PREG_PAD_GPIO1_O, 1 << 23, 1 << 23);
	}
}
/*GPIODV_25*/
static void vcck_ctrl(unsigned int ctrl)
{
	if (ctrl == ON) {
		aml_update_bits(PREG_PAD_GPIO0_EN_N, 1 << 25, 0);
		aml_update_bits(PREG_PAD_GPIO0_O, 1 << 25, 1 << 25);
		/* vcc = 1.1v resume*/
		pwm_set_voltage(pwm_d, 1100);
	} else {
		aml_update_bits(PREG_PAD_GPIO0_EN_N, 1 << 25, 0);
		aml_update_bits(PREG_PAD_GPIO0_O, 1 << 25, 0);
	}
}

static void power_off_at_clk81(void)
{
	hdmi_5v_ctrl(OFF);
	vcck_ctrl(OFF);
	pwm_set_voltage(pwm_b, CONFIG_VDDEE_SLEEP_VOLTAGE);	// reduce power
}
static void power_on_at_clk81(void)
{
	pwm_set_voltage(pwm_b, CONFIG_VDDEE_INIT_VOLTAGE);
	vcck_ctrl(ON);
	hdmi_5v_ctrl(ON);
}

static void power_off_at_24M(void)
{
	/* LED GPIODV_24*/
	aml_update_bits(PREG_PAD_GPIO0_EN_N, 1 << 24, 0);
	aml_update_bits(PREG_PAD_GPIO0_O, 1 << 24, 0);
}

static void power_on_at_24M(void)
{
	aml_update_bits(PREG_PAD_GPIO0_EN_N, 1 << 24, 0);
	aml_update_bits(PREG_PAD_GPIO0_O, 1 << 24, 1 << 24);
}

static void power_off_at_32k(void)
{
}

static void power_on_at_32k(void)
{
}

void get_wakeup_source(void *response, unsigned int suspend_from)
{
	struct wakeup_info *p = (struct wakeup_info *)response;
	unsigned val;
	struct wakeup_gpio_info *gpio;

	p->status = RESPONSE_OK;
	val = (POWER_KEY_WAKEUP_SRC | AUTO_WAKEUP_SRC | REMOTE_WAKEUP_SRC);
#ifdef CONFIG_CEC_WAKEUP
	if (suspend_from != SYS_POWEROFF)
		val |= CEC_WAKEUP_SRC;
#endif
	p->sources = val;

	/* Power Key: AO_GPIO[3]*/
	gpio = &(p->gpio_info[0]);
	gpio->wakeup_id = POWER_KEY_WAKEUP_SRC;
	gpio->gpio_in_idx = GPIOAO_2;
	gpio->gpio_in_ao = 1;
	gpio->gpio_out_idx = -1;
	gpio->gpio_out_ao = -1;
	gpio->irq = IRQ_AO_GPIO0_NUM;
	gpio->trig_type = GPIO_IRQ_FALLING_EDGE;

	p->gpio_info_count = 1;
}
void wakeup_timer_setup(void)
{
	/* 1ms resolution*/
	unsigned value;
	value = readl(P_ISA_TIMER_MUX);
	value |= ((0x3<<0) | (0x1<<12) | (0x1<<16));
	writel(value, P_ISA_TIMER_MUX);
	/*10ms generate an interrupt*/
	writel(10, P_ISA_TIMERA);
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
	unsigned *irq = (unsigned *)SECURE_TASK_SHARE_IRQ;
	unsigned int ret;
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
			if (suspend_from == SYS_POWEROFF)
				break;
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
			ret = remote_detect_key();
			if (ret == 1)
				exit_reason = REMOTE_WAKEUP;
			if (ret == 2)
				exit_reason = REMOTE_CUS_WAKEUP;
			break;

		case IRQ_AO_GPIO0_NUM:
			if ((readl(AO_GPIO_I) & (1<<2)) == 0)
				exit_reason = POWER_KEY_WAKEUP;
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

