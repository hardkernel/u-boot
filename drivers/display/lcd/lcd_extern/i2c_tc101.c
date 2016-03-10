/*
 * drivers/display/lcd/lcd_extern/i2c_tc101.c
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
#define LCD_EXTERN_NAME			"i2c_tc101"
#define LCD_EXTERN_TYPE			LCD_EXTERN_I2C

#define LCD_EXTERN_I2C_ADDR		(0xfc >> 1) //7bit address
#define LCD_EXTERN_I2C_BUS		AML_I2C_MASTER_A

static unsigned aml_i2c_bus_tmp;
static struct lcd_extern_config_s *ext_config;
extern int aml_i2c_xfer_slow(struct i2c_msg *msgs, int num);

#define INIT_LEN        3
static unsigned char i2c_init_table[][INIT_LEN] = {
	//{0xff, 0xff, 20},//delay mark(20ms)
	{0xf8, 0x30, 0xb2},
	{0xf8, 0x33, 0xc2},
	{0xf8, 0x31, 0xf0},
	{0xf8, 0x40, 0x80},
	{0xf8, 0x81, 0xec},
	{0xff, 0xff, 0xff},//ending mark
};

static int lcd_extern_i2c_write(unsigned i2caddr, unsigned char *buff, unsigned len)
{
	int ret = 0;
#ifdef LCD_EXT_DEBUG_INFO
	int i;
#endif
	struct i2c_msg msg[] = {
		{
			.addr = i2caddr,
			.flags = 0,
			.len = len,
			.buf = buff,
		},
	};

#ifdef LCD_EXT_DEBUG_INFO
	printf("%s:", __func__);
	for (i = 0; i < len; i++) {
		printf(" 0x%02x", buff[i]);
	}
	printf(" [addr 0x%02x]\n", i2caddr);
#endif

	//ret = aml_i2c_xfer(msg, 1);
	ret = aml_i2c_xfer_slow(msg, 1);
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

static int lcd_extern_i2c_init(void)
{
	int i = 0, ending_mark = 0;
	int ret = 0;

	while (ending_mark == 0) {
		if ((i2c_init_table[i][0] == 0xff) && (i2c_init_table[i][1] == 0xff)) {    //special mark
			if (i2c_init_table[i][2] == 0xff) //ending mark
				ending_mark = 1;
			else //delay mark
				mdelay(i2c_init_table[i][2]);
		} else {
			ret = lcd_extern_i2c_write(ext_config->i2c_addr, &i2c_init_table[i][0], INIT_LEN);
		}
		i++;
	}
	EXTPR("%s: %s\n", __func__, ext_config->name);
	return ret;
}

static int lcd_extern_i2c_remove(void)
{
	int ret = 0;

	return ret;
}

static struct aml_lcd_extern_pinmux_s aml_lcd_extern_pinmux_set[] = {
	{.reg = 5, .mux = ((1 << 6) | (1 << 7)),},
};

static struct aml_lcd_extern_pinmux_s aml_lcd_extern_pinmux_clr[] = {
	{.reg = 6, .mux = ((1 << 6) | (1 << 7)),},
	{.reg = 8, .mux = ((1 << 14) | (1 << 15)),},
};

static int lcd_extern_port_init(void)
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

static int lcd_extern_power_on(void)
{
	int ret = 0;
	extern struct aml_i2c_platform g_aml_i2c_plat;
	aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;

	lcd_extern_port_init();
	lcd_extern_change_i2c_bus(ext_config->i2c_bus);
	ret = lcd_extern_i2c_init();
	lcd_extern_change_i2c_bus(aml_i2c_bus_tmp);

	return ret;
}

static int lcd_extern_power_off(void)
{
	int ret = 0;
	extern struct aml_i2c_platform g_aml_i2c_plat;

	aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;

	lcd_extern_port_init();
	lcd_extern_change_i2c_bus(ext_config->i2c_bus);
	ret = lcd_extern_i2c_remove();
	lcd_extern_change_i2c_bus(aml_i2c_bus_tmp);

	return ret;
}

static int lcd_extern_driver_update(struct aml_lcd_extern_driver_s *ext_drv)
{
	if (ext_drv == NULL) {
		EXTERR("%s driver is null\n", LCD_EXTERN_NAME);
		return -1;
	}

	if (ext_drv->config.type == LCD_EXTERN_MAX) { //default for no dt
		ext_drv->config.index = LCD_EXTERN_INDEX;
		ext_drv->config.type = LCD_EXTERN_TYPE;
		strcpy(ext_drv->config.name, LCD_EXTERN_NAME);
		ext_drv->config.i2c_addr = LCD_EXTERN_I2C_ADDR;
		ext_drv->config.i2c_bus = LCD_EXTERN_I2C_BUS;
	}
	ext_drv->reg_read  = lcd_extern_reg_read;
	ext_drv->reg_write = lcd_extern_reg_write;
	ext_drv->power_on  = lcd_extern_power_on;
	ext_drv->power_off = lcd_extern_power_off;

	return 0;
}

int aml_lcd_extern_i2c_tc101_get_default_index(void)
{
	return LCD_EXTERN_INDEX;
}

int aml_lcd_extern_i2c_tc101_probe(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	ext_config = &ext_drv->config;
	ret = lcd_extern_driver_update(ext_drv);

	if (lcd_debug_print_flag)
		EXTPR("%s: %d\n", __func__, ret);
	return ret;
}
#endif

