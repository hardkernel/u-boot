/*
 * Copyright 2008, Freescale Semiconductor, Inc
 * Andy Fleming
 *
 * Based vaguely on the Linux code
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <config.h>
#include <common.h>
#include <part.h>
#include "mmc_private.h"
#include <malloc.h>

extern bool emmckey_is_access_range_legal(struct mmc *mmc,
		ulong start, lbaint_t blkcnt);

static ulong mmc_erase_t(struct mmc *mmc, ulong start, lbaint_t blkcnt)
{
	struct mmc_cmd cmd;
	ulong end;
	int err, start_cmd, end_cmd;

	if (mmc->high_capacity) {
		end = start + blkcnt - 1;
	} else {
		end = (start + blkcnt - 1) * mmc->write_bl_len;
		start *= mmc->write_bl_len;
	}
	printf("start = %lu,end = %lu\n",start,end);
	if (IS_SD(mmc)) {
		start_cmd = SD_CMD_ERASE_WR_BLK_START;
		end_cmd = SD_CMD_ERASE_WR_BLK_END;
	} else {
		start_cmd = MMC_CMD_ERASE_GROUP_START;
		end_cmd = MMC_CMD_ERASE_GROUP_END;
	}

	cmd.cmdidx = start_cmd;
	cmd.cmdarg = start;
	cmd.resp_type = MMC_RSP_R1;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		goto err_out;

	cmd.cmdidx = end_cmd;
	cmd.cmdarg = end;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		goto err_out;

	cmd.cmdidx = MMC_CMD_ERASE;
	cmd.cmdarg = SECURE_ERASE;
	cmd.resp_type = MMC_RSP_R1b;

	err = mmc_send_cmd(mmc, &cmd, NULL);
	if (err)
		goto err_out;

	return 0;

err_out:
	puts("mmc erase failed\n");
	return err;
}

unsigned long mmc_berase_becalled(int dev_num, lbaint_t start, lbaint_t blkcnt)
{
	int err = 0;
	struct mmc *mmc = find_mmc_device(dev_num);
	int timeout = 1000;

	if (!mmc)
		return -1;

	err = mmc_erase_t(mmc, start, blkcnt);
	if (err)
		return 1;

	/* Waiting for the ready status */
	if (mmc_send_status(mmc, timeout))
		return 1;

	return 0;
}

/*
 * Function: Zero out blk_len blocks at the blk_addr by writing zeros. The
 *           function can be used when we want to erase the blocks not
 *           aligned with the mmc erase group.
 * Arg     : Block address & length
 * Return  : Returns 0
 * Flow    : Erase the card from specified addr
 */

static uint32_t mmc_zero_out(int dev_num, uint32_t blk_addr, uint32_t num_blks)
{
	uint32_t erase_size = (512 * num_blks);
	uint32_t *out = malloc(erase_size);

	if (out == NULL) {
		printf("mmc zero out: malloc fail\n");
		return 1;
	}
	memset((void *)out, 0, erase_size);

	/* Flush the data to memory before writing to storage */

	if (mmc_bwrite(dev_num, blk_addr, num_blks, out) != num_blks)
	{
		printf("failed to erase the block: %x\n", blk_addr);
		free(out);
		return 1;
	}
	free(out);
	return 0;
}

/*
 * Function: mmc erase
 * Arg     : Block address & length
 * Return  : Returns 0
 * Flow    : Erase the card from specified addr
 */
unsigned long mmc_berase(int dev_num, lbaint_t start, lbaint_t blkcnt)
{
	struct mmc *mmc;
	uint32_t unaligned_blks;
	uint32_t head_unit;
	uint32_t tail_unit;
	uint32_t erase_unit_sz;
	uint64_t blks_to_erase;


	mmc = find_mmc_device(dev_num);

	if (!emmckey_is_access_range_legal(mmc, start, blkcnt))
		return blkcnt;

	if (blkcnt == 0) {

		blkcnt = mmc->capacity/512 - (mmc->capacity/512)% mmc->erase_grp_size; // erase whole
		printf("blkcnt = %lu\n",blkcnt);

		if (mmc_berase_becalled(dev_num, start, blkcnt))
			return 1;
	}

	erase_unit_sz = mmc->erase_grp_size;
	head_unit = start / erase_unit_sz;
	tail_unit = (start + blkcnt - 1) / erase_unit_sz;

	if (tail_unit - head_unit <= 1)
	{
		return mmc_zero_out(dev_num, start, blkcnt);
	}

	unaligned_blks = erase_unit_sz - (start % erase_unit_sz);

	if (unaligned_blks < erase_unit_sz)
	{
		if (mmc_zero_out(dev_num, start, unaligned_blks))
			return 1;

		start += unaligned_blks;
		blkcnt -= unaligned_blks;

		head_unit = start / erase_unit_sz;
		tail_unit = (start + blkcnt - 1) / erase_unit_sz;

		if (tail_unit - head_unit <= 1)
		{
			return mmc_zero_out(dev_num, start, blkcnt);
		}
	}

	unaligned_blks = blkcnt % erase_unit_sz;
	blks_to_erase = blkcnt - unaligned_blks;

	if (mmc_berase_becalled(dev_num, start, blks_to_erase))
	{
		printf("MMC erase failed\n");
		return 1;
	}

	start += blks_to_erase;

	if (unaligned_blks)
	{
		if (mmc_zero_out(dev_num, start, unaligned_blks))
			return 1;
	}


	return 0;
}

