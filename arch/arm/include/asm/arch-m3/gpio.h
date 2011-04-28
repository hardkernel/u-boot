#ifndef  __MESON_GPIO_H__
#define	 __MESON_GPIO_H__

#include "io.h"
//#include "gpio_name.h"
typedef enum gpio_bank {
    PREG_PAD_GPIO0 = 0,
    PREG_PAD_GPIO1,
    PREG_PAD_GPIO2,
    PREG_PAD_GPIO3,
    PREG_PAD_GPIO4,
    PREG_PAD_GPIO5,
	PREG_PAD_GPIOAO,
	PREG_JTAG_GPIO,
} gpio_bank_t;


typedef enum gpio_mode {
    GPIO_OUTPUT_MODE,
    GPIO_INPUT_MODE,
} gpio_mode_t;

int set_gpio_mode(gpio_bank_t bank, int bit, gpio_mode_t mode);
gpio_mode_t get_gpio_mode(gpio_bank_t bank, int bit);

int set_gpio_val(gpio_bank_t bank, int bit, unsigned long val);
unsigned long  get_gpio_val(gpio_bank_t bank, int bit);

#define GPIOA_bank_bit0_27(bit)     (PREG_PAD_GPIO0)
#define GPIOA_bit_bit0_27(bit)      (bit)

#define GPIOB_bank_bit0_23(bit)     (PREG_PAD_GPIO1)
#define GPIOB_bit_bit0_23(bit)      (bit)

#define GPIOC_bank_bit0_15(bit)     (PREG_PAD_GPIO2)
#define GPIOC_bit_bit0_15(bit)      (bit)

#define GPIOAO_bank_bit0_11(bit)    (PREG_PAD_GPIOAO)
#define GPIOAO_bit_bit0_11(bit)     (bit)

#define GPIOD_bank_bit0_9(bit)      (PREG_PAD_GPIO2)
#define GPIOD_bit_bit0_9(bit)       (bit+16)

#define GPIOCARD_bank_bit0_8(bit)   (PREG_PAD_GPIO5)
#define GPIOCARD_bit_bit0_8(bit)    (bit+23)

#define GPIOBOOT_bank_bit0_17(bit)  (PREG_PAD_GPIO3)
#define GPIOBOOT_bit_bit0_17(bit)   (bit)

#define GPIOX_bank_bit0_31(bit)     (PREG_PAD_GPIO4)
#define GPIOX_bit_bit0_31(bit)      (bit)

#define GPIOX_bank_bit32_35(bit)    (PREG_PAD_GPIO3)
#define GPIOX_bit_bit32_35(bit)     (bit+20)

#define GPIOY_bank_bit0_22(bit)     (PREG_PAD_GPIO5)
#define GPIOY_bit_bit0_22(bit)      (bit)

/**
 * enable gpio edge interrupt
 *	
 * @param [in] pin  index number of the chip, start with 0 up to 255 
 * @param [in] flag rising(0) or falling(1) edge 
 * @param [in] group  this interrupt belong to which interrupt group  from 0 to 7
 */
extern void gpio_enable_edge_int(int pin , int flag, int group);
/**
 * enable gpio level interrupt
 *	
 * @param [in] pin  index number of the chip, start with 0 up to 255 
 * @param [in] flag high(0) or low(1) level 
 * @param [in] group  this interrupt belong to which interrupt group  from 0 to 7
 */
extern void gpio_enable_level_int(int pin , int flag, int group);

/**
 * enable gpio interrupt filter
 *
 * @param [in] filter from 0~7(*222ns)
 * @param [in] group  this interrupt belong to which interrupt group  from 0 to 7
 */
extern void gpio_enable_int_filter(int filter, int group);

extern int gpio_is_valid(int number);
extern int gpio_request(unsigned gpio, const char *label);
extern void gpio_free(unsigned gpio);
extern int gpio_direction_input(unsigned gpio);
extern int gpio_direction_output(unsigned gpio, int value);
extern void gpio_set_value(unsigned gpio, int value);
extern int gpio_get_value(unsigned gpio);

#endif
