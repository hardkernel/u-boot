/*
 * cpu/s5pc1xx/usbd-otg-hs.c
 *
 * (C) Copyright 2007
 * Byungjae Lee, Samsung Erectronics, bjlee@samsung.com.
 *	- only support for S5PC100
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <common.h>

#if defined(CONFIG_S5PC110) || defined(CONFIG_S5PC210) || defined(CONFIG_S5PC220) || defined(CONFIG_S5P6450) || defined(CONFIG_ARCH_EXYNOS)
#include <command.h>
#include <asm/errno.h>
#include <asm/io.h>
#include <asm/arch/cpu.h>
#include "usbd-otg-hs.h"

#if defined(CONFIG_S5P6450)
	DECLARE_GLOBAL_DATA_PTR;
#endif

#undef USB_OTG_DEBUG_SETUP
#ifdef USB_OTG_DEBUG_SETUP
#define DBG_SETUP0(fmt, args...) printf("[%s:%d] " fmt, __FUNCTION__, __LINE__, ##args)
#define DBG_SETUP1(fmt, args...) printf("\t" fmt, ##args)
#define DBG_SETUP2(fmt, args...) printf(fmt, ##args)
#else
#define DBG_SETUP0(fmt, args...) do { } while (0)
#define DBG_SETUP1(fmt, args...) do { } while (0)
#define DBG_SETUP2(fmt, args...) do { } while (0)
#endif

#undef USB_OTG_DEBUG_BULK
#ifdef USB_OTG_DEBUG_BULK
#define DBG_BULK0(fmt, args...) printf("[%s:%d] " fmt, __FUNCTION__, __LINE__, ##args)
#define DBG_BULK1(fmt, args...)	printf("\t" fmt, ##args)
#else
#define DBG_BULK0(fmt, args...) do { } while (0)
#define DBG_BULK1(fmt, args...) do { } while (0)
#endif

#define USB_CHECKSUM_EN

#define TRUE	1
#define FALSE	0
#define SUSPEND_RESUME_ON FALSE


u32 s3c_usbd_dn_addr = 0;
u32 s3c_usbd_dn_cnt = 0;
u32 remode_wakeup;

#ifdef CONFIG_USB_CPUMODE
u16 config_value;
#else
u16 config_value __attribute__((aligned(8)));
u8 zlp_buf __attribute__((aligned(8)));
#endif

int DNW;
int is_fastboot = 0;
int s3c_receive_done = 0;
int s3c_got_header = 0;

#ifdef CONFIG_USB_CPUMODE
USB_OPMODE	op_mode = USB_CPU;
#else
USB_OPMODE	op_mode = USB_DMA;
#endif
USB_SPEED	speed = USB_HIGH;

otg_dev_t	otg;
get_status_t	get_status;
get_intf_t	get_intf;

enum EP_INDEX
{
	EP0, EP1, EP2, EP3, EP4
};

/*------------------------------------------------*/
/* EP0 state */
enum EP0_STATE
{
	EP0_STATE_INIT			= 0,
	EP0_STATE_GD_DEV_0		= 11,
	EP0_STATE_GD_DEV_1		= 12,
	EP0_STATE_GD_DEV_2		= 13,
	EP0_STATE_GD_CFG_0		= 21,
	EP0_STATE_GD_CFG_1		= 22,
	EP0_STATE_GD_CFG_2		= 23,
	EP0_STATE_GD_CFG_3		= 24,
	EP0_STATE_GD_CFG_4		= 25,
	EP0_STATE_GD_STR_I0		= 30,
	EP0_STATE_GD_STR_I1		= 31,
	EP0_STATE_GD_STR_I2		= 32,
	EP0_STATE_GD_STR_I3		= 133,
	EP0_STATE_GD_DEV_QUALIFIER	= 33,
	EP0_STATE_INTERFACE_GET		= 34,
	EP0_STATE_GET_STATUS0		= 35,
	EP0_STATE_GET_STATUS1		= 36,
	EP0_STATE_GET_STATUS2		= 37,
	EP0_STATE_GET_STATUS3		= 38,
	EP0_STATE_GET_STATUS4		= 39,
	EP0_STATE_GD_OTHER_SPEED	= 40,
	EP0_STATE_GD_CFG_ONLY_0 	= 41,
	EP0_STATE_GD_CFG_ONLY_1 	= 42,
	EP0_STATE_GD_IF_ONLY_0		= 44,
	EP0_STATE_GD_IF_ONLY_1		= 45,
	EP0_STATE_GD_EP0_ONLY_0 	= 46,
	EP0_STATE_GD_EP1_ONLY_0 	= 47,
	EP0_STATE_GD_EP2_ONLY_0 	= 48,
	EP0_STATE_GD_EP3_ONLY_0 	= 49,
	EP0_STATE_GD_OTHER_SPEED_HIGH_1	= 51,
	EP0_STATE_GD_OTHER_SPEED_HIGH_2	= 52,
	EP0_STATE_GD_OTHER_SPEED_HIGH_3	= 53
};

/*definitions related to CSR setting */

/* S5P_OTG_GOTGCTL*/
#define B_SESSION_VALID		(0x1<<19)
#define A_SESSION_VALID		(0x1<<18)

/* S5P_OTG_GAHBCFG*/
#define PTXFE_HALF		(0<<8)
#define PTXFE_ZERO		(1<<8)
#define NPTXFE_HALF		(0<<7)
#define NPTXFE_ZERO		(1<<7)
#define MODE_SLAVE		(0<<5)
#define MODE_DMA		(1<<5)
#define BURST_SINGLE		(0<<1)
#define BURST_INCR		(1<<1)
#define BURST_INCR4		(3<<1)
#define BURST_INCR8		(5<<1)
#define BURST_INCR16		(7<<1)
#define GBL_INT_UNMASK		(1<<0)
#define GBL_INT_MASK		(0<<0)

/* S5P_OTG_GRSTCTL*/
#define AHB_MASTER_IDLE		(1u<<31)
#define CORE_SOFT_RESET		(0x1<<0)

/* S5P_OTG_GINTSTS/S5P_OTG_GINTMSK core interrupt register */
#define INT_RESUME		(1u<<31)
#define INT_DISCONN		(0x1<<29)
#define INT_CONN_ID_STS_CNG	(0x1<<28)
#define INT_OUT_EP		(0x1<<19)
#define INT_IN_EP		(0x1<<18)
#define INT_ENUMDONE		(0x1<<13)
#define INT_RESET		(0x1<<12)
#define INT_SUSPEND		(0x1<<11)
#define INT_TX_FIFO_EMPTY	(0x1<<5)
#define INT_RX_FIFO_NOT_EMPTY	(0x1<<4)
#define INT_SOF			(0x1<<3)
#define INT_DEV_MODE		(0x0<<0)
#define INT_HOST_MODE		(0x1<<1)

/* S5P_OTG_GRXSTSP STATUS*/
#define GLOBAL_OUT_NAK			(0x1<<17)
#define OUT_PKT_RECEIVED		(0x2<<17)
#define OUT_TRNASFER_COMPLETED		(0x3<<17)
#define SETUP_TRANSACTION_COMPLETED	(0x4<<17)
#define SETUP_PKT_RECEIVED		(0x6<<17)

/* S5P_OTG_DCTL device control register */
#define NORMAL_OPERATION		(0x1<<0)
#define SOFT_DISCONNECT			(0x1<<1)
#define	TEST_J_MODE			(TEST_J<<4)
#define	TEST_K_MODE			(TEST_K<<4)
#define	TEST_SE0_NAK_MODE		(TEST_SE0_NAK<<4)
#define	TEST_PACKET_MODE		(TEST_PACKET<<4)
#define	TEST_FORCE_ENABLE_MODE		(TEST_FORCE_ENABLE<<4)
#define TEST_CONTROL_FIELD		(0x7<<4)

/* S5P_OTG_DAINT device all endpoint interrupt register */
#define INT_IN_EP0			(0x1<<0)
#define INT_IN_EP1			(0x1<<1)
#define INT_IN_EP3			(0x1<<3)
#define INT_OUT_EP0			(0x1<<16)
#define INT_OUT_EP2			(0x1<<18)
#define INT_OUT_EP4			(0x1<<20)

/* S5P_OTG_DIEPCTL0/S5P_OTG_DOEPCTL0 */
#define DEPCTL_EPENA			(0x1<<31)
#define DEPCTL_EPDIS			(0x1<<30)
#define DEPCTL_SNAK			(0x1<<27)
#define DEPCTL_CNAK			(0x1<<26)
#define DEPCTL_CTRL_TYPE		(EP_TYPE_CONTROL<<18)
#define DEPCTL_ISO_TYPE			(EP_TYPE_ISOCHRONOUS<<18)
#define DEPCTL_BULK_TYPE		(EP_TYPE_BULK<<18)
#define DEPCTL_INTR_TYPE		(EP_TYPE_INTERRUPT<<18)
#define DEPCTL_USBACTEP			(0x1<<15)

/*ep0 enable, clear nak, next ep0, max 64byte */
#define EPEN_CNAK_EP0_64 (DEPCTL_EPENA|DEPCTL_CNAK|(CONTROL_EP<<11)|(0<<0))

/*ep0 enable, clear nak, next ep0, 8byte */
#define EPEN_CNAK_EP0_8 (DEPCTL_EPENA|DEPCTL_CNAK|(CONTROL_EP<<11)|(3<<0))

/* DIEPCTLn/DOEPCTLn */
#define BACK2BACK_SETUP_RECEIVED	(0x1<<6)
#define INTKN_TXFEMP			(0x1<<4)
#define NON_ISO_IN_EP_TIMEOUT		(0x1<<3)
#define CTRL_OUT_EP_SETUP_PHASE_DONE	(0x1<<3)
#define AHB_ERROR			(0x1<<2)
#define TRANSFER_DONE			(0x1<<0)


/* codes representing languages */
const u8 string_desc0[] =
{
	4, STRING_DESCRIPTOR, LANGID_US_L, LANGID_US_H,
};

const u8 dnw_string_desc1[] = /* Manufacturer */
{
	(0x14+2), STRING_DESCRIPTOR,
	'S', 0x0, 'y', 0x0, 's', 0x0, 't', 0x0, 'e', 0x0,
	'm', 0x0, ' ', 0x0, 'M', 0x0, 'C', 0x0, 'U', 0x0,
};

const u8 dnw_string_desc2[] = /* Product */
{
	(0x2a+2), STRING_DESCRIPTOR,
	'S', 0x0, 'E', 0x0, 'C', 0x0, ' ', 0x0, 'S', 0x0,
	'3', 0x0, 'C', 0x0, '6', 0x0, '4', 0x0, '0', 0x0,
	'0', 0x0, 'X', 0x0, ' ', 0x0, 'T', 0x0, 'e', 0x0,
	's', 0x0, 't', 0x0, ' ', 0x0, 'B', 0x0, '/', 0x0,
	'D', 0x0
};

/* setting the device qualifier descriptor and a string descriptor */
const u8 qualifier_desc[] =
{
	0x0a,	/*  0 desc size */
	0x06,	/*  1 desc type (DEVICE_QUALIFIER)*/
	0x00,	/*  2 USB release */
	0x02,	/*  3 => 2.00*/
	0xFF,	/*  4 class */
	0x00,	/*  5 subclass */
	0x00,	/*  6 protocol */
	64,	/*  7 max pack size */
	0x01,	/*  8 number of other-speed configuration */
	0x00,	/*  9 reserved */
};

