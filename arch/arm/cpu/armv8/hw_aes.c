
/*
 * Amlogic AES hardware acceleration
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
*/
#include <common.h>
#include <asm/hw_aes.h>
#include <asm/arch/secure_apb.h>




static void *aes_block(void *dst, void *src, uint32_t len,uint16_t AEStype,uint8_t CryptMode)
{
	//limitation: len < ((128K -1)/2) KB
	//block here if len > ((128K - 1) KB ??
	struct {
		unsigned long lSource;
		unsigned long lTarget;
		int nLength;
		int nBlkFlag;
	} arrSteps[2];

	int index;
	memset(arrSteps, 0, sizeof(arrSteps));

	arrSteps[0].lSource = (unsigned long)src;
	arrSteps[0].lTarget = (unsigned long)dst;

	if (len > 512)
	{
		arrSteps[0].nLength = len >> 9;
		arrSteps[0].nBlkFlag = 1;
		arrSteps[1].lSource = arrSteps[0].lSource + (arrSteps[0].nLength << 9);
		arrSteps[1].lTarget = arrSteps[0].lTarget + (arrSteps[0].nLength << 9);
		arrSteps[1].nLength = len & 0x1FF;
	}
	else
	{
		arrSteps[0].nLength = len;
	}
	dma_dsc_t dsc;

	for (index=0; index < sizeof(arrSteps) / sizeof(arrSteps[0]); ++index)
	{
		dsc.src_addr = arrSteps[index].lSource;
		dsc.tgt_addr = arrSteps[index].lTarget;
		dsc.dsc_cfg.d32 = 0;
		dsc.dsc_cfg.b.length = arrSteps[index].nLength;
		dsc.dsc_cfg.b.mode = (AEStype>>6)+6;   // 8:aes128  9:aes192  10:aes256
		dsc.dsc_cfg.b.op_mode = 1; // cbc
		dsc.dsc_cfg.b.enc_sha_only=CryptMode;   //1:encrypt  0:decrypt
		dsc.dsc_cfg.b.eoc = 1;
		dsc.dsc_cfg.b.owner = 1;
		dsc.dsc_cfg.b.block = arrSteps[index].nBlkFlag;


		*P_DMA_STS0 = 0xf;
		*P_DMA_T0 = (uint64_t)&dsc | 2;
		while (*P_DMA_STS0 == 0);
	}

	return dst;
}

int aes_cbc_crypt(uint8_t *key, uint8_t *iv,
             uint8_t *ct, uint8_t *pt, uint32_t size, uint16_t AEStype,uint8_t CryptMode)
{
    dma_dsc_t dsc[3];
	unsigned char dcache_flag=0;
	enum aes_ret_t nReturn = AES_RET_SUCCESS;

	if (NULL == key || NULL == iv || NULL == ct || NULL == pt)
	{
		nReturn = AES_RET_ADDR;
		goto exit;
	}

	if (0 == size || (64<<20) <= size || 0 != size%16)
	{
		nReturn = AES_RET_SIZE;
		goto exit;
	}

	if (128 != AEStype && 192 != AEStype && 256 != AEStype)
	{
		nReturn = AES_RET_TYPE;
		goto exit;
	}

	if (0 != CryptMode && 1 != CryptMode)
	{
		nReturn = AES_RET_MODE;
		goto exit;
	}


	if (dcache_status())
	{
		dcache_disable();
		dcache_flag=1;
	}
	else
	{
		dcache_flag=0;
	}


    dsc[0].src_addr = (uint64_t)key;
    dsc[0].tgt_addr = 0;
    dsc[0].dsc_cfg.d32 = 0;
    dsc[0].dsc_cfg.b.length = 16;
    dsc[0].dsc_cfg.b.mode = 1; // key
    dsc[0].dsc_cfg.b.owner = 1;

    dsc[1].src_addr = (uint64_t)(key+16);
    dsc[1].tgt_addr = 16;
    dsc[1].dsc_cfg.d32 = 0;
    dsc[1].dsc_cfg.b.length = (AEStype>>3)-16;
    dsc[1].dsc_cfg.b.mode = 1; // key
    dsc[1].dsc_cfg.b.owner = 1;


    dsc[2].src_addr = (uint64_t)iv;
    dsc[2].tgt_addr = 32;
    dsc[2].dsc_cfg.d32 = 0;
    dsc[2].dsc_cfg.b.length = 16;
	dsc[2].dsc_cfg.b.eoc = 1;
    dsc[2].dsc_cfg.b.mode = 1; // key
    dsc[2].dsc_cfg.b.owner = 1;


    *P_DMA_STS0 = 0xf;
    *P_DMA_T0= (uint64_t)dsc | 2;
	while (*P_DMA_STS0 == 0);


	aes_block(pt, ct, size,AEStype,CryptMode);


	if (dcache_flag == 1)
	{
		dcache_enable();
	}

exit:

	return nReturn;

}


