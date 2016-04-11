
/*
 * include/configs/gxb_skt_v1.h
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

#ifndef __GXL_SKT_V1_H__
#define __GXL_SKT_V1_H__

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
#define CONFIG_VDDEE_INIT_VOLTAGE	1100		// voltage for power up
#define CONFIG_VDDEE_SLEEP_VOLTAGE	 850		// voltage for suspend

/* configs for CEC */
#define CONFIG_CEC_OSD_NAME		"Mbox"
#define CONFIG_CEC_WAKEUP

/* SMP Definitinos */
#define CPU_RELEASE_ADDR		secondary_boot_func

/* Serial config */
#define CONFIG_CONS_INDEX 2
#define CONFIG_BAUDRATE  115200
#define CONFIG_AML_MESON_SERIAL   1
#define CONFIG_SERIAL_MULTI		1

//Enable ir remote wake up for bl30
#define CONFIG_IR_REMOTE_POWER_UP_KEY_CNT 3
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL1 0XE51AFB04 //amlogic tv ir --- power
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL2 0XBB44FB04 //amlogic tv ir --- ch+
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL3 0xF20DFE01 //amlogic tv ir --- ch-
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL4 0xFFFFFFFF

/* args/envs */
#define CONFIG_SYS_MAXARGS  64
#define CONFIG_EXTRA_ENV_SETTINGS \
	"storeboot=\0"
#define CONFIG_BOOTARGS "init=/init console=ttyS0,115200 no_console_suspend earlyprintk=aml-uart,0xc81004c0 ramoops.pstore_en=1 ramoops.record_size=0x8000 ramoops.console_size=0x4000 "
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
#define CONFIG_DDR_SIZE					1024 //MB
#define CONFIG_DDR_CLK					792  //MHz, Range: 384-1200, should be multiple of 24
#define CONFIG_DDR_TYPE					CONFIG_DDR_TYPE_DDR3
/* DDR channel setting, please refer hardware design.
 *    CONFIG_DDR0_RANK0        : DDR0 rank0
 *    CONFIG_DDR0_RANK01       : DDR0 rank0+1
 *    CONFIG_DDR0_16BIT        : DDR0 16bit mode */
#define CONFIG_DDR_CHANNEL_SET			CONFIG_DDR0_RANK0
#define CONFIG_DDR_FULL_TEST			0 //1 for ddr full test
#define CONFIG_NR_DRAM_BANKS			1
/* ddr power saving */
#define CONFIG_DDR_ZQ_POWER_DOWN
#define CONFIG_DDR_POWER_DOWN_PHY_VREF
/* ddr detection */
#define CONFIG_DDR_SIZE_AUTO_DETECT		0 //0:disable, 1:enable
/* ddr functions */
#define CONFIG_CMD_DDR_D2PLL			0 //0:disable, 1:enable. d2pll cmd
#define CONFIG_CMD_DDR_TEST				0 //0:disable, 1:enable. ddrtest cmd

/* storage: emmc/nand/sd */
#define		CONFIG_STORE_COMPATIBLE 1
#define CONFIG_AML_NAND	1
#define 	CONFIG_ENV_OVERWRITE
#define 	CONFIG_CMD_SAVEENV
/* fixme, need fix*/

#if (defined(CONFIG_ENV_IS_IN_AMLNAND) || defined(CONFIG_ENV_IS_IN_MMC)) && defined(CONFIG_STORE_COMPATIBLE)
#error env in amlnand/mmc already be compatible;
#endif
#define		CONFIG_AML_SD_EMMC 1
#ifdef		CONFIG_AML_SD_EMMC
	#define 	CONFIG_GENERIC_MMC 1
	#define 	CONFIG_CMD_MMC 1
	#define	CONFIG_SYS_MMC_ENV_DEV 1
	#define CONFIG_EMMC_DDR52_EN 1
	#define CONFIG_EMMC_DDR52_CLK 35000000
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
#ifdef CONFIG_AML_VPU
#define CONFIG_VPU_PRESET 1
#endif

/* DISPLAY & HDMITX */
#define CONFIG_AML_HDMITX20 1
#define CONFIG_AML_CANVAS 1
#define CONFIG_AML_VOUT 1
#define CONFIG_AML_OSD 1
#define CONFIG_OSD_SCALE_ENABLE 1
#define CONFIG_CMD_BMP 1

#if defined(CONFIG_AML_VOUT)
#define CONFIG_AML_CVBS 1
#endif

/* USB
 * Enable CONFIG_MUSB_HCD for Host functionalities MSC, keyboard
 * Enable CONFIG_MUSB_UDD for Device functionalities.
 */
/* #define CONFIG_MUSB_UDC		1 */
#define CONFIG_CMD_USB 1
#if defined(CONFIG_CMD_USB)
	#define CONFIG_M8_USBPORT_BASE_A	0xC9000000
	#define CONFIG_M8_USBPORT_BASE_B	0xC9100000
	#define CONFIG_USB_STORAGE      1
	#define CONFIG_USB_DWC_OTG_HCD  1
	#define CONFIG_USB_DWC_OTG_294	1
#endif //#if defined(CONFIG_CMD_USB)
//#define CONFIG_AML_TINY_USBTOOL 1
#define CONFIG_AML_V2_FACTORY_BURN   1

/* net */
#define CONFIG_CMD_NET   1
#if defined(CONFIG_CMD_NET)
	#define CONFIG_DESIGNWARE_ETH 1
	#define CONFIG_PHYLIB	1
	#define CONFIG_NET_MULTI 1
	#define CONFIG_CMD_PING 1
	#define CONFIG_CMD_DHCP 1
	#define CONFIG_CMD_RARP 1
	#define CONFIG_HOSTNAME        arm_gxbb
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

/* debug mode defines */
//#define CONFIG_DEBUG_MODE			1
#ifdef CONFIG_DEBUG_MODE
#define CONFIG_DDR_CLK_DEBUG		636
#define CONFIG_CPU_CLK_DEBUG		600
#endif

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
//#undef CONFIG_AML_NAND

//unify build for generate encrypted bootloader "u-boot.bin.encrypt"
#define CONFIG_AML_CRYPTO_UBOOT   1

//unify build for generate encrypted kernel image
//SRC : "board/amlogic/gxb_skt_v1/boot.img"
//DST : "fip/boot.img.encrypt"
//#define CONFIG_AML_CRYPTO_IMG       1

#endif //CONFIG_AML_SECURE_UBOOT

#define CONFIG_SECURE_STORAGE 1

//build with uboot auto test
//#define CONFIG_AML_UBOOT_AUTO_TEST 1

//board customer ID
//#define CONFIG_CUSTOMER_ID  (0x6472616F624C4D41)

#if defined(CONFIG_CUSTOMER_ID)
  #undef CONFIG_AML_CUSTOMER_ID
  #define CONFIG_AML_CUSTOMER_ID  CONFIG_CUSTOMER_ID
#endif

#endif

