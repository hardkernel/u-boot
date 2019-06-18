/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <asm/io.h>
#include <asm/gpio.h>

DECLARE_GLOBAL_DATA_PTR;

#define ALIVE_LED_GPIO	17 /* GPIO0_C1 */
void board_alive_led(void)
{
	gpio_request(ALIVE_LED_GPIO, "alive_led");
	gpio_direction_output(ALIVE_LED_GPIO, 1);
}

int rk_board_late_init(void)
{
	board_alive_led();

	return 0;
}
