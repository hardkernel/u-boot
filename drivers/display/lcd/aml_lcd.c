/*
 * AMLOGIC timing controller driver.
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
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
 *
 */
#include <common.h>
#include <malloc.h>
#include <amlogic/aml_lcd.h>
#include <asm/arch/gpio.h>
#ifdef CONFIG_AML_LCD_EXTERN
#include <amlogic/aml_lcd_extern.h>
#endif
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"

#define PANEL_NAME	"panel"

static struct lcd_config_s *aml_lcd_config;
static struct bl_config_s *aml_bl_config;
static struct aml_lcd_drv_s aml_lcd_driver;

#if 0
static unsigned int aml_lcd_pinmux_reg[] = {
	PERIPHS_PIN_MUX_0,
	PERIPHS_PIN_MUX_1,
	PERIPHS_PIN_MUX_2,
	PERIPHS_PIN_MUX_3,
	PERIPHS_PIN_MUX_4,
	PERIPHS_PIN_MUX_5,
	PERIPHS_PIN_MUX_6,
	PERIPHS_PIN_MUX_7,
	PERIPHS_PIN_MUX_8,
	PERIPHS_PIN_MUX_9,
	PERIPHS_PIN_MUX_10,
	//AO_RTI_PIN_MUX_REG,
};
#endif

extern void mdelay(unsigned long msec);
#if 0
static void panel_power_ctrl(Bool_t status)
{
#ifdef CONFIG_AML_LCD_EXTERN
	struct aml_lcd_extern_driver_t *ext_drv;
#endif
	lcd_printf("statu=%s gpio=%d value=%d \n",(status ? "ON" : "OFF"),
		pDev->pconf->lcd_power_ctrl.panel_power->gpio,
		(status ?pDev->pconf->lcd_power_ctrl.panel_power->on_value:
				pDev->pconf->lcd_power_ctrl.panel_power->off_value));

	if ( ON == status) {
		amlogic_gpio_direction_output(pDev->pconf->lcd_power_ctrl.panel_power->gpio,
						pDev->pconf->lcd_power_ctrl.panel_power->on_value);
		mdelay(pDev->pconf->lcd_power_ctrl.panel_power->panel_on_delay);
#ifdef CONFIG_AML_LCD_EXTERN
		if (pDev->pconf->lcd_control.ext_config->index < LCD_EXTERN_INDEX_INVALID) {
			ext_drv = aml_lcd_extern_get_driver();
			if (ext_drv) {
				if (ext_drv->power_on)
					ext_drv->power_on();
			}
			if (pDev->pconf->lcd_control.ext_config->on_delay > 0)
				mdelay(pDev->pconf->lcd_control.ext_config->on_delay);
		}
#endif
	} else {
#ifdef CONFIG_AML_LCD_EXTERN
		if (pDev->pconf->lcd_control.ext_config->index < LCD_EXTERN_INDEX_INVALID) {
			if (pDev->pconf->lcd_control.ext_config->off_delay > 0)
				mdelay(pDev->pconf->lcd_control.ext_config->off_delay);
			ext_drv = aml_lcd_extern_get_driver();
			if (ext_drv) {
				if (ext_drv->power_off)
					ext_drv->power_off();
			}
		}
#endif
		mdelay(pDev->pconf->lcd_power_ctrl.panel_power->panel_off_delay);
		amlogic_gpio_direction_output(pDev->pconf->lcd_power_ctrl.panel_power->gpio,
						pDev->pconf->lcd_power_ctrl.panel_power->off_value);
	}
}

static int aml_lcd_pinmux_set(unsigned int mux_index, unsigned int mux_mask)
{
	lcd_printf("aml_lcd_pinmux_set: reg=%d, mask=%x\n",mux_index,mux_mask);
	if (mux_index < ARRAY_SIZE(aml_lcd_pinmux_reg)) {
		lcd_cbus_set_mask(aml_lcd_pinmux_reg[mux_index], mux_mask);

		return 0;
	} else {
		printf("lcd error: wrong pinmux index %d\n", mux_index);
		return -1;
	}
}

