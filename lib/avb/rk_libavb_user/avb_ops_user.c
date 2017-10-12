/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <common.h>
#include <image.h>
#include <android_image.h>
#include <malloc.h>
#include <mapmem.h>
#include <errno.h>
#include <command.h>
#include <mmc.h>
#include <blk.h>
#include <part.h>
#include <android_avb/avb_ops_user.h>
#include <android_avb/libavb_ab.h>
#include <android_avb/avb_atx_validate.h>
#include <optee_include/OpteeClientTest.h>

static void byte_to_block(int64_t *offset,
			  size_t *num_bytes,
			  lbaint_t *offset_blk,
			  lbaint_t *blkcnt)
{
	*offset_blk = (lbaint_t)(*offset / 512);
	if (*num_bytes % 512 == 0) {
		if (*offset % 512 == 0) {
			*blkcnt = (lbaint_t)(*num_bytes / 512);
		} else {
			*blkcnt = (lbaint_t)(*num_bytes / 512) + 1;
		}
	} else {
		if (*offset % 512 == 0) {
			*blkcnt = (lbaint_t)(*num_bytes / 512) + 1;
		} else {
			if ((*offset % 512) + (*num_bytes % 512) < 512 ||
			    (*offset % 512) + (*num_bytes % 512) == 512) {
				*blkcnt = (lbaint_t)(*num_bytes / 512) + 1;
			} else {
				*blkcnt = (lbaint_t)(*num_bytes / 512) + 2;
			}
			
		}
	}
}

static AvbIOResult read_from_partition(AvbOps* ops,
                                       const char* partition,
                                       int64_t offset,
                                       size_t num_bytes,
                                       void* buffer,
                                       size_t* out_num_read)
{
	char *dev_iface = "mmc";
	char *buffer_temp;
	int dev_num = 0;
	struct blk_desc *dev_desc;
	lbaint_t offset_blk, blkcnt;
	disk_partition_t part_info;

	byte_to_block(&offset, &num_bytes, &offset_blk, &blkcnt);
	buffer_temp = malloc(512 * blkcnt);
	dev_desc = blk_get_dev(dev_iface, dev_num);
	if (!dev_desc) {
		printf("Could not find %s %d\n", dev_iface, dev_num);
		return -1;
	}

	if (part_get_info_by_name(dev_desc, partition, &part_info) < 0) {
		printf("Could not find \"%s\" partition\n", partition);
		return -1;
	}

	if((offset % 512 == 0) && (num_bytes % 512 == 0)) {
		blk_dread(dev_desc, part_info.start + offset_blk, blkcnt, buffer);
		*out_num_read = blkcnt * 512;
	} else {
		blk_dread(dev_desc, part_info.start + offset_blk, blkcnt, buffer_temp);
		memcpy(buffer, buffer_temp + (offset % 512), num_bytes);
		*out_num_read = num_bytes;
	}
	free(buffer_temp);

	return AVB_IO_RESULT_OK;
}

static AvbIOResult write_to_partition(AvbOps* ops,
                                      const char* partition,
                                      int64_t offset,
                                      size_t num_bytes,
                                      const void* buffer)
{
	const char *dev_iface = "mmc";
	int dev_num = 0;
	struct blk_desc *dev_desc;
	char *buffer_temp;
	disk_partition_t part_info;
	lbaint_t offset_blk, blkcnt;

	byte_to_block(&offset, &num_bytes, &offset_blk, &blkcnt);
	buffer_temp = malloc(512 * blkcnt);
	memset(buffer_temp, 0, 512 * blkcnt);

	dev_desc = blk_get_dev(dev_iface, dev_num);
	if (!dev_desc) {
		printf("Could not find %s %d\n", dev_iface, dev_num);
		return -1;
	}

	if (part_get_info_by_name(dev_desc, partition, &part_info) < 0) {
		printf("Could not find \"%s\" partition\n", partition);
		return -1;
	}

	if ((offset % 512 != 0) && (num_bytes % 512) != 0) {
		blk_dread(dev_desc, part_info.start + offset_blk, blkcnt, buffer_temp);
	}
	memcpy(buffer_temp, buffer + (offset % 512), num_bytes);

	if(blk_dwrite(dev_desc, part_info.start + offset_blk, blkcnt, buffer) != 1){
		printf("Can't write %s partition",partition);
	}
	free(buffer_temp);

	return AVB_IO_RESULT_OK;
}

