#ifndef __LINUX_USB_CH9_H
#define __LINUX_USB_CH9_H

/**
 * @file usb_ch9.h
 * @brief This file holds USB constants and structures that are needed for USB
 * device APIs.  These are used by the USB device model, which is defined
 * in chapter 9 of the USB 2.0 specification.  Linux has several APIs in C
 * that need these:
 *
 * - the master/host side Linux-USB kernel driver API;
 * - the "usbfs" user space API; and
 * - the Linux "gadget" slave/device/peripheral side driver API.
 *
 * USB 2.0 adds an additional "On The Go" (OTG) mode, which lets systems
 * act either as a USB master/host or as a USB slave/device.  That means
 * the master and slave side APIs benefit from working well together.
 *
 * There's also "Wireless USB", using low power short range radios for
 * peripheral interconnection but otherwise building on the USB framework.
 *
 * @addtogroup usb_core
 */
/*@{*/

#include <linux/types.h>

/*******************************************************
* CONTROL REQUEST SUPPORT
********************************************************/

/// USB directions, to device
/// This bit flag is used in endpoint descriptors' bEndpointAddress field.
/// It's also one of three fields in control requests bRequestType.
#define USB_DIR_OUT     0
/// USB directions, to host
/// This bit flag is used in endpoint descriptors' bEndpointAddress field.
/// It's also one of three fields in control requests bRequestType.
#define USB_DIR_IN      0x80

/// USB types, the second of three bRequestType fields
#define USB_TYPE_MASK       (0x03 << 5)
/// USB types, the second of three bRequestType fields
#define USB_TYPE_STANDARD   (0x00 << 5)
/// USB types, the second of three bRequestType fields
#define USB_TYPE_CLASS      (0x01 << 5)
/// USB types, the second of three bRequestType fields
#define USB_TYPE_VENDOR     (0x02 << 5)
/// USB types, the second of three bRequestType fields
#define USB_TYPE_RESERVED   (0x03 << 5)

/// USB recipients, the third of three bRequestType fields
#define USB_RECIP_MASK        0x1f
/// USB recipients, the third of three bRequestType fields
#define USB_RECIP_DEVICE      0x00
/// USB recipients, the third of three bRequestType fields
#define USB_RECIP_INTERFACE   0x01
/// USB recipients, the third of three bRequestType fields
#define USB_RECIP_ENDPOINT    0x02
/// USB recipients, the third of three bRequestType fields
#define USB_RECIP_OTHER       0x03

/*
 * Standard requests, for the bRequest field of a SETUP packet.
 *
 * These are qualified by the bRequestType field, so that for example
 * TYPE_CLASS or TYPE_VENDOR specific feature flags could be retrieved
 * by a GET_STATUS request.
 */
#define USB_REQ_GET_STATUS    0x00
#define USB_REQ_CLEAR_FEATURE   0x01
#define USB_REQ_SET_FEATURE   0x03
#define USB_REQ_SET_ADDRESS   0x05
#define USB_REQ_GET_DESCRIPTOR    0x06
#define USB_REQ_SET_DESCRIPTOR    0x07
#define USB_REQ_GET_CONFIGURATION 0x08
#define USB_REQ_SET_CONFIGURATION 0x09
#define USB_REQ_GET_INTERFACE   0x0A
#define USB_REQ_SET_INTERFACE   0x0B
#define USB_REQ_SYNCH_FRAME   0x0C

/// Wireless USB
#define USB_REQ_SET_ENCRYPTION    0x0D/

#define USB_REQ_GET_ENCRYPTION    0x0E
#define USB_REQ_SET_HANDSHAKE   0x0F
#define USB_REQ_GET_HANDSHAKE   0x10
#define USB_REQ_SET_CONNECTION    0x11
#define USB_REQ_SET_SECURITY_DATA 0x12
#define USB_REQ_GET_SECURITY_DATA 0x13
#define USB_REQ_SET_WUSB_DATA   0x14
#define USB_REQ_LOOPBACK_DATA_WRITE 0x15
#define USB_REQ_LOOPBACK_DATA_READ  0x16
#define USB_REQ_SET_INTERFACE_DS  0x17

/*
 * USB feature flags are written using USB_REQ_{CLEAR,SET}_FEATURE, and
 * are read as a bit array returned by USB_REQ_GET_STATUS.  (So there
 * are at most sixteen features of each type.)
 */
