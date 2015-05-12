/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * USB related routine
 */

#include <stdio.h>
#include <asm/arch/romboot.h>
#include <string.h>
#include <io.h>
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>
#include <usb.h>

#include "platform.h"
#include "usb_pcd.h"

#include "usb_pcd.c"
#include "platform.c"
#include "dwc_pcd.c"
#include "dwc_pcd_irq.c"

//DECLARE_GLOBAL_DATA_PTR;

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