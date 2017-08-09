/*
 * Copyright (C) 2013 Samsung Electronics
 * Hyungwon Hwang <human.hwang@samsung.com>
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __CONFIG_ODROID_XU4_H
#define __CONFIG_ODROID_XU4_H

#include "exynos5420-common.h"
#include <configs/exynos5-common.h>

#undef CONFIG_ENV_IS_IN_SPI_FLASH

#define CONFIG_BOARD_COMMON
#define CONFIG_BOARD_LATE_INIT

#define CONFIG_SYS_SDRAM_BASE		0x40000000
#define CONFIG_SYS_TEXT_BASE		0x43E00000

/* select serial console configuration */
#define CONFIG_SERIAL2			/* use SERIAL 2 */

#define TZPC_BASE_OFFSET		0x10000

#define CONFIG_NR_DRAM_BANKS		8
#define SDRAM_BANK_SIZE			(256UL << 20UL)	/* 256 MB */
/* Reserve the last 22 MiB for the secure firmware */
#define CONFIG_SYS_MEM_TOP_HIDE		(22UL << 20UL)
#define CONFIG_TZSW_RESERVED_DRAM_SIZE	CONFIG_SYS_MEM_TOP_HIDE

#define CONFIG_SYS_MMC_MAX_DEVICE	2

#if defined(CONFIG_FASTBOOT)
/* Fastboot SDMMC Partition Table for ODROID(Exynos5422) */

/* BL1		BLK#: 1    (0x0001) ~    30 (0x001E) */
/* BL2		BLK#: 31   (0x001F) ~    62 (0x003E) */
/* UBOOT	BLK#: 63   (0x003F) ~  1502 (0x05DE) */
/* TZSW		BLK#: 1503 (0x05DF) ~  2014 (0x07DE) */
/* UBOOT ENV	BLK#: 2015 (0x07DF) ~  2046 (0x07FE) */

/* Attention! : eMMC BLK MAP is BLK#-1 in SDMMC Partition Table */

#define	MOVI_BLK_SIZE			(512)
#define	MOVI_BLK_END			(-1)

#define	PART_SIZE_BL1			(SZ_1K * 15)
#define	PART_SIZE_BL2			(SZ_1K * 16)
#define	PART_SIZE_UBOOT			(SZ_1K * 720)
#define	PART_SIZE_TZSW			(SZ_1K * 256)
#define	PART_SIZE_ENV			(SZ_1K * 16)
#define	PART_SIZE_KERNEL		(SZ_1M * 8)

#define	PART_BL1_ST_BLK			(1)	/* Skip for MBR */
#define	PART_BL2_ST_BLK			(PART_BL1_ST_BLK + \
					(PART_SIZE_BL1 / MOVI_BLK_SIZE))
#define	PART_UBOOT_ST_BLK		(PART_BL2_ST_BLK + \
					(PART_SIZE_BL2 / MOVI_BLK_SIZE))
#define	PART_TZSW_ST_BLK		(PART_UBOOT_ST_BLK + \
					(PART_SIZE_UBOOT / MOVI_BLK_SIZE))
#define	PART_ENV_ST_BLK			(PART_TZSW_ST_BLK + \
					(PART_SIZE_TZSW / MOVI_BLK_SIZE))
#define	PART_KERNEL_ST_BLK		(PART_ENV_ST_BLK + \
					(PART_SIZE_ENV / MOVI_BLK_SIZE))

/* Android Partition size for ODROID */
#define	PART_SIZE_SYSTEM		SZ_1G
#define	PART_SIZE_USERDATA		SZ_2G
#define	PART_SIZE_CACHE			SZ_256M
#define	ANDROID_PART_START		SZ_64M

#endif	/* #if defined(CONFIG_FASTBOOT) */

#define CONFIG_ENV_IS_IN_MMC

#undef CONFIG_ENV_SIZE
#undef CONFIG_ENV_OFFSET

#if defined(CONFIG_FASTBOOT)
	#define	CONFIG_ENV_SIZE		(PART_SIZE_ENV)
	#define	CONFIG_ENV_OFFSET	(PART_ENV_ST_BLK * MOVI_BLK_SIZE)
#else
	#define CONFIG_ENV_SIZE		(SZ_1K * 16)
	#define CONFIG_ENV_OFFSET	(SZ_1K * 3136) /* ~3 MiB offset */
#endif

/* Fastboot SDMMC Partition Table for ODROID(Exynos5422) */

