/*
* (C) Copyright 2014 Hardkernel Co,.Ltd
*
* See file CREDITS for list of people who contributed to this
* project.
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation; either version 2 of
* the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston,
* MA 02111-1307 USA
*/

#include <common.h>
#include <malloc.h>
#include <asm/arch/memory.h>
#include <asm/arch/usb.h>
#include <asm/mach-types.h>

DECLARE_GLOBAL_DATA_PTR;

extern void hdmi_tx_power_init(void);
extern void board_ir_init(void);
extern struct amlogic_usb_config g_usb_config_m6_skt_b;
extern struct amlogic_usb_config g_usb_config_m6_skt_h;

u32 get_board_rev(void)
{
	return 0x00001000;
}

int serial_set_pin_port(unsigned port_base)
{
	// GPIOAO_0 : tx, GPIOAO_1 : rx
	setbits_le32(P_AO_RTI_PIN_MUX_REG, 3 << 11);
	return 0;
}

int board_init(void)
{
	gd->bd->bi_arch_number = MACH_TYPE_MESON6_SKT;
	gd->bd->bi_boot_params = BOOT_PARAMS_OFFSET;

#ifdef CONFIG_IR_REMOTE
	board_ir_init();
#endif
#ifdef CONFIG_USB_DWC_OTG_HCD
	board_usb_init(&g_usb_config_m6_skt_b,BOARD_USB_MODE_HOST);
	board_usb_init(&g_usb_config_m6_skt_h,BOARD_USB_MODE_CHARGER);
#endif

	return 0;
}

#if defined(BOARD_LATE_INIT)
int board_late_init(void)
{
        block_dev_desc_t *dev_desc;

        dev_desc = get_dev_by_name("mmc0");
        if (dev_desc) {
                printf("============================================================\n");
                dev_print(dev_desc);
                printf("------------------------------------------------------------\n");
                print_part_dos(dev_desc);
                printf("============================================================\n");
        }
}
#endif
