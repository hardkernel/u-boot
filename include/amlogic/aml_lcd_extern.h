#ifndef _INC_AMLOGIC_LCD_EXTERN_H_
#define _INC_AMLOGIC_LCD_EXTERN_H_

typedef enum {
	LCD_EXTERN_I2C = 0,
	LCD_EXTERN_SPI,
	LCD_EXTERN_MIPI,
	LCD_EXTERN_MAX,
} Lcd_Extern_Type_t;

#define LCD_EXTERN_INDEX_INVALID   0xff
#define LCD_EXTERN_NAME_LEN_MAX    30
struct lcd_extern_config_t {
	int index;
	char name[LCD_EXTERN_NAME_LEN_MAX];
	Lcd_Extern_Type_t type;
	int status;
	int i2c_addr;
	int i2c_bus;
	int spi_cs;
	int spi_clk;
	int spi_data;
};

//global API
#define LCD_EXT_DRIVER_MAX    10
struct aml_lcd_extern_driver_t {
	struct lcd_extern_config_t config;
	int (*reg_read)  (unsigned char reg, unsigned char *buf);
	int (*reg_write) (unsigned char reg, unsigned char value);
	int (*power_on)(void);
	int (*power_off)(void);
	unsigned char *init_on_cmd_8;
	unsigned char *init_off_cmd_8;
	int (*get_lcd_ext_config)(void);
};

extern struct aml_lcd_extern_driver_t *aml_lcd_extern_get_driver(void);
extern int aml_lcd_extern_probe(char *dtaddr, int index);
extern int aml_lcd_extern_remove(void);

#endif

