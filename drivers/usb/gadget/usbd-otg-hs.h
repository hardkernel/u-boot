/*
 * cpu/s5pc1xx/usbd-otg-hs.h
 *
 * (C) Copyright 2009
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

#ifndef __S3C_OTG_HS_H__
#define __S3C_OTG_HS_H__

#include <asm/byteorder.h>
#include <asm/arch/cpu.h>
#include <asm/io.h>

#define S3C_USBD_DETECT_IRQ()	(readl(S5P_OTG_GINTSTS) & \
					(GINTSTS_WkUpInt|GINTSTS_OEPInt|GINTSTS_IEPInt| \
					 GINTSTS_EnumDone|GINTSTS_USBRst|GINTSTS_USBSusp|GINTSTS_RXFLvl))
#define S3C_USBD_CLEAR_IRQ()	do { \
					writel(BIT_ALLMSK, (S5P_OTG_GINTSTS)); \
				} while (0)

#define CONTROL_EP		0
#define BULK_IN_EP		1
#define BULK_OUT_EP		2

#define FS_CTRL_PKT_SIZE	64
#define FS_BULK_PKT_SIZE	64

#define HS_CTRL_PKT_SIZE	64
#define HS_BULK_PKT_SIZE	512

#define RX_FIFO_SIZE		512
#define NPTX_FIFO_START_ADDR	RX_FIFO_SIZE
#define NPTX_FIFO_SIZE		512
#define PTX_FIFO_SIZE		512

// string descriptor
#define LANGID_US_L		(0x09)
#define LANGID_US_H		(0x04)

// Feature Selectors
#define EP_STALL		0
#define DEVICE_REMOTE_WAKEUP	1
#define TEST_MODE		2

/* Test Mode Selector*/
#define TEST_J			1
#define TEST_K			2
#define TEST_SE0_NAK		3
#define TEST_PACKET		4
#define TEST_FORCE_ENABLE	5

#define S5P_OTG_DIEPCTL_IN	(S5P_OTG_DIEPCTL0 + 0x20*BULK_IN_EP)
#define S5P_OTG_DIEPINT_IN	(S5P_OTG_DIEPINT0 + 0x20*BULK_IN_EP)
#define S5P_OTG_DIEPTSIZ_IN	(S5P_OTG_DIEPTSIZ0 + 0x20*BULK_IN_EP)
#define S5P_OTG_DIEPDMA_IN	(S5P_OTG_DIEPDMA0 + 0x20*BULK_IN_EP)
#define S5P_OTG_DOEPCTL_OUT	(S5P_OTG_DOEPCTL0 + 0x20*BULK_OUT_EP)
#define S5P_OTG_DOEPINT_OUT	(S5P_OTG_DOEPINT0 + 0x20*BULK_OUT_EP)
#define S5P_OTG_DOEPTSIZ_OUT	(S5P_OTG_DOEPTSIZ0 + 0x20*BULK_OUT_EP)
#define S5P_OTG_DOEPDMA_OUT	(S5P_OTG_DOEPDMA0 + 0x20*BULK_OUT_EP)
#define S5P_OTG_IN_FIFO		(S5P_OTG_EP0_FIFO + 0x1000*BULK_IN_EP)
#define S5P_OTG_OUT_FIFO	(S5P_OTG_EP0_FIFO + 0x1000*BULK_OUT_EP)


typedef struct
{
	u8 bLength;
	u8 bDescriptorType;
	u8 bcdUSBL;
	u8 bcdUSBH;
	u8 bDeviceClass;
	u8 bDeviceSubClass;
	u8 bDeviceProtocol;
	u8 bMaxPacketSize0;
	u8 idVendorL;
	u8 idVendorH;
	u8 idProductL;
	u8 idProductH;
	u8 bcdDeviceL;
	u8 bcdDeviceH;
	u8 iManufacturer;
	u8 iProduct;
	u8 iSerialNumber;
	u8 bNumConfigurations;
} __attribute__ ((packed)) device_desc_t;

typedef struct
{
	u8 bLength;
	u8 bDescriptorType;
	u8 wTotalLengthL;
	u8 wTotalLengthH;
	u8 bNumInterfaces;
	u8 bConfigurationValue;
	u8 iConfiguration;
	u8 bmAttributes;
	u8 maxPower;
} __attribute__ ((packed)) config_desc_t;

typedef struct
{
	u8 bLength;
	u8 bDescriptorType;
	u8 bInterfaceNumber;
	u8 bAlternateSetting;
	u8 bNumEndpoints;
	u8 bInterfaceClass;
	u8 bInterfaceSubClass;
	u8 bInterfaceProtocol;
	u8 iInterface;
} __attribute__ ((packed)) intf_desc_t;

typedef struct
{
	u8 bLength;
	u8 bDescriptorType;
	u8 bEndpointAddress;
	u8 bmAttributes;
	u8 wMaxPacketSizeL;
	u8 wMaxPacketSizeH;
	u8 bInterval;
} __attribute__ ((packed)) ep_desc_t;

