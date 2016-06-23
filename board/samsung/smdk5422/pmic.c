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
#include "pmic.h"

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
	ack = GPIO_DAT;
	IIC0_ESCL_Hi;
	Delay();
	IIC0_ESCL_Hi;
	Delay();

	/* Function <- Output (SDA) */
	IIC0_ESDA_OUTP;

	ack = (ack >> GPIO_DAT_SHIFT) & 0x1;

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
	DIS_GPIO_PUD;

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
		reg = GPIO_DAT;
		IIC0_ESCL_Hi;
		IIC0_ESCL_Hi;
		Delay();
		IIC0_ESCL_Lo;
		IIC0_ESCL_Lo;
		Delay();

		reg = (reg >> GPIO_DAT_SHIFT) & 0x1;

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
	float vdd_int, vdd_g3d, vdd_mif, vdd_mem;

	vdd_arm = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_ARM);
	vdd_kfc = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_KFC);
	vdd_mif = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_MIF);
	vdd_int = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_INT);
	vdd_g3d = CONFIG_PM_CALC_VOLT(CONFIG_PM_VDD_G3D);
	vdd_mem = CONFIG_PM_CALC_VOLT(1.20);

	IIC0_ESetport();
	/* BUCK2 VDD_ARM */
	IIC0_EWrite(S2MPS11_ADDR, BUCK2_CTRL2, vdd_arm);
	/* BUCK6 VDD_KFC */
	IIC0_EWrite(S2MPS11_ADDR, BUCK6_CTRL2, vdd_kfc);
	/* BUCK1 VDD_MIF */
	IIC0_EWrite(S2MPS11_ADDR, BUCK1_CTRL2, vdd_mif);
	/* BUCK3 VDD_INT */
	IIC0_EWrite(S2MPS11_ADDR, BUCK3_CTRL2, vdd_int);
	/* BUCK4 VDD_G3D */
	IIC0_EWrite(S2MPS11_ADDR, BUCK4_CTRL2, vdd_g3d);
	/* BUCK5 VDD_MEM */
	IIC0_EWrite(S2MPS11_ADDR, BUCK5_CTRL2, vdd_mem);
	
#if defined(CONFIG_BOARD_HARDKERNEL)

	// VDD33_USB3_0,VDD33_USB3_1,VDD33_UHOST (LDO9) set to 3.3V
	IIC0_EWrite(S2MPS11_ADDR, 0x45, 0xF2);

	// ETH_3V3 (LDO15, LDO17) set to 3.3V
	IIC0_EWrite(S2MPS11_ADDR, 0x4B, 0xF2);
	IIC0_EWrite(S2MPS11_ADDR, 0x4D, 0xF2);

	// vdd_mmc02(LDO13), vdd_sd_2v85(LDO19) set to 3.3V
	IIC0_EWrite(S2MPS11_ADDR, 0x49, 0xF2);
	IIC0_EWrite(S2MPS11_ADDR, 0x4F, 0xF2);

	// VDDF_2V85(BUCK10), set to 2.85V
	IIC0_EWrite(S2MPS11_ADDR, 0x3C, 0xA8);

	/* CTRL1 Master Reset Disable & PWRHOLD is High(force) */
	IIC0_EWrite(0xcc, 0x0c, 0x10);  // enablbe
//	IIC0_EWrite(0xcc, 0x0c, 0x00);  // disable
	
    // POWER KEY Control
    GPX0CON &= 0xFFFF0FFF;    GPX0PUD = 0;

    // FAN CONTROL & LCD PWM
    GPB2CON &= 0xFFFF0FF0;  GPB2PUD = 0x00;         GPB2CON |= 0x1001;      GPB2DAT |= 0x09;

#if defined(CONFIG_LED_CONTROL)    
    // LED CONTROL
    GPB2CON |= 0x0110;      GPX2CON &= 0xFFFF0FFF;  GPX2CON |= 0x1000;      GPX2DAT &= 0xF7;
#endif
    
#endif	
}

void pmic_deinit(void)
{
	/* CTRL1 Master Reset Disable & PWRHOLD is Low(force) */
	IIC0_EWrite(0xcc, 0x0c, 0x00);  // disable
}
