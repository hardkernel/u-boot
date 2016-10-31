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
#endif
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_lcd_extern.h>
#include "lcd_extern.h"
#include "../aml_lcd_common.h"
#include "../aml_lcd_reg.h"

//#define LCD_EXT_I2C_PORT_INIT     /* no need init i2c port here */
//#define LCD_EXT_DEBUG_INFO

#define LCD_EXTERN_INDEX          0
#define LCD_EXTERN_NAME           "ext_default"

#define LCD_EXTERN_TYPE           LCD_EXTERN_I2C

#define LCD_EXTERN_I2C_ADDR       (0x1c) //7bit address
#define LCD_EXTERN_I2C_ADDR2      (0xff) //7bit address
#define LCD_EXTERN_I2C_BUS        AML_I2C_MASTER_C

#define SPI_GPIO_CS               0  //index
#define SPI_GPIO_CLK              1  //index
#define SPI_GPIO_DATA             2  //index
#define SPI_CLK_FREQ              10000 //Hz
#define SPI_CLK_POL               1

#ifdef CONFIG_SYS_I2C_AML
#ifdef LCD_EXT_I2C_PORT_INIT
static unsigned aml_i2c_bus_tmp;
#endif
#endif
static struct lcd_extern_config_s *ext_config;

#define LCD_EXTERN_CMD_SIZE        9
static unsigned char init_on_table[] = {
	0x00, 0x20, 0x01, 0x02, 0x00, 0x40, 0xFF, 0x00, 0x00,
	0x00, 0x80, 0x02, 0x00, 0x40, 0x62, 0x51, 0x73, 0x00,
	0x00, 0x61, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0xC1, 0x05, 0x0F, 0x00, 0x08, 0x70, 0x00, 0x00,
	0x00, 0x13, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x3D, 0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0xED, 0x0D, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
	0x00, 0x23, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0A,  /* delay 10ms */
	0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  /* ending */
};

static unsigned char init_off_table[] = {
	0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  /* ending */
};

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
	for (i = 0; i < len; i++) {
		printf(" 0x%02x", buff[i]);
	}
	printf(" [addr 0x%02x]\n", i2caddr);
#endif

	ret = aml_i2c_xfer(msg, 1);
	//ret = aml_i2c_xfer_slow(msg, 1);
	if (ret < 0)
		EXTERR("i2c write failed [addr 0x%02x]\n", i2caddr);

	return ret;
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

static int lcd_extern_power_cmd(unsigned char *init_table)
{
	int i = 0, gpio, len;
	int ret = 0;

	len = ext_config->cmd_size;
	if (len < 1) {
		EXTERR("%s: cmd_size %d is invalid\n", __func__, len);
		return -1;
	}
	switch (ext_config->type) {
#ifdef CONFIG_SYS_I2C_AML
	case LCD_EXTERN_I2C:
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
		break;
#endif
	case LCD_EXTERN_SPI:
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
				ret = lcd_extern_spi_write(&init_table[i+1], (len-2));
			} else {
				EXTERR("%s(%d: %s): pwoer_type %d is invalid\n",
					__func__, ext_config->index,
					ext_config->name, ext_config->type);
			}
			if (init_table[i+len-1] > 0)
				mdelay(init_table[i+len-1]);
			i += len;
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

#ifdef CONFIG_SYS_I2C_AML
#ifdef LCD_EXT_I2C_PORT_INIT
static int lcd_extern_change_i2c_bus(unsigned aml_i2c_bus)
{
	int ret = 0;
	extern struct aml_i2c_platform g_aml_i2c_plat;

	g_aml_i2c_plat.master_no = aml_i2c_bus;
	ret = aml_i2c_init();

	return ret;
}
#endif
#endif

static int lcd_extern_power_ctrl(int flag)
{
#ifdef CONFIG_SYS_I2C_AML
#ifdef LCD_EXT_I2C_PORT_INIT
	extern struct aml_i2c_platform g_aml_i2c_plat;
	aml_i2c_bus_tmp = g_aml_i2c_plat.master_no;
#endif
#endif
	int ret = 0;

	/* step 1: power prepare */
#ifdef CONFIG_SYS_I2C_AML
#ifdef LCD_EXT_I2C_PORT_INIT
	lcd_extern_change_i2c_bus(ext_config->i2c_bus);
#endif
#endif

	/* step 2: power cmd */
	if (flag)
		ret = lcd_extern_power_cmd(ext_config->table_init_on);
	else
		ret = lcd_extern_power_cmd(ext_config->table_init_off);

	/* step 3: power finish */
#ifdef CONFIG_SYS_I2C_AML
#ifdef LCD_EXT_I2C_PORT_INIT
	lcd_extern_change_i2c_bus(aml_i2c_bus_tmp);
#endif
#endif

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

	if (ext_drv->config.type == LCD_EXTERN_MAX) { //default for no dt
		ext_drv->config.index = LCD_EXTERN_INDEX;
		ext_drv->config.type = LCD_EXTERN_TYPE;
		strcpy(ext_drv->config.name, LCD_EXTERN_NAME);
		ext_drv->config.cmd_size = LCD_EXTERN_CMD_SIZE;
		switch (ext_drv->config.type) {
		case LCD_EXTERN_I2C:
			ext_drv->config.i2c_addr = LCD_EXTERN_I2C_ADDR;
			ext_drv->config.i2c_addr2 = LCD_EXTERN_I2C_ADDR2;
			ext_drv->config.i2c_bus = LCD_EXTERN_I2C_BUS;
			break;
		case LCD_EXTERN_SPI:
			ext_drv->config.spi_gpio_cs = SPI_GPIO_CS;
			ext_drv->config.spi_gpio_clk = SPI_GPIO_CLK;
			ext_drv->config.spi_gpio_data = SPI_GPIO_DATA;
			ext_drv->config.spi_clk_freq = SPI_CLK_FREQ;
			ext_drv->config.spi_clk_pol = SPI_CLK_POL;
			break;
		default:
			break;
		}
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

int aml_lcd_extern_default_probe(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	ext_config = &ext_drv->config;
	ret = lcd_extern_driver_update(ext_drv);

	if (lcd_debug_print_flag)
		EXTPR("%s: %d\n", __func__, ret);
	return ret;
}

