/*
 * include/configs/odroid-g12-common.h
 *
 * (C) Copyright 2018 Hardkernel Co., Ltd
 * * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __ODROID_G12_COMMON_H__
#define __ODROID_G12_COMMON_H__

#include <asm/arch/cpu.h>
#include <linux/sizes.h>

#define CONFIG_SYS_GENERIC_BOARD		1
#ifndef CONFIG_AML_MESON
#warning "include warning"
#endif

#ifndef CONFIG_DEVICE_PRODUCT
#error CONFIG_DEVICE_PRODUCT is missing!!
#endif

/*
 * platform power init config
 */
#define CONFIG_PLATFORM_POWER_INIT
#define CONFIG_VCCK_INIT_VOLTAGE		800	/* VCCK power up voltage */
#define CONFIG_VDDEE_INIT_VOLTAGE		860	/* VDDEE power up voltage */
#define CONFIG_VDDEE_SLEEP_VOLTAGE		731	/* VDDEE suspend voltage */

/* configs for CEC */
#define CONFIG_CEC_OSD_NAME			"AML_TV"
#define CONFIG_CEC_WAKEUP

/* SMP Definitinos */
#define CPU_RELEASE_ADDR			secondary_boot_func

/* config saradc*/
#define CONFIG_CMD_SARADC			1
#define CONFIG_SARADC_CH			2

/* ADC keys */
#undef CONFIG_ADC_KEY
#ifdef CONFIG_ADC_KEY
#define CONFIG_ADC_POWER_KEY_CHAN		2  /* channel range: 0-7*/
#define CONFIG_ADC_POWER_KEY_VAL		0  /* sample value range: 0-1023*/
#endif

/* Enable GPIO Key Wakeup */
#define CONFIG_GPIO_WAKEUP

/* Serial config */
#define CONFIG_CONS_INDEX			2
#define CONFIG_BAUDRATE				115200
#define CONFIG_AML_MESON_SERIAL			1
#define CONFIG_SERIAL_MULTI			1

/* Enable ir remote wake up for bl30 */
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL1	0x23DC4DB2 /* hardkernel ir --- power */
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL2	0XFFFFFFFF
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL3	0xFFFFFFFF
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL4	0XFFFFFFFF
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL5	0xFFFFFFFF
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL6	0xFFFFFFFF
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL7	0xFFFFFFFF
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL8	0xFFFFFFFF
#define CONFIG_IR_REMOTE_POWER_UP_KEY_VAL9	0xFFFFFFFF

#define CONFIG_CMD_PXE				1
#if defined(CONFIG_CMD_PXE)
#define CONFIG_BOOTP_PXE			1
#define CONFIG_BOOTP_PXE_CLIENTARCH		0x16
#define CONFIG_BOOTP_GATEWAY			1
#define CONFIG_BOOTP_HOSTNAME			1
#define CONFIG_BOOTP_VCI_STRING			"U-Boot.armv8"
#define CONFIG_BOOTP_BOOTPATH			1
#define CONFIG_BOOTP_SUBNET			1
#define CONFIG_BOOTP_DNS			1
#define CONFIG_UDP_CHECKSUM			1

#define CONFIG_MENU				1

#define CONFIG_DEFAULT_CONSOLE			"ttyS0,115200n8\0"

#define ENV_PXE_DEFAULT					\
	"pxefile_addr_r=0x1070000\0"			\
	"pxeuuid=" ODROID_BOARD_UUID "\0"		\
	"bootfile=Image\0"				\
	"boot_pxe="					\
		"dhcp; "				\
		"pxe get; "				\
		"pxe boot\0"
#else
#define ENV_PXE_DEFAULT
#endif

#define ENV_MMC_LIST_DEFAULT			"mmc_list=0 1\0"

#define ENV_MMC_DEFAULT					\
	"boot_mmc="					\
		"setenv devtype mmc; "			\
		"for n in ${mmc_list}; do "	\
			"setenv devnum ${n}; "		\
			"setenv devno ${n}; "		\
			"setenv mmc_dev ${n}; "		\
			"cfgload; "			\
		"done\0"

