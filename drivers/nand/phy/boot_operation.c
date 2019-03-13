

#include "../include/phynand.h"


extern void uboot_set_ran_mode(struct amlnand_phydev *phydev);
extern void nand_boot_info_prepare(struct amlnand_phydev *phydev, unsigned char * page0_buf);
extern int mt_L95B_nand_check(struct amlnand_chip *aml_chip);
extern int mt_L85C_nand_check(struct amlnand_chip *aml_chip);


static int read_uboot(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;
	struct nand_flash *flash = &(aml_chip->flash);
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller);
	struct chip_operation *operation = &(aml_chip->operation);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);
	struct en_slc_info *slc_info = &(controller->slc_info);

	u32 configure_data, pages_per_blk, configure_data_w;
	u32 pages_per_blk_w, page_size, tmp_size;
	u8 tmp_bch_mode, tmp_user_mode, tmp_ecc_limit, tmp_ecc_max;
	u16 tmp_ecc_unit, tmp_ecc_bytes, tmp_ecc_steps;
	u64 addr, readlen = 0, len = 0;
	int ret = 0;
	u32 tmp_value, en_slc = 0, tmp_index;
	u32 boot_num = 1, each_boot_pages , i;
	u32 valid_pages = BOOT_COPY_NUM * BOOT_PAGES_PER_COPY;

   // aml_nand_msg("devops->addr:%llx,devops->len:%llx,phydev->size:%llx",devops->addr,devops->len,phydev->size); //0,b8000,1000000
	if ((devops->addr + devops->len) >  phydev->size) {
		aml_nand_msg("read uboot:out of space");
		aml_nand_msg("addr:%llx len:%llx offset:%llx size:%llx",
			devops->addr,
			devops->len,
			phydev->offset,
			phydev->size);
		return -NAND_ARGUMENT_FAILURE;
	}

	if ((devops->len == 0) && (devops->ooblen == 0)) {
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

   // aml_nand_msg("devops->ooblen:%x,controller->bch_mode:%d,phydev->offset:%llx",devops->ooblen,controller->bch_mode,phydev->offset); //0,7,0

    if (controller->bch_mode == NAND_ECC_BCH_SHORT)
		page_size = (flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;

	tmp_size = phydev->writesize;
	/* phydev->writesize = page_size; */

	/* amlnand_get_device(aml_chip, CHIP_READING); */

	//clear ops_para here
	memset(ops_para, 0, sizeof(struct chip_ops_para));

	if (devops->len == 0) {
		len = phydev->writesize;
		ops_para->ooblen = devops->ooblen;
	} else {
		len = devops->len;
		ops_para->ooblen = devops->ooblen;
	}

	addr = phydev->offset + devops->addr;
	ops_para->data_buf = devops->datbuf;
	ops_para->option = phydev->option;
	ops_para->oob_buf = devops->oobbuf;

	//aml_nand_msg("addr:%llx,ops_para->data_buf:%p,ops_para->oob_buf:%p,ops_para->option:%d,len:%llx",addr,ops_para->data_buf,ops_para->oob_buf,ops_para->option,len);
	if (devops->mode == NAND_SOFT_ECC)
		ops_para->option |= DEV_ECC_SOFT_MODE;

	if ((flash->new_type) &&
		((flash->new_type < 10) || (flash->new_type == SANDISK_19NM) ||
		(slc_info->micron_l0l3_mode == 1))) {
		ops_para->option |= DEV_SLC_MODE;
		en_slc = 1;
		addr >>= 1;
	}

	len = ((((u32)len+flash->pagesize)-1)/flash->pagesize)*flash->pagesize;
	aml_nand_msg("valid_pages=%d en_slc=%d len = %llx addr=%llx", valid_pages, /*1024,0,b8000, 0*/
		en_slc, len, addr );
	valid_pages = (en_slc)?(valid_pages>>1):valid_pages;
	for (i = 1;
		i < ((valid_pages*flash->pagesize)/len + 1); i++) {
		if (((valid_pages*flash->pagesize)/(2*i) >= len)
				&& (boot_num < 4))
			boot_num <<= 1;
		else
			break;
	}
	each_boot_pages = valid_pages/boot_num;
	each_boot_pages = (en_slc)?(each_boot_pages<<1):each_boot_pages;
	aml_nand_msg("boot_num = %d each_boot_pages = %d", boot_num,each_boot_pages); /*4,256*/

	pages_per_blk = flash->blocksize / flash->pagesize;
	configure_data = NFC_CMD_N2M(controller->ran_mode,
		controller->bch_mode,
		0,
		(controller->ecc_unit >> 3),
		controller->ecc_steps);
	while (1) {
		if ((((u32)addr / flash->pagesize) %
			each_boot_pages) == 0) {
				uboot_set_ran_mode(phydev);
				page_size = (flash->pagesize / 512) *
					NAND_ECC_UNIT_SHORT;
				phydev->writesize = page_size;
				//aml_nand_msg("phydev->writesize0:%x",phydev->writesize);
#if 1
				controller->ecc_unit = NAND_ECC_UNIT_SHORT;
				controller->ecc_bytes = NAND_BCH60_1K_ECC_SIZE;
				controller->bch_mode = NAND_ECC_BCH_SHORT;
				controller->user_mode = 2;
				controller->ecc_cnt_limit = 55;
				controller->ecc_max = 60;
				controller->ecc_steps =
					(flash->pagesize+flash->oobsize)/512;
#endif
		} else
			controller->ran_mode = 1;

		/* controller->chip_num; */
		ops_para->page_addr = ((u32)addr / flash->pagesize);
		if ((ops_para->option & DEV_SLC_MODE)) {
			tmp_value = ops_para->page_addr;
			tmp_value &= (~((pages_per_blk >> 1) - 1));
			/*128-->256; 256-->512 ......*/
			tmp_value <<= 0x01;
			tmp_index =
			ops_para->page_addr % (pages_per_blk >> 1);
			if ((flash->new_type > 0) && (flash->new_type < 10 ||
				(slc_info->micron_l0l3_mode == 1)))
				ops_para->page_addr = tmp_value |
				(slc_info->pagelist[tmp_index]);
			if (flash->new_type == SANDISK_19NM)
				ops_para->page_addr = tmp_value |
				(tmp_index << 1);
		}
		ret = operation->read_page(aml_chip);
		if ((ops_para->ecc_err) || (ret < 0)) {
			aml_nand_msg("fail page_addr:%d", ops_para->page_addr);
			break;
		}

		/* check info page */
		if ((!strncmp((char *)phydev->name,
				NAND_BOOT_NAME,
				strlen((const char *)NAND_BOOT_NAME)))
				&& (((((u32)addr / flash->pagesize))%/*each_boot_pages*/
			each_boot_pages) == 0)) {
			controller->ran_mode = 1;
			memcpy((u8 *)(&configure_data_w),
				ops_para->data_buf,
				sizeof(int));
			memcpy((u8 *)(&pages_per_blk_w),
				ops_para->data_buf+4,
				sizeof(int));

			aml_nand_msg("configure_data:%x, pages_per_blk:%x",
				configure_data,
				pages_per_blk);

			addr += flash->pagesize;
#if 1
			controller->ecc_unit = tmp_ecc_unit;
			controller->ecc_bytes = tmp_ecc_bytes;
			controller->bch_mode = tmp_bch_mode;
			controller->user_mode = tmp_user_mode;
			controller->ecc_cnt_limit = tmp_ecc_limit;
			controller->ecc_max = tmp_ecc_max;
			controller->ecc_steps = tmp_ecc_steps;
			phydev->writesize = tmp_size;

			/*aml_nand_msg("phydev->writesize1:%x,addr:%llx",phydev->writesize,addr); */
#endif
			continue;
		}

		addr += flash->pagesize;
		ops_para->data_buf += phydev->writesize;
		readlen += phydev->writesize;
		/* aml_nand_msg("phydev->writesize1:%x,addr:%llx,readlen:%llx,ops_para->data_buf:%p",phydev->writesize,addr,readlen,ops_para->data_buf); */
		if (readlen >= len)
			break;
	}

	devops->retlen = readlen;
	/* amlnand_release_device(aml_chip); */
	if (!ret) {
		if (ops_para->ecc_err)
			ret = NAND_ECC_FAILURE;
		/*else if(ops_para->bit_flip){
			ret = NAND_BITFLIP_FAILURE;
		}*/
	}

	controller->ran_mode = 1;
	controller->ecc_unit = tmp_ecc_unit;
	controller->ecc_bytes = tmp_ecc_bytes;
	controller->bch_mode = tmp_bch_mode;
	controller->user_mode = tmp_user_mode;
	controller->ecc_cnt_limit = tmp_ecc_limit;
	controller->ecc_max = tmp_ecc_max;
	controller->ecc_steps = tmp_ecc_steps;
	phydev->writesize = tmp_size;

	return ret;
}

int roomboot_nand_read(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller);
	u64 offset , write_len;
	u8 *buffer, tmp_user_mode =0;
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

	amlnand_get_device(aml_chip, CHIP_READING);
	if (controller->oob_mod) {
		oob_set = controller->oob_mod;
		NFC_CLR_OOB_MODE(controller, 3<<26);
		controller->oob_mod = 0;
		tmp_user_mode = controller->user_mode;
		controller->user_mode = 2;
	}

	//aml_nand_msg("devops->addr111:%llx,devops->len:%llx,devops->datbuf:%p",devops->addr,devops->len,devops->datbuf);
	ret = read_uboot(phydev);
	if (ret < 0)
		aml_nand_dbg("nand read failed at %llx", devops->addr);

	if (oob_set) {
		controller->oob_mod = oob_set;
		NFC_SET_OOB_MODE(controller, 3<<26);
		controller->user_mode = tmp_user_mode;
	}

	amlnand_release_device(aml_chip);
	return ret;
}

