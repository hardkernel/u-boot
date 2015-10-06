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
#include <asm/arch/movi_partition.h>

unsigned int OmPin;

DECLARE_GLOBAL_DATA_PTR;
extern int nr_dram_banks;
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
	writel(0x00220020, 0x11000000 + 0x120);
	writel(0x00002222, 0x11000000 + 0x140);

	/* 16 Bit bus width */
	writel(0x22222222, 0x11000000 + 0x180);
	writel(0x0000FFFF, 0x11000000 + 0x188);
	writel(0x22222222, 0x11000000 + 0x1C0);
	writel(0x0000FFFF, 0x11000000 + 0x1C8);
	writel(0x22222222, 0x11000000 + 0x1E0);
	writel(0x0000FFFF, 0x11000000 + 0x1E8);

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

#define	PS_HOLD		*(volatile unsigned long *)(0x1002330C)

int board_init(void)
{
#if !defined(CONFIG_HKDK4212)
	u8 read_vol_arm;
	u8 read_vol_int;
	u8 read_vol_g3d;
	u8 read_vol_mif;
	u8 buck1_ctrl;
	u8 buck2_ctrl;
	u8 buck3_ctrl;
	u8 buck4_ctrl;
	u8 ldo14_ctrl;
#else	
	unsigned char	rwdata;
#endif	
	char bl1_version[9] = {0};

#if !defined(CONFIG_HKDK4212)
		IIC0_ERead(0xcc, 0x19, &read_vol_arm);
		IIC0_ERead(0xcc, 0x22, &read_vol_int);
		IIC0_ERead(0xcc, 0x2B, &read_vol_g3d);
		//IIC0_ERead(0xcc, 0x2D, &read_vol_mif);
		IIC0_ERead(0xcc, 0x18, &buck1_ctrl);
		IIC0_ERead(0xcc, 0x21, &buck2_ctrl);
		IIC0_ERead(0xcc, 0x2A, &buck3_ctrl);
		//IIC0_ERead(0xcc, 0x2C, &buck4_ctrl);
		IIC0_ERead(0xcc, 0x48, &ldo14_ctrl);

		printf("vol_arm: %X\n", read_vol_arm);
		printf("vol_int: %X\n", read_vol_int);
		printf("vol_g3d: %X\n", read_vol_g3d);
		printf("buck1_ctrl: %X\n", buck1_ctrl);
		printf("buck2_ctrl: %X\n", buck2_ctrl);
		printf("buck3_ctrl: %X\n", buck3_ctrl);
		printf("ldo14_ctrl: %X\n", ldo14_ctrl);
	} else if ((0 <= read_id) && (read_id <= 0x5)) {
		IIC0_ERead(0xcc, 0x33, &read_vol_mif);
		IIC0_ERead(0xcc, 0x35, &read_vol_arm);
		IIC0_ERead(0xcc, 0x3E, &read_vol_int);
		IIC0_ERead(0xcc, 0x47, &read_vol_g3d);
		printf("vol_mif: %X\n", read_vol_mif);
		printf("vol_arm: %X\n", read_vol_arm);
		printf("vol_int: %X\n", read_vol_int);
		printf("vol_g3d: %X\n", read_vol_g3d);
	} else {
		IIC0_ERead(0x12, 0x14, &read_vol_arm);
		IIC0_ERead(0x12, 0x1E, &read_vol_int);
		IIC0_ERead(0x12, 0x28, &read_vol_g3d);
		IIC0_ERead(0x12, 0x11, &read_vol_mif);
		IIC0_ERead(0x12, 0x10, &buck1_ctrl);
		IIC0_ERead(0x12, 0x12, &buck2_ctrl);
		IIC0_ERead(0x12, 0x1C, &buck3_ctrl);
		IIC0_ERead(0x12, 0x26, &buck4_ctrl);

		printf("vol_arm: %X\n", read_vol_arm);
		printf("vol_int: %X\n", read_vol_int);
		printf("vol_g3d: %X\n", read_vol_g3d);
		printf("vol_mif: %X\n", read_vol_mif);
		printf("buck1_ctrl: %X\n", buck1_ctrl);
		printf("buck2_ctrl: %X\n", buck2_ctrl);
		printf("buck3_ctrl: %X\n", buck3_ctrl);
		printf("buck4_ctrl: %X\n", buck4_ctrl);
	}
#else	
	
	PS_HOLD = 0x5300;
	
	if(pmic_read(0x00, &rwdata, 1))	printf("pmic read error!\n");
	else	{
		printf("\nPMIC VERSION : 0x%02X, CHIP REV : %d\n", ((rwdata >> 3) & 0x1F), (rwdata & 0x7));
	}
