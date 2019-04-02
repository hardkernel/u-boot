#ifndef __LD_BTMTK_USB_H__
#define __LD_BTMTK_USB_H__

#include "LD_usbbt.h"

/* Memory map for MTK BT */
/* SYS Control */
#define SYSCTL	0x400000

/* WLAN */
#define WLAN		0x410000

/* MCUCTL */
#define CLOCK_CTL		0x0708
#define INT_LEVEL		0x0718
#define COM_REG0		0x0730
#define SEMAPHORE_00	0x07B0
#define SEMAPHORE_01	0x07B4
#define SEMAPHORE_02	0x07B8
#define SEMAPHORE_03	0x07BC

/* Chip definition */

#define CONTROL_TIMEOUT_JIFFIES		(300)
#define DEVICE_VENDOR_REQUEST_OUT	0x40
#define DEVICE_VENDOR_REQUEST_IN	0xc0
#define DEVICE_CLASS_REQUEST_OUT	0x20
#define DEVICE_CLASS_REQUEST_IN	    0xa0

#define BTUSB_MAX_ISOC_FRAMES	10
#define BTUSB_INTR_RUNNING	0
#define BTUSB_BULK_RUNNING	1
#define BTUSB_ISOC_RUNNING	2
#define BTUSB_SUSPENDING	3
#define BTUSB_DID_ISO_RESUME	4

/* ROM Patch */
#define PATCH_HCI_HEADER_SIZE 4
#define PATCH_WMT_HEADER_SIZE 5
#define PATCH_HEADER_SIZE (PATCH_HCI_HEADER_SIZE + PATCH_WMT_HEADER_SIZE)
#define UPLOAD_PATCH_UNIT 2048
#define PATCH_INFO_SIZE 30
#define PATCH_PHASE1 1
#define PATCH_PHASE2 2
#define PATCH_PHASE3 3

#define LD_BT_MAX_EVENT_SIZE 260
#define BD_ADDR_LEN 6

#define WAKE_DEV_RECORD         "wake_on_ble.conf"
#define WAKE_DEV_RECORD_PATH    "/data/misc/bluedroid"
#define WOBLE_SETTING_FILE_NAME "woble_setting.bin"
#define APCF_SETTING_COUNT      10

typedef enum {
    TYPE_APCF_CMD,
} woble_setting_type;

struct apcf_cmd_tlv {
    //u8 type
    u8 len;
    u8 *value;
};

struct LD_btmtk_usb_data {
	mtkbt_dev_t *udev;	/* store the usb device informaiton */

	unsigned long flags;
	int meta_tx;
	HC_IF	*hcif;

	u8 cmdreq_type;

	unsigned int sco_num;
	int isoc_altsetting;
	int suspend_count;

	/* request for different io operation */
	u8 w_request;
	u8 r_request;

	/* io buffer for usb control transfer */
	unsigned char *io_buf;

	unsigned char *fw_image;
	unsigned char *fw_header_image;
	unsigned char *fw_bin_file_name;

	unsigned char *rom_patch;
	unsigned char *rom_patch_header_image;
	unsigned char *rom_patch_bin_file_name;
	u32 chip_id;
	u8 need_load_fw;
	u8 need_load_rom_patch;
	u32 rom_patch_offset;
	u32 rom_patch_len;
	u32 fw_len;

	u8 local_addr[BD_ADDR_LEN];
	u8 *woble_setting;
	u32 woble_setting_len;
	u8 *wake_dev;   /* ADDR:NAP-UAP-LAP, VID/PID:Both Little endian */
	u32 wake_dev_len;
	struct apcf_cmd_tlv apcf_cmd[APCF_SETTING_COUNT];
};


int LD_btmtk_usb_probe(mtkbt_dev_t *dev);
void LD_btmtk_usb_disconnect(mtkbt_dev_t *dev);
void LD_btmtk_usb_SetWoble(mtkbt_dev_t *dev);

#define REV_MT76x2E3        0x0022

#define MT_REV_LT(_data, _chip, _rev)	\
	is_##_chip(_data) && (((_data)->chip_id & 0x0000ffff) < (_rev))

#define MT_REV_GTE(_data, _chip, _rev)	\
	is_##_chip(_data) && (((_data)->chip_id & 0x0000ffff) >= (_rev))

/*
 *  Load code method
 */
enum LOAD_CODE_METHOD {
	BIN_FILE_METHOD,
	HEADER_METHOD,
};
#endif
