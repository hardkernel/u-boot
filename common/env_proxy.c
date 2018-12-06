/*
 * Copyright (C) 2018 Hardkernel Co,. Ltd
 *
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <env_proxy.h>

#include "../board/hardkernel/odroid-common/odroid-common.h"

DECLARE_GLOBAL_DATA_PTR;

__weak int get_boot_device(void)
{
	return 0;
}

#if defined(CONFIG_ENV_IS_IN_MMC)
extern struct env_proxy env_proxy_mmc;
#endif
#if defined(CONFIG_ENV_IS_IN_SPI_FLASH)
extern struct env_proxy env_proxy_sf;
#endif

char *env_name_spec = NULL;

static struct env_proxy* get_instance(void)
{
	struct env_proxy *__instance = NULL;

	if (get_boot_device() == BOOT_DEVICE_SPI) {
#if defined(CONFIG_ENV_IS_IN_SPI_FLASH)
		__instance = &env_proxy_sf;
#endif
	} else {
#if defined(CONFIG_ENV_IS_IN_MMC)
		__instance = &env_proxy_mmc;
#endif
	}

	if (__instance && (env_name_spec == NULL))
		env_name_spec = *__instance->env_name_spec_cb;

	return __instance;
}

__weak int saveenv(void)
{
	const struct env_proxy *env = get_instance();
	if (env && env->saveenv_cb)
		return env->saveenv_cb();

	return 1;
}

__weak void env_relocate_spec(void)
{
	const struct env_proxy *env = get_instance();
	if (env && env->env_relocate_spec_cb)
		return env->env_relocate_spec_cb();
}

__weak int env_init(void)
{
	const struct env_proxy *env = get_instance();
	if (env && env->env_init_cb)
		return env->env_init_cb();

	return 1;
}
