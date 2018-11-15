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
	{"minilvds", LCD_MLVDS},
	{"p2p", LCD_P2P},
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

void lcd_pinmux_set(int status)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_config_s *pconf;
	int i;

	if (lcd_debug_print_flag)
		LCDPR("%s: %d\n", __func__, status);

	pconf = lcd_drv->lcd_config;
	if (status) {
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (pconf->pinmux_clr[i][0] == LCD_PINMUX_END)
				break;
			if (lcd_debug_print_flag) {
				LCDPR("pinmux_clr: %d, 0x%08x\n",
					pconf->pinmux_clr[i][0],
					pconf->pinmux_clr[i][1]);
			}
			lcd_pinmux_clr_mask(pconf->pinmux_clr[i][0],
				pconf->pinmux_clr[i][1]);
			i++;
		}
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (pconf->pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			if (lcd_debug_print_flag) {
				LCDPR("pinmux_set: %d, 0x%08x\n",
					pconf->pinmux_set[i][0],
					pconf->pinmux_set[i][1]);
			}
			lcd_pinmux_set_mask(pconf->pinmux_set[i][0],
				pconf->pinmux_set[i][1]);
			i++;
		}
	} else {
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (pconf->pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			if (lcd_debug_print_flag) {
				LCDPR("pinmux_clr: %d, 0x%08x\n",
					pconf->pinmux_set[i][0],
					pconf->pinmux_set[i][1]);
			}
			lcd_pinmux_clr_mask(pconf->pinmux_set[i][0],
				pconf->pinmux_set[i][1]);
			i++;
		}
	}
}

int lcd_power_load_from_dts(struct lcd_config_s *pconf, char *dt_addr, int child_offset)
{
	char *propdata;
	unsigned int i, j, temp;

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

	return 0;
}

int lcd_power_load_from_unifykey(struct lcd_config_s *pconf,
		unsigned char *buf, int key_len, int len)
{
	int i, j;
	unsigned char *p;
	int ret = 0;

	/* power: (5byte * n) */
	p = buf + len;
	if (lcd_debug_print_flag)
		LCDPR("power_on step:\n");
	i = 0;
	while (i < LCD_PWR_STEP_MAX) {
		len += 5;
		ret = aml_lcd_unifykey_len_check(key_len, len);
		if (ret) {
			pconf->lcd_power->power_on_step[i].type = 0xff;
			pconf->lcd_power->power_on_step[i].index = 0;
			pconf->lcd_power->power_on_step[i].value = 0;
			pconf->lcd_power->power_on_step[i].delay = 0;
			LCDERR("unifykey power_on length is incorrect\n");
			return -1;
		}
		pconf->lcd_power->power_on_step[i].type = *(p + LCD_UKEY_PWR_TYPE + 5*i);
		pconf->lcd_power->power_on_step[i].index = *(p + LCD_UKEY_PWR_INDEX + 5*i);
		pconf->lcd_power->power_on_step[i].value = *(p + LCD_UKEY_PWR_VAL + 5*i);
		pconf->lcd_power->power_on_step[i].delay =
			(*(p + LCD_UKEY_PWR_DELAY + 5*i) |
			((*(p + LCD_UKEY_PWR_DELAY + 5*i + 1)) << 8));

		if (lcd_debug_print_flag) {
			LCDPR("step %d: type=%d, index=%d, value=%d, delay=%d\n",
				i, pconf->lcd_power->power_on_step[i].type,
				pconf->lcd_power->power_on_step[i].index,
				pconf->lcd_power->power_on_step[i].value,
				pconf->lcd_power->power_on_step[i].delay);
		}
		if (pconf->lcd_power->power_on_step[i].type >= LCD_POWER_TYPE_MAX)
			break;

		i++;
	}

	if (lcd_debug_print_flag)
		LCDPR("power_off step:\n");
	p += (5*(i + 1));
	j = 0;
	while (j < LCD_PWR_STEP_MAX) {
		len += 5;
		ret = aml_lcd_unifykey_len_check(key_len, len);
		if (ret) {
			pconf->lcd_power->power_off_step[j].type = 0xff;
			pconf->lcd_power->power_off_step[j].index = 0;
			pconf->lcd_power->power_off_step[j].value = 0;
			pconf->lcd_power->power_off_step[j].delay = 0;
			LCDERR("unifykey power_off length is incorrect\n");
			return -1;
		}
		pconf->lcd_power->power_off_step[j].type = *(p + LCD_UKEY_PWR_TYPE + 5*j);
		pconf->lcd_power->power_off_step[j].index = *(p + LCD_UKEY_PWR_INDEX + 5*j);
		pconf->lcd_power->power_off_step[j].value = *(p + LCD_UKEY_PWR_VAL + 5*j);
		pconf->lcd_power->power_off_step[j].delay =
				(*(p + LCD_UKEY_PWR_DELAY + 5*j) |
				((*(p + LCD_UKEY_PWR_DELAY + 5*j + 1)) << 8));

		if (lcd_debug_print_flag) {
			LCDPR("step %d: type=%d, index=%d, value=%d, delay=%d\n",
				j, pconf->lcd_power->power_off_step[j].type,
				pconf->lcd_power->power_off_step[j].index,
				pconf->lcd_power->power_off_step[j].value,
				pconf->lcd_power->power_off_step[j].delay);
		}
		if (pconf->lcd_power->power_off_step[j].type >= LCD_POWER_TYPE_MAX)
			break;

		j++;
	}

	return ret;
}

