/*
    
 * Copyright (C) 2013  Hardkernel Co.,LTD.
 * Hakjoo Kim <ruppi.kim@hardkernel.com>
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
#include <asm/io.h>
#include <i2c.h>
#include <netdev.h>
#include <asm/arch/cpu.h>
#include <asm/arch/gpio.h>
#include <asm/arch/mmc.h>
#include <asm/arch/dwmmc.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/sromc.h>
#include <asm/arch/power.h>
#include "setup.h"

DECLARE_GLOBAL_DATA_PTR;
struct exynos4_gpio_part1 *gpio1;
struct exynos4_gpio_part2 *gpio2;

int board_init(void)
{
	gpio1 = (struct exynos4_gpio_part1 *) EXYNOS4_GPIO_PART1_BASE;
	gpio2 = (struct exynos4_gpio_part2 *) EXYNOS4_GPIO_PART2_BASE;

	gd->bd->bi_boot_params = (PHYS_SDRAM_1 + 0x100UL);

	return 0;
}

int dram_init(void)
{
	gd->ram_size	= get_ram_size((long *)PHYS_SDRAM_1, PHYS_SDRAM_1_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_2, PHYS_SDRAM_2_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_3, PHYS_SDRAM_3_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_4, PHYS_SDRAM_4_SIZE);
#ifdef CONFIG_RESERVED_DRAM
	gd->ram_size -= COnFIG_RESERVED_DRAM;
#endif
    return 0;
}

void dram_init_banksize(void)
{
	gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
	gd->bd->bi_dram[0].size = get_ram_size((long *)PHYS_SDRAM_1,
							PHYS_SDRAM_1_SIZE);
	gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
	gd->bd->bi_dram[1].size = get_ram_size((long *)PHYS_SDRAM_2,
							PHYS_SDRAM_2_SIZE);
	gd->bd->bi_dram[2].start = PHYS_SDRAM_3;
	gd->bd->bi_dram[2].size = get_ram_size((long *)PHYS_SDRAM_3,
							PHYS_SDRAM_3_SIZE);
	gd->bd->bi_dram[3].start = PHYS_SDRAM_4;
	gd->bd->bi_dram[3].size = get_ram_size((long *)PHYS_SDRAM_4,
							PHYS_SDRAM_4_SIZE);

#ifdef CONFIG_TRUSTZONE
      gd->bd->bi_dram[CONFIG_NR_DRAM_BANKS - 1].size -= CONFIG_TRUSTZONE_RESERVED_DRAM;
#endif
}

static void board_power_init(void)
{
    ps_hold_setup();
}

int board_eth_init(bd_t *bis)
{
#ifdef CONFIG_SMC911X_ODROID
	if (smc9115_pre_init())
		return -1;
	return smc911x_initialize(0, CONFIG_SMC911X_BASE);
#endif
	return 0;
}

#ifdef CONFIG_DISPLAY_BOARDINFO
int checkboard(void)
{
	printf("\nBoard: ODROID-X\n");

	return 0;
}
#endif

#ifdef CONFIG_GENERIC_MMC
int board_emmc_init(void)
{
	int err;
#ifndef CONFIG_EXYNOS_DWMMC 
	err = exynos_pinmux_config(PERIPH_ID_SDMMC0, PINMUX_FLAG_8BIT_MODE);
	if (err) {
		debug("eMMC ch0 not configured\n");
		return err;
	}
	err = s5p_mmc_init(0, 8);
#else
	err = exynos_pinmux_config(PERIPH_ID_SDMMC4, PINMUX_FLAG_8BIT_MODE);
	if (err) {
		debug("eMMC ch4 not configured\n");
		return err;
	}
	err = exynos_dwmmc_init(4, 8);
#endif
	return err;
}

int board_sdmmc_init(void)
{
	int err;

	err = exynos_pinmux_config(PERIPH_ID_SDMMC2, PINMUX_FLAG_NONE);
	if (err) {
		debug("SDMMC2 not configured\n");
		return err;
	}
	err = s5p_mmc_init(2, 4);
	return err;
}
int board_mmc_init(bd_t *bis)
{
	int err;

	struct exynos4_power *power = (struct exynos4_power *)samsung_get_base_power();

	if ((power->om_stat & 0x1E) == 0x8) {
		err = board_emmc_init();
		err = board_sdmmc_init();
	} else {
		err = board_sdmmc_init();
		err = board_emmc_init();
	}

	return 0;
}
#endif

static int board_uart_init(void)
{
	int err;

	err = exynos_pinmux_config(PERIPH_ID_UART, PINMUX_FLAG_NONE);
	if (err) {
		debug("UART%d not configured\n",
			   PERIPH_ID_UART - PERIPH_ID_UART0);
	}

	return err;
}

#ifdef CONFIG_SYS_I2C_INIT_BOARD
static int board_i2c_init(void)
{
	int i, err;

	for (i = 0; i < CONFIG_MAX_I2C_NUM; i++) {
		err = exynos_pinmux_config((PERIPH_ID_I2C0 + i),
						PINMUX_FLAG_NONE);
		if (err) {
			debug("I2C%d not configured\n", (PERIPH_ID_I2C0 + i));
			return err;
		}
	}
	i2c_init(CONFIG_SYS_I2C_SPEED, CONFIG_SYS_I2C_SLAVE);
	return 0;
}
#endif

#ifdef CONFIG_BOARD_EARLY_INIT_F
int board_early_init_f(void)
{
	int err;

    board_power_init();
	err = board_uart_init();
	if (err) {
		debug("UART%d init failed\n",
			   PERIPH_ID_UART - PERIPH_ID_UART0);
		return err;
	}
#ifdef CONFIG_SYS_I2C_INIT_BOARD
	err = board_i2c_init();
#endif
	return err;
}
#endif 
