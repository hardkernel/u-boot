/*
 * rand.c
 *
 * Pseudorandom number generation, based on OpenBSD arc4random().
 *
 * Copyright (c) 2000 Dug Song <dugsong@monkey.org>
 * Copyright (c) 1996 David Mazieres <dm@lcs.mit.edu>
 *
 * $Id: rand.c,v 1.15 2005/02/15 06:37:07 dugsong Exp $
 */

#include "rand.h"

#ifdef _WIN32
/* XXX */
#undef _WIN32_WINNT
#define _WIN32_WINNT 0x0400
#include <windows.h>
#include <wincrypt.h>
#define inline __inline
#else
//# include <sys/types.h>
//# include <sys/time.h>
//# include <unistd.h>
#endif
//#include <fcntl.h>
//#include <stdlib.h>
//#include <string.h>

struct rand_handle {
	uint8_t		 i;
	uint8_t		 j;
	uint8_t		 s[256];
	u_char		*tmp;
	int		 tmplen;
};

static unsigned char g_Seed[32] ={0};
static unsigned long g_ulSendlen = 0;
////////////////////////////////////////////////
static inline void
rand_init(rand_t *rand)
{
	int i;
	
	for (i = 0; i < 256; i++)
		rand->s[i] = i;
	rand->i = rand->j = 0;
}

static inline void
rand_addrandom(rand_t *rand, u_char *buf, int len)
{
	int i;
	uint8_t si;
	
	rand->i--;
	for (i = 0; i < 256; i++) {
		rand->i = (rand->i + 1);
		si = rand->s[rand->i];
		rand->j = (rand->j + si + buf[i % len]);
		rand->s[rand->i] = rand->s[rand->j];
		rand->s[rand->j] = si;
	}
	rand->j = rand->i;
}

static rand_t *
rand_open(void)
{
	rand_t *r;
	u_char seed[256];
#if 0
#ifdef _WIN32
	HCRYPTPROV hcrypt = 0;

	CryptAcquireContext(&hcrypt, NULL, NULL, PROV_RSA_FULL,
	    CRYPT_VERIFYCONTEXT);
	CryptGenRandom(hcrypt, sizeof(seed), seed);
	CryptReleaseContext(hcrypt, 0);
#else
	struct timeval *tv = (struct timeval *)seed;
	int fd;

	if ((fd = open("/dev/arandom", O_RDONLY)) != -1 ||
	    (fd = open("/dev/urandom", O_RDONLY)) != -1) {
		read(fd, seed + sizeof(*tv), sizeof(seed) - sizeof(*tv));
		close(fd);
	}
	gettimeofday(tv, NULL);
#endif
#endif
	if ((r = malloc(sizeof(*r))) != NULL) {
		rand_init(r);
		rand_addrandom(r, seed, 128);
		rand_addrandom(r, seed + 128, 128);
		r->tmp = NULL;
		r->tmplen = 0;
	}
	return (r);
}

static uint8_t
rand_getbyte(rand_t *r)
{
	uint8_t si, sj;

	r->i = (r->i + 1);
	si = r->s[r->i];
	r->j = (r->j + si);
	sj = r->s[r->j];
	r->s[r->i] = sj;
	r->s[r->j] = si;
	return (r->s[(si + sj) & 0xff]);
}

static int
rand_get(rand_t *r, void *buf, size_t len)
{
	u_char *p;
	u_int i;

	for (p = buf, i = 0; i < len; i++) {
		p[i] = rand_getbyte(r);
	}
	return (0);
}

static int
rand_set(rand_t *r, const void *buf, size_t len)
{
	rand_init(r);
	rand_addrandom(r, (u_char *)buf, len);
	rand_addrandom(r, (u_char *)buf, len);
	return (0);
}

static int
rand_add(rand_t *r, const void *buf, size_t len)
{
	rand_addrandom(r, (u_char *)buf, len);
	return (0);
}

static uint8_t
rand_uint8(rand_t *r)
{
	return (rand_getbyte(r));
}

static uint16_t
rand_uint16(rand_t *r)
{
	uint16_t val;

	val = rand_getbyte(r) << 8;
	val |= rand_getbyte(r);
	return (val);
}

