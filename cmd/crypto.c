// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <command.h>
#include <crypto.h>
#include <dm.h>
#include <u-boot/md5.h>
#include <u-boot/sha1.h>
#include <u-boot/sha256.h>
#include <u-boot/sha512.h>
#include <rockchip/crypto_fix_test_data.h>

struct hash_test_data {
	const char	*algo_name;
	const char	*mode_name;
	u32		algo;
	const u8	*data;
	u32		data_len;
	const u8	*hash;
	u32		hash_len;
	const u8	*key;
	u32		key_len;
};

struct cipher_test_data {
	const char	*algo_name;
	const char	*mode_name;
	u32		algo;
	u32		mode;
	const u8	*key;
	const u8	*twk_key;
	u32		key_len;
	const u8	*iv;
	u32		iv_len;
	const u8	*plain;
	u32		plain_len;
	const u8	*cipher;
	u32		cipher_len;
};

struct rsa_test_data {
	const char	*algo_name;
	const char	*mode_name;
	u32		algo;
	const u8	*n;
	u32		n_len;
	const u8	*e;
	u32		e_len;
	const u8	*d;
	u32		d_len;
	const u8	*c;
	u32		c_len;
	const u8	*sign_in;
	u32		sign_in_len;
	const u8	*sign_out;
	u32		sign_out_len;
};

#define HASH_TEST(algo_type, data_in, hash_val) {\
	.algo_name = "HASH", \
	.mode_name = #algo_type, \
	.algo      = CRYPTO_##algo_type, \
	.data      = (data_in),\
	.data_len  = sizeof(data_in), \
	.hash      = (hash_val), \
	.hash_len  = sizeof(hash_val) \
}

#define HMAC_TEST(algo_type, data_in, hash_val, hmac_key) {\
	.algo_name = "HMAC", \
	.mode_name = #algo_type, \
	.algo      = CRYPTO_HMAC_##algo_type, \
	.data      = (data_in),\
	.data_len  = sizeof(data_in), \
	.hash      = (hash_val), \
	.hash_len  = sizeof(hash_val), \
	.key       = (hmac_key), \
	.key_len   = sizeof(hmac_key)\
}

#define CIPHER_XTS_TEST(algo_type, mode_type, key1, key2, iv_val, in, out) { \
	.algo_name  = #algo_type, \
	.mode_name  = #mode_type, \
	.algo       = CRYPTO_##algo_type,\
	.mode       = RK_MODE_##mode_type, \
	.key        = (key1), \
	.twk_key    = (key2), \
	.key_len    = sizeof(key1), \
	.iv         = (iv_val), \
	.iv_len     = sizeof(iv_val), \
	.plain      = (in), \
	.plain_len  = sizeof(in), \
	.cipher     = (out), \
	.cipher_len = sizeof(out) \
}

#define CIPHER_TEST(algo, mode, key, iv, plain, cipher) \
		CIPHER_XTS_TEST(algo, mode, key, NULL, iv, plain, cipher)

#define RSA_TEST(nbits, bn, be, bc, bd, in, out) { \
	.algo_name    = "RSA", \
	.mode_name    = #nbits, \
	.algo         = CRYPTO_RSA##nbits, \
	.n            = (bn), \
	.n_len        = sizeof(bn), \
	.e            = (be), \
	.e_len        = sizeof(be), \
	.d            = (bd), \
	.d_len        = sizeof(bd), \
	.c            = (bc), \
	.c_len        = sizeof(bc), \
	.sign_in      = (in), \
	.sign_in_len  = sizeof(in), \
	.sign_out     = (out), \
	.sign_out_len = sizeof(out) \
}

#define EMPTY_TEST() {}

