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
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_ldim.h>
#include "../aml_lcd_reg.h"
#include "../aml_lcd_common.h"
#include "ldim_drv.h"
#include "ldim_dev_drv.h"

#ifdef CONFIG_AML_SPICC

#define NORMAL_MSG            (0<<7)
#define BROADCAST_MSG         (1<<7)
#define BLOCK_DATA            (0<<6)
#define SINGLE_DATA           (1<<6)
#define IW7027_DEV_ADDR        1

static int iw7027_on_flag;

struct iw7027 {
	int cs_hold_delay;
	int cs_clk_delay;
	int cmd_size;
	unsigned char *init_data;
	struct spi_slave *spi;
};
struct iw7027 *bl_iw7027;

extern struct ldim_spi_dev_info_s ldim_spi_dev;

//iw7027 register write
static int iw7027_wreg(struct spi_slave *slave, u8 addr, u8 val)
{
	u8 tbuf[3];
	int ret;

	if (lcd_debug_print_flag)
		LDIMPR("%s: 0x%02x = 0x%02x\n", __func__, addr, val);

	ret = spi_claim_bus(slave);
	if (ret) {
		LDIMERR("%s: request spi bus failed\n", __func__);
		goto end;
	}
	if (bl_iw7027->cs_hold_delay)
		udelay(bl_iw7027->cs_hold_delay);
	spi_cs_activate(slave);
	if (bl_iw7027->cs_clk_delay)
		udelay(bl_iw7027->cs_clk_delay);

	tbuf[0] = NORMAL_MSG | SINGLE_DATA | IW7027_DEV_ADDR;
	tbuf[1] = addr & 0x7f;
	tbuf[2] = val;
	ret = spi_xfer(slave, 24, tbuf, 0, 0);
	if (bl_iw7027->cs_clk_delay)
		udelay(bl_iw7027->cs_clk_delay);
	spi_cs_deactivate(slave);

end:
	spi_release_bus(slave);
	return ret;
}

//iw7027 register read
static int iw7027_rreg(struct spi_slave *slave, u8 addr, u8 *val)
{
	u8 tbuf[4], rbuf[4];
	int ret;

	/*set read flag*/
	if (addr >= 0x80)
		iw7027_wreg(bl_iw7027->spi, 0x78, 0x80);
	else
		iw7027_wreg(bl_iw7027->spi, 0x78, 0x0);

	ret = spi_claim_bus(slave);
	if (ret) {
		LDIMERR("%s: request spi bus failed\n", __func__);
		goto end;
	}
	if (bl_iw7027->cs_hold_delay)
		udelay(bl_iw7027->cs_hold_delay);
	spi_cs_activate(slave);
	if (bl_iw7027->cs_clk_delay)
		udelay(bl_iw7027->cs_clk_delay);

	tbuf[0] = NORMAL_MSG | SINGLE_DATA | IW7027_DEV_ADDR;
	tbuf[1] = addr | 0x80;
	ret = spi_xfer(slave, 32, tbuf, rbuf, 0);
	if (ret)
		goto end;
	*val = rbuf[3];
	if (bl_iw7027->cs_clk_delay)
		udelay(bl_iw7027->cs_clk_delay);
	spi_cs_deactivate(slave);

end:
	spi_release_bus(slave);
	return ret;
}

//iw7027 block write
static int iw7027_wregs(struct spi_slave *slave, u8 addr, u8 *val, int len)
{
	u8 tbuf[30];
	int size, i;
	int ret;

	if (lcd_debug_print_flag) {
		LDIMPR("%s: ", __func__);
		for (i = 0; i < len; i++)
			printf("0x%02x ", val[i]);
		printf("\n");
	}

	ret = spi_claim_bus(slave);
	if (ret) {
		LDIMERR("%s: request spi bus failed\n", __func__);
		goto end;
	}
	if (bl_iw7027->cs_hold_delay)
		udelay(bl_iw7027->cs_hold_delay);
	spi_cs_activate(slave);
	if (bl_iw7027->cs_clk_delay)
		udelay(bl_iw7027->cs_clk_delay);

	tbuf[0] = NORMAL_MSG | BLOCK_DATA | IW7027_DEV_ADDR;
	tbuf[1] = len;
	tbuf[2] = addr & 0x7f;
	size = (len + 3) * 8;
	memcpy(&tbuf[3], val, len);
	ret = spi_xfer(slave, size, tbuf, 0, 0);
	if (bl_iw7027->cs_clk_delay)
		udelay(bl_iw7027->cs_clk_delay);
	spi_cs_deactivate(slave);

end:
	spi_release_bus(slave);
	return ret;
}

