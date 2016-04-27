
/*
 * Aml
 *
 * (C) 2012 8
 */
#include "../include/phynand.h"
#include <asm/arch/secure_apb.h>
#include <asm/cpu_id.h>

extern int aml_ubootenv_init(struct amlnand_chip *aml_chip);
#if (AML_CFG_DTB_RSV_EN)
extern int amlnf_dtb_init(struct amlnand_chip *aml_chip);
#endif
extern int amlnand_save_info_by_name(struct amlnand_chip *aml_chip,unsigned char * info,unsigned char * buf, u8 * name,unsigned size);
extern int aml_nand_update_key(struct amlnand_chip * aml_chip, char *key_ptr);
extern int aml_nand_update_ubootenv(struct amlnand_chip * aml_chip, char *env_ptr);

#ifdef AML_NAND_UBOOT
struct list_head nf_dev_list;
struct list_head nlogic_dev_list;
#endif /* AML_NAND_UBOOT */

struct bch_desc bch_list_m8[MAX_ECC_MODE_NUM] = {
	[0] = ECC_INFORMATION("NAND_RAW_MODE",
		NAND_ECC_SOFT_MODE,
		0,
		0,
		0,
		0),
	[1] = ECC_INFORMATION("NAND_BCH8_MODE",
		NAND_ECC_BCH8_MODE,
		NAND_ECC_UNIT_SIZE,
		NAND_BCH8_ECC_SIZE,
		2,
		1),
	[2] = ECC_INFORMATION("NAND_BCH8_1K_MODE" ,
		NAND_ECC_BCH8_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH8_1K_ECC_SIZE,
		2,
		2),
	[3] = ECC_INFORMATION("NAND_BCH24_1K_MODE" ,
		NAND_ECC_BCH24_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH24_1K_ECC_SIZE,
		2,
		3),
	[4] = ECC_INFORMATION("NAND_BCH30_1K_MODE" ,
		NAND_ECC_BCH30_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH30_1K_ECC_SIZE,
		2,
		4),
	[5] = ECC_INFORMATION("NAND_BCH40_1K_MODE" ,
		NAND_ECC_BCH40_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH40_1K_ECC_SIZE,
		2,
		5),
	[6] = ECC_INFORMATION("NAND_BCH50_1K_MODE" ,
		NAND_ECC_BCH50_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH50_1K_ECC_SIZE,
		2,
		6),
	[7] = ECC_INFORMATION("NAND_BCH60_1K_MODE" ,
		NAND_ECC_BCH60_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH60_1K_ECC_SIZE,
		2,
		7),
	[8] = ECC_INFORMATION("NAND_SHORT_MODE" ,
		NAND_ECC_SHORT_MODE,
		NAND_ECC_UNIT_SHORT,
		NAND_BCH60_1K_ECC_SIZE,
		2,
		8),
};

struct bch_desc bch_list[MAX_ECC_MODE_NUM] = {
	[0] = ECC_INFORMATION("NAND_RAW_MODE",
		NAND_ECC_SOFT_MODE,
		0,
		0,
		0,
		0),
	[1] = ECC_INFORMATION("NAND_BCH8_MODE",
		NAND_ECC_BCH8_MODE,
		NAND_ECC_UNIT_SIZE,
		NAND_BCH8_ECC_SIZE,
		2,
		1),
	[2] = ECC_INFORMATION("NAND_BCH8_1K_MODE" ,
		NAND_ECC_BCH8_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH8_1K_ECC_SIZE,
		2,
		2),
	[3] = ECC_INFORMATION("NAND_BCH16_1K_MODE" ,
		NAND_ECC_BCH16_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH16_1K_ECC_SIZE,
		2,
		3),
	[4] = ECC_INFORMATION("NAND_BCH24_1K_MODE" ,
		NAND_ECC_BCH24_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH24_1K_ECC_SIZE,
		2,
		4),
	[5] = ECC_INFORMATION("NAND_BCH30_1K_MODE" ,
		NAND_ECC_BCH30_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH30_1K_ECC_SIZE,
		2,
		5),
	[6] = ECC_INFORMATION("NAND_BCH40_1K_MODE" ,
		NAND_ECC_BCH40_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH40_1K_ECC_SIZE,
		2,
		6),
	[7] = ECC_INFORMATION("NAND_BCH60_1K_MODE" ,
		NAND_ECC_BCH60_1K_MODE,
		NAND_ECC_UNIT_1KSIZE,
		NAND_BCH60_1K_ECC_SIZE,
		2,
		7),
	[8] = ECC_INFORMATION("NAND_SHORT_MODE" ,
		NAND_ECC_SHORT_MODE,
		NAND_ECC_UNIT_SHORT,
		NAND_BCH60_1K_ECC_SIZE,
		2,
		8),
};