//	if(pmic_read(0x53, &rwdata, 1))	printf("pmic read error!\n");
//	else	{
//		printf("LDO20 : 0x%02X\n", rwdata);
//	}
//	if(pmic_read(0x56, &rwdata, 1))	printf("pmic read error!\n");
//	else	{
//		printf("LDO23 : 0x%02X\n", rwdata);
//	}
//	if(pmic_read(0x57, &rwdata, 1))	printf("pmic read error!\n");
//	else	{
//		printf("LDO24 : 0x%02X\n", rwdata);
//	}
//	if(pmic_read(0x58, &rwdata, 1))	printf("pmic read error!\n");
//	else	{
//		printf("LDO25 : 0x%02X\n", rwdata);
//	}
//	if(pmic_read(0x59, &rwdata, 1))	printf("pmic read error!\n");
//	else	{
//		printf("LDO26 : 0x%02X\n", rwdata);
//	}
#endif

	/* display BL1 version */
#ifdef CONFIG_TRUSTZONE
	printf("TrustZone Enabled BSP\n");
	strncpy(&bl1_version[0], (char *)0x0204f810, 8);
#else
	strncpy(&bl1_version[0], (char *)0x020233c8, 8);
#endif
	printf("BL1 version: %s\n", &bl1_version[0]);

	/* check half synchronizer for asynchronous bridge */
	if(*(unsigned int *)(0x10010350) == 0x1)
		printf("Using half synchronizer for asynchronous bridge\n");
	
#ifdef CONFIG_SMC911X
	smc9115_pre_init();
#endif

#ifdef CONFIG_SMDKC220
	gd->bd->bi_arch_number = MACH_TYPE_C220;
#else
	if(((PRO_ID & 0x300) >> 8) == 2)
		gd->bd->bi_arch_number = MACH_TYPE_C210;
	else
		gd->bd->bi_arch_number = MACH_TYPE_V310;
#endif

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

	/* CLK_SRC_LCD0: Clock source for LCD_BLK
	 * Select source clock of each device (MIPI0_SEL, MDNIE_PWM0_SEL,
	 * MDNIE0_SEL, FIMD0_SEL) to SCLKMPLL_USER_T
	 */
	writel(0x6666, S5PV310_CLOCK_BASE + 0xC234); // CLK_SRC_LCD0

	/* LCDBLK_CFG : Display control register
	 * set FIMD to bypass, MIE or MDNIE is the as default in reset
	 * +---+-----------------+--------------------------------+
	 * | 1 | FIMDBYPASS_LBK0 | 0 = MIE/MDNIE, 1 = FIMD Bypass |
	 * | 0 | MIE_LBL0        | 0 = MIE, 1 = MDNIE             |
	 * +---+-----------------+--------------------------------+
	 */
	u32 val;
	val = readl(S5PV310_SYSREG_BASE + 0x210);	// LCDBLK_CFG
	writel(val | (1 << 1), S5PV310_SYSREG_BASE + 0x210);

#if defined(CONFIG_HKDK4412)
    // GPX1.7 HDMI Active High for ODROID-U3
    #define GPX1CON		*(volatile unsigned long *)(0x11000C20)
    #define GPX1DAT		*(volatile unsigned long *)(0x11000C24)
    
    GPX1CON |= 0x10000000;  GPX1DAT |= 0x80;
#endif	

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

#if defined(CONFIG_EXYNOS_PRIME)
	gd->bd->bi_dram[4].start = PHYS_SDRAM_5;
	gd->bd->bi_dram[4].size = PHYS_SDRAM_5_SIZE;
	gd->bd->bi_dram[5].start = PHYS_SDRAM_6;
	gd->bd->bi_dram[5].size = PHYS_SDRAM_6_SIZE;
	gd->bd->bi_dram[6].start = PHYS_SDRAM_7;
	gd->bd->bi_dram[6].size = PHYS_SDRAM_7_SIZE;
	gd->bd->bi_dram[7].start = PHYS_SDRAM_8;
	gd->bd->bi_dram[7].size = PHYS_SDRAM_8_SIZE;
#endif

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

#define IMAGE_DOWNLOAD_ADDR     0x45000000

unsigned int    update_image_load(const unsigned char *filename)
{
    unsigned char   value[512];
    
    setenv("load_img_mem_base", "45000000");    // fatload addr 0x45000000
    memset(value, 0x00, sizeof(value));
    sprintf(value, "update/%s", filename);
    setenv("load_img_name_base", value);

    run_command("system_update", 0);
    
    if(getenv_ulong("load_img_next_base", 16, 0))   return  1;
        
    return  0;
}

