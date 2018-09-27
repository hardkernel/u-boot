
#include <common.h>
#include <command.h>

#if defined(CONFIG_ODROID_COMMON)
extern int board_fdisk_all(void);

static int do_oemfdisk(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	return board_fdisk_all();
}

static cmd_tbl_t cmd_oem[] = {
	U_BOOT_CMD_MKENT(fdisk,    1, 0, do_oemfdisk,     "", ""),
};

static int do_oemops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *cp;

	cp = find_cmd_tbl(argv[1], cmd_oem, ARRAY_SIZE(cmd_oem));

	/* Drop the oem command */
	argc--;
	argv++;

	if (cp == NULL || argc > cp->maxargs)
		return CMD_RET_USAGE;
	if (flag == CMD_FLAG_REPEAT && !cp->repeatable)
		return CMD_RET_SUCCESS;

	return cp->cmd(cmdtp, flag, argc, argv);
}

U_BOOT_CMD(
	oem, 2, 1, do_oemops,
	"OEM sub system",
	"oem fdisk\n"
	" - Reset the partition table for android\n"
	);
#endif
