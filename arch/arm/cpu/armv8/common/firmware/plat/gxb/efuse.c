/*
 * Copyright (c) 2014 Amlogic, Inc. All rights reserved.
 *
 * This source code is subject to the terms and conditions defined in the
 * file 'LICENSE' which is part of this source code package.
 *
 * eFUSE data in SRAM driver
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