static ulong mmc_write_blocks(struct mmc *mmc, lbaint_t start,
		lbaint_t blkcnt, const void *src)
{
	struct mmc_cmd cmd;
	struct mmc_data data;
	int timeout = 1000;
	int ret;

	if ((start + blkcnt) > mmc->block_dev.lba) {
		printf("MMC: block number 0x" LBAF " exceeds max(0x" LBAF ")\n",
		       start + blkcnt, mmc->block_dev.lba);
		return 0;
	}

	if (blkcnt == 0)
		return 0;
	else if (blkcnt == 1)
		cmd.cmdidx = MMC_CMD_WRITE_SINGLE_BLOCK;
	else
		cmd.cmdidx = MMC_CMD_WRITE_MULTIPLE_BLOCK;

	if (mmc->high_capacity)
		cmd.cmdarg = start;
	else
		cmd.cmdarg = start * mmc->write_bl_len;

	cmd.resp_type = MMC_RSP_R1;

	data.src = src;
	data.blocks = blkcnt;
	data.blocksize = mmc->write_bl_len;
	data.flags = MMC_DATA_WRITE;

	ret = mmc_send_cmd(mmc, &cmd, &data);
	if (ret)
		printf("mmc write failed\n");
	/* SPI multiblock writes terminate using a special
	 * token, not a STOP_TRANSMISSION request.
	 */
	if (!mmc_host_is_spi(mmc) && blkcnt > 1) {
		cmd.cmdidx = MMC_CMD_STOP_TRANSMISSION;
		cmd.cmdarg = 0;
		cmd.resp_type = MMC_RSP_R1b;
		if (mmc_send_cmd(mmc, &cmd, NULL)) {
			printf("mmc fail to send stop cmd\n");
			return 0;
		}
	}
	if (ret)
		return 0;

	/* Waiting for the ready status */
	if (mmc_send_status(mmc, timeout))
		return 0;

	return blkcnt;
}

ulong mmc_bwrite(int dev_num, lbaint_t start, lbaint_t blkcnt, const void *src)
{
	lbaint_t cur, blocks_todo = blkcnt;

	struct mmc *mmc = find_mmc_device(dev_num);
	if (!mmc)
		return 0;

	if (!emmckey_is_access_range_legal(mmc, start, blkcnt))
		return 0;

	if (mmc_set_blocklen(mmc, mmc->write_bl_len))
		return 0;

	do {
		cur = (blocks_todo > mmc->cfg->b_max) ?
			mmc->cfg->b_max : blocks_todo;
		if (mmc_write_blocks(mmc, start, cur, src) != cur)
			return 0;
		blocks_todo -= cur;
		start += cur;
		src += cur * mmc->write_bl_len;
	} while (blocks_todo > 0);

	return blkcnt;
}

extern int aml_sd_send_cmd_ffu(struct mmc *mmc, struct mmc_cmd *cmd, struct mmc_data *data);
ulong mmc_ffu_write(int dev_num, lbaint_t start, lbaint_t blkcnt, const void *src)
{
	struct mmc_cmd cmd;
	struct mmc_data data;
	int ret, timeout = 1000;
	struct mmc *mmc = find_mmc_device(dev_num);
	if (!mmc || !blkcnt)
		return 0;

	printf("mmc ffu start = %lx, cnt = %lx, addr = %p\n", start, blkcnt, src);

	cmd.cmdidx = MMC_CMD_SET_BLOCK_COUNT;
	cmd.cmdarg = blkcnt & 0xFFFF;
	cmd.resp_type = MMC_RSP_R1;
	ret = mmc_send_cmd(mmc, &cmd, NULL);
	if (ret) {
		printf("mmc set blkcnt failed\n");
		return 0;
	}

	cmd.cmdidx = MMC_CMD_WRITE_MULTIPLE_BLOCK;
	cmd.cmdarg = start;
	cmd.resp_type = MMC_RSP_R1b;

	data.src = src;
	data.blocks = blkcnt;
	data.blocksize = mmc->write_bl_len;
	data.flags = MMC_DATA_WRITE;

	ret = aml_sd_send_cmd_ffu(mmc, &cmd, &data);
	if (ret) {
		printf("mmc write failed\n");
		return 0;
	}

	/* Waiting for the ready status */
	if (mmc_send_status(mmc, timeout))
		return 0;

	return blkcnt;
}
