/*
 * drivers/display/lcd/aml_lcd_bl.c
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
#ifdef CONFIG_AML_LOCAL_DIMMING
#include <amlogic/aml_ldim.h>
#endif
#ifdef CONFIG_AML_BL_EXTERN
#include <amlogic/aml_bl_extern.h>
#endif
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"

static unsigned int bl_off_policy;
static unsigned int bl_status;

static void bl_set_pwm_gpio_check(struct bl_pwm_config_s *bl_pwm);

static struct bl_config_s *bl_check_valid(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct bl_config_s *bconf;
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_s *bl_ext;
#endif
#ifdef CONFIG_AML_LOCAL_DIMMING
	struct aml_ldim_driver_s *ldim_drv;
#endif

	bconf = lcd_drv->bl_config;
	switch (bconf->method) {
	case BL_CTRL_PWM:
		if (bconf->bl_pwm == NULL) {
			LCDERR("bl: no bl_pwm struct\n");
			bconf = NULL;
		}
		break;
	case BL_CTRL_PWM_COMBO:
		if (bconf->bl_pwm_combo0 == NULL) {
			LCDERR("bl: no bl_pwm_combo_0 struct\n");
			bconf = NULL;
		}
		if (bconf->bl_pwm_combo1 == NULL) {
			LCDERR("bl: no bl_pwm_combo_1 struct\n");
			bconf = NULL;
		}
		break;
	case BL_CTRL_GPIO:
		break;
#ifdef CONFIG_AML_LOCAL_DIMMING
	case BL_CTRL_LOCAL_DIMMING:
		ldim_drv = aml_ldim_get_driver();
		if (ldim_drv == NULL) {
			LCDERR("bl: no ldim driver\n");
			bconf = NULL;
		}
		break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
	case BL_CTRL_EXTERN:
		bl_ext = aml_bl_extern_get_driver();
		if (bl_ext == NULL) {
			LCDERR("bl: no bl_extern driver\n");
			bconf = NULL;
		}
		break;
#endif
	default:
		if (lcd_debug_print_flag)
			LCDPR("bl: invalid control_method: %d\n", bconf->method);
		bconf = NULL;
		break;
	}
	return bconf;
}

static void bl_pwm_pinmux_gpio_set(int pwm_index, int gpio_level)
{
	struct bl_config_s *bconf;
	struct bl_pwm_config_s *bl_pwm = NULL;
	int gpio;
	char *str;
	int i;

	bconf = bl_check_valid();
	if (bconf == NULL)
		return;

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bl_pwm = bconf->bl_pwm;
		break;
	case BL_CTRL_PWM_COMBO:
		if (pwm_index == 0)
			bl_pwm = bconf->bl_pwm_combo0;
		else
			bl_pwm = bconf->bl_pwm_combo1;
		break;
	default:
		LCDERR("bl: %s: invalid method %d\n", __func__, bconf->method);
		break;
	}
	if (bl_pwm == NULL)
		return;

	if (lcd_debug_print_flag) {
		LCDPR("bl: %s: pwm_port=%d, pinmux_flag=%d\n",
			__func__, bl_pwm->pwm_port, bl_pwm->pinmux_flag);
	}
	if (bl_pwm->pinmux_flag > 0) {
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (bl_pwm->pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_clr_mask(bl_pwm->pinmux_set[i][0],
				bl_pwm->pinmux_set[i][1]);
			if (lcd_debug_print_flag) {
			LCDPR("bl: %s: port=%d, pinmux_clr=%d,0x%08x\n",
				__func__, bl_pwm->pwm_port,
				bl_pwm->pinmux_set[i][0], bl_pwm->pinmux_set[i][1]);
			}
			i++;
		}
		bl_pwm->pinmux_flag = 0;
	}
	/* set gpio */
	if (bl_pwm->pwm_gpio >= BL_GPIO_NUM_MAX) {
		gpio = LCD_GPIO_MAX;
	} else {
		str = bconf->gpio_name[bl_pwm->pwm_gpio];
		gpio = aml_lcd_gpio_name_map_num(str);
	}
	if (gpio < LCD_GPIO_MAX)
		aml_lcd_gpio_set(gpio, gpio_level);
}

static void bl_pwm_pinmux_gpio_clr(unsigned int pwm_index)
{
	struct bl_config_s *bconf;
	struct bl_pwm_config_s *bl_pwm = NULL;
	int i;

	bconf = bl_check_valid();
	if (bconf == NULL)
		return;

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bl_pwm = bconf->bl_pwm;
		break;
	case BL_CTRL_PWM_COMBO:
		if (pwm_index == 0)
			bl_pwm = bconf->bl_pwm_combo0;
		else
			bl_pwm = bconf->bl_pwm_combo1;
		break;
	default:
		LCDERR("bl: %s: invalid method %d\n", __func__, bconf->method);
		break;
	}
	if (bl_pwm == NULL)
		return;

	if (lcd_debug_print_flag) {
		LCDPR("bl: %s: pwm_port=%d, pinmux_flag=%d\n",
			__func__, bl_pwm->pwm_port, bl_pwm->pinmux_flag);
	}
	if (bl_pwm->pinmux_flag > 0)
		return;

	/* set pinmux */
	i = 0;
	while (i < LCD_PINMUX_NUM) {
		if (bl_pwm->pinmux_set[i][0] == LCD_PINMUX_END)
			break;
		lcd_pinmux_set_mask(bl_pwm->pinmux_set[i][0],
			bl_pwm->pinmux_set[i][1]);
		if (lcd_debug_print_flag) {
			LCDPR("bl: %s: port=%d, pinmux_set=%d,0x%08x\n",
				__func__, bl_pwm->pwm_port,
				bl_pwm->pinmux_set[i][0], bl_pwm->pinmux_set[i][1]);
		}
		i++;
	}
	bl_pwm->pinmux_flag = 1;
}

static void bl_pwm_pinmux_ctrl(struct bl_config_s *bconf, int status)
{
	int gpio;
	char *str;
	int i;

	if (lcd_debug_print_flag)
		LCDPR("bl: %s: %d\n", __func__, status);
	if (status) {
		/* set pinmux */
		switch (bconf->method) {
		case BL_CTRL_PWM:
			bl_set_pwm_gpio_check(bconf->bl_pwm);
			break;
		case BL_CTRL_PWM_COMBO:
			bl_set_pwm_gpio_check(bconf->bl_pwm_combo0);
			bl_set_pwm_gpio_check(bconf->bl_pwm_combo1);
			break;
		default:
			break;
		}
	} else {
		switch (bconf->method) {
		case BL_CTRL_PWM:
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (bconf->bl_pwm->pinmux_set[i][0] == LCD_PINMUX_END)
					break;
				lcd_pinmux_clr_mask(bconf->bl_pwm->pinmux_set[i][0],
					bconf->bl_pwm->pinmux_set[i][1]);
				if (lcd_debug_print_flag) {
					LCDPR("bl: %s: port=%d, pinmux_clr=%d,0x%08x\n",
						__func__, bconf->bl_pwm->pwm_port,
						bconf->bl_pwm->pinmux_set[i][0],
						bconf->bl_pwm->pinmux_set[i][1]);
				}
				i++;
			}
			bconf->bl_pwm->pinmux_flag = 0;

			if (bconf->bl_pwm->pwm_gpio >= BL_GPIO_NUM_MAX) {
				gpio = LCD_GPIO_MAX;
			} else {
				str = bconf->gpio_name[bconf->bl_pwm->pwm_gpio];
				gpio = aml_lcd_gpio_name_map_num(str);
			}
			if (gpio < LCD_GPIO_MAX)
				aml_lcd_gpio_set(gpio, bconf->bl_pwm->pwm_gpio_off);
			break;
		case BL_CTRL_PWM_COMBO:
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (bconf->bl_pwm_combo0->pinmux_set[i][0] == LCD_PINMUX_END)
					break;
				lcd_pinmux_clr_mask(bconf->bl_pwm_combo0->pinmux_set[i][0],
					bconf->bl_pwm_combo0->pinmux_set[i][1]);
				if (lcd_debug_print_flag) {
					LCDPR("bl: %s: port=%d, pinmux_clr=%d,0x%08x\n",
						__func__, bconf->bl_pwm_combo0->pwm_port,
						bconf->bl_pwm_combo0->pinmux_set[i][0],
						bconf->bl_pwm_combo0->pinmux_set[i][1]);
				}
				i++;
			}
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (bconf->bl_pwm_combo1->pinmux_set[i][0] == LCD_PINMUX_END)
					break;
				lcd_pinmux_clr_mask(bconf->bl_pwm_combo1->pinmux_set[i][0],
					bconf->bl_pwm_combo1->pinmux_set[i][1]);
				if (lcd_debug_print_flag) {
					LCDPR("bl: %s: port=%d, pinmux_clr=%d,0x%08x\n",
						__func__, bconf->bl_pwm_combo1->pwm_port,
						bconf->bl_pwm_combo1->pinmux_set[i][0],
						bconf->bl_pwm_combo1->pinmux_set[i][1]);
				}
				i++;
			}
			bconf->bl_pwm_combo0->pinmux_flag = 0;
			bconf->bl_pwm_combo1->pinmux_flag = 0;

			if (bconf->bl_pwm_combo0->pwm_gpio >= BL_GPIO_NUM_MAX) {
				gpio = LCD_GPIO_MAX;
			} else {
				str = bconf->gpio_name[bconf->bl_pwm_combo0->pwm_gpio];
				gpio = aml_lcd_gpio_name_map_num(str);
			}
			if (gpio < LCD_GPIO_MAX)
				aml_lcd_gpio_set(gpio, bconf->bl_pwm_combo0->pwm_gpio_off);
			if (bconf->bl_pwm_combo1->pwm_gpio >= BL_GPIO_NUM_MAX) {
				gpio = LCD_GPIO_MAX;
			} else {
				str = bconf->gpio_name[bconf->bl_pwm_combo1->pwm_gpio];
				gpio = aml_lcd_gpio_name_map_num(str);
			}
			if (gpio < LCD_GPIO_MAX)
				aml_lcd_gpio_set(gpio, bconf->bl_pwm_combo1->pwm_gpio_off);
			break;
		default:
			break;
		}
	}
}

static unsigned int pwm_misc[6][5] = {
	/* pwm_reg,         pre_div, clk_sel, clk_en, pwm_en*/
	{PWM_MISC_REG_AB,   8,       4,       15,     0,},
	{PWM_MISC_REG_AB,   16,      6,       23,     0,},
	{PWM_MISC_REG_CD,   8,       4,       15,     0,},
	{PWM_MISC_REG_CD,   16,      6,       23,     0,},
	{PWM_MISC_REG_EF,   8,       4,       15,     0,},
	{PWM_MISC_REG_EF,   16,      6,       23,     0,},
};

static unsigned int pwm_reg[6] = {
	PWM_PWM_A,
	PWM_PWM_B,
	PWM_PWM_C,
	PWM_PWM_D,
	PWM_PWM_E,
	PWM_PWM_F,
};

static void bl_pwm_config_init(struct bl_pwm_config_s *bl_pwm)
{
	unsigned int freq, pre_div, cnt;
	int i;

	if (bl_pwm == NULL) {
		LCDERR("bl: %s: bl_pwm is NULL\n", __func__);
		return;
	}
	if (bl_pwm->pwm_port >= BL_PWM_MAX)
		return;

	if (lcd_debug_print_flag) {
		LCDPR("bl: %s pwm_port %d: freq = %u\n",
			__func__, bl_pwm->pwm_port, bl_pwm->pwm_freq);
	}
	freq = bl_pwm->pwm_freq;
	switch (bl_pwm->pwm_port) {
	case BL_PWM_VS:
		cnt = lcd_vcbus_read(ENCL_VIDEO_MAX_LNCNT) + 1;
		bl_pwm->pwm_cnt = cnt;
		bl_pwm->pwm_pre_div = 0;
		if (lcd_debug_print_flag)
			LCDPR("bl: pwm_cnt = %u\n", bl_pwm->pwm_cnt);
		break;
	default:
		for (i = 0; i < 0x7f; i++) {
			pre_div = i;
			cnt = XTAL_FREQ_HZ / (freq * (pre_div + 1)) - 2;
			if (cnt <= 0xffff) /* 16bit */
				break;
		}
		bl_pwm->pwm_cnt = cnt;
		bl_pwm->pwm_pre_div = pre_div;
		if (lcd_debug_print_flag)
			LCDPR("bl: pwm_cnt = %u, pwm_pre_div = %u\n", cnt, pre_div);
		break;
	}

	if (bl_pwm->pwm_duty_max > 100) {
		bl_pwm->pwm_max = (bl_pwm->pwm_cnt * bl_pwm->pwm_duty_max / 255);
		bl_pwm->pwm_min = (bl_pwm->pwm_cnt * bl_pwm->pwm_duty_min / 255);
	} else {
		bl_pwm->pwm_max = (bl_pwm->pwm_cnt * bl_pwm->pwm_duty_max / 100);
		bl_pwm->pwm_min = (bl_pwm->pwm_cnt * bl_pwm->pwm_duty_min / 100);
	}
	if (lcd_debug_print_flag)
		LCDPR("bl: pwm_max = %u, pwm_min = %u\n", bl_pwm->pwm_max, bl_pwm->pwm_min);
}

