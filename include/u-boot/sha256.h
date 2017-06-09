#ifndef _SHA256_H
#define _SHA256_H

#define SHA256_SUM_LEN	32

/* Reset watchdog each time we process this many bytes */
#define CHUNKSZ_SHA256	(64 * 1024)

#ifdef CONFIG_AML_HW_SHA2

#define SHA224_DIGEST_SIZE	28

#define SHA256_DIGEST_SIZE	32
#define SHA256_BLOCK_SIZE	64

/* SHA2 context */
typedef struct {
	uint32_t h[8];
	uint32_t tot_len;
	uint32_t len;
	uint32_t digest_len;
	uint8_t block[2 * SHA256_BLOCK_SIZE];
	uint8_t buf[SHA256_DIGEST_SIZE];  /* Used to store the final digest. */
	uint8_t tmp[12]; // temp sha bits counter saved here by hw.
}sha2_ctx,sha256_context;

#else

/* SHA256 context */
typedef struct {
	uint32_t total[2];
	uint32_t state[8];
	uint8_t buffer[64];
} sha256_context;
#endif

void sha256_starts(sha256_context * ctx);
void sha256_update(sha256_context *ctx, const uint8_t *input, uint32_t length);
void sha256_finish(sha256_context * ctx, uint8_t digest[SHA256_SUM_LEN]);

void sha256_csum_wd(const unsigned char *input, unsigned int ilen,
		unsigned char *output, unsigned int chunk_sz);

#endif /* _SHA256_H */
