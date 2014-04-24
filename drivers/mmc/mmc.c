/*
 * Copyright 2008, Freescale Semiconductor, Inc
 * Andy Fleming
 *
 * Based vaguely on the Linux code
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

#include <config.h>
#include <common.h>
#include <command.h>
#include <mmc.h>
#include <part.h>
#include <malloc.h>
#include <linux/list.h>
#include <mmc.h>
#include <div64.h>

#if defined(CONFIG_S5P6450)
DECLARE_GLOBAL_DATA_PTR;
#endif

#ifdef CONFIG_CMD_MOVINAND
extern int init_raw_area_table (block_dev_desc_t * dev_desc, int location);
#endif

#include <asm/arch/cpu.h>
#include <asm/arch/s3c_hsmmc.h>
static void feedback_delay(struct mmc *mmc, int count);

//#define DEBUG_MMC
#ifdef DEBUG_MMC
#define dbg(x...)       printf(x)
#else
#define dbg(x...)       do { } while (0)
#endif

static struct list_head mmc_devices;
static int cur_dev_num = -1;
static int once = 1;

int __board_mmc_getcd(u8 *cd, struct mmc *mmc) {
	return -1;
}

int board_mmc_getcd(u8 *cd, struct mmc *mmc)__attribute__((weak,
	alias("__board_mmc_getcd")));

int mmc_send_cmd(struct mmc *mmc, struct mmc_cmd *cmd, struct mmc_data *data)
{
	return mmc->send_cmd(mmc, cmd, data);
}

int mmc_set_blocklen(struct mmc *mmc, int len)
{
	struct mmc_cmd cmd;

	cmd.cmdidx = MMC_CMD_SET_BLOCKLEN;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = len;
	cmd.flags = 0;

	return mmc_send_cmd(mmc, &cmd, NULL);
}

struct mmc *find_mmc_device(int dev_num)
{
	struct mmc *m;
	struct list_head *entry;

	list_for_each(entry, &mmc_devices) {
		m = list_entry(entry, struct mmc, link);

		if (m->block_dev.dev == dev_num)
			return m;
	}

	debug("MMC Device %d not found\n", dev_num);

	return NULL;
}

static ulong
mmc_bwrite(int dev_num, ulong start, lbaint_t blkcnt, const void*src)
{
	struct mmc_cmd cmd;
	struct mmc_data data;
	int err;
	struct mmc *mmc = find_mmc_device(dev_num);
	int blklen;

	if (!mmc)
		return -1;

	int count=1;
	int timeout_c = 100;
	int timeout_d = 100;

	blklen = mmc->write_bl_len;

	if (blkcnt > 1)
		cmd.cmdidx = MMC_CMD_WRITE_MULTIPLE_BLOCK;
	else
		cmd.cmdidx = MMC_CMD_WRITE_SINGLE_BLOCK;

	if (mmc->high_capacity)
		cmd.cmdarg = start;
	else
		cmd.cmdarg = start * blklen;

	cmd.resp_type = MMC_RSP_R1;
	cmd.flags = 0;

	data.src = src;
	data.blocks = blkcnt;
	data.blocksize = (1<<9);
	data.flags = MMC_DATA_WRITE;

	err = mmc_send_cmd(mmc, &cmd, &data);

	if (err) {

if (strncmp(mmc->name, "S5P_MSHC", 8) != 0) {
		for(; count<9;) {
			printf("\ncount: %d\n", count);
			feedback_delay(mmc, count);
			count++;

			writeb((1<<1), mmc->ioaddr + SDHCI_SOFTWARE_RESET);
			printf("CMD reset\n");
			while (readb(mmc->ioaddr + SDHCI_SOFTWARE_RESET) & (1<<1)) {
				if (timeout_c == 0) {
					printf("CMD Reset is NEVER released\n");
					return 0;
				}
				timeout_c--;
				udelay(1000);
			}

			writeb((1<<2), mmc->ioaddr + SDHCI_SOFTWARE_RESET);
			printf("DATA reset\n");
			while (readb(mmc->ioaddr + SDHCI_SOFTWARE_RESET) & (1<<2)) {
				if (timeout_d == 0) {
					printf("DATA Reset is NEVER released\n");
					return 0;
				}
				timeout_d--;
				udelay(1000);
			}

			udelay(1000);

			err = mmc_send_cmd(mmc, &cmd, &data);

			/* If No error */
			if (!err)
				break;
		}

		if (count >= 9) {
			printf("\n\nmmc write failed ERROR: %d\n\r", err);
			printf("data.dest: 0x%08x\n", data.dest);
			printf("data.blocks: %d\n", data.blocks);
			printf("data.blocksize: %d\n", data.blocksize);
			printf("MMC_DATA_WRITE\n");
			return err;
		}
} else {
		printf("mmc write failed\n\r");
		return err;
}
	}

	return blkcnt;
}

int mmc_read_block(struct mmc *mmc, void *dst, uint blocknum)
{
	struct mmc_cmd cmd;
	struct mmc_data data;

	cmd.cmdidx = MMC_CMD_READ_SINGLE_BLOCK;

	if (mmc->high_capacity)
		cmd.cmdarg = blocknum;
	else
		cmd.cmdarg = blocknum * mmc->read_bl_len;

	cmd.resp_type = MMC_RSP_R1;
	cmd.flags = 0;

	data.dest = dst;
	data.blocks = 1;
	data.blocksize = (1<<9);
	data.flags = MMC_DATA_READ;

	return mmc_send_cmd(mmc, &cmd, &data);
}

int mmc_read(struct mmc *mmc, u64 src, uchar *dst, int size)
{
	char *buffer;
	int i;
	int blklen = mmc->read_bl_len;
	int startblock = lldiv(src, mmc->read_bl_len);
	int endblock = lldiv(src + size - 1, mmc->read_bl_len);
	int err = 0;

	/* Make a buffer big enough to hold all the blocks we might read */
	buffer = malloc(blklen);

	if (!buffer) {
		printf("Could not allocate buffer for MMC read!\n");
		return -1;
	}

	for (i = startblock; i <= endblock; i++) {
		int segment_size;
		int offset;

		err = mmc_read_block(mmc, buffer, i);

		if (err)
			goto free_buffer;

		/*
		 * The first block may not be aligned, so we
		 * copy from the desired point in the block
		 */
		offset = (src & (blklen - 1));
		segment_size = MIN(blklen - offset, size);

		memcpy(dst, buffer + offset, segment_size);

		dst += segment_size;
		src += segment_size;
		size -= segment_size;
	}

free_buffer:
	free(buffer);

	return err;
}

