
/*
 * arch/arm/include/asm/arch-txl/cpu_config.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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
 * [	128]	0xD901_3F80 - 0xD901_3FFF	Reserved
 * [	128]	0xD901_3F00 - 0xD901_3F7F	CPUs Boot Entry
 * [	256]	0xD901_3E00 - 0xD901_3EFF	Debug Info
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
#define BL1_EFUSE_MIRROR		(BL1_RAM_END - 1024)
#define P_SHARED_EFUSE_MIRROR		(volatile uint32_t *)(BL1_EFUSE_MIRROR)
#define BL1_DEBUG_BUFFER		(BL1_RAM_END - 512)
#define CPU_BOOT_ENTRY		(BL1_DEBUG_BUFFER + 256)
#define P_SHARED_DEBUG_BUFF		(volatile uint32_t *)(BL1_DEBUG_BUFFER)
#define BL1_SEC_MBX			(BL1_RAM_END - 2*1024)
#define BL1_NAND_BUFF			(BL1_RAM_START + 1024)
#define BL1_USB_BUFF			(BL1_NAND_BUFF)

#define MEMORY_LOC			RAM_START

#define SRAM_DEBUG_BUFF_SIZE		256

/* BL2 SPL size */
#define BL2_SIZE			(64 * 1024)

//for signature test
//#define CONFIG_AML_SIG_TEST_BUILD

/* Software SHA2 */
#define CONFIG_SHA2_SW

/* Hardware SHA2 */
#define CONFIG_SHA2_HW
#define SHA2_HW_UPDATE_API

/* Keep timer config in conf.h */
#define CONFIG_TIMER

/* Bootrom debug info */
#define CONFIG_DEBUG_INFO

/* Mincrypt RSA library */
//#define CONFIG_MINCRYPT

/* PolarSSL RSA library */
#define CONFIG_POLARSSL_RSA

#ifdef CONFIG_POLARSSL_RSA
#ifndef CONFIG_MALLOC
#define CONFIG_MALLOC
#endif /* ! CONFIG_MALLOC */
#endif /* CONFIG_POLARSSL_RSA */

#endif /* _BOOT_ROM_CONFIG_H_ */
