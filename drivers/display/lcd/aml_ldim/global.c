/*
 * drivers/display/lcd/lcd_bl_ldim/global_bl.c
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 */

#include <common.h>
#include <malloc.h>
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_ldim.h>
#include "../aml_lcd_reg.h"
#include "../aml_lcd_common.h"
#include "ldim_drv.h"
#include "ldim_dev_drv.h"

static int global_on_flag;

static int global_hw_init_on(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	ldim_set_duty_pwm(&(ldim_drv->ldev_conf->ldim_pwm_config));
	ldim_set_duty_pwm(&(ldim_drv->ldev_conf->analog_pwm_config));

	ldim_drv->pinmux_ctrl(1);
	mdelay(2);
	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio, ldim_drv->ldev_conf->en_gpio_on);
	mdelay(20);

	return 0;
}

static int global_hw_init_off(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	ldim_drv->pinmux_ctrl(0);
	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio, ldim_drv->ldev_conf->en_gpio_off);

	return 0;
}

static unsigned int global_get_value(unsigned int level)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	unsigned int val;
	unsigned int dim_max, dim_min;

	dim_max = ldim_drv->ldev_conf->dim_max;
	dim_min = ldim_drv->ldev_conf->dim_min;

	val = dim_min + ((level * (dim_max - dim_min)) / LD_DATA_MAX);

	return val;
}

static int global_smr(unsigned short *buf, unsigned char len)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();
	unsigned short val;

	val = global_get_value(buf[0]);
	ldim_drv->ldev_conf->ldim_pwm_config.pwm_duty = val;

	if (global_on_flag == 0) {
		if (lcd_debug_print_flag)
			LDIMPR("%s: on_flag=%d\n", __func__, global_on_flag);
		return 0;
	}

	if (len != 1) {
		LDIMERR("%s: data len %d invalid\n", __func__, len);
		return -1;
	}

	ldim_set_duty_pwm(&(ldim_drv->ldev_conf->ldim_pwm_config));

	return 0;
}

static void global_dim_range_update(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();
	struct ldim_dev_config_s *ldim_dev;

	ldim_dev = ldim_drv->ldev_conf;
	ldim_dev->dim_max = ldim_dev->ldim_pwm_config.pwm_duty_max;
	ldim_dev->dim_min = ldim_dev->ldim_pwm_config.pwm_duty_min;
}

static int global_power_on(void)
{
	global_hw_init_on();
	global_on_flag = 1;

	LDIMPR("%s: ok\n", __func__);
	return 0;
}

static int global_power_off(void)
{
	global_on_flag = 0;
	global_hw_init_off();

	LDIMPR("%s: ok\n", __func__);
	return 0;
}

static int global_ldim_driver_update(struct aml_ldim_driver_s *ldim_drv)
{
	struct ldim_dev_config_s *ldim_dev = ldim_drv->ldev_conf;

	ldim_dev->ldim_pwm_config.pwm_duty_max = ldim_dev->dim_max;
	ldim_dev->ldim_pwm_config.pwm_duty_min = ldim_dev->dim_min;
	ldim_dev->dim_range_update = global_dim_range_update;

	ldim_drv->device_power_on = global_power_on;
	ldim_drv->device_power_off = global_power_off;
	ldim_drv->device_bri_update = global_smr;

	return 0;
}

int ldim_dev_global_probe(struct aml_ldim_driver_s *ldim_drv)
{
	global_on_flag = 0;
	global_ldim_driver_update(ldim_drv);

	return 0;
}

int ldim_dev_global_remove(struct aml_ldim_driver_s *ldim_drv)
{
	return 0;
}

