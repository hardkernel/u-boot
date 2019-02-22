#include <common.h>
#include <environment.h>
#include <nand.h>
#include <asm/io.h>
#include <malloc.h>
#include "aml_mtd.h"

struct aml_nand_chip *aml_chip_env = NULL;

int amlnand_save_info_by_name_mtd(struct aml_nand_chip *aml_chip,
	unsigned char *buf, int size)
{
	struct mtd_info *mtd = &aml_chip->mtd;

	aml_nand_ext_save_rsv_info(mtd,
		aml_chip->aml_nandenv_info, buf);
	return 0;
}

int amlnand_read_info_by_name_mtd(struct aml_nand_chip *aml_chip,
	unsigned char *buf, int size)
{
	struct mtd_info *mtd = &aml_chip->mtd;

	aml_nand_ext_read_rsv_info(mtd,
		aml_chip->aml_nandenv_info, 0, buf);
	return 0;
}

int amlnf_env_save(u8 *buf, int len)
{
	u8 *env_buf = NULL;
	int ret = 0;

	printk("uboot env amlnf_env_save : ####\n");
	if (aml_chip_env == NULL) {
		printk("uboot env not init yet!,%s\n", __func__);
		return -EFAULT;
	}

	if (len > CONFIG_ENV_SIZE) {
		printk("uboot env data len too much,%s\n", __func__);
		return -EFAULT;
	}
	env_buf = kzalloc(CONFIG_ENV_SIZE, GFP_KERNEL);
	if (env_buf == NULL) {
		printk("nand malloc for uboot env failed\n");
		ret = -1;
		goto exit_err;
	}

	memcpy(env_buf, buf, len);
	ret = amlnand_save_info_by_name_mtd(aml_chip_env,
		env_buf,
		CONFIG_ENV_SIZE);
	if (ret) {
		printk("nand uboot env error,%s\n", __func__);
		ret = -EFAULT;
		goto exit_err;
	}
exit_err:
	kfree(env_buf);
	return ret;
}


int amlnf_env_read(u8 *buf, int len)
{
	u8 *env_buf = NULL;
	int ret = 0;

	printk("uboot env amlnf_env_read : ####\n");
	if (len > CONFIG_ENV_SIZE) {
		printk("uboot env data len too much,%s\n", __func__);
		return -EFAULT;
	}
	if (aml_chip_env == NULL) {
		memset(buf, 0x0, len);
		printk("uboot env arg_valid = 0 invalid,%s\n", __func__);
		return 0;
	}
	env_buf = kzalloc(CONFIG_ENV_SIZE, GFP_KERNEL);
	if (env_buf == NULL) {
		printk("nand malloc for uboot env failed\n");
		ret = -1;
		goto exit_err;
	}
	ret = amlnand_read_info_by_name_mtd(aml_chip_env,
		(u8 *)env_buf,
		CONFIG_ENV_SIZE);
	if (ret) {
		printk("nand uboot env error,%s\n", __func__);
		ret = -EFAULT;
		goto exit_err;
	}
	memcpy(buf, env_buf, len);
exit_err:
	kfree(env_buf);
	return ret;
}

int aml_ubootenv_init(struct aml_nand_chip *aml_chip)
{
	aml_chip_env = aml_chip;
	return 0;
}



