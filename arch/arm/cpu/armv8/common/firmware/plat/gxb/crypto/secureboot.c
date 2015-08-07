
/*
 * arch/arm/cpu/armv8/common/firmware/common/plat/gxb/crypto/secureboot.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

//for polarssl RSA
#include <rsa.h>
#include <string.h>
#include <stdio.h>
#include <sha2.h>
#include <asm/arch/secure_apb.h>
#include <arch_helpers.h>

#include <ndma_utils.h>

//#define AML_DEBUG_SHOW

#if defined(AML_DEBUG_SHOW)
	#define aml_printf printf
#else
	#define aml_printf(...)
#endif

//////////////////////////////////////////////////////////////////////////////////////
//following code will be used for romcode
//only signature check
//
//////////////////////////////////////////////////////////////////////////////////////
//following code will be used for romcode
//only signature check
//copy from here...
//return 0 for success, others for fail

/////////////////////////////////////////////////////////////////////////////////////////
//amlogic secure boot solution
typedef enum{
	AML_SIG_TYPE_NONE=0,
	AML_SIG_TYPE_RSA_PKCS_V15,
	AML_SIG_TYPE_RSA_PKCS_V21, //??
	AML_SIG_TYPE_RSA_PKCS_V15_AES,
}e_aml_sig_type;

typedef enum{
	AML_DATA_TYPE_NONE=0,
	AML_DATA_TYPE_RSA_KEY,
	AML_DATA_TYPE_AES_KEY,
	AML_DATA_TYPE_PROGRAM_GO,    //need this?
	AML_DATA_TYPE_PROGRAM_CALL,  //need this?
}e_aml_data_type;


#define AML_BLK_ID       (0x4C4D4140)
#define AML_BLK_VER_MJR  (1)
#define AML_BLK_VER_MIN  (0)


typedef struct __st_aml_block_header{
	//16
	unsigned int   dwMagic;       //"@AML"
	unsigned int   nTotalSize;    //total size: sizeof(hdr)+
	                              //  nSigLen + nDataLen
	unsigned char  bySizeHdr;     //sizeof(st_aml_block)
	unsigned char  byRootKeyIndex;//root key index; only romcode
	                              //  will use it, others just skip
	unsigned char  byVerMajor;    //major version
	unsigned char  byVerMinor;    //minor version

	unsigned char  szPadding1[4]; //padding???

	//16+16
	unsigned int   nSigType;      //e_aml_sig_type : AML_SIG_TYPE_NONE...
	unsigned int   nSigOffset;	  //sig data offset, include header
	unsigned int   nSigLen;       //sig data length
	//unsigned char  szPadding2[4]; //padding???
	unsigned int   nCHKStart;     //begin to be protected with SHA2

	//32+16
	unsigned int   nPUKType;     //e_aml_data_type : AML_DATA_TYPE_PROGRAM
	unsigned int   nPUKOffset;   //raw data offset, include header
	unsigned int   nPUKDataLen;	 //raw data length
	//unsigned char  szPadding4[4]; //padding???
	unsigned int   nCHKSize;     //size to be protected with SHA2

	//48+16
	unsigned int   nDataType;     //e_aml_data_type : AML_DATA_TYPE_PROGRAM
	unsigned int   nDataOffset;   //raw data offset, include header
	unsigned int   nDataLen;	  //raw data length
	unsigned char  szPadding3[4]; //padding???

	//64
} st_aml_block_header;

typedef enum{
	AML_ITEM_TYPE_NONE=0,
	AML_ITEM_TYPE_RAW_RSA_N,
	AML_ITEM_TYPE_RAW_RSA_E,
	AML_ITEM_TYPE_RAW_RSA_D,
}e_aml_big_num_type;


typedef struct __stBigNumber{
	//8
	unsigned short nBigNMType;    //e_aml_big_num_type
	unsigned short nOffset;       //offset for each data, after HDR
	unsigned short nSize;         //size of raw data
	unsigned char  szReserved[2]; //for future ? padding
	//unsigned char  szSHA2Item[32];//SHA2 of raw data ?? need this ??
	//8
}st_BIG_NUMBER;

typedef struct __stBigNumberStore{
	//8
	unsigned short nBigNMType;    //e_aml_big_num_type
	unsigned short nOffset;       //offset for each data, after HDR
	unsigned short nSize;         //size of raw data
	unsigned char  szReserved[2]; //for future ? padding
	unsigned char  pBuffer[1024];
	//unsigned char  szSHA2Item[32];//SHA2 of raw data ?? need this ??
	//8
}st_BIG_NUMBER_store;

typedef enum{
	AML_RSA_TYPE_NONE=0,
	AML_RSA_TYPE_1024,
	AML_RSA_TYPE_2048,
	AML_RSA_TYPE_4096,
	AML_RSA_TYPE_8192,
	AML_RSA_TYPE_1024_SHA2,
	AML_RSA_TYPE_2048_SHA2,
	AML_RSA_TYPE_4096_SHA2,
	AML_RSA_TYPE_8192_SHA2,

}e_aml_rsa_type_t;

typedef struct __stItemHeader{
	//4
	unsigned char  byCount;         //amount
	unsigned char  byUnitSize;      //sizeof(st_BIG_NUMBER)
	unsigned char  szPad1[2];       //padding

	//4+12
	unsigned short nItemsOffset;    //arrBNM[]
	unsigned short nItemTotalSize;  //(byCount X byUnitSize)
	unsigned short nRAWOffset;      //arrBNM[]
	unsigned short nRAWSize;        //sum(arrBNM[byCount].nSize)
	unsigned char  szPad2[4];       //padding
	//16
}st_ITEM_HDR;

/*
typedef struct __stItemHeader{
	st_ITEM_HDR    header;
	//......
	//......
	st_BIG_NUMBER  arrBNM[];
}st_ITEM;
*/

