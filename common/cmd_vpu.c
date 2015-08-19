#include <common.h>
#include <command.h>
#ifdef CONFIG_AML_VPU
#include <vpu.h>
#endif

#ifdef CONFIG_AML_VPU
static int do_vpu_enable(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	vpu_probe();
	return 0;
}

static int do_vpu_disable(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	vpu_remove();
	return 0;
}

static int do_vpu_clk(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int level;
	int ret = 0;

	if (argc == 1) {
		return -1;
	}
	if (strcmp(argv[1], "set") == 0) {
		if (argc == 3) {
			level = (int)simple_strtoul(argv[2], NULL, 10);
			ret = vpu_clk_change(level);
		} else {
			ret = -1;
		}
	} else if (strcmp(argv[1], "get") == 0) {
		vpu_clk_get();
	} else {
		ret = -1;
	}
	return ret;
}

static int do_vpu_test(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	vcbus_test();
	return 0;
}

static cmd_tbl_t cmd_vpu_sub[] = {
	U_BOOT_CMD_MKENT(probe, 2, 0, do_vpu_enable, "", ""),
	U_BOOT_CMD_MKENT(remove, 2, 0, do_vpu_disable, "", ""),
	U_BOOT_CMD_MKENT(clk, 3, 0, do_vpu_clk, "", ""),
	U_BOOT_CMD_MKENT(test, 2, 0, do_vpu_test, "", ""),
};

static int do_vpu(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'bmp' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_vpu_sub[0], ARRAY_SIZE(cmd_vpu_sub));

	if (c) {
		return c->cmd(cmdtp, flag, argc, argv);
	} else {
		cmd_usage(cmdtp);
		return 1;
	}
}

U_BOOT_CMD(
	vpu,	5,	0,	do_vpu,
	"vpu sub-system",
	"vpu probe        - enable vpu domain\n"
	"vpu remove       - disable vpu domain\n"
	"vpu test         - test vcbus access\n"
);
#endif