const struct hash_test_data hash_data_set[] = {
	HASH_TEST(MD5,    foo_data, hash_md5),
	HASH_TEST(SHA1,   foo_data, hash_sha1),
	HASH_TEST(SHA256, foo_data, hash_sha256),
	HASH_TEST(SHA512, foo_data, hash_sha512),
	HASH_TEST(SM3,    foo_data, hash_sm3),

#if CONFIG_IS_ENABLED(ROCKCHIP_HMAC)
	EMPTY_TEST(),
	HMAC_TEST(MD5,    foo_data, hmac_md5,    hmac_key),
	HMAC_TEST(SHA1,   foo_data, hmac_sha1,   hmac_key),
	HMAC_TEST(SHA256, foo_data, hmac_sha256, hmac_key),
	HMAC_TEST(SHA512, foo_data, hmac_sha512, hmac_key),
	HMAC_TEST(SM3,    foo_data, hmac_sm3,    hmac_key),
#endif
};

const struct cipher_test_data cipher_data_set[] = {
#if CONFIG_IS_ENABLED(ROCKCHIP_CIPHER)
	CIPHER_TEST(DES, ECB, des_key, des_iv, foo_data, des_ecb_cipher),
	CIPHER_TEST(DES, CBC, des_key, des_iv, foo_data, des_cbc_cipher),
	CIPHER_TEST(DES, CFB, des_key, des_iv, foo_data, des_cfb_cipher),
	CIPHER_TEST(DES, OFB, des_key, des_iv, foo_data, des_ofb_cipher),

	EMPTY_TEST(),
	CIPHER_TEST(DES, ECB, tdes_key, tdes_iv, foo_data, tdes_ecb_cipher),
	CIPHER_TEST(DES, CBC, tdes_key, tdes_iv, foo_data, tdes_cbc_cipher),
	CIPHER_TEST(DES, CFB, tdes_key, tdes_iv, foo_data, tdes_cfb_cipher),
	CIPHER_TEST(DES, OFB, tdes_key, tdes_iv, foo_data, tdes_ofb_cipher),

	EMPTY_TEST(),
	CIPHER_TEST(AES, ECB, aes_key, aes_iv, foo_data, aes_ecb_cipher),
	CIPHER_TEST(AES, CBC, aes_key, aes_iv, foo_data, aes_cbc_cipher),
	CIPHER_TEST(AES, CFB, aes_key, aes_iv, foo_data, aes_cfb_cipher),
	CIPHER_TEST(AES, OFB, aes_key, aes_iv, foo_data, aes_ofb_cipher),
	CIPHER_TEST(AES, CTS, aes_key, aes_iv, foo_data, aes_cts_cipher),
	CIPHER_TEST(AES, CTR, aes_key, aes_iv, foo_data, aes_ctr_cipher),
	CIPHER_XTS_TEST(AES, XTS, aes_key, aes_twk_key,
			aes_iv, foo_data, aes_xts_cipher),

	EMPTY_TEST(),
	CIPHER_TEST(SM4, ECB, sm4_key, sm4_iv, foo_data, sm4_ecb_cipher),
	CIPHER_TEST(SM4, CBC, sm4_key, sm4_iv, foo_data, sm4_cbc_cipher),
	CIPHER_TEST(SM4, CFB, sm4_key, sm4_iv, foo_data, sm4_cfb_cipher),
	CIPHER_TEST(SM4, OFB, sm4_key, sm4_iv, foo_data, sm4_ofb_cipher),
	CIPHER_TEST(SM4, CTS, sm4_key, sm4_iv, foo_data, sm4_cts_cipher),
	CIPHER_TEST(SM4, CTR, sm4_key, sm4_iv, foo_data, sm4_ctr_cipher),
	CIPHER_XTS_TEST(SM4, XTS, sm4_key, sm4_twk_key,
			sm4_iv, foo_data, sm4_xts_cipher),
#else
	EMPTY_TEST(),
#endif
};

const struct rsa_test_data rsa_data_set[] = {
#if CONFIG_IS_ENABLED(ROCKCHIP_RSA)
	RSA_TEST(2048, rsa2048_n, rsa2048_e, rsa2048_c, rsa2048_d,
		 rsa2048_sign_in, rsa2048_sign_out),
#else
	EMPTY_TEST(),
#endif
};

