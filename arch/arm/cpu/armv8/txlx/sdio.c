
/*
 * arch/arm/cpu/armv8/txl/sdio.c
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
#include <common.h>
#include <config.h>
#include <asm/arch/io.h>
#include <asm/arch/cpu_sdio.h>
#include <asm/arch/secure_apb.h>

void  cpu_sd_emmc_pwr_prepare(unsigned port)
{
//    switch(port)
//    {
//        case SDIO_PORT_A:
//            clrbits_le32(P_PREG_PAD_GPIO4_EN_N,0x30f);
//            clrbits_le32(P_PREG_PAD_GPIO4_O   ,0x30f);
//            clrbits_le32(P_PERIPHS_PIN_MUX_8,0x3f);
//            break;
//        case SDIO_PORT_B:
//            clrbits_le32(P_PREG_PAD_GPIO5_EN_N,0x3f<<23);
//            clrbits_le32(P_PREG_PAD_GPIO5_O   ,0x3f<<23);
//            clrbits_le32(P_PERIPHS_PIN_MUX_2,0x3f<<10);
//            break;
//        case SDIO_PORT_C:
//            //clrbits_le32(P_PREG_PAD_GPIO3_EN_N,0xc0f);
//            //clrbits_le32(P_PREG_PAD_GPIO3_O   ,0xc0f);
//            //clrbits_le32(P_PERIPHS_PIN_MUX_6,(0x3f<<24));break;
//            break;
//    }

    /**
        do nothing here
    */
}
unsigned sd_debug_board_1bit_flag = 0;

__weak int sd_emmc_detect(unsigned port)
{
    int ret;
    switch (port) {

    case SDIO_PORT_A:
        break;

    case SDIO_PORT_B:
        /* set CD pin as input */
        setbits_le32(P_PREG_PAD_GPIO1_EN_N, 0x1 << 30);
        ret = readl(P_PREG_PAD_GPIO1_I) & (1 << 30) ? 0 : 1;
        printf("%s\n", ret ? "card in" : "card out");
		if ((readl(P_PERIPHS_PIN_MUX_6) & (3 << 8))) { //if uart pinmux set, debug board in
			if (!(readl(P_PREG_PAD_GPIO2_I) & (1 << 24))) {
                printf("sdio debug board detected, sd card with 1bit mode\n");
                sd_debug_board_1bit_flag = 1;
            } else {
                printf("sdio debug board detected, no sd card in\n");
                sd_debug_board_1bit_flag = 0;
                return 1;
            }
        }
        break;

    default:
        break;
    }
    return 0;
}

int cpu_sd_emmc_init(unsigned port)
{

	//printf("inand sdio  port:%d\n",port);
	switch (port)
	{
	case SDIO_PORT_A:
        setbits_le32(P_PERIPHS_PIN_MUX_5, (0x3f << 26) | (0x1 << 24));
		break;
	case SDIO_PORT_B:
		if (sd_debug_board_1bit_flag == 1)
			setbits_le32(P_PERIPHS_PIN_MUX_6, 0x7 << 2);
        else {
            clrbits_le32(P_PERIPHS_PIN_MUX_6, 0x3f << 6);
			setbits_le32(P_PERIPHS_PIN_MUX_6, 0x3f << 0);
        }
		break;
	case SDIO_PORT_C://SDIOC GPIOB_2~GPIOB_7
		clrbits_le32(P_PERIPHS_PIN_MUX_7, (0x7 << 5) | (0xff << 16));
		setbits_le32(P_PERIPHS_PIN_MUX_7, 0x7 << 29);
        //printf("inand sdio  port:%d\n",port);
		break;
	default:
		return -1;
	}
	return 0;
}

__weak void sd_emmc_para_config(struct sd_emmc_global_regs *reg,
		unsigned int clock, unsigned int port)
{
	unsigned int clk = reg->gclock;

	if (port == SDIO_PORT_C) {
		clk &= ~(3 << Cfg_co_phase);
		clk |= (3 << Cfg_co_phase);
	}
	reg->gclock = clk;
	return;
}
