

#include "../include/phynand.h"

extern  int block_markbad(struct amlnand_chip *aml_chip);

#ifdef AML_NAND_UBOOT
//extern struct amlnf_partition amlnand_config;
extern struct amlnf_partition * amlnand_config;
int get_last_reserve_block(struct amlnand_chip *aml_chip);
int repair_reserved_bad_block(struct amlnand_chip *aml_chip);

int chipenv_init_erase_protect(struct amlnand_chip *aml_chip, int flag,int block_num)
{
	int ret = 0,start_blk = 0;
	struct nand_flash *flash = &aml_chip->flash;
	struct hw_controller *controller = &aml_chip->controller;
	struct read_retry_info *retry_info = &(controller->retry_info);

	int phys_erase_shift = ffs(flash->blocksize) - 1;
	start_blk =  (1024 * flash->pagesize) >> phys_erase_shift;
	block_num  -= (controller->chip_num - 1) * start_blk;
	
	if((flag > NAND_BOOT_UPGRATE)&&(flag <= NAND_BOOT_SCRUB_ALL)){
 		if((block_num == aml_chip->shipped_bbtinfo.valid_blk_addr)&&(aml_chip->shipped_bbtinfo.valid_blk_addr >= start_blk)&&(!(info_disprotect & DISPROTECT_KEY))){
 			aml_nand_msg("protect fbbt at blk %d",block_num);
 			ret = -1;
 		}else if(((block_num == retry_info->info_save_blk)&&(retry_info->info_save_blk >= start_blk)&&(flash->new_type)&&(flash->new_type < 10))&&(!(info_disprotect & DISPROTECT_HYNIX))){
 			aml_nand_msg("protect hynix retry info at blk %d",block_num);
 			ret = -1;
 		}else if((block_num == aml_chip->nand_key.valid_blk_addr)&&(aml_chip->nand_key.valid_blk_addr >= start_blk)&&(!(info_disprotect & DISPROTECT_KEY))){
			aml_nand_msg("protect nand_key info at blk %d",block_num);
			ret = -1;
		}else if((block_num == aml_chip->nand_secure.valid_blk_addr)&&(aml_chip->nand_secure.valid_blk_addr >= start_blk)&&(!(info_disprotect & DISPROTECT_SECURE))){
			aml_nand_msg("protect nand_secure info at blk %d",block_num);
			ret = -1;
		}else{
			ret = 0;
		}
	}

	return ret;
}

/***
*erase whole nand as scrub
* start_blk = 0; total_blk;
***/
static int amlnand_oops_handle(struct amlnand_chip *aml_chip, int flag)
{
	struct hw_controller *controller = &(aml_chip->controller);	
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct nand_flash *flash = &(aml_chip->flash);
	
	uint64_t  erase_len,  erase_off;
	unsigned erase_shift, write_shift, writesize, erasesize, pages_per_blk;
	int  start_blk,total_blk, ret = 0;
	int percent=0, percent_complete = -1;
	
	aml_nand_dbg("amlnand_oops_handle!!! ");

	erase_shift = ffs(flash->blocksize) - 1;
	write_shift =  ffs(flash->pagesize) - 1;
	erase_len = ((uint64_t)(flash->chipsize*controller->chip_num))<<20;
		
	start_blk = 0;
	total_blk = (int)(erase_len >> erase_shift);
	pages_per_blk = (1 << (erase_shift -write_shift));

	aml_nand_msg("start_blk =%d,total_blk=%d",start_blk, total_blk);

	if(flag == NAND_BOOT_ERASE_PROTECT_CACHE){
		start_blk = (1024 * flash->pagesize) >> erase_shift;
		total_blk = get_last_reserve_block(aml_chip);
		aml_nand_msg("start_blk =%d,total_blk=%d",start_blk, total_blk);
	}

	for(;start_blk< total_blk; start_blk++){
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));			
		ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num)) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		if(flag != NAND_BOOT_SCRUB_ALL){
			ret = operation->block_isbad(aml_chip);
			if(ret ){
				continue;
			}	//check bbt 
		}

		ret = chipenv_init_erase_protect(aml_chip,flag,start_blk);
		if(ret){
			continue;
		}

		nand_get_chip();
		 operation->erase_block(aml_chip);	
		nand_release_chip();		
	
		percent = (start_blk * 100) / total_blk;
		
		if ((percent != percent_complete)&&((percent %10)==0)) {
				percent_complete = percent;
				aml_nand_msg("nand erasing %d %% --%d %% complete",percent,percent+10);
		}
	}

	return ret;
}

int  phrase_driver_version(unsigned int cp, unsigned int cmp)
{
	int ret=0;

	if(((cp >> 24)&0xff) != ((cp >> 24)&0xff)){
		ret = -1;
	}
	if(((cp >> 16)&0xff)!= ((cp >> 16)&0xff)){	
		ret = -1;
	}
	return ret;
}


void reset_amlchip_member(struct amlnand_chip *aml_chip)
{
	memset(aml_chip->reserved_blk, 0xff, RESERVED_BLOCK_CNT);
	memset(&aml_chip->nand_bbtinfo,0x0,sizeof(struct _nand_arg_info));		
	memset(&aml_chip->shipped_bbtinfo,0x0,sizeof(struct _nand_arg_info));		
	memset(&aml_chip->nand_key,0x0,sizeof(struct _nand_arg_info));
	memset(&aml_chip->nand_secure,0x0,sizeof(struct _nand_arg_info));		
	memset(&aml_chip->config_msg,0x0,sizeof(struct _nand_arg_info));
}

#endif

static unsigned int aml_info_checksum(unsigned char *data,int lenth)
{
	unsigned int checksum;
	unsigned char *pdata;
	int i;
	checksum = 0;
	pdata = (unsigned char *)data;
	for(i=0;i<lenth;i++){
		checksum += pdata[i];
	}
	return checksum;
}

static int aml_info_check_datasum(void *data,unsigned char *name)
{
	int ret =0;
	unsigned int crc=0;
	if(!memcmp(name,BBT_HEAD_MAGIC,4)){
		struct block_status *blk_status = (struct block_status *)data;
		crc = blk_status->crc;
		if(aml_info_checksum(blk_status->blk_status,(MAX_CHIP_NUM*MAX_BLK_NUM)) != crc){
			aml_nand_msg("aml_info_check_datasum : nand bbt  bad crc error");
			ret = -NAND_READ_FAILED;
		}
	}
	
	if(!memcmp(name,SHIPPED_BBT_HEAD_MAGIC,4)){
		struct shipped_bbt * bbt = (struct shipped_bbt *)data;
		crc = bbt->crc;
		if(aml_info_checksum(bbt->shipped_bbt,(MAX_CHIP_NUM*MAX_BAD_BLK_NUM)) != crc){
			aml_nand_msg("aml_info_check_datasum : nand shipped bbt  bad crc error");
			ret = -NAND_READ_FAILED;
		}
	}
	
	if(!memcmp(name,CONFIG_HEAD_MAGIC,4)){
			struct nand_config * config = (struct nand_config *)data;
			crc = config->crc;
			if(aml_info_checksum(config->dev_para,(MAX_DEVICE_NUM*sizeof(struct dev_para))) != crc){
				aml_nand_msg("aml_info_check_datasum : nand check config crc error");
				ret = -NAND_READ_FAILED;
			}
		}

	return ret;
}

