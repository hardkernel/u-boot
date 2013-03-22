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
#define CONFIG_ARMV7	        	1	/* This is an ARM V7 CPU core */
#define CONFIG_SAMSUNG	        	1	/* in a SAMSUNG core */
#define CONFIG_S5P	        	1	/* which is in a S5P Family */
#define CONFIG_ARCH_EXYNOS              1       /* which is in a Exynos Family */
#define CONFIG_ARCH_EXYNOS5             1       /* which is in a Exynos5 Family */
#define CONFIG_CPU_EXYNOS5250           1       /* which is in a Exynos5250 */
#define CONFIG_MACH_SMDK5250            1       /* which is in a SMDK5250 */
#define CONFIG_CPU_EXYNOS5250_EVT1      1       /* which is in a Exynos5250 EVT1 */

#define CONFIG_TRUSTZONE
#define CONFIG_TRUSTZONE_RESERVED_DRAM	0x100000
#ifdef CONFIG_TRUSTZONE
#define CONFIG_BL1_MONITOR
#define CONFIG_BOOTLOADER_MONITOR        1
#define CONFIG_PHY_IRAM_BASE            (0x02020000)
#define CONFIG_PHY_IRAM_NS_BASE         (CONFIG_PHY_IRAM_BASE + 0x2F000)
#endif

#define CONFIG_SECURE_BL1_ONLY
//#define CONFIG_SECURE_TZSW_ONLY
//#define CONFIG_SECURE_BOOT
#ifdef CONFIG_SECURE_BOOT
#define CONFIG_SECURE_ROOTFS
#define CONFIG_SECURE_KERNEL_BASE	0xc0008000
#define CONFIG_SECURE_KERNEL_SIZE	0x400000
#define CONFIG_SECURE_ROOTFS_BASE	0xc1000000
#define CONFIG_SECURE_ROOTFS_SIZE	0x100000
#endif

//#include <asm/arch/cpu.h>		/* get chip and board defs */

/* APLL : 600MHz */
//#define CONFIG_CLK_ARM_600_APLL_600
/* APLL : 800MHz */
//#define CONFIG_CLK_ARM_800_APLL_800
/* APLL : 1GHz */
#define CONFIG_CLK_ARM_1000_APLL_1000
/* APLL : 1.2GHz */
//#define CONFIG_CLK_ARM_1200_APLL_1200
/* APLL : 1.4GHz */
//#define CONFIG_CLK_ARM_1400_APLL_1400

/* LPDDR support */
//#define CONFIG_DDR3
//#define CONFIG_LPDDR2
#define CONFIG_LPDDR3

#if defined(CONFIG_CPU_EXYNOS5250_EVT1)
/* MCLK_CDREX */
#define MCLK_CDREX_800  	1
/* PMIC Control */
//#define CONFIG_S5M8767          1
#else
/* MCLK_CDREX */
#ifdef CONFIG_DDR3
#define MCLK_CDREX_800  	1
#else
//#define MCLK_CDREX_800	1
//#define MCLK_CDREX_667  	1
#define MCLK_CDREX_533  	1
//#define MCLK_CDREX_400	1
#endif
/* PMIC Control */
//#define CONFIG_S5M8767          1
#define CONFIG_MAX8997          1
#endif


/* (Memory Interleaving Size = 1 << IV_SIZE) */
#define CONFIG_IV_SIZE 0x07

#define CONFIG_L2_OFF

//#define CONFIG_ARCH_CPU_INIT

#define CONFIG_DISPLAY_CPUINFO
//#define CONFIG_DISPLAY_BOARDINFO
#define BOARD_LATE_INIT

/* input clock of PLL: SMDK5250 has 24MHz input clock */
#define CONFIG_SYS_CLK_FREQ	24000000

/* DRAM Base */
#define CONFIG_SYS_SDRAM_BASE		0x40000000

#define CONFIG_SETUP_MEMORY_TAGS
#define CONFIG_CMDLINE_TAG
#define CONFIG_INITRD_TAG
#define CONFIG_CMDLINE_EDITING

