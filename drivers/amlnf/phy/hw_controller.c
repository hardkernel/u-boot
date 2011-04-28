/*****************************************************************
**                                                              
**  Copyright (C) 2012 Amlogic,Inc.  All rights reserved                         
**                                           
**        Filename : hw_controller.c       	
**        Revision : 1.001	                                        
**        Author: Benjamin Zhao
**        Description: 
**			hw controller operation function,  mainly init nand phy driver.
**        		
**            
*****************************************************************/
#include "../include/phynand.h"

static int controller_select_chip(struct hw_controller *controller, unsigned char chipnr)
{
	int i, ret = 0;
	
	switch (chipnr) {
		case 0:
		case 1:
		case 2:
		case 3:
			controller->chip_selected = controller->ce_enable[chipnr];
			controller->rb_received = controller->rb_enable[chipnr];
#ifdef AML_NAND_UBOOT
			for (i=0; i < controller->chip_num; i++) {
				pinmux_select_chip(controller->ce_enable[i], controller->rb_enable[i], ((controller->option & NAND_CTRL_NONE_RB) == 0));	
			}
#endif

			NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

			break;

		default:
			BUG();
			controller->chip_selected = CE_NOT_SEL;
			ret = -NAND_SELECT_CHIP_FAILURE;
			aml_nand_msg("failed");
			break;
	}
		
	return ret;
}

static int controller_quene_rb(struct hw_controller *controller, unsigned char chipnr)
{
	unsigned time_out_limit, time_out_cnt = 0;
	struct amlnand_chip *aml_chip = controller->aml_chip;
	int ret = 0;

	if(aml_chip->state == CHIP_RESETING){
		time_out_limit = AML_NAND_ERASE_BUSY_TIMEOUT;
	}
	else 	if(aml_chip->state == CHIP_WRITING){
		time_out_limit = AML_NAND_WRITE_BUSY_TIMEOUT;
	}
	else{
		time_out_limit = AML_NAND_READ_BUSY_TIMEOUT;
	}
		
	//aml_nand_dbg("chipnr =%d",chipnr);

	controller->select_chip(controller, chipnr);
	
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	while(NFC_CMDFIFO_SIZE() > 0);

#if 0 
	NFC_SEND_CMD_RB(aml_chip->chip_enable, 20);

	NFC_SEND_CMD_IDLE(aml_chip->chip_selected, 0);
	NFC_SEND_CMD_IDLE(aml_chip->chip_selected, 0);

	do {
		if (NFC_CMDFIFO_SIZE() <= 0)
			break;
	}while (time_out_cnt++ <= AML_DMA_BUSY_TIMEOUT);

#endif
	
	//udelay(2);
	if (controller->option & NAND_CTRL_NONE_RB) {		
		controller->cmd_ctrl(controller, NAND_CMD_STATUS, NAND_CTRL_CLE);	
		//aml_nand_dbg("controller->chip_selected =%d",controller->chip_selected);
		NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWHR_TIME_CYCLE);
		
	   	do{
    			//udelay(chip->chip_delay);
	    		if ((int)controller->readbyte(controller) & NAND_STATUS_READY)
	    			break;
	    		udelay(1);
    		}while(time_out_cnt++ <= time_out_limit);   //200ms max

	}
	else{
		do{
			if (NFC_GET_RB_STATUS(controller->rb_received))
				break;			
			udelay(2);
    		}while(time_out_cnt++ <= time_out_limit);

	}

	if(time_out_cnt >=  time_out_limit)
		ret = -NAND_BUSY_FAILURE;
	
	return ret;
}