int amlnand_free_block_test(struct amlnand_chip *aml_chip, int start_blk)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct nand_flash *flash = &aml_chip->flash;
	struct en_slc_info *slc_info = &(controller->slc_info);
	char block_invalid = 0;
	
	unsigned char phys_erase_shift, phys_page_shift, nand_boot;  
	unsigned i, offset, offset_tmp,  pages_per_blk, pages_read, amount_loaded =0;
	unsigned char  oob_buf[8];
	unsigned short total_blk, tmp_blk;
	int  ret = 0, len,t=0;

	unsigned char *dat_buf =NULL;

	dat_buf  = aml_nand_malloc(flash->pagesize);
	if(!dat_buf){
		aml_nand_msg("amlnand_free_block_test : malloc failed");
		block_invalid = 1;
		ret =  -1;
		goto exit;
	}
	memset(dat_buf, 0xa5, flash->pagesize);
	
	nand_boot = 1;
	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}*/	

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
	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));			
	ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
	ops_para->chipnr = start_blk % controller->chip_num;
	controller->select_chip(controller, ops_para->chipnr );
	ret = operation->erase_block(aml_chip); 	
	if(ret < 0){
		aml_nand_msg("nand blk %d check good but erase failed", start_blk);
		block_invalid = 1;
		ret =  -1;
		goto exit;
	}
	
	//write
	for(t = 0; t < pages_read; t++){
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
		if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE;
		ops_para->page_addr =(t+(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
		ops_para->chipnr = start_blk % controller->chip_num;	
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

		ret = operation->write_page(aml_chip);
		if(ret < 0){
			aml_nand_msg("nand write failed");
			block_invalid = 1;
			ret =  -1;
			goto exit;
		}
	}
	//read
	for(t = 0; t < pages_read; t++){
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
		if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE;
		ops_para->page_addr =(t+(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
		ops_para->chipnr = start_blk % controller->chip_num;	
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

		ret = operation->read_page(aml_chip);
		if(ret < 0){
			aml_nand_msg("nand write failed");
			block_invalid = 1;
			ret =  -1;
			goto exit;
		}
		aml_nand_dbg("start_blk %d aml_chip->user_page_buf: ",start_blk);
		show_data_buf(aml_chip->user_page_buf);
		aml_nand_dbg("start_blk %d dat_buf: ",start_blk);
		show_data_buf(dat_buf);
		if(memcmp(aml_chip->user_page_buf,dat_buf,flash->pagesize)){
			block_invalid = 1;
			ret =  -1;
			aml_nand_msg("free blk  %d,  page %d : test failed",start_blk, t);
			goto exit;
		}
		
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
		aml_nand_msg("free blk start_blk %d test OK",start_blk);
	}
	
	return ret;
}

int get_last_reserve_block(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct nand_flash *flash = &aml_chip->flash;
	
	unsigned int offset, start_blk, total_blk, blk_addr, tmp_blk, pages_per_blk;
	unsigned char phys_erase_shift, phys_page_shift;
	int  ret =0;
	
	offset = (1024 * flash->pagesize);

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));
	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));

	start_blk = (offset >> phys_erase_shift);
	tmp_blk = total_blk = start_blk;

	blk_addr = 0;
	//decide the total block_addr
	while(blk_addr < RESERVED_BLOCK_CNT){
		
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));	
		ops_para->page_addr =(((total_blk - total_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
		ops_para->chipnr = total_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr );
				
		ret = operation->block_isbad(aml_chip);
		if(ret ==  NAND_BLOCK_FACTORY_BAD){
			aml_nand_msg("nand blk %d is shipped bad block ", total_blk);
			total_blk++;
			continue;
		}	
		total_blk++;
		blk_addr++;
	}
		
	return total_blk;
}
int repair_reserved_bad_block(struct amlnand_chip *aml_chip)
{
    struct hw_controller *controller = &aml_chip->controller;
    struct chip_operation *operation = & aml_chip->operation;
    struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
    struct nand_flash *flash = &aml_chip->flash;
    
    unsigned int offset, start_blk, total_blk, blk_addr, tmp_blk, pages_per_blk,blk_used_bad_cnt = 0;
    unsigned char phys_erase_shift, phys_page_shift;
    int  ret =0,i = 0,j = 0;
    uint64_t bad_blk[128];
    memset(bad_blk,0,128*sizeof(uint64_t));
    offset = (1024 * flash->pagesize);

    phys_erase_shift = ffs(flash->blocksize) - 1;
    phys_page_shift =  ffs(flash->pagesize) - 1;
    pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));
    memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));

    start_blk = (offset >> phys_erase_shift);
    tmp_blk = total_blk = start_blk;

	unsigned char *dat_buf =NULL;
    unsigned char *oob_buf =NULL;
	dat_buf  = aml_nand_malloc(flash->pagesize);
	if(!dat_buf){
		aml_nand_msg("amlnand_free_block_test : malloc failed");
		ret =  -1;
		return ret;
	}
	memset(dat_buf, 0, flash->pagesize);
	oob_buf  = aml_nand_malloc(flash->oobsize);
	if(!oob_buf){
		aml_nand_msg("amlnand_free_block_test : malloc failed");
		ret =  -1;
		return ret;
	}
	memset(oob_buf, 0, flash->oobsize);

    blk_addr = 0;
    //decide the total block_addr
    while(blk_addr < RESERVED_BLOCK_CNT){
        
        memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));   
        ops_para->page_addr =(((total_blk - total_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
        ops_para->chipnr = total_blk % controller->chip_num;
        controller->select_chip(controller, ops_para->chipnr );
                
        ret = operation->block_isbad(aml_chip);
        if(ret ==  NAND_BLOCK_FACTORY_BAD){
            aml_nand_msg("nand blk %d is shipped bad block ", total_blk);
            total_blk++;
            continue;
        }
        if(ret == NAND_BLOCK_USED_BAD)
        {
            if(blk_used_bad_cnt < 128){
            bad_blk[blk_used_bad_cnt] = total_blk;
            blk_used_bad_cnt++;
            }
        }
        total_blk++;
        blk_addr++;
    }
    if(blk_used_bad_cnt>6)
    {
        #ifdef AML_NAND_UBOOT
			nand_get_chip();
        #else
    		nand_get_chip(aml_chip);
        #endif	
        aml_nand_msg("repair bad block of reserved,blk_used_bad_cnt=%d\n",blk_used_bad_cnt);
        for(i=0;i<blk_used_bad_cnt;i++){
            memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));   
            ops_para->page_addr =(((bad_blk[i] - bad_blk[i] % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
            ops_para->chipnr = bad_blk[i] % controller->chip_num;
            controller->select_chip(controller, ops_para->chipnr );
            ret = operation->blk_modify_bbt_chip_op(aml_chip,0);
            //erase
            ret = operation->erase_block(aml_chip);
            if(ret){
                ret = operation->blk_modify_bbt_chip_op(aml_chip,1);
                aml_nand_msg("test blk %d fail\n",bad_blk[i]);
                continue;
            }
            //write
            ops_para->page_addr =(((bad_blk[i] - bad_blk[i] % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
            ops_para->data_buf = dat_buf;
            ops_para->oob_buf = oob_buf;
            for(j=0;j<pages_per_blk;j++)
            {
                ops_para->page_addr += 1;
                memset(dat_buf, 0, flash->pagesize);
                memset(oob_buf, 0, flash->oobsize);
                ret = operation->write_page(aml_chip);
                if(ret){
                    ops_para->page_addr =(((bad_blk[i] - bad_blk[i] % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
                    ret = operation->blk_modify_bbt_chip_op(aml_chip,1);
                    aml_nand_msg("test blk %d fail\n",bad_blk[i]);
                    goto write_read_fail;
                }
            }
            //read
            ops_para->page_addr =(((bad_blk[i] - bad_blk[i] % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
            ops_para->data_buf = dat_buf;
            ops_para->oob_buf = oob_buf;
            for(j=0;j<pages_per_blk;j++)
            {
                ops_para->page_addr += 1;
                memset(dat_buf, 0, flash->pagesize);
                memset(oob_buf, 0, flash->oobsize);
                ret = operation->read_page(aml_chip);
                if((ops_para->ecc_err) || (ret < 0)){
                    ops_para->page_addr =(((bad_blk[i] - bad_blk[i] % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
                    ret = operation->blk_modify_bbt_chip_op(aml_chip,1);
                    aml_nand_msg("test blk %d fail\n",bad_blk[i]);
                    goto write_read_fail;
                }
            }
            //erase
            ops_para->page_addr =(((bad_blk[i] - bad_blk[i] % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
            ret = operation->erase_block(aml_chip);
            if(ret){
                ret = operation->blk_modify_bbt_chip_op(aml_chip,1);
                aml_nand_msg("test blk %d fail\n",bad_blk[i]);
                continue;
            }
            aml_nand_msg("test blk %d OK\n",bad_blk[i]);
write_read_fail:
            ;
        }
        #ifdef AML_NAND_UBOOT
			nand_release_chip();
        #else
			nand_release_chip(aml_chip);
        #endif
        amlnand_update_bbt(aml_chip);
    }
    return total_blk;
}

/*****************************************************************************
*Name         :amlnand_get_free_block
*Description :search a good block by skip the shipped bad block 
*Parameter  :
*Return       :
*Note          :
*****************************************************************************/
int amlnand_get_free_block(struct amlnand_chip *aml_chip,unsigned int block)
{	
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct nand_flash *flash = &aml_chip->flash;
	
	unsigned int offset, nand_boot, start_blk, total_blk, blk_addr, tmp_blk, pages_per_blk;
	unsigned char phys_erase_shift, phys_page_shift;
	unsigned char  blk_used_flag = 0;
	int  ret =0, i;
	
	nand_boot = 1;
	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else {
		offset = 0;
	}
	
	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));
	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));

	start_blk = (offset >> phys_erase_shift);
	tmp_blk = total_blk = start_blk;

	total_blk = get_last_reserve_block(aml_chip);
	blk_addr = 0;
	while((blk_addr < 1) && (start_blk < total_blk )){
		for(i=0; i<RESERVED_BLOCK_CNT;  i++){
			if(aml_chip->reserved_blk[i] == start_blk){
				//aml_nand_msg("nand blk %d is used", start_blk);
				blk_used_flag =1;					
				break;
			}
			else{
				blk_used_flag =0;	
			}
		}
		if(blk_used_flag){		
			start_blk++;
			continue;
		}
        if(block == start_blk){
			start_blk++;
			continue;
        }
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));			
		ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr );
		
		ret = operation->block_isbad(aml_chip);
		if(ret == NAND_BLOCK_FACTORY_BAD){
			aml_nand_msg("nand blk %d is shipped bad block ", start_blk);
			start_blk++;
			continue;
		}

		/*ret = amlnand_free_block_test(aml_chip, start_blk);
		if(ret){
			aml_nand_msg("nand get free block  %d invalid",start_blk);
			start_blk++;
			continue;
		}*/
		
#ifdef AML_NAND_UBOOT
		nand_get_chip();
#else
		nand_get_chip(aml_chip);
#endif	
		ret = operation->erase_block(aml_chip);	
#ifdef AML_NAND_UBOOT
		nand_release_chip();
#else
		nand_release_chip(aml_chip);
#endif			
		if(ret < 0){
			aml_nand_msg("nand blk %d check good but erase failed", start_blk);
			ret = operation->block_markbad(aml_chip);
			start_blk++;
			continue;
		}
		else{			
			aml_nand_dbg("nand get free block at %d", start_blk);
		}
		blk_addr ++;
	}

	if((start_blk >= total_blk )){
		ret = -NAND_BAD_BLCOK_FAILURE;
		aml_nand_msg("nand can not find free block");
	}
	
	return (ret == 0) ? start_blk : ret;
}

void amlnand_info_error_handle(struct amlnand_chip *aml_chip)
{
	nand_arg_info * nand_bbt = &aml_chip->nand_bbtinfo;  
	nand_arg_info  * nand_config= &aml_chip->config_msg;
	int ret = 0;
	
	if((nand_bbt->arg_valid)&&(nand_bbt->update_flag)){
		//aml_nand_msg("amlnand_info_error_handle : update bbt");
		ret = amlnand_update_bbt(aml_chip);
		nand_bbt->update_flag = 0;
		aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
				"bbt",nand_bbt->arg_valid, nand_bbt->valid_blk_addr, nand_bbt->valid_page_addr);
		if(ret){
			aml_nand_msg("amlnand_info_error_handle : nand update bbt failed");
			return;
		}

	}

	if((nand_config->arg_valid)&&(nand_config->update_flag)){
		//aml_nand_msg("amlnand_info_error_handle : update nand config");
		aml_chip->config_ptr->crc = aml_info_checksum(aml_chip->config_ptr->dev_para,(MAX_DEVICE_NUM*sizeof(struct dev_para)));					
		 ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->config_msg),aml_chip->config_ptr,CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
		nand_config->update_flag = 0;
		aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
				"config",nand_config->arg_valid, nand_config->valid_blk_addr, nand_config->valid_page_addr);
		if(ret < 0){
			aml_nand_msg("save nand dev_configs failed and ret:%d",ret);			
			return;
		}

	}
	
	ret =  aml_sys_info_error_handle(aml_chip);
	if(ret < 0){
		aml_nand_msg("amlnand_info_error_handle : sys info error handle failed");			
	}
	
	return;
}

int amlnand_read_info_by_name(struct amlnand_chip *aml_chip,unsigned char * info,unsigned char * buf,unsigned char * name,unsigned size)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct en_slc_info *slc_info = &(controller->slc_info);
	nand_arg_info * arg_info = (struct _nand_arg_info *)info;
	nand_arg_oobinfo * arg_oob_info; 

	unsigned char phys_erase_shift, phys_page_shift, nand_boot;  
	unsigned i, offset, offset_tmp,  pages_per_blk, pages_read, amount_loaded =0;
	unsigned char  oob_buf[sizeof(struct _nand_arg_oobinfo)];
	unsigned short start_blk, total_blk, tmp_blk;
	int  ret = 0, len;
	
	nand_boot = 1;
	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}*/	

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else {
		offset = 0;
	}

	arg_oob_info = (struct nand_arg_oobinfo *)oob_buf;
	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift)); 

	if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;
		
	if(ops_para->option & DEV_SLC_MODE){
		pages_read = pages_per_blk >> 1;
	}else{
		pages_read = pages_per_blk;
	}

	start_blk = (offset >> phys_erase_shift); 
	tmp_blk = start_blk;
	total_blk = (offset >> phys_erase_shift)+ RESERVED_BLOCK_CNT;
	
	if(arg_info->arg_valid == 1){	
		
		//load bbt
		offset_tmp = 0;
		while (amount_loaded < size){
			
			memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
			if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
				ops_para->option |= DEV_SLC_MODE;

			ops_para->data_buf = aml_chip->user_page_buf;
			ops_para->oob_buf = aml_chip->user_oob_buf;
			ops_para->ooblen = sizeof(oob_buf);
			memset((unsigned char *)ops_para->data_buf, 0x0, flash->pagesize);
			memset((unsigned char *)ops_para->oob_buf, 0x0, sizeof(oob_buf));

			ops_para->page_addr =(arg_info->valid_page_addr+(((arg_info->valid_blk_addr - arg_info->valid_blk_addr % controller->chip_num) \
				/controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk) + offset_tmp;

			if((ops_para->option & DEV_SLC_MODE)) {
				if((flash->new_type > 0) && (flash->new_type <10))
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
				if (flash->new_type == SANDISK_19NM) 
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
			}

			ops_para->chipnr = arg_info->valid_blk_addr % controller->chip_num;		
			controller->select_chip(controller, ops_para->chipnr );
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
			if ((ops_para->ecc_err) || (ret < 0)) {
				aml_nand_msg("nand read arg %s failed at chip %d page %d",name, ops_para->chipnr, ops_para->page_addr);
				goto exit_error0;
			}		
			
			memcpy((unsigned char *)arg_oob_info,  aml_chip->user_oob_buf,sizeof(oob_buf));
			if (!memcmp(arg_oob_info->name, name, 4)){
				len = min(flash->pagesize, size - amount_loaded);
				memcpy(((unsigned char *)(buf)+amount_loaded), (unsigned char *)aml_chip->user_page_buf, len); 
			}		
			offset_tmp += 1;
			amount_loaded += flash->pagesize;
		}		
	}

	return ret;
	
exit_error0:
	return ret;
}

int amlnand_save_info_by_name(struct amlnand_chip *aml_chip,unsigned char * info,unsigned char * buf,unsigned char * name,unsigned size)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct en_slc_info *slc_info = &(controller->slc_info);
	nand_arg_info * arg_info = (struct _nand_arg_info *)info;
	 nand_arg_oobinfo * arg_oob_info; 
	
	unsigned int len, offset, offset_tmp, nand_boot, blk_addr=0,tmp_blk_addr,  amount_saved =0, pages_per_blk, arg_pages, pages_read;
	unsigned char phys_erase_shift, phys_page_shift;
	unsigned char  oob_buf[sizeof(struct _nand_arg_oobinfo)];
	unsigned short tmp_blk;
	int full_page_flag=0, ret = 0, i,test_cnt = 0,extra_page = 0;
	
	nand_boot = 1;
	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}	*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else {
		offset = 0;
	}
	
	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));
    aml_nand_msg("size:%d",size);
	arg_pages = ((size>>phys_page_shift) + 1);
    aml_nand_msg("arg_pages:%d",arg_pages);
    if((size%flash->pagesize)==0)
    {
        extra_page = 1;
    }else
    {
        extra_page = 0;
    }
    aml_nand_msg("extra_page:%d",extra_page);
	tmp_blk = (offset >> phys_erase_shift);
	
	if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;
	
	if(ops_para->option & DEV_SLC_MODE){
		pages_read = pages_per_blk >> 1;
	}else{
		pages_read = pages_per_blk;
	}
	
	arg_oob_info =(struct nand_arg_oobinfo *) oob_buf;
	arg_info->timestamp +=1;
	arg_oob_info->timestamp = arg_info->timestamp;
	
	memcpy(arg_oob_info->name, name, 4);
	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));

#if 0
	aml_nand_dbg(" buf: %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x", \
		 bbt_ptr[0], bbt_ptr[1], bbt_ptr[2], bbt_ptr[3], bbt_ptr[4], bbt_ptr[5], bbt_ptr[6], bbt_ptr[7],\
		bbt_ptr[8], bbt_ptr[9], bbt_ptr[10], bbt_ptr[11], bbt_ptr[12], bbt_ptr[13], bbt_ptr[14], bbt_ptr[15] );

	aml_nand_dbg(" oob_buf: %x %x %x %x %x %x %x %x", \
		oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3], oob_buf[4], oob_buf[5], oob_buf[6], oob_buf[7]);

	aml_nand_dbg(" bbt_oob_info: %x %x %x %x %x %x %x %x", \
		bbt_oob_info[0], bbt_oob_info[1], bbt_oob_info[2], bbt_oob_info[3], bbt_oob_info[4], bbt_oob_info[5], bbt_oob_info[6], bbt_oob_info[7]);
