/*
 * drivers/display/lcd/lcd_tv/lcd_tv.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
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
*/

#include <common.h>
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include <amlogic/aml_lcd.h>
#include "../aml_lcd_reg.h"
#include "../aml_lcd_common.h"
#include "lcd_tv.h"

enum {
	LCD_OUTPUT_MODE_768P = 0,
	LCD_OUTPUT_MODE_768P50HZ,
	LCD_OUTPUT_MODE_1080P,
	LCD_OUTPUT_MODE_1080P50HZ,
	LCD_OUTPUT_MODE_4K2K60HZ420,
	LCD_OUTPUT_MODE_4K2K50HZ420,
	LCD_OUTPUT_MODE_4K2K60HZ,
	LCD_OUTPUT_MODE_4K2K50HZ,
	LCD_OUTPUT_MODE_MAX,
};

struct lcd_info_s {
	char *name;
	int width;
	int height;
	int sync_duration_num;
	int sync_duration_den;
};

static struct lcd_info_s lcd_info[] = {
	{
		.name              = "768p60hz",
		.width             = 1366,
		.height            = 768,
		.sync_duration_num = 60,
		.sync_duration_den = 1,
	},
	{
		.name              = "768p50hz",
		.width             = 1366,
		.height            = 768,
		.sync_duration_num = 50,
		.sync_duration_den = 1,
	},
	{
		.name              = "1080p60hz",
		.width             = 1920,
		.height            = 1080,
		.sync_duration_num = 60,
		.sync_duration_den = 1,
	},
	{
		.name              = "1080p50hz",
		.width             = 1920,
		.height            = 1080,
		.sync_duration_num = 50,
		.sync_duration_den = 1,
	},
	{
		.name              = "2160p60hz420",
		.width             = 3840,
		.height            = 2160,
		.sync_duration_num = 60,
		.sync_duration_den = 1,
	},
	{
		.name              = "2160p50hz420",
		.width             = 3840,
		.height            = 2160,
		.sync_duration_num = 50,
		.sync_duration_den = 1,
	},
	{
		.name              = "2160p60hz",
		.width             = 3840,
		.height            = 2160,
		.sync_duration_num = 60,
		.sync_duration_den = 1,
	},
	{
		.name              = "2160p50hz",
		.width             = 3840,
		.height            = 2160,
		.sync_duration_num = 50,
		.sync_duration_den = 1,
	},
	{
		.name              = "invalid",
		.width             = 1920,
		.height            = 1080,
		.sync_duration_num = 60,
		.sync_duration_den = 1,
	},
};

static int lcd_vmode_is_mached(struct lcd_config_s *pconf, int vmode)
{
	if ((pconf->lcd_basic.h_active != lcd_info[vmode].width) ||
		(pconf->lcd_basic.v_active != lcd_info[vmode].height)) {
		LCDERR("outputmode[%s] and panel_type is not match\n",
			lcd_info[vmode].name);
		return -1;
	}
	return 0;
}

static int check_lcd_output_mode(struct lcd_config_s *pconf, char *mode)
{
	int vmode, i;
	int ret;

	for (i = 0; i < ARRAY_SIZE(lcd_info); i++) {
		if (strcmp(mode, lcd_info[i].name) == 0)
			break;
	}
	vmode = i;
	if (vmode >= LCD_OUTPUT_MODE_MAX) {
		LCDERR("outputmode[%s] is not support\n", mode);
		return LCD_OUTPUT_MODE_MAX;
	}
	ret = lcd_vmode_is_mached(pconf, vmode);
	if (ret)
		return LCD_OUTPUT_MODE_MAX;

	pconf->lcd_timing.sync_duration_num = lcd_info[vmode].sync_duration_num;
	pconf->lcd_timing.sync_duration_den = lcd_info[vmode].sync_duration_den;

	return vmode;
}

static void lcd_list_support_mode(void)
{
	int i;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_basic_s *lcd_basic;

	lcd_basic = &lcd_drv->lcd_config->lcd_basic;
	for (i = 0; i < (ARRAY_SIZE(lcd_info) - 1); i++) {
		if ((lcd_basic->h_active == lcd_info[i].width) &&
		(lcd_basic->v_active == lcd_info[i].height)) {
			printf("%s\n", lcd_info[i].name);
		}
	}
}

