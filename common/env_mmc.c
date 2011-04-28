/*
 * (C) Copyright 2008-2010 Freescale Semiconductor, Inc.
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

/* #define DEBUG */

#include <common.h>
#include <environment.h>
#include <mmc.h>
#include <search.h>
#include <malloc.h>
#include <errno.h>
#include <partition_table.h>
#ifdef CONFIG_STORE_COMPATIBLE
#include <asm/arch/storage.h>
#endif



DECLARE_GLOBAL_DATA_PTR;
extern env_t *env_ptr;
extern uchar default_environment[];

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE || defined CONFIG_STORE_COMPATIBLE 
int emmc_env_init(void)
{
	/* use default */
	gd->env_addr = (ulong)&default_environment[0];
	gd->env_valid = 1;

	return 0;
}

#ifndef CONFIG_STORE_COMPATIBLE
void emmc_env_relocate_spec(void)
{
#if !defined(ENV_IS_EMBEDDED)
    int dev_num;
    int ret;
    env_t env_buf;
	u64 cnt = CONFIG_ENV_SIZE;
	u64 blk = CONFIG_ENV_IN_EMMC_OFFSET;

    dev_num = CONFIG_SYS_MMC_ENV_DEV;

	struct mmc *mmc = find_mmc_device(dev_num);
	if (!mmc) {
		set_default_env("!No MMC device");
		return;
	}
	if ((cnt % 512) || (blk % 512)) {
	    set_default_env("!addr or blk count notalign");
	    return ;
	}
	if (mmc_init(mmc)) {
		set_default_env("!MMC init failed");
		return ;
	}

	blk >>= 9;
    cnt >>= 9;
	ret =(cnt == mmc->block_dev.block_read(dev_num, blk, cnt, (const void *)&env_buf));
	if(!ret){
		set_default_env("!readenv() failed");
		return;
	}

	env_import(&env_buf, 1);
#endif
}
#else
void emmc_env_relocate_spec(void)
{
#if !defined(ENV_IS_EMBEDDED)
    int dev_num;
    int ret;
    env_t * env_buf =  NULL;
	u64 cnt = CONFIG_ENV_SIZE;
	u64 blk = 0;
	uint32_t crc;

	struct mmc *mmc = NULL;
	char *name = "env";
	struct partitions *part_info = NULL;
	int blk_shift = 0;
	env_buf = (env_t *)malloc(CONFIG_ENV_SIZE);
	if(!env_buf){
		printf("malloc failed \n");
		return ;
	}
	memset(env_buf->data, 0, ENV_SIZE);
#ifdef CONFIG_STORE_COMPATIBLE
    part_info = find_mmc_partition_by_name(name);
	if(part_info == NULL){
		printf("get partition info failed !!\n");
		return ;
	}

	dev_num = find_dev_num_by_partition_name (name);
	if(dev_num < 0){
		printf("get mmc dev  failed !!\n");
		return ;
	}
	store_dbg(" read env: dev_num %d",dev_num);

	mmc = find_mmc_device(dev_num);
	if (!mmc) {
		set_default_env("!No MMC device");
		return;
	}
	if ((cnt % 512) || (blk % 512)) {
	    set_default_env("!addr or blk count notalign");
	    return ;
	}
	
    blk_shift = ffs(mmc->read_bl_len) - 1;
	blk = part_info->offset >> blk_shift;
	 cnt  = cnt >> blk_shift;
#endif
	store_dbg(" read env: blk_shift %d blk %d cnt %llx",blk_shift,blk,cnt);
	ret =(cnt == mmc->block_dev.block_read(dev_num, blk, cnt, env_buf));
	if(!ret){
		set_default_env("!readenv() failed");
		saveenv();
		return;
	}

	crc = env_buf->crc;	
	if (crc32(0, env_buf->data, ENV_SIZE) != crc){
		set_default_env("!bad CRC");
		saveenv();
	}
	
	env_import(env_buf, 1);	 

#endif
}

#endif

#ifdef CONFIG_CMD_SAVEENV

