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

unsigned int OmPin;

DECLARE_GLOBAL_DATA_PTR;
extern int nr_dram_banks;
#ifdef CONFIG_EVT1
unsigned int dmc_density = 0xffffffff;
#endif
unsigned int second_boot_info = 0xffffffff;

/* ------------------------------------------------------------------------- */
#define SMC9115_Tacs	(0x0)	// 0clk		address set-up
#define SMC9115_Tcos	(0x4)	// 4clk		chip selection set-up
#define SMC9115_Tacc	(0xe)	// 14clk	access cycle
#define SMC9115_Tcoh	(0x1)	// 1clk		chip selection hold
#define SMC9115_Tah	(0x4)	// 4clk		address holding time
#define SMC9115_Tacp	(0x6)	// 6clk		page mode access cycle
#define SMC9115_PMC	(0x0)	// normal(1data)page mode configuration

#define SROM_DATA16_WIDTH(x)	(1<<((x*4)+0))
#define SROM_WAIT_ENABLE(x)	(1<<((x*4)+1))
#define SROM_BYTE_ENABLE(x)	(1<<((x*4)+2))

/*
 * Miscellaneous platform dependent initialisations
 */
static void smc9115_pre_init(void)
{
        unsigned int cs1;
	/* gpio configuration */
	writel(0x00000020, 0x11000000 + 0x120);

	/* 16 Bit bus width */
	writel(0x22222222, 0x11000000 + 0x1C0);
	writel(0x22222222, 0x11000000 + 0x1E0);

	/* SROM BANK1 */
        cs1 = SROM_BW_REG & ~(0xF<<4);
	cs1 |= ((1 << 0) |
		(0 << 2) |
		(1 << 3)) << 4;                

        SROM_BW_REG = cs1;

	/* set timing for nCS1 suitable for ethernet chip */
	SROM_BC1_REG = ( (0x1 << 0) |
		     (0x9 << 4) |
		     (0xc << 8) |
		     (0x1 << 12) |
		     (0x6 << 16) |
		     (0x1 << 24) |
		     (0x1 << 28) );
}

int board_init(void)
{
        #ifdef CONFIG_SMC911X
   	        smc9115_pre_init();
        #endif

	if(((PRO_ID & 0x300) >> 8) == 2)
		gd->bd->bi_arch_number = MACH_TYPE_C210;
	else
		gd->bd->bi_arch_number = MACH_TYPE_V310;

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
		printf(" EMMC4.3\n");
	} else if (OmPin == BOOT_EMMC_4_4) {
		printf(" EMMC4.41\n");
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
	if(((PRO_ID & 0x300) >> 8) == 2){
#ifdef CONFIG_EVT1
		printf("EVT1 ");
		if(dmc_density == 6){
			printf("POP_B\n");
			nr_dram_banks = 4;
			gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
			gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;
			gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
			gd->bd->bi_dram[1].size = PHYS_SDRAM_2_SIZE;
			gd->bd->bi_dram[2].start = PHYS_SDRAM_3;
			gd->bd->bi_dram[2].size = PHYS_SDRAM_3_SIZE;
			gd->bd->bi_dram[3].start = PHYS_SDRAM_4;
			gd->bd->bi_dram[3].size = PHYS_SDRAM_4_SIZE;
		}
		else if(dmc_density == 5){
			printf("POP_A\n");
			nr_dram_banks = 2;
			gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
			gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;
			gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
			gd->bd->bi_dram[1].size = PHYS_SDRAM_2_SIZE;
		}
		else{
			printf("unknown POP type\n");
			nr_dram_banks = 2;
			gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
			gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;
			gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
			gd->bd->bi_dram[1].size = PHYS_SDRAM_2_SIZE;
		}
#else
		nr_dram_banks = 2;
		gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
		gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;
		gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
		gd->bd->bi_dram[1].size = PHYS_SDRAM_2_SIZE;
#endif
	}
	else{
		nr_dram_banks = 8;
		gd->bd->bi_dram[0].start = PHYS_SDRAM_1;
		gd->bd->bi_dram[0].size = PHYS_SDRAM_1_SIZE;
		gd->bd->bi_dram[1].start = PHYS_SDRAM_2;
		gd->bd->bi_dram[1].size = PHYS_SDRAM_2_SIZE;
		gd->bd->bi_dram[2].start = PHYS_SDRAM_3;
		gd->bd->bi_dram[2].size = PHYS_SDRAM_3_SIZE;
		gd->bd->bi_dram[3].start = PHYS_SDRAM_4;
		gd->bd->bi_dram[3].size = PHYS_SDRAM_4_SIZE;
		gd->bd->bi_dram[4].start = PHYS_SDRAM_5;
		gd->bd->bi_dram[4].size = PHYS_SDRAM_5_SIZE;
		gd->bd->bi_dram[5].start = PHYS_SDRAM_6;
		gd->bd->bi_dram[5].size = PHYS_SDRAM_6_SIZE;
		gd->bd->bi_dram[6].start = PHYS_SDRAM_7;
		gd->bd->bi_dram[6].size = PHYS_SDRAM_7_SIZE;
		gd->bd->bi_dram[7].start = PHYS_SDRAM_8;
		gd->bd->bi_dram[7].size = PHYS_SDRAM_8_SIZE;
	}

#ifdef CONFIG_TRUSTZONE
	gd->bd->bi_dram[nr_dram_banks - 1].size -= CONFIG_TRUSTZONE_RESERVED_DRAM;
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
	printf("Board:\tSMDKV310\n");
	
	return 0;

}
#endif

int board_late_init (void)
{
	GPIO_Init();
	GPIO_SetFunctionEach(eGPIO_X0, eGPIO_0, 0);
	GPIO_SetPullUpDownEach(eGPIO_X0, eGPIO_0, 0);

	udelay(10);
	if (GPIO_GetDataEach(eGPIO_X0, eGPIO_0) == 0 || second_boot_info == 1){
		setenv ("bootcmd", CONFIG_BOOTCOMMAND2);
	}
	return 0;
}

int board_mmc_init(bd_t *bis)
{
#ifdef CONFIG_S3C_HSMMC
	setup_hsmmc_clock();
	setup_hsmmc_cfg_gpio();
	if (OmPin == BOOT_EMMC_4_4 || OmPin == BOOT_EMMC) {
#ifdef CONFIG_S5PC210
		smdk_s5p_mshc_init();
#endif
		smdk_s3c_hsmmc_init();
	} else {
		smdk_s3c_hsmmc_init();
#ifdef CONFIG_S5PC210
		smdk_s5p_mshc_init();
#endif
	}
#endif
	return 0;
}

#ifdef CONFIG_ENABLE_MMU
ulong virt_to_phy_s5pv310(ulong addr)
{
	if ((0xc0000000 <= addr) && (addr < 0xe0000000))
		return (addr - 0xc0000000 + 0x40000000);

	return addr;
}
#endif

