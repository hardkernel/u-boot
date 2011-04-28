#ifndef __CONFIG_ARM_8726M_TARGET_H_
#define __CONFIG_ARM_8726M_TARGET_H_
#include <ddr_types.h>
//UART Sectoion
#define CONFIG_CONS_INDEX   1

//Enable storage devices
//#define CONFIG_CMD_NAND  1
#define CONFIG_CMD_SF      1
#define CONFIG_AML_MESON_1 1

#define CONFIG_AML_I2C        1
#define AML_MESON_BOARD_8726M_2010_11_18_V11 1

/* USB
 * Enable CONFIG_MUSB_HCD for Host functionalities MSC, keyboard
 * Enable CONFIG_MUSB_UDD for Device functionalities.
 */
/* #define CONFIG_MUSB_UDC		1 */
#define CONFIG_CMD_USB 1
//#define CONFIG_MUSB_HCD 1
#define CONFIG_M1_USBPORT_BASE	IO_USB_B_BASE
#define CONFIG_USB_STORAGE       1
#define CONFIG_USB_DWC_OTG_HCD   1

#ifdef CONFIG_USB_DWC_OTG_HCD
  #ifndef CONFIG_AML_I2C
    #error "Please define CONFIG_AML_I2C for USB bus power enable!"
  #endif
#endif /*CONFIG_USB_DWC_OTG_HCD*/


//Amlogic SARADC support
#define CONFIG_SARADC 1

#define CONFIG_CMD_NET   1
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

#define CONFIG_MEMSIZE	512	/*unit is MB*/ 
#if(CONFIG_MEMSIZE == 512)
#define BOARD_INFO_ENV  " mem=512M"
#define UBOOTPATH		"u-boot-512M-UartB.bin"
#else
#define BOARD_INFO_ENV ""
#define UBOOTPATH		"u-boot-aml.bin"
#endif

#define CONFIG_AML_RTC

/*POST support*/
#define CONFIG_POST (CONFIG_SYS_POST_MEMORY | CONFIG_SYS_POST_RTC | \
										CONFIG_SYS_POST_CACHE | CONFIG_SYS_POST_BSPEC1 | \
										CONFIG_SYS_POST_BSPEC2 |  \
										CONFIG_SYS_POST_I2C | CONFIG_SYS_POST_PLL |\
										CONFIG_SYS_POST_NAND | CONFIG_SYS_POST_SDCARD | CONFIG_SYS_POST_ADC)
										
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
#define CONFIG_DDR_TYPE         DDR_W972GG6JB        /* total bits*/
#define CONFIG_DDR_BIT_WIDTH    32      /*16 or 32*/
#define CONFIG_DDR_PCS   	2	/* CS1 may or may not be populated */
#define PHYS_MEMORY_START       0x80000000 
#if ((CONFIG_DDR_TYPE) == (DDR_W972GG6JB))
#define DDR_TOTAL_BITS (2*1024) /*2G bits*/
#endif
#if ((CONFIG_DDR_TYPE) == (DDR_K4T1G164QE))
#define DDR_TOTAL_BITS (1024) /*1G bits*/
#endif
#ifndef DDR_TOTAL_BITS
error please define DDR_TOTAL_BITS
#endif
#define PHYS_MEMORY_SIZE  ((unsigned long)(DDR_TOTAL_BITS / 8 ) * CONFIG_DDR_PCS * 1024 * 1024)

#define CONFIG_SYS_MEMTEST_START	PHYS_MEMORY_START	/* memtest works on	*/      
#define CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_MEMTEST_START + PHYS_MEMORY_SIZE)

#include <asm/arch/cpu.h>

#endif
