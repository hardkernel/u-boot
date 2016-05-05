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
#define IW7019_REG_BRIGHTNESS      0x01
#define IW7019_REG_BRIGHTNESS_CHK  0x00


#define IW7019_GPIO_EN        "GPIOX_9"
#define IW7019_GPIO_CS        "GPIOH_9"

struct iw7019 {
	unsigned char write_check;
	int en_gpio;
	int en_on;
	int en_off;
	int cs_hold_delay;
	int cs_clk_delay;
	int cmd_size;
	struct spi_slave *spi;
};
struct iw7019 *bl_iw7019;

struct ld_config_s iw7019_ld_config = {
	.dim_min = 0x7f, /* min 3% duty */
	.dim_max = 0xfff,
	.cmd_size = 4,
};

#define IW7019_INIT_ON_SIZE     300
#define IW7019_INIT_OFF_SIZE    8

static u8 iw7019_ini_data[IW7019_INIT_ON_SIZE] = {
#if 1
	/* step1: */
	0x00, 0x01, 0x08, 0x00,
	/* step2:disable ocp and otp */
	0x00, 0x34, 0x14, 0x00,
	0x00, 0x10, 0x53, 0x00,
	/* step3: */
	0x00, 0x11, 0x00, 0x00,
	0x00, 0x12, 0x02, 0x00,
	0x00, 0x13, 0x00, 0x00,
	0x00, 0x14, 0x40, 0x00,
	0x00, 0x15, 0x06, 0x00,
	0x00, 0x16, 0x00, 0x00,
	0x00, 0x17, 0x80, 0x00,
	0x00, 0x18, 0x0a, 0x00,
	0x00, 0x19, 0x00, 0x00,
	0x00, 0x1a, 0xc0, 0x00,
	0x00, 0x1b, 0x0e, 0x00,
	0x00, 0x1c, 0x00, 0x00,
	0x00, 0x1d, 0x00, 0x00,
	0x00, 0x1e, 0x50, 0x00,
	0x00, 0x1f, 0x00, 0x00,
	0x00, 0x20, 0x63, 0x00,
	0x00, 0x21, 0xff, 0x00,
	0x00, 0x2a, 0xff, 0x00,
	0x00, 0x2b, 0x41, 0x00,
	0x00, 0x2c, 0x28, 0x00,
	0x00, 0x30, 0xff, 0x00,
	0x00, 0x31, 0x00, 0x00,
	0x00, 0x32, 0x0f, 0x00,
	0x00, 0x33, 0x40, 0x00,
	0x00, 0x34, 0x40, 0x00,
	0x00, 0x35, 0x00, 0x00,
	0x00, 0x3f, 0xa3, 0x00,
	0x00, 0x45, 0x00, 0x00,
	0x00, 0x47, 0x04, 0x00,
	0x00, 0x48, 0x60, 0x00,
	0x00, 0x4a, 0x0d, 0x00,
	/* step4:set 50% brightness */
	0x00, 0x01, 0x7f, 0x00,
	0x00, 0x02, 0xf7, 0x00,
	0x00, 0x03, 0xff, 0x00,
	0x00, 0x04, 0x7f, 0x00,
	0x00, 0x05, 0xf7, 0x00,
	0x00, 0x06, 0xff, 0x00,
	0x00, 0x07, 0x7f, 0x00,
	0x00, 0x08, 0xf7, 0x00,
	0x00, 0x09, 0xff, 0x00,
	0x00, 0x0a, 0x7f, 0x00,
	0x00, 0x0b, 0xf7, 0x00,
	0x00, 0x0c, 0xff, 0x00,
	/* step5: */
	0x00, 0x00, 0x09, 0x00,
	/* step6: */
	0x00, 0x34, 0x00, 0x00,
	0xff, 0x00, 0x00, 0x00,
#else
	/* step1: */
	0x00, 0x00, 0x0E, 0x00,
	0x00, 0x1D, 0x01, 0x00,
	/* step2:disable ocp and otp */
	0x00, 0x34, 0x54, 0x00,
	0x00, 0x10, 0x93, 0x00,
	/* step3: */
	0x00, 0x11, 0x00, 0x00,
	0x00, 0x12, 0x12, 0x00,
	0x00, 0x13, 0x00, 0x00,
	0x00, 0x14, 0x40, 0x00,
	0x00, 0x15, 0x06, 0x00,
	0x00, 0x16, 0x00, 0x00,
	0x00, 0x17, 0x80, 0x00,
	0x00, 0x18, 0x0a, 0x00,
	0x00, 0x19, 0x00, 0x00,
	0x00, 0x1a, 0xc0, 0x00,
	0x00, 0x1b, 0x0e, 0x00,
	0x00, 0x1c, 0x00, 0x00,
	0x00, 0x1d, 0x01, 0x00,
	0x00, 0x1e, 0x50, 0x00,
	0x00, 0x1f, 0x00, 0x00,
	0x00, 0x20, 0x43, 0x00,
	0x00, 0x21, 0xff, 0x00,
	0x00, 0x2a, 0xff, 0x00,
	0x00, 0x2b, 0x01, 0x00,
	0x00, 0x2c, 0x28, 0x00,
	0x00, 0x30, 0xff, 0x00,
	0x00, 0x31, 0x00, 0x00,
	0x00, 0x3f, 0xa3, 0x00,
	0x00, 0x47, 0x04, 0x00,
	0x00, 0x48, 0x40, 0x00, /*use external vsync or internal vsync*/
	0x00, 0x4a, 0x45, 0x00,
	0x00, 0x4b, 0x0C, 0x00,
	/*step4:set min brightness*/
	0x00, 0x01, 0x07, 0x00,
	0x00, 0x02, 0xf0, 0x00,
	0x00, 0x03, 0x7f, 0x00,
	0x00, 0x04, 0x07, 0x00,
	0x00, 0x05, 0xf0, 0x00,
	0x00, 0x06, 0x7f, 0x00,
	0x00, 0x07, 0x07, 0x00,
	0x00, 0x08, 0xf0, 0x00,
	0x00, 0x09, 0x7f, 0x00,
	0x00, 0x0a, 0x07, 0x00,
	0x00, 0x0b, 0xf0, 0x00,
	0x00, 0x0c, 0x7f, 0x00,
	/* step5: */
	0x00, 0x00, 0x0F, 0x00,
	/* step6: */
	0x00, 0x34, 0x00, 0x00,
	0xff, 0x00, 0x00, 0x00,  /* ending */
#endif
};

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
	if (bl_iw7019->cs_hold_delay)
		udelay(bl_iw7019->cs_hold_delay);
	spi_cs_activate(slave);
	if (bl_iw7019->cs_clk_delay)
		udelay(bl_iw7019->cs_clk_delay);

	tbuf[0] = NORMAL_MSG | SINGLE_DATA | IW7019_DEV_ADDR;
	tbuf[1] = addr | 0x80;
	ret = spi_xfer(slave, 32, tbuf, rbuf, 0);
	if (ret)
		goto end;
	*val = rbuf[3];
	if (bl_iw7019->cs_clk_delay)
		udelay(bl_iw7019->cs_clk_delay);
	spi_cs_deactivate(slave);

