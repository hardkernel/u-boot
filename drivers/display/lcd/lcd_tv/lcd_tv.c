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
#include <amlogic/aml_lcd_tv.h>
#ifdef CONFIG_AML_LCD_EXTERN
#include <amlogic/aml_lcd_extern.h>
#endif
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
	LCDPR("panel_type = %s\n", pconf->lcd_basic.model_name);

	if (lcd_debug_print_flag == 0)
		return;

	LCDPR("lcd_type = %s, lcd_bits = %d \n",
		lcd_type_type_to_str(pconf->lcd_basic.lcd_type),
		pconf->lcd_basic.lcd_bits);
	LCDPR("h_active = %d\n", pconf->lcd_basic.h_active);
	LCDPR("v_active = %d\n", pconf->lcd_basic.v_active);
	LCDPR("h_period = %d\n", pconf->lcd_basic.h_period);
	LCDPR("v_period = %d\n", pconf->lcd_basic.v_period);

	LCDPR("hsync_width = %d\n", pconf->lcd_timing.hsync_width);
	LCDPR("hsync_bp = %d\n", pconf->lcd_timing.hsync_bp);
	LCDPR("vsync_width = %d\n", pconf->lcd_timing.vsync_width);
	LCDPR("vsync_bp = %d\n", pconf->lcd_timing.vsync_bp);

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
static int lcd_config_load_from_dtd(char *dt_addr, struct lcd_config_s *pconf)
{
	int parent_offset;
	int child_offset;
	char propname[30];
	char *propdata;
	//struct fdt_property *prop;
	//char *p;
	//const char *str;
	//int i;

	parent_offset = fdt_path_offset(dt_addr, "/lcd");
	if (parent_offset < 0) {
		LCDERR("not find /lcd node: %s\n",fdt_strerror(parent_offset));
		return -1;
	}

	/* check lcd_mode */
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "mode", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get mode\n");
		return -1;
	} else {
		pconf->lcd_mode = lcd_mode_str_to_mode(propdata);
	}
	if (pconf->lcd_mode != LCD_MODE_TV) {
		LCDERR("lcd_mode is not match, exit\n");
		return -1;
	}

	/* check panel_type */
	char *panel_type = getenv("panel_type");
	if (panel_type == NULL) {
		LCDERR("no panel_type, use default lcd config\n ");
		return -1;
	}
	sprintf(propname, "/lcd/%s", panel_type);
	child_offset = fdt_path_offset(dt_addr, propname);
	if (child_offset < 0) {
		LCDERR("not find /lcd/%s node: %s\n",
			panel_type, fdt_strerror(child_offset));
		return -1;
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
		pconf->lcd_timing.hsync_width    = be32_to_cpup((((u32*)propdata)+3));
		pconf->lcd_timing.hsync_bp       = be32_to_cpup((((u32*)propdata)+4));
		pconf->lcd_timing.vsync_width    = be32_to_cpup((((u32*)propdata)+5));
		pconf->lcd_timing.vsync_bp       = be32_to_cpup((((u32*)propdata)+6));
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
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "lvds_att", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get lvds_att\n");
		} else {
			pconf->lcd_control.lvds_config->lvds_repack = be32_to_cpup((u32*)propdata);
			pconf->lcd_control.lvds_config->pn_swap     = be32_to_cpup((((u32*)propdata)+1));
			pconf->lcd_control.lvds_config->dual_port   = be32_to_cpup((((u32*)propdata)+2));
			pconf->lcd_control.lvds_config->port_swap   = be32_to_cpup((((u32*)propdata)+3));
		}
		break;
	case LCD_VBYONE:
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "vbyone_att", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get vbyone_att\n");
		} else {
			pconf->lcd_control.vbyone_config->lane_count = be32_to_cpup((u32*)propdata);
			pconf->lcd_control.vbyone_config->byte_mode  = be32_to_cpup((((u32*)propdata)+1));
			pconf->lcd_control.vbyone_config->region_num = be32_to_cpup((((u32*)propdata)+2));
			pconf->lcd_control.vbyone_config->color_fmt  = be32_to_cpup((((u32*)propdata)+3));
		}
		break;
	default:
		LCDERR("failed to get basic_setting\n");
		break;
	}