const u8 config_full[] =
{
	0x09,	/*  0 desc size */
	0x07,	/*  1 desc type (other speed)*/
	0x20,	/*  2 Total length of data returned */
	0x00,	/*  3 */
	0x01,	/*  4 Number of interfaces supported by this speed configuration */
	0x01,	/*  5 value to use to select configuration */
	0x00,	/*  6 index of string desc */
		/*  7 same as configuration desc */
	CONF_ATTR_DEFAULT|CONF_ATTR_SELFPOWERED,
	0x19,	/*  8 same as configuration desc */

};

const u8 config_full_total[] =
{
  0x09, 0x07 ,0x20 ,0x00 ,0x01 ,0x01 ,0x00 ,0xC0 ,0x19,
  0x09 ,0x04 ,0x00 ,0x00 ,0x02 ,0xff ,0x00 ,0x00 ,0x00,
  0x07 ,0x05 ,0x83 ,0x02 ,0x40 ,0x00 ,0x00,
  0x07 ,0x05 ,0x04 ,0x02 ,0x40 ,0x00 ,0x00
};

const u8 config_high[] =
{
	0x09,	/*  0 desc size */
	0x07,	/*  1 desc type (other speed)*/
	0x20,	/*  2 Total length of data returned */
	0x00,	/*  3 */
	0x01,	/*  4 Number of interfaces supported by this speed configuration */
	0x01,	/*  5 value to use to select configuration */
	0x00,	/*  6 index of string desc */
		/*  7 same as configuration desc */
	CONF_ATTR_DEFAULT|CONF_ATTR_SELFPOWERED,
	0x19,	/*  8 same as configuration desc */

};

const u8 config_high_total[] =
{
  0x09, 0x07 ,0x20 ,0x00 ,0x01 ,0x01 ,0x00 ,0xC0 ,0x19,
  0x09 ,0x04 ,0x00 ,0x00 ,0x02 ,0xff ,0x00 ,0x00 ,0x00,
  0x07 ,0x05 ,0x81 ,0x02 ,0x00 ,0x02 ,0x00,
  0x07 ,0x05 ,0x02 ,0x02 ,0x00 ,0x02 ,0x00
};

/* Descriptor size */
enum DESCRIPTOR_SIZE
{
	DEVICE_DESC_SIZE	= sizeof(device_desc_t),
	CONFIG_DESC_SIZE	= sizeof(config_desc_t),
	INTERFACE_DESC_SIZE	= sizeof(intf_desc_t),
	ENDPOINT_DESC_SIZE	= sizeof(ep_desc_t),
	DEVICE_QUALIFIER_SIZE	= sizeof(qualifier_desc),
	OTHER_SPEED_CFG_SIZE	= 9

};

/*32 <cfg desc>+<if desc>+<endp0 desc>+<endp1 desc>*/
#define CONFIG_DESC_TOTAL_SIZE	\
	(CONFIG_DESC_SIZE+INTERFACE_DESC_SIZE+ENDPOINT_DESC_SIZE*2)
#define TEST_PKT_SIZE 53

#ifdef CONFIG_USB_CPUMODE
u8 test_pkt [TEST_PKT_SIZE] = {
#else
u8 test_pkt [TEST_PKT_SIZE] __attribute__((aligned(8)))  = {
#endif
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,	/*JKJKJKJK x 9*/
	0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,	/*JJKKJJKK x 8*/
	0xEE,0xEE,0xEE,0xEE,0xEE,0xEE,0xEE,0xEE,	/*JJJJKKKK x 8*/
	0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,	/*JJJJJJJKKKKKKK x8 - '1'*/
	0x7F,0xBF,0xDF,0xEF,0xF7,0xFB,0xFD,		/*'1' + JJJJJJJK x 8*/
	0xFC,0x7E,0xBF,0xDF,0xEF,0xF7,0xFB,0xFD,0x7E	/*{JKKKKKKK x 10},JK*/
};

#ifndef CONFIG_USB_CPUMODE
/* BULK XFER SIZE is 256K bytes */
#define BULK_XFER_SIZE	262144
u8 usb_ctrl[8] __attribute__((aligned(8)));
u8 ctrl_buf[128] __attribute__((aligned(8)));
u8 tmp_buf[HS_BULK_PKT_SIZE] __attribute__((aligned(8)));
int written_bytes;

void s3c_usb_transfer_ep0(void);
void s3c_usb_set_outep_xfersize(EP_TYPE type, u32 pktcnt, u32 xfersize);
#endif
int s3c_usbctl_init(void);
void s3c_usb_set_inep_xfersize(EP_TYPE type, u32 pktcnt, u32 xfersize);
void s3c_usb_write_in_fifo(u8 *buf, int num);
void s3c_usb_read_out_fifo(u8 *buf, int num);

#include "fastboot.c"

void s3c_usb_init_phy(void)
{
#if defined(CONFIG_ARCH_EXYNOS5)
	writel(0x0, USB_CFG_REG);
	writel(0x7454, EXYNOS5_OTG_SYS);
	udelay(10);
	writel(0x0454, EXYNOS5_OTG_SYS);
	udelay(10);
#else /* EXYNOS4 or under */
#if defined(CONFIG_S5PC110)
	writel(0xa0, S5P_OTG_PHYPWR);
	writel(0x3, S5P_OTG_PHYCLK);
#elif defined(CONFIG_S5PC220)
	writel(0x0, USB_CFG_REG);
	writel(0x7f80, S5P_OTG_PHYPWR);
	writel(0x5, S5P_OTG_PHYCLK);
#elif defined(CONFIG_S5PC210)
	writel(0x1f80, S5P_OTG_PHYPWR);
	writel(0x3, S5P_OTG_PHYCLK);
#elif defined(CONFIG_S5P6450)
	writel(0xa0, S5P_OTG_PHYPWR);
	writel(0x21, S5P_OTG_PHYCLK);
#endif
	writel(0x1, S5P_OTG_RSTCON);
	udelay(10);
	writel(0x0, S5P_OTG_RSTCON);
	udelay(10);
#endif
}

/* OTG PHY Power Off */
void s3c_usb_phy_off(void) {
#if defined(CONFIG_ARCH_EXYNOS5)
	writel(0x145F, EXYNOS5_OTG_SYS);
#else
	writel(readl(S5P_OTG_PHYPWR)|(0x18), S5P_OTG_PHYPWR);
#endif
#if !defined(CONFIG_S5P6450)
	writel(readl(USB_PHY_CONTROL)&~(1<<0), USB_PHY_CONTROL);
#else
	writel(readl(OTHERS)|(1<<16), OTHERS);
#endif
}

void s3c_usb_core_soft_reset(void)
{
	u32 tmp;

	writel(CORE_SOFT_RESET, S5P_OTG_GRSTCTL);

	do
	{
		tmp = readl(S5P_OTG_GRSTCTL);
	}while(!(tmp & AHB_MASTER_IDLE));

}

void s3c_usb_wait_cable_insert(void)
{
	u32 tmp;
	int ucFirst = 1;

	do {
		udelay(50);

		tmp = readl(S5P_OTG_GOTGCTL);

		if (tmp & (B_SESSION_VALID|A_SESSION_VALID)) {
			printf("OTG cable Connected!\n");
			break;
		} else if(ucFirst == 1) {
			printf("Insert a OTG cable into the connector!\n");
			ucFirst = 0;
		}
	} while(1);
}

void s3c_usb_init_core(void)
{
#ifdef CONFIG_USB_CPUMODE
	writel(PTXFE_HALF|NPTXFE_HALF|MODE_SLAVE|BURST_SINGLE|GBL_INT_UNMASK,
		S5P_OTG_GAHBCFG);
#else
	writel(PTXFE_HALF|NPTXFE_HALF|MODE_DMA|BURST_INCR4|GBL_INT_UNMASK,
		S5P_OTG_GAHBCFG);
#endif

	writel(  0<<15		/* PHY Low Power Clock sel */
		|1<<14		/* Non-Periodic TxFIFO Rewind Enable */
		|0x5<<10	/* Turnaround time */
		|0<<9		/* 0:HNP disable, 1:HNP enable */
		|0<<8		/* 0:SRP disable, 1:SRP enable */
		|0<<7		/* ULPI DDR sel */
		|0<<6		/* 0: high speed utmi+, 1: full speed serial */
		|0<<4		/* 0: utmi+, 1:ulpi */
		|1<<3		/* phy i/f  0:8bit, 1:16bit */
		|0x7<<0,	/* HS/FS Timeout**/
		S5P_OTG_GUSBCFG );
}

void s3c_usb_check_current_mode(u8 *pucMode)
{
	u32 tmp;

	tmp = readl(S5P_OTG_GINTSTS);
	*pucMode = tmp & 0x1;
}

void s3c_usb_set_soft_disconnect(void)
{
	u32 tmp;

	tmp = readl(S5P_OTG_DCTL);
	tmp |= SOFT_DISCONNECT;
	writel(tmp, S5P_OTG_DCTL);
}

void s3c_usb_clear_soft_disconnect(void)
{
	u32 tmp;

	tmp = readl(S5P_OTG_DCTL);
	tmp &= ~SOFT_DISCONNECT;
	writel(tmp, S5P_OTG_DCTL);
}

void s3c_usb_init_device(void)
{
	writel(1<<18|otg.speed<<0, S5P_OTG_DCFG); /* [][1: full speed(30Mhz) 0:high speed]*/

#ifdef CONFIG_USB_CPUMODE
	writel(INT_RESUME|INT_OUT_EP|INT_IN_EP|INT_ENUMDONE|
		INT_RESET|INT_SUSPEND|INT_RX_FIFO_NOT_EMPTY,
		S5P_OTG_GINTMSK);	/*gint unmask */
#else
	writel(INT_RESUME|INT_OUT_EP|INT_IN_EP|INT_ENUMDONE|
		INT_RESET|INT_SUSPEND,
		S5P_OTG_GINTMSK);	/*gint unmask */
#endif
}

int s3c_usbctl_init(void)
{
	u8 ucMode;

	DBG_SETUP0("USB Control Init\n");
#if defined(CONFIG_S5PC110)||defined(CONFIG_S5PV310) || defined(CONFIG_S5PC210) || defined(CONFIG_S5PC220) || defined(CONFIG_ARCH_EXYNOS)
	writel(readl(USB_PHY_CONTROL)|(1<<0), USB_PHY_CONTROL);	/*USB PHY0 Enable */ // c110
#elif defined(CONFIG_S5PC100)
	writel(readl(OTHERS)|~(1<<16), OTHERS);
#elif defined(CONFIG_S5P6450)
	writel(readl(OTHERS)&~(1<<16), OTHERS);
#else
#error "* CFG_ERROR : you have to select proper CPU for Android Fastboot"
#endif

	otg.speed = speed;
	otg.set_config = 0;
	otg.ep0_state = EP0_STATE_INIT;
	otg.ep0_substate = 0;
	s3c_usb_init_phy();
	s3c_usb_core_soft_reset();
	s3c_usb_wait_cable_insert();
	s3c_usb_init_core();
	s3c_usb_check_current_mode(&ucMode);
	is_fastboot = 0;

	if (ucMode == INT_DEV_MODE) {
		s3c_usb_set_soft_disconnect();
		udelay(10);
		s3c_usb_clear_soft_disconnect();
		s3c_usb_init_device();
		return 0;
	} else {
		printf("Error : Current Mode is Host\n");
		return 0;
	}
}

int s3c_usbc_activate (void)
{
	/* dont used in usb high speed, but used in common file cmd_usbd.c  */
	return 0;
}

int s3c_usb_stop (void)
{
	/* dont used in usb high speed, but used in common file cmd_usbd.c  */
	s3c_usb_core_soft_reset();
	s3c_usb_phy_off();
	return 0;
}

void s3c_usb_print_pkt(u8 *pt, u8 count)
{
	int i;
	printf("[s3c_usb_print_pkt:");

	for(i=0;i<count;i++)
		printf("%x,", pt[i]);

	printf("]\n");
}

void s3c_usb_verify_checksum(void)
{
	u8 *cs_start, *cs_end;
	u16 dnCS;
	u16 checkSum;

	printf("Checksum is being calculated.");

	/* checksum calculation */
	cs_start = (u8*)otg.dn_addr;
	cs_end = (u8*)(otg.dn_addr+otg.dn_filesize-10);
	checkSum = 0;
	while(cs_start < cs_end) {
		checkSum += *cs_start++;
		if(((u32)cs_start&0xfffff)==0) printf(".");
	}

#if defined(CONFIG_S5PC110)||defined(CONFIG_S5PV310) || defined(CONFIG_S5PC210) || defined(CONFIG_S5PC220) || defined(CONFIG_ARCH_EXYNOS)
	// fixed alignment fault in case when cs_end is odd.
	dnCS = (u16)((cs_end[1]<<8) + cs_end[0]);
#elif defined(CONFIG_S5PC100) || defined(CONFIG_S5P6450)
	dnCS = *(u16 *)cs_end;
#else
#error "* CFG_ERROR : you have to select proper CPU"
#endif

	if (checkSum == dnCS)
	{
		printf("\nChecksum O.K.\n");
	}
	else
	{
		printf("\nChecksum Value => MEM:%x DNW:%x\n",checkSum,dnCS);
		printf("Checksum failed.\n\n");
	}

}
#ifndef CONFIG_USB_CPUMODE
void s3c_usb_prepare_setup_pkt(void)
{
	writel(virt_to_phys(ctrl_buf), S5P_OTG_DOEPDMA0);
	s3c_usb_set_outep_xfersize(EP_TYPE_CONTROL, 1, 8);
	/*ep0 enable, clear nak */
	writel((1u<<31)|(1<<26)|readl(S5P_OTG_DOEPCTL0), S5P_OTG_DOEPCTL0);
}

void s3c_usb_bulk_outep_setdma(u8* buf, int size)
{
	int pktcnt;
	u32 buf_address = (u32)buf;

	if(buf_address & 0x7) {
		printf("---------ERROR: DMA Address is not aligned by 8---------\n");
		return;
	}

	writel(virt_to_phys(buf), S5P_OTG_DOEPDMA_OUT);
	if(size == 0)
		pktcnt = 1;
	else
		pktcnt = (size - 1) / HS_BULK_PKT_SIZE + 1;

	s3c_usb_set_outep_xfersize(EP_TYPE_BULK, pktcnt, size);
	/*ep0 enable, clear nak */
	writel((1u<<31)|(1<<26)|readl(S5P_OTG_DOEPCTL_OUT), S5P_OTG_DOEPCTL_OUT);
}

void s3c_usb_bulk_inep_setdma(u8* buf, int size)
{
	int pktcnt;
	u32 buf_address = (u32)buf;

	if(buf_address & 0x7) {
		printf("---------ERROR: DMA Address is not aligned by 8---------\n");
		return;
	}

	writel(virt_to_phys(buf), S5P_OTG_DIEPDMA_IN);
	if(size == 0)
		pktcnt = 1;
	else
		pktcnt = (size - 1) / HS_BULK_PKT_SIZE + 1;

	s3c_usb_set_inep_xfersize(EP_TYPE_BULK, pktcnt, size);
	/*ep0 enable, clear nak */
	writel((1u<<31)|(1<<26)|readl(S5P_OTG_DIEPCTL_IN), S5P_OTG_DIEPCTL_IN);
}

void s3c_usb_ctrl_inep_setdma(u8* buf, int size)
{
	int pktcnt;
	u32 buf_address = (u32)buf;

	if(buf_address & 0x7) {
		memcpy(ctrl_buf, buf, size);
		buf = ctrl_buf;
	}
	writel(virt_to_phys(buf), S5P_OTG_DIEPDMA0);
	if(size == 0)
		pktcnt = 1;
	else
		pktcnt = (size - 1) / 64 + 1;
	s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, pktcnt, size);

	/*ep0 enable, clear nak */
	writel((1u<<31)|(1<<26)|readl(S5P_OTG_DIEPCTL0), S5P_OTG_DIEPCTL0);
}