#define ENV_MMC_BOOT_DISTRO				\
	"boot_mmc_distro="				\
		"setenv devtype mmc; "			\
		"for n in ${mmc_list}; do "		\
			"setenv devnum ${n}; "		\
			"setenv devno ${n}; "		\
			"setenv mmc_dev ${n}; "		\
			"load mmc ${n} ${preloadaddr} boot.scr; "	\
			"source ${preloadaddr}; "		\
		"done\0"				\

/* args/envs */
#define CONFIG_SYS_MAXARGS  64
#define CONFIG_EXTRA_ENV_SETTINGS \
        ENV_PXE_DEFAULT \
        ENV_MMC_DEFAULT \
        ENV_MMC_BOOT_DISTRO \
        ENV_MMC_LIST_DEFAULT \
	"console=" CONFIG_DEFAULT_CONSOLE \
        "loadaddr=1080000\0"\
        "outputmode=1080p60hz\0" \
        "hdmimode=1080p60hz\0" \
        "display_width=1920\0" \
        "display_height=1080\0" \
        "display_bpp=24\0" \
        "display_color_index=24\0" \
        "display_layer=osd0\0" \
        "display_color_fg=0xffff\0" \
        "display_color_bg=0\0" \
        "dtb_mem_addr=0x1000000\0" \
        "fb_addr=0x3d800000\0" \
        "fb_width=1920\0" \
        "fb_height=1080\0" \
        "fdt_high=0x20000000\0"\
        "fdt_addr_r=0x1000000\0" \
        "kernel_addr_r=0x1080000\0" \
        "ramdisk_addr_r=0x3080000\0" \
        "preloadaddr=0x3000000\0"\
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
            "if test ${hdmimode} = 2160p30hz || test ${hdmimode} = 2160p60hz; then setenv hdmimode 1080p60hz; fi; "\
            "setenv bootargs ${initargs} logo=${display_layer},loaded,${fb_addr} "\
                "vout=${hdmimode},enable hdmimode=${hdmimode} ${cmode} voutmode=${voutmode} "\
                "cvbsmode=${cvbsmode} osd_reverse=${osd_reverse} video_reverse=${video_reverse} "\
                "androidboot.selinux=permissive jtag=disable "\
                "androidboot.hardware=" CONFIG_DEVICE_PRODUCT " "\
                "recovery_part=recovery recovery_offset=0; "\
            "for n in ${mmc_list}; do "\
                "mmc dev ${n}; " \
                "movi read recovery 0 ${loadaddr}; " \
                "movi read dtbs 0 ${dtb_mem_addr}; " \
                "booti ${loadaddr} - ${dtb_mem_addr}; " \
                "bootm;" \
            "done\0" \
        "boot_rawimage=setenv bootargs ${initargs} logo=${display_layer},loaded,${fb_addr} " \
            "vout=${outputmode},enable cvbsmode=${cvbsmode} " \
            "hdmimode=${hdmimode} osd_reverse=${osd_reverse} video_reverse=${video_reverse} " \
            "androidboot.selinux=permissive androidboot.firstboot=${firstboot} jtag=disable " \
            "androidboot.hardware=" CONFIG_DEVICE_PRODUCT "; " \
            "for n in ${mmc_list}; do " \
                "mmc dev ${n}; " \
	        "movi read boot 0 ${loadaddr}; " \
	        "movi read dtbs 0 ${dtb_mem_addr}; " \
	        "booti ${loadaddr} - ${dtb_mem_addr}; " \
	        "bootm; " \
            "done\0" \
	"boot_default="\
            "run boot_mmc; " \
            "run boot_mmc_distro; " \
            "run boot_rawimage\0" \
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
	"set_spi_params="\
		"setenv start_uboot 0x0; "\
		"setenv start_kernel 0x119000; "\
		"setenv start_dtb 0x100000; "\
		"setenv start_initrd 0x4E6C00; "\
		"setenv size_kernel 0x3CDC00; "\
		"setenv size_dtb 0x19000; "\
		"setenv size_initrd 0x319400;\0"\
	"fusing_spi_from_sd="\
		"sf probe; "\
		"sf erase 0x0 0x800000; "\
		"load mmc 1 ${loadaddr} spiboot.img; "\
		"sf write ${loadaddr} 0x0 ${filesize}\0"\
	"booting_from_spi="\
		"hdmitx edid; "\
		"setenv bootargs ${initargs} console=tty0 logo=osd0,loaded,0x3d800000 osd_reverse=0 video_reverse=0; "\
		"setenv bootargs ${bootargs} vout=${vout} hdmimode=${hdmimode} modeline=${modeline} voutmode=${voutmode}; "\
		"osd open; "\
		"osd clear; "\
		"vout output ${outputmode}; "\
		"run set_spi_params; "\
		"sf probe; "\
		"sf read ${preloadaddr} ${start_kernel} ${size_kernel}; "\
		"sf read ${initrd_high} ${start_initrd} ${size_initrd}; "\
		"sf read ${dtb_mem_addr} ${start_dtb} ${size_dtb}; "\
		"if test -e mmc 1:1 spiboot.img; then " \
			"fdt addr ${dtb_mem_addr}; " \
			"fdt resize; " \
			"fdt set /emmc@ffe07000 status 'disabled'; " \
			"fdt set /soc/cbus/spifc@14000 status 'okay'; " \
		"fi; " \
		"bootm ${preloadaddr} ${initrd_high} ${dtb_mem_addr};\0"\