#if 0
	/* check power_step */
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "lcd_cpu_gpio_names", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get lcd_cpu_gpio_names\n");
	} else {
		prop = container_of(propdata, struct fdt_property, data);
		p = prop->data;
		while (i < LCD_CPU_GPIO_NUM_MAX) {
			p += strlen(p) + 1;
			str = p;
			LCDPR("i=%d, str=%s\n", i, str);
			sprintf(propname, "PIN_%s", str);
			pconf->lcd_power->cpu_gpio[i] = aml_lcd_gpio_name_map_num(propname);
			i++;
		}
		if (i < (LCD_CPU_GPIO_NUM_MAX - 1))
			pconf->lcd_power->cpu_gpio[i] = LCD_GPIO_MAX;
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "power_on_step", NULL);
	if (propdata == NULL) {
		LCDERR("error: failed to get power_on_step\n");
		return 0;
	} else {
		//temp = gpioname_to_pin(propdata);
		temp = -1;
		if (temp < 0) {
			LCDERR("error: wrong gpio number %s\n", propdata);
			return 0;
		}
		pconf->lcd_power->gpio = temp;
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "power_off_step", NULL);
	if (propdata == NULL) {
		LCDERR("error: failed to get power_off_step\n");
		return 0;
	} else {
		pconf->lcd_power->on_value  = be32_to_cpup((u32*)propdata);
		pconf->lcd_power->off_value = be32_to_cpup((((u32*)propdata)+1));
		pconf->lcd_power->on_delay = be32_to_cpup((((u32*)propdata)+2));
		pconf->lcd_power->off_delay = be32_to_cpup((((u32*)propdata)+3));
	}
#endif
#ifdef CONFIG_AML_LCD_EXTERN
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "lcd_extern_att", NULL);
	if (propdata == NULL) {
		LCDPR("no lcd_extern_att\n");
		return 0;
	} else {
		pconf->lcd_control.ext_config->index = be32_to_cpup((u32*)propdata);
		pconf->lcd_control.ext_config->on_delay = be32_to_cpup((((u32*)propdata)+2));
		pconf->lcd_control.ext_config->off_delay = be32_to_cpup((((u32*)propdata)+3));
	}
#endif

	return 0;
}
#endif

static int lcd_config_load_from_bsp(struct lcd_config_s *pconf)
{
	struct ext_lcd_config_s *ext_lcd = NULL;
	char *panel_type = getenv("panel_type");
	unsigned int i = 0;
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

	strcpy(pconf->lcd_basic.model_name, panel_type);
	pconf->lcd_basic.lcd_type = ext_lcd->lcd_type;
	pconf->lcd_basic.lcd_bits = ext_lcd->lcd_bits;

	pconf->lcd_basic.h_active = ext_lcd->h_active;
	pconf->lcd_basic.v_active = ext_lcd->v_active;
	pconf->lcd_basic.h_period = ext_lcd->h_period;
	pconf->lcd_basic.v_period = ext_lcd->v_period;
	pconf->lcd_timing.hsync_width = ext_lcd->hsync_width;
	pconf->lcd_timing.hsync_bp    = ext_lcd->hsync_bp;
	pconf->lcd_timing.vsync_width = ext_lcd->vsync_width;
	pconf->lcd_timing.vsync_bp    = ext_lcd->vsync_bp;

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
	if (i < (LCD_PWR_STEP_MAX - 1))
		pconf->lcd_power->power_on_step[i].type = LCD_POWER_TYPE_MAX;

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
	if (i < (LCD_PWR_STEP_MAX - 1))
		pconf->lcd_power->power_off_step[i].type = LCD_POWER_TYPE_MAX;

	return 0;
}

