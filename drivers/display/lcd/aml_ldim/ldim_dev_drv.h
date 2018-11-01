
/*
 * drivers/display/lcd/aml_ldim/ldim_dev_drv.h
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

#ifndef __LDIM_DEV_DRV_H
#define __LDIM_DEV_DRV_H
#include <spi.h>
#include <amlogic/aml_ldim.h>

extern void ldim_set_gpio(int index, int value);
extern unsigned int ldim_get_gpio(int index);
extern void ldim_set_duty_pwm(struct bl_pwm_config_s *bl);

extern int ldim_spi_write(struct spi_slave *spi, unsigned char *tbuf, int tlen);
extern int ldim_spi_read(struct spi_slave *spi, unsigned char *tbuf, int tlen,
		unsigned char *rbuf, int rlen);
extern int ldim_spi_driver_add(struct aml_ldim_driver_s *ldim_drv);
extern int ldim_spi_driver_remove(struct aml_ldim_driver_s *ldim_drv);

/* ldim device probe function */
#ifdef CONFIG_AML_LOCAL_DIMMING_IW7019
extern int ldim_dev_iw7019_probe(struct aml_ldim_driver_s *ldim_drv);
extern int ldim_dev_iw7019_remove(struct aml_ldim_driver_s *ldim_drv);
#endif
#ifdef CONFIG_AML_LOCAL_DIMMING_IW7027
extern int ldim_dev_iw7027_probe(struct aml_ldim_driver_s *ldim_drv);
extern int ldim_dev_iw7027_remove(struct aml_ldim_driver_s *ldim_drv);
#endif

#ifdef CONFIG_AML_LOCAL_DIMMING_OB3350
extern int ldim_dev_ob3350_probe(struct aml_ldim_driver_s *ldim_drv);
extern int ldim_dev_ob3350_remove(struct aml_ldim_driver_s *ldim_drv);
#endif

#ifdef CONFIG_AML_LOCAL_DIMMING_GLOBAL
extern int ldim_dev_global_probe(struct aml_ldim_driver_s *ldim_drv);
extern int ldim_dev_global_remove(struct aml_ldim_driver_s *ldim_drv);
#endif

#endif
