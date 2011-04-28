/*
 * (C) Copyright 2008
 * Stuart Wood, Lab X Technologies <stuart.wood@labxtechnologies.com>
 *
 * (C) Copyright 2004
 * Jian Zhang, Texas Instruments, jzhang@ti.com.

 * (C) Copyright 2000-2006
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * (C) Copyright 2001 Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Andreas Heppel <aheppel@sysgo.de>

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
#include <command.h>
#include <environment.h>
#include <linux/stddef.h>
#include <malloc.h>
#include <nand.h>
//#include <asm/arch/nand.h>
#include <linux/err.h>
#include <search.h>
#include <errno.h>
#include "../drivers/amlnf/include/amlnf_dev.h"


#if defined(CONFIG_CMD_SAVEENV) && defined(CONFIG_CMD_NAND)
#define CMD_SAVEENV
#elif defined(CONFIG_ENV_OFFSET_REDUND)
#error Cannot use CONFIG_ENV_OFFSET_REDUND without CONFIG_CMD_SAVEENV & CONFIG_CMD_NAND
#endif

#if defined(CONFIG_ENV_SIZE_REDUND) && (CONFIG_ENV_SIZE_REDUND != CONFIG_ENV_SIZE)
#error CONFIG_ENV_SIZE_REDUND should be the same as CONFIG_ENV_SIZE
#endif

#ifdef CONFIG_INFERNO
#error CONFIG_INFERNO not supported yet
#endif

#ifndef CONFIG_ENV_RANGE
#define CONFIG_ENV_RANGE	CONFIG_ENV_SIZE
#endif

#ifndef CONFIG_ENV_BLOCK_NUM
#define CONFIG_ENV_BLOCK_NUM	4
#endif

//#define __DBG__ENV__
#ifdef __DBG__ENV__
#define _debug(fmt,args...) do { printf("[DEBUG]: FILE:%s:%d, FUNC:%s--- "fmt"\n",\
                                                     __FILE__,__LINE__,__func__,## args);} \
                                         while (0)
#else
#define _debug(fmt,args...)
#endif

int nand_legacy_rw (struct nand_chip* nand, int cmd,
	    size_t start, size_t len,
	    size_t * retlen, u_char * buf);

extern env_t *env_ptr;
extern uchar default_environment[];

#ifndef CONFIG_STORE_COMPATIBLE

/* references to names in env_common.c */
extern uchar default_environment[];

char * env_name_spec = "NAND";


#ifdef ENV_IS_EMBEDDED
extern uchar environment[];
env_t *env_ptr = (env_t *)(&environment[0]);
#else /* ! ENV_IS_EMBEDDED */
env_t *env_ptr = 0;
#endif /* ENV_IS_EMBEDDED */

#endif

/* local functions */
#if !defined(ENV_IS_EMBEDDED)
static void use_default(void);
#endif
extern unsigned default_environment_size;
DECLARE_GLOBAL_DATA_PTR;

static struct aml_nandenv_info_t aml_nandenv_info;
/*typedef struct _env_blockmap{
	u_char block_id;
	u_char block_valid;
	u_char env_valid;
	u_char reserved;
}t_env_blockmap;
static t_env_blockmap env_map[CONFIG_ENV_BLOCK_NUM];
static u_char last_valid_block = 0;
static u_char current_valid_block = 0;*/

#ifndef CONFIG_STORE_COMPATIBLE

uchar env_get_char_spec (int index)
{
	return ( *((uchar *)(gd->env_addr + index)) );
}
#endif

/* this is called before nand_init()
 * so we can't read Nand to validate env data.
 * Mark it OK for now. env_relocate() in env_common.c
 * will call our relocate function which does the real
 * validation.
 *
 * When using a NAND boot image (like sequoia_nand), the environment
 * can be embedded or attached to the U-Boot image in NAND flash. This way
 * the SPL loads not only the U-Boot image from NAND but also the
 * environment.
 */
 #ifdef CONFIG_STORE_COMPATIBLE
	 int nand_env_init(void)
 #else
	int env_init(void)
