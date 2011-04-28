#include <common.h>
#include <asm/arch/io.h>
#include <asm/arch/gpio.h>
#include <amlogic/gpio.h>
extern struct gpio_chip amlogic_gpio_chip;

void amlogic_gpio_direction_input(unsigned int pin)
{
	if(pin>=0 && pin <=GPIO_MAX){
		if(amlogic_gpio_chip.request)
			amlogic_gpio_chip.request(NULL,pin);
		if(amlogic_gpio_chip.direction_input)
			amlogic_gpio_chip.direction_input(NULL,pin);
	}else
		printf("%d out of range\n",pin);
}

void amlogic_gpio_direction_output(unsigned int pin,int value)
{
	if(pin>=0 && pin <=GPIO_MAX){
		if(amlogic_gpio_chip.request)
			amlogic_gpio_chip.request(NULL,pin);
		if(amlogic_gpio_chip.direction_output)
			amlogic_gpio_chip.direction_output(NULL,pin,value);
	}else
		printf("%d out of range\n",pin);
}
int amlogic_get_value(unsigned int pin)
{
	if(pin>=0 && pin <=GPIO_MAX){
		if(amlogic_gpio_chip.get)
			return amlogic_gpio_chip.get(NULL,pin);
	}
	else
		printf("%d out of range\n",pin);
}

void amlogic_set_value(unsigned int pin,int value)
{
	if(pin>=0 && pin <=GPIO_MAX){
		if(amlogic_gpio_chip.set)
			amlogic_gpio_chip.set(NULL,pin,value);
	}
	else
		printf("%d out of range\n",pin);
}
void amlogic_set_pull_up(unsigned int pin,int value,unsigned int pullen)
{
	if(pin>=0 && pin <=GPIO_MAX){
		if(amlogic_gpio_chip.set_pullup)
			amlogic_gpio_chip.set_pullup(pin,value,pullen);
	}
	else
		printf("%d out of range\n",pin);
}
void amlogic_set_highz(unsigned int pin)
{
	if(pin>=0 && pin <=GPIO_MAX){
		if(amlogic_gpio_chip.set_pullup)
			amlogic_gpio_chip.set_highz(pin);
	}
	else
		printf("%d out of range\n",pin);
}

int  gpioname_to_pin(const char *name)
{
	if (amlogic_gpio_chip.name_to_pin)
		return amlogic_gpio_chip.name_to_pin(name);
	else
		return -1;
}


