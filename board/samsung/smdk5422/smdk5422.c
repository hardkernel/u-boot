/*
 * Copyright (C) 2013 Samsung Electronics
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
#include <asm/arch/sysreg.h>
#include "pmic.h"
#ifdef CONFIG_CPU_EXYNOS5422_EVT0
#ifdef CONFIG_MACH_UNIVERSAL5422
#include "companion_pmic.h"
#else
#include "pmic_lm3560.h"
#endif
#endif

#define DEBOUNCE_DELAY	10000

#define PRODUCT_ID	(0x10000000 + 0x000)
#define PKG_ID		(0x10000000 + 0x004)

#define Inp32(addr)	(*(volatile u32 *)(addr))
#define GetBits(uAddr, uBaseBit, uMaskValue) \
			((Inp32(uAddr)>>(uBaseBit))&(uMaskValue))
#define GetEvtNum()	(GetBits(PRODUCT_ID, 4, 0xf))
#define GetEvtSubNum()	(GetBits(PRODUCT_ID, 0, 0xf))
#define GetPopOption()	(GetBits(PKG_ID, 4, 0x3))
#define GetDdrType()	(GetBits(PKG_ID, 14, 0x1))

DECLARE_GLOBAL_DATA_PTR;
unsigned int pmic;
unsigned int nr_dram_banks = 0;

static int init_nr_dram_banks(void)
{
	int evt_num = (GetEvtNum()<<12)|(GetEvtSubNum()<<8)|(GetPopOption()<<4)|(GetDdrType());

#ifdef CONFIG_CPU_EXYNOS5422_EVT0
	nr_dram_banks = 8;
#else
	if (evt_num == 0x1020)
		nr_dram_banks = 12;
	else
		nr_dram_banks = 8;
#endif

#if defined(CONFIG_FORCE_DDR3GB) && defined(CONFIG_BOARD_HARDKERNEL)
    nr_dram_banks = 12;		
#endif
}

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

static void display_bl1_version(void)
{
	char bl1_version[9] = {0};

	/* display BL1 version */
#if defined(CONFIG_TRUSTZONE_ENABLE)
	printf("\nTrustZone Enabled BSP");
	strncpy(&bl1_version[0], (char *)(CONFIG_PHY_IRAM_NS_BASE + 0x810), 8);
	printf("\nBL1 version: %s\n", &bl1_version[0]);
#endif
}

static void display_pmic_info(void)
{
	unsigned char read_vol_arm;
	unsigned char read_vol_int;
	unsigned char read_vol_g3d;
	unsigned char read_vol_mif;
	unsigned char read_vol_kfc;
	unsigned char pmic_id;
#ifdef CONFIG_CPU_EXYNOS5422_EVT0
#ifdef CONFIG_MACH_UNIVERSAL5422
	unsigned char read_vol_ldo21;
	unsigned char comp_pmic_reg_0x11;
#else
	unsigned char read_vol_ldo19;
#endif
#endif

	IIC0_ESetport();
	IIC0_ERead(S2MPS11_ADDR, BUCK6_CTRL2, &read_vol_kfc);
	printf("VDD_KFC: 0x%x\n", read_vol_kfc);

#ifdef CONFIG_CPU_EXYNOS5422_EVT0
#ifdef CONFIG_MACH_UNIVERSAL5422
	IIC0_ERead(S2MPS11_ADDR, 0x51, &read_vol_ldo21);
	printf("LDO21: 0x%x\n", read_vol_ldo21);

	IIC3_ESetport();
	/* read companion reg(0x11) value */
	IIC3_ERead(COMP_PMIC_ADDR, COMP_PMIC_REG_ADDR, &comp_pmic_reg_0x11);

	/* clear gpg0 */
	writel(0x0, 0x14000084);

	printf("COMPANION_PMIC(0x%x:0x%x): 0x%x\n",
		COMP_PMIC_ADDR, COMP_PMIC_REG_ADDR, comp_pmic_reg_0x11);
#else
	IIC0_ERead(S2MPS11_ADDR, 0x4F, &read_vol_ldo19);
	printf("LDO19: 0x%x\n", read_vol_ldo19);

	/* setup PMIC lm3560 */
	IIC2_ESetport();
	/* set GPC0[2], GPC0[3] output low */
	*(unsigned int *)0x14000000 &= ~0xFF00;
	*(unsigned int *)0x14000000 |= 0x1100;
	*(unsigned int *)0x14000004 &= ~0xC;
	/* set GPF0[1] output high */
	*(unsigned int *)0x134100E0 &= ~0xF0;
	*(unsigned int *)0x134100E0 |= 0x10;
	*(unsigned int *)0x134100E4 |= 0x2;

	IIC2_EWrite(LM3560_ADDR, 0xE0, 0xEF);
	IIC2_EWrite(LM3560_ADDR, 0xC0, 0xFF);
	IIC2_EWrite(LM3560_ADDR, 0x11, 0x78);
#endif
#endif
}

