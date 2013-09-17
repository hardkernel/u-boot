/*
 * Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */


#ifndef _EXYNOS_USB2_H
#define _EXYNOS_USB2_H

/*
 * SYSREG
 */
#define USB_CFG_REG			(EXYNOS_SYSREG_BASE + USB_CFG_OFFSET)
#if defined(CONFIG_CPU_EXYNOS5250)
#define USB_CFG_OFFSET			0x230
#else
#define USB_CFG_OFFSET			0x21C
#endif

/* USBD 2.0 SFR */
#if defined(EXYNOS_USB_LINK_BASE)
#define USBOTG_LINK_BASE		(EXYNOS_USB_LINK_BASE)
#else
#define USBOTG_LINK_BASE		(0x12480000) //(0xEC000000)
#endif

#if defined(EXYNOS_USB_LINK_BASE)
#define USBOTG_PHY_BASE			(EXYNOS_USB_PHY_BASE)
#else
#define USBOTG_PHY_BASE			(0x125B0000) //(0xEC100000)
#endif

/* R/W OTG PHY Power Control Register */
#define EXYNOS5_OTG_SYS	 		(USBOTG_PHY_BASE + 0x038)

#if defined(CONFIG_CPU_EXYNOS5250)
#define USB_PHY_CONTROL_OFFSET		0x0708
#define USB_PHY_CONTROL                 (EXYNOS_POWER_BASE + USB_PHY_CONTROL_OFFSET)
#else
#define USB_PHY_CONTROL_OFFSET		0x0704
#define USB_PHY_CONTROL                 (0x10020000 + USB_PHY_CONTROL_OFFSET)
#endif

/* PENDING BIT */
#define BIT_EINT0			(0x1)
#define BIT_EINT1			(0x1<<1)
#define BIT_EINT2			(0x1<<2)
#define BIT_EINT3			(0x1<<3)
#define BIT_EINT4_7			(0x1<<4)
#define BIT_EINT8_23			(0x1<<5)
#define BIT_BAT_FLT			(0x1<<7)
#define BIT_TICK			(0x1<<8)
#define BIT_WDT				(0x1<<9)
#define BIT_TIMER0			(0x1<<10)
#define BIT_TIMER1			(0x1<<11)
#define BIT_TIMER2			(0x1<<12)
#define BIT_TIMER3			(0x1<<13)
#define BIT_TIMER4			(0x1<<14)
#define BIT_UART2			(0x1<<15)
#define BIT_LCD				(0x1<<16)
#define BIT_DMA0			(0x1<<17)
#define BIT_DMA1			(0x1<<18)
#define BIT_DMA2			(0x1<<19)
#define BIT_DMA3			(0x1<<20)
#define BIT_SDI				(0x1<<21)
#define BIT_SPI0			(0x1<<22)
#define BIT_UART1			(0x1<<23)
#define BIT_USBH			(0x1<<26)
#define BIT_IIC				(0x1<<27)
#define BIT_UART0			(0x1<<28)
#define BIT_SPI1			(0x1<<29)
#define BIT_RTC				(0x1<<30)
#define BIT_ADC				(0x1<<31)
#define BIT_ALLMSK			(0xFFFFFFFF)

/*
 * USB2.0 HS OTG (Chapter 26)
 */

#define S5P_OTG_PHYPWR	 		(USBOTG_PHY_BASE + 0x000) /* R/W OTG PHY Power Control Register */
#define S5P_OTG_PHYCLK 			(USBOTG_PHY_BASE + 0x004) /* R/W OTG PHY Clock Control Register */
#define S5P_OTG_RSTCON 			(USBOTG_PHY_BASE + 0x008) /* R/W OTG Reset Control Register */
#define S5P_OTG_PHYTUNE0 		(USBOTG_PHY_BASE + 0x020) /* R/W OTG PHY0 Tuning Register */
#define S5P_OTG_PHYTUNE1 		(USBOTG_PHY_BASE + 0x024) /* R/W OTG PHY1 Tuning Register */

