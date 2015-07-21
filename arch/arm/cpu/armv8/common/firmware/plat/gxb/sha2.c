
/*
 * arch/arm/cpu/armv8/common/firmware/plat/gxb/sha2.c
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

#include <stdio.h>
#include <asm/arch/romboot.h>
#include <string.h>
#include <io.h>
#include <platform_def.h>
#include <sha2.h>
#include <asm/arch/secure_apb.h>
#include <ndma_utils.h>

#define CONFIG_AML_SHA2_HW_DMA

static sha2_ctx *cur_ctx;
static void hw_init(uint32_t is224)
{
	uint32_t i, tmp;
	uint32_t state[10];
	if (is224 == 0) {
		/* SHA-256 */
		state[7] = 0x6A09E667;
		state[6] = 0xBB67AE85;
		state[5] = 0x3C6EF372;
		state[4] = 0xA54FF53A;
		state[3] = 0x510E527F;
		state[2] = 0x9B05688C;
		state[1] = 0x1F83D9AB;
		state[0] = 0x5BE0CD19;
	}
	else {
		/* SHA-224 */
		state[7] = 0xC1059ED8;
		state[6] = 0x367CD507;
		state[5] = 0x3070DD17;
		state[4] = 0xF70E5939;
		state[3] = 0xFFC00B31;
		state[2] = 0x68581511;
		state[1] = 0x64F98FA7;
		state[0] = 0xBEFA4FA4;
	}

	state[8] = 0;
	state[9] = 0;

	tmp = readl(SEC_SEC_BLKMV_GEN_REG0);
	tmp &= ~((3 << 12) | (0xf << 8) | (0xf << 4));
	tmp |= (1 << 12) | (0xa << 8) | (4 << 4);
	writel(tmp, (int *)SEC_SEC_BLKMV_GEN_REG0);

	writel((0 << 21) |			// last wdata
		   (0 << 20) |			// last block
		   (3 << 18) |			// byte transfer count
		   ((is224 ? 3 : 2) << 16) |	// SHA mode
		   (0 << 12) |			// out endian
		   (0 << 8) |			// in endian
		   (0 << 4) |			//
		   (0 << 4) |			//
		   (1 << 3) |			// enable
		   (0 << 2) |			//
		   (0 << 1) |			//
		   (1 << 0),			// enable SHA PIO data engine
		   SEC_SEC_BLKMV_SHA_CONTROL);

	// sha=5
	writel((1 << 4) | 5, SEC_SEC_BLKMV_PIO_CNTL0);
	while (((readl(SEC_SEC_BLKMV_PIO_CNTL0) >> 31) & 1) == 0)
		;

	// initial
	for (i = 0; i < 10; i++)
		writel(state[i], (long)(SEC_SEC_BLKMV_PIO_DATA0 + i * 4));
}

static void hw_update(const uint8_t *input, uint32_t ilen, uint8_t last_update)
{
	uint32_t bytes, left, tmp;
	uint32_t *p;

	if (!last_update && (ilen % 64)) {
		printf("Err:sha\n");
		// sha2 usage problem
		return;
	}

	// block
	p = (uint32_t *)input;
	while (ilen > 0) {
		if (ilen >= 64) {
			bytes = 64;
			ilen -= 64;
		}
		else {
			bytes = ilen;
			ilen = 0;
		}

		while (bytes > 0) {
			if (bytes >= 4) {
				left = 4;
				bytes -= 4;
			}
			else {
				left = bytes;
				bytes = 0;
			}

			if (left < 4) { // last write, last block
				tmp = readl(SEC_SEC_BLKMV_SHA_CONTROL);
				tmp &= ~(0xf << 18);
				tmp |= ((left - 1) << 18) | (3 << 20);
				writel(tmp, SEC_SEC_BLKMV_SHA_CONTROL);
			}
			else if (bytes == 0) { // last write,
				tmp = readl(SEC_SEC_BLKMV_SHA_CONTROL);
				tmp &= ~(3 << 20);
				tmp |= (1 << 21);

				if (last_update && ilen == 0)
					tmp |= (1 << 20); // last block

				writel(tmp, SEC_SEC_BLKMV_SHA_CONTROL);
			}

			writel(*p++, SEC_SEC_BLKMV_SHA_PIO_WDATA);

			if (bytes == 0) {
				while ((readl(SEC_SEC_BLKMV_SHA_CONTROL) >> 31) & 1)
					;

				tmp = readl(SEC_SEC_BLKMV_SHA_CONTROL);
				tmp &= ~(3 << 20);
				tmp |= (1 << 22);
				writel(tmp, SEC_SEC_BLKMV_SHA_CONTROL);
			}
		}
	}
}

