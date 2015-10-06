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
 
/* ------------------------------------------------------------------------- */
#define DM9000_Tacs	(0x0)	// 0clk		address set-up
#define DM9000_Tcos	(0x4)	// 4clk		chip selection set-up
#define DM9000_Tacc	(0xE)	// 14clk	access cycle
#define DM9000_Tcoh	(0x1)	// 1clk		chip selection hold
#define DM9000_Tah	(0x4)	// 4clk		address holding time
#define DM9000_Tacp	(0x6)	// 6clk		page mode access cycle
#define DM9000_PMC	(0x0)	// normal(1data)page mode configuration

#ifdef CONFIG_DRIVER_DM9000
extern int dm9000_initialize(bd_t *bis);
#endif

/*
 * Miscellaneous platform dependent initialisations
 */

static void dm9000_pre_init(void)
{
	unsigned int tmp;

#if defined(DM9000_16BIT_DATA)
	SROM_BW_REG &= ~(0xf << 20);
	SROM_BW_REG |= (0<<23) | (0<<22) | (0<<21) | (1<<20);

#else	
	SROM_BW_REG &= ~(0xf << 20);
	SROM_BW_REG |= (0<<19) | (0<<18) | (0<<16);
#endif
	SROM_BC5_REG = ((0<<28)|(1<<24)|(5<<16)|(1<<12)|(4<<8)|(6<<4)|(0<<0));

	tmp = MP01CON_REG;
	tmp &=~(0xf<<20);
	tmp |=(2<<20);
	MP01CON_REG = tmp;
}
 
int board_init(void)
{
#ifdef CONFIG_DRIVER_DM9000
	dm9000_pre_init();
#endif

	gd->bd->bi_arch_number = MACH_TYPE;
	gd->bd->bi_boot_params = (PHYS_SDRAM_1+0x100);

   	OmPin = INF_REG3_REG;
	printf("\n\nChecking Boot Mode ...");
	if(OmPin == BOOT_ONENAND) {
		printf(" OneNand\n");
	} else if (OmPin == BOOT_NAND) {
		printf(" NAND\n");
	} else if (OmPin == BOOT_MMCSD) {
		printf(" SDMMC\n");
	} else if (OmPin == BOOT_EMMC) {
		printf(" EMMC\n");
	}

	return 0;
}

int dram_init(void)
{
//	gd->ram_size = get_ram_size((long *)PHYS_SDRAM_1, PHYS_SDRAM_1_SIZE);
	
	return 0;
}

void dram_init_banksize(void)
{
	nr_dram_banks = 1;
	gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
	gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;

#if defined(CONFIG_SPARSEMEM)
#if defined(CONFIG_MCP_B)
        nr_dram_banks = 2;
	gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
	gd->bd->bi_dram[1].size = PHYS_SDRAM_2_SIZE;
#elif defined(CONFIG_MCP_D)
        nr_dram_banks = 3;
	gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
	gd->bd->bi_dram[1].size = PHYS_SDRAM_2_SIZE;
	gd->bd->bi_dram[2].start = PHYS_SDRAM_3;
	gd->bd->bi_dram[2].size = PHYS_SDRAM_3_SIZE;
#endif
#endif
}

#ifdef CONFIG_DRIVER_DM9000
int board_eth_init(bd_t *bis)
{
	return dm9000_initialize(bis);
}
#endif

#ifdef CONFIG_DISPLAY_BOARDINFO
int checkboard(void)
{
	printf("Board:\tSMDKV310\n");
	
	return 0;

}
#endif

int board_late_init (void)
{
	return 0;
}

int board_mmc_init(bd_t *bis)
{
#ifdef CONFIG_S3C_HSMMC
	setup_hsmmc_clock();
	setup_hsmmc_cfg_gpio();
#ifdef USE_MMC4
	return smdk_s5p_mshc_init();
#else
	return smdk_s3c_hsmmc_init();
#endif
#endif
	return 0;
}

#ifdef CONFIG_ENABLE_MMU
ulong virt_to_phy_s5pc110(ulong addr)
{
	if ((0xc0000000 <= addr) && (addr < 0xe0000000))
		return (addr - 0xc0000000 + CONFIG_SYS_SDRAM_BASE);

	return addr;
}
#endif

