/*
 * drivers/display/lcd/lcd_extern/lcd_extern.c
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

static char *dt_addr = NULL;

/* only probe one extern driver for uboot */
static struct aml_lcd_extern_driver_s *lcd_ext_driver;

struct aml_lcd_extern_driver_s *aml_lcd_extern_get_driver(void)
{
	if (lcd_ext_driver == NULL)
		EXTERR("invalid driver\n");
	return lcd_ext_driver;
}

#ifdef CONFIG_OF_LIBFDT
#ifdef CONFIG_SYS_I2C_AML
static int aml_lcd_extern_get_i2c_bus(const char *str)
{
	int i2c_bus;

	if (strncmp(str, "i2c_bus_ao", 10) == 0)
		i2c_bus = AML_I2C_MASTER_AO;
	else if (strncmp(str, "i2c_bus_a", 9) == 0)
		i2c_bus = AML_I2C_MASTER_A;
	else if (strncmp(str, "i2c_bus_b", 9) == 0)
		i2c_bus = AML_I2C_MASTER_B;
	else if (strncmp(str, "i2c_bus_c", 9) == 0)
		i2c_bus = AML_I2C_MASTER_C;
	else if (strncmp(str, "i2c_bus_d", 9) == 0)
		i2c_bus = AML_I2C_MASTER_D;
	else {
		i2c_bus = AML_I2C_MASTER_A;
		EXTERR("invalid i2c_bus: %s\n", str);
	}

	return i2c_bus;
}
#endif

char *aml_lcd_extern_get_dt_prop(int nodeoffset, char *propname)
{
	char *propdata;

	propdata = (char *)fdt_getprop(dt_addr, nodeoffset, propname, NULL);
	return propdata;
}

int aml_lcd_extern_get_dt_child(int index)
{
	int nodeoffset;
	char chlid_node[30];
	char *propdata;

	sprintf(chlid_node, "/lcd_extern/extern_%d", index);
	nodeoffset = fdt_path_offset(dt_addr, chlid_node);
	if (nodeoffset < 0) {
		EXTERR("dts: not find  node %s\n", chlid_node);
		return nodeoffset;
	}

	propdata = (char *)fdt_getprop(dt_addr, nodeoffset, "index", NULL);
	if (propdata == NULL) {
		EXTERR("get index failed, exit\n");
		return -1;
	} else {
		if (be32_to_cpup((u32*)propdata) != index) {
			EXTERR("index not match, exit\n");
			return -1;
		}
	}
	return nodeoffset;
}

static int aml_lcd_extern_get_dt_config(char *dtaddr, int index, struct lcd_extern_config_s *extconf)
{
	int val;
	int nodeoffset;
	char *propdata;
	const char *str;

	nodeoffset = aml_lcd_extern_get_dt_child(index);
	if (nodeoffset < 0)
		return -1;

	propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "status", NULL);
	if (propdata == NULL) {
		EXTERR("get status failed, default to disabled\n");
		extconf->status = 0;
	} else {
		if (strncmp(propdata, "okay", 2) == 0)
			extconf->status = 1;
		else
			extconf->status = 0;
	}
	if (extconf->status == 0) {
		EXTERR("driver status is disabled, exit\n");
		return -1;
	}

	propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "index", NULL);
	if (propdata == NULL) {
		extconf->index = LCD_EXTERN_INDEX_INVALID;
		EXTERR("get index failed, exit\n");
		return -1;
	} else {
		extconf->index = be32_to_cpup((u32*)propdata);
	}

	propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "extern_name", NULL);
	if (propdata == NULL) {
		str = "invalid_name";
		strcpy(extconf->name, str);
		EXTERR("get extern_name failed\n");
	} else {
		memset(extconf->name, 0, LCD_EXTERN_NAME_LEN_MAX);
		strcpy(extconf->name, propdata);
	}
	EXTPR("load config in dtb: %s[%d]\n", extconf->name, extconf->index);

	propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "type", NULL);
	if (propdata == NULL) {
		extconf->type = LCD_EXTERN_MAX;
		EXTERR("get type failed, exit\n");
		return -1;
	} else {
		extconf->type = be32_to_cpup((u32*)propdata);
	}
	if (lcd_debug_print_flag)
		EXTPR("%s: type = %d\n", extconf->name, extconf->type);

	switch (extconf->type) {
	case LCD_EXTERN_I2C:
#ifdef CONFIG_SYS_I2C_AML
		propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "i2c_address", NULL);
		if (propdata == NULL) {
			EXTERR("get %s i2c_address failed, exit\n", extconf->name);
			extconf->i2c_addr = 0;
			return -1;
		} else {
			extconf->i2c_addr = be32_to_cpup((u32*)propdata);
		}
		if (lcd_debug_print_flag)
			EXTPR("%s i2c_address=0x%02x\n", extconf->name, extconf->i2c_addr);

		propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "i2c_bus", NULL);
		if (propdata == NULL) {
			EXTERR("get %s i2c_bus failed, exit\n", extconf->name);
			extconf->i2c_bus = AML_I2C_MASTER_A;
			return -1;
		} else {
			extconf->i2c_bus = aml_lcd_extern_get_i2c_bus(propdata);
		}
		if (lcd_debug_print_flag)
			EXTPR("%s i2c_bus=%s[%d]\n", extconf->name, propdata, extconf->i2c_bus);
