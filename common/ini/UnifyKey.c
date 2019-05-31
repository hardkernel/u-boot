/*
 * Author:  Shoufu Zhao <shoufu.zhao@amlogic.com>
 */

#include "ini_config.h"

#define LOG_TAG "UnifyKey"
#define LOG_NDEBUG 0

#include "ini_log.h"

#include "UnifyKey.h"

#define CC_ONE_SECTION_SIZE                      (0x1000)

#if (defined (CC_INI_IO_USE_UNIFY_KEY))

#if (!defined (CC_INI_IO_UKEY_USE_OTHER_MODULE))

#if (defined(CC_COMPILE_IN_PC) || defined(CC_COMPILE_IN_ANDROID))

#if (defined CC_COMPILE_IN_PC)

#define CS_KEY_DATA_LIST_DEV_PATH                   "sys/class/unifykeys/list"
#define CS_KEY_DATA_NAME_DEV_PATH                   "sys/class/unifykeys/name"

static char gDevPath[256] = {0};
static int GetDevPath(char path_buf[]) {
    int tmp_len = 0;
    FILE *dev_fp = NULL;

    strcpy(path_buf, "sys/class/unifykeys/");
    dev_fp = fopen(CS_KEY_DATA_NAME_DEV_PATH, "r");
    if (dev_fp == NULL) {
        ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                CS_KEY_DATA_NAME_DEV_PATH, strerror(errno));
        return -1;
    }

    tmp_len = strlen(path_buf);
    fscanf(dev_fp, "%s", path_buf + tmp_len);

    fclose(dev_fp);
    dev_fp = NULL;

    return 0;
}

static const char *GetKeyDataWriteDevPath() {
    memset((void *)gDevPath, 0, 256);
    GetDevPath(gDevPath);
    return gDevPath;
}

static const char *GetKeyDataReadDevPath() {
    memset((void *)gDevPath, 0, 256);
    GetDevPath(gDevPath);
    return gDevPath;
}

#else

#define CS_KEY_DATA_LIST_DEV_PATH                   "/sys/class/unifykeys/list"
#define CS_KEY_DATA_NAME_DEV_PATH                   "/sys/class/unifykeys/name"

static const char *GetKeyDataWriteDevPath() {
    return "/sys/class/unifykeys/write";
}

static const char *GetKeyDataReadDevPath() {
    return "/sys/class/unifykeys/read";
}

#endif //CC_COMPILE_IN_PC

static int checkKeyNameInList(const char *key_name) {
    FILE *dev_fp = NULL;
    char *tmp_ptr = NULL;
    char lineStr[1024];

    dev_fp = fopen(CS_KEY_DATA_LIST_DEV_PATH, "r");
    if (dev_fp == NULL) {
        ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                CS_KEY_DATA_LIST_DEV_PATH, strerror(errno));
        return -1;
    }

    while (fgets(lineStr, 1024, dev_fp) != NULL) {
        tmp_ptr = strstr(lineStr, key_name);
        if (tmp_ptr != NULL) {
            break;
        }

        tmp_ptr = NULL;
    }

    fclose(dev_fp);
    dev_fp = NULL;

    if (tmp_ptr == NULL) {
        return -1;
    }

    return 0;
}

int readUKeyData_no_header(const char *key_name, unsigned char data_buf[], int rd_size) {
    int rd_cnt = 0;
    FILE *dev_fp = NULL;

    if (checkKeyNameInList(key_name) < 0) {
        ALOGE("%s, key \"%s\" isn't exist in unifykeys list\n", __FUNCTION__, key_name);
        return -1;
    }

    dev_fp = fopen(CS_KEY_DATA_NAME_DEV_PATH, "w");
    if (dev_fp == NULL) {
        ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                CS_KEY_DATA_NAME_DEV_PATH, strerror(errno));
        return -1;
    }

    fprintf(dev_fp, "%s", key_name);

    fclose(dev_fp);
    dev_fp = NULL;

    int mode = 1;

    if (mode == 0) {
        dev_fp = fopen(GetKeyDataReadDevPath(), "r");
        if (dev_fp == NULL) {
            ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                    GetKeyDataReadDevPath(), strerror(errno));
            return -1;
        }

        fscanf(dev_fp, "%s", data_buf);
        rd_cnt = strlen((char *) data_buf);
    } else {
        dev_fp = fopen(GetKeyDataReadDevPath(), "rb");
        if (dev_fp == NULL) {
            ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                    GetKeyDataReadDevPath(), strerror(errno));
            return -1;
        }

        rd_cnt = fread(data_buf, 1, CC_ONE_SECTION_SIZE, dev_fp);
    }

    fclose(dev_fp);
    dev_fp = NULL;

    return rd_cnt;
}

