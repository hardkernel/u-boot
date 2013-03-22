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

//[*]----------------------------------------------------------------------------------------------[*]
#define MAX77687_ADDR			(0x09 << 1)

//[*]----------------------------------------------------------------------------------------------[*]
#define GPD1CON					(*(volatile unsigned long *)(0x114000C0))
#define GPD1DAT					(*(volatile unsigned long *)(0x114000C4))
#define GPD1PUD					(*(volatile unsigned long *)(0x114000C8))

//[*]----------------------------------------------------------------------------------------------[*]
#define	GPIO_I2C_SDA_CON_PORT	GPD1CON
#define	GPIO_I2C_SDA_DAT_PORT	GPD1DAT
#define	GPIO_SDA_PIN			0

#define	GPIO_I2C_CLK_CON_PORT	GPD1CON
#define	GPIO_I2C_CLK_DAT_PORT	GPD1DAT
#define	GPIO_CLK_PIN			1

//[*]----------------------------------------------------------------------------------------------[*]
#define	DELAY_TIME				100	// us value
#define	PORT_CHANGE_DELAY_TIME	100

#define	GPIO_CON_PORT_MASK		0xF
#define	GPIO_CON_PORT_OFFSET	0x4

#define	GPIO_CON_INPUT			0x0
#define	GPIO_CON_OUTPUT			0x1

//[*]----------------------------------------------------------------------------------------------[*]
#define	HIGH					1
#define	LOW						0

#define	I2C_READ				1
#define	I2C_WRITE				0
//[*]----------------------------------------------------------------------------------------------[*]

extern	int 	pmic_write		(unsigned char reg, unsigned char *wdata, unsigned char wsize);
extern	int 	pmic_read		(unsigned char reg, unsigned char *rdata, unsigned char rsize);
extern 	void 	pmic_init		(void);
extern 	void 	emmc_pwr_reset	(void);

//[*]----------------------------------------------------------------------------------------------[*]
#endif /*__PMIC_H__*/
//[*]----------------------------------------------------------------------------------------------[*]
//[*]----------------------------------------------------------------------------------------------[*]