#define AML_KEY_ID        (0x59454B40)
#define AML_KEY_VER       (1)

#define AML_KEY_RSA1024   (0x41533152)
#define AML_KEY_RSA2048   (0x41533252)
#define AML_KEY_RSA4096   (0x41533452)
#define AML_KEY_RSA8192   (0x41533852)

#define AML_KEY_RSA1024_SHA   (0x41483152)
#define AML_KEY_RSA2048_SHA   (0x41483252)
#define AML_KEY_RSA4096_SHA   (0x41483452)
#define AML_KEY_RSA8192_SHA   (0x41483852)

typedef struct __stKeyHeader{
	//16
	unsigned int   dwMagic;         //"@KEY" 0x59454B40
	unsigned int   nTotalSize;      //total size
	unsigned char  byVersion;       //version
	unsigned char  byKeyType;       //e_aml_rsa_type_t
	unsigned char  byHeadSize;      //sizeof(st_KEY_HDR)
	unsigned char  szPad1[1];       //padding
	unsigned int   dwTypeInfo;      //

	//16+32
	union{
		unsigned char szKeySHA2[32];
		st_ITEM_HDR   itemHdr;
	}un;

	//48
}st_KEY_HDR;

#define AML_KEY_MATRIX_ID   (0x584D4B40)
#define AML_KEY_MATRIX_VER  (1)
#define AML_KEY_MAX_KEY_NUM (4)

typedef struct __stKeyMaxHeader{
	//8
	unsigned int   dwMagic;      //"@KMX" 0x584D4B40
	unsigned char  byVersion;    //version
	unsigned char  szPad1;       //padding
	unsigned short nHeadSize;    //sizeof(st_KEY_MAX_HDR)

	//8+8
	unsigned int   nTotalSize;   //nHeadSize + (byCount x byUnitSize)
	                             // + sum(arrKeyHdr[byCount].itemHdr.nItemTotalSize)
	unsigned char  byCount;      //key amount
	unsigned char  byUnitSize;   //sizeof(st_KEY_HDR)
	unsigned char  szPad2[2];    //padding

	//16
}st_KEY_MAX_HDR;

//----------------------------------------------
typedef struct __stKeyMax{
	st_KEY_MAX_HDR header;
	st_KEY_HDR     arrKeyHdr[4];
}st_KEY_MAX;


#if defined(AML_DEBUG_SHOW)
void aml_u8_printf( unsigned char *p, int size )
{
    int i;
    for (i=0; i<size; i++)
		printf("%02X%s", p[i], ((i+1) % 16==0) ? "\n" :" ");
}
#endif

