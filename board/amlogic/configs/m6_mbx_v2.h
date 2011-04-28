#ifndef __CONFIG_M6_MBX_V2_H__
#define __CONFIG_M6_MBX_V2_H__

#define CONFIG_AML_MESON_6 1
#define CONFIG_MACH_MESON6_MBX
//#define CONFIG_MESON_ARM_GIC_FIQ

//#define TEST_UBOOT_BOOT_SPEND_TIME

/*
 *  write to efuse/nand when usb_burning
 *  WRITE_TO_EFUSE_ENABLE and WRITE_TO_NAND_ENABLE should not be both existed
 */
#define CONFIG_AML_MESON6
//#define WRITE_TO_EFUSE_ENABLE
#define WRITE_TO_NAND_ENABLE

#define CONFIG_IR_REMOTE

#define CONFIG_SECURITYKEY
#ifdef CONFIG_SECURITYKEY
#define CONFIG_AML_NAND_KEY
#define CONFIG_AML_EMMC_KEY	1
#endif
/* Pass open firmware flat tree */
#define CONFIG_OF_LIBFDT    1
#define CONFIG_SYS_BOOTMAPSZ   PHYS_MEMORY_SIZE       /* Initial Memory map for Linux */

//#define CONFIG_SWITCH_BOOT_MODE 1
#define CONFIG_HDCP_PREFETCH 1

#if defined(WRITE_TO_EFUSE_ENABLE) && defined(WRITE_TO_NAND_ENABLE)
#error You should only select one of WRITE_TO_EFUSE_ENABLE and WRITE_TO_NAND_ENABLE
#endif

#define CONFIG_ACS
#ifdef CONFIG_ACS
/*pass memory size, spl->uboot, can not use 0xD9000000 - 0xD900C000, or secure boot will fail*/
#define CONFIG_DDR_SIZE_IND_ADDR 0xd901ff7c
#endif

// cart type of each port
#define PORT_A_CARD_TYPE            CARD_TYPE_UNKNOWN
#define PORT_B_CARD_TYPE            CARD_TYPE_UNKNOWN
#define PORT_C_CARD_TYPE            CARD_TYPE_UNKNOWN // CARD_TYPE_MMC/CARD_TYPE_SD

//UART Sectoion
#define CONFIG_CONS_INDEX   2

//support "boot,bootd"
//#define CONFIG_CMD_BOOTD 1
//#define CONFIG_AML_I2C      1

#define HAS_AO_MODULE
#define CONFIG_AML_I2C	//add by Elvis Yu
//#define CONFIG_AW_AXP20
#define CONFIG_PWM_DEFAULT_VCCK_VOLTAGE
#define CONFIG_VCCK_VOLTAGE                     1320        // 1.32v for default vcck voltage

//Enable storage devices
//#ifndef CONFIG_JERRY_NAND_TEST
#define CONFIG_NEXT_NAND 

#ifdef CONFIG_NEXT_NAND
#define CONFIG_CMD_IMGREAD  1   //read the actual size of boot.img/recovery.img/logo.img use cmd 'imgread'
#define CONFIG_AML_V2_USBTOOL 1
#endif//#ifdef CONFIG_NEXT_NAND

#if CONFIG_AML_V2_USBTOOL
#define CONFIG_SHA1
#define CONFIG_AUTO_START_SD_BURNING     1//1 then auto detect whether or not jump into sdc_burning when boot from external mmc card 
#define CONFIG_POWER_KEY_NOT_SUPPORTED_FOR_BURN 1//power key and poweroff can't work
#endif// #if CONFIG_AML_V2_USBTOOL

//#define CONFIG_UNIFY_KEY_MANAGE 1
//#define CONFIG_CMD_PWM  1

#define CONFIG_CMD_NAND  1
//#endif
#define CONFIG_CMD_SF    1

#if defined(CONFIG_CMD_SF)
#define SPI_WRITE_PROTECT  1
#define CONFIG_CMD_MEMORY  1
#endif /*CONFIG_CMD_SF*/

//Amlogic SARADC support
#define CONFIG_SARADC 1
#define CONFIG_CMD_SARADC
#define CONFIG_EFUSE 1
//#define CONFIG_MACHID_CHECK 1

#define CONFIG_L2_OFF			1
//#define CONFIG_ICACHE_OFF	1
//#define CONFIG_DCACHE_OFF	1


