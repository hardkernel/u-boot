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
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_lcd_extern.h>
#include "lcd_extern.h"
#include "../aml_lcd_common.h"
#include "../aml_lcd_reg.h"

#define LCD_EXTERN_NAME			"i2c_T5800Q"
#define LCD_EXTERN_TYPE			LCD_EXTERN_I2C
#define LCD_EXTERN_I2C_ADDR		(0x38 >> 1) //7bit address

//#define LCD_EXT_I2C_PORT_INIT     /* no need init i2c port default */

static struct lcd_extern_config_s *ext_config;

#define LCD_EXTERN_CMD_SIZE        LCD_EXT_CMD_SIZE_DYNAMIC
static unsigned char init_on_table[] = {
	//QFHD 50/60Hz 1 division Video Mode ：
	0xc0, 7, 0x20, 0x01, 0x02, 0x00, 0x40, 0xFF, 0x00,
	0xc0, 7, 0x80, 0x02, 0x00, 0x40, 0x62, 0x51, 0x73,
	0xc0, 7, 0x61, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00,
	0xc0, 7, 0xC1, 0x05, 0x0F, 0x00, 0x08, 0x70, 0x00,
	0xc0, 7, 0x13, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
	0xc0, 7, 0x3D, 0x02, 0x01, 0x00, 0x00, 0x00, 0x00, //Color Engine Bypass Enable
	0xc0, 7, 0xED, 0x0D, 0x01, 0x00, 0x00, 0x00, 0x00, //Mute only when starting
	0xc0, 7, 0x23, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, //MEMC off
	0xfd, 1, 10,   /* delay 10ms */
	0xff, 0,  /* ending */
};

static unsigned char init_off_table[] = {
	0xff, 0, //ending
};

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

static int lcd_extern_power_cmd_dynamic_size(unsigned char *table, int flag)
{
	int i = 0, j = 0, max_len = 0, step = 0;
	unsigned char type, cmd_size;
	int delay_ms, ret = 0;

	if (flag)
		max_len = ext_config->table_init_on_cnt;
	else
		max_len = ext_config->table_init_off_cnt;

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
		} else if (type == LCD_EXT_CMD_TYPE_GPIO) {
			if (cmd_size < 2) {
				EXTERR("step %d: invalid cmd_size %d for GPIO\n",
					step, cmd_size);
				goto power_cmd_dynamic_next;
			}
			aml_lcd_extern_gpio_set(table[i+2], table[i+3]);
			if (cmd_size > 2) {
				if (table[i+4] > 0)
					mdelay(table[i+4]);
			}
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

static int lcd_extern_power_cmd_fixed_size(unsigned char *table, int flag)
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
		max_len = ext_config->table_init_on_cnt;
	else
		max_len = ext_config->table_init_off_cnt;

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
		} else if (type == LCD_EXT_CMD_TYPE_GPIO) {
			aml_lcd_extern_gpio_set(table[i+1], table[i+2]);
			if (cmd_size > 3) {
				if (table[i+3] > 0)
					mdelay(table[i+3]);
			}
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
			EXTERR("%s: %s(%d: pwoer_type 0x%02x is invalid\n",
				__func__, ext_config->name, ext_config->index, type);
		}
		i += cmd_size;
		step++;
	}

	return ret;
}

static int lcd_extern_power_ctrl(int flag)
{
	unsigned char *table;
	unsigned char cmd_size;
	int ret = 0;

	/* step 1: power prepare */
#ifdef LCD_EXT_I2C_PORT_INIT
	aml_lcd_extern_i2c_bus_change(ext_config->i2c_bus);
#endif

	/* step 2: power cmd */
	cmd_size = ext_config->cmd_size;
	if (flag)
		table = ext_config->table_init_on;
	else
		table = ext_config->table_init_off;
	if (cmd_size < 1) {
		EXTERR("%s: cmd_size %d is invalid\n", __func__, cmd_size);
		ret = -1;
		goto power_ctrl_next;
	}
	if (table == NULL) {
		EXTERR("%s: init_table %d is NULL\n", __func__, flag);
		ret = -1;
		goto power_ctrl_next;
	}
	if (cmd_size == LCD_EXT_CMD_SIZE_DYNAMIC)
		ret = lcd_extern_power_cmd_dynamic_size(table, flag);
	else
		ret = lcd_extern_power_cmd_fixed_size(table, flag);

power_ctrl_next:
	/* step 3: power finish */
#ifdef LCD_EXT_I2C_PORT_INIT
	aml_lcd_extern_i2c_bus_recovery();
#endif

	if (ret) {
		EXTERR("%s: %s(%d): %d\n", __func__, ext_config->name,
			ext_config->index, flag);
	} else {
		EXTPR("%s: %s(%d): %d\n", __func__, ext_config->name,
			ext_config->index, flag);
	}
	return ret;
}

static int lcd_extern_power_on(void)
{
	int ret;

	aml_lcd_extern_pinmux_set(1);
	ret = lcd_extern_power_ctrl(1);
	return ret;
}

static int lcd_extern_power_off(void)
{
	int ret;

	ret = lcd_extern_power_ctrl(0);
	aml_lcd_extern_pinmux_set(0);

	return ret;
}

static int lcd_extern_driver_update(struct aml_lcd_extern_driver_s *ext_drv)
{
	if (ext_drv == NULL) {
		EXTERR("%s driver is null\n", LCD_EXTERN_NAME);
		return -1;
	}

	if (ext_drv->config->table_init_loaded == 0) {
		ext_drv->config->cmd_size = LCD_EXTERN_CMD_SIZE;
		ext_drv->config->table_init_on  = init_on_table;
		ext_config->table_init_on_cnt = sizeof(init_on_table);
		ext_drv->config->table_init_off = init_off_table;
		ext_config->table_init_off_cnt = sizeof(init_off_table);
	}
	ext_drv->reg_read  = lcd_extern_reg_read;
	ext_drv->reg_write = lcd_extern_reg_write;
	ext_drv->power_on  = lcd_extern_power_on;
	ext_drv->power_off = lcd_extern_power_off;

	return 0;
}

int aml_lcd_extern_i2c_T5800Q_probe(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	ext_config = ext_drv->config;
	ret = lcd_extern_driver_update(ext_drv);

	if (lcd_debug_print_flag)
		EXTPR("%s: %d\n", __func__, ret);
	return ret;
}