static uint32_t
rand_uint32(rand_t *r)
{
	uint32_t val;

	val = rand_getbyte(r) << 24;
	val |= rand_getbyte(r) << 16;
	val |= rand_getbyte(r) << 8;
	val |= rand_getbyte(r);
	return (val);
}

static int
rand_shuffle(rand_t *r, void *base, size_t nmemb, size_t size)
{
	u_char *save, *src, *dst, *start = (u_char *)base;
	u_int i, j;

	if (nmemb < 2)
		return (0);
	
	if ((u_int)r->tmplen < size) {
		if (r->tmp == NULL) {
			if ((save = malloc(size)) == NULL)
				return (-1);
		} else if ((save = realloc(r->tmp, size)) == NULL)
			return (-1);
		
		r->tmp = save;
		r->tmplen = size;
	} else
		save = r->tmp;
	
	for (i = 0; i < nmemb; i++) {
		if ((j = rand_uint32(r) % (nmemb - 1)) != i) {
			src = start + (size * i);
			dst = start + (size * j);
			memcpy(save, dst, size);
			memcpy(dst, src, size);
			memcpy(src, save, size);
		}
	}
	return (0);
}
static rand_t * rand_close(rand_t *r)
{
	if (r != NULL) {
		if (r->tmp != NULL)
			free(r->tmp);
		free(r);
	}
	return (NULL);
}

static unsigned int Rand_SetSend(unsigned char *pSend, unsigned long ulSendlen)
{
	if(ulSendlen > 32 )
		return -1;
	memcpy(g_Seed,pSend,ulSendlen);
	g_ulSendlen = ulSendlen;
	return 0;
}
static unsigned int Rand_GenRand(unsigned char *pRand, unsigned long ulRandLen)
{
	rand_t *r;
	int rv;
//	time_t seed;

	r = rand_open();
	if (r == NULL) return -1;
	if(g_ulSendlen != 0)
	{
		rv = rand_set(r,&g_Seed,g_ulSendlen);
		if (r == NULL) return -1;
	}
	rv = rand_get(r,pRand,ulRandLen);
	if (r == NULL) return -1;
	r = rand_close(r);

	memcpy(g_Seed,pRand,g_ulSendlen);
	return 0;
}

int random_generate(unsigned int seed_ext,unsigned char *buf,unsigned len)
{
#define SEEDBYTE_NUM	128
	unsigned int seed=seed_ext;
	rand_t *r;
	int rv;
	unsigned pos,cnt;
	unsigned char seedByte[SEEDBYTE_NUM] = {0}; 
	r = rand_open();
	if (r == NULL) return -1;
	rv = rand_set(r,&seed,4);
	if (r == NULL) return -1;

	rv = rand_get(r,seedByte,SEEDBYTE_NUM);
	r = rand_close(r);
	if(len <= SEEDBYTE_NUM){
		memcpy(buf,seedByte,len);
	}
	else{
		pos = 0;
		while(len>0){
			if(len>=SEEDBYTE_NUM){
				cnt = SEEDBYTE_NUM;
			}
			else{
				cnt = len;
			}
			memcpy(&buf[pos],seedByte,cnt);
			len -= cnt;
			pos += cnt;
			//printf("len:%d\n",len);
		}
	}
#undef SEEDBYTE_NUM
	return 0;
}
unsigned int random_u32(unsigned int seed)
{
	rand_t *r;
	int rv;
	unsigned int rand;
	r = rand_open();
	if (r == NULL) return -1;
	rv = rand_set(r,&seed,4);
	if (r == NULL) return -1;
	
	rand = rand_uint32(r);
	r = rand_close(r);
	return rand;
}
unsigned short random_u16(unsigned int seed)
{
	rand_t *r;
	int rv;
	unsigned int rand;
	r = rand_open();
	if (r == NULL) return -1;
	rv = rand_set(r,&seed,4);
	if (r == NULL) return -1;
	
	rand = rand_uint16(r);
	r = rand_close(r);
	return rand;
}
unsigned char random_u8(unsigned int seed)
{
	rand_t *r;
	int rv;
	unsigned char rand;
	r = rand_open();
	if (r == NULL) return -1;
	rv = rand_set(r,&seed,4);
	if (r == NULL) return -1;
	
	rand = rand_uint8(r);
	r = rand_close(r);
	return rand;
}



