/*
 * drivers/display/lcd/bl_extern/i2c_lp8556.c
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
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_bl_extern.h>
#include "bl_extern.h"
#include "../aml_lcd_common.h"
#include "../aml_lcd_reg.h"

#define BL_EXTERN_NAME			"i2c_lp8556"
#define BL_EXTERN_TYPE			BL_EXTERN_I2C
#define BL_EXTERN_I2C_ADDR		(0x58 >> 1) //7bit address

//#define BL_EXT_I2C_PORT_INIT     /* no need init i2c port default */

#define BL_EXTERN_CMD_SIZE        LCD_EXT_CMD_SIZE_DYNAMIC
static unsigned char init_on_table[] = {
	0xc0, 2, 0xa2, 0x20,
	0xc0, 2, 0xa5, 0x54,
	0xc0, 2, 0x00, 0xff,
	0xc0, 2, 0x01, 0x05,
	0xc0, 2, 0xa2, 0x20,
	0xc0, 2, 0xa5, 0x54,
	0xc0, 2, 0xa1, 0xb7,
	0xc0, 2, 0xa0, 0xff,
	0xc0, 2, 0x00, 0x80,
	0xff, 0, /*ending*/
};

static unsigned char init_off_table[] = {
	0xff, 0, /*ending*/
};

static int bl_extern_power_cmd_dynamic_size(unsigned char *table, int flag)
{
	int i = 0, j = 0, max_len = 0, step = 0;
	unsigned char type, cmd_size;
	int delay_ms, ret = 0;

	if (flag)
		max_len = ext_config->init_on_cnt;
	else
		max_len = ext_config->init_off_cnt;

	while ((i + 1) < max_len) {
		type = table[i];
		if (type == LCD_EXT_CMD_TYPE_END)
			break;
		if (lcd_debug_print_flag) {
			EXTPR("%s: step %d: type=0x%02x, cmd_size=%d\n",
				__func__, step, type, table[i+1]);
		}
		cmd_size = table[i+1];
		if (cmd_size == 0)
			goto power_cmd_dynamic_next;
		if ((i + 2 + cmd_size) > max_len)
			break;

		if (type == LCD_EXT_CMD_TYPE_NONE) {
			/* do nothing */
		} else if (type == LCD_EXT_CMD_TYPE_DELAY) {
			delay_ms = 0;
			for (j = 0; j < cmd_size; j++)
				delay_ms += table[i+2+j];
			if (delay_ms > 0)
				mdelay(delay_ms);
		} else if (type == LCD_EXT_CMD_TYPE_CMD) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr, &table[i+2], cmd_size);
		} else if (type == LCD_EXT_CMD_TYPE_CMD_DELAY) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr, &table[i+2], (cmd_size-1));
			if (table[i+1+cmd_size] > 0)
				mdelay(table[i+1+cmd_size]);
		} else {
			EXTERR("%s: %s(%d): type 0x%02x invalid\n",
				__func__, ext_config->name, ext_config->index, type);
		}
power_cmd_dynamic_next:
		i += (cmd_size + 2);
		step++;
	}

	return ret;
}

