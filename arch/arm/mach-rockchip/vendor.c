/*
 * (C) Copyright 2008-2017 Fuzhou Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <common.h>
#include <malloc.h>
#include <asm/arch/vendor.h>
#include <boot_rkimg.h>

/* tag for vendor check */
#define VENDOR_TAG		0x524B5644
/* The Vendor partition contains the number of Vendor blocks */
#define VENDOR_PART_NUM		4
/* align to 64 bytes */
#define VENDOR_BTYE_ALIGN	0x3F
#define VENDOR_BLOCK_SIZE	512

/* --- Emmc define --- */
/* Starting address of the Vendor in memory. */
#define EMMC_VENDOR_PART_OFFSET		(1024 * 7)
/*
 * The number of memory blocks used by each
 * Vendor structure(128 * 512B = 64KB)
 */
#define EMMC_VENDOR_PART_BLKS		128
/* The maximum number of items in each Vendor block */
#define EMMC_VENDOR_ITEM_NUM		126

/* --- Spi/Spi Nand/SLC/MLC define --- */
/* The Vendor partition contains the number of Vendor blocks */
#define	FLASH_VENDOR_PART_OFFSET	8
/*
 * The number of memory blocks used by each
 * Vendor structure(8 * 512B = 4KB)
 */
#define FLASH_VENDOR_PART_BLKS		8
/* The maximum number of items in each Vendor block */
#define FLASH_VENDOR_ITEM_NUM		62

/* Vendor uinit test define */
/* #define VENDOR_STORAGE_TEST */
#ifdef VENDOR_STORAGE_TEST
int vendor_storage_test(void);
#endif /* VENDOR_STORAGE_TEST */

struct vendor_item {
	u16  id;
	u16  offset;
	u16  size;
	u16  flag;
};

struct vendor_hdr {
	u32	tag;
	u32	version;
	u16	next_index;
	u16	item_num;
	u16	free_offset; /* Free space offset */
	u16	free_size; /* Free space size */
};

/*
 * Different types of Flash vendor info are different.
 * EMMC:EMMC_VENDOR_PART_BLKS * BLOCK_SIZE(512) = 64KB;
 * Spi Nor/Spi Nand/SLC/MLC: FLASH_VENDOR_PART_BLKS *
 * BLOCK_SIZE(512) = 4KB.
 * hash: For future expansion.
 * version2: Together with hdr->version, it is used to
 * ensure the current Vendor block content integrity.
 *   (version2 == hdr->version):Data valid;
 *   (version2 != hdr->version):Data invalid.
 */
struct vendor_info {
	struct vendor_hdr *hdr;
	struct vendor_item *item;
	u8 *data;
	u32 *hash;
	u32 *version2;
};
/*
 * Calculate the offset of each field for emmc.
 * Emmc vendor info size: 64KB
 */
#define EMMC_VENDOR_INFO_SIZE	(EMMC_VENDOR_PART_BLKS * VENDOR_BLOCK_SIZE)
#define EMMC_VENDOR_DATA_OFFSET	(sizeof(struct vendor_hdr) + EMMC_VENDOR_ITEM_NUM * sizeof(struct vendor_item))
#define EMMC_VENDOR_HASH_OFFSET (EMMC_VENDOR_INFO_SIZE - 8)
#define EMMC_VENDOR_VERSION2_OFFSET (EMMC_VENDOR_INFO_SIZE - 4)
/*
 * Calculate the offset of each field for spi nor/spi nand/slc/mlc.
 * Flash vendor info size: 4KB
 */
#define FLASH_VENDOR_INFO_SIZE	(FLASH_VENDOR_PART_BLKS * VENDOR_BLOCK_SIZE)
#define FLASH_VENDOR_DATA_OFFSET	(sizeof(struct vendor_hdr) + FLASH_VENDOR_ITEM_NUM * sizeof(struct vendor_item))
#define FLASH_VENDOR_HASH_OFFSET (FLASH_VENDOR_INFO_SIZE - 8)
#define FLASH_VENDOR_VERSION2_OFFSET (FLASH_VENDOR_INFO_SIZE - 4)

/* vendor info */
static struct vendor_info vendor_info;
/* The storage type of the device */
static int bootdev_type;

