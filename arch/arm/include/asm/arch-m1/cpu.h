/*

 *
 */

#ifndef _CPU_H
#define _CPU_H
#if CONFIG_AML_MESON==0
#error please define CONFIG_AML_MESON
#endif
#if CONFIG_M1==0
#error please define CONFIG_M1
#endif
//U boot code control

//timer
#define CONFIG_SYS_HZ 1000

#define CONFIG_SYS_NO_FLASH 1
#define CONFIG_NR_DRAM_BANKS 1

#define CONFIG_BAUDRATE                 115200
#define CONFIG_SYS_BAUDRATE_TABLE       { 9600, 19200, 38400, 57600, 115200}
#define CONFIG_SERIAL_MULTI             1
#define CONFIG_SYS_SDRAM_BASE   0x80000000

#define CONFIG_SYS_INIT_SP_ADDR (CONFIG_SYS_SDRAM_BASE+0xF000000)
#define CONFIG_SYS_TEXT_BASE    0x8F800000
#ifdef CONFIG_POST
#define CONFIG_SYS_POST_WORD_ADDR CONFIG_SYS_TEXT_BASE-0x4
#endif
#define CONFIG_SYS_MALLOC_LEN   (4<<20)
#define CONFIG_ENV_SIZE         (16 * 1024)
#define CONFIG_SYS_MAXARGS      16

#define CONFIG_ENV_IS_NOWHERE    1
#define CONFIG_SYS_LOAD_ADDR    0x82000000
#define CONFIG_SYS_CBSIZE          1024
#define CONFIG_SYS_PBSIZE (CONFIG_SYS_CBSIZE+sizeof(CONFIG_SYS_PROMPT)+16) /* Print Buffer Size */

#define CONFIG_SYS_LONGHELP	1

#define CONFIG_SYS_CACHE_LINE_SIZE 32
#define CONFIG_CMD_CACHE	1
//#define CONFIG_SYS_NO_CP15_CACHE	1
#define CONFIG_L2_OFF			1
//#define CONFIG_DCACHE_OFF    		1
//#define CONFIG_ICACHE_OFF    		1

//#define CONFIG_EFUSE 1

/** Timer relative Configuration **/
#define CONFIG_CRYSTAL_MHZ  24
/** Internal storage setting **/
//size Limitation
//#include "romboot.h"
//#warning todo implement CONFIG_BOARD_SIZE_LIMIT 
#define CONFIG_BOARD_SIZE_LIMIT 600000

/*--------------------------------------------------------------------
* Nand flash
*/
#define CONFIG_NAND_AML        1
#define CONFIG_CMD_NAND        1
#define CONFIG_MTD_DEVICE      1

#ifdef CONFIG_CMD_NAND
#define CONFIG_NAND_AML_M1 1
#define CONFIG_SYS_MAX_NAND_DEVICE	2		/* Max number of */
#define CONFIG_SYS_NAND_MAX_CHIPS	4
#ifndef CONFIG_NAND_SP_BLOCK_SIZE
#define CONFIG_NAND_SP_BLOCK_SIZE 32
#endif
#define CONFIG_SYS_NAND_BASE_LIST   {NFC_BASE} 
//#define CONFIG_SYS_NAND_BASE 0 //make uboot happy
#endif
#define CONFIG_CMD_MEMORY           1
#ifdef CONFIG_CMD_SF
#define CONFIG_AMLOGIC_SPI_FLASH    1
#define CONFIG_SPI_FLASH            1
#define SPI_FLASH_CACHELINE         64 //amlogic special setting. in M1 , SPI_A for SPI flash
#define CONFIG_SPI_FLASH_MACRONIX   1
//#define CONFIG_SPI_FLASH_SPANSION   1
#define CONFIG_SPI_FLASH_SST        1
//#define CONFIG_SPI_FLASH_STMICRO    1
#define CONFIG_SPI_FLASH_WINBOND    1

#endif
#if CONFIG_SDIO_B1 || CONFIG_SDIO_A || CONFIG_SDIO_B || CONFIG_SDIO_C
#define CONFIG_CMD_MMC          1
#define CONFIG_MMC              1
#define CONFIG_DOS_PARTITION    1
#define CONFIG_AML_SDIO         1
#define CONFIG_GENERIC_MMC      1
#endif

#if CONFIG_NAND_AML_M1 || CONFIG_AMLOGIC_SPI_FLASH
#define CONFIG_MTD_DEVICE     1
#define CONFIG_MTD_PARTITIONS 1
#define CONFIG_CMD_MTDPARTS   1
#endif

#define CONFIG_UBI_SUPPORT
#ifdef	CONFIG_UBI_SUPPORT
#define CONFIG_CMD_UBI
#define CONFIG_CMD_UBIFS
#define CONFIG_RBTREE
#endif

/* Environment information */
#define CONFIG_BOOTDELAY	1
#define CONFIG_BOOTFILE		uImage

#ifdef	CONFIG_UBI_SUPPORT
#define MTDIDS_DEFAULT		"nand1=nandflash1\0"
#define MTDPARTS_DEFAULT	"mtdparts=nandflash1:256m@168m(system)\0"						