static AvbIOResult validate_vbmeta_public_key(
	AvbOps *ops,
	const uint8_t *public_key_data,
	size_t public_key_length,
	const uint8_t *public_key_metadata,
	size_t public_key_metadata_length,
	bool *out_is_trusted)
{
	if (out_is_trusted != NULL) {
		*out_is_trusted = true;
	}
	return AVB_IO_RESULT_OK;
}


static AvbIOResult read_rollback_index(AvbOps *ops,
                                       size_t rollback_index_location,
                                       uint64_t *out_rollback_index)
{
	if (out_rollback_index != NULL) {
#ifdef CONFIG_OPTEE_CLIENT
		trusty_read_rollback_index(rollback_index_location, out_rollback_index);
#endif
	}
	return AVB_IO_RESULT_OK;
}

static AvbIOResult write_rollback_index(AvbOps *ops,
                                        size_t rollback_index_location,
                                        uint64_t rollback_index)
{
#ifdef CONFIG_OPTEE_CLIENT
	trusty_write_rollback_index(rollback_index_location, rollback_index);
#endif
	return AVB_IO_RESULT_OK;
}

static AvbIOResult read_is_device_unlocked(AvbOps *ops, bool *out_is_unlocked)
{
	if (out_is_unlocked != NULL) {
#ifdef CONFIG_OPTEE_CLIENT
		trusty_read_lock_state((uint8_t *)out_is_unlocked);
#endif
	}
	return AVB_IO_RESULT_OK;
}

static AvbIOResult write_is_device_unlocked(AvbOps *ops, bool *out_is_unlocked)
{
	if (out_is_unlocked != NULL) {
#ifdef CONFIG_OPTEE_CLIENT
		trusty_write_lock_state(*out_is_unlocked);
#endif
	}
	return AVB_IO_RESULT_OK;
}

static AvbIOResult get_size_of_partition(AvbOps *ops,
                                         const char *partition,
                                         uint64_t *out_size_in_bytes)
{
	const char *dev_iface = "mmc";
	int dev_num = 0;
	struct blk_desc *dev_desc;
	disk_partition_t part_info;

	dev_desc = blk_get_dev(dev_iface, dev_num);
	if (!dev_desc) {
		printf("Could not find %s %d\n", dev_iface, dev_num);
		return -1;
	}

	if (part_get_info_by_name(dev_desc, partition, &part_info) < 0) {
		printf("Could not find \"%s\" partition\n", partition);
		return -1;
	}
	*out_size_in_bytes = (part_info.size) * 512;
	return AVB_IO_RESULT_OK;
}

static AvbIOResult get_unique_guid_for_partition(AvbOps *ops,
                                                 const char *partition,
                                                 char *guid_buf,
                                                 size_t guid_buf_size)
{
	const char *dev_iface = "mmc";
	int dev_num = 0;
	struct blk_desc *dev_desc;
	disk_partition_t part_info;
	dev_desc = blk_get_dev(dev_iface, dev_num);
	if (!dev_desc) {
		printf("Could not find %s %d\n", dev_iface, dev_num);
		return -1;
	}

	if (part_get_info_by_name(dev_desc, partition, &part_info) < 0) {
		printf("Could not find \"%s\" partition\n", partition);
		return -1;
	}
	if (guid_buf != NULL && guid_buf_size > 0) {
		memcpy(guid_buf, part_info.uuid, guid_buf_size);
	}
	return AVB_IO_RESULT_OK;
}

