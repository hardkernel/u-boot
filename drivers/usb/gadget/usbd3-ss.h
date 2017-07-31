/*
 * drivers/usb/gadget/usbd3-ss.h
 *
 * (C) Copyright 2011
 * Yulgon Kim, Samsung Erectronics, yulgon.kim@samsung.com.
 *	- only support for S5PC510
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

#ifndef __EXYNOS_USBD_SS_H__
#define __EXYNOS_USBD_SS_H__

#include <asm/byteorder.h>
#include <asm/arch/cpu.h>
#include <mach/usb.h>
#include <asm/io.h>

//==========================
// Define
//==========================
#define CONTROL_EP			0
#define BULK_IN_EP			1
#define BULK_OUT_EP			2
#define TOTL_EP_COUNT			16

#define USBDEV3_MDWIDTH			64	// master data bus width
#define USBDEV3_DATA_BUF_SIZ		16384	// 16KB

#define CMDCOMPLETEWAIT_UNIT		1000

#define RX_FIFO_SIZE			1024
#define NPTX_FIFO_START_ADDR		RX_FIFO_SIZE
#define NPTX_FIFO_SIZE			256
#define PTX_FIFO_SIZE			256

#define CTRL_BUF_SIZE			128		//512

// string descriptor
#define LANGID_US_L			(0x09)
#define LANGID_US_H			(0x04)

// Feature Selectors
#define EP_STALL          		0
#define DEVICE_REMOTE_WAKEUP		1
#define TEST_MODE			2

/* Test Mode Selector*/
#define TEST_J				1
#define TEST_K				2
#define TEST_SE0_NAK			3
#define TEST_PACKET			4
#define TEST_FORCE_ENABLE		5

#define USB_DEVICE			0
#define USB_HOST			1
#define USB_OTG				2

#define FULL_SPEED_CONTROL_PKT_SIZE	64
#define FULL_SPEED_BULK_PKT_SIZE	64

#define HIGH_SPEED_CONTROL_PKT_SIZE	64
#define HIGH_SPEED_BULK_PKT_SIZE	512

#define SUPER_SPEED_CONTROL_PKT_EXP_SZ	9	// 2^9 = 512
#define SUPER_SPEED_CONTROL_PKT_SIZE	512
#define SUPER_SPEED_BULK_PKT_SIZE	1024

typedef struct {
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
} USB_DEVICE_DESCRIPTOR;

typedef struct {
	u8 bLength;
	u8 bDescriptorType;
	u8 wTotalLengthL;
	u8 wTotalLengthH;
	u8 bNumInterfaces;
	u8 bConfigurationValue;
	u8 iConfiguration;
	u8 bmAttributes;
	u8 maxPower;
} USB_CONFIGURATION_DESCRIPTOR;

typedef struct {
	u8 bLength;
	u8 bDescriptorType;
	u8 bInterfaceNumber;
	u8 bAlternateSetting;
	u8 bNumEndpoints;
	u8 bInterfaceClass;
	u8 bInterfaceSubClass;
	u8 bInterfaceProtocol;
	u8 iInterface;
} USB_INTERFACE_DESCRIPTOR;

typedef struct {
	u8 bLength;
	u8 bDescriptorType;
	u8 bEndpointAddress;
	u8 bmAttributes;
	u8 wMaxPacketSizeL;
	u8 wMaxPacketSizeH;
	u8 bInterval;
} USB_ENDPOINT_DESCRIPTOR;

typedef struct {
	u8  bLength;
	u8  bDescriptorType;
	u8  bMaxBurst;
	u8  bmAttributes;
	u16 wBytesPerInterval;
} __attribute__ ((packed)) USB_SS_EP_COMP_DESCRIPTOR;

typedef struct {
	u8 bLength;
	u8 bDescriptorType;
	u8 *pString;
} USB_STRING_DESCRIPTOR;

typedef struct {
	__u8 bLength;
	__u8 bDescriptorType;
	__le16 wTotalLength;
	__u8 bNumDeviceCaps;
} __attribute__ ((packed)) USB_BOS_DESCRIPTOR;

typedef struct {
	__u8 bLength;
	__u8 bDescriptorType;
	__u8 bDevCapabilityType;
	__le32 bmAttributes;
} __attribute__ ((packed)) USB20_EXT_CAP_DESCRIPTOR;

typedef struct {
	__u8 bLength;
	__u8 bDescriptorType;
	__u8 bDevCapabilityType;
	__u8 bmAttributes;
	__le16 wSpeedsSupported;
	__u8 bFunctionalitySupport;
	__u8 bU1DevExitLat;
	__le16 wU2DevExitLat;
} __attribute__ ((packed)) USB_SUPERSPEED_CAP_DESCRIPTOR;

typedef struct {
	__u8 bLength;
	__u8 bDescriptorType;
	__u8 bDevCapabilityType;
	__u8 bReserved;
	__u8 containerID[16];
} __attribute__ ((packed)) USB_CONTAINER_ID_CAP_DESCRIPTOR;

