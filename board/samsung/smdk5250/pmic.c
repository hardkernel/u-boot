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
#include <asm/arch/cpu.h>

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
	GPD1PUD &= ~(0xf<<0);	// Pull Up/Down Disable	SCL, SDA

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

		reg = (reg >> 0) & 0x1;

		data |= reg << (i-1);
	}

	IIC0_EAck_read();	// ACK
	IIC0_ESDA_OUTP;

	IIC0_EEnd();

	*IicData = data;
}

#define CALC_S5M8767_BUCK234_VOLT(x)	( (x<600) ? 0 : ((x-600)/6.25) )
#define CALC_S5M8767_BUCK156_VOLT(x)	( (x<650) ? 0 : ((x-650)/6.25) )
#define CALC_S5M8767_LDO1267815_VOLT(x)	( (x<800) ? 0 : ((x-800)/25) )
#define CALC_S5M8767_ALL_LDO_VOLT(x)	( (x<800) ? 0 : ((x-800)/50) )

void I2C_S5M8767_VolSetting(PMIC_RegNum eRegNum, unsigned char ucVolLevel, unsigned char ucEnable)
{
	unsigned char reg_addr, reg_bitpos, reg_bitmask, vol_level;

	reg_bitpos = 0;
	reg_bitmask = 0xFF;
	if(eRegNum == 0)  // BUCK1
	{
		reg_addr = 0x33;
	}
	else if(eRegNum == 1)  // BUCK2
	{
		reg_addr = 0x35;
	}
	else if(eRegNum == 2)  //  BUCK3
	{
		reg_addr = 0x3E;
	}
	else if(eRegNum == 3)  // BUCK4
	{
		reg_addr = 0x47;
	}
	else if(eRegNum == 4)  // LDO2
	{
		reg_addr = 0x5D;
		reg_bitmask = 0x3F;
	}
	else if(eRegNum == 5)  // LDO3
	{
		reg_addr = 0x61;
		reg_bitmask = 0x3F;
	}
	else if(eRegNum == 6)  // LDO5
	{
		reg_addr = 0x63;
		reg_bitmask = 0x3F;
	}
	else if(eRegNum == 7)  // LDO10
	{
		reg_addr = 0x68;
		reg_bitmask = 0x3F;
	}
	else if(eRegNum == 8)  // LDO7
	{
		reg_addr = 0x65;
		reg_bitmask = 0x3F;
	}
	else if(eRegNum == 9) // BUCK5
	{
		reg_addr = 0x50;
	}
	else
		while(1);

	vol_level = ucVolLevel & reg_bitmask | (ucEnable << 6);
	IIC0_EWrite(S5M8767_ADDR, reg_addr, vol_level);

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
	else if(eRegNum == 3)
	{
		reg_addr = 0x2C;
	}
	else if(eRegNum == 4)
	{
		reg_addr = 0x48;
		reg_bitpos = 0x6;
	}
	else if(eRegNum == 5)
	{
		reg_addr = 0x44;
		reg_bitpos = 0x6;
	}
	else if(eRegNum == 6)
	{
		reg_addr = 0x4D;
		reg_bitpos = 0x6;
	}
	else
		while(1);

	IIC0_ERead(MAX8997_ADDR, reg_addr, &read_data);

	read_data = (read_data & (~(1<<reg_bitpos))) | (ucEnable<<reg_bitpos);

	IIC0_EWrite(MAX8997_ADDR, reg_addr, read_data);
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
	else if(eRegNum == 3)
	{
		reg_addr = 0x2D;
	}
	else if(eRegNum == 4)
	{
		reg_addr = 0x48;
	}
	else if(eRegNum == 5)
	{
		reg_addr = 0x44;
	}
	else if(eRegNum == 6)
	{
		reg_addr = 0x4D;
	}
	else
		while(1);

	vol_level = ucVolLevel&reg_bitmask;

	IIC0_ERead(MAX8997_ADDR, reg_addr, &read_data);

	read_data = (read_data & (~(reg_bitmask<<reg_bitpos))) | (vol_level<<reg_bitpos);

	IIC0_EWrite(MAX8997_ADDR, reg_addr, read_data);

	I2C_MAX8997_EnableReg(eRegNum, ucEnable);
}

