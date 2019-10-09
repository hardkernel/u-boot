/*
 * SFC driver for rockchip
 *
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 * Yifeng.zhao, Software Engineering, <zhao0116@gmail.com>.
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <bouncebuf.h>
#include <clk.h>
#include <dm.h>
#include <dt-structs.h>
#include <errno.h>
#include <spi.h>
#include <linux/errno.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/periph.h>
#include <dm/pinctrl.h>

DECLARE_GLOBAL_DATA_PTR;

#ifdef SFC_DEBUG
#define SFC_DBG printf
#else
#define SFC_DBG(args...)
#endif

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

enum rockchip_sfc_if_type {
	IF_TYPE_STD,
	IF_TYPE_DUAL,
	IF_TYPE_QUAD,
};

struct rockchip_sfc_platdata {
	s32 frequency;
	void *base;
};

struct rockchip_sfc {
	struct rockchip_sfc_reg *regbase;
	struct clk clk;
	unsigned int max_freq;
	unsigned int mode;
	unsigned int speed_hz;
	u32 cmd;
	u32 addr;
	u8 addr_bits;
	u8 dummy_bits;
	u8 rw;
	u32 trb;
};

static int rockchip_sfc_ofdata_to_platdata(struct udevice *bus)
{
	struct rockchip_sfc_platdata *plat = dev_get_platdata(bus);
	struct rockchip_sfc *sfc = dev_get_priv(bus);
	ofnode subnode;
	int ret;

	plat->base = dev_read_addr_ptr(bus);
	ret = clk_get_by_index(bus, 0, &sfc->clk);
	if (ret < 0) {
		printf("Could not get clock for %s: %d\n", bus->name, ret);
		return ret;
	}

	subnode = dev_read_first_subnode(bus);
	if (!ofnode_valid(subnode)) {
		printf("Error: subnode with SPI flash config missing!\n");
		return -ENODEV;
	}

	plat->frequency = ofnode_read_u32_default(subnode, "spi-max-frequency",
						  100000000);

	return 0;
}

static int rockchip_sfc_probe(struct udevice *bus)
{
	struct rockchip_sfc_platdata *plat = dev_get_platdata(bus);
	struct rockchip_sfc *sfc = dev_get_priv(bus);

	sfc->regbase = (struct rockchip_sfc_reg *)plat->base;

	return 0;
}

static int rockchip_sfc_reset(struct rockchip_sfc *sfc)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	int tbase = get_timer(0);
	u32 rcvr;
	int ret = 0;

	writel(SFC_RESET, &regs->rcvr);
	do {
		rcvr = readl(&regs->rcvr);
		if (get_timer(tbase) > 1000) {
			debug("sfc reset timeout\n");
			ret =  -ETIMEDOUT;
			break;
		}
		udelay(1);
	} while (rcvr);

	writel(0xFFFFFFFF, &regs->iclr);

	debug("sfc reset\n");

	return ret;
}

/* The SFC_CTRL register is a global control register,
 * when the controller is in busy state(SFC_SR),
 * SFC_CTRL cannot be set.
 */
static int rockchip_sfc_wait_idle(struct rockchip_sfc *sfc,
				  u32 timeout_ms)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	unsigned long tbase = get_timer(0);
	u32 sr, fsr;

	while (1) {
		sr = readl(&regs->sr);
		fsr = readl(&regs->fsr);
		if ((fsr & SFC_TX_EMPTY) &&
		    (fsr & SFC_RX_EMPTY) &&
		    !(sr & SFC_BUSY))
			break;
		if (get_timer(tbase) > timeout_ms) {
			printf("waite sfc idle timeout(sr:0x%08x fsr:0x%08x)\n",
				sr, fsr);
			rockchip_sfc_reset(sfc);
			return -ETIMEDOUT;
		}
		udelay(100);
	}

	return 0;
}

