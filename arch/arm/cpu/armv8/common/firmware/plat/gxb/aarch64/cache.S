/*
 * (C) Copyright 2013
 * David Feng <fenghua@phytium.com.cn>
 *
 * This file is based on sample code from ARMv8 ARM.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <arch.h>
#include <asm_macros.S>

	.global disable_mmu_el1
	.global disable_mmu_icache_el1

/*
 * void disable_mmu_el1(void)
 *
 * disable mmu and dcache.
 */
func disable_mmu_el1
	mov	x1, #(SCTLR_M_BIT | SCTLR_C_BIT)
do_disable_mmu:
	mrs	x0, sctlr_el1
	bic	x0, x0, x1
	msr	sctlr_el1, x0
	isb				// ensure MMU is off
	mov	x0, #DCCISW		// DCache clean and invalidate
	b	dcsw_op_all

/*
 * void disable_mmu_icache_el1(void)
 *
 * disable mmu and dcache.
 */
func disable_mmu_icache_el1
	mov	x1, #(SCTLR_M_BIT | SCTLR_C_BIT | SCTLR_I_BIT)
	b	do_disable_mmu