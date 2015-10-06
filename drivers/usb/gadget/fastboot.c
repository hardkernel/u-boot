/*
 * Copyright (c) 2010 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * Platform dependant code for Fastboot
 *
 * Base code of USB connection part is usbd-otg-hs.c
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <fastboot.h>

#if defined(CONFIG_FASTBOOT)

/* S5PC110 Default Partition Table */
fastboot_ptentry ptable_default[] =
{
	{
		.name     = "bootloader",
		.start    = 0x0,
		.length   = 0x100000,
		.flags    = 0
	},
	{
		.name     = "recovery",
		.start    = 0x100000,
		.length   = 0x500000,
		.flags    = 0
	},
	{
		.name     = "kernel",
		.start    = 0x600000,
		.length   = 0x500000,
		.flags    = 0
	},
	{
		.name     = "ramdisk",
		.start    = 0xB00000,
		.length   = 0x300000,
		.flags    = 0
	},
	{
		.name     = "system",
		.start    = 0xE00000,
		.length   = 0x6E00000,
		.flags    = FASTBOOT_PTENTRY_FLAGS_WRITE_YAFFS
	},
	{
		.name     = "cache",
		.start    = 0x7C00000,
		.length   = 0x5000000,
		.flags    = FASTBOOT_PTENTRY_FLAGS_WRITE_YAFFS
	},
	{
		.name     = "userdata",
		.start    = 0xCC00000,
		.length   = 0,
		.flags    = FASTBOOT_PTENTRY_FLAGS_WRITE_YAFFS
	}
};
unsigned int ptable_default_size = sizeof(ptable_default);

#define FBOOT_USBD_IS_CONNECTED() (readl(S5P_OTG_GOTGCTL)&(B_SESSION_VALID|A_SESSION_VALID))
#define FBOOT_USBD_DETECT_IRQ_CPUMODE() (readl(S5P_OTG_GINTSTS) & \
					(GINTSTS_WkUpInt|GINTSTS_OEPInt|GINTSTS_IEPInt| \
					 GINTSTS_EnumDone|GINTSTS_USBRst|GINTSTS_USBSusp|GINTSTS_RXFLvl))
#define FBOOT_USBD_DETECT_IRQ_DMAMODE() (readl(S5P_OTG_GINTSTS) & \
					(GINTSTS_WkUpInt|GINTSTS_OEPInt|GINTSTS_IEPInt| \
					 GINTSTS_EnumDone|GINTSTS_USBRst|GINTSTS_USBSusp))
#define FBOOT_USBD_CLEAR_IRQ()  do { \
					writel(BIT_ALLMSK, (S5P_OTG_GINTSTS)); \
				} while (0)

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

static char *device_strings[DEVICE_STRING_MAX_INDEX+1];
static struct cmd_fastboot_interface *fastboot_interface = NULL;
/* The packet size is dependend of the speed mode
   In high speed mode packets are 512
   In full speed mode packets are 64
   Set to maximum of 512 */

/* Note: The start address must be double word aligned */
static u8 fastboot_bulk_fifo[0x0200+1]; //__attribute__ ((aligned(0x4))); 
const char* reply_msg;
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
#if defined(CONFIG_S5PC220) || defined(CONFIG_ARCH_EXYNOS)
	'E', 0x0,'X', 0x0, 'Y', 0x0, 'N', 0x0, 'O', 0x0, 'S', 0x0, '-', 0x0, '0', 0x0, '1', 0x0
#elif defined(CONFIG_S5PC210)
	'C', 0x0,'2', 0x0, '1', 0x0, '0', 0x0, '-', 0x0, '0', 0x0, '1', 0x0
#elif defined(CONFIG_S5PV310)
	'V', 0x0,'3', 0x0, '1', 0x0, '0', 0x0, '-', 0x0, '0', 0x0, '1', 0x0
#elif defined(CONFIG_S5PC110)
	'C', 0x0,'1', 0x0, '1', 0x0, '0', 0x0, '-', 0x0, '0', 0x0, '1', 0x0
