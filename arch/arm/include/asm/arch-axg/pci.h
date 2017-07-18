
/*
 * arch/arm/include/asm/arch-axg/pci.h
 *
 * Copyright (C) 2017 Amlogic, Inc. All rights reserved.
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

#ifndef __ARCH_ARM_MESON_PCI_H_U_BOOT__
#define __ARCH_ARM_MESON_PCI_H_U_BOOT__

#include <common.h>
#include <asm/types.h>

void amlogic_pcie_init_reset_pin(int pcie_dev);
void amlogic_pcie_disable(void);
#endif

