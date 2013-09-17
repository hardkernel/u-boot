/*
 * Copyright (C) 2011 Samsung Electronics
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
#include <asm/arch/pinmux.h>
#include <asm/arch/mmc.h>
#include <asm/arch/sromc.h>
#include <asm/arch/clk.h>

DECLARE_GLOBAL_DATA_PTR;
struct exynos4_gpio_part1 *gpio1;
struct exynos4_gpio_part2 *gpio2;

static void smc9115_pre_init(void)
{
	u32 smc_bw_conf, smc_bc_conf;

	/* gpio configuration GPK0CON */
	s5p_gpio_cfg_pin(&gpio2->y0, CONFIG_ENV_SROM_BANK, GPIO_FUNC(2));

	/* Ethernet needs bus width of 16 bits */
	smc_bw_conf = SROMC_DATA16_WIDTH(CONFIG_ENV_SROM_BANK);
	smc_bc_conf = SROMC_BC_TACS(0x0F) | SROMC_BC_TCOS(0x0F)
			| SROMC_BC_TACC(0x0F) | SROMC_BC_TCOH(0x0F)
			| SROMC_BC_TAH(0x0F)  | SROMC_BC_TACP(0x0F)
			| SROMC_BC_PMC(0x0F);

	/* Select and configure the SROMC bank */
	s5p_config_sromc(CONFIG_ENV_SROM_BANK, smc_bw_conf, smc_bc_conf);
}

int board_init(void)
{
	u8 read_id;
	u8 read_vol_arm = 0x0;
	u8 read_vol_int = 0x0;
	u8 read_vol_g3d = 0x0;
	u8 read_vol_mif = 0x0;

	int OmPin = readl(EXYNOS4_POWER_BASE + INFORM3_OFFSET);

	gpio1 = (struct exynos4_gpio_part1 *) EXYNOS4_GPIO_PART1_BASE;
	gpio2 = (struct exynos4_gpio_part2 *) EXYNOS4_GPIO_PART2_BASE;

	IIC0_ERead(0xcc, 0, &read_id);
	if (read_id == 0x77) {
		IIC0_ERead(0xcc, 0x19, &read_vol_arm);
		IIC0_ERead(0xcc, 0x22, &read_vol_int);
		IIC0_ERead(0xcc, 0x2B, &read_vol_g3d);
		//IIC0_ERead(0xcc, 0x2D, &read_vol_mif);
	} else if ((0 <= read_id) && (read_id <= 0x5)) {
		IIC0_ERead(0xcc, 0x33, &read_vol_mif);
		IIC0_ERead(0xcc, 0x35, &read_vol_arm);
		IIC0_ERead(0xcc, 0x3E, &read_vol_int);
		IIC0_ERead(0xcc, 0x47, &read_vol_g3d);
	} else {
		IIC0_ERead(0x12, 0x11, &read_vol_mif);
		IIC0_ERead(0x12, 0x14, &read_vol_arm);
		IIC0_ERead(0x12, 0x1E, &read_vol_int);
		IIC0_ERead(0x12, 0x28, &read_vol_g3d);
	}

	printf("vol_arm: %X\n", read_vol_arm);
	printf("vol_int: %X\n", read_vol_int);
	printf("vol_g3d: %X\n", read_vol_g3d);
	printf("vol_mif: %X\n", read_vol_mif);

	smc9115_pre_init();

	gd->bd->bi_boot_params = (PHYS_SDRAM_1 + 0x100UL);

	printf("\nChecking Boot Mode ...");
	switch (OmPin) {
		case BOOT_ONENAND:
			printf(" OneNand\n");
			break;
		case BOOT_NAND:
			printf(" NAND\n");
			break;
		case BOOT_MMCSD:
			printf(" SDMMC\n");
			break;
		case BOOT_EMMC:
			printf(" EMMC4.3\n");
			break;
		case BOOT_EMMC_4_4:
			printf(" EMMC4.41\n");
			break;
		default:
			break;
	}

	return 0;
}

