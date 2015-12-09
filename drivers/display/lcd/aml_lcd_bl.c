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
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"

static struct bl_config_s *bl_check_valid(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct bl_config_s *bconf;
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_s *bl_ext;
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
	case BL_CTRL_LOCAL_DIMING:
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

static unsigned int pwm_misc[6][5] = {
	/* pwm_reg,         pre_div, clk_sel, clk_en, pwm_en*/
	{PWM_MISC_REG_AB,   8,       4,       15,     0,},
	{PWM_MISC_REG_AB,   16,      6,       23,     1,},
	{PWM_MISC_REG_CD,   8,       4,       15,     0,},
	{PWM_MISC_REG_CD,   16,      6,       23,     1,},
	{PWM_MISC_REG_EF,   8,       4,       15,     0,},
	{PWM_MISC_REG_EF,   16,      6,       23,     1,},
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

	bl_pwm->pwm_max = (bl_pwm->pwm_cnt * bl_pwm->pwm_duty_max / 100);
	bl_pwm->pwm_min = (bl_pwm->pwm_cnt * bl_pwm->pwm_duty_min / 100);
	if (lcd_debug_print_flag)
		LCDPR("bl: pwm_max = %u, pwm_min = %u\n", bl_pwm->pwm_max, bl_pwm->pwm_min);
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

	if (level >= mid)
		level = (((level - mid) * (max - mid_map)) / (max - mid)) + mid_map;
	else
		level = (((level - min) * (mid_map - min)) / (mid - min)) + min;

	return level;
}

static void bl_set_level_pwm(struct bl_pwm_config_s *bl_pwm, unsigned int level)
{
	unsigned int pwm_hi = 0, pwm_lo = 0;
	unsigned int min = bl_pwm->level_min;
	unsigned int max = bl_pwm->level_max;
	unsigned int pwm_max = bl_pwm->pwm_max;
	unsigned int pwm_min = bl_pwm->pwm_min;
	unsigned int port = bl_pwm->pwm_port;
	unsigned int vs[4], ve[4], sw, n, i;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	level = bl_level_mapping(level);
	max = bl_level_mapping(max);
	min = bl_level_mapping(min);
	level = (pwm_max - pwm_min) * (level - min) / (max - min) + pwm_min;
	switch (bl_pwm->pwm_method) {
	case BL_PWM_POSITIVE:
		pwm_hi = level;
		pwm_lo = bl_pwm->pwm_cnt - level;
		break;
	case BL_PWM_NEGATIVE:
		pwm_lo = level;
		pwm_hi = bl_pwm->pwm_cnt - level;
		break;
	default:
		break;
	}

	switch (port) {
	case BL_PWM_A:
	case BL_PWM_B:
	case BL_PWM_C:
	case BL_PWM_D:
		lcd_cbus_write(pwm_reg[port], (pwm_hi << 16) | pwm_lo);
		break;
	case BL_PWM_E:
	case BL_PWM_F:
		if (lcd_drv->chip_type >= LCD_CHIP_M8)
			lcd_cbus_write(pwm_reg[port], (pwm_hi << 16) | pwm_lo);
		break;
	case BL_PWM_VS:
		memset(vs, 0, sizeof(unsigned int) * 4);
		memset(ve, 0, sizeof(unsigned int) * 4);
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
		lcd_vcbus_write(VPU_VPU_PWM_V0, (ve[0] << 16) | (vs[0]));
		lcd_vcbus_write(VPU_VPU_PWM_V1, (ve[1] << 16) | (vs[1]));
		lcd_vcbus_write(VPU_VPU_PWM_V2, (ve[2] << 16) | (vs[2]));
		lcd_vcbus_write(VPU_VPU_PWM_V3, (ve[3] << 16) | (vs[3]));
		break;
	default:
		break;
	}
}

void aml_bl_set_level(unsigned int level)
{
	unsigned int temp = 0;
	struct bl_config_s *bconf;
	struct bl_pwm_config_s *pwm0, *pwm1;
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_s *bl_ext;
#endif

	bconf = bl_check_valid();
	if (bconf == NULL)
		return;

	LCDPR("bl: set level: %u, last level: %u\n", level, bconf->level);
	level = (level > bconf->level_max ? bconf->level_max :
			(level < bconf->level_min ? bconf->level_min : level));
	bconf->level = level;

	/* mapping */
	if (level > bconf->level_mid) {
		level = ((level - bconf->level_mid) * (bconf->level_max - bconf->level_mid_mapping)) /
			(bconf->level_max - bconf->level_mid) + bconf->level_mid_mapping;
	} else {
		level = ((level - bconf->level_min) * (bconf->level_mid_mapping - bconf->level_min)) /
			(bconf->level_mid - bconf->level_min) + bconf->level_min;
	}

	switch (bconf->method) {
	case BL_CTRL_GPIO:
		break;
	case BL_CTRL_PWM:
		bl_set_level_pwm(bconf->bl_pwm, level);
		break;
	case BL_CTRL_PWM_COMBO:
		pwm0 = bconf->bl_pwm_combo0;
		pwm1 = bconf->bl_pwm_combo1;
		if ((level >= pwm0->level_min) || (level <= pwm0->level_max)) {
			temp = (pwm0->level_min > pwm1->level_min) ? pwm1->level_max : pwm1->level_min;
			bl_set_level_pwm(pwm0, level);
			bl_set_level_pwm(pwm1, temp);
		} else if ((level >= pwm1->level_min) || (level <= pwm1->level_max)) {
			temp = (pwm1->level_min > pwm0->level_min) ? pwm0->level_max : pwm0->level_min;
			bl_set_level_pwm(pwm0, temp);
			bl_set_level_pwm(pwm1, level);
		}
		break;
#ifdef CONFIG_AML_LOCAL_DIMMING
	case BL_CTRL_LOCAL_DIMING:
		/* to do */
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

static void bl_pwm_pinmux_ctrl(struct bl_config_s *bconf, int status)
{
	int i;

	if (status) {
		/* set pin mux */
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (bconf->pinmux_clr[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_clr_mask(bconf->pinmux_clr[i][0],
				bconf->pinmux_clr[i][1]);
			i++;
		}
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (bconf->pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_set_mask(bconf->pinmux_set[i][0],
				bconf->pinmux_set[i][1]);
			i++;
		}
	} else {
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (bconf->pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_clr_mask(bconf->pinmux_set[i][0],
				bconf->pinmux_set[i][1]);
			i++;
		}
		switch (bconf->method) {
		case BL_CTRL_PWM:
			if (bconf->bl_pwm->pwm_gpio < BL_GPIO_NUM_MAX) {
				aml_lcd_gpio_set(bconf->bl_pwm->pwm_gpio,
					bconf->bl_pwm->pwm_gpio_off);
			}
			break;
		case BL_CTRL_PWM_COMBO:
			if (bconf->bl_pwm_combo0->pwm_gpio < BL_GPIO_NUM_MAX) {
				aml_lcd_gpio_set(bconf->bl_pwm_combo0->pwm_gpio,
					bconf->bl_pwm_combo0->pwm_gpio_off);
			}
			if (bconf->bl_pwm_combo1->pwm_gpio < BL_GPIO_NUM_MAX) {
				aml_lcd_gpio_set(bconf->bl_pwm_combo1->pwm_gpio,
					bconf->bl_pwm_combo1->pwm_gpio_off);
			}
			break;
		default:
			break;
		}
	}
}

static void bl_pwm_ctrl(struct bl_pwm_config_s *bl_pwm, int status)
{
	int port, pre_div;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	port = bl_pwm->pwm_port;
	pre_div = bl_pwm->pwm_pre_div;
	if (status) {
		/* enable pwm */
		switch (port) {
		case BL_PWM_A:
		case BL_PWM_B:
		case BL_PWM_C:
		case BL_PWM_D:
			/* pwm clk_div */
			lcd_cbus_setb(pwm_misc[port][0], pre_div, pwm_misc[port][1], 7);
			/* pwm clk_sel */
			lcd_cbus_setb(pwm_misc[port][0], 0, pwm_misc[port][2], 2);
			/* pwm clk_en */
			lcd_cbus_setb(pwm_misc[port][0], 1, pwm_misc[port][3], 1);
			/* pwm enable */
			lcd_cbus_setb(pwm_misc[port][0], 1, pwm_misc[port][4], 1);
			break;
		case BL_PWM_E:
		case BL_PWM_F:
			if (lcd_drv->chip_type >= LCD_CHIP_M8) {
				/* pwm clk_div */
				lcd_cbus_setb(pwm_misc[port][0], pre_div, pwm_misc[port][1], 7);
				/* pwm clk_sel */
				lcd_cbus_setb(pwm_misc[port][0], 0, pwm_misc[port][2], 2);
				/* pwm clk_en */
				lcd_cbus_setb(pwm_misc[port][0], 1, pwm_misc[port][3], 1);
				/* pwm enable */
				lcd_cbus_setb(pwm_misc[port][0], 1, pwm_misc[port][4], 1);
			}
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
			lcd_cbus_setb(pwm_misc[port][0], 0, pwm_misc[port][4], 1);
			break;
		case BL_PWM_E:
		case BL_PWM_F:
			if (lcd_drv->chip_type >= LCD_CHIP_M8)
				lcd_cbus_setb(pwm_misc[port][0], 0, pwm_misc[port][4], 1);
			break;
		default:
			break;
		}
	}
}

static void bl_power_en_ctrl(struct bl_config_s *bconf, int status)
{
	if (status) {
		if (bconf->power_on_delay > 0)
			mdelay(bconf->power_on_delay);
		if (bconf->en_gpio < BL_GPIO_NUM_MAX)
			aml_lcd_gpio_set(bconf->en_gpio, bconf->en_gpio_on);
	} else {
		if (bconf->en_gpio < BL_GPIO_NUM_MAX)
			aml_lcd_gpio_set(bconf->en_gpio, bconf->en_gpio_off);
		if (bconf->power_off_delay > 0)
			mdelay(bconf->power_off_delay);
	}
}

void aml_bl_power_ctrl(int status)
{
	int gpio, value;
	struct bl_config_s *bconf;
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_s *bl_ext;
#endif

	bconf = bl_check_valid();
	if (bconf == NULL)
		return;

	gpio = bconf->en_gpio;
	value = status ? bconf->en_gpio_on : bconf->en_gpio_off;
	if (lcd_debug_print_flag)
		LCDPR("bl: status=%d gpio=%d value=%d\n", status, gpio, value);

	if (status) {
		switch (bconf->method) {
		case BL_CTRL_GPIO:
			bl_power_en_ctrl(bconf, 1);
			break;
		case BL_CTRL_PWM:
			/* step 1: power on pwm */
			if (bconf->pwm_on_delay > 0)
				mdelay(bconf->pwm_on_delay);
			bl_pwm_ctrl(bconf->bl_pwm, 1);
			bl_pwm_pinmux_ctrl(bconf, 1);
			/* step 2: power on enable */
			bl_power_en_ctrl(bconf, 1);
			break;
		case BL_CTRL_PWM_COMBO:
			/* step 1: power on pwm_combo */
			if (bconf->pwm_on_delay > 0)
				mdelay(bconf->pwm_on_delay);
			bl_pwm_ctrl(bconf->bl_pwm_combo0, 1);
			bl_pwm_ctrl(bconf->bl_pwm_combo1, 1);
			bl_pwm_pinmux_ctrl(bconf, 1);
			/* step 2: power on enable */
			bl_power_en_ctrl(bconf, 1);
			break;
#ifdef CONFIG_AML_LOCAL_DIMMING
		case BL_CTRL_LOCAL_DIMING:
			/* step 1: power on enable */
			bl_power_en_ctrl(bconf, 1);
			/* step 2: power on ldim */
			aml_bl_power_ctrl_ldim(1);
			break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
		case BL_CTRL_EXTERN:
			/* step 1: power on enable */
			bl_power_en_ctrl(bconf, 1);
			/* step 2: power on bl_extern */
			bl_ext = aml_bl_extern_get_driver();
			if (bl_ext->power_on)
				bl_ext->power_on();
			else
				LCDERR("bl: bl_extern power on is null\n");
			break;
#endif
		default:
			if (lcd_debug_print_flag)
				LCDERR("bl: wrong backlight control method\n");
			break;
		}
	} else {
		switch (bconf->method) {
		case BL_CTRL_GPIO:
			bl_power_en_ctrl(bconf, 0);
			break;
		case BL_CTRL_PWM:
			/* step 1: power off enable */
			bl_power_en_ctrl(bconf, 0);
			/* step 2: power off pwm */
			bl_pwm_ctrl(bconf->bl_pwm, 0);
			bl_pwm_pinmux_ctrl(bconf, 0);
			if (bconf->pwm_off_delay > 0)
				mdelay(bconf->pwm_off_delay);
			break;
		case BL_CTRL_PWM_COMBO:
			/* step 1: power off enable */
			bl_power_en_ctrl(bconf, 0);
			/* step 2: power off pwm_combo */
			bl_pwm_ctrl(bconf->bl_pwm_combo0, 0);
			bl_pwm_ctrl(bconf->bl_pwm_combo1, 0);
			bl_pwm_pinmux_ctrl(bconf, 0);
			if (bconf->pwm_off_delay > 0)
				mdelay(bconf->pwm_off_delay);
			break;
#ifdef CONFIG_AML_LOCAL_DIMMING
		case BL_CTRL_LOCAL_DIMING:
			/* step 1: power off ldim */
			aml_bl_power_ctrl_ldim(0);
			/* step 2: power off enable */
			bl_power_en_ctrl(bconf, 0);
			break;
#endif
#ifdef CONFIG_AML_BL_EXTERN
		case BL_CTRL_EXTERN:
			/* step 1: power off bl_extern */
			bl_ext = aml_bl_extern_get_driver();
			if (bl_ext->power_off)
				bl_ext->power_off();
			else
				LCDERR("bl: bl_extern: power off is null\n");
			/* step 2: power off enable */
			bl_power_en_ctrl(bconf, 0);
			break;
#endif
		default:
			if (lcd_debug_print_flag)
				LCDERR("bl: wrong backlight control method\n");
			break;
		}
	}
	LCDPR("bl: %s: %d\n", __func__, status);
}

#ifdef CONFIG_OF_LIBFDT
static const char *bl_pinmux_str[] = {
	"bl_pwm_on_pin",        /* 0 */
	"bl_pwm_vs_on_pin",     /* 1 */
	"bl_pwm_combo_on_pin",  /* 2 */
};

static char *bl_pwm_name[] = {
	"PWM_A",
	"PWM_B",
	"PWM_C",
	"PWM_D",
	"PWM_E",
	"PWM_F",
	"PWM_VS",
};

static enum bl_pwm_port_e bl_pwm_str_to_pwm(const char *str)
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

int aml_bl_config_load_from_dts(char *dt_addr, unsigned int index, struct bl_config_s *bconf)
{
	int parent_offset;
	char *propdata;
	char *p;
	const char *str;
	char propname[30];
	int child_offset;
	unsigned int temp;
	int len = 0;
	unsigned int i, j;
	struct bl_pwm_config_s *bl_pwm;
	struct bl_pwm_config_s *pwm_combo0, *pwm_combo1;
	int pinmux_index = 0;

	bconf->method = BL_CTRL_MAX; /* default */
	parent_offset = fdt_path_offset(dt_addr, "/backlight");
	if (parent_offset < 0) {
		LCDPR("bl: not find /backlight node %s\n", fdt_strerror(parent_offset));
		return 0;
	}
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "status", NULL);
	if (propdata == NULL) {
		LCDPR("bl: not find status, default to disabled\n");
		return 0;
	} else {
		if (strncmp(propdata, "okay", 2)) {
			LCDPR("bl: status disabled\n");
			return 0;
		}
	}

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

	sprintf(propname,"/backlight/backlight_%d", index);
	child_offset = fdt_path_offset(dt_addr, propname);
	if (child_offset < 0) {
		LCDERR("bl: not find %s node %s\n", propname, fdt_strerror(child_offset));
		return 0;
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
		return 0;
	} else {
		bconf->method = be32_to_cpup((u32*)propdata);
	}
	LCDPR("bl: ctrl_method=%d\n", bconf->method);
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_power_attr", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_power_attr\n");
		bconf->en_gpio = LCD_GPIO_MAX;
		bconf->en_gpio_on = LCD_GPIO_OUTPUT_HIGH;
		bconf->en_gpio_off = LCD_GPIO_OUTPUT_LOW;
		bconf->power_on_delay = 100;
		bconf->power_off_delay = 30;
	} else {
		temp = be32_to_cpup((u32*)propdata);
		if (temp >= BL_GPIO_NUM_MAX) {
			bconf->en_gpio = LCD_GPIO_MAX;
		} else {
			str = bconf->gpio_name[temp];
			bconf->en_gpio = aml_lcd_gpio_name_map_num(str);
		}
		bconf->en_gpio_on = be32_to_cpup((((u32*)propdata)+1));
		bconf->en_gpio_off = be32_to_cpup((((u32*)propdata)+2));
		bconf->power_on_delay = be32_to_cpup((((u32*)propdata)+3));
		bconf->power_off_delay = be32_to_cpup((((u32*)propdata)+4));
	}
	if (lcd_debug_print_flag) {
		LCDPR("bl: bl_en gpio=%d, on=%d, off=%d\n",
			bconf->en_gpio, bconf->en_gpio_on, bconf->en_gpio_off);
		LCDPR("bl: bl_power_delay on=%d, off=%d\n",
			bconf->power_on_delay, bconf->power_off_delay);
	}

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bconf->bl_pwm = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm == NULL) {
			LCDERR("bl: bl_pwm struct malloc error\n");
			return -1;
		}
		bl_pwm = bconf->bl_pwm;

		bl_pwm->level_max = bconf->level_max;
		bl_pwm->level_min = bconf->level_min;

		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_port", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_port\n");
			bl_pwm->pwm_port = BL_PWM_MAX;
		} else {
			bl_pwm->pwm_port = bl_pwm_str_to_pwm(propdata);
		}
		if (lcd_debug_print_flag)
			LCDPR("bl: bl_pwm port=%d\n", bl_pwm->pwm_port);
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
		if (lcd_debug_print_flag) {
			LCDPR("bl: bl_pwm method=%d\n", bl_pwm->pwm_method);
			LCDPR("bl: bl_pwm_duty max=%d%%, min=%d%%\n",
				bl_pwm->pwm_duty_max, bl_pwm->pwm_duty_min);
		}
		if (bl_pwm->pwm_port == BL_PWM_VS) {
			if (bl_pwm->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", bl_pwm->pwm_freq);
				bl_pwm->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
			if (lcd_debug_print_flag)
				LCDPR("bl: bl_pwm freq=%d x Vfreq\n", bl_pwm->pwm_freq);
		} else {
			if (bl_pwm->pwm_freq > XTAL_HALF_FREQ_HZ)
				bl_pwm->pwm_freq = XTAL_HALF_FREQ_HZ;
			if (lcd_debug_print_flag)
				LCDPR("bl_pwm freq=%dHz\n", bl_pwm->pwm_freq);
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_power", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_power\n");
			bl_pwm->pwm_gpio = LCD_GPIO_MAX;
			bl_pwm->pwm_gpio_off = LCD_GPIO_OUTPUT_LOW;
			bconf->pwm_on_delay = 10;
			bconf->pwm_off_delay = 10;
		} else {
			temp = be32_to_cpup((u32*)propdata);
			if (temp >= BL_GPIO_NUM_MAX) {
				bl_pwm->pwm_gpio = LCD_GPIO_MAX;
			} else {
				str = bconf->gpio_name[temp];
				bl_pwm->pwm_gpio = aml_lcd_gpio_name_map_num(str);
			}
			bl_pwm->pwm_gpio_off = be32_to_cpup((((u32*)propdata)+1));
			bconf->pwm_on_delay = be32_to_cpup((((u32*)propdata)+2));
			bconf->pwm_off_delay = be32_to_cpup((((u32*)propdata)+3));
		}
		if (lcd_debug_print_flag) {
			LCDPR("bl: bl_pwm gpio=%d, gpio_off=%d\n",
				bl_pwm->pwm_gpio, bl_pwm->pwm_gpio_off);
			LCDPR("bl: bl_pwm_delay on=%d, off=%d\n",
				bconf->pwm_on_delay, bconf->pwm_off_delay);
		}

		bl_pwm_config_init(bl_pwm);
		if (bl_pwm->pwm_port == BL_PWM_VS)
			pinmux_index = 1;
		else
			pinmux_index = 0;
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
		if (lcd_debug_print_flag) {
			LCDPR("bl: pwm_port combo0=%d, combo1=%d\n",
				pwm_combo0->pwm_port, pwm_combo1->pwm_port);
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
		if (lcd_debug_print_flag) {
			LCDPR("bl: bl_pwm_method combo0=%d, combo1=%d\n",
				pwm_combo0->pwm_method, pwm_combo1->pwm_method);
			LCDPR("bl: bl_pwm_duty combo0_max=%d%%, combo0_min=%d%%\n",
				pwm_combo0->pwm_duty_max, pwm_combo0->pwm_duty_min);
			LCDPR("bl: bl_pwm_duty combo1_max=%d%%, combo1_min=%d%%\n",
				pwm_combo1->pwm_duty_max, pwm_combo1->pwm_duty_min);
		}
		if (pwm_combo0->pwm_port == BL_PWM_VS) {
			if (pwm_combo0->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", pwm_combo0->pwm_freq);
				pwm_combo0->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
			if (lcd_debug_print_flag)
				LCDPR("bl: bl_pwm combo0_freq=%d x Vfreq\n", pwm_combo0->pwm_freq);
		} else {
			if (pwm_combo0->pwm_freq > XTAL_HALF_FREQ_HZ)
				pwm_combo0->pwm_freq = XTAL_HALF_FREQ_HZ;
			if (lcd_debug_print_flag)
				LCDPR("bl_pwm combo0_freq=%dHz\n", pwm_combo0->pwm_freq);
		}
		if (pwm_combo1->pwm_port == BL_PWM_VS) {
			if (pwm_combo1->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", pwm_combo1->pwm_freq);
				pwm_combo1->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
			if (lcd_debug_print_flag)
				LCDPR("bl: bl_pwm combo0_freq=%d x Vfreq\n", pwm_combo1->pwm_freq);
		} else {
			if (pwm_combo1->pwm_freq > XTAL_HALF_FREQ_HZ)
				pwm_combo1->pwm_freq = XTAL_HALF_FREQ_HZ;
			if (lcd_debug_print_flag)
				LCDPR("bl_pwm combo0_freq=%dHz\n", pwm_combo1->pwm_freq);
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_combo_power", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_combo_power\n");
			pwm_combo0->pwm_gpio = LCD_GPIO_MAX;
			pwm_combo0->pwm_gpio_off = LCD_GPIO_INPUT;
			pwm_combo1->pwm_gpio = LCD_GPIO_MAX;
			pwm_combo1->pwm_gpio_off = LCD_GPIO_INPUT;
			bconf->pwm_on_delay = 10;
			bconf->pwm_off_delay = 10;
		} else {
			temp = be32_to_cpup((u32*)propdata);
			if (temp >= BL_GPIO_NUM_MAX) {
				pwm_combo0->pwm_gpio = LCD_GPIO_MAX;
			} else {
				str = bconf->gpio_name[temp];
				pwm_combo0->pwm_gpio = aml_lcd_gpio_name_map_num(str);
			}
			pwm_combo0->pwm_gpio_off = be32_to_cpup((((u32*)propdata)+1));
			temp = be32_to_cpup((((u32*)propdata)+2));
			if (temp >= BL_GPIO_NUM_MAX) {
				pwm_combo1->pwm_gpio = LCD_GPIO_MAX;
			} else {
				str = bconf->gpio_name[temp];
				pwm_combo1->pwm_gpio = aml_lcd_gpio_name_map_num(str);
			}
			pwm_combo1->pwm_gpio_off = be32_to_cpup((((u32*)propdata)+3));
			bconf->pwm_on_delay = be32_to_cpup((((u32*)propdata)+4));
			bconf->pwm_off_delay = be32_to_cpup((((u32*)propdata)+5));
		}
		if (lcd_debug_print_flag) {
			LCDPR("bl: bl_pwm combo0 gpio=%d, gpio_off=%d\n",
				pwm_combo0->pwm_gpio, pwm_combo0->pwm_gpio_off);
			LCDPR("bl: bl_pwm combo1 gpio=%d, gpio_off=%d\n",
				pwm_combo1->pwm_gpio, pwm_combo1->pwm_gpio_off);
			LCDPR("bl: bl_pwm_delay on=%d, off=%d\n",
				bconf->pwm_on_delay, bconf->pwm_off_delay);
		}

		bl_pwm_config_init(pwm_combo0);
		bl_pwm_config_init(pwm_combo1);
		pinmux_index = 2;
		break;
	default:
		return 0;
		break;
	}

	switch (bconf->method) {
	case BL_CTRL_PWM:
	case BL_CTRL_PWM_COMBO:
		sprintf(propname,"/pinmux/%s", bl_pinmux_str[pinmux_index]);
		parent_offset = fdt_path_offset(dt_addr, propname);
		if (parent_offset < 0) {
			LCDERR("bl: not find %s node\n", propname);
			bconf->pinmux_set[0][0] = LCD_PINMUX_END;
			bconf->pinmux_set[0][1] = 0x0;
			bconf->pinmux_clr[0][0] = LCD_PINMUX_END;
			bconf->pinmux_clr[0][1] = 0x0;
			return 0;
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,setmask\n");
				bconf->pinmux_set[0][0] = LCD_PINMUX_END;
				bconf->pinmux_set[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					bconf->pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					bconf->pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					bconf->pinmux_set[temp][0] = LCD_PINMUX_END;
					bconf->pinmux_set[temp][1] = 0x0;
				}
			}
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,clrmask\n");
				bconf->pinmux_clr[0][0] = LCD_PINMUX_END;
				bconf->pinmux_clr[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					bconf->pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					bconf->pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					bconf->pinmux_clr[temp][0] = LCD_PINMUX_END;
					bconf->pinmux_clr[temp][1] = 0x0;
				}
			}
			if (lcd_debug_print_flag) {
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (bconf->pinmux_set[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: bl_pinmux set: %d, 0x%08x\n", bconf->pinmux_set[i][0], bconf->pinmux_set[i][1]);
					i++;
				}
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (bconf->pinmux_clr[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: bl_pinmux clr: %d, 0x%08x\n", bconf->pinmux_clr[i][0], bconf->pinmux_clr[i][1]);
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

int aml_bl_config_load_from_bsp(struct bl_config_s *bconf)
{
	struct ext_lcd_config_s *ext_lcd = NULL;
	char *panel_type = getenv("panel_type");
	unsigned int i = 0;
	char *str;
	struct bl_pwm_config_s *bl_pwm;
	struct bl_pwm_config_s *pwm_combo0, *pwm_combo1;

	if (panel_type == NULL) {
		LCDERR("bl: no panel_type, use default backlight config\n");
		return 0;
	}
	for (i = 0; i < LCD_NUM_MAX; i++) {
		ext_lcd = &ext_lcd_config[i];
		if (strcmp(ext_lcd->panel_type, panel_type) == 0)
			break;
	}
	if (i >= LCD_NUM_MAX) {
		LCDERR("bl: can't find %s, use default backlight config\n ", panel_type);
		return 0;
	}

	strcpy(bconf->name, panel_type);
	bconf->level_default     = ext_lcd->level_default;
	bconf->level_min         = ext_lcd->level_min;
	bconf->level_max         = ext_lcd->level_max;
	bconf->level_mid         = ext_lcd->level_mid;
	bconf->level_mid_mapping = ext_lcd->level_mid_mapping;

	bconf->method          = ext_lcd->bl_method;
	LCDPR("bl: method: %d\n", bconf->method);

	if (ext_lcd->bl_en_gpio >= BL_GPIO_NUM_MAX) {
		bconf->en_gpio    = LCD_GPIO_MAX;
	} else {
		str = bconf->gpio_name[ext_lcd->bl_en_gpio];
		bconf->en_gpio    = aml_lcd_gpio_name_map_num(str);
	}
	bconf->en_gpio_on      = ext_lcd->bl_en_gpio_on;
	bconf->en_gpio_off     = ext_lcd->bl_en_gpio_off;
	bconf->power_on_delay  = ext_lcd->bl_power_on_delay;
	bconf->power_off_delay = ext_lcd->bl_power_off_delay;

	if (lcd_debug_print_flag) {
		LCDPR("bl: level_default     = %d\n", bconf->level_default);
		LCDPR("bl: level_min         = %d\n", bconf->level_min);
		LCDPR("bl: level_max         = %d\n", bconf->level_max);
		LCDPR("bl: level_mid         = %d\n", bconf->level_mid);
		LCDPR("bl: level_mid_mapping = %d\n", bconf->level_mid_mapping);

		LCDPR("bl: en_gpio           = %d\n", bconf->en_gpio);
		LCDPR("bl: en_gpio_on        = %d\n", bconf->en_gpio_on);
		LCDPR("bl: en_gpio_off       = %d\n", bconf->en_gpio_off);
		LCDPR("bl: power_on_delay    = %d\n", bconf->power_on_delay);
		LCDPR("bl: power_off_delay   = %d\n\n", bconf->power_off_delay);
	}

	switch (bconf->method) {
	case BL_CTRL_PWM:
		bconf->bl_pwm = (struct bl_pwm_config_s *)malloc(sizeof(struct bl_pwm_config_s));
		if (bconf->bl_pwm == NULL) {
			LCDERR("bl: bl_pwm struct malloc error\n");
			return -1;
		}
		bl_pwm = bconf->bl_pwm;

		bl_pwm->level_max     = bconf->level_max;
		bl_pwm->level_min     = bconf->level_min;

		bl_pwm->pwm_method    = ext_lcd->pwm_method;
		bl_pwm->pwm_port      = ext_lcd->pwm_port;
		bl_pwm->pwm_freq      = ext_lcd->pwm_freq;
		bl_pwm->pwm_duty_max  = ext_lcd->pwm_duty_max;
		bl_pwm->pwm_duty_min  = ext_lcd->pwm_duty_min;
		if (ext_lcd->pwm_gpio >= BL_GPIO_NUM_MAX) {
			bl_pwm->pwm_gpio = LCD_GPIO_MAX;
		} else {
			str = bconf->gpio_name[ext_lcd->pwm_gpio];
			bl_pwm->pwm_gpio = aml_lcd_gpio_name_map_num(str);
		}
		bl_pwm->pwm_gpio_off  = ext_lcd->pwm_gpio_off;
		bconf->pwm_on_delay   = ext_lcd->pwm_on_delay;
		bconf->pwm_off_delay  = ext_lcd->pwm_off_delay;

		if (lcd_debug_print_flag) {
			LCDPR("bl: pwm_method    = %d\n", bl_pwm->pwm_method);
			LCDPR("bl: pwm_port      = %d\n", bl_pwm->pwm_port);
			LCDPR("bl: pwm_freq      = %d\n", bl_pwm->pwm_freq);
			LCDPR("bl: pwm_duty_max  = %d\n", bl_pwm->pwm_duty_max);
			LCDPR("bl: pwm_duty_min  = %d\n", bl_pwm->pwm_duty_min);
			LCDPR("bl: pwm_gpio      = %d\n", bl_pwm->pwm_gpio);
			LCDPR("bl: pwm_gpio_off  = %d\n", bl_pwm->pwm_gpio_off);
			LCDPR("bl: pwm_on_delay  = %d\n", bconf->pwm_on_delay);
			LCDPR("bl: pwm_off_delay = %d\n", bconf->pwm_off_delay);
		}
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

		if (lcd_debug_print_flag) {
			LCDPR("bl: pwm_combo0_method   = %d\n", pwm_combo0->pwm_method);
			LCDPR("bl: pwm_combo0_port     = %d\n", pwm_combo0->pwm_port);
			LCDPR("bl: pwm_combo0_freq     = %d\n", pwm_combo0->pwm_freq);
			LCDPR("bl: pwm_combo0_duty_max = %d\n", pwm_combo0->pwm_duty_max);
			LCDPR("bl: pwm_combo0_duty_min = %d\n", pwm_combo0->pwm_duty_min);
			LCDPR("bl: pwm_combo0_gpio     = %d\n", pwm_combo0->pwm_gpio);
			LCDPR("bl: pwm_combo0_gpio_off = %d\n", pwm_combo0->pwm_gpio_off);
			LCDPR("bl: pwm_combo1_method   = %d\n", pwm_combo1->pwm_method);
			LCDPR("bl: pwm_combo1_port     = %d\n", pwm_combo1->pwm_port);
			LCDPR("bl: pwm_combo1_freq     = %d\n", pwm_combo1->pwm_freq);
			LCDPR("bl: pwm_combo1_duty_max = %d\n", pwm_combo1->pwm_duty_max);
			LCDPR("bl: pwm_combo1_duty_min = %d\n", pwm_combo1->pwm_duty_min);
			LCDPR("bl: pwm_combo1_gpio     = %d\n", pwm_combo1->pwm_gpio);
			LCDPR("bl: pwm_combo1_gpio_off = %d\n", pwm_combo1->pwm_gpio_off);
			LCDPR("bl: pwm_on_delay        = %d\n", bconf->pwm_on_delay);
			LCDPR("bl: pwm_off_delay       = %d\n", bconf->pwm_off_delay);
		}
		break;
	case BL_CTRL_LOCAL_DIMING:
		break;
	case BL_CTRL_EXTERN:
		break;
	default:
		if (lcd_debug_print_flag)
			LCDERR("bl: wrong backlight control method\n");
		break;
	}

	return 0;
}

