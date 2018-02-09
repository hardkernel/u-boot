
/*
 * arch/arm/cpu/armv8/txl/usb.c
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

#include <asm/arch/usb-v2.h>
#include <asm/arch/romboot.h>


static struct amlogic_usb_config * g_usb_cfg[BOARD_USB_MODE_MAX][USB_PHY_PORT_MAX];

struct amlogic_usb_config * board_usb_start(int mode,int index)
{
	printf("USB3.0 XHCI init start\n");

	if (mode < 0 || mode >= BOARD_USB_MODE_MAX||!g_usb_cfg[mode][index])
		return 0;

	writel((1 << 2), P_RESET1_REGISTER);

	if (mode == BOARD_USB_MODE_HOST )
		if (g_usb_cfg[mode][index]->set_vbus_power)
			g_usb_cfg[mode][index]->set_vbus_power(1);

	return g_usb_cfg[mode][index];
}

int board_usb_stop(int mode,int index)
{
	printf("board_usb_stop cfg: %d\n",mode);

	return 0;
}

int usb_index = 0;
void board_usb_init(struct amlogic_usb_config * usb_cfg,int mode)
{
	if (mode < 0 || mode >= BOARD_USB_MODE_MAX || !usb_cfg)
		return ;

	if (mode == BOARD_USB_MODE_HOST) {
		if (usb_index >= USB_PHY_PORT_MAX)
			return;
		g_usb_cfg[mode][usb_index] = usb_cfg;
		usb_index++;
	} else
		g_usb_cfg[mode][0] = usb_cfg;
	printf("register usb cfg[%d][%d] = %p\n",mode,(mode==BOARD_USB_MODE_HOST)?usb_index:0,usb_cfg);
}

int get_usb_count(void)
{
    return  usb_index;
}

void set_usb_pll(uint32_t volatile *phy2_pll_base)
{
    (*(volatile uint32_t *)((unsigned long)phy2_pll_base + 0x40))
        = (USB_PHY2_PLL_PARAMETER_1 | USB_PHY2_RESET | USB_PHY2_ENABLE);
    (*(volatile uint32_t *)((unsigned long)phy2_pll_base + 0x44)) =
        USB_PHY2_PLL_PARAMETER_2;
    (*(volatile uint32_t *)((unsigned long)phy2_pll_base + 0x48)) =
        USB_PHY2_PLL_PARAMETER_3;
    udelay(100);
    (*(volatile uint32_t *)(unsigned long)((unsigned long)phy2_pll_base + 0x40))
        = (((USB_PHY2_PLL_PARAMETER_1) | (USB_PHY2_ENABLE))
        & (~(USB_PHY2_RESET)));
}

void board_usb_pll_disable(struct amlogic_usb_config *cfg)
{
    int i = 0;

    for (i = 0; i < cfg->u2_port_num; i++) {
        (*(volatile uint32_t *)(unsigned long)
            (cfg->usb_phy2_pll_base_addr[i] + 0x40))
            = ((USB_PHY2_PLL_PARAMETER_1 | USB_PHY2_RESET)
            & (~(USB_PHY2_ENABLE)));
    }
}
