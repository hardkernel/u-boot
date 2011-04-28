/*
 * drivers/mtd/nand/nand_util.c
 *
 * Copyright (C) 2006 by Weiss-Electronic GmbH.
 * All rights reserved.
 *
 * @author:	Guido Classen <clagix@gmail.com>
 * @descr:	NAND Flash support
 * @references: borrowed heavily from Linux mtd-utils code:
 *		flash_eraseall.c by Arcom Control System Ltd
 *		nandwrite.c by Steven J. Hill (sjhill@realitydiluted.com)
 *			       and Thomas Gleixner (tglx@linutronix.de)
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License version
 * 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 *
 */

#include <common.h>
#include <command.h>
#include <watchdog.h>
#include <malloc.h>
#include <div64.h>

#include <asm/errno.h>
#include <linux/err.h>
#include <linux/mtd/mtd.h>
#include <nand.h>
#include <jffs2/jffs2.h>

typedef struct erase_info erase_info_t;
typedef struct mtd_info	  mtd_info_t;

#define OOB_WITH_RAW		2
/* Spare structure for YAFFS1 */
typedef struct {
	__u8 tagByte0;
	__u8 tagByte1;
	__u8 tagByte2;
	__u8 tagByte3;
	__u8 pageStatus;	/* set to 0 to delete the chunk */
	__u8 blockStatus;
	__u8 tagByte4;
	__u8 tagByte5;
	__u8 ecc1[3];
	__u8 tagByte6;
	__u8 tagByte7;
	__u8 ecc2[3];
} yaffs_Spare;

/*Special structure for passing through to mtd */
struct yaffs_NANDSpare {
	yaffs_Spare spare;
	int eccres1;
	int eccres2;
};

/* support only for native endian JFFS2 */
#define cpu_to_je16(x) (x)
#define cpu_to_je32(x) (x)

/*****************************************************************************/
static int nand_block_bad_scrub(struct mtd_info *mtd, loff_t ofs, int getchip)
{
	return 0;
}

/*
*nand_block_bad_scrub_update_bbt: this function is in order to protect the factory bad blocks
*					change the bbt but reserve factory bad blocks
*/
static int nand_block_bad_scrub_update_bbt(struct mtd_info *meminfo)
{	
	//struct nand_chip *chip = mtd->priv;
	struct nand_chip *priv_nand = meminfo->priv;
	int ret;
	ret = priv_nand->nand_block_bad_scrub_update_bbt(meminfo); 
	
	return ret;
}


static inline void translate_oob2spare(yaffs_Spare *spare, __u8 *oob)
{
	struct yaffs_NANDSpare *nspare = (struct yaffs_NANDSpare *)spare;
	spare->tagByte0 = oob[0];
	spare->tagByte1 = oob[1];
	spare->tagByte2 = oob[2];
	spare->tagByte3 = oob[3];
	spare->tagByte4 = oob[4];
	spare->tagByte5 = oob[5] == 0xff ? 0xff : oob[5] & 0x3f;
	spare->blockStatus = oob[5] & 0x80 ? 0xff : 'Y';
	spare->pageStatus = oob[5] & 0x40 ? 0xff : 0;
	spare->ecc1[0] = spare->ecc1[1] = spare->ecc1[2] = 0xff;
	spare->tagByte6 = oob[6];
	spare->tagByte7 = oob[7];
	spare->ecc2[0] = spare->ecc2[1] = spare->ecc2[2] = 0xff;

	nspare->eccres1 = nspare->eccres2 = 0; /* FIXME */
}

static inline void translate_spare2oob(const yaffs_Spare *spare, __u8 *oob)
{
	oob[0] = spare->tagByte0;
	oob[1] = spare->tagByte1;
	oob[2] = spare->tagByte2;
	oob[3] = spare->tagByte3;
	oob[4] = spare->tagByte4;
	oob[5] = spare->tagByte5 & 0x3f;
	oob[5] |= spare->blockStatus == 'Y' ? 0: 0x80;
	oob[5] |= spare->pageStatus == 0 ? 0: 0x40;
	oob[6] = spare->tagByte6;
	oob[7] = spare->tagByte7;
}
/**
 * nand_erase_opts: - erase NAND flash with support for various options
 *		      (jffs2 formating)
 *
 * @param meminfo	NAND device to erase
 * @param opts		options,  @see struct nand_erase_options
 * @return		0 in case of success
 *
 * This code is ported from flash_eraseall.c from Linux mtd utils by
 * Arcom Control System Ltd.
 */