typedef struct {
	USB_DEVICE_DESCRIPTOR oDescDevice;
	USB_CONFIGURATION_DESCRIPTOR oDescConfig;
	USB_INTERFACE_DESCRIPTOR oDescInterface;
	USB_ENDPOINT_DESCRIPTOR oDescEp0;
	USB_ENDPOINT_DESCRIPTOR oDescEp1;
	USB_ENDPOINT_DESCRIPTOR oDescEp2;
	USB_ENDPOINT_DESCRIPTOR oDescEp3;
} __attribute__ ((packed)) USB_DESCRIPTORS;

typedef struct {
	USB_DEVICE_DESCRIPTOR oDescDevice;
	USB_CONFIGURATION_DESCRIPTOR oDescConfig;
	USB_INTERFACE_DESCRIPTOR oDescInterface;
	USB_ENDPOINT_DESCRIPTOR oDescEp0;
	USB_SS_EP_COMP_DESCRIPTOR oDescEp0Comp;
	USB_ENDPOINT_DESCRIPTOR oDescEp1;
	USB_SS_EP_COMP_DESCRIPTOR oDescEp1Comp;
	USB_ENDPOINT_DESCRIPTOR oDescEp2;
	USB_SS_EP_COMP_DESCRIPTOR oDescEp2Comp;
	USB_ENDPOINT_DESCRIPTOR oDescEp3;
	USB_SS_EP_COMP_DESCRIPTOR oDescEp3Comp;
	USB_BOS_DESCRIPTOR oDescBos;
	USB20_EXT_CAP_DESCRIPTOR oDescUsb20Ext;
	USB_SUPERSPEED_CAP_DESCRIPTOR oDescSuperCap;
	USB_CONTAINER_ID_CAP_DESCRIPTOR oDescContainCap;
} __attribute__ ((packed)) USB_SS_DESCRIPTORS;

typedef struct {
	u8 bmRequestType;
	u8 bRequest;
	u8 wValue_L;
	u8 wValue_H;
	u8 wIndex_L;
	u8 wIndex_H;
	u8 wLength_L;
	u8 wLength_H;
} DEVICE_REQUEST, *DEVICE_REQUEST_PTR;

//=====================================================================
// definitions related to Standard Device Requests
#define SETUP_DATA_SIZE	8

// Standard bmRequestType (direction)
// #define DEVICE_bmREQUEST_TYPE(oDeviceRequest)  ((m_poDeviceRequest->bmRequestType) & 0x80)
enum DEV_REQUEST_DIRECTION
{
	HOST_TO_DEVICE	= 0x00,
	DEVICE_TO_HOST	= 0x80
};

// Standard bmRequestType (Type)
// #define DEVICE_bmREQUEST_TYPE(oDeviceRequest)  ((m_poDeviceRequest->bmRequestType) & 0x60)
enum DEV_REQUEST_TYPE
{
	STANDARD_TYPE	= 0x00,
	CLASS_TYPE	= 0x20,
	VENDOR_TYPE	= 0x40,
	RESERVED_TYPE	= 0x60
};

// Standard bmRequestType (Recipient)
// #define DEVICE_bmREQUEST_RECIPIENT(oDeviceRequest)  ((m_poDeviceRequest->bmRequestType) & 0x07)
enum DEV_REQUEST_RECIPIENT
{
	DEVICE_RECIPIENT	= 0,
	INTERFACE_RECIPIENT	= 1,
	ENDPOINT_RECIPIENT	= 2,
	OTHER_RECIPIENT		= 3
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
	STANDARD_SYNCH_FRAME		= 12,
	STANDARD_SET_SEL		= 48,
	STANDARD_ISOCH_DELY		= 49,
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
	BOS				= 15,
};

// configuration descriptor: bmAttributes
enum CONFIG_ATTRIBUTES
{
	CONF_ATTR_DEFAULT		= 0x80, // in Spec 1.0, it was BUSPOWERED bit.
	CONF_ATTR_REMOTE_WAKEUP		= 0x20,
	CONF_ATTR_SELFPOWERED		= 0x40
};

// endpoint descriptor
enum ENDPOINT_ATTRIBUTES
{
	EP_ADDR_IN		= 0x80,
	EP_ADDR_OUT		= 0x00,

	EP_ATTR_CONTROL		= 0x0,
	EP_ATTR_ISOCHRONOUS	= 0x1,
	EP_ATTR_BULK		= 0x2,
	EP_ATTR_INTERRUPT	= 0x3
};

// Descriptor size
enum DESCRIPTOR_SIZE
{
	DEVICE_DESC_SIZE	= 18,
	STRING_DESC0_SIZE	= 4,
	STRING_DESC1_SIZE	= 22,
	STRING_DESC2_SIZE	= 42,
	CONFIG_DESC_SIZE	= 9,
	INTERFACE_DESC_SIZE	= 9,
	ENDPOINT_DESC_SIZE	= 7,
	ENDPOINT_COMP_DESC_SIZE	= 6,
	DEVICE_QUALIFIER_SIZE	= 10,
	OTHER_SPEED_CFG_SIZE 	= 9,
	BOS_DESC_SIZE		= 5,
	USB20_EXT_CAP_DESC_SIZE	= 7,
	SUPER_CAP_DESC_SIZE	= 10,
	CONTAIN_CAP_DESC_SIZE	= 5,
};

