// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020 Rockchip Electronics Co. Ltd.
 *
 * Author: Wyon Bi <bivvy.bi@rock-chips.com>
 */

#include <common.h>
#include <dm.h>
#include <generic-phy.h>
#include <reset.h>
#include <asm/io.h>
#include <linux/iopoll.h>

#define HIWORD_UPDATE(x, h, l)		((((x) << (l)) & GENMASK((h), (l))) | \
					 (GENMASK((h), (l)) << 16))

#define EDP_PHY_GRF_CON0		0x0000
#define EDP_PHY_TX_IDLE(x)		HIWORD_UPDATE(x, 11,  8)
#define EDP_PHY_TX_PD(x)		HIWORD_UPDATE(x,  7,  4)
#define EDP_PHY_IDDQ_EN(x)		HIWORD_UPDATE(x,  1,  1)
#define EDP_PHY_PD_PLL(x)		HIWORD_UPDATE(x,  0,  0)
#define EDP_PHY_GRF_CON1		0x0004
#define EDP_PHY_PLL_DIV(x)		HIWORD_UPDATE(x, 14,  0)
#define EDP_PHY_GRF_CON2		0x0008
#define EDP_PHY_TX_RTERM(x)		HIWORD_UPDATE(x, 10,  8)
#define EDP_PHY_RATE(x)			HIWORD_UPDATE(x,  5,  4)
#define EDP_PHY_REF_DIV(x)		HIWORD_UPDATE(x,  3,  0)
#define EDP_PHY_GRF_CON3		0x000c
#define EDP_PHY_TX_EMP(lane, x)		HIWORD_UPDATE(x, 4 * ((lane) + 1) - 1, \
						      4 * (lane))
#define EDP_PHY_GRF_CON4		0x0010
#define EDP_PHY_TX_AMP(lane, x)		HIWORD_UPDATE(x, 4 * ((lane) + 1) - 2, \
						      4 * (lane))
#define EDP_PHY_GRF_CON5		0x0014
#define EDP_PHY_TX_MODE(x)		HIWORD_UPDATE(x,  9,  8)
#define EDP_PHY_TX_AMP_SCALE(lane, x)	HIWORD_UPDATE(x, 2 * ((lane) + 1) - 1, \
						      2 * (lane))
#define EDP_PHY_GRF_CON6		0x0018
#define EDP_PHY_SSC_DEPTH(x)		HIWORD_UPDATE(x, 15, 12)
#define EDP_PHY_SSC_EN(x)		HIWORD_UPDATE(x, 11, 11)
#define EDP_PHY_SSC_CNT(x)		HIWORD_UPDATE(x,  9,  0)
#define EDP_PHY_GRF_CON7		0x001c
#define EDP_PHY_GRF_CON8		0x0020
#define EDP_PHY_PLL_CTL_H(x)		HIWORD_UPDATE(x, 15,  0)
#define EDP_PHY_GRF_CON9		0x0024
#define EDP_PHY_TX_CTL(x)		HIWORD_UPDATE(x, 15,  0)
#define EDP_PHY_GRF_CON10		0x0028
#define EDP_PHY_AUX_RCV_PD_SEL(x)	HIWORD_UPDATE(x,  5,  5)
#define EDP_PHY_AUX_DRV_PD_SEL(x)	HIWORD_UPDATE(x,  4,  4)
#define EDP_PHY_AUX_IDLE(x)		HIWORD_UPDATE(x,  2,  2)
#define EDP_PHY_AUX_RCV_PD(x)		HIWORD_UPDATE(x,  1,  1)
#define EDP_PHY_AUX_DRV_PD(x)		HIWORD_UPDATE(x,  0,  0)
#define EDP_PHY_GRF_CON11		0x002c
#define EDP_PHY_AUX_RCV_VCM(x)		HIWORD_UPDATE(x, 14, 12)
#define EDP_PHY_AUX_MODE(x)		HIWORD_UPDATE(x, 11, 10)
#define EDP_PHY_AUX_AMP_SCALE(x)	HIWORD_UPDATE(x,  9,  8)
#define EDP_PHY_AUX_AMP(x)		HIWORD_UPDATE(x,  6,  4)
#define EDP_PHY_AUX_RTERM(x)		HIWORD_UPDATE(x,  2,  0)
#define EDP_PHY_GRF_STATUS0		0x0030
#define PLL_RDY				BIT(0)
#define EDP_PHY_GRF_STATUS1		0x0034

struct rockchip_edp_phy {
	void __iomem *regs;
	struct udevice *dev;
	struct reset_ctl apb_reset;
};

static struct {
	int amp;
	int amp_scale;
	int emp;
} vp[4][4] = {
	{ {0x1, 0x1, 0x0}, {0x2, 0x1, 0x4}, {0x3, 0x1, 0x8}, {0x4, 0x1, 0xd} },
	{ {0x3, 0x1, 0x0}, {0x5, 0x1, 0x7}, {0x6, 0x1, 0x6}, { -1,  -1,  -1} },
	{ {0x5, 0x1, 0x0}, {0x7, 0x1, 0x4}, { -1,  -1,  -1}, { -1,  -1,  -1} },
	{ {0x7, 0x1, 0x0}, { -1,  -1,  -1}, { -1,  -1,  -1}, { -1,  -1,  -1} },
};

