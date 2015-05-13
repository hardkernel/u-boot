
/*
 * drivers/usb/gadget/aml_tiny_usbtool/aml_tiny_usbtool.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <common.h>
#include "platform.h"
#include "usb_pcd.h"

#include "usb_pcd.c"
#include "platform.c"
#include "dwc_pcd.c"
#include "dwc_pcd_irq.c"

DECLARE_GLOBAL_DATA_PTR;

int usb_boot(int clk_cfg, int time_out)
{
	int cfg = INT_CLOCK;

#if defined(CONFIG_SILENT_CONSOLE)
	gd->flags &= ~GD_FLG_SILENT;
#endif

	if (clk_cfg)
		cfg = EXT_CLOCK;
	set_usb_phy_config(cfg);

	usb_parameter_init(time_out);

	if (usb_pcd_init())
		return 0;

	while (1)
	{
		//watchdog_clear();		//Elvis Fool
		if (usb_pcd_irq())
			break;
	}
	return 0;
}

int do_tiny_usbtool (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int time_out = 0;
	if (argc > 1)
	{
		time_out = simple_strtol(argv[1], NULL, 10);
	}
	printf("Enter USB burning.\n");
	return usb_boot(1, time_out);
}


U_BOOT_CMD(
	tiny_usbtool,	2,	1,	do_tiny_usbtool,
	"start tiny USB tool for PC burner",
	"tiny_usbtool timeout"
);