typedef enum
{
	USB_HIGH, USB_FULL, USB_LOW
} USB_SPEED;

typedef enum
{
	USBPHY0,
	USBPHY1,
} USB_PHY;

typedef enum {
	DIFF_100MHz,
	DIFF_24MHz,
	DIFF_20MHz,
	DIFF_19_2MHz,

	EXTREF_50MHz,
	EXTREF_24MHz,
	EXTREF_20MHz,
	EXTREF_19_2MHz,
	EXTREF_12MHz,
	EXTREF_10MHz,
	EXTREF_9_6MHz,
} USB3_PHY_CLKFREQ;

typedef enum
{
	UNCHECKED, DISCONNECTED, CONNECTED
} CABLE_STATUS;

typedef struct {
	u8 ConfigurationValue;
} __attribute__ ((packed)) USB_CONFIGURATION_SET;

typedef struct {
	u8 Device;
	u8 Interface;
	u8 EndpointCtrl;
	u8 EndpointIn;
	u8 EndpointOut;
} __attribute__ ((packed)) USB_GET_STATUS;

typedef struct {
	u8 AlternateSetting;
} __attribute__ ((packed)) USB_INTERFACE_GET;

typedef struct Usb_st_REG {
	u8 name[64];
	u32 uAddr;
	u8 uBitLen;
	u8 uRWType;
	u8 uFlag;						//Option Flag(DPDB, DPPB, PPDB PPPB)
	u32 uPrivateBitMask;
	u32 rValue;
} USBDEV3_REGINFO;

//==================================================================
// CSR STRUCTURE
//
// PHYUTMI
typedef union
{
	u32 data;	// reset value : 0x00000630
	struct {
		// bit[0] : force sleep
		unsigned force_sleep:1;
		// bit[1] : force suspend
		unsigned force_suspend:1;
		// bit[2] : dmpulldown
		unsigned dm_pulldown:1;
		// bit[3] : dppulldown
		unsigned dp_pulldown:1;
		// bit[4] : drvvbus
		unsigned drvvbus:1;
		// bit[5] : idpullup
		unsigned id_pullup:1;
		// bit[6] : otg disable
		unsigned otg_disable:1;
		// bit[8:7] : reserved
		unsigned rsvd8_7:2;
		// bit[9] : external vbus valid indicator (to phy)
		unsigned vbusvld_ext:1;
		// bit[10] : external vbus valid select
		unsigned vbusvld_extsel:1;
		// bit[31:11] : reserved
		unsigned rsvd31_11:21;
	}b;
} usb3_phy_utmi_t;

// PHYCLKPWR
typedef union
{
	u32 data;	// reset value : 0x801bee3b@c520, 0x441b4558@c510
	struct {
			// bit[0] : common block power-down control
			//            (0->in suspend or sleep mode, the HS bias and pll blocks remain powered and continue to draw current,
			//             1->in suspend or sleep mode, the HS bias and pll blocks are powered down)
			unsigned commononn:1;
			// bit[1] : per-port reset (reest the port's USB2.0 transmit and receive logic without disableing the clocks)
			unsigned portreset:1;
			// bit[3:2] : reference clock select for pll block
			//               (2'b11:HS pll uses EXTREFCLK as reference, 2'b10:HS pll uses ref_pad_clk{p,m}
			unsigned refclksel:2;
			// bit[4] : lowered digital suplly indicator (0->normal operating mode, 1->analog blocks are powered-down
			unsigned retenablen:1;
			// bit[10:5] : frequency select
			unsigned fsel:6;
			// bit[17:11] : mpll frequency multiplier control
			unsigned mpll_multiplier:7;
			// bit[18] : input reference clock divider control
			unsigned ref_clkdiv2:1;
			// bit[19] : reference clock enable for SS function
			// enables the reference clock to the prescaler
			// this must remain deasserted until the ref. clock is running at the appropriate fre., 
			// at which point ref_ssp_en can be asserted.
			// for lower power states, ref_ssp_en can be deasserted.
			unsigned ref_ssp_en:1;
			// bit[20] : spread spectrum enable
			unsigned ssc_en:1;
			// bit[22:21] : spread spectrum clock range
			unsigned ssc_range:2;
			// bit[30:23] : spread spectrum reference clock shifting
			unsigned ssc_ref_clk_sel:8;
			// bit[31] : reserved
			unsigned rsvd31:1;
	}b;
} usbdev3_phy_clkpwr_t;