int emmc_saveenv(void)
{
    struct mmc *mmc;
    int dev_num;
	u64 cnt = CONFIG_ENV_SIZE;
	u64 blk = 0;
    env_t *env_new_p = NULL;
    ssize_t	len;
    char	*res;
#ifdef  CONFIG_STORE_COMPATIBLE
	char *name = "env";
	struct partitions *part_info = NULL;
	int blk_shift = 0;
	 
	 store_dbg("emmc save env: cnt %llx",cnt);
	part_info = find_mmc_partition_by_name(name);
	if(part_info == NULL){
		printf("get partition info failed !!\n");
		return ;
	}
	dev_num = find_dev_num_by_partition_name (name);
	if(dev_num < 0){
		printf("get mmc dev  failed !!\n");
		return ;
	}
#else
	blk = CONFIG_ENV_IN_EMMC_OFFSET;
    dev_num = CONFIG_SYS_MMC_ENV_DEV;
#endif
   	 mmc = find_mmc_device(dev_num);
	if (!mmc)
	{
		puts("No MMC device! Environment MMC not initialized!\n");
		return -1;
	}
	if ((cnt % 512) || (blk % 512)) {
	    printf("addr notalign 0x%llx or byte notalign 0x%llx",blk,cnt);
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
#ifdef CONFIG_STORE_COMPATIBLE
	blk_shift =  ffs(mmc->read_bl_len) - 1;
	blk = part_info->offset >> blk_shift;
	store_dbg("cnt %llx",cnt);
	cnt  = cnt >> blk_shift;
#else
    blk >>= 9;
    cnt >>= 9;
#endif

	if(cnt == mmc->block_dev.block_write(dev_num, blk, cnt, (const void *)env_new_p))
    {
        printf("mmc save env ok\n");
    }
    else
    {
        printf("mmc save env fail\n");
       free(env_new_p);
		return -1;
    }	
	
    free(env_new_p);
	return 0;
}
#endif /* CONFIG_CMD_SAVEENV */

#else

char *env_name_spec = "MMC";

#ifdef ENV_IS_EMBEDDED
extern uchar environment[];
env_t *env_ptr = (env_t *)(&environment[0]);
#else /* ! ENV_IS_EMBEDDED */
env_t *env_ptr = NULL;
#endif /* ENV_IS_EMBEDDED */

DECLARE_GLOBAL_DATA_PTR;

uchar env_get_char_spec(int index)
{
	return *((uchar *)(gd->env_addr + index));
}

int env_init(void)
{
	/* use default */
	gd->env_addr = (ulong)&default_environment[0];
	gd->env_valid = 1;

	return 0;
}

void env_relocate_spec(void)
{
#if !defined(ENV_IS_EMBEDDED)    	    	
    int dev_num;
    int ret;
    env_t env_buf;
	u64 cnt = CONFIG_ENV_SIZE;
	u64 blk = CONFIG_ENV_OFFSET;

    dev_num = CONFIG_SYS_MMC_ENV_DEV;
    
	struct mmc *mmc = find_mmc_device(dev_num);
	if (!mmc) {
		set_default_env("!No MMC device");		
		return;
	}
	if ((cnt % 512) || (blk % 512)) {	    
	    set_default_env("!addr or blk count notalign");		
	    return ;
	}
	if (mmc_init(mmc)) {
		set_default_env("!MMC init failed");
		return ;
	}

	blk >>= 9;
    cnt >>= 9;
	ret =(cnt == mmc->block_dev.block_read(dev_num, blk, cnt, (const void *)&env_buf));
	if(!ret){		
		set_default_env("!readenv() failed");		
		return;
	}						

	env_import(&env_buf, 1);
#endif
}


#ifdef CONFIG_CMD_SAVEENV

int saveenv(void)
{
    struct mmc *mmc;
    int dev_num;
	unsigned cnt = CONFIG_ENV_SIZE;	
	u64 blk = CONFIG_ENV_OFFSET;
    dev_num = CONFIG_SYS_MMC_ENV_DEV;
    env_t *env_new_p = NULL;
    ssize_t	len;	
    char	*res;
    mmc = find_mmc_device(dev_num);
	if (!mmc)
	{
		puts("No MMC device! Environment MMC not initialized!\n");
		return -1;
	}	
	if ((cnt % 512) || (blk % 512)) {
	    printf("addr notalign 0x%llx or byte notalign 0x%llx",blk,cnt);
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
        printf("mmc save env ok\n");
    }
    else
    {
        printf("mmc save env fail\n");
       free(env_new_p);
		return -1;
    }
    free(env_new_p);
	return 0;
}
#endif /* CONFIG_CMD_SAVEENV */
#endif
