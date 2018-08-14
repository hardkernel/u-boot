/*
 * drivers/display/lcd/lcd_extern/ext_default.c
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

//#define LCD_EXT_DEBUG_INFO

#define LCD_EXTERN_NAME           "ext_default"

#ifdef CONFIG_SYS_I2C_AML
//#define LCD_EXT_I2C_PORT_INIT     /* no need init i2c port default */
#ifdef LCD_EXT_I2C_PORT_INIT
static unsigned int aml_i2c_bus_tmp = LCD_EXTERN_I2C_BUS_INVALID;
#endif
#endif

static struct lcd_extern_config_s *ext_config;

#define LCD_EXTERN_CMD_SIZE        0

#ifdef CONFIG_SYS_I2C_AML
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
	for (i = 0; i < len; i++)
		printf(" 0x%02x", buff[i]);
	printf(" [addr 0x%02x]\n", i2caddr);
#endif

	ret = aml_i2c_xfer(msg, 1);
	if (ret < 0)
		EXTERR("i2c write failed [addr 0x%02x]\n", i2caddr);

	return ret;
}
#else
static int lcd_extern_i2c_write(unsigned i2caddr, unsigned char *buff, unsigned len)
{
	int ret;
	unsigned char i2c_bus;
	struct udevice *i2c_dev;
#ifdef LCD_EXT_DEBUG_INFO
	int i;
#endif

	i2c_bus = aml_lcd_extern_i2c_bus_get_sys(ext_config->i2c_bus);
	ret = i2c_get_chip_for_busnum(i2c_bus, i2caddr, &i2c_dev);
	if (ret) {
		EXTERR("no sys i2c_bus %d find\n", i2c_bus);
		return ret;
	}

#ifdef LCD_EXT_DEBUG_INFO
	printf("%s:", __func__);
	for (i = 0; i < len; i++)
		printf(" 0x%02x", buff[i]);
	printf(" [addr 0x%02x]\n", i2caddr);
#endif

	ret = i2c_write(i2c_dev, i2caddr, buff, len);
	if (ret) {
		EXTERR("i2c write failed [addr 0x%02x]\n", i2caddr);
		return ret;
	}

	return 0;
}
#endif

