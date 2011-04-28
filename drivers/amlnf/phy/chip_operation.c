
/*****************************************************************
**                                                              
**  Copyright (C) 2012 Amlogic,Inc.  All rights reserved                         
**                                           
**        Filename : chip_operation.c       	
**        Revision : 1.001	                                        
**        Author: Benjamin Zhao
**        Description: 
**			chip operation function,  contains read/write/erase, and bad block function.
**        		mainly init nand phy driver.
**            
*****************************************************************/
#include "../include/phynand.h"

static int check_cmdfifo_size()
{
	int time_out_cnt = 0, retry_cnt = 0;

RETRY:	
	do {
		if (NFC_CMDFIFO_SIZE() <= 0)
			break;
	}while (time_out_cnt++ <= AML_DMA_BUSY_TIMEOUT);

	if(time_out_cnt >= AML_DMA_BUSY_TIMEOUT){
		if(retry_cnt++ > 3){
			aml_nand_msg("check cmdfifo size timeout over 3 times !!!!!");
			return -NAND_FAILED;
		}
		else{
			aml_nand_dbg("check cmdfifo size timeout retry_cnt:%d", retry_cnt);
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
	if (controller->option & NAND_CTRL_FORCE_WP){
		aml_nand_msg("check force WP here");
		return -NAND_WP_FAILURE;
	}
	
	/* Check the WP bit */
	for(i=0; i<controller->chip_num; i++){
		controller->select_chip(controller, i);
		
		//read status
		controller->cmd_ctrl(controller, NAND_CMD_STATUS, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
		
		NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
		do{
			if (NFC_CMDFIFO_SIZE() <= 0)
				break;
			udelay(2);
		}while (time_out_cnt++ <= AML_NAND_READ_BUSY_TIMEOUT);
		
		if(time_out_cnt >= AML_NAND_READ_BUSY_TIMEOUT){
			aml_nand_msg("cmd fifo size failed to clear and NFC_CMDFIFO_SIZE():%d", NFC_CMDFIFO_SIZE());
			return -NAND_CMD_FAILURE;
		}

		if(controller->readbyte(controller) & NAND_STATUS_WP){
			return -NAND_WP_FAILURE;
		}	

	}
		
	return 0;
}


/************************************************************
 * read_page, all parameters saved in aml_chip->ops_para, refer to struct chip_ops_para define.
 * support read way of hwecc/raw, data/oob only, data+oob 
 * for opteration mode, contains multi-plane/multi-chip
 * 
 *************************************************************/
static int read_page(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct read_retry_info *retry_info = &(controller->retry_info);
	struct en_slc_info *slc_info = &(controller->slc_info);
	unsigned char *buf = ops_para->data_buf;
	unsigned char *oob_buf = ops_para->oob_buf;
	unsigned char *tmp_buf = controller->oob_buf;
	unsigned plane_page_addr, plane_blk_addr, pages_per_blk_shift, page_size, tmp_page;
	unsigned plane0_page_addr, plane1_page_addr, column, page_addr;	
	unsigned char i, bch_mode, plane_num, chip_num, chipnr, user_byte_num; 
	unsigned char with_oob, with_data, plane0_retry_flag = 0, all_ff_flag = 0;
	unsigned char need_retry, retry_cnt, up_page, slc_mode; 	
	int ooblen, j, ret = 0;
	int new_oob = 0;
	int retry_op_cnt = retry_info->retry_cnt_lp;
	//aml_nand_dbg("start");
	if((!buf) && (!oob_buf)){
		aml_nand_msg("buf & oob_buf should never be NULL");
		ret = -NAND_ARGUMENT_FAILURE;
		goto error_exit0;
	}
	if((flash->new_type == HYNIX_20NM_8GB) || (flash->new_type == HYNIX_20NM_4GB)|| (flash->new_type == HYNIX_1YNM_8GB))
		 retry_op_cnt = retry_info->retry_cnt_lp * retry_info->retry_cnt_lp;
	
	user_byte_num = chipnr = 0;
	plane0_page_addr = plane1_page_addr = 0;
	
	page_addr = ops_para->page_addr;	
	controller->page_addr = ops_para->page_addr;
	pages_per_blk_shift =  (controller->block_shift - controller->page_shift);	
	if(unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *aml_chip->flash.internal_chipnr;
	}
	
	with_oob = 0;
	with_data = 0;
	if(oob_buf){
		with_oob = 1;
	}

	if(buf){
		with_data = 1;
	}

	if(controller->oob_mod&&(with_oob ==1)&&(with_data ==0)) {
		new_oob = 1;
	}
	//for multi-chip mode 
	if(ops_para->option & DEV_MULTI_CHIP_MODE){
		chip_num = controller->chip_num;		
	}
	else{
		chip_num = 1;
	}
	
	 if(ops_para->option & DEV_SLC_MODE){
		// aml_nand_dbg("enable SLC mode");	
		 if(flash->new_type == SANDISK_19NM){
			 slc_mode = 1;
		 }
		 else if((flash->new_type > 0) && (flash->new_type < 10)){
			 slc_mode = 2;	
			// page_addr = slc_info->pagelist[page_addr];
		 }
		 else{
			 slc_mode = 0;
		 }
	 }
	 else{	 	
		slc_mode = 0;
		 if(flash->new_type == SANDISK_19NM){
			 tmp_page = page_addr % (1 << pages_per_blk_shift);
			 if(((tmp_page % 2 == 0) && (tmp_page !=0) )||(tmp_page == ((1 << pages_per_blk_shift)-1))){
				up_page = 1;
			 }
			 else{
				up_page = 0;
			 }
		 }
	 }

	//for multi-plane mode	
	if(ops_para->option & DEV_MULTI_PLANE_MODE){
		plane_num = 2;
		plane_page_addr = (controller->page_addr & (((1 << pages_per_blk_shift) - 1)));
		plane_blk_addr = (controller->page_addr >> (pages_per_blk_shift ));		
		plane_blk_addr <<= 1;
		plane0_page_addr = (plane_blk_addr << pages_per_blk_shift) | plane_page_addr;			
		plane1_page_addr = ((plane_blk_addr + 1) << pages_per_blk_shift) | plane_page_addr;
	}
	else{
		plane_num = 1;				
	}
	
	//for ecc mode
	if((ops_para->option & DEV_ECC_SOFT_MODE) || (controller->bch_mode == NAND_ECC_NONE)){
		bch_mode = NAND_ECC_NONE;		
		page_size = flash->pagesize + flash->oobsize;
		user_byte_num = flash->oobsize;
	}
	else{
		bch_mode = controller->bch_mode;
		user_byte_num = controller->ecc_steps*controller->user_mode;		
		page_size = controller->ecc_steps*controller->ecc_unit;
	}	
	
	if(new_oob){
		page_size = controller->ecc_unit;
	}
	ooblen = user_byte_num* chip_num;
	ooblen *= plane_num;
	
	if(ops_para->ooblen > ooblen){
		aml_nand_msg("check ops_para->ooblen:%d over size to chip ooblen:%d", ops_para->ooblen, ooblen);
	}
	else if(ops_para->ooblen){
		ooblen = ops_para->ooblen;
	}

	column = 0;
//send read command
	for(i=0; i<chip_num; i++){

		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
		//setting retry_cnt to 0
		retry_cnt = 0;

		ret = controller->quene_rb(controller, chipnr);
		if(ret){
			aml_nand_msg("quene rb busy here");
			goto error_exit0;
		}
		
		if(plane_num == 2){	
			
RETRY_PLANE_CMD:			
			if((controller->mfr_type == NAND_MFR_MICRON) || (controller->mfr_type == NAND_MFR_INTEL)){
				//plane0
				controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
				controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane0_page_addr, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane0_page_addr>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane0_page_addr>>16, NAND_CTRL_ALE);

				controller->cmd_ctrl(controller, 0x32, NAND_CTRL_CLE);				
				NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
				ret = controller->quene_rb(controller, chipnr);
				if(ret){
					aml_nand_msg("send 0x32 cmd Rb  failed\n");
				}

				//plane1								
				controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
				controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr>>16, NAND_CTRL_ALE);
				//read start
				controller->cmd_ctrl(controller, NAND_CMD_READSTART, NAND_CTRL_CLE);	
				
				//NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
			}
			else{
				//plane0
				controller->cmd_ctrl(controller, NAND_CMD_TWOPLANE_PREVIOS_READ, NAND_CTRL_CLE);
				controller->cmd_ctrl(controller, plane0_page_addr, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane0_page_addr>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane0_page_addr>>16, NAND_CTRL_ALE);
				//plane1
				controller->cmd_ctrl(controller, NAND_CMD_TWOPLANE_PREVIOS_READ, NAND_CTRL_CLE);
				controller->cmd_ctrl(controller, plane1_page_addr, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr>>16, NAND_CTRL_ALE);			
				//read start
				controller->cmd_ctrl(controller, NAND_CMD_READSTART, NAND_CTRL_CLE);
				
				//NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
			}
	
		}
		else{
			if(slc_mode == 1){
				ret = slc_info->enter(controller);
				if(ret < 0){
					aml_nand_msg("slc enter failed here");
				}
			}
RETRY_CMD:
			controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr>>16, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, NAND_CMD_READSTART, NAND_CTRL_CLE);
			
			//NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
		}		
		
		//wait twb here
		NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);

		if(check_cmdfifo_size()){
			aml_nand_msg("check cmdfifo size timeout");
			BUG();
		}
		if(retry_cnt){
			goto RETRY_DMA;
		}
	}

