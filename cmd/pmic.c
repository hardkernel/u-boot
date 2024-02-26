/*
 * Copyright (C) 2014-2015 Samsung Electronics
 * Przemyslaw Marczak <p.marczak@samsung.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#include <common.h>
#include <errno.h>
#include <dm.h>
#include <dm/uclass-internal.h>
#include <power/pmic.h>

#define LIMIT_DEV	32
#define LIMIT_PARENT	20

static struct udevice *currdev;

static int failure(int ret)
{
	printf("Error: %d (%s)\n", ret, errno_str(ret));

	return CMD_RET_FAILURE;
}

static int do_dev(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	char *name;
	int ret = -ENODEV;

	switch (argc) {
	case 2:
		name = argv[1];
		ret = pmic_get(name, &currdev);
		if (ret) {
			printf("Can't get PMIC: %s!\n", name);
			return failure(ret);
		}
	case 1:
		if (!currdev) {
			printf("PMIC device is not set!\n\n");
			return CMD_RET_USAGE;
		}

		printf("dev: %d @ %s\n", currdev->seq, currdev->name);
	}

	return CMD_RET_SUCCESS;
}

static int do_list(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct udevice *dev;

	printf("| %-*.*s| %-*.*s| %s @ %s\n",
	       LIMIT_DEV, LIMIT_DEV, "Name",
	       LIMIT_PARENT, LIMIT_PARENT, "Parent name",
	       "Parent uclass", "seq");

	for (uclass_first_device(UCLASS_PMIC, &dev); dev;
	     uclass_next_device(&dev)) {
		printf("| %-*.*s| %-*.*s| %s @ %d\n",
		       LIMIT_DEV, LIMIT_DEV, dev->name,
		       LIMIT_PARENT, LIMIT_PARENT, dev->parent->name,
		       dev_get_uclass_name(dev->parent), dev->parent->seq);
	}

	return CMD_RET_SUCCESS;
}

static int do_dump(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct udevice *dev;
	uint8_t value;
	uint reg;
	int ret;

	if (!currdev) {
		printf("First, set the PMIC device!\n");
		return CMD_RET_USAGE;
	}

	dev = currdev;

	printf("Dump pmic: %s registers\n", dev->name);

	for (reg = 0; reg < pmic_reg_count(dev); reg++) {
		ret = pmic_read(dev, reg, &value, 1);
		if (ret) {
			printf("Can't read register: %d\n", reg);
			return failure(ret);
		}

		if (!(reg % 16))
			printf("\n0x%02x: ", reg);

		printf("%2.2x ", value);
	}
	printf("\n");

	return CMD_RET_SUCCESS;
}

static int do_read(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct udevice *dev;
	int regs, ret;
	uint8_t value;
	uint reg;

	if (!currdev) {
		printf("First, set the PMIC device!\n");
		return CMD_RET_USAGE;
	}

	dev = currdev;

	if (argc != 2)
		return CMD_RET_USAGE;

	reg = simple_strtoul(argv[1], NULL, 0);
	regs = pmic_reg_count(dev);
	if (reg > regs) {
		printf("PMIC max reg: %d\n", regs);
		return failure(-EFAULT);
	}

	ret = pmic_read(dev, reg, &value, 1);
	if (ret) {
		printf("Can't read PMIC register: %d!\n", reg);
		return failure(ret);
	}

	printf("0x%02x: 0x%2.2x\n", reg, value);

	return CMD_RET_SUCCESS;
}

static int do_write(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct udevice *dev;
	int regs, ret;
	uint8_t value;
	uint reg;

	if (!currdev) {
		printf("First, set the PMIC device!\n");
		return CMD_RET_USAGE;
	}

	dev = currdev;

	if (argc != 3)
		return CMD_RET_USAGE;

	reg = simple_strtoul(argv[1], NULL, 0);
	regs = pmic_reg_count(dev);
	if (reg > regs) {
		printf("PMIC max reg: %d\n", regs);
		return failure(-EFAULT);
	}

	value = simple_strtoul(argv[2], NULL, 0);

	ret = pmic_write(dev, reg, &value, 1);
	if (ret) {
		printf("Can't write PMIC register: %d!\n", reg);
		return failure(ret);
	}

	return CMD_RET_SUCCESS;
}

static cmd_tbl_t subcmd[] = {
	U_BOOT_CMD_MKENT(dev, 2, 1, do_dev, "", ""),
	U_BOOT_CMD_MKENT(list, 1, 1, do_list, "", ""),
	U_BOOT_CMD_MKENT(dump, 1, 1, do_dump, "", ""),
	U_BOOT_CMD_MKENT(read, 2, 1, do_read, "", ""),
	U_BOOT_CMD_MKENT(write, 3, 1, do_write, "", ""),
};

static int do_pmic(cmd_tbl_t *cmdtp, int flag, int argc,
			char * const argv[])
{
	cmd_tbl_t *cmd;

	argc--;
	argv++;

	cmd = find_cmd_tbl(argv[0], subcmd, ARRAY_SIZE(subcmd));
	if (cmd == NULL || argc > cmd->maxargs)
		return CMD_RET_USAGE;

	return cmd->cmd(cmdtp, flag, argc, argv);
}

U_BOOT_CMD(pmic, CONFIG_SYS_MAXARGS, 1, do_pmic,
	" operations",
	"list          - list pmic devices\n"
	"pmic dev [name]    - show or [set] operating PMIC device\n"
	"pmic dump          - dump registers\n"
	"pmic read address  - read byte of register at address\n"
	"pmic write address - write byte to register at address\n"
);
