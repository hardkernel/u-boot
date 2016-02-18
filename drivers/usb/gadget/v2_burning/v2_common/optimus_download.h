/*
 * \file        optimus_download.h
 * \brief       common included files for optimus_*.c
 *
 * \version     1.0.0
 * \date        2013/5/3
 * \author      Sam.Wu <yihui.wu@Amlogic.com>
 *
 * Copyright (c) 2013 Amlogic Inc.. All Rights Reserved.
 *
 */

#ifndef __OPTIMUS_DOWNLOAD_H__
#define __OPTIMUS_DOWNLOAD_H__


int optimus_buf_manager_init(const unsigned mediaAlignSz);
int optimus_buf_manager_exit(void);
int optimus_buf_manager_tplcmd_init(const char* mediaType, const char* partName, u64 partBaseOffset,
                            const char* imgType, const u64 pktTotalSz, const int isUpload,
                            const unsigned itemSizeNotAligned);
int optimus_buf_manager_get_buf_for_bulk_transfer(char** pBuf, const unsigned wantSz, const unsigned sequenceNo, char* errInfo);
int optimus_buf_manager_report_transfer_complete(const u32 transferSz, char* errInfo);
int is_largest_data_transferring(void);
int optimus_buf_manager_get_command_data_for_upload_transfer(u8* cmdDataBuf, const unsigned bufLen);

int optimus_download_init(void);
int optimus_download_exit(void);
int optimus_parse_download_cmd(int argc, char* argv[]);
int optimus_parse_img_download_info(const char* part_name, const u64 imgSz, const char* imgType, const char* mediaType, const u64 partBaseOffset);
int is_optimus_to_burn_ready(void);//ready before burn
u32 optimus_download_img_data(const u8* data, const u32 size, char* errInfo);
int is_optimus_on_burn(void);    //is now transferring image
int is_optimus_pre_burn(void);    //is now has get "download command"
int optimus_media_download_verify(const int argc, char * const argv[], char *info);

u32 optimus_dump_storage_data(u8* pBuf, const u32 wantSz, char* errInfo);


//for key opearations
//
int v2_key_command(const int argc, char * const argv[], char *info);

/*
 *This fucntion called by mread command, mread= bulkcmd "upload key .." + n * upload transfer, for key n==1
 *Attentions: return 0 if success, else failed
 *@keyName: key name in null-terminated c style string
 *@keyVal: the buffer to read back the key value
 *@keyValLen: keyVal len is strict when read, i.e, user must know the length of key he/she wnat to read!!
 *@errInfo: start it with success if burned ok, or format error info into it tell pc burned failed
 */
int v2_key_read(const char* keyName, u8* keyVal, const unsigned keyValLen, char* errInfo, unsigned* fmtLen);

/*
 *This fucntion called by mwrite command, mread= bulkcmd "download key .." + n * download transfer, for key n==1
 *Attentions: return value is the key length if burn sucess
 *@keyName: key name in null-terminated c style string
 *@keyVal: key value download from USB, "the value for sepecial keyName" may need de-encrypt by user code
 *@keyValLen: the key value downloaded from usb transfer!
 *@errInfo: start it with success if burned ok, or format error info into it tell pc burned failed
 */
unsigned v2_key_burn(const char* keyName, const u8* keyVal, const unsigned keyValLen, char* errInfo);

#define DDR_MEM_ADDR_START  ( 0x073<<20 )

//  |<---Back 2M---->|<------------USB transfer Buf 64 ----------->|<--Backed sparse format info for verify-->|
//      Back buf                          Transfer buf
//TODO: move memory mapping to comman shared header file
//FIXME:Make sure [0x818<<20, 0x839<<20] not used by others
//[Buffer 0] DRAM_START, DRAM_START+2M, This range can't be accessed
//[Buffer 1] Buffer to Back up partition image data that not write back to flash,
#define OPTIMUS_SPARSE_IMG_LEFT_DATA_ADDR_LOW   (DDR_MEM_ADDR_START + (2U<<20))//Don't access First 1M address
#define OPTIMUS_SPARSE_IMG_LEFT_DATA_MAX_SZ    (0X2<<20) //back up address for sparse image, 2M

//[Buffer 2] This 64M buffer is used to cache image data received from USB download,
//            This Buffer size  should be 64M, other size has pending bugs when sparse image is very large.
#define OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR      (OPTIMUS_SPARSE_IMG_LEFT_DATA_ADDR_LOW + OPTIMUS_SPARSE_IMG_LEFT_DATA_MAX_SZ)
#define OPTIMUS_DOWNLOAD_TRANSFER_BUF_TOTALSZ   (0X40<<20)//64M

