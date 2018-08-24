/*
 * arch/arm/cpu/armv8/txlx/bl31_apis.c
 *
 * Copyright (C) 2014-2017 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

/*
 * Trustzone API
 */

#include <asm/arch/io.h>
#include <asm/arch/efuse.h>
#include <asm/cache.h>
#include <asm/arch/bl31_apis.h>
#include <asm/cpu_id.h>
#include <asm/arch/secure_apb.h>

static long sharemem_input_base;
static long sharemem_output_base;

long get_sharemem_info(unsigned long function_id)
{
	asm volatile(
		__asmeq("%0", "x0")
		"smc    #0\n"
		: "+r" (function_id));

	return function_id;
}

#ifdef CONFIG_EFUSE
int32_t meson_trustzone_efuse(struct efuse_hal_api_arg *arg)
{
	int ret;
	unsigned cmd, offset, size;
	unsigned long *retcnt = (unsigned long *)(arg->retcnt_phy);

	if (!sharemem_input_base)
		sharemem_input_base =
			get_sharemem_info(GET_SHARE_MEM_INPUT_BASE);
	if (!sharemem_output_base)
		sharemem_output_base =
			get_sharemem_info(GET_SHARE_MEM_OUTPUT_BASE);

	if (arg->cmd == EFUSE_HAL_API_READ)
		cmd = EFUSE_READ;
	else if (arg->cmd == EFUSE_HAL_API_WRITE)
		cmd = EFUSE_WRITE;
	else
		cmd = EFUSE_WRITE_PATTERN;
	offset = arg->offset;
	size = arg->size;

	if (arg->cmd == EFUSE_HAL_API_WRITE)
		memcpy((void *)sharemem_input_base,
		       (const void *)arg->buffer_phy, size);
		asm __volatile__("" : : : "memory");

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
		memcpy((void *)arg->buffer_phy,
		       (const void *)sharemem_output_base, ret);

	if (!ret)
		return -1;
	else
		return 0;
}

int32_t meson_trustzone_efuse_get_max(struct efuse_hal_api_arg *arg)
{
	int32_t ret;
	unsigned cmd;

	if (arg->cmd == EFUSE_HAL_API_USER_MAX)
		cmd = EFUSE_USER_MAX;

	asm __volatile__("" : : : "memory");

	register uint64_t x0 asm("x0") = cmd;

	do {
		asm volatile(
		    __asmeq("%0", "x0")
		    __asmeq("%1", "x0")
		    "smc    #0\n"
		    : "=r"(x0)
		    : "r"(x0));
	} while (0);
	ret = x0;

	if (!ret)
		return -1;
	else
		return ret;
}

ssize_t meson_trustzone_efuse_writepattern(const char *buf, size_t count)
{
	struct efuse_hal_api_arg arg;
	unsigned long retcnt;

	if (count != EFUSE_BYTES)
		return 0;	/* Past EOF */

	arg.cmd = EFUSE_HAL_API_WRITE_PATTERN;
	arg.offset = 0;
	arg.size = count;
	arg.buffer_phy = (unsigned long)buf;
	arg.retcnt_phy = (unsigned long)&retcnt;
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

	asm __volatile__("" : : : "memory");

	register uint64_t x0 asm("x0") = CALL_TRUSTZONE_HAL_API;
	register uint64_t x1 asm("x1") = TRUSTZONE_HAL_API_SRAM;
	register uint64_t x2 asm("x2") = (unsigned long)(&arg);
	do {
		asm volatile(
		    __asmeq("%0", "x0")
		    __asmeq("%1", "x0")
		    __asmeq("%2", "x1")
		    __asmeq("%3", "x2")
		    "smc #0\n"
		    : "=r"(x0)
		    : "r"(x0), "r"(x1), "r"(x2));
	} while (0);

	ret = x0;

	return ret;
}

void debug_efuse_cmd(unsigned long cmd)
{
	asm volatile(
		__asmeq("%0", "x0")
		"smc    #0\n"
		: : "r" (cmd));
}

void bl31_debug_efuse_write_pattern(const char *buf)
{
	if (!sharemem_input_base)
		sharemem_input_base =
			get_sharemem_info(GET_SHARE_MEM_INPUT_BASE);
	memcpy((void *)sharemem_input_base, (const void *)buf, 512);

	debug_efuse_cmd(DEBUG_EFUSE_WRITE_PATTERN);
}

void bl31_debug_efuse_read_pattern(char *buf)
{
	if (!sharemem_output_base)
		sharemem_output_base =
			get_sharemem_info(GET_SHARE_MEM_OUTPUT_BASE);
	debug_efuse_cmd(DEBUG_EFUSE_READ_PATTERN);

	memcpy((void *)buf, (const void *)sharemem_output_base, 512);
}

void aml_set_jtag_state(unsigned state, unsigned select)
{
	uint64_t command;
	if (state == JTAG_STATE_ON)
		command = JTAG_ON;
	else
		command = JTAG_OFF;
	asm __volatile__("" : : : "memory");

	asm volatile(
		__asmeq("%0", "x0")
		__asmeq("%1", "x1")
		"smc    #0\n"
		: : "r" (command), "r"(select));
}