/**********************************************************/
/*              vendor API implementation                 */
/**********************************************************/
static int vendor_ops(u8 *buffer, u32 addr, u32 n_sec, int write)
{
	struct blk_desc *dev_desc;
	unsigned int lba = 0;
	int ret = 0;

	dev_desc = rockchip_get_bootdev();
	/* Get the offset address according to the device type */
	switch (dev_desc->if_type) {
	case IF_TYPE_MMC:
		/*
		 * The location of VendorStorage in Flash is shown in the
		 * following figure. The starting address of the VendorStorage
		 * partition is 3.5MB(EMMC_VENDOR_PART_OFFSET*BLOCK_SIZE(512)),
		 * and the partition size is 256KB.
		 * ----------------------------------------------------
		 * |   3.5MB    |  VendorStorage  |                   |
		 * ----------------------------------------------------
		 */
		lba = EMMC_VENDOR_PART_OFFSET;
		debug("[Vednor INFO]:VendorStorage offset address=0x%x\n", lba);
		break;
	case IF_TYPE_RKNAND:
	case IF_TYPE_SPINOR:
	case IF_TYPE_SPINAND:
		/*
		 * The location of VendorStorage in Flash is shown in the
		 * following figure. The starting address of the VendorStorage
		 * partition is 4KB (FLASH_VENDOR_PART_OFFSET * BLOCK_SIZE),
		 * and the partition size is 16KB.
		 * ----------------------------------------------------
		 * |   4KB    |  VendorStorage  |                     |
		 * ----------------------------------------------------
		 */
		lba = FLASH_VENDOR_PART_OFFSET;
		debug("[Vednor INFO]:VendorStorage offset address=0x%x\n", lba);
		break;
	default:
		debug("[Vednor ERROR]:Boot device type is invalid!\n");
		ret = -ENODEV;
		break;
	}
	if (!ret) {
		if (write)
			ret = blk_dwrite(dev_desc, lba + addr, n_sec, buffer);
		else
			ret = blk_dread(dev_desc, lba + addr, n_sec, buffer);
	}
	debug("[Vednor INFO]:op=%s, ret=%d\n", write ? "write" : "read", ret);

	return ret;
}

/*
 * The VendorStorage partition is divided into four parts
 * (vendor 0-3) and its structure is shown in the following figure.
 * The init function is used to select the latest and valid vendor.
 *
 * |******************** FLASH ********************|
 * -------------------------------------------------
 * |  vendor0  |  vendor1  |  vendor2  |  vendor3  |
 * -------------------------------------------------
 * Notices:
 *   1. "version" and "version2" are used to verify that the vendor
 *      is valid (equal is valid).
 *   2. the "version" value is larger, indicating that the current
 *      verndor data is new.
 */
int vendor_storage_init(void)
{
	int ret = 0;
	u8 *buffer;
	u32 size, i;
	u32 max_ver = 0;
	u32 max_index = 0;
	u16 data_offset, hash_offset;
	u16 version2_offset, part_size;
	struct blk_desc *dev_desc;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("[Vednor ERROR]:Invalid boot device type(%d)\n",
		       bootdev_type);
		return -ENODEV;
	}

	switch (dev_desc->if_type) {
	case IF_TYPE_MMC:
		size = EMMC_VENDOR_INFO_SIZE;
		part_size = EMMC_VENDOR_PART_BLKS;
		data_offset = EMMC_VENDOR_DATA_OFFSET;
		hash_offset = EMMC_VENDOR_HASH_OFFSET;
		version2_offset = EMMC_VENDOR_VERSION2_OFFSET;
		break;
	case IF_TYPE_RKNAND:
	case IF_TYPE_SPINOR:
	case IF_TYPE_SPINAND:
		size = FLASH_VENDOR_INFO_SIZE;
		part_size = FLASH_VENDOR_PART_BLKS;
		data_offset = FLASH_VENDOR_DATA_OFFSET;
		hash_offset = FLASH_VENDOR_HASH_OFFSET;
		version2_offset = FLASH_VENDOR_VERSION2_OFFSET;
		break;
	default:
		debug("[Vednor ERROR]:Boot device type is invalid!\n");
		ret = -ENODEV;
		break;
	}
	/* Invalid bootdev type */
	if (ret)
		return ret;
	/* Always use, no need to release */
	buffer = (u8 *)malloc(size);
	if (!buffer) {
		printf("[Vednor ERROR]:Malloc failed!\n");
		return -ENOMEM;
	}
	/* Pointer initialization */
	vendor_info.hdr = (struct vendor_hdr *)buffer;
	vendor_info.item = (struct vendor_item *)(buffer + sizeof(struct vendor_hdr));
	vendor_info.data = buffer + data_offset;
	vendor_info.hash = (u32 *)(buffer + hash_offset);
	vendor_info.version2 = (u32 *)(buffer + version2_offset);

	/* Find valid and up-to-date one from (vendor0 - vendor3) */
	for (i = 0; i < VENDOR_PART_NUM; i++) {
		ret = vendor_ops((u8 *)vendor_info.hdr, part_size * i, part_size, 0);
		if (ret)
			return ret;

		if ((vendor_info.hdr->tag == VENDOR_TAG) &&
		    (*(vendor_info.version2) == vendor_info.hdr->version)) {
			if (max_ver < vendor_info.hdr->version) {
				max_index = i;
				max_ver = vendor_info.hdr->version;
			}
		}
	}
	if (max_ver) {
		debug("[Vednor INFO]:max_ver=%d, vendor_id=%d.\n", max_ver, max_index);
		/*
		 * Keep vendor_info the same as the largest
		 * version of vendor
		 */
		if (max_index != (VENDOR_PART_NUM - 1))
			ret = vendor_ops((u8 *)vendor_info.hdr, part_size * max_index, part_size, 0);
	} else {
		debug("[Vednor INFO]:Reset vendor info...\n");
		memset((u8 *)vendor_info.hdr, 0, size);
		vendor_info.hdr->version = 1;
		vendor_info.hdr->tag = VENDOR_TAG;
		/* data field length */
		vendor_info.hdr->free_size =
			((u32)(size_t)vendor_info.hash
			- (u32)(size_t)vendor_info.data);
		*(vendor_info.version2) = vendor_info.hdr->version;
	}
	debug("[Vednor INFO]:ret=%d.\n", ret);

