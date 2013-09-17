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
//-------------------------------------------------------------------------------------------
#include <common.h>
#include <asm/arch/pmic.h>

//-------------------------------------------------------------------------------------------
// MAX77802 BUCK Step : 0.00625
//-------------------------------------------------------------------------------------------
#define CONFIG_ARM_VOLTAGE(x)     ((x * 100000 - 60000)/625)
#define CONFIG_INT_VOLTAGE(x)     ((x * 100000 - 60000)/625)
#define CONFIG_G3D_VOLTAGE(x)     ((x * 100000 - 60000)/625)
#define CONFIG_KFC_VOLTAGE(x)     ((x * 100000 - 61250)/625)
#define CONFIG_MIF_VOLTAGE(x)     ((x * 100000 - 61250)/625)

//-------------------------------------------------------------------------------------------
// MAX77802 I2C Configuration
// I2C4.SCL (GPA2.1), I2C4.SDA (GPA2.0)
//-------------------------------------------------------------------------------------------
#define GPA2CON		*(volatile unsigned long *)(0x13400040)
#define GPA2DAT		*(volatile unsigned long *)(0x13400044)
#define GPA2PUD		*(volatile unsigned long *)(0x13400048)

//-------------------------------------------------------------------------------------------
// FAN CONTROL PORT (GPB2.0)
//-------------------------------------------------------------------------------------------
#define GPB2CON		*(volatile unsigned long *)(0x134000A0)
#define GPB2DAT		*(volatile unsigned long *)(0x134000A4)
#define GPB2PUD		*(volatile unsigned long *)(0x134000A8)

//-------------------------------------------------------------------------------------------
// HSIC RESET CONTROL PORT (GPX0.3)
//-------------------------------------------------------------------------------------------
#define GPX0CON		*(volatile unsigned long *)(0x13400C00)
#define GPX0DAT		*(volatile unsigned long *)(0x13400C04)
#define GPX0PUD		*(volatile unsigned long *)(0x13400C08)

//-------------------------------------------------------------------------------------------
// HSIC RESET CONTROL PORT (GPX1.4)
//-------------------------------------------------------------------------------------------
#define GPX1CON		*(volatile unsigned long *)(0x13400C20)
#define GPX1DAT		*(volatile unsigned long *)(0x13400C24)
#define GPX1PUD		*(volatile unsigned long *)(0x13400C28)

//-------------------------------------------------------------------------------------------
// LED CONTROL GPX2.3 (RED)
//-------------------------------------------------------------------------------------------
#define GPX2CON		*(volatile unsigned long *)(0x13400C40)
#define GPX2DAT		*(volatile unsigned long *)(0x13400C44)
#define GPX2PUD		*(volatile unsigned long *)(0x13400C48)

//-------------------------------------------------------------------------------------------
#define I2C4_PUD_NONE       GPA2PUD &= ~(0xF)
#define I2C4_INIT           GPA2CON &= ~(0xFF)
#define I2C4_SCL_OUT        GPA2CON |=  (0x10)
#define I2C4_SDA_OUT        GPA2CON |=  (0x1)

#define I2C4_SCL_HI         GPA2DAT |=  (0x2)
#define I2C4_SCL_LO         GPA2DAT &= ~(0x2)

#define I2C4_SDA_HI         GPA2DAT |=  (0x1)
#define I2C4_SDA_LO         GPA2DAT &= ~(0x1)
#define I2C4_SDA_GET        (GPA2DAT & 0x01) ? 1 : 0

#define I2C4_SDA_IN         GPA2CON &= ~(0x0F)

#define I2C4_DELAY          200

//-------------------------------------------------------------------------------------------
void i2c_delay(unsigned int count)
{
    unsigned int    i;
    for(i = 0; i < count; i++)  ;
}

//-------------------------------------------------------------------------------------------
void i2c_init(void)
{
    I2C4_INIT;      I2C4_PUD_NONE;
    I2C4_SCL_OUT;   I2C4_SDA_OUT;
    i2c_delay(I2C4_DELAY);
}

//-------------------------------------------------------------------------------------------
void i2c_start(void)
{
    I2C4_SCL_HI;
    I2C4_SDA_HI;
    i2c_delay(I2C4_DELAY);
    I2C4_SCL_OUT;   
    I2C4_SDA_OUT;   
    i2c_delay(I2C4_DELAY);
    
    I2C4_SDA_LO;    i2c_delay(I2C4_DELAY);
    I2C4_SCL_LO;    i2c_delay(I2C4_DELAY);
}

