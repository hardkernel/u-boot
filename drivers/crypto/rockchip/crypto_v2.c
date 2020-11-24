// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <clk.h>
#include <crypto.h>
#include <dm.h>
#include <asm/io.h>
#include <asm/arch/hardware.h>
#include <asm/arch/clock.h>
#include <rockchip/crypto_hash_cache.h>
#include <rockchip/crypto_v2.h>
#include <rockchip/crypto_v2_pka.h>

#define	RK_HASH_CTX_MAGIC		0x1A1A1A1A

#define CRYPTO_TRNG_MAX			32

enum endian_mode {
	BIG_ENDIAN = 0,
	LITTLE_ENDIAN
};

enum clk_type {
	CLK = 0,
	HCLK
};

struct crypto_lli_desc {
	u32 src_addr;
	u32 src_len;
	u32 dst_addr;
	u32 dst_len;
	u32 user_define;
	u32 reserve;
	u32 dma_ctrl;
	u32 next_addr;
};

struct rk_hash_ctx {
	struct crypto_lli_desc		data_lli;	/* lli desc */
	struct crypto_hash_cache	*hash_cache;
	u32				magic;		/* to check ctx */
	u32				algo;		/* hash algo */
	u8				digest_size;	/* hash out length */
	u8				reserved[3];
};

struct rockchip_crypto_priv {
	fdt_addr_t reg;
	struct clk clk;
	u32 frequency;
	char *clocks;
	u32 *frequencies;
	u32 nclocks;
	u32 length;
	struct rk_hash_ctx *hw_ctx;
};

#define LLI_ADDR_ALIGIN_SIZE	8
#define DATA_ADDR_ALIGIN_SIZE	8
#define DATA_LEN_ALIGIN_SIZE	64

/* crypto timeout 500ms, must support more than 32M data per times*/
#define HASH_UPDATE_LIMIT	(32 * 1024 * 1024)
#define RK_CRYPTO_TIME_OUT	500000

#define RK_WHILE_TIME_OUT(condition, timeout, ret) { \
			u32 time_out = timeout; \
			ret = 0; \
			while (condition) { \
				if (time_out-- == 0) { \
					debug("[%s] %d: time out!\n", __func__,\
						__LINE__); \
					ret = -ETIME; \
					break; \
				} \
				udelay(1); \
			} \
		} while (0)

typedef u32 paddr_t;
#define virt_to_phys(addr)		(((unsigned long)addr) & 0xffffffff)
#define phys_to_virt(addr, area)	((unsigned long)addr)

fdt_addr_t crypto_base;

static int hw_check_trng_exist(void)
{
	u32 tmp = 0, val = 0;

	tmp = crypto_read(CRYPTO_RNG_SAMPLE_CNT);
	crypto_write(50, CRYPTO_RNG_SAMPLE_CNT);

	val = crypto_read(CRYPTO_RNG_SAMPLE_CNT);
	crypto_write(tmp, CRYPTO_RNG_SAMPLE_CNT);

	return val;
}

static void word2byte(u32 word, u8 *ch, u32 endian)
{
	/* 0: Big-Endian 1: Little-Endian */
	if (endian == BIG_ENDIAN) {
		ch[0] = (word >> 24) & 0xff;
		ch[1] = (word >> 16) & 0xff;
		ch[2] = (word >> 8) & 0xff;
		ch[3] = (word >> 0) & 0xff;
	} else if (endian == LITTLE_ENDIAN) {
		ch[0] = (word >> 0) & 0xff;
		ch[1] = (word >> 8) & 0xff;
		ch[2] = (word >> 16) & 0xff;
		ch[3] = (word >> 24) & 0xff;
	} else {
		ch[0] = 0;
		ch[1] = 0;
		ch[2] = 0;
		ch[3] = 0;
	}
}

static inline void clear_hash_out_reg(void)
{
	int i;

	/*clear out register*/
	for (i = 0; i < 16; i++)
		crypto_write(0, CRYPTO_HASH_DOUT_0 + 4 * i);
}

