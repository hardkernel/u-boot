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
#include <asm/cpu_id.h>
#include <asm/arch/gpio.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#include <amlogic/keyunify.h>
#include <amlogic/aml_lcd.h>
#ifdef CONFIG_AML_LCD_EXTERN
#include <amlogic/aml_lcd_extern.h>
#endif
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"
#include "aml_lcd_clk_config.h"
#ifdef CONFIG_AML_LCD_TABLET
#include "lcd_tablet/mipi_dsi_util.h"
#endif

#define PANEL_NAME	"panel"

unsigned int lcd_debug_print_flag;
unsigned int lcd_debug_test;
static struct aml_lcd_drv_s aml_lcd_driver;

static void lcd_chip_detect(void)
{
#if 1
	unsigned int cpu_type;

	cpu_type = get_cpu_id().family_id;
	switch (cpu_type) {
	case MESON_CPU_MAJOR_ID_GXTVBB:
		aml_lcd_driver.chip_type = LCD_CHIP_GXTVBB;
		break;
	case MESON_CPU_MAJOR_ID_GXL:
		aml_lcd_driver.chip_type = LCD_CHIP_GXL;
		break;
	case MESON_CPU_MAJOR_ID_GXM:
		aml_lcd_driver.chip_type = LCD_CHIP_GXM;
		break;
	case MESON_CPU_MAJOR_ID_TXL:
		aml_lcd_driver.chip_type = LCD_CHIP_TXL;
		break;
	case MESON_CPU_MAJOR_ID_TXLX:
		aml_lcd_driver.chip_type = LCD_CHIP_TXLX;
		break;
	case MESON_CPU_MAJOR_ID_AXG:
		aml_lcd_driver.chip_type = LCD_CHIP_AXG;
		break;
	case MESON_CPU_MAJOR_ID_TXHD:
		aml_lcd_driver.chip_type = LCD_CHIP_TXHD;
		break;
	case MESON_CPU_MAJOR_ID_G12A:
		aml_lcd_driver.chip_type = LCD_CHIP_G12A;
		break;
	case MESON_CPU_MAJOR_ID_G12B:
		aml_lcd_driver.chip_type = LCD_CHIP_G12B;
		break;
	case MESON_CPU_MAJOR_ID_TL1:
		aml_lcd_driver.chip_type = LCD_CHIP_TL1;
		break;
	default:
		aml_lcd_driver.chip_type = LCD_CHIP_MAX;
		//aml_lcd_driver.chip_type = LCD_CHIP_TL1;
		break;
	}
#else
	aml_lcd_driver.chip_type = LCD_CHIP_TL1;
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

static void lcd_power_ctrl(int status)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_power_ctrl_s *lcd_power;
	struct lcd_power_step_s *power_step;
#ifdef CONFIG_AML_LCD_EXTERN
	struct aml_lcd_extern_driver_s *ext_drv;
#endif
	char *str;
	unsigned int i, gpio, value, temp;
	int ret;

	i = 0;
	lcd_power = lcd_drv->lcd_config->lcd_power;
	if (status) {
		/* check if factory test */
		if (lcd_drv->factory_lcd_power_on_step) {
			LCDPR("%s: factory test power_on_step!\n", __func__);
			power_step = lcd_drv->factory_lcd_power_on_step;
		} else {
			power_step = &lcd_power->power_on_step[0];
		}
	} else {
		power_step = &lcd_power->power_off_step[0];
	}

	while (i < LCD_PWR_STEP_MAX) {
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
			if (ext_drv) {
				if (status) {
					if (ext_drv->power_on)
						ext_drv->power_on();
					else
						LCDERR("no ext power on\n");
				} else {
					if (ext_drv->power_off)
						ext_drv->power_off();
					else
						LCDERR("no ext power off\n");
				}
			}
			break;
#endif
		case LCD_POWER_TYPE_WAIT_GPIO:
			break;
		case LCD_POWER_TYPE_CLK_SS:
			temp = lcd_drv->lcd_config->lcd_timing.ss_level;
			value = (power_step->value) & 0xff;
			ret = lcd_set_ss(0xff,
				(value >> LCD_CLK_SS_BIT_FREQ) & 0xf,
				(value >> LCD_CLK_SS_BIT_MODE) & 0xf);
			if (ret == 0) {
				temp &= ~(0xff << 8);
				temp |= (value << 8);
				lcd_drv->lcd_config->lcd_timing.ss_level = temp;
			}
			break;
		default:
			break;
		}
		if (power_step->delay)
			mdelay(power_step->delay);
		i++;
		power_step++;
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

	lcd_drv->driver_init_pre();
	lcd_power_ctrl(1);

	pconf->retry_enable_cnt = 0;
	while (pconf->retry_enable_flag) {
		if (pconf->retry_enable_cnt++ >= LCD_ENABLE_RETRY_MAX)
			break;
		LCDPR("retry enable...%d\n", pconf->retry_enable_cnt);
		lcd_power_ctrl(0);
		mdelay(1000);
		lcd_power_ctrl(1);
	}
	pconf->retry_enable_cnt = 0;

	lcd_vcbus_write(VPP_POSTBLEND_H_SIZE, pconf->lcd_basic.h_active);
	lcd_vcbus_write(VENC_INTCTRL, 0x200);

	aml_bl_pwm_config_update(lcd_drv->bl_config);
	aml_bl_set_level(lcd_drv->bl_config->level_default);
	aml_bl_power_ctrl(1, 1);
	aml_lcd_mute_setting(0);

	lcd_drv->lcd_status = 1;
}

