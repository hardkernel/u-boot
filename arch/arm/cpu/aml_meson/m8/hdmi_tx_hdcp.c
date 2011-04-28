/*
 * Amlogic MX
 * frame buffer driver-----------HDMI_TX
 * Copyright (C) 2010 Amlogic, Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the named License,
 * or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 */

#include <asm/arch/io.h>
#include <common.h>
#include "hdmi_tx_reg.h"
#include <asm/cpu_id.h>

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

    for(i = 0; i < GATE_NUM; i++){
        if(!(READ_CBUS_REG(hdmi_gate[i].cbus_addr) & (1<<hdmi_gate[i].gate_bit))){
//            printf("HDMI Gate Clock is off, turn on now\n");
            WRITE_CBUS_REG_BITS(hdmi_gate[i].cbus_addr, 1, hdmi_gate[i].gate_bit, 1);
        }
    }
}

unsigned long hdmi_hdcp_rd_reg(unsigned long addr)
{
    unsigned long data;
    check_cts_hdmi_sys_clk_status();

    aml_write_reg32(P_HDMI_ADDR_PORT, addr);
    aml_write_reg32(P_HDMI_ADDR_PORT, addr);

    data = aml_read_reg32(P_HDMI_DATA_PORT);

    return (data);
}

void hdmi_hdcp_wr_reg(unsigned long addr, unsigned long data)
{
    check_cts_hdmi_sys_clk_status();

    aml_write_reg32(P_HDMI_ADDR_PORT, addr);
    aml_write_reg32(P_HDMI_ADDR_PORT, addr);

    aml_write_reg32(P_HDMI_DATA_PORT, data);
}

static void vpu_init(void)
{
    writel((1 << 8) | (7 << 9), P_HHI_VPU_CLK_CNTL);

    clrbits_le32(P_AO_RTI_GEN_PWR_SLEEP0, (0x1<<8)); // [8] power on
    writel(0x00000000, P_HHI_VPU_MEM_PD_REG0);
    writel(0x00000000, P_HHI_VPU_MEM_PD_REG1);

    //Reset VIU + VENC
    //Reset VENCI + VENCP + VADC + VENCL
    //Reset HDMI-APB + HDMI-SYS + HDMI-TX + HDMI-CEC
    clrbits_le32(P_RESET0_MASK, ((0x1 << 5) | (0x1<<10)));
    clrbits_le32(P_RESET4_MASK, ((0x1 << 6) | (0x1<<7) | (0x1<<9) | (0x1<<13)));
    clrbits_le32(P_RESET2_MASK, ((0x1 << 2) | (0x1<<3) | (0x1<<11) | (0x1<<15)));
    writel(((0x1 << 2) | (0x1<<3) | (0x1<<11) | (0x1<<15)), P_RESET2_REGISTER);
    writel(((0x1 << 6) | (0x1<<7) | (0x1<<9) | (0x1<<13)), P_RESET4_REGISTER);    // reset this will cause VBUS reg to 0
    writel(((0x1 << 5) | (0x1<<10)), P_RESET0_REGISTER);
    writel(((0x1 << 6) | (0x1<<7) | (0x1<<9) | (0x1<<13)), P_RESET4_REGISTER);
    writel(((0x1 << 2) | (0x1<<3) | (0x1<<11) | (0x1<<15)), P_RESET2_REGISTER);
    setbits_le32(P_RESET0_MASK, ((0x1 << 5) | (0x1<<10)));
    setbits_le32(P_RESET4_MASK, ((0x1 << 6) | (0x1<<7) | (0x1<<9) | (0x1<<13)));
    setbits_le32(P_RESET2_MASK, ((0x1 << 2) | (0x1<<3) | (0x1<<11) | (0x1<<15)));

    //Remove VPU_HDMI ISO
    clrbits_le32(P_AO_RTI_GEN_PWR_SLEEP0, (0x1<<9)); // [9] VPU_HDMI
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
    if (!(IS_MESON_M8_CPU))
        vpu_init();
    WRITE_CBUS_REG_BITS(HHI_MEM_PD_REG0, 0x00, 8, 8);
    for(i = 0; i < TX_HDCP_KSV_SIZE; i++) {
        hdmi_hdcp_wr_reg(TX_HDCP_KSV_OFFSET + i, 0x00);
    }
    printf("clr h-ram\n");
    return 0;
}

