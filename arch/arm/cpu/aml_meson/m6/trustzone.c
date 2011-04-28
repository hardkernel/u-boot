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
#include <amlogic/efuse.h>
#include <asm/cache.h>
#include <asm/arch/trustzone.h>

#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"

/**
 * @brief meson_trustzone_rtc_read_reg32
 *
 * @param addr
 * @param value
 */
uint32_t meson_trustzone_rtc_read_reg32(uint32_t addr)
{
	register uint32_t r0 asm("r0") = 0x2;
	register uint32_t r1 asm("r1") = addr;
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1));
	} while (0);

	return r0;
}

/**
 * @brief meson_trustzone_rtc_write_reg32
 *
 * @param addr
 * @param value
 */
uint32_t meson_trustzone_rtc_write_reg32(uint32_t addr, uint32_t value)
{
	register uint32_t r0 asm("r0") = 0x3;
	register uint32_t r1 asm("r1") = addr;
	register uint32_t r2 asm("r2") = value;
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    __asmeq("%3", "r2")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1), "r"(r2));
	} while (0);

	return r0;
}

/**
 * @brief meson_trustzone_sram_read_reg32
 *
 * @param addr
 * @param value
 */
uint32_t meson_trustzone_sram_read_reg32(uint32_t addr)
{
	register uint32_t r0 asm("r0") = 0x2;
	register uint32_t r1 asm("r1") = addr;
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1));
	} while (0);

	return r0;
}

#ifdef CONFIG_AML_SUSPEND
/**
 * @brief meson_trustzone_suspend
 *
 * @suspend cmd smc entry
 */
uint32_t meson_trustzone_suspend(void)
{
	register uint32_t r0 asm("r0") = CALL_TRUSTZONE_MON;
	register uint32_t r1 asm("r1") = TRUSTZONE_MON_SUSPNED_FIRMWARE;

	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1));
	} while (0);

	return r0;
}

uint32_t meson_trustzone_suspend_uboot(void)
{
	register uint32_t r0 asm("r0") = CALL_TRUSTZONE_MON;
	register uint32_t r1 asm("r1") = TRUSTZONE_MON_SUSPNED_FIRMWARE_UBOOT;

	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1));
	} while (0);

	return r0;
}

uint32_t meson_trustzone_suspend_init(void)
{
	register uint32_t r0 asm("r0") = CALL_TRUSTZONE_MON;
	register uint32_t r1 asm("r1") = TRUSTZONE_MON_SUSPNED_FIRMWARE_INIT;

	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1));
	} while (0);

	return r0;
}
#endif //CONFIG_AML_SUSPEND

#ifdef CONFIG_EFUSE
int32_t meson_trustzone_efuse(struct efuse_hal_api_arg* arg)
{
	int ret;

	register int32_t r0 asm("r0") = CALL_TRUSTZONE_HAL_API;
	register uint32_t r1 asm("r1") = TRUSTZONE_HAL_API_EFUSE;
	register uint32_t r2 asm("r2") = (unsigned int)arg;
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    __asmeq("%3", "r2")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1), "r"(r2));
	} while (0);

	ret = r0;

	return ret;
}

ssize_t meson_trustzone_efuse_writepattern(const char *buf, size_t count)
{
	struct efuse_hal_api_arg arg;
	unsigned int retcnt;

	if (count != EFUSE_BYTES)
		return 0;	/* Past EOF */

	arg.cmd=EFUSE_HAL_API_WRITE_PATTERN;
	arg.offset = 0;
	arg.size=count;
	arg.buffer_phy=(unsigned int)buf;
	arg.retcnt_phy=&retcnt;
	int ret;
	ret = meson_trustzone_efuse(&arg);
	return ret;
}

#endif


#ifdef CONFIG_MESON_STORAGE_BURN
int32_t meson_trustzone_storage(struct storage_hal_api_arg* arg)
{
	int ret;

	register int32_t r0 asm("r0") = CALL_TRUSTZONE_HAL_API;
	register int32_t r1 asm("r1") = TRUSTZONE_HAL_API_STORAGE;
	register int32_t r2 asm("r2") = (unsigned int)arg;

	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    __asmeq("%3", "r2")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1), "r"(r2));
	} while (0);

	ret = r0;

	return ret;
}
#endif