/// (read only)
#define USB_DEVICE_SELF_POWERED   0

/// dev may initiate wakeup
#define USB_DEVICE_REMOTE_WAKEUP  1

/// (wired high speed only)
#define USB_DEVICE_TEST_MODE      2

/// (wireless)
#define USB_DEVICE_BATTERY        2

/// (otg) dev may initiate HNP
#define USB_DEVICE_B_HNP_ENABLE   3

/// (wireless
#define USB_DEVICE_WUSB_DEVICE    3

/// (otg) RH port supports HNP
#define USB_DEVICE_A_HNP_SUPPORT  4

/// (otg) other RH port does
#define USB_DEVICE_A_ALT_HNP_SUPPORT  5

/// (special devices only)
#define USB_DEVICE_DEBUG_MODE     6






/// IN/OUT will STALL
#define USB_ENDPOINT_HALT   0


#define USB_SETUP_PACKET_SIZE 8

/**
 * SETUP data for a USB device control request
 *
 * This structure is used to send control requests to a USB device.  It matches
 * the different fields of the USB 2.0 Spec section 9.3, table 9-2.  See the
 * USB spec for a fuller description of the different fields, and what they are
 * used for.
 *
 * Note that the driver for any interface can issue control requests.
 * For most devices, interfaces don't coordinate with each other, so
 * such requests may be made at any time.
 */
struct usb_ctrlrequest {
        /// matches the USB bmRequestType field
        __u8  bRequestType;

        /// matches the USB bRequest field
        __u8  bRequest;

        /// matches the USB wValue field (le16 byte order)
        __u16 wValue;

        /// matches the USB wIndex field (le16 byte order)
        __u16 wIndex;

        /// matches the USB wLength field (le16 byte order)
        __u16 wLength;
}  __attribute__ ((packed));
typedef struct usb_ctrlrequest usb_ctrlrequest_t;


/*
 * STANDARD DESCRIPTORS ... as returned by GET_DESCRIPTOR, or
 * (rarely) accepted by SET_DESCRIPTOR.
 *
 * Note that all multi-byte values here are encoded in little endian
 * byte order "on the wire".  But when exposed through Linux-USB APIs,
 * they've been converted to cpu byte order.
 */

/*
 * Descriptor types ... USB 2.0 spec table 9.5
 */
#define USB_DT_DEVICE     0x01
#define USB_DT_CONFIG     0x02
#define USB_DT_STRING     0x03
#define USB_DT_INTERFACE    0x04
#define USB_DT_ENDPOINT     0x05
#define USB_DT_DEVICE_QUALIFIER   0x06
#define USB_DT_OTHER_SPEED_CONFIG 0x07
#define USB_DT_INTERFACE_POWER    0x08
/* these are from a minor usb 2.0 revision (ECN) */
#define USB_DT_OTG      0x09
#define USB_DT_DEBUG      0x0a
#define USB_DT_INTERFACE_ASSOCIATION  0x0b
/* these are from the Wireless USB spec */
#define USB_DT_SECURITY     0x0c
#define USB_DT_KEY      0x0d
#define USB_DT_ENCRYPTION_TYPE    0x0e
#define USB_DT_BOS      0x0f
#define USB_DT_DEVICE_CAPABILITY  0x10
#define USB_DT_WIRELESS_ENDPOINT_COMP 0x11

/// conventional codes for class-specific descriptors
#define USB_DT_CS_DEVICE    0x21
/// conventional codes for class-specific descriptors
#define USB_DT_CS_CONFIG    0x22
/// conventional codes for class-specific descriptors
#define USB_DT_CS_STRING    0x23
/// conventional codes for class-specific descriptors
#define USB_DT_CS_INTERFACE   0x24
/// conventional codes for class-specific descriptors
#define USB_DT_CS_ENDPOINT    0x25

/** All standard descriptors have these 2 fields at the beginning */
struct usb_descriptor_header {
        __u8  bLength;
        __u8  bDescriptorType;
} __attribute__ ((packed));
typedef struct usb_descriptor_header usb_descriptor_header_t;



