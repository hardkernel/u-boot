/*
 * drivers/display/lcd/bl_extern/bl_extern.c
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
#include <amlogic/aml_bl_extern.h>
#include "bl_extern.h"
#include "../aml_lcd_common.h"

unsigned int bl_extern_brightness;
static struct aml_bl_extern_driver_s bl_extern_driver;

static int bl_extern_set_level(unsigned int level)
{
	bl_extern_brightness = level & 0xff;

	if (bl_extern_driver.device_bri_update)
		bl_extern_driver.device_bri_update(level);

	return 0;
}

static int bl_extern_power_on(void)
{
	int ret = 0;

	BLEX("%s\n", __func__);

	if (bl_extern_driver.device_power_on)
		bl_extern_driver.device_power_on();

	/* restore bl level */
	bl_extern_set_level(bl_extern_brightness);

	return ret;
}
static int bl_extern_power_off(void)
{
	int ret = 0;

	BLEX("%s\n", __func__);

	if (bl_extern_driver.device_power_off)
		bl_extern_driver.device_power_off();

	return ret;
}

static struct aml_bl_extern_driver_s bl_extern_driver = {
	.power_on = bl_extern_power_on,
	.power_off = bl_extern_power_off,
	.set_level = bl_extern_set_level,
	.config_print = NULL,
	.device_power_on = NULL,
	.device_power_off = NULL,
	.device_bri_update = NULL,
	.config = NULL,
};

struct aml_bl_extern_driver_s *aml_bl_extern_get_driver(void)
{
	return &bl_extern_driver;
}

struct aml_bl_extern_i2c_match_s {
	unsigned char bus_id;
	char *bus_str;
};

static struct aml_bl_extern_i2c_match_s aml_bl_extern_i2c_match_table[] = {
	{BL_EXTERN_I2C_BUS_AO,  "i2c_ao"},
	{BL_EXTERN_I2C_BUS_A,   "i2c_a"},
	{BL_EXTERN_I2C_BUS_B,   "i2c_b"},
	{BL_EXTERN_I2C_BUS_C,   "i2c_c"},
	{BL_EXTERN_I2C_BUS_D,   "i2c_d"},
	{BL_EXTERN_I2C_BUS_MAX, "i2c_invalid"},
};

static void aml_bl_extern_i2c_bus_print(unsigned char i2c_bus)
{
	int i, temp = ARRAY_SIZE(aml_bl_extern_i2c_match_table) - 1;

	for (i = 0; i < ARRAY_SIZE(aml_bl_extern_i2c_match_table); i++) {
		if (aml_bl_extern_i2c_match_table[i].bus_id == i2c_bus) {
			temp = i;
			break;
		}
	}

	BLEX("i2c_bus = %s(%d)\n",
		aml_bl_extern_i2c_match_table[temp].bus_str, temp);
}

static unsigned char aml_bl_extern_i2c_bus_table[][2] = {
	{BL_EXTERN_I2C_BUS_AO,   LCD_AML_I2C_BUS_AO},
	{BL_EXTERN_I2C_BUS_A,    LCD_AML_I2C_BUS_A},
	{BL_EXTERN_I2C_BUS_B,    LCD_AML_I2C_BUS_B},
	{BL_EXTERN_I2C_BUS_C,    LCD_AML_I2C_BUS_C},
	{BL_EXTERN_I2C_BUS_D,    LCD_AML_I2C_BUS_D},
	{BL_EXTERN_I2C_BUS_MAX,  LCD_AML_I2C_BUS_MAX},
};

unsigned char aml_bl_extern_i2c_bus_get_sys(unsigned char i2c_bus)
{
	int i, ret = BL_EXTERN_I2C_BUS_INVALID;

	for (i = 0; i < ARRAY_SIZE(aml_bl_extern_i2c_bus_table); i++) {
		if (aml_bl_extern_i2c_bus_table[i][0] == i2c_bus) {
			ret = aml_bl_extern_i2c_bus_table[i][1];
			break;
		}
	}

	if (lcd_debug_print_flag)
		BLEX("%s: %d->%d\n", __func__, i2c_bus, ret);
	return ret;
}

