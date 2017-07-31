/*
 * drivers/usb/gadget/usbd3-ss.c
 *
 * (C) Copyright 2011
 * Yulgon Kim, Samsung Erectronics, yulgon.kim@samsung.com.
 *	- only support for EXYNOS5210
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
#include <malloc.h>

#if defined(CONFIG_ARCH_EXYNOS5)
#include <command.h>
#include <asm/arch/cpu.h>
#include <asm/arch/clk.h>
#include "usbd3-ss.h"

#undef USBD3_DBG
#ifdef USBD3_DBG
#define DBG_USBD3(fmt, args...)	DBG_USBD3("[%s:%d] " fmt, __FUNCTION__, __LINE__, ##args)
#else
#define DBG_USBD3(fmt, args...) do { } while (0)
#endif

#define Assert(value) value ? : printf("[%s:%d] Assert(%d) \n", __func__, __LINE__, value)

#define USBDEVICE3_LINK_BASE		(oUsbDev3.m_uLinkBaseRegs)
#define USBDEVICE3_PHYCTRL_BASE		(oUsbDev3.m_uPhyBaseRegs)

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

const u8 set_sel[6];

/*32 <cfg desc>+<if desc>+<endp0 desc>+<endp1 desc>*/
#define CONFIG_DESC_TOTAL_SIZE	\
	(CONFIG_DESC_SIZE+INTERFACE_DESC_SIZE+ENDPOINT_DESC_SIZE*2)
#define CONFIG_SS_DESC_TOTAL_SIZE	\
	(CONFIG_DESC_SIZE+INTERFACE_DESC_SIZE+ENDPOINT_DESC_SIZE*2+ENDPOINT_COMP_DESC_SIZE*2)
#define BOS_DESC_TOTAL_SIZE	\
	(BOS_DESC_SIZE+USB20_EXT_CAP_DESC_SIZE+SUPER_CAP_DESC_SIZE+CONTAIN_CAP_DESC_SIZE)
#define TEST_PKT_SIZE 53

#define USB_CAP_20_EXT  0x2
#define USB_CAP_SS      0x3
#define USB_CAP_CID     0x4

#define USB_PHY_REF_CLK (EXTREF_24MHz)

#define CONFIG_PHY_CRPORT

u8 test_pkt [TEST_PKT_SIZE] = {
	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,	/*JKJKJKJK x 9*/
	0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,0xAA,	/*JJKKJJKK x 8*/
	0xEE,0xEE,0xEE,0xEE,0xEE,0xEE,0xEE,0xEE,	/*JJJJKKKK x 8*/
	0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,	/*JJJJJJJKKKKKKK x8 - '1'*/
	0x7F,0xBF,0xDF,0xEF,0xF7,0xFB,0xFD,		/*'1' + JJJJJJJK x 8*/
	0xFC,0x7E,0xBF,0xDF,0xEF,0xF7,0xFB,0xFD,0x7E	/*{JKKKKKKK x 10},JK*/
};

//=====================================================================
// global varibles used in several functions
USBDEV3 oUsbDev3;
USB_GET_STATUS oStatusGet;
USB_INTERFACE_GET oInterfaceGet;

u16 g_usConfig;
u16 g_usUploadPktLength=0;
u8 g_bTransferEp0 = 0;

u8 g_bSuspendResumeDBG_USBD3;

u8 g_bUsingUsbDownAddr = 0;
u32 g_uUsbDownAddr = 0;

u32 *g_uUsbDevCtrlInBufferPtr=NULL;
u32 *g_uUsbDevCtrlOutBufferPtr=NULL;
u32 *g_uUsbDevBulkOutTmpBufferPtr=NULL;
u32 *g_uUsbDevBulkOutBufferPtr=NULL;
u8 bCalled_SetEndPoint = 0;

volatile usbdev3_trb_ptr_t g_pBulkOutTrb0;

volatile usbdev3_trb_ptr_t g_pBulkOutTrbArray_Base;
volatile usbdev3_trb_ptr_t g_pBulkInTrbArray_Base;

u8 *g_ucTempDownBuf;
u32 g_uCntOfDescOutComplete = 0;
u32 g_uCntOfBulkOutTrb, g_uCntOfBulkInTrb;
u8 g_bIsBulkOutXferDone = 0;
u8 g_bIsBulkInXferDone = 0;

//=====================================================================
// For usb download

unsigned int exynos_usbd_dn_addr = 0;
unsigned int exynos_usbd_dn_cnt = 0;
int is_fastboot = 0;
int DNW;
int exynos_got_header = 0;
int exynos_receive_done = 0;

extern ulong virt_to_phy_exynos5210(ulong addr);
static u32 exynos_usb_malloc(u32 uSize, u32 uAlign);
static void exynos_usb_free(u32 uAddr);
static void exynos_usb_fill_trb(usbdev3_trb_ptr_t pTrb, u32 uBufAddr, u32 uLen, u32 uTrbCtrl, u32 uHwo);
static int exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_e eEpDir, u8 ucEpNum, u32 uTrbAddr, u32 uStrmidSofn, u32 *uTri);

u32 EXYNOS_USBD_DETECT_IRQ(void)
{
	if (oUsbDev3.m_cable != CONNECTED)
		return 0;

	return readl(rGEVNTCOUNT0);
}

void EXYNOS_USBD_CLEAR_IRQ(void)
{
	do {
		;
	} while (0);
}

#include "fastboot-ss.c"

void exynos_usb_phy_on(void)
{
	writel(0x1, USB_DEVICE_PHY_CONTROL);
	writel(0x1, USB_DEVICE1_PHY_CONTROL);
}

static void exynoy_usb_phy_off(void)
{
	usb3_phy_utmi_t usbdev3_phy_utmi;

	usbdev3_phy_utmi.data = 0x0;
	usbdev3_phy_utmi.b.otg_disable = 0x1;
	usbdev3_phy_utmi.b.force_sleep = 0x1;
	usbdev3_phy_utmi.b.force_suspend = 0x1;

	oUsbDev3.m_uPhyBaseRegs = USBDEVICE3_PHYCTRL_CH0_BASE;
	writel(usbdev3_phy_utmi.data, EXYNOS_PHY_UTMI);
	oUsbDev3.m_uPhyBaseRegs = USBDEVICE3_PHYCTRL_CH1_BASE;
	writel(usbdev3_phy_utmi.data, EXYNOS_PHY_UTMI);

	writel(0x0, USB_DEVICE_PHY_CONTROL);
	writel(0x0, USB_DEVICE1_PHY_CONTROL);
}

static void exynos_usb_init_phy(void)
{
	usb3_phy_utmi_t usbdev3_phy_utmi;
	usbdev3_phy_clkpwr_t usbdev3_phy_clkpwr;
	u32 eClkFreq = USB_PHY_REF_CLK;

	/* Reset PHY configuration */
	writel(0x00000000, EXYNOS_PHY_REG0);
	writel(0x24d466e4, EXYNOS_PHY_PARAM0); //must
	writel(0x00000000, EXYNOS_PHY_RESUME);

	writel(0x08000000, EXYNOS_PHY_LINKSYSTEM); // clear [8] : force_vbusvalid bit, [7] : force_bvalid
	writel(0x03fff818, EXYNOS_PHY_PARAM1); //must
	writel(0x00000004, EXYNOS_PHY_BATCHG); // PHY CLK Mux. (1<<2) : w_FREECLK, (0<<2) : w_PHYCLK
	if (eClkFreq == DIFF_100MHz)
		writel(readl(EXYNOS_PHY_PARAM0) | (0x1<<31), EXYNOS_PHY_PARAM0); // use 100MHz clk
	usbdev3_phy_utmi.data = 0x0;
	usbdev3_phy_utmi.b.otg_disable = 0x1;

	writel(usbdev3_phy_utmi.data, EXYNOS_PHY_UTMI);

	usbdev3_phy_clkpwr.data = 0;

	switch(eClkFreq){
		case DIFF_100MHz:
			usbdev3_phy_clkpwr.b.fsel = 0x27;
			usbdev3_phy_clkpwr.b.refclksel = 2; // DIFF PAD
			usbdev3_phy_clkpwr.b.mpll_multiplier = 0x19;
			usbdev3_phy_clkpwr.b.ref_clkdiv2 = 0;
			usbdev3_phy_clkpwr.b.ssc_ref_clk_sel = 0x00;
			break;
		case EXTREF_50MHz:
			usbdev3_phy_clkpwr.b.fsel = 0x7;
			usbdev3_phy_clkpwr.b.refclksel = 3; // REFCLK_SINGLE
			usbdev3_phy_clkpwr.b.mpll_multiplier = 0x32;
			usbdev3_phy_clkpwr.b.ref_clkdiv2 = 0;
			usbdev3_phy_clkpwr.b.ssc_ref_clk_sel = 0x00;
			break;
		case EXTREF_20MHz:
			usbdev3_phy_clkpwr.b.fsel = 0x4;
			usbdev3_phy_clkpwr.b.refclksel = 3; // REFCLK_SINGLE
			usbdev3_phy_clkpwr.b.mpll_multiplier = 0x7d;
			usbdev3_phy_clkpwr.b.ref_clkdiv2 = 0;
			usbdev3_phy_clkpwr.b.ssc_ref_clk_sel = 0x00;
			break;
		case EXTREF_19_2MHz:
			usbdev3_phy_clkpwr.b.fsel = 0x3;
			usbdev3_phy_clkpwr.b.refclksel = 3; // REFCLK_SINGLE
			usbdev3_phy_clkpwr.b.mpll_multiplier = 0x02;
			usbdev3_phy_clkpwr.b.ref_clkdiv2 = 0;
			usbdev3_phy_clkpwr.b.ssc_ref_clk_sel = 0x88;
			break;
		case EXTREF_24MHz:
		default:
			usbdev3_phy_clkpwr.b.fsel = 0x5;
			usbdev3_phy_clkpwr.b.refclksel = 3; // REFCLK_SINGLE
			usbdev3_phy_clkpwr.b.mpll_multiplier = 0x68;
			usbdev3_phy_clkpwr.b.ref_clkdiv2 = 0;
			usbdev3_phy_clkpwr.b.ssc_ref_clk_sel = 0x88;
			break;
	}

	usbdev3_phy_clkpwr.b.commononn = 1;		// pll blocks are powered in suspend or sleep mode
	usbdev3_phy_clkpwr.b.portreset = 1;		// assert port_reset
	usbdev3_phy_clkpwr.b.retenablen = 1;		// normal operating mode
	usbdev3_phy_clkpwr.b.ref_clkdiv2 = 0;
	usbdev3_phy_clkpwr.b.ref_ssp_en = 1;
	usbdev3_phy_clkpwr.b.ssc_en = 1;
	usbdev3_phy_clkpwr.b.ssc_range = 0;
	usbdev3_phy_clkpwr.b.ssc_ref_clk_sel = 0x0;

	writel(usbdev3_phy_clkpwr.data, EXYNOS_PHY_CLKPWR);
	usbdev3_phy_clkpwr.b.portreset = 0;
	udelay(10);
	writel(usbdev3_phy_clkpwr.data, EXYNOS_PHY_CLKPWR);
}

static void exynos_usb_phy_crport_handshake(usb3_phy_reg0_t *phy_reg0)
{
	usb3_phy_reg1_t phy_reg1;
	u32 usec = 100;

	writel(phy_reg0->data, EXYNOS_PHY_REG0);

	do {
		phy_reg1.data = readl(EXYNOS_PHY_REG1);
		if (phy_reg1.b.cr_ack)
			break;
	} while (usec-- > 0);

	if (!usec)
		printf("CRPORT handshake timeout (0x%08x)\n", phy_reg0->data);
}

static void exynos_phy_crport_ctrl(u16 addr, u16 data)
{
	usb3_phy_reg0_t phy_reg0;

	/* Write Address */
	phy_reg0.data = 0;
	phy_reg0.b.cr_data_in = addr;
	phy_reg0.b.cr_cap_addr = 1;
	exynos_usb_phy_crport_handshake(&phy_reg0);
	phy_reg0.b.cr_cap_addr = 0;
	exynos_usb_phy_crport_handshake(&phy_reg0);

	/* Write Data */
	phy_reg0.data = 0;
	phy_reg0.b.cr_data_in = data;
	phy_reg0.b.cr_cap_data = 1;
	exynos_usb_phy_crport_handshake(&phy_reg0);
	phy_reg0.b.cr_cap_data = 0;
	exynos_usb_phy_crport_handshake(&phy_reg0);

	/* Execute write operation */
	phy_reg0.data = 0;
	phy_reg0.b.cr_data_in = data;
	phy_reg0.b.cr_write = 1;
	exynos_usb_phy_crport_handshake(&phy_reg0);
	phy_reg0.b.cr_write = 0;
	exynos_usb_phy_crport_handshake(&phy_reg0);
}

static void exynos_usb_crport_config(void)
{
	exynos_phy_crport_ctrl(0x15, 0xA409);
	exynos_phy_crport_ctrl(0x12, 0xA000);
}

static u32 exynos_usb_malloc(u32 uSize, u32 uAlign)
{
	u32 uAddr, uTemp1, uTemp2, uTemp3;
	u32 uAddr_aligned;
	u32 uAllocHwMem_AlignConstraint = 64;

	// get the GCD(Great Common Divider)
	uTemp2 = uAlign;
	uTemp3 = uAllocHwMem_AlignConstraint;
	while(uTemp3)
	{
		uTemp1 = uTemp2%uTemp3;
		uTemp2 = uTemp3;
		uTemp3 = uTemp1;
	}

	// get the LCM(Least Common Multiple)
	uAlign = uAlign*uAllocHwMem_AlignConstraint/uTemp2;
	//TODO : check align
	uAddr = (u32)malloc(uSize + uAlign);
	uTemp2 = uAddr % uAlign;

	uAddr_aligned = uAddr + (uAlign - uTemp2);
	*(u32 *)(uAddr_aligned-4) = uAddr;

	memset((void *)uAddr, 0, uSize);
	DBG_USBD3("exynos_usb_malloc:Addr=0x%08x[0x%08x], Size=%d, Align=%d\n\n", uAddr, uAddr_aligned, uSize, uAlign);

	return uAddr_aligned;
}