static void lcd_module_disable(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	LCDPR("disable: %s\n", lcd_drv->lcd_config->lcd_basic.model_name);

	aml_lcd_mute_setting(1);
	aml_bl_power_ctrl(0, 1);

	lcd_power_ctrl(0);

	lcd_drv->lcd_status = 0;
}

static void lcd_vbyone_filter_flag_print(struct lcd_config_s *pconf)
{
	struct vbyone_config_s *vx1_conf = pconf->lcd_control.vbyone_config;

	switch (aml_lcd_driver.chip_type) {
	case LCD_CHIP_TXL:
	case LCD_CHIP_TXLX:
		LCDPR("vx1_sw_filter_en: %d\n", vx1_conf->vx1_sw_filter_en);
		LCDPR("vx1_sw_filter_time: %d\n", vx1_conf->vx1_sw_filter_time);
		LCDPR("vx1_sw_filter_cnt: %d\n", vx1_conf->vx1_sw_filter_cnt);
		LCDPR("vx1_sw_filter_retry_cnt: %d\n", vx1_conf->vx1_sw_filter_retry_cnt);
		LCDPR("vx1_sw_filter_retry_delay: %d\n", vx1_conf->vx1_sw_filter_retry_delay);
		LCDPR("vx1_sw_cdr_detect_time: %d\n", vx1_conf->vx1_sw_cdr_detect_time);
		LCDPR("vx1_sw_cdr_detect_cnt: %d\n", vx1_conf->vx1_sw_cdr_detect_cnt);
		LCDPR("vx1_sw_cdr_timeout_cnt: %d\n", vx1_conf->vx1_sw_cdr_timeout_cnt);
		break;
	default:
		break;
	}
}