uint32_t meson_trustzone_read_socrev1()
{
	register uint32_t r0 asm("r0") = CALL_TRUSTZONE_MON;
	register uint32_t r1 asm("r1") = TRUSTZONE_MON_CORE_RD_SOC_REV1;
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1));
	} while (0);

	return r0;
}

uint32_t meson_trustzone_read_socrev2()
{
	register uint32_t r0 asm("r0") = CALL_TRUSTZONE_MON;
	register uint32_t r1 asm("r1") = TRUSTZONE_MON_CORE_RD_SOC_REV2;
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1));
	} while (0);

	return r0;
}

#ifdef CONFIG_ACS
uint32_t meson_trustzone_acs_addr(uint32_t addr)
{
	unsigned int ret = 0;
	struct sram_hal_api_arg arg = {};


	arg.cmd = SRAM_HAL_API_CAS;
	arg.req_len = SECURE_OS_ACS_LEN;
	arg.res_len = SECURE_OS_ACS_LEN;

	if ((addr < SECURE_OS_ACS_SRAM_ADDR) || (addr > (SECURE_OS_ACS_SRAM_ADDR + SECURE_OS_ACS_LEN)))
		arg.req_phy_addr = *((volatile unsigned int*)addr);
	else
		arg.req_phy_addr = meson_trustzone_sram_read_reg32(addr);
	arg.res_phy_addr = SECURE_OS_ACS_DRAM_ADDR;
	asm __volatile__("": : :"memory");

	register uint32_t r0 asm("r0") = CALL_TRUSTZONE_HAL_API;
	register uint32_t r1 asm("r1") = TRUSTZONE_HAL_API_SRAM;
	register uint32_t r2 asm("r2") = (unsigned int)(&arg);
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    __asmeq("%3", "r2")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1), "r"(r2));
	} while (0);

	ret = arg.res_phy_addr;

	return ret;
}
#endif

uint32_t meson_trustzone_boot_check(unsigned char *addr)
{
	unsigned int ret = 0;
	struct sram_hal_api_arg arg = {};

	arg.cmd = SRAM_HAL_API_CHECK;
	arg.req_len = 0x1000000;
	arg.res_len = 0;
	arg.req_phy_addr = addr;
	arg.res_phy_addr = NULL;

	asm __volatile__("": : :"memory");

	register uint32_t r0 asm("r0") = CALL_TRUSTZONE_HAL_API;
	register uint32_t r1 asm("r1") = TRUSTZONE_HAL_API_SRAM;
	register uint32_t r2 asm("r2") = (unsigned int)(&arg);
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    __asmeq("%3", "r2")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1), "r"(r2));
	} while (0);

	ret = r0;

	return ret;
}

uint32_t meson_trustzone_efuse_check(unsigned char *addr)
{
	unsigned int ret = 0;
	struct sram_hal_api_arg arg = {};

	arg.cmd = SRAM_HAL_API_CHECK_EFUSE;
	arg.req_len = 0x1000000;
	arg.res_len = 0;
	arg.req_phy_addr = addr;
	arg.res_phy_addr = NULL;

	asm __volatile__("": : :"memory");

	register uint32_t r0 asm("r0") = CALL_TRUSTZONE_HAL_API;
	register uint32_t r1 asm("r1") = TRUSTZONE_HAL_API_SRAM;
	register uint32_t r2 asm("r2") = (unsigned int)(&arg);
	do {
		asm volatile(
		    __asmeq("%0", "r0")
		    __asmeq("%1", "r0")
		    __asmeq("%2", "r1")
		    __asmeq("%3", "r2")
		    "smc    #0  @switch to secure world\n"
		    : "=r"(r0)
		    : "r"(r0), "r"(r1), "r"(r2));
	} while (0);

	ret = r0;

	return ret;
}
