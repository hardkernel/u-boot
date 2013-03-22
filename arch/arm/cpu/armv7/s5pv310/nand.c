/*
 * (C) Copyright 2006 DENX Software Engineering
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

#include <common.h>

#if defined(CONFIG_CMD_NAND)
#include <nand.h>
#include <asm/arch/s5p_nand.h>

#include <asm/io.h>
#include <asm/errno.h>

/* Nand flash definition values by jsgood */
#define S3C_NAND_TYPE_UNKNOWN	0x0
#define S3C_NAND_TYPE_SLC	0x1
#define S3C_NAND_TYPE_MLC	0x2
#undef	S3C_NAND_DEBUG

/* Nand flash global values by jsgood */
int cur_ecc_mode = 0;
int nand_type = S3C_NAND_TYPE_UNKNOWN;

/* Nand flash oob definition for SLC 512b page size by jsgood */
static struct nand_ecclayout s3c_nand_oob_16 = {
//	.useecc = MTD_NANDECC_AUTOPLACE,	/* Only for U-Boot */
	.eccbytes = 4,
	.eccpos = {1, 2, 3, 4},
	.oobfree = {
		{.offset = 6,
		 . length = 10}}
};

/* Nand flash oob definition for SLC 2k page size by jsgood */
static struct nand_ecclayout s3c_nand_oob_64 = {
//	.useecc = MTD_NANDECC_AUTOPLACE,	/* Only for U-Boot */
	.eccbytes = 16,
	.eccpos = {40, 41, 42, 43, 44, 45, 46, 47,
		   48, 49, 50, 51, 52, 53, 54, 55},
	.oobfree = {
		{.offset = 2,
		 .length = 38}}
};
 
/* Nand flash oob definition for MLC 2k page size by jsgood */
static struct nand_ecclayout s3c_nand_oob_mlc_64 = {
//	.useecc = MTD_NANDECC_AUTOPLACE,	/* Only for U-Boot */
	.eccbytes = 32,
	.eccpos = {
		   32, 33, 34, 35, 36, 37, 38, 39,
		   40, 41, 42, 43, 44, 45, 46, 47,
 		   48, 49, 50, 51, 52, 53, 54, 55,
   		   56, 57, 58, 59, 60, 61, 62, 63},
	.oobfree = {
		{.offset = 2,
		 .length = 28}}
};

/* Nand flash oob definition for 4Kb page size with 8_bit ECC */
static struct nand_ecclayout s3c_nand_oob_128 = {
//        .useecc = MTD_NANDECC_AUTOPLACE,
        .eccbytes = 104,
        .eccpos = {
                   24, 25, 26, 27, 28, 29, 30, 31,
                   32, 33, 34, 35, 36, 37, 38, 39,
                   40, 41, 42, 43, 44, 45, 46, 47,
                   48, 49, 50, 51, 52, 53, 54, 55,
                   56, 57, 58, 59, 60, 61, 62, 63,
                   64, 65, 66, 67, 68, 69, 70, 71,
                   72, 73, 74, 75, 76, 77, 78, 79,
                   80, 81, 82, 83, 84, 85, 86, 87,
                   88, 89, 90, 91, 92, 93, 94, 95,
                   96, 97, 98, 99, 100, 101, 102, 103,
                   104, 105, 106, 107, 108, 109, 110, 111,
                   112, 113, 114, 115, 116, 117, 118, 119,
                   120, 121, 122, 123, 124, 125, 126, 127},
        .oobfree = {
                {.offset = 2,
                 .length = 22}}
};
#if defined(S3C_NAND_DEBUG)
/*
 * Function to print out oob buffer for debugging
 * Written by jsgood
 */
static void print_oob(const char *header, struct mtd_info *mtd)
{
	int i;
	struct nand_chip *chip = mtd->priv;

	printk("%s:\t", header);

	for(i = 0; i < 64; i++)
		printk("%02x ", chip->oob_poi[i]);

	printk("\n");
}
#endif

/*
 * Hardware specific access to control-lines function
 * Written by jsgood
 */
static void s3c_nand_hwcontrol(struct mtd_info *mtd, int dat, unsigned int ctrl)
{
	unsigned int cur;

	if (ctrl & NAND_CTRL_CHANGE) {
		if (ctrl & NAND_NCE) {
			if (dat != NAND_CMD_NONE) {
				cur = readl(NFCONT);
				/* Forced Enable CS */
				cur &= ~NFCONT_CS;

				writel(cur, NFCONT);
			}
		} else {
			cur = readl(NFCONT);
			/* Forced Enable CS */
			cur &= ~NFCONT_CS;

			writel(cur, NFCONT);
		}
	}

	if (dat != NAND_CMD_NONE) {
		if (ctrl & NAND_CLE)
			writeb(dat, NFCMMD);
		else if (ctrl & NAND_ALE)
			writeb(dat, NFADDR);
	}
}

/*
 * Function for checking device ready pin
 * Written by jsgood
 */
