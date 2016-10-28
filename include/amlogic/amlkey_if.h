/*
 * \file        amlkey_if.h
 * \brief       APIs of secure key for users
 *
 * \version     1.0.0
 * \date        15/07/10
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2015 Amlogic. All Rights Reserved.
 *
 */
#ifndef __AMLKEY_IF_H__
#define __AMLKEY_IF_H__

#define AMLKEY_NAME_LEN_MAX     (80)
//1.init
int32_t amlkey_init(uint8_t *seed, uint32_t len, int encrypt_type);

//2. query if the key already programmed, exsit 1, non 0
int32_t amlkey_isexsit(const uint8_t * name);

//3. query attr, key must exsit before those functions were called.
	//3.1 whether the prgrammed key is secure, secure 1, non 0
int32_t amlkey_issecure(const uint8_t * name);
	//3.2 whether the prgrammed key is encrypt, encrypt 1, non 0
int32_t amlkey_isencrypt(const uint8_t * name);

//4. actual bytes of key value
ssize_t amlkey_size(const uint8_t *name);

//5. read non-secure key in bytes, return byets readback actully.
ssize_t amlkey_read(const uint8_t *name, uint8_t *buffer, uint32_t len)	;

//6.write key with attribute in bytes , return byets readback actully
	//attr: bit0: secure/non-secure;
	//		bit8: encrypt/non-encrypt
#define UNIFYKEY_ATTR_SECURE_MASK	(1<<0)
#define UNIFYKEY_ATTR_ENCRYPT_MASK	(1<<8)
ssize_t amlkey_write(const uint8_t *name, uint8_t *buffer, uint32_t len, uint32_t attr);

//7. get the hash value of programmed secure key | 32bytes length, sha256
int32_t amlkey_hash_4_secure(const uint8_t * name, uint8_t * hash);

#endif// #ifndef __AMLKEY_IF_H__

