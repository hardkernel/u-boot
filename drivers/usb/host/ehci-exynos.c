/*
 * Copyright (c) 2013, Suriyan Ramasami <suriyan.r@gmail.com>
 *
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation version 2 of
 * the License.
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
#include <errno.h>
#include <asm/byteorder.h>
#include <asm/unaligned.h>
#include <usb.h>
#include <asm/io.h>
#include <malloc.h>
#include <watchdog.h>
#include <linux/compiler.h>

#include "ehci.h"

/* Declare global data pointer */
DECLARE_GLOBAL_DATA_PTR;

/*
 * Contains pointers to register base addresses
 * for the usb controller.
 */
struct exynos_ehci {
        struct exynos_usb_phy *usb;
        struct ehci_hccr *hcd;
};

static struct exynos_ehci exynos;

/* Empty functions - We dont have D-Cache enabled */
void flush_dcache_range(unsigned long start, unsigned long stop) {}
void invalidate_dcache_range(unsigned long start, unsigned long stop) {}

#define con_4bit_shift(__off) ((__off) * 4)

#define GPIOCON_OFF (0x00)
#define GPIODAT_OFF (0x04)
#define GPIOPUD_OFF (0x08)

static int gpio_direction_output(void *base, unsigned int offset, int value)
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

static int gpio_direction_input(void *base, unsigned offset)
{
        unsigned long con;

        con = __raw_readl(base + GPIOCON_OFF);
	con &= ~(0xf << con_4bit_shift(offset));
        __raw_writel(con, base + GPIOCON_OFF);

        return 0;
}

static void gpio_set_value(void *base, unsigned offset, int value)
{
        unsigned long dat;

        dat = __raw_readl(base + 0x04);
        dat &= ~(1 << offset);
        if (value)
                dat |= 1 << offset;
        __raw_writel(dat, base + 0x04);
}