#define CONFIG_PREBOOT  \
            "run switch_bootmode;"

#define CONFIG_BOOTCOMMAND			"run boot_default"

#define CONFIG_BOOTAREA_SIZE			(1 * SZ_1M)
#define CONFIG_MBR_SIZE				512
#define CONFIG_ENV_SIZE				(64 * SZ_1K)
#define CONFIG_UBOOT_SIZE			(CONFIG_BOOTAREA_SIZE - \
		(CONFIG_MBR_SIZE + CONFIG_ENV_SIZE))
#define CONFIG_PTABLE_SIZE			(4 * SZ_1K)

#define CONFIG_DTB_SIZE				(128 * SZ_1K)

#define CONFIG_ENV_OFFSET			(CONFIG_MBR_SIZE + CONFIG_UBOOT_SIZE)
#define CONFIG_PTABLE_OFFSET			(CONFIG_ENV_OFFSET + CONFIG_ENV_SIZE)

#define CONFIG_FIT				1
#define CONFIG_OF_LIBFDT			1
#define CONFIG_ANDROID_BOOT_IMAGE		1
#define CONFIG_ANDROID_IMG			1
#define CONFIG_SYS_BOOTM_LEN			(64 << 20) /* Increase max gunzip size */

/* cpu */
#define CONFIG_CPU_CLK				1200 //MHz. Range: 360-2000, should be multiple of 24

#define CONFIG_NR_DRAM_BANKS			1

/* ddr functions */
#define CONFIG_DDR_FULL_TEST			0 //0:disable, 1:enable. ddr full test
#define CONFIG_CMD_DDR_D2PLL			0 //0:disable, 1:enable. d2pll cmd
#define CONFIG_CMD_DDR_TEST			0 //0:disable, 1:enable. ddrtest cmd
#define CONFIG_DDR_LOW_POWER			0 //0:disable, 1:enable. ddr clk gate for lp
#define CONFIG_DDR_ZQ_PD			0 //0:disable, 1:enable. ddr zq power down
#define CONFIG_DDR_USE_EXT_VREF			0 //0:disable, 1:enable. ddr use external vref
#define CONFIG_DDR4_TIMING_TEST			0 //0:disable, 1:enable. ddr4 timing test function
#define CONFIG_DDR_PLL_BYPASS			0 //0:disable, 1:enable. ddr pll bypass function

/* storage: emmc/nand/sd */
#define CONFIG_ENV_IS_IN_MMC			1
#define 	CONFIG_ENV_OVERWRITE
#define 	CONFIG_CMD_SAVEENV
/* fixme, need fix*/

