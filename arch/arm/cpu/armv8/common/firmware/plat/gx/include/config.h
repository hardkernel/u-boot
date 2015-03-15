/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * Boot ROM top-level configuration
 */

#ifndef _BOOT_ROM_CONFIG_H_
#define _BOOT_ROM_CONFIG_H_

/***********************************************************
 * The following constants are GXBB definition
 **********************************************************/
#define ROMBOOT_START   0xD9040000
#define ROM_SIZE        (64*1024)
#define ROMBOOT_END     (ROMBOOT_START+ROM_SIZE)

/***********************************************************
 * AHB-SRAM Total Size 80KB, layout shown as below
 *
 * ROMCODE use the top 32KB
 *
 * [	512]	0xD901_3E00 - 0xD901_3FFF	Debug Info
 * [	512]	0xD901_3C00 - 0xD901_3DFF	eFuse mirror
 * [	 1K]	0xD901_3800 - 0xD901_3BFF	Secure Mailbox (3)
 * [	 1K]	0xD901_3400 - 0xD901_37FF	High Mailbox (2) *
 * [	 1K]	0xD901_3000 - 0xD901_33FF	High Mailbox (1) *
 * [	26K]	0xD900_C800 - 0xD901_2FFF	BL1 Stack, BSS
 * [	 1K]	0xD900_C400 - 0xD900_C7FF	NAND, USB Buffer
 * [	 1K]	0xD900_C000 - 0xD900_C3FF	Reserved
 *
 **********************************************************/
#define RAM_START			0xD9000000
#define RAM_SIZE			(80 * 1024)
#define BL1_RAM_START			(RAM_START + 0xC000)
#define BL1_RAM_SIZE			(32 * 1024)
#define BL1_RAM_END			(BL1_RAM_START + BL1_RAM_SIZE)
#define BSS_START			(BL1_RAM_START + (2 * 1024))
#define BSS_SIZE			(18 * 1024)
#define _STACK_END			(BSS_START + BSS_SIZE + 8*1024)
#define BL1_EFUSE_MIRROR		(BL1_RAM_END - 512)
#define P_SHARED_EFUSE_MIRROR		(volatile uint32_t *)(BL1_EFUSE_MIRROR)
#define BL1_SEC_MBX			(BL1_RAM_END - 1024)
#define BL1_NAND_BUFF			(BL1_RAM_START + 1024)
#define BL1_USB_BUFF			(BL1_NAND_BUFF)

#define MEMORY_LOC			RAM_START

/* BL2 SPL size */
#define BL2_SIZE			(48 * 1024)

//for signature test
#define CONFIG_AML_SIG_TEST_BUILD

/* Software SHA2 */
//#define CONFIG_SHA2_SW

/* Hardware SHA2 */
#define CONFIG_SHA2_HW

/* Keep timer config in conf.h */
#define CONFIG_TIMER

/* Mincrypt RSA library */
#define CONFIG_MINCRYPT

/* PolarSSL RSA library */
#define CONFIG_POLARSSL_RSA

#ifdef CONFIG_POLARSSL_RSA
#ifndef CONFIG_MALLOC
#define CONFIG_MALLOC
#endif /* ! CONFIG_MALLOC */
#endif /* CONFIG_POLARSSL_RSA */

#endif /* _BOOT_ROM_CONFIG_H_ */