#if defined(CONFIG_AML_SECURE_UBOOT)
static int aml_key_match_check_tpl(unsigned char szKeySHA2[32])
{
	int nReturn = -1;
	int i  = 0;
	volatile st_KEY_MAX *pKeyMax = (volatile st_KEY_MAX *)(0xd9000808);
	for (i = 0;i<pKeyMax->header.byCount;++i)
	{
		if (!memcmp(szKeySHA2,(void *)pKeyMax->arrKeyHdr[i].un.szKeySHA2,32))
		{
			nReturn = 0;
			break;
		}
	}

	return nReturn;
}
int aml_load_rsa_puk(rsa_context *prsa_ctx,
	unsigned char *pBlock,unsigned char szSHA2[32])
{
	int nRet = -1;
	st_aml_block_header *pblkHdr = (st_aml_block_header *)pBlock;
	st_KEY_HDR * pkeyHdr  = (st_KEY_HDR *)(pBlock + pblkHdr->nPUKOffset);
	st_ITEM_HDR * pHdr	  = (st_ITEM_HDR*)&pkeyHdr->un.itemHdr;
	st_BIG_NUMBER *pBGN   = (st_BIG_NUMBER *)(pBlock + pHdr->nItemsOffset);
	unsigned char *pRAW   = (unsigned char *)(pBlock + pHdr->nRAWOffset);
	mpi *pMPI = 0;
	int i =0;

	if (!prsa_ctx || !pBlock )
		goto exit;

	//following is just for this verison pollarssl code
	//just disable them if use the standard copy
	//begin
	//extern int g_nMX_RSA_keyFormat;
	//g_nMX_RSA_keyFormat = 1;
	//end

	pblkHdr = (st_aml_block_header *)pBlock;
	pkeyHdr  = (st_KEY_HDR *)(pBlock + pblkHdr->nPUKOffset);
	pHdr    = (st_ITEM_HDR*)&pkeyHdr->un.itemHdr;
	pBGN   = (st_BIG_NUMBER *)(pBlock + pHdr->nItemsOffset);
	pRAW   = (unsigned char *)(pBlock + pHdr->nRAWOffset);


	sha2(pRAW,pHdr->nRAWSize,szSHA2,0);

	//u8_printf(pBGN,32);
	//u8_printf(pRAW,32);

	for ( i = 0;i< pHdr->byCount;++i)
	{
		switch (pBGN->nBigNMType)
		{
		case AML_ITEM_TYPE_RAW_RSA_N:  pMPI = &prsa_ctx->N;  break;
		case AML_ITEM_TYPE_RAW_RSA_E:  pMPI = &prsa_ctx->E;  break;
		case AML_ITEM_TYPE_RAW_RSA_D:  pMPI = &prsa_ctx->D;  break;
		default: pMPI = 0; break;
		}

		if (!pMPI)
			while (1) ;

		mpi_read_binary(pMPI,pRAW,pBGN->nSize);

		pRAW += pBGN->nSize;
		pBGN += 1;
	}

	prsa_ctx->len = ( mpi_msb( &prsa_ctx->N ) + 7 ) >> 3;

	switch (prsa_ctx->len)
	{
	case 0x80:  //R1024
	case 0x100: //R2048
	case 0x200: nRet = 0;break; //R4096
	}

exit:

	return nRet;
}
#endif //CONFIG_AML_SECURE_UBOOT

