#include <config.h>
#include <asm/arch/cpu.h>

#include "../../../../../drivers/secure/aes_pollar.h"

#include "firmware/secure.c"



#define AML_SECURE_PROCESS_MSG_SHOW 1
#if defined(AML_SECURE_PROCESS_MSG_SHOW)

#if defined(CONFIG_AMLROM_SPL)
	#define AML_MSG_FAIL ("Aml log : ERROR! TPL secure check fail!\n")
	#define AML_MSG_PASS ("Aml log : TPL secure check pass!\n")	
	#define MSG_SHOW(fmt) serial_puts((fmt));serial_puts(" ");serial_puts(__func__);serial_puts(":");serial_put_hex(__LINE__,32);serial_puts("\n");
#else
	#define AML_MSG_FAIL ("Aml log : ERROR! Image secure check fail!\n")
	#define AML_MSG_PASS ("Aml log : Image secure check pass!\n")
	//#define MSG_SHOW(fmt,args...) printf(fmt ,##args)
	#define MSG_SHOW(fmt) printf(fmt);printf(" %s:%d",__func__,__LINE__);printf("\n");
#endif
#else
	#define MSG_SHOW(fmt)
#endif   //AML_SECURE_PROCESS_MSG_SHOW


int m6_rsa_dec_priv(int index,aml_intx *n,aml_intx *d,unsigned char *ct,int ctlen,unsigned char *pt,int *ptlen)
{
	int ret;
	ret = m6_rsa_dec_pub(index,n,d,ct,ctlen,pt,ptlen);
	return ret;
}



static void aml_aes_setkey_dec (aes_context *ctx, const uint8_t *key)
{
	aes_setkey_dec( ctx, key, 256 );
}

static int aml_aes_crypt_cbc( aes_context *ctx, 
                         uint8_t *iv, uint32_t *ct, uint32_t *pt ) 
{
	return aes_crypt_cbc( ctx, 0, 16, iv, (uint8_t *)ct, (uint8_t *)pt );
}

static int aml_aes_decrypt (uint8_t *ct, uint8_t *pt, int size, uint8_t *pAESkey)
{
    int i;
    aes_context ctx;
    uint8_t key[32+16], *iv; 
    uint32_t *ct32 = (uint32_t *)ct;
    uint32_t *pt32 = (uint32_t *)pt;
	int nRet = -1;

    iv = &key[32];

	if(pAESkey)
		memcpy(key,pAESkey,48);
	else
		return nRet;
	
    aml_aes_setkey_dec ( &ctx, key );
	
    for (i=0; i<size/16; i++) 
    {	
    	nRet = aml_aes_crypt_cbc ( &ctx, iv, &ct32[i*4], &pt32[i*4] );
		if(nRet)
			return nRet;
    }

	return nRet;
}

#define EFUSE_CNTL1 0xda000004

