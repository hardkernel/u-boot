/*
 * Copyright (C) 2012 Samsung Electronics
 *
 * Configuration settings for the SAMSUNG SMDK4412 (EXYNOS4412) board.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#ifndef __CONFIG_H
#define __CONFIG_H

/* High Level Configuration Options */
#define CONFIG_SAMSUNG			1	/* in a SAMSUNG core */
#define CONFIG_S5P			1	/* S5P Family */
#define CONFIG_ARCH_EXYNOS		1       /* which is in a Exynos Family */
#define CONFIG_EXYNOS4X12		1	/* which is a EXYNOS4x12 SoC */
#define CONFIG_EXYNOS4212		1	/* which is a EXYNOS4212 SoC */
#define CONFIG_SMDKV310			1	/* working with SMDKV310*/

#define CONFIG_BL_MONITOR

#define CONFIG_TRUSTZONE
#define CONFIG_TRUSTZONE_RESERVED_DRAM	0x100000
#ifdef CONFIG_TRUSTZONE
#define CONFIG_PHY_IRAM_BASE            (0x02020000)
#define CONFIG_PHY_IRAM_NS_BASE         (CONFIG_PHY_IRAM_BASE + 0x2F000)
#endif

/* Configuration of secure boot */
#undef CONFIG_UBOOT_SECURE_BOOT
#define CONFIG_TZSW_SECURE_BOOT
#undef CONFIG_SECURE_BOOT

#ifdef CONFIG_SECURE_BOOT
#define CONFIG_UBOOT_SECURE_BOOT
#define CONFIG_TZSW_SECURE_BOOT
#define CONFIG_SECURE_ROOTFS
#define CONFIG_SECURE_CONTEXT_BASE      0x40003800
#define CONFIG_SECURE_KERNEL_BASE       0x40008000
#define CONFIG_SECURE_KERNEL_SIZE       0x400000
#define CONFIG_SECURE_ROOTFS_BASE       0x41000000
#define CONFIG_SECURE_ROOTFS_SIZE       0x100000
#endif

/* APLL : 800MHz */
/* #define CONFIG_CLK_ARM_800_APLL_800 */
/* APLL : 1GHz */
#define CONFIG_CLK_ARM_1000_APLL_1000
/* APLL : 1.5GHz */
/* #define CONFIG_CLK_ARM_1500_APLL_1500 */

#ifdef CONFIG_EXYNOS4412_EVT2
/* bus clock: 220Mhz, DMC clock 440Mhz */
#define CONFIG_CLK_BUS_DMC_220_440
#else
/* bus clock: 200Mhz, DMC clock 400Mhz */
#define CONFIG_CLK_BUS_DMC_200_400
#endif

/* Power Management is enabled */
#define CONFIG_PM_VDD_ARM	1.1
#define CONFIG_PM_VDD_INT	1.1
#define CONFIG_PM_VDD_G3D	1.1
#define CONFIG_PM_VDD_MIF	1.1
#define CONFIG_PM_VDD_LDO14	1.8

#include <asm/arch/cpu.h>		/* get chip and board defs */

#define CONFIG_ARCH_CPU_INIT
#define CONFIG_DISPLAY_CPUINFO
#define CONFIG_DISPLAY_BOARDINFO

/* Mach Type */
#define CONFIG_MACH_TYPE		MACH_TYPE_SMDK4212

/* Keep L2 Cache Disabled */
#define CONFIG_L2_OFF			1

/* Offset for OM status registers */
#define OM_STATUS_OFFSET	0x0

/* Offset for inform registers */
#define INFORM0_OFFSET		0x800
#define INFORM1_OFFSET		0x804
#define INFORM2_OFFSET		0x808
#define INFORM3_OFFSET		0x80C

/* Boot configuration */
#define BOOT_ONENAND		0x1
#define BOOT_NAND		0x40000
#define BOOT_MMCSD		0x3
#define BOOT_NOR		0x4
#define BOOT_SEC_DEV		0x5
#define BOOT_EMMC		0x6
#define BOOT_EMMC_4_4		0x7
#define BOOT_USB		0x8

/* Boot device */
#define SDMMC_CH2		0x0
#define SDMMC_CH0		0x4
#define EMMC			0x10
#define EMMC_4_4		0x14
#define USB			0x40

#define CONFIG_BOARD_LATE_INIT

#define CONFIG_SYS_SDRAM_BASE		0x40000000
#define CONFIG_SYS_TEXT_BASE		0x43E00000

/* input clock of PLL: SMDKV310 has 24MHz input clock */
#define CONFIG_SYS_CLK_FREQ		24000000

#define CONFIG_CLK_BUS_DMC_200_400

#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG
#define CONFIG_INITRD_TAG
#define CONFIG_CMDLINE_EDITING

/* Handling Sleep Mode*/
#define S5P_CHECK_SLEEP			0x00000BAD
#define S5P_CHECK_DIDLE			0xBAD00000