/////////////////////////////////////////////////////////////////////////
/**
 *  pBuffer :  st_aml_block_header + signature data + st_aml_block_header(mirror) + [PUK] + raw data
 *      1. st_aml_block_header will have offset, length, type for signature data, PUK and raw data
 *      2. signature data is a PKCS #1 v1.5 RSA signature of SHA256 (st_aml_block_header(mirror) + [PUK] + raw data)
 *          signed with the PUK's corresponding private key.
 *      3. st_aml_block_header(mirror) is a mirror copy of st_aml_block_header for data consistency
 *      4. PUK is a RSA Public Key to be used for signature check (PKCSv15 format)
 *      5. raw data: has two types for romcode
 *          5.1 1st stage: two keymax : the first is for 4 root key SHA256 and the second is for 4 user key SHA256
 *          5.2 2nd stage: BL2 raw data
 *  pKeyMax : 4 SHA256 hashes of the keys (N+E)
 *      1. for 1st stage: pKeyMax is 0 for the root keymax and user keymax check
 *      2. for 2nd stage: pKeyMax is the user keymax to verify the PUK for BL2 signature
 *  pEntry : offset for BL2 start
 *
 *  return 0 for success and pEntry is the BL2 start address and all others value for check fail
*/
int aml_sig_check_buffer(unsigned long pBuffer,unsigned int *pEntry)
{

	int nReturn = __LINE__;
#if defined(CONFIG_AML_SECURE_UBOOT)
	rsa_context rsa_ctx;
	unsigned char szPUKSHA2[32];
	unsigned char *pSig;
#endif

	int nTick;

//#define AML_SECURE_LOG_TE 1

#if defined(AML_SECURE_LOG_TE)
	#define AML_GET_TE(a) do{a = *((volatile unsigned int*)0xc1109988);}while(0);
	unsigned nT1,nT2;
#else
	#define AML_GET_TE(...)
#endif

	unsigned char *pData=0;
	st_aml_block_header * pBlkHdr = 0;
	int nBL3XSigFlag = 0;
	unsigned char szSHA2[32];
	unsigned char *szAMLBLK= (unsigned char *)(unsigned long)(0x10800000);
	sha2_ctx sha_ctx;
	pBlkHdr = (st_aml_block_header *)pBuffer;

	aml_printf("aml log : Ln = %d\n",__LINE__);

	if (AML_BLK_ID != pBlkHdr->dwMagic)
		goto exit;

	if (AML_BLK_VER_MJR != pBlkHdr->byVerMajor)
		goto exit;
	if (AML_BLK_VER_MIN != pBlkHdr->byVerMinor)
		goto exit;

	if (sizeof(st_aml_block_header) != pBlkHdr->bySizeHdr)
		goto exit;

	//more check
	if (sizeof(st_aml_block_header) != pBlkHdr->nSigOffset)
		goto exit;

	aml_printf("aml log : Ln = %d\n",__LINE__);

	nReturn = __LINE__;

#if defined(CONFIG_AML_SECURE_UBOOT)
	//RSA key load
	rsa_init( &rsa_ctx, RSA_PKCS_V15, 0 );
#endif //CONFIG_AML_SECURE_UBOOT

	switch (pBlkHdr->nSigType)
	{
#if defined(CONFIG_AML_SECURE_UBOOT)
	case AML_RSA_TYPE_1024:
	case AML_RSA_TYPE_2048:
	case AML_RSA_TYPE_4096:
	{
		switch (pBlkHdr->nSigLen)
		{
		case 0x80:	//R1024
		case 0x100: //R2048
		case 0x200: //R4096
		{
			nBL3XSigFlag = 1;
			if (aml_load_rsa_puk(&rsa_ctx,(unsigned char *)pBuffer,szPUKSHA2))
				goto exit;

			aml_printf("aml log : PUK is RSA%d\n",(rsa_ctx.len<<3));

		}break;//R4096
		default: goto exit;
		}
	}break;
#endif //CONFIG_AML_SECURE_UBOOT
	case AML_RSA_TYPE_NONE:break;
	default: goto exit;
	}

	aml_printf("aml log : Ln = %d\n",__LINE__);

	nReturn = __LINE__;
	//check chip is secure enabled or not
	//if enabled just fail for next boot device
	//if(aml_check_secure_set_match(nBL3XSigFlag))
	//	goto exit;

	nTick = 64 - (pBlkHdr->nPUKDataLen & (63));
	//backup header
	memcpy((void*)szAMLBLK,(void*)pBuffer,pBlkHdr->nDataOffset);
	pBlkHdr = (st_aml_block_header *)szAMLBLK;

	flush_dcache_range((unsigned long )szAMLBLK, pBlkHdr->nDataOffset);

	//move original
	memcpy((void*)pBuffer,(void *)(pBuffer + pBlkHdr->nDataLen),pBlkHdr->nDataOffset);

	flush_dcache_range((unsigned long )pBuffer, pBlkHdr->nDataOffset);

	memcpy((void*)(szAMLBLK+pBlkHdr->nDataOffset),(void*)pBuffer,nTick);
	flush_dcache_range((unsigned long )(szAMLBLK+pBlkHdr->nDataOffset), nTick);

	aml_printf("aml log : Ln = %d\n",__LINE__);

	pData =(unsigned char *)(szAMLBLK + pBlkHdr->nCHKStart);

#if defined(CONFIG_AML_SECURE_UBOOT)
	pSig = (unsigned char *)(szAMLBLK + pBlkHdr->nSigOffset);
#endif //#if defined(CONFIG_AML_SECURE_UBOOT)

	AML_GET_TE(nT1);

	SHA2_init( &sha_ctx, 256);
	//hash header
	SHA2_update( &sha_ctx, szAMLBLK, pBlkHdr->bySizeHdr);
	//skip signature
	//hash PUK
	SHA2_update( &sha_ctx, pData, pBlkHdr->nPUKDataLen+nTick);
	SHA2_final( &sha_ctx, (unsigned char *)(pBuffer+nTick), pBlkHdr->nDataLen-nTick);
	AML_GET_TE(nT2);

	//flush_dcache_range((unsigned long )sha_ctx.buf,32);

#if defined(AML_SECURE_LOG_TE)
	printf("aml log : SHA %d (bytes) used %d(us)\n",pBlkHdr->nDataLen+ pBlkHdr->nPUKDataLen +pBlkHdr->bySizeHdr,
	nT2 - nT1);
#endif

	memcpy(szSHA2,sha_ctx.buf,32);

	flush_dcache_range((unsigned long )szSHA2,32);

#if defined(AML_DEBUG_SHOW)
	aml_printf("\naml log : dump cal SHA2 :\n");
	aml_u8_printf((unsigned char *)szSHA2,32);
#endif

	if (!nBL3XSigFlag)
	{
		aml_printf("aml log : normal check Ln = %d\n",__LINE__);
		nReturn = memcmp((const void*)szSHA2,
		(const void*)(szAMLBLK+pBlkHdr->nSigOffset),sizeof(szSHA2));

#if defined(AML_DEBUG_SHOW)
		aml_printf("\naml log : dump org SHA :\n");
		aml_u8_printf((unsigned char *)(szAMLBLK+pBlkHdr->nSigOffset),32);
#endif
		//if(!nReturn && pEntry)
		//	*pEntry = 0;
		//else
		if (nReturn)
			nReturn = __LINE__;

		goto exit;
	}

#if defined(CONFIG_AML_SECURE_UBOOT)
	//verify PUK is valid or not
	if (aml_key_match_check_tpl(szPUKSHA2))
	{
		//error
		aml_printf("aml log: PUK is not a valid key!\n");
		nReturn = __LINE__;
		goto exit;
	}

	nReturn = rsa_pkcs1_verify( &rsa_ctx, RSA_PUBLIC, SIG_RSA_SHA256,32, szSHA2, pSig );

	if (nReturn)
	{
		aml_printf("aml log : Sig check fail! Return = %d\n",nReturn);
		nReturn = __LINE__;
		goto exit;
	}
	else
	{
		aml_printf("aml log : Sig check pass!\n");

		if (pEntry)
			*pEntry = 0;

	}

	//printf("aml log : RSA-%d check %s!\n",rsa_ctx.len<<3, nReturn ? "fail": "pass");
	serial_puts("aml log : RSA-");
	serial_put_dec(rsa_ctx.len<<3);
	serial_puts(" check ");
	serial_puts(nReturn ? "fail": "pass");
	serial_puts("!\n");
#endif //CONFIG_AML_SECURE_UBOOT

exit:

	return nReturn;
}