static void lcd_vbyone_filter_env_init(struct lcd_config_s *pconf)
{
	struct vbyone_config_s *vx1_conf = pconf->lcd_control.vbyone_config;
	char *str;
	unsigned int temp = 0;

	str = getenv("lcd_debug_vx1_sw_filter");
	if (str)
		temp = simple_strtoul(str, NULL, 10);
	if (temp == 0)
		return;

	LCDPR("%s\n", __func__);
	str = getenv("vx1_sw_filter_en");
	if (str) {
		vx1_conf->vx1_sw_filter_en = simple_strtoul(str, NULL, 10);
		LCDPR("vx1_sw_filter_en: %d\n", vx1_conf->vx1_sw_filter_en);
	}

	str = getenv("vx1_sw_filter_time"); /* 100us */
	if (str) {
		vx1_conf->vx1_sw_filter_time = simple_strtoul(str, NULL, 10);
		LCDPR("vx1_sw_filter_time: %d\n", vx1_conf->vx1_sw_filter_time);
	}

	str = getenv("vx1_sw_filter_cnt");
	if (str) {
		vx1_conf->vx1_sw_filter_cnt = simple_strtoul(str, NULL, 10);
		LCDPR("vx1_sw_filter_cnt: %d\n", vx1_conf->vx1_sw_filter_cnt);
	}

	str = getenv("vx1_sw_filter_retry_cnt");
	if (str) {
		vx1_conf->vx1_sw_filter_retry_cnt = simple_strtoul(str, NULL, 10);
		LCDPR("vx1_sw_filter_retry_cnt: %d\n", vx1_conf->vx1_sw_filter_retry_cnt);
	}

	str = getenv("vx1_sw_filter_retry_delay"); /* ms */
	if (str) {
		vx1_conf->vx1_sw_filter_retry_delay = simple_strtoul(str, NULL, 10);
		LCDPR("vx1_sw_filter_retry_delay: %d\n", vx1_conf->vx1_sw_filter_retry_delay);
	}

	str = getenv("vx1_sw_cdr_detect_time"); /* us * 100 */
	if (str) {
		vx1_conf->vx1_sw_cdr_detect_time = simple_strtoul(str, NULL, 10);
		LCDPR("vx1_sw_cdr_detect_time: %d\n", vx1_conf->vx1_sw_cdr_detect_time);
	}

	str = getenv("vx1_sw_cdr_detect_cnt");
	if (str) {
		vx1_conf->vx1_sw_cdr_detect_cnt = simple_strtoul(str, NULL, 10);
		LCDPR("vx1_sw_cdr_detect_cnt: %d\n", vx1_conf->vx1_sw_cdr_detect_cnt);
	}

	str = getenv("vx1_sw_cdr_timeout_cnt");
	if (str) {
		vx1_conf->vx1_sw_cdr_timeout_cnt = simple_strtoul(str, NULL, 10);
		LCDPR("vx1_sw_cdr_timeout_cnt: %d\n", vx1_conf->vx1_sw_cdr_timeout_cnt);
	}
}

#ifdef CONFIG_AML_LCD_EXTERN
static int lcd_extern_load_config(char *dt_addr, struct lcd_config_s *pconf)
{
	struct lcd_power_step_s *power_step;
	int index, i;

	/* mipi extern_init is special */
	if (pconf->lcd_basic.lcd_type == LCD_MIPI) {
		index = pconf->lcd_control.mipi_config->extern_init;
		if (index < LCD_EXTERN_INDEX_INVALID)
			aml_lcd_extern_probe(dt_addr, index);
	}

	i = 0;
	while (i < LCD_PWR_STEP_MAX) {
		power_step = &pconf->lcd_power->power_on_step[i];
		if (power_step->type >= LCD_POWER_TYPE_MAX)
			break;
		if (power_step->type == LCD_POWER_TYPE_EXTERN) {
			if (lcd_debug_print_flag) {
				LCDPR("power_on: step %d: type=%d, index=%d\n",
					i, power_step->type, power_step->index);
			}
			index = power_step->index;
			if (index < LCD_EXTERN_INDEX_INVALID)
				aml_lcd_extern_probe(dt_addr, index);
		}
		i++;
	}

	return 0;
}
#endif