static int lcd_extern_spi_write(unsigned char *buf, int len)
{
	EXTPR("to do\n");
	return 0;
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

static int lcd_extern_power_cmd_dynamic_size(unsigned char *init_table, int flag)
{
	int i = 0, max_len = 0, step = 0;
	unsigned char type, cmd_size;
	int ret = 0;

	if (flag)
		max_len = LCD_EXTERN_INIT_ON_MAX;
	else
		max_len = LCD_EXTERN_INIT_OFF_MAX;

	switch (ext_config->type) {
	case LCD_EXTERN_I2C:
		while (i <= max_len) {
			type = init_table[i];
			if (type == LCD_EXTERN_INIT_END)
				break;
			if (lcd_debug_print_flag) {
				EXTPR("%s: step %d: type=0x%02x, cmd_size=%d\n",
					__func__, step, init_table[i], init_table[i+1]);
			}
			cmd_size = init_table[i+1];
			if (type == LCD_EXTERN_INIT_NONE) {
				if (cmd_size < 1) {
					EXTERR("step %d: invalid cmd_size %d\n", step, cmd_size);
					i += (cmd_size + 2);
					step++;
					continue;
				}
				/* do nothing, only for delay */
				if (init_table[i+2] > 0)
					mdelay(init_table[i+2]);
			} else if (type == LCD_EXTERN_INIT_GPIO) {
				if (cmd_size < 3) {
					EXTERR("step %d: invalid cmd_size %d\n", step, cmd_size);
					i += (cmd_size + 2);
					step++;
					continue;
				}
				aml_lcd_extern_set_gpio(init_table[i+2], init_table[i+3]);
				if (init_table[i+4] > 0)
					mdelay(init_table[i+3]);
			} else if (type == LCD_EXTERN_INIT_CMD) {
				ret = lcd_extern_i2c_write(ext_config->i2c_addr,
					&init_table[i+2], (cmd_size-1));
				if (init_table[i+1+cmd_size] > 0)
					mdelay(init_table[i+1+cmd_size]);
			} else if (type == LCD_EXTERN_INIT_CMD2) {
				ret = lcd_extern_i2c_write(ext_config->i2c_addr2,
					&init_table[i+2], (cmd_size - 1));
				if (init_table[i+1+cmd_size] > 0)
					mdelay(init_table[i+1+cmd_size]);
			} else {
				EXTERR("%s(%d: %s): type %d invalid\n",
					__func__, ext_config->index,
					ext_config->name, ext_config->type);
			}
			i += (cmd_size + 2);
			step++;
		}
		break;
	case LCD_EXTERN_SPI:
		while (i <= max_len) {
			type = init_table[i];
			if (type == LCD_EXTERN_INIT_END)
				break;
			if (lcd_debug_print_flag) {
				EXTPR("%s: step %d: type=0x%02x, cmd_size=%d\n",
					__func__, step, init_table[i], init_table[i+1]);
			}
			cmd_size = init_table[i+1];
			if (type == LCD_EXTERN_INIT_NONE) {
				if (cmd_size < 1) {
					EXTERR("step %d: invalid cmd_size %d\n", step, cmd_size);
					i += (cmd_size + 2);
					step++;
					continue;
				}
				/* do nothing, only for delay */
				if (init_table[i+2] > 0)
					mdelay(init_table[i+2]);
			} else if (type == LCD_EXTERN_INIT_GPIO) {
				if (cmd_size < 3) {
					EXTERR("step %d: invalid cmd_size %d\n", step, cmd_size);
					i += (cmd_size + 2);
					step++;
					continue;
				}
				aml_lcd_extern_set_gpio(init_table[i+2], init_table[i+3]);
				if (init_table[i+4] > 0)
					mdelay(init_table[i+4]);
			} else if (type == LCD_EXTERN_INIT_CMD) {
				ret = lcd_extern_spi_write(&init_table[i+2], (cmd_size-1));
				if (init_table[i+1+cmd_size] > 0)
					mdelay(init_table[i+1+cmd_size]);
			} else {
				EXTERR("%s(%d: %s): type %d invalid\n",
					__func__, ext_config->index,
					ext_config->name, ext_config->type);
			}
			i += (cmd_size + 2);
			step++;
		}
		break;
	default:
		EXTERR("%s(%d: %s): extern_type %d is not support\n",
			__func__, ext_config->index,
			ext_config->name, ext_config->type);
		break;
	}

	return ret;
}

static int lcd_extern_power_cmd_fixed_size(unsigned char *init_table, int flag)
{
	int i = 0, max_len = 0, step = 0;
	unsigned char type, cmd_size;
	int ret = 0;

	if (flag)
		max_len = LCD_EXTERN_INIT_ON_MAX;
	else
		max_len = LCD_EXTERN_INIT_OFF_MAX;

	cmd_size = ext_config->cmd_size;
	switch (ext_config->type) {
	case LCD_EXTERN_I2C:
		while (i <= max_len) {
			type = init_table[i];
			if (type == LCD_EXTERN_INIT_END)
				break;
			if (lcd_debug_print_flag) {
				EXTPR("%s: step %d: type=0x%02x, cmd_size=%d\n",
					__func__, step, type, cmd_size);
			}
			if (type == LCD_EXTERN_INIT_NONE) {
				/* do nothing, only for delay */
			} else if (type == LCD_EXTERN_INIT_GPIO) {
				aml_lcd_extern_set_gpio(init_table[i+1], init_table[i+2]);
			} else if (type == LCD_EXTERN_INIT_CMD) {
				ret = lcd_extern_i2c_write(ext_config->i2c_addr,
					&init_table[i+1], (cmd_size-2));
			} else if (type == LCD_EXTERN_INIT_CMD2) {
				ret = lcd_extern_i2c_write(ext_config->i2c_addr2,
					&init_table[i+1], (cmd_size-2));
			} else {
				EXTERR("%s(%d: %s): type %d invalid\n",
					__func__, ext_config->index,
					ext_config->name, ext_config->type);
			}
			if (init_table[i+cmd_size-1] > 0)
				mdelay(init_table[i+cmd_size-1]);
			i += cmd_size;
			step++;
		}
		break;
	case LCD_EXTERN_SPI:
		while (i <= max_len) {
			type = init_table[i];
			if (type == LCD_EXTERN_INIT_END)
				break;
			if (lcd_debug_print_flag) {
				EXTPR("%s: step %d: type=0x%02x, cmd_size=%d\n",
					__func__, step, type, cmd_size);
			}
			if (type == LCD_EXTERN_INIT_NONE) {
				/* do nothing, only for delay */
			} else if (type == LCD_EXTERN_INIT_GPIO) {
				aml_lcd_extern_set_gpio(init_table[i+1], init_table[i+2]);
			} else if (type == LCD_EXTERN_INIT_CMD) {
				ret = lcd_extern_spi_write(&init_table[i+1], (cmd_size-2));
			} else {
				EXTERR("%s(%d: %s): type %d invalid\n",
					__func__, ext_config->index,
					ext_config->name, ext_config->type);
			}
			if (init_table[i+cmd_size-1] > 0)
				mdelay(init_table[i+cmd_size-1]);
			i += cmd_size;
			step++;
		}
		break;
	default:
		EXTERR("%s(%d: %s): extern_type %d is not support\n",
			__func__, ext_config->index,
			ext_config->name, ext_config->type);
		break;
	}

	return ret;
}

static int lcd_extern_power_cmd(unsigned char *init_table, int flag)
{
	int cmd_size;
	int ret = 0;

	cmd_size = ext_config->cmd_size;
	if (cmd_size < 1) {
		EXTERR("%s: cmd_size %d is invalid\n", __func__, cmd_size);
		return -1;
	}
	if (init_table == NULL) {
		EXTERR("%s: init_table %d is NULL\n", __func__, flag);
		return -1;
	}

	if (cmd_size == LCD_EXTERN_CMD_SIZE_DYNAMIC)
		ret = lcd_extern_power_cmd_dynamic_size(init_table, flag);
	else
		ret = lcd_extern_power_cmd_fixed_size(init_table, flag);

	return ret;
}

#ifdef LCD_EXT_I2C_PORT_INIT
static int lcd_extern_change_i2c_bus(unsigned int aml_i2c_bus)
{
	int ret = 0;
	extern struct aml_i2c_platform g_aml_i2c_plat;

	if (aml_i2c_bus == LCD_EXTERN_I2C_BUS_INVALID) {
		EXTERR("%s: invalid sys i2c_bus %d\n", __func__, aml_i2c_bus);
		return -1;
	}
	g_aml_i2c_plat.master_no = aml_i2c_bus;
	ret = aml_i2c_init();

	return ret;
}
#endif

static int lcd_extern_power_ctrl(int flag)
{
#ifdef LCD_EXT_I2C_PORT_INIT
	extern struct aml_i2c_platform g_aml_i2c_plat;
	unsigned char i2c_bus;
#endif
	int ret = 0;

	/* step 1: power prepare */
#ifdef LCD_EXT_I2C_PORT_INIT
	if (ext_config->type == LCD_EXTERN_I2C) {
		aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;
		i2c_bus = aml_lcd_extern_i2c_bus_get_sys(ext_config->i2c_bus);
		lcd_extern_change_i2c_bus(i2c_bus);
	}
#endif

	/* step 2: power cmd */
	if (flag)
		ret = lcd_extern_power_cmd(ext_config->table_init_on, 1);
	else
		ret = lcd_extern_power_cmd(ext_config->table_init_off, 0);

	/* step 3: power finish */
#ifdef LCD_EXT_I2C_PORT_INIT
	if (ext_config->type == LCD_EXTERN_I2C) {
		lcd_extern_change_i2c_bus(aml_i2c_bus_tmp);
	}
#endif

	EXTPR("%s(%d: %s): %d\n",
		__func__, ext_config->index, ext_config->name, flag);
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

	ext_drv->reg_read  = lcd_extern_reg_read;
	ext_drv->reg_write = lcd_extern_reg_write;
	ext_drv->power_on  = lcd_extern_power_on;
	ext_drv->power_off = lcd_extern_power_off;

	return 0;
}

int aml_lcd_extern_default_probe(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	ext_config = ext_drv->config;
	ret = lcd_extern_driver_update(ext_drv);

	if (lcd_debug_print_flag)
		EXTPR("%s: %d\n", __func__, ret);
	return ret;
}