#if defined(CONFIG_AML_SECURE_UBOOT)

//#define CONFIG_AML_HW_AES_PIO

#if defined(CONFIG_AML_HW_AES_PIO)
void aes_setkey( const uint8_t *key)
{
    uint32_t i;
    uint32_t *key32 = (uint32_t *)key;

    // select aes
    clrbits_le32(SEC_SEC_BLKMV_GEN_REG0, (3<<12));

    // setup aes 256 cbc decrypto pio
    writel((2<<18) | (1<<16), SEC_SEC_BLKMV_AES_REG0);

    // aes=4, request pio and wait for grant.
    writel((1<<4) | 4, SEC_SEC_BLKMV_PIO_CNTL0);
    while (((readl(SEC_SEC_BLKMV_PIO_CNTL0) >> 31) & 1) == 0);

    // Write the Key
    for (i=0; i<8; i++) {
        writel(key32[i], SEC_SEC_BLKMV_PIO_DATA0 + i*4);
    }

	//set IV
	for (i=0; i<4; i++) writel(0, SEC_SEC_BLKMV_PIO_DATA8 + i*4);

    // load iv
    setbits_le32(SEC_SEC_BLKMV_AES_REG0, (1<<1));

}

/**
 * Perform AES 256 CBC decryption
 * cpt: array of 16 bytes of cipher text and plain text output
 */