static int aml_lcd_pinmux_clr(unsigned int mux_index, unsigned int mux_mask)
{
	lcd_printf("aml_lcd_pinmux_clr: reg=%d  mask=%x\n",mux_index,mux_mask);

	if (mux_index <  ARRAY_SIZE(aml_lcd_pinmux_reg)) {
		lcd_cbus_clr_mask(aml_lcd_pinmux_reg[mux_index], mux_mask);
		return 0;
	} else {
		printf("lcd error: wrong pinmux index %d\n", mux_index);
		return -1;
	}
}

static void aml_bl_pwm_param_init(Bl_Pwm_Config_t *bl_pwm_conf)
{
	unsigned int pwm_freq;
	unsigned int pwm_pre_div;
	unsigned int pwm_cnt;
	int i;

	pwm_freq = bl_pwm_conf->pwm_freq;

	if (bl_pwm_conf->pwm_port == BL_PWM_VS) {
		pwm_cnt = aml_read_reg32(P_ENCL_VIDEO_MAX_LNCNT) + 1;
		bl_pwm_conf->pwm_cnt = pwm_cnt;
		printf("aml_bl: pwm_cnt = %u\n", bl_pwm_conf->pwm_cnt);
	} else {
		for (i = 0; i < 0x7f; i++) {
			pwm_pre_div = i;
			pwm_cnt = XTAL_FREQ_HZ / (pwm_freq * (pwm_pre_div + 1)) - 2;
			if (pwm_cnt <= 0xffff) /* 16bit */
				break;
		}

		bl_pwm_conf->pwm_cnt = pwm_cnt;
		bl_pwm_conf->pre_div = pwm_pre_div;
		lcd_printf("pwm_cnt = %u, pwm_pre_div = %u\n", pwm_cnt, pwm_pre_div);
	}

	bl_pwm_conf->pwm_max = (pwm_cnt * bl_pwm_conf->pwm_duty_max / 100);
	bl_pwm_conf->pwm_min = (pwm_cnt * bl_pwm_conf->pwm_duty_min / 100);
	lcd_printf("pwm_max = %u, pwm_min = %u\n", bl_pwm_conf->pwm_max, bl_pwm_conf->pwm_min);
}