static ulong mmc_bread(int dev_num, ulong start, lbaint_t blkcnt, void *dst)
{
	int err;
	struct mmc_cmd cmd;
	struct mmc_data data;
	struct mmc *mmc = find_mmc_device(dev_num);
	int count = 1;
	int timeout_c = 100;
	int timeout_d = 100;

	if (!mmc)
		return 0;

	if (blkcnt > 1)
		cmd.cmdidx = MMC_CMD_READ_MULTIPLE_BLOCK;
	else
		cmd.cmdidx = MMC_CMD_READ_SINGLE_BLOCK;

	if (mmc->high_capacity)
		cmd.cmdarg = start;
	else
		cmd.cmdarg = start * mmc->read_bl_len;

	cmd.resp_type = MMC_RSP_R1;
	cmd.flags = 0;

	data.dest = dst;
	data.blocks = blkcnt;
	data.blocksize = (1<<9);
	data.flags = MMC_DATA_READ;

	err = mmc_send_cmd(mmc, &cmd, &data);
	if (err) {

if (strncmp(mmc->name, "S5P_MSHC", 8) != 0) {
		for(; count<9;) {
			printf("\ncount: %d\n", count);
			feedback_delay(mmc, count);
			count++;

			writeb((1<<1), mmc->ioaddr + SDHCI_SOFTWARE_RESET);
			while (readb(mmc->ioaddr + SDHCI_SOFTWARE_RESET) & (1<<1)) {
				if (timeout_c == 0) {
					printf("CMD Reset is NEVER released\n");
					return 0;
				}
				timeout_c--;
				udelay(1000);
			}

			writeb((1<<2), mmc->ioaddr + SDHCI_SOFTWARE_RESET);
			while (readb(mmc->ioaddr + SDHCI_SOFTWARE_RESET) & (1<<2)) {
				if (timeout_d == 0) {
					printf("DATA Reset is NEVER released\n");
					return 0;
				}
				timeout_d--;
				udelay(1000);
			}

			err = mmc_send_cmd(mmc, &cmd, &data);

			/* If No error */
			if (!err)
				break;
		}

		if (count >= 9) {
			printf("mmc read failed ERROR: %d\n\r", err);
			printf("data.dest: 0x%08x\n", data.dest);
			printf("data.blocks: %d\n", data.blocks);
			printf("data.blocksize: %d\n", data.blocksize);
			printf("MMC_DATA_READ\n");
			return err;
		}
} else {
		printf("mmc read failed\n");
		return err;
}
	}

	return blkcnt;
}

ulong movi_write(int dev_num, ulong start, lbaint_t blkcnt, void *src)
{
	return mmc_bwrite(dev_num, start, blkcnt, src);
}

ulong movi_read(int dev_num, ulong start, lbaint_t blkcnt, void *dst)
{
	return mmc_bread(dev_num, start, blkcnt, dst);
}

int mmc_go_idle(struct mmc* mmc)
{
	struct mmc_cmd cmd;
	int err;

	udelay(1000);

	cmd.cmdidx = MMC_CMD_GO_IDLE_STATE;
	cmd.cmdarg = 0;
	cmd.resp_type = MMC_RSP_NONE;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	udelay(2000);

	return 0;
}

int
sd_send_op_cond(struct mmc *mmc)
{
	int timeout = 1000;
	int err;
	struct mmc_cmd cmd;

	do {
		cmd.cmdidx = MMC_CMD_APP_CMD;
		cmd.resp_type = MMC_RSP_R1;
		cmd.cmdarg = 0;
		cmd.flags = 0;

		err = mmc_send_cmd(mmc, &cmd, NULL);

		if (err)
			return err;

		cmd.cmdidx = SD_CMD_APP_SEND_OP_COND;
		cmd.resp_type = MMC_RSP_R3;

		/*
		 * Most cards do not answer if some reserved bits
		 * in the ocr are set. However, Some controller
		 * can set bit 7 (reserved for low voltages), but
		 * how to manage low voltages SD card is not yet
		 * specified.
		 */
		cmd.cmdarg = mmc->voltages & 0xff8000;

		if (mmc->version == SD_VERSION_2)
			cmd.cmdarg |= OCR_HCS;

		err = mmc_send_cmd(mmc, &cmd, NULL);

		if (err)
			return err;

		udelay(1000);
	} while ((!(cmd.response[0] & OCR_BUSY)) && timeout--);

	if (timeout <= 0)
		return UNUSABLE_ERR;

	if (mmc->version != SD_VERSION_2)
		mmc->version = SD_VERSION_1_0;

	mmc->ocr = cmd.response[0];

	mmc->high_capacity = ((mmc->ocr & OCR_HCS) == OCR_HCS);
	mmc->rca = 0;

	dbg("OCR return 0x%x\n",cmd.response[0]);

	return 0;
}

int mmc_send_op_cond(struct mmc *mmc)
{
	int timeout = 1000;
	struct mmc_cmd cmd;
	int err;

	/* Some cards seem to need this */
	mmc_go_idle(mmc);

	do {
		cmd.cmdidx = MMC_CMD_SEND_OP_COND;
		cmd.resp_type = MMC_RSP_R3;
		cmd.cmdarg = OCR_HCS | mmc->voltages;
		cmd.flags = 0;

		err = mmc_send_cmd(mmc, &cmd, NULL);

		if (err)
			return err;

		udelay(1000);
	} while (!(cmd.response[0] & OCR_BUSY) && timeout--);

	if (timeout <= 0)
		return UNUSABLE_ERR;

	mmc->version = MMC_VERSION_UNKNOWN;
	mmc->ocr = cmd.response[0];

	mmc->high_capacity = ((mmc->ocr & OCR_HCS) == OCR_HCS);
	mmc->rca = 0x0001;

	return 0;
}


int mmc_send_ext_csd(struct mmc *mmc, char *ext_csd)
{
	struct mmc_cmd cmd;
	struct mmc_data data;
	int err;

	/* Get the Card Status Register */
	cmd.cmdidx = MMC_CMD_SEND_EXT_CSD;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = 0;
	cmd.flags = 0;

	data.dest = ext_csd;
	data.blocks = 1;
	data.blocksize = 512;
	data.flags = MMC_DATA_READ;

	err = mmc_send_cmd(mmc, &cmd, &data);

	return err;
}


