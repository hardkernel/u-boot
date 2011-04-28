/*

 *
 */

#ifndef _CPU_H
#define _CPU_H
#include <config.h>
#include <asm/plat-cpu.h>
#if CONFIG_AML_MESON==0
#error please define CONFIG_AML_MESON
#endif
//U boot code control

/*  Silent print function by Lawrence.Mok
        CONFIG_SILENT_CONSOLE checks if "silent" exists in env.
            If 'setenv silent 1' in uboot, then part of TPL print is silenced
                and 'quiet' is added to kernel bootargs.
            If "silent=1" is added to default env (CONFIG_EXTRA_ENV_SETTINGS),
                then all of TPL will be silenced and 'quiet' added to bootargs.
            To enable print, "setenv silent;saveenv" to delete env variable
                or undef CONFIG_SILENT_CONSOLE
    Add CONFIG_DISABLE_SILENT_CONSOLE in board.h if you want disable this function
*/
#if !defined(CONFIG_DISABLE_SILENT_CONSOLE)
#define CONFIG_SILENT_CONSOLE
#ifdef CONFIG_SILENT_CONSOLE
#define CONFIG_SILENT_CONSOLE_LINUX_QUIET
#define CONFIG_SILENT_CONSOLE_UPDATE_ON_RELOC
#define CONFIG_SYS_DEVICE_NULLDEV
#define CONFIG_SYS_CONSOLE_INFO_QUIET
#endif
#endif

//DDR mode. Once considering this value stored in efuse, 0=NotSet is necessary
#define CFG_DDR_NOT_SET			0
#define CFG_DDR_32BIT			1
#define CFG_DDR_16BIT_LANE02	2	//DDR lane0+lane2
#define CFG_DDR_16BIT_LANE01	3	//DDR lane0+lane1
#define CFG_DDR_MODE_STO_ADDR	0	//2 //2 bits, store in efuse etc..
#define CFG_DDR_MODE_STO_OFFSET	0	//6	//offset of these 2 bits

//low power ddr defines
#ifdef CONFIG_LPDDR2
#undef CONFIG_LPDDR3
#define LPDDR2
#endif
#ifdef CONFIG_LPDDR3
#undef CONFIG_LPDDR2
#define LPDDR3
#endif

#if !defined(CONFIG_DDR_COL_BITS)
	#define CONFIG_DDR_COL_BITS  (10)
#endif //CONFIG_DDR_COL_BITS

//DDR training address, DO NOT modify
//DDR0: 0x0F00 - 0x0F7F (128Bytes)
#define CONFIG_M8B_RANK0_DTAR_ADDR (0x3000000)

//M8baby support 16bit and 32bit mode
//#define CONFIG_M8B_DDR_BIT_MODE_SET (CONFIG_M8B_DDR_BIT_MODE_32BIT) //m8b_xxx_xxx.h
#define CONFIG_M8B_DDR_BIT_MODE_32BIT  (0)
#define CONFIG_M8B_DDR_BIT_MODE_16BIT  (1)

//M8baby support two ranks: Rank0 or Rank0+1
//#define CONFIG_M8B_DDR_RANK_SET  (CONFIG_M8B_DDR_RANK0_ONLY) //m8b_xxx_xxx.h.
#define CONFIG_M8B_DDR_RANK0_ONLY      (0)
#define CONFIG_M8B_DDR_RANK0_AND_RANK1 (1)

#define CONFIG_M8B_DDR_RANK0_SIZE_256M  (1)
#define CONFIG_M8B_DDR_RANK0_SIZE_512M  (2)
#define CONFIG_M8B_DDR_RANK0_SIZE_1GB   (3)
#define CONFIG_M8B_DDR_RANK0_SIZE_2GB   (0)

#define CONFIG_M8B_DDR_RANK1_START_ADDR_256M  (256<<20)
#define CONFIG_M8B_DDR_RANK1_START_ADDR_512M  (512<<20)
#define CONFIG_M8B_DDR_RANK1_START_ADDR_1GB   (1<<30)
#define CONFIG_M8B_DDR_RANK1_START_ADDR_2GB   (2<<30)

