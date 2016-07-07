

#include "../include/phynand.h"

extern  int block_markbad(struct amlnand_chip *aml_chip);
extern int amlnand_save_info_by_name(struct amlnand_chip *aml_chip,unsigned char * info,unsigned char * buf,unsigned char * name,unsigned size);
extern int aml_sys_info_error_handle(struct amlnand_chip *aml_chip);
extern int aml_sys_info_init(struct amlnand_chip *aml_chip);
extern int aml_nand_update_ubootenv(struct amlnand_chip * aml_chip, char *env_ptr);
extern int amlnand_get_partition_table(struct amlnand_chip *aml_chip);
extern void amlnf_get_chip_size(u64 *size);
extern int  amlnf_erase_ops(uint64_t off,
	uint64_t erase_len, unsigned char scrub_flag);
/* fixme, */
extern int info_disprotect;

#ifndef MAX
#define MAX(x, y) ((x) > (y) ? (x) : (y))
#endif /* MAX */

#ifdef AML_NAND_UBOOT
//extern struct amlnf_partition amlnand_config;
extern struct amlnf_partition * amlnand_config;
int get_last_reserve_block(struct amlnand_chip *aml_chip);
int repair_reserved_bad_block(struct amlnand_chip *aml_chip);
void show_data_buf(unsigned char *  buf);
void amlnand_config_buf_free(struct amlnand_chip *aml_chip);

int chipenv_init_erase_protect(struct amlnand_chip *aml_chip, int flag,int block_num)
{
	int ret = 0,start_blk = 0;
	struct nand_flash *flash = &aml_chip->flash;
	struct hw_controller *controller = &aml_chip->controller;
	struct read_retry_info *retry_info = &(controller->retry_info);

	int phys_erase_shift = ffs(flash->blocksize) - 1;
	start_blk =  (1024 * flash->pagesize) >> phys_erase_shift;
	block_num  -= (controller->chip_num - 1) * start_blk;

	if ((flag > NAND_BOOT_UPGRATE) && (flag <= NAND_BOOT_SCRUB_ALL)) {

		/*liang:make sure fbbt and bbt are ok, don't erase forever!!!*/
		if ((block_num == aml_chip->shipped_bbtinfo.valid_blk_addr) && (aml_chip->shipped_bbtinfo.valid_blk_addr >= start_blk)) {
			aml_nand_msg("protect fbbt at blk %d",block_num);
			ret = -1;
		}else if((block_num == aml_chip->nand_bbtinfo.valid_blk_addr)&&(aml_chip->nand_bbtinfo.valid_blk_addr >= start_blk)){
			aml_nand_msg("protect nand_bbt info at blk %d",block_num);
			ret = -1;
		}else if(((block_num == retry_info->info_save_blk)&&(retry_info->info_save_blk >= start_blk)&&(flash->new_type)&&(flash->new_type < 10))&&(!(info_disprotect & DISPROTECT_HYNIX))){
			aml_nand_msg("protect hynix retry info at blk %d", block_num);
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

#if (AML_CFG_DTB_RSV_EN)
extern int dtb_erase_blk;
extern struct amlnand_chip *aml_chip_dtb;
int bad_block_is_dtb_blk(const int blk_addr)
{
	/*laod dtb form ram*/
	if (dtb_erase_blk == blk_addr && dtb_erase_blk != -1) {
		return 1;
	}
	/*laod dtb form flash*/
	if (aml_chip_dtb != NULL) {
		if (aml_chip_dtb->amlnf_dtb.arg_valid == 1 &&\
			aml_chip_dtb->amlnf_dtb.valid_blk_addr == blk_addr) {
			return 1;
		}
	}
	return 0;
}
#endif

/***
*erase whole nand as scrub
* start_blk = 0; total_blk;
***/
/*
	todo need to add bbt here !!!!!!
*/
static int amlnand_oops_handle(struct amlnand_chip *aml_chip, int flag)
{
	struct hw_controller *controller = &(aml_chip->controller);
	struct chip_operation *operation = &(aml_chip->operation);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct nand_flash *flash = &(aml_chip->flash);

	uint64_t  erase_len;
	unsigned erase_shift, write_shift, pages_per_blk;
	int  start_blk,total_blk, ret = 0;
	int percent=0, percent_complete = -1;
	unsigned char *buf = NULL;
	unsigned int buf_size;
	int last_reserve_blk;

	buf_size = 0x40000; /*rsv item max size is 256KB*/
	buf = aml_nand_malloc(buf_size);
	if (!buf) {
	  aml_nand_msg("%s() %d: malloc failed", __FUNCTION__, __LINE__);
	}
	memset(buf, 0x0, buf_size);

	/* fixme, should not exit here, 20150801 */
	ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->nand_key),buf,(unsigned char *)KEY_INFO_HEAD_MAGIC, aml_chip->keysize);
	if (ret < 0) {
		aml_nand_msg("%s() %d invalid nand key\n", __FUNCTION__, __LINE__);
		goto exit_error0;
	}

#ifdef CONFIG_SECURE_NAND
	ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->nand_secure),buf,(unsigned char *)SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
	if (ret < 0) {
		aml_nand_msg("invalid nand secure_ptr\n");
		goto exit_error0;
	}
#endif

	erase_shift = ffs(flash->blocksize) - 1;
	write_shift =  ffs(flash->pagesize) - 1;
	erase_len = ((uint64_t)(flash->chipsize*controller->chip_num))<<20;

	start_blk = 0;
	total_blk = (int)(erase_len >> erase_shift);
	pages_per_blk = (1 << (erase_shift -write_shift));

	aml_nand_msg("start_blk =%d,total_blk=%d",start_blk, total_blk);

	if (flag == NAND_BOOT_ERASE_PROTECT_CACHE) {
		start_blk = (1024 * flash->pagesize) >> erase_shift;
		total_blk = get_last_reserve_block(aml_chip);
		aml_nand_msg("start_blk =%d,total_blk=%d",start_blk, total_blk);
	}
	last_reserve_blk = get_last_reserve_block(aml_chip);
	for (;start_blk< total_blk; start_blk++) {
		memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
		ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num)) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		ret = operation->block_isbad(aml_chip);
		if (ret ) {
			aml_nand_msg("bad block skipping!!!!0x%x",start_blk);
			//fixme, check is dtb, if dtb ,erase it!
			if (start_blk < last_reserve_blk && bad_block_is_dtb_blk(start_blk)) {
				aml_nand_msg("bad block dtb is dtb block:0x%x,not skipping",start_blk);
			}
			else {
				continue;
			}
		}	//check bbt


		ret = chipenv_init_erase_protect(aml_chip,flag,start_blk);
		if (ret) {
			aml_nand_msg("chipenv block skipping!!!!!!!0x%x", start_blk);
			continue;
		}

		nand_get_chip(aml_chip);
		ret = operation->erase_block(aml_chip);
		nand_release_chip(aml_chip);
		/*need to mark bad block*/
		if (ret) {
			aml_nand_msg("erase fail, marking badblock!!!!!!!0x%x", start_blk);
			ret = operation->block_markbad(aml_chip);
			if (ret < 0) {
				/*
				todo need to add bbt here !!!!!!
				*/
			}
			//continue;
		}else{

			if (aml_chip->init_flag > 3) {
#ifdef	SORTING_BAD_BLOCK_D
				if (flash->new_type == HYNIX_1YNM) {
					memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
					ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num)) * pages_per_blk;
					ops_para->chipnr = start_blk % controller->chip_num;
					if (start_blk > 4) {
						nand_get_chip(aml_chip);
						//aml_nand_msg("test block starting!!!!!!!0x%x", ops_para->page_addr);
						ret = operation->test_block(aml_chip);
						nand_release_chip(aml_chip);
						if (ret < 0) {
							memset((unsigned char *)ops_para, 0x0, sizeof(struct chip_ops_para));
							ops_para->page_addr =(((start_blk - start_blk % controller->chip_num) /controller->chip_num)) * pages_per_blk;
							ops_para->chipnr = start_blk % controller->chip_num;
							aml_nand_msg("test block fail, marking badblock!!!!!!!0x%x", start_blk);
							ret = operation->block_markbad(aml_chip);
						}
					}
				}
#endif
			}
		}
		percent = (start_blk * 100) / total_blk;

		if ((percent != percent_complete) && ((percent %10) == 0)) {
				percent_complete = percent;
				aml_nand_msg("nand erasing %d %% --%d %% complete",percent,percent+10);
		}
	}
exit_error0:
	if (buf) {
		kfree(buf);
		buf = NULL;
	}
	return ret;
}

int  phrase_driver_version(unsigned int cp, unsigned int cmp)
{
	int ret=0;

	if (((cp >> 24)&0xff) != ((cp >> 24)&0xff)) {
		ret = -1;
	}
	if (((cp >> 16)&0xff)!= ((cp >> 16)&0xff)) {
		ret = -1;
	}
	return ret;
}


void reset_amlchip_member(struct amlnand_chip *aml_chip)
{
	memset(aml_chip->reserved_blk, 0xff, RESERVED_BLOCK_CNT);
	memset(&aml_chip->nand_bbtinfo,0x0,sizeof(struct nand_arg_info));
	memset(&aml_chip->shipped_bbtinfo,0x0,sizeof(struct nand_arg_info));
	memset(&aml_chip->nand_key,0x0,sizeof(struct nand_arg_info));
	memset(&aml_chip->nand_secure,0x0,sizeof(struct nand_arg_info));
	memset(&aml_chip->config_msg,0x0,sizeof(struct nand_arg_info));
}
#endif /* AML_NAND_UBOOT */

u32 aml_info_checksum(u8 *data, int lenth)
{
	u32 checksum;
	u8 *pdata;
	int i;

	checksum = 0;
	pdata = (u8 *)data;

	for (i = 0; i < lenth; i++)
		checksum += pdata[i];

	return checksum;
}

static int aml_info_check_datasum(void *data, u8 *name)
{
	int ret = 0;
	u32 crc = 0;
	struct block_status *blk_status = NULL;
	struct shipped_bbt *bbt = NULL;
	struct nand_config *config = NULL;
	struct phy_partition_info *phy_part = NULL;

	if (!memcmp(name, BBT_HEAD_MAGIC, 4)) {
		blk_status = (struct block_status *)data;
		crc = blk_status->crc;
		if (aml_info_checksum((u8 *)(blk_status->blk_status),
			(MAX_CHIP_NUM*MAX_BLK_NUM)) != crc) {
			aml_nand_msg("%s :nand bbt bad crc error", __func__);
			ret = -NAND_READ_FAILED;
		}
	}

	if (!memcmp(name, SHIPPED_BBT_HEAD_MAGIC, 4)) {
		bbt = (struct shipped_bbt *)data;
		crc = bbt->crc;
		if (aml_info_checksum((u8 *)(bbt->shipped_bbt),
			(MAX_CHIP_NUM*MAX_BAD_BLK_NUM)) != crc) {
			aml_nand_msg("%s : nand shipped bbt  bad crc error",
				__func__);
			ret = -NAND_READ_FAILED;
		}
	}

	if (!memcmp(name, CONFIG_HEAD_MAGIC, 4)) {
		config = (struct nand_config *)data;
		crc = config->crc;
		if (aml_info_checksum((u8 *)(config->dev_para),
			(MAX_DEVICE_NUM*sizeof(struct dev_para))) != crc) {
			aml_nand_msg("%s : nand check config crc error",
				__func__);
			ret = -NAND_READ_FAILED;
		}
	}

	if (!memcmp(name, PHY_PARTITION_HEAD_MAGIC, 4)) {
		phy_part = (struct phy_partition_info *)data;
		crc = phy_part->crc;
		if (aml_info_checksum((u8 *)(phy_part->partition),
		(MAX_DEVICE_NUM*sizeof(struct _phy_partition))) != crc) {
			aml_nand_msg("%s : nand check phy partition crc error",
			__func__);
			ret = -NAND_READ_FAILED;
		}
	}
	/* others do not checksum at all. */
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

	u8 phys_erase_shift, phys_page_shift, nand_boot;
	u32 offset, pages_per_blk, pages_read;
	u8  oob_buf[8];
	u16  tmp_blk;
	int  ret = 0, t = 0;
	u32 tmp_value;

	u8 *dat_buf = NULL;

	dat_buf  = aml_nand_malloc(flash->pagesize);
	if (!dat_buf) {
		aml_nand_msg("amlnand_free_block_test : malloc failed");
		block_invalid = 1;
		ret =  -1;
		goto exit;
	}
	memset(dat_buf, 0xa5, flash->pagesize);

	nand_boot = 1;

	/*
	if (boot_device_flag == 0)
		nand_boot = 0;
	*/

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

#ifdef AML_NAND_UBOOT
	nand_get_chip(aml_chip);
#else
	if (aml_chip->state == CHIP_READY)
		nand_get_chip(aml_chip);
#endif

	/* erase */
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	tmp_value = start_blk - start_blk % controller->chip_num;
	tmp_value /= controller->chip_num;
	tmp_value += tmp_blk - tmp_blk/controller->chip_num;
	ops_para->page_addr =  tmp_value * pages_per_blk;
	ops_para->chipnr = start_blk % controller->chip_num;
	controller->select_chip(controller, ops_para->chipnr);
	ret = operation->erase_block(aml_chip);
	if (ret < 0) {
		aml_nand_msg("nand blk %d check good but erase failed",
			start_blk);
		block_invalid = 1;
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
		tmp_value = start_blk - start_blk % controller->chip_num;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = (t + tmp_value * pages_per_blk);
		ops_para->chipnr = start_blk % controller->chip_num;
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


		memset( aml_chip->user_page_buf, 0xa5, flash->pagesize);
		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		ret = operation->write_page(aml_chip);
		if (ret < 0) {
			aml_nand_msg("%s() %d: nand write failed", __func__, __LINE__);
			block_invalid = 1;
			ret =  -1;
			goto exit;
		}
	}
	/* read */
	for (t = 0; t < pages_read; t++) {
		memset((u8 *)ops_para,
			0x0,
			sizeof(struct chip_ops_para));
		if ((flash->new_type) && ((flash->new_type < 10)
			|| (flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE;
		tmp_value = start_blk - start_blk % controller->chip_num;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = (t + tmp_value * pages_per_blk);
		ops_para->chipnr = start_blk % controller->chip_num;
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

		ret = operation->read_page(aml_chip);
		if (ret < 0) {
			aml_nand_msg("nand write failed, %d", block_invalid);
			block_invalid = 1;

			ret =  -1;
			goto exit;
		}
		aml_nand_dbg("start_blk %d aml_chip->user_page_buf: ",
			start_blk);
		/* show_data_buf(aml_chip->user_page_buf); */
		aml_nand_dbg("start_blk %d dat_buf: ", start_blk);
		/* show_data_buf(dat_buf); */
		if (memcmp(aml_chip->user_page_buf,
			dat_buf,
			flash->pagesize)) {
			block_invalid = 1;
			ret =  -1;
			aml_nand_msg("free blk  %d,  page %d : test failed",
				start_blk,
				t);
			goto exit;
		}
	}

exit:

#ifdef AML_NAND_UBOOT
	nand_release_chip(aml_chip);
#else
	if (aml_chip->state == CHIP_READY)
		nand_release_chip(aml_chip);
#endif

	if (dat_buf) {
		aml_nand_free(dat_buf);
		dat_buf = NULL;
	}

	if (!ret)
		aml_nand_msg("free blk start_blk %d test OK", start_blk);

	return ret;
}

int get_last_reserve_block(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct nand_flash *flash = &aml_chip->flash;

	u32 offset, start_blk, blk_addr, tmp_blk, pages_per_blk;
	u8 phys_erase_shift, phys_page_shift;
	int  ret = 0;
	u32 tmp_value;
	static u32 total_blk = 0, scan_flag = 0;
	if ((total_blk > RESERVED_BLOCK_CNT) && (scan_flag == 1)) {
		aml_nand_dbg("total_blk:%d",total_blk);
		return total_blk;
	}
	if (aml_chip->nand_bbtinfo.arg_valid) {
		scan_flag = 1;
	}
	offset = (1024 * flash->pagesize);

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));

	start_blk = (offset >> phys_erase_shift);
	tmp_blk = total_blk = start_blk;

	blk_addr = 0;
	/* decide the total block_addr */
	while (blk_addr < RESERVED_BLOCK_CNT) {
		memset((u8 *)ops_para,
			0x0,
			sizeof(struct chip_ops_para));
		tmp_value = total_blk - total_blk % controller->chip_num;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = tmp_value * pages_per_blk;
		ops_para->chipnr = total_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		ret = operation->block_isbad(aml_chip);
		if (ret ==  NAND_BLOCK_FACTORY_BAD) {
			aml_nand_dbg("blk %d is shipped bad block ",
				total_blk);
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
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct nand_flash *flash = &aml_chip->flash;
	u32 offset, start_blk, total_blk, blk_addr, tmp_blk;
	u32 pages_per_blk, blk_used_bad_cnt = 0;
	u8 phys_erase_shift, phys_page_shift;
	int  ret = 0, i = 0, j = 0;
	u32 bad_blk[128];
	u8 *dat_buf = NULL;
	u8 *oob_buf = NULL;
	u32 tmp_value;

	memset(bad_blk, 0, 128*sizeof(u32));
	offset = (1024 * flash->pagesize);

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));

	start_blk = (offset >> phys_erase_shift);
	tmp_blk = total_blk = start_blk;

	dat_buf  = aml_nand_malloc(flash->pagesize);
	if (!dat_buf) {
		aml_nand_msg("amlnand_free_block_test : malloc failed");
		ret = -1;
		return ret;
	}

	memset(dat_buf, 0, flash->pagesize);
	oob_buf  = aml_nand_malloc(flash->oobsize);
	if (!oob_buf) {
		aml_nand_msg("amlnand_free_block_test : malloc failed");
		ret = -1;
		kfree(dat_buf);

		return ret;
	}
	memset(oob_buf, 0, flash->oobsize);

	blk_addr = 0;
	/* decide the total block_addr */
	while (blk_addr < RESERVED_BLOCK_CNT) {
		memset((u8 *)ops_para,
			0x0,
			sizeof(struct chip_ops_para));
		tmp_value = total_blk - total_blk % controller->chip_num;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = tmp_value * pages_per_blk;
		ops_para->chipnr = total_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		ret = operation->block_isbad(aml_chip);
		if (ret ==  NAND_BLOCK_FACTORY_BAD) {
			aml_nand_msg("blk %d is shipped bad block ",
				total_blk);
			total_blk++;
			continue;
		}
		if (ret == NAND_BLOCK_USED_BAD) {
			if (blk_used_bad_cnt < 128) {
				bad_blk[blk_used_bad_cnt] = total_blk;
				blk_used_bad_cnt++;
			}
		}
		total_blk++;
		blk_addr++;
	}

	if (blk_used_bad_cnt > 6) {
		nand_get_chip(aml_chip);
		aml_nand_msg("repair badblk of reserved,blk_used_bad_cnt=%d\n",
			blk_used_bad_cnt);
		for (i = 0; i < blk_used_bad_cnt; i++) {
			memset((u8 *)ops_para,
				0x0,
				sizeof(struct chip_ops_para));
			tmp_value = bad_blk[i]-bad_blk[i]%controller->chip_num;
			tmp_value /= controller->chip_num;
			tmp_value += tmp_blk - tmp_blk/controller->chip_num;
			ops_para->page_addr = tmp_value * pages_per_blk;
			ops_para->chipnr = bad_blk[i] % controller->chip_num;
			controller->select_chip(controller, ops_para->chipnr);
			ret = operation->blk_modify_bbt_chip_op(aml_chip, 0);
			/* erase */
			ret = operation->erase_block(aml_chip);
			if (ret) {
				ret = operation->blk_modify_bbt_chip_op(
					aml_chip,
					1);
				aml_nand_msg("test blk %d fail\n", bad_blk[i]);
				continue;
			}
			/* write */
			ops_para->page_addr = tmp_value * pages_per_blk;
			ops_para->data_buf = dat_buf;
			ops_para->oob_buf = oob_buf;
			for (j = 0; j < pages_per_blk; j++) {
				ops_para->page_addr += 1;
				memset(dat_buf, 0, flash->pagesize);
				memset(oob_buf, 0, flash->oobsize);
				ret = operation->write_page(aml_chip);
				if (ret) {
					ops_para->page_addr =
						tmp_value * pages_per_blk;
					ret =
					operation->blk_modify_bbt_chip_op(
						aml_chip, 1);
					aml_nand_msg("test blk %d fail\n",
						bad_blk[i]);
					goto write_read_fail;
				}
			}
			/* read */
			ops_para->page_addr = tmp_value * pages_per_blk;
			ops_para->data_buf = dat_buf;
			ops_para->oob_buf = oob_buf;
			for (j = 0; j < pages_per_blk; j++) {
				ops_para->page_addr += 1;
				memset(dat_buf, 0, flash->pagesize);
				memset(oob_buf, 0, flash->oobsize);
				ret = operation->read_page(aml_chip);
				if ((ops_para->ecc_err) || (ret < 0)) {
					ops_para->page_addr =
						tmp_value * pages_per_blk;
					ret =
					operation->blk_modify_bbt_chip_op(
						aml_chip, 1);
					aml_nand_msg("test blk %d fail\n",
						bad_blk[i]);
					goto write_read_fail;
				}
			}
			/* erase */
			ops_para->page_addr = tmp_value * pages_per_blk;
			ret = operation->erase_block(aml_chip);
			if (ret) {
				ret = operation->blk_modify_bbt_chip_op(
					aml_chip, 1);
				aml_nand_msg("test blk %d fail\n", bad_blk[i]);
				continue;
			}
			aml_nand_msg("test blk %d OK\n", bad_blk[i]);
write_read_fail:
			;
		}
		nand_release_chip(aml_chip);
		amlnand_update_bbt(aml_chip);
	}
	kfree(dat_buf);

	kfree(oob_buf);

	return total_blk;
}
/*****************************************************************************
*Name         :amlnand_get_free_block
*Description :search a good block by skip the shipped bad block
*Parameter  :
*Return       :
*Note          :
*****************************************************************************/
int amlnand_get_free_block(struct amlnand_chip *aml_chip, u32 block)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct nand_flash *flash = &aml_chip->flash;

	u32 offset, nand_boot, start_blk, total_blk;
	u32 blk_addr, tmp_blk, pages_per_blk;
	u8 phys_erase_shift, phys_page_shift;
	u8  blk_used_flag = 0;
	int  ret = 0, i;
	u32 tmp_value;

	nand_boot = 1;

	/*if(boot_device_flag == 0) {
		nand_boot = 0;
	}*/
	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else
		offset = 0;

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));

	start_blk = (offset >> phys_erase_shift);
	tmp_blk = total_blk = start_blk;

	total_blk = get_last_reserve_block(aml_chip);
	blk_addr = 0;

	while ((blk_addr < 1) && (start_blk < total_blk)) {
		for (i = 0; i < RESERVED_BLOCK_CNT;  i++) {
			if (aml_chip->reserved_blk[i] == start_blk) {
				/*
				aml_nand_msg("nand blk %d is used", start_blk);
				*/
				blk_used_flag = 1;
				break;
			} else
				blk_used_flag = 0;
		}

		if (blk_used_flag) {
			start_blk++;
			continue;
		}

		if (block == start_blk) {
			start_blk++;
			continue;
		}

		memset((u8 *)ops_para,
			0x0,
			sizeof(struct chip_ops_para));
		tmp_value = start_blk - start_blk % controller->chip_num;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = tmp_value * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		ret = operation->block_isbad(aml_chip);
		if (ret == NAND_BLOCK_FACTORY_BAD) {
			aml_nand_msg("blk %d is shipped bad block ",
				start_blk);
			start_blk++;
			continue;
		}
		if (ret == NAND_BLOCK_USED_BAD) {
			aml_nand_msg("blk %d is used bad block ",
				start_blk);
			start_blk++;
			continue;
		}
		/*
		ret = amlnand_free_block_test(aml_chip, start_blk);
		if (ret) {
			aml_nand_msg("nand get free block  %d invalid",
				start_blk);
			start_blk++;
			continue;
		}*/

		if (aml_chip->state == CHIP_READY)
			nand_get_chip(aml_chip);
		ret = operation->erase_block(aml_chip);
		if (aml_chip->state == CHIP_READY)
			nand_release_chip(aml_chip);
		if (ret < 0) {
			aml_nand_msg("nand blk %d check good but erase failed",
				start_blk);
			ret = operation->block_markbad(aml_chip);
			start_blk++;
			continue;
		} else
			aml_nand_dbg("nand get free block at %d", start_blk);

		blk_addr++;
	}

	if (start_blk >= total_blk) {
		ret = -NAND_BAD_BLCOK_FAILURE;
		aml_nand_msg("nand can not find free block");
	}

	return (ret == 0) ? start_blk : ret;
}

