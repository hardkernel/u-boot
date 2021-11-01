/*
 **Copyright (C) 2021 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <dm.h>
#include <errno.h>
#include <irq-generic.h>
#include <power/rk8xx_pmic.h>
#include <power/pmic.h>
#include <spi.h>

DECLARE_GLOBAL_DATA_PTR;

#define RK806_CHIP_NAME			0x5A
#define RK806_CHIP_VER			0x5B

#define RK806_CMD_READ			0
#define RK806_CMD_WRITE			BIT(7)
#define RK806_CMD_CRC_EN		BIT(6)
#define RK806_CMD_CRC_DIS		0
#define RK806_CMD_LEN_MSK		0x0f
#define RK806_REG_H			0x00

static const struct pmic_child_info pmic_children_info[] = {
	{ .prefix = "DCDC", .driver = "rk8xx_spi_buck"},
	{ .prefix = "NLDO", .driver = "rk8xx_spi_ldo"},
	{ .prefix = "PLDO", .driver = "rk8xx_spi_pldo"},
	{ },
};

static int _spi_read(struct udevice *dev, u32 reg, u8 *buffer, int len)
{
	struct rk8xx_priv *priv = dev_get_priv(dev);
	u8 txbuf[3];
	int ret;

	if (spi_claim_bus(priv->slave))
		return -EBUSY;

	txbuf[0] = RK806_CMD_READ;
	txbuf[1] = reg;
	txbuf[2] = RK806_REG_H;

	ret = spi_write_then_read(priv->slave, txbuf, 3, NULL, buffer, 1);
	spi_release_bus(priv->slave);

	return ret;
}

static int _spi_write(struct udevice *dev, uint reg, const u8 *buffer, int len)
{
	struct rk8xx_priv *priv = dev_get_priv(dev);
	u8 txbuf[4];
	int ret;

	if (len < 1) {
		dev_err(dev, "rk806 write error: len < 1\n");
		return -EINVAL;
	}

	if (spi_claim_bus(priv->slave))
		return -EBUSY;

	txbuf[0] = RK806_CMD_WRITE;
	txbuf[1] = reg;
	txbuf[2] = RK806_REG_H;
	txbuf[3] = *buffer;

	ret = spi_write_then_read(priv->slave, txbuf, 4, NULL, NULL, 0);
	spi_release_bus(priv->slave);

	return ret;
}

static int rk806_spi_read(struct udevice *dev,
			  uint reg,
			  u8 *buffer,
			  int len)
{
	int ret;

	ret = _spi_read(dev, reg, buffer, len);
	if (ret)
		dev_err(dev, "rk806 read reg(0x%x) error: %d\n", reg, ret);

	return ret;
}

static int rk806_spi_write(struct udevice *dev,
			   uint reg,
			   const u8 *buffer,
			   int len)
{
	int ret;

	ret = _spi_write(dev, reg, buffer, len);
	if (ret)
		dev_err(dev, "rk806 write reg(0x%x) error: %d\n", reg, ret);

	return ret;
}

static int rk8xx_spi_reg_count(struct udevice *dev)
{
	return 0xff;
}

#if CONFIG_IS_ENABLED(PMIC_CHILDREN)
static int rk8xx_spi_bind(struct udevice *dev)
{
	ofnode regulators_node;
	int children;

	regulators_node = dev_read_subnode(dev, "regulators");
	if (!ofnode_valid(regulators_node)) {
		debug("%s: %s regulators subnode not found!\n", __func__,
		      dev->name);
		return -ENXIO;
	}

	children = pmic_bind_children(dev, regulators_node, pmic_children_info);
	if (!children)
		debug("%s: %s - no child found\n", __func__, dev->name);

	return 0;
}
#endif

static int rk8xx_spi_probe(struct udevice *dev)
{
	struct dm_spi_slave_platdata *plat = dev_get_parent_platdata(dev);
	struct rk8xx_priv *priv = dev_get_priv(dev);
	struct udevice *spi = dev_get_parent(dev);
	struct spi_slave *slave = NULL;
	u8 msb, lsb;
	int ret;

	if (spi->seq < 0) {
		dev_err(dev, "Failed to configure the spi num\n");
		return -EINVAL;
	}

	slave = spi_setup_slave(spi->seq, plat->cs, plat->max_hz,
				plat->mode);
	if (!slave)
		return -ENODEV;
	priv->slave = slave;

	/* read Chip variant */
	ret = rk806_spi_read(dev, RK806_CHIP_NAME, &msb, 1);
	if (msb < 0) {
		dev_err(dev, "rk806 name read error: %d\n", ret);
		return ret;
	}

	ret = rk806_spi_read(dev, RK806_CHIP_VER, &lsb, 1);
	if (lsb < 0) {
		dev_err(dev, "rk806 version read error: %d\n", ret);
		return ret;
	}

	priv->variant = ((msb << 8) | lsb) & RK8XX_ID_MSK;
	printf("spi%d: RK%x%x: %d\n", spi->seq, msb, (lsb >> 4), lsb & 0x0f);

	return 0;
}

static struct dm_pmic_ops rk8xx_spi_ops = {
	.reg_count = rk8xx_spi_reg_count,
	.read = rk806_spi_read,
	.write = rk806_spi_write,
};

static const struct udevice_id rk8xx_spi_ids[] = {
	{ .compatible = "rockchip,rk806" },
	{ }
};

U_BOOT_DRIVER(pmic_rk8xx_spi) = {
	.name = "rk806-pmic",
	.id = UCLASS_PMIC,
	.of_match = rk8xx_spi_ids,
#if CONFIG_IS_ENABLED(PMIC_CHILDREN)
	.bind = rk8xx_spi_bind,
#endif
	.priv_auto_alloc_size = sizeof(struct rk8xx_priv),
	.probe = rk8xx_spi_probe,
	.ops = &rk8xx_spi_ops,
};