void aml_bl_pwm_config_update(struct bl_config_s *bconf)
{
#ifdef CONFIG_AML_LOCAL_DIMMING
	struct aml_ldim_driver_s *ldim_drv;
#endif

	if (bconf == NULL) {
		LCDERR("bl: bconf is null\n");
		return;
	}

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bl_pwm_config_init(bconf->bl_pwm);
		break;
	case BL_CTRL_PWM_COMBO:
		bl_pwm_config_init(bconf->bl_pwm_combo0);
		bl_pwm_config_init(bconf->bl_pwm_combo1);
		break;
#ifdef CONFIG_AML_LOCAL_DIMMING
	case BL_CTRL_LOCAL_DIMMING:
		ldim_drv = aml_ldim_get_driver();
		if (ldim_drv) {
			if (ldim_drv->ldev_conf)
				bl_pwm_config_init(&ldim_drv->ldev_conf->pwm_config);
			else
				LCDERR("bl: ldim_config is null\n");
		} else {
			LCDERR("bl: ldim_drv is null\n");
		}
		break;
#endif
	default:
		break;
	}
}

static unsigned int bl_level_mapping(unsigned int level)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	unsigned int mid = lcd_drv->bl_config->level_mid;
	unsigned int mid_map =lcd_drv->bl_config->level_mid_mapping;
	unsigned int max = lcd_drv->bl_config->level_max;
	unsigned int min = lcd_drv->bl_config->level_min;

	if (mid == mid_map)
		return level;

	level = level > max ? max : level;
	if ((level >= mid) && (level <= max))
		level = (((level - mid) * (max - mid_map)) / (max - mid)) + mid_map;
	else if ((level >= min) && (level < mid))
		level = (((level - min) * (mid_map - min)) / (mid - min)) + min;
	else
		level = 0;

	return level;
}

static void bl_set_pwm_gpio_check(struct bl_pwm_config_s *bl_pwm)
{
	unsigned int pwm_index, gpio_level;

	pwm_index = bl_pwm->index;

	/* pwm duty 100% or 0% special control */
	if (bl_pwm->pwm_duty_max > 100) {
		if ((bl_pwm->pwm_duty == 0) || (bl_pwm->pwm_duty == 255)) {
			switch (bl_pwm->pwm_method) {
			case BL_PWM_POSITIVE:
				if (bl_pwm->pwm_duty == 0)
					gpio_level = 0;
				else
					gpio_level = 1;
				break;
			case BL_PWM_NEGATIVE:
				if (bl_pwm->pwm_duty == 0)
					gpio_level = 1;
				else
					gpio_level = 0;
				break;
			default:
				LCDERR("bl: %s: port=%d: invalid pwm_method %d\n",
					__func__, bl_pwm->pwm_port, bl_pwm->pwm_method);
				gpio_level = 0;
				break;
			}
			if (lcd_debug_print_flag) {
				LCDPR("bl: %s: pwm port=%d, duty=%d%%, switch to gpio %d\n",
					__func__, bl_pwm->pwm_port, bl_pwm->pwm_duty*100/255, gpio_level);
			}
			bl_pwm_pinmux_gpio_set(pwm_index, gpio_level);
		} else {
			if (lcd_debug_print_flag) {
				LCDPR("bl: %s: pwm_port=%d set as pwm\n",
					__func__, bl_pwm->pwm_port);
			}
			bl_pwm_pinmux_gpio_clr(pwm_index);
		}
	} else {
		if ((bl_pwm->pwm_duty == 0) || (bl_pwm->pwm_duty == 100)) {
			switch (bl_pwm->pwm_method) {
			case BL_PWM_POSITIVE:
				if (bl_pwm->pwm_duty == 0)
					gpio_level = 0;
				else
					gpio_level = 1;
				break;
			case BL_PWM_NEGATIVE:
				if (bl_pwm->pwm_duty == 0)
					gpio_level = 1;
				else
					gpio_level = 0;
				break;
			default:
				LCDERR("bl: %s: port=%d: invalid pwm_method %d\n",
					__func__, bl_pwm->pwm_port, bl_pwm->pwm_method);
				gpio_level = 0;
				break;
			}
			if (lcd_debug_print_flag) {
				LCDPR("bl: %s: pwm port=%d, duty=%d%%, switch to gpio %d\n",
					__func__, bl_pwm->pwm_port, bl_pwm->pwm_duty, gpio_level);
			}
			bl_pwm_pinmux_gpio_set(pwm_index, gpio_level);
		} else {
			if (lcd_debug_print_flag) {
				LCDPR("bl: %s: pwm_port=%d set as pwm\n",
					__func__, bl_pwm->pwm_port);
			}
			bl_pwm_pinmux_gpio_clr(pwm_index);
		}
	}
}

static void bl_set_pwm(struct bl_pwm_config_s *bl_pwm)
{
	unsigned int pwm_hi = 0, pwm_lo = 0;
	unsigned int port = bl_pwm->pwm_port;
	unsigned int vs[4], ve[4], sw, n, i, pol = 0;

	if (bl_status > 0)
		bl_set_pwm_gpio_check(bl_pwm);

	switch (bl_pwm->pwm_method) {
	case BL_PWM_POSITIVE:
		pwm_hi = bl_pwm->pwm_level;
		pwm_lo = bl_pwm->pwm_cnt - bl_pwm->pwm_level;
		pol = 0;
		break;
	case BL_PWM_NEGATIVE:
		pwm_lo = bl_pwm->pwm_level;
		pwm_hi = bl_pwm->pwm_cnt - bl_pwm->pwm_level;
		pol = 1;
		break;
	default:
		LCDERR("bl: port %d: invalid pwm_method %d\n", port, bl_pwm->pwm_method);
		break;
	}

	switch (port) {
	case BL_PWM_A:
	case BL_PWM_B:
	case BL_PWM_C:
	case BL_PWM_D:
	case BL_PWM_E:
	case BL_PWM_F:
		lcd_cbus_write(pwm_reg[port], (pwm_hi << 16) | pwm_lo);
		if (lcd_debug_print_flag)
			LCDPR("bl: pwm_reg=0x%08x\n", lcd_cbus_read(pwm_reg[port]));
		break;
	case BL_PWM_VS:
		pwm_hi = bl_pwm->pwm_level;
		memset(vs, 0xffff, sizeof(unsigned int) * 4);
		memset(ve, 0xffff, sizeof(unsigned int) * 4);
		n = bl_pwm->pwm_freq;
		sw = (bl_pwm->pwm_cnt * 10 / n + 5) / 10;
		pwm_hi = (pwm_hi * 10 / n + 5) / 10;
		pwm_hi = (pwm_hi > 1) ? pwm_hi : 1;
		if (lcd_debug_print_flag)
			LCDPR("bl: n=%d, sw=%d, pwm_high=%d\n", n, sw, pwm_hi);
		for (i = 0; i < n; i++) {
			vs[i] = 1 + (sw * i);
			ve[i] = vs[i] + pwm_hi - 1;
			if (lcd_debug_print_flag) {
				LCDPR("bl: vs[%d]=%d, ve[%d]=%d\n",
					i, vs[i], i, ve[i]);
			}
		}
		lcd_vcbus_write(VPU_VPU_PWM_V0, (pol << 31) |
				(ve[0] << 16) | (vs[0]));
		lcd_vcbus_write(VPU_VPU_PWM_V1, (ve[1] << 16) | (vs[1]));
		lcd_vcbus_write(VPU_VPU_PWM_V2, (ve[2] << 16) | (vs[2]));
		lcd_vcbus_write(VPU_VPU_PWM_V3, (ve[3] << 16) | (vs[3]));
		break;
	default:
		break;
	}
}

static void bl_set_level_pwm(struct bl_pwm_config_s *bl_pwm, unsigned int level)
{
	unsigned int min = bl_pwm->level_min;
	unsigned int max = bl_pwm->level_max;
	unsigned int pwm_max = bl_pwm->pwm_max;
	unsigned int pwm_min = bl_pwm->pwm_min;

	level = bl_level_mapping(level);
	max = bl_level_mapping(max);
	min = bl_level_mapping(min);
	if ((max <= min) || (level < min))
		bl_pwm->pwm_level = pwm_min;
	else
		bl_pwm->pwm_level = (pwm_max - pwm_min) * (level - min) / (max - min) + pwm_min;

	if (bl_pwm->pwm_duty_max > 100)
		bl_pwm->pwm_duty = bl_pwm->pwm_level * 255 / bl_pwm->pwm_cnt;
	else
		bl_pwm->pwm_duty = ((bl_pwm->pwm_level * 1000 / bl_pwm->pwm_cnt) + 5) / 10;

	if (lcd_debug_print_flag) {
		LCDPR("bl: port %d: level=%d, level_max=%d, level_min=%d\n",
			bl_pwm->pwm_port, level, max, min);
		LCDPR("bl: port %d: pwm_max=%d, pwm_min=%d, pwm_level=%d, duty=%d%%\n",
			bl_pwm->pwm_port, pwm_max, pwm_min, bl_pwm->pwm_level, bl_pwm->pwm_duty);
	}

	bl_set_pwm(bl_pwm);
}

void aml_bl_set_level(unsigned int level)
{
	struct bl_config_s *bconf;
	struct bl_pwm_config_s *pwm0, *pwm1;
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_s *bl_ext;
#endif
#ifdef CONFIG_AML_LOCAL_DIMMING
	struct aml_ldim_driver_s *ldim_drv;
#endif

	bconf = bl_check_valid();
	if (bconf == NULL)
		return;

	LCDPR("bl: set level: %u, last level: %u\n", level, bconf->level);
	/* level range check */
	level = (level > bconf->level_max ? bconf->level_max :
			(level < bconf->level_min ? bconf->level_min : level));
	bconf->level = level;

	switch (bconf->method) {
	case BL_CTRL_GPIO:
		break;
	case BL_CTRL_PWM:
		bl_set_level_pwm(bconf->bl_pwm, level);
		break;
	case BL_CTRL_PWM_COMBO:
		pwm0 = bconf->bl_pwm_combo0;
		pwm1 = bconf->bl_pwm_combo1;

		if (level >= pwm0->level_max) {
			bl_set_level_pwm(pwm0, pwm0->level_max);
		} else if ((level > pwm0->level_min) &&
			(level < pwm0->level_max)) {
			if (lcd_debug_print_flag)
				LCDPR("bl: pwm0 region, level=%u\n", level);
			bl_set_level_pwm(pwm0, level);
		} else {
			bl_set_level_pwm(pwm0, pwm0->level_min);
		}

		if (level >= pwm1->level_max) {
			bl_set_level_pwm(pwm1, pwm1->level_max);
		} else if ((level > pwm1->level_min) &&
			(level < pwm1->level_max)) {
			if (lcd_debug_print_flag)
				LCDPR("bl: pwm1 region, level=%u\n", level);
			bl_set_level_pwm(pwm1, level);
		} else {
			bl_set_level_pwm(pwm1, pwm1->level_min);
		}
		break;
#ifdef CONFIG_AML_LOCAL_DIMMING
	case BL_CTRL_LOCAL_DIMMING:
		ldim_drv = aml_ldim_get_driver();
		if (ldim_drv->set_level)
			ldim_drv->set_level(level);
		else
			LCDERR("bl: ldim set_level is null\n");
		break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
	case BL_CTRL_EXTERN:
		bl_ext = aml_bl_extern_get_driver();
		if (bl_ext->set_level)
			bl_ext->set_level(level);
		else
			LCDERR("bl: bl_extern set_level is null\n");
		break;
#endif
	default:
		if (lcd_debug_print_flag)
			LCDERR("bl: wrong backlight control method\n");
		break;
	}
}

unsigned int aml_bl_get_level(void)
{
	struct bl_config_s *bconf;

	bconf = bl_check_valid();
	if (bconf == NULL)
		return 0;

	return bconf->level;
}

