/*
 * drivers/display/lcd/lcd_bl_ldim/iw7019.c
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

#ifdef CONFIG_AML_SPICC

#define BUS_SPICC             2
#define NORMAL_MSG            (0<<7)
#define BROADCAST_MSG         (1<<7)
#define BLOCK_DATA            (0<<6)
#define SINGLE_DATA           (1<<6)
#define IW7019_DEV_ADDR        1
#define IW7019_REG_BRIGHTNESS  0x01


#define IW7019_GPIO_EN        "GPIOX_9"
#define IW7019_GPIO_CS        "GPIOH_9"

struct iw7019 {
	int en_gpio;
	int cs_gpio;
	struct spi_slave *spi;
};
struct iw7019 *bl_iw7019;

struct ld_config_s iw7019_ld_config = {
	.dim_min = 0x7f, /* min 3% duty */
	.dim_max = 0xfff,
};

static u8 iw7019_ini_data[][2] = {
#if 1
	/* step1: */
	{0x1, 0x8},
	/* step2:disable ocp and otp */
	{0x34, 0x14},
	{0x10, 0x53},
	/* step3: */
	{0x11, 0x00},
	{0x12, 0x02},
	{0x13, 0x00},
	{0x14, 0x40},
	{0x15, 0x06},
	{0x16, 0x00},
	{0x17, 0x80},
	{0x18, 0x0a},
	{0x19, 0x00},
	{0x1a, 0xc0},
	{0x1b, 0x0e},
	{0x1c, 0x00},
	{0x1d, 0x00},
	{0x1e, 0x50},
	{0x1f, 0x00},
	{0x20, 0x63},
	{0x21, 0xff},
	{0x2a, 0xff},
	{0x2b, 0x41},
	{0x2c, 0x28},
	{0x30, 0xff},
	{0x31, 0x00},
	{0x32, 0x0f},
	{0x33, 0x40},
	{0x34, 0x40},
	{0x35, 0x00},
	{0x3f, 0xa3},
	{0x45, 0x00},
	{0x47, 0x04},
	{0x48, 0x60},
	{0x4a, 0x0d},
	/* step4:set brightness */
	{0x01, 0xff},
	{0x02, 0xff},
	{0x03, 0xff},
	{0x04, 0xff},
	{0x05, 0xff},
	{0x06, 0xff},
	{0x07, 0xff},
	{0x08, 0xff},
	{0x09, 0xff},
	{0x0a, 0xff},
	{0x0b, 0xff},
	{0x0c, 0xff},
	/* step5: */
	{0x00, 0x09},
	/* step6: */
	{0x34, 0x00},
#else
	/* step1: */
	{0x00, 0x0E},
	{0x1D, 0x01},
	/* step2:disable ocp and otp */
	{0x34, 0x54},
	{0x10, 0x93},
	/* step3: */
	{0x11, 0x00},
	{0x12, 0x12},
	{0x13, 0x00},
	{0x14, 0x40},
	{0x15, 0x06},
	{0x16, 0x00},
	{0x17, 0x80},
	{0x18, 0x0a},
	{0x19, 0x00},
	{0x1a, 0xc0},
	{0x1b, 0x0e},
	{0x1c, 0x00},
	{0x1d, 0x01},
	{0x1e, 0x50},
	{0x1f, 0x00},
	{0x20, 0x43},
	{0x21, 0xff},
	{0x2a, 0xff},
	{0x2b, 0x01},
	{0x2c, 0x28},
	{0x30, 0xff},
	{0x31, 0x00},
	{0x3f, 0xa3},
	{0x47, 0x04},
	{0x48, 0x40},/*use external vsync or internal vsync*/
	{0x4a, 0x45},
	{0x4b, 0x0C},
	/*step4:set brightness*/
	{0x01, 0xff},
	{0x02, 0xff},
	{0x03, 0xff},
	{0x04, 0xff},
	{0x05, 0xff},
	{0x06, 0xff},
	{0x07, 0xff},
	{0x08, 0xff},
	{0x09, 0xff},
	{0x0a, 0xff},
	{0x0b, 0xff},
	{0x0c, 0xff},
	/* step5: */
	{0x00, 0x0F},
	/* step6: */
	{0x34, 0x00},
#endif
};

