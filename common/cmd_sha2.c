/*
 * Copyright (C) 2014-2017 Amlogic, Inc. All rights reserved.
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
 */
/*
 * Functions in this file implement Amlogic SHA2 function
 *
 * Author : zhongfu.luo@amlogic.com
 *
 * Feature: implement uboot command for SHA2 common usage
 *          command : sha2 addr_in len [addr_out]
 *                         addr_in[IN]  : DDR address for input buffer
 *                         len[IN]      : total data size to be processed for SHA2
 *                         addr_out[OUT]: user defined output buffer for the SHA2 (if not set then the SHA2 of input will shown only but not stored)
 *
 * History: 1. 2017.06.01 function init
 *
 *
*/

#include <common.h>
#include <malloc.h>
#include <asm/arch/regs.h>
#include <u-boot/sha256.h>

#define DATA_MAX_LEN    (100<<20) //max length of SHA2 is 100MB
static int do_sha2(cmd_tbl_t *cmdtp, int flag, int argc,
			char * const argv[])
{
	int nReturn=CMD_RET_USAGE;
	ulong addr_in,nLength,addr_out=0;
	unsigned char szSHA2[32];
	unsigned char *pSHA2 = szSHA2;
	int nSHA2Type = 256;
	char *endp;
	int i;

	/* need at least three arguments */
	if (argc < 3)
		goto exit;

	nReturn = __LINE__;

	if ( 0 == *argv[1] )
	{
		printf("[addr_in] format error! \n" );
		goto exit;
	}
	addr_in = simple_strtoul(argv[1], &endp, 16);
	if ( 0 != *endp )
	{
		printf("[addr_in] format error! \n" );
		goto exit;
	}
	nReturn = __LINE__;

	if ( 0 == *argv[2])
	{
		printf("[Length] format error! \n" );
		goto exit;
	}
	nLength = simple_strtoul(argv[2], &endp, 16);
	if (  0 != *endp )
	{
		printf("[Length] format error! \n" );
		goto exit;
	}
	if ( !nLength || nLength > DATA_MAX_LEN)
		{
			printf("Length range: 0x00000001 ~ 0x%08x Byte! \n", DATA_MAX_LEN );
			goto exit;
		}

	nReturn = __LINE__;



	if (argc > 3)
	{
		if ( 0 == *argv[3] )
		{
			printf("[addr_out] format error! \n" );
			goto exit;
		}
		addr_out = simple_strtoul(argv[3], &endp, 16);
		if ( 0 != *endp )
		{
			printf("[addr_out] format error! \n" );
			goto exit;
		}
		pSHA2=(unsigned char *)addr_out;
	}


	sha256_csum_wd((unsigned char *)addr_in, nLength,pSHA2,0);

	if (argc > 3)
	printf("\nSHA%d of addr_in: 0x%08x, len: 0x%08x, addr_out: 0x%08x \n", nSHA2Type, (unsigned int)addr_in, (unsigned int)nLength,(unsigned int)addr_out);
	else
	printf("\nSHA%d of addr_in: 0x%08x, len: 0x%08x \n", nSHA2Type, (unsigned int)addr_in, (unsigned int)nLength);


	for (i=0; i<SHA256_SUM_LEN; i++)
		printf("%02x%s", pSHA2[i], ((i+1) % 16==0) ? "\n" :" ");

	nReturn = 0;

exit:

	return nReturn;
}

#undef DATA_MAX_LEN

U_BOOT_CMD(
	sha2, 4,	1,	do_sha2,
	"SHA2 command",
	"addr_in len [addr_out] \n"
);



/*
 * Feature: implement uboot command for test SHA2 common usage
 *          command : sha2test [writeval] [len]
 *                         writeval[IN]  : the value of data for test(default is 0x01)
 *                         len[IN]      : total data size to be processed for SHA2 (default is 128k bytes)
 *
 * History: 1. 2017.06.01 function init
 *
 *
*/

//#define CONFIG_AML_SHA2_TEST
#if defined(CONFIG_AML_SHA2_TEST)

#define writel(val,reg) (*((volatile unsigned *)(reg)))=(val)
#define readl(reg)		(*((volatile unsigned *)(reg)))
#define TEST_MAX_LEN    (10<<20)
#define TEST_MIN_LEN    (64)

static int do_sha2test(cmd_tbl_t *cmdtp, int flag, int argc,
			char * const argv[])
{

	int nReturn = __LINE__;
	unsigned char *pBuffer = 0;

	int i;
	int nLength = TEST_MAX_LEN;
	unsigned int byPattern = 1;
	char *endp;
	int nSHA2Type = 256;
	unsigned int ntime1,ntime2,ntime;
	unsigned char szSHA2[32];
	int testLength[8]={TEST_MAX_LEN,1024*1024,100*1024,10*1024,1024,512,128,TEST_MIN_LEN};
	int c=0;

	#ifdef CONFIG_AML_HW_SHA2
		printf("aml log : Amlogic HW SHA2 \n");
	#else
		printf("aml log : Software SHA2 \n");
	#endif


	//pattern
	if (argc > 1)
	{
		if ( 0 == *argv[1] )
		{
			printf("[writeval] format error! \n" );
			goto exit;
		}
		byPattern = simple_strtoul(argv[1], &endp, 16);
		if ( 0 != *endp )
		{
			printf("[writeval] format error! \n" );
			goto exit;
		}
		if (  byPattern > 0xff)
		{
			printf("writeval range: 0x00 ~ 0xff! \n" );
			goto exit;
		}

	}

	nReturn = __LINE__;

	//length
	if (argc > 2)
	{
		if ( 0== *argv[2] )
		{
			printf("[Length] format error! \n" );
			goto exit;
		}
		nLength = simple_strtoul(argv[2], &endp, 16);
		if ( 0 != *endp )
		{
			printf("[Length] format error! \n" );
			goto exit;
		}

		if ( !nLength || nLength > TEST_MAX_LEN)
		{
			printf("Length range: 0x00000001 ~ 0x%08x Byte! \n", TEST_MAX_LEN );
			goto exit;
		}
	}

	nReturn = __LINE__;

	pBuffer=(unsigned char*)malloc(nLength);

	if (!pBuffer)
		{
		printf("malloc fail! \n" );
		goto exit;
	}

	//set buffer with dedicated pattern
	memset(pBuffer,byPattern,nLength);


	do
	{
		ntime1=readl(P_ISA_TIMERE);
		sha256_csum_wd(pBuffer, nLength,szSHA2,0 );
		ntime2=readl(P_ISA_TIMERE);

		ntime = ntime2 - ntime1;

		printf("\nSHA%d of value: 0x%02x, len: 0x%08x, time used: %d us, bandwidth: %d kB/s \n",\
			nSHA2Type, (unsigned int)byPattern, nLength,ntime, (unsigned int)((float)nLength/1024/ntime*1000000));

		//SHA2 dump
		for (i=0; i<SHA256_SUM_LEN; i++)
			printf("%02x%s", szSHA2[i], ((i+1) % 16==0) ? "\n" :" ");

		if (argc > 2)
			break;

		nLength =testLength[++c];
	}
	while (nLength > TEST_MIN_LEN) ;

	nReturn = 0;

exit:

	if (pBuffer)
	{
		free(pBuffer);
		pBuffer = 0;
	}

	return nReturn;

}

#undef writel
#undef readl
#undef TEST_MAX_LEN
#undef TEST_MIN_LEN

U_BOOT_CMD(
	sha2test, 3,	1,	do_sha2test,
	"test SHA2 fuction",
	"[writeval] [len] \n"
);

#endif //#if defined(CONFIG_AML_SHA2_TEST)