static const char *lcd_ttl_pinmux_str[] = {
	"lcd_ttl_rgb_6bit_on",      /* 0 */
	"lcd_ttl_rgb_8bit_on",      /* 1 */
	"lcd_ttl_de_on_pin",        /* 2 */
	"lcd_ttl_hvsync_on_pin",    /* 3 */
	"lcd_ttl_de_hvsync_on_pin", /* 4 */
};

#ifdef CONFIG_OF_LIBFDT
static int lcd_pinmux_load_from_dts(char *dt_addr, struct lcd_config_s *pconf)
{
	int parent_offset;
	char propname[50];
	char *propdata;
	unsigned int i, j, temp;
	int pinmux_index = 0, pinmux_set_cnt = 0, pinmux_clr_cnt = 0;
	int len;

	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_TTL:
		/* data */
		if (pconf->lcd_basic.lcd_bits == 6)
			pinmux_index = 0;
		else
			pinmux_index = 1;
		sprintf(propname, "/pinmux/%s", lcd_ttl_pinmux_str[pinmux_index]);
		parent_offset = fdt_path_offset(dt_addr, propname);
		if (parent_offset < 0) {
			LCDERR("not find %s node\n", propname);
			pconf->pinmux_set[0][0] = LCD_PINMUX_END;
			pconf->pinmux_set[0][1] = 0x0;
			pconf->pinmux_clr[0][0] = LCD_PINMUX_END;
			pconf->pinmux_clr[0][1] = 0x0;
			return -1;
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
			if (propdata == NULL) {
				LCDERR("failed to get amlogic,setmask\n");
				pconf->pinmux_set[0][0] = LCD_PINMUX_END;
				pconf->pinmux_set[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					pconf->pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					pconf->pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					pconf->pinmux_set[temp][0] = LCD_PINMUX_END;
					pconf->pinmux_set[temp][1] = 0x0;
				}
				pinmux_set_cnt = temp;
			}
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
			if (propdata == NULL) {
				LCDERR("failed to get amlogic,clrmask\n");
				pconf->pinmux_clr[0][0] = LCD_PINMUX_END;
				pconf->pinmux_clr[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					pconf->pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					pconf->pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					pconf->pinmux_clr[temp][0] = LCD_PINMUX_END;
					pconf->pinmux_clr[temp][1] = 0x0;
				}
				pinmux_clr_cnt = temp;
			}
		}
		/* sync */
		switch (pconf->lcd_control.ttl_config->sync_valid) {
		case 0x1: /* hvsync */
			pinmux_index = 3;
			break;
		case 0x2: /* de */
			pinmux_index = 2;
			break;
		case 0x3: /* de + hvsync */
		default:
			pinmux_index = 4;
			break;
		}
		sprintf(propname, "/pinmux/%s", lcd_ttl_pinmux_str[pinmux_index]);
		parent_offset = fdt_path_offset(dt_addr, propname);
		if (parent_offset < 0) {
			return -1;
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
			if (propdata == NULL) {
				LCDERR("failed to get amlogic,setmask\n");
			} else {
				temp = len / 8;
				j = pinmux_set_cnt + temp;
				if (j < LCD_PINMUX_NUM) {
					for (i = 0; i < temp; i++) {
						pconf->pinmux_set[i+pinmux_set_cnt][0] = be32_to_cpup((((u32*)propdata)+2*i));
						pconf->pinmux_set[i+pinmux_set_cnt][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
						}
					if (j < (LCD_PINMUX_NUM - 1)) {
						pconf->pinmux_set[j][0] = LCD_PINMUX_END;
						pconf->pinmux_set[j][1] = 0x0;
					}
				} else {
					LCDERR("pinmux_set cnt is out of support\n");
				}
			}
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
			if (propdata == NULL) {
				LCDERR("failed to get amlogic,clrmask\n");
			} else {
				temp = len / 8;
				j = pinmux_clr_cnt + temp;
				if (j < LCD_PINMUX_NUM) {
					for (i = 0; i < temp; i++) {
						pconf->pinmux_clr[i+pinmux_clr_cnt][0] = be32_to_cpup((((u32*)propdata)+2*i));
						pconf->pinmux_clr[i+pinmux_clr_cnt][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
						}
					if (j < (LCD_PINMUX_NUM - 1)) {
						pconf->pinmux_clr[j][0] = LCD_PINMUX_END;
						pconf->pinmux_clr[j][1] = 0x0;
					}
				} else {
					LCDERR("pinmux_clr cnt is out of support\n");
				}
			}
		}
		break;
	case LCD_LVDS:
		pconf->pinmux_set[0][0] = LCD_PINMUX_END;
		pconf->pinmux_set[0][1] = 0x0;
		pconf->pinmux_clr[0][0] = LCD_PINMUX_END;
		pconf->pinmux_clr[0][1] = 0x0;
		break;
	case LCD_VBYONE:
		sprintf(propname, "/pinmux/lcd_vbyone_pin");
		parent_offset = fdt_path_offset(dt_addr, propname);
		if (parent_offset < 0) {
			LCDERR("not find %s node\n", propname);
			pconf->pinmux_set[0][0] = LCD_PINMUX_END;
			pconf->pinmux_set[0][1] = 0x0;
			pconf->pinmux_clr[0][0] = LCD_PINMUX_END;
			pconf->pinmux_clr[0][1] = 0x0;
			return -1;
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
			if (propdata == NULL) {
				LCDERR("failed to get amlogic,setmask\n");
				pconf->pinmux_set[0][0] = LCD_PINMUX_END;
				pconf->pinmux_set[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					pconf->pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					pconf->pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					pconf->pinmux_set[temp][0] = LCD_PINMUX_END;
					pconf->pinmux_set[temp][1] = 0x0;
				}
			}
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
			if (propdata == NULL) {
				LCDERR("failed to get amlogic,clrmask\n");
				pconf->pinmux_clr[0][0] = LCD_PINMUX_END;
				pconf->pinmux_clr[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					pconf->pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					pconf->pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					pconf->pinmux_clr[temp][0] = LCD_PINMUX_END;
					pconf->pinmux_clr[temp][1] = 0x0;
				}
			}
		}
		break;
	case LCD_MIPI:
		pconf->pinmux_set[0][0] = LCD_PINMUX_END;
		pconf->pinmux_set[0][1] = 0x0;
		pconf->pinmux_clr[0][0] = LCD_PINMUX_END;
		pconf->pinmux_clr[0][1] = 0x0;
		break;
	default:
		LCDERR("%s: invalid lcd type\n", __func__);
		break;
	}

	return 0;
}
#endif

static int lcd_pinmux_load_from_bsp(struct lcd_config_s *pconf)
{
	char propname[50];
	struct lcd_pinmux_ctrl_s *pinmux;
	unsigned int i, j;
	int pinmux_index = 0, set_cnt = 0, clr_cnt = 0;

	if (lcd_debug_print_flag)
		LCDPR("%s\n", __func__);

	if (pconf->lcd_pinmux == NULL) {
		LCDERR("%s: lcd_pinmux is NULL for lcd.c\n", __func__);
		return -1;
	}

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_TTL:
		/* data */
		if (pconf->lcd_basic.lcd_bits == 6)
			pinmux_index = 0;
		else
			pinmux_index = 1;
		sprintf(propname, "%s", lcd_ttl_pinmux_str[pinmux_index]);
		pinmux = pconf->lcd_pinmux;
		for (i = 0; i < LCD_PINMX_MAX; i++) {
			pinmux += i;
			if (strncmp(pinmux->name, "invalid", 7) == 0)
				break;
			if (strncmp(pinmux->name, propname, strlen(propname)) == 0) {
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_set[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_set[j][0] = pinmux->pinmux_set[j][0];
					pconf->pinmux_set[j][1] = pinmux->pinmux_set[j][1];
					set_cnt++;
				}
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_clr[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_clr[j][0] = pinmux->pinmux_clr[j][0];
					pconf->pinmux_clr[j][1] = pinmux->pinmux_clr[j][1];
					clr_cnt++;
				}
				break;
			}
		}

		/* sync */
		switch (pconf->lcd_control.ttl_config->sync_valid) {
		case 0x1: /* hvsync */
			pinmux_index = 3;
			break;
		case 0x2: /* de */
			pinmux_index = 2;
			break;
		case 0x3: /* de + hvsync */
		default:
			pinmux_index = 4;
			break;
		}
		sprintf(propname, "%s", lcd_ttl_pinmux_str[pinmux_index]);
		pinmux = pconf->lcd_pinmux;
		for (i = 0; i < LCD_PINMX_MAX; i++) {
			pinmux += i;
			if (strncmp(pinmux->name, "invalid", 7) == 0)
				break;
			if (strncmp(pinmux->name, propname, strlen(propname)) == 0) {
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_set[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_set[j+set_cnt][0] = pinmux->pinmux_set[j][0];
					pconf->pinmux_set[j+set_cnt][1] = pinmux->pinmux_set[j][1];
					set_cnt++;
				}
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_clr[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_clr[j+clr_cnt][0] = pinmux->pinmux_clr[j][0];
					pconf->pinmux_clr[j+clr_cnt][1] = pinmux->pinmux_clr[j][1];
					clr_cnt++;
				}
				break;
			}
		}

		if (set_cnt < LCD_PINMUX_NUM) {
			pconf->pinmux_set[set_cnt][0] = LCD_PINMUX_END;
			pconf->pinmux_set[set_cnt][1] = 0x0;
		}
		if (clr_cnt < LCD_PINMUX_NUM) {
			pconf->pinmux_clr[clr_cnt][0] = LCD_PINMUX_END;
			pconf->pinmux_clr[clr_cnt][1] = 0x0;
		}
		break;
	case LCD_LVDS:
		pconf->pinmux_set[0][0] = LCD_PINMUX_END;
		pconf->pinmux_set[0][1] = 0x0;
		pconf->pinmux_clr[0][0] = LCD_PINMUX_END;
		pconf->pinmux_clr[0][1] = 0x0;
		break;
	case LCD_MLVDS:
		sprintf(propname, "lcd_minilvds_pin");
		pinmux = pconf->lcd_pinmux;
		for (i = 0; i < LCD_PINMX_MAX; i++) {
			pinmux += i;
			if (strncmp(pinmux->name, "invalid", 7) == 0)
				break;
			if (strncmp(pinmux->name, propname, strlen(propname)) == 0) {
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_set[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_set[j][0] = pinmux->pinmux_set[j][0];
					pconf->pinmux_set[j][1] = pinmux->pinmux_set[j][1];
					set_cnt++;
				}
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_clr[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_clr[j][0] = pinmux->pinmux_clr[j][0];
					pconf->pinmux_clr[j][1] = pinmux->pinmux_clr[j][1];
					clr_cnt++;
				}
				break;
			}
		}
		if (set_cnt < LCD_PINMUX_NUM) {
			pconf->pinmux_set[set_cnt][0] = LCD_PINMUX_END;
			pconf->pinmux_set[set_cnt][1] = 0x0;
		}
		if (clr_cnt < LCD_PINMUX_NUM) {
			pconf->pinmux_clr[clr_cnt][0] = LCD_PINMUX_END;
			pconf->pinmux_clr[clr_cnt][1] = 0x0;
		}
		break;
	case LCD_VBYONE:
		sprintf(propname, "lcd_vbyone_pin");
		pinmux = pconf->lcd_pinmux;
		for (i = 0; i < LCD_PINMX_MAX; i++) {
			pinmux += i;
			if (strncmp(pinmux->name, "invalid", 7) == 0)
				break;
			if (strncmp(pinmux->name, propname, strlen(propname)) == 0) {
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_set[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_set[j][0] = pinmux->pinmux_set[j][0];
					pconf->pinmux_set[j][1] = pinmux->pinmux_set[j][1];
					set_cnt++;
				}
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_clr[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_clr[j][0] = pinmux->pinmux_clr[j][0];
					pconf->pinmux_clr[j][1] = pinmux->pinmux_clr[j][1];
					clr_cnt++;
				}
				break;
			}
		}
		if (set_cnt < LCD_PINMUX_NUM) {
			pconf->pinmux_set[set_cnt][0] = LCD_PINMUX_END;
			pconf->pinmux_set[set_cnt][1] = 0x0;
		}
		if (clr_cnt < LCD_PINMUX_NUM) {
			pconf->pinmux_clr[clr_cnt][0] = LCD_PINMUX_END;
			pconf->pinmux_clr[clr_cnt][1] = 0x0;
		}
		break;
	case LCD_P2P:
		sprintf(propname, "lcd_p2p_pin");
		pinmux = pconf->lcd_pinmux;
		for (i = 0; i < LCD_PINMX_MAX; i++) {
			pinmux += i;
			if (strncmp(pinmux->name, "invalid", 7) == 0)
				break;
			if (strncmp(pinmux->name, propname, strlen(propname)) == 0) {
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_set[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_set[j][0] = pinmux->pinmux_set[j][0];
					pconf->pinmux_set[j][1] = pinmux->pinmux_set[j][1];
					set_cnt++;
				}
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_clr[j][0] == LCD_PINMUX_END)
						break;
					pconf->pinmux_clr[j][0] = pinmux->pinmux_clr[j][0];
					pconf->pinmux_clr[j][1] = pinmux->pinmux_clr[j][1];
					clr_cnt++;
				}
				break;
			}
		}
		if (set_cnt < LCD_PINMUX_NUM) {
			pconf->pinmux_set[set_cnt][0] = LCD_PINMUX_END;
			pconf->pinmux_set[set_cnt][1] = 0x0;
		}
		if (clr_cnt < LCD_PINMUX_NUM) {
			pconf->pinmux_clr[clr_cnt][0] = LCD_PINMUX_END;
			pconf->pinmux_clr[clr_cnt][1] = 0x0;
		}
		break;
	case LCD_MIPI:
		pconf->pinmux_set[0][0] = LCD_PINMUX_END;
		pconf->pinmux_set[0][1] = 0x0;
		pconf->pinmux_clr[0][0] = LCD_PINMUX_END;
		pconf->pinmux_clr[0][1] = 0x0;
		break;
	default:
		LCDERR("%s: invalid lcd type\n", __func__);
		break;
	}

	return 0;
}

