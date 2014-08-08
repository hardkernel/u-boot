/*
 * Copyright (C) 2012 Samsung Electronics
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
#include <netdev.h>
#include <asm/arch/cpu.h>
#include <asm/arch/power.h>
#include <asm/arch/gpio.h>
#include <asm/arch/pmic.h>
#include <asm/arch/mmc.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/sromc.h>

unsigned int OmPin;

DECLARE_GLOBAL_DATA_PTR;
unsigned int second_boot_info = 0xffffffff;


int board_init(void)
{
	u8 read_vol_arm, read_vol_kfc;
	u8 read_vol_int, read_vol_g3d;
	u8 read_vol_mif;
	u8 read_buck;
	u8 read_pmic_id;
	u8 read_bb9_ctrl2;

	char bl1_version[9] = {0};

	/* display BL1 version */
#ifdef CONFIG_TRUSTZONE
	printf("\nTrustZone Enabled BSP");
	strncpy(&bl1_version[0], (char *)(CONFIG_PHY_IRAM_NS_BASE + 0x810), 8);
#else
	strncpy(&bl1_version[0], (char *)0x02022fc8, 8);
#endif
	printf("\nBL1 version: %s\n", &bl1_version[0]);

#if defined(CONFIG_PM)
	IIC0_ERead(0xcc, 0x26, &read_vol_mif);
	IIC0_ERead(0xcc, 0x28, &read_vol_arm);
	IIC0_ERead(0xcc, 0x2a, &read_vol_int);
	IIC0_ERead(0xcc, 0x2c, &read_vol_g3d);
	IIC0_ERead(0xcc, 0x34, &read_vol_kfc);
#ifdef CONFIG_MACH_UNIVERSAL5410
	IIC0_ERead(0xcc, 0x00, &read_pmic_id);
	IIC0_ERead(0xcc, 0x3a, &read_bb9_ctrl2);
	printf("id: %x\n", read_pmic_id);
	printf("bb9_ctrl2: %x\n", read_bb9_ctrl2);
	printf("GPH0DAT: %x\n", *(unsigned int *)(0x13400284));
	if ((read_pmic_id == 2) && ((read_bb9_ctrl2 & (1 << 6)) != 0)
		&& (*(unsigned int *)(0x13400284) == 0xD))
		printf("week: 49/50, board rev: 0.1\n");
#endif
	printf("vol_mif: %x\n", read_vol_mif);
	printf("vol_arm: %x\n", read_vol_arm);
	printf("vol_int: %x\n", read_vol_int);
	printf("vol_g3d: %x\n", read_vol_g3d);
	printf("vol_kfc: %x\n", read_vol_kfc);
#endif

	/* legacy - need to check */
	*(unsigned int *)0x10050234 = 0;

	gd->bd->bi_arch_number = MACH_TYPE_SMDK5410;

	gd->bd->bi_boot_params = (PHYS_SDRAM_1+0x100);

	OmPin = __REG(EXYNOS5_POWER_BASE + INFORM3_OFFSET);
	printf("\nChecking Boot Mode ...");
	if (OmPin == BOOT_ONENAND) {
		printf(" OneNand\n");
	} else if (OmPin == BOOT_NAND) {
		printf(" NAND\n");
	} else if (OmPin == BOOT_MMCSD) {
		printf(" SDMMC\n");
	} else if (OmPin == BOOT_EMMC) {
		printf(" EMMC4.3\n");
	} else if (OmPin == BOOT_EMMC_4_4) {
		printf(" EMMC4.41\n");
	} else {
		printf(" Please check OM_pin\n");
	}

	return 0;
}

int dram_init(void)
{
	gd->ram_size	= get_ram_size((long *)PHYS_SDRAM_1, PHYS_SDRAM_1_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_2, PHYS_SDRAM_2_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_3, PHYS_SDRAM_3_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_4, PHYS_SDRAM_4_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_5, PHYS_SDRAM_7_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_6, PHYS_SDRAM_7_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_7, PHYS_SDRAM_7_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_8, PHYS_SDRAM_8_SIZE);

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
	gd->bd->bi_dram[4].start = PHYS_SDRAM_5;
	gd->bd->bi_dram[4].size = get_ram_size((long *)PHYS_SDRAM_5,
							PHYS_SDRAM_5_SIZE);
	gd->bd->bi_dram[5].start = PHYS_SDRAM_6;
	gd->bd->bi_dram[5].size = get_ram_size((long *)PHYS_SDRAM_6,
							PHYS_SDRAM_6_SIZE);
	gd->bd->bi_dram[6].start = PHYS_SDRAM_7;
	gd->bd->bi_dram[6].size = get_ram_size((long *)PHYS_SDRAM_7,
							PHYS_SDRAM_7_SIZE);
	gd->bd->bi_dram[7].start = PHYS_SDRAM_8;
	gd->bd->bi_dram[7].size = get_ram_size((long *)PHYS_SDRAM_8,
							PHYS_SDRAM_8_SIZE);
}

