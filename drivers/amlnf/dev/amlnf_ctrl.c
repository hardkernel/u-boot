
/*
 * Aml  
 *
 * (C) 2012 8
 */
#include "../include/phynand.h"

struct bch_desc bch_list[MAX_ECC_MODE_NUM] = {

#ifdef CONFIG_NAND_AML_M8
	[0]=ECC_INFORMATION("NAND_RAW_MODE", NAND_ECC_SOFT_MODE, 0, 0, 0),
	[1]=ECC_INFORMATION("NAND_BCH8_MODE", NAND_ECC_BCH8_MODE, NAND_ECC_UNIT_SIZE, NAND_BCH8_ECC_SIZE, 2),
	[2]=ECC_INFORMATION("NAND_BCH8_1K_MODE" ,NAND_ECC_BCH8_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH8_1K_ECC_SIZE, 2),
	[3]=ECC_INFORMATION("NAND_BCH24_1K_MODE" ,NAND_ECC_BCH24_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH24_1K_ECC_SIZE, 2),
	[4]=ECC_INFORMATION("NAND_BCH30_1K_MODE" ,NAND_ECC_BCH30_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH30_1K_ECC_SIZE, 2),
	[5]=ECC_INFORMATION("NAND_BCH40_1K_MODE" ,NAND_ECC_BCH40_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH40_1K_ECC_SIZE, 2),
	[6]=ECC_INFORMATION("NAND_BCH50_1K_MODE" ,NAND_ECC_BCH50_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH50_1K_ECC_SIZE, 2),
	[7]=ECC_INFORMATION("NAND_BCH60_1K_MODE" ,NAND_ECC_BCH60_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH60_1K_ECC_SIZE, 2),
	[8]=ECC_INFORMATION("NAND_SHORT_MODE" ,NAND_ECC_SHORT_MODE, NAND_ECC_UNIT_SHORT, NAND_BCH60_1K_ECC_SIZE, 2),
#else
	[0]=ECC_INFORMATION("NAND_RAW_MODE", NAND_ECC_SOFT_MODE, 0, 0, 0),
	[1]=ECC_INFORMATION("NAND_BCH8_MODE", NAND_ECC_BCH8_MODE, NAND_ECC_UNIT_SIZE, NAND_BCH8_ECC_SIZE, 2),
	[2]=ECC_INFORMATION("NAND_BCH8_1K_MODE" ,NAND_ECC_BCH8_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH8_1K_ECC_SIZE, 2),
	[3]=ECC_INFORMATION("NAND_BCH16_1K_MODE" ,NAND_ECC_BCH16_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH16_1K_ECC_SIZE, 2),
	[4]=ECC_INFORMATION("NAND_BCH24_1K_MODE" ,NAND_ECC_BCH24_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH24_1K_ECC_SIZE, 2),
	[5]=ECC_INFORMATION("NAND_BCH30_1K_MODE" ,NAND_ECC_BCH30_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH30_1K_ECC_SIZE, 2),
	[6]=ECC_INFORMATION("NAND_BCH40_1K_MODE" ,NAND_ECC_BCH40_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH40_1K_ECC_SIZE, 2),
	[7]=ECC_INFORMATION("NAND_BCH60_1K_MODE" ,NAND_ECC_BCH60_1K_MODE, NAND_ECC_UNIT_1KSIZE, NAND_BCH60_1K_ECC_SIZE, 2),
	[8]=ECC_INFORMATION("NAND_SHORT_MODE" ,NAND_ECC_SHORT_MODE, NAND_ECC_UNIT_SHORT, NAND_BCH60_1K_ECC_SIZE, 2),
#endif
};


#ifndef 	AML_NAND_UBOOT
static dma_addr_t nfdata_dma_addr;
static dma_addr_t nfinfo_dma_addr;	
static spinlock_t amlnf_lock;
static wait_queue_head_t amlnf_wq;	
#endif

struct list_head nphy_dev_list;
struct list_head nf_dev_list;
#ifdef AML_NAND_UBOOT
struct list_head nlogic_dev_list;
#endif
void *aml_nand_malloc(uint32 size)
{
    return kmalloc(size, GFP_KERNEL);
}