static int hw_crypto_reset(void)
{
	u32 tmp = 0, tmp_mask = 0;
	int ret;

	tmp = CRYPTO_SW_PKA_RESET | CRYPTO_SW_CC_RESET;
	tmp_mask = tmp << CRYPTO_WRITE_MASK_SHIFT;

	/* reset pka and crypto modules*/
	crypto_write(tmp | tmp_mask, CRYPTO_RST_CTL);

	/* wait reset compelete */
	RK_WHILE_TIME_OUT(crypto_read(CRYPTO_RST_CTL),
			  RK_CRYPTO_TIME_OUT, ret);
	return ret;
}

static void hw_hash_clean_ctx(struct rk_hash_ctx *ctx)
{
	/* clear hash status */
	crypto_write(CRYPTO_WRITE_MASK_ALL | 0, CRYPTO_HASH_CTL);

	assert(ctx);
	assert(ctx->magic == RK_HASH_CTX_MAGIC);

	crypto_hash_cache_free(ctx->hash_cache);

	memset(ctx, 0x00, sizeof(*ctx));
}

static int rk_hash_init(void *hw_ctx, u32 algo)
{
	struct rk_hash_ctx *tmp_ctx = (struct rk_hash_ctx *)hw_ctx;
	u32 reg_ctrl = 0;
	int ret;

	if (!tmp_ctx)
		return -EINVAL;

	reg_ctrl = CRYPTO_SW_CC_RESET;
	crypto_write(reg_ctrl | (reg_ctrl << CRYPTO_WRITE_MASK_SHIFT),
		     CRYPTO_RST_CTL);

	/* wait reset compelete */
	RK_WHILE_TIME_OUT(crypto_read(CRYPTO_RST_CTL),
			  RK_CRYPTO_TIME_OUT, ret);

	reg_ctrl = 0;
	tmp_ctx->algo = algo;
	switch (algo) {
	case CRYPTO_MD5:
		reg_ctrl |= CRYPTO_MODE_MD5;
		tmp_ctx->digest_size = 16;
		break;
	case CRYPTO_SHA1:
		reg_ctrl |= CRYPTO_MODE_SHA1;
		tmp_ctx->digest_size = 20;
		break;
	case CRYPTO_SHA256:
		reg_ctrl |= CRYPTO_MODE_SHA256;
		tmp_ctx->digest_size = 32;
		break;
	case CRYPTO_SHA512:
		reg_ctrl |= CRYPTO_MODE_SHA512;
		tmp_ctx->digest_size = 64;
		break;

	default:
		ret = -EINVAL;
		goto exit;
	}

	clear_hash_out_reg();

	/* enable hardware padding */
	reg_ctrl |= CRYPTO_HW_PAD_ENABLE;
	crypto_write(reg_ctrl | CRYPTO_WRITE_MASK_ALL, CRYPTO_HASH_CTL);

	/* FIFO input and output data byte swap */
	/* such as B0, B1, B2, B3 -> B3, B2, B1, B0 */
	reg_ctrl = CRYPTO_DOUT_BYTESWAP | CRYPTO_DOIN_BYTESWAP;
	crypto_write(reg_ctrl | CRYPTO_WRITE_MASK_ALL, CRYPTO_FIFO_CTL);

	/* enable src_item_done interrupt */
	crypto_write(CRYPTO_SRC_ITEM_INT_EN, CRYPTO_DMA_INT_EN);

	tmp_ctx->magic = RK_HASH_CTX_MAGIC;

	return 0;
exit:
	/* clear hash setting if init failed */
	crypto_write(CRYPTO_WRITE_MASK_ALL | 0, CRYPTO_HASH_CTL);

	return ret;
}

