/*
 * drivers/display/lcd/aml_lcd_gpio.c
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
#include <errno.h>
#include <dm.h>
#include <asm/gpio.h>
#include <amlogic/aml_lcd.h>
#include "aml_lcd_reg.h"
#include "aml_lcd_common.h"

#define LCD_GPIO_SYS_API

#ifdef LCD_GPIO_SYS_API
int aml_lcd_gpio_name_map_num(const char *name)
{
	int gpio;
#if defined(CONFIG_DM_GPIO)
	int ret;
#endif

#if defined(CONFIG_DM_GPIO)
	ret = gpio_lookup_name(name, NULL, NULL, (unsigned int *)&gpio);
	if (ret) {
		LCDERR("gpio: wrong name %s\n", name);
		return LCD_GPIO_MAX;
	}
#else
	/* turn the gpio name into a gpio number */
	gpio = simple_strtoul(name, NULL, 10);
	if (gpio < 0) {
		LCDERR("gpio: wrong name %s\n", name);
		return LCD_GPIO_MAX;
	}
#endif
	if (lcd_debug_print_flag)
		LCDPR("gpio: %s, %d\n", name, gpio);
	return gpio;
}

int aml_lcd_gpio_set(int gpio, int value)
{
	int ret = 0;

	if (gpio >= LCD_GPIO_MAX)
		return -1;
	if (lcd_debug_print_flag)
		LCDPR("gpio: %d, value: %d\n", gpio, value);
	/* grab the pin before we tweak it */
	ret = gpio_request(gpio, "aml_lcd_gpio");
	if (ret && ret != -EBUSY) {
		LCDERR("gpio: requesting pin %u failed\n", gpio);
		return -1;
	}

	/* finally, let's do it: set direction and exec command */
	switch (value) {
	case LCD_GPIO_OUTPUT_LOW:
	case LCD_GPIO_OUTPUT_HIGH:
		ret = gpio_direction_output(gpio, value);
		break;
	case LCD_GPIO_INPUT:
	default:
		ret = gpio_direction_input(gpio);
		break;
	}
	if (ret != -EBUSY)
		gpio_free(gpio);

	return 0;
}

unsigned int aml_lcd_gpio_input_get(int gpio)
{
	unsigned int value;

	if (gpio >= LCD_GPIO_MAX)
		return 0;
	gpio_direction_input(gpio);
	value = gpio_get_value(gpio);
	return value;
}

#else
struct aml_lcd_gpio_s {
	unsigned int bank;
	unsigned int offset;
};

static const char *aml_lcd_gpio_table[]={
	"GPIOAO_0",
	"GPIOAO_1",
	"GPIOAO_2",
	"GPIOAO_3",
	"GPIOAO_4",
	"GPIOAO_5",
	"GPIOAO_6",
	"GPIOAO_7",
	"GPIOAO_8",
	"GPIOAO_9",
	"GPIOAO_10",
	"GPIOAO_11",
	"GPIOAO_12",
	"GPIOAO_13",
	"GPIOZ_0",
	"GPIOZ_1",
	"GPIOZ_2",
	"GPIOZ_3",
	"GPIOZ_4",
	"GPIOZ_5",
	"GPIOZ_6",
	"GPIOZ_7",
	"GPIOZ_8",
	"GPIOZ_9",
	"GPIOZ_10",
	"GPIOZ_11",
	"GPIOZ_12",
	"GPIOZ_13",
	"GPIOZ_14",
	"GPIOZ_15",
	"GPIOZ_16",
	"GPIOZ_17",
	"GPIOZ_18",
	"GPIOZ_19",
	"GPIOZ_20",
	"GPIOH_0",
	"GPIOH_1",
	"GPIOH_2",
	"GPIOH_3",
	"GPIOH_4",
	"GPIOH_5",
	"GPIOH_6",
	"GPIOH_7",
	"GPIOH_8",
	"GPIOH_9",
	"GPIOH_10",
	"BOOT_0",
	"BOOT_1",
	"BOOT_2",
	"BOOT_3",
	"BOOT_4",
	"BOOT_5",
	"BOOT_6",
	"BOOT_7",
	"BOOT_8",
	"BOOT_9",
	"BOOT_10",
	"BOOT_11",
	"BOOT_12",
	"BOOT_13",
	"BOOT_14",
	"BOOT_15",
	"BOOT_16",
	"BOOT_17",
	"BOOT_18",
	"CARD_0",
	"CARD_1",
	"CARD_2",
	"CARD_3",
	"CARD_4",
	"CARD_5",
	"CARD_6",
	"GPIOW_0",
	"GPIOW_1",
	"GPIOW_2",
	"GPIOW_3",
	"GPIOW_4",
	"GPIOW_5",
	"GPIOW_6",
	"GPIOW_7",
	"GPIOW_8",
	"GPIOW_9",
	"GPIOW_10",
	"GPIOW_11",
	"GPIOW_12",
	"GPIOW_13",
	"GPIOW_14",
	"GPIOW_15",
	"GPIOW_16",
	"GPIOW_17",
	"GPIOW_18",
	"GPIOW_19",
	"GPIOW_20",
	"GPIOY_0",
	"GPIOY_1",
	"GPIOY_2",
	"GPIOY_3",
	"GPIOY_4",
	"GPIOY_5",
	"GPIOY_6",
	"GPIOY_7",
	"GPIOY_8",
	"GPIOY_9",
	"GPIOY_10",
	"GPIOY_11",
	"GPIOY_12",
	"GPIOY_13",
	"GPIOX_0",
	"GPIOX_1",
	"GPIOX_2",
	"GPIOX_3",
	"GPIOX_4",
	"GPIOX_5",
	"GPIOX_6",
	"GPIOX_7",
	"GPIOX_8",
	"GPIOX_9",
	"GPIOX_10",
	"GPIOX_11",
	"GPIOX_12",
	"GPIOX_13",
	"GPIOX_14",
	"GPIOX_15",
	"GPIOX_16",
	"GPIOX_17",
	"GPIOX_18",
	"GPIOX_19",
	"GPIOX_20",
	"GPIOX_21",
	"GPIOX_22",
	"GPIOX_23",
	"GPIOX_24",
	"GPIOX_25",
	"GPIOX_26",
	"GPIOX_27",
	"GPIOCLK_0",
	"GPIO_TEST_N",
	"GPIO_MAX",
};

