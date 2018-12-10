// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <config.h>
#include <common.h>
#include <dm.h>
#include <dm/device-internal.h>
#include <errno.h>
#include <rockchip_crypto/rockchip_crypto_hd.h>
#include <rockchip_crypto/rockchip_crypto.h>

int get_rk_crypto_desc(struct rk_crypto_desc *crypto_desc)
{
	int ret;

	ret = uclass_get_device_by_name(UCLASS_RKCRYPTO, "crypto",
					&crypto_desc->dev);
	if (ret) {
		printf("%s: Can not get crypto dev.\n", __func__);
		return ret;
	}

	crypto_desc->ops = crypto_get_ops(crypto_desc->dev);

	return 0;
}

int rk_crypto_sha_init(struct rk_crypto_desc *rk_crypto, u32 msg_len,
		       int hash_bits)
{
	return rk_crypto->ops->sha_init(rk_crypto->dev, msg_len, msg_len);
}

int rk_crypto_sha_byte_swap(struct rk_crypto_desc *rk_crypto, int en)
{
	return rk_crypto->ops->sha_byte_swap(rk_crypto->dev, en);
}

int rk_crypto_sha_start(struct rk_crypto_desc *rk_crypto, u32 *data,
			u32 data_len)
{
	return rk_crypto->ops->sha_start(rk_crypto->dev, data, data_len);
}

int rk_crypto_sha_end(struct rk_crypto_desc *rk_crypto, u32 *result)
{
	return rk_crypto->ops->sha_end(rk_crypto->dev, result);
}

int rk_crypto_sha_check(struct rk_crypto_desc *rk_crypto, u32 *in_hash)
{
	int ret;
	u32 data_hash[8];

	ret = rk_crypto_sha_end(rk_crypto, data_hash);
	if (ret)
		return -1;

	return memcmp(in_hash, data_hash, 32);
}

int rk_crypto_rsa_init(struct rk_crypto_desc *rk_crypto)
{
	return rk_crypto->ops->rsa_init(rk_crypto->dev);
}

int rk_crypto_rsa_start(struct rk_crypto_desc *rk_crypto,
			u32 *m, u32 *n, u32 *e, u32 *c)
{
	return rk_crypto->ops->rsa_start(rk_crypto->dev, m, n, e, c);
}

int rk_crypto_rsa_end(struct rk_crypto_desc *rk_crypto, u32 *result)
{
	return rk_crypto->ops->rsa_end(rk_crypto->dev, result);
}

int rk_crypto_rsa_check(struct rk_crypto_desc *rk_crypto)
{
	u32 datahash[8];
	u32 rsa_result[8];
	int ret = 0;

	ret = rk_crypto_sha_end(rk_crypto, datahash);
	if (ret)
		return ret;

	ret = rk_crypto_rsa_end(rk_crypto, rsa_result);
	if (ret)
		return ret;

	return memcmp(rsa_result, datahash, 32);
}

int rk_crypto_probe(void)
{
	int ret;
	struct udevice *dev;

	ret = uclass_get_device_by_name(UCLASS_RKCRYPTO, "crypto", &dev);
	if (ret) {
		printf("%s: Can not get crypto dev.\n", __func__);
		return -1;
	}

	ret = device_probe(dev);
	if (ret) {
		printf("%s: Crypto probe error.\n", __func__);
		return -1;
	}

	return 0;
}

UCLASS_DRIVER(crypto) = {
	.id		= UCLASS_RKCRYPTO,
	.name		= "crypto",
};
