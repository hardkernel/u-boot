#include <common.h>
#include <environment.h>
#include <nand.h>
#include <asm/io.h>
#include <malloc.h>
#include "aml_mtd.h"

static struct aml_nand_chip *aml_chip_key = NULL;

int amlnf_key_read(u8 *buf, int len, uint32_t *actual_lenth)
{
	struct aml_nand_chip * aml_chip = aml_chip_key;
	struct mtd_info *mtd = &aml_chip->mtd;
	u8 *key_ptr = NULL;

	printk("%s: ####\n", __func__);

	if (aml_chip == NULL) {
		printk("%s(): amlnf key not ready yet!", __func__);
		return -EFAULT;
	}
	if (len > aml_chip->keysize) {
		printk("%s key data len too much\n",__func__);
		return -EFAULT;
	}
	key_ptr = kzalloc(aml_chip->keysize, GFP_KERNEL);
	if (key_ptr == NULL)
		return -ENOMEM;
	aml_nand_ext_read_rsv_info(mtd,
		aml_chip_key->aml_nandkey_info, 0, key_ptr);
	memcpy(buf, key_ptr, len);
	*actual_lenth = aml_chip->keysize;
	kfree(key_ptr);
	return 0;
}

int amlnf_key_write(u8 *buf, int len, uint32_t *actual_lenth)
{
	struct aml_nand_chip * aml_chip = aml_chip_key;
	struct mtd_info *mtd = &aml_chip->mtd;
	u8 *key_ptr = NULL;
	int error = 0;

	printk("%s: ####\n", __func__);
	if (aml_chip == NULL) {
		printk("%s(): amlnf key not ready yet!", __func__);
		return -EFAULT;
	}
	if (len > aml_chip->keysize) {
		printk("key data len too much,%s\n",__func__);
		return -EFAULT;
	}
	key_ptr = kzalloc(aml_chip->keysize, GFP_KERNEL);
	if (key_ptr == NULL)
		return -ENOMEM;
	memcpy(key_ptr, buf, len);
	aml_nand_ext_save_rsv_info(mtd,
		aml_chip_key->aml_nandkey_info, key_ptr);
	kfree(key_ptr);
	return error;
}

int amlnf_key_erase(void)
{
	int ret = 0;
	struct mtd_info *mtd = &aml_chip_key->mtd;

	printk("%s: ####\n", __func__);
	if (aml_chip_key == NULL) {
		printk("%s amlnf not ready yet!\n", __func__);
		return -1;
	}
	ret = aml_nand_ext_erase_rsv_info(mtd, aml_chip_key->aml_nandkey_info);
	if (ret) {
		printk("%s erase key error\n", __func__);
		ret = -EFAULT;
	}
	return ret;
}

int amlnf_ddr_parameter_read(u8 *buf, int len)
{
	struct aml_nand_chip *aml_chip = aml_chip_key;
	struct mtd_info *mtd = &aml_chip->mtd;
	u8 *key_ptr = NULL;

	printk("%s: ####\n", __func__);
	if (aml_chip == NULL) {
		printk("%s(): amlnf key not ready yet!", __func__);
		return -EFAULT;
	}
	key_ptr = malloc(2048);
	if (key_ptr == NULL)
		return -ENOMEM;
	aml_nand_ext_read_rsv_info(mtd,
		aml_chip_key->aml_nandddr_info, 0, key_ptr);
	memcpy(buf, key_ptr, len);
	free(key_ptr);
	return 0;
}

int amlnf_ddr_parameter_write(u8 *buf, int len)
{
	struct aml_nand_chip *aml_chip = aml_chip_key;
	struct mtd_info *mtd = &aml_chip->mtd;
	u8 *key_ptr = NULL;
	int error = 0;

	printk("%s: ####\n", __func__);
	if (aml_chip == NULL) {
		printk("%s(): amlnf key not ready yet!", __func__);
		return -EFAULT;
	}
	if (len > 2048) {
		printk("key data len too much,%s\n",__func__);
		return -EFAULT;
	}
	key_ptr = malloc(2048);
	if (key_ptr == NULL)
		return -ENOMEM;
	memcpy(key_ptr, buf, len);
	aml_nand_ext_save_rsv_info(mtd,
		aml_chip_key->aml_nandddr_info, key_ptr);
	free(key_ptr);
	return error;
}

int amlnf_ddr_parameter_erase(void)
{
	int ret = 0;
	struct mtd_info *mtd = &aml_chip_key->mtd;

	printk("%s: ####\n", __func__);
	if (aml_chip_key == NULL) {
		printk("%s amlnf not ready yet!\n", __func__);
		return -1;
	}
	ret = aml_nand_ext_erase_rsv_info(mtd, aml_chip_key->aml_nandddr_info);
	if (ret) {
		printk("%s erase key error\n", __func__);
		ret = -EFAULT;
	}
	return ret;
}

int aml_key_init(struct aml_nand_chip *aml_chip)
{
	aml_chip_key = aml_chip;
	return 0;
}