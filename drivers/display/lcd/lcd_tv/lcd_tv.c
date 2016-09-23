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
#include <malloc.h>
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include <amlogic/vmode.h>
#include <amlogic/aml_lcd.h>
#include "../aml_lcd_reg.h"
#include "../aml_lcd_common.h"
#include "lcd_tv.h"

/* ************************************************** *
   lcd mode function
 * ************************************************** */
static unsigned int lcd_std_frame_rate[] = {
	50,
	60,
	48,
};

struct lcd_vmode_info_s {
	char *name;
	enum vmode_e mode;
	unsigned int width;
	unsigned int height;
	unsigned int frame_rate;
};


enum lcd_vmode_e {
	LCD_VMODE_600P = 0,
	LCD_VMODE_768P,
	LCD_VMODE_1080P,
	LCD_VMODE_2160P,
	LCD_VMODE_MAX,
};

static struct lcd_vmode_info_s lcd_vmode_info[] = {
	{
		.name              = "600p",
		.mode              = VMODE_LCD,
		.width             = 1024,
		.height            = 600,
		.frame_rate        = 60,
	},
	{
		.name              = "768p",
		.mode              = VMODE_LCD,
		.width             = 1366,
		.height            = 768,
		.frame_rate        = 60,
	},
	{
		.name              = "1080p",
		.mode              = VMODE_LCD,
		.width             = 1920,
		.height            = 1080,
		.frame_rate        = 60,
	},
	{
		.name              = "2160p",
		.mode              = VMODE_LCD,
		.width             = 3840,
		.height            = 2160,
		.frame_rate        = 60,
	},
	{
		.name              = "invalid",
		.mode              = VMODE_INIT_NULL,
		.width             = 1920,
		.height            = 1080,
		.frame_rate        = 60,
	},
};

static int lcd_vmode_is_mached(struct lcd_config_s *pconf, int index)
{
	if ((pconf->lcd_basic.h_active == lcd_vmode_info[index].width) &&
		(pconf->lcd_basic.v_active == lcd_vmode_info[index].height))
		return 0;
	else
		return -1;
}

static int lcd_outputmode_to_lcd_vmode(const char *mode)
{
	int lcd_vmode = LCD_VMODE_MAX;
	int i, count = ARRAY_SIZE(lcd_vmode_info) - 1;
	char temp[30], *p;
	int n;

	p = strchr(mode, 'p');
	if (p == NULL)
		return LCD_VMODE_MAX;
	n = p - mode + 1;
	strncpy(temp, mode, n);
	temp[n] = '\0';
	if (lcd_debug_print_flag)
		LCDPR("outputmode=%s, lcd_vmode=%s\n", mode, temp);

	for (i = 0; i < count; i++) {
		if (strcmp(temp, lcd_vmode_info[i].name) == 0) {
			lcd_vmode = i;
			break;
		}
	}
	return lcd_vmode;
}

static int lcd_outputmode_to_lcd_frame_rate(const char *mode)
{
	int frame_rate = 0;
	char temp[30], *p;
	int n, i;

	p = strchr(mode, 'p');
	if (p == NULL)
		return 0;
	n = p - mode + 1;
	strncpy(temp, mode+n, (strlen(mode)-n));
	p = strchr(temp, 'h');
	if (p == NULL)
		return 0;
	*p = '\0';
	n = (int)simple_strtoul(temp, NULL, 10);
	if (lcd_debug_print_flag)
		LCDPR("outputmode=%s, frame_rate=%d\n", mode, n);

	for (i = 0; i < ARRAY_SIZE(lcd_std_frame_rate); i++) {
		if (n == lcd_std_frame_rate[i]) {
			frame_rate = n;
			break;
		}
	}
	return frame_rate;
}

