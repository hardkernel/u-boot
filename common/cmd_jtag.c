#include <config.h>
#include <common.h>
#include <asm/arch/io.h>
#include <command.h>
#include <malloc.h>
#include <asm/arch/bl31_apis.h>

static int get_jtag_sel(const char *argv)
{
	int sel;
	if (strcmp(argv, "apao") == 0)
		sel = JTAG_A53_AO;
	else if (strcmp(argv, "apee") == 0)
		sel = JTAG_A53_EE;
	else if (strcmp(argv, "scpao") == 0)
		sel = JTAG_M3_AO;
	else if (strcmp(argv, "scpee") == 0)
		sel = JTAG_M3_EE;
	else
		sel = -1;

	return sel;
}

int do_jtagon(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int sel;
	if (argc < 2) {
		printf("invalid argument count!\n");
		return -1;
	}
	sel = get_jtag_sel(argv[1]);
	if (sel < 0) {
		printf("invalid argument!\n");
		return -1;
	}

	aml_set_jtag_state(JTAG_STATE_ON, sel);
	return 0;
}

U_BOOT_CMD(
	jtagon,	2,	1,	do_jtagon,
	"enable jtag",
	"jtagon [apao|apee|scpao|scpee]"
);

int do_jtagoff(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int sel;
	if (argc < 2) {
		printf("invalid argument count!\n");
		return -1;
	}
	sel = get_jtag_sel(argv[1]);
	if (sel < 0) {
		printf("invalid argument!\n");
		return -1;
	}

	aml_set_jtag_state(JTAG_STATE_OFF, sel);
	return 0;
}

U_BOOT_CMD(
	jtagoff,	2,	1,	do_jtagoff,
	"disable jtag",
	"jtagoff [apao|apee|scpao|scpee]"
);
