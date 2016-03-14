
/*
 * include/configs/gxtvbb_skt_v1.h
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

#ifndef __GXTVBB_SKT_V1_H__
#define __GXTVBB_SKT_V1_H__

#include <asm/arch/cpu.h>

#define CONFIG_SYS_GENERIC_BOARD  1
#ifndef CONFIG_AML_MESON
#warning "include warning"
#endif

/*
 * platform power init config
 */
#define CONFIG_PLATFORM_POWER_INIT
#define CONFIG_VCCK_INIT_VOLTAGE	1100
#define CONFIG_VDDEE_INIT_VOLTAGE	1000		// voltage for power up
#define CONFIG_VDDEE_SLEEP_VOLTAGE	 850		// voltage for suspend

/* SMP Definitinos */
#define CPU_RELEASE_ADDR		secondary_boot_func

/* Serial config */
#define CONFIG_CONS_INDEX 2
#define CONFIG_BAUDRATE  115200
#define CONFIG_AML_MESON_SERIAL   1
#define CONFIG_SERIAL_MULTI		1
#define CONFIG_IR_REMOTE  1
//Enable ir remote wake up for bl30
#define CONFIG_IR_REMOTE_POWER_UP_KEY_CNT 8
#define CONFIG_IR_REMOTE_USE_PROTOCOL 0         // 0:nec  1:duokan  2:Toshiba 3:rca
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL1 0xef10fe01 //amlogic nec tv ir --- power
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL2 0xf30cfe01 //amlogic nec tv ir --- ch+
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL3 0xf20dfe01 //amlogic nec tv ir --- ch-
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL4 0xe51afb04 //amlogic nec box ir --- power
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL5 0xFFFFFFFF //amlogic nec tv ir --- right
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL6 0x00f2a0d5  //tcl rca
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL7 0xf40b1818  //hair toshiba
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL8 0xf30c0e0e  //skyworth
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL9 0xFFFFFFFF

/* args/envs */
#define CONFIG_SYS_MAXARGS  64
#define CONFIG_EXTRA_ENV_SETTINGS \
	"loadaddr=1080000\0"\
	"dtb_mem_addr=0x1000000\0" \
	"fdt_high=0x20000000\0" \
	"panel_type=lvds_0\0" \
	"outputmode=1080p60hz\0" \
	"panel_reverse=0\0" \
	"osd_reverse=n\0" \
	"video_reverse=n\0" \
	"display_width=1920\0" \
	"display_height=1080\0" \
	"display_bpp=16\0" \
	"display_color_index=16\0" \
	"display_layer=osd1\0" \
	"display_color_fg=0xffff\0" \
	"display_color_bg=0\0" \
	"fb_addr=0x3b000000\0" \
	"fb_width=1920\0" \
	"fb_height=1080\0" \
	"jtag=apao\0"\
	"init_display="\
		"osd open; osd clear; "\
		"vout output ${outputmode}; "\
		"imgread pic logo bootup $loadaddr; "\
		"bmp display $bootup_offset; bmp scale; "\
		"\0"\
	"storeargs=setenv bootargs "\
		"rootfstype=ramfs init=/init "\
		"console=ttyS0,115200 no_console_suspend "\
		"earlyprintk=aml-uart,0xc81004c0 "\
		"androidboot.selinux=disabled "\
		"logo=${display_layer},loaded,${fb_addr} "\
		"vout=${outputmode},enable "\
		"panel_type=${panel_type} hdmitx= "\
		"osd_reverse=${osd_reverse} video_reverse=${video_reverse} "\
		"jtag=${jtag} "\
		"\0"\
	"storeboot="\
		"if imgread kernel boot ${loadaddr}; then "\
			"bootm ${loadaddr}; "\
		"fi;"\
		"\0"

#define CONFIG_PREBOOT \
	"run init_display; "\
	"run storeargs; "

#define CONFIG_BOOTCOMMAND "run storeboot"

//#define CONFIG_ENV_IS_NOWHERE  1
#define CONFIG_ENV_SIZE   (64*1024)
#define CONFIG_FIT 1
#define CONFIG_OF_LIBFDT 1
#define CONFIG_ANDROID_BOOT_IMAGE 1
#define CONFIG_ANDROID_IMG 1
#define CONFIG_SYS_BOOTM_LEN (64<<20) /* Increase max gunzip size*/

/* cpu */
#define CONFIG_CPU_CLK					1536 //MHz. Range: 600-1800, should be multiple of 24