void aml_nand_free(const void *ptr)
{
    kfree(ptr);
}

#ifndef AML_NAND_UBOOT
void *amlnf_dma_malloc(uint32 size, unsigned char flag)
{
	if(flag = 0) //data
		return dma_alloc_coherent(NULL, size, &nfdata_dma_addr, GFP_KERNEL);
	if(flag = 1) //usr
		return dma_alloc_coherent(NULL, size, &nfinfo_dma_addr, GFP_KERNEL);
}

void amlnf_dma_free(const void *ptr, unsigned size, unsigned char flag)
{
	if(flag = 0) //data
		dma_free_coherent(NULL, size, ptr,nfdata_dma_addr);
	if(flag = 1) //usr
		dma_free_coherent(NULL, size, ptr, nfinfo_dma_addr);
}
#endif

int set_nphy_dma_addr(unsigned count, unsigned len, unsigned char *data_buf, unsigned int *usr_buf)
{
#ifndef AML_NAND_UBOOT
	smp_wmb();
	wmb();

	//while(NFC_CMDFIFO_SIZE() > 10);
	NFC_SEND_CMD_ADL(nfdata_dma_addr);
	NFC_SEND_CMD_ADH(nfdata_dma_addr);
	NFC_SEND_CMD_AIL(nfinfo_dma_addr);
	NFC_SEND_CMD_AIH(nfinfo_dma_addr);		
#else
	dcache_flush_range((unsigned)usr_buf, count*PER_INFO_BYTE);
	dcache_invalid_range((unsigned)data_buf, len);

	//while(NFC_CMDFIFO_SIZE() > 10);
	NFC_SEND_CMD_ADL((int)data_buf);
	NFC_SEND_CMD_ADH((int)data_buf);
	NFC_SEND_CMD_AIL((int)usr_buf);
	NFC_SEND_CMD_AIH((int)usr_buf);		
#endif
	return 0;
}
 
unsigned char nandphy_readb(void)
{
	return readb((void __iomem *) NAND_IO_ADDR);
}
 
#ifndef AML_NAND_UBOOT
int amlphy_prepare(unsigned flag)
{
	spin_lock_init(&amlnf_lock);
	init_waitqueue_head(&amlnf_wq);

	return 0;
}

int phydev_suspend(struct amlnand_phydev *phydev)
{
    struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
    
	if (!strncmp((char*)phydev->name, NAND_BOOT_NAME, strlen((const char*)NAND_BOOT_NAME)))
		return 0;
	aml_nand_dbg("phydev_suspend: entered!");
	spin_lock(&amlnf_lock);	
	//set_chip_state(phydev, CHIP_PM_SUSPENDED);
	set_chip_state(aml_chip, CHIP_PM_SUSPENDED);
	spin_unlock(&amlnf_lock);
}

int phydev_resume(struct amlnand_phydev *phydev)
{
	amlchip_resume(phydev);
	return 0;
}

#define	NAND_CTRL_NONE_RB 						(1<<1)
void   nand_get_chip(void *chip)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)chip;
	struct hw_controller *controller = &(aml_chip->controller);
	int retry = 0;
	while(1){
			mutex_lock(&spi_nand_mutex);
			if((controller->option & NAND_CTRL_NONE_RB) == 0)
				aml_chip->nand_pinctrl = devm_pinctrl_get_select(&aml_chip->device,"nand_rb_mod");
			else
				aml_chip->nand_pinctrl = devm_pinctrl_get_select(&aml_chip->device,"nand_norb_mod");
			if (IS_ERR(aml_chip->nand_pinctrl)){
				aml_chip->nand_pinctrl = NULL;
				printk("%s:%d  %s  can't get pinctrl \n",__func__,__LINE__,dev_name(&aml_chip->device));
			}
			else 
				break; 
			
			if(retry++ > 10 ){
				aml_nand_msg("devm_pinctrl_get_select get failed after  over 10 times retry=%d",retry);
			}
	}
	 return ;
}

 void  nand_release_chip(void *chip)
{
	 struct amlnand_chip *aml_chip = (struct amlnand_chip *)chip;
  	if(aml_chip->nand_pinctrl != NULL){

	devm_pinctrl_put(aml_chip->nand_pinctrl);
	aml_chip->nand_pinctrl = NULL;
		mutex_unlock(&spi_nand_mutex);
	}
}

