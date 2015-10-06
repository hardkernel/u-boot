/*
 * common/cmd_usbd3.c
 *
 *  $Id: cmd_usbd3.c,v 1.2 2009/01/28 00:11:42 dark0351 Exp $
 *
 * (C) Copyright 2011
 * Yulgon Kim, Samsung Erectronics, bjlee@samsung.com.
 *	- support for Exynos5210
 *
 * (C) Copyright 2007
 * Byungjae Lee, Samsung Erectronics, bjlee@samsung.com.
 *	- support for S3C2412, S3C2443 and S3C6400
 *
 * (C) Copyright SAMSUNG Electronics
 *      SW.LEE  <hitchcar@samsung.com>
 *      - add USB device fo S3C2440A, S3C24A0A
 *
 * (C) Copyright 2000
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 */

/*
 * Memory Functions
 *
 * Copied from FADS ROM, Dan Malek (dmalek@jlc.net)
 */

#include <common.h>
#include <command.h>

#ifdef CONFIG_EXYNOS_USBD3

#include <asm/arch/cpu.h>

#if defined(CONFIG_S5PC510) || defined(CONFIG_S5PC220) || defined(CONFIG_ARCH_EXYNOS5)
#include "../drivers/usb/gadget/usbd3-ss.h"
#else
#error "* CFG_ERROR : you have to setup right Samsung CPU configuration"
#endif

static const char pszMe[] = "usbd: ";

int do_usbd_dnw ( cmd_tbl_t *cmdtp, int flag, int argc, char *argv[])
{

	if (argv[0][0] == 'u') {
		DNW = 0;
	}
	else {
		DNW = 1;
		exynos_got_header = 0;
	}

	switch (argc) {
	case 1 :
		exynos_usbd_dn_addr = USBD_DOWN_ADDR;	/* Default Address */
		break;
	case 2 :
		exynos_usbd_dn_addr = simple_strtoul(argv[1], NULL, 16);
		break;
	default:
		printf ("Usage:\n%s\n", cmdtp->usage);
		return 1;
	}

	exynos_receive_done = 0;

	exynos_usbctl_init();
	exynos_usbc_activate();

	printf("Download address 0x%08x\n", exynos_usbd_dn_addr);
	printf("Now, Waiting for DNW to transmit data\n");

	while (1) {
		if (EXYNOS_USBD_DETECT_IRQ()) {
			exynos_udc_int_hndlr();
			EXYNOS_USBD_CLEAR_IRQ();
		}

		if (exynos_receive_done)
			break;

		if (serial_tstc()) {
			serial_getc();
			break;
		}
	}

	/* when operation is done, usbd must be stopped */
	exynos_usb_stop();

	return 0;
}

U_BOOT_CMD(
	dnw, 3, 0, do_usbd_dnw,
	"dnw     - initialize USB device and ready to receive for Windows server (specific)\n",
	"[download address]\n"
);

#endif	/* CONFIG_S3C_USBD */