static void hw_final(uint8_t output[32])
{
	uint32_t *p;
	uint32_t i;
	setbits_le32(SEC_SEC_BLKMV_PIO_CNTL0, 1 << 6);
	clrbits_le32(SEC_SEC_BLKMV_PIO_CNTL0, 1 << 6);

	for (p = (uint32_t *)(output), i = 0; i < 8; i++)
		*p++ = readl((long)(SEC_SEC_BLKMV_PIO_DATA0 + i * 4));
}

/**
 * SHA-2 Family Hash Init
 *
 * @param ctx         context
 * @param digest_len  digest length in bits (224 or 256)
 */
void SHA2_HW_init(sha2_ctx *ctx, uint32_t digest_len)
{
	if (cur_ctx != NULL) {
		printf("Err:sha\n");
		// sha2 usage problem
		return;
	}
	cur_ctx = ctx;

	hw_init(digest_len == 224);

	ctx->len = 0;
}

/**
 * SHA-2 Family Hash Update
 */
void SHA2_HW_update(sha2_ctx *ctx, const uint8_t *data, uint32_t len)
{
	unsigned int fill_len, data_len, rem_len,offset;

	if (cur_ctx != ctx) {
		printf("Err:sha\n");
		// sha2 usage problem
		return;
	}
	/* This method updates the hash for the input data in blocks, except the last
	 * partial|full block, which is saved in ctx->block.  The last partial|full
	 * block will be added to the hash in SHA2_final.
	 */
	data_len = len;
	offset = 0;
	/* fill saved block from beginning of input data */
	if (ctx->len) {
		fill_len = SHA256_BLOCK_SIZE - ctx->len;
		memcpy(&ctx->block[ctx->len], data, fill_len);
		data_len -= fill_len;
		offset = fill_len;
		ctx->len += fill_len;
	}
	if (ctx->len == SHA256_BLOCK_SIZE && data_len > 0) {
		/* saved block is full and is not last block, hash it */
		hw_update(ctx->block, SHA256_BLOCK_SIZE, 0);
		ctx->len = 0;
	}
	if (data_len > SHA256_BLOCK_SIZE) {
		/* still have more than 1 block. hash up until last [partial|full] block */
		rem_len = data_len % SHA256_BLOCK_SIZE;
		if (rem_len == 0) {
			rem_len = SHA256_BLOCK_SIZE;
		}

		data_len -= rem_len;
		hw_update(&data[offset], data_len, 0);
		offset += data_len;
	} else {
		rem_len = data_len;
	}

	if (rem_len) {
		/* save the remaining data */
		memcpy(ctx->block, &data[offset], rem_len);
		ctx->len = rem_len;
	}
}

/**
 * SHA-2 Family Hash Update
 *
 * Returns pointer to ctx->buf containing hash.
 */
uint8_t *SHA2_HW_final(sha2_ctx *ctx)
{
	if (cur_ctx != ctx) {
		printf("Err:sha\n");
		// sha2 usage problem
		return ctx->buf;
	}
	if (ctx->len == 0 || ctx->len > SHA256_BLOCK_SIZE) {
		printf("Err:sha\n");
		// internal sha2 problem
		return ctx->buf;
	}
	hw_update(ctx->block, ctx->len, 1);
	hw_final(ctx->buf);
	cur_ctx = NULL;
	return ctx->buf;
}