static int controller_hwecc_correct(struct hw_controller *controller, unsigned size, unsigned char *oob_buf)
{
	unsigned ecc_step_num, cur_ecc, usr_info;
	unsigned info_times_int_len = PER_INFO_BYTE/sizeof(unsigned int);
	struct amlnand_chip *aml_chip = controller->aml_chip;
	int max_ecc = 0;
	int user_offset = 0;
		
	if(controller->oob_mod ==1)
		user_offset = 4;
	if (size % controller->ecc_unit) {
		aml_nand_msg("error parameter size for ecc correct %x, and ecc_unit:%x", size, controller->ecc_unit);
		return -NAND_ARGUMENT_FAILURE;
	}

	controller->ecc_cnt_cur = 0;
	 for (ecc_step_num = 0; ecc_step_num < (size /controller->ecc_unit); ecc_step_num++) {
	 	//check if there have uncorrectable sector	 	
		usr_info = (*(unsigned *)(&(controller->user_buf[ecc_step_num*info_times_int_len +user_offset])));
	 	cur_ecc = NAND_ECC_CNT(usr_info);
		//aml_nand_dbg("uncorrected for cur_ecc:%d, usr_buf[%d]:%x", cur_ecc, ecc_step_num, usr_info);
		if(cur_ecc == 0x3f){
            		controller->zero_cnt = NAND_ZERO_CNT(usr_info);
			if(max_ecc < controller->zero_cnt) {
				max_ecc =  controller->zero_cnt;
			}
			//aml_nand_dbg("uncorrected for ecc_step_num:%d, zero_cnt:%d", ecc_step_num, controller->zero_cnt);
			return NAND_ECC_FAILURE;
	 	}
	 	else {
			controller->ecc_cnt_cur = (controller->ecc_cnt_cur > cur_ecc) ? controller->ecc_cnt_cur : cur_ecc;
			if(max_ecc < controller->ecc_cnt_cur) {
				max_ecc =  controller->ecc_cnt_cur;
			}
		}
	}
	 aml_chip->max_ecc_per_page = max_ecc;

	return 0;
}

//default enable ran mode
static int controller_dma_read(struct hw_controller *controller, unsigned len, unsigned char bch_mode)
{
	int count, dma_unit_size, info_times_int_len, time_out_cnt,dma_cnt;
	volatile unsigned int * info_buf = 0;
	volatile int cmp=0;

	dma_unit_size = 0;
	info_times_int_len = PER_INFO_BYTE/sizeof(unsigned int);
	if (bch_mode == NAND_ECC_NONE){
		if(len >0x3fff)
			len = 0x3ffe;
		count = 1;
	}
	else if (bch_mode == NAND_ECC_BCH_SHORT) {
		dma_unit_size = (controller->ecc_unit >> 3);
		count = len/controller->ecc_unit;
	}
	else{
		count = controller->ecc_steps;
	}
	dma_cnt = count;
	if((controller->oob_mod ==1) &&(bch_mode != NAND_ECC_NONE)){
		count += 16 /PER_INFO_BYTE;
	}
	
	info_buf = (volatile unsigned *)&(controller->user_buf[(count-1)*info_times_int_len]);
	memset((unsigned char *)controller->user_buf, 0, count*PER_INFO_BYTE);

	//set_nphy_dma_addr(count, len, controller->data_buf, controller->user_buf);

#ifndef AML_NAND_UBOOT
	smp_wmb();
	wmb();
	
	//while(NFC_CMDFIFO_SIZE() > 10);
	NFC_SEND_CMD_ADL(controller->data_dma_addr);
	NFC_SEND_CMD_ADH(controller->data_dma_addr);
	NFC_SEND_CMD_AIL(controller->info_dma_addr);
	NFC_SEND_CMD_AIH(controller->info_dma_addr);		
#else
	dcache_flush_range((unsigned)controller->user_buf, count*PER_INFO_BYTE);
	dcache_invalid_range((unsigned)controller->data_buf, len);
	
	//while(NFC_CMDFIFO_SIZE() > 10);
	NFC_SEND_CMD_ADL((int)controller->data_buf);
	NFC_SEND_CMD_ADH((int)controller->data_buf);
	NFC_SEND_CMD_AIL((int)controller->user_buf);
	NFC_SEND_CMD_AIH((int)controller->user_buf);		
#endif

	
	//setting page_addr used for seed
	NFC_SEND_CMD_SEED(controller->page_addr);
	
	if(bch_mode == NAND_ECC_NONE){
		NFC_SEND_CMD_N2M_RAW(controller->ran_mode, len);
	}
	else{
		NFC_SEND_CMD_N2M(controller->ran_mode, ((bch_mode == NAND_ECC_BCH_SHORT)?NAND_ECC_BCH60_1K:bch_mode), \
									((bch_mode == NAND_ECC_BCH_SHORT)?1:0), dma_unit_size, dma_cnt);
	}

#if 0
	NFC_SEND_CMD_STS(20, 2);
#else
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

	time_out_cnt = 0;
	do {
		if (NFC_CMDFIFO_SIZE() <= 0)
			break;
	}while (time_out_cnt++ <= AML_DMA_BUSY_TIMEOUT);

	if(time_out_cnt >= AML_DMA_BUSY_TIMEOUT){
		aml_nand_msg("dma timeout here");
		return -NAND_DMA_FAILURE;
	}
		
#endif

#ifndef AML_NAND_UBOOT
	do{
	    smp_rmb();
	}while(NAND_INFO_DONE(*info_buf) == 0);
	
	smp_wmb();
	wmb();
#else
	do{
		dcache_invalid_range((unsigned)controller->user_buf, count*PER_INFO_BYTE);
		info_buf = (volatile unsigned *)&(controller->user_buf[(count-1)*info_times_int_len]);	
		cmp = *info_buf;
	}while((cmp)==0);

#endif
	//aml_nand_dbg("len:%d, count:%d, bch_mode:%d\n", len, count, bch_mode);

	return NAND_SUCCESS;
}

