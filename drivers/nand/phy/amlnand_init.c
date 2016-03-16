/*****************************************************************
**
**  Copyright (C) 2012 Amlogic,Inc.  All rights reserved
**
**        Filename : driver_uboot.c
**        Revision : 1.001
**        Author: Benjamin Zhao
**        Description:
**			amlnand_init,  mainly init nand phy driver.
**
**
*****************************************************************/

#include "../include/phynand.h"
#include <amlogic/secure_storage.h>
#include <asm/arch/secure_apb.h>

struct amlnand_chip *aml_nand_chip = NULL;
extern int boot_dev_init(struct amlnand_chip *aml_chip);

static void show_nand_driver_version(void)
{
	aml_nand_msg("Nand PHY Ver:%d.%02d.%03d.%04d (c) 2013 Amlogic Inc.",
		(DRV_PHY_VERSION >> 24)&0xff,
		(DRV_PHY_VERSION >> 16)&0xff,
		(DRV_PHY_VERSION >> 8)&0xff,
		(DRV_PHY_VERSION)&0xff);
}
static int amlnf_phy_resource(struct amlnand_chip *aml_chip, struct platform_device *pdev)
{
	int ret = 0;
	if (aml_chip == NULL) {
		aml_nand_msg("%s() %d: invalid param!", __FUNCTION__, __LINE__);
		ret = -1;
		goto _out;
	}

#ifndef AML_NAND_UBOOT
	aml_chip->device = pdev->dev;

	aml_nand_msg("%s() %d: amlnf init flag %d",
		__FUNCTION__, __LINE__, aml_chip->init_flag);

#ifdef CONFIG_OF
	aml_chip->nand_pinctrl = devm_pinctrl_get(&aml_chip->device);
	if (IS_ERR(aml_chip->nand_pinctrl)) {
		aml_nand_msg("get pinctrl error");
		return PTR_ERR(aml_chip->nand_pinctrl);
	}
	aml_chip->nand_rbstate = pinctrl_lookup_state(aml_chip->nand_pinctrl,
		"nand_rb_mod");
	if (IS_ERR(aml_chip->nand_rbstate)) {
		devm_pinctrl_put(aml_chip->nand_pinctrl);
		return PTR_ERR(aml_chip->nand_rbstate);
	}
	aml_chip->nand_norbstate = pinctrl_lookup_state(aml_chip->nand_pinctrl,
		"nand_norb_mod");
	if (IS_ERR(aml_chip->nand_norbstate)) {
		devm_pinctrl_put(aml_chip->nand_pinctrl);
		return PTR_ERR(aml_chip->nand_norbstate);
	}
	aml_chip->nand_idlestate = pinctrl_lookup_state(aml_chip->nand_pinctrl,
		"nand_cs_pins_only");
	if (IS_ERR(aml_chip->nand_idlestate)) {
		devm_pinctrl_put(aml_chip->nand_pinctrl);
		return PTR_ERR(aml_chip->nand_idlestate);
	}
#endif /* CONFIG_OF */
#endif	/* AML_NAND_UBOOT */
_out:
	return ret;
}

extern int  dbg_amlnf_erase_ops(u64 off, u64 erase_len, unsigned char scrub_flag);
extern void amlnf_get_chip_size(u64 *size);
void dbg_erase_whole_chip(struct amlnand_chip *aml_chip)
{
	struct nand_flash *flash = &aml_chip->flash;
	u64 chipsize;

	PHY_NAND_LINE
	//amlnf_get_chip_size(&chipsize);
	chipsize = flash->blocksize * 4;	//erase 1st 60 blocks.
	PHY_NAND_LINE

	dbg_amlnf_erase_ops(0, chipsize, 1);


}

//-------------------------------------------------------------------------------------------------------------------
extern void _dump_mem(u32 * buf, u32 len);
#define DBG_OOB_LEN		(8)
static void dbg_buffer_free(struct amlnand_chip *aml_chip)
{
	if (aml_chip->user_oob_buf != NULL)
		kfree(aml_chip->user_oob_buf);

	if (aml_chip->user_page_buf != NULL)
		kfree(aml_chip->user_page_buf);
	return;
}

static void dbg_buffer_alloc(struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	u32 ret = 0, buf_size;

	buf_size = flash->oobsize * controller->chip_num;
	if (flash->option & NAND_MULTI_PLANE_MODE)
		buf_size <<= 1;

	aml_chip->user_oob_buf = aml_nand_malloc(buf_size);
	if (aml_chip->user_oob_buf == NULL) {
		aml_nand_msg("malloc failed for user_oob_buf ");
		ret = -NAND_MALLOC_FAILURE;
		goto _out;
	}
	memset(aml_chip->user_oob_buf, 0x0, buf_size);
	buf_size = (flash->pagesize + flash->oobsize) * controller->chip_num;
	if (flash->option & NAND_MULTI_PLANE_MODE)
		buf_size <<= 1;

	aml_chip->user_page_buf = aml_nand_malloc(buf_size);
	if (aml_chip->user_page_buf == NULL) {
		aml_nand_msg("malloc failed for user_page_buf ");
		ret = -NAND_MALLOC_FAILURE;
		goto _out;
	}
	memset(aml_chip->user_page_buf, 0x0, buf_size);
	return;
	if (ret) {
		aml_nand_msg("%s() ret %d", __func__, ret);
	}

_out:
	dbg_buffer_free(aml_chip);
	return;
}

