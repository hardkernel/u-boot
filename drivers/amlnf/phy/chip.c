/*****************************************************************
**                                                              
**  Copyright (C) 2012 Amlogic,Inc.  All rights reserved                         
**                                           
**        Filename : chip.c       	
**        Revision : 1.001	                                        
**        Author: Benjamin Zhao
**        Description: 
**			chip init/bbt/config/scan function,  mainly for nand phy driver.
**        		
**            
*****************************************************************/
#include "../include/phynand.h"

static int get_flash_type(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct chip_operation *operation = &(aml_chip->operation);
	unsigned char dev_id[MAX_ID_LEN] = {0};
	struct nand_flash *type = NULL;
	int ret = 0, i, extid;

	ret = operation->read_id(aml_chip, 0, NAND_CMD_ID_ADDR_NORMAL, &dev_id[0]);	
	if(ret < 0){
		aml_nand_dbg("read id failed and ret:0x%x", ret);
		goto error_exit;
	}
	
	aml_nand_msg("NAND device id: %x %x %x %x %x %x %x %x", \
					dev_id[0], dev_id[1], dev_id[2], dev_id[3], dev_id[4], dev_id[5], dev_id[6], dev_id[7]);

#ifdef AML_SLC_NAND_SUPPORT
		/* Lookup the slc flash id */
	for (i = 0; flash_ids_slc[i].name != NULL; i++) {
		if(dev_id[1] == flash_ids_slc[i].id[1]){
			type = &flash_ids_slc[i];
			break;
		}
	}
#endif	
	if (type){
		aml_nand_msg("detect slc nand here");
		controller->flash_type = NAND_TYPE_SLC;
	}
	else{
#ifdef AML_MLC_NAND_SUPPORT
			/* Lookup the mlc flash id */
		for (i = 0; flash_ids_mlc[i].name != NULL; i++) {
			if(!strncmp((char*)flash_ids_mlc[i].id, (char*)dev_id, strlen((const char*)flash_ids_mlc[i].id))){
				type = &flash_ids_mlc[i];
				break;
			}
		}
#endif
		if (!type){
			aml_nand_msg("no matched id");
			ret = -NAND_ID_FAILURE;
			goto error_exit; 
		}
		controller->flash_type= NAND_TYPE_MLC;

	}	

	memcpy(&(aml_chip->flash), type, sizeof(struct nand_flash));
	controller->mfr_type = type->id[0];

	aml_nand_dbg("check type->T_REA:%d, type->T_RHOH:%d, flash:%d %d",\
		type->T_REA, type->T_RHOH, aml_chip->flash.T_REA, aml_chip->flash.T_RHOH);

	aml_nand_msg("detect NAND device: %s", type->name);

#ifdef AML_SLC_NAND_SUPPORT	
	type = &aml_chip->flash;

	/* Newer devices have all the information in additional id bytes */
	if (!type->pagesize) {
		/* The 3rd id byte holds MLC / multichip data */
		controller->readbyte(controller);
		/* The 4th id byte is the important one */
		extid = controller->readbyte(controller);
		/* Calc pagesize */
		type->pagesize = 1024 << (extid & 0x3);
		extid >>= 2;
		/* Calc oobsize */
		type->oobsize = (8 << (extid & 0x01)) * (type->pagesize>>9);
		extid >>= 2;
		/* Calc blocksize. Blocksize is multiples of 64KiB */
		type->blocksize = (64 * 1024) << (extid & 0x03);
		extid >>= 2;
		/* Get buswidth information */
		aml_nand_msg("detect nand buswidth:%s",  (extid & 0x02) ? "16bit" : "8bit");
		if(extid & 0x02){
			aml_nand_msg("do not support 16bit buswidth yet");
			ret = -NAND_ID_FAILURE;
			goto error_exit; ;
		}
	}
#endif

#ifdef AML_MLC_NAND_SUPPORT
	//read onfi id
	ret = operation->read_id(aml_chip, 0, NAND_CMD_ID_ADDR_ONFI, &dev_id[0]);	
	if(ret < 0){
		aml_nand_msg("read id failed and ret:0x%x", ret);
		goto error_exit;
	}
	
	controller->page_shift =  ffs(aml_chip->flash.pagesize) - 1;
	controller->block_shift =  ffs(aml_chip->flash.blocksize) - 1;
	controller->internal_page_nums = ((aml_chip->flash.chipsize<<(20 - controller->page_shift)) /aml_chip->flash.internal_chipnr);
	aml_nand_dbg("controller->internal_page_nums =%d,aml_chip->flash.internal_chipnr=%d",controller->internal_page_nums,aml_chip->flash.internal_chipnr);
	if(!memcmp((char*)dev_id, "ONFI", 4)){
		controller->onfi_mode = type->onfi_mode;
	}	
#endif

error_exit:	
	return ret;
}