#define CONFIG_CMD_NET   1

#if defined(CONFIG_CMD_NET)
#define CONFIG_AML_ETHERNET 1
#define CONFIG_NET_MULTI 1
#define CONFIG_CMD_PING 1
#define CONFIG_CMD_DHCP 1
#define CONFIG_CMD_RARP 1

//#define CONFIG_NET_RGMII
#define CONFIG_NET_RMII_CLK_EXTERNAL //use external 50MHz clock source

#define CONFIG_AML_ETHERNET    1                   /*to link /driver/net/aml_ethernet.c*/
#define CONFIG_HOSTNAME        arm_m6
#define CONFIG_ETHADDR         00:15:18:01:81:31   /* Ethernet address */
#define CONFIG_IPADDR          10.18.9.97          /* Our ip address */
#define CONFIG_GATEWAYIP       10.18.9.1           /* Our getway ip address */
#define CONFIG_SERVERIP        10.18.9.113         /* Tftp server ip address */
#define CONFIG_NETMASK         255.255.255.0
#endif /* (CONFIG_CMD_NET) */


#define CONFIG_SDIO_B1   1
#define CONFIG_SDIO_A    1
#define CONFIG_SDIO_B    1
#define CONFIG_SDIO_C    1
#define CONFIG_ENABLE_EXT_DEVICE_RETRY 1


#define CONFIG_MMU                    1
#define CONFIG_PAGE_OFFSET 	0xc0000000
#define CONFIG_SYS_LONGHELP	1

/* USB
 * Enable CONFIG_MUSB_HCD for Host functionalities MSC, keyboard
 * Enable CONFIG_MUSB_UDD for Device functionalities.
 */
/* #define CONFIG_MUSB_UDC		1 */
#define CONFIG_M6_USBPORT_BASE	0xC90C0000
#define CONFIG_M6_USBPORT_BASE_A	0xC9040000
#define CONFIG_USB_STORAGE      1
#define CONFIG_USB_DWC_OTG_HCD  1
#define CONFIG_USB_DWC_OTG_294	1
#define CONFIG_CMD_USB 1

//#define CONFIG_USB_ETHER
#ifdef CONFIG_USB_ETHER
#define IO_USB_A_BASE			0xc9040000
#define CONFIG_USBPORT_BASE IO_USB_A_BASE
#define CONFIG_SYS_CACHELINE_SIZE       64
#define CONFIG_USB_ETH_RNDIS
#define CONFIG_USB_GADGET_S3C_UDC_OTG
#define CONFIG_USB_GADGET_DUALSPEED
#endif



#define CONFIG_UCL 1
#define CONFIG_SELF_COMPRESS

//#define CONFIG_IMPROVE_UCL_DEC   1

#ifdef CONFIG_IMPROVE_UCL_DEC
#define UCL_DEC_EN_IDCACHE        1
#define UCL_DEC_EN_IDCACHE_FINE_TUNE  1
#endif


#define CONFIG_CMD_AUTOSCRIPT
//#define CONFIG_CMD_AML 1
#define CONFIG_CMD_IMGPACK 1
#define CONFIG_CMD_REBOOT 1
#define CONFIG_CMD_MATH 1

#define CONFIG_ANDROID_IMG 1

/* Environment information */
#define CONFIG_BOOTDELAY	1
#define CONFIG_BOOTFILE		boot.img


