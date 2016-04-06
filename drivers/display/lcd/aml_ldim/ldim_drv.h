
/*
 * drivers/display/lcd/aml_ldim/ldim_drv.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
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
 *
*/

#ifndef __AML_LDIM_DRV_H__
#define __AML_LDIM_DRV_H__
#include <asm/arch/io.h>
#include <amlogic/aml_lcd_vout.h>

#define LDIMPR(fmt, args...)     printf("ldim: "fmt"", ## args)
#define LDIMERR(fmt, args...)    printf("ldim: error: "fmt"", ## args)

extern void bl_pwm_ctrl(struct bl_pwm_config_s *bl_pwm, int status);
#ifdef CONFIG_OF_LIBFDT
extern enum bl_pwm_port_e bl_pwm_str_to_pwm(const char *str);
#endif

/* ldim device probe function */
#ifdef CONFIG_AML_SPICC
#ifdef CONFIG_AML_LOCAL_DIMMING_IW7019
extern int aml_ldim_iw7019_probe(char *dt_addr);
#endif
#endif

#endif