#endif
{
#if defined(ENV_IS_EMBEDDED)
	int crc1_ok = 0, crc2_ok = 0;
	env_t *tmp_env1, *tmp_env2;

	tmp_env1 = env_ptr;
	tmp_env2 = (env_t *)((ulong)env_ptr + CONFIG_ENV_SIZE);

	crc1_ok = (crc32(0, tmp_env1->data, ENV_SIZE) == tmp_env1->crc);
	crc2_ok = (crc32(0, tmp_env2->data, ENV_SIZE) == tmp_env2->crc);

	if (!crc1_ok && !crc2_ok){
		gd->env_addr = 0;
		gd->env_valid = 0;
		return 0;
	}
	else if(crc1_ok && !crc2_ok)
		gd->env_valid = 1;
	else if(!crc1_ok && crc2_ok)
		gd->env_valid = 2;
	else {
		/* both ok - check serial */
		if(tmp_env1->flags == 255 && tmp_env2->flags == 0)
			gd->env_valid = 2;
		else if(tmp_env2->flags == 255 && tmp_env1->flags == 0)
			gd->env_valid = 1;
		else if(tmp_env1->flags > tmp_env2->flags)
			gd->env_valid = 1;
		else if(tmp_env2->flags > tmp_env1->flags)
			gd->env_valid = 2;
		else /* flags are equal - almost impossible */
			gd->env_valid = 1;
	}

	if (gd->env_valid == 1)
		env_ptr = tmp_env1;
	else if (gd->env_valid == 2)
		env_ptr = tmp_env2;

	gd->env_addr = (ulong)env_ptr->data;
	
#else /* ENV_IS_EMBEDDED */
	gd->env_addr  = (ulong)&default_environment[0];
	gd->env_valid = 1;

#endif /* ENV_IS_EMBEDDED */

	return (0);
}

#ifdef CMD_SAVEENV
/*
 * The legacy NAND code saved the environment in the first NAND device i.e.,
 * nand_dev_desc + 0. This is also the behaviour using the new NAND code.
 */

#ifdef CONFIG_ENV_OFFSET_REDUND
static unsigned char env_flags;

#ifdef CONFIG_STORE_COMPATIBLE
int nand_saveenv(void)
#else
int saveenv(void)
#endif
{
	printf("saveenv wrong !!!!: CONFIG_ENV_OFFSET_REDUND is configed\n");
	return 0;
}
#else /* ! CONFIG_ENV_OFFSET_REDUND */
#ifdef CONFIG_STORE_COMPATIBLE
int nand_saveenv(void)
#else
int saveenv(void)
#endif
{
	//struct aml_nftl_dev *nftl_dev;
	struct amlnf_dev* nftl_dev;
	unsigned char *env_data, * name = "env"; 
   	 env_t  *env_ptr = NULL;
	 int ret ,len, sector, page_sector;
	 aml_nand_dbg("saveenv");

	
	env_ptr = (env_t *) aml_nand_malloc(CONFIG_ENV_SIZE);
	if(env_ptr == NULL){
		aml_nand_msg("malloc failed for env_ptr");
		goto exit_error0;
	}

	env_data = (unsigned char *)(&env_ptr->data);
	len = hexport_r(&env_htab, '\0', &env_data, ENV_SIZE);
	if (len < 0){
		aml_nand_msg("Cannot export environment");
		goto exit_error0;
	}

	env_ptr->crc  = crc32(0, env_ptr->data, ENV_SIZE);
	aml_nand_dbg("save env_ptr->crc=%d",env_ptr->crc);
#if 0	
	nftl_dev = aml_nftl_get_dev(name);
	if(!nftl_dev){
		aml_nand_dbg("nand get device failed");
		return -1;
	}
	sector = CONFIG_ENV_SIZE /512;

	page_sector = nftl_dev->nand_dev->writesize /512;
	aml_nand_dbg("nand_dev->writesize  =%x",nftl_dev->nand_dev->writesize );
	aml_nand_dbg("page_sector =%d",page_sector);
	aml_nand_dbg("sector =%d",sector);
	if(sector % page_sector){
		sector =  (sector /page_sector + 1)*page_sector;
	}
	
	aml_nand_dbg("sector =%d",sector);
	aml_nand_dbg("Writing to Nand... ");
	ret = nftl_dev->write_sector((struct amlnf_dev *)nftl_dev, 0, sector, (unsigned char *)env_ptr);
	if(ret < 0){
		aml_nand_dbg("nftl write %d sector	failed", sector);
			ret = -1;
			goto exit_error0;
	}
	ret = nftl_dev->flush((struct amlnf_dev *)nftl_dev);
	if(ret < 0){
		aml_nand_dbg("nftl flush cache failed");
		ret = -1;
		goto exit_error0;
	}
#else
	ret = amlnf_env_save((unsigned char *)env_ptr,CONFIG_ENV_SIZE);
	if(ret < 0){
		aml_nand_msg("nand save env failed");
		ret = -1;
		goto exit_error0;
	}

#endif
	printf("nand_saveenv : Successful!\n");
	//return ret;
	
exit_error0:
	if(env_ptr){
		aml_nand_free(env_ptr);
		env_ptr = NULL;
	}
	
	return ret;
}
#endif /* CONFIG_ENV_OFFSET_REDUND */
#endif /* CMD_SAVEENV */