#if defined(CONFIG_AML_SHA2_HW_DMA)
#define THREAD1_TABLE_LOC  0x5510000
#define SHA_Wr(addr, data) *(volatile uint32_t *)(addr)=(data)
#define SHA_Rd(addr)       *(volatile uint32_t *)(addr)
#define SEC_ALLOWED_MASK   0xa // thread 3 and thread 1 are allowed non-secure
int g_n_sha_Start_flag = 0;
int g_n_sha_thread_num = 0;
#endif

void SHA2_init(sha2_ctx *ctx, unsigned int digest_len)
{
#if defined(CONFIG_AML_SHA2_HW_DMA)

	unsigned int sha2_256_msg_in[8] = {
		0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
		0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19};

	g_n_sha_thread_num = 0; //fixed SHA2 with thread 0


	// Setup secure and non-secure transfers
	// Also set up the general readback of crypto outputs to the SHA engine
	// assign              sec_allowed_mask        = sec_gen_reg0[11:8];
	// wire    [1:0]       sec_read_sel            = sec_gen_reg0[13:12];
	SHA_Wr(SEC_SEC_BLKMV_GEN_REG0, ((SHA_Rd(SEC_SEC_BLKMV_GEN_REG0) & ~((0x3 << 12) | (0xf << 8))) | (1 << 12) | (SEC_ALLOWED_MASK << 8)) );
	// Allow secure DDR tranfers for the Secure domains
	// wire    [3:0]       sec_ddr_sec_id_en   = sec_gen_reg0[7:4];       // Even though a thread is secure, we may not want it to use the DDR secure ID (just in case);
	SHA_Wr(SEC_SEC_BLKMV_GEN_REG0, ((SHA_Rd(SEC_SEC_BLKMV_GEN_REG0) & ~(0xf << 4)) | (0x4 << 4)) );   // only thread 2 can issue Secure transfers

	// Enable the SHA engine
	// wire                sec_sha_dma_enable      = sec_sha_control[3];
	SHA_Wr( SEC_SEC_BLKMV_SHA_CONTROL, SHA_Rd(SEC_SEC_BLKMV_SHA_CONTROL) | (1 << 3) );

	// For DMA modes, pretend there is a PIO request for the AES (not SHA)
	// reg                 pio_granted;        // pio_control[31];
	// wire                pio_hold_all    = pio_control[5];       // set to 1 to block all in-line processing regardless of the PIO being used
	// wire                pio_request     = pio_control[4];
	// wire    [2:0]       pio_inline_type = pio_control[2:0];
	SHA_Wr( SEC_SEC_BLKMV_PIO_CNTL0, (SHA_Rd(SEC_SEC_BLKMV_PIO_CNTL0) & ~((1 << 4) | (0x7 << 0))) | ((1 << 4) | (4 << 0)) );   // Request for AES

	//
	// Write the initial message and datatlen
	//
	// initial the internal CPU fifo write counter for the save/restore engine
	// wire                sec_sha_cpu_save_init   = sec_sha_control[6];      // Pulsed
	// wire    [1:0]       sec_sha_thread          = sec_sha_control[5:4];
	SHA_Wr( SEC_SEC_BLKMV_SHA_CONTROL, (SHA_Rd(SEC_SEC_BLKMV_SHA_CONTROL) & ~(3 << 4)) | (1 << 6) | (g_n_sha_thread_num << 4) );  // pulse bit (init cpu counters)
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_MSG_IN, sha2_256_msg_in[7] );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_MSG_IN, sha2_256_msg_in[6] );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_MSG_IN, sha2_256_msg_in[5] );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_MSG_IN, sha2_256_msg_in[4] );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_MSG_IN, sha2_256_msg_in[3] );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_MSG_IN, sha2_256_msg_in[2] );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_MSG_IN, sha2_256_msg_in[1] );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_MSG_IN, sha2_256_msg_in[0] );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_DATALEN_IN, 0 );
	SHA_Wr( SEC_SEC_BLKMV_SHA_DMA_DATALEN_IN, 0 );

	memset((void*)THREAD1_TABLE_LOC,0,10*32);

	NDMA_set_table_position_secure( g_n_sha_thread_num, THREAD1_TABLE_LOC, THREAD1_TABLE_LOC + (10*32) );	 // 2 thread entries
	g_n_sha_Start_flag = 0;
