/* cmd c files for aml mtd, overide amlnf cmds */
#include <config.h>
#include <common.h>
#include <command.h>
#include <environment.h>
#include <nand.h>
#include "aml_mtd.h"

/* debug macros */
#define CONFIG_AML_MTD_DBG	(1)
#ifdef CONFIG_AML_MTD_DBG
static void dump_args(int argc, char * const argv[])
{
	int i;
	/* debug codes for mtd cmd */
	for (i = 0; i < argc; i++)
		printk("arg %d: %s\n", i, argv[i]);

	return;
}
#else
static void dump_args(int argc, char * const argv[])
{
	return;
}
#endif

/*
 * operations for bootloader
 * we call it rom as legarcy reasons.
 * call nand's opeartions.
 * switch to normal device after doing this.
 */
#define CONFIG_AMLMTD_CURRDEV	(0)
extern int set_mtd_dev(int dev);
extern int get_mtd_dev(void);
static int do_rom_ops(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	char *sub;
	nand_info_t *nand;
	unsigned long addr;
	int base = 2;
	u64 off, maxsize;
	size_t rwsize;
	/* fixme, using this?! */
#if (CONFIG_AMLMTD_CURRDEV)
	int curr_mtd_dev;
#endif
	printk("%s(): argc %d\n", __func__, argc);
	dump_args(argc, argv);
#if (CONFIG_AMLMTD_CURRDEV)
	curr_mtd_dev = get_mtd_dev();
	if (curr_mtd_dev != 0)
		set_mtd_dev(0);
#endif
	nand = &nand_info[0];
	maxsize = nand->size;
	if (strlen(argv[1]) > 3)
		sub = &argv[1][4];
	else {
		sub = argv[2];
		base = 3;
	}
	if (!strcmp("read", sub)) {
		printk("%s() %s\n", __func__, sub);
		if (argc - base < 3) {
			ret = CMD_RET_USAGE;
			goto _out;
		}
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		off = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
		rwsize = (ulong)simple_strtoul(argv[base + 2], NULL, 16);
		ret = nand_read_skip_bad(nand, off, &rwsize,
							 NULL, maxsize,
							 (u8 *)addr);
	} else if (!strcmp("write", sub)) {
		printk("%s() %s\n", __func__, sub);
		if (argc - base < 3) {
			ret = CMD_RET_USAGE;
			goto _out;
		}
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		off = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
		rwsize = (ulong)simple_strtoul(argv[base + 2], NULL, 16);
		ret = nand_write_skip_bad(nand, off, &rwsize,
							  NULL, maxsize,
							  (u8 *)addr, 0);
	} else if (!strcmp("erase", sub)) {
		nand_erase_options_t opts;
		printk("%s() %s\n", __func__, sub);
		memset(&opts, 0, sizeof(opts));
		opts.offset = 0;
		/* whole boot area size */
		opts.length = nand->size;
		opts.jffs2  = 0;
		opts.quiet  = 0;
		opts.spread = 0;
		ret = nand_erase_opts(nand, &opts);

	} else {
		ret = CMD_RET_USAGE;
		goto _out;
	}

_out:
#if (CONFIG_AMLMTD_CURRDEV)
	/* restore mtd device */
	if (curr_mtd_dev != 0)
		set_mtd_dev(curr_mtd_dev);
#endif
	return ret;
}

/*
 * operations for dtb.
 */
extern int amlnf_dtb_save(u8 *buf, int len);
extern int amlnf_dtb_read(u8 *buf, int len);
extern int amlnf_dtb_erase(void);
static int do_dtb_ops(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = 0;
	printk("%s(): argc %d\n", __func__, argc);
	dump_args(argc, argv);
	char *sub;
	int base = 2;
	unsigned long addr;
	u64 size = 0;

	if (strlen(argv[1]) > 3)
		sub = &argv[1][4];
	else {
		sub = argv[2];
		base = 3;
	}

	if (!strcmp("read", sub)) {
		printk("%s() %s\n", __func__, sub);
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		size = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
		ret = amlnf_dtb_read((u8 *)addr, (int)size);
		printk("%s(): %llu bytes %s : %s\n",
				__func__,
				size,
				sub,
				ret ? "ERROR" : "OK");
	} else if (!strcmp("write", sub)) {
		printk("%s() %s\n", __func__, sub);
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		size = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
		ret = amlnf_dtb_save((u8 *)addr, (int)size);
		printk("%s(): %llu bytes %s : %s\n",
				__func__,
				size,
				sub,
				ret ? "ERROR" : "OK");
	} else if (!strcmp("erase", sub)) {
		printk("%s() %s\n", __func__, sub);
		ret = amlnf_dtb_erase();
		printk("%s() erase %s\n", __func__, ret ? "Fail" : "Okay");
	} else
		return CMD_RET_USAGE;

	return ret;
}