#ifndef AML_NAND_UBOOT
static dma_addr_t nfdata_dma_addr;
static dma_addr_t nfinfo_dma_addr;
spinlock_t amlnf_lock;
wait_queue_head_t amlnf_wq;
#endif

struct list_head nphy_dev_list;
struct list_head nf_dev_list;

void *aml_nand_malloc(u32 size)
{
	return kmalloc(size, GFP_KERNEL);
}

void aml_nand_free(void *ptr)
{
	kfree(ptr);
}

#ifndef AML_NAND_UBOOT
void *amlnf_dma_malloc(uint32 size, unsigned char flag)
{
	if (flag == 0) //data
		return dma_alloc_coherent(NULL, size, &nfdata_dma_addr, GFP_KERNEL);
	if (flag == 1) //usr
		return dma_alloc_coherent(NULL, size, &nfinfo_dma_addr, GFP_KERNEL);
}

void amlnf_dma_free(const void *ptr, u32 size, u8 flag)
{
	if (flag == 0) /* data */
		dma_free_coherent(NULL, size, (void *)ptr, nfdata_dma_addr);
	if (flag == 1) /* usr */
		dma_free_coherent(NULL, size, (void *)ptr, nfinfo_dma_addr);
}
#endif

/*
 * under os.
 */
#ifndef AML_NAND_UBOOT
int amlphy_prepare(u32 flag)
{
	spin_lock_init(&amlnf_lock);
	init_waitqueue_head(&amlnf_wq);

	return 0;
}

int phydev_suspend(struct amlnand_phydev *phydev)
{
    struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;
#ifdef AML_NAND_RB_IRQ
	u32 flags;
#endif

	if (!strncmp((char *)phydev->name,
			NAND_BOOT_NAME,
			strlen((const char *)NAND_BOOT_NAME)))
		return 0;
	aml_nand_dbg("phydev_suspend: entered!");
#ifdef AML_NAND_RB_IRQ
	spin_lock_irqsave(&amlnf_lock, flags);
#else
	spin_lock(&amlnf_lock);
#endif
	set_chip_state(aml_chip, CHIP_PM_SUSPENDED);
#ifdef AML_NAND_RB_IRQ
	spin_unlock_irqrestore(&amlnf_lock, flags);
#else
	spin_unlock(&amlnf_lock);
#endif
	return 0;

}

void phydev_resume(struct amlnand_phydev *phydev)
{
	amlchip_resume(phydev);
	return;
}

int nand_idleflag = 0;
#define	NAND_CTRL_NONE_RB	(1<<1)
void nand_get_chip(void *chip)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)chip;
	struct hw_controller *controller = &(aml_chip->controller);
	int retry = 0, ret;

	while (1) {
		/* mutex_lock(&spi_nand_mutex); */
		nand_idleflag = 1;
		if ((controller->option & NAND_CTRL_NONE_RB) == 0)
			ret = pinctrl_select_state(aml_chip->nand_pinctrl ,
				aml_chip->nand_rbstate);
		else
			ret = pinctrl_select_state(aml_chip->nand_pinctrl ,
				aml_chip->nand_norbstate);
		if (ret < 0)
			aml_nand_msg("%s:%d %s can't get pinctrl",
				__func__,
				__LINE__,
				dev_name(&aml_chip->device));
		else
			break;

		if (retry++ > 10)
			aml_nand_msg("get pin fail over 10 times retry=%d",
				retry);
	}
	return;
}

