/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * Boot ROM general defines
 */

#ifndef __BOOT_ROM_H_
#define __BOOT_ROM_H_
#ifndef __ASSEMBLY__
#include <stdint.h>
//uint8_t simple_i2c(uint8_t adr);
//void spi_pin_mux(void);
//void spi_init(void);
//uint32_t spi_read(uint32_t src, uint32_t mem, uint32_t size);
//void udelay(uint32_t usec);
//void boot_des_decrypt(uint8_t *ct, uint8_t *pt, uint32_t size);

#endif /* ! __ASSEMBLY__ */
#include "config.h"

/* Magic number to "boot" up A53 */
#define AO_SEC_SD_CFG2_CB			0x80000000

#define AO_SEC_GP_CFG7_W0_BIT			8
#define AO_SEC_GP_CFG7_W0			0x10

/*BOOT device and ddr size*/
/*31-28: boot device id, 27-24: boot device para, 23-20: reserved*/
/*19-8: ddr size, 7-0: board revision*/
//#define P_AO_SEC_GP_CFG0					0xDA100240 //defined in secure_apb.h

#define P_ISA_TIMERE                 (volatile uint32_t *)0xc1109988
#define P_ASSIST_POR_CONFIG          (volatile uint32_t *)0xc1107d54

#define P_RESET1_REGISTER	     (volatile uint32_t *)0xc1104408

#define P_WATCHDOG_CNTL              (volatile uint32_t *)0xc11098d0
#define P_WATCHDOG_CNTL1             (volatile uint32_t *)0xc11098d4
#define P_WATCHDOG_TCNT              (volatile uint32_t *)0xc11098d8
#define P_WATCHDOG_RESET             (volatile uint32_t *)0xc11098dc

#define P_SPI_FLASH_CTRL             (volatile uint32_t *)0xc1108c88
#define P_SPI_START_ADDR             (volatile uint32_t *)0xCC000000

#endif /* __BOOT_ROM_H_ */
