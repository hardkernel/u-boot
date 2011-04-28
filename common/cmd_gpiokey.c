/*
 * Command for Amlogic Custom.
 *
 * Copyright (C) 2012 Amlogic.
 * Frank Chen <frank.chen@amlogic.com>
 */

#include <common.h>
#include <command.h>
#include <asm/arch/io.h>


static int do_getGpiokey (cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{		
	int ret = get_gpiokey();
//	printf("gpio key status is %d\n", ret);
	return ret;
}


U_BOOT_CMD(
	getgpiokey,	1,	0,	do_getGpiokey,
	"get GPIO Home key",
	"/N\n"
	"This command will get HOME key'\n"
);

