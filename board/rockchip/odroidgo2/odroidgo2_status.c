/*
 * (C) Copyright 2019 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <key.h>
#include <dm.h>
#include <console.h>
#include <rockchip_display_cmds.h>
#include <odroidgo2_status.h>
#include <asm/io.h>
#include <asm/arch/grf_px30.h>
#include <asm/arch/hardware.h>
#include <version.h>

#define POWERDOWN_WAIT_TIME	10000
#define LOOP_DELAY		25

#define PMUGRF_BASE	0xFF010000

static const char *st_logo_modes[] = {
	"st_logo_hardkernel",
	"st_logo_lowbatt",
	"st_logo_recovery",
	"st_logo_err",
	"st_logo_nosdcard",
};

static const char *logo_bmp_names[] = {
	"logo.bmp",
	"low_battery.bmp",
	"recovery.bmp",
	"system_error.bmp",
	"no_sdcard.bmp",
};

unsigned long bmp_mem;
unsigned long bmp_copy;

/*
 * When normal fdt logic doesn't work, this fnctio will show error leds
 * and shutdown system. In this case, only low level interface is available
 * so this approach is only possible solution so far.
 */
void odroid_alert_leds(void)
{
	static struct px30_pmugrf * const pmugrf = (void *)PMUGRF_BASE;

	/* leds setup */
	rk_clrreg(&pmugrf->gpio0bl_iomux, 0x0C00);
	rk_clrreg(&pmugrf->gpio0cl_iomux, 0x000C);

	while (1) {
		/* set high */
		rk_clrsetreg(&pmugrf->gpio0b_p, 0x0C00, 0x0400);
		rk_clrsetreg(&pmugrf->gpio0c_p, 0x000C, 0x0004);
		mdelay(200);
		/* set low */
		rk_clrsetreg(&pmugrf->gpio0b_p, 0x0C00, 0x0800);
		rk_clrsetreg(&pmugrf->gpio0c_p, 0x000C, 0x0008);
		mdelay(200);

		if (ctrlc()) {
			printf("ctrl+c key pressed - drop to console\n");
			env_set("bootdelay", "-1");
			return;
		}
	}
}

void odroid_drop_errorlog(const char *err, unsigned int size)
{
	char str_cmd[64];

	sprintf(str_cmd, "save mmc 1 %p error.log 0x%x",
			(void *)err, size);
	run_command(str_cmd, 0);
}

void odroid_wait_pwrkey(void)
{
	u32 state;
	unsigned int delay = POWERDOWN_WAIT_TIME;

	printf("Wait power key\n");
	printf("Hit ctrl+c key to enter uboot console\n");

	/* check power key */
	while (delay) {
		state = key_read(KEY_POWER);
		if (state == KEY_PRESS_DOWN)
			break;

		if (ctrlc()) {
			printf("ctrl+c key pressed - drop to console\n");
			env_set("bootdelay", "-1");
			return;
		}

		mdelay(LOOP_DELAY);
		delay -= LOOP_DELAY;
	}

	if (show_bmp(bmp_mem))
		printf("[%s] show_bmp Fail!\n", __func__);

	printf("power key long pressed...\n");
	lcd_printf(0, 18, 1, "%s", "power off...");
	mdelay(500);
	run_command("poweroff", 0);
}

int odroid_display_status(int logo_mode, int logo_storage, const char *str)
{
	char cmd[128];

	if (lcd_init()) {
		printf("odroid lcd init fail!\n");
		odroid_drop_errorlog("lcd init fail, check dtb file", 29);
		odroid_alert_leds();
		return -1;
	}

	/* draw logo bmp */
	if (!bmp_mem) {
		bmp_mem = lcd_get_mem();
		bmp_copy = bmp_mem + LCD_LOGO_SIZE;
	}

	switch (logo_storage) {
	case LOGO_STORAGE_SPIFLASH:
		sprintf(cmd, "rksfc read %p %s %s", (void *)bmp_copy,
			env_get(st_logo_modes[logo_mode]),
			env_get("sz_logo"));
		run_command(cmd, 0);

		sprintf(cmd, "unzip %p %p", (void *)bmp_copy, (void *)bmp_mem);
		run_command(cmd, 0);

		if (show_bmp(bmp_mem))
			printf("[%s] show_bmp Fail!\n", __func__);
		break;
	case LOGO_STORAGE_SDCARD:
		sprintf(cmd, "fatload mmc 1:1 %p %s", (void *)bmp_mem,
			logo_bmp_names[logo_mode]);
		run_command(cmd, 0);

		if (show_bmp(bmp_mem))
			printf("[%s] show_bmp Fail!\n", __func__);
		break;
	case LOGO_STORAGE_ANYWHERE:
	default:
		/* try spi flash first */
		sprintf(cmd, "rksfc read %p %s %s", (void *)bmp_copy,
			env_get(st_logo_modes[logo_mode]),
			env_get("sz_logo"));
		run_command(cmd, 0);

		sprintf(cmd, "unzip %p %p", (void *)bmp_copy, (void *)bmp_mem);
		run_command(cmd, 0);

		if (show_bmp(bmp_mem)) {
			/* then, check sd card */
			sprintf(cmd, "fatload mmc 1:1 %p %s", (void *)bmp_mem,
				logo_bmp_names[logo_mode]);
			run_command(cmd, 0);

			if (show_bmp(bmp_mem))
				printf("[%s] show_bmp Fail!\n", __func__);
		}
		break;
	}

	switch (logo_mode) {
	case LOGO_MODE_SYSTEM_ERR:
		lcd_setfg_color("white");
		lcd_setbg_color("black");
		break;
	case LOGO_MODE_NO_SDCARD:
		lcd_setfg_color("grey");
		lcd_setbg_color("white");
		lcd_printf(0, 19, 1, "U-BOOT (spinor) : %s %s", U_BOOT_DATE, U_BOOT_TIME);
		lcd_setfg_color("black");
		break;
	case LOGO_MODE_LOW_BATT:
	case LOGO_MODE_RECOVERY:
	default:
		lcd_setfg_color("black");
		lcd_setbg_color("white");
		break;
	}

	/* draw text */
	if (str)
		lcd_printf(0, 18, 1, "%s", str);

	return 0;
}