#if (defined(CONFIG_ENV_IS_IN_AMLNAND) || defined(CONFIG_ENV_IS_IN_MMC)) && defined(CONFIG_STORE_COMPATIBLE)
#error env in amlnand/mmc already be compatible;
#endif

#define	CONFIG_AML_SD_EMMC			1
#ifdef CONFIG_AML_SD_EMMC
	#define CONFIG_GENERIC_MMC		1
	#define CONFIG_CMD_MMC			1
	#define	CONFIG_SYS_MMC_ENV_DEV		1
	#define CONFIG_EMMC_DDR52_EN		0
	#define CONFIG_EMMC_DDR52_CLK		35000000
#endif

#define CONFIG_PARTITIONS			1
#define CONFIG_SYS_NO_FLASH			1

/* meson SPI */
#define CONFIG_AML_SPIFC
/* #define CONFIG_AML_SPICC */
#if defined CONFIG_AML_SPIFC || defined CONFIG_AML_SPICC
	#define CONFIG_OF_SPI
	#define CONFIG_DM_SPI
	#define CONFIG_CMD_SPI
#endif
/* SPI flash config */
#ifdef CONFIG_AML_SPIFC
	#define CONFIG_SPI_FLASH
	/* max speed is 50MHz based on S905D2 SPIFC timing spec */
	#define CONFIG_SF_DEFAULT_SPEED		50000000
	#define CONFIG_DM_SPI_FLASH
	#define CONFIG_CMD_SF
	/* SPI flash surpport list */
	#define CONFIG_SPI_FLASH_ATMEL
	#define CONFIG_SPI_FLASH_EON
	#define CONFIG_SPI_FLASH_GIGADEVICE
	#define CONFIG_SPI_FLASH_MACRONIX
	#define CONFIG_SPI_FLASH_SPANSION
	#define CONFIG_SPI_FLASH_STMICRO
	#define CONFIG_SPI_FLASH_SST
	#define CONFIG_SPI_FLASH_WINBOND
	#define CONFIG_SPI_FRAM_RAMTRON
	#define CONFIG_SPI_M95XXX
	#define CONFIG_SPI_FLASH_ESMT
	/* SPI nand flash support */
	#define CONFIG_SPI_NAND
	#define CONFIG_BL2_SIZE			(64 * 1024)
#endif

#define CONFIG_ENV_IS_IN_SPI_FLASH		1
#ifdef CONFIG_ENV_IS_IN_SPI_FLASH
#define CONFIG_ENV_SECT_SIZE			(64 * SZ_1K)
#if (CONFIG_ENV_SIZE < CONFIG_ENV_SECT_SIZE)
#error 'CONFIG_ENV_SIZE' must be larger or equal than 'CONFIG_ENV_SECT_SIZE'
#endif
#endif

#if defined defined CONFIG_SPI_NAND
	#define CONFIG_MTD_DEVICE y
	#define CONFIG_RBTREE
	#define CONFIG_CMD_MTDPARTS		1
	#define CONFIG_MTD_PARTITIONS		1
#endif

/* vpu */
#define CONFIG_AML_VPU				1
//#define CONFIG_VPU_CLK_LEVEL_DFT		7

/* DISPLAY & HDMITX */
#define CONFIG_AML_HDMITX20			1
#define CONFIG_AML_CANVAS			1
#define CONFIG_AML_VOUT				1
#define CONFIG_AML_OSD				1
#define CONFIG_OSD_SCALE_ENABLE			1
#define CONFIG_CMD_BMP				1

/* gzip compressed bmp images */
#define CONFIG_VIDEO_BMP_GZIP			1
#define CONFIG_SYS_VIDEO_LOGO_MAX_SIZE		(6 << 20)

#if defined(CONFIG_AML_VOUT)
#define CONFIG_AML_CVBS				1
#endif

/* USB
 * Enable CONFIG_MUSB_HCD for Host functionalities MSC, keyboard
 * Enable CONFIG_MUSB_UDD for Device functionalities.
 */