static int aml_decrypt_efuse(void* pEFUSE,int nLen)
{
	int nRet = -1;
	if(!pEFUSE || 512 != nLen)
		return nRet;
	unsigned char szDecEFUSE[512];

	unsigned char RSA1024_N[] = {
	0x3B,0xC5,0xD7,0x07,0xF3,0xAD,0x38,0xD3,0xD9,0xF2,0x09,0xEA,0xD8,0x90,0xD1,0xE7,
	0xCF,0x90,0x6E,0xB1,0xCB,0xCE,0x3C,0x96,0x90,0x23,0xE6,0x3A,0x09,0xBC,0x3F,0x5F,
	0xA0,0x13,0x6F,0xFC,0x20,0x6D,0x7C,0x12,0x8B,0x9D,0x1A,0x28,0x17,0x1E,0xF2,0x4B,
	0xDC,0x88,0x11,0x30,0x4C,0x08,0xFA,0xA2,0xBF,0x03,0xE2,0x5D,0x73,0x62,0x18,0x57,
	0x3E,0xC3,0x2A,0x52,0xF2,0x8D,0xDB,0xB1,0x3D,0xDB,0x17,0x32,0x4E,0x70,0x95,0x8B,
	0xDB,0x34,0x02,0x3D,0x3F,0x45,0x4C,0x9A,0x57,0x8A,0x07,0xE3,0x81,0x40,0xED,0xF3,
	0x2D,0xEA,0xD4,0x49,0x62,0xE2,0x8C,0xC2,0x44,0x31,0xD0,0xAD,0xA7,0x2C,0x8B,0xEA,
	0x64,0xD4,0xFA,0xA7,0x1E,0x1D,0x51,0x5A,0x51,0xAA,0x7C,0x14,0x24,0x29,0x00,0xCC,
	};
	
	unsigned char RSA1024_E[] = {
	0x01,0x00,0x01,};
	
	unsigned char RSA1024_D[] = {
	0xA1,0x56,0xB9,0xBA,0x9E,0xA0,0x49,0xEF,0xBC,0x86,0x3A,0xFC,0xDE,0x38,0x04,0x9F,
	0xCC,0x88,0x82,0xA4,0x42,0x1B,0x8F,0xC6,0x9C,0xCD,0xBC,0x1C,0xEC,0x0D,0xF7,0xA1,
	0x8E,0x35,0xFC,0x0C,0x0B,0xCD,0x4C,0xD5,0xBC,0x0A,0x4C,0x6F,0x54,0x38,0x2F,0x0F,
	0x55,0xFE,0x8D,0x00,0x2E,0x11,0xBA,0x75,0x3F,0xE1,0x74,0x40,0xD6,0xA4,0xDD,0x1A,
	0x7E,0x9C,0xA1,0x95,0xA6,0xE4,0x2F,0x4E,0x5B,0x63,0xA9,0x79,0xF7,0x33,0xF1,0xB1,
	0xB6,0x2C,0xD8,0x80,0x5D,0x2C,0xBA,0x00,0x8E,0xE7,0x0E,0x2B,0x11,0x8E,0x16,0x5D,
	0x91,0x55,0xFF,0x72,0xAD,0xF5,0xC4,0xE1,0x88,0x62,0x4C,0xE5,0x6E,0x8F,0x0C,0xC5,
	0x22,0x22,0xC2,0x1F,0x07,0xE9,0x48,0xF0,0xA3,0xB7,0xD2,0xD0,0x88,0xA2,0x0B,0x66,
	};

	int index = check_m6_chip_version();
	if(index < 0){
		//MSG_SHOW("m6 chip can't be identify");
		MSG_SHOW("m6 chip err");
		return nRet;
	}
	unsigned int info=0;
	t_func_v3 fp_05 = (t_func_v3)m6_g_action[index][5];
	fp_05((int)&info,0,4);
	//auto RD bit is setted,if the bit not be cleaned, efuse can't be wrote
	*(volatile unsigned long *)(EFUSE_CNTL1) &= ~(1<<24);  //clean auto RD bit
	if(info &((1<<7))){
		return 1;
	}

	t_func_v3 fp_00 = (t_func_v3)m6_g_action[index][0];
	t_func_r3 fp_01 = (t_func_r3)m6_g_action[index][1];
	t_func_v3 fp_02 = (t_func_v3)m6_g_action[index][2];

	aml_intx amlKey[3];
	fp_00((int)&amlKey[0],0,sizeof(amlKey));
	fp_02((int)&amlKey[0].dp[0],(int)&RSA1024_N[0],128);
	//fp_02((int)&amlKey[1].dp[0],(int)&RSA1024_E[0],3);
	fp_02((int)&amlKey[2].dp[0],(int)&RSA1024_D[0],128);
	amlKey[0].used = 32;
	amlKey[1].used = 1;
	amlKey[2].used = 32;

	unsigned int *pCheck = (unsigned int *)pEFUSE;

	if(!*(pCheck+1))
		return nRet;

	//int i = 0;
	int nOutLen ;
	fp_00((int)&szDecEFUSE[0],0,sizeof(szDecEFUSE));
	nOutLen = 512;
	//aml_rsa_enc_dec(pEFUSE,512,szDecEFUSE,&nOutLen,DEC_WITH_PRIV,amlKey);
	m6_rsa_dec_priv(index,&amlKey[0],&amlKey[2],pEFUSE,512,&szDecEFUSE[0],&nOutLen);

	unsigned char szHashCal[32];
	fp_00((int)&szHashCal[0],0,sizeof(szHashCal));
	extern int sha2_sum( unsigned char outbuf[32],const unsigned char *pbuff, int nLen );
	sha2_sum(szHashCal,szDecEFUSE,512-16-32);
	if(!fp_01((int)&szHashCal[0],(int)(&szDecEFUSE[0]+512-16-32),32))
	{
		fp_02((int)pEFUSE,(int)&szDecEFUSE[0],nLen);	
		fp_00((int)(pEFUSE+512-48),0,32);
		fp_02((int)(pEFUSE+512-16),(int)(pEFUSE+512-48-16),16);
		fp_00((int)(pEFUSE+512-48-16),0,16);
		nRet = 0;
	}
	if(nRet){
		MSG_SHOW("decrypt efuse key fail");
	}
	else{
		MSG_SHOW("decrypt efuse key ok");
	}

	return nRet;
}

