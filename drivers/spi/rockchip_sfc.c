/*
 * sfc driver for rockchip
 *
 * (C) Copyright 2008-2016 Rockchip Electronics
 * Yifeng.zhao, Software Engineering, <zhao0116@gmail.com>.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
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

static u8 rockchip_sfc_get_if_type(struct rockchip_sfc *sfc)
{
	int type = IF_TYPE_STD;

	if (sfc->cmd & SFC_WR) {
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

static void rockchip_sfc_setup_xfer(struct rockchip_sfc *sfc)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	u32 val = 0x02;
	u32 fsr = readl(&regs->fsr);
	u32 sr = readl(&regs->sr);
	u8 data_width = IF_TYPE_STD;

	if (!(fsr & SFC_TX_EMPTY) || !(fsr & SFC_RX_EMPTY) || (sr & SFC_BUSY))
		rockchip_sfc_reset(sfc);

	if (sfc->cmd & SFC_ADDR_XBITS)
		data_width = rockchip_sfc_get_if_type(sfc);

	val |= (data_width << SFC_DATA_WIDTH_SHIFT);

	writel(val, &regs->ctrl);
	writel(sfc->cmd, &regs->cmd);
	if (sfc->cmd & SFC_ADDR_XBITS)
		writel(sfc->addr, &regs->addr);
}

static int rockchip_sfc_do_dma_xfer(struct rockchip_sfc *sfc, u32 *buffer)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	int timeout = 1000;
	int ret = 0;
	int risr;
	unsigned long tbase;

	rockchip_sfc_setup_xfer(sfc);

	writel(0xFFFFFFFF, &regs->iclr);
	writel((u32)buffer, &regs->dmaaddr);
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

	return ret;
}

static int rockchip_sfc_dma_xfer(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	u32 trb;
	u32 *p32_data = buf;
	int ret = 0;

	while (len) {
		trb = min(len, (u32)SFC_MAX_TRB);
		sfc->cmd |= (trb << SFC_TRB_SHIFT);
		ret = rockchip_sfc_do_dma_xfer(sfc, p32_data);
		if (ret < 0)
			break;
		len -= trb;
		sfc->addr += trb;
		p32_data += (trb >> 2);
	}

	return ret;
}

static int rockchip_sfc_wait_fifo_ready(struct rockchip_sfc *sfc, int wr,
					u32 timeout)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	unsigned long tbase = get_timer(0);
	u8 level;
	u32 fsr;

	do {
		fsr = readl(&regs->fsr);
		if (wr)
			level = (fsr & SFC_TXLV_MASK) >> SFC_TXLV_SHIFT;
		else
			level = (fsr & SFC_RXLV_MASK) >> SFC_RXLV_SHIFT;
		if (get_timer(tbase) > timeout)
			return -ETIMEDOUT;
		udelay(1);
	} while (!level);

	return level;
}

static int rockchip_sfc_write(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	u32 bytes = len & 0x3;
	u32 words = len >> 2;
	u32 tx_level = 0;
	u32 val = 0;
	u8 count;

	while (words) {
		tx_level = rockchip_sfc_wait_fifo_ready(sfc, 1, 1000);
		if (tx_level <= 0)
			return tx_level;
		count = min(words, tx_level);
		writesl(&regs->data, buf, count);
		buf += count;
		words -= count;
	}

	/* handle the last none word aligned bytes */
	if (bytes) {
		tx_level = rockchip_sfc_wait_fifo_ready(sfc, 1, 1000);
		if (tx_level <= 0)
			return tx_level;
		memcpy(&val, buf, bytes);
		writel(val, &regs->data);
	}

	return 0;
}

static int rockchip_sfc_read(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	struct rockchip_sfc_reg *regs = sfc->regbase;
	u32 bytes = len & 0x3;
	u32 words = len >> 2;
	u32 rx_level = 0;
	u32 count;
	u32 val;

	while (words) {
		rx_level = rockchip_sfc_wait_fifo_ready(sfc, 0, 1000);
		if (rx_level <= 0)
			return rx_level;
		count = min(words, rx_level);
		readsl(&regs->data, buf, count);
		buf += count;
		words -= count;
	}

	/* handle the last none word aligned bytes */
	if (bytes) {
		rx_level = rockchip_sfc_wait_fifo_ready(sfc, 0, 1000);
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
	int rw = sfc->cmd & SFC_WR;

	sfc->cmd |= (len << SFC_TRB_SHIFT);
	rockchip_sfc_setup_xfer(sfc);

	if (len) {
		if (rw)
			ret = rockchip_sfc_write(sfc, buf, len);
		else
			ret = rockchip_sfc_read(sfc, buf, len);
	}

	return ret;
}

static int rockchip_sfc_do_xfer(struct rockchip_sfc *sfc, u32 *buf, u32 len)
{
	int ret = 0;

	if (!(len & 0x03) && (len >= 4))
		ret = rockchip_sfc_dma_xfer(sfc, buf, len);
	else
		ret = rockchip_sfc_pio_xfer(sfc, buf, len);

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
			sfc->cmd |= SFC_ADDR_24BITS | (((len - 4) * 8) << 8);
			sfc->addr = pcmd[3] | (pcmd[2] << 8) | (pcmd[1] << 16);
		}
	}

	if (flags == (SPI_XFER_BEGIN | SPI_XFER_END))
		len = 0;

	if (flags & SPI_XFER_END) {
		if (dout && len)
			sfc->cmd |= SFC_WR;

		if (din)
			ret = rockchip_sfc_do_xfer(sfc, (u32 *)din, len);
		else if (dout)
			ret = rockchip_sfc_do_xfer(sfc, (u32 *)dout, len);
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