int dram_init(void)
{
	gd->ram_size = get_ram_size((long *)PHYS_SDRAM_1, PHYS_SDRAM_1_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_2, PHYS_SDRAM_2_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_3, PHYS_SDRAM_3_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_4, PHYS_SDRAM_4_SIZE);
#ifdef  USE_2G_DRAM
	gd->ram_size += get_ram_size((long *)PHYS_SDRAM_5, PHYS_SDRAM_5_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_6, PHYS_SDRAM_6_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_7, PHYS_SDRAM_7_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_8, PHYS_SDRAM_8_SIZE);
#endif
	return 0;
}

void dram_init_banksize(void)
{
	gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
	gd->bd->bi_dram[0].size = get_ram_size((long *)PHYS_SDRAM_1, \
							PHYS_SDRAM_1_SIZE);
	gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
	gd->bd->bi_dram[1].size = get_ram_size((long *)PHYS_SDRAM_2, \
							PHYS_SDRAM_2_SIZE);
	gd->bd->bi_dram[2].start = PHYS_SDRAM_3;
	gd->bd->bi_dram[2].size = get_ram_size((long *)PHYS_SDRAM_3, \
							PHYS_SDRAM_3_SIZE);
	gd->bd->bi_dram[3].start = PHYS_SDRAM_4;
	gd->bd->bi_dram[3].size = get_ram_size((long *)PHYS_SDRAM_4, \
							PHYS_SDRAM_4_SIZE);
#ifdef  USE_2G_DRAM
	gd->bd->bi_dram[4].start = PHYS_SDRAM_5;
	gd->bd->bi_dram[4].size = get_ram_size((long *)PHYS_SDRAM_5, \
							PHYS_SDRAM_5_SIZE);
	gd->bd->bi_dram[5].start = PHYS_SDRAM_6;
	gd->bd->bi_dram[5].size = get_ram_size((long *)PHYS_SDRAM_6, \
							PHYS_SDRAM_6_SIZE);
	gd->bd->bi_dram[6].start = PHYS_SDRAM_7;
	gd->bd->bi_dram[6].size = get_ram_size((long *)PHYS_SDRAM_7, \
							PHYS_SDRAM_7_SIZE);
	gd->bd->bi_dram[7].start = PHYS_SDRAM_8;
	gd->bd->bi_dram[7].size = get_ram_size((long *)PHYS_SDRAM_8, \
							PHYS_SDRAM_8_SIZE);
#endif
}

int board_eth_init(bd_t *bis)
{
	int rc = 0;
#ifdef CONFIG_SMC911X
	rc = smc911x_initialize(0, CONFIG_SMC911X_BASE);
#endif
	return rc;
}

#ifdef CONFIG_DISPLAY_BOARDINFO
int checkboard(void)
{
#ifdef CONFIG_EXYNOS4412
	printf("\nBoard: SMDK4412\n");
#else
	printf("\nBoard: SMDK4212\n");
#endif
	return 0;
}
#endif

