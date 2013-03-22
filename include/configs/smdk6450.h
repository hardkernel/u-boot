/*
 * (C) Copyright 2009 Samsung Electronics
 * Minkyu Kang <mk7.kang@samsung.com>
 * HeungJun Kim <riverful.kim@samsung.com>
 * Inki Dae <inki.dae@samsung.com>
 *
 * Configuation settings for the SAMSUNG SMDKC100 board.
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

/*
 * High Level Configuration Options
 * (easy to change)
 */
#define CONFIG_SAMSUNG  		1	/* in a SAMSUNG core */
#define CONFIG_S5P6450	                1	/* which is in a S5P6450 */
#define CONFIG_S5P
#define CONFIG_EVT1
#define CONFIG_NR_DRAM_BANKS            1

//#define CONFIG_S5P6460
#if defined(CONFIG_S5P6460)
//#define CONFIG_S5P6460_IP_TEST
#define CONFIG_FUSED
#define CONFIG_SECURE_BL1_ONLY
#endif

/* eMMC booting */
//#define CONFIG_EMMC_4_4                 1

/*
 * Architecture magic and machine type
 */
#define MACH_TYPE	                2938

#define CONFIG_CLK_533_133_66

#define CONFIG_ARCH_CPU_INIT
#define CONFIG_DISPLAY_CPUINFO
#define CONFIG_DISPLAY_BOARDINFO
//#deifne BOARD_LATE_INIT

/* input clock of PLL : SMDK6450 has 19.2Mhz input clock */
#define CONFIG_SYS_CLK_FREQ             19200000

/* DRAM Base */
#define CONFIG_SYS_SDRAM_BASE           0x20000000

/* TAG  */
#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG
#define CONFIG_INITRD_TAG
#define CONFIG_CMDLINE_EDITING

/*
 * Size of malloc() pool
 */
#define CONFIG_SYS_MALLOC_LEN		(CONFIG_ENV_SIZE + 1024*1024)

/*
 * select serial console configuration
 */
#define CONFIG_SERIAL2
#define CONFIG_SERIAL_MULTI             1

#define CONFIG_BAUDRATE                 115200

/* SD/MMC configuration */
#define CONFIG_MMC
#define CONFIG_GENERIC_MMC
#define CONFIG_S3C_HSMMC
#undef DEBUG_S3C_HSMMC

#define MMC_MAX_CHANNEL         4

/*
   Select a needed channel :
   It's recommanded to select only one channel to use 'movi' command
*/
#ifndef CONFIG_EMMC_4_4
#define USE_MMC0
#define USE_MMC1
#else
#define USE_MMC3
#endif

/*
 * BOOTP options
 */
#define CONFIG_BOOTP_SUBNETMASK
#define CONFIG_BOOTP_GATEWAY
#define CONFIG_BOOTP_HOSTNAME
#define CONFIG_BOOTP_BOOTPATH

#define CONFIG_ETHADDR		00:40:5c:26:0a:5b
#define CONFIG_NETMASK          255.255.255.0
#define CONFIG_IPADDR		192.168.0.20
#define CONFIG_SERVERIP		192.168.0.10
#define CONFIG_GATEWAYIP	192.168.0.1

#define CONFIG_BOOTDELAY	3
/* Default boot commands for Android booting. */
#define CONFIG_BOOTCOMMAND	"movi read kernel 1 20008000;movi read rootfs 1 21000000 C00000;bootm 20008000 21000000"
#define CONFIG_BOOTARGS	""

/*
 * Miscellaneous configurable options
 */
#define CONFIG_SYS_LONGHELP		/* undef to save memory */
#define CONFIG_SYS_HUSH_PARSER		/* use "hush" command parser	*/
#define CONFIG_SYS_PROMPT_HUSH_PS2	"> "
#ifdef  CONFIG_S5P6460
#define CONFIG_SYS_PROMPT		"SMDK6460 # "
#else
#define CONFIG_SYS_PROMPT		"SMDK6450 # "
#endif
#define CONFIG_SYS_CBSIZE	256	/* Console I/O Buffer Size */
#define CONFIG_SYS_PBSIZE	384	/* Print Buffer Size */
#define CONFIG_SYS_MAXARGS	16	/* max number of command args */
/* Boot Argument Buffer Size */
#define CONFIG_SYS_BARGSIZE		CONFIG_SYS_CBSIZE
/* memtest works on */
#define CONFIG_SYS_MEMTEST_START	CONFIG_SYS_SDRAM_BASE
#define CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_SDRAM_BASE + 0x5e00000)

#define CONFIG_SYS_HZ			1000

/* valid baudrates */
#define CONFIG_SYS_BAUDRATE_TABLE	{ 9600, 19200, 38400, 57600, 115200 }

/* Environment */
#define CONFIG_ENV_IS_IN_AUTO		1
#define CONFIG_ENV_SIZE                 0x4000

#define CONFIG_ENABLE_MMU

#ifdef CONFIG_ENABLE_MMU
#define CONFIG_SYS_MAPPED_RAM_BASE	0xc0000000
#define virt_to_phys(x)	virt_to_phy_s5p6450(x)
#else
#define CONFIG_SYS_MAPPED_RAM_BASE	CONFIG_SYS_SDRAM_BASE
#define virt_to_phys(x)	(x)
#endif

#define CONFIG_SYS_LOAD_ADDR		CONFIG_SYS_MAPPED_RAM_BASE + 0x7e00000
#define CONFIG_PHY_UBOOT_BASE		CONFIG_SYS_SDRAM_BASE + 0x7e00000

