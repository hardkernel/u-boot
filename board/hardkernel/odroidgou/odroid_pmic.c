/*
 * board/hardkernel/odroidgou/odroid_pmic.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * add by: renjun.xu@amlogic.com
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
*/

#include <common.h>
#include <malloc.h>
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif

#include "odroid_pmic.h"

void i2c_check_bus(unsigned int master_num)
{
	extern unsigned int i2c_get_bus_num(void);
	extern int i2c_set_bus_num(unsigned int busnum);

	if (master_num != i2c_get_bus_num())
		i2c_set_bus_num(master_num);
}

static int rk818_i2c_write(int32_t command, uint8_t val)
{
	int ret = 0;
	uint8_t buf[2] = {0};
	struct i2c_msg msg;

	i2c_check_bus(RK818_I2C_BUS);

	msg.addr = RK818_CHIP_ADDR;
	msg.flags = 0;
	msg.len = sizeof(buf);
	msg.buf = buf;

	buf[0] = command & 0xff;
	buf[1] = val & 0xff;

	ret = aml_i2c_xfer(&msg, 1);
	if (ret < 0)
		printf("i2c write failed [addr 0x%02x]\n", msg.addr);

	return ret;
}

static int rk817_i2c_write(int32_t command, uint8_t val)
{
	int ret = 0;
	uint8_t buf[2] = {0};
	struct i2c_msg msg;

	i2c_check_bus(RK817_I2C_BUS);

	msg.addr = RK817_CHIP_ADDR;
	msg.flags = 0;
	msg.len = sizeof(buf);
	msg.buf = buf;

	buf[0] = command & 0xff;
	buf[1] = val & 0xff;

	ret = aml_i2c_xfer(&msg, 1);
	if (ret < 0)
		printf("i2c write failed [addr 0x%02x]\n", msg.addr);

	return ret;
}

/* Set default buck, ldo voltage */
void odroid_pmic_init(void)
{
	printf("enter odroid_pmic_init.\n");

	/* RK818 BUCK4(vddao_3v3) : 3.3V */
	rk818_i2c_write(RK818_BUCK4_ON_VSEL, 0x0c);

	/* RK818 BUCK1(vddcpu_a) : 1.0375V */
	rk818_i2c_write(RK818_BUCK1_ON_VSEL, 0x1a);
	/* RK818 BUCK2(vdd_ee) : 0.875V */
	rk818_i2c_write(RK818_BUCK2_ON_VSEL, 0x0d);

	/* RK818 LDO7,LDO5 enable */
	/* RK818 LDO1,LDO2,LDO3,LDO4,LDO6,LDO8 disable */
	rk818_i2c_write(RK818_LDO_EN_REG, 0x50);

	/* RK817 BUCK2(vddcpu_b) : 1.0375V */
	rk817_i2c_write(RK817_BUCK2_ON_VSEL, 0x2b);
	/* RK817 BUCK3 default : 2.4V */
	rk817_i2c_write(RK817_BUCK3_ON_VSEL, 0x59);

	/* RK817 LDO8(vdd_lcd) : 3.3V */
	rk817_i2c_write(RK817_LDO8_ON_VSEL, 0x6c);

	/* RK817 LDO4,LDO8 enable */
	rk817_i2c_write(RK817_POWER_EN2, 0x88);
	/* RK817 LDO1,LDO2,LDO3 disable */
	/* RK817 LDO5,LDO6,LDO7 disable */
	rk817_i2c_write(RK817_POWER_EN1, 0x88);
	/* RK817 BUCK2,BUCK3 enable */
	rk817_i2c_write(RK817_POWER_EN0, 0x66);

	printf("leave odroid_pmic_init.\n");
}
