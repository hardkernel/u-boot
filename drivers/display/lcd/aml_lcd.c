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
#include <amlogic/keyunify.h>
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

static void lcd_power_ctrl(int status)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_power_ctrl_s *lcd_power;
	struct lcd_power_step_s *power_step;
#ifdef CONFIG_AML_LCD_EXTERN
	struct aml_lcd_extern_driver_s *ext_drv;
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
	lcd_vcbus_write(VPP_POSTBLEND_H_SIZE, pconf->lcd_basic.h_active);
	lcd_vcbus_write(VENC_INTCTRL, 0x200);

	aml_bl_pwm_config_update(lcd_drv->bl_config);
	aml_bl_set_level(lcd_drv->bl_config->level_default);
	aml_bl_power_ctrl(1, 1);

	lcd_drv->lcd_status = 1;
}

static void lcd_module_disable(void)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	LCDPR("disable: %s\n", lcd_drv->lcd_config->lcd_basic.model_name);

	aml_bl_power_ctrl(0, 1);

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

	printf("h_period_min      %d\n"
		"h_period_max      %d\n"
		"v_period_min      %d\n"
		"v_period_max      %d\n"
		"pclk_min          %d\n"
		"pclk_max          %d\n\n",
		pconf->lcd_basic.h_period_min, pconf->lcd_basic.h_period_max,
		pconf->lcd_basic.v_period_min, pconf->lcd_basic.v_period_max,
		pconf->lcd_basic.lcd_clk_min, pconf->lcd_basic.lcd_clk_max);
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

static void lcd_info_print(void)
{
	unsigned int lcd_clk;
	unsigned int sync_duration;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_config_s *pconf = lcd_drv->lcd_config;

	LCDPR("driver version: %s\n", lcd_drv->version);
	LCDPR("key_valid: %d\n", aml_lcd_driver.lcd_config->lcd_key_valid);
	LCDPR("mode: %s, status: %d\n",
		 lcd_mode_mode_to_str(aml_lcd_driver.lcd_config->lcd_mode), lcd_drv->lcd_status);

	lcd_clk = (pconf->lcd_timing.lcd_clk / 1000);
	sync_duration = pconf->lcd_timing.sync_duration_num;
	sync_duration = (sync_duration * 10 / pconf->lcd_timing.sync_duration_den);
	LCDPR("%s, %s, %ux%u@%u.%uHz\n"
		"fr_adj_type       %d\n"
		"lcd_clk           %u.%03uMHz\n"
		"ss_level          %u\n\n",
		pconf->lcd_basic.model_name,
		lcd_type_type_to_str(pconf->lcd_basic.lcd_type),
		pconf->lcd_basic.h_active, pconf->lcd_basic.v_active,
		(sync_duration / 10), (sync_duration % 10),
		pconf->lcd_timing.fr_adjust_type,
		(lcd_clk / 1000), (lcd_clk % 1000),
		pconf->lcd_timing.ss_level);

	lcd_timing_info_print(pconf);

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_LVDS:
		printf("lvds_repack       %u\n"
		   "dual_port         %u\n"
		   "pn_swap           %u\n"
		   "port_swap         %u\n"
		   "phy_vswing        %u\n"
		   "phy_preem         %u\n"
		   "phy_clk_vswing    %u\n"
		   "phy_clk_preem     %u\n\n",
		   pconf->lcd_control.lvds_config->lvds_repack,
		   pconf->lcd_control.lvds_config->dual_port,
		   pconf->lcd_control.lvds_config->pn_swap,
		   pconf->lcd_control.lvds_config->port_swap,
		   pconf->lcd_control.lvds_config->phy_vswing,
		   pconf->lcd_control.lvds_config->phy_preem,
		   pconf->lcd_control.lvds_config->phy_clk_vswing,
		   pconf->lcd_control.lvds_config->phy_clk_preem);
		break;
	case LCD_VBYONE:
		printf("lane_count        %u\n"
		   "region_num        %u\n"
		   "byte_mode         %u\n"
		   "phy_vswing        %u\n"
		   "phy_preemphasis   %u\n\n",
		   pconf->lcd_control.vbyone_config->lane_count,
		   pconf->lcd_control.vbyone_config->region_num,
		   pconf->lcd_control.vbyone_config->byte_mode,
		   pconf->lcd_control.lvds_config->phy_vswing,
		   pconf->lcd_control.lvds_config->phy_preem);
		break;
	case LCD_TTL:
		printf("clk_pol           %u\n"
		   "hvsync_valid      %u\n"
		   "DE_valid          %u\n"
		   "bit_swap          %u\n"
		   "rb_swap           %u\n\n",
		   pconf->lcd_control.ttl_config->clk_pol,
		   (pconf->lcd_control.ttl_config->sync_valid >> 0) & 1,
		   (pconf->lcd_control.ttl_config->sync_valid >> 1) & 1,
		   (pconf->lcd_control.ttl_config->swap_ctrl >> 0) & 1,
		   (pconf->lcd_control.ttl_config->swap_ctrl >> 1) & 1);
		break;
	default:
		break;
	}

	lcd_power_info_print(pconf, 1);
	lcd_power_info_print(pconf, 0);
}

