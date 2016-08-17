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

static void power_off_ports(void)
{
	/* GPIOAO.BIT4 - USB HUB RST_N */
	aml_update_bits(AO_GPIO_O_EN_N, 1<<4, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<20, 0);
}

static void power_off_3v3(void)
{
	//aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	//aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 1<<18);
}
static void power_on_3v3(void)
{
	//aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	//aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 0);
}

/*odroidc2	GPIOAO_2  powr on	:1, power_off	:0*/
static void power_off_vcck(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 0);
}
static void power_on_vcck(void)
{
	aml_update_bits(AO_GPIO_O_EN_N, 1<<2, 0);
	aml_update_bits(AO_GPIO_O_EN_N, 1<<18, 1<<18);
}

static void power_off_at_clk81(void)
{
	power_off_ports();
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

unsigned int pinmux_2, pinmux_3, pinmux_4;
unsigned int pinmux_ao, pinmux_ao_2;

/*
 * GPIOX BIT19
 * UPS - AC_OK
 * suspend/resume : input
 */
void set_GPIOX_BIT19(void)
{
	/* Step 1. save original pinmux 2 */
	pinmux_2 = readl(P_PERIPHS_PIN_MUX_2);

	/* Step 2. clear all alternative function */
	aml_update_bits(PERIPHS_PIN_MUX_2, (1 << 22), 0);
	aml_update_bits(PERIPHS_PIN_MUX_2, (1 << 30), 0);

	/* Step 3. set GPIOX.BIT19 as input */
	aml_update_bits((0xc8834400 + (0x18 << 2)), (1 << 19), (1 << 19));
}

/*
 * GPIOX BIT11
 * UPS - BAT_OK
 * suspend/resume : input
 */
void set_GPIOX_BIT11(void)
{
	/* Step 1. save original pinmux 3 */
	pinmux_3 = readl(P_PERIPHS_PIN_MUX_3);

	/* Step 2. clear all alternative function */
	aml_update_bits(PERIPHS_PIN_MUX_3, (1 << 27), 0);

	/* Step 3. set GPIOX.BIT11 as input */
	aml_update_bits((0xc8834400 + (0x18 << 2)), (1 << 11), (1 << 11));
}

/*
 * GPIOY Bit14
 * UPS - LATCH
 * Suspend : output low
 * Resume : output high
 */
void set_GPIOY_BIT14(void)
{
	/* Step 1. save original pinmux */
	/* Step 2. clear all alternative function */

	/* Step 3. set output */
	aml_update_bits((0xc8834400 + (0x0F << 2)), (1 << 14), 0);	// Set GPIOY_14 to output
	aml_update_bits((0xc8834400 + (0x10 << 2)), (1 << 14), 0);	// set GPIOY_14 to low

	/* Set some delays */
	_udelay(200);
	_udelay(200);
	_udelay(200);
	_udelay(200);
	_udelay(200);
}

/*
 * GPIOAO Bit11
 * Suspend : output high
 * Resume : output low
 */
void set_GPIOAO_BIT13(void)
{
	/* Step 1. save original AO_REG & AO_REG2 */
	pinmux_ao = readl(P_AO_RTI_PIN_MUX_REG);
	pinmux_ao_2 = readl(P_AO_RTI_PIN_MUX_REG2);

	/* Step 2. clear all alternative function */
	/* ao_reg[31], ao_reg[4], ao_reg[3], ao_reg2[1]  */
	aml_update_bits(AO_RTI_PIN_MUX_REG, (1 << 31), 0);
	aml_update_bits(AO_RTI_PIN_MUX_REG, (1 << 4), 0);
	aml_update_bits(AO_RTI_PIN_MUX_REG, (1 << 3), 0);
	aml_update_bits(AO_RTI_PIN_MUX_REG2, (1 << 1), 0);

	/* Step 3. set output */
	aml_update_bits((0xc8100000 + (0x09 << 2)), (1 << 9), 0); // Set GPIOAO_13 to output
	aml_update_bits((0xc8100000 + (0x09 << 2)), (1 << 29), (1 << 29)); // set GPIOAO_13 to high
}

void set_custom_gpio_status(void)
{
	set_GPIOAO_BIT13();
	set_GPIOX_BIT11();
	set_GPIOX_BIT19();
	set_GPIOY_BIT14();
}

void clear_custom_gpio_status(void)
{
	/* Restore pinmux 3 and 4 */
	writel(pinmux_3,P_PERIPHS_PIN_MUX_3);
	writel(pinmux_4,P_PERIPHS_PIN_MUX_4);

	/* Restore pinmux ao and ao2 */
	writel(pinmux_ao,P_AO_RTI_PIN_MUX_REG);
	writel(pinmux_ao_2,P_AO_RTI_PIN_MUX_REG2);
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
	/* set some gpios to intended status before suspend */
	set_custom_gpio_status();

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
#if 0
		if ((readl(AO_GPIO_I) & (1<<3)) == 0) {
				exit_reason = POWER_KEY_WAKEUP;
				break;
		}
#endif
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
#ifdef CONFIG_BT_WAKEUP
		if (!(readl(PREG_PAD_GPIO4_EN_N) & (0x01 << 20)) &&
			(readl(PREG_PAD_GPIO4_O) & (0x01 << 20)) &&
			!(readl(PREG_PAD_GPIO4_I) & (0x01 << 21))) {
			exit_reason = BT_WAKEUP;
			break;
		}
#endif
#ifdef CONFIG_WIFI_WAKEUP
		if (!(readl(PREG_PAD_GPIO4_EN_N) & (0x01 << 6)) &&
			(readl(PREG_PAD_GPIO4_O) & (0x01 << 6)) &&
			!(readl(PREG_PAD_GPIO4_I) & (0x01 << 7))) {
			exit_reason = WIFI_WAKEUP;
			break;
		}
#endif
	} while (1);

	/* restore the original value before entering suspend */
	// clear_custom_gpio_status();

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