//check rb and dma and ecc correct
	for(i=0; i<chip_num;i++){
		
		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
		retry_cnt = 0;
RETRY_DMA:		
		ret = controller->quene_rb(controller, chipnr);
		if(ret){
			aml_nand_msg("quene rb busy here");
			goto error_exit0;
		}

		 if(controller->option & NAND_CTRL_NONE_RB){
			controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);				
			NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);			
		}

		if(plane_num == 2){		
			if((controller->mfr_type == NAND_MFR_MICRON) || (controller->mfr_type == NAND_MFR_INTEL)){
				   if(plane0_retry_flag == 0){
					controller->page_addr = plane0_page_addr;
					ret = controller->dma_read(controller, page_size, bch_mode);
					if(ret){
						aml_nand_msg("quene rb busy here");
						BUG();
						goto error_exit0;
					}
					
					all_ff_flag = 0;
					//for ecc soft mode
					if(bch_mode != NAND_ECC_NONE){  
						controller->get_usr_byte(controller, tmp_buf, user_byte_num);
						ret = controller->hwecc_correct(controller, page_size, tmp_buf);
						if(ret ==  NAND_ECC_FAILURE){
							//check rand_mode and 0xff page
							if(controller->zero_cnt < controller->ecc_max){
								all_ff_flag = 1;
								//aml_nand_dbg("found all 0xff page here");
								goto plane0_ff_m;
							}
	//
						need_retry = 0;
						if(retry_info->flag && (slc_mode == 0)) {
							if(flash->new_type != SANDISK_19NM){
								if(retry_cnt++ < retry_op_cnt)
									need_retry = 1;
							}
							else if(flash->new_type == SANDISK_19NM){
								if(up_page){
									if(retry_cnt++ < retry_info->retry_cnt_up){
										need_retry = 1;
									}
								}
								else if(retry_cnt++ < retry_info->retry_cnt_lp){	
									need_retry = 1;
								}
							}
							if(need_retry){
								aml_nand_dbg("read retry at chip %d plane0 page %d and retry_cnt: %d",chipnr, plane0_page_addr, retry_cnt);
								ret = retry_info->handle(controller, chipnr);
								if(ret < 0){
									aml_nand_msg("read retry handle failed at plane0 page:%d", plane0_page_addr);
								}
								goto RETRY_PLANE_CMD;
							}
						}	
	//		
							aml_nand_msg("#####NAND uncorrect ecc here at page:%d, plane 0 chip:%d", page_addr, chipnr);
							ops_para->ecc_err++;
						}
						else if(ret < 0){
							aml_nand_msg("hwecc_correct failed ");
							BUG();
							goto error_exit0;
						}
						else {
							if(retry_cnt){
								if(flash->new_type != SANDISK_19NM){
									if(retry_cnt > (retry_op_cnt-2)){
										aml_nand_dbg("detect bitflip at page:%d", page_addr);
										ops_para->bit_flip++;
									}
								}
								else{
									if(up_page){
										if(retry_cnt > (retry_info->retry_cnt_up-2)){
											aml_nand_dbg("detect bitflip at page:%d", page_addr);
											ops_para->bit_flip++;
										}
									}
									else{
										if(retry_cnt > (retry_info->retry_cnt_lp -2)){
											aml_nand_dbg("detect bitflip at page:%d", page_addr);
											ops_para->bit_flip++;
										}
									}
								}
							}
							else if((controller->ecc_cnt_cur > controller->ecc_cnt_limit) && (flash->new_type == 0)){
								aml_nand_dbg("detect bitflip at  page:%d, chip:%d", page_addr, chipnr);
								ops_para->bit_flip++;
							}
						}
						if(retry_cnt && retry_info->exit){
							ret = retry_info->exit(controller, chipnr);
							if(ret < 0){
								aml_nand_msg("retry exit failed flash->new_type:%d, retry_cnt:%d", flash->new_type, retry_cnt);
							}
						}
							plane0_retry_flag = 1;
							retry_cnt = 0;
					}
plane0_ff_m:
					if(with_data) {
						if(all_ff_flag){
							memset(buf, 0xff, page_size);
						}
						else{
							memcpy(buf, controller->data_buf, page_size);
						}					
						//aml_nand_dbg("read data %x %x %x %x %x %x %x %x", buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);					
						//aml_nand_dbg("read oob %x %x %x %x", oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3]);
						buf += page_size;					
					}

					if(with_oob) {
						if(all_ff_flag){
							memset(tmp_buf, 0xff, user_byte_num);
						}
						//memcpy(ops_para->oob_buf, tmp_buf, user_byte_num);
						//aml_nand_dbg("read oob %x %x %x %x", oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3]);
						//oob_buf += user_byte_num;
						//ops_para->oob_buf += (BYTES_OF_USER_PER_PAGE / (controller->chip_num*plane_num)) ;
						tmp_buf += user_byte_num;
					}
					
					all_ff_flag = 0;
				}				
				if(new_oob)
					goto new_oob_mod;
				controller->cmd_ctrl(controller, NAND_CMD_PLANE2_READ_START, NAND_CTRL_CLE);
				controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr>>16, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, NAND_CMD_RNDOUTSTART, NAND_CTRL_CLE); 
				
				NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
				
				controller->page_addr = plane1_page_addr;
				ret = controller->dma_read(controller, page_size, bch_mode);
				if(ret){
					aml_nand_msg("dma error here");
					BUG();
					goto error_exit0;
				}
				
				if(bch_mode != NAND_ECC_NONE){
					controller->get_usr_byte(controller, tmp_buf, user_byte_num);
					ret = controller->hwecc_correct(controller, page_size, tmp_buf);
					if(ret == NAND_ECC_FAILURE){
						//check rand_mode and 0xff page
						if(controller->zero_cnt < controller->ecc_max){	
							all_ff_flag = 1;					
							//aml_nand_dbg("found all 0xff page here");
							goto page_ff;
						}	
//
						need_retry = 0;
						if(retry_info->flag && (slc_mode == 0)) {
							if(flash->new_type != SANDISK_19NM){
								if(retry_cnt++ < retry_op_cnt)
									need_retry = 1;
							}
							else if(flash->new_type == SANDISK_19NM){
								if(up_page){
									if(retry_cnt++ < retry_info->retry_cnt_up){
										need_retry = 1;
									}
								}
								else if(retry_cnt++ < retry_info->retry_cnt_lp){	
									need_retry = 1;
								}
							}
							if(need_retry){
								aml_nand_dbg("read retry at chip %d plane1 page %d and retry_cnt: %d",chipnr, plane1_page_addr, retry_cnt);
								ret = retry_info->handle(controller, chipnr);
								if(ret < 0){
									aml_nand_msg("read retry handle failed at plane1 page:%d", plane1_page_addr);
								}
								goto RETRY_PLANE_CMD;
							}
						}	
//						
						aml_nand_msg("####uncorrect ecc here at page:%d plane 1 chip:%d", page_addr, chipnr);
						ops_para->ecc_err++;
						if(retry_info->flag && (flash->new_type)&&(flash->new_type < 10)){
							ret = nand_reset(aml_chip, chipnr);
							if(ret < 0){
							       aml_nand_msg("reset failed after retry failed at chip %d",chipnr); 
							}
						}
					}
					else if(ret < 0){
						aml_nand_msg("failed ");						
						BUG();
						goto error_exit0;
					}
					else {
						if(retry_cnt){
							if(flash->new_type != SANDISK_19NM){
								if(retry_cnt > (retry_op_cnt-2)){
									aml_nand_dbg("detect bitflip at page:%d", page_addr);
									ops_para->bit_flip++;
								}
							}
							else{
								if(up_page){
									if(retry_cnt > (retry_info->retry_cnt_up-2)){
										aml_nand_dbg("detect bitflip at page:%d", page_addr);
										ops_para->bit_flip++;
									}
								}
								else{
									if(retry_cnt > (retry_info->retry_cnt_lp -2)){
										aml_nand_dbg("detect bitflip at page:%d", page_addr);
										ops_para->bit_flip++;
									}
								}
							}
						}
						else if((controller->ecc_cnt_cur > controller->ecc_cnt_limit) && (flash->new_type == 0)){
							aml_nand_dbg("detect bitflip at  page:%d, chip:%d", page_addr, chipnr);
							ops_para->bit_flip++;
						}
					}
					if(retry_cnt && retry_info->exit){
						ret = retry_info->exit(controller, chipnr);
						if(ret < 0){
							aml_nand_msg("retry exit failed flash->new_type:%d, retry_cnt:%d", flash->new_type, retry_cnt);
						}	
					}
					plane0_retry_flag = 0;
					retry_cnt = 0;
				}
			}
			else{
				if(plane0_retry_flag == 0){
					controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
					controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, plane0_page_addr, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, plane0_page_addr>>8, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, plane0_page_addr>>16, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, NAND_CMD_RNDOUT, NAND_CTRL_CLE);
					controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);			
					controller->cmd_ctrl(controller, NAND_CMD_RNDOUTSTART, NAND_CTRL_CLE); 
					
					NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
					
					controller->page_addr = plane0_page_addr;
					ret = controller->dma_read(controller, page_size, bch_mode);
					if(ret){
						aml_nand_msg("dma error here");
						BUG();
						goto error_exit0;
					}
					
					if(bch_mode != NAND_ECC_NONE){
						controller->get_usr_byte(controller, tmp_buf, user_byte_num);
						ret = controller->hwecc_correct(controller, page_size, tmp_buf);
						if(ret == NAND_ECC_FAILURE){
							//check rand_mode and 0xff page
							if(controller->zero_cnt < controller->ecc_max){
								all_ff_flag = 1;
								//aml_nand_dbg("found all 0xff page here");
								goto plane0_ff_h;
							}
	//
							need_retry = 0;
							if(retry_info->flag && (slc_mode == 0)) {
								if(flash->new_type != SANDISK_19NM){
									if(retry_cnt++ < retry_op_cnt)
										need_retry = 1;
								}
								else if(flash->new_type == SANDISK_19NM){
									if(up_page){
										if(retry_cnt++ < retry_info->retry_cnt_up){
											need_retry = 1;
										}
									}
									else if(retry_cnt++ < retry_info->retry_cnt_lp){	
										need_retry = 1;
									}
								}
								if(need_retry){
									aml_nand_dbg("read retry at chip %d plane0 page %d and retry_cnt: %d",chipnr, plane0_page_addr, retry_cnt);
									ret = retry_info->handle(controller, chipnr);
									if(ret < 0){
										aml_nand_msg("read retry handle failed at plane0 page:%d", plane0_page_addr);
									}
									goto RETRY_PLANE_CMD;
								}
							}	
	//				
							aml_nand_msg("####uncorrect ecc here at page:%d chip:%d", page_addr, chipnr);
							ops_para->ecc_err++;
						}
						else if(ret < 0){
							aml_nand_msg("failed");
							BUG();
							goto error_exit0;
						}
						else {
							if(retry_cnt){
								if(flash->new_type != SANDISK_19NM){
									if(retry_cnt > (retry_op_cnt-2)){
										aml_nand_dbg("detect bitflip at page:%d", page_addr);
										ops_para->bit_flip++;
									}
								}
								else{
									if(up_page){
										if(retry_cnt > (retry_info->retry_cnt_up-2)){
											aml_nand_dbg("detect bitflip at page:%d", page_addr);
											ops_para->bit_flip++;
										}
									}
									else{
										if(retry_cnt > (retry_info->retry_cnt_lp -2)){
											aml_nand_dbg("detect bitflip at page:%d", page_addr);
											ops_para->bit_flip++;
										}
									}
								}
							}
							else if((controller->ecc_cnt_cur > controller->ecc_cnt_limit) && (flash->new_type == 0)){
								aml_nand_dbg("detect bitflip at  page:%d, chip:%d", page_addr, chipnr);
								ops_para->bit_flip++;
							}
						}
						if(retry_cnt && retry_info->exit){
							ret = retry_info->exit(controller, chipnr);
							if(ret < 0){
								aml_nand_msg("retry exit failed flash->new_type:%d, retry_cnt:%d", flash->new_type, retry_cnt);
							}
						}
							plane0_retry_flag = 1;
							retry_cnt = 0;
					}