#define OPTIMUS_DOWNLOAD_SLOT_SZ                (64<<10)    //64K
#define OPTIMUS_DOWNLOAD_SLOT_SZ_SHIFT_BITS     (16)    //64K
#define OPTIMUS_DOWNLOAD_SLOT_NUM               (OPTIMUS_DOWNLOAD_TRANSFER_BUF_TOTALSZ/OPTIMUS_DOWNLOAD_SLOT_SZ)

//[Buffer 3] This buffer is used to Back up sparse chunk headers for verifying sparse image
#define OPTIMUS_DOWNLOAD_SPARSE_INFO_FOR_VERIFY (OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR + OPTIMUS_DOWNLOAD_TRANSFER_BUF_TOTALSZ)
#define OPTIMUS_DOWNLOAD_SPS_VERIFY_BACK_INFO_SZ (0x2U<<20)

//[Buffer 4] This buffer is used for filling filled-value CHUNK_TYPE_FILL type sparse chunk,
#define OPTIMUS_SPARSE_IMG_FILL_VAL_BUF         (OPTIMUS_DOWNLOAD_SPARSE_INFO_FOR_VERIFY + OPTIMUS_DOWNLOAD_SPS_VERIFY_BACK_INFO_SZ)
#define OPTIMUS_SPARSE_IMG_FILL_BUF_SZ          OPTIMUS_DOWNLOAD_SLOT_SZ

//[Buffer 5] This buffer to cache header of burning package when not usb burning
#define OPTIMUS_BURN_PKG_HEAD_BUF_ADDR          (OPTIMUS_SPARSE_IMG_FILL_VAL_BUF + OPTIMUS_SPARSE_IMG_FILL_BUF_SZ)
#define OPTIMUS_BURN_PKG_HEAD_BUF_SZ            (1U<<20)//1M should be enough!

//[Buffer 6] This buffer is used to cache logo resources for upgrading
////buffer to display logo, 10M used now
#define OPTIMUS_DOWNLOAD_DISPLAY_BUF            (OPTIMUS_BURN_PKG_HEAD_BUF_ADDR + OPTIMUS_BURN_PKG_HEAD_BUF_SZ)
#define OPTIMUS_DOWNLOAD_BUF_FREE_USE           (OPTIMUS_DOWNLOAD_DISPLAY_BUF + (10U<<20))//free buffer not used by downloading, 2 + 64 + 2 + 10

#define OPTIMUS_VFAT_IMG_WRITE_BACK_SZ          (OPTIMUS_DOWNLOAD_SLOT_SZ*1)//update complete alogrithm if change it
#define OPTIMUS_SIMG_WRITE_BACK_SZ              OPTIMUS_DOWNLOAD_TRANSFER_BUF_TOTALSZ
#define OPTIMUS_MEMORY_WRITE_BACK_SZ            (0X2U<<30)//2GBytes
#define OPTIMUS_BOOTLOADER_MAX_SZ               (2U<<20)//max size is 2M ??

#define OPTIMUS_SHA1SUM_BUFFER_ADDR             OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR
#define OPTIMUS_SHA1SUM_BUFFER_LEN              (OPTIMUS_DOWNLOAD_TRANSFER_BUF_TOTALSZ/8) //8M each time

//As key size < 64K, So buffer [OPTIMUS_SPARSE_IMG_LEFT_DATA_ADDR_LOW, OPTIMUS_DOWNLOAD_TRANSFER_BUF_ADDR) not used when download key
#define OPTIMUS_KEY_DECRYPT_BUF                 OPTIMUS_SPARSE_IMG_LEFT_DATA_ADDR_LOW//buffer for decrypt the key
#define OPTIMUS_KEY_DECRYPT_BUF_SZ              OPTIMUS_DOWNLOAD_SLOT_SZ

#define OPTIMUS_DTB_LOAD_ADDR                   CONFIG_DTB_MEM_ADDR

#define COMPILE_TYPE_CHK(expr, t)       typedef char t[(expr) ? 1 : -1]
#define COMPILE_TIME_ASSERT(expr)       typedef char assert_type[(expr) ? 1 : -1]

#define OPT_DOWN_OK     0
#define OPT_DOWN_FAIL   1
#define OPT_DOWN_TRUE   1
#define OPT_DOWN_FALSE  0

