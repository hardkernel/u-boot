// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <bouncebuf.h>
#include <clk.h>
#include <dm.h>
#include <dt-structs.h>
#include <errno.h>
#include <linux/errno.h>
#include <asm/arch/hardware.h>
#include <asm/io.h>
#include <asm/arch/clock.h>
#include <asm/arch/periph.h>
#include <rockchip_crypto/rockchip_crypto_hd.h>
#include <rockchip_crypto/rockchip_crypto.h>

struct rockchip_crypto_plat {
	fdt_addr_t base;
	s32 frequency;
};

struct rockchip_crypto_priv {
	volatile struct rk_crypto_reg *regbase;
	struct clk clk;
	unsigned int max_freq;
};

static int rockchip_crypto_ofdata_to_platdata(struct udevice *bus)
{
	struct rockchip_crypto_plat *plat = dev_get_platdata(bus);
	struct rockchip_crypto_priv *priv = dev_get_priv(bus);
	int ret = 0;

	plat->base = dev_read_u32_default(bus, "default-addr", 0);
	debug("Crypto base address is %x\n", (int)(size_t)plat->base);
	ret = clk_get_by_index(bus, 0, &priv->clk);
	if (ret < 0) {
		printf("Could not get clock for %s: %d\n", bus->name, ret);
		return ret;
	}

	plat->frequency = dev_read_u32_default(bus, "default-frequency",
					       CRYPTO_DEFAULT_CLK);
	debug("Crypto clock frequency is %x\n", (int)(size_t)plat->frequency);

	return 0;
}

static int rockchip_crypto_probe(struct udevice *dev)
{
	struct rockchip_crypto_plat *plat = dev_get_platdata(dev);
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	int ret = 0;

	priv->regbase = (volatile struct rk_crypto_reg *)
				(plat->base & 0xffffffff);
	priv->max_freq = plat->frequency;
	ret = clk_set_rate(&priv->clk, priv->max_freq);
	if (ret < 0) {
		printf("%s: Failed to set clock: %d\n", __func__, ret);
		return ret;
	}

	return 0;
}

static int rockchip_crypto_sha_init(struct udevice *dev, u32 msg_len,
				    int hash_bits)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);

	priv->regbase->crypto_hash_meg_len = msg_len;
	if (hash_bits == SHA_256_BIT) {
		priv->regbase->crypto_hash_ctrl = HASH_SWAP_DO | ENGINE_SELECTION_SHA256;
		priv->regbase->crypto_conf &= ~(BYTESWAP_HRFIFO);
	} else {
		printf("Do not support that hash_bits is not equal to 256");
		return -ENOTSUPP;
	}

	rk_setreg(&priv->regbase->crypto_ctrl, HASH_FLUSH);
	do {} while (priv->regbase->crypto_ctrl & HASH_FLUSH);

	return 0;
}

static int rockchip_crypto_sha_byte_swap(struct udevice *dev, int en)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);

	if (en)
		priv->regbase->crypto_conf |= BYTESWAP_HRFIFO;
	else
		priv->regbase->crypto_conf &= ~BYTESWAP_HRFIFO;
	return 0;
}

static int rockchip_crypto_sha_start(struct udevice *dev, u32 *data,
				     u32 data_len)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);

	if (data_len == 0)
		return 0;

	flush_cache((unsigned long)data, data_len);
	do {} while (priv->regbase->crypto_ctrl & HASH_START);
	priv->regbase->crypto_intsts = HASH_DONE_INT;
	priv->regbase->crypto_hrdmas = (u32)(unsigned long)data;
	priv->regbase->crypto_hrdmal = ((data_len + 3) >> 2);
	rk_setreg(&priv->regbase->crypto_ctrl, HASH_START);

	return 0;
}

static int rockchip_crypto_sha_end(struct udevice *dev, u32 *result)
{
	int i;
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);

	do {} while (priv->regbase->crypto_ctrl & HASH_START);
	do {} while (!priv->regbase->crypto_hash_sts);
	for (i = 0; i < 8; i++)
		*result++ = priv->regbase->crypto_hash_dout[i];

	return 0;
}

static int rockchip_crypto_rsa_init(struct udevice *dev)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);

	priv->regbase->crypto_pka_ctrl = PKA_BLOCK_SIZE_2048;
	rk_setreg(&priv->regbase->crypto_ctrl, PKA_HASH_CTRL);
	priv->regbase->crypto_intsts = 0xffffffff;
	do {} while (priv->regbase->crypto_ctrl & PKA_CTRL);

	return 0;
}

static int rockchip_crypto_rsa_start(struct udevice *dev, u32 *m,
				     u32 *n, u32 *e, u32 *c)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);

	priv->regbase->crypto_intsts = PKA_DONE_INT;
	memcpy((void *)&priv->regbase->crypto_pka_m, (void *)m, 256);
	memcpy((void *)&priv->regbase->crypto_pka_n, (void *)n, 256);
	memcpy((void *)&priv->regbase->crypto_pka_e, (void *)e, 256);
	memcpy((void *)&priv->regbase->crypto_pka_c, (void *)c, 256);
	do {} while (priv->regbase->crypto_ctrl & PKA_START);
	rk_setreg(&priv->regbase->crypto_ctrl, PKA_START);

	return 0;
}

static int rockchip_crypto_rsa_end(struct udevice *dev, u32 *result)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	int i;

	do {} while (priv->regbase->crypto_ctrl & PKA_START);
	for (i = 0; i < 8; i++)
		*result++ = *((u32 *)(&priv->regbase->crypto_pka_m + i));

	return 0;
}

static const struct dm_rk_crypto_ops rockchip_crypto_ops = {
	.sha_init = rockchip_crypto_sha_init,
	.sha_byte_swap = rockchip_crypto_sha_byte_swap,
	.sha_start = rockchip_crypto_sha_start,
	.sha_end = rockchip_crypto_sha_end,
	.rsa_init = rockchip_crypto_rsa_init,
	.rsa_start = rockchip_crypto_rsa_start,
	.rsa_end = rockchip_crypto_rsa_end,
};

static const struct udevice_id rockchip_crypto_ids[] = {
	{ .compatible = "rockchip,rk3399-crypto" },
	{ }
};

U_BOOT_DRIVER(rockchip_crypto_drv) = {
	.name		= "rockchip_crypto",
	.id		= UCLASS_RKCRYPTO,
	.of_match	= rockchip_crypto_ids,
	.ops = &rockchip_crypto_ops,
	.ofdata_to_platdata = rockchip_crypto_ofdata_to_platdata,
	.probe		= rockchip_crypto_probe,
	.priv_auto_alloc_size = sizeof(struct rockchip_crypto_priv),
	.platdata_auto_alloc_size = sizeof(struct rockchip_crypto_plat),
};
