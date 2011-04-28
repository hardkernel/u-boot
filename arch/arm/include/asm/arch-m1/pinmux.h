#ifndef MESON_PINMUX_H
#define MESON_PINMUX_H

/*
Linux Pinmux.h
*/

int clear_mio_mux(unsigned mux_index, unsigned mux_mask);
int set_mio_mux(unsigned mux_index, unsigned mux_mask);
void   clearall_pinmux(void);

/*
#include <asm/arch/am_eth_pinmux.h>
int eth_clearall_pinmux(void);
int eth_set_pinmux(int bank_id,int clk_in_out_id,unsigned long ext_msk);
*/
#endif

