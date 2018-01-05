/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <malloc.h>
#include <linux/list.h>
#include <asm/arch/resource_img.h>
#include <boot_rkimg.h>
#ifdef CONFIG_ANDROID_BOOT_IMAGE
#include <android_bootloader.h>
#include <android_image.h>
#endif

#define PART_RESOURCE			"resource"
#define RESOURCE_MAGIC			"RSCE"
#define RESOURCE_MAGIC_SIZE		4
#define RESOURCE_VERSION		0
#define CONTENT_VERSION			0
#define ENTRY_TAG			"ENTR"
#define ENTRY_TAG_SIZE			4
#define MAX_FILE_NAME_LEN		256

/*
 *         resource image structure
 * ----------------------------------------------
 * |                                            |
 * |    header  (1 block)                       |
 * |                                            |
 * ---------------------------------------------|
 * |                      |                     |
 * |    entry0  (1 block) |                     |
 * |                      |                     |
 * ------------------------                     |
 * |                      |                     |
 * |    entry1  (1 block) | contents (n blocks) |
 * |                      |                     |
 * ------------------------                     |
 * |    ......            |                     |
 * ------------------------                     |
 * |                      |                     |
 * |    entryn  (1 block) |                     |
 * |                      |                     |
 * ----------------------------------------------
 * |                                            |
 * |    file0  (x blocks)                       |
 * |                                            |
 * ----------------------------------------------
 * |                                            |
 * |    file1  (y blocks)                       |
 * |                                            |
 * ----------------------------------------------
 * |                   ......                   |
 * |---------------------------------------------
 * |                                            |
 * |    filen  (z blocks)                       |
 * |                                            |
 * ----------------------------------------------
 */

/**
 * struct resource_image_header
 *
 * @magic: should be "RSCE"
 * @version: resource image version, current is 0
 * @c_version: content version, current is 0
 * @blks: the size of the header ( 1 block = 512 bytes)
 * @c_offset: contents offset(by block) in the image
 * @e_blks: the size(by block) of the entry in the contents
 * @e_num: numbers of the entrys.
 */

struct resource_img_hdr {
	char		magic[4];
	uint16_t	version;
	uint16_t	c_version;
	uint8_t		blks;
	uint8_t		c_offset;
	uint8_t		e_blks;
	uint32_t	e_nums;
};

struct resource_entry {
	char		tag[4];
	char		name[MAX_FILE_NAME_LEN];
	uint32_t	f_offset;
	uint32_t	f_size;
};

struct resource_file {
	char		name[MAX_FILE_NAME_LEN];
	uint32_t	f_offset;
	uint32_t	f_size;
	struct list_head link;
	uint32_t 	rsce_base;	/* Base addr of resource */
};

static LIST_HEAD(entrys_head);

static int resource_image_check_header(const struct resource_img_hdr *hdr)
{
	int ret;

	ret = memcmp(RESOURCE_MAGIC, hdr->magic, RESOURCE_MAGIC_SIZE);
	if (ret) {
		printf("bad resource image magic\n");
		ret = -EINVAL;
	}
	debug("resource image header:\n");
	debug("magic:%s\n", hdr->magic);
	debug("version:%d\n", hdr->version);
	debug("c_version:%d\n", hdr->c_version);
	debug("blks:%d\n", hdr->blks);
	debug("c_offset:%d\n", hdr->c_offset);
	debug("e_blks:%d\n", hdr->e_blks);
	debug("e_num:%d\n", hdr->e_nums);

	return ret;
}

static int add_file_to_list(struct resource_entry *entry, int rsce_base)
{
	struct resource_file *file;

	if (memcmp(entry->tag, ENTRY_TAG, ENTRY_TAG_SIZE)) {
		printf("invalid entry tag\n");
		return -ENOENT;
	}
	file = malloc(sizeof(*file));
	if (!file) {
		printf("out of memory\n");
		return -ENOMEM;
	}
	strcpy(file->name, entry->name);
	file->rsce_base = rsce_base;
	file->f_offset = entry->f_offset;
	file->f_size = entry->f_size;
	list_add_tail(&file->link, &entrys_head);
	debug("entry:%p  %s offset:%d size:%d\n",
	      entry, file->name, file->f_offset, file->f_size);

	return 0;
}

