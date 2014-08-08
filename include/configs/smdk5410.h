/*
 * Copyright (C) 2011 Samsung Electronics
 *
 * Configuration settings for the SAMSUNG SMDK5410 (EXYNOS5410) board.
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
#define CONFIG_ARMV7
#define CONFIG_SAMSUNG			/* in a SAMSUNG core */
#define CONFIG_S5P			/* S5P Family */
#define CONFIG_EXYNOS5			/* which is in a Exynos5 Family */
#define CONFIG_SMDK5410			/* which is in a SMDK5410 */
#define CONFIG_ARCH_EXYNOS
#define CONFIG_ARCH_EXYNOS5
#define CONFIG_MACH_SMDK5410
#define CONFIG_CPU_EXYNOS5410		/* which is in a Exynos5410 */
#define CONFIG_CPU_EXYNOS5410_EVT2	/* which is in a Exynos5410 EVT2 */
/*
#define CONFIG_MACH_UNIVERSAL5410
*/
#undef CONFIG_MACH_ASB5410

/* Clock Speed Selection */
#ifdef CONFIG_MACH_UNIVERSAL5410
#define CONFIG_CLK_ARM_800
#define CONFIG_CLK_KFC_600
#else
#define CONFIG_CLK_ARM_900
#define CONFIG_CLK_KFC_600
#endif

/* Memory type	*/
#define CONFIG_LPDDR3
#define CONFIG_BTS_SUPPORT

/* MCLK_CDREX	*/
#define MCLK_CDREX_800			1

#include <asm/arch/cpu.h>		/* get chip and board defs */

#define CONFIG_ARCH_CPU_INIT
#define CONFIG_DISPLAY_CPUINFO
/*
#define CONFIG_BOARD_EARLY_INIT_F
#define CONFIG_DISPLAY_BOARDINFO */
#define CONFIG_BOARD_LATE_INIT

/* Bootloader Recovery */
#if defined(CONFIG_MACH_UNIVERSAL5410) || defined(CONFIG_MACH_ASB5410)
#undef CONFIG_RECOVERY_MODE
#else
#define CONFIG_RECOVERY_MODE
#endif

/* Keep L2 Cache Disabled */
#define CONFIG_SYS_DCACHE_OFF

#define CONFIG_SYS_SDRAM_BASE		0x40000000
#define CONFIG_SYS_TEXT_BASE		0x43E00000

/* TRUSTZONE */
#define CONFIG_TRUSTZONE
#define CONFIG_TRUSTZONE_RESERVED_DRAM	0x200000
#ifdef CONFIG_TRUSTZONE
#define CONFIG_BOOTLOADER_MONITOR
#define CONFIG_PHY_IRAM_BASE		(0x02020000)
#define CONFIG_PHY_IRAM_NS_BASE		(CONFIG_PHY_IRAM_BASE + 0x53000)
#endif

/* input clock of PLL: SMDK5410 has 24MHz input clock */
#define CONFIG_SYS_CLK_FREQ		24000000

#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG
#define CONFIG_INITRD_TAG
#define CONFIG_CMDLINE_EDITING

/* MACH_TYPE_SMDK5410 macro will be removed once added to mach-types */
#define CONFIG_MACH_TYPE		MACH_TYPE_SMDK5410

/* Power Down Modes */
#define S5P_CHECK_SLEEP			0x00000BAD
#define S5P_CHECK_DIDLE			0xBAD00000
#define S5P_CHECK_LPA			0xABAD0000

/* Offset for OM status registers */
#define OM_STATUS_OFFSET		0x0

/* Offset for inform registers */
#define INFORM0_OFFSET			0x800
#define INFORM1_OFFSET			0x804
#define INFORM2_OFFSET			0x808
#define INFORM3_OFFSET			0x80C

/* Size of malloc() pool */
#define CONFIG_SYS_MALLOC_LEN		(CONFIG_ENV_SIZE + (1 << 20))

/* select serial console configuration */
#define CONFIG_SERIAL_MULTI
#ifdef CONFIG_MACH_ASB5410
#define CONFIG_SERIAL3			/* use SERIAL 3 */
#else
#define CONFIG_SERIAL2			/* use SERIAL 2 */
#endif
#define CONFIG_BAUDRATE			115200
#define EXYNOS5_DEFAULT_UART_OFFSET	0x010000

