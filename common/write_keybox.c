// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2019 Fuzhou Rockchip Electronics Co., Ltd
 */

#include <common.h>
#include <boot_rkimg.h>
#include <stdlib.h>
#include <attestation_key.h>
#include <write_keybox.h>
#include <keymaster.h>
#include <optee_include/OpteeClientApiLib.h>
#include <optee_include/tee_client_api.h>
#include <optee_include/tee_api_defines.h>

#define STORAGE_CMD_WRITE	6
#define	SIZE_OF_TAG		4
#define	SIZE_OF_USB_CMD	8
#define	BOOT_FROM_EMMC	(1 << 1)
#define	WIDEVINE_TAG	"KBOX"
#define	ATTESTATION_TAG	"ATTE"
#define PLAYREADY30_TAG	"SL30"

uint32_t rk_send_keybox_to_ta(uint8_t *filename, uint32_t filename_size,
			      TEEC_UUID uuid,
			      uint8_t *key, uint32_t key_size,
			      uint8_t *data, uint32_t data_size)
{
	uint32_t ErrorOrigin;
	TEEC_Result TeecResult;
	TEEC_Context TeecContext;
	TEEC_Session TeecSession;
	TEEC_UUID *TeecUuid = &uuid;
	TEEC_Operation TeecOperation = {0};
	TEEC_SharedMemory SharedMem0 = {0};
	TEEC_SharedMemory SharedMem1 = {0};
	TEEC_SharedMemory SharedMem2 = {0};
	struct blk_desc *dev_desc;

	dev_desc = rockchip_get_bootdev();
	if (!dev_desc) {
		printf("%s: dev_desc is NULL!\n", __func__);
		return -TEEC_ERROR_GENERIC;
	}

	TeecResult = OpteeClientApiLibInitialize();
	if (TeecResult != TEEC_SUCCESS)
		return TeecResult;
	TeecResult = TEEC_InitializeContext(NULL, &TeecContext);
	if (TeecResult != TEEC_SUCCESS)
		return TeecResult;
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
	if (TeecResult != TEEC_SUCCESS)
		return TeecResult;

	SharedMem0.size = filename_size;
	SharedMem0.flags = 0;
	TeecResult = TEEC_AllocateSharedMemory(&TeecContext, &SharedMem0);
	if (TeecResult != TEEC_SUCCESS)
		return TeecResult;
	memcpy(SharedMem0.buffer, filename, SharedMem0.size);

	SharedMem1.size = key_size;
	SharedMem1.flags = 0;
	TeecResult = TEEC_AllocateSharedMemory(&TeecContext, &SharedMem1);
	if (TeecResult != TEEC_SUCCESS)
		return TeecResult;
	memcpy(SharedMem1.buffer, key, SharedMem1.size);

	SharedMem2.size = data_size;
	SharedMem2.flags = 0;
	TeecResult = TEEC_AllocateSharedMemory(&TeecContext, &SharedMem2);
	if (TeecResult != TEEC_SUCCESS)
		return TeecResult;
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
					STORAGE_CMD_WRITE,
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
	int rc = 0;
	TEEC_Result ret;

	if (memcmp(received_data, WIDEVINE_TAG, SIZE_OF_TAG) == 0) {
		/* widevine keybox */
		TEEC_UUID widevine_uuid = { 0x1b484ea5, 0x698b, 0x4142,
			{ 0x82, 0xb8, 0x3a, 0xcf, 0x16, 0xe9, 0x9e, 0x2a } };

		key_size = *(received_data + SIZE_OF_TAG);
		data_size = *(received_data + SIZE_OF_TAG + sizeof(key_size));

		ret = rk_send_keybox_to_ta((uint8_t *)"widevine_keybox",
					   sizeof("widevine_keybox"),
					   widevine_uuid,
					   received_data + SIZE_OF_TAG +
					   sizeof(key_size) + sizeof(data_size),
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
	} else if (memcmp(received_data, ATTESTATION_TAG, SIZE_OF_TAG) == 0) {
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
	} else if (memcmp(received_data, PLAYREADY30_TAG, SIZE_OF_TAG) == 0) {
		/* PlayReady SL3000 root key */
		uint32_t ret;

		data_size = *(received_data + SIZE_OF_TAG);
		ret = write_to_keymaster((uint8_t *)"PlayReady_SL3000",
					 sizeof("PlayReady_SL3000"),
					 received_data + SIZE_OF_TAG +
					 sizeof(data_size),
					 data_size);
		if (ret == TEEC_SUCCESS) {
			rc = 0;
			printf("write PlayReady SL3000 root key to secure storage success\n");
		} else {
			rc = -EIO;
			printf("write PlayReady SL3000 root key to secure storage fail\n");
		}
	}

	/* write all data to secure storage for readback check */
	if (!rc) {
		uint32_t ret;

		ret = write_to_keymaster((uint8_t *)"raw_data",
					 sizeof("raw_data"),
					 received_data, len);
		if (ret == TEEC_SUCCESS)
			rc = 0;
		else
			rc = -EIO;
	}
	return rc;
}

uint32_t read_raw_data_from_secure_storage(uint8_t *data, uint32_t data_size)
{
	uint32_t rc;

	rc = read_from_keymaster((uint8_t *)"raw_data", sizeof("raw_data"),
				 data, data_size - SIZE_OF_USB_CMD);
	if (rc != TEEC_SUCCESS)
		return 0;
	rc = data_size - SIZE_OF_USB_CMD;

	return rc;
}
