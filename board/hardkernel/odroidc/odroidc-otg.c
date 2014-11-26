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
#include <asm/arch/usb.h>
#include <asm/arch/gpio.h>

#ifdef CONFIG_USB_DWC_OTG_HCD
static int usb_charging_detect_call_back(char bc_mode)
{
        switch(bc_mode){
        case BC_MODE_DCP:
        case BC_MODE_CDP:
                //Pull up chargging current > 500mA
                break;

        case BC_MODE_UNKNOWN:
        case BC_MODE_SDP:
        default:
                //Limit chargging current <= 500mA
                //Or detet dec-charger
                break;
        }
        return 0;
}

struct amlogic_usb_config g_usb_config_m6_skt_b={
        USB_PHY_CLK_SEL_XTAL,
        1,      // PLL div = (clock/12 - 1)
        CONFIG_M8_USBPORT_BASE_B,
        USB_ID_MODE_SW_HOST,
        NULL,
        NULL,
};
struct amlogic_usb_config g_usb_config_m6_skt_h={
        USB_PHY_CLK_SEL_XTAL,
        1,      // PLL div = (clock/12 - 1)
        CONFIG_M8_USBPORT_BASE_A,
        USB_ID_MODE_HARDWARE,
        NULL,
        usb_charging_detect_call_back,
};
#endif /*CONFIG_USB_DWC_OTG_HCD*/

#if defined(CONFIG_USB_GADGET_S3C_UDC_OTG)
#include <usb/s3c_udc.h>

#define OTG_PHY_CONFIG          0x0000
#define OTG_PHY_CTRL            0x0004
#define OTG_PHY_CTRL_POR        (1 << 15)
#define OTG_PHY_CTRL_FSEL(x)    ((x) << 22)
#define OTG_PHY_CTRL_CLKDET     (1 << 8)
#define OTG_PHY_ENDP_INTR       0x0008
#define OTG_PHY_ADP_BC          0x000c
#define OTG_PHY_DBG_UART        0x0010
#define OTG_PHY_TEST            0x0014
#define OTG_PHY_TUNE            0x0018

#define PREI_USB_PHY_REG_BASE   P_USB_ADDR0
#define DWC_REG_BASE            0xc9040000
#define DWC_REG_GSNPSID         0x040   /* Synopsys ID Register (Read Only). */

static int dwc_otg_start_clk(int on)
{
        if (on) {
                u32 temp;
                u32 snpsid;

                writel((1 << 2), P_RESET1_REGISTER);
                udelay(500);

                /* Power On Reset */
                temp = readl(PREI_USB_PHY_REG_BASE + OTG_PHY_CTRL);
                temp |= OTG_PHY_CTRL_FSEL(5) | OTG_PHY_CTRL_POR;
                writel(temp, PREI_USB_PHY_REG_BASE + OTG_PHY_CTRL);

                udelay(500);    // 500us

                temp &= ~OTG_PHY_CTRL_POR;
                writel(temp, PREI_USB_PHY_REG_BASE + OTG_PHY_CTRL);

                udelay(50000);  // 50ms

                /* USB OTG PHY does work? */
                temp = readl(PREI_USB_PHY_REG_BASE + OTG_PHY_CTRL);
                if (0 == (temp & OTG_PHY_CTRL_CLKDET)) {
                        printf("ERROR, usb phy clock is not detected!\n");
                }

                /* Check USB OTG ID, if it can work */
                snpsid = readl(DWC_REG_BASE + DWC_REG_GSNPSID);
                if (0x4f543000 != (snpsid & 0xfffff000)) {
                        printf("%s, Bad value for SNPSID: 0x%08x\n",
                                        __func__, snpsid);
                        return -1;
                }
        }

        return 0;
}

struct s3c_plat_otg_data s3c_otg_data = {
        .phy_control = dwc_otg_start_clk,
        .regs_otg = DWC_REG_BASE,
};
#endif
