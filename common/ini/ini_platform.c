/*
 * Author:  Shoufu Zhao <shoufu.zhao@amlogic.com>
 */

#include "ini_config.h"

#define LOG_TAG "ini_platform"
#define LOG_NDEBUG 0

#include "ini_log.h"

#include "ini_handler.h"
#include "ini_platform.h"

//c basic lib
char* plat_strtok_r(char *str, const char *delim, char **saveptr) {
#if (defined CC_COMPILE_IN_PC || defined CC_COMPILE_IN_ANDROID)
    return strtok_r(str, delim, saveptr);
#elif (defined CC_COMPILE_IN_UBOOT)
    return strtok(str, delim);
#endif
}

//File functions
#if (defined CC_COMPILE_IN_UBOOT)
static int splitFilePath(const char *file_path, char part_name[], char file_name[], const char *ext_name) {
    int i = 0;
    char *tmp_start_ptr = NULL;
    char *tmp_end_ptr = NULL;

    if (file_path == NULL) {
        ALOGE("%s, file_path is NULL!!!\n", __FUNCTION__);
        return -1;
    }

    tmp_start_ptr = strchr((char*)file_path,'/');
    if (tmp_start_ptr != file_path) {
        ALOGE("%s, we need one abstract file path!!!  %s.\n", __FUNCTION__, file_path);
        return -1;
    }

    tmp_end_ptr = strchr(tmp_start_ptr + 1,'/');
    if (tmp_end_ptr == NULL) {
        ALOGE("%s, there is only partition name in the path!!!\n", __FUNCTION__);
        return -1;
    }

    strncpy(part_name, tmp_start_ptr + 1, tmp_end_ptr - tmp_start_ptr - 1);
    part_name[tmp_end_ptr - tmp_start_ptr - 1] = '\0';
    //ALOGD("%s, partition name is %s\n", __FUNCTION__, part_name);

    tmp_start_ptr = tmp_end_ptr;

    i = 0;
    while (*tmp_end_ptr && i < CC_MAX_INI_FILE_NAME_LEN) {
        tmp_end_ptr++;
        i++;
    }
    if (i >= CC_MAX_INI_FILE_NAME_LEN) {
        ALOGE("%s, file path is too long (%d)!!!\n", __FUNCTION__, i);
        return -1;
    }

    strncpy(file_name, tmp_start_ptr, i);
    file_name[i] = '\0';
    //ALOGD("%s, file name is %s\n", __FUNCTION__, file_name);

    if (ext_name != NULL) {
        if (strlen(ext_name) > 0) {
            while (tmp_end_ptr != tmp_start_ptr && *tmp_end_ptr != '.') {
                tmp_end_ptr--;
            }

            if (*tmp_end_ptr != '.') {
                ALOGE("%s, the file path \"%s\" doesn't have ext name!!!\n", __FUNCTION__, file_path);
                return -1;
            } else {
                if (strncmp(tmp_end_ptr + 1, ext_name, 128)) {
                    ALOGE("%s, the ext name of file path \"%s\" not equal to the special ext name \"%s\"!!!\n", __FUNCTION__, file_path, ext_name);
                    return -1;
                }
            }
        }
    }

    return 0;
}

#define CS_BLCOK_DEV_INTERFACE    "mmc"
#define CS_BLCOK_DEV_MARJOR_NUM   "1"

static int setBlockDevice(const char *part_name) {
    int part_no = 0;
    char part_buf[128] = {0};
    char tmp_buf[128] = {0};

    part_no = get_partition_num_by_name((char *)part_name);
    //ALOGD("%s, part_no is %d\n", __FUNCTION__, part_no);
    if (part_no >= 0) {
        strcpy(part_buf, CS_BLCOK_DEV_MARJOR_NUM);
        strcat(part_buf, ":");

        sprintf(tmp_buf, "%x", part_no);
        strcat(part_buf, tmp_buf);

        return fs_set_blk_dev(CS_BLCOK_DEV_INTERFACE, part_buf, FS_TYPE_EXT);
    }

    return -1;
}
#endif

