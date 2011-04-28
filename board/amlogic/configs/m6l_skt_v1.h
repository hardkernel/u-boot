#ifndef __CONFIG_M6_SKT_V1_H__
#define __CONFIG_M6_SKT_V1_H__

#define M6_SKT_V1_20120201 1
#define CONFIG_MACH_MESON6_SKT  // generate M6 SKT machid number

//ddrtest and d2pll command support
#define CONFIG_CMD_DDR_TEST	1	//ddrtest & d2pll

//UART Sectoion
#define CONFIG_CONS_INDEX   2

//support "boot,bootd"
//#define CONFIG_CMD_BOOTD 1
//#define CONFIG_AML_I2C      1


//Enable storage devices
//#ifndef CONFIG_JERRY_NAND_TEST
#define CONFIG_CMD_NAND  1
//#endif
#define CONFIG_CMD_SF    1

#if defined(CONFIG_CMD_SF)
#define CONFIG_AML_MESON_6 1
#define SPI_WRITE_PROTECT  1
#define CONFIG_CMD_MEMORY  1
#endif /*CONFIG_CMD_SF*/

//Amlogic SARADC support
#define CONFIG_SARADC 1
#define CONFIG_EFUSE 1
//#define CONFIG_MACHID_CHECK 1

#define CONFIG_L2_OFF			1

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


#define CONFIG_MEMSIZE	512	/*unit is MB*/ 
#if(CONFIG_MEMSIZE == 512)
#define BOARD_INFO_ENV  " mem=512M"
#define UBOOTPATH		"u-boot-512M-UartB.bin"
#else
#define BOARD_INFO_ENV ""
#define UBOOTPATH		"u-boot-aml.bin"
#endif

#define CONFIG_UCL 1
#define CONFIG_SELF_COMPRESS 
#define CONFIG_PREBOOT "mw da004004 80000510;mw c81000014 4000;mw c1109900 0"
//#define CONFIG_UBI_SUPPORT
#ifdef	CONFIG_UBI_SUPPORT
#define CONFIG_CMD_UBI
#define CONFIG_CMD_UBIFS
#define CONFIG_RBTREE
#define MTDIDS_DEFAULT		"nand1=nandflash1\0"
#define MTDPARTS_DEFAULT	"mtdparts=nandflash1:256m@168m(system)\0"						
#endif

/* Environment information */
#define CONFIG_BOOTDELAY	3
#define CONFIG_BOOTFILE		uImage

#define CONFIG_EXTRA_ENV_SETTINGS \
	"loadaddr=0x82000000\0" \
	"testaddr=0x82400000\0" \
	"usbtty=cdc_acm\0" \
	"console=ttyS2,115200n8\0" \
	"mmcargs=setenv bootargs console=${console} " \
	"boardname=m1_mbox\0" \
	"chipname=8726m\0" \
	"machid=F81\0" \
	"bootargs=init=/init console=ttyS0,115200n8 hlt no_console_suspend vmalloc=256m mem=1024m hdmitx=vdacoff,powermode1,unplug_powerdown\0" \
	"partnum=2\0" \
	"p0start=1000000\0" \
	"p0size=400000\0" \
	"p0path=uImage\0" \
	"p1start=1400000\0" \
	"p1size=8000000\0" \
	"p1path=android.rootfs\0" \
	"bootstart=0\0" \
	"bootsize=60000\0" \
	"bootpath=u-boot-512M-UartB.bin\0" \
	"normalstart=1000000\0" \
	"normalsize=400000\0" \

#define CONFIG_BOOTCOMMAND  "mmcinfo;fatload mmc 0 82000000 boot.img;bootm"

#define CONFIG_AUTO_COMPLETE	1

#define CONFIG_SPI_BOOT 1
//#define CONFIG_MMC_BOOT
#ifndef CONFIG_JERRY_NAND_TEST
	#define CONFIG_NAND_BOOT 1
#endif

//#ifdef CONFIG_NAND_BOOT
//#define CONFIG_AMLROM_NANDBOOT 1
//#endif 

#define CONFIG_ENV_SIZE         (64*1024)

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
//#define M6_DDR_CLK (480)
//#define M6_DDR_CLK (504)   /*504M m6l socket board without socket, in other words, chip was woald board direct*/
#define M6_DDR_CLK   (408)   /*408M m6l socket board with chip socket*/

//#define CONFIG_DDR_LOW_POWER 1

//#define DDR3_9_9_9
#define DDR3_7_7_7
//above setting must be set for ddr_set __ddr_setting in file
//board/amlogic/m6_skt_v1/firmware/timming.c 

//note: please DO NOT remove following check code
#if !defined(DDR3_9_9_9) && !defined(DDR3_7_7_7)
	#error "Please set DDR3 property first in file m6_skt_v1.h\n"
#endif

#define M6_DDR3_DATABUS_16MODE
#define M6_DDR3_512M
//#define M6_DDR3_1GB
//above setting will affect following:
//board/amlogic/m6_skt_v1/firmware/timming.c
//arch/arm/cpu/aml_meson/m6/mmutable.s

//note: please DO NOT remove following check code
#if !defined(M6_DDR3_1GB) && !defined(M6_DDR3_512M)
	#error "Please set DDR3 capacity first in file m6_skt_v1.h\n"
#endif


#define CONFIG_NR_DRAM_BANKS    1   /* CS1 may or may not be populated */

#define PHYS_MEMORY_START    0x80000000 // from 500000
#if defined(M6_DDR3_1GB)
	#define PHYS_MEMORY_SIZE     0x40000000 // 1GB
#elif defined(M6_DDR3_512M)
	#define PHYS_MEMORY_SIZE     0x20000000 // 512M
#else
	#error "Please define DDR3 memory capacity in file m6_skt_v1.h\n"
#endif

#define CONFIG_SYS_MEMTEST_START    0x80000000  /* memtest works on */      
#define CONFIG_SYS_MEMTEST_END      0x07000000  /* 0 ... 120 MB in DRAM */  
#define CONFIG_ENABLE_MEM_DEVICE_TEST 1
#define CONFIG_NR_DRAM_BANKS	1	/* CS1 may or may not be populated */


//M6 security boot
//#define CONFIG_M6_SECU_BOOT	1

/*-----------------------------------------------------------------------
 * power down
 */
//#define CONFIG_CMD_RUNARC 1 /* runarc */
#define CONFIG_AML_SUSPEND 1

#define CONFIG_ANDROID_IMG 1
/*
* CPU switch test for uboot
*/
//#define CONFIG_M6_TEST_CPU_SWITCH 1

#endif //__CONFIG_M6_SKT_V1_H__
