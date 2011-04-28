/*
*
*  PINMUX.C for Amlogic ethernet
*  
*/

//copy from /trunk/arch/arm/cpu/aml_meson/m1
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
	clear_mio_mux(ETH_BANK1_REG1,ETH_BANK1_REG1_VAL);
	clear_mio_mux(ETH_BANK2_REG1,ETH_BANK2_REG1_VAL);
	return 0;
}

/*
*   ETH PINMUX SETTING
*   More details can get from am_eth_pinmux.h
*/
int aml_eth_set_pinmux(int bank_id,int clk_in_out_id,unsigned long ext_msk)
{
	int ret=0;

	switch(bank_id)
	{
		case	ETH_BANK0_GPIOC3_C12:
				if(ext_msk>0)
					set_mio_mux(ETH_BANK0_REG1,ext_msk);
				else
					set_mio_mux(ETH_BANK0_REG1,ETH_BANK0_REG1_VAL);
				break;
		case 	ETH_BANK1_GPIOD2_D11:
				if(ext_msk>0)
					set_mio_mux(ETH_BANK1_REG1,ext_msk);
				else
					set_mio_mux(ETH_BANK1_REG1,ETH_BANK1_REG1_VAL);
				break;
		case 	ETH_BANK2_GPIOD15_D23:
				if(ext_msk>0)
					set_mio_mux(ETH_BANK2_REG1,ext_msk);
				else
					set_mio_mux(ETH_BANK2_REG1,ETH_BANK2_REG1_VAL);
				break;
		default:
				printf("UNknow pinmux setting of ethernet!error bankid=%d,must be 0-2\n",bank_id);
				ret=-1;
				
	}
	switch(clk_in_out_id)
	{
		case  ETH_CLK_IN_GPIOC2_REG4_26:
				set_mio_mux(4,1<<26);	
				break;
		case  ETH_CLK_IN_GPIOC12_REG3_0:
				set_mio_mux(3,1<<0);	
				break;
 		case  ETH_CLK_IN_GPIOD7_REG4_19:
				set_mio_mux(4,1<<19);	
				break;
	 	case  ETH_CLK_IN_GPIOD14_REG7_12:
				set_mio_mux(7,1<<12);	
				break;
 		case  ETH_CLK_IN_GPIOD24_REG5_0:
				set_mio_mux(5,1<<0);	
				break;
 		case  ETH_CLK_OUT_GPIOC2_REG4_27:
				set_mio_mux(4,1<<27);	
				break;
 		case  ETH_CLK_OUT_GPIOC12_REG3_1:
				set_mio_mux(3,1<<1);	
				break;
		case  ETH_CLK_OUT_GPIOD7_REG4_20:
				set_mio_mux(4,1<<20);	
				break;
		case  ETH_CLK_OUT_GPIOD14_REG7_13:
				set_mio_mux(7,1<<13);	
				break;
 		case  ETH_CLK_OUT_GPIOD24_REG5_1:
				set_mio_mux(5,1<<1);	
				break;
		default:
				printf("UNknow clk_in_out_id setting of ethernet!error clk_in_out_id=%d,must be 0-9\n",clk_in_out_id);
				ret=-1;
	}
	return ret;
}




