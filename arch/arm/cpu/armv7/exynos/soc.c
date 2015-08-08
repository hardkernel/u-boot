/*
 * Copyright (c) 2010 Samsung Electronics.
 * Minkyu Kang <mk7.kang@samsung.com>
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>
#include <asm/io.h>

#if defined(CONFIG_BOARD_HARDKERNEL) && defined(CONFIG_EXYNOS4412)
#include <asm/arch/gpio.h>
#include <asm/arch/pmic_hkdk4212.h>
#endif

void reset_cpu(ulong addr)
{
#if defined(CONFIG_BOARD_HARDKERNEL) && defined(CONFIG_EXYNOS4412)
	struct exynos4_gpio_part2 *gpio2 = (struct exynos4_gpio_part2 *) EXYNOS4_GPIO_PART2_BASE;

	emmc_pwr_reset();

	s5p_gpio_cfg_pin(&gpio2->k1, 2, GPIO_OUTPUT);
	s5p_gpio_set_value(&gpio2->k1, 2, 0);
	udelay (50000);				/* wait 50 ms */
	s5p_gpio_set_value(&gpio2->k1, 2, 1);
#endif

	writel(0x1, samsung_get_base_swreset());
}