/* Size of malloc() pool */
#define CONFIG_SYS_MALLOC_LEN		(CONFIG_ENV_SIZE + (1 << 20))

/* select serial console configuration */
#define CONFIG_SERIAL_MULTI		1
#define CONFIG_SERIAL1			1	/* use SERIAL 1 */
#define CONFIG_BAUDRATE			115200
#define EXYNOS4_DEFAULT_UART_OFFSET	0x010000

/* SD/MMC configuration */
#define CONFIG_GENERIC_MMC
#define CONFIG_MMC
#define CONFIG_SDHCI
#define CONFIG_S5P_SDHCI
#define CONFIG_S5P_MSHC

#if defined(CONFIG_S5P_MSHC)
#define CONFIG_SKIP_MMC_STOP_CMD
#define CONFIG_MMC_EARLY_INIT
#define MMC_MAX_CHANNEL		5

#define USE_MMC4

#define PHASE_DEVIDER			4

#define SDR_CH4			0x00010001
#define DDR_CH4			0x00010001
#endif

/* PWM */
#define CONFIG_PWM			1

/* allow to overwrite serial and ethaddr */
#define CONFIG_ENV_OVERWRITE

/* Command definition*/
#include <config_cmd_default.h>

#define CONFIG_CMD_PING
#define CONFIG_CMD_ELF
#define CONFIG_CMD_DHCP
#define CONFIG_CMD_MMC
#define CONFIG_CMD_EXT2
#define CONFIG_CMD_NET
#define CONFIG_CMD_FAT
#define CONFIG_CMD_BOOTZ

#define CONFIG_BOOTDELAY		3
#define CONFIG_ZERO_BOOTDELAY_CHECK

/* USB */
#undef CONFIG_CMD_USB
/* EHCI : 2.0 Host */
#undef CONFIG_USB_EHCI
#undef CONFIG_USB_EHCI_EXYNOS
#undef CONFIG_USB_STORAGE

/* OHCI : Host 1.0 */
#define CONFIG_USB_OHCI
#undef CONFIG_USB_CPUMODE

#define CONFIG_S3C_USBD

#define USBD_DOWN_ADDR                  0x40000000
#define EXYNOS_SYSREG_BASE              EXYNOS4_SYSREG_BASE

/*
 *  Fast Boot
*/
/* Fastboot variables */
#define CONFIG_FASTBOOT

#define CFG_FASTBOOT_TRANSFER_BUFFER            (0x48000000)
#define CFG_FASTBOOT_TRANSFER_BUFFER_SIZE       (0x10000000)   /* 256MB */
#define CFG_FASTBOOT_ADDR_KERNEL                (0x40008000)
#define CFG_FASTBOOT_ADDR_RAMDISK               (0x40800000)
#define CFG_FASTBOOT_PAGESIZE                   (2048)  // Page size of booting device
#define CFG_FASTBOOT_SDMMC_BLOCKSIZE            (512)   // Block size of sdmmc
#define CFG_FASTBOOT_SDMMCBSP

/* MMC SPL */
#define CONFIG_SPL
#define COPY_BL2_FNPTR_ADDR	0x00002488

#define CONFIG_BOOTCOMMAND	"movi r k 0 40008000; movi r r 0 41000000 100000; bootz 40008000 41000000"

#define CONFIG_RECOVERYCOMMAND	\
		"emmc partition 0 10 0;"	\
		"mmc erase user 0 1072 1;"	\
		"movi r f 1 40000000;emmc open 0;movi w z f 0 40000000;emmc close 0;"	\
		"movi r b 1 40000000;emmc open 0;movi w z b 0 40000000;emmc close 0;"	\
		"movi r u 1 40000000;emmc open 0;movi w z u 0 40000000;emmc close 0;"	\
		"movi r t 1 40000000;emmc open 0;movi w z t 0 40000000;emmc close 0;"	\
		"reset"

/* Configuration for factory reset mode */
#define CONFIG_FACTORY_RESET_MODE		0xf
#define CONFIG_FACTORY_RESET_BOOTCOMMAND	\
		"ext3format mmc 0:3;ext3format mmc 0:4;"	\
		"movi read kernel 0 40008000;"			\
		"movi read rootfs 0 41000000 100000;"		\
		"bootz 40008000 41000000"

/* Configuration of ROOTFS_ATAGS */
#define CONFIG_ROOTFS_ATAGS
#ifdef CONFIG_ROOTFS_ATAGS
#define CONFIG_EXTRA_ENV_SETTINGS	"rootfslen= 100000"
#endif

