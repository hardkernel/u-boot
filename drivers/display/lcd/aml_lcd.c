/*
 * drivers/display/lcd/aml_lcd.c
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
#ifdef CONFIG_AML_LCD_EXTERN
#include <amlogic/aml_lcd_extern.h>
#endif
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"

#define PANEL_NAME	"panel"

unsigned int lcd_debug_print_flag;
static struct aml_lcd_drv_s aml_lcd_driver;

static void lcd_chip_detect(void)
{
#if 0
	unsigned int cpu_type;

	cpu_type = get_cpu_type();
	switch (cpu_type) {
	case MESON_CPU_MAJOR_ID_M8:
		aml_lcd_driver.chip_type = LCD_CHIP_M8;
		break;
	case MESON_CPU_MAJOR_ID_M8B:
		aml_lcd_driver.chip_type = LCD_CHIP_M8B;
		break;
	case MESON_CPU_MAJOR_ID_M8M2:
		aml_lcd_driver.chip_type = LCD_CHIP_M8M2;
		break;
	case MESON_CPU_MAJOR_ID_MG9TV:
		aml_lcd_driver.chip_type = LCD_CHIP_G9TV;
		break;
	case MESON_CPU_MAJOR_ID_GXTVBB:
		aml_lcd_driver.chip_type = LCD_CHIP_GXTVBB;
		break;
	default:
		aml_lcd_driver.chip_type = LCD_CHIP_MAX;
	}
#else
	aml_lcd_driver.chip_type = LCD_CHIP_GXTVBB;
#endif
	if (lcd_debug_print_flag)
		LCDPR("check chip: %d\n", aml_lcd_driver.chip_type);
}

static int lcd_check_valid(void)
{
	if (aml_lcd_driver.config_check == NULL) {
		LCDERR("invalid lcd config\n");
		return -1;
	}
	return 0;
}

static int lcd_backlight_check_valid(void)
{
	if (aml_lcd_driver.bl_config->method >= BL_CTRL_MAX) {
		LCDERR("bl: invalid bl control method: %d\n",
			aml_lcd_driver.bl_config->method);
		return -1;
	}
	return 0;
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

static void lcd_backlight_pwm_config(struct bl_config_s *blconf)
{
	unsigned int freq, pre_div, cnt;
	int i;

	freq = blconf->pwm_freq;
	if (blconf->pwm_port == BL_PWM_VS) {
		cnt = lcd_vcbus_read(ENCL_VIDEO_MAX_LNCNT) + 1;
		blconf->pwm_cnt = cnt;
		if (lcd_debug_print_flag)
			LCDPR("bl: pwm_cnt = %u\n", blconf->pwm_cnt);
	} else {
		for (i = 0; i < 0x7f; i++) {
			pre_div = i;
			cnt = XTAL_FREQ_HZ / (freq * (pre_div + 1)) - 2;
			if (cnt <= 0xffff) /* 16bit */
				break;
		}
		blconf->pwm_cnt = cnt;
		blconf->pwm_pre_div = pre_div;
		if (lcd_debug_print_flag)
			LCDPR("bl: pwm_cnt = %u, pwm_pre_div = %u\n", cnt, pre_div);
	}

	blconf->pwm_max = (cnt * blconf->pwm_duty_max / 100);
	blconf->pwm_min = (cnt * blconf->pwm_duty_min / 100);
	if (lcd_debug_print_flag)
		LCDPR("bl: pwm_max = %u, pwm_min = %u\n", blconf->pwm_max, blconf->pwm_min);
}

static void lcd_bakclight_pwm_duty(unsigned int pwm_high, unsigned int pwm_low)
{
	unsigned int high = 0, low = 0;
	unsigned int vs[4], ve[4], sw, n, i;
	struct bl_config_s *blconf = aml_lcd_driver.bl_config;

	if (lcd_debug_print_flag)
		LCDPR("bl: pwm_hi=%u pwm_lo=%u \n", pwm_high, pwm_low);
	if (blconf->pwm_port == BL_PWM_VS) {
		memset(vs, 0, sizeof(unsigned int) * 4);
		memset(ve, 0, sizeof(unsigned int) * 4);
		n = blconf->pwm_freq;
		sw = (blconf->pwm_cnt * 10 / n + 5) / 10;
		if (blconf->pwm_method == BL_PWM_NEGATIVE)
			high = (pwm_low * 10 / n + 5) / 10;
		else
			high = (pwm_high * 10 / n + 5) / 10;
		high = (high > 1) ? high : 1;
		for (i = 0; i < n; i++) {
			vs[i] = 1 + (sw * i);
			ve[i] = vs[i] + high - 1;
		}
	} else {
		if (blconf->pwm_method == BL_PWM_NEGATIVE) {
			high = pwm_low;
			low = pwm_high;
		} else {
			high = pwm_high;
			low = pwm_low;
		}
	}

	switch (blconf->pwm_port) {
	case BL_PWM_A:
	case BL_PWM_B:
	case BL_PWM_C:
	case BL_PWM_D:
	case BL_PWM_E:
	case BL_PWM_F:
		i = blconf->pwm_port;
		lcd_cbus_write(pwm_reg[i], (high << 16) | (low << 0));
		break;
	case BL_PWM_VS:
		lcd_vcbus_write(VPU_VPU_PWM_V0, (ve[0] << 16) | (vs[0]));
		lcd_vcbus_write(VPU_VPU_PWM_V1, (ve[1] << 16) | (vs[1]));
		lcd_vcbus_write(VPU_VPU_PWM_V2, (ve[2] << 16) | (vs[2]));
		lcd_vcbus_write(VPU_VPU_PWM_V3, (ve[3] << 16) | (vs[3]));
	default:
		break;
	}
}