static unsigned int lcd_reg_dump_clk[] = {
	HHI_HDMI_PLL_CNTL,
	HHI_HDMI_PLL_CNTL2,
	HHI_HDMI_PLL_CNTL3,
	HHI_HDMI_PLL_CNTL4,
	HHI_HDMI_PLL_CNTL5,
	HHI_HDMI_PLL_CNTL6,
	HHI_VID_PLL_CLK_DIV,
	HHI_VIID_CLK_DIV,
	HHI_VIID_CLK_CNTL,
	HHI_VID_CLK_CNTL2,
};

static unsigned int lcd_reg_dump_encl[] = {
	VPU_VIU_VENC_MUX_CTRL,
	ENCL_VIDEO_EN,
	ENCL_VIDEO_MODE,
	ENCL_VIDEO_MODE_ADV,
	ENCL_VIDEO_MAX_PXCNT,
	ENCL_VIDEO_MAX_LNCNT,
	ENCL_VIDEO_HAVON_BEGIN,
	ENCL_VIDEO_HAVON_END,
	ENCL_VIDEO_VAVON_BLINE,
	ENCL_VIDEO_VAVON_ELINE,
	ENCL_VIDEO_HSO_BEGIN,
	ENCL_VIDEO_HSO_END,
	ENCL_VIDEO_VSO_BEGIN,
	ENCL_VIDEO_VSO_END,
	ENCL_VIDEO_VSO_BLINE,
	ENCL_VIDEO_VSO_ELINE,
	ENCL_VIDEO_RGBIN_CTRL,
	L_GAMMA_CNTL_PORT,
	L_RGB_BASE_ADDR,
	L_RGB_COEFF_ADDR,
	L_POL_CNTL_ADDR,
	L_DITH_CNTL_ADDR,
};

