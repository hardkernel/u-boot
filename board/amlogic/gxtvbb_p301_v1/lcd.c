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
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
 *
 */

#include <common.h>
#include <asm/arch/io.h>
#include <amlogic/aml_lcd_tv.h>
#include <asm/arch/gpio.h>

//Rsv_val = 0xffffffff

struct ext_lcd_config_s ext_lcd_config[LCD_TYPE_MAX] = {
	{/* AOC: public Platform lvds : 1920x1080@60hz 8bit pixel clk@74.25mhz 2prot*/
	"lvds_0",LCD_LVDS,8,
	1920,1080,2200,1125,44,148,5,36,
	0,1,0,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	1,0,1,0,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	GPIOH_0,1,0,50,50,
	0xff,0,0,
	Rsv_val,1,0,50,50,
	BL_PWM_B,180,100,25,1,60,10,255},

	{/*BOE: HV550QU2-305 vx1 : 3840x2160@60hz 8lane pixel clk@74.5mhz */
	"vbyone_0",LCD_VBYONE,10,
	3840,2160,4400,2250,33,477,6,81,
	0,1,0,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	8,4,2,4,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	GPIOH_0,1,0,50,50,
	0xff,0,0,
	Rsv_val,1,0,50,50,
	BL_PWM_B,180,100,25,1,128,10,255},
};

//**** Special parameters just for Vbyone ***//
static struct vbyone_config_s lcd_vbyone_config = {
	.lane_count 	= 8, //lane:  1/2/4/6/8 lanes;
	.byte_mode	= 4, //byte:  3/4/5 bytes;
	.region_num	= 2, //region
	.color_fmt	= 4, //color_fmt
};

//**** Special parameters just for lvds ***//
static struct lvds_config_s lcd_lvds_config = {
	.lvds_repack	= 1, //0->JEDIA mode,  1->VESA mode
	.pn_swap	= 0, //0->normal,         1->swap
	.dual_port	= 1, //0->single lvds, 1->double lvds
	.port_swap	= 0,
};

#ifdef CONFIG_AML_LCD_EXTERN
struct lcd_extern_config_s lcd_extern_config = {
	.index = LCD_EXTERN_INDEX_INVALID,
	.on_delay = 0,
	.off_delay = 0,
};
#endif

//****panel power control only for uboot ***//
static struct lcd_power_ctrl_s lcd_power_ctrl = {
	.gpio		=	GPIOH_0, /** panel power control gpio port */
	.on_value	=	1, /** panel power on gpio out value*/
	.off_value	=	0, /** panel power off gpio out value*/
	.on_delay	=	50, /** panel power on delay time (unit: ms)*/
	.off_delay	=	50  /** panel power off delay time (unit: ms)*/
};

struct lcd_config_s lcd_config_dft = {
	.lcd_basic = {
		.lcd_type = LCD_LVDS, //LCD_DIGITAL_TTL /LCD_DIGITAL_LVDS/LCD_DIGITAL_VBYONE
		.lcd_bits = 8,
		.h_active = 1920,
		.v_active = 1080,
		.h_period = 2200,
		.v_period = 1125,

		.screen_ratio_width   = 16,
		.screen_ratio_height  = 9,
		.screen_actual_width  = 127,
		.screen_actual_height = 203,
	},

	.lcd_timing = {
		.frame_rate_adj_type = 0,
		.clk_auto = 1,
		.ss_level = 0,

		.hsync_width = 44,
		.hsync_bp    = 148,
		.vsync_width = 5,
		.vsync_bp    = 36,
	},

	.lcd_control = {
#ifdef CONFIG_AML_LCD_EXTERN
		.ext_config	= &lcd_extern_config,
#endif
		.lvds_config	= &lcd_lvds_config,
		.vbyone_config	= &lcd_vbyone_config,
	},
	.lcd_power = &lcd_power_ctrl,
};

