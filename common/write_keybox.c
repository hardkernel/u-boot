// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <optee_include/OpteeClientApiLib.h>
#include <optee_include/tee_client_api.h>
#include <optee_include/tee_api_defines.h>
#include <boot_rkimg.h>
#include <stdlib.h>
#include <attestation_key.h>
#include "write_keybox.h"

#define	BOOT_FROM_EMMC	(1 << 1)
#define	WIDEVINE_TAG	"KBOX"
#define	ATTESTATION_TAG	"ATTE"

uint32_t rk_send_keybox_to_ta(uint8_t *filename, uint32_t filename_size,
			      TEEC_UUID uuid,
			      uint8_t *key, uint32_t key_size,
			      uint8_t *data, uint32_t data_size)
{
	TEEC_Result TeecResult;
	TEEC_Context TeecContext;
	TEEC_Session TeecSession;
	uint32_t ErrorOrigin;
	TEEC_UUID *TeecUuid = &uuid;
	TEEC_Operation TeecOperation = {0};
	struct blk_desc *dev_desc;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return -TEEC_ERROR_GENERIC;
	}

	OpteeClientApiLibInitialize();
	TeecResult = TEEC_InitializeContext(NULL, &TeecContext);
	TeecOperation.paramTypes = TEEC_PARAM_TYPES(TEEC_VALUE_INPUT,
						    TEEC_NONE,
						    TEEC_NONE,
						    TEEC_NONE);

	/* 0 nand or emmc "security" partition , 1 rpmb */
	TeecOperation.params[0].value.a =
		(dev_desc->if_type == IF_TYPE_MMC) ? 1 : 0;
#ifdef CONFIG_OPTEE_ALWAYS_USE_SECURITY_PARTITION
	TeecOperation.params[0].value.a = 0;
#endif
	TeecResult = TEEC_OpenSession(&TeecContext,
				      &TeecSession,
				      TeecUuid,
				      TEEC_LOGIN_PUBLIC,
				      NULL,
				      &TeecOperation,
				      &ErrorOrigin);

	TEEC_SharedMemory SharedMem0 = {0};

	SharedMem0.size = filename_size;
	SharedMem0.flags = 0;
	TeecResult = TEEC_AllocateSharedMemory(&TeecContext, &SharedMem0);
	memcpy(SharedMem0.buffer, filename, SharedMem0.size);
	TEEC_SharedMemory SharedMem1 = {0};

	SharedMem1.size = key_size;
	SharedMem1.flags = 0;
	TeecResult = TEEC_AllocateSharedMemory(&TeecContext, &SharedMem1);
	memcpy(SharedMem1.buffer, key, SharedMem1.size);
	TEEC_SharedMemory SharedMem2 = {0};

	SharedMem2.size = data_size;
	SharedMem2.flags = 0;
	TeecResult = TEEC_AllocateSharedMemory(&TeecContext, &SharedMem2);
	memcpy(SharedMem2.buffer, data, SharedMem2.size);

	TeecOperation.params[0].tmpref.buffer = SharedMem0.buffer;
	TeecOperation.params[0].tmpref.size = SharedMem0.size;
	TeecOperation.params[1].tmpref.buffer = SharedMem1.buffer;
	TeecOperation.params[1].tmpref.size = SharedMem1.size;
	TeecOperation.params[2].tmpref.buffer = SharedMem2.buffer;
	TeecOperation.params[2].tmpref.size = SharedMem2.size;

	TeecOperation.paramTypes = TEEC_PARAM_TYPES(TEEC_MEMREF_TEMP_INPUT,
						    TEEC_MEMREF_TEMP_INPUT,
						    TEEC_MEMREF_TEMP_INOUT,
						    TEEC_NONE);

	printf("write keybox to secure storage\n");
	TeecResult = TEEC_InvokeCommand(&TeecSession,
					6,
					&TeecOperation,
					&ErrorOrigin);
	if (TeecResult != TEEC_SUCCESS)
		printf("send data to TA failed with code 0x%x\n", TeecResult);
	else
		printf("send data to TA success with code 0x%x\n", TeecResult);

	TEEC_ReleaseSharedMemory(&SharedMem0);
	TEEC_ReleaseSharedMemory(&SharedMem1);
	TEEC_ReleaseSharedMemory(&SharedMem2);

	TEEC_CloseSession(&TeecSession);
	TEEC_FinalizeContext(&TeecContext);

	return TeecResult;
}

uint32_t write_keybox_to_secure_storage(uint8_t *received_data, uint32_t len)
{
	uint32_t key_size;
	uint32_t data_size;
	TEEC_Result ret;
	int rc = 0;

	if (memcmp(received_data, WIDEVINE_TAG, 4) == 0) {
		/* widevine keybox */
		TEEC_UUID widevine_uuid = { 0x1b484ea5, 0x698b, 0x4142,
			{ 0x82, 0xb8, 0x3a, 0xcf, 0x16, 0xe9, 0x9e, 0x2a } };

		key_size = *(received_data + 4);
		data_size = *(received_data + 8);

		ret = rk_send_keybox_to_ta((uint8_t *)"widevine_keybox",
					   sizeof("widevine_keybox"),
					   widevine_uuid,
					   received_data + 12,
					   key_size,
					   received_data + 12 + key_size,
					   data_size);
		if (ret == TEEC_SUCCESS) {
			rc = 0;
			printf("write widevine keybox to secure storage success\n");
		} else {
			rc = -EIO;
			printf("write widevine keybox to secure storage fail\n");
		}
	} else if (memcmp(received_data, ATTESTATION_TAG, 4) == 0) {
		/* attestation key */
		atap_result ret;

		ret = write_attestation_key_to_secure_storage(received_data, len);
		if (ret == ATAP_RESULT_OK) {
			rc = 0;
			printf("write attestation key to secure storage success\n");
		} else {
			rc = -EIO;
			printf("write attestation key to secure storage fail\n");
		}
	}
	return rc;
}
