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
#include <search.h>
#include <errno.h>


#ifdef CONFIG_STORE_COMPATIBLE
#include <emmc_partitions.h>
#include <partition_table.h>

#ifdef ENV_IS_EMBEDDED
env_t *env_ptr = &environment;
#else /* ! ENV_IS_EMBEDDED */
env_t *env_ptr;
#endif /* ENV_IS_EMBEDDED */
DECLARE_GLOBAL_DATA_PTR;

char *env_name_spec = "aml-storage";

/* env_init */
extern int amlnand_env_int(void);
extern int mmc_env_init(void);
int env_init(void)
{
	/* use default */
	gd->env_addr	= (ulong)&default_environment[0];
	gd->env_valid	= 1;

	return 0;
}

/* saveenv */
#ifdef CONFIG_CMD_SAVEENV
extern int amlnand_saveenv(void);
extern int mmc_saveenv(void);
int saveenv(void)
{
	int ret;

	if (EMMC_BOOT_FLAG == device_boot_flag) {
		ret = mmc_saveenv();
#ifdef CONFIG_AML_NAND
	} else if (NAND_BOOT_FLAG == device_boot_flag) {
		ret = amlnand_saveenv();
#endif
	} else {
		printf("%s() %d: device_boot_flag %d not exsit!\n",
			__func__, __LINE__, device_boot_flag);
		ret = -1;
	}
	return ret;
}
#endif /* CONFIG_CMD_SAVEENV */


/* env_relocate_spec */
extern void amlnand_env_relocate_spec(void);
extern void mmc_env_relocate_spec(void);
void env_relocate_spec(void)
{
	if (EMMC_BOOT_FLAG == device_boot_flag) {
		mmc_env_relocate_spec();
#ifdef CONFIG_AML_NAND
	} else if (NAND_BOOT_FLAG == device_boot_flag) {
		amlnand_env_relocate_spec();
#endif
	} else {
		printf("%s() %d: device_boot_flag %d not exsit!\n",
			__func__, __LINE__, device_boot_flag);
	}
	return;
}


#endif /* CONFIG_STORE_COMPATIBLE */