#define CONFIG_EXTRA_ENV_SETTINGS \
	"mmc_logo_offset=0x24000\0" \
	"mmc_boot_offset=0x44000\0" \
	"mmc_recovery_offset=0x34000\0" \
	"mmc_lk_size=0x4000\0" \
	"loadaddr=0x82000000\0" \
	"testaddr=0x82400000\0" \
	"loadaddr_misc=0x83000000\0" \
	"usbtty=cdc_acm\0" \
	"console=ttyS2,115200n8\0" \
	"mmcargs=setenv bootargs console=${console} " \
	"boardname=m6_mbx\0" \
	"chipname=8726m6\0" \
	"machid=4e27\0" \
	"video_dev=tvout\0" \
	"display_width=1920\0" \
	"display_height=1080\0" \
	"display_bpp=24\0" \
	"display_color_format_index=16\0" \
	"display_layer=osd1\0" \
	"display_color_fg=0xffff\0" \
	"display_color_bg=0\0" \
	"fb_addr=0x85900000\0" \
	"sleep_threshold=20\0" \
	"upgrade_step=0\0" \
	"batlow_threshold=10\0" \
	"batfull_threshold=98\0" \
	"outputmode=1080p\0" \
	"outputtemp=1080p\0" \
	"hdmimode=1080p\0" \
	"cvbsmode=576cvbs\0" \
	"cvbsenable=false\0" \
	"vdacswitchmode=cvbs\0" \
    "usb_burning=update 1000\0" \
	"sdcburncfg=aml_sdc_burn.ini\0"\
	"firstboot=1\0" \
	"store=0\0"\
	"preboot="\
        "run upgrade_check; "\
        "get_rebootmode; clear_rebootmode; echo reboot_mode=${reboot_mode}; "\
        "run nand_key_burning; "\
        "run updatekey_or_not; run irremote_update; run switch_bootmode\0" \
	"mbr_write=if test ${upgrade_step} != 2; then mmcinfo 1; mmc read 1 82000000 0 1; mw.l 820001fc 0 1; mmc write 1 82000000 0 1;fi;\0" \
	"upgrade_check="\
        "if itest ${upgrade_step} == 1; then defenv; setenv upgrade_step 2; save; fi; "\
        "if itest ${upgrade_step} == 3; then save; run update; fi;\0" \
	"updatekey_or_not=saradc open 4;if saradc get_in_range 0x0 0x50 ;then msleep 500;if saradc get_in_range 0x0 0x50; then run update; fi; fi\0" \
	"irremote_update=if irkey 0x41beb14e 500000 ;then run update; fi\0" \
	"nand_key_burning=saradc open 4;if saradc get_in_range 0x164 0x1b4 ;then msleep 500;if saradc get_in_range 0x164 0x1b4; then run usb_burning; fi; fi\0" \
	"cvbscheck=setenv outputtemp ${outputmode};if test ${outputmode} = 480i; then if test ${cvbsenable} = true; then setenv outputtemp 480cvbs;fi;fi; if test ${outputmode} = 576i; then if test ${cvbsenable} = true; then setenv outputtemp 576cvbs;fi;fi\0" \
	"nandargs=run cvbscheck; "\
            "imgread res logo ${loadaddr_misc};unpackimg ${loadaddr_misc}; cp ${bootup_offset} 0x85100000 ${bootup_size}; "\
            "setenv bootargs root=/dev/cardblksd2 rw rootfstype=ext3 rootwait init=/init console=ttyS0,115200n8 logo=osd1,0x85100000,${outputtemp},full androidboot.resolution=${outputmode} hdmimode=${hdmimode} cvbsmode=${cvbsmode} hlt vmalloc=256m mem=1024m a9_clk_max=1512000000 vdachwswitch=${vdacswitchmode} hdmitx=${cecconfig}\0"\
	"switch_bootmode="\
        "if test ${reboot_mode} = factory_reset; then run recovery; fi;"\
        "if test ${reboot_mode} = usb_burning; then run usb_burning; fi; "\
        "if test ${reboot_mode} = update; then run update; fi\0" \
	"nandboot="\
        "echo Booting ...;"\
        "run nandargs;"\
        "setenv bootargs ${initargs} androidboot.firstboot=${firstboot}; "\
        "imgread kernel boot ${loadaddr};"\
        "hdcp prefetch nand;"\
        "bootm;run recovery\0" \
	"recovery="\
        "echo enter recovery;"\
        "run nandargs;"\
        "if mmcinfo; then "\
            "if fatload mmc 0 ${loadaddr} recovery.img; then bootm;fi;"\
        "fi; "\
        "imgread kernel recovery ${loadaddr}; bootm\0" \
	"initargs=root=/dev/cardblksd2 rw rootfstype=ext3 rootwait init=/init console=ttyS0,115200n8 nohlt no_console_suspend vmalloc=256m mem=1024m logo=osd1,0x85100000,1080p\0" \
	"storage=null\0" \
	"factoryreset_wipe_data="\
        "echo ---wipe_data=${wipe_data}; "\
        "imgread kernel recovery ${loadaddr}; bootm; "\
       "\0" \
	"usbnet_devaddr=00:15:18:01:81:31;\0" \
	"usbnet_hostddr=00:15:18:01:a1:3b;\0" \
	"cdc_connect_timeout=9999999999;\0" \
    "update="\
        "echo update...; run usb_burning; "\
        "if mmcinfo; then "\
            "if fatexist mmc 0 ${sdcburncfg}; then "\
                "sdc_burn ${sdcburncfg}; "\
            "else "\
                "if fatload mmc 0 ${loadaddr} aml_autoscript; then autoscr ${loadaddr}; fi;"\
                "run recovery;"\
            "fi;"\
        "else "\
            "run recovery;"\
        "fi;\0"\

