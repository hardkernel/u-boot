
/*
 * arch/arm/include/asm/arch-txl/romboot.h
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

#ifndef __BOOT_ROM_H_
#define __BOOT_ROM_H_
#ifndef __ASSEMBLY__
//#include <stdint.h>
//uint8_t simple_i2c(uint8_t adr);
//void spi_pin_mux(void);
//void spi_init(void);
//uint32_t spi_read(uint32_t src, uint32_t mem, uint32_t size);
//void udelay(uint32_t usec);
//void boot_des_decrypt(uint8_t *ct, uint8_t *pt, uint32_t size);

#endif /* ! __ASSEMBLY__ */
#include "config.h"

/* Magic number to "boot" up A53 */
#define AO_SEC_SD_CFG10_CB			0x80000000

/*BOOT device and ddr size*/
/*31-28: boot device id, 27-24: boot device para, 23-20: reserved*/
/*19-8: ddr size, 7-0: board revision*/
//#define P_AO_SEC_GP_CFG0                                     0xDA100240 //defined in secure_apb.h
#define AO_SEC_GP_CFG7_W0_BIT			8
#define AO_SEC_GP_CFG7_W0			0x100

#define BOOT_ID_RESERVED	0
#define BOOT_ID_EMMC		1
#define BOOT_ID_NAND		2
#define BOOT_ID_SPI		3
#define BOOT_ID_SDCARD		4
#define BOOT_ID_USB		5

#endif /* __BOOT_ROM_H_ */
