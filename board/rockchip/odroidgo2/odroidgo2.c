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
#ifdef CONFIG_DM_CHARGE_DISPLAY
#include <power/charge_display.h>
#endif
#include <key.h>
#include <rockchip_display_cmds.h>
#include <odroidgo2_status.h>
#include <fs.h>
#include <version.h>

DECLARE_GLOBAL_DATA_PTR;

extern int board_check_recovery(void);
extern void board_odroid_recovery(void);
extern int board_check_power(void);

#define ALIVE_LED_GPIO	17 /* GPIO0_C1 */
#define WIFI_EN_GPIO	110 /* GPIO3_B6 */

void board_alive_led(void)
{
	gpio_request(ALIVE_LED_GPIO, "alive_led");
	gpio_direction_output(ALIVE_LED_GPIO, 1);
	gpio_free(ALIVE_LED_GPIO);
}

void board_wifi_en(void)
{
	gpio_request(WIFI_EN_GPIO, "wifi_enable");
	gpio_direction_output(WIFI_EN_GPIO, 1);
	gpio_free(WIFI_EN_GPIO);
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

void board_run_autotest(void)
{
	run_command("odroidtest all", 0);
	odroid_wait_pwrkey();
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

void board_check_mandatory_files(void)
{
	/* check sd card existence */
	if (CMD_RET_SUCCESS != run_command("mmc dev 1", 0)) {
		if(CMD_RET_SUCCESS != run_command("mmc dev 1", 0)) {
			odroid_display_status(LOGO_MODE_NO_SDCARD,
				LOGO_STORAGE_ANYWHERE, NULL);
			goto err;
		}
	}

	/* check launcher in ext4 fs of sd card */
	if (file_exists("mmc", "1:2", "/usr/local/bin/emulationstation/emulationstation",
				FS_TYPE_EXT)) {
		lcd_setfg_color("white");
		lcd_printf(0, 0, 1, "[ GO Advanced EMULATION Image ]");
	}

	return;

err:
	odroid_wait_pwrkey();
}

int rk_board_late_init(void)
{
	/* turn on blue led */
	board_alive_led();

	/* set wifi_en as default high */
	board_wifi_en();

	/* set uart2-m1 port as a default debug console */
	board_debug_uart2m1();

	/* set sfc alternate function */
	board_init_sfc_if();

	/* set switch gpio */
	board_init_switch_gpio();

	/* check power */
	if(board_check_power())
		return 0;

	if (!board_check_recovery()) {
		printf("Now start recovery mode\n");
		board_odroid_recovery();
		/* never get here */
	}

#ifdef CONFIG_DM_CHARGE_DISPLAY
	charge_display();
#endif

	/* show boot logo and version : drivers/video/drm/rockchip_display_cmds.c */
	lcd_show_logo();
	lcd_setfg_color("white");
	lcd_printf(0, 18, 1, "%s", U_BOOT_VERSION);
	lcd_printf(0, 19, 1, "%s %s", U_BOOT_DATE, U_BOOT_TIME);

	if (!board_check_autotest()) {
		board_run_autotest();
		return 0;
	}

	board_check_mandatory_files();

	return 0;
}