#ifdef CONFIG_OF_LIBFDT
static int lcd_init_load_from_dts(char *dt_addr)
{
	struct lcd_config_s *pconf = aml_lcd_driver.lcd_config;
	int parent_offset;
	char *propdata, *p;
	const char *str;
	int i, j, temp;

	/* check bl_key_valid */
	parent_offset = fdt_path_offset(dt_addr, "/backlight");
	if (parent_offset < 0) {
		LCDERR("not find /backlight node: %s\n", fdt_strerror(parent_offset));
		aml_lcd_driver.bl_config->bl_key_valid = 0;
	}
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "key_valid", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get key_valid\n");
		aml_lcd_driver.bl_config->bl_key_valid = 0;
	} else {
		aml_lcd_driver.bl_config->bl_key_valid = (unsigned char)(be32_to_cpup((u32*)propdata));
	}

	parent_offset = fdt_path_offset(dt_addr, "/lcd");
	if (parent_offset < 0) {
		LCDERR("not find /lcd node: %s\n", fdt_strerror(parent_offset));
		return -1;
	}

	/* check lcd_mode & lcd_key_valid */
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "mode", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get mode\n");
		return -1;
	} else {
		pconf->lcd_mode = lcd_mode_str_to_mode(propdata);
	}
	str = propdata;
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "key_valid", NULL);
	if (propdata == NULL) {
		LCDERR("failed to get key_valid\n");
		pconf->lcd_key_valid = 0;
	} else {
		pconf->lcd_key_valid = (unsigned char)(be32_to_cpup((u32*)propdata));
	}
	LCDPR("detect mode: %s, key_valid: %d\n", str, pconf->lcd_key_valid);

	/* check lcd_clk_path */
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "clk_path", NULL);
	if (propdata == NULL) {
		if (lcd_debug_print_flag)
			LCDPR("failed to get clk_path\n");
		pconf->lcd_clk_path = 0;
	} else {
		pconf->lcd_clk_path = (unsigned char)(be32_to_cpup((u32*)propdata));
		LCDPR("detect lcd_clk_path: %d\n", pconf->lcd_clk_path);
	}
	str = getenv("lcd_clk_path");
	if (str) {
		temp = simple_strtoul(str, NULL, 10);
		if (temp)
			pconf->lcd_clk_path = 1;
		else
			pconf->lcd_clk_path = 0;
		LCDPR("lcd_clk_path flag set clk_path: %d\n", pconf->lcd_clk_path);
	}

	i = 0;
	propdata = (char *)fdt_getprop(dt_addr, parent_offset, "lcd_cpu_gpio_names", NULL);
	if (propdata == NULL) {
		LCDPR("failed to get lcd_cpu_gpio_names\n");
	} else {
		p = propdata;
		while (i < LCD_CPU_GPIO_NUM_MAX) {
			str = p;
			if (strlen(str) == 0)
				break;
			strcpy(pconf->lcd_power->cpu_gpio[i], str);
			if (lcd_debug_print_flag) {
				LCDPR("i=%d, gpio=%s\n",
					i, pconf->lcd_power->cpu_gpio[i]);
			}
			p += strlen(p) + 1;
			i++;
		}
	}
	for (j = i; j < LCD_CPU_GPIO_NUM_MAX; j++)
		strcpy(pconf->lcd_power->cpu_gpio[j], "invalid");

	return 0;
}
#endif

static int lcd_init_load_from_bsp(void)
{
	struct lcd_config_s *pconf = aml_lcd_driver.lcd_config;
	int i, j, temp;
	char *str;

	/*pconf->lcd_key_valid = 0;
	aml_lcd_driver.bl_config->bl_key_valid = 0;*/
	LCDPR("detect mode: %s, key_valid: %d\n",
		lcd_mode_mode_to_str(pconf->lcd_mode), pconf->lcd_key_valid);

	i = 0;
	while (i < LCD_CPU_GPIO_NUM_MAX) {
		if (strcmp(pconf->lcd_power->cpu_gpio[i], "invalid") == 0)
			break;
		i++;
	}
	for (j = i; j < LCD_CPU_GPIO_NUM_MAX; j++) {
		strcpy(pconf->lcd_power->cpu_gpio[j], "invalid");
	}

	str = getenv("lcd_clk_path");
	if (str) {
		temp = simple_strtoul(str, NULL, 10);
		if (temp)
			pconf->lcd_clk_path = 1;
		else
			pconf->lcd_clk_path = 0;
		LCDPR("lcd_clk_path flag set clk_path: %d\n", pconf->lcd_clk_path);
	}

	return 0;
}

