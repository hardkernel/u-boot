/*
 * include/amlogic/aml_lcd.h
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

#ifndef INC_AML_LCD_H
#define INC_AML_LCD_H

#include <common.h>
#include <linux/list.h>
#include <amlogic/aml_lcd_vout.h>

#define Rsv_val 0xffffffff
struct ext_lcd_config_s {
	const char *panel_type;
	int lcd_type; // LCD_TTL /LCD_LVDS/LCD_VBYONE
	unsigned char lcd_bits;

	unsigned short h_active;
	unsigned short v_active;
	unsigned short h_period;
	unsigned short v_period;
	unsigned short hsync_width;
	unsigned short hsync_bp;
	unsigned short hsync_pol;
	unsigned short vsync_width;
	unsigned short vsync_bp;
	unsigned short vsync_pol;

	unsigned int customer_val_0; //fr_adjust_type
	unsigned int customer_val_1; //ss_level
	unsigned int customer_val_2; //clk_auto_generate
	unsigned int customer_val_3; //pixel clock(unit in Hz)
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

	struct lcd_power_step_s *power_on_step;
	struct lcd_power_step_s *power_off_step;

	/* backlight */
	unsigned int level_default;
	unsigned int level_max;
	unsigned int level_min;
	unsigned int level_mid;
	unsigned int level_mid_mapping;

	unsigned int bl_method;
	unsigned int bl_en_gpio;
	unsigned short bl_en_gpio_on;
	unsigned short bl_en_gpio_off;
	unsigned short bl_power_on_delay;
	unsigned short bl_power_off_delay;

	unsigned int pwm_method;
	unsigned int pwm_port;
	unsigned int pwm_freq;
	unsigned int pwm_duty_max;
	unsigned int pwm_duty_min;
	unsigned int pwm_gpio;
	unsigned int pwm_gpio_off;

	unsigned int pwm2_method;
	unsigned int pwm2_port;
	unsigned int pwm2_freq;
	unsigned int pwm2_duty_max;
	unsigned int pwm2_duty_min;
	unsigned int pwm2_gpio;
	unsigned int pwm2_gpio_off;

	unsigned int pwm_level_max;
	unsigned int pwm_level_min;
	unsigned int pwm2_level_max;
	unsigned int pwm2_level_min;

	unsigned int pwm_on_delay;
	unsigned int pwm_off_delay;

	/* backlight extern */
	unsigned int bl_ext_index;
};

#define LCD_NUM_MAX         10

extern struct ext_lcd_config_s ext_lcd_config[LCD_NUM_MAX];

#endif /* INC_AML_LCD_H */