static void set_lcd_backlight_level(unsigned int level)
{
	unsigned int pwm_hi = 0, pwm_lo = 0;
	struct bl_config_s *blconf = aml_lcd_driver.bl_config;

	if (lcd_backlight_check_valid())
		return;

	LCDPR("bl: set level: %u, last level: %u\n", level, blconf->level);
	level = (level > blconf->level_max ? blconf->level_max :
			(level < blconf->level_min ? blconf->level_min : level));
	blconf->level = level;

	/* mapping */
	if (level > blconf->level_mid) {
		level = ((level - blconf->level_mid) * (blconf->level_max - blconf->level_mid_mapping)) /
			(blconf->level_max - blconf->level_mid) + blconf->level_mid_mapping;
	} else {
		level = ((level - blconf->level_min) * (blconf->level_mid_mapping - blconf->level_min)) /
			(blconf->level_mid - blconf->level_min) + blconf->level_min;
	}

	switch (blconf->method) {
	case BL_CTRL_GPIO:
		/* to do */
		break;
	case BL_CTRL_PWM:
		level = (blconf->pwm_max - blconf->pwm_min) * (level - blconf->level_min) /
				(blconf->level_max - blconf->level_min) + blconf->pwm_min;
		pwm_hi = level;
		pwm_lo = blconf->pwm_cnt - level;
		lcd_bakclight_pwm_duty(pwm_hi, pwm_lo);
		break;
	case BL_CTRL_PWM_COMBO:
		/* to do */
		break;
	case BL_CTRL_LOCAL_DIMING:
		/* to do */
		break;
	case BL_CTRL_EXTERN:
		/* to do */
		break;
	default:
		break;
	}
}

static unsigned int get_lcd_backlight_level(void)
{
	if (lcd_backlight_check_valid())
		return 0;

	LCDPR("bl: get level: %d\n", aml_lcd_driver.bl_config->level);
	return aml_lcd_driver.bl_config->level;
}