/*
 * operations for key.
 * should never be used by users, just for nand team debug.
 */
extern int amlnf_key_read(u8 *buf, int len, uint32_t *actual_lenth);
extern int amlnf_key_write(u8 *buf, int len, uint32_t *actual_lenth);
extern int amlnf_key_erase(void);
static int do_key_ops(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	int ret = 0;
	printk("%s(): argc %d\n", __func__, argc);
	dump_args(argc, argv);
	char *sub;
	int base = 2;
	unsigned long addr;
	u64 size = 0;
	uint32_t len;

	if (strlen(argv[1]) > 3)
		sub = &argv[1][4];
	else {
		sub = argv[2];
		base = 3;
	}

	if (!strcmp("read", sub)) {
		printk("%s() %s\n", __func__, sub);
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		size = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
		ret = amlnf_key_read((u8 *)addr, (int)size, &len);
		printk("%s(): %llu bytes %s : %s\n",
				__func__,
				size,
				sub,
				ret ? "ERROR" : "OK");
	} else if (!strcmp("write", sub)) {
		printk("%s() %s\n", __func__, sub);
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		size = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
		ret = amlnf_key_write((u8 *)addr, (int)size, &len);
		printk("%s(): %llu bytes %s : %s\n",
				__func__,
				size,
				sub,
				ret ? "ERROR" : "OK");
	} else if (!strcmp("erase", sub)) {
		printk("%s() %s\n", __func__, sub);
		ret = amlnf_key_erase();
		printk("%s() erase %s\n", __func__, ret ? "Fail" : "Okay");
	} else
		return CMD_RET_USAGE;

	return ret;
}

static cmd_tbl_t cmd_amlmtd_sub[] = {
    U_BOOT_CMD_MKENT(rom, 5, 0, do_rom_ops, "", ""),
    U_BOOT_CMD_MKENT(dtb, 5, 0, do_dtb_ops, "", ""),
    U_BOOT_CMD_MKENT(key, 5, 0, do_key_ops, "", ""),
};

static int do_amlmtd(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
    cmd_tbl_t *c;
	char subcmd[4];

    if (argc < 2) return CMD_RET_USAGE;
	/* process subcmd which is longger than 3 characaters */
    c = find_cmd_tbl(argv[1], cmd_amlmtd_sub, ARRAY_SIZE(cmd_amlmtd_sub));
	if (!c) {
		strncpy(subcmd, argv[1], 3);
		if (strlen(argv[1]) > 3) {
			subcmd[3] = 0;
		}
		printk("sub cmd %s\n", subcmd);
		c = find_cmd_tbl(subcmd, cmd_amlmtd_sub, ARRAY_SIZE(cmd_amlmtd_sub));
		if (c) {
			printf("new argv[1] %s\n", argv[1]);
			return	c->cmd(cmdtp, flag, argc, argv);
		}
	} else {
		return	c->cmd(cmdtp, flag, argc, argv);
	}

    return CMD_RET_USAGE;
}


#ifdef CONFIG_SYS_LONGHELP
static char amlmtd_help_text[] =
	"amlnf boot\n	- show main storage device flag\n"
	"amlnf rom_read/write addr off cnt\n	- read/write uboot.\n"
	"amlnf rom_erase\n	- erase boot area!\n"
	"amlnf dtb_read/write addr cnt\n	- read/write dtd.\n"
	"amlnf dtb_erase\n	- erase dtb area!\n"
	"amlnf key_read/write addr cnt\n	- read/write keys.\n"
	"amlnf key_erase\n	- erase keys!\n"
	"";
#endif
U_BOOT_CMD(
	amlnf, CONFIG_SYS_MAXARGS, 0, do_amlmtd,
	"aml mtd nand sub-system",
	amlmtd_help_text
);