unsigned aml_get_reboot_reason(void)
{
	unsigned reason;
	uint64_t ret;

	register uint64_t x0 asm("x0") = GET_REBOOT_REASON;
	asm volatile(
		__asmeq("%0", "x0")
		"smc #0\n"
		:"+r"(x0));
		ret = x0;
		reason = (unsigned)(ret&0xffffffff);
		return reason;
}

void set_viu_probe_enable(void)
{
	register uint64_t x0 asm("x0") = VIU_PREOBE_EN;

	asm volatile(
			__asmeq("%0", "x0")
			"smc #0\n"
			:"+r"(x0));
}
unsigned aml_reboot(uint64_t function_id, uint64_t arg0, uint64_t arg1, uint64_t arg2)
{
	register long x0 asm("x0") = function_id;
	register long x1 asm("x1") = arg0;
	register long x2 asm("x2") = arg1;
	register long x3 asm("x3") = arg2;
	asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x1")
			__asmeq("%2", "x2")
			__asmeq("%3", "x3")
			"smc	#0\n"
		: "+r" (x0)
		: "r" (x1), "r" (x2), "r" (x3));

	return function_id;
}

void aml_set_reboot_reason(uint64_t function_id, uint64_t arg0, uint64_t arg1, uint64_t arg2)
{
	register long x0 asm("x0") = function_id;
	register long x1 asm("x1") = arg0;
	register long x2 asm("x2") = arg1;
	register long x3 asm("x3") = arg2;
	asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x1")
			__asmeq("%2", "x2")
			__asmeq("%3", "x3")
			"smc	#0\n"
			: "+r" (x0)
			: "r" (x1), "r" (x2), "r" (x3));

	return ;
}

unsigned long aml_sec_boot_check(unsigned long nType,
	unsigned long pBuffer,
	unsigned long nLength,
	unsigned long nOption)
{
	uint64_t ret = 1;

//#define AML_SECURE_LOG_TE

#if defined(AML_SECURE_LOG_TE)
	#define AML_GET_TE(a) do{a = *((volatile unsigned int*)0xc1109988);}while(0);
	unsigned nT1,nT2,nT3;
#else
	#define AML_GET_TE(...)
#endif

	AML_GET_TE(nT1);

	asm __volatile__("" : : : "memory");

	register uint64_t x0 asm("x0") = AML_DATA_PROCESS;
	register uint64_t x1 asm("x1") = nType;
	register uint64_t x2 asm("x2") = pBuffer;
	register uint64_t x3 asm("x3") = nLength;
	register uint64_t x4 asm("x4") = nOption;

	do {
		asm volatile(
		    __asmeq("%0", "x0")
		    __asmeq("%1", "x0")
		    __asmeq("%2", "x1")
		    __asmeq("%3", "x2")
		    __asmeq("%4", "x3")
		    __asmeq("%5", "x4")
		    "smc #0\n"
		    : "=r"(x0)
		    : "r"(x0), "r"(x1), "r"(x2),"r"(x3),"r"(x4));
	} while (0);

	ret = x0;

	AML_GET_TE(nT2);;

	flush_dcache_range((unsigned long )pBuffer, (unsigned long )pBuffer+nLength);

	AML_GET_TE(nT3);

#if defined(AML_SECURE_LOG_TE)
	printf("aml log : dec use %d(us) , flush cache used %d(us)\n",
		nT2 - nT1, nT3 - nT2);
#endif

	return ret;
}

void set_usb_boot_function(unsigned long command)
{
	register long x0 asm("x0") = SET_USB_BOOT_FUNC;
	register long x1 asm("x1") = command;

	asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x1")
			"smc	#0\n"
		: "+r" (x0)
		: "r" (x1));
}

void aml_system_off(void)
{
	/* TODO: Add poweroff capability */
	aml_reboot(0x82000042, 1, 0, 0);
	aml_reboot(0x84000008, 0, 0, 0);
}

int __get_chip_id(unsigned char *buff, unsigned int size)
{
	if (buff == NULL || size < 16)
		return -1;

	if (!sharemem_output_base)
		sharemem_output_base =
			get_sharemem_info(GET_SHARE_MEM_OUTPUT_BASE);

	if (sharemem_output_base) {
		register long x0 asm("x0") = GET_CHIP_ID;
		register long x1 asm("x1") = 2;

		asm volatile(
			__asmeq("%0", "x0")
			__asmeq("%1", "x1")
				"smc	#0\n"
			: "+r" (x0)
			: "r" (x1));

		if (x0 == 0) {
			int version = *((unsigned int *)sharemem_output_base);

			if (version == 2) {
				memcpy(buff, (void *)sharemem_output_base + 4, 16);
			}
			else {
				/**
				 * Legacy 12-byte chip ID read out, transform data
				 * to expected order format.
				 */
				uint32_t chip_info = readl(P_AO_SEC_SD_CFG8);
				uint8_t *ch;
				int i;

				((uint32_t *)buff)[0] =
					((chip_info & 0xff000000)	|	// Family ID
					((chip_info << 8) & 0xff0000)	|	// Chip Revision
					((chip_info >> 8) & 0xff00));		// Package ID

				((uint32_t *)buff)[0] = htonl(((uint32_t *)buff)[0]);

				/* Transform into expected order for display */
				ch = (uint8_t *)(sharemem_output_base + 4);
				for (i = 0; i < 12; i++)
					buff[i + 4] = ch[11 - i];
			}

			return 0;
		}
	}

	return -1;
}
