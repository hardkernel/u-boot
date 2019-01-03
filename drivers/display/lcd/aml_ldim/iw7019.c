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
#include "ldim_dev_drv.h"

#define BUS_SPICC             2
#define NORMAL_MSG            (0<<7)
#define BROADCAST_MSG         (1<<7)
#define BLOCK_DATA            (0<<6)
#define SINGLE_DATA           (1<<6)
#define IW7019_DEV_ADDR        1
#define IW7019_REG_BRIGHTNESS      0x01
#define IW7019_REG_BRIGHTNESS_CHK  0x00

static int iw7019_on_flag;
static int iw7019_wr_err_cnt;

struct iw7019 {
	int cs_hold_delay;
	int cs_clk_delay;
	unsigned char cmd_size;
	unsigned char *init_data;
	unsigned int init_data_cnt;
	struct spi_slave *spi;
};
static struct iw7019 *bl_iw7019;

#if 0
static u8 iw7019_ini_data[LDIM_INIT_ON_SIZE] = {
#if 1
	/* step1: */
	0xc0, 0x01, 0x08,
	/* step2:disable ocp and otp */
	0xc0, 0x34, 0x14,
	0xc0, 0x10, 0x53,
	/* step3: */
	0xc0, 0x11, 0x00,
	0xc0, 0x12, 0x02,
	0xc0, 0x13, 0x00,
	0xc0, 0x14, 0x40,
	0xc0, 0x15, 0x06,
	0xc0, 0x16, 0x00,
	0xc0, 0x17, 0x80,
	0xc0, 0x18, 0x0a,
	0xc0, 0x19, 0x00,
	0xc0, 0x1a, 0xc0,
	0xc0, 0x1b, 0x0e,
	0xc0, 0x1c, 0x00,
	0xc0, 0x1d, 0x00,
	0xc0, 0x1e, 0x50,
	0xc0, 0x1f, 0x00,
	0xc0, 0x20, 0x63,
	0xc0, 0x21, 0xff,
	0xc0, 0x2a, 0xff,
	0xc0, 0x2b, 0x41,
	0xc0, 0x2c, 0x28,
	0xc0, 0x30, 0xff,
	0xc0, 0x31, 0x00,
	0xc0, 0x32, 0x0f,
	0xc0, 0x33, 0x40,
	0xc0, 0x34, 0x40,
	0xc0, 0x35, 0x00,
	0xc0, 0x3f, 0xa3,
	0xc0, 0x45, 0x00,
	0xc0, 0x47, 0x04,
	0xc0, 0x48, 0x60,
	0xc0, 0x4a, 0x0d,
	/* step4:set 50% brightness */
	0xc0, 0x01, 0x7f,
	0xc0, 0x02, 0xf7,
	0xc0, 0x03, 0xff,
	0xc0, 0x04, 0x7f,
	0xc0, 0x05, 0xf7,
	0xc0, 0x06, 0xff,
	0xc0, 0x07, 0x7f,
	0xc0, 0x08, 0xf7,
	0xc0, 0x09, 0xff,
	0xc0, 0x0a, 0x7f,
	0xc0, 0x0b, 0xf7,
	0xc0, 0x0c, 0xff,
	/* step5: */
	0xc0, 0x00, 0x09,
	/* step6: */
	0xc0, 0x34, 0x00,
	0xff, 0x00, 0x00,
#else
	/* step1: */
	0xc0, 0x00, 0x0E,
	0xc0, 0x1D, 0x01,
	/* step2:disable ocp and otp */
	0xc0, 0x34, 0x54,
	0xc0, 0x10, 0x93,
	/* step3: */
	0xc0, 0x11, 0x00,
	0xc0, 0x12, 0x12,
	0xc0, 0x13, 0x00,
	0xc0, 0x14, 0x40,
	0xc0, 0x15, 0x06,
	0xc0, 0x16, 0x00,
	0xc0, 0x17, 0x80,
	0xc0, 0x18, 0x0a,
	0xc0, 0x19, 0x00,
	0xc0, 0x1a, 0xc0,
	0xc0, 0x1b, 0x0e,
	0xc0, 0x1c, 0x00,
	0xc0, 0x1d, 0x01,
	0xc0, 0x1e, 0x50,
	0xc0, 0x1f, 0x00,
	0xc0, 0x20, 0x43,
	0xc0, 0x21, 0xff,
	0xc0, 0x2a, 0xff,
	0xc0, 0x2b, 0x01,
	0xc0, 0x2c, 0x28,
	0xc0, 0x30, 0xff,
	0xc0, 0x31, 0x00,
	0xc0, 0x3f, 0xa3,
	0xc0, 0x47, 0x04,
	0xc0, 0x48, 0x40, /*use external vsync or internal vsync*/
	0xc0, 0x4a, 0x45,
	0xc0, 0x4b, 0x0C,
	/*step4:set min brightness*/
	0xc0, 0x01, 0x07,
	0xc0, 0x02, 0xf0,
	0xc0, 0x03, 0x7f,
	0xc0, 0x04, 0x07,
	0xc0, 0x05, 0xf0,
	0xc0, 0x06, 0x7f,
	0xc0, 0x07, 0x07,
	0xc0, 0x08, 0xf0,
	0xc0, 0x09, 0x7f,
	0xc0, 0x0a, 0x07,
	0xc0, 0x0b, 0xf0,
	0xc0, 0x0c, 0x7f,
	/* step5: */
	0xc0, 0x00, 0x0F,
	/* step6: */
	0xc0, 0x34, 0x00,
	0xff, 0x00, 0x00,  /* ending */
#endif
};
#endif

