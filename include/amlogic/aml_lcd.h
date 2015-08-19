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

#ifndef INC_AML_LCD_H
#define INC_AML_LCD_H

#include <common.h>
#include <linux/list.h>
#ifdef CONFIG_AML_LCD_EXTERN
#include <amlogic/aml_lcd_extern.h>
#endif

enum lcd_type_e {
	LCD_LVDS = 0,
	LCD_VBYONE,
	LCD_TTL,
	LCD_TYPE_MAX,
};

struct lcd_basic_s {
	char model_name[30];
	enum lcd_type_e lcd_type;
	unsigned char lcd_bits;
	unsigned short h_active; /* Horizontal display area */
	unsigned short v_active; /* Vertical display area */
	unsigned short h_period; /* Horizontal total period time */
	unsigned short v_period; /* Vertical total period time */

	unsigned short screen_ratio_width;  /* screen aspect ratio width */
	unsigned short screen_ratio_height; /* screen aspect ratio height */
	unsigned short screen_actual_width;  /* screen physical width in "mm" unit */
	unsigned short screen_actual_height; /* screen physical height in "mm" unit */
};

struct lcd_timing_s {
	unsigned char clk_auto; /* clk parameters auto generation flag */
	unsigned int lcd_clk;   /* lcd clock = pixel clock*/
	unsigned int pll_ctrl;  /* video PLL settings */
	unsigned int div_ctrl;  /* video pll div settings */
	unsigned int clk_ctrl;
	unsigned char frame_rate_adj_type; /* 0=htotal adjust, 1=clock adjust */
	unsigned char ss_level;

	unsigned short video_on_pixel;
	unsigned short video_on_line;

	unsigned short sync_duration_num;
	unsigned short sync_duration_den;

	unsigned short hsync_width;
	unsigned short hsync_bp;
	unsigned short vsync_width;
	unsigned short vsync_bp;

	unsigned short hs_hs_addr;
	unsigned short hs_he_addr;
	unsigned short hs_vs_addr;
	unsigned short hs_ve_addr;

	unsigned short vs_hs_addr;
	unsigned short vs_he_addr;
	unsigned short vs_vs_addr;
	unsigned short vs_ve_addr;
};

struct lvds_config_s {
	unsigned int lvds_repack;
	unsigned int pn_swap;
	unsigned int dual_port;
	unsigned int port_swap;
	unsigned int port_sel;
};

struct vbyone_config_s {
	unsigned int lane_count;
	unsigned int byte_mode;
	unsigned int region_num;
	unsigned int color_fmt;
	unsigned int phy_div;
	unsigned int bit_rate;
};

struct ttl_config_s {
	unsigned char rb_swap;
	unsigned char bit_swap;
};

#ifdef CONFIG_AML_LCD_EXTERN
struct lcd_extern_config_s {
	unsigned int index;
	unsigned int on_delay;
	unsigned int off_delay;
};
#endif

struct lcd_ctrl_config_s {
	struct lvds_config_s *lvds_config;
	struct vbyone_config_s *vbyone_config;
	struct ttl_config_s *ttl_config;
#ifdef CONFIG_AML_LCD_EXTERN
	struct lcd_extern_config_s *ext_config;
#endif
};

struct lcd_power_ctrl_s {
	unsigned int gpio;
	unsigned short on_value;
	unsigned short off_value;
	unsigned short on_delay;
	unsigned short off_delay;
};

struct lcd_config_s {
	struct lcd_basic_s lcd_basic;
	struct lcd_timing_s lcd_timing;
	struct lcd_ctrl_config_s lcd_control;
	struct lcd_power_ctrl_s *lcd_power;
};

extern struct lcd_config_s lcd_config_dft;

/* ==============backlight control config================== */
enum bl_ctrl_method_e {
	BL_CTRL_GPIO,
	BL_CTRL_PWM,
	BL_CTRL_EXTERN,
	BL_CTRL_MAX,
};

enum bl_pwm_e {
	BL_PWM_A = 0,
	BL_PWM_B,
	BL_PWM_C,
	BL_PWM_D,
	BL_PWM_E,
	BL_PWM_F,
	BL_PWM_VS,
	BL_PWM_MAX,
};

#define XTAL_FREQ_HZ		(24*1000*1000) /* 24M in HZ */
#define XTAL_HALF_FREQ_HZ	(24*1000*500)  /* 24M/2 in HZ */

#define AML_BL_FREQ_DEF			1000 /* unit: HZ */
#define AML_BL_FREQ_VS_DEF		2    /* multiple 2 of vfreq */

struct bl_config_s {
	int level_default;
	int level_mid;
	int level_mid_mapping;
	int level_min;
	int level_max;

	enum bl_ctrl_method_e method;
	unsigned short power_on_delay;
	unsigned short power_off_delay;

	int gpio;
	unsigned short gpio_on;
	unsigned short gpio_off;

	enum bl_pwm_e pwm_port;
	unsigned int pwm_freq; /* pwm_vs: 1~4(vfreq multiple), other pwm: real freq(unit: Hz) */
	unsigned int pwm_duty_max; /* unit: % */
	unsigned int pwm_duty_min; /* unit: % */
	unsigned int pwm_cnt;
	unsigned int pre_div;
	unsigned int pwm_max;
	unsigned int pwm_min;
	unsigned short pwm_on_delay;
	unsigned short pwm_off_delay;

	unsigned pinmux_set_num;
	unsigned pinmux_set[10][2];
	unsigned pinmux_clr_num;
	unsigned pinmux_clr[10][2];
};

struct aml_lcd_drv_s {
	char version[15];
	struct lcd_config_s *lcd_config;
	struct bl_config_s *bl_config;
	void (*list_support_mode)(void);
	int (*lcd_probe)(void);
	void (*lcd_enable)(char *mode);
	void (*lcd_disable)(void);
	void (*lcd_test)(int num);
	void (*lcd_info)(void);
	void (*bl_on)(void);
	void (*bl_off)(void);
	void (*set_bl_level)(int level);
	int (*get_bl_level)(void);
};

extern struct aml_lcd_drv_s *get_aml_lcd_driver(void);

extern void lcd_list_support_mode(void);
extern int get_lcd_config(struct lcd_config_s *pconf, struct bl_config_s *bconf);
extern void init_lcd_driver(struct lcd_config_s *pconf, char *mode);
extern void disable_lcd_driver(void);

extern int lcd_probe(void);

#define LCDPR(fmt,args...) printf("lcd: "fmt"", ## args)
#define lcd_printf(fmt,args...) printf("lcd: "fmt"", ## args)

#endif /* INC_AML_LCD_H */
