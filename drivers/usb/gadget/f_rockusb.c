/*
 * Copyright 2017 Rockchip Electronics Co., Ltd
 * Frank Wang <frank.wang@rock-chips.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <asm/io.h>
#include <asm/arch/boot_mode.h>
#include <asm/arch/chip_info.h>
#include <optee_include/OpteeClientInterface.h>

#ifdef CONFIG_ROCKCHIP_VENDOR_PARTITION
#include <asm/arch/vendor.h>
#endif

#include <rockusb.h>

#define ROCKUSB_INTERFACE_CLASS	0xff
#define ROCKUSB_INTERFACE_SUB_CLASS	0x06
#define ROCKUSB_INTERFACE_PROTOCOL	0x05

static struct usb_interface_descriptor rkusb_intf_desc = {
	.bLength		= USB_DT_INTERFACE_SIZE,
	.bDescriptorType	= USB_DT_INTERFACE,
	.bInterfaceNumber	= 0x00,
	.bAlternateSetting	= 0x00,
	.bNumEndpoints		= 0x02,
	.bInterfaceClass	= ROCKUSB_INTERFACE_CLASS,
	.bInterfaceSubClass	= ROCKUSB_INTERFACE_SUB_CLASS,
	.bInterfaceProtocol	= ROCKUSB_INTERFACE_PROTOCOL,
};

static struct usb_descriptor_header *rkusb_fs_function[] = {
	(struct usb_descriptor_header *)&rkusb_intf_desc,
	(struct usb_descriptor_header *)&fsg_fs_bulk_in_desc,
	(struct usb_descriptor_header *)&fsg_fs_bulk_out_desc,
	NULL,
};

static struct usb_descriptor_header *rkusb_hs_function[] = {
	(struct usb_descriptor_header *)&rkusb_intf_desc,
	(struct usb_descriptor_header *)&fsg_hs_bulk_in_desc,
	(struct usb_descriptor_header *)&fsg_hs_bulk_out_desc,
	NULL,
};

struct rk_flash_info {
	u32	flash_size;
	u16	block_size;
	u8	page_size;
	u8	ecc_bits;
	u8	access_time;
	u8	manufacturer;
	u8	flash_mask;
} __packed;

static int rkusb_rst_code; /* The subcode in reset command (0xFF) */

int g_dnl_bind_fixup(struct usb_device_descriptor *dev, const char *name)
{
	if (IS_RKUSB_UMS_DNL(name)) {
		/* Fix to Rockchip's VID and PID */
		dev->idVendor  = __constant_cpu_to_le16(0x2207);
		dev->idProduct = __constant_cpu_to_le16(CONFIG_ROCKUSB_G_DNL_PID);

		/* Enumerate as a loader device */
		dev->bcdUSB = cpu_to_le16(0x0201);
	} else if (!strncmp(name, "usb_dnl_fastboot", 16)) {
		/* Fix to Google's VID and PID */
		dev->idVendor  = __constant_cpu_to_le16(0x18d1);
		dev->idProduct = __constant_cpu_to_le16(0xd00d);
	}

	return 0;
}

__maybe_unused
static inline void dump_cbw(struct fsg_bulk_cb_wrap *cbw)
{
	assert(!cbw);

	debug("%s:\n", __func__);
	debug("Signature %x\n", cbw->Signature);
	debug("Tag %x\n", cbw->Tag);
	debug("DataTransferLength %x\n", cbw->DataTransferLength);
	debug("Flags %x\n", cbw->Flags);
	debug("LUN %x\n", cbw->Lun);
	debug("Length %x\n", cbw->Length);
	debug("OptionCode %x\n", cbw->CDB[0]);
	debug("SubCode %x\n", cbw->CDB[1]);
	debug("SectorAddr %x\n", get_unaligned_be32(&cbw->CDB[2]));
	debug("BlkSectors %x\n\n", get_unaligned_be16(&cbw->CDB[7]));
}

