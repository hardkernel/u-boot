/*
 * AMLOGIC LCD panel driver.
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

#include <common.h>
#include <amlogic/aml_lcd.h>
#ifdef CONFIG_AML_LOCAL_DIMMING
#include <amlogic/aml_ldim.h>
#endif

static char lcd_cpu_gpio[LCD_CPU_GPIO_NUM_MAX][LCD_CPU_GPIO_NAME_MAX] = {
	"GPIOAO_4",
	"invalid", /* ending flag */
};

static struct lcd_power_step_s lcd_power_on_step[] = {
	{LCD_POWER_TYPE_CPU,   0,1,20,}, /* panel vcc */
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},
	{LCD_POWER_TYPE_MAX,   0,0,0,},  /* ending flag */
};
static struct lcd_power_step_s lcd_power_off_step[] = {
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},
	{LCD_POWER_TYPE_CPU,   0,0,200,}, /* panel vcc */
	{LCD_POWER_TYPE_MAX,   0,0,0,},   /* ending flag */
};

static struct lcd_power_step_s lcd_power_on_step_p2p[] = {
	{LCD_POWER_TYPE_CPU,   0,1,20,}, /* panel vcc */
	{LCD_POWER_TYPE_EXTERN,0,0,100,}, /* init external voltage */
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},
	{LCD_POWER_TYPE_MAX,   0,0,0,},  /* ending flag */
};
static struct lcd_power_step_s lcd_power_off_step_p2p[] = {
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},
	{LCD_POWER_TYPE_CPU,   0,0,200,}, /* panel vcc */
	{LCD_POWER_TYPE_MAX,   0,0,0,},   /* ending flag */
};

static char lcd_bl_gpio[BL_GPIO_NUM_MAX][LCD_CPU_GPIO_NAME_MAX] = {
	"GPIOAO_11",
	"GPIOZ_5",
	"GPIOZ_6",
	"invalid", /* ending flag */
};

#ifdef CONFIG_AML_LOCAL_DIMMING
static char lcd_bl_ldim_gpio[BL_GPIO_NUM_MAX][LCD_CPU_GPIO_NAME_MAX] = {
	"GPIOH_10", /* LD_EN */
	"GPIOZ_5",  /* DIMMING_PWM */
	"GPIOZ_6",  /* LD_EN2 */
	"invalid",  /* ending flag */
};
#endif

