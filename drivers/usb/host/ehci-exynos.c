/*
 * SAMSUNG EXYNOS USB HOST EHCI Controller
 *
 * Copyright (C) 2013, Suriyan Ramasami <suriyan.r@gmail.com>
 *
 * Based on
 * Copyright (C) 2012 Samsung Electronics Co.Ltd
 *	Vivek Gautam <gautam.vivek@samsung.com>
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

#define con_4bit_shift(__off) ((__off) * 4)

#define GPIOCON_OFF (0x00)
#define GPIODAT_OFF (0x04)
#define GPIOPUD_OFF (0x08)


/* Declare global data pointer */
DECLARE_GLOBAL_DATA_PTR;

#if defined(CONFIG_BOARD_HARDKERNEL) && defined(CONFIG_EXYNOS4412)
void max77686_update_reg(u8 reg, u8 val, u8 mask) {
	u8 old_val, new_val;

	val = val & 0xFF;
	mask = mask & 0xFF;
	reg = reg & 0xFF;
	if (pmic_read(reg, &old_val, 1)) printf("pmic_read error\n");
	if (old_val >= 0) {
		old_val = old_val & 0xff;
		new_val = (val & mask) | (old_val & (~mask));
		pmic_write(reg, &new_val, 1);
	}
}
#endif

/**
 * Contains pointers to register base addresses
 * for the usb controller.
 */
struct exynos_ehci {
	struct exynos_usb_phy *usb;
	struct ehci_hccr *hcd;
	struct fdt_gpio_state vbus_gpio;
};

static struct exynos_ehci exynos;

static int s_gpio_direction_output(void *base, unsigned int offset, int value)
{
        unsigned long con;
        unsigned long dat;

        con = __raw_readl(base + GPIOCON_OFF);
        con &= ~(0xf << con_4bit_shift(offset));
        con |= 0x1 << con_4bit_shift(offset);

        dat = __raw_readl(base + GPIODAT_OFF);

        if (value)
                dat |= 1 << offset;
        else
                dat &= ~(1 << offset);

        __raw_writel(dat, base + GPIODAT_OFF);
        __raw_writel(con, base + GPIOCON_OFF);
        __raw_writel(dat, base + GPIODAT_OFF);

        return 0;
}

static int s_gpio_direction_input(void *base, unsigned offset)
{
        unsigned long con;

        con = __raw_readl(base + GPIOCON_OFF);
        con &= ~(0xf << con_4bit_shift(offset));
        __raw_writel(con, base + GPIOCON_OFF);

        return 0;
}

static void s_gpio_set_value(void *base, unsigned offset, int value)
{
        unsigned long dat;

        dat = __raw_readl(base + 0x04);
        dat &= ~(1 << offset);
        if (value)
                dat |= 1 << offset;
        __raw_writel(dat, base + 0x04);
}

#ifdef CONFIG_OF_CONTROL
static int exynos_usb_parse_dt(const void *blob, struct exynos_ehci *exynos)
{
	fdt_addr_t addr;
	unsigned int node;
	int depth;

	node = fdtdec_next_compatible(blob, 0, COMPAT_SAMSUNG_EXYNOS_EHCI);
	if (node <= 0) {
		debug("EHCI: Can't get device node for ehci\n");
		return -ENODEV;
	}

	/*
	 * Get the base address for EHCI controller from the device node
	 */
	addr = fdtdec_get_addr(blob, node, "reg");
	if (addr == FDT_ADDR_T_NONE) {
		debug("Can't get the EHCI register address\n");
		return -ENXIO;
	}

	exynos->hcd = (struct ehci_hccr *)addr;

	/* Vbus gpio */
	fdtdec_decode_gpio(blob, node, "samsung,vbus-gpio", &exynos->vbus_gpio);

	depth = 0;
	node = fdtdec_next_compatible_subnode(blob, node,
					COMPAT_SAMSUNG_EXYNOS_USB_PHY, &depth);
	if (node <= 0) {
		debug("EHCI: Can't get device node for usb-phy controller\n");
		return -ENODEV;
	}

	/*
	 * Get the base address for usbphy from the device node
	 */
	exynos->usb = (struct exynos_usb_phy *)fdtdec_get_addr(blob, node,
								"reg");
	if (exynos->usb == NULL) {
		debug("Can't get the usbphy register address\n");
		return -ENXIO;
	}

	return 0;
}
#endif

