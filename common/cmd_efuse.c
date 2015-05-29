
/*
 * common/cmd_efuse.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <command.h>
#include <malloc.h>
#include <asm/arch/efuse.h>

#define EFUSE_WRITE 0
#define EFUSE_READ 1

extern ssize_t efuse_read(char *buf, size_t count, loff_t *ppos );
extern ssize_t efuse_write(const char *buf, size_t count, loff_t *ppos );
extern uint32_t efuse_get_max(void);
extern int32_t meson_trustzone_efuse(struct efuse_hal_api_arg* arg);
extern uint32_t meson_trustzone_efuse_check(unsigned char *addr);

int cmd_efuse(int argc, char * const argv[], char *buf)
{
	int i, action = -1;
	efuseinfo_item_t info;
	uint32_t offset;
	uint32_t size, max_size;
	char *end;

	if (strncmp(argv[1], "read", 4) == 0)
		action=EFUSE_READ;
	else if(strncmp(argv[1], "write", 5) == 0)
		action=EFUSE_WRITE;
	else{
		printf("%s arg error\n", argv[1]);
		return -1;
	}

	/*check efuse user data max size*/
	offset = simple_strtoul(argv[2], &end, 16);
	size = simple_strtoul(argv[3], &end, 16);
	printf("%s: offset is %d  size is  %d \n", __func__,offset,size);
	max_size = efuse_get_max();
	if (!size) {
		printf("\n error: size is zero!!!\n");
		return -1;
	}
	if (offset > max_size) {
		printf("\n error: offset is too large!!!\n");
		printf("\n offset should be less than %d!\n",max_size);
		return -1;
	}
	if (offset+size > max_size) {
		printf("\n error: offset + size is too large!!!\n");
		printf("\n offset + size should be less than %d!\n",max_size);
		return -1;
	}

	// efuse read
	if (action == EFUSE_READ) {
		memset(buf, 0, size);
		efuse_read_usr(buf, size, (loff_t *)&offset);
		for (i=0; i<size; i++)
			printf(":%02x", buf[i]);
		printf("\n");
	}

	// efuse write
	else if(action==EFUSE_WRITE){
		if (argc<5) {
			printf("arg count error\n");
			return -1;
		}
		memset(buf, 0, size);

		if (efuse_write_usr(buf, size, (loff_t*)&offset)<0) {
			printf("error: efuse write fail.\n");
			return -1;
		}
		else
			printf("%s written done.\n", info.title);
	}
	else{
		printf("arg error\n");
		return -1;
	}

	return 0;
}


int do_efuse(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char buf[EFUSE_BYTES];

	memset(buf, 0, sizeof(buf));

	if (argc < 2) {
		cmd_usage(cmdtp);
		return -1;
	}

	return cmd_efuse(argc, argv, buf);
}
#if 0
U_BOOT_CMD(
	efuse,	4,	1,	do_efuse,
	"efuse version/licence/mac/hdcp/usid read/write or dump raw efuse data commands"
	" or info(display chip efuse info)",
	"[read/write] [licence/mac/hdc/usid/machineid] [mem_addr]\n"
	"	   [read/wirte] para read ; write ;\n"
	"				read need not mem_addr;write need\n"
	"				read to get efuse context\n"
	"				write to write efuse\n"
	"	   [mem_addr] usr do \n"
	"efuse [info]\n"
	"          display the chip efuse info\n"
	"efuse [secure_boot_set] [mem_addr]\n"
	"	   decrypt the EFUSE pattern from address mem_addr which contain setting\n"
	"	   for secure boot, if pass then the setting will be programmed to the chip\n"
	"	   DO NOT TRY THIS FEATURE IF NO CONFIRMATION FROM AMLOGIC IN WRITING\n"
	"	   OTHERWISE IT WILL CAUSE UNCORRECTABLE DAMAGE TO AMLOGIC CHIPS\n"
);
#else
U_BOOT_CMD(
	efuse,	5,	1,	do_efuse,
	"efuse read/write data commands",
	"[read/write offset size [mem_addr]]\n"
	"	   [read/wirte] read or write 'size' data from"
	"				'offset' from efuse user data ;\n"
	"		 [offset]	the offset byte from the beginning"
	"        of efuse user data zone;\n"
	"    [size] data size\n"
	"	   [mem_addr] the optional argument for 'write'\n"
);
#endif

/****************************************************/
