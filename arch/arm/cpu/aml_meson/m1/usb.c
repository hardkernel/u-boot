/******************************************************************************
 *
 *  Copyright (C) 2011 AMLOGIC, INC.
 *
 *
 * remark: copy from @ trunk/arch/arm/cpu/aml_meson/m1
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
 *********************************************************************************/

 
#include <common.h>   
#include <asm/cache.h>
#include <asm/arch/usb.h>

#ifdef CONFIG_USB_DWC_OTG_HCD

static amlogic_usb_config_t * g_usb_cfg;
static char * clock_src_name[]={
		"XTAL input",
		"XTAL input divided by 2",
		"other PLL",
		"DDR PLL",
		"dmod PLL"
};

extern void udelay(unsigned long usec);

 void local_dump_usb_reg()
{
	printf("hisun: usb addr= 0x%x val= 0x%x\n",
			P_USB_ADDR0,READ_CBUS_REG(USB_ADDR0));

	printf("hisun: usb addr= 0x%x val= 0x%x\n",
		P_USB_ADDR1,READ_CBUS_REG(USB_ADDR1));

	printf("hisun: usb addr= 0x%x val= 0x%x\n",
		P_USB_ADDR2,READ_CBUS_REG(USB_ADDR2));

	printf("hisun: usb addr= 0x%x val= 0x%x\n",
		P_USB_ADDR3,READ_CBUS_REG(USB_ADDR3));

	printf("hisun: usb addr= 0x%x val= 0x%x\n",
		P_USB_ADDR4,READ_CBUS_REG(USB_ADDR4));


}
void set_usb_phy_clock(amlogic_usb_config_t * usb_cfg)
{
    int clk_sel = usb_cfg->clk_selecter;
		
	// ------------------------------------------------------------
	//  CLK_SEL: These bits select the source for the 12Mhz: 
	// 0 = XTAL input (24, 25, 27Mhz)
	// 1 = XTAL input divided by 2
	// 2 = other PLL output
	// 3 = DDR pll clock (typically 400mhz)
	// 4 = demod 240Mhz PLL output
	CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_CLK_SEL);
	//clk_sel = 0; // 24M CLK 
	//clk_sel = 1; // 12M, Phy default setting is 12Mhz
	//clk_sel = 2; // other PLL, 540M
	//clk_sel = 3; // DDR, 369M
	//clk_sel = 4; // demod, 240M
		
	SET_CBUS_REG_MASK(PREI_USB_PHY_REG, (clk_sel<<5 ));

	CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG,PREI_USB_PHY_CLK_DIV);
		
	switch(clk_sel)
	{
		case USB_PHY_CLOCK_SEL_XTAL:
			//XTAL 24M, Divide by 2
			SET_CBUS_REG_MASK(PREI_USB_PHY_REG, (1 << 24));
			break;
			
		case USB_PHY_CLOCK_SEL_XTAL_DIV2:
			//XTAL 24M, Divide by 1
			SET_CBUS_REG_MASK(PREI_USB_PHY_REG, (0 << 24));
			break;
			
		case USB_PHY_CLOCK_SEL_OTHER_PLL:
			//Other PLL running at 540M (540/(44+1)=12)
			SET_CBUS_REG_MASK(PREI_USB_PHY_REG, (44 << 24));
			break;
			
		case USB_PHY_CLOCK_SEL_DDR_PLL:
			//DDR runing 396MHz (396/(32+1)=12)
			SET_CBUS_REG_MASK(PREI_USB_PHY_REG, (32 << 24));
			break;
			
		case USB_PHY_CLOCK_SEL_DEMOD_PLL:
			// demod 240M (240/(19+1) = 12)
			SET_CBUS_REG_MASK(PREI_USB_PHY_REG, (19 << 24));
			break;
	}

	// Open clock gate, to enable CLOCK to usb phy 
	SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_CLK_GATE);
	
}
void set_usb_phy_reset(amlogic_usb_config_t * usb_cfg,int is_on)
{
	unsigned long delay = 100;

	/*  Reset USB PHY A  */
    if(is_on){
		SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_A_AHB_RSET);
        udelay(delay); 
		
        CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_A_AHB_RSET);
        udelay(delay);
		
        SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_A_CLK_RSET);
        udelay(delay);  
		
        CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_A_CLK_RSET);
        udelay(delay);
		
        SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_A_PLL_RSET);
        udelay(delay);
		
        CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_A_PLL_RSET);
        udelay(delay);
	}

	
    // ------------------------------------------------------------ 
    // Reset the PHY A by setting POR high for 10uS.
    SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_A_POR);
    udelay(delay);	
    // Set POR to the PHY high
	if(is_on){
		CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_A_POR);
    	udelay(delay);
	}    
	// ------------------------------------------------------------

	
    /* Reset USB PHY B */
	if(is_on){ 
		SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_B_AHB_RSET);
		udelay(delay);
	
	    CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_B_AHB_RSET);
	    udelay(delay);
		
	    SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_B_CLK_RSET);
	    udelay(delay);
		
	    CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_B_CLK_RSET);
	    udelay(delay);
		
	    SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_B_PLL_RSET);
	    udelay(delay);
		
	    CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_B_PLL_RSET);
	    udelay(delay);
	}


    // ------------------------------------------------------------ 
    // Reset the PHY B by setting POR high for 10uS.
    SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_B_POR);
    udelay(delay);
    // Set POR to the PHY high
    if(is_on){
    	CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_B_POR);
    	udelay(delay);
    }
	// ------------------------------------------------------------
	
}
amlogic_usb_config_t * board_usb_start(void)
{	
	unsigned long delay = 100;
	
	if(!g_usb_cfg)
		return 0;
	
	set_usb_phy_clock(g_usb_cfg);
	
	set_usb_phy_reset(g_usb_cfg,1);//on
	

	CLEAR_CBUS_REG_MASK(USB_ADDR4, 3<<22);
	udelay(delay);

	SET_CBUS_REG_MASK(USB_ADDR4, 1<<23);
	udelay(delay);

	return g_usb_cfg;
}

int board_usb_stop(void)
{
	set_usb_phy_reset(g_usb_cfg,0);//off

	return 0;
}
void board_usb_init(amlogic_usb_config_t * usb_cfg)
{
	g_usb_cfg = usb_cfg;
}
#endif /*CONFIG_USB_DWC_OTG_HCD*/
