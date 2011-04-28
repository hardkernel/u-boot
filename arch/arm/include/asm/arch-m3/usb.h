/*********************************************************************************
 *
 *  Copyright (C) 2011 AMLOGIC, INC.
 *
 *
 * remark: copy from @ trunk/arch/arm/include/asm/arch-m3 @Rev2634
 *              by Haixiang.Bao 2011.10.17
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
#include <asm/types.h>
#include <asm/arch/io.h>

#define USB_PHY_PORT_A	    (0x40000)
#define USB_PHY_PORT_B	    (0xc0000)
#define USB_PHY_PORT_MSK	(0xf0000)

#define PREI_USB_PHY_REG     0x2100 //0xC1108400
#define PREI_USB_PHY_A_REG1  0x2101
#define PREI_USB_PHY_B_REG1  0x2102
#define PREI_USB_PHY_A_REG3  0x2103
#define PREI_USB_PHY_B_REG4  0x2104

#define PREI_USB_PHY_A_POR          (1 << 0)
#define PREI_USB_PHY_B_POR          (1 << 1)
//#define PREI_USB_PHY_CLK_EN			(1 << 6) no CLK_EN in A1H
#define PREI_USB_PHY_CLK_SEL        (7 << 5) 
#define MAKE_USB_PHY_CLK_SEL(clk_sel) ((clk_sel&7) << 5) 
#define PREI_USB_PHY_CLK_GATE 	    (1 << 8) 
#define PREI_USB_PHY_B_AHB_RSET     (1 << 11)
#define PREI_USB_PHY_B_CLK_RSET     (1 << 12)
#define PREI_USB_PHY_B_PLL_RSET     (1 << 13)
#define PREI_USB_PHY_A_AHB_RSET     (1 << 17)
#define PREI_USB_PHY_A_CLK_RSET     (1 << 18)
#define PREI_USB_PHY_A_PLL_RSET     (1 << 19)
#define PREI_USB_PHY_A_DRV_VBUS     (1 << 20)
#define PREI_USB_PHY_B_DRV_VBUS		(1 << 21)
#define PREI_USB_PHY_B_CLK_DETECT   (1 << 22)
#define PREI_USB_PHY_CLK_DIV        (0x7f << 24)
#define MAKE_USB_PHY_CLK_DIV(pll_div) ((pll_div&0x7F)<<24)
#define PREI_USB_PHY_A_CLK_DETECT   (1 << 31)

#define PREI_USB_PHY_MODE_MASK      (3 << 22)

#define PREI_USB_PHY_MODE_HW        (0 << 22)
#define PREI_USB_PHY_MODE_SW_HOST   (2 << 22)
#define PREI_USB_PHY_MODE_SW_SLAVE  (3 << 22)

#define USB_PHY_TUNE_MASK_REFCLKDIV  (3 << 29)
#define USB_PHY_TUNE_MASK_REFCLKSEL  (3 << 27)
#define USB_PHY_TUNE_MASK_SQRX       (7 << 16)
#define USB_PHY_TUNE_MASK_TXVREF     (15 << 5)
#define USB_PHY_TUNE_MASK_OTGDISABLE (1 << 2 )
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

/* M3 usb clock cfg
    0 = XTAL input
    1 = XTAL input divided by 2
    2 = SYS PLL output
    3 = MISC pll clock
    4 = DDR pll clock
    5 = AUD pll clock
    6 = VID pll clock
    7 = VID2 pll clock
  */
#define	USB_PHY_CLOCK_SEL_M3_XTAL       (0)  //when 24MHz, divider set to 1 will work
#define	USB_PHY_CLOCK_SEL_M3_XTAL_DIV2  (1)  //when 24MHz, divider set to 0 will work
#define	USB_PHY_CLOCK_SEL_M3_SYS_PLL    (2)  //when 800MHz, divider set to 65,66 all fail
#define	USB_PHY_CLOCK_SEL_M3_MISC_PLL   (3)  //when 800MHz, divider set to 65,66 all fail
#define	USB_PHY_CLOCK_SEL_M3_DDR_PLL    (4)  //when 528MHz, divider set to 43 will work
//following not support yet
/*
#define	USB_PHY_CLOCK_SEL_M3_AUD_PLL   (5)
#define	USB_PHY_CLOCK_SEL_M3_VID_PLL    (6)
#define	USB_PHY_CLOCK_SEL_M3_VID2_PLL  (7)
*/


/* usb id mode, only after M2
	 mode = 0 : HARDWARE
	 mode = 1 : SW_HOST
	 mode = 2 : SW_DEVICE
 */
#define USB_ID_MODE_HARDWARE    (1)
#define USB_ID_MODE_SW_HOST     (2)
#define USB_ID_MODE_SW_DEVICE   (3) 

typedef struct amlogic_usb_config{
	/* clock info */
	int clk_selecter; // usb USB_PHY_CLOCK_SEL_xxx
	int pll_divider;  // when other/ddr/demod pll used, fill this
	
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

#endif //__ARCH_ARM_MESON_USB_H_U_BOOT__