static void display_boot_device_info(void)
{
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;
	int OmPin;

	OmPin = readl(&pmu->inform3);

	printf("\nChecking Boot Mode ...");

	if (OmPin == BOOT_MMCSD)
		printf(" SDMMC\n");
	else if (OmPin == BOOT_EMMC)
		printf(" EMMC\n");
	else if (OmPin == BOOT_EMMC_4_4)
		printf(" EMMC\n");
	else
		printf(" Please check OM_pin\n");
}

int board_init(void)
{
	init_nr_dram_banks();

	display_bl1_version();

	display_pmic_info();

	display_boot_device_info();

	gd->bd->bi_boot_params = (PHYS_SDRAM_1 + 0x100UL);

#if defined(CONFIG_BOARD_HARDKERNEL)
    // GPX3.3 HDMI Active High for ODROID-XU2
    #define GPX3CON		*(volatile unsigned long *)(0x13400C60)
    #define GPX3DAT		*(volatile unsigned long *)(0x13400C64)
    
    GPX3CON |= 0x00001000;  GPX3DAT |= 0x08;
#endif	

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
			+ get_ram_size((long *)PHYS_SDRAM_7, PHYS_SDRAM_7_SIZE);

	if (nr_dram_banks == 8)
		gd->ram_size += get_ram_size((long *)PHYS_SDRAM_8, PHYS_SDRAM_8_END_SIZE);
	else {
		gd->ram_size += get_ram_size((long *)PHYS_SDRAM_8, PHYS_SDRAM_8_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_9, PHYS_SDRAM_9_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_10, PHYS_SDRAM_10_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_11, PHYS_SDRAM_11_SIZE)
			+ get_ram_size((long *)PHYS_SDRAM_12, PHYS_SDRAM_12_SIZE);
	}

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

	if (nr_dram_banks == 8) {
		gd->bd->bi_dram[7].start = PHYS_SDRAM_8;
		gd->bd->bi_dram[7].size = get_ram_size((long *)PHYS_SDRAM_8,
							PHYS_SDRAM_8_END_SIZE);
	} else if (nr_dram_banks == 12) {
		gd->bd->bi_dram[7].start = PHYS_SDRAM_8;
		gd->bd->bi_dram[7].size = get_ram_size((long *)PHYS_SDRAM_8,
							PHYS_SDRAM_8_SIZE);
		gd->bd->bi_dram[8].start = PHYS_SDRAM_9;
		gd->bd->bi_dram[8].size = get_ram_size((long *)PHYS_SDRAM_9,
							PHYS_SDRAM_9_SIZE);
		gd->bd->bi_dram[9].start = PHYS_SDRAM_10;
		gd->bd->bi_dram[9].size = get_ram_size((long *)PHYS_SDRAM_10,
							PHYS_SDRAM_10_SIZE);
		gd->bd->bi_dram[10].start = PHYS_SDRAM_11;
		gd->bd->bi_dram[10].size = get_ram_size((long *)PHYS_SDRAM_11,
							PHYS_SDRAM_11_SIZE);
		gd->bd->bi_dram[11].start = PHYS_SDRAM_12;
		gd->bd->bi_dram[11].size = get_ram_size((long *)PHYS_SDRAM_12,
							PHYS_SDRAM_12_SIZE);
	}
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
#if defined(CONFIG_MACH_UNIVERSAL5422)
	printf("\nBoard: UNIVERSAL5422\n");
#elif defined(CONFIG_MACH_XYREF5422)
#if defined(CONFIG_BOARD_HARDKERNEL)
	printf("\nBoard: HardKernel ODROID\n");
#else
	printf("\nBoard: XYREF5422\n");
#endif
#else
	printf("\nBoard: SMDK5422\n");
#endif
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
	init_nr_dram_banks();

	return board_uart_init();
}
#endif