static int rkusb_check_lun(struct fsg_common *common)
{
	struct fsg_lun *curlun;

	/* Check the LUN */
	if (common->lun >= 0 && common->lun < common->nluns) {
		curlun = &common->luns[common->lun];
		if (common->cmnd[0] != SC_REQUEST_SENSE) {
			curlun->sense_data = SS_NO_SENSE;
			curlun->info_valid = 0;
		}
	} else {
		curlun = NULL;
		common->bad_lun_okay = 0;

		/*
		 * INQUIRY and REQUEST SENSE commands are explicitly allowed
		 * to use unsupported LUNs; all others may not.
		 */
		if (common->cmnd[0] != SC_INQUIRY &&
		    common->cmnd[0] != SC_REQUEST_SENSE) {
			debug("unsupported LUN %d\n", common->lun);
			return -EINVAL;
		}
	}

	return 0;
}

static void __do_reset(struct usb_ep *ep, struct usb_request *req)
{
	u32 boot_flag = BOOT_NORMAL;

	if (rkusb_rst_code == 0x03)
		boot_flag = BOOT_BROM_DOWNLOAD;

	rkusb_rst_code = 0; /* restore to default */
	writel(boot_flag, (void *)CONFIG_ROCKCHIP_BOOT_MODE_REG);

	do_reset(NULL, 0, 0, NULL);
}

static int rkusb_do_reset(struct fsg_common *common,
			  struct fsg_buffhd *bh)
{
	common->data_size_from_cmnd = common->cmnd[4];
	common->residue = 0;
	bh->inreq->complete = __do_reset;
	bh->state = BUF_STATE_EMPTY;

	rkusb_rst_code = !common->cmnd[1] ? 0xff : common->cmnd[1];
	return 0;
}

static int rkusb_do_test_unit_ready(struct fsg_common *common,
				    struct fsg_buffhd *bh)
{
	common->residue = 0x06 << 24; /* Max block xfer support from host */
	common->data_dir = DATA_DIR_NONE;
	bh->state = BUF_STATE_EMPTY;

	return 0;
}

static int rkusb_do_read_flash_id(struct fsg_common *common,
				  struct fsg_buffhd *bh)
{
	u8 *buf = (u8 *)bh->buf;
	u32 len = 5;
	enum if_type type = ums[common->lun].block_dev.if_type;

	if (type == IF_TYPE_MMC)
		memcpy((void *)&buf[0], "EMMC ", 5);
	else if (type == IF_TYPE_RKNAND)
		memcpy((void *)&buf[0], "NAND ", 5);
	else
		memcpy((void *)&buf[0], "UNKN ", 5); /* unknown */

	/* Set data xfer size */
	common->residue = common->data_size_from_cmnd = len;
	common->data_size = len;

	return len;
}

static int rkusb_do_test_bad_block(struct fsg_common *common,
				   struct fsg_buffhd *bh)
{
	u8 *buf = (u8 *)bh->buf;
	u32 len = 64;

	memset((void *)&buf[0], 0, len);

	/* Set data xfer size */
	common->residue = common->data_size_from_cmnd = len;
	common->data_size = len;

	return len;
}

static int rkusb_do_read_flash_info(struct fsg_common *common,
				    struct fsg_buffhd *bh)
{
	u8 *buf = (u8 *)bh->buf;
	u32 len = sizeof(struct rk_flash_info);
	struct rk_flash_info finfo = {
		.block_size = 1024,
		.ecc_bits = 0,
		.page_size = 4,
		.access_time = 40,
		.manufacturer = 0,
		.flash_mask = 0
	};

	finfo.flash_size = (u32)ums[common->lun].block_dev.lba;
	if (finfo.flash_size)
		finfo.flash_mask = 1;

	memset((void *)&buf[0], 0, len);
	memcpy((void *)&buf[0], (void *)&finfo, len);

	/* Set data xfer size */
	common->residue = common->data_size_from_cmnd = len;
        /* legacy upgrade_tool does not set correct transfer size */
	common->data_size = len;

	return len;
}

