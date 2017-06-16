/*
 * drivers/display/lcd/bl_extern/bl_extern.h
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

#ifndef _BL_EXTERN_H_
#define _BL_EXTERN_H_
#ifdef CONFIG_SYS_I2C_AML
#include <aml_i2c.h>
#endif

#define BLEX(fmt, args...)     printf("bl extern: "fmt"", ## args)
#define BLEXERR(fmt, args...)    printf("bl extern: error: "fmt"", ## args)
#define BL_EXTERN_DRIVER		"bl_extern"

#ifdef CONFIG_SYS_I2C_AML
extern int aml_i2c_xfer_slow(struct i2c_msg *msgs, int num);
extern int aml_i2c_xfer(struct i2c_msg *msgs, int num);
#endif

#ifdef CONFIG_SYS_I2C_AML
#ifdef CONFIG_AML_BL_EXTERN_I2C_LP8556
extern int i2c_lp8556_probe(void);
#endif
#endif

#ifdef CONFIG_AML_BL_EXTERN_MIPI_IT070ME05
extern int mipi_lt070me05_probe(void);
#endif


#endif