static int s3c_nand_device_ready(struct mtd_info *mtdinfo)
{
	while (!(readl(NFSTAT) & NFSTAT_RnB)) {}
	return 1;
}

/*
 * We don't use bad block table
 */
static int s3c_nand_scan_bbt(struct mtd_info *mtdinfo)
{
	return nand_default_bbt(mtdinfo);
}

#if defined(CFG_NAND_HWECC)

/*
 * Function for checking ECCEncDone in NFSTAT
 * Written by jsgood
 */
static void s3c_nand_wait_enc(void)
{
	while (!(readl(NFECCSTAT) & NFSTAT_ECCENCDONE)) {}
}

/*
 * Function for checking ECCDecDone in NFSTAT
 * Written by jsgood
 */
static void s3c_nand_wait_dec(void)
{
	while (!(readl(NFECCSTAT) & NFSTAT_ECCDECDONE)) {}
}

/*
 * Function for checking ECC Busy
 * Written by jsgood
 */
static void s3c_nand_wait_ecc_busy(void)
{
	while (readl(NFECCSTAT) & NFESTAT0_ECCBUSY) {}
}

/*
 * This function is called before encoding ecc codes to ready ecc engine.
 * Written by jsgood
 */
static void s3c_nand_enable_hwecc(struct mtd_info *mtd, int mode)
{
	u_long nfcont, nfconf;

	cur_ecc_mode = mode;

	nfconf = readl(NFCONF);

 	if (nand_type == S3C_NAND_TYPE_SLC)
		nfconf &= ~NFCONF_ECC_MLC;	/* SLC */
	else
		nfconf |= NFCONF_ECC_MLC;	/* MLC */

	writel(nfconf, NFCONF);

	/* Initialize & unlock */
	nfcont = readl(NFCONT);
	nfcont |= NFCONT_INITMECC;
	nfcont &= ~NFCONT_MECCLOCK;

	if (nand_type == S3C_NAND_TYPE_MLC) {
		if (mode == NAND_ECC_WRITE)
			nfcont |= NFCONT_ECC_ENC;
		else if (mode == NAND_ECC_READ)
			nfcont &= ~NFCONT_ECC_ENC;
	}

	writel(nfcont, NFCONT);
}

/*
 * This function is called immediately after encoding ecc codes.
 * This function returns encoded ecc codes.
 * Written by jsgood
 */
static int s3c_nand_calculate_ecc(struct mtd_info *mtd, const u_char *dat, u_char *ecc_code)
{
	u_long nfcont, nfmecc0, nfmecc1;

	/* Lock */
	nfcont = readl(NFCONT);
	nfcont |= NFCONT_MECCLOCK;
	writel(nfcont, NFCONT);

	if (nand_type == S3C_NAND_TYPE_SLC) {
		nfmecc0 = readl(NFMECC0);

		ecc_code[0] = nfmecc0 & 0xff;
		ecc_code[1] = (nfmecc0 >> 8) & 0xff;
		ecc_code[2] = (nfmecc0 >> 16) & 0xff;
		ecc_code[3] = (nfmecc0 >> 24) & 0xff;
	} else {
		if (cur_ecc_mode == NAND_ECC_READ)
			s3c_nand_wait_dec();
		else {
			s3c_nand_wait_enc();

			nfmecc0 = readl(NFMECC0);
			nfmecc1 = readl(NFMECC1);

			ecc_code[0] = nfmecc0 & 0xff;
			ecc_code[1] = (nfmecc0 >> 8) & 0xff;
			ecc_code[2] = (nfmecc0 >> 16) & 0xff;
			ecc_code[3] = (nfmecc0 >> 24) & 0xff;
			ecc_code[4] = nfmecc1 & 0xff;
			ecc_code[5] = (nfmecc1 >> 8) & 0xff;
			ecc_code[6] = (nfmecc1 >> 16) & 0xff;
			ecc_code[7] = (nfmecc1 >> 24) & 0xff;
		}
	}

	return 0;
}

/*
 * This function determines whether read data is good or not.
 * If SLC, must write ecc codes to controller before reading status bit.
 * If MLC, status bit is already set, so only reading is needed.
 * If status bit is good, return 0.
 * If correctable errors occured, do that.
 * If uncorrectable errors occured, return -1.
 * Written by jsgood
 */