static int init_resource_list(struct resource_img_hdr *hdr)
{
	struct resource_entry *entry;
	void *content;
	int size;
	int ret;
	int e_num;
	int offset = 0;
	int mode = 0;
	struct blk_desc *dev_desc;
	struct andr_img_hdr *andr_hdr;
	disk_partition_t part_info;
	char *boot_partname = PART_BOOT;

	if (hdr) {
		content = (void *)((char *)hdr
				   + (hdr->c_offset) * RK_BLK_SIZE);
		for (e_num = 0; e_num < hdr->e_nums; e_num++) {
			size = e_num * hdr->e_blks * RK_BLK_SIZE;
			entry = (struct resource_entry *)(content + size);
			add_file_to_list(entry, offset);
		}
		return 0;
	}

	dev_desc = rockchip_get_bootdev();
	hdr = memalign(ARCH_DMA_MINALIGN, RK_BLK_SIZE);
	if (!hdr) {
		printf("%s out of memory!\n", __func__);
		return -ENOMEM;
	}

#ifdef CONFIG_ANDROID_BOOT_IMAGE
	/* Get boot mode from misc */
	mode = rockchip_get_boot_mode();
	if (mode == BOOT_MODE_RECOVERY)
		boot_partname = PART_RECOVERY;
	/* Read boot/recovery and chenc if this is an AOSP img */
	ret = part_get_info_by_name(dev_desc, boot_partname,
					 &part_info);
	if (ret < 0) {
		printf("fail to get %s part\n", boot_partname);
		goto out;
	}
	andr_hdr = (void *)hdr;
	ret = blk_dread(dev_desc, part_info.start, 1, andr_hdr);
	if (ret != 1) {
		printf("%s read fail\n", __func__);
		goto out;
	}
	ret = android_image_check_header(andr_hdr);
	if (!ret) {
		debug("%s Load resource from %s senond pos\n",
		      __func__, part_info.name);
		/* Read resource from second offset */
		offset = part_info.start * RK_BLK_SIZE;
		offset += andr_hdr->page_size;
		offset += ALIGN(andr_hdr->kernel_size, andr_hdr->page_size);
		offset += ALIGN(andr_hdr->ramdisk_size, andr_hdr->page_size);
		offset = offset / RK_BLK_SIZE;
	} else {
		/* Set mode to 0 in for recovery is not valid AOSP img */
		mode = 0;
	}
#endif
	if (!mode) {
		/* Read resource from Rockchip Resource partition */
		ret = part_get_info_by_name(dev_desc, PART_RESOURCE,
					 &part_info);
		if (ret < 0) {
			printf("fail to get %s part\n", PART_RESOURCE);
			goto out;
		}
		offset = part_info.start;
		debug("%s Load resource from %s\n", __func__, part_info.name);
	}

	hdr = (void *)andr_hdr;
	ret = blk_dread(dev_desc, offset, 1, hdr);
	if (ret != 1)
		goto out;
	ret = resource_image_check_header(hdr);
	if (ret < 0)
		goto out;
	content = memalign(ARCH_DMA_MINALIGN,
			   hdr->e_blks * hdr->e_nums * RK_BLK_SIZE);
	if (!content) {
		printf("alloc memory for content failed\n");
		goto out;
	}
	ret = blk_dread(dev_desc, offset + hdr->c_offset,
			hdr->e_blks * hdr->e_nums, content);
	if (ret != (hdr->e_blks * hdr->e_nums))
		goto err;

	for (e_num = 0; e_num < hdr->e_nums; e_num++) {
		size = e_num * hdr->e_blks * RK_BLK_SIZE;
		entry = (struct resource_entry *)(content + size);
		add_file_to_list(entry, offset);
	}

err:
	free(content);
out:
	free(hdr);

	return 0;
}

static struct resource_file *get_file_info(struct resource_img_hdr *hdr,
					   const char *name)
{
	struct resource_file *file;
	struct list_head *node;

	if (list_empty(&entrys_head))
		init_resource_list(hdr);

	list_for_each(node, &entrys_head) {
		file = list_entry(node, struct resource_file, link);
		if (!strcmp(file->name, name))
			return file;
	}

	return NULL;
}

int rockchip_get_resource_file(void *buf, const char *name)
{
	struct resource_file *file;

	file = get_file_info(buf, name);

	return file->f_offset;
}

/*
 * read file from resource partition
 * @buf: destination buf to store file data;
 * @name: file name
 * @offset: blocks offset in the file, 1 block = 512 bytes
 * @len: the size(by bytes) of file to read.
 */
int rockchip_read_resource_file(void *buf, const char *name,
				int offset, int len)
{
	struct resource_file *file;
	int ret = 0;
	int blks;
	struct blk_desc *dev_desc;

	file = get_file_info(NULL, name);
	if (!file) {
		printf("Can't find file:%s\n", name);
		return -ENOENT;
	}

	if (len <= 0 || len > file->f_size)
		len = file->f_size;
	blks = DIV_ROUND_UP(len, RK_BLK_SIZE);
	dev_desc = rockchip_get_bootdev();
	ret = blk_dread(dev_desc, file->rsce_base + file->f_offset + offset,
			blks, buf);
	if (ret != blks)
		ret = -EIO;
	else
		ret = len;

	return ret;
}