void I2C_MAX77686_EnableReg(PMIC_RegNum eRegNum, u8 ucEnable)
{
	u8 reg_addr, reg_bitpos;
	u8 read_data;

	reg_bitpos = 0;
	if(eRegNum == 0)
	{
		reg_addr = 0x10;
	}
	else if(eRegNum == 1)
	{
		reg_addr = 0x12;
		reg_bitpos = 0x4;
	}
	else if(eRegNum == 2)
	{
		reg_addr = 0x1C;
		reg_bitpos = 0x4;
	}
	else if(eRegNum == 3)
	{
		reg_addr = 0x26;
		reg_bitpos = 0x4;
	}
	else if(eRegNum == 9)
	{
		reg_addr = 0x30;
	}
	else
		while(1);

	IIC0_ERead(MAX77686_ADDR, reg_addr, &read_data);

	read_data = (read_data & (~(0x3<<reg_bitpos))) | (ucEnable<<reg_bitpos);

	IIC0_EWrite(MAX77686_ADDR, reg_addr, read_data);
}

void I2C_MAX77686_VolSetting(PMIC_RegNum eRegNum, u8 ucVolLevel, u8 ucEnable)
{
	u8 reg_addr, vol_bitpos, reg_bitmask, vol_level;
	u8 read_data;

	vol_bitpos = 0;
	reg_bitmask = 0x3F;
	if(eRegNum == 0)
	{
		reg_addr = 0x11;
	}
	else if(eRegNum == 1)
	{
		reg_addr = 0x14;
		reg_bitmask = 0xff;
	}
	else if(eRegNum == 2)
	{
		reg_addr = 0x1E;
	}
	else if(eRegNum == 3)
	{
		reg_addr = 0x28;
	}
	else if(eRegNum == 4)
	{
		reg_addr = 0x41;
	}
	else if(eRegNum == 5)
	{
		reg_addr = 0x42;
	}
	else if(eRegNum == 6)
	{
		reg_addr = 0x44;
	}
	else if(eRegNum == 7)
	{
		reg_addr = 0x49;
	}
	else if(eRegNum == 8)
	{
		reg_addr = 0x46;
	}
	else if(eRegNum == 9)
	{
		reg_addr = 0x31;
	}
	else
		while(1);

	vol_level = ucVolLevel;

	IIC0_ERead(MAX77686_ADDR, reg_addr, &read_data);

	read_data = (read_data & (~(reg_bitmask<<vol_bitpos))) | (vol_level<<vol_bitpos);

	if (reg_addr < 0x40) {
		/* BUCK Voltage Set */
		IIC0_EWrite(MAX77686_ADDR, reg_addr, read_data);
		/* Buck Enable */
		I2C_MAX77686_EnableReg(eRegNum, ucEnable);
	} else {
		/* LDO Voltage Set & Enable */
		read_data = (read_data | ucEnable);
		IIC0_EWrite(MAX77686_ADDR, reg_addr, read_data);
	}

}

