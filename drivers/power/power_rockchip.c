/*
 * pmic auto compatible driver on rockchip platform
 * Copyright (C) 2008-2015 Fuzhou Rockchip Electronics Co., Ltd
 * Andy <yxj@rock-chips.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <errno.h>
#include <power/rockchip_power.h>
#include <power/battery.h>
//#include <asm/arch/rkplat.h>
//#include <fastboot.h>

DECLARE_GLOBAL_DATA_PTR;

#if defined(CONFIG_POWER_RK818)
extern void pmic_rk818_power_init(void);
extern void pmic_rk818_power_on(void);
extern void pmic_rk818_power_off(void);
#endif

int low_power_level = 3;

int get_power_bat_status(struct battery *battery)
{
	struct pmic *p_fg = NULL;

	p_fg = pmic_get("RK818_FG");

	if (p_fg) {
		p_fg->pbat->bat = battery;
		if (p_fg->fg->fg_battery_update)
			p_fg->fg->fg_battery_update(p_fg, p_fg);
	} else {
		printf("no fuel gauge found\n");
		return -ENODEV;
	}

	return 0;
}

/*
return 0: bat exist
return 1: bat no exit
*/
int is_exist_battery(void)
{
	int ret;
	struct battery battery;
	memset(&battery,0, sizeof(battery));
	ret = get_power_bat_status(&battery);
	if (ret < 0)
		return 0;
	return battery.isexistbat;
}

/*
return 0: no charger
return 1: charging
*/
int is_charging(void)
{
	int ret;
	struct battery battery;

	memset(&battery,0, sizeof(battery));

	ret = get_power_bat_status(&battery);
	if (ret < 0)
		return 0;
	return battery.state_of_chrg;
}

int pmic_charger_setting(int current)
{
	return 0;
}

/*system on thresd*/
int is_power_low(void)
{
	int ret;
	struct battery battery;
	memset(&battery, 0, sizeof(battery));
	ret = get_power_bat_status(&battery);
	if (ret < 0)
		return 0;

	if (battery.capacity < low_power_level)
		return 1;

	return (battery.voltage_uV < CONFIG_SYSTEM_ON_VOL_THRESD) ? 1 : 0;
}

int pmic_init(unsigned char  bus)
{
	int ret = -1;

#if defined(CONFIG_POWER_RK818)
	ret = pmic_rk818_init (bus);
	if (ret >= 0) {
		printf("pmic:rk818\n");
		return 0;
	}
#endif
	return ret;
}


int fg_init(unsigned char bus)
{
	return 0;
}

void plat_charger_init(void)
{
}

void shut_down(void)
{
	pmic_rk818_shut_down();
}

// shutdown no use ldo
void power_pmic_init(void){
	
	pmic_rk818_power_init();
}

// by wakeup open ldo
void power_on_pmic(void){	
	pmic_rk818_power_on();
}


// by wakeup close ldo
void power_off_pmic(void){
	pmic_rk818_power_off();
}


