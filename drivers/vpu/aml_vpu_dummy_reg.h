
/*
 * drivers/vpu/aml_vpu_reg.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
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

#ifndef __VPU_DUMMY_REG_H__
#define __VPU_DUMMY_REG_H__
#include <asm/arch/io.h>
#include <asm/arch/secure_apb.h>

#ifndef HHI_GP_PLL_CNTL
#define HHI_GP_PLL_CNTL                            (0xc1100000 + (0x1010 << 2))
#endif

#ifndef HHI_GP1_PLL_CNTL
#define HHI_GP1_PLL_CNTL                           (0xc883c000 + (0x16 << 2))
#endif
#ifndef HHI_GP1_PLL_CNTL2
#define HHI_GP1_PLL_CNTL2                          (0xc883c000 + (0x17 << 2))
#endif
#ifndef HHI_GP1_PLL_CNTL3
#define HHI_GP1_PLL_CNTL3                          (0xc883c000 + (0x18 << 2))
#endif
#ifndef HHI_GP1_PLL_CNTL4
#define HHI_GP1_PLL_CNTL4                          (0xc883c000 + (0x19 << 2))
#endif

#ifndef HHI_VPU_MEM_PD_REG2
#define HHI_VPU_MEM_PD_REG2                        (0xff63c000 + (0x4d << 2))
#endif
#ifndef HHI_VPU_MEM_PD_REG3
#define HHI_VPU_MEM_PD_REG3                        (0xff63c000 + (0x4e << 2))
#endif
#ifndef HHI_VPU_MEM_PD_REG4
#define HHI_VPU_MEM_PD_REG4                        (0xff63c000 + (0x4c << 2))
#endif

#ifndef DOLBY_TV_CLKGATE_CTRL
#define DOLBY_TV_CLKGATE_CTRL                      (0x33f1)
#endif
#ifndef DOLBY_CORE1_CLKGATE_CTRL
#define DOLBY_CORE1_CLKGATE_CTRL                   (0x33f2)
#endif
#ifndef DOLBY_CORE2A_CLKGATE_CTRL
#define DOLBY_CORE2A_CLKGATE_CTRL                  (0x3432)
#endif
#ifndef DOLBY_CORE3_CLKGATE_CTRL
#define DOLBY_CORE3_CLKGATE_CTRL                   (0x36f0)
#endif


#endif
