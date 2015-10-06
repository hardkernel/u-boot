/*
 * Copyright (c) 2009 Samsung Electronics Co., Ltd.
 *              http://www.samsung.com/
 *
 * Header file for Advanced Crypto Engine (ACE)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
 
#ifndef __ACE_SFR_H__
#define __ACE_SFR_H__

#ifdef __cplusplus
extern "C" {
#endif


/*****************************************************************
	SFR Addresses
*****************************************************************/
#define ACE_BASE			(0xEA000000)
#define ACE_FC_BASE			(ACE_BASE + 0x0)
#define ACE_AES_BASE		(ACE_BASE + 0x4000)
#define ACE_TDES_BASE		(ACE_BASE + 0x5000)
#define ACE_HASH_BASE		(ACE_BASE + 0x6000)
#define ACE_PKA_BASE		(ACE_BASE + 0x7000)

/* Feed control registers */
#define ACE_FC_INTSTAT			(ACE_FC_BASE + 0x00)
#define ACE_FC_INTENSET			(ACE_FC_BASE + 0x04)
#define ACE_FC_INTENCLR			(ACE_FC_BASE + 0x08)
#define ACE_FC_INTPEND			(ACE_FC_BASE + 0x0C)
#define ACE_FC_FIFOSTAT			(ACE_FC_BASE + 0x10)
#define ACE_FC_FIFOCTRL			(ACE_FC_BASE + 0x14)
#define ACE_FC_BRDMAS			(ACE_FC_BASE + 0x20)
#define ACE_FC_BRDMAL			(ACE_FC_BASE + 0x24)
#define ACE_FC_BRDMAC			(ACE_FC_BASE + 0x28)
#define ACE_FC_BTDMAS			(ACE_FC_BASE + 0x30)
#define ACE_FC_BTDMAL			(ACE_FC_BASE + 0x34)
#define ACE_FC_BTDMAC			(ACE_FC_BASE + 0x38)
#define ACE_FC_HRDMAS			(ACE_FC_BASE + 0x40)
#define ACE_FC_HRDMAL			(ACE_FC_BASE + 0x44)
#define ACE_FC_HRDMAC			(ACE_FC_BASE + 0x48)
#define ACE_FC_PKDMAS			(ACE_FC_BASE + 0x50)
#define ACE_FC_PKDMAL			(ACE_FC_BASE + 0x54)
#define ACE_FC_PKDMAC			(ACE_FC_BASE + 0x58)
#define ACE_FC_PKDMAO			(ACE_FC_BASE + 0x5C)

/* AES control registers */
#define ACE_AES_CONTROL			(ACE_AES_BASE + 0x00)
#define ACE_AES_STATUS			(ACE_AES_BASE + 0x04)

#define ACE_AES_IN1				(ACE_AES_BASE + 0x10)
#define ACE_AES_IN2				(ACE_AES_BASE + 0x14)
#define ACE_AES_IN3				(ACE_AES_BASE + 0x18)
#define ACE_AES_IN4				(ACE_AES_BASE + 0x1C)

#define ACE_AES_OUT1			(ACE_AES_BASE + 0x20)
#define ACE_AES_OUT2			(ACE_AES_BASE + 0x24)
#define ACE_AES_OUT3			(ACE_AES_BASE + 0x28)
#define ACE_AES_OUT4			(ACE_AES_BASE + 0x2C)

#define ACE_AES_IV1				(ACE_AES_BASE + 0x30)
#define ACE_AES_IV2				(ACE_AES_BASE + 0x34)
#define ACE_AES_IV3				(ACE_AES_BASE + 0x38)
#define ACE_AES_IV4				(ACE_AES_BASE + 0x3C)

#define ACE_AES_CNT1			(ACE_AES_BASE + 0x40)
#define ACE_AES_CNT2			(ACE_AES_BASE + 0x44)
#define ACE_AES_CNT3			(ACE_AES_BASE + 0x48)
#define ACE_AES_CNT4			(ACE_AES_BASE + 0x4C)

#define ACE_AES_KEY1			(ACE_AES_BASE + 0x80)
#define ACE_AES_KEY2			(ACE_AES_BASE + 0x84)
#define ACE_AES_KEY3			(ACE_AES_BASE + 0x88)
#define ACE_AES_KEY4			(ACE_AES_BASE + 0x8C)
#define ACE_AES_KEY5			(ACE_AES_BASE + 0x90)
#define ACE_AES_KEY6			(ACE_AES_BASE + 0x94)
#define ACE_AES_KEY7			(ACE_AES_BASE + 0x98)
#define ACE_AES_KEY8			(ACE_AES_BASE + 0x9C)