/* Power Management is enabled */
#define CONFIG_PM
#if defined(CONFIG_CPU_EXYNOS5250_EVT1)
/* For POP TYPE */
#define CONFIG_PM_VDD_ARM	1200
#define CONFIG_PM_VDD_INT	1000
#define CONFIG_PM_VDD_G3D	1200
#define CONFIG_PM_VDD_MIF	1100
#define CONFIG_PM_VDD_MEM       1250
#define CONFIG_PM_VDD_LDO21	1250
/* For SCP TYPE */
#define CONFIG_SCP_PM_VDD_ARM	1200
#define CONFIG_SCP_PM_VDD_INT	1000
#define CONFIG_SCP_PM_VDD_G3D	1200
#define CONFIG_SCP_PM_VDD_MIF	1100
#define CONFIG_SCP_PM_VDD_LDO21	1350
#else
#if defined(CONFIG_DDR3)
#define CONFIG_PM_VDD_ARM	1300
#define CONFIG_PM_VDD_INT	1150
#define CONFIG_PM_VDD_G3D	1100
#define CONFIG_PM_VDD_MIF	1200
#define CONFIG_PM_VDD_LDO21	1500
#else
#if defined(CONFIG_CLK_ARM_600_APLL_600) || defined(CONFIG_CLK_ARM_800_APLL_800)
#define CONFIG_PM_VDD_ARM	1000
#elif defined(CONFIG_CLK_ARM_1000_APLL_1000)
#define CONFIG_PM_VDD_ARM	1050
#elif defined(CONFIG_CLK_ARM_1200_APLL_1200)
#define CONFIG_PM_VDD_ARM	1150
#elif defined(CONFIG_CLK_ARM_1400_APLL_1400)
#define CONFIG_PM_VDD_ARM	1250
#endif
#define CONFIG_PM_VDD_INT	1150
#define CONFIG_PM_VDD_G3D	1000
#define CONFIG_PM_VDD_MIF	1000
#endif
#define CONFIG_PM_VDD_LDO10	1150
#endif /* CONFIG_CPU_EXYNOS5250_EVT1 */

/*
 * Size of malloc() pool
 * 1MB = 0x100000, 0x100000 = 1024 * 1024
 */
#define CONFIG_SYS_MALLOC_LEN		(CONFIG_ENV_SIZE + (1 << 20))
						/* initial data */
/*
 * select serial console configuration
 */
#define CONFIG_SERIAL2			1
#define CONFIG_SERIAL_MULTI		1

#define CONFIG_USB_OHCI
#undef CONFIG_USB_STORAGE
#define CONFIG_EXYNOS_USBD3
#undef CONFIG_USB_CPUMODE

#ifndef CONFIG_EXYNOS_USBD3
#define CONFIG_S3C_USBD
#endif

#define USBD_DOWN_ADDR		0xc0000000

/* allow to overwrite serial and ethaddr */
#define CONFIG_ENV_OVERWRITE
#define CONFIG_BAUDRATE			115200

/***********************************************************
 * Command definition
 ***********************************************************/
#include <config_cmd_default.h>

#define CONFIG_CMD_PING

#define CONFIG_CMD_USB

#define CONFIG_CMD_MOVINAND

#undef CONFIG_CMD_FLASH
#undef CONFIG_CMD_IMLS
#undef CONFIG_CMD_NAND

#define CONFIG_CMD_CACHE
#define CONFIG_CMD_REGINFO
#define CONFIG_CMD_MMC
#define CONFIG_CMD_MOVI
#define CONFIG_CMD_ELF
#define CONFIG_CMD_FAT
#define CONFIG_CMD_MTDPARTS
#define CONFIG_MTD_DEVICE

#define CONFIG_CMD_EXT2
#define CONFIG_CMD_FAT

#define CONFIG_SYS_NAND_QUIET_TEST
#define CONFIG_SYS_ONENAND_QUIET_TEST

#define CONFIG_MMC
#define CONFIG_GENERIC_MMC
#define CONFIG_S3C_HSMMC

/* The macro for MMC channel 0 is defined by default and can't be undefined */

/* Notice for MSHC[Using of MMC CH4] */
/*
 * If you want MSHC at MMC CH4.
 */
