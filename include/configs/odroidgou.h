/*
 * include/configs/odroidgou.h
 *
 * (C) Copyright 2021 Hardkernel Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */


#ifndef __ODROIDGOU_H__
#define __ODROIDGOU_H__

#define CONFIG_DEVICE_PRODUCT		"odroidgou"
#define ODROID_BOARD_UUID		"909802f2-a1dd-11e8-98d0-529269fb1459"

/* configs for CEC */
//define CONFIG_CEC_OSD_NAME		"ODROID-GOU"
//#define CONFIG_CEC_WAKEUP

#include "odroid-g12-common.h"

#undef CONFIG_AML_SPIFC
#undef ETHERNET_INTERNAL_PHY
#undef ETHERNET_EXTERNAL_PHY
#undef CONFIG_AML_CVBS

#undef CONFIG_SYS_I2C_SPEED
#define CONFIG_SYS_I2C_SPEED		400000
#define CONFIG_ODROID_PMIC 1

#define CONFIG_AML_LCD    1
#define CONFIG_AML_LCD_TABLET 1
#define CONFIG_AML_LCD_EXTERN 1
#define CONFIG_AML_LCD_EXTERN_MIPI_KD50T048A 1

#undef CONFIG_EXTRA_ENV_SETTINGS
#define CONFIG_EXTRA_ENV_SETTINGS \
        ENV_PXE_DEFAULT \
        ENV_MMC_DEFAULT \
        ENV_MMC_LIST_DEFAULT \
	ENV_USB_DEFAULT \
	ENV_USB_LIST_DEFAULT \
	ENV_BOOTSCRIPTS_DEFAULT \
	ENV_BOOT_ORDER_DEFAULT \
	ENV_BOOT_DEFAULT \
	ENV_BOOT_ATTEMPT_DEFAULT \
	"console=" CONFIG_DEFAULT_CONSOLE \
        "loadaddr=0x1080000\0"\
        "panel_type=lcd_0\0" \
        "outputmode=panel\0" \
        "hdmimode=1080p60hz\0" \
        "display_width=1920\0" \
        "display_height=1080\0" \
        "display_bpp=24\0" \
        "display_color_index=24\0" \
        "display_layer=osd0\0" \
        "display_color_fg=0xffff\0" \
        "display_color_bg=0\0" \
        "dtb_mem_addr=0x1000000\0" \
        "cramfsaddr=0x20000000\0" \
        "fb_addr=0x3d800000\0" \
        "fb_width=1920\0" \
        "fb_height=1080\0" \
        "fdt_high=0x20000000\0"\
        "fdt_addr_r=0x1000000\0" \
        "kernel_addr_r=0x1080000\0" \
        "ramdisk_addr_r=0x3080000\0" \
        "preloadaddr=0x4000000\0"\
        "cvbs_drv=0\0"\
        "osd_reverse=0\0"\
        "video_reverse=0\0"\
        "boot_part=boot\0"\
        "initargs="\
            "rootfstype=ramfs init=/init console=ttyS0,115200n8 no_console_suspend earlyprintk=aml-uart,0xff803000 ramoops.pstore_en=1 ramoops.record_size=0x8000 ramoops.console_size=0x4000 "\
            "\0"\
        "switch_bootmode=" \
            "get_rebootmode;" \
            "if test ${reboot_mode} = factory_reset; then " \
                "run boot_recovery;" \
            "else if test ${reboot_mode} = selfinstall; then " \
                "oem fdisk;" \
                "run boot_recovery;" \
            "else if test ${reboot_mode} = cold_boot; then " \
                /*"run try_auto_burn; "*/ \
            "else if test ${reboot_mode} = fastboot; then " \
                "fastboot;" \
            "fi;fi;fi;fi;" \
            "\0" \
        "boot_recovery="\
            "hdmitx edid; "\
            "if test ${hdmimode} = custombuilt; then setenv cmode modeline=${modeline} customwidth=${customwidth} customheight=${customheight}; fi; "\
            "if test ${hdmimode} == 2160p*; then setenv hdmimode 1080p60hz; fi; "\
            "setenv bootargs ${initargs} logo=${display_layer},loaded,${fb_addr} "\
                "vout=${hdmimode},enable hdmimode=${hdmimode} ${cmode} voutmode=${voutmode} "\
                "cvbsmode=${cvbsmode} osd_reverse=${osd_reverse} video_reverse=${video_reverse} "\
                "androidboot.selinux=permissive jtag=disable "\
                "androidboot.hardware=" CONFIG_DEVICE_PRODUCT " "\
                "recovery_part=recovery recovery_offset=0; "\
            "movi read dtbs 0 ${cramfsaddr}; " \
            "if test " CONFIG_DEVICE_PRODUCT " = odroidn2; then " \
                "cramfsload ${dtb_mem_addr} meson64_" CONFIG_DEVICE_PRODUCT "_android.dtb;" \
                "cramfsload ${loadaddr} odroid${variant}-opp.dtbo;" \
                "fdt addr ${dtb_mem_addr};" \
                "fdt resize 8192;" \
                "fdt apply ${loadaddr};" \
            "else " \
                "cramfsload ${dtb_mem_addr} meson64_odroid${variant}_android.dtb;" \
            "fi;" \
            "movi read recovery 0 ${loadaddr}; " \
            "booti ${loadaddr} - ${dtb_mem_addr}; " \
            "bootm ${loadaddr};" \
        "boot_rawimage=" \
	    "setenv bootargs ${initargs} logo=${display_layer},loaded,${fb_addr} " \
            "vout=${outputmode},enable cvbsmode=${cvbsmode} " \
            "hdmimode=${hdmimode} osd_reverse=${osd_reverse} video_reverse=${video_reverse} " \
            "androidboot.selinux=permissive androidboot.firstboot=${firstboot} jtag=disable " \
            "androidboot.hardware=" CONFIG_DEVICE_PRODUCT "; " \
	        "movi read dtbs 0 ${cramfsaddr}; " \
            "if test " CONFIG_DEVICE_PRODUCT " = odroidn2; then " \
                "cramfsload ${dtb_mem_addr} meson64_" CONFIG_DEVICE_PRODUCT "_android.dtb;" \
                "cramfsload ${loadaddr} odroid${variant}-opp.dtbo;" \
                "fdt addr ${dtb_mem_addr};" \
                "fdt resize 8192;" \
                "fdt apply ${loadaddr};" \
            "else " \
                "cramfsload ${dtb_mem_addr} meson64_odroid${variant}_android.dtb;" \
            "fi;" \
	        "movi read boot 0 ${loadaddr}; " \
	        "booti ${loadaddr} - ${dtb_mem_addr}; " \
	        "bootm ${loadaddr}; " \
        "init_display="\
            "osd open; osd clear; " \
            "for n in ${mmc_list}; do " \
                "if load mmc ${n} ${preloadaddr} logo.bmp.gz; then " \
                    "setenv logo_addr_r ${loadaddr}; " \
                    "unzip ${preloadaddr} ${logo_addr_r}; " \
                    "bmp display ${logo_addr_r}; " \
                    "bmp scale; " \
                "elif load mmc ${n} ${preloadaddr} logo.bmp; then " \
                    "setenv logo_addr_r ${preloadaddr}; " \
                    "bmp display ${logo_addr_r}; " \
                    "bmp scale; " \
                "fi; " \
            "done; " \
            "vout output ${outputmode};\0" \
	"bios_offset_uboot=0x00000000\0" \
	"bios_sizeof_uboot=0x0f0000\0" \
	"bios_offset_ubootenv=0x000f0000\0" \
	"bios_sizeof_ubootenv=0x010000\0" \
	"bios_offset_dtb=0x00100000\0" \
	"bios_sizeof_dtb=0x020000\0" \
	"bios_offset_kernel=0x00120000\0" \
	"bios_sizeof_kernel=0x3c0000\0" \
	"bios_offset_initrd=0x004e0000\0" \
	"bios_sizeof_initrd=0x320000\0" \
	"spiupdate_uboot="\
		"sf probe; "\
		"load mmc 1 ${loadaddr} u-boot.bin; "\
		"sf update ${loadaddr} ${bios_offset_uboot} ${bios_sizeof_uboot}\0"\
	"spiupdate_dtb="\
		"sf probe; "\
		"load mmc 1 ${loadaddr} meson64_odroidn2_spibios.dtb; "\
		"sf update ${loadaddr} ${bios_offset_dtb} ${bios_sizeof_dtb}\0"\
	"spiupdate_kernel="\
		"sf probe; "\
		"load mmc 1 ${loadaddr} uImage; "\
		"sf update ${loadaddr} ${bios_offset_kernel} ${bios_sizeof_kernel}\0"\
	"spiupdate_initrd="\
		"sf probe; "\
		"load mmc 1 ${loadaddr} rootfs.cpio.uboot; "\
		"sf update ${loadaddr} ${bios_offset_initrd} ${bios_sizeof_initrd}\0"\
	"spiupdate_full="\
		"sf probe; "\
		"load mmc 1 ${preloadaddr} spiboot.img; "\
		"sf update ${preloadaddr} 0 ${filesize}\0"\
	"petitboot,interface=eth0\0"\
	"petitboot,timeout=10\0"\
	"petitboot,autoboot=true\0"\
	"petitboot,console=" CONFIG_DEFAULT_CONSOLE \
	"boot_spi="\
		"sf probe; "\
		"sf read ${preloadaddr} ${bios_offset_kernel} ${bios_sizeof_kernel}; "\
		"sf read ${ramdisk_addr_r} ${bios_offset_initrd} ${bios_sizeof_initrd}; "\
		"sf read ${fdt_addr_r} ${bios_offset_dtb} ${bios_sizeof_dtb}; "\
		"if test -e mmc 1:1 petitboot.cfg; then "\
			"load mmc 1:1 ${loadaddr} petitboot.cfg; "\
			"ini petitboot; "\
		"fi; " \
		"if test -e mmc 1:1 spiboot.img; then " \
			"fdt addr ${fdt_addr_r}; " \
			"fdt resize; " \
			"fdt set /emmc@ffe07000 status 'disabled'; " \
			"fdt set /soc/cbus/spifc@14000 status 'okay'; " \
		"fi; " \
		"hdmitx edid; "\
		"osd open; osd clear; vout output ${outputmode}; "\
		"setenv bootargs ${initargs} console=tty0 "\
			"logo=osd0,loaded,0x3d800000 "\
			"osd_reverse=0 video_reverse=0 vout=${vout} "\
			"hdmimode=${hdmimode} voutmode=${voutmode} modeline=${modeline} "\
			"customwidth=${customwidth} customheight=${customheight} "\
			"petitboot,write?=true "\
			"petitboot,autoboot=${petitboot,autoboot} "\
			"petitboot,bootdevs=${petitboot,bootdevs} "\
			"petitboot,console=${petitboot,console} "\
			"petitboot,interface=${petitboot,interface} "\
			"petitboot,timeout=${petitboot,timeout}; "\
		"bootm ${preloadaddr} ${ramdisk_addr_r} ${fdt_addr_r};\0"

#endif