plane0_ff_h:
					if(with_data) {
						if(all_ff_flag){
							memset(buf, 0xff, page_size);
						}
						else{
							memcpy(buf, controller->data_buf, page_size);
						}					
						//aml_nand_dbg("read data %x %x %x %x", buf[0], buf[1], buf[2], buf[3]);
						//aml_nand_dbg("read oob %x %x %x %x", oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3]);
						buf += page_size;					
					}
					
					if(with_oob) {
						if(all_ff_flag){
							memset(tmp_buf, 0xff, user_byte_num);
						}
						//memcpy(ops_para->oob_buf, tmp_buf, BYTES_OF_USER_PER_PAGE);
						//aml_nand_dbg("read oob %x %x %x %x", oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3]);
						//oob_buf += user_byte_num;
						tmp_buf += user_byte_num;
						//ops_para->oob_buf += (BYTES_OF_USER_PER_PAGE / (controller->chip_num*plane_num)) ;
					}
					
					all_ff_flag = 0;
				}
				
				controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
				controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, plane1_page_addr>>16, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, NAND_CMD_RNDOUT, NAND_CTRL_CLE);
				controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);			
				controller->cmd_ctrl(controller, NAND_CMD_RNDOUTSTART, NAND_CTRL_CLE);
				
				NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
				
				controller->page_addr = plane1_page_addr;
				ret = controller->dma_read(controller, page_size, bch_mode);
				if(ret){
					aml_nand_msg("dma error here");
					BUG();
					goto error_exit0;
				}
				
				if(bch_mode != NAND_ECC_NONE){
					controller->get_usr_byte(controller, tmp_buf, user_byte_num);
					ret = controller->hwecc_correct(controller, page_size, tmp_buf);
					if(ret == NAND_ECC_FAILURE){
						//check rand_mode and 0xff page
						if(controller->zero_cnt < controller->ecc_max){
							all_ff_flag = 1;
							//aml_nand_dbg("found all 0xff page here");
							goto page_ff;
						}
//
						need_retry = 0;
						if(retry_info->flag && (slc_mode == 0)) {
							if(flash->new_type != SANDISK_19NM){
								if(retry_cnt++ < retry_op_cnt)
									need_retry = 1;
							}
							else if(flash->new_type == SANDISK_19NM){
								if(up_page){
									if(retry_cnt++ < retry_info->retry_cnt_up){
										need_retry = 1;
									}
								}
								else if(retry_cnt++ < retry_info->retry_cnt_lp){	
									need_retry = 1;
								}
							}
							if(need_retry){
								aml_nand_dbg("read retry at chip %d plane1 page %d and retry_cnt: %d",chipnr, plane1_page_addr, retry_cnt);
								ret = retry_info->handle(controller, chipnr);
								if(ret < 0){
									aml_nand_msg("read retry handle failed at plane1 page:%d", plane1_page_addr);
								}
								aml_nand_dbg("plane0_retry_flag %d",plane0_retry_flag);
								goto RETRY_PLANE_CMD;
							}
						}	
//									
						aml_nand_msg("uncorrect ecc here at page:%d", page_addr);
						ops_para->ecc_err++;
						if(retry_info->flag && (flash->new_type)&&(flash->new_type < 10)){
							ret = nand_reset(aml_chip, chipnr);
							if(ret < 0){
							       aml_nand_msg("reset failed after retry failed at chip %d",chipnr); 
							}
						}
					}
					else if(ret){
						aml_nand_msg("failed ");
						BUG();
						goto error_exit0;
					}
					else {
						if(retry_cnt){
							if(flash->new_type != SANDISK_19NM){
								if(retry_cnt > (retry_op_cnt-2)){
									aml_nand_dbg("detect bitflip at page:%d", page_addr);
									ops_para->bit_flip++;
								}
							}
							else{
								if(up_page){
									if(retry_cnt > (retry_info->retry_cnt_up-2)){
										aml_nand_dbg("detect bitflip at page:%d", page_addr);
										ops_para->bit_flip++;
									}
								}
								else{
									if(retry_cnt > (retry_info->retry_cnt_lp -2)){
										aml_nand_dbg("detect bitflip at page:%d", page_addr);
										ops_para->bit_flip++;
									}
								}
							}
						}
						else if((controller->ecc_cnt_cur > controller->ecc_cnt_limit) && (flash->new_type == 0)){
							aml_nand_dbg("detect bitflip at  page:%d, chip:%d", page_addr, chipnr);
							ops_para->bit_flip++;
						}
					}
				}
				if(retry_cnt && retry_info->exit){
					ret = retry_info->exit(controller, chipnr);
					if(ret < 0){
						aml_nand_msg("retry exit failed flash->new_type:%d, retry_cnt:%d", flash->new_type, retry_cnt);
					}
				}
				plane0_retry_flag = 0;
				retry_cnt = 0;
			}
		}
		else{		
			//aml_nand_dbg("page_addr:%d", ops_para->page_addr);
			ret = controller->dma_read(controller, page_size, bch_mode);
			if(ret){
				aml_nand_msg("dma error here");	
				BUG();
				goto error_exit0;
			}
			
			if(bch_mode != NAND_ECC_NONE){
				controller->get_usr_byte(controller, tmp_buf, user_byte_num);
				ret = controller->hwecc_correct(controller, page_size, tmp_buf);
				if(ret == NAND_ECC_FAILURE){
					//check rand_mode and 0xff page
					if(controller->zero_cnt < controller->ecc_max){
						all_ff_flag = 1;
						//aml_nand_dbg("found all 0xff page here");
						goto page_ff;
					}	
					need_retry = 0;
					if(retry_info->flag && (slc_mode == 0)) {
						if(flash->new_type != SANDISK_19NM){
							if(retry_cnt++ < retry_op_cnt)
								need_retry = 1;
						}
						else if(flash->new_type == SANDISK_19NM){
							if(up_page){
								if(retry_cnt++ < retry_info->retry_cnt_up){
									need_retry = 1;
								}
							}
							else if(retry_cnt++ < retry_info->retry_cnt_lp){	
								need_retry = 1;
							}
						}
						
						if(need_retry){
							aml_nand_dbg("read retry at chip %d page %d and retry_cnt: %d",chipnr, page_addr, retry_cnt);
							ret = retry_info->handle(controller, chipnr);
							if(ret < 0){
								aml_nand_msg("read retry handle failed at page:%d", page_addr);
							}
							goto RETRY_CMD;
						}
					}	
					aml_nand_msg("uncorrect ecc here at page:%d, chip:%d", page_addr, chipnr);
					ops_para->ecc_err++;
					if(retry_info->flag && (flash->new_type)&&(flash->new_type < 10)){
						ret = nand_reset(aml_chip, chipnr);
						if(ret < 0){
						       aml_nand_msg("reset failed after retry failed at chip %d",chipnr); 
						}
					}
					
				}
				else if(ret < 0){
					aml_nand_msg("failed ");
					BUG();
					goto error_exit0;
				}
				else{
					if(retry_cnt){
						if(flash->new_type != SANDISK_19NM){
							if(retry_cnt > (retry_op_cnt-2)){
								aml_nand_dbg("detect bitflip at page:%d", page_addr);
								ops_para->bit_flip++;
							}
						}
						else{
							if(up_page){
								if(retry_cnt > (retry_info->retry_cnt_up-2)){
									aml_nand_dbg("detect bitflip at page:%d", page_addr);
									ops_para->bit_flip++;
								}
							}
							else{
								if(retry_cnt > (retry_info->retry_cnt_lp -2)){
									aml_nand_dbg("detect bitflip at page:%d", page_addr);
									ops_para->bit_flip++;
								}
							}
						}
					}
					else if((controller->ecc_cnt_cur > controller->ecc_cnt_limit) && (flash->new_type == 0)){
						aml_nand_dbg("detect bitflip at  page:%d, chip:%d , controller->ecc_cnt_cur %d ,controller->ecc_cnt_limit %d", page_addr, chipnr,controller->ecc_cnt_cur ,controller->ecc_cnt_limit);
						ops_para->bit_flip++;
					}
				}
				if(retry_cnt && retry_info->exit){
					ret = retry_info->exit(controller, chipnr);
					if(ret < 0){
						aml_nand_msg("retry exit failed flash->new_type:%d, retry_cnt:%d", flash->new_type, retry_cnt);
					}
				}
			}
		}