void amlnand_info_error_handle(struct amlnand_chip *aml_chip)
{
	struct nand_arg_info *nand_bbt = &aml_chip->nand_bbtinfo;
	struct nand_arg_info *nand_config = &aml_chip->config_msg;
	int ret = 0;

	if ((nand_bbt->arg_valid) && (nand_bbt->update_flag)) {
		/* aml_nand_msg("amlnand_info_error_handle : update bbt"); */
		ret = amlnand_update_bbt(aml_chip);
		nand_bbt->update_flag = 0;
		aml_nand_msg("NAND UPDATE CKECK : arg %s:", "bbt");
		aml_nand_msg("arg_valid=%d,valid_blk_addr=%d,valid_pg_addr=%d",
			nand_bbt->arg_valid,
			nand_bbt->valid_blk_addr,
			nand_bbt->valid_page_addr);
		if (ret) {
			aml_nand_msg("%s: nand update bbt failed", __func__);
			return;
		}
	}

	if ((nand_config->arg_valid) && (nand_config->update_flag)) {
		/*
		aml_nand_msg("amlnand_info_error_handle : update nand config");
		*/
		aml_chip->config_ptr->crc =
			aml_info_checksum(
			(u8 *)(aml_chip->config_ptr->dev_para),
			(MAX_DEVICE_NUM*sizeof(struct dev_para)));
		 ret = amlnand_save_info_by_name(aml_chip,
			(u8 *) &(aml_chip->config_msg),
			(u8 *)aml_chip->config_ptr,
			(u8 *)CONFIG_HEAD_MAGIC,
			sizeof(struct nand_config));
		nand_config->update_flag = 0;
		aml_nand_msg("NAND UPDATE CKECK: arg %s:", "config");
		aml_nand_msg("arg_valid=%d,valid_blk_addr=%d,valid_pg_addr=%d",
			nand_config->arg_valid,
			nand_config->valid_blk_addr,
			nand_config->valid_page_addr);
		if (ret < 0) {
			aml_nand_msg("save nand dev_configs failed and ret:%d",
				ret);
			return;
		}
	}

	return;
}
int amlnand_erase_info_by_name(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *name)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct nand_arg_info *arg_info = (struct nand_arg_info *)info;

	u8 phys_erase_shift, phys_page_shift, nand_boot;
	u32 offset;
	u32 pages_per_blk;
	u8 oob_buf[sizeof(struct nand_arg_oobinfo)];
	u16 start_blk, tmp_blk;
	int  ret = 0;
	u32 tmp_value;

	nand_boot = 1;

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else
		offset = 0;

	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));

	if ((flash->new_type)
		&& ((flash->new_type < 10)
		|| (flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;

	start_blk = (offset >> phys_erase_shift);
	tmp_blk = start_blk;

	if (arg_info->arg_valid == 1) {

		memset((u8 *)ops_para,
			0x0,
			sizeof(struct chip_ops_para));
		if ((flash->new_type)
			&& ((flash->new_type < 10)
			|| (flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE;

		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);
		memset((u8 *)ops_para->data_buf,
			0x0, flash->pagesize);
		memset((u8 *)ops_para->oob_buf,
			0x0, sizeof(oob_buf));
		/* calculate address */
		tmp_value = arg_info->valid_blk_addr;
		tmp_value = tmp_value-tmp_value % controller->chip_num;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;

		ops_para->page_addr = tmp_value * pages_per_blk;
		ops_para->chipnr =
			arg_info->valid_blk_addr % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);
#ifdef AML_NAND_UBOOT
		nand_get_chip(aml_chip);
#else
		if (aml_chip->state == CHIP_READY)
			nand_get_chip(aml_chip);
#endif	/* AML_NAND_UBOOT */
		/* erase block ! */
		ret = operation->erase_block(aml_chip);
#ifdef AML_NAND_UBOOT
		nand_release_chip(aml_chip);
#else
		if (aml_chip->state == CHIP_READY)
			nand_release_chip(aml_chip);
#endif
		if (ret < 0) {
			aml_nand_msg("erase arg %s fail,chip%d page=%d",
				name,
				ops_para->chipnr,
				ops_para->page_addr);
		}
		arg_info->arg_valid = 0;
	}

	return ret;
}

int amlnand_read_info_by_name(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *buf,
	u8 *name,
	u32 size)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct en_slc_info *slc_info = &(controller->slc_info);
	struct nand_arg_info *arg_info = (struct nand_arg_info *)info;
	struct nand_arg_oobinfo *arg_oob_info;

	u8 phys_erase_shift, phys_page_shift, nand_boot;
	u32 offset, offset_tmp;
	u32 pages_per_blk, amount_loaded = 0;
	u8 oob_buf[sizeof(struct nand_arg_oobinfo)];
	u16 start_blk, tmp_blk;
	int  ret = 0, len;
	u32 tmp_value, tmp_index;

	nand_boot = 1;

	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else
		offset = 0;

	arg_oob_info = (struct nand_arg_oobinfo *)oob_buf;
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));

	if ((flash->new_type)
		&& ((flash->new_type < 10)
		|| (flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;
#if 0
	if (ops_para->option & DEV_SLC_MODE)
		pages_read = pages_per_blk >> 1;
	else
		pages_read = pages_per_blk;
#endif //0
	start_blk = (offset >> phys_erase_shift);
	tmp_blk = start_blk;
	/*total_blk = (offset >> phys_erase_shift) + RESERVED_BLOCK_CNT; */

	if (arg_info->arg_valid == 1) {
		/* load bbt */
		offset_tmp = 0;
		while (amount_loaded < size) {
			memset((u8 *)ops_para,
				0x0,
				sizeof(struct chip_ops_para));
			if ((flash->new_type)
				&& ((flash->new_type < 10)
				|| (flash->new_type == SANDISK_19NM)))
				ops_para->option |= DEV_SLC_MODE;

			ops_para->data_buf = aml_chip->user_page_buf;
			ops_para->oob_buf = aml_chip->user_oob_buf;
			ops_para->ooblen = sizeof(oob_buf);
			memset((u8 *)ops_para->data_buf,
				0x0, flash->pagesize);
			memset((u8 *)ops_para->oob_buf,
				0x0, sizeof(oob_buf));

			tmp_value = arg_info->valid_blk_addr;
			tmp_value = tmp_value-tmp_value % controller->chip_num;
			tmp_value /= controller->chip_num;
			tmp_value += tmp_blk - tmp_blk/controller->chip_num;
			ops_para->page_addr = (arg_info->valid_page_addr +
				tmp_value * pages_per_blk) + offset_tmp;

			if ((ops_para->option & DEV_SLC_MODE)) {
				tmp_value = ~(pages_per_blk - 1);
				tmp_value &= ops_para->page_addr;
				if ((flash->new_type > 0)
					&& (flash->new_type < 10)) {
					tmp_index = ops_para->page_addr % 256;
					ops_para->page_addr = tmp_value |
						slc_info->pagelist[tmp_index];
				}
				if (flash->new_type == SANDISK_19NM)
					ops_para->page_addr = tmp_value |
						((ops_para->page_addr %
						pages_per_blk) << 1);
			}

			ops_para->chipnr =
				arg_info->valid_blk_addr % controller->chip_num;
			controller->select_chip(controller, ops_para->chipnr);
#ifdef AML_NAND_UBOOT
			nand_get_chip(aml_chip);
#else
			if (aml_chip->state == CHIP_READY)
				nand_get_chip(aml_chip);
#endif	/* AML_NAND_UBOOT */
			ret = operation->read_page(aml_chip);
#ifdef AML_NAND_UBOOT
		nand_release_chip(aml_chip);
#else
		if (aml_chip->state == CHIP_READY)
			nand_release_chip(aml_chip);
#endif
			if ((ops_para->ecc_err) || (ret < 0)) {
				aml_nand_msg("read arg %s fail,chip%d page=%d",
					name,
					ops_para->chipnr,
					ops_para->page_addr);
				goto exit_error0;
			}

			memcpy((u8 *)arg_oob_info,
				aml_chip->user_oob_buf,
				sizeof(oob_buf));
			if (!memcmp(arg_oob_info->name, name, 4)) {
				len = min(flash->pagesize, size-amount_loaded);
				memcpy(((u8 *)(buf)+amount_loaded),
					(u8 *)aml_chip->user_page_buf,
					len);
			}
			offset_tmp += 1;
			amount_loaded += flash->pagesize;
		}
	}

	return ret;
exit_error0:
	return ret;
}

int amlnand_save_info_by_name(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *buf,
	u8 *name,
	u32 size)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct en_slc_info *slc_info = &(controller->slc_info);
	struct nand_arg_info *arg_info = (struct nand_arg_info *)info;
	struct nand_arg_oobinfo *arg_oob_info;
	u32 len, offset, offset_tmp, nand_boot, blk_addr = 0;
	u32 tmp_blk_addr, amount_saved = 0;
	u32 pages_per_blk, arg_pages, pages_read;
	u8 phys_erase_shift, phys_page_shift;
	u8 oob_buf[sizeof(struct nand_arg_oobinfo)];
	u16 tmp_blk;
	u32 tmp_addr, temp_option;
	u8 temp_ran_mode;
	int full_page_flag = 0, ret = 0, i, test_cnt = 0;
	int extra_page = 0, write_page_cnt = 0, temp_page_num = 0;
	u32 tmp_value, index;

	ENV_NAND_LINE
	nand_boot = 1;

	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}	*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else
		offset = 0;
	ENV_NAND_LINE
	/*printk("aml_chip %p\n", aml_chip);*/
	/*printk("flash %p, block %d, page %d\n", flash, flash->blocksize, flash->pagesize);*/
	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));
	aml_nand_msg("%s(), %d", __func__, __LINE__);
	aml_nand_msg("name %s, size:%d", name, size);
	arg_pages = ((size>>phys_page_shift) + 1);
	//aml_nand_msg("arg_pages:%d", arg_pages);
	if ((size%flash->pagesize) == 0)
		extra_page = 1;
	else
		extra_page = 0;
	//aml_nand_msg("extra_page:%d", extra_page);

	tmp_blk = (offset >> phys_erase_shift);

	if ((flash->new_type) && ((flash->new_type < 10)
		|| (flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;

	if (ops_para->option & DEV_SLC_MODE)
		pages_read = pages_per_blk >> 1;
	else
		pages_read = pages_per_blk;

write_again:
	arg_oob_info = (struct nand_arg_oobinfo *) oob_buf;
	arg_info->timestamp += 1;
	arg_oob_info->timestamp = arg_info->timestamp;

	memcpy(arg_oob_info->name, name, 4);
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));

#if 0
	aml_nand_dbg(" buf: %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x",
		bbt_ptr[0], bbt_ptr[1], bbt_ptr[2], bbt_ptr[3], bbt_ptr[4],
		bbt_ptr[5], bbt_ptr[6], bbt_ptr[7], bbt_ptr[8], bbt_ptr[9],
		bbt_ptr[10], bbt_ptr[11], bbt_ptr[12], bbt_ptr[13],
		bbt_ptr[14], bbt_ptr[15]);

	aml_nand_dbg(" oob_buf: %x %x %x %x %x %x %x %x",
		oob_buf[0], oob_buf[1], oob_buf[2], oob_buf[3],
		oob_buf[4], oob_buf[5], oob_buf[6], oob_buf[7]);

	aml_nand_dbg(" bbt_oob_info: %x %x %x %x %x %x %x %x",
		bbt_oob_info[0], bbt_oob_info[1], bbt_oob_info[2],
		bbt_oob_info[3], bbt_oob_info[4], bbt_oob_info[5],
		bbt_oob_info[6], bbt_oob_info[7]);
#endif

get_free_blk:
	/* get new block according to arg_type or update_flag */
	if ((arg_info->arg_valid)
		&& (!arg_info->update_flag)
		&& (arg_info->arg_type == FULL_PAGE)) {
		if ((arg_info->valid_page_addr + 2 * arg_pages) > pages_read) {
			ret = amlnand_get_free_block(aml_chip, blk_addr);
			blk_addr = ret;
			if (ret < 0) {
				aml_nand_msg("nand get free blcok failed");
				ret = -NAND_BAD_BLCOK_FAILURE;
				goto exit_error0;
			}
			aml_nand_dbg("nand get free block  at %d", blk_addr);
			full_page_flag = 1;
		} else
			blk_addr = arg_info->valid_blk_addr;
	} else {
		ret = amlnand_get_free_block(aml_chip, blk_addr);
		blk_addr = ret;
		aml_nand_msg("%s, %d: new blk %d", __func__, __LINE__, blk_addr);
		if (ret < 0) {
			aml_nand_msg("nand get free block failed");
			ret = -NAND_BAD_BLCOK_FAILURE;
			goto exit_error0;
		}
		aml_nand_dbg("nand get free block  at %d", blk_addr);
	}

	/* show_data_buf(buf); */
	if (arg_info->arg_type == FULL_BLK) {
		for (i = 0; i < pages_read;) {
			if ((pages_read - i) < arg_pages) {
				if (flash->new_type == HYNIX_1YNM) {
					/*
					for slc mode, if not full block write,
					need write dummy random data to lock
					data
					*/
					/*
					write dummy page
					*/
					memset((u8 *)ops_para,
						0x0,
						sizeof(struct chip_ops_para));
					ops_para->option |= DEV_SLC_MODE;

					tmp_value = blk_addr;
					tmp_value /= controller->chip_num;
					tmp_value += tmp_blk -
						tmp_blk/controller->chip_num;
					tmp_value *= pages_per_blk;
					ops_para->page_addr = tmp_value + i;
					tmp_value = ~(pages_per_blk - 1);
					tmp_value &= ops_para->page_addr;
					index = ops_para->page_addr % 256;
					ops_para->page_addr = tmp_value |
						(slc_info->pagelist[index]);
					ops_para->chipnr =
						blk_addr % controller->chip_num;
					controller->select_chip(controller,
						ops_para->chipnr);
					ops_para->data_buf =
						aml_chip->user_page_buf;
					ops_para->oob_buf =
						aml_chip->user_oob_buf;
					ops_para->ooblen = sizeof(oob_buf);
					memset(aml_chip->user_oob_buf, 0x5a,
						sizeof(oob_buf));
					memset(aml_chip->user_page_buf, 0x5a,
						flash->pagesize);
				#ifdef AML_NAND_UBOOT
					nand_get_chip(aml_chip);
				#else
					nand_get_chip(aml_chip);
				#endif
			aml_nand_msg("dummy random data,i=%d pg_addr=%x",
						i,
						ops_para->page_addr);
					ret = operation->write_page(aml_chip);
				#ifdef AML_NAND_UBOOT
					nand_release_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
						nand_release_chip(aml_chip);
				#endif

					/* write dummy page paried */
					tmp_addr = ops_para->page_addr;
					temp_ran_mode = controller->ran_mode;
					temp_option = ops_para->option;
					controller->ran_mode = 0;
					ops_para->page_addr += 1;
			aml_nand_msg("dummy random paired data,i=%d pg_addr=%x",
						i,
						ops_para->page_addr);
					ops_para->option |= DEV_ECC_SOFT_MODE;
					ops_para->option &=
						DEV_SERIAL_CHIP_MODE;
					memset(aml_chip->user_page_buf, 0xff,
						flash->pagesize);
					memset(aml_chip->user_oob_buf, 0xff,
						sizeof(oob_buf));
				#ifdef AML_NAND_UBOOT
					nand_get_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
						nand_get_chip(aml_chip);
				#endif
					ret = operation->write_page(aml_chip);
				#ifdef AML_NAND_UBOOT
					nand_release_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
						nand_release_chip(aml_chip);
				#endif
					controller->ran_mode = temp_ran_mode;
					ops_para->page_addr = tmp_addr;
					ops_para->option = temp_option;
				}
				break;
			}
			offset_tmp = 0;
			amount_saved = 0;
			while (amount_saved <
				(size+extra_page*flash->pagesize)) {
				memset((u8 *)ops_para, 0x0,
					sizeof(struct chip_ops_para));
				if ((flash->new_type)
					&& ((flash->new_type < 10)
					|| (flash->new_type == SANDISK_19NM)))
					ops_para->option |= DEV_SLC_MODE;

				tmp_value = blk_addr;
				tmp_value /= controller->chip_num;
				tmp_value += tmp_blk -
					tmp_blk/controller->chip_num;
				tmp_value *= pages_per_blk;
				tmp_value += offset_tmp + i;
				ops_para->page_addr = tmp_value;

				if ((ops_para->option & DEV_SLC_MODE)) {
					tmp_value = ops_para->page_addr;
					tmp_value &= (~(pages_per_blk - 1));
					if ((flash->new_type > 0)
						&& (flash->new_type < 10)) {
						index =
						ops_para->page_addr % 256;
						ops_para->page_addr =
						tmp_value |
						(slc_info->pagelist[index]);
					}
					if (flash->new_type == SANDISK_19NM) {
						index = ops_para->page_addr;
						index %= pages_per_blk;
						index <<= 0x01;
						ops_para->page_addr =
							tmp_value | index;
					}
				}

				ops_para->chipnr =
					blk_addr % controller->chip_num;
				controller->select_chip(controller,
					ops_para->chipnr);
				ops_para->data_buf = aml_chip->user_page_buf;
				ops_para->oob_buf = aml_chip->user_oob_buf;
				ops_para->ooblen = sizeof(oob_buf);

				len = min(flash->pagesize,
					size +
					extra_page*flash->pagesize -
					amount_saved);
				memset(aml_chip->user_page_buf,
					0x0,
					flash->pagesize);
				memset(aml_chip->user_oob_buf,
					0x0,
					sizeof(oob_buf));
				memcpy((u8 *)aml_chip->user_page_buf,
					((u8 *)(buf) + amount_saved),
					len);
				memcpy(aml_chip->user_oob_buf,
					(u8 *)arg_oob_info,
					sizeof(oob_buf));
#if 0
			aml_nand_dbg("oob_buf:%x %x %x %x %x %x %x %x",
				ops_para->oob_buf[0], ops_para->oob_buf[1],
				ops_para->oob_buf[2], ops_para->oob_buf[3],
				ops_para->oob_buf[4], ops_para->oob_buf[5],
				ops_para->oob_buf[6], ops_para->oob_buf[7]);
#endif
			#ifdef AML_NAND_UBOOT
				nand_get_chip(aml_chip);
			#else
				if (aml_chip->state == CHIP_READY)
				nand_get_chip(aml_chip);
			#endif
				ret = operation->write_page(aml_chip);


			#ifdef AML_NAND_UBOOT
					nand_release_chip(aml_chip);
			#else
					if (aml_chip->state == CHIP_READY)
						nand_release_chip(aml_chip);
			#endif
				if (ret < 0) {
					aml_nand_msg("%s() %d: nand write failed", __func__, __LINE__);
					if (test_cnt >= 3) {
						aml_nand_msg("test 3 times");
						break;
					}
				ret = operation->test_block_reserved(aml_chip,
					blk_addr);
					test_cnt++;
			if (ret) {
				ret = operation->block_markbad(aml_chip);
				if (ret < 0)
					aml_nand_msg("nand mark bad blk=%d",
						blk_addr);
			}
					aml_nand_msg("rewrite!");
					goto get_free_blk;
				}
				/*for slc mode*/
				if (flash->new_type == HYNIX_1YNM) {
					temp_page_num = offset_tmp + i;
				if (temp_page_num >= 1) {
					ops_para->chipnr =
						blk_addr % controller->chip_num;
					controller->select_chip(controller,
						ops_para->chipnr);

					tmp_addr = ops_para->page_addr;
					temp_ran_mode = controller->ran_mode;
					temp_option = ops_para->option;
					controller->ran_mode = 0;
					ops_para->page_addr += 1;
					ops_para->option |= DEV_ECC_SOFT_MODE;
					ops_para->option &=
						DEV_SERIAL_CHIP_MODE;
					memset(aml_chip->user_page_buf, 0xff,
						flash->pagesize);
					memset(aml_chip->user_oob_buf, 0xff,
						sizeof(oob_buf));
				#ifdef AML_NAND_UBOOT
					nand_get_chip(aml_chip);
				#else
						if (aml_chip->state == CHIP_READY)
							nand_get_chip(aml_chip);
				#endif
			/*
			aml_nand_msg("normal blk write,pgnum=%d pgaddr=%x",
						temp_page_num,
						ops_para->page_addr);
			*/
						ret =
						operation->write_page(aml_chip);
				#ifdef AML_NAND_UBOOT
					nand_release_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
						nand_release_chip(aml_chip);
				#endif
					controller->ran_mode = temp_ran_mode;
					ops_para->page_addr = tmp_addr;
					ops_para->option = temp_option;
					/*
					ops_para->option &= DEV_ECC_HW_MODE;
					*/
					/* ops_para->option |=DEV_SLC_MODE; */
				}
				}

				offset_tmp += 1;
				amount_saved += flash->pagesize;
			}
			i += arg_pages;
			if (ret < 0)
				break;
		}
	} else if (arg_info->arg_type == FULL_PAGE) {
		offset_tmp = 0;
		amount_saved = 0;
		while (amount_saved < size+extra_page*flash->pagesize) {
			memset((u8 *)ops_para, 0x0,
				sizeof(struct chip_ops_para));
			if ((flash->new_type)
				&& ((flash->new_type < 10)
				|| (flash->new_type == SANDISK_19NM)))
				ops_para->option |= DEV_SLC_MODE;
			tmp_value = blk_addr;
			tmp_value /= controller->chip_num;
			tmp_value += tmp_blk - tmp_blk/controller->chip_num;
			tmp_value *= pages_per_blk;
			ops_para->page_addr = tmp_value + offset_tmp;
			if (arg_info->arg_valid
				&& (!full_page_flag)
				&& (!arg_info->update_flag))
				ops_para->page_addr +=
					(arg_info->valid_page_addr + arg_pages);

			/*for slc mode*/
			if (flash->new_type == HYNIX_1YNM) {
				if (arg_info->arg_valid
					&& (!full_page_flag)
					&& (!arg_info->update_flag))
					ops_para->page_addr += 1;
					temp_page_num =
					ops_para->page_addr % 256;
			}

			if ((ops_para->option & DEV_SLC_MODE)) {
				tmp_value = ops_para->page_addr;
				tmp_value &= (~(pages_per_blk - 1));
				if ((flash->new_type > 0)
					&& (flash->new_type < 10)) {
					index = ops_para->page_addr % 256;
					ops_para->page_addr = tmp_value |
						(slc_info->pagelist[index]);
				}
				if (flash->new_type == SANDISK_19NM) {
					index = ops_para->page_addr;
					index %= pages_per_blk;
					index <<= 0x01;
					ops_para->page_addr = tmp_value | index;
				}
			}

			ops_para->chipnr = blk_addr % controller->chip_num;
			controller->select_chip(controller, ops_para->chipnr);

			ops_para->data_buf = aml_chip->user_page_buf;
			ops_para->oob_buf = aml_chip->user_oob_buf;
			ops_para->ooblen = sizeof(oob_buf);

			len = min(flash->pagesize,
			size + extra_page*flash->pagesize - amount_saved);
			memset(aml_chip->user_page_buf, 0x0, flash->pagesize);
			memset(aml_chip->user_oob_buf, 0x0, sizeof(oob_buf));
			memcpy((u8 *)aml_chip->user_page_buf,
				((u8 *)(buf) + amount_saved), len);
			memcpy(aml_chip->user_oob_buf,
				(u8 *)arg_oob_info, sizeof(oob_buf));

		#ifdef AML_NAND_UBOOT
			nand_get_chip(aml_chip);
		#else
			if (aml_chip->state == CHIP_READY)
				nand_get_chip(aml_chip);
		#endif
			ret = operation->write_page(aml_chip);
            //aml_nand_msg("nand write page:%d,chipnr:%d",ops_para->page_addr,ops_para->chipnr);
#ifdef AML_NAND_UBOOT
			nand_release_chip(aml_chip);
#else
			if (aml_chip->state == CHIP_READY)
				nand_release_chip(aml_chip);
#endif
			if (ret < 0) {
				aml_nand_msg("%s() %d: nand write failed", __func__, __LINE__);
				if (test_cnt >= 3) {
					aml_nand_msg("test blk 3times");
					break;
				}
				ret = operation->test_block_reserved(aml_chip,
					blk_addr);
				test_cnt++;
				if (ret) {
					ret =
					operation->block_markbad(aml_chip);
					if (ret < 0)
						aml_nand_msg("mark bad blk %d",
							blk_addr);
				}
				goto get_free_blk;
			}

			/*for slc mode*/
			if (flash->new_type == HYNIX_1YNM) {
				if (temp_page_num >= 1) {
					ops_para->chipnr =
						blk_addr % controller->chip_num;
					controller->select_chip(controller,
						ops_para->chipnr);
					tmp_addr = ops_para->page_addr;
					temp_ran_mode = controller->ran_mode;
					temp_option = ops_para->option;
					controller->ran_mode = 0;
					ops_para->page_addr += 1;
					ops_para->option |= DEV_ECC_SOFT_MODE;
					ops_para->option &=
						DEV_SERIAL_CHIP_MODE;
					memset(aml_chip->user_page_buf, 0xff,
						flash->pagesize);
					memset(aml_chip->user_oob_buf, 0xff,
						sizeof(oob_buf));
				#ifndef AML_UBOOT_NAND
					nand_get_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
						nand_get_chip(aml_chip);
				#endif
					aml_nand_msg("pgnum=%d pgaddr=%x",
						temp_page_num,
						ops_para->page_addr);
					ret = operation->write_page(aml_chip);
				#ifdef AML_NAND_UBOOT
					nand_release_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
						nand_release_chip(aml_chip);
				#endif
					controller->ran_mode = temp_ran_mode;
					ops_para->page_addr = tmp_addr;
					ops_para->option = temp_option;
					/*
					ops_para->option &= DEV_ECC_HW_MODE;
					*/
					/*
					ops_para->option |=DEV_SLC_MODE;
					*/
				}
			}

			offset_tmp += 1;
			amount_saved += flash->pagesize;

			if (flash->new_type == HYNIX_1YNM) {
				if (amount_saved >= size+
					extra_page*flash->pagesize) {
					/*
					for slc mode, if not full block write,
					need write dummy random data to lock
					data
					*/
					/*
					write dummy page
					*/
					memset((u8 *)ops_para, 0x0,
						sizeof(struct chip_ops_para));
					ops_para->option |= DEV_SLC_MODE;

					tmp_value = blk_addr;
					tmp_value /= controller->chip_num;
					tmp_value += tmp_blk -
						tmp_blk/controller->chip_num;
					tmp_value *= pages_per_blk;
					ops_para->page_addr =
						tmp_value + temp_page_num + 1;

					tmp_value = ops_para->page_addr;
					tmp_value &= (~(pages_per_blk - 1));
					index = ops_para->page_addr % 256;
					ops_para->page_addr = tmp_value |
						(slc_info->pagelist[index]);
					ops_para->chipnr =
						blk_addr % controller->chip_num;
					controller->select_chip(controller,
						ops_para->chipnr);
					ops_para->data_buf =
						aml_chip->user_page_buf;
					ops_para->oob_buf =
						aml_chip->user_oob_buf;
					ops_para->ooblen = sizeof(oob_buf);

					memset(aml_chip->user_page_buf, 0x5a,
						flash->pagesize);
					memset(aml_chip->user_oob_buf, 0x5a,
						sizeof(oob_buf));

					if (aml_chip->state == CHIP_READY)
						nand_get_chip(aml_chip);

			aml_nand_msg("dummy random data:pgnum=%d pgaddr=%x",
						temp_page_num,
						ops_para->page_addr);
					ret = operation->write_page(aml_chip);
				#ifdef AML_NAND_UBOOT
					nand_release_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
						nand_release_chip(aml_chip);
				#endif

					/* write dummy page paried */
					tmp_addr = ops_para->page_addr;
					temp_ran_mode = controller->ran_mode;
					temp_option = ops_para->option;
					controller->ran_mode = 0;
					ops_para->page_addr += 1;
					ops_para->option |= DEV_ECC_SOFT_MODE;
					ops_para->option &=
						DEV_SERIAL_CHIP_MODE;
					memset(aml_chip->user_page_buf, 0xff,
						flash->pagesize);
					memset(aml_chip->user_oob_buf, 0xff,
						sizeof(oob_buf));
				#ifdef AML_NAND_UBOOT
					nand_get_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
						nand_get_chip(aml_chip);
				#endif
		aml_nand_msg("dummy random paired data:pgnum=%d pgaddr=%x",
						temp_page_num,
						ops_para->page_addr);
					ret = operation->write_page(aml_chip);
				#ifdef AML_NAND_UBOOT
					nand_release_chip(aml_chip);
				#else
					if (aml_chip->state == CHIP_READY)
					nand_release_chip(aml_chip);
				#endif
					controller->ran_mode = temp_ran_mode;
					ops_para->page_addr = tmp_addr;
					ops_para->option = temp_option;

				}
			}
		}
	}

	if (ret < 0) { /* write failed */
		aml_nand_msg(" NAND SAVE :arg %s faild at blk:%d",
			name,
			blk_addr);
		ret = -NAND_WRITE_FAILED;
		goto exit_error0;
	} else {
		/* write success and update reserved_blk table */
		if ((arg_info->arg_valid == 0)
			|| (arg_info->arg_type == FULL_BLK)
			|| ((arg_info->arg_type == FULL_PAGE)
			&& (full_page_flag || arg_info->update_flag))) {
			for (i = 0; i < RESERVED_BLOCK_CNT; i++) {
				if (aml_chip->reserved_blk[i] == 0xff) {
					aml_nand_dbg("update blk %s blk %d",
						name,
						blk_addr);
					aml_chip->reserved_blk[i] = blk_addr;
					break;
				}
			}
		}
#if 0
		for (i = 0; i < RESERVED_BLOCK_CNT; i++)
			aml_nand_dbg("aml_chip->reserved_blk[%d]=%d ",
			i,
			aml_chip->reserved_blk[i]);
#endif
		/* write success and update arg_info */
		tmp_blk_addr = arg_info->valid_blk_addr;
		arg_info->valid_blk_addr = blk_addr;

		if ((arg_info->arg_type == FULL_PAGE)
			&& (arg_info->arg_valid)) {
			if (full_page_flag || arg_info->update_flag)
				arg_info->valid_page_addr  = 0;
			else{
				arg_info->valid_page_addr += arg_pages;
				if (flash->new_type == HYNIX_1YNM)
					arg_info->valid_page_addr += 1;
			}
		} else if ((arg_info->arg_type == FULL_BLK)
			&& (arg_info->arg_valid))
			arg_info->valid_page_addr  = 0;

		aml_nand_dbg("NAND  SAVE :  arg  %s success at blk:%d",
			name,
			blk_addr);

		/* erase old info block */
		if ((arg_info->arg_type == FULL_BLK)
			|| ((arg_info->arg_type == FULL_PAGE)
			&& (full_page_flag || arg_info->update_flag))) {
			if ((arg_info->arg_valid) && (tmp_blk_addr != 0)) {
				aml_nand_dbg("nand erase old arg %s blk at %d",
					name,
					tmp_blk_addr);
				tmp_value = tmp_blk_addr;
				tmp_value /= controller->chip_num;
				tmp_value += tmp_blk -
					tmp_blk/controller->chip_num;
				ops_para->page_addr = tmp_value * pages_per_blk;
				ops_para->chipnr =
					tmp_blk_addr % controller->chip_num;
				controller->select_chip(controller,
					ops_para->chipnr);
#ifdef AML_NAND_UBOOT
					nand_get_chip(aml_chip);
#else
					if (aml_chip->state == CHIP_READY)
						nand_get_chip(aml_chip);
#endif
					 ret = operation->erase_block(aml_chip);
#ifdef AML_NAND_UBOOT
					nand_release_chip(aml_chip);
#else
					if (aml_chip->state == CHIP_READY)
						nand_release_chip(aml_chip);
#endif
				if (ret < 0) {
					aml_nand_msg("blk %d erase failed",
						tmp_blk_addr);
					ret =
					operation->test_block_reserved(aml_chip,
						tmp_blk_addr);
				if (ret) {
					ret =
					operation->block_markbad(aml_chip);
				if (ret < 0) {
					aml_nand_msg("mark failed,blk=%d",
						tmp_blk_addr);
					goto exit_error0;
				}
			}
		}

				for (i = 0; i < RESERVED_BLOCK_CNT; i++) {
					if (aml_chip->reserved_blk[i]
						== tmp_blk_addr) {
						aml_chip->reserved_blk[i] =
							0xff;
						break;
					}
				}
#if 0
				for (i = 0; i < RESERVED_BLOCK_CNT; i++)
					aml_nand_dbg("reserved_blk[%d]=%d ",
						i,
						aml_chip->reserved_blk[i]);
#endif
			}
		}
		/*
		add 'flash->blocksize > 0x40000' here,nand flash which blocksize
		is smaller than 256KB(slc flash) shoudn't write again.
		*/
		if ((arg_info->arg_type == FULL_PAGE) && (flash->blocksize > 0x40000)) {
			if (write_page_cnt == 0) {
				arg_info->arg_valid = 1;
				full_page_flag = 0;
				arg_info->update_flag = 0;
				write_page_cnt = 1;
				goto write_again;
			}
		}
		arg_info->arg_valid = 1;   /* SAVE SET VALID */
		full_page_flag = 0;
	}

exit_error0:
	return ret;
}


