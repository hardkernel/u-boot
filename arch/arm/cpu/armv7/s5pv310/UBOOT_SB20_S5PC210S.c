/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */
 
#include "UBOOT_SB20_S5PC210S.h"

#include <asm/arch/ace_sha1.h>
#define CONFIG_SHA1 (1)
//#define	SW_SHA1		(1)

#define SHA1_BLOCK_LEN		64	/* Input Message Block Length */
#define SHA1_DIGEST_LEN		20	/* Hash Code Length */

/* SHA1 Context  */
typedef struct
{
	unsigned int	auChain[SHA1_DIGEST_LEN/4];	/* Chaining Variable */
	unsigned int	auCount[2];			/* the number of input message bit */
	unsigned char	abBuffer[SHA1_BLOCK_LEN];	/* Buffer for unfilled block */
} SHA1_ALG_INFO;

/* int sscl_memcmp(BYTE *pbSrc1, BYTE *pbSrc2, DWORD uByteLen); */
#define	macro_sscl_memcmp(BASE_FUNC_PTR,a,b,c) \
			(((int(*)(unsigned char *, unsigned char *, unsigned int))\
			(*((unsigned int *)(BASE_FUNC_PTR +  0))))\
			((a),(b),(c)))

/* void sscl_memcpy(BYTE *pbDst, BYTE *pbSrc, DWORD uByteLen); */
#define	macro_sscl_memcpy(BASE_FUNC_PTR,a,b,c) \
			(((void(*)(unsigned char *, unsigned char *, unsigned int))\
			(*((unsigned int *)(BASE_FUNC_PTR +  4))))\
			((a),(b),(c)))

//void sscl_memset(BYTE *pbDst, BYTE bValue, DWORD uByteLen); */
#define	macro_sscl_memset(BASE_FUNC_PTR,a,b,c) \
			(((void(*)(unsigned char *, unsigned char, unsigned int))\
			(*((unsigned int *)(BASE_FUNC_PTR +  8))))\
			((a),(b),(c)))

/* void sscl_memxor(BYTE *pbDst, BYTE *pbSrc1, BYTE *pbSrc2, DWORD uByteLen); */
#define	macro_sscl_memxor(BASE_FUNC_PTR,a,b,c,d) \
			(((void(*)(unsigned char *, unsigned char *, unsigned char *, unsigned int))\
			(*((unsigned int *)(BASE_FUNC_PTR + 12))))\
			((a),(b),(c),(d)))

/* unsigned int SEC_SHA1_Init(SHA1_ALG_INFO *psAlgInfo); */
#define	macro_SEC_SHA1_Init(BASE_FUNC_PTR,a) \
			(((unsigned int(*)(SHA1_ALG_INFO *))\
			(*((unsigned int *)(BASE_FUNC_PTR + 16))))\
			((a)))

/* unsigned SEC_SHA1_Update(SHA1_ALG_INFO *psAlgInfo, BYTE *pbMessage, DWORD uMsgLen); */
#define	macro_SEC_SHA1_Update(BASE_FUNC_PTR,a,b,c) \
			(((unsigned int(*)(SHA1_ALG_INFO *, unsigned char *, unsigned int))\
			(*((unsigned int *)(BASE_FUNC_PTR + 20))))\
			((a),(b),(c)))

/* unsigned SEC_SHA1_Final( SHA1_ALG_INFO *psAlgInfo, BYTE *pbDigest); */
#define	macro_SEC_SHA1_Final(BASE_FUNC_PTR,a,b) \
			(((unsigned int(*)(SHA1_ALG_INFO *, unsigned char *))\
			(*((unsigned int *)(BASE_FUNC_PTR + 24))))\
			((a),(b)))

/* RET_VAL SEC_SHA1_HMAC_SetInfo( SHA1_HMAC_ALG_INFO *psAlgInfo, BYTE *pbUserKey, DWORD uUKeyLen ); */
#define	macro_SEC_SHA1_HMAC_SetInfo(BASE_FUNC_PTR,a,b,c) \
			(((unsigned int(*)(SHA1_HMAC_ALG_INFO *, unsigned char *, unsigned int))\
			(*((unsigned int *)(BASE_FUNC_PTR + 28))))\
			((a),(b),(c)))

/* RET_VAL SEC_SHA1_HMAC_Init(SHA1_HMAC_ALG_INFO *psAlgInfo); */
#define	macro_SEC_SHA1_HMAC_Init(BASE_FUNC_PTR,a) \
			(((unsigned int(*)(SHA1_HMAC_ALG_INFO *))\
			(*((unsigned int *)(BASE_FUNC_PTR + 32))))\
			((a)))

