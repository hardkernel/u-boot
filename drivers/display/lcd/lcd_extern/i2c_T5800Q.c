/*
 * drivers/display/lcd/lcd_extern/i2c_T5800Q.c
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
#include <malloc.h>
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#ifdef CONFIG_SYS_I2C_AML
#include <aml_i2c.h>
#endif
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_lcd_extern.h>
#include "lcd_extern.h"
#include "../aml_lcd_common.h"
#include "../aml_lcd_reg.h"

#ifdef CONFIG_SYS_I2C_AML
#define LCD_EXTERN_INDEX		1
#define LCD_EXTERN_NAME			"i2c_T5800Q"
#define LCD_EXTERN_TYPE			LCD_EXTERN_I2C

#define LCD_EXTERN_I2C_ADDR		(0x38 >> 1) //7bit address
#define LCD_EXTERN_I2C_BUS		AML_I2C_MASTER_C

static unsigned aml_i2c_bus_tmp;
static struct lcd_extern_config_s *ext_config;

#define LCD_EXTERN_CMD_SIZE        9
static unsigned char init_on_table[] = {
	//QFHD 50/60Hz 1 division Video Mode ：
	0x00, 0x20, 0x01, 0x02, 0x00, 0x40, 0xFF, 0x00, 0x00,
	0x00, 0x80, 0x02, 0x00, 0x40, 0x62, 0x51, 0x73, 0x00,
	0x00, 0x61, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0xC1, 0x05, 0x0F, 0x00, 0x08, 0x70, 0x00, 0x00,
	0x00, 0x13, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x3D, 0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, //Color Engine Bypass Enable
	0x00, 0xED, 0x0D, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, //Mute only when starting
	0x00, 0x23, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0A, //MEMC off
	0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //ending
};

static unsigned char init_off_table[] = {
	0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //ending
};

static int lcd_extern_i2c_write(unsigned i2caddr, unsigned char *buff, unsigned len)
{
	int ret = 0;
#ifdef LCD_EXT_DEBUG_INFO
	int i;
#endif
	struct i2c_msg msg;

	msg.addr = 0x1c;//i2caddr;
	msg.flags = 0;
	msg.len = 7;//len;
	msg.buf = buff;

#ifdef LCD_EXT_DEBUG_INFO
	printf("%s:", __func__);
	for (i = 0; i < len; i++) {
		printf(" 0x%02x", buff[i]);
	}
	printf(" [addr 0x%02x]\n", i2caddr);
#endif

	ret = aml_i2c_xfer(&msg, 1);
	//ret = aml_i2c_xfer_slow(&msg, 1);
	if (ret < 0)
		EXTERR("i2c write failed [addr 0x%02x]\n", i2caddr);

	return ret;
}

static int lcd_extern_reg_read(unsigned char reg, unsigned char *buf)
{
	int ret = 0;

	return ret;
}

static int lcd_extern_reg_write(unsigned char reg, unsigned char value)
{
	int ret = 0;

	return ret;
}

static struct aml_lcd_extern_pinmux_s aml_lcd_extern_pinmux_set[] = {
	{.reg = 1, .mux = ((1 << 22) | (1 << 23)),},
};

static struct aml_lcd_extern_pinmux_s aml_lcd_extern_pinmux_clr[] = {
	{.reg = 0, .mux = ((1 << 0) | (1 << 1)  | (1 << 10)  | (1 << 11)  | (1 << 23)),},
	{.reg = 1, .mux = ((1 << 0) | (1 << 10) | (1 << 24) | (1 << 25)),},
	{.reg = 2, .mux = ((1 << 0) | (1 << 1)),},
};

static int lcd_extern_i2c_port_init(void)
{
	int i;
	unsigned pinmux_reg, pinmux_data;

	for (i = 0; i < ARRAY_SIZE(aml_lcd_extern_pinmux_clr); i++) {
		pinmux_reg = aml_lcd_extern_pinmux_clr[i].reg;
		pinmux_data = aml_lcd_extern_pinmux_clr[i].mux;
		lcd_pinmux_clr_mask(pinmux_reg, pinmux_data);
	}
	for (i = 0; i < ARRAY_SIZE(aml_lcd_extern_pinmux_set); i++) {
		pinmux_reg = aml_lcd_extern_pinmux_set[i].reg;
		pinmux_data = aml_lcd_extern_pinmux_set[i].mux;
		lcd_pinmux_set_mask(pinmux_reg, pinmux_data);
	}

	return 0;
}

static int lcd_extern_change_i2c_bus(unsigned aml_i2c_bus)
{
	int ret = 0;
	extern struct aml_i2c_platform g_aml_i2c_plat;

	g_aml_i2c_plat.master_no = aml_i2c_bus;
	ret = aml_i2c_init();

	return ret;
}

static int lcd_extern_power_cmd(unsigned char *init_table)
{
	int i = 0, gpio, len;
	int ret = 0;

	len = ext_config->cmd_size;
	if (len < 1) {
		EXTERR("%s: cmd_size %d is invalid\n", __func__, len);
		return -1;
	}
	while (i <= LCD_EXTERN_INIT_TABLE_MAX) {
		if (init_table[i] == LCD_EXTERN_INIT_END) {
			break;
		} else if (init_table[i] == LCD_EXTERN_INIT_NONE) {
			//do nothing, only for delay
		} else if (init_table[i] == LCD_EXTERN_INIT_GPIO) {
			gpio = aml_lcd_extern_get_gpio(init_table[i+1]);
			if (gpio < LCD_GPIO_MAX)
				aml_lcd_gpio_set(gpio, init_table[i+2]);
		} else if (init_table[i] == LCD_EXTERN_INIT_CMD) {
			ret = lcd_extern_i2c_write(ext_config->i2c_addr,
				&init_table[i+1], (len-2));
		} else if (init_table[i] == LCD_EXTERN_INIT_CMD2) {
			ret = lcd_extern_i2c_write(ext_config->i2c_addr2,
				&init_table[i+1], (len-2));
		} else {
			EXTERR("%s(%d: %s): pwoer_type %d is invalid\n",
				__func__, ext_config->index,
				ext_config->name, ext_config->type);
		}
		if (init_table[i+len-1] > 0)
			mdelay(init_table[i+len-1]);
		i += len;
	}

	return ret;
}

static int lcd_extern_power_ctrl(int flag)
{
	extern struct aml_i2c_platform g_aml_i2c_plat;
	aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;
	struct aml_lcd_extern_driver_s *ext_drv = aml_lcd_extern_get_driver();
	int ret = 0;

	/* step 1: power prepare */
	lcd_extern_i2c_port_init();
	lcd_extern_change_i2c_bus(ext_config->i2c_bus);

	/* step 2: power cmd */
	if (flag)
		ret = lcd_extern_power_cmd(ext_drv->config.table_init_on);
	else
		ret = lcd_extern_power_cmd(ext_drv->config.table_init_off);

	/* step 3: power finish */
	lcd_extern_change_i2c_bus(aml_i2c_bus_tmp);

	EXTPR("%s(%d: %s): %d\n",
		__func__, ext_config->index, ext_config->name, flag);
	return ret;
}