void show_data_buf(u8 *buf)
{
	int i = 0;

	for (i = 0; i < 10; i++)
		aml_nand_dbg("buf[%d]= %d", i, buf[i]);

	return;
}

int amlnand_check_info_by_name(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *name,
	u32 size)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct en_slc_info *slc_info = &(controller->slc_info);
	struct nand_arg_info *arg_info = (struct nand_arg_info *)info;
	struct nand_arg_oobinfo *arg_oob_info;

	u8 phys_erase_shift, phys_page_shift, nand_boot;
	u32 i, offset, pages_per_blk, pages_read;
	u8 oob_buf[sizeof(struct nand_arg_oobinfo)];
	u16 start_blk, total_blk, tmp_blk;
	int ret = 0, read_failed_page = 0, read_middle_page_failed = 0;
	u32 tmp_value, index;

	nand_boot = 1;
	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}	*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else
		offset = 0;
	ENV_NAND_LINE
	arg_oob_info = (struct nand_arg_oobinfo *)oob_buf;
	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));

	if ((flash->new_type)
		&& ((flash->new_type < 10)
		|| (flash->new_type == SANDISK_19NM)))
		ops_para->option |= DEV_SLC_MODE;

	if (ops_para->option & DEV_SLC_MODE)
		pages_read = pages_per_blk >> 1;
	else
		pages_read = pages_per_blk;

	start_blk = (offset >> phys_erase_shift);
	tmp_blk = start_blk;