void nand_release_chip(void *chip)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)chip;
	struct hw_controller *controller = &(aml_chip->controller);
	int ret;

	if (nand_idleflag) {
		/* enter standby state. */
		controller->enter_standby(controller);
		ret = pinctrl_select_state(aml_chip->nand_pinctrl,
			aml_chip->nand_idlestate);
		if (ret < 0)
			aml_nand_msg("select idle state error");
		nand_idleflag = 0;
		/* mutex_unlock(&spi_nand_mutex); */
	}
}

/**
 * amlnand_get_device - [GENERIC] Get chip for selected access
 *
 * Get the device and lock it for exclusive access
 */
int amlnand_get_device(struct amlnand_chip *aml_chip,
	enum chip_state_t new_state)
{
#ifdef AML_NAND_RB_IRQ
	u32 flags;
#endif
	DECLARE_WAITQUEUE(wait, current);
retry:
#ifdef AML_NAND_RB_IRQ
	spin_lock_irqsave(&amlnf_lock, flags);
#else
	spin_lock(&amlnf_lock);
#endif
	if (get_chip_state(aml_chip) == CHIP_READY) {
		set_chip_state(aml_chip, new_state);
#ifdef AML_NAND_RB_IRQ
		spin_unlock_irqrestore(&amlnf_lock, flags);
#else
		spin_unlock(&amlnf_lock);
#endif
		/* set nand pinmux here */
		nand_get_chip(aml_chip);
		return 0;
	}
	set_current_state(TASK_UNINTERRUPTIBLE);
	add_wait_queue(&amlnf_wq, &wait);
#ifdef AML_NAND_IRQ_MODE
	spin_unlock_irqrestore(&amlnf_lock, flags);
#else
	spin_unlock(&amlnf_lock);
#endif
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
void amlnand_release_device(struct amlnand_chip *aml_chip)
{
#ifdef AML_NAND_RB_IRQ
	u32 flags;
#endif
	/* Release the controller and the chip */
#ifdef AML_NAND_RB_IRQ
	spin_lock_irqsave(&amlnf_lock, flags);
#else
	spin_lock(&amlnf_lock);
#endif
	set_chip_state(aml_chip, CHIP_READY);
	wake_up(&amlnf_wq);
#ifdef AML_NAND_RB_IRQ
	spin_unlock_irqrestore(&amlnf_lock, flags);
#else
	spin_unlock(&amlnf_lock);
#endif
	/* clear nand pinmux here */
	nand_release_chip(aml_chip);
}

#else /* AML_NAND_UBOOT, uboot ways below */

void nand_get_chip(void *chip)
{
	/* fixme, */
	cpu_id_t cpu_id = get_cpu_id();

	/* pull up enable */
	aml_nand_dbg("PAD_PULL_UP_EN_REG2 0x%x, PAD_PULL_UP_REG2 0x%x, PERIPHS_PIN_MUX_4 0x%x", P_PAD_PULL_UP_EN_REG2, P_PAD_PULL_UP_REG2, P_PERIPHS_PIN_MUX_4);

	AMLNF_SET_REG_MASK(P_PAD_PULL_UP_EN_REG2, 0x87ff);
	/* pull direction, dqs pull down */
	AMLNF_SET_REG_MASK(P_PAD_PULL_UP_REG2, 0x8700);
	/* switch pinmux */
	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXL) {
		AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_7,
			((0x7 << 28) | (0x1FF << 15) | (0xF << 10)));
		AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_7, ((0x1<<31) | 0xff));
	} else if (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXBB) {
		AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_4, ((0x1<<30) | (0x3ff<<20)));
		AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_0, (0x1 << 19));
		AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_4, (0x3 << 18));
		AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_5, (0xF));
	}
	aml_nand_dbg("PAD_PULL_UP_EN_REG2 0x%x, PAD_PULL_UP_REG2 0x%x, PERIPHS_PIN_MUX_4 0x%x", AMLNF_READ_REG(P_PAD_PULL_UP_EN_REG2), AMLNF_READ_REG(P_PAD_PULL_UP_REG2), AMLNF_READ_REG(P_PERIPHS_PIN_MUX_4));
	return ;
}