#else
		EXTERR("system has no i2c support\n");
#endif
		break;
	case LCD_EXTERN_SPI:
		propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "gpio_spi_cs", NULL);
		if (propdata == NULL) {
			EXTERR("get %s gpio_spi_cs failed, exit\n", extconf->name);
			extconf->spi_cs = -1;
			return -1;
		} else {
			val = aml_lcd_gpio_name_map_num(propdata);
			if (val > 0) {
				extconf->spi_cs = val;
				if (lcd_debug_print_flag)
					EXTPR("spi_cs gpio = %s(%d)\n", propdata, extconf->spi_cs);
			} else {
				extconf->spi_cs = LCD_GPIO_MAX;
			}
		}

		propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "gpio_spi_clk", NULL);
		if (propdata == NULL) {
			EXTERR("get %s gpio_spi_clk failed, exit\n", extconf->name);
			extconf->spi_clk = -1;
			return -1;
		} else {
			val = aml_lcd_gpio_name_map_num(propdata);
			if (val > 0) {
				extconf->spi_clk = val;
				if (lcd_debug_print_flag)
					EXTPR("spi_clk gpio = %s(%d)\n", propdata, extconf->spi_clk);
			} else {
				extconf->spi_clk = LCD_GPIO_MAX;
			}
		}

		propdata = (char *)fdt_getprop(dtaddr, nodeoffset, "gpio_spi_data", NULL);
		if (propdata == NULL) {
			EXTERR("get %s gpio_spi_data failed, exit\n", extconf->name);
			extconf->spi_data = -1;
			return -1;
		} else {
			val = aml_lcd_gpio_name_map_num(propdata);
			if (val > 0) {
				extconf->spi_data = val;
				if (lcd_debug_print_flag)
					EXTPR("spi_data gpio = %s(%d)\n", propdata, extconf->spi_data);
			} else {
				extconf->spi_data = LCD_GPIO_MAX;
			}
		}
		break;
	case LCD_EXTERN_MIPI:
		break;
	default:
		break;
	}

	return 0;
}
#endif

#ifdef CONFIG_SYS_I2C_AML
static int aml_lcd_extern_add_i2c(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	if (strcmp(ext_drv->config.name, "i2c_T5800Q") == 0) {
#ifdef CONFIG_AML_LCD_EXTERN_I2C_T5800Q
		ret = aml_lcd_extern_i2c_T5800Q_probe(ext_drv);
#endif
	} else if (strcmp(ext_drv->config.name, "i2c_tc101") == 0) {
#ifdef CONFIG_AML_LCD_EXTERN_I2C_TC101
		ret = aml_lcd_extern_i2c_tc101_probe(ext_drv);
#endif
	} else if (strcmp(ext_drv->config.name, "i2c_anx6345") == 0) {
#ifdef CONFIG_AML_LCD_EXTERN_I2C_ANX6345
		ret = aml_lcd_extern_i2c_anx6345_probe(ext_drv);
#endif
	} else {
		EXTERR("invalid driver name: %s\n", ext_drv->config.name);
		ret = -1;
	}
	return ret;
}
#endif

