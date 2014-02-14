#include <usb/s3c_udc.h>

void s5pc210_phy_control(int a) {
}

#define EXYNOS4X12_USBPHY_BASE          0x125B0000
#define EXYNOS4X12_USBOTG_BASE          0x12480000
#define EXYNOS4X12_USBPHY_CONTROL       0x10020704

struct s3c_plat_otg_data s5pc210_otg_data = {
	.phy_control	= s5pc210_phy_control,
	.regs_phy	= EXYNOS4X12_USBPHY_BASE,
	.regs_otg	= EXYNOS4X12_USBOTG_BASE,
	.usb_phy_ctrl	= EXYNOS4X12_USBPHY_CONTROL,
	.usb_flags	= PHY0_SLEEP,
};

#ifdef CONFIG_USB_CABLE_CHECK
int usb_cable_connected(void) {
u32 tmp;

	tmp = readl(S5P_OTG_GOTGCTL);
	if (tmp & (B_SESSION_VALID|A_SESSION_VALID))
		return(1);
	else
		return(0);
}
#endif
