
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
#include <asm/cpu_id.h>
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
	switch (port)
	{
	case SDIO_PORT_A:
		clrsetbits_le32(P_PERIPHS_PIN_MUX_3,
						0xFFFFFF, 0x111111);
		break;
	case SDIO_PORT_B:
		clrsetbits_le32(P_PAD_DS_REG3A, 0xFFFF, 0x5555);
		setbits_le32(P_PAD_PULL_UP_EN_REG3, 0x7F);
		setbits_le32(P_PAD_PULL_UP_REG3, 0x7F);
		/*
		clrbits_le32(P_PREG_PAD_GPIO5_O, 1<<17);
		*/
		if (sd_debug_board_1bit_flag == 1)
			clrsetbits_le32(P_PERIPHS_PIN_MUX_4,
					((0xFF << 16) | 0xF), ((0x11 << 16) | 0x1));
		else
			clrsetbits_le32(P_PERIPHS_PIN_MUX_4,
				0xFFFFFF, 0x111111);

		break;
	case SDIO_PORT_C:
		/* set driver strength */
		writel(0xFFFFFFFF, P_PAD_DS_REG0A);
		setbits_le32(P_PAD_PULL_UP_EN_REG0, 0x3fff);
		setbits_le32(P_PAD_PULL_UP_REG0, 0x3fff);

		/* pull up data by default */
		clrbits_le32(P_PERIPHS_PIN_MUX_0, (0xFFFFF << 12));
		/* set pinmux */
		writel(0x11111111, P_PERIPHS_PIN_MUX_0);
		clrsetbits_le32(P_PERIPHS_PIN_MUX_1,
						((0xFFFFF) | (0xF << 20)),
						((0x1 << 12) | (0x1 << 8) | 0x1));
		/* hardware reset with pull boot12 */
		clrbits_le32(P_PREG_PAD_GPIO0_EN_N, 1<<12);
		clrbits_le32(P_PREG_PAD_GPIO0_O, 1<<12);
		udelay(10);
		setbits_le32(P_PREG_PAD_GPIO0_O, 1<<12);
		break;
	default:
		return -1;
	}
	return 0;
}

/* return:
	0: insert
	1: not insert
 */
__weak int  sd_emmc_detect(unsigned port)
{
	int ret = 0;
	unsigned pinmux_5;
    switch (port) {

	case SDIO_PORT_A:
		break;
	case SDIO_PORT_B:
		pinmux_5 = readl(P_PERIPHS_PIN_MUX_5);
		clrbits_le32(P_PERIPHS_PIN_MUX_5, 0xF << 8);
		setbits_le32(P_PREG_PAD_GPIO3_EN_N, 1 << 10);
		setbits_le32(P_PAD_PULL_UP_EN_REG3, 1 << 10);
		setbits_le32(P_PAD_PULL_UP_REG3, 1 << 10);

		ret = readl(P_PREG_PAD_GPIO3_I) & (1 << 10);
		printf("%s\n", ret ? "card out" : "card in");
		if (!ret) {
			clrbits_le32(P_PERIPHS_PIN_MUX_5, 0xF << 12);
			setbits_le32(P_PREG_PAD_GPIO3_EN_N, 1 << 3);
			setbits_le32(P_PAD_PULL_UP_EN_REG3, 1 << 3);
			setbits_le32(P_PAD_PULL_UP_REG3, 1 << 3);
			/* debug board in when D3 is low */
			if (!(readl(P_PREG_PAD_GPIO3_I) & (1 << 3))) {
				/* switch uart to GPIOC(Card) */
				clrbits_le32(P_AO_RTI_PINMUX_REG0, 0xFF);
				clrsetbits_le32(P_PERIPHS_PIN_MUX_4, 0xFF << 8, 0x22 << 8);
				clrsetbits_le32(P_PERIPHS_PIN_MUX_4,
						((0xFF << 16) | 0xF), ((0x11 << 16) | 0x1));
				printf("sdio debug board detected\n");
				sd_debug_board_1bit_flag = 1;
			} else {
				//4bit card
				writel(pinmux_5, P_PERIPHS_PIN_MUX_5);
				sd_debug_board_1bit_flag = 0;
			}

		}
		break;
	default:
		break;
	}
	return ret;
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