static void exynos_usb_free(u32 uAddr)
{
	u32 uFree_addr;
	if (uAddr != 0)
	{
		uFree_addr = *(u32 *)(uAddr - 4);
		free((u8 *)uFree_addr);
	}
	DBG_USBD3("\n\nexynos_usb_free:0x%08x[0x%8x]\n\n", uAddr, uFree_addr);
}

static void exynos_usb_print_ep0_pkt(u8 *pt, u8 count)
{
	int i;
	DBG_USBD3("[DBG:");
	for(i=0;i<count;i++)
		DBG_USBD3("%x,", pt[i]);
	DBG_USBD3("]\n");
}

static void exynos_usb_set_descriptor_tlb(void)
{
	// Standard device descriptor
	oUsbDev3.m_oDesc.oDescDevice.bLength=DEVICE_DESC_SIZE;
	oUsbDev3.m_oDesc.oDescDevice.bDescriptorType=DEVICE_DESCRIPTOR;
	oUsbDev3.m_oDesc.oDescDevice.bDeviceClass=0xFF;
	oUsbDev3.m_oDesc.oDescDevice.bDeviceSubClass=0x0;
	oUsbDev3.m_oDesc.oDescDevice.bDeviceProtocol=0x0;
	if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER) {
		oUsbDev3.m_oDesc.oDescDevice.bMaxPacketSize0=SUPER_SPEED_CONTROL_PKT_EXP_SZ;
	} else {
		oUsbDev3.m_oDesc.oDescDevice.bMaxPacketSize0=oUsbDev3.m_uControlEPMaxPktSize;
	}
	oUsbDev3.m_oDesc.oDescDevice.idVendorL=0xE8;
	oUsbDev3.m_oDesc.oDescDevice.idVendorH=0x04;
	oUsbDev3.m_oDesc.oDescDevice.idProductL=0x34;
	oUsbDev3.m_oDesc.oDescDevice.idProductH=0x12;
	oUsbDev3.m_oDesc.oDescDevice.bcdDeviceL=0x00;
	oUsbDev3.m_oDesc.oDescDevice.bcdDeviceH=0x01;
	oUsbDev3.m_oDesc.oDescDevice.iManufacturer=0x1; // index of string descriptor
	oUsbDev3.m_oDesc.oDescDevice.iProduct=0x2;	// index of string descriptor
	oUsbDev3.m_oDesc.oDescDevice.iSerialNumber=0x0;
	oUsbDev3.m_oDesc.oDescDevice.bNumConfigurations=0x1;

	// khs. this should be changed, and also other descriptors should be changed
	if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER) {
		oUsbDev3.m_oDesc.oDescDevice.bcdUSBL=0x00;
		oUsbDev3.m_oDesc.oDescDevice.bcdUSBH=0x03; 	// Ver 3.0
	} else if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_HIGH) {
		oUsbDev3.m_oDesc.oDescDevice.bcdUSBL=0x00;
		oUsbDev3.m_oDesc.oDescDevice.bcdUSBH=0x02; 	// Ver 2.0
	} else if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_FULL) {
		oUsbDev3.m_oDesc.oDescDevice.bcdUSBL=0x10;
		oUsbDev3.m_oDesc.oDescDevice.bcdUSBH=0x01; 	// Ver 2.0
	}

	// Standard configuration descriptor
	oUsbDev3.m_oDesc.oDescConfig.bLength=CONFIG_DESC_SIZE; // 0x9 bytes
	oUsbDev3.m_oDesc.oDescConfig.bDescriptorType=CONFIGURATION_DESCRIPTOR;
	if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER)
		oUsbDev3.m_oDesc.oDescConfig.wTotalLengthL=CONFIG_SS_DESC_TOTAL_SIZE;
	else
		oUsbDev3.m_oDesc.oDescConfig.wTotalLengthL=CONFIG_DESC_TOTAL_SIZE;
	oUsbDev3.m_oDesc.oDescConfig.wTotalLengthH=0;
	oUsbDev3.m_oDesc.oDescConfig.bNumInterfaces=1;
	oUsbDev3.m_oDesc.oDescConfig.bConfigurationValue=1;
	oUsbDev3.m_oDesc.oDescConfig.iConfiguration=0;
	oUsbDev3.m_oDesc.oDescConfig.bmAttributes=CONF_ATTR_DEFAULT|CONF_ATTR_SELFPOWERED; // bus powered only.
	oUsbDev3.m_oDesc.oDescConfig.maxPower=25; // draws 50mA current from the USB bus.

	// Standard interface descriptor
	oUsbDev3.m_oDesc.oDescInterface.bLength=INTERFACE_DESC_SIZE; // 9
	oUsbDev3.m_oDesc.oDescInterface.bDescriptorType=INTERFACE_DESCRIPTOR;
	oUsbDev3.m_oDesc.oDescInterface.bInterfaceNumber=0x0;
	oUsbDev3.m_oDesc.oDescInterface.bAlternateSetting=0x0; // ?
	oUsbDev3.m_oDesc.oDescInterface.bNumEndpoints = 2;	// # of endpoints except EP0
	oUsbDev3.m_oDesc.oDescInterface.bInterfaceClass=0xff; // 0x0 ?
	oUsbDev3.m_oDesc.oDescInterface.bInterfaceSubClass=0x0;
	oUsbDev3.m_oDesc.oDescInterface.bInterfaceProtocol=0x0;
	oUsbDev3.m_oDesc.oDescInterface.iInterface=0x0;

	if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER) {
		/* Standard endpoint0 descriptor */
		oUsbDev3.m_oSSDesc.oDescEp0.bLength=ENDPOINT_DESC_SIZE;
		oUsbDev3.m_oSSDesc.oDescEp0.bDescriptorType=ENDPOINT_DESCRIPTOR;
		oUsbDev3.m_oSSDesc.oDescEp0.bEndpointAddress=BULK_IN_EP|EP_ADDR_IN;
		oUsbDev3.m_oSSDesc.oDescEp0.bmAttributes=EP_ATTR_BULK;
		oUsbDev3.m_oSSDesc.oDescEp0.wMaxPacketSizeL=(u8)oUsbDev3.m_uBulkEPMaxPktSize; /* 64*/
		oUsbDev3.m_oSSDesc.oDescEp0.wMaxPacketSizeH=(u8)(oUsbDev3.m_uBulkEPMaxPktSize>>8);
		oUsbDev3.m_oSSDesc.oDescEp0.bInterval=0x0; /* not used */

		oUsbDev3.m_oSSDesc.oDescEp0Comp.bLength=6;
		oUsbDev3.m_oSSDesc.oDescEp0Comp.bDescriptorType=0x30;
		oUsbDev3.m_oSSDesc.oDescEp0Comp.bMaxBurst=15;
		oUsbDev3.m_oSSDesc.oDescEp0Comp.bmAttributes=0;
		oUsbDev3.m_oSSDesc.oDescEp0Comp.wBytesPerInterval=0;

		/* Standard endpoint1 descriptor */
		oUsbDev3.m_oSSDesc.oDescEp1.bLength=ENDPOINT_DESC_SIZE;
		oUsbDev3.m_oSSDesc.oDescEp1.bDescriptorType=ENDPOINT_DESCRIPTOR;
		oUsbDev3.m_oSSDesc.oDescEp1.bEndpointAddress=BULK_OUT_EP|EP_ADDR_OUT;
		oUsbDev3.m_oSSDesc.oDescEp1.bmAttributes=EP_ATTR_BULK;
		oUsbDev3.m_oSSDesc.oDescEp1.wMaxPacketSizeL=(u8)oUsbDev3.m_uBulkEPMaxPktSize; /* 64*/
		oUsbDev3.m_oSSDesc.oDescEp1.wMaxPacketSizeH=(u8)(oUsbDev3.m_uBulkEPMaxPktSize>>8);
		oUsbDev3.m_oSSDesc.oDescEp1.bInterval=0x0; /* not used */

		oUsbDev3.m_oSSDesc.oDescEp1Comp.bLength=6;
		oUsbDev3.m_oSSDesc.oDescEp1Comp.bDescriptorType=0x30;
		oUsbDev3.m_oSSDesc.oDescEp1Comp.bMaxBurst=15;
		oUsbDev3.m_oSSDesc.oDescEp1Comp.bmAttributes=0;
		oUsbDev3.m_oSSDesc.oDescEp1Comp.wBytesPerInterval=0;

		// Standard BOS(Binary Object Store) descriptor
		oUsbDev3.m_oSSDesc.oDescBos.bLength = BOS_DESC_SIZE;
		oUsbDev3.m_oSSDesc.oDescBos.bDescriptorType = 0x0F;
		oUsbDev3.m_oSSDesc.oDescBos.wTotalLength = BOS_DESC_TOTAL_SIZE;
		oUsbDev3.m_oSSDesc.oDescBos.bNumDeviceCaps = 3;

		oUsbDev3.m_oSSDesc.oDescUsb20Ext.bLength = USB20_EXT_CAP_DESC_SIZE;
		oUsbDev3.m_oSSDesc.oDescUsb20Ext.bDescriptorType = 0x10;
		oUsbDev3.m_oSSDesc.oDescUsb20Ext.bDevCapabilityType = USB_CAP_20_EXT;
		oUsbDev3.m_oSSDesc.oDescUsb20Ext.bmAttributes = 0x2;

		oUsbDev3.m_oSSDesc.oDescSuperCap.bLength = SUPER_CAP_DESC_SIZE;
		oUsbDev3.m_oSSDesc.oDescSuperCap.bDescriptorType = 0x10;
		oUsbDev3.m_oSSDesc.oDescSuperCap.bDevCapabilityType = USB_CAP_SS;
		oUsbDev3.m_oSSDesc.oDescSuperCap.bmAttributes = 0x0;
		oUsbDev3.m_oSSDesc.oDescSuperCap.wSpeedsSupported = 0xC;
		oUsbDev3.m_oSSDesc.oDescSuperCap.bFunctionalitySupport = 2;
		/* TODO: set correct value */
		oUsbDev3.m_oSSDesc.oDescSuperCap.bU1DevExitLat = 0x4;
		oUsbDev3.m_oSSDesc.oDescSuperCap.wU2DevExitLat = 0x4;

		oUsbDev3.m_oSSDesc.oDescContainCap.bLength = CONTAIN_CAP_DESC_SIZE;
		oUsbDev3.m_oSSDesc.oDescContainCap.bDescriptorType = 0x10;
		oUsbDev3.m_oSSDesc.oDescContainCap.bDevCapabilityType = USB_CAP_CID;
		oUsbDev3.m_oSSDesc.oDescContainCap.bReserved = 0x0;
		memset(oUsbDev3.m_oSSDesc.oDescContainCap.containerID, 0x0, 16);
	}
	else {
		/* Standard endpoint0 descriptor */
		oUsbDev3.m_oDesc.oDescEp0.bLength=ENDPOINT_DESC_SIZE;
		oUsbDev3.m_oDesc.oDescEp0.bDescriptorType=ENDPOINT_DESCRIPTOR;
		oUsbDev3.m_oDesc.oDescEp0.bEndpointAddress=BULK_IN_EP|EP_ADDR_IN;
		oUsbDev3.m_oDesc.oDescEp0.bmAttributes=EP_ATTR_BULK;
		oUsbDev3.m_oDesc.oDescEp0.wMaxPacketSizeL=(u8)oUsbDev3.m_uBulkEPMaxPktSize; /* 64*/
		oUsbDev3.m_oDesc.oDescEp0.wMaxPacketSizeH=(u8)(oUsbDev3.m_uBulkEPMaxPktSize>>8);
		oUsbDev3.m_oDesc.oDescEp0.bInterval=0x0; /* not used */

		/* Standard endpoint1 descriptor */
		oUsbDev3.m_oDesc.oDescEp1.bLength=ENDPOINT_DESC_SIZE;
		oUsbDev3.m_oDesc.oDescEp1.bDescriptorType=ENDPOINT_DESCRIPTOR;
		oUsbDev3.m_oDesc.oDescEp1.bEndpointAddress=BULK_OUT_EP|EP_ADDR_OUT;
		oUsbDev3.m_oDesc.oDescEp1.bmAttributes=EP_ATTR_BULK;
		oUsbDev3.m_oDesc.oDescEp1.wMaxPacketSizeL=(u8)oUsbDev3.m_uBulkEPMaxPktSize; /* 64*/
		oUsbDev3.m_oDesc.oDescEp1.wMaxPacketSizeH=(u8)(oUsbDev3.m_uBulkEPMaxPktSize>>8);
		oUsbDev3.m_oDesc.oDescEp1.bInterval=0x0; /* not used */
	}
}

static void exynos_usb_softreset_phy(u8 ucSet)
{
	usbdev3_gusb2phycfg_t usbdev3_gusb2phycfg;
	usbdev3_gusb3pipectl_t usbdev3_gusb3pipectl;

	usbdev3_gusb2phycfg.data = readl(rGUSB2PHYCFG);
	usbdev3_gusb2phycfg.b.phy_soft_reset = ucSet;
	writel(usbdev3_gusb2phycfg.data, rGUSB2PHYCFG);

	usbdev3_gusb3pipectl.data = readl(rGUSB3PIPECTL);
	usbdev3_gusb3pipectl.b.phy_soft_reset = ucSet;
	writel(usbdev3_gusb3pipectl.data, rGUSB3PIPECTL);
}

