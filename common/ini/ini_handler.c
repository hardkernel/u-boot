/*
 * Author:  Shoufu Zhao <shoufu.zhao@amlogic.com>
 */

#include "ini_config.h"

#define LOG_TAG "ini_handler"
#define LOG_NDEBUG 0

#include "ini_log.h"

#include "ini_core.h"
#include "ini_handler.h"
#include "ini_platform.h"

static void trim(char *str, char ch);
static void trim_all(char *str);
static INI_SECTION* getSection(const char* section, INI_HANDLER_DATA *pHandlerData);
static INI_LINE* getKeyLineAtSec(INI_SECTION* pSec, const char* key);
static int setKeyValue(void* user, const char* section, const char* name, const char* value, int set_mode);
static int handler(void* user, const char* section, const char* name, const char* value);
static INI_LINE* newLine(const char* name, const char* value);
static INI_SECTION* newSection(const char* section, INI_LINE* pLINE);

#if CC_MEMORY_ALLOC_FREE_TRACE == 1
static void alloc_mem(const char *fun_name, const char *var_name, void *ptr);
static void free_mem(const char *fun_name, const char *var_name, void *ptr);
static void printAllocMemND(const char *fun_name);
static void printFreeMemND(const char *fun_name);
static void clearMemND(void);
#endif

int bin_file_read(const char* filename, unsigned char *file_buf) {
    int tmp_ret = -1, rd_cnt = 0, file_size = 0;
    unsigned char *tmp_buf = NULL;

    if (!iniIsFileExist(filename)) {
        ALOGE("%s, file \"%s\" is not exist!\n", __FUNCTION__, filename);
        return -1;
    }

    file_size = iniGetFileSize(filename);
    if (file_size <= 0) {
        ALOGE("%s, file \"%s\" size error!\n", __FUNCTION__, filename);
        return -1;
    }

    tmp_buf = (unsigned char *) malloc(file_size * 2);
    if (tmp_buf != NULL) {
        rd_cnt = iniReadFileToBuffer(filename, 0, file_size, tmp_buf);
        if (rd_cnt > 0) {
            if (file_size > CC_MAX_INI_FILE_SIZE) {
                ALOGE("%s: file \"%s\" size out of support!\n", __FUNCTION__, filename);
                tmp_ret = -1;
            } else {
                memcpy(file_buf, tmp_buf, file_size);
                tmp_ret = file_size;
            }
        }

        free(tmp_buf);
        tmp_buf = NULL;
    }

    return tmp_ret;
}

int ini_file_parse(const char* filename, INI_HANDLER_DATA *pHandlerData) {
    int tmp_ret = -1, rd_cnt = 0, file_size = 0;
    unsigned char *tmp_buf = NULL;

    if (!iniIsFileExist(filename)) {
        ALOGE("%s, file \"%s\" is not exist!\n", __FUNCTION__, filename);
        return -1;
    }

    file_size = iniGetFileSize(filename);
    if (file_size <= 0) {
        ALOGE("%s, file \"%s\" size error!\n", __FUNCTION__, filename);
        return -1;
    }

    tmp_buf = (unsigned char *) malloc(file_size * 2);
    if (tmp_buf != NULL) {
        strncpy(pHandlerData->mpFileName, filename, CC_MAX_INI_FILE_NAME_LEN - 1);

        rd_cnt = iniReadFileToBuffer(filename, 0, file_size, tmp_buf);
        if (rd_cnt > 0) {
            tmp_ret = ini_mem_parse(tmp_buf, pHandlerData);
        }

        free(tmp_buf);
        tmp_buf = NULL;
    }

    return tmp_ret;
}

int ini_mem_parse(unsigned char* file_buf, INI_HANDLER_DATA *pHandlerData) {
    //ALOGD("%s, entering...\n", __FUNCTION__);
    return ini_parse_mem((char *)file_buf, handler, (void *)pHandlerData);
}