unsigned int    filecheck(const unsigned char *filename)
{
    unsigned char   cmd[128];
    unsigned long   filesize = 0;
    
    memset(cmd, 0x00, sizeof(cmd));

    // file check & update
	setenv("filesize", "0");
    
    sprintf(cmd, "fatload mmc 0:1 0x%08X update/%s", IMAGE_DOWNLOAD_ADDR, filename);
    
    run_command(cmd, 0);
    
    if((filesize = getenv_ulong("filesize", 16, 0)))    return  1;  // file read success
    
    printf("ERROR! update/%s File Not Found!! filesize = 0\n", filename);

    return  0;  // file read fail
}

void update_image       (const unsigned char *partition)
{
    unsigned char   cmd[128];
    
    memset(cmd, 0x00, sizeof(cmd));
    sprintf(cmd, "fastboot flash %s 0x%08X 0", partition, IMAGE_DOWNLOAD_ADDR);
    run_command(cmd, 0);
}

void update_raw_image   (const unsigned char *partition)
{
    if      (!strncmp(partition, "kernel", sizeof("kernel")))     
        run_command("movi write kernel 0 0x45000000", 0);
    else if (!strncmp(partition, "ramdisk", sizeof("ramdisk")))
        run_command("movi write ramdisk 0 0x45000000 30000", 0);
    else    {
    	if (OmPin == BOOT_EMMC_4_4 || OmPin == BOOT_EMMC)   {
        	run_command("emmc open 0", 0);
            if(!strncmp(partition, "bootloader",    sizeof("bootloader")))  run_command("movi w z u 0 0x45000000", 0);
            if(!strncmp(partition, "bl1",           sizeof("bl1")))         run_command("movi w z f 0 0x45000000", 0);
            if(!strncmp(partition, "bl2",           sizeof("bl2")))         run_command("movi w z b 0 0x45000000", 0);
            if(!strncmp(partition, "tzsw",          sizeof("tzsw")))        run_command("movi w z t 0 0x45000000", 0);
            run_command("emmc close 0", 0);
    	}
    	else    {
            if(!strncmp(partition, "bootloader",    sizeof("bootloader")))  run_command("movi w u 0 0x45000000", 0);
            if(!strncmp(partition, "bl1",           sizeof("bl1")))         run_command("movi w f 0 0x45000000", 0);
            if(!strncmp(partition, "bl2",           sizeof("bl2")))         run_command("movi w b 0 0x45000000", 0);
            if(!strncmp(partition, "tzsw",          sizeof("tzsw")))        run_command("movi w t 0 0x45000000", 0);
    	}
    }
}

#define OPTION_ERASE_USERDATA   0x01
#define OPTION_ERASE_FAT        0x02
#define OPTION_ERASE_ENV        0x04
#define OPTION_UPDATE_UBOOT     0x08

/* cmd from kernel reboot */    
#define REBOOT_FASTBOOT 0xFAB0
#define REBOOT_UPDATE   0xFADA

#define GPIO_GPD0_BASE      0x114000A0
#define GPD0CON             *(volatile unsigned long *)(GPIO_GPD0_BASE + 0x00)
#define GPD0DAT             *(volatile unsigned long *)(GPIO_GPD0_BASE + 0x04)

#define GPIO_GPD1_BASE      0x114000C0
#define GPD1CON             *(volatile unsigned long *)(GPIO_GPD1_BASE + 0x00)
#define GPD1DAT             *(volatile unsigned long *)(GPIO_GPD1_BASE + 0x04)
#define GPD1PUD             *(volatile unsigned long *)(GPIO_GPD1_BASE + 0x08)

#define GPIO_GPX3_BASE      0x11000C60
#define GPX3CON             *(volatile unsigned long *)(GPIO_GPX3_BASE + 0x00)
#define GPX3DAT             *(volatile unsigned long *)(GPIO_GPX3_BASE + 0x04)

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