void s3c_usb_upload_continue(void)
{
	u32 xfer_size, remain_size;

	xfer_size = readl(S5P_OTG_DIEPTSIZ_IN) & 0x7FFF;
	otg.up_ptr += (written_bytes - xfer_size);

	remain_size = otg.up_size - ((u32)otg.up_ptr - otg.up_addr);
	if (remain_size > 0) {
		if(remain_size < BULK_XFER_SIZE)
			written_bytes = remain_size;
		else
			written_bytes = BULK_XFER_SIZE;

		s3c_usb_bulk_inep_setdma(otg.up_ptr, written_bytes);
	} else
		s3c_receive_done = 1;
}
#endif

void s3c_usb_set_inep_xfersize(EP_TYPE type, u32 pktcnt, u32 xfersize)
{
	if(type == EP_TYPE_CONTROL)
	{
		writel((pktcnt<<19)|(xfersize<<0), S5P_OTG_DIEPTSIZ0);
	}
	else if(type == EP_TYPE_BULK)
	{
		writel((1<<29)|(pktcnt<<19)|(xfersize<<0), S5P_OTG_DIEPTSIZ_IN);
	}
}

void s3c_usb_set_outep_xfersize(EP_TYPE type, u32 pktcnt, u32 xfersize)
{
	if(type == EP_TYPE_CONTROL)
	{
		writel((1<<29)|(pktcnt<<19)|(xfersize<<0), S5P_OTG_DOEPTSIZ0);
	}
	else if(type == EP_TYPE_BULK)
	{
		writel((pktcnt<<19)|(xfersize<<0), S5P_OTG_DOEPTSIZ_OUT);
	}
}

void s3c_usb_write_ep0_fifo(u8 *buf, int num)
{
	int i;
	u32 Wr_Data=0;

	DBG_SETUP1("[s3c_usb_write_ep0_fifo:");

	for(i=0;i<num;i+=4)
	{
		Wr_Data = ((*(buf+3))<<24)|((*(buf+2))<<16)|((*(buf+1))<<8)|*buf;
		DBG_SETUP2(" 0x%08x,", Wr_Data);
		writel(Wr_Data, S5P_OTG_EP0_FIFO);
		buf += 4;
	}

	DBG_SETUP2("]\n");
}


void s3c_usb_write_in_fifo(u8 *buf, int num)
{
	int i;
	u32 data=0;

	for(i=0;i<num;i+=4)
	{
		data=((*(buf+3))<<24)|((*(buf+2))<<16)|((*(buf+1))<<8)|*buf;
		writel(data, S5P_OTG_IN_FIFO);
		buf += 4;
	}
}

void s3c_usb_read_out_fifo(u8 *buf, int num)
{
	int i;
	u32 data;

	for (i=0;i<num;i+=4)
	{
		data = readl(S5P_OTG_OUT_FIFO);

		buf[i] = (u8)data;
		buf[i+1] = (u8)(data>>8);
		buf[i+2] = (u8)(data>>16);
		buf[i+3] = (u8)(data>>24);
	}
}

void s3c_usb_get_desc(void)
{
	switch (otg.dev_req.wValue_H) {
	case DEVICE_DESCRIPTOR:
		otg.req_length = (u32)((otg.dev_req.wLength_H << 8) |
			otg.dev_req.wLength_L);
		DBG_SETUP1("DEVICE_DESCRIPTOR = 0x%x \n",otg.req_length);
		otg.ep0_state = EP0_STATE_GD_DEV_0;
		break;

	case CONFIGURATION_DESCRIPTOR:
		otg.req_length = (u32)((otg.dev_req.wLength_H << 8) |
			otg.dev_req.wLength_L);
		DBG_SETUP1("CONFIGURATION_DESCRIPTOR = 0x%x \n",otg.req_length);

		/* GET_DESCRIPTOR:CONFIGURATION+INTERFACE+ENDPOINT0+ENDPOINT1 */
		if (otg.req_length > CONFIG_DESC_SIZE){
			otg.ep0_state = EP0_STATE_GD_CFG_0;
		} else
			otg.ep0_state = EP0_STATE_GD_CFG_ONLY_0;
		break;

	case STRING_DESCRIPTOR :
		DBG_SETUP1("STRING_DESCRIPTOR \n");

		switch(otg.dev_req.wValue_L) {
		case 0:
			otg.ep0_state = EP0_STATE_GD_STR_I0;
			break;
		case 1:
			otg.ep0_state = EP0_STATE_GD_STR_I1;
			break;
		case 2:
			otg.ep0_state = EP0_STATE_GD_STR_I2;
			break;
		case 3:
			otg.ep0_state = EP0_STATE_GD_STR_I3;
			break;
		default:
			break;
		}
		break;

	case ENDPOINT_DESCRIPTOR:
		DBG_SETUP1("ENDPOINT_DESCRIPTOR \n");
		switch(otg.dev_req.wValue_L&0xf) {
		case 0:
			otg.ep0_state=EP0_STATE_GD_EP0_ONLY_0;
			break;
		case 1:
			otg.ep0_state=EP0_STATE_GD_EP1_ONLY_0;
			break;
		default:
			break;
		}
		break;

	case DEVICE_QUALIFIER:
		otg.req_length = (u32)((otg.dev_req.wLength_H << 8) |
			otg.dev_req.wLength_L);
		DBG_SETUP1("DEVICE_QUALIFIER = 0x%x \n",otg.req_length);
		otg.ep0_state = EP0_STATE_GD_DEV_QUALIFIER;
		break;

	case OTHER_SPEED_CONFIGURATION :
		DBG_SETUP1("OTHER_SPEED_CONFIGURATION \n");
		otg.req_length = (u32)((otg.dev_req.wLength_H << 8) |
			otg.dev_req.wLength_L);
		otg.ep0_state = EP0_STATE_GD_OTHER_SPEED;
		break;

	}
}

void s3c_usb_clear_feature(void)
{
	switch (otg.dev_req.bmRequestType) {
	case DEVICE_RECIPIENT:
		DBG_SETUP1("DEVICE_RECIPIENT \n");
		if (otg.dev_req.wValue_L == 1)
			remode_wakeup = FALSE;
		break;

	case ENDPOINT_RECIPIENT:
		DBG_SETUP1("ENDPOINT_RECIPIENT \n");
		if (otg.dev_req.wValue_L == 0) {
			if ((otg.dev_req.wIndex_L & 0x7f) == CONTROL_EP)
				get_status.ep_ctrl= 0;

			/* IN	Endpoint */
			if ((otg.dev_req.wIndex_L & 0x7f) == BULK_IN_EP)
				get_status.ep_in= 0;

			/* OUT Endpoint */
			if ((otg.dev_req.wIndex_L & 0x7f) == BULK_OUT_EP)
				get_status.ep_out= 0;
		}
		break;

	default:
		DBG_SETUP1("\n");
		break;
	}
	otg.ep0_state = EP0_STATE_INIT;

}