static void exynos_usb_softreset_core(void)
{
	usbdev3_dctl_t usbdev3_dctl;

	usbdev3_dctl.data = readl(rDCTL);
	usbdev3_dctl.b.core_soft_reset = 1;
	//usbdev3_dctl.b.run_stop = 0;
	writel(usbdev3_dctl.data, rDCTL);

	do
	{
		udelay(10);
		usbdev3_dctl.data = readl(rDCTL);
	} while (usbdev3_dctl.b.core_soft_reset == 1);

	udelay(10);	// s/w must wait at least 3 phy clocks(1/60Mz * 3 = 48ns) before accessing the phy domain
}

static void exynos_usb_enable_eventinterrupt(void)
{
	usbdev3_gevntsiz_t usbdev3_gevntsiz;

	usbdev3_gevntsiz.data = readl(rGEVNTSIZ0);
	usbdev3_gevntsiz.b.event_int_mask = 0;
	writel(usbdev3_gevntsiz.data, rGEVNTSIZ0);
}

static void exynos_usb_disable_eventinterrupt(void)
{
	usbdev3_gevntsiz_t usbdev3_gevntsiz;

	usbdev3_gevntsiz.data = readl(rGEVNTSIZ0);
	usbdev3_gevntsiz.b.event_int_mask = 1;
	writel(usbdev3_gevntsiz.data, rGEVNTSIZ0);
}

static void exynos_usb_flush_eventbuffer(void)
{
	u32 uEventCount;

	uEventCount = readl(rGEVNTCOUNT0) & 0xffff;

	writel(uEventCount, rGEVNTCOUNT0);
}

static int exynos_usb_wait_ep_cmd_complete(USBDEV3_EP_DIR_e eEpDir, u8 ucEpNum, u32 uSec)
{
	usbdev3_depcmd_t usbdev3_depcmd;
	u32 uEpCmdAddr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMD(ucEpNum) : rDOEPCMD(ucEpNum);

	do {
		usbdev3_depcmd.data = readl(uEpCmdAddr);

		if (!(usbdev3_depcmd.b.cmd_active))
		{
			DBG_USBD3("Complete: D%cEPCMD(%d)=0x%08x\n",
				(eEpDir==USBDEV3_EP_DIR_IN)? 'I' : 'O', ucEpNum, usbdev3_depcmd.data);
			return 1;
		}

		udelay(1);
		uSec--;
	} while (uSec > 0);

	DBG_USBD3("TimeOver: D%cEPCMD(%d)=0x%08x\n",
		(eEpDir==USBDEV3_EP_DIR_IN)? 'I' : 'O', ucEpNum, usbdev3_depcmd.data);
	return 0;
}

static int exynos_usb_set_ep_cfg(USBDEV3_EP_DIR_e eEpDir, u8 ucEpNum, u32 uPar0, u32 uPar1)
{
	usbdev3_depcmd_t usbdev3_depcmd;
	u32 uEpCmdAddr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMD(ucEpNum) : rDOEPCMD(ucEpNum);
	u32 uEpPar0Addr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMDPAR0(ucEpNum) : rDOEPCMDPAR0(ucEpNum);
	u32 uEpPar1Addr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMDPAR1(ucEpNum) : rDOEPCMDPAR1(ucEpNum);


	writel(uPar1, uEpPar1Addr);
	writel(uPar0, uEpPar0Addr);

	usbdev3_depcmd.data = 0;
	usbdev3_depcmd.b.cmd_type = DEPCMD_CMD_SET_EP_CFG;
	usbdev3_depcmd.b.cmd_active = 1;
	writel(usbdev3_depcmd.data, uEpCmdAddr);

	if (!exynos_usb_wait_ep_cmd_complete(eEpDir, ucEpNum, CMDCOMPLETEWAIT_UNIT))
	{
		return 0;
	}

	return 1;
}

static int exynos_usb_set_ep_xfer_rsrc_cfg(USBDEV3_EP_DIR_e eEpDir, u8 ucEpNum, u32 uPar0)
{
	usbdev3_depcmd_t usbdev3_depcmd;
	u32 uEpCmdAddr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMD(ucEpNum) : rDOEPCMD(ucEpNum);
	u32 uEpPar0Addr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMDPAR0(ucEpNum) : rDOEPCMDPAR0(ucEpNum);

	writel(uPar0, uEpPar0Addr);

	usbdev3_depcmd.data = 0;
	usbdev3_depcmd.b.cmd_type = DEPCMD_CMD_SET_EP_XFER_RSRC_CFG;
	usbdev3_depcmd.b.cmd_active = 1;
	writel(usbdev3_depcmd.data, uEpCmdAddr);

	if (!exynos_usb_wait_ep_cmd_complete(eEpDir, ucEpNum, CMDCOMPLETEWAIT_UNIT))
	{
		return 0;
	}

	return 1;
}

static void exynos_usb_enable_ep(USBDEV3_EP_DIR_e eEpDir, u8 ucEpNum)
{
	u32 uEpEnaIdx;

	uEpEnaIdx = ucEpNum*2;

	if (eEpDir == USBDEV3_EP_DIR_IN)
	{
		uEpEnaIdx++;
	}

	writel(readl(rDALEPENA) | (1<<uEpEnaIdx), rDALEPENA);
}

static int exynos_usb_activate_ep0(void)
{
	usbdev3_depcmd_t usbdev3_depcmd;
	usbdev3_depcmdpar0_set_ep_cfg_t usbdev3_depcmdpar0_set_ep_cfg;
	usbdev3_depcmdpar1_set_ep_cfg_t usbdev3_depcmdpar1_set_ep_cfg;

	// . Start New Configuration
	//-----------------------
	usbdev3_depcmd.data = 0;
	usbdev3_depcmd.b.cmd_type = DEPCMD_CMD_START_NEW_CFG;
	usbdev3_depcmd.b.cmd_active = 1;
	writel(usbdev3_depcmd.data, rDOEPCMD(0));
	if (!exynos_usb_wait_ep_cmd_complete(USBDEV3_EP_DIR_OUT, 0, CMDCOMPLETEWAIT_UNIT))
	{
		return 0;
	}

	// . Issue Set Ep Configuraton for EP0-OUT
	//------------------------------------
	usbdev3_depcmdpar0_set_ep_cfg.data = 0;
	usbdev3_depcmdpar0_set_ep_cfg.b.ep_type = USBDEV3_EP_CTRL;
	usbdev3_depcmdpar0_set_ep_cfg.b.mps = oUsbDev3.m_uControlEPMaxPktSize;	// should be reconfigured after ConnectDone event

	usbdev3_depcmdpar1_set_ep_cfg.data = 0;
	usbdev3_depcmdpar1_set_ep_cfg.b.xfer_cmpl_en = 1;
	//usbdev3_depcmdpar1_set_ep_cfg.b.xfer_in_prog_en = 1;
	usbdev3_depcmdpar1_set_ep_cfg.b.xfer_nrdy_en = 1;
	usbdev3_depcmdpar1_set_ep_cfg.b.ep_dir = USBDEV3_EP_DIR_OUT;
	usbdev3_depcmdpar1_set_ep_cfg.b.ep_num = 0;

	if (!exynos_usb_set_ep_cfg(USBDEV3_EP_DIR_OUT, 0, usbdev3_depcmdpar0_set_ep_cfg.data, usbdev3_depcmdpar1_set_ep_cfg.data))
	{
		return 0;
	}

	// . Issue Set Ep Xfer Resource for EP0-OUT
	//------------------------------------
	if (!exynos_usb_set_ep_xfer_rsrc_cfg(USBDEV3_EP_DIR_OUT, 0, 1))
	{
		return 0;
	}

	// . Issue Set Ep Configuraton for EP0-IN
	//------------------------------------
	usbdev3_depcmdpar0_set_ep_cfg.data = 0;
	usbdev3_depcmdpar0_set_ep_cfg.b.ep_type = USBDEV3_EP_CTRL;
	usbdev3_depcmdpar0_set_ep_cfg.b.mps = oUsbDev3.m_uControlEPMaxPktSize;	// should be reconfigured after ConnectDone event

	usbdev3_depcmdpar1_set_ep_cfg.data = 0;
	usbdev3_depcmdpar1_set_ep_cfg.b.xfer_cmpl_en = 1;
	//usbdev3_depcmdpar1_set_ep_cfg.b.xfer_in_prog_en = 1;
	usbdev3_depcmdpar1_set_ep_cfg.b.xfer_nrdy_en = 1;
	usbdev3_depcmdpar1_set_ep_cfg.b.ep_dir = USBDEV3_EP_DIR_IN;
	usbdev3_depcmdpar1_set_ep_cfg.b.ep_num = 0;

	if (!exynos_usb_set_ep_cfg(USBDEV3_EP_DIR_IN, 0, usbdev3_depcmdpar0_set_ep_cfg.data, usbdev3_depcmdpar1_set_ep_cfg.data))
	{
		return 0;
	}

	// . Issue Set Ep Xfer Resource for EP0-IN
	//------------------------------------
	if (!exynos_usb_set_ep_xfer_rsrc_cfg(USBDEV3_EP_DIR_IN, 0, 1))
	{
		return 0;
	}

	return 1;
}

static int exynos_usb_activate_ep(USBDEV3_EP_DIR_e eEpDir, u8 ucEpNum)
{
	usbdev3_depcmd_t usbdev3_depcmd;
	usbdev3_depcmdpar0_set_ep_cfg_t usbdev3_depcmdpar0_set_ep_cfg;
	usbdev3_depcmdpar1_set_ep_cfg_t usbdev3_depcmdpar1_set_ep_cfg;


	if (oUsbDev3.m_bEPs_Enabled == 0)
	{
		oUsbDev3.m_bEPs_Enabled = 1;

		// . Start New Configuration
		//-----------------------
		usbdev3_depcmd.data = 0;
		usbdev3_depcmd.b.param = 2;	// XferRscIdx = 2 in case of non-EP0, XferRscIdx = 0 in case of EP0
		usbdev3_depcmd.b.cmd_type = DEPCMD_CMD_START_NEW_CFG;
		usbdev3_depcmd.b.cmd_active = 1;
		writel(usbdev3_depcmd.data, rDOEPCMD(0));
		if (!exynos_usb_wait_ep_cmd_complete(USBDEV3_EP_DIR_OUT, 0, CMDCOMPLETEWAIT_UNIT))
		{
			return 0;
		}
	}


	// . Issue Set Ep Configuraton
	//------------------------------------
	usbdev3_depcmdpar0_set_ep_cfg.data = 0;
	usbdev3_depcmdpar0_set_ep_cfg.b.ep_type = USBDEV3_EP_BULK;
	usbdev3_depcmdpar0_set_ep_cfg.b.mps = oUsbDev3.m_uBulkEPMaxPktSize;

	if (eEpDir == USBDEV3_EP_DIR_IN)
	{
		usbdev3_depcmdpar0_set_ep_cfg.b.fifo_num = ucEpNum;
	}

	usbdev3_depcmdpar0_set_ep_cfg.b.brst_siz = 0;	// khs. should find best value


	usbdev3_depcmdpar1_set_ep_cfg.data = 0;
	usbdev3_depcmdpar1_set_ep_cfg.b.xfer_cmpl_en = 1;
	//usbdev3_depcmdpar1_set_ep_cfg.b.xfer_in_prog_en = 1;
	//usbdev3_depcmdpar1_set_ep_cfg.b.xfer_nrdy_en = 1;		// when using preset transfer, this interrupt can be disabled
	usbdev3_depcmdpar1_set_ep_cfg.b.ep_dir = (u32)eEpDir;
	usbdev3_depcmdpar1_set_ep_cfg.b.ep_num = ucEpNum;

	if (!exynos_usb_set_ep_cfg(eEpDir, ucEpNum, usbdev3_depcmdpar0_set_ep_cfg.data, usbdev3_depcmdpar1_set_ep_cfg.data))
	{
		return 0;
	}

	// . Issue Set Ep Xfer Resource
	//--------------------------
	if (!exynos_usb_set_ep_xfer_rsrc_cfg(eEpDir, ucEpNum, 1))
	{
		return 0;
	}

	return 1;
}

static void exynos_usb_runstop_device(u8 ucSet)
{
	usbdev3_dctl_t usbdev3_dctl;

	usbdev3_dctl.data = readl(rDCTL);
	usbdev3_dctl.b.run_stop = ucSet;
	writel(usbdev3_dctl.data, rDCTL);
}

static int exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_e eEpDir, u8 ucEpNum, u32 uTrbAddr, u32 uStrmidSofn, u32 *uTri)
{
	usbdev3_depcmd_t usbdev3_depcmd;
	u32 uEpCmdAddr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMD(ucEpNum) : rDOEPCMD(ucEpNum);
	u32 uEpPar0Addr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMDPAR0(ucEpNum) : rDOEPCMDPAR0(ucEpNum);
	u32 uEpPar1Addr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMDPAR1(ucEpNum) : rDOEPCMDPAR1(ucEpNum);


	writel(virt_to_phys((void *)uTrbAddr), uEpPar1Addr);
	writel(0, uEpPar0Addr);

	usbdev3_depcmd.data = 0;
	usbdev3_depcmd.b.cmd_type = DEPCMD_CMD_START_XFER;
	usbdev3_depcmd.b.cmd_active = 1;
	usbdev3_depcmd.b.param = uStrmidSofn;
	writel(usbdev3_depcmd.data, uEpCmdAddr);

	if (!exynos_usb_wait_ep_cmd_complete(eEpDir, ucEpNum, CMDCOMPLETEWAIT_UNIT))
	{
		return 0;
	}

	// . Get the Tranfer Resource Index from the start transfer command
	//--------------------------------------------------------
	usbdev3_depcmd.data = readl(uEpCmdAddr);
	*uTri = usbdev3_depcmd.b.param & 0x7f;

	return 1;
}