//M8 DDR0/1 address map bank mode
#define CONFIG_M8B_DDR_BANK_MODE_2_BNK   (0)
#define CONFIG_M8B_DDR_BANK_MODE_4_BNK   (1)

//M8baby support 4 mode to abstract bank from address
//#define CONFIG_M8B_DDR_BANK_SET (CONFIG_M8B_DDR_BANK_SET_S12 ) //m8b_xxx_xxx.h
#define CONFIG_M8B_DDR_BANK_SET_S12	    (0)
#define CONFIG_M8B_DDR_BANK_SET_S13_S12	(1)
#define CONFIG_M8B_DDR_BANK_SET_S8      (2)
#define CONFIG_M8B_DDR_BANK_SET_S9_S8   (3)

#if !defined(CONFIG_M8B_DDR_RANK_SET)
  #define CONFIG_M8B_DDR_RANK_SET  (CONFIG_M8B_DDR_RANK0_ONLY)
#endif

#if !defined(CONFIG_M8B_DDR_BANK_SET)
  #define CONFIG_M8B_DDR_BANK_SET (CONFIG_M8B_DDR_BANK_SET_S12)
#endif

#if (CFG_DDR_MODE > CFG_DDR_32BIT)	//not 32bit mode
	#define CONFIG_M8B_DDR_BIT_MODE_SET (CONFIG_M8B_DDR_BIT_MODE_16BIT)
#else
	#define CONFIG_M8B_DDR_BIT_MODE_SET (CONFIG_M8B_DDR_BIT_MODE_32BIT)
#endif

#if !defined(CONFIG_M8B_DDR_BIT_MODE_SET)
  #define CONFIG_M8B_DDR_BIT_MODE_SET (CONFIG_M8B_DDR_BIT_MODE_32BIT)  
#endif

#define M8BABY_DDR_DTAR_BANK_GET(addr,bit_row,bit_col,bank_set,bit_set) \
	((((addr >> (bit_row+bit_col+(3-bit_set)+(bank_set&1))) & ((bank_set&1) ? 1 : 3)) << ((bank_set & 1)+1) ) |\
		 ((addr >>(((bank_set&2) ? 6 : bit_col)+(2-bit_set))) & ((bank_set&1)?3:1)))

#define M8BABY_DDR_DTAR_DTROW_GET(addr,bit_row,bit_col,bank_set,bit_set) \
	(( (addr) >> (bit_col+((bank_set&1)+(3-bit_set))) & ((1<< (bit_row))-1)))


#define M8BABY_DDR_DTAR_DTCOL_GET(addr,bit_col,bank_set,bit_set) \
	((( (addr) >> (2-bit_set)) & ((1<< (((bank_set) & 2) ? 6 : (bit_col)))-1))| \
		(((bank_set) & 2)? ((((addr) >> (((bank_set) & 1)+(9-bit_set)))&((1<<((bit_col)-6))-1))<<6):(0)))