void s3c_usb_set_feature(void)
{
	u32 tmp;

	switch (otg.dev_req.bmRequestType) {
	case DEVICE_RECIPIENT:
		DBG_SETUP1("DEVICE_RECIPIENT \n");
		if (otg.dev_req.wValue_L == 1)
			remode_wakeup = TRUE;
			break;

	case ENDPOINT_RECIPIENT:
		DBG_SETUP1("ENDPOINT_RECIPIENT \n");
		if (otg.dev_req.wValue_L == 0) {
			if ((otg.dev_req.wIndex_L & 0x7f) == CONTROL_EP)
				get_status.ep_ctrl= 1;

			if ((otg.dev_req.wIndex_L & 0x7f) == BULK_IN_EP)
				get_status.ep_in= 1;

			if ((otg.dev_req.wIndex_L & 0x7f) == BULK_OUT_EP)
				get_status.ep_out= 1;
		}
		break;

	default:
		DBG_SETUP1("\n");
		break;
	}

	switch (otg.dev_req.wValue_L) {
	case EP_STALL:
		/* TBD: additional processing if required */
		break;

	case TEST_MODE:
		if ((0 != otg.dev_req.wIndex_L ) ||(0 != otg.dev_req.bmRequestType))
			break;

		/* Set TEST MODE*/
		tmp = readl(S5P_OTG_DCTL);
		tmp = (tmp & ~(TEST_CONTROL_FIELD)) | (TEST_FORCE_ENABLE_MODE);
		writel(tmp, S5P_OTG_DCTL);

		switch(otg.dev_req.wIndex_H) {
		case TEST_J:
			/*Set Test J*/
			tmp = readl(S5P_OTG_DCTL);
			tmp = (tmp & ~(TEST_CONTROL_FIELD)) | (TEST_J_MODE);
			writel(tmp, S5P_OTG_DCTL);
			break;

		case TEST_K:
			/*Set Test K*/
			tmp = readl(S5P_OTG_DCTL);
			tmp = (tmp & ~(TEST_CONTROL_FIELD)) | (TEST_K_MODE);
			writel(tmp, S5P_OTG_DCTL);
			break;

		case TEST_SE0_NAK:
			/*Set Test SE0NAK*/
			tmp = readl(S5P_OTG_DCTL);
			tmp = (tmp & ~(TEST_CONTROL_FIELD)) | (TEST_SE0_NAK_MODE);
			writel(tmp, S5P_OTG_DCTL);
			break;

		case TEST_PACKET:
			DBG_SETUP1 ("Test_packet\n");
#ifdef CONFIG_USB_CPUMODE
			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, TEST_PKT_SIZE);
			s3c_usb_write_ep0_fifo(test_pkt, TEST_PKT_SIZE);
#else
			s3c_usb_ctrl_inep_setdma(test_pkt, TEST_PKT_SIZE);
#endif
			tmp = readl(S5P_OTG_DCTL);
			tmp = (tmp & ~(TEST_CONTROL_FIELD)) | (TEST_PACKET_MODE);
			writel(tmp, S5P_OTG_DCTL);
			DBG_SETUP1 ("S5P_OTG_DCTL=0x%08x\n", tmp);
			break;
		}
		break;

	default:
		break;
	}
	otg.ep0_state = EP0_STATE_INIT;
}

void s3c_usb_get_status(void)
{
	switch(otg.dev_req.bmRequestType) {
	case  (0x80):	/*device */
		DBG_SETUP1("DEVICE\n");
		get_status.Device=((u8)remode_wakeup<<1)|0x1; /* SelfPowered */
		otg.ep0_state = EP0_STATE_GET_STATUS0;
		break;

	case  (0x81):	/*interface */
		DBG_SETUP1("INTERFACE\n");
		get_status.Interface=0;
		otg.ep0_state = EP0_STATE_GET_STATUS1;
		break;

	case  (0x82):	/*endpoint */
		DBG_SETUP1("ENDPOINT\n");
		if ((otg.dev_req.wIndex_L & 0x7f) == CONTROL_EP)
			otg.ep0_state = EP0_STATE_GET_STATUS2;

		if ((otg.dev_req.wIndex_L & 0x7f) == BULK_IN_EP)
			otg.ep0_state = EP0_STATE_GET_STATUS3;

		if ((otg.dev_req.wIndex_L & 0x7f) == BULK_OUT_EP)
			otg.ep0_state = EP0_STATE_GET_STATUS4;
		break;

	default:
		DBG_SETUP1("\n");
		break;
	}
}

void s3c_usb_ep0_int_hndlr(void)
{
	u16 i;
	u32 buf[2]={0x0000, };
	u16 addr;

	DBG_SETUP0("Event EP0\n");

	if (otg.ep0_state == EP0_STATE_INIT) {

#ifdef CONFIG_USB_CPUMODE
		for(i=0;i<2;i++)
			buf[i] = readl(S5P_OTG_EP0_FIFO);

		otg.dev_req.bmRequestType = buf[0];
		otg.dev_req.bRequest	= buf[0]>>8;
		otg.dev_req.wValue_L	= buf[0]>>16;
		otg.dev_req.wValue_H	= buf[0]>>24;
		otg.dev_req.wIndex_L	= buf[1];
		otg.dev_req.wIndex_H	= buf[1]>>8;
		otg.dev_req.wLength_L	= buf[1]>>16;
		otg.dev_req.wLength_H	= buf[1]>>24;
#else
		otg.dev_req.bmRequestType = ctrl_buf[0];
		otg.dev_req.bRequest	= ctrl_buf[1];
		otg.dev_req.wValue_L	= ctrl_buf[2];
		otg.dev_req.wValue_H	= ctrl_buf[3];
		otg.dev_req.wIndex_L	= ctrl_buf[4];
		otg.dev_req.wIndex_H	= ctrl_buf[5];
		otg.dev_req.wLength_L	= ctrl_buf[6];
		otg.dev_req.wLength_H	= ctrl_buf[7];
#endif

#ifdef USB_OTG_DEBUG_SETUP
		s3c_usb_print_pkt((u8 *)&otg.dev_req, 8);
#endif

		switch (otg.dev_req.bRequest) {
		case STANDARD_SET_ADDRESS:
			/* Set Address Update bit */
			addr = (otg.dev_req.wValue_L);
			writel(1<<18|addr<<4|otg.speed<<0, S5P_OTG_DCFG);
			DBG_SETUP1("S5P_OTG_DCFG : %x, STANDARD_SET_ADDRESS : %d\n",
					readl(S5P_OTG_DCFG), addr);
			otg.ep0_state = EP0_STATE_INIT;
			break;

		case STANDARD_SET_DESCRIPTOR:
			DBG_SETUP1("STANDARD_SET_DESCRIPTOR \n");
			break;

		case STANDARD_SET_CONFIGURATION:
			DBG_SETUP1("STANDARD_SET_CONFIGURATION \n");
			/* Configuration value in configuration descriptor */
			config_value = otg.dev_req.wValue_L;
			otg.set_config = 1;
			otg.ep0_state = EP0_STATE_INIT;
#ifndef CONFIG_USB_CPUMODE
			/* Set the Dedicated FIFO 1 for Bulk IN EP(1<<22) */
			writel(1<<28|1<<22|2<<18|1<<15|otg.bulkin_max_pktsize<<0,S5P_OTG_DIEPCTL_IN);
			writel(1<<28|2<<18|1<<15|otg.bulkout_max_pktsize<<0,S5P_OTG_DOEPCTL_OUT);
			s3c_usb_bulk_outep_setdma(tmp_buf, HS_BULK_PKT_SIZE);
#endif
			break;

		case STANDARD_GET_CONFIGURATION:
			DBG_SETUP1("STANDARD_GET_CONFIGURATION \n");
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 1);

#ifdef CONFIG_USB_CPUMODE
			/*ep0 enable, clear nak, next ep0, 8byte */
			writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
			writel(config_value, S5P_OTG_EP0_FIFO);
#else
			s3c_usb_ctrl_inep_setdma((u8 *)&config_value, 1);
#endif
			otg.ep0_state = EP0_STATE_INIT;
			break;

		case STANDARD_GET_DESCRIPTOR:
			DBG_SETUP1("STANDARD_GET_DESCRIPTOR :");
			s3c_usb_get_desc();
			break;

		case STANDARD_CLEAR_FEATURE:
			DBG_SETUP1("STANDARD_CLEAR_FEATURE :");
			s3c_usb_clear_feature();
			break;

		case STANDARD_SET_FEATURE:
			DBG_SETUP1("STANDARD_SET_FEATURE :");
			s3c_usb_set_feature();
			break;

		case STANDARD_GET_STATUS:
			DBG_SETUP1("STANDARD_GET_STATUS :");
			s3c_usb_get_status();
			break;

		case STANDARD_GET_INTERFACE:
			DBG_SETUP1("STANDARD_GET_INTERFACE \n");
			otg.ep0_state = EP0_STATE_INTERFACE_GET;
			break;

		case STANDARD_SET_INTERFACE:
			DBG_SETUP1("STANDARD_SET_INTERFACE \n");
			get_intf.AlternateSetting= otg.dev_req.wValue_L;
			otg.ep0_state = EP0_STATE_INIT;
			break;

		case STANDARD_SYNCH_FRAME:
			DBG_SETUP1("STANDARD_SYNCH_FRAME \n");
			otg.ep0_state = EP0_STATE_INIT;
			break;

		default:
			break;
		}
	}
#ifdef CONFIG_USB_CPUMODE

	s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, otg.ctrl_max_pktsize);

	/*clear nak, next ep0, 64byte */
	writel(((1<<26)|(CONTROL_EP<<11)|(0<<0)), S5P_OTG_DIEPCTL0);

#else
	s3c_usb_transfer_ep0();
#endif
}

void s3c_usb_set_otherspeed_conf_desc(u32 length)
{
	/* Standard device descriptor */
	if (length ==9)
	{
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 9);
		writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo(((u8 *)&config_full)+0, 9);
#else
		s3c_usb_ctrl_inep_setdma(((u8 *)&config_full)+0, 9);
#endif
	}
	else if(length ==32)
	{
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 32);
		writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo(((u8 *)&config_full_total)+0, 32);
#else
		s3c_usb_ctrl_inep_setdma(((u8 *)&config_full_total)+0, 32);
#endif

	}
	otg.ep0_state = EP0_STATE_INIT;
}

void s3c_usb_transfer_ep0(void)
{
	const u8 *string_desc1, *string_desc2, *string_desc3;
	u32 string_desc1_size, string_desc2_size, string_desc3_size;

	if (is_fastboot) {
		string_desc1 = fboot_string_desc1;
		string_desc2 = fboot_string_desc2;
		string_desc3 = fboot_string_desc3;

		string_desc1_size = sizeof(fboot_string_desc1);
		string_desc2_size = sizeof(fboot_string_desc2);
		string_desc3_size = sizeof(fboot_string_desc3);
	} else {
		string_desc1 = dnw_string_desc1;
		string_desc2 = dnw_string_desc2;
		string_desc3 = dnw_string_desc2;

		string_desc1_size = sizeof(dnw_string_desc1);
		string_desc2_size = sizeof(dnw_string_desc2);
		string_desc3_size = sizeof(dnw_string_desc2);
	}

	DBG_SETUP0("otg.ep0_state = %d\n", otg.ep0_state);

	switch (otg.ep0_state) {
	case EP0_STATE_INIT:
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 0);

		/*ep0 enable, clear nak, next ep0, 8byte */
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
#else
		s3c_usb_ctrl_inep_setdma((u8 *)&zlp_buf, 0);
#endif
		DBG_SETUP1("EP0_STATE_INIT\n");
		break;

	/* GET_DESCRIPTOR:DEVICE */
	case EP0_STATE_GD_DEV_0:
		DBG_SETUP1("EP0_STATE_GD_DEV_0 :");

		/*ep0 enable, clear nak, next ep0, max 64byte */
#ifdef CONFIG_USB_CPUMODE
		writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
		if (otg.req_length < DEVICE_DESC_SIZE) {
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, otg.req_length);
			s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.dev))+0, otg.req_length);
		} else {
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, DEVICE_DESC_SIZE);
			s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.dev))+0, DEVICE_DESC_SIZE);
		}
		otg.ep0_state = EP0_STATE_INIT;