//iw7019 register write
static int iw7019_wreg(struct spi_slave *spi, unsigned char addr, unsigned char val)
{
	unsigned char tbuf[3];
	int ret;

	if (lcd_debug_print_flag)
		LDIMPR("%s: 0x%02x = 0x%02x\n", __func__, addr, val);

	tbuf[0] = NORMAL_MSG | SINGLE_DATA | IW7019_DEV_ADDR;
	tbuf[1] = addr & 0x7f;
	tbuf[2] = val;
	ret = ldim_spi_write(spi, tbuf, 3);

	return ret;
}

//iw7019 register read
static int iw7019_rreg(struct spi_slave *spi, unsigned char addr, unsigned char *val)
{
	unsigned char tbuf[4], rbuf[4];
	int ret;

	tbuf[0] = NORMAL_MSG | SINGLE_DATA | IW7019_DEV_ADDR;
	tbuf[1] = addr | 0x80;
	tbuf[2] = 0;
	ret = ldim_spi_read(spi, tbuf, 3, rbuf, 1);
	*val = rbuf[3];

	return ret;
}

//iw7019 block write
static int iw7019_wregs(struct spi_slave *spi, unsigned char addr,
		unsigned char *val, int len)
{
	unsigned char tbuf[20];
	int ret, i;

	if (lcd_debug_print_flag) {
		LDIMPR("%s: ", __func__);
		for (i = 0; i < len; i++)
			printf("0x%02x ", val[i]);
		printf("\n");
	}

	tbuf[0] = NORMAL_MSG | BLOCK_DATA | IW7019_DEV_ADDR;
	tbuf[1] = len;
	tbuf[2] = addr & 0x7f;
	memcpy(&tbuf[3], val, len);
	ret = ldim_spi_write(spi, tbuf, (len + 3));

	return ret;
}

static int ldim_power_cmd_dynamic_size(void)
{
	unsigned char *table;
	int i = 0, j, step = 0, max_len = 0;
	unsigned char type, cmd_size;
	int delay_ms, ret = 0;

	table = bl_iw7019->init_data;
	max_len = bl_iw7019->init_data_cnt;

	while ((i + 1) < max_len) {
		type = table[i];
		if (type == LCD_EXT_CMD_TYPE_END)
			break;
		if (lcd_debug_print_flag) {
			LDIMPR("%s: step %d: type=0x%02x, cmd_size=%d\n",
				__func__, step, type, table[i+1]);
		}
		cmd_size = table[i+1];
		if (cmd_size == 0)
			goto power_cmd_dynamic_next;
		if ((i + 2 + cmd_size) > max_len)
			break;

		if (type == LCD_EXT_CMD_TYPE_NONE) {
			/* do nothing */
		} else if (type == LCD_EXT_CMD_TYPE_DELAY) {
			delay_ms = 0;
			for (j = 0; j < cmd_size; j++)
				delay_ms += table[i+2+j];
			if (delay_ms > 0)
				mdelay(delay_ms);
		} else if (type == LCD_EXT_CMD_TYPE_CMD) {
			ret = iw7019_wreg(bl_iw7019->spi,
				table[i+2], table[i+3]);
			udelay(1);
		} else if (type == LCD_EXT_CMD_TYPE_CMD_DELAY) {
			ret = iw7019_wreg(bl_iw7019->spi,
				table[i+2], table[i+3]);
			udelay(1);
			if (table[i+4] > 0)
				mdelay(table[i+4]);
		} else {
			LDIMERR("%s: type 0x%02x invalid\n", __func__, type);
		}
power_cmd_dynamic_next:
		i += (cmd_size + 2);
		step++;
	}

	return ret;
}

