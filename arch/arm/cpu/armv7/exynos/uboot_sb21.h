#ifndef _UBOOT_SB21_H
#define _UBOOT_SB21_H

#ifdef	__cplusplus
extern "C"
{
#endif

#if defined(CONFIG_EXYNOS4x12) || defined(CONFIG_CPU_EXYNOS5250)
#define CONFIG_SECURE_BOOT_V20
#elif defined(CONFIG_SMDK5410) || defined(CONFIG_MACH_SMDK4270)
#define CONFIG_SECURE_BOOT_V23
#else /* CONFIG_CPU_EXYNOS5420, CONFIG_CPU_EXYNOS5422 */
#define CONFIG_SECURE_BOOT_V24
#endif

////////////////////////////////////////////////////////////////////////
// SecureBoot return value define
#define		SB_OK					0x00000000
#define		SB_OFF					0x80000000

//------------------------------------------------------------------------
#define		SB_ERROR_VALIDATE_PUBLIC_KEY_INFO	0xFFF10000
#define		SB_ERROR_VERIFY_PSS_RSA_SIGNATURE	0xFFF20000
#define		SB_ERROR_CHECK_INTEGRITY_CODE		0xFFF30000

//------------------------------------------------------------------------
// added for Secure Boot 2.0
#define		SB_ERROR_GENERATE_PSS_RSA_SIGNATURE	0xFFF40000
#define		SB_ERROR_GENERATE_PUBLIC_KEY_INFO	0xFFF50000
#define		SB_ERROR_GENERATE_SB_CONTEXT		0xFFF60000
#define		SB_ERROR_ENCRYPTION			0xFFF70000

#define		SB_ERROR_AES_PARM			0x0000A000
#define		SB_ERROR_AES_SET_ALGO			0x0000B000
#define		SB_ERROR_AES_ENCRYPT			0x0000C000
#define		SB_ERROR_AES_DECRYPT			0x0000D000

//------------------------------------------------------------------------
#define		SB_ERROR_HMAC_SHA1_SET_INFO		0x00000010
#define		SB_ERROR_HMAC_SHA1_INIT			0x00000020
#define		SB_ERROR_HMAC_SHA1_UPDATE		0x00000030
#define		SB_ERROR_HMAC_SHA1_FINAL		0x00000040
#define		SB_ERROR_MEM_CMP			0x00000050
#define		SB_ERROR_SHA1_INIT			0x00000060
#define		SB_ERROR_SHA1_UPDATE			0x00000070
#define		SB_ERROR_SHA1_FINAL			0x00000080
#define		SB_ERROR_VERIFY_RSA_PSS			0x00000090

////////////////////////////////////////////////////////////////////////
//-------------------------------------------
#define		SB20_MAX_EFUSE_DATA_LEN		20

#define		SB_MAX_RSA_KEY		(2048/8)
#define		SB_MAX_SIGN_LEN		SB_MAX_RSA_KEY

#ifdef CONFIG_SECURE_BOOT_V20
#define SB20_HMAC_SHA1_LEN			20
#else
#define SB20_HMAC_SHA1_LEN			32
#endif

//-------------------------------------------
typedef struct
{
	int			rsa_n_Len;
	unsigned char		rsa_n[SB_MAX_RSA_KEY];
	int			rsa_e_Len;
	unsigned char		rsa_e[4];
} SB_RSAPubKey;

//-------------------------------------------
typedef struct
{
	SB_RSAPubKey		rsaPubKey;
	unsigned char		signedData[SB20_HMAC_SHA1_LEN];
} SB_PubKeyInfo;

//-------------------------------------------
typedef struct
{
	SB_RSAPubKey		stage2PubKey;
	int			code_SignedDataLen;
	unsigned char		code_SignedData[SB_MAX_SIGN_LEN];
	SB_PubKeyInfo		pubKeyInfo;
	unsigned char		func_ptr_BaseAddr[128];
	unsigned char		reservedData[80];
} SB20_CONTEXT;

typedef struct
{
	unsigned int		codesignerversion;
	unsigned int		ap_info;
	unsigned long long	time;
	unsigned int		build_count;
	unsigned char		description[36];
} SB24_INFO;

typedef struct
{
	SB24_INFO		context_info;
	SB_RSAPubKey		stage2PubKey;
	unsigned char		func_ptr_BaseAddr[128];
	unsigned char		reservedData[12];
	SB_PubKeyInfo		pubKeyInfo;
	int			code_SignedDataLen;
	unsigned char		code_SignedData[SB_MAX_SIGN_LEN];
} SB24_CONTEXT;

#if defined(CONFIG_SECURE_BOOT_V24)
#define SB20_CONTEXT	SB24_CONTEXT
#endif

int check_signature(
		SB20_CONTEXT    *sbContext,
		unsigned char	*data,
		unsigned int	dataLen,
		unsigned char	*signedData,
		unsigned int	signedDataLen );

#ifdef	__cplusplus
}
#endif

#endif /* _UBOOT_SB21_H */
