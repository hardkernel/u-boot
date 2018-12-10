/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * (C) Copyright 2019 Rockchip Electronics Co., Ltd
 */

#ifndef _ROCKCHIP_CRYPTO_HD_H_
#define _ROCKCHIP_CRYPTO_HD_H_

struct rk_crypto_reg {
	u32 crypto_intsts;
	u32 crypto_intena;
	u32 crypto_ctrl;
	u32 crypto_conf;
	u32 crypto_brdmas;
	u32 crypto_btdmas;
	u32 crypto_brdmal;
	u32 crypto_hrdmas;
	u32 crypto_hrdmal;
	u32 reserved0[(0x80 - 0x24) / 4];

	u32 crypto_aes_ctrl;
	u32 crypto_aes_sts;
	u32 crypto_aes_din[4];
	u32 crypto_aes_dout[4];
	u32 crypto_aes_iv[4];
	u32 crypto_aes_key[8];
	u32 crypto_aes_cnt[4];
	u32 reserved1[(0x100 - 0xe8) / 4];

	u32 crypto_tdes_ctrl;
	u32 crypto_tdes_sts;
	u32 crypto_tdes_din[2];
	u32 crypto_tdes_dout[2];
	u32 crypto_tdes_iv[2];
	u32 crypto_tdes_key1[2];
	u32 crypto_tdes_key2[2];
	u32 crypto_tdes_key3[2];
	u32 reserved2[(0x180 - 0x138) / 4];

	u32 crypto_hash_ctrl;
	u32 crypto_hash_sts;
	u32 crypto_hash_meg_len;
	u32 crypto_hash_dout[8];
	u32 crypto_hash_seed[5];
	u32 reserved3[(0x200 - 0x1c0) / 4];

	u32 crypto_trng_ctrl;
	u32 crypto_trng_dout[8];
	u32 reserved4[(0x280 - 0x224) / 4];

	u32 crypto_pka_ctrl;
	u32 reserved5[(0x400 - 0x284) / 4];

	u32 crypto_pka_m;
	u32 reserved6[(0x500 - 0x404) / 4];

	u32 crypto_pka_c;
	u32 reserved7[(0x600 - 0x504) / 4];

	u32 crypto_pka_n;
	u32 reserved8[(0x700 - 0x604) / 4];

	u32 crypto_pka_e;
};

#define CRYPTO_DEFAULT_CLK           10000000
#define SHA_256_BIT                  256
/* crypto_hash_ctrl */
#define HASH_SWAP_DO                 0x8
#define ENGINE_SELECTION_SHA256      0x2
/* crypto_conf */
#define HR_ADDR_MODE                 (1 << 8)
#define BT_ADDR_MODE                 (1 << 7)
#define BR_ADDR_MODE                 (1 << 6)
#define BYTESWAP_HRFIFO              (1 << 5)
#define BYTESWAP_BTFIFO              (1 << 4)
#define BYTESWAP_BRFIFO              (1 << 3)
#define DESSEL                       (1 << 2)
/* crypto_ctrl */
#define TRNG_FLUSH                   (1 << 9)
#define TRNG_START                   (1 << 8)
#define PKA_FLUSH                    (1 << 7)
#define HASH_FLUSH                   (1 << 6)
#define BLOCK_FLUSH                  (1 << 5)
#define PKA_START                    (1 << 4)
#define HASH_START                   (1 << 3)
#define BLOCK_START                  (1 << 2)
#define TDES_START                   (1 << 1)
#define AES_START                    (1 << 0)
#define PKA_HASH_CTRL                (PKA_FLUSH | HASH_FLUSH)
#define PKA_CTRL                     (PKA_FLUSH | PKA_START)
/* crypto_intsts */
#define PKA_DONE_INT                 (1 << 5)
#define HASH_DONE_INT                (1 << 4)
#define HRDMA_ERR_INT                (1 << 3)
#define HRDMA_DONE_INT               (1 << 2)
#define BCDMA_ERR_INT                (1 << 1)
#define BCDMA_DONE_INT               (1 << 0)
/* crypto_pka_ctrl */
#define PKA_BLOCK_SIZE_2048          2

struct dm_rk_crypto_ops {
	int (*sha_init)(struct udevice *dev, u32 msg_len, int hash_bits);
	int (*sha_byte_swap)(struct udevice *dev, int en);
	int (*sha_start)(struct udevice *dev, u32 *data, u32 data_len);
	int (*sha_end)(struct udevice *dev, u32 *result);
	int (*rsa_init)(struct udevice *dev);
	int (*rsa_start)(struct udevice *dev, u32 *m, u32 *n, u32 *e, u32 *c);
	int (*rsa_end)(struct udevice *dev, u32 *result);
};

#endif