static void aml_bl_pwm_duty_set(Bl_Pwm_Config_t *bl_pwm_conf,
	unsigned int pwm_high, unsigned int pwm_low)
{
	unsigned int pre_div = 0;
	unsigned int high, low;
	unsigned int vs[4], ve[4], sw, n, i;

	if (bl_pwm_conf->pwm_port == BL_PWM_VS) {
		memset(vs, 0, sizeof(unsigned int) * 4);
		memset(ve, 0, sizeof(unsigned int) * 4);
		n = bl_pwm_conf->pwm_freq;
		sw = (bl_pwm_conf->pwm_cnt * 10 / n + 5) / 10;
		if (bl_pwm_conf->pwm_positive)
			high = (pwm_high * 10 / n + 5) / 10;
		else
			high = (pwm_low * 10 / n + 5) / 10;
		high = (high > 1) ? high : 1;
		for (i = 0; i < n; i++) {
			vs[i] = 1 + (sw * i);
			ve[i] = vs[i] + high - 1;
		}
	} else {
		pre_div = bl_pwm_conf->pre_div;
		if (bl_pwm_conf->pwm_positive) {
			high = pwm_high;
			low = pwm_low;
		} else {
			high = pwm_low;
			low = pwm_high;
		}
	}

	switch (bl_pwm_conf->pwm_port) {
	case BL_PWM_A:
		aml_write_reg32(P_PWM_MISC_REG_AB, (aml_read_reg32(P_PWM_MISC_REG_AB) & ~(0x7f<<8)) | ((1 << 15) | (pre_div<<8) | (1<<0)));
		aml_write_reg32(P_PWM_PWM_A, (high << 16) | (low));
		break;
	case BL_PWM_B:
		aml_write_reg32(P_PWM_MISC_REG_AB, (aml_read_reg32(P_PWM_MISC_REG_AB) & ~(0x7f<<16)) | ((1 << 23) | (pre_div<<16) | (1<<1)));
		aml_write_reg32(P_PWM_PWM_B, (high << 16) | (low));
		break;
	case BL_PWM_C:
		aml_write_reg32(P_PWM_MISC_REG_CD, (aml_read_reg32(P_PWM_MISC_REG_CD) & ~(0x7f<<8)) | ((1 << 15) | (pre_div<<8) | (1<<0)));
		aml_write_reg32(P_PWM_PWM_C, (high << 16) | (low));
		break;
	case BL_PWM_D:
		aml_write_reg32(P_PWM_MISC_REG_CD, (aml_read_reg32(PWM_MISC_REG_CD) & ~(0x7f<<16)) | ((1 << 23) | (pre_div<<16) | (1<<1)));
		aml_write_reg32(P_PWM_PWM_D, (high << 16) | (low));
		break;
	case BL_PWM_E:
		aml_write_reg32(P_PWM_MISC_REG_EF, (aml_read_reg32(P_PWM_MISC_REG_EF) & ~(0x7f<<8)) | ((1 << 15) | (pre_div<<8) | (1<<0)));
		aml_write_reg32(P_PWM_PWM_E, (high << 16) | (low));
		break;
	case BL_PWM_F:
		aml_write_reg32(P_PWM_MISC_REG_EF, (aml_read_reg32(PWM_MISC_REG_EF) & ~(0x7f<<16)) | ((1 << 23) | (pre_div<<16) | (1<<1)));
		aml_write_reg32(P_PWM_PWM_F, (high << 16) | (low));
		break;
	case BL_PWM_VS:
		aml_write_reg32(P_VPU_VPU_PWM_V0, (ve[0] << 16) | (vs[0]));
		aml_write_reg32(P_VPU_VPU_PWM_V1, (ve[1] << 16) | (vs[1]));
		aml_write_reg32(P_VPU_VPU_PWM_V2, (ve[2] << 16) | (vs[2]));
		aml_write_reg32(P_VPU_VPU_PWM_V3, (ve[3] << 16) | (vs[3]));
	default:
		break;
	}
}

static void set_lcd_backlight_level(Bool_t status, unsigned level)
{
	unsigned int pwm_hi = 0, pwm_lo = 0;
	unsigned int pwm_range,level_range,val_range;
	unsigned int i;
	unsigned int pwm_cnt, pwm_pre_div;

	if ( ON == status) {
		mdelay(pDev->bl_config->bl_pwm.pwm_on_delay);

		aml_bl_pwm_param_init(&pDev->bl_config->bl_pwm);
		pwm_cnt = pDev->bl_config->bl_pwm.pwm_cnt;
		pwm_pre_div = pDev->bl_config->bl_pwm.pre_div;

		level = (level > pDev->bl_config->bl_pwm.level_max ? pDev->bl_config->bl_pwm.level_max :
				(level < pDev->bl_config->bl_pwm.level_min ? pDev->bl_config->bl_pwm.level_min : level));
		lcd_printf("level = %d \n",level);

		val_range   = level - pDev->bl_config->bl_pwm.level_min;
		pwm_range   = pDev->bl_config->bl_pwm.pwm_max - pDev->bl_config->bl_pwm.pwm_min;
		level_range = pDev->bl_config->bl_pwm.level_max - pDev->bl_config->bl_pwm.level_min;
		level = val_range * pwm_range / level_range + pDev->bl_config->bl_pwm.pwm_min;

		pwm_hi = level;
		pwm_lo = pwm_cnt - level;
		lcd_printf("pwm_hi= %u pwm_lo= %u \n", pwm_hi, pwm_lo);

		aml_bl_pwm_duty_set(&pDev->bl_config->bl_pwm, pwm_hi, pwm_lo);

		//set pin mux
		for (i=0; i<pDev->bl_config->bl_pwm.pinmux_clr_num; i++) {
			aml_lcd_pinmux_clr(pDev->bl_config->bl_pwm.pinmux_clr[i][0],pDev->bl_config->bl_pwm.pinmux_clr[i][1]);
		}
		for (i=0; i<pDev->bl_config->bl_pwm.pinmux_set_num; i++) {
			aml_lcd_pinmux_set( pDev->bl_config->bl_pwm.pinmux_set[i][0], pDev->bl_config->bl_pwm.pinmux_set[i][1]);
		}
	}else{
		amlogic_gpio_direction_output(pDev->bl_config->bl_pwm.pwm_gpio, level);
		mdelay(pDev->bl_config->bl_pwm.pwm_off_delay);
	}
}