page_ff:				
		if(with_data){
			if(all_ff_flag){
				memset(buf, 0xff, page_size);
			}
			else{
				memcpy(buf, controller->data_buf, page_size);
			}					
			//aml_nand_dbg("read data %x %x %x %x %x %x %x %x", buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);					
			//aml_nand_dbg("read oob %x %x %x %x", oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3]);
			buf += page_size;		
		}
		
		if(with_oob){
			if(all_ff_flag){
				memset(tmp_buf, 0xff, user_byte_num);
			}
			//memcpy( ops_para->oob_buf, tmp_buf, BYTES_OF_USER_PER_PAGE);											
		//	aml_nand_dbg("read oob %x %x %x %x", oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3]);
			//oob_buf += user_byte_num;
			
			tmp_buf += user_byte_num;
		}
		
		all_ff_flag = 0;

		if(check_cmdfifo_size()){
			aml_nand_msg("check cmdfifo size timeout");
			BUG();
		}

	}
new_oob_mod:
	if(with_oob){
		memcpy(ops_para->oob_buf, controller->oob_buf, BYTES_OF_USER_PER_PAGE);
		if(ops_para->ecc_err)
			memset(ops_para->oob_buf,0x22,BYTES_OF_USER_PER_PAGE);		
	}
	
	
	return NAND_SUCCESS;

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
	unsigned char *buf = ops_para->data_buf;
	unsigned char *oob_buf = ops_para->oob_buf;	
	unsigned plane_page_addr, plane_blk_addr, pages_per_blk_shift, page_size;
	unsigned plane0_page_addr, plane1_page_addr, column, page_addr;	
	unsigned char i, bch_mode, plane_num, chip_num, chipnr, user_byte_num; 
	unsigned char slc_mode, status, st_cnt;
	int ret = 0;
    
	if(!buf){
		aml_nand_msg("buf should never be NULL");
		ret = -NAND_ARGUMENT_FAILURE;
		goto error_exit0;
	}
	if(aml_chip->nand_status  != NAND_STATUS_NORMAL){
		aml_nand_msg("nand status unusal: do not write anything!!!!!");
		return NAND_SUCCESS;
	}

	user_byte_num = chipnr = 0;
	plane0_page_addr = plane1_page_addr = 0;

	//for multi-chip mode 
	if(ops_para->option & DEV_MULTI_CHIP_MODE){
		chip_num = controller->chip_num;
		//aml_nand_dbg("DEV_MULTI_CHIP_MODE");
	}
	else{
		chip_num = 1;
	}

	if(ops_para->option & DEV_SLC_MODE){
		//aml_nand_dbg("enable SLC mode");   
		if(flash->new_type == SANDISK_19NM){
			slc_mode = 1;
		}
		else if((flash->new_type > 0) && (flash->new_type <10)){
			slc_mode = 2;  
			//page_addr = slc_info->pagelist[page_addr];
		}
		else{
			slc_mode = 0;
		}
	}
	else{	   
		slc_mode = 0;
	}

	//for multi-plane mode	
	page_addr = ops_para->page_addr;	
	controller->page_addr = ops_para->page_addr;
	pages_per_blk_shift =  (controller->block_shift - controller->page_shift);	
	if(unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *aml_chip->flash.internal_chipnr;
	}
	if(ops_para->option & DEV_MULTI_PLANE_MODE){
		plane_num = 2;
		plane_page_addr = (controller->page_addr & (((1 << pages_per_blk_shift) - 1)));
		plane_blk_addr = (controller->page_addr >> (pages_per_blk_shift));	
		plane_blk_addr <<= 1;
		plane0_page_addr = (plane_blk_addr << pages_per_blk_shift) | plane_page_addr;			
		plane1_page_addr = ((plane_blk_addr + 1) << pages_per_blk_shift) | plane_page_addr;	

#if 0		
		aml_nand_dbg("ops_para->page_addr =%d",ops_para->page_addr);	
		aml_nand_dbg("controller->page_addr =%d",controller->page_addr);
		aml_nand_dbg("plane_page_addr =%d",plane_page_addr);	
		aml_nand_dbg("plane_blk_addr =%d",plane_blk_addr);
		aml_nand_dbg("plane0_page_addr =%d",plane0_page_addr);
		aml_nand_dbg("plane1_page_addr =%d",plane1_page_addr);
#endif
	}
	else{
		plane_num = 1;
	}

	//for ecc mode
	if((ops_para->option & DEV_ECC_SOFT_MODE) || (controller->bch_mode == NAND_ECC_NONE)){
		bch_mode = NAND_ECC_NONE;		
		page_size = flash->pagesize + flash->oobsize;
	}
	else{
		bch_mode = controller->bch_mode;
		user_byte_num = controller->ecc_steps*controller->user_mode;		
		page_size = controller->ecc_steps*controller->ecc_unit;

		/*if (controller->bch_mode == NAND_ECC_BCH_SHORT){
			page_size = (flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;
		}*/
		
		if(!oob_buf){
			memset(controller->oob_buf, 0xa5, (user_byte_num*(plane_num*chip_num)));
			controller->oob_buf[0] = 0xff;
			oob_buf = controller->oob_buf;
		}else{
			memcpy(controller->oob_buf,  ops_para->oob_buf, (user_byte_num*(plane_num*chip_num)));
			oob_buf = controller->oob_buf;
		}

	}	
#if 0	
	aml_nand_dbg("page_addr:%d, buf: %x %x %x %x %x %x %x %x", \
		ops_para->page_addr, buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);

	aml_nand_dbg("page_addr:%d, oob_buf: %x %x %x %x %x %x %x %x", \
		ops_para->page_addr, oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3], oob_buf[4], oob_buf[5], oob_buf[6], oob_buf[7]);
#endif
	column = 0;

	for(i=0; i<chip_num; i++){

		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
				
		ret = controller->quene_rb(controller, chipnr);
		if(ret){
			aml_nand_msg("quene rb busy here");
			goto error_exit0;
		}
#if 0
		if(aml_chip->debug_num == 1)
			aml_nand_dbg("chipnr =%d, chip_num	=%d", chipnr, chip_num );
			aml_nand_dbg("controller->chip_selected =%d",controller->chip_selected);
#endif 
		
		if(plane_num == 2){			
			//plane0
			controller->cmd_ctrl(controller, NAND_CMD_SEQIN, NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr>>16, NAND_CTRL_ALE);

			if(bch_mode != NAND_ECC_NONE){
				controller->set_usr_byte(controller, oob_buf, user_byte_num);
			}

			controller->page_addr = plane0_page_addr;
			ret = controller->dma_write(controller, buf, page_size, bch_mode);
			if(ret){
				aml_nand_msg("dma error here");
				goto error_exit0;
			}

#if  0						
					if(aml_chip->debug_num == 1){
						aml_nand_dbg("ops_para->page_addr =%d",ops_para->page_addr);	
						aml_nand_dbg("controller->page_addr =%d",controller->page_addr);
						aml_nand_dbg("plane_page_addr =%d",plane_page_addr);	
						aml_nand_dbg("plane_blk_addr =%d",plane_blk_addr);
						aml_nand_dbg("plane0_page_addr =%d",plane0_page_addr);
						aml_nand_dbg("plane1_page_addr =%d",plane1_page_addr);

					}		
#endif

			
			controller->cmd_ctrl(controller, NAND_CMD_DUMMY_PROGRAM, NAND_CTRL_CLE);	
		
			NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TADL_TIME_CYCLE);

			ret = controller->quene_rb(controller, chipnr);
			if(ret){
				aml_nand_msg("quene rb busy here");
				goto error_exit0;
			}
			
			oob_buf += user_byte_num;
			
			//oob_buf += (BYTES_OF_USER_PER_PAGE /(controller->chip_num * plane_num));
			buf += page_size;		
			
			if((controller->mfr_type == NAND_MFR_HYNIX) || (controller->mfr_type == NAND_MFR_SAMSUNG)){
				controller->cmd_ctrl(controller, NAND_CMD_TWOPLANE_WRITE2, NAND_CTRL_CLE);
			}
			else{
				controller->cmd_ctrl(controller, NAND_CMD_TWOPLANE_WRITE2_MICRO, NAND_CTRL_CLE);
			}
			
			controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr>>16, NAND_CTRL_ALE);
			
			NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TADL_TIME_CYCLE);

			if(bch_mode != NAND_ECC_NONE){
				controller->set_usr_byte(controller, oob_buf, user_byte_num);
			}

			controller->page_addr = plane1_page_addr;
			ret = controller->dma_write(controller, buf, page_size, bch_mode);
			if(ret){
				aml_nand_msg("dma error here");
				goto error_exit0;
			}			
	
		}
		else{
			if(slc_mode){
				ret = slc_info->enter(controller);
				if(ret < 0){
					aml_nand_msg("slc enter failed here");
				}
			}
			
			//NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TADL_TIME_CYCLE);
			ret = controller->quene_rb(controller, chipnr);
			if(ret){
				aml_nand_msg("quene rb busy here");
			}

			controller->cmd_ctrl(controller, NAND_CMD_SEQIN, NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, column, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, column>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr>>16, NAND_CTRL_ALE);
			//controller->cmd_ctrl(controller, NAND_CMD_PAGEPROG, NAND_CTRL_CLE);
			
			NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TADL_TIME_CYCLE);

			if(bch_mode != NAND_ECC_NONE){
				controller->set_usr_byte(controller, oob_buf, user_byte_num);
			}
