/* uclpack.c -- example program: a simple file packer

   This file is part of the UCL data compression library.

   Copyright (C) 1996-2004 Markus Franz Xaver Johannes Oberhumer
   All Rights Reserved.

   The UCL library is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License, or (at your option) any later version.

   The UCL library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with the UCL library; see the file COPYING.
   If not, write to the Free Software Foundation, Inc.,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

   Markus F.X.J. Oberhumer
   <markus@oberhumer.com>
   http://www.oberhumer.com/opensource/ucl/
 */


/*************************************************************************
// NOTE: this is an example program, so do not use to backup your data.
//
// This program lacks things like sophisticated file handling but is
// pretty complete regarding compression - it should provide a good
// starting point for adaption for you applications.
**************************************************************************/

#include "ucl_conf.h"
#include "ucl.h"

/* portability layer */
#define WANT_UCL_MALLOC 1
#define WANT_UCL_FREAD 1
#if defined(WITH_TIMER)
#define WANT_UCL_UCLOCK 1
#endif
#define WANT_UCL_WILDARGV 1

const char *progname = NULL;

static unsigned long total_in = 0;
static unsigned long total_out = 0;
//static int opt_debug = 0;

/* use option `-F' for faster operation - then we don't compute or verify
 * a checksum and always use the fast decompressor */
static ucl_bool opt_fast = 0;

/* magic file header for compressed files */
static const unsigned char magic[8] =
    { 0x00, 0xe9, 0x55, 0x43, 0x4c, 0xff, 0x01, 0x1a };

/*************************************************************************
// ucl util
**************************************************************************/
#define printf(a,...)

static inline void * memcpy(void * dest,const void *src,unsigned int count)
    {
    
    
    /*  char *tmp = (char *) dest, *s = (char *) src;
    
        while (count--)
            *tmp++ = *s++;
    
    */
    
        if((((unsigned int) dest) & 0x03) || (((unsigned int) src) & 0x03)){
        
                char *tmp = (char *) dest, *s = (char *) src;
    
                while (count--)
                *tmp++ = *s++;
    
        }
        else{
    
            int word_num = count/4 - 1;
    
            int slice = count%4 - 1;
    
            while(word_num >= 0){
    
                *(u32*)dest= *(u32*)src;
                dest += 4;
                src += 4;
                word_num--;
            }
    
            while(slice >= 0){
    
                *((char *)dest + slice) = *((char *)src + slice);
                slice--;
            }
        
        }
        return dest;
    }