static int s3c_nand_correct_data(struct mtd_info *mtd, u_char *dat, u_char *read_ecc, u_char *calc_ecc)
{
	int ret = -1;
	u_long nfestat0, nfestat1, nfmeccdata0, nfmeccdata1, nfmlcbitpt;
	u_char err_type;

	if (nand_type == S3C_NAND_TYPE_SLC) {
		/* SLC: Write ecc to compare */
		nfmeccdata0 = (read_ecc[1] << 16) | read_ecc[0];
		nfmeccdata1 = (read_ecc[3] << 16) | read_ecc[2];
		writel(nfmeccdata0, NFMECCDATA0);
		writel(nfmeccdata1, NFMECCDATA1);

		/* Read ecc status */
		nfestat0 = readl(NFESTAT0);
		err_type = nfestat0 & 0x3;

		switch (err_type) {
		case 0: /* No error */
			ret = 0;
			break;

		case 1: /* 1 bit error (Correctable)
			   (nfestat0 >> 7) & 0x7ff	:error byte number
			   (nfestat0 >> 4) & 0x7	:error bit number */
			printk("s3c-nand: 1 bit error detected at byte %ld, correcting from "
					"0x%02x ", (nfestat0 >> 7) & 0x7ff, dat[(nfestat0 >> 7) & 0x7ff]);
			dat[(nfestat0 >> 7) & 0x7ff] ^= (1 << ((nfestat0 >> 4) & 0x7));
			printk("to 0x%02x...OK\n", dat[(nfestat0 >> 7) & 0x7ff]);
			ret = 1;
			break;

		case 2: /* Multiple error */
		case 3: /* ECC area error */
			printk("s3c-nand: ECC uncorrectable error detected\n");
			ret = -1;
			break;
		}
	} else {
		/* MLC: */
		s3c_nand_wait_ecc_busy();

		nfestat0 = readl(NFESTAT0);
		nfestat1 = readl(NFESTAT1);
		nfmlcbitpt = readl(NFMLCBITPT);

		err_type = (nfestat0 >> 26) & 0x7;

		/* No error, If free page (all 0xff) */
		if ((nfestat0 >> 29) & 0x1) {
			err_type = 0;
		} else {
			/* No error, If all 0xff from 17th byte in oob (in case of JFFS2 format) */
			if (dat) {
				if (dat[17] == 0xff && dat[26] == 0xff && dat[35] == 0xff && dat[44] == 0xff && dat[54] == 0xff)
					err_type = 0;
			}
		}

		switch (err_type) {
		case 5: /* Uncorrectable */
			printk("s3c-nand: ECC uncorrectable error detected\n");
			ret = -1;
			break;

		case 4: /* 4 bit error (Correctable) */
			dat[(nfestat1 >> 16) & 0x3ff] ^= ((nfmlcbitpt >> 24) & 0xff);

		case 3: /* 3 bit error (Correctable) */
			dat[nfestat1 & 0x3ff] ^= ((nfmlcbitpt >> 16) & 0xff);

		case 2: /* 2 bit error (Correctable) */
			dat[(nfestat0 >> 16) & 0x3ff] ^= ((nfmlcbitpt >> 8) & 0xff);

		case 1: /* 1 bit error (Correctable) */
			printk("s3c-nand: %d bit(s) error detected, corrected successfully\n", err_type);
			dat[nfestat0 & 0x3ff] ^= (nfmlcbitpt & 0xff);
			ret = err_type;
			break;

		case 0: /* No error */
			ret = 0;
			break;
		}
	}

	return ret;
}

#if defined(CONFIG_NAND_BL1_8BIT_ECC) && defined(CONFIG_S5PC110)
/***************************************************************
 * jsgood: Temporary 8 Bit H/W ECC supports for BL1 (6410/6430 only)
 ***************************************************************/
static void s3c_nand_wait_ecc_busy_8bit(void)
{
	while (readl(NFECCSTAT) & NFESTAT0_ECCBUSY) {
	}
}