int nand_erase_opts(nand_info_t *meminfo, const nand_erase_options_t *opts)
{
	struct jffs2_unknown_node cleanmarker;
	erase_info_t erase;
	loff_t erase_length;
	
	int bbtest = 1;
	int result;
	int percent_complete = -1;
	int (*nand_block_bad_old)(struct mtd_info *, loff_t, int) = NULL;
	const char *mtd_device = meminfo->name;
	struct mtd_oob_ops oob_opts;
	struct nand_chip *chip = meminfo->priv;

    //printf("%s\n", __func__);
	memset(&erase, 0, sizeof(erase));
	memset(&oob_opts, 0, sizeof(oob_opts));

	erase.mtd = meminfo;
	erase.len  = meminfo->erasesize;
	erase.addr = opts->offset;
	erase_length = opts->length;

	cleanmarker.magic = cpu_to_je16 (JFFS2_MAGIC_BITMASK);
	cleanmarker.nodetype = cpu_to_je16 (JFFS2_NODETYPE_CLEANMARKER);
	cleanmarker.totlen = cpu_to_je32(8);

	/* scrub option allows to erase badblock. To prevent internal
	 * check from erase() method, set block check method to dummy
	 * and disable bad block table while erasing.
	 */
	if (opts->scrub == 1) {
		struct nand_chip *priv_nand = meminfo->priv;

		nand_block_bad_old = priv_nand->block_bad;
		priv_nand->block_bad = nand_block_bad_scrub;
		/* we don't need the bad block table anymore...
		 * after scrub, there are no bad blocks left!
		 */
		if (priv_nand->bbt) {
			kfree(priv_nand->bbt);
		}
		priv_nand->bbt = NULL;
	}
	else if (opts->scrub == 2) {
		nand_block_bad_scrub_update_bbt(meminfo);
	}

	if (erase_length < meminfo->erasesize) {
		printf("Warning: Erase size 0x%09qx smaller than one "	\
		       "erase block 0x%08x\n",erase_length, meminfo->erasesize);
		printf("         Erasing 0x%08x instead\n", meminfo->erasesize);
		erase_length = meminfo->erasesize;
	}
    for (;
	     erase.addr < opts->offset + erase_length;
	     erase.addr += meminfo->erasesize) {
        
	
		WATCHDOG_RESET ();

		if (((!opts->scrub)||(opts->scrub == 2))&& bbtest) {
			int ret = meminfo->block_isbad(meminfo, erase.addr);
			if (ret > 0) {
				if (!opts->quiet)
					printf("\rSkipping bad block at  "
					       "0x%08llx                 "
					       "                         \n",
					       erase.addr);
				continue;

			} else if (ret < 0) {
				printf("\n%s: MTD get bad block failed: %d %llx\n",
				       mtd_device,
				       ret, erase.addr);
				return -1;
			}
		}

		result = meminfo->erase(meminfo, &erase);
		if (result != 0) {
			printf("\n%s: MTD Erase failure: %d %llx\n", mtd_device, result,erase.addr);
			result = meminfo->block_markbad(meminfo, erase.addr);
			if (result)
				printf("bad block mark faile: %llx\n", erase.addr);
			continue;
		}

		/* format for JFFS2 ? */
		if (opts->jffs2 && chip->ecc.layout->oobavail >= 8) {
			chip->ops.ooblen = 8;
			chip->ops.datbuf = NULL;
			chip->ops.oobbuf = (uint8_t *)&cleanmarker;
			chip->ops.ooboffs = 0;
			chip->ops.mode = MTD_OOB_AUTO;

			result = meminfo->write_oob(meminfo,
			                            erase.addr,
			                            &chip->ops);
			if (result != 0) {
				printf("\n%s: MTD writeoob failure: %d\n",
				       mtd_device, result);
				continue;
			}
		}

		if (!opts->quiet) {
			unsigned long long n =(unsigned long long)
				(erase.addr + meminfo->erasesize - opts->offset)
				* 100;
			int percent=0;
            n/=erase_length;
//			do_div(n, erase_length);
			percent = (int)n;

			/* output progress message only at whole percent
			 * steps to reduce the number of messages printed
			 * on (slow) serial consoles
			 */
			 
			if (percent != percent_complete) {
				percent_complete = percent;

			    printf("\rErasing at 0x%llx -- %3d%% complete.",
				       erase.addr, percent);
	
				if (opts->jffs2 && result == 0)
					printf(" Cleanmarker written at 0x%llx.",
					       erase.addr);
			}
		}
	}
	if (!opts->quiet)
		printf("\n");

	if (nand_block_bad_old) {
		struct nand_chip *priv_nand = meminfo->priv;

		priv_nand->block_bad = nand_block_bad_old;
		priv_nand->scan_bbt(meminfo);
	}

	return 0;
}

/* XXX U-BOOT XXX */
#if 0

#define MAX_PAGE_SIZE	2048
#define MAX_OOB_SIZE	64

/*
 * buffer array used for writing data
 */
static unsigned char data_buf[MAX_PAGE_SIZE];
static unsigned char oob_buf[MAX_OOB_SIZE];

/* OOB layouts to pass into the kernel as default */
static struct nand_ecclayout none_ecclayout = {
	.useecc = MTD_NANDECC_OFF,
};

static struct nand_ecclayout jffs2_ecclayout = {
	.useecc = MTD_NANDECC_PLACE,
	.eccbytes = 6,
	.eccpos = { 0, 1, 2, 3, 6, 7 }
};

