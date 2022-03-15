/*
 * Copyright (c) 2022 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <boot_rkimg.h>
#include <environment.h>
#include <memalign.h>
#include <part.h>

DECLARE_GLOBAL_DATA_PTR;

#define ENVF_MSG(fmt, args...)	printf("ENVF: "fmt, ##args)
#define BLK_CNT(desc, sz)	((sz) / (desc)->blksz)

static ulong env_offset, env_offset_redund;
static ulong env_size;

#ifdef CONFIG_SPL_BUILD
#ifdef CONFIG_SPL_ENV_PARTITION
/*
 * In case of env and env-backup partitions are too large that exceeds the limit
 * of CONFIG_SPL_SYS_MALLOC_F_LEN. we prefer to use a static address as an env
 * buffer. The tail of bss section is good choice from experience.
 */
static void *env_buf =
	(void *)CONFIG_SPL_BSS_START_ADDR + CONFIG_SPL_BSS_MAX_SIZE;

static const char *get_strval(env_t *env, u32 size, const char *str)
{
	const char *dp;
	u32 env_size;

	dp = (const char *)env->data;
	env_size = size - ENV_HEADER_SIZE;
	do {
		/* skip leading white space */
		while (*dp == ' ' || *dp == '\t')
			++dp;

		debug("ENTRY: %s\n", dp);
		if (strstr(dp, str)) {
			debug("FIND: %s\n", dp);
			return dp;
		}

		/* point to next ENTRY */
		dp += strlen(dp) + 1;
	} while (((ulong)dp < (ulong)env->data + env_size) && *dp);

	debug("NOT-FIND: %s\n", str);

	return NULL;
}

static int env_do_load(struct blk_desc *desc, u32 offset, u32 size,
		       void *buf, void **envp)
{
	lbaint_t env_size;
	lbaint_t env_off;
	env_t *env = buf;
	u32 blk_cnt;

	env_size = size - ENV_HEADER_SIZE;
	env_off = BLK_CNT(desc, offset);
	blk_cnt = BLK_CNT(desc, size);

	if (blk_dread(desc, env_off, blk_cnt, (void *)env) != blk_cnt) {
		ENVF_MSG("io error @ 0x%x\n", offset);
		return -EIO;
	}

	if (crc32(0, env->data, env_size) != env->crc) {
		ENVF_MSG("!bad CRC @ 0x%x\n", offset);
		return -EINVAL;
	}

	if (envp)
		*envp = env;

	return 0;
}

int envf_load(struct blk_desc *desc)
{
	const char *part_list;
	int ret = -ENOENT;
	void *env;

	if (!desc)
		return -ENODEV;

	if (desc->if_type == IF_TYPE_MTD &&
	    (desc->devnum == BLK_MTD_SPI_NAND || desc->devnum == BLK_MTD_NAND)) {
		env_size = CONFIG_ENV_NAND_SIZE;
		env_offset = CONFIG_ENV_NAND_OFFSET;
		env_offset_redund = CONFIG_ENV_NAND_OFFSET_REDUND;
	} else {
		env_size = CONFIG_ENV_SIZE;
		env_offset = CONFIG_ENV_OFFSET;
		env_offset_redund = CONFIG_ENV_OFFSET_REDUND;
	}

	if (env_offset == env_offset_redund)
		env_offset_redund = 0;

	ENVF_MSG("Primary 0x%08lx - 0x%08lx\n", env_offset, env_offset + env_size);
	if (env_offset_redund)
		ENVF_MSG("Backup  0x%08lx - 0x%08lx\n",
			 env_offset_redund, env_offset_redund + env_size);

	ret = env_do_load(desc, env_offset, env_size, env_buf, &env);
	if (ret < 0 && env_offset_redund)
		ret = env_do_load(desc, env_offset_redund, env_size,
				  env_buf + env_size, &env);
	if (ret < 0) {
		ENVF_MSG("No valid env data, ret=%d\n", ret);
		return ret;
	}

	part_list = get_strval(env, env_size, "mtdparts");
	if (!part_list)
		part_list = get_strval(env, env_size, "blkdevparts");
	if (!part_list) {
		ENVF_MSG("No valid env part list\n");
		return ret;
	}

	ENVF_MSG("OK\n");
	env_part_list_init(part_list);
	/*
	 * Call blk_dread() to read env content:
	 *    => mmc_init() => part_init() with CONFIG_ENV_PARTITION_LIST => mmc init ok
	 *    => read env content! including partition tables(blkdevparts/mtdparts).
	 *
	 * So we must reinit env partition after we setup the partition
	 * tables(blkdevparts/mtdparts) from env.
	 */
	part_init(desc);

	return 0;
}
#endif

#else
/*
 * Example: ./tools/mkenvimage -s 0x8000 -p 0x0 -o env.img env.txt
 */
#define ENVF_MAX		64
#define ENVF_EMSG		"error: please use \"sys_bootargs\" but not " \
				"\"bootargs\" in CONFIG_ENVF_LIST and envf.bin"
static const char *envf_list[ENVF_MAX];
static u32 envf_num;

static int envf_extract_list(void)
{
	char *tok, *p;
	u32 i = 0;

	tok = strdup(CONFIG_ENVF_LIST);
	if (!tok)
		return -ENOMEM;

	p = strtok(tok, " ");
	while (p && i < ENVF_MAX) {
		if (!strcmp(p, "bootargs")) {
			printf("%s\n", ENVF_EMSG);
			run_command("download", 0);
		}
		envf_list[i++] = p;
		p = strtok(NULL, " ");
	}

	envf_num = i;

	return 0;
}

