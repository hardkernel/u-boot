/*
 * sfc driver for rockchip
 *
 * (C) Copyright 2008-2016 Rockchip Electronics
 * Yifeng.zhao, Software Engineering, <zhao0116@gmail.com>.
 *
 * SPDX-License-Identifier:	GPL-2.0+
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
#include "rockchip_sfc.h"

DECLARE_GLOBAL_DATA_PTR;

enum rockchip_sfc_if_type {
	IF_TYPE_STD,
	IF_TYPE_DUAL,
	IF_TYPE_QUAD,
};

struct rockchip_sfc_platdata {
	s32 frequency;
	fdt_addr_t base;
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
	const void *blob = gd->fdt_blob;
	int node = dev_of_offset(bus);
	int subnode;
	int ret;

	plat->base = devfdt_get_addr(bus);

	ret = clk_get_by_index(bus, 0, &sfc->clk);
	if (ret < 0) {
		debug("Could not get clock for %s: %d\n", bus->name, ret);
		return ret;
	}

	subnode = fdt_first_subnode(blob, node);
	if (subnode < 0) {
		debug("Error: subnode with SPI flash config missing!\n");
		return -ENODEV;
	}

	plat->frequency = fdtdec_get_int(blob, subnode, "spi-max-frequency",
					 100000000);

	return 0;
}

static int rockchip_sfc_probe(struct udevice *bus)
{
	struct rockchip_sfc_platdata *plat = dev_get_platdata(bus);
	struct rockchip_sfc *sfc = dev_get_priv(bus);
	int ret;

	sfc->regbase = (struct rockchip_sfc_reg *)plat->base;

	sfc->max_freq = plat->frequency;

	ret = clk_set_rate(&sfc->clk, sfc->max_freq);
	if (ret < 0) {
		debug("%s: Failed to set clock: %d\n", __func__, ret);
		return ret;
	}

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
		if ((fsr & SFC_TX_EMPTY) && (fsr & SFC_RX_EMPTY) && !(sr & SFC_BUSY))
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

	if (sfc->addr_bits & SFC_ADDR_XBITS)
		data_width = rockchip_sfc_get_if_type(sfc);

	val |= (data_width << SFC_DATA_WIDTH_SHIFT);

	rockchip_sfc_wait_idle(sfc, 10);

	writel(val, &regs->ctrl);

	val = sfc->cmd;
	val |= trb << SFC_TRB_SHIFT;
	val |= sfc->rw << SFC_RW_SHIFT;
	val |= sfc->addr_bits << SFC_ADDR_BITS_SHIFT;
	val |= sfc->dummy_bits << SFC_DUMMY_BITS_SHIFT;

	writel(val, &regs->cmd);

	if (sfc->addr_bits & SFC_ADDR_XBITS)
		writel(sfc->addr, &regs->addr);
}

static int rockchip_sfc_do_dma_xfer(struct rockchip_sfc *sfc, u32 *buffer, u32 trb)
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

	ret = bounce_buffer_start(&bb, (void *)buffer, trb, bb_flags);
	if (ret)
		return ret;
	rockchip_sfc_setup_xfer(sfc, bb.len_aligned);

	writel(0xFFFFFFFF, &regs->iclr);
	writel((u32)bb.bounce_buffer, &regs->dmaaddr);
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

static int rockchip_sfc_dma_xfer(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	u32 trb;
	int ret = 0;

	while (len) {
		trb = min(len, (u32)SFC_MAX_TRB);
		ret = rockchip_sfc_do_dma_xfer(sfc, buf, trb);
		if (ret < 0)
			break;
		len -= trb;
		sfc->addr += trb;
		buf += (trb >> 2);
	}

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

static int rockchip_sfc_pio_xfer(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	int ret = 0;

	rockchip_sfc_setup_xfer(sfc, len);
	if (len) {
		if (sfc->rw == SFC_WR)
			ret = rockchip_sfc_write_fifo(sfc, buf, len);
		else
			ret = rockchip_sfc_read_fifo(sfc, buf, len);
	}

	return ret;
}

static int rockchip_sfc_do_xfer(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	int ret = 0;
	u32 bytes = len & 0x3;
	u32 dma_trans;

	if (len >= ARCH_DMA_MINALIGN) {
		dma_trans = len - bytes;
	} else {
		dma_trans = 0;
		bytes = len;
	}

	if (dma_trans) {
		ret = rockchip_sfc_dma_xfer(sfc, buf, dma_trans);
		buf += (dma_trans  >> 2);
	}

	/*
	 * transfer the last non 4 bytes anligned byte by pio mode
	 * there are also some commands like WREN(0x06) that execute
	 * whth no data, we also need to handle it here.
	 */
	if (bytes || (!bytes && !dma_trans))
		ret = rockchip_sfc_pio_xfer(sfc, buf, bytes);

	return ret;
}

static int rockchip_sfc_xfer(struct udevice *dev, unsigned int bitlen,
			     const void *dout, void *din, unsigned long flags)
{
	struct udevice *bus = dev->parent;
	struct rockchip_sfc *sfc = dev_get_priv(bus);
	int len = bitlen >> 3;
	u8 *pcmd = (u8 *)dout;
	int ret = 0;

	if (flags & SPI_XFER_BEGIN) {
		sfc->cmd = pcmd[0];
		if (len >= 4) {
			sfc->addr_bits = SFC_ADDR_24BITS;
			sfc->dummy_bits = (len - 4) << 3;
			sfc->addr = pcmd[3] | (pcmd[2] << 8) | (pcmd[1] << 16);
		} else {
			sfc->addr_bits = 0;
			sfc->dummy_bits = 0;
			sfc->addr = 0;
		}
	}

	if (flags == (SPI_XFER_BEGIN | SPI_XFER_END))
		len = 0;

	if (flags & SPI_XFER_END) {

		if (din) {
			sfc->rw = SFC_RD;
			ret = rockchip_sfc_do_xfer(sfc, (u32 *)din, len);
		} else if (dout) {
			sfc->rw = SFC_WR;
			ret = rockchip_sfc_do_xfer(sfc, (u32 *)dout, len);
		}
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