static void exynos_usb_fill_trb(usbdev3_trb_ptr_t pTrb, u32 uBufAddr, u32 uLen, u32 uTrbCtrl, u32 uHwo)
{
	pTrb->buf_ptr_l = virt_to_phys((void *)uBufAddr);
	pTrb->buf_ptr_h = 0;

	pTrb->status.data = 0;
	pTrb->status.b.buf_siz = uLen;

	pTrb->control.data = uTrbCtrl & 0xfffffffeU;

	// must do this last => why?
	if (uHwo)
	{
		pTrb->control.b.hwo = 1;
	}

}

static int exynos_usb_start_ep0_setup_rx(void)
{
	usbdev3_trb_ctrl_t usbdev3_trb_ctrl;

	// . Set TRB for Setup
	//------------------
	usbdev3_trb_ctrl.data = 0;
	usbdev3_trb_ctrl.b.lst = 1;
	usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_SETUP;
	usbdev3_trb_ctrl.b.isp_imi = 1;
	usbdev3_trb_ctrl.b.ioc = 1;
	usbdev3_trb_ctrl.b.strmid_sofn = 0;

	exynos_usb_fill_trb(oUsbDev3.m_oSetupTrbPtr, (u32)&oUsbDev3.m_oDeviceRequest,
		oUsbDev3.m_uControlEPMaxPktSize, usbdev3_trb_ctrl.data, 1);

	// . Issue Start Xfer for EP0-OUT
	//----------------------------
	if (!exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_OUT, 0, (u32)oUsbDev3.m_oSetupTrbPtr, 0, &oUsbDev3.m_uTriOut[0]))
	{
		return 0;
	}

	return 1;
}

static int exynos_usb_init_core(USBDEV3_SPEED_e eSpeed)
{
	usbdev3_gsbuscfg0_t usbdev3_gsbuscfg0;
	usbdev3_gsbuscfg1_t usbdev3_gsbuscfg1;
	usbdev3_gusb2phycfg_t usbdev3_gusb2phycfg;
	usbdev3_gusb3pipectl_t usbdev3_gusb3pipectl;
	usbdev3_gevntsiz_t usbdev3_gevntsiz;
	usbdev3_dcfg_t usbdev3_dcfg;
	usbdev3_devten_t usbdev3_devten;
	u32 uData = 0;

	// . to soft-reset core
	//-----------------
	exynos_usb_softreset_core();
	// . to crport configuration
	//-----------------
	exynos_usb_crport_config();
	// . to configure GSBUSCFG0/1
	//   khs. I should find best setting value for our AP system
	//----------------------------------------------
	usbdev3_gsbuscfg0.data = 0;
	//usbdev3_gsbuscfg0.b.incr_xbrst_ena = 1;
	//usbdev3_gsbuscfg0.b.incr_4brst_ena = 1;
	//usbdev3_gsbuscfg0.b.incr_8brst_ena = 1;
	usbdev3_gsbuscfg0.b.incr_16brst_ena = 1;
	writel(usbdev3_gsbuscfg0.data, rGSBUSCFG0);

	usbdev3_gsbuscfg1.data = 0x00000300;	// reset value
	writel(usbdev3_gsbuscfg1.data, rGSBUSCFG1);

	// . to configure GTXTHRCFG/GRXTHRCFG
	//------------------------------------------------
		// skipped because this sfr is only valid in the host mode

	// . to check IP version
	//-------------------
	uData = readl(rGSNPSID);
	DBG_USBD3("IP version is %1x.%03x\n", (uData&0xf000)>>12, (uData&0x0fff));

	// . to set usb 2.0 phy-related configuration parmeters
	//---------------------------------------------
	usbdev3_gusb2phycfg.data = readl(rGUSB2PHYCFG);
	usbdev3_gusb2phycfg.b.turnaround_time = 9;
	writel(usbdev3_gusb2phycfg.data, rGUSB2PHYCFG);

	// . to set usb 3.0 phy-related configuration parmeters
	//	(I should find proper setting value)
	//---------------------------------------------
	usbdev3_gusb3pipectl.data = 0x00260002;	// reset value
	// usbdev3_gusb3pipectl.data = 0x00240002;	// clear suspend bit
	writel(usbdev3_gusb3pipectl.data, rGUSB3PIPECTL);

	// . to set tx fifo sizes
	//------------------
		// skipped because of using default setting


	// . to set rx fifo sizes
	//-------------------
		// skipped because of using default setting


	// . to initialize the Event Buffer registers
	//-------------------------------------
	writel(0, rGEVNTADR_HI0);
	oUsbDev3.m_CurrentEventPosition = 0;
	writel(virt_to_phys((void *)oUsbDev3.m_pEventBuffer), rGEVNTADR_LO0);
	usbdev3_gevntsiz.data = 0;
	usbdev3_gevntsiz.b.event_siz = 4*USBDEV3_EVENT_BUFFER_COUNT;
	usbdev3_gevntsiz.b.event_int_mask = 0;
	writel(usbdev3_gevntsiz.data, rGEVNTSIZ0);
	writel(0, rGEVNTCOUNT0);

	// . to set Gloval Control Register
	//	khs. I should find proper setting value
	//--------------------------------
		// writel(rGCTL, 0x30c02000);

	// . to set Device Config. Register
	//-----------------------------
	usbdev3_dcfg.data = 0;
	usbdev3_dcfg.b.dev_speed = (u32) eSpeed;
	usbdev3_dcfg.b.dev_addr = 0;
	usbdev3_dcfg.b.per_fr_int = 2;	// 90%
	usbdev3_dcfg.b.intr_num = 0;
	usbdev3_dcfg.b.num_rx_buf = 1;		// khs. 1(simulation code) or 4(reset value)?
#ifdef USBDEV3_LPM_CAPABLE
	usbdev3_dcfg.b.lpm_cap = 1;
#endif
	writel(usbdev3_dcfg.data, rDCFG);

	// . to enable Global and Device interrupts
	//	(I should find proper setting value)
	//------------------------------------
	exynos_usb_disable_eventinterrupt();
	exynos_usb_flush_eventbuffer();
	exynos_usb_enable_eventinterrupt();

	usbdev3_devten.data = 0;
	usbdev3_devten.b.disconn_evt_en = 1;
	usbdev3_devten.b.usb_reset_en = 1;
	usbdev3_devten.b.conn_done_en = 1;
	//usbdev3_devten.b.usb_lnk_sts_chng_en = 1;
		//usbdev3_devten.b.wake_up_en = 1;
		//usbdev3_devten.b.errtic_err_en = 1;
		//usbdev3_devten.b.cmd_cmplt_en = 1;
	usbdev3_devten.b.evnt_overflow_en = 1;
	writel(usbdev3_devten.data, rDEVTEN);

	// . to activate EP0
	//----------------
	if (!exynos_usb_activate_ep0())
	{
		DBG_USBD3("Activate Ep0 Fail\n");
		return -1;
	}

	// . to start EP0 to receive SETUP packets
	//----------------------------------
	if (!exynos_usb_start_ep0_setup_rx())
	{
		DBG_USBD3("Start Ep0 Setup Rx Fail\n");
		return -1;
	}

	// . to enable EP0-OUT/IN in DALEPENA register
	//----------------------------------------
	exynos_usb_enable_ep(USBDEV3_EP_DIR_OUT, 0);
	exynos_usb_enable_ep(USBDEV3_EP_DIR_IN, 0);

	// . to set the Run/Stop bit
	//----------------------

	return 0;
}

static void exynos_usb_handle_disconnect_int(void)
{
	oUsbDev3.m_eUsbDev3State = USBDEV3_STATE_DEFAULT;
}

static int exynos_usb_end_ep_xfer(USBDEV3_EP_DIR_e eEpDir, u8 ucEpNum, u32 uTri)
{
	usbdev3_depcmd_t usbdev3_depcmd;
	u32 uEpCmdAddr = (eEpDir==USBDEV3_EP_DIR_IN)? rDIEPCMD(ucEpNum) : rDOEPCMD(ucEpNum);

	usbdev3_depcmd.data = 0;
	usbdev3_depcmd.b.cmd_type = DEPCMD_CMD_END_XFER;
	usbdev3_depcmd.b.cmd_active = 1;
	//usbdev3_depcmd.b.hipri_forcerm = 1;
	usbdev3_depcmd.b.param = uTri;
	writel(usbdev3_depcmd.data, uEpCmdAddr);

	if (!exynos_usb_wait_ep_cmd_complete(eEpDir, ucEpNum, (10*CMDCOMPLETEWAIT_UNIT)))	// wait time is longer than others'
	{
		return 0;
	}

	return 1;
}

static void exynos_usb_handle_reset_int(void)
{
	u32 uEpNum;
	usbdev3_dcfg_t usbdev3_dcfg;
	usbdev3_dsts_t usbdev3_dsts;
	usbdev3_dgcmd_t usbdev3_dgcmd;
	// . Stop All Transfers except for default control EP0
	//-------------------------------------------
	// stop any active xfers on the non-EP0 IN endpoints
	for (uEpNum = 1; uEpNum < TOTL_EP_COUNT; uEpNum++)
	{
		if (oUsbDev3.m_uTriIn[uEpNum])
		{
			exynos_usb_end_ep_xfer(USBDEV3_EP_DIR_IN, uEpNum, oUsbDev3.m_uTriIn[uEpNum]);
			oUsbDev3.m_uTriIn[uEpNum] = 0;
		}
	}

	// stop any active xfers on the non-EP0 OUT endpoints
	for (uEpNum = 1; uEpNum < TOTL_EP_COUNT; uEpNum++)
	{
		if (oUsbDev3.m_uTriOut[uEpNum])
		{
			exynos_usb_end_ep_xfer(USBDEV3_EP_DIR_OUT, uEpNum, oUsbDev3.m_uTriOut[uEpNum]);
			oUsbDev3.m_uTriOut[uEpNum] = 0;
		}
	}

	// . Flush all FIFOs
	//---------------
	usbdev3_dgcmd.data= 0;
	usbdev3_dgcmd.b.cmd_type = DGCMD_CMD_ALL_FIFO_FLUSH;
	usbdev3_dgcmd.b.cmd_active = 1;
	writel(usbdev3_dgcmd.data, rDGCMD);

	// wait until command is completed
	do
	{
		udelay(1);
		usbdev3_dgcmd.data = readl(rDGCMD);
	}while(usbdev3_dgcmd.b.cmd_active);

	// wait until Rx FIFO becomes empty
	do
	{
		udelay(1);
		usbdev3_dsts.data = readl(rDSTS);
	}while(!(usbdev3_dsts.b.rx_fifo_empty));

	// . Issue a DEPCSTALL command for any stalled EP
	//--------------------------------------------
	// this routine is necessary???

	// . Set Device Address to 0
	//-----------------------
	usbdev3_dcfg.data = readl(rDCFG);
	usbdev3_dcfg.b.dev_addr = 0;
	writel(usbdev3_dcfg.data, rDCFG);

	// . Set Device State to Default
	//--------------------------
	oUsbDev3.m_eUsbDev3State = USBDEV3_STATE_DEFAULT;
}

static void exynos_usb_set_maxpktsizes(USBDEV3_SPEED_e eSpeed)
{
	oUsbDev3.m_eSpeed = eSpeed;

	if (eSpeed == USBDEV3_SPEED_SUPER)
	{
		oUsbDev3.m_uControlEPMaxPktSize = SUPER_SPEED_CONTROL_PKT_SIZE;
		oUsbDev3.m_uBulkEPMaxPktSize = SUPER_SPEED_BULK_PKT_SIZE;
	}
	else if (eSpeed == USBDEV3_SPEED_HIGH)
	{
		oUsbDev3.m_uControlEPMaxPktSize = HIGH_SPEED_CONTROL_PKT_SIZE;
		oUsbDev3.m_uBulkEPMaxPktSize = HIGH_SPEED_BULK_PKT_SIZE;
	}
	else
	{
		oUsbDev3.m_uControlEPMaxPktSize = FULL_SPEED_CONTROL_PKT_SIZE;
		oUsbDev3.m_uBulkEPMaxPktSize = FULL_SPEED_BULK_PKT_SIZE;
	}
}

static void exynos_usb_get_connected_speed(USBDEV3_SPEED_e *eSpeed)
{
	usbdev3_dsts_t usbdev3_dsts;

	usbdev3_dsts.data = readl(rDSTS);

	*eSpeed = (USBDEV3_SPEED_e)usbdev3_dsts.b.connect_speed;
}