/* TDES control registers */
#define ACE_TDES_CONTROL		(ACE_TDES_BASE + 0x00)
#define ACE_TDES_STATUS			(ACE_TDES_BASE + 0x04)

#define ACE_TDES_KEY11			(ACE_TDES_BASE + 0x10)
#define ACE_TDES_KEY12			(ACE_TDES_BASE + 0x14)
#define ACE_TDES_KEY21			(ACE_TDES_BASE + 0x18)
#define ACE_TDES_KEY22			(ACE_TDES_BASE + 0x1C)
#define ACE_TDES_KEY31			(ACE_TDES_BASE + 0x20)
#define ACE_TDES_KEY32			(ACE_TDES_BASE + 0x24)

#define ACE_TDES_IV1			(ACE_TDES_BASE + 0x28)
#define ACE_TDES_IV2			(ACE_TDES_BASE + 0x2C)

#define ACE_TDES_IN1			(ACE_TDES_BASE + 0x30)
#define ACE_TDES_IN2			(ACE_TDES_BASE + 0x34)

#define ACE_TDES_OUT1			(ACE_TDES_BASE + 0x38)
#define ACE_TDES_OUT2			(ACE_TDES_BASE + 0x3C)

/* HASH control registers */
#define ACE_HASH_CONTROL		(ACE_HASH_BASE + 0x00)
#define ACE_HASH_CONTROL2		(ACE_HASH_BASE + 0x04)
#define ACE_HASH_FIFO_MODE		(ACE_HASH_BASE + 0x08)
#define ACE_HASH_BYTESWAP		(ACE_HASH_BASE + 0x0C)
#define ACE_HASH_STATUS			(ACE_HASH_BASE + 0x10)
#define ACE_HASH_MSGSIZE_LOW	(ACE_HASH_BASE + 0x14)
#define ACE_HASH_MSGSIZE_HIGH	(ACE_HASH_BASE + 0x18)

#define ACE_HASH_IN1			(ACE_HASH_BASE + 0x20)
#define ACE_HASH_IN2			(ACE_HASH_BASE + 0x24)
#define ACE_HASH_IN3			(ACE_HASH_BASE + 0x28)
#define ACE_HASH_IN4			(ACE_HASH_BASE + 0x2C)
#define ACE_HASH_IN5			(ACE_HASH_BASE + 0x30)
#define ACE_HASH_IN6			(ACE_HASH_BASE + 0x34)
#define ACE_HASH_IN7			(ACE_HASH_BASE + 0x38)
#define ACE_HASH_IN8			(ACE_HASH_BASE + 0x3C)

#define ACE_HASH_SEED1			(ACE_HASH_BASE + 0x40)
#define ACE_HASH_SEED2			(ACE_HASH_BASE + 0x44)
#define ACE_HASH_SEED3			(ACE_HASH_BASE + 0x48)
#define ACE_HASH_SEED4			(ACE_HASH_BASE + 0x4C)
#define ACE_HASH_SEED5			(ACE_HASH_BASE + 0x50)

#define ACE_HASH_OUT1			(ACE_HASH_BASE + 0x60)
#define ACE_HASH_OUT2			(ACE_HASH_BASE + 0x64)
#define ACE_HASH_OUT3			(ACE_HASH_BASE + 0x68)
#define ACE_HASH_OUT4			(ACE_HASH_BASE + 0x6C)
#define ACE_HASH_OUT5			(ACE_HASH_BASE + 0x70)

#define ACE_HASH_PRNGOUT1		(ACE_HASH_BASE + 0x80)
#define ACE_HASH_PRNGOUT2		(ACE_HASH_BASE + 0x84)
#define ACE_HASH_PRNGOUT3		(ACE_HASH_BASE + 0x88)
#define ACE_HASH_PRNGOUT4		(ACE_HASH_BASE + 0x8C)
#define ACE_HASH_PRNGOUT5		(ACE_HASH_BASE + 0x90)

#define ACE_HASH_IV1			(ACE_HASH_BASE + 0xA0)
#define ACE_HASH_IV2			(ACE_HASH_BASE + 0xA4)
#define ACE_HASH_IV3			(ACE_HASH_BASE + 0xA8)
#define ACE_HASH_IV4			(ACE_HASH_BASE + 0xAC)
#define ACE_HASH_IV5			(ACE_HASH_BASE + 0xB0)

#define ACE_HASH_PRELEN_HIGH	(ACE_HASH_BASE + 0xC0)
#define ACE_HASH_PRELEN_LOW		(ACE_HASH_BASE + 0xC4)

