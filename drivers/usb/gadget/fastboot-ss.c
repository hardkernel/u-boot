/*
 * Copyright (c) 2010 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * Platform dependant code for Fastboot
 *
 * Base code of USB connection part is usbd-ss.c
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <fastboot.h>

#if defined(CONFIG_FASTBOOT)

#define FBOOT_USBD_IS_CONNECTED() (1)
#define FBOOT_USBD_DETECT_IRQ() EXYNOS_USBD_DETECT_IRQ()
#define FBOOT_USBD_CLEAR_IRQ()  EXYNOS_USBD_CLEAR_IRQ()
#define VENDOR_ID 	0x18D1
#define PRODUCT_ID	0x0002
#define FB_PKT_SZ	64 // full-speed mode
#define OK	0
#define ERROR	-1

/* In high speed mode packets are 512
   In full speed mode packets are 64 */
#define RX_ENDPOINT_MAXIMUM_PACKET_SIZE_2_0  (0x0200)//512
#define RX_ENDPOINT_MAXIMUM_PACKET_SIZE_1_1  (0x0040)// 64
#define TX_ENDPOINT_MAXIMUM_PACKET_SIZE_2_0  (0x0200)
#define TX_ENDPOINT_MAXIMUM_PACKET_SIZE_1_1  (0x0040)

/* String 0 is the language id */
#define DEVICE_STRING_MANUFACTURER_INDEX  1
#define DEVICE_STRING_PRODUCT_INDEX       2
#define DEVICE_STRING_SERIAL_NUMBER_INDEX 3
#define DEVICE_STRING_CONFIG_INDEX        4
#define DEVICE_STRING_INTERFACE_INDEX     5
#define DEVICE_STRING_MAX_INDEX           DEVICE_STRING_INTERFACE_INDEX
#define DEVICE_STRING_LANGUAGE_ID         0x0409 /* English (United States) */

//static char *device_strings[DEVICE_STRING_MANUFACTURER_INDEX+1];
static char *device_strings[DEVICE_STRING_MAX_INDEX+1];
static struct cmd_fastboot_interface *fastboot_interface = NULL;
/* The packet size is dependend of the speed mode
   In high speed mode packets are 512
   In full speed mode packets are 64
   Set to maximum of 512 */

/* Note: The start address must be double word aligned */
char* reply_msg;
unsigned int transfer_size;
u32 fboot_response_flag=0;

/* codes representing languages */
const u8 fboot_string_desc1[] = /* Manufacturer */
{
	(0x16+2), STRING_DESCRIPTOR,
	'G', 0x0, 'o', 0x0, 'o', 0x0, 'g', 0x0, 'l', 0x0,
	'e', 0x0, ',', 0x0, ' ', 0x0, 'I', 0x0, 'n', 0x0,
	'c', 0x0
};

const u8 fboot_string_desc2[] = /* Product */
{
	(0x16+2), STRING_DESCRIPTOR,
	'A', 0x0, 'n', 0x0, 'd', 0x0, 'r', 0x0, 'o', 0x0,
	'i', 0x0, 'd', 0x0, ' ', 0x0, '1', 0x0, '.', 0x0,
	'0', 0x0
};

const u8 fboot_string_desc3[] = /* Test Serial ID */
{
	(0x16+2), STRING_DESCRIPTOR,
	'S', 0x0, 'M', 0x0, 'D', 0x0, 'K', 0x0,
	'E', 0x0,'X', 0x0, 'Y', 0x0, 'N', 0x0, 'O', 0x0, 'S', 0x0, '-', 0x0, '0', 0x0, '1', 0x0
};

/* setting the device qualifier descriptor and a string descriptor */
const u8 fboot_qualifier_desc[] =
{
	0x0a,	/*  0 desc size */
	0x06,	/*  1 desc type (DEVICE_QUALIFIER)*/
	0x00,	/*  2 USB release */
	0x02,	/*  3 => 2.00*/
	0xFF,	/*  4 class */
	0x42,	/*  5 subclass */
	0x03,	/*  6 protocol */
	64,	/*  7 max pack size */
	0x01,	/*  8 number of other-speed configuration */
	0x00,	/*  9 reserved */
};

volatile usbdev3_trb_ptr_t g_pBulkInTrb;

/* extern function from usbd3-ss.c */
void exynos_usb_phy_on(void);
int exynos_usb_wait_cable_insert(void);

void fboot_usbctl_init(void)
{
	exynos_usb_phy_on();
}

