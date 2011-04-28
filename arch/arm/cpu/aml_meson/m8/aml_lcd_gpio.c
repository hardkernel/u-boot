#include <common.h>
#include <asm/arch/register.h>
#include <asm/arch/lcd_reg.h>
#include <asm/arch/aml_lcd_gpio.h>

int aml_lcd_gpio_name_map_num(const char *name)
{
	int i;
	
	for(i = 0; i < GPIO_MAX; i++) {
		if(!strcmp(name, aml_lcd_gpio_type_table[i]))
			break;
	}
	if (i == GPIO_MAX) {
		printf("wrong gpio name %s, i=%d\n", name, i);
		i = -1;
	}
	return i;
}

int aml_lcd_gpio_set(int gpio, int flag)
{
	int gpio_bank, gpio_bit;
	
	if ((gpio>=GPIOAO_0) && (gpio<=GPIOAO_13)) {
		printf("don't support GPIOAO Port yet\n");
		return -2;
	}
	else if ((gpio>=GPIOZ_0) && (gpio<=GPIOZ_14)) {
		gpio_bit = gpio - GPIOZ_0 + 17;
		gpio_bank = PREG_PAD_GPIO1_EN_N;	//0x200f
	}
	else if ((gpio>=GPIOH_0) && (gpio<=GPIOH_9)) {
		gpio_bit = gpio - GPIOH_0 + 19;
		gpio_bank = PREG_PAD_GPIO3_EN_N;	//0x2015
	}
	else if ((gpio>=BOOT_0) && (gpio<=BOOT_18)) {
		gpio_bit = gpio - BOOT_0;
		gpio_bank = PREG_PAD_GPIO3_EN_N;	//0x2015
	}
	else if ((gpio>=CARD_0) && (gpio<=CARD_6)) {
		gpio_bit = gpio - CARD_0 + 22;
		gpio_bank = PREG_PAD_GPIO0_EN_N;	//0x200c
	}
	else if ((gpio>=GPIODV_0) && (gpio<=GPIODV_29)) {
		gpio_bit = gpio - GPIODV_0;
		gpio_bank = PREG_PAD_GPIO2_EN_N;	//0x2012
	}
	else if ((gpio>=GPIOY_0) && (gpio<=GPIOY_16)) {
		gpio_bit = gpio - GPIOY_0;
		gpio_bank = PREG_PAD_GPIO1_EN_N;	//0x200f
	}
	else if ((gpio>=GPIOX_0) && (gpio<=GPIOX_21)) {
		gpio_bit = gpio - GPIOX_0;
		gpio_bank = PREG_PAD_GPIO0_EN_N;	//0x200c
	}
	else if (gpio==GPIO_TEST_N) {
		printf("don't support GPIOAO Port yet\n");
		return -2;
	}
	else {
		printf("Wrong GPIO Port number: %d\n", gpio);
		return -1;
	}
	
	if (flag == LCD_GPIO_OUTPUT_LOW) {
		WRITE_LCD_CBUS_REG_BITS(gpio_bank+1, 0, gpio_bit, 1);
		WRITE_LCD_CBUS_REG_BITS(gpio_bank, 0, gpio_bit, 1);
	}
	else if (flag == LCD_GPIO_OUTPUT_HIGH) {
		WRITE_LCD_CBUS_REG_BITS(gpio_bank+1, 1, gpio_bit, 1);
		WRITE_LCD_CBUS_REG_BITS(gpio_bank, 0, gpio_bit, 1);
	}
	else {
		WRITE_LCD_CBUS_REG_BITS(gpio_bank, 1, gpio_bit, 1);
	}
	return 0;
}
