#ifndef  __AMLOGIC_GPIO_H__
#define	 __AMLOGIC_GPIO_H__
#include <asm/arch/gpio.h>
struct gpio_chip {
	int			(*request)(struct gpio_chip *chip ,unsigned offset);
	void			(*free)(unsigned offset);
	int			(*get_direction)(struct gpio_chip *chip ,unsigned offset);
	int			(*direction_input)(struct gpio_chip *chip ,unsigned offset);
	int			(*get)(struct gpio_chip *chip ,unsigned offset);
	int			(*direction_output)(struct gpio_chip *chip ,unsigned offset, int value);
	void			(*set)(struct gpio_chip *chip ,unsigned offset, int value);
	void			(*set_pullup)(unsigned offset, int value,unsigned int pullen);
	void			(*set_highz)(unsigned offset);
	int                  (*name_to_pin)(const char *name);
};
struct amlogic_gpio_desc{
	unsigned num;
	char *name;
	unsigned int out_en_reg_bit;
	unsigned int out_value_reg_bit;
	unsigned int input_value_reg_bit;
	unsigned int map_to_irq;
	unsigned int pull_up_reg_bit;
	const char *gpio_owner;
};

#define GPIO_REG_BIT(reg,bit) ((reg<<5)|bit)
#define GPIO_REG(value) ((value>>5))
#define GPIO_BIT(value) ((value&0x1F))

#ifdef CONFIG_AML_GPIO
void amlogic_gpio_direction_input(unsigned int pin);
void amlogic_gpio_direction_output(unsigned int pin,int value);
int amlogic_get_value(unsigned int pin);
void amlogic_set_value(unsigned int pin,int value);
void amlogic_set_pull_up(unsigned int pin,int value,unsigned int pullen);
int  gpioname_to_pin(const char*name);

#else
void amlogic_gpio_direction_input(unsigned int pin)
{
	return;
}
void amlogic_gpio_direction_output(unsigned int pin,int value)
{
	return;
}
int amlogic_get_value(unsigned int pin)
{
	return -1;
}
void amlogic_set_value(unsigned int pin,int value)
{
	return;
}
void amlogic_set_pull_up(unsigned int pin,int value,unsigned int pullen)

{
	return;
}
int  gpioname_to_pin(const char*name)
{
	return -1;
}

#endif
#endif
