/*
 * Author:  Shoufu Zhao <shoufu.zhao@amlogic.com>
 */

#include "ini_config.h"

#define LOG_TAG "ini_io"
#define LOG_NDEBUG 0

#include "ini_log.h"
#include "ini_platform.h"
#include "ini_io.h"

#if (defined (CC_INI_IO_USE_UNIFY_KEY))
    #if (!defined (CC_INI_IO_UKEY_USE_OTHER_MODULE))
        #include "UnifyKey.h"

        #define HanldeReadData    readUKeyData
        #define HandleWriteData   writeUKeyData
    #else
        #include <tvutils/tvutils.h>

        #define HanldeReadData    readUnifyKeyData
        #define HandleWriteData   writeUnifyKeyData
    #endif
#endif

static int ReadBinData(const char *item_name, unsigned char data_buf[]) {
    return readUKeyData_no_header(item_name, data_buf, CC_ONE_SECTION_SIZE);
}

static int WriteBinData(const char *item_name, int wr_size, unsigned char data_buf[]) {
    return HandleWriteData(item_name, data_buf, wr_size);
}

static int ReadIniData(const char *item_name, unsigned char data_buf[]) {
    return HanldeReadData(item_name, data_buf, CC_ONE_SECTION_SIZE);
}

static int WriteIniData(const char *item_name, int wr_size, unsigned char data_buf[]) {
    return HandleWriteData(item_name, data_buf, wr_size);
}

static int ReadStringData(const char *item_name, int mode, char data_buf[]) {
    int rd_size = 0, skip_len = 0;
    unsigned char *tmp_buf = NULL;

    if (data_buf == NULL) {
        return -1;
    }

    tmp_buf = (unsigned char *) malloc(CC_MAX_DATA_SIZE);
    if (tmp_buf == NULL) {
        ALOGE("%s, malloc buffer memory error!!!\n", __FUNCTION__);
        return -1;
    }

    memset((void *)tmp_buf, 0, CC_MAX_DATA_SIZE);
    rd_size = ReadIniData(item_name, tmp_buf);
    if (check_string_data_have_header_valid(NULL, (char *)tmp_buf, CC_HEAD_CHKSUM_LEN, CC_VERSION_LEN) < 0) {
        data_buf[0] = '\0';

        free(tmp_buf);
        tmp_buf = NULL;
        return 0;
    }

    if (mode == 0) {
        skip_len = CC_HEAD_CHKSUM_LEN + CC_VERSION_LEN;
    } else {
        skip_len = 0;
    }

    strncpy(data_buf, (char *)tmp_buf + skip_len, rd_size - skip_len);

    free(tmp_buf);
    tmp_buf = NULL;

    return rd_size;
}

static int SaveStringData(const char *item_name, int mode, char data_buf[]) {
    int tmp_ret = 0, data_len = 0;
    unsigned int tmp_crc32 = 0;
    char *buf_ptr = NULL;
    char *tmp_buf = NULL;
    char *tmp_ch_buf = NULL;

    if (data_buf == NULL) {
        return -1;
    }

    tmp_buf = (char *) malloc(CC_MAX_DATA_SIZE);
    if (tmp_buf == NULL) {
        ALOGE("%s, malloc buffer memory error!!!\n", __FUNCTION__);
        return -1;
    }

    tmp_ch_buf = (char *) malloc(CC_MAX_DATA_SIZE);
    if (tmp_ch_buf == NULL) {
        free(tmp_buf);
        tmp_buf = NULL;

        ALOGE("%s, malloc buffer memory error!!!\n", __FUNCTION__);
        return -1;
    }

    memset((void *)tmp_buf, 0, CC_MAX_DATA_SIZE);

    if (mode == 0) {
        strcpy(tmp_ch_buf, "V001,");
        strcat(tmp_ch_buf, data_buf);

        buf_ptr = tmp_ch_buf;
    } else {
        buf_ptr = data_buf;
    }

    tmp_crc32 = CalCRC32(0, (unsigned char *)buf_ptr, strlen(buf_ptr));
    sprintf(tmp_buf, "%08x,%s", tmp_crc32, buf_ptr);

    data_len = strlen(tmp_buf) + 1;
    tmp_ret = WriteIniData(item_name, data_len, (unsigned char *)tmp_buf);
    if (tmp_ret != data_len) {
        ALOGE("%s, write data error (0x%08X, 0x%08X)\n", __FUNCTION__, tmp_ret, data_len);

        free(tmp_ch_buf);
        tmp_ch_buf = NULL;

        free(tmp_buf);
        tmp_buf = NULL;

        return -1;
    }

    free(tmp_ch_buf);
    tmp_ch_buf = NULL;

    free(tmp_buf);
    tmp_buf = NULL;

    return tmp_ret;
}