static int controller_dma_write(struct hw_controller *controller, unsigned char *buf, int len, unsigned char bch_mode)
{
	int ret = 0, time_out_cnt = 0, oob_fill_cnt = 0;
	unsigned dma_unit_size = 0, count = 0;

	if (bch_mode == NAND_ECC_NONE){
		if(len >0x3fff)
			len = 0x3ffe;
		count = 1;
	}
	else if (bch_mode == NAND_ECC_BCH_SHORT) {
		dma_unit_size = (controller->ecc_unit >> 3);	
		count = len /controller->ecc_unit;
	}
	else{
		count = controller->ecc_steps;
	}

        memcpy(controller->data_buf, buf, len);
		
   //set_nphy_dma_addr(count, len, controller->data_buf, controller->user_buf);
#ifndef AML_NAND_UBOOT
	smp_wmb();
	wmb();

	NFC_SEND_CMD_ADL(controller->data_dma_addr);
	NFC_SEND_CMD_ADH(controller->data_dma_addr);
	NFC_SEND_CMD_AIL(controller->info_dma_addr);
	NFC_SEND_CMD_AIH(controller->info_dma_addr);		
#else
	dcache_flush_range((unsigned)controller->user_buf, count*PER_INFO_BYTE);
	dcache_flush_range((unsigned)controller->data_buf, len);
	NFC_SEND_CMD_ADL((int)controller->data_buf);
	NFC_SEND_CMD_ADH((int)controller->data_buf);
	NFC_SEND_CMD_AIL((int)controller->user_buf);
	NFC_SEND_CMD_AIH((int)controller->user_buf);		
#endif

	NFC_SEND_CMD_SEED(controller->page_addr);
	
	if(!bch_mode) {
		NFC_SEND_CMD_M2N_RAW(0, len);
	}
	else{
		NFC_SEND_CMD_M2N(controller->ran_mode, ((bch_mode == NAND_ECC_BCH_SHORT)?NAND_ECC_BCH60_1K:bch_mode), \
					((bch_mode == NAND_ECC_BCH_SHORT)?1:0), dma_unit_size, count);
	}

	if (bch_mode == NAND_ECC_BCH_SHORT){
		oob_fill_cnt = controller->oob_fill_boot;
	}else if(bch_mode != NAND_ECC_NONE){
		oob_fill_cnt = controller->oob_fill_data;
	}

	if(((bch_mode != NAND_ECC_NONE))&&(oob_fill_cnt > 0)){
		//aml_nand_dbg("fill oob   controller oob_fill_cnt %d",oob_fill_cnt);
		NFC_SEND_CMD_M2N_RAW(controller->ran_mode, oob_fill_cnt);
	}
	 else if (bch_mode == NAND_ECC_NONE) {
	 	NFC_SEND_CMD_ADL((int)controller->data_buf);
		NFC_SEND_CMD_ADH((int)controller->data_buf);
	 	NFC_SEND_CMD_M2N_RAW(0, controller->oobavail);
	}
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

	time_out_cnt = 0;
	do {
		if (NFC_CMDFIFO_SIZE() <= 0)
			break;
	}while (time_out_cnt++ <= AML_DMA_BUSY_TIMEOUT);

	if(time_out_cnt >= AML_DMA_BUSY_TIMEOUT){
		aml_nand_msg("dma timeout here");
		return -NAND_DMA_FAILURE;
	}

	return ret;		 
}