int ini_set_save_file_name(const char* filename, INI_HANDLER_DATA *pHandlerData) {
    //ALOGD("%s, entering...\n", __FUNCTION__);

    strncpy(pHandlerData->mpFileName, filename, CC_MAX_INI_FILE_NAME_LEN - 1);
    return 0;
}

void ini_free_mem(INI_HANDLER_DATA *pHandlerData) {
    //ALOGD("%s, entering...\n", __FUNCTION__);

    INI_SECTION* pNextSec = NULL;
    INI_SECTION* pSec = NULL;
    for (pSec = pHandlerData->mpFirstSection; pSec != NULL;) {
        pNextSec = pSec->pNext;

        INI_LINE* pNextLine = NULL;
        INI_LINE* pLine = NULL;
        for (pLine = pSec->pLine; pLine != NULL;) {
            pNextLine = pLine->pNext;

            if (pLine != NULL) {
#if CC_MEMORY_ALLOC_FREE_TRACE == 1
                free_mem(__FUNCTION__, "pLine", pLine);
#endif

                free(pLine);
                pLine = NULL;
            }

            pLine = pNextLine;
        }

        if (pSec != NULL) {
#if CC_MEMORY_ALLOC_FREE_TRACE == 1
            free_mem(__FUNCTION__, "pSec", pSec);
#endif

            free(pSec);
            pSec = NULL;
        }

        pSec = pNextSec;
    }

    pHandlerData->mpFirstSection = NULL;
    pHandlerData->mpCurSection = NULL;

#if CC_MEMORY_ALLOC_FREE_TRACE == 1
    printAllocMemND(__FUNCTION__);
    printFreeMemND(__FUNCTION__);
    clearMemND();
#endif
}

static void trim(char *str, char ch) {
    char* pStr;

    pStr = str;
    while (*pStr != '\0') {
        if (*pStr == ch) {
            char* pTmp = pStr;
            while (*pTmp != '\0') {
                *pTmp = *(pTmp + 1);
                pTmp++;
            }
        } else {
            pStr++;
        }
    }
}

static void trim_all(char *str) {
    char* pStr = NULL;

    pStr = strchr(str, '\n');
    if (pStr != NULL) {
        *pStr = 0;
    }

    int Len = strlen(str);
    if (Len > 0) {
        if (str[Len - 1] == '\r') {
            str[Len - 1] = '\0';
        }
    }

    pStr = strchr(str, '#');
    if (pStr != NULL) {
        *pStr = 0;
    }

    pStr = strchr(str, ';');
    if (pStr != NULL) {
        *pStr = 0;
    }

    trim(str, ' ');
    trim(str, '{');
    trim(str, '\\');
    trim(str, '}');
    trim(str, '\"');
    return;
}

void ini_print_all(INI_HANDLER_DATA *pHandlerData) {
    INI_SECTION* pSec = NULL;
    for (pSec = pHandlerData->mpFirstSection; pSec != NULL; pSec = pSec->pNext) {
        ALOGD("[%s]\n", pSec->Name);
        INI_LINE* pLine = NULL;
        for (pLine = pSec->pLine; pLine != NULL; pLine = pLine->pNext) {
            ALOGD("%s = %s\n", pLine->Name, pLine->Value);
        }
        ALOGD("\n\n\n");
    }
}

void ini_list_section(INI_HANDLER_DATA *pHandlerData) {
    INI_SECTION* pSec = NULL;
    for (pSec = pHandlerData->mpFirstSection; pSec != NULL; pSec = pSec->pNext) {
        printf("  %s\n", pSec->Name);
    }
}

static INI_SECTION* getSection(const char* section, INI_HANDLER_DATA *pHandlerData) {
    INI_SECTION* pSec = NULL;
    for (pSec = pHandlerData->mpFirstSection; pSec != NULL; pSec = pSec->pNext) {
        if (strncmp(pSec->Name, section, strlen(section)) == 0) {
            return pSec;
        }
    }

    return NULL;
}

static INI_LINE* getKeyLineAtSec(INI_SECTION* pSec, const char* key) {
    INI_LINE* pLine = NULL;
    for (pLine = pSec->pLine; pLine != NULL; pLine = pLine->pNext) {
        if (strncmp(pLine->Name, key, strlen(key)) == 0) {
            return pLine;
        }
    }
    return NULL;
}

