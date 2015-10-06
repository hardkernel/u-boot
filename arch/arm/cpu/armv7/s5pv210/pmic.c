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

#include <asm/arch/pmic.h>

void Delay(void)
{
	unsigned long i,j;
	for(i=0;i<DELAY;i++);
}

void SCLH_SDAH()
{
	IIC_ESCL_Hi;
	IIC_ESDA_Hi;
	Delay();
}

void SCLH_SDAL()
{
	IIC_ESCL_Hi;
	IIC_ESDA_Lo;
	Delay();
}

void SCLL_SDAH()
{
	IIC_ESCL_Lo;
	IIC_ESDA_Hi;
	Delay();
}

void SCLL_SDAL()
{
	IIC_ESCL_Lo;
	IIC_ESDA_Lo;
	Delay();
}

void IIC_ELow()
{
	SCLL_SDAL();
	SCLH_SDAL();
	SCLH_SDAL();
	SCLL_SDAL();
}

void IIC_EHigh()
{
	SCLL_SDAH();
	SCLH_SDAH();
	SCLH_SDAH();
	SCLL_SDAH();
}

void IIC_EStart()
{
	SCLH_SDAH();
	SCLH_SDAL();
	Delay();
	SCLL_SDAL();
}

void IIC_EEnd()
{
	SCLL_SDAL();
	SCLH_SDAL();
	Delay();
	SCLH_SDAH();
}

void IIC_EAck()
{
	unsigned long ack;

	IIC_ESDA_INP;			// Function <- Input
	
	IIC_ESCL_Lo;
	Delay();
	IIC_ESCL_Hi;
	Delay();
	ack = GPD1DAT;
	IIC_ESCL_Hi;
	Delay();
	IIC_ESCL_Hi;
	Delay();

	IIC_ESDA_OUTP;			// Function <- Output (SDA)

	ack = (ack>>4)&0x1;
	while(ack!=0);
	
	SCLL_SDAL();
}

void IIC_ESetport(void)
{
	GPD1PUD &= ~(0xf<<8);	// Pull Up/Down Disable	SCL, SDA

	IIC_ESCL_Hi;
	IIC_ESDA_Hi;

	IIC_ESCL_OUTP;		// Function <- Output (SCL)
	IIC_ESDA_OUTP;		// Function <- Output (SDA)

	Delay();
}

void IIC_EWrite (unsigned char ChipId, unsigned char IicAddr, unsigned char IicData)
{
	unsigned long i;

	IIC_EStart();

////////////////// write chip id //////////////////
	for(i = 7; i>0; i--)
	{
		if((ChipId >> (i-1)) & 0x0001)
			IIC_EHigh();
		else
			IIC_ELow();
	}

	IIC_ELow();	// write 'W'

	IIC_EAck();	// ACK

////////////////// write reg. addr. //////////////////
	for(i = 8; i>0; i--)
	{
		if((IicAddr >> (i-1)) & 0x0001)
			IIC_EHigh();
		else
			IIC_ELow();
	}

	IIC_EAck();	// ACK

////////////////// write reg. data. //////////////////
	for(i = 8; i>0; i--)
	{
		if((IicData >> (i-1)) & 0x0001)
			IIC_EHigh();
		else
			IIC_ELow();
	}

	IIC_EAck();	// ACK

	IIC_EEnd();
}

