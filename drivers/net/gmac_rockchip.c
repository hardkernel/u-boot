/*
 * (C) Copyright 2015 Sjoerd Simons <sjoerd.simons@collabora.co.uk>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 *
 * Rockchip GMAC ethernet IP driver for U-Boot
 */

#include <common.h>
#include <dm.h>
#include <clk.h>
#include <phy.h>
#include <syscon.h>
#include <asm/io.h>
#include <asm/arch/periph.h>
#include <asm/arch/clock.h>
#include <asm/arch/hardware.h>
#ifdef CONFIG_DWC_ETH_QOS
#include <asm/arch/grf_rv1126.h>
#include "dwc_eth_qos.h"
#else
#include <asm/arch/grf_px30.h>
#include <asm/arch/grf_rk1808.h>
#include <asm/arch/grf_rk322x.h>
#include <asm/arch/grf_rk3288.h>
#include <asm/arch/grf_rk3308.h>
#include <asm/arch/grf_rk3328.h>
#include <asm/arch/grf_rk3368.h>
#include <asm/arch/grf_rk3399.h>
#include <asm/arch/grf_rv1108.h>
#include "designware.h"
#include <dt-bindings/clock/rk3288-cru.h>
#endif
#include <dm/pinctrl.h>

DECLARE_GLOBAL_DATA_PTR;

struct rockchip_eth_dev {
#ifdef CONFIG_DWC_ETH_QOS
	struct eqos_priv eqos;
#else
	struct dw_eth_dev dw;
#endif
};

/*
 * Platform data for the gmac
 *
 * dw_eth_pdata: Required platform data for designware driver (must be first)
 */
struct gmac_rockchip_platdata {
#ifndef CONFIG_DWC_ETH_QOS
	struct dw_eth_pdata dw_eth_pdata;
#else
	struct eth_pdata eth_pdata;
#endif
	bool clock_input;
	int tx_delay;
	int rx_delay;
};

struct rk_gmac_ops {
#ifdef CONFIG_DWC_ETH_QOS
	const struct eqos_config config;
#endif
	int (*fix_mac_speed)(struct rockchip_eth_dev *dev);
	void (*set_to_rmii)(struct gmac_rockchip_platdata *pdata);
	void (*set_to_rgmii)(struct gmac_rockchip_platdata *pdata);
};

void gmac_set_rgmii(struct udevice *dev, u32 tx_delay, u32 rx_delay)
{
	struct gmac_rockchip_platdata *pdata = dev_get_platdata(dev);
	struct rk_gmac_ops *ops =
		(struct rk_gmac_ops *)dev_get_driver_data(dev);

	pdata->tx_delay = tx_delay;
	pdata->rx_delay = rx_delay;

	ops->set_to_rgmii(pdata);
}

static int gmac_rockchip_ofdata_to_platdata(struct udevice *dev)
{
	struct gmac_rockchip_platdata *pdata = dev_get_platdata(dev);
	const char *string;

	string = dev_read_string(dev, "clock_in_out");
	if (!strcmp(string, "input"))
		pdata->clock_input = true;
	else
		pdata->clock_input = false;

	/* Check the new naming-style first... */
	pdata->tx_delay = dev_read_u32_default(dev, "tx_delay", -ENOENT);
	pdata->rx_delay = dev_read_u32_default(dev, "rx_delay", -ENOENT);

	/* ... and fall back to the old naming style or default, if necessary */
	if (pdata->tx_delay == -ENOENT)
		pdata->tx_delay = dev_read_u32_default(dev, "tx-delay", 0x30);
	if (pdata->rx_delay == -ENOENT)
		pdata->rx_delay = dev_read_u32_default(dev, "rx-delay", 0x10);

#ifdef CONFIG_DWC_ETH_QOS
	return 0;
#else
	return designware_eth_ofdata_to_platdata(dev);
#endif
}

#ifndef CONFIG_DWC_ETH_QOS
static int px30_gmac_fix_mac_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct px30_grf *grf;
	struct clk clk_speed;
	int speed, ret;
	enum {
		PX30_GMAC_SPEED_SHIFT = 0x2,
		PX30_GMAC_SPEED_MASK  = BIT(2),
		PX30_GMAC_SPEED_10M   = 0,
		PX30_GMAC_SPEED_100M  = BIT(2),
	};

	ret = clk_get_by_name(priv->phydev->dev, "clk_mac_speed",
			      &clk_speed);
	if (ret)
		return ret;

	switch (priv->phydev->speed) {
	case 10:
		speed = PX30_GMAC_SPEED_10M;
		ret = clk_set_rate(&clk_speed, 2500000);
		if (ret)
			return ret;
		break;
	case 100:
		speed = PX30_GMAC_SPEED_100M;
		ret = clk_set_rate(&clk_speed, 25000000);
		if (ret)
			return ret;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->mac_con1, PX30_GMAC_SPEED_MASK, speed);

	return 0;
}

