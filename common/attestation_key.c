/*
 * Copyright 2018, Rockchip Electronics Co., Ltd
 * qiujian, <qiujian@rock-chips.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include "attestation_key.h"

#include <common.h>
#include <malloc.h>

#include <optee_include/OpteeClientApiLib.h>

/* attestation data offset*/
#define ATTESTATION_DATA_OFFSET  65536

/* block size */
#define ATTESTATION_DATA_BLOCK_SIZE 512

/* attestation data block offset */
#define ATTESTATION_DATA_BLOCK_OFFSET (ATTESTATION_DATA_OFFSET / ATTESTATION_DATA_BLOCK_SIZE)

#define ATAP_BLOB_LEN_MAX 2048
#define ATAP_CERT_CHAIN_LEN_MAX 8192
#define ATAP_CERT_CHAIN_ENTRIES_MAX 8

/*
 * Name of the attestation key file is
 * ATTESTATION_KEY_PREFIX.%algorithm,
 * where algorithm is either "EC" or "RSA"
 */
#define ATTESTATION_KEY_PREFIX "PrivateKey"

/*
 * Name of the attestation certificate file is
 * ATTESTATION_CERT_PREFIX.%algorithm.%index,
 * where index is the index within the certificate chain.
 */
#define ATTESTATION_CERT_PREFIX "CertificateChain"

/* Maximum file name size.*/
#define STORAGE_ID_LENGTH_MAX  64

typedef enum{
	KM_ALGORITHM_RSA = 1,
	KM_ALGORITHM_EC = 3,
} keymaster_algorithm_t;

typedef struct {
	uint8_t *data;
	uint32_t data_length;
} atap_blob;

typedef struct {
	atap_blob entries[ATAP_CERT_CHAIN_ENTRIES_MAX];
	uint32_t entry_count;
} atap_certchain;

uint32_t write_to_keymaster(uint8_t *filename, uint32_t filename_size,
				uint8_t *data, uint32_t data_size);

static const char *get_keyslot_str(keymaster_algorithm_t key_type)
{
	switch (key_type) {
	case KM_ALGORITHM_RSA:
		return "RSA";
	case KM_ALGORITHM_EC:
		return "EC";
	default:
		return "";
	}
}

static void free_blob(atap_blob blob)
{
	if (blob.data)
		free(blob.data);

	blob.data_length = 0;
}

static void free_cert_chain(atap_certchain cert_chain)
{
	unsigned int i = 0;

	for (i = 0; i < cert_chain.entry_count; ++i) {
		if (cert_chain.entries[i].data)
			free(cert_chain.entries[i].data);

		cert_chain.entries[i].data_length = 0;
	}
	memset(&cert_chain, 0, sizeof(atap_certchain));
}

static void copy_from_buf(uint8_t **buf_ptr, void *data, uint32_t data_size)
{
	memcpy(data, *buf_ptr, data_size);
	*buf_ptr += data_size;
}

static void copy_uint32_from_buf(uint8_t **buf_ptr, uint32_t *x)
{
	copy_from_buf(buf_ptr, x, sizeof(uint32_t));
}

static bool copy_blob_from_buf(uint8_t **buf_ptr, atap_blob *blob)
{
	memset(blob, 0, sizeof(atap_blob));
	copy_uint32_from_buf(buf_ptr, &blob->data_length);

	if (blob->data_length > ATAP_BLOB_LEN_MAX)
		return false;

	if (blob->data_length) {
		blob->data = (uint8_t *) malloc(blob->data_length);
		if (blob->data == NULL)
			return false;

		copy_from_buf(buf_ptr, blob->data, blob->data_length);
	}
	return true;
}

static bool copy_cert_chain_from_buf(uint8_t **buf_ptr,
					atap_certchain *cert_chain)
{
	uint32_t cert_chain_size = 0;
	int32_t bytes_remaining = 0;
	size_t i = 0;
	bool retval = true;

	memset(cert_chain, 0, sizeof(atap_certchain));

	/* Copy size of cert chain, as it is a Variable field. */
	copy_from_buf(buf_ptr, &cert_chain_size, sizeof(cert_chain_size));

	if (cert_chain_size > ATAP_CERT_CHAIN_LEN_MAX)
		return false;

	if (cert_chain_size == 0)
		return true;

	bytes_remaining = cert_chain_size;
	for (i = 0; i < ATAP_CERT_CHAIN_ENTRIES_MAX; ++i) {
		if (!copy_blob_from_buf(buf_ptr, &cert_chain->entries[i])) {
			retval = false;
			break;
		}

		++cert_chain->entry_count;
		bytes_remaining -= (sizeof(uint32_t) +
					cert_chain->entries[i].data_length);

		if (bytes_remaining <= 0) {
			retval = (bytes_remaining == 0);
			break;
		}
	}
	if (retval == false)
		free_cert_chain(*cert_chain);

	return retval;
}

