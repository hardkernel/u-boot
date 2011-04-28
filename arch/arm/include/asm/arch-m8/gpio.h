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
	PREG_PAD_GPIO6,
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

#define GPIOZ_bank_bit0_12(bit)     (PREG_PAD_GPIO6)
#define GPIOZ_bit_bit0_12(bit)      (bit)

#define GPIOP_bank_bit0_7(bit)     (PREG_PAD_GPIO1)
#define GPIOP_bit_bit0_7(bit)      (bit+23)

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

typedef enum {
	GPIOAO_0=0,
	GPIOAO_1=1,
	GPIOAO_2=2,
	GPIOAO_3=3,
	GPIOAO_4=4,
	GPIOAO_5=5,
	GPIOAO_6=6,
	GPIOAO_7=7,
	GPIOAO_8=8,
	GPIOAO_9=9,
	GPIOAO_10=10,
	GPIOAO_11=11,
	GPIOAO_12=12,
	GPIOAO_13=13,
	GPIOZ_0=14,
	GPIOZ_1=15,
	GPIOZ_2=16,
	GPIOZ_3=17,
	GPIOZ_4=18,
	GPIOZ_5=19,
	GPIOZ_6=20,
	GPIOZ_7=21,
	GPIOZ_8=22,
	GPIOZ_9=23,
	GPIOZ_10=24,
	GPIOZ_11=25,
	GPIOZ_12=26,
	GPIOZ_13=27,
	GPIOZ_14=28,
	GPIOH_0=29,
	GPIOH_1=30,
	GPIOH_2=31,
	GPIOH_3=32,
	GPIOH_4=33,
	GPIOH_5=34,
	GPIOH_6=35,
	GPIOH_7=36,
	GPIOH_8=37,
	GPIOH_9=38,
	BOOT_0=39,
	BOOT_1=40,
	BOOT_2=41,
	BOOT_3=42,
	BOOT_4=43,
	BOOT_5=44,
	BOOT_6=45,
	BOOT_7=46,
	BOOT_8=47,
	BOOT_9=48,
	BOOT_10=49,
	BOOT_11=50,
	BOOT_12=51,
	BOOT_13=52,
	BOOT_14=53,
	BOOT_15=54,
	BOOT_16=55,
	BOOT_17=56,
	BOOT_18=57,
	CARD_0=58,
	CARD_1=59,
	CARD_2=60,
	CARD_3=61,
	CARD_4=62,
	CARD_5=63,
	CARD_6=64,
	GPIODV_0=65,
	GPIODV_1=66,
	GPIODV_2=67,
	GPIODV_3=68,
	GPIODV_4=69,
	GPIODV_5=70,
	GPIODV_6=71,
	GPIODV_7=72,
	GPIODV_8=73,
	GPIODV_9=74,
	GPIODV_10=75,
	GPIODV_11=76,
	GPIODV_12=77,
	GPIODV_13=78,
	GPIODV_14=79,
	GPIODV_15=80,
	GPIODV_16=81,
	GPIODV_17=82,
	GPIODV_18=83,
	GPIODV_19=84,
	GPIODV_20=85,
	GPIODV_21=86,
	GPIODV_22=87,
	GPIODV_23=88,
	GPIODV_24=89,
	GPIODV_25=90,
	GPIODV_26=91,
	GPIODV_27=92,
	GPIODV_28=93,
	GPIODV_29=94,
	GPIOY_0=95,
	GPIOY_1=96,
	GPIOY_2=97,
	GPIOY_3=98,
	GPIOY_4=99,
	GPIOY_5=100,
	GPIOY_6=101,
	GPIOY_7=102,
	GPIOY_8=103,
	GPIOY_9=104,
	GPIOY_10=105,
	GPIOY_11=106,
	GPIOY_12=107,
	GPIOY_13=108,
	GPIOY_14=109,
	GPIOY_15=110,
	GPIOY_16=111,
	GPIOX_0=112,
	GPIOX_1=113,
	GPIOX_2=114,
	GPIOX_3=115,
	GPIOX_4=116,
	GPIOX_5=117,
	GPIOX_6=118,
	GPIOX_7=119,
	GPIOX_8=120,
	GPIOX_9=121,
	GPIOX_10=122,
	GPIOX_11=123,
	GPIOX_12=124,
	GPIOX_13=125,
	GPIOX_14=126,
	GPIOX_15=127,
	GPIOX_16=128,
	GPIOX_17=129,
	GPIOX_18=130,
	GPIOX_19=131,
	GPIOX_20=132,
	GPIOX_21=133,
	GPIO_BSD_EN=134,
	GPIO_TEST_N=135,
	GPIO_MAX=136,
}gpio_t;

#endif
