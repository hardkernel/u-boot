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
#include <asm/sizes.h>
#include <common.h>
#include <errno.h>
#include <malloc.h>
#include <linux/usb/ch9.h>
#include <linux/usb/gadget.h>
#include <linux/usb/composite.h>
#include <linux/compiler.h>
#include <version.h>
#include <g_dnl.h>
#include <environment.h>
#include <fastboot.h>

#define FASTBOOT_VERSION		"0.4"

#define FASTBOOT_INTERFACE_CLASS	0xff
#define FASTBOOT_INTERFACE_SUB_CLASS	0x42
#define FASTBOOT_INTERFACE_PROTOCOL	0x03

#if defined(CONFIG_MACH_MESON8_ODROIDC)
#define RX_ENDPOINT_MAXIMUM_PACKET_SIZE_2_0  (0x0200)
#define RX_ENDPOINT_MAXIMUM_PACKET_SIZE_1_1  (0x0040)
#define TX_ENDPOINT_MAXIMUM_PACKET_SIZE      (0x0200)
#else
#define RX_ENDPOINT_MAXIMUM_PACKET_SIZE_2_0  (0x0200)
#define RX_ENDPOINT_MAXIMUM_PACKET_SIZE_1_1  (0x0040)
#define TX_ENDPOINT_MAXIMUM_PACKET_SIZE      (0x0040)
#endif

#define EP_BUFFER_SIZE			4096

#ifndef CONFIG_ENV_BLK_PARTITION
#define CONFIG_ENV_BLK_PARTITION "environment"
#endif
#ifndef CONFIG_INFO_PARTITION
#define CONFIG_INFO_PARTITION "device_info"
#endif

#ifndef FASTBOOT_UNLOCKED_ENV_NAME
#define FASTBOOT_UNLOCKED_ENV_NAME "fastboot_unlocked"
#endif

static struct cmd_fastboot_interface priv = {
        .transfer_buffer        = (u8 *)CONFIG_FASTBOOT_TRANSFER_BUFFER,
        .transfer_buffer_size   = CONFIG_FASTBOOT_TRANSFER_BUFFER_SIZE,
};

struct f_fastboot {
	struct usb_function usb_function;

	/* IN/OUT EP's and correspoinding requests */
	struct usb_ep *in_ep, *out_ep;
	struct usb_request *in_req, *out_req;
};

static inline struct f_fastboot *func_to_fastboot(struct usb_function *f)
{
	return container_of(f, struct f_fastboot, usb_function);
}

static struct f_fastboot *fastboot_func;
static char serial_number[33];	/* what should be the length ?, 33 ? */

static struct usb_endpoint_descriptor fs_ep_in = {
	.bLength            = USB_DT_ENDPOINT_SIZE,
	.bDescriptorType    = USB_DT_ENDPOINT,
	.bEndpointAddress   = USB_DIR_IN,
	.bmAttributes       = USB_ENDPOINT_XFER_BULK,
	.wMaxPacketSize     = TX_ENDPOINT_MAXIMUM_PACKET_SIZE,
	.bInterval          = 0x00,
};

static struct usb_endpoint_descriptor fs_ep_out = {
	.bLength		= USB_DT_ENDPOINT_SIZE,
	.bDescriptorType	= USB_DT_ENDPOINT,
	.bEndpointAddress	= USB_DIR_OUT,
	.bmAttributes		= USB_ENDPOINT_XFER_BULK,
	.wMaxPacketSize		= RX_ENDPOINT_MAXIMUM_PACKET_SIZE_1_1,
	.bInterval		= 0x00,
};

