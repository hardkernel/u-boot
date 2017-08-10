/*
 * (C) Copyright 2003
 * Kyle Harris, kharris@nexus-tech.net
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <command.h>
#include <console.h>
#include <mmc.h>

static int curr_device = -1;

static void print_mmcinfo(struct mmc *mmc)
{
	int i;

	printf("Device: %s\n", mmc->cfg->name);
	printf("Manufacturer ID: %x\n", mmc->cid[0] >> 24);
	printf("OEM: %x\n", (mmc->cid[0] >> 8) & 0xffff);
	printf("Name: %c%c%c%c%c \n", mmc->cid[0] & 0xff,
			(mmc->cid[1] >> 24), (mmc->cid[1] >> 16) & 0xff,
			(mmc->cid[1] >> 8) & 0xff, mmc->cid[1] & 0xff);

	printf("Tran Speed: %d\n", mmc->tran_speed);
	printf("Rd Block Len: %d\n", mmc->read_bl_len);

	printf("%s version %d.%d", IS_SD(mmc) ? "SD" : "MMC",
			EXTRACT_SDMMC_MAJOR_VERSION(mmc->version),
			EXTRACT_SDMMC_MINOR_VERSION(mmc->version));
	if (EXTRACT_SDMMC_CHANGE_VERSION(mmc->version) != 0)
		printf(".%d", EXTRACT_SDMMC_CHANGE_VERSION(mmc->version));
	printf("\n");

	printf("High Capacity: %s\n", mmc->high_capacity ? "Yes" : "No");
	puts("Capacity: ");
	print_size(mmc->capacity, "\n");

	printf("Bus Width: %d-bit%s\n", mmc->bus_width,
			mmc->ddr_mode ? " DDR" : "");

	puts("Erase Group Size: ");
	print_size(((u64)mmc->erase_grp_size) << 9, "\n");

	if (!IS_SD(mmc) && mmc->version >= MMC_VERSION_4_41) {
		bool has_enh = (mmc->part_support & ENHNCD_SUPPORT) != 0;
		bool usr_enh = has_enh && (mmc->part_attr & EXT_CSD_ENH_USR);

		puts("HC WP Group Size: ");
		print_size(((u64)mmc->hc_wp_grp_size) << 9, "\n");

		puts("User Capacity: ");
		print_size(mmc->capacity_user, usr_enh ? " ENH" : "");
		if (mmc->wr_rel_set & EXT_CSD_WR_DATA_REL_USR)
			puts(" WRREL\n");
		else
			putc('\n');
		if (usr_enh) {
			puts("User Enhanced Start: ");
			print_size(mmc->enh_user_start, "\n");
			puts("User Enhanced Size: ");
			print_size(mmc->enh_user_size, "\n");
		}
		puts("Boot Capacity: ");
		print_size(mmc->capacity_boot, has_enh ? " ENH\n" : "\n");
		puts("RPMB Capacity: ");
		print_size(mmc->capacity_rpmb, has_enh ? " ENH\n" : "\n");

		for (i = 0; i < ARRAY_SIZE(mmc->capacity_gp); i++) {
			bool is_enh = has_enh &&
				(mmc->part_attr & EXT_CSD_ENH_GP(i));
			if (mmc->capacity_gp[i]) {
				printf("GP%i Capacity: ", i+1);
				print_size(mmc->capacity_gp[i],
					   is_enh ? " ENH" : "");
				if (mmc->wr_rel_set & EXT_CSD_WR_DATA_REL_GP(i))
					puts(" WRREL\n");
				else
					putc('\n');
			}
		}
	}
}
static struct mmc *init_mmc_device(int dev, bool force_init)
{
	struct mmc *mmc;
	mmc = find_mmc_device(dev);
	if (!mmc) {
		printf("no mmc device at slot %x\n", dev);
		return NULL;
	}

	if (force_init)
		mmc->has_init = 0;
	if (mmc_init(mmc))
		return NULL;
	return mmc;
}
static int do_mmcinfo(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	struct mmc *mmc;

	if (curr_device < 0) {
		if (get_mmc_num() > 0)
			curr_device = 0;
		else {
			puts("No MMC device available\n");
			return 1;
		}
	}

	mmc = init_mmc_device(curr_device, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	print_mmcinfo(mmc);
	return CMD_RET_SUCCESS;
}

#ifdef CONFIG_SUPPORT_EMMC_RPMB
static int confirm_key_prog(void)
{
	puts("Warning: Programming authentication key can be done only once !\n"
	     "         Use this command only if you are sure of what you are doing,\n"
	     "Really perform the key programming? <y/N> ");
	if (confirm_yesno())
		return 1;

	puts("Authentication key programming aborted\n");
	return 0;
}
static int do_mmcrpmb_key(cmd_tbl_t *cmdtp, int flag,
			  int argc, char * const argv[])
{
	void *key_addr;
	struct mmc *mmc = find_mmc_device(curr_device);

	if (argc != 2)
		return CMD_RET_USAGE;

	key_addr = (void *)simple_strtoul(argv[1], NULL, 16);
	if (!confirm_key_prog())
		return CMD_RET_FAILURE;
	if (mmc_rpmb_set_key(mmc, key_addr)) {
		printf("ERROR - Key already programmed ?\n");
		return CMD_RET_FAILURE;
	}
	return CMD_RET_SUCCESS;
}
static int do_mmcrpmb_read(cmd_tbl_t *cmdtp, int flag,
			   int argc, char * const argv[])
{
	u16 blk, cnt;
	void *addr;
	int n;
	void *key_addr = NULL;
	struct mmc *mmc = find_mmc_device(curr_device);

	if (argc < 4)
		return CMD_RET_USAGE;

	addr = (void *)simple_strtoul(argv[1], NULL, 16);
	blk = simple_strtoul(argv[2], NULL, 16);
	cnt = simple_strtoul(argv[3], NULL, 16);

	if (argc == 5)
		key_addr = (void *)simple_strtoul(argv[4], NULL, 16);

	printf("\nMMC RPMB read: dev # %d, block # %d, count %d ... ",
	       curr_device, blk, cnt);
	n =  mmc_rpmb_read(mmc, addr, blk, cnt, key_addr);

	printf("%d RPMB blocks read: %s\n", n, (n == cnt) ? "OK" : "ERROR");
	if (n != cnt)
		return CMD_RET_FAILURE;
	return CMD_RET_SUCCESS;
}
static int do_mmcrpmb_write(cmd_tbl_t *cmdtp, int flag,
			    int argc, char * const argv[])
{
	u16 blk, cnt;
	void *addr;
	int n;
	void *key_addr;
	struct mmc *mmc = find_mmc_device(curr_device);

	if (argc != 5)
		return CMD_RET_USAGE;

	addr = (void *)simple_strtoul(argv[1], NULL, 16);
	blk = simple_strtoul(argv[2], NULL, 16);
	cnt = simple_strtoul(argv[3], NULL, 16);
	key_addr = (void *)simple_strtoul(argv[4], NULL, 16);

	printf("\nMMC RPMB write: dev # %d, block # %d, count %d ... ",
	       curr_device, blk, cnt);
	n =  mmc_rpmb_write(mmc, addr, blk, cnt, key_addr);

	printf("%d RPMB blocks written: %s\n", n, (n == cnt) ? "OK" : "ERROR");
	if (n != cnt)
		return CMD_RET_FAILURE;
	return CMD_RET_SUCCESS;
}
static int do_mmcrpmb_counter(cmd_tbl_t *cmdtp, int flag,
			      int argc, char * const argv[])
{
	unsigned long counter;
	struct mmc *mmc = find_mmc_device(curr_device);

	if (mmc_rpmb_get_counter(mmc, &counter))
		return CMD_RET_FAILURE;
	printf("RPMB Write counter= %lx\n", counter);
	return CMD_RET_SUCCESS;
}

static cmd_tbl_t cmd_rpmb[] = {
	U_BOOT_CMD_MKENT(key, 2, 0, do_mmcrpmb_key, "", ""),
	U_BOOT_CMD_MKENT(read, 5, 1, do_mmcrpmb_read, "", ""),
	U_BOOT_CMD_MKENT(write, 5, 0, do_mmcrpmb_write, "", ""),
	U_BOOT_CMD_MKENT(counter, 1, 1, do_mmcrpmb_counter, "", ""),
};

static int do_mmcrpmb(cmd_tbl_t *cmdtp, int flag,
		      int argc, char * const argv[])
{
	cmd_tbl_t *cp;
	struct mmc *mmc;
	char original_part;
	int ret;

	cp = find_cmd_tbl(argv[1], cmd_rpmb, ARRAY_SIZE(cmd_rpmb));

	/* Drop the rpmb subcommand */
	argc--;
	argv++;

	if (cp == NULL || argc > cp->maxargs)
		return CMD_RET_USAGE;
	if (flag == CMD_FLAG_REPEAT && !cp->repeatable)
		return CMD_RET_SUCCESS;

	mmc = init_mmc_device(curr_device, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	if (!(mmc->version & MMC_VERSION_MMC)) {
		printf("It is not a EMMC device\n");
		return CMD_RET_FAILURE;
	}
	if (mmc->version < MMC_VERSION_4_41) {
		printf("RPMB not supported before version 4.41\n");
		return CMD_RET_FAILURE;
	}
	/* Switch to the RPMB partition */
	original_part = mmc->block_dev.hwpart;
	if (blk_select_hwpart_devnum(IF_TYPE_MMC, curr_device, MMC_PART_RPMB) !=
	    0)
		return CMD_RET_FAILURE;
	ret = cp->cmd(cmdtp, flag, argc, argv);

	/* Return to original partition */
	if (blk_select_hwpart_devnum(IF_TYPE_MMC, curr_device, original_part) !=
	    0)
		return CMD_RET_FAILURE;
	return ret;
}
#endif

