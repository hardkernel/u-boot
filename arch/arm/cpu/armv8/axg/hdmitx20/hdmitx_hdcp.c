
/*
 * arch/arm/cpu/armv8/txl/hdmitx20/hdmitx_hdcp.c
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

#include <asm/arch/io.h>
#include <common.h>
#include "hdmi_tx_reg.h"

// if the following bits are 0, then access HDMI IP Port will cause system hungup
#define GATE_NUM    2

static struct Hdmi_Gate_s{
    unsigned short cbus_addr;
    unsigned char gate_bit;
}hdmi_gate[GATE_NUM] =   {   {HHI_HDMI_CLK_CNTL, 8},
                            {HHI_GCLK_MPEG2   , 4},
                            };

// In order to prevent system hangup, add check_cts_hdmi_sys_clk_status() to check
static void check_cts_hdmi_sys_clk_status(void)
{
    int i;

    for (i = 0; i < GATE_NUM; i++) {
        if (!(READ_CBUS_REG(hdmi_gate[i].cbus_addr) & (1<<hdmi_gate[i].gate_bit))) {
//            printf("HDMI Gate Clock is off, turn on now\n");
            WRITE_CBUS_REG_BITS(hdmi_gate[i].cbus_addr, 1, hdmi_gate[i].gate_bit, 1);
        }
    }
}

unsigned long hdmi_hdcp_rd_reg(unsigned long addr)
{
    unsigned long data;
    check_cts_hdmi_sys_clk_status();
    WRITE_APB_REG(HDMI_ADDR_PORT, addr);
    WRITE_APB_REG(HDMI_ADDR_PORT, addr);

    data = READ_APB_REG(HDMI_DATA_PORT);

    return (data);
}

void hdmi_hdcp_wr_reg(unsigned long addr, unsigned long data)
{
    check_cts_hdmi_sys_clk_status();
    WRITE_APB_REG(HDMI_ADDR_PORT, addr);
    WRITE_APB_REG(HDMI_ADDR_PORT, addr);

    WRITE_APB_REG(HDMI_DATA_PORT, data);
}

#define TX_HDCP_KSV_OFFSET          0x540
#define TX_HDCP_KSV_SIZE            5
// Must be done by system init
// In kenrel hdmi driver, it will get AKSV value
// If equals to 0, then kernel won't enable HDCP
extern int hdmi_hdcp_clear_ksv_ram(void);
int hdmi_hdcp_clear_ksv_ram(void)
{
    int i;
    for (i = 0; i < TX_HDCP_KSV_SIZE; i++) {
        hdmi_hdcp_wr_reg(TX_HDCP_KSV_OFFSET + i, 0x00);
    }
    printf("clr h-ram\n");
    return 0;
}

