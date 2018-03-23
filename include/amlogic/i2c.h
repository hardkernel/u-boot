/*
 * Amlogic I2C controller Diver
 *
 * Copyright (C) 2018 Amlogic Corporation
 *
 * Licensed under the GPL-2 or later.
 *
 */

#ifndef __I2C_H__
#define __I2C_H__

/*
 * @i2c_index: Controller Index.
 * @reg: Controller registers address.
 * @clock_rate: clock source rate.
 * @div_factor: divider factor.
 * @i2c_index: Filter delay count ,if not, i2c frequecy
 * is not correct.
 */

struct meson_i2c_platdata {
	unsigned int i2c_index;
	ulong reg;
	unsigned int clock_rate;
	unsigned int div_factor;
	unsigned int delay_ajust;
	unsigned int clock_frequency;
};

struct meson_i2c_slavedata {
	uint chip_addr;
	uint offset_len;
	uint flags;
};

#endif /* __I2C_H__ */