static int bl_extern_power_cmd_fixed_size(unsigned char *table, int flag)
{
	int i = 0, j, max_len, step = 0;
	unsigned char type, cmd_size;
	int delay_ms, ret = 0;

	cmd_size = ext_config->cmd_size;
	if (cmd_size < 2) {
		EXTERR("%s: invalid cmd_size %d\n", __func__, cmd_size);
		return -1;
	}

	if (flag)
		max_len = ext_config->init_on_cnt;
	else
		max_len = ext_config->init_off_cnt;

	while ((i + cmd_size) <= max_len) {
		type = table[i];
		if (type == LCD_EXT_CMD_TYPE_END)
			break;
		if (lcd_debug_print_flag) {
			EXTPR("%s: step %d: type=0x%02x, cmd_size=%d\n",
				__func__, step, type, cmd_size);
		}
		if (type == LCD_EXT_CMD_TYPE_NONE) {
			/* do nothing */
		} else if (type == LCD_EXT_CMD_TYPE_DELAY) {
			delay_ms = 0;
			for (j = 0; j < (cmd_size - 1); j++)
				delay_ms += table[i+1+j];
			if (delay_ms > 0)
				mdelay(delay_ms);
		} else if (type == LCD_EXT_CMD_TYPE_CMD) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr,
				&table[i+1], (cmd_size-1));
		} else if (type == LCD_EXT_CMD_TYPE_CMD_DELAY) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr,
				&table[i+1], (cmd_size-2));
			if (table[i+cmd_size-1] > 0)
				mdelay(table[i+cmd_size-1]);
		} else {
			EXTERR("%s: %s(%d): type 0x%02x is invalid\n",
				__func__, ext_config->name, ext_config->index, type);
		}
		i += cmd_size;
		step++;
	}

	return ret;
}

static int i2c_lp8556_power_ctrl(int flag)
{
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();
	unsigned char *table;
	unsigned char cmd_size;
	int ret = 0;

	/* step 1: power prepare */
#ifdef BL_EXT_I2C_PORT_INIT
	aml_bl_extern_i2c_bus_change(bl_extern->config->i2c_bus);
#endif

	/* step 2: power cmd */
	cmd_size = ext_config->cmd_size;
	if (flag)
		table = ext_config->init_on;
	else
		table = ext_config->init_off;
	if (cmd_size < 1) {
		BLEXERR("%s: cmd_size %d is invalid\n", __func__, cmd_size);
		ret = -1;
		goto power_ctrl_next;
	}
	if (table == NULL) {
		BLEXERR("%s: init_table %d is NULL\n", __func__, flag);
		ret = -1;
		goto power_ctrl_next;
	}
	if (cmd_size == LCD_EXT_CMD_SIZE_DYNAMIC)
		ret = bl_extern_power_cmd_dynamic_size(table, flag);
	else
		ret = bl_extern_power_cmd_fixed_size(table, flag);

power_ctrl_next:
	/* step 3: power finish */
#ifdef BL_EXT_I2C_PORT_INIT
	aml_bl_extern_i2c_bus_recovery();
#endif

	BLEX("%s: %s(%d): %d\n", __func__, bl_extern->config->name,
		bl_extern->config->index, flag);
	return ret;
}

static int i2c_lp8556_power_on(void)
{
	int ret;

	ret = i2c_lp8556_power_ctrl(1);

	return ret;
}

static int i2c_lp8556_power_off(void)
{
	return 0;
}

static int i2c_lp8556_set_level(unsigned int level)
{
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();
	unsigned char tData[3];
	int ret = 0;

	level &= 0xff;

	tData[0] = 0x0;
	tData[1] = level;
	ret = aml_bl_extern_i2c_write(bl_extern->config->i2c_bus,
		bl_extern->config->i2c_addr, tData, 2);

	return ret;
}

static int i2c_lp8556_update(void)
{
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();

	if (bl_extern == NULL) {
		BLEXERR("%s driver is null\n", BL_EXTERN_NAME);
		return -1;
	}

	bl_extern->device_power_on = i2c_lp8556_power_on;
	bl_extern->device_power_off = i2c_lp8556_power_off;
	bl_extern->device_bri_update = i2c_lp8556_set_level;

	bl_extern->config->cmd_size = BL_EXTERN_CMD_SIZE;
	bl_extern->config->init_on = init_on_table;
	bl_extern->config->init_on_cnt = sizeof(init_on_table);
	bl_extern->config->init_off = init_off_table;
	bl_extern->config->init_off_cnt = sizeof(init_off_table);

	return 0;
}

int i2c_lp8556_probe(void)
{
	int ret = 0;

	ret = i2c_lp8556_update();
	if (lcd_debug_print_flag)
		BLEX("%s: %d\n", __func__, ret);

	return ret;
}

