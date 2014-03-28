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

#define DEBOUNCE_DELAY	10000

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

#if defined(CONFIG_BOARD_HARDKERNEL)
	IIC0_ERead(0x09, 0x11, &read_vol_mif);
	IIC0_ERead(0x09, 0x1D, &read_vol_arm);
	IIC0_ERead(0x09, 0x28, &read_vol_int);
	IIC0_ERead(0x09, 0x38, &read_vol_g3d);
	IIC0_ERead(0x09, 0x45, &read_vol_kfc);
#else
	IIC0_ERead(0xcc, 0x26, &read_vol_mif);
	IIC0_ERead(0xcc, 0x28, &read_vol_arm);
	IIC0_ERead(0xcc, 0x2a, &read_vol_int);
	IIC0_ERead(0xcc, 0x2c, &read_vol_g3d);
	IIC0_ERead(0xcc, 0x34, &read_vol_kfc);
#endif
     
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

    #if defined(CONFIG_BOARD_HARDKERNEL)
        IIC0_ERead(0x09, 0x00, &read_pmic_id);
        printf("PMIC VER : %X, CHIP REV : %X\n", (read_pmic_id & 0x78) >> 3, (read_pmic_id & 0x07));
    	printf("VDD MIF : %d.%05dV\n", (read_vol_mif * 625 + 61250) / 100000, (read_vol_mif * 625 + 61250) % 100000);
    	printf("VDD ARM : %d.%05dV\n", (read_vol_arm * 625 + 60000) / 100000, (read_vol_arm * 625 + 60000) % 100000);
    	printf("VDD INT : %d.%05dV\n", (read_vol_int * 625 + 60000) / 100000, (read_vol_int * 625 + 60000) % 100000);
    	printf("VDD G3D : %d.%05dV\n", (read_vol_g3d * 625 + 60000) / 100000, (read_vol_g3d * 625 + 60000) % 100000);
    	printf("VDD KFC : %d.%05dV\n", (read_vol_kfc * 625 + 61250) / 100000, (read_vol_kfc * 625 + 61250) % 100000);
    #else    	
    	printf("vol_mif: %x\n", read_vol_mif);
    	printf("vol_arm: %x\n", read_vol_arm);
    	printf("vol_int: %x\n", read_vol_int);
    	printf("vol_g3d: %x\n", read_vol_g3d);
    	printf("vol_kfc: %x\n", read_vol_kfc);    
	#endif

#endif

	/* legacy - need to check */
	*(unsigned int *)0x10050234 = 0;

	gd->bd->bi_arch_number = CONFIG_MACH_TYPE;

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
    if(!strncmp(partition, "kernel", sizeof("kernel")))     run_command("movi write kernel 0 40008000", 0);
    else    {
    	if (OmPin == BOOT_EMMC_4_4 || OmPin == BOOT_EMMC)   run_command("emmc open 0", 0);

        if(!strncmp(partition, "bootloader",    sizeof("bootloader")))  run_command("movi w z u 0 40008000", 0);
        if(!strncmp(partition, "bl1",           sizeof("bl1")))         run_command("movi w z f 0 40008000", 0);
        if(!strncmp(partition, "bl2",           sizeof("bl2")))         run_command("movi w z b 0 40008000", 0);
        if(!strncmp(partition, "tzsw",          sizeof("tzsw")))        run_command("movi w z t 0 40008000", 0);

    	if (OmPin == BOOT_EMMC_4_4 || OmPin == BOOT_EMMC)   run_command("emmc close 0", 0);
    }
}

#define OPTION_ERASE_USERDATA   0x01
#define OPTION_ERASE_FAT        0x02
#define OPTION_ERASE_ENV        0x04
#define OPTION_UPDATE_UBOOT     0x08
#define CLK_DIV_TOP0 0x10020510
#define CLK_SRC_TOP0 0x10020210
#define CLK_SRC_TOP2 0x10020218
#define CLK_SRC_TOP3 0x1002021C
#define CLK_DIV_DISP10 0x1002052C

int board_late_init(void)
{
        unsigned int    reg;
	struct exynos5_power *pmu = (struct exynos5_power *)EXYNOS5_POWER_BASE;

	reg = readl(CLK_SRC_TOP0);
	reg |= (0x1 << 12 | 0x1 <<20);
	reg &= ~((0x1 << 16) | (0x1 <<8));
	writel(reg, CLK_SRC_TOP0);
	reg = readl(CLK_SRC_TOP2);
	reg |= 0x1 << 16;
	reg |= 0x1 << 10;
	writel(reg, CLK_SRC_TOP2);
	reg = readl(CLK_SRC_TOP3);
	reg |= 0x1 << 4 | 0x1 <<5 | 0x1 | 0x1 << 17 | 0x1 << 18 | 0x1 << 19 | 0x1 <<24 | 0x1 << 26  | 0x1 << 8;
	writel(reg, CLK_SRC_TOP3);
	reg = readl(CLK_DIV_DISP10);
	reg |= 0xf << 28;
	writel(reg, CLK_DIV_DISP10);

#ifdef CONFIG_RAMDUMP_MODE
	struct exynos5_gpio_part1 *gpio1 =
		(struct exynos5_gpio_part1 *)samsung_get_base_gpio_part1();
	unsigned int gpio_debounce_cnt = 0;
	int err;

	err = exynos_pinmux_config(PERIPH_ID_INPUT_X0_0, PINMUX_FLAG_NONE);
	if (err) {
		debug("GPX0_0 INPUT not configured\n");
		return err;
	}

	while (s5p_gpio_get_value(&gpio1->x0, 0) == 0) {
		/* wait for 50ms */
		if (gpio_debounce_cnt < 5) {
			udelay(DEBOUNCE_DELAY);
			gpio_debounce_cnt++;
		} else {
			setenv("bootcmd", CONFIG_BOOTCOMMAND_RAMDUMP);
			break;
		}
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

#if defined(CONFIG_BOARD_HARDKERNEL)
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
                
                if(filecheck("zImage"))         update_raw_image("kernel");

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
#else
	if ((readl(&pmu->sysip_dat0)) == CONFIG_FACTORY_RESET_MODE) {
		writel(0x0, &pmu->sysip_dat0);
		setenv("bootcmd", CONFIG_FACTORY_RESET_BOOTCOMMAND);
	}
	
#endif

	return 0;
}