void nand_release_chip(void *chip)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)chip;
	struct hw_controller * controller;
	cpu_id_t cpu_id = get_cpu_id();

	controller = &aml_chip->controller;
	NFC_SEND_CMD_STANDBY(controller, 5);
	/* do not release cs0 & cs1 */
	//fixme,
	if (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXL) {
		//AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_7, ((0x1<<30) | (0x3f << 30)));
	} else if (cpu_id.family_id == MESON_CPU_MAJOR_ID_GXBB) {
		//AMLNF_CLEAR_REG_MASK(P_PERIPHS_PIN_MUX_2, ((0x33f<<20) | (0x1<< 30)));
	}
	return;
}

int amlnand_get_device(struct amlnand_chip *aml_chip, enum chip_state_t new_state)
{
	nand_get_chip(aml_chip);
	set_chip_state(aml_chip, new_state);
	return 0;
}

 void amlnand_release_device(struct amlnand_chip *aml_chip)
{
	 set_chip_state(aml_chip, CHIP_READY);
	//clear nand pinmux here
	nand_release_chip(aml_chip);
}
#endif


void pinmux_select_chip(unsigned ce_enable, unsigned rb_enable, unsigned flag)
{
#ifdef AML_NAND_UBOOT
	if (!((ce_enable >> 10) & 1))
		AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_4, (1 << 26));
	if (!((ce_enable >> 10) & 2))
		AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_4, (1 << 27));
	if (!((ce_enable >> 10) & 4))
		AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_4, (1 << 28));
	if (!((ce_enable >> 10) & 8))
		AMLNF_SET_REG_MASK(P_PERIPHS_PIN_MUX_4, (1 << 29));

#endif /*  */

}

void set_nand_core_clk(struct hw_controller *controller, int clk_freq)
{
	if (get_cpu_type() == MESON_CPU_MAJOR_ID_GX) {
		/* basic test code for gxb using 24Mhz, fixme. */
		//amlnf_write_reg32(controller->nand_clk_reg, 0x81000201); //24Mhz/1
		if (clk_freq == 200) {
			/* 1000Mhz/5 = 200Mhz */
			amlnf_write_reg32(controller->nand_clk_reg, 0x81000245);
		}
		else if (clk_freq == 250) {
			/* 1000Mhz/4 = 250Mhz */
			amlnf_write_reg32(controller->nand_clk_reg, 0x81000244);
		} else {
			/* 1000Mhz/5 = 200Mhz */
			amlnf_write_reg32(controller->nand_clk_reg, 0x81000245);
			printk("%s() %d, using default clock setting!\n", __func__, __LINE__);
		}
		//printk("clk_reg 0x%x\n", AMLNF_READ_REG(controller->nand_clk_reg));
		return;
	} else {
		printk("cpu type can not support!\n");
	}
	return;
}

void get_sys_clk_rate(struct hw_controller *controller, int *rate)
{
	u32 cpu_type;
#ifndef AML_NAND_UBOOT
	struct clk *sys_clk;
#endif

	cpu_type = get_cpu_type();
	if (cpu_type >= MESON_CPU_MAJOR_ID_M8) {
		/* 200-250Mhz */
		set_nand_core_clk(controller, *rate);
	}
	return;
}

/*
	set nand info into page0_buf
 */