#elif defined(CONFIG_S5P6450)
	'6', 0x0,'4', 0x0, '5', 0x0, '0', 0x0, '-', 0x0, '0', 0x0, '1', 0x0
#else
#error "* CFG_ERROR : you have to select proper CPU for Android Fastboot"
#endif
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

int fboot_usbctl_init(void)
{
	s3c_usbctl_init();
	is_fastboot = 1;
	return 0;
}

void fboot_usb_int_bulkin(void)
{
	u32 tmp;

	DBG_BULK0("~~~~~~~~~~~~~~~~ bulkin Function ~~~~~~~~~~~~\n");

	if ((fboot_response_flag==1)&&(reply_msg)) {

#ifdef CONFIG_USB_CPUMODE
		s3c_usb_set_inep_xfersize(EP_TYPE_BULK, 1, strlen(reply_msg));

		/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
		writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkin_max_pktsize<<0, S5P_OTG_DIEPCTL_IN);

		s3c_usb_write_in_fifo((u8 *)reply_msg,strlen(reply_msg)); 
#else
		s3c_usb_bulk_inep_setdma((u8 *)reply_msg, strlen(reply_msg));
#endif

		fboot_response_flag=0;
	}
	else if (fboot_response_flag==0)
	{
		/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
		//writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkin_max_pktsize<<0, S5P_OTG_DIEPCTL_IN);
		//writel((DEPCTL_SNAK|DEPCTL_BULK_TYPE), S5P_OTG_DIEPCTL_IN);
		// NAK should be cleared. why??
		tmp = readl(S5P_OTG_DOEPCTL0+0x20*BULK_OUT_EP);
		tmp |= (DEPCTL_CNAK);
		writel(tmp, S5P_OTG_DOEPCTL0+0x20*BULK_OUT_EP);
	}
	//DBG_BULK1("fboot_response_flag=%d S5P_OTG_DIEPCTL_IN=0x%x\n",fboot_response_flag,DIEPCTL_IN);

	return;
}

#ifdef CONFIG_USB_CPUMODE
void fboot_usb_int_bulkout(u32 fifo_cnt_byte)
#else
void fboot_usb_int_bulkout( void )
#endif
{
	DBG_BULK0("@@\n Bulk Out Function : otg.dn_filesize=0x%x\n", otg.dn_filesize);

#ifdef CONFIG_USB_CPUMODE
	s3c_usb_read_out_fifo((u8 *)fastboot_bulk_fifo, fifo_cnt_byte);
	if (fifo_cnt_byte<64) {
		fastboot_bulk_fifo[fifo_cnt_byte] = 0x00; // append null
		printf("Received %d bytes: %s\n",fifo_cnt_byte, fastboot_bulk_fifo);
	}

	/*ep3 enable, clear nak, bulk, usb active, next ep3, max pkt 64*/
	writel(1u<<31|1<<26|2<<18|1<<15|otg.bulkout_max_pktsize<<0,
			S5P_OTG_DOEPCTL_OUT);
#else
	u32 xfer_size, cnt_byte;
	xfer_size = readl(S5P_OTG_DOEPTSIZ_OUT) & 0x7FFF;
	cnt_byte = HS_BULK_PKT_SIZE - xfer_size;
	if(cnt_byte < HS_BULK_PKT_SIZE)
		tmp_buf[cnt_byte] = 0x00;
#endif

	/* Pass this up to the interface's handler */
	if (fastboot_interface && fastboot_interface->rx_handler) {
		/* Call rx_handler at common/cmd_fastboot.c */
#ifdef CONFIG_USB_CPUMODE
		if (!fastboot_interface->rx_handler(&fastboot_bulk_fifo[0], fifo_cnt_byte));//OK 
	}
#else
		if (!fastboot_interface->rx_handler(&tmp_buf, cnt_byte));
	}
	s3c_usb_bulk_outep_setdma(tmp_buf, HS_BULK_PKT_SIZE);