// PHYREG0
typedef union
{
	u32 data;
	struct {
		// bit[0] : CR_CMD_ADDR
		unsigned cr_cap_addr:1;
		// bit[1] : CR_CMD_DATA
		unsigned cr_cap_data:1;
		// bit[17:2] : send data to crport
		unsigned cr_data_in:16;
		// bit[18] : CR_CMD_READ
		unsigned cr_read:1;
		// bit[19] : CR_CMD_WRITE
		unsigned cr_write:1;
		// bit[31:20] : reserved
		unsigned rsvd31_11:12;
	}b;
} usb3_phy_reg0_t;
// PHYREG1
typedef union
{
	u32 data;
	struct {
		// bit[0] : receive ack from crport
		unsigned cr_ack:1;
		// bit[16:1] : receive data from crport
		unsigned cr_data_out:16;
		// bit[31:17] : reserved
		unsigned rsvd31_11:15;
	}b;
} usb3_phy_reg1_t;
//-----------------------
// Global Registers (Gxxxx)
//-----------------------
// rGSBUSCFG0
typedef union
{
	u32 data;	// reset value : 0x00000001
	struct {
		// bit[0] : undefined length INCR burst type enable
		unsigned incr_xbrst_ena:1;
		// bit[1] : INCR4 burst type enable
		unsigned incr_4brst_ena:1;
		// bit[2] : INCR8 burst type enable
		unsigned incr_8brst_ena:1;
		// bit[3] : INCR16 burst type enable
		unsigned incr_16brst_ena:1;
		// bit[10:4] :
		unsigned rsvd10_4:7;
		// bit[11] : data access is big endian
		unsigned dat_big_end:1;
		// bit[12] : bus store-and-forward mode?
		unsigned sbus_store_and_forward:1;
		// bit[31:13]
		unsigned rsvd31_13:19;
	}b;
} usbdev3_gsbuscfg0_t;

// rGSBUSCFG1
typedef union
{
	u32 data;	// reset value : 0x00000300
	struct {
		// bit[7:0] :
		unsigned rsvd7_0:8;
		// bit[11:8] : axi burst request limit
		unsigned breq_limit:4;
		// bit[12] : 1k page boundary enable
		unsigned en_1kpage:1;
		// bit[31:13]
		unsigned rsvd31_13:19;
	}b;
} usbdev3_gsbuscfg1_t;

// rGSCTL
typedef union
{
	u32 data;	// reset value : 0x30c02000
	struct {
		// bit[0] : Disable Clock Gating in LP Mode ( 0:Enable, 1:disable )
		unsigned dis_clk_gating:1;
		// bit[1] : HS/FS/LS Module Power Clamp
		unsigned HsFsLsPwrClmp:1;
		// bit[2] : SS Module Power Clamp
		unsigned SsPwrClmp:1;
		// bit[3] : Disable Data Scrambling in SS ( 0:enable, 1:disable )
		unsigned DisScramble:1;
		// bit[5:4] : Scale Down : for simulation
		unsigned ScaleDown:2;
		// bit[7:6] : ram clock select (0:bus, 1:pipe, 2:pipe/2, 3:rsvd)
		unsigned  ram_clk_sel:2;
		// bit[8] : debug attach
		unsigned debug_attach:1;
		// bit[9] : loopback enable
		unsigned phy_loopback_en:1;
		// bit[10] : local loopback enable
		unsigned local_loopback_en:1;
		// bit[11] : core soft reset
		unsigned core_soft_reset:1;
		// bit[13:12] : port cabpbility direction (1:host, 2:device, 3:otg configuration)
		unsigned port_capdir:2;
		// bit[15:14] :
		unsigned frm_scale_down:2;
		// bit[16] :
		unsigned u2rst_ecn:1;
		// bit[18:17] :
		unsigned rsvd18_17:2;
		// bit[31:19] : power down scale
		unsigned pwr_down_scale:13;
	}b;
} usbdev3_gctl_t;

// GSTS
typedef enum
{
	GSTS_CUR_OP_MODE_DEVICE, GSTS_CUR_OP_MODE_HOST, GSTS_CUR_OP_MODE_DRD
} USBDEV3_GSTS_CUR_OP_MODE;
typedef union
{
	u32 data;	// reset value : 0x
	struct {
		// bit[1:0] : current mode of operation
		unsigned cur_mod:2;
		// bit[31:2] :
		unsigned rsvd31_2:30;
	}b;
} usbdev3_gsts_t;

// GUSB2PHYCFG
typedef union
{
	u32 data;	// reset value : 0x
	struct {
		// bit[2:0] :
		unsigned timeout_cal:3;
		// bit[3] : 0-> 8bit, 1-> 16bit
		unsigned phy_if:1;
		// bit[5:4] :
		unsigned rsvd5_4:2;
		// bit[6] :
		unsigned suspend_usb2_phy:1;
		// bit[7] :
		unsigned rsvd7:1;
		// bit[8] :
		unsigned enable_sleep_n:1;
		// bit[9] :
		unsigned rsvd9:1;
		// bit[13:10] :
		unsigned turnaround_time:4;
		// bit[30:14] :
		unsigned rsvd30_14:17;
		// bit[31] :
		unsigned phy_soft_reset:1;
	}b;
} usbdev3_gusb2phycfg_t;