static int rk1808_gmac_fix_mac_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct clk clk_speed;
	int ret;

	ret = clk_get_by_name(priv->phydev->dev, "clk_mac_speed",
			      &clk_speed);
	if (ret)
		return ret;

	switch (priv->phydev->speed) {
	case 10:
		ret = clk_set_rate(&clk_speed, 2500000);
		if (ret)
			return ret;
		break;
	case 100:
		ret = clk_set_rate(&clk_speed, 25000000);
		if (ret)
			return ret;
		break;
	case 1000:
		ret = clk_set_rate(&clk_speed, 125000000);
		if (ret)
			return ret;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	return 0;
}

static int rk3228_gmac_fix_mac_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct rk322x_grf *grf;
	int clk;
	enum {
		RK3228_GMAC_CLK_SEL_SHIFT = 8,
		RK3228_GMAC_CLK_SEL_MASK  = GENMASK(9, 8),
		RK3228_GMAC_CLK_SEL_125M  = 0 << 8,
		RK3228_GMAC_CLK_SEL_25M   = 3 << 8,
		RK3228_GMAC_CLK_SEL_2_5M  = 2 << 8,
	};

	switch (priv->phydev->speed) {
	case 10:
		clk = RK3228_GMAC_CLK_SEL_2_5M;
		break;
	case 100:
		clk = RK3228_GMAC_CLK_SEL_25M;
		break;
	case 1000:
		clk = RK3228_GMAC_CLK_SEL_125M;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->mac_con[1], RK3228_GMAC_CLK_SEL_MASK, clk);

	return 0;
}

static int rk3288_gmac_fix_mac_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct rk3288_grf *grf;
	int clk;

	switch (priv->phydev->speed) {
	case 10:
		clk = RK3288_GMAC_CLK_SEL_2_5M;
		break;
	case 100:
		clk = RK3288_GMAC_CLK_SEL_25M;
		break;
	case 1000:
		clk = RK3288_GMAC_CLK_SEL_125M;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->soc_con1, RK3288_GMAC_CLK_SEL_MASK, clk);

	return 0;
}

static int rk3308_gmac_fix_mac_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct rk3308_grf *grf;
	struct clk clk_speed;
	int speed, ret;
	enum {
		RK3308_GMAC_SPEED_SHIFT = 0x0,
		RK3308_GMAC_SPEED_MASK  = BIT(0),
		RK3308_GMAC_SPEED_10M   = 0,
		RK3308_GMAC_SPEED_100M  = BIT(0),
	};

	ret = clk_get_by_name(priv->phydev->dev, "clk_mac_speed",
			      &clk_speed);
	if (ret)
		return ret;

	switch (priv->phydev->speed) {
	case 10:
		speed = RK3308_GMAC_SPEED_10M;
		ret = clk_set_rate(&clk_speed, 2500000);
		if (ret)
			return ret;
		break;
	case 100:
		speed = RK3308_GMAC_SPEED_100M;
		ret = clk_set_rate(&clk_speed, 25000000);
		if (ret)
			return ret;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->mac_con0, RK3308_GMAC_SPEED_MASK, speed);

	return 0;
}

static int rk3328_gmac_fix_mac_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct rk3328_grf_regs *grf;
	int clk;
	enum {
		RK3328_GMAC_CLK_SEL_SHIFT = 11,
		RK3328_GMAC_CLK_SEL_MASK  = GENMASK(12, 11),
		RK3328_GMAC_CLK_SEL_125M  = 0 << 11,
		RK3328_GMAC_CLK_SEL_25M   = 3 << 11,
		RK3328_GMAC_CLK_SEL_2_5M  = 2 << 11,
	};

	switch (priv->phydev->speed) {
	case 10:
		clk = RK3328_GMAC_CLK_SEL_2_5M;
		break;
	case 100:
		clk = RK3328_GMAC_CLK_SEL_25M;
		break;
	case 1000:
		clk = RK3328_GMAC_CLK_SEL_125M;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->mac_con[1], RK3328_GMAC_CLK_SEL_MASK, clk);

	return 0;
}

static int rk3368_gmac_fix_mac_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct rk3368_grf *grf;
	int clk;
	enum {
		RK3368_GMAC_CLK_SEL_2_5M = 2 << 4,
		RK3368_GMAC_CLK_SEL_25M = 3 << 4,
		RK3368_GMAC_CLK_SEL_125M = 0 << 4,
		RK3368_GMAC_CLK_SEL_MASK = GENMASK(5, 4),
	};

	switch (priv->phydev->speed) {
	case 10:
		clk = RK3368_GMAC_CLK_SEL_2_5M;
		break;
	case 100:
		clk = RK3368_GMAC_CLK_SEL_25M;
		break;
	case 1000:
		clk = RK3368_GMAC_CLK_SEL_125M;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->soc_con15, RK3368_GMAC_CLK_SEL_MASK, clk);

	return 0;
}

static int rk3399_gmac_fix_mac_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct rk3399_grf_regs *grf;
	int clk;

	switch (priv->phydev->speed) {
	case 10:
		clk = RK3399_GMAC_CLK_SEL_2_5M;
		break;
	case 100:
		clk = RK3399_GMAC_CLK_SEL_25M;
		break;
	case 1000:
		clk = RK3399_GMAC_CLK_SEL_125M;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->soc_con5, RK3399_GMAC_CLK_SEL_MASK, clk);

	return 0;
}