#endif
get_free_blk:
//get new block according to arg_type or update_flag
	if((arg_info->arg_valid)&&(!arg_info->update_flag) && (arg_info->arg_type == FULL_PAGE)){

		if((arg_info->valid_page_addr + 2* arg_pages) > pages_read){
			ret = amlnand_get_free_block(aml_chip,blk_addr);
            blk_addr = ret;
			if( ret < 0){
				aml_nand_msg("nand get free blcok failed"); 
				ret = - NAND_BAD_BLCOK_FAILURE;
				goto exit_error0;
			}
			aml_nand_dbg("nand get free blcok  at %d",blk_addr); 
			full_page_flag = 1;
		}else{
			blk_addr = arg_info->valid_blk_addr;
		}
	}else{
		ret = amlnand_get_free_block(aml_chip,blk_addr);
        blk_addr = ret;
		if( ret < 0){
			aml_nand_msg("nand get free blcok failed"); 
			ret = - NAND_BAD_BLCOK_FAILURE;
			goto exit_error0;
		}
		aml_nand_dbg("nand get free blcok  at %d",blk_addr); 
	}
	
//	show_data_buf(buf);
//write arg_data into the block
	if(arg_info->arg_type == FULL_BLK){
		for(i=0; i<pages_read;){
				if((pages_read -i) < arg_pages)
					break;
				offset_tmp =0;
				amount_saved = 0;
				while(amount_saved < (size+extra_page*flash->pagesize)){
					
					memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
					if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
						ops_para->option |= DEV_SLC_MODE;
					ops_para->page_addr =((((blk_addr - blk_addr % controller->chip_num) /controller->chip_num) \
						+ tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk)+ (offset_tmp + i);

					if((ops_para->option & DEV_SLC_MODE)) {
						if((flash->new_type > 0) && (flash->new_type <10))
							ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
						if (flash->new_type == SANDISK_19NM) 
							ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
					}

					ops_para->chipnr = blk_addr % controller->chip_num;
					controller->select_chip(controller, ops_para->chipnr );
					ops_para->data_buf = aml_chip->user_page_buf;
					ops_para->oob_buf = aml_chip->user_oob_buf;
					ops_para->ooblen = sizeof(oob_buf);
		
					len = min(flash->pagesize, size + extra_page*flash->pagesize - amount_saved);
					memset(aml_chip->user_page_buf, 0x0, flash->pagesize);		
					memset(aml_chip->user_oob_buf, 0x0,sizeof(oob_buf));
					memcpy((unsigned char *)aml_chip->user_page_buf, ((unsigned char *)(buf) + amount_saved), len);
					memcpy(aml_chip->user_oob_buf, (unsigned char *)arg_oob_info, sizeof(oob_buf));
#if 0		
			aml_nand_dbg(" ops_para->oob_buf : %x %x %x %x %x %x %x %x", \
				ops_para->oob_buf [0], ops_para->oob_buf [1], ops_para->oob_buf [2], ops_para->oob_buf [3], ops_para->oob_buf [4], \
				ops_para->oob_buf [5], ops_para->oob_buf [6], ops_para->oob_buf [7]);
#endif
#ifdef AML_NAND_UBOOT
				nand_get_chip();
#else
				nand_get_chip(aml_chip);
#endif	
					ret = operation->write_page(aml_chip);
                    //aml_nand_msg("FULL BLOCK:nand write page:%d,chipnr:%d",ops_para->page_addr,ops_para->chipnr);

#ifdef AML_NAND_UBOOT
					nand_release_chip();
#else
					nand_release_chip(aml_chip);
#endif	
					if(ret < 0){
						printk("nand write failed\n");
                        if(test_cnt>=3){
                            printk("test block 3 times, operating environment maybe wrong!\n");
                            break;
                        }
                        ret = operation->test_block_reserved(aml_chip,blk_addr);
                        test_cnt++;
                        if(ret){
    						ret = operation->block_markbad(aml_chip);
    						if(ret < 0){
    							aml_nand_msg("nand mark bad block failed at blk %d", blk_addr); 				
    						}
                        }
						printk("rewrite!\n");
						goto get_free_blk;
					}
					offset_tmp += 1;
					amount_saved += flash->pagesize;
				}	
		
				i += arg_pages;
		
				if(ret < 0)
					break;
			}

	}
	else if (arg_info->arg_type == FULL_PAGE) {
		
		offset_tmp =0;
		amount_saved = 0;
		while(amount_saved < size+extra_page*flash->pagesize){
			memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
			if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
				ops_para->option |= DEV_SLC_MODE;
			ops_para->page_addr =((((blk_addr - blk_addr % controller->chip_num) /controller->chip_num) \
				+ tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk)+ offset_tmp ;
			if(arg_info->arg_valid && (!full_page_flag)&&(!arg_info->update_flag)){
				ops_para->page_addr += (arg_info->valid_page_addr +arg_pages);
			}
			
			if((ops_para->option & DEV_SLC_MODE)) {
				if((flash->new_type > 0) && (flash->new_type <10))
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
				if (flash->new_type == SANDISK_19NM) 
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
			}

			ops_para->chipnr = blk_addr % controller->chip_num;
			controller->select_chip(controller, ops_para->chipnr );
			
			ops_para->data_buf = aml_chip->user_page_buf;
			ops_para->oob_buf = aml_chip->user_oob_buf;
			ops_para->ooblen = sizeof(oob_buf);

			len = min(flash->pagesize, size + extra_page*flash->pagesize - amount_saved);
			memset(aml_chip->user_page_buf, 0x0, flash->pagesize);		
			memset(aml_chip->user_oob_buf, 0x0,sizeof(oob_buf));
			memcpy((unsigned char *)aml_chip->user_page_buf, ((unsigned char *)(buf) + amount_saved), len);
			memcpy(aml_chip->user_oob_buf, (unsigned char *)arg_oob_info, sizeof(oob_buf));

#ifdef AML_NAND_UBOOT
			nand_get_chip();
#else
			nand_get_chip(aml_chip);
#endif	
			ret = operation->write_page(aml_chip);
            //aml_nand_msg("nand write page:%d,chipnr:%d",ops_para->page_addr,ops_para->chipnr);
#ifdef AML_NAND_UBOOT
			nand_release_chip();
#else
			nand_release_chip(aml_chip);
#endif	
			if(ret < 0){
				aml_nand_msg("nand write failed");
                 if(test_cnt>=3){
                    printk("test block 3 times, operating environment maybe wrong!\n");
                    break;
                    }
                    ret = operation->test_block_reserved(aml_chip,blk_addr);
                    test_cnt++;
                    if(ret){
        				ret = operation->block_markbad(aml_chip);
        				if(ret < 0){
        					aml_nand_msg("nand mark bad block failed at blk %d", blk_addr); 				
            				}
                        }
				goto get_free_blk;
			}
			offset_tmp += 1;
			amount_saved += flash->pagesize;
		}
	}

	if(ret < 0){ // write failed
		aml_nand_msg(" NAND SAVE :  arg  %s faild at blk:%d", name,blk_addr);
		ret = -NAND_WRITE_FAILED;
		goto exit_error0;
	}
	else{

//write success and update reserved_blk table		
		if((arg_info->arg_valid == 0) || (arg_info->arg_type == FULL_BLK) || \
			((arg_info->arg_type == FULL_PAGE) && (full_page_flag ||arg_info->update_flag))){
			for(i=0; i<RESERVED_BLOCK_CNT;i++){
				if(aml_chip->reserved_blk[i] ==0xff){
					aml_nand_dbg("update reserved blk %s blk %d",name,blk_addr);
					aml_chip->reserved_blk[i] = blk_addr;
					break;
				}
			}
		}
		
#if 0		
		for(i=0; i<RESERVED_BLOCK_CNT;	i++){
			aml_nand_dbg("aml_chip->reserved_blk[%d]=%d ",i, aml_chip->reserved_blk[i] );			
		}
#endif
//write success and update arg_info
		tmp_blk_addr = arg_info->valid_blk_addr;
		arg_info->valid_blk_addr = blk_addr;
		if((arg_info->arg_type == FULL_PAGE) && (arg_info->arg_valid)){
			if(full_page_flag || arg_info->update_flag)
				arg_info->valid_page_addr  = 0;
			else	
				arg_info->valid_page_addr += arg_pages;
		}else if((arg_info->arg_type == FULL_BLK) && (arg_info->arg_valid)){
			arg_info->valid_page_addr  = 0;
		}
		aml_nand_dbg("NAND  SAVE :  arg  %s success at blk:%d", name, blk_addr);

//erase old info block
		if((arg_info->arg_type == FULL_BLK) || ((arg_info->arg_type == FULL_PAGE) && (full_page_flag ||arg_info->update_flag) )){

				if((arg_info->arg_valid) && (tmp_blk_addr != 0)){	
					
					aml_nand_dbg("nand erase old arg %s block at %d",name,tmp_blk_addr);
					ops_para->page_addr =((((tmp_blk_addr - tmp_blk_addr % controller->chip_num) /controller->chip_num) \
						+ tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
					ops_para->chipnr = tmp_blk_addr % controller->chip_num;
					controller->select_chip(controller, ops_para->chipnr );
#ifdef AML_NAND_UBOOT
					nand_get_chip();
#else
					nand_get_chip(aml_chip);
#endif	
					 ret = operation->erase_block(aml_chip);
#ifdef AML_NAND_UBOOT
					nand_release_chip();
#else
					nand_release_chip(aml_chip);
#endif	
					if(ret < 0){
						aml_nand_msg("nand blk %d erase failed", tmp_blk_addr);
                        ret = operation->test_block_reserved(aml_chip,tmp_blk_addr);
                        if(ret){
						ret = operation->block_markbad(aml_chip);
						if(ret < 0){
							aml_nand_msg("nand mark bad failed at blk %d",tmp_blk_addr);					
							goto exit_error0;
    						}
                        }
					}
					for(i=0; i<RESERVED_BLOCK_CNT;i++){
						if(aml_chip->reserved_blk[i] == tmp_blk_addr){
							aml_chip->reserved_blk[i] = 0xff;
							break;
						}
					}
#if 0
					for(i=0; i<RESERVED_BLOCK_CNT;	i++){
						aml_nand_dbg("aml_chip->reserved_blk[%d]=%d ",i, aml_chip->reserved_blk[i] );			
					}
#endif			
				}
			}
		arg_info->arg_valid = 1;   //SAVE SET VALID
		full_page_flag = 0;
	}
	
	
exit_error0:

	return ret;
}


void show_data_buf(unsigned char *  buf)
{
	int i=0;
	for(i= 0; i< 10; i++){
		aml_nand_dbg("buf[%d]= %d",i,buf[i]);
	}
	return;
}

int amlnand_check_info_by_name(struct amlnand_chip *aml_chip,unsigned char * info,unsigned char * name ,unsigned size)
{	
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct en_slc_info *slc_info = &(controller->slc_info);
	nand_arg_info * arg_info = (struct _nand_arg_info *)info;
	 nand_arg_oobinfo * arg_oob_info;	

	unsigned char phys_erase_shift, phys_page_shift, nand_boot;  
	unsigned i, offset, offset_tmp,  pages_per_blk, pages_read, amount_loaded =0;
	unsigned char  oob_buf[sizeof(struct _nand_arg_oobinfo)];
	unsigned short start_blk, total_blk, tmp_blk;
	int  ret = 0,read_failed_page=0,read_middle_page_failed=0, len;

	nand_boot = 1;
	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}	*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else {
		offset = 0;
	}

	arg_oob_info = (struct nand_arg_oobinfo *)oob_buf;
	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift)); 

	if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;
		
	if(ops_para->option & DEV_SLC_MODE){
		pages_read = pages_per_blk >> 1;
	}else{
		pages_read = pages_per_blk;
	}

	start_blk = (offset >> phys_erase_shift); 
	tmp_blk = start_blk;
	total_blk = (offset >> phys_erase_shift)+ RESERVED_BLOCK_CNT;
#if 1
	for(start_blk;start_blk < total_blk; start_blk++){
		read_failed_page =0;
		read_middle_page_failed = 0;
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
		ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);
		ret = operation->block_isbad(aml_chip);
		if(ret){
			aml_nand_msg("nand block at blk %d is bad ", start_blk);
			continue;
		}
		for(i=0; i<pages_read;){	
			
			memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
			if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
				ops_para->option |= DEV_SLC_MODE;
			ops_para->page_addr =(i+(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
			ops_para->chipnr = start_blk % controller->chip_num;	
			controller->select_chip(controller, ops_para->chipnr);
			
			if((ops_para->option & DEV_SLC_MODE)) {
				if((flash->new_type > 0) && (flash->new_type < 10))
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
				if (flash->new_type == SANDISK_19NM) 
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
			}
			ops_para->data_buf = aml_chip->user_page_buf;
			ops_para->oob_buf = aml_chip->user_oob_buf;
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
			
			if ((ops_para->ecc_err) || (ret < 0)){
				aml_nand_msg("nand blk check good but read failed at chip %d page %d", ops_para->chipnr, ops_para->page_addr);			
				read_failed_page++;
				i +=(size >> phys_page_shift) + 1;	
				if((read_failed_page > 8)&&(read_middle_page_failed == 0)){
					aml_nand_msg("read_failed_page = %d, now read middle part",read_failed_page);
					i = ((size >> phys_page_shift) + 1)*((pages_per_blk/((size >> phys_page_shift) + 1))>>1);
					read_middle_page_failed = -1;
				}else if(read_middle_page_failed == -1){
					aml_nand_msg("read_failed_page = %d, now read last part",read_failed_page);
					i = ((size >> phys_page_shift) + 1)*((pages_per_blk/((size >> phys_page_shift) + 1)));
					read_middle_page_failed = -2;
				}
				continue;
			}

			memcpy((unsigned char *)arg_oob_info,  aml_chip->user_oob_buf,sizeof(oob_buf));
			if ((!memcmp(arg_oob_info->name, name, 4))){

				if(arg_info->arg_valid == 1){
					if(arg_oob_info->timestamp > arg_info->timestamp){
					
						arg_info->free_blk_addr = arg_info->valid_blk_addr;
						arg_info->valid_blk_addr = start_blk;
						arg_info->timestamp = arg_oob_info->timestamp;
					}
					else{
						arg_info->free_blk_addr = start_blk;
					}
					break;
				}
				else{
					arg_info->arg_valid= 1;
					arg_info->valid_blk_addr = start_blk;
					arg_info->timestamp = arg_oob_info->timestamp;
				}			
			}
			break;
		}
		
		if((arg_info->arg_type == FULL_BLK) && (arg_info->arg_valid == 1)&&(arg_info->valid_blk_addr != 0)){
			break;
		}
	}
#else	
	do{ 		
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
		ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);
		ret = operation->block_isbad(aml_chip);
		if(ret < 0){
			aml_nand_msg("nand block at blk %d is bad ", start_blk);
			continue;
		}
		
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
			if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE;
		ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;	
		controller->select_chip(controller, ops_para->chipnr );
		
			if((ops_para->option & DEV_SLC_MODE)) {
				if((flash->new_type > 0) && (flash->new_type <10))
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
				if (flash->new_type == SANDISK_19NM) 
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
			}
		
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
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
		if ((ops_para->ecc_err) || (ret < 0)){
			aml_nand_msg("nand blk check good but read failed at chip %d page %d", ops_para->chipnr, ops_para->page_addr);			
			continue;
		}
		
#if 0		
	aml_nand_dbg(" ops_para->oob_buf : %x %x %x %x %x %x %x %x", \
		ops_para->oob_buf [0], ops_para->oob_buf [1], ops_para->oob_buf [2], ops_para->oob_buf [3], ops_para->oob_buf [4], \
		ops_para->oob_buf [5], ops_para->oob_buf [6], ops_para->oob_buf [7]);
#endif	
		memcpy((unsigned char *)arg_oob_info,  aml_chip->user_oob_buf,sizeof(oob_buf));
		if ((!memcmp(arg_oob_info->name, name, 4))){
			
			if(arg_info->arg_valid == 1){
				if(arg_oob_info->timestamp > arg_info->timestamp){
				
					arg_info->free_blk_addr = arg_info->valid_blk_addr;
					arg_info->valid_blk_addr = start_blk;
					arg_info->timestamp = arg_oob_info->timestamp;
				}
				else{
					arg_info->free_blk_addr = start_blk;
				}
				break;
			}
			else{
				arg_info->arg_valid= 1;
				arg_info->valid_blk_addr = start_blk;
				arg_info->timestamp = arg_oob_info->timestamp;
			}			
		}
		
		if((arg_info->arg_type == FULL_BLK) && (arg_info->arg_valid == 1)&&(arg_info->valid_blk_addr != 0)){
			break;
		}		
	}while((++start_blk) < total_blk);
#endif
	
	if(arg_info->arg_valid == 1){	

			if(arg_info->arg_type == FULL_BLK){
				for (i=0; i<pages_read;){
					
					memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
					ops_para->data_buf = NULL;	//aml_chip->user_page_buf;
					ops_para->oob_buf = aml_chip->user_oob_buf;
					ops_para->ooblen = sizeof(oob_buf);
					memset((unsigned char *)ops_para->oob_buf, 0x0, sizeof(oob_buf));
					
					if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
						ops_para->option |= DEV_SLC_MODE;
					
					ops_para->page_addr =(i+(((arg_info->valid_blk_addr - arg_info->valid_blk_addr % controller->chip_num) \
						/controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);

					if((ops_para->option & DEV_SLC_MODE)) {
						if((flash->new_type > 0) && (flash->new_type <10))
							ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
						if (flash->new_type == SANDISK_19NM) 
							ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
					}

					ops_para->chipnr = arg_info->valid_blk_addr % controller->chip_num; 
					controller->select_chip(controller, ops_para->chipnr );
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
					if ((ops_para->ecc_err)||(ret < 0)){
						aml_nand_msg("nand read %s failed at chip %d page %d",name, ops_para->chipnr, ops_para->page_addr);
						i +=(size >> phys_page_shift) + 1;
						arg_info->update_flag = 1;
						continue;
					}
		
					memcpy((unsigned char *)arg_oob_info,  aml_chip->user_oob_buf,sizeof(oob_buf));
					if (!memcmp(arg_oob_info->name, name, 4)){
						arg_info->valid_page_addr = i;				
						arg_info->timestamp = arg_oob_info->timestamp;
						break;
					}
					i +=(size >> phys_page_shift) + 1;	
				}
			}
			else if(arg_info->arg_type == FULL_PAGE){
				for (i=0; i<pages_read;){
					memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
					if((flash->new_type) &&((flash->new_type < 10)||(flash->new_type == SANDISK_19NM)))
						ops_para->option |= DEV_SLC_MODE;

					ops_para->data_buf = aml_chip->user_page_buf;
					ops_para->oob_buf = aml_chip->user_oob_buf;
					ops_para->ooblen = sizeof(oob_buf);
					memset((unsigned char *)ops_para->data_buf, 0x0, flash->pagesize);
					memset((unsigned char *)ops_para->oob_buf, 0x0, sizeof(oob_buf));
					
					ops_para->page_addr =(i+(((arg_info->valid_blk_addr - arg_info->valid_blk_addr % controller->chip_num) \
						/controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
					
					if((ops_para->option & DEV_SLC_MODE)) {
						if((flash->new_type > 0) && (flash->new_type <10))
							ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
						if (flash->new_type == SANDISK_19NM) 
							ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
					}

					ops_para->chipnr = arg_info->valid_blk_addr % controller->chip_num; 
					controller->select_chip(controller, ops_para->chipnr );
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
					if ((ops_para->ecc_err) || (ret < 0)){
						aml_nand_msg("nand read %s failed at chip %d page %d", name,ops_para->chipnr, ops_para->page_addr);
						i +=(size >> phys_page_shift) + 1;					
						arg_info->update_flag = 1;
						continue;
					}
		
					memcpy((unsigned char *)arg_oob_info,  aml_chip->user_oob_buf,sizeof(oob_buf));
					if (!memcmp(arg_oob_info->name, name, 4)){
						arg_info->valid_page_addr = i;
						arg_info->timestamp = arg_oob_info->timestamp;
					}else{		
						break;
					}
					i +=(size >> phys_page_shift) + 1;	
				}
				
			}
		
		for(i=0; i<RESERVED_BLOCK_CNT; i++){
			if(aml_chip->reserved_blk[i] == 0xff){
				aml_chip->reserved_blk[i] = arg_info->valid_blk_addr;
				break;
			}
		}	
		aml_nand_dbg("NAND CKECK :  %s success at blk:%d page %d", name,arg_info->valid_blk_addr,arg_info->valid_page_addr);
	}

	aml_nand_msg("NAND CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					name,arg_info->arg_valid, arg_info->valid_blk_addr, arg_info->valid_page_addr);
	aml_nand_dbg(" complete ");


	return ret;
	
exit_error0:

	return ret;
}


int amlnand_info_init(struct amlnand_chip *aml_chip,unsigned char * info,unsigned char * buf,unsigned char *name,unsigned size)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	nand_arg_info * arg_info = (struct _nand_arg_info *)info;
	 nand_arg_oobinfo * arg_oob_info;	
	 
	int i, ret =0;
	
	aml_nand_dbg("NAME :  %s",name);
	
	ret = amlnand_check_info_by_name(aml_chip, arg_info ,name,size);
	if(ret < 0){
		aml_nand_msg("nand check info failed");
		goto exit_error;
	}

	if(arg_info->arg_valid == 1){
		ret = amlnand_read_info_by_name(aml_chip, arg_info,buf, name,size);
		if(ret < 0){
			aml_nand_msg("nand check info success but read failed");
			goto exit_error;
		}
		ret = aml_info_check_datasum(buf,name);
		if(ret < 0){
			aml_nand_msg("amlnand_info_init  : nand check read %s failed",name);
			//ret = 0;
			goto exit_error;
		}
	}else{
		aml_nand_msg("found NO arg : %s info",name);
	}
			
exit_error:

	return ret;
}


/*****************************************************************************
*Name         :amlnand_update_bbt
*Description :update bbt by block status 
*Parameter  :
*Return       :
*Note          :
*****************************************************************************/
int amlnand_update_bbt(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = &aml_chip->operation;
	struct nand_flash *flash = &aml_chip->flash;		
	
	unsigned total_blk,pages_per_blk, chipnr ;
	unsigned char phys_erase_shift, phys_page_shift;
	unsigned short *tmp_status, *tmp_bbt;
	int ret = 0, i, j;
	uint64_t tmp_size;
	
aml_nand_dbg("amlnand_update_bbt  :here!!");
	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));

	tmp_size = flash->chipsize;
	total_blk = (int) ((tmp_size<<20) >> phys_erase_shift);

#if 0
//show the bbt
	aml_nand_dbg("show the bbt");
	for(chipnr= 0; chipnr < controller->chip_num; chipnr++){		
	tmp_arr = &aml_chip->bbt_ptr->nand_bbt[chipnr][0];  			
		for(start_block=0; start_block < 200; start_block++){	
			aml_nand_msg(" tmp_arr[%d][%d]=%d", chipnr, start_block, tmp_arr[start_block]);
		}
	}
#endif
	aml_chip->block_status->crc = aml_info_checksum(aml_chip->block_status->blk_status,(MAX_CHIP_NUM*MAX_BLK_NUM));
	ret = amlnand_save_info_by_name(aml_chip,&(aml_chip->nand_bbtinfo),aml_chip->block_status,BBT_HEAD_MAGIC, sizeof(struct block_status));
	if(ret < 0){
		aml_nand_msg("nand update bbt failed");
		goto exit_error0;
	}

	return ret;
	
exit_error0:

	return ret;
}


/*****************************************************************************
*Name         :amlnand_init_block_status
*Description :init the block_status table by bbt;
*Parameter  :
*Return       :
*Note          :
*****************************************************************************/
int amlnand_init_block_status(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = &aml_chip->operation;
	struct nand_flash *flash = &aml_chip->flash;		
	struct shipped_bbt * shipped_bbt_ptr = aml_chip->shipped_bbt_ptr;

	unsigned start_blk, total_blk, chipnr,tmp_num, pages_per_blk, offset, nand_boot ;
	unsigned short * tmp_bbt, *tmp_status,*status;
	unsigned char phys_erase_shift, phys_page_shift;
	uint64_t tmp_size;
	int ret = 0, i, j;
	aml_nand_dbg("amlnand_init_block_status : start");

	nand_boot = 1;
	if(boot_device_flag == 0){
		nand_boot = 0;
	}	

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else {
		offset = 0;
	}

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));

	tmp_size = flash->chipsize;
	start_blk = offset >> phys_erase_shift;
	total_blk = (int) ((tmp_size<<20) >> phys_erase_shift);
		
#if 0
	aml_nand_dbg("show the bbt");
	for(chipnr= 0; chipnr < controller->chip_num; chipnr++){		
	tmp_arr = &aml_chip->bbt_ptr->nand_bbt[chipnr][0];  			
		for(start_block=0; start_block < 200; start_block++){	
			aml_nand_msg(" tmp_arr[%d][%d]=%d", chipnr, start_block, tmp_arr[start_block]);
		}
	}
#endif

	for(chipnr=0; chipnr < controller->chip_num;  chipnr++){	
		tmp_bbt = &aml_chip->shipped_bbt_ptr->shipped_bbt[chipnr][0];
		tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
		//for (i= start_blk; i < total_blk; i++){
		for (i= 0; i < total_blk; i++){	
			if(tmp_status[i] == NAND_BLOCK_FACTORY_BAD){
				tmp_status[i] =NAND_BLOCK_FACTORY_BAD;
			}else
				tmp_status[i] = NAND_BLOCK_GOOD;			
			for(j=0; j<MAX_BAD_BLK_NUM; j++){
				if ( (tmp_bbt[j] & 0x7fff) == i ){
					if((tmp_bbt[j] & 0x8000)){
							tmp_status[i] = NAND_BLOCK_FACTORY_BAD;
							for(tmp_num=0;tmp_num < controller->chip_num;  tmp_num++){
								status = &aml_chip->block_status->blk_status[tmp_num][0];
								status[i] = NAND_BLOCK_FACTORY_BAD;
							}
							aml_nand_dbg("tmp_status[%d][%d]=%d",chipnr,i,tmp_status[i] );
						}
						else{
							if (i == 0)
								tmp_status[i] = NAND_BLOCK_GOOD;
							else{
								tmp_status[i] = NAND_BLOCK_USED_BAD;	
								aml_nand_dbg("tmp_status[%d][%d]=%d",chipnr,i,tmp_status[i] );
							}
						}
					break;
					}
				}
			}
		}

#if 0
	aml_nand_dbg("show the block status ");
	unsigned short *tmp_arr;
	int start_block;
	for(chipnr= 0; chipnr < controller->chip_num; chipnr++){		
		tmp_arr = &aml_chip->block_status->blk_status[chipnr][0];  			
			for(start_block=0; start_block < 50; start_block++){	
				aml_nand_msg(" tmp_arr[%d][%d]=%d", chipnr, start_block, tmp_arr[start_block]);
			}
	}
#endif

	return ret;
	
exit_error0:

	return ret;
}

#ifdef AML_NAND_UBOOT	
static int confirm_dev_para(struct dev_para*dev_para_cmp,struct amlnf_partition *config_init,int dev_flag)
{
	int ret =0, j=0,partiton_num=0;
	struct amlnf_partition *partition = NULL; 
	struct amlnf_partition * partition_ptr =NULL;
	
	for(j = 0; j < MAX_NAND_PART_NUM; j++){
		partition = &(config_init[j]);
		partition_ptr =& (dev_para_cmp->partitions[partiton_num]);
		if(partition->mask_flags == dev_flag){
			if(memcmp(partition_ptr->name, partition->name, strlen(partition->name))){
				aml_nand_msg("nand partition table changed: partition->name: from %s  to %s",partition_ptr->name,partition->name);
				ret = -1;
				break;
			}
			if(partition->size != partition_ptr->size){
				aml_nand_msg("nand partition table changed:  %s partition->size: from %llx	to %llx",partition->name,partition_ptr->size,partition->size);
				ret = -1;
				break;
			}
			if(partition_ptr->mask_flags != dev_flag){
				aml_nand_msg("nand partition table %s : mask_flag changed from %d to %d",partition->name,partition_ptr->mask_flags,partition->mask_flags);
				ret = -1;
				break;
			}
			partiton_num ++;
		}else if(partition == NULL){
			break;
		}
	}	

	if(dev_para_cmp->nr_partitions != partiton_num){
		aml_nand_msg("nand dev %s : nr_partitions num changed from %d to %d",dev_para_cmp->name,dev_para_cmp->nr_partitions,partiton_num);
		ret = -1;
	}

	return ret ;
}

static void init_dev_para(struct dev_para*dev_para_ptr,struct amlnf_partition *config_init,int dev_flag)
{
	int j=0,partiton_num=0;
	struct amlnf_partition *partition = NULL; 
	struct amlnf_partition * partition_ptr =NULL;
	
	for(j = 0; j < MAX_NAND_PART_NUM; j++){
		partition = &(config_init[j]);
		partition_ptr =& (dev_para_ptr->partitions[partiton_num]);
		if(partition->mask_flags == dev_flag){
			memcpy(partition_ptr->name, partition->name, strlen( partition->name));
			partition_ptr->size = partition->size;
			partition_ptr->mask_flags = partition->mask_flags;
			partiton_num ++;
			aml_nand_dbg("init_dev_para : partition->name %s ",partition->name);
			aml_nand_dbg("init_dev_para : partition->size %llx",partition->size);
			aml_nand_dbg("init_dev_para : partition->mask_flags %d",partition->mask_flags);	
		}else if(partition == NULL){
			break;
		}
	}	
	dev_para_ptr->nr_partitions = partiton_num;
	aml_nand_dbg("partition-> partiton_num %d",partiton_num);	

	return;
}
static void amlnand_get_dev_num(struct amlnand_chip *aml_chip,struct amlnf_partition *config_init)
{
	struct dev_para *dev_para = NULL;
	struct dev_para*dev_para_ptr =NULL;
	struct amlnf_partition *partition = NULL; 
	struct amlnf_partition * partition_ptr =NULL;
	int j, i,k,tmp_num=0,partiton_num=0,dev_num=0,ret=0;
	int device_num =PHY_DEV_NUM;
	
	if(boot_device_flag == 1){
		memcpy(aml_chip->config_ptr->dev_para[tmp_num].name, NAND_BOOT_NAME, strlen(NAND_BOOT_NAME));
		aml_chip->config_ptr->dev_para[tmp_num].nr_partitions = 0;
		aml_chip->config_ptr->dev_para[tmp_num].option = 0;
		tmp_num++;
		device_num = PHY_DEV_NUM + 1;
	}
	aml_chip->config_ptr->dev_num = device_num;

	for(i=0;tmp_num < device_num;tmp_num++,i++){
		dev_para_ptr = &(aml_chip->config_ptr->dev_para[tmp_num]);
		if(i==0){
			memcpy(dev_para_ptr->name, NAND_CACHE_NAME, strlen(NAND_CACHE_NAME));
			init_dev_para(dev_para_ptr,config_init,STORE_CACHE);
			dev_para_ptr->option = NAND_DATA_OPTION;
		}else if(i==1) {
			memcpy(dev_para_ptr->name, NAND_CODE_NAME, strlen(NAND_CODE_NAME));
			init_dev_para(dev_para_ptr,config_init,STORE_CODE);
			dev_para_ptr->option = NAND_CODE_OPTION;
		}else if(i==2) {
			memcpy(dev_para_ptr->name, NAND_DATA_NAME, strlen(NAND_DATA_NAME));
			init_dev_para(dev_para_ptr,config_init,STORE_DATA);
			dev_para_ptr->option = NAND_DATA_OPTION;
		}else {
			aml_nand_msg("amlnand_get_dev_num : something wrong here!!");
			break;
		}
	}

	return ;
}

int amlnand_configs_confirm(struct amlnand_chip *aml_chip)
{
	nand_arg_info * config_msg = &aml_chip->config_msg;
#ifdef AML_NAND_UBOOT	
	struct amlnf_partition * configs_init =  (struct amlnf_partition *) amlnand_config;
#endif
	struct nand_config * config_ptr = aml_chip->config_ptr;  

	struct dev_para *dev_para_cmp = NULL;
	unsigned char  confirm_flag=0;
	int i, tmp_num=0,ret = 0;
	int device_num =PHY_DEV_NUM;

	ret = phrase_driver_version(config_ptr->driver_version,DRV_PHY_VERSION);
	if(ret){
		aml_nand_msg("nand driver version confirm failed :  driver_version in nand  %d.%02d.%03d.%04d ",(config_ptr->driver_version >> 24)&0xff,
		(config_ptr->driver_version >> 16)&0xff,(config_ptr->driver_version >> 8)&0xff,(config_ptr->driver_version)&0xff);
		confirm_flag = 1;
	}

		
	if(boot_device_flag == 1){
		tmp_num++;
		device_num = PHY_DEV_NUM + 1;
	}

	//check device num
	if(device_num != config_ptr->dev_num){
		aml_nand_msg("nand device num changed from %d to %d %s", config_ptr->dev_num,device_num);				
		confirm_flag = 1;
	}

	for(i=0;tmp_num < device_num;tmp_num++,i++){
		dev_para_cmp = &(aml_chip->config_ptr->dev_para[tmp_num]);
		if(i==0){
			ret = confirm_dev_para(dev_para_cmp,configs_init,STORE_CACHE);
			if(ret){
				confirm_flag = 1;
				break;
			}
		}else if(i==1) {
			ret = confirm_dev_para(dev_para_cmp,configs_init,STORE_CODE);
			if(ret){
				confirm_flag = 1;
				break;
			}
		}else if(i==2) {
			ret = confirm_dev_para(dev_para_cmp,configs_init,STORE_DATA);
			if(ret){
				confirm_flag = 1;
				break;
			}
		}else {
			aml_nand_msg("amlnand_get_dev_num : something wrong here!!");
			confirm_flag = 1;
			break;
		}
	}
	 	
 	if(confirm_flag == 0){
		aml_nand_dbg("nand configs confirm all right");			
		aml_chip->shipped_bbtinfo.valid_blk_addr = config_ptr->fbbt_blk_addr;			
		for(i=0; i<RESERVED_BLOCK_CNT; i++){
			if(aml_chip->reserved_blk[i] == 0xff){				
				aml_chip->reserved_blk[i] = aml_chip->config_ptr->fbbt_blk_addr;
				break;
			}
		}
		aml_nand_dbg("nand  shipped bbt at blk:%d, nand  config at blk:%d", \
			aml_chip->shipped_bbtinfo.valid_blk_addr, aml_chip->config_msg.valid_blk_addr);		
	}
	else{
		aml_nand_msg("nand configs confirm failed");
		reset_amlchip_member(aml_chip);
		ret = -1;
	}

	return ret;
	
exit_error0:	
	return ret;
}
#endif


int aml_nand_save_hynix_info(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct read_retry_info *retry_info = &(controller->retry_info);
	struct en_slc_info *slc_info = &(controller->slc_info);

	unsigned char phys_erase_shift, phys_page_shift;	
	unsigned short  blk_addr=0,  tmp_blk,  nand_boot;
	unsigned i, j, k,offset,  pages_per_blk,pages_read;
	unsigned char oob_buf [8] ;
	int ret = 0;
	unsigned tmp_addr;
	int save_cnt =20,test_cnt = 0;

	if(retry_info->retry_cnt_lp > 20)
		save_cnt = retry_info->retry_cnt_lp;
	if((flash->new_type == 0) ||(flash->new_type > 10))
		return NAND_SUCCESS;	

	aml_nand_dbg("aml_nand_save_hynix_info : here!! ");

	nand_boot = 1;	
	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else {
		offset = 0;
	}

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));
	tmp_blk = (offset >> phys_erase_shift);
	
	if((flash->new_type) &&(flash->new_type < 10))
		ops_para->option |= DEV_SLC_MODE;
	
	if(ops_para->option & DEV_SLC_MODE){
		pages_read = pages_per_blk >> 1;
	}else{
		pages_read = pages_per_blk;
	}

	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
	memcpy(oob_buf, HYNIX_DEV_HEAD_MAGIC, strlen(HYNIX_DEV_HEAD_MAGIC));
