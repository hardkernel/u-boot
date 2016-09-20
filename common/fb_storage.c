/*
 * drivers/mmc/aml_sd_emmc.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is used by fastboot.
 */

#include <config.h>
#include <common.h>
#include <fb_storage.h>

/* The 64 defined bytes plus the '\0' */
#define RESPONSE_LEN	(64 + 1)

static char *response_str;

void fastboot_fail(const char *s)
{
	strncpy(response_str, "FAIL", 4);
	strncat(response_str, s, RESPONSE_LEN - 4 - 1);
}

void fastboot_okay(const char *s)
{
	strncpy(response_str, "OKAY", 4);
	strncat(response_str, s, RESPONSE_LEN - 4 - 1);
}

void fb_mmc_flash_write(const char *cmd, void *download_buffer,
			unsigned int download_bytes, char *response)
{
	int ret = 0;
	char str[128] = {0};
	uint64_t addr;
	loff_t size=0;

	/* initialize the response buffer */
	response_str = response;

	addr = (uint64_t)download_buffer;
	size = download_bytes;
	sprintf(str, "store write %s 0x%llx 0x0 0x%llx", cmd, addr, size);
	printf("cmd : %s\n", str);
	ret = run_command(str, 0);
	if (ret) {
		fastboot_fail("store write fail");
		return;
	}
	fastboot_okay("");
}

void fb_mmc_erase_write(const char *cmd, void *download_buffer, char *response)
{
	int ret = 0;
	char str[128] = {0};

	/* initialize the response buffer */
	response_str = response;

	sprintf(str, "store erase partition %s", cmd);
	ret = run_command(str, 0);
	if (ret) {
		fastboot_fail("store erase fail");
		return;
	}
	fastboot_okay("");
}