void bl_pwm_ctrl(struct bl_pwm_config_s *bl_pwm, int status)
{
	int port, pre_div;

	port = bl_pwm->pwm_port;
	pre_div = bl_pwm->pwm_pre_div;
	if (status) {
		/* enable pwm */
		switch (port) {
		case BL_PWM_A:
		case BL_PWM_B:
		case BL_PWM_C:
		case BL_PWM_D:
		case BL_PWM_E:
		case BL_PWM_F:
			/* pwm clk_div */
			lcd_cbus_setb(pwm_misc[port][0], pre_div, pwm_misc[port][1], 7);
			/* pwm clk_sel */
			lcd_cbus_setb(pwm_misc[port][0], 0, pwm_misc[port][2], 2);
			/* pwm clk_en */
			lcd_cbus_setb(pwm_misc[port][0], 1, pwm_misc[port][3], 1);
			/* pwm enable */
			lcd_cbus_setb(pwm_misc[port][0], 0x3, pwm_misc[port][4], 2);
			break;
		default:
			break;
		}
	} else {
		/* disable pwm */
		switch (port) {
		case BL_PWM_A:
		case BL_PWM_B:
		case BL_PWM_C:
		case BL_PWM_D:
		case BL_PWM_E:
		case BL_PWM_F:
			/* pwm clk_disable */
			lcd_cbus_setb(pwm_misc[port][0], 0, pwm_misc[port][3], 1);
			break;
		default:
			break;
		}
	}
}

static void bl_power_en_ctrl(struct bl_config_s *bconf, int status)
{
	int gpio;
	char *str;

	if (bconf->en_gpio >= BL_GPIO_NUM_MAX) {
		gpio = LCD_GPIO_MAX;
	} else {
		str = bconf->gpio_name[bconf->en_gpio];
		gpio = aml_lcd_gpio_name_map_num(str);
	}
	if (status) {
		if (gpio < LCD_GPIO_MAX)
			aml_lcd_gpio_set(gpio, bconf->en_gpio_on);
	} else {
		if (gpio < LCD_GPIO_MAX)
			aml_lcd_gpio_set(gpio, bconf->en_gpio_off);
	}
}

void aml_bl_power_ctrl(int status, int delay_flag)
{
	int gpio, value;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct bl_config_s *bconf;
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_s *bl_ext;
#endif
#ifdef CONFIG_AML_LOCAL_DIMMING
	struct aml_ldim_driver_s *ldim_drv;
#endif

	bconf = bl_check_valid();
	if (bconf == NULL)
		return;

	gpio = bconf->en_gpio;
	value = status ? bconf->en_gpio_on : bconf->en_gpio_off;
	if (lcd_debug_print_flag)
		LCDPR("bl: status=%d gpio=%d value=%d\n", status, gpio, value);

	if (status) {
		/* bl_off_policy */
		if (bl_off_policy != BL_OFF_POLICY_NONE) {
			LCDPR("bl_off_policy=%d for bl_off\n", bl_off_policy);
			return;
		}

		bl_status = 1;
		/* check if factory test */
		if (lcd_drv->factory_bl_power_on_delay >= 0) {
			LCDPR("bl: %s: factory test power_on_delay!\n", __func__);
			if ((lcd_drv->factory_bl_power_on_delay > 0) && (delay_flag > 0))
				mdelay(lcd_drv->factory_bl_power_on_delay);
		} else {
			if ((bconf->power_on_delay > 0) && (delay_flag > 0))
				mdelay(bconf->power_on_delay);
		}

		switch (bconf->method) {
		case BL_CTRL_GPIO:
			bl_power_en_ctrl(bconf, 1);
			break;
		case BL_CTRL_PWM:
			if (bconf->en_sequence_reverse) {
				/* step 1: power on enable */
				bl_power_en_ctrl(bconf, 1);
				if (bconf->pwm_on_delay > 0)
					mdelay(bconf->pwm_on_delay);
				/* step 2: power on pwm */
				bl_pwm_ctrl(bconf->bl_pwm, 1);
				bl_pwm_pinmux_ctrl(bconf, 1);
			} else {
				/* step 1: power on pwm */
				bl_pwm_ctrl(bconf->bl_pwm, 1);
				bl_pwm_pinmux_ctrl(bconf, 1);
				if (bconf->pwm_on_delay > 0)
					mdelay(bconf->pwm_on_delay);
				/* step 2: power on enable */
				bl_power_en_ctrl(bconf, 1);
			}
			break;
		case BL_CTRL_PWM_COMBO:
			if (bconf->en_sequence_reverse) {
				/* step 1: power on enable */
				bl_power_en_ctrl(bconf, 1);
				if (bconf->pwm_on_delay > 0)
					mdelay(bconf->pwm_on_delay);
				/* step 2: power on pwm_combo */
				bl_pwm_ctrl(bconf->bl_pwm_combo0, 1);
				bl_pwm_ctrl(bconf->bl_pwm_combo1, 1);
				bl_pwm_pinmux_ctrl(bconf, 1);
			} else {
				/* step 1: power on pwm_combo */
				bl_pwm_ctrl(bconf->bl_pwm_combo0, 1);
				bl_pwm_ctrl(bconf->bl_pwm_combo1, 1);
				bl_pwm_pinmux_ctrl(bconf, 1);
				if (bconf->pwm_on_delay > 0)
					mdelay(bconf->pwm_on_delay);
				/* step 2: power on enable */
				bl_power_en_ctrl(bconf, 1);
			}
			break;
#ifdef CONFIG_AML_LOCAL_DIMMING
		case BL_CTRL_LOCAL_DIMMING:
			ldim_drv = aml_ldim_get_driver();
			if (bconf->en_sequence_reverse) {
				/* step 1: power on enable */
				bl_power_en_ctrl(bconf, 1);
				/* step 2: power on ldim */
				if (ldim_drv->power_on)
					ldim_drv->power_on();
				else
					LCDERR("bl: ldim power on is null\n");
			} else {
				/* step 1: power on ldim */
				if (ldim_drv->power_on)
					ldim_drv->power_on();
				else
					LCDERR("bl: ldim power on is null\n");
				/* step 2: power on enable */
				bl_power_en_ctrl(bconf, 1);
			}
			break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
		case BL_CTRL_EXTERN:
			bl_ext = aml_bl_extern_get_driver();
			if (bconf->en_sequence_reverse) {
				/* step 1: power on enable */
				bl_power_en_ctrl(bconf, 1);
				/* step 2: power on bl_extern */
				if (bl_ext->power_on)
					bl_ext->power_on();
				else
					LCDERR("bl: bl_extern power on is null\n");
			} else {
				/* step 1: power on bl_extern */
				if (bl_ext->power_on)
					bl_ext->power_on();
				else
					LCDERR("bl: bl_extern power on is null\n");
				/* step 2: power on enable */
				bl_power_en_ctrl(bconf, 1);
			}
			break;
#endif
		default:
			if (lcd_debug_print_flag)
				LCDERR("bl: wrong backlight control method\n");
			break;
		}
	} else {
		bl_status = 0;
		switch (bconf->method) {
		case BL_CTRL_GPIO:
			bl_power_en_ctrl(bconf, 0);
			break;
		case BL_CTRL_PWM:
			if (bconf->en_sequence_reverse) {
				/* step 1: power off pwm */
				bl_pwm_ctrl(bconf->bl_pwm, 0);
				bl_pwm_pinmux_ctrl(bconf, 0);
				if (bconf->pwm_off_delay > 0)
					mdelay(bconf->pwm_off_delay);
				/* step 2: power off enable */
				bl_power_en_ctrl(bconf, 0);
			} else {
				/* step 1: power off enable */
				bl_power_en_ctrl(bconf, 0);
				/* step 2: power off pwm */
				if (bconf->pwm_off_delay > 0)
					mdelay(bconf->pwm_off_delay);
				bl_pwm_ctrl(bconf->bl_pwm, 0);
				bl_pwm_pinmux_ctrl(bconf, 0);
			}
			break;
		case BL_CTRL_PWM_COMBO:
			if (bconf->en_sequence_reverse) {
				/* step 1: power off pwm_combo */
				bl_pwm_ctrl(bconf->bl_pwm_combo0, 0);
				bl_pwm_ctrl(bconf->bl_pwm_combo1, 0);
				bl_pwm_pinmux_ctrl(bconf, 0);
				if (bconf->pwm_off_delay > 0)
					mdelay(bconf->pwm_off_delay);
				/* step 2: power off enable */
				bl_power_en_ctrl(bconf, 0);
			} else {
				/* step 1: power off enable */
				bl_power_en_ctrl(bconf, 0);
				/* step 2: power off pwm_combo */
				if (bconf->pwm_off_delay > 0)
					mdelay(bconf->pwm_off_delay);
				bl_pwm_ctrl(bconf->bl_pwm_combo0, 0);
				bl_pwm_ctrl(bconf->bl_pwm_combo1, 0);
				bl_pwm_pinmux_ctrl(bconf, 0);
			}
			break;
#ifdef CONFIG_AML_LOCAL_DIMMING
		case BL_CTRL_LOCAL_DIMMING:
			ldim_drv = aml_ldim_get_driver();
			if (bconf->en_sequence_reverse) {
				/* step 1: power off ldim */
				if (ldim_drv->power_off)
					ldim_drv->power_off();
				else
					LCDERR("bl: ldim power off is null\n");
				/* step 2: power off enable */
				bl_power_en_ctrl(bconf, 0);
			} else {
				/* step 1: power off enable */
				bl_power_en_ctrl(bconf, 0);
				/* step 2: power off ldim */
				if (ldim_drv->power_off)
					ldim_drv->power_off();
				else
					LCDERR("bl: ldim power off is null\n");
			}
			break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
		case BL_CTRL_EXTERN:
			bl_ext = aml_bl_extern_get_driver();
			if (bconf->en_sequence_reverse) {
				/* step 1: power off bl_extern */
				if (bl_ext->power_off)
					bl_ext->power_off();
				else
					LCDERR("bl: bl_extern: power off is null\n");
				/* step 2: power off enable */
				bl_power_en_ctrl(bconf, 0);
			} else {
				/* step 1: power off enable */
				bl_power_en_ctrl(bconf, 0);
				/* step 2: power off bl_extern */
				if (bl_ext->power_off)
					bl_ext->power_off();
				else
					LCDERR("bl: bl_extern: power off is null\n");
			}
			break;
#endif
		default:
			if (lcd_debug_print_flag)
				LCDERR("bl: wrong backlight control method\n");
			break;
		}
		if ((bconf->power_off_delay > 0) && (delay_flag > 0))
			mdelay(bconf->power_off_delay);
	}
	LCDPR("bl: %s: %d\n", __func__, status);
}

#ifdef CONFIG_OF_LIBFDT
static char *bl_pwm_name[] = {
	"PWM_A",
	"PWM_B",
	"PWM_C",
	"PWM_D",
	"PWM_E",
	"PWM_F",
	"PWM_VS",
};

enum bl_pwm_port_e bl_pwm_str_to_pwm(const char *str)
{
	enum bl_pwm_port_e pwm_port = BL_PWM_MAX;
	int i;

	for (i = 0; i < ARRAY_SIZE(bl_pwm_name); i++) {
		if (strcmp(str, bl_pwm_name[i]) == 0) {
			pwm_port = i;
			break;
		}
	}

	return pwm_port;
}

