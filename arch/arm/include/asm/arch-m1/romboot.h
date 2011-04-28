/*
 * romboot.h
 *
 *  Created on: 2010-6-22
 *      Author: yuhao
 *      This file described romboot area usage and power on settings
 */

#ifndef _M1_ROMBOOT_H_
#define _M1_ROMBOOT_H_
#include "cpu.h"
#define POR_ROM_BOOT_ENABLE                         (1<<7)
#define POR_JTAG_ENABLE                             (1<<6)
//Power On setting
#define POR_INTL_CFG_MASK                           (7<<0)
#define POR_INTL_NAND_LP                            (7<<0)
#define POR_INTL_SPI                                (5<<0)
#define POR_INTL_SDIO_B1                            (6<<0)
#define POR_INTL_NAND_SP                            (4<<0)
#define POR_GET_INTL_CFG(a)                         (a&POR_INTL_CFG_MASK)
#define POR_SDIO_CFG_MASK                           (3<<8)
#define POR_SDIO_A_ENABLE                           (3<<8)
#define POR_SDIO_B_ENABLE                           (1<<8)
#define POR_SDIO_C_ENABLE                           (2<<8)
//#define POR_SDIO_B1_ENABLE                          (0<<8)
#define POR_GET_SDIO_CFG(a)                         ((a&POR_SDIO_CFG_MASK))
#define POR_ASSIST_CONFIG                           P_ASSIST_POR_CONFIG
/*
 * "MESON001"
 */
#define MAGIC_WORD1         0x4f53454d
#define MAGIC_WORD2         0x3130304e
#define CONFIG_ROMBOOT_READ_SIZE    6*1024
#define READ_SIZE       	6*1024      // memory size for data reading
#define CONFIG_NAND_PAGES         1024
#define ROM_BOOT_INFO                               (AHB_SRAM_BASE + 0x1f00)
#define MAGIC_STRUCT_OFF							(AHB_SRAM_BASE +0x1b0)
/**
 * rom debug area structure offsets
 */
#define POR_CFG	0
#define BOOT_ID	4
#define LOAD_0	8
#define LOAD_1	12
#define DCHK_0	16
#define DCHK_1	20
#define NAND_ADDR	24
#define CARD_TYPE	28
#ifndef __ASSEMBLY__
/**
 * rom debug area structure (c format)
 */
typedef struct {
    unsigned  por_cfg; // current boot configuration
    unsigned  boot_id; // boot from which device
    int       load[2];
    int       dchk[2];
    int       nand_addr;
    int       card_type;
    unsigned  clk81;
    unsigned  a9_clk;
} T_ROM_BOOT_RETURN_INFO;
/**
 * magic structure
 */
typedef struct data_format{
    unsigned  magic[2];
    unsigned short crc[2];
} DataFormat ;
extern  T_ROM_BOOT_RETURN_INFO * romboot_info;
extern  DataFormat * magic_info;
#endif
/**
 *
 */
#define    ROM_STACK_END  	(AHB_SRAM_BASE+0x1d80)
#define    ROM_FIQ_STACK	(AHB_SRAM_BASE+0x1e00)
#define    ROM_IRQ_STACK  	(AHB_SRAM_BASE+0x1f00)
#define    _STACK_END       (ROM_IRQ_STACK)
//Temp for arch\arm\cpu\aml_meson\common\firmware\rom_spl.s compile pass, not verify

#endif /* ROMBOOT_H_ */
