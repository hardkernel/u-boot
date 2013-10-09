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
 
#ifndef __USB3503_H__
#define __USB3503_H__

//[*]----------------------------------------------------------------------------------------------[*]
#define USB3503_ADDR			(0x08 << 1) 

#define USB3503_VIDL            0x00
#define USB3503_VIDM            0x01
#define USB3503_PIDL            0x02
#define USB3503_PIDM            0x03
#define USB3503_DIDL            0x04
#define USB3503_DIDM            0x05

#define USB3503_CFG1            0x06
#define USB3503_SELF_BUS_PWR    (1 << 7)

#define USB3503_CFG2            0x07
#define USB3503_CFG3            0x08
#define USB3503_NRD             0x09

#define USB3503_PDS             0x0a
#define USB3503_PORT1           (1 << 1)
#define USB3503_PORT2           (1 << 2)
#define USB3503_PORT3           (1 << 3)
#define USB3503_SP_ILOCK        0xe7
#define USB3503_SPILOCK_CONNECT (1 << 1)
#define USB3503_SPILOCK_CONFIG  (1 << 0)

#define USB3503_CFGP            0xee
#define USB3503_CLKSUSP         (1 << 7)

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

extern	int 	usb3503_write		(unsigned char reg, unsigned char *wdata, unsigned char wsize);
extern	int 	usb3503_read		(unsigned char reg, unsigned char *rdata, unsigned char rsize);

//[*]----------------------------------------------------------------------------------------------[*]
#endif /*__USB3503_H__*/
//[*]----------------------------------------------------------------------------------------------[*]
//[*]----------------------------------------------------------------------------------------------[*]