//#define CONFIG_MUSB_UDC			1
#define CONFIG_CMD_USB				1
#if defined(CONFIG_CMD_USB)
	#define CONFIG_GXL_XHCI_BASE		0xff500000
	#define CONFIG_GXL_USB_PHY2_BASE        0xffe09000
	#define CONFIG_GXL_USB_PHY3_BASE        0xffe09080
	#define CONFIG_USB_PHY_20		0xff636000
	#define CONFIG_USB_PHY_21		0xff63A000
	#define CONFIG_USB_STORAGE		1
	#define CONFIG_USB_XHCI			1
	#define CONFIG_USB_XHCI_AMLOGIC_V2	1
	/* USB OTG Power Enable */
	#define CONFIG_USB_GPIO_PWR		GPIOEE(GPIOH_6)
	#define CONFIG_USB_GPIO_PWR_NAME	"GPIOH_6"
	/* USB Host Hub Reset */
	#define CONFIG_USB_HUB_RST_N		GPIOEE(GPIOH_4)
	#define CONFIG_USB_HUB_RST_N_NAME	"GPIOH_4"
	/* USB Host Hub Enable */
	#define CONFIG_USB_HUB_CHIP_EN		GPIOEE(GPIOH_5)
	#define CONFIG_USB_HUB_CHIP_EN_NAME	"GPIOH_5"
	//#define CONFIG_USB_XHCI_AMLOGIC_USB3_V2	1
#endif //#if defined(CONFIG_CMD_USB)

#define CONFIG_TXLX_USB				1
#define CONFIG_USB_DEVICE_V2			1
#define USB_PHY2_PLL_PARAMETER_1		0x09400414
#define USB_PHY2_PLL_PARAMETER_2		0x927e0000
#define USB_PHY2_PLL_PARAMETER_3		0xAC5F49E5
#define USB_G12x_PHY_PLL_SETTING_1		0xfe18
#define USB_G12x_PHY_PLL_SETTING_2		0xfff
#define USB_G12x_PHY_PLL_SETTING_3		0x78000
#define USB_G12x_PHY_PLL_SETTING_4		0xe0004
#define USB_G12x_PHY_PLL_SETTING_5		0xe000c

/* UBOOT fastboot config */
#define CONFIG_CMD_FASTBOOT			1
#define CONFIG_FASTBOOT_FLASH_MMC_DEV		0
#define CONFIG_FASTBOOT_FLASH			1
#define CONFIG_USB_GADGET			1
#define CONFIG_USBDOWNLOAD_GADGET		1
#define CONFIG_SYS_CACHELINE_SIZE		64
#define CONFIG_FASTBOOT_MAX_DOWN_SIZE		0x8000000

/* net */
#define CONFIG_CMD_NET				1
#if defined(CONFIG_CMD_NET)
	#define CONFIG_DESIGNWARE_ETH		1
	#define CONFIG_PHYLIB			1
	#define CONFIG_NET_MULTI		1
	#define CONFIG_CMD_GPT			1
	#define CONFIG_CMD_PING			1
	#define CONFIG_CMD_DHCP			1
	#define CONFIG_CMD_RARP			1
	#define CONFIG_HOSTNAME			arm_gxbb
//	#define CONFIG_RANDOM_ETHADDR		1	/* use random eth addr, or default */
	#define CONFIG_ETHADDR			00:15:18:01:81:31	/* Ethernet address */
	#define CONFIG_IPADDR			192.168.0.5		/* Our ip address */
	#define CONFIG_GATEWAYIP		192.168.0.1		/* Our getway ip address */
	#define CONFIG_SERVERIP			192.168.0.2		/* Tftp server ip address */
	#define CONFIG_NETMASK			255.255.255.0
#endif

/* other devices */
#define CONFIG_SYS_I2C_AML			1
#define CONFIG_SYS_I2C_SPEED			400000
#define CONFIG_EFUSE				1