static void bl_extern_config_print(void)
{
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();

	BLEX("%s:\n", __func__);
	switch (bl_extern->config->type) {
	case BL_EXTERN_I2C:
		printf("index:          %d\n"
				"name:          %s\n"
				"type:          i2c(%d)\n"
				"i2c_addr:      0x%02x\n"
				"i2c_bus:       %d\n"
				"dim_min:       %d\n"
				"dim_max:       %d\n",
				bl_extern->config->index,
				bl_extern->config->name,
				bl_extern->config->type,
				bl_extern->config->i2c_addr,
				bl_extern->config->i2c_bus,
				bl_extern->config->dim_min,
				bl_extern->config->dim_max);
		break;
	case BL_EXTERN_SPI:
		break;
	case BL_EXTERN_MIPI:
		printf("index:     %d\n"
				"name:          %s\n"
				"type:          mipi(%d)\n"
				"dim_min:       %d\n"
				"dim_max:       %d\n",
				bl_extern->config->index,
				bl_extern->config->name,
				bl_extern->config->type,
				bl_extern->config->dim_min,
				bl_extern->config->dim_max);
		break;
	default:
		break;
	}
}

#ifdef CONFIG_OF_LIBFDT
static unsigned char bl_extern_get_i2c_bus_str(const char *str)
{
	unsigned char i2c_bus;

	if (strncmp(str, "i2c_bus_ao", 10) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_AO;
	else if (strncmp(str, "i2c_bus_a", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_A;
	else if (strncmp(str, "i2c_bus_b", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_B;
	else if (strncmp(str, "i2c_bus_c", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_C;
	else if (strncmp(str, "i2c_bus_d", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_D;
	else {
		i2c_bus = BL_EXTERN_I2C_BUS_INVALID;
		BLEXERR("invalid i2c_bus: %s\n", str);
	}

	return i2c_bus;
}

static int bl_extern_config_from_dts(char *dtaddr, int index)
{
	int ret = 0;
	int parent_offset, child_offset;
	char propname[30];
	char *propdata;
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();
	unsigned char bl_ext_i2c_bus = BL_EXTERN_I2C_BUS_INVALID;

	parent_offset = fdt_path_offset(dtaddr, "/bl_extern");
	if (parent_offset < 0) {
		BLEXERR("bl: not find /backlight node %s\n", fdt_strerror(parent_offset));
		return -1;
	}
	propdata = (char *)fdt_getprop(dtaddr, parent_offset, "status", NULL);
	if (propdata == NULL) {
		BLEXERR("bl: not find status, default to disabled\n");
		return -1;
	} else {
		if (strncmp(propdata, "okay", 2)) {
			BLEX("bl: status disabled\n");
			return -1;
		}
	}

	propdata = (char *)fdt_getprop(dtaddr, parent_offset, "i2c_bus", NULL);
	if (propdata == NULL)
		bl_ext_i2c_bus = BL_EXTERN_I2C_BUS_INVALID;
	else
		bl_ext_i2c_bus = bl_extern_get_i2c_bus_str(propdata);

	sprintf(propname,"/bl_extern/extern_%d", index);
	child_offset = fdt_path_offset(dtaddr, propname);
	if (child_offset < 0) {
		BLEXERR("bl: not find %s node: %s\n", propname, fdt_strerror(child_offset));
		return -1;
	}
	propdata = (char *)fdt_getprop(dtaddr, child_offset, "index", NULL);
	if (propdata == NULL) {
		BLEXERR("get index failed, exit\n");
		return -1;
	} else {
		if (be32_to_cpup((u32*)propdata) != index) {
			BLEXERR("index not match, exit\n");
			return -1;
		} else {
			bl_extern->config->index = be32_to_cpup((u32*)propdata);
		}
	}
	propdata = (char *)fdt_getprop(dtaddr, child_offset, "extern_name", NULL);
	if (propdata == NULL) {
		BLEXERR("failed to get extern_name\n");
		sprintf(bl_extern->config->name, "extern_%d", index);
	} else {
		strcpy(bl_extern->config->name, propdata);
	}
	propdata = (char *)fdt_getprop(dtaddr, child_offset, "type", NULL);
	if (propdata == NULL) {
		bl_extern->config->type = BL_EXTERN_MAX;
		BLEXERR("get type failed, exit\n");
		return -1;
	} else {
		bl_extern->config->type = be32_to_cpup((u32*)propdata);
	}
	propdata = (char *)fdt_getprop(dtaddr, child_offset, "dim_max_min", NULL);
	if (propdata == NULL) {
		BLEXERR("failed to get bl_level_attr\n");
	} else {
		bl_extern->config->dim_max = be32_to_cpup((u32*)propdata);
		bl_extern->config->dim_min = be32_to_cpup((((u32*)propdata)+1));
	}

	switch (bl_extern->config->type) {
	case BL_EXTERN_I2C:
		propdata = (char *)fdt_getprop(dtaddr, child_offset, "i2c_address", NULL);
		if (propdata == NULL) {
			BLEXERR("get %s i2c_address failed, exit\n", bl_extern->config->name);
			bl_extern->config->i2c_addr = 0xff;
			return -1;
		} else {
			bl_extern->config->i2c_addr = (unsigned char)(be32_to_cpup((u32*)propdata));
		}
		if (bl_ext_i2c_bus == BL_EXTERN_I2C_BUS_INVALID) { /* compatible for kernel3.14 */
			propdata = (char *)fdt_getprop(dtaddr, child_offset, "i2c_bus", NULL);
			if (propdata == NULL) {
				BLEXERR("get %s i2c_bus failed, exit\n", bl_extern->config->name);
				bl_extern->config->i2c_bus = BL_EXTERN_I2C_BUS_INVALID;
				return -1;
			} else {
				bl_extern->config->i2c_bus = bl_extern_get_i2c_bus_str(propdata);
			}
		} else {
			bl_extern->config->i2c_bus = bl_ext_i2c_bus;
		}
		if (lcd_debug_print_flag)
			aml_bl_extern_i2c_bus_print(bl_extern->config->i2c_bus);

		break;
	case BL_EXTERN_SPI:
		break;
	case BL_EXTERN_MIPI:
		break;
	default:
		break;
	}

	return ret;
}
#endif

static int bl_extern_add_driver(void)
{
	int ret = 0;
	struct bl_extern_config_s *extconf = bl_extern_driver.config;

	if (strcmp(extconf->name, "i2c_lp8556") == 0) {
#ifdef CONFIG_AML_BL_EXTERN_I2C_LP8556
		ret = i2c_lp8556_probe();
#endif
		goto bl_extern_add_driver_next;
	} else if (strcmp(extconf->name, "mipi_lt070me05") == 0) {
#ifdef CONFIG_AML_BL_EXTERN_MIPI_IT070ME05
		ret = mipi_lt070me05_probe();
#endif
		goto bl_extern_add_driver_next;
	} else {
		BLEXERR("invalid device name: %s\n", extconf->name);
		ret = -1;
	}

bl_extern_add_driver_next:
	if (ret) {
		BLEXERR("add device driver failed %s(%d)\n",
			extconf->name, extconf->index);
	} else {
		BLEX("add device driver %s(%d)\n",
			extconf->name, extconf->index);
	}

	return ret;
}

int aml_bl_extern_device_load(char *dtaddr, int index)
{
	int ret = 0;

	bl_extern_driver.config = &bl_extern_config_dtf;
	if (dtaddr) {
		if (lcd_debug_print_flag)
			BLEX("load bl_extern_config from dts\n");
		bl_extern_config_from_dts(dtaddr, index);
	}
	bl_extern_add_driver();
	bl_extern_driver.config_print = bl_extern_config_print;
	BLEX("%s OK\n", __func__);

	return ret;
}

