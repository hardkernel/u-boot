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
#include "cec.h"

static unsigned long cec_rd_reg(unsigned long addr)
{
	unsigned long data32;

	data32  = 0;
	data32 |= 0    << 16;  /* [16]   cec_reg_wr */
	data32 |= 0    << 8;   /* [15:8] cec_reg_wrdata */
	data32 |= addr << 0;   /* [7:0]  cec_reg_addr */
	writel(data32, AO_CECB_RW_REG);
	data32 = ((readl(AO_CECB_RW_REG)) >> 24) & 0xff;
	return data32;
} /* cec_rd_reg */

static void cec_wr_reg(unsigned long addr, unsigned long data)
{
	unsigned long data32;

	data32  = 0;
	data32 |= 1    << 16;  /* [16]   cec_reg_wr */
	data32 |= data << 8;   /* [15:8] cec_reg_wrdata */
	data32 |= addr << 0;   /* [7:0]  cec_reg_addr */
	writel(data32, AO_CECB_RW_REG);
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

static void cec_set_reg_bits(unsigned long addr, unsigned int value,
	unsigned int offset, unsigned int len)
{
	unsigned int data32 = 0;

	data32 = readl(addr);
	data32 &= ~(((1 << len) - 1) << offset);
	data32 |= (value & ((1 << len) - 1)) << offset;
	writel(data32, addr);
}

void cec_hw_reset(void)
{
	unsigned int reg;
	unsigned int data32;
	printf("cec b reset\n");

	reg =   (0 << 31) |
		(0 << 30) |
		(1 << 28) |		/* clk_div0/clk_div1 in turn */
		((732-1) << 12) |	/* Div_tcnt1 */
		((733-1) << 0);		/* Div_tcnt0 */
	writel(reg, AO_CECB_CLK_CNTL_REG0);
	reg =   (0 << 13) |
		((11-1)  << 12) |
		((8-1)  <<  0);
	writel(reg, AO_CECB_CLK_CNTL_REG1);

	reg = readl(AO_CECB_CLK_CNTL_REG0);
	reg |= (1 << 31);
	writel(reg, AO_CECB_CLK_CNTL_REG0);

	udelay(200);
	reg |= (1 << 30);
	writel(reg, AO_CECB_CLK_CNTL_REG0);

	reg = readl(AO_RTI_PWR_CNTL_REG0);
	reg |=  (0x01 << 6);	/* xtal gate */
	writel(reg, AO_RTI_PWR_CNTL_REG0);

	data32  = 0;
	data32 |= (7 << 12);	/* filter_del */
	data32 |= (1 <<  8);	/* filter_tick: 1us */
	data32 |= (1 <<  3);	/* enable system clock */
	data32 |= 0 << 1;	/* [2:1]	cntl_clk: */
				/* 0=Disable clk (Power-off mode); */
				/* 1=Enable gated clock (Normal mode); */
				/* 2=Enable free-run clk (Debug mode). */
	data32 |= 1 << 0;	/* [0]	  sw_reset: 1=Reset */
	writel(data32, AO_CECB_GEN_CNTL);
	/* Enable gated clock (Normal mode). */
	cec_set_reg_bits(AO_CECB_GEN_CNTL, 1, 1, 1);
	/* Release SW reset */
	cec_set_reg_bits(AO_CECB_GEN_CNTL, 0, 0, 1);

	/* set up pinmux */
	writel(readl(AO_RTI_PIN_MUX_REG) & (~(1 << 14 | 1 << 15 | 1 << 17)),
	       AO_RTI_PIN_MUX_REG);
	writel(readl(AO_RTI_PULL_UP_REG) & (~(1 << 7)), AO_RTI_PULL_UP_REG);
	writel(readl(AO_RTI_PIN_MUX_REG2) | (1 << 13), AO_RTI_PIN_MUX_REG2);
	writel(CECB_IRQ_EN_MASK, AO_CECB_INTR_MASKN);
}

static void cec_set_log_addr(int addr)
{
	cec_wr_reg(DWC_CECB_LADD_LOW, 0);
	cec_wr_reg(DWC_CECB_LADD_HIGH, 0x80);
	if (addr > 15)
		return;

	/*save logic addr for kernel*/
	cec_set_reg_bits(AO_DEBUG_REG1, addr, 16, 4);
	/*write the logic addr*/
	if ((addr & 0x0f) < 8)
		cec_wr_reg(DWC_CECB_LADD_LOW, 1 << addr);
	else
		cec_wr_reg(DWC_CECB_LADD_HIGH, (1 << (addr - 8)) | 0x80);
	udelay(100);
}

static unsigned char cec_get_log_addr(void)
{
	int i, reg;

	reg = cec_rd_reg(DWC_CECB_LADD_LOW);
	reg = (cec_rd_reg(DWC_CECB_LADD_HIGH) << 8) | reg;
	for (i = 0; i < 16; i++) {
		if (reg & (1 << i))
			break;
	}
	if (reg & 0x8000 && i < 16)
		return i + 16;
	else if (i < 16)
		return i;
	return 0xff;
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

