
/*
 * include/configs/gxb_p200_v1.h
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

#ifndef __GXB_P200_V1_H__
#define __GXB_P200_V1_H__

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
#define CONFIG_VDDEE_INIT_VOLTAGE	1100

/* SMP Definitinos */
#define CPU_RELEASE_ADDR		secondary_boot_func

/* Serial config */
#define CONFIG_CONS_INDEX 2
#define CONFIG_BAUDRATE  115200
#define CONFIG_AML_MESON_SERIAL   1
#define CONFIG_SERIAL_MULTI		1

/* args/envs */
#define CONFIG_SYS_MAXARGS  64
#define CONFIG_EXTRA_ENV_SETTINGS \
        "firstboot=1\0"\
        "upgrade_step=0\0"\
        "loadaddr=1080000\0"\
        "outputmode=1080p60hz\0" \
        "hdmimode=1080p60hz\0" \
        "cvbsmode=576cvbs\0" \
        "display_width=1920\0" \
        "display_height=1080\0" \
        "display_bpp=16\0" \
        "display_color_index=16\0" \
        "display_layer=osd2\0" \
        "display_color_fg=0xffff\0" \
        "display_color_bg=0\0" \
        "fb_addr=0x3e000000\0" \
        "fb_width=1920\0" \
        "fb_height=1080\0" \
        "usb_burning=update 1000\0" \
        "fdt_high=0x20000000\0"\
        "try_auto_burn=update 700 750;\0"\
        "sdcburncfg=aml_sdc_burn.ini\0"\
        "sdc_burning=sdc_burn ${sdcburncfg}\0"\
        "wipe_data=successful\0"\
        "wipe_cache=successful\0"\
        "initargs="\
            "rootfstype=ramfs init=/init console=ttyS0,115200 no_console_suspend earlyprintk=aml-uart,0xc81004c0 selinux=0"\
            "\0"\
        "upgrade_check="\
                "if itest ${upgrade_step} == 3; then run init_display; run storeargs; run update; fi; "\
                "if itest ${upgrade_step} == 1; then env default -a; setenv upgrade_step 2; saveenv; fi; "\
                "\0"\
        "storeargs="\
            "setenv bootargs ${initargs} logo=osd1,loaded,${fb_addr},${outputmode},hdmimode=${hdmimode} cvbsmode=${cvbsmode} hdmitx=${cecconfig} androidboot.firstboot=${firstboot}; "\
            "\0"\
        "switch_bootmode="\
            "get_rebootmode; echo reboot_mode=${reboot_mode};"\
            "if test ${reboot_mode} = factory_reset; then "\
                    "run recovery_from_flash;"\
            "else if test ${reboot_mode} = update; then "\
                    "run update;"\
            "else if test ${reboot_mode} = cold_boot; then "\
                "run try_auto_burn; "\
            "fi;fi;fi;"\
            "\0" \
        "storeboot="\
            "if imgread kernel boot ${loadaddr}; then bootm ${loadaddr}; fi;"\
            "\0"\
        "factory_reset_poweroff_protect="\
            "echo wipe_data=${wipe_data}; echo wipe_cache=${wipe_cache};"\
            "if test ${wipe_data} = failed; then "\
                "run recovery_from_flash;"\
            "fi; "\
            "if test ${wipe_cache} = failed; then "\
                "run recovery_from_flash;"\
            "fi; \0" \
         "update="\
            /*first usb burning, second sdc_burn, third ext-sd autoscr/recovery, last udisk autoscr/recovery*/\
            "run usb_burning; "\
            "run sdc_burning; "\
            "if mmcinfo; then "\
                "run recovery_from_sdcard;"\
            "fi;"\
            "if usb start 0; then "\
                "run recovery_from_udisk;"\
            "fi;"\
            "run recovery_from_flash;"\
            "\0"\
        "recovery_from_sdcard="\
            "if fatload mmc 0 ${loadaddr} aml_autoscript; then autoscr ${loadaddr}; fi;"\
            "if fatload mmc 0 ${loadaddr} recovery.img; then bootm ${loadaddr};fi;"\
            "\0"\
        "recovery_from_udisk="\
            "if fatload usb 0 ${loadaddr} aml_autoscript; then autoscr ${loadaddr}; fi;"\
            "if fatload usb 0 ${loadaddr} recovery.img; then bootm ${loadaddr};fi;"\
            "\0"\
        "recovery_from_flash="\
            "if imgread kernel recovery ${loadaddr}; then bootm ${loadaddr}; fi"\
            "\0"\
        "init_display="\
            "osd open;osd clear;hdmitx output ${outputmode};imgread pic logo bootup $loadaddr;bmp display $bootup_offset;"\
            "\0"\