void nand_boot_info_prepare(struct amlnand_phydev *phydev,
	u8 *page0_buf)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;
	struct nand_flash *flash = &(aml_chip->flash);
	struct phydev_ops *devops = &(phydev->ops);
	struct hw_controller *controller = &(aml_chip->controller);
	struct en_slc_info *slc_info = NULL;
	int i, nand_read_info;
	u32 en_slc, configure_data;
	u32 boot_num = 1, each_boot_pages;
	u32 valid_pages = BOOT_COPY_NUM * BOOT_PAGES_PER_COPY;

	nand_page0_t * p_nand_page0 = NULL;
	ext_info_t * p_ext_info = NULL;
	nand_setup_t * p_nand_setup = NULL;

	slc_info = &(controller->slc_info);

	p_nand_page0 = (nand_page0_t *) page0_buf;
	p_nand_setup = &p_nand_page0->nand_setup;
	p_ext_info = &p_nand_page0->ext_info;


	configure_data = NFC_CMD_N2M(controller->ran_mode,
			controller->bch_mode, 0, (controller->ecc_unit >> 3),
			controller->ecc_steps);
	/* hynix 2x and lower... */
	if ((flash->new_type < 10) && (flash->new_type))
		en_slc = 1;
	else if (flash->new_type == SANDISK_19NM)
		en_slc = 2;
	else
		en_slc = 0;

	//memset(page0_buf, 0x0, flash->pagesize);
	memset(p_nand_page0, 0x0, sizeof(nand_page0_t));
	p_nand_setup->cfg.d32 = (configure_data|(1<<23) | (1<<22) | (2<<20) | (1<<19));
	printk("cfg.d32 0x%x\n", p_nand_setup->cfg.d32);
	/* need finish here for romboot retry */
	p_nand_setup->id = 0;
	p_nand_setup->max = 0;

	memset(p_nand_page0->page_list,
		0,
		NAND_PAGELIST_CNT);
	if (en_slc) {
		p_nand_setup->cfg.b.page_list = 1;
		if (en_slc == 1) {
			memcpy(p_nand_page0->page_list,
				(u8 *)(&slc_info->pagelist[1]),
				NAND_PAGELIST_CNT);
		} else if (en_slc == 2) {
			p_nand_setup->cfg.b.a2 = 1;
			for (i = 1; i < NAND_PAGELIST_CNT; i++)
				p_nand_page0->page_list[i-1] = i<<1;
		}
	}

	/* chip_num occupy the lowest 2 bit */
	nand_read_info = controller->chip_num;

	/*
	make it
	1)calu the number of boot saved and pages each boot needs.
	2)the number is 2*n but less than 4.
	*/
	aml_nand_msg("valid_pages = %d en_slc = %d devops->len = %llx",
		valid_pages,
		en_slc, devops->len);
	valid_pages = (en_slc)?(valid_pages>>1):valid_pages;
	for (i = 1;
		i < ((valid_pages*flash->pagesize)/devops->len + 1); i++) {
		if (((valid_pages*flash->pagesize)/(2*i) >= devops->len)
				&& (boot_num < 4))
			boot_num <<= 1;
		else
			break;
	}
	each_boot_pages = valid_pages/boot_num;
	//each_boot_pages = (en_slc)?(each_boot_pages<<1):each_boot_pages;

	p_ext_info->read_info = nand_read_info;
	p_ext_info->new_type = aml_chip->flash.new_type;
	p_ext_info->page_per_blk = flash->blocksize / flash->pagesize;
	p_ext_info->ce_mask = aml_chip->ce_bit_mask;
	p_ext_info->xlc = 2;
	p_ext_info->boot_num = boot_num;
	p_ext_info->each_boot_pages = each_boot_pages;

	printk("new_type = 0x%x\n", p_ext_info->new_type);
	printk("page_per_blk = 0x%x\n", p_ext_info->page_per_blk);
	aml_nand_msg("boot_num = %d each_boot_pages = %d", boot_num,
		each_boot_pages);
}

void uboot_set_ran_mode(struct amlnand_phydev *phydev)
{
	struct amlnand_chip *aml_chip = (struct amlnand_chip *)phydev->priv;
	struct hw_controller *controller = &(aml_chip->controller);

	if (get_cpu_type() >= MESON_CPU_MAJOR_ID_M8)
		controller->ran_mode = 1;
	else
		controller->ran_mode = 0;
}