static int lcd_config_probe(void)
{
	int load_id = 0;
	char *dt_addr, *str;
#ifdef CONFIG_OF_LIBFDT
	int parent_offset;
#endif
	int ret;

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
		parent_offset = fdt_path_offset(dt_addr, "/lcd");
		if (parent_offset < 0) {
			LCDERR("not find /lcd node: %s\n", fdt_strerror(parent_offset));
			load_id = 0x0;
		} else {
			load_id = 0x1;
		}
	}
#endif

	lcd_debug_test = 0;
	str = getenv("lcd_debug_test");
	if (str == NULL)
		lcd_debug_test = 0;
	else
		lcd_debug_test = simple_strtoul(str, NULL, 10);
	if (lcd_debug_test) {
		load_id = 0x0;
		LCDPR("lcd_debug_test flag: %d\n", lcd_debug_test);
	}

	/* default setting */
	aml_lcd_driver.lcd_config->retry_enable_flag = 0;
	aml_lcd_driver.lcd_config->retry_enable_cnt = 0;

	if (load_id & 0x1 ) {
#ifdef CONFIG_OF_LIBFDT
		ret = lcd_init_load_from_dts(dt_addr);
		if (ret)
			return -1;
		if (aml_lcd_driver.unifykey_test_flag) {
			aml_lcd_driver.bl_config->bl_key_valid = 1;
			aml_lcd_driver.lcd_config->lcd_key_valid = 1;
			LCDPR("force bl_key_valid & lcd_key_valid to 1\n");
		}
		if (aml_lcd_driver.lcd_config->lcd_key_valid) {
			ret = aml_lcd_unifykey_check("lcd");
			if (ret == 0) {
				LCDPR("load config from unifykey\n");
				load_id |= 0x10;
			} else {
				LCDPR("load config from dts\n");
			}
		} else {
			LCDPR("load config from dts\n");
		}
#endif
	} else {
		ret = lcd_init_load_from_bsp();
		if (ret)
			return -1;
		if (aml_lcd_driver.unifykey_test_flag) {
			aml_lcd_driver.bl_config->bl_key_valid = 1;
			aml_lcd_driver.lcd_config->lcd_key_valid = 1;
			LCDPR("force bl_key_valid & lcd_key_valid to 1\n");
		}
		if (aml_lcd_driver.lcd_config->lcd_key_valid) {
			ret = aml_lcd_unifykey_check("lcd");
			if (ret == 0) {
				LCDPR("load lcd_config from unifykey\n");
				load_id |= 0x10;
			} else {
				LCDPR("load lcd_config from bsp\n");
			}
		} else {
			LCDPR("load config from bsp\n");
		}
	}

	lcd_clk_config_probe();

	/* load lcd config */
	switch (aml_lcd_driver.lcd_config->lcd_mode) {
#ifdef CONFIG_AML_LCD_TV
	case LCD_MODE_TV:
		ret = get_lcd_tv_config(dt_addr, load_id);
		break;
#endif
#ifdef CONFIG_AML_LCD_TABLET
	case LCD_MODE_TABLET:
		ret = get_lcd_tablet_config(dt_addr, load_id);
		break;
#endif
	default:
		LCDERR("invalid lcd mode: %d\n", aml_lcd_driver.lcd_config->lcd_mode);
		break;
	}
	if (ret) {
		aml_lcd_driver.config_check = NULL;
		LCDERR("invalid lcd config\n");
		return -1;
	}
	if (aml_lcd_driver.lcd_config->lcd_basic.lcd_type == LCD_VBYONE)
		lcd_vbyone_filter_env_init(aml_lcd_driver.lcd_config);
	if ((aml_lcd_driver.chip_type == LCD_CHIP_TXHD) ||
		(aml_lcd_driver.chip_type == LCD_CHIP_TL1))
		lcd_tcon_probe(dt_addr, &aml_lcd_driver, load_id);

#ifdef CONFIG_AML_LCD_EXTERN
	lcd_extern_load_config(dt_addr, aml_lcd_driver.lcd_config);
