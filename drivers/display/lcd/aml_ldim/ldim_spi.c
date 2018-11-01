/*
 * drivers/display/lcd/lcd_bl_ldim/iw7027.c
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
#include <spi.h>
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include <amlogic/aml_ldim.h>
#include "../aml_lcd_reg.h"
#include "../aml_lcd_common.h"
#include "ldim_drv.h"
#include "ldim_dev_drv.h"

#ifdef CONFIG_DM_SPI

static unsigned int cs_hold_delay;
static unsigned int cs_clk_delay;

int ldim_spi_write(struct spi_slave *spi, unsigned char *tbuf, int tlen)
{
	int ret, size;

	ret = spi_claim_bus(spi);
	if (ret) {
		LDIMERR("%s: request spi bus failed\n", __func__);
		goto wreg_end;
	}

	if (cs_hold_delay)
		udelay(cs_hold_delay);
	spi_cs_activate(spi);
	if (cs_clk_delay)
		udelay(cs_clk_delay);
	size = tlen * 8;
	ret = spi_xfer(spi, size, tbuf, NULL, 0);
	if (cs_clk_delay)
		udelay(cs_clk_delay);
	spi_cs_deactivate(spi);

wreg_end:
	spi_release_bus(spi);
	return ret;
}

int ldim_spi_read(struct spi_slave *spi, unsigned char *tbuf, int tlen,
		unsigned char *rbuf, int rlen)
{
	int ret, size;

	ret = spi_claim_bus(spi);
	if (ret) {
		LDIMERR("%s: request spi bus failed\n", __func__);
		goto rreg_end;
	}

	if (cs_hold_delay)
		udelay(cs_hold_delay);
	spi_cs_activate(spi);
	if (cs_clk_delay)
		udelay(cs_clk_delay);
	size = (tlen + rlen) * 8;
	ret = spi_xfer(spi, size, tbuf, rbuf, 0);
	if (ret)
		goto rreg_end;
	if (cs_clk_delay)
		udelay(cs_clk_delay);
	spi_cs_deactivate(spi);

rreg_end:
	spi_release_bus(spi);
	return ret;
}

int ldim_spi_driver_add(struct aml_ldim_driver_s *ldim_drv)
{
	struct udevice *dev;
	int ret;

	if (ldim_drv->spi_info == NULL) {
		LDIMERR("%s: spi_info is null\n", __func__);
		return -1;
	}

	/* register spi */
	snprintf(ldim_drv->spi_info->spi_name, LDIM_SPI_NAME_MAX,
		"generic_%d:%d",
		ldim_drv->spi_info->bus_num,
		ldim_drv->spi_info->chip_select);
	ret = spi_get_bus_and_cs(ldim_drv->spi_info->bus_num,
				ldim_drv->spi_info->chip_select,
				ldim_drv->spi_info->max_speed_hz,
				ldim_drv->spi_info->mode,
				"spi_generic_drv",
				ldim_drv->spi_info->spi_name,
				&dev, &ldim_drv->spi_info->spi);
	if (ret) {
		LDIMERR("%s: register spi driver failed\n", __func__);
		return -1;
	}
	ldim_drv->spi_info->spi->wordlen = ldim_drv->spi_info->wordlen;
	cs_hold_delay = ldim_drv->ldev_conf->cs_hold_delay;
	cs_clk_delay = ldim_drv->ldev_conf->cs_clk_delay;

	spi_cs_deactivate(ldim_drv->spi_info->spi);

	return 0;
}

int ldim_spi_driver_remove(struct aml_ldim_driver_s *ldim_drv)
{
	if (ldim_drv->spi_info)
		ldim_drv->spi_info->spi = NULL;

	return 0;
}

#else
int ldim_spi_write(struct spi_slave *spi, unsigned char *tbuf, int tlen)
{
	LDIMERR("%s: no AML_SPICC support\n", __func__);

	return -1;
}

int ldim_spi_read(struct spi_slave *spi, unsigned char *tbuf, int tlen,
		unsigned char *rbuf, int rlen)
{
	LDIMERR("%s: no AML_SPICC support\n", __func__);

	return -1;
}

int ldim_spi_driver_add(struct aml_ldim_driver_s *ldim_drv)
{
	LDIMERR("%s: no AML_SPICC support\n", __func__);

	return -1;
}

int ldim_spi_driver_remove(struct aml_ldim_driver_s *ldim_drv)
{
	return 0;
}
#endif