#if 0
	total_blk = (offset >> phys_erase_shift) + RESERVED_BLOCK_CNT;
#else
	total_blk = get_last_reserve_block(aml_chip);
#endif
	ENV_NAND_LINE
#if 1
	for (; start_blk < total_blk; start_blk++) {
		read_failed_page = 0;
		read_middle_page_failed = 0;
		memset((u8 *)ops_para, 0x0,
			sizeof(struct chip_ops_para));

		tmp_value = start_blk;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = tmp_value * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);
		ret = operation->block_isbad(aml_chip);
		if (ret) {
			aml_nand_dbg("blk %d is bad ", start_blk);
			continue;
		}
		for (i = 0; i < pages_read;) {
			memset((u8 *)ops_para, 0x0,
				sizeof(struct chip_ops_para));
			if ((flash->new_type)
				&& ((flash->new_type < 10)
				|| (flash->new_type == SANDISK_19NM)))
				ops_para->option |= DEV_SLC_MODE;

			ops_para->page_addr = (i + tmp_value * pages_per_blk);
			ops_para->chipnr = start_blk % controller->chip_num;

			controller->select_chip(controller, ops_para->chipnr);

			if ((ops_para->option & DEV_SLC_MODE)) {
				index = ops_para->page_addr;
				index &= (~(pages_per_blk - 1));
				if ((flash->new_type > 0)
					&& (flash->new_type < 10))
					ops_para->page_addr = index |
				(slc_info->pagelist[ops_para->page_addr % 256]);
				if (flash->new_type == SANDISK_19NM)
					ops_para->page_addr = index |
				((ops_para->page_addr % pages_per_blk) << 1);
			}
			ops_para->data_buf = aml_chip->user_page_buf;
			ops_para->oob_buf = aml_chip->user_oob_buf;
			ops_para->ooblen = sizeof(oob_buf);

			memset(ops_para->data_buf, 0x0, flash->pagesize);
			memset(ops_para->oob_buf, 0x0, sizeof(oob_buf));
			ENV_NAND_LINE
			nand_get_chip(aml_chip);
			ENV_NAND_LINE
			ret = operation->read_page(aml_chip);
			ENV_NAND_LINE
			nand_release_chip(aml_chip);

			if ((ops_para->ecc_err) || (ret < 0)) {
				aml_nand_msg("blk check good but read failed");
				aml_nand_msg("chip%d page=%d",
					ops_para->chipnr,
					ops_para->page_addr);
				read_failed_page++;
				i += (size >> phys_page_shift) + 1;
				if ((read_failed_page > 8)
					&& (read_middle_page_failed == 0)) {
					aml_nand_msg("failed_pg=%d",
						read_failed_page);
					i = ((size >> phys_page_shift) + 1) *
			((pages_per_blk/((size >> phys_page_shift) + 1))>>1);
					read_middle_page_failed = -1;
				} else if (read_middle_page_failed == -1) {
					aml_nand_msg("failed_page=%d",
						read_failed_page);
					i = ((size >> phys_page_shift) + 1) *
			((pages_per_blk/((size >> phys_page_shift) + 1)));
					read_middle_page_failed = -2;
				}
				continue;
			}

			memcpy((u8 *)arg_oob_info,
				aml_chip->user_oob_buf,
				sizeof(oob_buf));
			if ((!memcmp(arg_oob_info->name, name, 4))) {
				if (arg_info->arg_valid == 1) {
					if (arg_oob_info->timestamp >
						arg_info->timestamp) {
						arg_info->free_blk_addr =
						arg_info->valid_blk_addr;
						arg_info->valid_blk_addr =
							start_blk;
						arg_info->timestamp =
							arg_oob_info->timestamp;
					} else
						arg_info->free_blk_addr =
							start_blk;
					break;
				} else {
					arg_info->arg_valid = 1;
					arg_info->valid_blk_addr = start_blk;
					arg_info->timestamp =
						arg_oob_info->timestamp;
				}
			}
			break;
		}

		if ((arg_info->arg_type == FULL_BLK)
			&& (arg_info->arg_valid == 1)
			&& (arg_info->valid_blk_addr != 0))
			break;
	}
#else
	do {
		memset((u8 *)ops_para, 0x0,
			sizeof(struct chip_ops_para));
		ops_para->page_addr =
		(((start_blk - start_blk % controller->chip_num) /
		controller->chip_num) + tmp_blk -
		tmp_blk/controller->chip_num) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);
		ret = operation->block_isbad(aml_chip);
		if (ret < 0) {
			aml_nand_msg("blk %d is bad ",
				start_blk);
			continue;
		}

		memset((u8 *)ops_para, 0x0,
			sizeof(struct chip_ops_para));
		if ((flash->new_type) && ((flash->new_type < 10)
			|| (flash->new_type == SANDISK_19NM)))
			ops_para->option |= DEV_SLC_MODE
		ops_para->page_addr =
			(((start_blk - start_blk % controller->chip_num) /
			controller->chip_num) + tmp_blk -
			tmp_blk/controller->chip_num) * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		if ((ops_para->option & DEV_SLC_MODE)) {
			if ((flash->new_type > 0) && (flash->new_type < 10))
				ops_para->page_addr = (ops_para->page_addr &
					(~(pages_per_blk - 1))) |
				(slc_info->pagelist[ops_para->page_addr % 256]);
			if (flash->new_type == SANDISK_19NM)
				ops_para->page_addr =
			(ops_para->page_addr & (~(pages_per_blk - 1))) |
				((ops_para->page_addr % pages_per_blk) << 1);
		}

		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		memset(ops_para->data_buf, 0x0, flash->pagesize);
		memset(ops_para->oob_buf, 0x0, sizeof(oob_buf));

		if (aml_chip->state == CHIP_READY)
			nand_get_chip(aml_chip);

		ret = operation->read_page(aml_chip);

		if (aml_chip->state == CHIP_READY)
			nand_release_chip(aml_chip);

		if ((ops_para->ecc_err) || (ret < 0)) {
			aml_nand_msg("blk check good but read failed");
			aml_nand_msg("chip%d page=%d",
				ops_para->chipnr,
				ops_para->page_addr);
			continue;
		}

#if 0
	aml_nand_dbg(" ops_para->oob_buf : %x %x %x %x %x %x %x %x",
		ops_para->oob_buf[0], ops_para->oob_buf[1],
		ops_para->oob_buf[2], ops_para->oob_buf[3],
		ops_para->oob_buf[4], ops_para->oob_buf[5],
		ops_para->oob_buf[6], ops_para->oob_buf[7]);
#endif
		memcpy((u8 *)arg_oob_info,  aml_chip->user_oob_buf,
			sizeof(oob_buf));
		if ((!memcmp(arg_oob_info->name, name, 4))) {
			if (arg_info->arg_valid == 1) {
				if (arg_oob_info->timestamp >
					arg_info->timestamp) {
					arg_info->free_blk_addr =
						arg_info->valid_blk_addr;
					arg_info->valid_blk_addr = start_blk;
					arg_info->timestamp =
						arg_oob_info->timestamp;
				} else
					arg_info->free_blk_addr = start_blk;
				break;
			} else {
				arg_info->arg_valid = 1;
				arg_info->valid_blk_addr = start_blk;
				arg_info->timestamp = arg_oob_info->timestamp;
			}
		}

		if ((arg_info->arg_type == FULL_BLK)
			&& (arg_info->arg_valid == 1)
			&& (arg_info->valid_blk_addr != 0))
			break;
	} while ((++start_blk) < total_blk);
#endif

	if (arg_info->arg_valid == 1) {
		if (arg_info->arg_type == FULL_BLK) {
			for (i = 0; i < pages_read;) {
				memset((u8 *)ops_para, 0x0,
					sizeof(struct chip_ops_para));
				ops_para->data_buf = NULL;
				ops_para->oob_buf = aml_chip->user_oob_buf;
				ops_para->ooblen = sizeof(oob_buf);
				memset((u8 *)ops_para->oob_buf, 0x0,
					sizeof(oob_buf));

				if ((flash->new_type)
					&& ((flash->new_type < 10)
					|| (flash->new_type == SANDISK_19NM)))
					ops_para->option |= DEV_SLC_MODE;

				tmp_value = arg_info->valid_blk_addr;
				tmp_value /= controller->chip_num;
				tmp_value += tmp_blk -
					tmp_blk/controller->chip_num;
				tmp_value *= pages_per_blk;
				ops_para->page_addr = i + tmp_value;

				if ((ops_para->option & DEV_SLC_MODE)) {
					index = ops_para->page_addr;
					index &= (~(pages_per_blk - 1));
					if ((flash->new_type > 0)
						&& (flash->new_type < 10))
						ops_para->page_addr = index |
				(slc_info->pagelist[ops_para->page_addr % 256]);
					if (flash->new_type == SANDISK_19NM)
						ops_para->page_addr = index |
				((ops_para->page_addr % pages_per_blk) << 1);
				}

				ops_para->chipnr =
				arg_info->valid_blk_addr % controller->chip_num;
				controller->select_chip(controller,
					ops_para->chipnr);

				if (aml_chip->state == CHIP_READY)
					nand_get_chip(aml_chip);

				ret = operation->read_page(aml_chip);

				if (aml_chip->state == CHIP_READY)
					nand_release_chip(aml_chip);

			if ((ops_para->ecc_err) || (ret < 0)) {
				aml_nand_msg("read %s failed chip%d page=%d",
					name,
					ops_para->chipnr,
					ops_para->page_addr);
				i += (size >> phys_page_shift) + 1;
				arg_info->update_flag = 1;
				continue;
			}

				memcpy((u8 *)arg_oob_info,
					aml_chip->user_oob_buf,
					sizeof(oob_buf));
				if (!memcmp(arg_oob_info->name, name, 4)) {
					arg_info->valid_page_addr = i;
					arg_info->timestamp =
						arg_oob_info->timestamp;
					break;
				}
				i += (size >> phys_page_shift) + 1;
			}
		} else if (arg_info->arg_type == FULL_PAGE) {
			for (i = 0; i < pages_read;) {
				memset((u8 *)ops_para, 0x0,
					sizeof(struct chip_ops_para));
				if ((flash->new_type)
					&& ((flash->new_type < 10)
					|| (flash->new_type == SANDISK_19NM)))
					ops_para->option |= DEV_SLC_MODE;

				ops_para->data_buf = aml_chip->user_page_buf;
				ops_para->oob_buf = aml_chip->user_oob_buf;
				ops_para->ooblen = sizeof(oob_buf);
				memset((u8 *)ops_para->data_buf,
					0x0, flash->pagesize);
				memset((u8 *)ops_para->oob_buf,
					0x0, sizeof(oob_buf));

				tmp_value = arg_info->valid_blk_addr;
				tmp_value /= controller->chip_num;
				tmp_value += tmp_blk -
					tmp_blk/controller->chip_num;
				tmp_value *= pages_per_blk;
				ops_para->page_addr = i + tmp_value;

				if ((ops_para->option & DEV_SLC_MODE)) {
					index = ops_para->page_addr;
					index &= (~(pages_per_blk - 1));
					if ((flash->new_type > 0)
						&& (flash->new_type < 10))
						ops_para->page_addr = index |
				(slc_info->pagelist[ops_para->page_addr % 256]);
					if (flash->new_type == SANDISK_19NM)
						ops_para->page_addr = index |
				((ops_para->page_addr % pages_per_blk) << 1);
				}

				ops_para->chipnr = arg_info->valid_blk_addr %
					controller->chip_num;
				controller->select_chip(controller,
					ops_para->chipnr);

				if (aml_chip->state == CHIP_READY)
					nand_get_chip(aml_chip);

				ret = operation->read_page(aml_chip);

				if (aml_chip->state == CHIP_READY)
					nand_release_chip(aml_chip);

			if ((ops_para->ecc_err) || (ret < 0)) {
				aml_nand_msg("read %s failed at chip%d page %d",
					name,
					ops_para->chipnr,
					ops_para->page_addr);
				i += (size >> phys_page_shift) + 1;
				arg_info->update_flag = 1;
				continue;
			}

				memcpy((u8 *)arg_oob_info,
					aml_chip->user_oob_buf,
					sizeof(oob_buf));
				if (!memcmp(arg_oob_info->name, name, 4)) {
					arg_info->valid_page_addr = i;
					arg_info->timestamp =
						arg_oob_info->timestamp;
				} else
					break;

				i += (size >> phys_page_shift) + 1;
				/*for hynix slc mode*/
				if (flash->new_type == HYNIX_1YNM)
					i += 1;
			}
		}

		for (i = 0; i < RESERVED_BLOCK_CNT; i++) {
			if (aml_chip->reserved_blk[i] == 0xff) {
				aml_chip->reserved_blk[i] =
					arg_info->valid_blk_addr;
				break;
			}
		}
		aml_nand_dbg("NAND CKECK: %s success at blk:%d page %d",
			name,
			arg_info->valid_blk_addr,
			arg_info->valid_page_addr);
	}
	aml_nand_msg("NAND CKECK:arg %s: valid=%d, blk=%d, page=%d",
		name,
		arg_info->arg_valid,
		arg_info->valid_blk_addr,
		arg_info->valid_page_addr);
	aml_nand_dbg(" complete ");

	return ret;
}