int mmc_switch(struct mmc *mmc, u8 set, u8 index, u8 value)
{
	struct mmc_cmd cmd;

	cmd.cmdidx = MMC_CMD_SWITCH;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = (MMC_SWITCH_MODE_WRITE_BYTE << 24) |
		(index << 16) |
		(value << 8);
	cmd.flags = 0;

	return mmc_send_cmd(mmc, &cmd, NULL);
}

int mmc_change_freq(struct mmc *mmc)
{
	char ext_csd[512];
	char cardtype;
	int err;
	u8 high_speed = 0;

	mmc->card_caps = 0;

	/* Only version 4 supports high-speed */
	if (mmc->version < MMC_VERSION_4)
		return 0;

	err = mmc_send_ext_csd(mmc, ext_csd);

	if (err)
		return err;

	if (ext_csd[212] || ext_csd[213] || ext_csd[214] || ext_csd[215])
		mmc->high_capacity = 1;

	cardtype = ext_csd[196] & 0xf;

	dbg("cardtype: 0x%08x\n", cardtype);
	
	/* High Speed is set, there are three types: DDR 52Mhz,
	 * 52MHz and 26MHz
	 */
	if (cardtype & (MMC_HS_52MHZ_1_8V_3V_IO)) {
	dbg("MMC_HS_52MHZ_1_8V_3V_IO\n");
		mmc->card_caps |= MMC_MODE_HS_52MHz_DDR_18_3V | 
						MMC_MODE_HS_52MHz | MMC_MODE_HS |
						MMC_MODE_8BIT_DDR | MMC_MODE_4BIT_DDR |
						MMC_MODE_4BIT | MMC_MODE_8BIT;
		high_speed = 1;
	}
	else if (cardtype & MMC_HS_52MHZ) {
	dbg("MMC_HS_52MHZ\n");
		mmc->card_caps |= MMC_MODE_HS_52MHz | MMC_MODE_HS |
						MMC_MODE_4BIT | MMC_MODE_8BIT;
		high_speed = 1;
	}
	else {
	dbg("MMC_MODE_HS\n");
		mmc->card_caps |= MMC_MODE_HS |
						MMC_MODE_4BIT | MMC_MODE_8BIT;
		high_speed = 0;
	}

	/* Set High speed mode */
	err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL, EXT_CSD_HS_TIMING, high_speed);		
	if (err)
		return err;

	if (strcmp(mmc->name, "S5P_MSHC4") == 0) {
		if(once) {
			char man_ID= (mmc->cid[0] >> 24);
			unsigned long size = (mmc->capacity/(1024*1024/mmc->read_bl_len));

			if(man_ID == 0x15) { //samsung
				printf("Manufacturer SAMSUNG [ %dMB ]\n",size);
			}
			else if(man_ID == 0x90) {
				printf("Manufacturer HYNIX [ %dMB ] \n", size);
				if(size < 16000) {
					err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL, EXT_CSD_RST_N_FUNCTION, EXT_CSD_RST_N_ENABLED);
					if (err) {
						printf("\n%s[%d] : EXT_CSD_RST_N_FUNCTION Set error....... \n\n",__func__,__LINE__);
						return err;
					}
				}
			}
			else if(man_ID == 0x11) {
				printf("Manufacturer TOSHIBA [ %dMB ]\n",size);
				err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL, EXT_CSD_RST_N_FUNCTION, EXT_CSD_RST_N_ENABLED);
				if(err) {
					printf("\n%s[%d] : EXT_CSD_RST_N_FUNCTION Set error....... \n\n",__func__,__LINE__);
					return err;
				}
			}
			once = 0;
		}
	}

	return 0;
}

int sd_switch(struct mmc *mmc, int mode, int group, u8 value, u8 *resp)
{
	struct mmc_cmd cmd;
	struct mmc_data data;

	/* Switch the frequency */
	cmd.cmdidx = SD_CMD_SWITCH_FUNC;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = (mode << 31) | 0xffffff;
	cmd.cmdarg &= ~(0xf << (group * 4));
	cmd.cmdarg |= value << (group * 4);
	cmd.flags = 0;

	data.dest = (char *)resp;
	data.blocksize = 64;
	data.blocks = 1;
	data.flags = MMC_DATA_READ;

	return mmc_send_cmd(mmc, &cmd, &data);
}


int sd_change_freq(struct mmc *mmc)
{
	int err;
	struct mmc_cmd cmd;
	uint scr[2];
	uint switch_status[16];
	struct mmc_data data;
	int timeout;

	mmc->card_caps = 0;

	/* Read the SCR to find out if this card supports higher speeds */
	cmd.cmdidx = MMC_CMD_APP_CMD;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = mmc->rca << 16;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	cmd.cmdidx = SD_CMD_APP_SEND_SCR;
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = 0;
	cmd.flags = 0;

	timeout = 3;

retry_scr:
	data.dest = (char *)&scr;
	data.blocksize = 8;
	data.blocks = 1;
	data.flags = MMC_DATA_READ;

	err = mmc_send_cmd(mmc, &cmd, &data);

	if (err) {
		if (timeout--)
			goto retry_scr;

		return err;
	}

	mmc->scr[0] = __be32_to_cpu(scr[0]);
	mmc->scr[1] = __be32_to_cpu(scr[1]);

	switch ((mmc->scr[0] >> 24) & 0xf) {
		case 0:
			mmc->version = SD_VERSION_1_0;
			break;
		case 1:
			mmc->version = SD_VERSION_1_10;
			break;
		case 2:
			mmc->version = SD_VERSION_2;
			break;
		default:
			mmc->version = SD_VERSION_1_0;
			break;
	}

	/* Version 1.0 doesn't support switching */
	if (mmc->version == SD_VERSION_1_0)
		return 0;

	timeout = 4;
	while (timeout--) {
		err = sd_switch(mmc, SD_SWITCH_CHECK, 0, 1,
				(u8 *)&switch_status);

		if (err)
			return err;

		/* The high-speed function is busy.  Try again */
		if (!(__be32_to_cpu(switch_status[7]) & SD_HIGHSPEED_BUSY))
			break;
	}

	if (mmc->scr[0] & SD_DATA_4BIT)
		mmc->card_caps |= MMC_MODE_4BIT;
	/* If high-speed isn't supported, we return */
	if (!(__be32_to_cpu(switch_status[3]) & SD_HIGHSPEED_SUPPORTED))
		return 0;

	err = sd_switch(mmc, SD_SWITCH_SWITCH, 0, 1, (u8 *)&switch_status);

	if (err)
		return err;

	sd_switch(mmc, SD_SWITCH_CHECK, 0, 1, (u8 *)&switch_status);

	if ((__be32_to_cpu(switch_status[4]) & 0x0f000000) == 0x01000000)
		mmc->card_caps |= MMC_MODE_HS;

	return 0;
}

