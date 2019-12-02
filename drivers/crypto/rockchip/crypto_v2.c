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
#include <rockchip/crypto_v2.h>
#include <rockchip/crypto_v2_pka.h>

struct rockchip_crypto_priv {
	fdt_addr_t reg;
	struct clk clk;
	u32 frequency;
	char *clocks;
	u32 *frequencies;
	u32 nclocks;
	u32 length;
	void *hw_ctx;
};

#define LLI_ADDR_ALIGIN_SIZE	8
#define DATA_ADDR_ALIGIN_SIZE	8
#define RK_CRYPTO_TIME_OUT	50000  /* max 50ms */

#define RK_WHILE_TIME_OUT(condition, timeout, ret) { \
			u32 time_out = timeout; \
			while (condition) { \
				if (time_out-- == 0) { \
					printf("[%s] %d: time out!", __func__, \
						__LINE__); \
					ret = -ETIME; \
					break; \
				} \
				udelay(1); \
			} \
			ret = 0; \
		} while (0)

typedef u32 paddr_t;
#define virt_to_phys(addr)		(((unsigned long)addr) & 0xffffffff)
#define phys_to_virt(addr, area)	((unsigned long)addr)

static const u8 null_hash_sha1_value[] = {
	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
	0xaf, 0xd8, 0x07, 0x09
};

static const u8 null_hash_md5_value[] = {
	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
	0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e
};

static const u8 null_hash_sha256_value[] = {
	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
	0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
	0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
	0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55
};

static const u8 null_hash_sha512_value[] = {
	0xcf, 0x83, 0xe1, 0x35, 0x7e, 0xef, 0xb8, 0xbd,
	0xf1, 0x54, 0x28, 0x50, 0xd6, 0x6d, 0x80, 0x07,
	0xd6, 0x20, 0xe4, 0x05, 0x0b, 0x57, 0x15, 0xdc,
	0x83, 0xf4, 0xa9, 0x21, 0xd3, 0x6c, 0xe9, 0xce,
	0x47, 0xd0, 0xd1, 0x3c, 0x5d, 0x85, 0xf2, 0xb0,
	0xff, 0x83, 0x18, 0xd2, 0x87, 0x7e, 0xec, 0x2f,
	0x63, 0xb9, 0x31, 0xbd, 0x47, 0x41, 0x7a, 0x81,
	0xa5, 0x38, 0x32, 0x7a, 0xf9, 0x27, 0xda, 0x3e
};

fdt_addr_t crypto_base;

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

static void hw_hash_common_clean_ctx(struct rk_hash_ctx *ctx)
{
	crypto_write(CRYPTO_WRITE_MASK_ALL | 0, CRYPTO_HASH_CTL);

	if (ctx->free_data_lli)
		free(ctx->free_data_lli);

	if (ctx->cur_data_lli)
		free(ctx->cur_data_lli);

	if (ctx->vir_src_addr)
		free(ctx->vir_src_addr);
	memset(ctx, 0x00, sizeof(*ctx));
}

static void hw_hash_clean_ctx(struct rk_hash_ctx *ctx)
{
	/* clear hash status */
	crypto_write(CRYPTO_WRITE_MASK_ALL | 0, CRYPTO_HASH_CTL);

	/* free tmp buff */
	if (ctx && ctx->magic == RK_HASH_CTX_MAGIC)
		hw_hash_common_clean_ctx(ctx);
}