void aes_cbc_decrypt(uint32_t *cpt)
{
    uint32_t i;

    for (i=0; i<4; i++) writel(cpt[i], SEC_SEC_BLKMV_AES_PIO_W0 + i*4);

    // Wait for the AES process to complete
    while ((readl(SEC_NDMA_CNTL_REG0) >> 12) & 1) ;

    for (i=0; i<4; i++) cpt[i] = readl(SEC_SEC_BLKMV_PIO_DATA0 + i*4);
}
#else
//HW AES DMA
#define AES_Wr(addr, data) *(volatile uint32_t *)(addr)=(data)
#define AES_Rd(addr)       *(volatile uint32_t *)(addr)
#define THREAD0_TABLE_LOC  0x5500000
int g_n_aes_thread_num = 0;
void aes_setkey( const uint8_t *key)
{
    uint32_t *key32 = (uint32_t *)key;

    g_n_aes_thread_num = 0; //fixed thread number to 0

    AES_Wr( SEC_SEC_BLKMV_PIO_CNTL0, (AES_Rd(SEC_SEC_BLKMV_PIO_CNTL0)| (5<<0)) );

    AES_Wr(SEC_SEC_BLKMV_GEN_REG0, ((AES_Rd(SEC_SEC_BLKMV_GEN_REG0) & ~(0xf << 8)) | (0xf << 8)) );
    AES_Wr(SEC_SEC_BLKMV_GEN_REG0, ((AES_Rd(SEC_SEC_BLKMV_GEN_REG0) & ~(0xf << 0)) | (0 << 0)) );

    AES_Wr(SEC_SEC_BLKMV_GEN_REG0, ((AES_Rd(SEC_SEC_BLKMV_GEN_REG0) & ~(0xf << 4)) | (0x0<< 4)) );   // only thread 2 can issue Secure transfers

    AES_Wr( SEC_SEC_BLKMV_AES_REG0, (AES_Rd(SEC_SEC_BLKMV_AES_REG0) & ~(0x1 << 3)) );
    AES_Wr( NDMA_AES_REG0, (AES_Rd(NDMA_AES_REG0) & ~(0x3 << 8)) | (g_n_aes_thread_num << 8) );

    //key
    AES_Wr( NDMA_AES_KEY_0, (key32[0]) );
    AES_Wr( NDMA_AES_KEY_1, (key32[1]) );
    AES_Wr( NDMA_AES_KEY_2, (key32[2]) );
    AES_Wr( NDMA_AES_KEY_3, (key32[3]) );
    AES_Wr( NDMA_AES_KEY_4, (key32[4]) );
    AES_Wr( NDMA_AES_KEY_5, (key32[5]) );
    AES_Wr( NDMA_AES_KEY_6, (key32[6]) );
    AES_Wr( NDMA_AES_KEY_7, (key32[7]) );

    //set IV
    AES_Wr( NDMA_AES_IV_0, 0);
    AES_Wr( NDMA_AES_IV_1, 0);
    AES_Wr( NDMA_AES_IV_2, 0);
    AES_Wr( NDMA_AES_IV_3, 0);

    NDMA_set_table_position_secure( g_n_aes_thread_num, THREAD0_TABLE_LOC, THREAD0_TABLE_LOC + (10*32) );	  // 2 thread entries

}