#define CONFIG_PREBOOT  \
            "run upgrade_check;"\
            "run init_display;"\
            "run storeargs;"\
            "run switch_bootmode;" \
            "run factory_reset_poweroff_protect;"
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
#define CONFIG_DDR_CLK					936  //MHz, Range: 384-1200, should be multiple of 24
#define CONFIG_DDR_TYPE					CONFIG_DDR_TYPE_DDR3
/* DDR channel setting, please refer hardware design.
 *    CONFIG_DDR0_RANK0_ONLY   : one channel
 *    CONFIG_DDR0_RANK01_SAME  : one channel use two rank with same setting
 *    CONFIG_DDR01_SHARE_AC    : two channels  */
#define CONFIG_DDR_CHANNEL_SET			CONFIG_DDR0_RANK01_SAME
#define CONFIG_DDR_FULL_TEST			0 //1 for ddr full test
#define CONFIG_NR_DRAM_BANKS			1

/* storage: emmc/nand/sd */
#define	CONFIG_STORE_COMPATIBLE 1
#define 	CONFIG_ENV_OVERWRITE
#define 	CONFIG_CMD_SAVEENV
#define		CONFIG_ENV_IS_IN_MMC 1
#define		CONFIG_SYS_MMC_ENV_DEV 1
#define CONFIG_AML_SD_EMMC 1
#ifdef	CONFIG_AML_SD_EMMC
	#define CONFIG_GENERIC_MMC 1
	#define CONFIG_CMD_MMC 1
#endif
#define CONFIG_AML_NAND	1
#ifdef CONFIG_AML_NAND
#endif
#define	CONFIG_PARTITIONS 1
#define CONFIG_SYS_NO_FLASH  1

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

//UBOOT Facotry usb/sdcard burning config
#define CONFIG_AML_V2_FACTORY_BURN              1
#define CONFIG_AML_FACTORY_BURN_LOCAL_UPGRADE   1       //support factory sdcard burning
#define CONFIG_POWER_KEY_NOT_SUPPORTED_FOR_BURN 1       //There isn't power-key for factory sdcard burning

/* net */
#define CONFIG_CMD_NET   1
#if defined(CONFIG_CMD_NET)
	#define CONFIG_AML_ETHERNET 1
	#define CONFIG_NET_MULTI 1
	#define CONFIG_CMD_PING 1
	#define CONFIG_CMD_DHCP 1
	#define CONFIG_CMD_RARP 1
	//#define CONFIG_NET_RGMII
	//	//#define CONFIG_NET_RMII_CLK_EXTERNAL //use external 50MHz clock source
	#define CONFIG_AML_ETHERNET    1                   /*to link /driver/net/aml_ethernet.c*/
	#define IP101PHY    1                   /*to link /driver/net/aml_ethernet.c*/
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
#define CONFIG_CMD_ECHO 1
#define CONFIG_CMD_JTAG	1

/*file system*/
#define CONFIG_DOS_PARTITION 1
#define CONFIG_MMC 1
#define CONFIG_FS_FAT 1
#define CONFIG_FS_EXT4 1

/* Cache Definitions */
//#define CONFIG_SYS_DCACHE_OFF
//#define CONFIG_SYS_ICACHE_OFF

/* other functions */
#define CONFIG_NEED_BL301	1
#define CONFIG_BOOTDELAY	1 //delay 1s
#define CONFIG_SYS_LONGHELP 1
#define CONFIG_CMD_MISC     1
#define CONFIG_CMD_ITEST    1
#define CONFIG_CMD_CPU_TEMP 1

#endif