int fboot_usb_int_bulkin(const char *buffer, unsigned int buffer_size)
{
	usbdev3_trb_ctrl_t usbdev3_trb_ctrl;
	usbdev3_trb_ptr_t pBulkInTrb;
	u32 usCapTrbBufSiz, uLastBufSize;
	u32 i;

	// Set TRB for multiple Bulk IN Packet
	usCapTrbBufSiz = TRB_BUF_SIZ_LIMIT/oUsbDev3.m_uBulkEPMaxPktSize*oUsbDev3.m_uBulkEPMaxPktSize;
	g_uCntOfBulkInTrb = buffer_size/usCapTrbBufSiz;

	if ((buffer_size%usCapTrbBufSiz) != 0)
		g_uCntOfBulkInTrb++;

	g_pBulkInTrb = (usbdev3_trb_ptr_t)exynos_usb_malloc(g_uCntOfBulkInTrb*sizeof(usbdev3_trb_t), USBDEV3_MDWIDTH/8);

	if (g_pBulkInTrb == NULL)
		Assert(0);

	pBulkInTrb = g_pBulkInTrb;
	// Fill the Trbs
	usbdev3_trb_ctrl.data = 0;
	usbdev3_trb_ctrl.b.lst = 0;
	usbdev3_trb_ctrl.b.chn = 1;
	usbdev3_trb_ctrl.b.csp = 0;
	usbdev3_trb_ctrl.b.trb_ctrl = (u32)TRB_CTRL_NORMAL;
	usbdev3_trb_ctrl.b.isp_imi = 1;
	usbdev3_trb_ctrl.b.ioc = 0;
	usbdev3_trb_ctrl.b.strmid_sofn = 0;

	for(i=0;i<(g_uCntOfBulkInTrb-1);i++, pBulkInTrb++)
		exynos_usb_fill_trb(pBulkInTrb, (u32)(buffer+usCapTrbBufSiz*i), usCapTrbBufSiz, usbdev3_trb_ctrl.data, 1);

	usbdev3_trb_ctrl.b.lst = 1;
	usbdev3_trb_ctrl.b.chn = 0;
	usbdev3_trb_ctrl.b.ioc = 1;
	uLastBufSize = buffer_size-usCapTrbBufSiz*i;
	exynos_usb_fill_trb(pBulkInTrb, (u32)(buffer+usCapTrbBufSiz*i), uLastBufSize, usbdev3_trb_ctrl.data, 1);

	// . Issue Start Xfer for multiple Bulk IN Packet
	//------------------------------------
	if (!exynos_usb_start_ep_xfer(USBDEV3_EP_DIR_IN, BULK_IN_EP, (u32)g_pBulkInTrb, 0, &oUsbDev3.m_uTriIn[BULK_IN_EP]))
	{
		return 0;
	}

	return 1;
}

void fboot_usb_handle_ep_in_xfer_complete(void)
{
	if (fboot_response_flag) {
		exynos_usb_free((u32)g_pBulkInTrb);
		fboot_response_flag=0;
	}

	return;
}