int amlnand_info_init(struct amlnand_chip *aml_chip,
	u8 *info,
	u8 *buf,
	u8 *name,
	u32 size)
{
	struct nand_arg_info *arg_info = (struct nand_arg_info *)info;
	int ret = 0;

	aml_nand_dbg("NAME :  %s", name);

	ret = amlnand_check_info_by_name(aml_chip,
		(u8 *) arg_info ,
		name,
		size);
	if (ret < 0) {
		aml_nand_msg("nand check info failed");
		goto exit_error;
	}

	if (arg_info->arg_valid == 1) {
		ret = amlnand_read_info_by_name(aml_chip,
			(u8 *)arg_info,
			buf,
			name,
			size);
		if (ret < 0) {
			aml_nand_msg("nand check info success but read failed");
			goto exit_error;
		}
		ret = aml_info_check_datasum(buf, name);
		if (ret < 0) {
			aml_nand_msg("amlnand_info_init:check read %s failed",
				name);
			/* ret = 0; */
			goto exit_error;
		}
	} else
		aml_nand_msg("found NO arg : %s info", name);

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
	int ret = 0;

	aml_nand_dbg("amlnand_update_bbt  :here!!");


#if 0
	/* show the bbt */
	aml_nand_dbg("show the bbt");
	for (chipnr = 0; chipnr < controller->chip_num; chipnr++) {
		tmp_arr = &aml_chip->bbt_ptr->nand_bbt[chipnr][0];
		for (start_block = 0; start_block < 200; start_block++)
			aml_nand_msg(" tmp_arr[%d][%d]=%d",
				chipnr,
				start_block,
				tmp_arr[start_block]);
	}
#endif

	aml_chip->block_status->crc =
		aml_info_checksum((u8 *)aml_chip->block_status->blk_status,
			(MAX_CHIP_NUM*MAX_BLK_NUM));
	ret = amlnand_save_info_by_name(aml_chip,
		(u8 *)&(aml_chip->nand_bbtinfo),
		(u8 *)aml_chip->block_status,
		(unsigned char *)BBT_HEAD_MAGIC,
		sizeof(struct block_status));
	if (ret < 0) {
		aml_nand_msg("nand update bbt failed");
		goto exit_error0;
	}

	return ret;
exit_error0:
	return ret;
}

int amlnand_recover_fbbt(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	u32 total_blk, chipnr, start_block, factory_badblock_cnt=0;
	u16 *tmp_bbt, *tmp_status;
	u8 phys_erase_shift;
	u64 chip_size;

	aml_nand_dbg("%s : start",__func__);
	phys_erase_shift = ffs(flash->blocksize) - 1;
	chip_size = flash->chipsize;
	total_blk = (int) ((chip_size<<20) >> phys_erase_shift);
	factory_badblock_cnt = 0;

	for (chipnr = 0; chipnr < controller->chip_num;  chipnr++) {

		tmp_bbt = &aml_chip->shipped_bbt_ptr->shipped_bbt[chipnr][0];
		tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
		for (start_block = 0; start_block < total_blk; start_block++) {

			if (tmp_status[start_block] == NAND_BLOCK_FACTORY_BAD) {

				tmp_bbt[factory_badblock_cnt++] = (0x8000 | (u16)start_block);
				if ((controller->flash_type == NAND_TYPE_MLC) &&
						(flash->option & NAND_MULTI_PLANE_MODE)) {
					// if  plane 0 is bad block,just set plane 1 to bad
					if ((start_block % 2) == 0 ) {
						start_block += 1;
						tmp_bbt[factory_badblock_cnt++] = (u16)start_block |0x8000;
					}	// if plane 1 is bad block, just set plane 0 to bad
					else{
						tmp_bbt[factory_badblock_cnt++] = (u16)(start_block -1) |0x8000;
					}

					if (factory_badblock_cnt >= MAX_BAD_BLK_NUM) {
						aml_nand_dbg("%s : error too many bad blocks",__func__);
						return -1;
					}
				}
			}
		}
	}
	return 0;
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
	/* struct chip_operation *operation = &aml_chip->operation; */
	struct nand_flash *flash = &aml_chip->flash;
	/* struct shipped_bbt * shipped_bbt_ptr = aml_chip->shipped_bbt_ptr; */
	u32 total_blk, chipnr;
	u16 *tmp_bbt, *tmp_status;
	u8 phys_erase_shift;
	u64 chip_size;
	int ret = 0, i, j;

	aml_nand_dbg("amlnand_init_block_status : start");

	phys_erase_shift = ffs(flash->blocksize) - 1;

	chip_size = flash->chipsize;
	total_blk = (int) ((chip_size<<20) >> phys_erase_shift);

#if 0
	aml_nand_dbg("show the bbt");
	for (chipnr = 0; chipnr < controller->chip_num; chipnr++) {
		tmp_arr = &aml_chip->bbt_ptr->nand_bbt[chipnr][0];
		for (start_block = 0; start_block < 200; start_block++)
			aml_nand_msg(" tmp_arr[%d][%d]=%d",
				chipnr,
				start_block,
				tmp_arr[start_block]);
	}
#endif

	for (chipnr = 0; chipnr < controller->chip_num;  chipnr++) {
		tmp_bbt = &aml_chip->shipped_bbt_ptr->shipped_bbt[chipnr][0];
		tmp_status = &aml_chip->block_status->blk_status[chipnr][0];
		for (i = 0; i < total_blk; i++) {
			tmp_status[i] = NAND_BLOCK_GOOD;
			for (j = 0; j < MAX_BAD_BLK_NUM; j++) {
				if ((tmp_bbt[j] & 0x7fff) == i) {
					if ((tmp_bbt[j] & 0x8000)) {
						tmp_status[i] =
							NAND_BLOCK_FACTORY_BAD;
						aml_nand_dbg("s[%d][%d]=%d",
							chipnr,
							i,
							tmp_status[i]);
					} else {
						if (i == 0)
							tmp_status[i] = NAND_BLOCK_GOOD;
						else{
							tmp_status[i] = NAND_BLOCK_USED_BAD;
							aml_nand_dbg("s[%d][%d]=%d",
								chipnr,
								i,
								tmp_status[i]);
						}
					}
					break;
				}
			}
		}
	}

#if 0
	aml_nand_dbg("show the block status ");
	u16 *tmp_arr;
	int start_block;
	for (chipnr = 0; chipnr < controller->chip_num; chipnr++) {
		tmp_arr = &aml_chip->block_status->blk_status[chipnr][0];
		for (start_block = 0; start_block < 50; start_block++)
			aml_nand_msg(" tmp_arr[%d][%d]=%d",
				chipnr,
				start_block,
				tmp_arr[start_block]);
	}
#endif

	return ret;
}

#ifdef AML_NAND_UBOOT
static int confirm_dev_para(struct dev_para*dev_para_cmp,struct amlnf_partition *config_init,int dev_flag)
{
	int ret =0, j=0,partiton_num=0;
	struct amlnf_partition *partition = NULL;
	struct amlnf_partition * partition_ptr =NULL;

	for (j = 0; j < MAX_NAND_PART_NUM; j++) {
		partition = &(config_init[j]);
		partition_ptr =& (dev_para_cmp->partitions[partiton_num]);
		if (partition->mask_flags == dev_flag) {
			if (memcmp(partition_ptr->name, partition->name, strlen(partition->name))) {
				aml_nand_msg("nand partition table changed: partition->name: from %s  to %s",partition_ptr->name,partition->name);
				ret = -1;
				break;
			}
			if (partition->size != partition_ptr->size) {
				aml_nand_msg("nand partition table changed:  %s partition->size: from %llx	to %llx",partition->name,partition_ptr->size,partition->size);
				ret = -1;
				break;
			}
			if (partition_ptr->mask_flags != dev_flag) {
				aml_nand_msg("nand partition table %s : mask_flag changed from %d to %d",partition->name,partition_ptr->mask_flags,partition->mask_flags);
				ret = -1;
				break;
			}
			partiton_num ++;
		}else if(partition == NULL){
			break;
		}
	}

	if (dev_para_cmp->nr_partitions != partiton_num) {
		aml_nand_msg("nand dev %s : nr_partitions num changed from %d to %d",dev_para_cmp->name,dev_para_cmp->nr_partitions,partiton_num);
		ret = -1;
	}

	return ret ;
}

static void init_dev_para(struct dev_para*dev_para_ptr,struct amlnf_partition *config_init, int dev_flag)
{
	int j=0,partiton_num=0;
	struct amlnf_partition *partition = NULL;
	struct amlnf_partition * partition_ptr =NULL;

	for (j = 0; j < MAX_NAND_PART_NUM; j++) {
		//printf("%s, j = %d\n", __func__, j);
		partition = &(config_init[j]);
		partition_ptr =& (dev_para_ptr->partitions[partiton_num]);
		if (partition->mask_flags == dev_flag) {
			memcpy(partition_ptr->name, partition->name, strlen( partition->name));
			partition_ptr->size = partition->size;
			partition_ptr->mask_flags = partition->mask_flags;
			partiton_num ++;
			aml_nand_dbg("init_dev_para : partition->name %s ", partition->name);
			aml_nand_dbg("init_dev_para : partition->size %llx", partition->size);
			aml_nand_dbg("init_dev_para : partition->mask_flags %d", partition->mask_flags);
		}else if(partition == NULL){
			break;
		}
	}
	dev_para_ptr->nr_partitions = partiton_num;
	aml_nand_msg("partition-> partiton_num %d",partiton_num);

	return;
}
static void amlnand_get_dev_num(struct amlnand_chip *aml_chip,struct amlnf_partition *config_init)
{
	struct dev_para *dev_para_ptr =NULL;
	int i , tmp_num=0;
	int device_num;

	device_num = (aml_chip->h_cache_dev)? 3 : 2;

	if (boot_device_flag == 1) {
		memcpy((void *)(aml_chip->config_ptr->dev_para[tmp_num].name),
			NAND_BOOT_NAME, strlen(NAND_BOOT_NAME));
		aml_chip->config_ptr->dev_para[tmp_num].nr_partitions = 0;
		aml_chip->config_ptr->dev_para[tmp_num].option = 0;
		tmp_num++;
		device_num += 1;
	}
	aml_chip->config_ptr->dev_num = device_num;

	for (i=0; tmp_num < device_num; tmp_num++, i++) {
		int dev_flag;
		u32 option;
		dev_para_ptr = &(aml_chip->config_ptr->dev_para[tmp_num]);
		if (i == 0) {
			if (aml_chip->h_cache_dev) {
				memcpy((void *)(dev_para_ptr->name),
					NAND_CACHE_NAME,
					strlen(NAND_CACHE_NAME));
				dev_flag = STORE_CACHE;
				option = NAND_DATA_OPTION;
			} else {
				memcpy((void *)(dev_para_ptr->name),
					NAND_CODE_NAME,
					strlen(NAND_CODE_NAME));
				dev_flag = STORE_CODE;
				option = NAND_CODE_OPTION;
			}
			init_dev_para(dev_para_ptr, config_init, dev_flag);
			dev_para_ptr->option = option;
		} else if (i == 1) {
			if (aml_chip->h_cache_dev) {
				memcpy((void *)(dev_para_ptr->name),
					NAND_CODE_NAME,
					strlen(NAND_CODE_NAME));
				dev_flag = STORE_CODE;
				option = NAND_CODE_OPTION;
			} else {
				memcpy((void *)(dev_para_ptr->name),
					NAND_DATA_NAME,
					strlen(NAND_DATA_NAME));
				dev_flag = STORE_DATA;
				option = NAND_DATA_OPTION;
			}
			init_dev_para(dev_para_ptr, config_init, dev_flag);
			dev_para_ptr->option = option;
		} else if (i == 2) {
			if (aml_chip->h_cache_dev) {
				memcpy((void *)(dev_para_ptr->name),
					NAND_DATA_NAME,
					strlen(NAND_DATA_NAME));
				dev_flag = STORE_DATA;
				option = NAND_DATA_OPTION;
				init_dev_para(dev_para_ptr,
					config_init, dev_flag);
				dev_para_ptr->option = option;
			}
		} else {
			aml_nand_msg("%s:something wrong here",
				__func__);
			break;
		}
	}
	return ;
}

