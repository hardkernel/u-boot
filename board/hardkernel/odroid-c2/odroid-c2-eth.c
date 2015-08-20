/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <malloc.h>
#include <asm/arch/eth_setup.h>
#include <asm/arch/secure_apb.h>

#if defined(CONFIG_AML_ETHERNET)
extern int aml_eth_init(bd_t *bis);

struct eth_board_socket* eth_board_setup(char *name)
{
	struct eth_board_socket* new_board;

	new_board = (struct eth_board_socket*)
		malloc(sizeof(struct eth_board_socket));
	if (NULL == new_board)
		return NULL;

	if (name != NULL) {
		new_board->name = (char*)malloc(strlen(name));
		strncpy(new_board->name, name, strlen(name));
	} else {
		new_board->name = CONFIG_SYS_BOARD;
	}

	new_board->eth_pinmux_setup = NULL ;
	new_board->eth_clock_configure = NULL;
	new_board->eth_hw_reset = NULL;

	return new_board;
}

static void setup_net_chip(void)
{
	eth_aml_reg0_t reg;

	/*
	 * Set up ethernet clk need calibrate to configure
	 */
	setbits_le32(P_PERIPHS_PIN_MUX_6, 0x3fff);

	reg.d32 = 0;
	reg.b.phy_intf_sel = 1;
	reg.b.data_endian = 0;
	reg.b.desc_endian = 0;
	reg.b.rx_clk_rmii_invert = 0;
	reg.b.rgmii_tx_clk_src = 0;
	reg.b.rgmii_tx_clk_phase = 1;
	reg.b.rgmii_tx_clk_ratio = 4;
	reg.b.phy_ref_clk_enable = 1;
	reg.b.clk_rmii_i_invert = 0;
	reg.b.clk_en = 1;
	reg.b.adj_enable = 0;
	reg.b.adj_setup = 0;
	reg.b.adj_delay = 0;
	reg.b.adj_skew = 0;
	reg.b.cali_start = 0;
	reg.b.cali_rise = 0;
	reg.b.cali_sel = 0;
	reg.b.rgmii_rx_reuse = 0;
	reg.b.eth_urgent = 0;

	/* RGMII Mode */
	setbits_le32(P_PREG_ETH_REG0, reg.d32);

	setbits_le32(HHI_GCLK_MPEG1, 1 << 3);

	/*
	 * Power on memory
	 */
	clrbits_le32(HHI_MEM_PD_REG0, (1 << 3) | (1<<2));

	/*
	 * Hardware reset ethernet phy : GPIOZ_14
	 */
	clrbits_le32(PREG_PAD_GPIO3_EN_N, 1 << 14);
	clrbits_le32(PREG_PAD_GPIO3_O, 1 << 14);
	udelay(100000);
	setbits_le32(PREG_PAD_GPIO3_O, 1 << 14);
}

int board_eth_init(bd_t *bis)
{
	setup_net_chip();
	udelay(1000);
	aml_eth_init(bis);

	return 0;
}
#endif
