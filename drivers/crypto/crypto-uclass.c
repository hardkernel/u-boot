// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <crypto.h>
#include <dm.h>
#include <u-boot/sha1.h>

u32 crypto_algo_nbits(u32 algo)
{
	switch (algo) {
	case CRYPTO_MD5:
		return 128;
	case CRYPTO_SHA1:
		return 160;
	case CRYPTO_SHA256:
		return 256;
	case CRYPTO_RSA512:
		return 512;
	case CRYPTO_RSA1024:
		return 1024;
	case CRYPTO_RSA2048:
		return 2048;
	}

	printf("Unknown crypto algorithm: 0x%x\n", algo);

	return 0;
}

struct udevice *crypto_get_device(u32 capability)
{
	const struct dm_crypto_ops *ops;
	struct udevice *dev;
	struct uclass *uc;
	int ret;
	u32 cap;

	ret = uclass_get(UCLASS_CRYPTO, &uc);
	if (ret)
		return NULL;

	for (uclass_first_device(UCLASS_CRYPTO, &dev);
	     dev;
	     uclass_next_device(&dev)) {
		ops = device_get_ops(dev);
		if (!ops || !ops->capability)
			continue;

		cap = ops->capability(dev);
		if ((cap & capability) == capability)
			return dev;
	}

	return NULL;
}

int crypto_sha_init(struct udevice *dev, sha_context *ctx)
{
	const struct dm_crypto_ops *ops = device_get_ops(dev);

	if (!ops || !ops->sha_init)
		return -ENOSYS;

	return ops->sha_init(dev, ctx);
}

int crypto_sha_update(struct udevice *dev, u32 *input, u32 len)
{
	const struct dm_crypto_ops *ops = device_get_ops(dev);

	if (!ops || !ops->sha_update)
		return -ENOSYS;

	return ops->sha_update(dev, input, len);
}

int crypto_sha_final(struct udevice *dev, sha_context *ctx, u8 *output)
{
	const struct dm_crypto_ops *ops = device_get_ops(dev);

	if (!ops || !ops->sha_final)
		return -ENOSYS;

	return ops->sha_final(dev, ctx, output);
}

int crypto_sha_csum(struct udevice *dev, sha_context *ctx,
		    char *input, u32 input_len, u8 *output)
{
	int ret;

	ret = crypto_sha_init(dev, ctx);
	if (ret)
		return ret;

	ret = crypto_sha_update(dev, (u32 *)input, input_len);
	if (ret)
		return ret;

	ret = crypto_sha_final(dev, ctx, output);

	return ret;
}

int crypto_rsa_verify(struct udevice *dev, rsa_key *ctx, u8 *sign, u8 *output)
{
	const struct dm_crypto_ops *ops = device_get_ops(dev);

	if (!ops || !ops->rsa_verify)
		return -ENOSYS;

	return ops->rsa_verify(dev, ctx, sign, output);
}

UCLASS_DRIVER(crypto) = {
	.id	= UCLASS_CRYPTO,
	.name	= "crypto",
};