#endif
}

void fboot_usb_set_descriptors(void)
{
	/* Standard device descriptor */
	otg.desc.dev.bLength=DEVICE_DESC_SIZE;	/*0x12*/
	otg.desc.dev.bDescriptorType=DEVICE_DESCRIPTOR;
	otg.desc.dev.bMaxPacketSize0=otg.ctrl_max_pktsize;
	otg.desc.dev.bDeviceClass=0x0; /* 0x0*/
	otg.desc.dev.bDeviceSubClass=0x0;
	otg.desc.dev.bDeviceProtocol=0x0;
	otg.desc.dev.idVendorL=VENDOR_ID&0xff;//0xB4;	/**/
	otg.desc.dev.idVendorH=VENDOR_ID>>8;//0x0B;	/**/
	otg.desc.dev.idProductL=PRODUCT_ID&0xff;//0xFF; /**/
	otg.desc.dev.idProductH=PRODUCT_ID>>8;//0x0F; /**/
	otg.desc.dev.bcdDeviceL=0x00;
	otg.desc.dev.bcdDeviceH=0x01;
	otg.desc.dev.iManufacturer=DEVICE_STRING_MANUFACTURER_INDEX; /* index of string descriptor */
	otg.desc.dev.iProduct=DEVICE_STRING_PRODUCT_INDEX;	/* index of string descriptor */
	otg.desc.dev.iSerialNumber=DEVICE_STRING_SERIAL_NUMBER_INDEX;
	otg.desc.dev.bNumConfigurations=0x1;
	if (otg.speed == USB_FULL) {
		otg.desc.dev.bcdUSBL=0x10;
		otg.desc.dev.bcdUSBH=0x01;	/* Ver 1.10*/
	}
	else {
		otg.desc.dev.bcdUSBL=0x00;
		//otg.desc.dev.bcdUSBL=0x10;
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
	otg.desc.intf.bInterfaceClass=	FASTBOOT_INTERFACE_CLASS;// 0xff; /* 0x0 ?*/
	otg.desc.intf.bInterfaceSubClass=	FASTBOOT_INTERFACE_SUB_CLASS;// 0x42;
	otg.desc.intf.bInterfaceProtocol=	FASTBOOT_INTERFACE_PROTOCOL;//0x03;
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

int  fboot_usb_int_hndlr(void)
{
	return s3c_udc_int_hndlr();
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

	ret = 0;	// This is a fake return value, because we do not initialize USB yet!

	return ret;
}

/* Cleans up the board specific fastboot */
void fastboot_shutdown(void)
{
	/* when operation is done, usbd must be stopped */
	s3c_usb_stop();
}
int fastboot_fifo_size(void)
{
	return (otg.speed== USB_HIGH) ? RX_ENDPOINT_MAXIMUM_PACKET_SIZE_2_0 : RX_ENDPOINT_MAXIMUM_PACKET_SIZE_1_1;
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

	u32 intrusb;

	/* Look at the interrupt registers */
	intrusb =  readl(S5P_OTG_GINTSTS);

	/* A disconnect happended, this signals that the cable
	   has been disconnected, return immediately */
	if (!FBOOT_USBD_IS_CONNECTED())
		return FASTBOOT_DISCONNECT;

#ifdef CONFIG_USB_CPUMODE
	else if (FBOOT_USBD_DETECT_IRQ_CPUMODE()) {
#else
	else if (FBOOT_USBD_DETECT_IRQ_DMAMODE()) {

#endif
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
	transfer_size = MIN(64, buffer_size);

//------------------------------ kdj
	//printf("    Response - \"%s\" (%d bytes)\n", buffer, buffer_size);
	reply_msg = buffer;
	fboot_response_flag=1;
#ifndef CONFIG_USB_CPUMODE
	fboot_usb_int_bulkin();
#endif
	if (need_sync_flag)
	{
		while(fboot_response_flag)
			fastboot_poll();
	}
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

