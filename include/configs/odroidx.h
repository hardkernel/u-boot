/*
 * Copyright (C) 2013  Hardkernel Co.,LTD.
 * Hakjoo Kim <ruppi.kim@hardkernel.com>
 *
 * Configuration settings for the Hardkernel ODROID-X (EXYNOS4412) board.
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
#define CONFIG_CMD_BOOTZ
#define CONFIG_SAMSUNG			/* in a SAMSUNG core */
#define CONFIG_S5P			/* S5P Family */
#define CONFIG_ARCH_EXYNOS		/* which is in a Exynos Family */
#define CONFIG_EXYNOS4			/* which is in a Exynos4 Family */
#define CONFIG_EXYNOS4412		/* which is in a Exynos4412 */
#define CONFIG_BOARDNAME	"Odroid-x"
#define CONFIG_ODROIDX			/* which is in a ODROID-X */

#include <asm/arch/cpu.h>		/* get chip and board defs */

/* input clock of PLL: ODROID-X has 24MHz input clock */
#define CONFIG_SYS_CLK_FREQ		24000000
#define CONFIG_CLK_APLL			1400
#define CONFIG_CLK_MPLL			400
#define CONFIG_SYS_HZ			1000

#define CONFIG_ARCH_CPU_INIT
#define CONFIG_DISPLAY_CPUINFO
#define CONFIG_DISPLAY_BOARDINFO

/* Keep L2 Cache Disabled */
#define CONFIG_SYS_DCACHE_OFF

#define CONFIG_SYS_SDRAM_BASE		0x40000000
#define CONFIG_SYS_TEXT_BASE		0x43E00000

#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG
#define CONFIG_INITRD_TAG
#define CONFIG_CMDLINE_EDITING

/* MACH_TYPE_ODROIDX macro will be removed once added to mach-types */
#define MACH_TYPE_ODROIDX		4289
#define CONFIG_MACH_TYPE		MACH_TYPE_ODROIDX

/* Power Down Modes */
#define S5P_CHECK_SLEEP			0x00000BAD
#define S5P_CHECK_DIDLE			0xBAD00000
#define S5P_CHECK_LPA			0xABAD0000

/* Size of malloc() pool */
#define CONFIG_SYS_MALLOC_LEN		(CONFIG_ENV_SIZE + (1 << 20UL))

/* select serial console configuration */
#define CONFIG_SERIAL_MULTI
#define CONFIG_SERIAL1          1	/* use SERIAL 1 */
#define CONFIG_BAUDRATE			115200
#define EXYNOS4_DEFAULT_UART_OFFSET	0x010000

#define TZPC_BASE_OFFSET		0x10000

/* SD/MMC configuration */
#define CONFIG_GENERIC_MMC
#define CONFIG_MMC
#define CONFIG_SDHCI
#define CONFIG_S5P_SDHCI
#define CONFIG_CMD_MMC
/* #define CONFIG_DWMMC */
/* #define CONFIG_EXYNOS_DWMMC */

#define CONFIG_BOARD_EARLY_INIT_F	1

/* PWM */
#define CONFIG_PWM

/* Command definition*/
#include <config_cmd_default.h>

#define CONFIG_CMD_ELF
#define CONFIG_CMD_MMC
#define CONFIG_CMD_NET

#define CONFIG_BOOTDELAY		1
#define CONFIG_ZERO_BOOTDELAY_CHECK

#define CONFIG_EXTRA_ENV_SETTINGS \
        "usbtty=cdc_acm\0" \
        "hostname=odroid\0" \
        "usbethaddr=00:02:03:04:05:06\0" \
        "loadaddr=0x42000000\0" \
        "console=ttySAC1,115200n8\0" \
        "mmcdev=0:2\0" \
        "mmcroot=/dev/mmcblk0p2 rw\0" \
        "rootwait\0" \
        "mmcargs=setenv bootargs console=${console} " \
	"root=${mmcroot}\0" \
        "loadbootscript=fatload mmc ${mmcdev} ${loadaddr} boot.scr\0" \
        "bootscript=echo Running bootscript from mmc${mmcdev} ...; " \
	"source ${loadaddr}\0" \
        "loaduimage=fatload mmc ${mmcdev} ${loadaddr} uImage\0" \
        "mmcboot=echo Booting from mmc${mmcdev} ...; " \
	"run mmcargs; " \
	"bootm ${loadaddr}\0" \

#define CONFIG_BOOTCOMMAND \
        "if mmc rescan ${mmcdev}; then " \
	"if run loadbootscript; then " \
	"run bootscript; " \
                "else " \
	"if run loaduimage; then " \
	"run mmcboot; " \
	"fi; " \
	"fi; " \
        "fi"

/* USB */
#define CONFIG_CMD_USB
#define CONFIG_USB_EHCI
#define CONFIG_USB_EHCI_EXYNOS
#define CONFIG_USB_HOST
#define CONFIG_USB_HOST_ETHER
#define CONFIG_USB_ETHER_SMSC95XX
#define CONFIG_USB_STORAGE

/* Miscellaneous configurable options */
#define CONFIG_CMDLINE_EDITING
#define CONFIG_SYS_LONGHELP		/* undef to save memory */
#define CONFIG_SYS_HUSH_PARSER		/* use "hush" command parser	*/
#define CONFIG_SYS_PROMPT		CONFIG_BOARDNAME " # "
#define CONFIG_SYS_CBSIZE		256	/* Console I/O Buffer Size */
#define CONFIG_SYS_PBSIZE		384	/* Print Buffer Size */
#define CONFIG_SYS_MAXARGS		16	/* max number of command args */
#define CONFIG_DEFAULT_CONSOLE		"console=ttySAC1,115200n8\0"
/* Boot Argument Buffer Size */
#define CONFIG_SYS_BARGSIZE		CONFIG_SYS_CBSIZE
#define CONFIG_SYS_LOAD_ADDR		(CONFIG_SYS_SDRAM_BASE + 0x3E00000)


