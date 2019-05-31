#include <command.h>
#include <common.h>
#include <emmc_partitions.h>
#include <fs.h>

#define CS_BLCOK_DEV_INTERFACE    "mmc"
#define CS_BLCOK_DEV_MARJOR_NUM   "1"
#define CC_MAX_INI_FILE_NAME_LEN    (512)
#define CC_MAX_INI_FILE_LINE_LEN    (256)

/*File functions*/
static int splitFilePath(const char *file_path, char part_name[], char file_name[], const char *ext_name) {
    int i = 0;
    char *tmp_start_ptr = NULL;
    char *tmp_end_ptr = NULL;

    if (file_path == NULL) {
        printf("%s, file_path is NULL!!!\n", __FUNCTION__);
        return -1;
    }

    tmp_start_ptr = strchr((char*)file_path,'/');
    if (tmp_start_ptr != file_path) {
        printf("%s, we need one abstract file path!!!  %s.\n", __FUNCTION__, file_path);
        return -1;
    }

    tmp_end_ptr = strchr(tmp_start_ptr + 1,'/');
    if (tmp_end_ptr == NULL) {
        printf("%s, there is only partition name in the path!!!\n", __FUNCTION__);
        return -1;
    }

    strncpy(part_name, tmp_start_ptr + 1, tmp_end_ptr - tmp_start_ptr - 1);
    part_name[tmp_end_ptr - tmp_start_ptr - 1] = '\0';
    /*ALOGD("%s, partition name is %s\n", __FUNCTION__, part_name);*/

    tmp_start_ptr = tmp_end_ptr;

    i = 0;
    while (*tmp_end_ptr && i < CC_MAX_INI_FILE_NAME_LEN) {
        tmp_end_ptr++;
        i++;
    }
    if (i >= CC_MAX_INI_FILE_NAME_LEN) {
        printf("%s, file path is too long (%d)!!!\n", __FUNCTION__, i);
        return -1;
    }

    strncpy(file_name, tmp_start_ptr, i);
    file_name[i] = '\0';
    /*ALOGD("%s, file name is %s\n", __FUNCTION__, file_name);*/

    if (ext_name != NULL) {
        if (strlen(ext_name) > 0) {
            while (tmp_end_ptr != tmp_start_ptr && *tmp_end_ptr != '.') {
                tmp_end_ptr--;
            }

            if (*tmp_end_ptr != '.') {
                printf("%s, the file path \"%s\" doesn't have ext name!!!\n", __FUNCTION__, file_path);
                return -1;
            } else {
                if (strncmp(tmp_end_ptr + 1, ext_name, 128)) {
                    printf("%s, the ext name of file path \"%s\" not equal to the special ext name \"%s\"!!!\n", __FUNCTION__, file_path, ext_name);
                    return -1;
                }
            }
        }
    }

    return 0;
}

static int setBlockDevice_fs(const char *part_name) {
     int part_no = 0;
     char part_buf[128] = {0};
     char tmp_buf[128] = {0};
     printf("set blk\n");
     part_no = get_partition_num_by_name((char *)part_name);
     /*printf("%s, part_no is %d\n", __FUNCTION__, part_no);*/
     if (part_no >= 0) {
         strcpy(part_buf, CS_BLCOK_DEV_MARJOR_NUM);
         strcat(part_buf, ":");

         sprintf(tmp_buf, "%x", part_no);
         strcat(part_buf, tmp_buf);

         return fs_set_blk_dev(CS_BLCOK_DEV_INTERFACE, part_buf, FS_TYPE_EXT);
     }
     printf("set blk done\n");
     return -1;
}

int fwGetFileSize(const char *file_path) {
    loff_t file_size = 0;
    char part_name[CC_MAX_INI_FILE_NAME_LEN];
    char file_name[CC_MAX_INI_FILE_NAME_LEN];

    memset((void *)part_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    memset((void *)file_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    if (splitFilePath(file_path, part_name, file_name, NULL) < 0) {
        return -1;
    }
		printf("setBlockDevice_fs start ....\n");
    if (setBlockDevice_fs(part_name) < 0) {
        return -1;
    }
		printf("setBlockDevice_fs %s end ....\n",file_name);
    if (fs_size(file_name, &file_size)) {
        return -1;
    }
		printf("setBlockDevice_fs  %s end ....\n",file_name);
    return file_size;
}

int fwReadFileToBuffer(const char *file_path,unsigned char data_buf[]) {

    int tmp_ret = -1;
    loff_t rd_cnt = 0;
    char part_name[CC_MAX_INI_FILE_NAME_LEN];
    char file_name[CC_MAX_INI_FILE_NAME_LEN];

    memset((void *)part_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    memset((void *)file_name, 0, CC_MAX_INI_FILE_NAME_LEN);
    if (splitFilePath(file_path, part_name, file_name, NULL) < 0) {
        return -1;
    }

    if (setBlockDevice_fs(part_name) < 0) {
        return -1;
    }

    tmp_ret = fs_read(file_name, (unsigned long)data_buf, 0, 0, &rd_cnt);
    if (tmp_ret < 0) {
        return -1;
    }

    flush_dcache_range((unsigned long )data_buf, (unsigned long )data_buf + rd_cnt);
    return rd_cnt;
}