static int do_mmc_read(cmd_tbl_t *cmdtp, int flag,
		       int argc, char * const argv[])
{
	struct mmc *mmc;
	u32 blk, cnt, n;
	void *addr;

	if (argc != 4)
		return CMD_RET_USAGE;

	addr = (void *)simple_strtoul(argv[1], NULL, 16);
	blk = simple_strtoul(argv[2], NULL, 16);
	cnt = simple_strtoul(argv[3], NULL, 16);

	mmc = init_mmc_device(curr_device, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	printf("\nMMC read: dev # %d, block # %d, count %d ... ",
	       curr_device, blk, cnt);

	n = blk_dread(mmc_get_blk_desc(mmc), blk, cnt, addr);
	/* flush cache after read */
	flush_cache((ulong)addr, cnt * 512); /* FIXME */
	printf("%d blocks read: %s\n", n, (n == cnt) ? "OK" : "ERROR");

	return (n == cnt) ? CMD_RET_SUCCESS : CMD_RET_FAILURE;
}
static int do_mmc_write(cmd_tbl_t *cmdtp, int flag,
			int argc, char * const argv[])
{
	struct mmc *mmc;
	u32 blk, cnt, n;
	void *addr;

	if (argc != 4)
		return CMD_RET_USAGE;

	addr = (void *)simple_strtoul(argv[1], NULL, 16);
	blk = simple_strtoul(argv[2], NULL, 16);
	cnt = simple_strtoul(argv[3], NULL, 16);

	mmc = init_mmc_device(curr_device, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	printf("\nMMC write: dev # %d, block # %d, count %d ... ",
	       curr_device, blk, cnt);

	if (mmc_getwp(mmc) == 1) {
		printf("Error: card is write protected!\n");
		return CMD_RET_FAILURE;
	}
	n = blk_dwrite(mmc_get_blk_desc(mmc), blk, cnt, addr);
	printf("%d blocks written: %s\n", n, (n == cnt) ? "OK" : "ERROR");

	return (n == cnt) ? CMD_RET_SUCCESS : CMD_RET_FAILURE;
}
static int do_mmc_erase(cmd_tbl_t *cmdtp, int flag,
			int argc, char * const argv[])
{
	struct mmc *mmc;
	u32 blk, cnt, n;

	if (argc != 3)
		return CMD_RET_USAGE;

	blk = simple_strtoul(argv[1], NULL, 16);
	cnt = simple_strtoul(argv[2], NULL, 16);

	mmc = init_mmc_device(curr_device, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	printf("\nMMC erase: dev # %d, block # %d, count %d ... ",
	       curr_device, blk, cnt);

	if (mmc_getwp(mmc) == 1) {
		printf("Error: card is write protected!\n");
		return CMD_RET_FAILURE;
	}
	n = blk_derase(mmc_get_blk_desc(mmc), blk, cnt);
	printf("%d blocks erased: %s\n", n, (n == cnt) ? "OK" : "ERROR");

	return (n == cnt) ? CMD_RET_SUCCESS : CMD_RET_FAILURE;
}
static int do_mmc_rescan(cmd_tbl_t *cmdtp, int flag,
			 int argc, char * const argv[])
{
	struct mmc *mmc;

	mmc = init_mmc_device(curr_device, true);
	if (!mmc)
		return CMD_RET_FAILURE;

	return CMD_RET_SUCCESS;
}
static int do_mmc_part(cmd_tbl_t *cmdtp, int flag,
		       int argc, char * const argv[])
{
	struct blk_desc *mmc_dev;
	struct mmc *mmc;

	mmc = init_mmc_device(curr_device, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	mmc_dev = blk_get_devnum_by_type(IF_TYPE_MMC, curr_device);
	if (mmc_dev != NULL && mmc_dev->type != DEV_TYPE_UNKNOWN) {
		part_print(mmc_dev);
		return CMD_RET_SUCCESS;
	}

	puts("get mmc type error!\n");
	return CMD_RET_FAILURE;
}
static int do_mmc_dev(cmd_tbl_t *cmdtp, int flag,
		      int argc, char * const argv[])
{
	int dev, part = 0, ret;
	struct mmc *mmc;

	if (argc == 1) {
		dev = curr_device;
	} else if (argc == 2) {
		dev = simple_strtoul(argv[1], NULL, 10);
	} else if (argc == 3) {
		dev = (int)simple_strtoul(argv[1], NULL, 10);
		part = (int)simple_strtoul(argv[2], NULL, 10);
		if (part > PART_ACCESS_MASK) {
			printf("#part_num shouldn't be larger than %d\n",
			       PART_ACCESS_MASK);
			return CMD_RET_FAILURE;
		}
	} else {
		return CMD_RET_USAGE;
	}

	mmc = init_mmc_device(dev, true);
	if (!mmc)
		return CMD_RET_FAILURE;

	ret = blk_select_hwpart_devnum(IF_TYPE_MMC, dev, part);
	printf("switch to partitions #%d, %s\n",
	       part, (!ret) ? "OK" : "ERROR");
	if (ret)
		return 1;

	curr_device = dev;
	if (mmc->part_config == MMCPART_NOAVAILABLE)
		printf("mmc%d is current device\n", curr_device);
	else
		printf("mmc%d(part %d) is current device\n",
		       curr_device, mmc_get_blk_desc(mmc)->hwpart);

	return CMD_RET_SUCCESS;
}
static int do_mmc_list(cmd_tbl_t *cmdtp, int flag,
		       int argc, char * const argv[])
{
	print_mmc_devices('\n');
	return CMD_RET_SUCCESS;
}

static int parse_hwpart_user(struct mmc_hwpart_conf *pconf,
			     int argc, char * const argv[])
{
	int i = 0;

	memset(&pconf->user, 0, sizeof(pconf->user));

	while (i < argc) {
		if (!strcmp(argv[i], "enh")) {
			if (i + 2 >= argc)
				return -1;
			pconf->user.enh_start =
				simple_strtoul(argv[i+1], NULL, 10);
			pconf->user.enh_size =
				simple_strtoul(argv[i+2], NULL, 10);
			i += 3;
		} else if (!strcmp(argv[i], "wrrel")) {
			if (i + 1 >= argc)
				return -1;
			pconf->user.wr_rel_change = 1;
			if (!strcmp(argv[i+1], "on"))
				pconf->user.wr_rel_set = 1;
			else if (!strcmp(argv[i+1], "off"))
				pconf->user.wr_rel_set = 0;
			else
				return -1;
			i += 2;
		} else {
			break;
		}
	}
	return i;
}

static int parse_hwpart_gp(struct mmc_hwpart_conf *pconf, int pidx,
			   int argc, char * const argv[])
{
	int i;

	memset(&pconf->gp_part[pidx], 0, sizeof(pconf->gp_part[pidx]));

	if (1 >= argc)
		return -1;
	pconf->gp_part[pidx].size = simple_strtoul(argv[0], NULL, 10);

	i = 1;
	while (i < argc) {
		if (!strcmp(argv[i], "enh")) {
			pconf->gp_part[pidx].enhanced = 1;
			i += 1;
		} else if (!strcmp(argv[i], "wrrel")) {
			if (i + 1 >= argc)
				return -1;
			pconf->gp_part[pidx].wr_rel_change = 1;
			if (!strcmp(argv[i+1], "on"))
				pconf->gp_part[pidx].wr_rel_set = 1;
			else if (!strcmp(argv[i+1], "off"))
				pconf->gp_part[pidx].wr_rel_set = 0;
			else
				return -1;
			i += 2;
		} else {
			break;
		}
	}
	return i;
}

static int do_mmc_hwpartition(cmd_tbl_t *cmdtp, int flag,
			      int argc, char * const argv[])
{
	struct mmc *mmc;
	struct mmc_hwpart_conf pconf = { };
	enum mmc_hwpart_conf_mode mode = MMC_HWPART_CONF_CHECK;
	int i, r, pidx;

	mmc = init_mmc_device(curr_device, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	if (argc < 1)
		return CMD_RET_USAGE;
	i = 1;
	while (i < argc) {
		if (!strcmp(argv[i], "user")) {
			i++;
			r = parse_hwpart_user(&pconf, argc-i, &argv[i]);
			if (r < 0)
				return CMD_RET_USAGE;
			i += r;
		} else if (!strncmp(argv[i], "gp", 2) &&
			   strlen(argv[i]) == 3 &&
			   argv[i][2] >= '1' && argv[i][2] <= '4') {
			pidx = argv[i][2] - '1';
			i++;
			r = parse_hwpart_gp(&pconf, pidx, argc-i, &argv[i]);
			if (r < 0)
				return CMD_RET_USAGE;
			i += r;
		} else if (!strcmp(argv[i], "check")) {
			mode = MMC_HWPART_CONF_CHECK;
			i++;
		} else if (!strcmp(argv[i], "set")) {
			mode = MMC_HWPART_CONF_SET;
			i++;
		} else if (!strcmp(argv[i], "complete")) {
			mode = MMC_HWPART_CONF_COMPLETE;
			i++;
		} else {
			return CMD_RET_USAGE;
		}
	}

	puts("Partition configuration:\n");
	if (pconf.user.enh_size) {
		puts("\tUser Enhanced Start: ");
		print_size(((u64)pconf.user.enh_start) << 9, "\n");
		puts("\tUser Enhanced Size: ");
		print_size(((u64)pconf.user.enh_size) << 9, "\n");
	} else {
		puts("\tNo enhanced user data area\n");
	}
	if (pconf.user.wr_rel_change)
		printf("\tUser partition write reliability: %s\n",
		       pconf.user.wr_rel_set ? "on" : "off");
	for (pidx = 0; pidx < 4; pidx++) {
		if (pconf.gp_part[pidx].size) {
			printf("\tGP%i Capacity: ", pidx+1);
			print_size(((u64)pconf.gp_part[pidx].size) << 9,
				   pconf.gp_part[pidx].enhanced ?
				   " ENH\n" : "\n");
		} else {
			printf("\tNo GP%i partition\n", pidx+1);
		}
		if (pconf.gp_part[pidx].wr_rel_change)
			printf("\tGP%i write reliability: %s\n", pidx+1,
			       pconf.gp_part[pidx].wr_rel_set ? "on" : "off");
	}

	if (!mmc_hwpart_config(mmc, &pconf, mode)) {
		if (mode == MMC_HWPART_CONF_COMPLETE)
			puts("Partitioning successful, "
			     "power-cycle to make effective\n");
		return CMD_RET_SUCCESS;
	} else {
		puts("Failed!\n");
		return CMD_RET_FAILURE;
	}
}

#ifdef CONFIG_SUPPORT_EMMC_BOOT
static int do_mmc_bootbus(cmd_tbl_t *cmdtp, int flag,
			  int argc, char * const argv[])
{
	int dev;
	struct mmc *mmc;
	u8 width, reset, mode;

	if (argc != 5)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[1], NULL, 10);
	width = simple_strtoul(argv[2], NULL, 10);
	reset = simple_strtoul(argv[3], NULL, 10);
	mode = simple_strtoul(argv[4], NULL, 10);

	mmc = init_mmc_device(dev, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	if (IS_SD(mmc)) {
		puts("BOOT_BUS_WIDTH only exists on eMMC\n");
		return CMD_RET_FAILURE;
	}

	/* acknowledge to be sent during boot operation */
	return mmc_set_boot_bus_width(mmc, width, reset, mode);
}
static int do_mmc_boot_resize(cmd_tbl_t *cmdtp, int flag,
			      int argc, char * const argv[])
{
	int dev;
	struct mmc *mmc;
	u32 bootsize, rpmbsize;

	if (argc != 4)
		return CMD_RET_USAGE;
	dev = simple_strtoul(argv[1], NULL, 10);
	bootsize = simple_strtoul(argv[2], NULL, 10);
	rpmbsize = simple_strtoul(argv[3], NULL, 10);

	mmc = init_mmc_device(dev, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	if (IS_SD(mmc)) {
		printf("It is not a EMMC device\n");
		return CMD_RET_FAILURE;
	}

	if (mmc_boot_partition_size_change(mmc, bootsize, rpmbsize)) {
		printf("EMMC boot partition Size change Failed.\n");
		return CMD_RET_FAILURE;
	}

	printf("EMMC boot partition Size %d MB\n", bootsize);
	printf("EMMC RPMB partition Size %d MB\n", rpmbsize);
	return CMD_RET_SUCCESS;
}
static int do_mmc_partconf(cmd_tbl_t *cmdtp, int flag,
			   int argc, char * const argv[])
{
	int dev;
	struct mmc *mmc;
	u8 ack, part_num, access;

	if (argc != 5)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[1], NULL, 10);
	ack = simple_strtoul(argv[2], NULL, 10);
	part_num = simple_strtoul(argv[3], NULL, 10);
	access = simple_strtoul(argv[4], NULL, 10);

	mmc = init_mmc_device(dev, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	if (IS_SD(mmc)) {
		puts("PARTITION_CONFIG only exists on eMMC\n");
		return CMD_RET_FAILURE;
	}

	/* acknowledge to be sent during boot operation */
	return mmc_set_part_conf(mmc, ack, part_num, access);
}
static int do_mmc_rst_func(cmd_tbl_t *cmdtp, int flag,
			   int argc, char * const argv[])
{
	int dev;
	struct mmc *mmc;
	u8 enable;

	/*
	 * Set the RST_n_ENABLE bit of RST_n_FUNCTION
	 * The only valid values are 0x0, 0x1 and 0x2 and writing
	 * a value of 0x1 or 0x2 sets the value permanently.
	 */
	if (argc != 3)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[1], NULL, 10);
	enable = simple_strtoul(argv[2], NULL, 10);

	if (enable > 2) {
		puts("Invalid RST_n_ENABLE value\n");
		return CMD_RET_USAGE;
	}

	mmc = init_mmc_device(dev, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	if (IS_SD(mmc)) {
		puts("RST_n_FUNCTION only exists on eMMC\n");
		return CMD_RET_FAILURE;
	}

	return mmc_set_rst_n_function(mmc, enable);
}
#endif
static int do_mmc_setdsr(cmd_tbl_t *cmdtp, int flag,
			 int argc, char * const argv[])
{
	struct mmc *mmc;
	u32 val;
	int ret;

	if (argc != 2)
		return CMD_RET_USAGE;
	val = simple_strtoul(argv[1], NULL, 16);

	mmc = find_mmc_device(curr_device);
	if (!mmc) {
		printf("no mmc device at slot %x\n", curr_device);
		return CMD_RET_FAILURE;
	}
	ret = mmc_set_dsr(mmc, val);
	printf("set dsr %s\n", (!ret) ? "OK, force rescan" : "ERROR");
	if (!ret) {
		mmc->has_init = 0;
		if (mmc_init(mmc))
			return CMD_RET_FAILURE;
		else
			return CMD_RET_SUCCESS;
	}
	return ret;
}

#ifdef CONFIG_CMD_BKOPS_ENABLE
static int do_mmc_bkops_enable(cmd_tbl_t *cmdtp, int flag,
				   int argc, char * const argv[])
{
	int dev;
	struct mmc *mmc;

	if (argc != 2)
		return CMD_RET_USAGE;

	dev = simple_strtoul(argv[1], NULL, 10);

	mmc = init_mmc_device(dev, false);
	if (!mmc)
		return CMD_RET_FAILURE;

	if (IS_SD(mmc)) {
		puts("BKOPS_EN only exists on eMMC\n");
		return CMD_RET_FAILURE;
	}

	return mmc_set_bkops_enable(mmc);
}
#endif

static cmd_tbl_t cmd_mmc[] = {
	U_BOOT_CMD_MKENT(info, 1, 0, do_mmcinfo, "", ""),
	U_BOOT_CMD_MKENT(read, 4, 1, do_mmc_read, "", ""),
	U_BOOT_CMD_MKENT(write, 4, 0, do_mmc_write, "", ""),
	U_BOOT_CMD_MKENT(erase, 3, 0, do_mmc_erase, "", ""),
	U_BOOT_CMD_MKENT(rescan, 1, 1, do_mmc_rescan, "", ""),
	U_BOOT_CMD_MKENT(part, 1, 1, do_mmc_part, "", ""),
	U_BOOT_CMD_MKENT(dev, 3, 0, do_mmc_dev, "", ""),
	U_BOOT_CMD_MKENT(list, 1, 1, do_mmc_list, "", ""),
	U_BOOT_CMD_MKENT(hwpartition, 28, 0, do_mmc_hwpartition, "", ""),
#ifdef CONFIG_SUPPORT_EMMC_BOOT
	U_BOOT_CMD_MKENT(bootbus, 5, 0, do_mmc_bootbus, "", ""),
	U_BOOT_CMD_MKENT(bootpart-resize, 4, 0, do_mmc_boot_resize, "", ""),
	U_BOOT_CMD_MKENT(partconf, 5, 0, do_mmc_partconf, "", ""),
	U_BOOT_CMD_MKENT(rst-function, 3, 0, do_mmc_rst_func, "", ""),
#endif
#ifdef CONFIG_SUPPORT_EMMC_RPMB
	U_BOOT_CMD_MKENT(rpmb, CONFIG_SYS_MAXARGS, 1, do_mmcrpmb, "", ""),
#endif
	U_BOOT_CMD_MKENT(setdsr, 2, 0, do_mmc_setdsr, "", ""),
#ifdef CONFIG_CMD_BKOPS_ENABLE
	U_BOOT_CMD_MKENT(bkops-enable, 2, 0, do_mmc_bkops_enable, "", ""),
#endif
};

static int do_mmcops(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	cmd_tbl_t *cp;

	cp = find_cmd_tbl(argv[1], cmd_mmc, ARRAY_SIZE(cmd_mmc));

	/* Drop the mmc command */
	argc--;
	argv++;

	if (cp == NULL || argc > cp->maxargs)
		return CMD_RET_USAGE;
	if (flag == CMD_FLAG_REPEAT && !cp->repeatable)
		return CMD_RET_SUCCESS;

	if (curr_device < 0) {
		if (get_mmc_num() > 0) {
			curr_device = 0;
		} else {
			puts("No MMC device available\n");
			return CMD_RET_FAILURE;
		}
	}
	return cp->cmd(cmdtp, flag, argc, argv);
}

U_BOOT_CMD(
	mmc, 29, 1, do_mmcops,
	"MMC sub system",
	"info - display info of the current MMC device\n"
	"mmc read addr blk# cnt\n"
	"mmc write addr blk# cnt\n"
	"mmc erase blk# cnt\n"
	"mmc rescan\n"
	"mmc part - lists available partition on current mmc device\n"
	"mmc dev [dev] [part] - show or set current mmc device [partition]\n"
	"mmc list - lists available devices\n"
	"mmc hwpartition [args...] - does hardware partitioning\n"
	"  arguments (sizes in 512-byte blocks):\n"
	"    [user [enh start cnt] [wrrel {on|off}]] - sets user data area attributes\n"
	"    [gp1|gp2|gp3|gp4 cnt [enh] [wrrel {on|off}]] - general purpose partition\n"
	"    [check|set|complete] - mode, complete set partitioning completed\n"
	"  WARNING: Partitioning is a write-once setting once it is set to complete.\n"
	"  Power cycling is required to initialize partitions after set to complete.\n"
#ifdef CONFIG_SUPPORT_EMMC_BOOT
	"mmc bootbus dev boot_bus_width reset_boot_bus_width boot_mode\n"
	" - Set the BOOT_BUS_WIDTH field of the specified device\n"
	"mmc bootpart-resize <dev> <boot part size MB> <RPMB part size MB>\n"
	" - Change sizes of boot and RPMB partitions of specified device\n"
	"mmc partconf dev boot_ack boot_partition partition_access\n"
	" - Change the bits of the PARTITION_CONFIG field of the specified device\n"
	"mmc rst-function dev value\n"
	" - Change the RST_n_FUNCTION field of the specified device\n"
	"   WARNING: This is a write-once field and 0 / 1 / 2 are the only valid values.\n"
#endif
#ifdef CONFIG_SUPPORT_EMMC_RPMB
	"mmc rpmb read addr blk# cnt [address of auth-key] - block size is 256 bytes\n"
	"mmc rpmb write addr blk# cnt <address of auth-key> - block size is 256 bytes\n"
	"mmc rpmb key <address of auth-key> - program the RPMB authentication key.\n"
	"mmc rpmb counter - read the value of the write counter\n"
#endif
	"mmc setdsr <value> - set DSR register value\n"
#ifdef CONFIG_CMD_BKOPS_ENABLE
	"mmc bkops-enable <dev> - enable background operations handshake on device\n"
	"   WARNING: This is a write-once setting.\n"
#endif
	);

/* Old command kept for compatibility. Same as 'mmc info' */
U_BOOT_CMD(
	mmcinfo, 1, 0, do_mmcinfo,
	"display MMC info",
	"- display info of the current MMC device"
);

#ifdef CONFIG_SUPPORT_EMMC_BOOT
static int do_emmc(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int rc = 0;

	if (argc != 3)
		return	CMD_RET_USAGE;

	if (strcmp(argv[1], "open") == 0) {
		int dev = simple_strtoul(argv[2], NULL, 10);
		struct mmc *mmc = find_mmc_device(dev);

		if (!mmc)
			goto out;

		if (IS_SD(mmc)) {
			printf("MMC%d device is SD.!!\n", dev);
			return	CMD_RET_FAILURE;
		}

		rc = emmc_boot_open(mmc);

		if (rc == 0) {
			printf("eMMC OPEN Success.!!\n");
			printf("\t\t\t!!!Notice!!!\n");
			printf("!You must close eMMC boot Partition after all image writing!\n");
			printf("!eMMC boot partition has continuity at image writing time.!\n");
			printf("!So, Do not close boot partition, Before, all images is written.!\n");
		} else {
			printf("eMMC OPEN Failed.!!\n");
			return	CMD_RET_FAILURE;
		}
	} else if (strcmp(argv[1], "close") == 0) {
		int dev = simple_strtoul(argv[2], NULL, 10);
		struct mmc *mmc = find_mmc_device(dev);

		if (!mmc)
			goto out;

		if (IS_SD(mmc)) {
			printf("MMC%d device is SD.!!\n", dev);
			return	CMD_RET_FAILURE;
		}

		rc = emmc_boot_close(mmc);

		if (rc == 0) {
			printf("eMMC CLOSE Success.!!\n");
		} else {
			printf("eMMC CLOSE Failed.!!\n");
			return	CMD_RET_FAILURE;
		}
	} else {
		goto out;
	}
	return	CMD_RET_SUCCESS;
out:
	puts("No MMC device available\n");
	return	CMD_RET_FAILURE;
}

U_BOOT_CMD(
	emmc, 3, 0, do_emmc,
	"Open/Close eMMC boot partition",
	"open <device_num> \n"
	"emmc close <device_num> \n"
);

#endif

#ifdef CONFIG_FASTBOOT

#include <memalign.h>

#define	CHS_MODE	0
#define	LBA_MODE	!(CHS_MODE)

typedef struct
{
	uint	C_start, C_end;
	uint	H_start, H_end;
	uint	S_start, S_end;

	uint	available_block;
	uint	unit;
	uint	total_block_count;

	/* LBA or CHS mode */
	uint	addr_mode;
} SDInfo;

typedef struct
{
	uchar	bootable;
	uchar	partitionId;

	uint	C_start, C_end;
	uint	H_start, H_end;
	uint	S_start, S_end;

	u64	block_start;
	u64	block_count;
	u64	block_end;
} PartitionInfo;

#define	LBA_MODE_SIZE	(1023*254*63)

static u64 calc_unit(u64 length, SDInfo sdInfo)
{
	if (sdInfo.addr_mode == CHS_MODE)
		return ( (length / MOVI_BLK_SIZE / sdInfo.unit + 1 ) * sdInfo.unit);
	else
		return ( (length / MOVI_BLK_SIZE) );
}

static void encode_chs(uint C, uint H, uint S, uchar *result)
{
	*result++ = (uchar)   H;
	*result++ = (uchar) ( S + ((C & 0x00000300) >> 2) );
	*result   = (uchar) ( C & 0x000000FF );
}

static void encode_partitionInfo(PartitionInfo partInfo, uchar *result)
{
	uint blk_start = partInfo.block_start;
	uint blk_count = partInfo.block_count;

	*result++ = partInfo.bootable;

	encode_chs(partInfo.C_start, partInfo.H_start, partInfo.S_start, result);
	result +=3;
	*result++ = partInfo.partitionId;

	encode_chs(partInfo.C_end, partInfo.H_end, partInfo.S_end, result);
	result += 3;

	memcpy(result, (uchar *)&(blk_start), 4);
	result += 4;

	memcpy(result, (uchar *)&(blk_count), 4);
}

static void decode_partitionInfo(uchar *in, PartitionInfo *partInfo)
{
	uint blk_start, blk_count;

	partInfo->bootable	= *in;
	partInfo->partitionId	= *(in + 4);

	memcpy((uchar *)&(blk_start), (in + 8), 4);
	memcpy((uchar *)&(blk_count), (in +12), 4);

	partInfo->block_start = blk_start;
	partInfo->block_count = blk_count;
}

static void get_SDInfo(int block_count, SDInfo *sdInfo)
{
	uint C, H, S;

	uint C_max = 1023, H_max = 254, S_max = 63;
	uint H_start = 1, S_start = 1;
	uint diff_min = 0, diff = 0;

	if(block_count >= LBA_MODE_SIZE)
		sdInfo->addr_mode = LBA_MODE;
	else
		sdInfo->addr_mode = CHS_MODE;

	if (sdInfo->addr_mode == CHS_MODE) {
		diff_min = C_max;

		for (H = H_start; H <= H_max; H++) {
			for (S  = S_start; S <= S_max; S++) {
				C = block_count / (H * S);

				if ( (C <= C_max) ) {
					diff = C_max - C;
					if (diff <= diff_min) {
						diff_min = diff;
						sdInfo->C_end = C;
						sdInfo->H_end = H;
						sdInfo->S_end = S;
					}
				}
			}
		}
	} else {
		sdInfo->C_end = 1023;
		sdInfo->H_end = 254;
		sdInfo->S_end = 63;
	}

	sdInfo->C_start	= 0;
	sdInfo->H_start	= 1;
	sdInfo->S_start	= 1;

	sdInfo->total_block_count	= block_count;
	sdInfo->available_block		= sdInfo->C_end * sdInfo->H_end * sdInfo->S_end;
	sdInfo->unit			= sdInfo->H_end * sdInfo->S_end;
}

static void make_partitionInfo(u64 LBA_start,
	u64 count, SDInfo sdInfo, PartitionInfo *partInfo)
{
	u64	temp = 0;
	u64	part_start_blk;

	partInfo->block_start = LBA_start;

	if (sdInfo.addr_mode == CHS_MODE) {
		partInfo->C_start	= partInfo->block_start / (sdInfo.H_end * sdInfo.S_end);
		temp			= partInfo->block_start % (sdInfo.H_end * sdInfo.S_end);
		partInfo->H_start	= temp / sdInfo.S_end;
		partInfo->S_start	= temp % sdInfo.S_end + 1;

		if (count == MOVI_BLK_END) {
			part_start_blk 		= calc_unit(ANDROID_PART_START, sdInfo);
			partInfo->block_end	= sdInfo.C_end * sdInfo.H_end * sdInfo.S_end - part_start_blk - 1;
			partInfo->block_count	= partInfo->block_end - partInfo->block_start + 1;

			partInfo->C_end = partInfo->block_end / sdInfo.unit;
			partInfo->H_end = sdInfo.H_end - 1;
			partInfo->S_end = sdInfo.S_end;
		} else {
			partInfo->block_count	= count;

			partInfo->block_end	= partInfo->block_start + count - 1;
			partInfo->C_end		= partInfo->block_end / sdInfo.unit;

			temp			= partInfo->block_end % sdInfo.unit;
			partInfo->H_end		= temp / sdInfo.S_end;
			partInfo->S_end		= temp % sdInfo.S_end + 1;
		}
	} else {
		partInfo->C_start	= 0;
		partInfo->H_start	= 1;
		partInfo->S_start	= 1;

		partInfo->C_end		= 1023;
		partInfo->H_end		= 254;
		partInfo->S_end		= 63;

		if (count == MOVI_BLK_END) {
			part_start_blk 		= calc_unit(ANDROID_PART_START, sdInfo);
			partInfo->block_end	= sdInfo.total_block_count - part_start_blk - 1;
			partInfo->block_count	= partInfo->block_end - partInfo->block_start + 1;
		} else {
			partInfo->block_count	= count;
			partInfo->block_end	= partInfo->block_start + count - 1;
		}
	}
}

/* partition setup info struct */
struct psetup_info {
	int	expand_part;
	u64	part_size[4];
};

static int check_partition_param(int total_block_count,
	int argc, char * const argv[],  int *expand_part, u64 *psize)
{
	int	expand_part_cnt = 0, i;
	u64	setup_block_cnt;

	/* default expand partition is fat */
	*expand_part = 3;

	switch(argc) {
	/* fdisk -c {dev} */
	case	3:
		/* default value setup */
		psize[0] = PART_SIZE_SYSTEM;
		psize[1] = PART_SIZE_USERDATA;
		psize[2] = PART_SIZE_CACHE;
		psize[3] = 0;
		break;
	/* fdisk -c {dev} {system} {userdata} {cache} */
	case	6:
		for (i = 0; i < 3; i++) {
			psize[i] = simple_strtoul(argv[3 + i], NULL, 0);
			psize[i] = psize[i] * SZ_1M;
		}
		psize[i] = 0;
		break;
	/* fdisk -c {dev} {system} {userdata} {cache} {fat} */
	case	7:
		for (i = 0; i < 4; i++) {
			if ( strncmp(argv[3 + i],  "0", sizeof("0")) &&
			     strncmp(argv[3 + i], "-1", sizeof("-1")) ) {
				psize[i] = simple_strtoul(argv[3 + i], NULL, 0);
				psize[i] = psize[i] * SZ_1M;
			} else {
				expand_part_cnt++;
				*expand_part = i;
				psize[i] = 0;
			}
		}
		break;
	default :
		printf("Error : ");
		printf("Wrong param count.(param count = %d\n",
			argc);
		return	-1;
	}

	if (expand_part_cnt > 1) {
		printf("\nError : ");
		printf("Only one partition can be expanded.(expand part = %d)\n",
			expand_part_cnt);
		printf("\nDefault partition setup : \n");
		printf("System 1GB / Cache 256MB / FAT 100MB / Expand Userdata\n");
		psize[0] = PART_SIZE_SYSTEM;
		psize[1] = 0;
		psize[2] = PART_SIZE_CACHE;
		psize[3] = 100 * SZ_1M;
		*expand_part = 1;
	}

	setup_block_cnt = psize[0] + psize[1] + psize[2] + psize[3];
	setup_block_cnt = (setup_block_cnt / MMC_MAX_BLOCK_LEN);

	if (total_block_count < setup_block_cnt) {
		printf("Error : ");
		printf("Block size overflow.(total_block = %d, cal block = %lld)\n",
			total_block_count, setup_block_cnt);
		return	-1;
	}
	return	0;
}

static int make_mmc_partition(int total_block_count, uchar *mbr,
	int argc, char * const argv[])
{
	u64		block_start = 0, block_offset, psize[4];
	int		expand_part;
	SDInfo		sdInfo;
	PartitionInfo	partInfo[4];

	if(check_partition_param(total_block_count, argc, argv,
		&expand_part, psize))
		return	-1;

	memset((uchar *)&sdInfo, 0x00, sizeof(SDInfo));

	get_SDInfo(total_block_count, &sdInfo);

	block_start = calc_unit(ANDROID_PART_START, sdInfo);

	/* system partition */
	if (expand_part != 0) {
		block_offset = calc_unit(psize[0], sdInfo);
		partInfo[0].bootable	= 0x00;
		partInfo[0].partitionId	= 0x83;
		make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[0]);
		block_start += block_offset;
	}

	/* userdata partition */
	if (expand_part != 1) {
		block_offset = calc_unit(psize[1], sdInfo);
		partInfo[1].bootable	= 0x00;
		partInfo[1].partitionId	= 0x83;
		make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[1]);
		block_start += block_offset;
	}

	/* cache partition */
	if (expand_part != 2) {
		block_offset = calc_unit(psize[2], sdInfo);
		partInfo[2].bootable	= 0x00;
		partInfo[2].partitionId	= 0x83;
		make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[2]);
		block_start += block_offset;
	}

	/* fat partition */
	if (expand_part != 3) {
		block_offset = calc_unit(psize[3], sdInfo);
		partInfo[3].bootable	= 0x00;
		partInfo[3].partitionId	= 0x0C;
		make_partitionInfo(block_start, block_offset, sdInfo, &partInfo[3]);
		block_start += block_offset;
	}

	/* expand partition setup */
	block_offset = MOVI_BLK_END;

	partInfo[expand_part].bootable	= 0x00;
	partInfo[expand_part].partitionId = expand_part != 3 ? 0x83 : 0x0C;

	make_partitionInfo(block_start, block_offset, sdInfo,
		&partInfo[expand_part]);

	memset(mbr, 0x00, sizeof(mbr));
	mbr[510] = 0x55; mbr[511] = 0xAA;

	encode_partitionInfo(partInfo[0], &mbr[0x1CE]);
	encode_partitionInfo(partInfo[1], &mbr[0x1DE]);
	encode_partitionInfo(partInfo[2], &mbr[0x1EE]);
	encode_partitionInfo(partInfo[3], &mbr[0x1BE]);

	return 0;
}

static uint get_mmc_block_count(char *device_name)
{
	struct mmc *mmc;
	int block_count = 0;
	int dev_num;

	dev_num = simple_strtoul(device_name, NULL, 0);

	mmc = find_mmc_device(dev_num);

	if (!mmc || !mmc->capacity) {
		puts("No MMC device available\n");
		return -1;
	}

	block_count = mmc->capacity / mmc->read_bl_len;

	return block_count;
}

static int get_mmc_mbr(char *device_name, uchar *mbr)
{
	int rv;
	struct mmc *mmc;
	int dev_num;

	dev_num = simple_strtoul(device_name, NULL, 0);

	mmc = find_mmc_device(dev_num);
	if (!mmc || !mmc->capacity) {
		puts("No MMC device available\n");
		return -1;
	}

	rv = mmc->block_dev.block_read(&mmc->block_dev, 0, 1, mbr);

	if(rv == 1)
		return 0;
	else
		return -1;
}

static int put_mmc_mbr(uchar *mbr, char *device_name)
{
	int rv;
	struct mmc *mmc;
	int dev_num;

	dev_num = simple_strtoul(device_name, NULL, 0);

	mmc = find_mmc_device(dev_num);
	if (!mmc || !mmc->capacity) {
		puts("No MMC device available\n");
		return	-1;
	}

	rv = mmc->block_dev.block_write(&mmc->block_dev, 0, 1, mbr);

	/*
	 * TODO : set boot partition size for emmc
	 * mmc->ext_csd.boot_size_multi = 0;
	 */
	mmc = init_mmc_device(dev_num, true);
	if (!mmc) {
		printf("Card NOT detected or Init Failed!!\n");
		return	-1;
	}

	if(rv == 1)
		return	0;
	else
		return	-1;
}

int get_mmc_part_info(char *device_name, int part_num,
	u64 *block_start, u64 *block_count, uchar *part_Id)
{
	int		rv;
	PartitionInfo	partInfo;
	ALLOC_CACHE_ALIGN_BUFFER(uchar, mbr, 512);

	rv = get_mmc_mbr(device_name, mbr);
	if(rv !=0)
		return -1;

	switch(part_num)
	{
		case 1:
			decode_partitionInfo(&mbr[0x1BE], &partInfo);
			*block_start	= partInfo.block_start;
			*block_count	= partInfo.block_count;
			*part_Id 	= partInfo.partitionId;
			break;
		case 2:
			decode_partitionInfo(&mbr[0x1CE], &partInfo);
			*block_start	= partInfo.block_start;
			*block_count	= partInfo.block_count;
			*part_Id 	= partInfo.partitionId;
			break;
		case 3:
			decode_partitionInfo(&mbr[0x1DE], &partInfo);
			*block_start	= partInfo.block_start;
			*block_count	= partInfo.block_count;
			*part_Id 	= partInfo.partitionId;
			break;
		case 4:
			decode_partitionInfo(&mbr[0x1EE], &partInfo);
			*block_start	= partInfo.block_start;
			*block_count	= partInfo.block_count;
			*part_Id 	= partInfo.partitionId;
			break;
		default:
			return -1;
	}
	return 0;
}

static int print_mmc_part_info(int argc, char * const argv[])
{
	PartitionInfo	partInfo[4];

	if (get_mmc_part_info(argv[2], 1, &(partInfo[0].block_start), &(partInfo[0].block_count),
			&(partInfo[0].partitionId) ))	return	CMD_RET_FAILURE;

	if (get_mmc_part_info(argv[2], 2, &(partInfo[1].block_start), &(partInfo[1].block_count),
			&(partInfo[1].partitionId) ))	return	CMD_RET_FAILURE;

	if (get_mmc_part_info(argv[2], 3, &(partInfo[2].block_start), &(partInfo[2].block_count),
			&(partInfo[2].partitionId) ))	return	CMD_RET_FAILURE;

	if (get_mmc_part_info(argv[2], 4, &(partInfo[3].block_start), &(partInfo[3].block_count),
			&(partInfo[3].partitionId) ))	return	CMD_RET_FAILURE;

	printf("\n");
	printf("partion #    size(MB)     block start #    block count    partition_Id \n");

	if ( (partInfo[0].block_start !=0) && (partInfo[0].block_count != 0) )
		printf("   1        %6lld         %8lld        %8lld          0x%.2X \n",
			(partInfo[0].block_count / 2048), partInfo[0].block_start,
			partInfo[0].block_count, partInfo[0].partitionId);

	if ( (partInfo[1].block_start !=0) && (partInfo[1].block_count != 0) )
		printf("   2        %6lld         %8lld        %8lld          0x%.2X \n",
			(partInfo[1].block_count / 2048), partInfo[1].block_start,
			partInfo[1].block_count, partInfo[1].partitionId);

	if ( (partInfo[2].block_start !=0) && (partInfo[2].block_count != 0) )
		printf("   3        %6lld         %8lld        %8lld          0x%.2X \n",
			(partInfo[2].block_count / 2048), partInfo[2].block_start,
			partInfo[2].block_count, partInfo[2].partitionId);

	if ( (partInfo[3].block_start !=0) && (partInfo[3].block_count != 0) )
		printf("   4        %6lld         %8lld        %8lld          0x%.2X \n",
			(partInfo[3].block_count / 2048), partInfo[3].block_start,
			partInfo[3].block_count, partInfo[3].partitionId);

	return	CMD_RET_SUCCESS;
}

static int create_mmc_fdisk(int argc, char * const argv[])
{
	int	rv;
	uint	total_block_count;
	ALLOC_CACHE_ALIGN_BUFFER(uchar, mbr, 512);

	memset(mbr, 0x00, 512);

	total_block_count = get_mmc_block_count(argv[2]);
	if (total_block_count < 0)
		return CMD_RET_FAILURE;

	make_mmc_partition(total_block_count, mbr, argc, argv);

	rv = put_mmc_mbr(mbr, argv[2]);
	if (rv != 0)
		return CMD_RET_FAILURE;

	puts("\nfdisk is completed\n");

	return	CMD_RET_SUCCESS;
}

static int do_fdisk(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	switch (argc) {
	default :
		break;
	case	3:	case	6:	case	7:
		if (argv[2][0] != '0' && argv[2][0] != '1') {
			printf("Error :");
			printf("Wrong device number\n");
			return	CMD_RET_FAILURE;
		}
		if (argv[1][1] == 'c')
			create_mmc_fdisk(argc, argv);
		if (argv[1][1] == 'c' || argv[1][1] == 'p') {
			argv[1][1] = 'p';
			print_mmc_part_info(argc, argv);
			return	CMD_RET_SUCCESS;
		}
	}
	return	CMD_RET_USAGE;
}

U_BOOT_CMD (
	fdisk, 7, 0, do_fdisk,
	"Create(-c) or show(-p) partitions in mmc.",
	"-c <device_num> [<systemt size(MB)> <user data size(MB)> <cache size(MB)> [fat size(MB)]\n"
	"fdisk -p <device_num>\n"
);


#define	GB_BLK_CNT	((1024*1024*1024)/(512))

static int do_get_mmc_size(cmd_tbl_t *cmdtp, int flag, int argc, char * const argv[])
{
	int total_blk_cnt = 0;

	if ( argc == 2 )
	{
		total_blk_cnt = get_mmc_block_count(argv[1]);

		if 	(total_blk_cnt > (200 * GB_BLK_CNT))	setenv("mmc_size_gb", "256");
		else if (total_blk_cnt > (100 * GB_BLK_CNT))	setenv("mmc_size_gb", "128");
		else if (total_blk_cnt > (50  * GB_BLK_CNT))	setenv("mmc_size_gb", "64");
		else if (total_blk_cnt > (25  * GB_BLK_CNT))	setenv("mmc_size_gb", "32");
		else if (total_blk_cnt > (10  * GB_BLK_CNT))	setenv("mmc_size_gb", "16");
		else if (total_blk_cnt > (5   * GB_BLK_CNT))	setenv("mmc_size_gb", "8");
		else if (total_blk_cnt > (3   * GB_BLK_CNT))	setenv("mmc_size_gb", "4");
		else if (total_blk_cnt > (1   * GB_BLK_CNT))	setenv("mmc_size_gb", "2");
		else						setenv("mmc_size_gb", "1");

		if (total_blk_cnt <= 0)  {
			setenv("mmc_size_gb", "0");
			return	CMD_RET_FAILURE;
		}
		return	CMD_RET_SUCCESS;
	}
	return	CMD_RET_USAGE;
}

U_BOOT_CMD(
	get_mmc_size, 2, 0, do_get_mmc_size,
	"Check mmc device size.",
	"<device_num>\n"
	"MMC size writes to env variable mmc_size_gb [1, 2, 4, 8, 16, 32, 64, 128]\n"
);

#include <samsung/odroid_misc.h>

static int get_partition_info(const char *ptn, struct partition_info *pinfo)
{
	switch(ptn[0]) {
	case	'f':
		return	odroid_get_partition_info("fwbl1", pinfo);
	case	'b':
		return	odroid_get_partition_info("bl2", pinfo);
	case	'u':
		return	odroid_get_partition_info("bootloader", pinfo);
	case	't':
		return	odroid_get_partition_info("tzsw", pinfo);
	case	'k':
		return	odroid_get_partition_info("kernel", pinfo);
	default:
		break;
	}
	return	-1;
}

static int do_movi(cmd_tbl_t *cmdtp, int flag, int argc, char *const argv[])
{
	unsigned int dev_no, ret = -1, addr, offset = 0;
	struct partition_info pinfo;

	switch(argc)	{
	case	3:
		if ('i' == argv[1][0]) {
			dev_no  = simple_strtoul(argv[2], NULL, 10);
			if (dev_no)
				ret = run_command("mmc dev 1", 0);
			if (!ret)
				run_command("mmc info", 0);
			if (dev_no && !ret)
				run_command("mmc dev 0", 0);

			return	ret ? CMD_RET_FAILURE:CMD_RET_SUCCESS;
		}
		break;
	case	5:
		dev_no  = simple_strtoul(argv[3], NULL, 10);
		addr	= simple_strtoul(argv[4], NULL, 16);
		ret	= get_partition_info(argv[2], &pinfo);
		break;
	case	6:
		dev_no  = simple_strtoul(argv[4], NULL, 10);
		addr	= simple_strtoul(argv[5], NULL, 16);
		ret	= get_partition_info(argv[3], &pinfo);
		if ((argv[2][0] == 'z') && pinfo.raw_en)
			offset = 1;
		break;
	default	:
		break;
	}
	if (!ret) {
		struct mmc *mmc;
		uint blk_start, blk_count;

		blk_start = pinfo.blk_start - offset;
		blk_count = pinfo.size / MMC_MAX_BLOCK_LEN;

		mmc = find_mmc_device(dev_no);

		printf("mmc block %s, dev %d, addr 0x%x, blk start %d, blk cnt %d\n",
			(argv[1][0] == 'w') ? "write" : "read",
			dev_no, (unsigned int)addr, blk_start, blk_count);

		if (argv[1][0] == 'w')
			mmc->block_dev.block_write(&mmc->block_dev,
				(pinfo.blk_start - offset),
				(pinfo.size / MOVI_BLK_SIZE),
				(int *)addr);
		else
			mmc->block_dev.block_read(&mmc->block_dev,
				(pinfo.blk_start - offset),
				(pinfo.size / MOVI_BLK_SIZE),
				(void *)addr);
		return	CMD_RET_SUCCESS;
	}
	return CMD_RET_USAGE;
}

U_BOOT_CMD(
	movi, 7, 0, do_movi,
	"movi emmc/sd r/w command",
	"{read|write} [zero] {fwbl1|bl2|u-boot|tzsw|kernel} {dev no} {addr}\n"
	"[zero] - flag for emmc raw partition"
);

#endif
