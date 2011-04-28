#ifndef __CONFIG_M6_REF_V1_H__
#define __CONFIG_M6_REF_V1_H__

#define M6_REF_V1_20120201 1
#define CONFIG_AML_MESON_6 1
#define CONFIG_MACH_MESON6_REF

//UART Sectoion
#define CONFIG_CONS_INDEX   2

//support "boot,bootd"
//#define CONFIG_CMD_BOOTD 1
//#define CONFIG_AML_I2C      1

#define HAS_AO_MODULE
#define CONFIG_AML_I2C	//add by Elvis Yu
#define CONFIG_PLATFORM_HAS_PMU
#define CONFIG_AW_AXP20
#ifdef CONFIG_AW_AXP20
#define CONFIG_UBOOT_BATTERY_PARAMETER_TEST
#define CONFIG_UBOOT_BATTERY_PARAMETERS 
/*
 * under some cases default voltage of PMU output is 
 * not suitable for application, so you should take care
 * of the following macros which defined initial voltage
 * of each power domain when in SPL stage of uboot.
 */
#define CONFIG_POWER_SPL                            // init power for all domians, must have
#define CONFIG_CONST_PWM_FOR_DCDC                   // DCDC2 ~ 3 work for PWM mode
#define CONFIG_DISABLE_LDO3_UNDER_VOLTAGE_PROTECT   // disable LDO3 uv protect
#define CONFIG_VCCK_VOLTAGE             1320        // default voltage for VCCK
#define CONFIG_VDDAO_VOLTAGE            1200        // VDDAO voltage when boot, DCDC3
#define CONFIG_DDR_VOLTAGE              1500        // DDR voltage when boot, DCDC2
#define CONFIG_VDDIO_AO                 3000        // VDDIO_AO voltage, ldo2
#define CONFIG_AVDD2V5                  2500        // AVDD2.5V voltage, ldo3
#define CONFIG_AVDD3V3                  3300        // AVDD3.3V voltage, ldo4

#define CONFIG_DCDC_PFM_PMW_SWITCH      1 
#endif /* CONFIG_AW_AXP20 */

//Enable storage devices
//#ifndef CONFIG_JERRY_NAND_TEST
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

//#define CONFIG_CMD_NET   1

#if defined(CONFIG_CMD_NET)
#define CONFIG_AML_ETHERNET 1
#define CONFIG_NET_MULTI 1
#define CONFIG_CMD_PING 1
#define CONFIG_CMD_DHCP 1
#define CONFIG_CMD_RARP 1

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

#define CONFIG_UCL 1
#define CONFIG_SELF_COMPRESS

#define CONFIG_CMD_AUTOSCRIPT
#define CONFIG_CMD_AML 1
#define CONFIG_CMD_IMGPACK 1
#define CONFIG_CMD_REBOOT 1
#define CONFIG_CMD_MATH 1

/* Environment information */
#define CONFIG_BOOTDELAY	1
#define CONFIG_BOOTFILE		uImage

#define CONFIG_EXTRA_ENV_SETTINGS \
	"loadaddr=0x82000000\0" \
	"testaddr=0x82400000\0" \
	"loadaddr_misc=0x83000000\0" \
	"dtbaddr=0x83000000\0" \
	"usbtty=cdc_acm\0" \
	"console=ttyS2,115200n8\0" \
	"mmcargs=setenv bootargs console=${console} " \
	"boardname=m6_ref\0" \
	"chipname=8726m6\0" \
	"machid=F82\0" \
	"upgrade_step=0\0" \
	"video_dev=panel\0" \
	"display_width=800\0" \
	"display_height=1280\0" \
	"display_bpp=16\0" \
	"display_color_format_index=16\0" \
	"display_layer=osd2\0" \
	"display_color_fg=0xffff\0" \
	"display_color_bg=0\0" \
	"fb_addr=0x85100000\0" \
	"sleep_threshold=20\0" \
	"batlow_threshold=10\0" \
	"batfull_threshold=100\0" \
	"preloaddtb=store read boot ${loadaddr} 0 600000;dtbload ${loadaddr}\0" \
	"bootargs=init=/init console=ttyS0,115200n8 nohlt no_console_suspend vmalloc=256m mem=1024m logo=osd1,loaded,panel,debug hdmitx=vdacoff,powermode1,unplug_powerdown\0" \
	"preboot=run upgrade_check; run batlow_or_not; setenv sleep_count 0; saradc open 4;run updatekey_or_not; run switch_bootmode\0" \
	"upgrade_check=if itest ${upgrade_step} == 0; then defenv; save; run update; else if itest ${upgrade_step} == 1; then defenv; setenv upgrade_step 2; save; fi; fi\0" \
	"switch_bootmode=get_rebootmode; clear_rebootmode; echo reboot_mode=${reboot_mode}; if test ${reboot_mode} = normal; then run prepare; bmp display ${poweron_offset}; else if test ${reboot_mode} = factory_reset; then run recovery; else if test ${reboot_mode} = update; then run update; else run charging_or_not; fi; fi; fi\0" \
	"prepare=nand read logo ${loadaddr_misc} 0 40000; unpackimg ${loadaddr_misc}; video open; video clear; video dev bl_on\0" \
	"update=run prepare; bmp display ${bootup_offset}; if mmcinfo; then if fatload mmc 0 ${loadaddr} aml_autoscript; then autoscr ${loadaddr}; fi; if fatload mmc 0 ${loadaddr} uImage_recovery; then bootm; fi; fi; nand read recovery ${loadaddr} 0 400000; bootm\0" \
	"recovery=run prepare; bmp display ${bootup_offset}; if nand read recovery ${loadaddr} 0 400000; then bootm; else echo no uImage_recovery in NAND; fi\0" \
	"charging_or_not=if ac_online; then run prepare; run charging; else if getkey; then run prepare; bmp display ${poweron_offset}; run bootcmd; else poweroff; fi; fi\0" \
	"charging=video clear; run display_loop\0" \
	"display_loop=while itest 1 == 1; do get_batcap; if itest ${battery_cap} >= ${batfull_threshold}; then bmp display ${batteryfull_offset}; run custom_delay; else bmp display ${battery0_offset}; run custom_delay; bmp display ${battery1_offset}; run custom_delay; bmp display ${battery2_offset}; run custom_delay; bmp display ${battery3_offset}; run custom_delay; fi; done\0" \
	"custom_delay=setenv msleep_count 0; while itest ${msleep_count} < 800; do run aconline_or_not; run updatekey_or_not; run powerkey_or_not; msleep 1; calc ${msleep_count} + 1 msleep_count; done; run sleep_or_not\0" \
	"sleep_or_not=if itest ${sleep_count} > ${sleep_threshold}; then run into_sleep; setenv sleep_count 0; else calc ${sleep_count} + 1 sleep_count; fi\0" \
	"into_sleep=setenv sleep_enable 1; video dev bl_off; while itest ${sleep_enable} == 1; do run sleep_get_key; done; video dev bl_on\0" \
	"sleep_get_key=run aconline_or_not;if getkey; then msleep 100; if getkey; then setenv sleep_enable 0; fi; fi; if saradc get_in_range 0x0 0x380; then msleep 100; if saradc get_in_range 0x0 0x380; then setenv sleep_enable 0; fi; fi\0" \
	"powerkey_or_not=if getkey; then msleep 500; if getkey; then run bootcmd; fi; fi\0" \
	"updatekey_or_not=if saradc get_in_range 0x50 0xf0; then msleep 500; if getkey; then if saradc get_in_range 0x50 0xf0; then run update; fi; fi; fi\0" \
	"aconline_or_not=if ac_online; then; else poweroff; fi\0" \
	"batlow_or_not=if ac_online; then; else get_batcap; if itest ${battery_cap} < ${batlow_threshold}; then run prepare; run batlow_warning; poweroff; fi; fi\0" \
	"batlow_warning=bmp display ${batterylow_offset}; msleep 500; bmp display ${batterylow_offset}; msleep 500; bmp display ${batterylow_offset}; msleep 500; bmp display ${batterylow_offset}; msleep 500; bmp display ${batterylow_offset}; msleep 1000\0" \


