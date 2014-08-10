/*
 * SAMSUNG EXYNOS USB HOST EHCI Controller
 *
 * Copyright (C) 2013, Suriyan Ramasami <suriyan.r@gmail.com>
 *
 * Based on
 * Copyright (C) 2012 Samsung Electronics Co.Ltd
 *	Vivek Gautam <gautam.vivek@samsung.com>
 *
 * Parts of code from Tushar Behera <tushar.behera@linaro.org>
 *	Use GUID for setting MAC address.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <fdtdec.h>
#include <libfdt.h>
#include <malloc.h>
#include <usb.h>
#include <asm/arch/cpu.h>
#include <asm/arch/ehci.h>
#include <asm/arch/system.h>
#include <asm/arch/power.h>
#include <asm/gpio.h>
#include <asm-generic/errno.h>
#include <linux/compat.h>
#include "ehci.h"
#include "ehci-core.h"

#define HSIC_CTRL_REFCLKSEL                     (0x2)
#define HSIC_CTRL_REFCLKSEL_MASK                (0x3)
#define HSIC_CTRL_REFCLKSEL_SHIFT               (23)

#define HSIC_CTRL_REFCLKDIV_12                  (0x24)
#define HSIC_CTRL_REFCLKDIV_MASK                (0x7f)
#define HSIC_CTRL_REFCLKDIV_SHIFT               (16)

#define HSIC_CTRL_SIDDQ                         (0x1 << 6)
#define HSIC_CTRL_FORCESLEEP                    (0x1 << 5)
#define HSIC_CTRL_FORCESUSPEND                  (0x1 << 4)
#define HSIC_CTRL_UTMISWRST                     (0x1 << 2)
#define HSIC_CTRL_PHYSWRST                      (0x1 << 0) 

#define EXYNOS5_GUID_LOW			0x10000014
#define EXYNOS5_GUID_HIGH			0x10000018

/* Declare global data pointer */
DECLARE_GLOBAL_DATA_PTR;


/* This function if from Tushar Behera @ Linaro */
static void set_usb_ethaddr()
{
	int i;
	uchar mac[6];
	unsigned int guid_high = readl(EXYNOS5_GUID_HIGH);
	unsigned int guid_low = readl(EXYNOS5_GUID_LOW);

	for (i = 0; i < 2; i++)
		mac[i] = (guid_high >> (8 * (1 - i))) & 0xFF;

	for (i = 0; i < 4; i++)
		mac[i+2] = (guid_low >> (8 * (3 - i))) & 0xFF;

	/* mark it as not multicast and outside official 80211 MAC namespace */
	mac[0] = (mac[0] & ~0x1) | 0x2;

	eth_setenv_enetaddr("ethaddr", mac);
	eth_setenv_enetaddr("usbethaddr", mac);
}