int check_hex_data_no_header_valid(unsigned int* tmp_crc32, int max_len, int buf_len, unsigned char data_buf[]) {
    unsigned int cal_crc32 = 0;

    if (tmp_crc32 != NULL) {
        *tmp_crc32 = 0;
    }

    if (buf_len >= max_len) {
        ALOGE("%s, buf_len error (0x%x, 0x%x)\n", __FUNCTION__, max_len, buf_len);
        return -1;
    }
    //ALOGD("%s, data len ok(0x%x, 0x%x)\n", __FUNCTION__, data_len, buf_len);

    cal_crc32 = CalCRC32(0, data_buf, buf_len);

    if (tmp_crc32 != NULL) {
        *tmp_crc32 = cal_crc32;
    }

    return 0;
}

int check_hex_data_have_header_valid(unsigned int* tmp_crc32, int max_len, int buf_len, unsigned char data_buf[]) {
    unsigned int rd_crc32 = 0, cal_crc32 = 0;
    unsigned short data_len = 0;

    if (tmp_crc32 != NULL) {
        *tmp_crc32 = 0;
    }

    memcpy((void *)&data_len, (void *)(data_buf + 4), 2);
    if (data_len < 4 || data_len >= max_len || data_len != buf_len) {
        ALOGE("%s, rd data len error (0x%x, 0x%x)\n", __FUNCTION__, data_len, buf_len);
        return -1;
    }
    //ALOGD("%s, data len ok(0x%x, 0x%x)\n", __FUNCTION__, data_len, buf_len);

    memcpy((void *)&rd_crc32, (void *)data_buf, 4);
    cal_crc32 = CalCRC32(0, (data_buf + 4), data_len - 4);

    if (rd_crc32 != cal_crc32) {
        ALOGE("%s, data invalid (0x%08X, 0x%08X)\n", __FUNCTION__, rd_crc32, cal_crc32);
        return -1;
    }

    if (tmp_crc32 != NULL) {
        *tmp_crc32 = cal_crc32;
    }

    //ALOGD("%s, data check ok (0x%08X, 0x%08X)\n", __FUNCTION__, rd_crc32, cal_crc32);
    return 0;
}

int check_string_data_have_header_valid(unsigned int* tmp_crc32, char *data_str, int chksum_head_len, int ver_len) {
    int tmp_len = 0, tmp_ver = 0;
    char *endp = NULL;
    unsigned long src_chksum = 0, cal_chksum = 0;
    char tmp_buf[129] = { 0 };

    if (data_str != NULL) {
        if (tmp_crc32 != NULL) {
            *tmp_crc32 = 0;
        }

        tmp_len = strlen(data_str);
        if (tmp_len > chksum_head_len + ver_len) {
            cal_chksum = CalCRC32(0, (unsigned char *)(data_str + chksum_head_len), tmp_len - chksum_head_len);
            memcpy(tmp_buf, data_str, chksum_head_len);
            tmp_buf[chksum_head_len] = 0;
            src_chksum = strtoul(tmp_buf, &endp, 16);
            if (cal_chksum == src_chksum) {
                memcpy(tmp_buf, data_str + chksum_head_len, ver_len);
                if ((tmp_buf[0] == 'v' || tmp_buf[0] == 'V') && isxdigit(tmp_buf[1]) && isxdigit(tmp_buf[2]) && isxdigit(tmp_buf[3])) {
                    tmp_ver = strtoul(tmp_buf + 1, &endp, 16);
                    if (tmp_ver <= 0) {
                        ALOGE("%s, data version error!!!\n", __FUNCTION__);
                        return -1;
                    }
                } else {
                    ALOGD("%s, data version error!!!\n", __FUNCTION__);
                    return -1;
                }

                if (tmp_crc32 != NULL) {
                    *tmp_crc32 = cal_chksum;
                }
                //ALOGD("%s, data check ok\n", __FUNCTION__);
                return tmp_ver;
            } else {
                ALOGD("%s, cal_chksum = %x\n", __FUNCTION__, (unsigned int)cal_chksum);
                ALOGD("%s, src_chksum = %x\n", __FUNCTION__, (unsigned int)src_chksum);
            }
        }

        ALOGE("%s, data error!!!\n", __FUNCTION__);
        return -1;
    }

    ALOGE("%s, data is NULL!!!\n", __FUNCTION__);
    return -1;
}

int ReadLCDParam(unsigned char data_buf[]) {
    int rd_size = 0;

    if (data_buf == NULL) {
        return -1;
    }

    rd_size = ReadIniData(CS_LCD_ITEM_NAME, data_buf);

    return rd_size;
}

int SaveLCDParam(int wr_size, unsigned char data_buf[]) {
    int tmp_ret = 0;

    if (data_buf == NULL) {
        return -1;
    }

    tmp_ret = WriteIniData(CS_LCD_ITEM_NAME, wr_size, data_buf);
    if (tmp_ret != wr_size) {
        return -1;
    }

    return tmp_ret;
}

int ReadLCDExternParam(unsigned char data_buf[]) {
    int rd_size = 0;

    if (data_buf == NULL) {
        return -1;
    }

    rd_size = ReadIniData(CS_LCD_EXT_ITEM_NAME, data_buf);

    return rd_size;
}

int SaveLCDExternParam(int wr_size, unsigned char data_buf[]) {
    int tmp_ret = 0;

    if (data_buf == NULL) {
        return -1;
    }

    tmp_ret = WriteIniData(CS_LCD_EXT_ITEM_NAME, wr_size, data_buf);
    if (tmp_ret != wr_size) {
        return -1;
    }

    return tmp_ret;
}