static unsigned int aml_lcd_gpio_ctrl[][6] = {
	//oen_reg,            oen_bit, out_reg,          out_bit, in_reg,           in_bit
	{AO_GPIO_O_EN_N,      0,       AO_GPIO_O_EN_N,   16,      AO_GPIO_I,        0, }, //GPIOAO
	{PREG_PAD_GPIO2_EN_N, 0,       PREG_PAD_GPIO2_O, 0,       PREG_PAD_GPIO2_I, 0, }, //BOOT
	{PREG_PAD_GPIO2_EN_N, 20,      PREG_PAD_GPIO2_O, 20,      PREG_PAD_GPIO2_I, 20,}, //CARD
	{PREG_PAD_GPIO0_EN_N, 0,       PREG_PAD_GPIO0_O, 0,       PREG_PAD_GPIO0_I, 0, }, //GPIOW
	{PREG_PAD_GPIO3_EN_N, 0,       PREG_PAD_GPIO3_O, 0,       PREG_PAD_GPIO3_I, 0, }, //GPIOZ
	{PREG_PAD_GPIO1_EN_N, 20,      PREG_PAD_GPIO1_O, 20,      PREG_PAD_GPIO1_I, 20,}, //GPIOH
	{PREG_PAD_GPIO4_EN_N, 0,       PREG_PAD_GPIO4_O, 0,       PREG_PAD_GPIO4_I, 0, }, //GPIOX
	{PREG_PAD_GPIO1_EN_N, 0,       PREG_PAD_GPIO1_O, 0,       PREG_PAD_GPIO1_I, 0, }, //GPIOY
	{PREG_PAD_GPIO3_EN_N, 24,      PREG_PAD_GPIO3_O, 24,      PREG_PAD_GPIO3_I, 24,}  //GPIOCLK
};

int aml_lcd_gpio_name_map_num(const char *name)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(aml_lcd_gpio_table); i++) {
		if (!strcmp(name, aml_lcd_gpio_table[i]))
			break;
	}
	if (i == ARRAY_SIZE(aml_lcd_gpio_table)) {
		printf("wrong gpio name %s, i=%d\n", name, i);
		i = -1;
	}
	return i;
}

static int aml_lcd_gpio_bank_offset(int gpio, struct aml_lcd_gpio_s *gpio_s)
{
	int ret = 0;

	if ((gpio >= GPIOAO_0) && (gpio <= GPIOAO_13)) {
		gpio_s->bank = 0;
		gpio_s->offset = gpio - GPIOAO_0;
	} else if ((gpio >= PIN_BOOT_0) && (gpio <= PIN_BOOT_18)) {
		gpio_s->bank = 1;
		gpio_s->offset = gpio - PIN_BOOT_0;
	} else if ((gpio >= PIN_CARD_0) && (gpio <= PIN_CARD_6)) {
		gpio_s->bank = 2;
		gpio_s->offset = gpio - PIN_CARD_0;
	} else if ((gpio >= PIN_GPIOW_0) && (gpio <= PIN_GPIOW_20)) {
		gpio_s->bank = 3;
		gpio_s->offset = gpio - PIN_GPIOW_0;
	} else if ((gpio >= PIN_GPIOZ_0) && (gpio <= PIN_GPIOZ_20)) {
		gpio_s->bank = 4;
		gpio_s->offset = gpio - PIN_GPIOZ_0;
	} else if ((gpio >= PIN_GPIOH_0) && (gpio <= PIN_GPIOH_10)) {
		gpio_s->bank = 5;
		gpio_s->offset = gpio - PIN_GPIOH_0;
	} else if ((gpio >= PIN_GPIOX_0) && (gpio <= PIN_GPIOX_27)) {
		gpio_s->bank = 6;
		gpio_s->offset = gpio - PIN_GPIOX_0;
	} else if ((gpio >= PIN_GPIOY_0) && (gpio <= PIN_GPIOY_13)) {
		gpio_s->bank = 7;
		gpio_s->offset = gpio - PIN_GPIOY_0;
	} else {
		printf("Wrong GPIO Port number: %d\n", gpio);
		ret = -1;
	}

	return ret;
}

