#ifndef __PAEL_INI_H__
#define __PAEL_INI_H__

#define CC_MAX_TEMP_BUF_SIZE                    (0x1000)
#define CC_MAX_PANEL_ALL_DATA_SIZE              (0x100000)

#ifdef __cplusplus
extern "C" {
#endif

extern int handle_model_list(void);
extern int handle_model_sum(void);

#ifdef __cplusplus
}
#endif

#pragma pack (1)

enum lcd_type_e {
	LCD_TTL = 0,
	LCD_LVDS,
	LCD_VBYONE,
	LCD_MIPI,
	LCD_MLVDS,
	LCD_P2P,
	LCD_TYPE_MAX,
};

enum bl_ctrl_method_e {
	BL_CTRL_GPIO = 0,
	BL_CTRL_PWM,
	BL_CTRL_PWM_COMBO,
	BL_CTRL_LOCAL_DIMMING,
	BL_CTRL_EXTERN,
	BL_CTRL_MAX,
};

enum bl_pwm_method_e {
	BL_PWM_NEGATIVE = 0,
	BL_PWM_POSITIVE,
	BL_PWM_METHOD_MAX,
};

enum bl_pwm_port_e {
	BL_PWM_A = 0,
	BL_PWM_B,
	BL_PWM_C,
	BL_PWM_D,
	BL_PWM_E,
	BL_PWM_F,
	BL_PWM_VS,
	BL_PWM_MAX,
};

enum lcd_ldim_mode_e {
	LDIM_MODE_LR_SIDE = 0,
	LDIM_MODE_TB_SIDE,
	LDIM_MODE_DIRECT,
	LDIM_MODE_MAX,
};

enum lcd_extern_type_e {
	LCD_EXTERN_I2C = 0,
	LCD_EXTERN_SPI,
	LCD_EXTERN_MIPI,
	LCD_EXTERN_MAX,
};
#define LCD_EXTERN_I2C_BUS_INVALID 0xff

#define CC_LCD_NAME_LEN_MAX        (30)

struct lcd_header_s {
	unsigned int crc32;
	unsigned short data_len;
	unsigned short version;
	unsigned short rev;
};

struct lcd_basic_s {
	char model_name[CC_LCD_NAME_LEN_MAX];
	unsigned char lcd_type;
	unsigned char lcd_bits;
	unsigned short screen_width;  /* screen physical width in "mm" unit */
	unsigned short screen_height; /* screen physical height in "mm" unit */
};

struct lcd_timming_s {
	unsigned short h_active; /* Horizontal display area */
	unsigned short v_active; /* Vertical display area */
	unsigned short h_period; /* Horizontal total period time */
	unsigned short v_period; /* Vertical total period time */
	unsigned short hsync_width;
	unsigned short hsync_bp;
	unsigned char hsync_pol;
	unsigned short vsync_width;
	unsigned short vsync_bp;
	unsigned char vsync_pol;
};

struct lcd_customer_s {
	unsigned char fr_adjust_type;
	unsigned char ss_level;
	unsigned char clk_auto_gen;
	unsigned int pixel_clk;
	unsigned short h_period_min;
	unsigned short h_period_max;
	unsigned short v_period_min;
	unsigned short v_period_max;
	unsigned int pixel_clk_min;
	unsigned int pixel_clk_max;
	unsigned char vlock_val_0;
	unsigned char vlock_val_1;
	unsigned char vlock_val_2;
	unsigned char vlock_val_3;
	unsigned int customer_value_9;
};

struct lcd_interface_s {
	unsigned short if_attr_0; //vbyone_attr lane_count
	unsigned short if_attr_1; //vbyone_attr region_num
	unsigned short if_attr_2; //vbyone_attr byte_mode
	unsigned short if_attr_3; //vbyone_attr color_fmt
	unsigned short if_attr_4; //phy_attr vswing_level
	unsigned short if_attr_5; //phy_attr preemphasis_level
	unsigned short if_attr_6; //reversed
	unsigned short if_attr_7; //reversed
	unsigned short if_attr_8; //reversed
	unsigned short if_attr_9; //reversed
};

#define CC_LCD_PWR_ITEM_CNT    (4)
struct lcd_pwr_s {
	unsigned char pwr_step_type;
	unsigned char pwr_step_index;
	unsigned char pwr_step_val;
	unsigned short pwr_step_delay;
};

#define CC_MAX_PWR_SEQ_CNT     (50)

struct lcd_attr_s {
	struct lcd_header_s head;
	struct lcd_basic_s basic;
	struct lcd_timming_s timming;
	struct lcd_customer_s customer;
	struct lcd_interface_s interface;
	struct lcd_pwr_s pwr[CC_MAX_PWR_SEQ_CNT];
};

#define CC_BL_NAME_LEN_MAX        (30)

struct bl_header_s {
	unsigned int crc32;
	unsigned short data_len;
	unsigned short version;
	unsigned short rev;
};

struct bl_basic_s {
	char bl_name[CC_BL_NAME_LEN_MAX];
};

struct bl_level_s {
	unsigned short bl_level_uboot;
	unsigned short bl_level_kernel;
	unsigned short bl_level_max;
	unsigned short bl_level_min;
	unsigned short bl_level_mid;
	unsigned short bl_level_mid_mapping;
};

