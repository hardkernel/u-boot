/*
 * (C) Copyright 2008 - 2009
 * Windriver, <www.windriver.com>
 * Tom Rix <Tom.Rix@windriver.com>
 *
 * Copyright 2011 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
 *
 * Copyright 2014 Linaro, Ltd.
 * Rob Herring <robh@kernel.org>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#include <config.h>
#include <common.h>
#include <console.h>
#include <errno.h>
#include <fastboot.h>
#include <malloc.h>
#include <linux/usb/ch9.h>
#include <linux/usb/gadget.h>
#include <linux/usb/composite.h>
#include <linux/compiler.h>
#include <u-boot/sha256.h>
#include <version.h>
#include <g_dnl.h>
#include <fs.h>
#include <android_avb/avb_ops_user.h>
#include <android_avb/rk_avb_ops_user.h>
#include <dm/uclass.h>
#include <power/fuel_gauge.h>
#ifdef CONFIG_FASTBOOT_FLASH_MMC_DEV
#include <fb_mmc.h>
#endif
#ifdef CONFIG_FASTBOOT_FLASH_NAND_DEV
#include <fb_nand.h>
#endif
#ifdef CONFIG_OPTEE_CLIENT
#include <optee_include/OpteeClientInterface.h>
#endif
#include <boot_rkimg.h>
#include <optee_include/tee_client_api.h>

#define FASTBOOT_VERSION		"0.4"

#define FASTBOOT_INTERFACE_CLASS	0xff
#define FASTBOOT_INTERFACE_SUB_CLASS	0x42
#define FASTBOOT_INTERFACE_PROTOCOL	0x03

#define RX_ENDPOINT_MAXIMUM_PACKET_SIZE_2_0  (0x0200)
#define RX_ENDPOINT_MAXIMUM_PACKET_SIZE_1_1  (0x0040)
#define TX_ENDPOINT_MAXIMUM_PACKET_SIZE      (0x0040)

#define EP_BUFFER_SIZE			4096
#define SLEEP_COUNT 20000
/*
 * EP_BUFFER_SIZE must always be an integral multiple of maxpacket size
 * (64 or 512 or 1024), else we break on certain controllers like DWC3
 * that expect bulk OUT requests to be divisible by maxpacket size.
 */

struct f_fastboot {
	struct usb_function usb_function;

	/* IN/OUT EP's and corresponding requests */
	struct usb_ep *in_ep, *out_ep;
	struct usb_request *in_req, *out_req;
};

static inline struct f_fastboot *func_to_fastboot(struct usb_function *f)
{
	return container_of(f, struct f_fastboot, usb_function);
}

static struct f_fastboot *fastboot_func;
static unsigned int download_size;
static unsigned int download_bytes;
static unsigned int upload_size;
static unsigned int upload_bytes;
static bool start_upload;
static unsigned intthread_wakeup_needed;

static struct usb_endpoint_descriptor fs_ep_in = {
	.bLength            = USB_DT_ENDPOINT_SIZE,
	.bDescriptorType    = USB_DT_ENDPOINT,
	.bEndpointAddress   = USB_DIR_IN,
	.bmAttributes       = USB_ENDPOINT_XFER_BULK,
	.wMaxPacketSize     = cpu_to_le16(64),
};

static struct usb_endpoint_descriptor fs_ep_out = {
	.bLength		= USB_DT_ENDPOINT_SIZE,
	.bDescriptorType	= USB_DT_ENDPOINT,
	.bEndpointAddress	= USB_DIR_OUT,
	.bmAttributes		= USB_ENDPOINT_XFER_BULK,
	.wMaxPacketSize		= cpu_to_le16(64),
};

static struct usb_endpoint_descriptor hs_ep_in = {
	.bLength		= USB_DT_ENDPOINT_SIZE,
	.bDescriptorType	= USB_DT_ENDPOINT,
	.bEndpointAddress	= USB_DIR_IN,
	.bmAttributes		= USB_ENDPOINT_XFER_BULK,
	.wMaxPacketSize		= cpu_to_le16(512),
};

static struct usb_endpoint_descriptor hs_ep_out = {
	.bLength		= USB_DT_ENDPOINT_SIZE,
	.bDescriptorType	= USB_DT_ENDPOINT,
	.bEndpointAddress	= USB_DIR_OUT,
	.bmAttributes		= USB_ENDPOINT_XFER_BULK,
	.wMaxPacketSize		= cpu_to_le16(512),
};

static struct usb_interface_descriptor interface_desc = {
	.bLength		= USB_DT_INTERFACE_SIZE,
	.bDescriptorType	= USB_DT_INTERFACE,
	.bInterfaceNumber	= 0x00,
	.bAlternateSetting	= 0x00,
	.bNumEndpoints		= 0x02,
	.bInterfaceClass	= FASTBOOT_INTERFACE_CLASS,
	.bInterfaceSubClass	= FASTBOOT_INTERFACE_SUB_CLASS,
	.bInterfaceProtocol	= FASTBOOT_INTERFACE_PROTOCOL,
};

static struct usb_descriptor_header *fb_fs_function[] = {
	(struct usb_descriptor_header *)&interface_desc,
	(struct usb_descriptor_header *)&fs_ep_in,
	(struct usb_descriptor_header *)&fs_ep_out,
};

static struct usb_descriptor_header *fb_hs_function[] = {
	(struct usb_descriptor_header *)&interface_desc,
	(struct usb_descriptor_header *)&hs_ep_in,
	(struct usb_descriptor_header *)&hs_ep_out,
	NULL,
};

static struct usb_endpoint_descriptor *
fb_ep_desc(struct usb_gadget *g, struct usb_endpoint_descriptor *fs,
	    struct usb_endpoint_descriptor *hs)
{
	if (gadget_is_dualspeed(g) && g->speed == USB_SPEED_HIGH)
		return hs;
	return fs;
}

/*
 * static strings, in UTF-8
 */
static const char fastboot_name[] = "Android Fastboot";

static struct usb_string fastboot_string_defs[] = {
	[0].s = fastboot_name,
	{  }			/* end of list */
};

static struct usb_gadget_strings stringtab_fastboot = {
	.language	= 0x0409,	/* en-us */
	.strings	= fastboot_string_defs,
};