static int rk_hash_direct_calc(void *hw_data, const u8 *data,
			       u32 data_len, u8 *started_flag, u8 is_last)
{
	struct rockchip_crypto_priv *priv = hw_data;
	struct rk_hash_ctx *hash_ctx = priv->hw_ctx;
	struct crypto_lli_desc *lli = &hash_ctx->data_lli;
	int ret = -EINVAL;
	u32 tmp = 0, mask = 0;

	assert(IS_ALIGNED((ulong)data, DATA_ADDR_ALIGIN_SIZE));
	assert(is_last || IS_ALIGNED(data_len, DATA_LEN_ALIGIN_SIZE));

	debug("%s: data = %p, len = %u, s = %x, l = %x\n",
	      __func__, data, data_len, *started_flag, is_last);

	memset(lli, 0x00, sizeof(*lli));
	lli->src_addr = (u32)virt_to_phys(data);
	lli->src_len = data_len;
	lli->dma_ctrl = LLI_DMA_CTRL_SRC_DONE;

	if (is_last) {
		lli->user_define |= LLI_USER_STRING_LAST;
		lli->dma_ctrl |= LLI_DMA_CTRL_LAST;
	} else {
		lli->next_addr = (u32)virt_to_phys(lli);
		lli->dma_ctrl |= LLI_DMA_CTRL_PAUSE;
	}

	if (!(*started_flag)) {
		lli->user_define |=
			(LLI_USER_STRING_START | LLI_USER_CPIHER_START);
		crypto_write((u32)virt_to_phys(lli), CRYPTO_DMA_LLI_ADDR);
		crypto_write((CRYPTO_HASH_ENABLE << CRYPTO_WRITE_MASK_SHIFT) |
			     CRYPTO_HASH_ENABLE, CRYPTO_HASH_CTL);
		tmp = CRYPTO_DMA_START;
		*started_flag = 1;
	} else {
		tmp = CRYPTO_DMA_RESTART;
	}

	/* flush cache */
	crypto_flush_cacheline((ulong)lli, sizeof(*lli));
	crypto_flush_cacheline((ulong)data, data_len);

	/* start calculate */
	crypto_write(tmp << CRYPTO_WRITE_MASK_SHIFT | tmp,
		     CRYPTO_DMA_CTL);

	/* mask CRYPTO_SYNC_LOCKSTEP_INT_ST flag */
	mask = ~(mask | CRYPTO_SYNC_LOCKSTEP_INT_ST);

	/* wait calc ok */
	RK_WHILE_TIME_OUT(!(crypto_read(CRYPTO_DMA_INT_ST) & mask),
			  RK_CRYPTO_TIME_OUT, ret);

	/* clear interrupt status */
	tmp = crypto_read(CRYPTO_DMA_INT_ST);
	crypto_write(tmp, CRYPTO_DMA_INT_ST);

	if (tmp != CRYPTO_SRC_ITEM_DONE_INT_ST &&
	    tmp != CRYPTO_ZERO_LEN_INT_ST) {
		debug("[%s] %d: CRYPTO_DMA_INT_ST = 0x%x\n",
		      __func__, __LINE__, tmp);
		goto exit;
	}

	priv->length += data_len;
exit:
	return ret;
}

int rk_hash_update(void *ctx, const u8 *data, u32 data_len)
{
	struct rk_hash_ctx *tmp_ctx = (struct rk_hash_ctx *)ctx;
	int ret = -EINVAL;

	debug("\n");
	if (!tmp_ctx || !data)
		goto exit;

	if (tmp_ctx->digest_size == 0 || tmp_ctx->magic != RK_HASH_CTX_MAGIC)
		goto exit;

	ret = crypto_hash_update_with_cache(tmp_ctx->hash_cache,
					    data, data_len);

exit:
	/* free lli list */
	if (ret)
		hw_hash_clean_ctx(tmp_ctx);

	return ret;
}