static int ldim_power_cmd_fixed_size(void)
{
	unsigned char *table;
	int i = 0, j, step = 0, max_len = 0;
	unsigned char type, cmd_size;
	int delay_ms, ret = 0;

	cmd_size = bl_iw7019->cmd_size;
	if (cmd_size < 2) {
		LDIMERR("%s: invalid cmd_size %d\n", __func__, cmd_size);
		return -1;
	}

	table = bl_iw7019->init_data;
	max_len = bl_iw7019->init_data_cnt;

	while ((i + cmd_size) <= max_len) {
		type = table[i];
		if (type == LCD_EXT_CMD_TYPE_END)
			break;
		if (lcd_debug_print_flag) {
			LDIMPR("%s: step %d: type=0x%02x, cmd_size=%d\n",
				__func__, step, type, cmd_size);
		}
		if (type == LCD_EXT_CMD_TYPE_NONE) {
			/* do nothing */
		} else if (type == LCD_EXT_CMD_TYPE_DELAY) {
			delay_ms = 0;
			for (j = 0; j < (cmd_size - 1); j++)
				delay_ms += table[i+1+j];
			if (delay_ms > 0)
				mdelay(delay_ms);
		} else if (type == LCD_EXT_CMD_TYPE_CMD) {
			ret = iw7019_wreg(bl_iw7019->spi,
				table[i+1], table[i+2]);
			udelay(1);
		} else if (type == LCD_EXT_CMD_TYPE_CMD_DELAY) {
			ret = iw7019_wreg(bl_iw7019->spi,
				table[i+1], table[i+2]);
			udelay(1);
			if (table[i+3] > 0)
				mdelay(table[i+3]);
		} else {
			LDIMERR("%s: type 0x%02x invalid\n", __func__, type);
		}
		i += cmd_size;
		step++;
	}

	return ret;
}

static int iw7019_power_on_init(void)
{
	unsigned char cmd_size;
	int ret = 0;

	cmd_size = bl_iw7019->cmd_size;
	if (cmd_size < 2) {
		LDIMERR("%s: invalid cmd_size %d\n", __func__, cmd_size);
		return -1;
	}

	if (cmd_size == LCD_EXT_CMD_SIZE_DYNAMIC)
		ret = ldim_power_cmd_dynamic_size();
	else
		ret = ldim_power_cmd_fixed_size();

	iw7019_wr_err_cnt = 0;

	return ret;
}

static int iw7019_hw_init_on(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio, ldim_drv->ldev_conf->en_gpio_on);
	mdelay(2);
	ldim_set_duty_pwm(&(ldim_drv->ldev_conf->ldim_pwm_config));
	ldim_set_duty_pwm(&(ldim_drv->ldev_conf->analog_pwm_config));
	ldim_drv->pinmux_ctrl(1);
	mdelay(100);
	iw7019_power_on_init();

	return 0;
}

static int iw7019_hw_init_off(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	ldim_drv->pinmux_ctrl(0);
	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio, ldim_drv->ldev_conf->en_gpio_off);

	return 0;
}

static int iw7019_reset_handler(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	/* disable BL_ON once */
	LDIMPR("reset iw7019 BL_ON\n");
	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio, ldim_drv->ldev_conf->en_gpio_off);
	mdelay(1000);
	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio, ldim_drv->ldev_conf->en_gpio_on);
	mdelay(2);
	iw7019_power_on_init();

	return 0;
}

static int iw7019_short_reset_handler(void)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();

	/* disable BL_ON once */
	LDIMPR("short reset iw7019 BL_ON\n");

	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio,
		ldim_drv->ldev_conf->en_gpio_off);
	mdelay(300);
	ldim_set_gpio(ldim_drv->ldev_conf->en_gpio,
		ldim_drv->ldev_conf->en_gpio_on);
	mdelay(2);
	iw7019_power_on_init();

	return 0;
}

static unsigned int iw7019_get_value(unsigned int level)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();
	unsigned int val;
	unsigned int dim_max, dim_min;

	dim_max = ldim_drv->ldev_conf->dim_max;
	dim_min = ldim_drv->ldev_conf->dim_min;

	val = dim_min + ((level * (dim_max - dim_min)) / LD_DATA_MAX);

	return val;
}

