/*
 * drivers/i2c/aml_is31fl32xx.c
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
#include <amlogic/aml_is31fl32xx.h>

static int is31fl32xx_i2c_write(int32_t command, uint8_t val)
{
	int ret = 0;
	uint8_t buf[2] = {0};
	struct i2c_msg msg;

	msg.addr = IS31F132XX_DEVICE_ADDR;
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

void board_is31fl32xx_init(void)
{
	int i;

	printf("enter board_is31fl32xx_init.\n");
	is31fl32xx_i2c_write(0x4F, 0);
	for (i = 0x26; i < 0x4A; i++)
		is31fl32xx_i2c_write(i, 1);
	is31fl32xx_i2c_write(0, 1);
	is31fl32xx_i2c_write(0x4A, 0);
	is31fl32xx_i2c_write(0x4B, 1);
	for (i = 0; i < 36; i++)
		is31fl32xx_i2c_write(i+1, 0xFF);
}

void board_is31fl32xx_light_on(void)
{
	int i;

	printf("enter board_is31fl32xx_light_on.\n");
	for (i = 0; i < 34; i += 3) {
		is31fl32xx_i2c_write(i+1, 0xFF);
		is31fl32xx_i2c_write(0x25, 0);
	}
}
