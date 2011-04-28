
#ifndef __AMLOGIC_BL_EXTERN_H_
#define __AMLOGIC_BL_EXTERN_H_

#include <asm/arch/aml_lcd_gpio.h>

typedef enum {
	BL_EXTERN_I2C = 0,
	BL_EXTERN_SPI,
	BL_EXTERN_OTHER,//panel, pmu, etc...
	BL_EXTERN_MAX,
} Bl_Extern_Type_t;

struct aml_bl_extern_pinmux_t {
	unsigned reg;
	unsigned mux;
};

//global API
struct aml_bl_extern_driver_t {
	char *name;
	Bl_Extern_Type_t type;
	int (*power_on) (void);
	int (*power_off)(void);
	int (*set_level)(unsigned int level);
};

#define BL_EXTERN_GPIO_NONE GPIO_MAX
struct bl_extern_config_t {
	char *name;
	Bl_Extern_Type_t type;
	unsigned int gpio_used;
	int gpio;
	int i2c_addr;
	int i2c_bus;
	int spi_cs;
	int spi_clk;
	int spi_data;
	unsigned int dim_min;
	unsigned int dim_max;
	unsigned int level_min;
	unsigned int level_max;
};

extern void udelay(unsigned long usec);
extern void mdelay(unsigned long msec);

#define bl_extern_gpio_direction_input(gpio)        aml_lcd_gpio_set(gpio, 2)
#define bl_extern_gpio_direction_output(gpio, val)  aml_lcd_gpio_set(gpio, (val ? 1 : 0))

#ifdef CONFIG_AML_BL_EXTERN
extern struct aml_bl_extern_driver_t* aml_bl_extern_get_driver(void);

extern void get_bl_level(struct bl_extern_config_t *bl_ext_cfg);
#endif

#endif