static int rkusb_do_get_chip_info(struct fsg_common *common,
				  struct fsg_buffhd *bh)
{
	u8 *buf = (u8 *)bh->buf;
	u32 len = common->data_size;
	u32 chip_info[4];

	memset((void *)chip_info, 0, sizeof(chip_info));
	rockchip_rockusb_get_chip_info(chip_info);

	memset((void *)&buf[0], 0, len);
	memcpy((void *)&buf[0], (void *)chip_info, len);

	/* Set data xfer size */
	common->residue = common->data_size_from_cmnd = len;

	return len;
}

static int rkusb_do_lba_erase(struct fsg_common *common,
			      struct fsg_buffhd *bh)
{
	struct fsg_lun *curlun = &common->luns[common->lun];
	u32 lba, amount;
	loff_t file_offset;
	int rc;

	lba = get_unaligned_be32(&common->cmnd[2]);
	if (lba >= curlun->num_sectors) {
		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
		rc = -EINVAL;
		goto out;
	}

	file_offset = ((loff_t) lba) << 9;
	amount = get_unaligned_be16(&common->cmnd[7]) << 9;
	if (unlikely(amount == 0)) {
		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
		rc = -EIO;
		goto out;
	}

	/* Perform the erase */
	rc = ums[common->lun].erase_sector(&ums[common->lun],
			       file_offset / SECTOR_SIZE,
			       amount / SECTOR_SIZE);
	if (!rc) {
		curlun->sense_data = SS_MEDIUM_NOT_PRESENT;
		rc = -EIO;
	}

out:
	common->data_dir = DATA_DIR_NONE;
	bh->state = BUF_STATE_EMPTY;

	return rc;
}

#ifdef CONFIG_ROCKCHIP_VENDOR_PARTITION
static int rkusb_do_vs_write(struct fsg_common *common)
{
	struct fsg_lun		*curlun = &common->luns[common->lun];
	u16			type = get_unaligned_be16(&common->cmnd[4]);
	struct vendor_item	*vhead;
	struct fsg_buffhd	*bh;
	void			*data;
	int			rc;

	if (common->data_size >= (u32)65536) {
		/* _MUST_ small than 64K */
		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
		return -EINVAL;
	}

	common->residue         = common->data_size;
	common->usb_amount_left = common->data_size;

	/* Carry out the file writes */
	if (unlikely(common->data_size == 0))
		return -EIO; /* No data to write */

	for (;;) {
		if (common->usb_amount_left > 0) {
			/* Wait for the next buffer to become available */
			bh = common->next_buffhd_to_fill;
			if (bh->state != BUF_STATE_EMPTY)
				goto wait;

			/* Request the next buffer */
			common->usb_amount_left      -= common->data_size;
			bh->outreq->length	     = common->data_size;
			bh->bulk_out_intended_length = common->data_size;
			bh->outreq->short_not_ok     = 1;

			START_TRANSFER_OR(common, bulk_out, bh->outreq,
					  &bh->outreq_busy, &bh->state)
				/*
				 * Don't know what to do if
				 * common->fsg is NULL
				 */
				return -EIO;
			common->next_buffhd_to_fill = bh->next;
		} else {
			/* Then, wait for the data to become available */
			bh = common->next_buffhd_to_drain;
			if (bh->state != BUF_STATE_FULL)
				goto wait;

			common->next_buffhd_to_drain = bh->next;
			bh->state = BUF_STATE_EMPTY;

			/* Did something go wrong with the transfer? */
			if (bh->outreq->status != 0) {
				curlun->sense_data = SS_COMMUNICATION_FAILURE;
				curlun->info_valid = 1;
				break;
			}

			/* Perform the write */
			vhead = (struct vendor_item *)bh->buf;
			data  = bh->buf + sizeof(struct vendor_item);

			if (!type) {
				/* Vendor storage */
				rc = vendor_storage_write(vhead->id,
							  (char __user *)data,
							  vhead->size);
				if (rc < 0)
					return -EIO;
			} else {
				/* RPMB */
#ifdef CONFIG_OPTEE_V1
				rc =
				write_keybox_to_secure_storage((u8 *)data,
							       vhead->size);
				if (!rc)
					return -EIO;
#endif
			}

			common->residue -= common->data_size;

			/* Did the host decide to stop early? */
			if (bh->outreq->actual != bh->outreq->length)
				common->short_packet_received = 1;
			break; /* Command done */
		}
wait:
		/* Wait for something to happen */
		rc = sleep_thread(common);
		if (rc)
			return rc;
	}

	return -EIO; /* No default reply */
}