static int env_do_load(struct blk_desc *desc, u32 offset, u32 size,
		       const char *list[], int num, void **envp)
{
	ALLOC_CACHE_ALIGN_BUFFER(env_t, env, 1);
	lbaint_t env_size;
	lbaint_t env_off;
	u32 blk_cnt;
	int ret = 0;

	env_size = size - ENV_HEADER_SIZE;
	env_off = BLK_CNT(desc, offset);
	blk_cnt = BLK_CNT(desc, size);

	if (blk_dread(desc, env_off, blk_cnt, (void *)env) != blk_cnt) {
		ret = -EIO;
		goto out;
	}

	if (crc32(0, env->data, env_size) != env->crc) {
		ENVF_MSG("!bad CRC @ 0x%x\n", offset);
		ret = -EINVAL;
		goto out;
	}

	if (!himport_r(&env_htab, (char *)env->data, env_size, '\0',
		       H_NOCLEAR, 0, num, (char * const *)list)) {
		ENVF_MSG("himport error: %d\n", errno);
		ret = -EINTR;
	}

	if (envp)
		*envp = env;
out:
	return ret;
}

static int envf_load(void)
{
	struct blk_desc *desc;
	int ret = -ENOENT;

	desc = rockchip_get_bootdev();
	if (!desc) {
		printf("dev desc null!\n");
		return 0;
	}

	if (desc->if_type == IF_TYPE_MTD &&
	    (desc->devnum == BLK_MTD_SPI_NAND || desc->devnum == BLK_MTD_NAND)) {
		env_size = CONFIG_ENV_NAND_SIZE;
		env_offset = CONFIG_ENV_NAND_OFFSET;
		env_offset_redund = CONFIG_ENV_NAND_OFFSET_REDUND;
	} else {
		env_size = CONFIG_ENV_SIZE;
		env_offset = CONFIG_ENV_OFFSET;
		env_offset_redund = CONFIG_ENV_OFFSET_REDUND;
	}

	if (env_offset == env_offset_redund)
		env_offset_redund = 0;

	ENVF_MSG("Primary 0x%08lx - 0x%08lx\n", env_offset, env_offset + env_size);
	if (env_offset_redund)
		ENVF_MSG("Backup  0x%08lx - 0x%08lx\n",
			 env_offset_redund, env_offset_redund + env_size);

	envf_extract_list();
	ret = env_do_load(desc, env_offset, env_size, envf_list, envf_num, NULL);
	if (ret < 0 && env_offset_redund) {
		ret = env_do_load(desc, env_offset_redund,
				  env_size, envf_list, envf_num, NULL);
	}
	if (ret < 0) {
		ENVF_MSG("No valid env data, ret=%d\n", ret);
		return ret;
	}

	ENVF_MSG("OK\n");
	printf("  - %s\n", CONFIG_ENVF_LIST);
#ifdef CONFIG_ENV_PARTITION
	/*
	 * Call blk_dread() to read envf content:
	 *    => mmc_init() => part_init() with CONFIG_ENV_PARTITION_LIST => mmc init ok
	 *    => read envf content! including partition tables(blkdevparts/mtdparts).
	 *
	 * So we must reinit env partition after we setup the partition
	 * tables(blkdevparts/mtdparts) from envf.
	 */
	part_init(desc);
#endif
	return 0;
}

static int envf_save(void)
{
	ALLOC_CACHE_ALIGN_BUFFER(env_t, env, 1);
	struct blk_desc *desc;
	u32 blk_cnt;
	ssize_t	len;
	char *res;
	int ret = 0;

	desc = rockchip_get_bootdev();
	if (!desc) {
		printf("dev desc null!\n");
		return -EINVAL;
	}

	res = (char *)env->data;
	len = hexport_r(&env_htab, '\0', H_MATCH_KEY | H_MATCH_IDENT,
			&res, env_size - ENV_HEADER_SIZE,
			envf_num, (char * const *)envf_list);
	if (len < 0) {
		ENVF_MSG("hexpor error: %d\n", errno);
		return -EINVAL;
	}

	env->crc = crc32(0, env->data, env_size - ENV_HEADER_SIZE);
	blk_cnt = BLK_CNT(desc, env_size);
	if (blk_dwrite(desc, BLK_CNT(desc, env_offset),
		       blk_cnt, (char *)env) != blk_cnt) {
		ret = -EIO;
		ENVF_MSG("io error\n");
	}

	if (env_offset_redund) {
		if (blk_dwrite(desc, BLK_CNT(desc, env_offset_redund),
			       blk_cnt, (char *)env) != blk_cnt)
			ENVF_MSG("redundant: io error\n");
		else
			ret = 0;
	}

	return ret;
}

static int envf_nowhere_init(void)
{
	gd->env_addr	= (ulong)&default_environment[0];
	gd->env_valid	= ENV_INVALID;

	return 0;
}

U_BOOT_ENV_LOCATION(nowhere) = {
	.location	= ENVL_NOWHERE,
	.init		= envf_nowhere_init,
	.load		= envf_load,
	.save		= env_save_ptr(envf_save),
	ENV_NAME("envf")
};
#endif