static void lcd_backlight_pwm_ctrl(int status)
{
	int i;
	struct bl_config_s *blconf = aml_lcd_driver.bl_config;

	if (blconf->pwm_port >= BL_PWM_MAX)
		return;
	if (status) {
		switch (blconf->pwm_port) {
		case BL_PWM_A:
		case BL_PWM_B:
		case BL_PWM_C:
		case BL_PWM_D:
		case BL_PWM_E:
		case BL_PWM_F:
			i = blconf->pwm_port;
			lcd_cbus_setb(pwm_misc[i][0], blconf->pwm_pre_div,
				pwm_misc[i][1], 7);
			lcd_cbus_setb(pwm_misc[i][0], 0,
				pwm_misc[i][2], 2);
			lcd_cbus_setb(pwm_misc[i][0], 1,
				pwm_misc[i][3], 1);
			lcd_cbus_setb(pwm_misc[i][0], 1,
				pwm_misc[i][4], 1);
			break;
		default:
			break;
		}
		/* set pin mux */
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (blconf->pinmux_clr[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_clr_mask(blconf->pinmux_clr[i][0],
				blconf->pinmux_clr[i][1]);
			i++;
		}
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (blconf->pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_set_mask(blconf->pinmux_set[i][0],
				blconf->pinmux_set[i][1]);
			i++;
		}
	} else {
		i = 0;
		while (i < LCD_PINMUX_NUM) {
			if (blconf->pinmux_set[i][0] == LCD_PINMUX_END)
				break;
			lcd_pinmux_clr_mask(blconf->pinmux_set[i][0],
				blconf->pinmux_set[i][1]);
			i++;
		}
		aml_lcd_gpio_set(blconf->pwm_gpio, blconf->pwm_gpio_off);
	}
}

static void lcd_backlight_power_ctrl(int status)
{
	int gpio, value;
	int power_delay, pwm_delay, bl_delay;
	struct bl_config_s *blconf = aml_lcd_driver.bl_config;

	if (lcd_backlight_check_valid())
		return;

	gpio = blconf->gpio;
	value = status ? blconf->gpio_on : blconf->gpio_off;
	if (lcd_debug_print_flag)
		LCDPR("bl: status=%d gpio=%d value=%d\n", status, gpio, value);

	if (status) {
		switch (blconf->method) {
		case BL_CTRL_GPIO:
			mdelay(blconf->power_on_delay);
			if (gpio < LCD_GPIO_MAX)
				aml_lcd_gpio_set(gpio, value);
			break;
		case BL_CTRL_PWM:
			power_delay = blconf->power_on_delay;
			pwm_delay = blconf->pwm_on_delay;
			if (power_delay >= pwm_delay) {
				bl_delay = power_delay - pwm_delay;
				mdelay(pwm_delay);
				lcd_backlight_pwm_ctrl(1);
				if (gpio < LCD_GPIO_MAX) {
					mdelay(bl_delay);
					aml_lcd_gpio_set(gpio, value);
				}
			} else {
				bl_delay = pwm_delay - power_delay;
				mdelay(power_delay);
				if (gpio < LCD_GPIO_MAX)
					aml_lcd_gpio_set(gpio, value);
				mdelay(bl_delay);
				lcd_backlight_pwm_ctrl(1);
			}
			break;
		case BL_CTRL_PWM_COMBO:
			/* to do */
			break;
		case BL_CTRL_LOCAL_DIMING:
			/* to do */
			break;
		case BL_CTRL_EXTERN:
			/* to do */
			break;
		default:
			break;
		}
	} else {
		switch (blconf->method) {
		case BL_CTRL_GPIO:
			aml_lcd_gpio_set(gpio, value);
			mdelay(blconf->power_off_delay);
			break;
		case BL_CTRL_PWM:
			power_delay = blconf->power_off_delay;
			pwm_delay = blconf->pwm_off_delay;
			if (power_delay >= pwm_delay) {
				bl_delay = power_delay - pwm_delay;
				if (gpio < LCD_GPIO_MAX) {
					aml_lcd_gpio_set(gpio, value);
					mdelay(bl_delay);
				}
				lcd_backlight_pwm_ctrl(0);
				mdelay(pwm_delay);
			} else {
				bl_delay = pwm_delay - power_delay;
				lcd_backlight_pwm_ctrl(0);
				mdelay(bl_delay);
				if (gpio < LCD_GPIO_MAX)
					aml_lcd_gpio_set(gpio, value);
				mdelay(power_delay);
			}
			break;
		case BL_CTRL_PWM_COMBO:
			/* to do */
			break;
		case BL_CTRL_LOCAL_DIMING:
			/* to do */
			break;
		case BL_CTRL_EXTERN:
			/* to do */
			break;
		default:
			break;
		}
	}
	LCDPR("bl: %s: %d\n", __func__, status);
}

static void lcd_power_ctrl(int status)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_power_ctrl_s *lcd_power;
	struct lcd_power_step_s *power_step;
#ifdef CONFIG_AML_LCD_EXTERN
	struct aml_lcd_extern_driver_s *ext_drv;
	int index;
#endif
	char *str;
	int i, gpio;

	i = 0;
	lcd_power = lcd_drv->lcd_config->lcd_power;
	while (i < LCD_PWR_STEP_MAX) {
		if (status)
			power_step = &lcd_power->power_on_step[i];
		else
			power_step = &lcd_power->power_off_step[i];

		if (power_step->type >= LCD_POWER_TYPE_MAX)
			break;
		if (lcd_debug_print_flag) {
			LCDPR("power_ctrl: %d, step %d: type=%d, index=%d, value=%d, delay=%d\n",
				status, i, power_step->type, power_step->index,
				power_step->value, power_step->delay);
		}
		switch (power_step->type) {
		case LCD_POWER_TYPE_CPU:
			if (power_step->index < LCD_CPU_GPIO_NUM_MAX) {
				str = lcd_power->cpu_gpio[power_step->index];
				gpio = aml_lcd_gpio_name_map_num(str);
				aml_lcd_gpio_set(gpio, power_step->value);
			} else {
				LCDERR("cpu_gpio index: %d\n", power_step->index);
			}
			break;
		case LCD_POWER_TYPE_PMU:
			if (power_step->index < LCD_PMU_GPIO_NUM_MAX)
				LCDPR("to do\n");
			else
				LCDERR("pmu_gpio index: %d\n", power_step->index);
			break;
		case LCD_POWER_TYPE_SIGNAL:
			if (status)
				lcd_drv->driver_init();
			else
				lcd_drv->driver_disable();
			break;
#ifdef CONFIG_AML_LCD_EXTERN
		case LCD_POWER_TYPE_EXTERN:
			ext_drv = aml_lcd_extern_get_driver();
			if (status)
				ext_drv->power_on();
			else
				ext_drv->power_off();
			break;
#endif
		default:
			break;
		}
		if (power_step->delay)
			mdelay(power_step->delay);
		i++;
	}

	if (lcd_debug_print_flag)
		LCDPR("%s: %d\n", __func__, status);
}

static void lcd_module_enable(char *mode)
{
	unsigned int sync_duration;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_config_s *pconf = lcd_drv->lcd_config;
	int ret;

	LCDPR("driver version: %s\n", lcd_drv->version);

	ret = lcd_drv->config_check(mode);
	if (ret) {
		LCDERR("init exit\n");
		return;
	}

	sync_duration = pconf->lcd_timing.sync_duration_num;
	sync_duration = (sync_duration * 10 / pconf->lcd_timing.sync_duration_den);
	LCDPR("enable: %s, %s, %ux%u@%u.%uHz\n", pconf->lcd_basic.model_name,
		lcd_type_type_to_str(pconf->lcd_basic.lcd_type),
		pconf->lcd_basic.h_active, pconf->lcd_basic.v_active,
		(sync_duration / 10), (sync_duration % 10));

	lcd_power_ctrl(1);
	lcd_vcbus_write(VPP_POSTBLEND_H_SIZE, pconf->lcd_basic.h_active);
	lcd_vcbus_write(VENC_INTCTRL, 0x200);

	set_lcd_backlight_level(lcd_drv->bl_config->level_default);
	lcd_backlight_power_ctrl(1);

	lcd_drv->lcd_status = 1;
}

static void lcd_module_disable(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	LCDPR("disable: %s\n", lcd_drv->lcd_config->lcd_basic.model_name);

	lcd_backlight_power_ctrl(0);

	lcd_power_ctrl(0);

	lcd_drv->lcd_status = 0;
}

