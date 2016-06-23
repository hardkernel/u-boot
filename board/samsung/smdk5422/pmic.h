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

#define GPA2CON		*(volatile unsigned long *)(0x14010040)
#define GPA2DAT		*(volatile unsigned long *)(0x14010044)
#define GPA2PUD		*(volatile unsigned long *)(0x14010048)

#define GPB2CON		*(volatile unsigned long *)(0x140100A0)
#define GPB2DAT		*(volatile unsigned long *)(0x140100A4)
#define GPB2PUD		*(volatile unsigned long *)(0x140100A8)

#if defined(CONFIG_MACH_UNIVERSAL5422)
#define IIC0_ESCL_Hi	GPB2DAT |= (0x1<<3)
#define IIC0_ESCL_Lo	GPB2DAT &= ~(0x1<<3)
#define IIC0_ESDA_Hi	GPB2DAT |= (0x1<<2)
#define IIC0_ESDA_Lo	GPB2DAT &= ~(0x1<<2)

#define IIC0_ESCL_INP	GPB2CON &= ~(0xf<<12)
#define IIC0_ESCL_OUTP	GPB2CON = (GPB2CON & ~(0xf<<12))|(0x1<<12)

#define IIC0_ESDA_INP	GPB2CON &= ~(0xf<<8)
#define IIC0_ESDA_OUTP	GPB2CON = (GPB2CON & ~(0xf<<8))|(0x1<<8)

#define GPIO_DAT	GPB2DAT
#define GPIO_DAT_SHIFT	(2)
#define DIS_GPIO_PUD	GPB2PUD &= ~(0xf<<4)
#else
#define IIC0_ESCL_Hi	GPA2DAT |= (0x1<<1)
#define IIC0_ESCL_Lo	GPA2DAT &= ~(0x1<<1)
#define IIC0_ESDA_Hi	GPA2DAT |= (0x1<<0)
#define IIC0_ESDA_Lo	GPA2DAT &= ~(0x1<<0)

#define IIC0_ESCL_INP	GPA2CON &= ~(0xf<<4)
#define IIC0_ESCL_OUTP	GPA2CON = (GPA2CON & ~(0xf<<4))|(0x1<<4)

#define IIC0_ESDA_INP	GPA2CON &= ~(0xf<<0)
#define IIC0_ESDA_OUTP	GPA2CON = (GPA2CON & ~(0xf<<0))|(0x1<<0)

#define GPIO_DAT	GPA2DAT
#define GPIO_DAT_SHIFT	(0)
#define DIS_GPIO_PUD	GPA2PUD &= ~(0xf<<0)
#endif

#define DELAY		100
#define S2MPS11_ADDR	0xCC	// S2MPS11

#define VDD_BASE_VOLT	1.00
#define VDD_BASE_VAL	0x40
#define CONFIG_PM_CALC_VOLT(x)	(VDD_BASE_VAL + ((x - VDD_BASE_VOLT) * 20 * 8))

#define ARM_EMA_CTRL_OFFSET			0x01008
#define ARM_EMA_CTRL_KFC_OFFSET			0x29008

#define VDD_
extern void pmic_init(void);
extern void pmic_deinit(void);
extern void IIC0_EWrite(unsigned char ChipId,
		unsigned char IicAddr, unsigned char IicData);
extern void IIC0_ERead(unsigned char ChipId,
		unsigned char IicAddr, unsigned char *IicData);

/* S2MPS11 Register Address */
#define PMIC_ID		0x00
#define RTC_CTRL	0x0B
#define BUCK1_CTRL1	0x25
#define BUCK1_CTRL2	0x26
#define BUCK2_CTRL1	0x27
#define BUCK2_CTRL2	0x28
#define BUCK3_CTRL1	0x29
#define BUCK3_CTRL2	0x2A
#define BUCK4_CTRL1	0x2B
#define BUCK4_CTRL2	0x2C
#define BUCK5_CTRL1	0x2D
#define BUCK5_SW	0x2E
#define BUCK5_CTRL2	0x2F
#define BUCK5_CTRL3	0x30
#define BUCK5_CTRL4	0x31
#define BUCK5_CTRL5	0x32
#define BUCK6_CTRL1	0x33
#define BUCK6_CTRL2	0x34
#endif /*__PMIC_H__*/

