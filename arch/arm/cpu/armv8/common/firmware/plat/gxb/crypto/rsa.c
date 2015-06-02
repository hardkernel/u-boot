/*
 *  The RSA public-key cryptosystem
 *
 *  Copyright (C) 2006-2011, Brainspark B.V.
 *
 *  This file is part of PolarSSL (http://www.polarssl.org)
 *  Lead Maintainer: Paul Bakker <polarssl_maintainer at polarssl.org>
 *
 *  All rights reserved.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */
/*
 *  RSA was designed by Ron Rivest, Adi Shamir and Len Adleman.
 *
 *  http://theory.lcs.mit.edu/~rivest/rsapaper.pdf
 *  http://www.cacr.math.uwaterloo.ca/hac/about/chap8.pdf
 */

#include <rsa_config.h>
#include <string.h>

#if defined(POLARSSL_RSA_C)

#include <rsa.h>

#include <stdio.h>

/*
 * Initialize an RSA context
 */

extern void mymallocreset();

void rsa_init( rsa_context *ctx,
               int padding,
               int hash_id )
{
    memset( ctx, 0, sizeof( rsa_context ) );

    ctx->padding = padding;
    ctx->hash_id = hash_id;

	mymallocreset();
}

/*
 * Do an RSA public key operation
 */
int rsa_public( rsa_context *ctx,
                const unsigned char *input,
                unsigned char *output )
{
    int ret;
    size_t olen;
    mpi T;
    mpi_init( &T );
    MPI_CHK( mpi_read_binary( &T, input, ctx->len ) );

    if ( mpi_cmp_mpi( &T, &ctx->N ) >= 0 )
    {
        mpi_free( &T );
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );
    }
    olen = ctx->len;
    MPI_CHK( mpi_exp_mod( &T, &T, &ctx->E, &ctx->N, &ctx->RN ) );
    MPI_CHK( mpi_write_binary( &T, output, olen ) );

cleanup:

    mpi_free( &T );

    if ( ret != 0 )
        return( POLARSSL_ERR_RSA_PUBLIC_FAILED + ret );
    return( 0 );
}

/*
 * Implementation of the PKCS#1 v2.1 RSASSA-PKCS1-v1_5-VERIFY function
 */
int rsa_rsassa_pkcs1_v15_verify( rsa_context *ctx,
                                 int mode,
                                 int hash_id,
                                 unsigned int hashlen,
                                 const unsigned char *hash,
                                 unsigned char *sig )
{
    int ret;
    size_t len, siglen;
    unsigned char *p, c;
    unsigned char buf[POLARSSL_MPI_MAX_SIZE];

    if ( ctx->padding != RSA_PKCS_V15 )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

    siglen = ctx->len;

    if ( siglen < 16 || siglen > sizeof( buf ) )
        return( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

#ifdef CONFIG_EMU_BUILD
    ret = ( mode == RSA_PUBLIC )
          ? rsa_public(  ctx, sig, buf )
          : rsa_private( ctx, sig, buf );
#else
    if (mode != RSA_PUBLIC)
        return ( POLARSSL_ERR_RSA_BAD_INPUT_DATA );

    ret = rsa_public(  ctx, sig, buf );
#endif /* CONFIG_EMU_BUILD */

    if ( ret != 0 )
        return( ret );

    p = buf;

    if ( *p++ != 0 || *p++ != RSA_SIGN )
        return( POLARSSL_ERR_RSA_INVALID_PADDING );

    while ( *p != 0 )
    {
        if ( p >= buf + siglen - 1 || *p != 0xFF )
            return( POLARSSL_ERR_RSA_INVALID_PADDING );
        p++;
    }
    p++;

    len = siglen - ( p - buf );

    if ( len == 33 && hash_id == SIG_RSA_SHA1 )
    {
        if ( memcmp( p, ASN1_HASH_SHA1_ALT, 13 ) == 0 &&
                memcmp( p + 13, hash, 20 ) == 0 )
            return( 0 );
        else
            return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    }
    if ( len == 34 )
    {
        c = p[13];
        p[13] = 0;

        if ( memcmp( p, ASN1_HASH_MDX, 18 ) != 0 )
            return( POLARSSL_ERR_RSA_VERIFY_FAILED );

        if ( ( c == 2 && hash_id == SIG_RSA_MD2 ) ||
                ( c == 4 && hash_id == SIG_RSA_MD4 ) ||
                ( c == 5 && hash_id == SIG_RSA_MD5 ) )
        {
            if ( memcmp( p + 18, hash, 16 ) == 0 )
                return( 0 );
            else
                return( POLARSSL_ERR_RSA_VERIFY_FAILED );
        }
    }

    if ( len == 35 && hash_id == SIG_RSA_SHA1 )
    {
        if ( memcmp( p, ASN1_HASH_SHA1, 15 ) == 0 &&
                memcmp( p + 15, hash, 20 ) == 0 )
            return( 0 );
        else
            return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    }
    if ( ( len == 19 + 28 && p[14] == 4 && hash_id == SIG_RSA_SHA224 ) ||
            ( len == 19 + 32 && p[14] == 1 && hash_id == SIG_RSA_SHA256 ) ||
            ( len == 19 + 48 && p[14] == 2 && hash_id == SIG_RSA_SHA384 ) ||
            ( len == 19 + 64 && p[14] == 3 && hash_id == SIG_RSA_SHA512 ) )
    {
        c = p[1] - 17;
        p[1] = 17;
        p[14] = 0;

        if( p[18] == c &&
                memcmp( p, ASN1_HASH_SHA2X, 18 ) == 0 &&
                memcmp( p + 19, hash, c ) == 0 )
            return( 0 );
        else
            return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    }

    if ( len == hashlen && hash_id == SIG_RSA_RAW )
    {
        if ( memcmp( p, hash, hashlen ) == 0 )
            return( 0 );
        else
            return( POLARSSL_ERR_RSA_VERIFY_FAILED );
    }

    return( POLARSSL_ERR_RSA_INVALID_PADDING );
}

/*
 * Do an RSA operation and check the message digest
 */
int rsa_pkcs1_verify( rsa_context *ctx,
                      int mode,
                      int hash_id,
                      unsigned int hashlen,
                      const unsigned char *hash,
                      unsigned char *sig )
{
    int ret;
    switch ( ctx->padding )
    {
        case RSA_PKCS_V15:
            ret = rsa_rsassa_pkcs1_v15_verify( ctx, mode, hash_id,
                                                hashlen, hash, sig );
            break;
        default:
            return( POLARSSL_ERR_RSA_INVALID_PADDING );
    }

    return ret;
}

/*
 * Free the components of an RSA key
 */
void rsa_free( rsa_context *ctx )
{
    mpi_free( &ctx->RQ ); mpi_free( &ctx->RP ); mpi_free( &ctx->RN );
    mpi_free( &ctx->QP ); mpi_free( &ctx->DQ ); mpi_free( &ctx->DP );
    mpi_free( &ctx->Q  ); mpi_free( &ctx->P  ); mpi_free( &ctx->D );
    mpi_free( &ctx->E  ); mpi_free( &ctx->N  );
}

#endif