/* validate attestation data head. */
static bool validate_ca_header(const uint8_t *buf, uint32_t buf_size)
{

	if (buf[0] != 'C' || buf[1] != 'A' || buf[2] != 0)
		return false;

	uint32_t data_size;

	memcpy(&data_size, buf + 3, sizeof(uint32_t));

	if (data_size <= 0 || data_size > ATTESTATION_DATA_OFFSET) {
		printf("invalide data_size:%d\n", data_size);
		return false;
	}

	uint32_t real_size;

	memcpy(&real_size, buf + 3 + sizeof(uint32_t), sizeof(uint32_t));
	if (real_size <= 0 || real_size > data_size) {
		printf("invalide real_size:%d\n", real_size);
		return false;
	}
	return true;
}

/* write key to security storage. */
static uint32_t write_key(keymaster_algorithm_t key_type,
				const uint8_t *key, uint32_t key_size)
{
	char key_file[STORAGE_ID_LENGTH_MAX] = {0};

	snprintf(key_file, STORAGE_ID_LENGTH_MAX, "%s.%s", ATTESTATION_KEY_PREFIX,
		get_keyslot_str(key_type));
	write_to_keymaster((uint8_t *)key_file, strlen(key_file),
				(uint8_t *)key, key_size);
	return 0;
}

/* write cert to security storage. */
static uint32_t write_cert(keymaster_algorithm_t key_type, const uint8_t *cert,
				uint32_t cert_size, uint32_t index)
{
	char cert_file[STORAGE_ID_LENGTH_MAX] = {0};

	snprintf(cert_file, STORAGE_ID_LENGTH_MAX, "%s.%s.%d", ATTESTATION_CERT_PREFIX,
		get_keyslot_str(key_type), index);
	write_to_keymaster((uint8_t *)cert_file, strlen(cert_file),
				(uint8_t *)cert, cert_size);
	return 0;
}

/* write cert chain length to security storage. */
static uint32_t write_cert_chain_length(keymaster_algorithm_t key_type,
				uint8_t chain_len)
{
	char cert_chain_length_file[STORAGE_ID_LENGTH_MAX] = {0};
	uint8_t data = chain_len;
	uint32_t len = 1;

	snprintf(cert_chain_length_file, STORAGE_ID_LENGTH_MAX, "%s.%s.length",
		ATTESTATION_CERT_PREFIX, get_keyslot_str(key_type));
	write_to_keymaster((uint8_t *)cert_chain_length_file,
				strlen(cert_chain_length_file), &data, len);

	return 0;
}