#define TZPC_BASE_OFFSET		0x10000

/* SD/MMC configuration */
#define CONFIG_GENERIC_MMC
#define CONFIG_MMC
#define CONFIG_SDHCI
#define CONFIG_S5P_MSHC
#define CONFIG_S5P_SDHCI

#if defined(CONFIG_S5P_MSHC)
#define CONFIG_SKIP_MMC_STOP_CMD
#define CONFIG_MMC_EARLY_INIT
#define MMC_MAX_CHANNEL         4

#define USE_MMC0
#define USE_MMC2

#define PHASE_DEVIDER           4

#define SDR_CH0                 0x03030002
#define DDR_CH0                 0x03020001

#define SDR_CH2                 0x03020001
#define DDR_CH2                 0x03030002

#define SDR_CH4                 0x0
#define DDR_CH4                 0x0
#endif

/* PWM */
#define CONFIG_PWM

/* allow to overwrite serial and ethaddr */
#define CONFIG_ENV_OVERWRITE

/* Command definition*/
#include <config_cmd_default.h>

#define CONFIG_BL_MONITOR
#ifndef CONFIG_CPU_EXYNOS5410_EVT0
#define CONFIG_SECURE_TZSW_ONLY
#endif
/*
#define CONFIG_SECURE_BOOT
*/

#define CONFIG_CMD_PING
#define CONFIG_CMD_ELF
#define CONFIG_CMD_MMC
#define CONFIG_CMD_EXT2
#define CONFIG_CMD_FAT

#define CONFIG_CMD_MOVI
#define CONFIG_CMD_MOVINAND
#define CONFIG_CMD_BOOTZ

#define CONFIG_BOOTDELAY		3
#define CONFIG_ZERO_BOOTDELAY_CHECK

/* USB */
#define CONFIG_CMD_USB
#define CONFIG_USB_EHCI
#define CONFIG_USB_EHCI_EXYNOS
#define CONFIG_USB_STORAGE

/* OHCI : Host 1.0 */
#define CONFIG_USB_OHCI
#define CONFIG_EXYNOS_USBD3
#undef CONFIG_USB_CPUMODE

#ifdef CONFIG_EXYNOS_USBD3
#ifdef CONFIG_MACH_UNIVERSAL5410
#define CONFIG_EXYNOS_USBD3_CH0
#else
#define CONFIG_EXYNOS_USBD3_CH0
/*#define CONFIG_EXYNOS_USBD3_CH1*/
#endif
#else
#undef CONFIG_S3C_USBD
#endif

#define USBD_DOWN_ADDR                  0x40000000
#define EXYNOS_SYSREG_BASE              EXYNOS5_SYSREG_BASE
#define EXYNOS_POWER_BASE               EXYNOS5_POWER_BASE

/*
 * USBD 3.0 SFR
 */
#define USBDEVICE3_LINK_CH0_BASE	0x12000000
#define USBDEVICE3_PHYCTRL_CH0_BASE	0x12100000
#define USBDEVICE3_LINK_CH1_BASE	0x12400000
#define USBDEVICE3_PHYCTRL_CH1_BASE	0x12500000

#define EXYNOS_USB_PHY_BASE             EXYNOS5_USBPHY_BASE
#define EXYNOS_USB_LINK_BASE            EXYNOS5_USBOTG_BASE

/*
 * FASTBOOT
 */
#define CONFIG_FASTBOOT
#define CFG_FASTBOOT_SDMMCBSP

/* Fastboot variables */
#define CFG_FASTBOOT_TRANSFER_BUFFER            (0x48000000)
#define CFG_FASTBOOT_TRANSFER_BUFFER_SIZE       (0x30000000)   /* 768MB */
#define CFG_FASTBOOT_ADDR_KERNEL                (0x40008000)
#define CFG_FASTBOOT_ADDR_RAMDISK               (0x41000000)
#define CFG_FASTBOOT_PAGESIZE                   (2048)  // Page size of booting device
#define CFG_FASTBOOT_SDMMC_BLOCKSIZE            (512)   // Block size of sdmmc

#ifdef CONFIG_CPU_EXYNOS5410_EVT2
/* CFG_FASTBOOT_TRANSFER_BUFFER + CFG_FASTBOOT_TRANSFER_BUFFER_SIZE */
#define CFG_FASTBOOT_MMC_BUFFER			(0x78000000)
#endif

