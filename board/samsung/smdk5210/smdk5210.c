/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#include <common.h>
#include <asm/arch/cpu.h>
#include <asm/arch/gpio.h>
#include <asm/arch/pmic.h>

unsigned int OmPin;

DECLARE_GLOBAL_DATA_PTR;
extern int nr_dram_banks;
unsigned int second_boot_info = 0xffffffff;

/*
 * Miscellaneous platform dependent initialisations
 */
static void smc9115_pre_init(void)
{
	unsigned int cs1;
	/* gpio configuration */
	writel(0x00220020, 0x11400000 + 0x1A0);
	writel(0x00002222, 0x11400000 + 0x1C0);

	/* 16 Bit bus width */
	writel(0x22222222, 0x11400000 + 0x200);
	writel(0x0000FFFF, 0x11400000 + 0x208);
	writel(0x22222222, 0x11400000 + 0x240);
	writel(0x0000FFFF, 0x11400000 + 0x248);
	writel(0x22222222, 0x11400000 + 0x260);
	writel(0x0000FFFF, 0x11400000 + 0x268);

	/* SROM BANK1 */
	cs1 = SROM_BW_REG & ~(0xF<<4);
	cs1 |= ((1 << 0) |
		(0 << 2) |
		(1 << 3)) << 4;

	SROM_BW_REG = cs1;

	/* set timing for nCS1 suitable for ethernet chip */
	SROM_BC1_REG = ((0x1 << 0) |
		     (0x9 << 4) |
		     (0xc << 8) |
		     (0x1 << 12) |
		     (0x6 << 16) |
		     (0x1 << 24) |
		     (0x1 << 28));
}

int board_init(void)
{
	u8 read_vol_arm;
	u8 read_vol_int;
	u8 read_vol_g3d;
	u8 read_vol_mif;
	u8 pmic_id;
	char bl1_version[9] = {0};

	/* display BL1 version */
	strncpy(&bl1_version[0], (char *)0x02022fc8, 8);
	printf("\nBL1 version: %s\n", &bl1_version[0]);

#ifdef CONFIG_PM
	/* read ID */
	IIC0_ERead(MAX8997_ADDR, MAX8997_ID, &pmic_id);

	if (pmic_id == 0x77) {
		IIC0_ERead(MAX8997_ADDR, MAX8997_BUCK1TV_DVS, &read_vol_arm);
		IIC0_ERead(MAX8997_ADDR, MAX8997_BUCK2TV_DVS, &read_vol_int);
		IIC0_ERead(MAX8997_ADDR, MAX8997_BUCK3TV_DVS, &read_vol_g3d);
		IIC0_ERead(MAX8997_ADDR, MAX8997_BUCK4TV_DVS, &read_vol_mif);

		printf("ARM: %dmV\t", ((unsigned int)read_vol_arm * 25) + 650);
		printf("INT: %dmV\t", ((unsigned int)read_vol_int * 25) + 650);
		printf("G3D: %dmV\t", ((unsigned int)read_vol_g3d * 50) + 750);
		printf("MIF: %dmV\n", ((unsigned int)read_vol_mif * 25) + 650);
	} else
		printf("PMIC init error\n");
#endif

#ifdef CONFIG_SMC911X
	smc9115_pre_init();
#endif

	gd->bd->bi_arch_number = MACH_TYPE;

	gd->bd->bi_boot_params = (PHYS_SDRAM_1+0x100);

	OmPin = INF_REG3_REG;
	printf("\nChecking Boot Mode ...");
	if(OmPin == BOOT_ONENAND) {
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
	//gd->ram_size = get_ram_size((long *)PHYS_SDRAM_1, PHYS_SDRAM_1_SIZE);

	return 0;
}

void dram_init_banksize(void)
{
		nr_dram_banks = CONFIG_NR_DRAM_BANKS;
		gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
		gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;
		gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
		gd->bd->bi_dram[1].size = PHYS_SDRAM_2_SIZE;
		gd->bd->bi_dram[2].start = PHYS_SDRAM_3;
		gd->bd->bi_dram[2].size = PHYS_SDRAM_3_SIZE;
		gd->bd->bi_dram[3].start = PHYS_SDRAM_4;
		gd->bd->bi_dram[3].size = PHYS_SDRAM_4_SIZE;
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
	printf("Board:\tSMDK5210\n");

	return 0;

}
#endif

int board_late_init (void)
{
	/*
	GPIO_Init();
	GPIO_SetFunctionEach(eGPIO_X0, eGPIO_0, 0);
	GPIO_SetPullUpDownEach(eGPIO_X0, eGPIO_0, 0);

	udelay(10);
	if (GPIO_GetDataEach(eGPIO_X0, eGPIO_0) == 0 || second_boot_info == 1){
		setenv ("bootcmd", CONFIG_BOOTCOMMAND2);
	}
	*/
	return 0;
}

int board_mmc_init(bd_t *bis)
{
#ifdef CONFIG_S3C_HSMMC
	setup_hsmmc_clock();
	setup_hsmmc_cfg_gpio();
	if (OmPin == BOOT_EMMC_4_4 || OmPin == BOOT_EMMC) {
		smdk_s5p_mshc_init();
		smdk_s3c_hsmmc_init();
	} else {
		smdk_s3c_hsmmc_init();
		smdk_s5p_mshc_init();
	}
#endif
	return 0;
}

#ifdef CONFIG_ENABLE_MMU
ulong virt_to_phy_exynos5210(ulong addr)
{
	if ((0xc0000000 <= addr) && (addr < 0xe0000000))
		return (addr - 0xc0000000 + 0x40000000);

	return addr;
}
#endif