static void exynos_usb_handle_connect_done_int(void)
{
	USBDEV3_SPEED_e eSpeed;
	usbdev3_gusb2phycfg_t usbdev3_gusb2phycfg;
	usbdev3_gusb3pipectl_t usbdev3_gusb3pipectl;

	usbdev3_depcmdpar0_set_ep_cfg_t usbdev3_depcmdpar0_set_ep_cfg;
	usbdev3_depcmdpar1_set_ep_cfg_t usbdev3_depcmdpar1_set_ep_cfg;

	oUsbDev3.m_uEp0State = EP0_STATE_INIT;

	// . Get the connected speed
	//------------------------
	exynos_usb_get_connected_speed(&eSpeed);

	// . Suspend the Inactive PHY
	//-------------------------
	if (eSpeed == USBDEV3_SPEED_SUPER)
	{
		usbdev3_gusb2phycfg.data = readl(rGUSB2PHYCFG);
		usbdev3_gusb2phycfg.b.suspend_usb2_phy = 1;
		writel(usbdev3_gusb2phycfg.data, rGUSB2PHYCFG);
	}
	else
	{
		usbdev3_gusb3pipectl.data = readl(rGUSB3PIPECTL);
		usbdev3_gusb3pipectl.b.suspend_usb3_ss_phy = 1;
		writel(usbdev3_gusb3pipectl.data, rGUSB3PIPECTL);
	}

	// . Set Max Packet Size based on enumerated speed
	//----------------------------------------------
	switch(eSpeed) {
		case USBDEV3_SPEED_SUPER :
			exynos_usb_set_maxpktsizes(USBDEV3_SPEED_SUPER);
			DBG_USBD3("(Enumerated Speed : Super)\n");
			break;

		case USBDEV3_SPEED_HIGH :
			exynos_usb_set_maxpktsizes(USBDEV3_SPEED_HIGH);
			DBG_USBD3("(Enumerated Speed : High)\n");
			break;

		case USBDEV3_SPEED_FULL :
			exynos_usb_set_maxpktsizes(USBDEV3_SPEED_FULL);
			DBG_USBD3("(Enumerated Speed : Full)\n");
			break;

		default :
			return;
	}

	// . Issue Set Ep Configuraton for EP0-OUT/IN based on the connected speed
	//----------------------------------------------------------------
	usbdev3_depcmdpar0_set_ep_cfg.data = 0;
	usbdev3_depcmdpar0_set_ep_cfg.b.ep_type = USBDEV3_EP_CTRL;
	usbdev3_depcmdpar0_set_ep_cfg.b.mps = oUsbDev3.m_uControlEPMaxPktSize;
	usbdev3_depcmdpar0_set_ep_cfg.b.ign_dsnum = 1;	// to avoid resetting the sequnece number

	usbdev3_depcmdpar1_set_ep_cfg.data = 0;
	usbdev3_depcmdpar1_set_ep_cfg.b.xfer_cmpl_en = 1;
	//usbdev3_depcmdpar1_set_ep_cfg.b.xfer_in_prog_en = 1;
	usbdev3_depcmdpar1_set_ep_cfg.b.xfer_nrdy_en = 1;
	usbdev3_depcmdpar1_set_ep_cfg.b.ep_dir = USBDEV3_EP_DIR_OUT;
	usbdev3_depcmdpar1_set_ep_cfg.b.ep_num = 0;

	if (!exynos_usb_set_ep_cfg(USBDEV3_EP_DIR_OUT, 0, usbdev3_depcmdpar0_set_ep_cfg.data, usbdev3_depcmdpar1_set_ep_cfg.data))
	{
		return ;
	}

	usbdev3_depcmdpar1_set_ep_cfg.b.ep_dir = USBDEV3_EP_DIR_IN;
	if (!exynos_usb_set_ep_cfg(USBDEV3_EP_DIR_IN, 0, usbdev3_depcmdpar0_set_ep_cfg.data, usbdev3_depcmdpar1_set_ep_cfg.data))
	{
		return ;
	}

	// . Prepare Descriptor Table
	//------------------------
	if (is_fastboot)
		fboot_usb_set_descriptors_tlb();
	else
		exynos_usb_set_descriptor_tlb();
}

static void exynos_usb_handle_dev_event(usbdev3_devt_t uDevEvent)
{
	switch (uDevEvent.b.evt_type)
	{
		case DEVT_DISCONN:
			DBG_USBD3("Disconnect\n");
			exynos_usb_handle_disconnect_int();
			break;

		case DEVT_USBRESET:
			DBG_USBD3("USB Reset\n");
			exynos_usb_handle_reset_int();
			break;

		case DEVT_CONNDONE:
			DBG_USBD3("Connect Done\n");
			exynos_usb_handle_connect_done_int();
			break;

		case DEVT_WKUP:
			DBG_USBD3("Wakeup\n");
			//USBDEV3_HandleWakeupDetectedInt();
			break;

		case DEVT_ULST_CHNG:
			DBG_USBD3("Link Status Change\n");
			//USBDEV3_HandleLinkStatusChange();
			break;

		case DEVT_EOPF:
			DBG_USBD3("End of Periodic Frame\n");
			//USBDEV3_HandleEndPeriodicFrameInt();
			break;

		case DEVT_SOF:
			DBG_USBD3("Start of Frame\n");
			//USBDEV3_HandleSofInt();
			break;

		case DEVT_ERRATICERR:
			DBG_USBD3("Erratic Error\n");
			break;

		case DEVT_CMD_CMPL:
			DBG_USBD3("Command Complete\n");
			break;

		case DEVT_OVERFLOW:
			DBG_USBD3("Overflow\n");
			break;

		default:
			DBG_USBD3("Unknown event!\n");
	}

}

static void exynos_usb_handle_ep0_in_xfer_complete(void)
{
	switch (oUsbDev3.m_uEp0State) {
		case EP0_STATE_IN_DATA_PHASE:
			oUsbDev3.m_uEp0State = EP0_STATE_OUT_WAIT_NRDY;
			break;

		case EP0_STATE_IN_STATUS_PHASE:
			oUsbDev3.m_uEp0State = EP0_STATE_INIT;

			// . to start EP0 to receive SETUP packets
			//----------------------------------
			if (!exynos_usb_start_ep0_setup_rx())
			{
				return;
			}
			break;

		// khs. this routine is abnormal case, and handling for this case is not prepared.
		default :
			DBG_USBD3("\nError : [EP0-InXferComplete]Not Supported @%d\n", oUsbDev3.m_uEp0State);
			break;
	}
}

static void exynos_usb_handle_ep_in_xfer_complete(void)
{
	g_uCntOfDescOutComplete = 0;

	g_bIsBulkInXferDone = 1;

	exynos_usb_free((u32)g_pBulkInTrbArray_Base);

	oUsbDev3.m_pUpPt += oUsbDev3.m_uUploadSize;
	DBG_USBD3("DMA IN : Transfer Complete\n");
	if (oUsbDev3.m_uUploadSize > 0) {
		exynos_receive_done = 1;
		printf("Upload Done!! Upload Address: 0x%x, Upload Filesize:0x%x\n",
				oUsbDev3.m_uUploadAddr, (oUsbDev3.m_uUploadSize));
	}

}

static int exynos_usb_start_ep0_in_xfer(u32 pBufAddr, u32 uLen)
{
	usbdev3_trb_ctrl_t usbdev3_trb_ctrl;

	usbdev3_trb_ctrl.data = 0;

	if (oUsbDev3.m_uEp0State == EP0_STATE_IN_STATUS_PHASE) {
		if (oUsbDev3.m_bEp0ThreeStage)
			usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_STATUS_3;
		else
			usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_STATUS_2;
	} else {
		usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_CTLDATA_1ST;
	}

	usbdev3_trb_ctrl.b.lst = 1;
	usbdev3_trb_ctrl.b.isp_imi = 1;
	usbdev3_trb_ctrl.b.ioc = 1;
	usbdev3_trb_ctrl.b.strmid_sofn = 0;

	exynos_usb_fill_trb(oUsbDev3.m_oInTrbPtr, pBufAddr, uLen, usbdev3_trb_ctrl.data, 1);

	// . Issue Start Xfer for EP0-IN
	//----------------------------
	if (!exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_IN, 0, (u32)oUsbDev3.m_oInTrbPtr, 0, &oUsbDev3.m_uTriIn[0]))
	{
		return 0;
	}

	return 1;
}

static int exynos_usb_start_ep0_out_xfer(u32 pBufAddr, u32 uLen)
{
	usbdev3_trb_ctrl_t usbdev3_trb_ctrl;

	usbdev3_trb_ctrl.data = 0;

	if (oUsbDev3.m_uEp0State == EP0_STATE_OUT_STATUS_PHASE) {
		if (oUsbDev3.m_bEp0ThreeStage)
			usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_STATUS_3;
		else
			usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_STATUS_2;
	} else {
		usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_CTLDATA_1ST;
	}

	usbdev3_trb_ctrl.b.lst = 1;
	usbdev3_trb_ctrl.b.isp_imi = 1;
	usbdev3_trb_ctrl.b.ioc = 1;
	usbdev3_trb_ctrl.b.strmid_sofn = 0;

	exynos_usb_fill_trb(oUsbDev3.m_oOutTrbPtr, pBufAddr, uLen, usbdev3_trb_ctrl.data, 1);

	// . Issue Start Xfer for EP0-OUT
	//----------------------------
	if (!exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_OUT, 0, (u32)oUsbDev3.m_oOutTrbPtr, 0, &oUsbDev3.m_uTriOut[0]))
	{
		return 0;
	}

	return 1;
}

static void exynos_usb_setup_in_status_phase(void)
{

	DBG_USBD3("Setup EP0 IN ZLP\n");

	oUsbDev3.m_uEp0State = EP0_STATE_IN_STATUS_PHASE;

	exynos_usb_start_ep0_in_xfer(oUsbDev3.m_uStatusBufAddr, 0);
}

static void exynos_usb_setup_out_status_phase(void)
{
	DBG_USBD3("Setup EP0 OUT ZLP\n");

	oUsbDev3.m_uEp0State = EP0_STATE_OUT_STATUS_PHASE;

	exynos_usb_start_ep0_out_xfer((u32)&oUsbDev3.m_oDeviceRequest, 0);
}

static void exynos_usb_handle_ep0_in_xfer_not_ready(void)
{
	switch (oUsbDev3.m_uEp0State) {
		case EP0_STATE_IN_WAIT_NRDY:
			// . to setup in-status phase
			exynos_usb_setup_in_status_phase();
			break;

		// khs. this routine is abnormal case, and handling for this case is not prepared.
		default :
			DBG_USBD3("\nError : [EP0-InXferNotReady]Not Supported @%d\n", oUsbDev3.m_uEp0State);
			break;
	}
}