int amlnand_configs_confirm(struct amlnand_chip *aml_chip)
{
	//nand_arg_info * config_msg = &aml_chip->config_msg;
#ifdef AML_NAND_UBOOT
	struct amlnf_partition * configs_init =  (struct amlnf_partition *) amlnand_config;
#endif
	struct nand_config * config_ptr = aml_chip->config_ptr;

	struct dev_para *dev_para_cmp = NULL;
	unsigned char  confirm_flag=0;
	int i, tmp_num=0,ret = 0;
	int device_num;

	ENV_NAND_LINE

	device_num = (aml_chip->h_cache_dev)? 3 : 2;

	ret = phrase_driver_version(config_ptr->driver_version,DRV_PHY_VERSION);
	if (ret) {
		aml_nand_msg("driver_version in nand  %d.%02d.%03d.%04d ",
			(config_ptr->driver_version >> 24)&0xff,
			(config_ptr->driver_version >> 16)&0xff,
			(config_ptr->driver_version >> 8)&0xff,
			(config_ptr->driver_version)&0xff);
		/*confirm_flag = 1;*/
	}
	ENV_NAND_LINE

	if (boot_device_flag == 1) {
		tmp_num++;
		device_num += 1;
	}
	ENV_NAND_LINE
	//check device num
	if (device_num != config_ptr->dev_num) {
		//aml_nand_msg("nand device num changed from %d to %d %s", config_ptr->dev_num,device_num);
		aml_nand_msg("nand device num changed from %d to %d", config_ptr->dev_num,device_num);
		confirm_flag = 1;
	}
	ENV_NAND_LINE
	for (i=0; tmp_num < device_num; tmp_num++, i++) {
		ENV_NAND_LINE
		dev_para_cmp = &(aml_chip->config_ptr->dev_para[tmp_num]);
		if (i == 0) {
			if (aml_chip->h_cache_dev)
				ret = confirm_dev_para(dev_para_cmp,
					configs_init, STORE_CACHE);
			else
				ret = confirm_dev_para(dev_para_cmp,
					configs_init, STORE_CODE);
			if (ret) {
				confirm_flag = 1;
				break;
			}
		} else if (i == 1) {
			if (aml_chip->h_cache_dev)
				ret = confirm_dev_para(dev_para_cmp,
					configs_init, STORE_CODE);
			else
				ret = confirm_dev_para(dev_para_cmp,
					configs_init, STORE_DATA);
			if (ret) {
				confirm_flag = 1;
				break;
			}
		} else if (i == 2) {
			if (aml_chip->h_cache_dev) {
				ret = confirm_dev_para(dev_para_cmp,
					configs_init, STORE_DATA);
				if (ret) {
					confirm_flag = 1;
					break;
				}
			} else {
				aml_nand_msg("%s %d: something wrong here!!",
					__func__, __LINE__);
				confirm_flag = 1;
				break;
			}
		} else {
			aml_nand_msg("%s %d: something wrong here!!",
					__func__, __LINE__);
			confirm_flag = 1;
			break;
		}
	}

	ENV_NAND_LINE
	if (confirm_flag == 0) {
		aml_nand_dbg("nand configs confirm all right");
		aml_chip->shipped_bbtinfo.valid_blk_addr = config_ptr->fbbt_blk_addr;
		for (i=0; i<RESERVED_BLOCK_CNT; i++) {
			if (aml_chip->reserved_blk[i] == 0xff) {
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
	ENV_NAND_LINE
	return ret;

//exit_error0:
	//return ret;
}
#endif /* AML_NAND_UBOOT */


int aml_nand_save_hynix_info(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	struct read_retry_info *retry_info = &(controller->retry_info);
	struct en_slc_info *slc_info = &(controller->slc_info);

	u8 phys_erase_shift, phys_page_shift;
	u16  blk_addr = 0,  tmp_blk,  nand_boot;
	u32 i, j, offset,  pages_per_blk, pages_read;
	u8 oob_buf[8];
	int ret = 0;
	u32 tmp_addr;
	int test_cnt = 0;
	u8 tmp_rand;
	u32 tmp_value;

#ifdef DEBUG_HYINX_DEF
	int save_cnt = 20;
	if (retry_info->retry_cnt_lp > 20)
		save_cnt = retry_info->retry_cnt_lp;
#endif
	if ((flash->new_type == 0) || (flash->new_type > 10))
		return NAND_SUCCESS;

	aml_nand_dbg("aml_nand_save_hynix_info : here!! ");

	nand_boot = 1;

	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else
		offset = 0;

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));
	tmp_blk = (offset >> phys_erase_shift);

	if ((flash->new_type) && (flash->new_type < 10))
		ops_para->option |= DEV_SLC_MODE;

	if (ops_para->option & DEV_SLC_MODE)
		pages_read = pages_per_blk >> 1;
	else
		pages_read = pages_per_blk;

	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	memcpy(oob_buf, HYNIX_DEV_HEAD_MAGIC, strlen(HYNIX_DEV_HEAD_MAGIC));

get_free_blk:
	ret = amlnand_get_free_block(aml_chip, blk_addr);
	blk_addr = ret;
	if (ret < 0) {
		aml_nand_msg("nand get free block failed");
		ret = -NAND_BAD_BLCOK_FAILURE;
		goto exit_error0;
	}
	aml_nand_dbg("nand get free block for hynix readretry info at %d",
		blk_addr);

	for (i = 0; i < pages_read; i++) {
		memset((u8 *)ops_para, 0x0,
			sizeof(struct chip_ops_para));
		if ((flash->new_type) && (flash->new_type < 10))
			ops_para->option |= DEV_SLC_MODE;
		tmp_value = blk_addr;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = i + (tmp_value * pages_per_blk);
		ops_para->chipnr = blk_addr % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		if ((ops_para->option & DEV_SLC_MODE)
			&& ((flash->new_type > 0)
			&& (flash->new_type < 10))) {
			tmp_value = ops_para->page_addr;
			tmp_value &= (~(pages_per_blk - 1));
			ops_para->page_addr = tmp_value |
				(slc_info->pagelist[ops_para->page_addr % 256]);
		}

		ops_para->data_buf = aml_chip->user_page_buf;
		ops_para->oob_buf = aml_chip->user_oob_buf;
		ops_para->ooblen = sizeof(oob_buf);

		if (flash->new_type == HYNIX_1YNM) {
			if ((i > 1) && ((i%2) == 0)) {
				tmp_addr =	ops_para->page_addr;
				tmp_rand = controller->ran_mode;
				ops_para->page_addr -= 1;
				controller->ran_mode = 0;
				ops_para->option |= DEV_ECC_SOFT_MODE;
				ops_para->option &= DEV_SERIAL_CHIP_MODE;
				memset(aml_chip->user_page_buf, 0xff,
					flash->pagesize);
				#ifdef AML_NAND_UBOOT

				nand_get_chip(aml_chip);
				#else
				if (aml_chip->state == CHIP_READY)
					nand_get_chip(aml_chip);
				#endif
				ret = operation->write_page(aml_chip);
				#ifdef AML_NAND_UBOOT
				nand_release_chip(aml_chip);
				#else
				if (aml_chip->state == CHIP_READY)
					nand_release_chip(aml_chip);
				#endif
				ops_para->page_addr = tmp_addr;
				controller->ran_mode = tmp_rand;
				ops_para->option &= DEV_ECC_HW_MODE;
				ops_para->option |=DEV_SLC_MODE;
			}
		}
		memset(aml_chip->user_page_buf, 0x0, flash->pagesize);
		memset(aml_chip->user_oob_buf, 0x0, sizeof(oob_buf));
		memcpy((u8 *)aml_chip->user_page_buf,
			&retry_info->reg_def_val[0][0],
			MAX_CHIP_NUM*READ_RETRY_REG_NUM);
		memcpy(aml_chip->user_oob_buf, (u8 *)oob_buf, 4);

#ifdef DEBUG_HYINX_DEF
		for (k = 0; k < controller->chip_num; k++)
			for (j = 0; j < save_cnt; j++)
				memcpy((u8 *)(aml_chip->user_page_buf +
					MAX_CHIP_NUM*READ_RETRY_REG_NUM +
					j*READ_RETRY_REG_NUM+k*READ_RETRY_CNT),
					&retry_info->reg_offs_val_lp[k][j][0],
					READ_RETRY_REG_NUM);
#else
		memcpy((u8 *)(aml_chip->user_page_buf +
			MAX_CHIP_NUM*READ_RETRY_REG_NUM),
			&retry_info->reg_offs_val_lp[0][0][0],
			MAX_CHIP_NUM*READ_RETRY_CNT*READ_RETRY_REG_NUM);
#endif
#ifdef AML_NAND_UBOOT
		nand_get_chip(aml_chip);
#else
		if (aml_chip->state == CHIP_READY)
			nand_get_chip(aml_chip);
#endif
		ret = operation->write_page(aml_chip);
#ifdef AML_NAND_UBOOT
		nand_release_chip(aml_chip);
#else
	if (aml_chip->state == CHIP_READY)
		nand_release_chip(aml_chip);
#endif
		if (ret < 0) {
			aml_nand_msg("%s:nand write failed", __func__);
			if (test_cnt >= 3) {
				aml_nand_msg("test blk 3times,");
				break;
			}
			ret = operation->test_block_reserved(aml_chip,
				blk_addr);
			test_cnt++;
			if (ret) {
				ret = operation->block_markbad(aml_chip);
				if (ret < 0)
					aml_nand_dbg("mark badblk failed %d",
						blk_addr);
			}
			goto get_free_blk;
		}
	}

	if (ret < 0) {
		aml_nand_msg("hynix nand save readretry info failed");
		goto exit_error0;
	} else {
		for (j = 0; j < RESERVED_BLOCK_CNT; j++) {
			if (aml_chip->reserved_blk[j] == 0xff) {
				aml_chip->reserved_blk[j] = blk_addr;
				break;
			}
		}
		retry_info->info_save_blk = blk_addr;
		aml_nand_dbg("save hynix readretry info success at blk %d",
			blk_addr);
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

	u8 phys_erase_shift, phys_page_shift;
	u16 start_blk, tmp_blk, total_blk, nand_boot;
	u32 i, j, k, n, offset,  pages_per_blk, pages_read;
	u8 oob_buf[8];
	int nand_type, ret = 0;
	u32 tmp_value, index;

#ifdef DEBUG_HYINX_DEF
	int save_cnt = 20;
	if (retry_info->retry_cnt_lp > 20)
		save_cnt = retry_info->retry_cnt_lp;
#endif
	if ((flash->new_type == 0) || (flash->new_type > 10))
		return NAND_SUCCESS;

	nand_boot = 1;

	/*if(boot_device_flag == 0){
		nand_boot = 0;
	}*/

	if (nand_boot)
		offset = (1024 * flash->pagesize);
	else
		offset = 0;

	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	if ((flash->new_type) && (flash->new_type < 10))
		ops_para->option |= DEV_SLC_MODE;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));

	if (ops_para->option & DEV_SLC_MODE)
		pages_read = pages_per_blk >> 1;
	else
		pages_read = pages_per_blk;

	retry_info->default_flag = 0;
	retry_info->flag = 0;

	start_blk = (int)(offset >> phys_erase_shift);
	tmp_blk = start_blk;
	total_blk = (offset >> phys_erase_shift)+RESERVED_BLOCK_CNT;

	do {
		memset((u8 *)ops_para, 0x0,
			sizeof(struct chip_ops_para));
		tmp_value = start_blk;
		tmp_value /= controller->chip_num;
		tmp_value += tmp_blk - tmp_blk/controller->chip_num;
		ops_para->page_addr = tmp_value * pages_per_blk;
		ops_para->chipnr = start_blk % controller->chip_num;
		controller->select_chip(controller, ops_para->chipnr);

		nand_type = flash->new_type;
		flash->new_type = 0;
		ret = operation->block_isbad(aml_chip);
		flash->new_type = nand_type;
		if (ret == NAND_BLOCK_FACTORY_BAD) {
			aml_nand_msg("blk %d is bad ", start_blk);
			continue;
		}

		for (i = 0; i < pages_read; i++) {
			memset((u8 *)ops_para, 0x0,
				sizeof(struct chip_ops_para));

			if ((flash->new_type) && (flash->new_type < 10))
				ops_para->option |= DEV_SLC_MODE;

			ops_para->data_buf = aml_chip->user_page_buf;
			ops_para->oob_buf = aml_chip->user_oob_buf;
			ops_para->ooblen = sizeof(oob_buf);

			ops_para->page_addr = (i + tmp_value * pages_per_blk);
			if ((ops_para->option & DEV_SLC_MODE)
				&& ((flash->new_type > 0)
				&& (flash->new_type < 10))) {
				index = ops_para->page_addr;
				index &= (~(pages_per_blk - 1));
				ops_para->page_addr = index |
				(slc_info->pagelist[ops_para->page_addr % 256]);
			}
			ops_para->chipnr = start_blk % controller->chip_num;
			controller->select_chip(controller, ops_para->chipnr);

			memset((u8 *)ops_para->data_buf, 0x0,
				flash->pagesize);
			memset((u8 *)ops_para->oob_buf, 0x0,
				sizeof(oob_buf));

			nand_type = flash->new_type;
			flash->new_type = 0;
#ifdef AML_NAND_UBOOT
			nand_get_chip(aml_chip);
#else
			if (aml_chip->state == CHIP_READY)
				nand_get_chip(aml_chip);
#endif
			ret = operation->read_page(aml_chip);
#ifdef AML_NAND_UBOOT
			nand_release_chip(aml_chip);
#else
			if (aml_chip->state == CHIP_READY)
			nand_release_chip(aml_chip);
#endif
			flash->new_type = nand_type;
			if ((ops_para->ecc_err) || (ret < 0)) {
				aml_nand_msg("blk check good but read failed ");
				aml_nand_msg("chip %d page %d",
					ops_para->chipnr,
					ops_para->page_addr);
				continue;
			}

			memcpy(oob_buf, aml_chip->user_oob_buf,
				sizeof(oob_buf));
			if (!memcmp(oob_buf,
				HYNIX_DEV_HEAD_MAGIC,
				strlen(HYNIX_DEV_HEAD_MAGIC))) {
				memcpy(&retry_info->reg_def_val[0][0],
					(u8 *)aml_chip->user_page_buf,
					MAX_CHIP_NUM*READ_RETRY_REG_NUM);
				aml_nand_msg("get def value at blk:%d,page:%d",
					start_blk,
					ops_para->page_addr);

		for (k = 0; k < controller->chip_num; k++)
			for (j = 0; j < retry_info->reg_cnt_lp;
				j++)
				aml_nand_dbg("REG(0x%x):val:0x%x,for chip%d",
				retry_info->reg_addr_lp[j],
			retry_info->reg_def_val[k][j], k);

	if ((flash->new_type == HYNIX_20NM_8GB)
		|| (flash->new_type == HYNIX_20NM_4GB)
		|| (flash->new_type == HYNIX_1YNM)) {
#ifdef DEBUG_HYINX_DEF
		for (n = 0; n < controller->chip_num; n++)
			for (j = 0; j < save_cnt; j++)
				memcpy(&retry_info->reg_offs_val_lp[n][j][0],
					(u8 *)(aml_chip->user_page_buf +
					MAX_CHIP_NUM*READ_RETRY_REG_NUM +
					j*READ_RETRY_REG_NUM+n*save_cnt),
					READ_RETRY_REG_NUM);
#else
		memcpy(&retry_info->reg_offs_val_lp[0][0][0],
			(u8 *)(aml_chip->user_page_buf +
			MAX_CHIP_NUM*READ_RETRY_REG_NUM),
			MAX_CHIP_NUM*READ_RETRY_CNT*READ_RETRY_REG_NUM);
#endif
				}
for (n = 0; n < controller->chip_num; n++)
	for (j = 0; j < retry_info->retry_cnt_lp; j++)
		for (k = 0; k < retry_info->reg_cnt_lp; k++)
			aml_nand_dbg("Retry%dst,REG(0x%x):val:0x%2x,for chip%d",
				k,
				retry_info->reg_addr_lp[k],
			retry_info->reg_offs_val_lp[n][j][k],
			n);

				retry_info->default_flag = 1;
				retry_info->flag = 1;
				break;
			} else {
				aml_nand_dbg("read OK but magic is not hynix");
				break;
			}
		}

		if (retry_info->default_flag && flash->new_type)
			break;
	} while ((++start_blk) < total_blk);

	if (retry_info->default_flag && flash->new_type) {
		retry_info->info_save_blk = start_blk;
		for (i = 0; i < RESERVED_BLOCK_CNT; i++) {
			if (aml_chip->reserved_blk[i] == 0xff) {
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
	int  chipnr, offset, offset_tmp, read_cnt, page_addr, col0_data = 0, col_data_sandisk[6],  col0_oob = 0xff;
	unsigned char phys_erase_shift, phys_page_shift;
	int i, ret = 0, factory_badblock_cnt;
	uint64_t  tmp_blk;
	aml_nand_dbg("here!! ");

	nand_boot = 1;
	if (boot_device_flag == 0) {
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
		nand_get_chip(aml_chip);
#else
		nand_get_chip(aml_chip);
#endif

	for (chipnr=0; chipnr < controller->chip_num; chipnr++) {
		aml_nand_dbg("chipnr=%d",chipnr);
		factory_badblock_cnt = 0;
		tmp_arr = &aml_chip->shipped_bbt_ptr->shipped_bbt[chipnr][0];
		controller->select_chip(controller, chipnr);
		for (start_block=start_blk; start_block < total_block; start_block++) {
		//for(start_block = 0; start_block < total_block; start_block++){
			if (((start_block ==  ((aml_chip->nand_key.valid_blk_addr +(controller->chip_num -1)*4)/controller->chip_num)) && (aml_chip->nand_key.arg_valid))
				||((start_block ==  ((aml_chip->nand_secure.valid_blk_addr +(controller->chip_num -1)*4)/controller->chip_num))&&(aml_chip->nand_secure.arg_valid))){
				aml_nand_msg("shipped_badblock_detect skip block %d,chipnr %d",start_block,chipnr);
				continue;
			}
			offset = pages_per_blk*start_block;
			for (read_cnt=0; read_cnt<2; read_cnt++) {

				if ((controller->mfr_type  == NAND_MFR_SANDISK ))
					page_addr = offset + read_cnt; // page0 page1
				else
					page_addr = offset + read_cnt*(pages_per_blk-1); // page_num

				if (unlikely(page_addr >= controller->internal_page_nums)) {
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

				NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);

				ret = controller->quene_rb(controller, chipnr);
				if (ret) {
					aml_nand_msg("quene rb busy here");
					ret = -NAND_BUSY_FAILURE;
					goto error_exit0;
				}

				 if (controller->option & NAND_CTRL_NONE_RB) {
					controller->cmd_ctrl(controller, NAND_CMD_READ0, NAND_CTRL_CLE);
					NFC_SEND_CMD_IDLE(controller, NAND_TWB_TIME_CYCLE);
				}

				if ((controller->mfr_type  == NAND_MFR_SANDISK )) {
					for (i = 0; i < 6; i++) {
						col_data_sandisk[i] = controller->readbyte(controller);
						if (col_data_sandisk[i] == 0x0) {
							col0_oob = 0x0;
							break;
						}
					}
				}else	{
					col0_data = controller->readbyte(controller);
					//TRHW
					NFC_SEND_CMD_IDLE(controller, NAND_TRHW_TIME_CYCLE);

					controller->cmd_ctrl(controller, NAND_CMD_RNDOUT, NAND_CTRL_CLE);
					controller->cmd_ctrl(controller, flash->pagesize, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, flash->pagesize>>8, NAND_CTRL_ALE);
					controller->cmd_ctrl(controller, NAND_CMD_RNDOUTSTART, NAND_CTRL_CLE);
					//TCCS
					NFC_SEND_CMD_IDLE(controller, NAND_TCCS_TIME_CYCLE);

					col0_oob = controller->readbyte(controller);
				}

				if (((controller->mfr_type == NAND_MFR_SAMSUNG ) && ((col0_oob != 0xFF) || (col0_data != 0xFF))) \
					|| ((controller->mfr_type == NAND_MFR_TOSHIBA ) && ((col0_oob != 0xFF) || (col0_data != 0xFF))) \
					||((controller->mfr_type  == NAND_MFR_MICRON ) && (col0_oob == 0x0)) \
					||((controller->mfr_type  == NAND_MFR_HYNIX ) && (col0_oob != 0xFF)) \
					||((controller->mfr_type  == NAND_MFR_SANDISK ) && (col0_oob != 0xFF))){

					col0_oob = 0xff;
					aml_nand_msg("mfr_type:%x detect factory Bad block at read_cnt:%d and block:%d and chip:%d", \
											controller->mfr_type, read_cnt, start_block, chipnr);
					tmp_arr[factory_badblock_cnt] = start_block |0x8000;
					//aml_nand_msg("start_block is bad block = %d, tmp_arr[factory_badblock_cnt] = %d",
						//start_block, tmp_arr[factory_badblock_cnt]);

					if (start_block < start_blk) {
						aml_nand_msg("WARNING: UBOOT AREA  BLOCK %d IS BAD BLOCK",start_block);
					}

					if ((controller->flash_type == NAND_TYPE_MLC) && (flash->option & NAND_MULTI_PLANE_MODE)) {
						if ((start_block % 2) == 0 ) {		// if  plane 0 is bad block,just set plane 1 to bad
							start_block+=1;
							tmp_arr[++factory_badblock_cnt] = start_block |0x8000;
							//aml_nand_msg(" plane 0 is bad block,just set plane 1 to bad:");
						}else{					// if plane 1 is bad block, just set plane 0 to bad
							tmp_arr[++factory_badblock_cnt]= (start_block -1) |0x8000;
							//aml_nand_msg(" plane 1 is bad block,just set plane 0 to bad:");
						}
					}

					//bad block should less than 6% of total blocks
					if ((factory_badblock_cnt++ >= (total_block/2))) {
						aml_nand_msg("detect factory bad block over 50%%, hardware problem and factory_badblock_cnt:%d, total_block:%d, chipnr:%d !!!", \
												factory_badblock_cnt, total_block, chipnr);
						if (aml_chip->shipped_retry_flag) {
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
	for (chipnr= 0; chipnr < controller->chip_num; chipnr++) {
		tmp_arr = &aml_chip->shipped_bbt_ptr->shipped_bbt[chipnr][0];
			for (start_block=0; start_block < 200; start_block++) {
				aml_nand_msg(" tmp_arr[%d][%d]=%d", chipnr, start_block, tmp_arr[start_block]);
			}
	}
#endif

#ifdef AML_NAND_UBOOT
		nand_release_chip(aml_chip);
#else
		nand_release_chip(aml_chip);
#endif

	return ret;

error_exit0:
#ifdef AML_NAND_UBOOT
		nand_release_chip(aml_chip);
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
	if (aml_chip->phy_part_ptr) {
		kfree(aml_chip->phy_part_ptr);
		aml_chip->phy_part_ptr = NULL;
	}
	if (aml_chip->user_oob_buf) {
		kfree(aml_chip->user_oob_buf);
		aml_chip->user_oob_buf = NULL;
	}
	if (aml_chip->user_page_buf) {
		kfree(aml_chip->user_page_buf);
		aml_chip->user_page_buf = NULL;
	}
	if (amlnand_config) {
		kfree(amlnand_config);
		amlnand_config = NULL;
	}
}

static int amlnand_config_buf_malloc(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	/* struct chip_operation *operation = & aml_chip->operation; */
	/* struct chip_ops_para  *ops_para = & aml_chip->ops_para; */
	u32 ret = 0, buf_size;

	buf_size = flash->oobsize * controller->chip_num;
	if (flash->option & NAND_MULTI_PLANE_MODE)
		buf_size <<= 1;
	if (aml_chip->user_oob_buf == NULL) {
		aml_chip->user_oob_buf = aml_nand_malloc(buf_size);
		if (aml_chip->user_oob_buf == NULL) {
			aml_nand_msg("malloc failed for user_oob_buf ");
			ret = -NAND_MALLOC_FAILURE;
			goto exit_error0;
		}
	}
	memset(aml_chip->user_oob_buf, 0x0, buf_size);
	buf_size = (flash->pagesize + flash->oobsize) * controller->chip_num;
	if (flash->option & NAND_MULTI_PLANE_MODE)
		buf_size <<= 1;

	if (aml_chip->user_page_buf == NULL) {
		aml_chip->user_page_buf = aml_nand_malloc(buf_size);
		if (aml_chip->user_page_buf == NULL) {
			aml_nand_msg("malloc failed for user_page_buf ");
			ret = -NAND_MALLOC_FAILURE;
			goto exit_error0;
		}
	}
	memset(aml_chip->user_page_buf, 0x0, buf_size);

	/* using to record each block status.*/
	if (aml_chip->block_status == NULL) {
		aml_chip->block_status =
		(struct block_status *)aml_nand_malloc(sizeof(struct block_status));
		if (aml_chip->block_status == NULL) {
			aml_nand_msg("malloc failed for block_status and size:%x",
				(u32)sizeof(struct block_status));
			ret = -NAND_MALLOC_FAILURE;
			goto exit_error0;
		}
	}
	memset(aml_chip->block_status, 0x0, (sizeof(struct block_status)));
	if (aml_chip->shipped_bbt_ptr == NULL) {
		aml_chip->shipped_bbt_ptr = aml_nand_malloc(sizeof(struct shipped_bbt));
		if (aml_chip->shipped_bbt_ptr == NULL) {
			aml_nand_msg("malloc failed for shipped_bbt_ptr ");
			ret = -NAND_MALLOC_FAILURE;
			goto exit_error0;
		}
	}
	memset(aml_chip->shipped_bbt_ptr, 0x0, (sizeof(struct shipped_bbt)));

	if (aml_chip->config_ptr == NULL) {
		aml_chip->config_ptr = aml_nand_malloc(sizeof(struct nand_config));
		if (aml_chip->config_ptr == NULL) {
			aml_nand_msg("malloc failed for config_ptr ");
			ret = -NAND_MALLOC_FAILURE;
			goto exit_error0;
		}
	}
	memset(aml_chip->config_ptr, 0x0, (sizeof(struct nand_config)));

	aml_chip->phy_part_ptr =
		aml_nand_malloc(sizeof(struct phy_partition_info));
	if (aml_chip->phy_part_ptr == NULL) {
		aml_nand_msg("malloc failed for phy_part_ptr ");
		ret = -NAND_MALLOC_FAILURE;
		goto exit_error0;
	}
	memset(aml_chip->phy_part_ptr,
		0x0,
		(sizeof(struct phy_partition_info)));

	return ret;

exit_error0:
	amlnand_config_buf_free(aml_chip);
	return ret ;
}

/*
 * set attribute of each configs.
 * FULL_BLK: write the whole block once.
 * FULL_PAGE: write full pages once.
 */
void amlnand_set_config_attribute(struct amlnand_chip *aml_chip)
{
	aml_chip->nand_bbtinfo.arg_type = FULL_BLK;
	aml_chip->shipped_bbtinfo.arg_type = FULL_BLK;
	aml_chip->config_msg.arg_type = FULL_BLK;
	aml_chip->nand_secure.arg_type = FULL_PAGE;
	aml_chip->nand_key.arg_type = FULL_PAGE;
	aml_chip->uboot_env.arg_type = FULL_PAGE;
	aml_chip->nand_phy_partition.arg_type = FULL_PAGE;
#if (AML_CFG_DTB_RSV_EN)
	aml_chip->amlnf_dtb.arg_type = FULL_PAGE;
#endif
	return;
}

/*
 bbt is valid.
 */
int  bbt_valid_ops(struct amlnand_chip *aml_chip)
{
	int  ret = 0;
	ENV_NAND_LINE;

	PRINT("%s\n", __func__);
	ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->config_msg),(unsigned char *)(aml_chip->config_ptr),(unsigned char *)CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
	if (ret < 0) {
		aml_nand_msg("nand scan config failed and ret:%d",ret);
		goto exit_error0;
	}
	ENV_NAND_LINE

	ret = aml_sys_info_init(aml_chip); //key  and stoarge and env
	if (ret < 0) {
		aml_nand_msg("nand init sys_info failed and ret:%d", ret);
		goto exit_error0;
	}

	if (aml_chip->detect_dtb_flag) {
		ret = -NAND_DETECT_DTB_FAILED;
		aml_nand_msg("%s()%d:Now we must stop init !!!",__func__, __LINE__);
		goto exit_error0;
	}
	ENV_NAND_LINE
#ifdef AML_NAND_UBOOT
	if (aml_chip->config_msg.arg_valid == 1) {
		ENV_NAND_LINE
		ret = amlnand_configs_confirm(aml_chip);
		ENV_NAND_LINE
		if (ret < 0) {
			if ((aml_chip->init_flag > NAND_BOOT_UPGRATE) && (aml_chip->init_flag < NAND_BOOT_SCRUB_ALL)) {
				ret =0;
			} else {
				aml_nand_msg("nand configs confirm failed");
				ret = -NAND_CONFIGS_FAILED;
				goto exit_error0;
			}
		}
	} else {
		ENV_NAND_LINE
		// do nothing....
		aml_nand_msg("%s: do nothing!", __func__);
	}
#endif
	ENV_NAND_LINE
exit_error0:
	return ret;
}

int  shipped_bbt_invalid_ops(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	uint64_t chipsize;
	unsigned char *buf = NULL;
	int ret = 0, pre_erase = 0;

/*
	clean nand case!!!!!
*/
#if 1 //clean nand case
	/* need erase */
	if (aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE) {
		/*
		sandisk flash can't promise all the blocks are clean and
		need to be erased at the first time using.
		need be sure that factory bad block can't be erased.
		*/
		if (flash->id[0] == NAND_MFR_SANDISK) {
			/*
			set info_disprotect variant wich DISPROTECT_FBBT
			to skip env_protect erea.
			*/
			info_disprotect |= DISPROTECT_FBBT;
			amlnf_get_chip_size(&chipsize);
			/*background for carring out, bbt table is all zero*/
			/*make all blocks are erased*/
			amlnf_erase_ops(0, chipsize, 1);
			pre_erase = 1;
		}

		/*check factory bad block by reading bad flags.*/
		ret = shipped_badblock_detect(aml_chip);
		if (ret < 0 ) {
		 aml_nand_msg("nand detect factory bbt failed and ret:%d", ret);
		 goto exit_error0;
		}
		/* fill block status according to shipped bad block. */
		ret = amlnand_init_block_status(aml_chip);
		if (ret < 0) {
		 aml_nand_msg("nand init block status failed and ret:%d", ret);
		 goto exit_error0;
		}

		aml_chip->nand_bbtinfo.arg_valid =1;//risking?it is need here.

		/* erasing the whole chip then! */
		if (!pre_erase)
			amlnand_oops_handle(aml_chip,aml_chip->init_flag);

		/* save bbt info.*/
		aml_chip->nand_bbtinfo.arg_valid =0;
		aml_chip->block_status->crc = aml_info_checksum((unsigned char *)aml_chip->block_status->blk_status,(MAX_CHIP_NUM*MAX_BLK_NUM));
		ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->nand_bbtinfo),(unsigned char *)aml_chip->block_status,(unsigned char *)BBT_HEAD_MAGIC, sizeof(struct block_status));
		if (ret < 0) {
		 aml_nand_msg("nand save bbt failed and ret:%d", ret);
		 goto exit_error0;
		}
		/* save fbbt info.*/
		aml_chip->shipped_bbt_ptr->crc = aml_info_checksum((unsigned char *)aml_chip->shipped_bbt_ptr->shipped_bbt,(MAX_CHIP_NUM*MAX_BAD_BLK_NUM));
		aml_chip->shipped_bbt_ptr->chipnum = controller->chip_num;
		ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->shipped_bbtinfo),(unsigned char *)aml_chip->shipped_bbt_ptr,(unsigned char *)SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
		if (ret < 0) {
		 aml_nand_msg("nand save shipped bbt failed and ret:%d",ret);
		 goto exit_error0;
		}

	} else {
	/* normal boot or upgrade, no need to erase the whole chip! */
	/* init key info here!*/
		ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->nand_key),buf,(unsigned char *)KEY_INFO_HEAD_MAGIC, aml_chip->keysize);
		if (ret < 0) {
			aml_nand_msg("invalid nand key\n");
			goto exit_error0;
		}
#ifdef CONFIG_SECURE_NAND
		ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->nand_secure),buf,(unsigned char *)SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
		if (ret < 0) {
			aml_nand_msg("invalid nand secure_ptr\n");
			goto exit_error0;
		}
#endif

		ret = shipped_badblock_detect(aml_chip);
		if (ret < 0 ) {
			aml_nand_msg("%s() %d: nand detect factory bbt failed and ret:%d", __FUNCTION__, __LINE__, ret);
			goto exit_error0;
		}

		ret = amlnand_init_block_status(aml_chip);
		if (ret < 0) {
		 aml_nand_msg("%s() %d: nand init block status failed and ret:%d", __FUNCTION__, __LINE__, ret);
		 goto exit_error0;
		}

		ret = aml_sys_info_init(aml_chip); //key  and  stoarge
		if (ret < 0) {
			aml_nand_msg("%s() %d: nand init sys_info failed and ret:%d", __FUNCTION__, __LINE__, ret);
			goto exit_error0;
		}

		aml_chip->block_status->crc = aml_info_checksum((unsigned char *)aml_chip->block_status->blk_status,(MAX_CHIP_NUM*MAX_BLK_NUM));/*liang:if bbt is valid, never be here! so do this!*/
		ret = amlnand_save_info_by_name(aml_chip,(unsigned char *)&(aml_chip->nand_bbtinfo),(unsigned char *)aml_chip->block_status,(unsigned char *)BBT_HEAD_MAGIC, sizeof(struct block_status));
		if (ret < 0) {
		 aml_nand_msg("nand save bbt failed and ret:%d", ret);
		 goto exit_error0;
		}

		aml_chip->shipped_bbt_ptr->crc = aml_info_checksum((unsigned char *)aml_chip->shipped_bbt_ptr->shipped_bbt,(MAX_CHIP_NUM*MAX_BAD_BLK_NUM));
		aml_chip->shipped_bbt_ptr->chipnum = controller->chip_num;
		ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->shipped_bbtinfo),(unsigned char *)(aml_chip->shipped_bbt_ptr),(unsigned char *)SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
		if (ret < 0) {
		 aml_nand_msg("nand save shipped bbt failed and ret:%d",ret);
		 goto exit_error0;
		}

		if (aml_chip->detect_dtb_flag) {
			ret = -NAND_DETECT_DTB_FAILED;
			aml_nand_msg("%s()%d:Now we must stop init !!!",__func__, __LINE__);
			goto exit_error0;
		}

		//save config
		aml_chip->config_ptr->driver_version = DRV_PHY_VERSION;
		aml_chip->config_ptr->fbbt_blk_addr = aml_chip->shipped_bbtinfo.valid_blk_addr;
		amlnand_get_dev_num(aml_chip,(struct amlnf_partition *)amlnand_config);

		aml_chip->config_ptr->crc = aml_info_checksum((unsigned char *)(aml_chip->config_ptr->dev_para),(MAX_DEVICE_NUM*sizeof(struct dev_para)));
		ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->config_msg),(unsigned char *)(aml_chip->config_ptr),(unsigned char *)CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
		if (ret < 0) {
			aml_nand_msg("save nand dev_configs failed and ret:%d",ret);
			goto exit_error0;
		}
		/*
		liang: it is not need here. is it ??? when uboot run and will check it,if crc error, will overwrite env.
		*/
		if (aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE) {
			aml_chip->uboot_env.update_flag = 1;
			if ((aml_chip->uboot_env.arg_valid == 1) && (aml_chip->uboot_env.update_flag)) {
				aml_nand_update_ubootenv(aml_chip,NULL);
				aml_chip->uboot_env.update_flag = 0;
				aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"ubootenv",aml_chip->uboot_env.arg_valid, aml_chip->uboot_env.valid_blk_addr, aml_chip->uboot_env.valid_page_addr);
			}
		}
	}
#else

	ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->nand_key),buf,(unsigned char *)KEY_INFO_HEAD_MAGIC, aml_chip->keysize);
	if (ret < 0) {
	aml_nand_msg("invalid nand key\n");
	goto exit_error0;
	}