/**
 * amlnand_get_device - [GENERIC] Get chip for selected access
 *
 * Get the device and lock it for exclusive access
 */
int amlnand_get_device(struct amlnand_phydev *phydev, chip_state_t new_state)
{	
	DECLARE_WAITQUEUE(wait, current);
	
retry:
	spin_lock(&amlnf_lock);

	if (get_chip_state(phydev) == CHIP_READY) {
		set_chip_state(phydev, new_state);
		//set nand pinmux here
		nand_get_chip();		
		spin_unlock(&amlnf_lock);
		return 0;
	}
	
	set_current_state(TASK_UNINTERRUPTIBLE);
	add_wait_queue(&amlnf_wq, &wait);
	spin_unlock(&amlnf_lock);
	schedule();
	remove_wait_queue(&amlnf_wq, &wait);
	goto retry;
}

/**
 * nand_release_device - [GENERIC] release chip
 * @aml_chip:	nand chip structure
 *
 * Deselect, release chip lock and wake up anyone waiting on the device
 */
void amlnand_release_device(struct amlnand_phydev *phydev)
{
	/* Release the controller and the chip */
	spin_lock(&amlnf_lock);
	set_chip_state(phydev, CHIP_READY);

	//clear nand pinmux here
	nand_release_chip();
	wake_up(&amlnf_wq);
	spin_unlock(&amlnf_lock);
}

#else
int amlnand_get_device(struct amlnand_phydev *phydev, chip_state_t new_state)
{
	nand_get_chip();	
	set_chip_state(phydev, new_state);

	return 0;
}

 void amlnand_release_device(struct amlnand_phydev *phydev)
{
	 set_chip_state(phydev, CHIP_READY);
	//clear nand pinmux here
	nand_release_chip();
}
#endif


void pinmux_select_chip(unsigned ce_enable, unsigned rb_enable, unsigned flag)
{
#ifdef AML_NAND_UBOOT
	if (!((ce_enable >> 10) & 1))
		SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 25));
	if (!((ce_enable >> 10) & 2))
		SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 24));
	if (!((ce_enable >> 10) & 4))
		SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 23));
	if (!((ce_enable >> 10) & 8))
		SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 22));

#ifndef CONFIG_NAND_AML_M8
	if (flag && (rb_enable)){ 
		if (!((rb_enable >> 10) & 1))
			SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 17));
		if (!((rb_enable >> 10) & 1))
			SET_CBUS_REG_MASK(PERIPHS_PIN_MUX_2, (1 << 16));
	}
#endif	

#endif

}