get_free_blk:
	ret = amlnand_get_free_block (aml_chip,blk_addr);
    blk_addr = ret;
	if(ret < 0){
		aml_nand_msg("nand get free block failed");
		ret = - NAND_BAD_BLCOK_FAILURE;
		goto exit_error0;
	}
	aml_nand_dbg("nand get free block for hynix readretry info at %d",blk_addr); 

	for(i=0; i<pages_read; i++){
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));	
		if((flash->new_type) &&(flash->new_type < 10))
			ops_para->option |= DEV_SLC_MODE;
		ops_para->page_addr = i + ((((blk_addr - blk_addr % controller->chip_num) /controller->chip_num) \
			+ tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
		ops_para->chipnr = blk_addr % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr );
		
		if((ops_para->option & DEV_SLC_MODE)&&((flash->new_type > 0) && (flash->new_type <10))){
			ops_para->page_addr =(ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);		
		}		

		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		if(flash->new_type == HYNIX_1YNM_8GB) {
			if((i>1)&&((i%2) ==0)) {
				tmp_addr =	ops_para->page_addr;
				ops_para->page_addr -=1;
				ops_para->option |= DEV_ECC_SOFT_MODE;
				ops_para->option &=DEV_SERIAL_CHIP_MODE;
				memset(aml_chip->user_page_buf, 0xff, flash->pagesize);	
				#ifdef AML_NAND_UBOOT
				nand_get_chip();
				#else
				nand_get_chip(aml_chip);
				#endif	
				ret = operation->write_page(aml_chip);
				#ifdef AML_NAND_UBOOT
				nand_release_chip();
				#else
				nand_release_chip(aml_chip);
				#endif	
				ops_para->page_addr = tmp_addr;
				ops_para->option &= DEV_ECC_HW_MODE;
				ops_para->option |=DEV_SLC_MODE;
			}
		}
		memset(aml_chip->user_page_buf, 0x0, flash->pagesize);		
		memset(aml_chip->user_oob_buf, 0x0,sizeof(oob_buf));
		memcpy((unsigned char *)aml_chip->user_page_buf, &retry_info->reg_def_val[0][0], MAX_CHIP_NUM*READ_RETRY_REG_NUM);
		memcpy(aml_chip->user_oob_buf, (unsigned char *)oob_buf, 4);
		//memcpy((unsigned char *)(aml_chip->user_page_buf + MAX_CHIP_NUM*READ_RETRY_REG_NUM), &retry_info->reg_offs_val_lp[0][0][0], MAX_CHIP_NUM*READ_RETRY_CNT*READ_RETRY_REG_NUM);
		#ifdef  DEBUG_HYNIX_DEF
		for(k=0; k<controller->chip_num; k++)
		for(j=0;j<save_cnt;j++) {
			memcpy((unsigned char *)(aml_chip->user_page_buf + MAX_CHIP_NUM*READ_RETRY_REG_NUM+j*READ_RETRY_REG_NUM+k*save_cnt),&retry_info->reg_offs_val_lp[k][j][0],READ_RETRY_REG_NUM);
		}
		#else
			memcpy((unsigned char *)(aml_chip->user_page_buf + MAX_CHIP_NUM*READ_RETRY_REG_NUM), &retry_info->reg_offs_val_lp[0][0][0], MAX_CHIP_NUM*READ_RETRY_CNT*READ_RETRY_REG_NUM);
		#endif
#ifdef AML_NAND_UBOOT
		nand_get_chip();
#else
		nand_get_chip(aml_chip);
#endif	
		ret = operation->write_page(aml_chip);
#ifdef AML_NAND_UBOOT
		nand_release_chip();
#else
		nand_release_chip(aml_chip);
#endif	
		if(ret < 0){
			aml_nand_msg("aml_nand_save_hynix_info : nand write failed");
            if(test_cnt>=3){
                printk("test block 3 times, operating environment maybe wrong!\n");
                break;
                }
                ret = operation->test_block_reserved(aml_chip,blk_addr);
                test_cnt++;
                if(ret){
    			ret = operation->block_markbad(aml_chip);
    			if(ret < 0){
    				aml_nand_dbg("nand mark bad block failed at blk %d", blk_addr); 				
        			}
                }
			goto get_free_blk;
		}

	}

	if(ret < 0){
		aml_nand_msg("hynix nand save readretry info failed");
		goto exit_error0;
	}else{

		for(j=0; j<RESERVED_BLOCK_CNT; j++){
			if(aml_chip->reserved_blk[j] ==0xff){
				aml_chip->reserved_blk[j] = blk_addr;
				break;
			}
		}
		retry_info->info_save_blk = blk_addr;
		aml_nand_dbg("hynix nand save readretry info success at blk %d",blk_addr);
	}