static struct nand_ecclayout yaffs_ecclayout = {
	.useecc = MTD_NANDECC_PLACE,
	.eccbytes = 6,
	.eccpos = { 8, 9, 10, 13, 14, 15}
};

static struct nand_ecclayout autoplace_ecclayout = {
	.useecc = MTD_NANDECC_AUTOPLACE
};
#endif

/* XXX U-BOOT XXX */
#ifdef CONFIG_CMD_NAND_LOCK_UNLOCK

/******************************************************************************
 * Support for locking / unlocking operations of some NAND devices
 *****************************************************************************/

#define NAND_CMD_LOCK		0x2a
#define NAND_CMD_LOCK_TIGHT	0x2c
#define NAND_CMD_UNLOCK1	0x23
#define NAND_CMD_UNLOCK2	0x24
#define NAND_CMD_LOCK_STATUS	0x7a

/**
 * nand_lock: Set all pages of NAND flash chip to the LOCK or LOCK-TIGHT
 *	      state
 *
 * @param mtd		nand mtd instance
 * @param tight		bring device in lock tight mode
 *
 * @return		0 on success, -1 in case of error
 *
 * The lock / lock-tight command only applies to the whole chip. To get some
 * parts of the chip lock and others unlocked use the following sequence:
 *
 * - Lock all pages of the chip using nand_lock(mtd, 0) (or the lockpre pin)
 * - Call nand_unlock() once for each consecutive area to be unlocked
 * - If desired: Bring the chip to the lock-tight state using nand_lock(mtd, 1)
 *
 *   If the device is in lock-tight state software can't change the
 *   current active lock/unlock state of all pages. nand_lock() / nand_unlock()
 *   calls will fail. It is only posible to leave lock-tight state by
 *   an hardware signal (low pulse on _WP pin) or by power down.
 */
int nand_lock(struct mtd_info *mtd, int tight)
{
	int ret = 0;
	int status;
	struct nand_chip *chip = mtd->priv;

	/* select the NAND device */
	chip->select_chip(mtd, 0);

	chip->cmdfunc(mtd,
		      (tight ? NAND_CMD_LOCK_TIGHT : NAND_CMD_LOCK),
		      -1, -1);

	/* call wait ready function */
	status = chip->waitfunc(mtd, chip);

	/* see if device thinks it succeeded */
	if (status & 0x01) {
		ret = -1;
	}

	/* de-select the NAND device */
	chip->select_chip(mtd, -1);
	return ret;
}

/**
 * nand_get_lock_status: - query current lock state from one page of NAND
 *			   flash
 *
 * @param mtd		nand mtd instance
 * @param offset	page address to query (muss be page aligned!)
 *
 * @return		-1 in case of error
 *			>0 lock status:
 *			  bitfield with the following combinations:
 *			  NAND_LOCK_STATUS_TIGHT: page in tight state
 *			  NAND_LOCK_STATUS_LOCK:  page locked
 *			  NAND_LOCK_STATUS_UNLOCK: page unlocked
 *
 */
int nand_get_lock_status(struct mtd_info *mtd, loff_t offset)
{
	int ret = 0;
	int chipnr;
	int page;
	struct nand_chip *chip = mtd->priv;

	/* select the NAND device */
	chipnr = (int)(offset >> chip->chip_shift);
	chip->select_chip(mtd, chipnr);


	if ((offset & (mtd->writesize - 1)) != 0) {
		printf ("nand_get_lock_status: "
			"Start address must be beginning of "
			"nand page!\n");
		ret = -1;
		goto out;
	}

	/* check the Lock Status */
	page = (int)(offset >> chip->page_shift);
	chip->cmdfunc(mtd, NAND_CMD_LOCK_STATUS, -1, page & chip->pagemask);

	ret = chip->read_byte(mtd) & (NAND_LOCK_STATUS_TIGHT
					  | NAND_LOCK_STATUS_LOCK
					  | NAND_LOCK_STATUS_UNLOCK);

 out:
	/* de-select the NAND device */
	chip->select_chip(mtd, -1);
	return ret;
}

/**
 * nand_unlock: - Unlock area of NAND pages
 *		  only one consecutive area can be unlocked at one time!
 *
 * @param mtd		nand mtd instance
 * @param start		start byte address
 * @param length	number of bytes to unlock (must be a multiple of
 *			page size nand->writesize)
 *
 * @return		0 on success, -1 in case of error
 */