static u8 iw7019_ini_data_off[][2] = {
#if 1
	/* step1: */
	{0x1, 0x8},
	/* step2:disable ocp and otp */
	{0x34, 0x14},
	{0x10, 0x53},
	/* step3: */
	{0x11, 0x00},
	{0x12, 0x02},
	{0x13, 0x00},
	{0x14, 0x40},
	{0x15, 0x06},
	{0x16, 0x00},
	{0x17, 0x80},
	{0x18, 0x0a},
	{0x19, 0x00},
	{0x1a, 0xc0},
	{0x1b, 0x0e},
	{0x1c, 0x00},
	{0x1d, 0x00},
	{0x1e, 0x50},
	{0x1f, 0x00},
	{0x20, 0x63},
	{0x21, 0xff},
	{0x2a, 0xff},
	{0x2b, 0x41},
	{0x2c, 0x28},
	{0x30, 0xff},
	{0x31, 0x00},
	{0x32, 0x0f},
	{0x33, 0x40},
	{0x34, 0x40},
	{0x35, 0x00},
	{0x3f, 0xa3},
	{0x45, 0x00},
	{0x47, 0x04},
	{0x48, 0x60},
	{0x4a, 0x0d},
	/* step4:set brightness */
	{0x01, 0x00},
	{0x02, 0x00},
	{0x03, 0x00},
	{0x04, 0x00},
	{0x05, 0x00},
	{0x06, 0x00},
	{0x07, 0x00},
	{0x08, 0x00},
	{0x09, 0x00},
	{0x0a, 0x00},
	{0x0b, 0x00},
	{0x0c, 0x00},
	/* step5: */
	{0x00, 0x09},
	/* step6: */
	{0x34, 0x00},
#else
	/* step1: */
	{0x00, 0x0E},
	{0x1D, 0x01},
	/* step2:disable ocp and otp */
	{0x34, 0x54},
	{0x10, 0x93},
	/* step3: */
	{0x11, 0x00},
	{0x12, 0x12},
	{0x13, 0x00},
	{0x14, 0x40},
	{0x15, 0x06},
	{0x16, 0x00},
	{0x17, 0x80},
	{0x18, 0x0a},
	{0x19, 0x00},
	{0x1a, 0xc0},
	{0x1b, 0x0e},
	{0x1c, 0x00},
	{0x1d, 0x01},
	{0x1e, 0x50},
	{0x1f, 0x00},
	{0x20, 0x43},
	{0x21, 0xff},
	{0x2a, 0xff},
	{0x2b, 0x01},
	{0x2c, 0x28},
	{0x30, 0xff},
	{0x31, 0x00},
	{0x3f, 0xa3},
	{0x47, 0x04},
	{0x48, 0x40},/*use external vsync or internal vsync*/
	{0x4a, 0x45},
	{0x4b, 0x0C},
	/* step4:set brightness*/
	{0x01, 0xff},
	{0x02, 0xff},
	{0x03, 0xff},
	{0x04, 0xff},
	{0x05, 0xff},
	{0x06, 0xff},
	{0x07, 0xff},
	{0x08, 0xff},
	{0x09, 0xff},
	{0x0a, 0xff},
	{0x0b, 0xff},
	{0x0c, 0xff},
	/* step5: */
	{0x00, 0x0F},
	/* step6: */
	{0x34, 0x00},
#endif
};

#if 0
//iw7019 register read
static int iw7019_rreg(struct spi_slave *slave, u8 addr, u8 *val)
{
	u8 tbuf[4], rbuf[4];
	int ret;

	ret = spi_claim_bus(slave);
	if (ret) {
		LDIMERR("%s: request spi bus failed\n", __func__);
		goto end;
	}

	tbuf[0] = NORMAL_MSG | SINGLE_DATA | IW7019_DEV_ADDR;
	tbuf[1] = addr | 0x80;
	ret = spi_xfer(slave, 32, tbuf, rbuf, SPI_XFER_BEGIN | SPI_XFER_END);
	if (ret)
		goto end;
	*val = rbuf[3];

end:
	spi_release_bus(slave);
	return ret;
}
#endif

//iw7019 register write
static int iw7019_wreg(struct spi_slave *slave, u8 addr, u8 val)
{
	u8 tbuf[3];
	int ret;

	ret = spi_claim_bus(slave);
	if (ret) {
		LDIMERR("%s: request spi bus failed\n", __func__);
		goto end;
	}

	tbuf[0] = NORMAL_MSG | SINGLE_DATA | IW7019_DEV_ADDR;
	tbuf[1] = addr & 0x7f;
	tbuf[2] = val;
	ret = spi_xfer(slave, 24, tbuf, 0, SPI_XFER_BEGIN | SPI_XFER_END);

end:
	spi_release_bus(slave);
	return ret;
}