void aml_bl_config_print(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct bl_config_s *bconf;
	struct bl_pwm_config_s *bl_pwm;
#ifdef CONFIG_AML_LOCAL_DIMMING
	struct aml_ldim_driver_s *ldim_drv = aml_ldim_get_driver();
#endif
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_s *bl_extern = aml_bl_extern_get_driver();
#endif

	bconf = lcd_drv->bl_config;
	LCDPR("bl: name: %s\n", bconf->name);
	LCDPR("bl: method: %d\n", bconf->method);

	LCDPR("bl: level_default     = %d\n", bconf->level_default);
	LCDPR("bl: level_min         = %d\n", bconf->level_min);
	LCDPR("bl: level_max         = %d\n", bconf->level_max);
	LCDPR("bl: level_mid         = %d\n", bconf->level_mid);
	LCDPR("bl: level_mid_mapping = %d\n", bconf->level_mid_mapping);

	LCDPR("bl: en_gpio           = %d\n", bconf->en_gpio);
	LCDPR("bl: en_gpio_on        = %d\n", bconf->en_gpio_on);
	LCDPR("bl: en_gpio_off       = %d\n", bconf->en_gpio_off);
	/* check if factory test */
	if (lcd_drv->factory_bl_power_on_delay >= 0)
		LCDPR("bl: factory test power_on_delay    = %d\n", bconf->power_on_delay);
	else
		LCDPR("bl: power_on_delay    = %d\n", bconf->power_on_delay);
	LCDPR("bl: power_off_delay   = %d\n\n", bconf->power_off_delay);
	switch (bconf->method) {
	case BL_CTRL_PWM:
		if (bconf->bl_pwm) {
			bl_pwm = bconf->bl_pwm;
			LCDPR("bl: pwm_index     = %d\n", bl_pwm->index);
			LCDPR("bl: pwm_method    = %d\n", bl_pwm->pwm_method);
			LCDPR("bl: pwm_port      = %d\n", bl_pwm->pwm_port);
			if (bl_pwm->pwm_port == BL_PWM_VS) {
				LCDPR("bl: pwm_freq      = %d x vfreq\n", bl_pwm->pwm_freq);
				LCDPR("bl: pwm_cnt       = %u\n", bl_pwm->pwm_cnt);
				if (bl_pwm->pwm_duty_max > 100)
					LCDPR("bl: pwm_duty  = %d%%(%d)\n", bl_pwm->pwm_duty * 100 / 255, bl_pwm->pwm_duty);
				else
					LCDPR("bl: pwm_duty  = %d%%(%d)\n", bl_pwm->pwm_duty, bl_pwm->pwm_duty);

				LCDPR("bl: pwm_reg0      = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V0));
				LCDPR("bl: pwm_reg1      = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V1));
				LCDPR("bl: pwm_reg2      = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V2));
				LCDPR("bl: pwm_reg3      = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V3));
			} else {
				LCDPR("bl: pwm_freq      = %uHz\n", bl_pwm->pwm_freq);
				LCDPR("bl: pwm_cnt       = %u\n", bl_pwm->pwm_cnt);
				LCDPR("bl: pwm_pre_div   = %u\n", bl_pwm->pwm_pre_div);
				if (bl_pwm->pwm_duty_max > 100)
					LCDPR("bl: pwm_duty 	 = %d%%(%d)\n", bl_pwm->pwm_duty * 100 / 255, bl_pwm->pwm_duty);
				else
					LCDPR("bl: pwm_duty      = %d%%(%d)\n", bl_pwm->pwm_duty, bl_pwm->pwm_duty);

				LCDPR("bl: pwm_reg       = 0x%08x\n", lcd_cbus_read(pwm_reg[bl_pwm->pwm_port]));
			}
			LCDPR("bl: pwm_duty_max  = %d\n", bl_pwm->pwm_duty_max);
			LCDPR("bl: pwm_duty_min  = %d\n", bl_pwm->pwm_duty_min);
			LCDPR("bl: pwm_gpio      = %d\n", bl_pwm->pwm_gpio);
			LCDPR("bl: pwm_gpio_off  = %d\n", bl_pwm->pwm_gpio_off);
		}
		LCDPR("bl: pwm_on_delay  = %d\n", bconf->pwm_on_delay);
		LCDPR("bl: pwm_off_delay = %d\n", bconf->pwm_off_delay);
		LCDPR("bl: en_sequence_reverse = %d\n", bconf->en_sequence_reverse);
		break;
	case BL_CTRL_PWM_COMBO:
		if (bconf->bl_pwm_combo0) {
			bl_pwm = bconf->bl_pwm_combo0;
			LCDPR("bl: pwm_combo0_index    = %d\n", bl_pwm->index);
			LCDPR("bl: pwm_combo0_method   = %d\n", bl_pwm->pwm_method);
			LCDPR("bl: pwm_combo0_port     = %d\n", bl_pwm->pwm_port);
			if (bl_pwm->pwm_port == BL_PWM_VS) {
				LCDPR("bl: pwm_combo0_freq     = %d x vfreq\n", bl_pwm->pwm_freq);
				LCDPR("bl: pwm_combo0_cnt      = %u\n", bl_pwm->pwm_cnt);
				if (bl_pwm->pwm_duty_max > 100)
					LCDPR("bl: pwm_combo0_duty = %d%%(%d)\n", bl_pwm->pwm_duty * 100 / 255, bl_pwm->pwm_duty);
				else
					LCDPR("bl: pwm_combo0_duty = %d%%(%d)\n", bl_pwm->pwm_duty, bl_pwm->pwm_duty);

				LCDPR("bl: pwm_combo0_reg0     = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V0));
				LCDPR("bl: pwm_combo0_reg1     = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V1));
				LCDPR("bl: pwm_combo0_reg2     = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V2));
				LCDPR("bl: pwm_combo0_reg3     = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V3));
			} else {
				LCDPR("bl: pwm_combo0_freq     = %uHz\n", bl_pwm->pwm_freq);
				LCDPR("bl: pwm_combo0_cnt      = %u\n", bl_pwm->pwm_cnt);
				LCDPR("bl: pwm_combo0_pre_div  = %u\n", bl_pwm->pwm_pre_div);
				if (bl_pwm->pwm_duty_max > 100)
					LCDPR("bl: pwm_combo0_duty = %d%%(%d)\n", bl_pwm->pwm_duty * 100 / 255, bl_pwm->pwm_duty);
				else
					LCDPR("bl: pwm_combo0_duty = %d%%(%d)\n", bl_pwm->pwm_duty, bl_pwm->pwm_duty);

				LCDPR("bl: pwm_combo0_reg      = 0x%08x\n", lcd_cbus_read(pwm_reg[bl_pwm->pwm_port]));
			}
			LCDPR("bl: pwm_combo0_duty_max = %d\n", bl_pwm->pwm_duty_max);
			LCDPR("bl: pwm_combo0_duty_min = %d\n", bl_pwm->pwm_duty_min);
			LCDPR("bl: pwm_combo0_gpio     = %d\n", bl_pwm->pwm_gpio);
			LCDPR("bl: pwm_combo0_gpio_off = %d\n", bl_pwm->pwm_gpio_off);
		}
		if (bconf->bl_pwm_combo1) {
			bl_pwm = bconf->bl_pwm_combo1;
			LCDPR("bl: pwm_combo1_index    = %d\n", bl_pwm->index);
			LCDPR("bl: pwm_combo1_method   = %d\n", bl_pwm->pwm_method);
			LCDPR("bl: pwm_combo1_port     = %d\n", bl_pwm->pwm_port);
			if (bl_pwm->pwm_port == BL_PWM_VS) {
				LCDPR("bl: pwm_combo1_freq     = %d x vfreq\n", bl_pwm->pwm_freq);
				LCDPR("bl: pwm_combo1_cnt      = %u\n", bl_pwm->pwm_cnt);
				if (bl_pwm->pwm_duty_max > 100)
					LCDPR("bl: pwm_combo1_duty = %d%%(%d)\n", bl_pwm->pwm_duty * 100 / 255, bl_pwm->pwm_duty);
				else
					LCDPR("bl: pwm_combo1_duty = %d%%(%d)\n", bl_pwm->pwm_duty, bl_pwm->pwm_duty);

				LCDPR("bl: pwm_combo1_reg0     = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V0));
				LCDPR("bl: pwm_combo1_reg1     = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V1));
				LCDPR("bl: pwm_combo1_reg2     = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V2));
				LCDPR("bl: pwm_combo1_reg3     = 0x%08x\n", lcd_vcbus_read(VPU_VPU_PWM_V3));
			} else {
				LCDPR("bl: pwm_combo1_freq     = %uHz\n", bl_pwm->pwm_freq);
				LCDPR("bl: pwm_combo1_cnt      = %u\n", bl_pwm->pwm_cnt);
				LCDPR("bl: pwm_combo1_pre_div  = %u\n", bl_pwm->pwm_pre_div);
				if (bl_pwm->pwm_duty_max > 100)
					LCDPR("bl: pwm_combo1_duty = %d%%(%d)\n", bl_pwm->pwm_duty * 100 / 255, bl_pwm->pwm_duty);
				else
					LCDPR("bl: pwm_combo1_duty     = %d%%(%d)\n", bl_pwm->pwm_duty, bl_pwm->pwm_duty);

				LCDPR("bl: pwm_combo1_reg      = 0x%08x\n", lcd_cbus_read(pwm_reg[bl_pwm->pwm_port]));
			}
			LCDPR("bl: pwm_combo1_duty_max = %d\n", bl_pwm->pwm_duty_max);
			LCDPR("bl: pwm_combo1_duty_min = %d\n", bl_pwm->pwm_duty_min);
			LCDPR("bl: pwm_combo1_gpio     = %d\n", bl_pwm->pwm_gpio);
			LCDPR("bl: pwm_combo1_gpio_off = %d\n", bl_pwm->pwm_gpio_off);
		}
		LCDPR("bl: pwm_on_delay        = %d\n", bconf->pwm_on_delay);
		LCDPR("bl: pwm_off_delay       = %d\n", bconf->pwm_off_delay);
		LCDPR("bl: en_sequence_reverse = %d\n", bconf->en_sequence_reverse);
		break;
#ifdef CONFIG_AML_LOCAL_DIMMING
	case BL_CTRL_LOCAL_DIMMING:
		if (ldim_drv) {
			if (ldim_drv->config_print)
				ldim_drv->config_print();
		} else {
			LCDPR("bl: invalid local dimming driver\n");
		}
		break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
	case BL_CTRL_EXTERN:
		if (bl_extern) {
			if (bl_extern->config_print)
				bl_extern->config_print();
		} else {
			LCDPR("bl: invalid bl extern driver\n");
		}
		break;
#endif

	default:
		LCDPR("bl: invalid backlight control method\n");
		break;
	}
}

static int aml_bl_config_load_from_dts(char *dt_addr, unsigned int index, struct bl_config_s *bconf)
{
	int parent_offset, child_offset;
	char propname[30];
	char *propdata;
	char *p;
	const char *str;
	struct bl_pwm_config_s *bl_pwm;
	struct bl_pwm_config_s *pwm_combo0, *pwm_combo1;

	bconf->method = BL_CTRL_MAX; /* default */
	parent_offset = fdt_path_offset(dt_addr, "/backlight");
	if (parent_offset < 0) {
		LCDPR("bl: not find /backlight node %s\n", fdt_strerror(parent_offset));
		return -1;
	}
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "status", NULL);
	if (propdata == NULL) {
		LCDPR("bl: not find status, default to disabled\n");
		return -1;
	} else {
		if (strncmp(propdata, "okay", 2)) {
			LCDPR("bl: status disabled\n");
			return -1;
		}
	}

	sprintf(propname,"/backlight/backlight_%d", index);
	child_offset = fdt_path_offset(dt_addr, propname);
	if (child_offset < 0) {
		LCDERR("bl: not find %s node: %s\n", propname, fdt_strerror(child_offset));
		return -1;
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_name", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_name\n");
		sprintf(bconf->name, "backlight_%d", index);
	} else {
		strcpy(bconf->name, propdata);
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_level_default_uboot_kernel", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_level_default_uboot_kernel\n");
		bconf->level_default = BL_LEVEL_DEFAULT;
	} else {
		bconf->level_default = be32_to_cpup((u32*)propdata);
	}
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_level_attr", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_level_attr\n");
		bconf->level_max = BL_LEVEL_MAX;
		bconf->level_min = BL_LEVEL_MIN;
		bconf->level_mid = BL_LEVEL_MID;
		bconf->level_mid_mapping = BL_LEVEL_MID_MAPPED;
	} else {
		bconf->level_max = be32_to_cpup((u32*)propdata);
		bconf->level_min = be32_to_cpup((((u32*)propdata)+1));
		bconf->level_mid = be32_to_cpup((((u32*)propdata)+2));
		bconf->level_mid_mapping = be32_to_cpup((((u32*)propdata)+3));
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_ctrl_method", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_ctrl_method\n");
		bconf->method = BL_CTRL_MAX;
		return -1;
	} else {
		bconf->method = be32_to_cpup((u32*)propdata);
	}
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_power_attr", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_power_attr\n");
		bconf->en_gpio = BL_GPIO_NUM_MAX;
		bconf->en_gpio_on = LCD_GPIO_OUTPUT_HIGH;
		bconf->en_gpio_off = LCD_GPIO_OUTPUT_LOW;
		bconf->power_on_delay = 100;
		bconf->power_off_delay = 30;
	} else {
		bconf->en_gpio = be32_to_cpup((u32*)propdata);
		bconf->en_gpio_on = be32_to_cpup((((u32*)propdata)+1));
		bconf->en_gpio_off = be32_to_cpup((((u32*)propdata)+2));
		bconf->power_on_delay = be32_to_cpup((((u32*)propdata)+3));
		bconf->power_off_delay = be32_to_cpup((((u32*)propdata)+4));
	}

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bconf->bl_pwm = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm == NULL) {
			LCDERR("bl: bl_pwm struct malloc error\n");
			return -1;
		}
		bl_pwm = bconf->bl_pwm;
		bl_pwm->index = 0;

		bl_pwm->level_max = bconf->level_max;
		bl_pwm->level_min = bconf->level_min;

		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_port", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_port\n");
			bl_pwm->pwm_port = BL_PWM_MAX;
		} else {
			bl_pwm->pwm_port = bl_pwm_str_to_pwm(propdata);
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_attr", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_attr\n");
			bl_pwm->pwm_method = BL_PWM_POSITIVE;
			if (bl_pwm->pwm_port == BL_PWM_VS)
				bl_pwm->pwm_freq = BL_FREQ_VS_DEFAULT;
			else
				bl_pwm->pwm_freq = BL_FREQ_DEFAULT;
			bl_pwm->pwm_duty_max = 80;
			bl_pwm->pwm_duty_min = 20;
		} else {
			bl_pwm->pwm_method = be32_to_cpup((u32*)propdata);
			bl_pwm->pwm_freq = be32_to_cpup((((u32*)propdata)+1));
			bl_pwm->pwm_duty_max = be32_to_cpup((((u32*)propdata)+2));
			bl_pwm->pwm_duty_min = be32_to_cpup((((u32*)propdata)+3));
		}
		if (bl_pwm->pwm_port == BL_PWM_VS) {
			if (bl_pwm->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", bl_pwm->pwm_freq);
				bl_pwm->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
		} else {
			if (bl_pwm->pwm_freq > XTAL_HALF_FREQ_HZ)
				bl_pwm->pwm_freq = XTAL_HALF_FREQ_HZ;
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_power", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_power\n");
			bl_pwm->pwm_gpio = BL_GPIO_NUM_MAX;
			bl_pwm->pwm_gpio_off = LCD_GPIO_OUTPUT_LOW;
			bconf->pwm_on_delay = 10;
			bconf->pwm_off_delay = 10;
		} else {
			bl_pwm->pwm_gpio = be32_to_cpup((u32*)propdata);
			bl_pwm->pwm_gpio_off = be32_to_cpup((((u32*)propdata)+1));
			bconf->pwm_on_delay = be32_to_cpup((((u32*)propdata)+2));
			bconf->pwm_off_delay = be32_to_cpup((((u32*)propdata)+3));
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_en_sequence_reverse", NULL);
		if (propdata == NULL) {
			LCDPR("bl: don't find bl_pwm_en_sequence_reverse\n");
			bconf->en_sequence_reverse = 0;
		} else {
			bconf->en_sequence_reverse = be32_to_cpup((u32*)propdata);
		}

		bl_pwm->pwm_duty = bl_pwm->pwm_duty_min;
		/* bl_pwm_config_init(bl_pwm); */
		break;
	case BL_CTRL_PWM_COMBO:
		bconf->bl_pwm_combo0 = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm_combo0 == NULL) {
			LCDERR("bl: bl_pwm_combo0 struct malloc error\n");
			return -1;
		}
		bconf->bl_pwm_combo1 = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm_combo1 == NULL) {
			LCDERR("bl: bl_pwm_combo1 struct malloc error\n");
			return -1;
		}
		pwm_combo0 = bconf->bl_pwm_combo0;
		pwm_combo1 = bconf->bl_pwm_combo1;
		pwm_combo0->index = 0;
		pwm_combo1->index = 1;

		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_combo_level_mapping", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_combo_level_mapping\n");
			pwm_combo0->level_max = BL_LEVEL_MAX;
			pwm_combo0->level_min = BL_LEVEL_MID;
			pwm_combo1->level_max = BL_LEVEL_MID;
			pwm_combo1->level_min = BL_LEVEL_MIN;
		} else {
			pwm_combo0->level_max = be32_to_cpup((u32*)propdata);
			pwm_combo0->level_min = be32_to_cpup((((u32*)propdata)+1));
			pwm_combo1->level_max = be32_to_cpup((((u32*)propdata)+2));
			pwm_combo1->level_min = be32_to_cpup((((u32*)propdata)+3));
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_combo_port", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_combo_port\n");
			pwm_combo0->pwm_port = BL_PWM_MAX;
			pwm_combo1->pwm_port = BL_PWM_MAX;
		} else {
			p = propdata;
			str = p;
			pwm_combo0->pwm_port = bl_pwm_str_to_pwm(str);
			p += strlen(p) + 1;
			str = p;
			pwm_combo1->pwm_port = bl_pwm_str_to_pwm(str);
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_combo_attr", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_combo_attr\n");
			pwm_combo0->pwm_method = BL_PWM_POSITIVE;
			if (pwm_combo0->pwm_port == BL_PWM_VS)
				pwm_combo0->pwm_freq = BL_FREQ_VS_DEFAULT;
			else
				pwm_combo0->pwm_freq = BL_FREQ_DEFAULT;
			pwm_combo0->pwm_duty_max = 80;
			pwm_combo0->pwm_duty_min = 20;
			pwm_combo1->pwm_method = BL_PWM_POSITIVE;
			if (pwm_combo1->pwm_port == BL_PWM_VS)
				pwm_combo1->pwm_freq = BL_FREQ_VS_DEFAULT;
			else
				pwm_combo1->pwm_freq = BL_FREQ_DEFAULT;
			pwm_combo1->pwm_duty_max = 80;
			pwm_combo1->pwm_duty_min = 20;
		} else {
			pwm_combo0->pwm_method = be32_to_cpup((u32*)propdata);
			pwm_combo0->pwm_freq = be32_to_cpup((((u32*)propdata)+1));
			pwm_combo0->pwm_duty_max = be32_to_cpup((((u32*)propdata)+2));
			pwm_combo0->pwm_duty_min = be32_to_cpup((((u32*)propdata)+3));
			pwm_combo1->pwm_method = be32_to_cpup((((u32*)propdata)+4));
			pwm_combo1->pwm_freq = be32_to_cpup((((u32*)propdata)+5));
			pwm_combo1->pwm_duty_max = be32_to_cpup((((u32*)propdata)+6));
			pwm_combo1->pwm_duty_min = be32_to_cpup((((u32*)propdata)+7));
		}
		if (pwm_combo0->pwm_port == BL_PWM_VS) {
			if (pwm_combo0->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", pwm_combo0->pwm_freq);
				pwm_combo0->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
		} else {
			if (pwm_combo0->pwm_freq > XTAL_HALF_FREQ_HZ)
				pwm_combo0->pwm_freq = XTAL_HALF_FREQ_HZ;
		}
		if (pwm_combo1->pwm_port == BL_PWM_VS) {
			if (pwm_combo1->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", pwm_combo1->pwm_freq);
				pwm_combo1->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
		} else {
			if (pwm_combo1->pwm_freq > XTAL_HALF_FREQ_HZ)
				pwm_combo1->pwm_freq = XTAL_HALF_FREQ_HZ;
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_combo_power", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_combo_power\n");
			pwm_combo0->pwm_gpio = BL_GPIO_NUM_MAX;
			pwm_combo0->pwm_gpio_off = LCD_GPIO_INPUT;
			pwm_combo1->pwm_gpio = BL_GPIO_NUM_MAX;
			pwm_combo1->pwm_gpio_off = LCD_GPIO_INPUT;
			bconf->pwm_on_delay = 10;
			bconf->pwm_off_delay = 10;
		} else {
			pwm_combo0->pwm_gpio = be32_to_cpup((u32*)propdata);
			pwm_combo0->pwm_gpio_off = be32_to_cpup((((u32*)propdata)+1));
			pwm_combo1->pwm_gpio = be32_to_cpup((((u32*)propdata)+2));
			pwm_combo1->pwm_gpio_off = be32_to_cpup((((u32*)propdata)+3));
			bconf->pwm_on_delay = be32_to_cpup((((u32*)propdata)+4));
			bconf->pwm_off_delay = be32_to_cpup((((u32*)propdata)+5));
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_en_sequence_reverse", NULL);
		if (propdata == NULL) {
			LCDPR("bl: don't find bl_pwm_en_sequence_reverse\n");
			bconf->en_sequence_reverse = 0;
		} else {
			bconf->en_sequence_reverse = be32_to_cpup((u32*)propdata);
		}

		pwm_combo0->pwm_duty = pwm_combo0->pwm_duty_min;
		pwm_combo1->pwm_duty = pwm_combo1->pwm_duty_min;
		/* bl_pwm_config_init(pwm_combo0);
		bl_pwm_config_init(pwm_combo1); */
		break;
#ifdef CONFIG_AML_LOCAL_DIMMING
	case BL_CTRL_LOCAL_DIMMING:
		ldim_config_load_from_dts(dt_addr, child_offset);
		aml_ldim_probe(dt_addr, 0);
		break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
	case BL_CTRL_EXTERN:
		/* get bl_extern_index from dts */
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_extern_index", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_extern_index\n");
		} else {
			bconf->bl_extern_index = be32_to_cpup((u32*)propdata);
			LCDPR("get bl_extern_index = %d\n", bconf->bl_extern_index);
		}
		aml_bl_extern_device_load(dt_addr, bconf->bl_extern_index);
		break;
