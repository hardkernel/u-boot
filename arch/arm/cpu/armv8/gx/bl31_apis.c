/*
 *  Copyright (C) 2002 ARM Ltd.
 *  All Rights Reserved
 *  Copyright (c) 2010, Code Aurora Forum. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

/*
 * Trustzone API
 *
 * Copyright (C) 2012 Amlogic, Inc.
 *
 * Author: Platform-BJ@amlogic.com
 *
 */

#include <asm/arch/io.h>
#include <asm/arch/efuse.h>
#include <asm/cache.h>
//#include <asm/system.h>
#include <asm/arch/bl31_apis.h>

static long sharemem_input_base;
static long sharemem_output_base;

#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"

static long get_sharemem_info(unsigned function_id)
{
	asm volatile(
		__asmeq("%0", "x0")
		"smc    #0\n"
		: "+r" (function_id));

	return function_id;
}

#ifdef CONFIG_EFUSE
int32_t meson_trustzone_efuse(struct efuse_hal_api_arg* arg)
{
	int ret;
	unsigned cmd, offset, size;
	unsigned long *retcnt=(unsigned long*)(arg->retcnt_phy);

	if (!sharemem_input_base)
		sharemem_input_base = get_sharemem_info(GET_SHARE_MEM_INPUT_BASE);
	if (!sharemem_output_base)
		sharemem_output_base = get_sharemem_info(GET_SHARE_MEM_OUTPUT_BASE);

	if (arg->cmd == EFUSE_HAL_API_READ)
		cmd = EFUSE_READ;
	else if(arg->cmd == EFUSE_HAL_API_WRITE)
		cmd = EFUSE_WRITE;
	else
		cmd = EFUSE_WRITE_PATTERN;
	offset = arg->offset;
	size = arg->size;

	if (arg->cmd == EFUSE_HAL_API_WRITE)
		memcpy((void*)sharemem_input_base, (const void*)arg->buffer_phy, size);
	asm __volatile__("": : :"memory");

	register uint64_t x0 asm("x0") = cmd;
	register uint64_t x1 asm("x1") = offset;
	register uint64_t x2 asm("x2") = size;
	do {
		asm volatile(
		    __asmeq("%0", "x0")
		    __asmeq("%1", "x0")
		    __asmeq("%2", "x1")
		    __asmeq("%3", "x2")
		    "smc    #0\n"
		    : "=r"(x0)
		    : "r"(x0), "r"(x1), "r"(x2));
	} while (0);
	ret = x0;
	*retcnt = x0;

	if ((arg->cmd == EFUSE_HAL_API_READ) && (ret != 0))
		memcpy((void*)arg->buffer_phy, (const void*)sharemem_output_base, ret);

	if (!ret)
		return -1;
	else
		return 0;
}

ssize_t meson_trustzone_efuse_writepattern(const char *buf, size_t count)
{
	struct efuse_hal_api_arg arg;
	unsigned long retcnt;

	if (count != EFUSE_BYTES)
		return 0;	/* Past EOF */

	arg.cmd=EFUSE_HAL_API_WRITE_PATTERN;
	arg.offset = 0;
	arg.size=count;
	arg.buffer_phy=(unsigned long)buf;
	arg.retcnt_phy=(unsigned long)&retcnt;
	int ret;
	ret = meson_trustzone_efuse(&arg);
	return ret;
}

#endif




uint64_t meson_trustzone_efuse_check(unsigned char *addr)
{
	uint64_t ret = 0;
	struct sram_hal_api_arg arg = {};

	arg.cmd = SRAM_HAL_API_CHECK_EFUSE;
	arg.req_len = 0x1000000;
	arg.res_len = 0;
	arg.req_phy_addr = (unsigned long)addr;
	arg.res_phy_addr = (unsigned long)NULL;

	asm __volatile__("": : :"memory");

	register uint64_t x0 asm("x0") = CALL_TRUSTZONE_HAL_API;
	register uint64_t x1 asm("x1") = TRUSTZONE_HAL_API_SRAM;
	register uint64_t x2 asm("x2") = (unsigned long)(&arg);
	do {
		asm volatile(
		    __asmeq("%0", "x0")
		    __asmeq("%1", "x0")
		    __asmeq("%2", "x1")
		    __asmeq("%3", "x2")
		    "smc #0 \n"
		    : "=r"(x0)
		    : "r"(x0), "r"(x1), "r"(x2));
	} while (0);

	ret = x0;

	return ret;
}