int aml_lcd_gpio_set(int gpio, int value)
{
	struct aml_lcd_gpio_s gpio_s;
	int ret = 0;

	ret = aml_lcd_gpio_bank_offset(gpio, &gpio_s);
	if (ret)
		return -1;

	switch (value) {
	case LCD_GPIO_OUTPUT_LOW:
		if ((gpio >= GPIOAO_0) && (gpio <= GPIOAO_13)) {
			lcd_aobus_setb(aml_lcd_gpio_ctrl[gpio_s.bank][2], 0,
				(aml_lcd_gpio_ctrl[gpio_s.bank][3] + gpio_s.offset), 1);
			lcd_aobus_setb(aml_lcd_gpio_ctrl[gpio_s.bank][0], 0,
				(aml_lcd_gpio_ctrl[gpio_s.bank][1] + gpio_s.offset), 1);
		} else {
			lcd_periphs_setb(aml_lcd_gpio_ctrl[gpio_s.bank][2], 0,
				(aml_lcd_gpio_ctrl[gpio_s.bank][3] + gpio_s.offset), 1);
			lcd_periphs_setb(aml_lcd_gpio_ctrl[gpio_s.bank][0], 0,
				(aml_lcd_gpio_ctrl[gpio_s.bank][1] + gpio_s.offset), 1);
		}
		break;
	case LCD_GPIO_OUTPUT_HIGH:
		if ((gpio >= GPIOAO_0) && (gpio <= GPIOAO_13)) {
			lcd_aobus_setb(aml_lcd_gpio_ctrl[gpio_s.bank][2], 1,
				(aml_lcd_gpio_ctrl[gpio_s.bank][3] + gpio_s.offset), 1);
			lcd_aobus_setb(aml_lcd_gpio_ctrl[gpio_s.bank][0], 0,
				(aml_lcd_gpio_ctrl[gpio_s.bank][1] + gpio_s.offset), 1);
		} else {
			lcd_periphs_setb(aml_lcd_gpio_ctrl[gpio_s.bank][2], 1,
				(aml_lcd_gpio_ctrl[gpio_s.bank][3] + gpio_s.offset), 1);
			lcd_periphs_setb(aml_lcd_gpio_ctrl[gpio_s.bank][0], 0,
				(aml_lcd_gpio_ctrl[gpio_s.bank][1] + gpio_s.offset), 1);
		}
		break;
	case LCD_GPIO_INPUT:
	default:
		if ((gpio >= GPIOAO_0) && (gpio <= GPIOAO_13)) {
			lcd_aobus_setb(aml_lcd_gpio_ctrl[gpio_s.bank][0], 1,
				(aml_lcd_gpio_ctrl[gpio_s.bank][1] + gpio_s.offset), 1);
		} else {
			lcd_periphs_setb(aml_lcd_gpio_ctrl[gpio_s.bank][0], 1,
				(aml_lcd_gpio_ctrl[gpio_s.bank][1] + gpio_s.offset), 1);
		}
		break;
	}

	return 0;
}

unsigned int aml_lcd_gpio_input_get(int gpio)
{
	struct aml_lcd_gpio_s gpio_s;
	unsigned int ret = 0;

	ret = aml_lcd_gpio_bank_offset(gpio, &gpio_s);
	if (ret)
		return -1;

	if ((gpio >= GPIOAO_0) && (gpio <= GPIOAO_13)) {
		ret = lcd_aobus_getb(aml_lcd_gpio_ctrl[gpio_s.bank][0],
			(aml_lcd_gpio_ctrl[gpio_s.bank][1] + gpio_s.offset), 1);
	} else {
		ret = lcd_periphs_getb(aml_lcd_gpio_ctrl[gpio_s.bank][0],
			(aml_lcd_gpio_ctrl[gpio_s.bank][1] + gpio_s.offset), 1);
	}

	return ret;
}
#endif