int nand_unlock(struct mtd_info *mtd, ulong start, ulong length)
{
	int ret = 0;
	int chipnr;
	int status;
	int page;
	struct nand_chip *chip = mtd->priv;
	printf ("nand_unlock: start: %08x, length: %d!\n",
		(int)start, (int)length);

	/* select the NAND device */
	chipnr = (int)(start >> chip->chip_shift);
	chip->select_chip(mtd, chipnr);

	/* check the WP bit */
	chip->cmdfunc(mtd, NAND_CMD_STATUS, -1, -1);
	if (!(chip->read_byte(mtd) & NAND_STATUS_WP)) {
		printf ("nand_unlock: Device is write protected!\n");
		ret = -1;
		goto out;
	}

	if ((start & (mtd->erasesize - 1)) != 0) {
		printf ("nand_unlock: Start address must be beginning of "
			"nand block!\n");
		ret = -1;
		goto out;
	}

	if (length == 0 || (length & (mtd->erasesize - 1)) != 0) {
		printf ("nand_unlock: Length must be a multiple of nand block "
			"size %08x!\n", mtd->erasesize);
		ret = -1;
		goto out;
	}

	/*
	 * Set length so that the last address is set to the
	 * starting address of the last block
	 */
	length -= mtd->erasesize;

	/* submit address of first page to unlock */
	page = (int)(start >> chip->page_shift);
	chip->cmdfunc(mtd, NAND_CMD_UNLOCK1, -1, page & chip->pagemask);

	/* submit ADDRESS of LAST page to unlock */
	page += (int)(length >> chip->page_shift);
	chip->cmdfunc(mtd, NAND_CMD_UNLOCK2, -1, page & chip->pagemask);

	/* call wait ready function */
	status = chip->waitfunc(mtd, chip);
	/* see if device thinks it succeeded */
	if (status & 0x01) {
		/* there was an error */
		ret = -1;
		goto out;
	}

 out:
	/* de-select the NAND device */
	chip->select_chip(mtd, -1);
	return ret;
}
#endif

/**
 * get_len_incl_bad
 *
 * Check if length including bad blocks fits into device.
 *
 * @param nand NAND device
 * @param offset offset in flash
 * @param length image length
 * @return image length including bad blocks
 */
static size_t get_len_incl_bad (nand_info_t *nand, loff_t offset,
				 size_t *length)
{
	size_t len_incl_bad = 0;
	size_t len_excl_bad = 0;
	unsigned block_len;

	while (len_excl_bad < *length) {
		block_len = nand->erasesize - ((unsigned)offset & (nand->erasesize - 1));

		if (!nand_block_isbad (nand, offset & ~((loff_t)nand->erasesize - 1)))
		{
			len_excl_bad += block_len;
		}
		else {
			 
			*length -= block_len;
		}
		len_incl_bad += block_len;
		offset       += block_len;

		if (offset >= nand->size)
			break;
	}

	return len_incl_bad;
}

/**
 * nand_write_skip_bad:
 *
 * Write image to NAND flash.
 * Blocks that are marked bad are skipped and the is written to the next
 * block instead as long as the image is short enough to fit even after
 * skipping the bad blocks.
 *
 * @param nand  	NAND device
 * @param offset	offset in flash
 * @param length	buffer length
 * @param buf           buffer to read from
 * @return		0 in case of success
 */
int nand_write_skip_bad(nand_info_t *nand, loff_t offset, loff_t *length,
			u_char *buffer, unsigned write_with_oob)
{
	int rval;
	size_t left_to_write = *length;
	size_t len_incl_bad;
	u_char *p_buffer = buffer;
	struct mtd_oob_ops oob_opts;
	__u8 spareAsBytes[8];

    //printf("%s offset:%llx\n", __func__, offset);
	/* Reject writes, which are not page aligned */
	if (write_with_oob) {
		if ((offset & (nand->writesize - 1)) != 0 ||
	    	(*length % (nand->writesize+nand->oobsize)) != 0) {
			printf ("Attempt to write non page aligned data\n");
			return -EINVAL;
		}
	}
	else {
		if ((offset & (nand->writesize - 1)) != 0 ||
	    	(*length & (nand->writesize - 1)) != 0) {
			printf ("Attempt to write non page aligned data\n");
			return -EINVAL;
		}
	}

	len_incl_bad = get_len_incl_bad (nand, offset, length);

	if ((offset + len_incl_bad) > nand->size) {
		printf ("Attempt to write outside the flash area\n");
		return -EINVAL;
	}

	if (len_incl_bad == *length) {
		rval = nand_write (nand, offset, (size_t *)length, buffer);
		if (rval != 0)
			printf ("NAND write to offset %llx failed %d\n",
				offset, rval);

		return rval;
	}

	while (left_to_write > 0) {
		unsigned block_offset = (unsigned)offset & (nand->erasesize - 1);
		size_t write_size;

		WATCHDOG_RESET ();

		if (offset > nand->size)
			return -EINVAL;

		if ((offset % nand->erasesize) == 0) {
			if (nand_block_isbad (nand, offset & ~((loff_t)nand->erasesize - 1))) {
				printf ("Skip bad block 0x%08llx\n", offset & ~((loff_t)nand->erasesize - 1));
				offset += nand->erasesize - block_offset;
				continue;
			}
		}

		if (write_with_oob)
			write_size = nand->writesize;
		else {
			if (left_to_write < (nand->erasesize - block_offset))
				write_size = left_to_write;
			else
				write_size = nand->erasesize - block_offset;
		}

		if (write_with_oob) {

			if (write_with_oob == OOB_WITH_RAW) {
				memset(&oob_opts, 0, sizeof(oob_opts));
				oob_opts.mode = MTD_OOB_RAW;
				oob_opts.ooboffs = 0;
				oob_opts.datbuf = p_buffer;
				oob_opts.oobbuf = p_buffer + nand->writesize;
				oob_opts.len = nand->writesize;
				oob_opts.ooblen = nand->oobsize;
			}
			else {
				memset(&oob_opts, 0, sizeof(oob_opts));
				oob_opts.mode = MTD_OOB_AUTO;
				oob_opts.ooboffs = 0;
				oob_opts.datbuf = p_buffer;
				translate_spare2oob((yaffs_Spare *)(p_buffer+write_size), spareAsBytes);
				oob_opts.oobbuf = spareAsBytes;
				oob_opts.len = nand->writesize;
				oob_opts.ooblen = 8;
			}

			rval = nand->write_oob (nand, offset, &oob_opts);
			if (rval != 0) {
				printf ("NAND write spare to offset %zx failed %d\n",
					(size_t)offset, rval);
				*length -= left_to_write;
				return rval;
			}
		}
		else {
			rval = nand_write (nand, offset, (size_t *)&write_size, p_buffer);
			if (rval != 0) {
				printf ("NAND write to offset %zx failed %d\n",
					(size_t)offset, rval);
				*length -= left_to_write;
				return rval;
			}
		}

		if (write_with_oob) {
			left_to_write -= (write_size + nand->oobsize);
			offset        += write_size;
			p_buffer      += (write_size + nand->oobsize);
		}
		else {
			left_to_write -= write_size;
			offset        += write_size;
			p_buffer      += write_size;
		}
	}

	return 0;
}