/* frequency bases */
/* divided by 10 to be nice to platforms without floating point */
int fbase[] = {
	10000,
	100000,
	1000000,
	10000000,
};

/* Multiplier values for TRAN_SPEED.  Multiplied by 10 to be nice
 * to platforms without floating point.
 */
int multipliers[] = {
	0,	/* reserved */
	10,
	12,
	13,
	15,
	20,
	25,
	30,
	35,
	40,
	45,
	50,
	55,
	60,
	70,
	80,
};

static const unsigned int tran_exp[] = {
	10000,		100000,		1000000,	10000000,
	0,		0,		0,		0
};

static const unsigned char tran_mant[] = {
	0,	10,	12,	13,	15,	20,	25,	30,
	35,	40,	45,	50,	55,	60,	70,	80,
};

static const unsigned int tacc_exp[] = {
	1,	10,	100,	1000,	10000,	100000,	1000000, 10000000,
};

static const unsigned int tacc_mant[] = {
	0,	10,	12,	13,	15,	20,	25,	30,
	35,	40,	45,	50,	55,	60,	70,	80,
};

#define UNSTUFF_BITS(resp,start,size)					\
	({								\
		const int __size = size;				\
		const u32 __mask = (__size < 32 ? 1 << __size : 0) - 1;	\
		const int __off = 3 - ((start) / 32);			\
		const int __shft = (start) & 31;			\
		u32 __res;						\
									\
		__res = resp[__off] >> __shft;				\
		if (__size + __shft > 32)				\
			__res |= resp[__off-1] << ((32 - __shft) % 32);	\
		__res & __mask;						\
	})

/*
 * Given a 128-bit response, decode to our card CSD structure. for SD
 * every
 */
static int sd_decode_csd(struct mmc *host)
{
	struct mmc_csd csd_org, *csd;
	unsigned int e, m, csd_struct;
	u32 *resp = host->csd;

	csd = &csd_org;

	csd_struct = UNSTUFF_BITS(resp, 126, 2);

	switch (csd_struct) {
	case 0:
		m = UNSTUFF_BITS(resp, 115, 4);
		e = UNSTUFF_BITS(resp, 112, 3);
		csd->tacc_ns	 = (tacc_exp[e] * tacc_mant[m] + 9) / 10;
		csd->tacc_clks	 = UNSTUFF_BITS(resp, 104, 8) * 100;

		m = UNSTUFF_BITS(resp, 99, 4);
		e = UNSTUFF_BITS(resp, 96, 3);
		csd->max_dtr	  = tran_exp[e] * tran_mant[m];
		csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);

		e = UNSTUFF_BITS(resp, 47, 3);
		m = UNSTUFF_BITS(resp, 62, 12);
		csd->capacity	  = (1 + m) << (e + 2);

		csd->read_blkbits = UNSTUFF_BITS(resp, 80, 4);
		csd->read_partial = UNSTUFF_BITS(resp, 79, 1);
		csd->write_misalign = UNSTUFF_BITS(resp, 78, 1);
		csd->read_misalign = UNSTUFF_BITS(resp, 77, 1);
		csd->r2w_factor = UNSTUFF_BITS(resp, 26, 3);
		csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
		csd->write_partial = UNSTUFF_BITS(resp, 21, 1);
		host->read_bl_len = (1<<9);
		host->write_bl_len = (1<<9);
		host->capacity = csd->capacity<<(csd->read_blkbits - 9);
		break;
	case 1:
		/*
		 * This is a block-addressed SDHC card. Most
		 * interesting fields are unused and have fixed
		 * values. To avoid getting tripped by buggy cards,
		 * we assume those fixed values ourselves.
		 */

		csd->tacc_ns	 = 0; /* Unused */
		csd->tacc_clks	 = 0; /* Unused */

		m = UNSTUFF_BITS(resp, 99, 4);
		e = UNSTUFF_BITS(resp, 96, 3);
		csd->max_dtr	  = tran_exp[e] * tran_mant[m];
		csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);

		m = UNSTUFF_BITS(resp, 48, 22);
		csd->capacity     = (1 + m) << 10;

		csd->read_blkbits = 9;
		csd->read_partial = 0;
		csd->write_misalign = 0;
		csd->read_misalign = 0;
		csd->r2w_factor = 4; /* Unused */
		csd->write_blkbits = 9;
		csd->write_partial = 0;

		host->high_capacity = 1;
		host->read_bl_len = (1<<9);
		host->write_bl_len = (1<<9);
		host->capacity = csd->capacity;
		break;
	default:
		printf("unrecognised CSD structure version %d\n"
			, csd_struct);
		return -1;
	}

	return 0;
}

/*
 * Given a 128-bit response, decode to our card CSD structure.
 */