// GUSB3PIPECTL
typedef union
{
	u32 data;	// reset value : 0x00260002
	struct {
		// bit[16:0] :
		unsigned rsvd16_0:17;
		// bit[17] : suspend USB3.0 SS PHY
		unsigned suspend_usb3_ss_phy:1;
		// bit[30:18] :
		unsigned rsvd31_18:13;
		// bit[31] : usb3 phy soft reset
		unsigned phy_soft_reset:1;
	}b;
} usbdev3_gusb3pipectl_t;

// GEVNTSIZ
typedef union
{
	u32 data;	// reset value : 0x00000000
	struct {
		// bit[15:0] : event buffer size in bytes (must be a multiple of 4)
		unsigned event_siz:16;
		// bit[30:16] :
		unsigned rsvd30_16:15;
		// bit[31] : event interrupt mask (1 : prevent the interrupt from being generated)
		unsigned event_int_mask:1;
	}b;
} usbdev3_gevntsiz_t;

//-----------------------
// Device Registers (Dxxxx)
//-----------------------
// DCFG
typedef enum
{
	USBDEV3_SPEED_SUPER	= 4,
	USBDEV3_SPEED_HIGH	= 0,
	USBDEV3_SPEED_FULL	= 1
}USBDEV3_SPEED_e;
typedef union
{
	u32 data;	// reset value : 0x00080804
	struct {
		// bit[2:0] : device speed
		unsigned dev_speed:3;
		// bit[9:3] : device address
		unsigned dev_addr:7;
		// bit[11:10] : periodic frame interval
		unsigned per_fr_int:2;
		// bit [16:12] : interrupt number
		unsigned intr_num:5;
		// bit[21:17] : # of rx buffers
		unsigned num_rx_buf:5;
		// bit[22] : lpm capable
		unsigned lpm_cap:1;
		// bit[23] : ignore stream pp ???
		unsigned ignore_stream_pp:1;
		// bit[31:24] :
		unsigned rsvd31_24:8;
	}b;
} usbdev3_dcfg_t;

typedef enum
{
	DCTL_TEST_MODE_DISABLED = 0,
	DCTL_TEST_J_MODE = 1,
	DCTL_TEST_K_MODE = 2,
	DCTL_TEST_SE0_NAK_MODE = 3,
	DCTL_TEST_PACKET_MODE = 4,
	DCTL_TEST_FORCE_ENABLE = 5,
	DCTL_TEST_CTRL_FIELD = 7
} USBDEV3_DCTL_TEST_CTRL_e;

// DCTL
typedef union
{
	u32 data;	// reset value : 0x0
	struct {
		// bit[0] :
		unsigned rsvd0:1;
		// bit[4:1] : Test Control
		unsigned test_ctrl:4;
		// bit[29:5] :
		unsigned rsvd29_5:25;
		// bit[30] : core soft reset
		unsigned core_soft_reset:1;
		// bit[31] : run/stop
		unsigned run_stop:1;
	}b;
} usbdev3_dctl_t;

// DEVTEN
typedef union
{
	u32 data;	// reset value : 0x0
	struct {
		// bit[0] : disconnect detected event enable
		unsigned disconn_evt_en:1;
		// bit[1] : usb reset  enable
		unsigned usb_reset_en:1;
		// bit[2] : connection done enable
		unsigned conn_done_en:1;
		// bit[3] : usb/link state change event enable
		unsigned usb_lnk_sts_chng_en:1;
		// bit[4] : resume/remote wakeup detected event enable
		unsigned wake_up_en:1;
		// bit[5] :
		unsigned rsvd5:1;
		// bit[6] : end of periodic frame event enable
		unsigned eopf_en:1;
		// bit[7] : start of (micro)frame enable
		unsigned sof_en:1;
		// bit[8] :
		unsigned rsvd8:1;
		// bit[9] : erratic error event enable
		unsigned errtic_err_en:1;
		// bit[10] : generic command compete event enable
		unsigned cmd_cmplt_en:1;
		// bit[11] : event buffer overflow event enable
		unsigned evnt_overflow_en:1;
		// bit[12] : vendor device test LMP received event enable ???
		unsigned vndr_dev_tst_rcved_en:1;
		// bit[31:13] :
		unsigned rsvd31_13:19;
	}b;
} usbdev3_devten_t;

// DSTS
typedef union
{
	u32 data;	// reset value : 0x00020004
	struct {
		// bit[2:0] : connected speed(0:hs, 1:fs, 4:ss)
		unsigned connect_speed:3;
		// bit[16:3] : (u)frame # of the received SOF
		unsigned soffn:14;
		// bit[17] : RxFIFO Empty
		unsigned rx_fifo_empty:1;
		// bit[21:18] : USB/Link State
		unsigned usb_link_sts:4;
		// bit[22] : device controller halted
		unsigned dev_ctrl_halted:1;
		// bit[23] : core idle
		unsigned core_idle:1;
		// bit[24] : power up request
		unsigned pwr_up_req:1;
		// bit[31:25]
		unsigned rsvd31_25:7;
	}b;
} usbdev3_dsts_t;

