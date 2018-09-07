/*
 * drivers/display/lcd/lcd_extern/i2c_RT6947.c
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

#define LCD_EXTERN_NAME			"i2c_RT6947"
#define LCD_EXTERN_TYPE			LCD_EXTERN_I2C
#define LCD_EXTERN_I2C_ADDR		(0x66 >> 1) //7bit address


#define GAMMA_EEPROM_WRITE

//#define LCD_EXT_I2C_PORT_INIT     /* no need init i2c port default */

static struct lcd_extern_config_s *ext_config;

#define LCD_EXTERN_CMD_SIZE        LCD_EXT_CMD_SIZE_DYNAMIC
static unsigned char gamma_init[] = {
	0xc0, 89, 0x00,
		0xA2, 0xD0, 0x80, 0x00, 0x10, 0x10, 0x59, 0x19, 0x4B, 0x0B,
		0x3A, 0x13, 0x27, 0x2F, 0xC2, 0xC9, 0x29, 0xD2, 0x7A, 0x20,
		0xA1, 0xC0, 0x15, 0x01, 0x36, 0x10, 0x10, 0xCB, 0x0A, 0x10,
		0x2C, 0x1C, 0xA0, 0xFF, 0x00, 0x00, 0x0B, 0x02, 0x00, 0x00,
		0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x10,
		0x80, 0x00, 0x60, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x20, 0x02,
		0x00, 0x20, 0x02, 0x00, 0x20, 0x02, 0x00, 0x20, 0x02, 0x00,
		0x20, 0x02, 0x00, 0x20, 0x02, 0x00, 0x20, 0x02, 0x00, 0x20,
		0x00, 0xFF, 0x00, 0x00, 0x0B, 0x02, 0x00, 0x00,
	0xff, 0,  /* ending */
};

#ifdef GAMMA_EEPROM_WRITE
static unsigned char mtp_en[]    = {0x64,0x01};
static unsigned char eeprom_wr[] = {0xFF,0x80};
#endif

static int lcd_extern_power_cmd_dynamic_size(unsigned char *table)
{
	int i = 0, j, step = 0, delay_ms;
	unsigned char type, cmd_size;
	int ret = 0;
	int max_len;

	max_len = ext_config->table_init_on_cnt;
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
		} else if (type == LCD_EXT_CMD_TYPE_CMD2) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr2, &table[i+2], cmd_size);
		} else if (type == LCD_EXT_CMD_TYPE_CMD_DELAY) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr, &table[i+2], (cmd_size-1));
			if (table[i+1+cmd_size] > 0)
				mdelay(table[i+1+cmd_size]);
		} else if (type == LCD_EXT_CMD_TYPE_CMD2_DELAY) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr2, &table[i+2], (cmd_size-1));
			if (table[i+1+cmd_size] > 0)
				mdelay(table[i+1+cmd_size]);
		} else {
			EXTERR("%s(%d: %s): type 0x%02x invalid\n",
				__func__, ext_config->index, ext_config->name, type);
		}
power_cmd_dynamic_next:
		i += (cmd_size + 2);
		step++;
	}

	return ret;
}

static int lcd_extern_power_cmd_fixed_size(unsigned char *table)
{
	int i = 0, j, step = 0, delay_ms;
	unsigned char type, cmd_size;
	int ret = 0;
	int max_len;

	max_len = ext_config->table_init_on_cnt;
	cmd_size = ext_config->cmd_size;
	if (cmd_size < 2) {
		EXTERR("%s: invalid cmd_size %d\n", __func__, cmd_size);
		return -1;
	}

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
				ext_config->i2c_addr, &table[i+1], (cmd_size-1));
		} else if (type == LCD_EXT_CMD_TYPE_CMD2) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr2, &table[i+1], (cmd_size-1));
		} else if (type == LCD_EXT_CMD_TYPE_CMD_DELAY) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr, &table[i+1], (cmd_size-2));
			if (table[i+cmd_size-1] > 0)
				mdelay(table[i+cmd_size-1]);
		} else if (type == LCD_EXT_CMD_TYPE_CMD2_DELAY) {
			ret = aml_lcd_extern_i2c_write(ext_config->i2c_bus,
				ext_config->i2c_addr2, &table[i+1], (cmd_size-2));
			if (table[i+cmd_size-1] > 0)
				mdelay(table[i+cmd_size-1]);
		} else {
			EXTERR("%s(%d: %s): type 0x%02x invalid\n",
				__func__, ext_config->index, ext_config->name, type);
		}
		i += cmd_size;
		step++;
	}

	return ret;
}

