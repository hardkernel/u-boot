/*
 * AMLOGIC lcd controller driver.
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
 * Author:  Elvis Yu <elvis.yu@amlogic.com>
 *
 * Modify:  Evoke Zhang <evoke.zhang@amlogic.com>
 * compatible dts
 *
 */
#include <common.h>
#include <malloc.h>
#include <asm/arch/io.h>
#include <asm/arch/vinfo.h>
#include <asm/arch/lcdoutc.h>
#ifdef CONFIG_LCD_TYPE_MID_VALID
#include <amlogic/aml_lcd.h>
#include <amlogic/vinfo.h>
#include <amlogic/lcdoutc.h>
#include <amlogic/aml_lcd_common.h>
#include <asm/arch/clock.h>
#include <asm/arch/timing.h>
#include <asm/arch/lcd_reg.h>
#ifdef CONFIG_OF_LIBFDT
#include <libfdt.h>
#endif
#ifdef CONFIG_AML_LCD_EXTERN
#include <amlogic/aml_lcd_extern.h>
#endif
#ifdef CONFIG_AML_BL_EXTERN
#include <amlogic/aml_bl_extern.h>
#endif
#ifdef CONFIG_PLATFORM_HAS_PMU
#include <amlogic/aml_pmu_common.h>
#define BATTERY_LOW_THRESHOLD       20
#endif

#define PANEL_NAME		"panel"

unsigned int lcd_print_flag = 0;
unsigned int lcd_debug_flag = 0;
void lcd_print(const char *fmt, ...)
{
	va_list args;
	char printbuffer[CONFIG_SYS_PBSIZE];

	if (lcd_print_flag == 0)
		return;

	va_start(args, fmt);
	vsprintf(printbuffer, fmt, args);
	va_end(args);

	puts(printbuffer);
}

static const char* lcd_power_type_table[]={
	"cpu",
	"pmu",
	"signal",
	"init",
	"null",
};

static const char* lcd_power_pmu_gpio_table[]={
	"GPIO0",
	"GPIO1",
	"GPIO2",
	"GPIO3",
	"GPIO4",
	"null",
}; 

typedef struct {
	Lcd_Config_t *pConf;
	Lcd_Bl_Config_t *bl_config;
	vinfo_t lcd_info;
} lcd_dev_t;

static lcd_dev_t *pDev = NULL;
static char * dt_addr;
static int dts_ready = 0;

vidinfo_t panel_info = {
	.vl_col	=	0,		/* Number of columns (i.e. 160) */
	.vl_row	=	0,		/* Number of rows (i.e. 100) */

	.vl_bpix	=	0,				/* Bits per pixel */

	.vd_console_address	=	NULL,	/* Start of console buffer */
	.console_col	=	0,
	.console_row	=	0,

	.vd_color_fg	=	0,
	.vd_color_bg	=	0,
	.max_bl_level	=	255,

	.cmap	=	NULL,		/* Pointer to the colormap */

	.priv	=	NULL,		/* Pointer to driver-specific data */
};

static unsigned bl_level;

static Lcd_Bl_Config_t bl_config = {
	.level_default = BL_LEVEL_DFT,
	.level_mid = BL_LEVEL_MID_DFT,
	.level_mid_mapping = BL_LEVEL_MID_MAPPED_DFT,
	.level_min = BL_LEVEL_MIN_DFT,
	.level_max = BL_LEVEL_MAX_DFT,
};

#ifdef CONFIG_AML_BL_EXTERN
void get_bl_level(struct bl_extern_config_t *bl_ext_cfg)
{
    bl_ext_cfg->level_min = pDev->bl_config->level_min;
    bl_ext_cfg->level_max = pDev->bl_config->level_max;
}
#endif

static void lcd_backlight_power_ctrl(Bool_t status)
{
	int i;
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_t *bl_extern_driver;
	int ret;
#endif

	if( status == ON ) {
		mdelay(pDev->bl_config->power_on_delay);

		switch (pDev->bl_config->method) {
			case BL_CTL_GPIO:
#ifdef LED_PWM_REG0
				WRITE_LCD_CBUS_REG_BITS(LED_PWM_REG0, 1, 12, 2);
#endif
				mdelay(20);
				aml_lcd_gpio_set(pDev->bl_config->gpio, LCD_POWER_GPIO_OUTPUT_HIGH);
				break;
			case BL_CTL_PWM_NEGATIVE:
			case BL_CTL_PWM_POSITIVE:
				switch (pDev->bl_config->pwm_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, (READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~(0x7f<<8)) | ((1 << 15) | (pDev->bl_config->pwm_pre_div<<8) | (1<<0)));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, (READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~(0x7f<<16)) | ((1 << 23) | (pDev->bl_config->pwm_pre_div<<16) | (1<<1)));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, (READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~(0x7f<<8)) | ((1 << 15) | (pDev->bl_config->pwm_pre_div<<8) | (1<<0)));  //enable pwm clk & pwm output
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, (READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~(0x7f<<16)) | ((1 << 23) | (pDev->bl_config->pwm_pre_div<<16) | (1<<1)));  //enable pwm clk & pwm output
						break;
					default:
						break;
				}
				for (i=0; i<pDev->bl_config->pinmux_clr_num; i++) {
					clear_mio_mux(pDev->bl_config->pinmux_clr[i][0], pDev->bl_config->pinmux_clr[i][1]);
				}
				for (i=0; i<pDev->bl_config->pinmux_set_num; i++) {
					set_mio_mux(pDev->bl_config->pinmux_set[i][0], pDev->bl_config->pinmux_set[i][1]);
				}
				mdelay(20);
				if (pDev->bl_config->pwm_gpio_used)
					aml_lcd_gpio_set(pDev->bl_config->gpio, LCD_POWER_GPIO_OUTPUT_HIGH);
				break;
			case BL_CTL_PWM_COMBO:
				switch (pDev->bl_config->combo_high_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, (READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~(0x7f<<8)) | ((1 << 15) | (pDev->bl_config->combo_high_pre_div<<8) | (1<<0)));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, (READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~(0x7f<<16)) | ((1 << 23) | (pDev->bl_config->combo_high_pre_div<<16) | (1<<1)));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, (READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~(0x7f<<8)) | ((1 << 15) | (pDev->bl_config->combo_high_pre_div<<8) | (1<<0)));  //enable pwm clk & pwm output
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, (READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~(0x7f<<16)) | ((1 << 23) | (pDev->bl_config->combo_high_pre_div<<16) | (1<<1)));  //enable pwm clk & pwm output
						break;
					default:
						break;
				}
				switch (pDev->bl_config->combo_low_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, (READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~(0x7f<<8)) | ((1 << 15) | (pDev->bl_config->combo_low_pre_div<<8) | (1<<0)));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, (READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~(0x7f<<16)) | ((1 << 23) | (pDev->bl_config->combo_low_pre_div<<16) | (1<<1)));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, (READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~(0x7f<<8)) | ((1 << 15) | (pDev->bl_config->combo_low_pre_div<<8) | (1<<0)));  //enable pwm clk & pwm output
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, (READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~(0x7f<<16)) | ((1 << 23) | (pDev->bl_config->combo_low_pre_div<<16) | (1<<1)));  //enable pwm clk & pwm output
						break;
					default:
						break;
				}
				for (i=0; i<pDev->bl_config->pinmux_clr_num; i++) {
					clear_mio_mux(pDev->bl_config->pinmux_clr[i][0], pDev->bl_config->pinmux_clr[i][1]);
				}
				for (i=0; i<pDev->bl_config->pinmux_set_num; i++) {
					set_mio_mux(pDev->bl_config->pinmux_set[i][0], pDev->bl_config->pinmux_set[i][1]);
				}
				break;
			case BL_CTL_EXTERN:
#ifdef CONFIG_AML_BL_EXTERN
				bl_extern_driver = aml_bl_extern_get_driver();
				if (bl_extern_driver == NULL) {
					printf("no bl_extern driver\n");
				}
				else {
					if (bl_extern_driver->power_on) {
						ret = bl_extern_driver->power_on();
						if (ret) {
							printf("[bl_extern] power on error\n");
						}
					}
					else {
						printf("[bl_extern] power on is null\n");
					}
				}
#endif
				break;
			default:
				printf("Wrong backlight control method\n");
				break;
		}
	}
	else {
		switch (pDev->bl_config->method) {
			case BL_CTL_GPIO:
				aml_lcd_gpio_set(pDev->bl_config->gpio, LCD_POWER_GPIO_OUTPUT_LOW);
				break;
			case BL_CTL_PWM_NEGATIVE:
			case BL_CTL_PWM_POSITIVE:
				if (pDev->bl_config->pwm_gpio_used) {
					if (pDev->bl_config->gpio)
						aml_lcd_gpio_set(pDev->bl_config->gpio, LCD_POWER_GPIO_OUTPUT_LOW);
				}
				switch (pDev->bl_config->pwm_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~((1 << 15) | (1<<0)));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~((1 << 23) | (1<<1)));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~((1 << 15) | (1<<0)));  //disable pwm_clk & pwm port
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~((1 << 23) | (1<<1)));  //disable pwm_clk & pwm port
						break;
					default:
						break;
				}
				break;
			case BL_CTL_PWM_COMBO:
				switch (pDev->bl_config->combo_high_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~((1 << 15) | (1<<0)));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~((1 << 23) | (1<<1)));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~((1 << 15) | (1<<0)));  //disable pwm_clk & pwm port
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~((1 << 23) | (1<<1)));  //disable pwm_clk & pwm port
						break;
					default:
						break;
				}
				switch (pDev->bl_config->combo_low_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~((1 << 15) | (1<<0)));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_AB, READ_LCD_CBUS_REG(PWM_MISC_REG_AB) & ~((1 << 23) | (1<<1)));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~((1 << 15) | (1<<0)));  //disable pwm_clk & pwm port
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_MISC_REG_CD, READ_LCD_CBUS_REG(PWM_MISC_REG_CD) & ~((1 << 23) | (1<<1)));  //disable pwm_clk & pwm port
						break;
					default:
						break;
				}
				break;
			case BL_CTL_EXTERN:
#ifdef CONFIG_AML_BL_EXTERN
				bl_extern_driver = aml_bl_extern_get_driver();
				if (bl_extern_driver == NULL) {
					printf("no bl_extern driver\n");
				}
				else {
					if (bl_extern_driver->power_off) {
						ret = bl_extern_driver->power_off();
						if (ret) {
							printf("[bl_extern] power off error\n");
						}
					}
					else {
						printf("[bl_extern] power off is null\n");
					}
				}
#endif
				break;
			default:
				printf("Wrong backlight control method\n");
				break;
		}
	}
	printf("%s(): %s\n", __FUNCTION__, (status ? "ON" : "OFF"));
}

