
#include "../include/phynand.h"

extern  struct amlnand_chip * aml_nand_chip;
extern void amlchip_dumpinfo(struct amlnand_chip *aml_chip);

void amlnf_dump_chipinfo(void)
{
	struct amlnand_chip *aml_chip = aml_nand_chip;
	
	amlchip_dumpinfo(aml_chip);

	return;
}

void amlnf_get_chip_size(uint64_t *size)
{
	struct amlnand_chip *aml_chip = aml_nand_chip;
	struct hw_controller *controller = &(aml_chip->controller);	
	struct nand_flash *flash = &(aml_chip->flash);	
	uint64_t chipsize=0;
	
        if(!aml_chip)return;
	chipsize=((uint64_t)(flash->chipsize*controller->chip_num))<<20;
	*size = chipsize;
	
	return ;
}
 void amlnand_dump_page(struct amlnand_phydev *phydev)
 {
	 struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	 
	 struct phydev_ops *devops = &(phydev->ops);
	 struct hw_controller *controller = &(aml_chip->controller); 
	 struct chip_operation *operation = &(aml_chip->operation);  
	 struct chip_ops_para *ops_para = &(aml_chip->ops_para);
 
	 uint64_t  dump_len =0;
	 unsigned char *tmp =  NULL;
	int ret = 0;
	 
	 ret = phydev->read(phydev);
	 if(ret<0){ 		 
		 aml_nand_msg("amlnand_dump_page : read failed page_addr:%d", ops_para->page_addr); 		 
	 }
	 aml_nand_msg("\n show the raw read BUF: ");
	 tmp = devops->datbuf;
	 dump_len =512;
	 while (dump_len--) {
			 printk("\t%02x %02x %02x %02x %02x %02x %02x %02x"
					"  %02x %02x %02x %02x %02x %02x %02x %02x\n",
					tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6], tmp[7],
					tmp[8], tmp[9], tmp[10], tmp[11], tmp[12], tmp[13], tmp[14],
					tmp[15]);
		 tmp += 16;
	 }
	 	 
	 return ;
 }


 int nand_read_ops(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller =&(aml_chip->controller);	
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	uint64_t offset , read_len;
	unsigned char * buffer;
	int ret = 0;

	offset = devops->addr;
	read_len = devops->len;
	buffer = devops->datbuf;
	
aml_nand_dbg("offset =%llx",offset);
aml_nand_dbg("write_len =%llx",read_len);

	if ((offset & (phydev->writesize - 1)) != 0 ||(read_len & (phydev->writesize - 1)) != 0){
		printf ("Attempt to read non page aligned data\n");
		return -NAND_READ_FAILED;
	}

	if((offset + read_len) > phydev->size){
		aml_nand_dbg("Attemp to read out side the dev area");		
		return -NAND_READ_FAILED;
	}
		memset(devops, 0x0, sizeof(struct phydev_ops));
		devops->addr = offset;
		devops->len = phydev->writesize;
		devops->datbuf = buffer;
		devops->oobbuf = NULL;
		devops->mode = NAND_HW_ECC;
		aml_nand_dbg("phydev->writesize= %x",phydev->writesize);		
	do{ 	
		//aml_nand_dbg("devops->addr = %llx",devops->addr);
		if((devops->addr % phydev->erasesize) == 0 ){
			//aml_nand_dbg("devops->addr = %llx",devops->addr);
			ret =  phydev->block_isbad(phydev);
			if (ret > 0){
				printf("\rSkipping bad block at %llx\n", devops->addr);
				devops->addr += phydev->erasesize;
				continue;
			} else if (ret < 0) {
				printf("\n:AMLNAND get bad block failed: ret=%d at addr=%llx\n",ret, devops->addr);
				return -1;
			}
		}
		ret = phydev->read(phydev);
		if(ret < 0){
			aml_nand_dbg("nand read failed at %llx",devops->addr);
		}
		devops->addr +=  phydev->writesize;
		devops->datbuf += phydev->writesize;
	}while(devops->addr < (offset + read_len));

	return ret;
}

 int nand_write_ops(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller);	
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	uint64_t offset , write_len;
	unsigned char * buffer;
	int ret = 0;

	offset = devops->addr;
	write_len = devops->len;
	buffer = devops->datbuf;

	if ((offset & (phydev->writesize - 1)) != 0 ||(write_len & (phydev->writesize - 1)) != 0) {
		printf ("Attempt to write non page aligned data\n");
		return -NAND_WRITE_FAILED;
	}

	if((offset + write_len) > phydev->size){
		aml_nand_dbg("Attemp to write out side the dev area");		
		return -NAND_WRITE_FAILED;
	}
	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = offset;
	devops->len = phydev->writesize;
	devops->datbuf = buffer;		
	devops->oobbuf = NULL;
	devops->mode = NAND_HW_ECC;
	aml_nand_dbg("phydev->writesize= %x",phydev->writesize);
	do{
		//aml_nand_dbg("devops->addr = %llx",devops->addr);
		if((devops->addr % phydev->erasesize) == 0 ){
			//aml_nand_dbg("devops->addr = %llx",devops->addr);
			ret =  phydev->block_isbad(phydev);
			if (ret > 0){
				printf("\rSkipping bad block at %llx\n", devops->addr);
				devops->addr += phydev->erasesize;
				continue;
			} else if (ret < 0) {
				printf("\n:AMLNAND get bad block failed: ret=%d at addr=%llx\n",ret, devops->addr);
				return -1;
			}
		}
		ret = phydev->write(phydev);
		if(ret < 0){
			aml_nand_dbg("nand write failed at %llx",devops->addr);
		}
		devops->addr +=  phydev->writesize;
		devops->datbuf	 += phydev->writesize;
	}while(devops->addr < (offset + write_len));

	return ret;
}