void s3c_nand_enable_hwecc_8bit(struct mtd_info *mtd, int mode)
{
	u_long nfreg;
	
	cur_ecc_mode = mode;

	if(cur_ecc_mode == NAND_ECC_WRITE){

	/* 8 bit selection */
	nfreg = readl(NFCONF);
	nfreg &= ~(0x3 << 23);
	nfreg |= (0x3<< 23);
	writel(nfreg, NFCONF);
	
	/* Set ECC type */
	nfreg = readl(NFECCCONF);
	nfreg &= 0xf;
	nfreg |= 0x3;
	writel(nfreg, NFECCCONF);

	/* set 8/12/16bit Ecc direction to Encoding */
	nfreg = readl(NFECCCONT);
	nfreg &= ~(0x1 << 16);
	nfreg |= (0x1 << 16);
	writel(nfreg, NFECCCONT);

	/* set 8/12/16bit ECC message length  to msg */
	nfreg = readl(NFECCCONF);
	nfreg &= ~((0x3ff<<16));
	nfreg |= (0x1ff << 16);
	writel(nfreg, NFECCCONF);

	/* write '1' to clear this bit. */
	/* clear illegal access status bit */
	nfreg = readl(NFSTAT);
	nfreg |= (0x1 << 4);
	nfreg |= (0x1 << 5);
	writel(nfreg, NFSTAT);

	/* clear 8/12/16bit ecc encode done */
	nfreg = readl(NFECCSTAT);
	nfreg |= (0x1 << 25);
	writel(nfreg, NFECCSTAT);

	nfreg = readl(NFCONT);
	nfreg &= ~(0x1 << 1);
	writel(nfreg, NFCONT);
	
	/* Initialize & unlock */
	nfreg = readl(NFCONT);
	nfreg &= ~NFCONT_MECCLOCK;
	nfreg |= NFCONT_INITECC;	
	writel(nfreg, NFCONT);

	/* Reset ECC value. */
	nfreg = readl(NFECCCONT);
	nfreg |= (0x1 << 2);
	writel(nfreg, NFECCCONT);
	
	}else{

	/* set 8/12/16bit ECC message length  to msg */
	nfreg = readl(NFECCCONF);
	nfreg &= ~((0x3ff<<16));
	nfreg |= (0x1ff << 16);
	writel(nfreg, NFECCCONF);
	
	/* set 8/12/16bit Ecc direction to Decoding */
	nfreg = readl(NFECCCONT);
	nfreg &= ~(0x1 << 16);
	writel(nfreg, NFECCCONT);
	
	/* write '1' to clear this bit. */
	/* clear illegal access status bit */
	nfreg = readl(NFSTAT);
	nfreg |= (0x1 << 4);
	nfreg |= (0x1 << 5);
	writel(nfreg, NFSTAT);

	/* Lock */
	nfreg = readl(NFCONT);
	nfreg |= NFCONT_MECCLOCK;
	writel(nfreg, NFCONT);

	nfreg = readl(NFCONT);
	nfreg &= ~(0x1 << 1);
	writel(nfreg, NFCONT);

	/* clear 8/12/16bit ecc decode done */
	nfreg = readl(NFECCSTAT);
	nfreg |= (0x1 << 24);
	writel(nfreg, NFECCSTAT);
	
	/* Initialize & lock */
	nfreg = readl(NFCONT);
	nfreg &= ~NFCONT_MECCLOCK;
	nfreg |= NFCONT_MECCLOCK;
	writel(nfreg, NFCONT);

	/* write '1' to clear this bit. */
	nfreg = readl(NFSTAT);
	nfreg &= ~(1<<4);
	nfreg |= (1<<4);
	writel(nfreg, NFSTAT);

	while(!(nfreg &(1<<4))){
		nfreg = readl(NFSTAT);
		}

	/* write '1' to clear this bit. */
	nfreg = readl(NFSTAT);
	nfreg &= ~(1<<4);
	nfreg |= (1<<4);
	writel(nfreg, NFSTAT);
	
	/* Initialize & unlock */
	nfreg = readl(NFCONT);
	nfreg &= ~NFCONT_MECCLOCK;
	nfreg |= NFCONT_INITECC;	
	writel(nfreg, NFCONT);

	/* Reset ECC value. */
	nfreg = readl(NFECCCONT);
	nfreg |= (0x1 << 2);
	writel(nfreg, NFECCCONT);
	}

}

int s3c_nand_calculate_ecc_8bit(struct mtd_info *mtd, const u_char *dat, u_char *ecc_code)
{
	u_long nfcont, nfeccprgecc0, nfeccprgecc1, nfeccprgecc2, nfeccprgecc3;

	if (cur_ecc_mode == NAND_ECC_READ) {
		/* Lock */
		nfcont = readl(NFCONT);
		nfcont |= NFCONT_MECCLOCK;
		writel(nfcont, NFCONT);
		
		s3c_nand_wait_dec();

		/* clear 8/12/16bit ecc decode done */
		nfcont = readl(NFECCSTAT);
		nfcont |= (1<<24);
		writel(nfcont, NFECCSTAT);

		s3c_nand_wait_ecc_busy_8bit();

		if(readl(NFSTAT)&(1<<5))
		{
			/* clear illegal access status bit */
			nfcont = readl(NFSTAT);
			nfcont |= (1<<5);
			writel(nfcont, NFSTAT);

			printf("\n Accessed locked area!! \n");
			
			nfcont = readl(NFCONT);
			nfcont |= (1<<1);
			writel(nfcont, NFCONT);
			
			return -1;
		}
		
		nfcont = readl(NFCONT);
		nfcont |= (1<<1);
		writel(nfcont, NFCONT);

		
	} else {
		/* Lock */
		nfcont = readl(NFCONT);
		nfcont |= NFCONT_MECCLOCK;
		writel(nfcont, NFCONT);
		
		s3c_nand_wait_enc();

		/* clear 8/12/16bit ecc encode done */
		nfcont = readl(NFECCSTAT);
		nfcont |= (1<<25);
		writel(nfcont, NFECCSTAT);

		nfeccprgecc0 = readl(NFECCPRGECC0);
		nfeccprgecc1 = readl(NFECCPRGECC1);
		nfeccprgecc2 = readl(NFECCPRGECC2);
		nfeccprgecc3 = readl(NFECCPRGECC3);
	
		ecc_code[0] = nfeccprgecc0 & 0xff;
		ecc_code[1] = (nfeccprgecc0 >> 8) & 0xff;
		ecc_code[2] = (nfeccprgecc0 >> 16) & 0xff;
		ecc_code[3] = (nfeccprgecc0 >> 24) & 0xff;
		ecc_code[4] = nfeccprgecc1 & 0xff;
		ecc_code[5] = (nfeccprgecc1 >> 8) & 0xff;
		ecc_code[6] = (nfeccprgecc1 >> 16) & 0xff;
		ecc_code[7] = (nfeccprgecc1 >> 24) & 0xff;
		ecc_code[8] = nfeccprgecc2 & 0xff;
		ecc_code[9] = (nfeccprgecc2 >> 8) & 0xff;
		ecc_code[10] = (nfeccprgecc2 >> 16) & 0xff;
		ecc_code[11] = (nfeccprgecc2 >> 24) & 0xff;
		ecc_code[12] = nfeccprgecc3 & 0xff;

		

	}

	return 0;
}

