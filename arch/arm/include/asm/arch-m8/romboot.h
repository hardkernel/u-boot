/*
 * romboot.h
 *
 *  Created on: 2010-6-22
 *      Author: yuhao
 *      This file described romboot area usage and power on settings
 */

#ifndef __M6TV_ROMBOOT_H__
#define __M6TV_ROMBOOT_H__

#include "cpu.h"

#define RAM_START      (0xD9000000)
#define RAM_SIZE       (0x20000)
#define RAM_END        (RAM_START+RAM_SIZE)
#define MEMORY_LOC     (RAM_START)

#define ROMBOOT_START  (0xD9800000)
#define ROM_SIZE       (16*1024)
#define ROMBOOT_END    (ROMBOOT_START+ROM_SIZE)

#define GL_DATA_ADR    (RAM_END-256)
#define READ_SIZE      (32*1024)
#define CHECK_SIZE     (8*1024)
#define NOR_START_ADDR (0xCC000000)

//note: READ_SIZE is 32KB or 64KB
#define AML_UBOOT_SINFO_OFFSET (READ_SIZE-512-32)

/* USB PCD buff */
#define NAND_INFO_BUF      (RAM_END-2*1024)
#define NAND_INFO_BUF_SIZE (2*1024-256)
#define BSS_SIZE   (30*1024)
#define BSS_START  (RAM_END-32*1024)
#define _STACK_END (BSS_START+BSS_SIZE)
#define PCD_BUFF   (NAND_INFO_BUF)

#define POR_ROM_BOOT_ENABLE (1<<5)
#define POR_JTAG_ENABLE     (1<<6)

#define POR_GET_1ST_CFG(a)         ((((a>>9)&1)<<2)|((a>>6)&3))  //por[9],por[7,6]
#define POR_1ST_NAND                                7
#define POR_1ST_NAND_TOG                            6 
#define POR_1ST_SPI                                 5
#define POR_1ST_SPI_RESERVED                        4
#define POR_1ST_SDIO_C                              3
#define POR_1ST_SDIO_B                              2
#define POR_1ST_SDIO_A                              1
#define POR_1ST_NEVER_CHECKED                       0

#define POR_GET_2ND_CFG(a)    ((a>>2)&3)  //por[3:2]
#define POR_2ND_SDIO_B        3
#define POR_2ND_SDIO_A        2
#define POR_2ND_SDIO_C        1
#define POR_2ND_NEVER_CHECKED 0

//** ECC mode 7, dma 528 bytes(data+parity),Short mode , no scramble
#define DEFAULT_ECC_MODE ((2<<20)|(1<<17)|(7<<14)|(1<<13)|(48<<6)|1)

#define C_ROM_BOOT_DEBUG_LOG (volatile unsigned long *)(GL_DATA_ADR + 0xe0)
//#define DEBUG_EFUSE
#ifndef NULL
#define NULL (void*)0
#endif
#define CARD_TYPE_SD   0
#define CARD_TYPE_SDHC 1
#define CARD_TYPE_MMC  2
#define CARD_TYPE_EMMC 3
#define MAGIC_WORD1    0x4848334d
#ifdef CONFIG_MACHID_CHECK
#define MAGIC_WORD2 machine_arch_type
#else
#define MAGIC_WORD2 0x30564552
#endif //CONFIG_MACHID_CHECK

/**
 * This Section is about the romboot spl's first sector structure
 */
#define ROM_BOOT_INFO     (GL_DATA_ADR)

#ifndef __ASSEMBLY__
typedef struct {
    unsigned por_cfg; // current boot configuration
    unsigned boot_id; // boot from which device
    short init[2];
    short load[2][4];
    short dchk[2][4];
    void*    read;
    unsigned ext;
    unsigned nand_info_adr;
    unsigned loop;
    unsigned efuse_bch_uncor;
} T_ROM_BOOT_RETURN_INFO;
#define C_ROM_BOOT_DEBUG ((volatile T_ROM_BOOT_RETURN_INFO *)(ROM_BOOT_INFO))
extern  T_ROM_BOOT_RETURN_INFO * romboot_info;
typedef struct data_format{
    unsigned magic[2];
    unsigned short crc[2];
} DataFormat;
extern  DataFormat * magic_info;
extern DataFormat  __magic_word;
#else
#define C_ROM_BOOT_DEBUG ((ROM_BOOT_INFO))
#endif //__ASSEMBLY__
//#define AHB_SRAM_BASE RAM_START
#define ROM_STACK_END       (GL_DATA_ADR)
/** SDIO Return **/
#define ERROR_NONE     0
#define ERROR_GO_IDLE1 1
#define ERROR_GO_IDLE2 2
#define ERROR_APP55_1  3
#define ERROR_ACMD41   4
#define ERROR_APP55_2  5
#define ERROR_VOLTAGE_VALIDATION 6
#define ERROR_SEND_CID1 7
#define ERROR_SEND_RELATIVE_ADDR 8
#define ERROR_SEND_CID2    9
#define ERROR_SELECT_CARD  10
#define ERROR_APP55_RETRY3 11
#define ERROR_SEND_SCR     12
#define ERROR_READ_BLOCK   13
#define ERROR_STOP_TRANSMISSION 14
#define ERROR_MAGIC_WORDS 15
#define ERROR_CMD1        16
#define ERROR_MMC_SWITCH_BUS   17
#define ERROR_MMC_SWITCH_BOOT  18
/* Data Check Return */ //
#define ERROR_MAGIC_CHECK_SUM  19
#define ERROR_MAGIC_WORD_ERROR 20
/* NAND Return */ //
#define ERROR_NAND_TIMEOUT     21
#define ERROR_NAND_ECC         22
#define ERROR_NAND_MAGIC_WORD  23
#define ERROR_NAND_INIT_READ   24
#define ERROR_CMD1             16
#define ERROR_MMC_SWITCH_BUS   17
#define ERROR_MMC_SWITCH_BOOT  18
/* Data Check Return */ //
#define ERROR_MAGIC_CHECK_SUM  19
#define ERROR_MAGIC_WORD_ERROR 20
/* NAND Return */ //
#define ERROR_NAND_TIMEOUT 21
#define ERROR_NAND_ECC 22
#define ERROR_NAND_MAGIC_WORD 23
#define ERROR_NAND_INIT_READ 24

#define ERROR_NAND_BLANK_PAGE 25

#define SKIP_BOOT_REG_BACK_ADDR     (ROM_BOOT_INFO + 0X78)

#endif /* __M6TV_ROMBOOT_H__ */