static int erase_env_protect(struct amlnand_chip *aml_chip, int blk)
{	
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = & aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para; 
	struct read_retry_info *retry_info = &(controller->retry_info);
	nand_arg_info   * nand_bbtinfo = &(aml_chip->nand_bbtinfo);	
	nand_arg_info  *shipped_bbtinfo = &aml_chip->shipped_bbtinfo;
	nand_arg_info  * config_msg = &aml_chip->config_msg;
	nand_arg_info	*	nand_key = &aml_chip->nand_key;
	nand_arg_info  *nand_secure = &aml_chip->nand_secure;

	unsigned char phys_erase_shift, phys_page_shift;	
	unsigned short start_blk, nand_boot;
	unsigned  offset, pages_per_blk;
	int ret = 0;

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

	start_blk = (int)(offset >> phys_erase_shift);
	
	blk  -= (controller->chip_num - 1) * start_blk;  //decrease the uboot block;
	
	if(!(info_disprotect & DISPROTECT_FBBT)){
		if(((blk == shipped_bbtinfo->valid_blk_addr) )&&(shipped_bbtinfo->valid_blk_addr >= start_blk)&&(!(info_disprotect & DISPROTECT_FBBT))){
			aml_nand_msg("protect fbbt at blk %d",blk);
			ret = -1;
		}else if(((blk == retry_info->info_save_blk)&&(retry_info->info_save_blk >= start_blk)&&(flash->new_type)&&(flash->new_type < 10))&&(!(info_disprotect & DISPROTECT_HYNIX))){
			aml_nand_msg("protect hynix retry info at blk %d",blk);
			ret = -1;
		}else if((blk == nand_key->valid_blk_addr)&&(nand_key->valid_blk_addr >= start_blk)&&(!(info_disprotect & DISPROTECT_KEY))){
			aml_nand_msg("protect nand_key info at blk %d",blk);
			ret = -1;
		}else if((blk == nand_secure->valid_blk_addr)&&(nand_secure->valid_blk_addr >= start_blk)&&(!(info_disprotect & DISPROTECT_SECURE))){
			aml_nand_msg("protect nand_secure info at blk %d",blk);
			ret = -1;
		}else{
			ret = 0;
		}
	}

	return ret;
}


int  amlnf_erase_ops(uint64_t off, uint64_t erase_len,unsigned char scrub_flag)
{
	struct amlnand_chip *aml_chip = aml_nand_chip;
	struct hw_controller *controller = &(aml_chip->controller);	
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct nand_flash *flash = &(aml_chip->flash);
	
	uint64_t  erase_addr,  erase_off;
	unsigned erase_shift, write_shift, writesize, erasesize, pages_per_blk;
	int  start_blk,total_blk, ret = 0;
	int percent=0;
	int percent_complete = -1;

	erase_shift = ffs(flash->blocksize) - 1;
	write_shift =  ffs(flash->pagesize) - 1;
	start_blk = (int)(off >> erase_shift);
	total_blk = (int)(erase_len >> erase_shift);
	pages_per_blk = (1 << (erase_shift -write_shift));

	if (!scrub_flag){
		if(boot_device_flag == 1){
			if(start_blk < ((1024 / pages_per_blk )))
					start_blk = ((1024 / pages_per_blk ));
		}
			/*#ifndef CONFIG_SPI_BOOT
			if(start_blk < ((1024 / pages_per_blk )))
				start_blk = ((1024 / pages_per_blk ));
			#endif */
	}
	aml_nand_dbg("start_blk =%d,total_blk=%d",start_blk, total_blk);

	for(;start_blk< total_blk; start_blk++){
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));			
		ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num)) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr );

		ret = erase_env_protect(aml_chip, start_blk);
		if(ret < 0){
			//aml_nand_msg("nand configs protected: key fbbt hynix_info");
			continue;
		}
		
		if(!scrub_flag){ 
			ret = operation->block_isbad(aml_chip);
			if(ret ){
				//aml_nand_dbg("nand blk %d is  bad block ", start_blk);
				//start_blk++;
				continue;
			}   //check bbt 
		}
		
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
			ret = operation->block_markbad(aml_chip);
			continue;
		}
			
		percent = (start_blk * 100) / total_blk;
		
		if ((percent != percent_complete)&&((percent %10)==0)) {
				percent_complete = percent;
				aml_nand_msg("nand erasing %d %% --%d %% complete",percent,percent+10);
		}
	}
	
	return 0;
}
int  amlnf_markbad_reserved_ops(uint32_t start_blk)
{
	struct amlnand_chip *aml_chip = aml_nand_chip;
	struct hw_controller *controller = &(aml_chip->controller);	
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct nand_flash *flash = &(aml_chip->flash);

	unsigned erase_shift, write_shift, pages_per_blk;
	int ret = 0;


	erase_shift = ffs(flash->blocksize) - 1;
	write_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (erase_shift -write_shift));

	memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));			
	ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num)) * pages_per_blk;
	ops_para->chipnr = start_blk % controller->chip_num;
	controller->select_chip(controller, ops_para->chipnr );
#ifdef AML_NAND_UBOOT
	nand_get_chip();
#else
	nand_get_chip(aml_chip);
#endif	
    aml_nand_msg("ops_para->page_addr=%d\n",ops_para->page_addr);
	ret = operation->block_markbad(aml_chip);	
#ifdef AML_NAND_UBOOT
	nand_release_chip();
#else
	nand_release_chip(aml_chip);
#endif				

	
	return 0;
}