struct ext_lcd_config_s ext_lcd_config[LCD_NUM_MAX] = {
	{/* normal*/
	"lvds_0",LCD_LVDS,8,
	/* basic timing */
	1920,1080,2200,1125,44,148,0,5,36,0,
	/* clk_attr */
	0,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* lvds_attr */
	1,1,0,0,0,0xf,0x0,Rsv_val,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_PWM,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/* for HDMI convert*/
	"lvds_1",LCD_LVDS,8,
	/* basic timing */
	1920,1080,2200,1125,44,148,0,5,36,0,
	/* clk_attr */
	1,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* lvds_attr */
	1,1,0,0,0,0xf,0x0,Rsv_val,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_MAX,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/*public 2-region vx1 : 3840x2160@60hz 8lane */
	"vbyone_0",LCD_VBYONE,10,
	/* basic timing */
	3840,2160,4400,2250,33,477,0,6,81,0,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* vbyone_attr */
	8,2,4,4,0xf,0x1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_PWM,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/*public 1-region vx1 : 3840x2160@60hz 8lane */
	"vbyone_1",LCD_VBYONE,10,
	/* basic timing */
	3840,2160,4400,2250,33,477,0,6,81,0,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* vbyone_attr */
	8,1,4,4,0xf,0x1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_PWM,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/*public p2p ceds : 3840x2160@60hz 12lane */
	"p2p_0",LCD_P2P,8,
	/* basic timing */
	3840,2160,5000,2250,16,29,0,6,81,0,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* p2p attr */
	0,12,0x76543210,0xba98,0,0,0xf,0x1,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step_p2p, lcd_power_off_step_p2p,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_MAX,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/*public p2p ceds : 3840x2160@60hz 6lane */
	"p2p_1",LCD_P2P,8,
	/* basic timing */
	3840,2160,5000,2250,16,29,0,6,81,0,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* p2p attr */
	0,6,0x76543210,0xba98,0,0,0xf,0x1,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step_p2p, lcd_power_off_step_p2p,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_MAX,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/*public p2p chpi : 3840x2160@60hz 6lane */
	"p2p_2",LCD_P2P,8,
	/* basic timing */
	3840,2160,4400,2250,16,29,0,6,81,0,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* p2p attr */
	10,6,0x76543210,0xba98,0,0,0xf,0x1,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step_p2p, lcd_power_off_step_p2p,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_MAX,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/*public p2p chpi : 3840x2160@60hz 12lane */
	"p2p_3",LCD_P2P,8,
	/* basic timing */
	3840,2160,4400,2250,16,29,0,6,81,0,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* p2p attr */
	10,12,0x76543210,0xba98,0,0,0xf,0x1,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step_p2p, lcd_power_off_step_p2p,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_MAX,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/* 1920*1080*/
	"mlvds_0",LCD_MLVDS,8,
	/* basic timing */
	1920,1080,2200,1125,44,148,0,5,36,0,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* minilvds_attr */
	6,0x12304567,0x0,0x110,0,0,0xf,0x0,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_MAX,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/* 1366*768*/
	"mlvds_1",LCD_MLVDS,8,
	/* basic timing */
	1366,768,1560,806,56,64,0,3,28,0,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* minilvds_attr */
	6,0x45603012,0x0,0xaa0,0,0,0xf,0x0,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	60,255,10,128,128,
	BL_CTRL_MAX,0,1,0,200,200,
	BL_PWM_POSITIVE,BL_PWM_C,180,100,25,1,0,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{.panel_type = "invalid"},
};

static struct lcd_pinmux_ctrl_s lcd_pinmux_ctrl[LCD_PINMX_MAX] = {
	{
		.name = "lcd_vbyone_pin", //GPIOH_15/16
		.pinmux_set = {{8, 0x30000000}, {9, 0x00000003}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{8, 0xf0000000}, {9, 0x0000000f}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "lcd_minilvds_pin", //GPIOH_0~15
		.pinmux_set = {{7, 0x11111111}, {8, 0x11111111}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{7, 0xffffffff}, {8, 0xffffffff}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "lcd_p2p_pin", //GPIOH_0~19
		.pinmux_set = {{7, 0x11111111}, {8, 0x11111111}, {9, 0x11111}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{7, 0xffffffff}, {8, 0xffffffff}, {9, 0xfffff}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "invalid",
	},
};

static struct lcd_pinmux_ctrl_s bl_pinmux_ctrl[BL_PINMUX_MAX] = {
	{
		.name = "bl_pwm_on_pin", //GPIOZ_5
		.pinmux_set = {{2, 0x00400000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{2, 0x00f00000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "bl_pwm_vs_on_pin", //GPIOZ_5
		.pinmux_set = {{2, 0x00300000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{2, 0x00f00000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "bl_pwm_combo_0_on_pin", //GPIOZ_5
		.pinmux_set = {{2, 0x00400000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{2, 0x00f00000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "bl_pwm_combo_1_on_pin", //GPIOZ_6
		.pinmux_set = {{2, 0x04000000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{2, 0x0f000000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "bl_pwm_combo_0_vs_on_pin", //GPIOZ_5
		.pinmux_set = {{2, 0x00300000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{2, 0x00f00000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "bl_pwm_combo_1_vs_on_pin", //GPIOZ_6
		.pinmux_set = {{2, 0x03000000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{2, 0x0f000000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "invalid",
	},
};

#ifdef CONFIG_AML_LOCAL_DIMMING
static struct ldim_pinmux_ctrl_s ldim_pinmux_ctrl[] = {
	{
		.name = "ldim_pwm_pin", //GPIOZ_5
		.pinmux_set = {{2, 0x00400000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{2, 0x00f00000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "ldim_pwm_vs_pin", //GPIOZ_5
		.pinmux_set = {{2, 0x00300000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{2, 0x00f00000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "invalid",
		.pinmux_set = {{LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{LCD_PINMUX_END, 0x0}},
	},
};
#endif

static struct vbyone_config_s lcd_vbyone_config = {
	.lane_count   = 8,
	.byte_mode    = 4,
	.region_num   = 2,
	.color_fmt    = 4,
};

static struct lvds_config_s lcd_lvds_config = {
	.lvds_repack  = 1, //0=JEDIA mode,  1=VESA mode
	.dual_port    = 1, //0=single port, 1=double port
	.pn_swap      = 0, //0=normal,      1=swap
	.port_swap    = 0, //0=normal,      1=swap
	.lane_reverse = 0, //0=normal,      1=swap
};

static struct mlvds_config_s lcd_mlvds_config = {
	.channel_num  = 6,
	.channel_sel0 = 0x45603012,
	.channel_sel1 = 0x0,
	.clk_phase = 0x0,
	.pn_swap  = 0, //0=normal, 1=swap
	.bit_swap = 0, //0=normal, 1=swap
};

static struct p2p_config_s lcd_p2p_config = {
	.p2p_type  = 0,
	.lane_num  = 12,
	.channel_sel0 = 0x76543210,
	.channel_sel1 = 0xba98,
	.pn_swap  = 0, //0=normal, 1=swap
	.bit_swap = 0, //0=normal, 1=swap
};

static struct lcd_power_ctrl_s lcd_power_ctrl = {
	.power_on_step = {
		{
			.type = LCD_POWER_TYPE_MAX, /* ending flag */
		},
	},
	.power_off_step = {
		{
			.type = LCD_POWER_TYPE_MAX, /* ending flag */
		},
	},
};

struct lcd_config_s lcd_config_dft = {
	.lcd_mode = LCD_MODE_TV,
	.lcd_key_valid = 0,
	.lcd_basic = {
		.model_name = "default",
		.lcd_type = LCD_TYPE_MAX,
		.lcd_bits = 8,
		.h_active = 1920,
		.v_active = 1080,
		.h_period = 2200,
		.v_period = 1125,

		.screen_width   = 16,
		.screen_height  = 9,
	},

	.lcd_timing = {
		.clk_auto = 1,
		.lcd_clk = 60,
		.ss_level = 0,
		.fr_adjust_type = 0,

		.hsync_width = 44,
		.hsync_bp    = 148,
		.hsync_pol   = 0,
		.vsync_width = 5,
		.vsync_bp    = 36,
		.vsync_pol   = 0,
	},

	.lcd_control = {
		.lvds_config   = &lcd_lvds_config,
		.vbyone_config = &lcd_vbyone_config,
		.mlvds_config = &lcd_mlvds_config,
		.p2p_config    = &lcd_p2p_config,
	},
	.lcd_power = &lcd_power_ctrl,

	.pinctrl_ver = 2,
	.lcd_pinmux = lcd_pinmux_ctrl,
	.pinmux_set = {{LCD_PINMUX_END, 0x0}},
	.pinmux_clr = {{LCD_PINMUX_END, 0x0}},
};

#ifdef CONFIG_AML_LCD_EXTERN
static char lcd_ext_gpio[LCD_EXTERN_GPIO_NUM_MAX][LCD_EXTERN_GPIO_LEN_MAX] = {
	"invalid", /* ending flag */
};

static unsigned char init_on_table[LCD_EXTERN_INIT_ON_MAX] = {
	0xc0, 2, 0x01, 0x2b,
	0xc0, 2, 0x02, 0x05,
	0xc0, 2, 0x03, 0x00,
	0xc0, 2, 0x04, 0x00,
	0xc0, 2, 0x05, 0x0c,
	0xc0, 2, 0x06, 0x04,
	0xc0, 2, 0x07, 0x21,
	0xc0, 2, 0x08, 0x0f,
	0xc0, 2, 0x09, 0x04,
	0xc0, 2, 0x0a, 0x00,
	0xc0, 2, 0x0b, 0x04,
	0xc0, 2, 0xff, 0x00,
	0xfd, 1, 100  /* delay 100ms */

	0xc1, 2, 0x01, 0xca,
	0xc1, 2, 0x02, 0x3b,
	0xc1, 2, 0x03, 0x33,
	0xc1, 2, 0x04, 0x05,
	0xc1, 2, 0x05, 0x2c,
	0xc1, 2, 0x06, 0xf2,
	0xc1, 2, 0x07, 0x9c,
	0xc1, 2, 0x08, 0x1b,
	0xc1, 2, 0x09, 0x82,
	0xc1, 2, 0x0a, 0x3d,
	0xc1, 2, 0x0b, 0x20,
	0xc1, 2, 0x0c, 0x11,
	0xc1, 2, 0x0d, 0xc4,
	0xc1, 2, 0x0e, 0x1a,
	0xc1, 2, 0x0f, 0x31,
	0xc1, 2, 0x10, 0x4c,
	0xc1, 2, 0x11, 0x12,
	0xc1, 2, 0x12, 0x90,
	0xc1, 2, 0x13, 0xf7,
	0xc1, 2, 0x14, 0x0c,
	0xc1, 2, 0x15, 0x20,
	0xc1, 2, 0x16, 0x13,
	0xff, 0, /* ending */
};

static unsigned char init_off_table[LCD_EXTERN_INIT_OFF_MAX] = {
	0xff, 0,  /* ending */
};

struct lcd_extern_common_s ext_common_dft = {
	.lcd_ext_key_valid = 0,
	.lcd_ext_num = 1,
	.pinmux_set = {{LCD_PINMUX_END, 0x0}},
	.pinmux_clr = {{LCD_PINMUX_END, 0x0}},
};
struct lcd_extern_config_s ext_config_dtf[LCD_EXTERN_NUM_MAX] = {
	{
		.index = 0,
		.name = "i2c_ANX6862_7911",
		.type = LCD_EXTERN_I2C, /* LCD_EXTERN_I2C, LCD_EXTERN_SPI, LCD_EXTERN_MAX */
		.status = 1, /* 0=disable, 1=enable */
		.i2c_addr = 0x20, /* 7bit i2c address */
		.i2c_addr2 = 0x74, /* 7bit i2c address, 0xff for none */
		.i2c_bus = LCD_EXTERN_I2C_BUS_1, /* LCD_EXTERN_I2C_BUS_0/1/2/3/4 */
		.cmd_size = 0xff,
		.table_init_on = init_on_table,
		.table_init_off = init_off_table,
	},
	{
		.index = LCD_EXTERN_INDEX_INVALID,
	},
};
#endif

struct bl_config_s bl_config_dft = {
	.name = "default",
	.bl_key_valid = 0,

	.level_default = 100,
	.level_min = 10,
	.level_max = 255,
	.level_mid = 128,
	.level_mid_mapping = 128,
	.level = 0,

	.method = BL_CTRL_MAX,
	.power_on_delay = 200,
	.power_off_delay = 200,

	.en_gpio = 0xff,
	.en_gpio_on = 1,
	.en_gpio_off = 0,

	.bl_pwm = NULL,
	.bl_pwm_combo0 = NULL,
	.bl_pwm_combo1 = NULL,
	.pwm_on_delay = 10,
	.pwm_off_delay = 10,

	.bl_extern_index = 0xff,

	.pinctrl_ver = 2,
	.bl_pinmux = bl_pinmux_ctrl,
	.pinmux_set = {{LCD_PINMUX_END, 0x0}},
	.pinmux_clr = {{LCD_PINMUX_END, 0x0}},
};

#ifdef CONFIG_AML_LOCAL_DIMMING
static unsigned char ldim_init_on[LDIM_INIT_ON_MAX];
static unsigned char ldim_init_off[LDIM_INIT_OFF_MAX];
struct ldim_dev_config_s ldim_config_dft = {
	.type = LDIM_DEV_TYPE_NORMAL,
	.cs_hold_delay = 0,
	.cs_clk_delay = 0,
	.en_gpio = 0xff,
	.en_gpio_on = 1,
	.en_gpio_off = 0,
	.lamp_err_gpio = 0xff,
	.fault_check = 0,
	.write_check = 0,
	.dim_min = 0x7f, /* min 3% duty */
	.dim_max = 0xfff,
	.init_loaded = 0,
	.cmd_size = 0xff,
	.init_on = ldim_init_on,
	.init_off = ldim_init_off,
	.init_on_cnt = sizeof(ldim_init_on),
	.init_off_cnt = sizeof(ldim_init_off),
	.pwm_config = {
		.index = 0,
		.pwm_method = BL_PWM_POSITIVE,
		.pwm_port = BL_PWM_MAX,
		.pwm_duty_max = 100,
		.pwm_duty_min = 20,
	},
	.pinctrl_ver = 1,
	.ldim_pinmux = ldim_pinmux_ctrl,
};
#endif

void lcd_config_bsp_init(void)
{
	int i, j;

	for (i = 0; i < LCD_CPU_GPIO_NUM_MAX; i++) {
		if (strcmp(lcd_cpu_gpio[i], "invalid") == 0)
			break;
		strcpy(lcd_power_ctrl.cpu_gpio[i], lcd_cpu_gpio[i]);
	}
	for (j = i; j < LCD_CPU_GPIO_NUM_MAX; j++)
		strcpy(lcd_power_ctrl.cpu_gpio[j], "invalid");
	for (i = 0; i < BL_GPIO_NUM_MAX; i++) {
		if (strcmp(lcd_bl_gpio[i], "invalid") == 0)
			break;
		strcpy(bl_config_dft.gpio_name[i], lcd_bl_gpio[i]);
	}
	for (j = i; j < BL_GPIO_NUM_MAX; j++)
		strcpy(bl_config_dft.gpio_name[j], "invalid");

#ifdef CONFIG_AML_LCD_EXTERN
	for (i = 0; i < LCD_EXTERN_NUM_MAX; i++) {
		if (ext_config_dtf[i].index == LCD_EXTERN_INDEX_INVALID)
			break;
	}
	ext_common_dft.lcd_ext_num = i;

	for (i = 0; i < LCD_EXTERN_GPIO_NUM_MAX; i++) {
		if (strcmp(lcd_ext_gpio[i], "invalid") == 0)
			break;
		strcpy(ext_common_dft.gpio_name[i], lcd_ext_gpio[i]);
	}
	for (j = i; j < LCD_EXTERN_GPIO_NUM_MAX; j++)
		strcpy(ext_common_dft.gpio_name[j], "invalid");

#endif
#ifdef CONFIG_AML_LOCAL_DIMMING
	strcpy(ldim_config_dft.name, "invalid");
	strcpy(ldim_config_dft.pinmux_name, "invalid");
	for (i = 0; i < BL_GPIO_NUM_MAX; i++) {
		if (strcmp(lcd_bl_ldim_gpio[i], "invalid") == 0)
			break;
		strcpy(ldim_config_dft.gpio_name[i], lcd_bl_ldim_gpio[i]);
	}
	for (j = i; j < BL_GPIO_NUM_MAX; j++)
		strcpy(ldim_config_dft.gpio_name[j], "invalid");
#endif
}