//-------------------------------------------------------------------------------------------
void i2c_restart(void)
{
    I2C4_SDA_HI;    i2c_delay(I2C4_DELAY);
    I2C4_SCL_HI;    i2c_delay(I2C4_DELAY);
    i2c_start();
}
//-------------------------------------------------------------------------------------------
void i2c_stop(void)
{
    I2C4_SDA_OUT;   i2c_delay(I2C4_DELAY);
    I2C4_SCL_LO;    
    I2C4_SDA_LO;    i2c_delay(I2C4_DELAY);
    I2C4_SCL_HI;    i2c_delay(I2C4_DELAY);
    I2C4_SDA_HI;    i2c_delay(I2C4_DELAY);
}

//-------------------------------------------------------------------------------------------
void i2c_clk(void)
{
    i2c_delay(I2C4_DELAY);
    I2C4_SCL_HI;
    i2c_delay(I2C4_DELAY);
    I2C4_SCL_LO;
    i2c_delay(I2C4_DELAY);
}

//-------------------------------------------------------------------------------------------
unsigned char i2c_read_ack(void)
{
    unsigned char   cnt = 10;
    
    I2C4_SDA_IN;    i2c_delay(I2C4_DELAY);
    I2C4_SCL_HI;//    i2c_delay(100);
    
    while(cnt--)  {
        if(!I2C4_SDA_GET)   {
            I2C4_SCL_LO;    i2c_delay(I2C4_DELAY);
            I2C4_SDA_OUT;   i2c_delay(I2C4_DELAY);
            return  1;  // true
        }
        i2c_delay(I2C4_DELAY);
    }
    
    I2C4_SCL_LO;    i2c_delay(I2C4_DELAY);
    I2C4_SDA_OUT;   i2c_delay(I2C4_DELAY);
    return  0;  // false
}

//-------------------------------------------------------------------------------------------
void i2c_write_ack(void)
{
    I2C4_SDA_OUT;   i2c_delay(I2C4_DELAY);
    I2C4_SDA_HI;    i2c_delay(I2C4_DELAY);
    i2c_clk();
}

//-------------------------------------------------------------------------------------------
unsigned char i2c_byte_write(unsigned char wdata)
{
    unsigned char   bit_check = 0x80;
    
    for(bit_check = 0x80; bit_check != 0; bit_check = (bit_check >> 1))  {
        if(wdata & bit_check)   I2C4_SDA_HI;
        else                    I2C4_SDA_LO;
        i2c_clk();
    }
    return  i2c_read_ack();
}

//-------------------------------------------------------------------------------------------
void i2c_byte_read(unsigned char *rdata)
{
    unsigned char   cnt, temp;
    
    I2C4_SDA_IN;    i2c_delay(I2C4_DELAY);
    for(cnt = 0, temp = 0, *rdata = 0; cnt < 8; cnt++)    {
        I2C4_SCL_HI;    i2c_delay(I2C4_DELAY);
        temp = (I2C4_SDA_GET);
        I2C4_SCL_LO;    i2c_delay(I2C4_DELAY);
        temp = temp << (7-cnt);
        *rdata |= temp; temp = 0;
        
    }
    i2c_write_ack();
}

//-------------------------------------------------------------------------------------------
void IIC0_ERead(unsigned char addr, unsigned char reg, unsigned char *data)
{
    i2c_start();
    i2c_byte_write(addr<<1);
    i2c_byte_write(reg);
    i2c_start();
    i2c_byte_write((addr<<1) + 0x01);
    i2c_byte_read(data);
    i2c_stop();
}

//-------------------------------------------------------------------------------------------
void IIC0_EWrite(unsigned char addr, unsigned char reg, unsigned char data)
{
    i2c_start();
    i2c_byte_write(addr<<1);
    i2c_byte_write(reg);
    i2c_byte_write(data);
    i2c_stop();
}

//-------------------------------------------------------------------------------------------
void pmic_ema_init(void)
{
	unsigned int reg;

	/* Ema setting for A15 */
	if (CONFIG_PM_VDD_ARM >= 1.045)
		reg = 0x122;
	else if (CONFIG_PM_VDD_ARM >= 0.95)
		reg = 0x324;
	else
		reg = 0x427;

	__REG(EXYNOS5_CLOCK_BASE + ARM_EMA_CTRL_OFFSET) = reg;

	/* EMA setting for A7 */
	if (CONFIG_PM_VDD_KFC >= 1.045)
		reg = 0x11;
	else if (CONFIG_PM_VDD_KFC >= 0.95)
		reg = 0x33;
	else
		reg = 0x44;

	__REG(EXYNOS5_CLOCK_BASE + ARM_EMA_CTRL_KFC_OFFSET) = reg;
}

