
/*
 * drivers/usb/gadget/aml_tiny_usbtool/platform.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include "platform.h"
#include <asm/arch/timer.h>

#define PREI_USB_PHY_A_REG_BASE       0xC0000000  //0x2100
#define PREI_USB_PHY_B_REG_BASE       0xC0000020	//0X2108

#ifdef __USE_PORT_B
#define PREI_USB_PHY_REG_BASE   PREI_USB_PHY_B_REG_BASE
#else
#define PREI_USB_PHY_REG_BASE   PREI_USB_PHY_A_REG_BASE
#endif
//#define P_RESET1_REGISTER						   (volatile unsigned long *)0xc1104408
#define P_RESET1_REGISTER_USB                           (volatile unsigned long *)0xc1104408

#define USB_CLK_SEL_XTAL				0
#define USB_CLK_SEL_XTAL_DIV_2	1
#define USB_CLK_SEL_DDR_PLL			2
#define USB_CLK_SEL_MPLL_OUT0		3
#define USB_CLK_SEL_MPLL_OUT1		4
#define USB_CLK_SEL_MPLL_OUT2		5
#define USB_CLK_SEL_FCLK_DIV2		6
#define USB_CLK_SEL_FCLK_DIV3		7
/* typedef struct usb_aml_regs {
	 volatile uint32_t config;
	 volatile uint32_t ctrl;
	 volatile uint32_t endp_intr;
	 volatile uint32_t adp_bc;
	 volatile uint32_t dbg_uart;
	 volatile uint32_t test;
	 volatile uint32_t tune;
 } usb_aml_regs_t;
 typedef union usb_config_data {*/
	 /** raw register data */
/*	 uint32_t d32;*/
	 /** register bits */
/*	 struct {
		 unsigned clk_en:1;
		 unsigned clk_sel:3;
		 unsigned clk_div:7;
		 unsigned reserved:20;
		 unsigned test_trig:1;
	 } b;
 } usb_config_data_t;
 typedef union usb_ctrl_data {*/
	 /** raw register data */
/*	 uint32_t d32;*/
	 /** register bits */
/*	 struct {
		 unsigned soft_prst:1;
		 unsigned soft_hreset:1;
		 unsigned ss_scaledown_mode:2;
		 unsigned clk_det_rst:1;
		 unsigned intr_sel:1;
		 unsigned reserved:2;
		 unsigned clk_detected:1;
		 unsigned sof_sent_rcvd_tgl:1;
		 unsigned sof_toggle_out:1;
		 unsigned not_used:4;
		 unsigned por:1;
		 unsigned sleepm:1;
		 unsigned txbitstuffennh:1;
		 unsigned txbitstuffenn:1;
		 unsigned commononn:1;
		 unsigned refclksel:2;
		 unsigned fsel:3;
		 unsigned portreset:1;
		 unsigned thread_id:6;
	 } b;
 } usb_ctrl_data_t;*/
/*
	cfg = 0 : EXT clock
	cfg = 1 : INT clock
*/
static void set_usb_phy_config(int cfg)
{

	const int time_dly = 500;
	usb_aml_regs_t * usb_aml_regs = (usb_aml_regs_t * )PREI_USB_PHY_REG_BASE;
	usb_config_data_t config;
	usb_ctrl_data_t control;

	/*CLK_GATE_ON(USB0);*/
	//if(!IS_CLK_GATE_ON(USB0)){
	//	SET_CBUS_REG_MASK(GCLK_REG_USB0, GCLK_MASK_USB0);
	//}
	/*printf("%s %d\n", __func__, __LINE__);*/
	cfg = cfg;//avoid compiler warning
	/**P_RESET1_REGISTER = (1<<2);//usb reset*/
	*P_RESET1_REGISTER_USB = (1<<2);//usb reset
	_udelay(time_dly);//by Sam: delay after reset

	config.d32 = usb_aml_regs->config;

//    config.b.clk_sel    = 0;
//    config.b.clk_div    = 1;
//    config.b.clk_32k_alt_sel = 1;
	usb_aml_regs->config = config.d32;

	control.d32 = usb_aml_regs->ctrl;
	control.b.fsel = 5;
	control.b.por = 1;
	usb_aml_regs->ctrl = control.d32;
	_udelay(time_dly);

	control.b.por = 0;
	usb_aml_regs->ctrl = control.d32;
	_udelay(time_dly);//by Sam: delay 0.5s to wait usb clam down

	control.d32 = usb_aml_regs->ctrl;
	if (!control.b.clk_detected) {
		printf("Error, usb phy clock not detected!\n");
	}

	return;
}

#if 0
int chip_watchdog(void)
{
	watchdog_clear();
	return 0;
};
#endif
#if 1
void usb_memcpy(char * dst,char * src,int len)
{
	 while (len--)
	 {
		 *(unsigned char*)dst = *(unsigned char*)src;
		 dst++;
		 src++;
	 }
 }
void usb_memcpy_32bits(int *dst,int *src,int len)
{
	while (len--)
	{
		*dst = *src;
		dst++;
		src++;
	}
}
#endif