/* commands */
#define CONFIG_CMD_CACHE			1
#define CONFIG_CMD_BOOTI			1
#define CONFIG_CMD_BOOTM			1
#define CONFIG_CMD_EFUSE			1
#define CONFIG_CMD_I2C				1
#define CONFIG_CMD_MEMORY			1
#define CONFIG_CMD_FAT				1
#define CONFIG_CMD_EXT2				1
#define CONFIG_CMD_EXT4				1
#define CONFIG_CMD_GPIO				1
#define CONFIG_CMD_RUN				1
#define CONFIG_CMD_REBOOT			1
#define CONFIG_CMD_ECHO				1
#define CONFIG_CMD_JTAG				1
#define CONFIG_CMD_AUTOSCRIPT			1
#define CONFIG_CMD_MISC				1
#define CONFIG_CMD_BDI				1
#define CONFIG_CMD_FS_GENERIC			1

/*file system*/
#define CONFIG_DOS_PARTITION			1
#define CONFIG_EFI_PARTITION			1
#define CONFIG_MPT_PARTITION			1
#define CONFIG_MMC				1
#define CONFIG_FS_FAT				1
#define CONFIG_FS_EXT4				1
#define CONFIG_LZO				1
#define CONFIG_FAT_WRITE			1
#define CONFIG_EXT4_WRITE			1

/* Cache Definitions */
//#define CONFIG_SYS_DCACHE_OFF
//#define CONFIG_SYS_ICACHE_OFF

/* Compression commands */
#define CONFIG_CMD_UNZIP			1
#define CONFIG_LZMA				1

/* other functions */
#define CONFIG_NEED_BL301			1
#define CONFIG_NEED_BL32			1
#define CONFIG_CMD_RSVMEM			1
#define CONFIG_FIP_IMG_SUPPORT			1
#define CONFIG_BOOTDELAY			1
#define CONFIG_SYS_LONGHELP			1
#define CONFIG_CMD_MISC				1
#define CONFIG_CMD_ITEST			1
#define CONFIG_CMD_CPU_TEMP			1
#define CONFIG_SYS_MEM_TOP_HIDE			0x08000000 /* hide 128MB for kernel reserve */
#define CONFIG_CMD_LOADB			1
#define CONFIG_SUPPORT_RAW_INITRD		1

/* debug mode defines */
//#define CONFIG_DEBUG_MODE			1
#ifdef CONFIG_DEBUG_MODE
#define CONFIG_DDR_CLK_DEBUG			636
#define CONFIG_CPU_CLK_DEBUG			600
#endif

/* support secure boot */
#define CONFIG_AML_SECURE_UBOOT			1
#ifdef CONFIG_AML_SECURE_UBOOT
/* unify build for generate encrypted bootloader "u-boot.bin.encrypt" */
#define CONFIG_AML_CRYPTO_UBOOT			1
/*
 * unify build for generate encrypted kernel image
 * SRC : "board/amlogic/(board)/boot.img"
 * DST : "fip/boot.img.encrypt"
 */
//#define CONFIG_AML_CRYPTO_IMG			1
#endif

/* build with uboot auto test */
//#define CONFIG_AML_UBOOT_AUTO_TEST		1

/* board customer ID */
//#define CONFIG_CUSTOMER_ID			0x6472616F624C4D41

#if defined(CONFIG_CUSTOMER_ID)
  #undef CONFIG_AML_CUSTOMER_ID
  #define CONFIG_AML_CUSTOMER_ID		CONFIG_CUSTOMER_ID
#endif

/* Choose One of Ethernet Type */
#undef CONFIG_ETHERNET_NONE
#undef ETHERNET_INTERNAL_PHY
#define ETHERNET_EXTERNAL_PHY

/* u-boot memory test */
#define CONFIG_CMD_MEMTEST
#ifdef CONFIG_CMD_MEMTEST
#define CONFIG_SYS_MEMTEST_START		(128 << 20)	/* 128MB */
#define CONFIG_SYS_MEMTEST_END			(2048 << 20)	/* 2GB */
#endif

#define CONFIG_CMD_SOURCE			1

#define CONFIG_BOARD_EARLY_INIT_F		1

#define CONFIG_ZERO_BOOTDELAY_CHECK	/* check for keypress on bootdelay==0 */
#endif
