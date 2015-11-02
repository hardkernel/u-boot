
/*****************************************************************
**
**  Copyright (C) 2012 Amlogic,Inc.  All rights reserved
**
**        Filename : chip_operation.c
**        Revision : 1.001
**        Author: Benjamin Zhao
**        Description:
**chip operation function,  contains read/write/erase, and bad block function.
**mainly init nand phy driver.
**
*****************************************************************/
#include "../include/phynand.h"

static int _read_page_single_plane(struct amlnand_chip *aml_chip,
	u8 chipnr,
	u32 page_addr);

static int check_cmdfifo_size(struct hw_controller *controller)
{
	int time_out_cnt = 0, retry_cnt = 0;

RETRY:
	do {
		if (NFC_CMDFIFO_SIZE(controller) <= 0)
			break;
	} while (time_out_cnt++ <= AML_DMA_BUSY_TIMEOUT);

	if (time_out_cnt >= AML_DMA_BUSY_TIMEOUT) {
		if (retry_cnt++ > 3) {
			aml_nand_msg("check cmdfifo size timeout!");
			return -NAND_FAILED;
		} else {
			aml_nand_dbg("check cmdfifo size timeout retry_cnt:%d",
				retry_cnt);
			udelay(10);
			goto RETRY;
		}
	}
	return NAND_SUCCESS;
}


/************************************************************
 * nand_check_wp - [GENERIC] check if the chip is write protected
 * Check, if the chip is write protected.
 * First of all, check controller->option, then  read status, check nand status
 *
 *************************************************************/
static int check_wp(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int i, time_out_cnt = 0;

	/* force WP for readonly add for shutdown protect */
	if (controller->option & NAND_CTRL_FORCE_WP) {
		aml_nand_msg("check force WP here");
		return -NAND_WP_FAILURE;
	}

	/* Check the WP bit */
	for (i = 0; i < controller->chip_num; i++) {
		controller->select_chip(controller, i);
		/* read status */
		controller->cmd_ctrl(controller, NAND_CMD_STATUS,
			NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE);
		NFC_SEND_CMD_IDLE(controller, 0);
		NFC_SEND_CMD_IDLE(controller, 0);
		do {
			if (NFC_CMDFIFO_SIZE(controller) <= 0)
				break;
			udelay(2);
		} while (time_out_cnt++ <= AML_NAND_READ_BUSY_TIMEOUT);

		if (time_out_cnt >= AML_NAND_READ_BUSY_TIMEOUT) {
			aml_nand_msg("cmd fifo size failed to clear!");
			aml_nand_msg("NFC_CMDFIFO_SIZE():%d" ,
				NFC_CMDFIFO_SIZE(controller));
			return -NAND_CMD_FAILURE;
		}

		if (controller->readbyte(controller) & NAND_STATUS_WP)
			return -NAND_WP_FAILURE;
	}

	return 0;
}

static int ecc_read_retry_handle(struct amlnand_chip *aml_chip,
	u8 chipnr,
	u8 *tmp_buf,
	u8 user_byte_num,
	u32 page_size,
	u8 slc_mode,
	u8 up_page)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct read_retry_info *retry_info = &(controller->retry_info);
	u8 need_retry;
	u8 *retry_cnt;
	int retry_op_cnt, retry_cnt_lp, retry_cnt_up, ret;

	retry_op_cnt = retry_cnt_lp = retry_info->retry_cnt_lp;
	retry_cnt_up = retry_info->retry_cnt_up;
	retry_cnt = &aml_chip->g_retry_cnt;

	if ((flash->new_type == HYNIX_20NM_8GB)
		|| (flash->new_type == HYNIX_20NM_4GB)
		|| (flash->new_type == HYNIX_1YNM))
		retry_op_cnt = retry_info->retry_cnt_lp *
			retry_info->retry_cnt_lp;

	/* get usr bytes */
	controller->get_usr_byte(controller, tmp_buf, user_byte_num);
	ret = controller->hwecc_correct(controller, page_size, tmp_buf);
	if (ret ==  NAND_ECC_FAILURE) {
		/* check rand_mode and 0xff page */
		if (controller->zero_cnt < controller->ecc_max)
			return RETURN_PAGE_ALL_0XFF;
		/* ecc fail */
		need_retry = 0;
		if (retry_info->flag && (slc_mode == 0)) {
			if ((flash->new_type != SANDISK_19NM)
				&& ((*retry_cnt)++ < retry_op_cnt)) {
				need_retry = 1;
			} else if (flash->new_type == SANDISK_19NM) {
				if (up_page) {
					if ((*retry_cnt)++ < retry_cnt_up)
						need_retry = 1;
				} else if ((*retry_cnt)++ < retry_cnt_lp)
					need_retry = 1;
			}
			if (need_retry) {
				aml_nand_dbg("read retry");
				aml_nand_dbg("chip:%d cnt:%d",
					chipnr,
					*retry_cnt);
				ret = retry_info->handle(controller, chipnr);
				if (ret < 0) {
					aml_nand_msg("read retry");
					aml_nand_msg("fail at plane0_page");
				}
				/* next round */
				return RETURN_PAGE_NEED_READRETRY;
			}
		}
		ret = -1;
	} else {
	if ((*retry_cnt)) {
		if (flash->new_type != SANDISK_19NM) {
			if ((*retry_cnt) > (retry_op_cnt-2)) {
				aml_nand_dbg("detect bitflip page:%d",
					page_addr);
				ops_para->bit_flip++;
			}
		} else {
			if (up_page) {
				if ((*retry_cnt) > (retry_cnt_up-2)) {
					aml_nand_dbg("detect bitflip page:%d",
						page_addr);
					ops_para->bit_flip++;
				}
			} else {
				if ((*retry_cnt) > (retry_cnt_lp-2)) {
					aml_nand_dbg("detect bitflip page:%d",
						page_addr);
					ops_para->bit_flip++;
				}
			}
		}
	} else if ((controller->ecc_cnt_cur > controller->ecc_cnt_limit)
		&& (flash->new_type == 0)) {
		aml_nand_dbg("detect bitflip page:%d, chip:%d",
			page_addr,
			chipnr);
		ops_para->bit_flip++;
	}
	ret = 0;
	}
	/*  exit after all retry effort */
	if ((*retry_cnt) && retry_info->exit) {
		ret |= retry_info->exit(controller, chipnr);
		if (ret < 0) {
			aml_nand_msg("retry exit failed");
			aml_nand_msg("flash->new_type:%d, cnt:%d",
				flash->new_type,
				*retry_cnt);
		}
	}
	/* zero retry... */
	*retry_cnt = 0;
	return ret;
}

#if (AML_CFG_2PLANE_READ_EN)
static int read_page_two_plane(struct amlnand_chip *aml_chip,
	u8 chipnr,
	u32 plane0_page_addr,
	u32 plane1_page_addr)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	u8 *buf = ops_para->data_buf;
	u8 *tmp_buf = controller->oob_buf;
	u32 pages_per_blk_shift;
	u32 page_size, page_addr, tmp_page;
	u32 page0_addr, page1_addr;
	u8 plane0_retry_flag = 0, all_ff_flag = 0;
	u8 bch_mode, user_byte_num, slc_mode, up_page = 0;
	int ret = 0;
	int new_oob = 0;
	PHY_NAND_LINE
	page0_addr = plane0_page_addr;
	page1_addr = plane1_page_addr;
	page_addr = ops_para->page_addr;
	pages_per_blk_shift =
		(controller->block_shift - controller->page_shift);

	if ((controller->oob_mod) && (ops_para->oob_buf)
		&& (!ops_para->data_buf))
		new_oob = 1;
	PHY_NAND_LINE
	/* for ecc mode */
	if ((ops_para->option & DEV_ECC_SOFT_MODE)
		|| (controller->bch_mode == NAND_ECC_NONE)) {
		bch_mode = NAND_ECC_NONE;
		page_size = flash->pagesize + flash->oobsize;
		user_byte_num = flash->oobsize;
	} else {
		bch_mode = controller->bch_mode;
		user_byte_num = controller->ecc_steps * controller->user_mode;
		page_size = controller->ecc_steps * controller->ecc_unit;
	}

	if (new_oob)
		page_size = controller->ecc_unit;

	if (ops_para->option & DEV_SLC_MODE) {
		/* aml_nand_dbg("enable SLC mode"); */
		if (flash->new_type == SANDISK_19NM)
			slc_mode = 1;
		else if ((flash->new_type > 0) && (flash->new_type < 10))
			slc_mode = 2;
		else
			slc_mode = 0;
	} else {
		slc_mode = 0;
		if (flash->new_type == SANDISK_19NM) {
			tmp_page = page_addr % (1 << pages_per_blk_shift);
			if (((tmp_page % 2 == 0)
				&& (tmp_page != 0))
				|| (tmp_page == ((1 << pages_per_blk_shift)-1)))
				up_page = 1;
			else
				up_page = 0;
		}
	}
	/* setting global retry_cnt to 0 */
	aml_chip->g_retry_cnt = 0;
	PHY_NAND_LINE
	ret = controller->quene_rb(controller, chipnr);
	if (ret) {
		aml_nand_msg("quene rb busy here");
		goto error_exit0;
	}
	PHY_NAND_LINE
