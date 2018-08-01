/*
 * arch/arm/cpu/armv8/txlx/cec/cec.c
 *
 * Copyright (C) 2012 AMLOGIC, INC. All Rights Reserved.
 * Author: hongmin hua <hongmin hua@amlogic.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the smems of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 */


#include <common.h>
#include <command.h>
#include <asm/cpu_id.h>
#include <asm/arch/io.h>
#include <asm/arch/cec_tx_reg.h>
#include <amlogic/aml_cec.h>
#include <asm/arch/secure_apb.h>
#include "cec.h"

static void waiting_aocec_free(void) {
	do {
		unsigned long cnt = 0;
		while (readl(P_AO_CEC_RW_REG) & (1<<23))
		{
			if (5000 == cnt++)
			{
				break;
			}
		}
	} while(0);
}

static unsigned long cec_rd_reg(unsigned long addr)
{
	unsigned long data32;
	waiting_aocec_free();
	data32  = 0;
	data32 |= 0    << 16;  /* [16]   cec_reg_wr */
	data32 |= 0    << 8;   /* [15:8] cec_reg_wrdata */
	data32 |= addr << 0;   /* [7:0]  cec_reg_addr */
	writel(data32, P_AO_CEC_RW_REG);
	waiting_aocec_free();
	data32 = ((readl(P_AO_CEC_RW_REG)) >> 24) & 0xff;
	return (data32);
} /* cec_rd_reg */

static void cec_wr_reg (unsigned long addr, unsigned long data)
{
	unsigned long data32;
	waiting_aocec_free();
	data32  = 0;
	data32 |= 1    << 16;  /* [16]   cec_reg_wr */
	data32 |= data << 8;   /* [15:8] cec_reg_wrdata */
	data32 |= addr << 0;   /* [7:0]  cec_reg_addr */
	writel(data32, P_AO_CEC_RW_REG);
} /* aocec_wr_only_reg */

static inline void cec_set_bits_dwc(uint32_t reg, uint32_t bits,
				       uint32_t start, uint32_t len)
{
	unsigned int tmp;
	tmp = cec_rd_reg(reg);
	tmp &= ~(((1 << len) - 1) << start);
	tmp |=  (bits << start);
	cec_wr_reg(reg, tmp);
}

void cec_set_reg_bits(unsigned long addr, unsigned int value,
	unsigned int offset, unsigned int len)
{
	unsigned int data32 = 0;

	data32 = readl(addr);
	data32 &= ~(((1 << len) - 1) << offset);
	data32 |= (value & ((1 << len) - 1)) << offset;
	writel(data32, addr);
}

static void cec_arbit_bit_time_set(unsigned bit_set, unsigned time_set)
{
	//11bit:bit[10:0]
	switch (bit_set) {
	case 3:
		//3 bit
		cec_wr_reg(AO_CEC_TXTIME_4BIT_BIT7_0, time_set & 0xff);
		cec_wr_reg(AO_CEC_TXTIME_4BIT_BIT10_8, (time_set >> 8) & 0x7);
		break;
		//5 bit
	case 5:
		cec_wr_reg(AO_CEC_TXTIME_2BIT_BIT7_0, time_set & 0xff);
		cec_wr_reg(AO_CEC_TXTIME_2BIT_BIT10_8, (time_set >> 8) & 0x7);
		//7 bit
	case 7:
		cec_wr_reg(AO_CEC_TXTIME_17MS_BIT7_0, time_set & 0xff);
		cec_wr_reg(AO_CEC_TXTIME_17MS_BIT10_8, (time_set >> 8) & 0x7);
		break;
	default:
		break;
	}
}

void cec_hw_reset(void)
{
	unsigned int reg;
	printf("cec a reset cmd\n");

	reg = readl(P_AO_CRT_CLK_CNTL1);
	/* 24MHz/ (731 + 1) = 32786.885Hz */
	reg &= ~(0x7ff << 16);
	reg |= (731 << 16); 	/* divider from 24MHz */
	reg |= (0x1 << 26);
	reg &= ~(0x800 << 16);	/* select divider */
	writel(reg, P_AO_CRT_CLK_CNTL1);

	/* set up pinmux */
	writel(readl(P_AO_RTI_PIN_MUX_REG) & (~(1 << 14 | 1 << 17)), P_AO_RTI_PIN_MUX_REG);
	writel(readl(P_AO_RTI_PULL_UP_REG) & (~(1 << 9)), P_AO_RTI_PULL_UP_REG);
	writel(readl(P_AO_RTI_PIN_MUX_REG) | (1 << 15), P_AO_RTI_PIN_MUX_REG);
	// Assert SW reset AO_CEC
	writel(0x1, P_AO_CEC_GEN_CNTL);
	// Enable gated clock (Normal mode).
	writel(readl(P_AO_CEC_GEN_CNTL) | (1<<1), P_AO_CEC_GEN_CNTL);
	udelay(100);
	// Release SW reset
	writel(readl(P_AO_CEC_GEN_CNTL) & ~(1<<0), P_AO_CEC_GEN_CNTL);
	writel(readl(P_AO_CEC_INTR_MASKN) | (0x03 << 1), P_AO_CEC_INTR_MASKN);

	cec_arbit_bit_time_set(3, 0x118);
	cec_arbit_bit_time_set(5, 0x000);
	cec_arbit_bit_time_set(7, 0x2aa);
}

static void cec_hw_buf_clear(void)
{
	cec_wr_reg(CEC_RX_MSG_CMD, RX_DISABLE);
	cec_wr_reg(CEC_TX_MSG_CMD, TX_ABORT);
	cec_wr_reg(CEC_RX_CLEAR_BUF, 1);
	cec_wr_reg(CEC_TX_CLEAR_BUF, 1);
	udelay(100);
	cec_wr_reg(CEC_RX_CLEAR_BUF, 0);
	cec_wr_reg(CEC_TX_CLEAR_BUF, 0);
	udelay(100);
	cec_wr_reg(CEC_RX_MSG_CMD, RX_NO_OP);
	cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
}

static void cec_set_log_addr(int l_add)
{
	cec_wr_reg(CEC_LOGICAL_ADDR0, 0);
	cec_hw_buf_clear();
	cec_wr_reg(CEC_LOGICAL_ADDR0, (l_add & 0xf));
	udelay(100);
	cec_wr_reg(CEC_LOGICAL_ADDR0, (0x1 << 4) | (l_add & 0xf));
}

static unsigned int cec_get_log_addr(void)
{
	return cec_rd_reg(CEC_LOGICAL_ADDR0);
}

int cec_hw_init(int logic_addr, unsigned char fun_cfg)
{
	if (fun_cfg & (1 << CEC_FUNC_MASK)) {
		cec_hw_reset();
		cec_set_log_addr(logic_addr);
	}
	writel(fun_cfg, P_AO_DEBUG_REG0);
	printf("cec function:%#x, log_addr:%#x,%#x\n", readl(P_AO_DEBUG_REG0),
	       cec_get_log_addr(), readl(AO_DEBUG_REG1));
	return 0;
}