static int mmc_decode_csd(struct mmc *host)
{
	struct mmc_csd csd_org, *csd;
	unsigned int e, m, csd_struct;
	u32 *resp = host->csd;

	csd = &csd_org;

	/*
	 * We only understand CSD structure v1.1 and v1.2.
	 * v1.2 has extra information in bits 15, 11 and 10.
	 */
	csd_struct = UNSTUFF_BITS(resp, 126, 2);
	//if (csd_struct != 1 && csd_struct != 2) {
	if (csd_struct != 1 && csd_struct != 2 && csd_struct != 3) {
		printf("unrecognised CSD structure version %d\n",
			csd_struct);
		return -1;
	}

	csd->mmca_vsn	 = UNSTUFF_BITS(resp, 122, 4);
	switch (csd->mmca_vsn) {
	case 0:
		host->version = MMC_VERSION_1_2;
		break;
	case 1:
		host->version = MMC_VERSION_1_4;
		break;
	case 2:
		host->version = MMC_VERSION_2_2;
		break;
	case 3:
		host->version = MMC_VERSION_3;
		break;
	case 4:
		host->version = MMC_VERSION_4;
		break;
	}

	m = UNSTUFF_BITS(resp, 115, 4);
	e = UNSTUFF_BITS(resp, 112, 3);
	csd->tacc_ns	 = (tacc_exp[e] * tacc_mant[m] + 9) / 10;
	csd->tacc_clks	 = UNSTUFF_BITS(resp, 104, 8) * 100;

	m = UNSTUFF_BITS(resp, 99, 4);
	e = UNSTUFF_BITS(resp, 96, 3);
	csd->max_dtr	  = tran_exp[e] * tran_mant[m];
	csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);

	e = UNSTUFF_BITS(resp, 47, 3);
	m = UNSTUFF_BITS(resp, 62, 12);
	csd->capacity	  = (1 + m) << (e + 2);

	csd->read_blkbits = UNSTUFF_BITS(resp, 80, 4);
	csd->read_partial = UNSTUFF_BITS(resp, 79, 1);
	csd->write_misalign = UNSTUFF_BITS(resp, 78, 1);
	csd->read_misalign = UNSTUFF_BITS(resp, 77, 1);
	csd->r2w_factor = UNSTUFF_BITS(resp, 26, 3);
	csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
	csd->write_partial = UNSTUFF_BITS(resp, 21, 1);

	host->read_bl_len = 1 << csd->read_blkbits;
	host->write_bl_len = 1 << csd->write_blkbits;
	host->capacity = csd->capacity;
	host->clock = 20000000;

	return 0;
}

/*
 * Read and decode extended CSD.
 */
static int mmc_read_ext_csd(struct mmc *host)
{
	int err;
	char *ext_csd;
	unsigned int ext_csd_struct;

	if (host->version < (MMC_VERSION_4 | MMC_VERSION_MMC))
		return 0;

	/*
	 * As the ext_csd is so large and mostly unused, we don't store the
	 * raw block in mmc_card.
	 */
	ext_csd = malloc(512);
	if (!ext_csd) {
		printf("could not allocate a buffer to "
			"receive the ext_csd.\n");
		return -1;
	}

	err = mmc_switch(host, EXT_CSD_CMD_SET_NORMAL, EXT_CSD_HS_TIMING, 0);
	if (err)
		return err;

	err = mmc_switch(host, EXT_CSD_CMD_SET_NORMAL,
				EXT_CSD_BUS_WIDTH,
				EXT_CSD_BUS_WIDTH_1);	
	if (err)
		return err;
	

	err = mmc_send_ext_csd(host, ext_csd);
	if (err) {
		/*
		 * High capacity cards should have this "magic" size
		 * stored in their CSD.
		 */
		if (host->capacity == (4096 * 512)) {
			printf("unable to read EXT_CSD "
				"on a possible high capacity card. "
				"Card will be ignored.\n");
		} else {
			printf("unable to read "
				"EXT_CSD, performance might suffer.\n");
			err = 0;
		}

		goto out;
	}

	ext_csd_struct = ext_csd[EXT_CSD_REV];
	host->ext_csd.boot_size_multi = ext_csd[BOOT_SIZE_MULTI];
	
	if (ext_csd_struct > 7) {
		printf("unrecognised EXT_CSD structure "
			"version %d\n", ext_csd_struct);
		err = -1;
		goto out;
	}

	if (ext_csd_struct >= 2) {
		host->ext_csd.sectors =
			ext_csd[EXT_CSD_SEC_CNT + 0] << 0 |
			ext_csd[EXT_CSD_SEC_CNT + 1] << 8 |
			ext_csd[EXT_CSD_SEC_CNT + 2] << 16 |
			ext_csd[EXT_CSD_SEC_CNT + 3] << 24;
		if (host->ext_csd.sectors) {
			host->high_capacity = 1;
			host->capacity = host->ext_csd.sectors;
		}
	}

	if ((ext_csd[EXT_CSD_CARD_TYPE] & 0xf) & (EXT_CSD_CARD_TYPE_52 |
			EXT_CSD_CARD_TYPE_52_DDR_18_30 | EXT_CSD_CARD_TYPE_52_DDR_12)) {
		host->ext_csd.hs_max_dtr = 52000000;
		host->clock = 52000000;
	} else if (ext_csd[EXT_CSD_CARD_TYPE] & EXT_CSD_CARD_TYPE_26) {
		host->ext_csd.hs_max_dtr = 26000000;
		host->clock = 26000000;
	} else {
		/* MMC v4 spec says this cannot happen */
		printf("card is mmc v4 but doesn't "
			"support any high-speed modes.\n");
		goto out;
	}

out:
	free(ext_csd);

	return err;
}


void mmc_set_ios(struct mmc *mmc)
{
	mmc->set_ios(mmc);
}

void mmc_set_clock(struct mmc *mmc, uint clock)
{
	if (clock > mmc->f_max)
		clock = mmc->f_max;

	if (clock < mmc->f_min)
		clock = mmc->f_min;

	mmc->clock = clock;

	mmc_set_ios(mmc);
}

void mmc_set_bus_width(struct mmc *mmc, uint width)
{
	mmc->bus_width = width;

	mmc_set_ios(mmc);
}

