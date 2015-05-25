
/*
 * drivers/usb/gadget/aml_tiny_usbtool/usb_boot.c
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

#include "usb_boot.h"
#include "usb_pcd.h"

void set_usb_phy_config(void)
{
    int time_dly = 500;
    usb_aml_regs_t * usb_aml_regs = (usb_aml_regs_t * )PREI_USB_PHY_REG_BASE;
    usb_config_data_t config;
    usb_ctrl_data_t control;

    *P_RESET1_REGISTER = (1<<2);//usb reset

    // select rtc 32k
    config.d32 = usb_aml_regs->config;

    config.b.clk_32k_alt_sel= 1;
    usb_aml_regs->config = config.d32;

    // select 24MHz reference
    control.d32 = usb_aml_regs->ctrl;

    control.b.fsel = 5;
    control.b.por = 1;
    usb_aml_regs->ctrl = control.d32;

    _udelay(time_dly);
    control.b.por = 0;
    usb_aml_regs->ctrl = control.d32;

    _udelay(time_dly);
}

// static const char __attribute__((aligned(4))) usb_msg[] = "enter usb boot";

int usb_boot(int timeout_type)
{
    C_ROM_BOOT_DEBUG->usb_boot_cnt++;
    // serial_puts( usb_msg );
    set_usb_phy_config();

    usb_parameter_init(timeout_type);

    if (usb_pcd_init())
        return 0;

    while (1) {
        watchdog_clear();
        if (usb_pcd_irq())
            break;
    }

    return 0;
}