int rk_hash_init(void *hw_ctx, u32 algo)
{
	struct rk_hash_ctx *tmp_ctx = (struct rk_hash_ctx *)hw_ctx;
	u32 reg_ctrl = 0;
	int ret;

	if (!tmp_ctx)
		return -EINVAL;

	memset(tmp_ctx, 0x00, sizeof(*tmp_ctx));

	tmp_ctx->algo = algo;
	switch (algo) {
	case CRYPTO_MD5:
		reg_ctrl |= CRYPTO_MODE_MD5;
		tmp_ctx->digest_size = 16;
		tmp_ctx->null_hash = null_hash_md5_value;
		break;
	case CRYPTO_SHA1:
		reg_ctrl |= CRYPTO_MODE_SHA1;
		tmp_ctx->digest_size = 20;
		tmp_ctx->null_hash = null_hash_sha1_value;
		break;
	case CRYPTO_SHA256:
		reg_ctrl |= CRYPTO_MODE_SHA256;
		tmp_ctx->digest_size = 32;
		tmp_ctx->null_hash = null_hash_sha256_value;
		break;
	case CRYPTO_SHA512:
		reg_ctrl |= CRYPTO_MODE_SHA512;
		tmp_ctx->digest_size = 64;
		tmp_ctx->null_hash = null_hash_sha512_value;
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

	/* disable all interrupt */
	crypto_write(0x0, CRYPTO_DMA_INT_EN);

	tmp_ctx->magic = RK_HASH_CTX_MAGIC;

	return 0;
exit:
	/* clear hash setting if init failed */
	crypto_write(CRYPTO_WRITE_MASK_ALL | 0, CRYPTO_HASH_CTL);

	return ret;
}

int rk_hash_update(void *ctx, const u8 *data, u32 data_len)
{
	struct rk_hash_ctx *tmp_ctx = (struct rk_hash_ctx *)ctx;
	struct crypto_lli_desc *free_lli_desp = NULL;
	struct crypto_lli_desc *lli_desp = NULL;
	u32 tmp, temp_data_len = 0;
	u8 *vir_src_addr = NULL;
	int ret = -EINVAL;

	if (!tmp_ctx || !data)
		goto error;

	if (tmp_ctx->digest_size == 0 || tmp_ctx->magic != RK_HASH_CTX_MAGIC)
		goto error;

	/* update will keep cache one calculate request in memmory */
	/* because last calculate request should calculate in final */
	if (!tmp_ctx->cur_data_lli) {
		lli_desp = (struct crypto_lli_desc *)
				memalign(DATA_ADDR_ALIGIN_SIZE,
					 sizeof(struct crypto_lli_desc));
		if (!lli_desp)
			goto error;

		free_lli_desp = (struct crypto_lli_desc *)
				memalign(DATA_ADDR_ALIGIN_SIZE,
					 sizeof(struct crypto_lli_desc));
		if (!free_lli_desp) {
			free(lli_desp);
			goto error;
		}

		memset(lli_desp, 0x00, sizeof(*lli_desp));
		vir_src_addr = (u8 *)memalign(DATA_ADDR_ALIGIN_SIZE,
						HASH_MAX_SIZE);
		if (!vir_src_addr) {
			free(lli_desp);
			free(free_lli_desp);
			printf("[%s] %d: memalign fail!", __func__, __LINE__);
			goto error;
		}

		lli_desp->src_addr = (u32)virt_to_phys(vir_src_addr);
		lli_desp->user_define = LLI_USER_CPIHER_START |
					LLI_USER_STRING_START;
		tmp_ctx->cur_data_lli = lli_desp;
		tmp_ctx->free_data_lli = free_lli_desp;
		tmp_ctx->vir_src_addr = vir_src_addr;

		/* write first lli dma address to reg */
		crypto_write((u32)virt_to_phys(tmp_ctx->cur_data_lli),
			     CRYPTO_DMA_LLI_ADDR);
	}

	ret = 0;
	while (data_len) {
		lli_desp = (struct crypto_lli_desc *)tmp_ctx->cur_data_lli;
		vir_src_addr = (u8 *)phys_to_virt((paddr_t)lli_desp->src_addr,
						MEM_AREA_TEE_RAM);
		if (data_len + lli_desp->src_len > HASH_MAX_SIZE) {
			temp_data_len = HASH_MAX_SIZE - lli_desp->src_len;
			memcpy(vir_src_addr + lli_desp->src_len, data,
			       temp_data_len);
			data_len -= temp_data_len;
			data += temp_data_len;

			free_lli_desp = tmp_ctx->free_data_lli;

			memset(free_lli_desp, 0x00, sizeof(*free_lli_desp));
			lli_desp->src_len = HASH_MAX_SIZE;
			lli_desp->next_addr = (u32)virt_to_phys(free_lli_desp);
			/* item done and  pause */
			lli_desp->dma_ctrl = LLI_DMA_CTRL_PAUSE |
					     LLI_DMA_CTRL_SRC_DONE;

			if (tmp_ctx->dma_started == 0) {
				/* start calculate */
				crypto_write((CRYPTO_HASH_ENABLE <<
						CRYPTO_WRITE_MASK_SHIFT) |
						CRYPTO_HASH_ENABLE,
						CRYPTO_HASH_CTL);
				tmp = CRYPTO_DMA_START;
				tmp_ctx->dma_started = 1;
			} else {
				/* restart calculate */
				tmp = CRYPTO_DMA_RESTART;
			}

			/* flush cache */
			cache_op_inner(DCACHE_AREA_CLEAN, lli_desp,
				       sizeof(*lli_desp));
			cache_op_inner(DCACHE_AREA_CLEAN, vir_src_addr,
				       lli_desp->src_len);

			/* start calculate */
			crypto_write(tmp << CRYPTO_WRITE_MASK_SHIFT | tmp,
				     CRYPTO_DMA_CTL);

			/* wait calc ok */
			RK_WHILE_TIME_OUT(!crypto_read(CRYPTO_DMA_INT_ST),
					  RK_CRYPTO_TIME_OUT, ret);

			/* clear interrupt status */
			tmp = crypto_read(CRYPTO_DMA_INT_ST);
			crypto_write(tmp, CRYPTO_DMA_INT_ST);

			if (tmp != CRYPTO_SRC_ITEM_DONE_INT_ST &&
			    tmp != CRYPTO_ZERO_LEN_INT_ST) {
				printf("[%s] %d: CRYPTO_DMA_INT_ST = 0x%x",
				       __func__, __LINE__, tmp);
				goto error;
			}

			/* after calc one block, swap free lli and cur lli */
			free_lli_desp->src_addr = lli_desp->src_addr;
			tmp_ctx->free_data_lli = tmp_ctx->cur_data_lli;
			tmp_ctx->cur_data_lli = free_lli_desp;
			free_lli_desp = NULL;
		} else {
			/* cache first calculate request to buff */
			memcpy(vir_src_addr + lli_desp->src_len,
			       data, data_len);
			lli_desp->src_len += data_len;
			data_len = 0;
		}
	}

	return ret;

error:
	/* free lli list */
	hw_hash_clean_ctx(tmp_ctx);

	return ret;
}

int rk_hash_final(void *ctx, u8 *digest, size_t len)
{
	struct rk_hash_ctx *tmp_ctx = (struct rk_hash_ctx *)ctx;
	struct crypto_lli_desc *lli_desp = NULL;
	int ret = -EINVAL;
	u32 i, tmp;

	if (!digest)
		goto exit;

	if (!tmp_ctx ||
	    !tmp_ctx->cur_data_lli ||
	    tmp_ctx->digest_size == 0 ||
	    len > tmp_ctx->digest_size ||
	    tmp_ctx->magic != RK_HASH_CTX_MAGIC) {
		goto exit;
	}

	/* to find the last block */
	lli_desp = (struct crypto_lli_desc *)tmp_ctx->cur_data_lli;
	if (lli_desp->next_addr != 0)
		goto exit;

	/* if data len is zero, return null hash value immediately*/
	if (tmp_ctx->dma_started == 0 &&
	    lli_desp->src_len == 0 &&
	    !tmp_ctx->null_hash) {
		memcpy(digest, tmp_ctx->null_hash, len);
		ret = 0;
		goto exit;
	}

	/* set LLI_USER_STRING_LAST to tell crypto this block is last one */
	lli_desp->user_define |= LLI_USER_STRING_LAST;
	lli_desp->dma_ctrl = LLI_DMA_CTRL_LIST_DONE | LLI_DMA_CTRL_LAST;
	cache_op_inner(DCACHE_AREA_CLEAN, lli_desp, sizeof(*lli_desp));
	cache_op_inner(DCACHE_AREA_CLEAN, tmp_ctx->vir_src_addr,
		       lli_desp->src_len);

	if (tmp_ctx->dma_started == 0) {
		crypto_write((CRYPTO_HASH_ENABLE << CRYPTO_WRITE_MASK_SHIFT) |
				CRYPTO_HASH_ENABLE, CRYPTO_HASH_CTL);
		crypto_write((CRYPTO_DMA_START << CRYPTO_WRITE_MASK_SHIFT) |
				CRYPTO_DMA_START, CRYPTO_DMA_CTL);
	} else {
		crypto_write((CRYPTO_DMA_RESTART << CRYPTO_WRITE_MASK_SHIFT) |
				CRYPTO_DMA_RESTART, CRYPTO_DMA_CTL);
		tmp_ctx->dma_started = 1;
	}

	/* wait dma trans ok */
	RK_WHILE_TIME_OUT(!crypto_read(CRYPTO_DMA_INT_ST),
			  RK_CRYPTO_TIME_OUT, ret);

	/* clear interrupt status */
	tmp = crypto_read(CRYPTO_DMA_INT_ST);
	crypto_write(tmp, CRYPTO_DMA_INT_ST);

	if (tmp != CRYPTO_LIST_DONE_INT_ST) {
		ret = -EIO;
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
	/* free lli list */
	hw_hash_clean_ctx(tmp_ctx);

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
	return CRYPTO_MD5 |
	       CRYPTO_SHA1 |
	       CRYPTO_SHA256 |
#if !defined(CONFIG_ROCKCHIP_RK1808)
	       CRYPTO_SHA512 |
#endif
	       CRYPTO_RSA512 |
	       CRYPTO_RSA1024 |
	       CRYPTO_RSA2048 |
	       CRYPTO_RSA3072 |
	       CRYPTO_RSA4096 |
	       CRYPTO_TRNG;
}

static int rockchip_crypto_sha_init(struct udevice *dev, sha_context *ctx)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);

	if (!ctx)
		return -EINVAL;

	priv->hw_ctx = malloc(sizeof(struct rk_hash_ctx));
	if (!priv->hw_ctx)
		return -ENOMEM;

	memset(priv->hw_ctx, 0x00, sizeof(struct rk_hash_ctx));

	return rk_hash_init(priv->hw_ctx, ctx->algo);
}

static int rockchip_crypto_sha_update(struct udevice *dev,
				      u32 *input, u32 len)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);

	if (!len)
		return -EINVAL;

	return rk_hash_update(priv->hw_ctx, (u8 *)input, len);
}

static int rockchip_crypto_sha_final(struct udevice *dev,
				     sha_context *ctx, u8 *output)
{
	struct rockchip_crypto_priv *priv = dev_get_priv(dev);
	u32 nbits;
	int ret;

	nbits = crypto_algo_nbits(ctx->algo);

	ret = rk_hash_final(priv->hw_ctx, (u8 *)output, BITS2BYTE(nbits));
	if (priv->hw_ctx) {
		free(priv->hw_ctx);
		priv->hw_ctx = 0;
	}

	return ret;
}

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