int mmc_startup(struct mmc *mmc)
{
	int err;
	struct mmc_cmd cmd;

	/* Put the Card in Identify Mode */
	cmd.cmdidx = MMC_CMD_ALL_SEND_CID;
	cmd.resp_type = MMC_RSP_R2;
	cmd.cmdarg = 0;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	memcpy(mmc->cid, cmd.response, 16);

	/*
	 * For MMC cards, set the Relative Address.
	 * For SD cards, get the Relatvie Address.
	 * This also puts the cards into Standby State
	 */
	cmd.cmdidx = SD_CMD_SEND_RELATIVE_ADDR;
	cmd.cmdarg = mmc->rca << 16;
	cmd.resp_type = MMC_RSP_R1;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	if (IS_SD(mmc))
		mmc->rca = (cmd.response[0] >> 16) & 0xffff;

	/* Get the Card-Specific Data */
	cmd.cmdidx = MMC_CMD_SEND_CSD;
	cmd.resp_type = MMC_RSP_R2;
	cmd.cmdarg = mmc->rca << 16;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	memcpy(mmc->csd, cmd.response, 4*4);
	if (IS_SD(mmc))
		sd_decode_csd(mmc);
	else
		mmc_decode_csd(mmc);

	/* Select the card, and put it into Transfer Mode */
	cmd.cmdidx = MMC_CMD_SELECT_CARD;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = mmc->rca << 16;
	cmd.flags = 0;
	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	if (IS_SD(mmc)) {
		err = sd_change_freq(mmc);
	} else { 
		err = mmc_read_ext_csd(mmc);
		if (err)
			return err;
		err = mmc_change_freq(mmc);
	}

	if (err)
		return err;

	/* Restrict card's capabilities by what the host can do */
	mmc->card_caps &= mmc->host_caps;

	dbg("mmc->card_caps: 0x%08x\n", mmc->card_caps);
	dbg("mmc->host_caps: 0x%08x\n", mmc->host_caps);

	/* We always do full block reads from the card */
	err = mmc_set_blocklen(mmc, mmc->read_bl_len);

	if (err) {
		return 0;
	}

	if (IS_SD(mmc)) {
		if (mmc->card_caps & MMC_MODE_4BIT) {
			dbg("!!!Enter 4 Bit mode.!!!\n");
			cmd.cmdidx = MMC_CMD_APP_CMD;
			cmd.resp_type = MMC_RSP_R1;
			cmd.cmdarg = mmc->rca << 16;
			cmd.flags = 0;

			err = mmc_send_cmd(mmc, &cmd, NULL);
			if (err)
				return err;

			cmd.cmdidx = SD_CMD_APP_SET_BUS_WIDTH;
			cmd.resp_type = MMC_RSP_R1;
			cmd.cmdarg = 2;
			cmd.flags = 0;
			err = mmc_send_cmd(mmc, &cmd, NULL);
			if (err)
				return err;

			mmc_set_bus_width(mmc, MMC_BUS_WIDTH_4);
		}

		if (mmc->card_caps & MMC_MODE_HS)
			mmc_set_clock(mmc, 50000000);
		else {
			mmc_set_clock(mmc, 25000000);
		}
	} else {
		if (mmc->card_caps & MMC_MODE_8BIT_DDR) {
			dbg("!!!Enter 8 Bit DDR mode.!!!\n");
			/* Set the card to use 8 bit DDR*/
			err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
					EXT_CSD_BUS_WIDTH,
					EXT_CSD_BUS_WIDTH_8_DDR);

			if (err)
				return err;

			mmc_set_bus_width(mmc, MMC_BUS_WIDTH_8_DDR);
		} else if (mmc->card_caps & MMC_MODE_4BIT_DDR) {
			dbg("!!!Enter 4 Bit DDR mode.!!!\n");
			/* Set the card to use 4 bit DDR*/
			err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
					EXT_CSD_BUS_WIDTH,
					EXT_CSD_BUS_WIDTH_4_DDR);

			if (err)
				return err;

			mmc_set_bus_width(mmc, MMC_BUS_WIDTH_4_DDR);
		} else if (mmc->card_caps & MMC_MODE_8BIT) {
			/* Set the card to use 8 bit*/
			err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
					EXT_CSD_BUS_WIDTH,
					EXT_CSD_BUS_WIDTH_8);

			if (err)
				return err;

			mmc_set_bus_width(mmc, MMC_BUS_WIDTH_8);
		} else if (mmc->card_caps & MMC_MODE_4BIT) {
			/* Set the card to use 4 bit*/
			err = mmc_switch(mmc, EXT_CSD_CMD_SET_NORMAL,
					EXT_CSD_BUS_WIDTH,
					EXT_CSD_BUS_WIDTH_4);

			if (err)
				return err;

			mmc_set_bus_width(mmc, MMC_BUS_WIDTH_4);
		}

		if (mmc->card_caps & (MMC_MODE_HS | MMC_MODE_HS_52MHz_DDR_12V |
						MMC_MODE_HS_52MHz_DDR_18_3V)) {
if (strncmp(mmc->name, "S5P_MSHC", 8) == 0) {
		printf("NAME: %s\n", mmc->name);
#ifdef CONFIG_EXYNOS4412_EVT1
			mmc_set_clock(mmc, 50000000);
#elif CONFIG_CPU_EXYNOS5250_EVT1
			mmc_set_clock(mmc, 52000000);
#else
			mmc_set_clock(mmc, 40000000);
#endif
} else {
			mmc_set_clock(mmc, 52000000);
}
		} else {
			mmc_set_clock(mmc, 20000000);
		}
	}

	/* fill in device description */
	mmc->block_dev.lun = 0;
	mmc->block_dev.type = 0;
	mmc->block_dev.blksz = mmc->read_bl_len;
	mmc->block_dev.log2blksz = LOG2(mmc->block_dev.blksz);
	mmc->block_dev.lba = lldiv(mmc->capacity, mmc->read_bl_len);
	sprintf(mmc->block_dev.vendor, "Man %06x Snr %08x", mmc->cid[0] >> 8,
			(mmc->cid[2] << 8) | (mmc->cid[3] >> 24));
	sprintf(mmc->block_dev.product, "%c%c%c%c%c", mmc->cid[0] & 0xff,
			(mmc->cid[1] >> 24), (mmc->cid[1] >> 16) & 0xff,
			(mmc->cid[1] >> 8) & 0xff, mmc->cid[1] & 0xff);
	sprintf(mmc->block_dev.revision, "%d.%d", mmc->cid[2] >> 28,
			(mmc->cid[2] >> 24) & 0xf);
	init_part(&mmc->block_dev);

#ifdef CONFIG_CMD_MOVINAND
	init_raw_area_table(&mmc->block_dev, 0);
#endif
	return 0;
}

int mmc_send_if_cond(struct mmc *mmc)
{
	struct mmc_cmd cmd;
	int err;

	cmd.cmdidx = SD_CMD_SEND_IF_COND;
	/* We set the bit if the host supports voltages between 2.7 and 3.6 V */
	cmd.cmdarg = ((mmc->voltages & 0xff8000) != 0) << 8 | 0xaa;
	cmd.resp_type = MMC_RSP_R7;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);

	if (err)
		return err;

	if ((cmd.response[0] & 0xff) != 0xaa)
		return UNUSABLE_ERR;
	else
		mmc->version = SD_VERSION_2;

	return 0;
}