int readUKeyData(const char *key_name, unsigned char data_buf[], int rd_size) {
    int rd_cnt = 0;
    FILE *dev_fp = NULL;

    if (checkKeyNameInList(key_name) < 0) {
        ALOGE("%s, key \"%s\" isn't exist in unifykeys list\n", __FUNCTION__, key_name);
        return -1;
    }

    dev_fp = fopen(CS_KEY_DATA_NAME_DEV_PATH, "w");
    if (dev_fp == NULL) {
        ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                CS_KEY_DATA_NAME_DEV_PATH, strerror(errno));
        return -1;
    }

    fprintf(dev_fp, "%s", key_name);

    fclose(dev_fp);
    dev_fp = NULL;

    int mode = 1;

    if (mode == 0) {
        dev_fp = fopen(GetKeyDataReadDevPath(), "r");
        if (dev_fp == NULL) {
            ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                    GetKeyDataReadDevPath(), strerror(errno));
            return -1;
        }

        fscanf(dev_fp, "%s", data_buf);
        rd_cnt = strlen((char *) data_buf);
    } else {
        dev_fp = fopen(GetKeyDataReadDevPath(), "rb");
        if (dev_fp == NULL) {
            ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                    GetKeyDataReadDevPath(), strerror(errno));
            return -1;
        }

        rd_cnt = fread(data_buf, 1, CC_ONE_SECTION_SIZE, dev_fp);
    }

    fclose(dev_fp);
    dev_fp = NULL;

    return rd_cnt;
}

int writeUKeyData(const char *key_name, unsigned char data_buf[], int wr_size) {
    int wr_cnt = 0;
    int dev_fd = -1;
    FILE *dev_fp = NULL;

    if (checkKeyNameInList(key_name) < 0) {
        ALOGE("%s, key \"%s\" isn't exist in unifykeys list\n", __FUNCTION__, key_name);
        return -1;
    }

    dev_fp = fopen(CS_KEY_DATA_NAME_DEV_PATH, "w");
    if (dev_fp == NULL) {
        ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                CS_KEY_DATA_NAME_DEV_PATH, strerror(errno));
        return -1;
    }

    fprintf(dev_fp, "%s", key_name);

    fclose(dev_fp);
    dev_fp = NULL;

    dev_fd = open(GetKeyDataWriteDevPath(), O_WRONLY | O_SYNC | O_CREAT | O_TRUNC, S_IRWXU | S_IRWXG | S_IRWXO);

    if (dev_fd < 0) {
        ALOGE("%s, open %s ERROR(%s)!!\n", __FUNCTION__,
                GetKeyDataWriteDevPath(), strerror(errno));
        return -1;
    }

    wr_cnt = write(dev_fd, data_buf, wr_size);

    fsync(dev_fd);

    close(dev_fd);
    dev_fd = -1;

    return wr_cnt;
}

#elif (defined CC_COMPILE_IN_UBOOT)

#include "model.h"

#define CC_UKEY_RETRY_CNT_MAX   (5)

static int checkUnifyKey(const char *key_name) {
    int ret = 0, key_exist = 0, isSecure = 0;
    unsigned int key_len = 0;
    ssize_t key_size = 0;

    // start check the key is exist?
    ret = key_unify_query_exist(key_name, &key_exist);
    if (ret) {
        ALOGE("%s, %s query exist error.\n",__FUNCTION__, key_name);
        return -1;
    }
    if (key_exist == 0) {
        ALOGE("%s, %s is not exist.\n",__FUNCTION__, key_name);
        return -1;
    }
    // end check the key is exist?

    // start check the key is secure?
    ret = key_unify_query_secure(key_name, &isSecure);
    if (ret) {
        ALOGE("%s, %s query secure error\n",__FUNCTION__, key_name);
        return -1;
    }
    if (isSecure) {
        ALOGE("%s, %s is secure key\n",__FUNCTION__, key_name);
        return -1;
    }
    // end check the key is secure?

    // start read and check data integrity
    ret = key_unify_query_size(key_name, &key_size);
    if (ret) {
        ALOGE("%s, %s query size error\n",__FUNCTION__, key_name);
        return -1;
    }
    //ALOGD("%s, %s size: %d\n",__FUNCTION__, key_name, (int)key_size);

    key_len = (int)key_size;
    //ALOGD("%s, %s size: %d\n",__FUNCTION__, key_name, key_len);

    return key_len;
}

int readUKeyData_no_header(const char *key_name, unsigned char data_buf[], int rd_size) {
    int ret = 0, key_len = 0;

    key_len = checkUnifyKey(key_name);
    if (key_len < 0) {
        return -1;
    } else if (key_len == 0) {
        ALOGE("%s, %s size is zero\n",__FUNCTION__, key_name);
        return -1;
    } else if (key_len > rd_size) {
        ALOGE("%s, %s key len is larger than rd size.\n",__FUNCTION__, key_name);
        return -1;
    }

    ret = key_unify_read(key_name, data_buf, key_len);
    if (ret) {
        ALOGE("%s, %s unify read error\n",__FUNCTION__, key_name);
        return -1;
    }

    return key_len;
}