#define OPTIMUS_MEDIA_TYPE_NAND         0   //nand is default
#define OPTIMUS_MEDIA_TYPE_SDMMC        1
#define OPTIMUS_MEDIA_TYPE_SPIFLASH     2
#define OPTIMUS_MEDIA_TYPE_STORE        3   //store stands for one of nand/emmc/spi, which smart identified by stoarge driver
#define OPTIMUS_MEDIA_TYPE_MEM          4   //memory, dram and sram
#define OPTIMUS_MEDIA_TYPE_KEY_UNIFY    5

//Following for optimus_simg2img.c
int optimus_simg_probe(const u8* source, const u32 length);
int optimus_simg_parser_init(const u8* source);
u32 optimus_cb_simg_write_media(const unsigned destAddrInSec, const unsigned dataSzInBy, const char* data);
int optimus_simg_to_media(char* simgPktHead, const u32 pktLen, u32* unParsedDataLen, const u32 flashAddrInSec);
int optimus_sparse_get_chunk_data(u8** head, u32* headSz, u32* dataSz, u64* dataOffset);
int optimus_sparse_back_info_probe(void);

unsigned add_sum(const void* pBuf, const unsigned size);//Add-sum used for 64K transfer

//outStr will be null-terminater after format
int optimus_hex_data_2_ascii_str(const unsigned char* hexData, const unsigned nBytes, char* outStr, const unsigned strSz);

//for prompting step info
int optimus_progress_init(const unsigned itemSzHigh, const unsigned itemSzLow, const u32 startStep, const u32 endStep);
int optimus_progress_exit(void);
int optimus_update_progress(const unsigned thisBurnSz);

#define DWN_ERR(fmt ...) printf("ERR(%s)L%d:", __FILE__, __LINE__);printf(fmt)
#define DWN_MSG(fmt ...) printf("[MSG]"fmt)
#define DWN_WRN(fmt ...) printf("[WRN]"fmt)
#define DWN_DBG(...)
#define DWN_HERE()    printf("f(%s)L%d\n", __FILE__, __LINE__)

//common internal function
int optimus_erase_bootloader(const char* extBootDev);
void optimus_reset(const int cfgFlag);
int optimus_storage_init(int toErase);//init dest burning staorge
int optimus_storage_exit(void);
int is_optimus_storage_inited(void);
void optimus_poweroff(void);
int optimus_burn_complete(const int choice);
int is_the_flash_first_burned(void);
int optimus_set_burn_complete_flag(void);//set 'upgrade_step 1' after burnning success
int platform_busy_increase_un_reported_size(const unsigned nBytes);

#define OPTIMUS_WORK_MODE_NONE            0
#define OPTIMUS_WORK_MODE_USB_UPDATE      (0xefe5)
#define OPTIMUS_WORK_MODE_USB_PRODUCE     (0xefe6)
#define OPTIMUS_WORK_MODE_SDC_UPDATE      (0xefe7)
#define OPTIMUS_WORK_MODE_SDC_PRODUCE     (0xefe8)
#define OPTIMUS_WORK_MODE_SYS_RECOVERY    (0xefe9)
int optimus_work_mode_get(void);
int optimus_work_mode_set(int workmode);

#define OPTIMUS_BURN_COMPLETE__POWEROFF_DIRECT              (0X0)
#define OPTIMUS_BURN_COMPLETE__REBOOT_NORMAL                (0x1)
#define OPTIMUS_BURN_COMPLETE__POWEROFF_AFTER_POWERKEY      (0x2)
#define OPTIMUS_BURN_COMPLETE__POWEROFF_AFTER_DISCONNECT    (0x3)
#define OPTIMUS_BURN_COMPLETE__REBOOT_SDC_BURN              (0xdc)
#define OPTIMUS_BURN_COMPLETE__REBOOT_UPDATE                (0xeb)
#define OPTIMUS_BURN_COMPLETE__QUERY                        (0xe1)

#define ROM_BOOT_SKIP_BOOT_ENABLED_4_USB      1//skip boot to usb supported by romboot
#define ROM_BOOT_SKIP_BOOT_ENABLED_4_SDC      0//skip boot sdcard supported by romboot

//ENV for auto jump into producing
#define _ENV_TIME_OUT_TO_AUTO_BURN "identifyWaitTime"
#define AML_SYS_RECOVERY_PART      "aml_sysrecovery"

#endif//ifndef __OPTIMUS_DOWNLOAD_H__