int rk_hash_final(void *ctx, u8 *digest, size_t len)
{
	struct rk_hash_ctx *tmp_ctx = (struct rk_hash_ctx *)ctx;
	int ret = -EINVAL;
	u32 i;

	if (!digest)
		goto exit;

	if (!tmp_ctx ||
	    tmp_ctx->digest_size == 0 ||
	    len > tmp_ctx->digest_size ||
	    tmp_ctx->magic != RK_HASH_CTX_MAGIC) {
		goto exit;
	}

	/* wait hash value ok */
	RK_WHILE_TIME_OUT(!crypto_read(CRYPTO_HASH_VALID),
			  RK_CRYPTO_TIME_OUT, ret);

	for (i = 0; i < len / 4; i++)
		word2byte(crypto_read(CRYPTO_HASH_DOUT_0 + i * 4),
			  digest + i * 4, BIG_ENDIAN);

	if (len % 4) {
		u8 tmp_buf[4];

		word2byte(crypto_read(CRYPTO_HASH_DOUT_0 + i * 4),
			  tmp_buf, BIG_ENDIAN);
		memcpy(digest + i * 4, tmp_buf, len % 4);
	}

	/* clear hash status */
	crypto_write(CRYPTO_HASH_IS_VALID, CRYPTO_HASH_VALID);
	crypto_write(CRYPTO_WRITE_MASK_ALL | 0, CRYPTO_HASH_CTL);

exit:

	return ret;
}

static int rk_trng(u8 *trng, u32 len)
{
	u32 i, reg_ctrl = 0;
	int ret = -EINVAL;
	u32 buf[8];

	if (len > CRYPTO_TRNG_MAX)
		return -EINVAL;

	memset(buf, 0, sizeof(buf));

	/* enable osc_ring to get entropy, sample period is set as 50 */
	crypto_write(50, CRYPTO_RNG_SAMPLE_CNT);

	reg_ctrl |= CRYPTO_RNG_256_bit_len;
	reg_ctrl |= CRYPTO_RNG_SLOWER_SOC_RING_1;
	reg_ctrl |= CRYPTO_RNG_ENABLE;
	reg_ctrl |= CRYPTO_RNG_START;
	reg_ctrl |= CRYPTO_WRITE_MASK_ALL;

	crypto_write(reg_ctrl | CRYPTO_WRITE_MASK_ALL, CRYPTO_RNG_CTL);
	RK_WHILE_TIME_OUT(crypto_read(CRYPTO_RNG_CTL) & CRYPTO_RNG_START,
			  RK_CRYPTO_TIME_OUT, ret);

	if (ret == 0) {
		for (i = 0; i < ARRAY_SIZE(buf); i++)
			buf[i] = crypto_read(CRYPTO_RNG_DOUT_0 + i * 4);
		memcpy(trng, buf, len);
	}

	/* close TRNG */
	crypto_write(0 | CRYPTO_WRITE_MASK_ALL, CRYPTO_RNG_CTL);

	return ret;
}

static u32 rockchip_crypto_capability(struct udevice *dev)
{
	u32 val = 0;

	val =  CRYPTO_MD5 |
	       CRYPTO_SHA1 |
	       CRYPTO_SHA256 |
#if !defined(CONFIG_ROCKCHIP_RK1808)
	       CRYPTO_SHA512 |
#endif
	       CRYPTO_RSA512 |
	       CRYPTO_RSA1024 |
	       CRYPTO_RSA2048 |
	       CRYPTO_RSA3072 |
	       CRYPTO_RSA4096;

	if (hw_check_trng_exist())
		val |= CRYPTO_TRNG;

	return val;
}

static int rockchip_crypto_sha_init(struct udevice *dev, sha_context *ctx)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	struct rk_hash_ctx *hash_ctx = priv->hw_ctx;

	if (!ctx)
		return -EINVAL;

	memset(hash_ctx, 0x00, sizeof(*hash_ctx));

	priv->length = 0;

	hash_ctx->hash_cache = crypto_hash_cache_alloc(rk_hash_direct_calc,
						       priv, ctx->length,
						       DATA_ADDR_ALIGIN_SIZE,
						       DATA_LEN_ALIGIN_SIZE);
	if (!hash_ctx->hash_cache)
		return -EFAULT;

	return rk_hash_init(hash_ctx, ctx->algo);
}

