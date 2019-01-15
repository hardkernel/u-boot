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
#include "aml_lcd_unifykey.h"

/* 20180718: mute: wait vsync for display shadow */
/* 20180928: tl1 support, optimize clk config */
/* 20181012: tl1 support tcon */
/* 20181212: tl1 update p2p config and pll setting */
/* 20181225: update phy config */
/* 20190108: tl1 support tablet mode */
/* 20190115: tl1 tcon all interface support */
/* 20190118: support tcon bin data management */
#define LCD_DRV_VERSION    "20190118"

#define VPP_OUT_SATURATE            (1 << 0)

extern void mdelay(unsigned long n);
extern unsigned int lcd_debug_test;

/* lcd common */
extern int lcd_type_str_to_type(const char *str);
extern char *lcd_type_type_to_str(int type);
extern int lcd_mode_str_to_mode(const char *str);
extern char *lcd_mode_mode_to_str(int mode);

extern void lcd_pinmux_set(int status);

extern int lcd_power_load_from_dts(struct lcd_config_s *pconf,
		char *dt_addr, int child_offset);
extern int lcd_power_load_from_unifykey(struct lcd_config_s *pconf,
		unsigned char *buf, int key_len, int len);
extern int lcd_pinmux_load_config(char *dt_addr, struct lcd_config_s *pconf);
extern void lcd_timing_init_config(struct lcd_config_s *pconf);
extern int lcd_vmode_change(struct lcd_config_s *pconf);

/* lcd phy */
extern void lcd_lvds_phy_set(struct lcd_config_s *pconf, int status);
extern void lcd_vbyone_phy_set(struct lcd_config_s *pconf, int status);
extern void lcd_mlvds_phy_set(struct lcd_config_s *pconf, int status);
extern void lcd_p2p_phy_set(struct lcd_config_s *pconf, int status);
extern void lcd_mipi_phy_set(struct lcd_config_s *pconf, int status);

/* lcd tcon */
extern void lcd_tcon_info_print(void);
extern int lcd_tcon_enable(struct lcd_config_s *pconf);
extern void lcd_tcon_disable(void);
extern int lcd_tcon_probe(char *dt_addr, struct aml_lcd_drv_s *lcd_drv, int load_id);

/* lcd gpio */
extern int aml_lcd_gpio_name_map_num(const char *name);
extern int aml_lcd_gpio_set(int gpio, int value);
extern unsigned int aml_lcd_gpio_input_get(int gpio);

/* lcd debug */
extern void aml_lcd_debug_test(unsigned int num);
extern void aml_lcd_mute_setting(unsigned char flag);
extern void aml_lcd_info_print(void);
extern void aml_lcd_reg_print(void);
extern void aml_lcd_debug_probe(struct aml_lcd_drv_s *lcd_drv);

/* lcd driver */
extern int get_lcd_tv_config(char *dt_addr, int load_id);
extern int get_lcd_tablet_config(char *dt_addr, int load_id);

extern void lcd_wait_vsync(void);

/* aml_bl driver */
extern void aml_bl_config_print(void);
extern void aml_bl_pwm_config_update(struct bl_config_s *bconf);
extern void aml_bl_set_level(unsigned int level);
extern unsigned int aml_bl_get_level(void);
extern void aml_bl_power_ctrl(int status, int delay_flag);
extern int aml_bl_config_load(char *dt_addr, int load_id);
#ifdef CONFIG_AML_LOCAL_DIMMING
extern int ldim_config_load_from_dts(char *dt_addr, int child_offset);
extern int ldim_config_load_from_unifykey(unsigned char *para);
extern int ldim_config_load(char *dt_addr);
#endif

#endif

