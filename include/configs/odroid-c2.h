/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * Configuration settings for ODROID-C2 (AMLogic S905) board,
 * cloned from include/configs/gxb_p200_v1.h
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef __ODROID_C2_H__
#define __ODROID_C2_H__

#include <linux/sizes.h>

#define CONFIG_MACH_ODROIDC2		1

#ifndef __SUSPEND_FIRMWARE__
#include <asm/arch/cpu.h>
#endif	/* for compile problem of A53 and m3 */

#define CONFIG_SYS_GENERIC_BOARD	1
#ifndef __SUSPEND_FIRMWARE__
#ifndef CONFIG_AML_MESON
#warning "include warning"
#endif
#endif		/* for compile problem of A53 and m3 */

/* CPU */
/* Clock rnage : 600~1800MHz, should be multiple of 24 */
#define CONFIG_CPU_CLK			1536

/* SMP Definitinos */
#define CPU_RELEASE_ADDR		secondary_boot_func

/* DDR */
#define CONFIG_DDR_SIZE			(1024 + 512)	// MB

/* Clock range : 384~1200MHz, should be multiple of 24 */
#define CONFIG_DDR_CLK			912
#define CONFIG_DDR_TYPE			CONFIG_DDR_TYPE_DDR3

/* DDR channel setting, please refer hardware design.
 * CONFIG_DDR0_RANK0_ONLY   : one channel
 * CONFIG_DDR0_RANK01_SAME  : one channel use two rank with same setting
 * CONFIG_DDR01_SHARE_AC    : two channels
 */
#define CONFIG_DDR_CHANNEL_SET		CONFIG_DDR0_RANK01_SAME
#define CONFIG_DDR_FULL_TEST		0 // 1 for ddr full test
#define CONFIG_NR_DRAM_BANKS		1

/* DDR power saving */
#define CONFIG_DDR_ZQ_POWER_DOWN	1
#define CONFIG_DDR_POWER_DOWN_PHY_VREF	1

/* DDR detection */
#define CONFIG_DDR_SIZE_AUTO_DETECT	1

/* Platform power init config */
#define CONFIG_PLATFORM_POWER_INIT
#define CONFIG_VCCK_INIT_VOLTAGE	1100
#define CONFIG_VDDEE_INIT_VOLTAGE	1050	// voltage for power up
#define CONFIG_VDDEE_SLEEP_VOLTAGE	850	// voltage for suspend

/* CEC */
#define CONFIG_CEC_OSD_NAME		"ODROID-C2"
#define CONFIG_CEC_WAKEUP

/* Serial config */
#define CONFIG_CONS_INDEX		2
#define CONFIG_BAUDRATE			115200
#define CONFIG_AML_MESON_SERIAL		1
#define CONFIG_SERIAL_MULTI		1

#define CONFIG_BOOTDELAY		1	// Seconds

/* args/envs */
#define CONFIG_SYS_MAXARGS		64

#define CONFIG_EXTRA_ENV_SETTINGS	\
	"boardname=ODROIDC2\0"		\
	"loadaddr=0x10800000\0"		\
	"dtb_mem_addr=0x1000000\0"	\
	"fdt_high=0x20000000\0"		\
	"bootargs=root=/dev/mmcblk0p2 init=/init console=ttyS0,115200 hdmimode=1080p earlyprintk=aml-uart,0xc81004c0\0"	\
	"bootcmd=fatload mmc 0 ${loadaddr} image; fatload mmc 0 ${dtb_mem_addr} gxbb_p200_2g.dtb; booti ${loadaddr} - ${dtb_mem_addr}\0"

#define CONFIG_PREBOOT
#define CONFIG_BOOTCOMMAND

//#define CONFIG_ENV_IS_NOWHERE  1
#define CONFIG_ENV_SIZE			(32 * 1024)	/* 32kB */
#define CONFIG_ENV_OFFSET		(640 * 1024)
#define CONFIG_FIT			1
#define CONFIG_OF_LIBFDT		1
#define CONFIG_ANDROID_BOOT_IMAGE	1
#define CONFIG_ANDROID_IMG		1
#define CONFIG_SYS_BOOTM_LEN		(64 << 20) /* Increase max gunzip size*/

/* Support commands */
#define CONFIG_CMD_SAVEENV		1
#define CONFIG_CMD_CACHE		1
#define CONFIG_CMD_BOOTI		1
#define CONFIG_CMD_EFUSE		1
//#define CONFIG_CMD_I2C			1
#define CONFIG_CMD_MEMORY		1
#define CONFIG_CMD_FAT			1
#define CONFIG_CMD_GPIO			1
#define CONFIG_CMD_RUN			1
#define CONFIG_CMD_REBOOT		1
#define CONFIG_CMD_ECHO			1
#define CONFIG_CMD_JTAG			1
#define CONFIG_CMD_AUTOSCRIPT		1
#define CONFIG_CMD_BMP			1
#define CONFIG_CMD_USB			1
#define CONFIG_CMD_NET			1
#define CONFIG_CMD_MISC			1
#define CONFIG_CMD_ITEST		1
#define CONFIG_CMD_CPU_TEMP		1
#define CONFIG_CMD_MEMTEST		1
#define CONFIG_CMD_USB_MASS_STORAGE	1
#define CONFIG_CMD_FASTBOOT		1