//iw7019 block write
static int iw7019_wregs(struct spi_slave *slave, u8 addr, u8 *val, int len)
{
	u8 tbuf[20];
	int size;
	int ret;

	ret = spi_claim_bus(slave);
	if (ret) {
		LDIMERR("%s: request spi bus failed\n", __func__);
		goto end;
	}

	tbuf[0] = NORMAL_MSG | BLOCK_DATA | IW7019_DEV_ADDR;
	tbuf[1] = addr & 0x7f;
	size = (len + 2) * 8;
	memcpy(&tbuf[2], val, len);
	ret = spi_xfer(slave, size, tbuf, 0, SPI_XFER_BEGIN | SPI_XFER_END);

end:
	spi_release_bus(slave);
	return ret;
}

static int iw7019_power_on_init(void)
{
	u8 addr, val;
	int i, ret = 0;

	for (i = 0; i < ARRAY_SIZE(iw7019_ini_data); i++) {
		addr = iw7019_ini_data[i][0];
		val = iw7019_ini_data[i][1];
		ret = iw7019_wreg(bl_iw7019->spi, addr, val);
		udelay(1);
	}

	return ret;
}

static int iw7019_power_off_init(void)
{
	u8 addr, val;
	int i, ret = 0;

	for (i = 0; i < ARRAY_SIZE(iw7019_ini_data_off); i++) {
		addr = iw7019_ini_data_off[i][0];
		val = iw7019_ini_data_off[i][1];
		ret = iw7019_wreg(bl_iw7019->spi, addr, val);
		udelay(1);
	}

	return ret;
}

static int iw7019_hw_init(struct iw7019 *bl)
{
	struct aml_ldim_driver_s *ld_drv = aml_ldim_get_driver();

	aml_lcd_gpio_set(bl->en_gpio, 1);
	mdelay(2);
	ld_drv->pinmux_ctrl(1);
	mdelay(100);
	iw7019_power_on_init();

	return 0;
}

static int iw7019_hw_init_off(struct iw7019 *bl)
{
	struct aml_ldim_driver_s *ld_drv = aml_ldim_get_driver();

	iw7019_power_off_init();
	mdelay(10);
	ld_drv->pinmux_ctrl(0);
	aml_lcd_gpio_set(bl->en_gpio, 0);

	return 0;
}

static int iw7019_smr(unsigned short *buf, unsigned char len)
{
	int i;
	u8 val[12];
	int br0, br1;

	if (len != 8) {
		LDIMERR("%s: data len %d invalid\n", __func__, len);
		return -1;
	}
	for (i = 0; i < 4; i++) {
		br0 = buf[i*2+0];
		br1 = buf[i*2+1];
		val[i*3+0] = (br0 >> 4) & 0xff; /* br0[11~4] */
		val[i*3+1] = ((br0 & 0xf) << 4) | ((br1 >> 8) & 0xf);
		/* br0[3~0]|br1[11~8] */
		val[i*3+2] = br1 & 0xff; /* br1[7~0] */
	}
	iw7019_wregs(bl_iw7019->spi, IW7019_REG_BRIGHTNESS, val, ARRAY_SIZE(val));

	return 0;
}

static int iw7019_power_on(void)
{
	iw7019_hw_init(bl_iw7019);

	LDIMPR("%s: ok\n", __func__);
	return 0;
}

static int iw7019_power_off(void)
{
	iw7019_hw_init_off(bl_iw7019);

	LDIMPR("%s: ok\n", __func__);
	return 0;
}

static int iw7019_ldim_driver_update(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	ldim_drv->ld_config = &iw7019_ld_config;
	ldim_drv->device_power_on = iw7019_power_on;
	ldim_drv->device_power_off = iw7019_power_off;
	ldim_drv->device_bri_update = iw7019_smr;
	return 0;
}

static int iw7019_config_load_from_dts(char *dt_addr)
{
	bl_iw7019->en_gpio = aml_lcd_gpio_name_map_num(IW7019_GPIO_EN);

	/* bl_iw7019->cs_gpio = aml_lcd_gpio_name_map_num(IW7019_GPIO_CS); */

	return 0;
}

int aml_ldim_iw7019_probe(char *dt_addr)
{
	bl_iw7019 = (struct iw7019 *)malloc(sizeof(struct iw7019));
	if (bl_iw7019 == NULL) {
		LDIMERR("iw7019 malloc error\n");
		return -1;
	}
	memset(bl_iw7019, 0, sizeof(struct iw7019));

	iw7019_config_load_from_dts(dt_addr);
	iw7019_ldim_driver_update();

	bl_iw7019->spi = spi_setup_slave(BUS_SPICC, 0, 400000, 0);
	/* init cs to high */
	/* aml_lcd_gpio_set(bl_iw7019->cs_gpio, 1); */

	return 0;
}
#endif

