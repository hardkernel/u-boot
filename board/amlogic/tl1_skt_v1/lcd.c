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
#include <asm/arch/gpio.h>

#ifdef CONFIG_AML_LCD_EXTERN
#include "lcd_extern.h"
#endif

static char lcd_cpu_gpio[LCD_CPU_GPIO_NUM_MAX][LCD_CPU_GPIO_NAME_MAX] = {
	"GPIOZ_9", /* panel rst */
	"GPIOZ_8", /* panel power */
	"invalid", /* ending flag */
};

static struct lcd_power_step_s lcd_power_on_step[] = {
	{LCD_POWER_TYPE_CPU,   1,0,100,}, /* lcd power */
	{LCD_POWER_TYPE_CPU,   0,0,10,}, /* lcd_reset */
	{LCD_POWER_TYPE_CPU,   0,1,20,}, /* lcd_reset */
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},  /* signal */
	{LCD_POWER_TYPE_MAX,   0,0,0,},  /* ending flag */
};
static struct lcd_power_step_s lcd_power_off_step[] = {
	{LCD_POWER_TYPE_SIGNAL,0,0,50,},  /* signal */
	{LCD_POWER_TYPE_CPU,   0,0,10,}, /* lcd_reset */
	{LCD_POWER_TYPE_CPU,   1,1,100,}, /* power off */
	{LCD_POWER_TYPE_MAX,   0,0,0,},   /* ending flag */
};

static struct lcd_power_step_s lcd_power_on_step_TV070WSM[] = {
	{LCD_POWER_TYPE_CPU,   1,0,200,}, /* lcd power */
#if 0
	{LCD_POWER_TYPE_CPU,   0,1,10,}, /* lcd_reset */
	{LCD_POWER_TYPE_CPU,   0,0,20,}, /* lcd_reset */
	{LCD_POWER_TYPE_CPU,   0,1,20,}, /* lcd_reset */
#endif
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},  /* signal */
	{LCD_POWER_TYPE_MAX,   0,0,0,},  /* ending flag */
};
static struct lcd_power_step_s lcd_power_off_step_TV070WSM[] = {
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},  /* signal */
	{LCD_POWER_TYPE_CPU,   0,0,20,}, /* lcd_reset */
	{LCD_POWER_TYPE_CPU,   1,1,100,}, /* power off */
	{LCD_POWER_TYPE_MAX,   0,0,0,},   /* ending flag */
};

static struct lcd_power_step_s lcd_power_on_step_P070ACB[] = {
	{LCD_POWER_TYPE_CPU,   1,0,200,}, /* lcd power */
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},  /* signal */
	{LCD_POWER_TYPE_MAX,   0,0,0,},  /* ending flag */
};
static struct lcd_power_step_s lcd_power_off_step_P070ACB[] = {
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},  /* signal */
	{LCD_POWER_TYPE_CPU,   0,0,20,}, /* lcd_reset */
	{LCD_POWER_TYPE_CPU,   1,1,100,}, /* power off */
	{LCD_POWER_TYPE_MAX,   0,0,0,},   /* ending flag */
};

static struct lcd_power_step_s lcd_power_on_step_TL050FHV02CT[] = {
	{LCD_POWER_TYPE_CPU,   1,0,200,}, /* lcd power */
	{LCD_POWER_TYPE_CPU,   0,1,20,}, /* lcd reset: 1 */
	{LCD_POWER_TYPE_CPU,   0,0,10,}, /* lcd reset: 0 */
	{LCD_POWER_TYPE_CPU,   0,1,20,}, /* lcd reset: 1 */
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},  /* signal */
	{LCD_POWER_TYPE_MAX,   0,0,0,},  /* ending flag */
};
static struct lcd_power_step_s lcd_power_off_step_TL050FHV02CT[] = {
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},  /* signal */
	{LCD_POWER_TYPE_CPU,   0,0,20,}, /* lcd_reset */
	{LCD_POWER_TYPE_CPU,   1,1,100,}, /* power off */
	{LCD_POWER_TYPE_MAX,   0,0,0,},   /* ending flag */
};