const char* ini_get_string(const char* section, const char* key,
        const char* def_value, INI_HANDLER_DATA *pHandlerData) {
    INI_SECTION* pSec = getSection(section, pHandlerData);
    if (pSec == NULL) {
        //ALOGD("%s, section %s is NULL\n", __FUNCTION__, section);
        return def_value;
    }

    INI_LINE* pLine = getKeyLineAtSec(pSec, key);
    if (pLine == NULL) {
        //ALOGD("%s, key \"%s\" is NULL\n", __FUNCTION__, key);
        return def_value;
    }

    return pLine->Value;
}

int ini_set_string(const char *section, const char *key, const char *value, INI_HANDLER_DATA *pHandlerData) {
    setKeyValue(pHandlerData, section, key, value, 1);
    return 0;
}

int ini_save_to_file(const char *filename, INI_HANDLER_DATA *pHandlerData) {
#if (defined CC_COMPILE_IN_PC || defined CC_COMPILE_IN_ANDROID)
    const char *fname = NULL;
    FILE *fp = NULL;

    if (filename == NULL) {
        if (strlen(pHandlerData->mpFileName) == 0) {
            ALOGE("%s, save file name is NULL!!!\n", __FUNCTION__);
            return -1;
        } else {
            fname = pHandlerData->mpFileName;
        }
    } else {
        fname = filename;
    }

    if ((fp = fopen (fname, "wb")) == NULL) {
        ALOGE("%s, Open file \"%s\" ERROR (%s)!!!\n", __FUNCTION__, fname, strerror(errno));
        return -1;
    }

    INI_SECTION* pSec = NULL;
    for (pSec = pHandlerData->mpFirstSection; pSec != NULL; pSec = pSec->pNext) {
        fprintf(fp, "[%s]\r\n", pSec->Name);
        INI_LINE* pLine = NULL;
        for (pLine = pSec->pLine; pLine != NULL; pLine = pLine->pNext) {
            fprintf(fp, "%s = %s\r\n", pLine->Name, pLine->Value);
        }
    }

    fflush(fp);
    fsync(fileno(fp));

    fclose(fp);
    fp = NULL;

    return 0;
#elif (defined CC_COMPILE_IN_UBOOT)
    return 0;
#endif
}

static INI_LINE* newLine(const char* name, const char* value) {
    INI_LINE* pLine = NULL;

    pLine = (INI_LINE*) malloc(sizeof(INI_LINE));
    if (pLine != NULL) {
        pLine->pNext = NULL;
        strcpy(pLine->Name, name);
        strcpy(pLine->Value, value);

#if CC_MEMORY_ALLOC_FREE_TRACE == 1
        alloc_mem(__FUNCTION__, "pLine", pLine);
#endif
    }

    return pLine;
}

static INI_SECTION* newSection(const char* section, INI_LINE* pLine) {
    INI_SECTION* pSec = NULL;

    pSec = (INI_SECTION*) malloc(sizeof(INI_SECTION));
    if (pSec != NULL) {
        pSec->pLine = pLine;
        pSec->pNext = NULL;
        strcpy(pSec->Name, section);

#if CC_MEMORY_ALLOC_FREE_TRACE == 1
        alloc_mem(__FUNCTION__, "pSec", pSec);
#endif
    }

    return pSec;
}