int s3c_nand_correct_data_8bit(struct mtd_info *mtd, u_char *dat)
{
	int ret = -1;
	u_long nf8eccerr0, nf8eccerr1, nf8eccerr2, nf8eccerr3, nf8eccerr4, nfmlc8bitpt0, nfmlc8bitpt1;
	u_char err_type;

	s3c_nand_wait_ecc_busy_8bit();

	nf8eccerr0 = readl(NFECCSECSTAT);
	nf8eccerr1 = readl(NFECCERL0);
	nf8eccerr2 = readl(NFECCERL1);
	nf8eccerr3 = readl(NFECCERL2);
	nf8eccerr4 = readl(NFECCERL3);
	nfmlc8bitpt0 = readl(NFECCERP0);
	nfmlc8bitpt1 = readl(NFECCERP1);

	err_type = (nf8eccerr0) & 0xf;

	/* No error, If free page (all 0xff) */
	if ((nf8eccerr0 >> 29) & 0x1)
		err_type = 0;

	switch (err_type) {
	case 9: /* Uncorrectable */
		printk("s3c-nand: ECC uncorrectable error detected\n");
		ret = -1;
		break;

	case 8: /* 8 bit error (Correctable) */
		dat[(nf8eccerr4 >> 16) & 0x3ff] ^= ((nfmlc8bitpt1 >> 24) & 0xff);

	case 7: /* 7 bit error (Correctable) */
		dat[(nf8eccerr4) & 0x3ff] ^= ((nfmlc8bitpt1 >> 16) & 0xff);

	case 6: /* 6 bit error (Correctable) */
		dat[(nf8eccerr3 >> 16) & 0x3ff] ^= ((nfmlc8bitpt1 >> 8) & 0xff);

	case 5: /* 5 bit error (Correctable) */
		dat[(nf8eccerr3) & 0x3ff] ^= ((nfmlc8bitpt1) & 0xff);

	case 4: /* 8 bit error (Correctable) */
		dat[(nf8eccerr2 >> 16) & 0x3ff] ^= ((nfmlc8bitpt0 >> 24) & 0xff);

	case 3: /* 7 bit error (Correctable) */
		dat[(nf8eccerr2) & 0x3ff] ^= ((nfmlc8bitpt0>> 16) & 0xff);

	case 2: /* 6 bit error (Correctable) */
		dat[(nf8eccerr1 >> 16) & 0x3ff] ^= ((nfmlc8bitpt0>> 8) & 0xff);

	case 1: /* 1 bit error (Correctable) */
		printk("s3c-nand: %d bit(s) error detected, corrected successfully\n", err_type);
		dat[(nf8eccerr1) & 0x3ff] ^= ((nfmlc8bitpt0) & 0xff);
		ret = err_type;
		break;

	case 0: /* No error */
		ret = 0;
		break;
	}

	return ret;
}

void s3c_nand_write_page_8bit(struct mtd_info *mtd, struct nand_chip *chip,
				  const uint8_t *buf)
{	
	u_long nfreg;
	int i, eccsize = 512;
	int eccbytes = 13;
	int eccsteps = mtd->writesize / eccsize;
	int badoffs = mtd->writesize == 512 ? NAND_SMALL_BADBLOCK_POS : NAND_LARGE_BADBLOCK_POS;

	uint8_t *ecc_calc = chip->buffers->ecccalc;
	uint8_t *p = buf;
	
	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
		s3c_nand_enable_hwecc_8bit(mtd, NAND_ECC_WRITE);
		chip->write_buf(mtd, p, eccsize);
		s3c_nand_calculate_ecc_8bit(mtd, p, &ecc_calc[i]);
	}

	chip->oob_poi[badoffs] = 0xff;
	for (i = 0; i <= eccbytes * (mtd->writesize / eccsize); i++) {
#if defined(CONFIG_EVT1)
		chip->oob_poi[i+12] = ecc_calc[i];
#else
		chip->oob_poi[i] = ecc_calc[i];
#endif
	}

	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
}

