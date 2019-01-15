#ifndef __INI_IO_H__
#define __INI_IO_H__

#define CC_MAX_DATA_SIZE                         (0x10000)
#define CC_MAX_TCON_BIN_SIZE                     (0x5dc0)  /* max:24000 */
#define CC_ONE_SECTION_SIZE                      (0x10000)

#define CS_LCD_ITEM_NAME                          "lcd"
#define CS_LCD_EXT_ITEM_NAME                      "lcd_extern"
#define CS_BACKLIGHT_ITEM_NAME                    "backlight"
#define CS_LCD_TCON_ITEM_NAME                     "lcd_tcon"
#define CS_PANEL_INI_PATH_ITEM_NAME               "panel_ini_path"
#define CS_PANEL_PQ_PATH_ITEM_NAME                "panel_pq_path"
#define CS_PANEL_ALL_INFO_ITEM_NAME               "panel_all_info"
#define CS_PANEL_ALL_DATA_ITEM_NAME               "panel_all"

#define CC_HEAD_CHKSUM_LEN                       (9)
#define CC_VERSION_LEN                           (5)

#ifdef __cplusplus
extern "C" {
#endif

int ReadLCDParam(unsigned char data_buf[]);
int SaveLCDParam(int wr_size, unsigned char data_buf[]);
int ReadLCDExternParam(unsigned char data_buf[]);
int SaveLCDExternParam(int wr_size, unsigned char data_buf[]);
int ReadBackLightParam(unsigned char data_buf[]);
int SaveBackLightParam(int wr_size, unsigned char data_buf[]);
int ReadTconBinParam(unsigned char data_buf[]);
int SaveTconBinParam(int wr_size, unsigned char data_buf[]);
int ReadPanelIniName(char data_buf[]);
int SavePanelIniName(char data_buf[]);
int ReadPanelPQPath(char data_buf[]);
int SavePanelPQPath(char data_buf[]);
int ReadPanelAllInfoData(unsigned char data_buf[]);
int SavePanelAllInfoData(int wr_size, unsigned char data_buf[]);
int ReadPanelAllData(int sec_no, unsigned char data_buf[]);
int SavePanelAllData(int sec_no, int wr_size, unsigned char data_buf[]);

int check_hex_data_no_header_valid(unsigned int* tmp_crc32, int max_len, int buf_len, unsigned char data_buf[]);
int check_hex_data_have_header_valid(unsigned int* tmp_crc32, int max_len, int buf_len, unsigned char data_buf[]);
int check_string_data_have_header_valid(unsigned int* tmp_crc32, char *data_str, int chksum_head_len, int ver_len);
unsigned int CalCRC32(unsigned int crc, const unsigned char *ptr, int buf_len);
void PrintDataBuf(int data_cnt, unsigned char data_buf[]);

#ifdef __cplusplus
}
#endif

#endif //__INI_IO_H__