static u8 rockchip_sfc_get_if_type(struct rockchip_sfc *sfc)
{
	int type = IF_TYPE_STD;

	if (sfc->rw == SFC_WR) {
		if (sfc->mode & SPI_TX_QUAD)
			type = IF_TYPE_QUAD;
		else if (sfc->mode & SPI_TX_DUAL)
			type = IF_TYPE_DUAL;
		else
			type = IF_TYPE_STD;
	} else {
		if (sfc->mode & SPI_RX_QUAD)
			type = IF_TYPE_QUAD;
		else if (sfc->mode & SPI_RX_DUAL)
			type = IF_TYPE_DUAL;
		else
			type = IF_TYPE_STD;
	}

	return type;
}

static void rockchip_sfc_setup_xfer(struct rockchip_sfc *sfc, u32 trb)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	u32 val = 0x02;
	u8 data_width = IF_TYPE_STD;

	SFC_DBG("--- sfc.addr_bit %x\n", sfc->addr_bits);

	if (sfc->addr_bits == SFC_ADDR_24BITS ||
	    sfc->addr_bits == SFC_ADDR_32BITS)
		data_width = rockchip_sfc_get_if_type(sfc);

	val |= (data_width << SFC_DATA_WIDTH_SHIFT);

	rockchip_sfc_wait_idle(sfc, 10);

	SFC_DBG("--- sfc.ctrl %x\n", val);
	writel(val, &regs->ctrl);

	val = sfc->cmd;
	val |= trb << SFC_TRB_SHIFT;
	val |= sfc->rw << SFC_RW_SHIFT;
	val |= sfc->addr_bits << SFC_ADDR_BITS_SHIFT;
	val |= sfc->dummy_bits << SFC_DUMMY_BITS_SHIFT;

	SFC_DBG("--- sfc.cmd %x\n", val);
	writel(val, &regs->cmd);

	if (sfc->addr_bits & SFC_ADDR_XBITS) {
		SFC_DBG("--- sfc.addr %x\n", sfc->addr);
		writel(sfc->addr, &regs->addr);
	}
}

static int rockchip_sfc_dma_xfer(struct rockchip_sfc *sfc, void *buffer, size_t trb)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	struct bounce_buffer bb;
	unsigned int bb_flags;
	int timeout = 1000;
	int ret = 0;
	int risr;
	unsigned long tbase;

	if (sfc->rw == SFC_WR)
		bb_flags = GEN_BB_READ;
	else
		bb_flags = GEN_BB_WRITE;

	ret = bounce_buffer_start(&bb, buffer, trb, bb_flags);
	if (ret)
		return ret;

	rockchip_sfc_setup_xfer(sfc, bb.len_aligned);

	writel(0xFFFFFFFF, &regs->iclr);
	writel((unsigned long)bb.bounce_buffer, &regs->dmaaddr);
	writel(SFC_DMA_START, &regs->dmatr);

	tbase = get_timer(0);
	do {
		udelay(1);
		risr = readl(&regs->risr);
		if (get_timer(tbase) > timeout) {
			debug("dma timeout\n");
			ret = -ETIMEDOUT;
			break;
		}
	} while (!(risr & TRANS_FINISH_INT));

	writel(0xFFFFFFFF, &regs->iclr);

	bounce_buffer_stop(&bb);

	return ret;
}

static int rockchip_sfc_wait_fifo_ready(struct rockchip_sfc *sfc, int rw,
					u32 timeout)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	unsigned long tbase = get_timer(0);
	u8 level;
	u32 fsr;

	do {
		fsr = readl(&regs->fsr);
		if (rw == SFC_WR)
			level = (fsr & SFC_TXLV_MASK) >> SFC_TXLV_SHIFT;
		else
			level = (fsr & SFC_RXLV_MASK) >> SFC_RXLV_SHIFT;
		if (get_timer(tbase) > timeout)
			return -ETIMEDOUT;
		udelay(1);
	} while (!level);

	return level;
}