static void suriyan_exynos_usb_mux_change(struct platform_device *pdev, int val)
{
/* In the linux 3.4.y tree in file arch/arm/mach-exynos/setup-usb-phy.c
 * this is the registers fiddled with in function: exynos_usb_mux_change()
 * EXYNOS5_USB_CFG	(S3C_VA_SYS + 0x230)
 */

}

static int suriyan_exynos5_usb_phy20_is_on(void)
{
/*
 * In the linux 3.4.y tree in file arch/arm/mach-exynos/setup-usb-phy.c
 * this is the registers fiddled with in function: exynos5_usb_phy20_is_on()
 * EXYNOS5_PHY_HOST_CTRL0	EXYNOS4_HSOTG_PHYREG(0x00)
 * 	HOST_CTRL0_SIDDQ	(0x1 << 6)
 */
}


static void suriyan_setup_usb_phy(struct exynos_usb_phy *usb) {
/*
 * In the linux 3.4.y tree in file arch/arm/mach-exynos/setup-usb-phy.c
 * this is the registers fiddled with in function: exynos5_usb_phy20_init()
 * EXYNOS5_USBHOST_PHY_CONTROL	EXYNOS_PMUREG(0x070C)
 * 	PHY_ENABLE		(1 << 0)
 * EXYNOS5_PHY_HOST_CTRL0	EXYNOS4_HSOTG_PHYREG(0x00)
 * 	HOST_CTRL0_FSEL_MASK	(0x7 << 16)
 * EXYNOS5_PHY_OTG_SYS		EXYNOS4_HSOTG_PHYREG(0x38)
 * 	OTG_SYS_CTRL0_FSEL_MASK	(0x7 << 4)
 * 	HOST_CTRL0_CLKSEL_SHIFT	(16)
 * 	OTG_SYS_CLKSEL_SHIFT	(4)
 * 	HOST_CTRL0_COMMONON_N	(0x1 << 9)
 * 	OTG_SYS_COMMON_ON	(0x1 << 7)
 * 	OTG_SYS_FORCE_SUSPEND	(0x1 << 0)
 * 	OTG_SYS_SIDDQ_UOTG	(0x1 << 1)
 * 	OTG_SYS_FORCE_SLEEP	(0x1 << 3)
 *	OTG_SYS_REF_CLK_SEL_MASK	(0x3 << 9)
 *	OTG_SYS_REF_CLK_SEL(val)	((val&0x3) << 9)
 *	OTG_SYS_PHY0_SW_RST	(0x1 << 12)
 *	OTG_SYS_LINK_SW_RST_UOTG	(0x1 << 13)
 *	OTG_SYS_PHYLINK_SW_RESET	(0x1 << 14)
 *
 *	HOST_CTRL0_PHYSWRST	(0x1 << 0)
 *	HOST_CTRL0_PHYSWRSTALL	(0x1 << 31)
 *	HOST_CTRL0_SIDDQ	(0x1 << 6)
 *	HOST_CTRL0_FORCESUSPEND	(0x1 << 4)
 *	HOST_CTRL0_FORCESLEEP	(0x1 << 5)
 *	HOST_CTRL0_LINKSWRST	(0x1 << 1)
 *	HOST_CTRL0_UTMISWRST	(0x1 << 2)
 *
 * EXYNOS5_PHY_HSIC_CTRL1	EXYNOS4_HSOTG_PHYREG(0x10)
 * EXYNOS5_PHY_HSIC_CTRL2	EXYNOS4_HSOTG_PHYREG(0x20)
 * 	EXYNOS5_CLKSEL_24M	(0x5)
 *	HSIC_CTRL_REFCLKDIV(val)	((val&0x7f) << 16)
 *	HSIC_CTRL_REFCLKSEL(val)	((val&0x3) << 23)
 *	HSIC_CTRL_PHYSWRST	(0x1 << 0)
 *
 * EXYNOS5_PHY_HOST_OHCICTRL	EXYNOS4_HSOTG_PHYREG(0x34)
 * 	OHCICTRL_SUSPLGCY	(0x1 << 3)
 */

}

/*
 * For the USB3503A these are the details
 * NRESET	XE.INT12	GPX1_4
 * HUB_CONNECT	XE.INT6		GPX0_6
 * NINT		XE.INT7		GPX0_7
 * From the Exynos5(250) manual I see these base addresses:
 * 	GPX0BASE	(0x13400C00)
 * 	GPX1BASE	(0x13400C20)
 */

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