static unsigned get_lcd_backlight_level(void)
{
	printf("lcd: %s\n", __func__);
	return 0;
}

static void lcd_backlight_power_ctrl(Bool_t status)
{
	lcd_printf("status=%s gpio=%d value=%d \n",(status ? "ON" : "OFF"),
			pDev->bl_config->bl_power.gpio,
			(status ?pDev->bl_config->bl_power.on_value:
					pDev->bl_config->bl_power.off_value));

	if ( ON == status) {
		mdelay(pDev->bl_config->bl_power.bl_on_delay);
		amlogic_gpio_direction_output(pDev->bl_config->bl_power.gpio,
						pDev->bl_config->bl_power.on_value);
	}else{
		amlogic_gpio_direction_output(pDev->bl_config->bl_power.gpio,
						pDev->bl_config->bl_power.off_value);
		mdelay(pDev->bl_config->bl_power.bl_off_delay);
	}
	udelay(50);
	printf("lcd: %s: %d\n", __func__, status);
}
#endif

static void lcd_module_enable(char *mode)
{
	LCDPR("module enable: %s\n", aml_lcd_config->lcd_basic.model_name);
	//panel_power_ctrl(1);

	init_lcd_driver(aml_lcd_config, mode);
	//_enable_vsync_interrupt();

	//set_lcd_backlight_level(1, bl_config->bl_pwm.level_default);

	//lcd_backlight_power_ctrl(1);
}

static void lcd_module_disable(void)
{
	LCDPR("module disable: %s\n", aml_lcd_config->lcd_basic.model_name);
	//lcd_backlight_power_ctrl(0);

	//set_lcd_backlight_level(0, 0);

	disable_lcd_driver();

	//panel_power_ctrl(0);
}

static void lcd_timing_info_print(struct lcd_config_s * pconf)
{
	unsigned int hs_width, hs_bp, h_period;
	unsigned int vs_width, vs_bp, v_period;
	unsigned int video_on_pixel, video_on_line;

	video_on_pixel = pconf->lcd_timing.video_on_pixel;
	video_on_line = pconf->lcd_timing.video_on_line;
	h_period = pconf->lcd_basic.h_period;
	v_period = pconf->lcd_basic.v_period;

	hs_width = pconf->lcd_timing.hsync_width;
	hs_bp = pconf->lcd_timing.hsync_bp;
	vs_width = pconf->lcd_timing.vsync_width;
	vs_bp = pconf->lcd_timing.vsync_bp;

	printf("h_period          %d\n"
	   "v_period          %d\n"
	   "hs_width          %d\n"
	   "hs_backporch      %d\n"
	   "vs_width          %d\n"
	   "vs_backporch      %d\n"
	   "video_on_pixel    %d\n"
	   "video_on_line     %d\n\n",
	   h_period, v_period, hs_width, hs_bp, vs_width, vs_bp,
	   video_on_pixel, video_on_line);
}

static const char *lcd_type_table[]={
	"lvds",
	"vbyone",
	"ttl",
	"invalid",
};

