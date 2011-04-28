#ifndef __CONFIG_M8B_FT_V1_H__
#define __CONFIG_M8B_FT_V1_H__

/*
remark: 
1. this uboot config based from m8b_skt_v0
2. it will used for external proram which will run in DDR
   2.1 only SPL + ext program and no TPL 
   2.2 ft_firmware.bin + code_raw.bin
         2.2.1 code_raw.bin will be ucl compress for storage load performance
         2.2.2 code_raw.bin entry point is CONFIG_AML_EXT_PGM_ENTRY
*/

#define FT_DDR_TEST   // for FT DDR test

#define CONFIG_AML_EXT_PGM 

#define CONFIG_AML_EXT_PGM_SILENT

#define CONFIG_AML_EXT_PGM_ENTRY 0x10000000

#define CONFIG_MACH_MESON8_SKT  // generate M8 SKT machid number

//#define CONFIG_FT_TEXT_BASE CONFIG_SYS_TEXT_BASE
#define CONFIG_FT_TEXT_BASE CONFIG_SYS_TEXT_BASE

// cart type of each port
#define PORT_A_CARD_TYPE            CARD_TYPE_UNKNOWN
#define PORT_B_CARD_TYPE            CARD_TYPE_UNKNOWN
#define PORT_C_CARD_TYPE            CARD_TYPE_MMC // CARD_TYPE_MMC/CARD_TYPE_SD
#define CONFIG_IR_REMOTE_WAKEUP 1
//UART Sectoion
#define CONFIG_CONS_INDEX   2


#define CONFIG_ACS
#ifdef CONFIG_ACS
#define CONFIG_DDR_SIZE_IND_ADDR 0xD9000000	//pass memory size, spl->uboot
#endif

#ifdef CONFIG_NEXT_NAND
#define CONFIG_CMD_IMGREAD  1   //read the actual size of boot.img/recovery.img/logo.img use cmd 'imgread'
#define CONFIG_AML_V2_USBTOOL 1
#endif//#ifdef CONFIG_NEXT_NAND

#if CONFIG_AML_V2_USBTOOL
#define CONFIG_SHA1
#ifdef CONFIG_ACS
#define CONFIG_TPL_BOOT_ID_ADDR       		(0xD9000000U + 4)//pass boot_id, spl->uboot
#else
#define CONFIG_TPL_BOOT_ID_ADDR       		(&reboot_mode)//pass boot_id, spl->uboot
#endif// #ifdef CONFIG_ACS
#endif// #if CONFIG_AML_V2_USBTOOL

//Enable storage devices
#define CONFIG_CMD_SF    1
#if defined(CONFIG_CMD_SF)
	#define SPI_WRITE_PROTECT  1
	#define CONFIG_CMD_MEMORY  1
#endif /*CONFIG_CMD_SF*/

//Amlogic SARADC support
//#define CONFIG_SARADC 1
#define CONFIG_EFUSE 1
#define CONFIG_L2_OFF	 1

#define CONFIG_SDIO_B1   1
#define CONFIG_SDIO_A    1
#define CONFIG_SDIO_B    1
#define CONFIG_SDIO_C    1
#define CONFIG_ENABLE_EXT_DEVICE_RETRY 1


#define CONFIG_MMU                    1
#define CONFIG_PAGE_OFFSET 	0xc0000000
#define CONFIG_SYS_LONGHELP	1


#define CONFIG_UCL 1
#define CONFIG_SELF_COMPRESS 

#define CONFIG_CMD_REBOOT 1

/* Environment information */
#define CONFIG_BOOTDELAY	1

#define CONFIG_EXTRA_ENV_SETTINGS \
	"loadaddr=0x12000000\0" \
	
#define CONFIG_ENV_SIZE         (64*1024)

#define CONFIG_SPI_BOOT 1
//#define CONFIG_MMC_BOOT
//#define CONFIG_NAND_BOOT 1

#ifdef CONFIG_SPI_BOOT
	#define CONFIG_ENV_OVERWRITE
	#define CONFIG_ENV_IS_IN_SPI_FLASH
	#define CONFIG_CMD_SAVEENV	
	#define CONFIG_ENV_SECT_SIZE		0x10000
	#define CONFIG_ENV_OFFSET           0x1f0000
#elif defined CONFIG_NAND_BOOT
	#define CONFIG_ENV_IS_IN_AML_NAND
	#define CONFIG_CMD_SAVEENV
	#define CONFIG_ENV_OVERWRITE	
	#define CONFIG_ENV_OFFSET       0x400000
	#define CONFIG_ENV_BLOCK_NUM    2