int s3c_nand_read_page_8bit(struct mtd_info *mtd, struct nand_chip *chip,
				uint8_t *buf)
{
	u_long nfreg;
	int i, stat, eccsize = 512;
	int eccbytes = 13;
	int eccsteps = mtd->writesize / eccsize;
	int col = 0;
	uint8_t *p = buf;
	
	/* Step1: read whole oob */
	col = mtd->writesize;
#if defined(CONFIG_EVT1)
	chip->cmdfunc(mtd, NAND_CMD_RNDOUT, col+12, -1);
#else
	chip->cmdfunc(mtd, NAND_CMD_RNDOUT, col, -1);
#endif
	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);

	col = 0;

	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {

		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, col, -1);
		s3c_nand_enable_hwecc_8bit(mtd, NAND_ECC_READ);
		chip->read_buf(mtd, p, eccsize);
		chip->write_buf(mtd, chip->oob_poi + (((mtd->writesize / eccsize) - eccsteps) * eccbytes), eccbytes);
		s3c_nand_calculate_ecc_8bit(mtd, 0, 0);
		stat = s3c_nand_correct_data_8bit(mtd, p);

		if (stat == -1)
			mtd->ecc_stats.failed++;

		col = eccsize * ((mtd->writesize / eccsize) + 1 - eccsteps);
	}

	return 0;
}

int s3c_nand_read_oob_8bit(struct mtd_info *mtd, struct nand_chip *chip, int page, int sndcmd)
{
        int eccbytes = chip->ecc.bytes;
        int secc_start = mtd->oobsize - eccbytes;

        if (sndcmd) {
                chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, page);
                sndcmd = 0;
        }

        chip->read_buf(mtd, chip->oob_poi, 0); //secc_start);
        return sndcmd;
}

int s3c_nand_write_oob_8bit(struct mtd_info *mtd, struct nand_chip *chip, int page)
{
        int status = 0;
        int eccbytes = chip->ecc.bytes;
        int secc_start = mtd->oobsize - eccbytes;

        chip->cmdfunc(mtd, NAND_CMD_SEQIN, mtd->writesize, page);

        /* spare area */
        chip->write_buf(mtd, chip->oob_poi, 0); //secc_start);

        /* Send command to program the OOB data */
        chip->cmdfunc(mtd, NAND_CMD_PAGEPROG, -1, -1);
        status = chip->waitfunc(mtd, chip);
        return status & NAND_STATUS_FAIL ? -EIO : 0;
}

/********************************************************/
#endif

static int s3c_nand_write_oob_1bit(struct mtd_info *mtd, struct nand_chip *chip,
			      int page)
{
	uint8_t *ecc_calc = chip->buffers->ecccalc;
	int status = 0;
	int eccbytes = chip->ecc.bytes;
	int secc_start = mtd->oobsize - eccbytes;
	int i;

	chip->cmdfunc(mtd, NAND_CMD_SEQIN, mtd->writesize, page);

	/* spare area */
	chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
	chip->write_buf(mtd, chip->oob_poi, secc_start);
	chip->ecc.calculate(mtd, 0, &ecc_calc[chip->ecc.total]);

	for (i = 0; i < eccbytes; i++)
		chip->oob_poi[secc_start + i] = ecc_calc[chip->ecc.total + i];

	chip->write_buf(mtd, chip->oob_poi + secc_start, eccbytes);

	/* Send command to program the OOB data */
	chip->cmdfunc(mtd, NAND_CMD_PAGEPROG, -1, -1);

	status = chip->waitfunc(mtd, chip);

	return status & NAND_STATUS_FAIL ? -EIO : 0;
}

static int s3c_nand_read_oob_1bit(struct mtd_info *mtd, struct nand_chip *chip,
			     int page, int sndcmd)
{
	uint8_t *ecc_calc = chip->buffers->ecccalc;
	int eccbytes = chip->ecc.bytes;
	int secc_start = mtd->oobsize - eccbytes;

	if (sndcmd) {
		chip->cmdfunc(mtd, NAND_CMD_READOOB, 0, page);
		sndcmd = 0;
	}

	chip->ecc.hwctl(mtd, NAND_ECC_READ);
	chip->read_buf(mtd, chip->oob_poi, secc_start);
	chip->ecc.calculate(mtd, 0, &ecc_calc[chip->ecc.total]);
	chip->read_buf(mtd, chip->oob_poi + secc_start, eccbytes);

	/* jffs2 special case */
	if (!(chip->oob_poi[2] == 0x85 && chip->oob_poi[3] == 0x19))
		chip->ecc.correct(mtd, chip->oob_poi, chip->oob_poi + secc_start, 0);

	return sndcmd;
}

