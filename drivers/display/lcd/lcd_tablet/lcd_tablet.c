/*
 * drivers/display/lcd/lcd_tablet/lcd_tablet.c
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
#include <amlogic/aml_lcd.h>
#include "../aml_lcd_reg.h"
#include "../aml_lcd_common.h"
#include "lcd_tablet.h"
#include "mipi_dsi_util.h"

static int check_lcd_output_mode(char *mode)
{
	if (strcmp(mode, "panel") != 0) {
		LCDERR("outputmode[%s] is not support\n", mode);
		return -1;
	}

	return 0;
}

static void lcd_list_support_mode(void)
{
	printf("panel\n");
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
	LCDPR("clk = %dHz\n", pconf->lcd_timing.lcd_clk);

	if (pconf->lcd_basic.lcd_type == LCD_TTL) {
		LCDPR("clk_pol = %d\n", pconf->lcd_control.ttl_config->clk_pol);
		LCDPR("sync_valid = %d\n", pconf->lcd_control.ttl_config->sync_valid);
		LCDPR("swap_ctrl = %d\n", pconf->lcd_control.ttl_config->swap_ctrl);
	} else if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
		LCDPR("lvds_repack = %d\n", pconf->lcd_control.lvds_config->lvds_repack);
		LCDPR("pn_swap = %d\n", pconf->lcd_control.lvds_config->pn_swap);
		LCDPR("dual_port = %d\n", pconf->lcd_control.lvds_config->dual_port);
		LCDPR("port_swap = %d\n", pconf->lcd_control.lvds_config->port_swap);
		LCDPR("lane_reverse = %d\n", pconf->lcd_control.lvds_config->lane_reverse);
	} else if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
		LCDPR("lane_count = %d\n", pconf->lcd_control.vbyone_config->lane_count);
		LCDPR("byte_mode = %d\n", pconf->lcd_control.vbyone_config->byte_mode);
		LCDPR("region_num = %d\n", pconf->lcd_control.vbyone_config->region_num);
		LCDPR("color_fmt = %d\n", pconf->lcd_control.vbyone_config->color_fmt);
	} else if (pconf->lcd_basic.lcd_type == LCD_MIPI) {
		if (pconf->lcd_control.mipi_config->check_en) {
			LCDPR("check_reg = 0x%02x\n",
				pconf->lcd_control.mipi_config->check_reg);
			LCDPR("check_cnt = %d\n",
				pconf->lcd_control.mipi_config->check_cnt);
		}
		LCDPR("lane_num = %d\n",
			pconf->lcd_control.mipi_config->lane_num);
		LCDPR("bit_rate_max = %d\n",
			pconf->lcd_control.mipi_config->bit_rate_max);
		LCDPR("pclk_lanebyteclk_factor = %d\n",
			pconf->lcd_control.mipi_config->factor_numerator);
		LCDPR("operation_mode_init = %d\n",
			pconf->lcd_control.mipi_config->operation_mode_init);
		LCDPR("operation_mode_disp = %d\n",
			pconf->lcd_control.mipi_config->operation_mode_display);
		LCDPR("video_mode_type = %d\n",
			pconf->lcd_control.mipi_config->video_mode_type);
		LCDPR("clk_always_hs = %d\n",
			pconf->lcd_control.mipi_config->clk_always_hs);
		LCDPR("phy_switch = %d\n",
			pconf->lcd_control.mipi_config->phy_switch);
		LCDPR("extern_init = %d\n",
			pconf->lcd_control.mipi_config->extern_init);
	}
}

#ifdef CONFIG_OF_LIBFDT
static int lcd_config_load_from_dts(char *dt_addr, struct lcd_config_s *pconf)
{
	int parent_offset;
	int child_offset;
	char propname[30];
	char *propdata;
	unsigned int temp;
	int len;

	parent_offset = fdt_path_offset(dt_addr, "/lcd");
	if (parent_offset < 0) {
		LCDERR("not find /lcd node: %s\n",fdt_strerror(parent_offset));
		return -1;
	}

	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "pinctrl_version", NULL);
	if (propdata) {
		pconf->pinctrl_ver = (unsigned char)(be32_to_cpup((u32*)propdata));
	} else {
		pconf->pinctrl_ver = 0;
	}
	LCDPR("pinctrl_version: %d\n", pconf->pinctrl_ver);

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
		pconf->lcd_timing.lcd_clk = 60;
	} else {
		pconf->lcd_timing.fr_adjust_type = (unsigned char)(be32_to_cpup((u32*)propdata));
		pconf->lcd_timing.ss_level = be32_to_cpup((((u32*)propdata)+1));
		pconf->lcd_timing.clk_auto = (unsigned char)(be32_to_cpup((((u32*)propdata)+2)));
		temp = be32_to_cpup((((u32*)propdata)+3));
		if (temp > 0) {
			pconf->lcd_timing.lcd_clk = temp;
		} else { /* avoid 0 mistake */
			pconf->lcd_timing.lcd_clk = 60;
			LCDERR("lcd_clk is 0, default to 60Hz\n");
		}
	}
	if (pconf->lcd_timing.clk_auto == 0) {
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "clk_para", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get clk_para\n");
			pconf->lcd_timing.pll_ctrl = 0x00140248;
			pconf->lcd_timing.div_ctrl = 0x00000901;
			pconf->lcd_timing.clk_ctrl = 0x000000c0;
		} else {
			pconf->lcd_timing.pll_ctrl = be32_to_cpup((u32*)propdata);
			pconf->lcd_timing.div_ctrl = be32_to_cpup((((u32*)propdata)+1));
			pconf->lcd_timing.clk_ctrl = be32_to_cpup((((u32*)propdata)+2));
		}
	}

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_TTL:
		if (pconf->lcd_control.ttl_config == NULL) {
			LCDERR("ttl_config is null\n");
			return -1;
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "ttl_attr", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get ttl_attr\n");
		} else {
			pconf->lcd_control.ttl_config->clk_pol = be32_to_cpup((u32*)propdata);
			pconf->lcd_control.ttl_config->sync_valid =
				(((be32_to_cpup((((u32*)propdata)+1))) << 1) |
				((be32_to_cpup((((u32*)propdata)+2))) << 0));
			pconf->lcd_control.ttl_config->swap_ctrl =
				(((be32_to_cpup((((u32*)propdata)+3))) << 1) |
				((be32_to_cpup((((u32*)propdata)+4))) << 0));
		}
		break;
	case LCD_LVDS:
		if (pconf->lcd_control.lvds_config == NULL) {
			LCDERR("lvds_config is null\n");
			return -1;
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "lvds_attr", &len);
		if (propdata == NULL) {
			LCDERR("failed to get lvds_attr\n");
		} else {
			len = len / 4;
			if (len == 5) {
				pconf->lcd_control.lvds_config->lvds_repack = be32_to_cpup((u32*)propdata);
				pconf->lcd_control.lvds_config->dual_port   = be32_to_cpup((((u32*)propdata)+1));
				pconf->lcd_control.lvds_config->pn_swap     = be32_to_cpup((((u32*)propdata)+2));
				pconf->lcd_control.lvds_config->port_swap   = be32_to_cpup((((u32*)propdata)+3));
				pconf->lcd_control.lvds_config->lane_reverse = be32_to_cpup((((u32*)propdata)+4));
			} else if (len == 4) {
				pconf->lcd_control.lvds_config->lvds_repack = be32_to_cpup((u32*)propdata);
				pconf->lcd_control.lvds_config->dual_port   = be32_to_cpup((((u32*)propdata)+1));
				pconf->lcd_control.lvds_config->pn_swap     = be32_to_cpup((((u32*)propdata)+2));
				pconf->lcd_control.lvds_config->port_swap   = be32_to_cpup((((u32*)propdata)+3));
				pconf->lcd_control.lvds_config->lane_reverse = 0;
			} else {
				LCDERR("invalid lvds_attr parameters cnt: %d\n", len);
			}
		}

		propdata = (char *)fdt_getprop(dt_addr, child_offset, "phy_attr", &len);
		if (propdata == NULL) {
			if (lcd_debug_print_flag)
				LCDPR("failed to get phy_attr\n");
			pconf->lcd_control.lvds_config->phy_vswing = LVDS_PHY_VSWING_DFT;
			pconf->lcd_control.lvds_config->phy_preem  = LVDS_PHY_PREEM_DFT;
		} else {
			len = len / 4;
			if (len == 4) {
				pconf->lcd_control.lvds_config->phy_vswing = be32_to_cpup((u32*)propdata);
				pconf->lcd_control.lvds_config->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
				pconf->lcd_control.lvds_config->phy_clk_vswing = be32_to_cpup((((u32*)propdata)+2));
				pconf->lcd_control.lvds_config->phy_clk_preem  = be32_to_cpup((((u32*)propdata)+3));
				if (lcd_debug_print_flag) {
					LCDPR("set phy vswing=0x%x, preemphasis=0x%x\n",
						pconf->lcd_control.lvds_config->phy_vswing,
						pconf->lcd_control.lvds_config->phy_preem);
					LCDPR("set phy clk_vswing=0x%x, clk_preemphasis=0x%x\n",
						pconf->lcd_control.lvds_config->phy_clk_vswing,
						pconf->lcd_control.lvds_config->phy_clk_preem);
				}
			} else if (len == 2) {
				pconf->lcd_control.lvds_config->phy_vswing = be32_to_cpup((u32*)propdata);
				pconf->lcd_control.lvds_config->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
				pconf->lcd_control.lvds_config->phy_clk_vswing = LVDS_PHY_CLK_VSWING_DFT;
				pconf->lcd_control.lvds_config->phy_clk_preem  = LVDS_PHY_CLK_PREEM_DFT;
				if (lcd_debug_print_flag) {
					LCDPR("set phy vswing=0x%x, preemphasis=0x%x\n",
						pconf->lcd_control.lvds_config->phy_vswing,
						pconf->lcd_control.lvds_config->phy_preem);
				}
			} else {
				LCDERR("invalid phy_attr parameters cnt: %d\n", len);
			}
		}
		break;
	case LCD_VBYONE:
		if (pconf->lcd_control.vbyone_config == NULL) {
			LCDERR("vbyone_config is null\n");
			return -1;
		}
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
			if (lcd_debug_print_flag) {
				LCDPR("set phy vswing=%d, preemphasis=%d\n",
					pconf->lcd_control.vbyone_config->phy_vswing,
					pconf->lcd_control.vbyone_config->phy_preem);
			}
		}
		break;
	case LCD_MIPI:
		if (pconf->lcd_control.mipi_config == NULL) {
			LCDERR("mipi_config is null\n");
			return -1;
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "mipi_attr", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get mipi_attr\n");
		} else {
			pconf->lcd_control.mipi_config->lane_num = be32_to_cpup((u32*)propdata);
			pconf->lcd_control.mipi_config->bit_rate_max = be32_to_cpup((((u32*)propdata)+1));
			pconf->lcd_control.mipi_config->factor_numerator = be32_to_cpup((((u32*)propdata)+2));
			pconf->lcd_control.mipi_config->factor_denominator = 100;
			pconf->lcd_control.mipi_config->operation_mode_init = be32_to_cpup((((u32*)propdata)+3));
			pconf->lcd_control.mipi_config->operation_mode_display = be32_to_cpup((((u32*)propdata)+4));
			pconf->lcd_control.mipi_config->video_mode_type = be32_to_cpup((((u32*)propdata)+5));
			pconf->lcd_control.mipi_config->clk_always_hs = be32_to_cpup((((u32*)propdata)+6));
			pconf->lcd_control.mipi_config->phy_switch = be32_to_cpup((((u32*)propdata)+7));
		}

		pconf->lcd_control.mipi_config->check_en = 0;
		pconf->lcd_control.mipi_config->check_reg = 0xff;
		pconf->lcd_control.mipi_config->check_cnt = 0;
		lcd_mipi_dsi_init_table_detect(dt_addr, child_offset, pconf->lcd_control.mipi_config, 1);
		lcd_mipi_dsi_init_table_detect(dt_addr, child_offset, pconf->lcd_control.mipi_config, 0);

		propdata = (char *)fdt_getprop(dt_addr, child_offset, "extern_init", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get extern_init\n");
		} else {
			pconf->lcd_control.mipi_config->extern_init = be32_to_cpup((u32*)propdata);
		}
		break;
	default:
		LCDERR("invalid lcd type\n");
		break;
	}

	/* check power_step */
	lcd_power_load_from_dts(pconf, dt_addr, child_offset);

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "backlight_index", NULL);
	if (propdata == NULL) {
		LCDPR("failed to get backlight_index\n");
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
	unsigned int i, j;
	unsigned int temp;
	struct lcd_power_step_s *power_step;

	if (panel_type == NULL) {
		LCDERR("no panel_type, use default lcd config\n ");
		return -1;
	}
	for (i = 0 ; i < LCD_NUM_MAX ; i++) {
		ext_lcd = &ext_lcd_config[i];
		if (strcmp(ext_lcd->panel_type, panel_type) == 0)
			break;
		if (strcmp(ext_lcd->panel_type, "invalid") == 0) {
			i = LCD_NUM_MAX;
			break;
		}
	}
	if (i >= LCD_NUM_MAX) {
		LCDERR("can't find %s, use default lcd config\n ", panel_type);
		return -1;
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
		pconf->lcd_timing.ss_level = temp;
	/* clk_auto_generate */
	temp = ext_lcd->customer_val_2;
	if (temp == Rsv_val)
		pconf->lcd_timing.clk_auto = 1;
	else
		pconf->lcd_timing.clk_auto = (unsigned char)temp;
	/* lcd_clk */
	temp = ext_lcd->customer_val_3;
	if (temp == Rsv_val)
		pconf->lcd_timing.lcd_clk = 60;
	else
		pconf->lcd_timing.lcd_clk = temp;

	if (pconf->lcd_basic.lcd_type == LCD_TTL) {
		if (pconf->lcd_control.ttl_config == NULL) {
			LCDERR("ttl_config is null\n");
			return -1;
		}
		pconf->lcd_control.ttl_config->clk_pol = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.ttl_config->sync_valid =
			((ext_lcd->lcd_spc_val1 << 1) |
			(ext_lcd->lcd_spc_val2 << 0));
		pconf->lcd_control.ttl_config->swap_ctrl =
			((ext_lcd->lcd_spc_val3 << 1) |
			(ext_lcd->lcd_spc_val4 << 0));
	} else if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
		if (pconf->lcd_control.lvds_config == NULL) {
			LCDERR("lvds_config is null\n");
			return -1;
		}
		pconf->lcd_control.lvds_config->lvds_repack = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.lvds_config->dual_port   = ext_lcd->lcd_spc_val1;
		pconf->lcd_control.lvds_config->pn_swap     = ext_lcd->lcd_spc_val2;
		pconf->lcd_control.lvds_config->port_swap   = ext_lcd->lcd_spc_val3;
		pconf->lcd_control.lvds_config->lane_reverse = ext_lcd->lcd_spc_val4;
		if ((ext_lcd->lcd_spc_val5 == Rsv_val) ||
			(ext_lcd->lcd_spc_val6 == Rsv_val)) {
			pconf->lcd_control.lvds_config->phy_vswing = LVDS_PHY_VSWING_DFT;
			pconf->lcd_control.lvds_config->phy_preem  = LVDS_PHY_PREEM_DFT;
		} else {
			pconf->lcd_control.lvds_config->phy_vswing = ext_lcd->lcd_spc_val5;
			pconf->lcd_control.lvds_config->phy_preem  = ext_lcd->lcd_spc_val6;
		}
		if ((ext_lcd->lcd_spc_val7 == Rsv_val) ||
			(ext_lcd->lcd_spc_val8 == Rsv_val)) {
			pconf->lcd_control.lvds_config->phy_clk_vswing = LVDS_PHY_CLK_VSWING_DFT;
			pconf->lcd_control.lvds_config->phy_clk_preem  = LVDS_PHY_CLK_PREEM_DFT;
		} else {
			pconf->lcd_control.lvds_config->phy_clk_vswing = ext_lcd->lcd_spc_val7;
			pconf->lcd_control.lvds_config->phy_clk_preem  = ext_lcd->lcd_spc_val8;
		}
	} else if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
		if (pconf->lcd_control.vbyone_config == NULL) {
			LCDERR("vbyone_config is null\n");
			return -1;
		}
		pconf->lcd_control.vbyone_config->lane_count = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.vbyone_config->region_num = ext_lcd->lcd_spc_val1;
		pconf->lcd_control.vbyone_config->byte_mode  = ext_lcd->lcd_spc_val2;
		pconf->lcd_control.vbyone_config->color_fmt  = ext_lcd->lcd_spc_val3;
		if ((ext_lcd->lcd_spc_val4 == Rsv_val) ||
			(ext_lcd->lcd_spc_val5 == Rsv_val)) {
			pconf->lcd_control.vbyone_config->phy_vswing = VX1_PHY_VSWING_DFT;
			pconf->lcd_control.vbyone_config->phy_preem  = VX1_PHY_PREEM_DFT;
		} else {
			pconf->lcd_control.vbyone_config->phy_vswing = ext_lcd->lcd_spc_val4;
			pconf->lcd_control.vbyone_config->phy_preem  = ext_lcd->lcd_spc_val5;
		}
	} else if (pconf->lcd_basic.lcd_type == LCD_MIPI) {
		if (pconf->lcd_control.mipi_config == NULL) {
			LCDERR("mipi_config is null\n");
			return -1;
		}
		pconf->lcd_control.mipi_config->lane_num = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.mipi_config->bit_rate_max   = ext_lcd->lcd_spc_val1;
		pconf->lcd_control.mipi_config->factor_numerator = ext_lcd->lcd_spc_val2;
		pconf->lcd_control.mipi_config->operation_mode_init     = ext_lcd->lcd_spc_val3;
		pconf->lcd_control.mipi_config->operation_mode_display   = ext_lcd->lcd_spc_val4;
		pconf->lcd_control.mipi_config->video_mode_type = ext_lcd->lcd_spc_val5;
		pconf->lcd_control.mipi_config->clk_always_hs  = ext_lcd->lcd_spc_val6;
		pconf->lcd_control.mipi_config->phy_switch = ext_lcd->lcd_spc_val7;
		pconf->lcd_control.mipi_config->factor_denominator = 100;

		pconf->lcd_control.mipi_config->check_en = 0;
		pconf->lcd_control.mipi_config->check_reg = 0xff;
		pconf->lcd_control.mipi_config->check_cnt = 0;
		lcd_mipi_dsi_init_table_check_bsp(pconf->lcd_control.mipi_config, 1);
		lcd_mipi_dsi_init_table_check_bsp(pconf->lcd_control.mipi_config, 0);

		if (ext_lcd->lcd_spc_val9 == Rsv_val)
			pconf->lcd_control.mipi_config->extern_init = 0xff;
		else
			pconf->lcd_control.mipi_config->extern_init = ext_lcd->lcd_spc_val9;
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

static int lcd_config_load_from_unifykey(struct lcd_config_s *pconf)
{
	unsigned char *para;
	int key_len, len;
	unsigned char *p;
	const char *str;
	struct aml_lcd_unifykey_header_s lcd_header;
	unsigned int temp;
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

	/* step 1: check header */
	len = LCD_UKEY_HEAD_SIZE;
	ret = aml_lcd_unifykey_len_check(key_len, len);
	if (ret) {
		LCDERR("unifykey header length is incorrect\n");
		free(para);
		return -1;
	}

	aml_lcd_unifykey_header_check(para, &lcd_header);
	LCDPR("unifykey version: 0x%04x\n", lcd_header.version);
	switch (lcd_header.version) {
	case 2:
		len = LCD_UKEY_DATA_LEN_V2; /*10+36+18+31+20+44+10*/
		break;
	default:
		len = LCD_UKEY_DATA_LEN_V1; /*10+36+18+31+20*/
		break;
	}
	if (lcd_debug_print_flag) {
		LCDPR("unifykey header:\n");
		LCDPR("crc32             = 0x%08x\n", lcd_header.crc32);
		LCDPR("data_len          = %d\n", lcd_header.data_len);
		LCDPR("reserved          = 0x%04x\n", lcd_header.reserved);
	}

	/* step 2: check lcd parameters */
	ret = aml_lcd_unifykey_len_check(key_len, len);
	if (ret) {
		LCDERR("unifykey parameters length is incorrect\n");
		free(para);
		return -1;
	}

	/* basic: 36byte */
	p = para;
	*(p + LCD_UKEY_MODEL_NAME - 1) = '\0'; /* ensure string ending */
	str = (const char *)(p + LCD_UKEY_HEAD_SIZE);
	strcpy(pconf->lcd_basic.model_name, str);
	pconf->lcd_basic.lcd_type = *(p + LCD_UKEY_INTERFACE);
	pconf->lcd_basic.lcd_bits = *(p + LCD_UKEY_LCD_BITS);
	pconf->lcd_basic.screen_width = (*(p + LCD_UKEY_SCREEN_WIDTH) |
		((*(p + LCD_UKEY_SCREEN_WIDTH + 1)) << 8));
	pconf->lcd_basic.screen_height = (*(p + LCD_UKEY_SCREEN_HEIGHT) |
		((*(p + LCD_UKEY_SCREEN_HEIGHT + 1)) << 8));

	/* timing: 18byte */
	pconf->lcd_basic.h_active = (*(p + LCD_UKEY_H_ACTIVE) |
		((*(p + LCD_UKEY_H_ACTIVE + 1)) << 8));
	pconf->lcd_basic.v_active = (*(p + LCD_UKEY_V_ACTIVE)) |
		((*(p + LCD_UKEY_V_ACTIVE + 1)) << 8);
	pconf->lcd_basic.h_period = (*(p + LCD_UKEY_H_PERIOD)) |
		((*(p + LCD_UKEY_H_PERIOD + 1)) << 8);
	pconf->lcd_basic.v_period = (*(p + LCD_UKEY_V_PERIOD)) |
		((*(p + LCD_UKEY_V_PERIOD + 1)) << 8);
	pconf->lcd_timing.hsync_width = (*(p + LCD_UKEY_HS_WIDTH) |
		((*(p + LCD_UKEY_HS_WIDTH + 1)) << 8));
	pconf->lcd_timing.hsync_bp = (*(p + LCD_UKEY_HS_BP) | ((*(p + LCD_UKEY_HS_BP + 1)) << 8));
	pconf->lcd_timing.hsync_pol = *(p + LCD_UKEY_HS_POL);
	pconf->lcd_timing.vsync_width = (*(p + LCD_UKEY_VS_WIDTH) |
		((*(p + LCD_UKEY_VS_WIDTH + 1)) << 8));
	pconf->lcd_timing.vsync_bp = (*(p + LCD_UKEY_VS_BP) |
		((*(p + LCD_UKEY_VS_BP + 1)) << 8));
	pconf->lcd_timing.vsync_pol = *(p + LCD_UKEY_VS_POL);

	/* customer: 31byte */
	pconf->lcd_timing.fr_adjust_type = *(p + LCD_UKEY_FR_ADJ_TYPE);
	pconf->lcd_timing.ss_level = *(p + LCD_UKEY_SS_LEVEL);
	pconf->lcd_timing.clk_auto = *(p + LCD_UKEY_CLK_AUTO_GEN);
	pconf->lcd_timing.lcd_clk = (*(p + LCD_UKEY_PCLK) |
		((*(p + LCD_UKEY_PCLK + 1)) << 8) |
		((*(p + LCD_UKEY_PCLK + 2)) << 16) |
		((*(p + LCD_UKEY_PCLK + 3)) << 24));
	pconf->lcd_basic.h_period_min = (*(p + LCD_UKEY_H_PERIOD_MIN) |
		((*(p + LCD_UKEY_H_PERIOD_MIN + 1)) << 8));
	pconf->lcd_basic.h_period_max = (*(p + LCD_UKEY_H_PERIOD_MAX) |
		((*(p + LCD_UKEY_H_PERIOD_MAX + 1)) << 8));
	pconf->lcd_basic.v_period_min = (*(p + LCD_UKEY_V_PERIOD_MIN) |
		((*(p  + LCD_UKEY_V_PERIOD_MIN + 1)) << 8));
	pconf->lcd_basic.v_period_max = (*(p + LCD_UKEY_V_PERIOD_MAX) |
		((*(p + LCD_UKEY_V_PERIOD_MAX + 1)) << 8));
	pconf->lcd_basic.lcd_clk_min = (*(p + LCD_UKEY_PCLK_MIN) |
		((*(p + LCD_UKEY_PCLK_MIN + 1)) << 8) |
		((*(p + LCD_UKEY_PCLK_MIN + 2)) << 16) | ((*(p + LCD_UKEY_PCLK_MIN + 3)) << 24));
	pconf->lcd_basic.lcd_clk_max = (*(p + LCD_UKEY_PCLK_MAX) | ((*(p + LCD_UKEY_PCLK_MAX + 1)) << 8) |
		((*(p + LCD_UKEY_PCLK_MAX + 2)) << 16) | ((*(p + LCD_UKEY_PCLK_MAX + 3)) << 24));

	/* interface: 20byte */
	if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
		if (pconf->lcd_control.lvds_config == NULL) {
			LCDERR("lvds_config is null\n");
			free(para);
			return -1;
		}
		if (lcd_header.version == 2) {
			pconf->lcd_control.lvds_config->lvds_repack =
					(*(p + LCD_UKEY_IF_ATTR_0) |
					((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->dual_port =
					(*(p + LCD_UKEY_IF_ATTR_1) |
					((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->pn_swap =
					(*(p + LCD_UKEY_IF_ATTR_2) |
					((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->port_swap =
					(*(p + LCD_UKEY_IF_ATTR_3) |
					((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->lane_reverse =
					(*(p + LCD_UKEY_IF_ATTR_4) |
					((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 8)) & 0xff;
		} else {
			pconf->lcd_control.lvds_config->lvds_repack =
					(*(p + LCD_UKEY_IF_ATTR_0) |
					((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->dual_port =
					(*(p + LCD_UKEY_IF_ATTR_1) |
					((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->pn_swap =
					(*(p + LCD_UKEY_IF_ATTR_2) |
					((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->port_swap =
					(*(p + LCD_UKEY_IF_ATTR_3) |
					((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->phy_vswing =
					(*(p + LCD_UKEY_IF_ATTR_4) |
					((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->phy_preem =
					(*(p + LCD_UKEY_IF_ATTR_5) |
					((*(p + LCD_UKEY_IF_ATTR_5 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->phy_clk_vswing =
					(*(p + LCD_UKEY_IF_ATTR_6) |
					((*(p + LCD_UKEY_IF_ATTR_6 + 1)) << 8)) & 0xff;
			pconf->lcd_control.lvds_config->phy_clk_preem =
					(*(p + LCD_UKEY_IF_ATTR_7) |
					((*(p + LCD_UKEY_IF_ATTR_7 + 1)) << 8)) & 0xff;

			pconf->lcd_control.lvds_config->lane_reverse = 0;
		}
	} else if (pconf->lcd_basic.lcd_type == LCD_TTL) {
		if (pconf->lcd_control.ttl_config == NULL) {
			LCDERR("ttl_config is null\n");
			free(para);
			return -1;
		}
		pconf->lcd_control.ttl_config->clk_pol =
			(*(p + LCD_UKEY_IF_ATTR_0) |
			((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0x1;
		temp = (*(p + LCD_UKEY_IF_ATTR_1) |
			((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0x1; /* de_valid */
		pconf->lcd_control.ttl_config->sync_valid = (temp << 1);
		temp = (*(p + LCD_UKEY_IF_ATTR_2) |
			((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0x1; /* hvsync_valid */
		pconf->lcd_control.ttl_config->sync_valid |= (temp << 0);
		temp = (*(p + LCD_UKEY_IF_ATTR_3) |
			((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0x1; /* rb_swap */
		pconf->lcd_control.ttl_config->swap_ctrl = (temp << 1);
		temp = (*(p + LCD_UKEY_IF_ATTR_4) |
			((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 8)) & 0x1; /* bit_swap */
		pconf->lcd_control.ttl_config->swap_ctrl |= (temp << 0);
	} else if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
		if (pconf->lcd_control.vbyone_config == NULL) {
			LCDERR("vbyone_config is null\n");
			free(para);
			return -1;
		}
		if (lcd_header.version == 2) {
			pconf->lcd_control.vbyone_config->lane_count =
				(*(p + LCD_UKEY_IF_ATTR_0) |
				((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->region_num =
				(*(p + LCD_UKEY_IF_ATTR_1) |
				((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->byte_mode  =
				(*(p + LCD_UKEY_IF_ATTR_2) |
				((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->color_fmt  =
				(*(p + LCD_UKEY_IF_ATTR_3) |
				((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0xff;
		} else {
			pconf->lcd_control.vbyone_config->lane_count =
				(*(p + LCD_UKEY_IF_ATTR_0) |
				((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->region_num =
				(*(p + LCD_UKEY_IF_ATTR_1) |
				((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->byte_mode  =
				(*(p + LCD_UKEY_IF_ATTR_2) |
				((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->color_fmt  =
				(*(p + LCD_UKEY_IF_ATTR_3) |
				((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->phy_vswing =
				(*(p + LCD_UKEY_IF_ATTR_4) |
				((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->phy_preem =
				(*(p + LCD_UKEY_IF_ATTR_5) |
				((*(p + LCD_UKEY_IF_ATTR_5 + 1)) << 8)) & 0xff;
		}
	} else
		LCDERR("unsupport lcd_type: %d\n", pconf->lcd_basic.lcd_type);

	if (lcd_header.version == 2) {
		/* phy: 10byte */ /* v2 */
		if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
			pconf->lcd_control.lvds_config->phy_vswing = *(p +LCD_UKEY_PHY_ATTR_0);
			pconf->lcd_control.lvds_config->phy_preem = *(p + LCD_UKEY_PHY_ATTR_1);
			pconf->lcd_control.lvds_config->phy_clk_vswing = *(p + LCD_UKEY_PHY_ATTR_2);
			pconf->lcd_control.lvds_config->phy_clk_preem = *(p + LCD_UKEY_PHY_ATTR_3);
		} else if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
			pconf->lcd_control.vbyone_config->phy_vswing =
				(*(p + LCD_UKEY_PHY_ATTR_0) |
				((*(p + LCD_UKEY_PHY_ATTR_0 + 1)) << 8)) & 0xff;
			pconf->lcd_control.vbyone_config->phy_preem =
				(*(p + LCD_UKEY_PHY_ATTR_1) |
				((*(p + LCD_UKEY_PHY_ATTR_1 + 1)) << 8)) & 0xff;
		}
	}

	/* step 3: check power sequence */
	ret = lcd_power_load_from_unifykey(pconf, para, key_len, len);
	if (ret < 0) {
		free(para);
		return -1;
	}

	free(para);
	return 0;
}

static void lcd_config_init(struct lcd_config_s *pconf)
{
	unsigned int h_period = pconf->lcd_basic.h_period;
	unsigned int v_period = pconf->lcd_basic.v_period;
	unsigned int clk = pconf->lcd_timing.lcd_clk;
	unsigned int sync_duration;

	if (clk < 200) { /* regard as frame_rate */
		sync_duration = clk * 100;
		pconf->lcd_timing.lcd_clk = clk * h_period * v_period;
	} else { /* regard as pixel clock */
		sync_duration = ((clk / h_period) * 100) / v_period;
	}
	pconf->lcd_timing.lcd_clk_dft = pconf->lcd_timing.lcd_clk;
	pconf->lcd_timing.h_period_dft = pconf->lcd_basic.h_period;
	pconf->lcd_timing.v_period_dft = pconf->lcd_basic.v_period;
	pconf->lcd_timing.sync_duration_num = sync_duration;
	pconf->lcd_timing.sync_duration_den = 100;

	lcd_timing_init_config(pconf);
	lcd_tablet_config_update(pconf);
	lcd_clk_generate_parameter(pconf);
}

static int lcd_config_check(char *mode)
{
	int ret;

	ret = check_lcd_output_mode(mode);
	if (ret)
		return -1;

	return 0;
}

int get_lcd_tablet_config(char *dt_addr, int load_id)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int ret = 0;

	strcpy(lcd_drv->version, LCD_DRV_VERSION);
	lcd_drv->list_support_mode = lcd_list_support_mode;
	lcd_drv->outputmode_check = check_lcd_output_mode;
	lcd_drv->config_check = lcd_config_check;
	lcd_drv->driver_init_pre = lcd_tablet_driver_init_pre;
	lcd_drv->driver_init = lcd_tablet_driver_init;
	lcd_drv->driver_disable = lcd_tablet_driver_disable;

	if (load_id & 0x10) { /* unifykey */
		ret = lcd_config_load_from_unifykey(lcd_drv->lcd_config);
		ret = lcd_pinmux_load_config(dt_addr, lcd_drv->lcd_config);
	} else if (load_id & 0x1) { /* dts */
#ifdef CONFIG_OF_LIBFDT
		ret = lcd_config_load_from_dts(dt_addr, lcd_drv->lcd_config);
#endif
		ret = lcd_pinmux_load_config(dt_addr, lcd_drv->lcd_config);
	} else { /* bsp */
		ret = lcd_config_load_from_bsp(lcd_drv->lcd_config);
		ret = lcd_pinmux_load_config(dt_addr, lcd_drv->lcd_config);
	}
	if (ret)
		return -1;

	lcd_config_init(lcd_drv->lcd_config);
	lcd_config_load_print(lcd_drv->lcd_config);

	return 0;
}