static void set_lcd_backlight_level(unsigned level)
{
	unsigned pwm_hi = 0, pwm_lo = 0;
#ifdef CONFIG_AML_BL_EXTERN
	struct aml_bl_extern_driver_t *bl_extern_driver;
	int ret;
#endif

	printf("set_backlight_level: %u, last level: %u\n", level, bl_level);
	level = (level > pDev->bl_config->level_max ? pDev->bl_config->level_max : (level < pDev->bl_config->level_min ? pDev->bl_config->level_min : level));
	bl_level = level;

	//mapping
	if (level > pDev->bl_config->level_mid)
		level = ((level - pDev->bl_config->level_mid) * (pDev->bl_config->level_max - pDev->bl_config->level_mid_mapping)) / (pDev->bl_config->level_max - pDev->bl_config->level_mid) + pDev->bl_config->level_mid_mapping;
	else
		level = ((level - pDev->bl_config->level_min) * (pDev->bl_config->level_mid_mapping - pDev->bl_config->level_min)) / (pDev->bl_config->level_mid - pDev->bl_config->level_min) + pDev->bl_config->level_min;

	switch (pDev->bl_config->method) {
		case BL_CTL_GPIO:
			level = pDev->bl_config->dim_min - ((level - pDev->bl_config->level_min) * (pDev->bl_config->dim_min - pDev->bl_config->dim_max)) / (pDev->bl_config->level_max - pDev->bl_config->level_min);
			WRITE_LCD_CBUS_REG_BITS(LED_PWM_REG0, level, 0, 4);
			break;
		case BL_CTL_PWM_NEGATIVE:
		case BL_CTL_PWM_POSITIVE:
			level = (pDev->bl_config->pwm_max - pDev->bl_config->pwm_min) * (level - pDev->bl_config->level_min) / (pDev->bl_config->level_max - pDev->bl_config->level_min) + pDev->bl_config->pwm_min;
			if (pDev->bl_config->method == BL_CTL_PWM_POSITIVE) {
				pwm_hi = level;
				pwm_lo = pDev->bl_config->pwm_cnt - level;
			}
			else if (pDev->bl_config->method == BL_CTL_PWM_NEGATIVE) {
				pwm_hi = pDev->bl_config->pwm_cnt - level;
				pwm_lo = level;
			}

			switch (pDev->bl_config->pwm_port) {
				case BL_PWM_A:
					WRITE_LCD_CBUS_REG(PWM_PWM_A, (pwm_hi << 16) | (pwm_lo));
					break;
				case BL_PWM_B:
					WRITE_LCD_CBUS_REG(PWM_PWM_B, (pwm_hi << 16) | (pwm_lo));
					break;
				case BL_PWM_C:
					WRITE_LCD_CBUS_REG(PWM_PWM_C, (pwm_hi << 16) | (pwm_lo));
					break;
				case BL_PWM_D:
					WRITE_LCD_CBUS_REG(PWM_PWM_D, (pwm_hi << 16) | (pwm_lo));
					break;
				default:
					break;
			}
			break;
		case BL_CTL_PWM_COMBO:
			if (level >= pDev->bl_config->combo_level_switch) {
				//pre_set combo_low duty max
				if (pDev->bl_config->combo_low_method == BL_CTL_PWM_NEGATIVE) {
					pwm_hi = pDev->bl_config->combo_low_cnt - pDev->bl_config->combo_low_duty_max;
					pwm_lo = pDev->bl_config->combo_low_duty_max;
				}
				else {
					pwm_hi = pDev->bl_config->combo_low_duty_max;
					pwm_lo = pDev->bl_config->combo_low_cnt - pDev->bl_config->combo_low_duty_max;
				}
				switch (pDev->bl_config->combo_low_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_PWM_A, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_PWM_B, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_PWM_C, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_PWM_D, (pwm_hi << 16) | (pwm_lo));
						break;
					default:
						break;
				}

				//set combo_high duty
				level = (pDev->bl_config->combo_high_duty_max - pDev->bl_config->combo_high_duty_min) * (level - pDev->bl_config->combo_level_switch) / (pDev->bl_config->level_max - pDev->bl_config->combo_level_switch) + pDev->bl_config->combo_high_duty_min;
				if (pDev->bl_config->combo_high_method == BL_CTL_PWM_NEGATIVE) {
					pwm_hi = pDev->bl_config->combo_high_cnt - level;
					pwm_lo = level;
				}
				else {
					pwm_hi = level;
					pwm_lo = pDev->bl_config->combo_high_cnt - level;
				}
				switch (pDev->bl_config->combo_high_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_PWM_A, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_PWM_B, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_PWM_C, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_PWM_D, (pwm_hi << 16) | (pwm_lo));
						break;
					default:
						break;
				}
			}
			else {
				//pre_set combo_high duty min
				if (pDev->bl_config->combo_high_method == BL_CTL_PWM_NEGATIVE) {
					pwm_hi = pDev->bl_config->combo_high_cnt - pDev->bl_config->combo_high_duty_min;
					pwm_lo = pDev->bl_config->combo_high_duty_min;
				}
				else {
					pwm_hi = pDev->bl_config->combo_high_duty_min;;
					pwm_lo = pDev->bl_config->combo_high_cnt - pDev->bl_config->combo_high_duty_min;
				}
				switch (pDev->bl_config->combo_high_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_PWM_A, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_PWM_B, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_PWM_C, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_PWM_D, (pwm_hi << 16) | (pwm_lo));
						break;
					default:
						break;
				}

				//set combo_low duty
				level = (pDev->bl_config->combo_low_duty_max - pDev->bl_config->combo_low_duty_min) * (level - pDev->bl_config->level_min) / (pDev->bl_config->combo_level_switch - pDev->bl_config->level_min) + pDev->bl_config->combo_low_duty_min;
				if (pDev->bl_config->combo_low_method == BL_CTL_PWM_NEGATIVE) {
					pwm_hi = pDev->bl_config->combo_low_cnt - level;
					pwm_lo = level;
				}
				else {
					pwm_hi = level;
					pwm_lo = pDev->bl_config->combo_low_cnt - level;
				}
				switch (pDev->bl_config->combo_low_port) {
					case BL_PWM_A:
						WRITE_LCD_CBUS_REG(PWM_PWM_A, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_B:
						WRITE_LCD_CBUS_REG(PWM_PWM_B, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_C:
						WRITE_LCD_CBUS_REG(PWM_PWM_C, (pwm_hi << 16) | (pwm_lo));
						break;
					case BL_PWM_D:
						WRITE_LCD_CBUS_REG(PWM_PWM_D, (pwm_hi << 16) | (pwm_lo));
						break;
					default:
						break;
				}
			}
			break;
		case BL_CTL_EXTERN:
#ifdef CONFIG_AML_BL_EXTERN
			bl_extern_driver = aml_bl_extern_get_driver();
			if (bl_extern_driver == NULL) {
				printf("no bl_extern driver\n");
			}
			else {
				if (bl_extern_driver->set_level) {
					ret = bl_extern_driver->set_level(level);
					if (ret) {
						printf("[bl_extern] set_level error\n");
					}
				}
				else {
					printf("[bl_extern] set_level is null\n");
				}
			}
#endif
			break;
		default:
			break;
	}
}

static unsigned get_lcd_backlight_level(void)
{
    lcd_print("%s :%d\n", __FUNCTION__, bl_level);
    return bl_level;
}

static int lcd_power_ctrl(Bool_t status)
{
	int i;
	int ret = 0;
#ifdef CONFIG_PLATFORM_HAS_PMU
	struct aml_pmu_driver *pmu_driver;
#endif
#ifdef CONFIG_AML_LCD_EXTERN
	struct aml_lcd_extern_driver_t *lcd_extern_driver;
#endif

	lcd_print("%s(): %s\n", __FUNCTION__, (status ? "ON" : "OFF"));
	if (status) {
		if (pDev->pConf->lcd_power_ctrl.power_on_uboot.type < LCD_POWER_TYPE_MAX) {
			lcd_print("lcd_power_on_uboot\n");
			switch (pDev->pConf->lcd_power_ctrl.power_on_uboot.type) {
				case LCD_POWER_TYPE_CPU:
					aml_lcd_gpio_set(pDev->pConf->lcd_power_ctrl.power_on_uboot.gpio, pDev->pConf->lcd_power_ctrl.power_on_uboot.value);
					break;
				case LCD_POWER_TYPE_PMU:
#ifdef CONFIG_PLATFORM_HAS_PMU
					pmu_driver = aml_pmu_get_driver();
					if (pmu_driver == NULL) {
						printf("no pmu driver\n");
					}
					else if (pmu_driver->pmu_set_gpio) {
						if (pDev->pConf->lcd_power_ctrl.power_on_uboot.value == LCD_POWER_GPIO_OUTPUT_LOW) {
							pmu_driver->pmu_set_gpio(pDev->pConf->lcd_power_ctrl.power_on_uboot.gpio, 0);
						}
						else {
							pmu_driver->pmu_set_gpio(pDev->pConf->lcd_power_ctrl.power_on_uboot.gpio, 1);
						}
					}
#endif
					break;
				default:
					break;
			}
			if (pDev->pConf->lcd_power_ctrl.power_on_uboot.delay > 0)
				mdelay(pDev->pConf->lcd_power_ctrl.power_on_uboot.delay);
		}
		for (i=0; i<pDev->pConf->lcd_power_ctrl.power_on_step; i++) {
			lcd_print("%s %s step %d\n", __FUNCTION__, (status ? "ON" : "OFF"), i+1);
			switch (pDev->pConf->lcd_power_ctrl.power_on_config[i].type) {
				case LCD_POWER_TYPE_CPU:
					aml_lcd_gpio_set(pDev->pConf->lcd_power_ctrl.power_on_config[i].gpio, pDev->pConf->lcd_power_ctrl.power_on_config[i].value);
					break;
				case LCD_POWER_TYPE_PMU:
#ifdef CONFIG_PLATFORM_HAS_PMU
					pmu_driver = aml_pmu_get_driver();
					if (pmu_driver == NULL) {
						printf("no pmu driver\n");
					}
					else if (pmu_driver->pmu_set_gpio) {
						if (pDev->pConf->lcd_power_ctrl.power_on_config[i].value == LCD_POWER_GPIO_OUTPUT_LOW) {
							pmu_driver->pmu_set_gpio(pDev->pConf->lcd_power_ctrl.power_on_config[i].gpio, 0);
						}
						else {
							pmu_driver->pmu_set_gpio(pDev->pConf->lcd_power_ctrl.power_on_config[i].gpio, 1);
						}
					}
#endif
					break;
				case LCD_POWER_TYPE_SIGNAL:
					pDev->pConf->lcd_power_ctrl.ports_ctrl(ON);
					break;
				case LCD_POWER_TYPE_INITIAL:
#ifdef CONFIG_AML_LCD_EXTERN
					lcd_extern_driver = aml_lcd_extern_get_driver();
					if (lcd_extern_driver == NULL) {
						printf("no lcd_extern driver\n");
					}
					else {
						if (lcd_extern_driver->power_on)
							lcd_extern_driver->power_on();
						lcd_print("%s power on\n", lcd_extern_driver->name);
					}
#endif
					break;
				default:
					printf("lcd power ctrl ON step %d is null.\n", i+1);
					break;
			}
			if (pDev->pConf->lcd_power_ctrl.power_on_config[i].delay > 0)
				mdelay(pDev->pConf->lcd_power_ctrl.power_on_config[i].delay);
		}
		if (pDev->pConf->lcd_power_ctrl.power_ctrl_video)
			ret = pDev->pConf->lcd_power_ctrl.power_ctrl_video(ON);
	}
	else {
		mdelay(30);
		if (pDev->pConf->lcd_power_ctrl.power_ctrl_video)
			ret = pDev->pConf->lcd_power_ctrl.power_ctrl_video(OFF);
		for (i=0; i<pDev->pConf->lcd_power_ctrl.power_off_step; i++) {
			lcd_print("%s %s step %d\n", __FUNCTION__, (status ? "ON" : "OFF"), i+1);
			switch (pDev->pConf->lcd_power_ctrl.power_off_config[i].type) {
				case LCD_POWER_TYPE_CPU:
					aml_lcd_gpio_set(pDev->pConf->lcd_power_ctrl.power_off_config[i].gpio, pDev->pConf->lcd_power_ctrl.power_off_config[i].value);
					break;
				case LCD_POWER_TYPE_PMU:
#ifdef CONFIG_PLATFORM_HAS_PMU
					pmu_driver = aml_pmu_get_driver();
					if (pmu_driver == NULL) {
						printf("no pmu driver\n");
					}
					else if (pmu_driver->pmu_set_gpio) {
						if (pDev->pConf->lcd_power_ctrl.power_off_config[i].value == LCD_POWER_GPIO_OUTPUT_LOW) {
							pmu_driver->pmu_set_gpio(pDev->pConf->lcd_power_ctrl.power_off_config[i].gpio, 0);
						}
						else {
							pmu_driver->pmu_set_gpio(pDev->pConf->lcd_power_ctrl.power_off_config[i].gpio, 1);
						}
					}
#endif
					break;
				case LCD_POWER_TYPE_SIGNAL:
					pDev->pConf->lcd_power_ctrl.ports_ctrl(OFF);
					break;
				case LCD_POWER_TYPE_INITIAL:
#ifdef CONFIG_AML_LCD_EXTERN
					lcd_extern_driver = aml_lcd_extern_get_driver();
					if (lcd_extern_driver == NULL) {
						printf("no lcd_extern driver\n");
					}
					else {
						if (lcd_extern_driver->power_off)
							lcd_extern_driver->power_off();
						lcd_print("%s power off\n", lcd_extern_driver->name);
					}
#endif
					break;
				default:
					printf("lcd power ctrl OFF step %d is null.\n", i+1);
					break;
			}
			if (pDev->pConf->lcd_power_ctrl.power_off_config[i].delay > 0)
				mdelay(pDev->pConf->lcd_power_ctrl.power_off_config[i].delay);
		}
		if (pDev->pConf->lcd_power_ctrl.power_off_uboot.type < LCD_POWER_TYPE_MAX) {
			lcd_print("lcd_power_off_uboot\n");
			switch (pDev->pConf->lcd_power_ctrl.power_off_uboot.type) {
				case LCD_POWER_TYPE_CPU:
					aml_lcd_gpio_set(pDev->pConf->lcd_power_ctrl.power_off_uboot.gpio, pDev->pConf->lcd_power_ctrl.power_off_uboot.value);
					break;
				case LCD_POWER_TYPE_PMU:
#ifdef CONFIG_PLATFORM_HAS_PMU
					pmu_driver = aml_pmu_get_driver();
					if (pmu_driver == NULL) {
						printf("no pmu driver\n");
					}
					else if (pmu_driver->pmu_set_gpio) {
						if (pDev->pConf->lcd_power_ctrl.power_off_uboot.value == LCD_POWER_GPIO_OUTPUT_LOW) {
							pmu_driver->pmu_set_gpio(pDev->pConf->lcd_power_ctrl.power_off_uboot.gpio, 0);
						}
						else {
							pmu_driver->pmu_set_gpio(pDev->pConf->lcd_power_ctrl.power_off_uboot.gpio, 1);
						}
					}
#endif
					break;
				default:
					break;
			}
			if (pDev->pConf->lcd_power_ctrl.power_off_uboot.delay > 0)
				mdelay(pDev->pConf->lcd_power_ctrl.power_off_uboot.delay);
		}
	}
	printf("%s(): %s finished.\n", __FUNCTION__, (status ? "ON" : "OFF"));
	return ret;
}


static int lcd_set_current_vmode(vmode_t mode)
{
	if (mode != VMODE_LCD)
		return -1;
	
	WRITE_LCD_REG(VPP_POSTBLEND_H_SIZE, pDev->lcd_info.width);
	pDev->pConf->lcd_misc_ctrl.module_enable();
	if (VMODE_INIT_NULL == pDev->lcd_info.mode)
		pDev->lcd_info.mode = VMODE_LCD;
	else
		lcd_backlight_power_ctrl(ON);
	return 0;
}

