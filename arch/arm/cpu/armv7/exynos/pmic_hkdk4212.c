/*
 * (C) Copyright 2011 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

//[*]----------------------------------------------------------------------------------------------[*]
#include <common.h>
#include <asm/arch/pmic_hkdk4212.h>

//[*]----------------------------------------------------------------------------------------------[*]
//	static function prototype
//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_sda_port_control	(unsigned char inout);
static	void			gpio_i2c_clk_port_control	(unsigned char inout);

static	unsigned char	gpio_i2c_get_sda			(void);
static	void			gpio_i2c_set_sda			(unsigned char hi_lo);
static	void			gpio_i2c_set_clk			(unsigned char hi_lo);
                                        	
static 	void			gpio_i2c_start				(void);
static 	void			gpio_i2c_stop				(void);
                                        	
static 	void			gpio_i2c_send_ack			(void);
static 	void			gpio_i2c_send_noack			(void);
static 	unsigned char	gpio_i2c_chk_ack			(void);
                		                      	
static 	void 			gpio_i2c_byte_write			(unsigned char wdata);
static 	void			gpio_i2c_byte_read			(unsigned char *rdata);
		        		
//[*]----------------------------------------------------------------------------------------------[*]
void delay_func(unsigned int us)
{
	unsigned long i;

	for(i = 0; i < us; i++)	{	i++;	i--;	}
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_sda_port_control	(unsigned char inout)
{
	GPIO_I2C_SDA_CON_PORT &=  (unsigned long)(~(GPIO_CON_PORT_MASK << (GPIO_SDA_PIN * GPIO_CON_PORT_OFFSET)));
	GPIO_I2C_SDA_CON_PORT |=  (unsigned long)( (inout << (GPIO_SDA_PIN * GPIO_CON_PORT_OFFSET)));
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_clk_port_control	(unsigned char inout)
{
	GPIO_I2C_CLK_CON_PORT &=  (unsigned long)(~(GPIO_CON_PORT_MASK << (GPIO_CLK_PIN * GPIO_CON_PORT_OFFSET)));
	GPIO_I2C_CLK_CON_PORT |=  (unsigned long)( (inout << (GPIO_CLK_PIN * GPIO_CON_PORT_OFFSET)));
}

//[*]----------------------------------------------------------------------------------------------[*]
static	unsigned char	gpio_i2c_get_sda		(void)
{
	return	GPIO_I2C_SDA_DAT_PORT & (HIGH << GPIO_SDA_PIN) ? 1 : 0;
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_set_sda		(unsigned char hi_lo)
{
	if(hi_lo)	{
		gpio_i2c_sda_port_control(GPIO_CON_INPUT);
		delay_func(PORT_CHANGE_DELAY_TIME);
	}
	else		{
		GPIO_I2C_SDA_DAT_PORT &= ~(HIGH << GPIO_SDA_PIN);
		gpio_i2c_sda_port_control(GPIO_CON_OUTPUT);
		delay_func(PORT_CHANGE_DELAY_TIME);
	}
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_set_clk		(unsigned char hi_lo)
{
	if(hi_lo)	{
		gpio_i2c_clk_port_control(GPIO_CON_INPUT);
		delay_func(PORT_CHANGE_DELAY_TIME);
	}
	else		{
		GPIO_I2C_CLK_DAT_PORT &= ~(HIGH << GPIO_CLK_PIN);
		gpio_i2c_clk_port_control(GPIO_CON_OUTPUT);
		delay_func(PORT_CHANGE_DELAY_TIME);
	}
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_start			(void)
{
	// Setup SDA, CLK output High
	gpio_i2c_set_sda(HIGH);
	gpio_i2c_set_clk(HIGH);
	
	delay_func(DELAY_TIME);

	// SDA low before CLK low
	gpio_i2c_set_sda(LOW);	delay_func(DELAY_TIME);
	gpio_i2c_set_clk(LOW);	delay_func(DELAY_TIME);
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_stop			(void)
{
	// Setup SDA, CLK output low
	gpio_i2c_set_sda(LOW);
	gpio_i2c_set_clk(LOW);
	
	delay_func(DELAY_TIME);
	
	// SDA high after CLK high
	gpio_i2c_set_clk(HIGH);	delay_func(DELAY_TIME);
	gpio_i2c_set_sda(HIGH);	delay_func(DELAY_TIME);
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_send_ack		(void)
{
	// SDA Low
	gpio_i2c_set_sda(LOW);	delay_func(DELAY_TIME);
	gpio_i2c_set_clk(HIGH);	delay_func(DELAY_TIME);
	gpio_i2c_set_clk(LOW);	delay_func(DELAY_TIME);
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void			gpio_i2c_send_noack		(void)
{
	// SDA High
	gpio_i2c_set_sda(HIGH);	delay_func(DELAY_TIME);
	gpio_i2c_set_clk(HIGH);	delay_func(DELAY_TIME);
	gpio_i2c_set_clk(LOW);	delay_func(DELAY_TIME);
}

//[*]----------------------------------------------------------------------------------------------[*]
static	unsigned char	gpio_i2c_chk_ack		(void)
{
	unsigned char	count = 0, ret = 0;

	gpio_i2c_set_sda(LOW);		delay_func(DELAY_TIME);
	gpio_i2c_set_clk(HIGH);		delay_func(DELAY_TIME);

	gpio_i2c_sda_port_control(GPIO_CON_INPUT);
	delay_func(PORT_CHANGE_DELAY_TIME);

	while(gpio_i2c_get_sda())	{
		if(count++ > 100)	{	ret = 1;	break;	}
		else					delay_func(DELAY_TIME);	
	}

	gpio_i2c_set_clk(LOW);		delay_func(DELAY_TIME);
	
	#if defined(DEBUG_GPIO_I2C)
		if(ret)		DEBUG_MSG(("%s (%d): no ack!!\n",__FUNCTION__, ret));
		else		DEBUG_MSG(("%s (%d): ack !! \n" ,__FUNCTION__, ret));
	#endif

	return	ret;
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void 		gpio_i2c_byte_write		(unsigned char wdata)
{
	unsigned char	cnt, mask;
	
	for(cnt = 0, mask = 0x80; cnt < 8; cnt++, mask >>= 1)	{
		if(wdata & mask)		gpio_i2c_set_sda(HIGH);
		else					gpio_i2c_set_sda(LOW);
			
		gpio_i2c_set_clk(HIGH);		delay_func(DELAY_TIME);
		gpio_i2c_set_clk(LOW);		delay_func(DELAY_TIME);
	}
}

//[*]----------------------------------------------------------------------------------------------[*]
static	void		gpio_i2c_byte_read		(unsigned char *rdata)
{
	unsigned char	cnt, mask;

	gpio_i2c_sda_port_control(GPIO_CON_INPUT);
	delay_func(PORT_CHANGE_DELAY_TIME);

	for(cnt = 0, mask = 0x80, *rdata = 0; cnt < 8; cnt++, mask >>= 1)	{
		gpio_i2c_set_clk(HIGH);		delay_func(DELAY_TIME);
		
		if(gpio_i2c_get_sda())		*rdata |= mask;
		
		gpio_i2c_set_clk(LOW);		delay_func(DELAY_TIME);
		
	}
}

//[*]----------------------------------------------------------------------------------------------[*]
int 				pmic_write		(unsigned char reg, unsigned char *wdata, unsigned char wsize)
{
	unsigned char cnt, ack;

	// start
	gpio_i2c_start();
	
	gpio_i2c_byte_write(MAX77687_ADDR + I2C_WRITE);	// i2c address

	if((ack = gpio_i2c_chk_ack()))		goto	write_stop;
	
	gpio_i2c_byte_write(reg);	// register
	
	if((ack = gpio_i2c_chk_ack()))		goto	write_stop;
	
	if(wsize)	{
		for(cnt = 0; cnt < wsize; cnt++)	{
			gpio_i2c_byte_write(wdata[cnt]);

			if((ack = gpio_i2c_chk_ack()))	goto	write_stop;
		}
	}

write_stop:
	
	if(wsize)	gpio_i2c_stop();

	return	ack;
}

//[*]----------------------------------------------------------------------------------------------[*]
int 				pmic_read		(unsigned char reg, unsigned char *rdata, unsigned char rsize)
{
	unsigned char ack, cnt;

	// register pointer write
	if(pmic_write(reg, NULL, 0))		goto	read_stop;
	
	// restart
	gpio_i2c_start();

	gpio_i2c_byte_write(MAX77687_ADDR + I2C_READ);	// i2c address

	if((ack = gpio_i2c_chk_ack()))		goto	read_stop;
	
	for(cnt=0; cnt < rsize; cnt++)	{
		
		gpio_i2c_byte_read(&rdata[cnt]);
		
		if(cnt == rsize -1)		gpio_i2c_send_noack();
		else					gpio_i2c_send_ack();
	}
	
read_stop:
	gpio_i2c_stop();

	return	ack;
}

//[*]----------------------------------------------------------------------------------------------[*]
//[*]----------------------------------------------------------------------------------------------[*]
void pmic_init(void)
{
	unsigned char	rwdata;
	gpio_i2c_set_sda(HIGH);		gpio_i2c_set_clk(HIGH);
	
	rwdata = 0x08;		// reset delay changed : 7sec to 3sec
	pmic_write(0x0A, &rwdata, 1);

	rwdata = 0x14;		// 1.8V Enable
	pmic_write(0x53, &rwdata, 1);	// EMMC
}

//[*]----------------------------------------------------------------------------------------------[*]
//[*]----------------------------------------------------------------------------------------------[*]
void emmc_pwr_reset(void)
{
	unsigned char	rwdata;
	gpio_i2c_set_sda(HIGH);		gpio_i2c_set_clk(HIGH);
	
	rwdata = 0x14;		// 1.8V Enable
	pmic_write(0x53, &rwdata, 1);	// EMMC

	rwdata = 0x00;		// 1.8V Enable
//	pmic_write(0x34, &rwdata, 1);	// BUCK7 3.0V
	pmic_write(0x36, &rwdata, 1);	// BUCK8 3.0V
}
//[*]----------------------------------------------------------------------------------------------[*]
//[*]----------------------------------------------------------------------------------------------[*]