#else
	SHA2_HW_init(ctx, digest_len);
#endif
}

void SHA2_update(sha2_ctx *ctx, const unsigned char *data, unsigned int len)
{

#if defined(CONFIG_AML_SHA2_HW_DMA)

	if (!len)
		return;

	NDMA_add_descriptor_sha( g_n_sha_thread_num, 	// uint32_t   thread_num,
							 1,						// uint32_t   irq,
							 2,						// uint32_t   sha_mode, 	  // 1:sha1;2:sha2-256;3:sha2_224
							 0,						// uint32_t   pre_endian,
							 len,					// uint32_t   bytes_to_move,
							 (uint32_t)(unsigned long)data, 	// uint32_t   src_addr,
							 0 );					// uint32_t   last_block,
	if (!g_n_sha_Start_flag)
	{
		NDMA_start(g_n_sha_thread_num);
		g_n_sha_Start_flag = 1;
	}
#else
	SHA2_HW_update(ctx, data, len);
#endif
}

void SHA2_final(sha2_ctx *ctx,const unsigned char *data, unsigned int len)
{
#if defined(CONFIG_AML_SHA2_HW_DMA)
	unsigned int *pOUT = (unsigned int *)(unsigned char *)ctx->buf;

	NDMA_add_descriptor_sha( g_n_sha_thread_num,		// uint32_t   thread_num,
							 1,						// uint32_t   irq,
							 2,						// uint32_t   sha_mode, 	  // 1:sha1;2:sha2-256;3:sha2_224
							 0,						// uint32_t   pre_endian,
							 len,					// uint32_t   bytes_to_move,
							 (uint32_t)(unsigned long)data,	// uint32_t   src_addr,
							 1 );					// uint32_t   last_block,

	if (!g_n_sha_Start_flag)
	{
		NDMA_start(g_n_sha_thread_num);
		g_n_sha_Start_flag = 1;
	}

	NDMA_wait_for_completion(g_n_sha_thread_num);
	NDMA_stop(g_n_sha_thread_num);
	g_n_sha_Start_flag = 0;

	pOUT[0] = SHA_Rd(SEC_SEC_BLKMV_PIO_DATA0);
	pOUT[1] = SHA_Rd(SEC_SEC_BLKMV_PIO_DATA1);
	pOUT[2] = SHA_Rd(SEC_SEC_BLKMV_PIO_DATA2);
	pOUT[3] = SHA_Rd(SEC_SEC_BLKMV_PIO_DATA3);
	pOUT[4] = SHA_Rd(SEC_SEC_BLKMV_PIO_DATA4);
	pOUT[5] = SHA_Rd(SEC_SEC_BLKMV_PIO_DATA5);
	pOUT[6] = SHA_Rd(SEC_SEC_BLKMV_PIO_DATA6);
	pOUT[7] = SHA_Rd(SEC_SEC_BLKMV_PIO_DATA7);

#else
	SHA2_HW_update(ctx, data, len);
	SHA2_HW_final(ctx);
#endif

}


void sha2(const uint8_t *input, unsigned int ilen, unsigned char output[32], unsigned int is224)
{
	sha2_ctx sha_ctx;
	unsigned long nSRCAddr = (unsigned long)input;

	if (((nSRCAddr >> 24) &  (0xFF)) == 0xD9)
	{
		//printf("aml log : PIO SHA\n");
		SHA2_HW_init(&sha_ctx, is224 ? 224: 256);
		SHA2_HW_update(&sha_ctx, input, ilen);
		SHA2_HW_final(&sha_ctx);

	}
	else
	{
		//printf("aml log : DMA SHA\n");
		SHA2_init( &sha_ctx, is224 ? 224: 256);
		SHA2_final( &sha_ctx, input,ilen);
	}
	memcpy(output,sha_ctx.buf,32);
}
