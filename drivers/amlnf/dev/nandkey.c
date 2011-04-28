#include "../include/phynand.h"
#ifndef AML_NAND_UBOOT
#include <linux/module.h>
#include <linux/types.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/ioport.h>
#include <linux/platform_device.h>
#include <linux/delay.h>
#include <linux/err.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/bitops.h>
#include <linux/crc32.h>
#include <linux/fs.h>
#include <asm/uaccess.h>
#include <linux/amlogic/securitykey.h>
#endif

#define KEYSIZE (CONFIG_KEYSIZE - (sizeof(uint32_t)))

static struct amlnand_chip *aml_chip_key = NULL;

 int aml_nand_update_key(struct amlnand_chip * aml_chip, char *key_ptr)
{
	int ret = 0;
	int malloc_flag = 0;
	char *key_buf = NULL;
	
	if(key_buf == NULL){
		
		key_buf = kzalloc(CONFIG_KEYSIZE, GFP_KERNEL);
		malloc_flag = 1;
		if(key_buf == NULL)
			return -ENOMEM;
		memset(key_buf,0,CONFIG_KEYSIZE);
		ret = amlnand_read_info_by_name(aml_chip, &(aml_chip->nand_key),key_buf,KEY_INFO_HEAD_MAGIC, CONFIG_KEYSIZE);
		if (ret) {
			aml_nand_msg("read key error,%s\n",__func__);
			ret = -EFAULT;
			goto exit;
		}
	}else{
		key_buf = key_ptr;
	}
	
	aml_nand_msg("aml_chip->nand_key : arg_type%d valid %d,update_flag %d,valid_blk_addr %d,valid_page_addr %d",aml_chip->nand_key.arg_type,aml_chip->nand_key.arg_valid,\
		aml_chip->nand_key.update_flag,aml_chip->nand_key.valid_blk_addr,aml_chip->nand_key.valid_page_addr);
	
	ret = amlnand_save_info_by_name( aml_chip,&(aml_chip->nand_key),key_buf, KEY_INFO_HEAD_MAGIC,CONFIG_KEYSIZE);
	if(ret < 0){
		aml_nand_msg("aml_nand_update_key : save key info failed");
	}
	
exit:
	if(malloc_flag &&(key_buf)){
		kfree(key_buf);
		key_buf = NULL;
	}	
	return 0;
}

/*
 * This funcion reads the u-boot keyionment variables. 
 * The f_pos points directly to the key location.
 */
static int32_t nand_key_read(aml_keybox_provider_t * provider, uint8_t *buf,int len,int flags)
{
	struct amlnand_chip * aml_chip = provider->priv;
	meson_key *key_ptr = NULL;
	int error = 0,i=0;
	if(len > KEYSIZE)
	{
		printk("key data len too much,%s\n",__func__);
		return -EFAULT;
	}
	key_ptr = kzalloc(CONFIG_KEYSIZE, GFP_KERNEL);
	if(key_ptr == NULL)
		return -ENOMEM;
	memset(key_ptr,0,CONFIG_KEYSIZE);

	error = amlnand_read_info_by_name(aml_chip, &(aml_chip->nand_key),key_ptr,KEY_INFO_HEAD_MAGIC, CONFIG_KEYSIZE);
	//error = aml_nand_read_key(aml_chip, (u_char *)key_ptr);
	if (error) 
	{
		printk("read key error,%s\n",__func__);
		error = -EFAULT;
		goto exit;
	}
	memcpy(buf, key_ptr->data, len);
	
exit:
	kfree(key_ptr);
	return 0;
}

static int32_t nand_key_write(aml_keybox_provider_t * provider, uint8_t *buf,int len)
{
	struct amlnand_chip * aml_chip = provider->priv;
	meson_key *key_ptr = NULL;
	int error = 0,i=0;

	if(len > KEYSIZE)
	{
		printk("key data len too much,%s\n",__func__);
		return -EFAULT;
	}
	key_ptr = kzalloc(CONFIG_KEYSIZE, GFP_KERNEL);
	if(key_ptr == NULL)
		return -ENOMEM;
	memset(key_ptr,0,CONFIG_KEYSIZE);
	memcpy(key_ptr->data + 0, buf, len);

	error = amlnand_save_info_by_name(aml_chip, &(aml_chip->nand_key),key_ptr,KEY_INFO_HEAD_MAGIC, CONFIG_KEYSIZE);
	if (error) 
	{
		printk("save key error,%s\n",__func__);
		error = -EFAULT;
		goto exit;
	}
exit:
	kfree(key_ptr);
	return error;
}

static aml_keybox_provider_t nand_provider={
	.name="nand_key",
	.read=nand_key_read,
	.write=nand_key_write,
};

int aml_key_init(struct amlnand_chip *aml_chip)
{
	int ret = 0;
	meson_key *key_ptr = NULL;
	aml_keybox_provider_t *provider; 
	
	key_ptr = aml_nand_malloc(CONFIG_KEYSIZE);
	if (key_ptr == NULL){
		aml_nand_msg("nand malloc for key_ptr failed");
		ret = -1;
		goto exit_error0;
	}
	memset(key_ptr,0x0,CONFIG_KEYSIZE);
	aml_nand_dbg("nand key: nand_key_probe. ");

	ret = amlnand_info_init(aml_chip, &(aml_chip->nand_key),key_ptr,KEY_INFO_HEAD_MAGIC, CONFIG_KEYSIZE);
	if(ret < 0){
		aml_nand_msg("invalid nand key\n");
	}
	
	aml_chip_key = aml_chip;
	nand_provider.priv=aml_chip_key;	

	provider = aml_keybox_provider_get(nand_provider.name); 
	if(provider){ 
		return ret; 
	} 
	
	ret = aml_keybox_provider_register(&nand_provider); 
	if(ret){ 
		BUG(); 
	} 
	
exit_error0:
	if(key_ptr){
		aml_nand_free(key_ptr);
		key_ptr =NULL;
	}
	return ret;
}
#ifdef AML_NAND_UBOOT
int nandkey_provider_register()
{
	int ret = 0;
#if 0 
	ret = aml_keybox_provider_register(&nand_provider);
	if(ret){
		BUG();
	}
#endif
	return ret;
}
#endif

