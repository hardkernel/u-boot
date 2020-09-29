// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <asm/io.h>
#include <command.h>
#include <dm.h>
#include <linux/bitops.h>
#include <linux/delay.h>
#include <linux/iopoll.h>
#include <misc.h>
#include <rockchip-otp.h>

struct otp_data {
	int (*init)(struct udevice *dev);
	int (*read)(struct udevice *dev, int offset, void *buf, int size);
};

static int rockchip_otp_wait_status(struct rockchip_otp_platdata *otp,
				    u32 flag)
{
	int delay = OTPC_TIMEOUT;

	while (!(readl(otp->base + OTPC_INT_STATUS) & flag)) {
		udelay(1);
		delay--;
		if (delay <= 0) {
			printf("%s: wait init status timeout\n", __func__);
			return -ETIMEDOUT;
		}
	}

	/* clean int status */
	writel(flag, otp->base + OTPC_INT_STATUS);

	return 0;
}

static int rockchip_otp_ecc_enable(struct rockchip_otp_platdata *otp,
				   bool enable)
{
	int ret = 0;

	writel(SBPI_DAP_ADDR_MASK | (SBPI_DAP_ADDR << SBPI_DAP_ADDR_SHIFT),
	       otp->base + OTPC_SBPI_CTRL);

	writel(SBPI_CMD_VALID_MASK | 0x1, otp->base + OTPC_SBPI_CMD_VALID_PRE);
	writel(SBPI_DAP_CMD_WRF | SBPI_DAP_REG_ECC,
	       otp->base + OTPC_SBPI_CMD0_OFFSET);
	if (enable)
		writel(SBPI_ECC_ENABLE, otp->base + OTPC_SBPI_CMD1_OFFSET);
	else
		writel(SBPI_ECC_DISABLE, otp->base + OTPC_SBPI_CMD1_OFFSET);

	writel(SBPI_ENABLE_MASK | SBPI_ENABLE, otp->base + OTPC_SBPI_CTRL);

	ret = rockchip_otp_wait_status(otp, OTPC_SBPI_DONE);
	if (ret < 0)
		printf("%s timeout during ecc_enable\n", __func__);

	return ret;
}

static int rockchip_px30_otp_read(struct udevice *dev, int offset,
				  void *buf, int size)
{
	struct rockchip_otp_platdata *otp = dev_get_platdata(dev);
	u8 *buffer = buf;
	int ret = 0;

	ret = rockchip_otp_ecc_enable(otp, false);
	if (ret < 0) {
		printf("%s rockchip_otp_ecc_enable err\n", __func__);
		return ret;
	}

	writel(OTPC_USE_USER | OTPC_USE_USER_MASK, otp->base + OTPC_USER_CTRL);
	udelay(5);
	while (size--) {
		writel(offset++ | OTPC_USER_ADDR_MASK,
		       otp->base + OTPC_USER_ADDR);
		writel(OTPC_USER_FSM_ENABLE | OTPC_USER_FSM_ENABLE_MASK,
		       otp->base + OTPC_USER_ENABLE);
		ret = rockchip_otp_wait_status(otp, OTPC_USER_DONE);
		if (ret < 0) {
			printf("%s timeout during read setup\n", __func__);
			goto read_end;
		}
		*buffer++ = readb(otp->base + OTPC_USER_Q);
	}

read_end:
	writel(0x0 | OTPC_USE_USER_MASK, otp->base + OTPC_USER_CTRL);

	return ret;
}

static int rockchip_rv1126_otp_init(struct udevice *dev)
{
	struct rockchip_otp_platdata *otp = dev_get_platdata(dev);
	u32 status = 0;
	int ret;

	writel(0x0, otp->base + RV1126_OTP_NVM_CEB);
	ret = readl_poll_timeout(otp->base + RV1126_OTP_NVM_ST, status,
				 status & 0x1, OTPC_TIMEOUT);
	if (ret < 0) {
		printf("%s timeout during set ceb\n", __func__);
		return ret;
	}

	writel(0x1, otp->base + RV1126_OTP_NVM_RSTB);
	ret = readl_poll_timeout(otp->base + RV1126_OTP_NVM_ST, status,
				 status & 0x4, OTPC_TIMEOUT);
	if (ret < 0) {
		printf("%s timeout during set rstb\n", __func__);
		return ret;
	}

	return 0;
}

static int rockchip_rv1126_otp_read(struct udevice *dev, int offset, void *buf,
				    int size)
{
	struct rockchip_otp_platdata *otp = dev_get_platdata(dev);
	u32 status = 0;
	u8 *buffer = buf;
	int ret = 0;

	while (size--) {
		writel(offset++, otp->base + RV1126_OTP_NVM_RADDR);
		writel(0x1, otp->base + RV1126_OTP_NVM_RSTART);
		ret = readl_poll_timeout(otp->base + RV1126_OTP_READ_ST,
					 status, status == 0, OTPC_TIMEOUT);
		if (ret < 0) {
			printf("%s timeout during read setup\n", __func__);
			return ret;
		}

		*buffer++ = readb(otp->base + RV1126_OTP_NVM_RDATA);
	}

	return 0;
}

static int rockchip_otp_read(struct udevice *dev, int offset,
			     void *buf, int size)
{
	struct otp_data *data;

	data = (struct otp_data *)dev_get_driver_data(dev);
	if (!data)
		return -ENOSYS;

	return data->read(dev, offset, buf, size);
}

static const struct misc_ops rockchip_otp_ops = {
	.read = rockchip_otp_read,
};

static int rockchip_otp_ofdata_to_platdata(struct udevice *dev)
{
	struct rockchip_otp_platdata *otp = dev_get_platdata(dev);

	otp->base = dev_read_addr_ptr(dev);

	return 0;
}

static int rockchip_otp_probe(struct udevice *dev)
{
	struct otp_data *data;

	data = (struct otp_data *)dev_get_driver_data(dev);
	if (!data)
		return -EINVAL;

	if (data->init)
		return data->init(dev);

	return 0;
}

static const struct otp_data px30_data = {
	.read = rockchip_px30_otp_read,
};

static const struct otp_data rv1126_data = {
	.init = rockchip_rv1126_otp_init,
	.read = rockchip_rv1126_otp_read,
};

static const struct udevice_id rockchip_otp_ids[] = {
	{
		.compatible = "rockchip,px30-otp",
		.data = (ulong)&px30_data,
	},
	{
		.compatible = "rockchip,rk3308-otp",
		.data = (ulong)&px30_data,
	},
	{
		.compatible = "rockchip,rv1126-otp",
		.data = (ulong)&rv1126_data,
	},
	{}
};

U_BOOT_DRIVER(rockchip_otp) = {
	.name = "rockchip_otp",
	.id = UCLASS_MISC,
	.of_match = rockchip_otp_ids,
	.ops = &rockchip_otp_ops,
	.ofdata_to_platdata = rockchip_otp_ofdata_to_platdata,
	.platdata_auto_alloc_size = sizeof(struct rockchip_otp_platdata),
	.probe = rockchip_otp_probe,
};
