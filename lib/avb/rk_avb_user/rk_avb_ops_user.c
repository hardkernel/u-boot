/*
 * (C) Copyright 2017 Rockchip Electronics Co., Ltd
 *
 * SPDX-License-Identifier:     GPL-2.0+
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
#include <android_avb/avb_atx_types.h>
#include <optee_include/OpteeClientInterface.h>
#include <optee_include/tee_api_defines.h>
#include <android_avb/avb_vbmeta_image.h>
#include <android_avb/avb_atx_validate.h>
#include <android_avb/rk_avb_ops_user.h>
#include <boot_rkimg.h>

/* rk used */
int rk_avb_read_slot_count(char *slot_count)
{
	*slot_count = SLOT_NUM;

	return 0;
}

int rk_avb_read_slot_suffixes(char *slot_suffixes)
{
	memcpy(slot_suffixes, CURR_SYSTEM_SLOT_SUFFIX,
	       strlen(CURR_SYSTEM_SLOT_SUFFIX));

	return 0;
}

int rk_avb_set_slot_active(unsigned int *slot_number)
{
	AvbOps* ops;
	ops = avb_ops_user_new();
	int ret = 0;

	if (ops == NULL) {
		printf("avb_ops_user_new() failed!\n");
		return -1;
	}

	debug("set_slot_active\n");
	if (avb_ab_mark_slot_active(ops->ab_ops, *slot_number) != 0) {
		printf("set_slot_active error!\n");
		ret = -1;
	}

	avb_ops_user_free(ops);
	return ret;
}

static bool slot_is_bootable(AvbABSlotData* slot) {
	return (slot->priority > 0) && 
	       (slot->successful_boot || (slot->tries_remaining > 0));
}

AvbABFlowResult rk_avb_ab_slot_select(AvbABOps* ab_ops,char* select_slot)
{
	AvbABFlowResult ret = AVB_AB_FLOW_RESULT_OK;
	AvbIOResult io_ret = AVB_IO_RESULT_OK;
	AvbABData ab_data;
	size_t slot_index_to_boot;

	io_ret = ab_ops->read_ab_metadata(ab_ops, &ab_data);
	if (io_ret != AVB_IO_RESULT_OK) {
		avb_error("I/O error while loading A/B metadata.\n");
		ret = AVB_AB_FLOW_RESULT_ERROR_IO;
		goto out;
	}
	if (slot_is_bootable(&ab_data.slots[0]) && slot_is_bootable(&ab_data.slots[1])) {
		if (ab_data.slots[1].priority > ab_data.slots[0].priority) {
			slot_index_to_boot = 1;
		} else {
			slot_index_to_boot = 0;
		}
	} else if(slot_is_bootable(&ab_data.slots[0])) {
		slot_index_to_boot = 0;
	} else if(slot_is_bootable(&ab_data.slots[1])) {
		slot_index_to_boot = 1;
	} else {
		avb_error("No bootable slots found.\n");
		ret = AVB_AB_FLOW_RESULT_ERROR_NO_BOOTABLE_SLOTS;
		goto out;
	}

	if (slot_index_to_boot == 0) {
		strcpy(select_slot, "_a");
	} else if(slot_index_to_boot == 1) {
		strcpy(select_slot, "_b");
	}
out:
	return ret;
}

int rk_avb_get_current_slot(char *select_slot)
{
	AvbOps* ops;
	int ret = 0;

	ops = avb_ops_user_new();
	if (ops == NULL) {
		printf("avb_ops_user_new() failed!\n");
		return -1;
	}

	if (rk_avb_ab_slot_select(ops->ab_ops, select_slot) != 0) {
		printf("get_current_slot error!\n");
		ret = -1;
	}

	avb_ops_user_free(ops);
	return ret;
}

