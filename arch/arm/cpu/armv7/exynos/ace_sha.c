/*
 * Advanced Crypto Engine - SHA Firmware
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

#include <common.h>
#include <asm/arch/ace_sfr.h>
#include <asm/arch/ace_sha.h>


#if defined(CONFIG_ARCH_EXYNOS)

/*****************************************************************
	Definitions
*****************************************************************/
#define ACE_read_sfr(_sfr_)	\
	(*(volatile unsigned int*)(ACE_SFR_BASE + _sfr_))
#define ACE_write_sfr(_sfr_, _val_)	\
	do {*(volatile unsigned int*)(ACE_SFR_BASE + _sfr_)	\
		= (unsigned int)(_val_); } while (0)


/* SHA1 value for the message of zero length */
const unsigned char sha1_digest_emptymsg[20] = {
	0xDA, 0x39, 0xA3, 0xEE, 0x5E, 0x6B, 0x4B, 0x0D,
	0x32, 0x55, 0xBF, 0xFF, 0x95, 0x60, 0x18, 0x90,
	0xAF, 0xD8, 0x07, 0x09};

/* SHA256 value for the message of zero length */
const unsigned char sha256_digest_emptymsg[32] = {
	0xE3, 0xB0, 0xC4, 0x42, 0x98, 0xFC, 0x1C, 0x14,
	0x9A, 0xFB, 0xF4, 0xC8, 0x99, 0x6F, 0xB9, 0x24,
	0x27, 0xAE, 0x41, 0xE4, 0x64, 0x9B, 0x93, 0x4C,
	0xA4, 0x95, 0x99, 0x1B, 0x78, 0x52, 0xB8, 0x55};

/*****************************************************************
	Functions
*****************************************************************/
/**
 * @brief	This function computes hash value of input (pBuf[0]..pBuf[buflen-1]).
 *
 * @param	pOut	A pointer to the output buffer. When operation is completed
 *			20/32 bytes are copied to pOut[0]...pOut[31]. Thus, a user
 *			should allocate at least 20/32 bytes at pOut in advance.
 * @param	pBuf	A pointer to the input buffer
 * @param	bufLen	Byte length of input buffer
 *
 * @return	0	Success
 *
 * @remark	This function assumes that pBuf is a physical address of input buffer.
 *
 * @version V1.00
 * @b Revision History
 *	- V01.00	2009.11.13/djpark	Initial Version
 *	- V01.10	2010.10.19/djpark	Modification to support C210/V310
 */
int ace_hash_sha_digest(
	unsigned char	*pOut,
	unsigned char	*pBuf,
	unsigned int	bufLen,
	int		alg
)
{
	unsigned int reg;
	unsigned int *pDigest;

	/* ACE H/W cannot compute hash value for empty string */
	if (bufLen == 0) {
		if (alg == ALG_SHA1)
			memcpy(pOut, sha1_digest_emptymsg, SHA1_DIGEST_LEN);
		else
			memcpy(pOut, sha256_digest_emptymsg,
			SHA256_DIGEST_LEN);
		return 0;
	}

	/* Flush HRDMA */
	ACE_write_sfr(ACE_FC_HRDMAC, ACE_FC_HRDMACFLUSH_ON);
	ACE_write_sfr(ACE_FC_HRDMAC, ACE_FC_HRDMACFLUSH_OFF);

	/* Set byte swap of data in */
	ACE_write_sfr(ACE_HASH_BYTESWAP,
		ACE_HASH_SWAPDI_ON | ACE_HASH_SWAPDO_ON | ACE_HASH_SWAPIV_ON);

	/* Select Hash input mux as external source */
	reg = ACE_read_sfr(ACE_FC_FIFOCTRL);
	reg = (reg & ~ACE_FC_SELHASH_MASK) | ACE_FC_SELHASH_EXOUT;
	ACE_write_sfr(ACE_FC_FIFOCTRL, reg);

	/* Set Hash as SHA1 or SHA256 and start Hash engine */
	if (alg == ALG_SHA1)
		reg = ACE_HASH_ENGSEL_SHA1HASH | ACE_HASH_STARTBIT_ON;
	else
		reg = ACE_HASH_ENGSEL_SHA256HASH | ACE_HASH_STARTBIT_ON;
	ACE_write_sfr(ACE_HASH_CONTROL, reg);

	/* Enable FIFO mode */
	ACE_write_sfr(ACE_HASH_FIFO_MODE, ACE_HASH_FIFO_ON);

	/* Set message length */
	ACE_write_sfr(ACE_HASH_MSGSIZE_LOW, bufLen);
	ACE_write_sfr(ACE_HASH_MSGSIZE_HIGH, 0);

	/* Set HRDMA */
	ACE_write_sfr(ACE_FC_HRDMAS, (unsigned int)virt_to_phys(pBuf));
	ACE_write_sfr(ACE_FC_HRDMAL, bufLen);

	while ((ACE_read_sfr(ACE_HASH_STATUS) & ACE_HASH_MSGDONE_MASK)
			== ACE_HASH_MSGDONE_OFF)
		;

	/* Clear MSG_DONE bit */
	ACE_write_sfr(ACE_HASH_STATUS, ACE_HASH_MSGDONE_ON);

	/* Read hash result */
	pDigest = (unsigned int *)pOut;
	pDigest[0] = ACE_read_sfr(ACE_HASH_RESULT1);
	pDigest[1] = ACE_read_sfr(ACE_HASH_RESULT2);
	pDigest[2] = ACE_read_sfr(ACE_HASH_RESULT3);
	pDigest[3] = ACE_read_sfr(ACE_HASH_RESULT4);
	pDigest[4] = ACE_read_sfr(ACE_HASH_RESULT5);

	if (alg == ALG_SHA256) {
		pDigest[5] = ACE_read_sfr(ACE_HASH_RESULT6);
		pDigest[6] = ACE_read_sfr(ACE_HASH_RESULT7);
		pDigest[7] = ACE_read_sfr(ACE_HASH_RESULT8);
	}

	/* Clear HRDMA pending bit */
	ACE_write_sfr(ACE_FC_INTPEND, ACE_FC_HRDMA);

	return 0;
}

#endif

