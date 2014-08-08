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

#ifndef __PMIC_H__
#define __PMIC_H__

#define GPD1CON		*(volatile unsigned long *)(0x114000C0)
#define GPD1DAT		*(volatile unsigned long *)(0x114000C4)
#define GPD1PUD		*(volatile unsigned long *)(0x114000C8)
#ifdef CONFIG_EXYNOS4X12
#define GPA1CON		*(volatile unsigned long *)(0x11400020)
#define GPA1DAT		*(volatile unsigned long *)(0x11400024)
#define GPA1PUD		*(volatile unsigned long *)(0x11400028)
#endif

#ifdef CONFIG_INVERSE_PMIC_I2C
#define IIC0_ESCL_Hi	GPD1DAT |= (0x1<<0)
#define IIC0_ESCL_Lo	GPD1DAT &= ~(0x1<<0)
#define IIC0_ESDA_Hi	GPD1DAT |= (0x1<<1)
#define IIC0_ESDA_Lo	GPD1DAT &= ~(0x1<<1)
#else
#define IIC0_ESCL_Hi	GPD1DAT |= (0x1<<1)
#define IIC0_ESCL_Lo	GPD1DAT &= ~(0x1<<1)
#define IIC0_ESDA_Hi	GPD1DAT |= (0x1<<0)
#define IIC0_ESDA_Lo	GPD1DAT &= ~(0x1<<0)
#endif

#define IIC1_ESCL_Hi	GPD1DAT |= (0x1<<3)
#define IIC1_ESCL_Lo	GPD1DAT &= ~(0x1<<3)
#define IIC1_ESDA_Hi	GPD1DAT |= (0x1<<2)
#define IIC1_ESDA_Lo	GPD1DAT &= ~(0x1<<2)

#ifdef CONFIG_EXYNOS4X12
#define IIC3_ESCL_Hi	GPA1DAT |= (0x1<<3)
#define IIC3_ESCL_Lo	GPA1DAT &= ~(0x1<<3)
#define IIC3_ESDA_Hi	GPA1DAT |= (0x1<<2)
#define IIC3_ESDA_Lo	GPA1DAT &= ~(0x1<<2)
#endif

#ifdef CONFIG_INVERSE_PMIC_I2C
#define IIC0_ESCL_INP	GPD1CON &= ~(0xf<<0)
#define IIC0_ESCL_OUTP	GPD1CON = (GPD1CON & ~(0xf<<0))|(0x1<<0)

#define IIC0_ESDA_INP	GPD1CON &= ~(0xf<<4)
#define IIC0_ESDA_OUTP	GPD1CON = (GPD1CON & ~(0xf<<4))|(0x1<<4)
#else
#define IIC0_ESCL_INP	GPD1CON &= ~(0xf<<4)
#define IIC0_ESCL_OUTP	GPD1CON = (GPD1CON & ~(0xf<<4))|(0x1<<4)

#define IIC0_ESDA_INP	GPD1CON &= ~(0xf<<0)
#define IIC0_ESDA_OUTP	GPD1CON = (GPD1CON & ~(0xf<<0))|(0x1<<0)
#endif

#define IIC1_ESCL_INP	GPD1CON &= ~(0xf<<12)
#define IIC1_ESCL_OUTP	GPD1CON = (GPD1CON & ~(0xf<<12))|(0x1<<12)

#define IIC1_ESDA_INP	GPD1CON &= ~(0xf<<8)
#define IIC1_ESDA_OUTP	GPD1CON = (GPD1CON & ~(0xf<<8))|(0x1<<8)

#ifdef CONFIG_EXYNOS4X12
#define IIC3_ESCL_INP	GPA1CON &= ~(0xf<<12)
#define IIC3_ESCL_OUTP	GPA1CON = (GPA1CON & ~(0xf<<12))|(0x1<<12)

#define IIC3_ESDA_INP	GPA1CON &= ~(0xf<<8)
#define IIC3_ESDA_OUTP	GPA1CON = (GPA1CON & ~(0xf<<8))|(0x1<<8)
#endif

#define DELAY		100

#define MAX8952_ADDR            0xc0	// VDD_ARM - I2C0
#define MAX8649_ADDR            0xc0	// VDD_INT - I2C1
#define MAX8649A_ADDR           0xc4	// VDD_G3D - I2C0
#define MAX8997_ADDR            0xCC	// MAX8997 - I2C0
#define MAX77686_ADDR           0x12	// MAX77686 - I2C0
#define MAX8997_ID              0x00
#define MAX8997_BUCK1TV_DVS     0x19
#define MAX8997_BUCK2TV_DVS     0x22
#define MAX8997_BUCK3TV_DVS     0x2B
#define MAX8997_BUCK4TV_DVS     0x2D
#define MAX8997_LDO10CTRL       0x44
#define S5M8767_ADDR		0xCC	// S5M8767 - I2C0
extern void pmic8767_init(void);

#define CALC_MAXIM_BUCK1245_VOLT(x)     	( (x<650) ? 0 : ((x-650)/25) )
#define CALC_MAXIM_BUCK37_VOLT(x)       	( (x<750) ? 0 : ((x-750)/50) )
#define CALC_MAXIM_ALL_LDO(x)	        	( (x<800) ? 0 : ((x-800)/50) )
#define CALC_MAXIM77686_BUCK156789_VOLT(x)   	( (x<750) ? 0 : ((x-750)/50) )
#define CALC_MAXIM77686_BUCK234_VOLT(x) 	( (x<600) ? 0 : ((x-600)/12.5) )
#define CALC_MAXIM77686_LDO1267815_VOLT(x)	( (x<800) ? 0 : ((x-800)/25) )
#define CALC_MAXIM77686_ALL_LDO_VOLT(x)         ( (x<800) ? 0 : ((x-800)/50) )

typedef enum
{
	PMIC_BUCK1=0,
	PMIC_BUCK2,
	PMIC_BUCK3,
	PMIC_BUCK4,
	PMIC_LDO14,
	PMIC_LDO10,
	PMIC_LDO21,
}PMIC_RegNum;

extern void pmic_init(void);

#endif /*__PMIC_H__*/