/**
 * nand_read_skip_bad:
 *
 * Read image from NAND flash.
 * Blocks that are marked bad are skipped and the next block is readen
 * instead as long as the image is short enough to fit even after skipping the
 * bad blocks.
 *
 * @param nand NAND device
 * @param offset offset in flash
 * @param length buffer length, on return holds remaining bytes to read
 * @param buffer buffer to write to
 * @return 0 in case of success
 */
int nand_read_skip_bad(nand_info_t *nand, loff_t offset, loff_t *length,
		       u_char *buffer, unsigned read_with_oob)
{
	int rval;
	size_t left_to_read = *length;
	size_t len_incl_bad;
	u_char *p_buffer = buffer;
	struct mtd_oob_ops oob_opts;
	__u8 spareAsBytes[nand->oobsize];

	len_incl_bad = get_len_incl_bad (nand, offset, length);
	if ((offset + len_incl_bad) > nand->size) {
		printf ("Attempt to read outside the flash area\n");
		return -EINVAL;
	}
	if (len_incl_bad == *length) {
		rval = nand_read (nand, offset, (size_t *)length, buffer);
		if (!rval || rval == -EUCLEAN)
			return 0;
		printf ("NAND read from offset %llx failed %d\n",
			offset, rval);
		return rval;
	}

	while (left_to_read > 0) {
		unsigned block_offset = (unsigned)offset & (nand->erasesize - 1);
		size_t read_length;

		WATCHDOG_RESET ();

		if (offset > nand->size)
			return -EINVAL;

		if ((offset % nand->erasesize) == 0) {
			if (nand_block_isbad (nand, offset & ~((loff_t)nand->erasesize - 1))) {
				printf ("Skipping bad block 0x%08llx\n", offset & ~((loff_t)nand->erasesize - 1));
				offset += nand->erasesize - block_offset;
				continue;
			}
		}

		if (read_with_oob)
			read_length = nand->writesize;
		else {
			if (left_to_read < (nand->erasesize - block_offset))
				read_length = left_to_read;
			else
				read_length = nand->erasesize - block_offset;
		}

		if (read_with_oob) {

			if (read_with_oob == OOB_WITH_RAW) {
				memset(&oob_opts, 0, sizeof(oob_opts));
				oob_opts.mode = MTD_OOB_RAW;
				oob_opts.ooboffs = 0;
				oob_opts.datbuf = p_buffer;
				oob_opts.oobbuf = NULL;
				oob_opts.len = nand->writesize;
				oob_opts.ooblen = nand->oobsize;
			}
			else {
				memset(&oob_opts, 0, sizeof(oob_opts));
				memset(spareAsBytes, 0xff, 16);
				oob_opts.mode = MTD_OOB_AUTO;
				oob_opts.ooboffs = 0;
				oob_opts.datbuf = p_buffer;
				oob_opts.oobbuf = spareAsBytes;
				oob_opts.len = nand->writesize;
				oob_opts.ooblen = 8;
			}

			rval = nand->read_oob (nand, offset, &oob_opts);
			if (rval && rval != -EUCLEAN) {
				printf ("NAND read with spare to offset %llx failed %d\n",
					offset, rval);
				*length -= left_to_read;
				return rval;
			}

			if (read_with_oob != OOB_WITH_RAW)
				translate_oob2spare((yaffs_Spare *)(p_buffer+read_length), spareAsBytes);
		}
		else {
			rval = nand_read (nand, offset, &read_length, p_buffer);
			if (rval && rval != -EUCLEAN) {
				printf ("NAND read from offset %llx failed %d\n",
					offset, rval);
				*length -= left_to_read;
				return rval;
			}
		}

		if (read_with_oob) {
			left_to_read -= (read_length + nand->oobsize);
			offset        += read_length;
			p_buffer      += (read_length + nand->oobsize);
		}
		else {
			left_to_read -= read_length;
			offset       += read_length;
			p_buffer     += read_length;
		}
	}

	return 0;
}
#include <asm/arch/nand.h>

