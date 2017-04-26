#include <common.h>
#include <config.h>
#include <command.h>
#include <amlogic/aml_irblaster.h>

static int do_ir_open(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	struct aml_irblaster_drv_s *drv;

	drv = aml_irblaster_get_driver();
	if (drv)
		return drv->open();
	return CMD_RET_USAGE;
}

static int do_ir_close(cmd_tbl_t *cmdtp, int flag, int argc,char *const argv[])
{
	struct aml_irblaster_drv_s *drv;

	drv = aml_irblaster_get_driver();
	if (drv)
		return drv->close();
	return CMD_RET_USAGE;
}

static int do_ir_test(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	struct aml_irblaster_drv_s *drv;
	unsigned int times;

	if (argc != 2)
		return CMD_RET_USAGE;
	times = simple_strtoul(argv[1], NULL, 10);
	drv = aml_irblaster_get_driver();
	if (drv) {
		if (!drv->openflag) {
			printf("please first irblaster open\n");
			return 0;
		}
		return drv->test(times);
	}
	return CMD_RET_USAGE;
}

static int do_ir_send(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	struct aml_irblaster_drv_s *drv;
	unsigned int value;

	if (argc != 2)
		return CMD_RET_USAGE;
	drv = aml_irblaster_get_driver();
	if (drv) {
		if (!drv->openflag) {
			printf("please first irblaster open\n");
			return 0;
		}
		value =simple_strtoul(argv[1], NULL, 10);
		return drv->send(value);
	}
	return CMD_RET_USAGE;
}

static int do_ir_set(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	struct aml_irblaster_drv_s *drv;
	int value;

	if (argc != 3)
		return CMD_RET_USAGE;
	drv = aml_irblaster_get_driver();
	if (!strcmp(argv[1], "protocol")) {
		return drv->setprotocol(argv[2]);
	} else if(!strcmp(argv[1], "frequency")) {
		value = simple_strtoul(argv[2], NULL, 10);
		return drv->setfrequency(value);
	} else
		return CMD_RET_USAGE;
	return CMD_RET_SUCCESS;
}

static int do_ir_get(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	struct aml_irblaster_drv_s *drv;
	int value;
	const char *str;

	if (argc != 2)
		return CMD_RET_USAGE;
	drv = aml_irblaster_get_driver();
	if (!strcmp(argv[1], "protocol")) {
		str = drv->getprocotol();
		printf("procotol=%s\n", str);
	} else if(!strcmp(argv[1], "frequency")) {
		value = drv->getfrequency();
		printf("frequency=%d\n", value);
	} else if (!strcmp(argv[1], "windows")) {
		drv->print_windows();
	}else
		return CMD_RET_USAGE;
	return CMD_RET_SUCCESS;
}

static int do_ir_reg(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	struct aml_irblaster_drv_s *drv;
	unsigned int value;
	volatile unsigned int *addr;

	if (argc != 4)
		return CMD_RET_USAGE;
	drv = aml_irblaster_get_driver();
	if (!strcmp(argv[1], "write")) {
		addr = (volatile unsigned int *)simple_strtoul(argv[2], NULL, 10);
		value = simple_strtoul(argv[3], NULL, 10);
		drv->write_reg((volatile unsigned int *)addr, value);
	} else if(!strcmp(argv[1], "read")) {
		addr = (volatile unsigned int *)simple_strtoul(argv[2], NULL, 10);
		value = simple_strtoul(argv[3], NULL, 10);
		drv->read_reg((volatile unsigned int *)addr, value);
		printf("read reg\n");
	} else
		return CMD_RET_USAGE;
	return CMD_RET_SUCCESS;
}


static cmd_tbl_t cmd_ir_sub[] = {
	U_BOOT_CMD_MKENT(open, 1, 1, do_ir_open, "", ""),
	U_BOOT_CMD_MKENT(close, 1, 1, do_ir_close, "", ""),
	U_BOOT_CMD_MKENT(test, 2, 1, do_ir_test, "", ""),
	U_BOOT_CMD_MKENT(send, 2, 1, do_ir_send, "", ""),
	U_BOOT_CMD_MKENT(set, 3, 1, do_ir_set, "", ""),
	U_BOOT_CMD_MKENT(get, 2, 1, do_ir_get, "", ""),
	U_BOOT_CMD_MKENT(reg, 4, 1, do_ir_reg, "", ""),
};

static int do_irblaster (cmd_tbl_t *cmdtp, int flag, int argc,
	char *const argv[])
{
	cmd_tbl_t *c;

	if (argc < 2)
		return CMD_RET_USAGE;
	/* Strip off leading 'irblaster' command argument */
	argc--;
	argv++;
	c = find_cmd_tbl(argv[0], &cmd_ir_sub[0], ARRAY_SIZE(cmd_ir_sub));
	if (c)
		return c->cmd(cmdtp, flag, argc, argv);
	return CMD_RET_USAGE;
}

U_BOOT_CMD(irblaster, 5, 1, do_irblaster,
	   "blaster ir signal",
	   "send [data]\n"
	   "    - blaster data\n"
	   "irblaster test [times]\n"
	   "    - test will loop blaster data and can't return\n"
	   "irblaster open\n"
	   "    - open irblaster sub-system\n"
	   "irblaster close\n"
	   "    - close irblaster sub-system\n"
	   "irblaster set <frequency | protocol> [value]\n"
	   "    - set irblaster <frequency | protocol> value\n"
	   "irblaster get <frequency | protocol | windows>\n"
	   "    - get irblaster <frequency(20000<freq<60000) | protocol | windows>"
	   " value\n"
	   "irblaster reg <write | read> [addr] [value | length]\n"
	   );