#endif

	/* load bl config */
	if (aml_lcd_driver.bl_config->bl_key_valid) {
		ret = aml_lcd_unifykey_check("backlight");
		if (ret == 0) {
			LCDPR("load backlight_config from unifykey\n");
			load_id |= 0x10;
		} else {
			load_id &= ~(0x10);
		}
	} else {
		load_id &= ~(0x10);
	}
	aml_bl_config_load(dt_addr, load_id);

	if (lcd_debug_print_flag) {
		if (aml_lcd_driver.lcd_config->lcd_basic.lcd_type == LCD_VBYONE)
			lcd_vbyone_filter_flag_print(aml_lcd_driver.lcd_config);
	}

	aml_lcd_debug_probe(&aml_lcd_driver);

	return 0;
}

int lcd_probe(void)
{
#ifdef LCD_DEBUG_INFO
	lcd_debug_print_flag = 1;
#else
	char *str;
	int ret = 0;

	str = getenv("lcd_debug_print");
	if (str == NULL) {
		lcd_debug_print_flag = 0;
	} else {
		lcd_debug_print_flag = simple_strtoul(str, NULL, 10);
		LCDPR("lcd_debug_print flag: %d\n", lcd_debug_print_flag);
	}
#endif

	lcd_chip_detect();
	lcd_config_bsp_init();
	ret = lcd_config_probe();
	if (ret)
		return 0;

	aml_bl_power_ctrl(0, 0); /* init backlight ctrl port */
	mdelay(10);

	return 0;
}

int lcd_remove(void)
{
#ifdef CONFIG_AML_LCD_EXTERN
	aml_lcd_extern_remove();
#endif

	return 0;
}

#define LCD_WAIT_VSYNC_TIMEOUT    50000
void lcd_wait_vsync(void)
{
	int line_cnt, line_cnt_previous;
	int i = 0;

	line_cnt = 0x1fff;
	line_cnt_previous = lcd_vcbus_getb(ENCL_INFO_READ, 16, 13);
	while (i++ < LCD_WAIT_VSYNC_TIMEOUT) {
		line_cnt = lcd_vcbus_getb(ENCL_INFO_READ, 16, 13);
		if (line_cnt < line_cnt_previous)
			break;
		line_cnt_previous = line_cnt;
		udelay(2);
	}
	/*LCDPR("line_cnt=%d, line_cnt_previous=%d, i=%d\n",
	 *	line_cnt, line_cnt_previous, i);
	 */
}

/* ********************************************** *
  lcd driver API
 * ********************************************** */
static int lcd_outputmode_check(char *mode)
{
	if (aml_lcd_driver.outputmode_check)
		return aml_lcd_driver.outputmode_check(mode);

	LCDERR("invalid lcd config\n");
	return -1;
}

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

static void aml_lcd_set_ss(unsigned int level, unsigned int freq, unsigned int mode)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	unsigned int temp;
	int ret;

	if (lcd_check_valid())
		return;
	if (aml_lcd_driver.lcd_status) {
		temp = lcd_drv->lcd_config->lcd_timing.ss_level;
		ret = lcd_set_ss(level, freq, mode);
		if (ret == 0) {
			if (level < 0xff) {
				temp &= ~(0xff);
				temp |= level;
				lcd_drv->lcd_config->lcd_timing.ss_level = temp;
			}
			if (freq < 0xff) {
				temp &= ~((0xf << LCD_CLK_SS_BIT_FREQ) << 8);
				temp |= ((freq << LCD_CLK_SS_BIT_FREQ) << 8);
				lcd_drv->lcd_config->lcd_timing.ss_level = temp;
			}
			if (mode < 0xff) {
				temp &= ~((0xf << LCD_CLK_SS_BIT_MODE) << 8);
				temp |= ((mode << LCD_CLK_SS_BIT_MODE) << 8);
				lcd_drv->lcd_config->lcd_timing.ss_level = temp;
			}
		}
	} else {
		LCDPR("already disabled\n");
	}
}

static void aml_lcd_get_ss(void)
{
	if (lcd_check_valid())
		return;
	if (aml_lcd_driver.lcd_status)
		lcd_get_ss();
	else
		LCDPR("already disabled\n");
}

