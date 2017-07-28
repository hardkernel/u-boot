/*
 * Odroid Board setup for EXYNOS5 based board
 *
 * Copyright (C) 2017 Hardkernel Co.,Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */
#include <common.h>
#include <asm/arch/cpu.h>
#include <asm/arch/board.h>
#include <asm/arch/dwmmc.h>
#include <asm/arch/mmc.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/power.h>
#include <asm/arch/system.h>
#include <asm/arch/sromc.h>
#include <asm/gpio.h>
#include <asm/io.h>
#include <samsung/misc.h>
#include <samsung/odroid_misc.h>
#include <errno.h>
#include <version.h>
#include <malloc.h>
#include <memalign.h>
#include <linux/sizes.h>
#include <linux/input.h>
#include <power/pmic.h>
#include <power/regulator.h>
#include <power/s2mps11.h>
#include <dm.h>
#include <adc.h>
#include <mmc.h>

DECLARE_GLOBAL_DATA_PTR;

/* ODROID Debug Message */
/*
#define	ODROID_MISC_DEBUG
*/

/*---------------------------------------------------------------------------*/
void odroid_led_ctrl(int gpio, int status)
{
	gpio_set_value(gpio, status);
}

/*---------------------------------------------------------------------------*/
static void odroid_pmic_deinit(void)	{}

/*---------------------------------------------------------------------------*/
static void odroid_pmic_init(void)
{
	struct udevice *dev;

	if (pmic_get("s2mps11", &dev))	{
		printf("%s : s2mps11 control error!\n", __func__);
		return;
	}

	/* LDO9 : USB 3.0 3.3V */
	pmic_reg_write(dev, S2MPS11_REG_L9CTRL, 0xF2);

	/* LDO15, LDO17 : ETH 3.3V */
	pmic_reg_write(dev, S2MPS11_REG_L15CTRL, 0xF2);
	pmic_reg_write(dev, S2MPS11_REG_L17CTRL, 0xF2);

	/* LDO13, LDO19 : MMC 3.3V */
	pmic_reg_write(dev, S2MPS11_REG_L13CTRL, 0xF2);
	pmic_reg_write(dev, S2MPS11_REG_L19CTRL, 0xF2);

	/* BUCK10 : eMMC 2.85V */
	pmic_reg_write(dev, S2MPS11_REG_B10CTRL2, 0xA8);

	/* Master Reset Enable */
	pmic_reg_write(dev, 0x0c, 0x10);

#if defined(ODROID_MISC_DEBUG)
	/* debug message */
	printf("S2MPS11_REG_L9CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L9CTRL));
	printf("S2MPS11_REG_L15CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L15CTRL));
	printf("S2MPS11_REG_L17CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L17CTRL));
	printf("S2MPS11_REG_L13CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L13CTRL));
	printf("S2MPS11_REG_L19CTRL = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_L19CTRL));
	printf("S2MPS11_REG_B10CTRL2 = 0x%02X\n",
		pmic_reg_read(dev, S2MPS11_REG_B10CTRL2));
#endif
}

/*---------------------------------------------------------------------------*/
static void odroid_led_deinit(void)
{
	odroid_led_ctrl(GPIO_LED_R, 0);
	odroid_led_ctrl(GPIO_LED_G, 0);
	odroid_led_ctrl(GPIO_LED_B, 0);
	gpio_free(GPIO_LED_R);
	gpio_free(GPIO_LED_G);
	gpio_free(GPIO_LED_B);
}

/*---------------------------------------------------------------------------*/
static void odroid_led_init(void)
{
	if (gpio_request(GPIO_LED_R, "LED-R")) 
		goto	err;
	odroid_led_ctrl(GPIO_LED_R, 0);

	if (gpio_request(GPIO_LED_G, "LED-G"))
		goto	err;
	odroid_led_ctrl(GPIO_LED_G, 0);

	/* Default On */
	if (gpio_request(GPIO_LED_B, "LED-B"))
		goto	err;
	odroid_led_ctrl(GPIO_LED_B, 1);

	return;
err:
	printf("%s : GPIO Control error!\n", __func__);
}

/*---------------------------------------------------------------------------*/
static void odroid_gpio_deinit(void)
{
	gpio_direction_output(GPIO_FAN_CTL, 0);
	gpio_direction_output(GPIO_LCD_PWM, 0);

	gpio_free(GPIO_POWER_BT);
	gpio_free(GPIO_FAN_CTL);
	gpio_free(GPIO_LCD_PWM);
}

/*---------------------------------------------------------------------------*/
static void odroid_gpio_init(void)
{
	/* Power control button pin */
	if (!gpio_request(GPIO_POWER_BT, "Power BT"))
		goto err;
	gpio_set_pull(GPIO_POWER_BT, S5P_GPIO_PULL_NONE);
	gpio_direction_input(GPIO_POWER_BT);

	/* FAN Full Enable */
	if (!gpio_request(GPIO_FAN_CTL, "FAN Ctrl"))
		goto err;
	gpio_set_pull(GPIO_FAN_CTL, S5P_GPIO_PULL_NONE);
	gpio_direction_output(GPIO_FAN_CTL, 1);

	/* LCD PWM Port High */
	if (!gpio_request(GPIO_LCD_PWM, "LCD PWM"))
		goto err;
	gpio_set_pull(GPIO_LCD_PWM, S5P_GPIO_PULL_NONE);
	gpio_direction_output(GPIO_LCD_PWM, 1);

	return;
err:
	printf("%s : GPIO Control error!\n", __func__);
}

/*---------------------------------------------------------------------------*/
/*
	ODROID XU3/XU3-Lite/XU4 Hardware Init.
	call from board/samsung/common/board.c
*/
/*---------------------------------------------------------------------------*/
void odroid_misc_init(void)
{
	/* Default LDO value setup */
	odroid_pmic_init();
	odroid_gpio_init();
	odroid_led_init();
}

/*---------------------------------------------------------------------------*/
void odroid_misc_deinit(void)
{
	odroid_led_deinit();
	odroid_gpio_deinit();
	odroid_pmic_deinit();
}

/*---------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------*/