#else
		if (otg.req_length < DEVICE_DESC_SIZE) {
			s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.dev))+0, otg.req_length);
		} else {
			s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.dev))+0, DEVICE_DESC_SIZE);
		}
		otg.ep0_state = EP0_STATE_INIT;
#endif
		break;

	/* GET_DESCRIPTOR:CONFIGURATION+INTERFACE+ENDPOINT0+ENDPOINT1 */
	case EP0_STATE_GD_CFG_0:
		DBG_SETUP1("EP0_STATE_GD_CFG_0 :");
#ifdef CONFIG_USB_CPUMODE
		writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
		if(otg.req_length<CONFIG_DESC_TOTAL_SIZE)
		{
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, otg.req_length);
			s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.config))+0, otg.req_length);
		}
		else
		{
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, CONFIG_DESC_TOTAL_SIZE);
			s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.config))+0, CONFIG_DESC_TOTAL_SIZE);
		}
#else
		if(otg.req_length<CONFIG_DESC_TOTAL_SIZE)
		{
			s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.config))+0, otg.req_length);
		}
		else
		{
			s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.config))+0, CONFIG_DESC_TOTAL_SIZE);
		}
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	case EP0_STATE_GD_OTHER_SPEED:
			DBG_SETUP1("EP0_STATE_GD_OTHER_SPEED\n");
			s3c_usb_set_otherspeed_conf_desc(otg.req_length);
			break;

	/* GET_DESCRIPTOR:CONFIGURATION ONLY*/
	case EP0_STATE_GD_CFG_ONLY_0:
		DBG_SETUP1("EP0_STATE_GD_CFG_ONLY_0:");
		if(otg.req_length<CONFIG_DESC_SIZE)
		{
#ifdef CONFIG_USB_CPUMODE
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, otg.req_length);
			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.config))+0, otg.req_length);
#else
			s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.config))+0, otg.req_length);
#endif
		}
		else
		{
#ifdef CONFIG_USB_CPUMODE
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, CONFIG_DESC_SIZE);
			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.config))+0,
						CONFIG_DESC_SIZE);
#else
			s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.config))+0,CONFIG_DESC_SIZE);
#endif
		}
		otg.ep0_state = EP0_STATE_INIT;
		break;

	/* GET_DESCRIPTOR:INTERFACE ONLY */

	case EP0_STATE_GD_IF_ONLY_0:
		DBG_SETUP1("EP0_STATE_GD_IF_ONLY_0 :");
		if(otg.req_length<INTERFACE_DESC_SIZE)
		{
#ifdef CONFIG_USB_CPUMODE
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, otg.req_length);
			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.intf))+0, otg.req_length);
#else
			s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.intf))+0, otg.req_length);
#endif
		}
		else
		{
#ifdef CONFIG_USB_CPUMODE
			s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, INTERFACE_DESC_SIZE);
			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.intf))+0, INTERFACE_DESC_SIZE);
#else
			s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.intf))+0, INTERFACE_DESC_SIZE);
#endif
		}
		otg.ep0_state = EP0_STATE_INIT;
		break;

	/* GET_DESCRIPTOR:ENDPOINT 1 ONLY */
	case EP0_STATE_GD_EP0_ONLY_0:
		DBG_SETUP1("EP0_STATE_GD_EP0_ONLY_0\n");
#ifdef CONFIG_USB_CPUMODE
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, ENDPOINT_DESC_SIZE);
		s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.ep1))+0, ENDPOINT_DESC_SIZE);
#else
		s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.ep1))+0, ENDPOINT_DESC_SIZE);
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	/* GET_DESCRIPTOR:ENDPOINT 2 ONLY */
	case EP0_STATE_GD_EP1_ONLY_0:
		DBG_SETUP1("EP0_STATE_GD_EP1_ONLY_0\n");
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, ENDPOINT_DESC_SIZE);
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo(((u8 *)&(otg.desc.ep2))+0, ENDPOINT_DESC_SIZE);
#else
		s3c_usb_ctrl_inep_setdma(((u8 *)&(otg.desc.ep2))+0, ENDPOINT_DESC_SIZE);
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	/* GET_DESCRIPTOR:STRING  */
	case EP0_STATE_GD_STR_I0:
		DBG_SETUP1("EP0_STATE_GD_STR_I0\n");
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, sizeof(string_desc0));
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo((u8 *)string_desc0, sizeof(string_desc0));
#else
		s3c_usb_ctrl_inep_setdma((u8 *)string_desc0, sizeof(string_desc0));
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	case EP0_STATE_GD_STR_I1:
		DBG_SETUP1("EP0_STATE_GD_STR_I1 %d\n", otg.ep0_substate);
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, string_desc1_size);
		if ((otg.ep0_substate*otg.ctrl_max_pktsize+otg.ctrl_max_pktsize)
			< string_desc1_size) {

			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo((u8 *)string_desc1+(otg.ep0_substate*otg.ctrl_max_pktsize),
						otg.ctrl_max_pktsize);
			otg.ep0_state = EP0_STATE_GD_STR_I1;
			otg.ep0_substate++;
		} else {
			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo((u8 *)string_desc1+(otg.ep0_substate*otg.ctrl_max_pktsize),
						string_desc1_size-(otg.ep0_substate*otg.ctrl_max_pktsize));
			otg.ep0_state = EP0_STATE_INIT;
			otg.ep0_substate = 0;
		}
#else
		s3c_usb_ctrl_inep_setdma((u8 *)string_desc1, string_desc1_size);
		otg.ep0_state = EP0_STATE_INIT;
#endif
		break;

	case EP0_STATE_GD_STR_I2:
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, string_desc2_size);
		if ((otg.ep0_substate*otg.ctrl_max_pktsize+otg.ctrl_max_pktsize)
			< string_desc2_size) {

			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo((u8 *)string_desc2+(otg.ep0_substate*otg.ctrl_max_pktsize),
						otg.ctrl_max_pktsize);
			otg.ep0_state = EP0_STATE_GD_STR_I2;
			otg.ep0_substate++;
		} else {
			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo((u8 *)string_desc2+(otg.ep0_substate*otg.ctrl_max_pktsize),
						string_desc2_size-(otg.ep0_substate*otg.ctrl_max_pktsize));
			otg.ep0_state = EP0_STATE_INIT;
			otg.ep0_substate = 0;
		}
		DBG_SETUP1("EP0_STATE_GD_STR_I2 %d", otg.ep0_substate);
#else
		s3c_usb_ctrl_inep_setdma((u8 *)string_desc2, string_desc2_size);
		otg.ep0_state = EP0_STATE_INIT;
#endif
		break;

	case EP0_STATE_GD_STR_I3:
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, string_desc3_size);
		if ((otg.ep0_substate*otg.ctrl_max_pktsize+otg.ctrl_max_pktsize)
			< string_desc3_size) {

			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo((u8 *)string_desc3+(otg.ep0_substate*otg.ctrl_max_pktsize),
						otg.ctrl_max_pktsize);
			otg.ep0_state = EP0_STATE_GD_STR_I3;
			otg.ep0_substate++;
		} else {
			writel(EPEN_CNAK_EP0_64, S5P_OTG_DIEPCTL0);
			s3c_usb_write_ep0_fifo((u8 *)string_desc3+(otg.ep0_substate*otg.ctrl_max_pktsize),
						string_desc3_size-(otg.ep0_substate*otg.ctrl_max_pktsize));
			otg.ep0_state = EP0_STATE_INIT;
			otg.ep0_substate = 0;
		}
#else
		s3c_usb_ctrl_inep_setdma((u8 *)string_desc3, string_desc3_size);
		otg.ep0_state = EP0_STATE_INIT;
#endif
		DBG_SETUP1("EP0_STATE_GD_STR_I3 %d", otg.ep0_substate);
		break;

	case EP0_STATE_INTERFACE_GET:
		DBG_SETUP1("EP0_STATE_INTERFACE_GET\n");
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 1);
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo((u8 *)&get_intf+0, 1);
#else
		s3c_usb_ctrl_inep_setdma((u8 *)&get_intf+0, 1);
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;


	case EP0_STATE_GET_STATUS0:
		DBG_SETUP1("EP0_STATE_GET_STATUS0\n");
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 1);
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo((u8 *)&get_status+0, 1);
#else
		s3c_usb_ctrl_inep_setdma((u8 *)&get_status+0, 1);
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	case EP0_STATE_GET_STATUS1:
		DBG_SETUP1("EP0_STATE_GET_STATUS1\n");
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 1);
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo((u8 *)&get_status+1, 1);
#else
		s3c_usb_ctrl_inep_setdma((u8 *)&get_status+1, 1);
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	case EP0_STATE_GET_STATUS2:
		DBG_SETUP1("EP0_STATE_GET_STATUS2\n");
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 1);
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo((u8 *)&get_status+2, 1);
#else
		s3c_usb_ctrl_inep_setdma((u8 *)&get_status+2, 1);
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	case EP0_STATE_GET_STATUS3:
		DBG_SETUP1("EP0_STATE_GET_STATUS3\n");
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 1);
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo((u8 *)&get_status+3, 1);
#else
		s3c_usb_ctrl_inep_setdma((u8 *)&get_status+3, 1);
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	case EP0_STATE_GET_STATUS4:
		DBG_SETUP1("EP0_STATE_GET_STATUS4\n");
#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_CONTROL, 1, 1);
		writel(EPEN_CNAK_EP0_8, S5P_OTG_DIEPCTL0);
		s3c_usb_write_ep0_fifo((u8 *)&get_status+4, 1);
#else
		s3c_usb_ctrl_inep_setdma((u8 *)&get_status+4, 1);
#endif
		otg.ep0_state = EP0_STATE_INIT;
		break;

	default:
		break;
	}
}


void s3c_usb_int_bulkin(void)
{
	u8* bulkin_buf;
	u32 remain_cnt;

	DBG_BULK0("Bulk In Function\n");

	bulkin_buf = (u8*)otg.up_ptr;
	remain_cnt = otg.up_size- ((u32)otg.up_ptr - otg.up_addr);
	DBG_BULK1("bulkin_buf = 0x%x,remain_cnt = 0x%x \n", bulkin_buf, remain_cnt);

	if (remain_cnt > otg.bulkin_max_pktsize) {
		s3c_usb_set_inep_xfersize(EP_TYPE_BULK, 1, otg.bulkin_max_pktsize);

		/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
		writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkin_max_pktsize<<0,
			S5P_OTG_DIEPCTL_IN);

		s3c_usb_write_in_fifo(bulkin_buf, otg.bulkin_max_pktsize);

		otg.up_ptr += otg.bulkin_max_pktsize;

		while(readl(S5P_OTG_DIEPCTL_IN) & (1<<31));
	} else if(remain_cnt > 0) {
		s3c_usb_set_inep_xfersize(EP_TYPE_BULK, 1, remain_cnt);

		/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
		writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkin_max_pktsize<<0,
			S5P_OTG_DIEPCTL_IN);

		s3c_usb_write_in_fifo(bulkin_buf, remain_cnt);

		otg.up_ptr += remain_cnt;

		while(readl(S5P_OTG_DIEPCTL_IN) & (1<<31));
	} else { /*remain_cnt = 0*/
		writel((DEPCTL_SNAK|DEPCTL_BULK_TYPE), S5P_OTG_DIEPCTL_IN);
	}
}