#define CONFIG_RD_LVL

/* Stack sizes */
#define CONFIG_STACKSIZE		(256 << 10)	/* 256KB */

#define CONFIG_NR_DRAM_BANKS	4
#define SDRAM_BANK_SIZE		(256UL << 20UL)	/* 256 MB */
#define PHYS_SDRAM_1		CONFIG_SYS_SDRAM_BASE
#define PHYS_SDRAM_1_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_2		(CONFIG_SYS_SDRAM_BASE + SDRAM_BANK_SIZE)
#define PHYS_SDRAM_2_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_3		(CONFIG_SYS_SDRAM_BASE + (2 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_3_SIZE	SDRAM_BANK_SIZE
#define PHYS_SDRAM_4		(CONFIG_SYS_SDRAM_BASE + (3 * SDRAM_BANK_SIZE))
#define PHYS_SDRAM_4_SIZE	SDRAM_BANK_SIZE

#define CONFIG_SYS_MONITOR_BASE	0x00000000

/* Memory test */ 
#define CONFIG_CMD_MEMORY
#define CONFIG_SYS_MEMTEST_START	CONFIG_SYS_SDRAM_BASE
#define CONFIG_SYS_MEMTEST_END	(PHYS_SDRAM_4 + PHYS_SDRAM_4_SIZE - (8UL << 20UL))

/* FLASH and environment organization */
#define CONFIG_SYS_NO_FLASH
#undef CONFIG_CMD_IMLS
#define CONFIG_IDENT_STRING		" for ODROIDX"

#define CONFIG_ENV_IS_IN_MMC
#define CONFIG_SYS_MMC_ENV_DEV		0

#define CONFIG_SECURE_BL1_ONLY

/* Secure FW size configuration */
#ifdef	CONFIG_SECURE_BL1_ONLY
#define	CONFIG_SEC_FW_SIZE		(8 << 10)	/* 8KB */
#else
#define	CONFIG_SEC_FW_SIZE		0
#endif

/* Configuration of BL1, BL2, ENV Blocks on mmc */
#define CONFIG_RES_BLOCK_SIZE	(512)
#define CONFIG_SPL
#define CONFIG_MBR_SIZE	(512)
#define CONFIG_SBL_SIZE		(8UL << 10)		/* 8KB */
#define CONFIG_BL1_SIZE		(16UL << 10) /*16 K reserved for BL1*/
#define	CONFIG_BL2_SIZE		(512UL << 10)	/* 512 KB */
#define CONFIG_ENV_SIZE		(16UL << 10)	/* 16 KB */
/* allow to overwrite serial and ethaddr */
#define CONFIG_ENV_OVERWRITE

#define CONFIG_BL1_OFFSET	(CONFIG_RES_BLOCK_SIZE + CONFIG_SEC_FW_SIZE)
#define CONFIG_BL2_OFFSET	(CONFIG_BL1_OFFSET + CONFIG_BL1_SIZE)
#define CONFIG_ENV_OFFSET	(CONFIG_BL2_OFFSET + CONFIG_BL2_SIZE)

/* File System */
#define CONFIG_DOS_PARTITION
#define CONFIG_EFI_PARTITION
#define CONFIG_CMD_FAT
#define CONFIG_CMD_EXT2

#define OM_STAT	(0x1f << 1)
#define CONFIG_IRAM_STACK	0x02060000

#define CONFIG_SYS_INIT_SP_ADDR	(CONFIG_SYS_LOAD_ADDR - 0x1000000)

/* I2C */
#define CONFIG_SYS_I2C_INIT_BOARD
#define CONFIG_HARD_I2C
#define CONFIG_CMD_I2C
#define CONFIG_SYS_I2C_SPEED	100000		/* 100 Kbps */
#define CONFIG_DRIVER_S3C24X0_I2C
#define CONFIG_I2C_MULTI_BUS
#define CONFIG_MAX_I2C_NUM	2
#define CONFIG_SYS_I2C_SLAVE    0x0

/* PMIC */
#define CONFIG_PMIC
#define CONFIG_PMIC_I2C
#define CONFIG_PMIC_MAX77686

/* Ethernet Controllor */
#ifdef CONFIG_CMD_NET
#define CONFIG_NET_MULTI
#define CONFIG_CMD_PING
#define CONFIG_CMD_DHCP
#endif

#ifdef CONFIG_ENABLE_MMU
#define CONFIG_SYS_MAPPED_RAM_BASE	0xc0000000
#define virt_to_phys(x)	virt_to_phy_s5pv310(x)
#else
#define CONFIG_SYS_MAPPED_RAM_BASE	CONFIG_SYS_SDRAM_BASE
#define virt_to_phys(x)	(x)
#endif

#define CONFIG_PHY_UBOOT_BASE		CONFIG_SYS_SDRAM_BASE + 0x3e00000

/* USB Options */
#ifdef CONFIG_CMD_USB
#define CONFIG_USB_OHCI
#define CONFIG_S3C_USBD
#define USBD_DOWN_ADDR                 0xC0000000
#endif

/* Enable devicetree support */
#define CONFIG_OF_LIBFDT

#endif	/* __CONFIG_H */
