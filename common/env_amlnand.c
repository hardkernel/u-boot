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
#include <asm/arch/nand.h>
#include <linux/err.h>
#include <search.h>
#include <errno.h>

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

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE

#else
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

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE

#else

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

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE
int nand_env_init(void)
{
	/*struct mtd_info * mtd=get_mtd_device_nm(NAND_NORMAL_NAME);
	if (!mtd)
		return 1;

	int blocksize = mtd->erasesize;
	nand_erase_options_t nand_erase_options;
	
	nand_erase_options.length = blocksize;
	nand_erase_options.quiet = 0;
	nand_erase_options.jffs2 = 0;
	nand_erase_options.scrub = 0;
	nand_erase_options.offset = CONFIG_ENV_OFFSET;*/
	//printk("%s enter\n", __func__);
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
	
#else

int env_init(void)
{
	/*struct mtd_info * mtd=get_mtd_device_nm(NAND_NORMAL_NAME);
	if (!mtd)
		return 1;

	int blocksize = mtd->erasesize;
	nand_erase_options_t nand_erase_options;
	
	nand_erase_options.length = blocksize;
	nand_erase_options.quiet = 0;
	nand_erase_options.jffs2 = 0;
	nand_erase_options.scrub = 0;
	nand_erase_options.offset = CONFIG_ENV_OFFSET;*/
	//printk("%s enter\n", __func__);
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
#endif

#ifdef CMD_SAVEENV
/*
 * The legacy NAND code saved the environment in the first NAND device i.e.,
 * nand_dev_desc + 0. This is also the behaviour using the new NAND code.
 */
int writeenv(size_t offset, u_char *buf)
{
	struct mtd_info *mtd;
	struct env_oobinfo_t *env_oobinfo;
	int error = 0;
	size_t addr = 0;
	size_t amount_saved = 0;
	size_t len;
	struct mtd_oob_ops aml_oob_ops;
	unsigned char *data_buf;
	unsigned char env_oob_buf[sizeof(struct env_oobinfo_t)];
    //printk("%s enter\n", __func__);
	mtd = nand_info[nand_curr_device];
	if (mtd == NULL)
		return 1;

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL)
		return -ENOMEM;

	addr = offset;
	env_oobinfo = (struct env_oobinfo_t *)env_oob_buf;
	memcpy(env_oobinfo->name, ENV_NAND_MAGIC, 4);
	env_oobinfo->ec = aml_chip->aml_nandenv_info->env_valid_node->ec;
	env_oobinfo->timestamp = aml_chip->aml_nandenv_info->env_valid_node->timestamp;
	env_oobinfo->status_page = 1;

	while (amount_saved < CONFIG_ENV_SIZE ) {

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = sizeof(struct env_oobinfo_t);
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = env_oob_buf;

		memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
		len = min(mtd->writesize, CONFIG_ENV_SIZE - amount_saved);
		memcpy((unsigned char *)aml_oob_ops.datbuf, buf + amount_saved, len);

		error = mtd->write_oob(mtd, addr, &aml_oob_ops);
		if (error) {
			printf("blk check good but write failed: %llx, %d\n", (long long unsigned int)offset, error);
			return 1;
		}

		addr += mtd->writesize;;
		amount_saved += mtd->writesize;
	}
	if (amount_saved < CONFIG_ENV_SIZE)
		return 1;

	kfree(data_buf);
	return 0;
}

#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE

#ifdef CONFIG_ENV_OFFSET_REDUND
static unsigned char env_flags;

int nand_saveenv(void)
{
    env_t	*env_new_p = NULL;
	ssize_t	len;
	char	*res;
	struct mtd_info * mtd=get_mtd_device_nm(NAND_NORMAL_NAME);
	if (IS_ERR(mtd))
		return 1;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	size_t total;
	size_t offset = CONFIG_ENV_IN_NAND_OFFSET;
	int ret = 0;
	nand_erase_options_t nand_erase_options;
    //printk("123 %s enter\n", __func__);
	offset = (1024 * aml_chip->page_size * (mtd->writesize / (aml_chip->plane_num * aml_chip->page_size)));
	if (CONFIG_ENV_IN_NAND_OFFSET < offset)
		_debug ("env define offset must larger than 1024 page size: %d \n", mtd->writesize);
	else
		offset = CONFIG_ENV_IN_NAND_OFFSET;

	env_new_p = (env_t *)malloc (CONFIG_ENV_SIZE);		
	res = (char *)&(env_new_p->data);
	len = hexport_r(&env_htab, '\0', &res, ENV_SIZE);
	if (len < 0) {
		error("Cannot export environment: errno = %d\n", errno);
		free(env_new_p);			
		return 1;
	}
	env_new_p->crc   = crc32(0, env_new_p->data, ENV_SIZE);
	env_new_p->flags = ++env_flags; /* increase the serial */
	total = CONFIG_ENV_SIZE;

	nand_erase_options.length = CONFIG_ENV_RANGE;
	nand_erase_options.quiet = 0;
	nand_erase_options.jffs2 = 0;
	nand_erase_options.scrub = 0;

	if (CONFIG_ENV_RANGE < CONFIG_ENV_SIZE)
		return 1;
	if(gd->env_valid == 1) {
		puts ("Erasing redundant Nand...\n");
		nand_erase_options.offset = CONFIG_ENV_OFFSET_REDUND;
		if (nand_erase_opts(mtd, &nand_erase_options))
			return 1;

		puts ("Writing to redundant Nand... ");
		ret = writeenv(CONFIG_ENV_OFFSET_REDUND, (u_char *) env_new_p);
	} else {
		puts ("Erasing Nand...\n");
		nand_erase_options.offset = CONFIG_ENV_IN_NAND_OFFSET;
		if (nand_erase_opts(mtd, &nand_erase_options))
			return 1;

		puts ("Writing to Nand... ");
		ret = writeenv(CONFIG_ENV_IN_NAND_OFFSET, (u_char *) env_new_p);
	}
	if (ret) {
		puts("FAILED!\n");
		return 1;
	}

	puts ("done\n");
	gd->env_valid = (gd->env_valid == 2 ? 1 : 2);
    free(env_new_p);
	return ret;
}
#else /* ! CONFIG_ENV_OFFSET_REDUND */
int nand_saveenv(void)
{
    env_t *env_new_p = NULL;
	char	*res;
	ssize_t	len;
	struct mtd_info *mtd;
	struct aml_nand_bbt_info *nand_bbt_info;
	struct env_free_node_t *env_free_node, *env_tmp_node;
	int error = 0, pages_per_blk, i = 1;
	size_t addr = 0;
	struct erase_info aml_env_erase_info;
    //printk("abc %s enter\n", __func__);
	mtd = nand_info[nand_curr_device];
	if (mtd == NULL)
		return 1;

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	if (!aml_chip->aml_nandenv_info->env_init) 
		return 1;

	pages_per_blk = mtd->erasesize / mtd->writesize;
	if ((mtd->writesize < CONFIG_ENV_SIZE) && (aml_chip->aml_nandenv_info->env_valid == 1))
		i = (CONFIG_ENV_SIZE + mtd->writesize - 1) / mtd->writesize;
	
	if (aml_chip->aml_nandenv_info->env_valid) {
		aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr += i;
		if ((aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr + i) > pages_per_blk) {

			env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
			if (env_free_node == NULL)
				return -ENOMEM;

			env_free_node->phy_blk_addr = aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr;
			env_free_node->ec = aml_chip->aml_nandenv_info->env_valid_node->ec;
			env_tmp_node = aml_chip->aml_nandenv_info->env_free_node;
			while (env_tmp_node->next != NULL) {
				env_tmp_node = env_tmp_node->next;
			}
			env_tmp_node->next = env_free_node;

			env_tmp_node = aml_chip->aml_nandenv_info->env_free_node;
			aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr = env_tmp_node->phy_blk_addr;
			aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr = 0;
			aml_chip->aml_nandenv_info->env_valid_node->ec = env_tmp_node->ec;
			aml_chip->aml_nandenv_info->env_valid_node->timestamp += 1;
			aml_chip->aml_nandenv_info->env_free_node = env_tmp_node->next;
			kfree(env_tmp_node);
		}
	}
	else {

		env_tmp_node = aml_chip->aml_nandenv_info->env_free_node;
		aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr = env_tmp_node->phy_blk_addr;
		aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr = 0;
		aml_chip->aml_nandenv_info->env_valid_node->ec = env_tmp_node->ec;
		aml_chip->aml_nandenv_info->env_valid_node->timestamp += 1;
		aml_chip->aml_nandenv_info->env_free_node = env_tmp_node->next;
		kfree(env_tmp_node);
	}

	addr = aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr;
	addr *= mtd->erasesize;
	addr += aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr * mtd->writesize;
	if ((aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr == 0)&&aml_chip->aml_nandenv_info->env_valid) {

		memset(&aml_env_erase_info, 0, sizeof(struct erase_info));
		aml_env_erase_info.mtd = mtd;
		aml_env_erase_info.addr = addr;
		aml_env_erase_info.len = mtd->erasesize;
		aml_chip->aml_nandenv_info->env_valid_node->env_status = 0;
		error = mtd->erase(mtd, &aml_env_erase_info);
		if (error) {
			printf("env free blk erase failed %d\n", error);
			mtd->block_markbad(mtd, addr);
			return error;
		}
		aml_chip->aml_nandenv_info->env_valid_node->ec++;
		aml_chip->aml_nandenv_info->env_valid_node->env_status = 1;
	}

    env_new_p = (env_t *)malloc (CONFIG_ENV_SIZE);
    if(!env_new_p){
        error("Cannot malloc env_t\n");
        return 1;
    }
	// get env data from hash table
	res = (char *)&(env_new_p->data);
	memset(env_new_p->data, 0, ENV_SIZE);
	len = hexport_r(&env_htab, '\0', &res, ENV_SIZE);
	if (len < 0) {
		error("Cannot export environment: errno = %d\n", errno);		
		free(env_new_p);
		return 1;
	}
	env_new_p->crc   = crc32(0, env_new_p->data, ENV_SIZE);	

	nand_bbt_info = &aml_chip->aml_nandenv_info->nand_bbt_info;
	if ((!memcmp(nand_bbt_info->bbt_head_magic, BBT_HEAD_MAGIC, 4)) && (!memcmp(nand_bbt_info->bbt_tail_magic, BBT_TAIL_MAGIC, 4))) {
		memcpy(env_new_p->data + default_environment_size, aml_chip->aml_nandenv_info->nand_bbt_info.bbt_head_magic, sizeof(struct aml_nand_bbt_info));
		env_new_p->crc   = crc32(0, env_new_p->data, ENV_SIZE);
	}
	printf("Writing to Nand... 0x%x\n", addr);
	if (writeenv(addr, (u_char *) env_new_p)) {
		printf("FAILED!\n");
        free(env_new_p);
		return 1;
	}
	aml_chip->aml_nandenv_info->env_valid = 1;
	printf("Successful!\n");
    free(env_new_p);
	return error;
}
#endif /* CONFIG_ENV_OFFSET_REDUND */

#else

#ifdef CONFIG_ENV_OFFSET_REDUND
static unsigned char env_flags;
int saveenv(void)
{
    env_t	*env_new_p = NULL;
	ssize_t	len;
	char	*res;
	struct mtd_info * mtd=get_mtd_device_nm(NAND_NORMAL_NAME);
	if (IS_ERR(mtd))
		return 1;
	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	size_t total;
	size_t offset = CONFIG_ENV_OFFSET;
	int ret = 0;
	nand_erase_options_t nand_erase_options;
    //printk("123 %s enter\n", __func__);
	offset = (1024 * aml_chip->page_size * (mtd->writesize / (aml_chip->plane_num * aml_chip->page_size)));
	if (CONFIG_ENV_OFFSET < offset)
		_debug ("env define offset must larger than 1024 page size: %d \n", mtd->writesize);
	else
		offset = CONFIG_ENV_OFFSET;

	env_new_p = (env_t *)malloc (CONFIG_ENV_SIZE);		
	res = (char *)&(env_new_p->data);
	len = hexport_r(&env_htab, '\0', &res, ENV_SIZE);
	if (len < 0) {
		error("Cannot export environment: errno = %d\n", errno);
		free(env_new_p);			
		return 1;
	}
	env_new_p->crc   = crc32(0, env_new_p->data, ENV_SIZE);
	env_new_p->flags = ++env_flags; /* increase the serial */
	total = CONFIG_ENV_SIZE;

	nand_erase_options.length = CONFIG_ENV_RANGE;
	nand_erase_options.quiet = 0;
	nand_erase_options.jffs2 = 0;
	nand_erase_options.scrub = 0;

	if (CONFIG_ENV_RANGE < CONFIG_ENV_SIZE)
		return 1;
	if(gd->env_valid == 1) {
		puts ("Erasing redundant Nand...\n");
		nand_erase_options.offset = CONFIG_ENV_OFFSET_REDUND;
		if (nand_erase_opts(mtd, &nand_erase_options))
			return 1;

		puts ("Writing to redundant Nand... ");
		ret = writeenv(CONFIG_ENV_OFFSET_REDUND, (u_char *) env_new_p);
	} else {
		puts ("Erasing Nand...\n");
		nand_erase_options.offset = CONFIG_ENV_OFFSET;
		if (nand_erase_opts(mtd, &nand_erase_options))
			return 1;

		puts ("Writing to Nand... ");
		ret = writeenv(CONFIG_ENV_OFFSET, (u_char *) env_new_p);
	}
	if (ret) {
		puts("FAILED!\n");
		return 1;
	}

	puts ("done\n");
	gd->env_valid = (gd->env_valid == 2 ? 1 : 2);
    free(env_new_p);
	return ret;
}
#else /* ! CONFIG_ENV_OFFSET_REDUND */
int saveenv(void)
{
    env_t *env_new_p = NULL;
	char	*res;
	ssize_t	len;
	struct mtd_info *mtd;
	struct aml_nand_bbt_info *nand_bbt_info;
	struct env_free_node_t *env_free_node, *env_tmp_node;
	int error = 0, pages_per_blk, i = 1;
	size_t addr = 0;
	struct erase_info aml_env_erase_info;
    //printk("abc %s enter\n", __func__);
	mtd = nand_info[nand_curr_device];
	if (mtd == NULL)
		return 1;

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	if (!aml_chip->aml_nandenv_info->env_init) 
		return 1;

	pages_per_blk = mtd->erasesize / mtd->writesize;
	if ((mtd->writesize < CONFIG_ENV_SIZE) && (aml_chip->aml_nandenv_info->env_valid == 1))
		i = (CONFIG_ENV_SIZE + mtd->writesize - 1) / mtd->writesize;
	
	if (aml_chip->aml_nandenv_info->env_valid) {
		aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr += i;
		if ((aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr + i) > pages_per_blk) {

			env_free_node = kzalloc(sizeof(struct env_free_node_t), GFP_KERNEL);
			if (env_free_node == NULL)
				return -ENOMEM;

			env_free_node->phy_blk_addr = aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr;
			env_free_node->ec = aml_chip->aml_nandenv_info->env_valid_node->ec;
			env_tmp_node = aml_chip->aml_nandenv_info->env_free_node;
			while (env_tmp_node->next != NULL) {
				env_tmp_node = env_tmp_node->next;
			}
			env_tmp_node->next = env_free_node;

			env_tmp_node = aml_chip->aml_nandenv_info->env_free_node;
			aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr = env_tmp_node->phy_blk_addr;
			aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr = 0;
			aml_chip->aml_nandenv_info->env_valid_node->ec = env_tmp_node->ec;
			aml_chip->aml_nandenv_info->env_valid_node->timestamp += 1;
			aml_chip->aml_nandenv_info->env_free_node = env_tmp_node->next;
			kfree(env_tmp_node);
		}
	}
	else {

		env_tmp_node = aml_chip->aml_nandenv_info->env_free_node;
		aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr = env_tmp_node->phy_blk_addr;
		aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr = 0;
		aml_chip->aml_nandenv_info->env_valid_node->ec = env_tmp_node->ec;
		aml_chip->aml_nandenv_info->env_valid_node->timestamp += 1;
		aml_chip->aml_nandenv_info->env_free_node = env_tmp_node->next;
		kfree(env_tmp_node);
	}

	addr = aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr;
	addr *= mtd->erasesize;
	addr += aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr * mtd->writesize;
	if ((aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr == 0)&&aml_chip->aml_nandenv_info->env_valid) {

		memset(&aml_env_erase_info, 0, sizeof(struct erase_info));
		aml_env_erase_info.mtd = mtd;
		aml_env_erase_info.addr = addr;
		aml_env_erase_info.len = mtd->erasesize;

		error = mtd->erase(mtd, &aml_env_erase_info);
		if (error) {
			printf("env free blk erase failed %d\n", error);
			mtd->block_markbad(mtd, addr);
			return error;
		}
		aml_chip->aml_nandenv_info->env_valid_node->ec++;
	}

    env_new_p = (env_t *)malloc (CONFIG_ENV_SIZE);
    if(!env_new_p){
        error("Cannot malloc env_t\n");
        return 1;
    }
	// get env data from hash table
	res = (char *)&(env_new_p->data);
	memset(env_new_p->data, 0, ENV_SIZE);
	len = hexport_r(&env_htab, '\0', &res, ENV_SIZE);
	if (len < 0) {
		error("Cannot export environment: errno = %d\n", errno);		
		free(env_new_p);
		return 1;
	}
	env_new_p->crc   = crc32(0, env_new_p->data, ENV_SIZE);	

	nand_bbt_info = &aml_chip->aml_nandenv_info->nand_bbt_info;
	if ((!memcmp(nand_bbt_info->bbt_head_magic, BBT_HEAD_MAGIC, 4)) && (!memcmp(nand_bbt_info->bbt_tail_magic, BBT_TAIL_MAGIC, 4))) {
		memcpy(env_new_p->data + default_environment_size, aml_chip->aml_nandenv_info->nand_bbt_info.bbt_head_magic, sizeof(struct aml_nand_bbt_info));
		env_new_p->crc   = crc32(0, env_new_p->data, ENV_SIZE);
	}
	printf("Writing to Nand... 0x%x\n", addr);
	if (writeenv(addr, (u_char *) env_new_p)) {
		printf("FAILED!\n");
        free(env_new_p);
		return 1;
	}
	aml_chip->aml_nandenv_info->env_valid = 1;
	printf("Successful!\n");
    free(env_new_p);
	return error;
}
#endif /* CONFIG_ENV_OFFSET_REDUND */
#endif /* CMD_SAVEENV */
#endif /* CMD_SAVEENV */
int readenv (size_t offset, u_char * buf)
{
    env_t	*env_p = (env_t	*)buf;
	struct mtd_info *mtd;
	struct env_oobinfo_t *env_oobinfo;
	struct aml_nand_bbt_info *nand_bbt_info;
	int error = 0, start_blk, total_blk, i, j;
	size_t addr = 0;
	size_t amount_loaded = 0;
	size_t len;
	struct mtd_oob_ops aml_oob_ops;
	unsigned char *data_buf;
	unsigned char env_oob_buf[sizeof(struct env_oobinfo_t)];
    //printk("%s enter\n", __func__);
	mtd = nand_info[nand_curr_device];
	if (mtd == NULL)
		return 1;

	struct aml_nand_chip *aml_chip = mtd_to_nand_chip(mtd);
	if (!aml_chip->aml_nandenv_info->env_valid)
		return 2;

	addr = (1024 * mtd->writesize / aml_chip->plane_num);
	start_blk = addr / mtd->erasesize;
	total_blk = mtd->size / mtd->erasesize;
	addr = aml_chip->aml_nandenv_info->env_valid_node->phy_blk_addr;
	addr *= mtd->erasesize;
	addr += aml_chip->aml_nandenv_info->env_valid_node->phy_page_addr * mtd->writesize;

	data_buf = kzalloc(mtd->writesize, GFP_KERNEL);
	if (data_buf == NULL)
		return -ENOMEM;

	env_oobinfo = (struct env_oobinfo_t *)env_oob_buf;
	while (amount_loaded < CONFIG_ENV_SIZE ) {

		aml_oob_ops.mode = MTD_OOB_AUTO;
		aml_oob_ops.len = mtd->writesize;
		aml_oob_ops.ooblen = sizeof(struct env_oobinfo_t);
		aml_oob_ops.ooboffs = mtd->ecclayout->oobfree[0].offset;
		aml_oob_ops.datbuf = data_buf;
		aml_oob_ops.oobbuf = env_oob_buf;

		memset((unsigned char *)aml_oob_ops.datbuf, 0x0, mtd->writesize);
		memset((unsigned char *)aml_oob_ops.oobbuf, 0x0, aml_oob_ops.ooblen);

		error = mtd->read_oob(mtd, addr, &aml_oob_ops);
		if ((error != 0) && (error != -EUCLEAN)) {
			printf("blk check good but read failed: %llx, %d\n", (uint64_t)addr, error);
			return 1;
		}

		if (memcmp(env_oobinfo->name, ENV_NAND_MAGIC, 4)) 
			printf("invalid nand env magic: %llx\n", (uint64_t)offset);

		addr += mtd->writesize;
		len = min(mtd->writesize, CONFIG_ENV_SIZE - amount_loaded);
		memcpy(buf + amount_loaded, data_buf, len);
		amount_loaded += mtd->writesize;
	}
	if (amount_loaded < CONFIG_ENV_SIZE)
		return 1;

	nand_bbt_info = (struct aml_nand_bbt_info *)(env_p->data + default_environment_size);
	if ((!memcmp(nand_bbt_info->bbt_head_magic, BBT_HEAD_MAGIC, 4)) && (!memcmp(nand_bbt_info->bbt_tail_magic, BBT_TAIL_MAGIC, 4))) {
		for (i=start_blk; i<total_blk; i++) {
			aml_chip->block_status[i] = NAND_BLOCK_GOOD;
			for (j=0; j<MAX_BAD_BLK_NUM; j++) {
				if ((nand_bbt_info->nand_bbt[j]&0x7fff) == i) {

					if((nand_bbt_info->nand_bbt[j] &0x8000)){
						aml_chip->block_status[i] = NAND_FACTORY_BAD;
						//printk("readenv : init the aml_chip->block_status[%d] to NAND_FACTORY_BAD\n",i);
						}
						else	{
						aml_chip->block_status[i] = NAND_BLOCK_BAD;
						//printk("readenv : init the aml_chip->block_status[%d] to BAD\n",i);
						}
						
					//aml_chip->block_status[i] = NAND_BLOCK_BAD;
					break;
				}
			}
		}
		memcpy((unsigned char *)aml_chip->aml_nandenv_info->nand_bbt_info.bbt_head_magic, (unsigned char *)nand_bbt_info, sizeof(struct aml_nand_bbt_info));
	}

	kfree(data_buf);
	return 0;
}


#if defined CONFIG_SPI_NAND_COMPATIBLE || defined CONFIG_SPI_NAND_EMMC_COMPATIBLE

#ifdef CONFIG_ENV_OFFSET_REDUND
void nand_env_relocate_spec (void)
{
#if !defined(ENV_IS_EMBEDDED)
	size_t total;
	int crc1_ok = 0, crc2_ok = 0;
	env_t *tmp_env1, *tmp_env2;
    //printk("%s enter\n", __func__);
	total = CONFIG_ENV_SIZE;

	tmp_env1 = (env_t *) malloc(CONFIG_ENV_SIZE);
	tmp_env2 = (env_t *) malloc(CONFIG_ENV_SIZE);

	if (readenv(CONFIG_ENV_IN_NAND_OFFSET, (u_char *) tmp_env1))
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
void nand_env_relocate_spec (void)
{
#if !defined(ENV_IS_EMBEDDED)
	int ret;
	env_t env_buf;
	
	memset(env_buf.data, 0, ENV_SIZE);
	ret = readenv(CONFIG_ENV_IN_NAND_OFFSET, (u_char *) &env_buf);
	if (ret) {		
		set_default_env("!readenv() failed");
        if (ret == 2){
		nand_saveenv();
        	}
		return;
	}	
	env_import(&env_buf, 1);
	
#endif /* ! ENV_IS_EMBEDDED */
}
#endif /* CONFIG_ENV_OFFSET_REDUND */

#else
#ifdef CONFIG_ENV_OFFSET_REDUND
void env_relocate_spec (void)
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
void env_relocate_spec (void)
{
#if !defined(ENV_IS_EMBEDDED)
	int ret;
	env_t env_buf;
	
#if 0//(defined CONFIG_M3) || (defined CONFIG_M6)
	if(nand_probe(1)){
		set_default_env("!no available device.");
		return;
	}
#endif

	memset(env_buf.data, 0, ENV_SIZE);
	ret = readenv(CONFIG_ENV_OFFSET, (u_char *) &env_buf);
	if (ret) {		
		set_default_env("!readenv() failed");
        if (ret == 2)
			saveenv();
		return;
	}	
	env_import((char *)&env_buf, 1);
	
#endif /* ! ENV_IS_EMBEDDED */
}
#endif /* CONFIG_ENV_OFFSET_REDUND */
#endif /* CONFIG_ENV_OFFSET_REDUND */

#if !defined(ENV_IS_EMBEDDED)
static void use_default()
{
	puts ("*** Warning - bad CRC or NAND, using default environment\n\n");
	set_default_env(NULL);
}
#endif
