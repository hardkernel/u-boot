/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _CORE_CRYPTO_H_
#define _CORE_CRYPTO_H_

#include <common.h>
#include <dm.h>
#include <image.h>
#include <u-boot/sha1.h>

/* Algorithms/capability of crypto, works together with crypto_algo_nbits() */
#define CRYPTO_MD5		BIT(0)
#define CRYPTO_SHA1		BIT(1)
#define CRYPTO_SHA256		BIT(2)
#define CRYPTO_SHA512		BIT(3)

#define CRYPTO_RSA512		BIT(10)
#define CRYPTO_RSA1024		BIT(11)
#define CRYPTO_RSA2048		BIT(12)
#define CRYPTO_RSA3072		BIT(13)
#define CRYPTO_RSA4096		BIT(14)

#define CRYPTO_TRNG		BIT(15)

#define BYTE2WORD(bytes)	((bytes) / 4)
#define BITS2BYTE(nbits)	((nbits) / 8)
#define BITS2WORD(nbits)	((nbits) / 32)

typedef struct {
	u32 algo;	/* Algorithm: CRYPTO_MD5/CRYPTO_SHA1/CRYPTO_RSA2048... */
	u32 length;	/* Data total length */

} sha_context;

typedef struct {
	u32 algo;	/* Algorithm: CRYPTO_MD5/CRYPTO_SHA1/CRYPTO_RSA2048... */
	u32 *n;		/* Public key factor N */
	u32 *e;		/* Public key factor E */
	u32 *c;		/* Optional, a accelerate factor for some crypto */
} rsa_key;

struct dm_crypto_ops {
	/* Hardware algorithm capability */
	u32 (*capability)(struct udevice *dev);

	/* SHA init/update/final */
	int (*sha_init)(struct udevice *dev, sha_context *ctx);
	int (*sha_update)(struct udevice *dev, u32 *input, u32 len);
	int (*sha_final)(struct udevice *dev, sha_context *ctx, u8 *output);

	/* RSA verify */
	int (*rsa_verify)(struct udevice *dev, rsa_key *ctx,
			  u8 *sign, u8 *output);

	/* TRNG get */
	int (*get_trng)(struct udevice *dev, u8 *output, u32 len);
};

/**
 * crypto_algo_nbits() - Get algorithm bits accroding to algorithm
 * @capability: expected algorithm capability, eg. CRYPTO_MD5/RSA2048...
 *
 * @return algorithm bits
 */
u32 crypto_algo_nbits(u32 algo);

/**
 * crypto_get_device() - Get crypto device by capability
 * @capability: expected algorithm capability, eg. CRYPTO_MD5/RSA2048...
 *
 * @return dev on success, otherwise NULL
 */
struct udevice *crypto_get_device(u32 capability);

/**
 * crypto_sha_init() - Crypto sha init
 *
 * @dev: crypto device
 * @ctx: sha context
 *
 * @return 0 on success, otherwise failed
 */
int crypto_sha_init(struct udevice *dev, sha_context *ctx);

/**
 * crypto_sha_update() - Crypto sha update
 *
 * @dev: crypto device
 * @input: input data buffer
 * @len: input data length
 *
 * @return 0 on success, otherwise failed
 */
int crypto_sha_update(struct udevice *dev, u32 *input, u32 len);

/**
 * crypto_sha_final() - Crypto sha finish and get result
 *
 * @dev: crypto device
 * @ctx: sha context
 * @output: output hash data
 *
 * @return 0 on success, otherwise failed
 */
int crypto_sha_final(struct udevice *dev, sha_context *ctx, u8 *output);

/**
 * crypto_sha_csum() - Crypto sha hash for one data block only
 *
 * @dev: crypto device
 * @ctx: sha context
 * @input: input data buffer
 * @input_len: input data length
 * @output: output hash data
 *
 * @return 0 on success, otherwise failed
 */
int crypto_sha_csum(struct udevice *dev, sha_context *ctx,
		    char *input, u32 input_len, u8 *output);

/**
 * crypto_sha_regions_csum() - Crypto sha hash for multi data blocks
 *
 * @dev: crypto device
 * @ctx: sha context
 * @region: regions buffer
 * @region_count: regions count
 * @output: output hash data
 *
 * @return 0 on success, otherwise failed
 */
int crypto_sha_regions_csum(struct udevice *dev, sha_context *ctx,
			    const struct image_region region[],
			    int region_count, u8 *output);

/**
 * crypto_rsa_verify() - Crypto rsa verify
 *
 * @dev: crypto device
 * @ctx: rsa key context
 * @sign: signature
 * @output: output hash data buffer
 *
 * @return 0 on success, otherwise failed
 */
int crypto_rsa_verify(struct udevice *dev, rsa_key *ctx, u8 *sign, u8 *output);

/**
 * crypto_get_trng() - Crypto get trng
 *
 * @dev: crypto device
 * @output: output trng data
 * @len: trng len to get
 *
 * @return 0 on success, otherwise failed
 */
int crypto_get_trng(struct udevice *dev, u8 *output, u32 len);

#endif