#ifdef CONFIG_SECURE_NAND
	ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->nand_secure),buf,(unsigned char *)SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
	if (ret < 0) {
		aml_nand_msg("invalid nand secure_ptr\n");
		goto exit_error0;
	}
#endif


	if (aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE) {
		amlnand_oops_handle(aml_chip,aml_chip->init_flag);
	}

	ret = shipped_badblock_detect(aml_chip);
	if (ret < 0 ) {
	 aml_nand_msg("nand detect factory bbt failed and ret:%d", ret);
	 goto exit_error0;
	}

	ret = amlnand_init_block_status(aml_chip);
	if (ret < 0) {
	 aml_nand_msg("nand init block status failed and ret:%d", ret);
	 goto exit_error0;
	}

//if((aml_chip->init_flag == NAND_BOOT_ERASE_ALL))
	// amlnand_oops_handle(aml_chip,aml_chip->init_flag);

	ret = aml_sys_info_init(aml_chip); //key  and  stoarge
	if (ret < 0) {
		aml_nand_msg("nand init sys_info failed and ret:%d", ret);
		goto exit_error0;
	}

	   aml_chip->block_status->crc = aml_info_checksum((unsigned char *)(aml_chip->block_status->blk_status),(MAX_CHIP_NUM*MAX_BLK_NUM));
	   ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->nand_bbtinfo),(unsigned char *)(aml_chip->block_status),(unsigned char *)BBT_HEAD_MAGIC, sizeof(struct block_status));
	   if (ret < 0) {
		   aml_nand_msg("nand save bbt failed and ret:%d", ret);
		   goto exit_error0;
	   }

	   aml_chip->shipped_bbt_ptr->crc = aml_info_checksum((unsigned char *)(aml_chip->shipped_bbt_ptr->shipped_bbt),(MAX_CHIP_NUM*MAX_BAD_BLK_NUM));
	   aml_chip->shipped_bbt_ptr->chipnum = controller->chip_num;
	   ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->shipped_bbtinfo),(unsigned char *)(aml_chip->shipped_bbt_ptr),(unsigned char *)SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
	   if (ret < 0) {
		   aml_nand_msg("nand save shipped bbt failed and ret:%d",ret);
		   goto exit_error0;
	   }
	   //save config
	   aml_chip->config_ptr->driver_version = DRV_PHY_VERSION;
	   aml_chip->config_ptr->fbbt_blk_addr = aml_chip->shipped_bbtinfo.valid_blk_addr;
	   amlnand_get_dev_num(aml_chip,(struct amlnf_partition *)amlnand_config);

	   aml_chip->config_ptr->crc = aml_info_checksum((unsigned char *)(aml_chip->config_ptr->dev_para),(MAX_DEVICE_NUM*sizeof(struct dev_para)));
	  ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->config_msg),(unsigned char *)(aml_chip->config_ptr),(unsigned char *)CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
	   if (ret < 0) {
		   aml_nand_msg("save nand dev_configs failed and ret:%d",ret);
		   goto exit_error0;
	   }

	if (aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE) {
		aml_chip->uboot_env.update_flag = 1;
		 if ((aml_chip->uboot_env.arg_valid == 1) && (aml_chip->uboot_env.update_flag)) {
			aml_nand_update_ubootenv(aml_chip,NULL);
			aml_chip->uboot_env.update_flag = 0;
			aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"ubootenv",aml_chip->uboot_env.arg_valid, aml_chip->uboot_env.valid_blk_addr, aml_chip->uboot_env.valid_page_addr);
		}
	}
#endif

exit_error0:
	if (buf) {
		kfree(buf);
		buf = NULL;
	}
	return ret;
}

