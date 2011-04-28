/*
 * (C) Copyright 2007
 * Stelian Pop <stelian.pop@leadtechdesign.com>
 * Lead Tech Design <www.leadtechdesign.com>
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
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */
#ifndef __ASM_ARM_DMA_MAPPING_H
#define __ASM_ARM_DMA_MAPPING_H
#include <asm/arch/cpu.h>
#include <asm/io.h>
#include <asm/cache.h>
#include <asm/types.h>
#include <malloc.h>
enum dma_data_direction {
	DMA_BIDIRECTIONAL	= 0,
	DMA_TO_DEVICE		= 1,
	DMA_FROM_DEVICE		= 2,
};
//typedef unsigned long dma_addr_t;
static inline void *dma_alloc_coherent(size_t len, dma_addr_t *handle)
{
	void *addr = malloc(len + CONFIG_SYS_CACHE_LINE_SIZE);
	if (!addr)
		return 0;
	flush_cache((unsigned long)addr, len + CONFIG_SYS_CACHE_LINE_SIZE);
	*handle = (((((unsigned long)addr) + (CONFIG_SYS_CACHE_LINE_SIZE - 1)) &
		~(CONFIG_SYS_CACHE_LINE_SIZE - 1))& ~(IO_REGION_BASE))|IO_REGION_BASE;
	return addr;
}
static inline void dma_free_coherent(size_t len, dma_addr_t handle,void * addr)
{
	free(addr);
}

static inline dma_addr_t dma_map_single(void *vaddr, size_t len,
					   enum dma_data_direction dir)
{
	assert(dir<3&&dir>=0);
	switch (dir) {
	case DMA_BIDIRECTIONAL:
		dcache_flush_range((unsigned)vaddr, (unsigned)len);
		break;
	case DMA_TO_DEVICE:
		dcache_clean_range((unsigned)vaddr, (unsigned)len);
		break;
	case DMA_FROM_DEVICE:
		dcache_invalid_range((unsigned)vaddr, (unsigned)len);
		break;

	}
	return virt_to_phys(vaddr);
//	return (unsigned long)vaddr;
}

static inline void dma_unmap_single(void *vaddr, size_t len,
		dma_addr_t paddr)
{
}

#endif /* __ASM_ARM_DMA_MAPPING_H */