static struct lcd_power_step_s lcd_power_on_step_TL070WSH27[] = {
	{LCD_POWER_TYPE_CPU,   1,0,100,}, /* lcd power */
	{LCD_POWER_TYPE_CPU,   0,0,10,}, /* lcd reset: 0 */
	{LCD_POWER_TYPE_CPU,   0,1,20,}, /* lcd reset: 1 */
	{LCD_POWER_TYPE_SIGNAL,0,0,0,},  /* signal */
	{LCD_POWER_TYPE_MAX,   0,0,0,},  /* ending flag */
};
static struct lcd_power_step_s lcd_power_off_step_TL070WSH27[] = {
	{LCD_POWER_TYPE_SIGNAL,0,0,10,},  /* signal */
	{LCD_POWER_TYPE_CPU,   0,0,10,}, /* lcd_reset */
	{LCD_POWER_TYPE_CPU,   1,1,100,}, /* power off */
	{LCD_POWER_TYPE_MAX,   0,0,0,},   /* ending flag */
};

static char lcd_bl_gpio[BL_GPIO_NUM_MAX][LCD_CPU_GPIO_NAME_MAX] = {
	"GPIOH_4", /* BL_EN */
	"GPIOH_5", /* BL_PWM */
	"invalid", /* ending flag */
};

struct ext_lcd_config_s ext_lcd_config[LCD_NUM_MAX] = {
	{/* B080XAN01*/
	"lcd_0",LCD_MIPI,8,
	/* basic timing */
	768,1024,948,1140,64,56,0,50,30,0,
	/* clk_attr */
	0,0,1,64843200,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* mipi_attr */
	4,550,0,1,0,2,1,0,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step, lcd_power_off_step,
	/* backlight */
	100,255,10,128,128,
	BL_CTRL_PWM,0,1,0,200,200,
	BL_PWM_NEGATIVE,BL_PWM_F,180,100,25,1,1,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/* TV070WSM*/
	"lcd_1",LCD_MIPI,8,
	/* basic timing */
	600,1024,700,1053,24,36,0,2,8,0,
	/* clk_attr */
	0,0,1,44250000,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* mipi_attr */
	4,360,0,1,0,2,0,0,Rsv_val,1,
	/* power step */
	lcd_power_on_step_TV070WSM, lcd_power_off_step_TV070WSM,
	/* backlight */
	100,255,10,128,128,
	BL_CTRL_PWM,0,1,0,200,200,
	BL_PWM_NEGATIVE,BL_PWM_F,180,100,25,1,1,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/* P070ACB*/
	"lcd_2",LCD_MIPI,8,
	/* basic timing */
	600,1024,680,1194,24,36,0,10,80,0,
	/* clk_attr */
	0,0,1,48715200,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* mipi_attr */
	4,400,0,1,0,2,0,0,Rsv_val,2,
	/* power step */
	lcd_power_on_step_P070ACB, lcd_power_off_step_P070ACB,
	/* backlight */
	100,255,10,128,128,
	BL_CTRL_PWM,0,1,0,200,200,
	BL_PWM_NEGATIVE,BL_PWM_F,180,100,25,1,1,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/* TL050FHV02CT*/
	"lcd_3",LCD_MIPI,8,
	/* basic timing */
	1080,1920,1125,2100,5,30,0,44,108,0,
	/* clk_attr */
	0,0,1,118125000,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* mipi_attr */
	4,960,0,1,0,2,1,0,Rsv_val,3,
	/* power step */
	lcd_power_on_step_TL050FHV02CT, lcd_power_off_step_TL050FHV02CT,
	/* backlight */
	100,255,10,128,128,
	BL_CTRL_PWM,0,1,0,200,200,
	BL_PWM_NEGATIVE,BL_PWM_F,180,100,25,1,1,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{/* TL070WSH27*/
	"lcd_4",LCD_MIPI,8,
	/* basic timing */
	1024,600,1250,630,80,100,0,5,20,0,
	/* clk_attr */
	0,0,1,47250000,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	/* mipi_attr */
	4,300,0,1,0,2,1,0,Rsv_val,Rsv_val,
	/* power step */
	lcd_power_on_step_TL070WSH27, lcd_power_off_step_TL070WSH27,
	/* backlight */
	100,255,10,128,128,
	BL_CTRL_PWM,0,1,0,200,200,
	BL_PWM_NEGATIVE,BL_PWM_F,180,100,25,1,1,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	Rsv_val,Rsv_val,Rsv_val,Rsv_val,
	10,10,Rsv_val},