static void _init_vout(lcd_dev_t *pDev)
{
    pDev->lcd_info.name = PANEL_NAME;
    pDev->lcd_info.mode = VMODE_INIT_NULL;
    pDev->lcd_info.width = pDev->pConf->lcd_basic.h_active;
    pDev->lcd_info.height = pDev->pConf->lcd_basic.v_active;
    pDev->lcd_info.field_height = pDev->pConf->lcd_basic.v_active;
    pDev->lcd_info.aspect_ratio_num = pDev->pConf->lcd_basic.screen_ratio_width;
    pDev->lcd_info.aspect_ratio_den = pDev->pConf->lcd_basic.screen_ratio_height;
    pDev->lcd_info.screen_real_width= pDev->pConf->lcd_basic.h_active_area;
    pDev->lcd_info.screen_real_height= pDev->pConf->lcd_basic.v_active_area;
    pDev->lcd_info.sync_duration_num = pDev->pConf->lcd_timing.sync_duration_num;
    pDev->lcd_info.sync_duration_den = pDev->pConf->lcd_timing.sync_duration_den;
}

static void _lcd_init(Lcd_Config_t *pConf)
{
#ifdef CONFIG_PLATFORM_HAS_PMU
	struct aml_pmu_driver *pmu_driver;
	int battery_percent;
#endif

	lcd_config_init(pConf);
if (pDev->bl_config->level_default == pDev->bl_config->level_min) {
		set_lcd_backlight_level(pDev->bl_config->level_min);
	}
	else {
#ifdef CONFIG_PLATFORM_HAS_PMU
		/* if battery percentage is very low, set backlight level as low as possible  */
		pmu_driver = aml_pmu_get_driver();
		if (pmu_driver && pmu_driver->pmu_get_battery_capacity) {
			battery_percent = pmu_driver->pmu_get_battery_capacity();
			if (battery_percent <= BATTERY_LOW_THRESHOLD) {
				set_lcd_backlight_level(pDev->bl_config->level_min + battery_percent + 10);
			} else {
				set_lcd_backlight_level(pDev->bl_config->level_default);
			}
		} else {
			set_lcd_backlight_level(pDev->bl_config->level_default);
		}
#else
		set_lcd_backlight_level(pDev->bl_config->level_default);
#endif
	}

	_init_vout(pDev);
	lcd_set_current_vmode(VMODE_LCD);
}

static void lcd_setup_gamma_table(Lcd_Config_t *pConf, unsigned int rgb_flag)
{
	int i;
	
	const unsigned short gamma_adjust[256] = {
		0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,
		32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,
		64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,
		96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,
		128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
		160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
		192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
		224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
	};

	if (rgb_flag == 0) {	//r
		for (i=0; i<256; i++) {
			pConf->lcd_effect.GammaTableR[i] = gamma_adjust[i] << 2;
		}
	}
	else if (rgb_flag == 1) {	//g
		for (i=0; i<256; i++) {
			pConf->lcd_effect.GammaTableG[i] = gamma_adjust[i] << 2;
		}
	}
	else if (rgb_flag == 2) {	//b
		for (i=0; i<256; i++) {
			pConf->lcd_effect.GammaTableB[i] = gamma_adjust[i] << 2;
		}
	}
	else if (rgb_flag == 3) {	//rgb
		for (i=0; i<256; i++) {
			pConf->lcd_effect.GammaTableR[i] = gamma_adjust[i] << 2;
			pConf->lcd_effect.GammaTableG[i] = gamma_adjust[i] << 2;
			pConf->lcd_effect.GammaTableB[i] = gamma_adjust[i] << 2;
		}
	}
}

static int aml_lcd_pmu_gpio_name_map_num(const char *name)
{
	int index;
	
	for(index = 0; index < LCD_POWER_PMU_GPIO_MAX; index++) {
		if(!strcmp(name, lcd_power_pmu_gpio_table[index]))
			break;
	}
	return index;
}

#ifdef CONFIG_OF_LIBFDT
#define LCD_MODEL_LEN_MAX    30
static int _get_lcd_model_timing(Lcd_Config_t *pConf)
{
	int ret=0;
	int nodeoffset;
	char* lcd_model;
	char* propdata;
	char propname[LCD_MODEL_LEN_MAX];
	int i, j;
	
	nodeoffset = fdt_path_offset(dt_addr, "/lcd");
	if(nodeoffset < 0) {
		printf("dts: not find /lcd node %s.\n",fdt_strerror(nodeoffset));
		return ret;
	}
	
	lcd_model = fdt_getprop(dt_addr, nodeoffset, "lcd_model_name", NULL);
	sprintf(propname, "/%s", lcd_model);
	nodeoffset = fdt_path_offset(dt_addr, propname);
	if(nodeoffset < 0) {
		printf("dts: not find %s node %s.\n", propname, fdt_strerror(nodeoffset));
		return ret;
	}
	
	lcd_model = fdt_getprop(dt_addr, nodeoffset, "model_name", NULL);
	if (lcd_model == NULL) {
		printf("faild to get model_name\n");
		lcd_model = PANEL_MODEL_DEFAULT;
	}
	pConf->lcd_basic.model_name = (char *)malloc(sizeof(char)*LCD_MODEL_LEN_MAX);
	if (pConf->lcd_basic.model_name == NULL) {
		printf("[_get_lcd_model_timing]: Not enough memory\n");
	}
	else {
		memset(pConf->lcd_basic.model_name, 0, LCD_MODEL_LEN_MAX);
		strcpy(pConf->lcd_basic.model_name, lcd_model);
		printf("\nload lcd model in dtb: %s\n", pConf->lcd_basic.model_name);
	}
	
	propdata = fdt_getprop(dt_addr, nodeoffset, "interface", NULL);
	if (propdata == NULL) {
		printf("faild to get lcd_type!\n");
		pConf->lcd_basic.lcd_type = LCD_TYPE_MAX;
	}
	else {
		for(i = 0; i < LCD_TYPE_MAX; i++) {
			if(!strncmp(propdata, lcd_type_table_match[i], 3))
				break;
		}
		pConf->lcd_basic.lcd_type = i;
	}
	lcd_print("lcd_type = %s(%u)\n", lcd_type_table[pConf->lcd_basic.lcd_type], pConf->lcd_basic.lcd_type);
	propdata = fdt_getprop(dt_addr, nodeoffset, "active_area", NULL);
	if(propdata == NULL){
		printf("faild to get active_area\n");
	}
	else {
		pConf->lcd_basic.h_active_area = be32_to_cpup((u32*)propdata);
		pConf->lcd_basic.v_active_area = be32_to_cpup((((u32*)propdata)+1));
		pConf->lcd_basic.screen_ratio_width = be32_to_cpup((u32*)propdata);
		pConf->lcd_basic.screen_ratio_height = be32_to_cpup((((u32*)propdata)+1));
	}
	lcd_print("h_active_area = %umm, v_active_area = %umm\n", pConf->lcd_basic.h_active_area, pConf->lcd_basic.v_active_area);
	propdata = fdt_getprop(dt_addr, nodeoffset, "lcd_bits_option", NULL);
	if(propdata == NULL){
		printf("faild to get lcd_bits_option\n");
	}
	else {
		pConf->lcd_basic.lcd_bits = (unsigned short)(be32_to_cpup((u32*)propdata));
		pConf->lcd_basic.lcd_bits_option = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
	}
	lcd_print("lcd_bits = %u, lcd_bits_option = %u\n", pConf->lcd_basic.lcd_bits, pConf->lcd_basic.lcd_bits_option);
	
	propdata = fdt_getprop(dt_addr, nodeoffset, "resolution", NULL);
	if(propdata == NULL){
		printf("faild to get resolution\n");
	}
	else {
		pConf->lcd_basic.h_active = (unsigned short)(be32_to_cpup((u32*)propdata));
		pConf->lcd_basic.v_active = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
	}
	propdata = fdt_getprop(dt_addr, nodeoffset, "period", NULL);
	if(propdata == NULL){
		printf("faild to get period\n");
	}
	else {
		pConf->lcd_basic.h_period = (unsigned short)(be32_to_cpup((u32*)propdata));
		pConf->lcd_basic.v_period = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
	}
	lcd_print("h_active = %u, v_active =%u, h_period = %u, v_period = %u\n", pConf->lcd_basic.h_active, pConf->lcd_basic.v_active, pConf->lcd_basic.h_period, pConf->lcd_basic.v_period);
	
	propdata = fdt_getprop(dt_addr, nodeoffset, "clock_hz_pol", NULL);
	if(propdata == NULL){
		printf("faild to get clock_hz_pol\n");
	}
	else {
		pConf->lcd_timing.lcd_clk = be32_to_cpup((u32*)propdata);
		pConf->lcd_timing.pol_ctrl = (be32_to_cpup((((u32*)propdata)+1)) << POL_CTRL_CLK);
	}
	lcd_print("pclk = %uHz, pol=%u\n", pConf->lcd_timing.lcd_clk, (pConf->lcd_timing.pol_ctrl >> POL_CTRL_CLK) & 1);
	propdata = fdt_getprop(dt_addr, nodeoffset, "hsync_width_backporch", NULL);
	if(propdata == NULL){
		printf("faild to get hsync_width_backporch\n");
	}
	else {
		pConf->lcd_timing.hsync_width = (unsigned short)(be32_to_cpup((u32*)propdata));
		pConf->lcd_timing.hsync_bp = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
	}
	lcd_print("hsync width = %u, backporch = %u\n", pConf->lcd_timing.hsync_width, pConf->lcd_timing.hsync_bp);
	propdata = fdt_getprop(dt_addr, nodeoffset, "vsync_width_backporch", NULL);
	if(propdata == NULL){
		printf("faild to get vsync_width_backporch\n");
	}
	else {
		pConf->lcd_timing.vsync_width = (unsigned short)(be32_to_cpup((u32*)propdata));
		pConf->lcd_timing.vsync_bp = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
	}
	lcd_print("vsync width = %u, backporch = %u\n", pConf->lcd_timing.vsync_width, pConf->lcd_timing.vsync_bp);
	propdata = fdt_getprop(dt_addr, nodeoffset, "pol_hsync_vsync", NULL);
	if(propdata == NULL){
		printf("faild to get pol_hsync_vsync\n");
	}
	else {
		pConf->lcd_timing.pol_ctrl = (pConf->lcd_timing.pol_ctrl & ~((1 << POL_CTRL_HS) | (1 << POL_CTRL_VS))) | ((be32_to_cpup((u32*)propdata) << POL_CTRL_HS) | (be32_to_cpup((((u32*)propdata)+1)) << POL_CTRL_VS));
	}
	lcd_print("pol hsync = %u, vsync = %u\n", (pConf->lcd_timing.pol_ctrl >> POL_CTRL_HS) & 1, (pConf->lcd_timing.pol_ctrl >> POL_CTRL_VS) & 1);
	
	propdata = fdt_getprop(dt_addr, nodeoffset, "vsync_horizontal_phase", NULL);
		if(propdata == NULL){
		printf("faild to get vsync_horizontal_phase\n");
		pConf->lcd_timing.vsync_h_phase =0;
	}
	else {
		pConf->lcd_timing.vsync_h_phase = ((((be32_to_cpup((u32*)propdata)) & 0x1) << 31) | (((be32_to_cpup((((u32*)propdata)+1)))&0xffff) << 0));
	}
	lcd_print("vsync_h_phase = %u, sign = %u\n", (pConf->lcd_timing.vsync_h_phase&0xffff),(pConf->lcd_timing.vsync_h_phase>>31));

	if (pConf->lcd_basic.lcd_type == LCD_DIGITAL_MIPI) {
		DSI_Config_t *cfg = pConf->lcd_control.mipi_config;
		propdata = fdt_getprop(dt_addr, nodeoffset, "dsi_lane_num", NULL);
		if(propdata == NULL){
			printf("faild to get dsi_lane_num\n");
			cfg->lane_num = 4;
		} else {
			cfg->lane_num = (unsigned char)(be32_to_cpup((u32*)propdata));
		}
		lcd_print("dsi_lane_num= %d\n",  cfg->lane_num);
		propdata = fdt_getprop(dt_addr, nodeoffset, "dsi_bit_rate_max", NULL);
		if(propdata == NULL){
			printf("faild to get dsi_bit_rate_max\n");
			cfg->bit_rate_max = 0;
		} 
		else {
			cfg->bit_rate_max = (be32_to_cpup((u32*)propdata));
		}
		lcd_print("dsi bit_rate max = %dMHz\n", cfg->bit_rate_max);
		propdata = fdt_getprop(dt_addr, nodeoffset, "pclk_lanebyteclk_factor", NULL);
		if(propdata == NULL){
			printf("faild to get pclk_lanebyteclk_factor\n");
			cfg->factor_numerator = 0;
		} 
		else {
			 cfg->factor_numerator= (be32_to_cpup((u32*)propdata));
		}
		cfg->factor_denominator = 10;
		lcd_print("pclk_lanebyteclk factor = %d\n", cfg->factor_numerator);
		propdata = fdt_getprop(dt_addr, nodeoffset, "dsi_operation_mode", NULL);
		if(propdata == NULL){
			printf("faild to get dsi_operation_mode\n");
			 cfg->operation_mode = ((1 << BIT_OPERATION_MODE_INIT) | (0 << BIT_OPERATION_MODE_DISP));
		} 
		else {
			cfg->operation_mode= (((be32_to_cpup((u32*)propdata)) << BIT_OPERATION_MODE_INIT) | ((be32_to_cpup((((u32*)propdata)+1))) << BIT_OPERATION_MODE_DISP));
		}
		lcd_print("dsi_operation_mode init=%d, display=%d\n", ((cfg->operation_mode>>BIT_OPERATION_MODE_INIT) & 1), ((cfg->operation_mode>>BIT_OPERATION_MODE_DISP) & 1));
		propdata = fdt_getprop(dt_addr, nodeoffset, "dsi_transfer_ctrl", NULL);
		if(propdata == NULL){
			printf("faild to get dsi_transfer_ctrl\n");
			 cfg->transfer_ctrl = ((0 << BIT_TRANS_CTRL_CLK) | (0 << BIT_TRANS_CTRL_SWITCH));
		} 
		else {
			cfg->transfer_ctrl= (((be32_to_cpup((u32*)propdata)) << BIT_TRANS_CTRL_CLK) | ((be32_to_cpup((((u32*)propdata)+1))) << BIT_TRANS_CTRL_SWITCH));
		}
		lcd_print("dsi_transfer_ctrl clk=%d, switch=%d\n", ((cfg->transfer_ctrl>>BIT_TRANS_CTRL_CLK) & 1), ((cfg->transfer_ctrl>>BIT_TRANS_CTRL_SWITCH) & 1));
		//detect dsi init on table
		if (pConf->lcd_control.mipi_config->dsi_init_on != NULL) {
			propdata = fdt_getprop(dt_addr, nodeoffset, "dsi_init_on", NULL);
			if(propdata == NULL){
				printf("faild to get dsi_init_on\n");
			}
			else {
				i = 0;
				while(i < DSI_INIT_ON_MAX) {
					if ((be32_to_cpup((((u32*)propdata)+i))) == 0xff) {
						if ((be32_to_cpup((((u32*)propdata)+i+1))) == 0xff) {
							i += 2;
							break;
						}
						i += 2;
					}
					else {
						i = i + 3 + (be32_to_cpup((((u32*)propdata)+i+2)));
					}
				}
				lcd_print("dsi_init_on: ");
				for (j=0; j<i; j++) {
					cfg->dsi_init_on[j] = (be32_to_cpup((((u32*)propdata)+j)));
					lcd_print("0x%02x ", cfg->dsi_init_on[j]);
				}
				lcd_print("\n");
			}
		}
		//detect dsi init off table
		if (pConf->lcd_control.mipi_config->dsi_init_off != NULL) {
			propdata = fdt_getprop(dt_addr, nodeoffset, "dsi_init_off", NULL);
			if(propdata == NULL){
				printf("faild to get dsi_init_off\n");
			}
			else {
				i = 0;
				while(i < DSI_INIT_OFF_MAX) {
					if ((be32_to_cpup((((u32*)propdata)+i))) == 0xff) {
						if ((be32_to_cpup((((u32*)propdata)+i+1))) == 0xff) {
							i += 2;
							break;
						}
						i += 2;
					}
					else {
						i = i + 3 + (be32_to_cpup((((u32*)propdata)+i+2)));
					}
				}
				lcd_print("dsi_init_off: ");
				for (j=0; j<i; j++) {
					cfg->dsi_init_off[j] = (be32_to_cpup((((u32*)propdata)+j)));
					lcd_print("0x%02x ", cfg->dsi_init_off[j]);
				}
				lcd_print("\n");
			}
		}
		propdata = fdt_getprop(dt_addr, nodeoffset, "lcd_extern_init", NULL);
		if(propdata == NULL){
			printf("faild to get lcd_extern_init\n");
			cfg->lcd_extern_init = 0;
		}
		else {
			cfg->lcd_extern_init = (unsigned char)(be32_to_cpup((u32*)propdata));
		}
		lcd_print("lcd_extern_init = %d\n", cfg->lcd_extern_init);
	}
	else if (pConf->lcd_basic.lcd_type == LCD_DIGITAL_EDP) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "max_lane_count", NULL);
		if(propdata == NULL){
			printf("faild to get max_lane_count\n");
			pConf->lcd_control.edp_config->max_lane_count = 4;
		}
		else {
			pConf->lcd_control.edp_config->max_lane_count = (unsigned char)(be32_to_cpup((u32*)propdata));
		}
		lcd_print("max_lane_count = %d\n", pConf->lcd_control.edp_config->max_lane_count);
	}

	return ret;
}

