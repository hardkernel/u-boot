/*
 * \file        optimus_sdc_burn_i.h
 * \brief       internal struct types and interfaces for sdc burn
 *
 * \version     1.0.0
 * \date        2013-7-12
 * \author      Sam.Wu <yihui.wu@amlgic.com>
 *
 * Copyright (c) 2013 Amlogic. All Rights Reserved.
 *
 */
#ifndef __OPTIMUS_SDC_BURN_I_H__
#define __OPTIMUS_SDC_BURN_I_H__

#include "../v2_burning_i.h"
#include <fat.h>
#include <part.h>

#define ITEM_NOT_EXIST   0x55

typedef struct _burnEx{
    char        pkgPath[128];
    char        mediaPath[128];
    struct {
        unsigned pkgPath    : 1;
        unsigned mediaPath  : 1;
        unsigned reserv     : 32 - 2;
    }bitsMap;
}BurnEx_t;

typedef struct _customPara{
    int         eraseBootloader;
    int         eraseFlash;
    int         rebootAfterBurn;
    int         keyOverwrite;
    struct{
        unsigned eraseBootloader    : 1;
        unsigned eraseFlash         : 1;
        unsigned rebootAfterBurn    : 1;
        unsigned keyOverwrite       : 1;
        unsigned resev              : 32 - 4;
    }bitsMap;
}CustomPara_t;

#define MAX_BURN_PARTS      (32)
#define PART_NAME_LEN_MAX   (32)

typedef struct _burnParts{
    int         burn_num;
    char        burnParts[MAX_BURN_PARTS][PART_NAME_LEN_MAX];
    unsigned    bitsMap4BurnParts;
}BurnParts_t;

typedef struct _burnDisplay{
    char*       outputmode;
    unsigned    bitsMap4Display;
}BurnDisplay_t;

typedef struct _ConfigPara{
    BurnParts_t     burnParts;
    CustomPara_t    custom;
    BurnEx_t        burnEx;
    BurnDisplay_t   display;
    struct {
        unsigned    burnParts : 1;
        unsigned    custom    : 1;
        unsigned    burnEx    : 1;
        unsigned    display   : 1;
        unsigned    reserv    : 32 - 4;
    }setsBitMap;
}ConfigPara_t;

//ini parser
int _optimus_parse_buf_2_lines(char* pTextBuf, const unsigned textSz, const char* lines[],
                unsigned* totalLineNum, const unsigned MaxLines);//parse text context to linces delimitted by (\r)\n
int parse_ini_file_2_valid_lines(const char* filePath, char* iniBuf, const unsigned bufSz, char* lines[]);
int _optimus_abandon_ini_comment_lines(char* lines[], const unsigned lineNum);
int optimus_ini_trans_lines_2_usr_params(const char* const lines[], const unsigned lineNum,
                        int (*pCheckSetUseFul)(const char* setName),
                        int (*pParseCfgVal)(const char* setName, const char* keyName, const char* keyVal));

int parse_ini_cfg_file(const char* filePath);

int check_cfg_burn_parts(const ConfigPara_t* burnPara);
int print_burn_parts_para(const BurnParts_t* pBurnParts);

int sdc_burn_verify(const char* verifyFile);

//burn a partition with a image file
int optimus_burn_partition_image(const char* partName, const char* imgItemPath, const char* fileFmt, const char* verifyFile, const unsigned itemSizeNotAligned);

int sdc_burn_buf_manager_init(const char* partName, s64 imgItemSz, const char* fileFmt,
                            const unsigned itemSizeNotAligned /* if item offset 3 and bytepercluste 4k, then it's 4k -3 */);

int get_burn_parts_from_img(HIMAGE hImg, ConfigPara_t* pcfg);

//declare for aml_sysrecovery
int optimus_sdc_burn_partitions(ConfigPara_t* pCfgPara, HIMAGE hImg, __hdle hUiProgress, int needVerify);
int optimus_sdc_burn_dtb_load(HIMAGE hImg);

int optimus_burn_bootlader(HIMAGE hImg);

int optimus_report_burn_complete_sta(int isFailed, int rebootAfterBurn);


int optimus_sdc_burn_switch_to_extmmc(void);

int optimus_save_loaded_dtb_to_flash(void);

//Followings are For burn keys only
int optimus_sdc_keysprovider_init(void);
int optimus_sdc_keysprovider_exit(void);
int optimus_sdc_keysprovider_open(const char* keyName, const void** pHdle);
int optimus_sdc_keysprovider_get_keyval(const void* pHdle, u8* pBuf, unsigned* keySz);
int optimus_sdc_keysprovider_update_license(const void* pHdle);

int optimus_keysburn_onekey(const char* keyName, u8* keyVal, unsigned keyValLen);


//for fat fs
long do_fat_fopen(const char *filename);
long do_fat_fread(int fd, __u8 *buffer, unsigned long maxsize);
void do_fat_fclose(int fd);
s64 do_fat_get_fileSz(const char* imgItemPath);
int do_fat_fseek(int fd, const __u64 offset, int wherehence);
unsigned do_fat_get_bytesperclust(int fd);
int optimus_device_probe(const char* interface, const char* inPart);
int optimus_fat_register_device(block_dev_desc_t *dev_desc, int part_no);

//<0 if failed, 0 is normal, 1 is sparse, others reserved
int do_fat_get_file_format(const char* imgFilePath, unsigned char* pbuf, const unsigned bufSz);

extern int aml_check_is_ready_for_sdc_produce(void);

#endif//#ifndef __OPTIMUS_SDC_BURN_I_H__