static void lcd_timing_info_print(struct lcd_config_s * pconf)
{
	unsigned int hs_width, hs_bp, hs_pol, h_period;
	unsigned int vs_width, vs_bp, vs_pol, v_period;
	unsigned int video_on_pixel, video_on_line;

	video_on_pixel = pconf->lcd_timing.video_on_pixel;
	video_on_line = pconf->lcd_timing.video_on_line;
	h_period = pconf->lcd_basic.h_period;
	v_period = pconf->lcd_basic.v_period;

	hs_width = pconf->lcd_timing.hsync_width;
	hs_bp = pconf->lcd_timing.hsync_bp;
	hs_pol = pconf->lcd_timing.hsync_pol;
	vs_width = pconf->lcd_timing.vsync_width;
	vs_bp = pconf->lcd_timing.vsync_bp;
	vs_pol = pconf->lcd_timing.vsync_pol;

	printf("h_period          %d\n"
	   "v_period          %d\n"
	   "hs_width          %d\n"
	   "hs_backporch      %d\n"
	   "hs_pol            %d\n"
	   "vs_width          %d\n"
	   "vs_backporch      %d\n"
	   "vs_pol            %d\n"
	   "video_on_pixel    %d\n"
	   "video_on_line     %d\n\n",
	   h_period, v_period, hs_width, hs_bp, hs_pol,
	   vs_width, vs_bp, vs_pol, video_on_pixel, video_on_line);
}

static void lcd_power_info_print(struct lcd_config_s *pconf, int status)
{
	int i;
	struct lcd_power_step_s *power_step;

	if (status)
		printf("power on step:\n");
	else
		printf("power off step:\n");

	i = 0;
	while (i < LCD_PWR_STEP_MAX) {
		if (status)
			power_step = &pconf->lcd_power->power_on_step[i];
		else
			power_step = &pconf->lcd_power->power_off_step[i];

		if (power_step->type >= LCD_POWER_TYPE_MAX)
			break;
		switch (power_step->type) {
		case LCD_POWER_TYPE_CPU:
		case LCD_POWER_TYPE_PMU:
			printf("%d: type=%d, index=%d, value=%d, delay=%d\n",
				i, power_step->type, power_step->index,
				power_step->value, power_step->delay);
			break;
		case LCD_POWER_TYPE_EXTERN:
			printf("%d: type=%d, index=%d, delay=%d\n",
				i, power_step->type, power_step->index,
				power_step->delay);
			break;
		case LCD_POWER_TYPE_SIGNAL:
			printf("%d: type=%d, delay=%d\n",
				i, power_step->type, power_step->delay);
			break;
		default:
			break;
		}
		i++;
	}
}

static void print_lcd_info(void)
{
	unsigned int lcd_clk;
	unsigned int sync_duration;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_config_s *pconf = lcd_drv->lcd_config;

	LCDPR("driver version: %s\n", lcd_drv->version);
	LCDPR("status: %d\n", lcd_drv->lcd_status);
	LCDPR("mode  : %s\n", lcd_mode_mode_to_str(aml_lcd_driver.lcd_config->lcd_mode));

	lcd_clk = (pconf->lcd_timing.lcd_clk / 1000);
	sync_duration = pconf->lcd_timing.sync_duration_num;
	sync_duration = (sync_duration * 10 / pconf->lcd_timing.sync_duration_den);
	LCDPR("%s, %s, %ux%u@%u.%uHz\n"
		"fr_adj_type       %d\n"
		"lcd_clk           %u.%03uMHz\n\n",
		pconf->lcd_basic.model_name,
		lcd_type_type_to_str(pconf->lcd_basic.lcd_type),
		pconf->lcd_basic.h_active, pconf->lcd_basic.v_active,
		(sync_duration / 10), (sync_duration % 10),
		pconf->lcd_timing.fr_adjust_type,
		(lcd_clk / 1000), (lcd_clk % 1000));

	lcd_timing_info_print(pconf);

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_LVDS:
		printf("lvds_repack       %u\n"
		   "dual_port         %u\n"
		   "pn_swap           %u\n"
		   "port_swap         %u\n\n",
		   pconf->lcd_control.lvds_config->lvds_repack,
		   pconf->lcd_control.lvds_config->dual_port,
		   pconf->lcd_control.lvds_config->pn_swap,
		   pconf->lcd_control.lvds_config->port_swap);
		break;
	case LCD_VBYONE:
		printf("lane_count        %u\n"
		   "region_num        %u\n"
		   "byte_mode         %u\n\n",
		   pconf->lcd_control.vbyone_config->lane_count,
		   pconf->lcd_control.vbyone_config->region_num,
		   pconf->lcd_control.vbyone_config->byte_mode);
		break;
	default:
		break;
	}

	lcd_power_info_print(pconf, 1);
	lcd_power_info_print(pconf, 0);
}

#ifdef CONFIG_OF_LIBFDT
static char *bl_pwm_pinmux_name[] = {
	"bl_pwm_pin",
	"bl_pwm_vs_pin",
	"bl_pwm_combo_pin",
};