static int _get_lcd_default_config(Lcd_Config_t *pConf)
{
	int ret=0;
	int nodeoffset;
	char * propdata;
	int i;
	unsigned int lcd_gamma_multi = 0;
	
	nodeoffset = fdt_path_offset(dt_addr, "/lcd");
	if(nodeoffset < 0) {
		printf("lcd driver init: not find /lcd node %s.\n",fdt_strerror(nodeoffset));
		return ret;
	}
	
	if (pConf->lcd_basic.lcd_bits_option == 1) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "lcd_bits_user", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match lcd_bits_user, use panel typical setting.\n");
		}
		else {
			pConf->lcd_basic.lcd_bits = (unsigned short)(be32_to_cpup((u32*)propdata));
			printf("lcd_bits = %u\n", pConf->lcd_basic.lcd_bits);
		}
	}
	
	//hardware design config
	if (pConf->lcd_basic.lcd_type == LCD_DIGITAL_TTL) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "ttl_rb_bit_swap", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match ttl_rb_bit_swap, use default setting.\n");
		}
		else {
			pConf->lcd_control.ttl_config->rb_swap = (unsigned char)(be32_to_cpup((u32*)propdata));
			pConf->lcd_control.ttl_config->bit_swap = (unsigned char)(be32_to_cpup((((u32*)propdata)+1)));
			printf("ttl rb_swap = %u, bit_swap = %u\n", pConf->lcd_control.ttl_config->rb_swap, pConf->lcd_control.ttl_config->bit_swap);
		}
	}
	if (pConf->lcd_basic.lcd_type == LCD_DIGITAL_LVDS) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "lvds_channel_pn_swap", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match lvds_channel_pn_swap, use default setting.\n");
		}
		else {
			pConf->lcd_control.lvds_config->pn_swap = be32_to_cpup((u32*)propdata);
			printf("lvds_pn_swap = %u\n", pConf->lcd_control.lvds_config->pn_swap);
		}
	}
	
	//recommend setting
	propdata = fdt_getprop(dt_addr, nodeoffset, "valid_hvsync_de", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match valid_hvsync_de, use default setting.\n");
	}
	else {
		pConf->lcd_timing.hvsync_valid = (unsigned short)(be32_to_cpup((u32*)propdata));
		pConf->lcd_timing.de_valid = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
		lcd_print("valid hvsync = %u, de = %u\n", pConf->lcd_timing.hvsync_valid, pConf->lcd_timing.de_valid);
	}
	propdata = fdt_getprop(dt_addr, nodeoffset, "hsign_hoffset_vsign_voffset", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match hsign_hoffset_vsign_voffset, use default setting.\n");
		pConf->lcd_timing.h_offset = 0;
		pConf->lcd_timing.v_offset = 0;
	}
	else {
		pConf->lcd_timing.h_offset = ((be32_to_cpup((u32*)propdata) << 31) | ((be32_to_cpup((((u32*)propdata)+1)) & 0xffff) << 0));
		pConf->lcd_timing.v_offset = ((be32_to_cpup((((u32*)propdata)+2)) << 31) | ((be32_to_cpup((((u32*)propdata)+3)) & 0xffff) << 0));
		lcd_print("h_offset = %s%u, ", (((pConf->lcd_timing.h_offset >> 31) & 1) ? "-" : ""), (pConf->lcd_timing.h_offset & 0xffff));
		lcd_print("v_offset = %s%u\n", (((pConf->lcd_timing.v_offset >> 31) & 1) ? "-" : ""), (pConf->lcd_timing.v_offset & 0xffff));
	}	
	propdata = fdt_getprop(dt_addr, nodeoffset, "dither_user_ctrl", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match dither_user_ctrl, use default setting.\n");
	}
	else {
		pConf->lcd_effect.dith_user = (unsigned short)(be32_to_cpup((u32*)propdata));
		pConf->lcd_effect.dith_cntl_addr = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
		lcd_print("dither_user = %u, dither_ctrl = 0x%x\n", pConf->lcd_effect.dith_user, pConf->lcd_effect.dith_cntl_addr);
	}
	propdata = fdt_getprop(dt_addr, nodeoffset, "vadj_brightness_contrast_saturation", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match vadj_brightness_contrast_saturation, use default setting.\n");
	}
	else {
		pConf->lcd_effect.vadj_brightness = be32_to_cpup((u32*)propdata);
		pConf->lcd_effect.vadj_contrast = be32_to_cpup((((u32*)propdata)+1));
		pConf->lcd_effect.vadj_saturation = be32_to_cpup((((u32*)propdata)+2));
		lcd_print("vadj_brightness = 0x%x, vadj_contrast = 0x%x, vadj_saturation = 0x%x\n", pConf->lcd_effect.vadj_brightness, pConf->lcd_effect.vadj_contrast, pConf->lcd_effect.vadj_saturation);
	}
	
	propdata = fdt_getprop(dt_addr, nodeoffset, "gamma_en_reverse", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match gamma_en_reverse, use default setting.\n");
	}
	else {
		pConf->lcd_effect.gamma_ctrl = ((be32_to_cpup((u32*)propdata) << GAMMA_CTRL_EN) | ((be32_to_cpup((((u32*)propdata)+1))) << GAMMA_CTRL_REVERSE));
		lcd_print("gamma_en = %u, gamma_reverse = %u\n", ((pConf->lcd_effect.gamma_ctrl >> GAMMA_CTRL_EN) & 1), ((pConf->lcd_effect.gamma_ctrl >> GAMMA_CTRL_REVERSE) & 1));
	}
	propdata = fdt_getprop(dt_addr, nodeoffset, "gamma_multi_rgb_coeff", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match gamma_multi_rgb_coeff, use default setting.\n");
	}
	else {
		lcd_gamma_multi = be32_to_cpup((u32*)propdata);
		pConf->lcd_effect.gamma_r_coeff = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
		pConf->lcd_effect.gamma_g_coeff = (unsigned short)(be32_to_cpup((((u32*)propdata)+2)));
		pConf->lcd_effect.gamma_b_coeff = (unsigned short)(be32_to_cpup((((u32*)propdata)+3)));
		lcd_print("gamma_multi = %u, gamma_r_coeff = %u, gamma_g_coeff = %u, gamma_b_coeff = %u\n", lcd_gamma_multi, pConf->lcd_effect.gamma_r_coeff, pConf->lcd_effect.gamma_g_coeff, pConf->lcd_effect.gamma_b_coeff);
	}
	if (lcd_gamma_multi == 1) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "gamma_table_r", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match gamma_table_r, use default table.\n");
			lcd_setup_gamma_table(pConf, 0);
		}
		else {
			for (i=0; i<256; i++) {
				pConf->lcd_effect.GammaTableR[i] = (unsigned short)(be32_to_cpup((((u32*)propdata)+i)) << 2);
			}
			lcd_print("load gamma_table_r.\n");
		}
		propdata = fdt_getprop(dt_addr, nodeoffset, "gamma_table_g", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match gamma_table_g, use default table.\n");
			lcd_setup_gamma_table(pConf, 1);
		}
		else {
			for (i=0; i<256; i++) {
				pConf->lcd_effect.GammaTableG[i] = (unsigned short)(be32_to_cpup((((u32*)propdata)+i)) << 2);
			}
			lcd_print("load gamma_table_g.\n");
		}
		propdata = fdt_getprop(dt_addr, nodeoffset, "gamma_table_b", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match gamma_table_b, use default table.\n");
			lcd_setup_gamma_table(pConf, 2);
		}
		else {
			for (i=0; i<256; i++) {
				pConf->lcd_effect.GammaTableB[i] = (unsigned short)(be32_to_cpup((((u32*)propdata)+i)) << 2);
			}
			lcd_print("load gamma_table_b.\n");
		}
	}
	else {
		propdata = fdt_getprop(dt_addr, nodeoffset, "gamma_table", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match gamma_table, use default table.\n");
			lcd_setup_gamma_table(pConf, 3);
		}
		else {
			for (i=0; i<256; i++) {
				pConf->lcd_effect.GammaTableR[i] = (unsigned short)(be32_to_cpup((((u32*)propdata)+i)) << 2);
				pConf->lcd_effect.GammaTableG[i] = (unsigned short)(be32_to_cpup((((u32*)propdata)+i)) << 2);
				pConf->lcd_effect.GammaTableB[i] = (unsigned short)(be32_to_cpup((((u32*)propdata)+i)) << 2);
			}
			lcd_print("load gamma_table.\n");
		}
	}
	
	//default setting
	propdata = fdt_getprop(dt_addr, nodeoffset, "clock_spread_spectrum", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match clock_spread_spectrum, use default setting.\n");
	}
	else {
		pConf->lcd_timing.clk_ctrl = (pConf->lcd_timing.clk_ctrl & ~(0xf << CLK_CTRL_SS)) | (be32_to_cpup((u32*)propdata) << CLK_CTRL_SS);
		lcd_print("lcd clock spread_spectrum = %u\n", (pConf->lcd_timing.clk_ctrl >> CLK_CTRL_SS) & 0xf);
	}
	propdata = fdt_getprop(dt_addr, nodeoffset, "clock_auto_generation", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match clock_auto_generation, use default setting.\n");
	}
	else {
		pConf->lcd_timing.clk_ctrl = ((pConf->lcd_timing.clk_ctrl & ~(1 << CLK_CTRL_AUTO)) | (be32_to_cpup((u32*)propdata) << CLK_CTRL_AUTO));
		lcd_print("lcd clock auto_generation = %u\n", (pConf->lcd_timing.clk_ctrl >> CLK_CTRL_AUTO) & 1);
	}
	if (((pConf->lcd_timing.clk_ctrl >> CLK_CTRL_AUTO) & 1) == 0) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "clk_pll_div_clk_ctrl", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match clk_pll_div_clk_ctrl, use default setting.\n");
		}
		else {
			pConf->lcd_timing.pll_ctrl = be32_to_cpup((u32*)propdata);
			pConf->lcd_timing.div_ctrl = be32_to_cpup((((u32*)propdata)+1));
			pConf->lcd_timing.clk_ctrl = (pConf->lcd_timing.clk_ctrl & ~(0xffff >> 0)) | (be32_to_cpup((((u32*)propdata)+2)) >> 0);
			printf("pll_ctrl = 0x%x, div_ctrl = 0x%x, clk_ctrl=0x%x\n", pConf->lcd_timing.pll_ctrl, pConf->lcd_timing.div_ctrl, (pConf->lcd_timing.clk_ctrl & 0xffff));
		}
	}
	if (pConf->lcd_basic.lcd_type == LCD_DIGITAL_LVDS) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "lvds_vswing", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match lvds_vswing, use default setting.\n");
		}
		else {
			pConf->lcd_control.lvds_config->lvds_vswing = be32_to_cpup((u32*)propdata);
			printf("lvds_vswing level = %u\n", pConf->lcd_control.lvds_config->lvds_vswing);
		}
		propdata = fdt_getprop(dt_addr, nodeoffset, "lvds_user_repack", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match lvds_user_repack, use default setting.\n");
			pConf->lcd_control.lvds_config->lvds_repack_user = 0;
			pConf->lcd_control.lvds_config->lvds_repack = 1;
		}
		else {
			pConf->lcd_control.lvds_config->lvds_repack_user = be32_to_cpup((u32*)propdata);
			pConf->lcd_control.lvds_config->lvds_repack = be32_to_cpup((((u32*)propdata)+1));
			if ((be32_to_cpup((u32*)propdata)) == 0) {
				lcd_print("lvds_repack_user = %u, lvds_repack = %u\n", pConf->lcd_control.lvds_config->lvds_repack_user, pConf->lcd_control.lvds_config->lvds_repack);
			}
			else {
				printf("lvds_repack = %u\n", pConf->lcd_control.lvds_config->lvds_repack);
			}
		}
	}
	if (pConf->lcd_basic.lcd_type == LCD_DIGITAL_EDP) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "edp_user_link_rate_lane_count", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match edp_user_link_rate_lane_count, use default setting.\n");
			pConf->lcd_control.edp_config->link_user = 0;
			pConf->lcd_control.edp_config->link_rate = 1;
			pConf->lcd_control.edp_config->lane_count = 4;
		}
		else {
			pConf->lcd_control.edp_config->link_user = (unsigned char)(be32_to_cpup((u32*)propdata));
			pConf->lcd_control.edp_config->link_rate = (unsigned char)(be32_to_cpup((((u32*)propdata)+1)));
			pConf->lcd_control.edp_config->lane_count = (unsigned char)(be32_to_cpup((((u32*)propdata)+2)));
			if (pConf->lcd_control.edp_config->link_user > 0) {
				printf("edp link_rate = %s, lane_count = %u\n", ((pConf->lcd_control.edp_config->link_rate == 0) ? "1.62G":"2.7G"), pConf->lcd_control.edp_config->lane_count);
			}
			else {
				lcd_print("edp user = %u, link_rate = %s, lane_count = %u\n", pConf->lcd_control.edp_config->link_user, ((pConf->lcd_control.edp_config->link_rate == 0) ? "1.62G":"2.7G"), pConf->lcd_control.edp_config->lane_count);
			}
		}
		propdata = fdt_getprop(dt_addr, nodeoffset, "edp_link_adaptive_vswing", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match edp_link_adaptive_vswing, use default setting.\n");
			pConf->lcd_control.edp_config->link_adaptive = 0;
			pConf->lcd_control.edp_config->vswing = 0;
			pConf->lcd_control.edp_config->preemphasis = 0;
		}
		else {
			pConf->lcd_control.edp_config->link_adaptive = (unsigned char)(be32_to_cpup((u32*)propdata));
			pConf->lcd_control.edp_config->vswing = (unsigned char)(be32_to_cpup((((u32*)propdata)+1)));
			pConf->lcd_control.edp_config->preemphasis = 0;
			if (pConf->lcd_control.edp_config->link_adaptive == 0) {
				printf("edp swing_level = %u\n", pConf->lcd_control.edp_config->vswing);
			}
			else {
				lcd_print("edp link_adaptive = %u, swing_level = %u\n", pConf->lcd_control.edp_config->link_adaptive, pConf->lcd_control.edp_config->vswing);
			}
		}
		propdata = fdt_getprop(dt_addr, nodeoffset, "edp_sync_clock_mode", NULL);
		if(propdata == NULL){
			lcd_print("don't find to match edp_sync_clock_mode, use default setting.\n");
			pConf->lcd_control.edp_config->sync_clock_mode = 1;
		}
		else {
			pConf->lcd_control.edp_config->sync_clock_mode = (be32_to_cpup((u32*)propdata) & 1);
			printf("edp sync_clock_mode = %u\n", pConf->lcd_control.edp_config->sync_clock_mode);
		}
	}
	propdata = fdt_getprop(dt_addr, nodeoffset, "rgb_base_coeff", NULL);
	if(propdata == NULL){
		lcd_print("don't find to match rgb_base_coeff, use default setting.\n");
	}
	else {
		pConf->lcd_effect.rgb_base_addr = (unsigned short)(be32_to_cpup((u32*)propdata));
		pConf->lcd_effect.rgb_coeff_addr = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
		lcd_print("rgb_base = 0x%x, rgb_coeff = 0x%x\n", pConf->lcd_effect.rgb_base_addr, pConf->lcd_effect.rgb_coeff_addr);
	}	
	// propdata = fdt_getprop(dt_addr, nodeoffset, "video_on_pixel_line", NULL);
	// if(propdata == NULL){
		// lcd_print("don't find to match video_on_pixel_line, use default setting.\n");
	// }
	// else {
		// pConf->lcd_timing.video_on_pixel = (unsigned short)(be32_to_cpup((u32*)propdata));
		// pConf->lcd_timing.video_on_line = (unsigned short)(be32_to_cpup((((u32*)propdata)+1)));
		// lcd_print("video_on_pixel = %u, video_on_line = %u\n", pConf->lcd_timing.video_on_pixel, pConf->lcd_timing.video_on_line);
	// }

	return ret;
}