static int lcd_extern_power_on(void)
{
	int ret;

	ret = lcd_extern_power_ctrl(1);
	return ret;
}

static int lcd_extern_power_off(void)
{
	int ret;

	ret = lcd_extern_power_ctrl(0);
	return ret;
}

static int lcd_extern_driver_update(struct aml_lcd_extern_driver_s *ext_drv)
{
	if (ext_drv == NULL) {
		EXTERR("%s driver is null\n", LCD_EXTERN_NAME);
		return -1;
	}

	if (ext_drv->config.type == LCD_EXTERN_MAX) { //default for no dts
		ext_drv->config.index = LCD_EXTERN_INDEX;
		ext_drv->config.type = LCD_EXTERN_TYPE;
		strcpy(ext_drv->config.name, LCD_EXTERN_NAME);
		ext_drv->config.cmd_size = LCD_EXTERN_CMD_SIZE;
		ext_drv->config.i2c_addr = LCD_EXTERN_I2C_ADDR;
		ext_drv->config.i2c_bus = LCD_EXTERN_I2C_BUS;
	}
	if (ext_drv->config.table_init_loaded == 0) {
		ext_drv->config.table_init_on  = init_on_table;
		ext_drv->config.table_init_off = init_off_table;
	}
	ext_drv->reg_read  = lcd_extern_reg_read;
	ext_drv->reg_write = lcd_extern_reg_write;
	ext_drv->power_on  = lcd_extern_power_on;
	ext_drv->power_off = lcd_extern_power_off;

	return 0;
}

int aml_lcd_extern_i2c_T5800Q_get_default_index(void)
{
	return LCD_EXTERN_INDEX;
}

int aml_lcd_extern_i2c_T5800Q_probe(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	ext_config = &ext_drv->config;
	ret = lcd_extern_driver_update(ext_drv);

	if (lcd_debug_print_flag)
		EXTPR("%s: %d\n", __func__, ret);
	return ret;
}
#endif

