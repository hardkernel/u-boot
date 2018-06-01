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

#if 0 //bl2
#include <platform_def.h>
#include <aml_tlv.h>
#include <string.h>
#include <sha2.h>
#include <secure_apb.h> //AML_BL2_TMASTER_CFG_REG: AO_SEC_GP_CFG6
#include <acs.h>

#ifdef CONFIG_AML_TLV_BL2_VER_INFO
#include <soc_version.h>
extern const char build_message[];
#endif

#else
#include <config.h>
#include <amlogic/aml_tlv.h>
#include <asm/arch/secure_apb.h>
#include <linux/string.h>
#include <u-boot/sha256.h>

#ifndef AML_BL2_TMASTER_DDR_ADDR
#error ERROR! Please define DDR address for TLV!
#endif

#endif

#ifdef CONFIG_AML_SUPPORT_TLV

//internal use only, to fetch the transfer object from AML_BL2_TMASTER_CFG_REG
//only BL2 can set the AML_BL2_TMASTER_CFG_REG
//all others BL3X just use the obj from AML_BL2_TMASTER_CFG_REG
static s_bl2_to_bl3x_send_t * aml_get_t_master(void)
{

#ifdef BL2_ACS_OFFSET
	if (p_acs)
		*(unsigned int *)AML_BL2_TMASTER_CFG_REG = p_acs->p_plls->nCFGTAddr;
	else
		*(unsigned int *)AML_BL2_TMASTER_CFG_REG = 0;
#endif

	return (s_bl2_to_bl3x_send_t*)(unsigned long)(*(unsigned int *)AML_BL2_TMASTER_CFG_REG);

}


//IMPORTANT: BECAUSE THIS FUNCTION WILL USE DDR AS STORAGE(DEFAULT) THEN
//                    ALL THE APIS MSUT BE USED AFTER DDR INIT DONE

//feature : append item to the list
//para list:
//               nType[IN]       :   unique ID for item
//               nLength[IN]    :   byte data length for data pData
//               pData[IN]       :   data buffer to be processed
//
//return   :  e_err_not_support : BL33 not support valid address for TLV
//               e_ok_ret  : append OK to the list
//               e_err_in_data : invalid input pData
//               e_err_in_size  : invalid data length
//               e_err_over_size : total size exceed the max
//               e_err_item_exit  : item already exist with nType

e_ret_type aml_append_item(unsigned int nType, unsigned int nLength, unsigned char *pData)
{
	e_ret_type eReturn = e_err_not_support;

	#ifdef CONFIG_AML_TLV_BL2_VER_INFO
	int nIndex;
	#endif

	s_bl2_to_bl3x_send_t *pSndMaster = aml_get_t_master();

	if ( !pSndMaster )
		goto exit;

	if ( AML_BL2_TMASTER_MAGIC != pSndMaster->hdr.nMagic)
	{
		//first run which need initialize
		memset(pSndMaster,0,sizeof(*pSndMaster));

		pSndMaster->hdr.nMagic    = AML_BL2_TMASTER_MAGIC;       //magic @BL2
		pSndMaster->hdr.nVersion  = AML_BL2_TMASTER_VERSION;     //version: major | minor
		pSndMaster->hdr.nHeadSize = sizeof(s_bl2_to_bl3x_hdr_t); //size of hdr
		pSndMaster->hdr.pNextBlob = pSndMaster->blob;            //active item
		pSndMaster->hdr.pNextBlob->pNextItem = 0;                //next item is NULL

		//copy BL2 info one by one and limit to sizeof(szBL2Info)
		#ifdef CONFIG_AML_TLV_BL2_VER_INFO
		for ( nIndex = 0;build_message[nIndex] && nIndex < sizeof(pSndMaster->hdr.szBL2Info); ++nIndex)
			pSndMaster->hdr.szBL2Info[nIndex] = build_message[nIndex];
		#endif
	}

	eReturn = e_err_in_data;
	//check input data
	if (!pData )
		goto exit;

	//check input length
	eReturn = e_err_in_size;
	if (!nLength)
		goto exit;

	unsigned int nStoreLength = AML_BL2_TMASTER_ITEM_ALIGN_LEN(nLength);

	eReturn = e_err_over_size;

	//check whether the transfer buffer is overflow or not with this new input
	if (AML_BL2_TMASTER_DDR_MLEN <= (pSndMaster->hdr.nTotalSize + nStoreLength))
		goto exit;

	eReturn = e_err_item_exit;
	s_bl2_tlv_item_t *pItem = 0;
	if ( e_ok_ret == aml_fetch_item(nType, &pItem))
		goto exit;

	//total counter +1
	pSndMaster->hdr.nTLVCount +=1;

	//set item data & info
	pSndMaster->hdr.pNextBlob->nType = nType;
	pSndMaster->hdr.pNextBlob->nLength = nLength;
	pSndMaster->hdr.pNextBlob->nStoreLength = nStoreLength;
	memcpy(pSndMaster->hdr.pNextBlob->szContent,pData,nLength);

	//clean the padding buffer
	if ( nStoreLength > nLength )
			memset(pSndMaster->hdr.pNextBlob->szContent + nLength,0,(nStoreLength - nLength));

	//update total size
	pSndMaster->hdr.nTotalSize += (sizeof(s_bl2_tlv_item_t) - 4 + nStoreLength);

	//shift the next active item
	pSndMaster->hdr.pNextBlob->pNextItem = (s_bl2_tlv_item_t*)(pSndMaster->hdr.pNextBlob->szContent + nStoreLength);

  //update next active item
	pSndMaster->hdr.pNextBlob = pSndMaster->hdr.pNextBlob->pNextItem;

	//init active item
	memset(pSndMaster->hdr.pNextBlob,0,sizeof(s_bl2_tlv_item_t));

#ifdef BL2_ACS_OFFSET
	//update sha2 of TLVs
	sha2((void*)pSndMaster->blob,pSndMaster->hdr.nTotalSize,pSndMaster->hdr.szSHA2TLV,0);

	//update sha2 of head which include sha2 of TLVs
	sha2((void*)pSndMaster,pSndMaster->hdr.nHeadSize ,pSndMaster->szSHA2Head,0);
#else
	sha256_csum_wd((void*)pSndMaster->blob,pSndMaster->hdr.nTotalSize,
		pSndMaster->hdr.szSHA2TLV,pSndMaster->hdr.nHeadSize);
	sha256_csum_wd((void*)pSndMaster,pSndMaster->hdr.nHeadSize ,
		pSndMaster->szSHA2Head,pSndMaster->hdr.nHeadSize);
#endif
	//success
	eReturn = e_ok_ret;

exit:

	return eReturn;
}