static int _get_lcd_power_config(Lcd_Config_t *pConf)
{
	int i;
	int index;
	int ret=0;
	int nodeoffset;
	char* propdata;
	char propname[20];
	struct fdt_property *prop;
	char *p;
	const char * str;
	
	nodeoffset = fdt_path_offset(dt_addr, "/lcd");
	if(nodeoffset < 0) {
		printf("lcd driver init: not find /lcd node %s.\n",fdt_strerror(nodeoffset));
		return ret;
	}
	
	//lcd power on/off only for uboot
	propdata = fdt_getprop(dt_addr, nodeoffset, "power_on_uboot", NULL);
	if (propdata == NULL) {
		lcd_print("faild to get power_on_uboot\n");
		pConf->lcd_power_ctrl.power_on_uboot.type = LCD_POWER_TYPE_MAX;
		pConf->lcd_power_ctrl.power_on_uboot.gpio = GPIO_MAX;
		pConf->lcd_power_ctrl.power_on_uboot.value = LCD_POWER_GPIO_INPUT;
		pConf->lcd_power_ctrl.power_on_uboot.delay = 0;
	}
	else {
		prop = container_of(propdata, struct fdt_property, data);
		p = prop->data;
		str = p;
		if ((strcmp(str, "null") == 0) || ((strcmp(str, "n") == 0))) {
			lcd_print("no power_on_uboot config\n");
			pConf->lcd_power_ctrl.power_on_uboot.type = LCD_POWER_TYPE_MAX;
			pConf->lcd_power_ctrl.power_on_uboot.gpio = GPIO_MAX;
			pConf->lcd_power_ctrl.power_on_uboot.value = LCD_POWER_GPIO_INPUT;
			pConf->lcd_power_ctrl.power_on_uboot.delay = 0;
		}
		else {
			for(index = 0; index < LCD_POWER_TYPE_MAX; index++) {
				if(!strcmp(str, lcd_power_type_table[index]))
					break;
			}
			pConf->lcd_power_ctrl.power_on_uboot.type = index;
			if (pConf->lcd_power_ctrl.power_on_uboot.type < LCD_POWER_TYPE_SIGNAL) {
				p += strlen(p) + 1;
				str = p;
				if (pConf->lcd_power_ctrl.power_on_uboot.type == LCD_POWER_TYPE_CPU) {
					pConf->lcd_power_ctrl.power_on_uboot.gpio = aml_lcd_gpio_name_map_num(str);
				}
				else if (pConf->lcd_power_ctrl.power_on_uboot.type == LCD_POWER_TYPE_PMU) {
					pConf->lcd_power_ctrl.power_on_uboot.gpio = aml_lcd_pmu_gpio_name_map_num(str);
				}

				p += strlen(p) + 1;
				str = p;
				if ((strcmp(str, "output_low") == 0) || (strcmp(str, "0") == 0)) {
					pConf->lcd_power_ctrl.power_on_uboot.value = LCD_POWER_GPIO_OUTPUT_LOW;
				}
				else if ((strcmp(str, "output_high") == 0) || (strcmp(str, "1") == 0)) {
					pConf->lcd_power_ctrl.power_on_uboot.value = LCD_POWER_GPIO_OUTPUT_HIGH;
				}
				else if ((strcmp(str, "input") == 0) || (strcmp(str, "2") == 0)) {
					pConf->lcd_power_ctrl.power_on_uboot.value = LCD_POWER_GPIO_INPUT;
				}
			}
			pConf->lcd_power_ctrl.power_on_uboot.delay = 50;
			lcd_print("find power_on_uboot: type = %s(%d), ", lcd_power_type_table[pConf->lcd_power_ctrl.power_on_uboot.type], pConf->lcd_power_ctrl.power_on_uboot.type);
			if (pConf->lcd_power_ctrl.power_on_uboot.type == LCD_POWER_TYPE_CPU) {
				lcd_print("gpio = %s(%d), ", aml_lcd_gpio_type_table[pConf->lcd_power_ctrl.power_on_uboot.gpio], pConf->lcd_power_ctrl.power_on_uboot.gpio);
				lcd_print("value = %d\n", pConf->lcd_power_ctrl.power_on_uboot.value);
			}
			else if (pConf->lcd_power_ctrl.power_on_uboot.type == LCD_POWER_TYPE_PMU) {
				lcd_print("gpio = %d, ", pConf->lcd_power_ctrl.power_on_uboot.gpio);
				lcd_print("value = %d\n", pConf->lcd_power_ctrl.power_on_uboot.value);
			}
		}
	}
	propdata = fdt_getprop(dt_addr, nodeoffset, "power_off_uboot", NULL);
	if (propdata == NULL) {
		lcd_print("faild to get power_off_uboot\n");
		pConf->lcd_power_ctrl.power_off_uboot.type = LCD_POWER_TYPE_MAX;
		pConf->lcd_power_ctrl.power_off_uboot.gpio = GPIO_MAX;
		pConf->lcd_power_ctrl.power_off_uboot.value = LCD_POWER_GPIO_INPUT;
		pConf->lcd_power_ctrl.power_off_uboot.delay = 0;
	}
	else {
		prop = container_of(propdata, struct fdt_property, data);
		p = prop->data;
		str = p;
		if ((strcmp(str, "null") == 0) || ((strcmp(str, "n") == 0))) {
			lcd_print("no power_off_uboot config\n");
			pConf->lcd_power_ctrl.power_off_uboot.type = LCD_POWER_TYPE_MAX;
			pConf->lcd_power_ctrl.power_off_uboot.gpio = GPIO_MAX;
			pConf->lcd_power_ctrl.power_off_uboot.value = LCD_POWER_GPIO_INPUT;
			pConf->lcd_power_ctrl.power_off_uboot.delay = 0;
		}
		else {
			for(index = 0; index < LCD_POWER_TYPE_MAX; index++) {
				if(!strcmp(str, lcd_power_type_table[index]))
					break;
			}
			pConf->lcd_power_ctrl.power_off_uboot.type = index;
			if (pConf->lcd_power_ctrl.power_off_uboot.type < LCD_POWER_TYPE_SIGNAL) {
				p += strlen(p) + 1;
				str = p;
				if (pConf->lcd_power_ctrl.power_off_uboot.type == LCD_POWER_TYPE_CPU) {
					pConf->lcd_power_ctrl.power_off_uboot.gpio = aml_lcd_gpio_name_map_num(str);
				}
				else if (pConf->lcd_power_ctrl.power_off_uboot.type == LCD_POWER_TYPE_PMU) {
					pConf->lcd_power_ctrl.power_off_uboot.gpio = aml_lcd_pmu_gpio_name_map_num(str);
				}

				p += strlen(p) + 1;
				str = p;
				if ((strcmp(str, "output_low") == 0) || (strcmp(str, "0") == 0)) {
					pConf->lcd_power_ctrl.power_off_uboot.value = LCD_POWER_GPIO_OUTPUT_LOW;
				}
				else if ((strcmp(str, "output_high") == 0) || (strcmp(str, "1") == 0)) {
					pConf->lcd_power_ctrl.power_off_uboot.value = LCD_POWER_GPIO_OUTPUT_HIGH;
				}
				else if ((strcmp(str, "input") == 0) || (strcmp(str, "2") == 0)) {
					pConf->lcd_power_ctrl.power_off_uboot.value = LCD_POWER_GPIO_INPUT;
				}
			}
			pConf->lcd_power_ctrl.power_off_uboot.delay = 0;
			lcd_print("find power_off_uboot: type = %s(%d), ", lcd_power_type_table[pConf->lcd_power_ctrl.power_off_uboot.type], pConf->lcd_power_ctrl.power_off_uboot.type);
			if (pConf->lcd_power_ctrl.power_off_uboot.type == LCD_POWER_TYPE_CPU) {
				lcd_print("gpio = %s(%d), ", aml_lcd_gpio_type_table[pConf->lcd_power_ctrl.power_off_uboot.gpio], pConf->lcd_power_ctrl.power_off_uboot.gpio);
				lcd_print("value = %d\n", pConf->lcd_power_ctrl.power_off_uboot.value);
			}
			else if (pConf->lcd_power_ctrl.power_off_uboot.type == LCD_POWER_TYPE_PMU) {
				lcd_print("gpio = %d, ", pConf->lcd_power_ctrl.power_off_uboot.gpio);
				lcd_print("value = %d\n", pConf->lcd_power_ctrl.power_off_uboot.value);
			}
		}
	}
	
	//lcd power on
	for (i=0; i < LCD_POWER_CTRL_STEP_MAX; i++) {
		sprintf(propname, "power_on_step_%d", i+1);
		propdata = fdt_getprop(dt_addr, nodeoffset, propname, NULL);
		if (propdata == NULL) {
			lcd_print("faild to get %s\n", propname);
			break;
		}
		else {
			prop = container_of(propdata, struct fdt_property, data);
			p = prop->data;
			str = p;
			if ((strcmp(str, "null") == 0) || ((strcmp(str, "n") == 0))) {
				break;
			}
			for(index = 0; index < LCD_POWER_TYPE_MAX; index++) {
				if(!strcmp(str, lcd_power_type_table[index]))
					break;
			}
			pConf->lcd_power_ctrl.power_on_config[i].type = index;
			if (pConf->lcd_power_ctrl.power_on_config[i].type < LCD_POWER_TYPE_SIGNAL) {
				p += strlen(p) + 1;
				str = p;
				if (pConf->lcd_power_ctrl.power_on_config[i].type == LCD_POWER_TYPE_CPU) {
					pConf->lcd_power_ctrl.power_on_config[i].gpio = aml_lcd_gpio_name_map_num(str);
				}
				else if (pConf->lcd_power_ctrl.power_on_config[i].type == LCD_POWER_TYPE_PMU) {
					pConf->lcd_power_ctrl.power_on_config[i].gpio = aml_lcd_pmu_gpio_name_map_num(str);
				}

				p += strlen(p) + 1;
				str = p;
				if ((strcmp(str, "output_low") == 0) || (strcmp(str, "0") == 0)) {
					pConf->lcd_power_ctrl.power_on_config[i].value = LCD_POWER_GPIO_OUTPUT_LOW;
				}
				else if ((strcmp(str, "output_high") == 0) || (strcmp(str, "1") == 0)) {
					pConf->lcd_power_ctrl.power_on_config[i].value = LCD_POWER_GPIO_OUTPUT_HIGH;
				}
				else if ((strcmp(str, "input") == 0) || (strcmp(str, "2") == 0)) {
					pConf->lcd_power_ctrl.power_on_config[i].value = LCD_POWER_GPIO_INPUT;
				}
			}
		}
	}
	pConf->lcd_power_ctrl.power_on_step = i;
	lcd_print("lcd_power_on_step = %d\n", pConf->lcd_power_ctrl.power_on_step);

	propdata = fdt_getprop(dt_addr, nodeoffset, "power_on_delay", NULL);
	if (propdata == NULL) {
		printf("faild to get power_on_delay\n");
	}
	else {
		for (i=0; i<pConf->lcd_power_ctrl.power_on_step; i++) {
			pConf->lcd_power_ctrl.power_on_config[i].delay = (unsigned short)(be32_to_cpup((((u32*)propdata)+i)));
		}
	}

	//lcd power off
	for (i=0; i < LCD_POWER_CTRL_STEP_MAX; i++) {
		sprintf(propname, "power_off_step_%d", i+1);
		propdata = fdt_getprop(dt_addr, nodeoffset, propname, NULL);
		if (propdata == NULL) {
			lcd_print("faild to get %s\n", propname);
			break;
		}	
		else {
			prop = container_of(propdata, struct fdt_property, data);
			p = prop->data;
			str = p;
			if ((strcmp(str, "null") == 0) || ((strcmp(str, "n") == 0))) {
				break;
			}
			for(index = 0; index < LCD_POWER_TYPE_MAX; index++) {
				if(!strcmp(str, lcd_power_type_table[index]))
					break;
			}
			pConf->lcd_power_ctrl.power_off_config[i].type = index;
			if (pConf->lcd_power_ctrl.power_off_config[i].type < LCD_POWER_TYPE_SIGNAL) {
				p += strlen(p) + 1;
				str = p;
				if (pConf->lcd_power_ctrl.power_off_config[i].type == LCD_POWER_TYPE_CPU) {
					pConf->lcd_power_ctrl.power_off_config[i].gpio = aml_lcd_gpio_name_map_num(str);
				}
				else if (pConf->lcd_power_ctrl.power_off_config[i].type == LCD_POWER_TYPE_PMU) {
					pConf->lcd_power_ctrl.power_off_config[i].gpio = aml_lcd_pmu_gpio_name_map_num(str);
				}

				p += strlen(p) + 1;
				str = p;
				if ((strcmp(str, "output_low") == 0) || (strcmp(str, "0") == 0)) {
					pConf->lcd_power_ctrl.power_off_config[i].value = LCD_POWER_GPIO_OUTPUT_LOW;
				}
				else if ((strcmp(str, "output_high") == 0) || (strcmp(str, "1") == 0)) {
					pConf->lcd_power_ctrl.power_off_config[i].value = LCD_POWER_GPIO_OUTPUT_HIGH;
				}
				else if ((strcmp(str, "input") == 0) || (strcmp(str, "2") == 0)) {
					pConf->lcd_power_ctrl.power_off_config[i].value = LCD_POWER_GPIO_INPUT;
				}
			}
		}
	}
	pConf->lcd_power_ctrl.power_off_step = i;
	lcd_print("lcd_power_off_step = %d\n", pConf->lcd_power_ctrl.power_off_step);
	
	propdata = fdt_getprop(dt_addr, nodeoffset, "power_off_delay", NULL);
	if (propdata == NULL) {
		printf("faild to get power_off_delay\n");
	}
	else {
		for (i=0; i<pConf->lcd_power_ctrl.power_off_step; i++) {
			pConf->lcd_power_ctrl.power_off_config[i].delay = (unsigned short)(be32_to_cpup((((u32*)propdata)+i)));
		}
	}
	
	for (i=0; i<pConf->lcd_power_ctrl.power_on_step; i++) {
		lcd_print("power on step %d: type = %s(%d)\n", i+1, lcd_power_type_table[pConf->lcd_power_ctrl.power_on_config[i].type], pConf->lcd_power_ctrl.power_on_config[i].type);
		if (pConf->lcd_power_ctrl.power_on_config[i].type == LCD_POWER_TYPE_CPU) {
			lcd_print("power on step %d: gpio = %s(%d)\n", i+1, aml_lcd_gpio_type_table[pConf->lcd_power_ctrl.power_on_config[i].gpio], pConf->lcd_power_ctrl.power_on_config[i].gpio);
			lcd_print("power on step %d: value = %d\n", i+1, pConf->lcd_power_ctrl.power_on_config[i].value);
		}
		else if (pConf->lcd_power_ctrl.power_on_config[i].type == LCD_POWER_TYPE_PMU) {
			lcd_print("power on step %d: gpio = %d\n", i+1, pConf->lcd_power_ctrl.power_on_config[i].gpio);
			lcd_print("power on step %d: value = %d\n", i+1, pConf->lcd_power_ctrl.power_on_config[i].value);
		}
		lcd_print("power on step %d: delay = %d\n", i+1, pConf->lcd_power_ctrl.power_on_config[i].delay);
	}
	
	for (i=0; i<pConf->lcd_power_ctrl.power_off_step; i++) {
		lcd_print("power off step %d: type = %s(%d)\n", i+1, lcd_power_type_table[pConf->lcd_power_ctrl.power_off_config[i].type], pConf->lcd_power_ctrl.power_off_config[i].type);
		if (pConf->lcd_power_ctrl.power_off_config[i].type == LCD_POWER_TYPE_CPU) {
			lcd_print("power off step %d: gpio = %s(%d)\n", i+1, aml_lcd_gpio_type_table[pConf->lcd_power_ctrl.power_off_config[i].gpio], pConf->lcd_power_ctrl.power_off_config[i].gpio);
			lcd_print("power off step %d: value = %d\n", i+1, pConf->lcd_power_ctrl.power_off_config[i].value);
		}
		else if (pConf->lcd_power_ctrl.power_off_config[i].type == LCD_POWER_TYPE_PMU) {
			lcd_print("power off step %d: gpio = %d\n", i+1, pConf->lcd_power_ctrl.power_off_config[i].gpio);
			lcd_print("power off step %d: value = %d\n", i+1, pConf->lcd_power_ctrl.power_off_config[i].value);
		}
		lcd_print("power off step %d: delay = %d\n", i+1, pConf->lcd_power_ctrl.power_off_config[i].delay);
	}
	return ret;
}

