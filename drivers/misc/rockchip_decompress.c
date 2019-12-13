// SPDX-License-Identifier:     GPL-2.0+
/*
 * Copyright (C) 2019 Rockchip Electronics Co., Ltd
 */
#include <common.h>
#include <asm/io.h>
#include <dm.h>
#include <linux/bitops.h>
#include <misc.h>
#include <irq-generic.h>

DECLARE_GLOBAL_DATA_PTR;

#define DECOM_CTRL		0x0
#define DECOM_ENR		0x4
#define DECOM_RADDR		0x8
#define DECOM_WADDR		0xc
#define DECOM_UDDSL		0x10
#define DECOM_UDDSH		0x14
#define DECOM_TXTHR		0x18
#define DECOM_RXTHR		0x1c
#define DECOM_SLEN		0x20
#define DECOM_STAT		0x24
#define DECOM_ISR		0x28
#define DECOM_IEN		0x2c
#define DECOM_AXI_STAT		0x30
#define DECOM_TSIZEL		0x34
#define DECOM_TSIZEH		0x38
#define DECOM_MGNUM		0x3c
#define DECOM_FRAME		0x40
#define DECOM_DICTID		0x44
#define DECOM_CSL		0x48
#define DECOM_CSH		0x4c

#define LZ4_HEAD_CSUM_CHECK_EN	BIT(1)
#define LZ4_BLOCK_CSUM_CHECK_EN	BIT(2)
#define LZ4_CONT_CSUM_CHECK_EN	BIT(3)

#define DSOLIEN			BIT(19)
#define ZDICTEIEN		BIT(18)
#define GCMEIEN			BIT(17)
#define GIDEIEN			BIT(16)
#define CCCEIEN			BIT(15)
#define BCCEIEN			BIT(14)
#define HCCEIEN			BIT(13)
#define CSEIEN			BIT(12)
#define DICTEIEN		BIT(11)
#define VNEIEN			BIT(10)
#define WNEIEN			BIT(9)
#define RDCEIEN			BIT(8)
#define WRCEIEN			BIT(7)
#define DISEIEN			BIT(6)
#define LENEIEN			BIT(5)
#define LITEIEN			BIT(4)
#define SQMEIEN			BIT(3)
#define SLCIEN			BIT(2)
#define HDEIEN			BIT(1)
#define DSIEN			BIT(0)

#define DECOM_STOP		BIT(0)
#define DECOM_COMPLETE		BIT(0)
#define DECOM_GZIP_MODE		BIT(4)
#define DECOM_ZLIB_MODE		BIT(5)
#define DECOM_DEFLATE_MODE	BIT(0)

#define DECOM_ENABLE		0x1
#define DECOM_DISABLE		0x0

#define DECOM_IRQ		0xffff /* fixme */

#define DECOM_INT_MASK \
	(DSOLIEN | ZDICTEIEN | GCMEIEN | GIDEIEN | \
	CCCEIEN | BCCEIEN | HCCEIEN | CSEIEN | \
	DICTEIEN | VNEIEN | WNEIEN | RDCEIEN | WRCEIEN | \
	DISEIEN | LENEIEN | LITEIEN | SQMEIEN | SLCIEN | \
	HDEIEN | DSIEN)

enum decom_mod {
	LZ4_MOD,
	GZIP_MOD,
	ZLIB_MOD,
};

struct rockchip_decom_param {
	unsigned long addr_src;
	unsigned long addr_dst;
	unsigned long size;
	enum decom_mod mode;
};

struct rockchip_decom_priv {
	void __iomem *base;
	bool done;
};