void pmic8997_init(void)
{
	u8 vdd_arm, vdd_int, vdd_g3d;
	u8 vdd_mif;
	u8 vdd_apll;
	u8 vddq_m1_m2;

		vdd_arm = CALC_MAXIM_BUCK1245_VOLT(CONFIG_PM_VDD_ARM);
		vdd_int = CALC_MAXIM_BUCK1245_VOLT(CONFIG_PM_VDD_INT);
		vdd_g3d = CALC_MAXIM_BUCK37_VOLT(CONFIG_PM_VDD_G3D);
		vdd_mif = CALC_MAXIM_BUCK1245_VOLT(CONFIG_PM_VDD_MIF);
#if defined(CONFIG_PM_VDD_APLL)
		vdd_apll = CALC_MAXIM_ALL_LDO(CONFIG_PM_VDD_APLL);
#endif
#if defined(CONFIG_PM_VDDQ_M1_M2)
		vddq_m1_m2 = CALC_MAXIM_ALL_LDO(CONFIG_PM_VDDQ_M1_M2);
#endif

		I2C_MAX8997_VolSetting(PMIC_BUCK1, vdd_arm, 1);
		I2C_MAX8997_VolSetting(PMIC_BUCK2, vdd_int, 1);
		I2C_MAX8997_VolSetting(PMIC_BUCK3, vdd_g3d, 1);
		I2C_MAX8997_VolSetting(PMIC_BUCK4, vdd_mif, 1);
#if defined(CONFIG_PM_VDD_APLL)
		/* LDO10: APLL VDD */
		I2C_MAX8997_VolSetting(PMIC_LDO10, vdd_apll, 3);
#endif
#if defined(CONFIG_PM_VDDQ_M1_M2)
		/* VDDQ_M1_M, VDDQ_M2_M */
		I2C_MAX8997_VolSetting(PMIC_LDO21, vddq_m1_m2, 3);
#endif
}

void pmic77686_init(void)
{
	u8 vdd_arm, vdd_int, vdd_g3d;
	u8 vdd_mif;
	u8 vdd_mem, vdd_mem_set = 0;
	u8 vddq_m1_m2, vddq_m1_m2_set = 0;
	u8 vdd_apll;

#if defined(CONFIG_CPU_EXYNOS5250_EVT1)
	/* set DVS1,2,3 as 0 by GPD1 */
	*((volatile unsigned int *)0x11400180) = 0x00000111;	/* DVS1~3 : GPD1_0~2(output) */
	*((volatile unsigned int *)0x11400C40) = 0x00111000;	/* SELB1~3 : GPX2_3~5(output) */
	*((volatile unsigned int *)0x11400184) = 0x0;		/* DVS1~3 : Low */
	*((volatile unsigned int *)0x11400C44) = 0x0;		/* SELB1~3 : Low */
	*((volatile unsigned int *)0x11400C44) = 0x38;		/* SELB1~3 : High */
	*((volatile unsigned int *)0x11400C44) = 0x0;		/* SELB1~3 : Low */
	*((volatile unsigned int *)0x11400180) = 0x0;		/* DVS1~3 : GPD1_0~2(input) */
	*((volatile unsigned int *)0x11400C40) = 0x0;		/* SELB1~3 : GPX2_3~5(input) */

	if(PRO_PKGINFO == POP_TYPE) {
		vdd_arm = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_PM_VDD_ARM);
		vdd_int = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_PM_VDD_INT);
		vdd_g3d = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_PM_VDD_G3D);
		vdd_mif = CALC_MAXIM77686_BUCK156789_VOLT(CONFIG_PM_VDD_MIF);
#if defined(CONFIG_PM_VDD_MEM)
		vdd_mem = CALC_MAXIM77686_BUCK156789_VOLT(CONFIG_PM_VDD_MEM);
		vdd_mem_set = 1;
#endif
#if defined(CONFIG_PM_VDDQ_M1_M2)
		vddq_m1_m2 = CALC_MAXIM77686_LDO1267815_VOLT(CONFIG_PM_VDDQ_M1_M2);
		vddq_m1_m2_set = 1;
#endif
	} else {
		vdd_arm = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_SCP_PM_VDD_ARM);
		vdd_int = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_SCP_PM_VDD_INT);
		vdd_g3d = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_SCP_PM_VDD_G3D);
		vdd_mif = CALC_MAXIM77686_BUCK156789_VOLT(CONFIG_SCP_PM_VDD_MIF);