#if 0			
			if(aml_chip->debug_num == 1){
				aml_nand_dbg("chipnr =%d",chipnr);
				aml_nand_dbg("controller->page_addr =%d",controller->page_addr);
			}
#endif			
			ret = controller->dma_write(controller, buf, page_size, bch_mode);
			if(ret){
				aml_nand_msg("dma error here");
				goto error_exit0;
			}
#if  0						
			if(1){
				aml_nand_dbg("ops_para->page_addr =%d",ops_para->page_addr);	
				aml_nand_dbg("controller->page_addr =%d",controller->page_addr);
				aml_nand_dbg("plane_page_addr =%d",plane_page_addr);	
				aml_nand_dbg("plane_blk_addr =%d",plane_blk_addr);
				int tt;
				aml_nand_dbg("page_size=%d",page_size);
				for(tt=0; tt<200;tt++){ 
					aml_nand_dbg("buf[%d]=%d",tt,buf[tt]);
				}
			}		
#endif	
		}	
		// start
		controller->cmd_ctrl(controller, NAND_CMD_PAGEPROG, NAND_CTRL_CLE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
		oob_buf += user_byte_num;
		
		//oob_buf += (BYTES_OF_USER_PER_PAGE /(controller->chip_num * plane_num));
		buf += page_size;

		if(check_cmdfifo_size()){
			aml_nand_msg("check cmdfifo size timeout");
			BUG();
		}
	}

	for(i=0; i<chip_num; i++){
		
		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
		st_cnt = 0;	
		ret = controller->quene_rb(controller, chipnr);
		if(ret){
			aml_nand_msg("quene rb busy here");
			goto error_exit0;
		}	

		controller->cmd_ctrl(controller, NAND_CMD_STATUS, NAND_CTRL_CLE); 	
		NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
WSTATUS_TRY:		
		status = controller->readbyte(controller);		
		if(status == NAND_STATUS_FAILED){			
			aml_nand_msg("write falied at page:%d, status:0x%x", page_addr, status);
			ret = -NAND_WRITE_FAILED;
			goto error_exit0;
		}
		else if(status != NAND_STATUS_RIGHT){
		    aml_nand_msg("check status failed at page:%d, status:0x%x and try:%d", page_addr, status, st_cnt);
		    if(st_cnt++ < NAND_STATUS_MAX_TRY){
    		    NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
    		    goto WSTATUS_TRY;
    		}
    		
            aml_nand_msg("######check status still failed at page:%d, status:0x%x and try:%d", page_addr, status, st_cnt);  		  		
		}
		    
		if(slc_mode == 2){   //for hynix nand, reset reg def value
			ret = slc_info->exit(controller);
			if(ret < 0){
				aml_nand_msg("slc enter failed here");
			}
		}
	}

	return NAND_SUCCESS;
	
error_exit0:
	return ret;	
}

static int set_blcok_status(struct amlnand_chip *aml_chip, unsigned char chipnr, unsigned addr,int value)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	unsigned blk_addr = addr;
	unsigned short *tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
	
	tmp_status[blk_addr] = value;
	aml_nand_msg(" NAND bbt set Bad block at %d \n", blk_addr);

	return 0;	
}

static int get_blcok_status(struct amlnand_chip *aml_chip, unsigned char chipnr, unsigned addr)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	unsigned blk_addr = addr;
	unsigned short * tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
#if 0
	aml_nand_dbg("!!!!!show the block statusXXX ");
	int chip = 0, start_block, total_blk = 50;
	unsigned short * tmp_arr;
	for(chip= 0; chip < controller->chip_num; chip++){		
		tmp_arr = &aml_chip->block_status->blk_status[chip][0];  			
			for(start_block=0; start_block < total_blk; start_block++){	
				aml_nand_msg(" tmp_arr[%d][%d]=%d", chip, start_block, tmp_arr[start_block]);
			}
	}