int romboot_nand_write(nand_info_t *nand, loff_t offset, size_t * plen,
			u_char *buf, int protect_flag)
{
	struct mtd_oob_ops aml_oob_ops;
	struct erase_info aml_uboot_erase_info;
	loff_t addr;
	int buf_offset = 0, writed_len = 0, error = 0, unit_size, pages_per_blk;
	unsigned char *data_buf;
	struct mtd_info *mtd = nand;

    //printf("%s\n", __func__);
	memset(&aml_uboot_erase_info, 0, sizeof(struct erase_info));

	if (offset != 0) 
	{
		printk("Wrong addr begin\n");
		return 1;
	}

	data_buf = kzalloc((mtd->writesize), GFP_KERNEL);
	if (!data_buf)
		return 1;

	pages_per_blk = mtd->erasesize / mtd->writesize;
	if (mtd->writesize == 512)
		unit_size = 512;
	else {
#if CONFIG_NAND_AML_M3 || CONFIG_NAND_AML_A3	
		unit_size = mtd->writesize;
#else
		unit_size = 512*3;
#endif
	}

	addr = offset;
	do {
		if ((addr % mtd->erasesize) == 0) {
			aml_uboot_erase_info.mtd = mtd;
			aml_uboot_erase_info.addr = addr;
			aml_uboot_erase_info.len = mtd->erasesize;

			error = mtd->erase(mtd, &aml_uboot_erase_info);
			if (error) {
				printf("uboot erase failed %llx, %d\n", (uint64_t)addr, error);
				mtd->block_markbad(mtd, addr);
				return error;
			}
		}

		addr += mtd->erasesize;
		writed_len += unit_size * pages_per_blk;
	} while(writed_len < (*plen));		

	addr = offset;
	writed_len = 0;
	do {

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		//aml_oob_ops.ooblen = mtd->oobavail;
		//aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		if ((writed_len + unit_size) > (*plen)) {
			memcpy(data_buf, buf + buf_offset, (*plen - writed_len));
			aml_oob_ops.datbuf = data_buf;
		}
		else if (unit_size != mtd->writesize) {
			memset(data_buf, 0x5a, mtd->writesize);
			memcpy(data_buf, buf + buf_offset, unit_size);
			aml_oob_ops.datbuf = data_buf;	
		}
		else
			aml_oob_ops.datbuf = buf + buf_offset;
		//aml_oob_ops.oobbuf = (unsigned char *)oob_buf;

		error = mtd->write_oob(mtd, addr, &aml_oob_ops);
		if (error) {
			printk("uboot write failed: %llx, %d\n", (uint64_t)addr, error);
			return 1;
		}

		addr += mtd->writesize;
		writed_len += unit_size;
		buf_offset += unit_size;

	} while(writed_len < (*plen));

	kfree(data_buf);
	return 0;
}

int romboot_nand_read(nand_info_t *nand, loff_t offset, size_t *plen, u_char *buf)
{
	loff_t addr;
	int buf_offset = 0, unit_size, read_len = 0, error = 0;
	struct mtd_oob_ops aml_oob_ops;
	struct mtd_info *mtd = nand;
	unsigned char oob_buf[mtd->oobavail];
	unsigned char *data_buf;

    //printf("%s\n", __func__);
	data_buf = kzalloc((mtd->writesize), GFP_KERNEL);
	if (!data_buf)
		return 1;

	if (mtd->writesize == 512)
		unit_size = 512;
	else {
#if CONFIG_NAND_AML_M3 || CONFIG_NAND_AML_A3	
		unit_size = mtd->writesize;
#else
		unit_size = 512*3;
#endif
	}
	addr = offset;
	if(offset % (mtd->writesize * 256))
	{
            printf("uboot read offset Alignment failed, Must Multiply by: 0x%x \n", mtd->writesize * 256);
            return 1;
	}
	do {

		if (addr >= mtd->writesize * 256)
			break;

//never check bad block in nandboot area
/*
		if ((addr % mtd->erasesize) == 0) {
			error = mtd->block_isbad(mtd, addr);
			if (error) {
				addr += mtd->erasesize;
				continue;
			}
		}
*/
		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = mtd->oobavail;
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = (unsigned char *)oob_buf;

		error = mtd->read_oob(mtd, addr, &aml_oob_ops);
		if ((error) && (error != -EUCLEAN)) {
			printk("uboot read failed: %llx, %d\n", (uint64_t)addr, error);
			return 1;
		}

		memcpy(buf + buf_offset, data_buf, unit_size);
		addr += mtd->writesize;
		read_len += unit_size;
		buf_offset += unit_size;

	} while(read_len < (*plen));

	kfree(data_buf);
	return 0;
}