exit_error0:
	return ret;
}
int aml_nand_scan_hynix_info(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct read_retry_info *retry_info = &(controller->retry_info);
	struct en_slc_info *slc_info = &(controller->slc_info);

	unsigned char phys_erase_shift, phys_page_shift;	
	unsigned short start_blk, tmp_blk, total_blk, nand_boot;
	unsigned i, j, k, n, offset,  pages_per_blk, pages_read;
	unsigned char oob_buf [8] ;
	int nand_type, ret = 0;
	int save_cnt = 20;
	if(retry_info->retry_cnt_lp > 20)
		save_cnt = retry_info->retry_cnt_lp;
	
	if((flash->new_type == 0) ||(flash->new_type > 10))
		return NAND_SUCCESS;	
	
	nand_boot = 1;			
	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else {
		offset = 0;
	}

	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));	
	
	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	if((flash->new_type) &&(flash->new_type < 10))
		ops_para->option |= DEV_SLC_MODE;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));

	if(ops_para->option & DEV_SLC_MODE){
		pages_read = pages_per_blk >> 1;
	}else{
		pages_read = pages_per_blk;
	}
	
	retry_info->default_flag = 0;
	retry_info->flag = 0;
	
	start_blk = (int)(offset >> phys_erase_shift);
	tmp_blk = start_blk;
	total_blk = (offset >> phys_erase_shift)+RESERVED_BLOCK_CNT;
	do{
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));	
		ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr );
		
		nand_type = flash->new_type;
		flash->new_type = 0;
		ret = operation->block_isbad(aml_chip);
		flash->new_type = nand_type;
		if(ret == NAND_BLOCK_FACTORY_BAD){
			aml_nand_msg("nand block at blk %d is bad ", start_blk);
			continue;
		}

		for(i=0;i<pages_read; i++){
			
			memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));	

			if((flash->new_type) &&(flash->new_type < 10))
				ops_para->option |= DEV_SLC_MODE;
			ops_para->data_buf = aml_chip->user_page_buf;
			ops_para->oob_buf = aml_chip->user_oob_buf;
			ops_para->ooblen = sizeof(oob_buf);		
			ops_para->page_addr =(i +(((start_blk - start_blk % controller->chip_num) /controller->chip_num) + tmp_blk -tmp_blk/controller->chip_num) * pages_per_blk);
			if((ops_para->option & DEV_SLC_MODE)&&((flash->new_type > 0) && (flash->new_type <10))){
				ops_para->page_addr =(ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
			}
			ops_para->chipnr = start_blk % controller->chip_num;		
			controller->select_chip(controller, ops_para->chipnr );
			
			memset((unsigned char *)ops_para->data_buf, 0x0, flash->pagesize);
			memset((unsigned char *)ops_para->oob_buf, 0x0, sizeof(oob_buf));
			
			nand_type = flash->new_type;
			flash->new_type = 0;
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
			flash->new_type = nand_type;
			if ((ops_para->ecc_err) ||(ret < 0)){
				aml_nand_msg("blk check good but read failed at chip %d page %d", ops_para->chipnr, ops_para->page_addr);
				continue;
			}
			
			memcpy(oob_buf, aml_chip->user_oob_buf,  sizeof(oob_buf));
			if (!memcmp(oob_buf, HYNIX_DEV_HEAD_MAGIC, strlen(HYNIX_DEV_HEAD_MAGIC))){
				memcpy(&retry_info->reg_def_val[0][0], (unsigned char *)aml_chip->user_page_buf, MAX_CHIP_NUM*READ_RETRY_REG_NUM);
				aml_nand_msg("hynix nand get default reg value at blk:%d, page:%d", start_blk, ops_para->page_addr);

				for(k=0; k<controller->chip_num; k++){
					for(j=0; j<retry_info->reg_cnt_lp; j++)
						aml_nand_dbg(" REG(0x%x):	value:0x%x, for chip[%d]",retry_info->reg_addr_lp[j], retry_info->reg_def_val[k][j], k);					
				}
				
				if((flash->new_type == HYNIX_20NM_8GB) || (flash->new_type == HYNIX_20NM_4GB)|| (flash->new_type == HYNIX_1YNM_8GB)){
					//memcpy(&retry_info->reg_offs_val_lp[0][0][0], (unsigned char *)(aml_chip->user_page_buf+MAX_CHIP_NUM*READ_RETRY_REG_NUM), 		
					//						MAX_CHIP_NUM*READ_RETRY_CNT*READ_RETRY_REG_NUM);

					#ifdef  DEBUG_HYNIX_DEF
					for(n=0; n<controller->chip_num; n++){
						for(j=0; j < save_cnt; j++){
							memcpy(&retry_info->reg_offs_val_lp[n][j][0], (unsigned char *)(aml_chip->user_page_buf + MAX_CHIP_NUM*READ_RETRY_REG_NUM+j*READ_RETRY_REG_NUM+n*save_cnt), 		
											READ_RETRY_REG_NUM);
						}
					}
					#else
						memcpy(&retry_info->reg_offs_val_lp[0][0][0], (unsigned char *)(aml_chip->user_page_buf+MAX_CHIP_NUM*READ_RETRY_REG_NUM), 		
											MAX_CHIP_NUM*READ_RETRY_CNT*READ_RETRY_REG_NUM);
					#endif
				}
				for(n=0; n<controller->chip_num; n++){
						for(j=0; j < retry_info->retry_cnt_lp; j++){
							for(k=0; k<retry_info->reg_cnt_lp; k++)
							aml_nand_dbg(" Retry%dst, REG(0x%x):   value:0x%2x, for chip[%d]", k, retry_info->reg_addr_lp[k], retry_info->reg_offs_val_lp[n][j][k], n);
					}
				}
				
				retry_info->default_flag = 1;
				retry_info->flag = 1;
					break;
			}
			else{
				aml_nand_dbg("read OK but magic is not hynix");
				break;
			}

		}
		
			if(retry_info->default_flag && flash->new_type)
					break;
	}while((++start_blk)< total_blk);

	if(retry_info->default_flag && flash->new_type){	
		retry_info->info_save_blk = start_blk;
		for(i=0; i<RESERVED_BLOCK_CNT; i++){
			if(aml_chip->reserved_blk[i] == 0xff){
				aml_chip->reserved_blk[i] = start_blk;
				break;
			}
		}
	}
	
	return ret;
}
#ifdef AML_NAND_UBOOT	

