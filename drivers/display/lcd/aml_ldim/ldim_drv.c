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

static struct ldim_config_s ldim_config = {
	.row = 1,
	.col = 1,
};

static int ldim_power_on(void)
{
	if (ldim_driver.device_power_on)
		ldim_driver.device_power_on();
	else
		LDIMERR("%s: device_power_on is null\n", __func__);
	ldim_on_flag = 1;

	if (ldim_level > 0)
		ldim_set_level(ldim_level);

	return 0;
}
static int ldim_power_off(void)
{
	ldim_on_flag = 0;
	if (ldim_driver.device_power_off)
		ldim_driver.device_power_off();
	else
		LDIMERR("%s: device_power_off is null\n", __func__);

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

	ldim_level = level;
	if (ldim_on_flag == 0)
		return 0;

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
	LDIMPR("%s:\n", __func__);
	printf("valid_flag            = %d\n"
		"dev_index             = %d\n"
		"ldim_blk_row          = %d\n"
		"ldim_blk_col          = %d\n"
		"ldim_on_flag          = %d\n",
		ldim_driver.valid_flag,
		ldim_driver.dev_index,
		ldim_blk_row,
		ldim_blk_col,
		ldim_on_flag);
	if (ldim_driver.device_config_print)
		ldim_driver.device_config_print();
}

static struct aml_ldim_driver_s ldim_driver = {
	.valid_flag = 0, /* default invalid, active when bl_ctrl_method=ldim */
	.dev_index = 0,
	.ldim_conf = &ldim_config,
	.ldev_conf = NULL,
	.ldim_matrix_buf = NULL,
	.power_on = ldim_power_on,
	.power_off = ldim_power_off,
	.set_level = ldim_set_level,
	.config_print = ldim_config_print,
	.pinmux_ctrl = NULL,
	.device_config_print = NULL,
	.device_power_on = NULL,
	.device_power_off = NULL,
	.device_bri_update = NULL,
};

struct aml_ldim_driver_s *aml_ldim_get_driver(void)
{
	return &ldim_driver;
}

#ifdef CONFIG_OF_LIBFDT
int ldim_config_load_from_dts(char *dt_addr, int child_offset)
{
	char *propdata;

	if (child_offset < 0) {
		LDIMERR("not find backlight node %s\n", fdt_strerror(child_offset));
		return -1;
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_ldim_region_row_col", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get bl_ldim_region_row_col\n");
		ldim_blk_row = 1;
		ldim_blk_col = 1;
	} else {
		ldim_blk_row = be32_to_cpup((u32*)propdata);
		ldim_blk_col = be32_to_cpup((((u32*)propdata)+1));
		ldim_config.row = ldim_blk_row;
		ldim_config.col = ldim_blk_col;
	}
	LDIMPR("get region row = %d, col = %d\n", ldim_blk_row, ldim_blk_col);

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "ldim_dev_index", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get ldim_dev_index\n");
		ldim_driver.dev_index = 0xff;
	} else {
		ldim_driver.dev_index = be32_to_cpup((u32*)propdata);
	}
	LDIMPR("get dev_index = %d\n", ldim_driver.dev_index);

	return 0;
}
#endif

int ldim_config_load_from_unifykey(unsigned char *para)
{
	unsigned char *p;

	if (para == NULL) {
		LDIMERR("backlight unifykey buf is NULL\n");
		return -1;
	}

	p = para;

	/* ldim: 24byte */
	/* get bl_ldim_region_row_col 4byte*/
	ldim_blk_row = *(p + LCD_UKEY_BL_LDIM_ROW);
	ldim_blk_col = *(p + LCD_UKEY_BL_LDIM_COL);
	ldim_config.row = ldim_blk_row;
	ldim_config.col = ldim_blk_col;
	LDIMPR("get region row = %d, col = %d\n", ldim_blk_row, ldim_blk_col);

	/* get ldim_dev_index 1byte*/
	ldim_driver.dev_index = *(p + LCD_UKEY_BL_LDIM_DEV_INDEX);
	LDIMPR("get dev_index = %d\n", ldim_driver.dev_index);

	return 0;
}

int aml_ldim_probe(char *dt_addr, int flag)
{
	unsigned int size;
	int ret = -1;

	ldim_on_flag = 0;
	ldim_level = 0;

	switch (flag) {
	case 0: /* dts */
	case 2: /* unifykey */
#ifdef CONFIG_OF_LIBFDT
		if (dt_addr) {
			if (lcd_debug_print_flag)
				LDIMPR("load ldim_dev_config from dts\n");
			ret = aml_ldim_device_probe(dt_addr);
		}
#endif
		break;
	case 1: /* bsp */
		LDIMPR("%s: not support bsp config\n", __func__);
		break;
	default:
		break;
	}

	if (ret) {
		LDIMERR("%s failed\n", __func__);
		return ret;
	}

	size = ldim_blk_row * ldim_blk_col;
	ldim_driver.ldim_matrix_buf = (unsigned short *)malloc(sizeof(unsigned short) * size);
	if (ldim_driver.ldim_matrix_buf == NULL) {
		LDIMERR("ldim_matrix_buf malloc error\n");
		return -1;
	}

	ldim_driver.valid_flag = 1;

	LDIMPR("%s is ok\n", __func__);

	return ret;
}