#define CONFIG_DDR0_DTAR_DTBANK  M8BABY_DDR_DTAR_BANK_GET(CONFIG_M8B_RANK0_DTAR_ADDR,CONFIG_DDR_ROW_BITS,CONFIG_DDR_COL_BITS,CONFIG_M8B_DDR_BANK_SET,CONFIG_M8B_DDR_BIT_MODE_SET)
#define CONFIG_DDR0_DTAR_DTROW   M8BABY_DDR_DTAR_DTROW_GET(CONFIG_M8B_RANK0_DTAR_ADDR,CONFIG_DDR_ROW_BITS,CONFIG_DDR_COL_BITS,CONFIG_M8B_DDR_BANK_SET,CONFIG_M8B_DDR_BIT_MODE_SET)
#define CONFIG_DDR0_DTAR_DTCOL   M8BABY_DDR_DTAR_DTCOL_GET(CONFIG_M8B_RANK0_DTAR_ADDR,CONFIG_DDR_COL_BITS,CONFIG_M8B_DDR_BANK_SET,CONFIG_M8B_DDR_BIT_MODE_SET)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//NOTE: IMPORTANT! DO NOT TRY TO MODIFY FOLLOWING CODE!
//           It is used to get DDR0 training address from PUB_DTAR0.
//          
//How to fetch the DDR training address for M8:
//           1. enable PCTL clock before access
//           2. load DMC DDR setting from P_DMC_DDR_CTRL
//           3. load the DTAR0 value from DDR0 PUB register according to the channel setting from DMC_DDR_CTRL
//           4. disable PCTL clock for power saving
//
//Demo code: 
/*          
	//enable clock
	writel(readl(P_DDR0_CLK_CTRL)|(1), P_DDR0_CLK_CTRL);

	printf("training address: %x\n", M8BABY_GET_DT_ADDR(readl(P_DDR0_PUB_DTAR0), readl(P_DMC_DDR_CTRL)));

	//disable clock
	writel(readl(P_DDR0_CLK_CTRL) & (~1), P_DDR0_CLK_CTRL);  
*/

#define M8BABY_GET_DT_ADDR(dtar, dmc) \
	(((((dtar) >> 28) & 0x7) & (((((dmc) >> 5) & 0x3)&1)?3:1)) << ((((((dmc) >> 5) & 0x3)&2) ? 6 : (((dmc) & 0x3) + 8))+(2-(((dmc) >> 7) & 0x1)))) | \
	(((((((dtar) >> 28) & 0x7) >> (((((dmc) >> 5) & 0x3) & 1)+1))) & (((((dmc) >> 5) & 0x3)&1) ? 1 : 3)) << (((((dmc) >> 2) & 0x3) ? ((((dmc) >> 2) & 0x3)+12) : (16))+(((dmc) & 0x3) + 8)+(3-(((dmc) >> 7) & 0x1))+((((dmc) >> 5) & 0x3)&1))) | \
	(((((dtar)) & 0xfff) & ((1<< ((((((dmc) >> 5) & 0x3)) & 2) ? 6 : ((((dmc) & 0x3) + 8))))-1)) << (2-(((dmc) >> 7) & 0x1))) | \
	((((((dmc) >> 5) & 0x3)) & 2) ? ((((((dtar)) & 0xfff) >> 6) & ((1<<(((((dmc) & 0x3) + 8))-6))-1)) << ((((((dmc) >> 5) & 0x3)) & 1)+(9-(((dmc) >> 7) & 0x1)))):(0)) | \
	((((dtar) >> 12) & 0xffff) << ((((dmc) & 0x3) + 8)+(((((dmc) >> 5) & 0x3)&1)+(3-(((dmc) >> 7) & 0x1)))))

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//timer
#define CONFIG_SYS_HZ 1000

#define CONFIG_SYS_NO_FLASH 1
#define CONFIG_NR_DRAM_BANKS 1

#define CONFIG_BAUDRATE                 115200
#define CONFIG_SYS_BAUDRATE_TABLE       { 9600, 19200, 38400, 57600, 115200}
#define CONFIG_SERIAL_MULTI             1

#if 0
//no need to keep but for develop & verify
#define CONFIG_SYS_SDRAM_BASE   0x80000000
#define CONFIG_SYS_INIT_SP_ADDR (CONFIG_SYS_SDRAM_BASE+0xF00000)
#define CONFIG_SYS_TEXT_BASE    0x8F800000
#define CONFIG_MMU_DDR_SIZE     (0xc00)
#define CONFIG_SYS_LOAD_ADDR    0x82000000
#define CONFIG_DTB_LOAD_ADDR    0x83000000
#else
#define CONFIG_SYS_SDRAM_BASE   0x00000000
#define CONFIG_SYS_INIT_SP_ADDR (CONFIG_SYS_SDRAM_BASE+0xF00000)
#define CONFIG_SYS_TEXT_BASE    0x10000000
#define CONFIG_MMU_DDR_SIZE     ((PHYS_MEMORY_SIZE)>>20)
#ifdef CONFIG_DDR_SIZE_AUTO_DETECT
#undef CONFIG_MMU_DDR_SIZE
#define CONFIG_MMU_DDR_SIZE    ((0x80000000)>>20)	//max 2GB
#endif
#define CONFIG_SYS_LOAD_ADDR    0x12000000
#define CONFIG_DTB_LOAD_ADDR    0x0f000000
#endif