int aml_sys_info_init(struct amlnand_chip *aml_chip)
{
#if (AML_CFG_KEY_RSV_EN)
	struct nand_arg_info *nand_key = &aml_chip->nand_key;
#endif
#ifdef CONFIG_SECURE_NAND
	struct nand_arg_info *nand_secure = &aml_chip->nand_secure;
#endif
#if (AML_CFG_DTB_RSV_EN)
	struct nand_arg_info *amlnf_dtb = &aml_chip->amlnf_dtb;
#endif
	struct nand_arg_info *uboot_env =  &aml_chip->uboot_env;
	u8 *buf = NULL;
	u32 buf_size = 0;
	int ret = 0;

	NAND_LINE
	if (CONFIG_SECURE_SIZE > CONFIG_KEYSIZE)
		buf_size = CONFIG_SECURE_SIZE;
	else
		buf_size = CONFIG_KEYSIZE;
	NAND_LINE
	buf = aml_nand_malloc(buf_size);
	if (!buf)
		aml_nand_msg("aml_sys_info_init : malloc failed");

	memset(buf, 0x0, buf_size);
	NAND_LINE
#if (AML_CFG_KEY_RSV_EN)
	if (nand_key->arg_valid == 0) {
		NAND_LINE
		ret = aml_key_init(aml_chip);
		if (ret < 0) {
			aml_nand_msg("nand key init failed");
			goto exit_error;
		}
	}
#endif

#ifdef CONFIG_SECURE_NAND
	if (nand_secure->arg_valid == 0) {
		NAND_LINE
		ret = aml_secure_init(aml_chip);
		if (ret < 0) {
			aml_nand_msg("nand secure init failed");
			goto exit_error;
		}
	}
#endif
#if (AML_CFG_DTB_RSV_EN)
	if (amlnf_dtb->arg_valid == 0) {
		NAND_LINE
		ret = amlnf_dtb_init(aml_chip);
		if (ret < 0) {
			aml_nand_msg("amlnf dtb init failed");
			/* fixme, should go on! */
			//goto exit_error;
		}
	}
#endif
	NAND_LINE
	printk("boot_device_flag %d\n", boot_device_flag);
	if ((uboot_env->arg_valid == 0) && (boot_device_flag == 1)) {
		NAND_LINE
		ret = aml_ubootenv_init(aml_chip);
		if (ret < 0) {
			aml_nand_msg("nand uboot env init failed");
			goto exit_error;
		}
	}

#if (AML_CFG_KEY_RSV_EN)
	if (nand_key->arg_valid == 0) {
		NAND_LINE
		ret = amlnand_save_info_by_name(aml_chip,
			(u8 *)(&(aml_chip->nand_key)),
			buf,
			(u8 *)KEY_INFO_HEAD_MAGIC,
			CONFIG_KEYSIZE);
		NAND_LINE
		if (ret < 0) {
			aml_nand_msg("nand save default key failed");
			goto exit_error;
		}
	}
#endif

#ifdef CONFIG_SECURE_NAND
	/*save a empty value! */
	if (nand_secure->arg_valid == 0) {
		NAND_LINE
		ret = amlnand_save_info_by_name(aml_chip,
			(u8 *)&(aml_chip->nand_secure),
			buf,
			(u8 *)SECURE_INFO_HEAD_MAGIC,
			CONFIG_SECURE_SIZE);
		if (ret < 0) {
			aml_nand_msg("nand save default secure_ptr failed");
			goto exit_error;
		}
	}
#endif
#if (AML_CFG_DTB_RSV_EN)
	/* fixme, no need to save a empty dtb. */
#endif
	NAND_LINE
exit_error:
	kfree(buf);
	buf = NULL;
	return ret;
}

