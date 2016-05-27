
/*
 * arch/arm/cpu/armv8/gxb/sdio.c
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
#include <asm/cpu_id.h>

void  cpu_sd_emmc_pwr_prepare(unsigned port)
{
    /** here you can add io pin voltage operation if you need.
		but now it was used to open emmc gate for gxm
    */

	if ((port == SDIO_PORT_C)
        && (get_cpu_id().family_id >= MESON_CPU_MAJOR_ID_GXM)
        && (readl(HHI_NAND_CLK_CNTL) != 0x80))
        writel(0x80, HHI_NAND_CLK_CNTL);

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
		break;
	default:
		return -1;
	}
	return 0;
}