void _dump_mem_u8(uint8_t * buf, uint32_t len)
{
	uint32_t i;
	if (buf == NULL)
		return;
	printk("%s, %p, %d", __func__, buf, len);
	for (i = 0; i < len/sizeof(uint8_t); i++) {

		if ( i % 16 == 0)
			printk("\n0x%p: ", buf+i);
		printk("%02x ", buf[i]);
	}
	printk("\n");
	return;
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
	u8 *fill_buf = NULL;
	u8 *oob_buf = NULL, *page0_buf = NULL;
	u8 tmp_bch_mode, tmp_user_mode, tmp_ecc_limit, tmp_ecc_max;
	u8 tmp_rand;
	u32 configure_data, pages_per_blk;
	u32 oobsize, page_size, tmp_size, priv_lsb, ops_tem;
	u16 tmp_ecc_unit, tmp_ecc_bytes, tmp_ecc_steps;
	u64 addr, writelen = 0, len = 0;
	int  i, ret = 0;
	u8 *lazy_buf = devops->datbuf;
	/* u8  *tmp_buf; */
	char write_boot_status[BOOT_COPY_NUM] = {0}, err = 0;
	u32 tmp_value, tmp_index, fill_len=0, boot_pages;
	nand_page0_t * p_nand_page0 = NULL;
	ext_info_t * p_ext_info = NULL;
	unsigned char rand_val[4] = {0, 0, 0, 0}, rand_flag = 0;
	u32 page_no =0;

	BOOT_LINE
	if ((devops->addr + devops->len) >  phydev->size) {
		aml_nand_msg("writeboot:out of space and addr:");
		aml_nand_msg("%llx len:%llx offset:%llx size:%llx",
			devops->addr,
			devops->len,
			phydev->offset,
			phydev->size);
		return -NAND_ARGUMENT_FAILURE;
	}

	if ((devops->len == 0) && (devops->ooblen == 0)) {
		aml_nand_msg("len equal zero here");
		return NAND_SUCCESS;
	}

	if (devops->addr != 0) {
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

	if (controller->bch_mode == NAND_ECC_BCH_SHORT)
		page_size = (flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;

	oobsize = controller->ecc_steps*controller->user_mode;
	BOOT_LINE
	tmp_size = phydev->writesize;
	/* phydev->writesize = page_size; */

	amlnand_get_device(aml_chip, CHIP_WRITING);

	oob_buf = aml_nand_malloc(oobsize);
	if (oob_buf == NULL) {
		aml_nand_msg("malloc failed and oobavail:%d", phydev->oobavail);
		ret = -NAND_MALLOC_FAILURE;
		goto error_exit;
	}
	memset(oob_buf, 0x0, oobsize);

	page0_buf = aml_nand_malloc(flash->pagesize);
	if (page0_buf == NULL) {
		aml_nand_msg("malloc failed and oobavail:%d", flash->pagesize);
		ret = -NAND_MALLOC_FAILURE;
		goto error_exit;
	}
	memset(page0_buf, 0x0, flash->pagesize);
	len = devops->len;

	/*len = ((len + 0x200000 - 1) / 0x200000) * 0x200000 - flash->pagesize;*/
	for (i = 0; i < oobsize; i += 2) {
		oob_buf[i] = 0x55;
		oob_buf[i+1] = 0xaa;
	}

	fill_len = flash->pagesize + flash->oobsize;
	fill_buf = aml_nand_malloc(fill_len);
	if (fill_buf == NULL) {
		aml_nand_msg("malloc failed and oobavail:%d", fill_len);
		ret = -NAND_MALLOC_FAILURE;
		goto error_exit;
	}
	memset(fill_buf, 0xff, fill_len);

	BOOT_LINE
	/* clear ops_para here */
	memset(ops_para, 0, sizeof(struct chip_ops_para));
	addr = phydev->offset + devops->addr;
	ops_para->option = phydev->option;
	ops_para->data_buf = devops->datbuf;
	ops_para->oob_buf = oob_buf;

	BOOT_LINE

	if ((flash->new_type)
		&& ((flash->new_type < 10)
		|| (flash->new_type == SANDISK_19NM)
		|| (slc_info->micron_l0l3_mode == 1)))
		ops_para->option |= DEV_SLC_MODE;

	configure_data = NFC_CMD_N2M(controller->ran_mode,
		controller->bch_mode,
		0,
		(controller->ecc_unit >> 3),
		controller->ecc_steps);

	pages_per_blk = flash->blocksize / flash->pagesize;
	aml_nand_msg("configure_data:%x, pages_per_blk:%x %x",
		configure_data,
		pages_per_blk, ops_para->option);

	nand_boot_info_prepare(phydev, page0_buf);
	BOOT_LINE

	p_nand_page0 = (nand_page0_t *) page0_buf;
	p_ext_info = &p_nand_page0->ext_info;

	for (i = 0; i < p_ext_info->boot_num; i++) {
		BOOT_LINE
		writelen = 0;
		addr = 0;
		addr += flash->pagesize * p_ext_info->each_boot_pages *i;
		boot_pages = p_ext_info->each_boot_pages;
		if (ops_para->option & DEV_SLC_MODE) {
			addr >>= 1;
			boot_pages = p_ext_info->each_boot_pages >> 1;
		}
		ops_para->data_buf = lazy_buf;
		devops->datbuf = lazy_buf;
		while (1) {
			if (((((u32)addr/flash->pagesize))%boot_pages) == 0) {   /* first page special write */
				uboot_set_ran_mode(phydev);
				ops_para->data_buf = page0_buf;

				page_size =
				(flash->pagesize / 512) * NAND_ECC_UNIT_SHORT;
				phydev->writesize = page_size;
				#if 1
				controller->ecc_unit = NAND_ECC_UNIT_SHORT;
				controller->ecc_bytes = NAND_BCH60_1K_ECC_SIZE;
				controller->bch_mode = NAND_ECC_BCH_SHORT;
				controller->user_mode = 2;
				controller->ecc_cnt_limit = 55;
				controller->ecc_max = 60;
				controller->ecc_steps =
					(flash->pagesize+flash->oobsize)/512;
				#endif
			}
			ops_para->page_addr = ((u32)addr / flash->pagesize);
			ops_tem = ops_para->page_addr;
			if ((ops_para->option & DEV_SLC_MODE)) {
				tmp_value = ops_para->page_addr;
				tmp_value &= (~((pages_per_blk >> 1) - 1));
				/*128-->256; 256-->512 ......*/
				tmp_value <<= 0x01;
				tmp_index = ops_para->page_addr % (pages_per_blk >> 1);
				if ((flash->new_type > 0)
					&& (flash->new_type < 10
					|| (flash->new_type == MICRON_20NM)))
					ops_para->page_addr = tmp_value |
						(slc_info->pagelist[tmp_index]);
				if (flash->new_type == SANDISK_19NM)
					ops_para->page_addr = tmp_value |
						(tmp_index << 1);
			}
#if 1
			if (flash->new_type == HYNIX_1YNM ||
				slc_info->micron_l0l3_mode == 1) {
				if ((ops_tem % (pages_per_blk >> 1)) > 1) {
					tmp_value = ops_tem;
					tmp_value &= (~((pages_per_blk >> 1) - 1));
					/*128-->256; 256-->512 ......*/
					tmp_value <<= 0x01;
					tmp_index = ops_tem % (pages_per_blk >> 1);
					priv_lsb = tmp_value |
						(slc_info->pagelist[tmp_index - 1]);
					ops_tem = ops_para->page_addr;
					rand_flag = 0;
					if (flash->new_type == MICRON_20NM &&
						ops_tem > (priv_lsb+1)) {
						rand_val[0] = 0;
						rand_flag = 1;
						operation->set_onfi_para(aml_chip, rand_val, 0x92);
					}
					while (ops_tem > (priv_lsb+1)) {
						ops_para->data_buf = fill_buf;
						controller->bch_mode =
							NAND_ECC_NONE;
						controller->ran_mode = 0;
						ops_para->page_addr =
							priv_lsb+1;
						operation->write_page(aml_chip);
						priv_lsb++;
					}
					if (rand_flag == 1) {
						rand_val[0] = 1;
						operation->set_onfi_para(aml_chip, rand_val, 0x92);
					}
					ops_para->page_addr = ops_tem;
					ops_para->data_buf = devops->datbuf;
					controller->ecc_unit = tmp_ecc_unit;
					controller->ecc_bytes = tmp_ecc_bytes;
					controller->bch_mode = tmp_bch_mode;
					controller->user_mode = tmp_user_mode;
					controller->ecc_cnt_limit =
						tmp_ecc_limit;
					controller->ecc_max = tmp_ecc_max;
					controller->ecc_steps = tmp_ecc_steps;
					phydev->writesize = tmp_size;
					controller->ran_mode = tmp_rand;
				}
			}
			#endif
			if (((((u32)addr / flash->pagesize)) %
				boot_pages) != 0)
				ops_para->data_buf = devops->datbuf;
			ret = operation->write_page(aml_chip);
			if (ret < 0) {
				write_boot_status[i] = 1;
				aml_nand_msg("fail page_addr:%d",
					ops_para->page_addr);
				break;
			}

			if ((((u32)addr / flash->pagesize) %
				boot_pages) == 0) {
				controller->ran_mode = 1;
				addr += flash->pagesize;
				ops_para->data_buf = devops->datbuf;
				#if 1
				controller->ecc_unit = tmp_ecc_unit;
				controller->ecc_bytes = tmp_ecc_bytes;
				controller->bch_mode = tmp_bch_mode;
				controller->user_mode = tmp_user_mode;
				controller->ecc_cnt_limit = tmp_ecc_limit;
				controller->ecc_max = tmp_ecc_max;
				controller->ecc_steps = tmp_ecc_steps;
				phydev->writesize = tmp_size;
				#endif
				continue;
			}

			addr += flash->pagesize;
			devops->datbuf += phydev->writesize;
			writelen += phydev->writesize;

			if ((writelen >= devops->len)
				&& (writelen < phydev->erasesize))
				devops->datbuf = fill_buf;
			#if 0
			if ((writelen >= (len-flash->pagesize))
				|| ((ops_para->option & DEV_SLC_MODE)
				&& ((u32)addr%(flash->blocksize>>1) == 0))
				|| (((ops_para->option & DEV_SLC_MODE) == 0)
				&& ((u32)addr%flash->blocksize == 0)))
				break;
			#else
			if (writelen >= len) {
				page_no = (u32)addr/ flash->pagesize;
				page_no = page_no % L04A_PAGES_IN_BLK;
				aml_nand_msg("page_no:%d",page_no);
	            if (flash->option & NAND_USE_SHAREPAGE_MODE) {
					/*page_no = (u32)addr/ flash->pagesize;
					page_no = page_no % L04A_PAGES_IN_BLK;
					aml_nand_msg("page_no:%d",page_no);
					*/
	                if ((page_no >= NAND_PAGE_NO1) && (page_no <= NAND_PAGE_NO2) &&
					   (page_no % 2 != 0)) {
						/* memset(fill_buf, 0xa5, fill_len); */
						 ops_para->data_buf = fill_buf;    /*fill 0xff*/
						 ops_para->page_addr = ((u32)addr / flash->pagesize);
						 aml_nand_msg("write upperpage next no:%d",ops_para->page_addr);
						 ret = operation->write_page(aml_chip);
						if (ret < 0) {
							write_boot_status[i] = 1;
							aml_nand_msg("fail page_addr:%d",
								ops_para->page_addr);
							break;
							}
						}
					}

				/*********L95B*************/
				if ((mt_L95B_nand_check(aml_chip) == 0)
					|| (mt_L85C_nand_check(aml_chip) == 0)) {
					int j = 0;
					for (j = 0; j < 11; j++) {
						memset(fill_buf, 0x5a,fill_len);
						ops_para->data_buf = fill_buf;
						ops_para->page_addr = ((u32)addr / flash->pagesize);
						aml_nand_msg("write extra page: %d",ops_para->page_addr);
						ret = operation->write_page(aml_chip);
						if (ret < 0) {
							write_boot_status[i] = 1;
							aml_nand_msg("write fail page_addr:%d",
								ops_para->page_addr);
							break;
						}
						addr += flash->pagesize;
					}
				}
			break;
			}


			#endif
		}
	}
	BOOT_LINE
	for (i = 0; i < p_ext_info->boot_num; i++)
		err += write_boot_status[i];

	if (err < 2)
		ret = 0;
	else
	    ret = 1;
	devops->retlen = writelen;

error_exit:
	amlnand_release_device(aml_chip);
	controller->ran_mode = 1;
	controller->ecc_unit = tmp_ecc_unit;
	controller->ecc_bytes = tmp_ecc_bytes;
	controller->bch_mode = tmp_bch_mode;
	controller->user_mode = tmp_user_mode;
	controller->ecc_cnt_limit = tmp_ecc_limit;
	controller->ecc_max = tmp_ecc_max;
	controller->ecc_steps = tmp_ecc_steps;
	phydev->writesize = tmp_size;
	kfree(fill_buf);
	fill_buf = NULL;

	kfree(page0_buf);
	page0_buf = NULL;
	kfree(oob_buf);
	oob_buf = NULL;
	return ret;
}

int roomboot_nand_write(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;
	struct nand_flash *flash = &aml_chip->flash;
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller);
	struct chip_operation *operation = &(aml_chip->operation);
	struct chip_ops_para *ops_para = &(aml_chip->ops_para);

	u64 offset , write_len, addr;
	u8 *buffer, tmp_user_mode =0;
	int ret = 0;
	int oob_set = 0;

	offset = devops->addr;
	write_len = devops->len;
	buffer = devops->datbuf;

	if (offset != 0) {
		aml_nand_msg("Wrong addr begin");
		return -1;
	}

	/*align with page size*/
	write_len = ((((u32)write_len + phydev->writesize)-1)/
		phydev->writesize)*phydev->writesize;

	if ((offset & (phydev->writesize - 1)) != 0
		|| (write_len & (phydev->writesize - 1)) != 0) {
		aml_nand_msg("Attempt to write non page aligned data\n");
		return -NAND_WRITE_FAILED;
	}

	BOOT_LINE

	if ((offset + write_len) > phydev->size) {
		aml_nand_msg("Attemp to write out side the dev area");
		return -NAND_WRITE_FAILED;
	}

	if (controller->oob_mod) {
		oob_set = controller->oob_mod;
		NFC_CLR_OOB_MODE(controller, 3<<26);
		controller->oob_mod = 0;
		tmp_user_mode = controller->user_mode;
		controller->user_mode = 2;
	}

	memset(ops_para, 0, sizeof(struct chip_ops_para));
	addr = phydev->offset + devops->addr;
	ops_para->chipnr = 0;
	ops_para->option = phydev->option;
	if ((flash->new_type) && (flash->new_type == SANDISK_19NM))
		ops_para->option |= DEV_SLC_MODE;

	do {
		ops_para->page_addr = ((u32)addr / flash->pagesize);
		controller->select_chip(controller, ops_para->chipnr);
		ret = operation->block_isbad(aml_chip);
		if (ret ==  NAND_BLOCK_FACTORY_BAD) {
			aml_nand_msg("blk is shipped bad block at page %d",
				ops_para->page_addr);
			addr += phydev->erasesize;
			continue;
		}
		BOOT_LINE
		nand_get_chip(aml_chip);
		BOOT_LINE
		ret = operation->erase_block(aml_chip);
		BOOT_LINE
		nand_release_chip(aml_chip);
		if (ret < 0)
			aml_nand_msg("nand erase fail at addr page %d",
				ops_para->page_addr);
			/* break; */
		addr += phydev->erasesize;
	} while (addr < (1024 * flash->pagesize));
	BOOT_LINE
	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = offset;
	devops->len = write_len;
	devops->datbuf = buffer;	//!!
	devops->oobbuf = NULL;
	devops->mode = NAND_HW_ECC;

	aml_nand_dbg("devops->addr =%llx", devops->addr);
	aml_nand_dbg("devops->len =%llx", devops->len);
	BOOT_LINE
	ret = write_uboot(phydev);
	BOOT_LINE
	if (ret < 0) {
		aml_nand_dbg("nand write failed at %llx", devops->addr);
		goto exit_error0;
	}
	if (oob_set) {
		controller->oob_mod = oob_set;
		NFC_SET_OOB_MODE(controller, 3<<26);
		controller->user_mode = tmp_user_mode;
	}
	return ret;
exit_error0:
	return ret;
}

#ifndef AML_NAND_UBOOT
static int uboot_open(struct inode * inode, struct file * filp)
{
	aml_nand_dbg("uboot_open");
	return 0;
}
/*
 * This funcion reads the u-boot envionment variables.
 * The f_pos points directly to the env location.
 */
static ssize_t uboot_read(struct file *file,
	char __user *buf,
	size_t count,
	loff_t *ppos)
{
	struct amlnand_phydev *phydev = uboot_phydev;
	struct amlnand_chip *aml_chip = phydev->priv;
	struct phydev_ops *devops = &(phydev->ops);

	u8 *data_buf;
	int  ret;
	size_t align_count = 0;
	align_count =
		((((u32)count + phydev->writesize)-1)/phydev->writesize)
		*phydev->writesize;
	data_buf = aml_nand_malloc(align_count);
	if (!data_buf) {
		aml_nand_dbg("malloc buf for rom_write failed");
		goto err_exit0;
	}
	memset(data_buf, 0x0, align_count);


	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = 0x0;
	/* devops->len = UBOOT_WRITE_SIZE; */
	devops->len = align_count;
	devops->mode = NAND_HW_ECC;
	devops->datbuf = data_buf;
	amlnand_get_device(aml_chip, CHIP_WRITING);

	ret = roomboot_nand_read(phydev);
	if (ret < 0) {
		aml_nand_dbg("uboot_write failed");
		count = 0;
	}
	amlnand_release_device(aml_chip);
	ret = copy_to_user(buf, data_buf, count);
err_exit0:

	aml_nand_free(data_buf);
	data_buf = NULL;

	return count;
}

static ssize_t uboot_write(struct file *file, const char __user *buf,
			 size_t count, loff_t *ppos)
{
	struct amlnand_phydev *phydev = uboot_phydev;
	struct amlnand_chip *aml_chip = phydev->priv;
	struct phydev_ops *devops = &(phydev->ops);

	u8 *data_buf;
	int  ret;
	size_t align_count = 0;
	align_count =
		((((u32)count + phydev->writesize)-1)/phydev->writesize)
		*phydev->writesize;
	data_buf = aml_nand_malloc(align_count);
	if (!data_buf) {
		aml_nand_dbg("malloc buf for rom_write failed");
		goto err_exit0;
	}
	memset(data_buf, 0x0, align_count);
	ret = copy_from_user(data_buf, buf, count);

	memset(devops, 0x0, sizeof(struct phydev_ops));
	devops->addr = 0x0;
	devops->len = align_count;
	devops->mode = NAND_HW_ECC;
	devops->datbuf = data_buf;
	amlnand_get_device(aml_chip, CHIP_WRITING);

	ret = roomboot_nand_write(phydev);
	if (ret < 0) {
		aml_nand_dbg("uboot_write failed");
		count = 0;
	}
	amlnand_release_device(aml_chip);

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

static const struct file_operations uboot_fops = {
	.owner = THIS_MODULE,
	.open = uboot_open,
	.read = uboot_read,
	.write = uboot_write,
	.release = uboot_close,
};

int boot_device_register(struct amlnand_phydev *phydev)
{
	int ret = 0;

	if (!strncmp((char *)phydev->name,
		NAND_BOOT_NAME,
		strlen((const char *)NAND_BOOT_NAME))) {

		aml_nand_dbg("boot device register");

		uboot_phydev = phydev;
		ret = alloc_chrdev_region(&uboot_devno, 0, 1, "bootloader");
		if (ret < 0) {
			aml_nand_dbg("uboot_phydev:failed to allocate chrdev.");
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
			aml_nand_dbg("class_register(&uboot_class) failed!\n");
			goto exit_error0;
		}

		devp = device_create(&uboot_class,
				NULL,
				uboot_devno,
				NULL,
				"bootloader");
		if (IS_ERR(devp)) {
			aml_nand_dbg("uboot_phydev:fail to create node\n");
			ret = PTR_ERR(devp);
			goto exit_error0;
		}
	}
	return NAND_SUCCESS;
exit_error0:
	return ret;
}
#endif /* AML_NAND_UBOOT */
