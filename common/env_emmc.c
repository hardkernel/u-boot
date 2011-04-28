#include <common.h>
#include <environment.h>
#include <mmc.h>
#include <search.h>
#include <malloc.h>
#include <errno.h>

DECLARE_GLOBAL_DATA_PTR;

/* references to names in env_common.c */
extern uchar default_environment[];

char * env_name_spec = "eMMC";

#ifdef ENV_IS_EMBEDDED
extern uchar environment[];
env_t *env_ptr = (env_t *)(&environment[0]);
#else /* ! ENV_IS_EMBEDDED */
env_t *env_ptr = 0;
#endif /* ENV_IS_EMBEDDED */


uchar env_get_char_spec(int index)
{
	return *((uchar *)(gd->env_addr + index));
}

int env_init(void)
{
	/* eMMC isn't usable before relocation */
	gd->env_addr = (ulong)&default_environment[0];
	gd->env_valid = 1;

	return 0;
}

void env_relocate_spec(void)
{
#if !defined(ENV_IS_EMBEDDED)	
    struct mmc *mmc;
    int dev_num;
    int ret;
    env_t env_buf;
	u64 cnt = CONFIG_ENV_SIZE;
	u64 blk = CONFIG_ENV_OFFSET;

    dev_num = CONFIG_ENV_DEVICE_ID;
    mmc = find_mmc_device(dev_num);
	if (!mmc)
	{		
		set_default_env("!No eMMC device");		
		return;
	}
	if ((cnt % 512) || (blk % 512)) {	    
	    set_default_env("!addr or blk count notalign");		
	    return ;
	}
	mmc_init(mmc);
    blk >>= 9;
    cnt >>= 9;
	ret =(cnt == mmc->block_dev.block_read(dev_num, blk, cnt, (void *)&env_buf));
	if(!ret){		
		set_default_env("!readenv() failed");		
		return;
	}						
	env_import((const char*)(&env_buf), 1);
	
#endif    
}

int saveenv(void)
{
    struct mmc *mmc;
    int dev_num;
	unsigned cnt = CONFIG_ENV_SIZE;	
	u64 blk = CONFIG_ENV_OFFSET;
    dev_num = CONFIG_ENV_DEVICE_ID;
    env_t *env_new_p = NULL;
    ssize_t	len;	
    char	*res;
    mmc = find_mmc_device(dev_num);
	if (!mmc)
	{
		puts("No eMMC device! Environment eMMC not initialized!\n");
		return -1;
	}	
	if ((cnt % 512) || (blk % 512)) {
	    printf("addr notalign 0x%llx or byte notalign 0x%x",blk,cnt);
		return -1;
	}	
	env_new_p = (env_t *)malloc (CONFIG_ENV_SIZE);			
	// get env data from hash table	
	memset(env_new_p->data, 0, ENV_SIZE);
	res = (char *)&(env_new_p->data);
	len = hexport_r(&env_htab, '\0', &res, ENV_SIZE);
	if (len < 0) {
		error("Cannot export environment: errno = %d\n", errno);		
		free(env_new_p);
		return 1;
	}	
	env_new_p->crc   = crc32(0, env_new_p->data, ENV_SIZE);		
	mmc_init(mmc);	
    blk >>= 9;
    cnt >>= 9;           
	if(cnt == mmc->block_dev.block_write(dev_num, blk, cnt, (const void *)env_new_p))
    {
        printf("emmc save env ok\n");
    }
    else
    {
        printf("emmc save env fail\n");
       free(env_new_p);
		return -1;
    }
    free(env_new_p);
	return 0;
}