static int rockchip_decom_start(struct udevice *dev, void *buf)
{
	struct rockchip_decom_priv *priv = dev_get_priv(dev);
	struct rockchip_decom_param *param = (struct rockchip_decom_param *)buf;

	priv->done = false;

	if (param->mode == LZ4_MOD)
		writel(LZ4_CONT_CSUM_CHECK_EN |
		       LZ4_HEAD_CSUM_CHECK_EN |
		       LZ4_BLOCK_CSUM_CHECK_EN |
		       LZ4_MOD, priv->base + DECOM_CTRL);

	if (param->mode == GZIP_MOD)
		writel(DECOM_DEFLATE_MODE | DECOM_GZIP_MODE,
		       priv->base + DECOM_CTRL);

	if (param->mode == ZLIB_MOD)
		writel(DECOM_DEFLATE_MODE | DECOM_ZLIB_MODE,
		       priv->base + DECOM_CTRL);

	writel(param->addr_src, priv->base + DECOM_RADDR);
	writel(param->addr_dst, priv->base + DECOM_WADDR);

	writel(DECOM_INT_MASK, priv->base + DECOM_IEN);
	writel(DECOM_ENABLE, priv->base + DECOM_ENR);

	return 0;
}

static int rockchip_decom_stop(struct udevice *dev)
{
	struct rockchip_decom_priv *priv = dev_get_priv(dev);
	int irq_status;

	irq_status = readl(priv->base + DECOM_ISR);
	/* clear interrupts */
	if (irq_status)
		writel(irq_status, priv->base + DECOM_ISR);

	writel(DECOM_DISABLE, priv->base + DECOM_ENR);

	return 0;
}

/* Caller must call this function to check if decompress done */
static int rockchip_decom_done_poll(struct udevice *dev)
{
	struct rockchip_decom_priv *priv = dev_get_priv(dev);
	int decom_status;

	decom_status = readl(priv->base + DECOM_STAT);
	if (decom_status & DECOM_COMPLETE)
		return 0;

	return -EINVAL;
}

/* Caller must fill in param @buf which represent struct rockchip_decom_param */
static int rockchip_decom_ioctl(struct udevice *dev, unsigned long request,
				void *buf)
{
	int ret = -EINVAL;

	switch (request) {
	case IOCTL_REQ_START:
		ret = rockchip_decom_start(dev, buf);
		break;
	case IOCTL_REQ_POLL:
		ret = rockchip_decom_done_poll(dev);
		break;
	case IOCTL_REQ_STOP:
		ret = rockchip_decom_stop(dev);
		break;
	}

	return ret;
}

static const struct misc_ops rockchip_decom_ops = {
	.ioctl = rockchip_decom_ioctl,
};

static int rockchip_decom_ofdata_to_platdata(struct udevice *dev)
{
	struct rockchip_decom_priv *priv = dev_get_priv(dev);

	priv->base = dev_read_addr_ptr(dev);
	if (!priv->base)
		return -ENOENT;

	return 0;
}

#ifndef CONFIG_SPL_BUILD
static void rockchip_decom_irqhandler(int irq, void *data)
{
	struct udevice *dev = data;
	struct rockchip_decom_priv *priv = dev_get_priv(dev);
	int irq_status;
	int decom_status;

	irq_status = readl(priv->base + DECOM_ISR);
	/* clear interrupts */
	writel(irq_status, priv->base + DECOM_ISR);
	if (irq_status & DECOM_STOP) {
		decom_status = readl(priv->base + DECOM_STAT);
		if (decom_status & DECOM_COMPLETE) {
			priv->done = true;
			/*
			 * TODO:
			 * Inform someone that decompress completed
			 */
			printf("decom completed\n");
		} else {
			printf("decom failed, irq_status = 0x%x, decom_status = 0x%x\n",
			       irq_status, decom_status);
		}
	}
}
#endif

static int rockchip_decom_probe(struct udevice *dev)
{
#ifndef CONFIG_SPL_BUILD
	irq_install_handler(DECOM_IRQ, rockchip_decom_irqhandler, dev);
	irq_handler_enable(DECOM_IRQ);
#endif
	return 0;
}

static const struct udevice_id rockchip_decom_ids[] = {
	{ .compatible = "rockchip,hw-decompress" },
	{}
};

U_BOOT_DRIVER(rockchip_hw_decompress) = {
	.name = "rockchip_hw_decompress",
	.id = UCLASS_MISC,
	.of_match = rockchip_decom_ids,
	.probe = rockchip_decom_probe,
	.ofdata_to_platdata = rockchip_decom_ofdata_to_platdata,
	.priv_auto_alloc_size = sizeof(struct rockchip_decom_priv),
	.ops = &rockchip_decom_ops,
};