atap_result load_attestation_key(struct blk_desc *dev_desc,
				disk_partition_t *misc_partition)
{
	int ret;

	if (!dev_desc) {
		printf("%s: Could not find device\n", __func__);
		return ATAP_RESULT_ERROR_DEVICE_NOT_FOUND;
	}

	if (misc_partition == NULL) {
		printf("misc partition not found!\n");
		return ATAP_RESULT_ERROR_PARTITION_NOT_FOUND;
	}

	/* get attestation data offset from misc partition */
	lbaint_t key_offset = misc_partition->start +
				misc_partition->size - ATTESTATION_DATA_BLOCK_OFFSET;

	/* read ca head from attestation data offset */
	uint8_t ca_headr[ATTESTATION_DATA_BLOCK_SIZE];

	ret = blk_dread(dev_desc, key_offset, 1, ca_headr);
	if (ret != 1) {
		printf("failed to read ca head from misc\n");
		return ATAP_RESULT_ERROR_BLOCK_READ;
	}

	if (!validate_ca_header(ca_headr, sizeof(ca_headr))) {
		printf("ca head not found\n");
		return ATAP_RESULT_ERROR_INVALID_HEAD;
	}

	/* get attestation data size from ca head */
	uint32_t real_size;

	memcpy(&real_size, ca_headr + 3 + sizeof(uint32_t), sizeof(uint32_t));

	/* calculate real block size of attestation data */
	int real_block_num = real_size / ATTESTATION_DATA_BLOCK_SIZE;

	if (real_size % ATTESTATION_DATA_BLOCK_SIZE != 0)
		real_block_num++;

	unsigned char keybuf[ATTESTATION_DATA_OFFSET] = {0};

	/* check block size */
	if (real_block_num <= 0 || real_block_num > ATTESTATION_DATA_BLOCK_OFFSET) {
		printf("invalidate real_block_num:%d\n", real_block_num);
		return ATAP_RESULT_ERROR_INVALID_BLOCK_NUM;
	}

	/* read all attestation data from misc */
	if (blk_dread(dev_desc, key_offset, real_block_num, keybuf) != real_block_num) {
		printf("failed to read misc key\n");
		return ATAP_RESULT_ERROR_BLOCK_READ;
	}

	/* read device id from buf*/
	uint32_t device_id_size = 0;
	uint8_t device_id[32] = {0};

	memcpy(&device_id_size, keybuf + 16, sizeof(uint32_t));
	if (device_id_size < 0 || device_id_size > sizeof(device_id)) {
		printf("invalidate device_id_size:%d\n", device_id_size);
		return ATAP_RESULT_ERROR_INVALID_DEVICE_ID;
	}

	memcpy(device_id, keybuf + 16 + sizeof(uint32_t), device_id_size);
	debug("device_id:%s\n", device_id);

	/* read algorithm from buf */
	uint8_t *key_buf = keybuf + 16 + sizeof(uint32_t) + device_id_size;
	uint32_t algorithm;

	copy_uint32_from_buf(&key_buf, &algorithm);
	debug("\n algorithm:%d\n", algorithm);

	/* read rsa private key */
	atap_blob key;

	if (copy_blob_from_buf(&key_buf, &key) == false) {
		printf("copy_blob_from_buf failed!\n");
		return ATAP_RESULT_ERROR_BUF_COPY;
	}
	/* write rsa private key to security storage*/
	write_key(KM_ALGORITHM_RSA, key.data, key.data_length);

	/* read rsa cert chain */
	atap_certchain certchain;

	if (copy_cert_chain_from_buf(&key_buf, &certchain) == false) {
		printf("copy_cert_chain_from_buf failed!\n");
		return ATAP_RESULT_ERROR_BUF_COPY;
	}

	/* write rsa cert chain size to security storage*/
	write_cert_chain_length(KM_ALGORITHM_RSA,
				(uint8_t) certchain.entry_count);

	/* write rsa cert chain data to security storage*/
	int i = 0;

	for (i = 0; i < certchain.entry_count; ++i) {
		write_cert(KM_ALGORITHM_RSA, certchain.entries[i].data,
			certchain.entries[i].data_length, i);
	}

	/* read ec algorithm */
	copy_uint32_from_buf(&key_buf, &algorithm);
	debug("\n algorithm:%d\n", algorithm);

	/* read ec private key */
	free_blob(key);
	if (copy_blob_from_buf(&key_buf, &key) == false) {
		printf("copy_blob_from_buf failed!\n");
		return ATAP_RESULT_ERROR_BUF_COPY;
	}

	/* write ec private key to security storage*/
	write_key(KM_ALGORITHM_EC, key.data, key.data_length);

	/* read ec cert chain */
	free_cert_chain(certchain);
	if (copy_cert_chain_from_buf(&key_buf, &certchain) == false) {
		printf("copy_cert_chain_from_buf failed!\n");
		return ATAP_RESULT_ERROR_BUF_COPY;
	}
	/* write ec cert chain size to security storage*/
	write_cert_chain_length(KM_ALGORITHM_EC,
					(uint8_t) certchain.entry_count);

	/* write ec cert chain to security storage*/
	for (i = 0; i < certchain.entry_count; ++i) {
		write_cert(KM_ALGORITHM_EC, certchain.entries[i].data,
			certchain.entries[i].data_length, i);
	}

	memset(keybuf, 0, sizeof(keybuf));

	/* wipe attestation data from misc*/
	if (blk_dwrite(dev_desc, key_offset, real_block_num, keybuf) != real_block_num) {
		printf("StorageWriteLba failed\n");
		return ATAP_RESULT_ERROR_BLOCK_WRITE;
	}

	return ATAP_RESULT_OK;
}