/* Core Global Register */
#define S5P_OTG_GOTGCTL 		(USBOTG_LINK_BASE + 0x000) /* R/W OTG Control and Status Register */
#define S5P_OTG_GOTGINT 		(USBOTG_LINK_BASE + 0x004) /* R/W OTG Interrupt Register */
#define S5P_OTG_GAHBCFG 		(USBOTG_LINK_BASE + 0x008) /* R/W Core AHB Configuration Register */
#define S5P_OTG_GUSBCFG 		(USBOTG_LINK_BASE + 0x00C) /* R/W Core USB Configuration Register */
#define S5P_OTG_GRSTCTL 		(USBOTG_LINK_BASE + 0x010) /* R/W Core Reset Register */
#define S5P_OTG_GINTSTS 		(USBOTG_LINK_BASE + 0x014) /* R/W Core Interrupt Register */
#define S5P_OTG_GINTMSK 		(USBOTG_LINK_BASE + 0x018) /* R/W Core Interrupt Mask Register */
#define S5P_OTG_GRXSTSR 		(USBOTG_LINK_BASE + 0x01C) /* R Receive Status Debug Read Register */
#define S5P_OTG_GRXSTSP 		(USBOTG_LINK_BASE + 0x020) /* R Receive Status Read/Pop Register */
#define S5P_OTG_GRXFSIZ 		(USBOTG_LINK_BASE + 0x024) /* R/W Receive FIFO Size Register */
#define S5P_OTG_GNPTXFSIZ 		(USBOTG_LINK_BASE + 0x028) /* R/W Non-Periodic Transmit FIFO Size Register */
#define S5P_OTG_GNPTXSTS 		(USBOTG_LINK_BASE + 0x02C) /* R Non-Periodic Transmit FIFO/Queue Status Register */
#define S5P_OTG_HPTXFSIZ 		(USBOTG_LINK_BASE + 0x100) /* R/W Host Periodic Transmit FIFO Size Register */
#define S5P_OTG_DPTXFSIZ1 		(USBOTG_LINK_BASE + 0x104) /* R/W Device Periodic Transmit FIFO-1 Size Register */
#define S5P_OTG_DPTXFSIZ2 		(USBOTG_LINK_BASE + 0x108) /* R/W Device Periodic Transmit FIFO-2 Size Register */
#define S5P_OTG_DPTXFSIZ3 		(USBOTG_LINK_BASE + 0x10C) /* R/W Device Periodic Transmit FIFO-3 Size Register */
#define S5P_OTG_DPTXFSIZ4 		(USBOTG_LINK_BASE + 0x110) /* R/W Device Periodic Transmit FIFO-4 Size Register */
#define S5P_OTG_DPTXFSIZ5 		(USBOTG_LINK_BASE + 0x114) /* R/W Device Periodic Transmit FIFO-5 Size Register */
#define S5P_OTG_DPTXFSIZ6 		(USBOTG_LINK_BASE + 0x118) /* R/W Device Periodic Transmit FIFO-6 Size Register */
#define S5P_OTG_DPTXFSIZ7 		(USBOTG_LINK_BASE + 0x11C) /* R/W Device Periodic Transmit FIFO-7 Size Register */
#define S5P_OTG_DPTXFSIZ8 		(USBOTG_LINK_BASE + 0x120) /* R/W Device Periodic Transmit FIFO-8 Size Register */
#define S5P_OTG_DPTXFSIZ9 		(USBOTG_LINK_BASE + 0x124) /* R/W Device Periodic Transmit FIFO-9 Size Register */
#define S5P_OTG_DPTXFSIZ10 		(USBOTG_LINK_BASE + 0x128) /* R/W Device Periodic Transmit FIFO-10 Size Register */
#define S5P_OTG_DPTXFSIZ11 		(USBOTG_LINK_BASE + 0x12C) /* R/W Device Periodic Transmit FIFO-11 Size Register */
#define S5P_OTG_DPTXFSIZ12 		(USBOTG_LINK_BASE + 0x130) /* R/W Device Periodic Transmit FIFO-12 Size Register */
#define S5P_OTG_DPTXFSIZ13 		(USBOTG_LINK_BASE + 0x134) /* R/W Device Periodic Transmit FIFO-13 Size Register */
#define S5P_OTG_DPTXFSIZ14 		(USBOTG_LINK_BASE + 0x138) /* R/W Device Periodic Transmit FIFO-14 Size Register */
#define S5P_OTG_DPTXFSIZ15 		(USBOTG_LINK_BASE + 0x13C) /* R/W Device Periodic Transmit FIFO-15 Size Register */

/* Host Mode Register */
/* Host Global Register */
#define S5P_OTG_HCFG 			(USBOTG_LINK_BASE + 0x400) /* R/W Host Configuration Register */
#define S5P_OTG_HFIR 			(USBOTG_LINK_BASE + 0x404) /* R/W Host Frame Interval Register */
#define S5P_OTG_HFNUM 			(USBOTG_LINK_BASE + 0x408) /* R Host Frame Number/Frame Time Remaining Register */

#define S5P_OTG_HPTXSTS 		(USBOTG_LINK_BASE + 0x410) /* R Host Periodic Transmit FIFO/Queue Status Register */
#define S5P_OTG_HAINT 			(USBOTG_LINK_BASE + 0x414) /* R Host All Channels Interrupt Register */
#define S5P_OTG_HAINTMSK 		(USBOTG_LINK_BASE + 0x418) /* R/W Host All Channels Interrupt Mask Register */

/*Host Port Control and Status Register */
#define S5P_OTG_HPRT 			(USBOTG_LINK_BASE + 0x440) /* R/W Host Port Control and Status Register */