int aml_sys_info_error_handle(struct amlnand_chip *aml_chip)
{

#if (AML_CFG_KEY_RSV_EN)
	 if ((aml_chip->nand_key.arg_valid == 1) &&
		(aml_chip->nand_key.update_flag)) {
		aml_nand_update_key(aml_chip, NULL);
		aml_chip->nand_key.update_flag = 0;
		aml_nand_msg("NAND UPDATE CKECK  : ");
		aml_nand_msg("arg %s:arg_valid=%d,blk_addr=%d,page_addr=%d",
			"nandkey",
			aml_chip->nand_key.arg_valid,
			aml_chip->nand_key.valid_blk_addr,
			aml_chip->nand_key.valid_page_addr);
	}
#endif

#ifdef CONFIG_SECURE_NAND
	if ((aml_chip->nand_secure.arg_valid == 1)
		&& (aml_chip->nand_secure.update_flag)) {
		aml_nand_update_secure(aml_chip, NULL);
		aml_chip->nand_secure.update_flag = 0;
		aml_nand_msg("NAND UPDATE CKECK  : ");
		aml_nand_msg("arg%s:arg_valid=%d,blk_addr=%d,page_addr=%d",
			"nandsecure",
			aml_chip->nand_secure.arg_valid,
			aml_chip->nand_secure.valid_blk_addr,
			aml_chip->nand_secure.valid_page_addr);
	}
#endif

#if (AML_CFG_DTB_RSV_EN)
	if ((aml_chip->amlnf_dtb.arg_valid == 1)
		&& (aml_chip->amlnf_dtb.update_flag)) {
		aml_nand_update_dtb(aml_chip, NULL);
		aml_chip->amlnf_dtb.update_flag = 0;
		aml_nand_msg("NAND UPDATE CKECK  : ");
		aml_nand_msg("arg%s:arg_valid=%d,blk_addr=%d,page_addr=%d",
			"dtb",
			aml_chip->amlnf_dtb.arg_valid,
			aml_chip->amlnf_dtb.valid_blk_addr,
			aml_chip->amlnf_dtb.valid_page_addr);
	}
#endif
	if ((aml_chip->uboot_env.arg_valid == 1)
		&& (aml_chip->uboot_env.update_flag)) {
		aml_nand_update_ubootenv(aml_chip, NULL);
		aml_chip->uboot_env.update_flag = 0;
		aml_nand_msg("NAND UPDATE CKECK  : ");
		aml_nand_msg("arg%s:arg_valid=%d,blk_addr=%d,page_addr=%d",
			"ubootenv",
			aml_chip->uboot_env.arg_valid,
			aml_chip->uboot_env.valid_blk_addr,
			aml_chip->uboot_env.valid_page_addr);
	}
	return 0;
}

#ifdef AML_NAND_UBOOT
/*fixme, */
extern int info_disprotect;

void amlnf_disprotect(char * name)
{
	//struct amlnand_chip *aml_chip = aml_nand_chip;

/* #ifdef CONFIG_SECURITYKEY */
	if (strcmp((const char *)name, "key") == 0) {
		aml_nand_msg("disprotect key");
		info_disprotect |= DISPROTECT_KEY;
		aml_nand_chip->protect |= DISPROTECT_KEY;
	}
/*#endif */

#ifdef CONFIG_SECURE_NAND
	if (strcmp((const char *)name, "secure") == 0) {
		aml_nand_msg("disprotect secure");
		info_disprotect |= DISPROTECT_SECURE;
		aml_nand_chip->protect |= DISPROTECT_SECURE;
	}
#endif

	if (strcmp((const char *)name, "fbbt") == 0) {
		aml_nand_msg("disprotect fbbt");
		info_disprotect |= DISPROTECT_FBBT;
		aml_nand_chip->protect |= DISPROTECT_FBBT;
	}
	if (strcmp((const char *)name, "hynix") == 0) {
		aml_nand_msg("disprotect hynix");
		info_disprotect |= DISPROTECT_HYNIX;
		aml_nand_chip->protect |= DISPROTECT_HYNIX;
	}
	if (strcmp((const char *)name, "dbg") == 0) {
		aml_nand_msg("disprotect dbg");
		info_disprotect |= DISPROTECT_DBG;
		aml_nand_chip->protect |= DISPROTECT_DBG;
	}
	aml_nand_msg("disprotect 0x%08x", info_disprotect);
	return ;
}

#endif