int mmc_register(struct mmc *mmc)
{
	/* Setup the universal parts of the block interface just once */
	mmc->block_dev.if_type = IF_TYPE_MMC;
	mmc->block_dev.dev = cur_dev_num++;
	mmc->block_dev.removable = 1;
	mmc->block_dev.block_read = mmc_bread;
	mmc->block_dev.block_write = mmc_bwrite;

	INIT_LIST_HEAD (&mmc->link);

	list_add_tail (&mmc->link, &mmc_devices);

	return 0;
}

block_dev_desc_t *mmc_get_dev(int dev)
{
	struct mmc *mmc = find_mmc_device(dev);

	return mmc ? &mmc->block_dev : NULL;
}

int mmc_init(struct mmc *mmc)
{
	int err;

	err = mmc->init(mmc);

	if (err)
		return err;

	mmc_set_clock(mmc, 1);
	mmc_set_bus_width(mmc, MMC_BUS_WIDTH_1);

	/* Reset the Card */
	err = mmc_go_idle(mmc);

	if (err)
		return err;

	/* Test for SD version 2 */
	err = mmc_send_if_cond(mmc);

	/* Now try to get the SD card's operating condition */
	err = sd_send_op_cond(mmc);

	/* If the command timed out, we check for an MMC card */
	if (err == TIMEOUT) {
		err = mmc_send_op_cond(mmc);

		if (err) {
			return UNUSABLE_ERR;
		}
	}

	return mmc_startup(mmc);
}

/*
 * CPU and board-specific MMC initializations.  Aliased function
 * signals caller to move on
 */
static int __def_mmc_init(bd_t *bis)
{
	return -1;
}

int cpu_mmc_init(bd_t *bis) __attribute__((weak, alias("__def_mmc_init")));
int board_mmc_init(bd_t *bis) __attribute__((weak, alias("__def_mmc_init")));

void print_mmc_devices(char separator)
{
	struct mmc *m;
	struct list_head *entry;

	list_for_each(entry, &mmc_devices) {
		m = list_entry(entry, struct mmc, link);

		printf("%s: %d", m->name, m->block_dev.dev);

		if (entry->next != &mmc_devices)
			printf("%c ", separator);
	}

	printf("\n");
}

int mmc_initialize(bd_t *bis)
{
	struct mmc *mmc;
	int err, dev;
	
	INIT_LIST_HEAD (&mmc_devices);
	cur_dev_num = 0;

	if (board_mmc_init(bis) < 0)
		cpu_mmc_init(bis);

#if defined(DEBUG_MMC)
	print_mmc_devices(',');
#endif
	for (dev = 0; dev < MMC_MAX_CHANNEL; dev++) {
		mmc = find_mmc_device(dev);
		if (mmc) {
			err = mmc_init(mmc);
			if (err)
				err = mmc_init(mmc);
		} else {
			/* Can not find no more channels */
			break;
		}
		printf("MMC Device %d: %d MB\n", dev, (mmc->capacity/(1024*1024/mmc->read_bl_len)));
	}
	return err;
}

int mmc_erase(struct mmc *mmc, int part, u32 start, u32 block)
{
	int err, erase_time;
	u32 count, dis, blk_hc;
	struct mmc_cmd cmd;

	printf("START: %d BLOCK: %d\n", start, block);
	printf("high_capacity: %d\n", mmc->high_capacity);
	printf("Capacity: %d\n", mmc->capacity);

	/* ERASE boot partition */
	if (part == 0) {
		/* Boot ack enable, boot partition enable , boot partition access */
		cmd.cmdidx = MMC_CMD_SWITCH;
		cmd.resp_type = MMC_RSP_R1b;
		cmd.cmdarg = ((3<<24)|(179<<16)|(((1<<6)|(1<<3)|(1<<0))<<8));
		cmd.flags = 0;

		err = mmc_send_cmd(mmc, &cmd, NULL);
		if (err)
			return err;
	}


	/* Byte addressing */
	if (mmc->high_capacity == 0) {
		start = start * 512;
		block = block * 512;
	} else {
		if (!IS_SD(mmc)) {
			blk_hc = block;
		/* MMC High Capacity erase minimum size is 512KB */
			if (block < 1024) {
				if (block < 512)
					block = 1;
				else
					block = 2;
			} else {
				if (0 == (block%1024)) {
					block = (block / 1024);
				} else {
					block = (block / 1024) + 1;
				}
			}
		}
	}

	/* Set ERASE start group */
	if (IS_SD(mmc)) {
		cmd.cmdidx = 32;
	} else {
		cmd.cmdidx = 35;
	}
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = start;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	/* Set ERASE start group */
	if (IS_SD(mmc)) {
		cmd.cmdidx = 33;
	} else {
		cmd.cmdidx = 36;
	}
	cmd.resp_type = MMC_RSP_R1;
	cmd.cmdarg = (start + block);
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	/* ERASE */
	cmd.cmdidx = 38;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = 0x0;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	/* Byte addressing */
	if (mmc->high_capacity == 0) {
		start = start / 512;
		block = block / 512;
		erase_time = block;
	} else {
		if (!IS_SD(mmc)) {
			erase_time = blk_hc;
		} else {
			erase_time = block;
		}
	}
	if (erase_time < 2048*1024) {
		dis = 1;
	} else {
		dis = 100;
	}
	printf("\nErase\n");
	for (count = 1; count < erase_time ; count++) {

		if (!(count%(100*dis))) {
			printf(".");
		}
		if (!(count%(4000*dis))) {
			printf("\n");
		}
	}

	if (mmc->high_capacity && !IS_SD(mmc)) {
		printf("\n\t\t\t*** NOTICE ***\n");
		printf("*** High Capacity(higher than 2GB) MMC's erase "
		"minimum size is 512KB ***\n");
		if (block < 2) {
			printf("\n %d KB erase Done\n", block*512);
		} else if ((block >= 2)&&(block < 2048)){
			printf("\n %d.%d MB erase Done\n", (block/2),
			(block%2)*5);
		} else {
			printf("\n %d.%d GB erase Done\n",
			(block/2048),
			((block*1000)/2048) -
			((block/2048)*1000));
		}
	} else {
		if (block < 2) {
			printf("\n %d B erase Done\n", block*512);
		} else if ((block >= 2)&&(block < 2048)){
			printf("\n %d KB erase Done\n", (block/2));
		} else if ((block >= 2048)&&(block < (2048 * 1024))){
			printf("\n %d.%d MB erase Done\n",
			(block/2048),
			((block*1000)/2048) -
			((block/2048)*1000));
		} else {
			printf("\n %d.%d GB erase Done\n",
			(block/(2048*1024)),
			((block*10)/(2048*1024)) -
			((block/(2048*1024))*10));
		}
	}
	/* ERASE boot partition */
	if (part == 0) {
		/* Boot ack enable, boot partition enable , boot partition access */
		cmd.cmdidx = MMC_CMD_SWITCH;
		cmd.resp_type = MMC_RSP_R1b;
		cmd.cmdarg = ((3<<24)|(179<<16)|(((1<<6)|(1<<3)|(0<<0))<<8));
		cmd.flags = 0;

		err = mmc_send_cmd(mmc, &cmd, NULL);
		if (err)
			return err;
	}
	return 0;
}