#ifdef CONFIG_HKDK4412

	// u3+ otg_host vbus output disable (2014.05.12)
	GPIO_Init();
	GPIO_SetFunctionEach(eGPIO_L2, eGPIO_0, eGPO);
	GPIO_SetPullUpDownEach(eGPIO_L2, eGPIO_0, eGPUDdis); 	// pull-down
	GPIO_SetDataEach(eGPIO_L2, eGPIO_0, 0);

	GPIO_SetFunctionEach(eGPIO_X3, eGPIO_1, eGPI);
	GPIO_SetPullUpDownEach(eGPIO_X3, eGPIO_1, eGPUen); 	// pull-up


    // FAN Control
    GPD0CON &= 0xFFFFFFF0;  mdelay(1);
    GPD0CON |= 0x00000001;  mdelay(1);
    GPD0DAT |= 0x01;

    GPX3CON &= 0xFF00FFF0;  mdelay(1);
    GPX3CON |= 0x00110001;  mdelay(1);
    GPX3DAT &= 0xCE;        mdelay(1);
    GPX3DAT |= 0x20;        mdelay(1);
    if(getenv_ulong("usb_invert_clken", 16, 0))    {
        printf("USB3503 NINT = OUTPUT HIGH!\n");
        GPX3DAT |= 0x01;
    }
    else    
        printf("USB3503 NINT = OUTPUT LOW!\n");

    GPD1PUD &= 0xFFFFFFF0;  mdelay(1);
    GPD1CON &= 0xFFFFFF00;  mdelay(1);
    GPD1CON |= 0xFFFFFF11;  mdelay(1);
    GPD1DAT &= 0xFC;    mdelay(1);
    GPD1DAT |= 0x02;    mdelay(1);
    GPD1DAT |= 0x01;    

#if 0   // test
    INF_REG5_REG = REBOOT_UPDATE;
    INF_REG0_REG = OPTION_ERASE_USERDATA | OPTION_ERASE_FAT | OPTION_ERASE_ENV | OPTION_UPDATE_UBOOT;
#endif

    if (INF_REG5_REG & 0xFFFF)     {
        unsigned char   cmd[32];
        unsigned int    reboot_cmd;
        unsigned int    option;
        
        reboot_cmd = INF_REG5_REG;
        INF_REG5_REG = 0;
        
        option = INF_REG0_REG;
        INF_REG0_REG = 0;
        
        memset(cmd, 0x00, sizeof(cmd));

        switch(reboot_cmd  & 0xFFFF) {
            case    REBOOT_FASTBOOT:
                sprintf(cmd, "%s", "fastboot");
                run_command(cmd, 0);
                break;
            case    REBOOT_UPDATE:
                #if 0
                    // 64gb check for userdata erase
                    run_command("check_64gb 0", 0);
                #endif

#if defined(CONFIG_LED_CONTROL)    
                LED_BLUE(ON);
#endif            

                // Used system update function in cmd_fat.c
                setenv("system_memory_end", "80000000");
                setenv("max_load_file_cnt", "500");
                
                setenv("load_partition_type", "fat");
                setenv("raw_write_enable", "false");
                
                setenv("update_device_num", "0");           // it self
                setenv("load_device_num", "0");             // it self
                setenv("load_img_size", "1000000");         // 16MBytes (HEX)
                setenv("load_partition_num", "1");          // FAT partition
                
                if(update_image_load("system_"))        update_image("system");
                if(update_image_load("cache_"))         update_image("cache");
                if(option & OPTION_ERASE_USERDATA)  {
                    if(update_image_load("userdata_"))  update_image("userdata");
                }

                if(filecheck("zImage"))             update_raw_image("kernel");
                if(filecheck("ramdisk-uboot.img"))  update_raw_image("ramdisk");

                if(option & OPTION_UPDATE_UBOOT)    {
                    if(filecheck("u-boot.bin")) update_raw_image("bootloader");
                    if(filecheck("bl1.bin"))    update_raw_image("bl1");
                    if(filecheck("bl2.bin"))    update_raw_image("bl2");
                    if(filecheck("tzsw.bin"))   update_raw_image("tzsw");
                }
                if(option & OPTION_ERASE_ENV)   {
                    memset(cmd, 0x00, sizeof(cmd));
        		    sprintf(cmd,"mmc write %d 0x40008000 0x%lx 0x%lx", 0, MOVI_ENV_POS, MOVI_ENV_BLKCNT);
        			run_command(cmd, 0);
                }
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

	GPIO_Init();
	GPIO_SetFunctionEach(eGPIO_X2, eGPIO_2, eGPI);
	GPIO_SetPullUpDownEach(eGPIO_X2, eGPIO_2, 1); 	// pull-down

	udelay(10);
	if (GPIO_GetDataEach(eGPIO_X2, eGPIO_2) == 0){
		printf("ModeKey Check... run normal_boot \n");
	}
	else {
		char run_cmd[80];
		
		printf("ModeKey Check... run fastboot \n");

		sprintf(run_cmd, "fastboot");
		run_command(run_cmd, 0);
	}
#endif

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
#if !defined(CONFIG_HKDK4412)
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

