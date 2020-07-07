/*
 * (C) Copyright 2020 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <key.h>
#include <dm.h>
#include <console.h>
#include <asm/io.h>
#include <asm/arch/grf_px30.h>
#include <asm/arch/hardware.h>
#include <version.h>

#define POWERDOWN_WAIT_TIME	10000
#define LOOP_DELAY		25

#define PMUGRF_BASE	0xFF010000

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

	printf("power key long pressed...\n");
	mdelay(500);
	run_command("poweroff", 0);
}