static int iw7027_power_on_init(void)
{
	unsigned char addr, val;
	int i, ret = 0;

	for (i = 0; i < LDIM_SPI_INIT_ON_SIZE; i += bl_iw7027->cmd_size) {
		if (bl_iw7027->init_data[i] == 0xff) {
			if (bl_iw7027->init_data[i+3] > 0)
				mdelay(bl_iw7027->init_data[i+3]);
			break;
		} else if (bl_iw7027->init_data[i] == 0x0) {
			addr = bl_iw7027->init_data[i+1];
			val = bl_iw7027->init_data[i+2];
			ret = iw7027_wreg(bl_iw7027->spi, addr, val);
			udelay(1);
		}
		if (bl_iw7027->init_data[i+3] > 0)
			mdelay(bl_iw7027->init_data[i+3]);
	}

	return ret;
}

static int iw7027_hw_init_on(void)
{
	int i, count = 1000;
	unsigned char  reg_duty_chk = 0 , reg_chk = 0;
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	/*iw7027 system power_on*/
	LDIMPR("%s: iw7027 system power_on\n", __func__);
	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio, ldim_drv->ldev_conf->en_gpio_on);
	ldim_set_duty_pwm(&(ldim_drv->ldev_conf->pwm_config));
	mdelay(10);

	/*SPI Communication Check */
	LDIMPR("%s: SPI Communication Check \n", __func__);
	for (i = 0; i <= 10; i++) {
		iw7027_wreg(bl_iw7027->spi, 0x00, 0x06);
		iw7027_rreg(bl_iw7027->spi, 0x00, &reg_chk);
		if (reg_chk == 0x06)
			break;
		else if(i == 10)
			goto iw7027_smr_end;
	}
	/*Write initial control registers*/
	LDIMPR("%s: Write initial control registers\n", __func__);
	iw7027_power_on_init();

	/*open Vsync*/
	LDIMPR("%s: open Vsync\n", __func__);
	ldim_drv->pinmux_ctrl(1);
	mdelay(500);

	/*Disable soft reset*/
	LDIMPR("%s: Disable soft reset\n", __func__);
	iw7027_wreg(bl_iw7027->spi, 0x00, 0x07);

	/*Calibration Done or not*/
	LDIMPR("%s: Calibration Done or not\n", __func__);
	while (count --) {
		iw7027_rreg(bl_iw7027->spi, 0xb3, &reg_duty_chk);
		/*VDAC statue reg :FB1=[0x5] FB2=[0x50]*/
		/*The current platform using FB1*/
		if ((reg_duty_chk & 0xf) == 0x05) {
			break;
		}
		mdelay(1);
	}
	LDIMPR("%s: reg_duty_chk[%d] = %x\n", __func__, count, reg_duty_chk);
iw7027_smr_end:

	return 0;
}

static int iw7027_hw_init_off(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	ldim_drv->pinmux_ctrl(0);
	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio, ldim_drv->ldev_conf->en_gpio_off);

	return 0;
}

static unsigned int iw7027_get_value(unsigned int level)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();
	unsigned int val;
	unsigned int dim_max, dim_min;

	dim_max = ldim_drv->ldev_conf->dim_max;
	dim_min = ldim_drv->ldev_conf->dim_min;

	val = dim_min + ((level * (dim_max - dim_min)) / LD_DATA_MAX);

	return val;
}