end:
	spi_release_bus(slave);
	return ret;
}

//iw7019 register write
static int iw7019_wreg(struct spi_slave *slave, u8 addr, u8 val)
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
	if (bl_iw7019->cs_hold_delay)
		udelay(bl_iw7019->cs_hold_delay);
	spi_cs_activate(slave);
	if (bl_iw7019->cs_clk_delay)
		udelay(bl_iw7019->cs_clk_delay);

	tbuf[0] = NORMAL_MSG | SINGLE_DATA | IW7019_DEV_ADDR;
	tbuf[1] = addr & 0x7f;
	tbuf[2] = val;
	ret = spi_xfer(slave, 24, tbuf, 0, 0);
	if (bl_iw7019->cs_clk_delay)
		udelay(bl_iw7019->cs_clk_delay);
	spi_cs_deactivate(slave);

end:
	spi_release_bus(slave);
	return ret;
}

//iw7019 block write
static int iw7019_wregs(struct spi_slave *slave, u8 addr, u8 *val, int len)
{
	u8 tbuf[20];
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
	if (bl_iw7019->cs_hold_delay)
		udelay(bl_iw7019->cs_hold_delay);
	spi_cs_activate(slave);
	if (bl_iw7019->cs_clk_delay)
		udelay(bl_iw7019->cs_clk_delay);

	tbuf[0] = NORMAL_MSG | BLOCK_DATA | IW7019_DEV_ADDR;
	tbuf[1] = len;
	tbuf[2] = addr & 0x7f;
	size = (len + 3) * 8;
	memcpy(&tbuf[3], val, len);
	ret = spi_xfer(slave, size, tbuf, 0, 0);
	if (bl_iw7019->cs_clk_delay)
		udelay(bl_iw7019->cs_clk_delay);
	spi_cs_deactivate(slave);

end:
	spi_release_bus(slave);
	return ret;
}