static int aml_lcd_extern_add_spi(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	if (strcmp(ext_drv->config.name, "spi_LD070WS2") == 0) {
#ifdef CONFIG_AML_LCD_EXTERN_SPI_LD070WS2
		ret = aml_lcd_extern_spi_LD070WS2_probe(ext_drv);
#endif
	} else {
		EXTERR("invalid driver name: %s\n", ext_drv->config.name);
		ret = -1;
	}
	return ret;
}

static int aml_lcd_extern_add_mipi(struct aml_lcd_extern_driver_s *ext_drv)
{
	int ret = 0;

	if (strcmp(ext_drv->config.name, "mipi_N070ICN") == 0) {
#ifdef CONFIG_AML_LCD_EXTERN_MIPI_N070ICN
		ret = aml_lcd_extern_mipi_N070ICN_probe(ext_drv);
#endif
	} else if (strcmp(ext_drv->config.name, "mipi_KD080D13") == 0) {
#ifdef CONFIG_AML_LCD_EXTERN_MIPI_KD080D13
		ret = aml_lcd_extern_mipi_KD080D13_probe(ext_drv);
#endif
	} else {
		EXTERR("invalid driver name: %s\n", ext_drv->config.name);
		ret = -1;
	}
	return ret;
}

static int aml_lcd_extern_add_invalid(struct aml_lcd_extern_driver_s *ext_drv)
{
	return -1;
}

static int aml_lcd_extern_add_driver(struct lcd_extern_config_s *extconf)
{
	struct aml_lcd_extern_driver_s *ext_drv;
	int ret = -1;

	lcd_ext_driver = (struct aml_lcd_extern_driver_s *)malloc(sizeof(struct aml_lcd_extern_driver_s));
	if (lcd_ext_driver == NULL) {
		EXTERR("failed to alloc driver %s[%d], not enough memory\n", extconf->name, extconf->index);
		return -1;
	}
	if (extconf->status == 0) {
		free(lcd_ext_driver);
		lcd_ext_driver = NULL;
		EXTERR("driver is disabled\n");
		return -1;
	}

	ext_drv = lcd_ext_driver;
	/* fill config parameters */
	ext_drv->config.index = extconf->index;
	strcpy(ext_drv->config.name, extconf->name);
	ext_drv->config.type = extconf->type;

	/* fill config parameters by different type */
	switch (ext_drv->config.type) {
	case LCD_EXTERN_I2C:
#ifdef CONFIG_SYS_I2C_AML
		ext_drv->config.i2c_addr = extconf->i2c_addr;
		ext_drv->config.i2c_bus = extconf->i2c_bus;
		ret = aml_lcd_extern_add_i2c(ext_drv);
#else
		EXTERR("system has no i2c support\n");
#endif
		break;
	case LCD_EXTERN_SPI:
		ext_drv->config.spi_cs = extconf->spi_cs;
		ext_drv->config.spi_clk = extconf->spi_clk;
		ext_drv->config.spi_data = extconf->spi_data;
		ret = aml_lcd_extern_add_spi(ext_drv);
		break;
	case LCD_EXTERN_MIPI:
		ret = aml_lcd_extern_add_mipi(ext_drv);
		break;
	default:
		ret = aml_lcd_extern_add_invalid(ext_drv);
		EXTERR("don't support type %d\n", ext_drv->config.type);
		break;
	}
	if (ret) {
		EXTERR("add driver failed\n");
		free(lcd_ext_driver);
		lcd_ext_driver = NULL;
		return -1;
	}
	EXTPR("add driver %s(%d)\n", ext_drv->config.name, ext_drv->config.index);
	return ret;
}