#endif

	default:
		break;
	}

	return 0;
}
#endif

static int aml_bl_config_load_from_bsp(struct bl_config_s *bconf)
{
	struct ext_lcd_config_s *ext_lcd = NULL;
	char *panel_type = getenv("panel_type");
	unsigned int i = 0;
	char *str;
	struct bl_pwm_config_s *bl_pwm;
	struct bl_pwm_config_s *pwm_combo0, *pwm_combo1;

	if (panel_type == NULL) {
		LCDERR("bl: no panel_type, use default backlight config\n");
		return -1;
	}
	for (i = 0; i < LCD_NUM_MAX; i++) {
		ext_lcd = &ext_lcd_config[i];
		if (strcmp(ext_lcd->panel_type, panel_type) == 0)
			break;
	}
	if (i >= LCD_NUM_MAX) {
		LCDERR("bl: can't find %s, use default backlight config\n ", panel_type);
		return -1;
	}

	strcpy(bconf->name, panel_type);
	bconf->level_default     = ext_lcd->level_default;
	bconf->level_min         = ext_lcd->level_min;
	bconf->level_max         = ext_lcd->level_max;
	bconf->level_mid         = ext_lcd->level_mid;
	bconf->level_mid_mapping = ext_lcd->level_mid_mapping;

	bconf->method          = ext_lcd->bl_method;

	if (ext_lcd->bl_en_gpio >= BL_GPIO_NUM_MAX)
		bconf->en_gpio    = LCD_GPIO_MAX;
	else
		bconf->en_gpio    = ext_lcd->bl_en_gpio;
	bconf->en_gpio_on      = ext_lcd->bl_en_gpio_on;
	bconf->en_gpio_off     = ext_lcd->bl_en_gpio_off;
	bconf->power_on_delay  = ext_lcd->bl_power_on_delay;
	bconf->power_off_delay = ext_lcd->bl_power_off_delay;

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bconf->bl_pwm = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm == NULL) {
			LCDERR("bl: bl_pwm struct malloc error\n");
			return -1;
		}
		bl_pwm = bconf->bl_pwm;
		bl_pwm->index = 0;

		bl_pwm->level_max     = bconf->level_max;
		bl_pwm->level_min     = bconf->level_min;

		bl_pwm->pwm_method    = ext_lcd->pwm_method;
		bl_pwm->pwm_port      = ext_lcd->pwm_port;
		bl_pwm->pwm_freq      = ext_lcd->pwm_freq;
		bl_pwm->pwm_duty_max  = ext_lcd->pwm_duty_max;
		bl_pwm->pwm_duty_min  = ext_lcd->pwm_duty_min;

		bl_pwm->pwm_gpio = ext_lcd->pwm_gpio;
		bl_pwm->pwm_gpio_off  = ext_lcd->pwm_gpio_off;
		bconf->pwm_on_delay   = ext_lcd->pwm_on_delay;
		bconf->pwm_off_delay  = ext_lcd->pwm_off_delay;

		bl_pwm->pwm_duty = bl_pwm->pwm_duty_min;
		/* bl_pwm_config_init(bl_pwm); */
		break;
	case BL_CTRL_PWM_COMBO:
		bconf->bl_pwm_combo0 = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm_combo0 == NULL) {
			LCDERR("bl: bl_pwm_combo0 struct malloc error\n");
			return -1;
		}
		bconf->bl_pwm_combo1 = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm_combo1 == NULL) {
			LCDERR("bl: bl_pwm_combo1 struct malloc error\n");
			return -1;
		}
		pwm_combo0 = bconf->bl_pwm_combo0;
		pwm_combo1 = bconf->bl_pwm_combo1;
		pwm_combo0->index = 0;
		pwm_combo1->index = 1;

		pwm_combo0->level_max     = ext_lcd->pwm_level_max;
		pwm_combo0->level_min     = ext_lcd->pwm_level_min;
		pwm_combo1->level_max     = ext_lcd->pwm2_level_max;
		pwm_combo1->level_min     = ext_lcd->pwm2_level_min;

		pwm_combo0->pwm_method    = ext_lcd->pwm_method;
		pwm_combo0->pwm_port      = ext_lcd->pwm_port;
		pwm_combo0->pwm_freq      = ext_lcd->pwm_freq;
		pwm_combo0->pwm_duty_max  = ext_lcd->pwm_duty_max;
		pwm_combo0->pwm_duty_min  = ext_lcd->pwm_duty_min;
		if (ext_lcd->pwm_gpio >= BL_GPIO_NUM_MAX) {
			pwm_combo0->pwm_gpio = LCD_GPIO_MAX;
		} else {
			str = bconf->gpio_name[ext_lcd->pwm_gpio];
			pwm_combo0->pwm_gpio = aml_lcd_gpio_name_map_num(str);
		}
		pwm_combo0->pwm_gpio_off  = ext_lcd->pwm_gpio_off;
		pwm_combo1->pwm_method    = ext_lcd->pwm2_method;
		pwm_combo1->pwm_port      = ext_lcd->pwm2_port;
		pwm_combo1->pwm_freq      = ext_lcd->pwm2_freq;
		pwm_combo1->pwm_duty_max  = ext_lcd->pwm2_duty_max;
		pwm_combo1->pwm_duty_min  = ext_lcd->pwm2_duty_min;
		if (ext_lcd->pwm2_gpio >= BL_GPIO_NUM_MAX) {
			pwm_combo1->pwm_gpio = LCD_GPIO_MAX;
		} else {
			str = bconf->gpio_name[ext_lcd->pwm2_gpio];
			pwm_combo1->pwm_gpio = aml_lcd_gpio_name_map_num(str);
		}
		pwm_combo1->pwm_gpio_off  = ext_lcd->pwm2_gpio_off;
		bconf->pwm_on_delay   = ext_lcd->pwm_on_delay;
		bconf->pwm_off_delay  = ext_lcd->pwm_off_delay;

		pwm_combo0->pwm_duty = pwm_combo0->pwm_duty_min;
		pwm_combo1->pwm_duty = pwm_combo1->pwm_duty_min;
		/* bl_pwm_config_init(pwm_combo0);
		bl_pwm_config_init(pwm_combo1); */
		break;
