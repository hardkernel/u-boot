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
#include <asm/arch/clock.h>
#include <asm/arch/power.h>
#include <asm/arch/gpio.h>
#include <asm/arch/mmc.h>
#include <asm/arch/pinmux.h>
#include <asm/arch/sromc.h>
#include <asm/arch/pmic.h>
#include <asm/arch/sysreg.h>
#include "board_rev.h"

DECLARE_GLOBAL_DATA_PTR;
unsigned int pmic;

#ifdef CONFIG_SMC911X
static int smc9115_pre_init(void)
{
	u32 smc_bw_conf, smc_bc_conf;
	int err;

	/* Ethernet needs data bus width of 16 bits */
	smc_bw_conf = SROMC_DATA16_WIDTH(CONFIG_ENV_SROM_BANK)
			| SROMC_BYTE_ENABLE(CONFIG_ENV_SROM_BANK);

	smc_bc_conf = SROMC_BC_TACS(0x01) | SROMC_BC_TCOS(0x01)
			| SROMC_BC_TACC(0x06) | SROMC_BC_TCOH(0x01)
			| SROMC_BC_TAH(0x0C)  | SROMC_BC_TACP(0x09)
			| SROMC_BC_PMC(0x01);

	/* Select and configure the SROMC bank */
	err = exynos_pinmux_config(PERIPH_ID_SROMC,
				CONFIG_ENV_SROM_BANK | PINMUX_FLAG_16BIT);
	if (err) {
		debug("SROMC not configured\n");
		return err;
	}

	s5p_config_sromc(CONFIG_ENV_SROM_BANK, smc_bw_conf, smc_bc_conf);
	return 0;
}
#endif

static void i2c_interrupt_src_init(void)
{
	struct exynos5_sysreg *sysreg =
		(struct exynos5_sysreg *)samsung_get_base_sysreg();

	/* I2C interrupt source is for i2c, not for USI */
	writel(0x0, (unsigned int)&sysreg->i2c_cfg);

}

static void display_bl1_version(void)
{
	char bl1_version[9] = {0};

	/* display BL1 version */
	printf("\nTrustZone Enabled BSP");
	strncpy(&bl1_version[0], (char *)0x0204f810, 8);
	printf("\nBL1 version: %s\n", &bl1_version[0]);
}

static void display_pmic_info(void)
{
	unsigned char read_vol_arm;
	unsigned char read_vol_int;
	unsigned char read_vol_g3d;
	unsigned char read_vol_mif;
	unsigned char read_vol_mem;
	unsigned char read_vol_apll;
	unsigned char pmic_id;

	/* read ID */
	IIC0_ERead(MAX8997_ADDR, MAX8997_ID, &pmic_id);

	if (pmic_id == 0x77) {
		/* MAX8997 */
		printf("PMIC: MAX8997\n");
		pmic = SMDK5250_REGULATOR_MAX8997;
		IIC0_ERead(MAX8997_ADDR, MAX8997_BUCK1TV_DVS, &read_vol_arm);
		IIC0_ERead(MAX8997_ADDR, MAX8997_BUCK2TV_DVS, &read_vol_int);
		IIC0_ERead(MAX8997_ADDR, MAX8997_BUCK3TV_DVS, &read_vol_g3d);
		IIC0_ERead(MAX8997_ADDR, MAX8997_BUCK4TV_DVS, &read_vol_mif);
		IIC0_ERead(MAX8997_ADDR, MAX8997_LDO10CTRL, &read_vol_apll);

		printf("ARM: %dmV\t", ((unsigned int)read_vol_arm * 25) + 650);
		printf("INT: %dmV\t", ((unsigned int)read_vol_int * 25) + 650);
		printf("G3D: %dmV\n", ((unsigned int)read_vol_g3d * 50) + 750);
		printf("MIF: %dmV\t", ((unsigned int)read_vol_mif * 25) + 650);
		printf("APLL: %dmV\n",	((unsigned int)(read_vol_apll & 0x3F)
					* 50) + 800);
	} else if (pmic_id >= 0x0 && pmic_id <= 0x5) {
		/* S5M8767 */
		printf("PMIC: S5M8767\n");
		pmic = SMDK5250_REGULATOR_S5M8767;
	} else {
		/* MAX77686 */
		printf("PMIC: MAX77686\n");
		pmic = SMDK5250_REGULATOR_MAX77686;
		IIC0_ERead(MAX77686_ADDR, MAX77686_BUCK2TV_DVS1, &read_vol_arm);
		IIC0_ERead(MAX77686_ADDR, MAX77686_BUCK3TV_DVS1, &read_vol_int);
		IIC0_ERead(MAX77686_ADDR, MAX77686_BUCK4TV_DVS1, &read_vol_g3d);
		IIC0_ERead(MAX77686_ADDR, MAX77686_BUCK1OUT, &read_vol_mif);
		IIC0_ERead(MAX77686_ADDR, MAX77686_BUCK5OUT, &read_vol_mem);

		printf("ARM: %dmV\t", ((unsigned int)(read_vol_arm >> 1) * 25) + 600);
		printf("INT: %dmV\t", ((unsigned int)(read_vol_int >> 1) * 25) + 600);
		printf("G3D: %dmV\n", ((unsigned int)(read_vol_g3d >> 1)* 25) + 600);
		printf("MIF: %dmV\t", ((unsigned int)(read_vol_mif & 0x3F) * 50) + 750);
		printf("MEM: %dmV\n", ((unsigned int)(read_vol_mem & 0x3F) * 50) + 750);

	}
}

