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
#include <asm/arch/pmic.h>
#include <asm/arch/cpu.h>

void Delay(void)
{
	unsigned long i;
	for (i = 0; i < DELAY; i++)
		;
}

void IIC0_SCLH_SDAH(void)
{
	IIC0_ESCL_Hi;
	IIC0_ESDA_Hi;
	Delay();
}

void IIC0_SCLH_SDAL(void)
{
	IIC0_ESCL_Hi;
	IIC0_ESDA_Lo;
	Delay();
}

void IIC0_SCLL_SDAH(void)
{
	IIC0_ESCL_Lo;
	IIC0_ESDA_Hi;
	Delay();
}

void IIC0_SCLL_SDAL(void)
{
	IIC0_ESCL_Lo;
	IIC0_ESDA_Lo;
	Delay();
}

void IIC0_ELow(void)
{
	IIC0_SCLL_SDAL();
	IIC0_SCLH_SDAL();
	IIC0_SCLH_SDAL();
	IIC0_SCLL_SDAL();
}

void IIC0_EHigh(void)
{
	IIC0_SCLL_SDAH();
	IIC0_SCLH_SDAH();
	IIC0_SCLH_SDAH();
	IIC0_SCLL_SDAH();
}

void IIC0_EStart(void)
{
	IIC0_SCLH_SDAH();
	IIC0_SCLH_SDAL();
	Delay();
	IIC0_SCLL_SDAL();
}

void IIC0_EEnd(void)
{
	IIC0_SCLL_SDAL();
	IIC0_SCLH_SDAL();
	Delay();
	IIC0_SCLH_SDAH();
}

void IIC0_EAck_write(void)
{
	unsigned long ack;

	/* Function <- Input */
	IIC0_ESDA_INP;

	IIC0_ESCL_Lo;
	Delay();
	IIC0_ESCL_Hi;
	Delay();
	ack = GPD1DAT;
	IIC0_ESCL_Hi;
	Delay();
	IIC0_ESCL_Hi;
	Delay();

	/* Function <- Output (SDA) */
	IIC0_ESDA_OUTP;

	ack = (ack>>0)&0x1;

	IIC0_SCLL_SDAL();
}

void IIC0_EAck_read(void)
{
	/* Function <- Output */
	IIC0_ESDA_OUTP;

	IIC0_ESCL_Lo;
	IIC0_ESCL_Lo;
	IIC0_ESDA_Hi;
	IIC0_ESCL_Hi;
	IIC0_ESCL_Hi;
	/* Function <- Input (SDA) */
	IIC0_ESDA_INP;

	IIC0_SCLL_SDAL();
}

void IIC0_ESetport(void)
{
	/* Pull Up/Down Disable	SCL, SDA */
	GPD1PUD &= ~(0xf<<0);

	IIC0_ESCL_Hi;
	IIC0_ESDA_Hi;

	/* Function <- Output (SCL) */
	IIC0_ESCL_OUTP;
	/* Function <- Output (SDA) */
	IIC0_ESDA_OUTP;

	Delay();
}

void IIC0_EWrite(unsigned char ChipId,
		unsigned char IicAddr, unsigned char IicData)
{
	unsigned long i;

	IIC0_EStart();

	/* write chip id */
	for (i = 7; i > 0; i--) {
		if ((ChipId >> i) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	/* write */
	IIC0_ELow();

	/* ACK */
	IIC0_EAck_write();

	/* write reg. addr. */
	for (i = 8; i > 0; i--) {
		if ((IicAddr >> (i-1)) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	/* ACK */
	IIC0_EAck_write();

	/* write reg. data. */
	for (i = 8; i > 0; i--) {
		if ((IicData >> (i-1)) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	/* ACK */
	IIC0_EAck_write();

	IIC0_EEnd();
}

void IIC0_ERead(unsigned char ChipId,
		unsigned char IicAddr, unsigned char *IicData)
{
	unsigned long i, reg;
	unsigned char data = 0;

	IIC0_EStart();

	/* write chip id */
	for (i = 7; i > 0; i--) {
		if ((ChipId >> i) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	/* write */
	IIC0_ELow();

	/* ACK */
	IIC0_EAck_write();

	/* write reg. addr. */
	for (i = 8; i > 0; i--) {
		if ((IicAddr >> (i-1)) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	/* ACK */
	IIC0_EAck_write();

	IIC0_EStart();

	/* write chip id */
	for (i = 7; i > 0; i--) {
		if ((ChipId >> i) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	/* read */
	IIC0_EHigh();
	/* ACK */
	IIC0_EAck_write();

	/* read reg. data. */
	IIC0_ESDA_INP;

	IIC0_ESCL_Lo;
	IIC0_ESCL_Lo;
	Delay();

	for (i = 8; i > 0; i--) {
		IIC0_ESCL_Lo;
		IIC0_ESCL_Lo;
		Delay();
		IIC0_ESCL_Hi;
		IIC0_ESCL_Hi;
		Delay();
		reg = GPD1DAT;
		IIC0_ESCL_Hi;
		IIC0_ESCL_Hi;
		Delay();
		IIC0_ESCL_Lo;
		IIC0_ESCL_Lo;
		Delay();

		reg = (reg >> 0) & 0x1;

		data |= reg << (i-1);
	}

	/* ACK */
	IIC0_EAck_read();
	IIC0_ESDA_OUTP;

	IIC0_EEnd();

	*IicData = data;
}

void pmic_init(void)
{
	float vdd_arm, vdd_kfc;
	float vdd_int, vdd_g3d, vdd_mif;

	vdd_arm = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_ARM);
	vdd_kfc = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_KFC);
	vdd_mif = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_MIF);
	vdd_int = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_INT);
	vdd_g3d = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_G3D);

	IIC0_ESetport();
	/* BUCK2 VDD_ARM */
	IIC0_EWrite(0xcc, 0x28, vdd_arm);
	/* BUCK6 VDD_KFC */
	IIC0_EWrite(0xcc, 0x34, vdd_kfc);
	/* BUCK1 VDD_MIF */
	IIC0_EWrite(0xcc, 0x26, vdd_mif);
	/* BUCK3 VDD_INT */
	IIC0_EWrite(0xcc, 0x2a, vdd_int);
	/* BUCK4 VDD_G3D */
	IIC0_EWrite(0xcc, 0x2c, vdd_g3d);
}
