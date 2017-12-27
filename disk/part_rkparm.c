/*
 * (C) Copyright 2017 rkparm Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#include <common.h>
#include <malloc.h>

#ifdef HAVE_BLOCK_DEVICE
#define RK_PARAM_OFFSET			0x2000
#define MAX_PARAM_SIZE			(1024 * 64)

struct rkparm_param {
	u32 tag;
	u32 length;
	char params[1];
	u32 crc;
};

struct rkparm_part {
	char name[PART_NAME_LEN];
	unsigned long start;
	unsigned long size;
	struct list_head node;
};


static LIST_HEAD(parts_head);

static int rkparm_param_parse(char *param, struct list_head *parts_head)
{
	struct rkparm_part *part;
	const char *cmdline = strstr(param, "CMDLINE:");
	char *cmdline_end = strstr(cmdline, "\n"); /* end by '\n' */
	const char *blkdev_parts = strstr(cmdline, "mtdparts");
	const char *blkdev_def = strchr(blkdev_parts, ':') + 1;
	char *next = (char *)blkdev_def;
	char *pend;
	int len;
	unsigned long size, start;

	if (!cmdline) {
		printf("invalid parameter\n");
		return -EINVAL;
	}

	*cmdline_end = '\0';
	/* skip "CMDLINE:" */
	env_update("bootargs", cmdline + strlen("CMDLINE:"));

	while (*next) {
		if (*next == '-') {
			size = (~0UL);
			next++;
		} else {
			size = simple_strtoul(next, &next, 16);
		}
		next++;
		start = simple_strtoul(next, &next, 16);
		next++;
		pend =  strchr(next, ')');
		if (!pend)
			break;
		len = min_t(int, pend - next, PART_NAME_LEN);
		part = malloc(sizeof(*part));
		if (!part) {
			printf("out of memory\n");
			break;
		}
		part->start = start;
		part->size = size;
		strncpy(part->name, next, len);
		part->name[len] = '\0';
		next = strchr(next, ',');
		next++;
		list_add_tail(&part->node, parts_head);
	}

	return 0;
}

static int rkparm_init_param(struct blk_desc *dev_desc,
				struct list_head *parts_head)
{
	struct rkparm_param *param;
	int ret;

	param = memalign(ARCH_DMA_MINALIGN, MAX_PARAM_SIZE);
	if (!param) {
		printf("out of memory\n");
		return -ENOMEM;
	}

	ret = blk_dread(dev_desc, RK_PARAM_OFFSET, MAX_PARAM_SIZE >> 9,
			(ulong *)param);
	if (ret != (MAX_PARAM_SIZE >> 9)) {
		printf("%s param read fail\n", __func__);
		return -EINVAL;
	}

	return rkparm_param_parse(param->params, parts_head);

}

static void part_print_rkparm(struct blk_desc *dev_desc)
{
	int ret = 0;
	struct list_head *node;
	struct rkparm_part *p = NULL;
	int i = 0;

	if (list_empty(&parts_head))
		ret = rkparm_init_param(dev_desc, &parts_head);

	if (ret) {
		printf("%s Invalid rkparm parameter\n", __func__);
		return;
	}

	printf("Part\tStart LBA\tSize\t\tName\n");
	list_for_each(node, &parts_head) {
		p = list_entry(node, struct rkparm_part, node);
		printf("%3d\t0x%08lx\t0x%08lx\t%s\n", (i++ + 1),
		       p->start, p->size, p->name);
	}


	return;
}

static int part_get_info_rkparm(struct blk_desc *dev_desc, int idx,
		      disk_partition_t *info)
{
	struct list_head *node;
	struct rkparm_part *p = NULL;
	int part_num = 1;
	int ret = 0;

	if (idx < 1) {
		printf("%s Invalid partition no.%d\n", __func__, idx);
		return -EINVAL;
	}

	if (list_empty(&parts_head))
		ret = rkparm_init_param(dev_desc, &parts_head);

	if (ret) {
		printf("%s Invalid rkparm partition\n", __func__);
		return -1;
	}

	list_for_each(node, &parts_head) {
		p = list_entry(node, struct rkparm_part, node);
		if (idx == part_num)
			break;
		part_num ++;
	}

	if (part_num > idx) {
		printf("%s Invalid partition no.%d\n", __func__, idx);
		return -EINVAL;
	}

	info->start = p->start;
	info->size = p->size << 9;
	info->blksz = dev_desc->blksz;

	sprintf((char *)info->name, "%s", p->name);
	strcpy((char *)info->type, "U-Boot");
	info->bootable = 0;

	return 0;
}

static int part_test_rkparm(struct blk_desc *dev_desc)
{
	int ret = 0;

	if (list_empty(&parts_head))
		ret = rkparm_init_param(dev_desc, &parts_head);
	if (ret)
		ret = -1;

	return ret;
}
/*
 * Add an 'b_' prefix so it comes before 'dos' and after 'a_efi' in the linker
 * list. We need to check EFI first, and then rkparm partition
 */
U_BOOT_PART_TYPE(b_rkparm) = {
	.name		= "RKPARM",
	.part_type	= PART_TYPE_RKPARM,
	.max_entries	= GPT_ENTRY_NUMBERS,
	.get_info	= part_get_info_ptr(part_get_info_rkparm),
	.print		= part_print_ptr(part_print_rkparm),
	.test		= part_test_rkparm,
};
#endif
