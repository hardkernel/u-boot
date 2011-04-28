/*
 * Command for Amlogic Custom.
 *
 * Copyright (C) 2013 Amlogic.
 * Frank Chen <frank.chen@amlogic.com>
 */

#include <common.h>
#include <command.h>


extern void magic_checkstatus(int saveEnvFlag);

static int do_checkstatus (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int saveenv = 0;
	if(argc > 1){
		saveenv = simple_strtoul(argv[1], NULL, 10);
	}
	magic_checkstatus(saveenv);
	return 1;
}


U_BOOT_CMD(
	magic_checkstatus,	2,	0,	do_checkstatus,
	"check magic key status",
	"/N\n"
	"This command will check magic key status'\n"
);
