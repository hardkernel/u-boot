/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <asm/arch/usb.h>

#include <usb.h>
#include <usb/s3c_udc.h>

#define P_RESET1_REGISTER_USB	0xc1104408

#define PREI_USB_PHY_A_REG_BASE	0xC0000000
#define PREI_USB_PHY_REG_BASE	PREI_USB_PHY_A_REG_BASE

#define PORT_REG_OFFSET		0x0000	/* Port - A */
#define DWC_REG_BASE		(0xC9000000 + PORT_REG_OFFSET)

#define DWC_REG_GSNPSID		0x040	/* Synopsys ID Register (Read Only) */

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

extern struct amlogic_usb_config *amlogic_usb_config(int port);

static int dwc_otg_start_clk(int on)
{
        if (on) {
                u32 temp;
                u32 snpsid;

                writel((1 << 2), P_RESET1_REGISTER_USB);
                udelay(500);

                /* Power On Reset & select 24MHz as reference clock */
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
        } else {
		/* FIXME: Add to disable USB OTG PHY
		 */
	}

        return 0;
}

struct s3c_plat_otg_data odroid_otg_data = {
	.phy_control	= dwc_otg_start_clk,
	.regs_otg	= DWC_REG_BASE,
};

void otg_phy_init(struct s3c_udc *dev)
{
	dev->pdata->phy_control(1);

	/* USB PHY0 Enable */
	printf("USB PHY0 Enabled\n");
}

void otg_phy_off(struct s3c_udc *dev)
{
	dev->pdata->phy_control(0);

	/* USB PHY0 Disable */
	printf("USB PHY0 Disabled\n");
}

int board_usb_init(int index, enum usb_init_type init)
{
	amlogic_usb_config_t *usb_config;

	if (init == USB_INIT_DEVICE) {
		usb_config = amlogic_usb_start(BOARD_USB_MODE_SLAVE, 0);
		if (usb_config == amlogic_usb_config(0))
			return s3c_udc_probe(&odroid_otg_data);
	} else {
		/* FIXME: do we need to initiate USB host here? */
	}

	return -ENODEV;
}