static void lcd_config_load_print(struct lcd_config_s *pconf)
{
	if (lcd_debug_print_flag == 0)
		return;

	LCDPR("%s, %s, %dbit, %dx%d\n",
		pconf->lcd_basic.model_name,
		lcd_type_type_to_str(pconf->lcd_basic.lcd_type),
		pconf->lcd_basic.lcd_bits,
		pconf->lcd_basic.h_active, pconf->lcd_basic.v_active);

	LCDPR("h_period = %d\n", pconf->lcd_basic.h_period);
	LCDPR("v_period = %d\n", pconf->lcd_basic.v_period);

	LCDPR("hsync_width = %d\n", pconf->lcd_timing.hsync_width);
	LCDPR("hsync_bp = %d\n", pconf->lcd_timing.hsync_bp);
	LCDPR("hsync_pol = %d\n", pconf->lcd_timing.hsync_pol);
	LCDPR("vsync_width = %d\n", pconf->lcd_timing.vsync_width);
	LCDPR("vsync_bp = %d\n", pconf->lcd_timing.vsync_bp);
	LCDPR("vsync_pol = %d\n", pconf->lcd_timing.vsync_pol);

	LCDPR("fr_adjust_type = %d\n", pconf->lcd_timing.fr_adjust_type);
	LCDPR("ss_level = %d\n", pconf->lcd_timing.ss_level);
	LCDPR("clk_auto = %d\n", pconf->lcd_timing.clk_auto);

	if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
		LCDPR("lane_count = %d\n", pconf->lcd_control.vbyone_config->lane_count);
		LCDPR("byte_mode = %d\n", pconf->lcd_control.vbyone_config->byte_mode);
		LCDPR("region_num = %d\n", pconf->lcd_control.vbyone_config->region_num);
		LCDPR("color_fmt = %d\n", pconf->lcd_control.vbyone_config->color_fmt);
	} else if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
		LCDPR("lvds_repack = %d\n", pconf->lcd_control.lvds_config->lvds_repack);
		LCDPR("pn_swap = %d\n", pconf->lcd_control.lvds_config->pn_swap);
		LCDPR("dual_port = %d\n", pconf->lcd_control.lvds_config->dual_port);
		LCDPR("port_swap = %d\n", pconf->lcd_control.lvds_config->port_swap);
	}
}

