/*
 * Copyright (C) 2018 Amlogic, Inc. All rights reserved.
 *
 * All information contained herein is Amlogic confidential.
 *
 * This software is provided to you pursuant to Software License Agreement
 * (SLA) with Amlogic Inc ("Amlogic"). This software may be used
 * only in accordance with the terms of this agreement.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification is strictly prohibited without prior written permission from
 * Amlogic.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Created by haixiang.bao@amlogic.com
 *
 * Revision history:  1. 2018.05.31 v0.1 init for transfer data from BL2 to BL3X
 *
 */


#ifndef __AMLOGIC_TLV_H_
#define __AMLOGIC_TLV_H_

typedef struct __s_bl2_tlv_item_t{
	unsigned    int    nType;   //type: user defined, should sync between BL2 and BL3X
	unsigned    int    nLength; //length: length of szContent, no alignment
	unsigned    int    nStoreLength; //length: length of szContent, alignment to 16
	unsigned    char   szRserved1[4];//reserved for future
	struct __s_bl2_tlv_item_t * pNextItem;//next item, list for fetch all quickly
	unsigned    char   szContent[4]; //data transfered from BL2
}s_bl2_tlv_item_t;

typedef struct __s_bl2_to_bl3x_hdr_t{
	unsigned    int    nMagic;         //magic for identify itself, AML_BL2_TMASTER_MAGIC (@BL2)
	unsigned    int    nVersion;       //version for control
	unsigned    int    nHeadSize;      //sizeof(this)
	unsigned    char   szRserved1[4];  //reserved for furture

	unsigned    char   szBL2Info[96];  //BL2 build information

	s_bl2_tlv_item_t * pNextBlob;      //next active valid blob item
	unsigned    int    nTLVCount;      //current valid TLV item number
	unsigned    int    nTotalSize;     //total size of all TLV items
	unsigned    char   szSHA2TLV[32];  //SHA2 of all TLV items, size is nTotalSize

} s_bl2_to_bl3x_hdr_t;

typedef struct __s_bl2_to_bl3x_send_t{

	s_bl2_to_bl3x_hdr_t hdr;

	unsigned     char   szSHA2Head[32];

	s_bl2_tlv_item_t	blob[1];

} s_bl2_to_bl3x_send_t;

typedef enum{
	e_ok_ret      = 0,

	e_err_not_support = 0x01,

	e_err_no_item = 0x10,
	e_err_sha_hdr = 0x11,
	e_err_sha_tlv = 0x12,

	e_err_in_data = 0x20,
	e_err_in_size = 0x21,
	e_err_over_size=0x22,
	e_err_item_exit=0x23,

}e_ret_type;

typedef enum{
	e_t_ap_ver    = 0x10,
	e_t_scp_ver   = 0x11,
	e_t_sp_ver    = 0x12,
	e_t_bl2z_ver  = 0x13,
	e_t_bl30_ver  = 0x14,
	e_t_bl301_ver = 0x15,
	e_t_bl31_ver  = 0x16,
	e_t_bl32_ver  = 0x17,
	e_t_bl33_ver  = 0x18,

	e_t_root_aes          = 0x20,
	e_t_root_rsa_sha_all  = 0x21,
	e_t_root_rsa_sha  	  = 0x22,
	e_t_root_rsa_puk      = 0x23,

	e_t_user_aes          = 0x30,
	e_t_user_rsa_sha_all  = 0x31,
	e_t_user_rsa_sha  	  = 0x32,
	e_t_user_rsa_puk  	  = 0x33,

	e_t_bl30_rsa_puk      = 0x50,
	e_t_bl30_aes          = 0x51,

	e_t_bl31_rsa_puk	  = 0x60,
	e_t_bl31_aes          = 0x61,

	e_t_bl32_rsa_puk      = 0x70,
	e_t_bl32_aes          = 0x71,

	e_t_bl33_rsa_puk      = 0x80,
	e_t_bl33_aes          = 0x81,


	//....

}e_item_type;


//magic ID
#define	 AML_BL2_TMASTER_MAGIC     (0x324c4240) 	//@BL2

//major & minor version
#define  AML_BL2_TMASTER_MAJ_VER   (0x00)         //major version
#define	 AML_BL2_TMASTER_MIN_VER   (0x01)			    //minor version
#define	 AML_BL2_TMASTER_VERSION   ((AML_BL2_TMASTER_MAJ_VER << 16) |\
									AML_BL2_TMASTER_MIN_VER)        //major << 16 | minor version

//item data length alignment
#define  AML_BL2_TMASTER_ITEM_UNIT_LEN            (16)
#define  AML_BL2_TMASTER_ITEM_ALIGN_LEN(len)      ((len) + (AML_BL2_TMASTER_ITEM_UNIT_LEN-1)) & (~(AML_BL2_TMASTER_ITEM_UNIT_LEN-1))

//CFG reg to store DDR address
#define  AML_BL2_TMASTER_CFG_REG  (AO_SEC_GP_CFG6)

//DDR buffer size
#ifndef AML_BL2_TMASTER_DDR_MLEN
#define  AML_BL2_TMASTER_DDR_MLEN  ((1<<20) - sizeof(s_bl2_to_bl3x_send_t))  //1MB for transfer data from BL2 to BL3X
#endif

//flag to pass BL2 build info to BL3X
//#define CONFIG_AML_TLV_BL2_VER_INFO

//IMPORTANT: BECAUSE THOSE FUNCTIONS WILL USE DDR AS STORAGE(DEFAULT) THEN
//                    ALL THE APIS MSUT BE USED AFTER DDR INIT DONE
//global APIs to pad & fetch item
//pad item with data, type and length
e_ret_type aml_append_item(unsigned int nType, unsigned int nLength, unsigned char *pData);
//fetch item with type
e_ret_type aml_fetch_item(unsigned int nType, s_bl2_tlv_item_t **ppItem);

#endif /* __AMLOGIC_TLV_H_ */