static void exynos_usb_handle_ep_in_event(usbdev3_depevt_t uEpInEvent)
{
	u32 uEpNum = uEpInEvent.b.ep_num/2;		// 1,3,5,7,...

	DBG_USBD3("[EP%d] IN State = 0x%x Type = 0x%x[%x]\n", uEpNum, oUsbDev3.m_uEp0State, uEpInEvent.b.evt_type, uEpInEvent.data);
	switch (uEpInEvent.b.evt_type)
	{
		case DEPEVT_EVT_XFER_CMPL:
			DBG_USBD3("[EP%d] IN xfer complete @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			if (uEpNum == 0)
				exynos_usb_handle_ep0_in_xfer_complete();
			else if (uEpNum == BULK_IN_EP) {
				if (is_fastboot)
					fboot_usb_handle_ep_in_xfer_complete();
				else
					exynos_usb_handle_ep_in_xfer_complete();
			}
			else
				Assert(0);
			break;

		case DEPEVT_EVT_XFER_IN_PROG:
			DBG_USBD3("[EP%d] IN xfer in progress @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			break;

		case DEPEVT_EVT_XFER_NRDY:
			DBG_USBD3("[EP%d] IN xfer not ready @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			if (uEpNum == 0)
				exynos_usb_handle_ep0_in_xfer_not_ready();
			break;

		case DEPEVT_EVT_FIFOXRUN:
			DBG_USBD3("[EP%d] IN FIFO Underrun Error @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			break;

		case DEPEVT_EVT_STRM_EVT:
			DBG_USBD3("[EP%d] IN Stream Event @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			break;

		case DEPEVT_EVT_EPCMD_CMPL:
			DBG_USBD3("[EP%d] IN Command Complete @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			break;

		default:
			DBG_USBD3("Unknown event!\n");
	}
}

static int exynos_usb_prepare_1st_bulk_out_trb(void)
{
	usbdev3_trb_ctrl_t usbdev3_trb_ctrl;

	g_bIsBulkOutXferDone = 0;
	g_bIsBulkInXferDone = 0;

	g_pBulkOutTrb0 = (usbdev3_trb_ptr_t)exynos_usb_malloc(sizeof(usbdev3_trb_t), USBDEV3_MDWIDTH/8);
	if (g_pBulkOutTrb0 == NULL)
	{
		Assert(0);
	}
	/* size + 1 is for fastboot */
	g_ucTempDownBuf = (u8 *)exynos_usb_malloc(4096 + 1, USBDEV3_MDWIDTH/8);

	if (g_ucTempDownBuf == NULL)
	{
		Assert(0);
	}

	// . Set TRB for 1st Bulk Out Packet
	//-----------------------------
	usbdev3_trb_ctrl.data = 0;
	usbdev3_trb_ctrl.b.lst = 1;
	usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_NORMAL;
	usbdev3_trb_ctrl.b.isp_imi = 1;
	usbdev3_trb_ctrl.b.ioc = 1;
	usbdev3_trb_ctrl.b.strmid_sofn = 0;

	exynos_usb_fill_trb(g_pBulkOutTrb0, (u32)g_ucTempDownBuf, oUsbDev3.m_uBulkEPMaxPktSize, usbdev3_trb_ctrl.data, 1);

	// . Issue Start Xfer for 1st Bulk Out Packet
	//------------------------------------
	if (!exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_OUT, BULK_OUT_EP, (u32)g_pBulkOutTrb0, 0, &oUsbDev3.m_uTriOut[BULK_OUT_EP]))
	{
		return 0;
	}
	return 1;
}

void exynos_usb_handle_setup(void)
{
	const u8 *string_desc1, *string_desc2, *string_desc3;
	usbdev3_dcfg_t usbdev3_dcfg;
	u32 uRemoteWakeUp = 0;

	exynos_usb_print_ep0_pkt((u8 *)&oUsbDev3.m_oDeviceRequest, 8);

	// . sort Request type
	//-------------------
	switch(oUsbDev3.m_oDeviceRequest.bmRequestType & 0x60) {
		case STANDARD_TYPE:
			break;

		case CLASS_TYPE:
			DBG_USBD3("Class Type Request is not supported yet\n");
			return;

		case VENDOR_TYPE:
			DBG_USBD3("Vendor Type Request is not supported yet\n");
			return;

		default:
			DBG_USBD3("0x%02x Type Request is not supported yet\n", oUsbDev3.m_oDeviceRequest.bmRequestType & 0x60);
			return;
	}

	// . distinguish host2dev from dev2host
	if (oUsbDev3.m_oDeviceRequest.bmRequestType & 0x80)
		oUsbDev3.m_uEp0State = EP0_STATE_IN_DATA_PHASE;
	else
		oUsbDev3.m_uEp0State = EP0_STATE_OUT_DATA_PHASE;

	// . find requestlength and decide whether control xfer is 2 stage or 3 stage
	oUsbDev3.m_uDeviceRequestLength = (u32)((oUsbDev3.m_oDeviceRequest.wLength_H << 8) | oUsbDev3.m_oDeviceRequest.wLength_L);

	oUsbDev3.m_bEp0ThreeStage = 1;

	if (oUsbDev3.m_uDeviceRequestLength == 0)
	{
		oUsbDev3.m_uEp0State = EP0_STATE_IN_WAIT_NRDY;
		oUsbDev3.m_bEp0ThreeStage = 0;
	}


	// . handle standard type request
	//-----------------------------
	switch(oUsbDev3.m_oDeviceRequest.bRequest) {
		case STANDARD_SET_ADDRESS:
			usbdev3_dcfg.data = readl(rDCFG);
			usbdev3_dcfg.b.dev_addr = oUsbDev3.m_oDeviceRequest.wValue_L;
			writel(usbdev3_dcfg.data, rDCFG);

			DBG_USBD3("\n MCU >> Set Address : %d \n", usbdev3_dcfg.b.dev_addr);

			oUsbDev3.m_eUsbDev3State = USBDEV3_STATE_ADDRESSED;
			break;

		case STANDARD_SET_DESCRIPTOR:
			DBG_USBD3("\n MCU >> Set Descriptor \n");
			break;

		case STANDARD_SET_CONFIGURATION:
			DBG_USBD3("\n MCU >> Set Configuration \n");
			if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER)
				printf("Super speed enumeration success\n");
			g_usConfig = oUsbDev3.m_oDeviceRequest.wValue_L; // Configuration value in configuration descriptor
			oUsbDev3.m_eUsbDev3State = USBDEV3_STATE_CONFIGURED;

			// . to activate endpoints for bulk xfer
			exynos_usb_activate_ep(USBDEV3_EP_DIR_IN, BULK_IN_EP);
			exynos_usb_activate_ep(USBDEV3_EP_DIR_OUT, BULK_OUT_EP);

			// . to enable endpoints for bulk xfer
			exynos_usb_enable_ep(USBDEV3_EP_DIR_IN, BULK_IN_EP);
			exynos_usb_enable_ep(USBDEV3_EP_DIR_OUT, BULK_OUT_EP);

			exynos_usb_prepare_1st_bulk_out_trb();
			break;

		case STANDARD_GET_CONFIGURATION:
			exynos_usb_start_ep0_in_xfer((u32)&g_usConfig, 1);
			break;

		case STANDARD_GET_DESCRIPTOR:
			switch (oUsbDev3.m_oDeviceRequest.wValue_H)
			{
				case DEVICE_DESCRIPTOR:
					oUsbDev3.m_uDeviceRequestLength = (u32)((oUsbDev3.m_oDeviceRequest.wLength_H << 8) |
						oUsbDev3.m_oDeviceRequest.wLength_L);
					DBG_USBD3("\n MCU >> Get Device Descriptor = 0x%x \n",oUsbDev3.m_uDeviceRequestLength);

					if (oUsbDev3.m_uDeviceRequestLength<=DEVICE_DESC_SIZE)
					{
						exynos_usb_start_ep0_in_xfer(((u32)&(oUsbDev3.m_oDesc.oDescDevice))+0, oUsbDev3.m_uDeviceRequestLength);
					}
					else
					{
						exynos_usb_start_ep0_in_xfer(((u32)&(oUsbDev3.m_oDesc.oDescDevice))+0, DEVICE_DESC_SIZE);
					}
					break;

				case CONFIGURATION_DESCRIPTOR:
					oUsbDev3.m_uDeviceRequestLength = (u32)((oUsbDev3.m_oDeviceRequest.wLength_H << 8) |
						oUsbDev3.m_oDeviceRequest.wLength_L);
					DBG_USBD3("\n MCU >> Get Configuration Descriptor = 0x%x \n",oUsbDev3.m_uDeviceRequestLength);

					if (oUsbDev3.m_uDeviceRequestLength > CONFIG_DESC_SIZE){
					// === GET_DESCRIPTOR:CONFIGURATION+INTERFACE+ENDPOINT0+ENDPOINT1 ===
					// Windows98 gets these 4 descriptors all together by issuing only a request.
					// Windows2000 gets each descriptor seperately.
					// oUsbDev3.m_uEpZeroTransferLength = CONFIG_DESC_TOTAL_SIZE;
						if(oUsbDev3.m_uDeviceRequestLength<=oUsbDev3.m_oDesc.oDescConfig.wTotalLengthL)
						{
							exynos_usb_start_ep0_in_xfer(((u32)&(oUsbDev3.m_oDesc.oDescConfig))+0, oUsbDev3.m_uDeviceRequestLength);
						}
						else
						{
							exynos_usb_start_ep0_in_xfer(((u32)&(oUsbDev3.m_oDesc.oDescConfig))+0, oUsbDev3.m_oDesc.oDescConfig.wTotalLengthL);
						}
					}
					else		// for win2k
					{
						if(oUsbDev3.m_uDeviceRequestLength<=CONFIG_DESC_SIZE)
						{
							exynos_usb_start_ep0_in_xfer(((u32)&(oUsbDev3.m_oDesc.oDescConfig))+0, oUsbDev3.m_uDeviceRequestLength);
						}
						else
						{
							exynos_usb_start_ep0_in_xfer(((u32)&(oUsbDev3.m_oDesc.oDescConfig))+0, CONFIG_DESC_SIZE);
						}
					}
					break;

				case STRING_DESCRIPTOR :
					DBG_USBD3("\n MCU >> Get String Descriptor \n");
					if (is_fastboot) {
						string_desc1 = fboot_string_desc1;
						string_desc2 = fboot_string_desc2;
						string_desc3 = fboot_string_desc3;
					} else {
						string_desc1 = dnw_string_desc1;
						string_desc2 = dnw_string_desc2;
					}

					switch(oUsbDev3.m_oDeviceRequest.wValue_L)
					{
						case 0:
							exynos_usb_start_ep0_in_xfer((u32)string_desc0, STRING_DESC0_SIZE);
							break;
						case 1:
							exynos_usb_start_ep0_in_xfer((u32)string_desc1, STRING_DESC1_SIZE);
							break;
						case 2:
							exynos_usb_start_ep0_in_xfer((u32)string_desc2, STRING_DESC2_SIZE);
							break;
						case 3:
							exynos_usb_start_ep0_in_xfer((u32)string_desc2, STRING_DESC2_SIZE);
							break;
						default:
								break;
					}
					break;

				case ENDPOINT_DESCRIPTOR:
					DBG_USBD3("\n MCU >> Get Endpoint Descriptor \n");
					switch(oUsbDev3.m_oDeviceRequest.wValue_L&0xf)
					{
						case 0:
							if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER)
								exynos_usb_start_ep0_in_xfer((u32)&(oUsbDev3.m_oSSDesc.oDescEp0), ENDPOINT_DESC_SIZE+ENDPOINT_COMP_DESC_SIZE);
							else
								exynos_usb_start_ep0_in_xfer((u32)&(oUsbDev3.m_oDesc.oDescEp0), ENDPOINT_DESC_SIZE);
							break;
						case 1:
							if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER)
								exynos_usb_start_ep0_in_xfer((u32)&(oUsbDev3.m_oSSDesc.oDescEp1), ENDPOINT_DESC_SIZE+ENDPOINT_COMP_DESC_SIZE);
							else
								exynos_usb_start_ep0_in_xfer((u32)&(oUsbDev3.m_oDesc.oDescEp1), ENDPOINT_DESC_SIZE);
							break;
						default:
							break;
					}
					break;

				case DEVICE_QUALIFIER:	// only supported in over 2.0
					oUsbDev3.m_uDeviceRequestLength = (u32)((oUsbDev3.m_oDeviceRequest.wLength_H << 8) |
						oUsbDev3.m_oDeviceRequest.wLength_L);
					DBG_USBD3("\n MCU >> Get Device Qualifier Descriptor = 0x%x \n",oUsbDev3.m_uDeviceRequestLength);

					if(oUsbDev3.m_uDeviceRequestLength<=10)
					{
						exynos_usb_start_ep0_in_xfer((u32)qualifier_desc, oUsbDev3.m_uDeviceRequestLength);
					}
					else
					{
						exynos_usb_start_ep0_in_xfer((u32)qualifier_desc, 10);
					}
					break;

				case OTHER_SPEED_CONFIGURATION :
					DBG_USBD3(("\n MCU >> Get OTHER_SPEED_CONFIGURATION \n"));
					oUsbDev3.m_uDeviceRequestLength = (u32)((oUsbDev3.m_oDeviceRequest.wLength_H << 8) |
						oUsbDev3.m_oDeviceRequest.wLength_L);

					if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_HIGH)
					{
						if (oUsbDev3.m_uDeviceRequestLength ==9)
						{
							exynos_usb_start_ep0_in_xfer((u32)config_high, 9);
						}
						else if(oUsbDev3.m_uDeviceRequestLength ==32)
						{
							exynos_usb_start_ep0_in_xfer((u32)config_high_total, 32);
						}
					}
					else if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_FULL)
					{
						if (oUsbDev3.m_uDeviceRequestLength ==9)
						{
							exynos_usb_start_ep0_in_xfer((u32)config_full, 9);
						}
						else if(oUsbDev3.m_uDeviceRequestLength ==32)
						{
							exynos_usb_start_ep0_in_xfer((u32)config_full_total, 32);
						}
					}
					else	// super
					{
						DBG_USBD3("\n %s(line %d)\n", __FILE__, __LINE__);
						DBG_USBD3("Error : Not implemented yet\n");
					}

					break;
				case BOS :
					if (oUsbDev3.m_uDeviceRequestLength == BOS_DESC_SIZE)
						exynos_usb_start_ep0_in_xfer((u32)&oUsbDev3.m_oSSDesc.oDescBos, BOS_DESC_SIZE);
					else
						exynos_usb_start_ep0_in_xfer((u32)&oUsbDev3.m_oSSDesc.oDescBos, BOS_DESC_TOTAL_SIZE);
					break;
			}
			break;

		case STANDARD_CLEAR_FEATURE:
			DBG_USBD3("\n MCU >> Clear Feature \n");
			switch (oUsbDev3.m_oDeviceRequest.bmRequestType)
			{
				case DEVICE_RECIPIENT:
					if (oUsbDev3.m_oDeviceRequest.wValue_L == 1)
						uRemoteWakeUp = 0;
					break;

				case ENDPOINT_RECIPIENT:
					if (oUsbDev3.m_oDeviceRequest.wValue_L == 0)
					{
						if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == CONTROL_EP)
							oStatusGet.EndpointCtrl= 0;

						if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == BULK_IN_EP) // IN  Endpoint
							oStatusGet.EndpointIn= 0;

						if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == BULK_OUT_EP) // OUT Endpoint
							oStatusGet.EndpointOut= 0;
					}
					break;

				default:
					break;
			}
			break;

		case STANDARD_SET_FEATURE:
			DBG_USBD3("\n MCU >> Set Feature \n");
			switch (oUsbDev3.m_oDeviceRequest.bmRequestType)
			{
				case DEVICE_RECIPIENT:
					if (oUsbDev3.m_oDeviceRequest.wValue_L == 1)
						uRemoteWakeUp = 1;
						break;

				case ENDPOINT_RECIPIENT:
					if (oUsbDev3.m_oDeviceRequest.wValue_L == 0)
					{
						if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == CONTROL_EP)
							oStatusGet.EndpointCtrl= 1;

						if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == BULK_IN_EP)
							oStatusGet.EndpointIn= 1;

						if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == BULK_OUT_EP)
							oStatusGet.EndpointOut= 1;
					}
					break;

				default:
					break;
			}

			//=======================================================

			switch (oUsbDev3.m_oDeviceRequest.wValue_L) {

				case EP_STALL:
					// TBD: additional processing if required
					break;


				case TEST_MODE:
					if ((0 != oUsbDev3.m_oDeviceRequest.wIndex_L ) ||(0 != oUsbDev3.m_oDeviceRequest.bmRequestType))
					{
						DBG_USBD3("\n %s(line %d)\n", __FILE__, __LINE__);
						DBG_USBD3("Error : Wrong Request Parameter\n");
						break;
					}

					switch(oUsbDev3.m_oDeviceRequest.wIndex_H)
					{
						usbdev3_dctl_t usbdev3_dctl;

						case TEST_J:
							//Set Test J
							exynos_usb_start_ep0_in_xfer((u32)NULL, 0);
							DBG_USBD3 ("Test_J\n");
							usbdev3_dctl.data = readl(rDCTL);
							usbdev3_dctl.b.test_ctrl = (u32)DCTL_TEST_J_MODE;
							writel(usbdev3_dctl.data, rDCTL);
							break;

						case TEST_K:
							//Set Test K
							exynos_usb_start_ep0_in_xfer((u32)NULL, 0);
							DBG_USBD3 ("Test_K\n");
							usbdev3_dctl.data = readl(rDCTL);
							usbdev3_dctl.b.test_ctrl = (u32)DCTL_TEST_K_MODE;
							writel(usbdev3_dctl.data, rDCTL);
							break;

						case TEST_SE0_NAK:
							//Set Test SE0_NAK
							exynos_usb_start_ep0_in_xfer((u32)NULL, 0);
							DBG_USBD3 ("Test_SE0_NAK\n");
							usbdev3_dctl.data = readl(rDCTL);
							usbdev3_dctl.b.test_ctrl = (u32)DCTL_TEST_SE0_NAK_MODE;
							writel(usbdev3_dctl.data, rDCTL);
							break;

						case TEST_PACKET:
							//Set Test Packet
							exynos_usb_start_ep0_in_xfer((u32)NULL, 0);

							// khs. Is this routine necessary?
							//exynos_usb_start_ep0_in_xfer((u32)TestPkt, TEST_PKT_SIZE);

							DBG_USBD3 ("Test_Packet\n");
							usbdev3_dctl.data = readl(rDCTL);
							usbdev3_dctl.b.test_ctrl = (u32)DCTL_TEST_PACKET_MODE;
							writel(usbdev3_dctl.data, rDCTL);
							break;

						case TEST_FORCE_ENABLE:
							//Set Test Force Enable
							exynos_usb_start_ep0_in_xfer((u32)NULL, 0);
							DBG_USBD3 ("Test_Force_Enable\n");
							usbdev3_dctl.data = readl(rDCTL);
							usbdev3_dctl.b.test_ctrl = (u32)DCTL_TEST_FORCE_ENABLE;
							writel(usbdev3_dctl.data, rDCTL);
							break;
					}

					break;

				default:
					break;
			}
			//=======================================================
			break;

		case STANDARD_GET_STATUS:
			switch(oUsbDev3.m_oDeviceRequest.bmRequestType)
			{
				case  (0x80):	//device
					oStatusGet.Device=((u8)uRemoteWakeUp<<1)|0x1;		// SelfPowered
					exynos_usb_start_ep0_in_xfer((u32)&oStatusGet.Device, 1);
					break;

				case  (0x81):	//interface
					oStatusGet.Interface=0;
					exynos_usb_start_ep0_in_xfer((u32)&oStatusGet.Interface, 1);
					break;

				case  (0x82):	//endpoint
					if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == CONTROL_EP)
						exynos_usb_start_ep0_in_xfer((u32)&oStatusGet.EndpointCtrl, 1);

					if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == BULK_IN_EP)
						exynos_usb_start_ep0_in_xfer((u32)&oStatusGet.EndpointIn, 1);

					if ((oUsbDev3.m_oDeviceRequest.wIndex_L & 0x7f) == BULK_OUT_EP)
						exynos_usb_start_ep0_in_xfer((u32)&oStatusGet.EndpointOut, 1);
					break;

				default:
					break;
			}
			break;

		case STANDARD_GET_INTERFACE:
			exynos_usb_start_ep0_in_xfer((u32)&oInterfaceGet.AlternateSetting, 1);
			break;

		case STANDARD_SET_INTERFACE:
			oInterfaceGet.AlternateSetting= oUsbDev3.m_oDeviceRequest.wValue_L;
			break;

		case STANDARD_SYNCH_FRAME:
			break;

		case STANDARD_SET_SEL:
			oUsbDev3.m_bReq_Set_sel= 1;
			/* For SET_SEL */
			exynos_usb_start_ep0_out_xfer((u32)&set_sel, oUsbDev3.m_uControlEPMaxPktSize);
			DBG_USBD3("Standard Req : SET SEL\n");
			break;

		case STANDARD_ISOCH_DELY:
			DBG_USBD3("Standard Req : ISOCH Delay\n");
			break;

		default:
			DBG_USBD3("\n %s(line %d)\n", __FILE__, __LINE__);
			DBG_USBD3("Error : This Request(%d) is not implemented yet\n", oUsbDev3.m_oDeviceRequest.bRequest);
			break;
	}
}