void s3c_usb_upload_start(void)
{
#ifdef CONFIG_USB_CPUMODE
	u8 tmp_buf[12];
	u32 check;

	s3c_usb_read_out_fifo((u8 *)tmp_buf, 10);
#else
	u32 check;
#endif
	check = *((u8 *)(tmp_buf+8)) + (*((u8 *)(tmp_buf+9))<<8);

	if (check==0x1) {
		otg.up_addr =
			*((u8 *)(tmp_buf+0))+
			(*((u8 *)(tmp_buf+1))<<8)+
			(*((u8 *)(tmp_buf+2))<<16)+
			(*((u8 *)(tmp_buf+3))<<24);

		otg.up_size =
			*((u8 *)(tmp_buf+4))+
			(*((u8 *)(tmp_buf+5))<<8)+
			(*((u8 *)(tmp_buf+6))<<16)+
			(*((u8 *)(tmp_buf+7))<<24);

		otg.up_ptr=(u8 *)otg.up_addr;
		DBG_BULK1("UploadAddress : 0x%x, UploadSize: %d\n",
			otg.up_addr, otg.up_size);

#ifdef CONFIG_USB_CPUMODE
		if (otg.op_mode == USB_CPU) {
			if (otg.up_size > otg.bulkin_max_pktsize) {
				s3c_usb_set_inep_xfersize(EP_TYPE_BULK, 1,
					otg.bulkin_max_pktsize);
			} else {
				s3c_usb_set_inep_xfersize(EP_TYPE_BULK, 1,
					otg.up_size);
			}

			/*ep1 enable, clear nak, bulk, usb active, max pkt 64*/
			writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkin_max_pktsize<<0,
				S5P_OTG_DIEPCTL_IN);
		} else if ((otg.op_mode == USB_DMA) && (otg.up_size > 0)) {
			u32 pktcnt, remainder;

			DBG_BULK1("Dma Start for IN PKT \n");

			writel(MODE_DMA|BURST_INCR4|GBL_INT_UNMASK,
				S5P_OTG_GAHBCFG);
			writel(INT_RESUME|INT_OUT_EP|INT_IN_EP| INT_ENUMDONE|
				INT_RESET|INT_SUSPEND, S5P_OTG_GINTMSK);

			writel((u32)otg.up_ptr, S5P_OTG_DIEPDMA_IN);

			pktcnt = (u32)(otg.up_size/otg.bulkin_max_pktsize);
			remainder = (u32)(otg.up_size%otg.bulkin_max_pktsize);
			if(remainder != 0) {
				pktcnt += 1;
			}

			if (pktcnt > 1023) {
				s3c_usb_set_inep_xfersize(EP_TYPE_BULK, 1023,
					(otg.bulkin_max_pktsize*1023));
			} else {
				s3c_usb_set_inep_xfersize(EP_TYPE_BULK, pktcnt,
					otg.up_size);
			}

			/*ep1 enable, clear nak, bulk, usb active, next ep1, max pkt */
			writel(1u<<31|1<<26|2<<18|1<<15|BULK_IN_EP<<11|
				otg.bulkin_max_pktsize<<0,
				S5P_OTG_DIEPCTL_IN);
#else
	if (otg.up_size > 0) {
			DBG_BULK1("Dma Start for IN PKT \n");
			if(otg.up_size<BULK_XFER_SIZE)
				written_bytes = otg.up_size;
			else
				written_bytes = BULK_XFER_SIZE;
			s3c_usb_bulk_inep_setdma(otg.up_ptr, written_bytes);
#endif
		}
	}
	otg.dn_filesize=0;
}

#ifdef CONFIG_USB_CPUMODE

void s3c_usb_download_start(u32 fifo_cnt_byte)
{
	u8 tmp_buf[8];

	s3c_usb_read_out_fifo((u8 *)tmp_buf, 8);
	DBG_BULK1("downloadFileSize==0, 1'st BYTE_READ_CNT_REG : %x\n",
		fifo_cnt_byte);

	otg.dn_addr=s3c_usbd_dn_addr;
	otg.dn_filesize=
		*((u8 *)(tmp_buf+4))+
		(*((u8 *)(tmp_buf+5))<<8)+
		(*((u8 *)(tmp_buf+6))<<16)+
		(*((u8 *)(tmp_buf+7))<<24);

	otg.dn_ptr=(u8 *)otg.dn_addr;
	DBG_BULK1("downloadAddress : 0x%x, downloadFileSize: %x\n",
		otg.dn_addr, otg.dn_filesize);

	/* The first 8-bytes are deleted.*/
	s3c_usb_read_out_fifo((u8 *)otg.dn_ptr, fifo_cnt_byte-8);
	otg.dn_ptr += fifo_cnt_byte-8;

	if (otg.op_mode == USB_CPU) {
		s3c_usb_set_outep_xfersize(EP_TYPE_BULK, 1,
			otg.bulkout_max_pktsize);

		/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
		writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkout_max_pktsize<<0,
		S5P_OTG_DOEPCTL_OUT);
	} else if (otg.dn_filesize>otg.bulkout_max_pktsize) {
		u32 pkt_cnt, remain_cnt;

		DBG_BULK1("downloadFileSize!=0, Dma Start for 2nd OUT PKT \n");
		writel(INT_RESUME|INT_OUT_EP|INT_IN_EP|INT_ENUMDONE|
			INT_RESET|INT_SUSPEND, S5P_OTG_GINTMSK); /*gint unmask */
		writel(MODE_DMA|BURST_INCR4|GBL_INT_UNMASK,
			S5P_OTG_GAHBCFG);
		writel((u32)otg.dn_ptr, S5P_OTG_DOEPDMA_OUT);
		pkt_cnt = (u32)(otg.dn_filesize-otg.bulkout_max_pktsize)/otg.bulkout_max_pktsize;
		remain_cnt = (u32)((otg.dn_filesize-otg.bulkout_max_pktsize)%otg.bulkout_max_pktsize);
		if(remain_cnt != 0) {
			pkt_cnt += 1;
		}

		if (pkt_cnt > 1023) {
			s3c_usb_set_outep_xfersize(EP_TYPE_BULK, 1023,
				(otg.bulkout_max_pktsize*1023));
		} else {
			s3c_usb_set_outep_xfersize(EP_TYPE_BULK, pkt_cnt,
				(otg.dn_filesize-otg.bulkout_max_pktsize));
		}

		/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
		writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkout_max_pktsize<<0,
			S5P_OTG_DOEPCTL_OUT);
	}
}

void s3c_usb_download_continue(u32 fifo_cnt_byte)
{
	if (otg.op_mode == USB_CPU) {
		s3c_usb_read_out_fifo((u8 *)otg.dn_ptr, fifo_cnt_byte);
		otg.dn_ptr += fifo_cnt_byte;
		DBG_BULK1("downloadFileSize!=0, 2nd BYTE_READ_CNT_REG = 0x%x, m_pDownPt = 0x%x\n",
				fifo_cnt_byte, otg.dn_ptr);

		s3c_usb_set_outep_xfersize(EP_TYPE_BULK, 1, otg.bulkout_max_pktsize);

		/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
		writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkout_max_pktsize<<0,
			S5P_OTG_DOEPCTL_OUT);

		/* USB format : addr(4)+size(4)+data(n)+cs(2) */
		if (((u32)otg.dn_ptr - otg.dn_addr) >= (otg.dn_filesize - 8)) {
			printf("Download Done!! Download Address: 0x%x, Download Filesize:0x%x\n",
				otg.dn_addr, (otg.dn_filesize-10));

			s3c_usbd_dn_cnt 	= otg.dn_filesize-10;
			s3c_usbd_dn_addr	= otg.dn_addr;

#ifdef USB_CHECKSUM_EN
			s3c_usb_verify_checksum();
#endif
			s3c_receive_done = 1;
		}

	}\
}

void s3c_usb_int_bulkout(u32 fifo_cnt_byte)
{
	DBG_BULK0("Bulk Out Function : otg.dn_filesize=0x%x\n", otg.dn_filesize);
	if (otg.dn_filesize==0) {
		if (fifo_cnt_byte == 10) {
			s3c_usb_upload_start();
		} else {
			s3c_usb_download_start(fifo_cnt_byte);
		}
	} else {
		s3c_usb_download_continue(fifo_cnt_byte);
	}
}
#else
void s3c_usb_download_start(void)
{
	otg.dn_addr=s3c_usbd_dn_addr;
	otg.dn_filesize=
		*((u8 *)(tmp_buf+4))+
		(*((u8 *)(tmp_buf+5))<<8)+
		(*((u8 *)(tmp_buf+6))<<16)+
		(*((u8 *)(tmp_buf+7))<<24);

	otg.dn_ptr=(u8 *)otg.dn_addr;
	DBG_BULK1("downloadAddress : 0x%x, downloadFileSize: %x\n",
		otg.dn_addr, otg.dn_filesize);


	memcpy((u8 *)otg.dn_ptr, (u8 *)(tmp_buf+8), HS_BULK_PKT_SIZE - 8);
	/* The first 8-bytes are deleted.*/
	otg.dn_ptr += HS_BULK_PKT_SIZE - 8;

	/* USB format : addr(4)+size(4)+data(n)+cs(2) */
	if (otg.dn_filesize>((u32)otg.dn_ptr - otg.dn_addr + 8)) {
		s3c_usb_bulk_outep_setdma((u8 *)otg.dn_ptr, BULK_XFER_SIZE);
	}
	else {
#ifdef USB_CHECKSUM_EN
		s3c_usb_verify_checksum();
#endif
		s3c_receive_done = 1;
		printf("Download Done!! Download Address: 0x%x, Download Filesize:0x%x\n",
				otg.dn_addr, (otg.dn_filesize-10));
	}
}

void s3c_usb_download_continue(void)
{

	u32 xfer_size;

	xfer_size = readl(S5P_OTG_DOEPTSIZ_OUT) & 0x7FFF;
	otg.dn_ptr += (BULK_XFER_SIZE - xfer_size);

	/* USB format : addr(4)+size(4)+data(n)+cs(2) */
	if (otg.dn_filesize>((u32)otg.dn_ptr - otg.dn_addr + 8))
		s3c_usb_bulk_outep_setdma((u8 *)otg.dn_ptr, BULK_XFER_SIZE);
	else {
#ifdef USB_CHECKSUM_EN
			s3c_usb_verify_checksum();
#endif
		s3c_receive_done = 1;
		printf("Download Done!! Download Address: 0x%x, Download Filesize:0x%x\n",
				otg.dn_addr, (otg.dn_filesize-10));
	}
}

void s3c_usb_int_bulkout(void)
{
	u32 xfer_size;
	DBG_BULK0("Bulk Out Function : otg.dn_filesize=0x%x\n", otg.dn_filesize);

	xfer_size = readl(S5P_OTG_DOEPTSIZ_OUT) & 0x7FFF;
	if (otg.dn_filesize==0) {
		if (xfer_size == 0x1F6) {
			s3c_usb_upload_start();
		} else {
			s3c_usb_download_start();
		}
	} else {
		s3c_usb_download_continue();
	}
}
#endif