/*
  * aml_nand_hw_init function.
  * init hwcontroller CFG register setting, 
  * 
  */
static int controller_hw_init(struct hw_controller *controller)
{
	int sys_clk_rate, sys_time, start_cycle, end_cycle, bus_cycle, bus_timing, Tcycle, T_REA = DEFAULT_T_REA, T_RHOH = DEFAULT_T_RHOH;
	int ret = 0;

	sys_clk_rate = 212;
	get_sys_clk_rate(&sys_clk_rate);

	sys_time = (10000 / sys_clk_rate);

	#if 0
	start_cycle = (((NAND_CYCLE_DELAY + T_REA * 10) * 10) / sys_time);
	start_cycle = (start_cycle + 9) / 10;

	for (bus_cycle = 4; bus_cycle <= MAX_CYCLE_NUM; bus_cycle++) {
		Tcycle = bus_cycle * sys_time;
		end_cycle = (((NAND_CYCLE_DELAY + Tcycle / 2 + T_RHOH * 10) * 10) / sys_time);
		end_cycle = end_cycle / 10;
		if ((((start_cycle >= 3) && (start_cycle <= ( bus_cycle + 1)))
			|| ((end_cycle >= 3) && (end_cycle <= (bus_cycle + 1))))
			&& (start_cycle <= end_cycle)) {
			break;
		}			
	}
	if (bus_cycle > MAX_CYCLE_NUM){
		aml_nand_msg("timming failed bus_cycle:%d", bus_cycle);
		return -NAND_FAILED;
	}

	bus_timing = (start_cycle + end_cycle) / 2;
	#else
	bus_cycle  = 5;	
	bus_timing = bus_cycle +2;
	#endif
	NFC_SET_CFG(0);
	NFC_SET_TIMING_ASYC(bus_timing, (bus_cycle - 1));
	NFC_SEND_CMD(1<<31);
	aml_nand_dbg("init bus_cycle=%d, bus_timing=%d, system=%d.%dns",
		bus_cycle, bus_timing, sys_time/10, sys_time%10);
	return ret;
}

