/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <asm/io.h>
#include <asm/gpio.h>
#include <asm/arch/grf_px30.h>
#include <asm/arch/hardware.h>
#include <rockchip_display_cmds.h>
#include <fat.h>
#include <version.h>

DECLARE_GLOBAL_DATA_PTR;

#define ALIVE_LED_GPIO	17 /* GPIO0_C1 */
void board_alive_led(void)
{
	gpio_request(ALIVE_LED_GPIO, "alive_led");
	gpio_direction_output(ALIVE_LED_GPIO, 1);
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

void board_show_logo(void)
{
	loff_t len_read;

	lcd_init();

	fs_set_blk_dev("mmc", "1:1", FS_TYPE_FAT);
	fs_read("1.bmp", 33554432, 0, 0, &len_read);
	show_bmp(simple_strtoul("2000000", NULL, 16));

	lcd_setfg(255, 255, 0);
	lcd_printf(0, 18, 1, "%s", U_BOOT_VERSION);
	lcd_printf(0, 19, 1, "%s", U_BOOT_DATE);
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

int rk_board_late_init(void)
{
	/* turn on blue led */
	board_alive_led();

	/* set uart2-m1 port as a default debug console */
	board_debug_uart2m1();

	/* show boot logo and version */
	board_show_logo();

	/* set sfc alternate function */
	board_init_sfc_if();

	return 0;
}