int iniIsFileExist(const char *file_path) {
#if (defined CC_COMPILE_IN_PC || defined CC_COMPILE_IN_ANDROID)
    if (access(file_path, 0) < 0) {
        return 0;
    }

    return 1;
#elif (defined CC_COMPILE_IN_UBOOT)
    char part_name[CC_MAX_INI_FILE_NAME_LEN];
    char file_name[CC_MAX_INI_FILE_NAME_LEN];

    memset((void *)part_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    memset((void *)file_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    if (splitFilePath(file_path, part_name, file_name, NULL) < 0) {
        return 0;
    }

    if (setBlockDevice(part_name) < 0) {
        return 0;
    }

    return fs_exists(file_name);
#endif
}

int iniGetFileSize(const char *file_path) {
#if (defined CC_COMPILE_IN_PC || defined CC_COMPILE_IN_ANDROID)
    int file_size = 0;
    int dev_fd = -1;

    dev_fd = open(file_path, O_RDONLY);
    if (dev_fd < 0) {
        ALOGE("%s, open \"%s\" ERROR(%s)!!\n", __FUNCTION__,
                file_path, strerror(errno));
        return 0;
    }

    file_size = lseek(dev_fd, 0L, SEEK_END);
    lseek(dev_fd, 0L, SEEK_SET);

    return file_size;
#elif (defined CC_COMPILE_IN_UBOOT)
    loff_t file_size = 0;
    char part_name[CC_MAX_INI_FILE_NAME_LEN];
    char file_name[CC_MAX_INI_FILE_NAME_LEN];

    memset((void *)part_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    memset((void *)file_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    if (splitFilePath(file_path, part_name, file_name, NULL) < 0) {
        return -1;
    }

    if (setBlockDevice(part_name) < 0) {
        return -1;
    }

    if (fs_size(file_name, &file_size)) {
        return -1;
    }

    return file_size;
#endif
}

int iniReadFileToBuffer(const char *file_path, int offset, int rd_size, unsigned char data_buf[]) {
#if (defined CC_COMPILE_IN_PC || defined CC_COMPILE_IN_ANDROID)
    int rd_cnt = 0, file_size = 0;
    int dev_fd = -1;

    dev_fd = open(file_path, O_RDONLY);
    if (dev_fd < 0) {
        ALOGE("%s, open \"%s\" ERROR(%s)!!\n", __FUNCTION__,
                file_path, strerror(errno));
        return -1;
    }

    lseek(dev_fd, offset, SEEK_SET);

    rd_cnt = read(dev_fd, data_buf, rd_size);

    close(dev_fd);
    dev_fd = -1;

    if (rd_cnt != rd_size) {
        ALOGE("%s, read file \"%s\" ERROR(%d, %d)!!!!\n", __FUNCTION__,
                file_path, rd_cnt, file_size);
        return -1;
    }

    return rd_cnt;
#elif (defined CC_COMPILE_IN_UBOOT)
    int tmp_ret = -1;
    loff_t rd_cnt = 0;
    char part_name[CC_MAX_INI_FILE_NAME_LEN];
    char file_name[CC_MAX_INI_FILE_NAME_LEN];

    memset((void *)part_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    memset((void *)file_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    if (splitFilePath(file_path, part_name, file_name, NULL) < 0) {
        return -1;
    }

    if (setBlockDevice(part_name) < 0) {
        return -1;
    }

    tmp_ret = fs_read(file_name, (unsigned long)data_buf, 0, 0, &rd_cnt);
    if (tmp_ret < 0) {
        return -1;
    }

    flush_dcache_range((unsigned long )data_buf, (unsigned long )data_buf + rd_cnt);

    return rd_cnt;
#endif
}