/*
  * fill amlnand_chip struct.
  * including chip partnum detect and multi-chip num detect function.
  * 
  */
static int amlnand_chip_scan(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct chip_operation *operation = &(aml_chip->operation);
	unsigned char dev_id[MAX_ID_LEN] = {0};
	unsigned char onfi_features[4] = {0};
 	int i, t, chip_num, ret = 0;

	//should setting nand pinmux first
#ifdef AML_NAND_UBOOT
	nand_get_chip();
#else
	nand_get_chip(aml_chip);
#endif	
	ret = get_flash_type(aml_chip);
	if(ret<0){
		aml_nand_msg("get_chip_type and ret:%x", ret);
		goto error_exit0;
	}

	controller->chip_num = MAX_CHIP_NUM;//1;
	controller->option |= NAND_CTRL_NONE_RB;
	chip_num = 1;

		/* Check for a chip array */
	for (i = 1; i < MAX_CHIP_NUM; i++) {
		memset(&dev_id[0], 0, MAX_ID_LEN);
		ret = operation->read_id(aml_chip, i, NAND_CMD_ID_ADDR_NORMAL, &dev_id[0]);		
		if(ret<0){
			aml_nand_dbg("read id failed and ret:%d", ret);
			continue;
		}
		//memcmp((char*)&(aml_chip->flash.id[0]), (char*)&dev_id[0], MAX_ID_LEN)
		
		aml_nand_dbg("controller->flash_type =%d",controller->flash_type);
		if(((controller->flash_type == NAND_TYPE_SLC)  ||(controller->flash_type == NAND_TYPE_MLC))&&
			(aml_chip->flash.id[1] == dev_id[1])){
			controller->ce_enable[chip_num] = (((CE_PAD_DEFAULT >> i*4) & 0xf) << 10);
			controller->rb_enable[chip_num] = (((RB_PAD_DEFAULT>> i*4) & 0xf) << 10);
			chip_num++;
			
		}
	}

	controller->chip_num = chip_num;
	
	if(controller->chip_num > 1){
		if(controller->chip_num == MAX_CHIP_NUM){
			aml_chip->flash.option &= ~(NAND_MULTI_PLANE_MODE);	
			aml_nand_msg("detected %d NAND chips,and disable two_plane mode", controller->chip_num);		
		}else
		aml_nand_msg("detected %d NAND chips",controller->chip_num);		
	}

	if (controller->onfi_mode) {
		operation->set_onfi_para(aml_chip, (unsigned char *)&(controller->onfi_mode), ONFI_TIMING_ADDR);
		operation->get_onfi_para(aml_chip, onfi_features, ONFI_TIMING_ADDR);
		if (onfi_features[0] != controller->onfi_mode) {
			aml_chip->flash.T_REA = DEFAULT_T_REA;
			aml_chip->flash.T_RHOH = DEFAULT_T_RHOH;
			aml_nand_msg("onfi timing mode set failed: %x", onfi_features[0]);		
		}
	}
	
	ret = NAND_SUCCESS;
	
error_exit0:
		//should clear nand pinmux here
#ifdef AML_NAND_UBOOT
	nand_release_chip();
#else
	nand_release_chip(aml_chip);
#endif
	return ret;
}


/*
  * fill aml_nand_buf_init struct.
  * malloc tmp buf and dma buf here.
  * 
  */