static struct usb_gadget_strings *fastboot_strings[] = {
	&stringtab_fastboot,
	NULL,
};

static void rx_handler_command(struct usb_ep *ep, struct usb_request *req);
static int strcmp_l1(const char *s1, const char *s2);
static void wakeup_thread(void)
{
	intthread_wakeup_needed = false;
}

static void busy_indicator(void)
{
	static int state;

	switch (state) {
	case 0:
		puts("\r|"); break;
	case 1:
		puts("\r/"); break;
	case 2:
		puts("\r-"); break;
	case 3:
		puts("\r\\"); break;
	case 4:
		puts("\r|"); break;
	case 5:
		puts("\r/"); break;
	case 6:
		puts("\r-"); break;
	case 7:
		puts("\r\\"); break;
	default:
		state = 0;
	}
	if (state++ == 8)
		state = 0;
}

static int sleep_thread(void)
{
	int rc = 0;
	int i = 0, k = 0;

	/* Wait until a signal arrives or we are woken up */
	for (;;) {
		if (!intthread_wakeup_needed)
			break;

		if (++i == SLEEP_COUNT) {
			busy_indicator();
			i = 0;
			k++;
		}

		if (k == 10) {
			/* Handle CTRL+C */
			if (ctrlc())
				return -EPIPE;

			/* Check cable connection */
			if (!g_dnl_board_usb_cable_connected())
				return -EIO;

			k = 0;
		}

		usb_gadget_handle_interrupts(0);
	}
	intthread_wakeup_needed = true;
	return rc;
}

static void fastboot_complete(struct usb_ep *ep, struct usb_request *req)
{
	int status = req->status;

	wakeup_thread();
	if (!status)
		return;
	printf("status: %d ep '%s' trans: %d\n", status, ep->name, req->actual);
}

static int fastboot_bind(struct usb_configuration *c, struct usb_function *f)
{
	int id;
	struct usb_gadget *gadget = c->cdev->gadget;
	struct f_fastboot *f_fb = func_to_fastboot(f);
	const char *s;

	/* DYNAMIC interface numbers assignments */
	id = usb_interface_id(c, f);
	if (id < 0)
		return id;
	interface_desc.bInterfaceNumber = id;

	id = usb_string_id(c->cdev);
	if (id < 0)
		return id;
	fastboot_string_defs[0].id = id;
	interface_desc.iInterface = id;

	f_fb->in_ep = usb_ep_autoconfig(gadget, &fs_ep_in);
	if (!f_fb->in_ep)
		return -ENODEV;
	f_fb->in_ep->driver_data = c->cdev;

	f_fb->out_ep = usb_ep_autoconfig(gadget, &fs_ep_out);
	if (!f_fb->out_ep)
		return -ENODEV;
	f_fb->out_ep->driver_data = c->cdev;

	f->descriptors = fb_fs_function;

	if (gadget_is_dualspeed(gadget)) {
		/* Assume endpoint addresses are the same for both speeds */
		hs_ep_in.bEndpointAddress = fs_ep_in.bEndpointAddress;
		hs_ep_out.bEndpointAddress = fs_ep_out.bEndpointAddress;
		/* copy HS descriptors */
		f->hs_descriptors = fb_hs_function;
	}

	s = env_get("serial#");
	if (s)
		g_dnl_set_serialnumber((char *)s);

	return 0;
}

static void fastboot_unbind(struct usb_configuration *c, struct usb_function *f)
{
	memset(fastboot_func, 0, sizeof(*fastboot_func));
}

static void fastboot_disable(struct usb_function *f)
{
	struct f_fastboot *f_fb = func_to_fastboot(f);

	usb_ep_disable(f_fb->out_ep);
	usb_ep_disable(f_fb->in_ep);

	if (f_fb->out_req) {
		free(f_fb->out_req->buf);
		usb_ep_free_request(f_fb->out_ep, f_fb->out_req);
		f_fb->out_req = NULL;
	}
	if (f_fb->in_req) {
		free(f_fb->in_req->buf);
		usb_ep_free_request(f_fb->in_ep, f_fb->in_req);
		f_fb->in_req = NULL;
	}
}

static struct usb_request *fastboot_start_ep(struct usb_ep *ep)
{
	struct usb_request *req;

	req = usb_ep_alloc_request(ep, 0);
	if (!req)
		return NULL;

	req->length = EP_BUFFER_SIZE;
	req->buf = memalign(CONFIG_SYS_CACHELINE_SIZE, EP_BUFFER_SIZE);
	if (!req->buf) {
		usb_ep_free_request(ep, req);
		return NULL;
	}

	memset(req->buf, 0, req->length);
	return req;
}

static int fastboot_set_alt(struct usb_function *f,
			    unsigned interface, unsigned alt)
{
	int ret;
	struct usb_composite_dev *cdev = f->config->cdev;
	struct usb_gadget *gadget = cdev->gadget;
	struct f_fastboot *f_fb = func_to_fastboot(f);
	const struct usb_endpoint_descriptor *d;

	debug("%s: func: %s intf: %d alt: %d\n",
	      __func__, f->name, interface, alt);

	d = fb_ep_desc(gadget, &fs_ep_out, &hs_ep_out);
	ret = usb_ep_enable(f_fb->out_ep, d);
	if (ret) {
		puts("failed to enable out ep\n");
		return ret;
	}

	f_fb->out_req = fastboot_start_ep(f_fb->out_ep);
	if (!f_fb->out_req) {
		puts("failed to alloc out req\n");
		ret = -EINVAL;
		goto err;
	}
	f_fb->out_req->complete = rx_handler_command;

	d = fb_ep_desc(gadget, &fs_ep_in, &hs_ep_in);
	ret = usb_ep_enable(f_fb->in_ep, d);
	if (ret) {
		puts("failed to enable in ep\n");
		goto err;
	}

	f_fb->in_req = fastboot_start_ep(f_fb->in_ep);
	if (!f_fb->in_req) {
		puts("failed alloc req in\n");
		ret = -EINVAL;
		goto err;
	}
	f_fb->in_req->complete = fastboot_complete;

	ret = usb_ep_queue(f_fb->out_ep, f_fb->out_req, 0);
	if (ret)
		goto err;

	return 0;
err:
	fastboot_disable(f);
	return ret;
}

