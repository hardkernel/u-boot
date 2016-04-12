/*
 *amlogic USB HOST XHCI Controller
 *
 *	Yue Wang <yue.wang@amlogic.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

/*
 * This file is a conglomeration for DWC3-init sequence and further
 * exynos5 specific PHY-init sequence.
 */

#include <common.h>
#include <libfdt.h>
#include <malloc.h>
#include <usb.h>
#include <watchdog.h>
#include <asm/arch/cpu.h>
#include <asm-generic/errno.h>
#include <linux/compat.h>
#include <linux/usb/dwc3.h>
#include <asm/arch/usb-new.h>
#include "xhci.h"

/* Declare global data pointer */
DECLARE_GLOBAL_DATA_PTR;

/**
 * Contains pointers to register base addresses
 * for the usb controller.
 */
struct amlogic_xhci {
	struct u2p_aml_regs *usb2_phy;
	struct usb_aml_regs *usb3_phy;
	struct xhci_hccr *hcd;
	struct dwc3 *dwc3_reg;
};
struct usb_aml_regs *usb_aml_reg;

static struct amlogic_xhci amlogic;

static void amlogic_usb2_phy_init(struct u2p_aml_regs *phy)
{
	int time_dly = 500;
	int i;
	struct u2p_aml_regs *u2p_aml_reg;
	union u2p_r0_t reg0;

	*P_RESET1_REGISTER = (1<<2);

	udelay(time_dly);

	for (i=0; i<2; i++) {
		u2p_aml_reg = (struct u2p_aml_regs *)((ulong)phy + i * PHY_REGISTER_SIZE);

		reg0.d32 = u2p_aml_reg->u2p_r0;
		reg0.b.por = 1;
		reg0.b.dmpulldown = 1;
		reg0.b.dppulldown = 1;

		u2p_aml_reg->u2p_r0 = reg0.d32;

		udelay(time_dly);

		reg0.d32 = u2p_aml_reg->u2p_r0;
		reg0.b.por = 0;
		u2p_aml_reg->u2p_r0 = reg0.d32;
	}

	return;
}

static void amlogic_usb3_phy_init(struct usb_aml_regs *phy)
{
	return;
}

static void amlogic_usb2_phy_exit(struct u2p_aml_regs *phy)
{
	return;
}

static void amlogic_usb3_phy_exit(struct usb_aml_regs *phy)
{
	return;
}
void dwc3_set_mode(struct dwc3 *dwc3_reg, u32 mode)
{
	u32 reg;

	reg = xhci_readl(&dwc3_reg->g_ctl);
	reg &= ~(DWC3_GCTL_PRTCAPDIR(DWC3_GCTL_PRTCAP_OTG));
	reg |= DWC3_GCTL_PRTCAPDIR(mode);
	xhci_writel(&dwc3_reg->g_ctl, reg);
}

static void dwc3_core_soft_reset(struct dwc3 *dwc3_reg)
{
	u32		reg;

	/* Before Resetting PHY, put Core in Reset */
	reg = xhci_readl(&dwc3_reg->g_ctl);
	reg |= DWC3_GCTL_CORESOFTRESET;
	xhci_writel(&dwc3_reg->g_ctl, reg);

	/* Assert USB2 PHY reset */
	reg = xhci_readl(&dwc3_reg->g_usb2phycfg[0]);
	reg |= DWC3_GUSB2PHYCFG_PHYSOFTRST;
	xhci_writel(&dwc3_reg->g_usb2phycfg[0], reg);

	reg = xhci_readl(&dwc3_reg->g_usb2phycfg[1]);
	reg |= DWC3_GUSB2PHYCFG_PHYSOFTRST;
	xhci_writel(&dwc3_reg->g_usb2phycfg[1], reg);

	amlogic_usb2_phy_init(amlogic.usb2_phy);
	amlogic_usb3_phy_init(amlogic.usb3_phy);
	mdelay(100);

	/* Clear USB2 PHY reset */
	reg = xhci_readl(&dwc3_reg->g_usb2phycfg[0]);
	reg &= ~DWC3_GUSB2PHYCFG_PHYSOFTRST;
	reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
	xhci_writel(&dwc3_reg->g_usb2phycfg[0], reg);

	/* Clear USB2 PHY reset */
	reg = xhci_readl(&dwc3_reg->g_usb2phycfg[1]);
	reg &= ~DWC3_GUSB2PHYCFG_PHYSOFTRST;
	reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
	xhci_writel(&dwc3_reg->g_usb2phycfg[1], reg);

	mdelay(100);

	/* After PHYs are stable we can take Core out of reset state */
	reg = xhci_readl(&dwc3_reg->g_ctl);
	reg &= ~DWC3_GCTL_CORESOFTRESET;
	xhci_writel(&dwc3_reg->g_ctl, reg);
}

