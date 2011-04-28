

#include "../include/phynand.h"

#ifndef AML_NAND_UBOOT
extern void amlnand_release_device(struct amlnand_phydev *phydev);
extern int amlnand_get_device(struct amlnand_phydev *phydev, chip_state_t new_state);
#endif

static int read_uboot(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
	struct nand_flash *flash = &(aml_chip->flash);
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller); 
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct en_slc_info *slc_info = &(controller->slc_info);
	
	unsigned configure_data, pages_per_blk, configure_data_w, pages_per_blk_w, page_size, tmp_size;
	unsigned char tmp_bch_mode, tmp_user_mode, tmp_ecc_limit, tmp_ecc_max;
	unsigned short tmp_ecc_unit, tmp_ecc_bytes, tmp_ecc_steps;
	uint64_t addr, readlen = 0, len = 0;
	int  ret = 0;

	if((devops->addr + devops->len) >  phydev->size){
		aml_nand_msg("out of space and addr:%llx len:%llx phydev->offset:%llx phydev->size:%llx",\
						devops->addr, devops->len, phydev->offset, phydev->size);
		return -NAND_ARGUMENT_FAILURE;
	}

	if((devops->len == 0) && (devops->ooblen == 0)){
		aml_nand_msg("len equal zero here");
		return NAND_SUCCESS;
	}

	tmp_ecc_unit = controller->ecc_unit;
	tmp_ecc_bytes = controller->ecc_bytes;
	tmp_bch_mode = controller->bch_mode;
	tmp_user_mode	= controller->user_mode;
	tmp_ecc_limit = controller->ecc_cnt_limit;
	tmp_ecc_max = controller->ecc_max;
	tmp_ecc_steps = controller->ecc_steps;


	if (controller->bch_mode == NAND_ECC_BCH_SHORT){
		page_size = (flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;
	}

	tmp_size = phydev->writesize;
	//phydev->writesize = page_size;

	amlnand_get_device(phydev, CHIP_READING);

	//clear ops_para here
	memset(ops_para, 0, sizeof(struct chip_ops_para));

	if(devops->len == 0){
		len = phydev->writesize;
		ops_para->ooblen = devops->ooblen;
	}
	else{
		len = devops->len;
		ops_para->ooblen = devops->ooblen;
	}
	
	addr = phydev->offset + devops->addr;
	ops_para->data_buf = devops->datbuf;	
	ops_para->option = phydev->option;	
	ops_para->oob_buf = devops->oobbuf;
	
	if(devops->mode == NAND_SOFT_ECC){
		ops_para->option |= DEV_ECC_SOFT_MODE;
	}
	
	if((flash->new_type) &&((flash->new_type < 10) || (flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;
	
	pages_per_blk = flash->blocksize / flash->pagesize; 
	configure_data = NFC_CMD_N2M(controller->ran_mode, controller->bch_mode, 0, (controller->ecc_unit >> 3), controller->ecc_steps);
	while(1){
		if (((addr / flash->pagesize )%BOOT_PAGES_PER_COPY) == 0){
				uboot_set_ran_mode(phydev);
				page_size = (flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;
				phydev->writesize = page_size;
#if 1
				controller->ecc_unit = NAND_ECC_UNIT_SHORT;
				controller->ecc_bytes = NAND_BCH60_1K_ECC_SIZE;
				controller->bch_mode = NAND_ECC_BCH_SHORT;
				controller->user_mode = 2;			
				controller->ecc_cnt_limit = 55;
				controller->ecc_max = 60;
				controller->ecc_steps = (flash->pagesize+flash->oobsize)/512;
#endif	
			
		}else{		
			controller->ran_mode = 1;
		}
		
		ops_para->page_addr = (int)(addr / flash->pagesize);// /controller->chip_num;	
		if((ops_para->option & DEV_SLC_MODE)) {
			if((flash->new_type > 0) && (flash->new_type <10))
				ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
			if (flash->new_type == SANDISK_19NM) 
				ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
		}

		ret = operation->read_page(aml_chip);
		if((ops_para->ecc_err) || (ret<0)){			
			aml_nand_msg("fail page_addr:%d", ops_para->page_addr); 		
			break;
		}
							
		//check info page
		if((!strncmp((char*)phydev->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))) 
				&& (((addr / flash->pagesize )%BOOT_PAGES_PER_COPY) == 0)){
				
			controller->ran_mode = 1;  // 1
			
			
			memcpy((unsigned char *)(&configure_data_w), ops_para->data_buf, sizeof(int));
			memcpy((unsigned char *)(&pages_per_blk_w), ops_para->data_buf+4, sizeof(int));
			
			aml_nand_msg("configure_data:%x, pages_per_blk:%x", configure_data, pages_per_blk);

			addr += flash->pagesize;	
#if 1
			controller->ecc_unit = tmp_ecc_unit;
			controller->ecc_bytes = tmp_ecc_bytes;
			controller->bch_mode =tmp_bch_mode;
			controller->user_mode =tmp_user_mode;
			controller->ecc_cnt_limit =tmp_ecc_limit;
			controller->ecc_max =tmp_ecc_max;		
			controller->ecc_steps = tmp_ecc_steps;
			phydev->writesize = tmp_size;
#endif
			continue;
		}
		
		addr += flash->pagesize;		
		ops_para->data_buf += phydev->writesize;
		readlen += phydev->writesize;
		
		if(readlen >= len){
			break;
		}
	}

	devops->retlen = readlen;
	
	amlnand_release_device(phydev);

	if(!ret){
		if(ops_para->ecc_err){
			ret = NAND_ECC_FAILURE;
		}
		/*else if(ops_para->bit_flip){
			ret = NAND_BITFLIP_FAILURE;
		}*/
	}
	
	controller->ran_mode = 1;		
	controller->ecc_unit = tmp_ecc_unit;
	controller->ecc_bytes = tmp_ecc_bytes;
	controller->bch_mode =tmp_bch_mode;
	controller->user_mode =tmp_user_mode;
	controller->ecc_cnt_limit =tmp_ecc_limit;
	controller->ecc_max =tmp_ecc_max;		
	controller->ecc_steps = tmp_ecc_steps;
	phydev->writesize = tmp_size;
		
	return ret;
}

int roomboot_nand_read(struct amlnand_phydev *phydev)
{	
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller); 
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);

	uint64_t offset , write_len;
	unsigned char * buffer;
	int ret = 0;
	int oob_set = 0;

	offset = devops->addr;
	write_len = devops->len;
	buffer = devops->datbuf;
	
	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = offset;
	devops->len = write_len;
	devops->datbuf = buffer;		
	devops->oobbuf = NULL;
	devops->mode = NAND_HW_ECC;
	if(controller->oob_mod) {
		oob_set = controller->oob_mod;
		NFC_CLR_OOB_MODE(3<<26);
		controller->oob_mod =0;
	}
	ret = read_uboot(phydev);
	if(ret < 0){
		aml_nand_dbg("nand read failed at %llx",devops->addr);
	}
	if(oob_set) {
		controller->oob_mod =oob_set;
		NFC_SET_OOB_MODE(3<<26);
	}
	return ret ;
}

static int write_uboot(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
	struct nand_flash *flash = &(aml_chip->flash);
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller); 
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct en_slc_info *slc_info = &(controller->slc_info);
	unsigned char *fill_buf=NULL;
	unsigned char *oob_buf=NULL, *page0_buf=NULL, tmp_bch_mode, tmp_user_mode, tmp_ecc_limit, tmp_ecc_max,tmp_rand;
	unsigned configure_data, pages_per_blk, oobsize, page_size, tmp_size,priv_lsb,ops_tem; 
	unsigned short tmp_ecc_unit, tmp_ecc_bytes, tmp_ecc_steps;
	uint64_t addr, writelen = 0, len = 0;
	int chip_num=1, nand_read_info, new_nand_type, i, ret = 0;
	//unsigned char  *tmp_buf;
	char write_boot_status[BOOT_COPY_NUM] = {0},err = 0;
	
	if((devops->addr + devops->len) >  phydev->size){
		aml_nand_msg("writeboot:out of space and addr:%llx len:%llx phydev->offset:%llx phydev->size:%llx",\
						devops->addr, devops->len, phydev->offset, phydev->size);
		return -NAND_ARGUMENT_FAILURE;
	}

	if((devops->len == 0) && (devops->ooblen == 0)){
		aml_nand_msg("len equal zero here");
		return NAND_SUCCESS;
	}

	if(devops->addr != 0){
		aml_nand_msg("addr do not equal zero here for uboot write");
		return NAND_SUCCESS;
	}

	tmp_ecc_unit = controller->ecc_unit;
	tmp_ecc_bytes = controller->ecc_bytes;
	tmp_bch_mode = controller->bch_mode;
	tmp_user_mode	= controller->user_mode;
	tmp_ecc_limit = controller->ecc_cnt_limit;
	tmp_ecc_max = controller->ecc_max;
	tmp_ecc_steps = controller->ecc_steps;
	tmp_rand = controller->ran_mode;
	if (controller->bch_mode == NAND_ECC_BCH_SHORT){
		page_size = (flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;
	}
	
	oobsize = controller->ecc_steps*controller->user_mode;

	tmp_size = phydev->writesize;
	//phydev->writesize = page_size;

	amlnand_get_device(phydev, CHIP_WRITING);

	oob_buf = aml_nand_malloc(oobsize);
	if(oob_buf == NULL){
		aml_nand_msg("malloc failed and oobavail:%d", phydev->oobavail);
		ret = -NAND_MALLOC_FAILURE;
		goto error_exit;
	}
	memset(oob_buf,0x0,oobsize);
	page0_buf = aml_nand_malloc(flash->pagesize);
	if(page0_buf == NULL){
		aml_nand_msg("malloc failed and oobavail:%d", flash->pagesize);
		ret = -NAND_MALLOC_FAILURE;
		goto error_exit;
	}
	memset(page0_buf,0x0,flash->pagesize);
	len = devops->len;
	for (i=0; i<oobsize; i+=2){
		oob_buf[i] = 0x55;
		oob_buf[i+1] = 0xaa;
	}
	
	fill_buf = aml_nand_malloc(flash->pagesize);
	if(fill_buf == NULL){
		aml_nand_msg("malloc failed and oobavail:%d", flash->pagesize);
		ret = -NAND_MALLOC_FAILURE;
		goto error_exit;
	}
	memset(fill_buf,0xff,flash->pagesize);
	//clear ops_para here
	memset(ops_para, 0, sizeof(struct chip_ops_para));
	addr = phydev->offset + devops->addr;
	ops_para->option = phydev->option;	
	ops_para->data_buf = devops->datbuf;	
	ops_para->oob_buf = oob_buf;
	
	if((flash->new_type) &&((flash->new_type < 10) || (flash->new_type == SANDISK_19NM))){
	ops_para->option |= DEV_SLC_MODE;
	}
	
	configure_data = NFC_CMD_N2M(controller->ran_mode, controller->bch_mode, 0, (controller->ecc_unit >> 3), controller->ecc_steps);	

	//configure_data = NFC_CMD_N2M(controller->ran_mode, NAND_ECC_BCH60_1K, 1, (controller->ecc_unit >> 3), controller->ecc_steps); 
	pages_per_blk = flash->blocksize / flash->pagesize;
	aml_nand_msg("configure_data:%x, pages_per_blk:%x", configure_data, pages_per_blk);

	nand_boot_info_prepare(phydev,page0_buf);
	unsigned char * lazy_buf = devops->datbuf;
	for(i=0; i<BOOT_COPY_NUM; i++){
		writelen = 0;
		addr = 0;
		addr += flash->pagesize*(BOOT_PAGES_PER_COPY*i);
		ops_para->data_buf = lazy_buf;	
		devops->datbuf = lazy_buf;
		while(1){
			if(((addr / flash->pagesize) % BOOT_PAGES_PER_COPY) == 0){
				uboot_set_ran_mode(phydev);
				ops_para->data_buf = page0_buf;
				
				page_size = (flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;
				phydev->writesize = page_size;
#if 1
				controller->ecc_unit = NAND_ECC_UNIT_SHORT;
				controller->ecc_bytes = NAND_BCH60_1K_ECC_SIZE;
				controller->bch_mode = NAND_ECC_BCH_SHORT;
				controller->user_mode = 2;			
				controller->ecc_cnt_limit = 55;
				controller->ecc_max = 60;
				controller->ecc_steps = (flash->pagesize+flash->oobsize)/512;
#endif 	
			}
			ops_para->page_addr = (int)(addr / flash->pagesize);// /controller->chip_num;	
			ops_tem = ops_para->page_addr ;
			if((ops_para->option & DEV_SLC_MODE)) {
				if((flash->new_type > 0) && (flash->new_type < 10))
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |(slc_info->pagelist[ops_para->page_addr % 256]);
				if (flash->new_type == SANDISK_19NM) 
					ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
			}
#if 1
			if(flash->new_type ==HYNIX_1YNM_8GB) {
				if((ops_tem % 256)>1) {
					priv_lsb =  (ops_tem & (~(pages_per_blk -1))) |(slc_info->pagelist[(ops_tem % 256)-1]);
				ops_tem = ops_para->page_addr ;
				while(ops_tem > (priv_lsb+1)) {
				ops_para->data_buf = fill_buf;				
				controller->bch_mode =NAND_ECC_NONE;
				ops_para->page_addr = priv_lsb+1;
				 operation->write_page(aml_chip);
				 priv_lsb++;
					}
				ops_para->page_addr = ops_tem;
				ops_para->data_buf = devops->datbuf;
				controller->ecc_unit = tmp_ecc_unit;
				controller->ecc_bytes = tmp_ecc_bytes;
				controller->bch_mode =tmp_bch_mode;
				controller->user_mode =tmp_user_mode;
				controller->ecc_cnt_limit =tmp_ecc_limit;
				controller->ecc_max =tmp_ecc_max;	
				controller->ecc_steps = tmp_ecc_steps;
				phydev->writesize = tmp_size;
				controller->ran_mode = tmp_rand;
				}	
			}
	#endif
			if(((addr / flash->pagesize) % BOOT_PAGES_PER_COPY) != 0)
					ops_para->data_buf = devops->datbuf;
			ret = operation->write_page(aml_chip);			
			if(ret<0){			
				write_boot_status[i] = 1;
				aml_nand_msg("fail page_addr:%d", ops_para->page_addr); 		
				break;
			}
						
			if(((addr / flash->pagesize) % BOOT_PAGES_PER_COPY) == 0){
				controller->ran_mode = 1;
				addr += flash->pagesize;
				ops_para->data_buf = devops->datbuf;				
#if 1
				controller->ecc_unit = tmp_ecc_unit;
				controller->ecc_bytes = tmp_ecc_bytes;
				controller->bch_mode =tmp_bch_mode;
				controller->user_mode =tmp_user_mode;
				controller->ecc_cnt_limit =tmp_ecc_limit;
				controller->ecc_max =tmp_ecc_max;	
				controller->ecc_steps = tmp_ecc_steps;
				phydev->writesize = tmp_size;
#endif
				continue;
			}	
			
			addr += flash->pagesize;
			devops->datbuf += phydev->writesize;
			writelen += phydev->writesize;
			
			if((writelen >= devops->len)&&(writelen < phydev->erasesize)){
				devops->datbuf = fill_buf;
			}
			
			if ((writelen >= (len-flash->pagesize)) \
			    ||((ops_para->option & DEV_SLC_MODE) && ((unsigned)addr%(flash->blocksize>>1) ==0)) \
			    || (((ops_para->option & DEV_SLC_MODE) == 0) && ((unsigned)addr%flash->blocksize ==0))){
			        break;
			}
		}
	}
	for(i=0; i<BOOT_COPY_NUM; i++) {
	
		err +=write_boot_status[i];
	}	
	if(err < 2)
		ret = 0;
	else
		ret =1;		
	devops->retlen = writelen;
	
error_exit: 
	amlnand_release_device(phydev);
	
	controller->ran_mode = 1;
	controller->ecc_unit = tmp_ecc_unit;
	controller->ecc_bytes = tmp_ecc_bytes;
	controller->bch_mode =tmp_bch_mode;
	controller->user_mode =tmp_user_mode;
	controller->ecc_cnt_limit =tmp_ecc_limit;
	controller->ecc_max =tmp_ecc_max;	
	controller->ecc_steps = tmp_ecc_steps;
	phydev->writesize = tmp_size;
	
	if(page0_buf){
		kfree(page0_buf);
		page0_buf =NULL;
	}
	if(fill_buf){
		kfree(fill_buf);
		fill_buf =NULL;
	}
	if(oob_buf){
		kfree(oob_buf);
		oob_buf =NULL;
	}
	
	return ret;
}

int roomboot_nand_write(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
	struct nand_flash * flash = &aml_chip->flash;
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller); 
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);

	uint64_t offset , write_len, addr;
	unsigned char * buffer;
	int pages_per_blk = 0, ret = 0;
	int oob_set = 0;
	offset = devops->addr;
	write_len = devops->len;
	buffer = devops->datbuf;

	if (offset != 0){
		aml_nand_msg("Wrong addr begin");
		return -1;
	}
	/*if(write_len < 0x60000){
		aml_nand_msg("Wrong size begin");
		write_len = 0x60000;
	}
	write_len = (((write_len +phydev->writesize)-1)/phydev->writesize)*phydev->writesize;
	*/
	if(write_len < phydev->erasesize){
		write_len = phydev->erasesize;
	}
	if((flash->new_type) &&((flash->new_type < 10) || (flash->new_type == SANDISK_19NM))){
		write_len =  phydev->erasesize >> 1;
	}
	write_len = ((((unsigned)write_len +phydev->writesize)-1)/phydev->writesize)*phydev->writesize;

	if ((offset & (phydev->writesize - 1)) != 0 ||(write_len & (phydev->writesize - 1)) != 0) {
		printf ("Attempt to write non page aligned data\n");
		return -NAND_WRITE_FAILED;
	}

	if((offset + write_len) > (phydev->size /BOOT_COPY_NUM)){
		aml_nand_dbg("Attemp to write out side the dev area");		
		return -NAND_WRITE_FAILED;
	}
	if(controller->oob_mod) {

		oob_set = controller->oob_mod;
		NFC_CLR_OOB_MODE(3<<26);
		controller->oob_mod =0;
	}
	pages_per_blk = flash->blocksize / flash->pagesize;
	memset(ops_para, 0, sizeof(struct chip_ops_para));
	addr = phydev->offset + devops->addr;
	ops_para->chipnr = 0;
	ops_para->option = phydev->option;		
	if((flash->new_type) &&(flash->new_type == SANDISK_19NM))
	ops_para->option |= DEV_SLC_MODE;
	
	do{
			ops_para->page_addr = (unsigned)(addr / flash->pagesize);
			controller->select_chip(controller, ops_para->chipnr);		
			ret = operation->block_isbad(aml_chip);
			if(ret ==  NAND_BLOCK_FACTORY_BAD){
				aml_nand_msg("nand blk is shipped bad block at page %d", ops_para->page_addr);
				addr += phydev->erasesize;
				continue;
			}
			
			if((flash->new_type == SANDISK_19NM) &&(ops_para->option & DEV_SLC_MODE)){
				ops_para->page_addr = (ops_para->page_addr & (~(pages_per_blk -1))) |((ops_para->page_addr % pages_per_blk) << 1);
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

			if(ret<0){
				aml_nand_msg("nand erase fail at addr :%lx ", ops_para->page_addr);
				//break;
			}
			
			addr += phydev->erasesize;
		}while(addr < (1024 * flash->pagesize));

	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = offset;
	devops->len = write_len;
	devops->datbuf = buffer;		
	devops->oobbuf = NULL;
	devops->mode = NAND_HW_ECC;

	aml_nand_dbg("devops->addr =%llx",devops->addr);
	aml_nand_dbg("devops->len =%llx",devops->len);
	ret = write_uboot(phydev);
	if(ret < 0){
		aml_nand_dbg("nand write failed at %llx",devops->addr);
		goto exit_error0;
	}
	if(oob_set) {
		controller->oob_mod =oob_set;
		NFC_SET_OOB_MODE(3<<26);
	}
	return ret;
	
exit_error0:
	return ret;
}

#ifndef AML_NAND_UBOOT
struct device *devp;
static dev_t uboot_devno;
struct amlnand_phydev *uboot_phydev  = NULL;
#define UBOOT_WRITE_SIZE  0x60000 

static int uboot_open(struct inode * inode, struct file * filp)
{
	aml_nand_dbg("uboot_open");
	return 0;
}
/*
 * This funcion reads the u-boot envionment variables. 
 * The f_pos points directly to the env location.
 */
static ssize_t uboot_read(struct file *file, char __user *buf,
			size_t count, loff_t *ppos)
{		
		return 0;
}

static ssize_t uboot_write(struct file *file, const char __user *buf,
			 size_t count, loff_t *ppos)
{
	struct amlnand_phydev * phydev = uboot_phydev;
	struct amlnand_chip *aml_chip = phydev->priv;	
	struct nand_flash *flash = &(aml_chip->flash);
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller); 
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);

	unsigned char *data_buf;
	int  ret;
	size_t align_count = 0;
	//data_buf = aml_nand_malloc(UBOOT_WRITE_SIZE);
	align_count = ((((unsigned)count +phydev->writesize)-1)/phydev->writesize)*phydev->writesize;
	data_buf = aml_nand_malloc(align_count);
	if(!data_buf){
		aml_nand_dbg("malloc buf for rom_write failed");
		goto err_exit0;
	}	
	//memset(data_buf,0x0,UBOOT_WRITE_SIZE);
	//ret=copy_from_user(data_buf, buf, UBOOT_WRITE_SIZE);
	memset(data_buf,0x0,align_count);
	ret=copy_from_user(data_buf, buf, count);
	
	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = 0x0;
	devops->len = align_count;
	devops->mode = NAND_HW_ECC;
	devops->datbuf = data_buf;

	ret = roomboot_nand_write(phydev);
	if (ret < 0){
		aml_nand_dbg("uboot_write failed");
		count = 0;
	}
	
