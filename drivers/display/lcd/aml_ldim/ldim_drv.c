/*
 * drivers/display/lcd/lcd_bl_ldim/ldim_drv.c
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
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include <amlogic/aml_lcd.h>
#include <amlogic/aml_ldim.h>
#include "../aml_lcd_reg.h"
#include "../aml_lcd_common.h"
#include "ldim_drv.h"

#define LDIM_BRI_LEVEL_MAX    0xfff
#define LDIM_BRI_LEVEL_MIN    0x7f
static unsigned int ldim_blk_row = 1;
static unsigned int ldim_blk_col = 8;
static struct aml_ldim_driver_s ldim_driver;

static int ldim_on_flag;
static int ldim_level;
static int ldim_set_level(unsigned int level);

static struct bl_pwm_config_s ldim_pwm_config = {
	.index = 0,
	.pwm_method = BL_PWM_POSITIVE,
	.pwm_port = BL_PWM_MAX,
	.pwm_duty_max = 100,
	.pwm_duty_min = 1,
};

static unsigned int pwm_reg[6] = {
	PWM_PWM_A,
	PWM_PWM_B,
	PWM_PWM_C,
	PWM_PWM_D,
	PWM_PWM_E,
	PWM_PWM_F,
};

static int ldim_enable(void)
{
	if (ldim_driver.device_power_on)
		ldim_driver.device_power_on();
	if (ldim_level > 0)
		ldim_set_level(ldim_level);

	return 0;
}
static int ldim_disable(void)
{
	if (ldim_driver.device_power_off)
		ldim_driver.device_power_off();

	return 0;
}

static void ldim_brightness_update(unsigned int level)
{
	unsigned int size;
	unsigned int i;

	size = ldim_blk_row * ldim_blk_col;
	for (i = 0; i < size; i++)
		ldim_driver.ldim_matrix_2_spi[i] = (unsigned short)level;

	if (ldim_driver.device_bri_update)
		ldim_driver.device_bri_update(ldim_driver.ldim_matrix_2_spi, size);
	else
		LDIMPR("%s: device_bri_update is null\n", __func__);
}

static int ldim_set_level(unsigned int level)
{
	int ret = 0;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	unsigned int level_max, level_min;
	unsigned int dim_max, dim_min;

	if (ldim_on_flag == 0) {
		ldim_level = level;
		return 0;
	}

	level_max = lcd_drv->bl_config->level_max;
	level_min = lcd_drv->bl_config->level_min;
	if (ldim_driver.ld_config) {
		dim_max = ldim_driver.ld_config->dim_max;
		dim_min = ldim_driver.ld_config->dim_min;
	} else {
		dim_max = LDIM_BRI_LEVEL_MAX;
		dim_min = LDIM_BRI_LEVEL_MIN;
		LDIMERR("%s: no ld_config, use default\n", __func__);
	}
	level = dim_min + ((level - level_min) * (dim_max - dim_min)) /
			(level_max - level_min);
	level &= 0xfff;
	ldim_brightness_update(level);

	return ret;
}

static void ldim_set_duty_pwm(struct bl_pwm_config_s *bl_pwm)
{
	unsigned int pwm_hi = 0, pwm_lo = 0;
	unsigned int port = bl_pwm->pwm_port;
	unsigned int vs[4], ve[4], sw, n, i;

	bl_pwm->pwm_level = bl_pwm->pwm_cnt * bl_pwm->pwm_duty / 100;

	LDIMPR("pwm port %d: duty=%d%%, duty_max=%d, duty_min=%d\n",
		bl_pwm->pwm_port, bl_pwm->pwm_duty,
		bl_pwm->pwm_duty_max, bl_pwm->pwm_duty_min);

	switch (bl_pwm->pwm_method) {
	case BL_PWM_POSITIVE:
		pwm_hi = bl_pwm->pwm_level;
		pwm_lo = bl_pwm->pwm_cnt - bl_pwm->pwm_level;
		break;
	case BL_PWM_NEGATIVE:
		pwm_lo = bl_pwm->pwm_level;
		pwm_hi = bl_pwm->pwm_cnt - bl_pwm->pwm_level;
		break;
	default:
		LDIMERR("port %d: invalid pwm_method %d\n",
			port, bl_pwm->pwm_method);
		break;
	}
	LDIMPR("port %d: pwm_cnt=%d, pwm_hi=%d, pwm_lo=%d\n",
		port, bl_pwm->pwm_cnt, pwm_hi, pwm_lo);

	switch (port) {
	case BL_PWM_A:
	case BL_PWM_B:
	case BL_PWM_C:
	case BL_PWM_D:
	case BL_PWM_E:
	case BL_PWM_F:
		lcd_cbus_write(pwm_reg[port], (pwm_hi << 16) | pwm_lo);
		break;
	case BL_PWM_VS:
		memset(vs, 0xffff, sizeof(unsigned int) * 4);
		memset(ve, 0xffff, sizeof(unsigned int) * 4);
		n = bl_pwm->pwm_freq;
		sw = (bl_pwm->pwm_cnt * 10 / n + 5) / 10;
		pwm_hi = (pwm_hi * 10 / n + 5) / 10;
		pwm_hi = (pwm_hi > 1) ? pwm_hi : 1;
		if (lcd_debug_print_flag)
			LDIMPR("n=%d, sw=%d, pwm_high=%d\n", n, sw, pwm_hi);
		for (i = 0; i < n; i++) {
			vs[i] = 1 + (sw * i);
			ve[i] = vs[i] + pwm_hi - 1;
			if (lcd_debug_print_flag)
				LDIMPR("vs[%d]=%d, ve[%d]=%d\n", i, vs[i], i, ve[i]);
		}
		lcd_vcbus_write(VPU_VPU_PWM_V0, (ve[0] << 16) | (vs[0]));
		lcd_vcbus_write(VPU_VPU_PWM_V1, (ve[1] << 16) | (vs[1]));
		lcd_vcbus_write(VPU_VPU_PWM_V2, (ve[2] << 16) | (vs[2]));
		lcd_vcbus_write(VPU_VPU_PWM_V3, (ve[3] << 16) | (vs[3]));
		break;
	default:
		break;
	}
}

/* set ldim pwm_vs */
static int ldim_pwm_pinmux_ctrl(int status)
{
	int i;

	if (ldim_pwm_config.pwm_port >= BL_PWM_MAX)
		return 0;

	if (lcd_debug_print_flag)
		LDIMPR("%s: %d\n", __func__, status);

	if (status) {
		ldim_set_duty_pwm(&ldim_pwm_config);
		bl_pwm_ctrl(&ldim_pwm_config, 1);
		/* set pinmux */
		ldim_pwm_config.pinmux_flag = 1;
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (ldim_pwm_config.pinmux_clr[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_clr_mask(ldim_pwm_config.pinmux_clr[i][0],
				ldim_pwm_config.pinmux_clr[i][1]);
			if (lcd_debug_print_flag) {
				LDIMPR("%s: port=%d, pinmux_clr=%d,0x%08x\n",
					__func__, ldim_pwm_config.pwm_port,
					ldim_pwm_config.pinmux_clr[i][0],
					ldim_pwm_config.pinmux_clr[i][1]);
			}
			i++;
		}
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (ldim_pwm_config.pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_set_mask(ldim_pwm_config.pinmux_set[i][0],
				ldim_pwm_config.pinmux_set[i][1]);
			if (lcd_debug_print_flag) {
				LDIMPR("%s: port=%d, pinmux_set=%d,0x%08x\n",
					__func__, ldim_pwm_config.pwm_port,
					ldim_pwm_config.pinmux_set[i][0],
					ldim_pwm_config.pinmux_set[i][1]);
			}
			i++;
		}
	} else {
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (ldim_pwm_config.pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_clr_mask(ldim_pwm_config.pinmux_set[i][0],
				ldim_pwm_config.pinmux_set[i][1]);
			if (lcd_debug_print_flag) {
				LDIMPR("%s: port=%d, pinmux_clr=%d,0x%08x\n",
					__func__, ldim_pwm_config.pwm_port,
					ldim_pwm_config.pinmux_set[i][0],
					ldim_pwm_config.pinmux_set[i][1]);
			}
			i++;
		}
		ldim_pwm_config.pinmux_flag = 0;

		bl_pwm_ctrl(&ldim_pwm_config, 0);
	}

	return 0;
}

static struct aml_ldim_driver_s ldim_driver = {
	.ldim_pwm = &ldim_pwm_config,
	.ld_config = NULL,
	.ldim_matrix_2_spi = NULL,
	.power_on = ldim_enable,
	.power_off = ldim_disable,
	.set_level = ldim_set_level,
	.pinmux_ctrl = ldim_pwm_pinmux_ctrl,
	.device_power_on = NULL,
	.device_power_off = NULL,
	.device_bri_update = NULL,
};

struct aml_ldim_driver_s *aml_ldim_get_driver(void)
{
	return &ldim_driver;
}

#ifdef CONFIG_OF_LIBFDT
static int ldim_config_load_from_dts(char *dt_addr)
{
	int parent_offset;
	char *propdata;
	int temp, len = 0;
	int i;

	parent_offset = fdt_path_offset(dt_addr, "/aml_local_dimming");
	if (parent_offset < 0) {
		LDIMERR("not find /aml_local_dimming node %s\n", fdt_strerror(parent_offset));
		return -1;
	}
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "status", NULL);
	if (propdata == NULL) {
		LDIMPR("not find status, default to disabled\n");
		return -1;
	} else {
		if (strncmp(propdata, "okay", 2)) {
			LDIMPR("status disabled\n");
			return -1;
		}
	}

	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "ldim_region_row_col", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get ldim_region_row_col\n");
		ldim_blk_row = 1;
		ldim_blk_col = 8;
	} else {
		ldim_blk_row = be32_to_cpup((u32*)propdata);
		ldim_blk_col = be32_to_cpup((((u32*)propdata)+1));
	}

	ldim_pwm_config.index = 0;

	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "ldim_pwm_port", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get ldim_pwm_port\n");
		ldim_pwm_config.pwm_port = BL_PWM_MAX;
	} else {
		ldim_pwm_config.pwm_port = bl_pwm_str_to_pwm(propdata);
	}
	if (ldim_pwm_config.pwm_port == BL_PWM_MAX)
		return 0;

	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "ldim_pwm_attr", NULL);
	if (propdata == NULL) {
		LDIMERR("failed to get ldim_pwm_attr\n");
		ldim_pwm_config.pwm_method = BL_PWM_POSITIVE;
		if (ldim_pwm_config.pwm_port == BL_PWM_VS)
			ldim_pwm_config.pwm_freq = 1;
		else
			ldim_pwm_config.pwm_freq = 60;
		ldim_pwm_config.pwm_duty = 50;
	} else {
		ldim_pwm_config.pwm_method = be32_to_cpup((u32*)propdata);
		ldim_pwm_config.pwm_freq = be32_to_cpup((((u32*)propdata)+1));
		ldim_pwm_config.pwm_duty = be32_to_cpup((((u32*)propdata)+2));
	}
	if (ldim_pwm_config.pwm_port == BL_PWM_VS) {
		if (ldim_pwm_config.pwm_freq > 4) {
			LDIMERR("pwm_vs wrong freq %d\n", ldim_pwm_config.pwm_freq);
			ldim_pwm_config.pwm_freq = BL_FREQ_VS_DEFAULT;
		}
	} else {
		if (ldim_pwm_config.pwm_freq > XTAL_HALF_FREQ_HZ)
			ldim_pwm_config.pwm_freq = XTAL_HALF_FREQ_HZ;
	}

	/* pinmux */
	parent_offset = fdt_path_offset(dt_addr, "/pinmux/ldim_pwm_pin");
	if (parent_offset < 0) {
		LDIMERR("not find ldim_pwm_pin node\n");
		ldim_pwm_config.pinmux_set[0][0] = LCD_PINMUX_END;
		ldim_pwm_config.pinmux_set[0][1] = 0x0;
		ldim_pwm_config.pinmux_clr[0][0] = LCD_PINMUX_END;
		ldim_pwm_config.pinmux_clr[0][1] = 0x0;
		return -1;
	} else {
		propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
		if (propdata == NULL) {
			LDIMERR("failed to get amlogic,setmask\n");
			ldim_pwm_config.pinmux_set[0][0] = LCD_PINMUX_END;
			ldim_pwm_config.pinmux_set[0][1] = 0x0;
		} else {
			temp = len / 8;
			for (i = 0; i < temp; i++) {
				ldim_pwm_config.pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
				ldim_pwm_config.pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
			}
			if (temp < (LCD_PINMUX_NUM - 1)) {
				ldim_pwm_config.pinmux_set[temp][0] = LCD_PINMUX_END;
				ldim_pwm_config.pinmux_set[temp][1] = 0x0;
			}
		}
		propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
		if (propdata == NULL) {
			LDIMERR("failed to get amlogic,clrmask\n");
			ldim_pwm_config.pinmux_clr[0][0] = LCD_PINMUX_END;
			ldim_pwm_config.pinmux_clr[0][1] = 0x0;
		} else {
			temp = len / 8;
			for (i = 0; i < temp; i++) {
				ldim_pwm_config.pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
				ldim_pwm_config.pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
			}
			if (temp < (LCD_PINMUX_NUM - 1)) {
				ldim_pwm_config.pinmux_clr[temp][0] = LCD_PINMUX_END;
				ldim_pwm_config.pinmux_clr[temp][1] = 0x0;
			}
		}
		if (lcd_debug_print_flag) {
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (ldim_pwm_config.pinmux_set[i][0] == LCD_PINMUX_END)
					break;
				LDIMPR("pinmux set: %d, 0x%08x\n",
					ldim_pwm_config.pinmux_set[i][0], ldim_pwm_config.pinmux_set[i][1]);
				i++;
			}
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (ldim_pwm_config.pinmux_clr[i][0] == LCD_PINMUX_END)
					break;
				LDIMPR("pinmux clr: %d, 0x%08x\n",
					ldim_pwm_config.pinmux_clr[i][0], ldim_pwm_config.pinmux_clr[i][1]);
				i++;
			}
		}
	}

	return 0;
}
#endif