static int rockchip_edp_phy_set_voltages(struct rockchip_edp_phy *edpphy,
					 struct phy_configure_opts_dp *dp)
{
	u8 lane;
	u32 val;

	for (lane = 0; lane < dp->lanes; lane++) {
		val = vp[dp->voltage[lane]][dp->pre[lane]].amp;
		writel(EDP_PHY_TX_AMP(lane, val),
		       edpphy->regs + EDP_PHY_GRF_CON4);

		val = vp[dp->voltage[lane]][dp->pre[lane]].amp_scale;
		writel(EDP_PHY_TX_AMP_SCALE(lane, val),
		       edpphy->regs + EDP_PHY_GRF_CON5);

		val = vp[dp->voltage[lane]][dp->pre[lane]].emp;
		writel(EDP_PHY_TX_EMP(lane, val),
		       edpphy->regs + EDP_PHY_GRF_CON3);
	}

	return 0;
}

static int rockchip_edp_phy_set_rate(struct rockchip_edp_phy *edpphy,
				     struct phy_configure_opts_dp *dp)
{
	u32 value;
	int ret;

	writel(EDP_PHY_TX_IDLE(0xf) | EDP_PHY_TX_PD(0xf),
	       edpphy->regs + EDP_PHY_GRF_CON0);
	udelay(100);
	writel(EDP_PHY_TX_MODE(0x3), edpphy->regs + EDP_PHY_GRF_CON5);
	writel(EDP_PHY_PD_PLL(0x1), edpphy->regs + EDP_PHY_GRF_CON0);

	switch (dp->link_rate) {
	case 1620:
		writel(EDP_PHY_PLL_DIV(0x4380),
		       edpphy->regs + EDP_PHY_GRF_CON1);
		writel(EDP_PHY_TX_RTERM(0x1) | EDP_PHY_RATE(0x1) |
		       EDP_PHY_REF_DIV(0x0), edpphy->regs + EDP_PHY_GRF_CON2);
		writel(EDP_PHY_PLL_CTL_H(0x0800),
		       edpphy->regs + EDP_PHY_GRF_CON8);
		writel(EDP_PHY_TX_CTL(0x0000), edpphy->regs + EDP_PHY_GRF_CON9);
		break;
	case 2700:
		writel(EDP_PHY_PLL_DIV(0x3840),
		       edpphy->regs + EDP_PHY_GRF_CON1);
		writel(EDP_PHY_TX_RTERM(0x1) | EDP_PHY_RATE(0x0) |
		       EDP_PHY_REF_DIV(0x0), edpphy->regs + EDP_PHY_GRF_CON2);
		writel(EDP_PHY_PLL_CTL_H(0x0800),
		       edpphy->regs + EDP_PHY_GRF_CON8);
		writel(EDP_PHY_TX_CTL(0x0000), edpphy->regs + EDP_PHY_GRF_CON9);
		break;
	}

	if (dp->ssc)
		writel(EDP_PHY_SSC_DEPTH(0x9) | EDP_PHY_SSC_EN(0x1) |
		       EDP_PHY_SSC_CNT(0x17d),
		       edpphy->regs + EDP_PHY_GRF_CON6);
	else
		writel(EDP_PHY_SSC_EN(0x0), edpphy->regs + EDP_PHY_GRF_CON6);

	writel(EDP_PHY_PD_PLL(0x0), edpphy->regs + EDP_PHY_GRF_CON0);
	writel(EDP_PHY_TX_PD(~GENMASK(dp->lanes - 1, 0)),
	       edpphy->regs + EDP_PHY_GRF_CON0);
	ret = readl_poll_timeout(edpphy->regs + EDP_PHY_GRF_STATUS0,
				 value, value & PLL_RDY, 1000);
	if (ret) {
		dev_err(edpphy->dev, "pll is not ready: %d\n", ret);
		return ret;
	}

	writel(EDP_PHY_TX_MODE(0x0), edpphy->regs + EDP_PHY_GRF_CON5);
	writel(EDP_PHY_TX_IDLE(~GENMASK(dp->lanes - 1, 0)),
	       edpphy->regs + EDP_PHY_GRF_CON0);

	return 0;
}

static int rockchip_edp_phy_verify_config(struct rockchip_edp_phy *edpphy,
					  struct phy_configure_opts_dp *dp)
{
	int i;

	/* If changing link rate was required, verify it's supported. */
	if (dp->set_rate) {
		switch (dp->link_rate) {
		case 1620:
		case 2700:
			/* valid bit rate */
			break;
		default:
			return -EINVAL;
		}
	}

	/* Verify lane count. */
	switch (dp->lanes) {
	case 1:
	case 2:
	case 4:
		/* valid lane count. */
		break;
	default:
		return -EINVAL;
	}