static int rv1108_set_rmii_speed(struct rockchip_eth_dev *dev)
{
	struct dw_eth_dev *priv = &dev->dw;
	struct rv1108_grf *grf;
	int clk, speed;
	enum {
		RV1108_GMAC_SPEED_MASK		= BIT(2),
		RV1108_GMAC_SPEED_10M		= 0 << 2,
		RV1108_GMAC_SPEED_100M		= 1 << 2,
		RV1108_GMAC_CLK_SEL_MASK	= BIT(7),
		RV1108_GMAC_CLK_SEL_2_5M	= 0 << 7,
		RV1108_GMAC_CLK_SEL_25M		= 1 << 7,
	};

	switch (priv->phydev->speed) {
	case 10:
		clk = RV1108_GMAC_CLK_SEL_2_5M;
		speed = RV1108_GMAC_SPEED_10M;
		break;
	case 100:
		clk = RV1108_GMAC_CLK_SEL_25M;
		speed = RV1108_GMAC_SPEED_100M;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phydev->speed);
		return -EINVAL;
	}

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->gmac_con0,
		     RV1108_GMAC_CLK_SEL_MASK | RV1108_GMAC_SPEED_MASK,
		     clk | speed);

	return 0;
}
#else
static int rv1126_set_rgmii_speed(struct rockchip_eth_dev *dev)
{
	struct eqos_priv *priv = &dev->eqos;
	struct clk clk_speed;
	int ret;

	ret = clk_get_by_name(priv->phy->dev, "clk_mac_speed",
			      &clk_speed);
	if (ret) {
			printf("%s~(ret=%d):\n", __func__, ret);
		return ret;
	}

	switch ( priv->phy->speed) {
	case 10:
		ret = clk_set_rate(&clk_speed, 2500000);
		if (ret)
			return ret;
		break;
	case 100:
		ret = clk_set_rate(&clk_speed, 25000000);
		if (ret)
			return ret;
		break;
	case 1000:
		ret = clk_set_rate(&clk_speed, 125000000);
		if (ret)
			return ret;
		break;
	default:
		debug("Unknown phy speed: %d\n", priv->phy->speed);
		return -EINVAL;
	}

	return 0;
}
#endif

#ifndef CONFIG_DWC_ETH_QOS
static void px30_gmac_set_to_rmii(struct gmac_rockchip_platdata *pdata)
{
	struct px30_grf *grf;
	enum {
		px30_GMAC_PHY_INTF_SEL_SHIFT = 4,
		px30_GMAC_PHY_INTF_SEL_MASK  = GENMASK(4, 6),
		px30_GMAC_PHY_INTF_SEL_RMII  = BIT(6),
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);

	rk_clrsetreg(&grf->mac_con1,
		     px30_GMAC_PHY_INTF_SEL_MASK,
		     px30_GMAC_PHY_INTF_SEL_RMII);
}

static void rk1808_gmac_set_to_rgmii(struct gmac_rockchip_platdata *pdata)
{
	struct rk1808_grf *grf;
	enum {
		RK1808_GMAC_PHY_INTF_SEL_SHIFT = 4,
		RK1808_GMAC_PHY_INTF_SEL_MASK  = GENMASK(6, 4),
		RK1808_GMAC_PHY_INTF_SEL_RGMII = BIT(4),

		RK1808_RXCLK_DLY_ENA_GMAC_MASK = BIT(1),
		RK1808_RXCLK_DLY_ENA_GMAC_DISABLE = 0,
		RK1808_RXCLK_DLY_ENA_GMAC_ENABLE = BIT(1),

		RK1808_TXCLK_DLY_ENA_GMAC_MASK = BIT(0),
		RK1808_TXCLK_DLY_ENA_GMAC_DISABLE = 0,
		RK1808_TXCLK_DLY_ENA_GMAC_ENABLE = BIT(0),
	};
	enum {
		RK1808_CLK_RX_DL_CFG_GMAC_SHIFT = 0x8,
		RK1808_CLK_RX_DL_CFG_GMAC_MASK = GENMASK(15, 7),

		RK1808_CLK_TX_DL_CFG_GMAC_SHIFT = 0x0,
		RK1808_CLK_TX_DL_CFG_GMAC_MASK = GENMASK(7, 0),
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->mac_con1,
		     RK1808_GMAC_PHY_INTF_SEL_MASK |
		     RK1808_RXCLK_DLY_ENA_GMAC_MASK |
		     RK1808_TXCLK_DLY_ENA_GMAC_MASK,
		     RK1808_GMAC_PHY_INTF_SEL_RGMII |
		     RK1808_RXCLK_DLY_ENA_GMAC_ENABLE |
		     RK1808_TXCLK_DLY_ENA_GMAC_ENABLE);

	rk_clrsetreg(&grf->mac_con0,
		     RK1808_CLK_RX_DL_CFG_GMAC_MASK |
		     RK1808_CLK_TX_DL_CFG_GMAC_MASK,
		     pdata->rx_delay << RK1808_CLK_RX_DL_CFG_GMAC_SHIFT |
		     pdata->tx_delay << RK1808_CLK_TX_DL_CFG_GMAC_SHIFT);
}

