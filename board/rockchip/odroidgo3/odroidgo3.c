/*
 * (C) Copyright 2020 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <asm/io.h>
#include <asm/gpio.h>
#include <asm/arch/grf_px30.h>
#include <asm/arch/hardware.h>
#include <key.h>
#include <fs.h>
#include <version.h>

DECLARE_GLOBAL_DATA_PTR;

extern int board_check_power(void);

#define ALIVE_LED_GPIO	17 /* GPIO0_C1 */
#define WIFI_EN_GPIO	110 /* GPIO3_B6 */

void board_alive_led(void)
{
	gpio_request(ALIVE_LED_GPIO, "alive_led");
	gpio_direction_output(ALIVE_LED_GPIO, 1);
	gpio_free(ALIVE_LED_GPIO);
}

int board_check_autotest(void)
{
	u32 stater, statel;
	unsigned int delay = 1000; /* long key down for 1 sec */

	while (delay) {
		stater = key_read(BTN_TR);
		statel = key_read(BTN_TL);

		if ((stater != KEY_PRESS_DOWN) || (statel != KEY_PRESS_DOWN))
			return -1;

		mdelay(50);
		delay -= 50;
	}

	return 0;
}

#define GRF_BASE		0xff140000
void board_debug_uart2m1(void)
{
	static struct px30_grf * const grf = (void *)GRF_BASE;

	/* GRF_IOFUNC_CON0 */
	enum {
		CON_IOMUX_UART2SEL_SHIFT	= 10,
		CON_IOMUX_UART2SEL_MASK = 3 << CON_IOMUX_UART2SEL_SHIFT,
		CON_IOMUX_UART2SEL_M0	= 0,
		CON_IOMUX_UART2SEL_M1,
		CON_IOMUX_UART2SEL_USBPHY,
	};

	/* Enable early UART2 */
	rk_clrsetreg(&grf->iofunc_con0,
		     CON_IOMUX_UART2SEL_MASK,
		     CON_IOMUX_UART2SEL_M1 << CON_IOMUX_UART2SEL_SHIFT);
}

void board_init_sfc_if(void)
{
	static struct px30_grf * const grf = (void *)GRF_BASE;

	/* sfc_clk */
	rk_setreg(&grf->gpio1bl_iomux, (0x3 << 4));

	/* sfc_scn0 */
	rk_setreg(&grf->gpio1ah_iomux, 0x3);

	/* sfc_sio0 */
	rk_setreg(&grf->gpio1al_iomux, 0x3);

	/* sfc_sio1 */
	rk_setreg(&grf->gpio1al_iomux, (0x3 << 4));
}

void board_init_switch_gpio(void)
{
	static struct px30_grf * const grf = (void *)GRF_BASE;

	/* set iomux */
	rk_clrreg(&grf->gpio1al_iomux, 0x0f00);
	rk_clrreg(&grf->gpio1ah_iomux, 0xfff0);
	rk_clrreg(&grf->gpio1bh_iomux, 0xffff);

	/* set pad pull control */
	rk_clrsetreg(&grf->gpio1b_p, 0xff00, 0x5500);
	rk_clrsetreg(&grf->gpio1a_p, 0xfcc0, 0x5440);
	rk_clrsetreg(&grf->gpio2a_p, 0xffff, 0x5555);
	rk_clrsetreg(&grf->gpio3b_p, 0xC030, 0x4010);
}

int rk_board_late_init(void)
{
	/* turn on blue led */
	board_alive_led();

	/* set uart2-m1 port as a default debug console */
	board_debug_uart2m1();

	/* set sfc alternate function */
	board_init_sfc_if();

	/* set switch gpio */
	board_init_switch_gpio();

	/* check power */
	if(board_check_power())
		return 0;

	/* display boot logo - TODO */

	return 0;
}