RETRY_PLANE_CMD:
	if ((controller->mfr_type == NAND_MFR_MICRON)
		|| (controller->mfr_type == NAND_MFR_INTEL)) {
		/* plane0 */
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page0_addr, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page0_addr>>8, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page0_addr>>16, NAND_CTRL_ALE);
		PHY_NAND_LINE
		controller->cmd_ctrl(controller, 0x32, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
		ret = controller->quene_rb(controller, chipnr);
		if (ret)
			aml_nand_msg("send 0x32 cmd Rb  failed\n");
		PHY_NAND_LINE
		/* plane1 */
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr>>8, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr>>16, NAND_CTRL_ALE);
		/* read start */
		controller->cmd_ctrl(controller, 0x30, NAND_CTRL_CLE);

	} else {
		PHY_NAND_LINE
		/* plane0 */
		controller->cmd_ctrl(controller, 0x60, NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, page0_addr, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page0_addr>>8, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page0_addr>>16, NAND_CTRL_ALE);
		/* plane1 */
		controller->cmd_ctrl(controller, 0x60, NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, page1_addr, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr>>8, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr>>16, NAND_CTRL_ALE);
		/* read start */
		controller->cmd_ctrl(controller, 0x30, NAND_CTRL_CLE);

		/* NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE); */
	}
	PHY_NAND_LINE
	/* wait twb here */
	NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
	if (check_cmdfifo_size(controller)) {
		aml_nand_msg("check cmdfifo size timeout");
		BUG();
	}
	PHY_NAND_LINE
	ret = controller->quene_rb(controller, chipnr);
	if (ret) {
		aml_nand_msg("quene rb busy here");
		goto error_exit0;
	}
	PHY_NAND_LINE
	if (controller->option & NAND_CTRL_NONE_RB) {
		controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
	}
	PHY_NAND_LINE
	if ((controller->mfr_type == NAND_MFR_MICRON)
		|| (controller->mfr_type == NAND_MFR_INTEL)) {
		PHY_NAND_LINE
		if (plane0_retry_flag == 0) {
			PHY_NAND_LINE
			controller->page_addr = page0_addr;
			ret = controller->dma_read(controller,
				page_size,
				bch_mode);
			if (ret) {
				aml_nand_msg("quene dma busy here");
				BUG();
				goto error_exit0;
			}
			PHY_NAND_LINE
			all_ff_flag = 0;
			/* for ecc soft mode */
			if (bch_mode != NAND_ECC_NONE) {
				PHY_NAND_LINE
				ret = ecc_read_retry_handle(aml_chip,
					chipnr,
					tmp_buf,
					user_byte_num,
					page_size,
					slc_mode,
					up_page);
				if (ret == RETURN_PAGE_ALL_0XFF) {
					PHY_NAND_LINE
					all_ff_flag = 1;
				} else if (ret == RETURN_PAGE_NEED_READRETRY) {
					PHY_NAND_LINE
					goto RETRY_PLANE_CMD;
				} else if (ret < 0) {
					aml_nand_msg("uncorrect ecc here!");
					aml_nand_msg("at page:%d,pl0 chip:%d",
						page_addr,
						chipnr);
					ops_para->ecc_err++;

				}
				plane0_retry_flag = 1;
			}
			if (ops_para->data_buf) {
				if (all_ff_flag) {
					memset(buf, 0xff, page_size);
				} else {
					memcpy(buf,
						controller->data_buf,
						page_size);
				}
				buf += page_size;
			}
			if (ops_para->oob_buf) {
				if (all_ff_flag)
					memset(tmp_buf, 0xff, user_byte_num);

				tmp_buf += user_byte_num;
			}
			all_ff_flag = 0;
		}
		if (new_oob)
			goto new_oob_mod;
		controller->cmd_ctrl(controller, 0x06, NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr>>8, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr>>16, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, 0xe0, NAND_CTRL_CLE);
		PHY_NAND_LINE
		NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE);
		PHY_NAND_LINE
		controller->page_addr = page1_addr;
		ret = controller->dma_read(controller, page_size, bch_mode);
		if (ret) {
			aml_nand_msg("dma error here");
			BUG();
			goto error_exit0;
		}

		if (bch_mode != NAND_ECC_NONE) {
			PHY_NAND_LINE
			ret = ecc_read_retry_handle(aml_chip,
				chipnr,
				tmp_buf,
				user_byte_num,
				page_size,
				slc_mode,
				up_page);
			if (ret == RETURN_PAGE_ALL_0XFF) {
				all_ff_flag = 1;
			} else if (ret == RETURN_PAGE_NEED_READRETRY) {
				goto RETRY_PLANE_CMD;
			} else if (ret < 0) {
				aml_nand_msg("uncorrect ecc here");
				aml_nand_msg("at page:%d, pl1 chip:%d",
					page_addr,
					chipnr);
				ops_para->ecc_err++;

			}
			plane0_retry_flag = 0;
		}
	} else { /* not micron intel below */
		if (plane0_retry_flag == 0) {
			PHY_NAND_LINE
			controller->cmd_ctrl(controller, 0x00, NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, page0_addr,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, page0_addr>>8,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, page0_addr>>16,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, 0x05, NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, 0xe0, NAND_CTRL_CLE);

			NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE);
			PHY_NAND_LINE
			controller->page_addr = page0_addr;
			ret = controller->dma_read(controller,
				page_size,
				bch_mode);
			PHY_NAND_LINE
			if (ret) {
				aml_nand_msg("dma error here");
				BUG();
				goto error_exit0;
			}

			if (bch_mode != NAND_ECC_NONE) {
				ret = ecc_read_retry_handle(aml_chip,
					chipnr,
					tmp_buf,
					user_byte_num,
					page_size,
					slc_mode,
					up_page);
				if (ret == RETURN_PAGE_ALL_0XFF) {
					all_ff_flag = 1;
				} else if (ret == RETURN_PAGE_NEED_READRETRY) {
					goto RETRY_PLANE_CMD;
				} else if (ret < 0) {
					aml_nand_msg("NAND uncorrect ecc here");
					aml_nand_msg("at page:%d, pl0 chip:%d",
						page_addr,
						chipnr);
					ops_para->ecc_err++;

				}
				plane0_retry_flag = 1;
			}
			if (ops_para->data_buf) {
				if (all_ff_flag)
					memset(buf, 0xff, page_size);
				else
					memcpy(buf,
						controller->data_buf,
						page_size);
				buf += page_size;
			}
			if (ops_para->oob_buf) {
				if (all_ff_flag)
					memset(tmp_buf, 0xff, user_byte_num);

				tmp_buf += user_byte_num;
			}
			all_ff_flag = 0;
		}
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr>>8, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, page1_addr>>16, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, 0x05, NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, 0x00, NAND_CTRL_ALE);
		controller->cmd_ctrl(controller, 0xe0, NAND_CTRL_CLE);
		PHY_NAND_LINE
		NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE);
		PHY_NAND_LINE
		controller->page_addr = page1_addr;
		ret = controller->dma_read(controller, page_size, bch_mode);
		if (ret) {
			aml_nand_msg("dma error here");
			BUG();
			goto error_exit0;
		}
		PHY_NAND_LINE
		if (bch_mode != NAND_ECC_NONE) {
			ret = ecc_read_retry_handle(aml_chip,
				chipnr,
				tmp_buf,
				user_byte_num,
				page_size,
				slc_mode,
				up_page);
			if (ret == RETURN_PAGE_ALL_0XFF) {
				all_ff_flag = 1;
			} else if (ret == RETURN_PAGE_NEED_READRETRY) {
				goto RETRY_PLANE_CMD;
			} else if (ret < 0) {
				aml_nand_msg("NAND uncorrect ecc here");
				aml_nand_msg("at page:%d, pl1 chip:%d",
					page_addr,
					chipnr);
				ops_para->ecc_err++;

			}
			plane0_retry_flag = 0;
		}
	}
	if (ops_para->data_buf) {
		if (all_ff_flag)
			memset(buf, 0xff, page_size);
		else
			memcpy(buf, controller->data_buf, page_size);
		buf += page_size; /* fixme, why buffer plus here? */
	}

	if (ops_para->oob_buf) {
		if (all_ff_flag)
			memset(tmp_buf, 0xff, user_byte_num);
		tmp_buf += user_byte_num;
	}
	all_ff_flag = 0;

	if (check_cmdfifo_size(controller)) {
		aml_nand_msg("check cmdfifo size timeout");
		BUG();
	}
	PHY_NAND_LINE
new_oob_mod:
	if (ops_para->oob_buf) {
		memcpy(ops_para->oob_buf,
			controller->oob_buf,
			BYTES_OF_USER_PER_PAGE);
		if (ops_para->ecc_err)
			memset(ops_para->oob_buf, 0x22, BYTES_OF_USER_PER_PAGE);
	}
	PHY_NAND_LINE
	return NAND_SUCCESS;
error_exit0:
	return ret;
}
/* AML_CFG_2PLANE_READ_EN */
#else
/* using 2 single plane read simulate 2plane */
extern void _dump_mem_u8(uint8_t * buf, uint32_t len);
static int read_page_two_plane(struct amlnand_chip *aml_chip,
	u8 chipnr,
	u32 p0_addr,
	u32 p1_addr)
{
	int ret = 0;
	u32 page_size, user_byte_num, new_oob;
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);

	/* pointer for restore */
	u8* oob_buffer = controller->oob_buf;
	u8* data_buffer = ops_para->data_buf;

	new_oob = 0;

	/* for ecc mode */
	if ((ops_para->option & DEV_ECC_SOFT_MODE)
		|| (controller->bch_mode == NAND_ECC_NONE)) {
		page_size = flash->pagesize + flash->oobsize;
		user_byte_num = flash->oobsize;
	} else {
		user_byte_num = controller->ecc_steps * controller->user_mode;
		page_size = controller->ecc_steps * controller->ecc_unit;
	}

	if ((controller->oob_mod) && (ops_para->oob_buf)
		&& (!ops_para->data_buf))
		new_oob = 1;
	//printf("p0, oob %p, data %p\n", controller->oob_buf, ops_para->data_buf);

	ret = _read_page_single_plane(aml_chip, chipnr, p0_addr) ;
	if (new_oob)
		goto _out;
	//_dump_mem_u8(ops_para->data_buf, 128);
	/* move buffer ahead. */
	//printf("p0-, oob %p, data %p\n", controller->oob_buf, ops_para->data_buf);

	controller->oob_buf += user_byte_num; /* fixme, maybe not right!*/
	if (ops_para->data_buf)
	ops_para->data_buf += page_size;
	//printf("p1, oob %p, data %p\n", controller->oob_buf, ops_para->data_buf);

	ret |= _read_page_single_plane(aml_chip, chipnr, p1_addr) ;
	//printf("p1-, oob %p, data %p\n", controller->oob_buf, ops_para->data_buf);
	//_dump_mem_u8(ops_para->data_buf, 128);

	/* restore buffer location */
	controller->oob_buf = oob_buffer;
	ops_para->data_buf = data_buffer;
	//printf("p1=, oob %p, data %p\n", controller->oob_buf, ops_para->data_buf);
