#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <command.h>
#include <malloc.h>
#include <asm/arch/mailbox.h>

int do_open_scp_log(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	open_scp_log();
	printf("open SCP log!\n");
	return 0;
}

U_BOOT_CMD(
	open_scp_log,	1,	1,	do_open_scp_log,
	"print SCP messgage",
	"print SCP log"
);
