/*
 * drivers/display/lcd/aml_lcd_common.c
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
#include <amlogic/aml_lcd.h>
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"

struct lcd_type_match_s {
	char *name;
	enum lcd_type_e type;
};

static struct lcd_type_match_s lcd_type_match_table[] = {
	{"ttl",     LCD_TTL},
	{"lvds",    LCD_LVDS},
	{"vbyone",  LCD_VBYONE},
	{"mipi",    LCD_MIPI},
	{"edp",     LCD_EDP},
	{"invalid", LCD_TYPE_MAX},
};

int lcd_type_str_to_type(const char *str)
{
	int type = LCD_TYPE_MAX;
	int i;

	for (i = 0; i < ARRAY_SIZE(lcd_type_match_table); i++) {
		if (!strcmp(str, lcd_type_match_table[i].name)) {
			type = lcd_type_match_table[i].type;
			break;
		}
	}
	return type;
}

char *lcd_type_type_to_str(int type)
{
	char *name = lcd_type_match_table[LCD_TYPE_MAX].name;
	int i;

	for (i = 0; i < ARRAY_SIZE(lcd_type_match_table); i++) {
		if (type == lcd_type_match_table[i].type) {
			name = lcd_type_match_table[i].name;
			break;
		}
	}
	return name;
}

static char *lcd_mode_table[] = {
	"tv",
	"tablet",
	"invalid",
};

int lcd_mode_str_to_mode(const char *str)
{
	int mode;

	for (mode = 0; mode < ARRAY_SIZE(lcd_mode_table); mode++) {
		if (!strcmp(str, lcd_mode_table[mode]))
			break;
	}
	return mode;
}

char *lcd_mode_mode_to_str(int mode)
{
	return lcd_mode_table[mode];
}

unsigned int lcd_lvds_channel_on_value(struct lcd_config_s *pconf)
{
	unsigned int channel_on = 0;

	if (pconf->lcd_control.lvds_config->dual_port == 0) {
		if (pconf->lcd_control.lvds_config->lane_reverse == 0) {
			switch (pconf->lcd_basic.lcd_bits) {
			case 6:
				channel_on = 0xf;
				break;
			case 8:
				channel_on = 0x1f;
				break;
			case 10:
			default:
				channel_on = 0x3f;
				break;
			}
		} else {
			switch (pconf->lcd_basic.lcd_bits) {
			case 6:
				channel_on = 0x3c;
				break;
			case 8:
				channel_on = 0x3e;
				break;
			case 10:
			default:
				channel_on = 0x3f;
				break;
			}
		}
		if (pconf->lcd_control.lvds_config->port_swap == 1)
			channel_on = (channel_on << 6); /* use channel B */
	} else {
		if (pconf->lcd_control.lvds_config->lane_reverse == 0) {
			switch (pconf->lcd_basic.lcd_bits) {
			case 6:
				channel_on = 0x3cf;
				break;
			case 8:
				channel_on = 0x7df;
				break;
			case 10:
			default:
				channel_on = 0xfff;
				break;
			}
		} else {
			switch (pconf->lcd_basic.lcd_bits) {
			case 6:
				channel_on = 0xf3c;
				break;
			case 8:
				channel_on = 0xfbe;
				break;
			case 10:
			default:
				channel_on = 0xfff;
				break;
			}
		}
	}
	return channel_on;
}

void lcd_tcon_config(struct lcd_config_s *pconf)
{
	unsigned short h_period, v_period, h_active, v_active;
	unsigned short hsync_bp, hsync_width, vsync_bp, vsync_width;
	unsigned short de_hstart, de_vstart;
	unsigned short hstart, hend, vstart, vend;
	unsigned short h_delay;

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_TTL:
		h_delay = TTL_DELAY;
		break;
	default:
		h_delay = 0;
		break;
	}
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

	pconf->lcd_timing.video_on_pixel = de_hstart - h_delay;
	pconf->lcd_timing.video_on_line = de_vstart;

	pconf->lcd_timing.de_hs_addr = de_hstart;
	pconf->lcd_timing.de_he_addr = de_hstart + h_active;
	pconf->lcd_timing.de_vs_addr = de_vstart;
	pconf->lcd_timing.de_ve_addr = de_vstart + v_active - 1;

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

	if (lcd_debug_print_flag) {
		LCDPR("hs_hs_addr=%d, hs_he_addr=%d, hs_vs_addr=%d, hs_ve_addr=%d\n",
			pconf->lcd_timing.hs_hs_addr, pconf->lcd_timing.hs_he_addr,
			pconf->lcd_timing.hs_vs_addr, pconf->lcd_timing.hs_ve_addr);
		LCDPR("vs_hs_addr=%d, vs_he_addr=%d, vs_vs_addr=%d, vs_ve_addr=%d\n",
			pconf->lcd_timing.vs_hs_addr, pconf->lcd_timing.vs_he_addr,
			pconf->lcd_timing.vs_vs_addr, pconf->lcd_timing.vs_ve_addr);
	}
}