static int lcd_extern_power_cmd(unsigned char *table)
{
	int cmd_size;
	int ret = 0;

	cmd_size = ext_config->cmd_size;
	if (cmd_size < 1) {
		EXTERR("%s: cmd_size %d is invalid\n", __func__, cmd_size);
		return -1;
	}
	if (table == NULL)
		return -1;

	if (cmd_size == LCD_EXT_CMD_SIZE_DYNAMIC)
		ret = lcd_extern_power_cmd_dynamic_size(table);
	else
		ret = lcd_extern_power_cmd_fixed_size(table);

	return ret;
}

#ifdef GAMMA_EEPROM_WRITE
static int lcd_extern_init_check(int len)
{
	int ret = 0;
	unsigned char *chk_table;
	int i;

	chk_table = (unsigned char *)malloc(sizeof(unsigned char) * len);
	if (chk_table == NULL) {
		EXTERR("%s: failed to alloc chk_table, not enough memory\n", LCD_EXTERN_NAME);
		ret = lcd_extern_power_cmd(ext_config->table_init_on);
		return ret;
	}
	memset(chk_table, 0, len);

	ret = aml_lcd_extern_i2c_read(ext_config->i2c_bus, ext_config->i2c_addr, chk_table, len);
	if (ret == 0) {
		for (i = 0; i < len; i++) {
			if (chk_table[i] != ext_config->table_init_on[i+3])
				return -1;
		}
	}

	return 0;
}
#endif

static int lcd_extern_power_on(void)
{
	int ret = 0;
#ifdef GAMMA_EEPROM_WRITE
	int len;
#endif

	aml_lcd_extern_pinmux_set(1);
#ifdef LCD_EXT_I2C_PORT_INIT
	aml_lcd_extern_i2c_bus_change(ext_config->i2c_bus);
	mdelay(10);
#endif

#ifdef GAMMA_EEPROM_WRITE
	len = ext_config->table_init_on[1] - 2;
	/* check gamma is init or not */
	ret = lcd_extern_init_check(len);
	if (ret) {
		EXTPR("RT6947: need init gamma and mtp write\n");
		lcd_extern_power_cmd(ext_config->table_init_on);
		/* enable mtp */
		len = sizeof(mtp_en) / sizeof(unsigned char);
		aml_lcd_extern_i2c_write(ext_config->i2c_bus, ext_config->i2c_addr, mtp_en, len);
		/* write eeprom */
		len = sizeof(eeprom_wr) / sizeof(unsigned char);
		aml_lcd_extern_i2c_write(ext_config->i2c_bus, ext_config->i2c_addr, eeprom_wr, len);
	}
#else
	lcd_extern_power_cmd(ext_config->table_init_on);
#endif

#ifdef LCD_EXT_I2C_PORT_INIT
	aml_lcd_extern_i2c_bus_recovery();
#endif

	EXTPR("%s\n", __func__);
	return ret;
}

static int lcd_extern_power_off(void)
{
	int ret = 0;

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
		ext_drv->config->table_init_on = gamma_init;
		ext_drv->config->table_init_on_cnt = sizeof(gamma_init);
	}

	ext_drv->power_on  = lcd_extern_power_on;
	ext_drv->power_off = lcd_extern_power_off;

	return 0;
}

int aml_lcd_extern_i2c_RT6947_probe(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	ext_config = ext_drv->config;
	ret = lcd_extern_driver_update(ext_drv);

	if (lcd_debug_print_flag)
		EXTPR("%s: %d\n", __func__, ret);
	return ret;
}