int shipped_bbt_valid_ops(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	//struct nand_flash *flash = &aml_chip->flash;
	//struct chip_operation *operation = & aml_chip->operation;
	//struct chip_ops_para  *ops_para = & aml_chip->ops_para;
	// nand_arg_info * nand_key = &aml_chip->nand_key;
	//nand_arg_info  * nand_secure= &aml_chip->nand_secure;
	int  ret = 0;
	ENV_NAND_LINE
	if (aml_chip->shipped_bbt_ptr->chipnum != controller->chip_num) {
		aml_nand_msg("nand read chipnum in config %d,controller->chip_num:%d",aml_chip->shipped_bbt_ptr->chipnum,controller->chip_num);
		ret = -NAND_SHIPPED_BADBLOCK_FAILED ;
		goto exit_error0;
	}

	ret = amlnand_init_block_status(aml_chip);
	if (ret < 0 ) {
			aml_nand_msg("nand init blcok status failed and ret:%d", ret);
			goto exit_error0;
	}

	if (aml_chip->init_flag < NAND_BOOT_ERASE_PROTECT_CACHE) {
		ENV_NAND_LINE
		ret = aml_sys_info_init(aml_chip); //key  and  stoarge
		if (ret < 0) {
			aml_nand_msg("nand init sys_info failed and ret:%d", ret);
			goto exit_error0;
		}
		ENV_NAND_LINE
		ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->config_msg),(unsigned char *)(aml_chip->config_ptr),(unsigned char *)CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
		if (ret < 0) {
			aml_nand_msg("nand scan config failed and ret:%d",ret);
			goto exit_error0;
		}
		ENV_NAND_LINE
		aml_chip->block_status->crc = aml_info_checksum((unsigned char *)aml_chip->block_status->blk_status,(MAX_CHIP_NUM*MAX_BLK_NUM));
		ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->nand_bbtinfo),(unsigned char *)(aml_chip->block_status),(unsigned char *)BBT_HEAD_MAGIC, sizeof(struct block_status));
		if (ret < 0) {
			aml_nand_msg("nand save bbt failed and ret:%d", ret);
			goto exit_error0;
		}

		if (aml_chip->detect_dtb_flag) {
			ret = -NAND_DETECT_DTB_FAILED;
			aml_nand_msg("%s()%d:Now we must stop init !!!",__func__, __LINE__);
			goto exit_error0;
		}
		ENV_NAND_LINE
		//save config
		aml_chip->config_ptr->driver_version = DRV_PHY_VERSION;
		aml_chip->config_ptr->fbbt_blk_addr = aml_chip->shipped_bbtinfo.valid_blk_addr;
		amlnand_get_dev_num(aml_chip,(struct amlnf_partition *)amlnand_config);
		ENV_NAND_LINE
		aml_chip->config_ptr->crc = aml_info_checksum((unsigned char *)(aml_chip->config_ptr->dev_para),(MAX_DEVICE_NUM*sizeof(struct dev_para)));
		ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->config_msg),(unsigned char *)(aml_chip->config_ptr),(unsigned char *)CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
		if (ret < 0) {
			aml_nand_msg("nand save config failed and ret:%d",ret);
			goto exit_error0;
		}
		ENV_NAND_LINE
		ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->config_msg),(unsigned char *)(aml_chip->config_ptr),(unsigned char *)CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
		if (ret < 0) {
			aml_nand_msg("nand scan config failed and ret:%d",ret);
			goto exit_error0;
		}
		ENV_NAND_LINE
		/*liang: check if config is exist,if it is, use old config which is saved in nandflash*/
		if ((aml_chip->config_msg.arg_valid == 1)) {
			ENV_NAND_LINE
			ret = amlnand_configs_confirm(aml_chip);
			ENV_NAND_LINE
			if (ret < 0) {
				if ((aml_chip->init_flag > NAND_BOOT_UPGRATE) && (aml_chip->init_flag < NAND_BOOT_SCRUB_ALL)) {
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
			ENV_NAND_LINE
			aml_chip->config_ptr->crc = aml_info_checksum((unsigned char *)aml_chip->config_ptr->dev_para,(MAX_DEVICE_NUM*sizeof(struct dev_para)));
			ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->config_msg),(unsigned char *)(aml_chip->config_ptr),(unsigned char *)CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
			if (ret < 0) {
				aml_nand_msg("nand save config failed and ret:%d",ret);
				goto exit_error0;
			}
			ENV_NAND_LINE
		}
		/* fixme, can not reach here! */
		if (aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE) {
			aml_chip->uboot_env.update_flag = 1;
			if ((aml_chip->uboot_env.arg_valid == 1) && (aml_chip->uboot_env.update_flag)) {
				aml_nand_update_ubootenv(aml_chip,NULL);
				aml_chip->uboot_env.update_flag = 0;
				aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
						"ubootenv",aml_chip->uboot_env.arg_valid, aml_chip->uboot_env.valid_blk_addr, aml_chip->uboot_env.valid_page_addr);
			}
		}
	} else {
		aml_chip->nand_bbtinfo.arg_valid = 1;//risking?it is need here.
		amlnand_oops_handle(aml_chip,aml_chip->init_flag);
		aml_chip->nand_bbtinfo.arg_valid = 0;
		aml_chip->block_status->crc = aml_info_checksum((unsigned char *)aml_chip->block_status->blk_status,(MAX_CHIP_NUM*MAX_BLK_NUM));
		ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->nand_bbtinfo),(unsigned char *)(aml_chip->block_status),(unsigned char *)BBT_HEAD_MAGIC, sizeof(struct block_status));
		if (ret < 0) {
			aml_nand_msg("nand save bbt failed and ret:%d", ret);
			goto exit_error0;
		}
	}

exit_error0:
	return ret;
}

/* fixme, */
#if 0
static int _get_bbt_fbbt(struct amlnand_chip *aml_chip, int flag)
{
	int ret = 0;
	/* 3.1 get bbt info 1st*/
	ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->nand_bbtinfo),(unsigned char *)(aml_chip->block_status),(unsigned char *)BBT_HEAD_MAGIC, sizeof(struct block_status));
	if (ret < 0) {
		aml_nand_msg("%s() %d: nand scan bbt info failed and ret:%d", __FUNCTION__, __LINE__, ret);
	}
	/* 3.2 get fbbt info if bbt info is not exist.*/
	if (aml_chip->nand_bbtinfo.arg_valid == 0) {
		ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->shipped_bbtinfo),(unsigned char *)aml_chip->shipped_bbt_ptr,(unsigned char *)SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
		if (ret < 0) {
			aml_nand_msg("%s() %d: nand scan shipped bbt info failed and ret:%d", __FUNCTION__, __LINE__, ret);
		}
		/* 3.3 ship bbt invalid, rebuild it */
		if (aml_chip->shipped_bbtinfo.arg_valid == 0) {
		/*todo
			one, !!!!!!
			fbbt lost or clean nand.
			how to check that fbbt is lost or it only a clean nand.
			if a clean nand, first scan factory bad block and then created a bad block table.
			else fbbt is lost ,need to do some test-patterns and search bad blocks.
		*/
			ret = shipped_bbt_invalid_ops(aml_chip);
			if (ret < 0) {
				aml_nand_msg("shipped_bbt_invalid_ops and ret:%d", ret);
				goto _out;	//fixme, may need free buffer
			}
		} else {
			/* 3.4 ship bbt valid, */
			ret = shipped_bbt_valid_ops(aml_chip);
			if (ret < 0) {
				aml_nand_msg("shipped_bbt_valid_ops and ret:%d", ret);
				goto _out; //fixme, may need free buffer
			}
		}
	} else { /* bbt is valid */
		/*liang:
			for amlnand_oops_handle,it will not erase fbbt if exist.
		  fixme, may need to check fbbt which may need a refresh.
		*/
		ret = amlnand_info_init(aml_chip, (unsigned char *)&(aml_chip->shipped_bbtinfo),(unsigned char *)(aml_chip->shipped_bbt_ptr),(unsigned char *)SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));
		if (ret < 0) {
			aml_nand_msg("nand scan shipped info failed and ret:%d",ret);
		}
		amlnand_oops_handle(aml_chip,aml_chip->init_flag);
	}

_out:
	return ret;
}


static int get_bbt_fbbt(struct amlnand_chip *aml_chip, int flag)
{
	int ret = 0;

	switch (flag)
	{
		case NAND_BOOT_NORMAL:
		case NAND_BOOT_UPGRATE:

		break;

		case NAND_BOOT_ERASE_PROTECT_CACHE:

		break;
		case NAND_BOOT_ERASE_ALL:
		case NAND_BOOT_SCRUB_ALL:
		case NAND_SCAN_ID_INIT: //fixme, this flag should already return earlier.

		break;

		default:
			aml_nand_msg("%s() %d: no such flag(%d) while phy dev init.", __FUNCTION__, __LINE__, flag);
	}

	return ret;
}
#endif
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
	struct read_retry_info *retry_info = &(controller->retry_info);
	int  ret = 0;

	if (flash->blocksize < 0x40000) {
		aml_chip->keysize = flash->blocksize;
		aml_chip->dtbsize = flash->blocksize;
	} else {
		/*
		fix size key/dtb!!!
		max key/dtb size is 256KB
		*/
		aml_chip->keysize = 0x40000;
		aml_chip->dtbsize = 0x40000;
	}

	/* 1. setting config attribute.*/
	ENV_NAND_LINE;
	amlnand_set_config_attribute(aml_chip);

	ENV_NAND_LINE;
	ret = amlnand_config_buf_malloc(aml_chip);
	if (ret < 0) {
		aml_nand_msg("nand malloc buf failed");
		goto exit_error0;
	}
	ENV_NAND_LINE;
	/* get retry infos on the otp area.*/
	if (aml_chip->flash.new_type) {
		ENV_NAND_LINE;
		aml_nand_msg("detect new nand here and new_type:%d", aml_chip->flash.new_type);
		ret = amlnand_set_readretry_slc_para(aml_chip);
		if (ret<0) {
			aml_nand_msg("setting new nand para failed and ret:0x%x", ret);
			goto exit_error0;
		}
	}
#ifdef AML_NAND_UBOOT
	ENV_NAND_LINE;
	/* 2. serch fbbt & nbbt in flash.*/

	/* 2.1 serch fbbt & nbbt in flash.*/
	ret = amlnand_info_init(aml_chip,
		(unsigned char *)&(aml_chip->nand_bbtinfo),
		(unsigned char *)(aml_chip->block_status),
		(unsigned char *)BBT_HEAD_MAGIC,
		sizeof(struct block_status));
	if (ret < 0) {
		aml_nand_msg("%s() %d: nand scan bbt info failed and ret:%d",
			__FUNCTION__, __LINE__, ret);
	}
	ENV_NAND_LINE;
	ret = amlnand_info_init(aml_chip,
		(unsigned char *)&(aml_chip->shipped_bbtinfo),
		(unsigned char *)aml_chip->shipped_bbt_ptr,
		(unsigned char *)SHIPPED_BBT_HEAD_MAGIC,
		sizeof(struct shipped_bbt));
	if (ret < 0) {
		aml_nand_msg("%s() %d: nand scan shipped bbt info failed and ret:%d",
			__FUNCTION__, __LINE__, ret);
	}
	ENV_NAND_LINE;

	/* 2.1 get partition table from outsides, maybe sram.*/
	ret = amlnand_get_partition_table(aml_chip);
	if (ret < 0 && ret != -NAND_DETECT_DTB_FAILED) {
		aml_nand_msg("amlnand_get_partition_table failed:ret:%d",ret);
		goto exit_error0;
	}

#endif

	/* 3. with erase flags*/
	if ((aml_chip->init_flag > NAND_BOOT_ERASE_PROTECT_CACHE)) {
		ENV_NAND_LINE;
		/* 3.2 get fbbt info if bbt info is not exist.*/
		if (aml_chip->nand_bbtinfo.arg_valid == 0) {
			/* 3.3 ship bbt invalid, rebuild it */
			if (aml_chip->shipped_bbtinfo.arg_valid == 0) {
			/*todo
				one, !!!!!!fbbt lost or clean nand.
				how to check that fbbt is lost or it only a clean nand.
				if a clean nand, first scan factory bad block and then created a bad block table.
				else fbbt is lost ,need to do some test-patterns and search bad blocks.
			*/
				ENV_NAND_LINE;
				ret = shipped_bbt_invalid_ops(aml_chip);
				if (ret < 0) {
					aml_nand_msg("shipped_bbt_invalid_ops and ret:%d", ret);
					goto exit_error0;
				}
			} else {
				/* 3.4 ship bbt valid, */
				ENV_NAND_LINE;
				ret = shipped_bbt_valid_ops(aml_chip);
				if (ret < 0) {
					aml_nand_msg("shipped_bbt_valid_ops and ret:%d", ret);
					goto exit_error0;
				}
			}
		} else {
			/*liang:
				for amlnand_oops_handle,it will not erase fbbt if exist.
			  fixme, may need to check fbbt which may need a refresh.
			*/
			ENV_NAND_LINE;
			amlnand_oops_handle(aml_chip,aml_chip->init_flag);

			if (aml_chip->shipped_bbtinfo.arg_valid == 0) {
				amlnand_recover_fbbt(aml_chip);	/*recover fbbt table*/

				/* save fbbt info.*/
				aml_chip->shipped_bbt_ptr->crc = aml_info_checksum(
				(unsigned char *)aml_chip->shipped_bbt_ptr->shipped_bbt,
					(MAX_CHIP_NUM*MAX_BAD_BLK_NUM) );

				aml_chip->shipped_bbt_ptr->chipnum = controller->chip_num;
				ret = amlnand_save_info_by_name(aml_chip,
					(unsigned char *)&(aml_chip->shipped_bbtinfo),
					(unsigned char *)aml_chip->shipped_bbt_ptr,
					(unsigned char *)SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));

				if (ret < 0) {
					aml_nand_msg("error:%s(),%d,ret=%d", __func__, __LINE__, ret);
					goto exit_error0;
				}
			}
		}
		ENV_NAND_LINE;
	}else if(aml_chip->init_flag == NAND_BOOT_ERASE_PROTECT_CACHE) {
		/* 4. erase protect cache only!*/
		ENV_NAND_LINE;
		amlnand_oops_handle(aml_chip, aml_chip->init_flag);
	} else {
		/* 5. without erase, normal boot or upgrade */
		if (aml_chip->nand_bbtinfo.arg_valid == 0) { // bbt invalid
#ifdef AML_NAND_UBOOT
			ENV_NAND_LINE
			if (aml_chip->shipped_bbtinfo.arg_valid == 0) {	// ship bbt invalid
				ret = shipped_bbt_invalid_ops(aml_chip);
				if (ret < 0) {
					aml_nand_msg("shipped_bbt_invalid_ops and ret:%d", ret);
					goto exit_error0;
				}
			} else {		// ship bbt valid
				ENV_NAND_LINE
				ret = shipped_bbt_valid_ops(aml_chip);
				if (ret < 0) {
					aml_nand_msg("shipped_bbt_valid_ops and ret:%d", ret);
					goto exit_error0;
				}
			}
#else
			aml_nand_msg("nand scan bbt failed");
			ret = -NAND_READ_FAILED;
			goto exit_error0;
#endif
		} else {	// bbt valid

			if (aml_chip->shipped_bbtinfo.arg_valid == 0) {
				amlnand_recover_fbbt(aml_chip);	/*recover fbbt table*/
				/* save fbbt info.*/
				aml_chip->shipped_bbt_ptr->crc = aml_info_checksum(
				(unsigned char *)aml_chip->shipped_bbt_ptr->shipped_bbt,
					(MAX_CHIP_NUM*MAX_BAD_BLK_NUM) );

				aml_chip->shipped_bbt_ptr->chipnum = controller->chip_num;
				ret = amlnand_save_info_by_name(aml_chip,
					(unsigned char *)&(aml_chip->shipped_bbtinfo),
					(unsigned char *)aml_chip->shipped_bbt_ptr,
					(unsigned char *)SHIPPED_BBT_HEAD_MAGIC, sizeof(struct shipped_bbt));

				if (ret < 0) {
					aml_nand_msg("error:%s(),%d,ret=%d", __func__, __LINE__, ret);
					goto exit_error0;
				}
			}

			ENV_NAND_LINE
			ret = bbt_valid_ops(aml_chip);
			if (ret < 0) {
				aml_nand_msg("shipped_bbt_valid_ops and ret:%d", ret);
				goto exit_error0;
			}
		}
	}
	/* normal boot or upgrade */
	ENV_NAND_LINE
	if ((aml_chip->init_flag < NAND_BOOT_ERASE_PROTECT_CACHE)) {
#ifdef AML_NAND_UBOOT
		if (aml_chip->config_msg.arg_valid == 0) { // if no config,just save
			ENV_NAND_LINE
			aml_chip->config_ptr->driver_version = DRV_PHY_VERSION;
			ENV_NAND_LINE
			aml_chip->config_ptr->fbbt_blk_addr = aml_chip->shipped_bbtinfo.valid_blk_addr;
			ENV_NAND_LINE
			/* fixme, debug code. */
			aml_nand_msg("%s() %d", __func__, __LINE__);
			amlnand_get_dev_num(aml_chip,(struct amlnf_partition *)amlnand_config);
			ENV_NAND_LINE
			aml_chip->config_ptr->crc = aml_info_checksum((unsigned char *)aml_chip->config_ptr->dev_para,(MAX_DEVICE_NUM*sizeof(struct dev_para)));
			ENV_NAND_LINE
			ret = amlnand_save_info_by_name(aml_chip, (unsigned char *)&(aml_chip->config_msg),(unsigned char *)(aml_chip->config_ptr),(unsigned char *)CONFIG_HEAD_MAGIC, sizeof(struct nand_config));
			if (ret < 0) {
				aml_nand_msg("nand save config failed and ret:%d",ret);
				goto exit_error0;
			}
		}
		/* scan phy partition info here,
		if we can't find phy partition,
		we will calc and save it in phydev init stage. */
		ret = amlnand_info_init(aml_chip,
			(unsigned char *)&(aml_chip->nand_phy_partition),
			(unsigned char *)aml_chip->phy_part_ptr,
			(unsigned char *)PHY_PARTITION_HEAD_MAGIC,
			sizeof(struct phy_partition_info));
		if (ret < 0)
			aml_nand_msg("scan phy partition failed and ret:%d",
				ret);

		ENV_NAND_LINE
		if (flash->new_type && (flash->new_type < 10) && (retry_info->default_flag == 0)) {
			ENV_NAND_LINE
			ret = aml_nand_save_hynix_info(aml_chip);
			if (ret < 0) {
				aml_nand_msg("hynix nand save readretry info failed and ret:%d", ret);
				goto exit_error0;
			}
		}

		if (aml_chip->shipped_bbt_ptr) {
			kfree(aml_chip->shipped_bbt_ptr);
			aml_chip->shipped_bbt_ptr = NULL;
		}
#endif
		ENV_NAND_LINE
		amlnand_info_error_handle(aml_chip);

		/*liang:sure? is it need?*/
		/* fixme, yyh */
		repair_reserved_bad_block(aml_chip);
		/* fixme, do not free buffers....*/
		return ret ;
	}
	/*fixme, should not return here?*/
	//return ret;
	ENV_NAND_LINE;
exit_error0:
/* fixme, debug code*/
	/* free this for bad block detect! */
	ENV_NAND_LINE;
	if (ret != -NAND_DETECT_DTB_FAILED) {
		kfree(aml_chip->block_status);
		aml_chip->block_status = NULL;
	}
#if 0
	kfree(aml_chip->shipped_bbt_ptr);
	aml_chip->shipped_bbt_ptr = NULL;

	kfree(aml_chip->config_ptr);
	aml_chip->config_ptr = NULL;
	/* fixme, user_page_buf */
	kfree(aml_chip->user_oob_buf);
	aml_chip->user_oob_buf = NULL;

	kfree(aml_chip->user_page_buf);
	aml_chip->user_page_buf = NULL;
#endif
	return ret;
}