static struct usb_endpoint_descriptor hs_ep_out = {
	.bLength		= USB_DT_ENDPOINT_SIZE,
	.bDescriptorType	= USB_DT_ENDPOINT,
	.bEndpointAddress	= USB_DIR_OUT,
	.bmAttributes		= USB_ENDPOINT_XFER_BULK,
	.wMaxPacketSize		= RX_ENDPOINT_MAXIMUM_PACKET_SIZE_2_0,
	.bInterval		= 0x00,
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

static struct usb_descriptor_header *fb_runtime_descs[] = {
	(struct usb_descriptor_header *)&interface_desc,
	(struct usb_descriptor_header *)&fs_ep_in,
	(struct usb_descriptor_header *)&hs_ep_out,
	NULL,
};

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

static const char info_partition_magic[] = {'I', 'n', 'f', 'o'};

static void rx_handler_command(struct usb_ep *ep, struct usb_request *req);

#define MAX_PTN (CONFIG_MAX_PARTITION_NUM - CONFIG_MIN_PARTITION_NUM + 1)

static disk_partition_t ptable[MAX_PTN];
static unsigned int pcount;

static void fastboot_complete(struct usb_ep *ep, struct usb_request *req)
{
	int status = req->status;
	if (!status)
		return;
	printf("status: %d ep '%s' trans: %d\n", status, ep->name, req->actual);
}

static int fastboot_bind(struct usb_configuration *c, struct usb_function *f)
{
	int id;
	struct usb_gadget *gadget = c->cdev->gadget;
	struct f_fastboot *f_fb = func_to_fastboot(f);

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

	hs_ep_out.bEndpointAddress = fs_ep_out.bEndpointAddress;

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

	debug("%s: func: %s intf: %d alt: %d\n",
	      __func__, f->name, interface, alt);

	/* make sure we don't enable the ep twice */
	if (gadget->speed == USB_SPEED_HIGH)
		ret = usb_ep_enable(f_fb->out_ep, &hs_ep_out);
	else
		ret = usb_ep_enable(f_fb->out_ep, &fs_ep_out);
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

	ret = usb_ep_enable(f_fb->in_ep, &fs_ep_in);
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

int fastboot_add(struct usb_configuration *c)
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
	f_fb->usb_function.hs_descriptors = fb_runtime_descs;
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

int fastboot_tx_write(const char *buffer, unsigned int buffer_size)
{
	struct usb_request *in_req = fastboot_func->in_req;
	int ret;

	memcpy(in_req->buf, buffer, buffer_size);
	in_req->length = buffer_size;
	ret = usb_ep_queue(fastboot_func->in_ep, in_req, 0);
	if (ret)
		printf("Error %d on queue\n", ret);
	return 0;
}

static int fastboot_tx_write_str(const char *buffer)
{
	return fastboot_tx_write(buffer, strlen(buffer));
}

static void compl_do_reset(struct usb_ep *ep, struct usb_request *req)
{
	do_reset(NULL, 0, 0, NULL);
}

static void cb_reboot(struct usb_ep *ep, struct usb_request *req)
{
	fastboot_func->in_req->complete = compl_do_reset;
	fastboot_tx_write_str("OKAY");
}

static int strcmp_l1(const char *s1, const char *s2)
{
	if (!s1 || !s2)
		return -1;
	return strncmp(s1, s2, strlen(s1));
}

static disk_partition_t *fastboot_flash_find_ptn(const char *name);

static void cb_getvar(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;
	const char *s;

	strcpy(priv.response, "OKAY");
	strsep(&cmd, ":");
	if (!cmd) {
		fastboot_tx_write_str("FAILmissing var");
		return;
	}

	if (!strcmp_l1("version", cmd)) {
		strncat(priv.response, FASTBOOT_VERSION, sizeof(priv.response));
	} else if (!strcmp_l1("bootloader-version", cmd)) {
		strncat(priv.response, U_BOOT_VERSION, sizeof(priv.response));
	} else if (!strcmp_l1("max-download-size", cmd)) {
		char str_num[12];
		sprintf(str_num, "0x%08x", CONFIG_FASTBOOT_TRANSFER_BUFFER_SIZE);
		strncat(priv.response, str_num, sizeof(priv.response));
	} else if (!strcmp_l1("serialno", cmd)) {
		s = getenv("serial#");
		if (s)
			strncat(priv.response, s, sizeof(priv.response));
		else
			strcpy(priv.response, "FAILValue not set");
        } else if (!strncmp("partition-type:", cmd, 15)) {
                const char *partition_name = cmd + 15;
                const char *type;

                if (!strcmp(partition_name, "all")) {
                        // TODO: List up all partitions on the board
                        sprintf(priv.response, "OKAY");
                } else {
                        type = board_fbt_get_partition_type(partition_name);
                        if (type) {
                                strncat(priv.response, type,
                                                sizeof(priv.response));
                        } else {
                                sprintf(priv.response,
                                                "FAILunknown partition %s",
                                                partition_name);
                        }
                }
        } else if (!strncmp("partition-size:", cmd, 15)) {
                const char *partition_name = cmd + 15;
                disk_partition_t *ptn;

                ptn = fastboot_flash_find_ptn(partition_name);
                if (ptn) {
                        sprintf(priv.response, "OKAY0x%016llx",
                                        (uint64_t)ptn->size * ptn->blksz);
                } else {
                        sprintf(priv.response, "FAILunknown partition %s",
                                        partition_name);
                }
	} else {
		strcpy(priv.response, "FAILVariable not implemented");
	}
	fastboot_tx_write_str(priv.response);
}

static unsigned int rx_bytes_expected(void)
{
	int rx_remain = priv.d_size - priv.d_bytes;
	if (rx_remain < 0)
		return 0;
	if (rx_remain > EP_BUFFER_SIZE)
		return EP_BUFFER_SIZE;
	return rx_remain;
}

#define BYTES_PER_DOT	0x20000
static void rx_handler_dl_image(struct usb_ep *ep, struct usb_request *req)
{
	unsigned int transfer_size = priv.d_size - priv.d_bytes;
	const unsigned char *buffer = req->buf;
	unsigned int buffer_size = req->actual;

	if (req->status != 0) {
		printf("Bad status: %d\n", req->status);
		return;
	}

	if (buffer_size < transfer_size)
		transfer_size = buffer_size;

	memcpy((void *)priv.transfer_buffer + priv.d_bytes, buffer,
                        transfer_size);

	priv.d_bytes += transfer_size;

	/* Check if transfer is done */
	if (priv.d_bytes >= priv.d_size) {
		/*
		 * Reset global transfer variable, keep priv.d_bytes because
		 * it will be used in the next possible flashing command
		 */
		priv.d_size = 0;
		req->complete = rx_handler_command;
		req->length = EP_BUFFER_SIZE;

		sprintf(priv.response, "OKAY");
		fastboot_tx_write_str(priv.response);

		printf("\ndownloading of %d bytes finished\n", priv.d_bytes);
	} else {
		req->length = rx_bytes_expected();
		if (req->length < ep->maxpacket)
			req->length = ep->maxpacket;
	}

	if (priv.d_bytes && !(priv.d_bytes % BYTES_PER_DOT)) {
		putc('.');
		if (!(priv.d_bytes % (74 * BYTES_PER_DOT)))
			putc('\n');
	}
	req->actual = 0;
	usb_ep_queue(ep, req, 0);
}

static void cb_download(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;

	strsep(&cmd, ":");

	priv.d_size = simple_strtoul(cmd, NULL, 16);
	priv.d_bytes = 0;

	printf("Starting download of %d bytes\n", priv.d_size);

	if (0 == priv.d_size) {
		sprintf(priv.response, "FAILdata invalid size");
	} else if (priv.d_size > CONFIG_FASTBOOT_TRANSFER_BUFFER_SIZE) {
		priv.d_size = 0;
		sprintf(priv.response, "FAILdata too large");
	} else {
		sprintf(priv.response, "DATA%08x", priv.d_size);
		req->complete = rx_handler_dl_image;
		req->length = rx_bytes_expected();
		if (req->length < ep->maxpacket)
			req->length = ep->maxpacket;
	}
	fastboot_tx_write_str(priv.response);
}

static void do_bootm_on_complete(struct usb_ep *ep, struct usb_request *req)
{
	char boot_addr_start[12];
	char *bootm_args[] = { "bootm", boot_addr_start, NULL };

	puts("Booting kernel..\n");

	sprintf(boot_addr_start, "0x%lx", load_addr);
	do_bootm(NULL, 0, 2, bootm_args);

	/* This only happens if image is somehow faulty so we start over */
//	do_reset(NULL, 0, 0, NULL);
}

static void cb_boot(struct usb_ep *ep, struct usb_request *req)
{
	fastboot_func->in_req->complete = do_bootm_on_complete;
	fastboot_tx_write_str("OKAY");
}

/*
 * Android style flash utilties
 */
static void set_serial_number(const char *serial_no)
{
	strncpy(serial_number, serial_no, sizeof(serial_number));
	serial_number[sizeof(serial_number) - 1] = '\0';
	priv.serial_no = serial_number;
	printf("fastboot serial_number = %s\n", serial_number);
}

static void create_serial_number(void)
{
	char *dieid = getenv("fbt_id#");

	if (dieid == NULL)
		dieid = getenv("dieid#");

	if (dieid == NULL) {
		printf("Setting serial number from constant (no dieid info)\n");
		set_serial_number("00123");
	} else {
		printf("Setting serial number from unique id\n");
		set_serial_number(dieid);
	}
}

static int is_env_partition(disk_partition_t *ptn)
{
	return !strcmp((char *)ptn->name, CONFIG_ENV_BLK_PARTITION);
}

static int is_info_partition(disk_partition_t *ptn)
{
	return !strcmp((char *)ptn->name, CONFIG_INFO_PARTITION);
}

static void cb_erase(struct usb_ep *ep, struct usb_request *req)
{
	// TODO: Implement to erase particular partition requested
	sprintf(priv.response, "OKAY");

	fastboot_tx_write_str(priv.response);
}

void fbt_add_ptn(disk_partition_t *ptn)
{
	if (pcount < MAX_PTN) {
		memcpy(ptable + pcount, ptn, sizeof(*ptn));
		pcount++;
	}
}

int fbt_load_partition_table(void)      // FIXME: should static member?
{
	disk_partition_t *info_ptn;
	unsigned int i;

	if (board_fbt_load_ptbl()) {
		printf("board_fbt_load_ptbl() failed\n");
		return -1;
	}

	/* load device info partition if it exists */
	info_ptn = fastboot_flash_find_ptn(CONFIG_INFO_PARTITION);
	if (info_ptn) {
		struct info_partition_header *info_header;
		char *name, *next_name;
		char *value;

		lbaint_t num_blks = 1;
		i = partition_read_blks(priv.dev_desc, info_ptn,
					&num_blks, priv.transfer_buffer);
		if (i) {
			printf("failed to read info partition. error=%d\n", i);
			goto no_existing_info;
		}

		/* parse the info partition read from the device */
		info_header =
			(struct info_partition_header *)priv.transfer_buffer;
		name = (char *)(info_header + 1);
		value = name;

		if (memcmp(&info_header->magic, info_partition_magic,
			   sizeof(info_partition_magic)) != 0) {
			printf("info partition magic 0x%x invalid,"
			       " assuming none\n", info_header->magic);
			goto no_existing_info;
		}
		if (info_header->num_values > FASTBOOT_MAX_NUM_DEVICE_INFO) {
			printf("info partition num values %d too large "
			       " (max %d)\n", info_header->num_values,
			       FASTBOOT_MAX_NUM_DEVICE_INFO);
			goto no_existing_info;
		}
		priv.num_device_info = info_header->num_values;
		/* the name/value pairs are in the format:
		 *    name1=value1\n
		 *    name2=value2\n
		 * this makes it easier to read if we dump the partition
		 * to a file
		 */
		printf("%d device info entries read from %s partition:\n",
		       priv.num_device_info, info_ptn->name);
		for (i = 0; i < priv.num_device_info; i++) {
			while (*value != '=')
				value++;
			*value++ = '\0';
			next_name = value;
			while (*next_name != '\n')
				next_name++;
			*next_name++ = '\0';
			priv.dev_info[i].name = strdup(name);
			priv.dev_info[i].value = strdup(value);
			printf("\t%s=%s\n", priv.dev_info[i].name,
			       priv.dev_info[i].value);
			/* initialize serial number from device info */
			if (!strcmp(name, FASTBOOT_SERIALNO_BOOTARG))
				set_serial_number(value);
			name = next_name;
		}
		priv.dev_info_uninitialized = 0;
	} else {
no_existing_info:
		priv.dev_info_uninitialized = 1;
		printf("No existing device info found.\n");
	}

	if (priv.serial_no == NULL)
		create_serial_number();

	return 0;
}

static disk_partition_t *fastboot_flash_find_ptn(const char *name)
{
	unsigned int n;

	if (pcount == 0) {
		if (fbt_load_partition_table()) {
			printf("Unable to load partition table, aborting\n");
			return NULL;
		}
	}

	for (n = 0; n < pcount; n++) {
		if (!strcmp_l1((char *)ptable[n].name, name))
			return ptable + n;
        }

	return NULL;
}

void fbt_reset_ptn(void)
{
	pcount = 0;
	if (fbt_load_partition_table())
		printf("Unable to load partition table\n");
}

static void fbt_set_unlocked(int unlocked)
{
	char *unlocked_string;

	printf("Setting device to %s\n",
	       unlocked ? "unlocked" : "locked");
	priv.unlocked = unlocked;
	if (unlocked)
		unlocked_string = "1";
	else
		unlocked_string = "0";
	setenv(FASTBOOT_UNLOCKED_ENV_NAME, unlocked_string);
#if defined(CONFIG_CMD_SAVEENV)
	saveenv();
#endif
}

void fbt_fastboot_init(void)
{
	char *fastboot_unlocked_env;

	priv.flag = 0;
	priv.d_size = 0;
	priv.d_bytes = 0;
	priv.u_size = 0;
	priv.u_bytes = 0;
	priv.exit = 0;
	priv.unlock_pending_start_time = 0;

	priv.unlocked = 1;

	fastboot_unlocked_env = getenv(FASTBOOT_UNLOCKED_ENV_NAME);
	if (fastboot_unlocked_env) {
		unsigned long unlocked;
		if (!strict_strtoul(fastboot_unlocked_env, 10, &unlocked)) {
			if (unlocked)
				priv.unlocked = 1;
			else
				priv.unlocked = 0;
		} else {
			printf("bad env setting %s of %s,"
			       " initializing to locked\n",
			       fastboot_unlocked_env,
			       FASTBOOT_UNLOCKED_ENV_NAME);
			fbt_set_unlocked(0);
		}
	} else {
		printf("no existing env setting for %s\n",
		       FASTBOOT_UNLOCKED_ENV_NAME);
		printf("creating one set to false\n");
		fbt_set_unlocked(0);
	}
	if (priv.unlocked)
		printf("Device is unlocked\n");
	else
		printf("Device is locked\n");

	priv.dev_desc = get_dev_by_name(FASTBOOT_BLKDEV);
	if (!priv.dev_desc) {
		FBTERR("%s: fastboot device %s not found\n",
						__func__, FASTBOOT_BLKDEV);
		return;
	}

	/*
	 * We need to be able to run fastboot even if there isn't a partition
	 * table (so we can use "oem format") and fbt_load_partition_table
	 * already printed an error, so just ignore the error return.
	 */
	(void)fbt_load_partition_table();
}

static int fbt_handle_erase(char *cmdbuf)
{
	disk_partition_t *ptn;
	int err;
	char *partition_name = cmdbuf + 6;
	char *num_blocks_str;
	lbaint_t num_blocks;
	lbaint_t *num_blocks_p = NULL;

	/* see if there is an optional num_blocks after the partition name */
	num_blocks_str = strchr(partition_name, ' ');
	if (num_blocks_str) {
		/* null terminate the partition name */
		*num_blocks_str = 0;
		num_blocks_str++;
		num_blocks = simple_strtoull(num_blocks_str, NULL, 10);
		num_blocks_p = &num_blocks;
	}

	ptn = fastboot_flash_find_ptn(partition_name);
	if (ptn == 0) {
		printf("Partition %s does not exist\n", partition_name);
		sprintf(priv.response, "FAILpartition does not exist");
		return -1;
	}

#ifndef CONFIG_MFG
	/* don't allow erasing environment partition or a valid
	 * device info partition in a production u-boot */
        if (is_env_partition(ptn) ||
                        (is_info_partition(ptn)
                         && (!priv.dev_info_uninitialized))) {
		printf("Not allowed to erase %s partition\n", ptn->name);
		strcpy(priv.response, "FAILnot allowed to erase partition");
		return -1;
	}
#endif

	printf("Erasing partition '%s':\n", ptn->name);

	printf("\tstart blk %lu, blk_cnt %lu of %lu\n", ptn->start,
			num_blocks_p ? num_blocks : ptn->size, ptn->size);

	err = partition_erase_blks(priv.dev_desc, ptn, num_blocks_p);
	if (err) {
		printf("Erasing '%s' FAILED! error=%d\n", ptn->name, err);
		sprintf(priv.response,
				"FAILfailed to erase partition (%d)", err);
	} else {
		printf("partition '%s' erased\n", ptn->name);
		sprintf(priv.response, "OKAY");
	}

	return 0;
}

#define SPARSE_HEADER_MAJOR_VER 1

static int _unsparse(unsigned char *source,
					lbaint_t sector, lbaint_t num_blks)
{
	sparse_header_t *header = (void *) source;
	u32 i;
	unsigned long blksz;
	u64 section_size;
	u64 outlen = 0;
	block_dev_desc_t *dev_desc;

	dev_desc= get_dev_by_name(FASTBOOT_BLKDEV);

        blksz = dev_desc->blksz;
	section_size = (u64)num_blks * blksz;

	FBTINFO("sparse_header:\n");
	FBTINFO("\t         magic=0x%08X\n", header->magic);
	FBTINFO("\t       version=%u.%u\n", header->major_version,
						header->minor_version);
	FBTINFO("\t file_hdr_size=%u\n", header->file_hdr_sz);
	FBTINFO("\tchunk_hdr_size=%u\n", header->chunk_hdr_sz);
	FBTINFO("\t        blk_sz=%u\n", header->blk_sz);
	FBTINFO("\t    total_blks=%u\n", header->total_blks);
	FBTINFO("\t  total_chunks=%u\n", header->total_chunks);
	FBTINFO("\timage_checksum=%u\n", header->image_checksum);

	if (header->magic != SPARSE_HEADER_MAGIC) {
		printf("sparse: bad magic\n");
		return 1;
	}

	if (((u64)header->total_blks * header->blk_sz) > section_size) {
		printf("sparse: section size %llu MB limit: exceeded\n",
				section_size/(1024*1024));
		return 1;
	}

	if ((header->major_version != SPARSE_HEADER_MAJOR_VER) ||
	    (header->file_hdr_sz != sizeof(sparse_header_t)) ||
	    (header->chunk_hdr_sz != sizeof(chunk_header_t))) {
		printf("sparse: incompatible format\n");
		return 1;
	}

	/* Skip the header now */
	source += header->file_hdr_sz;

	for (i = 0; i < header->total_chunks; i++) {
		u64 clen = 0;
		lbaint_t blkcnt;
		chunk_header_t *chunk = (void *) source;

		FBTINFO("chunk_header:\n");
		FBTINFO("\t    chunk_type=%u\n", chunk->chunk_type);
		FBTINFO("\t      chunk_sz=%u\n", chunk->chunk_sz);
		FBTINFO("\t      total_sz=%u\n", chunk->total_sz);
		/* move to next chunk */
		source += sizeof(chunk_header_t);

		switch (chunk->chunk_type) {
		case CHUNK_TYPE_RAW:
			clen = (u64)chunk->chunk_sz * header->blk_sz;
			FBTINFO("sparse: RAW blk=%d bsz=%d:"
			       " write(sector=%lu,clen=%llu)\n",
			       chunk->chunk_sz, header->blk_sz, sector, clen);

			if (chunk->total_sz != (clen + sizeof(chunk_header_t))) {
				printf("sparse: bad chunk size for"
				       " chunk %d, type Raw\n", i);
				return 1;
			}

			outlen += clen;
			if (outlen > section_size) {
				printf("sparse: section size %llu MB limit:"
				       " exceeded\n", section_size/(1024*1024));
				return 1;
			}
			blkcnt = clen / blksz;
			FBTDBG("sparse: RAW blk=%d bsz=%d:"
			       " write(sector=%lu,clen=%llu)\n",
			       chunk->chunk_sz, header->blk_sz, sector, clen);
			if (dev_desc->block_write(dev_desc->dev,
						       sector, blkcnt, source)
						!= blkcnt) {
				printf("sparse: block write to sector %lu"
					" of %llu bytes (%ld blkcnt) failed\n",
					sector, clen, blkcnt);
				return 1;
			}

			sector += (clen / blksz);
			source += clen;
			break;

		case CHUNK_TYPE_DONT_CARE:
			if (chunk->total_sz != sizeof(chunk_header_t)) {
				printf("sparse: bogus DONT CARE chunk\n");
				return 1;
			}
			clen = (u64)chunk->chunk_sz * header->blk_sz;
			FBTDBG("sparse: DONT_CARE blk=%d bsz=%d:"
			       " skip(sector=%lu,clen=%llu)\n",
			       chunk->chunk_sz, header->blk_sz, sector, clen);

			outlen += clen;
			if (outlen > section_size) {
				printf("sparse: section size %llu MB limit:"
				       " exceeded\n", section_size/(1024*1024));
				return 1;
			}
			sector += (clen / blksz);
			break;

		default:
			printf("sparse: unknown chunk ID %04x\n",
			       chunk->chunk_type);
			return 1;
		}
	}

	printf("sparse: out-length %llu MB\n", outlen/(1024*1024));
	return 0;
}

static int do_unsparse(disk_partition_t *ptn, unsigned char *source,
					lbaint_t sector, lbaint_t num_blks)
{
	int rtn;
	if (partition_write_pre(ptn))
		return 1;

	rtn = _unsparse(source, sector, num_blks);

	if (partition_write_post(ptn))
		return 1;

	return rtn;
}

static void cb_flash(struct usb_ep *ep, struct usb_request *req)
{
	char *cmd = req->buf;
	disk_partition_t *ptn;
	block_dev_desc_t *dev_desc;

	dev_desc = get_dev_by_name(FASTBOOT_BLKDEV);
	if (!dev_desc) {
		printf("error getting device %s\n", FASTBOOT_BLKDEV);
                return -1;
	}

	if (!dev_desc->lba) {
		printf("device %s has no space\n", FASTBOOT_BLKDEV);
                return -1;
	}

        if (0 == priv.d_bytes) {
		printf("%s: failed, no image downloaded\n", __func__);
		sprintf(priv.response, "FAILno image downloaded");
                goto done;
	}

	strsep(&cmd, ":");

	ptn = fastboot_flash_find_ptn(cmd);
	if (ptn == 0) {
		printf("%s: failed, partition %s does not exist\n",
                                __func__, cmd);
		sprintf(priv.response, "FAILpartition does not exist");
                goto done;
	}

	/* do board/cpu specific special handling if needed.  this
	 * can include modifying priv.image_start_ptr to flash from
	 * an address other than the start of the transfer buffer.
	 */
	priv.image_start_ptr = priv.transfer_buffer;

	if (board_fbt_handle_flash(ptn, &priv)) {
		/* error case, return.  expect priv.response to be
		 * set by the board specific handler.
		 */
		printf("%s: failed, board_fbt_handle_flash() error\n",
		       __func__);
                strcpy(priv.response, "FAILboard_fbt_handle_flash() error");
                goto done;
	}

	/* Prevent using flash command to write to device_info partition */
	if (is_info_partition(ptn)) {
		printf("%s: failed, partition not writable"
		       " using flash command\n",
		       __func__);
		sprintf(priv.response,
			"FAILpartition not writable using flash command");
                goto done;
	}

	/* Check if this is not really a flash write but rather a saveenv */
	if (is_env_partition(ptn)) {
		if (!himport_r(&env_htab,
			       (const char *)priv.image_start_ptr,
			       priv.d_bytes, '\n', H_NOCLEAR)) {
			FBTINFO("Import '%s' FAILED!\n", ptn->name);
			sprintf(priv.response, "FAIL: Import environment");
                        goto done;
		}

#if defined(CONFIG_CMD_SAVEENV)
		if (saveenv()) {
			printf("Writing '%s' FAILED!\n", ptn->name);
			sprintf(priv.response, "FAIL: Write partition");
			return;
		}
		printf("saveenv to '%s' DONE!\n", ptn->name);
#endif
		sprintf(priv.response, "OKAY");
	} else {
		/* Normal case */
		printf("writing to partition '%s'\n", ptn->name);

		/* Check if we have sparse compressed image */
		if (((sparse_header_t *)priv.image_start_ptr)->magic
		    == SPARSE_HEADER_MAGIC) {
			printf("fastboot: %s is in sparse format\n", ptn->name);
			if (!do_unsparse(ptn, priv.image_start_ptr,
					 ptn->start, ptn->size)) {
				printf("Writing sparsed: '%s' DONE!\n",
				       ptn->name);
				sprintf(priv.response, "OKAY");
			} else {
				printf("Writing sparsed '%s' FAILED!\n",
				       ptn->name);
				sprintf(priv.response, "FAIL: Sparsed Write");
			}
		} else {
			/* Normal image: no sparse */
			int err;
			loff_t num_bytes = (loff_t)priv.d_bytes;

			printf("Writing %llu bytes to '%s'\n",
						num_bytes, ptn->name);
			err = partition_write_bytes(dev_desc, ptn,
				&num_bytes, priv.image_start_ptr);
			if (err) {
				printf("Writing '%s' FAILED! error=%d\n",
							ptn->name, err);
				sprintf(priv.response,
					"FAILWrite partition, error=%d", err);
			} else {
				printf("Writing '%s' DONE!\n", ptn->name);
				sprintf(priv.response, "OKAY");
			}
		}
	} /* Normal Case */
done:
	fastboot_tx_write_str(priv.response);
}

static void cb_oem(struct usb_ep *ep, struct usb_request *req)
{
	const char *cmd = req->buf + 4;
        int i;

	if (!cmd) {
		fastboot_tx_write_str("FAILmissing var");
		return;
	}

        /* %fastboot oem erase partition <numblocks>
         * similar to 'fastboot erase' except an optional number
         * of blocks can be passed to erase less than the
         * full partition, for speed
         */
        if (strncmp(cmd, "erase ", 6) == 0) {
                // TODO: Implement to erase specific partiton
                FBTDBG("oem %s\n", cmd);
                fbt_handle_erase(cmd);
                goto done;
	} else {
                /* %fastboot oem [xxx] */
                if (board_fbt_oem(cmd) >= 0) {
			strcpy(priv.response, "OKAY");
                        goto done;
                }
        }

        printf("\nfastboot: unsupported oem command %s\n", cmd);
        strcpy(priv.response, "FAILinvalid command");

done:
	fastboot_tx_write_str(priv.response);
}

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
		.cmd = "boot",
		.cb = cb_boot,
        }, {
                .cmd = "erase:",
                .cb = cb_erase,
        }, {
                .cmd = "flash:",
                .cb = cb_flash,
        }, {
                .cmd = "oem ",
                .cb = cb_oem,
        }
};

static void rx_handler_command(struct usb_ep *ep, struct usb_request *req)
{
	char *cmdbuf = req->buf;
	void (*func_cb)(struct usb_ep *ep, struct usb_request *req) = NULL;
	int i;
        *(char *)(cmdbuf + req->actual) = 0;

	for (i = 0; i < ARRAY_SIZE(cmd_dispatch_info); i++) {
		if (!strcmp_l1(cmd_dispatch_info[i].cmd, cmdbuf)) {
			func_cb = cmd_dispatch_info[i].cb;
			break;
		}
	}

	if (!func_cb)
		fastboot_tx_write_str("FAILunknown command");
	else
		func_cb(ep, req);

	if (req->status == 0) {
		*cmdbuf = '\0';
		req->actual = 0;
		usb_ep_queue(ep, req, 0);
	}
}