static int nand_buf_init(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &aml_chip->flash;
	unsigned buf_size;
	int err = 0;
	
	controller->ecc_unit = NAND_ECC_UNIT_SIZE;

#ifndef 	AML_NAND_UBOOT
	controller->data_buf = dma_alloc_coherent(NULL, (flash->pagesize + flash->oobsize), &controller->data_dma_addr, GFP_KERNEL);
#else
	controller->data_buf = aml_nand_malloc(flash->pagesize + flash->oobsize);
#endif
	if (!controller->data_buf) {
		aml_nand_msg("no memory for data buf, and need %x", (flash->pagesize + flash->oobsize));
		err = -NAND_MALLOC_FAILURE;
		goto exit_error0;
	}

	
	buf_size = (flash->pagesize /controller->ecc_unit)*PER_INFO_BYTE;
	buf_size += 16;
#ifndef 	AML_NAND_UBOOT
	controller->user_buf = dma_alloc_coherent(NULL, buf_size, &(controller->info_dma_addr), GFP_KERNEL);//amlnf_dma_malloc(buf_size, 1);
#else
	controller->user_buf = aml_nand_malloc(buf_size);
#endif
	if (!controller->user_buf) {
		aml_nand_msg("no memory for usr info buf, and need %x", buf_size);
		err = -NAND_MALLOC_FAILURE;
		goto exit_error1;
	}

	buf_size = (flash->pagesize + flash->oobsize)* controller->chip_num;
	if(flash->option & NAND_MULTI_PLANE_MODE){
		buf_size <<= 1;
	}		
	controller->page_buf = aml_nand_malloc(buf_size) ;
	if (!controller->page_buf) {
		aml_nand_msg("no memory for data buf, and need %x", buf_size);
		err = -NAND_MALLOC_FAILURE;
		goto exit_error2;
	}	

	buf_size = flash->oobsize * controller->chip_num;
	if(flash->option & NAND_MULTI_PLANE_MODE){
		buf_size <<= 1;
	}		
	controller->oob_buf = aml_nand_malloc(buf_size) ;
	if (!controller->oob_buf) {
		aml_nand_msg("no memory for data buf, and need %x", buf_size);
		err = -NAND_MALLOC_FAILURE;
		goto exit_error3;
	}
	
#ifndef 	AML_NAND_UBOOT
	//if (request_irq(INT_NAND, (irq_handler_t)nand_interrupt_monitor, 0, "anl_nand", aml_chip)) {
		//printk("request SDIO irq error!!!\n");
		//return -1;
	//}	
#endif	

	return NAND_SUCCESS;

exit_error3:	
	aml_nand_free(controller->page_buf);
exit_error2:	
#ifndef 	AML_NAND_UBOOT
	amlnf_dma_free(controller->user_buf, (flash->pagesize /controller->ecc_bytes)*sizeof(int), 1);
#else
	aml_nand_free(controller->user_buf);
#endif
exit_error1:	
#ifndef 	AML_NAND_UBOOT
		amlnf_dma_free(controller->data_buf, (flash->pagesize + flash->oobsize), 0);
#else
		aml_nand_free(controller->data_buf);
#endif
exit_error0:

	return err;
}

   /*
	 * fill free malloc buf here.
	 * 
	 * 
	 */
static void nand_buf_free(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
#ifndef 	AML_NAND_UBOOT
	struct nand_flash *flash = &aml_chip->flash; 

	amlnf_dma_free(controller->data_buf, (flash->pagesize + flash->oobsize), 0);
	amlnf_dma_free(controller->user_buf, (flash->pagesize /controller->ecc_bytes)*sizeof(int), 1);
#else
	  aml_nand_free(controller->data_buf);
	  aml_nand_free(controller->user_buf);
#endif

	  aml_nand_free(controller->page_buf);
	  aml_nand_free(controller->oob_buf);
}


/*
  * check rb pin here.
  * if without rb pin, then setting NAND_CTRL_NONE_RB mode
  * 
  */
static void aml_chip_rb_mode_confirm(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	unsigned por_cfg = 0, rb_mode = 0;

	if(controller->chip_num > 2){
		aml_nand_msg("force NO RB pin here and controller->chip_num:%d over 2", controller->chip_num);
		rb_mode = 1;
	}
	else{
		por_cfg = POR_CONFIG;

		aml_nand_msg("detect RB pin here and por_cfg:%x", por_cfg);
		if(por_cfg&POC_NAND_NO_RB){
			aml_nand_msg("detect without RB pin here");
			rb_mode = 1;
		}
		else{
			aml_nand_msg("detect with RB pin here");
			controller->option &= ~NAND_CTRL_NONE_RB;
		}		
	}

	if(rb_mode){
		controller->rb_enable[0] = 0;
		controller->option |= NAND_CTRL_NONE_RB;
	}

}