#ifdef CONFIG_GENERIC_MMC
int board_mmc_init(bd_t *bis)
{
	int i, err, OmPin;
	u32 clock;

	OmPin = readl(EXYNOS4_POWER_BASE + INFORM3_OFFSET);

	/*
	 * MMC2 SD card GPIO:
	 *
	 * GPK2[0]	SD_2_CLK(2)
	 * GPK2[1]	SD_2_CMD(2)
	 * GPK2[2]	SD_2_CDn
	 * GPK2[3:6]	SD_2_DATA[0:3](2)
	 */
	for (i = 0; i < 7; i++) {
		/* GPK2[0:6] special function 2 */
		s5p_gpio_cfg_pin(&gpio2->k2, i, GPIO_FUNC(0x2));

		/* GPK2[0:6] drv 4x */
		s5p_gpio_set_drv(&gpio2->k2, i, GPIO_DRV_4X);

		/* GPK2[0:1] pull disable */
		if (i == 0 || i == 1) {
			s5p_gpio_set_pull(&gpio2->k2, i, GPIO_PULL_NONE);
			continue;
		}

		/* GPK2[2:6] pull up */
		s5p_gpio_set_pull(&gpio2->k2, i, GPIO_PULL_UP);
	}

	/*
	 * MMC4 MSHC GPIO:
	 *
	 * GPK0[0]	SD_4_CLK
	 * GPK0[1]	SD_4_CMD
	 * GPK0[2]	SD_4_CDn
	 * GPK0[3:6]	SD_4_DATA[0:3]
	 * GPK1[3:6]	SD_4_DATA[4:7]
	 */
	for (i = 0; i < 7; i++) {
		/* GPK0[0:6] special function 3 */
		s5p_gpio_cfg_pin(&gpio2->k0, i, GPIO_FUNC(0x3));

		/* GPK0[0:6] drv 4x */
		s5p_gpio_set_drv(&gpio2->k0, i, GPIO_DRV_4X);

		/* GPK0[0:1] pull disable */
		if (i == 0 || i == 1) {
			s5p_gpio_set_pull(&gpio2->k0, i, GPIO_PULL_NONE);
			continue;
		}

		/* GPK0[2:6] pull up */
		s5p_gpio_set_pull(&gpio2->k0, i, GPIO_PULL_UP);
	}

	for (i = 3; i < 7; i++) {
		/* GPK1[3:6] special function 3 */
		s5p_gpio_cfg_pin(&gpio2->k1, i, GPIO_FUNC(0x4));

		/* GPK1[3:6] drv 4x */
		s5p_gpio_set_drv(&gpio2->k1, i, GPIO_DRV_4X);

		/* GPK1[3:6] pull up */
		s5p_gpio_set_pull(&gpio2->k1, i, GPIO_PULL_UP);
	}

	/* Drive Strength */
	writel(0x00010001, 0x1255009C);

	clock = get_pll_clk(MPLL)/1000000;
	for(i=0 ; i<=0xf; i++)
	{
		if((clock /(i+1)) <= 400) {
			set_mmc_clk(4, i);
			break;
		}
	}

	switch (OmPin) {
	case BOOT_EMMC_4_4:
		err = s5p_mmc_init(4, 8);
		if (err)
			printf("MSHC Channel 4 init failed!!!\n");
		err = s5p_mmc_init(2, 4);
		if (err)
			printf("SDHC Channel 2 init failed!!!\n");

		break;
	default:
		err = s5p_mmc_init(2, 4);
		if (err)
			printf("MSHC Channel 2 init failed!!!\n");
		err = s5p_mmc_init(4, 8);
		if (err)
			printf("SDHC Channel 4 init failed!!!\n");

		break;
	}

}
#endif

int board_late_init(void)
{
	struct exynos4_power *pmu = (struct exynos4_power *)EXYNOS4_POWER_BASE;
	struct exynos4_gpio_part2 *gpio2 =
		(struct exynos4_gpio_part2 *) samsung_get_base_gpio_part2();
	int second_boot_info = readl(CONFIG_SECONDARY_BOOT_INFORM_BASE);
	int err;

	err = exynos_pinmux_config(PERIPH_ID_INPUT_X0_0, PINMUX_FLAG_NONE);
	if (err) {
		debug("GPX0_0 INPUT not configured\n");
		return err;
	}

	udelay(10);
	if ((s5p_gpio_get_value(&gpio2->x0, 0) == 0) || second_boot_info == 1) {
		printf("###Recovery Boot Mode###\n");
		setenv("bootcmd", CONFIG_RECOVERYCOMMAND);
		/* clear secondary boot inform */
		writel(0x0, CONFIG_SECONDARY_BOOT_INFORM_BASE);
	}

	if ((readl(&pmu->inform4)) == CONFIG_FACTORY_RESET_MODE) {
		writel(0x0, &pmu->inform4);
		setenv("bootcmd", CONFIG_FACTORY_RESET_BOOTCOMMAND);
	}

	return 0;
}