_out:
	/* fill oob buffer */
	if (ops_para->oob_buf) {
		memcpy(ops_para->oob_buf,
			controller->oob_buf,
			BYTES_OF_USER_PER_PAGE);
		if (ops_para->ecc_err)
			memset(ops_para->oob_buf, 0x22, BYTES_OF_USER_PER_PAGE);
	}
	return ret;
}
/* AML_CFG_2PLANE_READ_EN */
#endif


static int _read_page_single_plane(struct amlnand_chip *aml_chip,
	u8 chipnr,
	u32 page_addr)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct en_slc_info *slc_info = &(controller->slc_info);
	u8 *buf = ops_para->data_buf;
	u8 *tmp_buf = controller->oob_buf;
	u32 pages_per_blk_shift;
	u32 page_size, tmp_page;
	u8 all_ff_flag = 0;
	u8 bch_mode, user_byte_num, slc_mode, up_page = 0;
	int ret = 0;
	int new_oob = 0;

	pages_per_blk_shift =
		(controller->block_shift - controller->page_shift);

	if (controller->oob_mod && (ops_para->oob_buf)
		&& (!ops_para->data_buf))
		new_oob = 1;
	PHY_NAND_LINE
	/* for ecc mode */
	if ((ops_para->option & DEV_ECC_SOFT_MODE)
		|| (controller->bch_mode == NAND_ECC_NONE)) {
		bch_mode = NAND_ECC_NONE;
		page_size = flash->pagesize + flash->oobsize;
		user_byte_num = flash->oobsize;
	} else {
		bch_mode = controller->bch_mode;
		user_byte_num = controller->ecc_steps * controller->user_mode;
		page_size = controller->ecc_steps * controller->ecc_unit;
	}

	if (new_oob)
		page_size = controller->ecc_unit;

	if (ops_para->option & DEV_SLC_MODE) {
		/* aml_nand_dbg("enable SLC mode"); */
		if (flash->new_type == SANDISK_19NM)
			slc_mode = 1;
		else if ((flash->new_type > 0) && (flash->new_type < 10))
			slc_mode = 2;
		else
			slc_mode = 0;
	} else {
		slc_mode = 0;
		if (flash->new_type == SANDISK_19NM) {
			tmp_page = page_addr % (1 << pages_per_blk_shift);
			if (((tmp_page % 2 == 0)
				&& (tmp_page != 0))
				|| (tmp_page == ((1 << pages_per_blk_shift)-1)))
				up_page = 1;
			else
				up_page = 0;
		}
	}
	PHY_NAND_LINE
	/* setting global retry_cnt to 0 */
	aml_chip->g_retry_cnt = 0;

	ret = controller->quene_rb(controller, chipnr);
	if (ret) {
		aml_nand_msg("quene rb busy here");
		goto error_exit0;
	}

	if (slc_mode == 1) {
		ret = slc_info->enter(controller);
		if (ret < 0)
			aml_nand_msg("slc enter failed here");
	}
RETRY_CMD:
	PHY_NAND_LINE
	controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
	controller->cmd_ctrl(controller, 0x0, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, 0x0, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, page_addr, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, page_addr>>8, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, page_addr>>16, NAND_CTRL_ALE);
	controller->cmd_ctrl(controller, NAND_CMD_READSTART, NAND_CTRL_CLE);
	/* NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE); */

	/* wait twb here */
	NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
	if (check_cmdfifo_size(controller)) {
		aml_nand_msg("check cmdfifo size timeout");
		BUG();
	}
	PHY_NAND_LINE
	ret = controller->quene_rb(controller, chipnr);
	if (ret) {
		aml_nand_msg("quene rb busy here");
		goto error_exit0;
	}
	PHY_NAND_LINE
	if (controller->option & NAND_CTRL_NONE_RB) {
		controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
	}
	PHY_NAND_LINE
	/* aml_nand_dbg("page_addr:%d", ops_para->page_addr); */
	/* transfer random seed. */
	controller->page_addr = page_addr;
	ret = controller->dma_read(controller, page_size, bch_mode);
	if (ret) {
		aml_nand_msg("dma error here");
		BUG();
		goto error_exit0;
	}
	PHY_NAND_LINE
	if (bch_mode != NAND_ECC_NONE) {
		PHY_NAND_LINE
		ret = ecc_read_retry_handle(aml_chip,
			chipnr,
			tmp_buf,
			user_byte_num,
			page_size,
			slc_mode,
			up_page);
		if (ret == RETURN_PAGE_ALL_0XFF) {
			PHY_NAND_LINE
			all_ff_flag = 1;
		} else if (ret == RETURN_PAGE_NEED_READRETRY) {
			PHY_NAND_LINE
			goto RETRY_CMD;
		} else if (ret < 0) {
			PHY_NAND_LINE
			aml_nand_msg("uncorrect ecc here at page:%d, chip:%d",
				page_addr,
				chipnr);
			ops_para->ecc_err++;

		}
	}
	if (ops_para->data_buf) {
		if (all_ff_flag)
			memset(buf, 0xff, page_size);
		else
			memcpy(buf, controller->data_buf, page_size);
		buf += page_size;
	}
	PHY_NAND_LINE
	if (ops_para->oob_buf) {
		if (all_ff_flag)
			memset(tmp_buf, 0xff, user_byte_num);
		tmp_buf += user_byte_num;
	}
	all_ff_flag = 0;

	if (check_cmdfifo_size(controller)) {
		aml_nand_msg("check cmdfifo size timeout");
		BUG();
	}
#if 0 /*move this outsides */
	if (ops_para->oob_buf) {
		memcpy(ops_para->oob_buf,
			controller->oob_buf,
			BYTES_OF_USER_PER_PAGE);
		if (ops_para->ecc_err)
			memset(ops_para->oob_buf, 0x22, BYTES_OF_USER_PER_PAGE);
	}
#endif //
	return NAND_SUCCESS;
error_exit0:
	return ret;
}


static int read_page_single_plane(struct amlnand_chip *aml_chip,
	u8 chipnr,
	u32 page_addr)
{
	int ret;
	struct hw_controller *controller = &(aml_chip->controller);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);

	ret = _read_page_single_plane( aml_chip, chipnr, page_addr);

	if (ops_para->oob_buf) {
		memcpy(ops_para->oob_buf,
			controller->oob_buf,
			BYTES_OF_USER_PER_PAGE);
		if (ops_para->ecc_err)
			memset(ops_para->oob_buf, 0x22, BYTES_OF_USER_PER_PAGE);
	}

	return ret;
}


/************************************************************
 * read_page, all parameters saved in aml_chip->ops_para,
 * refer to struct chip_ops_para define.
 * support read way of hwecc/raw, data/oob only, data+oob
 * for opteration mode, contains multi-plane/multi-chip
 *************************************************************/
