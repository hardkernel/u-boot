/*
 * (C) Copyright 2000-2010
 * Wolfgang Denk, DENX Software Engineering, wd@denx.de.
 *
 * (C) Copyright 2008
 * Stuart Wood, Lab X Technologies <stuart.wood@labxtechnologies.com>
 *
 * (C) Copyright 2004
 * Jian Zhang, Texas Instruments, jzhang@ti.com.
 *
 * (C) Copyright 2001 Sysgo Real-Time Solutions, GmbH <www.elinos.com>
 * Andreas Heppel <aheppel@sysgo.de>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <environment.h>
#include <linux/stddef.h>
#include <malloc.h>
//#include <nand.h>	/* fixme, using header's of amlnand */
#include <search.h>
#include <errno.h>

#if defined(CONFIG_CMD_SAVEENV) && defined(CONFIG_AML_NAND)
#define CMD_SAVEENV
#elif defined(CONFIG_ENV_OFFSET_REDUND)
#error CONFIG_ENV_OFFSET_REDUND must have CONFIG_CMD_SAVEENV & CONFIG_AML_NAND
#endif

#if defined(CONFIG_ENV_SIZE_REDUND) &&	\
	(CONFIG_ENV_SIZE_REDUND != CONFIG_ENV_SIZE)
#error CONFIG_ENV_SIZE_REDUND should be the same as CONFIG_ENV_SIZE
#endif

#ifndef CONFIG_ENV_RANGE
#define CONFIG_ENV_RANGE	CONFIG_ENV_SIZE
#endif

#ifdef CONFIG_AML_NAND
extern int amlnf_env_read(u_char *buf, int len);
extern int amlnf_env_save(u_char *buf, int len);

#ifndef CONFIG_STORE_COMPATIBLE
char *env_name_spec = "aml-nand";
#if defined(ENV_IS_EMBEDDED)
env_t *env_ptr = &environment;
#elif defined(CONFIG_NAND_ENV_DST)
env_t *env_ptr = (env_t *)CONFIG_NAND_ENV_DST;
#else /* ! ENV_IS_EMBEDDED */
env_t *env_ptr;
#endif /* ENV_IS_EMBEDDED */
#endif /* CONFIG_STORE_COMPATIBLE */
DECLARE_GLOBAL_DATA_PTR;
/*
 * This is called before nand_init() so we can't read NAND to
 * validate env data.
 *
 * Mark it OK for now. env_relocate() in env_common.c will call our
 * relocate function which does the real validation.
 *
 * When using a NAND boot image (like sequoia_nand), the environment
 * can be embedded or attached to the U-Boot image in NAND flash.
 * This way the SPL loads not only the U-Boot image from NAND but
 * also the environment.
 */
#ifdef CONFIG_STORE_COMPATIBLE
int amlnand_env_int(void)
#else
int env_init(void)
#endif
{
#if defined(ENV_IS_EMBEDDED) || defined(CONFIG_NAND_ENV_DST)
	int crc1_ok = 0, crc2_ok = 0;
	env_t *tmp_env1;

	tmp_env1 = env_ptr;
	crc1_ok = crc32(0, tmp_env1->data, ENV_SIZE) == tmp_env1->crc;

	if (!crc1_ok && !crc2_ok) {
		gd->env_addr	= 0;
		gd->env_valid	= 0;

		return 0;
	} else if (crc1_ok && !crc2_ok) {
		gd->env_valid = 1;
	}

	if (gd->env_valid == 1)
		env_ptr = tmp_env1;

	gd->env_addr = (ulong)env_ptr->data;

#else /* ENV_IS_EMBEDDED || CONFIG_NAND_ENV_DST */
	gd->env_addr	= (ulong)&default_environment[0];
	gd->env_valid	= 1;
#endif /* ENV_IS_EMBEDDED || CONFIG_NAND_ENV_DST */

	return 0;
}

#ifdef CMD_SAVEENV
#ifdef CONFIG_STORE_COMPATIBLE
int amlnand_saveenv(void)
#else
int saveenv(void)
#endif
{
	int	ret = 0;
	ALLOC_CACHE_ALIGN_BUFFER(env_t, env_new, 1);

	ret = env_export(env_new);
	if (ret)
		return ret;

	ret = amlnf_env_save((u_char *)env_new, CONFIG_ENV_SIZE);

	return ret;
}
#endif /* CMD_SAVEENV */

static int readenv(u_char *buf)
{
	int ret;

	ret = amlnf_env_read(buf, CONFIG_ENV_SIZE);
	if (ret) {
		printf("%s() return %d\n", __func__, ret);
	}
	return ret;
}

/*
 * The legacy NAND code saved the environment in the first NAND
 * device i.e., nand_dev_desc + 0. This is also the behaviour using
 * the new NAND code.
 */
#ifdef CONFIG_STORE_COMPATIBLE
void amlnand_env_relocate_spec(void)
#else
void env_relocate_spec(void)
#endif
{
#if !defined(ENV_IS_EMBEDDED)
	int ret;
	ALLOC_CACHE_ALIGN_BUFFER(u_char, buf, CONFIG_ENV_SIZE);

	ret = readenv(buf);
	if (ret) {
		set_default_env("!readenv() failed");
		//saveenv();
		return;
	}

	env_import((char *)buf, 1);
#endif /* ! ENV_IS_EMBEDDED */
}

#endif
