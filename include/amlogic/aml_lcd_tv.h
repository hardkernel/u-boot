/*
 * AMLOGIC lcd controller driver.
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
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
 *
 */

#ifndef INL_AML_LCD_TV_H
#define INL_AML_LCD_TV_H

#include <common.h>
#include <linux/list.h>
#include <amlogic/aml_lcd.h>

//**********************************
//lcd driver version
//**********************************
#define LCD_DRV_TYPE      "tv"
#define LCD_DRV_DATE      "20151009"
//**********************************

#define Rsv_val 0xffffffff
struct ext_lcd_config_s {
	const char *panel_type;
	int lcd_type; // LCD_DIGITAL_TTL /LCD_DIGITAL_LVDS/LCD_DIGITAL_VBYONE
	unsigned char lcd_bits;

	unsigned short h_active;
	unsigned short v_active;
	unsigned short h_period;
	unsigned short v_period;
	unsigned short hsync_width;
	unsigned short hsync_bp;
	unsigned short vsync_width;
	unsigned short vsync_bp;

	unsigned int customer_val_0; //fr_adjust_type
	unsigned int customer_val_1; //clk_auto_generate
	unsigned int customer_val_2; //ss_level
	unsigned int customer_val_3;
	unsigned int customer_val_4;
	unsigned int customer_val_5;
	unsigned int customer_val_6;
	unsigned int customer_val_7;
	unsigned int customer_val_8;
	unsigned int customer_val_9;

	int lcd_spc_val0;
	int lcd_spc_val1;
	int lcd_spc_val2;
	int lcd_spc_val3;
	int lcd_spc_val4;
	int lcd_spc_val5;
	int lcd_spc_val6;
	int lcd_spc_val7;
	int lcd_spc_val8;
	int lcd_spc_val9;

	unsigned int power_gpio;
	unsigned short power_on_value;
	unsigned short power_off_value;
	unsigned short power_on_delay;
	unsigned short power_off_delay;

	int extern_index;
	int extern_on_delay;
	int extern_off_delay;

	unsigned int bl_gpio;
	unsigned short bl_on_value;
	unsigned short bl_off_value;
	unsigned short bl_on_delay;
	unsigned short bl_off_delay;

	unsigned pwm_port;
	unsigned pwm_freq;
	unsigned pwm_duty_max;
	unsigned pwm_duty_min;
	unsigned pwm_positive;

	unsigned level_default;
	unsigned level_min;
	unsigned level_max;

};

#define LCD_TYPE_MAX 	15

extern struct ext_lcd_config_s ext_lcd_config[LCD_TYPE_MAX];

#endif /* INL_AML_LCD_TV_H */