/* PKA control registers */
#define ACE_PKA_SFR0			(ACE_PKA_BASE + 0x00)
#define ACE_PKA_SFR1			(ACE_PKA_BASE + 0x04)
#define ACE_PKA_SFR2			(ACE_PKA_BASE + 0x08)
#define ACE_PKA_SFR3			(ACE_PKA_BASE + 0x0C)
#define ACE_PKA_SFR4			(ACE_PKA_BASE + 0x10)


/*****************************************************************
	OFFSET
*****************************************************************/

/* FC_INT */
#define FC_PKDMA				(1 << 0)
#define FC_HRDMA				(1 << 1)
#define FC_BTDMA				(1 << 2)
#define FC_BRDMA				(1 << 3)

/* FC_FIFOSTAT */
#define FC_PKFIFO_EMPTY			(1 << 0)
#define FC_PKFIFO_FULL			(1 << 1)
#define FC_HRFIFO_EMPTY			(1 << 2)
#define FC_HRFIFO_FULL			(1 << 3)
#define FC_BTFIFO_EMPTY			(1 << 4)
#define FC_BTFIFO_FULL			(1 << 5)
#define FC_BRFIFO_EMPTY			(1 << 6)
#define FC_BRFIFO_FULL			(1 << 7)

/* FC_FIFOCTRL */
#define FC_SELHASH_MASK			(3 << 0)
#define FC_SELHASH_EXOUT		(0 << 0)	// independent source
#define FC_SELHASH_BCIN			(1 << 0)	// block cipher input
#define FC_SELHASH_BCOUT		(2 << 0)	// block cipher output
#define FC_SELBC_MASK			(1 << 2)
#define FC_SELBC_AES			(0 << 2)	// AES	
#define FC_SELBC_DES			(1 << 2)	// DES

/* Feed control - BRDMA control */
#define FC_BRDMACFLUSH_OFF		(0 << 0)
#define FC_BRDMACFLUSH_ON		(1 << 0)
#define FC_BRDMACSWAP_ON		(1 << 1)

/* Feed control - BTDMA control */
#define FC_BTDMACFLUSH_OFF		(0 << 0)
#define FC_BTDMACFLUSH_ON		(1 << 0)
#define FC_BTDMACSWAP_ON		(1 << 1)

/* Feed control - HRDMA control */
#define FC_HRDMACFLUSH_OFF		(0 << 0)
#define FC_HRDMACFLUSH_ON		(1 << 0)
#define FC_HRDMACSWAP_ON		(1 << 1)

/* Feed control - PKDMA control */
#define FC_PKDMACBYTESWAP_ON	(1 << 3)
#define FC_PKDMACDESEND_ON		(1 << 2)
#define FC_PKDMACTRANSMIT_ON	(1 << 1)
#define FC_PKDMACFLUSH_ON		(1 << 0)

/* Feed control - PKDMA offset */
#define FC_SRAMOFFSET_MASK		(0xFFF)

/* AES control */
#define AES_MODE_MASK			(1 << 0)
#define AES_MODE_ENC			(0 << 0)
#define AES_MODE_DEC			(1 << 0)
#define AES_OPERMODE_MASK		(3 << 1)
#define AES_OPERMODE_ECB		(0 << 1)
#define AES_OPERMODE_CBC		(1 << 1)
#define AES_OPERMODE_CTR		(2 << 1)
#define AES_FIFO_MASK			(1 << 3)
#define AES_FIFO_OFF			(0 << 3)	// CPU mode
#define AES_FIFO_ON				(1 << 3)	// FIFO mode
#define AES_KEYSIZE_MASK		(3 << 4)
#define AES_KEYSIZE_128			(0 << 4)
#define AES_KEYSIZE_192			(1 << 4)
#define AES_KEYSIZE_256			(2 << 4)
#define AES_KEYCNGMODE_MASK		(1 << 6)
#define AES_KEYCNGMODE_OFF		(0 << 6)
#define AES_KEYCNGMODE_ON		(1 << 6)
#define AES_SWAP_MASK			(0x1F << 7)
#define AES_SWAPKEY_OFF			(0 << 7)
#define AES_SWAPKEY_ON			(1 << 7)
#define AES_SWAPCNT_OFF			(0 << 8)
#define AES_SWAPCNT_ON			(1 << 8)
#define AES_SWAPIV_OFF			(0 << 9)
#define AES_SWAPIV_ON			(1 << 9)
#define AES_SWAPDO_OFF			(0 << 10)
#define AES_SWAPDO_ON			(1 << 10)
#define AES_SWAPDI_OFF			(0 << 11)
#define AES_SWAPDI_ON			(1 << 11)

