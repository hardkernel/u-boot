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

#include <common.h>
#include <asm/arch/bl31_apis.h>
#include "anti-rollback.h"

#define FUNCID_ANTIROLLBACK_VERSION_CHECK     0xb2000010

#define FUNCID_AVB_VERSION_SET                0xb2000011
#define FUNCID_AVB_VERSION_GET                0xb2000012
#define FUNCID_AVB_LOCK_STATE_GET             0xb2000013
#define FUNCID_AVB_LOCK                       0xb2000014
#define FUNCID_AVB_UNLOCK                     0xb2000015

#define IMAGE_VERSION_TYPE_BOOTLOADER         0x001
#define IMAGE_VERSION_TYPE_RECOVERY           0x002
#define IMAGE_VERSION_TYPE_BOOT               0x003

#define KERNEL_TYPE_UNKNOWN                   0x00
#define KERNEL_TYPE_BOOT                      0x01
#define KERNEL_TYPE_RECOVERY                  0x02

static uint32_t antirollback_image_version_check(uint32_t type,
							uint32_t version)
{
	register uint32_t x0 asm("x0") = FUNCID_ANTIROLLBACK_VERSION_CHECK;
	register uint32_t x1 asm("x1") = type;
	register uint32_t x2 asm("x2") = version;

	do {
		asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x0")
			__asmeq("%2", "x1")
			__asmeq("%3", "x2")
			"smc	#0\n"
			: "=r"(x0)
			: "r"(x0), "r"(x1), "r"(x2));
	} while (0);

	return x0;
}

bool check_antirollback(uint32_t kernel_version)
{
	bool ret = true;
	uint32_t type = (kernel_version >> 24);
	uint32_t version = ((kernel_version << 8) >> 8);
	if (KERNEL_TYPE_BOOT == type) {
		if (antirollback_image_version_check(IMAGE_VERSION_TYPE_BOOT,
							version) != 0) {
			printf("checking boot.img version failed\n");
			ret = false;
		}
	}
	else if (KERNEL_TYPE_RECOVERY == type) {
		if (antirollback_image_version_check(
					IMAGE_VERSION_TYPE_RECOVERY,
					version) != 0) {
			printf("checking recovery.img version failed\n");
			ret = false;
		}
	}
	else {
		printf("the kernel type is unknown\n");
		ret = false;
	}

	if (ret)
		printf("checking version success\n");

	return ret;
}

bool set_avb_antirollback(uint32_t index, uint32_t version)
{
	register uint32_t x0 asm("x0") = FUNCID_AVB_VERSION_SET;
	register uint32_t x1 asm("x1") = index;
	register uint32_t x2 asm("x2") = version;

	do {
		asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x0")
			__asmeq("%2", "x1")
			__asmeq("%3", "x2")
			"smc	#0\n"
			: "=r"(x0)
			: "r"(x0), "r"(x1), "r"(x2));
	} while (0);

	return 0 == x0;
}

bool get_avb_antirollback(uint32_t index, uint32_t* version)
{
	register uint32_t x0 asm("x0") = FUNCID_AVB_VERSION_GET;
	register uint32_t x1 asm("x1") = index;

	do {
		asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x1")
			__asmeq("%2", "x0")
			__asmeq("%3", "x1")
			"smc	#0\n"
			: "=r"(x0), "=r"(x1)
			: "r"(x0), "r"(x1));
	} while (0);

	if (0 == x0)
		*version = x1;

	return 0 == x0;
}

bool get_avb_lock_state(uint32_t* lock_state)
{
	register uint32_t x0 asm("x0") = FUNCID_AVB_LOCK_STATE_GET;
	register uint32_t x1 asm("x1") = 0;

	do {
		asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x1")
			__asmeq("%2", "x0")
			"smc	#0\n"
			: "=r"(x0), "=r"(x1)
			: "r"(x0));
	} while (0);

	if (0 == x0)
		*lock_state = x1;

	return 0 == x0;
}

bool avb_lock(void)
{
	register uint32_t x0 asm("x0") = FUNCID_AVB_LOCK;

	do {
		asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x0")
			"smc	#0\n"
			: "=r"(x0)
			: "r"(x0));
	} while (0);

	return 0 == x0;
}

bool avb_unlock(void)
{
	register uint32_t x0 asm("x0") = FUNCID_AVB_UNLOCK;

	do {
		asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x0")
			"smc	#0\n"
			: "=r"(x0)
			: "r"(x0));
	} while (0);

	return 0 == x0;
}
