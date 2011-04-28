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
	GPIOH_0=14,
	GPIOH_1=15,
	GPIOH_2=16,
	GPIOH_3=17,
	GPIOH_4=18,
	GPIOH_5=19,
	GPIOH_6=20,
	GPIOH_7=21,
	GPIOH_8=22,
	GPIOH_9=23,
	BOOT_0=24,
	BOOT_1=25,
	BOOT_2=26,
	BOOT_3=27,
	BOOT_4=28,
	BOOT_5=29,
	BOOT_6=30,
	BOOT_7=31,
	BOOT_8=32,
	BOOT_9=33,
	BOOT_10=34,
	BOOT_11=35,
	BOOT_12=36,
	BOOT_13=37,
	BOOT_14=38,
	BOOT_15=39,
	BOOT_16=40,
	BOOT_17=41,
	BOOT_18=42,
	CARD_0=43,
	CARD_1=44,
	CARD_2=45,
	CARD_3=46,
	CARD_4=47,
	CARD_5=48,
	CARD_6=49,
	GPIODV_0=50,
	GPIODV_1=51,
	GPIODV_2=52,
	GPIODV_3=53,
	GPIODV_4=54,
	GPIODV_5=55,
	GPIODV_6=56,
	GPIODV_7=57,
	GPIODV_8=58,
	GPIODV_9=59,
	GPIODV_10=60,
	GPIODV_11=61,
	GPIODV_12=62,
	GPIODV_13=63,
	GPIODV_14=64,
	GPIODV_15=65,
	GPIODV_16=66,
	GPIODV_17=67,
	GPIODV_18=68,
	GPIODV_19=69,
	GPIODV_20=70,
	GPIODV_21=71,
	GPIODV_22=72,
	GPIODV_23=73,
	GPIODV_24=74,
	GPIODV_25=75,
	GPIODV_26=76,
	GPIODV_27=77,
	GPIODV_28=78,
	GPIODV_29=79,
	GPIOY_0=80,
	GPIOY_1=81,
	GPIOY_2=82,
	GPIOY_3=83,
	GPIOY_4=84,
	GPIOY_5=85,
	GPIOY_6=86,
	GPIOY_7=87,
	GPIOY_8=88,
	GPIOY_9=89,
	GPIOY_10=90,
	GPIOY_11=91,
	GPIOY_12=92,
	GPIOY_13=93,
	GPIOY_14=94,
	GPIOY_15=95,
	GPIOY_16=96,
	GPIOX_0=97,
	GPIOX_1=98,
	GPIOX_2=99,
	GPIOX_3=100,
	GPIOX_4=101,
	GPIOX_5=102,
	GPIOX_6=103,
	GPIOX_7=104,
	GPIOX_8=105,
	GPIOX_9=106,
	GPIOX_10=107,
	GPIOX_11=108,
	GPIOX_12=109,
	GPIOX_13=110,
	GPIOX_14=111,
	GPIOX_15=112,
	GPIOX_16=113,
	GPIOX_17=114,
	GPIOX_18=115,
	GPIOX_19=116,
	GPIOX_20=117,
	GPIOX_21=118,
	DIF_TTL_0_P=119,
	DIF_TTL_0_N=120,
	DIF_TTL_1_P=121,
	DIF_TTL_1_N=122,
	DIF_TTL_2_P=123,
	DIF_TTL_2_N=124,
	DIF_TTL_3_P=125,
	DIF_TTL_3_N=126,
	DIF_TTL_4_P=127,
	DIF_TTL_4_N=128,
	HDMI_TTL_0_P=129,
	HDMI_TTL_0_N=130,
	HDMI_TTL_1_P=131,
	HDMI_TTL_1_N=132,
	HDMI_TTL_2_P=133,
	HDMI_TTL_2_N=134,
	HDMI_TTL_CK_P=135,
	HDMI_TTL_CK_N=136,
	GPIO_BSD_EN=137,
	GPIO_TEST_N=138,
	GPIO_MAX=139,
}gpio_t;

#endif