#ifdef CONFIG_OF_LIBFDT
static int lcd_config_load_from_dts(char *dt_addr, struct lcd_config_s *pconf)
{
	int parent_offset;
	int child_offset;
	char propname[30];
	char *propdata;
	char *p;
	const char *str;
	int i, j, temp;

	parent_offset = fdt_path_offset(dt_addr, "/lcd");
	if (parent_offset < 0) {
		LCDERR("not find /lcd node: %s\n",fdt_strerror(parent_offset));
		return -1;
	}

	/* check panel_type */
	char *panel_type = getenv("panel_type");
	if (panel_type == NULL) {
		LCDERR("no panel_type, use default lcd config\n ");
		return -1;
	}
	LCDPR("use panel_type=%s\n", panel_type);

	sprintf(propname, "/lcd/%s", panel_type);
	child_offset = fdt_path_offset(dt_addr, propname);
	if (child_offset < 0) {
		LCDERR("not find /lcd/%s node: %s\n",
			panel_type, fdt_strerror(child_offset));
		return -1;
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "model_name", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get model_name\n");
		strcpy(pconf->lcd_basic.model_name, panel_type);
	} else {
		strcpy(pconf->lcd_basic.model_name, propdata);
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "interface", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get interface\n");
		return -1;
	} else {
		pconf->lcd_basic.lcd_type = lcd_type_str_to_type(propdata);
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "basic_setting", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get basic_setting\n");
		return -1;
	} else {
		pconf->lcd_basic.h_active = be32_to_cpup((u32*)propdata);
		pconf->lcd_basic.v_active = be32_to_cpup((((u32*)propdata)+1));
		pconf->lcd_basic.h_period = be32_to_cpup((((u32*)propdata)+2));
		pconf->lcd_basic.v_period = be32_to_cpup((((u32*)propdata)+3));
		pconf->lcd_basic.lcd_bits = be32_to_cpup((((u32*)propdata)+4));
		pconf->lcd_basic.screen_width = be32_to_cpup((((u32*)propdata)+5));
		pconf->lcd_basic.screen_height = be32_to_cpup((((u32*)propdata)+6));
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "lcd_timing", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get lcd_timing\n");
		return -1;
	} else {
		pconf->lcd_timing.hsync_width = (unsigned short)(be32_to_cpup((u32*)propdata));
		pconf->lcd_timing.hsync_bp    = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
		pconf->lcd_timing.hsync_pol   = (unsigned short)(be32_to_cpup((((u32*)propdata)+2)));
		pconf->lcd_timing.vsync_width = (unsigned short)(be32_to_cpup((((u32*)propdata)+3)));
		pconf->lcd_timing.vsync_bp    = (unsigned short)(be32_to_cpup((((u32*)propdata)+4)));
		pconf->lcd_timing.vsync_pol   = (unsigned short)(be32_to_cpup((((u32*)propdata)+5)));
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "clk_attr", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get clk_attr\n");
		pconf->lcd_timing.fr_adjust_type = 0;
		pconf->lcd_timing.ss_level = 0;
		pconf->lcd_timing.clk_auto = 1;
	} else {
		pconf->lcd_timing.fr_adjust_type = (unsigned char)(be32_to_cpup((u32*)propdata));
		pconf->lcd_timing.ss_level = (unsigned char)(be32_to_cpup((((u32*)propdata)+1)));
		pconf->lcd_timing.clk_auto = (unsigned char)(be32_to_cpup((((u32*)propdata)+2)));
	}

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_LVDS:
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "lvds_attr", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get lvds_attr\n");
		} else {
			pconf->lcd_control.lvds_config->lvds_repack = be32_to_cpup((u32*)propdata);
			pconf->lcd_control.lvds_config->dual_port   = be32_to_cpup((((u32*)propdata)+1));
			pconf->lcd_control.lvds_config->pn_swap     = be32_to_cpup((((u32*)propdata)+2));
			pconf->lcd_control.lvds_config->port_swap   = be32_to_cpup((((u32*)propdata)+3));
		}
		break;
	case LCD_VBYONE:
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "vbyone_attr", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get vbyone_attr\n");
		} else {
			pconf->lcd_control.vbyone_config->lane_count = be32_to_cpup((u32*)propdata);
			pconf->lcd_control.vbyone_config->region_num = be32_to_cpup((((u32*)propdata)+1));
			pconf->lcd_control.vbyone_config->byte_mode  = be32_to_cpup((((u32*)propdata)+2));
			pconf->lcd_control.vbyone_config->color_fmt  = be32_to_cpup((((u32*)propdata)+3));
		}
		break;
	default:
		LCDERR("invalid lcd type\n");
		break;
	}

	/* check power_step */
	i = 0;
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "lcd_cpu_gpio_names", NULL);
	if (propdata == NULL) {
		LCDPR("failed to get lcd_cpu_gpio_names\n");
	} else {
		p = propdata;
		while (i < LCD_CPU_GPIO_NUM_MAX) {
			if (i > 0)
				p += strlen(p) + 1;
			str = p;
			if (strlen(str) == 0)
				break;
			strcpy(pconf->lcd_power->cpu_gpio[i], str);
			if (lcd_debug_print_flag) {
				LCDPR("i=%d, gpio=%s\n",
					i, pconf->lcd_power->cpu_gpio[i]);
			}
			i++;
		}
	}
	for (j = i; j < LCD_CPU_GPIO_NUM_MAX; j++) {
		strcpy(pconf->lcd_power->cpu_gpio[j], "invalid");
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "power_on_step", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get power_on_step\n");
		return 0;
	} else {
		i = 0;
		while (i < LCD_PWR_STEP_MAX) {
			j = 4 * i;
			temp = be32_to_cpup((((u32*)propdata)+j));
			pconf->lcd_power->power_on_step[i].type = temp;
			if (temp == 0xff)
				break;
			temp = be32_to_cpup((((u32*)propdata)+j+1));
			pconf->lcd_power->power_on_step[i].index = temp;
			temp = be32_to_cpup((((u32*)propdata)+j+2));
			pconf->lcd_power->power_on_step[i].value = temp;
			temp = be32_to_cpup((((u32*)propdata)+j+3));
			pconf->lcd_power->power_on_step[i].delay = temp;
			i++;
		}
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "power_off_step", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get power_off_step\n");
		return 0;
	} else {
		i = 0;
		while (i < LCD_PWR_STEP_MAX) {
			j = 4 * i;
			temp = be32_to_cpup((((u32*)propdata)+j));
			pconf->lcd_power->power_off_step[i].type = temp;
			if (temp == 0xff)
				break;
			temp = be32_to_cpup((((u32*)propdata)+j+1));
			pconf->lcd_power->power_off_step[i].index = temp;
			temp = be32_to_cpup((((u32*)propdata)+j+2));
			pconf->lcd_power->power_off_step[i].value = temp;
			temp = be32_to_cpup((((u32*)propdata)+j+3));
			pconf->lcd_power->power_off_step[i].delay = temp;
			i++;
		}
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "backlight_index", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get backlight_index\n");
		pconf->backlight_index = 0;
		return 0;
	} else {
		pconf->backlight_index = be32_to_cpup((u32*)propdata);
	}

	return 0;
}
#endif