static void rk3228_gmac_set_to_rgmii(struct gmac_rockchip_platdata *pdata)
{
	struct rk322x_grf *grf;
	enum {
		RK3228_RMII_MODE_SHIFT = 10,
		RK3228_RMII_MODE_MASK  = BIT(10),

		RK3228_GMAC_PHY_INTF_SEL_SHIFT = 4,
		RK3228_GMAC_PHY_INTF_SEL_MASK  = GENMASK(6, 4),
		RK3228_GMAC_PHY_INTF_SEL_RGMII = BIT(4),

		RK3228_RXCLK_DLY_ENA_GMAC_MASK = BIT(1),
		RK3228_RXCLK_DLY_ENA_GMAC_DISABLE = 0,
		RK3228_RXCLK_DLY_ENA_GMAC_ENABLE = BIT(1),

		RK3228_TXCLK_DLY_ENA_GMAC_MASK = BIT(0),
		RK3228_TXCLK_DLY_ENA_GMAC_DISABLE = 0,
		RK3228_TXCLK_DLY_ENA_GMAC_ENABLE = BIT(0),
	};
	enum {
		RK3228_CLK_RX_DL_CFG_GMAC_SHIFT = 0x7,
		RK3228_CLK_RX_DL_CFG_GMAC_MASK = GENMASK(13, 7),

		RK3228_CLK_TX_DL_CFG_GMAC_SHIFT = 0x0,
		RK3228_CLK_TX_DL_CFG_GMAC_MASK = GENMASK(6, 0),
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->mac_con[1],
		     RK3228_RMII_MODE_MASK |
		     RK3228_GMAC_PHY_INTF_SEL_MASK |
		     RK3228_RXCLK_DLY_ENA_GMAC_MASK |
		     RK3228_TXCLK_DLY_ENA_GMAC_MASK,
		     RK3228_GMAC_PHY_INTF_SEL_RGMII |
		     RK3228_RXCLK_DLY_ENA_GMAC_ENABLE |
		     RK3228_TXCLK_DLY_ENA_GMAC_ENABLE);

	rk_clrsetreg(&grf->mac_con[0],
		     RK3228_CLK_RX_DL_CFG_GMAC_MASK |
		     RK3228_CLK_TX_DL_CFG_GMAC_MASK,
		     pdata->rx_delay << RK3228_CLK_RX_DL_CFG_GMAC_SHIFT |
		     pdata->tx_delay << RK3228_CLK_TX_DL_CFG_GMAC_SHIFT);
}

static void rk3288_gmac_set_to_rgmii(struct gmac_rockchip_platdata *pdata)
{
	struct rk3288_grf *grf;

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->soc_con1,
		     RK3288_RMII_MODE_MASK | RK3288_GMAC_PHY_INTF_SEL_MASK,
		     RK3288_GMAC_PHY_INTF_SEL_RGMII);

	rk_clrsetreg(&grf->soc_con3,
		     RK3288_RXCLK_DLY_ENA_GMAC_MASK |
		     RK3288_TXCLK_DLY_ENA_GMAC_MASK |
		     RK3288_CLK_RX_DL_CFG_GMAC_MASK |
		     RK3288_CLK_TX_DL_CFG_GMAC_MASK,
		     RK3288_RXCLK_DLY_ENA_GMAC_ENABLE |
		     RK3288_TXCLK_DLY_ENA_GMAC_ENABLE |
		     pdata->rx_delay << RK3288_CLK_RX_DL_CFG_GMAC_SHIFT |
		     pdata->tx_delay << RK3288_CLK_TX_DL_CFG_GMAC_SHIFT);
}

static void rk3308_gmac_set_to_rmii(struct gmac_rockchip_platdata *pdata)
{
	struct rk3308_grf *grf;
	enum {
		RK3308_GMAC_PHY_INTF_SEL_SHIFT = 2,
		RK3308_GMAC_PHY_INTF_SEL_MASK  = GENMASK(4, 2),
		RK3308_GMAC_PHY_INTF_SEL_RMII  = BIT(4),
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);

	rk_clrsetreg(&grf->mac_con0,
		     RK3308_GMAC_PHY_INTF_SEL_MASK,
		     RK3308_GMAC_PHY_INTF_SEL_RMII);
}