int ReadBackLightParam(unsigned char data_buf[]) {
    int rd_size = 0;

    if (data_buf == NULL) {
        return -1;
    }

    rd_size = ReadIniData(CS_BACKLIGHT_ITEM_NAME, data_buf);

    return rd_size;
}

int SaveBackLightParam(int wr_size, unsigned char data_buf[]) {
    int tmp_ret = 0;

    if (data_buf == NULL) {
        return -1;
    }

    tmp_ret = WriteIniData(CS_BACKLIGHT_ITEM_NAME, wr_size, data_buf);
    if (tmp_ret != wr_size) {
        return -1;
    }

    return tmp_ret;
}

int ReadTconBinParam(unsigned char data_buf[]) {
    int rd_size = 0;

    if (data_buf == NULL) {
        return -1;
    }

    rd_size = ReadBinData(CS_LCD_TCON_ITEM_NAME, data_buf);

    return rd_size;
}

int SaveTconBinParam(int wr_size, unsigned char data_buf[]) {
    int tmp_ret = 0;

    if (data_buf == NULL) {
        return -1;
    }

    tmp_ret = WriteBinData(CS_LCD_TCON_ITEM_NAME, wr_size, data_buf);
    if (tmp_ret != wr_size) {
        return -1;
    }

    return tmp_ret;
}

int ReadPanelIniName(char data_buf[]) {
    return ReadStringData(CS_PANEL_INI_PATH_ITEM_NAME, 0, data_buf);
}

int SavePanelIniName(char data_buf[]) {
    return SaveStringData(CS_PANEL_INI_PATH_ITEM_NAME, 0, data_buf);
}

int ReadPanelPQPath(char data_buf[]) {
    return ReadStringData(CS_PANEL_PQ_PATH_ITEM_NAME, 0, data_buf);
}

int SavePanelPQPath(char data_buf[]) {
    return SaveStringData(CS_PANEL_PQ_PATH_ITEM_NAME, 0, data_buf);
}

int ReadPanelAllInfoData(unsigned char data_buf[]) {
    int rd_size = 0;

    if (data_buf == NULL) {
        return -1;
    }

    rd_size = ReadIniData(CS_PANEL_ALL_INFO_ITEM_NAME, data_buf);

    return rd_size;
}

int SavePanelAllInfoData(int wr_size, unsigned char data_buf[]) {
    int tmp_ret = 0;

    if (data_buf == NULL) {
        return -1;
    }

    tmp_ret = WriteIniData(CS_PANEL_ALL_INFO_ITEM_NAME, wr_size, data_buf);
    if (tmp_ret != wr_size) {
        return -1;
    }

    return tmp_ret;
}

int ReadPanelAllData(int sec_no, unsigned char data_buf[]) {
    int rd_size = 0;
    char tmp_buf[128];

    if (data_buf == NULL) {
        return -1;
    }

    sprintf(tmp_buf, "%s_d%d", CS_PANEL_ALL_DATA_ITEM_NAME, sec_no);

    rd_size = ReadIniData(tmp_buf, data_buf);

    return rd_size;
}

int SavePanelAllData(int sec_no, int wr_size, unsigned char data_buf[]) {
    int tmp_ret = 0;
    char tmp_buf[128];

    if (data_buf == NULL) {
        return -1;
    }

    sprintf(tmp_buf, "%s_d%d", CS_PANEL_ALL_DATA_ITEM_NAME, sec_no);

    tmp_ret = WriteIniData(tmp_buf, wr_size, data_buf);
    if (tmp_ret != wr_size) {
        return -1;
    }

    return tmp_ret;
}

void PrintDataBuf(int data_cnt, unsigned char data_buf[]) {
    int i = 0;

    for (i = 0; i < data_cnt; i++) {
        ALOGD("%s, data_buf[%d] = 0x%02x\n", __FUNCTION__, i, data_buf[i]);
    }

    ALOGD("%s, \n\n\n\n", __FUNCTION__);
}

unsigned int CalCRC32(unsigned int crc, const unsigned char *ptr, int buf_len) {
    static const unsigned int s_crc32[16] = {
        0, 0x1db71064, 0x3b6e20c8, 0x26d930ac, 0x76dc4190, 0x6b6b51f4, 0x4db26158, 0x5005713c,
        0xedb88320, 0xf00f9344, 0xd6d6a3e8, 0xcb61b38c, 0x9b64c2b0, 0x86d3d2d4, 0xa00ae278, 0xbdbdf21c };

    unsigned int crcu32 = crc;
    if (buf_len < 0) {
        return 0;
    }

    if (!ptr) {
        return 0;
    }

    crcu32 = ~crcu32;
    while (buf_len--) {
        unsigned char b = *ptr++;
        crcu32 = (crcu32 >> 4) ^ s_crc32[(crcu32 & 0xF) ^ (b & 0xF)];
        crcu32 = (crcu32 >> 4) ^ s_crc32[(crcu32 & 0xF) ^ (b >> 4)];
    }

    return ~crcu32;
}
