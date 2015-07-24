/*
 * \file        keymanage.h
 * \brief       API from drivers/keymange
 *
 * \version     1.0.0
 * \date        15/07/7
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2015 Amlogic. All Rights Reserved.
 *
 */
#ifndef __KEYUNIFY_H__
#define __KEYUNIFY_H__

//APIs of key_unify*: unify interfaces for nandkeys/emmckeys/efuse keys

int key_unify_init(const char* seednum, const char* dtbaddr);

int key_unify_uninit(void);

//keyType: user type to define how to parse/check the key value before burn to target
int key_unify_write(const char* keyname, const void* keydata, const unsigned datalen);

int key_unify_read(const char* keyname, void* keydata, const unsigned bufLen);

int key_unify_query_size(const char* keyname, ssize_t* keysize);

int key_unify_query_exist(const char* keyname, int* exist);

int key_unify_query_secure(const char* keyname, int* isSecure);

int key_unify_query_canOverWrite(const char* keyname, int* canOverWrite);

//Does the key configured in dts
int key_unify_query_key_has_configure(const char* keyname);

//Another APIs with APP concers, like special flower hdcp2
//These APIs are based on key_unify_*
//
int key_manage_init(const char* seednum, const char* dtbaddr);
int key_manage_exit(void);

int key_manage_write(const char* keyname, const void* keydata, const unsigned datalen);

int key_manage_read(const char* keyname, void* keydata, const unsigned bufLen);

int key_manage_query_size(const char* keyname, ssize_t* keysize);

int key_manage_query_exist(const char* keyname, int* exist);

int key_manage_query_secure(const char* keyname, int* isSecure);

int key_manage_query_canOverWrite(const char* keyname, int* canOverWrite);

#endif// #ifndef __KEYUNIFY_H__

