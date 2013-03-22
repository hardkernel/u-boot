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

#ifndef _SECURE_H_
#define _SECURE_H_

#define		IN
#define		OUT

/* Return Value Definition */
#define		SB_OK					0x00000000
#define		SB_OFF					0x80000000

#define		SB_ERROR_VALIDATE_PUBLIC_KEY_INFO	0xFFF10000 
#define		SB_ERROR_VERIFY_PSS_RSA_SIGNATURE	0xFFF20000 
#define		SB_ERROR_CHECK_INTEGRITY_CODE		0xFFF30000 

#define		SB_ERROR_HMAC_SHA1_SET_INFO		0x00000010
#define		SB_ERROR_HMAC_SHA1_INIT			0x00000020
#define		SB_ERROR_HMAC_SHA1_UPDATE		0x00000030
#define		SB_ERROR_HMAC_SHA1_FINAL		0x00000040
#define		SB_ERROR_MEM_CMP			0x00000050
#define		SB_ERROR_SHA1_INIT			0x00000060
#define		SB_ERROR_SHA1_UPDATE			0x00000070
#define		SB_ERROR_SHA1_FINAL			0x00000080
#define		SB_ERROR_VERIFY_RSA_PSS			0x00000090 

#define		MAX_EFUSE_DATA_LEN			16

typedef struct
{
	unsigned char	rsa_n[128];	/* RSA Modulus N */
	unsigned char	rsa_e[4];	/* RSA Public Exponent E */
} RawRSAPublicKey;

typedef struct
{
	RawRSAPublicKey	rsaPubKey;	/* RSA PublicKey */
	unsigned char	signedData[20];	/* HMAC Value of RSA PublicKey */
} PubKeyInfo;

/* Secure Boot Context */
typedef struct
{
	RawRSAPublicKey	stage2PubKey;			/* Stage2 RSA Public Key */
	unsigned char	code_SignedData[128];		/* RSA Signature Value */
	PubKeyInfo	pubKeyInfo;			/* Stage1 RSA PublicKey and it's HMAC value */
	unsigned char	func_ptr_BaseAddr[48];		/* Function pointer of iROM's secure boot function */
	unsigned char	test_eFuse[MAX_EFUSE_DATA_LEN];
	unsigned char	reservedData[36];
} SecureBoot_CTX;

/* Verify integrity of Image. */
int Check_IntegrityOfImage (
	IN	SecureBoot_CTX	*sbContext,
	IN	unsigned char	*BL2,
	IN	int		BL2Len,
	IN	unsigned char	*BL2_SignedData,
	IN	int		BL2_SignedDataLen );

#endif  /* _BL1_SB_C110_H_ */