int lcd_pinmux_load_config(char *dt_addr, struct lcd_config_s *pconf)
{
	int ret = 0;
	int i;

	switch (pconf->pinctrl_ver) {
	case 0:
#ifdef CONFIG_OF_LIBFDT
		ret = lcd_pinmux_load_from_dts(dt_addr, pconf);
#endif
		break;
	case 2:
		ret = lcd_pinmux_load_from_bsp(pconf);
		break;
	case 1: /* pinmux use default */
	default:
		break;
	}

	if (lcd_debug_print_flag) {
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (pconf->pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			LCDPR("pinmux_set: %d, 0x%08x\n",
				pconf->pinmux_set[i][0], pconf->pinmux_set[i][1]);
			i++;
		}
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (pconf->pinmux_clr[i][0] == LCD_PINMUX_END)
				break;
			LCDPR("pinmux_clr: %d, 0x%08x\n",
				pconf->pinmux_clr[i][0], pconf->pinmux_clr[i][1]);
			i++;
		}
	}

	return ret;
}

void lcd_timing_init_config(struct lcd_config_s *pconf)
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

	pconf->lcd_timing.clk_change = 0; /* clear clk flag */
	switch (type) {
	case 0: /* pixel clk adjust */
		pclk = (h_period * v_period) / duration_den * duration_num;
		if (pconf->lcd_timing.lcd_clk != pclk)
			pconf->lcd_timing.clk_change = LCD_CLK_PLL_CHANGE;
		break;
	case 1: /* htotal adjust */
		h_period = ((pclk / v_period) * duration_den * 100) /
				duration_num;
		h_period = (h_period + 99) / 100; /* round off */
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
		v_period = ((pclk / h_period) * duration_den * 100) /
				duration_num;
		v_period = (v_period + 99) / 100; /* round off */
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
		v_period = ((pclk / h_period) * duration_den * 100) /
			duration_num;
		v_period = (v_period + 99) / 100; /* round off */
		if (v_period > pconf->lcd_basic.v_period_max) {
			v_period = pconf->lcd_basic.v_period_max;
			h_period = ((pclk / v_period) * duration_den * 100) /
				duration_num;
			h_period = (h_period + 99) / 100; /* round off */
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
			h_period = ((pclk / v_period) * duration_den * 100) /
				duration_num;
			h_period = (h_period + 99) / 100; /* round off */
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
	case 4: /* hdmi mode */
		if ((duration_num / duration_den) == 59) {
			/* pixel clk adjust */
			pclk = (h_period * v_period) / duration_den * duration_num;
			if (pconf->lcd_timing.lcd_clk != pclk)
				pconf->lcd_timing.clk_change = LCD_CLK_PLL_CHANGE;
		} else {
			/* htotal adjust */
			h_period = ((pclk / v_period) * duration_den * 100) /
					duration_num;
			h_period = (h_period + 99) / 100; /* round off */
			if (pconf->lcd_basic.h_period != h_period) {
				/* check clk frac update */
				pclk = (h_period * v_period) / duration_den *
					duration_num;
				if (pconf->lcd_timing.lcd_clk != pclk) {
					pconf->lcd_timing.clk_change =
						LCD_CLK_FRAC_UPDATE;
				}
			}
		}
		break;
	default:
		LCDERR("%s: invalid fr_adjust_type: %d\n", __func__, type);
		return 0;
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