#ifdef CONFIG_NAND_AML_M8
 void set_nand_core_clk(int clk_freq)
{
    int i, j, unit, best_err, best_freq, best_sel, best_div;
    int tmp_freq, tmp_div, tmp_err;
    int fclk[7];
    int div[4] = {4, 3, 5, 7};
    nand_core_clk_t clk_cfg;

#ifdef AML_NAND_DBG_M8   
    // NAND uses crystal, 24 or 25 MHz
    //NFC_SET_CORE_PLL(((4<<9) | (1<<8) | 0);
    
    if(clk_freq  == 160){    
	    // NAND uses src 0 div by 4, 160 MHz
	    //WRITE_CBUS_REG(HHI_NAND_CLK_CNTL, ((0<<9) | (1<<8) | 3));
	    NFC_SET_CORE_PLL(((0<<9) | (1<<8) | 3));
	}
		
	if(clk_freq  == 182){    
	    // NAND uses src 0 div by 4, 160 MHz
	    //WRITE_CBUS_REG(HHI_NAND_CLK_CNTL, ((0<<9) | (1<<8) | 3));
	    NFC_SET_CORE_PLL(((3<<9) | (1<<8) | 1));
	}

    if(clk_freq  == 212){    
	    // NAND uses src 0 div by 4, 160 MHz
	    //WRITE_CBUS_REG(HHI_NAND_CLK_CNTL, ((0<<9) | (1<<8) | 3));
	    NFC_SET_CORE_PLL(((1<<9) | (1<<8) | 3));
	}	
	
    if(clk_freq  == 255){    
	    // NAND uses src 0 div by 4, 160 MHz
	    //WRITE_CBUS_REG(HHI_NAND_CLK_CNTL, ((0<<9) | (1<<8) | 3));
	    NFC_SET_CORE_PLL(((2<<9) | (1<<8) | 1));
	}	
	
    return;
#endif
    
    unit = 10000; // 10000 as 1 MHz, 0.1 kHz resolution.
    for (i=0; i<4; i++)
        fclk[i] = 2551*unit/div[i];

    fclk[4] = 24*unit;
    fclk[5] = 0*unit;
    fclk[6] = 350*unit;

    clk_cfg.d32 = 0;

    if (clk_freq > 0) {
        clk_cfg.b.clk_en = 1;
        if (clk_freq <= 1000) 
            clk_freq = clk_freq*unit;
        else
            clk_freq = clk_freq*unit/1000;

        best_err = fclk[0];
        best_freq = 0;
        best_div = 0;
        best_sel = 0;
        for (i=0; i<7; i++) {
            for (j=1; j<2; j++) {
                tmp_div = (fclk[i] + j*(clk_freq - 1))/clk_freq - 1;
                if (tmp_div < 0) tmp_div = 0;
                if (tmp_div > 127) continue;
                tmp_freq = fclk[i] / (tmp_div + 1);
                tmp_err = abs(clk_freq - tmp_freq);
                if (tmp_err < best_err ||
                    (tmp_err == best_err && tmp_div%2 == 1 &&
                    best_div%2 == 0 && best_div>0)) {
                    best_err = tmp_err;
                    best_freq = tmp_freq;
                    best_div = tmp_div;
                    best_sel = i;
                }
            }
        }

        clk_cfg.b.clk_div = best_div;
        clk_cfg.b.clk_sel = best_sel;
        aml_nand_msg("Set nand core clock %3d MHz : sel %d  div %2d  actual %3d MHz", 
                  clk_freq/unit, best_sel, best_div, best_freq/unit);
    }
    else {
        clk_cfg.b.clk_en = 0;
    }
    
    NFC_SET_CORE_PLL(clk_cfg.d32);

	//WRITE_CBUS_REG(HHI_NAND_CLK_CNTL, clk_cfg.d32);

}
#endif

void get_sys_clk_rate(int * rate)
{
#ifndef AML_NAND_UBOOT
	struct clk *sys_clk;
#endif	

#ifdef CONFIG_NAND_AML_M8
#ifdef AML_NAND_DBG_M8   
	//set_nand_core_clk(160); 
	//*rate = 160000000;  //160M

	//set_nand_core_clk(182); 
	//*rate = 182000000;  //
	
	//set_nand_core_clk(212); 
	//*rate = 212000000;  //
		
	set_nand_core_clk(*rate); 
	//set_nand_core_clk(255); 
	//*rate = 255000000;  //		
	
#else
	set_nand_core_clk(200*10000); 
	//*rate = 200*1000000;
#endif
#else
	#ifndef AML_NAND_UBOOT
		sys_clk = clk_get_sys(NAND_SYS_CLK_NAME, NULL);
		*rate = clk_get_rate(sys_clk);
	#else
		*rate = get_clk81();
	#endif
#endif

}

 void nand_boot_info_prepare(struct amlnand_phydev *phydev, unsigned char * page0_buf)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
	struct nand_flash *flash = &(aml_chip->flash);
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller); 
	struct en_slc_info *slc_info = &(controller->slc_info);
	
	unsigned en_slc,configure_data, pages_per_blk; 
	int chip_num=1, nand_read_info, new_nand_type, i;

	pages_per_blk = flash->blocksize / flash->pagesize;
	new_nand_type = aml_chip->flash.new_type;
	//en_slc = (( flash->new_type < 10)&&( flash->new_type))? 1:0;
	configure_data = NFC_CMD_N2M(controller->ran_mode, controller->bch_mode, 0, (controller->ecc_unit >> 3), controller->ecc_steps);	

    if(( flash->new_type < 10)&&( flash->new_type)){
        en_slc = 1;
    }
    else if(flash->new_type == SANDISK_19NM){
        en_slc = 2;
    }
    else{
       en_slc = 0; 
    }    
        