static void rk3328_gmac_set_to_rgmii(struct gmac_rockchip_platdata *pdata)
{
	struct rk3328_grf_regs *grf;
	enum {
		RK3328_RMII_MODE_SHIFT = 9,
		RK3328_RMII_MODE_MASK  = BIT(9),

		RK3328_GMAC_PHY_INTF_SEL_SHIFT = 4,
		RK3328_GMAC_PHY_INTF_SEL_MASK  = GENMASK(6, 4),
		RK3328_GMAC_PHY_INTF_SEL_RGMII = BIT(4),

		RK3328_RXCLK_DLY_ENA_GMAC_MASK = BIT(1),
		RK3328_RXCLK_DLY_ENA_GMAC_DISABLE = 0,
		RK3328_RXCLK_DLY_ENA_GMAC_ENABLE = BIT(1),

		RK3328_TXCLK_DLY_ENA_GMAC_MASK = BIT(0),
		RK3328_TXCLK_DLY_ENA_GMAC_DISABLE = 0,
		RK3328_TXCLK_DLY_ENA_GMAC_ENABLE = BIT(0),
	};
	enum {
		RK3328_CLK_RX_DL_CFG_GMAC_SHIFT = 0x7,
		RK3328_CLK_RX_DL_CFG_GMAC_MASK = GENMASK(13, 7),

		RK3328_CLK_TX_DL_CFG_GMAC_SHIFT = 0x0,
		RK3328_CLK_TX_DL_CFG_GMAC_MASK = GENMASK(6, 0),
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->mac_con[1],
		     RK3328_RMII_MODE_MASK |
		     RK3328_GMAC_PHY_INTF_SEL_MASK |
		     RK3328_RXCLK_DLY_ENA_GMAC_MASK |
		     RK3328_TXCLK_DLY_ENA_GMAC_MASK,
		     RK3328_GMAC_PHY_INTF_SEL_RGMII |
		     RK3328_RXCLK_DLY_ENA_GMAC_MASK |
		     RK3328_TXCLK_DLY_ENA_GMAC_ENABLE);

	rk_clrsetreg(&grf->mac_con[0],
		     RK3328_CLK_RX_DL_CFG_GMAC_MASK |
		     RK3328_CLK_TX_DL_CFG_GMAC_MASK,
		     pdata->rx_delay << RK3328_CLK_RX_DL_CFG_GMAC_SHIFT |
		     pdata->tx_delay << RK3328_CLK_TX_DL_CFG_GMAC_SHIFT);
}

static void rk3368_gmac_set_to_rgmii(struct gmac_rockchip_platdata *pdata)
{
	struct rk3368_grf *grf;
	enum {
		RK3368_GMAC_PHY_INTF_SEL_RGMII = 1 << 9,
		RK3368_GMAC_PHY_INTF_SEL_MASK = GENMASK(11, 9),
		RK3368_RMII_MODE_MASK  = BIT(6),
		RK3368_RMII_MODE       = BIT(6),
	};
	enum {
		RK3368_RXCLK_DLY_ENA_GMAC_MASK = BIT(15),
		RK3368_RXCLK_DLY_ENA_GMAC_DISABLE = 0,
		RK3368_RXCLK_DLY_ENA_GMAC_ENABLE = BIT(15),
		RK3368_TXCLK_DLY_ENA_GMAC_MASK = BIT(7),
		RK3368_TXCLK_DLY_ENA_GMAC_DISABLE = 0,
		RK3368_TXCLK_DLY_ENA_GMAC_ENABLE = BIT(7),
		RK3368_CLK_RX_DL_CFG_GMAC_SHIFT = 8,
		RK3368_CLK_RX_DL_CFG_GMAC_MASK = GENMASK(14, 8),
		RK3368_CLK_TX_DL_CFG_GMAC_SHIFT = 0,
		RK3368_CLK_TX_DL_CFG_GMAC_MASK = GENMASK(6, 0),
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->soc_con15,
		     RK3368_RMII_MODE_MASK | RK3368_GMAC_PHY_INTF_SEL_MASK,
		     RK3368_GMAC_PHY_INTF_SEL_RGMII);

	rk_clrsetreg(&grf->soc_con16,
		     RK3368_RXCLK_DLY_ENA_GMAC_MASK |
		     RK3368_TXCLK_DLY_ENA_GMAC_MASK |
		     RK3368_CLK_RX_DL_CFG_GMAC_MASK |
		     RK3368_CLK_TX_DL_CFG_GMAC_MASK,
		     RK3368_RXCLK_DLY_ENA_GMAC_ENABLE |
		     RK3368_TXCLK_DLY_ENA_GMAC_ENABLE |
		     pdata->rx_delay << RK3368_CLK_RX_DL_CFG_GMAC_SHIFT |
		     pdata->tx_delay << RK3368_CLK_TX_DL_CFG_GMAC_SHIFT);
}

static void rk3399_gmac_set_to_rgmii(struct gmac_rockchip_platdata *pdata)
{
	struct rk3399_grf_regs *grf;

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);

	rk_clrsetreg(&grf->soc_con5,
		     RK3399_GMAC_PHY_INTF_SEL_MASK,
		     RK3399_GMAC_PHY_INTF_SEL_RGMII);

	rk_clrsetreg(&grf->soc_con6,
		     RK3399_RXCLK_DLY_ENA_GMAC_MASK |
		     RK3399_TXCLK_DLY_ENA_GMAC_MASK |
		     RK3399_CLK_RX_DL_CFG_GMAC_MASK |
		     RK3399_CLK_TX_DL_CFG_GMAC_MASK,
		     RK3399_RXCLK_DLY_ENA_GMAC_ENABLE |
		     RK3399_TXCLK_DLY_ENA_GMAC_ENABLE |
		     pdata->rx_delay << RK3399_CLK_RX_DL_CFG_GMAC_SHIFT |
		     pdata->tx_delay << RK3399_CLK_TX_DL_CFG_GMAC_SHIFT);
}

