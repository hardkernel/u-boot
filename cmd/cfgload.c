/*
 * Copyright (C) 2015 Hardkernel Co,. Ltd
 * Dongjin Kim <tobetter@gmail.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <errno.h>
#include <malloc.h>
#include <linux/ctype.h>    /* isalpha, isdigit */
#include <linux/sizes.h>

#ifdef CONFIG_SYS_HUSH_PARSER
#include <cli_hush.h>
#endif

#if defined(CONFIG_TARGET_ODROID_XU4)
#define BOOTINI_MAGIC	"ODROIDXU-UBOOT-CONFIG"
#else
#error 'BOOTINI_MAGIC' is missing!!!
#endif

#define SZ_BOOTINI		SZ_64K

/* Nothing to proceed with zero size string or comment.
 *
 * FIXME: Do we really need to strip the line start with '#' or ';',
 *        since any U-boot command does not start with punctuation character.
 */
static int valid_command(const char* p)
{
	char *q;

	for (q = (char*)p; *q; q++) {
		if (isblank(*q)) continue;
		if (isalnum(*q)) return 1;
		if (ispunct(*q))
			return (*q != '#') && (*q != ';');
	}

	return !(p == q);
}

/* Read boot.ini from FAT partition
 */
static char* read_cfgload(void)
{
	char msg[128] = { 0, };
	unsigned long filesize;
	char *p;

	p = (char *)simple_strtoul(getenv("loadaddr"), NULL, 16);
	if (NULL == p) {
		p = (char *)CONFIG_SYS_LOAD_ADDR;
		sprintf(msg, "%x", CONFIG_SYS_LOAD_ADDR);
		setenv("loadaddr", msg);
	}

	setenv("filesize", "0");
	sprintf(msg, "cfgload addr = 0x%08X, Loading boot.ini from ",
		simple_strtoul(getenv("loadaddr"), NULL, 16));

	setenv("msgload", msg);
	run_command("if fatload mmc 0:1 ${loadaddr} boot.ini;" \
		"   then echo ${msgload} FAT;" \
		"   else if ext4load mmc 0:1 ${loadaddr} /boot.ini;" \
		"   then echo ${msgload} ext4 0:1 /boot.ini;" \
		"   else if ext4load mmc 0:1 ${loadaddr} /boot/boot.ini;" \
		"   then echo ${msgload} ext4 0:1 /boot/boot.ini;" \
		"   else if ext4load mmc 0:2 ${loadaddr} /boot/boot.ini;" \
		"   then echo ${msgload} ext4 0:2 /boot.ini;" \
		"   else if ext4load mmc 0:2 ${loadaddr} /boot.ini;" \
		"   then echo ${msgload} ext4 0:2 /boot/boot.ini;" \
		"   fi;fi;fi;fi;fi;", 0);

	filesize = getenv_ulong("filesize", 16, 0);
	if (0 == filesize) {
		printf("cfgload: no boot.ini or empty file\n");
		return NULL;
	}

	if (filesize > SZ_BOOTINI) {
		printf("boot.ini: 'boot.ini' exceeds %d, size=%ld\n",
				SZ_BOOTINI, filesize);
		return NULL;
	}

	/* Terminate the read buffer with '\0' to be treated as string */
	*(char *)(p + filesize) = '\0';

	/* Scan MAGIC string, readed boot.ini must start with exact magic string.
	 * Otherwise, we will not proceed at all.
	 */
	while (*p) {
		char *s = strsep(&p, "\n");
		if (!valid_command(s))
			continue;

		/* MAGIC string is discovered, return the buffer address of next to
		 * proceed the commands.
		 */
		if (!strncmp(s, BOOTINI_MAGIC, sizeof(BOOTINI_MAGIC)))
			return memcpy(malloc(filesize), p, filesize);
	}

	printf("cfgload: MAGIC NAME, %s, is not found!!\n", BOOTINI_MAGIC);

	return NULL;
}

static int do_load_cfgload(cmd_tbl_t *cmdtp, int flag, int argc,
		char *const argv[])
{
	char *p;
	char *cmd;

	p = read_cfgload();
	if (NULL == p)
		return 0;

	printf("cfgload: applying boot.ini...\n");

	while (p) {
		cmd = strsep(&p, "\n");
		if (!valid_command(cmd))
			continue;

		printf("cfgload: %s\n", cmd);

#ifndef CONFIG_SYS_HUSH_PARSER
		run_command(cmd, 0);
#else
		parse_string_outer(cmd, FLAG_PARSE_SEMICOLON
				| FLAG_EXIT_FROM_LOOP);
#endif
	}

	return 0;
}

U_BOOT_CMD(
		cfgload,		1,		0,		do_load_cfgload,
		"read 'boot.ini' from FAT partiton",
		"\n"
		"    - read boot.ini from the first partiton treated as FAT partiton"
);

/* vim: set ts=4 sw=4 tw=80: */
