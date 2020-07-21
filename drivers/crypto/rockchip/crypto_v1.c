// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <clk.h>
#include <crypto.h>
#include <dm.h>
#include <rockchip/crypto_v1.h>
#include <asm/io.h>
#include <asm/arch/hardware.h>
#include <asm/arch/clock.h>

#define CRYPTO_V1_DEFAULT_RATE		100000000

struct rockchip_crypto_priv {
	struct rk_crypto_reg *reg;
	struct clk clk;
	sha_context *ctx;
	u32 frequency;
	char *clocks;
	u32 nclocks;
	u32 length;
};

static u32 rockchip_crypto_capability(struct udevice *dev)
{
	return CRYPTO_MD5 |
	       CRYPTO_SHA1 |
	       CRYPTO_SHA256 |
	       CRYPTO_RSA512 |
	       CRYPTO_RSA1024 |
	       CRYPTO_RSA2048;
}

static int rockchip_crypto_sha_init(struct udevice *dev, sha_context *ctx)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	struct rk_crypto_reg *reg = priv->reg;
	u32 val;

	if (!ctx)
		return -EINVAL;

	if (!ctx->length) {
		printf("Crypto-v1: require data total length for sha init\n");
		return -EINVAL;
	}

	priv->ctx = ctx;
	priv->length = 0;
	writel(ctx->length, &reg->crypto_hash_msg_len);
	if (ctx->algo == CRYPTO_SHA256) {
		/* Set SHA256 mode and out byte swap */
		writel(HASH_SWAP_DO | ENGINE_SELECTION_SHA256,
		       &reg->crypto_hash_ctrl);

		val = readl(&reg->crypto_conf);
		val &= ~BYTESWAP_HRFIFO;
		writel(val, &reg->crypto_conf);
	} else if (ctx->algo == CRYPTO_SHA1) {
		/* Set SHA160 input byte swap */
		val = readl(&reg->crypto_conf);
		val |= BYTESWAP_HRFIFO;
		writel(val, &reg->crypto_conf);

		/* Set SHA160 mode and out byte swap */
		writel(HASH_SWAP_DO, &reg->crypto_hash_ctrl);
	} else if (ctx->algo == CRYPTO_MD5) {
		/* Set MD5 input byte swap */
		val = readl(&reg->crypto_conf);
		val |= BYTESWAP_HRFIFO;
		writel(val, &reg->crypto_conf);

		/* Set MD5 mode and out byte swap */
		writel(HASH_SWAP_DO | ENGINE_SELECTION_MD5,
		       &reg->crypto_hash_ctrl);
	} else {
		return -EINVAL;
	}

	rk_setreg(&reg->crypto_ctrl, HASH_FLUSH);
	do {} while (readl(&reg->crypto_ctrl) & HASH_FLUSH);

	/* SHA256 needs input byte swap */
	if (ctx->algo == CRYPTO_SHA256) {
		val = readl(&reg->crypto_conf);
		val |= BYTESWAP_HRFIFO;
		writel(val, &reg->crypto_conf);
	}

	return 0;
}

static int rockchip_crypto_sha_update(struct udevice *dev,
				      u32 *input, u32 len)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	struct rk_crypto_reg *reg = priv->reg;
	ulong aligned_input, aligned_len;

	if (!len)
		return -EINVAL;

	priv->length += len;
	if ((priv->length != priv->ctx->length) && !IS_ALIGNED(len, 4)) {
		printf("Crypto-v1: require update data length 4-byte "
		       "aligned(0x%08lx - 0x%08lx)\n",
		       (ulong)input, (ulong)input + len);
		return -EINVAL;
	}

	/* Must flush dcache before crypto DMA fetch data region */
	aligned_input = round_down((ulong)input, CONFIG_SYS_CACHELINE_SIZE);
	aligned_len = round_up(len + ((ulong)input - aligned_input),
			       CONFIG_SYS_CACHELINE_SIZE);
	flush_cache(aligned_input, aligned_len);

	/* Wait last complete */
	do {} while (readl(&reg->crypto_ctrl) & HASH_START);

	/* Hash Done Interrupt */
	writel(HASH_DONE_INT, &reg->crypto_intsts);

	/* Set data base and length */
	writel((u32)(ulong)input, &reg->crypto_hrdmas);
	writel((len + 3) >> 2, &reg->crypto_hrdmal);

	/* Write 1 to start. When finishes, the core will clear it */
	rk_setreg(&reg->crypto_ctrl, HASH_START);

	return 0;
}

static int rockchip_crypto_sha_final(struct udevice *dev,
				     sha_context *ctx, u8 *output)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	struct rk_crypto_reg *reg = priv->reg;
	u32 *buf = (u32 *)output;
	u32 nbits;
	int i;

	if (priv->length != ctx->length) {
		printf("Crypto-v1: data total length(0x%08x) != init length(0x%08x)!\n",
		       priv->length, ctx->length);
		return -EIO;
	}

	/* Wait last complete */
	do {} while (readl(&reg->crypto_ctrl) & HASH_START);

	/* It is high when finish, and it will not be low until it restart */
	do {} while (!readl(&reg->crypto_hash_sts));

	/* Read hash data, per-data 32-bit */
	nbits = crypto_algo_nbits(ctx->algo);
	for (i = 0; i < BITS2WORD(nbits); i++)
		buf[i] = readl(&reg->crypto_hash_dout[i]);

	return 0;
}

