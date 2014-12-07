/*
* (C) Copyright 2014 Hardkernel Co,.Ltd
*
* See file CREDITS for list of people who contributed to this
* project.
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation; either version 2 of
* the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston,
* MA 02111-1307 USA
*/

#include <common.h>
#include <asm/arch/aml_eth_reg.h>
#include <asm/arch/aml_eth_pinmux.h>
#include <asm/arch/io.h>

#if defined(CONFIG_CMD_NET)
static void setup_net_chip(void)
{
        eth_aml_reg0_t eth_reg0;

        /* Supporting RTL8211F Gigabit Phy and use RGMII interface
        */
        SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_6, 0x3f4f);
        SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_7, 0xf00000);
        eth_reg0.d32 = 0;
        eth_reg0.b.phy_intf_sel = 1;
        eth_reg0.b.data_endian = 0;
        eth_reg0.b.desc_endian = 0;
        eth_reg0.b.rx_clk_rmii_invert = 0;
        eth_reg0.b.rgmii_tx_clk_src = 0;
        eth_reg0.b.rgmii_tx_clk_phase = 0;
        eth_reg0.b.rgmii_tx_clk_ratio = 2;
        eth_reg0.b.phy_ref_clk_enable = 1;
        eth_reg0.b.clk_rmii_i_invert = 1;
        eth_reg0.b.clk_en = 1;
        eth_reg0.b.adj_enable = 1;
        eth_reg0.b.adj_setup = 1;
        eth_reg0.b.adj_delay = 4;
        eth_reg0.b.adj_skew = 0xc;
        eth_reg0.b.cali_start = 0;
        eth_reg0.b.cali_rise = 0;
        eth_reg0.b.cali_sel = 0;
        eth_reg0.b.rgmii_rx_reuse = 0;
        eth_reg0.b.eth_urgent = 0;
        WRITE_CBUS_REG(0x2050, eth_reg0.d32);// rgmii mode
        SET_CBUS_REG_MASK(0x10a5,1 << 27);
        WRITE_CBUS_REG(0x2050, 0x7d21);// rgmii mode
        SET_CBUS_REG_MASK(0x108a, 0xb803);
        SET_CBUS_REG_MASK(HHI_MPLL_CNTL9, (1638 << 0)
                        | (0 << 14) | (1 << 15) | (1 << 14)
                        | (5 << 16)
                        | (0 << 25) | (0 << 26) | (0 << 30) | (0 << 31));

        /* setup ethernet mode */
        CLEAR_CBUS_REG_MASK(HHI_MEM_PD_REG0, (1 << 3) | (1 << 2));
        /* hardware reset ethernet phy : gpioh_4 connect phyreset pin*/
        CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO3_EN_N, 1 << 23);
        CLEAR_CBUS_REG_MASK(PREG_PAD_GPIO3_O, 1 << 23);
        udelay(2000);
        SET_CBUS_REG_MASK(PREG_PAD_GPIO3_O, 1 << 23);
}

int board_eth_init(bd_t *bis)
{
        setup_net_chip();
        udelay(1000);
        aml_eth_init(bis);

        eth_setenv_enetaddr("ethaddr", board_read_macaddr());

        return 0;
}
#endif
