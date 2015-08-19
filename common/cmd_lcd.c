#include <common.h>
#include <command.h>
#include <amlogic/aml_lcd.h>

static int do_lcd_probe(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct aml_lcd_drv_s *lcd_drv;

	lcd_drv = get_aml_lcd_driver();
	if (lcd_drv) {
		if (lcd_drv->lcd_probe)
			lcd_drv->lcd_probe();
		else
			printf("no lcd probe\n");
	} else {
		printf("no lcd driver\n");
	}
	return 0;
}

static int do_lcd_enable(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct aml_lcd_drv_s *lcd_drv = get_aml_lcd_driver();
	char *mode;

	mode = getenv("outputmode");
	if (lcd_drv) {
		if (lcd_drv->lcd_enable)
			lcd_drv->lcd_enable(mode);
		else
			printf("no lcd enable\n");
	} else {
		printf("no lcd driver\n");
	}
	return 0;
}

static int do_lcd_disable(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct aml_lcd_drv_s *lcd_drv;

	lcd_drv = get_aml_lcd_driver();
	if (lcd_drv) {
		if (lcd_drv->lcd_disable)
			lcd_drv->lcd_disable();
		else
			printf("no lcd disable\n");
	} else {
		printf("no lcd driver\n");
	}
	return 0;
}

static int do_lcd_info(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct aml_lcd_drv_s *lcd_drv;

	lcd_drv = get_aml_lcd_driver();
	if (lcd_drv) {
		if (lcd_drv->lcd_info)
			lcd_drv->lcd_info();
		else
			printf("no lcd info\n");
	} else {
		printf("no lcd driver\n");
	}
	return 0;
}

static int do_lcd_test(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct aml_lcd_drv_s *lcd_drv;
	int num;

	if (argc == 1) {
		return -1;
	}
	num = (int)simple_strtoul(argv[1], NULL, 10);

	lcd_drv = get_aml_lcd_driver();
	if (lcd_drv) {
		if (lcd_drv->lcd_test)
			lcd_drv->lcd_test(num);
	} else {
		printf("no lcd driver\n");
	}
	return 0;
}

static cmd_tbl_t cmd_lcd_sub[] = {
	U_BOOT_CMD_MKENT(probe, 2, 0, do_lcd_probe, "", ""),
	U_BOOT_CMD_MKENT(enable, 2, 0, do_lcd_enable, "", ""),
	U_BOOT_CMD_MKENT(disable, 2, 0, do_lcd_disable, "", ""),
	U_BOOT_CMD_MKENT(info, 2, 0, do_lcd_info, "", ""),
	U_BOOT_CMD_MKENT(test, 3, 0, do_lcd_test, "", ""),
};

static int do_lcd(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *c;

	/* Strip off leading 'bmp' command argument */
	argc--;
	argv++;

	c = find_cmd_tbl(argv[0], &cmd_lcd_sub[0], ARRAY_SIZE(cmd_lcd_sub));

	if (c) {
		return c->cmd(cmdtp, flag, argc, argv);
	} else {
		cmd_usage(cmdtp);
		return 1;
	}
}

U_BOOT_CMD(
	lcd,	5,	0,	do_lcd,
	"lcd sub-system",
	"lcd probe         - probe lcd parameters\n"
	"lcd enable        - enable lcd module\n"
	"lcd disable       - disable lcd module\n"
	"lcd info         - show lcd parameters\n"
	"lcd test         - show lcd bist pattern\n"
);
