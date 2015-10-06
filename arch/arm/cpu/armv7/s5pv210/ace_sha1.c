/*
 * Copyright (c) 2009 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * SHA1 Code using ACE (Advanced Crypto Engine)
 *
 * Based on SHA1 F/W Code
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <ace_sha1.h>


/*****************************************************************
	Definitions
*****************************************************************/
#define read_u32(_addr_)	\
	(*(volatile unsigned int*)(_addr_))
#define write_u32(_addr_, _val_)	\
	do {*(volatile unsigned int*)(_addr_) = (unsigned int)(_val_);} while(0)


/*****************************************************************
	Functions
*****************************************************************/
/**
 * @brief	This function computes hash value of input (pBuf[0]..pBuf[buflen-1]).
 *
 * @param	pOut	A pointer to the output buffer. When operation is completed
 * 					20 bytes are copied to pOut[0]...pOut[19]. Thus, a user
 * 					should allocate at least 20 bytes at pOut in advance.
 * @param	pBuf	A pointer to the input buffer
 * @param	bufLen	Byte length of input buffer
 *
 * @return	0		Success
 *
 * @remark	This function assumes that pBuf is a physical address of input buffer.
 *
 * @version V1.00
 * @b Revision History
 *		- V01.00	2009.11.13/djpark	Initial Version
 */
int SHA1_digest (
	unsigned char*	pOut,
	unsigned char*	pBuf,
	unsigned int	bufLen
)
{
	unsigned int reg;
	unsigned int* pDigest;

	/* Flush HRDMA */
	write_u32(ACE_FC_HRDMAC, FC_HRDMACFLUSH_ON);
	write_u32(ACE_FC_HRDMAC, FC_HRDMACFLUSH_OFF);

	/* Set byte swap of data in */
	write_u32(ACE_HASH_BYTESWAP, HASH_SWAPDI_ON | HASH_SWAPDO_ON);

	/* Select Hash input mux as external source */
	reg = read_u32(ACE_FC_FIFOCTRL);
	reg = (reg & ~FC_SELHASH_MASK) | FC_SELHASH_EXOUT;
	write_u32(ACE_FC_FIFOCTRL, reg);

	/* Set Hash as SHA1 and start Hash engine */
	reg = HASH_ENGSEL_SHA1HASH | HASH_STARTBIT_ON;
	write_u32(ACE_HASH_CONTROL, reg);

	/* Enable FIFO mode */
	write_u32(ACE_HASH_FIFO_MODE, HASH_FIFO_ON);

	/* Set message length */
	write_u32(ACE_HASH_MSGSIZE_LOW, bufLen);
	write_u32(ACE_HASH_MSGSIZE_HIGH, 0);

	/* Set HRDMA */
	write_u32(ACE_FC_HRDMAS, (unsigned int)pBuf);
	write_u32(ACE_FC_HRDMAL, bufLen);

	do
	{
		reg = read_u32(ACE_HASH_STATUS) & HASH_MSGDONE_MASK;
	} while (reg == HASH_MSGDONE_OFF);

	/* Clear MSG_DONE bit */
	write_u32(ACE_HASH_STATUS, reg);

	/* Read hash result */
	pDigest = (unsigned int*)pOut;
	pDigest[0] = read_u32(ACE_HASH_OUT1);
	pDigest[1] = read_u32(ACE_HASH_OUT2);
	pDigest[2] = read_u32(ACE_HASH_OUT3);
	pDigest[3] = read_u32(ACE_HASH_OUT4);
	pDigest[4] = read_u32(ACE_HASH_OUT5);

	/* Clear HRDMA pending bit */
	write_u32(ACE_FC_INTPEND, FC_HRDMA);

	return 0;
}

