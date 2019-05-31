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
		LCDPR("lane_reverse = %d\n", pconf->lcd_control.lvds_config->lane_reverse);
	} else if (pconf->lcd_basic.lcd_type == LCD_P2P) {
		LCDPR("p2p_type = %d\n", pconf->lcd_control.p2p_config->p2p_type);
		LCDPR("lane_num = %d\n", pconf->lcd_control.p2p_config->lane_num);
		LCDPR("channel_sel0 = %d\n", pconf->lcd_control.p2p_config->channel_sel0);
		LCDPR("channel_sel1 = %d\n", pconf->lcd_control.p2p_config->channel_sel1);
		LCDPR("pn_swap = %d\n", pconf->lcd_control.p2p_config->pn_swap);
		LCDPR("bit_swap = %d\n", pconf->lcd_control.p2p_config->bit_swap);
	}
}

#ifdef CONFIG_OF_LIBFDT
static int lcd_config_load_from_dts(char *dt_addr, struct lcd_config_s *pconf)
{
	int parent_offset;
	int child_offset;
	char propname[30];
	char *propdata;
	int len;
	struct lvds_config_s *lvds_conf;
	struct vbyone_config_s *vx1_conf;
	struct mlvds_config_s *mlvds_conf;
	struct p2p_config_s *p2p_conf;

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
		LCDPR("no range_setting\n");
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
		pconf->lcd_timing.lcd_clk = be32_to_cpup((((u32*)propdata)+3));
	}

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_LVDS:
		if (pconf->lcd_control.lvds_config == NULL) {
			LCDERR("lvds_config is null\n");
			return -1;
		}
		lvds_conf = pconf->lcd_control.lvds_config;
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "lvds_attr", &len);
		if (propdata == NULL) {
			LCDERR("failed to get lvds_attr\n");
		} else {
			len = len / 4;
			if (len == 5) {
				lvds_conf->lvds_repack = be32_to_cpup((u32*)propdata);
				lvds_conf->dual_port   = be32_to_cpup((((u32*)propdata)+1));
				lvds_conf->pn_swap     = be32_to_cpup((((u32*)propdata)+2));
				lvds_conf->port_swap   = be32_to_cpup((((u32*)propdata)+3));
				lvds_conf->lane_reverse = be32_to_cpup((((u32*)propdata)+4));
			} else if (len == 4) {
				lvds_conf->lvds_repack = be32_to_cpup((u32*)propdata);
				lvds_conf->dual_port   = be32_to_cpup((((u32*)propdata)+1));
				lvds_conf->pn_swap     = be32_to_cpup((((u32*)propdata)+2));
				lvds_conf->port_swap   = be32_to_cpup((((u32*)propdata)+3));
				lvds_conf->lane_reverse = 0;
			} else {
				LCDERR("invalid lvds_attr parameters cnt: %d\n", len);
			}
		}

		propdata = (char *)fdt_getprop(dt_addr, child_offset, "phy_attr", &len);
		if (propdata == NULL) {
			if (lcd_debug_print_flag)
				LCDPR("failed to get phy_attr\n");
			lvds_conf->phy_vswing = LVDS_PHY_VSWING_DFT;
			lvds_conf->phy_preem  = LVDS_PHY_PREEM_DFT;
			lvds_conf->phy_clk_vswing = LVDS_PHY_CLK_VSWING_DFT;
			lvds_conf->phy_clk_preem  = LVDS_PHY_CLK_PREEM_DFT;
		} else {
			len = len / 4;
			if (len == 4) {
				lvds_conf->phy_vswing = be32_to_cpup((u32*)propdata);
				lvds_conf->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
				lvds_conf->phy_clk_vswing = be32_to_cpup((((u32*)propdata)+2));
				lvds_conf->phy_clk_preem  = be32_to_cpup((((u32*)propdata)+3));
				if (lcd_debug_print_flag) {
					LCDPR("set phy vswing=0x%x, preemphasis=0x%x\n",
						lvds_conf->phy_vswing, lvds_conf->phy_preem);
					LCDPR("set phy clk_vswing=0x%x, clk_preemphasis=0x%x\n",
						lvds_conf->phy_clk_vswing, lvds_conf->phy_clk_preem);
				}
			} else if (len == 2) {
				lvds_conf->phy_vswing = be32_to_cpup((u32*)propdata);
				lvds_conf->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
				lvds_conf->phy_clk_vswing = LVDS_PHY_CLK_VSWING_DFT;
				lvds_conf->phy_clk_preem  = LVDS_PHY_CLK_PREEM_DFT;
				if (lcd_debug_print_flag) {
					LCDPR("set phy vswing=0x%x, preemphasis=0x%x\n",
						lvds_conf->phy_vswing, lvds_conf->phy_preem);
				}
			} else {
				LCDERR("invalid phy_attr parameters cnt: %d\n", len);
			}
		}
		break;
	case LCD_MLVDS:
		if (pconf->lcd_control.mlvds_config == NULL) {
			LCDERR("mlvds_config is null\n");
			return -1;
		}
		mlvds_conf = pconf->lcd_control.mlvds_config;
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "minilvds_attr", &len);
		if (propdata == NULL) {
			LCDERR("failed to get minilvds_attr\n");
		} else {
			mlvds_conf->channel_num  = be32_to_cpup((u32*)propdata);
			mlvds_conf->channel_sel0 = be32_to_cpup((((u32*)propdata)+1));
			mlvds_conf->channel_sel1 = be32_to_cpup((((u32*)propdata)+2));
			mlvds_conf->clk_phase    = be32_to_cpup((((u32*)propdata)+3));
			mlvds_conf->pn_swap      = be32_to_cpup((((u32*)propdata)+4));
			mlvds_conf->bit_swap     = be32_to_cpup((((u32*)propdata)+5));
		}

		propdata = (char *)fdt_getprop(dt_addr, child_offset, "phy_attr", &len);
		if (propdata == NULL) {
			if (lcd_debug_print_flag)
				LCDPR("failed to get phy_attr\n");
			mlvds_conf->phy_vswing = LVDS_PHY_VSWING_DFT;
			mlvds_conf->phy_preem  = LVDS_PHY_PREEM_DFT;
		} else {
			mlvds_conf->phy_vswing = be32_to_cpup((u32*)propdata);
			mlvds_conf->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
			if (lcd_debug_print_flag) {
				LCDPR("set phy vswing=0x%x, preemphasis=0x%x\n",
					mlvds_conf->phy_vswing, mlvds_conf->phy_preem);
			}
		}
		break;
	case LCD_VBYONE:
		if (pconf->lcd_control.vbyone_config == NULL) {
			LCDERR("vbyone_config is null\n");
			return -1;
		}
		vx1_conf = pconf->lcd_control.vbyone_config;
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "vbyone_attr", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get vbyone_attr\n");
		} else {
			vx1_conf->lane_count = be32_to_cpup((u32*)propdata);
			vx1_conf->region_num = be32_to_cpup((((u32*)propdata)+1));
			vx1_conf->byte_mode  = be32_to_cpup((((u32*)propdata)+2));
			vx1_conf->color_fmt  = be32_to_cpup((((u32*)propdata)+3));
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "phy_attr", NULL);
		if (propdata == NULL) {
			if (lcd_debug_print_flag)
				LCDPR("failed to get phy_attr\n");
			vx1_conf->phy_vswing = VX1_PHY_VSWING_DFT;
			vx1_conf->phy_preem  = VX1_PHY_PREEM_DFT;
		} else {
			vx1_conf->phy_vswing = be32_to_cpup((u32*)propdata);
			vx1_conf->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
			if (lcd_debug_print_flag) {
				LCDPR("set phy vswing=0x%x, preemphasis=0x%x\n",
					vx1_conf->phy_vswing, vx1_conf->phy_preem);
			}
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "vbyone_ctrl_flag", NULL);
		if (propdata == NULL) {
			if (lcd_debug_print_flag)
				LCDPR("failed to get vbyone_ctrl_flag\n");
			vx1_conf->ctrl_flag = 0;
			vx1_conf->power_on_reset_delay = VX1_PWR_ON_RESET_DLY_DFT;
			vx1_conf->hpd_data_delay = VX1_HPD_DATA_DELAY_DFT;
			vx1_conf->cdr_training_hold = VX1_CDR_TRAINING_HOLD_DFT;
			vx1_conf->vx1_sw_filter_en = 0;
			vx1_conf->vx1_sw_filter_time = VX1_SW_FILTER_TIME_DFT;
			vx1_conf->vx1_sw_filter_cnt = VX1_SW_FILTER_CNT_DFT;
			vx1_conf->vx1_sw_filter_retry_cnt = VX1_SW_FILTER_RETRY_CNT_DFT;
			vx1_conf->vx1_sw_filter_retry_delay = VX1_SW_FILTER_RETRY_DLY_DFT;
			vx1_conf->vx1_sw_cdr_detect_time = VX1_SW_CDR_DET_TIME_DFT;
			vx1_conf->vx1_sw_cdr_detect_cnt = VX1_SW_CDR_DET_CNT_DFT;
			vx1_conf->vx1_sw_cdr_timeout_cnt = VX1_SW_CDR_TIMEOUT_CNT_DFT;
		} else {
			vx1_conf->ctrl_flag = be32_to_cpup((u32*)propdata);
			vx1_conf->vx1_sw_filter_en = (vx1_conf->ctrl_flag >> 4) & 3;
			LCDPR("vbyone ctrl_flag=0x%x\n", vx1_conf->ctrl_flag);
		}
		if (vx1_conf->ctrl_flag & 0x7) {
			propdata = (char *)fdt_getprop(dt_addr, child_offset, "vbyone_ctrl_timing", NULL);
			if (propdata == NULL) {
				LCDPR("failed to get vbyone_ctrl_timing\n");
				vx1_conf->power_on_reset_delay = VX1_PWR_ON_RESET_DLY_DFT;
				vx1_conf->hpd_data_delay = VX1_HPD_DATA_DELAY_DFT;
				vx1_conf->cdr_training_hold = VX1_CDR_TRAINING_HOLD_DFT;
			} else {
				vx1_conf->power_on_reset_delay = be32_to_cpup((u32*)propdata);
				vx1_conf->hpd_data_delay = be32_to_cpup((((u32*)propdata)+1));
				vx1_conf->cdr_training_hold = be32_to_cpup((((u32*)propdata)+2));
			}
			if (lcd_debug_print_flag) {
				LCDPR("power_on_reset_delay: %d\n", vx1_conf->power_on_reset_delay);
				LCDPR("hpd_data_delay: %d\n", vx1_conf->hpd_data_delay);
				LCDPR("cdr_training_hold: %d\n", vx1_conf->cdr_training_hold);
			}
		}
		if (vx1_conf->vx1_sw_filter_en) {
			propdata = (char *)fdt_getprop(dt_addr, child_offset, "vbyone_sw_filter", NULL);
			if (propdata == NULL) {
					LCDPR("failed to get vbyone_sw_filter\n");
				vx1_conf->vx1_sw_filter_time = VX1_SW_FILTER_TIME_DFT;
				vx1_conf->vx1_sw_filter_cnt = VX1_SW_FILTER_CNT_DFT;
				vx1_conf->vx1_sw_filter_retry_cnt = VX1_SW_FILTER_RETRY_CNT_DFT;
				vx1_conf->vx1_sw_filter_retry_delay = VX1_SW_FILTER_RETRY_DLY_DFT;
				vx1_conf->vx1_sw_cdr_detect_time = VX1_SW_CDR_DET_TIME_DFT;
				vx1_conf->vx1_sw_cdr_detect_cnt = VX1_SW_CDR_DET_CNT_DFT;
				vx1_conf->vx1_sw_cdr_timeout_cnt = VX1_SW_CDR_TIMEOUT_CNT_DFT;
			} else {
				vx1_conf->vx1_sw_filter_time = be32_to_cpup((u32*)propdata);
				vx1_conf->vx1_sw_filter_cnt = be32_to_cpup((((u32*)propdata)+1));
				vx1_conf->vx1_sw_filter_retry_cnt = be32_to_cpup((((u32*)propdata)+2));
				vx1_conf->vx1_sw_filter_retry_delay = be32_to_cpup((((u32*)propdata)+3));
				vx1_conf->vx1_sw_cdr_detect_time = be32_to_cpup((((u32*)propdata)+4));
				vx1_conf->vx1_sw_cdr_detect_cnt = be32_to_cpup((((u32*)propdata)+5));
				vx1_conf->vx1_sw_cdr_timeout_cnt = be32_to_cpup((((u32*)propdata)+6));
				if (lcd_debug_print_flag) {
					LCDPR("vx1_sw_filter_en: %d\n", vx1_conf->vx1_sw_filter_en);
					LCDPR("vx1_sw_filter_time: %d\n", vx1_conf->vx1_sw_filter_time);
					LCDPR("vx1_sw_filter_cnt: %d\n", vx1_conf->vx1_sw_filter_cnt);
					LCDPR("vx1_sw_filter_retry_cnt: %d\n", vx1_conf->vx1_sw_filter_retry_cnt);
					LCDPR("vx1_sw_filter_retry_delay: %d\n", vx1_conf->vx1_sw_filter_retry_delay);
					LCDPR("vx1_sw_cdr_detect_time: %d\n", vx1_conf->vx1_sw_cdr_detect_time);
					LCDPR("vx1_sw_cdr_detect_cnt: %d\n", vx1_conf->vx1_sw_cdr_detect_cnt);
					LCDPR("vx1_sw_cdr_timeout_cnt: %d\n", vx1_conf->vx1_sw_cdr_timeout_cnt);
				}
			}
		}
		break;
	case LCD_P2P:
		if (pconf->lcd_control.p2p_config == NULL) {
			LCDERR("p2p_config is null\n");
			return -1;
		}
		p2p_conf = pconf->lcd_control.p2p_config;
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "p2p_attr", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get p2p_attr\n");
		} else {
			p2p_conf->p2p_type = be32_to_cpup((u32*)propdata);
			p2p_conf->lane_num = be32_to_cpup((((u32*)propdata)+1));
			p2p_conf->channel_sel0  = be32_to_cpup((((u32*)propdata)+2));
			p2p_conf->channel_sel1  = be32_to_cpup((((u32*)propdata)+3));
			p2p_conf->pn_swap  = be32_to_cpup((((u32*)propdata)+4));
			p2p_conf->bit_swap  = be32_to_cpup((((u32*)propdata)+5));
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "phy_attr", NULL);
		if (propdata == NULL) {
			if (lcd_debug_print_flag)
				LCDPR("failed to get phy_attr\n");
			p2p_conf->phy_vswing = 0;
			p2p_conf->phy_preem  = 0;
		} else {
			p2p_conf->phy_vswing = be32_to_cpup((u32*)propdata);
			p2p_conf->phy_preem  = be32_to_cpup((((u32*)propdata)+1));
			if (lcd_debug_print_flag) {
				LCDPR("set phy vswing=0x%x, preemphasis=0x%x\n",
					p2p_conf->phy_vswing, p2p_conf->phy_preem);
			}
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
	unsigned int i;
	unsigned int temp;
	struct lcd_power_step_s *power_step;

	if (panel_type == NULL) {
		LCDERR("no panel_type, use default lcd config\n ");
		return -1;
	}
	for (i = 0 ; i < LCD_NUM_MAX ; i++) {
		ext_lcd = &ext_lcd_config[i];
		if (strcmp(ext_lcd->panel_type, panel_type) == 0)
			break ;
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
	/* clk_freq */
	temp = ext_lcd->customer_val_3;
	if (temp == Rsv_val)
		pconf->lcd_timing.lcd_clk = 0;
	else
		pconf->lcd_timing.lcd_clk = temp;

	if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
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

		pconf->lcd_control.vbyone_config->ctrl_flag = 0;
		pconf->lcd_control.vbyone_config->power_on_reset_delay = VX1_PWR_ON_RESET_DLY_DFT;
		pconf->lcd_control.vbyone_config->hpd_data_delay = VX1_HPD_DATA_DELAY_DFT;
		pconf->lcd_control.vbyone_config->cdr_training_hold = VX1_CDR_TRAINING_HOLD_DFT;
		pconf->lcd_control.vbyone_config->vx1_sw_filter_en = 0;
		pconf->lcd_control.vbyone_config->vx1_sw_filter_time = VX1_SW_FILTER_TIME_DFT;
		pconf->lcd_control.vbyone_config->vx1_sw_filter_cnt = VX1_SW_FILTER_CNT_DFT;
		pconf->lcd_control.vbyone_config->vx1_sw_filter_retry_cnt = VX1_SW_FILTER_RETRY_CNT_DFT;
		pconf->lcd_control.vbyone_config->vx1_sw_filter_retry_delay = VX1_SW_FILTER_RETRY_DLY_DFT;
		pconf->lcd_control.vbyone_config->vx1_sw_cdr_detect_time = VX1_SW_CDR_DET_TIME_DFT;
		pconf->lcd_control.vbyone_config->vx1_sw_cdr_detect_cnt = VX1_SW_CDR_DET_CNT_DFT;
		pconf->lcd_control.vbyone_config->vx1_sw_cdr_timeout_cnt = VX1_SW_CDR_TIMEOUT_CNT_DFT;
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
	} else if (pconf->lcd_basic.lcd_type == LCD_MLVDS) {
		if (pconf->lcd_control.mlvds_config == NULL) {
			LCDERR("mlvds_config is null\n");
			return -1;
		}
		pconf->lcd_control.mlvds_config->channel_num = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.mlvds_config->channel_sel0 = ext_lcd->lcd_spc_val1;
		pconf->lcd_control.mlvds_config->channel_sel1 = ext_lcd->lcd_spc_val2;
		pconf->lcd_control.mlvds_config->clk_phase  = ext_lcd->lcd_spc_val3;
		pconf->lcd_control.mlvds_config->pn_swap    = ext_lcd->lcd_spc_val4;
		pconf->lcd_control.mlvds_config->bit_swap   = ext_lcd->lcd_spc_val5;
		if ((ext_lcd->lcd_spc_val6 == Rsv_val) ||
			(ext_lcd->lcd_spc_val7 == Rsv_val)) {
			pconf->lcd_control.mlvds_config->phy_vswing = LVDS_PHY_VSWING_DFT;
			pconf->lcd_control.mlvds_config->phy_preem  = LVDS_PHY_PREEM_DFT;
		} else {
			pconf->lcd_control.mlvds_config->phy_vswing = ext_lcd->lcd_spc_val6;
			pconf->lcd_control.mlvds_config->phy_preem  = ext_lcd->lcd_spc_val7;
		}
	} else if (pconf->lcd_basic.lcd_type == LCD_P2P) {
		if (pconf->lcd_control.p2p_config == NULL) {
			LCDERR("p2p_config is null\n");
			return -1;
		}
		pconf->lcd_control.p2p_config->p2p_type = ext_lcd->lcd_spc_val0;
		pconf->lcd_control.p2p_config->lane_num = ext_lcd->lcd_spc_val1;
		pconf->lcd_control.p2p_config->channel_sel0 = ext_lcd->lcd_spc_val2;
		pconf->lcd_control.p2p_config->channel_sel1 = ext_lcd->lcd_spc_val3;
		pconf->lcd_control.p2p_config->pn_swap    = ext_lcd->lcd_spc_val4;
		pconf->lcd_control.p2p_config->bit_swap   = ext_lcd->lcd_spc_val5;
		if ((ext_lcd->lcd_spc_val6 == Rsv_val) ||
			(ext_lcd->lcd_spc_val7 == Rsv_val)) {
			pconf->lcd_control.p2p_config->phy_vswing = VX1_PHY_VSWING_DFT;
			pconf->lcd_control.p2p_config->phy_preem  = VX1_PHY_PREEM_DFT;
		} else {
			pconf->lcd_control.p2p_config->phy_vswing = ext_lcd->lcd_spc_val6;
			pconf->lcd_control.p2p_config->phy_preem  = ext_lcd->lcd_spc_val7;
		}
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

	return 0;
}

static int lcd_config_load_from_unifykey(struct lcd_config_s *pconf)
{
	unsigned char *para;
	int key_len, len;
	unsigned char *p;
	const char *str;
	struct aml_lcd_unifykey_header_s lcd_header;
	int ret;
	struct lvds_config_s *lvdsconf = pconf->lcd_control.lvds_config;
	struct vbyone_config_s *vx1_conf = pconf->lcd_control.vbyone_config;
	struct mlvds_config_s *mlvds_conf = pconf->lcd_control.mlvds_config;
	struct p2p_config_s *p2p_conf = pconf->lcd_control.p2p_config;

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
	pconf->lcd_timing.hsync_bp = (*(p + LCD_UKEY_HS_BP) |
		((*(p + LCD_UKEY_HS_BP + 1)) << 8));
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
		((*(p + LCD_UKEY_V_PERIOD_MIN + 1)) << 8));
	pconf->lcd_basic.v_period_max = (*(p + LCD_UKEY_V_PERIOD_MAX) |
		((*(p + LCD_UKEY_V_PERIOD_MAX + 1)) << 8));
	pconf->lcd_basic.lcd_clk_min = (*(p + LCD_UKEY_PCLK_MIN) |
		((*(p + LCD_UKEY_PCLK_MIN + 1)) << 8) |
		((*(p + LCD_UKEY_PCLK_MIN + 2)) << 16) |
		((*(p + LCD_UKEY_PCLK_MIN + 3)) << 24));
	pconf->lcd_basic.lcd_clk_max = (*(p + LCD_UKEY_PCLK_MAX) |
		((*(p + LCD_UKEY_PCLK_MAX + 1)) << 8) |
		((*(p + LCD_UKEY_PCLK_MAX + 2)) << 16) |
		((*(p + LCD_UKEY_PCLK_MAX + 3)) << 24));

	/* interface: 20byte */
	if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
		if (pconf->lcd_control.vbyone_config == NULL) {
			LCDERR("vbyone_config is null\n");
			free(para);
			return -1;
		}
		if (lcd_header.version == 2) {
			vx1_conf->lane_count = (*(p + LCD_UKEY_IF_ATTR_0) |
				((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			vx1_conf->region_num = (*(p + LCD_UKEY_IF_ATTR_1) |
				((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0xff;
			vx1_conf->byte_mode = (*(p + LCD_UKEY_IF_ATTR_2) |
				((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0xff;
			vx1_conf->color_fmt = (*(p + LCD_UKEY_IF_ATTR_3) |
				((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0xff;
		} else {
			vx1_conf->lane_count = (*(p + LCD_UKEY_IF_ATTR_0) |
				((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			vx1_conf->region_num = (*(p + LCD_UKEY_IF_ATTR_1) |
				((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0xff;
			vx1_conf->byte_mode = (*(p + LCD_UKEY_IF_ATTR_2) |
				((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0xff;
			vx1_conf->color_fmt = (*(p + LCD_UKEY_IF_ATTR_3) |
				((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0xff;
			vx1_conf->phy_vswing = (*(p + LCD_UKEY_IF_ATTR_4) |
				((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 8)) & 0xff;
			vx1_conf->phy_preem = (*(p + LCD_UKEY_IF_ATTR_5) |
				((*(p + LCD_UKEY_IF_ATTR_5 + 1)) << 8)) & 0xff;
		}
	} else if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
		if (pconf->lcd_control.lvds_config == NULL) {
			LCDERR("lvds_config is null\n");
			free(para);
			return -1;
		}
		if (lcd_header.version == 2) {
			lvdsconf->lvds_repack = (*(p + LCD_UKEY_IF_ATTR_0) |
				((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			lvdsconf->dual_port = (*(p + LCD_UKEY_IF_ATTR_1) |
				((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0xff;
			lvdsconf->pn_swap = (*(p + LCD_UKEY_IF_ATTR_2) |
				((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0xff;
			lvdsconf->port_swap = (*(p + LCD_UKEY_IF_ATTR_3) |
				((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0xff;
			lvdsconf->lane_reverse = (*(p + LCD_UKEY_IF_ATTR_4) |
				((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 8)) & 0xff;
		} else {
			lvdsconf->lvds_repack = (*(p + LCD_UKEY_IF_ATTR_0) |
				((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			lvdsconf->dual_port = (*(p + LCD_UKEY_IF_ATTR_1) |
				((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8)) & 0xff;
			lvdsconf->pn_swap = (*(p + LCD_UKEY_IF_ATTR_2) |
				((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8)) & 0xff;
			lvdsconf->port_swap = (*(p + LCD_UKEY_IF_ATTR_3) |
				((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8)) & 0xff;
			lvdsconf->phy_vswing = (*(p + LCD_UKEY_IF_ATTR_4) |
				((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 8)) & 0xff;
			lvdsconf->phy_preem = (*(p + LCD_UKEY_IF_ATTR_5) |
				((*(p + LCD_UKEY_IF_ATTR_5 + 1)) << 8)) & 0xff;
			lvdsconf->phy_clk_vswing = (*(p + LCD_UKEY_IF_ATTR_6) |
				((*(p + LCD_UKEY_IF_ATTR_6 + 1)) << 8)) & 0xff;
			lvdsconf->phy_clk_preem = (*(p + LCD_UKEY_IF_ATTR_7) |
				((*(p + LCD_UKEY_IF_ATTR_7 + 1)) << 8)) & 0xff;

			lvdsconf->lane_reverse = 0;
		}
	} else if (pconf->lcd_basic.lcd_type == LCD_MLVDS) {
		if (pconf->lcd_control.mlvds_config == NULL) {
			LCDERR("mlvds_config is null\n");
			free(para);
			return -1;
		}
		if (lcd_header.version == 2) {
			mlvds_conf->channel_num = (*(p + LCD_UKEY_IF_ATTR_0) |
				((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			mlvds_conf->channel_sel0 = (*(p + LCD_UKEY_IF_ATTR_1) |
				((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8) |
				((*(p + LCD_UKEY_IF_ATTR_2)) << 16) |
				((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 24));
			mlvds_conf->channel_sel1 = (*(p + LCD_UKEY_IF_ATTR_3) |
				((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8) |
				((*(p + LCD_UKEY_IF_ATTR_4)) << 16) |
				((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 24));
			mlvds_conf->clk_phase = (*(p + LCD_UKEY_IF_ATTR_5) |
				((*(p + LCD_UKEY_IF_ATTR_5 + 1)) << 8));
			mlvds_conf->pn_swap = (*(p + LCD_UKEY_IF_ATTR_6) |
				((*(p + LCD_UKEY_IF_ATTR_6 + 1)) << 8)) & 0xff;
			mlvds_conf->bit_swap = (*(p + LCD_UKEY_IF_ATTR_7) |
				((*(p + LCD_UKEY_IF_ATTR_7 + 1)) << 8)) & 0xff;
		} else if (lcd_header.version == 1) {
			mlvds_conf->channel_num = (*(p + LCD_UKEY_IF_ATTR_0) |
				((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8)) & 0xff;
			mlvds_conf->channel_sel0 = (*(p + LCD_UKEY_IF_ATTR_1) |
				((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8) |
				((*(p + LCD_UKEY_IF_ATTR_2)) << 16) |
				((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 24));
			mlvds_conf->channel_sel1 = (*(p + LCD_UKEY_IF_ATTR_3) |
				((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 8) |
				((*(p + LCD_UKEY_IF_ATTR_4)) << 16) |
				((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 24));
			mlvds_conf->clk_phase = (*(p + LCD_UKEY_IF_ATTR_5) |
				((*(p + LCD_UKEY_IF_ATTR_5 + 1)) << 8));
			mlvds_conf->pn_swap = (*(p + LCD_UKEY_IF_ATTR_6) |
				((*(p + LCD_UKEY_IF_ATTR_6 + 1)) << 8)) & 0xff;
			mlvds_conf->bit_swap = (*(p + LCD_UKEY_IF_ATTR_7) |
				((*(p + LCD_UKEY_IF_ATTR_7 + 1)) << 8)) & 0xff;
			mlvds_conf->phy_vswing = (*(p + LCD_UKEY_IF_ATTR_8) |
				((*(p + LCD_UKEY_IF_ATTR_8 + 1)) << 8)) & 0xff;
			mlvds_conf->phy_preem = (*(p + LCD_UKEY_IF_ATTR_9) |
				((*(p + LCD_UKEY_IF_ATTR_9 + 1)) << 8)) & 0xff;
		}
	} else if (pconf->lcd_basic.lcd_type == LCD_P2P) {
		if (pconf->lcd_control.p2p_config == NULL) {
			LCDERR("p2p_config is null\n");
			free(para);
			return -1;
		}
		p2p_conf->p2p_type = (*(p + LCD_UKEY_IF_ATTR_0) |
			((*(p + LCD_UKEY_IF_ATTR_0 + 1)) << 8));
		p2p_conf->lane_num = (*(p + LCD_UKEY_IF_ATTR_1) |
			((*(p + LCD_UKEY_IF_ATTR_1 + 1)) << 8));
		p2p_conf->channel_sel0 = (*(p + LCD_UKEY_IF_ATTR_2) |
			((*(p + LCD_UKEY_IF_ATTR_2 + 1)) << 8) |
			(*(p + LCD_UKEY_IF_ATTR_3) << 16) |
			((*(p + LCD_UKEY_IF_ATTR_3 + 1)) << 24));
		p2p_conf->channel_sel1 = (*(p + LCD_UKEY_IF_ATTR_4) |
			((*(p + LCD_UKEY_IF_ATTR_4 + 1)) << 8) |
			(*(p + LCD_UKEY_IF_ATTR_5) << 16) |
			((*(p + LCD_UKEY_IF_ATTR_5 + 1)) << 24));
		p2p_conf->pn_swap = (*(p + LCD_UKEY_IF_ATTR_6) |
			((*(p + LCD_UKEY_IF_ATTR_6 + 1)) << 8));
		p2p_conf->bit_swap = (*(p + LCD_UKEY_IF_ATTR_7) |
			((*(p + LCD_UKEY_IF_ATTR_7 + 1)) << 8));
		p2p_conf->phy_vswing = (*(p + LCD_UKEY_IF_ATTR_8) |
			((*(p + LCD_UKEY_IF_ATTR_8 + 1)) << 8));
		p2p_conf->phy_preem = (*(p + LCD_UKEY_IF_ATTR_9) |
			((*(p + LCD_UKEY_IF_ATTR_9 + 1)) << 8));
	} else
		LCDERR("unsupport lcd_type: %d\n", pconf->lcd_basic.lcd_type);

	if (lcd_header.version == 2) {
		/* ctrl: 44byte */ /* v2 */
		if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
			vx1_conf->ctrl_flag = (*(p + LCD_UKEY_CTRL_FLAG) |
				((*(p + LCD_UKEY_CTRL_FLAG + 1)) << 8) |
				((*(p + LCD_UKEY_CTRL_FLAG + 2)) << 16) |
				((*(p + LCD_UKEY_CTRL_FLAG + 3)) << 24));
			vx1_conf->power_on_reset_delay = (*(p + LCD_UKEY_CTRL_ATTR_0) |
				((*(p + LCD_UKEY_CTRL_ATTR_0 + 1)) << 8));
			vx1_conf->hpd_data_delay = (*(p + LCD_UKEY_CTRL_ATTR_1) |
				((*(p  + LCD_UKEY_CTRL_ATTR_1 + 1)) << 8));
			vx1_conf->cdr_training_hold = (*(p + LCD_UKEY_CTRL_ATTR_2) |
				((*(p + LCD_UKEY_CTRL_ATTR_2 + 1)) << 8));

			vx1_conf->vx1_sw_filter_en = (vx1_conf->ctrl_flag >> 4) & 0x3;
			vx1_conf->vx1_sw_filter_time = (*(p + LCD_UKEY_CTRL_ATTR_7) |
				((*(p + LCD_UKEY_CTRL_ATTR_7 + 1)) << 8)) & 0xff;
			vx1_conf->vx1_sw_filter_cnt = (*(p + LCD_UKEY_CTRL_ATTR_8) |
				((*(p + LCD_UKEY_CTRL_ATTR_8 + 1)) << 8)) & 0xff;
			vx1_conf->vx1_sw_filter_retry_cnt = (*(p + LCD_UKEY_CTRL_ATTR_9) |
				((*(p + LCD_UKEY_CTRL_ATTR_9 + 1)) << 8)) & 0xff;
			vx1_conf->vx1_sw_filter_retry_delay = (*(p + LCD_UKEY_CTRL_ATTR_10) |
				((*(p + LCD_UKEY_CTRL_ATTR_10 + 1)) << 8)) & 0xff;
			vx1_conf->vx1_sw_cdr_detect_time = (*(p + LCD_UKEY_CTRL_ATTR_11) |
				((*(p + LCD_UKEY_CTRL_ATTR_11 + 1)) << 8)) & 0xff;
			vx1_conf->vx1_sw_cdr_detect_cnt = (*(p + LCD_UKEY_CTRL_ATTR_12) |
				((*(p + LCD_UKEY_CTRL_ATTR_12 + 1)) << 8)) & 0xff;
			vx1_conf->vx1_sw_cdr_timeout_cnt = (*(p + LCD_UKEY_CTRL_ATTR_13) |
				((*(p + LCD_UKEY_CTRL_ATTR_13 + 1)) << 8)) & 0xff;
		}

		/* phy: 10byte */ /* v2 */
		if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
			vx1_conf->phy_vswing = *(p + LCD_UKEY_PHY_ATTR_0);
			vx1_conf->phy_preem = *(p + LCD_UKEY_PHY_ATTR_1);
		} else if (pconf->lcd_basic.lcd_type == LCD_LVDS) {
			lvdsconf->phy_vswing = *(p + LCD_UKEY_PHY_ATTR_0);
			lvdsconf->phy_preem = *(p + LCD_UKEY_PHY_ATTR_1);
			lvdsconf->phy_clk_vswing = *(p + LCD_UKEY_PHY_ATTR_2);
			lvdsconf->phy_clk_preem = *(p + LCD_UKEY_PHY_ATTR_3);
		} else if (pconf->lcd_basic.lcd_type == LCD_MLVDS) {
			mlvds_conf->phy_vswing = *(p + LCD_UKEY_PHY_ATTR_0);
			mlvds_conf->phy_preem = *(p + LCD_UKEY_PHY_ATTR_1);
		}
	} else if (lcd_header.version == 1) {
		if (pconf->lcd_basic.lcd_type == LCD_VBYONE) {
			vx1_conf->ctrl_flag = 0;
			vx1_conf->power_on_reset_delay = VX1_PWR_ON_RESET_DLY_DFT;
			vx1_conf->hpd_data_delay = VX1_HPD_DATA_DELAY_DFT;
			vx1_conf->cdr_training_hold = VX1_CDR_TRAINING_HOLD_DFT;
			vx1_conf->vx1_sw_filter_en = 0;
			vx1_conf->vx1_sw_filter_time = VX1_SW_FILTER_TIME_DFT;
			vx1_conf->vx1_sw_filter_cnt = VX1_SW_FILTER_CNT_DFT;
			vx1_conf->vx1_sw_filter_retry_cnt = VX1_SW_FILTER_RETRY_CNT_DFT;
			vx1_conf->vx1_sw_filter_retry_delay = VX1_SW_FILTER_RETRY_DLY_DFT;
			vx1_conf->vx1_sw_cdr_detect_time = VX1_SW_CDR_DET_TIME_DFT;
			vx1_conf->vx1_sw_cdr_detect_cnt = VX1_SW_CDR_DET_CNT_DFT;
			vx1_conf->vx1_sw_cdr_timeout_cnt = VX1_SW_CDR_TIMEOUT_CNT_DFT;
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
	unsigned int clk;

	if (pconf->lcd_timing.lcd_clk == 0) /* default 0 for 60hz */
		pconf->lcd_timing.lcd_clk = 60;
	else
		LCDPR("custome clk: %d\n", pconf->lcd_timing.lcd_clk);
	clk = pconf->lcd_timing.lcd_clk;
	if (clk < 200) { /* regard as frame_rate */
		pconf->lcd_timing.lcd_clk = clk * pconf->lcd_basic.h_period *
			pconf->lcd_basic.v_period;
	} else /* regard as pixel clock */
		pconf->lcd_timing.lcd_clk = clk;
	pconf->lcd_timing.lcd_clk_dft = pconf->lcd_timing.lcd_clk;
	pconf->lcd_timing.h_period_dft = pconf->lcd_basic.h_period;
	pconf->lcd_timing.v_period_dft = pconf->lcd_basic.v_period;
	pconf->lcd_timing.sync_duration_num = ((pconf->lcd_timing.lcd_clk / pconf->lcd_basic.h_period) * 100) / pconf->lcd_basic.v_period;
	pconf->lcd_timing.sync_duration_den = 100;

	lcd_timing_init_config(pconf);
}

static int lcd_outputmode_check(char *mode)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int lcd_vmode;

	lcd_vmode = check_lcd_output_mode(lcd_drv->lcd_config, mode);
	if (lcd_vmode >= LCD_VMODE_MAX)
		return -1;

	return 0;
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
	lcd_clk_generate_parameter(lcd_drv->lcd_config);

	return 0;
}

int get_lcd_tv_config(char *dt_addr, int load_id)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	int ret = 0;

	strcpy(lcd_drv->version, LCD_DRV_VERSION);
	lcd_drv->list_support_mode = lcd_list_support_mode;
	lcd_drv->outputmode_check = lcd_outputmode_check;
	lcd_drv->config_check = lcd_config_check;
	lcd_drv->driver_init_pre = lcd_tv_driver_init_pre;
	lcd_drv->driver_init = lcd_tv_driver_init;
	lcd_drv->driver_disable = lcd_tv_driver_disable;

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

	lcd_config_load_print(lcd_drv->lcd_config);
	lcd_config_init(lcd_drv->lcd_config);

	return 0;
}