static void dump_hex(const char *name, const u8 *array, u32 len)
{
	int i;

	printf("[%s]: %uByte", name, len);
	for (i = 0; i < len; i++) {
		if (i % 32 == 0)
			printf("\n");
		printf("%02x ", array[i]);
	}
	printf("\n");
}

static inline void check_result(const char *algo_name, const char *mode_name,
				const char *crypt,
				const u8 *expect, const u8 *actual, u32 len)
{
	if (memcmp(expect, actual, len) == 0) {
		printf("[%s] %-8s%-8s PASS\n",
		       algo_name, mode_name, crypt);
	} else {
		printf("[%s] %-8s%-8s FAIL\n",
		       algo_name, mode_name, crypt);
		dump_hex("expect", expect, len);
		dump_hex("actual", actual, len);
	}
}

int test_hash_result(void)
{
	const struct hash_test_data *test_data = NULL;
	sha_context csha_ctx;
	struct udevice *dev;
	unsigned int i;
	u8 out[64];
	int ret;

	printf("\n=================== hash & hmac test ===================\n");

	for (i = 0; i < ARRAY_SIZE(hash_data_set); i++) {
		test_data = &hash_data_set[i];
		if (test_data->algo == 0) {
			printf("\n");
			continue;
		}

		dev = crypto_get_device(test_data->algo);
		if (!dev) {
			printf("[%s] %-16s unsupported!!!\n",
			       test_data->algo_name,
			       test_data->mode_name);
			continue;
		}

		csha_ctx.algo   = test_data->algo;
		csha_ctx.length = test_data->data_len;

		memset(out, 0x00, sizeof(out));
		if (test_data->key) {
			ret = crypto_hmac_init(dev, &csha_ctx,
					       (u8 *)test_data->key,
					       test_data->key_len);
			ret |= crypto_hmac_update(dev, (void *)test_data->data,
						  test_data->data_len);
			ret |= crypto_hmac_final(dev, &csha_ctx, out);
			if (ret) {
				printf("hmac calc error ret = %d\n", ret);
				goto error;
			}
		} else {
			ret = crypto_sha_init(dev, &csha_ctx);
			ret |= crypto_sha_update(dev, (void *)test_data->data,
						 test_data->data_len);
			ret |= crypto_sha_final(dev, &csha_ctx, out);
			if (ret) {
				printf("hash calc error ret = %d\n", ret);
				goto error;
			}
		}

		check_result(test_data->algo_name, test_data->mode_name,
			     "", test_data->hash, out, test_data->hash_len);
		printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	}

	return 0;
error:
	printf("%s %s test error!\n",
	       test_data->algo_name, test_data->mode_name);
	return ret;
}

int test_cipher_result(void)
{
	const struct cipher_test_data *test_data = NULL;
	struct udevice *dev;
	cipher_context ctx;
	u8 out[256];
	int ret;
	u32 i;

	printf("\n===================== cipher test ======================\n");

	for (i = 0; i < ARRAY_SIZE(cipher_data_set); i++) {
		test_data = &cipher_data_set[i];
		if (test_data->algo == 0) {
			printf("\n");
			continue;
		}

		dev = crypto_get_device(test_data->algo);
		if (!dev) {
			printf("[%s] %-16s unsupported!!!\n",
			       test_data->algo_name, test_data->mode_name);
			continue;
		}

		memset(&ctx, 0x00, sizeof(ctx));

		ctx.algo    = test_data->algo;
		ctx.mode    = test_data->mode;
		ctx.key     = test_data->key;
		ctx.twk_key = test_data->twk_key;
		ctx.key_len = test_data->key_len;
		ctx.iv      = test_data->iv;
		ctx.iv_len  = test_data->iv_len;

		ret = crypto_cipher(dev, &ctx, test_data->plain,
				    out, test_data->plain_len, true);
		if (ret)
			goto error;

		check_result(test_data->algo_name, test_data->mode_name,
			     "encrypt", test_data->cipher, out,
			     test_data->cipher_len);

		ret = crypto_cipher(dev, &ctx, test_data->cipher,
				    out, test_data->cipher_len, false);
		if (ret)
			goto error;

		check_result(test_data->algo_name, test_data->mode_name,
			     "decrypt", test_data->plain, out,
			     test_data->plain_len);
		printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	}
	return 0;
error:
	printf("%s %s test error!\n",
	       test_data->algo_name, test_data->mode_name);
	return ret;
}