static void aml_lcd_test(int num)
{
	if (lcd_check_valid())
		return;
	if (aml_lcd_driver.lcd_status)
		aml_lcd_debug_test(num);
	else
		LCDPR("already disabled\n");
}

static void aml_lcd_clk(void)
{
	if (lcd_check_valid())
		return;
	lcd_clk_config_print();
}

static void aml_lcd_info(void)
{
	if (lcd_check_valid())
		return;
	aml_lcd_info_print();
}

static void aml_lcd_reg(void)
{
	if (lcd_check_valid())
		return;
	aml_lcd_reg_print();
}

static void aml_set_backlight_level(int level)
{
	aml_bl_set_level(level);
}

static int aml_get_backlight_level(void)
{
	return aml_bl_get_level();
}

static void aml_backlight_power_on(void)
{
	aml_bl_power_ctrl(1, 1);
}

static void aml_backlight_power_off(void)
{
	aml_bl_power_ctrl(0, 1);
}

static void aml_lcd_key_test(void)
{
	if (aml_lcd_driver.unifykey_test_flag) {
		aml_lcd_unifykey_test();
		lcd_config_probe();
	} else {
		printf("lcd unifykey test disabled\n");
	}
}

static void aml_lcd_key_tcon_test(void)
{
	if (aml_lcd_driver.unifykey_test_flag) {
		aml_lcd_unifykey_tcon_test(1080);
		lcd_config_probe();
	} else {
		printf("lcd unifykey test disabled\n");
	}
}

static void aml_lcd_key_dump(void)
{
	int flag = LCD_UKEY_DEBUG_NORMAL;

	switch (aml_lcd_driver.chip_type) {
	case LCD_CHIP_TXHD:
		flag |= LCD_UKEY_DEBUG_TCON;
		break;
	default:
		break;
	}
	aml_lcd_unifykey_dump(flag);
}

static void aml_lcd_extern_info(void)
{
#ifdef CONFIG_AML_LCD_EXTERN
	struct aml_lcd_extern_driver_s *ext_drv;

	ext_drv = aml_lcd_extern_get_driver();
	if (ext_drv)
		ext_drv->info_print();
#else
	printf("lcd_extern is not support\n");
#endif
}

static struct aml_lcd_drv_s aml_lcd_driver = {
	.lcd_status = 0,
	.lcd_config = &lcd_config_dft,
	.bl_config = &bl_config_dft,
	.config_check = NULL,
	.lcd_probe = lcd_probe,
	.lcd_outputmode_check = lcd_outputmode_check,
	.lcd_enable = lcd_enable,
	.lcd_disable = lcd_disable,
	.lcd_set_ss = aml_lcd_set_ss,
	.lcd_get_ss = aml_lcd_get_ss,
	.lcd_test = aml_lcd_test,
	.lcd_clk = aml_lcd_clk,
	.lcd_info = aml_lcd_info,
	.lcd_reg = aml_lcd_reg,
	.lcd_tcon_reg_print = NULL,
	.lcd_tcon_table_print = NULL,
	.lcd_tcon_reg_read = NULL,
	.lcd_tcon_reg_write = NULL,
	.bl_on = aml_backlight_power_on,
	.bl_off = aml_backlight_power_off,
	.set_bl_level = aml_set_backlight_level,
	.get_bl_level = aml_get_backlight_level,
	.bl_config_print = aml_bl_config_print,
	.unifykey_test_flag = 0, /* default disable unifykey test */
	.unifykey_test = aml_lcd_key_test,
	.unifykey_tcon_test = aml_lcd_key_tcon_test,
	.unifykey_dump = aml_lcd_key_dump,
	.lcd_extern_info = aml_lcd_extern_info,

	/* for factory test */
	.factory_lcd_power_on_step = NULL,
	.factory_bl_power_on_delay = -1,
};

struct aml_lcd_drv_s *aml_lcd_get_driver(void)
{
	return &aml_lcd_driver;
}
