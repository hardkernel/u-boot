
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/efuse.c
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

#include <io.h>
#include <config.h>
#include <stdio.h>
#include <string.h>
#include <efuse.h>

#define EFUSE_READ_PRINT 0

void efuse_read(uint64_t offset, uint64_t length, const char * buffer){
	memcpy((void *)buffer, (void *)(P_SHARED_EFUSE_MIRROR+offset), length);
#if EFUSE_READ_PRINT
	efuse_print(offset, length, buffer);
#endif
}

void efuse_print(uint64_t offset, uint64_t length, const char * buffer){
	uint32_t loop = 0;
	printf("Efuse Read:");
	for (loop=0; loop<length; loop++) {
		if (0 == (loop % 16))
			printf("\n");
		printf("%2x ", buffer[loop]);
	}
	printf("\n");
}