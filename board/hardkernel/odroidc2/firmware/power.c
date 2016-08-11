#include "config.h"
#include <serial.h>
#include <stdio.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

static int pwm_voltage_table[][2] = {
	{ 0x10f001b,  860},
	{ 0x1050025,  870},
	{ 0x0fc002e,  880},
	{ 0x0f30037,  890},
	{ 0x0ea0040,  900},
	{ 0x0e10049,  910},
	{ 0x0d60054,  920},
	{ 0x0cb005f,  930},
	{ 0x0c0006a,  940},
	{ 0x0b50075,  950},
	{ 0x0aa0080,  960},
	{ 0x0a0008a,  970},
	{ 0x0960094,  980},
	{ 0x08d009d,  990},
	{ 0x07b00af, 1000},
	{ 0x07200b8, 1010},
	{ 0x06900c1, 1020},
	{ 0x06000ca, 1030},
	{ 0x05700d3, 1040},
	{ 0x04e00dc, 1050},
	{ 0x04500e5, 1060},
	{ 0x03c00ee, 1070},
	{ 0x03300f7, 1080},
	{ 0x02a0100, 1090},
	{ 0x0180109, 1100},
	{ 0x00f011b, 1110},
	{ 0x00a0120, 1120},
	{ 0x0050125, 1130},
	{ 0x000012a, 1140}
};

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

unsigned int _get_time(void)
{
	return P_EE_TIMER_E;
}

void _udelay_(unsigned int us)
{
	unsigned int t0 = _get_time();

	while (_get_time() - t0 <= us)
		;
}

void pwm_init(int id)
{
	unsigned int reg;

	/*
	 * TODO: support more pwm controllers, right now only support
	 * PWM_B, PWM_D
	 */

	switch (id) {
	case pwm_b:
		reg = P_PWM_MISC_REG_AB;
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1));
		P_PWM_MISC_REG_AB = reg;
		/*
		 * default set to max voltage
		 */
		P_PWM_PWM_B = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_REG7;
		reg &= ~(1 << 22);
		P_PIN_MUX_REG7 = reg;

		reg  = P_PIN_MUX_REG3;
		reg &= ~(1 << 22);
		reg |=  (1 << 21);		// enable PWM_B
		P_PIN_MUX_REG3 = reg;
		break;

	case pwm_d:
		reg = P_PWM_MISC_REG_CD;
		reg &= ~(0x7f << 16);
		reg |=  ((1 << 23) | (1 << 1));
		P_PWM_MISC_REG_CD = reg;
		/*
		 * default set to max voltage
		 */
		P_PWM_PWM_D = pwm_voltage_table[ARRAY_SIZE(pwm_voltage_table) - 1][0];
		reg  = P_PIN_MUX_REG7;
		reg &= ~(1 << 23);
		P_PIN_MUX_REG7 = reg;

		reg  = P_PIN_MUX_REG3;
		reg |=  (1 << 20);		// enable PWM_D
		P_PIN_MUX_REG3 = reg;
		break;
	default:
		break;
	}

	_udelay_(200);
}

void pwm_set_voltage(unsigned int id, unsigned int voltage)
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
	case pwm_b:
		P_PWM_PWM_B = pwm_voltage_table[to][0];
		break;

	case pwm_d:
		P_PWM_PWM_D = pwm_voltage_table[to][0];
		break;
	default:
		break;
	}
	_udelay_(200);
}

void power_init(int mode)
{
	pwm_init(pwm_b);
	pwm_init(pwm_d);
	serial_puts("set vcck to ");
	serial_put_dec(CONFIG_VCCK_INIT_VOLTAGE);
	serial_puts(" mv\n");
	pwm_set_voltage(pwm_b, CONFIG_VCCK_INIT_VOLTAGE);
	serial_puts("set vddee to ");
	serial_put_dec(CONFIG_VDDEE_INIT_VOLTAGE);
	serial_puts(" mv\n");
	pwm_set_voltage(pwm_d, CONFIG_VDDEE_INIT_VOLTAGE);
}