/** USB_DT_DEVICE: Device descriptor */
struct usb_device_descriptor {
        __u8  bLength;
        __u8  bDescriptorType;
        __u16 bcdUSB;
        __u8  bDeviceClass;
        __u8  bDeviceSubClass;
        __u8  bDeviceProtocol;
        __u8  bMaxPacketSize0;
        __u16 idVendor;
        __u16 idProduct;
        __u16 bcdDevice;
        __u8  iManufacturer;
        __u8  iProduct;
        __u8  iSerialNumber;
        __u8  bNumConfigurations;
} __attribute__ ((packed));
typedef struct usb_device_descriptor usb_device_descriptor_t;

#define USB_DT_DEVICE_SIZE    18


/*
 * Device and/or Interface Class codes
 * as found in bDeviceClass or bInterfaceClass
 * and defined by www.usb.org documents
 */
/// for DeviceClass
#define USB_CLASS_PER_INTERFACE   0

#define USB_CLASS_AUDIO     1
#define USB_CLASS_COMM      2
#define USB_CLASS_HID     3
#define USB_CLASS_PHYSICAL    5
#define USB_CLASS_STILL_IMAGE   6
#define USB_CLASS_PRINTER   7
#define USB_CLASS_MASS_STORAGE    8
#define USB_CLASS_HUB     9
#define USB_CLASS_CDC_DATA    0x0a

/// chip+ smart card
#define USB_CLASS_CSCID     0x0b

/// content security
#define USB_CLASS_CONTENT_SEC   0x0d

#define USB_CLASS_VIDEO     0x0e
#define USB_CLASS_WIRELESS_CONTROLLER 0xe0
#define USB_CLASS_MISC			0xef
#define USB_CLASS_APP_SPEC    0xfe
#define USB_CLASS_VENDOR_SPEC   0xff


/**
 * USB_DT_CONFIG: Configuration descriptor information.
 *
 * USB_DT_OTHER_SPEED_CONFIG is the same descriptor, except that the
 * descriptor type is different.  Highspeed-capable devices can look
 * different depending on what speed they're currently running.  Only
 * devices with a USB_DT_DEVICE_QUALIFIER have any OTHER_SPEED_CONFIG
 * descriptors.
 */
struct usb_config_descriptor {
        __u8  bLength;
        __u8  bDescriptorType;
        __u16 wTotalLength;
        __u8  bNumInterfaces;
        __u8  bConfigurationValue;
        __u8  iConfiguration;
        __u8  bmAttributes;
        __u8  bMaxPower;

} __attribute__ ((packed));
//typedef struct usb_config_descriptor usb_config_descriptor_t;

#define USB_DT_CONFIG_SIZE    9

/* from config descriptor bmAttributes */
/// from config descriptor bmAttributes: must be set
#define USB_CONFIG_ATT_ONE    (1 << 7)

/// from config descriptor bmAttributes: self powered
#define USB_CONFIG_ATT_SELFPOWER  (1 << 6)

/// from config descriptor bmAttributes: can wakeup
#define USB_CONFIG_ATT_WAKEUP   (1 << 5)

/// from config descriptor bmAttributes: battery powered
#define USB_CONFIG_ATT_BATTERY    (1 << 4)


/** USB_DT_STRING: String descriptor */
struct usb_string_descriptor {
        __u8  bLength;
        __u8  bDescriptorType;

        /// UTF-16LE encoded
        __u16 wData[1];
} __attribute__ ((packed));
typedef struct usb_string_descriptor usb_string_descriptor_t;

/*
 * note that "string" zero is special, it holds language codes that
 * the device supports, not Unicode characters.
 */


/** USB_DT_INTERFACE: Interface descriptor */
struct usb_interface_descriptor {
        __u8  bLength;
        __u8  bDescriptorType;
        __u8  bInterfaceNumber;
        __u8  bAlternateSetting;
        __u8  bNumEndpoints;
        __u8  bInterfaceClass;
        __u8  bInterfaceSubClass;
        __u8  bInterfaceProtocol;
        __u8  iInterface;

        struct usb_endpoint_descriptor *endpoint;

        /// Extra descriptors
        unsigned char *extra;

        int extralen;
} __attribute__ ((packed));
typedef struct usb_interface_descriptor usb_interface_descriptor_t;

#if 0
typedef struct usb_interface {
        struct usb_interface_descriptor *altsetting;

        int act_altsetting;             /* active alternate setting */
        int num_altsetting;             /* number of alternate settings */
        int max_altsetting;             /* total memory allocated */

        void *private_data;
} usb_interface_t;
#endif

#define USB_DT_INTERFACE_SIZE   9