static int check_lcd_output_mode(struct lcd_config_s *pconf, char *mode)
{
	int lcd_vmode, frame_rate;
	int ret;

	if (mode == NULL)
		return LCD_VMODE_MAX;

	lcd_vmode = lcd_outputmode_to_lcd_vmode(mode);
	if (lcd_vmode >= LCD_VMODE_MAX) {
		LCDERR("%s: outputmode %s is not support\n", __func__, mode);
		return LCD_VMODE_MAX;
	}
	frame_rate = lcd_outputmode_to_lcd_frame_rate(mode);
	if (frame_rate == 0) {
		LCDERR("%s: frame_rate is not support\n", __func__);
		return LCD_VMODE_MAX;
	} else {
		lcd_vmode_info[lcd_vmode].frame_rate = frame_rate;
	}
	ret = lcd_vmode_is_mached(pconf, lcd_vmode);
	if (ret) {
		LCDERR("outputmode[%s] and panel_type is not match\n",
			lcd_vmode_info[lcd_vmode].name);
		return LCD_VMODE_MAX;
	}

	return lcd_vmode;
}

static void lcd_list_support_mode(void)
{
	int i, j;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_basic_s *lcd_basic;
	char str[30];

	lcd_basic = &lcd_drv->lcd_config->lcd_basic;
	for (i = 0; i < (ARRAY_SIZE(lcd_vmode_info) - 1); i++) {
		if ((lcd_basic->h_active == lcd_vmode_info[i].width) &&
		(lcd_basic->v_active == lcd_vmode_info[i].height)) {
			for (j = 0; j < ARRAY_SIZE(lcd_std_frame_rate); j++) {
				sprintf(str, "%s%dhz", lcd_vmode_info[i].name, lcd_std_frame_rate[j]);
				printf("%s\n", str);
			}
			break;
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

	LCDPR("h_period_min = %d\n", pconf->lcd_basic.h_period_min);
	LCDPR("h_period_max = %d\n", pconf->lcd_basic.h_period_max);
	LCDPR("v_period_min = %d\n", pconf->lcd_basic.v_period_min);
	LCDPR("v_period_max = %d\n", pconf->lcd_basic.v_period_max);
	LCDPR("pclk_min = %d\n", pconf->lcd_basic.lcd_clk_min);
	LCDPR("pclk_max = %d\n", pconf->lcd_basic.lcd_clk_max);

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
	unsigned int i, j, temp;
	int len;

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

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "range_setting", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get range_setting\n");
		pconf->lcd_basic.h_period_min = pconf->lcd_basic.h_period;
		pconf->lcd_basic.h_period_max = pconf->lcd_basic.h_period;
		pconf->lcd_basic.v_period_min = pconf->lcd_basic.v_period;
		pconf->lcd_basic.v_period_max = pconf->lcd_basic.v_period;
		pconf->lcd_basic.lcd_clk_min = 0;
		pconf->lcd_basic.lcd_clk_max = 0;
	} else {
		pconf->lcd_basic.h_period_min = be32_to_cpup((u32*)propdata);
		pconf->lcd_basic.h_period_max = be32_to_cpup((((u32*)propdata)+1));
		pconf->lcd_basic.v_period_min = be32_to_cpup((((u32*)propdata)+2));
		pconf->lcd_basic.v_period_max = be32_to_cpup((((u32*)propdata)+3));
		pconf->lcd_basic.lcd_clk_min = be32_to_cpup((((u32*)propdata)+4));
		pconf->lcd_basic.lcd_clk_max = be32_to_cpup((((u32*)propdata)+5));
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
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "phy_attr", &len);
		if (propdata == NULL) {
			if (lcd_debug_print_flag)
				LCDPR("failed to get phy_attr\n");
			pconf->lcd_control.lvds_config->phy_vswing = LVDS_PHY_VSWING_DFT;
			pconf->lcd_control.lvds_config->phy_preem  = LVDS_PHY_PREEM_DFT;
			pconf->lcd_control.lvds_config->phy_clk_vswing = LVDS_PHY_CLK_VSWING_DFT;
			pconf->lcd_control.lvds_config->phy_clk_preem  = LVDS_PHY_CLK_PREEM_DFT;
		} else {
			len = len / 4;
			if (len == 4) {
				pconf->lcd_control.lvds_config->phy_vswing = be32_to_cpup((u32*)propdata);
				pconf->lcd_control.lvds_config->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
				pconf->lcd_control.lvds_config->phy_clk_vswing = be32_to_cpup((((u32*)propdata)+2));
				pconf->lcd_control.lvds_config->phy_clk_preem  = be32_to_cpup((((u32*)propdata)+3));
				LCDPR("set phy vswing=%d, preemphasis=%d\n",
					pconf->lcd_control.lvds_config->phy_vswing,
					pconf->lcd_control.lvds_config->phy_preem);
				LCDPR("set phy clk_vswing=%d, clk_preemphasis=%d\n",
					pconf->lcd_control.lvds_config->phy_clk_vswing,
					pconf->lcd_control.lvds_config->phy_clk_preem);
			} else if (len == 2) {
				pconf->lcd_control.lvds_config->phy_vswing = be32_to_cpup((u32*)propdata);
				pconf->lcd_control.lvds_config->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
				pconf->lcd_control.lvds_config->phy_clk_vswing = LVDS_PHY_CLK_VSWING_DFT;
				pconf->lcd_control.lvds_config->phy_clk_preem  = LVDS_PHY_CLK_PREEM_DFT;
				LCDPR("set phy vswing=%d, preemphasis=%d\n",
					pconf->lcd_control.lvds_config->phy_vswing,
					pconf->lcd_control.lvds_config->phy_preem);
			} else {
				LCDERR("invalid phy_attr parameters cnt: %d\n", len);
			}
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
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "phy_attr", NULL);
		if (propdata == NULL) {
			if (lcd_debug_print_flag)
				LCDPR("failed to get phy_attr\n");
			pconf->lcd_control.vbyone_config->phy_vswing = VX1_PHY_VSWING_DFT;
			pconf->lcd_control.vbyone_config->phy_preem  = VX1_PHY_PREEM_DFT;
		} else {
			pconf->lcd_control.vbyone_config->phy_vswing = be32_to_cpup((u32*)propdata);
			pconf->lcd_control.vbyone_config->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
			LCDPR("set phy vswing=%d, preemphasis=%d\n",
				pconf->lcd_control.vbyone_config->phy_vswing,
				pconf->lcd_control.vbyone_config->phy_preem);
		}
		break;
	default:
		LCDERR("invalid lcd type\n");
		break;
	}

	/* check power_step */
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
		pconf->backlight_index = 0xff;
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
	unsigned int i;
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

	pconf->lcd_basic.h_period_min = pconf->lcd_basic.h_period;
	pconf->lcd_basic.h_period_max = pconf->lcd_basic.h_period;
	pconf->lcd_basic.v_period_min = pconf->lcd_basic.v_period;
	pconf->lcd_basic.v_period_max = pconf->lcd_basic.v_period;
	pconf->lcd_basic.lcd_clk_min = 0;
	pconf->lcd_basic.lcd_clk_max = 0;

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
		pconf->lcd_control.vbyone_config->phy_vswing = VX1_PHY_VSWING_DFT;
		pconf->lcd_control.vbyone_config->phy_preem  = VX1_PHY_PREEM_DFT;
	} else if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
		pconf->lcd_control.lvds_config->lvds_repack = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.lvds_config->dual_port   = ext_lcd->lcd_spc_val1;
		pconf->lcd_control.lvds_config->pn_swap     = ext_lcd->lcd_spc_val2;
		pconf->lcd_control.lvds_config->port_swap   = ext_lcd->lcd_spc_val3;
		pconf->lcd_control.lvds_config->phy_vswing = LVDS_PHY_VSWING_DFT;
		pconf->lcd_control.lvds_config->phy_preem  = LVDS_PHY_PREEM_DFT;
		pconf->lcd_control.lvds_config->phy_clk_vswing = LVDS_PHY_CLK_VSWING_DFT;
		pconf->lcd_control.lvds_config->phy_clk_preem  = LVDS_PHY_CLK_PREEM_DFT;
	} else if (pconf->lcd_basic.lcd_type == LCD_TTL) {
		LCDERR("unsupport lcd_type: %d\n", pconf->lcd_basic.lcd_type);
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

	return 0;
}