void feedback_delay(struct mmc *mmc, int count)
{
#if !defined(CONFIG_S5P_MSHC)
	unsigned int ctrl2, ctrl3;

	ctrl2 = readl(mmc->ioaddr + S3C_SDHCI_CONTROL2);
	ctrl3 = readl(mmc->ioaddr + S3C_SDHCI_CONTROL3);
	ctrl2 &= ~(S3C_SDHCI_CTRL2_ENFBCLKTX | S3C_SDHCI_CTRL2_ENFBCLKRX);
	ctrl3 &= ~(1 << 31 | 1 << 23 | 1 << 15 | 1 << 7);

	switch(count)
	{
	case 1:
		/* Tx: Inverter delay / Rx: Inverter delay */
		printf("# Tx: Inverter delay / Rx: Inverter delay\n");
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKTX | S3C_SDHCI_CTRL2_ENFBCLKRX);
		break;
	case 2:
		/* Tx: Basic delay / Rx: Inverter delay */
		printf("## Tx: Basic delay / Rx: Inverter delay\n");
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKTX | S3C_SDHCI_CTRL2_ENFBCLKRX);
		ctrl3 |= (1 << 31 | 1 << 23 | 0 << 15 | 0 << 7);
		break;
	case 3:
		/* Tx: Inverter delay / Rx: Basic delay */
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKTX | S3C_SDHCI_CTRL2_ENFBCLKRX);
		printf("## Tx: Inverter delay / Rx: Basic delay\n");
		ctrl3 |= (0 << 31 | 0 << 23 | 1 << 15 | 1 << 7);
		break;
	case 4:
		/* Tx: Basic delay / Rx: Basic delay */
		printf("### Tx: Basic delay / Rx: Basic delay\n");
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKTX | S3C_SDHCI_CTRL2_ENFBCLKRX);
		ctrl3 |= (1 << 31 | 1 << 23 | 1 << 15 | 1 << 7);
		break;
	case 5:
		/* Tx: Disable / Rx: Basic delay */
		printf("# Tx: Disable / Rx: Basic delay\n");
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKRX);
		ctrl3 |= (1 << 15 | 1 << 7);
		break;
	case 6:
		/* Tx: Disable / Rx: Inverter delay */
		printf("## Tx: Disable / Rx: Inverter delay\n");
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKRX);
		ctrl3 |= (0 << 15 | 0 << 7);
		break;
	case 7:
		/* Tx: Basic delay / Rx: Disable */
		printf("### Tx: Basic delay / Rx: Disable\n");
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKTX);
		ctrl3 |= (1 << 31 | 1 << 23);
		break;
	case 8:
		/* Tx: Inverter delay / Rx: Disable */
		printf("### Tx: Inverter delay / Rx: Disable\n");
		ctrl2 |= (S3C_SDHCI_CTRL2_ENFBCLKTX);
		ctrl3 |= (0 << 31 | 0 << 23);
		break;
	default:
		/* Tx: Inverter delay / Rx: Inverter delay */
		dbg("Tx: Inverter delay / Rx: Inverter delay\n");
		printf("Tx: Inverter delay / Rx: Inverter delay\n");
		break;
	}
	writel(ctrl2, mmc->ioaddr + S3C_SDHCI_CONTROL2);
	writel(ctrl3, mmc->ioaddr + S3C_SDHCI_CONTROL3);
	udelay(20000);
#endif
}

int emmc_boot_partition_size_change(struct mmc *mmc, u32 bootsize, u32 rpmbsize)
{
	int err;
	struct mmc_cmd cmd;

	/* Only use this command for raw eMMC moviNAND */
	/* Enter backdoor mode */
	cmd.cmdidx = 62;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = 0xefac62ec;
	cmd.flags = 0;
	
	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;
	
	/* Boot partition changing mode */
	cmd.cmdidx = 62;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = 0xcbaea7;
	cmd.flags = 0;
	
	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	bootsize = ((bootsize*1024)/128);

	/* Arg: boot partition size */
	cmd.cmdidx = 62;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = bootsize;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	rpmbsize = ((rpmbsize*1024)/128);

	/* Arg: RPMB partition size */
	cmd.cmdidx = 62;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = rpmbsize;
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;



	return 0;	
}
int emmc_boot_open(struct mmc *mmc)
{
	int err;
	struct mmc_cmd cmd;

	/* Boot ack enable, boot partition enable , boot partition access */
	cmd.cmdidx = MMC_CMD_SWITCH;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = ((3<<24)|(179<<16)|(((1<<6)|(1<<3)|(1<<0))<<8));
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	/* 4bit transfer mode at booting time. */
	cmd.cmdidx = MMC_CMD_SWITCH;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = ((3<<24)|(177<<16)|((1<<0)<<8));
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	return 0;
}

int emmc_boot_close(struct mmc *mmc)
{
	int err;
	struct mmc_cmd cmd;

	/* Boot ack enable, boot partition enable , boot partition access */
	cmd.cmdidx = MMC_CMD_SWITCH;
	cmd.resp_type = MMC_RSP_R1b;
	cmd.cmdarg = ((3<<24)|(179<<16)|(((1<<6)|(1<<3)|(0<<0))<<8));
	cmd.flags = 0;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		return err;

	return 0;
}