static int rockchip_crypto_sha_update(struct udevice *dev,
				      u32 *input, u32 len)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	int ret, i;
	u8 *p;

	if (!len)
		return -EINVAL;

	p = (u8 *)input;

	for (i = 0; i < len / HASH_UPDATE_LIMIT; i++, p += HASH_UPDATE_LIMIT) {
		ret = rk_hash_update(priv->hw_ctx, p, HASH_UPDATE_LIMIT);
		if (ret)
			goto exit;
	}

	if (len % HASH_UPDATE_LIMIT)
		ret = rk_hash_update(priv->hw_ctx, p, len % HASH_UPDATE_LIMIT);

exit:
	return ret;
}

static int rockchip_crypto_sha_final(struct udevice *dev,
				     sha_context *ctx, u8 *output)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	u32 nbits;
	int ret;

	nbits = crypto_algo_nbits(ctx->algo);

	if (priv->length != ctx->length) {
		printf("total length(0x%08x) != init length(0x%08x)!\n",
		       priv->length, ctx->length);
		ret = -EIO;
		goto exit;
	}

	ret = rk_hash_final(priv->hw_ctx, (u8 *)output, BITS2BYTE(nbits));

exit:
	hw_hash_clean_ctx(priv->hw_ctx);
	return ret;
}

#if CONFIG_IS_ENABLED(ROCKCHIP_RSA)
static int rockchip_crypto_rsa_verify(struct udevice *dev, rsa_key *ctx,
				      u8 *sign, u8 *output)
{
	struct mpa_num *mpa_m = NULL, *mpa_e = NULL, *mpa_n = NULL;
	struct mpa_num *mpa_c = NULL, *mpa_result = NULL;
	u32 n_bits, n_words;
	u32 *rsa_result;
	int ret;

	if (!ctx)
		return -EINVAL;

	if (ctx->algo != CRYPTO_RSA512 &&
	    ctx->algo != CRYPTO_RSA1024 &&
	    ctx->algo != CRYPTO_RSA2048 &&
	    ctx->algo != CRYPTO_RSA3072 &&
	    ctx->algo != CRYPTO_RSA4096)
		return -EINVAL;

	n_bits = crypto_algo_nbits(ctx->algo);
	n_words = BITS2WORD(n_bits);

	rsa_result = malloc(BITS2BYTE(n_bits));
	if (!rsa_result)
		return -ENOMEM;

	memset(rsa_result, 0x00, BITS2BYTE(n_bits));

	ret = rk_mpa_alloc(&mpa_m);
	ret |= rk_mpa_alloc(&mpa_e);
	ret |= rk_mpa_alloc(&mpa_n);
	ret |= rk_mpa_alloc(&mpa_c);
	ret |= rk_mpa_alloc(&mpa_result);
	if (ret)
		goto exit;

	mpa_m->d = (void *)sign;
	mpa_e->d = (void *)ctx->e;
	mpa_n->d = (void *)ctx->n;
	mpa_c->d = (void *)ctx->c;
	mpa_result->d = (void *)rsa_result;

	mpa_m->size = n_words;
	mpa_e->size = n_words;
	mpa_n->size = n_words;
	mpa_c->size = n_words;
	mpa_result->size = n_words;

	ret = rk_exptmod_np(mpa_m, mpa_e, mpa_n, mpa_c, mpa_result);
	if (!ret)
		memcpy(output, rsa_result, BITS2BYTE(n_bits));

exit:
	free(rsa_result);
	rk_mpa_free(&mpa_m);
	rk_mpa_free(&mpa_e);
	rk_mpa_free(&mpa_n);
	rk_mpa_free(&mpa_c);
	rk_mpa_free(&mpa_result);

	return ret;
}
#else
static int rockchip_crypto_rsa_verify(struct udevice *dev, rsa_key *ctx,
				      u8 *sign, u8 *output)
{
	return -ENOSYS;
}
#endif

static int rockchip_crypto_get_trng(struct udevice *dev, u8 *output, u32 len)
{
	int ret;
	u32 i;

	if (!dev || !output || !len)
		return -EINVAL;

	for (i = 0; i < len / CRYPTO_TRNG_MAX; i++) {
		ret = rk_trng(output + i * CRYPTO_TRNG_MAX, CRYPTO_TRNG_MAX);
		if (ret)
			goto fail;
	}

	ret = rk_trng(output + i * CRYPTO_TRNG_MAX, len % CRYPTO_TRNG_MAX);

fail:
	return ret;
}

