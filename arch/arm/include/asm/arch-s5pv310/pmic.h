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

#define IIC0_ESCL_Hi	GPD1DAT |= (0x1<<1)
#define IIC0_ESCL_Lo	GPD1DAT &= ~(0x1<<1)
#define IIC0_ESDA_Hi	GPD1DAT |= (0x1<<0)
#define IIC0_ESDA_Lo	GPD1DAT &= ~(0x1<<0)

#define IIC1_ESCL_Hi	GPD1DAT |= (0x1<<3)
#define IIC1_ESCL_Lo	GPD1DAT &= ~(0x1<<3)
#define IIC1_ESDA_Hi	GPD1DAT |= (0x1<<2)
#define IIC1_ESDA_Lo	GPD1DAT &= ~(0x1<<2)

#define IIC0_ESCL_INP	GPD1CON &= ~(0xf<<4)
#define IIC0_ESCL_OUTP	GPD1CON = (GPD1CON & ~(0xf<<4))|(0x1<<4)

#define IIC0_ESDA_INP	GPD1CON &= ~(0xf<<0)
#define IIC0_ESDA_OUTP	GPD1CON = (GPD1CON & ~(0xf<<0))|(0x1<<0)


#define IIC1_ESCL_INP	GPD1CON &= ~(0xf<<12)
#define IIC1_ESCL_OUTP	GPD1CON = (GPD1CON & ~(0xf<<12))|(0x1<<12)

#define IIC1_ESDA_INP	GPD1CON &= ~(0xf<<8)
#define IIC1_ESDA_OUTP	GPD1CON = (GPD1CON & ~(0xf<<8))|(0x1<<8)

#define DELAY		100

#define MAX8952_ADDR	0xc0	// VDD_ARM - I2C0
#define MAX8649_ADDR	0xc0	// VDD_INT - I2C1
#define MAX8649A_ADDR	0xc4	// VDD_G3D - I2C0
#define MAX8997_ADDR	0xCC	// MAX8997 - I2C0

#define CALC_MAXIM_BUCK1245_VOLT(x)	( (x<650) ? 0 : ((x-650)/25) )
#define CALC_MAXIM_BUCK37_VOLT(x)	( (x<750) ? 0 : ((x-750)/50) )

typedef enum
{
	PMIC_BUCK1=0,
	PMIC_BUCK2,	
	PMIC_BUCK3,
}PMIC_RegNum;

extern void pmic_init(void);

#endif /*__PMIC_H__*/