#ifdef CONFIG_NAND_AML_M8
	
	memset(page0_buf, 0x0, flash->pagesize);

	struct nand_page0_cfg_t *info_cfg = (struct nand_page0_cfg_t *)page0_buf;
	struct nand_page0_info_t *info = (struct nand_page0_info_t *)((page0_buf+384)-sizeof(struct nand_page0_info_t));

	info_cfg->ext = (configure_data|(1<<23) |(1<<22) | (2<<20) |(1<<19));

	//need finish here for romboot retry
	info_cfg->id = 0;
	info_cfg->max =0;

    memset((unsigned char *)(&info_cfg->list[0]), 0, NAND_PAGELIST_CNT);
	
	if(en_slc){
	    info_cfg->ext |= (1<<26);
	    if(en_slc == 1){
		    memcpy((unsigned char *)(&info_cfg->list[0]), (unsigned char *)(&slc_info->pagelist[1]), NAND_PAGELIST_CNT);
		}		
	    else if(en_slc == 2){
	        info_cfg->ext |= (1<<24);
	        for(i=1;i<NAND_PAGELIST_CNT;i++)
	            info_cfg->list[i-1] = i<<1;
		}		
	}

		

	chip_num = controller->chip_num;
	aml_nand_msg("chip_num %d controller->chip_num %d",chip_num,controller->chip_num);
	nand_read_info = chip_num;	// chip_num occupy the lowest 2 bit

	info->nand_read_info = nand_read_info;
	info->pages_in_block = pages_per_blk;
	info->new_nand_type = new_nand_type;
#else

	memset(page0_buf, 0xbb, flash->pagesize);
	memcpy(page0_buf, (unsigned char *)(&configure_data), sizeof(int));
	memcpy(page0_buf + sizeof(int), (unsigned char *)(&pages_per_blk), sizeof(int));	
	new_nand_type = aml_chip->flash.new_type;
	memcpy(page0_buf +2* sizeof(int), (unsigned char *)(&new_nand_type), sizeof(int));

	chip_num = controller->chip_num;
	nand_read_info = chip_num;	// chip_num occupy the lowest 2 bit
	memcpy(page0_buf +3* sizeof(int), (unsigned char *)(&nand_read_info), sizeof(int));
#endif

}

void uboot_set_ran_mode(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;	
	struct hw_controller *controller = &(aml_chip->controller); 

#ifdef CONFIG_NAND_AML_M8
	controller->ran_mode = 1;
#else
	controller->ran_mode = 0;
#endif
	
}