	{.panel_type = "invalid"},
};

static struct lcd_pinmux_ctrl_s lcd_pinmux_ctrl[LCD_PINMX_MAX] = {
	{
		.name = "lcd_pin",
		.pinmux_set = {{LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "invalid",
	},
};

static struct lcd_pinmux_ctrl_s bl_pinmux_ctrl[BL_PINMUX_MAX] = {
	{
		.name = "bl_pwm_on_pin", //GPIOH_5
		.pinmux_set = {{11, 0x00400000}, {LCD_PINMUX_END, 0x0}},
		.pinmux_clr = {{11, 0x00f00000}, {LCD_PINMUX_END, 0x0}},
	},
	{
		.name = "invalid",
	},
};

static unsigned char mipi_init_on_table[DSI_INIT_ON_MAX] = {//table size < 100
	0x05, 1, 0x11,
	0xff, 20,
	0x05, 1, 0x29,
	0xff, 20,
	0xff, 0xff,   //ending flag
};
static unsigned char mipi_init_off_table[DSI_INIT_OFF_MAX] = {//table size < 50
	0x05, 1, 0x28,
	0xff, 10,
	0x05, 1, 0x10,
	0xff, 10,
	0xff,0xff,   //ending flag
};

static unsigned char mipi_init_on_table_TV070WSM[DSI_INIT_ON_MAX] = {//table size < 100
	0xff, 10,
	0xf0, 3, 0, 1, 30, /* reset high, delay 30ms */
	0xf0, 3, 0, 0, 10, /* reset low, delay 10ms */
	0xf0, 3, 0, 1, 30, /* reset high, delay 30ms */
	0xfc, 2, 0x04, 3,  /* check_reg, check_cnt */
	0xff, 100,   /* delay */
	0xff, 0xff,   //ending flag
};
static unsigned char mipi_init_off_table_TV070WSM[DSI_INIT_OFF_MAX] = {//table size < 50
	0xff,0xff,   //ending flag
};

static unsigned char mipi_init_on_table_P070ACB[DSI_INIT_ON_MAX] = {//table size < 100
	0xff, 10,
	0xf0, 3, 0, 1, 30, /* reset high, delay 30ms */
	0xf0, 3, 0, 0, 10, /* reset low, delay 10ms */
	0xf0, 3, 0, 1, 30, /* reset high, delay 30ms */
	0xfc, 2, 0x04, 3,  /* check_reg, check_cnt */
	0xff, 0xff,   //ending flag
};
static unsigned char mipi_init_off_table_P070ACB[DSI_INIT_OFF_MAX] = {//table size < 50
	0xff,0xff,   //ending flag
};

static unsigned char mipi_init_on_table_TL050FHV02CT[DSI_INIT_ON_MAX] = {//table size < 100
	0xff,0xff,   //ending flag
};
static unsigned char mipi_init_off_table_TL050FHV02CT[DSI_INIT_OFF_MAX] = {//table size < 50
	0xff,0xff,   //ending flag
};

static unsigned char mipi_init_on_table_TL070WSH27[DSI_INIT_ON_MAX] = {//table size < 100
	0x05, 1, 0x11,
	0xff, 100,
	0x05, 1, 0x29,
	0xff, 20,
	0xff, 0xff,   //ending flag
};
static unsigned char mipi_init_off_table_TL070WSH27[DSI_INIT_OFF_MAX] = {//table size < 50
	0x05, 1, 0x28,
	0xff, 100,
	0x05, 1, 0x10,
	0xff, 10,
	0xff, 0xff,   //ending flag
};

static struct dsi_config_s lcd_mipi_config = {
	.lane_num = 4,
	.bit_rate_max = 550, /* MHz */
	.factor_numerator   = 0,
	.factor_denominator = 100,
	.operation_mode_init = 1,    /* 0=video mode, 1=command mode */
	.operation_mode_display = 0, /* 0=video mode, 1=command mode */
	.video_mode_type = 2, /* 0=sync_pulse, 1=sync_event, 2=burst */
	.clk_always_hs = 1, /* 0=disable, 1=enable */
	.phy_switch = 0,   /* 0=auto, 1=standard, 2=slow */

