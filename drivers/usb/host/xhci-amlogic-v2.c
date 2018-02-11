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
//#include <watchdog.h>
#include <asm/arch/cpu.h>
#include <asm-generic/errno.h>
#include <linux/compat.h>
#include <linux/usb/dwc3.h>
#include <asm/arch/usb-v2.h>
#include "xhci.h"
#include <asm/arch/secure_apb.h>

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
	unsigned int u2_port_num;
	unsigned int u3_port_num;
	uint32_t volatile *phy_2[4];
};
struct usb_aml_regs *usb_aml_reg;

static struct amlogic_xhci amlogic;

#ifdef CONFIG_USB_XHCI_AMLOGIC_USB3_V2
#define PCIE_PHY_CFG_BASE_ADDR      0xff646000
static void set_comb_phy_to_usb3_mode(void)
{
	u32 val = 0;

	*P_RESET0_LEVEL &= ~((0x1<<12) | (0x3<<14));
	*P_RESET0_LEVEL |=	  (0x1<<12) | (0x3<<14);

	val = xhci_readl((uint32_t volatile *)PCIE_PHY_CFG_BASE_ADDR);
	val |= (3<<5);
	xhci_writel((uint32_t volatile *)PCIE_PHY_CFG_BASE_ADDR, val);
}
#endif

static void amlogic_usb2_phy_init(struct u2p_aml_regs *phy)
{
	struct u2p_aml_regs *u2p_aml_reg;
	u2p_r0_t dev_u2p_r0;
	u2p_r1_t dev_u2p_r1;
	int i;
	int cnt;
	int time_dly = 500;

	*P_RESET1_REGISTER |= (1<<2);

	udelay(time_dly);

	for (i = 0; i < amlogic.u2_port_num; i++) {
		u2p_aml_reg = (struct u2p_aml_regs *)((ulong)phy + i * PHY_REGISTER_SIZE);
		dev_u2p_r0.d32 = u2p_aml_reg->u2p_r0;
		dev_u2p_r0.b.host_device= 1;
		dev_u2p_r0.b.POR= 0;
		u2p_aml_reg->u2p_r0  = dev_u2p_r0.d32;
		udelay(10);
		*P_RESET1_REGISTER |= (1 << (16 + i));
		udelay(50);

		/* wait for phy ready */
		dev_u2p_r1.d32  = u2p_aml_reg->u2p_r1;
		cnt = 0;
		while (dev_u2p_r1.b.phy_rdy != 1) {
			dev_u2p_r1.d32 = u2p_aml_reg->u2p_r1;
			/*we wait phy ready max 1ms, common is 100us*/
			if (cnt > 200)
				break;
			else {
				cnt++;
				udelay(5);
			}
		}
	}

	for (i = 0; i < amlogic.u2_port_num; i++) {
		printf("------set usb pll\n");
		set_usb_pll(amlogic.phy_2[i]);
	}
	return;
}

#ifdef CONFIG_USB_XHCI_AMLOGIC_USB3_V2
#if 0
void cr_bus_addr (u32 addr)
{
	usb_r2_t usb_r2 = {.d32 = 0};
	usb_r6_t usb_r6 = {.d32 = 0};

	// prepare addr
	usb_r2.b.p30_cr_data_in = addr;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// cap addr rising edge
	usb_r2.b.p30_cr_cap_addr = 0;
	usb_aml_reg->usb_r2 = usb_r2.d32;
	usb_r2.b.p30_cr_cap_addr = 1;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// wait ack 1
	do {
		usb_r6.d32 = usb_aml_reg->usb_r6;
	} while (usb_r6.b.p30_cr_ack == 0);

	// clear cap addr
	usb_r2.b.p30_cr_cap_addr = 0;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// wait ack 0
	do {
		usb_r6.d32 = usb_aml_reg->usb_r6;
	} while (usb_r6.b.p30_cr_ack == 1);
}

int cr_bus_read (u32 addr)
{
	int data;
	usb_r2_t usb_r2 = {.d32 = 0};
	usb_r6_t usb_r6 = {.d32 = 0};

	cr_bus_addr ( addr );

	// read rising edge
	usb_r2.b.p30_cr_read = 0;
	usb_aml_reg->usb_r2 = usb_r2.d32;
	usb_r2.b.p30_cr_read = 1;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// wait ack 1
	do {
		usb_r6.d32 = usb_aml_reg->usb_r6;
	} while (usb_r6.b.p30_cr_ack == 0);

	// save data
	data = usb_r6.b.p30_cr_data_out;

	// clear read
	usb_r2.b.p30_cr_read = 0;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// wait ack 0
	do {
		usb_r6.d32 = usb_aml_reg->usb_r6;
	} while (usb_r6.b.p30_cr_ack == 1);

	return data;
}