#ifdef VENDOR_STORAGE_TEST
	if (vendor_storage_test())
		printf("[Vendor ERROR]:Vendor test result:failure\n");
#endif

	return ret;
}

int vendor_storage_read(u16 id, void *pbuf, u16 size)
{
	int ret = 0;
	u32 i;
	u16 offset;
	struct vendor_item *item;

	/* init vendor storage */
	if (!bootdev_type) {
		ret = vendor_storage_init();
		if (ret)
			return ret;
	}

	item = vendor_info.item;
	for (i = 0; i < vendor_info.hdr->item_num; i++) {
		if ((item + i)->id == id) {
			debug("[Vednor INFO]:Find the matching item, id=%d\n", id);
			/* Correct the size value */
			if (size > (item + i)->size)
				size = (item + i)->size;
			offset = (item + i)->offset;
			memcpy(pbuf, (vendor_info.data + offset), size);
			return size;
		}
	}
	debug("[Vednor ERROR]:No matching item, id=%d\n", id);

	return -EINVAL;
}

int vendor_storage_write(u16 id, void *pbuf, u16 size)
{
	int ret = 0;
	u32 i, next_index, align_size;
	struct vendor_item *item;
	u16 part_size, max_item_num, offset;

	/* init vendor storage */
	if (!bootdev_type) {
		ret = vendor_storage_init();
		if (ret)
			return ret;
	}

	switch (bootdev_type) {
	case IF_TYPE_MMC:
		part_size = EMMC_VENDOR_PART_BLKS;
		max_item_num = EMMC_VENDOR_ITEM_NUM;
		break;
	case IF_TYPE_RKNAND:
	case IF_TYPE_SPINOR:
	case IF_TYPE_SPINAND:
		part_size = FLASH_VENDOR_PART_BLKS;
		max_item_num = FLASH_VENDOR_ITEM_NUM;
		break;
	default:
		ret = -ENODEV;
		break;
	}
	/* Invalid bootdev? */
	if (ret)
		return ret;

	next_index = vendor_info.hdr->next_index;
	/* algin to 64 bytes*/
	align_size = (size + VENDOR_BTYE_ALIGN) & (~VENDOR_BTYE_ALIGN);
	if (size > align_size)
		return -EINVAL;

	item = vendor_info.item;
	/* If item already exist, update the item data */
	for (i = 0; i < vendor_info.hdr->item_num; i++) {
		if ((item + i)->id == id) {
			debug("[Vednor INFO]:Find the matching item, id=%d\n", id);
			offset = (item + i)->offset;
			memcpy((vendor_info.data + offset), pbuf, size);
			(item + i)->size = size;
			vendor_info.hdr->version++;
			*(vendor_info.version2) = vendor_info.hdr->version;
			vendor_info.hdr->next_index++;
			if (vendor_info.hdr->next_index >= VENDOR_PART_NUM)
				vendor_info.hdr->next_index = 0;
			return vendor_ops((u8 *)vendor_info.hdr, part_size * next_index, part_size, 1);
		}
	}
	/*
	 * If item does not exist, and free size is enough,
	 * creat a new one
	 */
	if ((vendor_info.hdr->item_num < max_item_num) &&
	    (vendor_info.hdr->free_size >= align_size)) {
		debug("[Vednor INFO]:Create new Item, id=%d\n", id);
		item = vendor_info.item + vendor_info.hdr->item_num;
		item->id = id;
		item->offset = vendor_info.hdr->free_offset;
		item->size = size;

		vendor_info.hdr->free_offset += align_size;
		vendor_info.hdr->free_size -= align_size;
		memcpy((vendor_info.data + item->offset), pbuf, size);
		vendor_info.hdr->item_num++;
		vendor_info.hdr->version++;
		vendor_info.hdr->next_index++;
		*(vendor_info.version2) = vendor_info.hdr->version;
		if (vendor_info.hdr->next_index >= VENDOR_PART_NUM)
			vendor_info.hdr->next_index = 0;

		return vendor_ops((u8 *)vendor_info.hdr, part_size * next_index, part_size, 1);
	}
	debug("[Vednor ERROR]:Vendor has no space left!\n");

	return -ENOMEM;
}