void dbg_calcaddress(u8 chip, u32 blk, u32 page, struct amlnand_chip *aml_chip)
{
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	u8 phys_erase_shift, phys_page_shift;
	u32 pages_per_blk;

	phys_erase_shift = ffs(flash->blocksize) - 1;
	phys_page_shift =  ffs(flash->pagesize) - 1;
	pages_per_blk = (1 << (phys_erase_shift - phys_page_shift));

	ops_para->chipnr = chip;
	ops_para->page_addr = blk * pages_per_blk + page;
	ops_para->ooblen = DBG_OOB_LEN;

	printk("%s(%d, %d, %d) - %x\n", __func__, chip, blk, page, ops_para->page_addr);
}

void dbg_ereaeblk(u8 chip, u32 blk, struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	int ret;

	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	dbg_calcaddress(chip, blk, 0, aml_chip);

	ops_para->data_buf = aml_chip->user_page_buf;
	ops_para->oob_buf = aml_chip->user_oob_buf;

	controller->select_chip(controller, ops_para->chipnr);
	nand_get_chip(aml_chip);
	ret = operation->erase_block(aml_chip);
	if (ret < 0) {
		aml_nand_msg("%s() %d: nand erased failed", __func__, __LINE__);
	}
	nand_release_chip(aml_chip);

}

void dbg_readpage(u8 chip, u32 blk, u32 page, struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	int ret;

	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	memset(ops_para->data_buf, 0x0, flash->pagesize);
	memset(ops_para->oob_buf, 0x0, DBG_OOB_LEN);
	dbg_calcaddress(chip, blk, page, aml_chip);

	ops_para->data_buf = aml_chip->user_page_buf;
	ops_para->oob_buf = aml_chip->user_oob_buf;

	controller->select_chip(controller, ops_para->chipnr);
	nand_get_chip(aml_chip);
	ret = operation->read_page(aml_chip);
	if (ret < 0) {
		aml_nand_msg("%s() %d: nand read failed", __func__, __LINE__);
	}
	nand_release_chip(aml_chip);
	_dump_mem((u32 *)ops_para->oob_buf, DBG_OOB_LEN);
	_dump_mem((u32 *)ops_para->data_buf, 512);

}

void dbg_writepage(u8 chip, u32 blk, u32 page, struct amlnand_chip *aml_chip)
{
	struct hw_controller *controller = &aml_chip->controller;
	struct nand_flash *flash = &aml_chip->flash;
	struct chip_operation *operation = &aml_chip->operation;
	struct chip_ops_para  *ops_para = &aml_chip->ops_para;
	int ret;

	memset((u8 *)ops_para, 0x0, sizeof(struct chip_ops_para));
	dbg_calcaddress(chip, blk, page, aml_chip);

	ops_para->data_buf = aml_chip->user_page_buf;
	ops_para->oob_buf = aml_chip->user_oob_buf;

	memset(ops_para->data_buf, 0xAA, flash->pagesize);
	memset(ops_para->oob_buf, 0x55, DBG_OOB_LEN);

	controller->select_chip(controller, ops_para->chipnr);
	nand_get_chip(aml_chip);
	ret = operation->write_page(aml_chip);
	if (ret < 0) {
		aml_nand_msg("%s() %d: nand write failed", __func__, __LINE__);
	}
	nand_release_chip(aml_chip);

}

void dbg_phyop( void )
{
	/* u64 blksize; */
	struct amlnand_chip *aml_chip = aml_nand_chip;
	/* struct hw_controller *controller = &aml_chip->controller; */
	/* struct nand_flash *flash = &aml_chip->flash; */

	PHY_NAND_LINE
	dbg_buffer_alloc(aml_chip);
	PHY_NAND_LINE
#if 0
	blksize = (u64) flash->blocksize;
	PHY_NAND_LINE
	printk("erase\n");
	amlnf_erase_ops(0, blksize * 2, 1);

	printk("erase again\n");
	dbg_ereaeblk(0, 0, aml_chip);
#endif
	PHY_NAND_LINE	//write page here
	//printk("read after erase!\n");
	dbg_readpage(0, 80, 0, aml_chip);
	dbg_readpage(0, 81, 0, aml_chip);
	PHY_NAND_LINE	//read page here.
#if 0
	printk("write!\n");
	dbg_writepage(0, 0, 0, aml_chip);
	printk("read!\n");
	dbg_readpage(0, 0, 0, aml_chip);
	PHY_NAND_LINE
#endif //0
	dbg_buffer_free(aml_chip);
}