/*Host Channel-Specific Register */
#define S5P_OTG_HCCHAR0 		(USBOTG_LINK_BASE + 0x500) /* R/W Host Channel 0 Characteristics Register */
#define S5P_OTG_HCSPLT0 		(USBOTG_LINK_BASE + 0x504) /* R/W Host Channel 0 Spilt Control Register */
#define S5P_OTG_HCINT0 			(USBOTG_LINK_BASE + 0x508) /* R/W Host Channel 0 Interrupt Register */
#define S5P_OTG_HCINTMSK0 		(USBOTG_LINK_BASE + 0x50C) /* R/W Host Channel 0 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ0 		(USBOTG_LINK_BASE + 0x510) /* R/W Host Channel 0 Transfer Size Register */
#define S5P_OTG_HCDMA0 			(USBOTG_LINK_BASE + 0x514) /* R/W Host Channel 0 DMA Address Register */
#define S5P_OTG_HCCHAR1 		(USBOTG_LINK_BASE + 0x520) /* R/W Host Channel 1 Characteristics Register */
#define S5P_OTG_HCSPLT1 		(USBOTG_LINK_BASE + 0x524) /* R/W Host Channel 1 Spilt Control Register */
#define S5P_OTG_HCINT1 			(USBOTG_LINK_BASE + 0x528) /* R/W Host Channel 1 Interrupt Register */
#define S5P_OTG_HCINTMSK1 		(USBOTG_LINK_BASE + 0x52C) /* R/W Host Channel 1 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ1 		(USBOTG_LINK_BASE + 0x530) /* R/W Host Channel 1 Transfer Size Register */
#define S5P_OTG_HCDMA1 			(USBOTG_LINK_BASE + 0x534) /* R/W Host Channel 1 DMA Address Register */
#define S5P_OTG_HCCHAR2 		(USBOTG_LINK_BASE + 0x540) /* R/W Host Channel 2 Characteristics Register */
#define S5P_OTG_HCSPLT2 		(USBOTG_LINK_BASE + 0x544) /* R/W Host Channel 2 Spilt Control Register */
#define S5P_OTG_HCINT2 			(USBOTG_LINK_BASE + 0x548) /* R/W Host Channel 2 Interrupt Register */
#define S5P_OTG_HCINTMSK2 		(USBOTG_LINK_BASE + 0x54C) /* R/W Host Channel 2 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ2 		(USBOTG_LINK_BASE + 0x550) /* R/W Host Channel 2 Transfer Size Register */
#define S5P_OTG_HCDMA2 			(USBOTG_LINK_BASE + 0x554) /* R/W Host Channel 2 DMA Address Register */
#define S5P_OTG_HCCHAR3 		(USBOTG_LINK_BASE + 0x560) /* R/W Host Channel 3 Characteristics Register */
#define S5P_OTG_HCSPLT3 		(USBOTG_LINK_BASE + 0x564) /* R/W Host Channel 3 Spilt Control Register */
#define S5P_OTG_HCINT3 			(USBOTG_LINK_BASE + 0x568) /* R/W Host Channel 3 Interrupt Register */
#define S5P_OTG_HCINTMSK3 		(USBOTG_LINK_BASE + 0x56C) /* R/W Host Channel 3 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ3 		(USBOTG_LINK_BASE + 0x570) /* R/W Host Channel 3 Transfer Size Register */
#define S5P_OTG_HCDMA3 			(USBOTG_LINK_BASE + 0x574) /* R/W Host Channel 3 DMA Address Register */
#define S5P_OTG_HCCHAR4 		(USBOTG_LINK_BASE + 0x580) /* R/W Host Channel 4 Characteristics Register */
#define S5P_OTG_HCSPLT4 		(USBOTG_LINK_BASE + 0x584) /* R/W Host Channel 4 Spilt Control Register */
#define S5P_OTG_HCINT4 			(USBOTG_LINK_BASE + 0x588) /* R/W Host Channel 4 Interrupt Register */
#define S5P_OTG_HCINTMSK4 		(USBOTG_LINK_BASE + 0x58C) /* R/W Host Channel 4 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ4 		(USBOTG_LINK_BASE + 0x580) /* R/W Host Channel 4 Transfer Size Register */
#define S5P_OTG_HCDMA4 			(USBOTG_LINK_BASE + 0x584) /* R/W Host Channel 4 DMA Address Register */
#define S5P_OTG_HCCHAR5 		(USBOTG_LINK_BASE + 0x5A0) /* R/W Host Channel 5 Characteristics Register */
#define S5P_OTG_HCSPLT5 		(USBOTG_LINK_BASE + 0x5A4) /* R/W Host Channel 5 Spilt Control Register */
#define S5P_OTG_HCINT5 			(USBOTG_LINK_BASE + 0x5A8) /* R/W Host Channel 5 Interrupt Register */
#define S5P_OTG_HCINTMSK5 		(USBOTG_LINK_BASE + 0x5AC) /* R/W Host Channel 5 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ5 		(USBOTG_LINK_BASE + 0x5B0) /* R/W Host Channel 5 Transfer Size Register */
#define S5P_OTG_HCDMA5 			(USBOTG_LINK_BASE + 0x5B4) /* R/W Host Channel 5 DMA Address Register */
#define S5P_OTG_HCCHAR6 		(USBOTG_LINK_BASE + 0x5C0) /* R/W Host Channel 6 Characteristics Register */
#define S5P_OTG_HCSPLT6 		(USBOTG_LINK_BASE + 0x5C4) /* R/W Host Channel 6 Spilt Control Register */
#define S5P_OTG_HCINT6 			(USBOTG_LINK_BASE + 0x5C8) /* R/W Host Channel 6 Interrupt Register */
#define S5P_OTG_HCINTMSK6 		(USBOTG_LINK_BASE + 0x5CC) /* R/W Host Channel 6 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ6 		(USBOTG_LINK_BASE + 0x5D0) /* R/W Host Channel 6 Transfer Size Register */
#define S5P_OTG_HCDMA6 			(USBOTG_LINK_BASE + 0x5D4) /* R/W Host Channel 6 DMA Address Register */
#define S5P_OTG_HCCHAR7 		(USBOTG_LINK_BASE + 0x5E0) /* R/W Host Channel 7 Characteristics Register */
#define S5P_OTG_HCSPLT7 		(USBOTG_LINK_BASE + 0x5E4) /* R/W Host Channel 7 Spilt Control Register */
#define S5P_OTG_HCINT7 			(USBOTG_LINK_BASE + 0x5E8) /* R/W Host Channel 7 Interrupt Register */
#define S5P_OTG_HCINTMSK7 		(USBOTG_LINK_BASE + 0x5EC) /* R/W Host Channel 7 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ7 		(USBOTG_LINK_BASE + 0x5F0) /* R/W Host Channel 7 Transfer Size Register */
#define S5P_OTG_HCDMA7 			(USBOTG_LINK_BASE + 0x5F4) /* R/W Host Channel 7 DMA Address Register */
#define S5P_OTG_HCCHAR8 		(USBOTG_LINK_BASE + 0x600) /* R/W Host Channel 8 Characteristics Register */
#define S5P_OTG_HCSPLT8 		(USBOTG_LINK_BASE + 0x604) /* R/W Host Channel 8 Spilt Control Register */
#define S5P_OTG_HCINT8 			(USBOTG_LINK_BASE + 0x608) /* R/W Host Channel 8 Interrupt Register */
#define S5P_OTG_HCINTMSK8 		(USBOTG_LINK_BASE + 0x60C) /* R/W Host Channel 8 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ8 		(USBOTG_LINK_BASE + 0x610) /* R/W Host Channel 8 Transfer Size Register */
#define S5P_OTG_HCDMA8 			(USBOTG_LINK_BASE + 0x614) /* R/W Host Channel 8 DMA Address Register */
#define S5P_OTG_HCCHAR9 		(USBOTG_LINK_BASE + 0x620) /* R/W Host Channel 9 Characteristics Register */
#define S5P_OTG_HCSPLT9 		(USBOTG_LINK_BASE + 0x624) /* R/W Host Channel 9 Spilt Control Register */
#define S5P_OTG_HCINT9 			(USBOTG_LINK_BASE + 0x628) /* R/W Host Channel 9 Interrupt Register */
#define S5P_OTG_HCINTMSK9 		(USBOTG_LINK_BASE + 0x62C) /* R/W Host Channel 9 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ9 		(USBOTG_LINK_BASE + 0x630) /* R/W Host Channel 9 Transfer Size Register */
#define S5P_OTG_HCDMA9 			(USBOTG_LINK_BASE + 0x634) /* R/W Host Channel 9 DMA Address Register */
#define S5P_OTG_HCCHAR10 		(USBOTG_LINK_BASE + 0x640) /* R/W Host Channel 10 Characteristics Register */
#define S5P_OTG_HCSPLT10 		(USBOTG_LINK_BASE + 0x644) /* R/W Host Channel 10 Spilt Control Register */
#define S5P_OTG_HCINT10 		(USBOTG_LINK_BASE + 0x648) /* R/W Host Channel 10 Interrupt Register */
#define S5P_OTG_HCINTMSK10 		(USBOTG_LINK_BASE + 0x64C) /* R/W Host Channel 10 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ10 		(USBOTG_LINK_BASE + 0x650) /* R/W Host Channel 10 Transfer Size Register */
#define S5P_OTG_HCDMA10 		(USBOTG_LINK_BASE + 0x654) /* R/W Host Channel 10 DMA Address Register */
#define S5P_OTG_HCCHAR11 		(USBOTG_LINK_BASE + 0x660) /* R/W Host Channel 11 Characteristics Register */
#define S5P_OTG_HCSPLT11 		(USBOTG_LINK_BASE + 0x664) /* R/W Host Channel 11 Spilt Control Register */
#define S5P_OTG_HCINT11 		(USBOTG_LINK_BASE + 0x668) /* R/W Host Channel 11 Interrupt Register */
#define S5P_OTG_HCINTMSK11 		(USBOTG_LINK_BASE + 0x66C) /* R/W Host Channel 11 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ11 		(USBOTG_LINK_BASE + 0x670) /* R/W Host Channel 11 Transfer Size Register */
#define S5P_OTG_HCDMA11 		(USBOTG_LINK_BASE + 0x674) /* R/W Host Channel 11 DMA Address Register */
#define S5P_OTG_HCCHAR12 		(USBOTG_LINK_BASE + 0x680) /* R/W Host Channel 12 Characteristics Register */
#define S5P_OTG_HCSPLT12 		(USBOTG_LINK_BASE + 0x684) /* R/W Host Channel 12 Spilt Control Register */
#define S5P_OTG_HCINT12 		(USBOTG_LINK_BASE + 0x688) /* R/W Host Channel 12 Interrupt Register */
#define S5P_OTG_HCINTMSK12 		(USBOTG_LINK_BASE + 0x68C) /* R/W Host Channel 12 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ12 		(USBOTG_LINK_BASE + 0x690) /* R/W Host Channel 12 Transfer Size Register */
#define S5P_OTG_HCDMA12 		(USBOTG_LINK_BASE + 0x694) /* R/W Host Channel 12 DMA Address Register */
#define S5P_OTG_HCCHAR13 		(USBOTG_LINK_BASE + 0x6A0) /* R/W Host Channel 13 Characteristics Register */
#define S5P_OTG_HCSPLT13 		(USBOTG_LINK_BASE + 0x6A4) /* R/W Host Channel 13 Spilt Control Register */
#define S5P_OTG_HCINT13 		(USBOTG_LINK_BASE + 0x6A8) /* R/W Host Channel 13 Interrupt Register */
#define S5P_OTG_HCINTMSK13 		(USBOTG_LINK_BASE + 0x6AC) /* R/W Host Channel 13 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ13 		(USBOTG_LINK_BASE + 0x6B0) /* R/W Host Channel 13 Transfer Size Register */
#define S5P_OTG_HCDMA13 		(USBOTG_LINK_BASE + 0x6B4) /* R/W Host Channel 13 DMA Address Register */
#define S5P_OTG_HCCHAR14 		(USBOTG_LINK_BASE + 0x6C0) /* R/W Host Channel 14 Characteristics Register */
#define S5P_OTG_HCSPLT14 		(USBOTG_LINK_BASE + 0x6C4) /* R/W Host Channel 14 Spilt Control Register */
#define S5P_OTG_HCINT14 		(USBOTG_LINK_BASE + 0x6C8) /* R/W Host Channel 14 Interrupt Register */
#define S5P_OTG_HCINTMSK14 		(USBOTG_LINK_BASE + 0x6CC) /* R/W Host Channel 14 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ14	 	(USBOTG_LINK_BASE + 0x6D0) /* R/W Host Channel 14 Transfer Size Register */
#define S5P_OTG_HCDMA14 		(USBOTG_LINK_BASE + 0x6D4) /* R/W Host Channel 14 DMA Address Register */
#define S5P_OTG_HCCHAR15 		(USBOTG_LINK_BASE + 0x6E0) /* R/W Host Channel 15 Characteristics Register */
#define S5P_OTG_HCSPLT15 		(USBOTG_LINK_BASE + 0x6E4) /* R/W Host Channel 15 Spilt Control Register */
#define S5P_OTG_HCINT15 		(USBOTG_LINK_BASE + 0x6E8) /* R/W Host Channel 15 Interrupt Register */
#define S5P_OTG_HCINTMSK15 		(USBOTG_LINK_BASE + 0x6EC) /* R/W Host Channel 15 Interrupt Mask Register */
#define S5P_OTG_HCTSIZ15 		(USBOTG_LINK_BASE + 0x6F0) /* R/W Host Channel 15 Transfer Size Register */
#define S5P_OTG_HCDMA15 		(USBOTG_LINK_BASE + 0x6F4) /* R/W Host Channel 15 DMA Address Register */