static int read_page(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	u32 plane0_page_addr, plane1_page_addr, page_addr;
	u32 plane_page_addr, plane_blk_addr, pages_per_blk_shift;
	u8 i, chip_num , plane_num;
	int ret = 0;
	PHY_NAND_LINE
	if ((!ops_para->oob_buf) && (!ops_para->data_buf)) {
		aml_nand_msg("buf & oob_buf should never be NULL");
		ret = -NAND_ARGUMENT_FAILURE;
		goto error_exit0;
	}

	/* for multi-chip mode */
	if (ops_para->option & DEV_MULTI_CHIP_MODE)
		chip_num = controller->chip_num;
	else
		chip_num = 1;

	plane0_page_addr = plane1_page_addr = 0;

	page_addr = ops_para->page_addr;
	controller->page_addr = ops_para->page_addr;
	pages_per_blk_shift =
		(controller->block_shift - controller->page_shift);
	if (unlikely(page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *
			aml_chip->flash.internal_chipnr;
		page_addr = controller->page_addr;
	}
	PHY_NAND_LINE
	/* for multi-plane mode */
	if (ops_para->option & DEV_MULTI_PLANE_MODE) {
		plane_num = 2;
		plane_page_addr = page_addr & ((1 << pages_per_blk_shift)-1);
		plane_blk_addr = (page_addr >> (pages_per_blk_shift));
		plane_blk_addr <<= 1;
		plane0_page_addr = (plane_blk_addr << pages_per_blk_shift) |
			plane_page_addr;
		plane_blk_addr += 1;
		plane1_page_addr = (plane_blk_addr << pages_per_blk_shift) |
			plane_page_addr;
	} else
		plane_num = 1;
	PHY_NAND_LINE
	if (chip_num > 1) {
		for (i = 0; i < chip_num; i++) {
			if (plane_num == 2) {
				ret = read_page_two_plane(aml_chip,
					i,
					plane0_page_addr,
					plane1_page_addr);
			} else
				ret = read_page_single_plane(aml_chip,
					i,
					page_addr);
		}
	} else {
		PHY_NAND_LINE
		if (plane_num == 2) {
			PHY_NAND_LINE
			ret = read_page_two_plane(aml_chip,
				ops_para->chipnr,
				plane0_page_addr,
				plane1_page_addr);
		} else {
			PHY_NAND_LINE
			ret = read_page_single_plane(aml_chip,
				ops_para->chipnr,
				page_addr);
		}
	}
error_exit0:
	return ret;
}

/************************************************************
 * write_page, all parameters saved in aml_chip->ops_para.
 * support read way of hwecc/raw, data/oob only, data+oob
 * for opteration mode, contains multi-plane/multi-chip
 *
 *************************************************************/
static int write_page(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct en_slc_info *slc_info = &(controller->slc_info);
	u8 *buf = ops_para->data_buf;
	u8 *oob_buf = ops_para->oob_buf;
	u32 plane_page_addr, plane_blk_addr, pages_per_blk_shift;
	u32 plane0_page_addr, plane1_page_addr, column, page_addr;
	u32 page_size;
	u8 i, bch_mode, plane_num, chip_num, chipnr, user_byte_num;
	u8 slc_mode, status, st_cnt;
	int ret = 0;

	if (!buf) {
		aml_nand_msg("buf should never be NULL");
		ret = -NAND_ARGUMENT_FAILURE;
		goto error_exit0;
	}
	if (aml_chip->nand_status  != NAND_STATUS_NORMAL) {
		aml_nand_msg("nand status unusal: do not write anything!!!!!");
		return NAND_SUCCESS;
	}

	user_byte_num = chipnr = 0;
	plane0_page_addr = plane1_page_addr = 0;

	/* for multi-chip mode */
	if (ops_para->option & DEV_MULTI_CHIP_MODE)
		chip_num = controller->chip_num;
	else
		chip_num = 1;

	if (ops_para->option & DEV_SLC_MODE) {
		/* aml_nand_dbg("enable SLC mode"); */
		if (flash->new_type == SANDISK_19NM)
			slc_mode = 1;
		else if ((flash->new_type > 0) && (flash->new_type < 10))
			slc_mode = 2;
		else
			slc_mode = 0;
	} else
		slc_mode = 0;

	/* for multi-plane mode */
	page_addr = ops_para->page_addr;
	controller->page_addr = ops_para->page_addr;
	pages_per_blk_shift =
		(controller->block_shift - controller->page_shift);
	if (unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *
			aml_chip->flash.internal_chipnr;
	}
	if (ops_para->option & DEV_MULTI_PLANE_MODE) {
		plane_num = 2;
		plane_page_addr = (controller->page_addr &
			(((1 << pages_per_blk_shift) - 1)));
		plane_blk_addr = (controller->page_addr >> pages_per_blk_shift);
		plane_blk_addr <<= 1;
		plane0_page_addr = (plane_blk_addr << pages_per_blk_shift)
			| plane_page_addr;
		plane_blk_addr += 1;
		plane1_page_addr = (plane_blk_addr << pages_per_blk_shift)
			| plane_page_addr;

#if 0
		aml_nand_dbg("ops_para->page_addr =%d", ops_para->page_addr);
		aml_nand_dbg("controller->page_addr=%d", controller->page_addr);
		aml_nand_dbg("plane_page_addr =%d", plane_page_addr);
		aml_nand_dbg("plane_blk_addr =%d", plane_blk_addr);
		aml_nand_dbg("plane0_page_addr =%d", plane0_page_addr);
		aml_nand_dbg("plane1_page_addr =%d", plane1_page_addr);
#endif
	} else {
		plane_num = 1;
	}

	/* for ecc mode */
	if ((ops_para->option & DEV_ECC_SOFT_MODE)
		|| (controller->bch_mode == NAND_ECC_NONE)) {
		bch_mode = NAND_ECC_NONE;
		page_size = flash->pagesize + flash->oobsize;
	} else {
		bch_mode = controller->bch_mode;
		user_byte_num = controller->ecc_steps*controller->user_mode;
		page_size = controller->ecc_steps*controller->ecc_unit;

		/*
		if (controller->bch_mode == NAND_ECC_BCH_SHORT) {
			page_size =
				(flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;
		}*/

		if (!oob_buf) { /* empty oob buffer, set defaut */
			memset(controller->oob_buf,
				0xa5,
				(user_byte_num * (plane_num * chip_num)));
			controller->oob_buf[0] = 0xff;
			oob_buf = controller->oob_buf;
		} else {
			memcpy(controller->oob_buf,
				ops_para->oob_buf,
				(user_byte_num * (plane_num * chip_num)));
			oob_buf = controller->oob_buf;
		}

	}

#if 0
	aml_nand_dbg("page_addr:%d, buf: %x %x %x %x %x %x %x %x",
			ops_para->page_addr, buf[0],
			buf[1], buf[2], buf[3], buf[4],
			buf[5], buf[6], buf[7]);
	aml_nand_dbg("page_addr:%d, oob_buf: %x %x %x %x %x %x %x %x",
			ops_para->page_addr, oob_buf[0],
			oob_buf[1], oob_buf[2], oob_buf[3], oob_buf[4],
			oob_buf[5], oob_buf[6], oob_buf[7]);
#endif
	column = 0;

	for (i = 0; i < chip_num; i++) {
		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
		ret = controller->quene_rb(controller, chipnr);
		if (ret) {
			aml_nand_msg("quene rb busy here");
			goto error_exit0;
		}
#if 0
		if (aml_chip->debug_num == 1)
			aml_nand_dbg("chipnr=%d, chip_num=%d",
				chipnr,
				chip_num);
			aml_nand_dbg("controller->chip_selected =%d",
			controller->chip_selected);
#endif

		if (plane_num == 2) {
			/* plane0 */
			controller->cmd_ctrl(controller, NAND_CMD_SEQIN,
				NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, column,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, column>>8,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr>>8,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr>>16,
				NAND_CTRL_ALE);

			if (bch_mode != NAND_ECC_NONE)
				controller->set_usr_byte(controller,
					oob_buf,
					user_byte_num);

			controller->page_addr = plane0_page_addr;
			ret = controller->dma_write(controller,
				buf,
				page_size,
				bch_mode);
			if (ret) {
				aml_nand_msg("dma error here");
				goto error_exit0;
			}
#if  0
			if (aml_chip->debug_num == 1) {
				aml_nand_dbg("ops_para->page_addr =%d",
					ops_para->page_addr);
				aml_nand_dbg("controller->page_addr =%d",
					controller->page_addr);
				aml_nand_dbg("plane_page_addr =%d",
					plane_page_addr);
				aml_nand_dbg("plane_blk_addr =%d",
					plane_blk_addr);
				aml_nand_dbg("plane0_page_addr =%d",
					plane0_page_addr);
				aml_nand_dbg("plane1_page_addr =%d",
					plane1_page_addr);

			}
#endif
			controller->cmd_ctrl(controller,
				NAND_CMD_DUMMY_PROGRAM,
				NAND_CTRL_CLE);

			NFC_SEND_CMD_IDLE(controller, NAND_TADL_TIME_CYCLE);

			ret = controller->quene_rb(controller, chipnr);
			if (ret) {
				aml_nand_msg("quene rb busy here");
				goto error_exit0;
			}

			oob_buf += user_byte_num;

			/*
			oob_buf+=(BYTES_OF_USER_PER_PAGE /(controller->chip_num;
				plane_num));
			*/
			buf += page_size;

			if ((controller->mfr_type == NAND_MFR_HYNIX)
				|| (controller->mfr_type == NAND_MFR_SAMSUNG))
				controller->cmd_ctrl(controller,
					NAND_CMD_TWOPLANE_WRITE2,
					NAND_CTRL_CLE);
			else
				controller->cmd_ctrl(controller,
					NAND_CMD_TWOPLANE_WRITE2_MICRO,
					NAND_CTRL_CLE);

			controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, column>>8,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr>>8,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr>>16,
				NAND_CTRL_ALE);

			NFC_SEND_CMD_IDLE(controller, NAND_TADL_TIME_CYCLE);

			if (bch_mode != NAND_ECC_NONE)
				controller->set_usr_byte(controller,
					oob_buf,
					user_byte_num);

			controller->page_addr = plane1_page_addr;
			ret = controller->dma_write(controller,
					buf,
					page_size,
					bch_mode);
			if (ret) {
				aml_nand_msg("dma error here");
				goto error_exit0;
			}
		} else {
			if (slc_mode) {
				ret = slc_info->enter(controller);
				if (ret < 0)
					aml_nand_msg("slc enter failed here");
			}

			/*
			NFC_SEND_CMD_IDLE(controller, NAND_TADL_TIME_CYCLE);
			*/
			ret = controller->quene_rb(controller, chipnr);
			if (ret)
				aml_nand_msg("quene rb busy here");

			controller->cmd_ctrl(controller, NAND_CMD_SEQIN,
				NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, column,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, column>>8,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller,
				controller->page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller,
				controller->page_addr>>16, NAND_CTRL_ALE);
			/*
			controller->cmd_ctrl(controller,
				NAND_CMD_PAGEPROG, NAND_CTRL_CLE);
			*/
			NFC_SEND_CMD_IDLE(controller, NAND_TADL_TIME_CYCLE);

			if (bch_mode != NAND_ECC_NONE)
				controller->set_usr_byte(controller,
					oob_buf,
					user_byte_num);
#if 0
			if (aml_chip->debug_num == 1) {
				aml_nand_dbg("chipnr =%d", chipnr);
				aml_nand_dbg("controller->page_addr =%d",
					controller->page_addr);
			}
#endif
			ret = controller->dma_write(controller,
				buf,
				page_size,
				bch_mode);
			if (ret) {
				aml_nand_msg("dma error here");
				goto error_exit0;
			}
#if  0
			if (1) {
				aml_nand_dbg("ops_para->page_addr =%d",
					ops_para->page_addr);
				aml_nand_dbg("controller->page_addr =%d",
					controller->page_addr);
				aml_nand_dbg("plane_page_addr =%d",
					plane_page_addr);
				aml_nand_dbg("plane_blk_addr =%d",
					plane_blk_addr);
				int tt;
				aml_nand_dbg("page_size=%d", page_size);
				for (tt = 0; tt < 200; tt++)
					aml_nand_dbg("buf[%d]=%d", tt, buf[tt]);
			}
#endif
		}
		/* start */
		controller->cmd_ctrl(controller, NAND_CMD_PAGEPROG,
			NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
		oob_buf += user_byte_num;

		/*
		oob_buf +=
		(BYTES_OF_USER_PER_PAGE /(controller->chip_num * plane_num));
		*/
		buf += page_size;

		if (check_cmdfifo_size(controller)) {
			aml_nand_msg("check cmdfifo size timeout");
			BUG();
		}
	}

	for (i = 0; i < chip_num; i++) {
		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
		st_cnt = 0;
#ifdef AML_NAND_RB_IRQ
		if (i == 0)
			ret = controller->quene_rb_irq(controller, chipnr);
		else
			ret = controller->quene_rb(controller, chipnr);
#else
		ret = controller->quene_rb(controller, chipnr);
#endif
		if (ret) {
			aml_nand_msg("quene rb busy here");
			goto error_exit0;
		}

		controller->cmd_ctrl(controller, NAND_CMD_STATUS,
			NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE);
WSTATUS_TRY:
		status = controller->readbyte(controller);
		if (status == NAND_STATUS_FAILED) {
			aml_nand_msg("write falied at page:%d, status:0x%x",
				page_addr,
				status);
			ret = -NAND_WRITE_FAILED;
			goto error_exit0;
		} else if (status != NAND_STATUS_RIGHT) {
			aml_nand_msg("status failed page:%d,status:0x%x try:%d",
				page_addr,
				status,
				st_cnt);
			if (st_cnt++ < NAND_STATUS_MAX_TRY) {
				NFC_SEND_CMD_IDLE(controller,
					NAND_TWB_TIME_CYCLE);
				goto WSTATUS_TRY;
			}
			aml_nand_msg("status still failed");
		}

		/* for hynix nand, reset reg def value */
		if (slc_mode == 2) {
			ret = slc_info->exit(controller);
			if (ret < 0)
				aml_nand_msg("slc enter failed here");
		}
	}
	return NAND_SUCCESS;
error_exit0:
	return ret;
}

static int set_blcok_status(struct amlnand_chip *aml_chip,
	u8 chipnr,
	u32 addr,
	int value)
{
	/* struct hw_controller *controller = &aml_chip->controller; */
	/* struct nand_flash *flash = &aml_chip->flash; */
	u32 blk_addr = addr;
	u16 *tmp_status = NULL;

	tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
	tmp_status[blk_addr] = value;
	aml_nand_msg(" NAND bbt set Bad block at %d\n", blk_addr);

	return 0;
}

static int get_blcok_status(struct amlnand_chip *aml_chip,
	u8 chipnr,
	u32 addr)
{
	/* struct hw_controller *controller = &aml_chip->controller; */
	/* struct nand_flash *flash = &aml_chip->flash; */
	u32 blk_addr = addr;
	u16 *tmp_status = NULL;

	tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
#if 0
	aml_nand_dbg("!!!!!show the block statusXXX ");
	int chip = 0, start_block, total_blk = 50;
	u16 *tmp_arr;
	for (chip = 0; chip < controller->chip_num; chip++) {
		tmp_arr = &aml_chip->block_status->blk_status[chip][0];
			for (start_block = 0;
				start_block < total_blk;
				start_block++)
				aml_nand_msg(" tmp_arr[%d][%d]=%d",
					chip,
					start_block,
					tmp_arr[start_block]);
	}
#endif

	if (tmp_status[blk_addr] == NAND_BLOCK_USED_BAD) {
		aml_nand_dbg(" NAND bbt detect Bad block at chip %d blk %d ",
			chipnr, blk_addr);
		return  NAND_BLOCK_USED_BAD;
	} else if (tmp_status[blk_addr] == NAND_BLOCK_FACTORY_BAD) {
		/*
		aml_nand_dbg(" NAND bbt detect factory
			Bad block at chip %d blk %d",
			chipnr, blk_addr);
		*/
		return  NAND_BLOCK_FACTORY_BAD;
	} else if (tmp_status[blk_addr] == NAND_BLOCK_GOOD)
		return  NAND_BLOCK_GOOD;
	else{
		aml_nand_msg("blk status is wrong at chip%d blk=%d tmp[%d]=%d",
			chipnr, blk_addr,
			blk_addr, tmp_status[blk_addr]);
		return -1;
	}
}

/************************************************************
 * block_isbad, all parameters saved in aml_chip->ops_para.
 * for opteration mode, contains multi-plane/multi-chip
 * supposed chip bbt has been installed
 *
 *************************************************************/
static int block_isbad(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_ops_para *ops_para = &aml_chip->ops_para;
	struct chip_operation *operation = &aml_chip->operation;

	u32 blk_addr, page_per_blk_shift;
	u8 chipnr;
	//u8 chip_num = 1;
	u8  oob_buf[8];
	int ret = 0;
#if 0
	if (ops_para->option & DEV_MULTI_CHIP_MODE) {
		chip_num = controller->chip_num;
		/* aml_nand_dbg(" chip_num =%d ",chip_num); */
	}
#endif //0
	page_per_blk_shift = ffs(flash->blocksize) - ffs(flash->pagesize);
	blk_addr = ops_para->page_addr >> page_per_blk_shift;
	chipnr = ops_para->chipnr;
	if (unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *
			aml_chip->flash.internal_chipnr;
	}
	/* aml_nand_dbg("ops_para->page_addr = %d",ops_para->page_addr); */
	/* aml_nand_dbg("chipnr= %d",chipnr); */
	/* aml_nand_dbg("blk_addr= %d",blk_addr); */

	if (aml_chip->block_status != NULL) {
		if ((ops_para->option  & DEV_MULTI_PLANE_MODE)
			&& (!(ops_para->option & DEV_MULTI_CHIP_MODE))) {
			blk_addr <<= 1;
			/*
		aml_nand_dbg(" DEV_MULTI_PLANE_MODE  &&  !DEV_MULTI_CHIP_MODE");
			*/
			ret = get_blcok_status(aml_chip, chipnr, blk_addr);
			if (ret == NAND_BLOCK_GOOD) {
				/* plane 0 is good , check plane 1 */
				if ((blk_addr % 2) == 0)
					ret = get_blcok_status(aml_chip,
						chipnr,
						(blk_addr+1));
				else/* plane 1 is good, check plane 0 */
					ret = get_blcok_status(aml_chip,
						chipnr,
						(blk_addr - 1));
			}
		} else if ((!(ops_para->option  & DEV_MULTI_PLANE_MODE))
			&& ((ops_para->option & DEV_MULTI_CHIP_MODE))) {
			/*
		aml_nand_dbg(" !DEV_MULTI_PLANE_MODE  &&  DEV_MULTI_CHIP_MODE");
			*/
			for (chipnr = 0;
				chipnr < controller->chip_num;
				chipnr++) {
				ret = get_blcok_status(aml_chip, chipnr,
					blk_addr);
				if (ret != NAND_BLOCK_GOOD)
					break;
			}
		} else if ((ops_para->option  & DEV_MULTI_PLANE_MODE)
			&& (ops_para->option & DEV_MULTI_CHIP_MODE)) {
			/*
			aml_nand_dbg("DEV_MULTI_PLANE_MODE &&
				DEV_MULTI_CHIP_MODE");
			*/
			blk_addr <<= 1;
			ret = get_blcok_status(aml_chip, chipnr, blk_addr);
			if (ret == 0) {
				for (chipnr = 0;
					chipnr < controller->chip_num;
					chipnr++) {
					ret = get_blcok_status(aml_chip,
						chipnr,
						blk_addr);
					if (ret != NAND_BLOCK_GOOD)
						break;
					if ((blk_addr % 2) == 0) {
						/*
						plane 0 is good , check plane 1
						*/
						ret = get_blcok_status(aml_chip,
							chipnr,
							(blk_addr+1));
			if (ret != NAND_BLOCK_GOOD)
				break;
					} else {
						/*
						plane 1 is good, check plane 0
						*/
						ret = get_blcok_status(aml_chip,
							chipnr,
							(blk_addr - 1));
			if (ret != NAND_BLOCK_GOOD)
				break;
					}
				}
			}
		} else
			ret = get_blcok_status(aml_chip, chipnr, blk_addr);
	} else {
		ops_para->data_buf = controller->page_buf;
		ops_para->oob_buf = controller->oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		memset(ops_para->data_buf, 0x0, flash->pagesize);
		memset(ops_para->oob_buf, 0x0, sizeof(oob_buf));

		nand_get_chip(aml_chip);

		ret = operation->read_page(aml_chip);

		nand_release_chip(aml_chip);

		if ((ret < 0) || (ops_para->ecc_err)) {
			aml_nand_msg("nand read page failed at %d chip %d",
				ops_para->page_addr, ops_para->chipnr);
			ret = -NAND_READ_FAILED;
			goto exit_error0;
		}

		if (ops_para->oob_buf[0] == 0) {
			aml_nand_msg("nand detect bad blk at %d chip %d",
				blk_addr, ops_para->chipnr);
			ret = -NAND_BAD_BLCOK_FAILURE;
			goto exit_error0;
		}
	}
	return ret;
exit_error0:
	return ret;
}

/************************************************************
 * block_isbad, all parameters saved in aml_chip->ops_para.
 * for opteration mode, contains multi-plane/multi-chip
 * supposed chip bbt has been installed
 *
 *************************************************************/
static int block_markbad(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_ops_para *ops_para = &aml_chip->ops_para;
	struct chip_operation *operation = &aml_chip->operation;

	u32 blk_addr, pages_per_blk_shift;
	u8 chipnr;
	//u8 chip_num = 1;
	u16 *tmp_status;
	int ret;
#if 0
	if (ops_para->option & DEV_MULTI_CHIP_MODE)
		chip_num = controller->chip_num;
#endif
	pages_per_blk_shift = ffs(flash->blocksize) - ffs(flash->pagesize);
	blk_addr = ops_para->page_addr >> pages_per_blk_shift;
	chipnr = ops_para->chipnr;
	if (unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *
			aml_chip->flash.internal_chipnr;
	}
	aml_nand_dbg("blk_addr =%d", blk_addr);

	if ((aml_chip->nand_bbtinfo.arg_valid)
		&& (aml_chip->block_status != NULL)) {
		tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
		if ((tmp_status[blk_addr] == NAND_BLOCK_USED_BAD)
			|| (tmp_status[blk_addr] == NAND_BLOCK_FACTORY_BAD))
			return 0;
		else if (tmp_status[blk_addr] == NAND_BLOCK_GOOD) {
			if ((ops_para->option  & DEV_MULTI_PLANE_MODE)
			&& (!(ops_para->option & DEV_MULTI_CHIP_MODE))) {
				blk_addr <<= 1;
				if ((blk_addr % 2) == 0) {
					/* plane 0 is good , set plane 1 */
					ret = set_blcok_status(aml_chip,
						chipnr, (blk_addr),
						NAND_BLOCK_USED_BAD);
					ret = set_blcok_status(aml_chip,
						chipnr, (blk_addr+1),
						NAND_BLOCK_USED_BAD);
				aml_nand_dbg("set blk bad at chip%d blk=%d",
						chipnr, blk_addr);
				aml_nand_dbg("set blk bad at chip %d blk %d",
						chipnr, (blk_addr+1));
				} else {/* plane 1 is good, set plane 0 */
					ret = set_blcok_status(aml_chip, chipnr,
						(blk_addr),
						NAND_BLOCK_USED_BAD);
					ret = set_blcok_status(aml_chip, chipnr,
						(blk_addr - 1),
						NAND_BLOCK_USED_BAD);
				aml_nand_dbg("set blk bad at chip %d blk %d",
						chipnr, blk_addr);
				aml_nand_dbg("set blk bad at chip %d blk %d",
						chipnr, (blk_addr-1));
				}
			} else if ((!(ops_para->option & DEV_MULTI_PLANE_MODE))
				&& ((ops_para->option & DEV_MULTI_CHIP_MODE))) {
				for (chipnr = 0;
					chipnr < controller->chip_num;
					chipnr++) {
					ret = set_blcok_status(aml_chip,
						chipnr,
						blk_addr,
						NAND_BLOCK_USED_BAD);
				aml_nand_dbg(" set blk bad at chip %d blk %d",
						chipnr, blk_addr);
				}
			} else if ((ops_para->option  & DEV_MULTI_PLANE_MODE)
				&& (ops_para->option & DEV_MULTI_CHIP_MODE)) {
				blk_addr <<= 1;
				for (chipnr = 0;
					chipnr < controller->chip_num;
					chipnr++) {
					if ((blk_addr % 2) == 0) {
						/*
						plane 0 is good , set plane 1
						*/
						ret = set_blcok_status(aml_chip,
							chipnr,
							(blk_addr+1),
							NAND_BLOCK_USED_BAD);
				aml_nand_dbg("set blk bad at chip %d blk %d",
							chipnr,
							(blk_addr+1));
					} else {
					/* plane 1 is good, set plane 0 */
						ret = set_blcok_status(aml_chip,
							chipnr,
							(blk_addr - 1),
							NAND_BLOCK_USED_BAD);
				aml_nand_dbg("set blk bad,chip%d blk %d",
							chipnr,
							(blk_addr-1));
					}
					/* multi_chip , set every chip_blk */
					ret = set_blcok_status(aml_chip,
						chipnr,
						blk_addr,
						NAND_BLOCK_USED_BAD);
				aml_nand_dbg("set blk bad at chip%d blk=%d",
					chipnr, blk_addr);
				}
			} else {
				ret = set_blcok_status(aml_chip,
					chipnr,
					blk_addr,
					NAND_BLOCK_USED_BAD);
				aml_nand_dbg(" set blk bad at chip %d blk %d",
					chipnr,
					blk_addr);
			}

			ret = amlnand_update_bbt(aml_chip);
			if (ret < 0)
				aml_nand_msg("nand update bbt failed");

		}
	}
#if 0
	/* show the changed block status */
	aml_nand_dbg("show the changed block status ");
	for (chipnr = 0; chipnr < controller->chip_num; chipnr++) {
		tmp_arr = &aml_chip->block_status->blk_status[chipnr][0];
		for (start_block = 0; start_block < 100; start_block++)
			aml_nand_msg(" tmp_arr[%d][%d]=%d",
				chipnr,
				start_block,
				tmp_arr[start_block]);
	}
#endif

	/*
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	*/
	/* ops_para->page_addr = blk_addr << pages_per_blk_shift; */
	/* ops_para->chipnr = blk_addr % controller->chip_num; */
	controller->select_chip(controller, ops_para->chipnr);
	ops_para->data_buf = controller->page_buf;
	ops_para->oob_buf = controller->oob_buf;
	memset((u8 *)ops_para->data_buf, 0x0, flash->pagesize);
	memset((u8 *)ops_para->oob_buf, 0x0, flash->oobsize);

	if (aml_chip->state == CHIP_READY)
		nand_get_chip(aml_chip);

	ret = operation->write_page(aml_chip);

	if (aml_chip->state == CHIP_READY)
		nand_release_chip(aml_chip);

	if (ret < 0) {
		aml_nand_msg("%s() %d: nand write failed", __func__, __LINE__);
		ret = -NAND_WRITE_FAILED;
	}

	return ret;
}


/************************************************************
 * erase_block, all parameters saved in aml_chip->ops_para.
 * for opteration mode, contains multi-plane/multi-chip
 * supposed chip bbt has been installed
 *
 *************************************************************/
static int erase_block(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct en_slc_info *slc_info = &(controller->slc_info);
	u32 plane_page_addr, plane_blk_addr, pages_per_blk_shift;
	u32 plane0_page_addr, plane1_page_addr, chipnr;
	u8 slc_mode, chip_num = 1, plane_num = 1, status, st_cnt;
	int i, ret = 0;

	/* aml_nand_dbg("page_addr:%d", ops_para->page_addr); */
	if (aml_chip->nand_status  != NAND_STATUS_NORMAL) {
		aml_nand_msg("nand status unusal: do not erase anything!!!!!");
		return NAND_SUCCESS;
	}

	if (ops_para->option & DEV_MULTI_CHIP_MODE)
		chip_num = controller->chip_num;

	if (ops_para->option & DEV_SLC_MODE) {
		aml_nand_dbg("enable SLC mode");
		if (flash->new_type == SANDISK_19NM)
			slc_mode = 1;
		else
			slc_mode = 0;
	} else
	   slc_mode = 0;

	controller->page_addr = ops_para->page_addr;

	pages_per_blk_shift = ffs(flash->blocksize) - ffs(flash->pagesize);
	if (unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *
			aml_chip->flash.internal_chipnr;
	}
	plane0_page_addr = plane1_page_addr = 0;
	if (ops_para->option & DEV_MULTI_PLANE_MODE) {
		plane_num = 2;
		plane_page_addr = (controller->page_addr &
			((1 << pages_per_blk_shift) - 1));
		plane_blk_addr = (controller->page_addr >> pages_per_blk_shift);
		plane_blk_addr <<= 1;
		plane0_page_addr = (plane_blk_addr << pages_per_blk_shift) |
			plane_page_addr;
		plane1_page_addr =
			((plane_blk_addr + 1) << pages_per_blk_shift) |
			plane_page_addr;
	}

	for (i = 0; i < chip_num; i++) {
		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
		ret = controller->quene_rb(controller, chipnr);
		if (ret) {
			aml_nand_msg("quene rb busy,chipnr:%d,page_addr:%d",
				chipnr,
				controller->page_addr);
			goto error_exit0;
		}

		if (plane_num == 2) {
			controller->cmd_ctrl(controller, NAND_CMD_ERASE1,
				NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, plane0_page_addr,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr>>8,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr>>16,
				NAND_CTRL_ALE);
			if ((controller->mfr_type == NAND_MFR_MICRON)
				|| (controller->mfr_type == NAND_MFR_MICRON)) {
				controller->cmd_ctrl(controller,
					NAND_CMD_ERASE1_END,
					NAND_CTRL_CLE);
				NFC_SEND_CMD_IDLE(controller,
					NAND_TWB_TIME_CYCLE);
				ret = controller->quene_rb(controller, chipnr);
				if (ret) {
					aml_nand_msg("rb busy,chip%d,paddr:%d",
						chipnr,
						controller->page_addr);
					goto error_exit0;
				}
			}

			controller->cmd_ctrl(controller, NAND_CMD_ERASE1,
				NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, plane1_page_addr,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr>>8,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr>>16,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, NAND_CMD_ERASE2,
				NAND_CTRL_CLE);
			NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
		} else {
			if (slc_mode) {
				ret = slc_info->enter(controller);
				if (ret < 0)
					aml_nand_msg("slc enter failed here");
			}
			controller->cmd_ctrl(controller, NAND_CMD_ERASE1,
				NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, controller->page_addr,
				NAND_CTRL_ALE);
			controller->cmd_ctrl(controller,
				controller->page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller,
				controller->page_addr>>16, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller,
				NAND_CMD_ERASE2, NAND_CTRL_CLE);

			NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
		}

		if (check_cmdfifo_size(controller)) {
			aml_nand_msg("check cmdfifo size timeout");
			BUG();
		}
	}

	for (i = 0; i < chip_num; i++) {
		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
		st_cnt = 0;
#ifdef AML_NAND_RB_IRQ
		if (i == 0)
			ret = controller->quene_rb_irq(controller, chipnr);
		else
			ret = controller->quene_rb(controller, chipnr);
#else
		ret = controller->quene_rb(controller, chipnr);
#endif
		if (ret) {
			aml_nand_msg("quene rb busy,chipnr:%d,page_addr:%d",
				chipnr,
				controller->page_addr);
			goto error_exit0;
		}

		controller->cmd_ctrl(controller,
			NAND_CMD_STATUS, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE);

ESTATUS_TRY:
		status = controller->readbyte(controller);
		if (status == NAND_STATUS_FAILED) {
			aml_nand_msg("erase falied, chip%d page:%d,status:0x%x",
				chipnr,
				controller->page_addr,
				status);
			ret = -NAND_WRITE_FAILED;
			goto error_exit0;
		} else if (status != NAND_STATUS_RIGHT) {
			aml_nand_msg("erase status failed");
			aml_nand_msg("chipnr:%d page:%d,status:0x%x and try:%d",
				chipnr,
				controller->page_addr,
				status,
				st_cnt);
			if (st_cnt++ < NAND_STATUS_MAX_TRY) {
				NFC_SEND_CMD_IDLE(controller,
					NAND_TWB_TIME_CYCLE);
				goto ESTATUS_TRY;
			}
			aml_nand_msg("erase status still failed ");
		}
	}
	return NAND_SUCCESS;
error_exit0:
	return ret;
}
/************************************************************
 * test_block, all parameters saved in aml_chip->ops_para.
 * for opteration mode, contains multi-plane/multi-chip
 * supposed chip bbt has been installed
 * something wrong, don't work well!!! Do not use it.
 *************************************************************/
static int test_block_chip_op(struct amlnand_chip *aml_chip)
{
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct nand_flash *flash = &aml_chip->flash;

	u8 phys_erase_shift, phys_page_shift;
	u32 pages_per_blk, pages_read, blk_addr = 0;
	u8  oob_buf[8];
	int  ret = 0, t = 0;
	u8 *dat_buf = NULL;

	blk_addr = ops_para->page_addr;
	dat_buf  = aml_nand_malloc(flash->pagesize);
	if (!dat_buf) {
		aml_nand_msg("test_block: malloc failed");
		ret =  -1;
		goto exit;
	}
	memset(dat_buf, 0xa5, flash->pagesize);

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));
	pages_read = pages_per_blk;

	/* erase */
	aml_nand_msg("erase addr = %d", ops_para->page_addr);
	ret = erase_block(aml_chip);
	if (ret < 0) {
		aml_nand_msg("nand blk erase failed");
		ret =  -1;
		goto exit;
	}
	aml_nand_msg("nand blk %d erase OK", blk_addr);

