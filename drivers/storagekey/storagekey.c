/*
 * drivers/storagekey/storagekey.c
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

/* extern from bl31 */
/*
 * when RET_OK
 * query: retval=1: key exsit,=0: key not exsit；
 * tell: retvak = key size
 * status: retval=1: secure, retval=0: non-secure

 */

#include <common.h>
#include <linux/types.h>
#include <amlogic/secure_storage.h>
#include <amlogic/storage_if.h>
#include <amlogic/amlkey_if.h>
#ifdef CONFIG_STORE_COMPATIBLE
#include <partition_table.h>
#endif

/* key buffer status */
/* bit0, dirty flag*/
#define KEYBUFFER_CLEAN		(0 << 0)
#define KEYBUFFER_DIRTY		(1 << 0)
#define SECUESTORAGE_HEAD_SIZE		(256)
#define SECUESTORAGE_WHOLE_SIZE		(0x40000)

struct storagekey_info_t {
	uint8_t * buffer;
	uint32_t size;
	uint32_t status;
};

static struct storagekey_info_t storagekey_info = {
	.buffer = NULL,
	/* default size */
	.size = SECUESTORAGE_WHOLE_SIZE,
	.status = KEYBUFFER_CLEAN,
};

/**
 *1.init
 * return ok 0, fail 1
 */
int32_t amlkey_init(uint8_t *seed, uint32_t len)
{
	int32_t ret = 0;
	uint32_t buffer_size;

	/* do nothing for now*/
	printf("%s() enter!\n", __func__);
	if (storagekey_info.buffer != NULL) {
		printf("%s() %d: already init!\n", __func__, __LINE__);
		goto _out;
	}

	/* get buffer from bl31 */
	storagekey_info.buffer = secure_storage_getbuffer(&buffer_size);
	if (storagekey_info.buffer == NULL) {
		printf("%s() %d: can't get buffer from bl31!\n",
				__func__, __LINE__);
		ret = -1;
		goto _out;
	}
	if (buffer_size != storagekey_info.size) {
		printf("%s() %d: warnning! %d/%d\n",
			__func__, __LINE__, buffer_size, storagekey_info.size);
		/* using innor size!*/
		storagekey_info.size = buffer_size;
	}

	/* full fill key infos from storage. */
	ret = store_key_read(storagekey_info.buffer,  storagekey_info.size);
	if (ret) {
		/* memset head info for bl31 */
		memset(storagekey_info.buffer, 0, SECUESTORAGE_HEAD_SIZE);
		ret = 0;
		goto _out;
	}
	secure_storage_notifier();
#ifdef CONFIG_STORE_COMPATIBLE
	info_disprotect &= ~DISPROTECT_KEY;  //protect
#endif
_out:
	return ret;
}

/**
 *2. query if the key already programmed
 * return: exsit 1, non 0
 */
int32_t amlkey_isexsit(const uint8_t * name)
{
	int32_t ret = 0;
	uint32_t retval;

	if ( NULL == name ) {
		printf("%s() %d, invalid key ", __func__, __LINE__);
		return 0;
	}

	ret = secure_storage_query((uint8_t *)name, &retval);
	if (ret) {
		printf("%s() %d: ret %d\n", __func__, __LINE__, ret);
		retval = 0;
	}

	return (int32_t)retval;
}

static int32_t amlkey_get_attr(const uint8_t * name)
{
	int32_t ret = 0;
	uint32_t retval;

	if ( NULL == name ) {
		printf("%s() %d, invalid key ", __func__, __LINE__);
		return 0;
	}

	ret = secure_storage_status((uint8_t *)name, &retval);
	if (ret) {
		printf("%s() %d: ret %d\n", __func__, __LINE__, ret);
		retval = 0;
	}

	return (int32_t)(retval);
}

/**
 * 3.1 query if the prgrammed key is secure. key must exsit!
 * return secure 1, non 0;
 */
int32_t amlkey_issecure(const uint8_t * name)
{
	return (amlkey_get_attr(name)&UNIFYKEY_ATTR_SECURE_MASK);
}

/**
 * 3.2 query if the prgrammed key is encrypt
 * return encrypt 1, non-encrypt 0;
 */
int32_t amlkey_isencrypt(const uint8_t * name)
{
	return (amlkey_get_attr(name)&UNIFYKEY_ATTR_ENCRYPT_MASK);
}
/**
 * 4. actual bytes of key value
 *  return actual size.
 */
ssize_t amlkey_size(const uint8_t *name)
{
	ssize_t size = 0;
	int32_t ret = 0;
	uint32_t retval;

	if ( NULL == name ) {
		printf("%s() %d, invalid key ", __func__, __LINE__);
		return 0;
	}

	ret = secure_storage_tell((uint8_t *)name, &retval);
	if (ret) {
		printf("%s() %d: ret %d\n", __func__, __LINE__, ret);
		retval = 0;
	}
	size = (ssize_t)retval;
	return size;
}

/**
 *5. read non-secure key in bytes, return bytes readback actully.
 * return actual size read back.
 */
ssize_t amlkey_read(const uint8_t *name, uint8_t *buffer, uint32_t len)
{
	int32_t ret = 0;
	ssize_t retval = 0;
	uint32_t actul_len;

	if ( NULL == name ) {
		printf("%s() %d, invalid key ", __func__, __LINE__);
		return 0;
	}
	ret = secure_storage_read((uint8_t *)name, buffer, len, &actul_len);
	if (ret) {
		printf("%s() %d: return %d\n", __func__, __LINE__, ret);
		retval = 0;
		goto _out;
	}
	retval = actul_len;
_out:
	return retval;
}

/**
 * 6.write secure/non-secure key in bytes , return bytes readback actully
 * attr: bit0, secure/non-secure;
 *		 bit8, encrypt/non-encrypt;
 * return actual size write down.
 */
ssize_t amlkey_write(const uint8_t *name, uint8_t *buffer, uint32_t len, uint32_t attr)
{
	int32_t ret = 0;
	ssize_t retval = 0;

	if ( NULL == name ) {
		printf("%s() %d, invalid key ", __func__, __LINE__);
		return retval;
	}
	ret = secure_storage_write((uint8_t *)name, buffer, len, attr);
	if (ret) {
		printf("%s() %d: return %d\n", __func__, __LINE__, ret);
		retval = 0;
		goto _out;
	} else {
		retval = (ssize_t)len;
		/* write down! */
		if (storagekey_info.buffer != NULL) {
			ret = store_key_write(storagekey_info.buffer, storagekey_info.size);
			if (ret) {
				printf("%s() %d, store_key_write fail\n", __func__, __LINE__);
				retval = 0;
			}
		}
	}
_out:
	return retval;
}
/**
 * 7. get the hash value of programmed secure key | 32bytes length, sha256
 * return success 0, fail -1
 */
int32_t amlkey_hash_4_secure(const uint8_t * name, uint8_t * hash)
{
	int32_t ret = 0;

	ret = secure_storage_verify((uint8_t *)name, hash);

	return ret;
}

/**
 * 7. del key by name
 * return success 0, fail -1
 */
int32_t amlkey_del(const uint8_t * name)
{
	int32_t ret = 0;

	ret = secure_storage_remove((uint8_t *)name);
	if ((ret == 0) && (storagekey_info.buffer != NULL)) {
		/* flush back */
		ret = store_key_write(storagekey_info.buffer, storagekey_info.size);
		if (ret) {
			printf("%s() %d, store_key_write fail\n", __func__, __LINE__);
		}
	} else {
		printf("%s() %d, remove key fail\n", __func__, __LINE__);
	}

	return ret;
}