#endif	

	if (tmp_status[blk_addr] == NAND_BLOCK_USED_BAD) {
		aml_nand_dbg(" NAND bbt detect Bad block at chip %d blk %d ",chipnr, blk_addr);
		return  NAND_BLOCK_USED_BAD;
	}
	else if (tmp_status[blk_addr] == NAND_BLOCK_FACTORY_BAD) {
		//aml_nand_dbg(" NAND bbt detect factory Bad block at chip %d blk %d",chipnr, blk_addr);
		return  NAND_BLOCK_FACTORY_BAD; 
	}
	else if (tmp_status[blk_addr] == NAND_BLOCK_GOOD) {		
		return  NAND_BLOCK_GOOD ;	
	}
	else{
		aml_nand_msg("block status is wrong at chip %d blk %d tmp_status[%d] = %d",chipnr,blk_addr, blk_addr, tmp_status[blk_addr]);
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
	struct chip_operation *operation = & aml_chip->operation;

	unsigned blk_addr, page_per_blk_shift;
	unsigned char chip_num = 1, chipnr;
	unsigned char  oob_buf[8];
	int ret = 0;

	if(ops_para->option & DEV_MULTI_CHIP_MODE){
		chip_num = controller->chip_num;		
		//aml_nand_dbg(" chip_num =%d ",chip_num);
	}

	page_per_blk_shift = ffs(flash->blocksize) -ffs(flash->pagesize);
	blk_addr = ops_para->page_addr >> page_per_blk_shift;
	chipnr = ops_para->chipnr;
	if(unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *aml_chip->flash.internal_chipnr;
	}
	//aml_nand_dbg("ops_para->page_addr = %d",ops_para->page_addr);
	//aml_nand_dbg("chipnr= %d",chipnr);
	//aml_nand_dbg("blk_addr= %d",blk_addr);
	
	if(/*(aml_chip->nand_bbtinfo.arg_valid) &&*/ (aml_chip->block_status != NULL)){
		
		if((ops_para->option  & DEV_MULTI_PLANE_MODE) && (!(ops_para->option & DEV_MULTI_CHIP_MODE))){
	
			blk_addr <<= 1;
			//aml_nand_dbg(" DEV_MULTI_PLANE_MODE  &&  !DEV_MULTI_CHIP_MODE");
			ret = get_blcok_status(aml_chip, chipnr, blk_addr); 
			if(ret == NAND_BLOCK_GOOD ){
				if((blk_addr % 2) == 0){ 	// plane 0 is good , check plane 1
					ret = get_blcok_status(aml_chip, chipnr, (blk_addr+1));
				}
				else {				// plane 1 is good, check plane 0
					ret = get_blcok_status(aml_chip, chipnr, (blk_addr -1));
					}
				}
		}
		else if((!(ops_para->option  & DEV_MULTI_PLANE_MODE)) && ((ops_para->option & DEV_MULTI_CHIP_MODE))){
			
			//aml_nand_dbg(" !DEV_MULTI_PLANE_MODE  &&  DEV_MULTI_CHIP_MODE");
			for(chipnr=0; chipnr < controller->chip_num; chipnr++){  //multi_chip 
				ret = get_blcok_status(aml_chip, chipnr, blk_addr);
				if(ret != NAND_BLOCK_GOOD){
					break;
				}
			}
		}
		else if ((ops_para->option  & DEV_MULTI_PLANE_MODE) && (ops_para->option & DEV_MULTI_CHIP_MODE)){
			
			//aml_nand_dbg(" DEV_MULTI_PLANE_MODE  &&  DEV_MULTI_CHIP_MODE");
			blk_addr <<= 1;
			ret = get_blcok_status(aml_chip, chipnr, blk_addr);
			if(ret == 0 ){
				for(chipnr=0; chipnr < controller->chip_num; chipnr++){  	
					ret = get_blcok_status(aml_chip, chipnr, blk_addr);
					if(ret != NAND_BLOCK_GOOD)
						break;
					if((blk_addr % 2) == 0){ // plane 0 is good , check plane 1
						ret = get_blcok_status(aml_chip, chipnr, (blk_addr+1));
						if(ret != NAND_BLOCK_GOOD)
							break;
					}
					else {			// plane 1 is good, check plane 0
						ret = get_blcok_status(aml_chip, chipnr, (blk_addr -1));
						if(ret != NAND_BLOCK_GOOD)
							break;
					}
				}
			}			
		}
		else{	
			ret = get_blcok_status(aml_chip, chipnr, blk_addr);
		}	
	}
	else{	 

		ops_para->data_buf = controller->page_buf;
		ops_para->oob_buf = controller->oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		memset(ops_para->data_buf, 0x0, flash->pagesize);
		memset(ops_para->oob_buf, 0x0, sizeof(oob_buf));
		
#ifdef AML_NAND_UBOOT
		nand_get_chip();
#else
		nand_get_chip(aml_chip);
#endif		
		ret = operation->read_page(aml_chip);	 
#ifdef AML_NAND_UBOOT
		nand_release_chip();
#else
		nand_release_chip(aml_chip);
#endif	
		 if((ret < 0)||(ops_para->ecc_err)){
			aml_nand_msg("nand read page failed at %d chip %d",ops_para->page_addr, ops_para->chipnr);
			ret = -NAND_READ_FAILED;
			goto exit_error0;
		 }		 
		 
		 if(ops_para->oob_buf[0] == 0){
			aml_nand_msg("nand detect bad blk at %d chip %d",blk_addr, ops_para->chipnr);
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
	struct chip_operation *operation = & aml_chip->operation;

	unsigned blk_addr, pages_per_blk_shift;
	unsigned char chip_num = 1, chipnr;
	unsigned short * tmp_status;
	int ret;

	if(ops_para->option & DEV_MULTI_CHIP_MODE){
		chip_num = controller->chip_num;		
	}
	
	pages_per_blk_shift = ffs(flash->blocksize) -ffs(flash->pagesize);
	blk_addr = ops_para->page_addr >> pages_per_blk_shift;
	chipnr = ops_para->chipnr;
	if(unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *aml_chip->flash.internal_chipnr;
	}
	aml_nand_dbg("blk_addr =%d",blk_addr);
	
	if((aml_chip->nand_bbtinfo.arg_valid) && (aml_chip->block_status != NULL)){
		
		tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
		if ((tmp_status[blk_addr] == NAND_BLOCK_USED_BAD) ||(tmp_status[blk_addr] == NAND_BLOCK_FACTORY_BAD)) {
			return 0;
		}
		else if ((tmp_status[blk_addr] == NAND_BLOCK_GOOD)){
			if((ops_para->option  & DEV_MULTI_PLANE_MODE) && (!(ops_para->option & DEV_MULTI_CHIP_MODE))){
				blk_addr <<= 1;
				if((blk_addr % 2) == 0){ // plane 0 is good , set plane 1
					ret = set_blcok_status(aml_chip, chipnr, (blk_addr), NAND_BLOCK_USED_BAD);
					ret = set_blcok_status(aml_chip, chipnr, (blk_addr+1), NAND_BLOCK_USED_BAD);
					aml_nand_dbg("set blk bad at chip %d blk %d", chipnr, blk_addr);
					aml_nand_dbg("set blk bad at chip %d blk %d", chipnr, (blk_addr+1));
				}
				else {			// plane 1 is good, set plane 0
					ret = set_blcok_status(aml_chip, chipnr, (blk_addr), NAND_BLOCK_USED_BAD);
					ret = set_blcok_status(aml_chip, chipnr, (blk_addr -1), NAND_BLOCK_USED_BAD);					
					aml_nand_dbg("set blk bad at chip %d blk %d",  chipnr, blk_addr);
					aml_nand_dbg("set blk bad at chip %d blk %d", chipnr, (blk_addr-1));
					}
			}
			else if ((!(ops_para->option  & DEV_MULTI_PLANE_MODE)) && ((ops_para->option & DEV_MULTI_CHIP_MODE))){

				for(chipnr=0; chipnr < controller->chip_num; chipnr++){  //multi_chip 
					ret = set_blcok_status(aml_chip, chipnr, blk_addr, NAND_BLOCK_USED_BAD);
					aml_nand_dbg(" set blk bad at chip %d blk %d",  chipnr, blk_addr);
				}
			}
			else if ((ops_para->option  & DEV_MULTI_PLANE_MODE) && (ops_para->option & DEV_MULTI_CHIP_MODE)){
				blk_addr <<= 1;
				for(chipnr=0; chipnr < controller->chip_num; chipnr++){  	
					if((blk_addr % 2) == 0){ 	// plane 0 is good , set plane 1
						ret = set_blcok_status(aml_chip, chipnr, (blk_addr+1), NAND_BLOCK_USED_BAD);						
						aml_nand_dbg("set blk bad at chip %d blk %d", chipnr, (blk_addr+1));
					}
					else {			// plane 1 is good, set plane 0
						ret = set_blcok_status(aml_chip, chipnr, (blk_addr -1), NAND_BLOCK_USED_BAD);
						aml_nand_dbg(" set blk bad at chip %d blk %d", chipnr, (blk_addr-1));
					}
									//multi_chip , set every chip_blk
						ret = set_blcok_status(aml_chip, chipnr, blk_addr, NAND_BLOCK_USED_BAD);
						aml_nand_dbg(" set blk bad at chip %d blk %d",chipnr, blk_addr);
					}
			}
			else{
				ret = set_blcok_status(aml_chip, chipnr, blk_addr, NAND_BLOCK_USED_BAD);			
				aml_nand_dbg(" set blk bad at chip %d blk %d",chipnr, blk_addr);
			}
			
			ret = amlnand_update_bbt(aml_chip);
			if(ret < 0){		
				aml_nand_msg("nand update bbt failed");
			}
			
		}
	}

#if 0
//show the changed block status 
 	aml_nand_dbg("show the changed block status ");
	for(chipnr= 0; chipnr < controller->chip_num; chipnr++){		
		tmp_arr = &aml_chip->block_status->blk_status[chipnr][0];  			
			for(start_block=0; start_block < 100; start_block++){	
				aml_nand_msg(" tmp_arr[%d][%d]=%d", chipnr, start_block, tmp_arr[start_block]);
			}
	}
#endif	

	//memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
	//ops_para->page_addr = blk_addr << pages_per_blk_shift;
	//ops_para->chipnr = blk_addr % controller->chip_num;
	controller->select_chip(controller, ops_para->chipnr );
	ops_para->data_buf = controller->page_buf;
	ops_para->oob_buf =controller->oob_buf;
	memset((unsigned char *)ops_para->data_buf, 0x0, flash->pagesize );
	memset((unsigned char *)ops_para->oob_buf, 0x0, flash->oobsize);
	
#ifdef AML_NAND_UBOOT
		nand_get_chip();
#else
    if(aml_chip->state == CHIP_READY)
		nand_get_chip(aml_chip);
#endif		
	ret = operation->write_page(aml_chip);
#ifdef AML_NAND_UBOOT
		nand_release_chip();
#else
    if(aml_chip->state == CHIP_READY)
		nand_release_chip(aml_chip);
#endif	
	if(ret < 0){		
		aml_nand_msg(" nand write failed");
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
	unsigned plane_page_addr, plane_blk_addr, pages_per_blk_shift;
	unsigned plane0_page_addr, plane1_page_addr, chipnr;	
	unsigned char slc_mode, chip_num = 1, plane_num = 1, status, st_cnt;
	int i, ret = 0;

	//aml_nand_dbg("page_addr:%d", ops_para->page_addr);
	if(aml_chip->nand_status  != NAND_STATUS_NORMAL){
		aml_nand_msg("nand status unusal: do not erase anything!!!!!");
		return NAND_SUCCESS;
	}

	if(ops_para->option & DEV_MULTI_CHIP_MODE){
		chip_num = controller->chip_num;		
	}

	if(ops_para->option & DEV_SLC_MODE){
		aml_nand_dbg("enable SLC mode");   
		if(flash->new_type == SANDISK_19NM){
			slc_mode = 1;
		}
		else{
			slc_mode = 0;
		}
	}
	else{	   
	   slc_mode = 0;
	}

	controller->page_addr = ops_para->page_addr;

	pages_per_blk_shift = ffs(flash->blocksize) -ffs(flash->pagesize);
	if(unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *aml_chip->flash.internal_chipnr;
	}
	plane0_page_addr = plane1_page_addr = 0;
	if(ops_para->option & DEV_MULTI_PLANE_MODE){
		plane_num = 2;
		plane_page_addr = (controller->page_addr & ((1 << pages_per_blk_shift) - 1));
		plane_blk_addr = (controller->page_addr >> pages_per_blk_shift);
		plane_blk_addr <<=1;
		plane0_page_addr = (plane_blk_addr << pages_per_blk_shift)| plane_page_addr;		
		plane1_page_addr = ((plane_blk_addr + 1) << pages_per_blk_shift)| plane_page_addr;
	}

	for(i=0; i<chip_num; i++){

		chipnr = (chip_num > 1) ? i : ops_para->chipnr;

		ret = controller->quene_rb(controller, chipnr);
		if(ret){
			aml_nand_msg("quene rb busy here, chipnr:%d, page_addr:%d", chipnr, controller->page_addr);
			goto error_exit0;
		}

		if(plane_num == 2){
			controller->cmd_ctrl(controller, NAND_CMD_ERASE1, NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, plane0_page_addr, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane0_page_addr>>16, NAND_CTRL_ALE);
			if((controller->mfr_type == NAND_MFR_MICRON) || (controller->mfr_type == NAND_MFR_MICRON)){
				controller->cmd_ctrl(controller, NAND_CMD_ERASE1_END, NAND_CTRL_CLE);				
				NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
				ret = controller->quene_rb(controller, chipnr);
				if(ret){
					aml_nand_msg("quene rb busy here, chipnr:%d, page_addr:%d", chipnr, controller->page_addr);
					goto error_exit0;
				}
			}
			
			controller->cmd_ctrl(controller, NAND_CMD_ERASE1, NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, plane1_page_addr, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, plane1_page_addr>>16, NAND_CTRL_ALE);
			
			controller->cmd_ctrl(controller, NAND_CMD_ERASE2, NAND_CTRL_CLE);		
			
			NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);

		}
		else{
			if(slc_mode){
				ret = slc_info->enter(controller);
				if(ret < 0){
					aml_nand_msg("slc enter failed here");
				}
			}
			controller->cmd_ctrl(controller, NAND_CMD_ERASE1, NAND_CTRL_CLE);
			controller->cmd_ctrl(controller, controller->page_addr, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr>>8, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, controller->page_addr>>16, NAND_CTRL_ALE);
			controller->cmd_ctrl(controller, NAND_CMD_ERASE2, NAND_CTRL_CLE);
			
			NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
		}

		if(check_cmdfifo_size()){
			aml_nand_msg("check cmdfifo size timeout");
			BUG();
		}
			
	}
	
	for(i=0; i<chip_num;i++){
		
		chipnr = (chip_num > 1) ? i : ops_para->chipnr;
        st_cnt = 0;
		ret = controller->quene_rb(controller, chipnr);
		if(ret){
			aml_nand_msg("quene rb busy here, chipnr:%d, page_addr:%d", chipnr, controller->page_addr);
			goto error_exit0;
		}	

		controller->cmd_ctrl(controller, NAND_CMD_STATUS, NAND_CTRL_CLE); 	
		NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
		
ESTATUS_TRY:		
		status = controller->readbyte(controller);		
		if(status == NAND_STATUS_FAILED){			
			aml_nand_msg("erase falied at chipnr:%d page:%d, status:0x%x",\
			                 chipnr, controller->page_addr, status);
			ret = -NAND_WRITE_FAILED;
			goto error_exit0;
		}
		else if(status != NAND_STATUS_RIGHT){
		    aml_nand_msg("check erase status failed at chipnr:%d page:%d, status:0x%x and try:%d",\
		                     chipnr, controller->page_addr, status, st_cnt);
		    if(st_cnt++ < NAND_STATUS_MAX_TRY){
    		    NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
    		    goto ESTATUS_TRY;
    		}
    		
            aml_nand_msg("######check erase status still failed at chipnr:%d page:%d, status:0x%x and try:%d", \
                                chipnr, controller->page_addr, status, st_cnt);  		  		
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
static int test_block(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct nand_flash *flash = &aml_chip->flash;
	struct en_slc_info *slc_info = &(controller->slc_info);
	
	unsigned char phys_erase_shift, phys_page_shift, nand_boot;  
	unsigned i, offset,pages_per_blk, pages_read, amount_loaded =0,blk_addr = 0;
	unsigned char  oob_buf[8];
	unsigned short total_blk;
	int  ret = 0, len,t=0;

	unsigned char *dat_buf =NULL;
    blk_addr = ops_para->page_addr;
	dat_buf  = aml_nand_malloc(flash->pagesize);
	if(!dat_buf){
		aml_nand_msg("test_block: malloc failed");
		ret =  -1;
		goto exit;
	}
	memset(dat_buf, 0xa5, flash->pagesize);
	

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift)); 

	pages_read = pages_per_blk;

//#ifdef AML_NAND_UBOOT
//	nand_get_chip();
//#else
//	nand_get_chip(aml_chip);
//#endif	
    //erase
    aml_nand_msg("erase addr = %ld",ops_para->page_addr);

	ret = erase_block(aml_chip); 	
	if(ret < 0){
		aml_nand_msg("nand blk erase failed");
		ret =  -1;
		goto exit;
	}
    aml_nand_msg("nand blk %ld erase OK",blk_addr);
    #if 1
    //read
    memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
    ops_para->page_addr = blk_addr;
	for(t = 0; t < pages_read; t++){
		memset(aml_chip->user_page_buf, 0x0, flash->pagesize);
        ops_para->page_addr += t;
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = read_page(aml_chip);
		if(ret < 0){
			aml_nand_msg("nand read %ld failed",blk_addr);
			ret =  -1;
			goto exit;
		}
		//aml_nand_dbg("aml_chip->user_page_buf: ");
		//show_data_buf(aml_chip->user_page_buf);
		//aml_nand_dbg("dat_buf: ");
		//show_data_buf(dat_buf);
	}
    aml_nand_msg("nand blk read OK");
    
    //write
    memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
    ops_para->page_addr = blk_addr;
    for(t = 0; t < pages_read; t++){
        memset( aml_chip->user_page_buf, 0xa5, flash->pagesize);
        ops_para->page_addr += t;
        ops_para->data_buf = aml_chip->user_page_buf;
        ops_para->oob_buf = aml_chip->user_oob_buf;
        ops_para->ooblen = sizeof(oob_buf);

        ret = write_page(aml_chip);
        if(ret < 0){
            aml_nand_msg("nand write failed");
            ret =  -1;
            goto exit;
        }
    }
    aml_nand_msg("nand blk %d write OK",blk_addr);
    //read
	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
    ops_para->page_addr = blk_addr;
	for(t = 0; t < pages_read; t++){
		memset(aml_chip->user_page_buf, 0x0, flash->pagesize);
        ops_para->page_addr += t;
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = read_page(aml_chip);
		if(ret < 0){
			aml_nand_msg("nand read failed");
			ret =  -1;
			goto exit;
		}
		//aml_nand_dbg("aml_chip->user_page_buf: ");
		//show_data_buf(aml_chip->user_page_buf);
		//aml_nand_dbg("dat_buf: ");
		//show_data_buf(dat_buf);
	}
    aml_nand_msg("nand blk %d read OK",blk_addr);
    //erase
    ops_para->page_addr = blk_addr;
	ret = erase_block(aml_chip); 	
	if(ret < 0){
		aml_nand_msg("nand blk erase failed");
		ret =  -1;
		goto exit;
	}
    aml_nand_msg("nand blk %d erase OK",blk_addr);
    #endif
exit:
//#ifdef AML_NAND_UBOOT
//        nand_release_chip();
//#else
//        nand_release_chip(aml_chip);
//#endif

        if(dat_buf){
            aml_nand_free(dat_buf);
            dat_buf=NULL;
        }
    
        if(!ret){
            aml_nand_msg("blk test OK");
        }
        
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
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct nand_flash *flash = &aml_chip->flash;
	struct en_slc_info *slc_info = &(controller->slc_info);
	
	unsigned char phys_erase_shift, phys_page_shift, nand_boot;  
	unsigned i, offset,pages_per_blk, pages_read, amount_loaded =0;
	unsigned char  oob_buf[8];
	unsigned short total_blk, tmp_blk;
	int  ret = 0, len,t=0;

	unsigned char *dat_buf =NULL;

	dat_buf  = aml_nand_malloc(flash->pagesize);
	if(!dat_buf){
		aml_nand_msg("test_block: malloc failed");
		ret =  -1;
		goto exit;
	}
	memset(dat_buf, 0xa5, flash->pagesize);
	
	nand_boot = 1;

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else {
		offset = 0;
	}

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift)); 

	tmp_blk = (offset >> phys_erase_shift); 

	if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;
	
	if(ops_para->option & DEV_SLC_MODE){
		pages_read = pages_per_blk >> 1;
	}else{
		pages_read = pages_per_blk;
	}

#ifdef AML_NAND_UBOOT
	nand_get_chip();
#else
	nand_get_chip(aml_chip);
#endif	
    //erase
	ops_para->page_addr =(((tst_blk - tst_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
	ops_para->chipnr = tst_blk % controller->chip_num;
	controller->select_chip(controller, ops_para->chipnr );
	ret = erase_block(aml_chip); 	
	if(ret < 0){
		aml_nand_msg("nand blk %d erase failed", tst_blk);
		ret =  -1;
		goto exit;
	}
    //write
    for(t = 0; t < pages_read; t++){
        memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
        if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
            ops_para->option |= DEV_SLC_MODE;
        ops_para->page_addr =(t+(((tst_blk - tst_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
        ops_para->chipnr = tst_blk % controller->chip_num;    
        controller->select_chip(controller, ops_para->chipnr );

        if((ops_para->option & DEV_SLC_MODE)) {
            if((flash->new_type > 0) && (flash->new_type <10))
                ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
            if (flash->new_type == SANDISK_19NM) 
                ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
        }

        memset( aml_chip->user_page_buf, 0xa5, flash->pagesize);
        ops_para->data_buf = aml_chip->user_page_buf;
        ops_para->oob_buf = aml_chip->user_oob_buf;
        ops_para->ooblen = sizeof(oob_buf);

        ret = write_page(aml_chip);
        if(ret < 0){
            aml_nand_msg("nand write failed");
            ret =  -1;
            goto exit;
        }
    }
    //read
	for(t = 0; t < pages_read; t++){
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
		if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE;
		ops_para->page_addr =(t+(((tst_blk - tst_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
		ops_para->chipnr = tst_blk % controller->chip_num;	
		controller->select_chip(controller, ops_para->chipnr );

		if((ops_para->option & DEV_SLC_MODE)) {
			if((flash->new_type > 0) && (flash->new_type <10))
				ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
			if (flash->new_type == SANDISK_19NM) 
				ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
		}

		
		memset(aml_chip->user_page_buf, 0x0, flash->pagesize);
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = read_page(aml_chip);
		if(ret < 0){
			aml_nand_msg("nand read failed");
			ret =  -1;
			goto exit;
		}
		//aml_nand_dbg("tst_blk %d aml_chip->user_page_buf: ",tst_blk);
		//show_data_buf(aml_chip->user_page_buf);
		//aml_nand_dbg("tst_blk %d dat_buf: ",tst_blk);
		//show_data_buf(dat_buf);
		if(memcmp(aml_chip->user_page_buf,dat_buf,flash->pagesize)){
			ret =  -1;
			aml_nand_msg("blk  %d,  page %d : test failed",tst_blk, t);
			goto exit;
		}
	}
    //erase
	ops_para->page_addr =(((tst_blk - tst_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
	ops_para->chipnr = tst_blk % controller->chip_num;
	controller->select_chip(controller, ops_para->chipnr );
	ret = erase_block(aml_chip); 	
	if(ret < 0){
		aml_nand_msg("nand blk %d erase failed", tst_blk);
		ret =  -1;
		goto exit;
	}

exit:
#ifdef AML_NAND_UBOOT
        nand_release_chip();
#else
        nand_release_chip(aml_chip);
#endif
    
        if(dat_buf){
            aml_nand_free(dat_buf);
            dat_buf=NULL;
        }
    
        if(!ret){
            aml_nand_msg("blk %d test OK",tst_blk);
        }
        
        return ret;
}
/************************************************************
 * all parameters saved in aml_chip->ops_para.
 * for opteration mode, contains multi-plane/multi-chip
 * supposed chip bbt has been installed
 *
 *************************************************************/
static int blk_modify_bbt_chip_op(struct amlnand_chip *aml_chip,int value)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_ops_para *ops_para = &aml_chip->ops_para;	
	struct chip_operation *operation = & aml_chip->operation;

	unsigned blk_addr, page_per_blk_shift;
	unsigned char chip_num = 1, chipnr;
	unsigned char  oob_buf[8];
	int ret = 0;

	if(ops_para->option & DEV_MULTI_CHIP_MODE){
		chip_num = controller->chip_num;		
		//aml_nand_dbg(" chip_num =%d ",chip_num);
	}

	page_per_blk_shift = ffs(flash->blocksize) -ffs(flash->pagesize);
	blk_addr = ops_para->page_addr >> page_per_blk_shift;
	chipnr = ops_para->chipnr;
	if(unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *aml_chip->flash.internal_chipnr;
	}
		
		if((ops_para->option  & DEV_MULTI_PLANE_MODE) && (!(ops_para->option & DEV_MULTI_CHIP_MODE))){
	
			blk_addr <<= 1;
			//aml_nand_dbg(" DEV_MULTI_PLANE_MODE  &&  !DEV_MULTI_CHIP_MODE");
			ret = set_blcok_status(aml_chip, chipnr, blk_addr,value); 
			if(ret == 0 ){
				if((blk_addr % 2) == 0){ 	// plane 0 is good , check plane 1
					ret = set_blcok_status(aml_chip, chipnr, (blk_addr+1),value);
				}
				else {				// plane 1 is good, check plane 0
					ret = set_blcok_status(aml_chip, chipnr, (blk_addr -1),value);
					}
				}
		}
		else if((!(ops_para->option  & DEV_MULTI_PLANE_MODE)) && ((ops_para->option & value))){
			
			//aml_nand_dbg(" !DEV_MULTI_PLANE_MODE  &&  DEV_MULTI_CHIP_MODE");
			for(chipnr=0; chipnr < controller->chip_num; chipnr++){  //multi_chip 
				ret = set_blcok_status(aml_chip, chipnr, blk_addr,value);
				if(ret != 0){
					break;
				}
			}
		}
		else if ((ops_para->option  & DEV_MULTI_PLANE_MODE) && (ops_para->option & DEV_MULTI_CHIP_MODE)){
			
			//aml_nand_dbg(" DEV_MULTI_PLANE_MODE  &&  DEV_MULTI_CHIP_MODE");
			blk_addr <<= 1;
			ret = set_blcok_status(aml_chip, chipnr, blk_addr,value);
			if(ret == 0 ){
				for(chipnr=0; chipnr < controller->chip_num; chipnr++){  	
					ret = set_blcok_status(aml_chip, chipnr, blk_addr,value);
					if(ret != 0)
						break;
					if((blk_addr % 2) == 0){ // plane 0 is good , check plane 1
						ret = set_blcok_status(aml_chip, chipnr, (blk_addr+1),value);
						if(ret != 0)
							break;
					}
					else {			// plane 1 is good, check plane 0
						ret = set_blcok_status(aml_chip, chipnr, (blk_addr -1),value);
						if(ret != 0)
							break;
					}
				}
			}			
		}
		else{	
			ret = set_blcok_status(aml_chip, chipnr, blk_addr,value);
		}	
	


	return ret;
	
exit_error0:

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
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_ops_para *ops_para = &aml_chip->ops_para;	
	struct chip_operation *operation = & aml_chip->operation;

	unsigned blk_addr, pages_per_blk_shift;
	unsigned char chip_num = 1, chipnr;
	unsigned short * tmp_status;
	int ret;

	if(ops_para->option & DEV_MULTI_CHIP_MODE){
		chip_num = controller->chip_num;		
	}
	
	pages_per_blk_shift = ffs(flash->blocksize) -ffs(flash->pagesize);
	blk_addr = ops_para->page_addr >> pages_per_blk_shift;
	chipnr = ops_para->chipnr;
	if(unlikely(controller->page_addr >= controller->internal_page_nums)) {
		controller->page_addr -= controller->internal_page_nums;
		controller->page_addr |= controller->internal_page_nums *aml_chip->flash.internal_chipnr;
	}
	
	aml_nand_msg("###nand update start!!!!\n");

		
	ret = amlnand_update_bbt(aml_chip);
	if(ret < 0){		
		aml_nand_msg("nand update bbt failed");
	}
		

	return ret;
}


/************************************************************
 * get_onfi_features, for onfi feature operation
 *
 *************************************************************/
static int get_onfi_features(struct amlnand_chip *aml_chip,  unsigned char *buf, int addr)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int i, j;

	for (i=0; i<controller->chip_num; i++) {
		controller->select_chip(controller, i);
		controller->cmd_ctrl(controller, NAND_CMD_GET_FEATURES, NAND_CTRL_CLE);
		controller->cmd_ctrl(controller, addr, NAND_CTRL_ALE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

		for (j=0; j<4; j++)
			buf[j] = controller->readbyte(controller);
	}

	return 0;
}

/************************************************************
 * set_onfi_features, for onfi feature operation
 *
 *************************************************************/
static int set_onfi_features(struct amlnand_chip *aml_chip,  unsigned char *buf, int addr)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int i, j;
	int time_out_cnt = 0;

	for (i=0; i<controller->chip_num; i++) {
		controller->select_chip(controller, i);
		controller->cmd_ctrl(controller, NAND_CMD_SET_FEATURES, NAND_CTRL_CLE);			
		controller->cmd_ctrl(controller, addr, NAND_CTRL_ALE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TADL_TIME_CYCLE);
		NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

		for (j=0; j<4; j++)
			controller->writebyte(controller, buf[j]);

		//NFC_SEND_CMD_RB(controller->chip_selected, 20);
		do{
			if (NFC_CMDFIFO_SIZE() <= 0)
				break;
			udelay(2);
		}while (time_out_cnt++ <= AML_NAND_READ_BUSY_TIMEOUT);

		if(time_out_cnt >= AML_NAND_READ_BUSY_TIMEOUT)
			return -NAND_BUSY_FAILURE;		
	}
	
	return NAND_SUCCESS;
}

/************************************************************
 * nand_reset, send reset command, and assume nand selected here
 * 
 *************************************************************/
int nand_reset(struct amlnand_chip *aml_chip, unsigned char chipnr)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int status;
	//reset 
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	controller->cmd_ctrl(controller, NAND_CMD_RESET, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);	
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	
	//read status
	//controller->cmd_ctrl(controller, NAND_CMD_STATUS, NAND_CTRL_CLE);
	//NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
	
	//NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

	if(controller->quene_rb(controller, chipnr) < 0){
		aml_nand_dbg("quene rb failed here");
		return -NAND_BUSY_FAILURE;
	}

	controller->cmd_ctrl(controller, NAND_CMD_STATUS, NAND_CTRL_CLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

	while(NFC_CMDFIFO_SIZE());
	
	status = (int)controller->readbyte(controller);
	if (status & NAND_STATUS_READY){
		return NAND_SUCCESS;
	}
	
	aml_nand_dbg("check status failed and status:0x%x", status);
	
	return -NAND_BUSY_FAILURE;
}

/************************************************************
 * read_id
 * @id_addr: for 00H and 20H;
 * @buf: chip id stored into buf;
 *************************************************************/
static int read_id(struct amlnand_chip *aml_chip, unsigned char chipnr, unsigned char id_addr, unsigned char *buf)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int i, ret = 0;

	if(buf == NULL){
		aml_nand_msg("buf must not be NULL here");
		ret = -NAND_ARGUMENT_FAILURE;
		goto error_exit0;
	}
	
	ret = controller->select_chip(controller, chipnr);
	if(ret < 0){
		aml_nand_msg("select chip %d failed",chipnr);
		goto error_exit0;
	}
	
	ret = nand_reset(aml_chip, chipnr);
	if(ret < 0){
	    if(chipnr == 0)
	       aml_nand_msg("reset failed"); 
	    else
		aml_nand_dbg("reset failed");
		goto error_exit0;
	}

	//send id cmd
	controller->cmd_ctrl(controller, NAND_CMD_READID, NAND_CTRL_CLE);
	controller->cmd_ctrl(controller, id_addr, NAND_CTRL_ALE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

	/* Read manufacturer and device IDs */
	for (i=0; i<MAX_ID_LEN; i++) {
		buf[i] = controller->readbyte(controller);
	}

error_exit0:	
	return ret;

}

int amlnand_init_operation(struct amlnand_chip *aml_chip)
{
	struct chip_operation *operation = &(aml_chip->operation);

	if(!operation->reset)
		operation->reset = nand_reset;
	if(!operation->read_id)
		operation->read_id = read_id;
	if(!operation->set_onfi_para)
		operation->set_onfi_para = set_onfi_features;
	if(!operation->get_onfi_para)
		operation->get_onfi_para = get_onfi_features;

	if(!operation->check_wp)
		operation->check_wp = check_wp;	

	if(!operation->erase_block)
		operation->erase_block = erase_block;
    
	if(!operation->test_block)
		operation->test_block = test_block; 
    
	if(!operation->test_block_reserved)
		operation->test_block_reserved = test_block_reserved; 
    
	if(!operation->block_isbad)
		operation->block_isbad = block_isbad;
	
	if(!operation->block_markbad)
		operation->block_markbad = block_markbad;

	if(!operation->read_page)
		operation->read_page = read_page;
	
	if(!operation->write_page)
		operation->write_page = write_page;	
    
	if(!operation->blk_modify_bbt_chip_op)
		operation->blk_modify_bbt_chip_op = blk_modify_bbt_chip_op;

	if(!operation->update_bbt_chip_op)
		operation->update_bbt_chip_op = update_bbt_chip_op;

	return NAND_SUCCESS;
	
}