/* RET_VAL SEC_SHA1_HMAC_Update(SHA1_HMAC_ALG_INFO *psAlgInfo, BYTE *pbMessage, DWORD uMsgLen); */
#define	macro_SEC_SHA1_HMAC_Update(BASE_FUNC_PTR,a,b,c) \
			(((unsigned int(*)(SHA1_HMAC_ALG_INFO *, unsigned char *, unsigned int))\
			(*((unsigned int *)(BASE_FUNC_PTR + 36))))\
			((a),(b),(c)))

/* RET_VAL SEC_SHA1_HMAC_Final( SHA1_HMAC_ALG_INFO *psAlgInfo, BYTE *pbHmacVal); */
#define	macro_SEC_SHA1_HMAC_Final(BASE_FUNC_PTR,a,b) \
			(((unsigned int(*)(SHA1_HMAC_ALG_INFO *, unsigned char *))\
			(*((unsigned int *)(BASE_FUNC_PTR + 40))))\
			((a),(b)))

/* int Verify_PSS_RSASignature (
 *	IN	unsigned char	*rawRSAPublicKey,
 *	IN	int		rawRSAPublicKeyLen,
 *	IN	unsigned char	*hashCode,
 *	IN	int		hashCodeLen,
 *	IN	unsigned char	*signature,
 *	IN	int		signatureLen);
 */	
#define	macro_Verify_PSS_RSASignature(BASE_FUNC_PTR,a,b,c,d,e,f) \
			(((int(*)(unsigned char *, int, unsigned char *, int, unsigned char*, int))\
			(*((unsigned int *)(BASE_FUNC_PTR + 44))))\
			((a),(b),(c),(d),(e),(f)))
#define	macro_Verify_PSS_RSASignature2(BASE_FUNC_PTR,a,b,c,d,e,f)	(((int(*)(unsigned char *, int, unsigned char *, int, unsigned char*, int))\
														(*((unsigned int *)(BASE_FUNC_PTR + 48))))\
														((a),(b),(c),(d),(e),(f)))


////////////////////////////////////////////////////////////////////////
//	Verify integrity of BL2(or OS) Image.
int Check_Signature (
		SB20_CONTEXT	*sbContext,
		unsigned char	*data,
		int		dataLen,
		unsigned char	*signedData,
		int		signedDataLen )
{
	unsigned int	rv;
	unsigned int	SBoot_BaseFunc_ptr;

	SBoot_BaseFunc_ptr = (unsigned int)sbContext->func_ptr_BaseAddr;
#if defined (CONFIG_SHA1)
	unsigned char	hashCode[SHA1_DIGEST_LEN];
	int		hashCodeLen = SHA1_DIGEST_LEN;
	SHA1_ALG_INFO	algInfo;
	SB20_RSAPubKey	tempPubKey;
	SBoot_BaseFunc_ptr = (unsigned int)sbContext->func_ptr_BaseAddr;

#if 0
	/* 0. if stage2 pubkey is 0x00, do NOT check integrity. */
	macro_sscl_memset(SBoot_BaseFunc_ptr,
			(unsigned char *)&tempPubKey,
			0x00,
			sizeof(SB20_RSAPubKey));

	rv = macro_sscl_memcmp(SBoot_BaseFunc_ptr,
			(unsigned char *)&(sbContext->stage2PubKey),
			(unsigned char *)&tempPubKey,
			sizeof(SB20_RSAPubKey));

	if (rv  == 0)
	return SB_OFF;
#endif
	/* 1. Make HashCode */
	/* 1-1. SHA1 Init */
	macro_sscl_memset(SBoot_BaseFunc_ptr,
			(unsigned char *) &algInfo,
			0x00,
			sizeof(SHA1_ALG_INFO));

#if defined(SW_SHA1) 	
	macro_SEC_SHA1_Init(SBoot_BaseFunc_ptr, &algInfo );

	/* 1-3. SHA1 Update. */
	macro_SEC_SHA1_Update(SBoot_BaseFunc_ptr, &algInfo, data, dataLen );

	/* 1-4. SHA1 Final. */
	macro_SEC_SHA1_Final(SBoot_BaseFunc_ptr, &algInfo, hashCode );
#else
	ace_hash_sha1_digest(hashCode, data, dataLen);
#endif
	rv = macro_Verify_PSS_RSASignature(SBoot_BaseFunc_ptr,
					(unsigned char *)&(sbContext->stage2PubKey),
					sizeof(SB20_RSAPubKey),
					hashCode, hashCodeLen,
					signedData, signedDataLen );
#else
	rv = macro_Verify_PSS_RSASignature2(SBoot_BaseFunc_ptr,
					(unsigned char *)&(sbContext->stage2PubKey),
					sizeof(SB20_RSAPubKey),
					data, dataLen,
					signedData, signedDataLen );
#endif
	if ( rv != SB_OK )
		return rv;
	
	return SB_OK;
}
