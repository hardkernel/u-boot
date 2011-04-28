/*
Linux PINMUX.C
#include <asm/arch
*/
#include <asm/arch/io.h>
#include <asm/arch/pinmux.h>

int  clear_mio_mux(unsigned mux_index, unsigned mux_mask)
{
    unsigned mux_reg[] = {PERIPHS_PIN_MUX_0, PERIPHS_PIN_MUX_1, PERIPHS_PIN_MUX_2,PERIPHS_PIN_MUX_3,
		PERIPHS_PIN_MUX_4,PERIPHS_PIN_MUX_5,PERIPHS_PIN_MUX_6,PERIPHS_PIN_MUX_7,PERIPHS_PIN_MUX_8,
		PERIPHS_PIN_MUX_9,PERIPHS_PIN_MUX_10,PERIPHS_PIN_MUX_11,PERIPHS_PIN_MUX_12};
    if (mux_index < 13) {
        CLEAR_CBUS_REG_MASK(mux_reg[mux_index], mux_mask);
		return 0;
    }
	return -1;
}

int  set_mio_mux(unsigned mux_index, unsigned mux_mask)
{
    unsigned mux_reg[] = {PERIPHS_PIN_MUX_0, PERIPHS_PIN_MUX_1, PERIPHS_PIN_MUX_2,PERIPHS_PIN_MUX_3,
		PERIPHS_PIN_MUX_4,PERIPHS_PIN_MUX_5,PERIPHS_PIN_MUX_6,PERIPHS_PIN_MUX_7,PERIPHS_PIN_MUX_8,
		PERIPHS_PIN_MUX_9,PERIPHS_PIN_MUX_10,PERIPHS_PIN_MUX_11,PERIPHS_PIN_MUX_12};
    if (mux_index < 13) {
        SET_CBUS_REG_MASK(mux_reg[mux_index], mux_mask);
		return 0;
    }
	return -1;
}



/*
call it before pinmux init;
call it before soft reset;
*/
void   clearall_pinmux(void)
{
	int i;
	for(i=0;i<13;i++)
		clear_mio_mux(i,0xffffffff);
	return;
}
int eth_clearall_pinmux(void)
{
	clear_mio_mux(ETH_BANK0_REG1,ETH_BANK0_REG1_VAL);
	return 0;
}

