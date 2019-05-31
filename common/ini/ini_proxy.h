/*
 * Author:  Shoufu Zhao <shoufu.zhao@amlogic.com>
 */

#ifndef __INI_PROXY_H__
#define __INI_PROXY_H__

#ifdef __cplusplus
extern "C" {
#endif

void BinFileInit(void);
void BinFileUninit(void);
int ReadBinFile(const char* filename);
int GetBinData(unsigned char* file_buf, unsigned int file_size);

void IniParserInit(void);
void IniParserUninit(void);
int IniParseFile(const char* filename);
int IniParseMem(unsigned char* file_buf);
int IniSetSaveFileName(const char* filename);
void IniParserFree(void);
void IniPrintAll(void);
void IniListSection(void);
const char* IniGetString(const char* section, const char* key, const char* def_value);
int IniSetString(const char *section, const char *key, const char *value);
int IniSaveToFile(const char *filename);

#ifdef __cplusplus
}
#endif

#endif //__INI_PROXY_H__