#if CONFIG_IS_ENABLED(ROCKCHIP_RSA)
static int rockchip_crypto_rsa_verify(struct udevice *dev, rsa_key *ctx,
				      u8 *sign, u8 *output)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	struct rk_crypto_reg *reg = priv->reg;
	u32 nbits, *buf = (u32 *)output;
	int i, value;

	if (!ctx)
		return -EINVAL;

	if (ctx->algo == CRYPTO_RSA512)
		value = PKA_BLOCK_SIZE_512;
	else if (ctx->algo == CRYPTO_RSA1024)
		value = PKA_BLOCK_SIZE_1024;
	else if (ctx->algo == CRYPTO_RSA2048)
		value = PKA_BLOCK_SIZE_2048;
	else
		return -EINVAL;

	/* Specify the nbits of N in PKA calculation */
	writel(value, &reg->crypto_pka_ctrl);

	/* Flush SHA and RSA */
	rk_setreg(&reg->crypto_ctrl, PKA_HASH_CTRL);
	writel(0xffffffff, &reg->crypto_intsts);
	do {} while (readl(&reg->crypto_ctrl) & PKA_CTRL);

	/* Clean PKA done interrupt */
	writel(PKA_DONE_INT, &reg->crypto_intsts);

	/* Set m/n/e/c */
	nbits = crypto_algo_nbits(ctx->algo);
	memcpy((void *)&reg->crypto_pka_m, (void *)sign,   BITS2BYTE(nbits));
	memcpy((void *)&reg->crypto_pka_n, (void *)ctx->n, BITS2BYTE(nbits));
	memcpy((void *)&reg->crypto_pka_e, (void *)ctx->e, BITS2BYTE(nbits));
	memcpy((void *)&reg->crypto_pka_c, (void *)ctx->c, BITS2BYTE(nbits));
	do {} while (readl(&reg->crypto_ctrl) & PKA_START);

	/* Start PKA */
	rk_setreg(&reg->crypto_ctrl, PKA_START);

	/* Wait PKA done */
	do {} while (readl(&reg->crypto_ctrl) & PKA_START);

	/* Read hash data, per-data 32-bit */
	for (i = 0; i < BITS2WORD(nbits); i++)
		buf[i] = readl(&reg->crypto_pka_m[i]);

	return 0;
}
#else
static int rockchip_crypto_rsa_verify(struct udevice *dev, rsa_key *ctx,
				      u8 *sign, u8 *output)
{
	return -ENOSYS;
}
#endif
static const struct dm_crypto_ops rockchip_crypto_ops = {
	.capability = rockchip_crypto_capability,
	.sha_init   = rockchip_crypto_sha_init,
	.sha_update = rockchip_crypto_sha_update,
	.sha_final  = rockchip_crypto_sha_final,
	.rsa_verify = rockchip_crypto_rsa_verify,
};

/*
 * Only use "clocks" to parse crypto clock id and use rockchip_get_clk().
 * Because we always add crypto node in U-Boot dts, when kernel dtb enabled :
 *
 *   1. There is cru phandle mismatch between U-Boot and kernel dtb;
 *   2. CONFIG_OF_SPL_REMOVE_PROPS removes clock property;
 */
static int rockchip_crypto_ofdata_to_platdata(struct udevice *dev)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	int len;

	if (!dev_read_prop(dev, "clocks", &len)) {
		printf("Crypto-v1: can't find \"clocks\" property\n");
		return -EINVAL;
	}

	priv->clocks = malloc(len);
	if (!priv->clocks)
		return -ENOMEM;

	priv->nclocks = len / sizeof(u32);
	if (dev_read_u32_array(dev, "clocks", (u32 *)priv->clocks,
			       priv->nclocks)) {
		printf("Crypto-v1: can't read \"clocks\" property\n");
		return -EINVAL;
	}

	priv->reg = dev_read_addr_ptr(dev);
	priv->frequency = dev_read_u32_default(dev, "clock-frequency",
					       CRYPTO_V1_DEFAULT_RATE);

	return 0;
}

static int rockchip_crypto_probe(struct udevice *dev)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	u32 *clocks;
	int i, ret;

	ret = rockchip_get_clk(&priv->clk.dev);
	if (ret) {
		printf("Crypto-v1: failed to get clk device, ret=%d\n", ret);
		return ret;
	}

	clocks = (u32 *)priv->clocks;
	for (i = 1; i < priv->nclocks; i += 2) {
		priv->clk.id = clocks[i];
		ret = clk_set_rate(&priv->clk, priv->frequency);
		if (ret < 0) {
			printf("Crypto-v1: failed to set clk(%ld): ret=%d\n",
			       priv->clk.id, ret);
			return ret;
		}
	}

	return 0;
}

static const struct udevice_id rockchip_crypto_ids[] = {
	{ .compatible = "rockchip,rk3399-crypto" },
	{ .compatible = "rockchip,rk3368-crypto" },
	{ .compatible = "rockchip,rk3328-crypto" },
	{ .compatible = "rockchip,rk3288-crypto" },
	{ .compatible = "rockchip,rk322x-crypto" },
	{ .compatible = "rockchip,rk312x-crypto" },
	{ }
};

U_BOOT_DRIVER(rockchip_crypto_v1) = {
	.name		= "rockchip_crypto_v1",
	.id		= UCLASS_CRYPTO,
	.of_match	= rockchip_crypto_ids,
	.ops		= &rockchip_crypto_ops,
	.probe		= rockchip_crypto_probe,
	.ofdata_to_platdata = rockchip_crypto_ofdata_to_platdata,
	.priv_auto_alloc_size = sizeof(struct rockchip_crypto_priv),
};
