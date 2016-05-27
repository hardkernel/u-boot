/*
 * include/amlogic/aml_bl_ldim.h
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

#ifndef INC_AML_BL_LDIM_H
#define INC_AML_BL_LDIM_H

#include <common.h>
#include <linux/list.h>
#include <amlogic/aml_lcd.h>
#include <spi.h>

#define LDIM_SPI_INIT_ON_SIZE     300
#define LDIM_SPI_INIT_OFF_SIZE    20
struct ldim_dev_config_s {
	char name[20];
	int cs_hold_delay;
	int cs_clk_delay;
	int en_gpio;
	int en_gpio_on;
	int en_gpio_off;
	int lamp_err_gpio;
	unsigned char fault_check;
	unsigned char write_check;

	unsigned int dim_min;
	unsigned int dim_max;
	unsigned char cmd_size;
	unsigned char *init_on;
	unsigned char *init_off;

	struct bl_pwm_config_s pwm_config;
	char gpio_name[BL_GPIO_NUM_MAX][LCD_CPU_GPIO_NAME_MAX];
};

/*******global API******/
struct aml_ldim_driver_s {
	int valid_flag;
	int dev_index;
	struct ldim_dev_config_s *ldev_conf;
	unsigned short *ldim_matrix_2_spi;
	int (*power_on)(void);
	int (*power_off)(void);
	int (*set_level)(unsigned int level);
	void (*config_print)(void);
	int (*pinmux_ctrl)(int status);
	int (*device_power_on)(void);
	int (*device_power_off)(void);
	int (*device_bri_update)(unsigned short *buf, unsigned char len);
	struct spi_slave *spi;
};

extern struct aml_ldim_driver_s *aml_ldim_get_driver(void);
extern int aml_ldim_probe(char *dt_addr, int flag); /* flag: 0=dts, 1=bsp, 2=unifykey */

#endif /* INC_AML_BL_LDIM_H */
