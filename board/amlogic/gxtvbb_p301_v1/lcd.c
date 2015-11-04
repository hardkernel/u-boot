/*
 * AMLOGIC TV LCD panel driver.
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
#include <amlogic/aml_lcd_tv.h>
#include <asm/arch/gpio.h>

//Rsv_val = 0xffffffff

static int lcd_cpu_gpio[LCD_CPU_GPIO_NUM_MAX] = {
	PIN_GPIOX_3,
	LCD_GPIO_MAX, /* ending flag */
};

static struct lcd_power_step_s lcd_power_on_step[] = {
	{LCD_POWER_TYPE_CPU,   0,1,50,},
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},
	{LCD_POWER_TYPE_MAX,   0,0,0,},
};
static struct lcd_power_step_s lcd_power_off_step[] = {
	{LCD_POWER_TYPE_SIGNAL,0,0,50,},
	{LCD_POWER_TYPE_CPU,   0,0,100,},
	{LCD_POWER_TYPE_MAX,   0,0,0,},
};

struct ext_lcd_config_s ext_lcd_config[LCD_NUM_MAX] = {
	{/* AOC: public Platform lvds : 1920x1080@60hz 8bit pixel clk@74.25mhz 2prot*/
	"lvds_0",LCD_LVDS,8,
	/* basic timing */
	1920,1080,2200,1125,44,148,5,36,
	/* clk_attr */
	0,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* lvds_attr */
	1,1,0,0,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	Rsv_val,Rsv_val,1,0,50,50,
	Rsv_val,Rsv_val,180,100,25,
	60,10,255},

	{/*BOE: HV550QU2-305 vx1 : 3840x2160@60hz 8lane */
	"vbyone_0",LCD_VBYONE,10,
	/* basic timing */
	3840,2160,4400,2250,33,477,6,81,
	/* clk_attr */
	0,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* vbyone_attr */
	8,2,4,4,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	Rsv_val,Rsv_val,1,0,50,50,
	Rsv_val,Rsv_val,180,100,25,
	60,10,255},

	{/*LG: RDL550WY: 3840x2160@60hz 8lane */
	"vbyone_1",LCD_VBYONE,10,
	/* basic timing */
	3840,2160,4400,2250,33,477,6,81,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* vbyone_attr */
	8,2,4,4,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	Rsv_val,Rsv_val,1,0,50,50,
	Rsv_val,Rsv_val,180,100,25,
	60,10,255},

	{/*INL: V580DJ2: 3840x2160@60hz 8lane */
	"vbyone_2",LCD_VBYONE,10,
	/* basic timing */
	3840,2160,4400,2250,33,477,6,81,
	/* clk_attr */
	2,0,1,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* vbyone_attr */
	8,1,4,4,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	Rsv_val,Rsv_val,1,0,50,50,
	Rsv_val,Rsv_val,180,100,25,
	60,10,255},
};

//**** Special parameters just for Vbyone ***//
static struct vbyone_config_s lcd_vbyone_config = {
	.lane_count   = 8,
	.byte_mode    = 4,
	.region_num   = 2,
	.color_fmt    = 4,
};

//**** Special parameters just for lvds ***//
static struct lvds_config_s lcd_lvds_config = {
	.lvds_repack  = 1, //0=JEDIA mode,  1=VESA mode
	.dual_port    = 1, //0=single port, 1=double port
	.pn_swap      = 0, //0=normal,      1=swap
	.port_swap    = 0, //0=normal,      1=swap
};

static struct lcd_power_ctrl_s lcd_power_ctrl = {
	.cpu_gpio = lcd_cpu_gpio,
	.power_on_step = {
		{
			.type = LCD_POWER_TYPE_CPU,
			.index = 0, /* point to cpu_gpio[] struct */
			.value = 1, /* 0=output_low, 1=output_high, 2=input */
			.delay = 50, /* unit: ms */
		},
		{
			.type = LCD_POWER_TYPE_SIGNAL,
			.delay = 0, /* unit: ms */
		},
		{
			.type = LCD_POWER_TYPE_MAX, /* ending flag */
		},
	},
	.power_off_step = {
		{
			.type = LCD_POWER_TYPE_SIGNAL,
			.delay = 50, /* unit: ms */
		},
		{
			.type = LCD_POWER_TYPE_CPU,
			.index = 0, /* point to cpu_gpio[] struct */
			.value = 0, /* 0=output_low, 1=output_high, 2=input */
			.delay = 100, /* unit: ms */
		},
		{
			.type = LCD_POWER_TYPE_MAX, /* ending flag */
		},
	},
};

struct lcd_config_s lcd_config_dft = {
	.lcd_basic = {
		.lcd_type = LCD_LVDS, //LCD_TTL /LCD_LVDS/LCD_VBYONE
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
		.ss_level = 0,
		.fr_adjust_type = 0,

		.hsync_width = 44,
		.hsync_bp    = 148,
		.vsync_width = 5,
		.vsync_bp    = 36,
	},

	.lcd_control = {
		.lvds_config   = &lcd_lvds_config,
		.vbyone_config = &lcd_vbyone_config,
	},
	.lcd_power = &lcd_power_ctrl,
};

struct bl_config_s bl_config_dft = {
	.level_default = 100,
	.level_min = 10,
	.level_max = 255,

	.method = BL_CTRL_PWM,
	.power_on_delay = 200,
	.power_off_delay = 30,
};