/* BL1		BLK#: 1    (0x0001)  ~    30 (0x001E) */
/* BL2		BLK#: 31   (0x001F)  ~    62 (0x003E) */
/* UBOOT	BLK#: 63   (0x003F)  ~  1502 (0x05DE) */
/* TZSW		BLK#: 1503 (0x05DF)  ~  2014 (0x07DE) */
/* UBOOT ENV	BLK#: 2015 (0x07DF)  ~  2046 (0x07FE) */
/* KERNEL	BLK#: 2047 (0x07DF)  ~ 18430 (0x47FE) */
#define	UBOOT_ENV_ERASE	\
	"mw.l ${loadaddr} 0 4000;"	\
	"mmc dev 0;  mmc write ${loadaddr} 0x07df 0x0020;mmc dev 0\0"

#define	UBOOT_COPY_SD2EMMC	\
	"mmc dev 0;"		\
	"mmc read  ${loadaddr} 0x0001 0x07de;mmc dev 1;emmc open  1;"	\
	"mmc write ${loadaddr} 0x0000 0x07de;emmc close 1;mmc dev 0;"	\
	"mmc dev 1;  mmc write ${loadaddr} 0x07df 0x0020;mmc dev 0\0"	

#define	UBOOT_COPY_EMMC2SD	\
	"mmc dev 0;"		\
	"emmc open 0;mmc read  ${loadaddr} 0x0000 0x07de;emmc close 0;"	\
	"mmc dev 1;  mmc write ${loadaddr} 0x0001 0x07de;mmc dev 0;"	\
	"mmc dev 1;  mmc write ${loadaddr} 0x07df 0x0020;mmc dev 0\0"	

#define CONFIG_SYS_INIT_SP_ADDR		(CONFIG_SYS_LOAD_ADDR - 0x1000000)

#define CONFIG_DEFAULT_CONSOLE		"console=ttySAC2,115200n8\0"

/* USB */
#define CONFIG_USB_EHCI
#define CONFIG_USB_EHCI_EXYNOS

/* DFU : need enable */
#define CONFIG_SYS_DFU_DATA_BUF_SIZE	SZ_32M
#define DFU_DEFAULT_POLL_TIMEOUT	300
#define DFU_MANIFEST_POLL_TIMEOUT	25000

/* THOR */
#define CONFIG_G_DNL_THOR_VENDOR_NUM	CONFIG_G_DNL_VENDOR_NUM
#define CONFIG_G_DNL_THOR_PRODUCT_NUM	0x685D
#define CONFIG_USB_FUNCTION_THOR
#define CONFIG_CMD_THOR_DOWNLOAD

/* UMS */
#define CONFIG_G_DNL_UMS_VENDOR_NUM	0x0525
#define CONFIG_G_DNL_UMS_PRODUCT_NUM	0xA4A5
#define CONFIG_USB_FUNCTION_MASS_STORAGE

/* #if defined(CONFIG_USB_DEVICE) */
/*
#define CONFIG_USB_DEVICE
- need function : void udc_disconnect(void), void udc_connedt(void)
*/
#if !defined(CONFIG_USB_DEVICE)
	/*
	#define CONFIG_EXYNOS_USBD3
	*/
	#define EXYNOS_SYSREG_BASE		EXYNOS5_SYSREG_BASE
	#define EXYNOS_POWER_BASE		EXYNOS5_POWER_BASE
	/*
	 * USBD 3.0 SFR
	 */
	#define USBDEVICE3_LINK_CH0_BASE	0x12000000
	#define USBDEVICE3_PHYCTRL_CH0_BASE	0x12100000
	#define USBDEVICE3_LINK_CH1_BASE	0x12400000
	#define USBDEVICE3_PHYCTRL_CH1_BASE	0x12500000

	#define EXYNOS_USB_PHY_BASE		EXYNOS5_USBPHY_BASE
	#define EXYNOS_USB_LINK_BASE		EXYNOS5_USBOTG_BASE

	#if defined(CONFIG_FASTBOOT)
		#define CFG_FASTBOOT_TRANSFER_BUFFER		(0x50000000)

		/* Download maximum size 1024MB */
		#define CFG_FASTBOOT_TRANSFER_BUFFER_SIZE	(0x40000000)
		/* Page size of booting device */
		#define CFG_FASTBOOT_PAGESIZE			(2048)
		/* Block size of sdmmc */
		#define CFG_FASTBOOT_SDMMC_BLOCKSIZE		(512)
	#endif

	/* cmd from kernel reboot */
	#define FASTBOOT_MAGIC_REBOOT_CMD		0xFAB0
	#define FASTBOOT_MAGIC_UPDATE_CMD		0xFADA