int fboot_usb_handle_ep_out_xfer_complete(void)
{
	u32 usRxCnt;
	usbdev3_trb_ctrl_t usbdev3_trb_ctrl;

	// Check whether TRB was finished successfully or not
	if ((g_pBulkOutTrb0->control.b.hwo != 0)||(g_pBulkOutTrb0->status.b.trb_sts != 0))
	{
		Assert(0);
	}

	usRxCnt = oUsbDev3.m_uBulkEPMaxPktSize - g_pBulkOutTrb0->status.b.buf_siz;

	if (usRxCnt < oUsbDev3.m_uBulkEPMaxPktSize)
		g_ucTempDownBuf[usRxCnt] = 0;

	/* Pass this up to the interface's handler */
	if (fastboot_interface && fastboot_interface->rx_handler) {
		/* Call rx_handler at common/cmd_fastboot.c */
		if (!fastboot_interface->rx_handler(g_ucTempDownBuf, usRxCnt))
			;//OK
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

void fboot_usb_set_descriptors_tlb(void)
{
	/* Standard device descriptor */
	oUsbDev3.m_oDesc.oDescDevice.bLength=DEVICE_DESC_SIZE;	/*0x12*/
	oUsbDev3.m_oDesc.oDescDevice.bDescriptorType=DEVICE_DESCRIPTOR;
	if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER) {
		oUsbDev3.m_oDesc.oDescDevice.bMaxPacketSize0=SUPER_SPEED_CONTROL_PKT_EXP_SZ;
	} else {
		oUsbDev3.m_oDesc.oDescDevice.bMaxPacketSize0=oUsbDev3.m_uControlEPMaxPktSize;
	}
	oUsbDev3.m_oDesc.oDescDevice.bDeviceClass=0x0; /* 0x0*/
	oUsbDev3.m_oDesc.oDescDevice.bDeviceSubClass=0x0;
	oUsbDev3.m_oDesc.oDescDevice.bDeviceProtocol=0x0;
	oUsbDev3.m_oDesc.oDescDevice.idVendorL=VENDOR_ID&0xff;//0xB4;	/**/
	oUsbDev3.m_oDesc.oDescDevice.idVendorH=VENDOR_ID>>8;//0x0B;	/**/
	oUsbDev3.m_oDesc.oDescDevice.idProductL=PRODUCT_ID&0xff;//0xFF; /**/
	oUsbDev3.m_oDesc.oDescDevice.idProductH=PRODUCT_ID>>8;//0x0F; /**/
	oUsbDev3.m_oDesc.oDescDevice.bcdDeviceL=0x00;
	oUsbDev3.m_oDesc.oDescDevice.bcdDeviceH=0x01;
	oUsbDev3.m_oDesc.oDescDevice.iManufacturer=DEVICE_STRING_MANUFACTURER_INDEX; /* index of string descriptor */
	oUsbDev3.m_oDesc.oDescDevice.iProduct=DEVICE_STRING_PRODUCT_INDEX;	/* index of string descriptor */
	oUsbDev3.m_oDesc.oDescDevice.iSerialNumber=DEVICE_STRING_SERIAL_NUMBER_INDEX;
	oUsbDev3.m_oDesc.oDescDevice.bNumConfigurations=0x1;
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

	/* Standard configuration descriptor */
	oUsbDev3.m_oDesc.oDescConfig.bLength=CONFIG_DESC_SIZE; /* 0x9 bytes */
	oUsbDev3.m_oDesc.oDescConfig.bDescriptorType=CONFIGURATION_DESCRIPTOR;
	if (oUsbDev3.m_eSpeed == USBDEV3_SPEED_SUPER)
		oUsbDev3.m_oDesc.oDescConfig.wTotalLengthL=CONFIG_SS_DESC_TOTAL_SIZE;
	else
		oUsbDev3.m_oDesc.oDescConfig.wTotalLengthL=CONFIG_DESC_TOTAL_SIZE;
	oUsbDev3.m_oDesc.oDescConfig.wTotalLengthH=0;
	oUsbDev3.m_oDesc.oDescConfig.bNumInterfaces=1;
	/* dbg	  descConf.bConfigurationValue=2; // why 2? There's no reason.*/
	oUsbDev3.m_oDesc.oDescConfig.bConfigurationValue=1;
	oUsbDev3.m_oDesc.oDescConfig.iConfiguration=0;
	oUsbDev3.m_oDesc.oDescConfig.bmAttributes=CONF_ATTR_DEFAULT|CONF_ATTR_SELFPOWERED; /* bus powered only.*/
	oUsbDev3.m_oDesc.oDescConfig.maxPower=25; /* draws 50mA current from the USB bus.*/

	/* Standard interface descriptor */
	oUsbDev3.m_oDesc.oDescInterface.bLength=INTERFACE_DESC_SIZE; /* 9*/
	oUsbDev3.m_oDesc.oDescInterface.bDescriptorType=INTERFACE_DESCRIPTOR;
	oUsbDev3.m_oDesc.oDescInterface.bInterfaceNumber=0x0;
	oUsbDev3.m_oDesc.oDescInterface.bAlternateSetting=0x0; /* ?*/
	oUsbDev3.m_oDesc.oDescInterface.bNumEndpoints = 2;	/* # of endpoints except EP0*/
	oUsbDev3.m_oDesc.oDescInterface.bInterfaceClass=	FASTBOOT_INTERFACE_CLASS;// 0xff; /* 0x0 ?*/
	oUsbDev3.m_oDesc.oDescInterface.bInterfaceSubClass=	FASTBOOT_INTERFACE_SUB_CLASS;// 0x42;
	oUsbDev3.m_oDesc.oDescInterface.bInterfaceProtocol=	FASTBOOT_INTERFACE_PROTOCOL;//0x03;
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

int  fboot_usb_int_hndlr(void)
{
	return exynos_udc_int_hndlr();
}

//-----------------------------------------------------------------------------------
// FASTBOOT codes
//-----------------------------------------------------------------------------------

static void set_serial_number(void)
{
	char *dieid = getenv("dieid#");
	if (dieid == NULL) {
		device_strings[DEVICE_STRING_SERIAL_NUMBER_INDEX] = "SLSI0123";
	} else {
		static char serial_number[32];
		int len;

		memset(&serial_number[0], 0, 32);
		len = strlen(dieid);
		if (len > 30)
			len = 30;

		strncpy(&serial_number[0], dieid, len);

		device_strings[DEVICE_STRING_SERIAL_NUMBER_INDEX] =
			&serial_number[0];
	}
}

/* Initizes the board specific fastboot
   Returns 0 on success
   Returns 1 on failure */
int fastboot_init(struct cmd_fastboot_interface *interface)
{
	int ret = 1;

	// usbd init
	fboot_usbctl_init();

	device_strings[DEVICE_STRING_MANUFACTURER_INDEX]  = "Samsung S.LSI";
	device_strings[DEVICE_STRING_PRODUCT_INDEX]       = "smdk";
	set_serial_number();
	/* These are just made up */
	device_strings[DEVICE_STRING_CONFIG_INDEX]        = "Android Fastboot";
	device_strings[DEVICE_STRING_INTERFACE_INDEX]     = "Android Fastboot";

	/* The interface structure */
	fastboot_interface = interface;
	fastboot_interface->product_name                  = device_strings[DEVICE_STRING_PRODUCT_INDEX];
	fastboot_interface->serial_no                     = device_strings[DEVICE_STRING_SERIAL_NUMBER_INDEX];
	fastboot_interface->nand_block_size               = CFG_FASTBOOT_PAGESIZE * 64;
	fastboot_interface->transfer_buffer               = (unsigned char *) CFG_FASTBOOT_TRANSFER_BUFFER;
	fastboot_interface->transfer_buffer_size          = CFG_FASTBOOT_TRANSFER_BUFFER_SIZE;

	memset((unsigned char *) CFG_FASTBOOT_TRANSFER_BUFFER, 0x0, FASTBOOT_REBOOT_MAGIC_SIZE);

	reply_msg = (char *)exynos_usb_malloc(512, USBDEV3_MDWIDTH/8);

	ret = 0;	// This is a fake return value, because we do not initialize USB yet!

	return ret;
}

/* Cleans up the board specific fastboot */
void fastboot_shutdown(void)
{
	/* when operation is done, usbd must be stopped */
	exynos_usb_stop();
	is_fastboot = 0;
}

int fastboot_fifo_size(void)
{
	return (oUsbDev3.m_eSpeed == USBDEV3_SPEED_HIGH) ? RX_ENDPOINT_MAXIMUM_PACKET_SIZE_2_0 : RX_ENDPOINT_MAXIMUM_PACKET_SIZE_1_1;
}

/*
 * Handles board specific usb protocol exchanges
 * Returns 0 on success
 * Returns 1 on disconnects, break out of loop
 * Returns 2 if no USB activity detected
 * Returns -1 on failure, unhandled usb requests and other error conditions
*/
int fastboot_poll(void)
{
	//printf("DEBUG: %s is called.\n", __FUNCTION__);
	/* No activity */
	int ret = FASTBOOT_INACTIVE;

	if (!exynos_usb_wait_cable_insert() && !is_fastboot) {
		exynos_usbctl_init();
		exynos_usbc_activate();
		is_fastboot = 1;
	}

	/* A disconnect happended, this signals that the cable
	   has been disconnected, return immediately */
	if (!FBOOT_USBD_IS_CONNECTED()) {
		return FASTBOOT_DISCONNECT;
	} else if (FBOOT_USBD_DETECT_IRQ()) {
		if (!fboot_usb_int_hndlr())
			ret = FASTBOOT_OK;
		else
			ret = FASTBOOT_ERROR;
		FBOOT_USBD_CLEAR_IRQ();
	}

	return ret;
}


/* Send a status reply to the client app
   buffer does not have to be null terminated.
   buffer_size must be not be larger than what is returned by
   fastboot_fifo_size
   Returns 0 on success
   Returns 1 on failure */
int fastboot_tx_status(const char *buffer, unsigned int buffer_size, const u32 need_sync_flag)
{
	/* fastboot client only reads back at most 64 */
	transfer_size = 64 < buffer_size ? 64 : buffer_size;

	if (fboot_response_flag)
		printf(" Response tx Warnning\n");

	memcpy(reply_msg, buffer, transfer_size);
	fboot_response_flag=1;
	fboot_usb_int_bulkin(reply_msg, transfer_size);

	if (need_sync_flag)
	{
		while(fboot_response_flag)
			fastboot_poll();
	}
	return 1;
}

/* Returns 0 on success
   Returns 1 on failure */
int fastboot_tx_mem(const char *buffer, unsigned int buffer_size)
{
	if (!fboot_usb_int_bulkin(buffer, buffer_size))
		return 0;
	return 1;
}

/* A board specific variable handler.
   The size of the buffers is governed by the fastboot spec.
   rx_buffer is at most 57 bytes
   tx_buffer is at most 60 bytes
   Returns 0 on success
   Returns 1 on failure */
int fastboot_getvar(const char *rx_buffer, char *tx_buffer)
{
	/* Place board specific variables here */
	return 1;
}

#endif /* CONFIG_FASTBOOT */