void cr_bus_write (u32 addr, u32 data)
{
	usb_r2_t usb_r2 = {.d32 = 0};
	usb_r6_t usb_r6 = {.d32 = 0};

	cr_bus_addr ( addr );

	// prepare data
	usb_r2.b.p30_cr_data_in = data;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// cap data rising edge
	usb_r2.b.p30_cr_cap_data = 0;
	usb_aml_reg->usb_r2 = usb_r2.d32;
	usb_r2.b.p30_cr_cap_data = 1;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// wait ack 1
	do {
		usb_r6.d32 = usb_aml_reg->usb_r6;
	} while (usb_r6.b.p30_cr_ack == 0);

	// clear cap data
	usb_r2.b.p30_cr_cap_data = 0;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// wait ack 0
	do {
		usb_r6.d32 = usb_aml_reg->usb_r6;
	} while (usb_r6.b.p30_cr_ack == 1);

	// write rising edge
	usb_r2.b.p30_cr_write = 0;
	usb_aml_reg->usb_r2 = usb_r2.d32;
	usb_r2.b.p30_cr_write = 1;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// wait ack 1
	do {
		usb_r6.d32 = usb_aml_reg->usb_r6;
	} while (usb_r6.b.p30_cr_ack == 0);

	// clear write
	usb_r2.b.p30_cr_write = 0;
	usb_aml_reg->usb_r2 = usb_r2.d32;

	// wait ack 0
	do {
		usb_r6.d32 = usb_aml_reg->usb_r6;
	} while (usb_r6.b.p30_cr_ack == 1);
}
#endif
#endif

