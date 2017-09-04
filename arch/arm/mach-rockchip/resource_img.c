/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */
#include <common.h>
#include <malloc.h>
#include <linux/list.h>
#include <asm/arch/resource_img.h>
#include "rockchip_parameter.h"
#include "rockchip_blk.h"

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
};

static struct blk_part *rsce_blk;

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

static int add_file_to_list(struct resource_entry *entry)
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
	file->f_offset = entry->f_offset;
	file->f_size = entry->f_size;
	list_add_tail(&file->link, &entrys_head);
	debug("entry:%p  %s offset:%d size:%d\n",
	      entry, file->name, file->f_offset, file->f_size);

	return 0;
}

static int read_file_info_from_blk_dev(void)
{
	struct resource_img_hdr *hdr;
	struct resource_entry *entry;
	void *content;
	int size;
	int ret;
	int e_num;

	rsce_blk = rockchip_get_blk_part(PART_RESOURCE);
	if (!rsce_blk) {
		printf("no resource partition found\n");
		return  -ENODEV;
	}

	hdr = memalign(ARCH_DMA_MINALIGN, RK_BLK_SIZE);
	if (!hdr) {
		printf("out of memory!\n");
		return -ENOMEM;
	}

	ret = blkdev_read(hdr, rsce_blk->from, 1);
	if (ret < 0)
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
	ret = blkdev_read(content, rsce_blk->from + hdr->c_offset,
			  hdr->e_blks * hdr->e_nums);
	if (ret < 0)
		goto err;

	for (e_num = 0; e_num < hdr->e_nums; e_num++) {
		size = e_num * hdr->e_blks * RK_BLK_SIZE;
		entry = (struct resource_entry *)(content + size);
		add_file_to_list(entry);
	}

err:
	free(content);
out:
	free(hdr);

	return 0;
}

static struct resource_file *get_file_info(struct resource_img_hdr *hdr,
					   const void *content,
					   const char *name)
{
	struct resource_file *file;
	struct list_head *node;

	if (list_empty(&entrys_head))
		read_file_info_from_blk_dev();

	list_for_each(node, &entrys_head) {
		file = list_entry(node, struct resource_file, link);
		if (!strcmp(file->name, name))
			return file;
	}

	return NULL;
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

	file = get_file_info(NULL, NULL, name);
	if (!file) {
		printf("Can't find file:%s\n", name);
		return -ENOENT;
	}

	if (len <= 0 || len > file->f_size)
		len = file->f_size;
	blks = DIV_ROUND_UP(len, RK_BLK_SIZE);
	ret = blkdev_read(buf, rsce_blk->from + file->f_offset + offset, blks);
	if (!ret)
		ret = len;

	return ret;
}