static int bl_config_load_from_dts(char *dt_addr, unsigned int index, struct bl_config_s *blconf)
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

	parent_offset = fdt_path_offset(dt_addr, "/backlight");
	if (parent_offset < 0) {
		LCDERR("bl: not find /backlight node %s\n", fdt_strerror(parent_offset));
		return 0;
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
			strcpy(blconf->gpio_name[i], str);
			if (lcd_debug_print_flag)
				LCDPR("bl: i=%d, gpio=%s\n", i, blconf->gpio_name[i]);
			i++;
		}
	}
	for (j = i; j < BL_GPIO_NUM_MAX; j++) {
		strcpy(blconf->gpio_name[j], "invalid");
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
		sprintf(blconf->name, "backlight_%d", index);
	} else {
		strcpy(blconf->name, propdata);
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_level_default_uboot_kernel", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_level_default_uboot_kernel\n");
		blconf->level_default = BL_LEVEL_DEFAULT;
	} else {
		blconf->level_default = be32_to_cpup((u32*)propdata);
	}
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_level_max_min", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_level_max_min\n");
		blconf->level_max = BL_LEVEL_MAX;
		blconf->level_min = BL_LEVEL_MIN;
	} else {
		blconf->level_max = be32_to_cpup((u32*)propdata);
		blconf->level_min = be32_to_cpup((((u32*)propdata)+1));
	}
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_level_middle_mapping", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_level_middle_mapping\n");
		blconf->level_mid = BL_LEVEL_MID;
		blconf->level_mid_mapping = BL_LEVEL_MID_MAPPED;
	} else {
		blconf->level_mid = be32_to_cpup((u32*)propdata);
		blconf->level_mid_mapping = be32_to_cpup((((u32*)propdata)+1));
	}

	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_ctrl_method", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_ctrl_method\n");
		blconf->method = BL_CTRL_MAX;
		return 0;
	} else {
		blconf->method = be32_to_cpup((u32*)propdata);
	}
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_en_gpio_on_off", NULL);
	if (propdata == NULL) {
		LCDERR("bl: failed to get bl_en_gpio_on_off\n");
		blconf->gpio = LCD_GPIO_MAX;
		blconf->gpio_on = LCD_GPIO_OUTPUT_HIGH;
		blconf->gpio_off = LCD_GPIO_OUTPUT_LOW;
	} else {
		temp = be32_to_cpup((u32*)propdata);
		if (temp >= BL_GPIO_NUM_MAX) {
			blconf->gpio = LCD_GPIO_MAX;
		} else {
			str = blconf->gpio_name[temp];
			blconf->gpio = aml_lcd_gpio_name_map_num(str);
		}
		blconf->gpio_on = be32_to_cpup((((u32*)propdata)+1));
		blconf->gpio_off = be32_to_cpup((((u32*)propdata)+2));
	}
	if (lcd_debug_print_flag)
		LCDPR("bl: bl_en gpio=%d, on=%d, off=%d\n", blconf->gpio, blconf->gpio_on, blconf->gpio_off);
	propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_power_on_off_delay", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get bl_power_on_off_delay\n");
		blconf->power_on_delay = 100;
		blconf->power_off_delay = 30;
	} else {
		blconf->power_on_delay = be32_to_cpup((u32*)propdata);
		blconf->power_off_delay = be32_to_cpup((((u32*)propdata)+1));
	}
	if (lcd_debug_print_flag)
		LCDPR("bl: bl_power_delay on=%d, off=%d\n", blconf->power_on_delay, blconf->power_off_delay);

	switch (blconf->method) {
	case BL_CTRL_PWM:
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_method", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_method\n");
			blconf->pwm_method = BL_PWM_POSITIVE;
		} else {
			blconf->pwm_method = be32_to_cpup((u32*)propdata);
		}
		if (lcd_debug_print_flag)
			LCDPR("bl: bl_pwm method=%d\n", blconf->pwm_method);
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_port", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_port\n");
			blconf->pwm_port = BL_PWM_MAX;
		} else {
			blconf->pwm_port = lcd_backlight_get_pwm_port(propdata);
		}
		if (lcd_debug_print_flag)
			LCDPR("bl: bl_pwm port=%d\n", blconf->pwm_port);
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_freq", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get bl_pwm_freq\n");
			if (blconf->pwm_port == BL_PWM_VS)
				blconf->pwm_freq = BL_FREQ_VS_DEFAULT;
			else
				blconf->pwm_freq = BL_FREQ_DEFAULT;
		} else {
			blconf->pwm_freq = be32_to_cpup((u32*)propdata);
		}
		if (blconf->pwm_port == BL_PWM_VS) {
			if (blconf->pwm_freq > 4) {
				LCDERR("bl: bl_pwm_vs wrong freq %d\n", blconf->pwm_freq);
				blconf->pwm_freq = BL_FREQ_VS_DEFAULT;
			}
			if (lcd_debug_print_flag)
				LCDPR("bl: bl_pwm freq=%d x Vfreq\n", blconf->pwm_freq);
		} else {
			if (blconf->pwm_freq > XTAL_HALF_FREQ_HZ)
				blconf->pwm_freq = XTAL_HALF_FREQ_HZ;
			if (lcd_debug_print_flag)
				LCDPR("bl_pwm freq=%dHz\n", blconf->pwm_freq);
		}
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_duty_max_min", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_duty_max_min\n");
			blconf->pwm_duty_max = 80;
			blconf->pwm_duty_min = 20;
		} else {
			blconf->pwm_duty_max = be32_to_cpup((u32*)propdata);
			blconf->pwm_duty_min = be32_to_cpup((((u32*)propdata)+1));
		}
		if (lcd_debug_print_flag)
			LCDPR("bl: bl_pwm_duty max=%d%%, min=%d%%\n", blconf->pwm_duty_max, blconf->pwm_duty_min);
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_gpio_off", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_gpio_off\n");
			blconf->pwm_gpio = LCD_GPIO_MAX;
			blconf->pwm_gpio_off = LCD_GPIO_OUTPUT_LOW;
		} else {
			temp = be32_to_cpup((u32*)propdata);
			if (temp >= BL_GPIO_NUM_MAX) {
				blconf->pwm_gpio = LCD_GPIO_MAX;
			} else {
				str = blconf->gpio_name[temp];
				blconf->pwm_gpio = aml_lcd_gpio_name_map_num(str);
			}
			blconf->pwm_gpio_off = be32_to_cpup((((u32*)propdata)+1));
		}
		if (lcd_debug_print_flag)
			LCDPR("bl: bl_pwm gpio=%d, gpio_off=%d\n", blconf->pwm_gpio, blconf->pwm_gpio_off);
		propdata = (char *)fdt_getprop(dt_addr, child_offset, "bl_pwm_on_off_delay", NULL);
		if (propdata == NULL) {
			LCDERR("bl: failed to get bl_pwm_on_off_delay\n");
			blconf->pwm_on_delay = 100;
			blconf->pwm_off_delay = 30;
		} else {
			blconf->pwm_on_delay = be32_to_cpup((u32*)propdata);
			blconf->pwm_off_delay = be32_to_cpup((((u32*)propdata)+1));
		}
		if (lcd_debug_print_flag)
			LCDPR("bl: bl_pwm_delay on=%d, off=%d\n", blconf->pwm_on_delay, blconf->pwm_off_delay);

		lcd_backlight_pwm_config(blconf);
		if (blconf->pwm_port == BL_PWM_VS)
			sprintf(propname,"/pinmux/%s", bl_pwm_pinmux_name[1]);
		else
			sprintf(propname,"/pinmux/%s", bl_pwm_pinmux_name[0]);
		break;
	case BL_CTRL_PWM_COMBO:
		sprintf(propname,"/pinmux/%s", bl_pwm_pinmux_name[2]);
		break;
	default:
		return 0;
		break;
	}

	switch (blconf->method) {
	case BL_CTRL_PWM:
	case BL_CTRL_PWM_COMBO:
		parent_offset = fdt_path_offset(dt_addr, propname);
		if (parent_offset < 0) {
			LCDERR("bl: not find %s node\n", propname);
			blconf->pinmux_set[0][0] = LCD_PINMUX_END;
			blconf->pinmux_set[0][1] = 0x0;
			blconf->pinmux_clr[0][0] = LCD_PINMUX_END;
			blconf->pinmux_clr[0][1] = 0x0;
			return 0;
		} else {
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,setmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,setmask\n");
				blconf->pinmux_set[0][0] = LCD_PINMUX_END;
				blconf->pinmux_set[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					blconf->pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					blconf->pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					blconf->pinmux_set[temp][0] = LCD_PINMUX_END;
					blconf->pinmux_set[temp][1] = 0x0;
				}
			}
			propdata = (char *)fdt_getprop(dt_addr, parent_offset, "amlogic,clrmask", &len);
			if (propdata == NULL) {
				LCDERR("bl: failed to get amlogic,clrmask\n");
				blconf->pinmux_clr[0][0] = LCD_PINMUX_END;
				blconf->pinmux_clr[0][1] = 0x0;
			} else {
				temp = len / 8;
				for (i = 0; i < temp; i++) {
					blconf->pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
					blconf->pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
				}
				if (temp < (LCD_PINMUX_NUM - 1)) {
					blconf->pinmux_clr[temp][0] = LCD_PINMUX_END;
					blconf->pinmux_clr[temp][1] = 0x0;
				}
			}
			if (lcd_debug_print_flag) {
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (blconf->pinmux_set[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: bl_pinmux set: %d, 0x%08x\n", blconf->pinmux_set[i][0], blconf->pinmux_set[i][1]);
					i++;
				}
				i = 0;
				while (i < LCD_PINMUX_NUM) {
					if (blconf->pinmux_clr[i][0] == LCD_PINMUX_END)
						break;
					LCDPR("bl: bl_pinmux clr: %d, 0x%08x\n", blconf->pinmux_clr[i][0], blconf->pinmux_clr[i][1]);
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

static int bl_config_load_from_bsp(struct bl_config_s *blconf)
{
	struct ext_lcd_config_s *ext_lcd = NULL;
	char *panel_type = getenv("panel_type");
	unsigned int i = 0;
	char *str;

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

	strcpy(blconf->name, panel_type);
	blconf->level_default     = ext_lcd->level_default;
	blconf->level_min         = ext_lcd->level_min;
	blconf->level_max         = ext_lcd->level_max;
	blconf->level_mid         = ext_lcd->level_mid;
	blconf->level_mid_mapping = ext_lcd->level_mid_mapping;

	blconf->method          = ext_lcd->bl_method;
	if (ext_lcd->bl_gpio >= BL_GPIO_NUM_MAX) {
		blconf->gpio    = LCD_GPIO_MAX;
	} else {
		str = blconf->gpio_name[ext_lcd->bl_gpio];
		blconf->gpio    = aml_lcd_gpio_name_map_num(str);
	}
	blconf->gpio_on         = ext_lcd->bl_on_value;
	blconf->gpio_off        = ext_lcd->bl_off_value;
	blconf->power_on_delay  = ext_lcd->bl_on_delay;
	blconf->power_off_delay = ext_lcd->bl_off_delay;

	blconf->pwm_method    = ext_lcd->pwm_method;
	blconf->pwm_port      = ext_lcd->pwm_port;
	blconf->pwm_freq      = ext_lcd->pwm_freq;
	blconf->pwm_duty_max  = ext_lcd->pwm_duty_max;
	blconf->pwm_duty_min  = ext_lcd->pwm_duty_min;
	if (ext_lcd->pwm_gpio >= BL_GPIO_NUM_MAX) {
		blconf->pwm_gpio = LCD_GPIO_MAX;
	} else {
		str = blconf->gpio_name[ext_lcd->pwm_gpio];
		blconf->pwm_gpio = aml_lcd_gpio_name_map_num(str);
	}
	blconf->pwm_gpio_off  = ext_lcd->pwm_gpio_off;
	blconf->pwm_on_delay  = ext_lcd->pwm_on_delay;
	blconf->pwm_off_delay = ext_lcd->pwm_off_delay;

	if (lcd_debug_print_flag) {
		LCDPR("bl: level_default = %d\n", blconf->level_default);
		LCDPR("bl: level_min = %d\n", blconf->level_min);
		LCDPR("bl: level_max = %d\n", blconf->level_max);
		LCDPR("bl: level_mid = %d\n", blconf->level_mid);
		LCDPR("bl: level_mid_mapping = %d\n", blconf->level_mid_mapping);

		LCDPR("bl: method = %d\n", blconf->method);
		LCDPR("bl: gpio = %d\n", blconf->gpio);
		LCDPR("bl: gpio_on = %d\n", blconf->gpio_on);
		LCDPR("bl: gpio_off = %d\n", blconf->gpio_off);
		LCDPR("bl: power_on_delay = %d\n", blconf->power_on_delay);
		LCDPR("bl: power_off_delay = %d\n", blconf->power_off_delay);

		LCDPR("bl: pwm_method = %d\n", blconf->pwm_method);
		LCDPR("bl: pwm_port = %d\n", blconf->pwm_port);
		LCDPR("bl: pwm_freq = %d\n", blconf->pwm_freq);
		LCDPR("bl: pwm_duty_max = %d\n", blconf->pwm_duty_max);
		LCDPR("bl: pwm_duty_min = %d\n", blconf->pwm_duty_min);
		LCDPR("bl: pwm_gpio = %d\n", blconf->pwm_gpio);
		LCDPR("bl: pwm_gpio_off = %d\n", blconf->pwm_gpio_off);
		LCDPR("bl: pwm_on_delay = %d\n", blconf->pwm_on_delay);
		LCDPR("bl: pwm_off_delay = %d\n", blconf->pwm_off_delay);
	}

	return 0;
}

static int lcd_mode_probe(void)
{
	int load_id = 0;
	unsigned int lcd_debug_test = 0;
	char *dt_addr;
#ifdef CONFIG_OF_LIBFDT
	int parent_offset;
	char *propdata;
	unsigned int index;
#endif

	dt_addr = NULL;
#ifdef CONFIG_OF_LIBFDT
#ifdef CONFIG_DTB_MEM_ADDR
	dt_addr = (char *)CONFIG_DTB_MEM_ADDR;
#else
	dt_addr = (char *)0x01000000;
#endif
	if (fdt_check_header(dt_addr) < 0) {
		LCDERR("check dts: %s, load default lcd parameters\n",
			fdt_strerror(fdt_check_header(dt_addr)));
	} else {
		load_id = 1;
	}
#endif

	lcd_debug_test = simple_strtoul(getenv("lcd_debug_test"), NULL, 10);
	if (lcd_debug_test)
		load_id = 0;

	if (load_id == 1 ) {
#ifdef CONFIG_OF_LIBFDT
		LCDPR("load config from dts\n");
		parent_offset = fdt_path_offset(dt_addr, "/lcd");
		if (parent_offset < 0) {
			LCDERR("not find /lcd node: %s\n",fdt_strerror(parent_offset));
			return -1;
		}

		/* check lcd_mode */
		propdata = (char *)fdt_getprop(dt_addr, parent_offset, "mode", NULL);
		if (propdata == NULL) {
			LCDERR("failed to get mode\n");
			return -1;
		} else {
			aml_lcd_driver.lcd_config->lcd_mode = lcd_mode_str_to_mode(propdata);
		}
		LCDPR("detect mode: %s\n", propdata);
#endif
	} else {
		LCDPR("load config from lcd.c\n");
		LCDPR("detect mode: %s\n", lcd_mode_mode_to_str(aml_lcd_driver.lcd_config->lcd_mode));
	}

	/* load lcd config */
	switch (aml_lcd_driver.lcd_config->lcd_mode) {
#ifdef CONFIG_AML_LCD_TV
	case LCD_MODE_TV:
		get_lcd_tv_config(dt_addr, load_id);
		break;
#endif
#ifdef CONFIG_AML_LCD_TABLET
	case LCD_MODE_TABLET:
		get_lcd_tablet_config(dt_addr, load_id);
		break;
#endif
	default:
		LCDPR("invalid lcd mode\n");
		break;
	}

	/* load bl config */
	if (load_id == 1 ) {
#ifdef CONFIG_OF_LIBFDT
	index = aml_lcd_driver.lcd_config->backlight_index;
	bl_config_load_from_dts(dt_addr, index, aml_lcd_driver.bl_config);
#endif
	} else {
		bl_config_load_from_bsp(aml_lcd_driver.bl_config);
	}

	return 0;
}

int lcd_probe(void)
{
#ifdef LCD_DEBUG_INFO
	lcd_debug_print_flag = 1;
#else
	lcd_debug_print_flag = 0;
	lcd_debug_print_flag = simple_strtoul(getenv("lcd_debug_print"), NULL, 10);
#endif

	lcd_chip_detect();
	lcd_clk_config_probe();
	lcd_mode_probe();

	return 0;
}

int lcd_remove(void)
{
// #ifdef CONFIG_AML_LCD_EXTERN
	// aml_lcd_extern_remove();
// #endif

	return 0;
}

/* ********************************************** *
  lcd driver API
 * ********************************************** */
static void lcd_enable(char *mode)
{
	if (lcd_check_valid())
		return;
	if (aml_lcd_driver.lcd_status)
		LCDPR("already enabled\n");
	else
		lcd_module_enable(mode);
}

static void lcd_disable(void)
{
	if (lcd_check_valid())
		return;
	if (aml_lcd_driver.lcd_status)
		lcd_module_disable();
	else
		LCDPR("already disabled\n");
}

#define TV_LCD_ENC_TST_NUM_MAX    8
static char *lcd_enc_tst_str[] = {
	"0-None",        /* 0 */
	"1-Color Bar",   /* 1 */
	"2-Thin Line",   /* 2 */
	"3-Dot Grid",    /* 3 */
	"4-Gray",        /* 4 */
	"5-Blue",         /* 5 */
	"6-Red",       /* 6 */
	"7-Green",        /* 7 */
};

static unsigned int lcd_enc_tst[][7] = {
/*tst_mode,    Y,       Cb,     Cr,     tst_en,  vfifo_en  rgbin*/
	{0,    0x200,   0x200,  0x200,   0,      1,        3},  /* 0 */
	{1,    0x200,   0x200,  0x200,   1,      0,        1},  /* 1 */
	{2,    0x200,   0x200,  0x200,   1,      0,        1},  /* 2 */
	{3,    0x200,   0x200,  0x200,   1,      0,        1},  /* 3 */
	{0,    0x200,   0x200,  0x200,   1,      0,        1},  /* 4 */
	{0,    0x130,   0x153,  0x3fd,   1,      0,        1},  /* 5 */
	{0,    0x256,   0x0ae,  0x055,   1,      0,        1},  /* 6 */
	{0,    0x074,   0x3fd,  0x1ad,   1,      0,        1},  /* 7 */
};

static void lcd_test(unsigned int num)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	unsigned int start, width;

	start = lcd_drv->lcd_config->lcd_timing.video_on_pixel;
	width = lcd_drv->lcd_config->lcd_basic.h_active / 9;
	num = (num >= TV_LCD_ENC_TST_NUM_MAX) ? 0 : num;
	if (num >= 0) {
		lcd_vcbus_write(ENCL_VIDEO_RGBIN_CTRL, lcd_enc_tst[num][6]);
		lcd_vcbus_write(ENCL_TST_MDSEL, lcd_enc_tst[num][0]);
		lcd_vcbus_write(ENCL_TST_Y, lcd_enc_tst[num][1]);
		lcd_vcbus_write(ENCL_TST_CB, lcd_enc_tst[num][2]);
		lcd_vcbus_write(ENCL_TST_CR, lcd_enc_tst[num][3]);
		lcd_vcbus_write(ENCL_TST_CLRBAR_STRT, start);
		lcd_vcbus_write(ENCL_TST_CLRBAR_WIDTH, width);
		lcd_vcbus_write(ENCL_TST_EN, lcd_enc_tst[num][4]);
		lcd_vcbus_setb(ENCL_VIDEO_MODE_ADV, lcd_enc_tst[num][5], 3, 1);
		printf("lcd: show test pattern: %s\n", lcd_enc_tst_str[num]);
	} else {
		printf("lcd: disable test pattern\n");
	}
}

static void aml_lcd_test(int num)
{
	if (lcd_check_valid())
		return;
	if (aml_lcd_driver.lcd_status)
		lcd_test(num);
	else
		LCDPR("already disabled\n");
}

static void aml_lcd_info(void)
{
	if (lcd_check_valid())
		return;
	print_lcd_info();
}

static void aml_set_backlight_level(int level)
{
	set_lcd_backlight_level(level);
}

static int aml_get_backlight_level(void)
{
	return get_lcd_backlight_level();
}

static void aml_backlight_power_on(void)
{
	lcd_backlight_power_ctrl(1);
}

static void aml_backlight_power_off(void)
{
	lcd_backlight_power_ctrl(0);
}

static struct aml_lcd_drv_s aml_lcd_driver = {
	.lcd_status = 0,
	.lcd_config = &lcd_config_dft,
	.bl_config = &bl_config_dft,
	.config_check = NULL,
	.lcd_probe = lcd_probe,
	.lcd_enable = lcd_enable,
	.lcd_disable = lcd_disable,
	.lcd_test = aml_lcd_test,
	.lcd_info = aml_lcd_info,
	.bl_on = aml_backlight_power_on,
	.bl_off = aml_backlight_power_off,
	.set_bl_level = aml_set_backlight_level,
	.get_bl_level = aml_get_backlight_level,
};

struct aml_lcd_drv_s *aml_lcd_get_driver(void)
{
	return &aml_lcd_driver;
}