#if defined(CONFIG_SCP_PM_VDD_MEM)
		vdd_mem = CALC_MAXIM77686_BUCK156789_VOLT(CONFIG_SCP_PM_VDD_MEM);
		vdd_mem_set = 1;
#endif
#if defined(CONFIG_SCP_PM_VDDQ_M1_M2)
		vddq_m1_m2 = CALC_MAXIM77686_LDO1267815_VOLT(CONFIG_SCP_PM_VDDQ_M1_M2);
		vddq_m1_m2_set = 1;
#endif
	}
#else
		vdd_arm = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_PM_VDD_ARM);
		vdd_int = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_PM_VDD_INT);
		vdd_g3d = CALC_MAXIM77686_BUCK234_VOLT(CONFIG_PM_VDD_G3D);
		vdd_mif = CALC_MAXIM77686_BUCK156789_VOLT(CONFIG_PM_VDD_MIF);
#if defined(CONFIG_PM_VDD_MEM)
		vdd_mem = CALC_MAXIM77686_BUCK156789_VOLT(CONFIG_PM_VDD_MEM);
		vdd_mem_set = 1;
#endif
#if defined(CONFIG_PM_VDD_APLL)
		vdd_apll = CALC_MAXIM77686_LDO1267815_VOLT(CONFIG_PM_VDD_APLL);
#endif
#if defined(CONFIG_PM_VDDQ_M1_M2)
		vddq_m1_m2 = CALC_MAXIM77686_LDO1267815_VOLT(CONFIG_PM_VDDQ_M1_M2);
		vddq_m1_m2_set = 1;
#endif
#endif /* CONFIG_CPU_EXYNOS5250_EVT1 */

	/* ARM VDD */
	I2C_MAX77686_VolSetting(PMIC_BUCK2, vdd_arm, 1);
	/* INT VDD */
	I2C_MAX77686_VolSetting(PMIC_BUCK3, vdd_int, 1);
	/* G3D VDD */
	I2C_MAX77686_VolSetting(PMIC_BUCK4, vdd_g3d, 1);
	/* MIF VDD */
	I2C_MAX77686_VolSetting(PMIC_BUCK1, vdd_mif, 3);
	/* MEM VDD */
	if (vdd_mem_set)
		I2C_MAX77686_VolSetting(0x09, vdd_mem, 3);
	/* LDO2: VDDQ_M1_M, VDDQ_M2_M */
	if (vddq_m1_m2_set)
		I2C_MAX77686_VolSetting(0x04, vddq_m1_m2, 3);
#if defined(CONFIG_PM_VDD_APLL)
	/* LDO7: APLL VDD */
	I2C_MAX77686_VolSetting(0x08, vdd_apll, 3);
#endif
}