static void display_boot_device_info(void)
{
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;
	int OmPin;

	OmPin = readl(&pmu->inform3);

	printf("\nChecking Boot Mode ...");

	if (OmPin == BOOT_MMCSD) {
		printf(" SDMMC\n");
	} else if (OmPin == BOOT_EMMC) {
		printf(" EMMC\n");
	} else if (OmPin == BOOT_EMMC_4_4) {
		printf(" EMMC\n");
	} else {
		printf(" Please check OM_pin\n");
	}
}

int board_init(void)
{
	display_bl1_version();

	display_pmic_info();

	display_boot_device_info();

	gd->bd->bi_boot_params = (PHYS_SDRAM_1 + 0x100UL);

	i2c_interrupt_src_init();

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
#ifdef CONFIG_SMC911X
	if (smc9115_pre_init())
		return -1;
	return smc911x_initialize(0, CONFIG_SMC911X_BASE);
#endif
	return 0;
}

#ifdef CONFIG_DISPLAY_BOARDINFO
int checkboard(void)
{
	printf("\nBoard: SMDK5250\n");

	return 0;
}
#endif

#ifdef CONFIG_GENERIC_MMC
int board_mmc_init(bd_t *bis)
{
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;
	int err, OmPin;

	OmPin = readl(&pmu->inform3);

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

	switch (OmPin) {
	case BOOT_EMMC_4_4:
#if defined(USE_MMC0)
		set_mmc_clk(PERIPH_ID_SDMMC0, 1);

		err = s5p_mmc_init(PERIPH_ID_SDMMC0, 8);
#endif
#if defined(USE_MMC2)
		set_mmc_clk(PERIPH_ID_SDMMC2, 1);

		err = s5p_mmc_init(PERIPH_ID_SDMMC2, 4);
#endif
		break;
	default:
#if defined(USE_MMC2)
		set_mmc_clk(PERIPH_ID_SDMMC2, 1);

		err = s5p_mmc_init(PERIPH_ID_SDMMC2, 4);
#endif
#if defined(USE_MMC0)
		set_mmc_clk(PERIPH_ID_SDMMC0, 1);

		err = s5p_mmc_init(PERIPH_ID_SDMMC0, 8);
#endif
		break;
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
	struct exynos5_gpio_part1 *gpio1 =
		(struct exynos5_gpio_part1 *) samsung_get_base_gpio_part1();
	int err;
	u32 second_boot_info = readl(CONFIG_SECONDARY_BOOT_INFORM_BASE);

	err = exynos_pinmux_config(PERIPH_ID_INPUT_X0_0, PINMUX_FLAG_NONE);
	if (err) {
		debug("GPX0_0 INPUT not configured\n");
		return err;
	}

	udelay(10);
	if ((s5p_gpio_get_value(&gpio1->x0, 0) == 0) || second_boot_info == 1)
		setenv("bootcmd", CONFIG_BOOTCOMMAND2);

	if (second_boot_info == 1)
		printf("###Secondary Boot###\n");

	if((readl(&pmu->sysip_dat0)) == CONFIG_FACTORY_RESET_MODE) {
		writel(0x0, &pmu->sysip_dat0);
		setenv ("bootcmd", CONFIG_FACTORY_RESET_BOOTCOMMAND);
	}

	return 0;
}

unsigned int get_board_rev(void)
{
	struct exynos5_clock *clk = (struct exynos5_clock *)EXYNOS5_CLOCK_BASE;
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;
	unsigned int rev = 0;
	int adc_val = 0;
	unsigned int timeout, con;

	writel(0x7, &pmu->isp_configuration);
	timeout = 1000;
	while ((readl(&pmu->isp_status) & 0x7) != 0x7) {
		if (timeout == 0)
			printf("A5 power on failed1\n");
		timeout--;
		udelay(1);
		goto err_power;
	}
	writel(0x1, MTCADC_PHY_CONTROL);

	writel(0x00000031, &clk->div_isp0);
	writel(0x00000031, &clk->div_isp1);
	writel(0x00000001, &clk->div_isp2);

	writel(0xDFF000FF, &clk->gate_ip_isp0);
	writel(0x00003007, &clk->gate_ip_isp1);

	/* SELMUX Channel 3 */
	writel(ADCCON_SELMUX(3), FIMC_IS_ADC_BASE + ADCMUX);

	con = readl(FIMC_IS_ADC_BASE + ADCCON);
	con &= ~ADCCON_MUXMASK;
	con &= ~ADCCON_STDBM;
	con &= ~ADCCON_STARTMASK;
	con |=  ADCCON_PRSCEN;

	/* ENABLE START */
	con |= ADCCON_ENABLE_START;
	writel(con, FIMC_IS_ADC_BASE + ADCCON);

	udelay (50);

	/* Read Data*/
	adc_val = readl(FIMC_IS_ADC_BASE + ADCDAT0) & 0xFFF;
	/* CLRINT */
	writel(0, FIMC_IS_ADC_BASE + ADCCLRINT);

	rev = (adc_val < SMDK5250_REV_0_2_ADC_VALUE/2) ?
			SMDK5250_REV_0_0 : SMDK5250_REV_0_2;

err_power:
	rev &= SMDK5250_REV_MASK;
	pmic = (pmic & SMDK5250_REGULATOR_MASK) << SMDK5250_REGULATOR_SHIFT;

	return (rev | pmic);
}