	.dsi_init_on  = &mipi_init_on_table[0],
	.dsi_init_off = &mipi_init_off_table[0],
	.extern_init = 0xff, /* ext_index if needed, 0xff for invalid */
	.check_en = 0,
	.check_state = 0,
};

static struct lcd_power_ctrl_s lcd_power_ctrl = {
	.power_on_step = {
		{
			.type = LCD_POWER_TYPE_CPU,
			.index = 0, /* point to cpu_gpio[] struct */
			.value = 1, /* 0=output_low, 1=output_high, 2=input */
			.delay = 10, /* unit: ms */
		},
		{
			.type = LCD_POWER_TYPE_CPU,
			.index = 0, /* point to cpu_gpio[] struct */
			.value = 0, /* 0=output_low, 1=output_high, 2=input */
			.delay = 20, /* unit: ms */
		},
		{
			.type = LCD_POWER_TYPE_CPU,
			.index = 0, /* point to cpu_gpio[] struct */
			.value = 1, /* 0=output_low, 1=output_high, 2=input */
			.delay = 20, /* unit: ms */
		},
		{
			.type = LCD_POWER_TYPE_SIGNAL,
			.index = 0, /* point to cpu_gpio[] struct */
			.value = 1, /* 0=output_low, 1=output_high, 2=input */
			.delay = 0, /* unit: ms */
		},
		{
			.type = LCD_POWER_TYPE_MAX, /* ending flag */
		},
	},
	.power_off_step = {
		{
			.type = LCD_POWER_TYPE_SIGNAL,
			.index = 0, /* point to cpu_gpio[] struct */
			.value = 0, /* 0=output_low, 1=output_high, 2=input */
			.delay = 100, /* unit: ms */
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
	.lcd_mode = LCD_MODE_TABLET,
	.lcd_key_valid = 0,
	.lcd_clk_path = 0,
	.lcd_basic = {
		.model_name = "default",
		.lcd_type = LCD_TYPE_MAX,
		.lcd_bits = 8,
		.h_active = 768,
		.v_active = 1024,
		.h_period = 948,
		.v_period = 1140,

		.screen_width   = 119,
		.screen_height  = 159,
	},

	.lcd_timing = {
		.clk_auto = 1,
		.lcd_clk = 64843200,
		.ss_level = 0,
		.fr_adjust_type = 0,

		.hsync_width = 64,
		.hsync_bp    = 56,
		.hsync_pol   = 0,
		.vsync_width = 50,
		.vsync_bp    = 30,
		.vsync_pol   = 0,
	},

	.lcd_control = {
		.mipi_config= &lcd_mipi_config,
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

static unsigned char ext_init_on_table[LCD_EXTERN_INIT_ON_MAX] = {
	0xff, 0xff,   //ending flag
};

static unsigned char ext_init_off_table[LCD_EXTERN_INIT_OFF_MAX] = {
	0xff,0xff,   //ending flag
};

struct lcd_extern_common_s ext_common_dft = {
	.lcd_ext_key_valid = 0,
	.lcd_ext_num = 4,
	.pinmux_set = {{LCD_PINMUX_END, 0x0}},
	.pinmux_clr = {{LCD_PINMUX_END, 0x0}},
};

struct lcd_extern_config_s ext_config_dtf[LCD_EXTERN_NUM_MAX] = {
	{
		.index = 0,
		.name = "ext_default",
		.type = LCD_EXTERN_I2C, /* LCD_EXTERN_I2C, LCD_EXTERN_SPI, LCD_EXTERN_MIPI, LCD_EXTERN_MAX */
		.status = 0, /* 0=disable, 1=enable */
		.i2c_addr = 0x1c, /* 7bit i2c address */
		.i2c_addr2 = 0xff, /* 7bit i2c address, 0xff for none */
		.i2c_bus = LCD_EXTERN_I2C_BUS_C, /* LCD_EXTERN_I2C_BUS_AO, LCD_EXTERN_I2C_BUS_A/B/C/D */
		.cmd_size = 9,
		.table_init_on = ext_init_on_table,
		.table_init_off = ext_init_off_table,
	},
	{
		.index = 1,
		.name = "mipi_default",
		.type = LCD_EXTERN_MIPI, /* LCD_EXTERN_I2C, LCD_EXTERN_SPI, LCD_EXTERN_MIPI, LCD_EXTERN_MAX */
		.status = 1, /* 0=disable, 1=enable */
		.cmd_size = LCD_EXTERN_CMD_SIZE_DYNAMIC,
		.table_init_on = ext_init_on_table_TV070WSM,
		.table_init_off = ext_init_off_table_TV070WSM,
	},
	{
		.index = 2,
		.name = "mipi_default",
		.type = LCD_EXTERN_MIPI, /* LCD_EXTERN_I2C, LCD_EXTERN_SPI, LCD_EXTERN_MIPI, LCD_EXTERN_MAX */
		.status = 1, /* 0=disable, 1=enable */
		.cmd_size = LCD_EXTERN_CMD_SIZE_DYNAMIC,
		.table_init_on = ext_init_on_table_P070ACB,
		.table_init_off = ext_init_off_table_P070ACB,
	},
	{
		.index = 3,
		.name = "mipi_default",
		.type = LCD_EXTERN_MIPI, /* LCD_EXTERN_I2C, LCD_EXTERN_SPI, LCD_EXTERN_MIPI, LCD_EXTERN_MAX */
		.status = 1, /* 0=disable, 1=enable */
		.cmd_size = LCD_EXTERN_CMD_SIZE_DYNAMIC,
		.table_init_on = ext_init_on_table_TL050FHV02CT,
		.table_init_off = ext_init_off_table_TL050FHV02CT,
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
	.pinmux_set = {{11, 0x00400000}, {LCD_PINMUX_END, 0x0}},
	.pinmux_clr = {{11, 0x00f00000}, {LCD_PINMUX_END, 0x0}},
};

#ifdef CONFIG_AML_BL_EXTERN
struct bl_extern_config_s bl_extern_config_dtf = {
	.index = BL_EXTERN_INDEX_INVALID,
	.name = "none",
	.type = BL_EXTERN_MAX,
	.i2c_addr = 0xff,
	.i2c_bus = BL_EXTERN_I2C_BUS_MAX,
	.dim_min = 10,
	.dim_max = 255,
};
#endif

void lcd_config_bsp_init(void)
{
	int i, j;
	char *str;
	struct ext_lcd_config_s *ext_lcd = NULL;

	str = getenv("panel_type");
	if (str) {
		for (i = 0 ; i < LCD_NUM_MAX ; i++) {
			ext_lcd = &ext_lcd_config[i];
			if (strcmp(ext_lcd->panel_type, str) == 0) {
				switch (i) {
				case 1:
					lcd_mipi_config.dsi_init_on = mipi_init_on_table_TV070WSM;
					lcd_mipi_config.dsi_init_off = mipi_init_off_table_TV070WSM;
					break;
				case 2:
					lcd_mipi_config.dsi_init_on = mipi_init_on_table_P070ACB;
					lcd_mipi_config.dsi_init_off = mipi_init_off_table_P070ACB;
					break;
				case 3:
					lcd_mipi_config.dsi_init_on = mipi_init_on_table_TL050FHV02CT;
					lcd_mipi_config.dsi_init_off = mipi_init_off_table_TL050FHV02CT;
					break;
				case 4:
					lcd_mipi_config.dsi_init_on = mipi_init_on_table_TL070WSH27;
					lcd_mipi_config.dsi_init_off = mipi_init_off_table_TL070WSH27;
					break;
				case 0:
				default:
					lcd_mipi_config.dsi_init_on = mipi_init_on_table;
					lcd_mipi_config.dsi_init_off = mipi_init_off_table;
					break;
				}
				break;
			}
		}
	}

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
}
