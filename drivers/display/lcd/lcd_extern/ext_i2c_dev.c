/*
 * drivers/display/lcd/lcd_extern/ext_i2c_dev.c
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
#else
#include <i2c.h>
#include <dm/device.h>
#endif
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_lcd_extern.h>
#include "lcd_extern.h"
#include "../aml_lcd_common.h"
#include "../aml_lcd_reg.h"

#ifdef CONFIG_SYS_I2C_AML
static unsigned int aml_i2c_bus_tmp = LCD_EXTERN_I2C_BUS_MAX;
#endif

struct aml_lcd_extern_i2c_match_s {
	unsigned char bus_id;
	unsigned char bus_sys;
	char *bus_str;
};

static struct aml_lcd_extern_i2c_match_s aml_lcd_extern_i2c_match_table[] = {
	{LCD_EXTERN_I2C_BUS_0,   LCD_EXT_I2C_BUS_0,   "i2c_0/a"},
	{LCD_EXTERN_I2C_BUS_1,   LCD_EXT_I2C_BUS_1,   "i2c_1/b"},
	{LCD_EXTERN_I2C_BUS_2,   LCD_EXT_I2C_BUS_2,   "i2c_2/c"},
	{LCD_EXTERN_I2C_BUS_3,   LCD_EXT_I2C_BUS_3,   "i2c_3/d"},
	{LCD_EXTERN_I2C_BUS_4,   LCD_EXT_I2C_BUS_4,   "i2c_4/ao"},
	{LCD_EXTERN_I2C_BUS_MAX, LCD_EXT_I2C_BUS_MAX, "i2c_invalid"},
};

void aml_lcd_extern_i2c_bus_print(unsigned char i2c_bus)
{
	int i, temp = ARRAY_SIZE(aml_lcd_extern_i2c_match_table) - 1;

	for (i = 0; i < ARRAY_SIZE(aml_lcd_extern_i2c_match_table); i++) {
		if (aml_lcd_extern_i2c_match_table[i].bus_id == i2c_bus) {
			temp = i;
			break;
		}
	}

	EXTPR("i2c_bus = %s(%d)\n",
		aml_lcd_extern_i2c_match_table[temp].bus_str, temp);
}

unsigned char aml_lcd_extern_i2c_bus_get_sys(unsigned char i2c_bus)
{
	int i, ret = LCD_EXT_I2C_BUS_MAX;

	for (i = 0; i < ARRAY_SIZE(aml_lcd_extern_i2c_match_table); i++) {
		if (aml_lcd_extern_i2c_match_table[i].bus_id == i2c_bus) {
			ret = aml_lcd_extern_i2c_match_table[i].bus_sys;
			break;
		}
	}

	if (lcd_debug_print_flag)
		EXTPR("%s: %d->%d\n", __func__, i2c_bus, ret);
	return ret;
}

#ifdef CONFIG_SYS_I2C_AML
int aml_lcd_extern_i2c_bus_change(unsigned int i2c_bus)
{
	unsigned char aml_i2c_bus;
	int ret = 0;

	aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;
	aml_i2c_bus = aml_lcd_extern_i2c_bus_get_sys(i2c_bus);

	if (aml_i2c_bus == LCD_EXT_I2C_BUS_MAX) {
		EXTERR("%s: invalid sys aml_i2c_bus %d\n", __func__, aml_i2c_bus);
		return -1;
	}
	g_aml_i2c_plat.master_no = aml_i2c_bus;
	ret = aml_i2c_init();

	return ret;
}

int aml_lcd_extern_i2c_bus_recovery(void)
{
	int ret = 0;

	g_aml_i2c_plat.master_no = aml_i2c_bus_tmp;
	ret = aml_i2c_init();

	return ret;
}

#else
int aml_lcd_extern_i2c_bus_change(unsigned int i2c_bus)
{
	return 0;
}

int aml_lcd_extern_i2c_bus_recovery(void)
{
	return 0;
}
#endif

#ifdef CONFIG_SYS_I2C_AML
int aml_lcd_extern_i2c_write(unsigned char i2c_bus, unsigned i2c_addr,
		unsigned char *buff, unsigned len)
{
	struct i2c_msg msg;
	int i, ret = 0;

	msg.addr = i2c_addr;
	msg.flags = 0;
	msg.len = len;
	msg.buf = buff;

	if (lcd_debug_print_flag) {
		printf("%s:", __func__);
		for (i = 0; i < len; i++)
			printf(" 0x%02x", buff[i]);
		printf(" [addr 0x%02x]\n", i2c_addr);
	}

	ret = aml_i2c_xfer(&msg, 1);
	if (ret < 0)
		EXTERR("i2c write failed [addr 0x%02x]\n", i2c_addr);

	return ret;
}

int aml_lcd_extern_i2c_read(unsigned char i2c_bus, unsigned i2c_addr,
		unsigned char *buff, unsigned int len)
{
	struct i2c_msg msgs[2];
	int ret = 0;

	msgs[0].addr = i2c_addr;
	msgs[0].flags = 0;
	msgs[0].len = 1;
	msgs[0].buf = buff;
	msgs[1].addr = i2c_addr;
	msgs[1].flags = I2C_M_RD;
	msgs[1].len = len;
	msgs[1].buf = buff;

	ret = aml_i2c_xfer(msgs, 2);
	if (ret < 0)
		EXTERR("i2c read failed [addr 0x%02x]\n", i2c_addr);

	return ret;
}

#else
int aml_lcd_extern_i2c_write(unsigned char i2c_bus, unsigned i2c_addr,
		unsigned char *buff, unsigned len)
{
	unsigned char aml_i2c_bus;
	struct udevice *i2c_dev;
	int i, ret = 0;

	aml_i2c_bus = aml_lcd_extern_i2c_bus_get_sys(i2c_bus);
	ret = i2c_get_chip_for_busnum(aml_i2c_bus, i2c_addr, &i2c_dev);
	if (ret) {
		EXTERR("no sys aml_i2c_bus %d find\n", aml_i2c_bus);
		return ret;
	}

	if (lcd_debug_print_flag) {
		printf("%s:", __func__);
		for (i = 0; i < len; i++)
			printf(" 0x%02x", buff[i]);
		printf(" [addr 0x%02x]\n", i2c_addr);
	}

	ret = i2c_write(i2c_dev, i2c_addr, buff, len);
	if (ret) {
		EXTERR("i2c write failed [addr 0x%02x]\n", i2c_addr);
		return ret;
	}

	return 0;
}

int aml_lcd_extern_i2c_read(unsigned char i2c_bus, unsigned i2c_addr,
		unsigned char *buff, unsigned int len)
{
	unsigned char aml_i2c_bus;
	struct udevice *i2c_dev;
	int ret = 0;

	aml_i2c_bus = aml_lcd_extern_i2c_bus_get_sys(i2c_bus);
	ret = i2c_get_chip_for_busnum(aml_i2c_bus, i2c_addr, &i2c_dev);
	if (ret) {
		EXTERR("no sys aml_i2c_bus %d find\n", aml_i2c_bus);
		return ret;
	}

	ret = i2c_write(i2c_dev, i2c_addr, buff, 1);
	if (ret) {
		EXTERR("i2c write failed [addr 0x%02x]\n", i2c_addr);
		return ret;
	}
	ret = i2c_read(i2c_dev, i2c_addr, buff, len);
	if (ret) {
		EXTERR("i2c read failed [addr 0x%02x]\n", i2c_addr);
		return ret;
	}

	return 0;
}
#endif