/**********************************************************/
/*              vendor API uinit test                      */
/**********************************************************/
#ifdef VENDOR_STORAGE_TEST
/* Reset the vendor storage space to the initial state */
void vendor_test_reset(void)
{
	u16 i, part_size;
	u32 size;

	switch (bootdev_type) {
	case IF_TYPE_MMC:
		size = EMMC_VENDOR_INFO_SIZE;
		part_size = EMMC_VENDOR_PART_BLKS;
		break;
	case IF_TYPE_RKNAND:
	case IF_TYPE_SPINOR:
	case IF_TYPE_SPINAND:
		size = FLASH_VENDOR_INFO_SIZE;
		part_size = FLASH_VENDOR_PART_BLKS;
		break;
	default:
		size = 0;
		part_size = 0;
		break;
	}
	/* Invalid bootdev? */
	if (!size)
		return;

	memset((u8 *)vendor_info.hdr, 0, size);
	vendor_info.hdr->version = 1;
	vendor_info.hdr->tag = VENDOR_TAG;
	/* data field length */
	vendor_info.hdr->free_size =
		((u32)vendor_info.hash - (u32)vendor_info.data);
	*(vendor_info.version2) = vendor_info.hdr->version;
	/* write to flash. */
	for (i = 0; i < VENDOR_PART_NUM; i++)
		vendor_ops((u8 *)vendor_info.hdr, part_size * i, part_size, 1);
}

/*
 * A total of four tests
 * 1.All items test.
 * 2.Overrides the maximum number of items test.
 * 3.Single Item memory overflow test.
 * 4.Total memory overflow test.
 */