static int controller_adjust_timing(struct hw_controller *controller)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);
	int sys_clk_rate, sys_time, start_cycle, end_cycle, bus_cycle, bus_timing, Tcycle;

	if (!flash->T_REA ||(flash->T_REA < 16))
		flash->T_REA = 16;
	if (!flash->T_RHOH ||(flash->T_RHOH < 15) )
		flash->T_RHOH = 15;

	if(flash->T_REA >16)
		sys_clk_rate = 212;
	else
		sys_clk_rate = 255;
	
	get_sys_clk_rate(&sys_clk_rate);

	sys_time = (10000 / sys_clk_rate);
	//sys_time = (10000 / (sys_clk_rate / 1000000));
	#if 0
	start_cycle = (((NAND_CYCLE_DELAY + flash->T_REA * 10) * 10) / sys_time);
	start_cycle = (start_cycle + 9) / 10;

	for (bus_cycle = 6; bus_cycle <= MAX_CYCLE_NUM; bus_cycle++) {
		Tcycle = bus_cycle * sys_time;
		end_cycle = (((NAND_CYCLE_DELAY + Tcycle / 2 + flash->T_RHOH * 10) * 10) / sys_time);
		end_cycle = end_cycle / 10;
		if ((((start_cycle >= 3) && (start_cycle <= ( bus_cycle + 1)))
			|| ((end_cycle >= 3) && (end_cycle <= (bus_cycle + 1))))
			&& (start_cycle <= end_cycle)) {
			break;
		}			
	}
	if (bus_cycle > MAX_CYCLE_NUM){
		aml_nand_msg("timming failed bus_cycle:%d, sys_time%d, flash->T_REA:%d, flash->T_RHOH:%d", \
						bus_cycle, sys_time, flash->T_REA, flash->T_RHOH);
		return -NAND_FAILED;
	}


	bus_timing = (start_cycle + end_cycle) / 2;
	#else
	bus_cycle  = 5;	
	bus_timing = bus_cycle +2;
	#endif
	NFC_SET_CFG(0);
	NFC_SET_TIMING_ASYC(bus_timing, (bus_cycle - 1));
	
#if defined (AML_NAND_NEW_OOB) && defined (CONFIG_NAND_AML_M8)
	if(flash->pagesize > 4096){
		aml_nand_msg("AML_NAND_NEW_OOB : new oob");
		NFC_SET_OOB_MODE(3<<26);
		controller->oob_mod = 1;
	}else{
		controller->oob_mod = 0;	
	}
#else
	controller->oob_mod = 0;	
#endif
	NFC_SEND_CMD(1<<31);
	aml_nand_msg("bus_cycle=%d, bus_timing=%d,system=%d.%dns,flash->T_REA =%d,flash->T_RHOH=%d",
		bus_cycle, bus_timing, sys_time/10, sys_time%10,flash->T_REA,flash->T_RHOH);

	return NAND_SUCCESS;
}

/*
  *options confirm here, including ecc mode
  */