/* ddr */
#define CONFIG_DDR_SIZE					2048 //MB
#define CONFIG_DDR_CLK					720  //MHz, Range: 384-1200, should be multiple of 24
#define CONFIG_DDR_TYPE					CONFIG_DDR_TYPE_DDR3
/* DDR channel setting, please refer hardware design.
 *    CONFIG_DDR0_ONLY_32BIT           : one channel 32bit
 *    CONFIG_DDR0_ONLY_16BIT           : one channel 16bit
 *    CONFIG_DDR01_TWO_CHANNEL         : two channels 32bit
 *    CONFIG_DDR01_TWO_CHANNEL_16BIT   : two channels 16bit */
#define CONFIG_DDR_CHANNEL_SET			CONFIG_DDR01_TWO_CHANNEL
#define CONFIG_DDR_FULL_TEST			0 //1 for ddr full test
#define CONFIG_NR_DRAM_BANKS			1
/* ddr power saving */
#define CONFIG_DDR_ZQ_POWER_DOWN
#define CONFIG_DDR_POWER_DOWN_PHY_VREF
/* ddr detection */
#define CONFIG_DDR_SIZE_AUTO_DETECT		1 //0:disable, 1:enable
/* ddr functions */
#define CONFIG_CMD_DDR_D2PLL			0 //0:disable, 1:enable. d2pll cmd
#define CONFIG_CMD_DDR_TEST				0 //0:disable, 1:enable. ddrtest cmd

/* storage: emmc/nand/sd */
#define		CONFIG_STORE_COMPATIBLE 1
#define 	CONFIG_ENV_OVERWRITE
#define 	CONFIG_CMD_SAVEENV
#define		CONFIG_ENV_IS_IN_MMC 1
#define		CONFIG_SYS_MMC_ENV_DEV 1
#define		CONFIG_AML_SD_EMMC 1
#ifdef		CONFIG_AML_SD_EMMC
	#define 	CONFIG_GENERIC_MMC 1
	#define 	CONFIG_CMD_MMC 1
	#define CONFIG_EMMC_DDR52_EN 1
	#define CONFIG_EMMC_DDR52_CLK 35000000
#endif
#define 	CONFIG_AML_NAND	1
#ifdef CONFIG_AML_NAND
#endif
#define		CONFIG_PARTITIONS 1
#define 	CONFIG_SYS_NO_FLASH  1

/*SPI*/
#define CONFIG_AMLOGIC_SPI_FLASH 1
#ifdef 		CONFIG_AMLOGIC_SPI_FLASH
#undef 		CONFIG_ENV_IS_NOWHERE
//#define		CONFIG_SPI_BOOT 1
#define 	CONFIG_SPI_FLASH_ATMEL
#define 	CONFIG_SPI_FLASH_EON
#define 	CONFIG_SPI_FLASH_MACRONIX
#define 	CONFIG_SPI_FLASH_SPANSION
#define 	CONFIG_SPI_FLASH_SST
#define 	CONFIG_SPI_FLASH_STMICRO
#define 	CONFIG_SPI_FLASH_WINBOND
#define		CONFIG_SPI_FRAM_RAMTRON
#define		CONFIG_SPI_M95XXX
//#define		CONFIG_SPI_FLASH_GIGADEVICE
//#define		CONFIG_SPI_FLASH_PMDEVICE
//#define		CONFIG_SPI_NOR_SECURE_STORAGE
#define		CONFIG_SPI_FLASH_ESMT
#define		CONFIG_SPI_FLASH 1
#define 	CONFIG_CMD_SF 1
#ifdef CONFIG_SPI_BOOT
	#define CONFIG_ENV_OVERWRITE
	#define CONFIG_ENV_IS_IN_SPI_FLASH
	#define CONFIG_CMD_SAVEENV
	#define CONFIG_ENV_SECT_SIZE		0x10000
	#define CONFIG_ENV_OFFSET           0x1f0000
#endif
#endif


/* vpu */
#define CONFIG_AML_VPU 1

/* DISPLAY & HDMITX */
//#define CONFIG_AML_HDMITX20 1
#define CONFIG_AML_CANVAS 1
#define CONFIG_AML_VOUT 1
#define CONFIG_AML_OSD 1
#define CONFIG_OSD_SCALE_ENABLE 1
#define CONFIG_CMD_BMP 1

// #if defined(CONFIG_AML_VOUT)
// #define CONFIG_AML_CVBS 1
// #endif

#define CONFIG_AML_LCD    1
#define CONFIG_AML_LCD_TV 1
#define CONFIG_AML_LCD_TABLET 1

/* USB
 * Enable CONFIG_MUSB_HCD for Host functionalities MSC, keyboard
 * Enable CONFIG_MUSB_UDD for Device functionalities.
 */