static int lcd_config_load_from_unifykey(struct lcd_config_s *pconf)
{
	unsigned char *para;
	int i, key_len, len;
	unsigned char *p;
	const char *str;
	struct aml_lcd_unifykey_header_s lcd_header;
	int ret;

	para = (unsigned char *)malloc(sizeof(unsigned char) * LCD_UKEY_LCD_SIZE);
	if (!para) {
		LCDERR("%s: Not enough memory\n", __func__);
		return -1;
	}
	key_len = LCD_UKEY_LCD_SIZE;
	memset(para, 0, (sizeof(unsigned char) * key_len));
	ret = aml_lcd_unifykey_get("lcd", para, &key_len);
	if (ret) {
		free(para);
		return -1;
	}

	/* check lcd unifykey length */
	len = 10 + 36 + 18 + 31 + 20;
	ret = aml_lcd_unifykey_len_check(key_len, len);
	if (ret) {
		LCDERR("unifykey length is not correct\n");
		free(para);
		return -1;
	}

	/* header: 10byte */
	aml_lcd_unifykey_header_check(para, &lcd_header);
	if (lcd_debug_print_flag) {
		LCDPR("unifykey header:\n");
		LCDPR("crc32             = 0x%08x\n", lcd_header.crc32);
		LCDPR("data_len          = %d\n", lcd_header.data_len);
		LCDPR("version           = 0x%04x\n", lcd_header.version);
		LCDPR("reserved          = 0x%04x\n", lcd_header.reserved);
	}

	/* basic: 36byte */
	p = para + LCD_UKEY_HEAD_SIZE;
	*(p + LCD_UKEY_MODEL_NAME - 1) = '\0'; /* ensure string ending */
	str = (const char *)p;
	strcpy(pconf->lcd_basic.model_name, str);
	p += LCD_UKEY_MODEL_NAME;
	pconf->lcd_basic.lcd_type = *p;
	p += LCD_UKEY_INTERFACE;
	pconf->lcd_basic.lcd_bits = *p;
	p += LCD_UKEY_LCD_BITS;
	pconf->lcd_basic.screen_width = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_SCREEN_WIDTH;
	pconf->lcd_basic.screen_height = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_SCREEN_HEIGHT;

	/* timing: 18byte */
	pconf->lcd_basic.h_active = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_H_ACTIVE;
	pconf->lcd_basic.v_active = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_V_ACTIVE;
	pconf->lcd_basic.h_period = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_H_PERIOD;
	pconf->lcd_basic.v_period = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_V_PERIOD;
	pconf->lcd_timing.hsync_width = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_HS_WIDTH;
	pconf->lcd_timing.hsync_bp = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_HS_BP;
	pconf->lcd_timing.hsync_pol = *p;
	p += LCD_UKEY_HS_POL;
	pconf->lcd_timing.vsync_width = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_VS_WIDTH;
	pconf->lcd_timing.vsync_bp = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_VS_BP;
	pconf->lcd_timing.vsync_pol = *p;
	p += LCD_UKEY_VS_POL;

	/* customer: 31byte */
	pconf->lcd_timing.fr_adjust_type = *p;
	p += LCD_UKEY_FR_ADJ_TYPE;
	pconf->lcd_timing.ss_level = *p;
	p += LCD_UKEY_SS_LEVEL;
	pconf->lcd_timing.clk_auto = *p;
	p += LCD_UKEY_CLK_AUTO_GEN;
	/* dummy pointer */
	p += LCD_UKEY_PCLK;
	pconf->lcd_basic.h_period_min = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_H_PERIOD_MIN;
	pconf->lcd_basic.h_period_max = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_H_PERIOD_MAX;
	pconf->lcd_basic.v_period_min = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_V_PERIOD_MIN;
	pconf->lcd_basic.v_period_max = (*p | ((*(p + 1)) << 8));
	p += LCD_UKEY_V_PERIOD_MAX;
	pconf->lcd_basic.lcd_clk_min = (*p | ((*(p + 1)) << 8) |
		((*(p + 2)) << 16) | ((*(p + 3)) << 24));
	p += LCD_UKEY_PCLK_MIN;
	pconf->lcd_basic.lcd_clk_max = (*p | ((*(p + 1)) << 8) |
		((*(p + 2)) << 16) | ((*(p + 3)) << 24));
	/* dummy pointer */
	p += LCD_UKEY_CUST_VAL_8;
	p += LCD_UKEY_CUST_VAL_9;

	/* interface: 20byte */
	if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
		pconf->lcd_control.vbyone_config->lane_count = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_0;
		pconf->lcd_control.vbyone_config->region_num = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_1;
		pconf->lcd_control.vbyone_config->byte_mode  = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_2;
		pconf->lcd_control.vbyone_config->color_fmt  = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_3;
		pconf->lcd_control.vbyone_config->phy_vswing = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_4;
		pconf->lcd_control.vbyone_config->phy_preem  = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_5;
		/* dummy pointer */
		p += LCD_UKEY_IF_ATTR_6;
		p += LCD_UKEY_IF_ATTR_7;
		p += LCD_UKEY_IF_ATTR_8;
		p += LCD_UKEY_IF_ATTR_9;
	} else if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
		pconf->lcd_control.lvds_config->lvds_repack = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_0;
		pconf->lcd_control.lvds_config->dual_port = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_1;
		pconf->lcd_control.lvds_config->pn_swap  = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_2;
		pconf->lcd_control.lvds_config->port_swap  = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_3;
		pconf->lcd_control.lvds_config->phy_vswing = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_4;
		pconf->lcd_control.lvds_config->phy_preem = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_5;
		pconf->lcd_control.lvds_config->phy_clk_vswing = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_6;
		pconf->lcd_control.lvds_config->phy_clk_preem = (*p | ((*(p + 1)) << 8)) & 0xff;
		p += LCD_UKEY_IF_ATTR_7;
		/* dummy pointer */
		p += LCD_UKEY_IF_ATTR_8;
		p += LCD_UKEY_IF_ATTR_9;
	} else {
		LCDERR("unsupport lcd_type: %d\n", pconf->lcd_basic.lcd_type);
		p += LCD_UKEY_IF_ATTR_0;
		p += LCD_UKEY_IF_ATTR_1;
		p += LCD_UKEY_IF_ATTR_2;
		p += LCD_UKEY_IF_ATTR_3;
		p += LCD_UKEY_IF_ATTR_4;
		p += LCD_UKEY_IF_ATTR_5;
		p += LCD_UKEY_IF_ATTR_6;
		p += LCD_UKEY_IF_ATTR_7;
		p += LCD_UKEY_IF_ATTR_8;
		p += LCD_UKEY_IF_ATTR_9;
	}

	/* power: (5byte * n) */
	i = 0;
	while (i < LCD_PWR_STEP_MAX) {
		len += 5;
		ret = aml_lcd_unifykey_len_check(key_len, len);
		if (ret) {
			pconf->lcd_power->power_on_step[i].type = 0xff;
			pconf->lcd_power->power_on_step[i].index = 0;
			pconf->lcd_power->power_on_step[i].value = 0;
			pconf->lcd_power->power_on_step[i].delay = 0;
			free(para);
			return -1;
		}
		pconf->lcd_power->power_on_step[i].type = *p;
		p += LCD_UKEY_PWR_TYPE;
		pconf->lcd_power->power_on_step[i].index = *p;
		p += LCD_UKEY_PWR_INDEX;
		pconf->lcd_power->power_on_step[i].value = *p;
		p += LCD_UKEY_PWR_VAL;
		pconf->lcd_power->power_on_step[i].delay = (*p | ((*(p + 1)) << 8));
		p += LCD_UKEY_PWR_DELAY;
		if (lcd_debug_print_flag) {
			LCDPR("power_on: step %d: type=%d, index=%d, value=%d, delay=%d\n",
				i, pconf->lcd_power->power_on_step[i].type,
				pconf->lcd_power->power_on_step[i].index,
				pconf->lcd_power->power_on_step[i].value,
				pconf->lcd_power->power_on_step[i].delay);
		}
		if (pconf->lcd_power->power_on_step[i].type >= LCD_POWER_TYPE_MAX)
			break;
		else
			i++;
	}
	i = 0;
	while (i < LCD_PWR_STEP_MAX) {
		len += 5;
		ret = aml_lcd_unifykey_len_check(key_len, len);
		if (ret) {
			pconf->lcd_power->power_off_step[i].type = 0xff;
			pconf->lcd_power->power_off_step[i].index = 0;
			pconf->lcd_power->power_off_step[i].value = 0;
			pconf->lcd_power->power_off_step[i].delay = 0;
			free(para);
			return -1;
		}
		pconf->lcd_power->power_off_step[i].type = *p;
		p += LCD_UKEY_PWR_TYPE;
		pconf->lcd_power->power_off_step[i].index = *p;
		p += LCD_UKEY_PWR_INDEX;
		pconf->lcd_power->power_off_step[i].value = *p;
		p += LCD_UKEY_PWR_VAL;
		pconf->lcd_power->power_off_step[i].delay = (*p | ((*(p + 1)) << 8));
		p += LCD_UKEY_PWR_DELAY;
		if (lcd_debug_print_flag) {
			LCDPR("power_off: step %d: type=%d, index=%d, value=%d, delay=%d\n",
				i, pconf->lcd_power->power_off_step[i].type,
				pconf->lcd_power->power_off_step[i].index,
				pconf->lcd_power->power_off_step[i].value,
				pconf->lcd_power->power_off_step[i].delay);
		}
		if (pconf->lcd_power->power_off_step[i].type >= LCD_POWER_TYPE_MAX)
			break;
		else
			i++;
	}

	free(para);
	return 0;
}

