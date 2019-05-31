/*
 * Author:  Shoufu Zhao <shoufu.zhao@amlogic.com>
 */

#include "ini_config.h"

#define LOG_TAG "ini_proxy"
#define LOG_NDEBUG 0

#include "ini_log.h"

#include "ini_handler.h"
#include "ini_proxy.h"

INI_HANDLER_DATA *gHandlerData = NULL;
static unsigned char *gBinData = NULL;

void BinFileInit(void) {
    if (gBinData == NULL) {
        gBinData = malloc(CC_MAX_INI_FILE_SIZE);
        if (gBinData != NULL)
            memset(gBinData, 0, CC_MAX_INI_FILE_SIZE);
    }
}

void BinFileUninit(void) {
    if (gBinData != NULL) {
        free(gBinData);
        gBinData = NULL;
    }
}

int ReadBinFile(const char* filename) {
    if (gBinData == NULL) {
        return -1;
    }
    return bin_file_read(filename, gBinData);
}

int GetBinData(unsigned char* file_buf, unsigned int file_size)
{
    if (gBinData == NULL) {
        return -1;
    }
    if (file_buf == NULL) {
        return -1;
    }
    memcpy(file_buf, gBinData, file_size);
    return 0;
}

void IniParserInit(void) {
    if (gHandlerData == NULL) {
        gHandlerData = (INI_HANDLER_DATA *) malloc(sizeof(INI_HANDLER_DATA));
        if (gHandlerData != NULL) {
            memset((void *)gHandlerData, 0, sizeof(INI_HANDLER_DATA));
        }
    }
}

void IniParserUninit(void) {
    if (gHandlerData != NULL) {
        IniParserFree();
        free(gHandlerData);
        gHandlerData = NULL;
    }
}

int IniParseFile(const char* filename) {
    if (gHandlerData == NULL) {
        return -1;
    }
    return ini_file_parse(filename, gHandlerData);
}

int IniParseMem(unsigned char* file_buf) {
    if (gHandlerData == NULL) {
        return -1;
    }
    return ini_mem_parse(file_buf, gHandlerData);
}

int IniSetSaveFileName(const char* filename) {
    if (gHandlerData == NULL) {
        return -1;
    }
    return ini_set_save_file_name(filename, gHandlerData);
}

void IniParserFree(void) {
    if (gHandlerData == NULL) {
        return;
    }
    return ini_free_mem(gHandlerData);
}

void IniPrintAll(void) {
    if (gHandlerData == NULL) {
        return;
    }
    return ini_print_all(gHandlerData);
}

void IniListSection(void) {
    if (gHandlerData == NULL) {
        ALOGE("%s, ini load file error!\n", __FUNCTION__);
        return;
    }
    ini_list_section(gHandlerData);
}

const char* IniGetString(const char* section, const char* key,
        const char* def_value) {
    if (gHandlerData == NULL) {
        return def_value;
    }
    return ini_get_string(section, key, def_value, gHandlerData);
}

int IniSetString(const char *section, const char *key, const char *value) {
    if (gHandlerData == NULL) {
        return -1;
    }
    return ini_set_string(section, key, value, gHandlerData);
}

int IniSaveToFile(const char *filename) {
    if (gHandlerData == NULL) {
        return -1;
    }
    return ini_save_to_file(filename, gHandlerData);
}