/* Miscellaneous configurable options */
#define CONFIG_SYS_LONGHELP		/* undef to save memory */
#define CONFIG_SYS_HUSH_PARSER		/* use "hush" command parser	*/
#define CONFIG_SYS_PROMPT		"SMDK4212 # "
#define CONFIG_SYS_CBSIZE		256	/* Console I/O Buffer Size*/
#define CONFIG_SYS_PBSIZE		384	/* Print Buffer Size */
#define CONFIG_SYS_MAXARGS		16	/* max number of command args */
#define CONFIG_DEFAULT_CONSOLE		"console=ttySAC2,115200n8\0"
/* Boot Argument Buffer Size */
#define CONFIG_SYS_BARGSIZE		CONFIG_SYS_CBSIZE
/* memtest works on */
#define CONFIG_SYS_MEMTEST_START	CONFIG_SYS_SDRAM_BASE
#define CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_SDRAM_BASE + 0x6000000)
#define CONFIG_SYS_LOAD_ADDR		(CONFIG_SYS_SDRAM_BASE + 0x3E00000)

#define CONFIG_SYS_HZ			1000

/* Stack sizes */
#define CONFIG_STACKSIZE		(256 << 10)	/* 256KB */
#undef  USE_2G_DRAM

#ifdef  USE_2G_DRAM
#define CONFIG_NR_DRAM_BANKS	8
#else
#define CONFIG_NR_DRAM_BANKS	4
#endif
#define SDRAM_BANK_SIZE		(256UL << 20UL)	/* 256 MB */
#define PHYS_SDRAM_1		CONFIG_SYS_SDRAM_BASE
#define PHYS_SDRAM_1_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_2		(CONFIG_SYS_SDRAM_BASE + SDRAM_BANK_SIZE)
#define PHYS_SDRAM_2_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_3		(CONFIG_SYS_SDRAM_BASE + (2 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_3_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_4		(CONFIG_SYS_SDRAM_BASE + (3 * SDRAM_BANK_SIZE))
#ifdef  USE_2G_DRAM
#define PHYS_SDRAM_4_SIZE	SDRAM_BANK_SIZE
#else
#define PHYS_SDRAM_4_SIZE	(SDRAM_BANK_SIZE                        \
                                        - CONFIG_TRUSTZONE_RESERVED_DRAM)
#endif
#define PHYS_SDRAM_5		(CONFIG_SYS_SDRAM_BASE + (4 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_5_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_6		(CONFIG_SYS_SDRAM_BASE + (5 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_6_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_7		(CONFIG_SYS_SDRAM_BASE + (6 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_7_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_8		(CONFIG_SYS_SDRAM_BASE + (7 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_8_SIZE	(SDRAM_BANK_SIZE                        \
                                        - CONFIG_TRUSTZONE_RESERVED_DRAM)
/* FLASH and environment organization */
#define CONFIG_SYS_NO_FLASH		1
#undef	CONFIG_CMD_IMLS
#define CONFIG_IDENT_STRING		" for SMDK4212"

#ifdef CONFIG_USE_IRQ
#define CONFIG_STACKSIZE_IRQ		(4*1024)	/* IRQ stack */
#define CONFIG_STACKSIZE_FIQ		(4*1024)	/* FIQ stack */
#endif

#define CONFIG_CLK_1000_400_200

/* MIU (Memory Interleaving Unit) */
#define CONFIG_MIU_2BIT_INTERLEAVED

#define CONFIG_ENV_IS_IN_MMC		1
#define CONFIG_SYS_MMC_ENV_DEV		0
#define CONFIG_ENV_SIZE			(16 << 10)	/* 16 KB */
#define RESERVE_BLOCK_SIZE		(512)
#define BL1_SIZE			(16 << 10) /*16 K reserved for BL1*/
#define CONFIG_ENV_OFFSET		(RESERVE_BLOCK_SIZE + BL1_SIZE)
#define CONFIG_DOS_PARTITION		1
#define CFG_PARTITION_START             0x4000000

#define CONFIG_SYS_INIT_SP_ADDR	(CONFIG_SYS_LOAD_ADDR - GENERATED_GBL_DATA_SIZE)

/* U-boot copy size from boot Media to DRAM.*/
#define	COPY_BL2_SIZE		0x80000
#define BL2_START_OFFSET	((CONFIG_ENV_OFFSET + CONFIG_ENV_SIZE)/512)
#define BL2_SIZE_BLOC_COUNT	(COPY_BL2_SIZE/512)

/* Base address for secondary boot information */
#define CONFIG_SECONDARY_BOOT_INFORM_BASE       (CONFIG_SYS_TEXT_BASE - 0x8)

/* Ethernet Controllor Driver */
#ifdef CONFIG_CMD_NET
#define CONFIG_SMC911X
#define CONFIG_SMC911X_BASE		0x5000000
#define CONFIG_SMC911X_16_BIT
#define CONFIG_ENV_SROM_BANK		1
#endif /*CONFIG_CMD_NET*/

/* Enable devicetree support */
#define CONFIG_OF_LIBFDT
#endif	/* __CONFIG_H */