#define DECTECT_BAD_NAME		"stupid way for amlogic detect bad block after scrub"
#define SAME_BLK_GOOD_INFO		0
#define SAME_BLK_BAD_INFO		1
#define GOOD_ERASE_FAIL_BAD		2
#define GOOD_WRITE_FAIL_BAD		3
#define GOOD_READ_FAIL_BAD		4
#define GOOD_COMPARE_FAIL_BAD	5

void aml_nand_stupid_dectect_badblock(struct mtd_info *mtd)
{
	int error, test_num = 0, i, blk_num, detect_start_blk, phys_erase_shift;
	size_t pagesize, blocksize;
	loff_t addr;
	size_t retlen;
	erase_info_t erase;
	u_char *data_buf;
	unsigned char *old_bad_blk, *new_bad_blk;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);

	pagesize = mtd->writesize;
	blocksize = mtd->erasesize;

	phys_erase_shift = fls(mtd->erasesize) - 1;
	detect_start_blk = (NAND_MINI_PART_SIZE >> phys_erase_shift);
	if (detect_start_blk < 2)
		detect_start_blk = 2;
	if (!IS_ERR(get_mtd_device_nm(NAND_BOOT_NAME))) {
		addr = (1024 * mtd->writesize / aml_chip->plane_num);
		detect_start_blk += (int)(addr >> phys_erase_shift);
	}
	blk_num = (int)(mtd->size >> phys_erase_shift);

	data_buf = kzalloc(pagesize, GFP_KERNEL);
	if (data_buf == NULL) {
		printk("data_buf malloc failed \n");
		return;
	}
	old_bad_blk = kzalloc(blk_num, GFP_KERNEL);
	new_bad_blk = kzalloc(blk_num, GFP_KERNEL);
	if ((old_bad_blk == NULL) || (new_bad_blk == NULL)) {
		printk("bad blk buf malloc failed \n");
		return;
	}
	
	memset(&erase, 0, sizeof(erase));

	erase.mtd = mtd;
	erase.len  = mtd->erasesize;

	for (i=detect_start_blk; i<blk_num; i++) {
		addr = blocksize;
		addr *= i;
		error = mtd->block_isbad(mtd, addr);
		if (error) {
			old_bad_blk[i] = SAME_BLK_BAD_INFO;
			new_bad_blk[i] = SAME_BLK_BAD_INFO;
			continue;
		}
		else
			old_bad_blk[i] = SAME_BLK_GOOD_INFO;

		if (old_bad_blk[i] == 0) {
			erase.addr = addr;
			error = mtd->erase(mtd, &erase);
			if (error) {
				new_bad_blk[i] = GOOD_ERASE_FAIL_BAD;
				printk("goot blk erase failed %d\n", error);
				mtd->block_markbad(mtd, addr);
				continue;
			}
		}

		memset(data_buf, 0xff, pagesize);
		memcpy(data_buf, DECTECT_BAD_NAME, sizeof(DECTECT_BAD_NAME));
		error = mtd->write(mtd, addr, pagesize, &retlen, data_buf);
		if (error) {
			new_bad_blk[i] = GOOD_WRITE_FAIL_BAD;
			printk("goot blk write failed %d\n", error);
			mtd->block_markbad(mtd, addr);
			continue;
		}

		memset(data_buf, 0xff, pagesize);
		error = mtd->read(mtd, addr, pagesize, &retlen, data_buf);
		if ((error) && (error != -EUCLEAN)) {
			new_bad_blk[i] = GOOD_READ_FAIL_BAD;
			printk("goot blk read failed %d\n", error);
			continue;
		}

		if(strncmp((char*)data_buf, (char*)DECTECT_BAD_NAME, sizeof(DECTECT_BAD_NAME))) {
			new_bad_blk[i] = GOOD_COMPARE_FAIL_BAD;
			printk("goot blk write and compare failed\n");	
			continue;
		}
		new_bad_blk[i] = SAME_BLK_GOOD_INFO;
		mtd->erase(mtd, &erase);
	}

	printk("\n bad blk info before test: \n");
	for (i=0; i<blk_num; i++) {
		if (old_bad_blk[i]) {
			addr = blocksize;
			addr *= i;
			printk("dectect bad blk at %llx \n", (uint64_t)addr);
		}
	}

	printk("\n bad blk info after test: \n");
	for (i=0; i<blk_num; i++) {
		if (new_bad_blk[i]) {
			addr = blocksize;
			addr *= i;
			printk("dectect bad blk at %llx \n", (uint64_t)addr);
		}
	}

	for (i=0; i<blk_num; i++) {
		if (new_bad_blk[i] != old_bad_blk[i]) {
			addr = blocksize;
			addr *= i;
			printk("dectect new bad blk at %llx \n", (uint64_t)addr);
			test_num++;
		}
	}
	if(test_num > 0)
		printk("\n this stupid way had dectected new block %d\n", test_num);
	else
		printk("\n this stupid way is useless for dectect bad block\n");

	kfree(old_bad_blk);
	kfree(new_bad_blk);
	kfree(data_buf);
	return;
}