int vendor_storage_test(void)
{
	u16 id, size, j, item_num;
	u32 total_size;
	u8 *buffer = NULL;
	int ret = 0;

	/*
	 * Calculate the maximum number of items and the maximum
	 * allocable memory for each item.
	 */
	switch (bootdev_type) {
	case IF_TYPE_MMC:
		item_num = EMMC_VENDOR_ITEM_NUM;
		total_size = (u32)vendor_info.hash - (u32)vendor_info.data;
		size = total_size/item_num;
		break;
	case IF_TYPE_RKNAND:
	case IF_TYPE_SPINOR:
	case IF_TYPE_SPINAND:
		item_num = FLASH_VENDOR_ITEM_NUM;
		total_size = (u32)vendor_info.hash - (u32)vendor_info.data;
		size = total_size/item_num;
		break;
	default:
		total_size = 0;
		break;
	}
	/* Invalid bootdev? */
	if (!total_size)
		return -ENODEV;
	/* 64 bytes are aligned and rounded down */
	size = (size/64)*64;
	/* malloc memory */
	buffer = (u8 *)malloc(size);
	if (!buffer) {
		printf("[Vendor Test]:Malloc failed(size=%d)!\n", size);
		return -ENOMEM;
	}
	printf("[Vendor Test]:Test Start...\n");
	printf("[Vendor Test]:Before Test, Vendor Resetting.\n");
	vendor_test_reset();

	/* FIRST TEST: test all items can be used correctly */
	printf("[Vendor Test]:<All Items Used> Test Start...\n");
	printf("[Vendor Test]:item_num=%d, size=%d.\n",
	       item_num, size);
	/*
	 * Write data, then read the data, and compare the
	 * data consistency
	 */
	for (id = 0; id < item_num; id++) {
		memset(buffer, id, size);
		ret = vendor_storage_write(id, buffer, size);
		if (ret) {
			printf("[Vendor Test]:vendor write failed(id=%d)!\n", id);
			free(buffer);
			return ret;
		}
	}
	/* Read data */
	for (id = 0; id < item_num; id++) {
		memset(buffer, 0, size);
		ret = vendor_storage_read(id, buffer, size);
		if (ret != size) {
			printf("[Vendor Test]:vendor read failed(id=%d)!\n", id);
			free(buffer);
			return ret;
		}
		/* check data Correctness */
		for (j = 0; j < size; j++) {
			if (*(buffer + j) != id) {
				printf("[Vendor Test]:Unexpected error occurs(id=%d)\n", id);
				printf("the data content is:\n");
				print_buffer(0, buffer, 1, size, 16);

				free(buffer);
				return -1;
			}
		}
		debug("\t#id=%03d success,data=0x%02x,size=%d.\n", id, *buffer, size);
	}
	printf("[Vendor Test]:<All Items Used> Test End,States:OK\n");

	/*
	 * SECOND TEST: Overrides the maximum number of items to see if the
	 * return value matches the expectation
	 */
	printf("[Vendor Test]:<Overflow Items Cnt> Test Start...\n");
	/* Any id value that was not used before */
	id = item_num;
	printf("[Vendor Test]:id=%d, size=%d.\n", id, size);
	ret = vendor_storage_write(id, buffer, size);
	if (ret == -ENOMEM)
		printf("[Vendor Test]:<Overflow Items Cnt> Test End,States:OK\n");
	else
		printf("[Vendor Test]:<Overflow Items Cnt> Test End,States:Failed\n");

	/* free buffer, remalloc later */
	free(buffer);
	buffer = NULL;
	/*
	 * remalloc memory and recalculate size to test memory overflow
	 * (1) item_num > 10: Memory is divided into 10 blocks,
	 * 11th memory will overflow.
	 * (2) 10 > item_num > 1: Memory is divided into item_num-1
	 * blocks. item_num block, memory will overflow.
	 * (3) item_num = 1: size = total_size + 512 Bytes, The first
	 * block, memory will overflow.
	 * The reason to do so is to minimize the size of the memory,
	 * making malloc easier to perform successfully.
	 */
	item_num = (item_num > 10) ? 10 : (item_num - 1);
	size = item_num ? (total_size / item_num) : (total_size + 512);
	size = (size + VENDOR_BTYE_ALIGN) & (~VENDOR_BTYE_ALIGN);
	/* Find item_num value that can make the memory overflow */
	for (id = 0; id <= item_num; id++) {
		if (((id + 1) * size) > total_size) {
			item_num = id;
			break;
		}
	}
	/* malloc */
	buffer = (u8 *)malloc(size);
	if (buffer == NULL) {
		printf("[Vendor Test]:Malloc failed(size=%d)!\n", size);
		return -ENOMEM;
	}

	/* THIRD TEST: Single Item memory overflow test */
	printf("[Vendor Test]:<Single Item Memory Overflow> Test Start...\n");
	/* The value can be arbitrary */
	memset(buffer, 'a', size);
	/* Any id value that was used before */
	id = 0;
	printf("[Vendor Test]:id=%d, size=%d.\n", id, size);
	ret = vendor_storage_write(id, buffer, size);
	if (!ret)
		printf("[Vendor Test]:<Single Item Memory Overflow> Test End, States:OK\n");
	else
		printf("[Vendor Test]:<Single Item Memory Overflow> Test End, States:Failed\n");

	/* FORTH TEST: Total memory overflow test */
	printf("[Vendor Test]:<Total memory overflow> Test Start...\n");
	printf("[Vendor Test]:item_num=%d, size=%d.\n", item_num, size);

	vendor_test_reset();
	for (id = 0; id <= item_num; id++) {
		memset(buffer, id, size);
		ret = vendor_storage_write(id, buffer, size);
		if (ret) {
			if ((id == item_num) && (ret == -ENOMEM)) {
				printf("[Vendor Test]:<Total memory overflow> Test End, States:OK\n");
				break;
			} else {
				printf("[Vendor Test]:<Total memory overflow> Test End, States:Failed\n");
				break;
			}
		}
		debug("\t#id=%03d success,data=0x%02x,size=%d.\n", id, *buffer, size);
	}

	/* Test end */
	printf("[Vendor Test]:After Test, Vendor Resetting...\n");
	vendor_test_reset();
	printf("[Vendor Test]:Test End.\n");
	free(buffer);

	return 0;
}
#endif /* VENDOR_STORAGE_TEST */