#if 1
	/* read */
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	ops_para->page_addr = blk_addr;
	for (t = 0; t < pages_read; t++) {
		memset(aml_chip->user_page_buf, 0x0, flash->pagesize);
		ops_para->page_addr += t;
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = read_page(aml_chip);
		if (ret < 0) {
			aml_nand_msg("nand read %d failed", blk_addr);
			ret =  -1;
			goto exit;
		}
	}
	aml_nand_msg("nand blk read OK");

	/* write */
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	ops_para->page_addr = blk_addr;
	for (t = 0; t < pages_read; t++) {
		memset(aml_chip->user_page_buf, 0xa5, flash->pagesize);
		ops_para->page_addr += t;
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = write_page(aml_chip);
		if (ret < 0) {
			aml_nand_msg("%s() %d: nand write failed", __func__, __LINE__);
			ret =  -1;
			goto exit;
		}
	}
	aml_nand_msg("nand blk %d write OK", blk_addr);
	/* read */
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	ops_para->page_addr = blk_addr;
	for (t = 0; t < pages_read; t++) {
		memset(aml_chip->user_page_buf, 0x0, flash->pagesize);
		ops_para->page_addr += t;
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = read_page(aml_chip);
		if (ret < 0) {
			aml_nand_msg("nand read failed");
			ret =  -1;
			goto exit;
		}
	}
	aml_nand_msg("nand blk %d read OK", blk_addr);
	/* erase */
	ops_para->page_addr = blk_addr;
	ret = erase_block(aml_chip);
	if (ret < 0) {
		aml_nand_msg("nand blk erase failed");
		ret =  -1;
		goto exit;
	}
	aml_nand_msg("nand blk %d erase OK", blk_addr);