/* STACK */
#define CONFIG_SYS_INIT_SP_ADDR         (0x27e00000 - 0x1000000)

/*
 * mDDR memory configuration
 */
#define CONFIG_NR_DRAM_BANKS    1
#define SDRAM_BANK_SIZE         0x10000000    /* 256 MB */
#define PHYS_SDRAM_1            CONFIG_SYS_SDRAM_BASE /* SDRAM Bank #1 */
#define PHYS_SDRAM_1_SIZE       SDRAM_BANK_SIZE

/*-----------------------------------------------------------------------
 * FLASH and environment organization
 */
#define CONFIG_SYS_MAX_FLASH_SECT       1
#define CONFIG_SYS_NO_FLASH		1

#define CONFIG_SYS_MONITOR_LEN		(256 << 10)	/* 256 KiB */
#ifdef  CONFIG_S5P6460
#define CONFIG_IDENT_STRING		" for SMDK6460"
#else
#define CONFIG_IDENT_STRING		" for SMDK6450"
#endif

/* base address for uboot */
#define CONFIG_SYS_PHY_UBOOT_BASE       CONFIG_SYS_SDRAM_BASE + 0x07e00000

#define CONFIG_PERIPORT_REMAP
#ifdef CONFIG_PERIPORT_REMAP
#define CONFIG_PERIPORT_BASE            0xE0000000      /* which is in SFR region */
#define CONFIG_PERIPORT_SIZE            0x14            /* size = 512MB */
#endif

/*
 *  Fast Boot
 */
/* Fastboot variables */
#define CFG_FASTBOOT_TRANSFER_BUFFER            (0x28000000)
#define CFG_FASTBOOT_TRANSFER_BUFFER_SIZE       (0x8000000)   /* 128MB */
#define CFG_FASTBOOT_ADDR_KERNEL                (0x20008000)
#define CFG_FASTBOOT_ADDR_RAMDISK               (0x20800000)
#define CFG_FASTBOOT_PAGESIZE                   (2048)  // Page size of booting device
#define CFG_FASTBOOT_SDMMC_BLOCKSIZE            (512)   // Block size of sdmmc
#define CFG_PARTITION_START			(0x4000000)

/*
 * Boot configuraion
 */
#define CONFIG_FASTBOOT
#define CFG_FASTBOOT_SDMMCBSP

#ifdef  CONFIG_S5P6460
#define BOOT_MMCSD		0x4
#define BOOT_EMMC		0x1
#define BOOT_EMMC_4_4		0x2
#define BOOT_SEC_DEV		0x8
/* Don't use it */
#define BOOT_EMMC_4_4		0x2
#define BOOT_SPI		0x5
#define BOOT_NAND		0x6
#define BOOT_ONENAND		0x0
#else
#define BOOT_MMCSD		0x0
#define BOOT_EMMC		0x1
#define BOOT_SEC_DEV		0x8
/* Don't use it */
#define BOOT_EMMC_4_4		0x2
#define BOOT_ONENAND		0x4
#define BOOT_NAND		0x40000
#define BOOT_NOR		0x4
#endif

/*
 * USB device
 */
#define CONFIG_S3C_USBD
#define USBD_DOWN_ADDR		0xc0000000

/* allow to overwrite serial and ethaddr */
#define CONFIG_ENV_OVERWRITE

#define CONFIG_ZIMAGE_BOOT

#define CONFIG_DOS_PARTITION

/* IROM specific data */
#ifdef CONFIG_EVT0
#define SDMMC_BLK_SIZE        (0xd0021c54)
#endif
#ifdef CONFIG_EVT1
#define SDMMC_BLK_SIZE        (0xd0021FF0)
#endif

/*
 * Command definition
 */
#include <config_cmd_default.h>

#define CONFIG_CMD_MOVINAND
#define CONFIG_CMD_ENV
#define CONFIG_CMD_SAVEENV
#define CONFIG_CMD_NET
#define CONFIG_CMD_MOVI
#define CONFIG_CMD_MMC
#define CONFIG_CMD_EXT2
#define CONFIG_CMD_FAT

/*
 * Ethernet Contoller driver
 */
#define CONFIG_NET_MULTI
#ifdef CONFIG_NET_MULTI
#define CONFIG_SMC911X         1       /* we have a SMC9115 on-board   */
#define CONFIG_SMC911X_16_BIT  1       /* SMC911X_16_BIT Mode          */
#define CONFIG_SMC911X_BASE    0x80000000      /* SMC911X Drive Base   */
#define CONFIG_ENV_SROM_BANK   0       /* Select SROM Bank-0 for Ethernet*/
#define CONFIG_DRIVER_CS8900
#define CS8900_BASE	  		(0x18800300)
#define CS8900_BUS16
#else

#define CONFIG_DRIVER_DM9000	1

#ifdef 	CONFIG_DRIVER_SMC911X
#define CONFIG_DRIVER_SMC911X_16_BIT
#undef	CONFIG_DRIVER_CS8900
#define CONFIG_DRIVER_SMC911X_BASE	(0x80000000)
#endif

#ifdef CONFIG_DRIVER_CS8900
#define CS8900_BASE	  		(0x80000000)
#define CS8900_BUS16
#endif

#ifdef CONFIG_DRIVER_DM9000
#define CONFIG_DM9000_BASE		(0x80000000)
#define DM9000_IO			(CONFIG_DM9000_BASE)
#define DM9000_DATA			(CONFIG_DM9000_BASE+2)
#endif
#endif

#endif	/* __CONFIG_H */