static int dwc3_core_init(struct dwc3 *dwc3_reg)
{
	u32 reg;
	u32 revision;
	unsigned int dwc3_hwparams1;
	unsigned long		timeout;

	revision = xhci_readl(&dwc3_reg->g_snpsid);
	/* This should read as U3 followed by revision number */
	if ((revision & DWC3_GSNPSID_MASK) != 0x55330000) {
		printf("this is not a DesignWare USB3 DRD Core\n");
		return -EINVAL;
	}

	/* issue device SoftReset too */
	timeout = 500;
	xhci_writel(&dwc3_reg->d_ctl, DWC3_DCTL_CSFTRST);
	do {
		reg = xhci_readl(&dwc3_reg->d_ctl);
		if (!(reg & DWC3_DCTL_CSFTRST))
			break;

		timeout--;
		mdelay(1);
	} while (timeout);

	if (!timeout) {
		printf("device SoftReset fail!\n");
		return -EINVAL;
	}

	dwc3_core_soft_reset(dwc3_reg);

	dwc3_hwparams1 = xhci_readl(&dwc3_reg->g_hwparams1);

	reg = xhci_readl(&dwc3_reg->g_ctl);
	reg &= ~DWC3_GCTL_SCALEDOWN_MASK;
	reg &= ~DWC3_GCTL_DISSCRAMBLE;
	switch (DWC3_GHWPARAMS1_EN_PWROPT(dwc3_hwparams1)) {
	case DWC3_GHWPARAMS1_EN_PWROPT_CLK:
		reg &= ~DWC3_GCTL_DSBLCLKGTNG;
		break;
	default:
		debug("No power optimization available\n");
	}

	/*
	 * WORKAROUND: DWC3 revisions <1.90a have a bug
	 * where the device can fail to connect at SuperSpeed
	 * and falls back to high-speed mode which causes
	 * the device to enter a Connect/Disconnect loop
	 */
	if ((revision & DWC3_REVISION_MASK) < 0x190a)
		reg |= DWC3_GCTL_U2RSTECN;

	xhci_writel(&dwc3_reg->g_ctl, reg);

	return 0;
}

static int amlogic_xhci_core_init(struct amlogic_xhci *amlogic)
{
	int ret;

	ret = dwc3_core_init(amlogic->dwc3_reg);
	if (ret) {
		debug("failed to initialize core\n");
		return -EINVAL;
	}

	/* We are hard-coding DWC3 core to Host Mode */
	dwc3_set_mode(amlogic->dwc3_reg, DWC3_GCTL_PRTCAP_HOST);

	return 0;
}

static void amlogic_xhci_core_exit(struct amlogic_xhci *amlogic)
{
	amlogic_usb2_phy_exit(amlogic->usb2_phy);

	amlogic_usb3_phy_exit(amlogic->usb3_phy);
}

int xhci_hcd_init(int index, struct xhci_hccr **hccr, struct xhci_hcor **hcor)
{
	struct amlogic_xhci *ctx = &amlogic;
	struct amlogic_usb_config * usb_config;
	int ret;

	usb_config = board_usb_start(BOARD_USB_MODE_HOST, index);

	ctx->hcd = (struct xhci_hccr *)(ulong)(usb_config->base_addr);
	ctx->dwc3_reg = (struct dwc3 *)((char *)(ctx->hcd) + DWC3_REG_OFFSET);
	ctx->usb3_phy = (struct usb_aml_regs *)(ulong)(usb_config->usb_phy3_base_addr);
	ctx->usb2_phy = (struct u2p_aml_regs *)(ulong)(usb_config->usb_phy2_base_addr);

	ret = amlogic_xhci_core_init(ctx);
	if (ret) {
		puts("XHCI: failed to initialize controller\n");
		return -EINVAL;
	}

	*hccr = (ctx->hcd);
	*hcor = (struct xhci_hcor *)((ulong) *hccr
				+ HC_LENGTH(xhci_readl(&(*hccr)->cr_capbase)));

	debug("amlogic-xhci: init hccr %lx and hcor %lx hc_length %d\n",
		(ulong)*hccr, (ulong)*hcor,
		(uint32_t)HC_LENGTH(xhci_readl(&(*hccr)->cr_capbase)));

	return 0;
}

void xhci_hcd_stop(int index)
{
	struct amlogic_xhci *ctx = &amlogic;

	amlogic_xhci_core_exit(ctx);
}