int readenv (u_char * buf)
{
	//struct aml_nftl_dev *nftl_dev;
	struct amlnf_dev* nftl_dev;
	
    	env_t	 * env_ptr = (env_t *)buf;
	uint32_t crc;

	unsigned char * name = "env"; 
	 int ret ,len, sector;
#if 0
	aml_nand_dbg("readenv");
	nftl_dev = aml_nftl_get_dev(name);
	if(!nftl_dev){
		aml_nand_dbg("nand get device failed");
		return -1;
	}

	
	sector = CONFIG_ENV_SIZE /512;

	ret = nftl_dev->read_sector((struct amlnf_dev *)nftl_dev, 0, sector, (unsigned char *)env_ptr);
	if(ret < 0){
		aml_nand_msg("nftl read %d sector  failed", sector);
		return NAND_READ_FAILED;
	}
	
#else
	unsigned char *env_magic = "nenv";
	aml_nand_dbg("readenv :#####");
	ret = amlnf_env_read((unsigned char *)env_ptr,CONFIG_ENV_SIZE);
	if(ret){	
		aml_nand_msg("readenv : nand read env failed");
		return NAND_READ_FAILED;
	}
#endif
	crc = env_ptr->crc;

	if (crc32(0, env_ptr->data, ENV_SIZE) != crc){
		set_default_env("!bad CRC");
		return 2;
	}
	
	return 0;
}

#ifdef CONFIG_ENV_OFFSET_REDUND

#ifdef CONFIG_STORE_COMPATIBLE
void nand_env_relocate_spec (void)
#else
void env_relocate_spec (void)
#endif
{
#if !defined(ENV_IS_EMBEDDED)
	size_t total;
	int crc1_ok = 0, crc2_ok = 0;
	env_t *tmp_env1, *tmp_env2;
    //printk("%s enter\n", __func__);
	total = CONFIG_ENV_SIZE;

	tmp_env1 = (env_t *) malloc(CONFIG_ENV_SIZE);
	tmp_env2 = (env_t *) malloc(CONFIG_ENV_SIZE);

	if (readenv(CONFIG_ENV_OFFSET, (u_char *) tmp_env1))
		puts("No Valid Environment Area Found\n");
	if (readenv(CONFIG_ENV_OFFSET_REDUND, (u_char *) tmp_env2))
		puts("No Valid Reundant Environment Area Found\n");

	crc1_ok = (crc32(0, tmp_env1->data, ENV_SIZE) == tmp_env1->crc);
	crc2_ok = (crc32(0, tmp_env2->data, ENV_SIZE) == tmp_env2->crc);

	if(!crc1_ok && !crc2_ok) {
		free(tmp_env1);
		free(tmp_env2);
		return use_default();
	} else if(crc1_ok && !crc2_ok)
		gd->env_valid = 1;
	else if(!crc1_ok && crc2_ok)
		gd->env_valid = 2;
	else {
		/* both ok - check serial */
		if(tmp_env1->flags == 255 && tmp_env2->flags == 0)
			gd->env_valid = 2;
		else if(tmp_env2->flags == 255 && tmp_env1->flags == 0)
			gd->env_valid = 1;
		else if(tmp_env1->flags > tmp_env2->flags)
			gd->env_valid = 1;
		else if(tmp_env2->flags > tmp_env1->flags)
			gd->env_valid = 2;
		else /* flags are equal - almost impossible */
			gd->env_valid = 1;

	}

	free(env_ptr);
	if(gd->env_valid == 1) {
		env_ptr = tmp_env1;
		free(tmp_env2);
	} else {
		env_ptr = tmp_env2;
		free(tmp_env1);
	}

#endif /* ! ENV_IS_EMBEDDED */
}
#else /* ! CONFIG_ENV_OFFSET_REDUND */
/*
 * The legacy NAND code saved the environment in the first NAND device i.e.,
 * nand_dev_desc + 0. This is also the behaviour using the new NAND code.
 */
#ifdef CONFIG_STORE_COMPATIBLE
	void nand_env_relocate_spec (void)
#else
	void env_relocate_spec (void)
#endif
{
#if !defined(ENV_IS_EMBEDDED)
	int ret;
	env_t env_buf;
	
	memset(env_buf.data, 0, ENV_SIZE);
	ret = readenv((u_char *) &env_buf);
	if (ret ) {
		if(ret == NAND_READ_FAILED){
			set_default_env("!readenv() failed");	
			saveenv();
		}
		if(ret == 2)
			saveenv();
		if(ret == -1){
			set_default_env("!readenv() failed");
			return;
		}
		return;
	}	
	env_import(&env_buf, 1);
	
#endif /* ! ENV_IS_EMBEDDED */
}
#endif /* CONFIG_ENV_OFFSET_REDUND */

#if !defined(ENV_IS_EMBEDDED)
static void use_default()
{
	puts ("*** Warning - bad CRC or NAND, using default environment\n\n");
	set_default_env(NULL);
}
#endif