#ifdef CONFIG_AML_LCD_EXTERN
static int lcd_extern_load_config(char *dt_addr, struct lcd_config_s *pconf)
{
	struct aml_lcd_extern_driver_s *ext_drv;
	struct lcd_power_step_s *power_step;
	int index, i;

	i = 0;
	while (i < LCD_PWR_STEP_MAX) {
		power_step = &pconf->lcd_power->power_on_step[i];
		if (power_step->type == LCD_POWER_TYPE_EXTERN) {
			if (lcd_debug_print_flag) {
				LCDPR("power_on: step %d: type=%d, index=%d\n",
					i, power_step->type, power_step->index);
			}
			index = power_step->index;
			if (index < LCD_EXTERN_INDEX_INVALID)
				aml_lcd_extern_probe(dt_addr, index);
		}
		if (power_step->type >= LCD_POWER_TYPE_MAX)
			break;
		else
			i++;
	}
}
#endif

#if 0
static int bl_config_load_from_dtd(char *dt_addr, struct bl_config_s *bl_config)
{
#ifdef CONFIG_OF_LIBFDT
	int parent_offset;
	char* propdata;
	char *sel;
	char propname[30];
	int child_offset;

	lcd_printf("\n");
	parent_offset = fdt_path_offset(dt_addr, "/backlight");
	if (parent_offset < 0) {
		printf("lcd error: backlight init: not find /backlight node %s.\n",fdt_strerror(parent_offset));
		return 0;
	}

	char *panel_type = getenv("panel_type");
	if (panel_type == NULL) {
		printf("lcd error: no panel_type use defult lcd config\n ");
		return 0;
	}
	sel = strchr(panel_type,'_');
	sprintf(propname,"/backlight/%s%s","backlight", sel);
	child_offset = fdt_path_offset(dt_addr, propname);
	if (child_offset < 0) {
		printf("lcd error: dts: not find /backlight/%s  node %s.\n",panel_type,fdt_strerror(child_offset));
		return 0;
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_en_gpio", NULL);
	int blacklight_power_pin;
	blacklight_power_pin = gpioname_to_pin(propdata);
	if (blacklight_power_pin<0) {
		printf("lcd error: wrong gpio number %s\n",propdata);	 //----------------//
		return 0;
	}
	if (propdata == NULL) {
		printf("lcd error: faild to get panel_power_pin\n");
		return 0;
	} else {
		bl_config->bl_power.gpio = blacklight_power_pin;

	}
	lcd_printf("dtd_bl:panel_power_pin: %s--%d \n",propdata,bl_config->bl_power.gpio);


	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_en_gpio_on", NULL);
	if (propdata == NULL) {
		printf("lcd error: faild to get backlight/bl_en_gpio_on \n");
		return 0;
	} else {
		bl_config->bl_power.on_value	 = be32_to_cpup((u32*)propdata);
		bl_config->bl_power.off_value  = !( be32_to_cpup((u32*)propdata));
	}
	lcd_printf("dtd_bl:on_value = %d \n",bl_config->bl_power.on_value);
	lcd_printf("dtd_bl:off_value = %d \n",bl_config->bl_power.off_value);


	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_power_on_delay", NULL);
	if (propdata == NULL) {
		printf("lcd error: faild to get backlight/bl_power_on_delay \n");
		return 0;
	} else {
		bl_config->bl_power.bl_on_delay = be32_to_cpup((u32*)propdata);
	}
	lcd_printf("dtd_bl:bl_on_delay = %d \n",bl_config->bl_power.bl_on_delay);


	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_power_off_delay", NULL);
	 if (propdata == NULL) {
		 printf("lcd error: faild to get backlight/bl_power_off_delay \n");
		 return 0;
	 } else {
		 bl_config->bl_power.bl_off_delay = be32_to_cpup((u32*)propdata);
	 }
	 lcd_printf("dtd_bl:bl_off_delay = %d \n",bl_config->bl_power.bl_off_delay);


	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_gpio", NULL);
	 unsigned int pwm_pin;
	 pwm_pin = gpioname_to_pin(propdata);
	 if (pwm_pin<0) {
		 printf("lcd error: wrong gpio number %s\n",propdata);	  //----------------//
		 return 0;
	 }
	 if (propdata == NULL) {
		 printf("lcd error: faild to get bl_pwm_gpio\n");
		 return 0;
	 } else {
		 bl_config->bl_pwm.pwm_gpio = pwm_pin;
	 }
	 lcd_printf("dtd_bl:bl_pwm_gpio: %s--%d \n",propdata,bl_config->bl_pwm.pwm_gpio);

	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_on_delay", NULL);
	 if (propdata == NULL) {
		 printf("lcd error: faild to get backlight/bl_pwm_on_delay \n");
		 return 0;
	 } else {
		 bl_config->bl_pwm.pwm_on_delay = be32_to_cpup((u32*)propdata);
	 }
	 lcd_printf("dtd_bl:pwm_on_delay = %d \n",bl_config->bl_pwm.pwm_on_delay);

	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_off_delay", NULL);
	 if (propdata == NULL) {
		printf("lcd error: faild to get backlight/bl_pwm_off_delay \n");
		return 0;
	 } else {
		bl_config->bl_pwm.pwm_off_delay = be32_to_cpup((u32*)propdata);
	 }
	 lcd_printf("dtd_bl:pwm_off_delay = %d \n",bl_config->bl_pwm.pwm_off_delay);


	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_port", NULL);
	 if (propdata == NULL) {
		 printf("lcd error: faild to get backlight/bl_pwm_port \n");
		 return 0;
	 } else {
		 if (strcmp(propdata, "PWM_A") == 0)
			 bl_config->bl_pwm.pwm_port = BL_PWM_A;
		 else if (strcmp(propdata, "PWM_B") == 0)
			 bl_config->bl_pwm.pwm_port = BL_PWM_B;
		 else if (strcmp(propdata, "PWM_C") == 0)
			 bl_config->bl_pwm.pwm_port = BL_PWM_C;
		 else if (strcmp(propdata, "PWM_D") == 0)
			 bl_config->bl_pwm.pwm_port = BL_PWM_D;
		 else if (strcmp(propdata, "PWM_E") == 0)
			 bl_config->bl_pwm.pwm_port = BL_PWM_E;
		 else if (strcmp(propdata, "PWM_F") == 0)
			 bl_config->bl_pwm.pwm_port = BL_PWM_F;
		 else if (strcmp(propdata, "PWM_VS") == 0)
			 bl_config->bl_pwm.pwm_port = BL_PWM_VS;
	 }
	 lcd_printf("dtd_bl:pwm_port = %d \n",bl_config->bl_pwm.pwm_port);


	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_positive", NULL);
	 if (propdata == NULL) {
		 printf("lcd error: faild to get backlight/pwm_positive\n");
		 return 0;
	 } else {
		 bl_config->bl_pwm.pwm_positive = be32_to_cpup((u32*)propdata);
	 }
	 lcd_printf("dtd_bl:pwm_positive = %d \n",bl_config->bl_pwm.pwm_positive);


	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_freq", NULL);
	 if (propdata == NULL) {
		 printf("lcd error: faild to get backlight/bl_pwm_freq \n");
		 if (bl_config->bl_pwm.pwm_port == BL_PWM_VS)
			 bl_config->bl_pwm.pwm_freq = AML_BL_FREQ_VS_DEF;
		 else
			 bl_config->bl_pwm.pwm_freq = AML_BL_FREQ_DEF;
	 } else {
		 bl_config->bl_pwm.pwm_freq = be32_to_cpup((u32*)propdata);
	 }
	 if (bl_config->bl_pwm.pwm_port == BL_PWM_VS) {
		 if (bl_config->bl_pwm.pwm_freq > 4) {
			 printf("lcd error: faild to get backlight/pwm_positive\n");
			 bl_config->bl_pwm.pwm_freq = AML_BL_FREQ_VS_DEF;
		 }
		 lcd_printf("dtd_bl:pwm_vs_freq = %d x vfreq\n", bl_config->bl_pwm.pwm_freq);
	 } else {
		 if (bl_config->bl_pwm.pwm_freq > XTAL_HALF_FREQ_HZ)
			bl_config->bl_pwm.pwm_freq = XTAL_HALF_FREQ_HZ;
		 lcd_printf("dtd_bl:pwm_freq = %d \n", bl_config->bl_pwm.pwm_freq);
	 }

	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_duty_max_min", NULL);
	 if (propdata == NULL) {
		 printf("lcd error: faild to get backlight/bl_pwm_duty_max_min \n");
		 return 0;
	 } else {
		 bl_config->bl_pwm.pwm_duty_max = be32_to_cpup((u32*)propdata);
		 bl_config->bl_pwm.pwm_duty_min = be32_to_cpup((((u32*)propdata)+1));
	 }
	 lcd_printf("dtd_bl:pwm_duty_max = %d \n",bl_config->bl_pwm.pwm_duty_max);
	 lcd_printf("dtd_bl:pwm_duty_min = %d \n",bl_config->bl_pwm.pwm_duty_min);

	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_level_default_uboot", NULL);
	 if (propdata == NULL) {
		 printf("lcd error: faild to get backlight/bl_level_default_uboot\n");
		 return 0;
	 } else {
		 bl_config->bl_pwm.level_default = be32_to_cpup((u32*)propdata);
	 }
	 lcd_printf("dtd_bl:level_default = %d \n",bl_config->bl_pwm.level_default);


	 propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_level_max_min", NULL);
	 if (propdata == NULL) {
		 printf("lcd error: faild to get backlight/bl_level_max_min \n");
		 return 0;
	 } else {
		 bl_config->bl_pwm.level_max = be32_to_cpup((u32*)propdata);
		 bl_config->bl_pwm.level_min = be32_to_cpup((((u32*)propdata)+1));
	 }
	 lcd_printf("dtd_bl:level_max = %d \n",bl_config->bl_pwm.level_max);
	 lcd_printf("dtd_bl:level_min = %d \n",bl_config->bl_pwm.level_min);

	int len = 0;
	unsigned int i = 0;
	if (bl_config->bl_pwm.pwm_port == BL_PWM_VS)
		parent_offset = fdt_path_offset(dt_addr, "/pinmux/bl_pwm_vs_pins");
	else
		parent_offset = fdt_path_offset(dt_addr, "/pinmux/bl_pwm_pins");
	if (propdata == NULL) {
		printf("lcd error: backlight init: not find /pinmux/%s node %s\n",
			((bl_config->bl_pwm.pwm_port == BL_PWM_VS) ? "bl_pwm_vs_pins" : "bl_pwm_pins"),	fdt_strerror(parent_offset));
		return 0;
	} else {

		propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
		if (propdata == NULL) {
			printf("lcd error: faild to get amlogic,setmask\n");
			return 0;
		} else {
			bl_config->bl_pwm.pinmux_set_num = len / 8;
			for (i=0; i<bl_config->bl_pwm.pinmux_set_num; i++) {
				bl_config->bl_pwm.pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
				bl_config->bl_pwm.pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
			}
		}

		propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
		if (propdata == NULL) {
			printf("lcd error: faild to get amlogic,clrmask\n");
			return 0;
		} else {
			bl_config->bl_pwm.pinmux_clr_num = len / 8;
			for (i=0; i<bl_config->bl_pwm.pinmux_clr_num; i++) {
				bl_config->bl_pwm.pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
				bl_config->bl_pwm.pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
			}

			for (i=0; i<bl_config->bl_pwm.pinmux_set_num; i++) {
				lcd_printf("backlight pinmux set %d: mux_num = %d, mux_mask = 0x%08x\n", i+1, bl_config->bl_pwm.pinmux_set[i][0], bl_config->bl_pwm.pinmux_set[i][1]);
			}
			for (i=0; i<bl_config->bl_pwm.pinmux_clr_num; i++) {
				lcd_printf("backlight pinmux clr %d: mux_num = %d, mux_mask = 0x%08x\n", i+1, bl_config->bl_pwm.pinmux_clr[i][0], bl_config->bl_pwm.pinmux_clr[i][1]);
			}

			return 1;
		}
	}

#endif

	return 0;
}


static int bl_config_load_from_bsp(Lcd_Bl_Config_t *bl_config)
{
	struct ext_lcd_config_s *ext_lcd = NULL;
	char *panel_type = getenv("panel_type");
	unsigned int i = 0;

	if (panel_type == NULL) {
		LCDPR("error: no panel_type, use default lcd config\n ");
		return 0;
	}
	for (i = 0 ; i < LCD_TYPE_MAX ; i++) {
		ext_lcd = &ext_lcd_config[i];
		if (strcmp(ext_lcd->panel_type, panel_type) == 0) {
			LCDPR("use panel_type = %s \n",ext_lcd->panel_type);
			break ;
		}
	}
	if ( i >= LCD_TYPE_MAX ) {
		LCDPR("error: out of range use default bl config\n ");
		return 0;
	}else{
		bl_config->bl_power.gpio		 = ext_lcd->bl_gpio;
		bl_config->bl_power.on_value	 = ext_lcd->bl_on_value;
		bl_config->bl_power.off_value	 = ext_lcd->bl_off_value;
		bl_config->bl_power.bl_on_delay = ext_lcd->bl_on_delay;
		bl_config->bl_power.bl_off_delay= ext_lcd->bl_off_delay;

		bl_config->bl_pwm.pwm_port = ext_lcd->pwm_port;
		bl_config->bl_pwm.pwm_freq = ext_lcd->pwm_freq;
		bl_config->bl_pwm.pwm_duty_max = ext_lcd->pwm_duty_max;
		bl_config->bl_pwm.pwm_duty_min = ext_lcd->pwm_duty_min;
		bl_config->bl_pwm.pwm_positive = ext_lcd->pwm_positive;

		bl_config->bl_pwm.level_default = ext_lcd->level_default;
		bl_config->bl_pwm.level_min = ext_lcd->level_min;
		bl_config->bl_pwm.level_max = ext_lcd->level_max;

		lcd_printf("bl_config:bl_gpio = %d \n",bl_config->bl_power.gpio);
		lcd_printf("bl_config:on_value = %d \n",bl_config->bl_power.on_value);
		lcd_printf("bl_config:off_value = %d \n",bl_config->bl_power.off_value);
		lcd_printf("bl_config:bl_on_delay = %d \n",bl_config->bl_power.bl_on_delay);
		lcd_printf("bl_config:bl_off_delay = %d \n",bl_config->bl_power.bl_off_delay);

		lcd_printf("bl_config:pwm_port = %d \n",bl_config->bl_pwm.pwm_port);
		lcd_printf("bl_config:pwm_freq = %d \n",bl_config->bl_pwm.pwm_freq);
		lcd_printf("bl_config:pwm_duty_max = %d \n",bl_config->bl_pwm.pwm_duty_max);
		lcd_printf("bl_config:pwm_duty_min = %d \n",bl_config->bl_pwm.pwm_duty_min);
		lcd_printf("bl_config:pwm_positive = %d \n",bl_config->bl_pwm.pwm_positive);

		lcd_printf("bl_config:level_default = %d \n",bl_config->bl_pwm.level_default);
		lcd_printf("bl_config:level_min = %d \n",bl_config->bl_pwm.level_min);
		lcd_printf("bl_config:level_max = %d \n",bl_config->bl_pwm.level_max );

		return 1;
	}

	return 0;
}
#endif

static void lcd_tcon_config(struct lcd_config_s *pconf)
{
	unsigned short h_period, v_period, h_active, v_active;
	unsigned short hsync_bp, hsync_width, vsync_bp, vsync_width;
	unsigned short de_hstart, de_vstart;
	unsigned short hstart, hend, vstart, vend;

	h_period = pconf->lcd_basic.h_period;
	v_period = pconf->lcd_basic.v_period;
	h_active = pconf->lcd_basic.h_active;
	v_active = pconf->lcd_basic.v_active;
	hsync_bp = pconf->lcd_timing.hsync_bp;
	hsync_width = pconf->lcd_timing.hsync_width;
	vsync_bp = pconf->lcd_timing.vsync_bp;
	vsync_width = pconf->lcd_timing.vsync_width;

	de_hstart = h_period - h_active - 1;
	de_vstart = v_period - v_active;

	pconf->lcd_timing.video_on_pixel = de_hstart;
	pconf->lcd_timing.video_on_line = de_vstart;

	hstart = (de_hstart + h_period - hsync_bp - hsync_width) % h_period;
	hend = (de_hstart + h_period - hsync_bp) % h_period;
	pconf->lcd_timing.hs_hs_addr = hstart;
	pconf->lcd_timing.hs_he_addr = hend;
	pconf->lcd_timing.hs_vs_addr = 0;
	pconf->lcd_timing.hs_ve_addr = v_period - 1;

	pconf->lcd_timing.vs_hs_addr = (hstart + h_period) % h_period;
	pconf->lcd_timing.vs_he_addr = pconf->lcd_timing.vs_hs_addr;
	vstart = (de_vstart + v_period - vsync_bp - vsync_width) % v_period;
	vend = (de_vstart + v_period - vsync_bp) % v_period;
	pconf->lcd_timing.vs_vs_addr = vstart;
	pconf->lcd_timing.vs_ve_addr = vend;

/*	LCDPR("hs_hs_addr=%d, hs_he_addr=%d, hs_vs_addr=%d, hs_ve_addr=%d\n"
		"vs_hs_addr=%d, vs_he_addr=%d, vs_vs_addr=%d, vs_ve_addr=%d\n",
		pconf->lcd_timing.sth1_hs_addr, pconf->lcd_timing.sth1_he_addr,
		pconf->lcd_timing.sth1_vs_addr, pconf->lcd_timing.sth1_ve_addr,
		pconf->lcd_timing.stv1_hs_addr, pconf->lcd_timing.stv1_he_addr,
		pconf->lcd_timing.stv1_vs_addr, pconf->lcd_timing.stv1_ve_addr);*/
}

static void lcd_config_init(struct lcd_config_s *pconf)
{
	unsigned int h_period = pconf->lcd_basic.h_period;
	unsigned int v_period = pconf->lcd_basic.v_period;

	pconf->lcd_timing.lcd_clk = h_period * v_period * 60;
	pconf->lcd_timing.sync_duration_num = 60;
	pconf->lcd_timing.sync_duration_den = 1;

	lcd_tcon_config(pconf);
}

/* change clock(frame_rate) for different vmode */
static int lcd_vmode_change(struct lcd_config_s *pconf, int vmode)
{
	unsigned int pclk;
	unsigned int h_period = pconf->lcd_basic.h_period;
	unsigned int v_period = pconf->lcd_basic.v_period;
	unsigned char type = pconf->lcd_timing.fr_adjust_type;
	unsigned int sync_duration_num = lcd_info[vmode].sync_duration_num;
	unsigned int sync_duration_den = lcd_info[vmode].sync_duration_den;

	/* init lcd pixel clock */
	pclk = h_period * v_period * 60;
	pconf->lcd_timing.lcd_clk = pclk;

	/* frame rate 60hz as default, no need adjust */
	if ((sync_duration_num / sync_duration_den) > 55)
		return 0;

	/* frame rate adjust */
	switch (type) {
	case 1: /* htotal adjust */
		h_period = ((pclk / v_period) * sync_duration_den * 10) / sync_duration_num;
		h_period = (h_period + 5) / 10; /* round off */
		LCDPR("vmode_change: adjust h_period %u -> %u\n",
			pconf->lcd_basic.h_period, h_period);
		pconf->lcd_basic.h_period = h_period;
		break;
	case 2: /* vtotal adjust */
		v_period = ((pclk / h_period) * sync_duration_den * 10) / sync_duration_num;
		v_period = (v_period + 5) / 10; /* round off */
		LCDPR("vmode_change: adjust v_period %u -> %u\n",
			pconf->lcd_basic.v_period, v_period);
		pconf->lcd_basic.v_period = v_period;
		break;
	case 0: /* pixel clk adjust */
	default:
		pclk = (h_period * v_period * sync_duration_num) / sync_duration_den;
		LCDPR("vmode_change: adjust pclk %u.%03uMHz -> %u.%03uMHz\n",
			(pconf->lcd_timing.lcd_clk / 1000000),
			((pconf->lcd_timing.lcd_clk / 1000) % 1000),
			(pclk / 1000000), ((pclk / 1000) % 1000));
		pconf->lcd_timing.lcd_clk = pclk;
		break;
	}

	return 0;
}

static int lcd_driver_init(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	switch (lcd_drv->lcd_config->lcd_basic.lcd_type) {
	case LCD_LVDS:
		lvds_init(lcd_drv->lcd_config);
		break;
	case LCD_VBYONE:
		vbyone_init(lcd_drv->lcd_config);
		break;
	default:
		LCDPR("invalid lcd type\n");
		break;
	}

	//LCDPR("%s\n", __func__);
	return 0;
}

static void lcd_driver_disable(void)
{
	int vclk_sel = 0;

	lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL3, 0);
	lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL1, 0);
	lcd_hiu_write(HHI_DIF_CSI_PHY_CNTL2, 0);

	lcd_vcbus_write(ENCL_VIDEO_EN, 0);

	if (vclk_sel)
		lcd_hiu_setb(HHI_VIID_CLK_CNTL, 0, 0, 5); //close vclk2 gate: 0x104b[4:0]
	else
		lcd_hiu_setb(HHI_VID_CLK_CNTL, 0, 0, 5); //close vclk1 gate: 0x105f[4:0]

	//LCDPR("%s\n", __func__);
}