#ifdef CONFIG_CMD_MOVINAND
#define CONFIG_FASTBOOT
#define CFG_FASTBOOT_SDMMCBSP
#endif

/* MMC SPL */
#define CONFIG_SPL

#ifdef CONFIG_SECURE_BOOT
#define CONFIG_BOOTCOMMAND	"emmc open 0;movi r z f 0 40000000;emmc close 0;"	\
				"movi read kernel 0 40008000;movi read rootfs 0 41000000 100000;bootz 40008000 41000000"
#else
#define CONFIG_BOOTCOMMAND	"movi read kernel 0 40008000;movi read rootfs 0 41000000 100000;bootz 40008000 41000000"
#endif

#define CONFIG_BOOTARGS	""

#define CONFIG_BOOTCOMMAND2	\
		"movi r f 1 40000000;emmc open 0;movi w z f 0 40000000;emmc close 0;"	\
		"movi r b 1 40000000;emmc open 0;movi w z b 0 40000000;emmc close 0;"	\
		"movi r u 1 40000000;emmc open 0;movi w z u 0 40000000;emmc close 0;"	\
		"movi r t 1 40000000;emmc open 0;movi w z t 0 40000000;emmc close 0;"	\
		"reset"
		/*
		"mmc erase user 0 1072 1;"	\
		"movi r f 1 40000000;emmc open 0;movi w z f 0 40000000;emmc close 0;"	\
		"movi r b 1 40000000;emmc open 0;movi w z b 0 40000000;emmc close 0;"	\
		"movi r u 1 40000000;emmc open 0;movi w z u 0 40000000;emmc close 0;"	\
		"movi r t 1 40000000;emmc open 0;movi w z t 0 40000000;emmc close 0;"	\
		"movi r k 1 40000000;movi w k 0 40000000;"				\
		"movi r r 1 40000000 100000;movi w r 0 40000000 100000;"		\
		"fdisk -c 0;"								\
		"movi init 0;"								\
		"fatformat mmc 0:1;"							\
		"mmc read 1 48000000 20000 a0000;"					\
		"fastboot flash system 48000000;"					\
		"mmc read 1 48000000 c0000 a0000;"					\
		"fastboot flash userdata 48000000;"					\
		"mmc read 1 48000000 160000 a0000;"					\
		"fastboot flash cache 48000000;"					\
		"reset"
		*/

/* Configuration for factory reset mode */
#define CONFIG_FACTORY_RESET_MODE		0xf
#define CONFIG_FACTORY_RESET_BOOTCOMMAND	\
		"ext3format mmc 0:3;ext3format mmc 0:4;"				\
		"movi read kernel 0 40008000;"						\
		"movi read rootfs 0 41000000 100000;"					\
		"bootz 40008000 41000000"

/* Configuration of ROOTFS_ATAGS */
#define CONFIG_ROOTFS_ATAGS
#ifdef CONFIG_ROOTFS_ATAGS
#define CONFIG_EXTRA_ENV_SETTINGS       "rootfslen= 100000"
#endif

/* Miscellaneous configurable options */
#define CONFIG_SYS_LONGHELP		/* undef to save memory */
#define CONFIG_SYS_HUSH_PARSER		/* use "hush" command parser	*/
#define CONFIG_SYS_PROMPT		"SMDK5410 # "
#define CONFIG_SYS_CBSIZE		256	/* Console I/O Buffer Size */
#define CONFIG_SYS_PBSIZE		384	/* Print Buffer Size */
#define CONFIG_SYS_MAXARGS		16	/* max number of command args */
#define CONFIG_DEFAULT_CONSOLE		"console=ttySAC1,115200n8\0"
/* Boot Argument Buffer Size */
#define CONFIG_SYS_BARGSIZE		CONFIG_SYS_CBSIZE
/* memtest works on */
#define CONFIG_SYS_MEMTEST_START	CONFIG_SYS_SDRAM_BASE
#define CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_SDRAM_BASE + 0x5E00000)
#define CONFIG_SYS_LOAD_ADDR		(CONFIG_SYS_SDRAM_BASE + 0x3E00000)

#define CONFIG_SYS_HZ			1000

#define CONFIG_RD_LVL

/* Stack sizes */
#define CONFIG_STACKSIZE		(256 << 10)	/* 256KB */