static void exynos_usb_handle_ep0_out_xfer_complete(void)
{
	switch (oUsbDev3.m_uEp0State) {
		case EP0_STATE_INIT:
			exynos_usb_handle_setup();
			break;

		case EP0_STATE_OUT_DATA_PHASE:
			oUsbDev3.m_uEp0State = EP0_STATE_IN_WAIT_NRDY;
			break;

		case EP0_STATE_OUT_STATUS_PHASE:
			oUsbDev3.m_uEp0State = EP0_STATE_INIT;

			// . to start EP0 to receive SETUP packets
			//----------------------------------
			if (!exynos_usb_start_ep0_setup_rx())
			{
				return;
			}
			break;

		// khs. this routine is abnormal case, and handling for this case is not prepared.
		default :
			DBG_USBD3("\nError : [EP0-OutXferComplete]Not Supported @%d\n", oUsbDev3.m_uEp0State);
			break;
	}

}

static void exynos_usb_handle_ep_out_xfer_complete(void)
{
	u16	usRxCnt;
	u16 usCheck;
	u32 usCapTrbBufSiz;
	u32 uLastBufSize;
	u32 i=0;
	usbdev3_trb_ptr_t pBulkOutTrb;
	usbdev3_trb_ptr_t pBulkInTrb;
	usbdev3_trb_ctrl_t usbdev3_trb_ctrl;

	if (g_uCntOfDescOutComplete == 0)
	{
		// Check whether TRB was finished successfully or not
		if ((g_pBulkOutTrb0->control.b.hwo != 0)||(g_pBulkOutTrb0->status.b.trb_sts != 0))
		{
			Assert(0);
		}

		g_uCntOfDescOutComplete++;

		usRxCnt = oUsbDev3.m_uBulkEPMaxPktSize - g_pBulkOutTrb0->status.b.buf_siz;

		exynos_usb_free((u32)g_pBulkOutTrb0);

		if (usRxCnt == 10)		//Upload Request
		{
			usCheck = *((u8 *)(g_ucTempDownBuf+8)) + (*((u8 *)(g_ucTempDownBuf+9))<<8);

			if (usCheck == 0x1)
			{
				oUsbDev3.m_uUploadAddr =
					*((u8 *)(g_ucTempDownBuf+0))+
					(*((u8 *)(g_ucTempDownBuf+1))<<8)+
					(*((u8 *)(g_ucTempDownBuf+2))<<16)+
					(*((u8 *)(g_ucTempDownBuf+3))<<24);

				oUsbDev3.m_uUploadSize =
					*((u8 *)(g_ucTempDownBuf+4))+
					(*((u8 *)(g_ucTempDownBuf+5))<<8)+
					(*((u8 *)(g_ucTempDownBuf+6))<<16)+
					(*((u8 *)(g_ucTempDownBuf+7))<<24);

				exynos_usb_free((u32)g_ucTempDownBuf);

				oUsbDev3.m_pUpPt=(u8 *)oUsbDev3.m_uUploadAddr;

				DBG_USBD3("UploadAddress : 0x%x, UploadSize: %d\n", oUsbDev3.m_uUploadAddr, oUsbDev3.m_uUploadSize);

				if (oUsbDev3.m_uUploadSize>0)
				{
					DBG_USBD3("Dma Start for IN PKT \n");

					// buffer_size of TRB should be
					usCapTrbBufSiz = TRB_BUF_SIZ_LIMIT/oUsbDev3.m_uBulkEPMaxPktSize*oUsbDev3.m_uBulkEPMaxPktSize;

					g_uCntOfBulkInTrb = oUsbDev3.m_uUploadSize/usCapTrbBufSiz;

					if ((oUsbDev3.m_uUploadSize%usCapTrbBufSiz) != 0)
					{
						g_uCntOfBulkInTrb++;
					}

					g_pBulkInTrbArray_Base = (usbdev3_trb_ptr_t)exynos_usb_malloc(g_uCntOfBulkInTrb*sizeof(usbdev3_trb_t), USBDEV3_MDWIDTH/8);

					if (g_pBulkInTrbArray_Base == NULL)
					{
						Assert(0);
					}

					pBulkInTrb = g_pBulkInTrbArray_Base;


					// . fill the Trbs
					//------------------
					// (Total Buffer size must be in terms of multiple of Max Packet Size)
					usbdev3_trb_ctrl.data = 0;
					usbdev3_trb_ctrl.b.lst = 0;
					usbdev3_trb_ctrl.b.chn = 1;
					usbdev3_trb_ctrl.b.csp = 0;
					usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_NORMAL;
					usbdev3_trb_ctrl.b.isp_imi = 1;
					usbdev3_trb_ctrl.b.ioc = 0;
					usbdev3_trb_ctrl.b.strmid_sofn = 0;
					for(i=0;i<(g_uCntOfBulkInTrb-1);i++)
					{
						exynos_usb_fill_trb(pBulkInTrb, (u32)(oUsbDev3.m_pUpPt+usCapTrbBufSiz*i), usCapTrbBufSiz, usbdev3_trb_ctrl.data, 1);
						pBulkInTrb++;
					}

					// i = g_uCntOfBulkInTrb-1, last Trb
					usbdev3_trb_ctrl.b.lst = 1;
					usbdev3_trb_ctrl.b.chn = 0;
					usbdev3_trb_ctrl.b.ioc = 1;
					uLastBufSize = oUsbDev3.m_uUploadSize-usCapTrbBufSiz*i;
					exynos_usb_fill_trb(pBulkInTrb, (u32)(oUsbDev3.m_pUpPt+usCapTrbBufSiz*i), uLastBufSize, usbdev3_trb_ctrl.data, 1);
					//
					////

					// . Issue Start Xfer for Bulk In Xfer
					//----------------------------
					if (!exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_IN, BULK_IN_EP, (u32)g_pBulkInTrbArray_Base, 0, &oUsbDev3.m_uTriIn[BULK_IN_EP]))
					{
						return;
					}
				}
			}
			else
			{
				Assert(0);
			}
		}
		else		//Download Request
		{
			oUsbDev3.m_uDownloadAddress =
					*((u8 *)(g_ucTempDownBuf+0))+
					(*((u8 *)(g_ucTempDownBuf+1))<<8)+
					(*((u8 *)(g_ucTempDownBuf+2))<<16)+
					(*((u8 *)(g_ucTempDownBuf+3))<<24);
			oUsbDev3.m_uDownloadFileSize =
				*((u8 *)(g_ucTempDownBuf+4))+
				(*((u8 *)(g_ucTempDownBuf+5))<<8)+
				(*((u8 *)(g_ucTempDownBuf+6))<<16)+
				(*((u8 *)(g_ucTempDownBuf+7))<<24);

			if (exynos_usbd_dn_addr)
			{
				oUsbDev3.m_uDownloadAddress = exynos_usbd_dn_addr;		// Request usb down Addr
			}

			oUsbDev3.m_pDownPt=(u8 *)oUsbDev3.m_uDownloadAddress;

			DBG_USBD3("downloadAddress : 0x%x, downloadFileSize: %d\n", oUsbDev3.m_uDownloadAddress, oUsbDev3.m_uDownloadFileSize);

			memcpy((void *)oUsbDev3.m_pDownPt, (void *)(g_ucTempDownBuf+8), usRxCnt-8);

			exynos_usb_free((u32)g_ucTempDownBuf);

			oUsbDev3.m_pDownPt += usRxCnt-8;

			if (oUsbDev3.m_uDownloadFileSize>usRxCnt)	//there are more data to be received
			{

				usCapTrbBufSiz = TRB_BUF_SIZ_LIMIT/oUsbDev3.m_uBulkEPMaxPktSize*oUsbDev3.m_uBulkEPMaxPktSize;

				g_uCntOfBulkOutTrb = (oUsbDev3.m_uDownloadFileSize-usRxCnt)/usCapTrbBufSiz;

				if ((oUsbDev3.m_uDownloadFileSize-usRxCnt)%usCapTrbBufSiz != 0)
				{
					g_uCntOfBulkOutTrb++;
				}

				g_pBulkOutTrbArray_Base = (usbdev3_trb_ptr_t)exynos_usb_malloc(g_uCntOfBulkOutTrb*sizeof(usbdev3_trb_t), USBDEV3_MDWIDTH/8);

				if (g_pBulkOutTrbArray_Base == NULL)
				{
					Assert(0);
				}

				pBulkOutTrb = (usbdev3_trb_ptr_t)virt_to_phys((void *)g_pBulkOutTrbArray_Base);

				// . fill the Trbs
				//------------------
				// (Total Buffer size must be in terms of multiple of Max Packet Size)
				usbdev3_trb_ctrl.data = 0;
				usbdev3_trb_ctrl.b.lst = 0;
				usbdev3_trb_ctrl.b.chn = 1;
				usbdev3_trb_ctrl.b.csp = 0;
				usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_NORMAL;
				usbdev3_trb_ctrl.b.isp_imi = 1;
				usbdev3_trb_ctrl.b.ioc = 0;
				usbdev3_trb_ctrl.b.strmid_sofn = 0;

				for(i=0;i<(g_uCntOfBulkOutTrb-1);i++)
				{
					exynos_usb_fill_trb(pBulkOutTrb, (u32)(oUsbDev3.m_pDownPt+usCapTrbBufSiz*i), usCapTrbBufSiz, usbdev3_trb_ctrl.data, 1);
					pBulkOutTrb++;
				}

				// i = g_uCntOfBulkOutTrb-1, last Trb
				usbdev3_trb_ctrl.b.lst = 1;
				usbdev3_trb_ctrl.b.chn = 0;
				usbdev3_trb_ctrl.b.ioc = 1;
				uLastBufSize = (oUsbDev3.m_uDownloadFileSize-usRxCnt)-usCapTrbBufSiz*i;
				uLastBufSize = ((uLastBufSize+oUsbDev3.m_uBulkEPMaxPktSize-1)/oUsbDev3.m_uBulkEPMaxPktSize)*oUsbDev3.m_uBulkEPMaxPktSize;
				exynos_usb_fill_trb(pBulkOutTrb, (u32)(oUsbDev3.m_pDownPt+usCapTrbBufSiz*i), uLastBufSize, usbdev3_trb_ctrl.data, 1);
				//
				////

				// . Issue Start Xfer for Bulk Out Xfer
				//----------------------------
				if (!exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_OUT, BULK_OUT_EP, (u32)g_pBulkOutTrbArray_Base, 0, &oUsbDev3.m_uTriOut[BULK_OUT_EP]))
				{
					return;
				}
			}
			else		//there are no more data
			{
				g_uCntOfDescOutComplete = 0;

				exynos_receive_done = 1;

				DBG_USBD3("DMA OUT : Transfer Complete\n");
			}
		}
	}
	else
	{
		g_uCntOfDescOutComplete = 0;

		exynos_receive_done = 1;

		exynos_usb_free((u32)g_pBulkOutTrbArray_Base);

		oUsbDev3.m_pDownPt += (oUsbDev3.m_uDownloadFileSize - 8);

		printf("Download Done!! Download Address: 0x%x, Download Filesize:0x%x\n",
				oUsbDev3.m_uDownloadAddress, (oUsbDev3.m_uDownloadFileSize-10));
	}
}