#ifdef CONFIG_AML_LOCAL_DIMMING
	case BL_CTRL_LOCAL_DIMMING:
		aml_ldim_probe(NULL, 1);
		break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
	case BL_CTRL_EXTERN:
		aml_bl_extern_device_load(NULL, bconf->bl_extern_index);
		break;
#endif
	default:
		if (lcd_debug_print_flag)
			LCDPR("bl: invalid backlight control method\n");
		break;
	}

	return 0;
}

static int aml_bl_config_load_from_unifykey(char *dt_addr, struct bl_config_s *bconf)
{
	unsigned char *para;
	int key_len, len;
	unsigned char *p;
	const char *str;
	struct aml_lcd_unifykey_header_s bl_header;
	struct bl_pwm_config_s *bl_pwm;
	struct bl_pwm_config_s *pwm_combo0, *pwm_combo1;
	int ret;

	para = (unsigned char *)malloc(sizeof(unsigned char) * LCD_UKEY_BL_SIZE);
	if (!para) {
		LCDERR("bl: %s: Not enough memory\n", __func__);
		return -1;
	}

	key_len = LCD_UKEY_BL_SIZE;
	memset(para, 0, (sizeof(unsigned char) * key_len));
	ret = aml_lcd_unifykey_get("backlight", para, &key_len);
	if (ret) {
		free(para);
		return -1;
	}

	/* step 1: check header */
	len = LCD_UKEY_HEAD_SIZE;
	ret = aml_lcd_unifykey_len_check(key_len, len);
	if (ret) {
		LCDERR("unifykey header length is incorrect\n");
		free(para);
		return -1;
	}

	aml_lcd_unifykey_header_check(para, &bl_header);
	LCDPR("bl: unifykey version: 0x%04x\n", bl_header.version);
	switch (bl_header.version) {
	case 2:
		len = 10 + 30 + 12 + 8 + 32 + 10;
		break;
	default:
		len = 10 + 30 + 12 + 8 + 32;
		break;
	}
	if (lcd_debug_print_flag) {
		LCDPR("bl: unifykey header:\n");
		LCDPR("bl: crc32             = 0x%08x\n", bl_header.crc32);
		LCDPR("bl: data_len          = %d\n", bl_header.data_len);
		LCDPR("bl: reserved          = 0x%04x\n", bl_header.reserved);
	}

	/* step 2: check backlight parameters */
	ret = aml_lcd_unifykey_len_check(key_len, len);
	if (ret) {
		LCDERR("bl: unifykey length is incorrect\n");
		free(para);
		return -1;
	}

	/* basic: 30byte */
	p = para;
	*(p + LCD_UKEY_BL_NAME - 1) = '\0'; /* ensure string ending */
	str = (const char *)(p + LCD_UKEY_HEAD_SIZE);
	strcpy(bconf->name, str);

	/* level: 12byte */
	bconf->level_default = (*(p + LCD_UKEY_BL_LEVEL_UBOOT) |
		 ((*(p + LCD_UKEY_BL_LEVEL_UBOOT + 1)) << 8));
	bconf->level_max = (*(p + LCD_UKEY_BL_LEVEL_MAX) |
		((*(p + LCD_UKEY_BL_LEVEL_MAX + 1)) << 8));
	bconf->level_min = (*(p + LCD_UKEY_BL_LEVEL_MIN) |
		((*(p  + LCD_UKEY_BL_LEVEL_MIN + 1)) << 8));
	bconf->level_mid = (*(p + LCD_UKEY_BL_LEVEL_MID) |
		((*(p + LCD_UKEY_BL_LEVEL_MID + 1)) << 8));
	bconf->level_mid_mapping = (*(p + LCD_UKEY_BL_LEVEL_MID_MAP) |
		((*(p + LCD_UKEY_BL_LEVEL_MID_MAP + 1)) << 8));

	/* method: 8byte */
	bconf->method = *(p + LCD_UKEY_BL_METHOD);
	bconf->en_gpio = *(p + LCD_UKEY_BL_EN_GPIO);
	bconf->en_gpio_on = *(p + LCD_UKEY_BL_EN_GPIO_ON);
	bconf->en_gpio_off = *(p + LCD_UKEY_BL_EN_GPIO_OFF);
	bconf->power_on_delay = (*(p + LCD_UKEY_BL_ON_DELAY) |
		((*(p + LCD_UKEY_BL_ON_DELAY + 1)) << 8));
	bconf->power_off_delay = (*(p + LCD_UKEY_BL_OFF_DELAY) |
		((*(p + LCD_UKEY_BL_OFF_DELAY + 1)) << 8));

	/* pwm: 32byte */
	switch (bconf->method) {
	case BL_CTRL_PWM:
		bconf->bl_pwm = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm == NULL) {
			LCDERR("bl: bl_pwm struct malloc error\n");
			free(para);
			return -1;
		}
		bl_pwm = bconf->bl_pwm;
		bl_pwm->index = 0;

		bl_pwm->level_max = bconf->level_max;
		bl_pwm->level_min = bconf->level_min;

		bconf->pwm_on_delay = (*(p + LCD_UKEY_BL_PWM_ON_DELAY) |
			((*(p + LCD_UKEY_BL_PWM_ON_DELAY + 1)) << 8));
		bconf->pwm_off_delay = (*(p + LCD_UKEY_BL_PWM_OFF_DELAY) |
			((*(p + LCD_UKEY_BL_PWM_OFF_DELAY + 1)) << 8));
		bl_pwm->pwm_method =  *(p + LCD_UKEY_BL_PWM_METHOD);
		bl_pwm->pwm_port = *(p + LCD_UKEY_BL_PWM_PORT);
		bl_pwm->pwm_freq = (*(p + LCD_UKEY_BL_PWM_FREQ) |
			((*(p + LCD_UKEY_BL_PWM_FREQ + 1)) << 8) |
			((*(p + LCD_UKEY_BL_PWM_FREQ + 2)) << 8) |
			((*(p + LCD_UKEY_BL_PWM_FREQ + 3)) << 8));
		if (bl_pwm->pwm_port == BL_PWM_VS) {
			if (bl_pwm->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", bl_pwm->pwm_freq);
				bl_pwm->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
		} else {
			if (bl_pwm->pwm_freq > XTAL_HALF_FREQ_HZ)
				bl_pwm->pwm_freq = XTAL_HALF_FREQ_HZ;
		}
		bl_pwm->pwm_duty_max = *(p + LCD_UKEY_BL_PWM_DUTY_MAX);
		bl_pwm->pwm_duty_min = *(p + LCD_UKEY_BL_PWM_DUTY_MIN);
		bl_pwm->pwm_gpio = *(p + LCD_UKEY_BL_PWM_GPIO);
		bl_pwm->pwm_gpio_off = *(p + LCD_UKEY_BL_PWM_GPIO_OFF);

		if (bl_header.version == 2)
			bconf->en_sequence_reverse =
				(*(p + LCD_UKEY_BL_CUST_VAL_0) |
				((*(p + LCD_UKEY_BL_CUST_VAL_0 + 1)) << 8));
		else
			bconf->en_sequence_reverse = 0;

		bl_pwm->pwm_duty = bl_pwm->pwm_duty_min;
		/* bl_pwm_config_init(bl_pwm); */
		break;
	case BL_CTRL_PWM_COMBO:
		bconf->bl_pwm_combo0 = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm_combo0 == NULL) {
			LCDERR("bl: bl_pwm_combo0 struct malloc error\n");
			free(para);
			return -1;
		}
		bconf->bl_pwm_combo1 = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm_combo1 == NULL) {
			LCDERR("bl: bl_pwm_combo1 struct malloc error\n");
			free(para);
			return -1;
		}
		pwm_combo0 = bconf->bl_pwm_combo0;
		pwm_combo1 = bconf->bl_pwm_combo1;
		pwm_combo0->index = 0;
		pwm_combo1->index = 1;

		bconf->pwm_on_delay = (*(p + LCD_UKEY_BL_PWM_ON_DELAY) |
			((*(p + LCD_UKEY_BL_PWM_ON_DELAY + 1)) << 8));
		bconf->pwm_off_delay = (*(p + LCD_UKEY_BL_PWM_OFF_DELAY) |
			((*(p + LCD_UKEY_BL_PWM_OFF_DELAY + 1)) << 8));
		pwm_combo0->pwm_method = *(p + LCD_UKEY_BL_PWM_METHOD);
		pwm_combo0->pwm_port = *(p + LCD_UKEY_BL_PWM_PORT);
		pwm_combo0->pwm_freq = (*(p + LCD_UKEY_BL_PWM_FREQ) |
			((*(p + LCD_UKEY_BL_PWM_FREQ + 1)) << 8) |
			((*(p + LCD_UKEY_BL_PWM_FREQ + 2)) << 8) |
			((*(p + LCD_UKEY_BL_PWM_FREQ + 3)) << 8));
		if (pwm_combo0->pwm_port == BL_PWM_VS) {
			if (pwm_combo0->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", pwm_combo0->pwm_freq);
				pwm_combo0->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
		} else {
			if (pwm_combo0->pwm_freq > XTAL_HALF_FREQ_HZ)
				pwm_combo0->pwm_freq = XTAL_HALF_FREQ_HZ;
		}
		pwm_combo0->pwm_duty_max = *(p + LCD_UKEY_BL_PWM_DUTY_MAX);
		pwm_combo0->pwm_duty_min = *(p + LCD_UKEY_BL_PWM_DUTY_MIN);
		pwm_combo0->pwm_gpio = *(p + LCD_UKEY_BL_PWM_GPIO);
		pwm_combo0->pwm_gpio_off = *(p + LCD_UKEY_BL_PWM_GPIO_OFF);
		pwm_combo1->pwm_method = *(p + LCD_UKEY_BL_PWM2_METHOD);
		pwm_combo1->pwm_port = *(p + LCD_UKEY_BL_PWM2_PORT);
		pwm_combo1->pwm_freq = (*(p + LCD_UKEY_BL_PWM2_FREQ) |
			((*(p + LCD_UKEY_BL_PWM2_FREQ + 1)) << 8) |
			((*(p + LCD_UKEY_BL_PWM2_FREQ + 2)) << 8) |
			((*(p + LCD_UKEY_BL_PWM2_FREQ + 3)) << 8));
		if (pwm_combo1->pwm_port == BL_PWM_VS) {
			if (pwm_combo1->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", pwm_combo1->pwm_freq);
				pwm_combo1->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
		} else {
			if (pwm_combo1->pwm_freq > XTAL_HALF_FREQ_HZ)
				pwm_combo1->pwm_freq = XTAL_HALF_FREQ_HZ;
		}
		pwm_combo1->pwm_duty_max = *(p + LCD_UKEY_BL_PWM2_DUTY_MAX);
		pwm_combo1->pwm_duty_min = *(p + LCD_UKEY_BL_PWM2_DUTY_MIN);
		pwm_combo1->pwm_gpio = *(p + LCD_UKEY_BL_PWM2_GPIO);
		pwm_combo1->pwm_gpio_off = *(p + LCD_UKEY_BL_PWM2_GPIO_OFF);

		pwm_combo0->level_max = (*(p + LCD_UKEY_BL_PWM_LEVEL_MAX) |
			((*(p + LCD_UKEY_BL_PWM_LEVEL_MAX + 1)) << 8));
		pwm_combo0->level_min = (*(p + LCD_UKEY_BL_PWM_LEVEL_MIN) |
			((*(p + LCD_UKEY_BL_PWM_LEVEL_MIN + 1)) << 8));
		pwm_combo1->level_max = (*(p + LCD_UKEY_BL_PWM2_LEVEL_MAX) |
			((*(p + LCD_UKEY_BL_PWM2_LEVEL_MAX + 1)) << 8));
		pwm_combo1->level_min = (*(p + LCD_UKEY_BL_PWM2_LEVEL_MIN) |
			((*(p + LCD_UKEY_BL_PWM2_LEVEL_MIN + 1)) << 8));

		if (bl_header.version == 2)
			bconf->en_sequence_reverse = (*(p + LCD_UKEY_BL_CUST_VAL_0) |
				((*(p + LCD_UKEY_BL_CUST_VAL_0 + 1)) << 8));
		else
			bconf->en_sequence_reverse = 0;

		pwm_combo0->pwm_duty = pwm_combo0->pwm_duty_min;
		pwm_combo1->pwm_duty = pwm_combo1->pwm_duty_min;
		/* bl_pwm_config_init(pwm_combo0);
		bl_pwm_config_init(pwm_combo1); */
		break;
#ifdef CONFIG_AML_LOCAL_DIMMING
	case BL_CTRL_LOCAL_DIMMING:
		if (bl_header.version == 2) {
			ldim_config_load_from_unifykey(para);
		} else {
			LCDERR("bl: not support ldim for unifykey version: %d\n",
				bl_header.version);
		}
		aml_ldim_probe(dt_addr, 2);
		break;
#endif
	default:
		break;
	}

	free(para);
	return 0;
}

