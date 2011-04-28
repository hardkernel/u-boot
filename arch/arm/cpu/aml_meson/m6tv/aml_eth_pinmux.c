/*******************************************************************
 * 
 *  Copyright C 2011 by Amlogic, Inc. All Rights Reserved.
 *
 *  Description: pinmux setting implementation for Amlogic Ethernet
 *
 *  
 *  Remark: 2011.08.02 merge by Hisun bao
 *                from /arch/arm/cpu/aml_meson/m1
 *
 *******************************************************************/
#include <asm/arch/io.h>
#include <asm/arch/aml_eth_reg.h>
#include <asm/arch/aml_eth_pinmux.h>

extern int printf(const char *fmt, ...);
static int  clear_mio_mux(unsigned mux_index, unsigned mux_mask)
{
    unsigned mux_reg[] = {PERIPHS_PIN_MUX_0, PERIPHS_PIN_MUX_1, PERIPHS_PIN_MUX_2,PERIPHS_PIN_MUX_3,
		PERIPHS_PIN_MUX_4,PERIPHS_PIN_MUX_5,PERIPHS_PIN_MUX_6,PERIPHS_PIN_MUX_7,PERIPHS_PIN_MUX_8,
		PERIPHS_PIN_MUX_9,PERIPHS_PIN_MUX_10,PERIPHS_PIN_MUX_11,PERIPHS_PIN_MUX_12};
    if (mux_index < 13) {
         clrbits_le32(CBUS_REG_ADDR(mux_reg[mux_index]),mux_mask);
		return 0;
    }
	return -1;
}

static int  set_mio_mux(unsigned mux_index, unsigned mux_mask)
{
    unsigned mux_reg[] = {PERIPHS_PIN_MUX_0, PERIPHS_PIN_MUX_1, PERIPHS_PIN_MUX_2,PERIPHS_PIN_MUX_3,
		PERIPHS_PIN_MUX_4,PERIPHS_PIN_MUX_5,PERIPHS_PIN_MUX_6,PERIPHS_PIN_MUX_7,PERIPHS_PIN_MUX_8,
		PERIPHS_PIN_MUX_9,PERIPHS_PIN_MUX_10,PERIPHS_PIN_MUX_11,PERIPHS_PIN_MUX_12};
    if (mux_index < 13) {
        setbits_le32(CBUS_REG_ADDR(mux_reg[mux_index]), mux_mask);
		return 0;
    }
	return -1;
}

int aml_eth_clearall_pinmux(void)
{
	clear_mio_mux(ETH_BANK0_REG1,ETH_BANK0_REG1_VAL);
	return 0;
}

/*************************************
  *   ETH PINMUX SETTING
  *   More details can get from following:
  *   1. am_eth_pinmux.h
  *   2. AppNote-M3-CorePinMux.xlsx
  *   3. m3_skt_v1.pdf
  *************************************/
int aml_eth_set_pinmux(int bank_id,int clk_in_out_id,unsigned long ext_msk)
{
	int ret=0;

	switch(bank_id)
	{
		case	ETH_BANK0_GPIOY1_Y9:
				if(ext_msk>0)
					set_mio_mux(ETH_BANK0_REG1,ext_msk);
				else
					set_mio_mux(ETH_BANK0_REG1,ETH_BANK0_REG1_VAL);
				break;		
		default:
				printf("UNknow pinmux setting of ethernet!error bankid=%d,must be 0-2\n",bank_id);
				ret=-1;
				
	}
	switch(clk_in_out_id)
	{
		case  ETH_CLK_IN_GPIOY0_REG6_18:
				set_mio_mux(6,1<<18);
				break;
		case  ETH_CLK_OUT_GPIOY0_REG6_17:
				set_mio_mux(6,1<<17);	
				break;	
		default:
				printf("UNknow clk_in_out_id setting of ethernet!error clk_in_out_id=%d,must be 0-9\n",clk_in_out_id);
				ret=-1;
	}
	return ret;
}