#endif /*#if defined(CONFIG_USB_DEVICE) */

/* FIXME: MUST BE REMOVED AFTER TMU IS TURNED ON */
#undef CONFIG_EXYNOS_TMU
#undef CONFIG_TMU_CMD_DTT

#define CONFIG_DFU_ALT_SYSTEM               \
	"uImage fat 0 1;"                   \
	"zImage fat 0 1;"                   \
	"Image.itb fat 0 1;"                \
	"uInitrd fat 0 1;"                  \
	"boot.scr fat 0 1;"                 \
	"boot.cmd fat 0 1;"                 \
	"exynos5422-odroidxu3.dtb fat 0 1;" \
	"exynos5422-odroidxu3-lite.dtb fat 0 1;" \
	"exynos5422-odroidxu4.dtb fat 0 1;" \
	"boot part 0 1;"                    \
	"root part 0 2\0"

#define CONFIG_DFU_ALT_BOOT_EMMC           \
	"u-boot raw 0x3e 0x800 mmcpart 1;" \
	"bl1 raw 0x0 0x1e mmcpart 1;"      \
	"bl2 raw 0x1e 0x1d mmcpart 1;"     \
	"tzsw raw 0x5de 0x200 mmcpart 1;"  \
	"params.bin raw 0x7df 0x20\0"

#define CONFIG_DFU_ALT_BOOT_SD   \
	"u-boot raw 0x3f 0x800;" \
	"bl1 raw 0x1 0x1e;"      \
	"bl2 raw 0x1f 0x1d;"     \
	"tzsw raw 0x5df 0x200;"  \
	"params.bin raw 0x7df 0x20\0"

/* Enable: board/samsung/common/misc.c to use set_dfu_alt_info() */
#define CONFIG_MISC_COMMON
#define CONFIG_MISC_INIT_R
#define CONFIG_SET_DFU_ALT_INFO
#define CONFIG_SET_DFU_ALT_BUF_LEN	(SZ_1K)

/* Set soc_rev, soc_id, board_rev, boardname, fdtfile */
#define CONFIG_ENV_VARS_UBOOT_RUNTIME_CONFIG
#define CONFIG_ODROID_REV_AIN			9
#define CONFIG_REVISION_TAG
#define CONFIG_BOARD_TYPES

#undef CONFIG_SYS_BOARD
#define CONFIG_SYS_BOARD	"odroid"

/* Define new extra env settings, including DFU settings */
#undef CONFIG_EXTRA_ENV_SETTINGS
#define CONFIG_EXTRA_ENV_SETTINGS \
	EXYNOS_DEVICE_SETTINGS \
	EXYNOS_FDTFILE_SETTING \
	MEM_LAYOUT_ENV_SETTINGS \
	BOOTENV \
	"bootdelay=1\0" \
	"rootfstype=ext4\0" \
	"console=" CONFIG_DEFAULT_CONSOLE \
	"fdtfile=exynos5422-odroidxu4.dtb\0" \
	"board_name=xu4\0" \
	"mmcbootdev=0\0" \
	"mmcrootdev=0\0" \
	"mmcbootpart=1\0" \
	"mmcrootpart=2\0" \
	"dfu_alt_system="CONFIG_DFU_ALT_SYSTEM \
	"dfu_alt_info=Autoset by THOR/DFU command run.\0" \
	"loadaddr=0x50000000\0" \
	"env_erase="UBOOT_ENV_ERASE \
	"copy_uboot_sd2emmc="UBOOT_COPY_SD2EMMC \
	"copy_uboot_emmc2sd="UBOOT_COPY_EMMC2SD

#undef CONFIG_BOOTCOMMAND
#define CONFIG_BOOTCOMMAND "cfgload;movi r k 0 40008000;bootz 40008000"

#undef CONFIG_BOOTARGS
/* Android Default bootargs */
#define CONFIG_BOOTARGS	"fb_x_res=1280 fb_y_res=720 vout=hdmi led_blink=1 " \
			"hdmi_phy_res=720p60hz edid=0, hpd=1 disable_vu7=false " \
			"touch_invert_x=false touch_invert_y=false"

#endif	/* __CONFIG_H */
