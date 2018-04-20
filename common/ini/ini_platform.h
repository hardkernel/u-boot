#ifndef __INI_PLATFORM_H__
#define __INI_PLATFORM_H__

#if (defined CC_COMPILE_IN_UBOOT)
    #define strtoul simple_strtoul
    #define strtol simple_strtol
#endif

#ifdef __cplusplus
extern "C" {
#endif

//c basic lib
char* plat_strtok_r(char *str, const char *delim, char **saveptr);

//File functions
int iniIsFileExist(const char *file_path);
int iniGetFileSize(const char *file_path);
int iniReadFileToBuffer(const char *file_path, int offset, int rd_size, unsigned char data_buf[]);

#ifdef __cplusplus
}
#endif

#endif //__INI_PLATFORM_H__