#if defined(CONFIG_BOARD_HARDKERNEL)
unsigned int    filecheck(const unsigned char *filename)
{
    unsigned char   cmd[128];
    unsigned long   filesize = 0;
    
    memset(cmd, 0x00, sizeof(cmd));

    // file check & update
	setenv("filesize", "0");
    
    sprintf(cmd, "fatload mmc 0:1 40008000 update/%s", filename);
    
    run_command(cmd, 0);
    
    if((filesize = getenv_ulong("filesize", 16, 0)))    return  1;  // file read success
    
    printf("ERROR! update/%s File Not Found!! filesize = 0\n", filename);

    return  0;  // file read fail
}

void update_image       (const unsigned char *partition)
{
    unsigned char   cmd[128];
    
    memset(cmd, 0x00, sizeof(cmd));
    sprintf(cmd, "fastboot flash %s 40008000 0", partition);
    run_command(cmd, 0);
}

void update_raw_image   (const unsigned char *partition)
{
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;
	int OmPin;

	OmPin = readl(&pmu->inform3);

    if(!strncmp(partition, "kernel", sizeof("kernel")))     run_command("movi write kernel 0 40008000", 0);
    else    {
    	if (OmPin == BOOT_EMMC_4_4 || OmPin == BOOT_EMMC)   {
        	run_command("emmc open 0", 0);
            if(!strncmp(partition, "bootloader",    sizeof("bootloader")))  run_command("movi w z u 0 40008000", 0);
            if(!strncmp(partition, "bl1",           sizeof("bl1")))         run_command("movi w z f 0 40008000", 0);
            if(!strncmp(partition, "bl2",           sizeof("bl2")))         run_command("movi w z b 0 40008000", 0);
            if(!strncmp(partition, "tzsw",          sizeof("tzsw")))        run_command("movi w z t 0 40008000", 0);
            run_command("emmc close 0", 0);
    	}
    	else    {
            if(!strncmp(partition, "bootloader",    sizeof("bootloader")))  run_command("movi w u 0 40008000", 0);
            if(!strncmp(partition, "bl1",           sizeof("bl1")))         run_command("movi w f 0 40008000", 0);
            if(!strncmp(partition, "bl2",           sizeof("bl2")))         run_command("movi w b 0 40008000", 0);
            if(!strncmp(partition, "tzsw",          sizeof("tzsw")))        run_command("movi w t 0 40008000", 0);
    	}
    }
}

#define OPTION_ERASE_USERDATA   0x01
#define OPTION_ERASE_FAT        0x02
#define OPTION_ERASE_ENV        0x04
#define OPTION_UPDATE_UBOOT     0x08

