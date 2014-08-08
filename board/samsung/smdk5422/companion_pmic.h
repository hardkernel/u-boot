/*
 * (C) Copyright 2013 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 */

#ifndef __COMPANION_PMIC_H__
#define __COMPANION_PMIC_H__

/* I2C GPIO for companion pmic */
#define GPG0CON		*(volatile unsigned long *)(0x14000080)
#define GPG0DAT		*(volatile unsigned long *)(0x14000084)
#define GPG0PUD		*(volatile unsigned long *)(0x14000088)

/* I2C emulation */

#define IIC3_ESCL_Hi	GPG0DAT |= (0x1<<4)
#define IIC3_ESCL_Lo	GPG0DAT &= ~(0x1<<4)
#define IIC3_ESDA_Hi	GPG0DAT |= (0x1<<5)
#define IIC3_ESDA_Lo	GPG0DAT &= ~(0x1<<5)

#define IIC3_ESCL_INP	GPG0CON &= ~(0xf<<16)
#define IIC3_ESCL_OUTP	GPG0CON = (GPG0CON & ~(0xf<<16))|(0x1<<16)

#define IIC3_ESDA_INP	GPG0CON &= ~(0xf<<20)
#define IIC3_ESDA_OUTP	GPG0CON = (GPG0CON & ~(0xf<<20))|(0x1<<20)

#define IIC3_GPIO_PUD	GPG0PUD &= ~(0xf<<8)
#define GPIO_COMP_DAT	GPG0DAT
#define GPIO_COMP_DAT_SHIFT	(5)

#define DELAY		100

/* COMPANION PMIC slave address */
#define COMP_PMIC_ADDR		0x38
#define COMP_PMIC_REG_ADDR	0x11
#define COMP_PMIC_REG_VALUE	0xC5

/* GPIO for companion enable */
#define GPE0CON_ADDR		(0x14000000)
#define GPE0DAT_ADDR		(0x14000004)

#define GPE0_5_CON_MASK		~(0xf << 20)
#define GPE0_5_CON_OUTPUT	(0x1 << 20)
#define GPE0_5_DAT_HIGH		(0x20)

/* gpio control for companion enable */
extern void companion_init(void);
extern void IIC3_ESetport(void);
extern void IIC3_ERead(unsigned char ChipId,
		unsigned char IicAddr, unsigned char *IicData);
extern void IIC3_EWrite(unsigned char ChipId,
		unsigned char IicAddr, unsigned char IicData);

#endif /*__COMPANION_PMIC_H__*/