static void rv1108_gmac_set_to_rmii(struct gmac_rockchip_platdata *pdata)
{
	struct rv1108_grf *grf;

	enum {
		RV1108_GMAC_PHY_INTF_SEL_MASK  = GENMASK(6, 4),
		RV1108_GMAC_PHY_INTF_SEL_RMII  = 4 << 4,
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);
	rk_clrsetreg(&grf->gmac_con0,
		     RV1108_GMAC_PHY_INTF_SEL_MASK,
		     RV1108_GMAC_PHY_INTF_SEL_RMII);
}
#else
static void rv1126_set_to_rmii(struct gmac_rockchip_platdata *pdata)
{
	struct rv1126_grf *grf;

	enum {
		RV1126_GMAC_PHY_INTF_SEL_SHIFT = 4,
		RV1126_GMAC_PHY_INTF_SEL_MASK  = GENMASK(6, 4),
		RV1126_GMAC_PHY_INTF_SEL_RMII = BIT(6),
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);

	rk_clrsetreg(&grf->mac_con0,
		     RV1126_GMAC_PHY_INTF_SEL_MASK,
		     RV1126_GMAC_PHY_INTF_SEL_RMII);
}

static void rv1126_set_to_rgmii(struct gmac_rockchip_platdata *pdata)
{
	struct rv1126_grf *grf;

	enum {
		RV1126_GMAC_PHY_INTF_SEL_SHIFT = 4,
		RV1126_GMAC_PHY_INTF_SEL_MASK  = GENMASK(6, 4),
		RV1126_GMAC_PHY_INTF_SEL_RGMII = BIT(4),

		RV1126_RXCLK_M1_DLY_ENA_GMAC_MASK = BIT(3),
		RV1126_RXCLK_M1_DLY_ENA_GMAC_DISABLE = 0,
		RV1126_RXCLK_M1_DLY_ENA_GMAC_ENABLE = BIT(3),

		RV1126_TXCLK_M1_DLY_ENA_GMAC_MASK = BIT(2),
		RV1126_TXCLK_M1_DLY_ENA_GMAC_DISABLE = 0,
		RV1126_TXCLK_M1_DLY_ENA_GMAC_ENABLE = BIT(2),

		RV1126_RXCLK_M0_DLY_ENA_GMAC_MASK = BIT(1),
		RV1126_RXCLK_M0_DLY_ENA_GMAC_DISABLE = 0,
		RV1126_RXCLK_M0_DLY_ENA_GMAC_ENABLE = BIT(1),

		RV1126_TXCLK_M0_DLY_ENA_GMAC_MASK = BIT(0),
		RV1126_TXCLK_M0_DLY_ENA_GMAC_DISABLE = 0,
		RV1126_TXCLK_M0_DLY_ENA_GMAC_ENABLE = BIT(0),
	};
	enum {
		RV1126_M0_CLK_RX_DL_CFG_GMAC_SHIFT = 0x8,
		RV1126_M0_CLK_RX_DL_CFG_GMAC_MASK = GENMASK(14, 8),

		RV1126_M0_CLK_TX_DL_CFG_GMAC_SHIFT = 0x0,
		RV1126_M0_CLK_TX_DL_CFG_GMAC_MASK = GENMASK(6, 0),
	};
	enum {
		RV1126_M1_CLK_RX_DL_CFG_GMAC_SHIFT = 0x8,
		RV1126_M1_CLK_RX_DL_CFG_GMAC_MASK = GENMASK(14, 8),

		RV1126_M1_CLK_TX_DL_CFG_GMAC_SHIFT = 0x0,
		RV1126_M1_CLK_TX_DL_CFG_GMAC_MASK = GENMASK(6, 0),
	};

	grf = syscon_get_first_range(ROCKCHIP_SYSCON_GRF);

	rk_clrsetreg(&grf->mac_con0,
		     RV1126_TXCLK_M0_DLY_ENA_GMAC_MASK |
		     RV1126_RXCLK_M0_DLY_ENA_GMAC_MASK |
		     RV1126_TXCLK_M1_DLY_ENA_GMAC_MASK |
		     RV1126_RXCLK_M1_DLY_ENA_GMAC_MASK |
		     RV1126_GMAC_PHY_INTF_SEL_MASK,
		     RV1126_TXCLK_M0_DLY_ENA_GMAC_ENABLE |
		     RV1126_RXCLK_M0_DLY_ENA_GMAC_ENABLE |
		     RV1126_TXCLK_M1_DLY_ENA_GMAC_ENABLE |
		     RV1126_RXCLK_M1_DLY_ENA_GMAC_ENABLE |
		     RV1126_GMAC_PHY_INTF_SEL_RGMII);

	rk_clrsetreg(&grf->mac_con1,
		     RV1126_M0_CLK_RX_DL_CFG_GMAC_MASK |
		     RV1126_M0_CLK_TX_DL_CFG_GMAC_MASK,
		     pdata->rx_delay << RV1126_M0_CLK_RX_DL_CFG_GMAC_SHIFT |
		     pdata->tx_delay << RV1126_M0_CLK_TX_DL_CFG_GMAC_SHIFT);

	rk_clrsetreg(&grf->mac_con2,
		     RV1126_M1_CLK_RX_DL_CFG_GMAC_MASK |
		     RV1126_M1_CLK_TX_DL_CFG_GMAC_MASK,
		     pdata->rx_delay << RV1126_M1_CLK_RX_DL_CFG_GMAC_SHIFT |
		     pdata->tx_delay << RV1126_M1_CLK_TX_DL_CFG_GMAC_SHIFT);
}
#endif