static int rockchip_sfc_write_fifo(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	u32 bytes = len & 0x3;
	u32 words = len >> 2;
	int tx_level = 0;
	u32 val = 0;
	u8 count;

	while (words) {
		tx_level = rockchip_sfc_wait_fifo_ready(sfc, SFC_WR, 1000);
		if (tx_level <= 0)
			return tx_level;
		count = min(words, (u32)tx_level);
		writesl(&regs->data, buf, count);
		buf += count;
		words -= count;
	}

	/* handle the last non 4byte aligned bytes */
	if (bytes) {
		tx_level = rockchip_sfc_wait_fifo_ready(sfc, SFC_WR, 1000);
		if (tx_level <= 0)
			return tx_level;
		memcpy(&val, buf, bytes);
		writel(val, &regs->data);
	}

	return 0;
}

static int rockchip_sfc_read_fifo(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	u32 bytes = len & 0x3;
	u32 words = len >> 2;
	int rx_level = 0;
	u32 count;
	u32 val;

	while (words) {
		rx_level = rockchip_sfc_wait_fifo_ready(sfc, SFC_RD, 1000);
		if (rx_level <= 0)
			return rx_level;
		count = min(words, (u32)rx_level);
		readsl(&regs->data, buf, count);
		buf += count;
		words -= count;
	}

	/* handle the last non 4 bytes aligned bytes */
	if (bytes) {
		rx_level = rockchip_sfc_wait_fifo_ready(sfc, SFC_RD, 1000);
		if (rx_level <= 0)
			return rx_level;
		val = readl(&regs->data);
		memcpy(buf, &val, bytes);
	}

	return 0;
}

static int rockchip_sfc_pio_xfer(struct rockchip_sfc *sfc, void *buf, u32 len)
{
	int ret = 0;

	rockchip_sfc_setup_xfer(sfc, len);

	if (len) {
		if (sfc->rw == SFC_WR)
			ret = rockchip_sfc_write_fifo(sfc, (u32 *)buf, len);
		else
			ret = rockchip_sfc_read_fifo(sfc, (u32 *)buf, len);
	}

	return ret;
}

static int rockchip_sfc_read(struct rockchip_sfc *sfc, u32 offset,
			     void *buf, size_t len)
{
	u32 dma_trans;
	u32 trb;
	u8 bytes;
	int ret;

	if (len >= ARCH_DMA_MINALIGN) {
		bytes = len & (ARCH_DMA_MINALIGN - 1);
		dma_trans = len - bytes;
	} else {
		dma_trans = 0;
		bytes = len;
	}

	while (dma_trans) {
		trb = min_t(size_t, dma_trans, SFC_MAX_TRB);
		ret = rockchip_sfc_dma_xfer(sfc, buf, trb);
		if (ret < 0)
			return ret;
		dma_trans -= trb;
		sfc->addr += trb;
		buf += trb;
	}

	/*
	 * transfer the last non dma anligned byte by pio mode
	 */
	if (bytes)
		ret = rockchip_sfc_pio_xfer(sfc, buf, bytes);

	return 0;
}

static int rockchip_sfc_write(struct rockchip_sfc *sfc, u32 offset,
			      void *buf, size_t len)
{
	if (len > SFC_MAX_TRB) {
		printf("out of the max sfc trb");
		return -EINVAL;
	}

	if (len && !(len & (ARCH_DMA_MINALIGN - 1)))
		return rockchip_sfc_dma_xfer(sfc, buf, len);
	else
		return rockchip_sfc_pio_xfer(sfc, buf, len);

	return 0;
}

static int rockchip_sfc_do_xfer(struct rockchip_sfc *sfc, void *buf, size_t len)
{
	if (sfc->rw)
		return rockchip_sfc_write(sfc, sfc->addr, buf, len);
	else
		return rockchip_sfc_read(sfc, sfc->addr, buf, len);
}

