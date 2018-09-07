/*
 * include/amlogic/aml_bl_extern.h
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

#ifndef _INC_AML_BL_EXTERN_H_
#define _INC_AML_BL_EXTERN_H_

enum bl_extern_type_e {
	BL_EXTERN_I2C = 0,
	BL_EXTERN_SPI,
	BL_EXTERN_MIPI,
	BL_EXTERN_MAX,
};

#define BL_EXTERN_I2C_BUS_A          0
#define BL_EXTERN_I2C_BUS_B          1
#define BL_EXTERN_I2C_BUS_C          2
#define BL_EXTERN_I2C_BUS_D          3
#define BL_EXTERN_I2C_BUS_AO         4

#define BL_EXTERN_I2C_BUS_0          BL_EXTERN_I2C_BUS_A
#define BL_EXTERN_I2C_BUS_1          BL_EXTERN_I2C_BUS_B
#define BL_EXTERN_I2C_BUS_2          BL_EXTERN_I2C_BUS_C
#define BL_EXTERN_I2C_BUS_3          BL_EXTERN_I2C_BUS_D
#define BL_EXTERN_I2C_BUS_4          BL_EXTERN_I2C_BUS_AO
#define BL_EXTERN_I2C_BUS_MAX        5

#define BL_EXTERN_INIT_ON_MAX       200
#define BL_EXTERN_INIT_OFF_MAX      50

#define BL_EXTERN_GPIO_NUM_MAX      6
#define BL_EXTERN_INDEX_INVALID     0xff
#define BL_EXTERN_NAME_LEN_MAX      30
struct bl_extern_config_s {
	unsigned char index;
	char name[BL_EXTERN_NAME_LEN_MAX];
	enum bl_extern_type_e type;
	unsigned char i2c_addr;
	unsigned char i2c_bus;
	unsigned int dim_min;
	unsigned int dim_max;

	unsigned char init_loaded;
	unsigned char cmd_size;
	unsigned char *init_on;
	unsigned char *init_off;
	unsigned int init_on_cnt;
	unsigned int init_off_cnt;
};

/* global API */
#define BL_EXT_DRIVER_MAX    10
struct aml_bl_extern_driver_s {
	int (*power_on)(void);
	int (*power_off)(void);
	int (*set_level)(unsigned int level);
	void (*config_print)(void);
	int (*device_power_on)(void);
	int (*device_power_off)(void);
	int (*device_bri_update)(unsigned int level);
	struct bl_extern_config_s *config;
};

extern struct aml_bl_extern_driver_s *aml_bl_extern_get_driver(void);
extern int aml_bl_extern_device_load(char *dtaddr, int index);
extern struct bl_extern_config_s bl_extern_config_dtf;
#ifdef CONFIG_AML_LCD_TABLET
extern int dsi_write_cmd(unsigned char *payload);
#endif

#endif