static int controller_ecc_confirm(struct hw_controller *controller)
{
	struct amlnand_chip *aml_chip = controller->aml_chip;
	struct nand_flash *flash = &(aml_chip->flash);
	struct bch_desc *ecc_supports = controller->bch_desc;	
	unsigned max_bch_mode = controller->max_bch;
	unsigned options_support = 0, ecc_bytes, i;

	if(controller->option & NAND_ECC_SOFT_MODE){
		controller->ecc_unit = flash->pagesize + flash->oobsize;
		controller->bch_mode = NAND_ECC_NONE;
		aml_nand_msg("soft ecc mode");
		return NAND_SUCCESS;
	}
	
	for(i=(max_bch_mode-1); i>0; i--){
		ecc_bytes = flash->oobsize/(flash->pagesize/ecc_supports[i].unit_size);
		if(ecc_bytes >= ecc_supports[i].bytes + ecc_supports[i].usr_mode){
			options_support = ecc_supports[i].mode;
			break;
		}
	}
	
	switch (options_support) {

		case NAND_ECC_BCH8_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_SIZE;
			controller->ecc_bytes = NAND_BCH8_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH8;
			controller->user_mode = 2;
			controller->ecc_cnt_limit = 6;
		  	controller->ecc_max = 8;
			break;

		case NAND_ECC_BCH8_1K_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_1KSIZE;
			controller->ecc_bytes = NAND_BCH8_1K_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH8_1K;
			controller->user_mode = 2;
			controller->ecc_cnt_limit = 6;
		  	controller->ecc_max = 8;
			break;

		case NAND_ECC_BCH16_1K_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_1KSIZE;
			controller->ecc_bytes = NAND_BCH16_1K_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH16_1K;
			controller->user_mode = 2;
			controller->ecc_cnt_limit = 14;
		  	controller->ecc_max = 16;
			break;

		case NAND_ECC_BCH24_1K_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_1KSIZE;
			controller->ecc_bytes = NAND_BCH24_1K_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH24_1K;
			controller->user_mode = 2;
			controller->ecc_cnt_limit = 22;
		  	controller->ecc_max = 24;
			break;

		case NAND_ECC_BCH30_1K_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_1KSIZE;
			controller->ecc_bytes = NAND_BCH30_1K_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH30_1K;
			controller->user_mode = 2;
			controller->ecc_cnt_limit = 26;
		  	controller->ecc_max = 30;
			break;

		case NAND_ECC_BCH40_1K_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_1KSIZE;
			controller->ecc_bytes = NAND_BCH40_1K_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH40_1K;
			controller->user_mode = 2;
			controller->ecc_cnt_limit = 34;
		  	controller->ecc_max = 40;
			break;

		case NAND_ECC_BCH50_1K_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_1KSIZE;
			controller->ecc_bytes = NAND_BCH50_1K_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH50_1K;
			controller->user_mode = 2;
			controller->ecc_cnt_limit = 45;
		  	controller->ecc_max = 50;
			break;

		case NAND_ECC_BCH60_1K_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_1KSIZE;
			controller->ecc_bytes = NAND_BCH60_1K_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH60_1K;
			controller->user_mode = 2;
			controller->ecc_cnt_limit = 55;
		  	controller->ecc_max = 60;
			break;

		case NAND_ECC_SHORT_MODE:
			controller->ecc_unit = NAND_ECC_UNIT_SHORT;
			controller->ecc_bytes = NAND_BCH60_1K_ECC_SIZE;
			controller->bch_mode = NAND_ECC_BCH_SHORT;
			controller->user_mode = 2;			
			controller->ecc_cnt_limit = 55;
		  	controller->ecc_max = 60;
			break;

		default :
			aml_nand_msg("no match ecc mode here, options_support:%d, controller->max_bch:%d, controller->option:%x",\
				options_support, controller->max_bch, controller->option);
			return -NAND_ARGUMENT_FAILURE;
			break;
	}

	controller->ecc_steps = (flash->pagesize+flash->oobsize)/(controller->ecc_unit + controller->ecc_bytes + controller->user_mode);
	controller->oobavail = controller->ecc_steps*controller->user_mode;
	controller->oobtail = flash->pagesize - controller->ecc_steps*(controller->ecc_unit + controller->ecc_bytes + controller->user_mode);	
	controller->oob_fill_data= (flash->oobsize - ( controller->ecc_steps * (controller->ecc_bytes+controller->user_mode)));
	controller->oob_fill_boot = (flash->pagesize+flash->oobsize) -512;
	controller->ran_mode = 1;
	aml_nand_dbg("ecc_unit:%d, ecc_bytes:%d, ecc_steps:%d, ecc_max:%d", \
		controller->ecc_unit, controller->ecc_bytes, controller->ecc_steps, controller->ecc_max);	
	aml_nand_dbg("bch_mode:%d, user_mode:%d, oobavail:%d, oobtail:%d, oob_fill_data %d, controller->oob_fill_boot %d", \
		controller->bch_mode, controller->user_mode, controller->oobavail, controller->oobtail,controller->oob_fill_data,controller->oob_fill_boot);	
	
	return NAND_SUCCESS;
}

static void controller_cmd_ctrl(struct hw_controller *controller, unsigned cmd,  unsigned ctrl)
{
	if (cmd == NAND_CMD_NONE)
		return;
	
	if (ctrl & NAND_CLE)
		cmd=NFC_CMD_CLE(controller->chip_selected, cmd);
	else
		cmd=NFC_CMD_ALE(controller->chip_selected, cmd);

	NFC_SEND_CMD(cmd);   
}

static void controller_write_byte(struct hw_controller *controller, unsigned char data)
{
	NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
	NFC_SEND_CMD_DWR(controller->chip_selected, data);
	NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);
	
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

	while(NFC_CMDFIFO_SIZE()>0);
	
}

static unsigned char controller_read_byte(struct hw_controller *controller)
{
	NFC_SEND_CMD_DRD(controller->chip_selected,0) ;
	NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);

	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);
	NFC_SEND_CMD_IDLE(controller->chip_selected, 0);

	while(NFC_CMDFIFO_SIZE()>0);
	
	return nandphy_readb();//readb(controller->IO_ADDR_R);	
}