int aml_sys_info_init(struct amlnand_chip *aml_chip)
{
	nand_arg_info * nand_key = &aml_chip->nand_key;  
	nand_arg_info  * nand_secure= &aml_chip->nand_secure;
	nand_arg_info *  uboot_env =  &aml_chip->uboot_env;
	unsigned char *buf = NULL;
	unsigned int buf_size = MAX(CONFIG_SECURE_SIZE,CONFIG_KEYSIZE);
	int ret =0;
	
	buf = aml_nand_malloc(buf_size);
	if(!buf){
		aml_nand_msg("aml_sys_info_init : malloc failed");
	}
	memset(buf,0x0,buf_size);
	
#ifdef CONFIG_SECURITYKEY
		if(nand_key->arg_valid == 0){
			ret = aml_key_init(aml_chip);
			if(ret < 0){
				aml_nand_msg("nand key init failed");
			goto exit_error;
			}
		}
#endif

#ifdef CONFIG_SECURE_NAND
		if(nand_secure->arg_valid == 0){
			ret = aml_secure_init(aml_chip);
			if(ret < 0){
				aml_nand_msg("nand secure init failed");
			goto exit_error;
			}
		}
#endif

	if((uboot_env->arg_valid == 0) && (boot_device_flag == 1)){
		ret = aml_ubootenv_init(aml_chip);
		if(ret < 0){
			aml_nand_msg("nand uboot env init failed");
			goto exit_error;
		}
	}
	
#ifdef CONFIG_SECURITYKEY
	if(nand_key->arg_valid == 0){
		ret = amlnand_save_info_by_name(aml_chip,&(aml_chip->nand_key),buf, KEY_INFO_HEAD_MAGIC,CONFIG_KEYSIZE);
		if(ret < 0){
			aml_nand_msg("nand save default key failed");
			goto exit_error;
		}
	}
#endif

#ifdef CONFIG_SECURE_NAND
	if(nand_secure->arg_valid == 0){
		ret = amlnand_save_info_by_name(aml_chip,&(aml_chip->nand_secure),buf, SECURE_INFO_HEAD_MAGIC,CONFIG_SECURE_SIZE);
		if(ret < 0){
			aml_nand_msg("nand save default secure_ptr failed");
			goto exit_error;
		}
	}
#endif
	
exit_error:

	if(buf){
		kfree(buf);
		buf = NULL;
	}		
	
	return ret;
}

int aml_sys_info_error_handle(struct amlnand_chip *aml_chip)
{

#ifdef CONFIG_SECURITYKEY
		 if((aml_chip->nand_key.arg_valid == 1) && (aml_chip->nand_key.update_flag)){
			aml_nand_update_key(aml_chip,NULL);
			aml_chip->nand_key.update_flag = 0;
			aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"nandkey",aml_chip->nand_key.arg_valid, aml_chip->nand_key.valid_blk_addr, aml_chip->nand_key.valid_page_addr);
		}
#endif 
	
#ifdef CONFIG_SECURE_NAND
		 if((aml_chip->nand_secure.arg_valid == 1) && (aml_chip->nand_secure.update_flag)){
			aml_nand_update_secure(aml_chip,NULL);
			aml_chip->nand_secure.update_flag = 0;
			aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"nandsecure",aml_chip->nand_secure.arg_valid, aml_chip->nand_secure.valid_blk_addr, aml_chip->nand_secure.valid_page_addr);
		}
#endif

		 if((aml_chip->uboot_env.arg_valid == 1) && (aml_chip->uboot_env.update_flag)){
			aml_nand_update_ubootenv(aml_chip,NULL);
			aml_chip->uboot_env.update_flag = 0;
			aml_nand_msg("NAND UPDATE CKECK  : arg %s: arg_valid= %d, valid_blk_addr = %d, valid_page_addr = %d",\
					"ubootenv",aml_chip->uboot_env.arg_valid, aml_chip->uboot_env.valid_blk_addr, aml_chip->uboot_env.valid_page_addr);
		}

	return 0;
}
#ifdef AML_NAND_UBOOT
void amlnf_disprotect(uchar * name)
{
	struct amlnand_chip *aml_chip = aml_nand_chip;

#ifdef CONFIG_SECURITYKEY
	if(strcmp(name, "key") == 0){
		aml_nand_msg("disprotect key");
		info_disprotect |= DISPROTECT_KEY;
	}
#endif

#ifdef CONFIG_SECURE_NAND
	if(strcmp(name, "secure") == 0){	
		aml_nand_msg("disprotect secure");
		info_disprotect |= DISPROTECT_SECURE;
	}
#endif

	if(strcmp(name, "fbbt") == 0){	
		aml_nand_msg("disprotect fbbt");
		info_disprotect |= DISPROTECT_FBBT;
	}
	if(strcmp(name, "hynix") == 0){ 
		aml_nand_msg("disprotect hynix");
		info_disprotect |= DISPROTECT_HYNIX;
	}

	return ;
}

#endif