static const char *bl_pinmux_str[] = {
	"bl_pwm_on_pin",        /* 0 */
	"bl_pwm_vs_on_pin",     /* 1 */
	"bl_pwm_combo_0_on_pin",  /* 2 */
	"bl_pwm_combo_1_on_pin",  /* 3 */
	"bl_pwm_combo_0_vs_on_pin",  /* 4 */
	"bl_pwm_combo_1_vs_on_pin",  /* 5 */
};

#ifdef CONFIG_OF_LIBFDT
static int aml_bl_pinmux_load_from_dts(char *dt_addr, struct bl_config_s *bconf)
{
	int parent_offset;
	char propname[50];
	char *propdata;
	unsigned int temp;
	int len = 0;
	struct bl_pwm_config_s *bl_pwm;
	struct bl_pwm_config_s *pwm_combo0, *pwm_combo1;
	int pinmux_index = 0;
	int i;

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bl_pwm = bconf->bl_pwm;
		if (bl_pwm->pwm_port == BL_PWM_VS)
			pinmux_index = 1;
		else
			pinmux_index = 0;
		sprintf(propname,"/pinmux/%s", bl_pinmux_str[pinmux_index]);
		parent_offset = fdt_path_offset(dt_addr, propname);
		if (parent_offset < 0) {
			LCDERR("bl: not find %s node\n", propname);
			bl_pwm->pinmux_set[0][0] = LCD_PINMUX_END;
			bl_pwm->pinmux_set[0][1] = 0x0;
			bl_pwm->pinmux_clr[0][0] = LCD_PINMUX_END;
			bl_pwm->pinmux_clr[0][1] = 0x0;
			return -1;
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,setmask\n");
				bl_pwm->pinmux_set[0][0] = LCD_PINMUX_END;
				bl_pwm->pinmux_set[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					bl_pwm->pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					bl_pwm->pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					bl_pwm->pinmux_set[temp][0] = LCD_PINMUX_END;
					bl_pwm->pinmux_set[temp][1] = 0x0;
				}
			}
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,clrmask\n");
				bl_pwm->pinmux_clr[0][0] = LCD_PINMUX_END;
				bl_pwm->pinmux_clr[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					bl_pwm->pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					bl_pwm->pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					bl_pwm->pinmux_clr[temp][0] = LCD_PINMUX_END;
					bl_pwm->pinmux_clr[temp][1] = 0x0;
				}
			}
			if (lcd_debug_print_flag) {
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (bl_pwm->pinmux_set[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: bl_pinmux set: %d, 0x%08x\n", bl_pwm->pinmux_set[i][0], bl_pwm->pinmux_set[i][1]);
					i++;
				}
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (bl_pwm->pinmux_clr[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: bl_pinmux clr: %d, 0x%08x\n", bl_pwm->pinmux_clr[i][0], bl_pwm->pinmux_clr[i][1]);
					i++;
				}
			}
		}
		break;
	case BL_CTRL_PWM_COMBO:
		pwm_combo0 = bconf->bl_pwm_combo0;
		pwm_combo1 = bconf->bl_pwm_combo1;
		if (pwm_combo1->pwm_port == BL_PWM_VS)
			sprintf(propname,"/pinmux/%s", bl_pinmux_str[5]);
		else
			sprintf(propname,"/pinmux/%s", bl_pinmux_str[3]);

		parent_offset = fdt_path_offset(dt_addr, propname);
		if (parent_offset < 0) {
			LCDERR("bl: not find %s node\n", propname);
			pwm_combo1->pinmux_set[0][0] = LCD_PINMUX_END;
			pwm_combo1->pinmux_set[0][1] = 0x0;
			pwm_combo1->pinmux_clr[0][0] = LCD_PINMUX_END;
			pwm_combo1->pinmux_clr[0][1] = 0x0;
			return -1;
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,setmask\n");
				pwm_combo1->pinmux_set[0][0] = LCD_PINMUX_END;
				pwm_combo1->pinmux_set[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					pwm_combo1->pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					pwm_combo1->pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					pwm_combo1->pinmux_set[temp][0] = LCD_PINMUX_END;
					pwm_combo1->pinmux_set[temp][1] = 0x0;
				}
			}
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,clrmask\n");
				pwm_combo1->pinmux_clr[0][0] = LCD_PINMUX_END;
				pwm_combo1->pinmux_clr[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					pwm_combo1->pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					pwm_combo1->pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					pwm_combo1->pinmux_clr[temp][0] = LCD_PINMUX_END;
					pwm_combo1->pinmux_clr[temp][1] = 0x0;
				}
			}
			if (lcd_debug_print_flag) {
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (pwm_combo1->pinmux_set[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: pwm_combo1 pinmux_set: %d, 0x%08x\n",
						pwm_combo1->pinmux_set[i][0], pwm_combo1->pinmux_set[i][1]);
					i++;
				}
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (pwm_combo1->pinmux_clr[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: pwm_combo1 pinmux_clr: %d, 0x%08x\n",
						pwm_combo1->pinmux_clr[i][0], pwm_combo1->pinmux_clr[i][1]);
					i++;
				}
			}
		}

		if (pwm_combo0->pwm_port == BL_PWM_VS)
			sprintf(propname,"/pinmux/%s", bl_pinmux_str[4]);
		else
			sprintf(propname,"/pinmux/%s", bl_pinmux_str[2]);

		parent_offset = fdt_path_offset(dt_addr, propname);
		if (parent_offset < 0) {
			LCDERR("bl: not find %s node\n", propname);
			pwm_combo0->pinmux_set[0][0] = LCD_PINMUX_END;
			pwm_combo0->pinmux_set[0][1] = 0x0;
			pwm_combo0->pinmux_clr[0][0] = LCD_PINMUX_END;
			pwm_combo0->pinmux_clr[0][1] = 0x0;
			return -1;
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,setmask\n");
				pwm_combo0->pinmux_set[0][0] = LCD_PINMUX_END;
				pwm_combo0->pinmux_set[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					pwm_combo0->pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					pwm_combo0->pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					pwm_combo0->pinmux_set[temp][0] = LCD_PINMUX_END;
					pwm_combo0->pinmux_set[temp][1] = 0x0;
				}
			}
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,clrmask\n");
				pwm_combo0->pinmux_clr[0][0] = LCD_PINMUX_END;
				pwm_combo0->pinmux_clr[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					pwm_combo0->pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					pwm_combo0->pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					pwm_combo0->pinmux_clr[temp][0] = LCD_PINMUX_END;
					pwm_combo0->pinmux_clr[temp][1] = 0x0;
				}
			}
			if (lcd_debug_print_flag) {
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (pwm_combo0->pinmux_set[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: pwm_combo0 pinmux_set: %d, 0x%08x\n",
						pwm_combo0->pinmux_set[i][0], pwm_combo0->pinmux_set[i][1]);
					i++;
				}
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (pwm_combo0->pinmux_clr[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: pwm_combo0 pinmux_clr: %d, 0x%08x\n",
						pwm_combo0->pinmux_clr[i][0], pwm_combo0->pinmux_clr[i][1]);
					i++;
				}
			}
		}
		break;
	default:
		break;
	}

	return 0;
}
#endif