void amlchip_dumpinfo(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct nand_flash *flash = &(aml_chip->flash);

	//flash info
	aml_nand_msg("flash  info\n");	
	aml_nand_msg("name:%s, id:%2x %2x %2x %2x %2x %2x %2x %2x\n", \
		flash->name, flash->id[0], flash->id[1], flash->id[2], flash->id[3], flash->id[4], flash->id[5], flash->id[6], flash->id[7]);	
	aml_nand_msg("pagesize:0x%x, blocksize:0x%x, oobsize:0x%x, chipsize:0x%x, option:0x%x, T_REA:%d, T_RHOH:%d\n", \
		flash->pagesize, flash->blocksize, flash->oobsize, flash->chipsize, flash->option, flash->T_REA, flash->T_RHOH);
	aml_nand_msg("hw controller info\n");
	aml_nand_msg("chip_num:%d, onfi_mode:%d, page_shift:%d, block_shift:%d, option:0x%x\n", \
		controller->chip_num, controller->onfi_mode, controller->page_shift, controller->block_shift, controller->option);	
	aml_nand_msg("ecc_unit:%d, ecc_bytes:%d, ecc_steps:%d, ecc_max:%d\n", \
		controller->ecc_unit, controller->ecc_bytes, controller->ecc_steps, controller->ecc_max);	
	aml_nand_msg("bch_mode:%d, user_mode:%d, oobavail:%d, oobtail:%d\n", \
		controller->bch_mode, controller->user_mode, controller->oobavail, controller->oobtail);	

}

int amlchip_opstest(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);	
	struct chip_operation *operation = &(aml_chip->operation);	
	struct nand_flash *flash = &(aml_chip->flash);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	uint64_t addr, opslen = 0, len = 0;
	unsigned erase_shift, write_shift, writesize, erasesize;
	int i, ret = 0;

	//should setting nand pinmux first
#ifdef AML_NAND_UBOOT
	nand_get_chip();
#else
	nand_get_chip(aml_chip);
#endif
	
	//clear ops_para here
	memset(ops_para, 0, sizeof(struct chip_ops_para));
	
	writesize = flash->pagesize;
	erasesize = flash->blocksize;

	//ops_para->option = (DEV_ECC_HW_MODE |DEV_SERIAL_CHIP_MODE );	
	ops_para->option = (DEV_ECC_HW_MODE |NAND_MULTI_PLANE_MODE |DEV_SERIAL_CHIP_MODE );	
	ops_para->data_buf = controller->page_buf;	
	//ops_para->oob_buf = controller->oobbuf;


	if(ops_para->option & DEV_MULTI_PLANE_MODE){
		writesize *= 2;
		erasesize *= 2;
	}

	if(ops_para->option & DEV_MULTI_CHIP_MODE){
		writesize *= controller->chip_num;
		erasesize *= controller->chip_num;
	}
	
	erase_shift  = ffs(erasesize) - 1;
	write_shift  = ffs(writesize) - 1;

#if 0	
//read
	//start addr 0, read whole chip size
	opslen = addr = 0;
	len = ((uint64_t)(flash->chipsize*controller->chip_num))<<20;
	aml_nand_dbg("TEST step1 read whole chip, len:%llx, total_page:%d", len, len>>write_shift);

	while(1){
		memset(ops_para->data_buf, 0, writesize);
		if(ops_para->option & DEV_SERIAL_CHIP_MODE){		
			ops_para->chipnr = (addr>>erase_shift)%controller->chip_num;
		}
		
		ops_para->page_addr = (int)(addr >>write_shift)/controller->chip_num;	
		ret = operation->read_page(aml_chip);			
		if(ret<0){			
			aml_nand_msg("fail page_addr:%d", ops_para->page_addr); 		
			break;
		}
		aml_nand_dbg("page:%d data: %x %x %x %x", ops_para->page_addr, \
			ops_para->data_buf[0], ops_para->data_buf[1], ops_para->data_buf[2], ops_para->data_buf[3]);			

		addr +=writesize;		
		opslen += writesize;
		if(opslen >= len){
			break;
		}

		if(ops_para->ecc_err){
			aml_nand_msg("ecc failed at page_addr:%d", ops_para->page_addr); 	
		}
		else if(ops_para->bit_flip){
			aml_nand_msg("bit_flip at page_addr:%d", ops_para->page_addr); 	
		}
	}
#endif
//	BUG();

#if 1
//erase
	//start addr 0, read whole chip size
	aml_nand_dbg("TEST step2 erase whole chip");
	opslen = addr = 0;
	//len = ((uint64_t)(flash->chipsize*controller->chip_num))<<20;
	len = 1<<erase_shift;
	aml_nand_dbg("TEST step2 erase whole chip, len:%llx, total_page:%d", len, len>>write_shift);
	while(1){		
		if(ops_para->option & DEV_SERIAL_CHIP_MODE){		
			ops_para->chipnr = (addr>>erase_shift)%controller->chip_num;
		}
		
		ops_para->page_addr = (int)(addr >>write_shift)/controller->chip_num;	
		ret = operation->erase_block(aml_chip);			
		if(ret<0){			
			aml_nand_msg("fail page_addr:%d", ops_para->page_addr); 		
			break;
		}
					
		addr += erasesize;		
		opslen += erasesize;
		if(opslen >= len){
			break;
		}
	}