static void s3c_nand_write_page_1bit(struct mtd_info *mtd, struct nand_chip *chip,
				  const uint8_t *buf)
{
	int i, eccsize = chip->ecc.size;
	int eccbytes = chip->ecc.bytes;
	int eccsteps = chip->ecc.steps;
	int secc_start = mtd->oobsize - eccbytes;
	uint8_t *ecc_calc = chip->buffers->ecccalc;
	const uint8_t *p = buf;

	uint32_t *eccpos = chip->ecc.layout->eccpos;

	/* main area */
	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
		chip->write_buf(mtd, p, eccsize);
		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
	}

	for (i = 0; i < chip->ecc.total; i++)
		chip->oob_poi[eccpos[i]] = ecc_calc[i];

	/* spare area */
	chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
	chip->write_buf(mtd, chip->oob_poi, secc_start);
	chip->ecc.calculate(mtd, p, &ecc_calc[chip->ecc.total]);

	for (i = 0; i < eccbytes; i++)
		chip->oob_poi[secc_start + i] = ecc_calc[chip->ecc.total + i];

	chip->write_buf(mtd, chip->oob_poi + secc_start, eccbytes);
}

static int s3c_nand_read_page_1bit(struct mtd_info *mtd, struct nand_chip *chip,
				uint8_t *buf)
{
	int i, stat, eccsize = chip->ecc.size;
	int eccbytes = chip->ecc.bytes;
	int eccsteps = chip->ecc.steps;
	int secc_start = mtd->oobsize - eccbytes;
	int col = 0;
	uint8_t *p = buf;
	uint32_t *mecc_pos = chip->ecc.layout->eccpos;
	uint8_t *ecc_calc = chip->buffers->ecccalc;

	col = mtd->writesize;
	chip->cmdfunc(mtd, NAND_CMD_RNDOUT, col, -1);

	/* spare area */
	chip->ecc.hwctl(mtd, NAND_ECC_READ);
	chip->read_buf(mtd, chip->oob_poi, secc_start);
	chip->ecc.calculate(mtd, p, &ecc_calc[chip->ecc.total]);
	chip->read_buf(mtd, chip->oob_poi + secc_start, eccbytes);

	/* jffs2 special case */
	if (!(chip->oob_poi[2] == 0x85 && chip->oob_poi[3] == 0x19))
		chip->ecc.correct(mtd, chip->oob_poi, chip->oob_poi + secc_start, 0);

	col = 0;

	/* main area */
	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, col, -1);
		chip->ecc.hwctl(mtd, NAND_ECC_READ);
		chip->read_buf(mtd, p, eccsize);
		chip->ecc.calculate(mtd, p, &ecc_calc[i]);

		stat = chip->ecc.correct(mtd, p, chip->oob_poi + mecc_pos[0] + ((chip->ecc.steps - eccsteps) * eccbytes), 0);
		if (stat == -1)
			mtd->ecc_stats.failed++;

		col = eccsize * (chip->ecc.steps + 1 - eccsteps);
	}

	return 0;
}

/*
 * Hardware specific page read function for MLC.
 * Written by jsgood
 */
static int s3c_nand_read_page_4bit(struct mtd_info *mtd, struct nand_chip *chip,
				uint8_t *buf)
{
	int i, stat, eccsize = chip->ecc.size;
	int eccbytes = chip->ecc.bytes;
	int eccsteps = chip->ecc.steps;
	int col = 0;
	uint8_t *p = buf;
	uint32_t *mecc_pos = chip->ecc.layout->eccpos;

	/* Step1: read whole oob */
	col = mtd->writesize;
	chip->cmdfunc(mtd, NAND_CMD_RNDOUT, col, -1);
	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);

	col = 0;
	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, col, -1);
		chip->ecc.hwctl(mtd, NAND_ECC_READ);
		chip->read_buf(mtd, p, eccsize);
		chip->write_buf(mtd, chip->oob_poi + mecc_pos[0] + ((chip->ecc.steps - eccsteps) * eccbytes), eccbytes);
		chip->ecc.calculate(mtd, 0, 0);
		stat = chip->ecc.correct(mtd, p, 0, 0);

		if (stat == -1)
			mtd->ecc_stats.failed++;

		col = eccsize * (chip->ecc.steps + 1 - eccsteps);
	}

	return 0;
}

/*
 * Hardware specific page write function for MLC.
 * Written by jsgood
 */
static void s3c_nand_write_page_4bit(struct mtd_info *mtd, struct nand_chip *chip,
				  const uint8_t *buf)
{
	int i, eccsize = chip->ecc.size;
	int eccbytes = chip->ecc.bytes;
	int eccsteps = chip->ecc.steps;
	const uint8_t *p = buf;
	uint8_t *ecc_calc = chip->buffers->ecccalc;
	uint32_t *mecc_pos = chip->ecc.layout->eccpos;

	/* Step1: write main data and encode mecc */
	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
		chip->write_buf(mtd, p, eccsize);
		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
	}

	/* Step2: save encoded mecc */
	for (i = 0; i < chip->ecc.total; i++)
		chip->oob_poi[mecc_pos[i]] = ecc_calc[i];

	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
}
#endif