/** USB_DT_ENDPOINT: Endpoint descriptor */
struct usb_endpoint_descriptor {
        __u8  bLength;
        __u8  bDescriptorType;

        __u8  bEndpointAddress;
        __u8  bmAttributes;
        __u16 wMaxPacketSize;
        __u8  bInterval;

        /// NOTE:  these two are _only_ in audio endpoints.
        /// use USB_DT_ENDPOINT*_SIZE in bLength, not sizeof.
        __u8  bRefresh;
        __u8  bSynchAddress;

        /// Extra descriptors

        unsigned char *extra;
        int extralen;
} __attribute__ ((packed));
typedef struct usb_endpoint_descriptor usb_endpoint_descriptor_t;

#define USB_DT_ENDPOINT_SIZE    7

/// Audio extension
#define USB_DT_ENDPOINT_AUDIO_SIZE  9


/*
 * Endpoints Macro
 */
/// in bEndpointAddress
#define USB_ENDPOINT_NUMBER_MASK  0x0f

#define USB_ENDPOINT_DIR_MASK   0x80

/// in bmAttributes
#define USB_ENDPOINT_XFERTYPE_MASK  0x03

#define USB_ENDPOINT_XFER_CONTROL 0
#define USB_ENDPOINT_XFER_ISOC    1
#define USB_ENDPOINT_XFER_BULK    2
#define USB_ENDPOINT_XFER_INT   3
#define USB_ENDPOINT_MAX_ADJUSTABLE 0x80



/** USB_DT_DEVICE_QUALIFIER: Device Qualifier descriptor */
struct usb_qualifier_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  __le16 bcdUSB;
  __u8  bDeviceClass;
  __u8  bDeviceSubClass;
  __u8  bDeviceProtocol;
  __u8  bMaxPacketSize0;
  __u8  bNumConfigurations;
  __u8  bRESERVED;
} __attribute__ ((packed));



/** USB_DT_OTG (from OTG 1.0a supplement) */
struct usb_otg_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  /// support for HNP, SRP, etc
  __u8  bmAttributes;
} __attribute__ ((packed));

/// from usb_otg_descriptor.bmAttributes
#define USB_OTG_SRP   (1 << 0)
/// swap host/device roles
#define USB_OTG_HNP   (1 << 1)


/** USB_DT_DEBUG:  for special highspeed devices, replacing serial console */
struct usb_debug_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  /// bulk endpoints with 8 byte maxpacket
  __u8  bDebugInEndpoint;
  __u8  bDebugOutEndpoint;
};


/** USB_DT_INTERFACE_ASSOCIATION: groups interfaces */
struct usb_interface_assoc_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  __u8  bFirstInterface;
  __u8  bInterfaceCount;
  __u8  bFunctionClass;
  __u8  bFunctionSubClass;
  __u8  bFunctionProtocol;
  __u8  iFunction;
};



/**
 * USB_DT_SECURITY:  group of wireless security descriptors, including
 * encryption types available for setting up a CC/association.
 */
struct usb_security_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  __le16 wTotalLength;
  __u8  bNumEncryptionTypes;
};


/**
 * USB_DT_KEY:  used with {GET,SET}_SECURITY_DATA; only public keys
 * may be retrieved.
 */
struct usb_key_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  __u8  tTKID[3];
  __u8  bReserved;
  __u8  bKeyData[0];
};


/** USB_DT_ENCRYPTION_TYPE:  bundled in DT_SECURITY groups */
struct usb_encryption_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  __u8  bEncryptionType;
#define USB_ENC_TYPE_UNSECURE   0

/// non-wireless mode
#define USB_ENC_TYPE_WIRED    1

/// aes128/cbc session
#define USB_ENC_TYPE_CCM_1    2

/// rsa3072/sha1 auth
#define USB_ENC_TYPE_RSA_1    3

  /// use in SET_ENCRYPTION
  __u8  bEncryptionValue;

  __u8  bAuthKeyIndex;
};



/** USB_DT_BOS:  group of wireless capabilities */
struct usb_bos_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  __le16 wTotalLength;
  __u8  bNumDeviceCaps;
};


/** USB_DT_DEVICE_CAPABILITY:  grouped with BOS */
struct usb_dev_cap_header {
  __u8  bLength;
  __u8  bDescriptorType;
  __u8  bDevCapabilityType;
};