int rk_avb_read_permanent_attributes(uint8_t *attributes, uint32_t size)
{
#ifdef CONFIG_OPTEE_CLIENT
	if(trusty_read_permanent_attributes(attributes, size) != 0) {
		printf("trusty_read_permanent_attributes failed!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_write_permanent_attributes(uint8_t *attributes, uint32_t size)
{
#ifdef CONFIG_OPTEE_CLIENT
	if(trusty_write_permanent_attributes(attributes, size) != 0) {
		printf("trusty_write_permanent_attributes failed!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_read_flash_lock_state(uint8_t *flash_lock_state)
{
#ifdef CONFIG_OPTEE_CLIENT
	int ret;

	ret = trusty_read_flash_lock_state(flash_lock_state);
	if (ret == TEE_ERROR_ITEM_NOT_FOUND) {
		*flash_lock_state = 1;
		if (trusty_write_flash_lock_state(*flash_lock_state)) {
			printf("trusty_write_flash_lock_state error!\n");
			return -1;
		}

		ret = trusty_read_flash_lock_state(flash_lock_state);

		return ret;
	} else if (ret == 0) {
		return 0;
	} else {
		printf("avb_read_flash_lock_state ret = %x\n", ret);
		return -1;
	}
#else
	return -1;
#endif
}

int rk_avb_write_flash_lock_state(uint8_t flash_lock_state)
{
#ifdef CONFIG_OPTEE_CLIENT
	if (trusty_write_flash_lock_state(flash_lock_state)) {
		printf("trusty_write_flash_lock_state error!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_write_lock_state(uint8_t lock_state)
{
#ifdef CONFIG_OPTEE_CLIENT
	if (trusty_write_lock_state(lock_state)) {
		printf("trusty_write_lock_state error!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_read_lock_state(uint8_t *lock_state)
{
#ifdef CONFIG_OPTEE_CLIENT
	int ret;

	ret = trusty_read_lock_state(lock_state);
	if (ret == TEE_ERROR_ITEM_NOT_FOUND) {
		*lock_state = 1;
		if (rk_avb_write_lock_state(*lock_state)) {
			printf("avb_write_lock_state error!\n");
			return -1;
		}

		ret = trusty_read_lock_state(lock_state);

		return ret;
	} else if (ret == 0) {
		return 0;
	} else {
		printf("avb_read_lock_state ret = %x\n", ret);
		return -1;
	}
#else
	return -1;
#endif
}

int rk_avb_write_perm_attr_flag(uint8_t flag)
{
#ifdef CONFIG_OPTEE_CLIENT
	if (trusty_write_permanent_attributes_flag(flag)) {
		printf("trusty_write_permanent_attributes_flag error!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_read_perm_attr_flag(uint8_t *flag)
{
#ifdef CONFIG_OPTEE_CLIENT
	int ret;

	ret = trusty_read_permanent_attributes_flag(flag);
	if (ret != TEE_SUCCESS) {
		*flag = 0;
		if (rk_avb_write_perm_attr_flag(*flag)) {
			printf("avb_write_perm_attr_flag error!\n");
			return -1;
		}

		ret = trusty_read_permanent_attributes_flag(flag);

		return ret;
	} else if (ret == 0) {
		return 0;
	} else {
		printf("avb_read_perm_attr_flag ret = %x\n", ret);
		return -1;
	}
#else
	return -1;
#endif
}

int rk_avb_read_vbootkey_hash(uint8_t *buf, uint8_t length)
{
#ifdef CONFIG_OPTEE_CLIENT
	if (trusty_read_vbootkey_hash((uint32_t *)buf,
				      (uint32_t)length / sizeof(uint32_t))) {
		printf("trusty_read_vbootkey_hash error!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_write_vbootkey_hash(uint8_t *buf, uint8_t length)
{
#ifdef CONFIG_OPTEE_CLIENT
	if (trusty_write_vbootkey_hash((uint32_t *)buf,
				       (uint32_t)length / sizeof(uint32_t))) {
		printf("trusty_write_vbootkey_hash error!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_close_optee_client(void)
{
#ifdef CONFIG_OPTEE_CLIENT
	if(trusty_notify_optee_uboot_end()) {
		printf("trusty_notify_optee_uboot_end error!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_read_attribute_hash(uint8_t *buf, uint8_t length)
{
#ifdef CONFIG_OPTEE_CLIENT
	if (trusty_read_attribute_hash((uint32_t *)buf,
	    (uint32_t)(length/sizeof(uint32_t)))) {
		printf("trusty_read_attribute_hash error!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_write_attribute_hash(uint8_t *buf, uint8_t length)
{
#ifdef CONFIG_OPTEE_CLIENT
	if (trusty_write_attribute_hash((uint32_t *)buf,
	    (uint32_t)(length/sizeof(uint32_t)))) {
		printf("trusty_write_attribute_hash error!\n");
		return -1;
	}

	return 0;
#else
	return -1;
#endif
}

int rk_avb_read_all_rollback_index(char *buffer)
{
	AvbOps* ops;
	uint64_t stored_rollback_index = 0;
	AvbIOResult io_ret;
	char temp[ROLLBACK_MAX_SIZE] = {0};
	int n;

	ops = avb_ops_user_new();
	if (ops == NULL) {
		printf("avb_ops_user_new() failed!\n");
		return -1;
	}

	for (n = 0; n < AVB_MAX_NUMBER_OF_ROLLBACK_INDEX_LOCATIONS; n++) {
		io_ret = ops->read_rollback_index(
			ops, n, &stored_rollback_index);
		if (io_ret != AVB_IO_RESULT_OK)
			goto out;
		snprintf(temp, sizeof(int) + 1, "%d", n);
		strncat(buffer, temp, ROLLBACK_MAX_SIZE);
		strncat(buffer, ":", 1);
		snprintf(temp, sizeof(uint64_t) + 1, "%lld",
			 stored_rollback_index);
		strncat(buffer, temp, ROLLBACK_MAX_SIZE);
		strncat(buffer, ",", 1);
	}

	io_ret =
		ops->read_rollback_index(ops,
					 AVB_ATX_PIK_VERSION_LOCATION,
					 &stored_rollback_index);
	if (io_ret != AVB_IO_RESULT_OK) {
		avb_error("Failed to read PIK minimum version.\n");
		goto out;
	}
	/* PIK rollback index */
	snprintf(temp, sizeof(int) + 1, "%d", AVB_ATX_PIK_VERSION_LOCATION);
	strncat(buffer, temp, ROLLBACK_MAX_SIZE);
	strncat(buffer, ":", 1);
	snprintf(temp, sizeof(uint64_t) + 1, "%lld", stored_rollback_index);
	strncat(buffer, temp, ROLLBACK_MAX_SIZE);
	strncat(buffer, ",", 1);
	io_ret = ops->read_rollback_index(ops,
					  AVB_ATX_PSK_VERSION_LOCATION,
					  &stored_rollback_index);
	if (io_ret != AVB_IO_RESULT_OK) {
		avb_error("Failed to read PSK minimum version.\n");
		goto out;
	}
	/* PSK rollback index */
	snprintf(temp, sizeof(int) + 1, "%d", AVB_ATX_PSK_VERSION_LOCATION);
	strncat(buffer, temp, ROLLBACK_MAX_SIZE);
	strncat(buffer, ":", 1);
	snprintf(temp, sizeof(uint64_t) + 1, "%lld", stored_rollback_index);
	strncat(buffer, temp, ROLLBACK_MAX_SIZE);
	debug("%s\n", buffer);
	avb_ops_user_free(ops);

	return 0;
out:
	avb_ops_user_free(ops);

	return -1;
}

int rk_avb_read_bootloader_locked_flag(uint8_t *flag)
{
#ifdef CONFIG_OPTEE_CLIENT
	if (trusty_read_vbootkey_enable_flag(flag)) {
		return -1;
	}
	return 0;
#else
	return -1;
#endif
}

#ifdef CONFIG_SUPPORT_EMMC_RPMB
static int curr_device = -1;

int rk_bootloader_rollback_index_read(uint32_t offset, uint32_t bytes,
				      void *rb_index)
{

	struct mmc *mmc;
	uint8_t rpmb_buf[256] = {0};
	uint32_t n;
	char original_part;

	if ((offset + bytes) > 256)
		return -1;

	if (curr_device < 0) {
		if (get_mmc_num() > 0)
			curr_device = 0;
		else {
			avb_error("No MMC device available");
			return -1;
		}
	}

	mmc = find_mmc_device(curr_device);
	/* Switch to the RPMB partition */
#ifndef CONFIG_BLK
	original_part = mmc->block_dev.hwpart;
#else
	original_part = mmc_get_blk_desc(mmc)->hwpart;
#endif
	if (blk_select_hwpart_devnum(IF_TYPE_MMC, curr_device, MMC_PART_RPMB) !=
	    0)
		return -1;

	n =  mmc_rpmb_read(mmc, rpmb_buf, RPMB_BASE_ADDR, 1, NULL);
	if (n != 1)
		return -1;

	/* Return to original partition */
	if (blk_select_hwpart_devnum(IF_TYPE_MMC, curr_device, original_part) !=
	    0)
		return -1;

	memcpy(rb_index, (void*)&rpmb_buf[offset], bytes);

	return 0;
}

int rk_avb_get_bootloader_min_version(char *buffer)
{
	uint32_t rb_index;
	char temp[ROLLBACK_MAX_SIZE] = {0};

	if (rk_bootloader_rollback_index_read(UBOOT_RB_INDEX_OFFSET,
					      sizeof(uint32_t), &rb_index)) {
		avb_error("Can not read uboot rollback index");
		return -1;
	}
	snprintf(temp, sizeof(int) + 1, "%d", 0);
	strncat(buffer, temp, ROLLBACK_MAX_SIZE);
	strncat(buffer, ":", 1);
	snprintf(temp, sizeof(uint32_t) + 1, "%d", rb_index);
	strncat(buffer, temp, ROLLBACK_MAX_SIZE);
	strncat(buffer, ",", 1);

	if (rk_bootloader_rollback_index_read(TRUST_RB_INDEX_OFFSET,
					      sizeof(uint32_t), &rb_index)) {
		avb_error("Can not read trust rollback index");
		return -1;
	}

	snprintf(temp, sizeof(int) + 1, "%d", 1);
	strncat(buffer, temp, ROLLBACK_MAX_SIZE);
	strncat(buffer, ":", 1);
	snprintf(temp, sizeof(uint32_t) + 1, "%d", rb_index);
	strncat(buffer, temp, ROLLBACK_MAX_SIZE);

	return 0;
}
#endif

void rk_avb_get_at_vboot_state(char *buf)
{
	char temp_buffer[200] = {0};
	char temp_flag = 0;
	char crlf[2] = {'\n', 0};
	char *lock_val = NULL;
	char *unlocK_dis_val = NULL;
	char *perm_attr_flag = NULL;
	char *bootloader_locked_flag = NULL;
	char *lock_state = "bootloader-locked=";
	char *btld_min_ver = "bootloader-min-versions=";
	char *avb_perm_attr_set = "avb-perm-attr-set=";
	char *avb_lock = "avb-locked=";
	char *avb_unlock_dis = "avb-unlock-disabled=";
	char *avb_min_ver = "avb-min-versions=";

	if (rk_avb_read_perm_attr_flag((uint8_t *)&temp_flag)) {
		printf("Can not read perm_attr_flag!\n");
		perm_attr_flag = "";
	} else {
		perm_attr_flag = temp_flag ? "1" : "0";
	}
	sprintf(buf, "%s%s%s%s", buf, avb_perm_attr_set, perm_attr_flag, crlf);

	temp_flag = 0;
	if (rk_avb_read_lock_state((uint8_t *)&temp_flag)) {
		printf("Can not read lock state!\n");
		lock_val = "";
		unlocK_dis_val = "";
	} else {
		lock_val = (temp_flag & LOCK_MASK) ? "0" : "1";
		unlocK_dis_val = (temp_flag & UNLOCK_DISABLE_MASK) ? "1" : "0";
	}
	sprintf(buf, "%s%s%s%s%s%s%s", buf, avb_lock, lock_val, crlf,
		avb_unlock_dis, unlocK_dis_val, crlf);

	temp_flag = 0;
	if (rk_avb_read_bootloader_locked_flag((uint8_t *)&temp_flag)) {
		printf("Can not read bootloader locked flag!\n");
		bootloader_locked_flag = "";
	} else {
		bootloader_locked_flag = temp_flag ? "1" : "0";
	}
	sprintf(buf, "%s%s%s%s", buf, lock_state, bootloader_locked_flag, crlf);

	if (rk_avb_read_all_rollback_index(temp_buffer))
		printf("Can not avb_min_ver!\n");
	sprintf(buf, "%s%s%s%s", buf, avb_min_ver, temp_buffer, crlf);

	/* bootloader-min-versions */
	memset(temp_buffer, 0, 200);
#ifdef CONFIG_SUPPORT_EMMC_RPMB
	if (rk_avb_get_bootloader_min_version(temp_buffer))
		avb_error("Call rk_avb_get_bootloader_min_version error!");
#else
	memcpy(temp_buffer, "-1", strlen("-1"));
#endif
	sprintf(buf, "%s%s%s%s", buf, btld_min_ver, temp_buffer, crlf);
}

int rk_avb_get_ab_info(AvbABData* ab_data)
{
	AvbOps* ops;
	AvbIOResult io_ret = AVB_IO_RESULT_OK;
	int ret = 0;

	ops = avb_ops_user_new();
	if (ops == NULL) {
		printf("%s: avb_ops_user_new() failed!\n", __FILE__);
		return -1;
	}

	io_ret = ops->ab_ops->read_ab_metadata(ops->ab_ops, ab_data);
	if (io_ret != AVB_IO_RESULT_OK) {
		avb_error("I/O error while loading A/B metadata.\n");
		ret = -1;
	}

	avb_ops_user_free(ops);

	return ret;
}

int rk_avb_get_part_has_slot_info(const char *base_name)
{
	char *part_name;
	int part_num;
	size_t part_name_len;
	disk_partition_t part_info;
	struct blk_desc *dev_desc;
	const char *slot_suffix = "_a";

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: Could not find device!\n", __func__);
		return -1;
	}

	if (base_name == NULL) {
		printf("The base_name is NULL!\n");
		return -1;
	}

	part_name_len = strlen(base_name) + 1;
	part_name_len += strlen(slot_suffix);
	part_name = malloc(part_name_len);
	if (!part_name) {
		printf("%s can not malloc a buffer!\n", __FILE__);
		return -1;
	}

	memset(part_name, 0, part_name_len);
	snprintf(part_name, part_name_len, "%s%s", base_name, slot_suffix);
	part_num = part_get_info_by_name(dev_desc, part_name, &part_info);
	if (part_num < 0) {
		printf("Could not find partition \"%s\"\n", part_name);
		part_num = -1;
	}

	free(part_name);
	return part_num;
}

int rk_auth_unlock(void *buffer, char *out_is_trusted)
{
	AvbOps* ops;

	ops = avb_ops_user_new();
	if (ops == NULL) {
		avb_error("avb_ops_user_new() failed!");
		return -1;
	}

	if (avb_atx_validate_unlock_credential(ops->atx_ops,
					   (AvbAtxUnlockCredential*)buffer,
					   (bool*)out_is_trusted)) {
		avb_ops_user_free(ops);
		return -1;
	}
	avb_ops_user_free(ops);
	if (*out_is_trusted == true)
		return 0;
	else
		return -1;
}

int rk_generate_unlock_challenge(void *buffer, uint32_t *challenge_len)
{
	AvbOps* ops;
	AvbIOResult result = AVB_IO_RESULT_OK;

	ops = avb_ops_user_new();
	if (ops == NULL) {
		avb_error("avb_ops_user_new() failed!");
		return -1;
	}

	result = avb_atx_generate_unlock_challenge(ops->atx_ops,
						   (AvbAtxUnlockChallenge *)buffer);
	avb_ops_user_free(ops);
	*challenge_len = sizeof(AvbAtxUnlockChallenge);
	if (result == AVB_IO_RESULT_OK)
		return 0;
	else
		return -1;
}