/* #define CONFIG_MUSB_UDC		1 */
#define CONFIG_CMD_USB 1
#if defined(CONFIG_CMD_USB)
	#define CONFIG_GXTVBB_XHCI_BASE		0xc9000000
	#define CONFIG_GXTVBB_USB_PHY2_BASE	0xd0078000
	#define CONFIG_GXTVBB_USB_PHY3_BASE	0xd0078080
	#define CONFIG_USB_STORAGE      1
	#define CONFIG_USB_XHCI 1
	#define CONFIG_USB_XHCI_AMLOGIC 1
#endif //#if defined(CONFIG_CMD_USB)
//#define CONFIG_AML_TINY_USBTOOL 1
#define CONFIG_AML_V2_FACTORY_BURN   1

/* net */
#define CONFIG_CMD_NET   1
#if defined(CONFIG_CMD_NET)
	#define CONFIG_DESIGNWARE_ETH 1
	#define CONFIG_PHYLIB	1
	#define CONFIG_AML_PMU4 1
	#define CONFIG_NET_MULTI 1
	#define CONFIG_CMD_PING 1
	#define CONFIG_CMD_DHCP 1
	#define CONFIG_CMD_RARP 1
	#define CONFIG_HOSTNAME        arm_gxtvbb
	#define CONFIG_ETHADDR         00:15:18:01:81:31   /* Ethernet address */
	#define CONFIG_IPADDR          10.18.9.97          /* Our ip address */
	#define CONFIG_GATEWAYIP       10.18.9.1           /* Our getway ip address */
	#define CONFIG_SERVERIP        10.18.9.113         /* Tftp server ip address */
	#define CONFIG_NETMASK         255.255.255.0
#endif /* (CONFIG_CMD_NET) */

/* other devices */
#define CONFIG_EFUSE 1
#define CONFIG_SYS_I2C_AML 1
#define CONFIG_SYS_I2C_SPEED     400000

/* commands */
#define CONFIG_CMD_CACHE 1
#define CONFIG_CMD_BOOTI 1
#define CONFIG_CMD_EFUSE 1
#define CONFIG_CMD_I2C 1
#define CONFIG_CMD_MEMORY 1
#define CONFIG_CMD_FAT 1
#define CONFIG_CMD_GPIO 1
#define CONFIG_CMD_RUN
#define CONFIG_CMD_REBOOT 1
#define CONFIG_CMD_JTAG	1

/*file system*/
#define CONFIG_DOS_PARTITION 1
#define CONFIG_MMC 1
#define CONFIG_FS_FAT 1
#define CONFIG_FS_EXT4 1
#define CONFIG_LZO 1

/* Cache Definitions */
//#define CONFIG_SYS_DCACHE_OFF
//#define CONFIG_SYS_ICACHE_OFF

/* other functions */
#define CONFIG_NEED_BL301	1
#define CONFIG_BOOTDELAY	1
#define CONFIG_SYS_LONGHELP 1
#define CONFIG_CMD_MISC         1
#define CONFIG_CMD_CPU_TEMP 1
#define CONFIG_SYS_MEM_TOP_HIDE 0x08000000 //hide 128MB for kernel reserve

#define CONFIG_MULTI_DTB    1

/* ddr dump function defines */
//#define CONFIG_SPL_DDR_DUMP 1
#ifdef CONFIG_SPL_DDR_DUMP
	#define CONFIG_SPL_DDR_DUMP_ADDR 			0x01000000
	#define CONFIG_SPL_DDR_DUMP_SIZE			0x00200000
	#define CONFIG_SPL_DDR_DUMP_DEV_TYPE		0x4 //device type, 1:emmc, 4:sd
	#define CONFIG_SPL_DDR_DUMP_DEV_OFFSET		0x40000000 //offset of store device
	#define CONFIG_SPL_DDR_DUMP_FLAG			0x1 //flag write in sticky reg
#endif

//support secure boot
#define CONFIG_AML_SECURE_UBOOT   1

#if defined(CONFIG_AML_SECURE_UBOOT)

//for GXBB SRAM size limitation just disable NAND
//as the socket board default has no NAND
#undef CONFIG_AML_NAND

//unify build for generate encrypted bootloader "u-boot.bin.encrypt"
#define CONFIG_AML_CRYPTO_UBOOT   1

//unify build for generate encrypted kernel image
//SRC : "board/amlogic/gxb_skt_v1/boot.img"
//DST : "fip/boot.img.encrypt"
//#define CONFIG_AML_CRYPTO_IMG       1

#endif //CONFIG_AML_SECURE_UBOOT

#define CONFIG_SECURE_STORAGE 1

#endif