static int aml_bl_pinmux_load_from_bsp(struct bl_config_s *bconf)
{
	char propname[50];
	struct lcd_pinmux_ctrl_s *pinmux;
	unsigned int i, j;
	int pinmux_index = 0, set_cnt = 0, clr_cnt = 0;
	struct bl_pwm_config_s *bl_pwm;
	struct bl_pwm_config_s *pwm_combo0, *pwm_combo1;

	if (bconf->bl_pinmux == NULL) {
		LCDERR("bl: %s: bl_pinmux is NULL for lcd.c\n", __func__);
		return -1;
	}

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bl_pwm = bconf->bl_pwm;
		if (bl_pwm->pwm_port == BL_PWM_VS)
			pinmux_index = 1;
		else
			pinmux_index = 0;
		sprintf(propname,"%s", bl_pinmux_str[pinmux_index]);
		pinmux = bconf->bl_pinmux;
		for (i = 0; i < LCD_PINMX_MAX; i++) {
			if (strncmp(pinmux->name, "invalid", 7) == 0)
				break;
			if (strncmp(pinmux->name, propname, strlen(propname)) == 0) {
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_set[j][0] == LCD_PINMUX_END)
						break;
					bl_pwm->pinmux_set[j][0] = pinmux->pinmux_set[j][0];
					bl_pwm->pinmux_set[j][1] = pinmux->pinmux_set[j][1];
					set_cnt++;
				}
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_clr[j][0] == LCD_PINMUX_END)
						break;
					bl_pwm->pinmux_clr[j][0] = pinmux->pinmux_clr[j][0];
					bl_pwm->pinmux_clr[j][1] = pinmux->pinmux_clr[j][1];
					clr_cnt++;
				}
				break;
			}
			pinmux++;
		}
		if (set_cnt < LCD_PINMUX_NUM) {
			bl_pwm->pinmux_set[set_cnt][0] = LCD_PINMUX_END;
			bl_pwm->pinmux_set[set_cnt][1] = 0x0;
		}
		if (clr_cnt < LCD_PINMUX_NUM) {
			bl_pwm->pinmux_clr[clr_cnt][0] = LCD_PINMUX_END;
			bl_pwm->pinmux_clr[clr_cnt][1] = 0x0;
		}

		if (lcd_debug_print_flag) {
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (bl_pwm->pinmux_set[i][0] == LCD_PINMUX_END)
					break;
				LCDPR("bl: bl_pinmux set: %d, 0x%08x\n",
					bl_pwm->pinmux_set[i][0], bl_pwm->pinmux_set[i][1]);
				i++;
			}
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (bl_pwm->pinmux_clr[i][0] == LCD_PINMUX_END)
					break;
				LCDPR("bl: bl_pinmux clr: %d, 0x%08x\n",
					bl_pwm->pinmux_clr[i][0], bl_pwm->pinmux_clr[i][1]);
				i++;
			}
		}
		break;
	case BL_CTRL_PWM_COMBO:
		pwm_combo0 = bconf->bl_pwm_combo0;
		pwm_combo1 = bconf->bl_pwm_combo1;
		if (pwm_combo0->pwm_port == BL_PWM_VS)
			sprintf(propname,"%s", bl_pinmux_str[4]);
		else
			sprintf(propname,"%s", bl_pinmux_str[2]);

		pinmux = bconf->bl_pinmux;
		for (i = 0; i < LCD_PINMX_MAX; i++) {
			if (strncmp(pinmux->name, "invalid", 7) == 0)
				break;
			if (strncmp(pinmux->name, propname, strlen(propname)) == 0) {
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_set[j][0] == LCD_PINMUX_END)
						break;
					pwm_combo0->pinmux_set[j][0] = pinmux->pinmux_set[j][0];
					pwm_combo0->pinmux_set[j][1] = pinmux->pinmux_set[j][1];
					set_cnt++;
				}
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_clr[j][0] == LCD_PINMUX_END)
						break;
					pwm_combo0->pinmux_clr[j][0] = pinmux->pinmux_clr[j][0];
					pwm_combo0->pinmux_clr[j][1] = pinmux->pinmux_clr[j][1];
					clr_cnt++;
				}
				break;
			}
			pinmux++;
		}
		if (set_cnt < LCD_PINMUX_NUM) {
			pwm_combo0->pinmux_set[set_cnt][0] = LCD_PINMUX_END;
			pwm_combo0->pinmux_set[set_cnt][1] = 0x0;
		}
		if (clr_cnt < LCD_PINMUX_NUM) {
			pwm_combo0->pinmux_clr[clr_cnt][0] = LCD_PINMUX_END;
			pwm_combo0->pinmux_clr[clr_cnt][1] = 0x0;
		}

		if (lcd_debug_print_flag) {
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (pwm_combo0->pinmux_set[i][0] == LCD_PINMUX_END)
					break;
				LCDPR("bl: pwm_combo0 pinmux_set: %d, 0x%08x\n",
					pwm_combo0->pinmux_set[i][0], pwm_combo0->pinmux_set[i][1]);
				i++;
			}
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (pwm_combo0->pinmux_clr[i][0] == LCD_PINMUX_END)
					break;
				LCDPR("bl: pwm_combo0 pinmux_clr: %d, 0x%08x\n",
					pwm_combo0->pinmux_clr[i][0], pwm_combo0->pinmux_clr[i][1]);
				i++;
			}
		}

		if (pwm_combo1->pwm_port == BL_PWM_VS)
			sprintf(propname,"%s", bl_pinmux_str[5]);
		else
			sprintf(propname,"%s", bl_pinmux_str[3]);

		pinmux = bconf->bl_pinmux;
		set_cnt = 0;
		clr_cnt = 0;
		for (i = 0; i < LCD_PINMX_MAX; i++) {
			if (strncmp(pinmux->name, "invalid", 7) == 0)
				break;
			if (strncmp(pinmux->name, propname, strlen(propname)) == 0) {
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_set[j][0] == LCD_PINMUX_END)
						break;
					pwm_combo1->pinmux_set[j][0] = pinmux->pinmux_set[j][0];
					pwm_combo1->pinmux_set[j][1] = pinmux->pinmux_set[j][1];
					set_cnt++;
				}
				for (j = 0; j < LCD_PINMUX_NUM; j++ ) {
					if (pinmux->pinmux_clr[j][0] == LCD_PINMUX_END)
						break;
					pwm_combo1->pinmux_clr[j][0] = pinmux->pinmux_clr[j][0];
					pwm_combo1->pinmux_clr[j][1] = pinmux->pinmux_clr[j][1];
					clr_cnt++;
				}
				break;
			}
			pinmux++;
		}
		if (set_cnt < LCD_PINMUX_NUM) {
			pwm_combo1->pinmux_set[set_cnt][0] = LCD_PINMUX_END;
			pwm_combo1->pinmux_set[set_cnt][1] = 0x0;
		}
		if (clr_cnt < LCD_PINMUX_NUM) {
			pwm_combo1->pinmux_clr[clr_cnt][0] = LCD_PINMUX_END;
			pwm_combo1->pinmux_clr[clr_cnt][1] = 0x0;
		}
		if (lcd_debug_print_flag) {
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (pwm_combo1->pinmux_set[i][0] == LCD_PINMUX_END)
					break;
				LCDPR("bl: pwm_combo1 pinmux_set: %d, 0x%08x\n",
					pwm_combo1->pinmux_set[i][0], pwm_combo1->pinmux_set[i][1]);
				i++;
			}
			i = 0;
			while (i < LCD_PINMUX_NUM) {
				if (pwm_combo1->pinmux_clr[i][0] == LCD_PINMUX_END)
					break;
				LCDPR("bl: pwm_combo1 pinmux_clr: %d, 0x%08x\n",
					pwm_combo1->pinmux_clr[i][0], pwm_combo1->pinmux_clr[i][1]);
				i++;
			}
		}
		break;
	default:
		break;
	}

	return 0;
}

static int aml_bl_pinmux_load_default(struct bl_config_s *bconf)
{
	struct bl_pwm_config_s *bl_pwm;
	struct bl_pwm_config_s *pwm_combo0, *pwm_combo1;
	int i;

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bl_pwm = bconf->bl_pwm;
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (bconf->pinmux_set[i][0] == LCD_PINMUX_END) {
				bl_pwm->pinmux_set[i][0] = LCD_PINMUX_END;
				bl_pwm->pinmux_set[i][1] = 0;
				bl_pwm->pinmux_clr[i][0] = LCD_PINMUX_END;
				bl_pwm->pinmux_clr[i][1] = 0;
				break;
			}
			bl_pwm->pinmux_set[i][0] = bconf->pinmux_set[i][0];
			bl_pwm->pinmux_set[i][1] = bconf->pinmux_set[i][1];
			bl_pwm->pinmux_clr[i][0] = bconf->pinmux_clr[i][0];
			bl_pwm->pinmux_clr[i][1] = bconf->pinmux_clr[i][1];
			i++;
		}
		break;
	case BL_CTRL_PWM_COMBO:
		pwm_combo0 = bconf->bl_pwm_combo0;
		pwm_combo1 = bconf->bl_pwm_combo1;
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (bconf->pinmux_set[i][0] == LCD_PINMUX_END) {
				pwm_combo0->pinmux_set[i][0] = LCD_PINMUX_END;
				pwm_combo0->pinmux_set[i][1] = 0;
				pwm_combo0->pinmux_clr[i][0] = LCD_PINMUX_END;
				pwm_combo0->pinmux_clr[i][1] = 0;
				break;
			}
			pwm_combo0->pinmux_set[i][0] = bconf->pinmux_set[i][0];
			pwm_combo0->pinmux_set[i][1] = bconf->pinmux_set[i][1];
			pwm_combo0->pinmux_clr[i][0] = bconf->pinmux_clr[i][0];
			pwm_combo0->pinmux_clr[i][1] = bconf->pinmux_clr[i][1];
			i++;
		}
		pwm_combo1->pinmux_set[0][0] = LCD_PINMUX_END;
		pwm_combo1->pinmux_set[0][1] = 0x0;
		pwm_combo1->pinmux_clr[0][0] = LCD_PINMUX_END;
		pwm_combo1->pinmux_clr[0][1] = 0x0;
		break;
	default:
		break;
	}

	return 0;
}

#ifdef CONFIG_OF_LIBFDT
static int aml_bl_init_load_from_dts(char *dt_addr, struct bl_config_s *bconf)
{
	int parent_offset;
	char *propdata;
	char *p;
	const char *str;
	int i, j;
	int ret = 0;

	parent_offset = fdt_path_offset(dt_addr, "/backlight");
	if (parent_offset < 0) {
		LCDPR("bl: not find /backlight node %s\n", fdt_strerror(parent_offset));
		return -1;
	}
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "status", NULL);
	if (propdata == NULL) {
		LCDPR("bl: not find status, default to disabled\n");
		return -1;
	} else {
		if (strncmp(propdata, "okay", 2)) {
			LCDPR("bl: status disabled\n");
			return -1;
		}
	}

	/* gpio */
	i = 0;
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "bl_gpio_names", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_gpio_names\n");
	} else {
		p = propdata;
		while (i < BL_GPIO_NUM_MAX) {
			if (i > 0)
				p += strlen(p) + 1;
			str = p;
			if (strlen(str) == 0)
				break;
			strcpy(bconf->gpio_name[i], str);
			if (lcd_debug_print_flag)
				LCDPR("bl: i=%d, gpio=%s\n", i, bconf->gpio_name[i]);
			i++;
		}
	}
	for (j = i; j < BL_GPIO_NUM_MAX; j++) {
		strcpy(bconf->gpio_name[j], "invalid");
	}

	/* pinmux */
	/* new kernel dts pinctrl detect */
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "pinctrl_version", NULL);
	if (propdata)
		bconf->pinctrl_ver = (unsigned char)(be32_to_cpup((u32*)propdata));
	LCDPR("bl: pinctrl_version: %d\n", bconf->pinctrl_ver);

	switch (bconf->pinctrl_ver) {
	case 0:
		ret = aml_bl_pinmux_load_from_dts(dt_addr, bconf);
		break;
	case 2:
		ret = aml_bl_pinmux_load_from_bsp(bconf);
		break;
	case 1:
	default:
		ret = aml_bl_pinmux_load_default(bconf);
		break;
	}

	return ret;
}
#endif

static int aml_bl_init_load_from_bsp(struct bl_config_s *bconf)
{
	int ret = 0;

	ret = aml_bl_pinmux_load_default(bconf);

	return ret;
}

int aml_bl_config_load(char *dt_addr, int load_id)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
#ifdef CONFIG_OF_LIBFDT
	unsigned int index;
#endif
	char *bl_off_policy_str;
	char *bl_level_str;
	int ret;

	bl_status = 0;

	/* load bl config */
	if (load_id & 0x1) { /* dts */
		if (load_id & 0x10) { /* unifykey */
			if (lcd_debug_print_flag)
				LCDPR("bl: load bl_config from unifykey\n");
			ret = aml_bl_config_load_from_unifykey(dt_addr, lcd_drv->bl_config);
		} else { /* dts */
#ifdef CONFIG_OF_LIBFDT
			if (lcd_debug_print_flag)
				LCDPR("bl: load bl_config from dts\n");
			index = lcd_drv->lcd_config->backlight_index;
			if (index == 0xff) {
				lcd_drv->bl_config->method = BL_CTRL_MAX;
				LCDPR("bl: no backlight exist\n");
				return -1;
			}
			ret = aml_bl_config_load_from_dts(dt_addr, index, lcd_drv->bl_config);
#endif
		}
#ifdef CONFIG_OF_LIBFDT
		if (ret == 0)
			aml_bl_init_load_from_dts(dt_addr, lcd_drv->bl_config);
#endif
	} else { /* bsp */
		if (load_id & 0x10) { /* unifykey */
			if (lcd_debug_print_flag)
				LCDPR("bl: load bl_config from unifykey\n");
			ret = aml_bl_config_load_from_unifykey(dt_addr, lcd_drv->bl_config);
		} else { /* bsp */
			if (lcd_debug_print_flag)
				LCDPR("bl: load bl_config from bsp\n");
			ret = aml_bl_config_load_from_bsp(lcd_drv->bl_config);
		}
		if (ret == 0)
			aml_bl_init_load_from_bsp(lcd_drv->bl_config);
	}
	if (ret) {
		lcd_drv->bl_config->method = BL_CTRL_MAX;
		LCDPR("bl: invalid backlight config\n");
		return -1;
	}
	if (lcd_debug_print_flag) {
		aml_bl_config_print();
	} else {
		LCDPR("bl: name: %s, method: %d\n",
			lcd_drv->bl_config->name,
			lcd_drv->bl_config->method);
	}

	/* get bl_off_policy */
	bl_off_policy = BL_OFF_POLICY_NONE;
	bl_off_policy_str = getenv("bl_off");
	if (bl_off_policy_str) {
		if (strncmp(bl_off_policy_str, "none", 2) == 0)
			bl_off_policy = BL_OFF_POLICY_NONE;
		else if (strncmp(bl_off_policy_str, "always", 2) == 0)
			bl_off_policy = BL_OFF_POLICY_ALWAYS;
		else if (strncmp(bl_off_policy_str, "once", 2) == 0)
			bl_off_policy = BL_OFF_POLICY_ONCE;
		LCDPR("bl: bl_off_policy: %s\n", bl_off_policy_str);
	}

	/* get bl_level */
	bl_level_str = getenv("bl_level");
	if (bl_level_str != NULL) {
		lcd_drv->bl_config->level_default = (int)simple_strtoul(bl_level_str, NULL, 10);
		LCDPR("bl: bl_level: %d\n", lcd_drv->bl_config->level_default);
	}

	return 0;
}

