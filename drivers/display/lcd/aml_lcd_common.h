/*
 * driver/display/lcd/aml_lcd_common.h
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

#ifndef _AML_LCD_COMMON_H
#define _AML_LCD_COMMON_H
#include <amlogic/aml_lcd.h>
#include "aml_lcd_clk_config.h"

#define VPP_OUT_SATURATE            (1 << 0)

extern void mdelay(unsigned long n);

/* lcd common */
extern int lcd_type_str_to_type(const char *str);
extern char *lcd_type_type_to_str(int type);
extern int lcd_mode_str_to_mode(const char *str);
extern char *lcd_mode_mode_to_str(int mode);
extern int lcd_backlight_get_pwm_port(char *str);
extern void vpp_set_matrix_ycbcr2rgb(int vd1_or_vd2_or_post, int mode);
extern void lcd_tcon_config(struct lcd_config_s *pconf);

/* lcd gpio */
extern int aml_lcd_gpio_name_map_num(const char *name);
extern int aml_lcd_gpio_set(int gpio, int value);
extern unsigned int aml_lcd_gpio_input_get(int gpio);

/* lcd driver */
extern int get_lcd_tv_config(char *dt_addr, int load_id);
extern int get_lcd_tablet_config(char *dt_addr, int load_id);

#endif