#define CONFIG_BOOTCOMMAND  "run nandboot"

#define CONFIG_AUTO_COMPLETE	1
#define CONFIG_ENV_SIZE		(64 * 1024)

#define CONFIG_STORE_COMPATIBLE

// SPI
#define CONFIG_ENV_OVERWRITE
#define CONFIG_CMD_SAVEENV
#define CONFIG_ENV_SECT_SIZE		0x1000
#define CONFIG_ENV_IN_SPI_OFFSET	0x100000

// NAND
#define CONFIG_ENV_IN_NAND_OFFSET	0x400000
#define CONFIG_ENV_BLOCK_NUM		2

// eMMC
#define CONFIG_SYS_MMC_ENV_DEV		1
#define CONFIG_ENV_IN_EMMC_OFFSET	0x80000

#define CONFIG_SYS_GBL_DATA_SIZE	128	/* bytes reserved for */
						/* initial data */

#define BOARD_LATE_INIT
#define CONFIG_PREBOOT
#define CONFIG_VIDEO_AML
/* config TV output */
#define CONFIG_VIDEO_AMLTVOUT
#define CONFIG_AML_HDMI_TX 1
/* config LCD output */
//#define CONFIG_VIDEO_AMLLCD
//#define CONFIG_VIDEO_AMLLCD_M3
#define CONFIG_CMD_BMP
#define LCD_BPP LCD_COLOR24
#define TV_BPP LCD_BPP
#define LCD_TEST_PATTERN
#ifndef CONFIG_SYS_CONSOLE_IS_IN_ENV
#define CONFIG_SYS_CONSOLE_IS_IN_ENV
#endif
/*end config LCD output*/

/*POST support*/
/*
#define CONFIG_POST (CONFIG_SYS_POST_CACHE	| CONFIG_SYS_POST_BSPEC1 |	\
										CONFIG_SYS_POST_RTC | CONFIG_SYS_POST_ADC | \
										CONFIG_SYS_POST_PLL)
*/
//CONFIG_SYS_POST_MEMORY

#undef CONFIG_POST
#ifdef CONFIG_POST
#define CONFIG_POST_AML
#define CONFIG_POST_ALT_LIST
#define CONFIG_SYS_CONSOLE_IS_IN_ENV  /* Otherwise it catches logbuffer as output */
#define CONFIG_LOGBUFFER
#define CONFIG_CMD_DIAG

#define SYSTEST_INFO_L1 1
#define SYSTEST_INFO_L2 2
#define SYSTEST_INFO_L3 3

#define CONFIG_POST_BSPEC1 {    \
	"L2CACHE test", \
	"l2cache", \
	"This test verifies the L2 cache operation.", \
	POST_RAM | POST_MANUAL,   \
	&l2cache_post_test,		\
	NULL,		\
	NULL,		\
	CONFIG_SYS_POST_BSPEC1 	\
	}

#define CONFIG_POST_BSPEC2 {  \
	"BIST test", \
	"bist", \
	"This test checks bist test", \
	POST_RAM | POST_MANUAL, \
	&bist_post_test, \
	NULL, \
	NULL, \
	CONFIG_SYS_POST_BSPEC1  \
	}
#endif   /*end ifdef CONFIG_POST*/

/*-----------------------------------------------------------------------
 * Physical Memory Map
 */
//Please just define M6 DDR clock here only
//current DDR clock range (300~600)MHz
#define M6_DDR_CLK (468)

#define CONFIG_DDR_LOW_POWER


//#define DDR3_9_9_9
#define DDR3_7_7_7
//above setting must be set for ddr_set __ddr_setting in file
//board/amlogic/m6_ref_v1/firmware/timming.c