static int lcd_config_load_from_bsp(struct lcd_config_s *pconf)
{
	struct ext_lcd_config_s *ext_lcd = NULL;
	char *panel_type = getenv("panel_type");
	unsigned int i, j;
	unsigned int temp;
	struct lcd_power_step_s *power_step;

	if (panel_type == NULL) {
		LCDERR("no panel_type, use default lcd config\n ");
		return 0;
	}
	for (i = 0 ; i < LCD_NUM_MAX ; i++) {
		ext_lcd = &ext_lcd_config[i];
		if (strcmp(ext_lcd->panel_type, panel_type) == 0)
			break ;
	}
	if (i >= LCD_NUM_MAX) {
		LCDERR("can't find %s, use default lcd config\n ", panel_type);
		return 0;
	}
	LCDPR("use panel_type=%s\n", panel_type);

	strcpy(pconf->lcd_basic.model_name, panel_type);
	pconf->lcd_basic.lcd_type = ext_lcd->lcd_type;
	pconf->lcd_basic.lcd_bits = ext_lcd->lcd_bits;

	pconf->lcd_basic.h_active = ext_lcd->h_active;
	pconf->lcd_basic.v_active = ext_lcd->v_active;
	pconf->lcd_basic.h_period = ext_lcd->h_period;
	pconf->lcd_basic.v_period = ext_lcd->v_period;
	pconf->lcd_timing.hsync_width = ext_lcd->hsync_width;
	pconf->lcd_timing.hsync_bp    = ext_lcd->hsync_bp;
	pconf->lcd_timing.hsync_pol    = ext_lcd->hsync_pol;
	pconf->lcd_timing.vsync_width = ext_lcd->vsync_width;
	pconf->lcd_timing.vsync_bp    = ext_lcd->vsync_bp;
	pconf->lcd_timing.vsync_pol    = ext_lcd->vsync_pol;

	/* fr_adjust_type */
	temp = ext_lcd->customer_val_0;
	if (temp == Rsv_val)
		pconf->lcd_timing.fr_adjust_type = 0;
	else
		pconf->lcd_timing.fr_adjust_type = (unsigned char)temp;
	/* ss_level */
	temp = ext_lcd->customer_val_1;
	if (temp == Rsv_val)
		pconf->lcd_timing.ss_level = 0;
	else
		pconf->lcd_timing.ss_level = (unsigned char)temp;
	/* clk_auto_generate */
	temp = ext_lcd->customer_val_2;
	if (temp == Rsv_val)
		pconf->lcd_timing.clk_auto = 1;
	else
		pconf->lcd_timing.clk_auto = (unsigned char)temp;

	if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
		pconf->lcd_control.vbyone_config->lane_count = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.vbyone_config->region_num = ext_lcd->lcd_spc_val1;
		pconf->lcd_control.vbyone_config->byte_mode  = ext_lcd->lcd_spc_val2;
		pconf->lcd_control.vbyone_config->color_fmt  = ext_lcd->lcd_spc_val3;
	} else if (pconf->lcd_basic.lcd_type == LCD_TTL) {
		LCDPR("this is ttl att \n");
	} else if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
		pconf->lcd_control.lvds_config->lvds_repack = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.lvds_config->dual_port   = ext_lcd->lcd_spc_val1;
		pconf->lcd_control.lvds_config->pn_swap     = ext_lcd->lcd_spc_val2;
		pconf->lcd_control.lvds_config->port_swap   = ext_lcd->lcd_spc_val3;
	}

	i = 0;
	while (i < LCD_PWR_STEP_MAX) {
		power_step = &ext_lcd->power_on_step[i];
		if (lcd_debug_print_flag) {
			LCDPR("power_on: step %d: type=%d, index=%d, value=%d, delay=%d\n",
				i, power_step->type, power_step->index,
				power_step->value, power_step->delay);
		}
		pconf->lcd_power->power_on_step[i].type = power_step->type;
		pconf->lcd_power->power_on_step[i].index = power_step->index;
		pconf->lcd_power->power_on_step[i].value = power_step->value;
		pconf->lcd_power->power_on_step[i].delay = power_step->delay;
		if (power_step->type >= LCD_POWER_TYPE_MAX)
			break;
		else
			i++;
	}

	i = 0;
	while (i < LCD_PWR_STEP_MAX) {
		power_step = &ext_lcd->power_off_step[i];
		if (lcd_debug_print_flag) {
			LCDPR("power_off: step %d: type=%d, index=%d, value=%d, delay=%d\n",
				i, power_step->type, power_step->index,
				power_step->value, power_step->delay);
		}
		pconf->lcd_power->power_off_step[i].type = power_step->type;
		pconf->lcd_power->power_off_step[i].index = power_step->index;
		pconf->lcd_power->power_off_step[i].value = power_step->value;
		pconf->lcd_power->power_off_step[i].delay = power_step->delay;
		if (power_step->type >= LCD_POWER_TYPE_MAX)
			break;
		else
			i++;
	}

	i = 0;
	while (i < LCD_CPU_GPIO_NUM_MAX) {
		if (strcmp(pconf->lcd_power->cpu_gpio[i], "invalid") == 0)
			break;
		i++;
	}
	for (j = i; j < LCD_CPU_GPIO_NUM_MAX; j++) {
		strcpy(pconf->lcd_power->cpu_gpio[j], "invalid");
	}

	return 0;
}

