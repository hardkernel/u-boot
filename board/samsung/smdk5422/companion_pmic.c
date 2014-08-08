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

#include <common.h>
#include <asm/arch/cpu.h>
#include "companion_pmic.h"

void COMP_Delay(void)
{
	unsigned long i;
	for (i = 0; i < DELAY; i++)
		;
}

void IIC3_SCLH_SDAH(void)
{
	IIC3_ESCL_Hi;
	IIC3_ESDA_Hi;
	COMP_Delay();
}

void IIC3_SCLH_SDAL(void)
{
	IIC3_ESCL_Hi;
	IIC3_ESDA_Lo;
	COMP_Delay();
}

void IIC3_SCLL_SDAH(void)
{
	IIC3_ESCL_Lo;
	IIC3_ESDA_Hi;
	COMP_Delay();
}

void IIC3_SCLL_SDAL(void)
{
	IIC3_ESCL_Lo;
	IIC3_ESDA_Lo;
	COMP_Delay();
}

void IIC3_ELow(void)
{
	IIC3_SCLL_SDAL();
	IIC3_SCLH_SDAL();
	IIC3_SCLH_SDAL();
	IIC3_SCLL_SDAL();
}

void IIC3_EHigh(void)
{
	IIC3_SCLL_SDAH();
	IIC3_SCLH_SDAH();
	IIC3_SCLH_SDAH();
	IIC3_SCLL_SDAH();
}

void IIC3_EStart(void)
{
	IIC3_SCLH_SDAH();
	IIC3_SCLH_SDAL();
	COMP_Delay();
	IIC3_SCLL_SDAL();
}

void IIC3_EEnd(void)
{
	IIC3_SCLL_SDAL();
	IIC3_SCLH_SDAL();
	COMP_Delay();
	IIC3_SCLH_SDAH();
}

void IIC3_EAck_write(void)
{
	unsigned long ack;

	/* Function <- Input */
	IIC3_ESDA_INP;

	IIC3_ESCL_Lo;
	COMP_Delay();
	IIC3_ESCL_Hi;
	COMP_Delay();
	ack = GPIO_COMP_DAT;
	IIC3_ESCL_Hi;
	COMP_Delay();
	IIC3_ESCL_Hi;
	COMP_Delay();

	/* Function <- Output (SDA) */
	IIC3_ESDA_OUTP;

	ack = (ack>>GPIO_COMP_DAT_SHIFT)&0x1;

	IIC3_SCLL_SDAL();
}

void IIC3_EAck_read(void)
{
	/* Function <- Output */
	IIC3_ESDA_OUTP;

	IIC3_ESCL_Lo;
	IIC3_ESCL_Lo;
	IIC3_ESDA_Hi;
	IIC3_ESCL_Hi;
	IIC3_ESCL_Hi;
	/* Function <- Input (SDA) */
	IIC3_ESDA_INP;

	IIC3_SCLL_SDAL();
}

void IIC3_ESetport(void)
{
	/* Pull Up/Down Disable	SCL, SDA */
	IIC3_GPIO_PUD;

	IIC3_ESCL_Hi;
	IIC3_ESDA_Hi;

	/* Function <- Output (SCL) */
	IIC3_ESCL_OUTP;
	/* Function <- Output (SDA) */
	IIC3_ESDA_OUTP;

	COMP_Delay();
}

void IIC3_EWrite(unsigned char ChipId,
		unsigned char IicAddr, unsigned char IicData)
{
	unsigned long i;

	IIC3_EStart();

	/* write chip id */
	for (i = 7; i > 0; i--) {
		if ((ChipId >> i) & 0x0001)
			IIC3_EHigh();
		else
			IIC3_ELow();
	}

	/* write */
	IIC3_ELow();

	/* ACK */
	IIC3_EAck_write();

	/* write reg. addr. */
	for (i = 8; i > 0; i--) {
		if ((IicAddr >> (i-1)) & 0x0001)
			IIC3_EHigh();
		else
			IIC3_ELow();
	}

	/* ACK */
	IIC3_EAck_write();

	/* write reg. data. */
	for (i = 8; i > 0; i--) {
		if ((IicData >> (i-1)) & 0x0001)
			IIC3_EHigh();
		else
			IIC3_ELow();
	}

	/* ACK */
	IIC3_EAck_write();

	IIC3_EEnd();
}

void IIC3_ERead(unsigned char ChipId,
		unsigned char IicAddr, unsigned char *IicData)
{
	unsigned long i, reg;
	unsigned char data = 0;

	IIC3_EStart();

	/* write chip id */
	for (i = 7; i > 0; i--) {
		if ((ChipId >> i) & 0x0001)
			IIC3_EHigh();
		else
			IIC3_ELow();
	}

	/* write */
	IIC3_ELow();

	/* ACK */
	IIC3_EAck_write();

	/* write reg. addr. */
	for (i = 8; i > 0; i--) {
		if ((IicAddr >> (i-1)) & 0x0001)
			IIC3_EHigh();
		else
			IIC3_ELow();
	}

	/* ACK */
	IIC3_EAck_write();

	IIC3_EStart();

	/* write chip id */
	for (i = 7; i > 0; i--) {
		if ((ChipId >> i) & 0x0001)
			IIC3_EHigh();
		else
			IIC3_ELow();
	}

	/* read */
	IIC3_EHigh();
	/* ACK */
	IIC3_EAck_write();

	/* read reg. data. */
	IIC3_ESDA_INP;

	IIC3_ESCL_Lo;
	IIC3_ESCL_Lo;
	COMP_Delay();

	for (i = 8; i > 0; i--) {
		IIC3_ESCL_Lo;
		IIC3_ESCL_Lo;
		COMP_Delay();
		IIC3_ESCL_Hi;
		IIC3_ESCL_Hi;
		COMP_Delay();
		reg = GPIO_COMP_DAT;
		IIC3_ESCL_Hi;
		IIC3_ESCL_Hi;
		COMP_Delay();
		IIC3_ESCL_Lo;
		IIC3_ESCL_Lo;
		COMP_Delay();

		reg = (reg >> GPIO_COMP_DAT_SHIFT) & 0x1;

		data |= reg << (i-1);
	}

	/* ACK */
	IIC3_EAck_read();
	IIC3_ESDA_OUTP;

	IIC3_EEnd();

	*IicData = data;
}

void companion_pmic_init(void)
{
	unsigned char pmic_id;
	unsigned char gpio_con;
	unsigned char gpio_dat;

	IIC3_ESetport();

	/* set companion_enable gpio to output */
	gpio_con = readl(GPE0CON_ADDR);
	gpio_con &= GPE0_5_CON_MASK;
	gpio_con |= GPE0_5_CON_OUTPUT;
	writel(gpio_con, GPE0CON_ADDR);

	/* set companion_enable to high */
	gpio_dat = readl(GPE0DAT_ADDR);
	gpio_dat |= GPE0_5_DAT_HIGH;
	writel(gpio_dat, GPE0DAT_ADDR);

	IIC3_EWrite(COMP_PMIC_ADDR, COMP_PMIC_REG_ADDR, COMP_PMIC_REG_VALUE);
}