#define CONFIG_EXTRA_ENV_SETTINGS \
	"loadaddr=0x82000000\0" \
	"testaddr=0x82400000\0" \
	"usbtty=cdc_acm\0" \
	"console=ttyS2,115200n8\0" \
	"mmcargs=setenv bootargs console=${console} " \
	"boardname=m1_mid\0" \
	"chipname=8726m\0" \
	"machid=B8C\0" \
	"bootargs=init=/init console=ttyS0,115200"  BOARD_INFO_ENV  " board_ver=v2 clk81=187500k hdmitx=vdacoff,powermode1,unplug_powerdown rootwait logo=osd1,0x84100000,lcd,full, root=/dev/cardblksd2 \0" \
	"mtdids=" MTDIDS_DEFAULT \
	"mtdparts="MTDPARTS_DEFAULT \
	"logo_start=0x4800000\0" \
	"logo_size=0x200000\0" \
	"aml_logo_start=0x5800000\0" \
	"aml_logo_size=0x200000\0" \
	"bootloader_start=0\0" \
	"bootloader_size=60000\0" \
	"bootloader_path=" UBOOTPATH "\0" \
	"normal_start=0x8800000\0" \
	"normal_size=0x800000\0" \
	"recovery_start=0x6800000\0" \
	"recovery_size=0x800000\0" \
	"recovery_path=uImage_recovery\0" \
	"env_path=u-boot-env\0" \
	"bootstart=0\0" \
	"bootsize=60000\0"
	
#define CONFIG_BOOTCOMMAND  "nand read 84100000 ${logo_start} ${logo_size};nand read ${loadaddr} ${normal_start} ${normal_size};lcd bl off;bootm"
//#define CONFIG_BOOTCOMMAND  "lcd bl off;mmcinfo;fatload mmc 0:1 82000000 uImage;bootm"
#else
#define CONFIG_EXTRA_ENV_SETTINGS \
	"loadaddr=0x82000000\0" \
	"testaddr=0x82400000\0" \
	"usbtty=cdc_acm\0" \
	"console=ttyS2,115200n8\0" \
	"mmcargs=setenv bootargs console=${console} " \
	"boardname=m1_mid\0" \
	"chipname=8726m\0" \
	"machid=B8C\0" \
	"bootargs=init=/init console=ttyS0,115200"  BOARD_INFO_ENV  " board_ver=v2 clk81=187500k hdmitx=vdacoff,powermode1,unplug_powerdown rootwait logo=osd1,0x84100000,lcd,full,root=/dev/cardblksd2\0" \
	"partnum=4\0" \
	"p0start=0x4800000\0" \
	"p0size=0x800000\0" \
	"p0path=logo\0" \
	"p1start=0x5800000\0" \
	"p1size=0x800000\0" \
	"p1path=aml_logo\0" \
	"p2start=0x6800000\0" \
	"p2size=0x1000000\0" \
	"p2path=uImage_recovery\0" \
	"p3start=0x8800000 \0" \
	"p3size=1000000\0" \
	"p3path=uImage\0" \
	"logo_start=0x4800000\0" \
	"logo_size=0x200000\0" \
	"aml_logo_start=0x5800000\0" \
	"aml_logo_size=0x200000\0" \
	"bootloader_start=0\0" \
	"bootloader_size=60000\0" \
	"bootloader_path=" UBOOTPATH "\0" \
	"normal_start=0x8800000\0" \
	"normal_size=0x800000\0" \
	"recovery_start=0x6800000\0" \
	"recovery_size=0x800000\0" \
	"recovery_path=uImage_recovery\0" \
	"envpath=u-boot-env\0" \
	"bootstart=0\0" \
	"bootsize=60000\0"

#define CONFIG_BOOTCOMMAND  "nand read 84100000 ${p0start} ${p0size};nand read ${loadaddr} ${normalstart} ${normalsize};lcd bl off;bootm"
#endif
#define CONFIG_AUTO_COMPLETE	1

/*
 * File system
 */
#define CONFIG_CMD_EXT2		/* EXT2 Support			*/
#define CONFIG_CMD_FAT		/* FAT support			*/


#define CONFIG_AML_ROMBOOT    1
#define SPI_MEM_BASE                                0x40000000
#define AHB_SRAM_BASE                               0x49000000  // AHB-SRAM-BASE
#define IO_REGION_BASE                              0xe0000000

#if (CONFIG_ICACHE_OFF && CONFIG_DCACHE_OFF)
#undef CONFIG_MMU
#else
#define CONFIG_MMU 	1
#endif

#ifdef CONFIG_AML_ROMBOOT_SPL
#define SPL_STATIC_FUNC     static
#define SPL_STATIC_VAR      static
#else
#define SPL_STATIC_FUNC     
#define SPL_STATIC_VAR      
#endif

#define CONFIG_LZMA  1
#define CONFIG_LZO

#define CONFIG_CMDLINE_TAG		1	/* enable passing of ATAGs */
#define CONFIG_SETUP_MEMORY_TAGS	1
#define CONFIG_INITRD_TAG		1
#define CONFIG_REVISION_TAG		1
#define CONFIG_CMD_KGDB			1
//#define CONFIG_SERIAL_TAG       1

#endif /* _CPU_H */