static int iw7019_smr(unsigned short *buf, unsigned char len)
{
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();
	int i, j, offset, cmd_len;
	unsigned char val[13];
	int br0, br1;
	unsigned char bri_reg;
	unsigned char temp, reg_chk, clk_sel, wr_err_flag = 0;

	if (iw7019_on_flag == 0) {
		if (lcd_debug_print_flag)
			LDIMPR("%s: on_flag=%d\n", __func__, iw7019_on_flag);
		return 0;
	}
	if (len != 8) {
		LDIMERR("%s: data len %d invalid\n", __func__, len);
		return -1;
	}
	if (ldim_drv->ldev_conf->write_check) {
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
		br0 = iw7019_get_value(buf[i*2+0]);
		br1 = iw7019_get_value(buf[i*2+1]);
		val[i*3+offset] = (br0 >> 4) & 0xff; /* br0[11~4] */
		val[i*3+offset+1] = ((br0 & 0xf) << 4) | ((br1 >> 8) & 0xf);
		/* br0[3~0]|br1[11~8] */
		val[i*3+offset+2] = br1 & 0xff; /* br1[7~0] */
	}
	iw7019_wregs(bl_iw7019->spi, bri_reg, val, cmd_len);

	if (ldim_drv->ldev_conf->write_check) { /* brightness write check */
		/* reg 0x00 check */
		iw7019_rreg(bl_iw7019->spi, 0x00, &reg_chk);
		for (i = 1; i < 3; i++) {
			iw7019_rreg(bl_iw7019->spi, 0x00, &temp);
			if (temp != reg_chk)
				goto iw7019_smr_write_chk2;
		}
		clk_sel = (reg_chk >> 1) & 0x3;
		if ((reg_chk == 0xff) || (clk_sel == 0x1) || (clk_sel == 0x2)) {
			LDIMERR("%s: reg check failed, 0x00=0x%02x\n",
				__func__, reg_chk);
			iw7019_reset_handler();
			goto iw7019_smr_end;
		}
iw7019_smr_write_chk2:
		/* reg brightness check */
		for (j = 0x01; j <= 0x0c; j++) {
			for (i = 1; i < 3; i++) {
				iw7019_rreg(bl_iw7019->spi, j, &reg_chk);
				if (val[j] == reg_chk) {
					wr_err_flag = 0;
					break;
				} else {
					LDIMERR("%s: failed, 0x%02x=0x%02x, w_val=0x%02x\n",
						__func__, j, reg_chk, val[j]);
					iw7019_wreg(bl_iw7019->spi, j, val[j]);
					wr_err_flag = 1;
				}
			}
			if (wr_err_flag)
				iw7019_wr_err_cnt++;
		}
		if (iw7019_wr_err_cnt >= 60) {
			LDIMERR("%s: spi write failed\n", __func__);
			iw7019_short_reset_handler();
			goto iw7019_smr_end;
		}
	}

iw7019_smr_end:
	return 0;
}

static int iw7019_power_on(void)
{
	iw7019_hw_init_on();
	iw7019_on_flag = 1;

	LDIMPR("%s: ok\n", __func__);
	return 0;
}

static int iw7019_power_off(void)
{
	iw7019_on_flag = 0;
	iw7019_hw_init_off();

	LDIMPR("%s: ok\n", __func__);
	return 0;
}

static int iw7019_ldim_driver_update(struct aml_ldim_driver_s *ldim_drv)
{
	ldim_drv->device_power_on = iw7019_power_on;
	ldim_drv->device_power_off = iw7019_power_off;
	ldim_drv->device_bri_update = iw7019_smr;
	return 0;
}

int ldim_dev_iw7019_probe(struct aml_ldim_driver_s *ldim_drv)
{
	if (ldim_drv->spi_info->spi == NULL) {
		LDIMERR("%s: spi is null\n", __func__);
		return -1;
	}

	bl_iw7019 = (struct iw7019 *)malloc(sizeof(struct iw7019));
	if (bl_iw7019 == NULL) {
		LDIMERR("iw7019 malloc error\n");
		return -1;
	}
	memset(bl_iw7019, 0, sizeof(struct iw7019));

	iw7019_on_flag = 0;
	iw7019_wr_err_cnt = 0;

	bl_iw7019->spi = ldim_drv->spi_info->spi;
	bl_iw7019->cs_hold_delay = ldim_drv->ldev_conf->cs_hold_delay;
	bl_iw7019->cs_clk_delay = ldim_drv->ldev_conf->cs_clk_delay;
	bl_iw7019->cmd_size = ldim_drv->ldev_conf->cmd_size;
	bl_iw7019->init_data = ldim_drv->ldev_conf->init_on;
	bl_iw7019->init_data_cnt = ldim_drv->ldev_conf->init_on_cnt;

	iw7019_ldim_driver_update(ldim_drv);

	printf("%s: ok\n", __func__);

	return 0;
}

int ldim_dev_iw7019_remove(struct aml_ldim_driver_s *ldim_drv)
{
	if (bl_iw7019) {
		free(bl_iw7019);
		bl_iw7019 = NULL;
	}
	return 0;
}

