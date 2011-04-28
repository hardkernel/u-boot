/*



 *

 */



#ifndef _CPU_H

#define _CPU_H

#ifdef __KERNEL__

#warning todo implement CONFIG_BOARD_SIZE_LIMIT 

//#define CONFIG_BOARD_SIZE_LIMIT 



#if CONFIG_AML_MESON==0

#error please define CONFIG_AML_MESON

#endif

#if CONFIG_M3==0

#error please define CONFIG_M1

#endif

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



#define CONFIG_SYS_INIT_SP_ADDR (CONFIG_SYS_SDRAM_BASE+0xF00000)

#define CONFIG_SYS_TEXT_BASE    0x8F800000

#define CONFIG_SYS_MALLOC_LEN   (4<<20)

#define CONFIG_ENV_SIZE         (16 * 1024)

#define CONFIG_SYS_MAXARGS      16



#define CONFIG_ENV_IS_NOWHERE    1

#define CONFIG_SYS_LOAD_ADDR    0x82000000

#define CONFIG_SYS_CBSIZE          1024

#define CONFIG_SYS_PBSIZE (CONFIG_SYS_CBSIZE+sizeof(CONFIG_SYS_PROMPT)+16) /* Print Buffer Size */



#define CONFIG_L2_OFF

/** Timer relative Configuration **/

#define CONFIG_CRYSTAL_MHZ  24

/** Internal storage setting **/

//size Limitation

//#include "romboot.h"





#ifdef CONFIG_CMD_NAND

#define CONFIG_NAND_AML_M1 1

#define CONFIG_SYS_MAX_NAND_DEVICE	1		/* Max number of */

#define CONFIG_SYS_NAND_MAX_CHIPS	4

#ifndef CONFIG_NAND_SP_BLOCK_SIZE

#define CONFIG_NAND_SP_BLOCK_SIZE 32

#endif

#warning todo implement nand driver later

#define CONFIG_SYS_MAX_NAND_DEVICE  1  //make uboot happy

#define CONFIG_SYS_NAND_BASE_LIST   {0}//make uboot happy

//#define CONFIG_SYS_NAND_BASE 0 //make uboot happy

#endif



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



#define CONFIG_AML_ROMBOOT    1

#define SPI_MEM_BASE                                0x40000000

#define AHB_SRAM_BASE                               0x49000000  // AHB-SRAM-BASE





#ifdef CONFIG_AML_ROMBOOT_SPL

#define SPL_STATIC_FUNC     static

#define SPL_STATIC_VAR      static

#else

#define SPL_STATIC_FUNC     

#define SPL_STATIC_VAR      

#endif

#endif /* _CPU_H */

