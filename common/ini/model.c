/*
 * Author:  Shoufu Zhao <shoufu.zhao@amlogic.com>
 */

#include "ini_config.h"

#define LOG_TAG "model"
#define LOG_NDEBUG 0

#include "ini_log.h"

#include "ini_proxy.h"
#include "ini_handler.h"
#include "ini_platform.h"
#include "ini_io.h"
#include "model.h"

//#define ITEM_DEBUG

#if (defined ITEM_DEBUG)
	#define ITEM_LOGD(x...) ALOGD(x)
	#define ITEM_LOGE(x...) ALOGE(x)
#else
	#define ITEM_LOGD(x...)
	#define ITEM_LOGE(x...)
#endif

#define DEFAULT_MODEL_SUM_PATH "/vendor/etc/tvconfig/model/model_sum.ini"

#define CC_PARAM_CHECK_OK                             (0)
#define CC_PARAM_CHECK_ERROR_NEED_UPDATE_PARAM        (-1)
#define CC_PARAM_CHECK_ERROR_NOT_NEED_UPDATE_PARAM    (-2)

static int gLcdDataCnt = 0, gLcdExtDataCnt = 0, gBlDataCnt = 0;
static int g_lcd_pwr_on_seq_cnt = 0, g_lcd_pwr_off_seq_cnt = 0;

static int gLcdExtInitOnCnt = 0, gLcdExtInitOffCnt = 0;

static int transBufferData(const char *data_str, unsigned int data_buf[]) {
	int item_ind = 0;
	char *token = NULL;
	char *pSave = NULL;
	char *tmp_buf = NULL;

	if (data_str == NULL)
		return 0;

	tmp_buf = (char *) malloc(CC_MAX_TEMP_BUF_SIZE);
	if (tmp_buf == NULL) {
		ALOGE("%s, malloc buffer memory error!!!\n", __func__);
		return -1;
	}

	memset((void *)tmp_buf, 0, CC_MAX_TEMP_BUF_SIZE);
	strncpy(tmp_buf, data_str, CC_MAX_TEMP_BUF_SIZE - 1);
	token = plat_strtok_r(tmp_buf, ",", &pSave);
	while (token != NULL) {
		data_buf[item_ind] = strtoul(token, NULL, 0);
		item_ind++;
		token = plat_strtok_r(NULL, ",", &pSave);
	}

	free(tmp_buf);
	tmp_buf = NULL;

	return item_ind;
}

static int check_param_valid(int mode, int parse_len, unsigned char parse_buf[], int ori_len, unsigned char ori_buf[])
{
	unsigned int ori_cal_crc32 = 0, parse_cal_crc32 = 0;

	if (mode == 0) {
		// start check parse data valid
		//ALOGD("%s, start check parse data valid\n", __func__);
		if (check_hex_data_have_header_valid(&parse_cal_crc32, CC_MAX_DATA_SIZE, parse_len, parse_buf) < 0)
			return CC_PARAM_CHECK_ERROR_NOT_NEED_UPDATE_PARAM;

		// start check flash key data valid
		//ALOGD("%s, start check flash key data valid\n", __func__);
		if (check_hex_data_have_header_valid(&ori_cal_crc32, CC_MAX_DATA_SIZE, ori_len, ori_buf) < 0)
			return CC_PARAM_CHECK_ERROR_NEED_UPDATE_PARAM;

		if (parse_cal_crc32 != ori_cal_crc32) {
			//ALOGE("%s, parse data not equal flash data(0x%08X, 0x%08X)\n", __func__, parse_cal_crc32, ori_cal_crc32);
			return CC_PARAM_CHECK_ERROR_NEED_UPDATE_PARAM;
		}
		// end check parse data valid
	} else {
		// start check parse data valid
		//ALOGD("%s, start check parse data valid\n", __func__);
		if (check_string_data_have_header_valid(&parse_cal_crc32, (char *)parse_buf, CC_HEAD_CHKSUM_LEN, CC_VERSION_LEN) < 0)
			return CC_PARAM_CHECK_ERROR_NOT_NEED_UPDATE_PARAM;

		// start check flash key data valid
		//ALOGD("%s, start check flash key data valid\n", __func__);
		if (check_string_data_have_header_valid(&ori_cal_crc32, (char *)ori_buf, CC_HEAD_CHKSUM_LEN, CC_VERSION_LEN) < 0)
			return CC_PARAM_CHECK_ERROR_NEED_UPDATE_PARAM;

		if (parse_cal_crc32 != ori_cal_crc32) {
			//ALOGE("%s, parse data not equal flash data(0x%08X, 0x%08X)\n", __func__, parse_cal_crc32, ori_cal_crc32);
			return CC_PARAM_CHECK_ERROR_NEED_UPDATE_PARAM;
		}
		// end check parse data valid
	}

	//ALOGD("%s, param check ok!\n", __func__);
	return CC_PARAM_CHECK_OK;
}

static int handle_integrity_flag(void)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("start", "start_tag", "null");
	ITEM_LOGD("%s, start_tag is (%s)\n", __func__, ini_value);
	if (strcasecmp(ini_value, "amlogic_start")) {
		ALOGE("%s, start_tag (%s) is error!!!\n", __func__, ini_value);
		return -1;
	}

	ini_value = IniGetString("end", "end_tag", "null");
	ITEM_LOGD("%s, end_tag is (%s)\n", __func__, ini_value);
	if (strcasecmp(ini_value, "amlogic_end")) {
		ITEM_LOGE("%s, end_tag (%s) is error!!!\n", __func__, ini_value);
		return -1;
	}

	return 0;
}

