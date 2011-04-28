
#include "../include/phynand.h"

struct amlnand_chip *aml_chip_env = NULL;

int aml_nand_update_ubootenv(struct amlnand_chip * aml_chip, char *env_ptr)
{
	int ret = 0;
	char malloc_flag = 0;
	char *env_buf = NULL;
	
	if(env_buf == NULL){
		
		env_buf = kzalloc(CONFIG_ENV_SIZE, GFP_KERNEL);
		malloc_flag = 1;
		if(env_buf == NULL)
			return -ENOMEM;
		memset(env_buf,0,CONFIG_ENV_SIZE);
		ret = amlnand_read_info_by_name(aml_chip, &(aml_chip->uboot_env),env_buf,ENV_INFO_HEAD_MAGIC, CONFIG_ENV_SIZE);
		if (ret) 
		{
			aml_nand_msg("read ubootenv error,%s\n",__func__);
			ret = -EFAULT;
			goto exit;
		}
	}else{
		env_buf = env_ptr;
	}
	
	ret = amlnand_save_info_by_name(aml_chip, &(aml_chip->uboot_env),env_buf,ENV_INFO_HEAD_MAGIC, CONFIG_ENV_SIZE);
	if(ret < 0){
		aml_nand_msg("aml_nand_update_secure : update secure failed");
	}
	
exit:	
	if(malloc_flag &&(env_buf)){
		kfree(env_buf);
		env_buf = NULL;
	}
	return 0;
}

int amlnf_env_save(unsigned char *buf,int len)
{
	unsigned char *env_buf = NULL;
	int ret=0, i=0;
	aml_nand_msg("uboot env amlnf_env_save : ####");
	
	if(aml_chip_env == NULL){
		return 0;
	}
	if(len > CONFIG_ENV_SIZE)
	{
		aml_nand_msg("uboot env data len too much,%s",__func__);
		return -EFAULT;
	}
	env_buf = aml_nand_malloc(CONFIG_ENV_SIZE);
	if (env_buf == NULL){
		aml_nand_msg("nand malloc for uboot env failed");
		ret = -1;
		goto exit_err;
	}

	memset(env_buf,0,CONFIG_ENV_SIZE);
	memcpy(env_buf, buf, len);

	ret = amlnand_save_info_by_name(aml_chip_env, &(aml_chip_env->uboot_env),env_buf,ENV_INFO_HEAD_MAGIC, CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand uboot env error,%s",__func__);
		ret = -EFAULT;
		goto exit_err;
	}
	
exit_err:

	if(env_buf){
		kfree(env_buf);
		env_buf= NULL;
	}
	return ret;
}


int amlnf_env_read(unsigned char *buf,int len)
{
	unsigned char *env_buf = NULL;
	int ret=0, i=0;
	
	aml_nand_msg("uboot env amlnf_env_read : ####");

	if(aml_chip_env == NULL){
		return 0;
	}

	if(len > CONFIG_ENV_SIZE) 
	{
		aml_nand_msg("uboot env data len too much,%s",__func__);
		return -EFAULT;
	}

	if(aml_chip_env->uboot_env.arg_valid == 0){
		memset(buf,0x0,len);
		return 0;
	}
	
	env_buf = aml_nand_malloc(CONFIG_ENV_SIZE);
	if (env_buf == NULL){
		aml_nand_msg("nand malloc for uboot env failed");
		ret = -1;
		goto exit_err;
	}
	memset(env_buf,0,CONFIG_ENV_SIZE);

	ret = amlnand_read_info_by_name(aml_chip_env, &(aml_chip_env->uboot_env),env_buf,ENV_INFO_HEAD_MAGIC, CONFIG_ENV_SIZE);
	if (ret) {
		aml_nand_msg("nand uboot env error,%s",__func__);
		ret = -EFAULT;
		goto exit_err;
	}
	memcpy(buf,env_buf, len);
	
exit_err:
	if(env_buf){
		kfree(env_buf);
		env_buf= NULL;
	}
	return ret;
}


int aml_ubootenv_init(struct amlnand_chip *aml_chip)
{
	int ret = 0;
	unsigned char * env_buf = NULL;
	aml_chip_env = aml_chip;
	
	env_buf = aml_nand_malloc(CONFIG_ENV_SIZE);
	if (env_buf == NULL){
		aml_nand_msg("nand malloc for secure_ptr failed");
		ret = -1;
		goto exit_err;
	}
	memset(env_buf,0x0,CONFIG_ENV_SIZE);
	
	ret = amlnand_info_init(aml_chip, &(aml_chip->uboot_env),env_buf,ENV_INFO_HEAD_MAGIC, CONFIG_ENV_SIZE);
	if(ret < 0){
		aml_nand_msg("aml_ubootenv_init failed\n");
		ret = -1;
		goto exit_err;
	}

	/*if(aml_chip->uboot_env.arg_valid == 0){
		memset(env_buf,0x0,CONFIG_ENV_SIZE);
		ret = amlnf_env_save(env_buf,CONFIG_ENV_SIZE);
		if(ret){
			aml_nand_msg("amlnf_env_save: save env failed");
		}
	}*/
	
exit_err:
	if(env_buf){
		kfree(env_buf);
		env_buf = NULL;
	}
	return ret;
}