#define CONFIG_BOOTCOMMAND  "bmp display ${bootup_offset}; nand read boot ${loadaddr} 0 400000; bootm"


#define CONFIG_AUTO_COMPLETE	1

//#define CONFIG_SPI_BOOT 1
//#define CONFIG_MMC_BOOT
#ifndef CONFIG_JERRY_NAND_TEST
#define CONFIG_NAND_BOOT 1
#endif

//#ifdef CONFIG_NAND_BOOT
//#define CONFIG_AMLROM_NANDBOOT 1
//#endif

#define CONFIG_ENV_SIZE         0x8000

#ifdef CONFIG_SPI_BOOT
	#define CONFIG_ENV_OVERWRITE
	#define CONFIG_ENV_IS_IN_SPI_FLASH
	#define CONFIG_CMD_SAVEENV

	//for CONFIG_SPI_FLASH_SPANSION 64KB sector size
	//#ifdef CONFIG_SPI_FLASH_SPANSION
	 #define CONFIG_ENV_SECT_SIZE		0x10000
	//#else
	//	#define CONFIG_ENV_SECT_SIZE        0x1000
	//#endif

	#define CONFIG_ENV_OFFSET           0x1f0000
#elif defined CONFIG_NAND_BOOT
	#define CONFIG_ENV_IS_IN_AML_NAND
	#define CONFIG_CMD_SAVEENV
	#define CONFIG_ENV_OVERWRITE
	#define CONFIG_ENV_OFFSET       0x400000
	#define CONFIG_ENV_BLOCK_NUM    2
#elif defined CONFIG_MMC_BOOT
	#define CONFIG_ENV_IS_IN_MMC
	#define CONFIG_CMD_SAVEENV
    #define CONFIG_SYS_MMC_ENV_DEV        0
	#define CONFIG_ENV_OFFSET       0x1000000
#else
#define CONFIG_ENV_IS_NOWHERE    1
#endif

#define BOARD_LATE_INIT
#define CONFIG_PREBOOT
/* config LCD output */
#define CONFIG_VIDEO_AML
#define CONFIG_VIDEO_AMLLCD
//#define CONFIG_VIDEO_AMLLCD_M3
#define CONFIG_CMD_BMP
#define LCD_BPP LCD_COLOR16
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
#define M6_DDR_CLK (504)

//#define CONFIG_DDR_LOW_POWER


//#define DDR3_9_9_9
#define DDR3_7_7_7
//above setting must be set for ddr_set __ddr_setting in file
//board/amlogic/m6_ref_v1/firmware/timming.c

//note: please DO NOT remove following check code
#if !defined(DDR3_9_9_9) && !defined(DDR3_7_7_7)
	#error "Please set DDR3 property first in file m6_ref_v1.h\n"
#endif

#define M6_DDR3_1GB
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


/*-----------------------------------------------------------------------
 * power down
 */
//#define CONFIG_CMD_RUNARC 1 /* runarc */
#define CONFIG_AML_SUSPEND 1


#endif //__CONFIG_M6_REF_V1_H__