struct bl_method_s {
	unsigned char bl_method;
	unsigned char bl_en_gpio;
	unsigned char bl_en_gpio_on;
	unsigned char bl_en_gpio_off;
	unsigned short bl_on_delay;
	unsigned short bl_off_delay;
};

struct bl_pwm_s {
	unsigned short pwm_on_delay;
	unsigned short pwm_off_delay;

	unsigned char pwm_method;
	unsigned char pwm_port;
	unsigned int pwm_freq;
	unsigned char pwm_duty_max;
	unsigned char pwm_duty_min;
	unsigned char pwm_gpio;
	unsigned char pwm_gpio_off;

	unsigned char pwm2_method;
	unsigned char pwm2_port;
	unsigned int pwm2_freq;
	unsigned char pwm2_duty_max;
	unsigned char pwm2_duty_min;
	unsigned char pwm2_gpio;
	unsigned char pwm2_gpio_off;

	unsigned short pwm_level_max;
	unsigned short pwm_level_min;
	unsigned short pwm2_level_max;
	unsigned short pwm2_level_min;
};

struct bl_ldim_s {
	unsigned char ldim_row;
	unsigned char ldim_col;
	unsigned char ldim_mode;
	unsigned char ldim_dev_index;

	unsigned short ldim_attr_4;
	unsigned short ldim_attr_5;
	unsigned short ldim_attr_6;
	unsigned short ldim_attr_7;
	unsigned short ldim_attr_8;
	unsigned short ldim_attr_9;
};

struct bl_custome_s {
	unsigned short custome_val_0;
	unsigned short custome_val_1;
	unsigned short custome_val_2;
	unsigned short custome_val_3;
	unsigned short custome_val_4;
};

struct bl_attr_s {
	struct bl_header_s head;
	struct bl_basic_s basic;
	struct bl_level_s level;
	struct bl_method_s method;
	struct bl_pwm_s pwm;
	struct bl_ldim_s ldim;         //v2
	struct bl_custome_s custome;   //v2
};

#define CC_LCD_EXT_NAME_LEN_MAX        (30)

struct lcd_ext_header_s {
	unsigned int crc32;
	unsigned short data_len;
	unsigned short version;
	unsigned short rev;
};

#define LCD_EXTERN_CMD_SIZE_DYNAMIC    0xff
#define LCD_EXTERN_INIT_ON_MAX         1000
#define LCD_EXTERN_INIT_OFF_MAX        100

struct lcd_ext_basic_s {
	char ext_name[CC_LCD_EXT_NAME_LEN_MAX];
	unsigned char ext_index;  // set it as 0
	unsigned char ext_type;   // LCD_EXTERN_I2C, LCD_EXTERN_SPI, LCD_EXTERN_MIPI
	unsigned char ext_status; // 1 is okay, 0 is disable
};

struct lcd_ext_type_s {
	unsigned char value_0;     //i2c_addr           //spi_gpio_cs
	unsigned char value_1;     //i2c_second_addr    //spi_gpio_clk
	unsigned char value_2;     //i2c_bus            //spi_gpio_data
	unsigned char value_3;     //cmd_size           //spi_clk_freq[bit 7:0]  //unit: hz
	unsigned char value_4;                          //spi_clk_freq[bit 15:8]
	unsigned char value_5;                          //spi_clk_freq[bit 23:16]
	unsigned char value_6;                          //spi_clk_freq[bit 31:24]
	unsigned char value_7;                          //spi_clk_pol
	unsigned char value_8;                          //cmd_size
	unsigned char value_9;     //reserved for future usage
};

#define CC_EXT_CMD_MAX_CNT           (300)

#define LCD_EXTERN_INIT_CMD           0x00
#define LCD_EXTERN_INIT_CMD2          0x01  //only for special i2c device
#define LCD_EXTERN_INIT_NONE          0x10
#define LCD_EXTERN_INIT_GPIO          0xf0
#define LCD_EXTERN_INIT_END           0xff

struct lcd_ext_attr_s {
	struct lcd_ext_header_s head;
	struct lcd_ext_basic_s basic;
	struct lcd_ext_type_s type;
	unsigned char cmd_data[LCD_EXTERN_INIT_ON_MAX+LCD_EXTERN_INIT_OFF_MAX];
};

struct panel_misc_s {
	char version[8];
	char outputmode[64];
	unsigned char panel_reverse;
};

#define CC_MAX_SUPPORT_PANEL_CNT          (128)

#define CC_MAX_PANEL_ALL_INFO_TAG_SIZE    (16)
#define CS_PANEL_ALL_INFO_TAG_CONTENT     "panel_all_info"

struct all_info_header_s {
	unsigned int crc32;
	unsigned short data_len;
	unsigned short version;
	unsigned char tag[CC_MAX_PANEL_ALL_INFO_TAG_SIZE];
	unsigned int max_panel_cnt;
	unsigned int cur_panel_cnt;
	unsigned int sec_off;
	unsigned int sec_cnt;
	unsigned int sec_size;
	unsigned int sec_len;
	unsigned int item_head_off;
	unsigned int item_head_cnt;
	unsigned int item_head_size;
	unsigned int item_head_len;
	unsigned int def_flag;
	unsigned char rev[12];
};

#define CC_MAX_PANEL_ALL_ONE_SEC_TAG_SIZE        (16)
#define CC_MAX_PANEL_ALL_ONE_SEC_TAG_CONTENT     "panel_all_data0"

#endif //__PAEL_INI_H__