//-------------------------------------------------------------------------------------------
void pmic_init(void)
{
#if defined(CONFIG_PMIC_CONTROL)
    unsigned char   i;
    float           cal_volt;
#endif    

	/* To advance margin, below EMA setting is executed */
	/* If you use EMA, remove comment mark and use below function */
	/* pmic_ema_init(); */

    i2c_init();

#if defined(CONFIG_PMIC_CONTROL)
    // BUCK2 VDD_ARM(1.0V -> 1.20V)
    for(i = 0; i < 8; i++)  IIC0_EWrite(0x09, 0x1D + i, CONFIG_ARM_VOLTAGE(CONFIG_PM_VDD_ARM));  
    // BUCK3 VDD_INT(1.0V -> 1.05V)
    for(i = 0; i < 8; i++)  IIC0_EWrite(0x09, 0x28 + i, CONFIG_INT_VOLTAGE(CONFIG_PM_VDD_INT));  
    // BUCK4 VDD_G3D(1.0V -> 1.20V)
    for(i = 0; i < 8; i++)  IIC0_EWrite(0x09, 0x38 + i, CONFIG_G3D_VOLTAGE(CONFIG_PM_VDD_G3D));  
    // BUCK6 VDD_KFC(1.0V -> 1.20V)
    for(i = 0; i < 8; i++)  IIC0_EWrite(0x09, 0x45 + i, CONFIG_KFC_VOLTAGE(CONFIG_PM_VDD_KFC));  
#endif    
}

//-------------------------------------------------------------------------------------------
void pmic_late_init(void)
{
    unsigned char   i, rdata;

#if defined(CONFIG_PMIC_CONTROL)
    // BUCK1 VDD_MIF(1.0V -> 1.05V)
    for(i = 0; i < 8; i++)  IIC0_EWrite(0x09, 0x11 + i, CONFIG_MIF_VOLTAGE(CONFIG_PM_VDD_MIF));  
#endif    
    
    // LDO Enable
    IIC0_ERead (0x09, 0x66, &rdata);
    IIC0_EWrite(0x09, 0x66, rdata | 0xC0);      // LDO7 1.8V, 1.8V_LCD, USB 2.0

    // LDO25 ETH_P3V3 Disable
    IIC0_ERead (0x09, 0x78, &rdata);
    IIC0_EWrite(0x09, 0x78, rdata & ~0xC0);     // LDO25 3.3V, 3.3V Ethernet default off

#if defined(CONFIG_PMIC_CONTROL)
    IIC0_ERead (0x09, 0x79, &rdata);
    IIC0_EWrite(0x09, 0x79, rdata | 0xC0);      // LDO26 3.3V, V_LCD, USB 3.0 Clock
    IIC0_ERead (0x09, 0x70, &rdata);
    IIC0_EWrite(0x09, 0x70, rdata | 0xC0);      // LDO17 1.2V, CAM_SENSOR_CORE
    IIC0_ERead (0x09, 0x77, &rdata);
    IIC0_EWrite(0x09, 0x77, rdata | 0xC0);      // LDO24 2.8V, CAM_AF
    IIC0_ERead (0x09, 0x76, &rdata);
    IIC0_EWrite(0x09, 0x76, rdata | 0xC0);      // LDO23 3.3V, TSP_AVDD
    IIC0_ERead (0x09, 0x78, &rdata);
    IIC0_EWrite(0x09, 0x78, rdata | 0xC0);      // LDO25 3.3V, VADC/MHL
    IIC0_ERead (0x09, 0x7F, &rdata);
    IIC0_EWrite(0x09, 0x7F, rdata | 0xC0);      // LDO32 3.0V, V_MOTOR
    IIC0_ERead (0x09, 0x71, &rdata);
    IIC0_EWrite(0x09, 0x71, rdata | 0xC0);      // LDO18 1.8V, CAM_ISP_SENSOR
#endif

    // POWER KEY Control
    GPX0CON &= 0xFFFF0FFF;    GPX0PUD = 0;

    // FAN CONTROL & LCD PWM
    GPB2CON &= 0xFFFF0FF0;  GPB2PUD = 0x00;         GPB2CON |= 0x1001;      GPB2DAT |= 0x09;

#if defined(CONFIG_LED_CONTROL)    
    // LED CONTROL
    GPB2CON |= 0x0110;      GPX2CON &= 0xFFFF0FFF;  GPX2CON |= 0x1000;      GPX2DAT &= 0xF7;
    LED_GREEN(ON);          LED_BLUE(OFF);          LED_RED(OFF);
#endif 
   
}

//-------------------------------------------------------------------------------------------