/* Device Global Register */
#define S5P_OTG_DCFG 			(USBOTG_LINK_BASE + 0x800) /* R/W Device Configuration Register */
#define S5P_OTG_DCTL 			(USBOTG_LINK_BASE + 0x804) /* R/W Device Control Register */
#define S5P_OTG_DSTS 			(USBOTG_LINK_BASE + 0x808) /* R Device Status Register */
#define S5P_OTG_DIEPMSK 		(USBOTG_LINK_BASE + 0x810) /* R/W Device IN Endpoint Common Interrupt Mask Register */
#define S5P_OTG_DOEPMSK 		(USBOTG_LINK_BASE + 0x814) /* R/W Device OUT Endpoint Common Interrupt Mask Register */
#define S5P_OTG_DAINT 			(USBOTG_LINK_BASE + 0x818) /* R Device ALL Endpoints Interrupt Register */
#define S5P_OTG_DAINTMSK 		(USBOTG_LINK_BASE + 0x81C) /* R/W Device ALL Endpoints Interrupt Mask Register */
#define S5P_OTG_DTKNQR1 		(USBOTG_LINK_BASE + 0x820) /* R Device IN Token Sequence Learning Queue Read Register */
#define S5P_OTG_DTKNQR2 		(USBOTG_LINK_BASE + 0x824) /* R Device IN Token Sequence Learning Queue Read Register */
#define S5P_OTG_DVBUSDIS 		(USBOTG_LINK_BASE + 0x828) /* R/W Device VBUS Discharge Time Register */
#define S5P_OTG_DVBUSPULSE 		(USBOTG_LINK_BASE + 0x82C) /* R/W Device VBUS Pulsing Time Register */
#define S5P_OTG_DTKNQR3 		(USBOTG_LINK_BASE + 0x830) /* R Device IN Token Sequence Learning Queue Read Register */
#define S5P_OTG_DTKNQR4 		(USBOTG_LINK_BASE + 0x834) /* R Device IN Token Sequence Learning Queue Read Register */