static int rkusb_do_vs_read(struct fsg_common *common)
{
	struct fsg_lun		*curlun = &common->luns[common->lun];
	u16			type = get_unaligned_be16(&common->cmnd[4]);
	struct vendor_item	*vhead;
	struct fsg_buffhd	*bh;
	void			*data;
	int			rc;

	if (common->data_size >= (u32)65536) {
		/* _MUST_ small than 64K */
		curlun->sense_data = SS_LOGICAL_BLOCK_ADDRESS_OUT_OF_RANGE;
		return -EINVAL;
	}

	common->residue         = common->data_size;
	common->usb_amount_left = common->data_size;

	/* Carry out the file reads */
	if (unlikely(common->data_size == 0))
		return -EIO; /* No default reply */

	for (;;) {
		/* Wait for the next buffer to become available */
		bh = common->next_buffhd_to_fill;
		while (bh->state != BUF_STATE_EMPTY) {
			rc = sleep_thread(common);
			if (rc)
				return rc;
		}

		memset(bh->buf, 0, FSG_BUFLEN);
		vhead = (struct vendor_item *)bh->buf;
		data  = bh->buf + sizeof(struct vendor_item);
		vhead->id = get_unaligned_be16(&common->cmnd[2]);

		if (!type) {
			/* Vendor storage */
			rc = vendor_storage_read(vhead->id,
						 (char __user *)data,
						 common->data_size);
			if (!rc)
				return -EIO;
			vhead->size = rc;
		} else {
			/* RPMB */
		}

		common->residue   -= common->data_size;
		bh->inreq->length = common->data_size;
		bh->state         = BUF_STATE_FULL;

		break; /* No more left to read */
	}

	return -EIO; /* No default reply */
}
#endif

static int rkusb_do_read_capacity(struct fsg_common *common,
				    struct fsg_buffhd *bh)
{
	u8 *buf = (u8 *)bh->buf;
	u32 len = common->data_size;
	enum if_type type = ums[common->lun].block_dev.if_type;

	/*
	 * bit[0]: Direct LBA, 0: Disabled;
	 * bit[1]: Vendor Storage API, 0: Disabed (default);
	 * bit[2]: First 4M Access, 0: Disabled;
	 * bit[3]: Read LBA On, 0: Disabed (default);
	 * bit[4]: New Vendor Storage API, 0: Disabed;
	 * bit[5:63}: Reserved.
	 */
	memset((void *)&buf[0], 0, len);
	if (type == IF_TYPE_MMC)
		buf[0] = BIT(0) | BIT(2) | BIT(4);
	else
		buf[0] = BIT(0) | BIT(4);

	/* Set data xfer size */
	common->residue = common->data_size_from_cmnd = len;

	return len;
}

static void rkusb_fixup_cbwcb(struct fsg_common *common,
			      struct fsg_buffhd *bh)
{
	struct usb_request      *req = bh->outreq;
	struct fsg_bulk_cb_wrap *cbw = req->buf;

	/* FIXME cbw.DataTransferLength was not set by Upgrade Tool */
	common->data_size = le32_to_cpu(cbw->DataTransferLength);
	if (common->data_size == 0) {
		common->data_size =
		get_unaligned_be16(&common->cmnd[7]) << 9;
		printf("Trasfer Length NOT set, please use new version tool\n");
		debug("%s %d, cmnd1 %x\n", __func__,
		      get_unaligned_be16(&common->cmnd[7]),
		      get_unaligned_be16(&common->cmnd[1]));
	}
	if (cbw->Flags & USB_BULK_IN_FLAG)
		common->data_dir = DATA_DIR_TO_HOST;
	else
		common->data_dir = DATA_DIR_FROM_HOST;