#endif
	//BUG();
//write
	opslen = addr = 0;
	//len = ((uint64_t)(flash->chipsize*controller->chip_num))<<20;
	aml_nand_dbg("TEST step3 write whole chip, len:%llx, total_page:%d", len, len>>write_shift);
	for(i=0; i<writesize;i++){
		ops_para->data_buf[i] = i;
	}
	while(1){
		
		if(ops_para->option & DEV_SERIAL_CHIP_MODE){		
			ops_para->chipnr = (addr>>erase_shift)%controller->chip_num;
		}
		
		ops_para->page_addr = (int)(addr >>write_shift)/controller->chip_num;	
		ret = operation->write_page(aml_chip);			
		if(ret<0){			
			aml_nand_msg("fail page_addr:%d", ops_para->page_addr); 		
			break;
		}
					
		addr +=writesize;		
		//ops_para->data_buf += writesize;
		opslen += writesize;
		if(opslen >= len){
			break;
		}
	}

//read
	//start addr 0, read whole chip size
	opslen = addr = 0;
	//len = ((uint64_t)(flash->chipsize*controller->chip_num))<<20;
	aml_nand_dbg("TEST step4 read whole chip, len:%llx, total_page:%d", len, len>>write_shift);
	while(1){
		memset(ops_para->data_buf, 0, writesize);
		if(ops_para->option & DEV_SERIAL_CHIP_MODE){		
			ops_para->chipnr = (addr>>erase_shift)%controller->chip_num;
		}
		
		ops_para->page_addr = (int)(addr >>write_shift)/controller->chip_num;	
		ret = operation->read_page(aml_chip);			
		if(ret<0){			
			aml_nand_msg("fail page_addr:%d", ops_para->page_addr); 		
			break;
		}
		aml_nand_dbg("page:%d data: %x %x %x %x", ops_para->page_addr, \
			ops_para->data_buf[0], ops_para->data_buf[1], ops_para->data_buf[2], ops_para->data_buf[3]);			
		addr +=writesize;		
		//ops_para->data_buf += writesize;
		opslen += writesize;
		if(opslen >= len){
			break;
		}

		if(ops_para->ecc_err){
			aml_nand_msg("ecc failed at page_addr:%d", ops_para->page_addr); 	
		}
		else if(ops_para->bit_flip){
			aml_nand_msg("bit_flip at page_addr:%d", ops_para->page_addr); 	
		}
	}


	//should clear nand pinmux here
#ifdef AML_NAND_UBOOT
	nand_release_chip();
#else
	nand_release_chip(aml_chip);
#endif

}

/*
  * fill amlnand_chip struct.
  * including hw init, chip detect, option setting and operation function.
  * 
  */
unsigned amlnand_chip_init(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &(aml_chip->controller);
	//struct chip_operation *operation = &aml_chip->operation;
	int ret = 0;		
	
	ret = amlnand_chip_scan(aml_chip);
	if(ret){
		aml_nand_msg("get_chip_type and ret:%x", ret);
		goto error_exit0;
	}
	
	//amlchip_dumpinfo(aml_chip);

	ret = nand_buf_init(aml_chip);
	if(ret){
		aml_nand_msg("buf init failed and ret:%x", ret);		
		goto error_exit0;
	}
	
	ret = controller->adjust_timing(controller);	
	if(ret){
		aml_nand_msg("adjust_timing failed and ret:%x", ret);
		goto error_exit1;
	}

#ifndef CONFIG_NAND_AML_M8
	aml_chip_rb_mode_confirm(aml_chip);
#endif

	ret = controller->ecc_confirm(controller);
	if(ret){
		aml_nand_msg("buf init failed and ret:%x", ret);		
		goto error_exit1;
	}	

#ifdef AML_NAND_DBG
	amlchip_dumpinfo(aml_chip);
#endif

//basic operation test here, read/write/erase
#if 0
	amlchip_opstest(aml_chip);
#endif

	return NAND_SUCCESS;
error_exit1:
	nand_buf_free(aml_chip);
error_exit0:
	return ret;

}