	/*
	 * If changing voltages is required, check swing and pre-emphasis
	 * levels, per-lane.
	 */
	if (dp->set_voltages) {
		/* Lane count verified previously. */
		for (i = 0; i < dp->lanes; i++) {
			if (dp->voltage[i] > 3 || dp->pre[i] > 3)
				return -EINVAL;

			/*
			 * Sum of voltage swing and pre-emphasis levels cannot
			 * exceed 3.
			 */
			if (dp->voltage[i] + dp->pre[i] > 3)
				return -EINVAL;
		}
	}

	return 0;
}

static int rockchip_edp_phy_configure(struct phy *phy,
				      union phy_configure_opts *opts)
{
	struct rockchip_edp_phy *edpphy = dev_get_priv(phy->dev);
	int ret;

	ret = rockchip_edp_phy_verify_config(edpphy, &opts->dp);
	if (ret) {
		dev_err(edpphy->dev, "invalid params for phy configure\n");
		return ret;
	}

	if (opts->dp.set_rate) {
		ret = rockchip_edp_phy_set_rate(edpphy, &opts->dp);
		if (ret) {
			dev_err(edpphy->dev,
				"rockchip_edp_phy_set_rate failed\n");
			return ret;
		}
	}

	if (opts->dp.set_voltages) {
		ret = rockchip_edp_phy_set_voltages(edpphy, &opts->dp);
		if (ret) {
			dev_err(edpphy->dev,
				"rockchip_edp_phy_set_voltages failed\n");
			return ret;
		}
	}

	return 0;
}

static int rockchip_edp_phy_power_on(struct phy *phy)
{
	struct rockchip_edp_phy *edpphy = dev_get_priv(phy->dev);

	reset_assert(&edpphy->apb_reset);
	udelay(1);
	reset_deassert(&edpphy->apb_reset);
	udelay(1);

	writel(EDP_PHY_AUX_RCV_PD(0x1) | EDP_PHY_AUX_DRV_PD(0x1) |
	       EDP_PHY_AUX_IDLE(0x1), edpphy->regs + EDP_PHY_GRF_CON10);
	writel(EDP_PHY_TX_IDLE(0xf) | EDP_PHY_TX_PD(0xf) | EDP_PHY_PD_PLL(0x1),
	       edpphy->regs + EDP_PHY_GRF_CON0);
	udelay(100);

	writel(EDP_PHY_AUX_RCV_VCM(0x4) | EDP_PHY_AUX_MODE(0x1) |
	       EDP_PHY_AUX_AMP_SCALE(0x1) | EDP_PHY_AUX_AMP(0x3) |
	       EDP_PHY_AUX_RTERM(0x1), edpphy->regs + EDP_PHY_GRF_CON11);

	writel(EDP_PHY_AUX_RCV_PD(0x0) | EDP_PHY_AUX_DRV_PD(0x0),
	       edpphy->regs + EDP_PHY_GRF_CON10);
	udelay(100);

	writel(EDP_PHY_AUX_IDLE(0x0), edpphy->regs + EDP_PHY_GRF_CON10);
	mdelay(20);

	return 0;
}

static int rockchip_edp_phy_power_off(struct phy *phy)
{
	struct rockchip_edp_phy *edpphy = dev_get_priv(phy->dev);

	writel(EDP_PHY_TX_IDLE(0xf) | EDP_PHY_TX_PD(0xf),
	       edpphy->regs + EDP_PHY_GRF_CON0);
	udelay(100);
	writel(EDP_PHY_TX_MODE(0x3), edpphy->regs + EDP_PHY_GRF_CON5);
	writel(EDP_PHY_PD_PLL(0x1), edpphy->regs + EDP_PHY_GRF_CON0);
	writel(EDP_PHY_AUX_RCV_PD(0x1) | EDP_PHY_AUX_DRV_PD(0x1) |
	       EDP_PHY_AUX_IDLE(0x1), edpphy->regs + EDP_PHY_GRF_CON10);

	return 0;
}

static struct phy_ops rockchip_edp_phy_ops = {
	.power_on = rockchip_edp_phy_power_on,
	.power_off = rockchip_edp_phy_power_off,
	.configure = rockchip_edp_phy_configure,
};

static int rockchip_edp_phy_probe(struct udevice *dev)
{
	struct rockchip_edp_phy *edpphy = dev_get_priv(dev);
	int ret;

	edpphy->regs = dev_read_addr_ptr(dev);
	if (!edpphy->regs)
		return -ENOENT;

	edpphy->dev = dev;

	ret = reset_get_by_name(dev, "apb", &edpphy->apb_reset);
	if (ret < 0) {
		dev_err(dev, "failed to get apb reset: %d\n", ret);
		return ret;
	}

	return 0;
}

static const struct udevice_id rockchip_edp_phy_ids[] = {
	{ .compatible = "rockchip,rk3568-edp-phy", },
	{}
};

U_BOOT_DRIVER(rockchip_edp_phy) = {
	.name		= "rockchip_edp_phy",
	.id		= UCLASS_PHY,
	.ops		= &rockchip_edp_phy_ops,
	.of_match	= rockchip_edp_phy_ids,
	.probe		= rockchip_edp_phy_probe,
	.priv_auto_alloc_size = sizeof(struct rockchip_edp_phy),
};