/*****************************************************************************
 *Name		:shipped_badblock_detect
 *Description :Detect factory badblock once using the nand flash first time
 *Parameter  :
 *Return	      :
 *Note	      :
 *****************************************************************************/
  static int shipped_badblock_detect(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct shipped_bbt * shipped_bbt_ptr = aml_chip->shipped_bbt_ptr;
	unsigned short * tmp_arr;
	
	int pages_per_blk, start_block, total_block, nand_boot, start_blk;
	int  chipnr, offset, offset_tmp, read_cnt, page_addr, col0_data, col_data_sandisk[6],  col0_oob = 0xff;
	unsigned char *data_buf, *oob_buf, phys_erase_shift, phys_page_shift;	
	int i, ret = 0, factory_badblock_cnt;
	uint64_t  tmp_blk;
	aml_nand_dbg("here!! ");

	nand_boot = 1;
	if(boot_device_flag == 0){
		nand_boot = 0;
	}

	if (nand_boot)
		offset_tmp = (1024 * flash->pagesize);
	else {
		offset_tmp = 0;
	}	

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift -phys_page_shift));

	start_blk = offset_tmp >> phys_erase_shift;
	tmp_blk = flash->chipsize;
	total_block = (int) ((tmp_blk<<20) >> phys_erase_shift);
	
	aml_nand_dbg("phys_erase_shift=%d ",phys_erase_shift);
	aml_nand_dbg("flash->chipsize =%d ",flash->chipsize);
	aml_nand_dbg("flash->blocksize =%d ",flash->blocksize);	
	aml_nand_dbg("start_blk =%d ",start_blk);
	aml_nand_dbg("total_block =%d ",total_block);
	aml_nand_dbg("pages_per_blk =%d ",pages_per_blk);
	//block 0 never bad block, so init table into 0
	memset((unsigned char *)shipped_bbt_ptr, 0x0, (sizeof(struct shipped_bbt)));
#ifdef AML_NAND_UBOOT
		nand_get_chip();
#else
		nand_get_chip(aml_chip);
