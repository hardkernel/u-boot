#include <common.h>
#include <environment.h>
#include <nand.h>
#include <asm/io.h>
#include <malloc.h>
#include "aml_mtd.h"

static struct aml_nand_chip *aml_chip_key = NULL;

struct nand_menson_key {
	u32 crc;
	u8 data[252];
};
/*
 * This funcion reads the u-boot keys.
 */
int amlnf_key_read(u8 * buf, int len, uint32_t *actual_lenth)
{
	struct aml_nand_chip * aml_chip = aml_chip_key;
	struct nand_menson_key *key_ptr = NULL;
	u32 keysize = aml_chip->keysize - sizeof(u32);
	//int error = 0;

	*actual_lenth = keysize;

	if (aml_chip == NULL) {
		printk("%s(): amlnf key not ready yet!", __func__);
		return -EFAULT;
	}

	if (len > keysize) {
		/*
		No return here! keep consistent, should memset zero
		for the rest.
		*/
		printk("%s key data len too much\n",__func__);
		memset(buf + keysize, 0 , len - keysize);
		//return -EFAULT;
	}

	key_ptr = kzalloc(aml_chip->keysize, GFP_KERNEL);
	if (key_ptr == NULL)
		return -ENOMEM;
#if 0 //fixit
	error = amlnand_read_info_by_name(aml_chip,
		(u8 *)&(aml_chip->nand_key),
		(u8 *)key_ptr,
		(u8*)KEY_INFO_HEAD_MAGIC,
		aml_chip->keysize);
	if (error) {
		printk("%s: read key error\n",__func__);
		error = -EFAULT;
		goto exit;
	}
#else
	struct mtd_info *mtd = &aml_chip->mtd;
	size_t offset = 0;
	aml_nand_read_key(mtd, offset, (u8 *)key_ptr->data);
#endif

	memcpy(buf, key_ptr->data, keysize);

//exit:
	kfree(key_ptr);
	return 0;
}

/*
 * This funcion write the keys.
 */
int amlnf_key_write(u8 *buf, int len, uint32_t *actual_lenth)
{
	struct aml_nand_chip * aml_chip = aml_chip_key;
	struct nand_menson_key *key_ptr = NULL;
	u32 keysize = aml_chip->keysize - sizeof(u32);
	int error = 0;

	if (aml_chip == NULL) {
		printk("%s(): amlnf key not ready yet!", __func__);
		return -EFAULT;
	}

	if (len > keysize) {
		/*
		No return here! keep consistent, should memset zero
		for the rest.
		*/
		printk("key data len too much,%s\n",__func__);
		memset(buf + keysize, 0 , len - keysize);
		//return -EFAULT;
	}

	key_ptr = kzalloc(aml_chip->keysize, GFP_KERNEL);
	if (key_ptr == NULL)
		return -ENOMEM;

	memcpy(key_ptr->data + 0, buf, keysize);
#if 0 //fixit
	error = amlnand_save_info_by_name(aml_chip,
		(u8 *)&(aml_chip->nand_key),
		(u8 *)key_ptr,
		(u8 *)KEY_INFO_HEAD_MAGIC,
		aml_chip->keysize);
	if (error) {
		printk("save key error,%s\n",__func__);
		error = -EFAULT;
		goto exit;
	}
#else
	struct mtd_info *mtd = &aml_chip->mtd;
	aml_nand_save_key(mtd, buf);
#endif
//exit:
	kfree(key_ptr);
	return error;
}

int amlnf_key_erase(void)
{
	int ret = 0;
	struct mtd_info *mtd = &aml_chip_key->mtd;

	if (aml_chip_key == NULL) {
		printk("%s amlnf not ready yet!\n", __func__);
		return -1;
	}

	ret = aml_nand_erase_key(mtd);
	if (ret) {
		printk("%s erase key error\n", __func__);
		ret = -EFAULT;
	}

	return ret;
}

int aml_key_init(struct aml_nand_chip *aml_chip)
{
	int ret = 0;

	/* avoid null */
	aml_chip_key = aml_chip;
#if 0 //fixit
	struct nand_menson_key *key_ptr = NULL;

	key_ptr = kzalloc(aml_chip->keysize, GFP_KERNEL);
	if (key_ptr == NULL) {
		printk("nand malloc for key_ptr failed");
		ret = -1;
		goto exit_error0;
	}
	memset(key_ptr, 0x0, aml_chip->keysize);
	printk("%s probe.\n", __func__);

	ret = amlnand_info_init(aml_chip,
		(u8 *)&(aml_chip->nand_key),
		(u8 *)key_ptr,(u8 *)KEY_INFO_HEAD_MAGIC,
		aml_chip->keysize);
	if (ret < 0) {
		printk("invalid nand key\n");
	}

exit_error0:
	if (key_ptr) {
		kfree(key_ptr);
		key_ptr =NULL;
	}
#endif
	printk("%s %d\n", __func__, __LINE__);
	return ret;
}


int aml_nand_update_key(struct aml_nand_chip * aml_chip, char *key_ptr)
{
	//int ret = 0;
	int malloc_flag = 0;
	char *key_buf = NULL;

	if (key_buf == NULL) {
		key_buf = kzalloc(aml_chip->keysize, GFP_KERNEL);
		malloc_flag = 1;
		if (key_buf == NULL)
			return -ENOMEM;
		memset(key_buf, 0, aml_chip->keysize);
#if 0 //fixit
		ret = amlnand_read_info_by_name(aml_chip,
			(u8 *)&(aml_chip->nand_key),
			(u8 *)key_buf,
			(u8 *)KEY_INFO_HEAD_MAGIC,
			aml_chip->keysize);
		if (ret) {
			printk("%s: read key error\n", __func__);
			ret = -EFAULT;
			goto exit;
		}
#endif
	} else {
		key_buf = key_ptr;
	}
#if 0 //fixit
	printk("amlnf_key : type %d, valid %d, flag %d, blk %d, page %d\n",
		aml_chip->nand_key.arg_type,aml_chip->nand_key.arg_valid,
		aml_chip->nand_key.update_flag,aml_chip->nand_key.valid_blk_addr,
		aml_chip->nand_key.valid_page_addr);

	ret = amlnand_save_info_by_name( aml_chip,
		(u8 *)&(aml_chip->nand_key),
		(u8 *)key_buf,
		(u8 *)KEY_INFO_HEAD_MAGIC,
		aml_chip->keysize);
	if (ret < 0) {
		printk("%s : save key info failed\n", __func__);
	}
#endif
//exit:
	if (malloc_flag &&(key_buf)) {
		kfree(key_buf);
		key_buf = NULL;
	}
	return 0;
}
