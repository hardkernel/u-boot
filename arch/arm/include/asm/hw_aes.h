/*
 * Header file for AES hardware acceleration
 *
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
 *
 *
 */
#ifndef __HW_AES_H
#define __HW_AES_H

#ifndef __AP_DMA_H__
#define __AP_DMA_H__

typedef struct dma_dsc {
    union {
        uint32_t d32;
        struct {
            unsigned length:17;
            unsigned irq:1;
            unsigned eoc:1;
            unsigned loop:1;
            unsigned mode:4;
            unsigned begin:1;
            unsigned end:1;
            unsigned op_mode:2;
            unsigned enc_sha_only:1;
            unsigned block:1;
            unsigned error:1;
            unsigned owner:1;
        } b;
    } dsc_cfg;
    uint32_t src_addr;
    uint32_t tgt_addr;
} dma_dsc_t;

#endif /* __AP_DMA_H__ */

enum aes_ret_t {
	AES_RET_SUCCESS=0,
	AES_RET_ADDR=1,
	AES_RET_SIZE=2,
	AES_RET_TYPE=3,
	AES_RET_MODE = 4,
};

/**
 *
 * @param key	      A pointer to the key buffer
 * @param iv	      Byte length of iv buffer
 * @param ct	      A pointer to the source buffer
 * @param pt	      A pointer to the target buffer
 * @param size	      Byte length of source buffer
 * @param AEStype     128: aes128 192: aes192  256: aes256
 * @param CryptMode   1: encrypt  0: decrypt
 */
int aes_cbc_crypt(uint8_t *key, uint8_t *iv,
				 uint8_t *ct, uint8_t *pt, uint32_t size, uint16_t AEStype,uint8_t CryptMode);

#endif