#endif		

	for(chipnr=0; chipnr < controller->chip_num; chipnr++){		
		aml_nand_dbg("chipnr=%d",chipnr);
		factory_badblock_cnt = 0;
		tmp_arr = &aml_chip->shipped_bbt_ptr->shipped_bbt[chipnr][0];  
		controller->select_chip(controller, chipnr);
		for(start_block=start_blk; start_block < total_block; start_block++){
		//for(start_block = 0; start_block < total_block; start_block++){
			if(((start_block ==  ((aml_chip->nand_key.valid_blk_addr +(controller->chip_num -1)*4)/controller->chip_num))&&(aml_chip->nand_key.arg_valid))
				||((start_block ==  ((aml_chip->nand_secure.valid_blk_addr +(controller->chip_num -1)*4)/controller->chip_num))&&(aml_chip->nand_secure.arg_valid))){
				aml_nand_msg("shipped_badblock_detect skip block %d,chipnr %d",start_block,chipnr);
				continue;
			}
			offset = pages_per_blk*start_block;
			for (read_cnt=0; read_cnt<2; read_cnt++){
				
				if((controller->mfr_type  == NAND_MFR_SANDISK ))
					page_addr = offset + read_cnt; // page0 page1
				else
					page_addr = offset + read_cnt*(pages_per_blk-1); // page_num

				if(unlikely(page_addr >= controller->internal_page_nums)) {
					page_addr -= controller->internal_page_nums;
					page_addr |= controller->internal_page_nums *aml_chip->flash.internal_chipnr;
				}
				controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
				controller->cmd_ctrl(controller, 0, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, 0, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, page_addr, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, page_addr>>8, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, page_addr>>16, NAND_CTRL_ALE);
				controller->cmd_ctrl(controller, NAND_CMD_READSTART, NAND_CTRL_CLE);

				NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);	

				ret = controller->quene_rb(controller, chipnr);
				if(ret){
					aml_nand_msg("quene rb busy here");
					ret = -NAND_BUSY_FAILURE;
					goto error_exit0;
				}

				 if(controller->option & NAND_CTRL_NONE_RB){
					controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);				
					NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TWB_TIME_CYCLE);			
				}
			
				if((controller->mfr_type  == NAND_MFR_SANDISK )){
					for(i = 0; i < 6; i++){			
						col_data_sandisk[i] = controller->readbyte(controller);
						if(col_data_sandisk[i] == 0x0){
							col0_oob = 0x0;
							break;
						}
					}
				}else	{
					col0_data = controller->readbyte(controller);		
					//TRHW
					NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TRHW_TIME_CYCLE);

					controller->cmd_ctrl(controller, NAND_CMD_RNDOUT, NAND_CTRL_CLE);
					controller->cmd_ctrl(controller, flash->pagesize, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, flash->pagesize>>8, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, NAND_CMD_RNDOUTSTART, NAND_CTRL_CLE);
					//TCCS
					NFC_SEND_CMD_IDLE(controller->chip_selected, NAND_TCCS_TIME_CYCLE);
					
					col0_oob = controller->readbyte(controller); 
				}
					
				if(((controller->mfr_type == NAND_MFR_SAMSUNG ) && ((col0_oob != 0xFF) || (col0_data != 0xFF)))
					|| ((controller->mfr_type == NAND_MFR_TOSHIBA ) && ((col0_oob != 0xFF) || (col0_data != 0xFF)))
					||((controller->mfr_type  == NAND_MFR_MICRON ) && ((col0_oob == 0x0) ||(col0_oob != 0xFF)))
					||((controller->mfr_type  == NAND_MFR_HYNIX ) && (col0_oob != 0xFF))
					||((controller->mfr_type  == NAND_MFR_SANDISK ) && (col0_oob != 0xFF))){
				
					col0_oob = 0xff;
					aml_nand_msg("mfr_type:%x detect factory Bad block at read_cnt:%d and block:%d and chip:%d", \
											controller->mfr_type, read_cnt, start_block, chipnr);
					tmp_arr[factory_badblock_cnt] = start_block |0x8000;
					//aml_nand_msg("start_block is bad block = %d, tmp_arr[factory_badblock_cnt] = %d", \
						//start_block, tmp_arr[factory_badblock_cnt]);

					if (start_block < start_blk){
						aml_nand_msg("WARNING: UBOOT AREA  BLOCK %d IS BAD BLOCK",start_block);
					}
					
					if ((controller->flash_type == NAND_TYPE_MLC) && (flash->option & NAND_MULTI_PLANE_MODE)){
						if ((start_block % 2) == 0 ){		// if  plane 0 is bad block,just set plane 1 to bad 
							start_block+=1;
							tmp_arr[++factory_badblock_cnt] = start_block |0x8000;						
							//aml_nand_msg(" plane 0 is bad block,just set plane 1 to bad:");					
						}else{					// if plane 1 is bad block, just set plane 0 to bad
							tmp_arr[++factory_badblock_cnt]= (start_block -1) |0x8000;											
							//aml_nand_msg(" plane 1 is bad block,just set plane 0 to bad:");
						}
					}
					
					//bad block should less than 6% of total blocks
					if((factory_badblock_cnt++ >= (total_block/20))){
						aml_nand_msg("detect factory bad block over 6%, hardware problem and factory_badblock_cnt:%d, total_block:%d, chipnr:%d !!!", \
												factory_badblock_cnt, total_block, chipnr);
						if(aml_chip->shipped_retry_flag){
							ret  = -NAND_STATUS_FAILURE;
						}else{
							aml_chip->shipped_retry_flag = 1;
							reset_amlchip_member(aml_chip);
							amlnand_config_buf_free(aml_chip);
							ret= -NAND_SHIPPED_BADBLOCK_FAILED;
						}	
						goto error_exit0;
					}
					break;

				}

			}
		}
		
		aml_nand_msg("shipped bad block scan complete: chip %d, factory_badblock_cnt =%d (total_block/10) =%d",chipnr, factory_badblock_cnt,(total_block/10));
	}

#if 0
	//display the fbbt
	for(chipnr= 0; chipnr < controller->chip_num; chipnr++){		
		tmp_arr = &aml_chip->shipped_bbt_ptr->shipped_bbt[chipnr][0];  			
			for(start_block=0; start_block < 200; start_block++){	
				aml_nand_msg(" tmp_arr[%d][%d]=%d", chipnr, start_block, tmp_arr[start_block]);
			}
	}
#endif	
	
#ifdef AML_NAND_UBOOT
		nand_release_chip();
#else
		nand_release_chip(aml_chip);
#endif		

	return ret;	
	
error_exit0:	
#ifdef AML_NAND_UBOOT
		nand_release_chip();
#else
		nand_release_chip(aml_chip);
#endif	
	return ret;	
}

#endif

void amlnand_config_buf_free(struct amlnand_chip *aml_chip)
{
	if (aml_chip->block_status) {
		kfree(aml_chip->block_status);
		aml_chip->block_status = NULL;
	}
	if (aml_chip->shipped_bbt_ptr) {
		kfree(aml_chip->shipped_bbt_ptr);
		aml_chip->shipped_bbt_ptr = NULL;
	}
	if (aml_chip->config_ptr) {
		kfree(aml_chip->config_ptr);
		aml_chip->config_ptr = NULL;
	}
	if (aml_chip->user_oob_buf) {
		kfree(aml_chip->user_oob_buf);
		aml_chip->user_oob_buf = NULL;
	}
	if (aml_chip->user_page_buf) {
		kfree(aml_chip->user_page_buf);
		aml_chip->user_page_buf = NULL;
	}
	if(amlnand_config){
		kfree(amlnand_config);
		amlnand_config = NULL;
	}
}

static int amlnand_config_buf_malloc(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = & aml_chip->ops_para; 
	unsigned ret =0, buf_size;

	buf_size = flash->oobsize * controller->chip_num;
	if(flash->option & NAND_MULTI_PLANE_MODE){
		buf_size <<= 1;
	}

	aml_chip->user_oob_buf= aml_nand_malloc(buf_size);
	if(aml_chip->user_oob_buf == NULL){
		aml_nand_msg("malloc failed for user_oob_buf ");
		ret = -NAND_MALLOC_FAILURE;
		goto exit_error0;
	}
	memset(aml_chip->user_oob_buf,0x0,buf_size);
	buf_size = (flash->pagesize + flash->oobsize)* controller->chip_num;
	if(flash->option & NAND_MULTI_PLANE_MODE){
		buf_size <<= 1;
	}

	aml_chip->user_page_buf= aml_nand_malloc(buf_size);
	if(aml_chip->user_page_buf == NULL){
		aml_nand_msg("malloc failed for user_page_buf ");
		ret = -NAND_MALLOC_FAILURE;
		goto exit_error0;
	}
	memset(aml_chip->user_page_buf,0x0,buf_size);

	aml_chip->block_status = (unsigned short *)aml_nand_malloc(sizeof(struct block_status));
	if (aml_chip->block_status == NULL){
		aml_nand_msg("nand malloc memory failed for block_status and size:%x", sizeof(struct block_status));
		ret = -NAND_MALLOC_FAILURE;
		goto exit_error0;
	}
	memset(aml_chip->block_status,0x0,(sizeof(struct block_status)));
	aml_chip->shipped_bbt_ptr = aml_nand_malloc(sizeof(struct shipped_bbt));
	if(aml_chip->shipped_bbt_ptr == NULL){
		aml_nand_msg("malloc failed for shipped_bbt_ptr ");
		ret = -NAND_MALLOC_FAILURE;
		goto exit_error0;
	}
	memset(aml_chip->shipped_bbt_ptr,0x0,(sizeof(struct shipped_bbt)));
	
	aml_chip->config_ptr = aml_nand_malloc(sizeof(struct nand_config));
	if(aml_chip->config_ptr == NULL){
		aml_nand_msg("malloc failed for config_ptr ");
		ret = -NAND_MALLOC_FAILURE;
		goto exit_error0;
	}
	memset(aml_chip->config_ptr, 0x0, (sizeof(struct nand_config)));

	return ret;
	
exit_error0:
	amlnand_config_buf_free(aml_chip);
	return ret ;
}


void amlnand_set_config_attribute(struct amlnand_chip *aml_chip)
{
	aml_chip->nand_bbtinfo.arg_type = FULL_BLK;
	aml_chip->shipped_bbtinfo.arg_type = FULL_BLK;
	aml_chip->config_msg.arg_type = FULL_BLK;
	aml_chip->nand_secure.arg_type = FULL_PAGE;
	aml_chip->nand_key.arg_type = FULL_PAGE;  
	aml_chip->uboot_env.arg_type = FULL_PAGE;  

	return;
}

int  bbt_valid_ops(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = & aml_chip->ops_para; 
	 nand_arg_info * nand_key = &aml_chip->nand_key;  
	nand_arg_info  * nand_secure= &aml_chip->nand_secure;
	int  ret = 0;

	ret = amlnand_info_init(aml_chip, &(aml_chip->config_msg),aml_chip->config_ptr,CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
	if(ret < 0){
		aml_nand_msg("nand scan config failed and ret:%d",ret);	
		goto exit_error0;
	}

	ret = aml_sys_info_init(aml_chip); //key  and stoarge and env
	if(ret < 0){
		aml_nand_msg("nand init sys_info failed and ret:%d", ret);					
		goto exit_error0;
	}

#ifdef AML_NAND_UBOOT	
	if(aml_chip->config_msg.arg_valid == 1){
		ret = amlnand_configs_confirm(aml_chip);
		if(ret < 0){
			if((aml_chip->init_flag > NAND_BOOT_UPGRATE)&&(aml_chip->init_flag < NAND_BOOT_SCRUB_ALL)){
				ret =0;
			}else{
				aml_nand_msg("nand configs confirm failed");
				ret = -NAND_CONFIGS_FAILED;
				goto exit_error0;
			}
		}
	}else{
		ret = amlnand_info_init(aml_chip, &(aml_chip->shipped_bbtinfo),aml_chip->shipped_bbt_ptr,SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
		if(ret < 0){
			aml_nand_msg("nand scan shipped info failed and ret:%d",ret);
			goto exit_error0;
		}
		if(aml_chip->shipped_bbt_ptr->chipnum != controller->chip_num){
			aml_nand_msg("nand read chipnum in config %d,controller->chip_num",aml_chip->shipped_bbt_ptr->chipnum,controller->chip_num);
			ret = -NAND_SHIPPED_BADBLOCK_FAILED;
		}
	}
#endif

exit_error0:
	return ret;
}

int  shipped_bbt_invalid_ops(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = & aml_chip->ops_para; 
	 nand_arg_info * nand_key = &aml_chip->nand_key;  
	nand_arg_info  * nand_secure= &aml_chip->nand_secure;
	unsigned char *buf = NULL;
	unsigned int buf_size = MAX(CONFIG_SECURE_SIZE,CONFIG_KEYSIZE);
	int  ret = 0;

	  buf = aml_nand_malloc(buf_size);
	  if(!buf){
		  aml_nand_msg("aml_sys_info_init : malloc failed");
	  }
	  memset(buf,0x0,buf_size);
	    
#ifdef CONFIG_SECURITYKEY
	 ret = amlnand_info_init(aml_chip, &(aml_chip->nand_key),buf,KEY_INFO_HEAD_MAGIC, CONFIG_KEYSIZE);
	if(ret < 0){
		aml_nand_msg("invalid nand key\n");
		goto exit_error0;
	}
#endif
  
#ifdef CONFIG_SECURE_NAND
	ret = amlnand_info_init(aml_chip, &(aml_chip->nand_secure),buf,SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
	if(ret < 0){
		aml_nand_msg("invalid nand secure_ptr\n");
		goto exit_error0;
	}
#endif

	if(aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE){
		amlnand_oops_handle(aml_chip,aml_chip->init_flag);
	}
	
	  ret = shipped_badblock_detect(aml_chip);
	   if(ret < 0 ){	   
		   aml_nand_msg("nand detect factory bbt failed and ret:%d", ret);			   
		   goto exit_error0;
	   }
	   
	   ret = amlnand_init_block_status(aml_chip);
	   if(ret < 0){
		   aml_nand_msg("nand init block status failed and ret:%d", ret);
		   goto exit_error0;
	   }
	   
	//if((aml_chip->init_flag == NAND_BOOT_ERASE_ALL))
		// amlnand_oops_handle(aml_chip,aml_chip->init_flag);
	
  	ret = aml_sys_info_init(aml_chip); //key  and  stoarge
	if(ret < 0){
		aml_nand_msg("nand init sys_info failed and ret:%d", ret);					
		goto exit_error0;
	}
	
	   aml_chip->block_status->crc = aml_info_checksum(aml_chip->block_status->blk_status,(MAX_CHIP_NUM*MAX_BLK_NUM));
	   ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->nand_bbtinfo),aml_chip->block_status,BBT_HEAD_MAGIC, sizeof(struct block_status));
	   if(ret < 0){
		   aml_nand_msg("nand save bbt failed and ret:%d", ret);
		   goto exit_error0;
	   }   
	   
	   aml_chip->shipped_bbt_ptr->crc = aml_info_checksum(aml_chip->shipped_bbt_ptr->shipped_bbt,(MAX_CHIP_NUM*MAX_BAD_BLK_NUM));	
	   aml_chip->shipped_bbt_ptr->chipnum = controller->chip_num;
	   ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->shipped_bbtinfo),aml_chip->shipped_bbt_ptr,SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
	   if(ret < 0){
		   aml_nand_msg("nand save shipped bbt failed and ret:%d",ret); 		   
		   goto exit_error0;
	   }		   
	   //save config
	   aml_chip->config_ptr->driver_version = DRV_PHY_VERSION;
	   aml_chip->config_ptr->fbbt_blk_addr = aml_chip->shipped_bbtinfo.valid_blk_addr;
	   amlnand_get_dev_num(aml_chip,(struct amlnf_partition *)amlnand_config);
	   
	   aml_chip->config_ptr->crc = aml_info_checksum(aml_chip->config_ptr->dev_para,(MAX_DEVICE_NUM*sizeof(struct dev_para)));				   
	  ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->config_msg),aml_chip->config_ptr,CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
	   if(ret < 0){
		   aml_nand_msg("save nand dev_configs failed and ret:%d",ret); 		   
		   goto exit_error0;
	   }

	if(aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE){
		aml_chip->uboot_env.update_flag = 1;
		 if((aml_chip->uboot_env.arg_valid == 1) && (aml_chip->uboot_env.update_flag)){
			aml_nand_update_ubootenv(aml_chip,NULL);
			aml_chip->uboot_env.update_flag = 0;
			aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"ubootenv",aml_chip->uboot_env.arg_valid, aml_chip->uboot_env.valid_blk_addr, aml_chip->uboot_env.valid_page_addr);
		}
	}

