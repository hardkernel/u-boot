/*
 * (C) Copyright 2008-2015 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#ifndef __ROCKCHIP_PMIC_H_
#define __ROCKCHIP_PMIC_H_
#include <power/pmic.h>

enum pmic_id {
	PMIC_ID_UNKNOW,
	PMIC_ID_RICOH619,
	PMIC_ID_ACT8846,
	PMIC_ID_RK805,
	PMIC_ID_RK808,
	PMIC_ID_RK816,
	PMIC_ID_RK818,
	PMIC_ID_RT5025,
	PMIC_ID_RT5036,
	PMIC_ID_ACT8931,
};

/* rockchip first i2c node as parent for pmic */
extern int g_i2c_node;

unsigned char get_rockchip_pmic_id(void);
int dwc_otg_check_dpdm(void);
int is_charging(void);
int is_power_low(void);
unsigned int get_battery_cap(void);

int pmic_rk818_init(unsigned char bus);
int pmic_rk818_charger_setting(int current);
void pmic_rk818_shut_down(void);

int fg_rk818_init(unsigned char bus,uchar addr);

struct regulator_init_reg_name {
	const char *name;
};

#define MAX_DCDC_NUM			5
#define MAX_REGULATOR_NUM		20
#define MAX_PWM_NUM			3

extern struct regulator_init_reg_name regulator_init_pmic_matches[MAX_REGULATOR_NUM];
extern struct regulator_init_reg_name regulator_init_pwm_matches[MAX_PWM_NUM];

int regulator_register_check(int num_matches);


u8 rk818_pwron_source(void);


#endif /* __ROCKCHIP_PMIC_H_ */