static void lcd_ttl_reg_print(void)
{
	unsigned int reg;

	printf("\nttl registers:\n");
	reg = L_DUAL_PORT_CNTL_ADDR;
	printf("PORT_CNTL           [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = L_STH1_HS_ADDR;
	printf("STH1_HS_ADDR        [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = L_STH1_HE_ADDR;
	printf("STH1_HE_ADDR        [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_STH1_VS_ADDR;
	printf("STH1_VS_ADDR        [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_STH1_VE_ADDR;
	printf("STH1_VE_ADDR        [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_STV1_HS_ADDR;
	printf("STV1_HS_ADDR        [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_STV1_HE_ADDR;
	printf("STV1_HE_ADDR        [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_STV1_VS_ADDR;
	printf("STV1_VS_ADDR        [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_STV1_VE_ADDR;
	printf("STV1_VE_ADDR        [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_OEH_HS_ADDR;
	printf("OEH_HS_ADDR         [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_OEH_HE_ADDR;
	printf("OEH_HE_ADDR         [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_OEH_VS_ADDR;
	printf("OEH_VS_ADDR         [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = L_OEH_VE_ADDR;
	printf("OEH_VE_ADDR         [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
}

static void lcd_lvds_reg_print(void)
{
	unsigned int reg;

	printf("\nlvds registers:\n");
	reg = LVDS_PACK_CNTL_ADDR;
	printf("LVDS_PACK_CNTL      [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = LVDS_GEN_CNTL;
	printf("LVDS_GEN_CNTL       [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = HHI_LVDS_TX_PHY_CNTL0;
	printf("LVDS_PHY_CNTL0      [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = HHI_LVDS_TX_PHY_CNTL1;
	printf("LVDS_PHY_CNTL1      [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
}

static void lcd_vbyone_reg_print(void)
{
	unsigned int reg;

	printf("\nvbyone registers:\n");
	reg = PERIPHS_PIN_MUX_7;
	printf("VX1_PINMUX          [0x%04x] = 0x%08x\n",
		reg, lcd_periphs_read(reg));
	reg = VBO_STATUS_L;
	printf("VX1_STATUS          [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = VBO_FSM_HOLDER_L;
	printf("VX1_FSM_HOLDER_L    [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = VBO_FSM_HOLDER_H;
	printf("VX1_FSM_HOLDER_H    [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = VBO_INTR_STATE_CTRL;
	printf("VX1_INTR_STATE_CTRL [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = VBO_INTR_UNMASK;
	printf("VX1_INTR_UNMASK     [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = VBO_INTR_STATE;
	printf("VX1_INTR_STATE      [0x%04x] = 0x%08x\n",
		reg, lcd_vcbus_read(reg));
	reg = HHI_LVDS_TX_PHY_CNTL0;
	printf("VX1_PHY_CNTL0       [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
}

static void lcd_phy_analog_reg_print(void)
{
	unsigned int reg;

	printf("\nphy analog registers:\n");
	reg = HHI_DIF_CSI_PHY_CNTL1;
	printf("PHY_CNTL1           [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = HHI_DIF_CSI_PHY_CNTL2;
	printf("PHY_CNTL2           [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
	reg = HHI_DIF_CSI_PHY_CNTL3;
	printf("PHY_CNTL3           [0x%04x] = 0x%08x\n",
		reg, lcd_hiu_read(reg));
}

static void lcd_reg_print(void)
{
	int i;
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();
	struct lcd_config_s *pconf;

	pconf = lcd_drv->lcd_config;
	printf("clk registers:\n");
	for (i = 0; i < ARRAY_SIZE(lcd_reg_dump_clk); i++) {
		printf("hiu     [0x%04x] = 0x%08x\n",
			lcd_reg_dump_clk[i],
			lcd_hiu_read(lcd_reg_dump_clk[i]));
	}

	printf("\nencl registers:\n");
	for (i = 0; i < ARRAY_SIZE(lcd_reg_dump_encl); i++) {
		printf("vcbus   [0x%04x] = 0x%08x\n",
			lcd_reg_dump_encl[i],
			lcd_vcbus_read(lcd_reg_dump_encl[i]));
	}

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_TTL:
		lcd_ttl_reg_print();
		break;
	case LCD_LVDS:
		lcd_lvds_reg_print();
		lcd_phy_analog_reg_print();
		break;
	case LCD_VBYONE:
		lcd_vbyone_reg_print();
		lcd_phy_analog_reg_print();
		break;
	case LCD_MIPI:
		break;
	case LCD_EDP:
		break;
	default:
		break;
	}
}

#ifdef CONFIG_AML_LCD_EXTERN
static int lcd_extern_load_config(char *dt_addr, struct lcd_config_s *pconf)
{
	struct lcd_power_step_s *power_step;
	int index, i;

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
	int i, j;

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
	int i, j;

	pconf->lcd_key_valid = 0;
	aml_lcd_driver.bl_config->bl_key_valid = 0;
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

	return 0;
}

static int lcd_mode_probe(void)
{
	int load_id = 0;
	unsigned int lcd_debug_test = 0;
	char *dt_addr;
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
		load_id = 0x1;
	}
#endif

	lcd_debug_test = simple_strtoul(getenv("lcd_debug_test"), NULL, 10);
	if (lcd_debug_test)
		load_id = 0x0;

	if (load_id & 0x1 ) {
#ifdef CONFIG_OF_LIBFDT
		ret = lcd_init_load_from_dts(dt_addr);
		if (ret)
			return -1;
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
		if (aml_lcd_driver.lcd_config->lcd_key_valid) {
			ret = aml_lcd_unifykey_check("lcd");
			if (ret == 0) {
				LCDPR("load lcd_config from unifykey\n");
				load_id |= 0x10;
			} else {
				LCDPR("load lcd_config from lcd.c\n");
			}
		} else {
			LCDPR("load config from lcd.c\n");
		}
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
			LCDPR("load backlight_config from dts\n");
			load_id &= ~(0x10);
		}
	} else {
		load_id &= ~(0x10);
	}
	aml_bl_config_load(dt_addr, load_id);

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
	lcd_config_gpio_init();
	lcd_clk_config_probe();
	lcd_mode_probe();
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

static void aml_lcd_set_ss(int level)
{
	struct aml_lcd_drv_s *lcd_drv = aml_lcd_get_driver();

	if (lcd_check_valid())
		return;
	if (aml_lcd_driver.lcd_status) {
		lcd_drv->lcd_config->lcd_timing.ss_level = level;
		lcd_set_spread_spectrum();
	} else {
		LCDPR("already disabled\n");
	}
}

static char *aml_lcd_get_ss(void)
{
	char *str = "invalid";

	if (lcd_check_valid())
		return str;
	if (aml_lcd_driver.lcd_status)
		str = lcd_get_spread_spectrum();
	else
		LCDPR("already disabled\n");

	return str;
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

static void aml_lcd_clk(void)
{
	if (lcd_check_valid())
		return;
	lcd_clk_config_print();
}

extern void lcd_unifykey_test(void);
static void aml_lcd_info(void)
{
	if (lcd_check_valid())
		return;
	lcd_info_print();
}

static void aml_lcd_reg(void)
{
	if (lcd_check_valid())
		return;
	lcd_reg_print();
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

static void aml_lcd_unifykey_test(void)
{
	aml_lcd_test_unifykey();
	aml_lcd_extern_test_unifykey();
	aml_bl_test_unifykey();
	lcd_mode_probe();
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
	.lcd_enable = lcd_enable,
	.lcd_disable = lcd_disable,
	.lcd_set_ss = aml_lcd_set_ss,
	.lcd_get_ss = aml_lcd_get_ss,
	.lcd_test = aml_lcd_test,
	.lcd_clk = aml_lcd_clk,
	.lcd_info = aml_lcd_info,
	.lcd_reg = aml_lcd_reg,
	.bl_on = aml_backlight_power_on,
	.bl_off = aml_backlight_power_off,
	.set_bl_level = aml_set_backlight_level,
	.get_bl_level = aml_get_backlight_level,
	.bl_config_print = aml_bl_config_print,
	.unifykey_test = aml_lcd_unifykey_test,
	.lcd_extern_info = aml_lcd_extern_info,
};

struct aml_lcd_drv_s *aml_lcd_get_driver(void)
{
	return &aml_lcd_driver;
}