static int iw7019_power_on_init(void)
{
	u8 addr, val;
	int i, ret = 0;

	for (i = 0; i < IW7019_INIT_ON_SIZE; i += iw7019_ld_config.cmd_size) {
		if (iw7019_ini_data[i] == 0xff) {
			if (iw7019_ini_data[i+3] > 0)
				mdelay(iw7019_ini_data[i+3]);
			break;
		} else if (iw7019_ini_data[i] == 0x0) {
			addr = iw7019_ini_data[i+1];
			val = iw7019_ini_data[i+2];
			ret = iw7019_wreg(bl_iw7019->spi, addr, val);
			udelay(1);
		}
		if (iw7019_ini_data[i+3] > 0)
			mdelay(iw7019_ini_data[i+3]);
	}

	return ret;
}

static int iw7019_hw_init(struct iw7019 *bl)
{
	struct aml_ldim_driver_s *ld_drv = aml_ldim_get_driver();

	aml_lcd_gpio_set(bl->en_gpio, bl->en_on);
	mdelay(2);
	ld_drv->pinmux_ctrl(1);
	mdelay(100);
	iw7019_power_on_init();

	return 0;
}

static int iw7019_hw_init_off(struct iw7019 *bl)
{
	struct aml_ldim_driver_s *ld_drv = aml_ldim_get_driver();

	ld_drv->pinmux_ctrl(0);
	aml_lcd_gpio_set(bl->en_gpio, bl->en_off);

	return 0;
}

static int iw7019_reset_handler(void)
{
	/* disable BL_ON once */
	LDIMPR("reset iw7019 BL_ON\n");
	aml_lcd_gpio_set(bl_iw7019->en_gpio, bl_iw7019->en_off);
	mdelay(1000);
	aml_lcd_gpio_set(bl_iw7019->en_gpio, bl_iw7019->en_on);
	mdelay(2);
	iw7019_power_on_init();

	return 0;
}