/* Device Logical IN Endpo int-Specific Registers */
#define S5P_OTG_DIEPCTL0 		(USBOTG_LINK_BASE + 0x900) /* R/W Device Control IN Endpoint 0 Control Register */
#define S5P_OTG_DIEPINT0 		(USBOTG_LINK_BASE + 0x908) /* R/W Device IN Endpoint 0 Interrupt Register */
#define S5P_OTG_DIEPTSIZ0 		(USBOTG_LINK_BASE + 0x910) /* R/W Device IN Endpoint 0 Transfer Size Register */
#define S5P_OTG_DIEPDMA0 		(USBOTG_LINK_BASE + 0x914) /* R/W Device IN Endpoint 0 DMA Address Register */
#define S5P_OTG_DIEPCTL1 		(USBOTG_LINK_BASE + 0x920) /* R/W Device Control IN Endpoint 1 Control Register */
#define S5P_OTG_DIEPINT1 		(USBOTG_LINK_BASE + 0x928) /* R/W Device IN Endpoint 1 Interrupt Register */
#define S5P_OTG_DIEPTSIZ1 		(USBOTG_LINK_BASE + 0x930) /* R/W Device IN Endpoint 1 Transfer Size Register */
#define S5P_OTG_DIEPDMA1 		(USBOTG_LINK_BASE + 0x934) /* R/W Device IN Endpoint 1 DMA Address Register */
#define S5P_OTG_DIEPCTL2 		(USBOTG_LINK_BASE + 0x940) /* R/W Device Control IN Endpoint 2 Control Register */
#define S5P_OTG_DIEPINT2 		(USBOTG_LINK_BASE + 0x948) /* R/W Device IN Endpoint 2 Interrupt Register */
#define S5P_OTG_DIEPTSIZ2 		(USBOTG_LINK_BASE + 0x950) /* R/W Device IN Endpoint 2 Transfer Size Register */
#define S5P_OTG_DIEPDMA2 		(USBOTG_LINK_BASE + 0x954) /* R/W Device IN Endpoint 2 DMA Address Register */
#define S5P_OTG_DIEPCTL3 		(USBOTG_LINK_BASE + 0x960) /* R/W Device Control IN Endpoint 3 Control Register */
#define S5P_OTG_DIEPINT3 		(USBOTG_LINK_BASE + 0x968) /* R/W Device IN Endpoint 3 Interrupt Register */
#define S5P_OTG_DIEPTSIZ3 		(USBOTG_LINK_BASE + 0x970) /* R/W Device IN Endpoint 3 Transfer Size Register */
#define S5P_OTG_DIEPDMA3 		(USBOTG_LINK_BASE + 0x974) /* R/W Device IN Endpoint 3 DMA Address Register */
#define S5P_OTG_DIEPCTL4 		(USBOTG_LINK_BASE + 0x980) /* R/W Device Control IN Endpoint 0 Control Register */
#define S5P_OTG_DIEPINT4 		(USBOTG_LINK_BASE + 0x988) /* R/W Device IN Endpoint 4 Interrupt Register */
#define S5P_OTG_DIEPTSIZ4 		(USBOTG_LINK_BASE + 0x990) /* R/W Device IN Endpoint 4 Transfer Size Register */
#define S5P_OTG_DIEPDMA4 		(USBOTG_LINK_BASE + 0x994) /* R/W Device IN Endpoint 4 DMA Address Register */
#define S5P_OTG_DIEPCTL5 		(USBOTG_LINK_BASE + 0x9A0) /* R/W Device Control IN Endpoint 5 Control Register */
#define S5P_OTG_DIEPINT5 		(USBOTG_LINK_BASE + 0x9A8) /* R/W Device IN Endpoint 5 Interrupt Register */
#define S5P_OTG_DIEPTSIZ5 		(USBOTG_LINK_BASE + 0x9B0) /* R/W Device IN Endpoint 5 Transfer Size Register */
#define S5P_OTG_DIEPDMA5 		(USBOTG_LINK_BASE + 0x9B4) /* R/W Device IN Endpoint 5 DMA Address Register */
#define S5P_OTG_DIEPCTL6 		(USBOTG_LINK_BASE + 0x9C0) /* R/W Device Control IN Endpoint 6 Control Register */
#define S5P_OTG_DIEPINT6		(USBOTG_LINK_BASE + 0x9C8) /* R/W Device IN Endpoint 6 Interrupt Register */
#define S5P_OTG_DIEPTSIZ6		(USBOTG_LINK_BASE + 0x9D0) /* R/W Device IN Endpoint 6 Transfer Size Register */
#define S5P_OTG_DIEPDMA6		(USBOTG_LINK_BASE + 0x9D4) /* R/W Device IN Endpoint 6 DMA Address Register */
#define S5P_OTG_DIEPCTL7		(USBOTG_LINK_BASE + 0x9E0) /* R/W Device Control IN Endpoint 7 Control Register */
#define S5P_OTG_DIEPINT7		(USBOTG_LINK_BASE + 0x9E8) /* R/W Device IN Endpoint 7 Interrupt Register */
#define S5P_OTG_DIEPTSIZ7		(USBOTG_LINK_BASE + 0x9F0) /* R/W Device IN Endpoint 7 Transfer Size Register */
#define S5P_OTG_DIEPDMA7		(USBOTG_LINK_BASE + 0x9F4) /* R/W Device IN Endpoint 7 DMA Address Register */
#define S5P_OTG_DIEPCTL8		(USBOTG_LINK_BASE + 0xA00) /* R/W Device Control IN Endpoint 8 Control Register */
#define S5P_OTG_DIEPINT8		(USBOTG_LINK_BASE + 0xA08) /* R/W Device IN Endpoint 8 Interrupt Register */
#define S5P_OTG_DIEPTSIZ8		(USBOTG_LINK_BASE + 0xA10) /* R/W Device IN Endpoint 8 Transfer Size Register */
#define S5P_OTG_DIEPDMA8		(USBOTG_LINK_BASE + 0xA14) /* R/W Device IN Endpoint 8 DMA Address Register */
#define S5P_OTG_DIEPCTL9		(USBOTG_LINK_BASE + 0xA20) /* R/W Device Control IN Endpoint 9 Control Register */
#define S5P_OTG_DIEPINT9		(USBOTG_LINK_BASE + 0xA28) /* R/W Device IN Endpoint 9 Interrupt Register */
#define S5P_OTG_DIEPTSIZ9		(USBOTG_LINK_BASE + 0xA30) /* R/W Device IN Endpoint 9 Transfer Size Register */
#define S5P_OTG_DIEPDMA9		(USBOTG_LINK_BASE + 0xA34) /* R/W Device IN Endpoint 9 DMA Address Register */
#define S5P_OTG_DIEPCTL10		(USBOTG_LINK_BASE + 0xA40) /* R/W Device Control IN Endpoint 10 Control Register */
#define S5P_OTG_DIEPINT10		(USBOTG_LINK_BASE + 0xA48) /* R/W Device IN Endpoint 10 Interrupt Register */
#define S5P_OTG_DIEPTSIZ10		(USBOTG_LINK_BASE + 0xA50) /* R/W Device IN Endpoint 10 Transfer Size Register */
#define S5P_OTG_DIEPDMA10		(USBOTG_LINK_BASE + 0xA54) /* R/W Device IN Endpoint 10 DMA Address Register */
#define S5P_OTG_DIEPCTL11		(USBOTG_LINK_BASE + 0xA60) /* R/W Device Control IN Endpoint 11 Control Register */
#define S5P_OTG_DIEPINT11		(USBOTG_LINK_BASE + 0xA68) /* R/W Device IN Endpoint 11 Interrupt Register */
#define S5P_OTG_DIEPTSIZ11		(USBOTG_LINK_BASE + 0xA70) /* R/W Device IN Endpoint 11 Transfer Size Register */
#define S5P_OTG_DIEPDMA11		(USBOTG_LINK_BASE + 0xA74) /* R/W Device IN Endpoint 11 DMA Address Register */
#define S5P_OTG_DIEPCTL12		(USBOTG_LINK_BASE + 0xA80) /* R/W Device Control IN Endpoint 12 Control Register */
#define S5P_OTG_DIEPINT12		(USBOTG_LINK_BASE + 0xA88) /* R/W Device IN Endpoint 12 Interrupt Register */
#define S5P_OTG_DIEPTSIZ12		(USBOTG_LINK_BASE + 0xA90) /* R/W Device IN Endpoint 12 Transfer Size Register */
#define S5P_OTG_DIEPDMA12		(USBOTG_LINK_BASE + 0xA94) /* R/W Device IN Endpoint 12 DMA Address Register */
#define S5P_OTG_DIEPCTL13		(USBOTG_LINK_BASE + 0xAA0) /* R/W Device Control IN Endpoint 13 Control Register */
#define S5P_OTG_DIEPINT13		(USBOTG_LINK_BASE + 0xAA8) /* R/W Device IN Endpoint 13 Interrupt Register */
#define S5P_OTG_DIEPTSIZ13		(USBOTG_LINK_BASE + 0xAB0) /* R/W Device IN Endpoint 13 Transfer Size Register */
#define S5P_OTG_DIEPDMA13		(USBOTG_LINK_BASE + 0xAB4) /* R/W Device IN Endpoint 13 DMA Address Register */
#define S5P_OTG_DIEPCTL14		(USBOTG_LINK_BASE + 0xAC0) /* R/W Device Control IN Endpoint 14 Control Register */
#define S5P_OTG_DIEPINT14		(USBOTG_LINK_BASE + 0xAC8) /* R/W Device IN Endpoint 14 Interrupt Register */
#define S5P_OTG_DIEPTSIZ14		(USBOTG_LINK_BASE + 0xAD0) /* R/W Device IN Endpoint 14 Transfer Size Register */
#define S5P_OTG_DIEPDMA14		(USBOTG_LINK_BASE + 0xAD4) /* R/W Device IN Endpoint 14 DMA Address Register */
#define S5P_OTG_DIEPCTL15		(USBOTG_LINK_BASE + 0xAE0) /* R/W Device Control IN Endpoint 15 Control Register */
#define S5P_OTG_DIEPINT15		(USBOTG_LINK_BASE + 0xAE8) /* R/W Device IN Endpoint 15 Interrupt Register */
#define S5P_OTG_DIEPTSIZ15		(USBOTG_LINK_BASE + 0xAF0) /* R/W Device IN Endpoint 15 Transfer Size Register */
#define S5P_OTG_DIEPDMA15		(USBOTG_LINK_BASE + 0xAF4) /* R/W Device IN Endpoint 15 DMA Address Register */

