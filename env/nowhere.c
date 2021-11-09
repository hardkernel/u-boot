/*
 * (C) Copyright 2000-2010
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * (C) Copyright 2001 Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Andreas Heppel <aheppel@sysgo.de>

 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <environment.h>
#include <linux/stddef.h>
#include <boot_rkimg.h>
#include <memalign.h>

DECLARE_GLOBAL_DATA_PTR;

#ifdef CONFIG_ENVF
/*
 * example: ./tools/mkenvimage -s 0x8000 -p 0x0 -o envf.bin envf.txt
 *
 * - 0x8000: the value of CONFIG_ENV_SIZE.
 * - env.txt: input file
 */
#define ENVF_MAX_ENTRY		64
#define ENVF_PART		"envf"
#define ENVF_EMSG		"error: please use \"bootargs_envf\" but not " \
				"\"bootargs\" in CONFIG_ENVF_LIST and envf.bin"
static char *envf_entry[ENVF_MAX_ENTRY];
static u32 envf_num;

static int envf_extract_list(void)
{
	char *tok, *p;
	u32 i = 0;

	tok = strdup(CONFIG_ENVF_LIST);
	if (!tok)
		return -ENOMEM;

	p = strtok(tok, " ");
	while (p && i < ENVF_MAX_ENTRY) {
		if (!strcmp(p, "bootargs")) {
			printf("%s\n", ENVF_EMSG);
			run_command("download", 0);
		}
		envf_entry[i++] = p;
		p = strtok(NULL, " ");
	}

	envf_num = i;

	return 0;
}

/* allow failure, not stop boot */
static int envf_load(void)
{
	struct blk_desc *dev_desc;
	disk_partition_t part;
	env_t *envf;
	u32 blk_cnt;
	int ret = 0;

	printf("ENVF: ");

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("dev_desc null!\n");
		return 0;
	}

	if (part_get_info_by_name(dev_desc, ENVF_PART, &part) < 0) {
		printf("no %s partition\n", ENVF_PART);
		return 0;
	}

	blk_cnt = DIV_ROUND_UP(ENV_SIZE, part.blksz);
	envf = memalign(ARCH_DMA_MINALIGN, blk_cnt * part.blksz);
	if (!envf) {
		printf("no memory\n");
		return 0;
	}

	if (blk_dread(dev_desc, part.start, blk_cnt, (void *)envf) != blk_cnt) {
		printf("io error\n");
		ret = -EIO;
		goto out;
	}

	if (crc32(0, envf->data, ENV_SIZE) != envf->crc) {
		printf("!bad CRC\n");
		ret = -EINVAL;
		goto out;
	}

	envf_extract_list();

	if (!himport_r(&env_htab, (char *)envf->data, ENV_SIZE, '\0',
		       H_NOCLEAR, 0, envf_num, envf_entry))
		printf("himport error\n");

	printf("OK\n");

out:
	if (envf)
		free(envf);

	return ret;
}

static int envf_save(void)
{
	ALLOC_CACHE_ALIGN_BUFFER(env_t, envf, 1);
	struct blk_desc *dev_desc;
	disk_partition_t part;
	u32 blk_cnt;
	ssize_t	len;
	char *res;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("dev_desc null!\n");
		return -EINVAL;
	}

	if (part_get_info_by_name(dev_desc, ENVF_PART, &part) < 0) {
		printf("envf: no partition\n");
		return -ENODEV;
	}

	blk_cnt = DIV_ROUND_UP(ENV_SIZE, part.blksz);
	res = (char *)envf->data;
	len = hexport_r(&env_htab, '\0', H_MATCH_KEY | H_MATCH_IDENT,
			&res, ENV_SIZE, envf_num, envf_entry);
	if (len < 0) {
		printf("envf: hexpor errno: %d\n", errno);
		return -EINVAL;
	}

	envf->crc = crc32(0, envf->data, ENV_SIZE);
	if (blk_dwrite(dev_desc, part.start, blk_cnt, (char *)envf) != blk_cnt) {
		printf("envf: io error\n");
		return -EIO;
	}

	return 0;
}
#endif

/*
 * Because we only ever have the default environment available we must mark
 * it as invalid.
 */
static int env_nowhere_init(void)
{
	gd->env_addr	= (ulong)&default_environment[0];
	gd->env_valid	= ENV_INVALID;

	return 0;
}

U_BOOT_ENV_LOCATION(nowhere) = {
	.location	= ENVL_NOWHERE,
	.init		= env_nowhere_init,
#ifdef CONFIG_ENVF
	.load		= envf_load,
	.save		= env_save_ptr(envf_save),
	ENV_NAME("envf")
#else
	ENV_NAME("nowhere")
#endif
};