#define CONFIG_SECURE_UBOOT_SIZE     0x100000

#define CONFIG_SYS_MALLOC_LEN   (12<<20)

#define CONFIG_SYS_MAXARGS      16
#define CONFIG_SYS_CBSIZE          1024
#define CONFIG_SYS_PBSIZE (CONFIG_SYS_CBSIZE+sizeof(CONFIG_SYS_PROMPT)+16) /* Print Buffer Size */

#define CONFIG_VPU_PRESET		1

/** Timer relative Configuration **/
#define CONFIG_CRYSTAL_MHZ  24
/** Internal storage setting **/
//size Limitation
//#include "romboot.h"
//#warning todo implement CONFIG_BOARD_SIZE_LIMIT 
//#define CONFIG_BOARD_SIZE_LIMIT 600000
#define IO_REGION_BASE                0xe0000000
#define CONFIG_SYS_CACHE_LINE_SIZE 32
#define CONFIG_CMD_CACHE	1
//#define CONFIG_SYS_NO_CP15_CACHE	1
//#define CONFIG_DCACHE_OFF    		1
//#define CONFIG_ICACHE_OFF    		1

//#define CONFIG_EFUSE 1

#ifdef CONFIG_CMD_NAND
	#define CONFIG_NAND_AML_M3 1
	#define CONFIG_NAND_AML  1	
	#define CONFIG_NAND_AML_M8
	//#define CONFIG_SYS_MAX_NAND_DEVICE	1		/* Max number of */
	#define CONFIG_SYS_NAND_MAX_CHIPS	4
	#ifndef CONFIG_NAND_SP_BLOCK_SIZE
		#define CONFIG_NAND_SP_BLOCK_SIZE 32
	#endif
	//#warning todo implement nand driver later
	#define CONFIG_SYS_MAX_NAND_DEVICE  2  //make uboot happy
	#define CONFIG_SYS_NAND_BASE_LIST   {0}//make uboot happy
	//#define CONFIG_SYS_NAND_BASE 0 //make uboot happy
#endif

#ifdef CONFIG_CMD_SF
	#define CONFIG_AMLOGIC_SPI_FLASH    1
	#define CONFIG_SPI_FLASH            1
	#define SPI_FLASH_CACHELINE         64 //amlogic special setting. in M1 , SPI_A for SPI flash
	#define CONFIG_SPI_FLASH_MACRONIX   1
	#define CONFIG_SPI_FLASH_EON        1
	#define CONFIG_SPI_FLASH_SPANSION   1
	#define CONFIG_SPI_FLASH_SST        1
	#define CONFIG_SPI_FLASH_STMICRO    1
	#define CONFIG_SPI_FLASH_WINBOND    1
	#define CONFIG_SPI_FLASH_GIGADEVICE     1
#endif


#if CONFIG_SDIO_B1 || CONFIG_SDIO_A || CONFIG_SDIO_B || CONFIG_SDIO_C
	#define CONFIG_CMD_MMC          1
	#define CONFIG_MMC              1
	#define CONFIG_DOS_PARTITION    1
	#define CONFIG_AML_SDIO         1
	#define CONFIG_GENERIC_MMC      1
#endif

#if CONFIG_NAND_AML_M3 || CONFIG_AMLOGIC_SPI_FLASH
	#define CONFIG_MTD_DEVICE     1
	#define CONFIG_MTD_PARTITIONS 1
	#define CONFIG_CMD_MTDPARTS   1
#endif

/*
 * File system
 */
#define CONFIG_CMD_EXT2		/* EXT2 Support			*/
#define CONFIG_CMD_FAT		/* FAT support			*/