void pmic8767_init(void)
{
#if defined(CONFIG_CPU_EXYNOS5250_EVT1)
	u8 vdd_arm, vdd_int, vdd_g3d;
	u8 vdd_mif;
	u8 vdd_mem, vdd_mem_set = 0;
	u8 vddq_m1_m2, vddq_m1_m2_set = 0;
	u8 vdd_apll;

	if (PRO_PKGINFO == POP_TYPE) {

	} else {
		vdd_arm = CALC_S5M8767_BUCK234_VOLT(CONFIG_SCP_PM_VDD_ARM);
		vdd_int = CALC_S5M8767_BUCK234_VOLT(CONFIG_SCP_PM_VDD_INT);
		vdd_g3d = CALC_S5M8767_BUCK234_VOLT(CONFIG_SCP_PM_VDD_G3D);
		vdd_mif = CALC_S5M8767_BUCK156_VOLT(CONFIG_SCP_PM_VDD_MIF);
#if defined(CONFIG_SCP_PM_VDDQ_M1_M2)
		vddq_m1_m2 = CALC_S5M8767_LDO1267815_VOLT(CONFIG_SCP_PM_VDDQ_M1_M2);
		vddq_m1_m2_set = 1;
#endif
	}

	I2C_S5M8767_VolSetting(PMIC_BUCK1, vdd_mif, 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK2, vdd_arm, 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK3, vdd_int, 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK4, vdd_g3d, 1);
	if (vddq_m1_m2_set)
		I2C_S5M8767_VolSetting(0x04, vddq_m1_m2, 3);

	/* BUCK9: VDDF_eMMC 2.8V */
	IIC0_EWrite(S5M8767_ADDR, 0x5A, 0x58);

	/* BUCK6: Memory */
	IIC0_EWrite(S5M8767_ADDR, 0x54, 0x58);

	/* LDO4: VDD_eMMC_1V8_PM */
	IIC0_EWrite(S5M8767_ADDR, 0x62, 0x14);

	/* BUCK3: remote sense on */
	IIC0_EWrite(S5M8767_ADDR, 0x3D, 0xFA);

#else
	float vdd_arm, vdd_int, vdd_g3d;
	float vdd_mif;

	vdd_arm = CONFIG_PM_VDD_ARM;
	vdd_int = CONFIG_PM_VDD_INT;
	vdd_g3d = CONFIG_PM_VDD_G3D;
	vdd_mif = CONFIG_PM_VDD_MIF;

#ifdef CONFIG_DDR3
	I2C_S5M8767_VolSetting(PMIC_BUCK1, CALC_S5M8767_BUCK156_VOLT(vdd_mif), 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK2, CALC_S5M8767_BUCK234_VOLT(vdd_arm), 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK3, CALC_S5M8767_BUCK234_VOLT(vdd_int), 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK4, CALC_S5M8767_BUCK234_VOLT(vdd_g3d), 1);

	IIC0_EWrite(S5M8767_ADDR, 0x59, 0x4C); // BUCK8 1.4 -> 1.7V
	IIC0_EWrite(S5M8767_ADDR, 0x5D, 0xDC); // LDO2 1.2 -> 1.5V

	IIC0_EWrite(S5M8767_ADDR, 0x34, 0x78);
	IIC0_EWrite(S5M8767_ADDR, 0x3d, 0x58);
	IIC0_EWrite(S5M8767_ADDR, 0x46, 0x78);

	IIC0_EWrite(S5M8767_ADDR, 0x5A, 0x58);

	IIC0_EWrite(S5M8767_ADDR, 0x65, 0xCE); // LDO7 1.0 -> 1.2V
#else
	I2C_S5M8767_VolSetting(PMIC_BUCK1, CALC_S5M8767_BUCK156_VOLT(vdd_mif), 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK2, CALC_S5M8767_BUCK234_VOLT(vdd_arm), 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK3, CALC_S5M8767_BUCK234_VOLT(vdd_int), 1);
	I2C_S5M8767_VolSetting(PMIC_BUCK4, CALC_S5M8767_BUCK234_VOLT(vdd_g3d), 1);
	IIC0_EWrite(S5M8767_ADDR, 0x34, 0x78);
	IIC0_EWrite(S5M8767_ADDR, 0x3d, 0x58);
	IIC0_EWrite(S5M8767_ADDR, 0x46, 0x78);

	IIC0_EWrite(S5M8767_ADDR, 0x5A, 0x58);

	IIC0_EWrite(S5M8767_ADDR, 0x63, 0xE8); // LDO5
	IIC0_EWrite(S5M8767_ADDR, 0x64, 0xD0); // LDO6
	IIC0_EWrite(S5M8767_ADDR, 0x65, 0xD0); // LDO7

#endif
#endif /* CONFIG_CPU_EXYNOS5250_EVT1 */

}


void pmic_init(void)
{
	u8 read_data;

	IIC0_ESetport();

	/* read ID */
	IIC0_ERead(MAX8997_ADDR, 0, &read_data);

	if (read_data == 0x77)
		pmic8997_init();
	else if (read_data >= 0x0 && read_data <= 0x5)
		pmic8767_init();
	else
		pmic77686_init();
}