#endif
exit:
	/* nand_release_chip(aml_chip); */
	if (dat_buf) {
		aml_nand_free(dat_buf);
		dat_buf = NULL;
	}
	if (!ret)
		aml_nand_msg("blk test OK");

	return ret;
}

/************************************************************
 * test_block, all parameters saved in aml_chip->ops_para.
 * for opteration mode, contains multi-plane/multi-chip
 * supposed chip bbt has been installed
 *
 *************************************************************/
static int test_block_reserved(struct amlnand_chip *aml_chip, int tst_blk)
{
	struct hw_controller *controller = &aml_chip->controller;
	/* struct chip_operation *operation = & aml_chip->operation; */
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct nand_flash *flash = &aml_chip->flash;
	struct en_slc_info *slc_info = &(controller->slc_info);

	u8 phys_erase_shift, phys_page_shift, nand_boot;
	u32 offset, pages_per_blk, pages_read;
	u8  oob_buf[8];
	u16  tmp_blk;
	int  ret = 0, t = 0;
	u32 tmp_value;

	u8 *dat_buf = NULL;

	dat_buf  = aml_nand_malloc(flash->pagesize);
	if (!dat_buf) {
		aml_nand_msg("test_block: malloc failed");
		ret =  -1;
		goto exit;
	}
	memset(dat_buf, 0xa5, flash->pagesize);

	nand_boot = 1;

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else
		offset = 0;

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));

	tmp_blk = (offset >> phys_erase_shift);

	if ((flash->new_type) && ((flash->new_type < 10)
		|| (flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;

	if (ops_para->option & DEV_SLC_MODE)
		pages_read = pages_per_blk >> 1;
	else
		pages_read = pages_per_blk;

	nand_get_chip(aml_chip);

	/* erase */
	tmp_value = tst_blk - tst_blk % controller->chip_num;
	tmp_value /= controller->chip_num;
	tmp_value += tmp_blk - tmp_blk/controller->chip_num;
	ops_para->page_addr = tmp_value * pages_per_blk;
	ops_para->chipnr = tst_blk % controller->chip_num;
	controller->select_chip(controller, ops_para->chipnr);
	ret = erase_block(aml_chip);
	if (ret < 0) {
		aml_nand_msg("nand blk %d erase failed", tst_blk);
		ret =  -1;
		goto exit;
	}
	/* write */
	for (t = 0; t < pages_read; t++) {
		memset((u8 *)ops_para,
			0x0,
			sizeof(struct chip_ops_para));
		if ((flash->new_type) && ((flash->new_type < 10)
			|| (flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE;
		tmp_value = tst_blk - tst_blk % controller->chip_num;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = t + tmp_value * pages_per_blk;
		ops_para->chipnr = tst_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		if ((ops_para->option & DEV_SLC_MODE)) {
			tmp_value = ~(pages_per_blk - 1);
			tmp_value &= ops_para->page_addr;
			if ((flash->new_type > 0) && (flash->new_type < 10))
				ops_para->page_addr = tmp_value |
				(slc_info->pagelist[ops_para->page_addr % 256]);
			if (flash->new_type == SANDISK_19NM)
				ops_para->page_addr = tmp_value |
				((ops_para->page_addr % pages_per_blk) << 1);
		}

		memset(aml_chip->user_page_buf, 0xa5, flash->pagesize);
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = write_page(aml_chip);
		if (ret < 0) {
			aml_nand_msg("%s() %d: nand write failed", __func__, __LINE__);
			ret =  -1;
			goto exit;
		}
	}
	/* read */
	for (t = 0; t < pages_read; t++) {
		memset((u8 *)ops_para, 0x0,
			sizeof(struct chip_ops_para));
		if ((flash->new_type) && ((flash->new_type < 10)
			|| (flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE;
		tmp_value = tst_blk - tst_blk % controller->chip_num;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = (t + tmp_value * pages_per_blk);
		ops_para->chipnr = tst_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		if ((ops_para->option & DEV_SLC_MODE)) {
			tmp_value = ~(pages_per_blk - 1);
			tmp_value &= ops_para->page_addr;
			if ((flash->new_type > 0) && (flash->new_type < 10))
				ops_para->page_addr = tmp_value |
				(slc_info->pagelist[ops_para->page_addr % 256]);
			if (flash->new_type == SANDISK_19NM)
				ops_para->page_addr = tmp_value |
				((ops_para->page_addr % pages_per_blk) << 1);
		}

		memset(aml_chip->user_page_buf, 0x0, flash->pagesize);
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = read_page(aml_chip);
		if (ret < 0) {
			aml_nand_msg("nand read failed");
			ret =  -1;
			goto exit;
		}
		/*
		aml_nand_dbg("tst_blk %d aml_chip->user_page_buf: ",tst_blk);
		*/
		/* show_data_buf(aml_chip->user_page_buf); */
		/* aml_nand_dbg("tst_blk %d dat_buf: ",tst_blk); */
		/* show_data_buf(dat_buf); */
		if (memcmp(aml_chip->user_page_buf,
			dat_buf,
			flash->pagesize)) {
			ret =  -1;
			aml_nand_msg("blk  %d,  page %d : test failed",
				tst_blk,
				t);
			goto exit;
		}
	}
	/* erase */
	tmp_value = tst_blk - tst_blk % controller->chip_num;
	tmp_value /= controller->chip_num;
	tmp_value += tmp_blk - tmp_blk/controller->chip_num;
	ops_para->page_addr = tmp_value * pages_per_blk;
	ops_para->chipnr = tst_blk % controller->chip_num;
	controller->select_chip(controller, ops_para->chipnr);
	ret = erase_block(aml_chip);
	if (ret < 0) {
		aml_nand_msg("nand blk %d erase failed", tst_blk);
		ret =  -1;
		goto exit;
	}

exit:
	nand_release_chip(aml_chip);

	if (dat_buf) {
		aml_nand_free(dat_buf);
		dat_buf = NULL;
	}
	if (!ret)
		aml_nand_msg("blk %d test OK", tst_blk);

	return ret;
}
/************************************************************
 * all parameters saved in aml_chip->ops_para.
 * for opteration mode, contains multi-plane/multi-chip
 * supposed chip bbt has been installed
 *
 *************************************************************/
static int blk_modify_bbt_chip_op(struct amlnand_chip *aml_chip, int value)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_ops_para *ops_para = &aml_chip->ops_para;
	/* struct chip_operation *operation = & aml_chip->operation; */

	u32 blk_addr, page_per_blk_shift;
	u8 chipnr;
	/* u8  oob_buf[8]; */
	int ret = 0;
#if 0
	u8 chip_num = 1;
	if (ops_para->option & DEV_MULTI_CHIP_MODE)
		chip_num = controller->chip_num;
#endif
	page_per_blk_shift = ffs(flash->blocksize) - ffs(flash->pagesize);
	blk_addr = ops_para->page_addr >> page_per_blk_shift;
	chipnr = ops_para->chipnr;
	if (unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *
			aml_chip->flash.internal_chipnr;
	}

	if ((ops_para->option  & DEV_MULTI_PLANE_MODE)
		&& (!(ops_para->option & DEV_MULTI_CHIP_MODE))) {
		blk_addr <<= 1;
		/*
		aml_nand_dbg(" DEV_MULTI_PLANE_MODE && !DEV_MULTI_CHIP_MODE");
		*/
		ret = set_blcok_status(aml_chip, chipnr, blk_addr, value);
		if (ret == 0) {
			if ((blk_addr % 2) == 0)
				/* plane 0 is good , check plane 1 */
				ret = set_blcok_status(aml_chip,
					chipnr,
					(blk_addr+1),
					value);
			else	/* plane 1 is good, check plane 0 */
				ret = set_blcok_status(aml_chip,
					chipnr,
					(blk_addr - 1),
					value);
		}
	} else if ((!(ops_para->option & DEV_MULTI_PLANE_MODE))
		&& ((ops_para->option & value))) {
		/*
		aml_nand_dbg(" !DEV_MULTI_PLANE_MODE  &&  DEV_MULTI_CHIP_MODE");
		*/
		for (chipnr = 0; chipnr < controller->chip_num; chipnr++) {
			ret = set_blcok_status(aml_chip,
				chipnr,
				blk_addr,
				value);
			if (ret != 0)
				break;
		}
	} else if ((ops_para->option  & DEV_MULTI_PLANE_MODE)
		&& (ops_para->option & DEV_MULTI_CHIP_MODE)) {
		/*
		aml_nand_dbg(" DEV_MULTI_PLANE_MODE && DEV_MULTI_CHIP_MODE");
		*/
		blk_addr <<= 1;
		ret = set_blcok_status(aml_chip, chipnr, blk_addr, value);
		if (ret == 0) {
			for (chipnr = 0;
				chipnr < controller->chip_num;
				chipnr++) {
				ret = set_blcok_status(aml_chip,
					chipnr,
					blk_addr,
					value);
				if (ret != 0)
					break;
				if ((blk_addr % 2) == 0) {
					/* plane 0 is good , check plane 1 */
					ret = set_blcok_status(aml_chip,
						chipnr,
						(blk_addr+1),
						value);
					if (ret != 0)
						break;
				} else {/* plane 1 is good, check plane 0 */
					ret = set_blcok_status(aml_chip,
						chipnr,
						(blk_addr - 1),
						value);
					if (ret != 0)
						break;
				}
			}
		}
	} else
		ret = set_blcok_status(aml_chip, chipnr, blk_addr, value);

	return ret;
}


/************************************************************
 *  all parameters saved in aml_chip->ops_para.
 * for opteration mode, contains multi-plane/multi-chip
 * supposed chip bbt has been installed
 *
 *************************************************************/
static int update_bbt_chip_op(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	/* struct chip_operation *operation = & aml_chip->operation; */

	/* u8 chip_num = 1; */
	/* u16 * tmp_status; */
	int ret;
#if 0
	if (ops_para->option & DEV_MULTI_CHIP_MODE)
		chip_num = controller->chip_num;
#endif

	//blk_addr = ops_para->page_addr >> pages_per_blk_shift;
	//chipnr = ops_para->chipnr;
	if (unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -=
			controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *
			aml_chip->flash.internal_chipnr;
	}

	aml_nand_msg("###nand update start!!!!\n");

	ret = amlnand_update_bbt(aml_chip);
	if (ret < 0)
		aml_nand_msg("nand update bbt failed");

	return ret;
}

/************************************************************
 * get_onfi_features, for onfi feature operation
 *
 *************************************************************/
static int get_onfi_features(struct amlnand_chip *aml_chip,
	u8 *buf, int addr)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int i, j;

	for (i = 0; i < controller->chip_num; i++) {
		controller->select_chip(controller, i);
		controller->cmd_ctrl(controller, NAND_CMD_GET_FEATURES,
			NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, addr, NAND_CTRL_ALE);
		NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
		NFC_SEND_CMD_IDLE(controller, 0);

		for (j = 0; j < 4; j++)
			buf[j] = controller->readbyte(controller);
	}

	return 0;
}

/************************************************************
 * set_onfi_features, for onfi feature operation
 *
 *************************************************************/
static int set_onfi_features(struct amlnand_chip *aml_chip,
	u8 *buf,
	int addr)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int i, j;
	int time_out_cnt = 0;

	for (i = 0; i < controller->chip_num; i++) {
		controller->select_chip(controller, i);
		controller->cmd_ctrl(controller, NAND_CMD_SET_FEATURES,
			NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, addr, NAND_CTRL_ALE);
		NFC_SEND_CMD_IDLE(controller, NAND_TADL_TIME_CYCLE);
		NFC_SEND_CMD_IDLE(controller, 0);

		for (j = 0; j < 4; j++)
			controller->writebyte(controller, buf[j]);

		/*
		NFC_SEND_CMD_RB(controller, controller->chip_selected, 20);
		*/
		do {
			if (NFC_CMDFIFO_SIZE(controller) <= 0)
				break;
			udelay(2);
		} while (time_out_cnt++ <= AML_NAND_READ_BUSY_TIMEOUT);

		if (time_out_cnt >= AML_NAND_READ_BUSY_TIMEOUT)
			return -NAND_BUSY_FAILURE;
	}

	return NAND_SUCCESS;
}

/************************************************************
 * nand_reset, send reset command, and assume nand selected here
 *
 *************************************************************/
int nand_reset(struct amlnand_chip *aml_chip, u8 chipnr)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int status;

	/* fixme, read back controller status. */

	/* reset */
	NFC_SEND_CMD_IDLE(controller, 0);
	controller->cmd_ctrl(controller, NAND_CMD_RESET, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
	NFC_SEND_CMD_IDLE(controller, 0);

	/* read status */
	/* controller->cmd_ctrl(controller, NAND_CMD_STATUS, NAND_CTRL_CLE); */
	/* NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE); */

	/* NFC_SEND_CMD_IDLE(controller, 0); */

	if (controller->quene_rb(controller, chipnr) < 0) {
		aml_nand_dbg("quene rb failed here");
		return -NAND_BUSY_FAILURE;
	}

	controller->cmd_ctrl(controller, NAND_CMD_STATUS, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE);
	NFC_SEND_CMD_IDLE(controller, 0);
	NFC_SEND_CMD_IDLE(controller, 0);

	while (NFC_CMDFIFO_SIZE(controller))
		;

	status = (int)controller->readbyte(controller);
	if (status & NAND_STATUS_READY)
		return NAND_SUCCESS;

	aml_nand_dbg("check status failed and status:0x%x", status);

	return -NAND_BUSY_FAILURE;
}

/************************************************************
 * read_id
 * @id_addr: for 00H and 20H;
 * @buf: chip id stored into buf;
 *************************************************************/
static int read_id(struct amlnand_chip *aml_chip, u8 chipnr,
	u8 id_addr,
	u8 *buf)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int i, ret = 0;

	if (buf == NULL) {
		aml_nand_msg("buf must not be NULL here");
		ret = -NAND_ARGUMENT_FAILURE;
		goto error_exit0;
	}

	ret = controller->select_chip(controller, chipnr);
	if (ret < 0) {
		aml_nand_msg("select chip %d failed", chipnr);
		goto error_exit0;
	}

	ret = nand_reset(aml_chip, chipnr);
	if (ret < 0) {
		if (chipnr == 0)
			aml_nand_msg("reset failed");
		else
			aml_nand_dbg("reset failed");
		goto error_exit0;
	}

	/* send id cmd */
	controller->cmd_ctrl(controller, NAND_CMD_READID, NAND_CTRL_CLE);
	controller->cmd_ctrl(controller, id_addr, NAND_CTRL_ALE);
	NFC_SEND_CMD_IDLE(controller, NAND_TWHR_TIME_CYCLE);
	NFC_SEND_CMD_IDLE(controller, 0);

	/* Read manufacturer and device IDs */
	for (i = 0; i < MAX_ID_LEN; i++)
		buf[i] = controller->readbyte(controller);
error_exit0:
	return ret;
}

int amlnand_init_operation(struct amlnand_chip *aml_chip)
{
	struct chip_operation *operation = &(aml_chip->operation);

	if (!operation->reset)
		operation->reset = nand_reset;
	if (!operation->read_id)
		operation->read_id = read_id;
	if (!operation->set_onfi_para)
		operation->set_onfi_para = set_onfi_features;
	if (!operation->get_onfi_para)
		operation->get_onfi_para = get_onfi_features;

	if (!operation->check_wp)
		operation->check_wp = check_wp;

	if (!operation->erase_block)
		operation->erase_block = erase_block;

	if (!operation->test_block_chip_op)
		operation->test_block_chip_op = test_block_chip_op;

	if (!operation->test_block_reserved)
		operation->test_block_reserved = test_block_reserved;

	if (!operation->block_isbad)
		operation->block_isbad = block_isbad;

	if (!operation->block_markbad)
		operation->block_markbad = block_markbad;

	if (!operation->read_page)
		operation->read_page = read_page;

	if (!operation->write_page)
		operation->write_page = write_page;

	if (!operation->blk_modify_bbt_chip_op)
		operation->blk_modify_bbt_chip_op = blk_modify_bbt_chip_op;

	if (!operation->update_bbt_chip_op)
		operation->update_bbt_chip_op = update_bbt_chip_op;

	return NAND_SUCCESS;

}

