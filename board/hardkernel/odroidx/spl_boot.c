/*
 * Copyright (C) 2013  Hardkernel Co.,LTD.
 * Hakjoo Kim <ruppi.kim@hardkernel.com>
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
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include<common.h>
#include<config.h>
#include "setup.h"

enum boot_mode {
    BOOT_MODE_MMCSD = 4,
    BOOT_MODE_EMMC = 6,
    BOOT_MODE_EMMC_4_4 = 0x8,
    BOOT_MODE_OM = 32,
    BOOT_MODE_USB,
};

#define IRAM_ADDRESS			0x02020000
#define EXTERNAL_FUNC_ADDRESS		(IRAM_ADDRESS + 0x0030)
#define	IROM_READ_SDMMC			EXTERNAL_FUNC_ADDRESS

void inline irom_read_sdmmc(u32 start, u32 count, u32 addr)
{
	void (*read_sdmmc)(u32, u32, u32) = (void *) *(u32 *)IROM_READ_SDMMC;
	read_sdmmc(start, count, addr);
}

/*
* Copy U-boot from mmc to RAM:
* COPY_BL2_FNPTR_ADDR: Address in iRAM, which Contains
* Pointer to API (Data transfer from mmc to ram)
*/
void board_init_f(unsigned long bootflag)
{
	__attribute__((noreturn)) void (*uboot)(void);

	irom_read_sdmmc(BL2_BLK_OFFSET, BL2_BLK_COUNT, CONFIG_SYS_TEXT_BASE);

	/* Jump to U-Boot image */
	uboot = (void *)CONFIG_SYS_TEXT_BASE;
	(*uboot)();
	/* Never returns Here */
}

/* Place Holders */
void board_init_r(gd_t *id, ulong dest_addr)
{
	/* Function attribute is no-return */
	/* This Function never executes */
	while (1);
}

void save_boot_params(u32 r0, u32 r1, u32 r2, u32 r3) { }
