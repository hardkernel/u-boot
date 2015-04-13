/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 */

#ifndef __BL2_CACHE_H_
#define __BL2_CACHE_H_

void disable_mmu_el1(void); /*disable mmu dcache*/
void disable_mmu_icache_el1(void); /*disable mmu dcache icache*/

#endif /*__BL2_CACHE_H_*/