int aml_sec_boot_check_efuse(unsigned char *pSRC)
{
	return aml_decrypt_efuse(pSRC,512);
}


static int aml_auth_check_buffer(int index,unsigned char *pszContent,aml_intx *n,aml_intx *e)
{
	int nRet = -1;
	struct_aml_chk_blk blk;
	if(!pszContent || !n || !e){
		MSG_SHOW("err");
		return nRet;
	}
	t_func_v3 fp_00 = (t_func_v3)m6_g_action[index][0];//memset
	t_func_r3 fp_01 = (t_func_r3)m6_g_action[index][1];//memcmp
	t_func_v3 fp_02 = (t_func_v3)m6_g_action[index][2];//memcpy

	fp_00((int)&blk,0,sizeof(blk));
	unsigned char *pBufferCHK = pszContent;
	
	pBufferCHK = pszContent + sizeof(blk);
	fp_02((int)&blk,(int)pszContent,sizeof(blk));
	#define RSA1024_DEC_LEN     (128)   //block length for RSA decrypt

	if(((AMLOGIC_CHKBLK_ID_2 == blk.unAMLID) ||(AMLOGIC_CHKBLK_ID == blk.unAMLID)) &&
		(AMLOGIC_CHKBLK_VER >= blk.nVer) &&
		sizeof(blk) == blk.nSize2)
	{
		unsigned char szRSADecBuff[RSA1024_DEC_LEN];
		fp_00((int)&szRSADecBuff[0],0,sizeof(szRSADecBuff));
		int OutLen = 128;
		int m6_rsa_dec_pub(int index,aml_intx *n,aml_intx *e,unsigned char *ct,int ctlen,unsigned char *pt,int *ptlen);
		m6_rsa_dec_pub(index,n,e,blk.szCHK,RSA1024_DEC_LEN,szRSADecBuff,&OutLen);
		fp_02((int)&blk.szCHK[0],(int)&szRSADecBuff[0],RSA1024_DEC_LEN);
		if(1 == blk.secure.nInfoType){
			nRet = aml_aes_decrypt(pBufferCHK,pBufferCHK,blk.secure.nAESLength,blk.secure.szAESKey);
			if(nRet)
			{
				//printf("AML-LOG : AES-dec fail (%d)\n",nRet);
				MSG_SHOW("AML-LOG : AES-dec fail ");
				return nRet;
			}
		}
		else{
			MSG_SHOW("err");
			return nRet;
		}
		//Get hash data 
		unsigned char *pBuffer = pBufferCHK;
		if(pBuffer){
			unsigned char szHashCal[128];
			fp_00((int)&szHashCal[0],0,sizeof(szHashCal));
			//hash
			extern int sha2_sum( unsigned char outbuf[32],const unsigned char *pbuff, int nLen );
			sha2_sum(szHashCal,pBuffer,blk.secure.nHashDataLen);
			//compare the hash value			
			if(!fp_01((int)&blk.secure.szHashKey[0],(int)&szHashCal[0],AMLOGIC_CHKBLK_HASH_KEY_LEN))
			{				
				fp_02((int)pszContent,(int)pBufferCHK,blk.secure.nTotalFileLen);
				nRet = 0;
			}
			else{
				MSG_SHOW("err");
			}
		}
	}
	else{
		MSG_SHOW("AML-LOG : Invalid AML-CHK-BLK ID or Ver! ");
	}
	return nRet;
}

