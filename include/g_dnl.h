/*
 *  Copyright (C) 2012 Samsung Electronics
 *  Lukasz Majewski <l.majewski@samsung.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef __G_DOWNLOAD_H_
#define __G_DOWNLOAD_H_

#include <linux/usb/ch9.h>
#include <linux/usb/gadget.h>
#include <linux/usb/composite.h>
#include <linker_lists.h>

#define CONFIG_USB_GADGET_VBUS_DRAW 500
#define CONFIG_USB_FASTBOOT_BUF_SIZE 0xB0000000
#define CONFIG_USB_FASTBOOT_BUF_ADDR 0x10200000
#define CONFIG_G_DNL_MANUFACTURER 0123
#define CONFIG_G_DNL_PRODUCT_NUM 1234

/*
 * @usb_fname: unescaped USB function name
 * @callback_ptr: bind callback, one per function name
 */
#define DECLARE_GADGET_BIND_CALLBACK(usb_fname, callback_ptr) \
	ll_entry_declare(struct g_dnl_bind_callback, \
			__usb_function_name_##usb_fname, \
			g_dnl_bind_callbacks) = { \
				.usb_function_name = #usb_fname, \
				.fptr = callback_ptr \
			}

typedef int (*g_dnl_bind_callback_f)(struct usb_configuration *);

/* used in Gadget downloader callback linker list */
struct g_dnl_bind_callback {
	const char *usb_function_name;
	g_dnl_bind_callback_f fptr;
};

int g_dnl_bind_fixup(struct usb_device_descriptor *, const char *);
int g_dnl_board_usb_cable_connected(void);
int g_dnl_register(const char *s);
void g_dnl_unregister(void);
void g_dnl_set_serialnumber(char *);

bool g_dnl_detach(void);
void g_dnl_trigger_detach(void);
void g_dnl_clear_detach(void);

#endif /* __G_DOWNLOAD_H_ */
