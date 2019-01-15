#ifndef __UNIFYKEY_H__
#define __UNIFYKEY_H__

#include "ini_config.h"

#ifdef __cplusplus
extern "C" {
#endif

int readUKeyData_no_header(const char *key_name, unsigned char data_buf[], int rd_size);
int readUKeyData(const char *key_name, unsigned char data_buf[], int rd_size);
int writeUKeyData(const char *key_name, unsigned char data_buf[], int wr_size);

#if (defined CC_UBOOT_RW_SIMULATE)

unsigned int crc32(unsigned int crc, const unsigned char *ptr, int buf_len);
int key_unify_write(const char* keyname, const void* keydata, const unsigned datalen);
int key_unify_read(const char* keyname, void* keydata, const unsigned bufLen);
int key_unify_query_size(const char* keyname, ssize_t* keysize);
int key_unify_query_exist(const char* keyname, int *exist);
int key_unify_query_secure(const char* keyname, int *isSecure);

#endif

#ifdef __cplusplus
}
#endif

#endif //__UNIFYKEY_H__