static inline int memcmp(const void * cs,const void * ct,size_t count)
{
	const unsigned char *su1, *su2;
	int res = 0;

	for( su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
		if ((res = *su1 - *su2) != 0)
			break;
	return res;
}

UCL_PUBLIC(ucl_bool)
ucl_assert(int expr)
{
    return (expr) ? 1 : 0;
}

/***********************************************************************
// adler32 checksum
// adapted from free code by Mark Adler <madler@alumni.caltech.edu>
// see http://www.cdrom.com/pub/infozip/zlib/
************************************************************************/

#define UCL_BASE 65521u /* largest prime smaller than 65536 */
#define UCL_NMAX 5552
/* NMAX is the largest n such that 255n(n+1)/2 + (n+1)(BASE-1) <= 2^32-1 */

#define UCL_DO1(buf,i)  {s1 += buf[i]; s2 += s1;}
#define UCL_DO2(buf,i)  UCL_DO1(buf,i); UCL_DO1(buf,i+1);
#define UCL_DO4(buf,i)  UCL_DO2(buf,i); UCL_DO2(buf,i+2);
#define UCL_DO8(buf,i)  UCL_DO4(buf,i); UCL_DO4(buf,i+4);
#define UCL_DO16(buf,i) UCL_DO8(buf,i); UCL_DO8(buf,i+8);

UCL_PUBLIC(ucl_uint32)
ucl_adler32(ucl_uint32 adler, const ucl_bytep buf, ucl_uint len)
{
    ucl_uint32 s1 = adler & 0xffff;
    ucl_uint32 s2 = (adler >> 16) & 0xffff;
    int k;

    if (buf == NULL)
        return 1;

    while (len > 0)
    {
        k = len < UCL_NMAX ? (int) len : UCL_NMAX;
        len -= k;
        if (k >= 16) do
        {
            UCL_DO16(buf,0);
            buf += 16;
            k -= 16;
        } while (k >= 16);
        if (k != 0) do
        {
            s1 += *buf++;
            s2 += s1;
        } while (--k > 0);
        s1 %= UCL_BASE;
        s2 %= UCL_BASE;
    }
    return (s2 << 16) | s1;
}


/*************************************************************************
// data IO
**************************************************************************/

static ucl_uint xread(ucl_bytep f, ucl_voidp buf, ucl_uint len)
{
	if(!f)
		return 0;
	f += total_in;
	
	if(buf != f)
    	memcpy(buf, f, len);
    total_in += len;
    return len;
}


static int xgetc(ucl_bytep f)
{
    unsigned char c;
    xread(f,(ucl_voidp) &c,1);
    return c;
}

/* read and write portable 32-bit integers */
static ucl_uint32 xread32(ucl_bytep f)
{
    unsigned char b[4];
    ucl_uint32 v;

    xread(f,b,4);
    v  = (ucl_uint32) b[3] <<  0;
    v |= (ucl_uint32) b[2] <<  8;
    v |= (ucl_uint32) b[1] << 16;
    v |= (ucl_uint32) b[0] << 24;
    return v;
}

static ucl_uint xwrite(ucl_bytep f, const ucl_voidp buf, ucl_uint len)
{
    if (!f)
    	return 0;
    f += total_out;
	if(f != buf)
        memcpy(f, buf, len);

    total_out += len;
    return len;
}

/*************************************************************************
// decompress util
**************************************************************************/

static ucl_uint get_overhead(int method, ucl_uint size)
{
    if (method == 0x2b || method == 0x2d || method == 0x2e)
        return size / 8 + 256;
    return 0;
}


static ucl_bool set_method_name(int method, int level)
{
    if (level < 1 || level > 10)
        return 0;
    return 1;
}

/*************************************************************************
// decompress
// input point = in + total_in
// We are using in-place decompression here.
**************************************************************************/

int uclDecompress(ucl_bytep op, ucl_uint32p o_len, ucl_bytep ip)
{
    int r = 0;
    unsigned char m [ sizeof(magic) ];
    ucl_uint32 flags;
    int method;
    int level;
    ucl_uint block_size;
    ucl_uint32 checksum;
    ucl_uint overhead = 0;
    ucl_bytep in = ip;
    ucl_bytep out = op;
    ucl_uint in_len;
    ucl_uint out_len;

    total_in = total_out = 0;
    *o_len = 0;

	if(!ip || !op)
		return -1;

/*
 * Step 1: check magic header, read flags & block size, init checksum
 */
    if (xread(in, m,sizeof(magic)) != sizeof(magic) ||
        memcmp(m,magic,sizeof(magic)) != 0)
    {
        printf("%s: header error - this file is not compressed by uclpack\n", progname);
        r = 1;
        goto err;
    }
    flags = xread32(ip);
    method = xgetc(ip);
    level = xgetc(ip);
    block_size = xread32(ip);
    overhead = get_overhead(method, block_size);
    if (overhead == 0 || !set_method_name(method, level))
    {
        printf("%s: header error - invalid method %d (level %d)\n",
                progname, method, level);
        r = 2;
        goto err;
    }
    if (block_size < 1024 || block_size > 8*1024*1024L)
    {
        printf("%s: header error - invalid block size %ld\n",
                progname, (long) block_size);
        r = 3;
        goto err;
    }
    printf("%s: block-size is %ld bytes\n", progname, (long)block_size);

    checksum = ucl_adler32(0,NULL,0);

/*
 * Step 2: allocate buffer for in-place decompression
 */
	//memory decompress, out use as buf

/*
 * Step 3: process blocks
 */
    printf("decompressing ... \n");
    for (;;)
    {
        /* read uncompressed size */
        out_len = xread32(ip);

        /* exit if last block (EOF marker) */
        if (out_len == 0)
            break;

        /* read compressed size */
        in_len = xread32(ip);

        /* sanity check of the size values */
        if (in_len > block_size || out_len > block_size ||
            in_len == 0 || in_len > out_len)
        {
            printf("%s: block size error - data corrupted\n", progname);
            r = 5;
            goto err;
        }

        /* place compressed block at the top of the buffer */
        in = ip + total_in;
        out = op + total_out ;

        /* read compressed block data */
        xread(ip,in,in_len);

        if (in_len < out_len)
        {
            /* decompress - use safe decompressor as data might be corrupted */
            ucl_uint new_len = out_len;

            if (method == 0x2b)
            {
                    r = ucl_nrv2b_decompress_8(in,in_len,out,&new_len,NULL);
            }
            else if (method == 0x2d)
            {
                    r = ucl_nrv2d_decompress_8(in,in_len,out,&new_len,NULL);
            }
            else if (method == 0x2e)
            {
                    r = ucl_nrv2e_decompress_8(in,in_len,out,&new_len,NULL);
            }
            if (r != UCL_E_OK || new_len != out_len)
            {
                printf("%s: compressed data violation: error %d (0x%x: %ld/%ld/%ld)\n", progname, r, method, (long) in_len, (long) out_len, (long) new_len);
                r = 6;
                goto err;
            }
            /* write decompressed block */
            xwrite(op,out,out_len);
            printf("#");
            *o_len += out_len;
            /* update checksum */
            if ((flags & 1) && !opt_fast)
                checksum = ucl_adler32(checksum,out,out_len);
        }
        else
        {
            /* write original (incompressible) block */
            xwrite(op,in,in_len);
            printf("#");
            *o_len += in_len;
            /* update checksum */
            if ((flags & 1) && !opt_fast)
                checksum = ucl_adler32(checksum,in,in_len);
        }
    }
    printf("\n");
    /* read and verify checksum */
    if (flags & 1)
    {
        ucl_uint32 c = xread32(ip);
        if (!opt_fast && c != checksum)
        {
            printf("%s: checksum error - data corrupted\n", progname);
            r = 7;
            goto err;
        }
    }

    r = 0;
err:
    return r;
}

