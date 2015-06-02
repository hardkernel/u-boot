/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * Common defines
 */

#ifndef _BOOT_ROM_COMMON_H
#define _BOOT_ROM_COMMON_H

#include <stdint.h>
#include <stddef.h>
#include "rsa_config.h"

#ifdef CONFIG_EMU_BUILD
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#endif /* CONFIG_EMU_BUILD */

#define setbits_le32(reg, val)		(*((volatile uint32_t *)((uintptr_t)(reg)))) |= (val)
#define clrbits_le32(reg, val)		(*((volatile uint32_t *)((uintptr_t)(reg)))) &= (~(val))
#define writel32(val, reg)		(*((volatile uint32_t *)((uintptr_t)(reg)))) =  (val)
#define readl32(reg)			(*((volatile uint32_t *)((uintptr_t)(reg))))

#if 0
static inline void writel32(uint32_t value, uintptr_t addr)
{
        *(volatile uint32_t*)addr = value;
}

static inline uint32_t readl32(uintptr_t addr)
{
        return *(volatile uint32_t*)addr;
}
#endif

#define writel	writel32
#define readl	readl32

void print_str(const char *str);
void print_u32(unsigned int data);

#undef DEBUG
#ifdef DEBUG
#define print_error 	print_str
#define print_out	print_str
#define print_info	print_str
#define print_dbg	print_str
#define print_dbg_u32	print_u32
#else
#define dummy_print(a)	do{} while(0);
#define print_error 	print_str
#define print_out	print_str
#define print_info(a)	dummy_print(a)
#define print_dbg(a)	dummy_print(a)
#define print_dbg_u32(a) dummy_print(a)
#endif

#ifdef CONFIG_EMU_BUILD
#define ss_printf	printf
#else
#define ss_printf(...)
#endif /* CONFIG_EMU_BUILD */

#endif /* _BOOT_ROM_COMMON_H */
