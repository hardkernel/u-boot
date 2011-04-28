/*
 * mach/sram.h - Meson simple SRAM allocator
 *
 * Copyright (C) 2010 Robin Zhu
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#ifndef __MACH_SRAM_H
#define __MACH_SRAM_H

#define SRAM_SIZE       (127*1024 + 512)
#define SRAM_GRANULARITY    512

#define REBOOT_MODE_OFFSET (SRAM_SIZE + SRAM_GRANULARITY - 4) /*  */

/*
 * SRAM allocations return a CPU virtual address, or NULL on error.
 */
extern void *sram_alloc(size_t len);
extern void sram_free(void *addr, size_t len);

#endif /* __MACH_SRAM_H */