static int _get_lcd_backlight_config(Lcd_Bl_Config_t *bl_conf)
{
	int ret=0;
	int nodeoffset;
	char * propdata;
	unsigned int bl_para[3];
	int i;
	struct fdt_property *prop;
	char *p;
	const char * str;
	unsigned pwm_freq, pwm_cnt, pwm_pre_div, tmp;
	int len;
	
	nodeoffset = fdt_path_offset(dt_addr, "/backlight");
	if(nodeoffset < 0) {
		printf("backlight init: not find /backlight node %s.\n",fdt_strerror(nodeoffset));
		return ret;
	}

	propdata = fdt_getprop(dt_addr, nodeoffset, "bl_level_default_uboot_kernel", NULL);
	if(propdata == NULL){
		printf("faild to get bl_level_default_uboot_kernel\n");
		bl_conf->level_default = BL_LEVEL_DFT;
	}
	else {
		bl_conf->level_default = (be32_to_cpup((u32*)propdata));
	}
	lcd_print("bl level default uboot=%u\n", bl_conf->level_default);
	propdata = fdt_getprop(dt_addr, nodeoffset, "bl_level_middle_mapping", NULL);
	if(propdata == NULL){
		printf("faild to get bl_level_middle_mapping\n");
		bl_conf->level_mid = BL_LEVEL_MID_DFT;
		bl_conf->level_mid_mapping = BL_LEVEL_MID_MAPPED_DFT;
	}
	else {
		bl_conf->level_mid = (be32_to_cpup((u32*)propdata));
		bl_conf->level_mid_mapping = (be32_to_cpup((((u32*)propdata)+1)));
	}
	lcd_print("bl level mid=%u, mid_mapping=%u\n", bl_conf->level_mid, bl_conf->level_mid_mapping);
	propdata = fdt_getprop(dt_addr, nodeoffset, "bl_level_max_min", NULL);
	if(propdata == NULL){
		printf("faild to get bl_level_max_min\n");
		bl_conf->level_min = BL_LEVEL_MIN_DFT;
		bl_conf->level_max = BL_LEVEL_MAX_DFT;
	}
	else {
		bl_conf->level_max = (be32_to_cpup((u32*)propdata));
		bl_conf->level_min = (be32_to_cpup((((u32*)propdata)+1)));
	}
	lcd_print("bl level max=%u, min=%u\n", bl_conf->level_max, bl_conf->level_min);
	
	propdata = fdt_getprop(dt_addr, nodeoffset, "bl_power_on_delay", NULL);
	if(propdata == NULL){
		printf("faild to get bl_power_on_delay\n");
		bl_conf->power_on_delay = 100;
	}
	else {
		bl_conf->power_on_delay = (unsigned short)(be32_to_cpup((u32*)propdata));
	}
	lcd_print("bl power_on_delay: %ums\n", bl_conf->power_on_delay);
	propdata = fdt_getprop(dt_addr, nodeoffset, "bl_ctrl_method", NULL);
	if(propdata == NULL){
		printf("faild to get bl_ctrl_method\n");
		bl_conf->method = BL_CTL_PWM_NEGATIVE;
	}
	else {
		bl_conf->method = (be32_to_cpup((u32*)propdata) > BL_CTL_MAX) ? (BL_CTL_MAX-1) : (unsigned char)(be32_to_cpup((u32*)propdata));
	}
	lcd_print("bl control_method: %s(%u)\n", bl_ctrl_method_table[bl_conf->method], bl_conf->method);
	
	if (bl_conf->method == BL_CTL_GPIO) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_gpio_port", NULL);
		if (propdata == NULL) {
			printf("faild to get bl_gpio_port\n");
#ifdef GPIODV_28
			bl_conf->gpio = GPIODV_28;
#endif
#ifdef GPIOD_1
			bl_conf->gpio = GPIOD_1;
#endif
		}
		else {
			bl_conf->gpio = aml_lcd_gpio_name_map_num(propdata);
		}
		lcd_print("bl gpio = %s(%d)\n", propdata, bl_conf->gpio);
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_gpio_dim_max_min", NULL);
		if(propdata == NULL){
			printf("faild to get bl_gpio_dim_max_min\n");
			bl_conf->dim_max = 0x0;
			bl_conf->dim_min = 0xf;
		}
		else {
			bl_conf->dim_max = (be32_to_cpup((u32*)propdata));
			bl_conf->dim_min = (be32_to_cpup((((u32*)propdata)+1)));
		}
		lcd_print("bl dim max = 0x%x, min = 0x%x\n", bl_conf->dim_max, bl_conf->dim_min);
	}
	else if ((bl_conf->method == BL_CTL_PWM_NEGATIVE) || (bl_conf->method == BL_CTL_PWM_POSITIVE)) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_pwm_port_gpio_used", NULL);
		if(propdata == NULL){
			printf("faild to get bl_pwm_port_gpio_used\n");
			str = "PWM_C";
			bl_conf->pwm_port = BL_PWM_C;
			bl_conf->pwm_gpio_used = 0;
		}
		else {
			prop = container_of(propdata, struct fdt_property, data);
			p = prop->data;
			str = p;
			if (strcmp(str, "PWM_A") == 0)
				bl_conf->pwm_port = BL_PWM_A;
			else if (strcmp(str, "PWM_B") == 0)
				bl_conf->pwm_port = BL_PWM_B;
			else if (strcmp(str, "PWM_C") == 0)
				bl_conf->pwm_port = BL_PWM_C;
			else if (strcmp(str, "PWM_D") == 0)
				bl_conf->pwm_port = BL_PWM_D;
			
			p += strlen(p) + 1;
			str = p;
			if (strncmp(str, "1", 1) == 0)
				bl_conf->pwm_gpio_used = 1;
			else
				bl_conf->pwm_gpio_used = 0;
		}
		lcd_print("bl pwm_port: %s(%u)\n", propdata, bl_conf->pwm_port);
		lcd_print("bl pwm gpio_used: %u\n", bl_conf->pwm_gpio_used);
		if (bl_conf->pwm_gpio_used == 1) {
			propdata = fdt_getprop(dt_addr, nodeoffset, "bl_gpio_port", NULL);
			if (propdata == NULL) {
				printf("faild to get bl_gpio_port\n");
	#ifdef GPIODV_28
				bl_conf->gpio = GPIODV_28;
	#endif
	#ifdef GPIOD_1
				bl_conf->gpio = GPIOD_1;
	#endif
			}
			else {
				bl_conf->gpio = aml_lcd_gpio_name_map_num(propdata);
			}
			lcd_print("bl gpio = %s(%d)\n", propdata, bl_conf->gpio);
		}
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_pwm_freq", NULL);
		if(propdata == NULL){
			pwm_freq = 300000;
			printf("faild to get bl_pwm_freq, default set to %uHz\n", pwm_freq);
		}
		else {
			pwm_freq = be32_to_cpup((u32*)propdata);
			pwm_freq = ((pwm_freq >= (FIN_FREQ * 500)) ? (FIN_FREQ * 500) : pwm_freq);
		}
		for (i=0; i<0x7f; i++) {
			pwm_pre_div = i;
			pwm_cnt = FIN_FREQ * 1000 / (pwm_freq * (pwm_pre_div + 1)) - 2;
			if (pwm_cnt <= 0xffff)
				break;
		}
		bl_conf->pwm_cnt = pwm_cnt;
		bl_conf->pwm_pre_div = pwm_pre_div;
		lcd_print("bl pwm_frequency = %uHz, pwm_cnt = %u, pre_div = %u\n", pwm_freq, bl_conf->pwm_cnt, bl_conf->pwm_pre_div);
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_pwm_duty_max_min", NULL);
		if(propdata == NULL){
			printf("faild to get bl_pwm_duty_max_min\n");
			bl_para[0] = 100;
			bl_para[1] = 20;
		}
		else {
			bl_para[0] = be32_to_cpup((u32*)propdata);
			bl_para[1] = be32_to_cpup((((u32*)propdata)+1));
		}
		bl_conf->pwm_max = (bl_conf->pwm_cnt * bl_para[0] / 100);
		bl_conf->pwm_min = (bl_conf->pwm_cnt * bl_para[1] / 100);
		lcd_print("bl pwm_duty max = %u\%, min = %u\%\n", bl_para[0], bl_para[1]);
	}
	else if (bl_conf->method == BL_CTL_PWM_COMBO) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_pwm_combo_high_low_level_switch", NULL);
		if(propdata == NULL){
			printf("faild to get bl_pwm_combo_high_low_level_switch\n");
			tmp = bl_conf->level_mid;
		}
		else {
			tmp = be32_to_cpup((u32*)propdata);
		}
		if (tmp > bl_conf->level_mid)
			tmp = ((tmp - bl_conf->level_mid) * (bl_conf->level_max - bl_conf->level_mid_mapping)) / (bl_conf->level_max - bl_conf->level_mid) + bl_conf->level_mid_mapping;
		else
			tmp = ((tmp - bl_conf->level_min) * (bl_conf->level_mid_mapping - bl_conf->level_min)) / (bl_conf->level_mid - bl_conf->level_min) + bl_conf->level_min;
		bl_conf->combo_level_switch = tmp;
		lcd_print("bl pwm_combo level switch =%u\n", bl_conf->combo_level_switch);
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_pwm_combo_high_port_method", NULL);
		if(propdata == NULL){
			printf("faild to get bl_pwm_combo_high_port_method\n");
			str = "PWM_C";
			bl_conf->combo_high_port = BL_PWM_C;
			bl_conf->combo_high_method = BL_CTL_PWM_NEGATIVE;
		}
		else {
			prop = container_of(propdata, struct fdt_property, data);
			p = prop->data;
			str = p;
			if (strcmp(str, "PWM_A") == 0)
				bl_conf->combo_high_port = BL_PWM_A;
			else if (strcmp(str, "PWM_B") == 0)
				bl_conf->combo_high_port = BL_PWM_B;
			else if (strcmp(str, "PWM_C") == 0)
				bl_conf->combo_high_port = BL_PWM_C;
			else if (strcmp(str, "PWM_D") == 0)
				bl_conf->combo_high_port = BL_PWM_D;
			
			p += strlen(p) + 1;
			str = p;
			if (strncmp(str, "1", 1) == 0)
				bl_conf->combo_high_method = BL_CTL_PWM_NEGATIVE;
			else
				bl_conf->combo_high_method = BL_CTL_PWM_POSITIVE;
		}
		lcd_print("bl pwm_combo high port: %s(%u)\n", str, bl_conf->combo_high_port);
		lcd_print("bl pwm_combo high method: %s(%u)\n", bl_ctrl_method_table[bl_conf->combo_high_method], bl_conf->combo_high_method);
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_pwm_combo_low_port_method", NULL);
		if(propdata == NULL){
			printf("faild to get bl_pwm_combo_low_port_method\n");
			str = "PWM_D";
			bl_conf->combo_low_port = BL_PWM_D;
			bl_conf->combo_high_method = BL_CTL_PWM_POSITIVE;
		}
		else {
			prop = container_of(propdata, struct fdt_property, data);
			p = prop->data;
			str = p;
			if (strcmp(str, "PWM_A") == 0)
				bl_conf->combo_low_port = BL_PWM_A;
			else if (strcmp(str, "PWM_B") == 0)
				bl_conf->combo_low_port = BL_PWM_B;
			else if (strcmp(str, "PWM_C") == 0)
				bl_conf->combo_low_port = BL_PWM_C;
			else if (strcmp(str, "PWM_D") == 0)
				bl_conf->combo_low_port = BL_PWM_D;
			
			p += strlen(p) + 1;
			str = p;
			if (strncmp(str, "1", 1) == 0)
				bl_conf->combo_low_method = BL_CTL_PWM_NEGATIVE;
			else
				bl_conf->combo_low_method = BL_CTL_PWM_POSITIVE;
		}
		lcd_print("bl pwm_combo low port: %s(%u)\n", str, bl_conf->combo_low_port);
		lcd_print("bl pwm_combo low method: %s(%u)\n", bl_ctrl_method_table[bl_conf->combo_low_method], bl_conf->combo_low_method);
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_pwm_combo_high_freq_duty_max_min", NULL);
		if(propdata == NULL){
			printf("faild to get bl_pwm_combo_high_freq_duty_max_min\n");
			bl_para[0] = 300000;	//freq=300k
			bl_para[1] = 100;
			bl_para[2] = 50;
		}
		else {
			bl_para[0] = be32_to_cpup((u32*)propdata);
			bl_para[1] = be32_to_cpup((((u32*)propdata)+1));
			bl_para[2] = be32_to_cpup((((u32*)propdata)+2));
		}
		pwm_freq = ((bl_para[0] >= (FIN_FREQ * 500)) ? (FIN_FREQ * 500) : bl_para[0]);
		for (i=0; i<0x7f; i++) {
			pwm_pre_div = i;
			pwm_cnt = FIN_FREQ * 1000 / (pwm_freq * (pwm_pre_div + 1)) - 2;
			if (pwm_cnt <= 0xffff)
				break;
		}
		bl_conf->combo_high_cnt = pwm_cnt;
		bl_conf->combo_high_pre_div = pwm_pre_div;
		bl_conf->combo_high_duty_max = (bl_conf->combo_high_cnt * bl_para[1] / 100);
		bl_conf->combo_high_duty_min = (bl_conf->combo_high_cnt * bl_para[2] / 100);
		lcd_print("bl pwm_combo high freq=%uHz, duty_max=%u\%, duty_min=%u\%\n", pwm_freq, bl_para[1], bl_para[2]);
		propdata = fdt_getprop(dt_addr, nodeoffset, "bl_pwm_combo_low_freq_duty_max_min", NULL);
		if(propdata == NULL){
			printf("faild to get bl_pwm_combo_low_freq_duty_max_min\n");
			bl_para[0] = 1000;	//freq=1k
			bl_para[1] = 100;
			bl_para[2] = 50;
		}
		else {
			bl_para[0] = be32_to_cpup((u32*)propdata);
			bl_para[1] = be32_to_cpup((((u32*)propdata)+1));
			bl_para[2] = be32_to_cpup((((u32*)propdata)+2));
		}
		pwm_freq = ((bl_para[0] >= (FIN_FREQ * 500)) ? (FIN_FREQ * 500) : bl_para[0]);
		for (i=0; i<0x7f; i++) {
			pwm_pre_div = i;
			pwm_cnt = FIN_FREQ * 1000 / (pwm_freq * (pwm_pre_div + 1)) - 2;
			if (pwm_cnt <= 0xffff)
				break;
		}
		bl_conf->combo_low_cnt = pwm_cnt;
		bl_conf->combo_low_pre_div = pwm_pre_div;
		bl_conf->combo_low_duty_max = (bl_conf->combo_low_cnt * bl_para[1] / 100);
		bl_conf->combo_low_duty_min = (bl_conf->combo_low_cnt * bl_para[2] / 100);
		lcd_print("bl pwm_combo low freq=%uHz, duty_max=%u\%, duty_min=%u\%\n", pwm_freq, bl_para[1], bl_para[2]);
	}
	
	//get backlight pinmux for pwm
	len = 0;
	switch (bl_conf->method) {
		case BL_CTL_PWM_NEGATIVE:
		case BL_CTL_PWM_POSITIVE:
			nodeoffset = fdt_path_offset(dt_addr, "/pinmux/lcd_backlight");
			if(nodeoffset < 0)
				printf("backlight init: not find /pinmux/lcd_backlight node %s.\n",fdt_strerror(nodeoffset));
			else
				len = 1;
			break;
		case BL_CTL_PWM_COMBO:
			nodeoffset = fdt_path_offset(dt_addr, "/pinmux/lcd_backlight_combo");
			if(nodeoffset < 0)
				printf("backlight init: not find /pinmux/lcd_backlight_combo node %s.\n",fdt_strerror(nodeoffset));
			else
				len = 1;
			break;
		default:
			break;
	}
	if (len > 0) {
		propdata = fdt_getprop(dt_addr, nodeoffset, "amlogic,setmask", &len);
		if(propdata == NULL){
			printf("faild to get amlogic,setmask\n");
			bl_conf->pinmux_set_num = 0;
		}
		else {
			bl_conf->pinmux_set_num = len / 8;
			for (i=0; i<bl_conf->pinmux_set_num; i++) {
				bl_conf->pinmux_set[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
				bl_conf->pinmux_set[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
			}
		}
		propdata = fdt_getprop(dt_addr, nodeoffset, "amlogic,clrmask", &len);
		if(propdata == NULL){
			printf("faild to get amlogic,clrmask\n");
			bl_conf->pinmux_clr_num = 0;
		}
		else {
			bl_conf->pinmux_clr_num = len / 8;
			for (i=0; i<bl_conf->pinmux_clr_num; i++) {
				bl_conf->pinmux_clr[i][0] = be32_to_cpup((((u32*)propdata)+2*i));
				bl_conf->pinmux_clr[i][1] = be32_to_cpup((((u32*)propdata)+2*i+1));
			}
		}
	
		for (i=0; i<bl_conf->pinmux_set_num; i++) {
			lcd_print("backlight pinmux set %d: mux_num = %d, mux_mask = 0x%x\n", i+1, bl_conf->pinmux_set[i][0], bl_conf->pinmux_set[i][1]);
		}
		for (i=0; i<bl_conf->pinmux_clr_num; i++) {
			lcd_print("backlight pinmux clr %d: mux_num = %d, mux_mask = 0x%x\n", i+1, bl_conf->pinmux_clr[i][0], bl_conf->pinmux_clr[i][1]);
		}
	}
	return ret;
}
#endif

static void prepare_lcd_debug(void)
{
#ifdef LCD_DEBUG_INFO
	lcd_print_flag = 1;
#else
	if (getenv("lcd_print_flag") == NULL)
		lcd_print_flag = 0;
	else
		lcd_print_flag = simple_strtoul(getenv("lcd_print_flag"), NULL, 10);
#endif
	lcd_print("lcd print flag: %u\n", lcd_print_flag);
	
	if (getenv("lcd_debug_flag") == NULL)
		lcd_debug_flag = 0;
	else
		lcd_debug_flag = simple_strtoul(getenv("lcd_debug_flag"), NULL, 10);
}

static inline void _set_panel_info(void)
{
	panel_info.vd_base = simple_strtoul(getenv("fb_addr"), NULL, NULL);
	panel_info.vl_col = simple_strtoul(getenv("display_width"), NULL, NULL);
	panel_info.vl_row = simple_strtoul(getenv("display_height"), NULL, NULL);
	panel_info.vl_bpix = simple_strtoul(getenv("display_bpp"), NULL, NULL);
	panel_info.vd_color_fg = simple_strtoul(getenv("display_color_fg"), NULL, NULL);
	panel_info.vd_color_bg = simple_strtoul(getenv("display_color_bg"), NULL, NULL);
	
	lcd_print("panel_info: resolution = %ux%u\n", panel_info.vl_col, panel_info.vl_row);
	lcd_print("panel_info: vl_bpix = %u\n", panel_info.vl_bpix);
}

static void print_lcd_info(void)
{
    unsigned lcd_clk;
    int h_adj, v_adj;
    Lcd_Config_t *pConf = pDev->pConf;

    lcd_clk = (pConf->lcd_timing.lcd_clk / 1000);
    h_adj = ((pConf->lcd_timing.h_offset >> 31) & 1);
    v_adj = ((pConf->lcd_timing.v_offset >> 31) & 1);

    printf("LCD mode: %s %ubit, %ux%u@%u.%uHz\n"
           "lcd_clk           %u.%03uMHz\n"
           "ss_level          %d\n"
           "clk_pol           %d\n\n",
           lcd_type_table[pConf->lcd_basic.lcd_type], pConf->lcd_basic.lcd_bits, pConf->lcd_basic.h_active, pConf->lcd_basic.v_active, (pConf->lcd_timing.sync_duration_num / 10), (pConf->lcd_timing.sync_duration_num % 10),
           (lcd_clk / 1000), (lcd_clk % 1000), ((pConf->lcd_timing.clk_ctrl >> CLK_CTRL_SS) & 0xf), ((pConf->lcd_timing.pol_ctrl >> POL_CTRL_CLK) & 1));

    printf("h_period          %d\n"
           "v_period          %d\n"
           "hs_width          %d\n"
           "hs_backporch      %d\n"
           "hs_pol            %d\n"
           "vs_width          %d\n"
           "vs_backporch      %d\n"
           "vs_pol            %d\n"
           "vs_h_phase        %s%d\n"
           "hvsync_valid      %d\n"
           "de_valid          %d\n"
           "h_offset          %s%d\n"
           "v_offset          %s%d\n\n",
           pConf->lcd_basic.h_period, pConf->lcd_basic.v_period,
           pConf->lcd_timing.hsync_width, pConf->lcd_timing.hsync_bp, ((pConf->lcd_timing.pol_ctrl >> POL_CTRL_HS) & 1),
           pConf->lcd_timing.vsync_width, pConf->lcd_timing.vsync_bp, ((pConf->lcd_timing.pol_ctrl >> POL_CTRL_VS) & 1),
           (((pConf->lcd_timing.vsync_h_phase >> 31) & 1) ? "-":""), (pConf->lcd_timing.vsync_h_phase & 0xffff), pConf->lcd_timing.hvsync_valid, pConf->lcd_timing.de_valid,
           (h_adj ? "-" : ""), (pConf->lcd_timing.h_offset & 0xffff), (v_adj ? "-" : ""), (pConf->lcd_timing.v_offset & 0xffff));

    switch (pConf->lcd_basic.lcd_type) {
        case LCD_DIGITAL_TTL:
            printf("rb_swap           %u\n"
                   "bit_swap          %u\n\n",
                   pConf->lcd_control.ttl_config->rb_swap, pConf->lcd_control.ttl_config->bit_swap);
            break;
        case LCD_DIGITAL_LVDS:
            printf("vswing_level      %u\n"
                   "lvds_repack       %u\n"
                   "pn_swap           %u\n\n",
                   pConf->lcd_control.lvds_config->lvds_vswing, pConf->lcd_control.lvds_config->lvds_repack, pConf->lcd_control.lvds_config->pn_swap);
            break;
        case LCD_DIGITAL_MIPI:
            printf("dsi_lane_num      %u\n"
                   "dsi_bit_rate      %u.%03uMHz\n"
                   "operation_mode    %u(%s), %u(%s)\n"
                   "transfer_ctrl     %u, %u\n\n",
                   pConf->lcd_control.mipi_config->lane_num,
                   (pConf->lcd_control.mipi_config->bit_rate / 1000000), ((pConf->lcd_control.mipi_config->bit_rate % 1000000) / 1000),
                   ((pConf->lcd_control.mipi_config->operation_mode>>BIT_OPERATION_MODE_INIT) &1), (((pConf->lcd_control.mipi_config->operation_mode>>BIT_OPERATION_MODE_INIT) & 1) ? "COMMAND" : "VIDEO"),
                   ((pConf->lcd_control.mipi_config->operation_mode>>BIT_OPERATION_MODE_DISP) & 1), (((pConf->lcd_control.mipi_config->operation_mode>>BIT_OPERATION_MODE_DISP) & 1) ? "COMMAND" : "VIDEO"),
                   ((pConf->lcd_control.mipi_config->transfer_ctrl>>BIT_TRANS_CTRL_CLK) & 1), ((pConf->lcd_control.mipi_config->transfer_ctrl>>BIT_TRANS_CTRL_SWITCH) & 3));
            break;
        case LCD_DIGITAL_EDP:
            printf("link_rate         %s\n"
                   "lane_count        %u\n"
                   "link_adaptive     %u\n"
                   "vswing            %u\n"
                   "max_lane_count    %u\n"
                   "sync_clock_mode   %u\n\n",
                   ((pConf->lcd_control.edp_config->link_rate == 0) ? "1.62G" : "2.7G"), pConf->lcd_control.edp_config->lane_count,
                   pConf->lcd_control.edp_config->link_adaptive, pConf->lcd_control.edp_config->vswing,
                   pConf->lcd_control.edp_config->max_lane_count, pConf->lcd_control.edp_config->sync_clock_mode);
            break;
        default:
            break;
    }

    if (pConf->lcd_effect.dith_user)
        printf("dither_ctrl       0x%x\n", pConf->lcd_effect.dith_cntl_addr);

    printf("pll_ctrl          0x%08x\n"
           "div_ctrl          0x%08x\n"
           "clk_ctrl          0x%08x\n"
           "video_on_pixel    %d\n"
           "video_on_line     %d\n\n",
           pConf->lcd_timing.pll_ctrl, pConf->lcd_timing.div_ctrl, pConf->lcd_timing.clk_ctrl,
           pConf->lcd_timing.video_on_pixel, pConf->lcd_timing.video_on_line);

    if (pConf->lcd_misc_ctrl.print_clk)
        pConf->lcd_misc_ctrl.print_clk();
}

static void lcd_config_assign(Lcd_Config_t *pConf)
{
    pConf->lcd_power_ctrl.power_ctrl = lcd_power_ctrl;
}

int lcd_probe(void)
{
    pDev = (lcd_dev_t *)malloc(sizeof(lcd_dev_t));
    if (!pDev) {
        printf("[lcd]: Not enough memory.\n");
        return -1;
    }
	prepare_lcd_debug();
	dts_ready = 0;	//prepare dts_ready flag, default no dts
#ifdef CONFIG_OF_LIBFDT
#ifdef CONFIG_DT_PRELOAD
	int ret;
	
#ifdef CONFIG_DTB_LOAD_ADDR
	dt_addr = CONFIG_DTB_LOAD_ADDR;
#else
	dt_addr = 0x0f000000;
#endif
	ret = fdt_check_header(dt_addr);
	if(ret < 0) {
		dts_ready = 0;
		printf("check dts: %s, load default lcd parameters\n", fdt_strerror(ret));
	}
	else {
		dts_ready = 1;
	}
#endif
#endif
	
	if (lcd_debug_flag > 0)
		dts_ready = 0;
	if(dts_ready == 0) {
		pDev->pConf = &lcd_config_dft;
		pDev->bl_config = &bl_config_dft;
		if (pDev->pConf->lcd_basic.model_name == NULL) {
			pDev->pConf->lcd_basic.model_name = PANEL_MODEL_DEFAULT;
		}
		else if (strncmp(pDev->pConf->lcd_basic.model_name, "none", 4) == 0) {
			printf("no lcd exist!\n");
			return 1;
		}
		lcd_default_config_init(pDev->pConf);
		backlight_default_config_init(pDev->bl_config);
		printf("load default lcd model: %s\n", pDev->pConf->lcd_basic.model_name);
	}
	else {
#ifdef CONFIG_OF_LIBFDT
		pDev->pConf = get_lcd_config();
		pDev->bl_config = &bl_config;
		_get_lcd_model_timing(pDev->pConf);
		_get_lcd_default_config(pDev->pConf);
		_get_lcd_power_config(pDev->pConf);
		_get_lcd_backlight_config(pDev->bl_config);
#endif
	}
	
	_set_panel_info();
	lcd_config_assign(pDev->pConf);
	lcd_config_probe(pDev->pConf);
	
	pDev->pConf->lcd_misc_ctrl.print_version();
	_lcd_init(pDev->pConf);
	if (lcd_print_flag > 0)
		print_lcd_info();
	return 0;
}

int lcd_remove(void)
{
	lcd_backlight_power_ctrl(OFF);
	pDev->pConf->lcd_misc_ctrl.module_disable();
	lcd_config_remove();
	
	if (pDev->pConf->lcd_basic.model_name)
		free(pDev->pConf->lcd_basic.model_name);
	if (pDev)
		free(pDev);
	pDev = NULL;

	return 0;
}

//***************************************************//
//for lcd_function_call by other module, compatible dts
//***************************************************//
static void _enable_backlight(void)
{
	if (pDev != NULL)
		lcd_backlight_power_ctrl(ON);
}
static void _disable_backlight(void)
{
	if (pDev != NULL)
		lcd_backlight_power_ctrl(OFF);
}
static void _set_backlight_level(unsigned level)
{
	if (pDev != NULL)
		set_lcd_backlight_level(level);
}
static unsigned _get_backlight_level(void)
{
	if (pDev != NULL)
		return get_lcd_backlight_level();
	else
		return 0;
}
static void _lcd_enable(void)
{
	if (pDev == NULL)
		lcd_probe();
	else
		printf("lcd is already ON\n");
}
static void _lcd_disable(void)
{
	if (pDev != NULL)
		lcd_remove();
	else
		printf("lcd is already OFF\n");
}
static void _lcd_power_on(void)
{
	if (pDev != NULL)
		lcd_power_ctrl(ON);
}
static void _lcd_power_off(void)
{
	if (pDev != NULL)
		lcd_power_ctrl(OFF);
}
static void _lcd_test(unsigned num)
{
	if (pDev != NULL)
		pDev->pConf->lcd_misc_ctrl.lcd_test(num);
	else
		printf("lcd is OFF, can't display test pattern\n");
}

static void _lcd_info(void)
{
	if (pDev != NULL) {
		pDev->pConf->lcd_misc_ctrl.print_version();
		print_lcd_info();
	}
	else {
		printf("lcd is OFF\n");
	}
}

struct panel_operations panel_oper =
{
	.enable       = _lcd_enable,
	.disable      = _lcd_disable,
	.bl_on        = _enable_backlight,
	.bl_off       = _disable_backlight,
	.set_bl_level = _set_backlight_level,
	.get_bl_level = _get_backlight_level,
	.power_on     = _lcd_power_on,
	.power_off    = _lcd_power_off,
	.test         = _lcd_test,
	.info         = _lcd_info,
};
//****************************************

#endif