// DGCMD
typedef enum
{
	DGCMD_CMD_XMIT_SET_LINK_FUNC_LMP	= 0x1,
	DGCMD_CMD_SET_PERIODIC_PARAMS		= 0x2,
	DGCMD_CMD_XMIT_FUNC_WAKE_DEV_NOTIF	= 0x3,
	DGCMD_CMD_SELECTED_FIFO_FLUSH		= 0x9,
	DGCMD_CMD_ALL_FIFO_FLUSH		= 0xa,
	DGCMD_CMD_SET_EP_NRDY			= 0xc,
	DGCMD_CMD_RUN_SOC_BUS_LOOPBACK_TEST	= 0x10
} USBDEV3_DGCMD_CMD_e;

typedef union
{
	u32 data;	// reset value : 0x0
	struct {
		// bit[7:0] : command type
		unsigned cmd_type:8;
		// bit[8] : command interrupt on complete
		unsigned ioc:1;
		// bit[9]
		unsigned rsvd9:1;
		// bit[10] : command active
		unsigned cmd_active:1;
		// bit[14:11]
		unsigned rsvd14_11:4;
		// bit[15] : command completion status (0:error, 1:success)
		unsigned cmd_sts:1;
		// bit[31:16] :
		unsigned rsvd31_16:16;
	}b;
} usbdev3_dgcmd_t;

// DEPCMDPAR1
	// This structure represents the bit fields in the Device Endpoint Command
	// Parameter 1 Register (DEPCMDPAR1n) for the Set Endpoint Configuration
	// (DEPCMD_SET_EP_CFG) command.
typedef enum
{
	USBDEV3_EP_DIR_OUT = 0,
	USBDEV3_EP_DIR_IN = 1
} USBDEV3_EP_DIR_e;

typedef union
{
	u32 data;	// reset value : 0x0
	struct {
		// bit[4:0] : interrupt number
		unsigned intr_num:5;
		// bit[7:5]
		unsigned rsvd7_5:3;
		// bit[8] : transfer complete enable
		unsigned xfer_cmpl_en:1;
		// bit[9] : xfer in progress enable
		unsigned xfer_in_prog_en:1;
		// bit[10] : xfer not ready enable
		unsigned xfer_nrdy_en:1;
		// bit[11] : fifo under/over-run enable
		unsigned fifo_xrun_en:1;
		// bit[12]
		unsigned rsvd12:1;
		// bit[13] : stream event enable
		unsigned str_evnt_en:1;
		// bit[15:14]
		unsigned rsvd15_14:2;
		// bit[23:16] : b interval -1
		unsigned binterval_m1:8;
		// bit[24] : stream capable
		unsigned strm_cap:1;
		// bit[25] : ep direction(0:out, 1:in)
		unsigned ep_dir:1;
		// bit[29:26] : ep number
		unsigned ep_num:4;
		// bit[30] : bulk-base
		unsigned bulk_based:1;
		// bit[31] : fifo-based
		unsigned fifo_based:1;
	}b;
} usbdev3_depcmdpar1_set_ep_cfg_t;

// DEPCMDPAR0
	// This structure represents the bit fields in the Device Endpoint Command
	// Parameter 0 Register (DEPCMDPAR0n) for the Set Endpoint Configuration
	// (DEPCMD_SET_EP_CFG) command.
typedef enum
{
	USBDEV3_EP_CTRL = 0,
	USBDEV3_EP_ISOC = 1,
	USBDEV3_EP_BULK = 2,
	USBDEV3_EP_INTR = 3
}USBDEV3_EP_TYPE_e;

typedef union
{
	u32 data;	// reset value : 0x0
	struct {
		// bit[0]
		unsigned rsvd0:1;
		// bit[2:1] : ep type
		unsigned ep_type:2;
		// bit[13:3] : maximum packet size
		unsigned mps:11;
		// bit[16:14]
		unsigned rsvd16_14:3;
		// bit[21:17] : fifo number
		unsigned fifo_num:5;
		// bit[25:22] : burst size
		unsigned brst_siz:4;
		// bit[30:26] : data sequence number
		unsigned ds_num:5;
		// bit[31] : ignor sequence number
		unsigned ign_dsnum:1;
	}b;
} usbdev3_depcmdpar0_set_ep_cfg_t;

// DEPCMD
typedef enum
{
	DEPCMD_CMD_RSVD = 0x0,
	DEPCMD_CMD_SET_EP_CFG = 0x1,
	DEPCMD_CMD_SET_EP_XFER_RSRC_CFG = 0x2,
	DEPCMD_CMD_GET_DATA_SEQ_NUM = 0x3,
	DEPCMD_CMD_SET_STALL = 0x4,
	DEPCMD_CMD_CLR_STALL = 0x5,
	DEPCMD_CMD_START_XFER = 0x6,
	DEPCMD_CMD_UPDATE_XFER = 0x7,
	DEPCMD_CMD_END_XFER = 0x8,
	DEPCMD_CMD_START_NEW_CFG = 0x9
} USBDEV3_DEPCMD_CMD_TYPE_e;
typedef union
{
	u32 data;	// reset value : 0x0
	struct {
		// bit[3:0] : Command Type
		unsigned cmd_type:4;
		// bit[7:4]
		unsigned rsvd7_4:4;
		// bit[8] : command interrupt on complete
		unsigned ioc:1;
		// bit9]
		unsigned rsvd9:1;
		// bit[10] : command active
		unsigned cmd_active:1;
		// bit[11] : high priority(only valid for start transfer command), forceRM(only valid for end transfer command)
		unsigned hipri_forcerm:1;
		// bit[15:12] : command completion status
		unsigned cmd_sts:4;
		// bit[31:16] : command parameters(written case), event parameters(read case)
		unsigned param:16;
	}b;
} usbdev3_depcmd_t;

