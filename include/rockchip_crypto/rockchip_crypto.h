/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _ROCKCHIP_CRYPTO_H_
#define _ROCKCHIP_CRYPTO_H_

#define crypto_get_ops(dev)	((struct dm_rk_crypto_ops *)(dev)->driver->ops)

struct rk_crypto_desc {
	struct udevice *dev;
	struct dm_rk_crypto_ops *ops;
};

int get_rk_crypto_desc(struct rk_crypto_desc *crypto_desc);
int rk_crypto_sha_init(struct rk_crypto_desc *rk_crypto, u32 msg_len,
		       int hash_bits);
int rk_crypto_sha_byte_swap(struct rk_crypto_desc *rk_crypto, int en);
int rk_crypto_sha_start(struct rk_crypto_desc *rk_crypto, u32 *data,
			u32 data_len);
int rk_crypto_sha_end(struct rk_crypto_desc *rk_crypto, u32 *result);
int rk_crypto_sha_check(struct rk_crypto_desc *rk_crypto, u32 *in_hash);
int rk_crypto_rsa_init(struct rk_crypto_desc *rk_crypto);
int rk_crypto_rsa_start(struct rk_crypto_desc *rk_crypto, u32 *m,
			u32 *n, u32 *e, u32 *c);
int rk_crypto_rsa_end(struct rk_crypto_desc *rk_crypto, u32 *result);
int rk_crypto_rsa_check(struct rk_crypto_desc *rk_crypto);
int rk_crypto_probe(void);

#endif