static int iw7027_smr(unsigned short *buf, unsigned char len)
{
	unsigned char val_0[20];

	if (iw7027_on_flag == 0) {
		if (lcd_debug_print_flag)
			LDIMPR("%s: on_flag=%d\n", __func__, iw7027_on_flag);
		return 0;
	}
	if (len != 10) {
		LDIMERR("%s: data len %d invalid\n", __func__, len);
		return -1;
	}

	val_0[0] = ((iw7027_get_value(buf[0])
		) & 0xf00) >> 8;
	val_0[1] = (iw7027_get_value(buf[0])
		) & 0xff;
	val_0[2] = ((iw7027_get_value(buf[1])
		) & 0xf00) >> 8;
	val_0[3] = (iw7027_get_value(buf[1])
		) & 0xff;
	val_0[4] = ((iw7027_get_value(buf[2])
		) & 0xf00) >> 8;
	val_0[5] = (iw7027_get_value(buf[2])
		) & 0xff;
	val_0[6] = ((iw7027_get_value(buf[3])
		) & 0xf00) >> 8;
	val_0[7] = (iw7027_get_value(buf[3])
		) & 0xff;
	val_0[8] = ((iw7027_get_value(buf[4])
		) & 0xf00) >> 8;
	val_0[9] = (iw7027_get_value(buf[4])
		) & 0xff;
	val_0[10] = ((iw7027_get_value(buf[5])
		) & 0xf00) >> 8;
	val_0[11] = (iw7027_get_value(buf[5])
		) & 0xff;
	val_0[12] = ((iw7027_get_value(buf[6])
		) & 0xf00) >> 8;
	val_0[13] = (iw7027_get_value(buf[6])
		) & 0xff;
	val_0[14] = ((iw7027_get_value(buf[7])
		) & 0xf00) >> 8;
	val_0[15] = (iw7027_get_value(buf[7])
		) & 0xff;
	val_0[16] = ((iw7027_get_value(buf[8])
		) & 0xf00) >> 8;
	val_0[17] = (iw7027_get_value(buf[8])
		) & 0xff;
	val_0[18] = ((iw7027_get_value(buf[9])
		) & 0xf00) >> 8;
	val_0[19] = (iw7027_get_value(buf[9])
		) & 0xff;

	iw7027_wregs(bl_iw7027->spi, 0x40, val_0, 20);

	return 0;
}

static int iw7027_power_on(void)
{
	iw7027_hw_init_on();
	iw7027_on_flag = 1;

	LDIMPR("%s: ok\n", __func__);
	return 0;
}

static int iw7027_power_off(void)
{
	iw7027_on_flag = 0;
	iw7027_hw_init_off();

	LDIMPR("%s: ok\n", __func__);
	return 0;
}

static int iw7027_ldim_driver_update(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	ldim_drv->device_power_on = iw7027_power_on;
	ldim_drv->device_power_off = iw7027_power_off;
	ldim_drv->device_bri_update = iw7027_smr;
	return 0;
}

int ldim_dev_iw7027_probe(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	bl_iw7027 = (struct iw7027 *)malloc(sizeof(struct iw7027));
	if (bl_iw7027 == NULL) {
		LDIMERR("iw7027 malloc error\n");
		return -1;
	}
	memset(bl_iw7027, 0, sizeof(struct iw7027));

	iw7027_on_flag = 0;

	/* register spi */
	ldim_drv->spi_dev->spi =
		spi_setup_slave(ldim_drv->spi_dev->bus_num,
					ldim_drv->spi_dev->chip_select,
					ldim_drv->spi_dev->max_speed_hz,
					ldim_drv->spi_dev->mode);
	if (ldim_drv->spi_dev->spi == NULL) {
		LDIMERR("register ldim_dev spi driver failed\n");
		return -1;
	}
	spi_cs_deactivate(ldim_drv->spi_dev->spi);

	bl_iw7027->spi = ldim_drv->spi_dev->spi;
	bl_iw7027->cs_hold_delay = ldim_drv->ldev_conf->cs_hold_delay;
	bl_iw7027->cs_clk_delay = ldim_drv->ldev_conf->cs_clk_delay;
	bl_iw7027->cmd_size = ldim_drv->ldev_conf->cmd_size;
	bl_iw7027->init_data = ldim_drv->ldev_conf->init_on;
	iw7027_ldim_driver_update();

	return 0;
}

int ldim_dev_iw7027_remove(void)
{
	if (bl_iw7027) {
		free(bl_iw7027);
		bl_iw7027 = NULL;
	}
	return 0;
}
#endif