#elif defined CONFIG_MMC_BOOT
	#define CONFIG_ENV_IS_IN_MMC
	#define CONFIG_CMD_SAVEENV
    #define CONFIG_SYS_MMC_ENV_DEV        0	
	#define CONFIG_ENV_OFFSET       0x1000000		
#else
	#define CONFIG_ENV_IS_NOWHERE    1
#endif

//----------------------------------------------------------------------
//Please set the M8 CPU clock(unit: MHz)
//legal value: 600, 792, 996, 1200
#define M8_CPU_CLK 		    (792)
#define CONFIG_SYS_CPU_CLK	(M8_CPU_CLK)
//----------------------------------------------------------------------

//-----------------------------------------------------------------------
//DDR setting
//For DDR PUB training not check the VT done flag
#define CONFIG_NO_DDR_PUB_VT_CHECK 1

//For M8 DDR clock gating disable
#define CONFIG_GATEACDDRCLK_DISABLE 1        // DDR PHY model don't support

//For M8 DDR low power feature disable
#define CONFIG_DDR_LOW_POWER_DISABLE 1       // DDR PHY model don't support

//For M8 DDR PUB WL/WD/RD/RG-LVT, WD/RD-BVT disable
//#define CONFIG_PUB_WLWDRDRGLVTWDRDBVT_DISABLE 1

//Please just define m8 DDR clock here only
//current DDR clock range (408~804)MHz with fixed step 12MHz
#define CFG_DDR_CLK    696 //696 //768  //792// (636)
#define CFG_DDR_MODE   CFG_DDR_32BIT   // CFG_DDR_16BIT_LANE01

#ifdef CONFIG_ACS
//#define CONFIG_DDR_MODE_AUTO_DETECT	//ddr bus-width auto detection
//#define CONFIG_DDR_SIZE_AUTO_DETECT	//ddr size auto detection
#endif

//On board DDR capactiy
//#define CFG_DDR3_512MB
#define CFG_DDR3_1GB
//#define CFG_DDR3_2GB
//#define CFG_DDR3_4GB
//above setting will affect following:
//board/amlogic/m8b_ft_v1/firmware/timming.c
//arch/arm/cpu/aml_meson/m8/mmutable.s

//DDR row/col size
//row size.  2'b01 : A0~A12.   2'b10 : A0~A13.  2'b11 : A0~A14.  2'b00 : A0~A15.
//col size.   2'b01 : A0~A8,      2'b10 : A0~A9  
#define PHYS_MEMORY_START        (0x00000000) // ???
#if   defined(CFG_DDR3_512MB)
	#define CONFIG_DDR3_ROW_SIZE (3)
	#define CONFIG_DDR3_COL_SIZE (2)
	#define CONFIG_DDR_ROW_BITS  (15)
	#define PHYS_MEMORY_SIZE     (0x20000000)
#elif defined(CFG_DDR3_1GB)
	//2Gb(X16) x 4pcs
	#define CONFIG_DDR3_ROW_SIZE (3)
	#define CONFIG_DDR3_COL_SIZE (2)
	#define CONFIG_DDR_ROW_BITS  (15)
	#define PHYS_MEMORY_SIZE     (0x40000000)
#elif defined(CFG_DDR3_2GB)
	//4Gb(X16) x 4pcs
	#define CONFIG_DDR3_ROW_SIZE (3)
	#define CONFIG_DDR3_COL_SIZE (2)
	#define CONFIG_DDR_ROW_BITS  (15)
	#define PHYS_MEMORY_SIZE     (0x80000000)
#elif !defined(CFG_DDR3_1GB) && !defined(CFG_DDR3_2GB) && !defined(CFG_DDR3_512MB)
	#error "Please set DDR3 capacity first in file m8_skt_v0.h\n"
#endif

#define CONFIG_DUMP_DDR_INFO 1
#define CONFIG_ENABLE_WRITE_LEVELING 1

#define CONFIG_SYS_MEMTEST_START      0x10000000  /* memtest works on */      
#define CONFIG_SYS_MEMTEST_END        0x18000000  /* 0 ... 128 MB in DRAM */  
#define CONFIG_ENABLE_MEM_DEVICE_TEST 1
#define CONFIG_NR_DRAM_BANKS	      1	          /* CS1 may or may not be populated */

/* Pass open firmware flat tree*/
#define CONFIG_OF_LIBFDT	1
#define CONFIG_SYS_BOOTMAPSZ   PHYS_MEMORY_SIZE       /* Initial Memory map for Linux */
#define CONFIG_ANDROID_IMG	1

//M8 L1 cache enable for uboot decompress speed up
#define CONFIG_AML_SPL_L1_CACHE_ON	1

#define CONFIG_AML_DISABLE_CRYPTO_UBOOT

#endif //__CONFIG_M8B_FT_V1_H__