/* AES status */
#define AES_OUTRDY_MASK			(1 << 0)
#define AES_OUTRDY_OFF			(0 << 0)
#define AES_OUTRDY_ON			(1 << 0)
#define AES_INRDY_MASK			(1 << 1)
#define AES_INRDY_OFF			(0 << 1)
#define AES_INRDY_ON			(1 << 1)
#define AES_BUSY_MASK			(1 << 2)
#define AES_BUSY_OFF			(0 << 2)
#define AES_BUSY_ON				(1 << 2)

/* TDES control */
#define TDES_MODE_MASK			(1 << 0)
#define TDES_MODE_ENC			(0 << 0)
#define TDES_MODE_DEC			(1 << 0)
#define TDES_OPERMODE_MASK		(1 << 1)
#define TDES_OPERMODE_ECB		(0 << 1)
#define TDES_OPERMODE_CBC		(1 << 1)
#define TDES_SEL_MASK			(3 << 3)
#define TDES_SEL_DES			(0 << 3)
#define TDES_SEL_TDESEDE		(1 << 3)	// TDES EDE mode
#define TDES_SEL_TDESEEE		(3 << 3)	// TDES EEE mode
#define TDES_FIFO_MASK			(1 << 5)
#define TDES_FIFO_OFF			(0 << 5)	// CPU mode
#define TDES_FIFO_ON			(1 << 5)	// FIFO mode
#define TDES_SWAP_MASK			(0xF << 6)
#define TDES_SWAPKEY_OFF		(0 << 6)
#define TDES_SWAPKEY_ON			(1 << 6)
#define TDES_SWAPIV_OFF			(0 << 7)
#define TDES_SWAPIV_ON			(1 << 7)
#define TDES_SWAPDO_OFF			(0 << 8)
#define TDES_SWAPDO_ON			(1 << 8)
#define TDES_SWAPDI_OFF			(0 << 9)
#define TDES_SWAPDI_ON			(1 << 9)

/* Hash control */
#define HASH_ENGSEL_MASK		(0xF << 0)
#define HASH_ENGSEL_SHA1HASH	(0x0 << 0)
#define HASH_ENGSEL_SHA1HMACIN	(0x1 << 0)
#define HASH_ENGSEL_SHA1HMACOUT	(0x9 << 0)
#define HASH_ENGSEL_MD5HASH		(0x2 << 0)
#define HASH_ENGSEL_MD5HMACIN	(0x3 << 0)
#define HASH_ENGSEL_MD5HMACOUT	(0xB << 0)
#define HASH_ENGSEL_PRNG		(0x4 << 0)
#define HASH_STARTBIT_ON		(1 << 4)
#define HASH_USERIV_EN			(1 << 5)

/* Hash control 2 */
#define HASH_PAUSE_ON			(1 << 3)

/* Hash control - FIFO mode */
#define HASH_FIFO_MASK			(1 << 0)
#define HASH_FIFO_OFF			(0 << 0)
#define HASH_FIFO_ON			(1 << 0)

/* Hash control - byte swap */
#define HASH_SWAP_MASK			(0x7 << 1)
#define HASH_SWAPIV_OFF			(0 << 1)
#define	HASH_SWAPIV_ON			(1 << 1)
#define HASH_SWAPDO_OFF			(0 << 2)
#define HASH_SWAPDO_ON			(1 << 2)
#define HASH_SWAPDI_OFF			(0 << 3)
#define HASH_SWAPDI_ON			(1 << 3)

/* Hash status */
#define HASH_BUFRDY_MASK		(1 << 0)
#define HASH_BUFRDY_OFF			(0 << 0)
#define HASH_BUFRDY_ON			(1 << 0)
#define HASH_SEEDSETTING_MASK	(1 << 1)
#define HASH_SEEDSETTING_OFF	(0 << 1)
#define HASH_SEEDSETTING_ON		(1 << 1)
#define HASH_PRNGBUSY_MASK		(1 << 2)
#define HASH_PRNGBUSY_OFF		(0 << 2)
#define HASH_PRNGBUSY_ON		(1 << 2)
#define HASH_PARTIALDONE_MASK	(1 << 4)
#define HASH_PARTIALDONE_OFF	(0 << 4)
#define HASH_PARTIALDONE_ON		(1 << 4)
#define HASH_PRNGDONE_MASK		(1 << 5)
#define HASH_PRNGDONE_OFF		(0 << 5)
#define HASH_PRNGDONE_ON		(1 << 5)
#define HASH_MSGDONE_MASK		(1 << 6)
#define HASH_MSGDONE_OFF		(0 << 6)
#define HASH_MSGDONE_ON			(1 << 6)
#define HASH_PRNGERROR_MASK		(1 << 7)
#define HASH_PRNGERROR_OFF		(0 << 7)
#define HASH_PRNGERROR_ON		(1 << 7)

/* To Do: SFRs for PKA */

#ifdef __cplusplus
}
#endif

#endif 