static int fastboot_add(struct usb_configuration *c)
{
	struct f_fastboot *f_fb = fastboot_func;
	int status;

	debug("%s: cdev: 0x%p\n", __func__, c->cdev);

	if (!f_fb) {
		f_fb = memalign(CONFIG_SYS_CACHELINE_SIZE, sizeof(*f_fb));
		if (!f_fb)
			return -ENOMEM;

		fastboot_func = f_fb;
		memset(f_fb, 0, sizeof(*f_fb));
	}

	f_fb->usb_function.name = "f_fastboot";
	f_fb->usb_function.bind = fastboot_bind;
	f_fb->usb_function.unbind = fastboot_unbind;
	f_fb->usb_function.set_alt = fastboot_set_alt;
	f_fb->usb_function.disable = fastboot_disable;
	f_fb->usb_function.strings = fastboot_strings;

	status = usb_add_function(c, &f_fb->usb_function);
	if (status) {
		free(f_fb);
		fastboot_func = f_fb;
	}

	return status;
}
DECLARE_GADGET_BIND_CALLBACK(usb_dnl_fastboot, fastboot_add);

static int fastboot_tx_write(const char *buffer, unsigned int buffer_size)
{
	struct usb_request *in_req = fastboot_func->in_req;
	int ret;

	memcpy(in_req->buf, buffer, buffer_size);
	in_req->length = buffer_size;

	usb_ep_dequeue(fastboot_func->in_ep, in_req);

	ret = usb_ep_queue(fastboot_func->in_ep, in_req, 0);
	if (ret)
		printf("Error %d on queue\n", ret);
	return 0;
}

static int fastboot_tx_write_str(const char *buffer)
{
	int ret;

	ret = sleep_thread();
	if (ret < 0)
		printf("warning: 0x%x, usb transmission is abnormal!\n", ret);

	return fastboot_tx_write(buffer, strlen(buffer));
}

static void compl_do_reset(struct usb_ep *ep, struct usb_request *req)
{
	do_reset(NULL, 0, 0, NULL);
}

int __weak fb_set_reboot_flag(void)
{
	return -ENOSYS;
}

static void cb_reboot(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;
	if (!strcmp_l1("reboot-bootloader", cmd)) {
		if (fb_set_reboot_flag()) {
			fastboot_tx_write_str("FAILCannot set reboot flag");
			return;
		}
	}
	fastboot_func->in_req->complete = compl_do_reset;
	fastboot_tx_write_str("OKAY");
}

static int strcmp_l1(const char *s1, const char *s2)
{
	if (!s1 || !s2)
		return -1;
	return strncmp(s1, s2, strlen(s1));
}

