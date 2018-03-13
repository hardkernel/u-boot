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
#ifdef CONFIG_SYS_I2C_AML
#include <aml_i2c.h>
#endif
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_lcd_extern.h>
#include "lcd_extern.h"
#include "../aml_lcd_common.h"
#include "../aml_lcd_reg.h"

//#define LCD_EXT_I2C_PORT_INIT     /* no need init i2c port here */
//#define LCD_EXT_DEBUG_INFO

#ifdef CONFIG_SYS_I2C_AML
#define LCD_EXTERN_INDEX		1
#define LCD_EXTERN_NAME			"i2c_RT6947"
#define LCD_EXTERN_TYPE			LCD_EXTERN_I2C

#define LCD_EXTERN_I2C_ADDR		(0x66 >> 1) //7bit address
#define LCD_EXTERN_I2C_BUS		AML_I2C_MASTER_D

//#define GAMMA_EEPROM_WRITE

#ifdef LCD_EXT_I2C_PORT_INIT
static unsigned aml_i2c_bus_tmp;
#endif
static struct lcd_extern_config_s *ext_config;

static unsigned char gamma_init[] = {
	0x00, 90,
	0x00,
	0xA2, 0xD0, 0x80, 0x00, 0x10, 0x10, 0x59, 0x19, 0x4B, 0x0B,
	0x3A, 0x13, 0x27, 0x2F, 0xC2, 0xC9, 0x29, 0xD2, 0x7A, 0x20,
	0xA1, 0xC0, 0x15, 0x01, 0x36, 0x10, 0x10, 0xCB, 0x0A, 0x10,
	0x2C, 0x1C, 0xA0, 0xFF, 0x00, 0x00, 0x0B, 0x02, 0x00, 0x00,
	0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x10,
	0x80, 0x00, 0x60, 0x00, 0x00, 0x00, 0x0D, 0x0D, 0x20, 0x02,
	0x00, 0x20, 0x02, 0x00, 0x20, 0x02, 0x00, 0x20, 0x02, 0x00,
	0x20, 0x02, 0x00, 0x20, 0x02, 0x00, 0x20, 0x02, 0x00, 0x20,
	0x00, 0xFF, 0x00, 0x00, 0x0B, 0x02, 0x00, 0x00,
	0x00, /* delay */
	0xff, 0,  /* ending */
};

#ifdef GAMMA_EEPROM_WRITE
static unsigned char mtp_en[]    = {0x64,0x01};
static unsigned char eeprom_wr[] = {0xFF,0x80};
#endif