static int lcd_config_check(char *mode)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int vmode;

	vmode = check_lcd_output_mode(lcd_drv->lcd_config, mode);
	if (vmode >= LCD_OUTPUT_MODE_MAX)
		return -1;

	lcd_vmode_change(lcd_drv->lcd_config, vmode);
	return 0;
}

int get_lcd_config(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int load_id;
#ifdef CONFIG_OF_LIBFDT
	char *dt_addr;
#endif
#ifdef CONFIG_AML_LCD_EXTERN
	int index, i;
#endif

	load_id = 0;
#ifdef CONFIG_OF_LIBFDT
	dt_addr = NULL;
#ifdef CONFIG_DTB_MEM_ADDR
	dt_addr = (char *)CONFIG_DTB_MEM_ADDR;
#else
	dt_addr = (char *)0x01000000;
#endif
	if (fdt_check_header(dt_addr) < 0) {
		LCDERR("check dts: %s, load default lcd parameters\n",
			fdt_strerror(fdt_check_header(dt_addr)));
	} else {
		load_id = 1;
	}
#endif

	strcpy(lcd_drv->version, LCD_DRV_VERSION);
	lcd_drv->list_support_mode = lcd_list_support_mode;
	lcd_drv->driver_init = lcd_driver_init;
	lcd_drv->driver_disable = lcd_driver_disable;
	lcd_drv->config_check = lcd_config_check;

	load_id = 0; /* for test */
	if (load_id == 1 ) {
#ifdef CONFIG_OF_LIBFDT
		LCDPR("load config from dtd\n");
		lcd_config_load_from_dtd(dt_addr, lcd_drv->lcd_config);
		//bl_config_load_from_dtd(dt_addr, lcd_drv->bl_config);
#endif
	} else {
		LCDPR("load config from lcd.c\n");
		lcd_config_load_from_bsp(lcd_drv->lcd_config);
		//bl_config_load_from_bsp(lcd_drv->bl_config);
	}
	lcd_config_load_print(lcd_drv->lcd_config);

#ifdef CONFIG_AML_LCD_EXTERN
	lcd_extern_load_config(dt_addr, lcd_drv->lcd_config);
#endif
	lcd_config_init(lcd_drv->lcd_config);

	return 0;
}


