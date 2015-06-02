
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/include/sha2.h
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

#include <stdint.h>

#ifndef __PLAT_SHA2_H_
#define __PLAT_SHA2_H_


#define SHA224_DIGEST_SIZE	28

#define SHA256_DIGEST_SIZE	32
#define SHA256_BLOCK_SIZE	64

/* SHA2 context */
struct sha2_ctx {
	uint32_t h[8];
	uint32_t tot_len;
	uint32_t len;
	uint32_t digest_len;
	uint8_t block[2 * SHA256_BLOCK_SIZE];
	uint8_t buf[SHA256_DIGEST_SIZE];  /* Used to store the final digest. */
};

void SHA2_init(struct sha2_ctx *, uint32_t );
void SHA2_update(struct sha2_ctx *, const uint8_t *, uint32_t);
uint8_t *SHA2_final(struct sha2_ctx *);

int aml_data_check(unsigned long ,unsigned int ,unsigned int );

void sha2(const uint8_t *input,
	  uint32_t ilen,
	  uint8_t output[32],
	  uint32_t is224);

#endif /*__PLAT_SHA2_H_*/