void usb_eth_init() {
	/* Turn off and turn on the power to LAN9730 - LDO 25 */
#if defined(CONFIG_BOARD_HARDKERNEL) && defined(CONFIG_EXYNOS4412)
	mdelay(10);
	max77686_update_reg(0x37, 0x0, 0x3F); /* 0V */
	mdelay(10);
	max77686_update_reg(0x37, 0x33, 0x3F); /* 3.3V */
	mdelay(10);
	max77686_update_reg(0x36, 0x3, 0x3); /*ON val=3, mask=4*/
	mdelay(10);
#else
	unsigned char rdata;

	IIC0_ERead (0x09, 0x78, &rdata);
	IIC0_EWrite(0x09, 0x78, rdata & ~0xC0);
	udelay(10);

	IIC0_ERead(0x09, 0x78, &rdata);
	IIC0_EWrite(0x09, 0x78, rdata | 0xC0);
#endif
}

void usb_hub_init () {
        u32     a, val, i2c_dat;
	int clk_inv;

#define	GPX0BASE ((void *) (0x13400C00))
#define GPX1BASE ((void *) (0x13400C20))

        /* Start */
        s_gpio_direction_output(GPX1BASE, 4, 0);
        s_gpio_set_value(GPX1BASE, 4, 0);
        mdelay(10);

        clk_inv = getenv_yesno("usb_invert_clken");
        printf("usb: usb_refclk_enable is active low: %s\n", clk_inv ? "NO" : "YES");
        printf("ProTIP: If usb doesn't work - try playing with 'usb_invert_clken' environment\n");

        /* RefCLK 24MHz INTN pin low */
        s_gpio_direction_output(GPX0BASE, 7, 0);
        s_gpio_set_value(GPX0BASE, 7, clk_inv);
        mdelay(10);

	/* HUB CONNECT low */
        s_gpio_direction_output(GPX0BASE, 6, 0);
        s_gpio_set_value(GPX0BASE, 6, 0);
        mdelay(10);

        // RESET pin set to 1
        s_gpio_set_value(GPX1BASE, 4, 1);

	// Hub Wait RefClk stage
	mdelay(10);

        // Set CONNECT to 1 to move to hub configure phase.
	s_gpio_set_value(GPX0BASE, 6, 1);
	mdelay(10);

	// Make INT line as input.
	s_gpio_direction_input(GPX0BASE, 7);
	mdelay(10);
}

/*
 * EHCI-initialization
 * Create the appropriate control structures to manage
 * a new EHCI host controller.
 */
int ehci_hcd_init(int index, enum usb_init_type init,
		struct ehci_hccr **hccr, struct ehci_hcor **hcor)
{
	struct exynos_ehci *ctx = &exynos;

#ifdef CONFIG_OF_CONTROL
	if (exynos_usb_parse_dt(gd->fdt_blob, ctx)) {
		debug("Unable to parse device tree for ehci-exynos\n");
		return -ENODEV;
	}
#else
	ctx->usb = (struct exynos_usb_phy *)samsung_get_base_usb_phy();
	ctx->hcd = (struct ehci_hccr *)samsung_get_base_usb_ehci();
#endif

#ifdef CONFIG_OF_CONTROL
	/* setup the Vbus gpio here */
	if (!fdtdec_setup_gpio(&ctx->vbus_gpio))
		gpio_direction_output(ctx->vbus_gpio.gpio, 1);
#endif

	setup_usb_phy(ctx->usb);

	*hccr = ctx->hcd;
	*hcor = (struct ehci_hcor *)((uint32_t) *hccr
				+ HC_LENGTH(ehci_readl(&(*hccr)->cr_capbase)));

	debug("Exynos5-ehci: init hccr %x and hcor %x hc_length %d\n",
		(uint32_t)*hccr, (uint32_t)*hcor,
		(uint32_t)HC_LENGTH(ehci_readl(&(*hccr)->cr_capbase)));

	usb_eth_init();
	usb_hub_init();
	return 0;
}

/*
 * Destroy the appropriate control structures corresponding
 * the EHCI host controller.
 */
int ehci_hcd_stop(int index)
{
	struct exynos_ehci *ctx = &exynos;

	reset_usb_phy(ctx->usb);
	usb_eth_init();
	usb_hub_init();

	return 0;
}