/*
 * Board-specific NAND initialization. The following members of the
 * argument are board-specific (per include/linux/mtd/nand.h):
 * - IO_ADDR_R?: address to read the 8 I/O lines of the flash device
 * - IO_ADDR_W?: address to write the 8 I/O lines of the flash device
 * - hwcontrol: hardwarespecific function for accesing control-lines
 * - dev_ready: hardwarespecific function for  accesing device ready/busy line
 * - enable_hwecc?: function to enable (reset)  hardware ecc generator. Must
 *   only be provided if a hardware ECC is available
 * - eccmode: mode of ecc, see defines
 * - chip_delay: chip dependent delay for transfering data from array to
 *   read regs (tR)
 * - options: various chip options. They can partly be set to inform
 *   nand_scan about special functionality. See the defines for further
 *   explanation
 * Members with a "?" were not set in the merged testing-NAND branch,
 * so they are not set here either.
 */
int board_nand_init(struct nand_chip *nand)
{
#if defined(CFG_NAND_HWECC)
	int i;
	u_char tmp;
	struct nand_flash_dev *type = NULL;
#endif

	NFCONT_REG 		&= ~NFCONT_WP;
	nand->IO_ADDR_R		= (void __iomem *)(NFDATA);
	nand->IO_ADDR_W		= (void __iomem *)(NFDATA);
	nand->cmd_ctrl		= s3c_nand_hwcontrol;
	nand->dev_ready		= s3c_nand_device_ready;
	nand->scan_bbt		= s3c_nand_scan_bbt;
	nand->options		= 0;

#if defined(CFG_NAND_FLASH_BBT)
		nand->options 		|= NAND_USE_FLASH_BBT;
#else
		nand->options		|= NAND_SKIP_BBTSCAN;
#endif

#if defined(CFG_NAND_HWECC)
	nand->ecc.mode		= NAND_ECC_HW;
	nand->ecc.hwctl		= s3c_nand_enable_hwecc;
	nand->ecc.calculate	= s3c_nand_calculate_ecc;
	nand->ecc.correct	= s3c_nand_correct_data;

	s3c_nand_hwcontrol(0, NAND_CMD_READID, NAND_NCE | NAND_CLE | NAND_CTRL_CHANGE);
	s3c_nand_hwcontrol(0, 0x00, NAND_CTRL_CHANGE | NAND_NCE | NAND_ALE);
	s3c_nand_hwcontrol(0, 0x00, NAND_NCE | NAND_ALE);
	s3c_nand_hwcontrol(0, NAND_CMD_NONE, NAND_NCE | NAND_CTRL_CHANGE);
	s3c_nand_device_ready(0);

	tmp = readb(nand->IO_ADDR_R); /* Maf. ID */
	tmp = readb(nand->IO_ADDR_R); /* Device ID */

	for (i = 0; nand_flash_ids[i].name != NULL; i++) {
		if (tmp == nand_flash_ids[i].id) {
			type = &nand_flash_ids[i];
			break;
		}
	}

	if (type == NULL)
		return -1;

	nand->cellinfo = readb(nand->IO_ADDR_R);	/* 3rd byte */
	tmp = readb(nand->IO_ADDR_R);			/* 4th byte */

	if (!type->pagesize) {
		if (((nand->cellinfo >> 2) & 0x3) == 0) {
			nand_type = S3C_NAND_TYPE_SLC;
			nand->ecc.size = 512;
			nand->ecc.bytes	= 4;

			if ((1024 << (tmp & 0x3)) > 512) {
				nand->ecc.read_page = s3c_nand_read_page_1bit;
				nand->ecc.write_page = s3c_nand_write_page_1bit;
				nand->ecc.read_oob = s3c_nand_read_oob_1bit;
				nand->ecc.write_oob = s3c_nand_write_oob_1bit;
				nand->ecc.layout = &s3c_nand_oob_64;
				nand->ecc.hwctl = s3c_nand_enable_hwecc;
                                nand->ecc.calculate = s3c_nand_calculate_ecc;
                                nand->ecc.correct = s3c_nand_correct_data;
                                nand->options |= NAND_NO_SUBPAGE_WRITE;
			} else {
				nand->ecc.layout = &s3c_nand_oob_16;
			}
		} else {
			nand_type = S3C_NAND_TYPE_MLC;
			nand->options |= NAND_NO_SUBPAGE_WRITE;	/* NOP = 1 if MLC */
			nand->ecc.read_page = s3c_nand_read_page_4bit;
			nand->ecc.write_page = s3c_nand_write_page_4bit;
			nand->ecc.size = 512;
			nand->ecc.bytes = 8;	/* really 7 bytes */
			nand->ecc.layout = &s3c_nand_oob_mlc_64;
		}
	} else {
		nand_type = S3C_NAND_TYPE_SLC;
		nand->ecc.size = 512;
		nand->cellinfo = 0;
		nand->ecc.bytes = 4;
		nand->ecc.layout = &s3c_nand_oob_16;
	}
#else
	nand->ecc.mode = NAND_ECC_SOFT;
#endif
	return 0;
}
#endif /* (CONFIG_CMD_NAND) */