err_exit0:
	
	if (data_buf) {
		aml_nand_free(data_buf);
		data_buf = NULL;
	}
	
	return count;
}

static int uboot_close(struct inode *inode, struct file *file)
{
	return 0;
}
static int uboot_suspend(struct device *dev, pm_message_t state)
{
		return 0;
}

static int uboot_resume(struct device *dev)
{
	return 0;
}

static struct class uboot_class = {
    
	.name = "bootloader",
	.owner = THIS_MODULE,
	.suspend = uboot_suspend,
	.resume = uboot_resume,
};

static struct file_operations uboot_fops = {
    .owner	= THIS_MODULE,
    .open	= uboot_open,
    .read	= uboot_read,
    .write	= uboot_write,
    .release	= uboot_close,
};

int boot_device_register(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = phydev->priv;	
	struct nand_flash *flash = &(aml_chip->flash);
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller); 
	struct chip_operation *operation = &(aml_chip->operation);	
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);

	int ret = 0;
	
	if(!strncmp((char*)phydev->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME))){

			aml_nand_dbg("boot device register");

			uboot_phydev = phydev;
			ret = alloc_chrdev_region(&uboot_devno, 0, 1, "bootloader");
			if (ret < 0) {
				aml_nand_dbg("uboot_phydev: failed to allocate chrdev. ");
				goto exit_error0;
			}
			cdev_init(&uboot_phydev->uboot_cdev, &uboot_fops);
			uboot_phydev->uboot_cdev.owner = THIS_MODULE;
			ret = cdev_add(&uboot_phydev->uboot_cdev, uboot_devno, 1);
			if (ret) {
				aml_nand_dbg("uboot_phydev: failed to add device.");
				goto exit_error0;
			}
			
			ret = class_register(&uboot_class);
			if (ret < 0) {
				aml_nand_dbg( "class_register(&uboot_class) failed!\n");		
				goto exit_error0;
			}
			
			devp = device_create(&uboot_class, NULL, uboot_devno, NULL, "bootloader");
			if (IS_ERR(devp)) {
				aml_nand_dbg( "uboot_phydev: failed to create device node\n");
				ret = PTR_ERR(devp);	
				goto exit_error0;
			}
		}

		return NAND_SUCCESS;
	
exit_error0:
	return ret;
}
#endif