void aes_cbc_decrypt(uint32_t *ct,uint32_t *pt,int nLen)
{
    NDMA_add_descriptor_aes(    g_n_aes_thread_num, // uint32_t   thread_num,
                                1,                  // uint32_t   irq,
                                1,                  // uint32_t   cbc_enable,
                                1,                  // uint32_t   cbc_reset,
                                0,                  // uint32_t   encrypt,        // 0 = decrypt, 1 = encrypt
                                2,                  // uint32_t   aes_type,       // 00 = 128, 01 = 192, 10 = 256
                                0,                  // uint32_t   pre_endian,
                                0,                  // uint32_t   post_endian,
                                nLen,               // uint32_t   bytes_to_move,
                                (unsigned int)(long)ct, // uint32_t   src_addr,
                                (unsigned int)(long)pt, // uint32_t   dest_addr )
                                0xf,                // uint32_t   ctr_endian,
                                0 );                // uint32_t   ctr_limit )
    NDMA_start(g_n_aes_thread_num);

    NDMA_wait_for_completion(g_n_aes_thread_num);

    NDMA_stop(g_n_aes_thread_num);

}

#endif
#endif //CONFIG_AML_SECURE_UBOOT

int aml_data_check(unsigned long pBuffer,unsigned long pBufferDST,unsigned int nLength,unsigned int nAESFlag)
{

#define TOC_HEADER_NAME 			(0xAA640001)
#define TOC_HEADER_SERIAL_NUMBER	(0x12345678)

#if defined(CONFIG_AML_SECURE_UBOOT)
	unsigned char szAESKey[32];
	#if defined(CONFIG_AML_HW_AES_PIO)
	unsigned int *ct32;
	int i = 0;
	#endif
	unsigned char *pDST= (unsigned char *)(pBufferDST);
#endif //CONFIG_AML_SECURE_UBOOT

#if defined(AML_DEBUG_SHOW)
	int nBegin,nEnd;
#endif

	unsigned int *pCHK = (unsigned int *)pBuffer;

#if defined(AML_DEBUG_SHOW)
	nBegin = *((volatile unsigned int*)0xc1109988);
#endif

	if (TOC_HEADER_NAME == *pCHK && TOC_HEADER_SERIAL_NUMBER == *(pCHK+1))
	{
		return 0;
	}


#if defined(CONFIG_AML_SECURE_UBOOT)

#if defined(AML_DEBUG_SHOW)
	aml_printf("aml log : begin dump buffer before AES nTPLAESFlag = %d:\n",nAESFlag);
	aml_u8_printf((unsigned char *)pBuffer,32);
#endif

	if (nAESFlag)
	{

		if (nAESFlag)
			pCHK = (unsigned int*)pDST;

		sha2((unsigned char *)0xd9000000,16,szAESKey,0);
		aes_setkey(szAESKey);

#if defined(CONFIG_AML_HW_AES_PIO)
		//HW AES PIO
		ct32 = (unsigned int *)pBuffer;

		for (i=0; i<nLength/16; i++)
			aes_cbc_decrypt(&ct32[i*4]);

		memcpy(pDST,(void*)pBuffer,nLength);
#else
		//HW AES DMA
		aes_cbc_decrypt((unsigned int *)pBuffer,(unsigned int *)pDST,nLength);
#endif
		pBuffer = (unsigned long)pDST;

		flush_dcache_range((unsigned long )pDST, nLength);

#if defined(AML_DEBUG_SHOW)
		nEnd = *((volatile unsigned int*)0xc1109988);
		aml_printf("aml log : begin dump buffer after AES nTPLAESFlag=%d len=%d time=%dus\n",
		nAESFlag,nLength,nEnd - nBegin);
		aml_u8_printf((unsigned char *)pBuffer,32);
#endif
		if (TOC_HEADER_NAME == *pCHK && TOC_HEADER_SERIAL_NUMBER == *(pCHK+1))
			return 0;
	}

#if defined(AML_DEBUG_SHOW)
	aml_printf("aml log : begin dump buffer after AES nTPLAESFlag = %d:\n",nAESFlag);
	aml_u8_printf((unsigned char *)pBuffer,32);
#endif

#endif //CONFIG_AML_SECURE_UBOOT

	return aml_sig_check_buffer(pBuffer,0);

}


//////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