#if defined(CONFIG_CMD_USB_MASS_STORAGE)
#define CONFIG_USB_GADGET		1
#define CONFIG_USB_GADGET_MASS_STORAGE	1
#define CONFIG_USBDOWNLOAD_GADGET	1
#endif

#if defined(CONFIG_USB_GADGET)
#define CONFIG_USB_GADGET_DUALSPEED	1
#define CONFIG_USB_GADGET_S3C_UDC_OTG	1
#define CONFIG_USB_GADGET_VBUS_DRAW	0
#define CONFIG_SYS_CACHELINE_SIZE	64
#endif

#if defined(CONFIG_USBDOWNLOAD_GADGET)
#define CONFIG_G_DNL_VENDOR_NUM		0x18d1
#define CONFIG_G_DNL_PRODUCT_NUM	0x0002
#define CONFIG_G_DNL_MANUFACTURER	"Hardkernel Co., Ltd"
#endif

#if defined(CONFIG_CMD_FASTBOOT)
#define CONFIG_USB_FASTBOOT_BUF_ADDR	CONFIG_SYS_LOAD_ADDR
#define CONFIG_USB_FASTBOOT_BUF_SIZE	SZ_512M
#endif

#if defined(CONFIG_CMD_MEMTEST)
#define CONFIG_SYS_MEMTEST_START	CONFIG_SYS_LOAD_ADDR
#define CONFIG_SYS_MEMTEST_END		\
	(PHYS_SDRAM_1_SIZE - CONFIG_SYS_MEMTEST_START)
#define CONFIG_SYS_ALT_MEMTEST	1
#endif

/* File systems */
#define CONFIG_DOS_PARTITION		1
#define CONFIG_MMC			1
#define CONFIG_FS_FAT			1
#define CONFIG_FS_EXT4			1
#define CONFIG_LZO			1

/* storage: emmc/nand/sd */
#define CONFIG_ENV_OVERWRITE
#define CONFIG_ENV_IS_IN_MMC		1
#define CONFIG_SYS_MMC_ENV_DEV		0
#define CONFIG_AML_SD_EMMC		1

#if defined(CONFIG_AML_SD_EMMC)
#define CONFIG_GENERIC_MMC		1
#define CONFIG_CMD_MMC			1
#endif

#define	CONFIG_PARTITIONS		1
#define CONFIG_SYS_NO_FLASH		1

/* VPU */
#define CONFIG_AML_VPU			1

#if defined(CONFIG_AML_VPU)
#define CONFIG_VPU_PRESET		1
#endif

/* DISPLAY & HDMITX */
#define CONFIG_AML_HDMITX20		1
#define CONFIG_AML_CANVAS		1
#define CONFIG_AML_VOUT			1
#define CONFIG_AML_OSD			1
#define CONFIG_OSD_SCALE_ENABLE		1

#if defined(CONFIG_AML_VOUT)
#define CONFIG_AML_CVBS			1
#endif

/* USB
 * Enable CONFIG_MUSB_HCD for Host functionalities MSC, keyboard
 * Enable CONFIG_MUSB_UDD for Device functionalities.
 */
/* #define CONFIG_MUSB_UDC		1 */

#if defined(CONFIG_CMD_USB)
#define CONFIG_M8_USBPORT_BASE_A	0xc9000000
#define CONFIG_M8_USBPORT_BASE_B	0xc9100000
#define CONFIG_USB_STORAGE		1
#define CONFIG_USB_DWC_OTG_HCD		1
#define CONFIG_USB_DWC_OTG_294		1
#endif

/* NETWORK */
#if defined(CONFIG_CMD_NET)
#define CONFIG_AML_ETHERNET		1
#define CONFIG_NET_MULTI		1
#define CONFIG_CMD_PING			1
#define CONFIG_CMD_DHCP			1
#define CONFIG_CMD_RARP			1
#if 0
#define CONFIG_NET_RGMII		1
#define CONFIG_NET_RMII_CLK_EXTERNAL	1	// Use external 50MHz
#endif

#define IP101PHY			1
#define CONFIG_HOSTNAME			odroid-c2
#define CONFIG_ETHADDR			00:15:18:01:81:31	/* MAC address */
#define CONFIG_GATEWAYIP		192.168.0.1	/* Gateway */
#define CONFIG_IPADDR			192.168.0.2	/* IP */
#define CONFIG_NETMASK			255.255.255.0	/* Netmask */
#define CONFIG_SERVERIP			192.168.0.10	/* TFTP server */
#endif

/* I2C */
#if defined(CONFIG_CMD_I2C)
#define CONFIG_SYS_I2C_AML		1
#define CONFIG_SYS_I2C_SPEED		400000	// kHz
#endif

/* MISC */
#define CONFIG_EFUSE			1
#define CONFIG_NEED_BL301		1
#define CONFIG_SYS_LONGHELP		1
#define CONFIG_SYS_MEM_TOP_HIDE		0x08000000	/* Hide 128MB for
							   kernel reserve */
#endif