static void print_lcd_info(void)
{
	unsigned lcd_clk;
	unsigned int sync_duration;
	struct aml_lcd_drv_s *lcd_drv = get_aml_lcd_driver();
	struct lcd_config_s *pconf = aml_lcd_config;

	LCDPR("driver version: %s\n", lcd_drv->version);

	lcd_clk = (pconf->lcd_timing.lcd_clk / 1000);
	sync_duration = pconf->lcd_timing.sync_duration_num;
	sync_duration = (sync_duration * 10 / pconf->lcd_timing.sync_duration_den);
	printf("LCD mode: %s, %s, %ux%u@%u.%uHz\n"
		"fr_adj_type       %d\n"
		"lcd_clk           %u.%03uMHz\n\n",
		pconf->lcd_basic.model_name,
		lcd_type_table[pconf->lcd_basic.lcd_type],
		pconf->lcd_basic.h_active, pconf->lcd_basic.v_active,
		(sync_duration / 10), (sync_duration % 10),
		pconf->lcd_timing.frame_rate_adj_type,
		(lcd_clk / 1000), (lcd_clk % 1000));

	lcd_timing_info_print(pconf);

	switch (pconf->lcd_basic.lcd_type) {
	case LCD_LVDS:
		printf("lvds_repack       %u\n"
		   "pn_swap           %u\n"
		   "dual_port         %u\n"
		   "port_swap         %u\n\n",
		   pconf->lcd_control.lvds_config->lvds_repack,
		   pconf->lcd_control.lvds_config->pn_swap,
		   pconf->lcd_control.lvds_config->dual_port,
		   pconf->lcd_control.lvds_config->port_swap);
		break;
	case LCD_VBYONE:
		printf("lane_count        %u\n"
		   "byte_mode         %u\n"
		   "region_num        %u\n\n",
		   pconf->lcd_control.vbyone_config->lane_count,
		   pconf->lcd_control.vbyone_config->byte_mode,
		   pconf->lcd_control.vbyone_config->region_num);
		break;
	default:
		break;
	}

	printf("power_gpio        %d\n"
	   "power_on_value    %d\n"
	   "power_off_value   %d\n"
	   "power_on_delay    %d\n"
	   "power_off_delay   %d\n\n",
	   pconf->lcd_power->gpio,
	   pconf->lcd_power->on_value,
	   pconf->lcd_power->off_value,
	   pconf->lcd_power->on_delay,
	   pconf->lcd_power->off_delay);
#ifdef CONFIG_AML_LCD_EXTERN
	printf("extern index      %d\n"
	   "extern on_delay   %d\n"
	   "extern off_delay  %d\n\n",
	   pconf->lcd_control.ext_config->index,
	   pconf->lcd_control.ext_config->on_delay,
	   pconf->lcd_control.ext_config->off_delay);
#endif
}

int lcd_probe(void)
{
	//LCDPR("driver version: %s\n", LCD_DRV_DATE);
#if 0
	aml_lcd_config = (struct lcd_config_s *)malloc(sizeof(struct lcd_config_s));
	if (aml_lcd_config == NULL) {
		LCDPR("error: Not enough memory\n");
		return -1;
	}
	memset(aml_lcd_config, 0, sizeof(*aml_lcd_config));
#else
	aml_lcd_config = &lcd_config_dft;
#endif
#if 0
	aml_bl_config = (struct bl_config_s *)malloc(sizeof(struct bl_config_s));
	if (aml_bl_config == NULL) {
		LCDPR("error: Not enough memory\n");
		free(aml_lcd_config);
		aml_lcd_config = NULL;
		return -1;
	}
	memset(aml_bl_config, 0, sizeof(*aml_bl_config));
#endif
	aml_bl_config = NULL;
	get_lcd_config(aml_lcd_config, aml_bl_config);
	//lcd_module_enable();

	return 0;
}

int lcd_remove(void)
{
	// lcd_module_disable();
// #ifdef CONFIG_AML_LCD_EXTERN
	// aml_lcd_extern_remove();
// #endif

	free(aml_lcd_config);
	free(aml_bl_config);
	aml_lcd_config = NULL;
	aml_bl_config = NULL;
	return 0;
}