static int aml_lcd_extern_add_driver_default(int index)
{
	int drv_index;
	int ret = -1;
	struct aml_lcd_extern_driver_s *ext_drv;

	lcd_ext_driver = (struct aml_lcd_extern_driver_s *)malloc(sizeof(struct aml_lcd_extern_driver_s));
	if (lcd_ext_driver == NULL) {
		EXTERR("failed to alloc driver %d, not enough memory\n", index);
		return -1;
	}

	ext_drv = lcd_ext_driver;
	drv_index = LCD_EXTERN_INDEX_INVALID;
	if (ext_drv == NULL)
		goto add_driver_default_end;
	if (drv_index > LCD_EXTERN_INDEX_INVALID)
		goto add_driver_default_end;
#ifdef CONFIG_SYS_I2C_AML
#ifdef CONFIG_AML_LCD_EXTERN_I2C_T5800Q
	drv_index = aml_lcd_extern_i2c_T5800Q_get_default_index();
	if (drv_index == index) {
		ret = aml_lcd_extern_i2c_T5800Q_probe(ext_drv);
		goto add_driver_default_end;
	}
#endif
#ifdef CONFIG_AML_LCD_EXTERN_I2C_TC101
	drv_index = aml_lcd_extern_i2c_tc101_get_default_index();
	if (drv_index == index) {
		ret = aml_lcd_extern_i2c_tc101_probe(ext_drv);
		goto add_driver_default_end;
	}
#endif
#ifdef CONFIG_AML_LCD_EXTERN_I2C_ANX6345
	drv_index = aml_lcd_extern_i2c_anx6345_get_default_index();
	if (drv_index == index) {
		ret = aml_lcd_extern_i2c_anx6345_probe(ext_drv);
		goto add_driver_default_end;
	}
#endif
#endif
#ifdef CONFIG_AML_LCD_EXTERN_SPI_LD070WS2
	drv_index = aml_lcd_extern_spi_LD070WS2_get_default_index();
	if (drv_index == index) {
		ret = aml_lcd_extern_spi_LD070WS2_probe(ext_drv);
		goto add_driver_default_end;
	}
#endif
#ifdef CONFIG_AML_LCD_EXTERN_MIPI_N070ICN
	drv_index = aml_lcd_extern_mipi_N070ICN_get_default_index();
	if (drv_index == index) {
		ret = aml_lcd_extern_mipi_N070ICN_probe(ext_drv);
		goto add_driver_default_end;
	}
#endif
#ifdef CONFIG_AML_LCD_EXTERN_MIPI_KD080D13
	drv_index = aml_lcd_extern_mipi_KD080D13_get_default_index();
	if (drv_index == index) {
		ret = aml_lcd_extern_mipi_KD080D13_probe(ext_drv);
		goto add_driver_default_end;
	}
#endif

add_driver_default_end:
	if (ret) {
		EXTERR("add driver failed\n");
		free(lcd_ext_driver);
		lcd_ext_driver = NULL;
		return -1;
	}
	EXTPR("add default driver %d\n", index);
	return ret;
}

int aml_lcd_extern_probe(char *dtaddr, int index)
{
	struct lcd_extern_config_s ext_config;
	int ret, dt_ready = 0;

	if (index >= LCD_EXTERN_INDEX_INVALID) {
		EXTERR("invalid index, %s exit\n", __func__);
		return -1;
	}

	dt_addr = NULL;
	ext_config.index = LCD_EXTERN_INDEX_INVALID;
	ext_config.type = LCD_EXTERN_MAX;
#ifdef CONFIG_OF_LIBFDT
	if (dtaddr)
		dt_addr = dtaddr;
	if (fdt_check_header(dtaddr) < 0) {
		EXTERR("check dts: %s, use default parameters\n",
			fdt_strerror(fdt_check_header(dt_addr)));
	} else {
		ret = aml_lcd_extern_get_dt_config(dtaddr, index, &ext_config);
		if (ret == 0)
			dt_ready = 1;
	}
#endif
	if (dt_ready)
		ret = aml_lcd_extern_add_driver(&ext_config);
	else
		ret = aml_lcd_extern_add_driver_default(index);

	EXTPR("%s %s\n", __func__, (ret ? "failed" : "ok"));
	return ret;
}

int aml_lcd_extern_remove(void)
{
	if (lcd_ext_driver)
		free(lcd_ext_driver);
	lcd_ext_driver = NULL;
	return 0;
}