int board_eth_init(bd_t *bis)
{
	return 0;
}

#ifdef CONFIG_DISPLAY_BOARDINFO
int checkboard(void)
{
	printf("\nBoard: SMDK5410\n");

	return 0;
}
#endif

#ifdef CONFIG_GENERIC_MMC
int board_mmc_init(bd_t *bis)
{
	int err;

	err = exynos_pinmux_config(PERIPH_ID_SDMMC2, PINMUX_FLAG_NONE);
	if (err) {
		debug("SDMMC2 not configured\n");
		return err;
	}

	err = exynos_pinmux_config(PERIPH_ID_SDMMC0, PINMUX_FLAG_8BIT_MODE);
	if (err) {
		debug("MSHC0 not configured\n");
		return err;
	}

	if (OmPin == BOOT_EMMC_4_4 || OmPin == BOOT_EMMC) {
#ifdef USE_MMC0
		set_mmc_clk(PERIPH_ID_SDMMC0, 1);
		err = s5p_mmc_init(PERIPH_ID_SDMMC0, 8);
#endif
#ifdef USE_MMC2
		set_mmc_clk(PERIPH_ID_SDMMC2, 1);
		err = s5p_mmc_init(PERIPH_ID_SDMMC2, 4);
#endif
	}
	else {
#ifdef USE_MMC2
		set_mmc_clk(PERIPH_ID_SDMMC2, 1);
		err = s5p_mmc_init(PERIPH_ID_SDMMC2, 4);
#endif
#ifdef USE_MMC0
		set_mmc_clk(PERIPH_ID_SDMMC0, 1);
		err = s5p_mmc_init(PERIPH_ID_SDMMC0, 8);
#endif
	}

	return err;
}
#endif

static int board_uart_init(void)
{
	int err;

	err = exynos_pinmux_config(PERIPH_ID_UART0, PINMUX_FLAG_NONE);
	if (err) {
		debug("UART0 not configured\n");
		return err;
	}

	err = exynos_pinmux_config(PERIPH_ID_UART1, PINMUX_FLAG_NONE);
	if (err) {
		debug("UART1 not configured\n");
		return err;
	}

	err = exynos_pinmux_config(PERIPH_ID_UART2, PINMUX_FLAG_NONE);
	if (err) {
		debug("UART2 not configured\n");
		return err;
	}

	err = exynos_pinmux_config(PERIPH_ID_UART3, PINMUX_FLAG_NONE);
	if (err) {
		debug("UART3 not configured\n");
		return err;
	}

	return 0;
}

#ifdef CONFIG_BOARD_EARLY_INIT_F
int board_early_init_f(void)
{
	return board_uart_init();
}
#endif

int board_late_init(void)
{
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;
#ifdef CONFIG_RECOVERY_MODE
	struct exynos5_gpio_part1 *gpio1 =
		(struct exynos5_gpio_part1 *)samsung_get_base_gpio_part1();
	int err;
	u32 second_boot_info = readl(CONFIG_SECONDARY_BOOT_INFORM_BASE);

	err = exynos_pinmux_config(PERIPH_ID_INPUT_X0_0, PINMUX_FLAG_NONE);
	if (err) {
		debug("GPX0_0 INPUT not configured\n");
		return err;
	}

	udelay(10);
	if ((s5p_gpio_get_value(&gpio1->x0, 0) == 0) || second_boot_info == 1) {
		writel(0x0, CONFIG_SECONDARY_BOOT_INFORM_BASE);
		setenv("bootcmd", CONFIG_BOOTCOMMAND2);
	}
#endif
	if (second_boot_info == 1)
		printf("###Secondary Boot###\n");

	if ((readl(&pmu->sysip_dat0)) == CONFIG_FACTORY_RESET_MODE) {
		writel(0x0, &pmu->sysip_dat0);
		setenv("bootcmd", CONFIG_FACTORY_RESET_BOOTCOMMAND);
	}

	return 0;
}
