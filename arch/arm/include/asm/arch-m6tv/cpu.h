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
#if CONFIG_M6TV==0
#error please define CONFIG_M6
#endif
//U boot code control

//DDR training address, DO NOT modify
#define CONFIG_M6TV_DDR_DTAR (0x9fffff00)

//timer
#define CONFIG_SYS_HZ 1000

#define CONFIG_SYS_NO_FLASH 1
#define CONFIG_NR_DRAM_BANKS 1

#define CONFIG_BAUDRATE                 115200
#define CONFIG_SYS_BAUDRATE_TABLE       { 9600, 19200, 38400, 57600, 115200}
#define CONFIG_SERIAL_MULTI             1
#define CONFIG_SYS_SDRAM_BASE   0x80000000

#define CONFIG_SYS_INIT_SP_ADDR (CONFIG_SYS_SDRAM_BASE+0xF00000)
#define CONFIG_SYS_TEXT_BASE    0x8F800000
#ifdef CONFIG_POST
	#define CONFIG_SYS_POST_WORD_ADDR CONFIG_SYS_TEXT_BASE-0x4
#endif
#define CONFIG_SYS_MALLOC_LEN   (4<<20)

#define CONFIG_SYS_MAXARGS      16

#define CONFIG_SYS_LOAD_ADDR    0x82000000
#define CONFIG_SYS_CBSIZE          1024
#define CONFIG_SYS_PBSIZE (CONFIG_SYS_CBSIZE+sizeof(CONFIG_SYS_PROMPT)+16) /* Print Buffer Size */

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
	//#define CONFIG_SPI_FLASH_STMICRO    1
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
//#define SPI_MEM_BASE                                0x40000000
//#define AHB_SRAM_BASE                               0x49000000  // AHB-SRAM-BASE
#define SPI_MEM_BASE                                0xcc000000
#define AHB_SRAM_BASE                               0xd9000000  // AHB-SRAM-BASE
#define CONFIG_DDR_INIT_ADDR                        (0xd9000000)


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

#define CONFIG_AML_RTC 
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

//max watchdog timer: 41.943s
#define AML_WATCHDOG_TIME_SLICE				10	//us
#define AML_WATCHDOG_ENABLE_OFFSET			22
#define AML_WATCHDOG_CPU_RESET_CNTL			3
#define AML_WATCHDOG_CPU_RESET_OFFSET		24

#define MESON_CPU_TYPE	MESON_CPU_TYPE_MESON6TV

#endif /* _CPU_H */
