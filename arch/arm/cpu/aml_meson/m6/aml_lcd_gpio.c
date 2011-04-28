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
	
	if ((gpio>=GPIOZ_0) && (gpio<=GPIOZ_12)) {	//GPIOZ_0~12
		gpio_bit = gpio - GPIOZ_0 + 16;
		gpio_bank = PREG_PAD_GPIO6_EN_N;
	}
	else if ((gpio>=GPIOE_0) && (gpio<=GPIOE_11)) {	//GPIOE_0~11
		gpio_bit = gpio - GPIOE_0;
		gpio_bank = PREG_PAD_GPIO6_EN_N;
	}
	else if ((gpio>=GPIOY_0) && (gpio<=GPIOY_15)) {	//GPIOY_0~15
		gpio_bit = gpio - GPIOY_0;
		gpio_bank = PREG_PAD_GPIO5_EN_N;
	}
	else if ((gpio>=GPIOX_0) && (gpio<=GPIOX_31)) {	//GPIOX_0~31
		gpio_bit = gpio - GPIOX_0;
		gpio_bank = PREG_PAD_GPIO4_EN_N;
	}
	else if ((gpio>=GPIOX_32) && (gpio<=GPIOX_35)) {	//GPIOX_32~35
		gpio_bit = gpio - GPIOX_32 + 20;
		gpio_bank = PREG_PAD_GPIO3_EN_N;
	}
	else if ((gpio>=BOOT_0) && (gpio<=BOOT_17)) {	//BOOT_0~17
		gpio_bit = gpio - BOOT_0;
		gpio_bank = PREG_PAD_GPIO3_EN_N;
	}
	else if ((gpio>=GPIOD_0) && (gpio<=GPIOD_9)) {	//GPIOD_0~9
		gpio_bit = gpio - GPIOD_0 + 16;
		gpio_bank = PREG_PAD_GPIO2_EN_N;
	}
	else if ((gpio>=GPIOC_0) && (gpio<=GPIOC_15)) {	//GPIOC_0~15
		gpio_bit = gpio - GPIOC_0;
		gpio_bank = PREG_PAD_GPIO2_EN_N;
	}
	else if ((gpio>=CARD_0) && (gpio<=CARD_8)) {	//CARD_0~8
		gpio_bit = gpio - CARD_0 + 23;
		gpio_bank = PREG_PAD_GPIO5_EN_N;
	}
	else if ((gpio>=GPIOB_0) && (gpio<=GPIOB_23)) {	//GPIOB_0~23
		gpio_bit = gpio - GPIOB_0;
		gpio_bank = PREG_PAD_GPIO1_EN_N;
	}
	else if ((gpio>=GPIOA_0) && (gpio<=GPIOA_27)) {	//GPIOA_0~27
		gpio_bit = gpio - GPIOA_0;
		gpio_bank = PREG_PAD_GPIO0_EN_N;
	}
	else if ((gpio>=GPIOAO_0) && (gpio<=GPIOAO_11)) {	//GPIOAO_0~11
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