void s3c_usb_dma_in_done(void)
{
	s32 remain_cnt;

	DBG_BULK0("DMA IN : Transfer Done\n");

	otg.up_ptr = (u8 *)readl(S5P_OTG_DIEPDMA_IN);
	remain_cnt = otg.up_size- ((u32)otg.up_ptr - otg.up_addr);

	if (remain_cnt>0) {
		u32 pktcnt, remainder;
		pktcnt = (u32)(remain_cnt/otg.bulkin_max_pktsize);
		remainder = (u32)(remain_cnt%otg.bulkin_max_pktsize);
		if(remainder != 0) {
			pktcnt += 1;
		}
		DBG_SETUP1("remain_cnt : %d \n", remain_cnt);
		if (pktcnt> 1023) {
			s3c_usb_set_inep_xfersize(EP_TYPE_BULK, 1023,
				(otg.bulkin_max_pktsize*1023));
		} else {
			s3c_usb_set_inep_xfersize(EP_TYPE_BULK, pktcnt,
				remain_cnt);
		}

		/*ep1 enable, clear nak, bulk, usb active, next ep1, max pkt */
		writel(1u<<31|1<<26|2<<18|1<<15|BULK_IN_EP<<11|otg.bulkin_max_pktsize<<0,
			S5P_OTG_DIEPCTL_IN);
	} else
		DBG_SETUP1("DMA IN : Transfer Complete\n");
}

#ifdef CONFIG_USB_CPUMODE
void s3c_usb_dma_out_done(void)
{
	s32 remain_cnt;

	DBG_BULK1("DMA OUT : Transfer Done\n");
	otg.dn_ptr = (u8 *)readl(S5P_OTG_DOEPDMA_OUT);

	remain_cnt = otg.dn_filesize - ((u32)otg.dn_ptr - otg.dn_addr + 8);

	if (remain_cnt>0) {
		u32 pktcnt, remainder;
		pktcnt = (u32)(remain_cnt/otg.bulkout_max_pktsize);
		remainder = (u32)(remain_cnt%otg.bulkout_max_pktsize);
		if(remainder != 0) {
			pktcnt += 1;
		}
		DBG_BULK1("remain_cnt : %d \n", remain_cnt);
		if (pktcnt> 1023) {
			s3c_usb_set_outep_xfersize(EP_TYPE_BULK, 1023,
				(otg.bulkout_max_pktsize*1023));
		} else {
			s3c_usb_set_outep_xfersize(EP_TYPE_BULK, pktcnt,
				remain_cnt);
		}

		/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
		writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkout_max_pktsize<<0,
			S5P_OTG_DOEPCTL_OUT);
	} else {
		DBG_BULK1("DMA OUT : Transfer Complete\n");
		udelay(500);		/*for FPGA ???*/
	}
}
#endif

void s3c_usb_set_all_outep_nak(void)
{
	u8 i = 0;
	u32 tmp;

	for(i=0;i<16;i++)
	{
		tmp = readl(S5P_OTG_DOEPCTL0+0x20*i);
		tmp |= DEPCTL_SNAK;
		writel(tmp, S5P_OTG_DOEPCTL0+0x20*i);
	}
}

void s3c_usb_clear_all_outep_nak(void)
{
	u8 i = 0;
	u32 tmp;

	for(i=0;i<16;i++)
	{
		tmp = readl(S5P_OTG_DOEPCTL0+0x20*i);
		tmp |= (DEPCTL_EPENA|DEPCTL_CNAK);
		writel(tmp, S5P_OTG_DOEPCTL0+0x20*i);
	}
}

void s3c_usb_set_max_pktsize(USB_SPEED speed)
{
	if (speed == USB_HIGH)
	{
		otg.speed = USB_HIGH;
		otg.ctrl_max_pktsize = HS_CTRL_PKT_SIZE;
		otg.bulkin_max_pktsize = HS_BULK_PKT_SIZE;
		otg.bulkout_max_pktsize = HS_BULK_PKT_SIZE;
	}
	else
	{
		otg.speed = USB_FULL;
		otg.ctrl_max_pktsize = FS_CTRL_PKT_SIZE;
		otg.bulkin_max_pktsize = FS_BULK_PKT_SIZE;
		otg.bulkout_max_pktsize = FS_BULK_PKT_SIZE;
	}
}

void s3c_usb_set_endpoint(void)
{
	/* Unmask S5P_OTG_DAINT source */
	writel(0xff, S5P_OTG_DIEPINT0);
	writel(0xff, S5P_OTG_DOEPINT0);
	writel(0xff, S5P_OTG_DIEPINT_IN);
	writel(0xff, S5P_OTG_DOEPINT_OUT);

	/* Init For Ep0*/
#ifdef CONFIG_USB_CPUMODE
	/*MPS:64bytes */
	writel(((1<<26)|(CONTROL_EP<<11)|(0<<0)), S5P_OTG_DIEPCTL0);
	/*ep0 enable, clear nak */
	writel((1u<<31)|(1<<26)|(0<<0), S5P_OTG_DOEPCTL0);
#else
        if(otg.speed == USB_HIGH)
        {
                /*MPS:64bytes */
		writel(((1<<26)|(CONTROL_EP<<11)|(0<<0)), S5P_OTG_DIEPCTL0);
                s3c_usb_prepare_setup_pkt();
        }
        else
        {
                /*MPS:8bytes */
                writel(((1<<26)|(CONTROL_EP<<11)|(3<<0)), S5P_OTG_DIEPCTL0);
                /*ep0 enable, clear nak */
                writel((1u<<31)|(1<<26)|(3<<0), S5P_OTG_DOEPCTL0);
        }
#endif
}

void s3c_usb_set_descriptors(void)
{
	/* Standard device descriptor */
	otg.desc.dev.bLength=DEVICE_DESC_SIZE;	/*0x12*/
	otg.desc.dev.bDescriptorType=DEVICE_DESCRIPTOR;
	otg.desc.dev.bDeviceClass=0xFF; /* 0x0*/
	otg.desc.dev.bDeviceSubClass=0x0;
	otg.desc.dev.bDeviceProtocol=0x0;
	otg.desc.dev.bMaxPacketSize0=otg.ctrl_max_pktsize;
	otg.desc.dev.idVendorL=0xE8;	/*0x45;*/
	otg.desc.dev.idVendorH=0x04;	/*0x53;*/
	otg.desc.dev.idProductL=0x34; /*0x00*/
	otg.desc.dev.idProductH=0x12; /*0x64*/
	otg.desc.dev.bcdDeviceL=0x00;
	otg.desc.dev.bcdDeviceH=0x01;
	otg.desc.dev.iManufacturer=0x1; /* index of string descriptor */
	otg.desc.dev.iProduct=0x2;	/* index of string descriptor */
	otg.desc.dev.iSerialNumber=0x0;
	otg.desc.dev.bNumConfigurations=0x1;
	if (otg.speed == USB_FULL) {
		otg.desc.dev.bcdUSBL=0x10;
		otg.desc.dev.bcdUSBH=0x01;	/* Ver 1.10*/
	}
	else {
		otg.desc.dev.bcdUSBL=0x00;
		otg.desc.dev.bcdUSBH=0x02;	/* Ver 2.0*/
	}

	/* Standard configuration descriptor */
	otg.desc.config.bLength=CONFIG_DESC_SIZE; /* 0x9 bytes */
	otg.desc.config.bDescriptorType=CONFIGURATION_DESCRIPTOR;
	otg.desc.config.wTotalLengthL=CONFIG_DESC_TOTAL_SIZE;
	otg.desc.config.wTotalLengthH=0;
	otg.desc.config.bNumInterfaces=1;
/* dbg	  descConf.bConfigurationValue=2; // why 2? There's no reason.*/
	otg.desc.config.bConfigurationValue=1;
	otg.desc.config.iConfiguration=0;
	otg.desc.config.bmAttributes=CONF_ATTR_DEFAULT|CONF_ATTR_SELFPOWERED; /* bus powered only.*/
	otg.desc.config.maxPower=25; /* draws 50mA current from the USB bus.*/

	/* Standard interface descriptor */
	otg.desc.intf.bLength=INTERFACE_DESC_SIZE; /* 9*/
	otg.desc.intf.bDescriptorType=INTERFACE_DESCRIPTOR;
	otg.desc.intf.bInterfaceNumber=0x0;
	otg.desc.intf.bAlternateSetting=0x0; /* ?*/
	otg.desc.intf.bNumEndpoints = 2;	/* # of endpoints except EP0*/
	otg.desc.intf.bInterfaceClass=0xff; /* 0x0 ?*/
	otg.desc.intf.bInterfaceSubClass=0x0;
	otg.desc.intf.bInterfaceProtocol=0x0;
	otg.desc.intf.iInterface=0x0;

	/* Standard endpoint0 descriptor */
	otg.desc.ep1.bLength=ENDPOINT_DESC_SIZE;
	otg.desc.ep1.bDescriptorType=ENDPOINT_DESCRIPTOR;
	otg.desc.ep1.bEndpointAddress=BULK_IN_EP|EP_ADDR_IN;
	otg.desc.ep1.bmAttributes=EP_ATTR_BULK;
	otg.desc.ep1.wMaxPacketSizeL=(u8)otg.bulkin_max_pktsize; /* 64*/
	otg.desc.ep1.wMaxPacketSizeH=(u8)(otg.bulkin_max_pktsize>>8);
	otg.desc.ep1.bInterval=0x0; /* not used */

	/* Standard endpoint1 descriptor */
	otg.desc.ep2.bLength=ENDPOINT_DESC_SIZE;
	otg.desc.ep2.bDescriptorType=ENDPOINT_DESCRIPTOR;
	otg.desc.ep2.bEndpointAddress=BULK_OUT_EP|EP_ADDR_OUT;
	otg.desc.ep2.bmAttributes=EP_ATTR_BULK;
	otg.desc.ep2.wMaxPacketSizeL=(u8)otg.bulkout_max_pktsize; /* 64*/
	otg.desc.ep2.wMaxPacketSizeH=(u8)(otg.bulkout_max_pktsize>>8);
	otg.desc.ep2.bInterval=0x0; /* not used */
}

void s3c_usb_check_speed(USB_SPEED *speed)
{
	u32 status;

	status = readl(S5P_OTG_DSTS); /* System status read */

	*speed = (USB_SPEED)((status&0x6) >>1);
}

void s3c_usb_clear_dnfile_info(void)
{
	otg.dn_addr = 0;
	otg.dn_filesize = 0;
	otg.dn_ptr = 0;
}

void s3c_usb_clear_upfile_info(void)
{
	otg.up_addr= 0;
	otg.up_size= 0;
	otg.up_ptr = 0;
}


int s3c_usb_check_setconf(void)
{
	if (otg.set_config == 0)
		return FALSE;
	else
		return TRUE;
}

void s3c_usb_set_opmode(USB_OPMODE mode)
{
	otg.op_mode = mode;

#ifdef CONFIG_USB_CPUMODE
	writel(INT_RESUME|INT_OUT_EP|INT_IN_EP|INT_ENUMDONE|
		INT_RESET|INT_SUSPEND|INT_RX_FIFO_NOT_EMPTY,
		S5P_OTG_GINTMSK); /*gint unmask */

	writel(MODE_SLAVE|BURST_SINGLE|GBL_INT_UNMASK, S5P_OTG_GAHBCFG);

	s3c_usb_set_outep_xfersize(EP_TYPE_BULK, 1, otg.bulkout_max_pktsize);
	s3c_usb_set_inep_xfersize(EP_TYPE_BULK, 1, 0);

	/*bulk out ep enable, clear nak, bulk, usb active, next ep3, max pkt */
	writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkout_max_pktsize<<0,
		S5P_OTG_DOEPCTL_OUT);

	/*bulk in ep enable, clear nak, bulk, usb active, next ep1, max pkt */
	writel(0u<<31|1<<26|2<<18|1<<15|otg.bulkin_max_pktsize<<0,
		S5P_OTG_DIEPCTL_IN);