static int handle_lcd_basic(struct lcd_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("lcd_Attr", "model_name", "null");
	ITEM_LOGD("%s, model_name is (%s)\n", __func__, ini_value);
	strncpy(p_attr->basic.model_name, ini_value, CC_LCD_NAME_LEN_MAX);

	ini_value = IniGetString("lcd_Attr", "interface", "null");
	ITEM_LOGD("%s, interface is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "LCD_TTL") == 0)
		p_attr->basic.lcd_type = LCD_TTL;
	else if (strcmp(ini_value, "LCD_LVDS") == 0)
		p_attr->basic.lcd_type = LCD_LVDS;
	else if (strcmp(ini_value, "LCD_VBYONE") == 0)
		p_attr->basic.lcd_type = LCD_VBYONE;
	else if (strcmp(ini_value, "LCD_MIPI") == 0)
		p_attr->basic.lcd_type = LCD_MIPI;
	else if (strcmp(ini_value, "LCD_MLVDS") == 0)
		p_attr->basic.lcd_type = LCD_MLVDS;
	else if (strcmp(ini_value, "LCD_P2P") == 0)
		p_attr->basic.lcd_type = LCD_P2P;
	else
		p_attr->basic.lcd_type = LCD_TYPE_MAX;

	ini_value = IniGetString("lcd_Attr", "lcd_bits", "10");
	ITEM_LOGD("%s, lcd_bits is (%s)\n", __func__, ini_value);
	p_attr->basic.lcd_bits = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "screen_width", "16");
	ITEM_LOGD("%s, screen_width is (%s)\n", __func__, ini_value);
	p_attr->basic.screen_width = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "screen_height", "9");
	ITEM_LOGD("%s, screen_height is (%s)\n", __func__, ini_value);
	p_attr->basic.screen_height = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_lcd_timming(struct lcd_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("lcd_Attr", "h_active", "1920");
	ITEM_LOGD("%s, h_active is (%s)\n", __func__, ini_value);
	p_attr->timming.h_active = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "v_active", "1080");
	ITEM_LOGD("%s, v_active is (%s)\n", __func__, ini_value);
	p_attr->timming.v_active = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "h_period", "2200");
	ITEM_LOGD("%s, h_period is (%s)\n", __func__, ini_value);
	p_attr->timming.h_period = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "v_period", "1125");
	ITEM_LOGD("%s, v_period is (%s)\n", __func__, ini_value);
	p_attr->timming.v_period = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "hsync_width", "44");
	ITEM_LOGD("%s, hsync_width is (%s)\n", __func__, ini_value);
	p_attr->timming.hsync_width = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "hsync_bp", "148");
	ITEM_LOGD("%s, hsync_bp is (%s)\n", __func__, ini_value);
	p_attr->timming.hsync_bp = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "hsync_pol", "0");
	ITEM_LOGD("%s, hsync_pol is (%s)\n", __func__, ini_value);
	p_attr->timming.hsync_pol = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "vsync_width", "5");
	ITEM_LOGD("%s, vsync_width is (%s)\n", __func__, ini_value);
	p_attr->timming.vsync_width = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "vsync_bp", "30");
	ITEM_LOGD("%s, vsync_bp is (%s)\n", __func__, ini_value);
	p_attr->timming.vsync_bp = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "vsync_pol", "0");
	ITEM_LOGD("%s, vsync_pol is (%s)\n", __func__, ini_value);
	p_attr->timming.vsync_pol = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_lcd_customer(struct lcd_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("lcd_Attr", "fr_adjust_type", "0");
	ITEM_LOGD("%s, fr_adjust_type is (%s)\n", __func__, ini_value);
	p_attr->customer.fr_adjust_type = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "ss_level", "0");
	ITEM_LOGD("%s, ss_level is (%s)\n", __func__, ini_value);
	p_attr->customer.ss_level = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "clk_auto_gen", "1");
	ITEM_LOGD("%s, clk_auto_gen is (%s)\n", __func__, ini_value);
	p_attr->customer.clk_auto_gen = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "pixle_clk", "0");
	ITEM_LOGD("%s, pixle_clk is (%s)\n", __func__, ini_value);
	p_attr->customer.pixle_clk = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "h_period_min", "0");
	ITEM_LOGD("%s, h_period_min is (%s)\n", __func__, ini_value);
	p_attr->customer.h_period_min = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "h_period_max", "0");
	ITEM_LOGD("%s, h_period_max is (%s)\n", __func__, ini_value);
	p_attr->customer.h_period_max = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "v_period_min", "0");
	ITEM_LOGD("%s, v_period_min is (%s)\n", __func__, ini_value);
	p_attr->customer.v_period_min = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "v_period_max", "0");
	ITEM_LOGD("%s, v_period_max is (%s)\n", __func__, ini_value);
	p_attr->customer.v_period_max = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "pixle_clk_min", "0");
	ITEM_LOGD("%s, pixle_clk_min is (%s)\n", __func__, ini_value);
	p_attr->customer.pixle_clk_min = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "pixle_clk_max", "0");
	ITEM_LOGD("%s, pixle_clk_max is (%s)\n", __func__, ini_value);
	p_attr->customer.pixle_clk_max = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "vlock_val_0", "0");
	ITEM_LOGD("%s, vlock_val_0 is (%s)\n", __func__, ini_value);
	p_attr->customer.vlock_val_0 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "vlock_val_1", "0");
	ITEM_LOGD("%s, vlock_val_1 is (%s)\n", __func__, ini_value);
	p_attr->customer.vlock_val_1 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "vlock_val_2", "0");
	ITEM_LOGD("%s, vlock_val_2 is (%s)\n", __func__, ini_value);
	p_attr->customer.vlock_val_2 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "vlock_val_3", "0");
	ITEM_LOGD("%s, vlock_val_3 is (%s)\n", __func__, ini_value);
	p_attr->customer.vlock_val_3 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "customer_value_9", "0");
	ITEM_LOGD("%s, customer_value_9 is (%s)\n", __func__, ini_value);
	p_attr->customer.customer_value_9 = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_lcd_interface(struct lcd_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("lcd_Attr", "if_attr_0", "0");
	ITEM_LOGD("%s, if_attr_0 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_0 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_1", "0");
	ITEM_LOGD("%s, if_attr_1 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_1 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_2", "0");
	ITEM_LOGD("%s, if_attr_2 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_2 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_3", "0");
	ITEM_LOGD("%s, if_attr_3 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_3 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_4", "0");
	ITEM_LOGD("%s, if_attr_4 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_4 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_5", "0");
	ITEM_LOGD("%s, if_attr_5 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_5 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_6", "0");
	ITEM_LOGD("%s, if_attr_6 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_6 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_7", "0");
	ITEM_LOGD("%s, if_attr_7 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_7 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_8", "0");
	ITEM_LOGD("%s, if_attr_8 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_8 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_Attr", "if_attr_9", "0");
	ITEM_LOGD("%s, if_attr_9 is (%s)\n", __func__, ini_value);
	p_attr->interface.if_attr_9 = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_lcd_pwr(struct lcd_attr_s *p_attr)
{
	int i = 0, tmp_cnt = 0, tmp_base_ind = 0;
	const char *ini_value = NULL;
	unsigned int tmp_buf[1024];

	ini_value = IniGetString("lcd_Attr", "power_on_step", "null");
	ITEM_LOGD("%s, power_on_step is (%s)\n", __func__, ini_value);
	tmp_cnt = transBufferData(ini_value, tmp_buf + 0);
	g_lcd_pwr_on_seq_cnt = tmp_cnt / CC_LCD_PWR_ITEM_CNT;
	for (i = 0; i < g_lcd_pwr_on_seq_cnt; i++) {
		tmp_base_ind = i * CC_LCD_PWR_ITEM_CNT;
		p_attr->pwr[i].pwr_step_type = tmp_buf[tmp_base_ind + 0];
		p_attr->pwr[i].pwr_step_index = tmp_buf[tmp_base_ind + 1];
		p_attr->pwr[i].pwr_step_val = tmp_buf[tmp_base_ind + 2];
		p_attr->pwr[i].pwr_step_delay = tmp_buf[tmp_base_ind + 3];
	}

	ini_value = IniGetString("lcd_Attr", "power_off_step", "null");
	ITEM_LOGD("%s, power_off_step is (%s)\n", __func__, ini_value);
	tmp_cnt = transBufferData(ini_value, tmp_buf + tmp_cnt);
	g_lcd_pwr_off_seq_cnt = tmp_cnt / CC_LCD_PWR_ITEM_CNT;
	for (i = 0; i < g_lcd_pwr_off_seq_cnt; i++) {
		tmp_base_ind = (g_lcd_pwr_on_seq_cnt + i)* CC_LCD_PWR_ITEM_CNT;
		p_attr->pwr[i + g_lcd_pwr_on_seq_cnt].pwr_step_type = tmp_buf[tmp_base_ind + 0];
		p_attr->pwr[i + g_lcd_pwr_on_seq_cnt].pwr_step_index = tmp_buf[tmp_base_ind + 1];
		p_attr->pwr[i + g_lcd_pwr_on_seq_cnt].pwr_step_val = tmp_buf[tmp_base_ind + 2];
		p_attr->pwr[i + g_lcd_pwr_on_seq_cnt].pwr_step_delay = tmp_buf[tmp_base_ind + 3];
	}

	return 0;
}

static int handle_lcd_header(struct lcd_attr_s *p_attr)
{
	const char *ini_value = NULL;

	gLcdDataCnt = 0;
	gLcdDataCnt += sizeof(struct lcd_header_s);
	gLcdDataCnt += sizeof(struct lcd_basic_s);
	gLcdDataCnt += sizeof(struct lcd_timming_s);
	gLcdDataCnt += sizeof(struct lcd_customer_s);
	gLcdDataCnt += sizeof(struct lcd_interface_s);

	gLcdDataCnt += sizeof(struct lcd_pwr_s) * g_lcd_pwr_on_seq_cnt;
	gLcdDataCnt += sizeof(struct lcd_pwr_s) * g_lcd_pwr_off_seq_cnt;

	p_attr->head.data_len = gLcdDataCnt;

	ini_value = IniGetString("lcd_Attr", "version", "null");
	ITEM_LOGD("%s, version is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "null") == 0)
		p_attr->head.version = 0;
	else
		p_attr->head.version = strtoul(ini_value, NULL, 0);

	p_attr->head.rev = 0;
	p_attr->head.crc32 = CalCRC32(0, (((unsigned char *)p_attr) + 4), gLcdDataCnt - 4);

	return 0;
}

static int handle_lcd_ext_basic(struct lcd_ext_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("lcd_ext_Attr", "ext_name", "null");
	ITEM_LOGD("%s, ext_name is (%s)\n", __func__, ini_value);
	strncpy(p_attr->basic.ext_name, ini_value, CC_LCD_EXT_NAME_LEN_MAX);

	ini_value = IniGetString("lcd_ext_Attr", "ext_index", "0xff");
	ITEM_LOGD("%s, ext_index is (%s)\n", __func__, ini_value);
	p_attr->basic.ext_index = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_ext_Attr", "ext_type", "null");
	ITEM_LOGD("%s, ext_type is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "LCD_EXTERN_I2C") == 0)
		p_attr->basic.ext_type = LCD_EXTERN_I2C;
	else if (strcmp(ini_value, "LCD_EXTERN_SPI") == 0)
		p_attr->basic.ext_type = LCD_EXTERN_SPI;
	else if (strcmp(ini_value, "LCD_EXTERN_MIPI") == 0)
		p_attr->basic.ext_type = LCD_EXTERN_MIPI;
	else
		p_attr->basic.ext_type = LCD_EXTERN_MAX;

	ini_value = IniGetString("lcd_ext_Attr", "ext_status", "0");
	ITEM_LOGD("%s, ext_status is (%s)\n", __func__, ini_value);
	p_attr->basic.ext_status = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_lcd_ext_type(struct lcd_ext_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("lcd_ext_Attr", "value_0", "null");
	ITEM_LOGD("%s, value_0 is (%s)\n", __func__, ini_value);
	p_attr->type.value_0 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_ext_Attr", "value_1", "null");
	ITEM_LOGD("%s, value_1 is (%s)\n", __func__, ini_value);
	p_attr->type.value_1 = strtoul(ini_value, NULL, 0);

	if (p_attr->basic.ext_type == LCD_EXTERN_I2C)
		p_attr->type.value_2 = LCD_EXTERN_I2C_BUS_INVALID;
	else {
		ini_value = IniGetString("lcd_ext_Attr", "value_2", "null");
		ITEM_LOGD("%s, value_2 is (%s)\n", __func__, ini_value);
		p_attr->type.value_2 = strtoul(ini_value, NULL, 0);
	}

	ini_value = IniGetString("lcd_ext_Attr", "value_3", "null");
	ITEM_LOGD("%s, value_3 is (%s)\n", __func__, ini_value);
	p_attr->type.value_3 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_ext_Attr", "value_4", "null");
	ITEM_LOGD("%s, value_4 is (%s)\n", __func__, ini_value);
	p_attr->type.value_4 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_ext_Attr", "value_5", "null");
	ITEM_LOGD("%s, value_5 is (%s)\n", __func__, ini_value);
	p_attr->type.value_5 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_ext_Attr", "value_6", "null");
	ITEM_LOGD("%s, value_6 is (%s)\n", __func__, ini_value);
	p_attr->type.value_6 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_ext_Attr", "value_7", "null");
	ITEM_LOGD("%s, value_7 is (%s)\n", __func__, ini_value);
	p_attr->type.value_7 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_ext_Attr", "value_8", "null");
	ITEM_LOGD("%s, value_8 is (%s)\n", __func__, ini_value);
	p_attr->type.value_8 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("lcd_ext_Attr", "value_9", "null");
	ITEM_LOGD("%s, value_9 is (%s)\n", __func__, ini_value);
	p_attr->type.value_9 = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_lcd_ext_cmd_data(struct lcd_ext_attr_s *p_attr)
{
	int i = 0, tmp_cnt = 0, tmp_off = 0;
	const char *ini_value = NULL;
	unsigned int tmp_buf[2048];


	ini_value = IniGetString("lcd_ext_Attr", "init_on", "null");
	ITEM_LOGD("%s, init_on is (%s)\n", __func__, ini_value);
	tmp_cnt = transBufferData(ini_value, tmp_buf);
	if (tmp_cnt > LCD_EXTERN_INIT_ON_MAX) {
		printf("error: %s: invalid init_on data\n", __func__);
		p_attr->cmd_data[0] = LCD_EXTERN_INIT_END;
		p_attr->cmd_data[1] = 0;
		gLcdExtInitOnCnt = 2;
	} else {
		for (i = 0; i < tmp_cnt; i++)
			p_attr->cmd_data[i] = tmp_buf[i];
		gLcdExtInitOnCnt = tmp_cnt;
	}

	tmp_off = gLcdExtInitOnCnt;
	ini_value = IniGetString("lcd_ext_Attr", "init_off", "null");
	ITEM_LOGD("%s, init_off is (%s)\n", __func__, ini_value);
	tmp_cnt = transBufferData(ini_value, tmp_buf);
	if (tmp_cnt > LCD_EXTERN_INIT_ON_MAX) {
		printf("error: %s: invalid init_off data\n", __func__);
		p_attr->cmd_data[tmp_off+0] = LCD_EXTERN_INIT_END;
		p_attr->cmd_data[tmp_off+1] = 0;
		gLcdExtInitOnCnt = 2;
	} else {
		for (i = 0; i < tmp_cnt; i++)
			p_attr->cmd_data[tmp_off+i] = tmp_buf[i];
		gLcdExtInitOffCnt = tmp_cnt;
	}

#if 0
	for (i = 0; i < gLcdExtInitOnCnt; i++)
		ALOGD("%s, init_on_data[%d] = 0x%02x\n", __func__, i, p_attr->cmd_data[i]);

	for (i = 0; i < gLcdExtInitOffCnt; i++)
		ALOGD("%s, init_off_data[%d] = 0x%02x\n", __func__, i, p_attr->cmd_data[tmp_off+i]);
#endif

	return 0;
}

static int lcd_ext_data_to_buf(unsigned char tmp_buf[], struct lcd_ext_attr_s *p_attr)
{
	int i = 0;
	int tmp_len = 0, tmp_off = 0;

	tmp_off = 0;

	tmp_len = sizeof(struct lcd_ext_header_s);
	memcpy((void *)(tmp_buf + tmp_off), (void *)(&p_attr->head), tmp_len);
	tmp_off += tmp_len;

	tmp_len = sizeof(struct lcd_ext_basic_s);
	memcpy((void *)(tmp_buf + tmp_off), (void *)(&p_attr->basic), tmp_len);
	tmp_off += tmp_len;

	tmp_len = sizeof(struct lcd_ext_type_s);
	memcpy((void *)(tmp_buf + tmp_off), (void *)(&p_attr->type), tmp_len);
	tmp_off += tmp_len;

	tmp_len = gLcdExtInitOnCnt;
	for (i = 0; i < gLcdExtInitOnCnt; i++)
		tmp_buf[tmp_off + i] = p_attr->cmd_data[i];
	tmp_off += tmp_len;

	for (i = 0; i < gLcdExtInitOffCnt; i++)
		tmp_buf[tmp_off + i] = p_attr->cmd_data[tmp_len+i];

	return 0;
}

static int handle_lcd_ext_header(struct lcd_ext_attr_s *p_attr)
{
	const char *ini_value = NULL;
	unsigned char *tmp_buf = NULL;

	tmp_buf = (unsigned char *) malloc(CC_MAX_TEMP_BUF_SIZE);
	if (tmp_buf == NULL) {
		ALOGE("%s, malloc buffer memory error!!!\n", __func__);
		return -1;
	}

	gLcdExtDataCnt = 0;
	gLcdExtDataCnt += sizeof(struct lcd_ext_header_s);
	gLcdExtDataCnt += sizeof(struct lcd_ext_basic_s);
	gLcdExtDataCnt += sizeof(struct lcd_ext_type_s);

	gLcdExtDataCnt += gLcdExtInitOnCnt;
	gLcdExtDataCnt += gLcdExtInitOffCnt;

	p_attr->head.data_len = gLcdExtDataCnt;

	ini_value = IniGetString("lcd_ext_Attr", "version", "null");
	ITEM_LOGD("%s, version is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "null") == 0)
		p_attr->head.version = 0;
	else
		p_attr->head.version = strtoul(ini_value, NULL, 0);

	p_attr->head.rev = 0;

	memset((void *)tmp_buf, 0, CC_MAX_TEMP_BUF_SIZE);
	lcd_ext_data_to_buf(tmp_buf, p_attr);
	p_attr->head.crc32 = CalCRC32(0, (tmp_buf + 4), gLcdExtDataCnt - 4);

	ITEM_LOGD("%s, gLcdExtDataCnt = %d\n", __func__, gLcdExtDataCnt);

	free(tmp_buf);
	tmp_buf = NULL;

	return 0;
}

static int handle_bl_basic(struct bl_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("Backlight_Attr", "bl_name", "null");
	ITEM_LOGD("%s, bl_name is (%s)\n", __func__, ini_value);
	strncpy(p_attr->basic.bl_name, ini_value, CC_BL_NAME_LEN_MAX);

	return 0;
}

static int handle_bl_level(struct bl_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("Backlight_Attr", "bl_level_uboot", "0");
	ITEM_LOGD("%s, bl_level_uboot is (%s)\n", __func__, ini_value);
	p_attr->level.bl_level_uboot = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_level_kernel", "0");
	ITEM_LOGD("%s, bl_level_kernel is (%s)\n", __func__, ini_value);
	p_attr->level.bl_level_kernel = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_level_max", "0");
	ITEM_LOGD("%s, bl_level_max is (%s)\n", __func__, ini_value);
	p_attr->level.bl_level_max = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_level_min", "0");
	ITEM_LOGD("%s, bl_level_min is (%s)\n", __func__, ini_value);
	p_attr->level.bl_level_min = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_level_mid", "0");
	ITEM_LOGD("%s, bl_level_mid is (%s)\n", __func__, ini_value);
	p_attr->level.bl_level_mid = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_level_mid_mapping", "0");
	ITEM_LOGD("%s, bl_level_mid_mapping is (%s)\n", __func__, ini_value);
	p_attr->level.bl_level_mid_mapping = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_bl_method(struct bl_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("Backlight_Attr", "bl_method", "null");
	ITEM_LOGD("%s, bl_method is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "BL_CTRL_GPIO") == 0)
		p_attr->method.bl_method = BL_CTRL_GPIO;
	else if (strcmp(ini_value, "BL_CTRL_PWM") == 0)
		p_attr->method.bl_method = BL_CTRL_PWM;
	else if (strcmp(ini_value, "BL_CTRL_PWM_COMBO") == 0)
		p_attr->method.bl_method = BL_CTRL_PWM_COMBO;
	else if (strcmp(ini_value, "BL_CTRL_LOCAL_DIMING") == 0)
		p_attr->method.bl_method = BL_CTRL_LOCAL_DIMMING;
	else if (strcmp(ini_value, "BL_CTRL_LOCAL_DIMMING") == 0)
		p_attr->method.bl_method = BL_CTRL_LOCAL_DIMMING;
	else if (strcmp(ini_value, "BL_CTRL_EXTERN") == 0)
		p_attr->method.bl_method = BL_CTRL_EXTERN;
	else
		p_attr->method.bl_method = BL_CTRL_MAX;

	ini_value = IniGetString("Backlight_Attr", "bl_en_gpio", "0xff");
	ITEM_LOGD("%s, bl_en_gpio is (%s)\n", __func__, ini_value);
	p_attr->method.bl_en_gpio = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_en_gpio_on", "0");
	ITEM_LOGD("%s, bl_en_gpio_on is (%s)\n", __func__, ini_value);
	p_attr->method.bl_en_gpio_on = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_en_gpio_off", "0");
	ITEM_LOGD("%s, bl_en_gpio_off is (%s)\n", __func__, ini_value);
	p_attr->method.bl_en_gpio_off = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_on_delay", "0");
	ITEM_LOGD("%s, bl_on_delay is (%s)\n", __func__, ini_value);
	p_attr->method.bl_on_delay = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_off_delay", "0");
	ITEM_LOGD("%s, bl_off_delay is (%s)\n", __func__, ini_value);
	p_attr->method.bl_off_delay = strtoul(ini_value, NULL, 0);

	return 0;
}

static int getPWMMethod(const char *ini_value, int def_val)
{
	if (strcmp(ini_value, "BL_PWM_NEGATIVE") == 0)
		return BL_PWM_NEGATIVE;
	else if (strcmp(ini_value, "BL_PWM_POSITIVE") == 0)
		return BL_PWM_POSITIVE;
	else
		return def_val;
}

static int getPWMPortIndVal(const char *ini_value, int def_val)
{
	if (strcmp(ini_value, "BL_PWM_A") == 0)
		return BL_PWM_A;
	else if (strcmp(ini_value, "BL_PWM_B") == 0)
		return BL_PWM_B;
	else if (strcmp(ini_value, "BL_PWM_C") == 0)
		return BL_PWM_C;
	else if (strcmp(ini_value, "BL_PWM_D") == 0)
		return BL_PWM_D;
	else if (strcmp(ini_value, "BL_PWM_E") == 0)
		return BL_PWM_E;
	else if (strcmp(ini_value, "BL_PWM_F") == 0)
		return BL_PWM_F;
	else if (strcmp(ini_value, "BL_PWM_VS") == 0)
		return BL_PWM_VS;
	else
		return def_val;
}

static int handle_bl_pwm(struct bl_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("Backlight_Attr", "pwm_method", "BL_PWM_POSITIVE");
	ITEM_LOGD("%s, pwm_method is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_method = getPWMMethod(ini_value, BL_PWM_POSITIVE);

	ini_value = IniGetString("Backlight_Attr", "pwm_port", "null");
	ITEM_LOGD("%s, pwm_port is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_port = getPWMPortIndVal(ini_value, BL_PWM_MAX);

	ini_value = IniGetString("Backlight_Attr", "pwm_freq", "0");
	ITEM_LOGD("%s, pwm_freq is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_freq = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm_duty_max", "0");
	ITEM_LOGD("%s, pwm_duty_max is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_duty_max = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm_duty_min", "0");
	ITEM_LOGD("%s, pwm_duty_min is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_duty_min = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm_gpio", "0");
	ITEM_LOGD("%s, pwm_gpio is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_gpio = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm_gpio_off", "0");
	ITEM_LOGD("%s, pwm_gpio_off is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_gpio_off = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm2_method", "BL_PWM_POSITIVE");
	ITEM_LOGD("%s, pwm2_method is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_method = getPWMMethod(ini_value, BL_PWM_POSITIVE);

	ini_value = IniGetString("Backlight_Attr", "pwm2_port", "null");
	ITEM_LOGD("%s, pwm2_port is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_port = getPWMPortIndVal(ini_value, BL_PWM_MAX);

	ini_value = IniGetString("Backlight_Attr", "pwm2_freq", "0");
	ITEM_LOGD("%s, pwm2_freq is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_freq = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm2_duty_max", "0");
	ITEM_LOGD("%s, pwm2_duty_max is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_duty_max = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm2_duty_min", "0");
	ITEM_LOGD("%s, pwm2_duty_min is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_duty_min = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm2_gpio", "0");
	ITEM_LOGD("%s, pwm2_gpio is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_gpio = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm2_gpio_off", "0");
	ITEM_LOGD("%s, pwm2_gpio_off is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_gpio_off = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm_on_delay", "0");
	ITEM_LOGD("%s, pwm_on_delay is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_on_delay = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm_off_delay", "0");
	ITEM_LOGD("%s, pwm_off_delay is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_off_delay = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm_level_max", "0");
	ITEM_LOGD("%s, pwm_level_max is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_level_max = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm_level_min", "0");
	ITEM_LOGD("%s, pwm_level_min is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm_level_min = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm2_level_max", "0");
	ITEM_LOGD("%s, pwm2_level_max is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_level_max = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "pwm2_level_min", "0");
	ITEM_LOGD("%s, pwm2_level_min is (%s)\n", __func__, ini_value);
	p_attr->pwm.pwm2_level_min = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_bl_ldim(struct bl_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("Backlight_Attr", "bl_ldim_row", "1");
	ITEM_LOGD("%s, bl_ldim_row is (%s)\n", __func__, ini_value);
	p_attr->ldim.ldim_row = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_ldim_col", "1");
	ITEM_LOGD("%s, bl_ldim_col is (%s)\n", __func__, ini_value);
	p_attr->ldim.ldim_col = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_ldim_mode", "null");
	ITEM_LOGD("%s, bl_ldim_mode is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "LDIM_LR_SIDE") == 0)
		p_attr->ldim.ldim_mode = LDIM_MODE_LR_SIDE;
	else if (strcmp(ini_value, "LDIM_TB_SIDE") == 0)
		p_attr->ldim.ldim_mode = LDIM_MODE_TB_SIDE;
	else if (strcmp(ini_value, "LDIM_DIRECT") == 0)
		p_attr->ldim.ldim_mode = LDIM_MODE_DIRECT;
	else
		p_attr->ldim.ldim_mode = LDIM_MODE_TB_SIDE;

	ini_value = IniGetString("Backlight_Attr", "bl_ldim_dev_index", "0xff");
	ITEM_LOGD("%s, bl_ldim_dev_index is (%s)\n", __func__, ini_value);
	p_attr->ldim.ldim_dev_index = strtoul(ini_value, NULL, 0);

	p_attr->ldim.ldim_attr_4 = 0;
	p_attr->ldim.ldim_attr_5 = 0;
	p_attr->ldim.ldim_attr_6 = 0;
	p_attr->ldim.ldim_attr_7 = 0;
	p_attr->ldim.ldim_attr_8 = 0;
	p_attr->ldim.ldim_attr_9 = 0;

	return 0;
}

static int handle_bl_custome(struct bl_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("Backlight_Attr", "bl_custome_val_0", "0");
	ITEM_LOGD("%s, bl_custome_val_0 is (%s)\n", __func__, ini_value);
	p_attr->custome.custome_val_0 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_custome_val_1", "0");
	ITEM_LOGD("%s, bl_custome_val_1 is (%s)\n", __func__, ini_value);
	p_attr->custome.custome_val_1 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_custome_val_2", "0");
	ITEM_LOGD("%s, bl_custome_val_2 is (%s)\n", __func__, ini_value);
	p_attr->custome.custome_val_2 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_custome_val_3", "0");
	ITEM_LOGD("%s, bl_custome_val_3 is (%s)\n", __func__, ini_value);
	p_attr->custome.custome_val_3 = strtoul(ini_value, NULL, 0);

	ini_value = IniGetString("Backlight_Attr", "bl_custome_val_4", "0");
	ITEM_LOGD("%s, bl_custome_val_4 is (%s)\n", __func__, ini_value);
	p_attr->custome.custome_val_4 = strtoul(ini_value, NULL, 0);

	return 0;
}

static int handle_bl_header(struct bl_attr_s *p_attr)
{
	const char *ini_value = NULL;

	ini_value = IniGetString("Backlight_Attr", "version", "null");
	ITEM_LOGD("%s, version is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "null") == 0)
		p_attr->head.version = 0;
	else
		p_attr->head.version = strtoul(ini_value, NULL, 0);

	gBlDataCnt = 0;
	gBlDataCnt += sizeof(struct bl_header_s);
	gBlDataCnt += sizeof(struct bl_basic_s);
	gBlDataCnt += sizeof(struct bl_level_s);
	gBlDataCnt += sizeof(struct bl_method_s);
	gBlDataCnt += sizeof(struct bl_pwm_s);
	if (p_attr->head.version == 2) {
		gBlDataCnt += sizeof(struct bl_ldim_s);
		gBlDataCnt += sizeof(struct bl_custome_s);
	}
	p_attr->head.data_len = gBlDataCnt;

	p_attr->head.rev = 0;
	p_attr->head.crc32 = CalCRC32(0, (((unsigned char *)p_attr) + 4), gBlDataCnt - 4);

	return 0;
}

static int handle_panel_misc(struct panel_misc_s *p_misc)
{
	int tmp_val = 0;
	const char *ini_value = NULL;
	char buf[64] = {0};

	ini_value = IniGetString("panel_misc", "panel_misc_version", "null");
	ITEM_LOGD("%s, panel_misc_version is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "null") == 0) {
		strcpy(p_misc->version, "V001");
	} else {
		tmp_val = strtol(ini_value, NULL, 0);
		if (tmp_val < 1)
			tmp_val = 1;

		sprintf(p_misc->version, "V%03d", tmp_val);
	}

	ini_value = IniGetString("panel_misc", "outputmode", "null");
	ITEM_LOGD("%s, outputmode is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "null") == 0)
		strcpy(p_misc->outputmode, "1080p60hz");
	else
		strcpy(p_misc->outputmode, ini_value);

	ini_value = IniGetString("panel_misc", "panel_reverse", "null");
	ITEM_LOGD("%s, panel_reverse is (%s)\n", __func__, ini_value);
	if (strcmp(ini_value, "null") == 0 || strcmp(ini_value, "0") == 0 ||
		strcmp(ini_value, "false") == 0 || strcmp(ini_value, "no_rev") == 0) {
		p_misc->panel_reverse = 0;
	} else if (strcmp(ini_value, "true") == 0 || strcmp(ini_value, "1") == 0 ||
		strcmp(ini_value, "have_rev") == 0) {
		p_misc->panel_reverse = 1;
	} else {
		p_misc->panel_reverse = 0;
	}

	sprintf(buf, "setenv outputmode %s", p_misc->outputmode);
	run_command(buf, 0);
	if (p_misc->panel_reverse) {
		run_command("setenv panel_reverse 1", 0);
		run_command("setenv osd_reverse all,true", 0);
		run_command("setenv video_reverse 1", 0);
	} else {
		run_command("setenv panel_reverse 0", 0);
		run_command("setenv osd_reverse n", 0);
		run_command("setenv video_reverse 0", 0);
	}

	return 0;
}



static int parse_panel_ini(const char *file_name, struct lcd_attr_s *lcd_attr, struct lcd_ext_attr_s *lcd_ext_attr, struct bl_attr_s *bl_attr, struct panel_misc_s *misc_attr)
{
	memset((void *)lcd_attr, 0, sizeof(struct lcd_attr_s));
	memset((void *)bl_attr, 0, sizeof(struct bl_attr_s));

	IniParserInit();

	if (IniParseFile(file_name) < 0) {
		ALOGE("%s, ini load file error!\n", __func__);
		IniParserUninit();
		return -1;
	}

	// handle integrity flag
	if (handle_integrity_flag() < 0) {
		IniParserUninit();
		return -1;
	}

	// handle lcd attr
	handle_lcd_basic(lcd_attr);
	handle_lcd_timming(lcd_attr);
	handle_lcd_customer(lcd_attr);
	handle_lcd_interface(lcd_attr);
	handle_lcd_pwr(lcd_attr);
	handle_lcd_header(lcd_attr);

	// handle lcd extern attr
	handle_lcd_ext_basic(lcd_ext_attr);
	handle_lcd_ext_type(lcd_ext_attr);
	handle_lcd_ext_cmd_data(lcd_ext_attr);
	handle_lcd_ext_header(lcd_ext_attr);

	// handle bl attr
	handle_bl_basic(bl_attr);
	handle_bl_level(bl_attr);
	handle_bl_method(bl_attr);
	handle_bl_pwm(bl_attr);
	handle_bl_ldim(bl_attr);
	handle_bl_custome(bl_attr);
	handle_bl_header(bl_attr);

	handle_panel_misc(misc_attr);

	IniParserUninit();

	return 0;
}

int handle_panel_ini(void)
{
	int tmp_len = 0;
	unsigned char *tmp_buf = NULL;
	unsigned char *parse_buf = NULL;
	struct lcd_attr_s lcd_attr;
	struct lcd_ext_attr_s lcd_ext_attr;
	struct bl_attr_s bl_attr;
	struct panel_misc_s misc_attr;
	char *file_name, *tmp;
	char outputmode_str[64] = {0}, reverse_str[10] = {0};
	unsigned char env_save = 0, reverse_tmp = 0;

	tmp = getenv("outputmode");
	if (tmp == NULL)
		strcpy(outputmode_str, "null");
	else
		strcpy(outputmode_str, tmp);
	tmp = getenv("panel_reverse");
	if (tmp == NULL)
		strcpy(reverse_str, "null");
	else
		strcpy(reverse_str, tmp);

	file_name = getenv("model_panel");
	if (file_name == NULL) {
		ALOGE("%s, model_panel path error!!!\n", __func__);
		return -1;
	}

	tmp_buf = (unsigned char *) malloc(CC_MAX_DATA_SIZE);
	if (tmp_buf == NULL) {
		ALOGE("%s, malloc buffer memory error!!!\n", __func__);
		return -1;
	}

	parse_buf = (unsigned char *) malloc(CC_MAX_DATA_SIZE);
	if (parse_buf == NULL) {
		free(tmp_buf);
		tmp_buf = NULL;
		ALOGE("%s, malloc buffer memory error!!!\n", __func__);
		return -1;
	}

	memset((void *)&lcd_attr, 0, sizeof(struct lcd_attr_s));
	memset((void *)&lcd_ext_attr, 0, sizeof(struct lcd_ext_attr_s));
	memset((void *)&bl_attr, 0, sizeof(struct bl_attr_s));
	memset((void *)&misc_attr, 0, sizeof(struct panel_misc_s));

	//init misc attr as default
	strcpy(misc_attr.version, "V001");
	strcpy(misc_attr.outputmode, "1080p60hz");
	misc_attr.panel_reverse = 0;

	// start handle panel ini name
	if (!iniIsFileExist(file_name)) {
		ALOGE("%s, file name \"%s\" not exist.\n", __func__, file_name);
		free(tmp_buf);
		tmp_buf = NULL;
		free(parse_buf);
		parse_buf = NULL;
		return -1;
	}

	if (parse_panel_ini(file_name, &lcd_attr, &lcd_ext_attr, &bl_attr, &misc_attr) < 0) {
		free(tmp_buf);
		tmp_buf = NULL;
		free(parse_buf);
		parse_buf = NULL;
		return -1;
	}

	// start handle lcd param
	memset((void *)tmp_buf, 0, CC_MAX_DATA_SIZE);
	tmp_len = ReadLCDParam(tmp_buf);
	//ALOGD("%s, start check lcd param data (0x%x).\n", __func__, tmp_len);
	if (check_param_valid(0, gLcdDataCnt, (unsigned char*)&lcd_attr, tmp_len, tmp_buf) == CC_PARAM_CHECK_ERROR_NEED_UPDATE_PARAM) {
		ALOGD("%s, check lcd param data error (0x%x), save lcd param.\n", __func__, tmp_len);
		SaveLCDParam(gLcdDataCnt, (unsigned char*)&lcd_attr);
	}
	// end handle lcd param

	// start handle lcd extern param
	memset((void *)tmp_buf, 0, CC_MAX_DATA_SIZE);
	tmp_len = ReadLCDExternParam(tmp_buf);
	//ALOGD("%s, start check lcd extern param data (0x%x).\n", __func__, tmp_len);
	if (check_param_valid(0, gLcdExtDataCnt, (unsigned char*)&lcd_ext_attr, tmp_len, tmp_buf) == CC_PARAM_CHECK_ERROR_NEED_UPDATE_PARAM) {
		ALOGD("%s, check lcd extern param data error (0x%x), save lcd extern param.\n", __func__, tmp_len);
		SaveLCDExternParam(gLcdExtDataCnt, (unsigned char*)&lcd_ext_attr);
	}
	// end handle lcd extern param

	// start handle backlight param
	memset((void *)tmp_buf, 0, CC_MAX_DATA_SIZE);
	tmp_len = ReadBackLightParam(tmp_buf);
	//ALOGD("%s, start check backlight param data (0x%x).\n", __func__, tmp_len);
	if (check_param_valid(0, gBlDataCnt, (unsigned char*)&bl_attr, tmp_len, tmp_buf) == CC_PARAM_CHECK_ERROR_NEED_UPDATE_PARAM) {
		ALOGD("%s, check backlight param data error (0x%x), save backlight param.\n", __func__, tmp_len);
		SaveBackLightParam(gBlDataCnt, (unsigned char*)&bl_attr);
	}
	// end handle backlight param

	// start handle panel misc
	if (strcmp(outputmode_str, "nul1") == 0) {
		env_save = 1;
	} else {
		if (strcmp(outputmode_str, misc_attr.outputmode))
			env_save = 1;
	}
	if (strcmp(reverse_str, "nul1") == 0) {
		env_save = 1;
	} else {
		if (strcmp(reverse_str, "1") == 0)
			reverse_tmp = 1;
		else
			reverse_tmp = 0;
		if (reverse_tmp != misc_attr.panel_reverse)
			env_save = 1;
	}
	if (env_save) {
		ALOGD("%s, save env.\n", __func__);
		run_command("saveenv", 0);
	}
	// end handle panel misc

	free(tmp_buf);
	tmp_buf = NULL;
	free(parse_buf);
	parse_buf = NULL;

	return 0;
}

int parse_model_sum(const char *file_name, char *model_name)
{
	const char *ini_value = NULL;

	IniParserInit();

	if (IniParseFile(file_name) < 0) {
		ALOGE("%s, ini load file error!\n", __func__);
		IniParserUninit();
		return -1;
	}

	ini_value = IniGetString(model_name, "PANELINI_PATH", "null");
	if (strcmp(ini_value, "null") != 0)
		setenv("model_panel", ini_value);
	else
		ALOGE("%s, invalid PANELINI_PATH!!!\n", __func__);

	ini_value = IniGetString(model_name, "EDID_14_FILE_PATH", "null");
	if (strcmp(ini_value, "null") != 0)
		setenv("model_edid", ini_value);
	else
		ALOGE("%s, invalid EDID_14_FILE_PATH!!!\n", __func__);
	/*
	ini_value = IniGetString(model_name, "PQINI_PATH", "null");
	if (strcmp(ini_value, "null") != 0)
		setenv("model_pq", ini_value);

	ini_value = IniGetString(model_name, "AMLOGIC_AUDIO_EFFECT_INI_PATH", "null");
	if (strcmp(ini_value, "null") != 0)
		setenv("model_audio", ini_value);
	*/
	IniParserUninit();

	return 0;
}

const char *get_model_sum_path(void)
{
	return DEFAULT_MODEL_SUM_PATH;
}

int handle_model_list(void)
{
	char *model;

	model = getenv("model_name");
	if (model == NULL) {
		ALOGE("%s, model_name error!!!\n", __func__);
		return -1;
	}
	printf("current model_name: %s\n", model);

	IniParserInit();

	if (IniParseFile(get_model_sum_path()) < 0) {
		ALOGE("%s, ini load file error!\n", __func__);
		IniParserUninit();
		return -1;
	}

	printf("model_name list:\n");
	IniListSection();
	printf("\n");

	IniParserUninit();

	return 0;
}

int handle_model_sum(void)
{
	char *model;
	int ret;

	model = getenv("model_name");
	if (model == NULL) {
		ALOGE("%s, model_name error!!!\n", __func__);
		return -1;
	}
	ret = parse_model_sum(get_model_sum_path(), model);
	if (ret < 0)
		return -1;
	ret = handle_panel_ini();
	return ret;
}