int test_rsa_result(void)
{
	const struct rsa_test_data *test_data = NULL;
	u8 *hard_out = NULL, *e_tmp;
	u32 data_size = 4096 / 8;
	struct udevice *dev;
	rsa_key rsa_key;
	int ret, i;

	hard_out = (u8 *)memalign(CONFIG_SYS_CACHELINE_SIZE, data_size);
	if (!hard_out) {
		printf("%s, %d: memalign %u error!\n",
		       __func__, __LINE__, data_size);
		return -EINVAL;
	}

	e_tmp = (u8 *)memalign(CONFIG_SYS_CACHELINE_SIZE, data_size);
	if (!e_tmp) {
		printf("%s, %d: memalign %u error!\n",
		       __func__, __LINE__, data_size);
		return -EINVAL;
	}

	printf("\n====================== rsa test ========================\n");
	for (i = 0; i < ARRAY_SIZE(rsa_data_set); i++) {
		test_data = &rsa_data_set[i];
		if (test_data->algo == 0) {
			printf("\n");
			continue;
		}

		dev = crypto_get_device(test_data->algo);
		if (!dev) {
			printf("[%s] %-16s unsupported!!!\n",
			       test_data->algo_name, test_data->mode_name);
			continue;
		}

		/* sign test */
		memset(&rsa_key, 0x00, sizeof(rsa_key));
		rsa_key.algo = test_data->algo;
		rsa_key.n = (u32 *)test_data->n;
		rsa_key.e = (u32 *)test_data->d;
#ifdef CONFIG_ROCKCHIP_CRYPTO_V1
		rsa_key.c = (u32 *)test_data->c;
#endif

		ret = crypto_rsa_verify(dev, &rsa_key,
					(u8 *)test_data->sign_in, hard_out);
		if (ret) {
			printf("sign test error, ret = %d\n", ret);
			goto error;
		}

		check_result(test_data->algo_name, test_data->mode_name,
			     "sign", test_data->sign_out,
			     hard_out, test_data->n_len);

		/* verify test */
		memset(&rsa_key, 0x00, sizeof(rsa_key));
		memset(e_tmp, 0x00, data_size);
		memcpy(e_tmp, test_data->e, test_data->e_len);
		rsa_key.algo = test_data->algo;
		rsa_key.n = (u32 *)test_data->n;
		rsa_key.e = (u32 *)e_tmp;
#ifdef CONFIG_ROCKCHIP_CRYPTO_V1
		rsa_key.c = (u32 *)test_data->c;
#endif

		ret = crypto_rsa_verify(dev, &rsa_key,
					(u8 *)test_data->sign_out, hard_out);
		if (ret) {
			printf("verify test error, ret = %d\n", ret);
			goto error;
		}

		check_result(test_data->algo_name, test_data->mode_name,
			     "verify", test_data->sign_in,
			     hard_out, test_data->n_len);

		printf("+++++++++++++++++++++++++++++++++++++++++++++++++++\n");
	}

	free(hard_out);
	free(e_tmp);

	return 0;
error:
	free(hard_out);
	free(e_tmp);
	printf("%s %s test error!\n",
	       test_data->algo_name, test_data->mode_name);
	return ret;
}

static int test_all_result(void)
{
	int ret = 0;

	ret = test_hash_result();
	if (ret)
		goto exit;

	ret = test_cipher_result();
	if (ret)
		goto exit;

	ret = test_rsa_result();
	if (ret)
		goto exit;

exit:
	return 0;
}

static int do_crypto(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	return test_all_result();
}

U_BOOT_CMD(
	crypto, 1, 1, do_crypto,
	"crypto test",
	""
);