/* ********************************************** *
  lcd driver API
 * ********************************************** */
static void lcd_enable(char *mode)
{
	if (aml_lcd_config == NULL)
		printf("lcd: invalid lcd driver\n");
	else
		lcd_module_enable(mode);
}

static void lcd_disable(void)
{
	if (aml_lcd_config == NULL) {
		printf("lcd: invalid lcd driver\n");
	} else {
		lcd_module_disable();
#ifdef CONFIG_AML_LCD_EXTERN
		aml_lcd_extern_remove();
#endif
	}
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

static void lcd_test(unsigned int num, struct lcd_config_s *pconf)
{
	num = (num >= TV_LCD_ENC_TST_NUM_MAX) ? 0 : num;
	if (num >= 0) {
		lcd_vcbus_write(ENCL_VIDEO_RGBIN_CTRL, lcd_enc_tst[num][6]);
		lcd_vcbus_write(ENCL_TST_MDSEL, lcd_enc_tst[num][0]);
		lcd_vcbus_write(ENCL_TST_Y, lcd_enc_tst[num][1]);
		lcd_vcbus_write(ENCL_TST_CB, lcd_enc_tst[num][2]);
		lcd_vcbus_write(ENCL_TST_CR, lcd_enc_tst[num][3]);
		lcd_vcbus_write(ENCL_TST_CLRBAR_STRT, pconf->lcd_timing.video_on_pixel);
		lcd_vcbus_write(ENCL_TST_CLRBAR_WIDTH, (pconf->lcd_basic.h_active / 9));
		lcd_vcbus_write(ENCL_TST_EN, lcd_enc_tst[num][4]);
		lcd_vcbus_setb(ENCL_VIDEO_MODE_ADV, lcd_enc_tst[num][5], 3, 1);
		printf("lcd: show test pattern: %s\n", lcd_enc_tst_str[num]);
	} else {
		printf("lcd: disable test pattern\n");
	}
}

static void aml_lcd_test(int num)
{
	if (aml_lcd_config == NULL)
		printf("lcd: invalid lcd driver\n");
	else
		lcd_test(num, aml_lcd_config);
}

static void aml_lcd_info(void)
{
	if (aml_lcd_config == NULL)
		printf("lcd: invalid lcd driver\n");
	else
		print_lcd_info();
}

#if 0
static void aml_set_backlight_level(int level)
{
	if (aml_bl_config == NULL)
		printf("lcd: invalid lcd driver\n");
	else
		set_lcd_backlight_level(ON,level);
}

static int aml_get_backlight_level(void)
{
	if (aml_bl_config == NULL) {
		printf("lcd: invalid lcd driver\n");
		return 0;
	} else
		return get_lcd_backlight_level();
}

static void aml_backlight_power_on(void)
{
	if (aml_bl_config == NULL)
		printf("lcd: invalid lcd driver\n");
	else
		lcd_backlight_power_ctrl(ON);
}

static void aml_backlight_power_off(void)
{
	if (aml_bl_config == NULL)
		printf("lcd: invalid lcd driver\n");
	else
		lcd_backlight_power_ctrl(OFF);
}
#endif

static struct aml_lcd_drv_s aml_lcd_driver = {
	//.lcd_config = aml_lcd_config,
	//.bl_config = aml_bl_config,
	.list_support_mode = lcd_list_support_mode,
	.lcd_probe = lcd_probe,
	.lcd_enable = lcd_enable,
	.lcd_disable = lcd_disable,
	.lcd_test = aml_lcd_test,
	.lcd_info = aml_lcd_info,
	//.bl_on = aml_backlight_power_on,
	//.bl_off = aml_backlight_power_off,
	//.set_bl_level = aml_set_backlight_level,
	//.get_bl_level = aml_get_backlight_level,
};

struct aml_lcd_drv_s *get_aml_lcd_driver(void)
{
	return &aml_lcd_driver;
}