static void controller_get_user_byte(struct hw_controller *controller, unsigned char *oob_buf, unsigned char byte_num)
{
	int read_times = 0;
	unsigned int len = PER_INFO_BYTE/sizeof(unsigned int);
	
	if(controller->oob_mod ==1) {
		memcpy(oob_buf,(unsigned char *)controller->user_buf,byte_num);

		return ;
	}
	while (byte_num > 0) {
		*oob_buf++ = (controller->user_buf[read_times*len] & 0xff);
		byte_num--;
		if (controller->user_mode == 2) {
			*oob_buf++ = ((controller->user_buf[read_times*len] >> 8) & 0xff);
			byte_num--;
		}
		read_times++;
	}
}

static void controller_set_user_byte(struct hw_controller *controller, unsigned char *oob_buf, unsigned char byte_num)
{
	int write_times = 0;
	unsigned int len = PER_INFO_BYTE/sizeof(unsigned int);
	unsigned char *usr_info;
	usr_info = (unsigned char *)controller->user_buf ;
	if(controller->oob_mod ==1) {
		memcpy((unsigned char *)controller->user_buf,oob_buf,byte_num);
		return ;
	}
	while (byte_num > 0) {
		controller->user_buf[write_times*len] = *oob_buf++;
		byte_num--;
		if (controller->user_mode == 2) {
			controller->user_buf[write_times*len] |= (*oob_buf++ << 8);
			byte_num--;
		}
		write_times++;
	}
}


/*
  * fill hw_controller struct.
  * including hw init, option setting and operation function.
  * 
  */
 int amlnand_hwcontroller_init(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	int i, tmp_num = 0,ret = 0;	
		
	if (!controller->init)
		controller->init = controller_hw_init;
	if (!controller->adjust_timing)
		controller->adjust_timing = controller_adjust_timing;
	if (!controller->ecc_confirm)
		controller->ecc_confirm = controller_ecc_confirm;
	if (!controller->cmd_ctrl)
		controller->cmd_ctrl = controller_cmd_ctrl;
	if (!controller->select_chip)
		controller->select_chip = controller_select_chip;
	if (!controller->quene_rb)
		controller->quene_rb= controller_quene_rb;
	if (!controller->dma_read)
		controller->dma_read = controller_dma_read;
	if (!controller->dma_write)
		controller->dma_write = controller_dma_write;
	if (!controller->hwecc_correct)
		controller->hwecc_correct = controller_hwecc_correct;	
	if (!controller->readbyte)
		controller->readbyte = controller_read_byte;		
	if (!controller->writebyte)
		controller->writebyte= controller_write_byte;	
	if (!controller->get_usr_byte)
		controller->get_usr_byte = controller_get_user_byte;		
	if (!controller->set_usr_byte)
		controller->set_usr_byte = controller_set_user_byte;	

	for (i=0; i<MAX_CHIP_NUM; i++) {
		controller->ce_enable[i] = (((CE_PAD_DEFAULT >> i*4) & 0xf) << 10);
		controller->rb_enable[i] = (((RB_PAD_DEFAULT>> i*4) & 0xf) << 10);
	}

	//setting default value for option
	controller->option |= NAND_CTRL_NONE_RB;
	controller->option |= NAND_ECC_BCH60_1K_MODE;	

	controller->aml_chip = aml_chip;

#ifndef 	AML_NAND_UBOOT
	amlphy_prepare(0);
#endif

	ret = controller->init(controller);
	if(ret){
		aml_nand_msg("controller hw init failed");
	}

	controller->bch_desc = (struct bch_desc *)&bch_list[0];
	for(i = 0; i < MAX_ECC_MODE_NUM; i++){
		if(bch_list[i].name == NULL){
			break;
		}
		tmp_num++;
	}
	
	controller->max_bch  = tmp_num;
	//controller->max_bch = sizeof(bch_list) / sizeof(bch_list[0]);
	return ret;	
}

