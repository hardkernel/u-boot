/*
 * $Id: nand_wite_bl.c,v 1.1 2008/11/20 01:08:36 boyko Exp $
 *
 * (C) Copyright 2006 Samsung Electronics
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

/*
 * You must make sure that all functions in this file are designed
 * to write only U-Boot BL1/2 image.
 *
 * So, DO NOT USE in common write.
 *
 * By scsuh.
 */


#include <common.h>

#ifdef CONFIG_S5PC210
#include <asm/io.h>
#include <linux/mtd/nand.h>
#include <asm/arch/s5p_nand.h>


#define	MAX_ECC_LEN		96
#define NAND_RANDOMIZER_SEED			(0x59A9)
#define	NFRANDSEED		(ELFIN_NAND_BASE+0x20050)

#define NAND_CONTROL_ENABLE()	(writel(readl(NFCONT)|(1<<0),NFCONT))
#define NAND_SEL_ECC16()	(writel((readl(NFECCCONF)&~(0xf<<0))|(0x5<<0),NFECCCONF))
#define NAND_ECC_SETDIR_ENC()	(writel(readl(NFECCCONT)|(1<<16),NFECCCONT))
#define NAND_ECC_SET_MSGLEN(msg)	(writel((readl(NFECCCONF)&~(0x7ff<<16))|(((msg)-1)<<16),NFECCCONF))
#define NAND_CLEAR_RB()	(writel(readl(NFSTAT)|(1<<4),NFSTAT))
#define NAND_ILL_ACC_CLEAR()	(writel(readl(NFSTAT)|(1<<5),NFSTAT))
#define NAND_ECC_ENC_DONE_CLEAR()	(writel(readl(NFECCSTAT)|(1<<25),NFECCSTAT))
#define NAND_nFCE_L(n)		(writel(readl(NFCONT)&~(1<<((n>1)?(20+n):(n+1))),NFCONT))
#define NAND_nFCE_H(n)		(writel(readl(NFCONT)|(1<<((n>1)?(20+n):(n+1))),NFCONT))
#define NAND_CMD(cmd)		(writel((cmd),NFCMMD))
#define NAND_ADDR(addr)	(writel((addr),NFADDR))
#define NAND_MECC_UnLock()	(writel(readl(NFCONT)&~(1<<7),NFCONT))
#define NAND_MECC_Lock()	(writel(readl(NFCONT)|(1<<7),NFCONT))
#define NAND_RSTECC()		{(writel(readl(NFCONT)|((1<<5)|(1<<4)),NFCONT));\
				(writel(readl(NFECCCONT)|(1<<2),NFECCCONT));}
#define NAND_ECC_LOOP_UNTIL_ENC_DONE()	{while(!(readl(NFECCSTAT)&(1<<25)));}
#define NAND_IS_LOCKED()	(readl(NFSTAT)&(1<<5))
#define NAND_DETECT_RB()	{while(!(readl(NFSTAT)&(1<<4)));}

#define NAND_SET_RND_SEED(seed)	(writel((seed),NFRANDSEED))
#define NAND_RESET_RND()	(writel(readl(NFECCCONT)|(1<<23),NFECCCONT))
#define NAND_ENABLE_RND()	(writel(readl(NFECCCONT)|(1<<22),NFECCCONT))
#define NAND_DISABLE_RND()	(writel(readl(NFECCCONT)&~(1<<22),NFECCCONT))



static void nandll_calculate_ecc(uchar *ecc_code)
{
	int	i;
	u_long	uRead0, uRead1, uRead2, uRead3, uRead4, uRead5, uRead6;

	uRead0 = readl(NFECCPRGECC0);  
	uRead1 = readl(NFECCPRGECC1);  
	uRead2 = readl(NFECCPRGECC2);  
	uRead3 = readl(NFECCPRGECC3);  
	uRead4 = readl(NFECCPRGECC4);  
	uRead5 = readl(NFECCPRGECC5);  
	uRead6 = readl(NFECCPRGECC6);  

	for(i=0;i<4; i++) *ecc_code++ = (uRead0>>(8*i))&0xff;
	for(i=0;i<4; i++) *ecc_code++ = (uRead1>>(8*i))&0xff;
	for(i=0;i<4; i++) *ecc_code++ = (uRead2>>(8*i))&0xff;
	for(i=0;i<4; i++) *ecc_code++ = (uRead3>>(8*i))&0xff;
	for(i=0;i<4; i++) *ecc_code++ = (uRead4>>(8*i))&0xff;
	for(i=0;i<4; i++) *ecc_code++ = (uRead5>>(8*i))&0xff;
	for(i=0;i<4; i++) *ecc_code++ = (uRead6>>(8*i))&0xff;

	return;
}



/*
 * address format
 *              17 16         9 8            0
 * --------------------------------------------
 * | block(12bit) | page(5bit) | offset(9bit) |
 * --------------------------------------------
 */