#define CONFIG_NR_DRAM_BANKS	8
#define SDRAM_BANK_SIZE		(256UL << 20UL)	/* 256 MB */
#define PHYS_SDRAM_1		CONFIG_SYS_SDRAM_BASE
#define PHYS_SDRAM_1_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_2		(CONFIG_SYS_SDRAM_BASE + SDRAM_BANK_SIZE)
#define PHYS_SDRAM_2_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_3		(CONFIG_SYS_SDRAM_BASE + (2 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_3_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_4		(CONFIG_SYS_SDRAM_BASE + (3 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_4_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_5		(CONFIG_SYS_SDRAM_BASE + (4 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_5_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_6		(CONFIG_SYS_SDRAM_BASE + (5 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_6_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_7		(CONFIG_SYS_SDRAM_BASE + (6 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_7_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_8		(CONFIG_SYS_SDRAM_BASE + (7 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_8_SIZE	(SDRAM_BANK_SIZE - \
                                               CONFIG_TRUSTZONE_RESERVED_DRAM)


#define CONFIG_SYS_MONITOR_BASE	0x00000000

/* FLASH and environment organization */
#define CONFIG_SYS_NO_FLASH
#undef CONFIG_CMD_IMLS
#define CONFIG_IDENT_STRING		" for SMDK5410"

#define CONFIG_ENV_IS_IN_MMC
#define CONFIG_SYS_MMC_ENV_DEV		0

#ifdef CONFIG_SECURE_BOOT
#define CONFIG_SECURE_ROOTFS
#define CONFIG_SECURE_KERNEL_BASE	0x40008000
#define CONFIG_SECURE_KERNEL_SIZE	0x400000
#define CONFIG_SECURE_ROOTFS_BASE	0x41000000
#define CONFIG_SECURE_ROOTFS_SIZE	0x100000
#endif

/* Power Management is enabled */
#define CONFIG_PM
#ifdef CONFIG_MACH_UNIVERSAL5410
#define CONFIG_PM_VDD_ARM	1.0750
#define CONFIG_PM_VDD_KFC	1.0500
#define CONFIG_PM_VDD_INT	1.1875
#define CONFIG_PM_VDD_G3D	1.00
#define CONFIG_PM_VDD_MIF	1.0625
#else
#define CONFIG_PM_VDD_ARM	1.20
#define CONFIG_PM_VDD_KFC	1.20
#define CONFIG_PM_VDD_INT	1.05
#define CONFIG_PM_VDD_G3D	1.20
#define CONFIG_PM_VDD_MIF	1.05
#endif

/* Boot configuration */
#define BOOT_ONENAND		0x1
#define BOOT_NAND		0x40000
#define BOOT_MMCSD		0x3
#define BOOT_NOR		0x4
#define BOOT_SEC_DEV		0x5
#define BOOT_EMMC		0x6
#define BOOT_EMMC_4_4		0x7
#define BOOT_USB                0x100

/* Boot device */
#define SDMMC_CH2               0x0
#define SDMMC_CH0               0x4
#define EMMC                    0x14
#define SATA                    0x18
#define SPI_SF                  0x28
#define SFMC                    0x34
#define USB                     0x40

/* Configuration of ENV size on mmc */
#define CONFIG_ENV_SIZE		(16 << 10)	/* 16 KB */

#include <asm/arch/movi_partition.h>

/* U-boot copy size from boot Media to DRAM.*/
#define BL2_START_OFFSET	(CONFIG_BL2_OFFSET/512)
#define BL2_SIZE_BLOC_COUNT	(CONFIG_BL2_SIZE/512)
#define CONFIG_DOS_PARTITION
#define CFG_PARTITION_START	0x4000000

#define CONFIG_IRAM_STACK	0x02074000

#define CONFIG_SYS_INIT_SP_ADDR	(CONFIG_SYS_LOAD_ADDR - 0x1000000)

/* Ethernet Controllor Driver */
#ifdef CONFIG_CMD_NET
#define CONFIG_NET_MULTI
#endif /*CONFIG_CMD_NET*/

/* Base address for secondary boot information */
#define CONFIG_SECONDARY_BOOT_INFORM_BASE	(CONFIG_SYS_TEXT_BASE - 0x8)

/* Enable devicetree support */
/* #define CONFIG_OF_LIBFDT  */

#endif	/* __CONFIG_H */
