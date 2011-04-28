/*********************************************************************************
 *
 *  Copyright (C) 2011 AMLOGIC, INC.
 *
 *
 * remark: copy from @ trunk/arch/arm/include/asm/arch-m1
 *              by Haixiang.Bao 2011.08.12
 *              haixiang.bao@amlogic.com
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *
 **********************************************************************************/

#ifndef __ARCH_ARM_MESON_USB_H_U_BOOT__
#define __ARCH_ARM_MESON_USB_H_U_BOOT__

#include <common.h>
#include <asm/io.h>
#include <asm/types.h>
#include <asm/arch/io.h>

#define PREI_USB_PHY_REG        (0x2100) /*0xC1108400*/
#define PREI_USB_PHY_A_REG1     (0x2101)
#define PREI_USB_PHY_B_REG1     (0x2102)

#define PREI_USB_PHY_A_POR        (1 << 0)
#define PREI_USB_PHY_B_POR        (1 << 1)
#define PREI_USB_PHY_CLK_SEL      (7 << 5) 
#define PREI_USB_PHY_CLK_GATE 	  (1 << 8) 
#define PREI_USB_PHY_B_AHB_RSET   (1 << 11)
#define PREI_USB_PHY_B_CLK_RSET   (1 << 12)
#define PREI_USB_PHY_B_PLL_RSET   (1 << 13)
#define PREI_USB_PHY_A_AHB_RSET   (1 << 17)
#define PREI_USB_PHY_A_CLK_RSET   (1 << 18)
#define PREI_USB_PHY_A_PLL_RSET   (1 << 19)
#define PREI_USB_PHY_A_DRV_VBUS   (1 << 20)
#define PREI_USB_PHY_B_DRV_VBUS   (1 << 21)
#define PREI_USB_PHY_B_CLK_DETECT (1 << 22)
#define PREI_USB_PHY_CLK_DIV      (0x7f << 24)
#define PREI_USB_PHY_A_CLK_DETECT (1 << 31)

#define USB_PHY_TUNE_MASK_REFCLKDIV  (3 << 29)
#define USB_PHY_TUNE_MASK_REFCLKSEL  (3 << 27 )
#define USB_PHY_TUNE_MASK_SQRX       (7 << 16 )
#define USB_PHY_TUNE_MASK_TXVREF     (15 << 5)
#define USB_PHY_TUNE_MASK_OTGDISABLE (1 << 2)
#define USB_PHY_TUNE_MASK_RISETIME   (3 << 9 )
#define USB_PHY_TUNE_MASK_VBUS_THRE  (7 << 19)

#define USB_PHY_TUNE_SHIFT_REFCLKDIV  (29)
#define USB_PHY_TUNE_SHIFT_REFCLKSEL  (27)
#define USB_PHY_TUNE_SHIFT_SQRX       (16)
#define USB_PHY_TUNE_SHIFT_TXVREF     (5)
#define USB_PHY_TUNE_SHIFT_OTGDISABLE (2)
#define USB_PHY_TUNE_SHIFT_RISETIME   (9)
#define USB_PHY_TUNE_SHIFT_VBUS_THRE  (19)

#define USB_PHY_A_INTR_BIT	(1 << 30)
#define USB_PHY_B_INTR_BIT	(1 << 31)

/* M1 usb clock cfg
   cfg = 0 : XTAL input
   cfg = 1 : XTAL input divided by 2
   cfg = 2 : other PLL
   cfg = 3 : DDR pll
   cfg = 4 : dmod pll
  */
#define	USB_PHY_CLOCK_SEL_XTAL      (0)
#define	USB_PHY_CLOCK_SEL_XTAL_DIV2 (1)
#define	USB_PHY_CLOCK_SEL_OTHER_PLL (2)
#define	USB_PHY_CLOCK_SEL_DDR_PLL   (3)
#define	USB_PHY_CLOCK_SEL_DEMOD_PLL (4)

typedef struct amlogic_usb_config{
	/* clock info */
	int clk_selecter;	// usb USB_PHY_CLOCK_SEL_xxx
	int pll_divider; // when other/ddr/demod pll used, fill this
	
	/* controller */
	unsigned int base_addr;
	
	/* role */
	int id_mode; // only used after M2
	
	/* vbus call back */
	void (* set_vbus_power)(char is_power_on);
	
}amlogic_usb_config_t;

amlogic_usb_config_t * board_usb_start(void);
int board_usb_stop(void);
void board_usb_init(amlogic_usb_config_t * usb_cfg);

#endif /*__ARCH_ARM_MESON_USB_H_U_BOOT__*/
