/*
 * (C) Copyright 2009
 * Marvell Semiconductor <www.marvell.com>
 * Written-by: Prafulla Wadaskar <prafulla@marvell.com>
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301 USA
 */

#ifndef _ASM_CACHE_H
#define _ASM_CACHE_H

#include <asm/system.h>

/*
 * Invalidate L2 Cache using co-proc instruction
 */
static inline void invalidate_l2_cache(void)
{
	unsigned int val=0;

	asm volatile("mcr p15, 1, %0, c15, c11, 0 @ invl l2 cache"
		: : "r" (val) : "cc");
	isb();
}

void l2_cache_enable(void);
void l2_cache_disable(void);
int  l2_cache_status(void);
void cache_flush(void);
void dcache_flush(void);
void flush_cache (unsigned long dummy1, unsigned long dummy2);

void dcache_flush_range(unsigned start, unsigned size);
void dcache_clean_range(unsigned start,unsigned size);
void dcache_invalid_range(unsigned start, unsigned size);

/* implemented in cache_v7.s */
void _invalidate_dcache(void);
void _clean_dcache(void);
void _clean_invd_dcache(void);
void _clean_dcache_addr(unsigned long addr);
void _invalidate_dcache_addr2(unsigned long addr);
void _invalidate_dcache_addr(unsigned long addr);
void _clean_invd_dcache_addr(unsigned long addr);
void _invalidate_icache(void);

void icache_invalid(void);
void dcache_invalid(void);
void dcache_clean(void);

#endif /* _ASM_CACHE_H */
