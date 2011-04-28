
#include "../include/phynand.h"


//#define SECURE_SIZE  (CONFIG_SECURE_SIZE - (sizeof(uint32_t)))

struct amlnand_chip *aml_chip_secure = NULL;


int aml_nand_update_secure(struct amlnand_chip * aml_chip, char *secure_ptr)
{
	int ret = 0;
	char malloc_flag = 0;
	char *secure_buf = NULL;
	
	if(secure_buf == NULL){
		
		secure_buf = kzalloc(CONFIG_SECURE_SIZE, GFP_KERNEL);
		if(secure_buf == NULL)
			return -ENOMEM;
		memset(secure_buf,0,CONFIG_SECURE_SIZE);
		ret = amlnand_read_info_by_name(aml_chip, &(aml_chip->nand_secure),secure_buf,SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
		if (ret) 
		{
			aml_nand_msg("read key error,%s\n",__func__);
			ret = -EFAULT;
			goto exit;
		}
	}else{
		secure_buf = secure_ptr;
	}
	
	ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->nand_secure), secure_buf, SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
	if(ret < 0){
		aml_nand_msg("aml_nand_update_secure : update secure failed");
	}
	
exit:	
	if(malloc_flag && (secure_buf)){
		kfree(secure_buf);
		secure_buf = NULL;
	}
	return 0;
}

 int32_t nand_secure_read(struct amlnand_chip * aml_chip, char *buf,int len)
{
	//struct amlnand_chip * aml_chip = provider->priv;
	secure_t *secure_ptr = NULL;
	int error = 0,i=0;
	if(len > CONFIG_SECURE_SIZE)
	{
		aml_nand_msg("key data len too much,%s\n",__func__);
		return -EFAULT;
	}
	secure_ptr = kzalloc(CONFIG_SECURE_SIZE, GFP_KERNEL);
	if(secure_ptr == NULL)
		return -ENOMEM;
	memset(secure_ptr,0,CONFIG_SECURE_SIZE);

	error = amlnand_read_info_by_name(aml_chip, &(aml_chip->nand_secure),secure_ptr,SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
	if (error) 
	{
		aml_nand_msg("read key error,%s\n",__func__);
		error = -EFAULT;
		goto exit;
	}
	memcpy(buf, secure_ptr->data, len);
	
exit:
	kfree(secure_ptr);
	return error;
}

int32_t nand_secure_write(struct amlnand_chip * aml_chip, char *buf,int len)
{
	secure_t *secure_ptr = NULL;
	int error = 0,i=0;

	if(len > CONFIG_SECURE_SIZE)
	{
		aml_nand_msg("key data len too much,%s\n",__func__);
		return -EFAULT;
	}
	secure_ptr = kzalloc(CONFIG_SECURE_SIZE, GFP_KERNEL);
	if(secure_ptr == NULL)
		return -ENOMEM;
	memset(secure_ptr,0,CONFIG_SECURE_SIZE);
	memcpy(secure_ptr->data + 0, buf, len);

	error = amlnand_save_info_by_name(aml_chip, &(aml_chip->nand_secure),secure_ptr,SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
	if (error) 
	{
		printk("save key error,%s\n",__func__);
		error = -EFAULT;
		goto exit;
	}
exit:
	kfree(secure_ptr);
	return error;
}


int aml_secure_init(struct amlnand_chip *aml_chip)
{
	int ret = 0;
	secure_t *secure_ptr = NULL;
	
	secure_ptr = aml_nand_malloc(CONFIG_SECURE_SIZE);
	if (secure_ptr == NULL){
		aml_nand_msg("nand malloc for secure_ptr failed");
		ret = -1;
		goto exit_error0;
	}
	memset(secure_ptr,0x0,CONFIG_SECURE_SIZE);
	aml_nand_dbg("nand secure: nand_secure_probe. ");
	
	ret = amlnand_info_init(aml_chip, &(aml_chip->nand_secure),secure_ptr,SECURE_INFO_HEAD_MAGIC, CONFIG_SECURE_SIZE);
	if(ret < 0){
		aml_nand_msg("invalid nand secure_ptr\n");
		ret = -1;
		goto exit_error0;
	}

#if 0
	aml_nand_msg("nand secure debug :: save secure again !!!!");
	ret = amlnand_save_info_by_name( aml_chip,&(aml_chip->nand_secure),secure_ptr, SECURE_INFO_HEAD_MAGIC,CONFIG_SECURE_SIZE);
	if(ret < 0){
		aml_nand_msg("nand save default secure_ptr failed aigain!!");
	}

#endif
	
	aml_chip_secure = aml_chip;

exit_error0:
	if(secure_ptr){
		aml_nand_free(secure_ptr);
		secure_ptr =NULL;
	}
	return ret;
}


#ifdef CONFIG_SECURE_NAND
int secure_storage_nand_read(char *buf,unsigned int len)
{
	 struct amlnand_chip *aml_chip = aml_chip_secure;
	int ret = 0;
	
	ret = nand_secure_read(aml_chip,buf,len);
	if(ret < 0){
		aml_nand_msg("secure storage nand read failed\n");
	}

	return ret;
}

int secure_storage_nand_write(char *buf,unsigned int len)
{
	 struct amlnand_chip *aml_chip = aml_chip_secure;
	int ret = 0;
	
	ret = nand_secure_write(aml_chip,buf,len);
	if(ret < 0){
		aml_nand_msg("secure storage nand write failed\n");
	}

	return ret;
}
#endif