int aml_decrypt_kernel_image(void* kernel_image_address)
{
	int nRet = -1;
	unsigned char by2RSAFlag = 0;
	char szEFUSE[128+32];
	int nIndex = 0;
	aml_intx try_key[3];
	int index = check_m6_chip_version();
	if(index < 0){
		MSG_SHOW("chip no identify");
		return nRet;
	}
	t_func_v3 fp_00 = (t_func_v3)m6_g_action[index][0];
	t_func_v3 fp_02 = (t_func_v3)m6_g_action[index][2];
	t_func_v3 fp_05 = (t_func_v3)m6_g_action[index][5];
	
	unsigned int info=0;
	fp_05((int)&info,0,4);
	if(!(info &(1<<7))){
		nRet = 0;
		return nRet;
	}

	fp_00((int)&try_key[0],0,sizeof(try_key));
	fp_00((int)&szEFUSE[0],0,sizeof(szEFUSE));
	fp_05((int)&szEFUSE[0],8,128+32);
	
	try_key[0].used = 32;
	fp_02((int)&try_key[0].dp[0],(int)&szEFUSE[0],128);
	try_key[1].used = 1;
	try_key[1].dp[0] = 0x10001;

	for(nIndex=128;nIndex <128+32;++nIndex)
		by2RSAFlag |= szEFUSE[nIndex];

	nRet = aml_auth_check_buffer(index,kernel_image_address,&try_key[0],&try_key[1]);
	if(nRet){
		MSG_SHOW("decrypt error\n");
		return nRet;
	}

	if(by2RSAFlag){
		
		fp_00((int)&try_key[0],0,sizeof(try_key));

		unsigned int *pRSAAuthID = (unsigned int *)(AHB_SRAM_BASE+32*1024-16);
		#define AML_M6_AMLA_ID	  (0x414C4D41)	 //AMLA
		//int nRSAOffset = 32*1024 - (256+16);
		int nRSAOffset = 32*1024 - (256+16)-16;
		if( AML_M6_AMLA_ID == *pRSAAuthID){
			//nRSAOffset -= (128+16);
			nRSAOffset -= (128);
		}

		fp_02((int)&try_key[0].dp[0],AHB_SRAM_BASE+nRSAOffset,128);
		try_key[0].used = 32;
		nRSAOffset += 128;
		fp_02((int)&try_key[1].dp[0],AHB_SRAM_BASE+nRSAOffset,4);
		try_key[1].used = 1;
		
		nRet = aml_auth_check_buffer(index,kernel_image_address,&try_key[0],&try_key[1]);
		if(nRet){
			MSG_SHOW("decrypt error\n");
		}
	}

	return nRet;
}

#if 0
int test_m6_aes_decrypt(void)
{
	unsigned char aes_key[]={
		0xD1,0x77,0xd9,0x1c,0xdb,0xf1,0x1d,0x87,0x43,0xe0,0x0d,0x6e,0xdd,0x78,0x70,0xff,
		0x11,0xe0,0x14,0xd5,0x39,0x7b,0x9f,0x85,0x7b,0xaf,0xce,0x7a,0xf3,0x48,0x9b,0xb1,
		0xa6,0x63,0xd4,0x63,0xa4,0xcf,0xe6,0x7c,0x75,0x64,0xfc,0xb9,0x55,0x71,0xdb,0x67,
	};
	unsigned char enc_context[]={
		0xad,0xc4,0x2c,0xf6,0x70,0xc0,0xfa,0x4e,0x48,0xd3,0xad,0x72,0x23,0xcc,0x92,0x7e,
	};
	//unsigned char enc_dec[16];
	int index = check_m6_chip_version();
	if(index < 0){
		return -1;
	}
	//memset(enc_dec,0,16);
	m6_aes_decrypt(index,enc_context,16,aes_key,sizeof(aes_key));
	printf("m6 romcode aes dec:\n%s\n\n",enc_context);
	
	int i;
	for(i=0;i<16;i++){
		printf("%x,",enc_context[i]);
	}
	printf("\nm6 aes test finished\n");
	return 0;
}
#endif