static int lcd_extern_i2c_write(unsigned int i2caddr, unsigned char *buff, unsigned int len)
{
	int ret = 0;
#ifdef LCD_EXT_DEBUG_INFO
	int i;
#endif
	struct i2c_msg msg;

	msg.addr = i2caddr;
	msg.flags = 0;
	msg.len = len;
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

#ifdef GAMMA_EEPROM_WRITE
static int lcd_extern_i2c_read(unsigned i2caddr, unsigned char reg ,unsigned char *buff, unsigned len)
{
	int ret = 0;
	struct i2c_msg msg[] = {
		{
			.addr  = i2caddr,
			.flags = 0,
			.len   = 1,
			.buf   = &reg,
		},
		{
			.addr  = i2caddr,
			.flags = I2C_M_RD,
			.len   = len,
			.buf   = buff,
		}
	};

	ret = aml_i2c_xfer(msg, 2);
	if (ret < 0)
		EXTERR("i2c read failed [addr 0x%02x]\n", i2caddr);

	return ret;
}

#endif

static int lcd_extern_power_cmd_dynamic_size(unsigned char *init_table)
{
	int i = 0, step = 0;
	unsigned char type, cmd_size;
	int ret = 0;
	int max_len = LCD_EXTERN_INIT_ON_MAX;

#ifdef CONFIG_SYS_I2C_AML
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
#endif

	return ret;
}

static int lcd_extern_power_cmd_fixed_size(unsigned char *init_table)
{
	int i = 0, step = 0;
	unsigned char type, cmd_size;
	int ret = 0;
	int max_len = LCD_EXTERN_INIT_ON_MAX;

	cmd_size = ext_config->cmd_size;
#ifdef CONFIG_SYS_I2C_AML
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
#endif

	return ret;
}

static int lcd_extern_power_cmd(unsigned char *init_table)
{
	int cmd_size;
	int ret = 0;

	cmd_size = ext_config->cmd_size;
	if (cmd_size < 1) {
		EXTERR("%s: cmd_size %d is invalid\n", __func__, cmd_size);
		return -1;
	}
	if (init_table == NULL)
		return -1;

	if (cmd_size == LCD_EXTERN_CMD_SIZE_DYNAMIC)
		ret = lcd_extern_power_cmd_dynamic_size(init_table);
	else
		ret = lcd_extern_power_cmd_fixed_size(init_table);

	return ret;
}

#ifdef LCD_EXT_I2C_PORT_INIT
static int lcd_extern_change_i2c_bus(unsigned aml_i2c_bus)
{
	int ret = 0;
	extern struct aml_i2c_platform g_aml_i2c_plat;

	if (aml_i2c_bus == LCD_EXTERN_I2C_BUS_INVALID) {
		EXTERR("%s: invalid i2c_bus\n", __func__);
		return -1;
	}
	g_aml_i2c_plat.master_no = aml_i2c_bus;
	ret = aml_i2c_init();

	return ret;
}
#endif

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

	ret = lcd_extern_i2c_read(ext_config->i2c_addr, 0x00, chk_table, len);
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
	int len = ext_config->table_init_on[1] - 2;
#endif

#ifdef LCD_EXT_I2C_PORT_INIT
	extern struct aml_i2c_platform g_aml_i2c_plat;
#endif

	lcd_extern_pinmux_set(1);
#ifdef LCD_EXT_I2C_PORT_INIT
	aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;
	lcd_extern_change_i2c_bus(ext_config->i2c_bus);
	mdelay(10);
#endif

#ifdef GAMMA_EEPROM_WRITE
	/* check gamma is init or not */
	ret = lcd_extern_init_check(len);
	if (ret) {
		EXTPR("RT6947: need init gamma and mtp write\n");
		lcd_extern_power_cmd(ext_config->table_init_on);
		/* enable mtp */
		len = sizeof(mtp_en) / sizeof(unsigned char);
		lcd_extern_i2c_write(ext_config->i2c_addr, mtp_en, len);
		/* write eeprom */
		len = sizeof(eeprom_wr) / sizeof(unsigned char);
		lcd_extern_i2c_write(ext_config->i2c_addr, eeprom_wr, len);
	}
#else
	lcd_extern_power_cmd(ext_config->table_init_on);
#endif

#ifdef LCD_EXT_I2C_PORT_INIT
	lcd_extern_change_i2c_bus(aml_i2c_bus_tmp);
#endif

	EXTPR("%s\n", __func__);
	return ret;
}

static int lcd_extern_power_off(void)
{
	int ret = 0;

	lcd_extern_pinmux_set(0);
	return ret;
}

static int lcd_extern_driver_update(struct aml_lcd_extern_driver_s *ext_drv)
{
	if (ext_drv == NULL) {
		EXTERR("%s driver is null\n", LCD_EXTERN_NAME);
		return -1;
	}

	if (ext_drv->config->type == LCD_EXTERN_MAX) { //default for no dt
		ext_drv->config->index = LCD_EXTERN_INDEX;
		ext_drv->config->type = LCD_EXTERN_TYPE;
		strcpy(ext_drv->config->name, LCD_EXTERN_NAME);
		ext_drv->config->cmd_size = LCD_EXTERN_CMD_SIZE_DYNAMIC;
		ext_drv->config->i2c_addr = LCD_EXTERN_I2C_ADDR;
		ext_drv->config->i2c_bus = LCD_EXTERN_I2C_BUS;
	}
	if (ext_drv->config->table_init_loaded == 0) {
		ext_drv->config->table_init_on = gamma_init;
		ext_drv->config->cmd_size = LCD_EXTERN_CMD_SIZE_DYNAMIC;
	}

	ext_drv->power_on  = lcd_extern_power_on;
	ext_drv->power_off = lcd_extern_power_off;

	return 0;
}

int aml_lcd_extern_i2c_RT6947_get_default_index(void)
{
	return LCD_EXTERN_INDEX;
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
#endif