int nand_raw_read_factory_info(struct mtd_info *mtd, loff_t from, size_t len,
		     size_t *retlen, uint8_t *buf, struct mtd_oob_ops *ops);

int nand_raw_read_nand_dev(nand_info_t *nand, loff_t offset, loff_t *length,
		       u_char *buffer, unsigned all,unsigned autodetect)
{
    size_t  left_to_read = *length;
    struct  nand_chip *chip = nand->priv;
    size_t retlen;
    struct mtd_oob_ops volatile raw_ops;
    loff_t addr_from=0;
//	u_char *p_buffer = buffer;
    u_char *tmp_buf=NULL;
    size_t page_no,block_num=0,bad_num=0;
	//size_t read_length;
    int rval=0;
    int badblockFlag;
    char c;
    
    tmp_buf = kzalloc((nand->writesize + nand->oobsize), GFP_KERNEL);
    if(!tmp_buf)
    {
        printk("no memory for flash data buf\n");
		rval = -ENOMEM;
		return rval;
    }
    
    memset((void *)&raw_ops, 0, sizeof(raw_ops));
    raw_ops.len = nand->writesize;
    raw_ops.ooblen = nand->oobsize;
    raw_ops.ooboffs = 0;
    raw_ops.datbuf = tmp_buf;
    raw_ops.oobbuf = &tmp_buf[nand->writesize];
    raw_ops.mode = MTD_OOB_RAW;
    if(all)
    {
        left_to_read = nand->size/nand->erasesize;
        offset = 0;
        block_num = 0;
    }
    else
    {
        //left_to_read = left_to_read * nand->erasesize;
        //addr_from = offset<<chip->phys_erase_shift;
        block_num = offset;
        if ((addr_from + (left_to_read*nand->erasesize)) > nand->size) {
		    printf ("Attempt to read outside the flash area\n");
		    return -EINVAL;
	    }
    }
    
    while (left_to_read > 0) {
        
		//read_length = nand->writesize;
		
		badblockFlag = 0;
		//badblockFlag = 1;//debug

        memset(tmp_buf,0,nand->writesize+nand->oobsize);
        page_no = 0;
        addr_from = (block_num << chip->phys_erase_shift) + (page_no<<chip->page_shift);
    	rval = nand_raw_read_factory_info(nand,addr_from,nand->writesize,&retlen,tmp_buf,&raw_ops);
    	if (rval && rval != -EUCLEAN) {
    		printf ("NAND read from offset %zx failed %d\n",
    			(size_t)offset, rval);
    		*length -= left_to_read;
    		return rval;
    	}
    	if(tmp_buf[nand->writesize]!=0xff)
	    {
	        printf("bad block:0x%x, page no:0x%x\n",block_num, page_no);
	        
	        print_buffer((ulong)(tmp_buf+nand->writesize), &tmp_buf[nand->writesize], /*size*/1, /*linebytes/size*/nand->oobsize, /*DISP_LINE_LEN/size*/8);
	        badblockFlag = 1;
	    }

        memset(tmp_buf,0,nand->writesize+nand->oobsize);
        page_no = nand->erasesize/nand->writesize - 1;
        addr_from = ( block_num << chip->phys_erase_shift) + (page_no<<chip->page_shift);
    	rval = nand_raw_read_factory_info(nand,addr_from,nand->writesize,&retlen,tmp_buf,&raw_ops);
    	if (rval && rval != -EUCLEAN) {
    		printf ("NAND read from offset %zx failed %d\n",
    			(size_t)offset, rval);
    		*length -= left_to_read;
    		return rval;
    	}
    	if(tmp_buf[nand->writesize]!=0xff)
        {
            badblockFlag = 1;
	        printf("bad block:0x%x, page no:0x%x\n", block_num,page_no);
	        print_buffer((ulong)(tmp_buf+nand->writesize), &tmp_buf[nand->writesize], /*size*/1, /*linebytes/size*/nand->oobsize, /*DISP_LINE_LEN/size*/8);
        }
        if(badblockFlag)
        {
	        bad_num++;
	        if(autodetect)
	        {
    	        c = getc();
    	        if(c=='b')
                {
                    break;
                }
            }
        }
    	
    	left_to_read--;
    	block_num++;

    }

    printf("\ntotal bad block count:0x%x\n",bad_num);
    if(tmp_buf)
    {
        kfree(tmp_buf);
        tmp_buf = NULL;
    }
    return rval;
}