void pmic_init(void)
{
	IIC_ESetport();

#if !(defined(CONFIG_SMDKC110_REV03) || defined(CONFIG_SMDKV210_REV02))
	IIC_EWrite(MAX8698_ADDR, 0x00, 0x3E);
	IIC_EWrite(MAX8698_ADDR, 0x01, 0xF0);

	// VDD_ARM
#if defined(CONFIG_CLK_1200_200_166_133)
	IIC_EWrite(MAX8698_ADDR, 0x04, 0xBB);	// default:0x99=>1.2v, 0xBB=>1.30v
	IIC_EWrite(MAX8698_ADDR, 0x05, 0xBB);	// default:0x99=>1.2v, 0xBB=>1.30v
#elif defined (CONFIG_CLK_1000_200_166_133)
	IIC_EWrite(MAX8698_ADDR, 0x04, 0xAA);	// default:0x99=>1.2v, 0xAA=>1.25v
	IIC_EWrite(MAX8698_ADDR, 0x05, 0xAA);	// default:0x99=>1.2v, 0xAA=>1.25v
#else
	IIC_EWrite(MAX8698_ADDR, 0x04, 0x99);	// default:0x99=>1.2v, 0x99=>1.2v
	IIC_EWrite(MAX8698_ADDR, 0x05, 0x99);	// default:0x99=>1.2v, 0x99=>1.2v
#endif

	// VDD_INT
#if defined(CONFIG_CLK_1200_200_166_133)
	IIC_EWrite(MAX8698_ADDR, 0x06, 0x88);	// default:0x99=>1.2v, 0x88=>1.15v
#else
	IIC_EWrite(MAX8698_ADDR, 0x06, 0x77);	// default:0x99=>1.2v, 0x77=>1.1v
#endif
	IIC_EWrite(MAX8698_ADDR, 0x07, 0x02);

	IIC_EWrite(MAX8698_ADDR, 0x08, 0x66);
	IIC_EWrite(MAX8698_ADDR, 0x09, 0x02);
	IIC_EWrite(MAX8698_ADDR, 0x0A, 0x0C);
	IIC_EWrite(MAX8698_ADDR, 0x0B, 0x0A);
	IIC_EWrite(MAX8698_ADDR, 0x0C, 0x0E);
	IIC_EWrite(MAX8698_ADDR, 0x0D, 0x33);
	IIC_EWrite(MAX8698_ADDR, 0x0E, 0x0E);
#else	/* CONFIG_SMDKC110_REV03, CONFIG_SMDKV210_REV02 */
	IIC_EWrite(MAX8998_ADDR, 0x11, 0x2F);	// VDD_ARM, VDD_INT disable
	IIC_EWrite(MAX8998_ADDR, 0x12, 0xFB);
	IIC_EWrite(MAX8998_ADDR, 0x13, 0x00);

	// VDD_ARM
#if defined(CONFIG_CLK_1200_200_166_133)
	IIC_EWrite(MAX8998_ADDR, 0x15, 0x16);	// default:0x12=>1.2v, 0x16=>1.30v
	IIC_EWrite(MAX8998_ADDR, 0x16, 0x16);	// default:0x12=>1.2v, 0x16=>1.30v
	IIC_EWrite(MAX8998_ADDR, 0x17, 0x16);	// default:0x12=>1.2v, 0x16=>1.30v
	IIC_EWrite(MAX8998_ADDR, 0x18, 0x16);	// default:0x12=>1.2v, 0x16=>1.30v
#elif defined (CONFIG_CLK_1000_200_166_133)
	IIC_EWrite(MAX8998_ADDR, 0x15, 0x14);	// default:0x12=>1.2v, 0x14=>1.25v
	IIC_EWrite(MAX8998_ADDR, 0x16, 0x14);	// default:0x12=>1.2v, 0x14=>1.25v
	IIC_EWrite(MAX8998_ADDR, 0x17, 0x14);	// default:0x12=>1.2v, 0x14=>1.25v
	IIC_EWrite(MAX8998_ADDR, 0x18, 0x14);	// default:0x12=>1.2v, 0x14=>1.25v
#else
	IIC_EWrite(MAX8998_ADDR, 0x15, 0x12);	// default:0x12=>1.2v, 0x12=>1.2v
	IIC_EWrite(MAX8998_ADDR, 0x16, 0x12);	// default:0x12=>1.2v, 0x12=>1.2v
	IIC_EWrite(MAX8998_ADDR, 0x17, 0x12);	// default:0x12=>1.2v, 0x12=>1.2v
	IIC_EWrite(MAX8998_ADDR, 0x18, 0x12);	// default:0x12=>1.2v, 0x12=>1.2v
#endif

	// VDD_INT
#if defined(CONFIG_CLK_1200_200_166_133)
	IIC_EWrite(MAX8998_ADDR, 0x19, 0x10);	// default:0x12=>1.2v, 0x10=>1.15v
	IIC_EWrite(MAX8998_ADDR, 0x1A, 0x10);	// default:0x12=>1.2v, 0x10=>1.15v
#else
	IIC_EWrite(MAX8998_ADDR, 0x19, 0x0E);	// default:0x12=>1.2v, 0x0E=>1.1v
	IIC_EWrite(MAX8998_ADDR, 0x1A, 0x0E);	// default:0x12=>1.2v, 0x0E=>1.1v
#endif
	// VDD_MEM
	IIC_EWrite(MAX8998_ADDR, 0x1B, 0x02);	// default:0x02=>1.8v, 0x02=>1.8v

	IIC_EWrite(MAX8998_ADDR, 0x1D, 0x66);	// LDO2 = 1.1v, LDO3 = 1.1v
	IIC_EWrite(MAX8998_ADDR, 0x1E, 0x02);	// LDO4 = 1.8v
	IIC_EWrite(MAX8998_ADDR, 0x1F, 0x0C);	// LDO5 = 2.8v
	IIC_EWrite(MAX8998_ADDR, 0x20, 0x0A);	// LDO6 = 2.6v
	IIC_EWrite(MAX8998_ADDR, 0x21, 0x0E);	// LDO7 = 3.0v
	IIC_EWrite(MAX8998_ADDR, 0x22, 0x32);	// LDO8 = 3.3v, LDO9 = 3.0v

	IIC_EWrite(MAX8998_ADDR, 0x23, 0x60);	// LDO10 = 1.1v, LDO11 = not used
	IIC_EWrite(MAX8998_ADDR, 0x24, 0x03);	// LDO12 = 1.1v
	IIC_EWrite(MAX8998_ADDR, 0x25, 0x14);	// LDO13 = 2.8v
#endif
}