static int rockchip_sfc_xfer(struct udevice *dev, unsigned int bitlen,
			     const void *dout, void *din, unsigned long flags)
{
	struct udevice *bus = dev->parent;
	struct rockchip_sfc *sfc = dev_get_priv(bus);
	int len = bitlen >> 3;
	u8 *pcmd = (u8 *)dout;
	void *data_buf;
	int ret = 0;

	if (flags & SPI_XFER_BEGIN) {
		sfc->cmd = pcmd[0];
		switch (len) {
		case 6: /* Nor >16MB 0x6b dummy op */
			sfc->addr_bits = SFC_ADDR_32BITS;
			sfc->dummy_bits = 8;
			sfc->addr = pcmd[4] | (pcmd[3] << 8) | (pcmd[2] << 16) | (pcmd[1] << 24);
			break;
		case 5: /* Nor <=16MB 0x6b dummy op, Nor >16MB no dummy op */
			if (sfc->cmd == 0x6b) {
				sfc->addr_bits = SFC_ADDR_24BITS;
				sfc->dummy_bits = 8;
				sfc->addr = pcmd[3] | (pcmd[2] << 8) | (pcmd[1] << 16);
			} else {
				sfc->addr_bits = SFC_ADDR_32BITS;
				sfc->dummy_bits = 0;
				sfc->addr = pcmd[4] | (pcmd[3] << 8) | (pcmd[2] << 16) | (pcmd[1] << 24);
			}
			break;
		case 4: /* Nand erase and read, Nor <=16MB no dummy op */
			sfc->addr_bits = SFC_ADDR_24BITS;
			sfc->dummy_bits = 0;
			sfc->addr = pcmd[3] | (pcmd[2] << 8) | (pcmd[1] << 16);
			break;
		case 3: /* Nand prog,  */
			sfc->addr_bits = SFC_ADDR_XBITS;
			sfc->dummy_bits = 0;
			sfc->addr = pcmd[2] | pcmd[1] << 8;
			break;
		case 2: /* Nand read/write feature */
			sfc->addr_bits = SFC_ADDR_XBITS;
			sfc->dummy_bits = 0;
			sfc->addr = pcmd[1];
			break;
		default: /* Nand/Nor Read/Write status */
			sfc->addr_bits = SFC_ADDR_0BITS;
			sfc->dummy_bits = 0;
			sfc->addr = 0;
			break;
		}
		SFC_DBG("%s %d %x %d %d %x\n", __func__, len, sfc->cmd, sfc->addr_bits,
			sfc->dummy_bits, sfc->addr);
	}
	if (flags & SPI_XFER_END) {
		if (din) {
			sfc->rw = SFC_RD;
			data_buf = din;
		} else {
			sfc->rw = SFC_WR;
			data_buf = (void *)dout;
		}

		if (flags == (SPI_XFER_BEGIN | SPI_XFER_END)) {
			len = 0;
			data_buf = NULL;
		}

		ret = rockchip_sfc_do_xfer(sfc, data_buf, len);
	}

	return ret;
}

static int rockchip_sfc_set_speed(struct udevice *bus, uint speed)
{
	struct rockchip_sfc *sfc = dev_get_priv(bus);

	if (speed > sfc->max_freq)
		speed = sfc->max_freq;

	sfc->speed_hz = speed;

	return 0;
}

static int rockchip_sfc_set_mode(struct udevice *bus, uint mode)
{
	struct rockchip_sfc *sfc = dev_get_priv(bus);

	sfc->mode = mode;

	return 0;
}

static const struct dm_spi_ops rockchip_sfc_ops = {
	.xfer		= rockchip_sfc_xfer,
	.set_speed	= rockchip_sfc_set_speed,
	.set_mode	= rockchip_sfc_set_mode,
};

static const struct udevice_id rockchip_sfc_ids[] = {
	{ .compatible = "rockchip,sfc" },
	{ }
};

U_BOOT_DRIVER(rockchip_sfc_driver) = {
	.name	= "rockchip_sfc",
	.id	= UCLASS_SPI,
	.of_match = rockchip_sfc_ids,
	.ops	= &rockchip_sfc_ops,
	.ofdata_to_platdata = rockchip_sfc_ofdata_to_platdata,
	.platdata_auto_alloc_size = sizeof(struct rockchip_sfc_platdata),
	.priv_auto_alloc_size = sizeof(struct rockchip_sfc),
	.probe	= rockchip_sfc_probe,
};