static void lcd_config_init(struct lcd_config_s *pconf)
{
	struct lcd_clk_config_s *cconf = get_lcd_clk_config();
	unsigned int ss_level;
	unsigned int clk;

	clk = pconf->lcd_basic.h_period * pconf->lcd_basic.v_period * 60;
	pconf->lcd_timing.lcd_clk = clk;
	pconf->lcd_timing.lcd_clk_dft = pconf->lcd_timing.lcd_clk;
	pconf->lcd_timing.h_period_dft = pconf->lcd_basic.h_period;
	pconf->lcd_timing.v_period_dft = pconf->lcd_basic.v_period;
	pconf->lcd_timing.sync_duration_num = 60;
	pconf->lcd_timing.sync_duration_den = 1;

	lcd_tcon_config(pconf);
	ss_level = pconf->lcd_timing.ss_level;
	cconf->ss_level = (ss_level >= cconf->ss_level_max) ? 0 : ss_level;
}

static int lcd_config_check(char *mode)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int lcd_vmode;

	lcd_vmode = check_lcd_output_mode(lcd_drv->lcd_config, mode);
	if (lcd_vmode >= LCD_VMODE_MAX)
		return -1;

	lcd_drv->lcd_config->lcd_timing.sync_duration_num = lcd_vmode_info[lcd_vmode].frame_rate;
	lcd_drv->lcd_config->lcd_timing.sync_duration_den = 1;
	/* update clk & timing config */
	lcd_vmode_change(lcd_drv->lcd_config);
	lcd_tv_config_update(lcd_drv->lcd_config);

	return 0;
}

int get_lcd_tv_config(char *dt_addr, int load_id)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int ret = 0;

	strcpy(lcd_drv->version, LCD_DRV_VERSION);
	lcd_drv->list_support_mode = lcd_list_support_mode;
	lcd_drv->config_check = lcd_config_check;
	lcd_drv->driver_init_pre = lcd_tv_driver_init_pre;
	lcd_drv->driver_init = lcd_tv_driver_init;
	lcd_drv->driver_disable = lcd_tv_driver_disable;

	if (load_id & 0x10) { /* unifykey */
		ret = lcd_config_load_from_unifykey(lcd_drv->lcd_config);
	} else if (load_id & 0x1) { /* dts */
#ifdef CONFIG_OF_LIBFDT
		ret = lcd_config_load_from_dts(dt_addr, lcd_drv->lcd_config);
#endif
	} else { /* bsp */
		ret = lcd_config_load_from_bsp(lcd_drv->lcd_config);
	}
	if (ret)
		return -1;

	lcd_config_load_print(lcd_drv->lcd_config);
	lcd_config_init(lcd_drv->lcd_config);

	return 0;
}