typedef struct
{
	u8 bmRequestType;
	u8 bRequest;
	u8 wValue_L;
	u8 wValue_H;
	u8 wIndex_L;
	u8 wIndex_H;
	u8 wLength_L;
	u8 wLength_H;
} __attribute__ ((packed)) device_req_t;

typedef struct
{
	device_desc_t dev;
	config_desc_t config;
	intf_desc_t intf;
	ep_desc_t ep1;
	ep_desc_t ep2;
	ep_desc_t ep3;
	ep_desc_t ep4;
} __attribute__ ((packed)) descriptors_t;

typedef struct
{
	u8 Device;
	u8 Interface;
	u8 ep_ctrl;
	u8 ep_in;
	u8 ep_out;
} __attribute__ ((packed)) get_status_t;

typedef struct
{
	u8 AlternateSetting;
} __attribute__ ((packed)) get_intf_t;


typedef enum
{
	USB_CPU, USB_DMA
} USB_OPMODE;

typedef enum
{
	USB_HIGH, USB_FULL, USB_LOW
} USB_SPEED;

typedef enum
{
	EP_TYPE_CONTROL, EP_TYPE_ISOCHRONOUS, EP_TYPE_BULK, EP_TYPE_INTERRUPT
} EP_TYPE;


typedef struct
{
	descriptors_t desc;
	device_req_t dev_req;

	u32  ep0_state;
	u32  ep0_substate;
	USB_OPMODE op_mode;
	USB_SPEED speed;
	u32  ctrl_max_pktsize;
	u32  bulkin_max_pktsize;
	u32  bulkout_max_pktsize;
	u32  dn_addr;
	u32  dn_filesize;
	u32  up_addr;
	u32  up_size;
	u8*  dn_ptr;
	u8*  up_ptr;
	u32  set_config;
	u32  req_length;
} __attribute__ ((packed)) otg_dev_t;

// SPEC1.1

// Standard bmRequestType (direction)
enum DEV_REQUEST_DIRECTION
{
	HOST_TO_DEVICE				= 0x00,
	DEVICE_TO_HOST				= 0x80
};

// Standard bmRequestType (Type)
enum DEV_REQUEST_TYPE
{
	STANDARD_TYPE			= 0x00,
	CLASS_TYPE			= 0x20,
	VENDOR_TYPE			= 0x40,
	RESERVED_TYPE			= 0x60
};

// Standard bmRequestType (Recipient)
enum DEV_REQUEST_RECIPIENT
{
	DEVICE_RECIPIENT		= 0,
	INTERFACE_RECIPIENT		= 1,
	ENDPOINT_RECIPIENT		= 2,
	OTHER_RECIPIENT			= 3
};

// Descriptor types
enum DESCRIPTOR_TYPE
{
	DEVICE_DESCRIPTOR		= 1,
	CONFIGURATION_DESCRIPTOR	= 2,
	STRING_DESCRIPTOR		= 3,
	INTERFACE_DESCRIPTOR		= 4,
	ENDPOINT_DESCRIPTOR		= 5,
	DEVICE_QUALIFIER		= 6,
	OTHER_SPEED_CONFIGURATION	= 7,
	INTERFACE_POWER			= 8,
};

// configuration descriptor: bmAttributes
enum CONFIG_ATTRIBUTES
{
	CONF_ATTR_DEFAULT		= 0x80,
	CONF_ATTR_REMOTE_WAKEUP 	= 0x20,
	CONF_ATTR_SELFPOWERED		= 0x40
};

// endpoint descriptor
enum ENDPOINT_ATTRIBUTES
{
	EP_ADDR_IN			= 0x80,
	EP_ADDR_OUT			= 0x00,

	EP_ATTR_CONTROL			= 0x0,
	EP_ATTR_ISOCHRONOUS		= 0x1,
	EP_ATTR_BULK			= 0x2,
	EP_ATTR_INTERRUPT		= 0x3
};

// Standard bRequest codes
enum STANDARD_REQUEST_CODE
{
	STANDARD_GET_STATUS		= 0,
	STANDARD_CLEAR_FEATURE		= 1,
	STANDARD_RESERVED_1		= 2,
	STANDARD_SET_FEATURE		= 3,
	STANDARD_RESERVED_2		= 4,
	STANDARD_SET_ADDRESS		= 5,
	STANDARD_GET_DESCRIPTOR		= 6,
	STANDARD_SET_DESCRIPTOR		= 7,
	STANDARD_GET_CONFIGURATION	= 8,
	STANDARD_SET_CONFIGURATION	= 9,
	STANDARD_GET_INTERFACE		= 10,
	STANDARD_SET_INTERFACE		= 11,
	STANDARD_SYNCH_FRAME		= 12
};

int s3c_usbctl_init(void);
int s3c_usbc_activate (void);
int s3c_usb_stop( void );
int s3c_udc_int_hndlr(void);

/* in usbd-otg-hs.c */
extern unsigned int s3c_usbd_dn_addr;
extern unsigned int s3c_usbd_dn_cnt;
extern int DNW;
extern int s3c_got_header;
extern int s3c_receive_done;

#endif