static int nandll_write_page (uchar *buf, ulong addr, int large_block)
{
        int	i;
	int	page_size = 512, ECCLen=26;
	u16	uRandomSeed=NAND_RANDOMIZER_SEED;
	uchar	ECCData[MAX_ECC_LEN];

	NAND_CLEAR_RB();
	NAND_ILL_ACC_CLEAR();
	NAND_ECC_ENC_DONE_CLEAR();

	NAND_nFCE_L(0);		/* Force nRCS[0] to low (Enable chip select) */

	NAND_CMD(NAND_CMD_SEQIN);	/* Write command, 0x80	*/

        /* Write Address */
	NAND_ADDR(0);
  	if (large_block) NAND_ADDR(0);
	NAND_ADDR((addr) & 0xff);
	NAND_ADDR((addr>>8) & 0xff);
	NAND_ADDR((addr>>16) & 0xff);

	NAND_MECC_UnLock();
	NAND_RSTECC();

	NAND_SET_RND_SEED(uRandomSeed);
	NAND_RESET_RND();
	NAND_ENABLE_RND();

	for(i=0; i < page_size; i++)
	{
		NFDATA8_REG = *buf++;
	}

	NAND_MECC_Lock();

	NAND_ECC_LOOP_UNTIL_ENC_DONE();
	NAND_ECC_ENC_DONE_CLEAR();

	nandll_calculate_ecc(ECCData);

	for(i=0; i<ECCLen; i++)
	{
		NFDATA8_REG = ECCData[i];
	}

	NAND_DISABLE_RND();

 	NAND_CLEAR_RB();
	NAND_CMD(NAND_CMD_PAGEPROG);

	if(NAND_IS_LOCKED()) 
	{	
		NAND_ILL_ACC_CLEAR();
       		NAND_nFCE_H(0);
		return 1;
	}

#if	0
	if( NAND_DETECT_RB() == false )
	{
		NAND_nFCE_H(0);
		return 1;
	}
#else
	NAND_DETECT_RB();
#endif

	NAND_CMD(NAND_CMD_STATUS);   // Read status command

	for(i=0; i<1000; i++) 
	{

		if ( NFDATA8_REG&0x40 ) break;
	}

	if( NFDATA8_REG & 1)
	{
		NAND_nFCE_H(0);
		return 1;
	}

	NAND_nFCE_H(0);

	return 0;
}

/*
 * Read data from NAND.
 */
static int nandll_write_blocks (ulong src_addr, int dest_page, ulong size, int large_block)
{
	uchar	*buf = (uchar *)src_addr;
	uchar	local_buf[512];
	int	i, j;
	ulong	checksum;
	int	ret;

        NAND_ENABLE_CE();

	/*
	 * from AP team's iROM code
	 */
	NAND_ECC_SETDIR_ENC();
	NAND_SEL_ECC16();
	NAND_ECC_SET_MSGLEN(512);

	checksum=0;
	for (i = dest_page; i < dest_page+size; i++, buf+=512)
	{
#ifdef CONFIG_EVT1
		if (i==43||i==75)
#else
		if (i==27||i==59)
#endif
		{
			for (j=0;j<508;j++)
			{
				checksum+=buf[j];
				local_buf[j]=buf[j];
			}
			*((volatile ulong *)(local_buf + 508)) = checksum;
			nandll_write_page(local_buf, i, large_block);
			checksum=0;
		}
		else
		{
#ifdef CONFIG_EVT1
			if (i >= 16)
#endif
				for (j=0;j<512;j++)
				{
				checksum+=buf[j];
				}
			ret = nandll_write_page(buf, i, large_block);
			if(ret)
			{
				printf("nandll_write_page %d fail\n", i);
			}
		}
	}

	NAND_DISABLE_CE();
	return 0;
}

int write_bl1_to_nand (ulong src_addr, int dest_page, int size)
{
	int large_block = 8;
	int i;
	vu_char id;
	/*
	 * dest_page : 0 (BL1) or 32 (BL2)
	 * size : 32 pages (16k bytes)
	 */
	if (dest_page+size>64) return 1;
	if (dest_page && dest_page!=32) return 1;
	if (size!=32 && size!=64) return 1;

	NAND_CONTROL_ENABLE();
        NAND_ENABLE_CE();
        NFCMD_REG = NAND_CMD_READID;
        NFADDR_REG =  0x00;

	/* wait for a while */
        for (i=0; i<200; i++);
	id = NFDATA8_REG;
	id = NFDATA8_REG;

	if (id > 0x80)
		large_block = 1;

	/* write BL1 or BL2 image to NAND.
	 * BL1 : 0 ~ 31 pages.
	 * BL2 : 32 ~ 63 pages.
	 */
	return nandll_write_blocks(src_addr, dest_page, size, large_block);
}
 
#endif

