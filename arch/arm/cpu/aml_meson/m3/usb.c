/******************************************************************************
 *
 *  Copyright (C) 2011 AMLOGIC, INC.
 *
 *
 * remark: copy from @ trunk/arch/arm/cpu/aml_meson/m3 @Rev2634
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
 *********************************************************************************/
//#include <common.h>
//#include <asm/cache.h>
#include <asm/arch/usb.h>

#ifdef CONFIG_USB_DWC_OTG_HCD
static amlogic_usb_config_t * g_usb_cfg = 0;
static char * g_clock_src_name_m3[]={
		"XTAL input",
		"XTAL input divided by 2",
		"SYS PLL clock",
		"MISC PLL clock",
		"DDR PLL clock",
		"AUD pll clock",
		"VID PLL clock"
		"VID2 pll clock"
};

extern void udelay(unsigned long usec);

int set_usb_phy_id_mode(amlogic_usb_config_t * usb_cfg)
{
    unsigned long delay = 100;
    unsigned int reg;
    unsigned int port;
    unsigned int mode;

	mode = usb_cfg->id_mode;
	port = usb_cfg->base_addr & USB_PHY_PORT_MSK;
	
    if(port == USB_PHY_PORT_A)
    {
        reg = PREI_USB_PHY_A_REG3;
    }
    else if(port == USB_PHY_PORT_B)
    {
        reg = PREI_USB_PHY_B_REG4;
    }
    else
    {
        printf("id_mode this usb port is not exist!\n");
        return -1;
    }

    CLEAR_CBUS_REG_MASK(reg, PREI_USB_PHY_MODE_MASK);
    udelay(delay);
    
    switch(mode)
    {
        case USB_ID_MODE_SW_HOST:
        	printf("usb id mode: SW_HOST\n");
            SET_CBUS_REG_MASK(reg, PREI_USB_PHY_MODE_SW_HOST);
            break;
			
        case USB_ID_MODE_SW_DEVICE:
        	printf("usb id mode: SW_DEVICE\n");
            SET_CBUS_REG_MASK(reg, PREI_USB_PHY_MODE_SW_SLAVE);
            break;
			
        case USB_ID_MODE_HARDWARE:
        default:
        	printf("usb id mode: HARDWARE\n");
            SET_CBUS_REG_MASK(reg, PREI_USB_PHY_MODE_HW);
            break;
    }
    
    udelay(delay);

    return 0;
}

void set_usb_phy_clock(amlogic_usb_config_t * usb_cfg)
{
    int clk_sel = usb_cfg->clk_selecter;
	int pll_div = usb_cfg->pll_divider;

	//need check data?
	if(clk_sel < 0 || 
		clk_sel >= (sizeof(g_clock_src_name_m3)/sizeof(g_clock_src_name_m3[0])))
	{
		printf("Error! Not support the clock source [%d] for USB PHY!\n",clk_sel);
		return;
	}
		

	//show USB 12MHz clock input source
	printf("usb clk_sel: %s\n",g_clock_src_name_m3[clk_sel]);

	//clear clock select setting	
	CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_CLK_SEL);

	//set clock select setting
	SET_CBUS_REG_MASK(PREI_USB_PHY_REG, MAKE_USB_PHY_CLK_SEL(clk_sel));

	//clear clock divider setting
	CLEAR_CBUS_REG_MASK(PREI_USB_PHY_REG,PREI_USB_PHY_CLK_DIV);

	//set clock divider setting
	switch(clk_sel)
	{
		case USB_PHY_CLOCK_SEL_M3_XTAL:
		case USB_PHY_CLOCK_SEL_M3_XTAL_DIV2:
		/*	
		//when 800MHz, divider set to 65,66 all fail
		case USB_PHY_CLOCK_SEL_M3_SYS_PLL://SYS PLL running at 800M (800/(65+1)=12)
		case USB_PHY_CLOCK_SEL_M3_MISC_PLL://MISC runing 800MHz (800/(65+1)=12)
		*/
		/*
		//following PLL not support yet
		case USB_PHY_CLOCK_SEL_M3_AUD_PLL: 			
		case USB_PHY_CLOCK_SEL_M3_VID_PLL: 
		case USB_PHY_CLOCK_SEL_M3_VID2_PLL:
		*/
		case USB_PHY_CLOCK_SEL_M3_DDR_PLL:
			SET_CBUS_REG_MASK(PREI_USB_PHY_REG, MAKE_USB_PHY_CLK_DIV(pll_div));
			break;		
		default:
			printf("Not support the clock source [%d] for USB PHY!\n",clk_sel);
			break;
	}

	// Open clock gate, to enable CLOCK to usb phy 
	SET_CBUS_REG_MASK(PREI_USB_PHY_REG, PREI_USB_PHY_CLK_GATE);

}
void set_usb_phy_reset(amlogic_usb_config_t * usb_cfg,int is_on)
{
	unsigned long delay = 100;
    unsigned int port = usb_cfg->base_addr & USB_PHY_PORT_MSK;;

	if(port == USB_PHY_PORT_A){
		if(is_on){
			/*  Reset USB PHY A  */
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
	}

	if(port == USB_PHY_PORT_B){		    
    	if(is_on){
            /* Reset USB PHY B */
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
  	}
}
amlogic_usb_config_t * board_usb_start(void)
{
	if(!g_usb_cfg)
		return 0;

	set_usb_phy_id_mode(g_usb_cfg);
	set_usb_phy_clock(g_usb_cfg);
	set_usb_phy_reset(g_usb_cfg,1);//on
	
	return g_usb_cfg;
}

int board_usb_stop(void)
{
	printf("board_usb_stop!\n");
	set_usb_phy_reset(g_usb_cfg,0);//off

	return 0;
}
void board_usb_init(amlogic_usb_config_t * usb_cfg)
{
	g_usb_cfg = usb_cfg;
}
#endif //CONFIG_USB_DWC_OTG_HCD