#else
	writel(INT_RESUME|INT_OUT_EP|INT_IN_EP|INT_ENUMDONE|
		INT_RESET|INT_SUSPEND,
		S5P_OTG_GINTMSK); /*gint unmask */

	writel(PTXFE_HALF|NPTXFE_HALF|MODE_DMA|BURST_INCR4|GBL_INT_UNMASK, S5P_OTG_GAHBCFG);
#endif
}

void s3c_usb_reset(void)
{
	s3c_usb_set_all_outep_nak();

	otg.ep0_state = EP0_STATE_INIT;
	writel(((1<<BULK_OUT_EP)|(1<<CONTROL_EP))<<16|((1<<BULK_IN_EP)|(1<<CONTROL_EP)),
		S5P_OTG_DAINTMSK);
	writel(CTRL_OUT_EP_SETUP_PHASE_DONE|AHB_ERROR|TRANSFER_DONE,
		S5P_OTG_DOEPMSK);
	writel(INTKN_TXFEMP|NON_ISO_IN_EP_TIMEOUT|AHB_ERROR|TRANSFER_DONE,
		S5P_OTG_DIEPMSK);

	/* Rx FIFO Size */
	writel(RX_FIFO_SIZE, S5P_OTG_GRXFSIZ);

	/* Non Periodic Tx FIFO Size */
	writel(NPTX_FIFO_SIZE<<16| NPTX_FIFO_START_ADDR<<0, S5P_OTG_GNPTXFSIZ);
#ifndef CONFIG_USB_CPUMODE
	writel(PTX_FIFO_SIZE<<16|(NPTX_FIFO_START_ADDR+NPTX_FIFO_SIZE)<<0, S5P_OTG_DPTXFSIZ1);
#endif

	s3c_usb_clear_all_outep_nak();

	/*clear device address */
	writel(readl(S5P_OTG_DCFG)&~(0x7f<<4), S5P_OTG_DCFG);

	if(SUSPEND_RESUME_ON) {
		writel(readl(S5P_OTG_PCGCCTL)&~(1<<0), S5P_OTG_PCGCCTL);
	}
}
int s3c_usb_set_init(void)
{
	u32 status;

	status = readl(S5P_OTG_DSTS); /* System status read */

	/* Set if Device is High speed or Full speed */
	if (((status&0x6) >>1) == USB_HIGH) {
		DBG_SETUP1("High Speed Detection\n");
		s3c_usb_set_max_pktsize(USB_HIGH);
	}
	else if(((status&0x6) >>1) == USB_FULL) {
		DBG_SETUP1("Full Speed Detec tion\n");
		s3c_usb_set_max_pktsize(USB_FULL);
	}
	else {
		printf("**** Error:Neither High_Speed nor Full_Speed\n");
		return FALSE;
	}

	s3c_usb_set_endpoint();
	if (is_fastboot)
		fboot_usb_set_descriptors();
	else
		s3c_usb_set_descriptors();
	s3c_usb_clear_dnfile_info();
	s3c_usb_set_opmode(op_mode);

	return TRUE;
}

#ifdef CONFIG_USB_CPUMODE
void s3c_usb_pkt_receive(void)
{
	u32 rx_status;
	u32 fifo_cnt_byte;

	rx_status = readl(S5P_OTG_GRXSTSP);
	DBG_SETUP0("S5P_OTG_GRXSTSP = 0x%x\n", rx_status);

	if ((rx_status & (0xf<<17)) == SETUP_PKT_RECEIVED) {
		DBG_SETUP1("SETUP_PKT_RECEIVED\n");
		s3c_usb_ep0_int_hndlr();

	} else if ((rx_status & (0xf<<17)) == OUT_PKT_RECEIVED) {
		fifo_cnt_byte = (rx_status & 0x7ff0)>>4;
		DBG_SETUP1("OUT_PKT_RECEIVED\n");

		if((rx_status & BULK_OUT_EP)&&(fifo_cnt_byte)) {
			if (is_fastboot)
				fboot_usb_int_bulkout(fifo_cnt_byte);
			else
				s3c_usb_int_bulkout(fifo_cnt_byte);
			if( otg.op_mode == USB_CPU )
				writel(INT_RESUME|INT_OUT_EP|INT_IN_EP|
					INT_ENUMDONE|INT_RESET|INT_SUSPEND|
					INT_RX_FIFO_NOT_EMPTY,
					S5P_OTG_GINTMSK);
			return;
		}

	} else if ((rx_status & (0xf<<17)) == GLOBAL_OUT_NAK) {
		DBG_SETUP1("GLOBAL_OUT_NAK\n");

	} else if ((rx_status & (0xf<<17)) == OUT_TRNASFER_COMPLETED) {
		DBG_SETUP1("OUT_TRNASFER_COMPLETED\n");

	} else if ((rx_status & (0xf<<17)) == SETUP_TRANSACTION_COMPLETED) {
		DBG_SETUP1("SETUP_TRANSACTION_COMPLETED\n");

	} else {
		DBG_SETUP1("Reserved\n");
	}
}
#endif

void s3c_usb_transfer(void)
{
	u32 ep_int;
	u32 check_dma;
	u32 ep_int_status;

	ep_int = readl(S5P_OTG_DAINT);
	DBG_SETUP0("S5P_OTG_DAINT = 0x%x", ep_int);

	if (ep_int & (1<<CONTROL_EP)) {
		ep_int_status = readl(S5P_OTG_DIEPINT0);
		DBG_SETUP1("S5P_OTG_DIEPINT0 : %x \n", ep_int_status);

#ifdef CONFIG_USB_CPUMODE
		if (ep_int_status & INTKN_TXFEMP) {
			u32 uNTxFifoSpace;
			do {
				uNTxFifoSpace=readl(S5P_OTG_GNPTXSTS)&0xffff;
			}while(uNTxFifoSpace<otg.ctrl_max_pktsize);

			s3c_usb_transfer_ep0();
#else
		if(ep_int_status & TRANSFER_DONE) {
			s3c_usb_prepare_setup_pkt();
#endif
		}

		writel(ep_int_status, S5P_OTG_DIEPINT0); /* Interrupt Clear */
	} else if (ep_int & ((1<<CONTROL_EP)<<16)) {
		ep_int_status = readl(S5P_OTG_DOEPINT0);
		DBG_SETUP1("S5P_OTG_DOEPINT0 : %x \n", ep_int_status);

#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_outep_xfersize(EP_TYPE_CONTROL, 1, 8);
		writel(1u<<31|1<<26, S5P_OTG_DOEPCTL0); /*ep0 enable, clear nak */

#else
		if(ep_int_status & CTRL_OUT_EP_SETUP_PHASE_DONE) {	
			s3c_usb_ep0_int_hndlr();
		}
		if(ep_int_status & TRANSFER_DONE) {
			s3c_usb_prepare_setup_pkt();
		}
#endif
		writel(ep_int_status, S5P_OTG_DOEPINT0); /* Interrupt Clear */
	} else if(ep_int & (1<<BULK_IN_EP)) {
		ep_int_status = readl(S5P_OTG_DIEPINT_IN);
		DBG_BULK1("S5P_OTG_DIEPINT_IN : %x \n", ep_int_status);
		writel(ep_int_status, S5P_OTG_DIEPINT_IN); /* Interrupt Clear */

#ifdef CONFIG_USB_CPUMODE
		if ( (ep_int_status&INTKN_TXFEMP) && otg.op_mode == USB_CPU) {
			if (is_fastboot)
				fboot_usb_int_bulkin();
			else
				s3c_usb_int_bulkin();
		}

		check_dma = readl(S5P_OTG_GAHBCFG);
		if ((check_dma&MODE_DMA)&&(ep_int_status&TRANSFER_DONE))
			s3c_usb_dma_in_done();
#else
		check_dma = readl(S5P_OTG_GAHBCFG);
		if ((check_dma&MODE_DMA)&&(ep_int_status&TRANSFER_DONE)) {
			if (is_fastboot)
				fboot_response_flag=0;
			else
				s3c_usb_upload_continue();
		}
#endif
	} else if (ep_int & ((1<<BULK_OUT_EP)<<16)) {
		ep_int_status = readl(S5P_OTG_DOEPINT_OUT);
		DBG_BULK1("S5P_OTG_DOEPINT_OUT : 0x%x\n", ep_int_status);
		writel(ep_int_status, S5P_OTG_DOEPINT_OUT); /* Interrupt Clear */

		check_dma = readl(S5P_OTG_GAHBCFG);
		if ((check_dma&MODE_DMA)&&(ep_int_status&TRANSFER_DONE)) {
#ifdef CONFIG_USB_CPUMODE
			s3c_usb_dma_out_done();
#else
			if (is_fastboot)
				fboot_usb_int_bulkout();
			else
				s3c_usb_int_bulkout();
#endif
		}
	}
}

int s3c_udc_int_hndlr(void)
{
	u32 int_status;
	int tmp;
	int ret = ERROR;

	int_status = readl(S5P_OTG_GINTSTS); /* Core Interrupt Register */
	writel(int_status, S5P_OTG_GINTSTS); /* Interrupt Clear */
	DBG_SETUP0("*** USB OTG Interrupt(S5P_OTG_GINTSTS: 0x%08x) ****\n",
		int_status);

	if (int_status & INT_RESET) {
		DBG_SETUP1("INT_RESET\n");
		writel(INT_RESET, S5P_OTG_GINTSTS); /* Interrupt Clear */

		s3c_usb_reset();
		ret = OK;
	}

	if (int_status & INT_ENUMDONE) {
		DBG_SETUP1("INT_ENUMDONE :");
		writel(INT_ENUMDONE, S5P_OTG_GINTSTS); /* Interrupt Clear */

		tmp = s3c_usb_set_init();
		ret = OK;
		if (tmp == FALSE)
			return ret;
	}

	if (int_status & INT_RESUME) {
		DBG_SETUP1("INT_RESUME\n");
		writel(INT_RESUME, S5P_OTG_GINTSTS); /* Interrupt Clear */

		if(SUSPEND_RESUME_ON) {
			writel(readl(S5P_OTG_PCGCCTL)&~(1<<0), S5P_OTG_PCGCCTL);
			DBG_SETUP1("INT_RESUME\n");
		}
		ret = OK;
	}

	if (int_status & INT_SUSPEND) {
		DBG_SETUP1("INT_SUSPEND\n");
		writel(INT_SUSPEND, S5P_OTG_GINTSTS); /* Interrupt Clear */

		if(SUSPEND_RESUME_ON) {
			writel(readl(S5P_OTG_PCGCCTL)|(1<<0), S5P_OTG_PCGCCTL);
		}
		ret = OK;
	}

#ifdef CONFIG_USB_CPUMODE
	if(int_status & INT_RX_FIFO_NOT_EMPTY) {
		DBG_SETUP1("INT_RX_FIFO_NOT_EMPTY\n");
		/* Read only register field */

		writel(INT_RESUME|INT_OUT_EP|INT_IN_EP|
			INT_ENUMDONE|INT_RESET|INT_SUSPEND,
			S5P_OTG_GINTMSK);
		s3c_usb_pkt_receive();
		writel(INT_RESUME|INT_OUT_EP|INT_IN_EP|INT_ENUMDONE|
			INT_RESET |INT_SUSPEND|INT_RX_FIFO_NOT_EMPTY,
			S5P_OTG_GINTMSK); /*gint unmask */
		ret = OK;
	}
#endif

	if ((int_status & INT_IN_EP) || (int_status & INT_OUT_EP)) {
		DBG_SETUP1("INT_IN or OUT_EP\n");
		/* Read only register field */

		s3c_usb_transfer();
		ret = OK;
	}
	return ret;
}

#endif