#if defined(CONFIG_CPU_EXYNOS5250_EVT1)
#define CONFIG_S5P_MSHC
#define MMC_MAX_CHANNEL		4

#define USE_MMC0
#define USE_MMC2
#else
#define MMC_MAX_CHANNEL		5

#define USE_MMC2
#define USE_MMC4
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

#define CONFIG_FACTORY_RESET_MODE       0xf

/* Default boot commands for Android booting. */
#define CONFIG_BOOTCOMMAND	"movi read kernel 0 40008000;movi read rootfs 0 41000000 100000;bootm 40008000 41000000"
#define CONFIG_BOOTARGS	""

#define CONFIG_BOOTCOMMAND2	\
		"mmc erase user 0 1072 1;"	\
		"movi r f 1 40000000;emmc open 0;movi w z f 0 40000000;emmc close 0;"	\
		"movi r u 1 40000000;emmc open 0;movi w z u 0 40000000;emmc close 0;"	\
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

#define CONFIG_FACTORY_RESET_BOOTCOMMAND        \
                "ext3format mmc 0:3;ext3format mmc 0:4;"		\
                "movi read kernel 0 40008000;movi read rootfs 0 41000000 100000;bootm 40008000 41000000"

#define CONFIG_ROOTFS_ATAGS
#ifdef CONFIG_ROOTFS_ATAGS
#define CONFIG_EXTRA_ENV_SETTINGS                                       \
                "rootfslen= 100000"
#endif

/*
 * Miscellaneous configurable options
 */
#define CONFIG_SYS_LONGHELP		/* undef to save memory */
#define CONFIG_SYS_HUSH_PARSER		/* use "hush" command parser	*/
#define CONFIG_SYS_PROMPT_HUSH_PS2	"> "
#define CONFIG_SYS_PROMPT		"SMDK5250 # "
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

/*-----------------------------------------------------------------------
 * Stack sizes
 *
 * The stack sizes are set up in start.S using the settings below
 */
#define CONFIG_STACKSIZE	(256 << 10)	/* 256 KiB */

#define CONFIG_NR_DRAM_BANKS	8
#define SDRAM_BANK_SIZE         (unsigned long)0x10000000    /* 256 MB */
#define PHYS_SDRAM_1            CONFIG_SYS_SDRAM_BASE /* SDRAM Bank #1 */
#define PHYS_SDRAM_1_SIZE       SDRAM_BANK_SIZE
#define PHYS_SDRAM_2            (CONFIG_SYS_SDRAM_BASE + SDRAM_BANK_SIZE) /* SDRAM Bank #2 */
#define PHYS_SDRAM_2_SIZE       SDRAM_BANK_SIZE
#define PHYS_SDRAM_3            (CONFIG_SYS_SDRAM_BASE + 2 * SDRAM_BANK_SIZE) /* SDRAM Bank #3 */
#define PHYS_SDRAM_3_SIZE       SDRAM_BANK_SIZE
#define PHYS_SDRAM_4            (CONFIG_SYS_SDRAM_BASE + 3 * SDRAM_BANK_SIZE) /* SDRAM Bank #4 */
#define PHYS_SDRAM_4_SIZE       SDRAM_BANK_SIZE
#define PHYS_SDRAM_5            (CONFIG_SYS_SDRAM_BASE + 4 * SDRAM_BANK_SIZE) /* SDRAM Bank #5 */
#define PHYS_SDRAM_5_SIZE       SDRAM_BANK_SIZE
#define PHYS_SDRAM_6            (CONFIG_SYS_SDRAM_BASE + 5 * SDRAM_BANK_SIZE) /* SDRAM Bank #6 */
#define PHYS_SDRAM_6_SIZE       SDRAM_BANK_SIZE
#define PHYS_SDRAM_7            (CONFIG_SYS_SDRAM_BASE + 6 * SDRAM_BANK_SIZE) /* SDRAM Bank #7 */
#define PHYS_SDRAM_7_SIZE       SDRAM_BANK_SIZE
#define PHYS_SDRAM_8            (CONFIG_SYS_SDRAM_BASE + 7 * SDRAM_BANK_SIZE) /* SDRAM Bank #8 */
#define PHYS_SDRAM_8_SIZE       SDRAM_BANK_SIZE