AvbOps* avb_ops_user_new(void)
{
	AvbOps* ops;

	ops = calloc(1, sizeof(AvbOps));
	if (ops == NULL) {
		avb_error("Error allocating memory for AvbOps.\n");
		goto out;
	}

	ops->ab_ops = calloc(1, sizeof(AvbABOps));
	if (ops->ab_ops == NULL) {
		avb_error("Error allocating memory for AvbABOps.\n");
		free(ops);
		goto out;
	}
	ops->atx_ops = calloc(1, sizeof(AvbAtxOps));
	if (ops->atx_ops == NULL) {
		avb_error("Error allocating memory for AvbAtxOps.\n");
		free(ops->ab_ops);
		free(ops);
		goto out;
	}
	ops->ab_ops->ops = ops;
	ops->atx_ops->ops = ops;

	ops->read_from_partition = read_from_partition;
	ops->write_to_partition = write_to_partition;
	ops->validate_vbmeta_public_key = validate_vbmeta_public_key;
	ops->read_rollback_index = read_rollback_index;
	ops->write_rollback_index = write_rollback_index;
	ops->read_is_device_unlocked = read_is_device_unlocked;
	ops->write_is_device_unlocked = write_is_device_unlocked;
	ops->get_unique_guid_for_partition = get_unique_guid_for_partition;
	ops->get_size_of_partition = get_size_of_partition;
	ops->ab_ops->read_ab_metadata = avb_ab_data_read;
	ops->ab_ops->write_ab_metadata = avb_ab_data_write;
	ops->ab_ops->init_ab_metadata = avb_ab_data_init;
out:
	return ops;
}

void avb_ops_user_free(AvbOps *ops)
{
	free(ops->ab_ops);
	free(ops->atx_ops);
	free(ops);
}


int read_slot_count(char *slot_count)
{
	AvbOps* ops;
	AvbABData ab_data;
	memset(&ab_data,0,sizeof(AvbABData));
	ops = avb_ops_user_new();
	printf("read_slot_count\n");
	if (ops == NULL) {
		printf("avb_ops_user_new() failed!\n");
		return -1;
	}
	if (ops->ab_ops->read_ab_metadata(ops->ab_ops,&ab_data) != 0) {
		printf("read_slot_count error!\n");
		avb_ops_user_free(ops);
		return -1;
	}
	*slot_count = ab_data.nb_slot;
	avb_ops_user_free(ops);
	return 0;
}

int read_slot_suffixes(char *slot_suffixes)
{
	AvbOps* ops;
	AvbABData ab_data;
	memset(&ab_data,0,sizeof(AvbABData));
	ops = avb_ops_user_new();
	printf("read_slot_suffixes\n");
	if (ops == NULL) {
		printf("avb_ops_user_new() failed!\n");
		return -1;
	}
	if (ops->ab_ops->read_ab_metadata(ops->ab_ops,&ab_data) != 0) {
		printf("read_slot_suffixes error!\n");
		avb_ops_user_free(ops);
		return -1;
	}
	memcpy(slot_suffixes,ab_data.slot_suffix,4);
	avb_ops_user_free(ops);
	return 0;
}

int set_slot_active(unsigned int *slot_number)
{
	AvbOps* ops;
	ops = avb_ops_user_new();
	if (ops == NULL) {
		printf("avb_ops_user_new() failed!\n");
		return -1;
	}
	printf("set_slot_active\n");
	if (avb_ab_mark_slot_active(ops->ab_ops, *slot_number) != 0) {
		printf("set_slot_active error!\n");
		avb_ops_user_free(ops);
		return -1;
	}

	avb_ops_user_free(ops);
	return 0;
}

int get_current_slot(char *select_slot)
{
	AvbOps* ops;
	ops = avb_ops_user_new();
	if (ops == NULL) {
		printf("avb_ops_user_new() failed!\n");
		return -1;
	}
	if (avb_ab_slot_select(ops->ab_ops, select_slot) != 0) {
		printf("get_current_slot error!\n");
		avb_ops_user_free(ops);
		return -1;
	}

	avb_ops_user_free(ops);
	return 0;
}

int read_permanent_attributes(uint8_t *attributes, uint32_t size)
{
	if(trusty_read_permanent_attributes(attributes, size) != 0) {
		return -1;
	}

	return 0;
}

int write_permanent_attributes(uint8_t *attributes, uint32_t size)
{
	if(trusty_write_permanent_attributes(attributes, size) != 0) {
		return -1;
	}

	return 0;
}

int read_flash_lock_state(uint8_t *flash_lock_state)
{
	if (trusty_read_flash_lock_state(flash_lock_state))
		return -1;
	return 0;
}

int write_flash_lock_state(uint8_t flash_lock_state)
{
	if (trusty_write_flash_lock_state(flash_lock_state))
		return -1;
	return 0;
}

int read_lock_state(uint8_t *lock_state)
{
	if (trusty_read_lock_state(lock_state))
		return -1;
	return 0;
}

int write_lock_state(uint8_t lock_state)
{
	if (trusty_write_lock_state(lock_state))
		return -1;
	return 0;
}