exit_error0:
	if(buf){
		kfree(buf);
		buf = NULL;
	}		
	return ret;
}

int shipped_bbt_valid_ops(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = & aml_chip->ops_para; 
	 nand_arg_info * nand_key = &aml_chip->nand_key;  
	nand_arg_info  * nand_secure= &aml_chip->nand_secure;
	int  ret = 0;

	if(aml_chip->shipped_bbt_ptr->chipnum != controller->chip_num){
		aml_nand_msg("nand read chipnum in config %d,controller->chip_num",aml_chip->shipped_bbt_ptr->chipnum,controller->chip_num);
		ret = -NAND_SHIPPED_BADBLOCK_FAILED ;		
		goto exit_error0;
	}

	ret = amlnand_init_block_status(aml_chip);
	if(ret < 0 ){
			aml_nand_msg("nand init blcok status failed and ret:%d", ret);
			goto exit_error0;
	}			

	ret = amlnand_info_init(aml_chip, &(aml_chip->config_msg),aml_chip->config_ptr,CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
	if(ret < 0){
		aml_nand_msg("nand scan config failed and ret:%d",ret);	
		goto exit_error0;
	}

	ret = aml_sys_info_init(aml_chip); //key  and  stoarge
	if(ret < 0){
		aml_nand_msg("nand init sys_info failed and ret:%d", ret);					
		goto exit_error0;
	}
	
	if(aml_chip->init_flag == NAND_BOOT_ERASE_ALL)
		 amlnand_oops_handle(aml_chip,aml_chip->init_flag);

	aml_chip->block_status->crc = aml_info_checksum(aml_chip->block_status->blk_status,(MAX_CHIP_NUM*MAX_BLK_NUM));
	ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->nand_bbtinfo),aml_chip->block_status,BBT_HEAD_MAGIC, sizeof(struct block_status));
	if(ret < 0){
		aml_nand_msg("nand save bbt failed and ret:%d", ret);					
		goto exit_error0;
	}

	if((aml_chip->config_msg.arg_valid == 1)&&(aml_chip->init_flag != NAND_BOOT_ERASE_ALL)){
		ret = amlnand_configs_confirm(aml_chip);
		if(ret < 0){
			if((aml_chip->init_flag > NAND_BOOT_UPGRATE)&&(aml_chip->init_flag < NAND_BOOT_SCRUB_ALL)){
				ret =0;
			}else{
				aml_nand_msg("nand configs confirm failed");
				ret = -NAND_CONFIGS_FAILED;
				goto exit_error0;
			}
		}
	}else{
		//save config	
		aml_chip->config_ptr->driver_version = DRV_PHY_VERSION;
		aml_chip->config_ptr->fbbt_blk_addr = aml_chip->shipped_bbtinfo.valid_blk_addr; 
		amlnand_get_dev_num(aml_chip,(struct amlnf_partition *)amlnand_config);
	
		aml_chip->config_ptr->crc = aml_info_checksum(aml_chip->config_ptr->dev_para,(MAX_DEVICE_NUM*sizeof(struct dev_para))); 				
		ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->config_msg),aml_chip->config_ptr,CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
		if(ret < 0){
			aml_nand_msg("nand save config failed and ret:%d",ret); 		
			goto exit_error0;
		}
	}

	if(aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE){
		aml_chip->uboot_env.update_flag = 1;
		 if((aml_chip->uboot_env.arg_valid == 1) && (aml_chip->uboot_env.update_flag)){
			aml_nand_update_ubootenv(aml_chip,NULL);
			aml_chip->uboot_env.update_flag = 0;
			aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"ubootenv",aml_chip->uboot_env.arg_valid, aml_chip->uboot_env.valid_blk_addr, aml_chip->uboot_env.valid_page_addr);
		}
	}
exit_error0:		
	return ret;
}

/*****************************************************************************
*Name         :amlnand_get_dev_configs
*Description :search bbt /fbbt /config /key;
*Parameter  :
*Return       :
*Note          :
*****************************************************************************/
int amlnand_get_dev_configs(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = & aml_chip->ops_para; 
	struct read_retry_info *retry_info = &(controller->retry_info);
	struct dev_para *dev_para = NULL;
	 nand_arg_info * nand_key = &aml_chip->nand_key;  
	nand_arg_info  * nand_secure= &aml_chip->nand_secure;
	int  ret = 0, i;

#ifdef AML_NAND_UBOOT	

	ret = amlnand_get_partition_table();
	if(ret < 0){
		aml_nand_msg("nand malloc buf failed");
		goto exit_error0;		
	}
#endif
	
	ret = amlnand_config_buf_malloc(aml_chip);
	if(ret < 0){
		aml_nand_msg("nand malloc buf failed");
		goto exit_error0;		
	}
		
	if(aml_chip->flash.new_type){
		aml_nand_dbg("detect new nand here and new_type:%d", aml_chip->flash.new_type);
		ret = amlnand_set_readretry_slc_para(aml_chip);
		if(ret<0){
			aml_nand_msg("setting new nand para failed and ret:0x%x", ret);
			goto exit_error0;
		}
	}

	amlnand_set_config_attribute(aml_chip);

	if((aml_chip->init_flag == NAND_BOOT_ERASE_ALL)){
	
		ret = amlnand_info_init(aml_chip, &(aml_chip->shipped_bbtinfo),aml_chip->shipped_bbt_ptr,SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
		if(ret < 0){
			aml_nand_msg("nand scan shipped info failed and ret:%d",ret);
			//goto exit_error0;
		}

		if(aml_chip->shipped_bbtinfo.arg_valid == 0){
			ret = shipped_bbt_invalid_ops(aml_chip);
			if(ret < 0){
				aml_nand_msg("shipped_bbt_invalid_ops and ret:%d", ret);
				goto exit_error0;
			}
		}else{
			ret = shipped_bbt_valid_ops(aml_chip);
			if(ret < 0){
				aml_nand_msg("shipped_bbt_valid_ops and ret:%d", ret);
				goto exit_error0;
			}
		}
		//amlnand_oops_handle(aml_chip,aml_chip->init_flag);
		
	}
	else if(aml_chip->init_flag == NAND_BOOT_SCRUB_ALL){
		ret = shipped_bbt_invalid_ops(aml_chip);
		if(ret < 0){
			aml_nand_msg("shipped_bbt_invalid_ops and ret:%d", ret);
			goto exit_error0;
		}
	}
	else{
		//search  bbt
		ret = amlnand_info_init(aml_chip, &(aml_chip->nand_bbtinfo),aml_chip->block_status,BBT_HEAD_MAGIC, sizeof(struct block_status));
		if(ret < 0){
			aml_nand_msg("nand scan bbt info  failed :%d",ret); 	
			//goto exit_error0;
		}
	
		if(aml_chip->nand_bbtinfo.arg_valid == 0){ // bbt invalid
#ifdef AML_NAND_UBOOT		
			ret = amlnand_info_init(aml_chip, &(aml_chip->shipped_bbtinfo),aml_chip->shipped_bbt_ptr,SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
			if(ret < 0){
				aml_nand_msg("nand scan shipped info failed and ret:%d",ret);
				//goto exit_error0;
			}
			
			if(aml_chip->shipped_bbtinfo.arg_valid == 0){	// ship bbt invalid
				ret = shipped_bbt_invalid_ops(aml_chip);
				if(ret < 0){
					aml_nand_msg("shipped_bbt_invalid_ops and ret:%d", ret);
					goto exit_error0;
				}
			}
			else{		// ship bbt valid		
				ret = shipped_bbt_valid_ops(aml_chip);
				if(ret < 0){
					aml_nand_msg("shipped_bbt_valid_ops and ret:%d", ret);
					goto exit_error0;
				}
			}		
#else
				aml_nand_msg("nand scan bbt failed");
				ret = -NAND_READ_FAILED;		
				goto exit_error0;
#endif
		}
		else {		// bbt valid	
			ret = bbt_valid_ops(aml_chip);
			if(ret < 0){
				aml_nand_msg("shipped_bbt_valid_ops and ret:%d", ret);
				goto exit_error0;
			}
		}
	}

#ifdef AML_NAND_UBOOT
	if(aml_chip->config_msg.arg_valid == 0){ // if no config,just save
		aml_chip->config_ptr->driver_version = DRV_PHY_VERSION;
		aml_chip->config_ptr->fbbt_blk_addr = aml_chip->shipped_bbtinfo.valid_blk_addr;	
		amlnand_get_dev_num(aml_chip,(struct amlnf_partition *)amlnand_config);
		aml_chip->config_ptr->crc = aml_info_checksum(aml_chip->config_ptr->dev_para,(MAX_DEVICE_NUM*sizeof(struct dev_para)));					
		ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->config_msg),aml_chip->config_ptr,CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
		if(ret < 0){
			aml_nand_msg("nand save config failed and ret:%d",ret);			
			goto exit_error0;
		}
	}
	
	if(flash->new_type && (flash->new_type < 10) && (retry_info->default_flag == 0)){
		ret = aml_nand_save_hynix_info(aml_chip);
		if(ret < 0){
			aml_nand_msg("hynix nand save readretry info failed and ret:%d", ret);
			goto exit_error0;
		}
	}

	if (aml_chip->shipped_bbt_ptr) {
		kfree(aml_chip->shipped_bbt_ptr);
		aml_chip->shipped_bbt_ptr = NULL;
	}
#endif

	 amlnand_info_error_handle(aml_chip);

	if((aml_chip->init_flag == NAND_BOOT_ERASE_PROTECT_CACHE)){
		amlnand_oops_handle(aml_chip,aml_chip->init_flag);
		aml_chip->nand_bbtinfo.update_flag = 1;
		if((aml_chip->nand_bbtinfo.arg_valid)&&(aml_chip->nand_bbtinfo.update_flag)){
			ret = amlnand_update_bbt(aml_chip);
			aml_chip->nand_bbtinfo.update_flag = 0;
			aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"bbt",aml_chip->nand_bbtinfo.arg_valid,aml_chip->nand_bbtinfo.valid_blk_addr, aml_chip->nand_bbtinfo.valid_page_addr);
		}
		aml_chip->config_ptr->driver_version = DRV_PHY_VERSION;
		aml_chip->config_ptr->fbbt_blk_addr = aml_chip->shipped_bbtinfo.valid_blk_addr;	
		amlnand_get_dev_num(aml_chip,(struct amlnf_partition *)amlnand_config);
		aml_chip->config_ptr->crc = aml_info_checksum(aml_chip->config_ptr->dev_para,(MAX_DEVICE_NUM*sizeof(struct dev_para)));					
		ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->config_msg),aml_chip->config_ptr,CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
		if(ret < 0){
			aml_nand_msg("nand save config failed and ret:%d",ret);			
			goto exit_error0;
		}
		aml_chip->uboot_env.update_flag = 1;
		if((aml_chip->uboot_env.arg_valid == 1) && (aml_chip->uboot_env.update_flag)){
			aml_nand_update_ubootenv(aml_chip,NULL);
			aml_chip->uboot_env.update_flag = 0;
			aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"ubootenv",aml_chip->uboot_env.arg_valid, aml_chip->uboot_env.valid_blk_addr, aml_chip->uboot_env.valid_page_addr);
		}
	}
    repair_reserved_bad_block(aml_chip);
	return ret ;
	
exit_error0:
	amlnand_config_buf_free(aml_chip);
	return ret ;
}