/* Setup the EHCI host controller. */
static void setup_usb_phy(struct exynos_usb_phy *usb)
{
u32 hsic_ctrl;

	set_usbhost_mode(USB20_PHY_CFG_HOST_LINK_EN);

	set_usbhost_phy_ctrl(POWER_USB_HOST_PHY_CTRL_EN);

	clrbits_le32(&usb->usbphyctrl0,
			HOST_CTRL0_FSEL_MASK |
			HOST_CTRL0_COMMONON_N |
			/* HOST Phy setting */
			HOST_CTRL0_PHYSWRST |
			HOST_CTRL0_PHYSWRSTALL |
			HOST_CTRL0_SIDDQ |
			HOST_CTRL0_FORCESUSPEND |
			HOST_CTRL0_FORCESLEEP);

	setbits_le32(&usb->usbphyctrl0,
			/* Setting up the ref freq */
			(CLK_24MHZ << 16) |
			/* HOST Phy setting */
			HOST_CTRL0_LINKSWRST |
			HOST_CTRL0_UTMISWRST);

	udelay(10);
	clrbits_le32(&usb->usbphyctrl0,
			HOST_CTRL0_LINKSWRST |
			HOST_CTRL0_UTMISWRST);
	/* HSIC Phy Setting */
	hsic_ctrl = (HSIC_CTRL_FORCESUSPEND |
			HSIC_CTRL_FORCESLEEP |
			HSIC_CTRL_SIDDQ);

	clrbits_le32(&usb->hsicphyctrl1, hsic_ctrl);
	clrbits_le32(&usb->hsicphyctrl2, hsic_ctrl);

	hsic_ctrl = (((HSIC_CTRL_REFCLKDIV_12 & HSIC_CTRL_REFCLKDIV_MASK)
			 << HSIC_CTRL_REFCLKDIV_SHIFT)
			| ((HSIC_CTRL_REFCLKSEL & HSIC_CTRL_REFCLKSEL_MASK)
			<< HSIC_CTRL_REFCLKSEL_SHIFT)
			| HSIC_CTRL_UTMISWRST);

	setbits_le32(&usb->hsicphyctrl1, hsic_ctrl);
	setbits_le32(&usb->hsicphyctrl2, hsic_ctrl);

	udelay(10);

	clrbits_le32(&usb->hsicphyctrl1, HSIC_CTRL_PHYSWRST |
			HSIC_CTRL_UTMISWRST);

	clrbits_le32(&usb->hsicphyctrl2, HSIC_CTRL_PHYSWRST |
			HSIC_CTRL_UTMISWRST);

	udelay(20);

	/* EHCI Ctrl setting */
	setbits_le32(&usb->ehcictrl,
			EHCICTRL_ENAINCRXALIGN |
			EHCICTRL_ENAINCR4 |
			EHCICTRL_ENAINCR8 |
			EHCICTRL_ENAINCR16);
}

/* Reset the EHCI host controller. */
static void reset_usb_phy(struct exynos_usb_phy *usb)
{
	u32 hsic_ctrl;

	/* HOST_PHY reset */
	setbits_le32(&usb->usbphyctrl0,
			HOST_CTRL0_PHYSWRST |
			HOST_CTRL0_PHYSWRSTALL |
			HOST_CTRL0_SIDDQ |
			HOST_CTRL0_FORCESUSPEND |
			HOST_CTRL0_FORCESLEEP);

	/* HSIC Phy reset */
	hsic_ctrl = (HSIC_CTRL_FORCESUSPEND |
	HSIC_CTRL_FORCESLEEP |
	HSIC_CTRL_SIDDQ |
	HSIC_CTRL_PHYSWRST);

	setbits_le32(&usb->hsicphyctrl1, hsic_ctrl);
	setbits_le32(&usb->hsicphyctrl2, hsic_ctrl);

	set_usbhost_phy_ctrl(POWER_USB_HOST_PHY_CTRL_DISABLE);
}

/*
 * EHCI-initialization
 * Create the appropriate control structures to manage
 * a new EHCI host controller.
 */
int ehci_hcd_init(void)
{
	struct exynos_usb_phy *usb;

	usb = (struct exynos_usb_phy *)samsung_get_base_usb_phy();
	hccr = (struct ehci_hccr *)samsung_get_base_usb_ehci();

	setup_usb_phy(usb);

	hcor = (struct ehci_hcor *)((uint32_t) hccr
				+ HC_LENGTH(ehci_readl(&hccr->cr_capbase)));

	debug("Exynos5-ehci: init hccr %x and hcor %x hc_length %d\n",
		(uint32_t)hccr, (uint32_t)hcor,
		(uint32_t)HC_LENGTH(ehci_readl(&hccr->cr_capbase)));
	set_usb_ethaddr();

	return 0;
}

/*
 * Destroy the appropriate control structures corresponding
 * the EHCI host controller.
 */
int ehci_hcd_stop(void)
{
	struct exynos_usb_phy *usb;

	usb = (struct exynos_usb_phy *)samsung_get_base_usb_phy();

	reset_usb_phy(usb);

	return 0;
}
