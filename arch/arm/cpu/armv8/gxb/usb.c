
/*
 * arch/arm/cpu/armv8/gxb/usb.c
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

//#include <common.h>
//#include <asm/cache.h>
#include <asm/arch/usb.h>
#include <asm/arch/romboot.h>


#ifdef CONFIG_USB_DWC_OTG_HCD
static amlogic_usb_config_t * g_usb_cfg[BOARD_USB_MODE_MAX][USB_PHY_PORT_MAX];

static char * g_clock_src_name_m8[]={
    "XTAL input",
};

extern void _udelay(unsigned long usec);
extern void _mdelay(unsigned long usec);
//static int reset_count = 0;
//int set_usb_phy_clk(struct lm_device * plmdev,int is_enable)
//{
static int set_usb_phy_clock(amlogic_usb_config_t * usb_cfg)
{

	int port_idx;
	usb_peri_reg_t * peri;
	usb_config_data_t config;
	usb_ctrl_data_t control;
	int clk_sel,clk_div;
	unsigned int port = usb_cfg->base_addr & USB_PHY_PORT_MSK;
	int time_dly = 500; //usec

	if (!usb_cfg)
		return -1;


	if (port == USB_PHY_PORT_A) {
		port_idx = 0;
		peri = (usb_peri_reg_t*)PREI_USB_PHY_REG_A;//CBUS_REG_ADDR(PREI_USB_PHY_REG_A);
	}else if(port == USB_PHY_PORT_B){
		port_idx = 1;
		peri = (usb_peri_reg_t*)PREI_USB_PHY_REG_B;//CBUS_REG_ADDR(PREI_USB_PHY_REG_B);
	}else{
		printf("usb base address error: %x\n",usb_cfg->base_addr);
		return -1;
	}
	writel((1 << 2),P_RESET1_REGISTER);
	printf("USB (%d) peri reg base: %x\n",port_idx,(uint32_t)(unsigned long long)peri);
	clk_sel = usb_cfg->clk_selecter;
	clk_div = usb_cfg->pll_divider;

	config.d32 = peri->config;
	config.b.clk_32k_alt_sel= 1;
	peri->config = config.d32;

	printf("USB (%d) use clock source: %s, div: %d\n",port_idx,g_clock_src_name_m8[clk_sel], clk_div);

	control.d32 = peri->ctrl;
	control.b.fsel = 5;	/* PHY default is 24M (5), change to 12M (2) */
	control.b.por = 1;  /* power off default*/
	peri->ctrl = control.d32;
	_udelay(time_dly);
	return 0;
}
//call after set clock
void set_usb_phy_power(amlogic_usb_config_t * usb_cfg,int is_on)
{
	unsigned long delay = 1000;
	int port_idx = 100;
	unsigned int port = usb_cfg->base_addr & USB_PHY_PORT_MSK;
	usb_peri_reg_t *peri_a,*peri_b,*peri_c,*peri_d,*peri;
	peri = NULL;
	usb_ctrl_data_t control;
	usb_adp_bc_data_t adp_bc;

	peri_a = (usb_peri_reg_t*)PREI_USB_PHY_REG_A;//CBUS_REG_ADDR(PREI_USB_PHY_REG_A);
	peri_b = (usb_peri_reg_t*)PREI_USB_PHY_REG_B;//CBUS_REG_ADDR(PREI_USB_PHY_REG_B);
//	peri_c = (usb_peri_reg_t*)CBUS_REG_ADDR(PREI_USB_PHY_REG_C);
//	peri_d = (usb_peri_reg_t*)CBUS_REG_ADDR(PREI_USB_PHY_REG_D);
	peri_c = NULL;
	peri_d = NULL;

	if (port == USB_PHY_PORT_A) {
		peri = peri_a;
		port_idx = 0;
	}else if(port == USB_PHY_PORT_B){
		peri = peri_b;
		port_idx = 1;
	}
	else if(port == USB_PHY_PORT_C){
		peri = peri_c;
		port_idx = 2;
	}else if(port == USB_PHY_PORT_D){
		peri = peri_d;
		port_idx = 3;
	}

	if (is_on) {
		control.d32 = peri->ctrl;
		control.b.por = 0;
		peri->ctrl = control.d32;

		_udelay(delay);
		/* read back clock detected flag*/
		control.d32 = peri->ctrl;
		if (!control.b.clk_detected) {
			printf("USB (%d) PHY Clock not detected!\n",port_idx);
		}
		if (port == USB_PHY_PORT_B) {
			adp_bc.d32 = peri->adp_bc;
			adp_bc.b.aca_enable = 1;
			peri->adp_bc = adp_bc.d32;
			_udelay(50);
			adp_bc.d32 = peri->adp_bc;
			if (adp_bc.b.aca_pin_float) {
				printf("USB-B ID detect failed!\n");
				printf("Please use the chip after version RevA1!\n");
				return;
			}
		}
	}else{
		control.d32 = peri->ctrl;
		control.b.por = 1;
		peri->ctrl = control.d32;
	}
	_udelay(delay);

}
const char * bc_name[]={
	"UNKNOWN",
	"SDP (PC)",
	"DCP (Charger)",
	"CDP (PC with Charger)",
};
#define T_DCD_TIMEOUT	10
#define T_VDPSRC_ON	40
#define T_VDMSRC_EN	(20 + 5)
#define T_VDMSRC_DIS	(20 + 5)
#define T_VDMSRC_ON	40
static void usb_bc_detect(amlogic_usb_config_t * usb_cfg)
{
	int port_idx,timeout_det;
	unsigned int port = usb_cfg->base_addr & USB_PHY_PORT_MSK;
	usb_peri_reg_t *peri,*peri_a,*peri_b,*peri_c,*peri_d;
	peri = NULL;
	port_idx = 100;
	usb_adp_bc_data_t adp_bc;
	int bc_mode = BC_MODE_UNKNOWN;

	peri_a = (usb_peri_reg_t*)PREI_USB_PHY_REG_A;//CBUS_REG_ADDR(PREI_USB_PHY_REG_A);
	peri_b = (usb_peri_reg_t*)PREI_USB_PHY_REG_B;//CBUS_REG_ADDR(PREI_USB_PHY_REG_B);
//	peri_c = (usb_peri_reg_t*)CBUS_REG_ADDR(PREI_USB_PHY_REG_C);
//	peri_d = (usb_peri_reg_t*)CBUS_REG_ADDR(PREI_USB_PHY_REG_D);
	peri_c = NULL;
	peri_d = NULL;

	if (port == USB_PHY_PORT_A) {
		peri = peri_a;
		port_idx = 0;
	}else if(port == USB_PHY_PORT_B){
		peri = peri_b;
		port_idx = 1;
	}
	else if(port == USB_PHY_PORT_C){
		peri = peri_c;
		port_idx = 2;
	}else if(port == USB_PHY_PORT_D){
		peri = peri_d;
		port_idx = 3;
	}

	adp_bc.d32 = peri->adp_bc;
	if (adp_bc.b.device_sess_vld) {
		_mdelay(T_DCD_TIMEOUT);

		/* Turn on VDPSRC */
		adp_bc.b.chrgsel = 0;
		adp_bc.b.vdatdetenb = 1;
		adp_bc.b.vdatsrcenb = 1;
		adp_bc.b.dcd_enable = 0;
		peri->adp_bc = adp_bc.d32;

		/* SDP and CDP/DCP distinguish */
		timeout_det = T_VDMSRC_EN;
		while (timeout_det--) {
			adp_bc.d32 = peri->adp_bc;
			if (adp_bc.b.chg_det)
				break;
			_mdelay(1);
		};

		if (adp_bc.b.chg_det) {
			/* Turn off VDPSRC */
			adp_bc.d32 = peri->adp_bc;
			adp_bc.b.vdatdetenb = 0;
			adp_bc.b.vdatsrcenb = 0;
			peri->adp_bc = adp_bc.d32;

			/* Wait VDMSRC_DIS */
			timeout_det = T_VDMSRC_DIS;
			while (timeout_det--) {
				adp_bc.d32 = peri->adp_bc;
				if (!adp_bc.b.chg_det)
					break;
				_mdelay(1);
			};

			if (timeout_det <= 0)
				printf("Time out for VDMSRC_DIS!");

			/* Turn on VDMSRC */
			adp_bc.d32 = peri->adp_bc;
			adp_bc.b.chrgsel = 1;
			adp_bc.b.vdatdetenb = 1;
			adp_bc.b.vdatsrcenb = 1;
			peri->adp_bc = adp_bc.d32;

			_mdelay(T_VDMSRC_ON);
			adp_bc.d32 = peri->adp_bc;
			if (adp_bc.b.chg_det)
				bc_mode = BC_MODE_DCP;
			else
				bc_mode = BC_MODE_CDP;
		}
		else{
			bc_mode = BC_MODE_SDP;
		}
		adp_bc.d32 = peri->adp_bc;
		adp_bc.b.vdatdetenb = 0;
		adp_bc.b.vdatsrcenb = 0;
		adp_bc.b.dcd_enable = 0;
		peri->adp_bc = adp_bc.d32;
	}

	printf("Port %d detect usb battery charger mode: %s\n",port_idx, bc_name[bc_mode]);
	usb_cfg->battery_charging_det_cb(bc_mode);

}
amlogic_usb_config_t * board_usb_start(int mode,int index)
{
	if (mode < 0 || mode >= BOARD_USB_MODE_MAX||!g_usb_cfg[mode][index])
		return 0;


	set_usb_phy_clock(g_usb_cfg[mode][index]);
	set_usb_phy_power(g_usb_cfg[mode][index],1);//on
	if(mode == BOARD_USB_MODE_CHARGER &&
	    g_usb_cfg[mode][index]->battery_charging_det_cb)
		usb_bc_detect(g_usb_cfg[mode][index]);
	return g_usb_cfg[mode][index];
}

int board_usb_stop(int mode,int index)
{
	printf("board_usb_stop cfg: %d\n",mode);
	if (mode < 0 || mode >= BOARD_USB_MODE_MAX)
		return 1;
	set_usb_phy_power(g_usb_cfg[mode][index],0);//off

	return 0;
}

int usb_index = 0;
void board_usb_init(amlogic_usb_config_t * usb_cfg,int mode)
{

	if (mode < 0 || mode >= BOARD_USB_MODE_MAX || !usb_cfg)
		return ;

	if (mode == BOARD_USB_MODE_HOST) {
		if (usb_index >= USB_PHY_PORT_MAX)
			return;
		g_usb_cfg[mode][usb_index] = usb_cfg;
		usb_index++;
	}else
		g_usb_cfg[mode][0] = usb_cfg;
	printf("register usb cfg[%d][%d] = %p\n",mode,(mode==BOARD_USB_MODE_HOST)?usb_index:0,usb_cfg);
}

int get_usb_count(void)
{
    return  usb_index;
}
#endif //CONFIG_USB_DWC_OTG_HCD