static int iw7019_smr(unsigned short *buf, unsigned char len)
{
	int i, offset, cmd_len;
	u8 val[13];
	int br0, br1;
	unsigned char bri_reg;
	unsigned char temp, reg_chk, clk_sel;

	if (len != 8) {
		LDIMERR("%s: data len %d invalid\n", __func__, len);
		return -1;
	}
	if (bl_iw7019->write_check) {
		offset = 1;
		val[0] = 0x0f;
		cmd_len = 13;
		bri_reg = IW7019_REG_BRIGHTNESS_CHK;
	} else {
		offset = 0;
		cmd_len = 12;
		bri_reg = IW7019_REG_BRIGHTNESS;
	}
	for (i = 0; i < 4; i++) {
		br0 = buf[i*2+0];
		br1 = buf[i*2+1];
		val[i*3+offset] = (br0 >> 4) & 0xff; /* br0[11~4] */
		val[i*3+offset+1] = ((br0 & 0xf) << 4) | ((br1 >> 8) & 0xf);
		/* br0[3~0]|br1[11~8] */
		val[i*3+offset+2] = br1 & 0xff; /* br1[7~0] */
	}
	iw7019_wregs(bl_iw7019->spi, bri_reg, val, cmd_len);

	if (bl_iw7019->write_check) { /* brightness write check */
		iw7019_rreg(bl_iw7019->spi, 0x00, &reg_chk);
		for (i = 1; i < 3; i++) {
			iw7019_rreg(bl_iw7019->spi, 0x00, &temp);
			if (temp != reg_chk)
				break;
		}
		clk_sel = (reg_chk >> 1) & 0x3;
		if ((reg_chk == 0xff) || (clk_sel == 0x1) || (clk_sel == 0x2)) {
			LDIMPR("%s: spi write failed, 0x00=0x%02x\n",
				__func__, reg_chk);
			iw7019_reset_handler();
		}
	}

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
	int parent_offset;
	int child_offset;
	char *propdata;
	char *en_gpio_str;
	unsigned char cmd_size;
	int i, j;

	bl_iw7019->write_check = 0;
	en_gpio_str = IW7019_GPIO_EN;
	bl_iw7019->en_gpio = aml_lcd_gpio_name_map_num(en_gpio_str);
	bl_iw7019->en_on = 1;
	bl_iw7019->en_off = 0;
	bl_iw7019->cs_hold_delay = 0;
	bl_iw7019->cs_clk_delay = 0;

#ifdef CONFIG_OF_LIBFDT
	parent_offset = fdt_path_offset(dt_addr, "/spicc");
	if (parent_offset < 0) {
		LDIMERR("not find /spicc node: %s\n",fdt_strerror(parent_offset));
		return -1;
	}

	child_offset = fdt_path_offset(dt_addr, "/spicc/iw7019");
	if (child_offset < 0) {
		LDIMERR("not find /spicc/iw7019 node: %s\n", fdt_strerror(child_offset));
		return -1;
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "en_gpio_name", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get en_gpio_name\n");
	} else {
		en_gpio_str = propdata;
		bl_iw7019->en_gpio = aml_lcd_gpio_name_map_num(en_gpio_str);
	}
	if (lcd_debug_print_flag)
		LDIMPR("iw7019 en_gpio=%s(%d)\n", en_gpio_str, bl_iw7019->en_gpio);
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "en_gpio_on_off", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get en_gpio_on_off\n");
	} else {
		bl_iw7019->en_on = be32_to_cpup((u32*)propdata);
		bl_iw7019->en_off = be32_to_cpup((((u32*)propdata)+1));
	}
	if (lcd_debug_print_flag) {
		LDIMPR("iw7019 en_on=%d, en_off=%d\n",
			bl_iw7019->en_on, bl_iw7019->en_off);
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "spi_cs_delay", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get spi_cs_delay\n");
	} else {
		bl_iw7019->cs_hold_delay = be32_to_cpup((u32*)propdata);
		bl_iw7019->cs_clk_delay = be32_to_cpup((((u32*)propdata)+1));
	}
	if (lcd_debug_print_flag) {
		LDIMPR("iw7019 cs_hold_delay=%dus, cs_clk_delay=%dus\n",
			bl_iw7019->cs_hold_delay, bl_iw7019->cs_clk_delay);
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "spi_write_check", NULL);
	if (propdata == NULL)
		LDIMERR("failed to get spi_write_check\n");
	else
		bl_iw7019->write_check = (unsigned char)(be32_to_cpup((u32*)propdata));
	if (lcd_debug_print_flag)
		LDIMPR("iw7019 write_check=%d\n", bl_iw7019->write_check);

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "dim_max_min", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get dim_max_min\n");
		iw7019_ld_config.dim_max = 0xfff;
		iw7019_ld_config.dim_min = 0x7f;
	} else {
		iw7019_ld_config.dim_max = be32_to_cpup((u32*)propdata);
		iw7019_ld_config.dim_min = be32_to_cpup((((u32*)propdata)+1));
	}
	if (lcd_debug_print_flag) {
		LDIMPR("iw7019 dim_max=0x%03x, dim_min=0x%03x\n",
			iw7019_ld_config.dim_max, iw7019_ld_config.dim_min);
	}

	/* get init_cmd */
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "cmd_size", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get cmd_size\n");
		iw7019_ld_config.cmd_size = 4;
	} else {
		iw7019_ld_config.cmd_size = (unsigned char)be32_to_cpup((u32*)propdata);
	}
	if (lcd_debug_print_flag)
		LDIMPR("iw7019 cmd_size=%d\n", iw7019_ld_config.cmd_size);
	cmd_size = iw7019_ld_config.cmd_size;
	if (cmd_size > 1) {
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "init_on", NULL);
		if (propdata == NULL) {
			LDIMERR("failed to get init_on\n");
			iw7019_ini_data[0] = 0xff;
			for (j = 1; j < cmd_size; j++)
				iw7019_ini_data[j] = 0x0;
		} else {
			i = 0;
			while (i < IW7019_INIT_ON_SIZE) {
				for (j = 0; j < cmd_size; j++) {
					iw7019_ini_data[i+j] =
						(unsigned char)(be32_to_cpup((((u32*)propdata)+i+j)));
				}
				if (iw7019_ini_data[i] == 0xff)
					break;
				else
					i += cmd_size;
			}
		}
	} else {
		iw7019_ld_config.cmd_size = 1;
	}
#endif

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
	spi_cs_deactivate(bl_iw7019->spi);

	return 0;
}
#endif