#define CONFIG_SYS_MONITOR_BASE	0x00000000

/*-----------------------------------------------------------------------
 * FLASH and environment organization
 */
#define CONFIG_SYS_NO_FLASH		1

#define CONFIG_SYS_MONITOR_LEN		(256 << 10)	/* 256 KiB */
#define CONFIG_IDENT_STRING		" for SMDK5250"

#define CONFIG_ENABLE_MMU

#ifdef CONFIG_ENABLE_MMU
#define CONFIG_SYS_MAPPED_RAM_BASE	0xc0000000
#define virt_to_phys(x)	virt_to_phy_exynos5250(x)
#else
#define CONFIG_SYS_MAPPED_RAM_BASE	CONFIG_SYS_SDRAM_BASE
#define virt_to_phys(x)	(x)
#endif

#define CONFIG_SYS_LOAD_ADDR		CONFIG_SYS_MAPPED_RAM_BASE + 0x3e00000
#define CONFIG_PHY_UBOOT_BASE		CONFIG_SYS_SDRAM_BASE + 0x3e00000

/*
 *  Fast Boot
*/
/* Fastboot variables */
#define CFG_FASTBOOT_TRANSFER_BUFFER            (0x48000000)
#define CFG_FASTBOOT_TRANSFER_BUFFER_SIZE       (0x30000000)   /* 768MB */
#define CFG_FASTBOOT_ADDR_KERNEL                (0x40008000)
#define CFG_FASTBOOT_ADDR_RAMDISK               (0x41000000)
#define CFG_FASTBOOT_PAGESIZE                   (2048)  // Page size of booting device
#define CFG_FASTBOOT_SDMMC_BLOCKSIZE            (512)   // Block size of sdmmc
#define CFG_PARTITION_START			(0x4000000)

/* Just one BSP type should be defined. */
#if defined(CONFIG_CMD_MOVINAND)
#define CONFIG_FASTBOOT
#endif

#if defined(CONFIG_CMD_MOVINAND)
#define CFG_FASTBOOT_SDMMCBSP
#endif

/*
 * machine type
 */

#define MACH_TYPE       		3825	/* SMDK5250 machine ID */

#define CONFIG_ENV_OFFSET		0x0007C000

/*-----------------------------------------------------------------------
 * Boot configuration
 */
#define BOOT_ONENAND		0x1
#define BOOT_NAND		0x40000
#define BOOT_MMCSD		0x3
#define BOOT_NOR		0x4
#define BOOT_SEC_DEV		0x5
#define BOOT_EMMC		0x6
#define BOOT_EMMC_4_4		0x7
#define BOOT_USB                0x100

/*
 *  Boot device
 */
#define SDMMC_CH2               0x0
#define SDMMC_CH0               0x4
#define EMMC                    0x14
#define SATA                    0x18
#define SPI_SF                  0x28
#define SFMC                    0x34
#define USB                     0x40

#define CONFIG_ZIMAGE_BOOT

#define CONFIG_ENV_IS_IN_AUTO		1
#define CONFIG_ENV_SIZE			0x4000

#define CONFIG_DOS_PARTITION		1

#define CONFIG_SYS_INIT_SP_ADDR	(CONFIG_PHY_UBOOT_BASE - 0x1000000)

/*
 * Ethernet Contoller driver
 */
#ifdef CONFIG_CMD_NET
#define CONFIG_NET_MULTI
#define CONFIG_SMC911X
#define CONFIG_SMC911X_BASE	0x5000000
#define CONFIG_SMC911X_16_BIT
#endif /* CONFIG_CMD_NET */

/* GPIO */
#define GPIO_BASE	0x11400000

#define CFG_PHY_UBOOT_BASE	MEMORY_BASE_ADDRESS + 0x3e00000
#define CFG_PHY_KERNEL_BASE	MEMORY_BASE_ADDRESS + 0x8000

#define MEMORY_BASE_ADDRESS	0x40000000

#endif	/* __CONFIG_H */
