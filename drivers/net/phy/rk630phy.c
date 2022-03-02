// SPDX-License-Identifier: GPL-2.0+
/**
 *
 * Driver for ROCKCHIP RK630 Ethernet PHYs
 *
 * Copyright (c) 2020, Fuzhou Rockchip Electronics Co., Ltd
 *
 * David Wu <david.wu@rock-chips.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 */

#include <config.h>
#include <common.h>
#include <linux/bitops.h>
#include <phy.h>

#define RK630_PHY_ID				0x00441400

/* PAGE 0 */
#define REG_INTERRUPT_STATUS			0X10
#define REG_INTERRUPT_MASK			0X11
#define REG_GLOBAL_CONFIGURATION		0X13
#define REG_MAC_ADDRESS0			0x16
#define REG_MAC_ADDRESS1			0x17
#define REG_MAC_ADDRESS2			0x18

#define REG_PAGE_SEL				0x1F

/* PAGE 1 */
#define REG_PAGE1_APS_CTRL			0x12
#define REG_PAGE1_UAPS_CONFIGURE		0X13
#define REG_PAGE1_EEE_CONFIGURE			0x17

/* PAGE 2 */
#define REG_PAGE2_AFE_CTRL			0x18

/* PAGE 6 */
#define REG_PAGE6_ADC_ANONTROL			0x10
#define REG_PAGE6_AFE_RX_CTRL			0x13
#define REG_PAGE6_AFE_TX_CTRL			0x14
#define REG_PAGE6_AFE_DRIVER2			0x15

/* PAGE 8 */
#define REG_PAGE8_AFE_CTRL			0x18

static void rk630_phy_ieee_set(struct phy_device *phydev, bool enable)
{
	u32 value;

	/* Switch to page 1 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0100);
	value = phy_read(phydev, MDIO_DEVAD_NONE, REG_PAGE1_EEE_CONFIGURE);
	if (enable)
		value |= BIT(3);
	else
		value &= ~BIT(3);
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE1_EEE_CONFIGURE, value);
	/* Switch to page 0 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0000);
}

static void rk630_phy_set_uaps(struct phy_device *phydev)
{
	u32 value;

	/* Switch to page 1 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0100);
	value = phy_read(phydev, MDIO_DEVAD_NONE, REG_PAGE1_UAPS_CONFIGURE);
	value |= BIT(15);
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE1_UAPS_CONFIGURE, value);
	/* Switch to page 0 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0000);
}

static int rk630_phy_config_init(struct phy_device *phydev)
{
	u32 value;

	phy_write(phydev, 0, MDIO_DEVAD_NONE,
		  phy_read(phydev, MDIO_DEVAD_NONE, 0) & ~BIT(13));

	/* Switch to page 1 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0100);
	/* Disable APS */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE1_APS_CTRL, 0x4824);
	/* Switch to page 2 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0200);
	/* PHYAFE TRX optimization */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE2_AFE_CTRL, 0x0000);
	/* Switch to page 6 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0600);
	/* PHYAFE TX optimization */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE6_AFE_TX_CTRL, 0x708f);
	/* PHYAFE RX optimization */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE6_AFE_RX_CTRL, 0xf000);
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE6_AFE_DRIVER2, 0x1530);

	/* Switch to page 8 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0800);
	/* PHYAFE TRX optimization */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE8_AFE_CTRL, 0x00bc);

	/* Adjust tx level, bypass */
	value = phy_read(phydev, MDIO_DEVAD_NONE, 0x1d);
	value |= BIT(11);
	phy_write(phydev, 0x1d, MDIO_DEVAD_NONE, value);
	/* switch to page6 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0600);
	/* Enable tx level control */
	value = phy_read(phydev, MDIO_DEVAD_NONE, REG_PAGE6_ADC_ANONTROL);
	value &= ~BIT(6);
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE6_ADC_ANONTROL, value);
	/* Set tx level */
	value = phy_read(phydev, MDIO_DEVAD_NONE, REG_PAGE6_AFE_DRIVER2);
	value &= ~GENMASK(15, 8);
	value |= 0x121a;
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE6_AFE_DRIVER2, value);

	/* Switch to page 0 */
	phy_write(phydev, MDIO_DEVAD_NONE, REG_PAGE_SEL, 0x0000);

	rk630_phy_ieee_set(phydev, true);
	/*
	 * Ultra Auto-Power Saving Mode (UAPS) is designed to
	 * save power when cable is not plugged into PHY.
	 */
	rk630_phy_set_uaps(phydev);

	return 0;
}

static int rk630_phy_probe(struct phy_device *phydev)
{
	return 0;
}

static struct phy_driver RK630_driver = {
	.name = "Rockchip RK630",
	.uid = RK630_PHY_ID,
	.mask = 0xffffff,
	.features = PHY_BASIC_FEATURES,
	.probe = &rk630_phy_probe,
	.config = &rk630_phy_config_init,
	.shutdown = &genphy_shutdown,
};

int phy_rk630_init(void)
{
	phy_register(&RK630_driver);

	return 0;
}
