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
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_bl_extern.h>
#include "bl_extern.h"
#include "../aml_lcd_common.h"

static unsigned int bl_extern_status;
static unsigned int bl_extern_level;

static struct aml_bl_extern_driver_s bl_extern_driver;

static int bl_extern_set_level(unsigned int level)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();
	unsigned int level_max, level_min;
	unsigned int dim_max, dim_min;

	if (lcd_drv == NULL)
		return -1;

	bl_extern_level = level;
	if (bl_extern_status == 0)
		return 0;

	level_max = lcd_drv->bl_config->level_max;
	level_min = lcd_drv->bl_config->level_min;
	dim_max = bl_extern->config->dim_max;
	dim_min = bl_extern->config->dim_min;
	level = dim_min - ((level - level_min) * (dim_min - dim_max)) /
			(level_max - level_min);

	if (bl_extern_driver.device_bri_update)
		bl_extern_driver.device_bri_update(level);

	return 0;
}

static int bl_extern_power_on(void)
{
	int ret = 0;

	BLEX("%s\n", __func__);

	if (bl_extern_driver.device_power_on) {
		bl_extern_driver.device_power_on();
		bl_extern_status = 1;
	}

	/* restore bl level */
	if (bl_extern_level > 0)
		bl_extern_set_level(bl_extern_level);

	return ret;
}
static int bl_extern_power_off(void)
{
	int ret = 0;

	BLEX("%s\n", __func__);

	bl_extern_status = 0;
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

static void aml_bl_extern_init_table_dynamic_size_print(
		struct bl_extern_config_s *econf, int flag)
{
	int i, j, max_len;
	unsigned char cmd_size;
	unsigned char *table;

	if (flag) {
		printf("power on:\n");
		table = econf->init_on;
		max_len = econf->init_on_cnt;
	} else {
		printf("power off:\n");
		table = econf->init_off;
		max_len = econf->init_off_cnt;
	}
	if (table == NULL) {
		BLEXERR("init_table %d is NULL\n", flag);
		return;
	}

	i = 0;
	while ((i + 1) < max_len) {
		if (table[i] == LCD_EXT_CMD_TYPE_END) {
			printf("  0x%02x,%d,\n", table[i], table[i+1]);
			break;
		}
		cmd_size = table[i+1];
		printf("  0x%02x,%d,", table[i], cmd_size);
		if (cmd_size == 0)
			goto init_table_dynamic_print_next;
		if (i + 2 + cmd_size > max_len) {
			printf("cmd_size out of support\n");
			break;
		}

		if (table[i] == LCD_EXT_CMD_TYPE_DELAY) {
			for (j = 0; j < cmd_size; j++)
				printf("%d,", table[i+2+j]);
		} else if (table[i] == LCD_EXT_CMD_TYPE_CMD) {
			for (j = 0; j < cmd_size; j++)
				printf("0x%02x,", table[i+2+j]);
		} else if (table[i] == LCD_EXT_CMD_TYPE_CMD_DELAY) {
			for (j = 0; j < (cmd_size - 1); j++)
				printf("0x%02x,", table[i+2+j]);
			printf("%d,", table[i+cmd_size+1]);
		} else {
			for (j = 0; j < cmd_size; j++)
				printf("0x%02x,", table[i+2+j]);
		}
init_table_dynamic_print_next:
		printf("\n");
		i += (cmd_size + 2);
	}
}

static void aml_bl_extern_init_table_fixed_size_print(
		struct bl_extern_config_s *econf, int flag)
{
	int i, j, max_len;
	unsigned char cmd_size;
	unsigned char *table;

	cmd_size = econf->cmd_size;
	if (flag) {
		printf("power on:\n");
		table = econf->init_on;
		max_len = econf->init_on_cnt;
	} else {
		printf("power off:\n");
		table = econf->init_off;
		max_len = econf->init_off_cnt;
	}
	if (table == NULL) {
		BLEXERR("init_table %d is NULL\n", flag);
		return;
	}

	i = 0;
	while ((i + cmd_size) <= max_len) {
		printf("  ");
		for (j = 0; j < cmd_size; j++)
			printf("0x%02x,", table[i+j]);
		printf("\n");

		if (table[i] == LCD_EXT_CMD_TYPE_END)
			break;
		i += cmd_size;
	}
}

static void bl_extern_config_print(void)
{
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();

	BLEX("%s:\n", __func__);
	printf("index:          %d\n"
		"name:          %s\n",
		bl_extern->config->index,
		bl_extern->config->name);
	switch (bl_extern->config->type) {
	case BL_EXTERN_I2C:
		printf("type:          i2c(%d)\n"
			"i2c_addr:      0x%02x\n"
			"i2c_bus:       %d\n"
			"dim_min:       %d\n"
			"dim_max:       %d\n",
			bl_extern->config->type,
			bl_extern->config->i2c_addr,
			bl_extern->config->i2c_bus,
			bl_extern->config->dim_min,
			bl_extern->config->dim_max);
		if (bl_extern->config->cmd_size == 0)
			break;
		printf("init_loaded           = %d\n"
			"cmd_size              = %d\n"
			"init_on_cnt           = %d\n"
			"init_off_cnt          = %d\n",
			bl_extern->config->init_loaded,
			bl_extern->config->cmd_size,
			bl_extern->config->init_on_cnt,
			bl_extern->config->init_off_cnt);
		if (bl_extern->config->cmd_size == LCD_EXT_CMD_SIZE_DYNAMIC) {
			aml_bl_extern_init_table_dynamic_size_print(
				bl_extern->config, 1);
			aml_bl_extern_init_table_dynamic_size_print(
				bl_extern->config, 0);
		} else {
			aml_bl_extern_init_table_fixed_size_print(
				bl_extern->config, 1);
			aml_bl_extern_init_table_fixed_size_print(
				bl_extern->config, 0);
		}
		break;
	case BL_EXTERN_SPI:
		printf("type:          spi(%d)\n"
			"dim_min:       %d\n"
			"dim_max:       %d\n",
			bl_extern->config->type,
			bl_extern->config->dim_min,
			bl_extern->config->dim_max);
		if (bl_extern->config->cmd_size == 0)
			break;
		printf("init_loaded           = %d\n"
			"cmd_size              = %d\n"
			"init_on_cnt           = %d\n"
			"init_off_cnt          = %d\n",
			bl_extern->config->init_loaded,
			bl_extern->config->cmd_size,
			bl_extern->config->init_on_cnt,
			bl_extern->config->init_off_cnt);
		if (bl_extern->config->cmd_size == LCD_EXT_CMD_SIZE_DYNAMIC) {
			aml_bl_extern_init_table_dynamic_size_print(
				bl_extern->config, 1);
			aml_bl_extern_init_table_dynamic_size_print(
				bl_extern->config, 0);
		} else {
			aml_bl_extern_init_table_fixed_size_print(
				bl_extern->config, 1);
			aml_bl_extern_init_table_fixed_size_print(
				bl_extern->config, 0);
		}
		break;
	case BL_EXTERN_MIPI:
		printf("type:          mipi(%d)\n"
			"dim_min:       %d\n"
			"dim_max:       %d\n",
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
		i2c_bus = BL_EXTERN_I2C_BUS_4;
	else if (strncmp(str, "i2c_bus_a", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_0;
	else if (strncmp(str, "i2c_bus_b", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_1;
	else if (strncmp(str, "i2c_bus_c", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_2;
	else if (strncmp(str, "i2c_bus_d", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_3;
	else if (strncmp(str, "i2c_bus_0", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_0;
	else if (strncmp(str, "i2c_bus_1", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_1;
	else if (strncmp(str, "i2c_bus_2", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_2;
	else if (strncmp(str, "i2c_bus_3", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_3;
	else if (strncmp(str, "i2c_bus_4", 9) == 0)
		i2c_bus = BL_EXTERN_I2C_BUS_4;
	else {
		i2c_bus = BL_EXTERN_I2C_BUS_MAX;
		BLEXERR("invalid i2c_bus: %s\n", str);
	}

	return i2c_bus;
}

static int aml_bl_extern_init_table_dynamic_size_load_dts(char *dtaddr,
		int nodeoffset, struct bl_extern_config_s *extconf, int flag)
{
	unsigned char cmd_size, type;
	int i = 0, j, max_len;
	unsigned char *table;
	char propname[20];
	char *propdata;

	if (flag) {
		table = extconf->init_on;
		max_len = BL_EXTERN_INIT_ON_MAX;
		sprintf(propname, "init_on");
	} else {
		table = extconf->init_off;
		max_len = BL_EXTERN_INIT_OFF_MAX;
		sprintf(propname, "init_off");
	}
	if (table == NULL) {
		BLEX("%s init_table is null\n", propname);
		return 0;
	}

	propdata = (char *)fdt_getprop(dtaddr, nodeoffset, propname, NULL);
	if (propdata == NULL) {
		BLEXERR("%s: get %s failed\n", extconf->name, propname);
		table[0] = LCD_EXT_CMD_TYPE_END;
		table[1] = 0;
		return -1;
	}

	while ((i + 1) < max_len) {
		table[i] = (unsigned char)(be32_to_cpup((((u32*)propdata)+i)));
		table[i+1] = (unsigned char)(be32_to_cpup((((u32*)propdata)+i+1)));
		type = table[i];
		cmd_size = table[i+1];
		if (type == LCD_EXT_CMD_TYPE_END)
			break;
		if (cmd_size == 0)
			goto init_table_dynamic_dts_next;
		if ((i + 2 + cmd_size) > max_len) {
			BLEXERR("%s: %s cmd_size out of support\n", extconf->name, propname);
			table[i] = LCD_EXT_CMD_TYPE_END;
			table[i+1] = 0;
			return -1;
		}
		for (j = 0; j < cmd_size; j++)
			table[i+2+j] = (unsigned char)(be32_to_cpup((((u32*)propdata)+i+2+j)));

init_table_dynamic_dts_next:
		i += (cmd_size + 2);
	}
	if (flag)
		extconf->init_on_cnt = i + 2;
	else
		extconf->init_off_cnt = i + 2;

	return 0;
}

static int aml_bl_extern_init_table_fixed_size_load_dts(char *dtaddr,
		int nodeoffset, struct bl_extern_config_s *extconf, int flag)
{
	unsigned char cmd_size;
	int i = 0, j, max_len;
	unsigned char *table;
	char propname[20];
	char *propdata;

	cmd_size = extconf->cmd_size;
	if (flag) {
		table = extconf->init_on;
		max_len = BL_EXTERN_INIT_ON_MAX;
		sprintf(propname, "init_on");
	} else {
		table = extconf->init_off;
		max_len = BL_EXTERN_INIT_OFF_MAX;
		sprintf(propname, "init_off");
	}
	if (table == NULL) {
		BLEX("%s init_table is null\n", propname);
		return 0;
	}

	propdata = (char *)fdt_getprop(dtaddr, nodeoffset, propname, NULL);
	if (propdata == NULL) {
		BLEXERR("%s: get %s failed\n", extconf->name, propname);
		table[0] = LCD_EXT_CMD_TYPE_END;
		table[1] = 0;
		return -1;
	}

	while (i < max_len) {
		if ((i + cmd_size) > max_len) {
			BLEXERR("%s: %s cmd_size out of support\n", extconf->name, propname);
			table[i] = LCD_EXT_CMD_TYPE_END;
			return -1;
		}
		for (j = 0; j < cmd_size; j++)
			table[i+j] = (unsigned char)(be32_to_cpup((((u32*)propdata)+i+j)));

		if (table[i] == LCD_EXT_CMD_TYPE_END)
			break;

		i += cmd_size;
	}
	if (flag)
		extconf->init_on_cnt = i + cmd_size;
	else
		extconf->init_off_cnt = i + cmd_size;

	return 0;
}

static int bl_extern_config_from_dts(char *dtaddr, int index)
{
	int ret = 0;
	int parent_offset, child_offset;
	char propname[30];
	char *propdata;
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();
	unsigned char bl_ext_i2c_bus = BL_EXTERN_I2C_BUS_MAX;

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
		bl_ext_i2c_bus = BL_EXTERN_I2C_BUS_MAX;
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
		if (bl_ext_i2c_bus == BL_EXTERN_I2C_BUS_MAX) { /* compatible for kernel3.14 */
			propdata = (char *)fdt_getprop(dtaddr, child_offset, "i2c_bus", NULL);
			if (propdata == NULL) {
				BLEXERR("get %s i2c_bus failed, exit\n", bl_extern->config->name);
				bl_extern->config->i2c_bus = BL_EXTERN_I2C_BUS_MAX;
				return -1;
			} else {
				bl_extern->config->i2c_bus = bl_extern_get_i2c_bus_str(propdata);
			}
		} else {
			bl_extern->config->i2c_bus = bl_ext_i2c_bus;
		}
		if (lcd_debug_print_flag)
			aml_bl_extern_i2c_bus_print(bl_extern->config->i2c_bus);

		propdata = (char *)fdt_getprop(dtaddr, child_offset, "cmd_size", NULL);
		if (propdata == NULL) {
			BLEX("%s: no cmd_size\n", bl_extern->config->name);
			bl_extern->config->cmd_size = 0;
		} else {
			bl_extern->config->cmd_size = (unsigned char)(be32_to_cpup((u32*)propdata));
		}
		if (lcd_debug_print_flag)
			BLEX("%s: cmd_size=%d\n", bl_extern->config->name, bl_extern->config->cmd_size);
		if (bl_extern->config->cmd_size == 0)
			break;

		if (bl_extern->config->cmd_size == LCD_EXT_CMD_SIZE_DYNAMIC) {
			ret = aml_bl_extern_init_table_dynamic_size_load_dts(
				dtaddr, child_offset, bl_extern->config, 1);
			if (ret)
				break;
			ret = aml_bl_extern_init_table_dynamic_size_load_dts(
				dtaddr, child_offset, bl_extern->config, 0);
		} else {
			ret = aml_bl_extern_init_table_fixed_size_load_dts(
				dtaddr, child_offset, bl_extern->config, 1);
			if (ret)
				break;
			ret = aml_bl_extern_init_table_fixed_size_load_dts(
				dtaddr, child_offset, bl_extern->config, 0);
		}
		if (ret == 0)
			bl_extern->config->init_loaded = 1;
		break;
	case BL_EXTERN_SPI:
		propdata = (char *)fdt_getprop(dtaddr, child_offset, "cmd_size", NULL);
		if (propdata == NULL) {
			BLEX("%s: no cmd_size\n", bl_extern->config->name);
			bl_extern->config->cmd_size = 0;
		} else {
			bl_extern->config->cmd_size = (unsigned char)(be32_to_cpup((u32*)propdata));
		}
		if (lcd_debug_print_flag)
			BLEX("%s: cmd_size=%d\n", bl_extern->config->name, bl_extern->config->cmd_size);
		if (bl_extern->config->cmd_size == 0)
			break;

		if (bl_extern->config->cmd_size == LCD_EXT_CMD_SIZE_DYNAMIC) {
			ret = aml_bl_extern_init_table_dynamic_size_load_dts(
				dtaddr, child_offset, bl_extern->config, 1);
			if (ret)
				break;
			ret = aml_bl_extern_init_table_dynamic_size_load_dts(
				dtaddr, child_offset, bl_extern->config, 0);
		} else {
			ret = aml_bl_extern_init_table_fixed_size_load_dts(
				dtaddr, child_offset, bl_extern->config, 1);
			if (ret)
				break;
			ret = aml_bl_extern_init_table_fixed_size_load_dts(
				dtaddr, child_offset, bl_extern->config, 0);
		}
		if (ret == 0)
			bl_extern->config->init_loaded = 1;
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
	} else if (strcmp(extconf->name, "mipi_lt070me05") == 0) {
#ifdef CONFIG_AML_BL_EXTERN_MIPI_IT070ME05
		ret = mipi_lt070me05_probe();
#endif
	} else {
		BLEXERR("invalid device name: %s\n", extconf->name);
		ret = -1;
	}

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

	bl_extern_status = 0;
	bl_extern_level = 0;
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