	/* Not support */
	common->cmnd[1] = 0;
}

static int rkusb_cmd_process(struct fsg_common *common,
			     struct fsg_buffhd *bh, int *reply)
{
	struct usb_request	*req = bh->outreq;
	struct fsg_bulk_cb_wrap	*cbw = req->buf;
	int rc;

	dump_cbw(cbw);

	if (rkusb_check_lun(common)) {
		*reply = -EINVAL;
		return RKUSB_RC_ERROR;
	}

	switch (common->cmnd[0]) {
	case RKUSB_TEST_UNIT_READY:
		*reply = rkusb_do_test_unit_ready(common, bh);
		rc = RKUSB_RC_FINISHED;
		break;

	case RKUSB_READ_FLASH_ID:
		*reply = rkusb_do_read_flash_id(common, bh);
		rc = RKUSB_RC_FINISHED;
		break;

	case RKUSB_TEST_BAD_BLOCK:
		*reply = rkusb_do_test_bad_block(common, bh);
		rc = RKUSB_RC_FINISHED;
		break;

	case RKUSB_LBA_READ_10:
		rkusb_fixup_cbwcb(common, bh);
		common->cmnd[0] = SC_READ_10;
		common->cmnd[1] = 0; /* Not support */
		rc = RKUSB_RC_CONTINUE;
		break;

	case RKUSB_LBA_WRITE_10:
		rkusb_fixup_cbwcb(common, bh);
		common->cmnd[0] = SC_WRITE_10;
		common->cmnd[1] = 0; /* Not support */
		rc = RKUSB_RC_CONTINUE;
		break;

	case RKUSB_READ_FLASH_INFO:
		*reply = rkusb_do_read_flash_info(common, bh);
		rc = RKUSB_RC_FINISHED;
		break;

	case RKUSB_GET_CHIP_VER:
		*reply = rkusb_do_get_chip_info(common, bh);
		rc = RKUSB_RC_FINISHED;
		break;

	case RKUSB_LBA_ERASE:
		*reply = rkusb_do_lba_erase(common, bh);
		rc = RKUSB_RC_FINISHED;
		break;

#ifdef CONFIG_ROCKCHIP_VENDOR_PARTITION
	case RKUSB_VS_WRITE:
		*reply = rkusb_do_vs_write(common);
		rc = RKUSB_RC_FINISHED;
		break;

	case RKUSB_VS_READ:
		*reply = rkusb_do_vs_read(common);
		rc = RKUSB_RC_FINISHED;
		break;
#endif

	case RKUSB_READ_CAPACITY:
		*reply = rkusb_do_read_capacity(common, bh);
		rc = RKUSB_RC_FINISHED;
		break;

	case RKUSB_RESET:
		*reply = rkusb_do_reset(common, bh);
		rc = RKUSB_RC_FINISHED;
		break;

	case RKUSB_READ_10:
	case RKUSB_WRITE_10:
		printf("CMD Not support, pls use new version Tool\n");
	case RKUSB_SET_DEVICE_ID:
	case RKUSB_ERASE_10:
	case RKUSB_WRITE_SPARE:
	case RKUSB_READ_SPARE:
	case RKUSB_ERASE_10_FORCE:
	case RKUSB_GET_VERSION:
	case RKUSB_ERASE_SYS_DISK:
	case RKUSB_SDRAM_READ_10:
	case RKUSB_SDRAM_WRITE_10:
	case RKUSB_SDRAM_EXECUTE:
	case RKUSB_LOW_FORMAT:
	case RKUSB_SET_RESET_FLAG:
	case RKUSB_SPI_READ_10:
	case RKUSB_SPI_WRITE_10:
	case RKUSB_SESSION:
		/* Fall through */
	default:
		rc = RKUSB_RC_UNKNOWN_CMND;
		break;
	}

	return rc;
}

DECLARE_GADGET_BIND_CALLBACK(rkusb_ums_dnl, fsg_add);