int board_late_init(void)
{
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;

    LED_GREEN(OFF);          LED_BLUE(ON);          LED_RED(OFF);

    if (readl(&pmu->sysip_dat0) & 0xFFFF)     {
        unsigned char   cmd[32];
        unsigned int    reboot_cmd;
        unsigned int    option;
        unsigned long   filesize;
        
        #define INFORM0_REG 0x10040800
        #define INFORM2_REG 0x10040808
        #define INFORM5_REG 0x10040814  /* SYSIP_DAT1 */
        #define INFORM6_REG 0x10040818  /* SYSIP_DAT2 */
        #define INFORM7_REG 0x1004081C  /* SYSIP_DAT3 */
        
        reboot_cmd = readl(&pmu->sysip_dat0);
        writel(0x00, &pmu->sysip_dat0);
        
        option = readl(INFORM0_REG);
        writel(0x00, INFORM0_REG);
        
        memset(cmd, 0x00, sizeof(cmd));
        
        switch(reboot_cmd  & 0xFFFF) {
            case    REBOOT_FASTBOOT:
                sprintf(cmd, "%s", "fastboot");
                run_command(cmd, 0);
                break;
            case    REBOOT_UPDATE:
#if defined(CONFIG_LED_CONTROL)    
                LED_BLUE(ON);
#endif                
                if(filecheck("system.img"))     update_image("system");
                if(filecheck("cache.img"))      update_image("cache");

                if(option & OPTION_ERASE_USERDATA)  {
                    if(filecheck("userdata.img"))   update_image("userdata");
                }                    
                
                if      (filecheck("zImage"))       update_raw_image("kernel");
                else if (filecheck("zImage-dtb"))   update_raw_image("kernel");

                if(option & OPTION_UPDATE_UBOOT)    {
                    if(filecheck("u-boot.bin")) update_raw_image("bootloader");
                    if(filecheck("bl1.bin"))    update_raw_image("bl1");
                    if(filecheck("bl2.bin"))    update_raw_image("bl2");
                    if(filecheck("tzsw.bin"))   update_raw_image("tzsw");
                }
                
                if(option & OPTION_ERASE_ENV)
                    run_command("mmc write 0 40008000 0x4CF 0x20", 0);

                if(option & OPTION_ERASE_FAT)
                    run_command("fatformat mmc 0:1", 0);
            	
#if defined(CONFIG_LED_CONTROL)    
                LED_BLUE(OFF);
#endif                
                break;
            default :
                break;
        }
        
        // Restart system
        memset(cmd, 0x00, sizeof(cmd));
        sprintf(cmd, "%s", "reset");
        run_command(cmd, 0);
    }

	return 0;
}

#else

int board_late_init(void)
{
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;
	unsigned int rst_stat = 0;

	rst_stat = readl(&pmu->rst_stat);
	printf("rst_stat : 0x%x\n", rst_stat);
#ifdef CONFIG_RAMDUMP_MODE
	/* check reset status for ramdump */
	if ((rst_stat & (WRESET | SYS_WDTRESET))
		|| (readl(&pmu->sysip_dat0) == CONFIG_RAMDUMP_MODE)
		|| (readl(CONFIG_RAMDUMP_SCRATCH) == CONFIG_RAMDUMP_MODE)) {
		/* run fastboot */
		run_command("fastboot", 0);
	}
#endif
#ifdef CONFIG_RECOVERY_MODE
	u32 second_boot_info = readl(CONFIG_SECONDARY_BOOT_INFORM_BASE);

	if (second_boot_info == 1) {
		printf("###Recovery Mode###\n");
		writel(0x0, CONFIG_SECONDARY_BOOT_INFORM_BASE);
		setenv("bootcmd", CONFIG_BOOTCOMMAND2);
	}
#endif

	if ((readl(&pmu->sysip_dat0)) == CONFIG_FACTORY_RESET_MODE) {
		writel(0x0, &pmu->sysip_dat0);
		setenv("bootcmd", CONFIG_FACTORY_RESET_BOOTCOMMAND);
	}

	return 0;
}

#endif

unsigned int get_board_rev(void)
{
	unsigned int rev = 0;
	unsigned int board_rev_info;

	board_rev_info = rev | pmic;

	return board_rev_info;
}