/////////////////////////////////////////////////
// Event Buffer Structures
//

#define USBDEV3_EVENT_BUFFER_COUNT	128	//256

// Event Buffer for Device Endpoint-Specific Events
typedef enum
{
	DEPEVT_EVT_XFER_CMPL	= 1,
	DEPEVT_EVT_XFER_IN_PROG	= 2,
	DEPEVT_EVT_XFER_NRDY	= 3,
	DEPEVT_EVT_FIFOXRUN	= 4,
	DEPEVT_EVT_STRM_EVT	= 6,
	DEPEVT_EVT_EPCMD_CMPL	= 7,
}USBDEV3_DEPEVT_EVT_e;

typedef union
{
	u32 data;
	struct {
		// bit[0] : 0-> ep-specific event
		unsigned non_ep_evnt:1;
		// bit[5:1] : ep number
		unsigned ep_num:5;
		// bit[9:6] : event type
		unsigned evt_type:4;
		// bit[11:10]
		unsigned rsvd11_10:2;
		// bit[15:12] : event status
		unsigned evnt_sts:4;
		// bit[31:16] : event parameters
		unsigned evnt_param:16;
	}b;
}usbdev3_depevt_t;

// Event Buffer for Device-Specific Events
typedef enum
{
	DEVT_DISCONN		= 0,
	DEVT_USBRESET		= 1,
	DEVT_CONNDONE		= 2,
	DEVT_ULST_CHNG		= 3,
	DEVT_WKUP		= 4,
	DEVT_EOPF		= 6,
	DEVT_SOF		= 7,
	DEVT_ERRATICERR		= 9,
	DEVT_CMD_CMPL		= 10,
	DEVT_OVERFLOW		= 11,
	DEVT_VNDR_DEV_TST_RCVD	= 12,
	DEVT_INACT_TIMEOUT_RCVD	= 13,
}USBDEV3_DEVT_e;

typedef union
{
	u32 data;
	struct {
		// bit[0] : 1-> device-specific event
		unsigned non_ep_evnt:1;
		// bit[7:1] : 0-> device specific, 1-> OTG, 3-> ULPI Carkit, 4-> I2C
		unsigned dev_specific:7;
		// bit[11:8] : event type
		unsigned evt_type:4;
		// bit[15:12]
		unsigned rsvd15_12:4;
		// bit[23:16] : event information bits
		unsigned evt_info:8;
		// bit[31:24]
		unsigned rsvd31_24:8;
	}b;
}usbdev3_devt_t;
//

/////////////////////////////////////////////////
// DMA Descriptor Specific Structures
//

// Limit of bytes in one TRB
#define TRB_BUF_SIZ_LIMIT	16777215	//2^24 - 1 (16MB -1byte)

// status field of TRB
typedef union
{
	u32 data;
	struct
	{
		// bit[23:0] : buffer size
		unsigned buf_siz:24;
		// bit[25:24] : packet count minus 1
		unsigned pkt_cnt_m1:2;
		// bit[27:26]
		unsigned rsvd27_26:2;
		// bit[31:28] : TRB status
		unsigned trb_sts:4;
	}b;
}usbdev3_trb_sts_t;

typedef enum
{
	TRB_CTRL_NORMAL		= 1,		// Control-Data-2+ / bulk / Interrupt
	TRB_CTRL_SETUP		= 2,
	TRB_CTRL_STATUS_2	= 3,
	TRB_CTRL_STATUS_3	= 4,
	TRB_CTRL_CTLDATA_1ST	= 5,		// 1st TRB of Data stage
	TRB_CTRL_ISOC_1ST	= 6,		// 1st TRB of Service Interval
	TRB_CTRL_ISOC		= 7,
	TRB_CTRL_LINK		= 8,		// Link TRB
} USBDEV3_TRB_TYPE_e;

// control field of TRB
typedef union
{
	u32 data;
	struct
	{
		// bit[0] : h/w owner of descriptor
		unsigned hwo:1;
		// bit[1] : last TRB
		unsigned lst:1;
		// bit[2] : chain buffers
		unsigned chn:1;
		// bit[3] : continue on short packet
		unsigned csp:1;
		// bit[9:4] : TRB control
		unsigned trb_ctrl:6;
		// bit[10] : interrupt on short packet/ interrupt on missed ISOC
		unsigned isp_imi:1;
		// bit[11] : interrupt on complete
		unsigned ioc:1;
		// bit[13:12]
		unsigned rsvd13_12:2;
		// bit[29:14] : stream ID/ SOF #
		unsigned strmid_sofn:16;
		// bit[31:30]
		unsigned rsvd31_30:2;
	}b;
} usbdev3_trb_ctrl_t;

