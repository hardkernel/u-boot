/*
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
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
 */

#include <config.h>
#include <asm/arch/io.h>
#include <asm/arch/cpu_sdio.h>
#include <asm/arch/secure_apb.h>
#include <common.h>

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
int cpu_sd_emmc_init(unsigned port)
{

	//printf("inand sdio  port:%d\n",port);
	switch (port)
	{
	case SDIO_PORT_A:
		//setbits_le32(P_PERIPHS_PIN_MUX_5, (0x3f << 26) | (0x1 << 24));
		break;
	case SDIO_PORT_B:
		if (sd_debug_board_1bit_flag == 1)
			setbits_le32(P_PERIPHS_PIN_MUX_9, 0x110001);
        else {
            setbits_le32(P_PERIPHS_PIN_MUX_9, 0x111111);
        }
		break;
	case SDIO_PORT_C://SDIOC GPIOB_2~GPIOB_7
		/*pull up data by default*/
		setbits_le32(P_PAD_PULL_UP_EN_REG2, 0xfff);
		setbits_le32(P_PAD_PULL_UP_REG2, 0xfff);
		/*set pinmux*/
		clrbits_le32(P_PERIPHS_PIN_MUX_0, 0xffffffff);
		setbits_le32(P_PERIPHS_PIN_MUX_0, 0x11111111);
		clrbits_le32(P_PERIPHS_PIN_MUX_1, 0xff0f);
		setbits_le32(P_PERIPHS_PIN_MUX_1, 0x1101);
		/*HW reset*/
		clrbits_le32(P_PREG_PAD_GPIO2_EN_N, (1<<9));
		clrbits_le32(P_PREG_PAD_GPIO2_O, (1<<9));
		udelay(10);
		setbits_le32(P_PREG_PAD_GPIO2_O, (1<<9));
        //printf("inand sdio  port:%d\n",port);
		break;
	default:
		return -1;
	}
	return 0;
}