static const struct dm_crypto_ops rockchip_crypto_ops = {
	.capability = rockchip_crypto_capability,
	.sha_init   = rockchip_crypto_sha_init,
	.sha_update = rockchip_crypto_sha_update,
	.sha_final  = rockchip_crypto_sha_final,
	.rsa_verify = rockchip_crypto_rsa_verify,
	.get_trng = rockchip_crypto_get_trng,
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
	int len, ret = -EINVAL;

	if (!dev_read_prop(dev, "clocks", &len)) {
		printf("Can't find \"clocks\" property\n");
		return -EINVAL;
	}

	memset(priv, 0x00, sizeof(*priv));
	priv->clocks = malloc(len);
	if (!priv->clocks)
		return -ENOMEM;

	priv->nclocks = len / sizeof(u32);
	if (dev_read_u32_array(dev, "clocks", (u32 *)priv->clocks,
			       priv->nclocks)) {
		printf("Can't read \"clocks\" property\n");
		ret = -EINVAL;
		goto exit;
	}

	if (!dev_read_prop(dev, "clock-frequency", &len)) {
		printf("Can't find \"clock-frequency\" property\n");
		ret = -EINVAL;
		goto exit;
	}

	priv->frequencies = malloc(len);
	if (!priv->frequencies) {
		ret = -ENOMEM;
		goto exit;
	}

	priv->nclocks = len / sizeof(u32);
	if (dev_read_u32_array(dev, "clock-frequency", priv->frequencies,
			       priv->nclocks)) {
		printf("Can't read \"clock-frequency\" property\n");
		ret = -EINVAL;
		goto exit;
	}

	priv->reg = (fdt_addr_t)dev_read_addr_ptr(dev);

	crypto_base = priv->reg;

	return 0;
exit:
	if (priv->clocks)
		free(priv->clocks);

	if (priv->frequencies)
		free(priv->frequencies);

	return ret;
}

static int rockchip_crypto_probe(struct udevice *dev)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	int i, ret = 0;
	u32* clocks;

	priv->hw_ctx = memalign(LLI_ADDR_ALIGIN_SIZE,
				sizeof(struct rk_hash_ctx));
	if (!priv->hw_ctx)
		return -ENOMEM;

	ret = rockchip_get_clk(&priv->clk.dev);
	if (ret) {
		printf("Failed to get clk device, ret=%d\n", ret);
		return ret;
	}

	clocks = (u32 *)priv->clocks;
	for (i = 0; i < priv->nclocks; i++) {
		priv->clk.id = clocks[i * 2 + 1];
		ret = clk_set_rate(&priv->clk, priv->frequencies[i]);
		if (ret < 0) {
			printf("%s: Failed to set clk(%ld): ret=%d\n",
			       __func__, priv->clk.id, ret);
			return ret;
		}
	}

	hw_crypto_reset();

	return 0;
}

static const struct udevice_id rockchip_crypto_ids[] = {
	{ .compatible = "rockchip,px30-crypto" },
	{ .compatible = "rockchip,rk1808-crypto" },
	{ .compatible = "rockchip,rk3308-crypto" },
	{ .compatible = "rockchip,rv1126-crypto" },
	{ .compatible = "rockchip,rk3568-crypto" },
	{ }
};

U_BOOT_DRIVER(rockchip_crypto_v2) = {
	.name		= "rockchip_crypto_v2",
	.id		= UCLASS_CRYPTO,
	.of_match	= rockchip_crypto_ids,
	.ops		= &rockchip_crypto_ops,
	.probe		= rockchip_crypto_probe,
	.ofdata_to_platdata = rockchip_crypto_ofdata_to_platdata,
	.priv_auto_alloc_size = sizeof(struct rockchip_crypto_priv),
};