static void exynos_usb_handle_ep0_out_xfer_not_ready(void)
{
	switch (oUsbDev3.m_uEp0State) {
		case EP0_STATE_OUT_WAIT_NRDY:
			// . to setup out-status phase
			exynos_usb_setup_out_status_phase();
			break;
		// khs. this routine is abnormal case, and handling for this case is not prepared.
		default :
			DBG_USBD3("\nError : [EP0-OutXferNotReady]Not Supported @%d\n", oUsbDev3.m_uEp0State);
			break;
	}
}

static void exynos_usb_handle_ep_out_event(usbdev3_depevt_t uEpOutEvent)
{
	u32 uEpNum = uEpOutEvent.b.ep_num/2;	// 0,2,4,6,...

	DBG_USBD3("[EP%d] Out State = 0x%x Type = 0x%x[0x%x]\n", uEpNum, oUsbDev3.m_uEp0State, uEpOutEvent.b.evt_type, uEpOutEvent.data);
	switch (uEpOutEvent.b.evt_type)
	{
		case DEPEVT_EVT_XFER_CMPL:
			DBG_USBD3("[EP%d] OUT xfer complete @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			if (uEpNum == 0)
				exynos_usb_handle_ep0_out_xfer_complete();
			else if (uEpNum == BULK_OUT_EP) {
				if (is_fastboot)
					fboot_usb_handle_ep_out_xfer_complete();
				else
					exynos_usb_handle_ep_out_xfer_complete();
			} else
				Assert(0);
			break;

		case DEPEVT_EVT_XFER_IN_PROG:
			DBG_USBD3("[EP%d] OUT xfer in progress @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			break;

		case DEPEVT_EVT_XFER_NRDY:
			DBG_USBD3("[EP%d] OUT xfer not ready @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			if (uEpNum == 0)
				exynos_usb_handle_ep0_out_xfer_not_ready();
			else
				;//
			break;

		case DEPEVT_EVT_FIFOXRUN:
			DBG_USBD3("[EP%d] OUT FIFO Overrun Error @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			break;

		case DEPEVT_EVT_STRM_EVT:
			DBG_USBD3("[EP%d] OUT Stream Event @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			break;

		case DEPEVT_EVT_EPCMD_CMPL:
			DBG_USBD3("[EP%d] OUT Command Complete @%d\n", uEpNum, oUsbDev3.m_uEp0State);
			break;

		default:
			DBG_USBD3("Unknown event!\n");
	}

}

static void exynos_usb_handle_event(void)
{
	u16 uEventCount, uLoop=0;
	u32 uEventBufferCopied;

	// . Get Event Buffer Count
	//----------------------
	uEventCount = readl(rGEVNTCOUNT0);

	uEventCount = uEventCount/4;

	if (uEventCount == 0)
	{
		return;
	}
	else
	{
		DBG_USBD3("## Event Count is %d ##\n", uEventCount);
	}

	while((uEventCount--> 0) && (uLoop < USBDEV3_EVENT_BUFFER_COUNT))
	{
		if (oUsbDev3.m_CurrentEventPosition == USBDEV3_EVENT_BUFFER_COUNT)
		{
			oUsbDev3.m_CurrentEventPosition = 0;
		}

		uEventBufferCopied = *(oUsbDev3.m_pEventBuffer + oUsbDev3.m_CurrentEventPosition);	// to avoid that event buffer is overwritten.

		uLoop++;
		oUsbDev3.m_CurrentEventPosition++;

		writel(4, rGEVNTCOUNT0);	// update event buffer count
		// core update event buffer whenever event occurs
		if (uEventBufferCopied == 0)
		{
			DBG_USBD3("## Null Event!##\n");
		}
		else		// event buffer contains event information
		{
			DBG_USBD3("\nLoop%d: Content of %dth Event Buffer is 0x%08x\n", uLoop, oUsbDev3.m_CurrentEventPosition, uEventBufferCopied);

			// Device-Specific Event
			if (uEventBufferCopied & 0x1)
			{
				usbdev3_devt_t usbdev3_devt;

				usbdev3_devt.data = uEventBufferCopied;

				//DBG_USBD3IntR("Device-Specific Event Occurred\n");

				if (usbdev3_devt.b.dev_specific != 0)
				{
					DBG_USBD3("Other Core Event\n");
				}

				exynos_usb_handle_dev_event(usbdev3_devt);
			}
			else		// Device Endpoint-Specific Event
			{
				usbdev3_depevt_t usbdev3_depevt;
				u32 uEpNum;

				usbdev3_depevt.data = uEventBufferCopied;

				uEpNum = usbdev3_depevt.b.ep_num;

				if (uEpNum & 1)
				{
					DBG_USBD3("IN Endpoint%d Event Occurred\n", (uEpNum/2));
					exynos_usb_handle_ep_in_event(usbdev3_depevt);
				}
				else
				{
					DBG_USBD3("OUT Endpoint%d Event Occurred\n", (uEpNum/2));
					exynos_usb_handle_ep_out_event(usbdev3_depevt);
				}
			}
		}
	}
}

struct exynos_usb3_phy {
	unsigned int reserve1;
	unsigned int link_system;
	unsigned int phy_utmi;
	unsigned int phy_pipe;
	unsigned int phy_clk_rst;
	unsigned int phy_reg0;
	unsigned int phy_reg1;
	unsigned int phy_param0;
	unsigned int phy_param1;
	unsigned int phy_term;
	unsigned int phy_test;
	unsigned int phy_adp;
	unsigned int phy_batchg;
	unsigned int phy_resume;
	unsigned int reserve2[3];
	unsigned int link_port;
};

int exynos_usb_wait_cable_insert(void)
{
	u32 tmp1, tmp2;
	char ch;
	int ret = -1;
	oUsbDev3.m_uPhyBaseRegs = USBDEVICE3_PHYCTRL_CH0_BASE;
	tmp1 = readl(EXYNOS_PHY_ADP);
	oUsbDev3.m_uPhyBaseRegs = USBDEVICE3_PHYCTRL_CH1_BASE;
	tmp2 = readl(EXYNOS_PHY_ADP);
	oUsbDev3.m_uPhyBaseRegs = 0;
	if (tmp1 & 0x8 || tmp2 & 0x8) {
		if(oUsbDev3.m_cable != CONNECTED) {
			ch = (tmp1 & 0x8) ? 0 : 1;
			printf("USB cable Connected![CH-%d]\n", ch);
			ret = 0;
			oUsbDev3.m_cable = CONNECTED;
			if (!ch) {
				oUsbDev3.m_uLinkBaseRegs = USBDEVICE3_LINK_CH0_BASE;
				oUsbDev3.m_uPhyBaseRegs = USBDEVICE3_PHYCTRL_CH0_BASE;
			} else {
				oUsbDev3.m_uLinkBaseRegs = USBDEVICE3_LINK_CH1_BASE;
				oUsbDev3.m_uPhyBaseRegs = USBDEVICE3_PHYCTRL_CH1_BASE;
			}
		}
	} else {
		if(oUsbDev3.m_cable == UNCHECKED) {
			printf("Insert a USB cable into the connector!\n");
			oUsbDev3.m_cable = DISCONNECTED;
		} else if(oUsbDev3.m_cable == CONNECTED) {
			oUsbDev3.m_cable = UNCHECKED;
			exynos_usb_runstop_device(0);
			is_fastboot = 0;
		}
	}
	return ret;
}

int exynos_usbc_activate (void)
{
	exynos_usb_runstop_device(1);
	return 0;
}

int exynos_usb_stop( void )
{
	if(oUsbDev3.m_cable == CONNECTED)
		exynos_usb_runstop_device(0);

	exynoy_usb_phy_off();
	oUsbDev3.m_cable = UNCHECKED;

	return 0;
}

int exynos_udc_int_hndlr(void)
{
	exynos_usb_handle_event();
	return OK;
}

int exynos_usbctl_init(void)
{
	usbdev3_gusb2phycfg_t usbdev3_gusb2phycfg;
	usbdev3_gusb3pipectl_t usbdev3_gusb3pipectl;
	usbdev3_gctl_t usbdev3_gctl;
	USBDEV3_SPEED_e eSpeed = USBDEV3_SPEED_SUPER;

	// . to initialize variables for usb device
	//--------------------------------
	// khs. to be implemented more
	oUsbDev3.m_eSpeed = eSpeed;
	oUsbDev3.m_eUsbDev3State = USBDEV3_STATE_DEFAULT;
	oUsbDev3.m_uEp0State = EP0_STATE_UNCONNECTED;
	oUsbDev3.m_uEp0SubState = 0;
	oUsbDev3.m_bEPs_Enabled = 0;
	oUsbDev3.m_bReq_Set_sel = 0;
	switch(eSpeed)
	{
		case USBDEV3_SPEED_SUPER:
			oUsbDev3.m_uControlEPMaxPktSize = SUPER_SPEED_CONTROL_PKT_SIZE;
			break;

		case USBDEV3_SPEED_FULL:
			oUsbDev3.m_uControlEPMaxPktSize = FULL_SPEED_CONTROL_PKT_SIZE;
			break;

		default :
			oUsbDev3.m_uControlEPMaxPktSize = HIGH_SPEED_CONTROL_PKT_SIZE;
			break;
	}

	// . to allocate initial buffers for usb device
	//------------------------------------
	oUsbDev3.m_pEventBuffer = (u32 *)exynos_usb_malloc(4*USBDEV3_EVENT_BUFFER_COUNT, USBDEV3_MDWIDTH/8);
	oUsbDev3.m_uStatusBufAddr = exynos_usb_malloc(CTRL_BUF_SIZE, USBDEV3_MDWIDTH/8);
	oUsbDev3.m_oSetupTrbPtr = (usbdev3_trb_ptr_t)exynos_usb_malloc(sizeof(usbdev3_trb_t), USBDEV3_MDWIDTH/8);
	oUsbDev3.m_oOutTrbPtr = (usbdev3_trb_ptr_t)exynos_usb_malloc(sizeof(usbdev3_trb_t), USBDEV3_MDWIDTH/8);
	oUsbDev3.m_oInTrbPtr = (usbdev3_trb_ptr_t)exynos_usb_malloc(sizeof(usbdev3_trb_t), USBDEV3_MDWIDTH/8);

	// khs. ep_init 함수 호출을 통한 ep 별 structure 초기화 수행해야할까....?

	// . to set AP system related to usb device (ex. clock source & gating, phy enable)
	//--------------------------------------------------------------------
	// - to enable a bus clock for usb dev controller & phy control block
	//TODO: Enable system clock and so on.
	/* USBDEV3_HclkUsb3ClkGate(true); */
	/* USBDEV3_Usb3PhyEnable();		  // USB PHY Enable */
	exynos_usb_phy_on();

	/* EXYNOS5 EVT1 : PHY should be reset before global register configuration
	   This sequence cover reset sequence on EXYNOS5 EVT0. */
	exynos_usb_softreset_phy(1);
	exynos_usb_init_phy();
	exynos_usb_softreset_phy(0);

	usbdev3_gusb2phycfg.data = readl(rGUSB2PHYCFG);
	usbdev3_gusb2phycfg.b.suspend_usb2_phy = 0;
	usbdev3_gusb2phycfg.b.enable_sleep_n = 0;
	writel(usbdev3_gusb2phycfg.data, rGUSB2PHYCFG);

	usbdev3_gusb3pipectl.data = readl(rGUSB3PIPECTL);
	usbdev3_gusb3pipectl.b.suspend_usb3_ss_phy = 0;
	writel(usbdev3_gusb3pipectl.data, rGUSB3PIPECTL);

	// . to initialize usb device phy
	//--------------------------
	usbdev3_gctl.data = readl(rGCTL);
	usbdev3_gctl.b.core_soft_reset = 1;	// to keep the core in reset state until phy clocks are stable(GCTL의 11번 bit 설명 참조)
	/*
	* WORKAROUND: DWC3 revisions <1.90a have a bug
	* when The device fails to connect at SuperSpeed
	* and falls back to high-speed mode which causes
	* the device to enter in a Connect/Disconnect loop
	*/
	usbdev3_gctl.b.u2rst_ecn = 1;
	writel(usbdev3_gctl.data, rGCTL);

	usbdev3_gctl.data = readl(rGCTL);
	usbdev3_gctl.b.core_soft_reset = 0;	// to keep the core out of reset state after phy clocks are stable(GCTL의 11번 bit 설명 참조)
	writel(usbdev3_gctl.data, rGCTL);

	usbdev3_gctl.b.pwr_down_scale = ((unsigned int)get_usbdrd_clk()) / 16000;
	usbdev3_gctl.b.ram_clk_sel = 0; // 00:bus clock, 01:pipe clock, 10:pipe/2 clock
	usbdev3_gctl.b.DisScramble = 0;
	writel(usbdev3_gctl.data, rGCTL);

	g_uCntOfDescOutComplete = 0;
	is_fastboot = 0;
	// . to initialize usb device controller
	//------------------------------
	if (exynos_usb_init_core(eSpeed))
	{
		DBG_USBD3("Exynos USB3 Core Init Fail\n");
		return 0;
	}

	return 0;
}
#endif