static void cb_getvar(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;
	char response[FASTBOOT_RESPONSE_LEN];
	const char *s;
	size_t chars_left;

	strcpy(response, "OKAY");
	chars_left = sizeof(response) - strlen(response) - 1;

	strsep(&cmd, ":");
	if (!cmd) {
		pr_err("missing variable");
		fastboot_tx_write_str("FAILmissing var");
		return;
	}

	if (!strcmp_l1("version", cmd)) {
		strncat(response, FASTBOOT_VERSION, chars_left);
	} else if (!strcmp_l1("bootloader-version", cmd)) {
		strncat(response, U_BOOT_VERSION, chars_left);
	} else if (!strcmp_l1("product", cmd)) {
		strncat(response, CONFIG_SYS_BOARD, chars_left);
	} else if (!strcmp_l1("variant", cmd)) {
		strncat(response, "userdebug", chars_left);
	} else if (!strcmp_l1("secure", cmd)) {
		strncat(response, "no", chars_left);
	} else if (!strcmp_l1("unlocked", cmd)) {
		strncat(response, "yes", chars_left);
	} else if (!strcmp_l1("off-mode-charge", cmd)) {
		strncat(response, "0", chars_left);
	} else if (!strcmp_l1("battery-voltage", cmd)) {
		strncat(response, "7.4", chars_left);
	} else if (!strcmp_l1("battery-soc-ok", cmd)) {
		strncat(response, "yes", chars_left);
	} else if (!strcmp_l1("downloadsize", cmd) ||
		!strcmp_l1("max-download-size", cmd)) {
		char str_num[12];

		sprintf(str_num, "0x%08x", CONFIG_FASTBOOT_BUF_SIZE);
		strncat(response, str_num, chars_left);
	} else if (!strcmp_l1("serialno", cmd)) {
		s = env_get("serial#");
		if (s)
			strncat(response, s, chars_left);
		else
			strcpy(response, "FAILValue not set");
	} else if (strncmp("at-attest-dh", cmd, 12) == 0) {
#ifdef CONFIG_OPTEE_CLIENT
		char dhbuf[8];
		uint32_t dh_len = 8;
		uint32_t res = trusty_attest_dh((uint8_t *)dhbuf, &dh_len);
		if (res)
			strcpy(response, "FAILdh not set");
		else
			strncat(response, dhbuf, chars_left);
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (strncmp("at-attest-uuid", cmd, 14) == 0) {
#ifdef CONFIG_OPTEE_CLIENT
		char uuid[32] = {0};
		uint32_t uuid_len = 32;
		uint32_t res = trusty_attest_uuid((uint8_t *)uuid, &uuid_len);
		if (res)
			strcpy(response, "FAILuuid not set");
		else
			strncat(response, uuid, chars_left);
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (strncmp("at-vboot-state", cmd, 14) == 0) {
		char uuid[32] = {0};

		strncat(response, uuid, chars_left);
	} else if (!strcmp_l1("slot-count", cmd)) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		char slot_count[2];
		char temp;

		slot_count[1] = '\0';
		rk_avb_read_slot_count(&temp);
		slot_count[0] = temp + 0x30;
		strncat(response, slot_count, chars_left);
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (!strcmp_l1("current-slot", cmd)) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		char slot_surrent[8] = {0};

		if (!rk_avb_get_current_slot(slot_surrent))
			strncat(response, slot_surrent+1, chars_left);
		else
			strcpy(response, "FAILgeterror");
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (!strcmp_l1("slot-suffixes", cmd)) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		char slot_suffixes_temp[4];
		char slot_suffixes[9];
		int slot_cnt = 0;

		memset(slot_suffixes_temp, 0, 4);
		memset(slot_suffixes, 0, 9);
		rk_avb_read_slot_suffixes(slot_suffixes_temp);
		while (slot_suffixes_temp[slot_cnt] != '\0') {
			slot_suffixes[slot_cnt * 2]
				= slot_suffixes_temp[slot_cnt];
			slot_suffixes[slot_cnt * 2 + 1] = ',';
			slot_cnt++;
		}
		strncat(response, slot_suffixes, chars_left);
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (!strncmp("has-slot", cmd, 8)) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		char *part_name = cmd;

		cmd = strsep(&part_name, ":");
		if (!strcmp(part_name, "boot") ||
		    !strcmp(part_name, "system") ||
		    !strcmp(part_name, "vendor") ||
		    !strcmp(part_name, "vbmeta") ||
		    !strcmp(part_name, "oem")) {
			strncat(response, "yes", chars_left);
		} else {
			strcpy(response, "FAILno");
		}
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (!strncmp("slot-unbootable", cmd, 15)) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		char *slot_name = cmd;

		cmd = strsep(&slot_name, ":");
		if (!strcmp(slot_name, "a") ||
		    !strcmp(slot_name, "b")) {
			strncat(response, "no", chars_left);
		} else {
			strcpy(response, "FAILno");
		}
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (!strncmp("slot-successful", cmd, 15)) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		char *slot_name = cmd;

		cmd = strsep(&slot_name, ":");
		if (!strcmp(slot_name, "a") ||
		    !strcmp(slot_name, "b")) {
			strncat(response, "no", chars_left);
		} else {
			strcpy(response, "FAILno");
		}
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (!strncmp("slot-retry-count", cmd, 16)) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		char *slot_name = cmd;
		char count[10] = {0};
		static int cnt[2] = {0};

		cmd = strsep(&slot_name, ":");
		if (!strcmp(slot_name, "a")) {
			sprintf(count, "%c", 0x30+cnt[0]);
			strncat(response, count, chars_left);
			if (cnt[0] > 0)
				cnt[0]--;
		} else if (!strcmp(slot_name, "b")) {
			sprintf(count, "%c", 0x30+cnt[1]);
			strncat(response, count, chars_left);
			if (cnt[1] > 0)
				cnt[1]--;
		} else {
			strcpy(response, "FAILno");
		}
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (!strncmp("partition-type", cmd, 14) ||
		   !strncmp("partition-size", cmd, 14)) {
		disk_partition_t part_info;
		struct blk_desc *dev_desc;
		char *part_name = cmd;
		char part_size_str[20];

		cmd = strsep(&part_name, ":");
		dev_desc = blk_get_dev("mmc", 0);
		if (!dev_desc) {
			strcpy(response, "FAILblock device not found");
		} else if (part_get_info_by_name(dev_desc, part_name, &part_info) < 0) {
			strcpy(response, "FAILpartition not found");
		} else if (!strncmp("partition-type", cmd, 14)) {
			strncat(response, (char *)part_info.type, chars_left);
		} else if (!strncmp("partition-size", cmd, 14)) {
			sprintf(part_size_str, "0x%016x", (int)part_info.size);
			strncat(response, part_size_str, chars_left);
		}
	} else if (!strncmp("oem-unlock", cmd, 10)) {
#ifdef CONFIG_FASTBOOT_OEM_UNLOCK
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		fastboot_tx_write_str("FAILnot implemented");
		return;
#else

		char msg[50] = {0};
		uint8_t unlock = 0;
		TEEC_Result result;

		result = trusty_read_oem_unlock(&unlock);
		if (result) {
			printf("read oem unlock status with error : 0x%x\n", result);
			fastboot_tx_write_str("FAILRead oem unlock status failed");
			return;
		}
		sprintf(msg, "Device is %s, Status Code: %d\n",
			unlock == 0 ? "LOCKED" : "UNLOCKED", unlock);

		printf(msg);
		strncat(response, msg, chars_left);
#endif
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else {
		char *envstr;

		envstr = malloc(strlen("fastboot.") + strlen(cmd) + 1);
		if (!envstr) {
			fastboot_tx_write_str("FAILmalloc error");
			return;
		}

		sprintf(envstr, "fastboot.%s", cmd);
		s = env_get(envstr);
		if (s) {
			strncat(response, s, chars_left);
		} else {
			printf("WARNING: unknown variable: %s\n", cmd);
			strcpy(response, "FAILVariable not implemented");
		}

		free(envstr);
	}
	fastboot_tx_write_str(response);
}

static unsigned int rx_bytes_expected(struct usb_ep *ep)
{
	int rx_remain = download_size - download_bytes;
	unsigned int rem;
	unsigned int maxpacket = ep->maxpacket;

	if (rx_remain <= 0)
		return 0;
	else if (rx_remain > EP_BUFFER_SIZE)
		return EP_BUFFER_SIZE;

	/*
	 * Some controllers e.g. DWC3 don't like OUT transfers to be
	 * not ending in maxpacket boundary. So just make them happy by
	 * always requesting for integral multiple of maxpackets.
	 * This shouldn't bother controllers that don't care about it.
	 */
	rem = rx_remain % maxpacket;
	if (rem > 0)
		rx_remain = rx_remain + (maxpacket - rem);

	return rx_remain;
}

#define BYTES_PER_DOT	0x20000
static void rx_handler_dl_image(struct usb_ep *ep, struct usb_request *req)
{
	char response[FASTBOOT_RESPONSE_LEN];
	unsigned int transfer_size = download_size - download_bytes;
	const unsigned char *buffer = req->buf;
	unsigned int buffer_size = req->actual;
	unsigned int pre_dot_num, now_dot_num;

	if (req->status != 0) {
		printf("Bad status: %d\n", req->status);
		return;
	}

	if (buffer_size < transfer_size)
		transfer_size = buffer_size;

	memcpy((void *)CONFIG_FASTBOOT_BUF_ADDR + download_bytes,
	       buffer, transfer_size);

	pre_dot_num = download_bytes / BYTES_PER_DOT;
	download_bytes += transfer_size;
	now_dot_num = download_bytes / BYTES_PER_DOT;

	if (pre_dot_num != now_dot_num) {
		putc('.');
		if (!(now_dot_num % 74))
			putc('\n');
	}

	/* Check if transfer is done */
	if (download_bytes >= download_size) {
		/*
		 * Reset global transfer variable, keep download_bytes because
		 * it will be used in the next possible flashing command
		 */
		download_size = 0;
		req->complete = rx_handler_command;
		req->length = EP_BUFFER_SIZE;

		strcpy(response, "OKAY");
		fastboot_tx_write_str(response);

		printf("\ndownloading of %d bytes finished\n", download_bytes);
	} else {
		req->length = rx_bytes_expected(ep);
	}

	req->actual = 0;
	usb_ep_queue(ep, req, 0);
}

static void cb_download(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;
	char response[FASTBOOT_RESPONSE_LEN];

	strsep(&cmd, ":");
	download_size = simple_strtoul(cmd, NULL, 16);
	download_bytes = 0;

	printf("Starting download of %d bytes\n", download_size);

	if (0 == download_size) {
		strcpy(response, "FAILdata invalid size");
	} else if (download_size > CONFIG_FASTBOOT_BUF_SIZE) {
		download_size = 0;
		strcpy(response, "FAILdata too large");
	} else {
		sprintf(response, "DATA%08x", download_size);
		req->complete = rx_handler_dl_image;
		req->length = rx_bytes_expected(ep);
	}

	fastboot_tx_write_str(response);
}

static void tx_handler_ul(struct usb_ep *ep, struct usb_request *req)
{
	unsigned int xfer_size = 0;
	unsigned int pre_dot_num, now_dot_num;
	unsigned int remain_size = 0;
	unsigned int transferred_size = req->actual;

	if (req->status != 0) {
		printf("Bad status: %d\n", req->status);
		return;
	}

	if (start_upload) {
		pre_dot_num = upload_bytes / BYTES_PER_DOT;
		upload_bytes += transferred_size;
		now_dot_num = upload_bytes / BYTES_PER_DOT;

		if (pre_dot_num != now_dot_num) {
			putc('.');
			if (!(now_dot_num % 74))
				putc('\n');
		}
	}

	remain_size = upload_size - upload_bytes;
	xfer_size = (remain_size > EP_BUFFER_SIZE) ?
		    EP_BUFFER_SIZE : remain_size;

	debug("%s: remain_size=%d, transferred_size=%d",
	      __func__, remain_size, transferred_size);
	debug("xfer_size=%d, upload_bytes=%d, upload_size=%d!\n",
	      xfer_size, upload_bytes, upload_size);

	if (remain_size <= 0) {
		fastboot_func->in_req->complete = fastboot_complete;
		wakeup_thread();
		fastboot_tx_write_str("OKAY");
		printf("\nuploading of %d bytes finished\n", upload_bytes);
		upload_bytes = 0;
		upload_size = 0;
		start_upload = false;
		return;
	}

	/* Remove the transfer callback which response the upload */
	/* request from host */
	if (!upload_bytes)
		start_upload = true;

	fastboot_tx_write((char *)((phys_addr_t)CONFIG_FASTBOOT_BUF_ADDR + \
			  upload_bytes),
			  xfer_size);
}

static void cb_upload(struct usb_ep *ep, struct usb_request *req)
{
	char response[FASTBOOT_RESPONSE_LEN];

	printf("Starting upload of %d bytes\n", upload_size);

	if (0 == upload_size) {
		strcpy(response, "FAILdata invalid size");
	} else {
		start_upload = false;
		sprintf(response, "DATA%08x", upload_size);
		fastboot_func->in_req->complete = tx_handler_ul;
	}

	fastboot_tx_write_str(response);
}

static void do_bootm_on_complete(struct usb_ep *ep, struct usb_request *req)
{
	char boot_addr_start[12];
	char *bootm_args[] = { "bootm", boot_addr_start, NULL };

	puts("Booting kernel..\n");

	sprintf(boot_addr_start, "0x%lx", (long)CONFIG_FASTBOOT_BUF_ADDR);
	do_bootm(NULL, 0, 2, bootm_args);

	/* This only happens if image is somehow faulty so we start over */
	do_reset(NULL, 0, 0, NULL);
}

static void cb_boot(struct usb_ep *ep, struct usb_request *req)
{
	fastboot_func->in_req->complete = do_bootm_on_complete;
	fastboot_tx_write_str("OKAY");
}

static void do_exit_on_complete(struct usb_ep *ep, struct usb_request *req)
{
	g_dnl_trigger_detach();
}

static void cb_continue(struct usb_ep *ep, struct usb_request *req)
{
	fastboot_func->in_req->complete = do_exit_on_complete;
	fastboot_tx_write_str("OKAY");
}

static void cb_set_active(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;

	debug("%s: %s\n", __func__, cmd);

	strsep(&cmd, ":");
	if (!cmd) {
		pr_err("missing slot name");
		fastboot_tx_write_str("FAILmissing slot name");
		return;
	}
#ifdef CONFIG_RK_AVB_LIBAVB_USER
	unsigned int slot_number;
	if (strncmp("a", cmd, 1) == 0) {
		slot_number = 0;
		rk_avb_set_slot_active(&slot_number);
	} else if (strncmp("b", cmd, 1) == 0) {
		slot_number = 1;
		rk_avb_set_slot_active(&slot_number);
	} else {
		fastboot_tx_write_str("FAILunkown slot name");
		return;
	}

	fastboot_tx_write_str("OKAY");
	return;
#else
	fastboot_tx_write_str("FAILnot implemented");
	return;
#endif
}

#ifdef CONFIG_FASTBOOT_FLASH
static void cb_flash(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;
	char response[FASTBOOT_RESPONSE_LEN] = {0};
#ifdef CONFIG_RK_AVB_LIBAVB_USER
	uint8_t flash_lock_state;

	if (rk_avb_read_flash_lock_state(&flash_lock_state)) {
		/* write the device flashing unlock when first read */
		if (rk_avb_write_flash_lock_state(1)) {
			fastboot_tx_write_str("FAILflash lock state write failure");
			return;
		}
		if (rk_avb_read_flash_lock_state(&flash_lock_state)) {
			fastboot_tx_write_str("FAILflash lock state read failure");
			return;
		}
	}

	if (flash_lock_state == 0) {
		fastboot_tx_write_str("FAILThe device is locked, can not flash!");
		printf("The device is locked, can not flash!\n");
		return;
	}
#endif
	strsep(&cmd, ":");
	if (!cmd) {
		pr_err("missing partition name");
		fastboot_tx_write_str("FAILmissing partition name");
		return;
	}

	fastboot_fail("no flash device defined", response);
#ifdef CONFIG_FASTBOOT_FLASH_MMC_DEV
	fb_mmc_flash_write(cmd, (void *)CONFIG_FASTBOOT_BUF_ADDR,
				download_bytes, response);
#endif
#ifdef CONFIG_FASTBOOT_FLASH_NAND_DEV
	fb_nand_flash_write(cmd, (void *)CONFIG_FASTBOOT_BUF_ADDR,
				download_bytes, response);
#endif
	fastboot_tx_write_str(response);
}

static void cb_flashing(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;

	if (strncmp("lock", cmd + 9, 4) == 0) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		uint8_t flash_lock_state;
		flash_lock_state = 0;
		if (rk_avb_write_flash_lock_state(flash_lock_state))
			fastboot_tx_write_str("FAILflash lock state"
					      " write failure");
		else
			fastboot_tx_write_str("OKAY");
#else
		fastboot_tx_write_str("FAILnot implemented");
#endif
	} else if (strncmp("unlock", cmd + 9, 6) == 0) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		uint8_t flash_lock_state;
		flash_lock_state = 1;
		if (rk_avb_write_flash_lock_state(flash_lock_state))
			fastboot_tx_write_str("FAILflash lock state"
					      " write failure");
		else
			fastboot_tx_write_str("OKAY");
#else
		fastboot_tx_write_str("FAILnot implemented");
#endif
	} else if (strncmp("lock_critical", cmd + 9, 12) == 0) {
		fastboot_tx_write_str("FAILnot implemented");
	} else if (strncmp("unlock_critical", cmd + 9, 14) == 0) {
		fastboot_tx_write_str("FAILnot implemented");
	} else if (strncmp("get_unlock_ability", cmd + 9, 17) == 0) {
		fastboot_tx_write_str("FAILnot implemented");
	} else if (strncmp("get_unlock_bootloader_nonce", cmd + 4, 27) == 0) {
		fastboot_tx_write_str("FAILnot implemented");
	} else if (strncmp("unlock_bootloader", cmd + 9, 17) == 0) {
		fastboot_tx_write_str("FAILnot implemented");
	} else if (strncmp("lock_bootloader", cmd + 9, 15) == 0) {
		fastboot_tx_write_str("FAILnot implemented");
	} else {
		fastboot_tx_write_str("FAILunknown flashing command");
	}
}
#endif

static void cb_oem_perm_attr(void)
{
#ifdef CONFIG_RK_AVB_LIBAVB_USER
	sha256_context ctx;
	uint8_t digest[SHA256_SUM_LEN] = {0};
	uint8_t digest_temp[SHA256_SUM_LEN] = {0};
	uint8_t perm_attr_temp[PERM_ATTR_TOTAL_SIZE] = {0};
	uint8_t flag = 0;

	if (PERM_ATTR_TOTAL_SIZE != download_bytes) {
		printf("Permanent attribute size is not equal!\n");
		fastboot_tx_write_str("FAILincorrect perm attribute size");
		return;
	}

	if (rk_avb_read_perm_attr_flag(&flag)) {
		printf("rk_avb_read_perm_attr_flag error!\n");
		fastboot_tx_write_str("FAILperm attr read failed");
		return;
	}

	if (flag == PERM_ATTR_SUCCESS_FLAG) {
		if (rk_avb_read_attribute_hash(digest_temp,
					       SHA256_SUM_LEN)) {
			printf("The efuse IO can not be used!\n");
			fastboot_tx_write_str("FAILefuse IO can not be used");
			return;
		}

		if (memcmp(digest, digest_temp, SHA256_SUM_LEN) != 0) {
			if (rk_avb_read_permanent_attributes(perm_attr_temp,
							     PERM_ATTR_TOTAL_SIZE)) {
				printf("rk_avb_write_permanent_attributes error!\n");
				fastboot_tx_write_str("FAILread perm attr error");
				return;
			}

			sha256_starts(&ctx);
			sha256_update(&ctx,
				      (const uint8_t *)perm_attr_temp,
				      PERM_ATTR_TOTAL_SIZE);
			sha256_finish(&ctx, digest);
			if (memcmp(digest, digest_temp, SHA256_SUM_LEN) == 0) {
				printf("The hash has been written!\n");
				fastboot_tx_write_str("OKAY");
				return;
			}
		}

		if (rk_avb_write_perm_attr_flag(0)) {
			fastboot_tx_write_str("FAILperm attr flag write failure");
			return;
		}
	}

	if (rk_avb_write_permanent_attributes((uint8_t *)
					      CONFIG_FASTBOOT_BUF_ADDR,
					      download_bytes)) {
		if (rk_avb_write_perm_attr_flag(0)) {
			fastboot_tx_write_str("FAILperm attr flag write failure");
			return;
		}
		fastboot_tx_write_str("FAILperm attr write failed");
		return;
	}

	memset(digest, 0, SHA256_SUM_LEN);
	sha256_starts(&ctx);
	sha256_update(&ctx, (const uint8_t *)CONFIG_FASTBOOT_BUF_ADDR,
		      PERM_ATTR_TOTAL_SIZE);
	sha256_finish(&ctx, digest);

	if (rk_avb_write_attribute_hash((uint8_t *)digest,
					SHA256_SUM_LEN)) {
		if (rk_avb_read_attribute_hash(digest_temp,
						SHA256_SUM_LEN)) {
			printf("The efuse IO can not be used!\n");
			fastboot_tx_write_str("FAILefuse IO can not be used");
			return;
		}
		if (memcmp(digest, digest_temp, SHA256_SUM_LEN) != 0) {
			if (rk_avb_write_perm_attr_flag(0)) {
				fastboot_tx_write_str("FAILperm attr flag write failure");
				return;
			}
			printf("The hash has been written, but is different!\n");
			fastboot_tx_write_str("FAILhash comparison failure");
			return;
		}
	}

	if (rk_avb_write_perm_attr_flag(PERM_ATTR_SUCCESS_FLAG)) {
		fastboot_tx_write_str("FAILperm attr flag write failure");
		return;
	}

	fastboot_tx_write_str("OKAY");
#else
	fastboot_tx_write_str("FAILnot implemented");
#endif
}

static void cb_oem(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;

#ifdef CONFIG_FASTBOOT_FLASH_MMC_DEV
	if (strncmp("format", cmd + 4, 6) == 0) {
		char cmdbuf[32];
		sprintf(cmdbuf, "gpt write mmc %x $partitions",
			CONFIG_FASTBOOT_FLASH_MMC_DEV);
		if (run_command(cmdbuf, 0))
			fastboot_tx_write_str("FAILmmc write failure");
		else
			fastboot_tx_write_str("OKAY");
	} else
#endif
	if (strncmp("unlock", cmd + 4, 8) == 0) {
#ifdef CONFIG_FASTBOOT_OEM_UNLOCK
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		fastboot_tx_write_str("FAILnot implemented");
		return;
#else
		uint8_t unlock = 0;
		TEEC_Result result;
		debug("oem unlock\n");
		result = trusty_read_oem_unlock(&unlock);
		if (result) {
			printf("read oem unlock status with error : 0x%x\n", result);
			fastboot_tx_write_str("FAILRead oem unlock status failed");
			return;
		}
		if (unlock) {
			printf("oem unlock ignored, device already unlocked\n");
			fastboot_tx_write_str("FAILalready unlocked");
			return;
		}
		printf("oem unlock requested:\n");
		printf("\tUnlocking forces a factory reset and could\n");
		printf("\topen your device up to a world of hurt.  If you\n");
		printf("\tare sure you know what you're doing, then accept\n");
		printf("\tvia 'fastboot oem unlock_accept'.\n");
		env_set("unlock", "unlock");
		fastboot_tx_write_str("OKAY");
#endif
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (strncmp("unlock_accept", cmd + 4, 13) == 0) {
#ifdef CONFIG_FASTBOOT_OEM_UNLOCK
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		fastboot_tx_write_str("FAILnot implemented");
		return;
#else
		char *unlock = env_get("unlock");
		TEEC_Result result;
		debug("oem unlock_accept\n");
		if (unlock == NULL || strncmp("unlock", unlock, 6) != 0) {
			printf("oem unlock_accept ignored, not pending\n");
			fastboot_tx_write_str("FAILoem unlock not requested");
			return;
		}
		env_set("unlock", "");
		printf("Erasing userdata partition\n");
		struct blk_desc *dev_desc;
		disk_partition_t part_info;
		dev_desc = rockchip_get_bootdev();
		if (!dev_desc) {
			printf("%s: dev_desc is NULL!\n", __func__);
			return;
		}
		int ret = part_get_info_by_name(dev_desc, "userdata",
				&part_info);
		if (ret < 0) {
			printf("not found userdata partition");
			printf("Erase failed with error %d\n", ret);
			fastboot_tx_write_str("FAILErasing userdata failed");
			return;
		}
		ret = blk_derase(dev_desc, part_info.start, part_info.size);
		if (ret != part_info.size) {
			printf("Erase failed with error %d\n", ret);
			fastboot_tx_write_str("FAILErasing userdata failed");
			return;
		}
		printf("Erasing succeeded\n");

		result = trusty_write_oem_unlock(1);
		if (result) {
			printf("write oem unlock status with error : 0x%x\n", result);
			fastboot_tx_write_str("FAILWrite oem unlock status failed");
			return;
		}
		fastboot_tx_write_str("OKAY");

		/*
		 * now reboot into recovery to do a format of the
		 * userdata partition so it's ready to use on next boot
		 */
		board_run_recovery_wipe_data();
#endif
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (strncmp("lock", cmd + 4, 8) == 0) {
#ifdef CONFIG_FASTBOOT_OEM_UNLOCK
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		fastboot_tx_write_str("FAILnot implemented");
		return;
#else
		TEEC_Result result;
		uint8_t unlock = 0;
		trusty_read_oem_unlock(&unlock);
		if (!unlock) {
			printf("oem lock ignored, already locked\n");
			fastboot_tx_write_str("FAILalready locked");
			return;
		}

		result = trusty_write_oem_unlock(0);
		if (result) {
			printf("write oem unlock status with error : 0x%x\n", result);
			fastboot_tx_write_str("FAILWrite oem unlock status failed");
			return;
		}
		fastboot_tx_write_str("OKAY");
#endif
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (strncmp("at-get-ca-request", cmd + 4, 17) == 0) {
#ifdef CONFIG_OPTEE_CLIENT
		uint8_t out[ATTEST_CA_OUT_SIZE];
		uint32_t operation_size = download_bytes;
		uint32_t out_len = ATTEST_CA_OUT_SIZE;
		uint32_t res = 0;

		res = trusty_attest_get_ca((uint8_t *)CONFIG_FASTBOOT_BUF_ADDR,
					   &operation_size, out, &out_len);
		if (res) {
			fastboot_tx_write_str("FAILtrusty_attest_get_ca failed");
			return;
		}
		upload_size = out_len;
		memcpy((void *)CONFIG_FASTBOOT_BUF_ADDR, out, out_len);
		fastboot_tx_write_str("OKAY");
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (strncmp("at-set-ca-response", cmd + 4, 18) == 0) {
#ifdef CONFIG_OPTEE_CLIENT
		uint32_t ca_response_size = download_bytes;
		uint32_t res = 0;

		res = trusty_attest_set_ca((uint8_t *)CONFIG_FASTBOOT_BUF_ADDR,
					   &ca_response_size);
		if (res)
			fastboot_tx_write_str("FAILtrusty_attest_set_ca failed");
		else
			fastboot_tx_write_str("OKAY");
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (strncmp("at-get-vboot-unlock-challenge", cmd + 4, 29) == 0) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		uint32_t challenge_len = 0;
		int ret = 0;

		ret = rk_generate_unlock_challenge((void *)CONFIG_FASTBOOT_BUF_ADDR, &challenge_len);
		if (ret == 0) {
			upload_size = challenge_len;
			fastboot_tx_write_str("OKAY");
		} else {
			fastboot_tx_write_str("FAILgenerate unlock challenge fail!");
		}
#else
		fastboot_tx_write_str("FAILnot implemented");
		return;
#endif
	} else if (strncmp("at-lock-vboot", cmd + 4, 13) == 0) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		uint8_t lock_state;
		lock_state = 0;
		if (rk_avb_write_lock_state(lock_state))
			fastboot_tx_write_str("FAILwrite lock state failed");
		else
			fastboot_tx_write_str("OKAY");
#else
		fastboot_tx_write_str("FAILnot implemented");
#endif
	} else if (strncmp("at-unlock-vboot", cmd + 4, 15) == 0) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		uint8_t lock_state;
		char out_is_trusted;

		if (rk_avb_read_lock_state(&lock_state))
			fastboot_tx_write_str("FAILlock sate read failure");
		if (lock_state >> 1 == 1) {
			fastboot_tx_write_str("FAILThe vboot is disable!");
		} else {
			lock_state = 1;
			if (rk_auth_unlock((void *)CONFIG_FASTBOOT_BUF_ADDR,
					   &out_is_trusted)) {
				printf("rk_auth_unlock ops error!\n");
				fastboot_tx_write_str("FAILrk_auth_unlock ops error!");
				return;
			}
			if (out_is_trusted == true) {
				if (rk_avb_write_lock_state(lock_state))
					fastboot_tx_write_str("FAILwrite lock state failed");
				else
					fastboot_tx_write_str("OKAY");
			} else {
				fastboot_tx_write_str("FAILauthenticated unlock fail");
			}
		}
#else
		fastboot_tx_write_str("FAILnot implemented");
#endif
	} else if (strncmp("at-disable-unlock-vboot", cmd + 4, 23) == 0) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		uint8_t lock_state;
		lock_state = 2;
		if (rk_avb_write_lock_state(lock_state))
			fastboot_tx_write_str("FAILwrite lock state failed");
		else
			fastboot_tx_write_str("OKAY");
#else
		fastboot_tx_write_str("FAILnot implemented");
#endif
	} else if (strncmp("fuse at-perm-attr", cmd + 4, 16) == 0) {
		cb_oem_perm_attr();
	} else if (strncmp("fuse at-bootloader-vboot-key", cmd + 4, 27) == 0) {
#ifdef CONFIG_RK_AVB_LIBAVB_USER
		sha256_context ctx;
		uint8_t digest[SHA256_SUM_LEN];

		if (download_bytes != VBOOT_KEY_HASH_SIZE) {
			fastboot_tx_write_str("FAILinvalid vboot key length");
			printf("The vboot key size error!\n");
			return;
		}

		sha256_starts(&ctx);
		sha256_update(&ctx, (const uint8_t *)CONFIG_FASTBOOT_BUF_ADDR,
			      VBOOT_KEY_SIZE);
		sha256_finish(&ctx, digest);

		if (rk_avb_write_vbootkey_hash((uint8_t *)digest,
					       SHA256_SUM_LEN)) {
			fastboot_tx_write_str("FAILvbootkey hash write failure");
			return;
		}
		fastboot_tx_write_str("OKAY");
#else
		fastboot_tx_write_str("FAILnot implemented");
#endif
	} else {
		fastboot_tx_write_str("FAILunknown oem command");
	}
}

#ifdef CONFIG_FASTBOOT_FLASH
static void cb_erase(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;
	char response[FASTBOOT_RESPONSE_LEN];

	strsep(&cmd, ":");
	if (!cmd) {
		pr_err("missing partition name");
		fastboot_tx_write_str("FAILmissing partition name");
		return;
	}

	fastboot_fail("no flash device defined", response);
#ifdef CONFIG_FASTBOOT_FLASH_MMC_DEV
	fb_mmc_erase(cmd, response);
#endif
#ifdef CONFIG_FASTBOOT_FLASH_NAND_DEV
	fb_nand_erase(cmd, response);
#endif
	fastboot_tx_write_str(response);
}
#endif

struct cmd_dispatch_info {
	char *cmd;
	void (*cb)(struct usb_ep *ep, struct usb_request *req);
};

static const struct cmd_dispatch_info cmd_dispatch_info[] = {
	{
		.cmd = "reboot",
		.cb = cb_reboot,
	}, {
		.cmd = "getvar:",
		.cb = cb_getvar,
	}, {
		.cmd = "download:",
		.cb = cb_download,
	}, {
		.cmd = "upload",
		.cb = cb_upload,
	}, {
		.cmd = "boot",
		.cb = cb_boot,
	}, {
		.cmd = "continue",
		.cb = cb_continue,
	}, {
		.cmd = "set_active",
		.cb = cb_set_active,
	},
#ifdef CONFIG_FASTBOOT_FLASH
	{
		.cmd = "flashing",
		.cb = cb_flashing,
	},
	{
		.cmd = "flash",
		.cb = cb_flash,
	}, {
		.cmd = "erase",
		.cb = cb_erase,
	},
#endif
	{
		.cmd = "oem",
		.cb = cb_oem,
	},
};

static void rx_handler_command(struct usb_ep *ep, struct usb_request *req)
{
	char *cmdbuf = req->buf;
	void (*func_cb)(struct usb_ep *ep, struct usb_request *req) = NULL;
	int i;

	if (req->status != 0 || req->length == 0)
		return;

	for (i = 0; i < ARRAY_SIZE(cmd_dispatch_info); i++) {
		if (!strcmp_l1(cmd_dispatch_info[i].cmd, cmdbuf)) {
			func_cb = cmd_dispatch_info[i].cb;
			break;
		}
	}

	if (!func_cb) {
		pr_err("unknown command: %.*s", req->actual, cmdbuf);
		fastboot_tx_write_str("FAILunknown command");
	} else {
		if (req->actual < req->length) {
			u8 *buf = (u8 *)req->buf;
			buf[req->actual] = 0;
			func_cb(ep, req);
		} else {
			pr_err("buffer overflow");
			fastboot_tx_write_str("FAILbuffer overflow");
		}
	}

	*cmdbuf = '\0';
	req->actual = 0;
	usb_ep_queue(ep, req, 0);
}