static void lcd_config_init(struct lcd_config_s *pconf)
{
	unsigned int clk;

	clk = pconf->lcd_basic.h_period * pconf->lcd_basic.v_period * 60;
	pconf->lcd_timing.lcd_clk = clk;
	pconf->lcd_timing.sync_duration_num = 60;
	pconf->lcd_timing.sync_duration_den = 1;

	lcd_tcon_config(pconf);
}

static int lcd_config_check(char *mode)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int vmode;

	vmode = check_lcd_output_mode(lcd_drv->lcd_config, mode);
	if (vmode >= LCD_OUTPUT_MODE_MAX)
		return -1;

	lcd_drv->lcd_config->lcd_timing.sync_duration_num = lcd_info[vmode].sync_duration_num;
	lcd_drv->lcd_config->lcd_timing.sync_duration_den = lcd_info[vmode].sync_duration_den;
	/* update clk & timing config */
	lcd_vmode_change(lcd_drv->lcd_config);
	lcd_tv_config_update(lcd_drv->lcd_config);

	return 0;
}

int get_lcd_tv_config(char *dt_addr, int load_id)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	strcpy(lcd_drv->version, LCD_DRV_VERSION);
	lcd_drv->list_support_mode = lcd_list_support_mode;
	lcd_drv->driver_init = lcd_tv_driver_init;
	lcd_drv->driver_disable = lcd_tv_driver_disable;
	lcd_drv->config_check = lcd_config_check;

	if (load_id == 1 ) {
#ifdef CONFIG_OF_LIBFDT
		lcd_config_load_from_dts(dt_addr, lcd_drv->lcd_config);
#endif
	} else {
		lcd_config_load_from_bsp(lcd_drv->lcd_config);
	}
	lcd_config_load_print(lcd_drv->lcd_config);
	lcd_config_init(lcd_drv->lcd_config);

	return 0;
}


