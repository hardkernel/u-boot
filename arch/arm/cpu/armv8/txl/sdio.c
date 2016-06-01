
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