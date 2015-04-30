/*
 * Copyright (c) 2015 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 *
 * Amlogic storage load module
 * Author: larson.jiang@amlogic.com, xiaobo.gu@amlogic.com
 * Created time: 2015.04.22
 *
 */

#ifndef __BL2_STORAGE_H_
#define __BL2_STORAGE_H_

#include <asm/arch/cpu_sdio.h>

/*boot device defines*/
#define BOOT_DEVICE_RESERVED            0
#define BOOT_DEVICE_EMMC                1
#define BOOT_DEVICE_NAND                2
#define BOOT_DEVICE_SPI                 3
#define BOOT_DEVICE_SD                  4
#define BOOT_DEVICE_USB                 5

/*sdio defines*/
#define MAX_DESC_NUM                    8
#define MAX_BLOCK_COUNTS                512

uint64_t storage_load(uint64_t src, uint64_t des, uint64_t size, const char * image_name);
uint64_t get_boot_device(void);
uint64_t spi_read(uint64_t src, uint64_t des, uint64_t size);
uint64_t sdio_read_blocks(struct sd_emmc_global_regs *sd_emmc_regs, uint64_t src, uint64_t des, uint64_t size,uint64_t mode);
uint64_t sdio_read_data(uint64_t boot_device, uint64_t src, uint64_t des, uint64_t size);

/*SIZE defines*/
#define SIZE_1K							0x400
#define SIZE_2K							0x800
#define SIZE_4K							0x1000
#define SIZE_8K							0x2000
#define SIZE_16K						0x4000
#define SIZE_32K						0x8000
#define SIZE_64K						0x10000
#define SIZE_128K						0x20000
#define SIZE_256K						0x40000
#define SIZE_512K						0x80000
#define SIZE_1M							0x100000
#define SIZE_2M							0x200000
#define SIZE_4M							0x400000
#define SIZE_8M							0x800000
#define SIZE_16M						0x1000000
#define SIZE_32M						0x2000000
#define SIZE_64M						0x4000000
#define SIZE_128M						0x8000000
#define SIZE_256M						0x10000000
#define SIZE_512M						0x20000000
#define SIZE_1G							0x40000000
#define SIZE_2G							0x80000000

#endif /*__BL2_STORAGE_H_*/