//note: please DO NOT remove following check code
#if !defined(DDR3_9_9_9) && !defined(DDR3_7_7_7)
	#error "Please set DDR3 property first in file m6_ref_v1.h\n"
#endif

#define M6_DDR3_1GB
//#define M6_DDR3_512M
//above setting will affect following:
//board/amlogic/m6_ref_v1/firmware/timming.c
//arch/arm/cpu/aml_meson/m6/mmutable.s

//note: please DO NOT remove following check code
#if !defined(M6_DDR3_1GB) && !defined(M6_DDR3_512M)
	#error "Please set DDR3 capacity first in file m6_ref_v1.h\n"
#endif


#define CONFIG_NR_DRAM_BANKS    1   /* CS1 may or may not be populated */

#define PHYS_MEMORY_START    0x80000000 // from 500000
#if defined(M6_DDR3_1GB)
	#define PHYS_MEMORY_SIZE     0x40000000 // 1GB
#elif defined(M6_DDR3_512M)
	#define PHYS_MEMORY_SIZE     0x20000000 // 512M
#else
	#error "Please define DDR3 memory capacity in file m6_ref_v1.h\n"
#endif

#define CONFIG_SYS_MEMTEST_START    0x80000000  /* memtest works on */
#define CONFIG_SYS_MEMTEST_END      0x07000000  /* 0 ... 120 MB in DRAM */
#define CONFIG_ENABLE_MEM_DEVICE_TEST 1
#define CONFIG_NR_DRAM_BANKS	1	/* CS1 may or may not be populated */

#define DDR_DETECT168_NAND_D7
//////////////////////////////////////////////////////////////////////////


//M6 security boot enable
//#define CONFIG_M6_SECU_BOOT		 1
//M6 2-RSA signature enable, enable CONFIG_M6_SECU_BOOT
//first before use this feature
//#define CONFIG_M6_SECU_BOOT_2RSA   1

//M6 Auth-key build to uboot
//#define CONFIG_M6_SECU_AUTH_KEY 1


//enable CONFIG_M6_SECU_BOOT_2K must enable CONFIG_M6_SECU_BOOT first
#if defined(CONFIG_M6_SECU_BOOT_2K)
	#if !defined(CONFIG_M6_SECU_BOOT)
		#define CONFIG_M6_SECU_BOOT 1
	#endif //!defined(CONFIG_M6_SECU_BOOT)
#endif //defined(CONFIG_M6_SECU_BOOT_2K)


//M6 L1 cache enable for uboot decompress speed up
#define CONFIG_AML_SPL_L1_CACHE_ON	1

//////////////////////////////////////////////////////////////////////////

/* Pass open firmware flat tree*/
#define CONFIG_OF_LIBFDT	1
#define CONFIG_SYS_BOOTMAPSZ   PHYS_MEMORY_SIZE       /* Initial Memory map for Linux */
#define CONFIG_ANDROID_IMG	1

/*-----------------------------------------------------------------------
 * power down
 */
//#define CONFIG_CMD_RUNARC 1 /* runarc */
//#define CONFIG_CMD_SUSPEND 1
#define CONFIG_AML_SUSPEND 1
#define CONFIG_CEC_WAKE_UP 1

/*
 * Secure OS
 */
#ifdef CONFIG_MESON_TRUSTZONE

#define CONFIG_MESON_SECUREARGS  1
#define CONFIG_JOIN_UBOOT_SECUREOS 1
#define SECUREOS_KEY_BASE_ADDR  0x85100000
#define SECURE_OS_DECOMPRESS_ADDR 0x85200000
#define CONFIG_SECURE_STORAGE_BURNED

#ifdef CONFIG_SECURE_STORAGE_BURNED
#define CONFIG_MESON_STORAGE_BURN 1
#define CONFIG_MESON_STORAGE_DEBUG
#define CONFIG_SECURESTORAGEKEY
#define CONFIG_RANDOM_GENERATE
#define CONFIG_CMD_SECURESTORE
#define CONFIG_CMD_RANDOM
/* secure storage support both spi and emmc */
#define CONFIG_SECURE_MMC
#define CONFIG_SPI_NOR_SECURE_STORAGE
#endif /* CONFIG_SECURE_STORAGE_BURNED */

#endif //CONFIG_MESON_TRUSTZONE

#endif //__CONFIG_M6_MBX_V2_H__
