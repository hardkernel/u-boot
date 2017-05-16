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
	int copy_num = 4;
	int i;
#ifdef CONFIG_DISCRETE_BOOTLOADER
	ulong cpy;
#endif
	char *sub;
	nand_info_t *nand;
	unsigned long addr;
	int base = 2;
	u64 off, maxsize;
	size_t rwsize, limit;
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
		if (argc - base < 2) {
			ret = CMD_RET_USAGE;
			goto _out;
		}
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
	#ifdef CONFIG_DISCRETE_BOOTLOADER
		limit = nand->size / CONFIG_BL2_COPY_NUM;
		/* write all copies if off do not exist */
		if (argc - base == 2) {
			off = 0;
			rwsize = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
			copy_num = CONFIG_BL2_COPY_NUM;
		} else {
			off = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
			rwsize = (ulong)simple_strtoul(argv[base + 2], NULL, 16);
			copy_num = 1;
		}
	#else
		/* write all, offset must be 0 */
		off = 0;
		rwsize = (ulong)simple_strtoul(argv[base + 2], NULL, 16);
		copy_num = get_boot_num(nand, rwsize);
		limit = nand->size / copy_num;
	#endif
		printf("%s() %d\n", __func__, copy_num);
		for (i = 0; i < copy_num; i++) {
			ret = nand_write_skip_bad(nand, off, &rwsize,
						NULL, limit,
						(u8 *)addr, 0);
			off += nand->size/copy_num;
		}
	} else if (!strcmp("erase", sub)) {
		nand_erase_options_t opts;
		printk("%s() %s\n", __func__, sub);
		memset(&opts, 0, sizeof(opts));
	#ifdef CONFIG_DISCRETE_BOOTLOADER
		if (argc - base == 0) {
			opts.offset = 0;
			/* whole boot area size */
			opts.length = nand->size;
		} else {
			cpy = (ulong)simple_strtoul(argv[base], NULL, 16);
			if (cpy >= 4) {
				printk("max cpies %d\n", 4);
				ret = CMD_RET_USAGE;
				goto _out;
			}
			opts.offset = cpy * 256 * nand->writesize;
			opts.length = 256 * nand->writesize;
		}
	#else
		/* whole boot area size */
		opts.offset = 0;
		opts.length = nand->size;
	#endif
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

#ifdef CONFIG_DISCRETE_BOOTLOADER

/* bl2 operations */
static int do_bl2_ops(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	int copy_num = 4;
	int i;
	ulong cpy;
	char *sub;
	nand_info_t *nand;
	unsigned long addr;
	int base = 2;
	u64 off, maxsize;
	size_t rwsize, limit;
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
	limit = maxsize / CONFIG_BL2_COPY_NUM;
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
		cpy = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
		rwsize = (ulong)simple_strtoul(argv[base + 2], NULL, 16);
		off = cpy * limit;
		ret = nand_read_skip_bad(nand, off, &rwsize,
							 NULL, limit,
							 (u8 *)addr);
	} else if (!strcmp("write", sub)) {
		printk("%s() %s\n", __func__, sub);
		if (argc - base < 2) {
			ret = CMD_RET_USAGE;
			goto _out;
		}
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		/* write all copies if off do not exist */
		if (argc - base == 2) {
			off = 0;
			rwsize = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
			copy_num = CONFIG_BL2_COPY_NUM;
		} else {
			cpy = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
			off = cpy * limit;
			rwsize = (ulong)simple_strtoul(argv[base + 2], NULL, 16);
			copy_num = 1;
		}
		printf("%s() %d\n", __func__, copy_num);
		for (i = 0; i < copy_num; i++) {
			ret = nand_write_skip_bad(nand, off, &rwsize,
						NULL, limit,
						(u8 *)addr, 0);
			off += nand->size/copy_num;
		}
	} else if (!strcmp("erase", sub)) {
		nand_erase_options_t opts;
		printk("%s() %s\n", __func__, sub);
		memset(&opts, 0, sizeof(opts));
		if (argc - base == 0) {
			opts.offset = 0;
			/* whole boot area size */
			opts.length = nand->size;
		} else {
			cpy = (ulong)simple_strtoul(argv[base], NULL, 16);
			if (cpy >= 4) {
				printk("max cpies %d\n", 4);
				ret = CMD_RET_USAGE;
				goto _out;
			}
			opts.offset = cpy * 256 * nand->writesize;
			opts.length = 256 * nand->writesize;
		}

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

static int do_fip_ops(cmd_tbl_t * cmdtp, int flag, int argc, char * const argv[])
{
	int ret = 0;
	int copy_num = 1;
	int i;
	char *sub;
	nand_info_t *nand;
	ulong addr;
	ulong cpy;
	int base = 2;
	u64 off, maxsize = CONFIG_TPL_SIZE_PER_COPY*CONFIG_TPL_COPY_NUM;
	u64 fip_base;
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
	nand = &nand_info[1];
	if (strlen(argv[1]) > 3)
		sub = &argv[1][4];
	else {
		sub = argv[2];
		base = 3;
	}
	fip_base = 1024*nand->writesize + RESERVED_BLOCK_NUM*nand->erasesize;
	if (!strcmp("read", sub)) {
		printk("%s() %s\n", __func__, sub);
		if (argc - base < 2) {
			ret = CMD_RET_USAGE;
			goto _out;
		}
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		off = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
		rwsize = (ulong)simple_strtoul(argv[base + 2], NULL, 16);
		off +=fip_base;
		ret = nand_read_skip_bad(nand,
			off, &rwsize, NULL, maxsize, (u8 *)addr);
	} else if (!strcmp("write", sub)) {
		printk("%s() %s\n", __func__, sub);
		if (argc - base < 2) {
			ret = CMD_RET_USAGE;
			goto _out;
		}
		addr = (ulong)simple_strtoul(argv[base], NULL, 16);
		if (argc - base == 2) {
			off = fip_base;
			rwsize = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
			copy_num = CONFIG_TPL_COPY_NUM;
			printk("%s %d: off=0x%llx rwsize=0x%zx\n",
				__func__, __LINE__, off, rwsize);

		} else {
			//addr off size
			off = (ulong)simple_strtoul(argv[base + 1], NULL, 16);
			off += fip_base;
			rwsize = (ulong)simple_strtoul(argv[base + 2], NULL, 16);
			copy_num = 1;
		}
		if (rwsize > CONFIG_TPL_SIZE_PER_COPY) {
			printk("size %ld > max per cpy %d\n", rwsize, CONFIG_TPL_COPY_NUM);
			ret = CMD_RET_USAGE;
			goto _out;
		}
		/* fixme, write it once! */
		for (i = 0; i < copy_num; i++) {
			printk("cpy %d\n", i);
			ret = nand_write_skip_bad(nand,
				off, &rwsize, NULL, CONFIG_TPL_SIZE_PER_COPY, (u8 *)addr, 0);
			off += CONFIG_TPL_SIZE_PER_COPY;
		}

	} else if (!strcmp("erase", sub)) {
		nand_erase_options_t opts;
		printk("%s() %s, base %d\n", __func__, sub, base);
		memset(&opts, 0, sizeof(opts));
		if (argc - base == 0) {
			opts.offset = fip_base;
			/* whole boot area size */
			opts.length = maxsize;
		} else {
			cpy = (ulong)simple_strtoul(argv[base], NULL, 16);
			if (cpy >= CONFIG_TPL_COPY_NUM) {
				printk("max cpies %d\n", CONFIG_TPL_COPY_NUM);
				ret = CMD_RET_USAGE;
				goto _out;
			}
			opts.offset = fip_base + cpy * CONFIG_TPL_SIZE_PER_COPY;
			opts.length = CONFIG_TPL_SIZE_PER_COPY;
		}
		opts.jffs2  = 0;
		opts.quiet  = 0;
		opts.spread = 0;
		ret = nand_erase_opts(nand, &opts);
	} else if (!strcmp("info", sub)) {
		printk("tpl infos:\ncopies %d, size/copy 0x%x\n",
			CONFIG_TPL_COPY_NUM, CONFIG_TPL_SIZE_PER_COPY);
	} else{
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
#endif
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
#ifdef CONFIG_DISCRETE_BOOTLOADER
    U_BOOT_CMD_MKENT(bl2, 5, 0, do_bl2_ops, "", ""),
    U_BOOT_CMD_MKENT(fip, 5, 0, do_fip_ops, "", ""),
#endif
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
#ifndef CONFIG_DISCRETE_BOOTLOADER
    "amlnf rom_read addr off size	- read uboot by offset.\n"
    "amlnf rom_write addr off size	- write all uboot at once.\n"
    "amlnf rom_erase  - erase whole boot area\n"
#else
#if 0 /* hide for interal usage */
    "amlnf rom_erase [cpy]	- erase bl2 area, erase all without cpy!\n"
    "amlnf rom_read addr off size	- read bl2 by offset.\n"
    "amlnf rom_write addr [off] size	- write bl2.\n"
    "\t[off] inside offset\n\twirte all copies if without off\n"
#endif
    "amlnf bl2_erase [cpy]	- erase bl2 area, erase all without cpy!\n"
    "amlnf bl2_read addr cpy size	- read bl2 by cpy.\n"
    "amlnf bl2_write addr [cpy] size	- write bl2.\n"
    "\t[cpy] copy to operate\n\twirte all copies if without cpy\n"
    "amlnf fip_info	- show fip infos\n"
    "amlnf fip_read addr off size	- read fip.\n"
    "amlnf fip_write addr [off] size	- write fip.\n"
    "\t[off] inside offset\n\twirte all copies if without off\n"
    "amlnf fip_erase [cpy]	- erase fip area, erase all without cpy!\n"
#endif
    "amlnf dtb_read/write addr size	- read/write dtd.\n"
    "amlnf dtb_erase    - erase dtb area!\n"
    "amlnf key_read/write addr size	- read/write keys.\n"
    "amlnf key_erase    - erase keys!\n"
	"";
#endif
U_BOOT_CMD(
	amlnf, CONFIG_SYS_MAXARGS, 0, do_amlmtd,
	"aml mtd nand sub-system",
	amlmtd_help_text
);