static void amlogic_usb3_phy_init(struct usb_aml_regs *phy)
{
	usb_r1_t r1 = {.d32 = 0};
	usb_r2_t r2 = {.d32 = 0};
	usb_r3_t r3 = {.d32 = 0};
	int i;
#if 0
	u32 data = 0;
#endif

	if (amlogic.u3_port_num == 0) {
		usb_aml_reg = (struct usb_aml_regs *)((ulong)phy);
		r1.d32 = usb_aml_reg->usb_r1;
		usb_aml_reg->usb_r2 = r1.d32;
		r1.b.u3h_fladj_30mhz_reg = 0x26;
		usb_aml_reg->usb_r2 = r1.d32;
		udelay(100);
	}

	for (i = 0; i < amlogic.u3_port_num; i++) {
		usb_aml_reg = (struct usb_aml_regs *)((ulong)phy+i*PHY_REGISTER_SIZE);

		r3.d32 = usb_aml_reg->usb_r3;
		r3.b.p30_ssc_en = 1;
		r3.b.p30_ref_ssp_en = 1;
		usb_aml_reg->usb_r3 = r3.d32;
		udelay(2);
		r2.d32 = usb_aml_reg->usb_r2;
		r2.b.p30_pcs_tx_deemph_3p5db = 0x15;
		r2.b.p30_pcs_tx_deemph_6db = 0x20;
		usb_aml_reg->usb_r2 = r2.d32;
		udelay(2);
		r1.d32 = usb_aml_reg->usb_r1;
		r1.b.u3h_host_port_power_control_present = 1;
		r1.b.u3h_fladj_30mhz_reg = 32;
		usb_aml_reg->usb_r2 = r1.d32;
		udelay(2);
#if 0
		/*
		* WORKAROUND: There is SSPHY suspend bug due to which USB enumerates
		* in HS mode instead of SS mode. Workaround it by asserting
		* LANE0.TX_ALT_BLOCK.EN_ALT_BUS to enable TX to use alt bus mode
		*/
		data = cr_bus_read(0x102d);
		data |= (1 << 7);
		cr_bus_write(0x102D, data);

		data = cr_bus_read(0x1010);
		data &= ~0xff0;
		data |= 0x20;
		cr_bus_write(0x1010, data);

		/*
		* Fix RX Equalization setting as follows
		* LANE0.RX_OVRD_IN_HI. RX_EQ_EN set to 0
		* LANE0.RX_OVRD_IN_HI.RX_EQ_EN_OVRD set to 1
		* LANE0.RX_OVRD_IN_HI.RX_EQ set to 3
		* LANE0.RX_OVRD_IN_HI.RX_EQ_OVRD set to 1
		*/
		data = cr_bus_read(0x1006);
		data &= ~(1 << 6);
		data |= (1 << 7);
		data &= ~(0x7 << 8);
		data |= (0x3 << 8);
		data |= (0x1 << 11);
		cr_bus_write(0x1006, data);

		/*
		* Set EQ and TX launch amplitudes as follows
		* LANE0.TX_OVRD_DRV_LO.PREEMPH set to 22
		* LANE0.TX_OVRD_DRV_LO.AMPLITUDE set to 127
		 * LANE0.TX_OVRD_DRV_LO.EN set to 1.
		*/
		data = cr_bus_read(0x1002);
		data &= ~0x3f80;
		data |= (0x16 << 7);
		data &= ~0x7f;
		data |= (0x7f | (1 << 14));
		cr_bus_write(0x1002, data);

		/*
		* TX_FULL_SWING  to 127
		*/
		data = cr_bus_read(0x30);
		data &= ~(0xf << 4);
		cr_bus_write(0x30, data);

		/*
		* TX_FULL_SWING  to 127
		*/
		r1.d32 = usb_aml_reg->usb_r1;
		r1.b.p30_pcs_tx_swing_full = 127;
		r1.b.u3h_fladj_30mhz_reg = 0x20;
		usb_aml_reg->usb_r1 = r1.d32;
		udelay(2);

		/*
		* TX_DEEMPH_3_5DB  to 22
		*/
		r2.d32 = usb_aml_reg->usb_r2;
		r2.b.p30_pcs_tx_deemph_3p5db = 22;
		usb_aml_reg->usb_r2 = r2.d32;

		udelay(2);
		/*
		* LOS_BIAS	to 0x5
		* LOS_LEVEL to 0x9
		*/
		r3.d32 = usb_aml_reg->usb_r3;
		r3.b.p30_los_bias = 0x5;
		r3.b.p30_los_level = 0x9;
		r3.b.p30_ssc_en = 1;
		r3.b.p30_ssc_range = 2;
		usb_aml_reg->usb_r3 = r3.d32;
#endif
	}

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
	int		i;

	/* Before Resetting PHY, put Core in Reset */
	reg = xhci_readl(&dwc3_reg->g_ctl);
	reg |= DWC3_GCTL_CORESOFTRESET;
	xhci_writel(&dwc3_reg->g_ctl, reg);

	for (i = 0; i < 1; i++) {
		/* Assert USB3 PHY reset */
		reg = xhci_readl(&dwc3_reg->g_usb3pipectl[i]);
		reg |= DWC3_GUSB3PIPECTL_PHYSOFTRST;
		xhci_writel(&dwc3_reg->g_usb3pipectl[i], reg);
	}

	for (i = 0; i < 3; i++) {
		/* Assert USB2 PHY reset */
		reg = xhci_readl(&dwc3_reg->g_usb2phycfg[i]);
		reg |= DWC3_GUSB2PHYCFG_PHYSOFTRST;
		xhci_writel(&dwc3_reg->g_usb2phycfg[i], reg);
	}

	amlogic_usb2_phy_init(amlogic.usb2_phy);
	amlogic_usb3_phy_init(amlogic.usb3_phy);
	mdelay(100);


	for (i = 0; i < 1; i++) {
		/* Clear USB3 PHY reset */
		reg = xhci_readl(&dwc3_reg->g_usb3pipectl[i]);
		reg &= ~DWC3_GUSB3PIPECTL_PHYSOFTRST;
		xhci_writel(&dwc3_reg->g_usb3pipectl[i], reg);
	}

	for (i = 0; i < 3; i++) {
			/* Clear USB2 PHY reset */
		reg = xhci_readl(&dwc3_reg->g_usb2phycfg[i]);
		reg &= ~DWC3_GUSB2PHYCFG_PHYSOFTRST;
		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
		reg &= ~DWC3_GUSB2PHYCFG_PHYIF;
		xhci_writel(&dwc3_reg->g_usb2phycfg[i], reg);
	}

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
	reg = xhci_readl(&dwc3_reg->g_uctl);
	reg |= DWC3_GUCTL_USBHSTINAUTORETRYEN;
	xhci_writel(&dwc3_reg->g_uctl, reg);

	reg = xhci_readl((uint32_t volatile *)DWC3_GFLADJ);
	reg &= ~DWC3_GFLADJ_30MHZ_MASK;
	reg |= DWC3_GFLADJ_30MHZ_SDBND_SEL | 0x26;
	xhci_writel((uint32_t volatile *)DWC3_GFLADJ, reg);

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
	int i = 0;

#ifdef CONFIG_USB_XHCI_AMLOGIC_USB3_V2
	set_comb_phy_to_usb3_mode();
#endif

	usb_config = board_usb_start(BOARD_USB_MODE_HOST, index);

	ctx->hcd = (struct xhci_hccr *)(ulong)(usb_config->base_addr);
	ctx->dwc3_reg = (struct dwc3 *)((char *)(ctx->hcd) + DWC3_REG_OFFSET);
	ctx->usb3_phy = (struct usb_aml_regs *)(ulong)(usb_config->usb_phy3_base_addr);
	ctx->usb2_phy = (struct u2p_aml_regs *)(ulong)(usb_config->usb_phy2_base_addr);
	ctx->u2_port_num = usb_config->u2_port_num;
	ctx->u3_port_num = usb_config->u3_port_num;
	for (i = 0; i < usb_config->u2_port_num; i++)
		ctx->phy_2[i] = (uint32_t volatile *)(ulong)usb_config->usb_phy2_pll_base_addr[i];

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