static int aml_ldim_device_probe(char *dt_addr)
{
	int ret = 0;

#ifdef CONFIG_AML_SPICC
#ifdef CONFIG_AML_LOCAL_DIMMING_IW7019
	ret = aml_ldim_iw7019_probe(dt_addr);
#endif
#endif

	return ret;
}

int aml_ldim_probe(char *dt_addr, int flag)
{
	unsigned int size;
	int ret = 0;

	ldim_on_flag = 0;
	ldim_level = 0;

	switch (flag) {
	case 0: /* dts */
#ifdef CONFIG_OF_LIBFDT
		if (dt_addr) {
			aml_ldim_device_probe(dt_addr);
			if (lcd_debug_print_flag)
				LDIMPR("load ldim_config from dts\n");
			ret = ldim_config_load_from_dts(dt_addr);
		}
#endif
		break;
	case 1:
		break;
	case 2:
		break;
	default:
		break;
	}
	size = ldim_blk_row * ldim_blk_col;
	ldim_driver.ldim_matrix_2_spi = (unsigned short *)malloc(sizeof(unsigned short) * size);
	if (ldim_driver.ldim_matrix_2_spi == NULL) {
		LDIMERR("ldim_matrix_2_spi malloc error\n");
		return -1;
	}

	return ret;
}