// TRB structure
typedef struct
{
	u32 buf_ptr_l;	// buffer pointer low
	u32 buf_ptr_h;	// buffer pointer high
	usbdev3_trb_sts_t status;
	usbdev3_trb_ctrl_t control;
} usbdev3_trb_t, *usbdev3_trb_ptr_t;


//------------------------------------------------
// USBDEV state
typedef enum
{
	USBDEV3_STATE_DEFAULT,
	USBDEV3_STATE_ADDRESSED,
	USBDEV3_STATE_CONFIGURED,
} USBDEV3_STATE;

typedef struct
{
	union {
		USB_DESCRIPTORS m_oDesc;
		USB_SS_DESCRIPTORS m_oSSDesc;
	};

	DEVICE_REQUEST m_oDeviceRequest;

	u32  m_uEp0State;
	u32  m_uEp0SubState;
	USBDEV3_SPEED_e m_eSpeed;
	u32  m_uControlEPMaxPktSize;
	u32  m_uBulkEPMaxPktSize;
	u32  m_uDownloadAddress;
	u32  m_uDownloadFileSize;
	u32  m_uUploadAddr;
	u32  m_uUploadSize;
	u8*  m_pDownPt;
	u8*  m_pUpPt;
	USBDEV3_STATE  m_eUsbDev3State;
	u32  m_uDeviceRequestLength;
	u8 m_bEp0ThreeStage;

	u8 m_bEPs_Enabled;

	u32 m_uLinkBaseRegs;
	u32 m_uPhyBaseRegs;
	u32 *m_pEventBuffer;
	u16 m_CurrentEventPosition;

	// Buffer for GET_STATUS & GET_DESCRIPTOR up to 512 bytes in length
	u32 m_uStatusBufAddr;

	// SET_SEL request pending info
	u8 m_bReq_Set_sel;

	// TRB for Setup Packet
	volatile usbdev3_trb_ptr_t m_oSetupTrbPtr;

	// TRB for Data-Out or Status-Out phase
	volatile usbdev3_trb_ptr_t m_oOutTrbPtr;

	// TRB for Data-In or Status-In phase
	volatile usbdev3_trb_ptr_t m_oInTrbPtr;

	// Transfer Resource Index for Each EP
	u32 m_uTriOut[TOTL_EP_COUNT];
	u32 m_uTriIn[TOTL_EP_COUNT];

	// Stall Status for Each EP
	u8 m_bEpOutStalled[TOTL_EP_COUNT];
	u8 m_bEpInStalled[TOTL_EP_COUNT];

	CABLE_STATUS m_cable;
} USBDEV3;

// EP0 state
enum EP0_STATE
{
	EP0_STATE_UNCONNECTED		= 0xffff,
	EP0_STATE_INIT			= 0,
	EP0_STATE_IN_DATA_PHASE		= 1,
	EP0_STATE_OUT_DATA_PHASE	= 2,
	EP0_STATE_IN_WAIT_NRDY		= 3,
	EP0_STATE_OUT_WAIT_NRDY		= 4,
	EP0_STATE_IN_STATUS_PHASE	= 5,
	EP0_STATE_OUT_STATUS_PHASE	= 6,
	EP0_STATE_STALL			= 7
};

//=====================================================================================
// prototypes of API functions
void Isr_UsbDev3(void);
u8 USBDEV3_Init(USBDEV3_SPEED_e eSpeed);
void USBDEV3_DeInit(void);

u8 USBDEV3_IsUsbDevSetConfiguration(void);

void USBDEV3_Prepare1stBulkOutTrb(void);

void USBDEV3_ClearDownFileInfo(void);
void USBDEV3_GetDownFileInfo(u32* uDownAddr, u32* uDownFileSize, u8* bIsFinished);
void USBDEV3_ClearUpFileInfo(void);
void USBDEV3_GetUpFileInfo(u32* uUpAddr, u32* uUpFileSize, u8* bIsFinished);
u8 USBDEV3_VerifyChecksum(void);
void USBDEV3_OpenUsingUsbDownAddr(u32 Addr);
void USBDEV3_CloseUsingUsbDownAddr(void);
u32 USBDEV3_AllocateDataStructure(u32 uSize, u32 uAlign);
void USBDEV3_FreeDataStructure(u32 uAddr);

int exynos_usbctl_init(void);
int exynos_usbc_activate (void);
int exynos_usb_stop( void );
int exynos_udc_int_hndlr(void);

/* in usbd3-ss.c */
extern unsigned int exynos_usbd_dn_addr;
extern unsigned int exynos_usbd_dn_cnt;
extern int DNW;
extern int exynos_got_header;
extern int exynos_receive_done;

#endif
