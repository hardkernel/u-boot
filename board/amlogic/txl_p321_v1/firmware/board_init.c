
/*
 * board/amlogic/gxtvbb_p301_v1/firmware/board_init.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include "power.c"

/* bl2 customer code */

#define PNL_PREG_PAD_GPIO1_EN_N           0x0f
#define PNL_PREG_PAD_GPIO1_O              0x10
#define PNL_PREG_PAD_GPIO1_I              0x11

#define PNL_PREG_PAD_GPIO3_EN_N           0x15
#define PNL_PREG_PAD_GPIO3_O              0x16
#define PNL_PREG_PAD_GPIO3_I              0x17

#define PNL_REG_BASE               (0xc8834400L)
#define PNL_REG(reg)               (PNL_REG_BASE + (reg << 2))
#define PNL_REG_R(_reg)            (*(volatile unsigned int *)PNL_REG(_reg))
#define PNL_REG_W(_reg, _value)    *(volatile unsigned int *)PNL_REG(_reg) = (_value);
void panel_power_init(void)
{
	serial_puts("init panel power\n");

	/* panel: GPIOH_4/5/6/7/8 */ /* remove GPIOH_6 for 2D/3D special case */
	PNL_REG_W(PNL_PREG_PAD_GPIO1_O,
		(PNL_REG_R(PNL_PREG_PAD_GPIO1_O) & ~(0x1b << 24)));
	PNL_REG_W(PNL_PREG_PAD_GPIO1_EN_N,
		(PNL_REG_R(PNL_PREG_PAD_GPIO1_EN_N) & ~(0x1b << 24)));

	/* backlight: GPIOZ_2/6/7 */
	PNL_REG_W(PNL_PREG_PAD_GPIO3_O,
		(PNL_REG_R(PNL_PREG_PAD_GPIO3_O) & ~((1 << 2) | (0x3 << 6))));
	PNL_REG_W(PNL_PREG_PAD_GPIO3_EN_N,
		(PNL_REG_R(PNL_PREG_PAD_GPIO3_EN_N) & ~((1 << 2) | (0x3 << 6))));
}

#define SEC_AO_SEC_GP_CFG0			(0xda100000 + (0x90 << 2))
static int check_is_ddr_inited(void)
{
	return ((readl(SEC_AO_SEC_GP_CFG0) >> 16) & 0xffff);
}

#ifdef CONFIG_MDUMP_COMPRESS
#include <asm/reboot.h>
static unsigned int get_reboot_reason(void)
{
	unsigned int reboot_mode_val = ((readl(AO_RTI_STATUS_REG3)) & 0xf);

	return reboot_mode_val;
}
#endif

void board_init(void)
{
	power_init(0);

	//only run once before ddr inited.
#ifdef CONFIG_MDUMP_COMPRESS
	if (!check_is_ddr_inited() &&
	    (get_reboot_reason() != AMLOGIC_KERNEL_PANIC)) {
#else
	if (!check_is_ddr_inited()) {
#endif
		/* dram 1.5V reset */
		serial_puts("DRAM reset...\n");
		/* power off ddr */
		writel((readl(P_AO_GPIO_O_EN_N) & (~((1 << 11) | (1 << 27)))),P_AO_GPIO_O_EN_N);
		/* need delay, check hw design */
		_udelay(100000);
		/* power on ddr */
		writel((readl(P_AO_GPIO_O_EN_N) | (1 << 27)),P_AO_GPIO_O_EN_N);

		/* dram RC charge time, check hw design */
		_udelay(10000);
	}

	panel_power_init();
}