//IMPORTANT: BECAUSE THIS FUNCTION WILL USE DDR AS STORAGE(DEFAULT) THEN
//           ALL THE APIS MSUT BE USED AFTER DDR INIT DONE


//feature : fetch the item from list with nType
//para list:
//               nType[IN]       :   unique ID for item
//               ppItem[OUT]  :   item found which has the matched type nType
//
//return   :  e_err_not_support : BL33 not support valid address for TLV
//               e_ok_ret  : found the item and return with ppItem
//               e_err_sha_hdr : head sha2 check fail
//               e_err_sha_tlv  : TLV sha2 check fail
//               e_err_no_item : no item match the type nType

e_ret_type aml_fetch_item(unsigned int nType, s_bl2_tlv_item_t **ppItem)
{
	e_ret_type eReturn = e_err_not_support;
	s_bl2_to_bl3x_send_t *pSndMaster = aml_get_t_master();
	s_bl2_tlv_item_t *pItem = 0;
	unsigned char szSHA2[32];

	if ( ppItem )
		*ppItem = 0;

	if ( !pSndMaster )
		goto exit;

	eReturn = e_err_no_item;

    //check TLV's counter
	if (!pSndMaster->hdr.nTLVCount)
		goto exit;

	eReturn = e_err_sha_hdr;

	//check sha2 of header
#ifdef BL2_ACS_OFFSET
	sha2((void*)pSndMaster,pSndMaster->hdr.nHeadSize ,szSHA2,0);
#else
	sha256_csum_wd((void*)pSndMaster,pSndMaster->hdr.nHeadSize,
		szSHA2,pSndMaster->hdr.nHeadSize);
#endif

	if (memcmp(szSHA2,pSndMaster->szSHA2Head,sizeof(szSHA2)))
		goto exit;

	eReturn = e_err_sha_tlv;

	//check sha2 of TLVs
#ifdef BL2_ACS_OFFSET
	sha2((void*)pSndMaster->blob,pSndMaster->hdr.nTotalSize,szSHA2,0);
#else
	sha256_csum_wd((void*)pSndMaster->blob,pSndMaster->hdr.nTotalSize,
		szSHA2,pSndMaster->hdr.nTotalSize);
#endif

	if (memcmp(szSHA2,pSndMaster->hdr.szSHA2TLV,sizeof(szSHA2)))
		goto exit;

  //first item
	pItem = pSndMaster->blob;

  //check the list
	while (pItem->nLength)
	{
		if ( nType == pItem->nType)
			break;

		pItem = pItem->pNextItem;
	}

	//check valid item or not with length
	if (pItem->nLength)
		eReturn = e_ok_ret;
	else
	{
		pItem = 0;
		eReturn = e_err_no_item;
	}

	*ppItem = pItem;

exit:

	return eReturn;
}

#endif //#ifdef CONFIG_AML_SUPPORT_TLV
