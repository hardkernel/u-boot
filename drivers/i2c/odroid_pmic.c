/*
 * drivers/i2c/odroid_pmic.c
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
#ifdef CONFIG_SYS_I2C_AML
#include <aml_i2c.h>
#endif
#include <amlogic/odroid_pmic.h>

static int rk818_i2c_write(int32_t command, uint8_t val)
{
	int ret = 0;
	uint8_t buf[2] = {0};
	struct i2c_msg msg;

	msg.addr = RK818_ADDR;
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

	msg.addr = RK817_ADDR;
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

void odroid_pmic_init(void)
{
	printf("enter odroid_pmic_init.\n");
	
	/* RK817 LDO8 default : 3.0V */
	rk817_i2c_write(0xda, 0x60);
	rk817_i2c_write(0xdb, 0x60);
	
	/* RK817 LDO8 ON */
	rk817_i2c_write(0xb3, 0x88);

	//rk817_i2c_write(0xb2, 0x74);
	//rk817_i2c_write(0xb2, 0x74);
	//rk817_i2c_write(0xb2, 0x74);

	/* RK818 LDO6 */
	rk818_i2c_write(0x45, 0x1f);
	//rk818_i2c_write(0x24, 0x50);
}
