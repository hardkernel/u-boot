#ifndef __CONFIG_M3_SOCKET_H_
#define __CONFIG_M3_SOCKET_H_

#define M3_SKT_V1_20110622 1

//UART Sectoion
#define CONFIG_CONS_INDEX   2

//support "boot,bootd"
#define CONFIG_CMD_BOOTD 1
//#define CONFIG_SWITCH_BOOT_MODE 1
//#define CONFIG_AML_I2C      1

//Enable storage devices
#ifndef CONFIG_JERRY_NAND_TEST
#define CONFIG_CMD_NAND  1
#endif
#define CONFIG_CMD_SF    1

#if defined(CONFIG_CMD_SF)
#define CONFIG_AML_MESON_3 1
#define SPI_WRITE_PROTECT  1
#define CONFIG_CMD_MEMORY  1
#endif /*CONFIG_CMD_SF*/

//Amlogic SARADC support
#define CONFIG_SARADC 1
#define CONFIG_EFUSE 1

#define CONFIG_L2_OFF			1

#define CONFIG_CMD_NET   1
//#define CONFIG_M3_EXT_CLK 1 //to use external clock


#if defined(CONFIG_CMD_NET)
#define CONFIG_AML_ETHERNET 1
#define CONFIG_NET_MULTI 1
#define CONFIG_CMD_PING 1
#define CONFIG_CMD_DHCP 1
#define CONFIG_CMD_RARP 1

#define CONFIG_AML_ETHERNET    1                   /*to link /driver/net/aml_ethernet.c*/
#define CONFIG_HOSTNAME        arm_m1
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
#define CONFIG_M3_USBPORT_BASE	0xC90C0000
#define CONFIG_USB_STORAGE      1
#define CONFIG_USB_DWC_OTG_HCD  1
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

//#define CONFIG_UBI_SUPPORT
#ifdef	CONFIG_UBI_SUPPORT
#define CONFIG_CMD_UBI
#define CONFIG_CMD_UBIFS
#define CONFIG_RBTREE
#define MTDIDS_DEFAULT		"nand1=nandflash1\0"
#define MTDPARTS_DEFAULT	"mtdparts=nandflash1:256m@168m(system)\0"						
#endif

/* Environment information */
#define CONFIG_BOOTDELAY	1
#define CONFIG_BOOTFILE		uImage

#define CONFIG_EXTRA_ENV_SETTINGS \
	"loadaddr=0x82000000\0" \
	"testaddr=0x82400000\0" \
	"usbtty=cdc_acm\0" \
	"console=ttyS2,115200n8\0" \
	"mmcargs=setenv bootargs console=${console} " \
	"boardname=m1_mbox\0" \
	"chipname=8726m\0" \
	"machid=B8E\0" \
	"bootargs=root=/dev/cardblksd2 rw rootfstype=ext2 rootwait init=/init console=ttyS0,115200n8 nohlt a9_clk=600M clk81=200M mem=512m\0" \
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

#define CONFIG_BOOTCOMMAND  "mmcinfo;fatload mmc 0:1 82000000 uimage-m3;bootm"

#define CONFIG_AUTO_COMPLETE	1

//#define CONFIG_SPI_BOOT 1
//#define CONFIG_MMC_BOOT
//#ifndef CONFIG_JERRY_NAND_TEST
//#define CONFIG_NAND_BOOT 1
//#endif

#ifdef CONFIG_NAND_BOOT
#define CONFIG_AMLROM_NANDBOOT 1
#endif 

#ifdef CONFIG_SPI_BOOT
	#define CONFIG_ENV_OVERWRITE
	#define CONFIG_ENV_IS_IN_SPI_FLASH
	#define CONFIG_CMD_SAVEENV	
	#define CONFIG_ENV_SECT_SIZE        0x1000
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
#define CONFIG_POST (CONFIG_SYS_POST_CACHE	| CONFIG_SYS_POST_BSPEC1 |	\
										CONFIG_SYS_POST_RTC | CONFIG_SYS_POST_ADC | \
										CONFIG_SYS_POST_PLL)
//CONFIG_SYS_POST_MEMORY
											
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
#define CONFIG_NR_DRAM_BANKS	1	/* CS1 may or may not be populated */
#define PHYS_MEMORY_START    0x80000000 // from 500000
#if(CONFIG_MEMSIZE == 128)
#define PHYS_MEMORY_SIZE      0x8000000 // 128M
#elif(CONFIG_MEMSIZE == 256)
#define CONFIG_DDR_TYPE DDR_K4T1G164QE //128M/PCS DDR
#define PHYS_MEMORY_SIZE     0x10000000 // 256M
#elif(CONFIG_MEMSIZE == 512)
#define CONFIG_DDR_TYPE DDR_W972GG6JB	//256M/PCS DDR
#define PHYS_MEMORY_SIZE     0x20000000 // 512M
#else
#ERROR: Must config CONFIG_MEMSIZE
#endif
#define CONFIG_SYS_MEMTEST_START	0x80000000	/* memtest works on	*/      
#define CONFIG_SYS_MEMTEST_END		0x87000000	/* 0 ... 120 MB in DRAM	*/  

/*-----------------------------------------------------------------------
 * power down
 */
#define CONFIG_CMD_RUNARC 1 /* runarc */


#endif
