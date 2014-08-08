/*
 * Header file for SHA firmware
 *
 * Copyright (c) 2010  Samsung Electronics
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

#ifndef __ACE_FW_SHA_H__
#define __ACE_FW_SHA_H__


#ifdef __cplusplus
extern "C" {
#endif

#if defined(CONFIG_ARCH_EXYNOS)

/* Hash Code Length */
#define SHA1_DIGEST_LEN                 20
#define SHA256_DIGEST_LEN               32

enum {
	ALG_SHA1,
	ALG_SHA256,
};

/*****************************************************************
	Functions
*****************************************************************/
int ace_hash_sha_digest(
	unsigned char	*pOut,
	unsigned char	*pBuf,
	unsigned int	bufLen,
	int		alg
);
#endif

#ifdef __cplusplus
}
#endif

#endif

