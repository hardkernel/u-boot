/*
 * drivers/display/lcd/lcd_bl_ldim/ldim_drv.c
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

#define LD_DATA_MIN           10
#define LDIM_BRI_LEVEL_MAX    0xfff
#define LDIM_BRI_LEVEL_MIN    0x7f
static unsigned int ldim_blk_row = 1;
static unsigned int ldim_blk_col = 8;
static struct aml_ldim_driver_s ldim_driver;

static int ldim_on_flag;
static int ldim_level;
static int ldim_set_level(unsigned int level);

static int ldim_power_on(void)
{
	if (ldim_driver.device_power_on) {
		ldim_driver.device_power_on();
		ldim_on_flag = 1;
	}
	if (ldim_level > 0)
		ldim_set_level(ldim_level);

	return 0;
}
static int ldim_power_off(void)
{
	ldim_on_flag = 0;
	if (ldim_driver.device_power_off)
		ldim_driver.device_power_off();

	return 0;
}

static void ldim_brightness_update(unsigned int level)
{
	unsigned int size;
	unsigned int i;

	size = ldim_blk_row * ldim_blk_col;
	for (i = 0; i < size; i++)
		ldim_driver.ldim_matrix_buf[i] = (unsigned short)level;

	if (ldim_driver.device_bri_update)
		ldim_driver.device_bri_update(ldim_driver.ldim_matrix_buf, size);
	else
		LDIMPR("%s: device_bri_update is null\n", __func__);
}

static int ldim_set_level(unsigned int level)
{
	int ret = 0;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	unsigned int level_max, level_min;

	if (ldim_on_flag == 0) {
		ldim_level = level;
		return 0;
	}

	level_max = lcd_drv->bl_config->level_max;
	level_min = lcd_drv->bl_config->level_min;

	level = ((level - level_min) * (LD_DATA_MAX - LD_DATA_MIN)) /
		(level_max - level_min) + LD_DATA_MIN;
	level &= 0xfff;
	ldim_brightness_update(level);

	return ret;
}

static void ldim_config_print(void)
{
	struct bl_pwm_config_s *ld_pwm;

	LDIMPR("%s:\n", __func__);
	printf("valid_flag            = %d\n"
		"dev_index             = %d\n"
		"ldim_on_flag          = %d\n",
		ldim_driver.valid_flag,
		ldim_driver.dev_index,
		ldim_on_flag);
	if (ldim_driver.ldev_conf) {
		ld_pwm = &ldim_driver.ldev_conf->pwm_config;
		printf("dev_name              = %s\n"
			"cs_hold_delay         = %d\n"
			"cs_clk_delay          = %d\n"
			"en_gpio               = %d\n"
			"en_gpio_on            = %d\n"
			"en_gpio_off           = %d\n"
			"write_check           = %d\n"
			"dim_min               = 0x%03x\n"
			"dim_max               = 0x%03x\n"
			"cmd_size              = %d\n",
			ldim_driver.ldev_conf->name,
			ldim_driver.ldev_conf->cs_hold_delay,
			ldim_driver.ldev_conf->cs_clk_delay,
			ldim_driver.ldev_conf->en_gpio,
			ldim_driver.ldev_conf->en_gpio_on,
			ldim_driver.ldev_conf->en_gpio_off,
			ldim_driver.ldev_conf->write_check,
			ldim_driver.ldev_conf->dim_min,
			ldim_driver.ldev_conf->dim_max,
			ldim_driver.ldev_conf->cmd_size);
		if (ld_pwm->pwm_port < BL_PWM_MAX) {
			printf("pwm_port              = %d\n"
				"pwm_pol               = %d\n"
				"pwm_freq              = %d\n"
				"pwm_duty              = %d%%\n"
				"pinmux_flag           = %d\n",
				ld_pwm->pwm_port, ld_pwm->pwm_method,
				ld_pwm->pwm_freq, ld_pwm->pwm_duty,
				ld_pwm->pinmux_flag);
		}
	} else {
		printf("device config is null\n");
	}
}

static struct aml_ldim_driver_s ldim_driver = {
	.valid_flag = 0, /* default invalid, active when bl_ctrl_method=ldim */
	.dev_index = 0,
	.ldev_conf = NULL,
	.ldim_matrix_buf = NULL,
	.power_on = ldim_power_on,
	.power_off = ldim_power_off,
	.set_level = ldim_set_level,
	.config_print = ldim_config_print,
	.pinmux_ctrl = NULL,
	.device_power_on = NULL,
	.device_power_off = NULL,
	.device_bri_update = NULL,
};

struct aml_ldim_driver_s *aml_ldim_get_driver(void)
{
	return &ldim_driver;
}

#ifdef CONFIG_OF_LIBFDT
static int ldim_config_load_from_dts(char *dt_addr)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int parent_offset;
	char *propdata;
	char propname[30];
	int child_offset;
	unsigned int index;

	parent_offset = fdt_path_offset(dt_addr, "/backlight");
	if (parent_offset < 0) {
		LDIMERR("not find /backlight node %s\n", fdt_strerror(parent_offset));
		return -1;
	}

	index = lcd_drv->lcd_config->backlight_index;
	sprintf(propname,"/backlight/backlight_%d", index);
	child_offset = fdt_path_offset(dt_addr, propname);
	if (child_offset < 0) {
		LDIMERR("not find %s node %s\n", propname, fdt_strerror(child_offset));
		return -1;
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_ldim_region_row_col", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get bl_ldim_region_row_col\n");
		ldim_blk_row = 1;
		ldim_blk_col = 8;
	} else {
		ldim_blk_row = be32_to_cpup((u32*)propdata);
		ldim_blk_col = be32_to_cpup((((u32*)propdata)+1));
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "ldim_dev_index", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get ldim_dev_index\n");
		ldim_driver.dev_index = 0;
	} else {
		ldim_driver.dev_index = be32_to_cpup((u32*)propdata);
	}

	return 0;
}
#endif

int aml_ldim_probe(char *dt_addr, int flag)
{
	unsigned int size;
	int ret = 0;

	ldim_on_flag = 0;
	ldim_level = 0;

	switch (flag) {
	case 0: /* dts */
#ifdef CONFIG_OF_LIBFDT
		if (dt_addr) {
			if (lcd_debug_print_flag)
				LDIMPR("load ldim_config from dts\n");
			ldim_config_load_from_dts(dt_addr);
			ret = aml_ldim_device_probe(dt_addr);
		}
#endif
		break;
	case 1:
		break;
	case 2:
		break;
	default:
		break;
	}
	size = ldim_blk_row * ldim_blk_col;
	ldim_driver.ldim_matrix_buf = (unsigned short *)malloc(sizeof(unsigned short) * size);
	if (ldim_driver.ldim_matrix_buf == NULL) {
		LDIMERR("ldim_matrix_buf malloc error\n");
		return -1;
	}

	ldim_driver.valid_flag = 1;

	return ret;
}

