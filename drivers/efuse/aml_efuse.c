/*
 * Copyright (C) 2014-2018 Amlogic, Inc. All rights reserved.
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
 *
 * Copyright (C) 2018 Amlogic, Inc. All rights reserved.
*/

#include <common.h>
#include <asm/arch/io.h>
#include <amlogic/aml_efuse.h>
#include <asm/arch/secure_apb.h>

//weak function for EFUSE license query
//all following functions are defined with "weak" for customization of each SoC
//EFUSE_LICX	--> AO_SEC_SD_CFG10/9 --> EFUSE mirror
int  __attribute__((weak)) IS_FEAT_BOOT_VERIFY(void)
{
	#ifndef ADDR_IS_FEAT_BOOT_VERIFY
	  #ifdef EFUSE_LIC0
		  #define ADDR_IS_FEAT_BOOT_VERIFY (EFUSE_LIC0)
		  #define OSET_IS_FEAT_BOOT_VERIFY (0)
	  #else
		  #define ADDR_IS_FEAT_BOOT_VERIFY (AO_SEC_SD_CFG10)
		  #define OSET_IS_FEAT_BOOT_VERIFY (4)
	  #endif
	#endif

	return ((readl(ADDR_IS_FEAT_BOOT_VERIFY) >> OSET_IS_FEAT_BOOT_VERIFY) & 1);

	#undef ADDR_IS_FEAT_BOOT_VERIFY
	#undef OSET_IS_FEAT_BOOT_VERIFY
}
int  __attribute__((weak)) IS_FEAT_BOOT_ENCRYPT(void)
{
	#ifndef ADDR_IS_FEAT_BOOT_ENCRYPT
	  #ifdef EFUSE_LIC0
		#define ADDR_IS_FEAT_BOOT_ENCRYPT (EFUSE_LIC0)
		#define OSET_IS_FEAT_BOOT_ENCRYPT (1)
	  #else
		#define ADDR_IS_FEAT_BOOT_ENCRYPT (AO_SEC_SD_CFG10)
		#define OSET_IS_FEAT_BOOT_ENCRYPT (28)
	  #endif
	#endif

	return ((readl(ADDR_IS_FEAT_BOOT_ENCRYPT) >> OSET_IS_FEAT_BOOT_ENCRYPT) & 1);

	#undef ADDR_IS_FEAT_BOOT_ENCRYPT
	#undef OSET_IS_FEAT_BOOT_ENCRYPT
}
