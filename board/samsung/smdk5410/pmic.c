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

#include <common.h>
#include <asm/arch/pmic.h>

void Delay(void)
{
	unsigned long i;
	for(i=0;i<DELAY;i++);
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

	IIC0_ESDA_INP;			// Function <- Input

	IIC0_ESCL_Lo;
	Delay();
	IIC0_ESCL_Hi;
	Delay();
	ack = GPD1DAT;
	IIC0_ESCL_Hi;
	Delay();
	IIC0_ESCL_Hi;
	Delay();

	IIC0_ESDA_OUTP;			// Function <- Output (SDA)

	ack = (ack>>0)&0x1;
//	while(ack!=0);

	IIC0_SCLL_SDAL();
}

void IIC0_EAck_read(void)
{
	IIC0_ESDA_OUTP;			// Function <- Output

	IIC0_ESCL_Lo;
	IIC0_ESCL_Lo;
	IIC0_ESDA_Hi;
	IIC0_ESCL_Hi;
	IIC0_ESCL_Hi;

	IIC0_ESDA_INP;			// Function <- Input (SDA)

	IIC0_SCLL_SDAL();
}

void IIC0_ESetport(void)
{
#ifdef CONFIG_MACH_UNIVERSAL5410
	GPD1PUD |= (0xf<<4);
#else
	GPD1PUD &= ~(0xf<<0);	// Pull Up/Down Disable	SCL, SDA
#endif

	IIC0_ESCL_Hi;
	IIC0_ESDA_Hi;

	IIC0_ESCL_OUTP;		// Function <- Output (SCL)
	IIC0_ESDA_OUTP;		// Function <- Output (SDA)

	Delay();
}

void IIC0_EWrite (unsigned char ChipId, unsigned char IicAddr, unsigned char IicData)
{
	unsigned long i;

	IIC0_EStart();

////////////////// write chip id //////////////////
	for(i = 7; i>0; i--)
	{
		if((ChipId >> i) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	IIC0_ELow();	// write

	IIC0_EAck_write();	// ACK

////////////////// write reg. addr. //////////////////
	for(i = 8; i>0; i--)
	{
		if((IicAddr >> (i-1)) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	IIC0_EAck_write();	// ACK

////////////////// write reg. data. //////////////////
	for(i = 8; i>0; i--)
	{
		if((IicData >> (i-1)) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	IIC0_EAck_write();	// ACK

	IIC0_EEnd();
}

void IIC0_ERead (unsigned char ChipId, unsigned char IicAddr, unsigned char *IicData)
{
	unsigned long i, reg;
	unsigned char data = 0;

	IIC0_EStart();

////////////////// write chip id //////////////////
	for(i = 7; i>0; i--)
	{
		if((ChipId >> i) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	IIC0_ELow();	// write

	IIC0_EAck_write();	// ACK

////////////////// write reg. addr. //////////////////
	for(i = 8; i>0; i--)
	{
		if((IicAddr >> (i-1)) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	IIC0_EAck_write();	// ACK

	IIC0_EStart();

////////////////// write chip id //////////////////
	for(i = 7; i>0; i--)
	{
		if((ChipId >> i) & 0x0001)
			IIC0_EHigh();
		else
			IIC0_ELow();
	}

	IIC0_EHigh();	// read

	IIC0_EAck_write();	// ACK

////////////////// read reg. data. //////////////////
	IIC0_ESDA_INP;

	IIC0_ESCL_Lo;
	IIC0_ESCL_Lo;
	Delay();

	for(i = 8; i>0; i--)
	{
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
#ifdef CONFIG_MACH_UNIVERSAL5410
		reg = (reg >> 2) & 0x1;
#else
		reg = (reg >> 0) & 0x1;
#endif

		data |= reg << (i-1);
	}

	IIC0_EAck_read();	// ACK
	IIC0_ESDA_OUTP;

	IIC0_EEnd();

	*IicData = data;
}


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


void pmic_init(void)
{
	float vdd_arm, vdd_kfc;
	float vdd_int, vdd_g3d;
	unsigned char chk_ver;

	vdd_arm = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_ARM);
	vdd_kfc = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_KFC);
	vdd_int = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_INT);
	vdd_g3d = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_G3D);

	IIC0_ESetport();
	IIC0_EWrite(0xcc, 0x28, vdd_arm); // BUCK2 VDD_ARM
	IIC0_EWrite(0xcc, 0x2a, vdd_int); // BUCK3 VDD_INT
	IIC0_EWrite(0xcc, 0x2c, vdd_g3d); // BUCK4 VDD_G3D
	IIC0_EWrite(0xcc, 0x34, vdd_kfc); // BUCK6 VDD_KFC

	IIC0_ERead(0xcc, 0x00, &chk_ver);
	if (chk_ver == 0x00) {
		IIC0_EWrite(0xcc, 0x43, 0xD4); // LDO7 always on
		IIC0_EWrite(0xcc, 0x49, 0xE8); // LDO13 always on

		IIC0_EWrite(0xcc, 0x39, 0xD8); // BUCK-Boost Enable
		IIC0_EWrite(0xcc, 0x8D, 0x4F); // BUCK-Boost Burn Protection

		IIC0_EWrite(0xcc, 0x8C, 0x52);

		IIC0_EWrite(0xcc, 0x81, 0x53);
		IIC0_EWrite(0xcc, 0x87, 0x66);
		IIC0_EWrite(0xcc, 0x94, 0x66);
	}
	else if (chk_ver == 0x02) {
		IIC0_EWrite(0xcc, 0x91, 0xF3); // BUCK1 undershoot
		IIC0_EWrite(0xcc, 0x97, 0xF3); // BUCK6 undershoot
	}

#ifdef CONFIG_MACH_UNIVERSAL5410
	IIC0_EWrite(0xcc, 0x0B, 0x07); /* 32KHZ_AP/CP/BT Enable */
#endif

	/* To advance margin, below EMA setting is executed */
	/* If you use EMA, remove comment mark and use below function */
	/* pmic_ema_init(); */
}


void pmic_late_init(void)
{
	float vdd_mif;

	vdd_mif = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_MIF);

	IIC0_ESetport();
	IIC0_EWrite(0xcc, 0x26, vdd_mif); // BUCK1 VDD_MIF
}
