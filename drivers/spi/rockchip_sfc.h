/*
 * sfc driver for rockchip
 *
 * (C) Copyright 2008-2016 Rockchip Electronics
 * Yifeng.zhao, Software Engineering, <zhao0116@gmail.com>.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef __RK_SFC_H
#define __RK_SFC_H

struct rockchip_sfc_reg {
	u32 ctrl;
	u32 imr;
	u32 iclr;
	u32 ftlr;
	u32 rcvr;
	u32 ax;
	u32 abit;
	u32 isr;
	u32 fsr;
	u32 sr;
	u32 risr;
	u32 reserved[21];
	u32 dmatr;
	u32 dmaaddr;
	u32 reserved1[30];
	u32 cmd;
	u32 addr;
	u32 data;
};
check_member(rockchip_sfc_reg, data, 0x108);

/*SFC_CTRL*/
#define SFC_DATA_WIDTH_SHIFT	12
#define SFC_DATA_WIDTH_MASK	GENMASK(13, 12)
#define SFC_ADDR_WIDTH_SHIFT	10
#define SFC_ADDR_WIDTH_MASK	GENMASK(11, 10)
#define SFC_CMD_WIDTH_SHIFT	8
#define SFC_CMD_WIDTH_MASK	GENMASK(9, 8)
#define SFC_DATA_SHIFT_NEGETIVE	BIT(1)

/*SFC_CMD*/
#define SFC_DUMMY_BITS_SHIFT	8
#define SFC_RW_SHIFT		12
#define SFC_WR			1
#define SFC_RD			0
#define SFC_ADDR_BITS_SHIFT	14
#define SFC_ADDR_BITS_MASK	GENMASK(15, 14)
#define SFC_ADDR_0BITS		0
#define SFC_ADDR_24BITS		1
#define SFC_ADDR_32BITS		2
#define SFC_ADDR_XBITS		3
#define SFC_TRB_SHIFT		(16)
#define SFC_TRB_MASK		GENMASK(29, 16)

/* Dma start trigger signal. Auto cleared after write */
#define SFC_DMA_START		BIT(0)

#define SFC_RESET		BIT(0)

/*SFC_FSR*/
#define SFC_RXLV_SHIFT		(16)
#define SFC_RXLV_MASK		GENMASK(20, 16)
#define SFC_TXLV_SHIFT		(8)
#define SFC_TXLV_MASK		GENMASK(12, 8)
#define SFC_RX_FULL		BIT(3)	/* rx fifo full */
#define SFC_RX_EMPTY		BIT(2)	/* rx fifo empty */
#define SFC_TX_EMPTY		BIT(1)	/* tx fifo empty */
#define SFC_TX_FULL		BIT(0)	/* tx fifo full */

#define SFC_BUSY		BIT(0)	/* sfc busy flag */

/*SFC_RISR*/
#define DMA_FINISH_INT		BIT(7)        /* dma interrupt */
#define SPI_ERR_INT		BIT(6)        /* Nspi error interrupt */
#define AHB_ERR_INT		BIT(5)        /* Ahb bus error interrupt */
#define TRANS_FINISH_INT	BIT(4)        /* Transfer finish interrupt */
#define TX_EMPTY_INT		BIT(3)        /* Tx fifo empty interrupt */
#define TX_OF_INT		BIT(2)        /* Tx fifo overflow interrupt */
#define RX_UF_INT		BIT(1)        /* Rx fifo underflow interrupt */
#define RX_FULL_INT		BIT(0)        /* Rx fifo full interrupt */

#define SFC_MAX_TRB		(512 * 31)

#endif