int ehci_hcd_init(int index, struct ehci_hccr **hccr, struct ehci_hcor **hcor)
{
struct exynos_ehci *ctx = &exynos;

u32     phypwr, phyclk, rstcon, a;

	ctx->usb = (struct exynos_usb_phy *) 0x125B0000;
	ctx->hcd = (struct ehci_hccr *) 0x12580000;

	/* odroid linux - arch/arm/mach-exynos/setup-usb-phy.c */
        /*
	set XuhostOVERCUR to in-active by controlling ET6PUD[15:14]
	0x0 : pull-up/down disabled
	0x1 : pull-down enabled
	0x2 : reserved
	0x3 : pull-up enabled
	*/
#define ETC6PUD 0x11000228
	writel((__raw_readl(ETC6PUD) & ~(0x3 << 14)) | (0x3 << 14), ETC6PUD);
	rstcon = __raw_readl(ETC6PUD);

#define S5P_USB_PHY_CONTROL     0x10020704
#define S5P_HSIC_1_PHY_CONTROL  0x10020708
#define S5P_HSIC_2_PHY_CONTROL  0x1002070C
        a = 1;
        writel(a, S5P_USB_PHY_CONTROL); // This is what gives us the right hcd
        writel(a, S5P_HSIC_1_PHY_CONTROL);
        writel(a, S5P_HSIC_2_PHY_CONTROL);

#define EXYNOS4_PHYPWR  0x125B0000
#define EXYNOS4_PHYCLK  0x125B0004
#define EXYNOS4_RSTCON  0x125B0008
        phyclk = 5;
        writel(phyclk, EXYNOS4_PHYCLK);
	rstcon = __raw_readl(EXYNOS4_PHYCLK);

        /* set to normal of Device */
#define PHY0_NORMAL_MASK                (0x39 << 0)
	phypwr = readl(EXYNOS4_PHYPWR) & ~PHY0_NORMAL_MASK;
	writel(phypwr, EXYNOS4_PHYPWR);

	/* set to normal of Host */
        phypwr = readl(EXYNOS4_PHYPWR);

#define PHY1_STD_NORMAL_MASK            (0x7 << 6)
#define EXYNOS4X12_HSIC0_NORMAL_MASK            (0x7 << 9)
#define EXYNOS4X12_HSIC1_NORMAL_MASK            (0x7 << 12)
        phypwr &= ~(PHY1_STD_NORMAL_MASK
                | EXYNOS4X12_HSIC0_NORMAL_MASK | EXYNOS4X12_HSIC1_NORMAL_MASK);
        writel(phypwr, EXYNOS4_PHYPWR);

	/* reset both PHY and Link of Device */
#define PHY0_SWRST_MASK                 (0x7 << 0)
        rstcon = readl(EXYNOS4_RSTCON) | PHY0_SWRST_MASK;
        writel(rstcon, EXYNOS4_RSTCON);

        udelay(10);
        rstcon &= ~PHY0_SWRST_MASK;
        writel(rstcon, EXYNOS4_RSTCON);

        /* reset both PHY and Link of Host */
#define EXYNOS4X12_HOST_LINK_PORT_SWRST_MASK    (0xf << 7)
#define EXYNOS4X12_PHY1_SWRST_MASK              (0xf << 3)
        rstcon = readl(EXYNOS4_RSTCON)
                | EXYNOS4X12_HOST_LINK_PORT_SWRST_MASK
                | EXYNOS4X12_PHY1_SWRST_MASK;
        writel(rstcon, EXYNOS4_RSTCON);

        udelay(10);
        rstcon &= ~(EXYNOS4X12_HOST_LINK_PORT_SWRST_MASK
                | EXYNOS4X12_PHY1_SWRST_MASK);

        writel(rstcon, EXYNOS4_RSTCON);

        udelay(80);

        *hccr = ctx->hcd;
        *hcor = (struct ehci_hcor *)((uint32_t) *hccr
                                + HC_LENGTH(ehci_readl(&(*hccr)->cr_capbase)));
        printf("Exynos4412-ehci: init hccr %x and hcor %x hc_length %d\n",
                (uint32_t)*hccr, (uint32_t)*hcor,
                (uint32_t)HC_LENGTH(ehci_readl(&(*hccr)->cr_capbase)));
        mdelay(10);
	usb_hub_init();
	return 0;
}

void usb_hub_init () {

#define GPX3BASE ((void *) (0x11000C60))

	/* Start */
	gpio_direction_output(GPX3BASE, 5, 0);
	gpio_set_value(GPX3BASE, 5, 0);
	mdelay(10);

	/* RefCLK 24MHz */
	gpio_direction_output(GPX3BASE, 0, 0);
	gpio_set_value(GPX3BASE, 0, 0);
	mdelay(10);

	gpio_direction_output(GPX3BASE, 4, 0);
	gpio_set_value(GPX3BASE, 4, 0);
	mdelay(10);

	// RESET pin set to 1
	gpio_set_value(GPX3BASE, 5, 1);

	// Hub Wait RefClk stage
	mdelay(10);

	// Set CONNECT to 1 to move to hub configure phase.
	gpio_set_value(GPX3BASE, 4, 1);
	mdelay(10);

	// Make INT line as input.
	gpio_direction_input(GPX3BASE, 0);
	mdelay(10);
}

int ehci_hcd_stop(int index)
{
int a = 0;
u32 phypwr;

	/* unset to normal of Device */
        writel((readl(EXYNOS4_PHYPWR) | PHY0_NORMAL_MASK),
                        EXYNOS4_PHYPWR);

        /* unset to normal of Host */
        phypwr = readl(EXYNOS4_PHYPWR)
                | PHY1_STD_NORMAL_MASK
                | EXYNOS4X12_HSIC0_NORMAL_MASK
                | EXYNOS4X12_HSIC1_NORMAL_MASK;
        writel(phypwr, EXYNOS4_PHYPWR);

	writel(a, S5P_USB_PHY_CONTROL);
        writel(a, S5P_HSIC_1_PHY_CONTROL);
        writel(a, S5P_HSIC_2_PHY_CONTROL);
        return 0;
}