static int setKeyValue(void* user, const char* section, const char* key, const char* value, int set_mode) {
    INI_LINE* pLine = NULL;
    INI_SECTION *pSec = NULL;
    INI_HANDLER_DATA *pHandlerData = (INI_HANDLER_DATA *) user;

    if (section == NULL || key == NULL || value == NULL) {
        return 1;
    }

    trim_all((char *) value);
    if (value[0] == '\0') {
        return 1;
    }

    if (strlen(key) > CC_MAX_INI_LINE_NAME_LEN) {
        ALOGE("key name is too long, limit %d.\n", CC_MAX_INI_LINE_NAME_LEN);
        return 1;
    }
    if (strlen(value) > CC_MAX_INI_FILE_LINE_LEN) {
        ALOGE("key name is too long, limit %d.\n", CC_MAX_INI_FILE_LINE_LEN);
        return 1;
    }

    if (pHandlerData->mpFirstSection == NULL) {
        pLine = newLine(key, value);
        pSec = newSection(section, pLine);

        pHandlerData->mpFirstSection = pSec;
        pHandlerData->mpCurSection = pSec;
        pSec->pCurLine = pLine;
    } else {
        pSec = getSection(section, pHandlerData);
        if (pSec == NULL) {
            pLine = newLine(key, value);
            pSec = newSection(section, pLine);

            pHandlerData->mpCurSection->pNext = pSec;
            pHandlerData->mpCurSection = pSec;
            pSec->pCurLine = pLine;

            pSec->pCurLine = pLine;
        } else {
            pLine = getKeyLineAtSec(pSec, key);
            if (pLine == NULL) {
                pLine = newLine(key, value);

                pSec->pCurLine->pNext = pLine;
                pSec->pCurLine = pLine;
            } else {
                if (set_mode == 1) {
                    strcpy(pLine->Value, value);
                } else {
                    strcat(pLine->Value, value);
                }
            }
        }
    }

    return 0;
}

static int handler(void* user, const char* section, const char* name,
        const char* value) {
    //ALOGD("%s, section = %s, name = %s, value = %s\n", __FUNCTION__, section, name, value);
    setKeyValue(user, section, name, value, 0);
    return 1;
}

#if CC_MEMORY_ALLOC_FREE_TRACE == 1

#define CC_MEM_RECORD_CNT    (1024)

typedef struct tag_memnd {
    char fun_name[50];
    char var_name[50];
    void *ptr;
} memnd;

static memnd gMemAllocItems[CC_MEM_RECORD_CNT];
static int gMemAllocInd = 0;

static memnd gMemFreeItems[CC_MEM_RECORD_CNT];
static int gMemFreeInd = 0;

static void alloc_mem(const char *fun_name, const char *var_name, void *ptr) {
    strcpy(gMemAllocItems[gMemAllocInd].fun_name, fun_name);
    strcpy(gMemAllocItems[gMemAllocInd].var_name, var_name);
    gMemAllocItems[gMemAllocInd].ptr = ptr;

    gMemAllocInd += 1;
}

static void free_mem(const char *fun_name, const char *var_name, void *ptr) {
    strcpy(gMemFreeItems[gMemFreeInd].fun_name, fun_name);
    strcpy(gMemFreeItems[gMemFreeInd].var_name, var_name);
    gMemFreeItems[gMemFreeInd].ptr = ptr;

    gMemFreeInd += 1;
}

static void printMemND(const char *fun_name, memnd *tmp_nd, int tmp_cnt) {
#if CC_MEMORY_ALLOC_FREE_TRACE_PRINT_ALL == 1
    int i = 0;

    ALOGD("fun_name = %s, total_cnt = %d\n", fun_name, tmp_cnt);

    for (i = 0; i < tmp_cnt; i++) {
        ALOGD("fun_name = %s, var_name = %s, ptr = %p\n", tmp_nd[i].fun_name, tmp_nd[i].var_name, tmp_nd[i].ptr);
    }
#endif
}

static void printFreeMemND(const char *fun_name) {
    printMemND(__FUNCTION__, gMemFreeItems, gMemFreeInd);
}

static void printAllocMemND(const char *fun_name) {
    printMemND(__FUNCTION__, gMemAllocItems, gMemAllocInd);
}

static void clearMemND(void) {
    gMemAllocInd = 0;
    gMemFreeInd = 0;
    memset((void *)gMemAllocItems, 0, sizeof(memnd) * CC_MEM_RECORD_CNT);
    memset((void *)gMemFreeItems, 0, sizeof(memnd) * CC_MEM_RECORD_CNT);
}
#endif
