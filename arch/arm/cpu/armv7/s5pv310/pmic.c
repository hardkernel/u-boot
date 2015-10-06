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

void IIC1_SCLH_SDAH(void)
{
	IIC1_ESCL_Hi;
	IIC1_ESDA_Hi;
	Delay();
}

void IIC1_SCLH_SDAL(void)
{
	IIC1_ESCL_Hi;
	IIC1_ESDA_Lo;
	Delay();
}

void IIC1_SCLL_SDAH(void)
{
	IIC1_ESCL_Lo;
	IIC1_ESDA_Hi;
	Delay();
}

void IIC1_SCLL_SDAL(void)
{
	IIC1_ESCL_Lo;
	IIC1_ESDA_Lo;
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

void IIC1_ELow(void)
{
	IIC1_SCLL_SDAL();
	IIC1_SCLH_SDAL();
	IIC1_SCLH_SDAL();
	IIC1_SCLL_SDAL();
}

void IIC1_EHigh(void)
{
	IIC1_SCLL_SDAH();
	IIC1_SCLH_SDAH();
	IIC1_SCLH_SDAH();
	IIC1_SCLL_SDAH();
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
	IIC0_ESDA_Lo;
	IIC0_ESCL_Hi;
	IIC0_ESCL_Hi;

	IIC0_ESDA_INP;			// Function <- Input (SDA)
	
	IIC0_SCLL_SDAL();
}

void IIC1_EStart(void)
{
	IIC1_SCLH_SDAH();
	IIC1_SCLH_SDAL();
	Delay();
	IIC1_SCLL_SDAL();
}

void IIC1_EEnd(void)
{
	IIC1_SCLL_SDAL();
	IIC1_SCLH_SDAL();
	Delay();
	IIC1_SCLH_SDAH();
}

void IIC1_EAck(void)
{
	unsigned long ack;

	IIC1_ESDA_INP;			// Function <- Input
	
	IIC1_ESCL_Lo;
	Delay();
	IIC1_ESCL_Hi;
	Delay();
	ack = GPD1DAT;
	IIC1_ESCL_Hi;
	Delay();
	IIC1_ESCL_Hi;
	Delay();

	IIC1_ESDA_OUTP;			// Function <- Output (SDA)

	ack = (ack>>2)&0x1;
//	while(ack!=0);
	
	IIC1_SCLL_SDAL();
}

void IIC0_ESetport(void)
{
	GPD1PUD &= ~(0xf<<0);	// Pull Up/Down Disable	SCL, SDA

	IIC0_ESCL_Hi;
	IIC0_ESDA_Hi;

	IIC0_ESCL_OUTP;		// Function <- Output (SCL)
	IIC0_ESDA_OUTP;		// Function <- Output (SDA)

	Delay();
}

void IIC1_ESetport(void)
{
	GPD1PUD &= ~(0xf<<4);	// Pull Up/Down Disable	SCL, SDA

	IIC1_ESCL_Hi;
	IIC1_ESDA_Hi;

	IIC1_ESCL_OUTP;		// Function <- Output (SCL)
	IIC1_ESDA_OUTP;		// Function <- Output (SDA)

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
	
	for(i = 8; i>0; i--)
	{
		IIC0_ESCL_Lo;
		Delay();
		IIC0_ESCL_Hi;
		Delay();
		reg = GPD1DAT;
		IIC0_ESCL_Hi;
		Delay();
		IIC0_ESCL_Hi;
		Delay();

		reg = (reg >> 0) & 0x1;
		data |= reg << (i-1);
	}

	IIC0_EAck_read();	// ACK
	IIC0_ESDA_OUTP;
	
	IIC0_EEnd();

	*IicData = data;
}


void IIC1_EWrite (unsigned char ChipId, unsigned char IicAddr, unsigned char IicData)
{
	unsigned long i;

	IIC1_EStart();

////////////////// write chip id //////////////////
	for(i = 7; i>0; i--)
	{
		if((ChipId >> i) & 0x0001)
			IIC1_EHigh();
		else
			IIC1_ELow();
	}

	IIC1_ELow();	// write 'W'

	IIC1_EAck();	// ACK

////////////////// write reg. addr. //////////////////
	for(i = 8; i>0; i--)
	{
		if((IicAddr >> (i-1)) & 0x0001)
			IIC1_EHigh();
		else
			IIC1_ELow();
	}

	IIC1_EAck();	// ACK

////////////////// write reg. data. //////////////////
	for(i = 8; i>0; i--)
	{
		if((IicData >> (i-1)) & 0x0001)
			IIC1_EHigh();
		else
			IIC1_ELow();
	}

	IIC1_EAck();	// ACK

	IIC1_EEnd();
}

void I2C_MAX8997_VolSetting(PMIC_RegNum eRegNum, u8 ucVolLevel, u8 ucEnable)
{
	u8 reg_addr, reg_bitpos, reg_bitmask, vol_level;
	u8 read_data;

	reg_bitpos = 0;
	reg_bitmask = 0x3F;
	if(eRegNum == 0)
	{
		reg_addr = 0x19;		
	}
	else if(eRegNum == 1)
	{
		reg_addr = 0x22;
	}
	else if(eRegNum == 2)
	{
		reg_addr = 0x2B;
	}
	else 
		while(1);
	
	vol_level = ucVolLevel&reg_bitmask;

	IIC0_ERead(MAX8997_ADDR, reg_addr, &read_data);

	read_data = (read_data & (~(reg_bitmask<<reg_bitpos))) | (vol_level<<reg_bitpos);
	
	IIC0_EWrite(MAX8997_ADDR, reg_addr, read_data);

	I2C_MAX8997_EnableReg(eRegNum, ucEnable);
}

void I2C_MAX8997_EnableReg(PMIC_RegNum eRegNum, u8 ucEnable)
{
	u8 reg_addr, reg_bitpos;
	u8 read_data;

	reg_bitpos = 0;
	if(eRegNum == 0)
	{
		reg_addr = 0x18;
	}
	else if(eRegNum == 1)
	{
		reg_addr = 0x21;
	}
	else if(eRegNum == 2)
	{
		reg_addr = 0x2A;
	}
	else 
		while(1);

	IIC0_ERead(MAX8997_ADDR, reg_addr, &read_data);

	read_data = (read_data & (~(1<<reg_bitpos))) | (ucEnable<<reg_bitpos);
	
	IIC0_EWrite(MAX8997_ADDR, reg_addr, read_data);
}

void pmic_init(void)
{
	float vdd_arm, vdd_int, vdd_g3d;
	u8 read_data;

	vdd_arm = CONFIG_PM_VDD_ARM;
	vdd_int = CONFIG_PM_VDD_INT;
	vdd_g3d = CONFIG_PM_VDD_G3D;
        
	IIC0_ESetport();
	IIC1_ESetport();

	/* read ID */
	IIC0_ERead(MAX8997_ADDR, 0, &read_data);
	if(read_data == 0x77)
	{
		I2C_MAX8997_VolSetting(PMIC_BUCK1, CALC_MAXIM_BUCK1245_VOLT(vdd_arm * 1000), 1);
		I2C_MAX8997_VolSetting(PMIC_BUCK2, CALC_MAXIM_BUCK1245_VOLT(vdd_int * 1000), 1);
		I2C_MAX8997_VolSetting(PMIC_BUCK3, CALC_MAXIM_BUCK37_VOLT(vdd_g3d * 1000), 1);
	}
	else
	{
		/* VDD_ARM, mode 3 register */
		IIC0_EWrite(MAX8952_ADDR, 0x03, 0x80 | (((unsigned char)(vdd_arm * 100))-77));
		/* VDD_INT, mode 2 register */
		IIC1_EWrite(MAX8649_ADDR, 0x02, 0x80 | (((unsigned char)(vdd_int * 100))-75));
		/* VDD_G3D, mode 2 register */
		IIC0_EWrite(MAX8649A_ADDR, 0x02, 0x80 | (((unsigned char)(vdd_g3d * 100))-75));
	}
}