void amlnand_clear_pinmux(struct amlnand_chip *aml_chip)
{
	amlnf_clr_reg32_mask(P_PERIPHS_PIN_MUX_4,(0x7ff<<20));
	return;
}

int amlnf_phy_init(u8 flag, struct platform_device *pdev)
{
	struct amlnand_chip *aml_chip = NULL;
	int ret = 0;

	/*show nand phy version here.*/
	show_nand_driver_version();

	aml_chip = aml_nand_malloc(sizeof(struct amlnand_chip));
	if (aml_chip == NULL) {
		aml_nand_msg("malloc failed for aml_chip:%x",
			(uint32_t)sizeof(struct amlnand_chip));
		ret = -NAND_MALLOC_FAILURE;
		goto exit_error1;
	}
	memset(aml_chip , 0, sizeof(struct amlnand_chip));
	memset(aml_chip->reserved_blk, 0xff, RESERVED_BLOCK_CNT);
	aml_chip->init_flag = flag;
	aml_chip->nand_status = NAND_STATUS_NORMAL;
	aml_nand_chip = aml_chip;
	PHY_NAND_LINE
	ret = amlnf_phy_resource(aml_chip, pdev);
	if (ret)
		goto exit_error1;

	PHY_NAND_LINE
	/* Step 1: init hw controller */
	ret = amlnand_hwcontroller_init(aml_chip);
	if (ret < 0) {
		aml_nand_msg("aml_hw_controller_init failed");
		ret = -NAND_FAILED;
		goto exit_error1;
	}
	PHY_NAND_LINE
	/* Step 2: init aml_chip operation */
	ret = amlnand_init_operation(aml_chip);
	if (ret < 0) {
		aml_nand_msg("chip detect failed and ret:%x", ret);
		ret = -NAND_FAILED;
		goto exit_error1;
	}
	PHY_NAND_LINE
	/* Step 3: get nand id and get hw flash information */
	ret = amlnand_chip_init(aml_chip);
	if (ret < 0) {
		aml_nand_msg("chip detect failed and ret:%x", ret);
		device_boot_flag = EMMC_BOOT_FLAG;
		amlnand_clear_pinmux(aml_chip);
		ret = -NAND_FAILED;
		goto exit_error1;
	}
	PHY_NAND_LINE
	/* update device_boot_flag for outsides */
	device_boot_flag = NAND_BOOT_FLAG;
	/* write 2 gp2*/
	secure_storage_set_info(STORAGE_DEV_NAND);

	PHY_NAND_LINE
	if (aml_chip->init_flag == NAND_SCAN_ID_INIT)
		goto exit_error1;
	PHY_NAND_LINE

	//fixme, debug code
	//dbg_phyop(aml_chip);
	//dbg_erase_whole_chip(aml_chip);

	/* step 3.5 init boot phydev 1st, then we can operate uboot no matter what happens further.*/
	boot_dev_init(aml_chip);
	if (aml_chip->init_flag == 6) {	//NAND_PHY_INIT
			PHY_NAND_LINE
			goto exit_error0;
	}

	//Step 4: get device configs
	ret = amlnand_get_dev_configs(aml_chip);
	if (ret < 0) {
		if ((ret == -NAND_CONFIGS_FAILED) || (ret == -NAND_SHIPPED_BADBLOCK_FAILED)
				|| (ret == -NAND_DETECT_DTB_FAILED)) {
			aml_nand_msg("get device configs failed and ret:%x", ret);
			goto exit_error0;
		}else{
			aml_nand_msg("get device configs failed and ret:%x", ret);
			ret = -NAND_READ_FAILED;
			goto exit_error0;
		}
	}
	PHY_NAND_LINE
	if (aml_chip->init_flag >= NAND_BOOT_ERASE_PROTECT_CACHE) {
		struct hw_controller *controller = &aml_chip->controller;
#ifndef AML_NAND_UBOOT
		struct nand_flash *flash = &aml_chip->flash;

		amlnf_dma_free(controller->data_buf, (flash->pagesize + flash->oobsize), 0);
		amlnf_dma_free(controller->user_buf, (flash->pagesize /controller->ecc_bytes)*sizeof(int), 1);
#else /* AML_NAND_UBOOT */
		aml_nand_free(controller->data_buf);
		aml_nand_free(controller->user_buf);
#endif /* AML_NAND_UBOOT */
		aml_nand_free(controller->page_buf);
		aml_nand_free(controller->oob_buf);

		//nand_buf_free(aml_chip);
		/*exit with error code in porpoises, while we are erasing.*/
		ret = -1;
		goto exit_error1;
	}else{
		//Step 5: register nand device, and config device information
		PHY_NAND_LINE
		ret = amlnand_phydev_init(aml_chip);
		PHY_NAND_LINE
		if (ret < 0) {
			aml_nand_msg("register nand device failed and ret:%x", ret);
			ret = -NAND_READ_FAILED;
			goto exit_error0;
		}
	}
	return ret;

exit_error1:
	aml_nand_free(aml_chip);
exit_error0:

	return ret;
}