#define CONFIG_AML_ROMBOOT    1
#define SPI_MEM_BASE                                0xcc000000
#define AHB_SRAM_BASE                               0xd9000000  // AHB-SRAM-BASE
#define CONFIG_USB_SPL_ADDR                         (CONFIG_SYS_TEXT_BASE - (32<<10)) //here need update when support 64KB SPL
#define CONFIG_DDR_INIT_ADDR                        (0xd9000000) //usb driver limit, bit4 must 1, change 0xd9000000 as ACS hard coded to 0xd9000200

#if !defined(CONFIG_AML_DISABLE_CRYPTO_UBOOT)
	#define CONFIG_AML_SECU_BOOT_V2		1
	#define CONFIG_AML_CRYPTO_UBOOT		1
	#if !defined(CONFIG_AML_RSA_1024) && !defined(CONFIG_AML_RSA_2048)
		#define CONFIG_AML_RSA_2048 1
	#endif //CONFIG_AML_RSA_2048
#endif //CONFIG_AML_DISABLE_CRYPTO_UBOOT


#ifdef CONFIG_AML_ROMBOOT_SPL
	#define SPL_STATIC_FUNC     static
	#define SPL_STATIC_VAR      static
#else
	#define SPL_STATIC_FUNC     
	#define SPL_STATIC_VAR      
#endif

#define CONFIG_CMDLINE_TAG		1	/* enable passing of ATAGs */
#define CONFIG_SETUP_MEMORY_TAGS	1
#define CONFIG_INITRD_TAG		1
#define CONFIG_REVISION_TAG		1
#define CONFIG_CMD_KGDB			1
////#define CONFIG_SERIAL_TAG       1*/

//#define CONFIG_AML_RTC 
//#define CONFIG_RTC_DAY_TEST 1  // test RTC run 2 days

#define CONFIG_LZMA  1
#define CONFIG_LZO
#define CONFIG_DISABLE_INTERNAL_U_BOOT_CHECK
/*default command select*/
#define CONFIG_CMD_MEMORY	1 /* md mm nm mw cp cmp crc base loop mtest */
//support "bdinfo" 
#define CONFIG_CMD_BDI 1
//support "coninfo"
#define CONFIG_CMD_CONSOLE 1
//support "echo"
#define CONFIG_CMD_ECHO 1
//support "loadb,loads,loady"
#define CONFIG_CMD_LOADS 1
#define CONFIG_CMD_LOADB 1
//support "run"
#define CONFIG_CMD_RUN 1
//support "true,false,test"
//#define CONFIG_SYS_LONGHELP		/* undef to save memory */
#define CONFIG_SYS_HUSH_PARSER		/* use "hush" command parser */
#define CONFIG_SYS_PROMPT_HUSH_PS2	"> "
//#define CONFIG_SYS_PROMPT		"8726M_ref # "
//#define CONFIG_SYS_CBSIZE		256	/* Console I/O Buffer Size */
//support "imxtract"
#define CONFIG_CMD_XIMG 1
//support "itest"
#define CONFIG_CMD_ITEST 1
//support "sleep"
#define CONFIG_CMD_MISC 1
//support "source"
#define CONFIG_SOURCE 1
#define CONFIG_CMD_SOURCE 1
//support "editenv"
#define CONFIG_CMD_EDITENV 1
/*default command select end*/

//support gpio cmd
#define CONFIG_AML_GPIO_CMD 1
#define CONFIG_AML_GPIO 1

//max watchdog timer: 8.388s
#define AML_WATCHDOG_TIME_SLICE				128	//us
#define AML_WATCHDOG_ENABLE_OFFSET			19
#define AML_WATCHDOG_CPU_RESET_CNTL			0xf	//qual-core
#define AML_WATCHDOG_CPU_RESET_OFFSET		24

#define MESON_CPU_TYPE	MESON_CPU_TYPE_MESON8B
#define CONFIG_AML_MESON_8		1
#define CONFIG_AML_SMP

#endif /* _CPU_H */
