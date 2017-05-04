
/*
 * arch/arm/cpu/armv8/xx/power_cal.c
 *
 * Copyright (C) 2016 Amlogic, Inc. All rights reserved.
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

#include <common.h>
#include <asm/arch/gpio.h>
#include <asm/arch/secure_apb.h>
#include <asm/arch/io.h>
#include <asm/saradc.h>
#include <asm/arch/mailbox.h>

#define P_EE_TIMER_E		(*((volatile unsigned *)(0xffd00000 + (0x3c62 << 2))))
#define vcck_adc_channel	0x4
#define ee_adc_channel		0x5
#define default_ref_val		1800

extern const int pwm_cal_voltage_table[][2];
extern const int pwm_cal_voltage_table_ee[][2];
extern int pwm_cal_voltage_table_size;
extern int pwm_cal_voltage_table_ee_size;


enum pwm_id {
    pwm_vcck = 0,
    pwm_ee,
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

int32_t aml_delt_get(int adc_val, unsigned int voltage)
{
	unsigned int adc_volt;
	int32_t delt;
	int32_t div = 10;	/*10mv is min step*/

	if (adc_val != -1) {
		adc_volt = default_ref_val*adc_val/1024;
		printf("aml pwm cal adc_val = %x, adc_voltage = %d, def_voltage = %d\n",
				adc_val, adc_volt, voltage);
	} else {
		adc_volt = voltage;
		printf("warning:aml pwm cal adc get voltage error\n");
		return 0;
	}
	delt = voltage - adc_volt;
	delt = delt / div;
	return delt;
}

void aml_set_voltage(unsigned int id, unsigned int voltage, int delt)
{
	int to;

	switch (id) {
	case pwm_vcck:
		for (to = 0; to < pwm_cal_voltage_table_size; to++) {
			if (pwm_cal_voltage_table[to][1] >= voltage) {
				break;
			}
		}
		to +=delt;
		if (to >= pwm_cal_voltage_table_size) {
			to = pwm_cal_voltage_table_size - 1;
		}
		/*vcck volt set by dvfs and avs*/
		//writel(pwm_voltage_table[to][0], PWM_PWM_A_ADRESS);
		_udelay_(200);
		break;

	case pwm_ee:
		for (to = 0; to < pwm_cal_voltage_table_ee_size; to++) {
			if (pwm_cal_voltage_table_ee[to][1] >= voltage) {
				break;
				}
		}
		to +=delt;
		if (to >= pwm_cal_voltage_table_ee_size) {
			to = pwm_cal_voltage_table_ee_size - 1;
		}
		printf("aml pwm cal before ee_address: %x, ee_voltage: %x\n",
				AO_PWM_PWM_B, readl(AO_PWM_PWM_B));
		writel(pwm_cal_voltage_table_ee[to][0],AO_PWM_PWM_B);
		_udelay_(1000);
		printf("aml pwm cal after ee_address: %x, ee_voltage: %x\n",
				AO_PWM_PWM_B, readl(AO_PWM_PWM_B));
		break;
	default:
		break;
	}
	_udelay_(200);
}

void aml_cal_pwm(unsigned int ee_voltage, unsigned int vcck_voltage)
{
	int32_t ee_delt, vcck_delt;
	unsigned int ee_val, vcck_val;
	/*txlx vcck ch4,vddee ch5*/
	vcck_val = get_adc_sample_gxbb(vcck_adc_channel);
	ee_val = get_adc_sample_gxbb(ee_adc_channel);
	vcck_delt = aml_delt_get(vcck_val, vcck_voltage);
	ee_delt = aml_delt_get(ee_val, ee_voltage);
	send_pwm_delt(vcck_delt, ee_delt);
	aml_set_voltage(pwm_ee, CONFIG_VDDEE_INIT_VOLTAGE, ee_delt);
	//aml_set_voltage(pwm_vcck, CONFIG_VCCK_INIT_VOLTAGE, vcck_delt);
	printf("aml board pwm vcck: %x, ee: %x\n", vcck_delt, ee_delt);
}

void aml_pwm_cal_init(int mode)
{
	printf("aml pwm cal init\n");
	saradc_enable();
	aml_cal_pwm(CONFIG_VDDEE_INIT_VOLTAGE, CONFIG_VCCK_INIT_VOLTAGE);
	saradc_disable();
}
