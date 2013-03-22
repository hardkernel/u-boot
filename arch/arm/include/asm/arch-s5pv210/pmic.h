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

#define GPD1CON		*(volatile unsigned long *)(0xE02000C0)
#define GPD1DAT		*(volatile unsigned long *)(0xE02000C4)
#define GPD1PUD		*(volatile unsigned long *)(0xE02000C8)

#define IIC_ESCL_Hi	GPD1DAT |= (0x1<<5)
#define IIC_ESCL_Lo	GPD1DAT &= ~(0x1<<5)
#define IIC_ESDA_Hi	GPD1DAT |= (0x1<<4)
#define IIC_ESDA_Lo	GPD1DAT &= ~(0x1<<4)

#define IIC_ESCL_INP	GPD1CON &= ~(0xf<<20)
#define IIC_ESCL_OUTP	GPD1CON = (GPD1CON & ~(0xf<<20))|(0x1<<20)

#define IIC_ESDA_INP	GPD1CON &= ~(0xf<<16)
#define IIC_ESDA_OUTP	GPD1CON = (GPD1CON & ~(0xf<<16))|(0x1<<16)

#define DELAY			100

#define MAX8698_ADDR	0x66	// when SRAD pin = 0, CC/CDh is selected
#define MAX8998_ADDR	0x66	// when SRAD pin = 0, CC/CDh is selected

extern void PMIC_InitIp(void);

#endif /*__PMIC_H__*/

