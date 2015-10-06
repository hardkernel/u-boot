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

unsigned int OmPin;

DECLARE_GLOBAL_DATA_PTR;
extern int nr_dram_banks;

int dram_init(void)
{
//	gd->ram_size = get_ram_size((long *)PHYS_SDRAM_1, PHYS_SDRAM_1_SIZE);

	return 0;
}

void dram_init_banksize(void)
{

DECLARE_GLOBAL_DATA_PTR;
	nr_dram_banks = 1;
	gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
	gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;

}

static void smc9115_pre_init(void)
{
        unsigned int cs0;

	/* SROM BANK */
        cs0 = SROM_BW_REG & ~(0xF<<4);
	cs0 |= ((1 << 0) |
		(0 << 2) |
		(1 << 3)) << 4;

        SROM_BW_REG = cs0;

	/* set timing for nCS5 suitable for ethernet chip */
	SROM_BC0_REG = ( (0x1 << 0) |
		     (0x9 << 4) |
		     (0xc << 8) |
		     (0x1 << 12) |
		     (0x6 << 16) |
		     (0x1 << 24) |
		     (0x1 << 28) );
}

int board_init(void)
{

	gd->bd->bi_arch_number = MACH_TYPE;

	gd->bd->bi_boot_params = (PHYS_SDRAM_1+0x100);

	smc9115_pre_init();

	OmPin = INF_REG3_REG;

	printf("\n\nChecking Boot Mode ...");

	if (OmPin == BOOT_MMCSD) {
		printf(" SDMMC\n");
	} else if (OmPin == BOOT_EMMC) {
		printf(" EMMC4.3\n");
	} else if (OmPin == BOOT_EMMC_4_4) {
		printf(" EMMC4.4\n");
	} else if (OmPin == BOOT_SEC_DEV) {
		printf(" SDMMC(Secondary Boot)\n");
	}


	return 0;
}

#ifdef CONFIG_NET_MULTI
int board_eth_init(bd_t *bis)
{
	int rc = 0;
	rc = smc911x_initialize(0, CONFIG_SMC911X_BASE);
	return rc;
}
#endif

#ifdef CONFIG_DISPLAY_BOARDINFO
int checkboard(void)
{
#if defined(CONFIG_S5P6460)
	printf("Board:\tSMDK6460\n");
#else
	printf("Board:\tSMDK6450\n");
#endif
	return 0;
}
#endif

int board_mmc_init(bd_t *bis)
{
#ifdef CONFIG_S3C_HSMMC
	setup_hsmmc_clock();
	setup_hsmmc_cfg_gpio();
#ifdef USE_MMC3
	return smdk_s5p_mshc_init();
#else
	return smdk_s3c_hsmmc_init();
#endif
#endif
	return 0;
}

#ifdef CONFIG_ENABLE_MMU
ulong virt_to_phy_s5p6450(ulong addr)
{
	if ((0xc0000000 <= addr) && (addr < 0xe0000000))
		return (addr - 0xc0000000 + CONFIG_SYS_SDRAM_BASE);

	return addr;
}
#endif