#if 0
/* change clock(frame_rate) for different vmode */
int lcd_vmode_change(struct lcd_config_s *pconf)
{
	unsigned int pclk = pconf->lcd_timing.lcd_clk;
	unsigned int h_period = pconf->lcd_basic.h_period;
	unsigned int v_period = pconf->lcd_basic.v_period;
	unsigned char type = pconf->lcd_timing.fr_adjust_type;
	unsigned int sync_duration_num = pconf->lcd_timing.sync_duration_num;
	unsigned int sync_duration_den = pconf->lcd_timing.sync_duration_den;

	/* frame rate adjust */
	switch (type) {
	case 1: /* htotal adjust */
		h_period = ((pclk / v_period) * sync_duration_den * 10) / sync_duration_num;
		h_period = (h_period + 5) / 10; /* round off */
		if (pconf->lcd_basic.h_period != h_period) {
			LCDPR("vmode_change: adjust h_period %u -> %u\n",
				pconf->lcd_basic.h_period, h_period);
			pconf->lcd_basic.h_period = h_period;
			/* check clk frac update */
			pclk = (h_period * v_period) / sync_duration_den * sync_duration_num;
			if (pconf->lcd_timing.lcd_clk != pclk)
				pconf->lcd_timing.lcd_clk = pclk;
		}
		break;
	case 2: /* vtotal adjust */
		v_period = ((pclk / h_period) * sync_duration_den * 10) / sync_duration_num;
		v_period = (v_period + 5) / 10; /* round off */
		if (pconf->lcd_basic.v_period != v_period) {
			LCDPR("vmode_change: adjust v_period %u -> %u\n",
				pconf->lcd_basic.v_period, v_period);
			pconf->lcd_basic.v_period = v_period;
			/* check clk frac update */
			pclk = (h_period * v_period) / sync_duration_den * sync_duration_num;
			if (pconf->lcd_timing.lcd_clk != pclk)
				pconf->lcd_timing.lcd_clk = pclk;
		}
		break;
	case 0: /* pixel clk adjust */
	default:
		pclk = (h_period * v_period * sync_duration_num) / sync_duration_den;
		if (pconf->lcd_timing.lcd_clk != pclk) {
			LCDPR("vmode_change: adjust pclk %u.%03uMHz -> %u.%03uMHz\n",
				(pconf->lcd_timing.lcd_clk / 1000000),
				((pconf->lcd_timing.lcd_clk / 1000) % 1000),
				(pclk / 1000000), ((pclk / 1000) % 1000));
			pconf->lcd_timing.lcd_clk = pclk;
		}
		break;
	}

	return 0;
}
#else
int lcd_vmode_change(struct lcd_config_s *pconf)
{
	unsigned char type = pconf->lcd_timing.fr_adjust_type;
	 /* use default value to avoid offset */
	unsigned int pclk = pconf->lcd_timing.lcd_clk_dft;
	unsigned int h_period = pconf->lcd_timing.h_period_dft;
	unsigned int v_period = pconf->lcd_timing.v_period_dft;
	unsigned int pclk_min = pconf->lcd_basic.lcd_clk_min;
	unsigned int pclk_max = pconf->lcd_basic.lcd_clk_max;
	unsigned int duration_num = pconf->lcd_timing.sync_duration_num;
	unsigned int duration_den = pconf->lcd_timing.sync_duration_den;
	char str[100];
	int len = 0;

	pconf->lcd_timing.clk_change = 0; /* clear clk flga */
	switch (type) {
	case 0: /* pixel clk adjust */
		pclk = (h_period * v_period) / duration_den * duration_num;
		if (pconf->lcd_timing.lcd_clk != pclk)
			pconf->lcd_timing.clk_change = LCD_CLK_PLL_CHANGE;
		break;
	case 1: /* htotal adjust */
		h_period = ((pclk / v_period) * duration_den * 10) /
				duration_num;
		h_period = (h_period + 5) / 10; /* round off */
		if (pconf->lcd_basic.h_period != h_period) {
			/* check clk frac update */
			pclk = (h_period * v_period) / duration_den *
				duration_num;
			if (pconf->lcd_timing.lcd_clk != pclk) {
				pconf->lcd_timing.clk_change =
					LCD_CLK_FRAC_UPDATE;
			}
		}
		break;
	case 2: /* vtotal adjust */
		v_period = ((pclk / h_period) * duration_den * 10) /
				duration_num;
		v_period = (v_period + 5) / 10; /* round off */
		if (pconf->lcd_basic.v_period != v_period) {
			/* check clk frac update */
			pclk = (h_period * v_period) / duration_den *
				duration_num;
			if (pconf->lcd_timing.lcd_clk != pclk) {
				pconf->lcd_timing.clk_change =
					LCD_CLK_FRAC_UPDATE;
			}
		}
		break;
	case 3: /* free adjust, use min/max range to calculate */
	default:
		v_period = ((pclk / h_period) * duration_den * 10) /
			duration_num;
		v_period = (v_period + 5) / 10; /* round off */
		if (v_period > pconf->lcd_basic.v_period_max) {
			v_period = pconf->lcd_basic.v_period_max;
			h_period = ((pclk / v_period) * duration_den * 10) /
				duration_num;
			h_period = (h_period + 5) / 10; /* round off */
			if (h_period > pconf->lcd_basic.h_period_max) {
				h_period = pconf->lcd_basic.h_period_max;
				pclk = (h_period * v_period) / duration_den *
					duration_num;
				if (pconf->lcd_timing.lcd_clk != pclk) {
					if (pclk > pclk_max) {
						pclk = pclk_max;
						LCDERR("invalid vmode\n");
						return -1;
					}
					pconf->lcd_timing.clk_change =
						LCD_CLK_PLL_CHANGE;
				}
			}
		} else if (v_period < pconf->lcd_basic.v_period_min) {
			v_period = pconf->lcd_basic.v_period_min;
			h_period = ((pclk / v_period) * duration_den * 10) /
				duration_num;
			h_period = (h_period + 5) / 10; /* round off */
			if (h_period < pconf->lcd_basic.h_period_min) {
				h_period = pconf->lcd_basic.h_period_min;
				pclk = (h_period * v_period) / duration_den *
					duration_num;
				if (pconf->lcd_timing.lcd_clk != pclk) {
					if (pclk < pclk_min) {
						pclk = pclk_min;
						LCDERR("invalid vmode\n");
						return -1;
					}
					pconf->lcd_timing.clk_change =
						LCD_CLK_PLL_CHANGE;
				}
			}
		}
		/* check clk frac update */
		if ((pconf->lcd_timing.clk_change & LCD_CLK_PLL_CHANGE) == 0) {
			pclk = (h_period * v_period) / duration_den *
				duration_num;
			if (pconf->lcd_timing.lcd_clk != pclk) {
				pconf->lcd_timing.clk_change =
					LCD_CLK_FRAC_UPDATE;
			}
		}
		break;
	}

	if (pconf->lcd_basic.v_period != v_period) {
		len += sprintf(str+len, "v_period %u->%u",
			pconf->lcd_basic.v_period, v_period);
		/* update v_period */
		pconf->lcd_basic.v_period = v_period;
	}
	if (pconf->lcd_basic.h_period != h_period) {
		if (len > 0)
			len += sprintf(str+len, ", ");
		len += sprintf(str+len, "h_period %u->%u",
			pconf->lcd_basic.h_period, h_period);
		/* update h_period */
		pconf->lcd_basic.h_period = h_period;
	}
	if (pconf->lcd_timing.lcd_clk != pclk) {
		if (len > 0)
			len += sprintf(str+len, ", ");
		len += sprintf(str+len, "pclk %u.%03uMHz->%u.%03uMHz",
			(pconf->lcd_timing.lcd_clk / 1000000),
			((pconf->lcd_timing.lcd_clk / 1000) % 1000),
			(pclk / 1000000), ((pclk / 1000) % 1000));
		pconf->lcd_timing.lcd_clk = pclk;
	}
	if (lcd_debug_print_flag) {
		if (len > 0)
			LCDPR("%s: %s\n", __func__, str);
	}

	return 0;
}
#endif