static int gmac_rockchip_probe(struct udevice *dev)
{
	struct gmac_rockchip_platdata *pdata = dev_get_platdata(dev);
	struct rk_gmac_ops *ops =
		(struct rk_gmac_ops *)dev_get_driver_data(dev);
#ifdef CONFIG_DWC_ETH_QOS
	struct eqos_config *config;
#else
	struct dw_eth_pdata *dw_pdata;
#endif
	struct eth_pdata *eth_pdata;
	struct clk clk;
	ulong rate;
	int ret;

#ifdef CONFIG_DWC_ETH_QOS
	eth_pdata = &pdata->eth_pdata;
	config = (struct eqos_config *)&ops->config;
	eth_pdata->phy_interface = config->ops->eqos_get_interface(dev);
#else
	dw_pdata = &pdata->dw_eth_pdata;
	eth_pdata = &dw_pdata->eth_pdata;
#endif
	/* Process 'assigned-{clocks/clock-parents/clock-rates}' properties */
	ret = clk_set_defaults(dev);
	if (ret)
		debug("%s clk_set_defaults failed %d\n", __func__, ret);

	ret = clk_get_by_index(dev, 0, &clk);
	if (ret)
		return ret;

	switch (eth_pdata->phy_interface) {
	case PHY_INTERFACE_MODE_RGMII:
		/*
		 * If the gmac clock is from internal pll, need to set and
		 * check the return value for gmac clock at RGMII mode. If
		 * the gmac clock is from external source, the clock rate
		 * is not set, because of it is bypassed.
		 */
		if (!pdata->clock_input) {
			rate = clk_set_rate(&clk, 125000000);
			if (rate != 125000000)
				return -EINVAL;
		}

		/* Set to RGMII mode */
		if (ops->set_to_rgmii)
			ops->set_to_rgmii(pdata);
		else
			return -EPERM;

		break;
	case PHY_INTERFACE_MODE_RMII:
		/* The commet is the same as RGMII mode */
		if (!pdata->clock_input) {
			rate = clk_set_rate(&clk, 50000000);
			if (rate != 50000000)
				return -EINVAL;
		}

		/* Set to RMII mode */
		if (ops->set_to_rmii)
			ops->set_to_rmii(pdata);
		else
			return -EPERM;

		break;
	default:
		debug("NO interface defined!\n");
		return -ENXIO;
	}

#ifdef CONFIG_DWC_ETH_QOS
	return eqos_probe(dev);
#else
	return designware_eth_probe(dev);
#endif
}

static int gmac_rockchip_eth_write_hwaddr(struct udevice *dev)
{
#if defined(CONFIG_DWC_ETH_QOS)
	return eqos_write_hwaddr(dev);
#else
	return designware_eth_write_hwaddr(dev);
#endif
}

static int gmac_rockchip_eth_free_pkt(struct udevice *dev, uchar *packet,
				      int length)
{
#ifdef CONFIG_DWC_ETH_QOS
	return eqos_free_pkt(dev, packet, length);
#else
	return designware_eth_free_pkt(dev, packet, length);
#endif
}

static int gmac_rockchip_eth_send(struct udevice *dev, void *packet,
				  int length)
{
#ifdef CONFIG_DWC_ETH_QOS
	return eqos_send(dev, packet, length);
#else
	return designware_eth_send(dev, packet, length);
#endif
}

static int gmac_rockchip_eth_recv(struct udevice *dev, int flags,
				  uchar **packetp)
{
#ifdef CONFIG_DWC_ETH_QOS
	return eqos_recv(dev, flags, packetp);
#else
	return designware_eth_recv(dev, flags, packetp);
#endif
}

static int gmac_rockchip_eth_start(struct udevice *dev)
{
	struct rockchip_eth_dev *priv = dev_get_priv(dev);
	struct rk_gmac_ops *ops =
		(struct rk_gmac_ops *)dev_get_driver_data(dev);
#ifndef CONFIG_DWC_ETH_QOS
	struct gmac_rockchip_platdata *pdata = dev_get_platdata(dev);
	struct dw_eth_pdata *dw_pdata;
	struct eth_pdata *eth_pdata;
#endif
	int ret;

#ifdef CONFIG_DWC_ETH_QOS
	ret = eqos_init(dev);
#else
	dw_pdata = &pdata->dw_eth_pdata;
	eth_pdata = &dw_pdata->eth_pdata;
	ret = designware_eth_init((struct dw_eth_dev *)priv,
				  eth_pdata->enetaddr);
#endif
	if (ret)
		return ret;
	ret = ops->fix_mac_speed(priv);
	if (ret)
		return ret;

#ifdef CONFIG_DWC_ETH_QOS
	eqos_enable(dev);
#else
	ret = designware_eth_enable((struct dw_eth_dev *)priv);
	if (ret)
		return ret;
#endif

	return 0;
}

static void gmac_rockchip_eth_stop(struct udevice *dev)
{
#ifdef CONFIG_DWC_ETH_QOS
	eqos_stop(dev);
#else
	designware_eth_stop(dev);
#endif
}