#define USB_CAP_TYPE_WIRELESS_USB 1

/** Ultra Wide Band */
struct usb_wireless_cap_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;
  __u8  bDevCapabilityType;

  __u8  bmAttributes;
#define USB_WIRELESS_P2P_DRD    (1 << 1)
#define USB_WIRELESS_BEACON_MASK  (3 << 2)
#define USB_WIRELESS_BEACON_SELF  (1 << 2)
#define USB_WIRELESS_BEACON_DIRECTED  (2 << 2)
#define USB_WIRELESS_BEACON_NONE  (3 << 2)

  /// bit rates, Mbps
  __le16 wPHYRates;

/// always set
#define USB_WIRELESS_PHY_53   (1 << 0)

#define USB_WIRELESS_PHY_80   (1 << 1)

/// always set
#define USB_WIRELESS_PHY_107    (1 << 2)

#define USB_WIRELESS_PHY_160    (1 << 3)

/// always set
#define USB_WIRELESS_PHY_200    (1 << 4)

#define USB_WIRELESS_PHY_320    (1 << 5)
#define USB_WIRELESS_PHY_400    (1 << 6)
#define USB_WIRELESS_PHY_480    (1 << 7)

  /// TFI power levels
  __u8  bmTFITXPowerInfo;

  /// FFI power levels
  __u8  bmFFITXPowerInfo;

  __le16 bmBandGroup;
  __u8  bReserved;
};


/**
 * USB_DT_WIRELESS_ENDPOINT_COMP:  companion descriptor associated with
 * each endpoint descriptor for a wireless device
 */
struct usb_wireless_ep_comp_descriptor {
  __u8  bLength;
  __u8  bDescriptorType;

  __u8  bMaxBurst;
  __u8  bMaxSequence;
  __le16 wMaxStreamDelay;
  __le16 wOverTheAirPacketSize;
  __u8  bOverTheAirInterval;
  __u8  bmCompAttributes;

/// in bmCompAttributes
#define USB_ENDPOINT_SWITCH_MASK  0x03

#define USB_ENDPOINT_SWITCH_NO    0
#define USB_ENDPOINT_SWITCH_SWITCH  1
#define USB_ENDPOINT_SWITCH_SCALE 2
};


/**
 * USB_REQ_SET_HANDSHAKE is a four-way handshake used between a wireless
 * host and a device for connection set up, mutual authentication, and
 * exchanging short lived session keys.  The handshake depends on a CC.
 */
struct usb_handshake {
  __u8 bMessageNumber;
  __u8 bStatus;
  __u8 tTKID[3];
  __u8 bReserved;
  __u8 CDID[16];
  __u8 nonce[16];
  __u8 MIC[8];
};


/**
 * USB_REQ_SET_CONNECTION modifies or revokes a connection context (CC).
 * A CC may also be set up using non-wireless secure channels (including
 * wired USB!), and some devices may support CCs with multiple hosts.
 */
struct usb_connection_context {
  /// persistent host id
  __u8 CHID[16];

  /// device id (unique w/in host context)
  __u8 CDID[16];

  /// connection key
  __u8 CK[16];
};



/** USB 2.0 defines three speeds, here's how Linux identifies them */

enum usb_device_speed {
  USB_SPEED_UNKNOWN = 0,      /** enumerating */
  USB_SPEED_LOW, USB_SPEED_FULL,    /** usb 1.1 */
  USB_SPEED_HIGH,       /** usb 2.0 */
  USB_SPEED_VARIABLE,     /** wireless (usb 2.5) */
};

/**
 * USB device state
 */
enum usb_device_state {
  /** NOTATTACHED isn't in the USB spec, and this state acts
   * the same as ATTACHED ... but it's clearer this way.
   */
  USB_STATE_NOTATTACHED = 0,

  /** the chapter 9 device states */
  USB_STATE_ATTACHED,
  USB_STATE_POWERED,
  USB_STATE_DEFAULT,     /** limited function */
  USB_STATE_ADDRESS,
  USB_STATE_CONFIGURED,  /** most functions */

  USB_STATE_SUSPENDED    /** Note: there are actually four different SUSPENDED
                             states, returning to POWERED, DEFAULT, ADDRESS, or
                             CONFIGURED respectively when SOF tokens flow again.
                         */
};


/*@}*/
#endif  /* __LINUX_USB_CH9_H */