int readUKeyData(const char *key_name, unsigned char data_buf[], int rd_size) {
    int i = 0, ret = 0, key_len = 0, retry_cnt = 0, tmp_content_type = 0;
    unsigned int key_crc = 0, key_crc32 = 0, tmp_len = 0, tmp_crc = 0;
    struct all_info_header_s *pHeadPtr = NULL;

    key_len = checkUnifyKey(key_name);
    if (key_len < 0) {
        return -1;
    } else if (key_len == 0) {
        ALOGE("%s, %s size is zero\n",__FUNCTION__, key_name);
        return -1;
    } else if (key_len > rd_size) {
        ALOGE("%s, %s key len is larger than rd size.\n",__FUNCTION__, key_name);
        return -1;
    }

unifykey_read:
    ret = key_unify_read(key_name, data_buf, key_len);
    if (ret) {
        ALOGE("%s, %s unify read error\n",__FUNCTION__, key_name);
        return -1;
    }

    //judge unfikey data type, default is binary data
    tmp_content_type = 0;
    for (i = 0; i < 14; i++) {
        if (i < 8 || (i > 9 && i < 13)) {
            if (!isxdigit(data_buf[i])) {
                break;
            }
        } else if (i == 8 || i == 13) {
            if (data_buf[i] != ',') {
                break;
            }
        } else if (i == 9) {
            if (data_buf[i] != 'V' && data_buf[i] != 'v') {
                break;
            }
        }
    }

    if (i == 14) {
        tmp_content_type = 1;
    }

    tmp_crc = 0;
    tmp_len = 0;
    if (tmp_content_type == 0) {
        pHeadPtr = (struct all_info_header_s *)(data_buf);
        tmp_crc = pHeadPtr->crc32;
        tmp_len = pHeadPtr->data_len;
    } else {
        return key_len;
    }

    if (key_len != tmp_len) {
        ALOGE("%s, %s data_len %d is not match key_len %d\n",__FUNCTION__,
            key_name, tmp_len, key_len);
        if (retry_cnt < CC_UKEY_RETRY_CNT_MAX) {
            retry_cnt++;
            goto unifykey_read;
        } else {
            ALOGE("%s, %s load unifykey failed\n",__FUNCTION__, key_name);
            return -1;
        }
    }

    key_crc = crc32(0, &data_buf[4], (key_len - 4)); //except crc32
    key_crc32 = (unsigned int)key_crc;
    if (key_crc32 != tmp_crc) {
        ALOGE("%s, %s crc32 0x%08x is not match 0x%08x\n",__FUNCTION__,
            key_name, tmp_crc, key_crc32);
        if (retry_cnt < CC_UKEY_RETRY_CNT_MAX) {
            retry_cnt++;
            goto unifykey_read;
        } else {
            ALOGE("%s, %s load unifykey failed\n",__FUNCTION__, key_name);
            return -1;
        }
    }
    // end read and check data integrity

    return key_len;
}

int writeUKeyData(const char *key_name, unsigned char data_buf[], int wr_size) {
    // if the key is not burn data, the fucntion will return fail
    // now we disable the unifykey check function.
/*
    int key_len = 0;

    key_len = checkUnifyKey(key_name);
    if (key_len < 0) {
        return -1;
    }
*/
    if (key_unify_write(key_name, data_buf, wr_size) == 0) {
        return wr_size;
    }
    return -1;
}

#endif

#endif

#if (defined CC_UBOOT_RW_SIMULATE)

#include "ini_io.h"

unsigned int crc32(unsigned int crc, const unsigned char *ptr, int buf_len) {
    return CalCRC32(crc, ptr, buf_len);
}

static unsigned char gTempBuf[0x400000];

int key_unify_write(const char* keyname, const void* keydata, const unsigned datalen) {
    int tmp_ret = 0;

    tmp_ret = writeUKeyData(keyname, (unsigned char *)keydata, datalen);
    if (tmp_ret != datalen) {
        return -1;
    }
    return 0;
}

int key_unify_read(const char* keyname, void* keydata, const unsigned bufLen) {
    if (readUKeyData(keyname, (unsigned char *)keydata, CC_ONE_SECTION_SIZE) <= 0) {
        return -1;
    }

    return 0;
}

int key_unify_query_size(const char* keyname, ssize_t *keysize) {
    int rd_size = 0;

    rd_size = readUKeyData(keyname, gTempBuf, CC_ONE_SECTION_SIZE);
    if (rd_size > 0) {
        *keysize = rd_size;
        return 0;
    }

    return -1;
}

int key_unify_query_exist(const char* keyname, int *exist) {
    if (checkKeyNameInList(keyname) < 0) {
        ALOGE("%s, key \"%s\" isn't exist in unifykeys list\n", __FUNCTION__, keyname);
        *exist = 0;
        return -1;
    }

    *exist = 1;
    return 0;
}

int key_unify_query_secure(const char* keyname, int *isSecure) {
    *isSecure = 0;
    return 0;
}

#endif

#endif //CC_INI_IO_UKEY_USE_OTHER_MODULE
