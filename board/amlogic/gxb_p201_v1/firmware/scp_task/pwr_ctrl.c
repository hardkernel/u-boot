/*p200/201	GPIOAO_2  powr on	:0, power_off	:1*/

#define __SUSPEND_FIRMWARE__
#include <config.h>
#undef __SUSPEND_FIRMWARE__

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

#ifdef CONFIG_CEC_WAKEUP
#include <cec_tx_reg.h>
#endif

extern int pwm_voltage_table[31][2];

#define P_PIN_MUX_REG3		(*((volatile unsigned *)(0xda834400 + (0x2f << 2))))
#define P_PIN_MUX_REG7		(*((volatile unsigned *)(0xda834400 + (0x33 << 2))))

#define P_PWM_MISC_REG_AB	(*((volatile unsigned *)(0xc1100000 + (0x2156 << 2))))
#define P_PWM_PWM_B		(*((volatile unsigned *)(0xc1100000 + (0x2155 << 2))))
#define P_PWM_MISC_REG_CD	(*((volatile unsigned *)(0xc1100000 + (0x2196 << 2))))
#define P_PWM_PWM_D		(*((volatile unsigned *)(0xc1100000 + (0x2195 << 2))))

#define P_EE_TIMER_E		(*((volatile unsigned *)(0xc1100000 + (0x2662 << 2))))

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

static void power_off_3v3(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 1<<18);
}
static void power_on_3v3(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 0);
}

/*p200/201	GPIOAO_4  powr on	:1, power_off	:0*/
static void power_off_vcck(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<4, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<20, 0);
}
static void power_on_vcck(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<4, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<20, 1<<20);
}

static void power_off_at_clk81(void)
{
	power_off_3v3();
	power_off_vcck();
	pwm_set_voltage(pwm_d, CONFIG_VDDEE_SLEEP_VOLTAGE);	// reduce power
}
static void power_on_at_clk81(void)
{
	pwm_set_voltage(pwm_d, CONFIG_VDDEE_INIT_VOLTAGE);
	power_on_vcck();
	power_on_3v3();
}

static void power_off_at_24M(void)
{
	//LED gpioao_13
	aml_update_bits(AO_GPIO_O_EN_N, 1<<29, 0);
}

static void power_on_at_24M(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<29, 1<<29);
}

static void power_off_at_32k(void)
{
}

static void power_on_at_32k(void)
{
}

unsigned int detect_key(unsigned int suspend_from)
{

	int exit_reason = 0;
	unsigned int time_out = readl(AO_DEBUG_REG2);
	unsigned int init_time = get_time();
	init_remote();
#ifdef CONFIG_CEC_WAKEUP
	if (hdmi_cec_func_config & 0x1) {
		remote_cec_hw_reset();
		cec_node_init();
	}
#endif
	do {
	#ifdef CONFIG_CEC_WAKEUP
		if (cec_msg.log_addr) {
			if (hdmi_cec_func_config & 0x1) {
				cec_handler();
				if (cec_msg.cec_power == 0x1) {  //cec power key
					exit_reason = CEC_WAKEUP;
					break;
				}
			}
		} else if (hdmi_cec_func_config & 0x1) {
			cec_node_init();
		}
	#endif
		if ((readl(AO_GPIO_I) & (1<<3)) ==0) {
				exit_reason = POWER_KEY_WAKEUP;
				break;
		}

		if (time_out != 0) {
			if ((get_time() - init_time) >= time_out * 1000 * 1000) {
				exit_reason = AUTO_WAKEUP;
				break;
			}
		}
		if (remote_detect_key()) {
			exit_reason = REMOTE_WAKEUP;
			break;
		}
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
}