/* Device Logical OUT Endpoint-Specific Register */
#define S5P_OTG_DOEPCTL0		(USBOTG_LINK_BASE + 0xB00) /* R/W Device Control OUT Endpoint 0 Control Register */
#define S5P_OTG_DOEPINT0		(USBOTG_LINK_BASE + 0xB08) /* R/W Device OUT Endpoint 0 Interrupt Register */
#define S5P_OTG_DOEPTSIZ0		(USBOTG_LINK_BASE + 0xB10) /* R/W Device OUT Endpoint 0 Transfer Size Register */
#define S5P_OTG_DOEPDMA0		(USBOTG_LINK_BASE + 0xB14) /* R/W Device OUT Endpoint 0 DMA Address Register */
#define S5P_OTG_DOEPCTL1		(USBOTG_LINK_BASE + 0xB20) /* R/W Device Control OUT Endpoint 1 Control Register */
#define S5P_OTG_DOEPINT1		(USBOTG_LINK_BASE + 0xB28) /* R/W Device OUT Endpoint 1 Interrupt Register */
#define S5P_OTG_DOEPTSIZ1		(USBOTG_LINK_BASE + 0xB30) /* R/W Device OUT Endpoint 1 Transfer Size Register */
#define S5P_OTG_DOEPDMA1		(USBOTG_LINK_BASE + 0xB34) /* R/W Device OUT Endpoint 1 DMA Address Register */
#define S5P_OTG_DOEPCTL2		(USBOTG_LINK_BASE + 0xB40) /* R/W Device Control OUT Endpoint 2 Control Register */
#define S5P_OTG_DOEPINT2		(USBOTG_LINK_BASE + 0xB48) /* R/W Device OUT Endpoint 2 Interrupt Register */
#define S5P_OTG_DOEPTSIZ2		(USBOTG_LINK_BASE + 0xB50) /* R/W Device OUT Endpoint 2 Transfer Size Register */
#define S5P_OTG_DOEPDMA2		(USBOTG_LINK_BASE + 0xB54) /* R/W Device OUT Endpoint 2 DMA Address Register */
#define S5P_OTG_DOEPCTL3		(USBOTG_LINK_BASE + 0xB60) /* R/W Device Control OUT Endpoint 3 Control Register */
#define S5P_OTG_DOEPINT3		(USBOTG_LINK_BASE + 0xB68) /* R/W Device OUT Endpoint 3 Interrupt Register */
#define S5P_OTG_DOEPTSIZ3		(USBOTG_LINK_BASE + 0xB70) /* R/W Device OUT Endpoint 3 Transfer Size Register */
#define S5P_OTG_DOEPDMA3		(USBOTG_LINK_BASE + 0xB74) /* R/W Device OUT Endpoint 3 DMA Address Register */
#define S5P_OTG_DOEPCTL4		(USBOTG_LINK_BASE + 0xB80) /* R/W Device Control OUT Endpoint 4 Control Register */
#define S5P_OTG_DOEPINT4		(USBOTG_LINK_BASE + 0xB88) /* R/W Device OUT Endpoint 4 Interrupt Register */
#define S5P_OTG_DOEPTSIZ4		(USBOTG_LINK_BASE + 0xB90) /* R/W Device OUT Endpoint 4 Transfer Size Register */
#define S5P_OTG_DOEPDMA4		(USBOTG_LINK_BASE + 0xB94) /* R/W Device OUT Endpoint 4 DMA Address Register */
#define S5P_OTG_DOEPCTL5		(USBOTG_LINK_BASE + 0xBA0) /* R/W Device Control OUT Endpoint 5 Control Register */
#define S5P_OTG_DOEPINT5		(USBOTG_LINK_BASE + 0xBA8) /* R/W Device OUT Endpoint 5 Interrupt Register */
#define S5P_OTG_DOEPTSIZ5		(USBOTG_LINK_BASE + 0xBB0) /* R/W Device OUT Endpoint 5 Transfer Size Register */
#define S5P_OTG_DOEPDMA5		(USBOTG_LINK_BASE + 0xBB4) /* R/W Device OUT Endpoint 5 DMA Address Register */
#define S5P_OTG_DOEPCTL6		(USBOTG_LINK_BASE + 0xBC0) /* R/W Device Control OUT Endpoint 6 Control Register */
#define S5P_OTG_DOEPINT6		(USBOTG_LINK_BASE + 0xBC8) /* R/W Device OUT Endpoint 6 Interrupt Register */
#define S5P_OTG_DOEPTSIZ6		(USBOTG_LINK_BASE + 0xBD0) /* R/W Device OUT Endpoint 6 Transfer Size Register */
#define S5P_OTG_DOEPDMA6		(USBOTG_LINK_BASE + 0xBD4) /* R/W Device OUT Endpoint 6 DMA Address Register */
#define S5P_OTG_DOEPCTL7		(USBOTG_LINK_BASE + 0xBE0) /* R/W Device Control OUT Endpoint 7 Control Register */
#define S5P_OTG_DOEPINT7		(USBOTG_LINK_BASE + 0xBE8) /* R/W Device OUT Endpoint 7 Interrupt Register */
#define S5P_OTG_DOEPTSIZ7		(USBOTG_LINK_BASE + 0xBF0) /* R/W Device OUT Endpoint 7 Transfer Size Register */
#define S5P_OTG_DOEPDMA7		(USBOTG_LINK_BASE + 0xBF4) /* R/W Device OUT Endpoint 7 DMA Address Register */
#define S5P_OTG_DOEPCTL8		(USBOTG_LINK_BASE + 0xC00) /* R/W Device Control OUT Endpoint 8 Control Register */
#define S5P_OTG_DOEPINT8		(USBOTG_LINK_BASE + 0xC08) /* R/W Device OUT Endpoint 8 Interrupt Register */
#define S5P_OTG_DOEPTSIZ8		(USBOTG_LINK_BASE + 0xC10) /* R/W Device OUT Endpoint 8 Transfer Size Register */
#define S5P_OTG_DOEPDMA8		(USBOTG_LINK_BASE + 0xC14) /* R/W Device OUT Endpoint 8 DMA Address Register */
#define S5P_OTG_DOEPCTL9		(USBOTG_LINK_BASE + 0xC20) /* R/W Device Control OUT Endpoint 9 Control Register */
#define S5P_OTG_DOEPINT9		(USBOTG_LINK_BASE + 0xC28) /* R/W Device OUT Endpoint 9 Interrupt Register */
#define S5P_OTG_DOEPTSIZ9		(USBOTG_LINK_BASE + 0xC30) /* R/W Device OUT Endpoint 9 Transfer Size Register */
#define S5P_OTG_DOEPDMA9		(USBOTG_LINK_BASE + 0xC34) /* R/W Device OUT Endpoint 9 DMA Address Register */
#define S5P_OTG_DOEPCTL10		(USBOTG_LINK_BASE + 0xC40) /* R/W Device Control OUT Endpoint 10 Control Register */
#define S5P_OTG_DOEPINT10		(USBOTG_LINK_BASE + 0xC48) /* R/W Device OUT Endpoint 10 Interrupt Register */
#define S5P_OTG_DOEPTSIZ10		(USBOTG_LINK_BASE + 0xC50) /* R/W Device OUT Endpoint 10 Transfer Size Register */
#define S5P_OTG_DOEPDMA10		(USBOTG_LINK_BASE + 0xC54) /* R/W Device OUT Endpoint 10 DMA Address Register */
#define S5P_OTG_DOEPCTL11		(USBOTG_LINK_BASE + 0xC60) /* R/W Device Control OUT Endpoint 11 Control Register */
#define S5P_OTG_DOEPINT11		(USBOTG_LINK_BASE + 0xC68) /* R/W Device OUT Endpoint 11 Interrupt Register */
#define S5P_OTG_DOEPTSIZ11		(USBOTG_LINK_BASE + 0xC70) /* R/W Device OUT Endpoint 11 Transfer Size Register */
#define S5P_OTG_DOEPDMA11		(USBOTG_LINK_BASE + 0xC74) /* R/W Device OUT Endpoint 11 DMA Address Register */
#define S5P_OTG_DOEPCTL12		(USBOTG_LINK_BASE + 0xC80) /* R/W Device Control OUT Endpoint 12 Control Register */
#define S5P_OTG_DOEPINT12		(USBOTG_LINK_BASE + 0xC88) /* R/W Device OUT Endpoint 12 Interrupt Register */
#define S5P_OTG_DOEPTSIZ12		(USBOTG_LINK_BASE + 0xC90) /* R/W Device OUT Endpoint 12 Transfer Size Register */
#define S5P_OTG_DOEPDMA12		(USBOTG_LINK_BASE + 0xC94) /* R/W Device OUT Endpoint 12 DMA Address Register */
#define S5P_OTG_DOEPCTL13		(USBOTG_LINK_BASE + 0xCA0) /* R/W Device Control OUT Endpoint 13 Control Register */
#define S5P_OTG_DOEPINT13		(USBOTG_LINK_BASE + 0xCA8) /* R/W Device OUT Endpoint 13 Interrupt Register */
#define S5P_OTG_DOEPTSIZ13		(USBOTG_LINK_BASE + 0xCB0) /* R/W Device OUT Endpoint 13 Transfer Size Register */
#define S5P_OTG_DOEPDMA13		(USBOTG_LINK_BASE + 0xCB4) /* R/W Device OUT Endpoint 13 DMA Address Register */
#define S5P_OTG_DOEPCTL14		(USBOTG_LINK_BASE + 0xCC0) /* R/W Device Control OUT Endpoint 14 Control Register */
#define S5P_OTG_DOEPINT14		(USBOTG_LINK_BASE + 0xCC8) /* R/W Device OUT Endpoint 14 Interrupt Register */
#define S5P_OTG_DOEPTSIZ14		(USBOTG_LINK_BASE + 0xCD0) /* R/W Device OUT Endpoint 14 Transfer Size Register */
#define S5P_OTG_DOEPDMA14		(USBOTG_LINK_BASE + 0xCD4) /* R/W Device OUT Endpoint 14 DMA Address Register */
#define S5P_OTG_DOEPCTL15		(USBOTG_LINK_BASE + 0xCE0) /* R/W Device Control OUT Endpoint 15 Control Register */
#define S5P_OTG_OTG_DOEPINT15		(USBOTG_LINK_BASE + 0xCE8) /* R/W Device OUT Endpoint 15 Interrupt Register */
#define S5P_OTG_DOEPTSIZ15		(USBOTG_LINK_BASE + 0xCF0) /* R/W Device OUT Endpoint 15 Transfer Size Register */
#define S5P_OTG_DOEPDMA15		(USBOTG_LINK_BASE + 0xCF4) /* R/W Device OUT Endpoint 15 DMA Address Register */

/* Power and Clock Gating Register */
#define S5P_OTG_PCGCCTL 		(USBOTG_LINK_BASE + 0xE00) /* R/W Power and Clock Gating Control Register */

/* Endpoint FIFO address */
#define S5P_OTG_EP0_FIFO		(USBOTG_LINK_BASE + 0x1000)

/* USB Global Interrupt Status register(GINTSTS) setting value */
#define GINTSTS_WkUpInt		(1<<31)
#define GINTSTS_OEPInt		(1<<19)
#define GINTSTS_IEPInt		(1<<18)
#define GINTSTS_EnumDone	(1<<13)
#define GINTSTS_USBRst		(1<<12)
#define GINTSTS_USBSusp		(1<<11)
#define GINTSTS_RXFLvl		(1<<4)

#endif