const struct eth_ops gmac_rockchip_eth_ops = {
	.start			= gmac_rockchip_eth_start,
	.send			= gmac_rockchip_eth_send,
	.recv			= gmac_rockchip_eth_recv,
	.free_pkt		= gmac_rockchip_eth_free_pkt,
	.stop			= gmac_rockchip_eth_stop,
	.write_hwaddr		= gmac_rockchip_eth_write_hwaddr,
};

#ifndef CONFIG_DWC_ETH_QOS
const struct rk_gmac_ops px30_gmac_ops = {
	.fix_mac_speed = px30_gmac_fix_mac_speed,
	.set_to_rmii = px30_gmac_set_to_rmii,
};

const struct rk_gmac_ops rk1808_gmac_ops = {
	.fix_mac_speed = rk1808_gmac_fix_mac_speed,
	.set_to_rgmii = rk1808_gmac_set_to_rgmii,
};

const struct rk_gmac_ops rk3228_gmac_ops = {
	.fix_mac_speed = rk3228_gmac_fix_mac_speed,
	.set_to_rgmii = rk3228_gmac_set_to_rgmii,
};

const struct rk_gmac_ops rk3288_gmac_ops = {
	.fix_mac_speed = rk3288_gmac_fix_mac_speed,
	.set_to_rgmii = rk3288_gmac_set_to_rgmii,
};

const struct rk_gmac_ops rk3308_gmac_ops = {
	.fix_mac_speed = rk3308_gmac_fix_mac_speed,
	.set_to_rmii = rk3308_gmac_set_to_rmii,
};

const struct rk_gmac_ops rk3328_gmac_ops = {
	.fix_mac_speed = rk3328_gmac_fix_mac_speed,
	.set_to_rgmii = rk3328_gmac_set_to_rgmii,
};

const struct rk_gmac_ops rk3368_gmac_ops = {
	.fix_mac_speed = rk3368_gmac_fix_mac_speed,
	.set_to_rgmii = rk3368_gmac_set_to_rgmii,
};

const struct rk_gmac_ops rk3399_gmac_ops = {
	.fix_mac_speed = rk3399_gmac_fix_mac_speed,
	.set_to_rgmii = rk3399_gmac_set_to_rgmii,
};

const struct rk_gmac_ops rv1108_gmac_ops = {
	.fix_mac_speed = rv1108_set_rmii_speed,
	.set_to_rmii = rv1108_gmac_set_to_rmii,
};
#else
const struct rk_gmac_ops rv1126_gmac_ops = {
	.config = {
		.reg_access_always_ok = false,
		.mdio_wait = 10000,
		.swr_wait = 200,
		.config_mac = EQOS_MAC_RXQ_CTRL0_RXQ0EN_NOT_ENABLED,
		.config_mac_mdio = EQOS_MAC_MDIO_ADDRESS_CR_100_150,
		.ops = &eqos_rockchip_ops
	},

	.fix_mac_speed = rv1126_set_rgmii_speed,
	.set_to_rgmii = rv1126_set_to_rgmii,
	.set_to_rmii = rv1126_set_to_rmii,
};
#endif

static const struct udevice_id rockchip_gmac_ids[] = {
#ifndef CONFIG_DWC_ETH_QOS
	{ .compatible = "rockchip,px30-gmac",
	  .data = (ulong)&px30_gmac_ops },
	{ .compatible = "rockchip,rk1808-gmac",
	  .data = (ulong)&rk1808_gmac_ops },
	{ .compatible = "rockchip,rk3228-gmac",
	  .data = (ulong)&rk3228_gmac_ops },
	{ .compatible = "rockchip,rk3288-gmac",
	  .data = (ulong)&rk3288_gmac_ops },
	{ .compatible = "rockchip,rk3308-mac",
	  .data = (ulong)&rk3308_gmac_ops },
	{ .compatible = "rockchip,rk3328-gmac",
	  .data = (ulong)&rk3328_gmac_ops },
	{ .compatible = "rockchip,rk3368-gmac",
	  .data = (ulong)&rk3368_gmac_ops },
	{ .compatible = "rockchip,rk3399-gmac",
	  .data = (ulong)&rk3399_gmac_ops },
	{ .compatible = "rockchip,rv1108-gmac",
	  .data = (ulong)&rv1108_gmac_ops },
#else
	{ .compatible = "rockchip,rv1126-gmac",
	  .data = (ulong)&rv1126_gmac_ops },
#endif
	{ }
};

U_BOOT_DRIVER(eth_gmac_rockchip) = {
	.name	= "gmac_rockchip",
	.id	= UCLASS_ETH,
	.of_match = rockchip_gmac_ids,
	.ofdata_to_platdata = gmac_rockchip_ofdata_to_platdata,
	.probe	= gmac_rockchip_probe,
	.ops	= &gmac_rockchip_eth_ops,
	.priv_auto_alloc_size = sizeof(struct rockchip_eth_dev),
	.platdata_auto_alloc_size = sizeof(struct gmac_rockchip_platdata),
	.flags = DM_FLAG_ALLOC_PRIV_DMA,
};
