/**************************************************************************************
* 
*	Project Name : S5PC210 Validation
*
*	Copyright 2006 by Samsung Electronics, Inc.
*	All rights reserved.
*
*	Project Description :
*		This software is only for validating functions of the S5PC210.
*		Anybody can use this software without our permission.
*  
*--------------------------------------------------------------------------------------
* 
*	File Name : i2c.c
*  
*	File Description : This file implements the API functon for UART.
*
*	Author : Jang TaeSu
*	Dept. : AP Development Team
*	Created Date : 2010/04/11
*	Version : 0.1 
* 
*	History
*	- Create 
*	- Modified by Jang TaeSu for S5PC210 (2010/04/11)
*  
**************************************************************************************/
#include <s5pc210.h>

#include "gpio.h"
#include "i2c.h"
#include "cmu.h"

/*
	Macro
*/
#define HW_REG32(base, offset)		(*(volatile unsigned int *)(base + (offset)))
#define HW_REG16(base, offset)		(*(volatile u16 *)(base + (offset)))
#define HW_REG8(base, offset)		(*(volatile u8 *)(base + (offset)))

#define TRUE	1
#define FALSE	0
/*
	Debug Message
*/
#define I2C_INIT			0
#define I2C_ERR				1

/*
	Global Variable
*/
static I2C_CONTEXT g_aI2c[] = 
{
	{ I2C0_BASE, 0, 0, 0, 0, 0 },
	{ I2C1_BASE, 0, 0, 0, 0, 0 },
	{ I2C2_BASE, 0, 0, 0, 0, 0 },
	{ I2C3_BASE, 0, 0, 0, 0, 0 },
	{ I2C4_BASE, 0, 0, 0, 0, 0 },
	{ I2C5_BASE, 0, 0, 0, 0, 0 },
	{ I2C6_BASE, 0, 0, 0, 0, 0 },
	{ I2C7_BASE, 0, 0, 0, 0, 0 },
	{ I2C8_BASE, 0, 0, 0, 0, 0 },
};

/*
	Public Function
*/
#define TAG_PUBLIC_FUNCTION

bool I2C_InitIp(I2C_CHANNEL eCh, unsigned int nOpClock, unsigned int nTimeOut)
{
	I2C_PRESCALER ePrescaler;
	unsigned int nPclk, nPrescaler;

	nPclk = SYSC_GetClkFreq(SYSC_ACLK_GPL);

	if (!I2C_CalculatePrescaler(nPclk, nOpClock, &ePrescaler, &nPrescaler))
	{
		g_aI2c[eCh].eError = I2C_INVALID_TX_CLOCK;
		return FALSE;
	}
	
	g_aI2c[eCh].nOpClock = nPclk/ePrescaler/(nPrescaler+1);
	g_aI2c[eCh].ePrescaler = ePrescaler;
	g_aI2c[eCh].nPrescaler = nPrescaler;
	g_aI2c[eCh].nTimeOut = nTimeOut;
	g_aI2c[eCh].eError = I2C_SUCCESS;

	return TRUE;
}

static bool I2C_SendForGeneral(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aAddr[], unsigned int nNumOfAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = TRUE;
	unsigned int i;

	if (g_aI2c[eCh].eError == I2C_INVALID_TX_CLOCK)
	{
		bResult = FALSE;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_START;
		goto I2C_Stop;
	}

	I2C_InitMaster(eCh, g_aI2c[eCh].ePrescaler, g_aI2c[eCh].nPrescaler);	// Init I2C

	//
	// I2C Phase - START
	//
	I2C_SetMode(eCh, MASTER_TX_MODE);		// Set Mode
	I2C_WriteAddress(eCh, ucSlvAddr);		// Write Slave Address
	I2C_GenerateSignal(eCh, START_CONDITION);	// Send START Signal

	udelay(10);
	if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Write Address
	//
	for (i = 0; i < nNumOfAddr; i++)
	{
		I2C_WriteData(eCh, aAddr[i]);
		I2C_ClearIntStatus(eCh);		
		if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
		{
			g_aI2c[eCh].eError = I2C_TIMEOUT_WRITE_ADDRESS;
			goto I2C_Stop;
		}
	}

	//
	// I2C Phase - Write Data
	//
	for (i = 0; i < nNumOfData; i++)
	{
		I2C_WriteData(eCh, aData[i]);
		I2C_ClearIntStatus(eCh);
		
		udelay(10);
		if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
		{
			g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
			goto I2C_Stop;
		}
	}

	g_aI2c[eCh].eError = I2C_SUCCESS;

I2C_Stop:

	//
	// I2C Phase - STOP
	//
	I2C_GenerateSignal(eCh, STOP_CONDITION);								// Send STOP Signal
	I2C_ClearIntStatus(eCh);

	I2C_SetMode(eCh, DISABLE_I2C);											// Deactivate I2C

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_STOP;
		bResult = FALSE;
	}

	I2C_PrintErrorCase(g_aI2c[eCh].eError);
	
	return bResult;
}

static bool I2C_RecvForGeneral(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aAddr[], unsigned int nNumOfAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = TRUE;
	unsigned int i;

	if (g_aI2c[eCh].eError == I2C_INVALID_TX_CLOCK)
	{
		bResult = FALSE;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_START;
		goto I2C_Stop;
	}

	I2C_InitMaster(eCh, g_aI2c[eCh].ePrescaler, g_aI2c[eCh].nPrescaler);	// Init I2C

	//
	// I2C Phase - START
	//
	I2C_SetMode(eCh, MASTER_TX_MODE);										// Set Mode
	I2C_WriteAddress(eCh, ucSlvAddr);										// Write Slave Address
	I2C_GenerateSignal(eCh, START_CONDITION);								// Send START Signal
	if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Write Address
	//	
	for (i = 0; i < nNumOfAddr; i++)
	{
		I2C_WriteData(eCh, aAddr[i]);
		I2C_ClearIntStatus(eCh);
		if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
		{
			g_aI2c[eCh].eError = I2C_TIMEOUT_WRITE_ADDRESS;
			goto I2C_Stop;
		}
	}

	//
	// I2C Phase - STOP
	//
	I2C_GenerateSignal(eCh, STOP_CONDITION);								// Send STOP Signal
	I2C_ClearIntStatus(eCh);

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_STOP;
		return FALSE;
	}
	
	//
	// I2C Phase - START
	//
	I2C_SetMode(eCh, MASTER_RX_MODE);										// Set Mode
	I2C_WriteAddress(eCh, ucSlvAddr);										// Write Slave Address
	I2C_GenerateSignal(eCh, START_CONDITION);								// Send START Signal
	if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
		goto I2C_Stop;
	}
	
	//
	// I2C Phase - Read Data
	//
	for (i = 0; i < nNumOfData; i++)
	{
		if (i < nNumOfData-1)
		{
			I2C_SetAckGeneration(eCh, TRUE);
			I2C_ClearIntStatus(eCh);
			if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
			{
				g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
				goto I2C_Stop;
			}

			aData[i] = I2C_ReadData(eCh);
		}
		else
		{
			I2C_SetAckGeneration(eCh, FALSE);
			I2C_ClearIntStatus(eCh);
			if (I2C_WaitForXferNoAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
			{
				g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
				goto I2C_Stop;
			}

			aData[i] = I2C_ReadData(eCh);
		}
	}

	g_aI2c[eCh].eError = I2C_SUCCESS;

I2C_Stop:

	//
	// I2C Phase - STOP
	//
	I2C_GenerateSignal(eCh, STOP_CONDITION);								// Send STOP Signal
	I2C_ClearIntStatus(eCh);

	I2C_SetMode(eCh, DISABLE_I2C);											// Deactivate I2C

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_STOP;
		bResult = FALSE;
	}

	I2C_PrintErrorCase(g_aI2c[eCh].eError);
	
	return bResult;
}

static bool I2C_SendForHdmiPhy(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = TRUE;
	unsigned int i;

	if (g_aI2c[eCh].eError == I2C_INVALID_TX_CLOCK)
	{
		bResult = FALSE;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_START;
		goto I2C_Stop;
	}

	I2C_InitMaster(eCh, g_aI2c[eCh].ePrescaler, g_aI2c[eCh].nPrescaler);	// Init I2C

	//
	// I2C Phase - START
	//
	I2C_SetMode(eCh, MASTER_TX_MODE);										// Set Mode
	I2C_WriteAddress(eCh, ucSlvAddr);										// Write Slave Address
	I2C_GenerateSignal(eCh, START_CONDITION);								// Send START Signal
	if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Write Data
	// 
	for (i = 0; i < nNumOfData; i++)
	{
		I2C_WriteData(eCh, aData[i]);
		I2C_ClearIntStatus(eCh);
		if (I2C_WaitForXferAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
		{
			g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
			goto I2C_Stop;
		}
	}

	g_aI2c[eCh].eError = I2C_SUCCESS;

I2C_Stop:

	//
	// I2C Phase - STOP
	//
	I2C_GenerateSignal(eCh, STOP_CONDITION);								// Send STOP Signal
	I2C_ClearIntStatus(eCh);

	I2C_SetMode(eCh, DISABLE_I2C);											// Deactivate I2C

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_STOP;
		bResult = FALSE;
	}

	I2C_PrintErrorCase(g_aI2c[eCh].eError);
	
	return bResult;
}

static bool I2C_RecvForHdmiPhy(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = TRUE;
	unsigned int i;

	if (g_aI2c[eCh].eError == I2C_INVALID_TX_CLOCK)
	{
		bResult = FALSE;
		goto I2C_Stop;
	}
	
	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_START;
		return FALSE;
	}
	
	I2C_InitMaster(eCh, g_aI2c[eCh].ePrescaler, g_aI2c[eCh].nPrescaler);	// Init I2C

	//
	// I2C Phase - START
	//
	I2C_SetMode(eCh, MASTER_RX_MODE);										// Set Mode
	I2C_WriteAddress(eCh, ucSlvAddr);										// Write Slave Address
	I2C_GenerateSignal(eCh, START_CONDITION);								// Send START Signal
	if (!I2C_WaitForXferNoAck(eCh, g_aI2c[eCh].nTimeOut))						// Workaround for HDMI PHY
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Read Data
	//
	for (i = 0; i < nNumOfData; i++)
	{
		if (i < nNumOfData-1)
		{
			I2C_SetAckGeneration(eCh, TRUE);
			I2C_ClearIntStatus(eCh);
			if (I2C_WaitForXferNoAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)		// Workaround for HDMI PHY
			{
				g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
				goto I2C_Stop;
			}

			aData[i] = I2C_ReadData(eCh);
		}
		else
		{
			I2C_SetAckGeneration(eCh, FALSE);
			I2C_ClearIntStatus(eCh);
			if (I2C_WaitForXferNoAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
			{
				g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
				goto I2C_Stop;
			}

			aData[i] = I2C_ReadData(eCh);
		}
	}

	g_aI2c[eCh].eError = I2C_SUCCESS;

I2C_Stop:

	//
	// I2C Phase - STOP
	//
	I2C_GenerateSignal(eCh, STOP_CONDITION);								// Send STOP Signal
	I2C_ClearIntStatus(eCh);

	I2C_SetMode(eCh, DISABLE_I2C);											// Deactivate I2C

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_STOP;
		return FALSE;
	}

	I2C_PrintErrorCase(g_aI2c[eCh].eError);
	
	return bResult;
}

static bool I2C_SendForHdmiDdc(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = TRUE;
	unsigned int i;

	if (g_aI2c[eCh].eError == I2C_INVALID_TX_CLOCK)
	{
		bResult = FALSE;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_START;
		goto I2C_Stop;
	}

	I2C_InitMaster(eCh, g_aI2c[eCh].ePrescaler, g_aI2c[eCh].nPrescaler);	// Init I2C

	//
	// I2C Phase - START
	//
	I2C_SetMode(eCh, MASTER_TX_MODE);										// Set Mode
	I2C_WriteAddress(eCh, ucSlvAddr);										// Write Slave Address
	I2C_GenerateSignal(eCh, START_CONDITION);								// Send START Signal
	if (I2C_WaitForXferNoAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
		goto I2C_Stop;
	}

	//
	// I2C Phase - Write Data
	// 
	for (i = 0; i < nNumOfData; i++)
	{
		I2C_WriteData(eCh, aData[i]);
		I2C_ClearIntStatus(eCh);
		if (I2C_WaitForXferNoAck(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
		{
			g_aI2c[eCh].eError = I2C_TIMEOUT_SLAVE_ADDRESS;
			goto I2C_Stop;
		}
	}

	g_aI2c[eCh].eError = I2C_SUCCESS;

I2C_Stop:

	//
	// I2C Phase - STOP
	//
	I2C_GenerateSignal(eCh, STOP_CONDITION);								// Send STOP Signal
	I2C_ClearIntStatus(eCh);

	I2C_SetMode(eCh, DISABLE_I2C);											// Deactivate I2C

	//
	// I2C Phase - Check BUS Status
	//
	if (I2C_WaitForBusReady(eCh, g_aI2c[eCh].nTimeOut) == FALSE)
	{
		g_aI2c[eCh].eError = I2C_TIMEOUT_BUS_READY_STOP;
		bResult = FALSE;
	}

	I2C_PrintErrorCase(g_aI2c[eCh].eError);
	
	return bResult;
}

bool I2C_Send(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = FALSE;

	switch (eCh)
	{
		case I2C8:
			bResult = I2C_SendForHdmiPhy(eCh, ucSlvAddr, aData, nNumOfData);
			break;
		default:
			bResult = I2C_SendForGeneral(eCh, ucSlvAddr, NULL, 0, aData, nNumOfData);
			break;
	}

	return bResult;
}

bool I2C_Recv(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = FALSE;
	
	switch (eCh)
	{
		case I2C8:
			bResult = I2C_RecvForHdmiPhy(eCh, ucSlvAddr, aData, nNumOfData);
			break;
		default:
			bResult = I2C_RecvForGeneral(eCh, ucSlvAddr, NULL, 0, aData, nNumOfData);
			break;
	}

	return bResult;
}

bool I2C_SendEx(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aAddr[], unsigned int nNumOfAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = FALSE;

	switch (eCh)
	{
		default:
			bResult = I2C_SendForGeneral(eCh, ucSlvAddr, aAddr, nNumOfAddr, aData, nNumOfData);
			break;
	}

	return bResult;
}

bool I2C_RecvEx(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aAddr[], unsigned int nNumOfAddr, u8 aData[], unsigned int nNumOfData)
{
	bool bResult = FALSE;

	switch (eCh)
	{
		default:
			bResult = I2C_RecvForGeneral(eCh, ucSlvAddr, aAddr, nNumOfAddr, aData, nNumOfData);
			break;
	}

	return bResult;
}

I2C_ERROR I2C_GetLastError(I2C_CHANNEL eCh)
{
	return g_aI2c[eCh].eError;
}

void I2C_PrintErrorCase(I2C_ERROR eError)
{
	switch (eError)
	{
		case I2C_INVALID_TX_CLOCK:
			printf("\n[I2C->ERR] Invalid TX Clock\n");
			break;

		case I2C_TIMEOUT_BUS_READY_START:
			printf("\n[I2C->ERR] Timeout BUS Start Status\n");
			break;
			
		case I2C_TIMEOUT_SLAVE_ADDRESS:
			printf("\n[I2C->ERR] Timeout Slave Address\n");
			break;

		case I2C_TIMEOUT_WRITE_ADDRESS:
			printf("\n[I2C->ERR] Timeout Write Address\n");
			break;

		case I2C_TIMEOUT_WRITE_DATA:
			printf("\n[I2C->ERR] Timeout Write Data\n");
			break;

		case I2C_TIMEOUT_READ_DATA:
			printf("\n[I2C->ERR] Timeout Read Data\n");
			break;

		case I2C_TIMEOUT_BUS_READY_STOP:
			printf("\n[I2C->ERR] BUS Stop Status\n");
			break;
	}
}

/*
	Private Function
*/
#define TAG_PRIVATE_FUNCTION

bool I2C_InitMaster(I2C_CHANNEL eCh, I2C_PRESCALER ePrescaler, unsigned int nPrescaler)
{
	I2C_SetGPIO(eCh, TRUE);
	
	I2C_SetClock(eCh, ePrescaler, nPrescaler);
	I2C_SetFilter(eCh, TRUE);
//	I2C_SetOutputDelay(eCh, 0x0);
	I2C_SetAckGeneration(eCh, FALSE);

	return TRUE;
}

bool I2C_InitSlave(I2C_CHANNEL eCh, unsigned int uSlaveAddr, I2C_PRESCALER ePrescaler, unsigned int nPrescaler)
{
	I2C_SetGPIO(eCh, TRUE);
	
	I2C_SetClock(eCh, ePrescaler, nPrescaler);
	I2C_SetSlaveAddress(eCh, uSlaveAddr);
	I2C_SetFilter(eCh, TRUE);
//	I2C_SetOutputDelay(eCh, 0x0);
	I2C_SetAckGeneration(eCh, TRUE);

	return TRUE;
}

bool I2C_CalculatePrescaler(unsigned int uPClk, unsigned int uOpClk, I2C_PRESCALER *pePrescaler, unsigned int *pnPrescaler)
{
	unsigned int aTable[32];
	unsigned int uCalcValue;
	unsigned int i;

	for (i = 0; i < 32; i++)
	{
		if (i < 16)
			aTable[i] = uPClk / PRESCALER_16 / (i + 1);
		else
			aTable[i] = uPClk / PRESCALER_512 / (i - 16 + 1);
	}

	for (i = 0; i < 31; i++)
	{
		uCalcValue = aTable[i];
		
		if (uCalcValue > 400000)
			continue;

		if (uCalcValue <= uOpClk)
		{
			if (i < 16)
			{
				*pePrescaler = PRESCALER_16;
				*pnPrescaler = i;
			}
			else
			{
				*pePrescaler = PRESCALER_512;
				*pnPrescaler = i - 16;
			}
			
			return TRUE;
		}			
	}

	printf("\n[I2C->ERR] Invalid TX Clock\n");
	*pePrescaler = 0;
	*pnPrescaler = 0;
	
	return FALSE;
}

bool I2C_WaitForBusReady(I2C_CHANNEL eCh, unsigned int nTimeOut)
{
	while (--nTimeOut)
	{
		if (nTimeOut == I2C_TIMEOUT_INFINITY)
			++nTimeOut;

		if (I2C_IsBusReady(eCh))
			return TRUE;
	}

	return FALSE;
}

bool I2C_WaitForMatchAddress(I2C_CHANNEL eCh, unsigned int nTimeOut)
{
	while (--nTimeOut)
	{
		if (nTimeOut == I2C_TIMEOUT_INFINITY)
			++nTimeOut;

		if (I2C_GetIntStatus(eCh))
		{
			if (I2C_IsMatchAddress(eCh))
				return TRUE;
		}
	}

	return FALSE;
}

bool I2C_WaitForXferAck(I2C_CHANNEL eCh, unsigned int nTimeOut)
{
	nTimeOut = 1000;
	while (--nTimeOut)
	{
		if (nTimeOut == I2C_TIMEOUT_INFINITY)
			++nTimeOut;

		if (I2C_GetIntStatus(eCh))
		{
			if (I2C_IsXferAck(eCh))
				return TRUE;
		}
	}

	return FALSE;
}

bool I2C_WaitForXferNoAck(I2C_CHANNEL eCh, unsigned int nTimeOut)
{
	while (--nTimeOut)
	{
		if (nTimeOut == I2C_TIMEOUT_INFINITY)
			++nTimeOut;

		if (I2C_GetIntStatus(eCh))
			return TRUE;
	}

	return FALSE;
}

void I2C_SetGPIO(I2C_CHANNEL eCh, bool bEnable)
{
	switch (eCh)
	{	
		case I2C0:
			if (bEnable)
			{
				GPIO_SetFunctionEach(eGPIO_D1, eGPIO_0, 2);			// GPIO set I2C0_SDA
				GPIO_SetFunctionEach(eGPIO_D1, eGPIO_1, 2);			// GPIO set I2C0_SCL
				GPIO_SetPullUpDownEach(eGPIO_D1, eGPIO_0, 0);		// GPIO set Pull-up/down Disable
				GPIO_SetPullUpDownEach(eGPIO_D1, eGPIO_1, 0);		// GPIO set Pull-up/down Disable
			}
			else
			{
				GPIO_SetFunctionEach(eGPIO_D1, eGPIO_0, 0);			// GPIO set reset value
				GPIO_SetFunctionEach(eGPIO_D1, eGPIO_1, 0);			// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_D1, eGPIO_0, 1);		// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_D1, eGPIO_1, 1);		// GPIO set reset value
			}
			break;

		case I2C1:
			if (bEnable)
			{
				GPIO_SetFunctionEach(eGPIO_D1, eGPIO_2, 2);			// GPIO set I2C1_SDA
				GPIO_SetFunctionEach(eGPIO_D1, eGPIO_3, 2);			// GPIO set I2C1_SCL
				GPIO_SetPullUpDownEach(eGPIO_D1, eGPIO_2, 0);		// GPIO set Pull-up/down Disable
				GPIO_SetPullUpDownEach(eGPIO_D1, eGPIO_3, 0);		// GPIO set Pull-up/down Disable
			}
			else
			{
				GPIO_SetFunctionEach(eGPIO_D1, eGPIO_2, 0);			// GPIO set reset value
				GPIO_SetFunctionEach(eGPIO_D1, eGPIO_3, 0);			// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_D1, eGPIO_2, 1);		// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_D1, eGPIO_3, 1);		// GPIO set reset value
			}
			break;
			
		case I2C2:
			if (bEnable)
			{
				GPIO_SetFunctionEach(eGPIO_A0, eGPIO_6, 3);			// GPIO set I2C2_SDA
				GPIO_SetFunctionEach(eGPIO_A0, eGPIO_7, 3);			// GPIO set I2C2_SCL
				GPIO_SetPullUpDownEach(eGPIO_A0, eGPIO_6, 0);		// GPIO set Pull-up/down Disable
				GPIO_SetPullUpDownEach(eGPIO_A0, eGPIO_7, 0);		// GPIO set Pull-up/down Disable
			}
			else
			{
				GPIO_SetFunctionEach(eGPIO_A0, eGPIO_6, 0);			// GPIO set reset value
				GPIO_SetFunctionEach(eGPIO_A0, eGPIO_7, 0);			// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_A0, eGPIO_6, 1);		// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_A0, eGPIO_7, 1);		// GPIO set reset value
			}
			break;

		case I2C3:
			if (bEnable)
			{
				GPIO_SetFunctionEach(eGPIO_A1, eGPIO_2, 3);			// GPIO set I2C3_SDA
				GPIO_SetFunctionEach(eGPIO_A1, eGPIO_3, 3);			// GPIO set I2C3_SCL
				GPIO_SetPullUpDownEach(eGPIO_A1, eGPIO_2, 0);		// GPIO set Pull-up/down Disable
				GPIO_SetPullUpDownEach(eGPIO_A1, eGPIO_3, 0);		// GPIO set Pull-up/down Disable
			}
			else
			{
				GPIO_SetFunctionEach(eGPIO_A1, eGPIO_2, 0);			// GPIO set reset value
				GPIO_SetFunctionEach(eGPIO_A1, eGPIO_3, 0);			// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_A1, eGPIO_2, 1);		// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_A1, eGPIO_3, 1);		// GPIO set reset value
			}
			break;

		case I2C4:
			if (bEnable)
			{
				GPIO_SetFunctionEach(eGPIO_B, eGPIO_2, 3);			// GPIO set I2C4_SDA
				GPIO_SetFunctionEach(eGPIO_B, eGPIO_3, 3);			// GPIO set I2C4_SCL
				GPIO_SetPullUpDownEach(eGPIO_B, eGPIO_2, 0);		// GPIO set Pull-up/down Disable
				GPIO_SetPullUpDownEach(eGPIO_B, eGPIO_3, 0);		// GPIO set Pull-up/down Disable
			}
			else
			{
				GPIO_SetFunctionEach(eGPIO_B, eGPIO_2, 0);			// GPIO set reset value
				GPIO_SetFunctionEach(eGPIO_B, eGPIO_3, 0);			// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_B, eGPIO_2, 1);		// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_B, eGPIO_3, 1);		// GPIO set reset value
			}
			break;

		case I2C5:
			if (bEnable)
			{
				GPIO_SetFunctionEach(eGPIO_B, eGPIO_6, 3);			// GPIO set I2C5_SDA
				GPIO_SetFunctionEach(eGPIO_B, eGPIO_7, 3);			// GPIO set I2C5_SCL
				GPIO_SetPullUpDownEach(eGPIO_B, eGPIO_6, 0);		// GPIO set Pull-up/down Disable
				GPIO_SetPullUpDownEach(eGPIO_B, eGPIO_7, 0);		// GPIO set Pull-up/down Disable
			}
			else
			{
				GPIO_SetFunctionEach(eGPIO_B, eGPIO_6, 0);			// GPIO set reset value
				GPIO_SetFunctionEach(eGPIO_B, eGPIO_7, 0);			// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_B, eGPIO_6, 1);		// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_B, eGPIO_7, 1);		// GPIO set reset value
			}
			break;

		case I2C6:
			if (bEnable)
			{
				GPIO_SetFunctionEach(eGPIO_C1, eGPIO_3, 4);			// GPIO set I2C6_SDA
				GPIO_SetFunctionEach(eGPIO_C1, eGPIO_4, 4);			// GPIO set I2C6_SCL
				GPIO_SetPullUpDownEach(eGPIO_C1, eGPIO_3, 0);		// GPIO set Pull-up/down Disable
				GPIO_SetPullUpDownEach(eGPIO_C1, eGPIO_4, 0);		// GPIO set Pull-up/down Disable
			}
			else
			{
				GPIO_SetFunctionEach(eGPIO_C1, eGPIO_3, 0);			// GPIO set reset value
				GPIO_SetFunctionEach(eGPIO_C1, eGPIO_4, 0);			// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_C1, eGPIO_3, 1);		// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_C1, eGPIO_4, 1);		// GPIO set reset value
			}
			break;

		case I2C7:
			if (bEnable)
			{
				GPIO_SetFunctionEach(eGPIO_D0, eGPIO_2, 3);			// GPIO set I2C7_SDA
				GPIO_SetFunctionEach(eGPIO_D0, eGPIO_3, 3);			// GPIO set I2C7_SCL
				GPIO_SetPullUpDownEach(eGPIO_D0, eGPIO_2, 0);		// GPIO set Pull-up/down Disable
				GPIO_SetPullUpDownEach(eGPIO_D0, eGPIO_3, 0);		// GPIO set Pull-up/down Disable
			}
			else
			{
				GPIO_SetFunctionEach(eGPIO_D0, eGPIO_2, 0);			// GPIO set reset value
				GPIO_SetFunctionEach(eGPIO_D0, eGPIO_3, 0);			// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_D0, eGPIO_2, 1);		// GPIO set reset value
				GPIO_SetPullUpDownEach(eGPIO_D0, eGPIO_3, 1);		// GPIO set reset value
			}
			break;

		case I2C8:
			break;
	}
}

void I2C_SetClock(I2C_CHANNEL eCh, I2C_PRESCALER eSource, unsigned int nPrescaler)
{
	if (eSource == PRESCALER_512)
		HW_REG32(g_aI2c[eCh].uBase, I2C_CON) |= (0x1 << 6);
	else		// PRESCALER_16
		HW_REG32(g_aI2c[eCh].uBase, I2C_CON) &= ~(0x1 << 6);

	HW_REG32(g_aI2c[eCh].uBase, I2C_CON) &= ~(0xF);
	HW_REG32(g_aI2c[eCh].uBase, I2C_CON) |= (nPrescaler & 0xF);
}

void I2C_SetAckGeneration(I2C_CHANNEL eCh, bool bEnable)
{
	if (bEnable)
		HW_REG32(g_aI2c[eCh].uBase, I2C_CON) |= (0x1 << 7);
	else
		HW_REG32(g_aI2c[eCh].uBase, I2C_CON) &= ~(0x1 << 7);
}

void I2C_SetSlaveAddress(I2C_CHANNEL eCh, u8 nSlaveAddress)
{
	HW_REG32(g_aI2c[eCh].uBase, I2C_ADD) &= ~(0xFF);
	HW_REG32(g_aI2c[eCh].uBase, I2C_ADD) |= nSlaveAddress;
}

void I2C_SetFilter(I2C_CHANNEL eCh, bool bEnable)
{
	if (bEnable)
		HW_REG32(g_aI2c[eCh].uBase, I2C_LC ) |= (0x1 << 2);
	else
		HW_REG32(g_aI2c[eCh].uBase, I2C_LC ) &= ~(0x1 << 2);
}

void I2C_SetOutputDelay(I2C_CHANNEL eCh, I2C_OUTPUT_DELAY eOutputDelay)
{
	HW_REG32(g_aI2c[eCh].uBase, I2C_LC ) &= ~(0x3);
	HW_REG32(g_aI2c[eCh].uBase, I2C_LC ) |= (eOutputDelay & 0x3);
}

void I2C_SetMode(I2C_CHANNEL eCh, I2C_MODE eMode)
{
	HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) &= ~(0x1 << 4);			// Disable I2C
	
	HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) &= ~(0x3 << 6);			// Clear Mode

	I2C_ClearIntStatus(eCh);
	I2C_DisableInt(eCh);								// Disable Interrupt
	
	switch (eMode)
	{
		case MASTER_TX_MODE:
			HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) |= (0x3 << 6);	// Set Mode
			break;

		case MASTER_RX_MODE:
			HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) |= (0x2 << 6);	// Set Mode
			break;

		case SLAVE_TX_MODE:
			HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) |= (0x1 << 6);	// Set Mode
			break;

		case SLAVE_RX_MODE:
			HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) |= (0x0 << 6);	// Set Mode
			break;

		default:
			return;
	}

	I2C_EnableInt(eCh);
	HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) |= (0x1 << 4);			// Enable I2C
}

void I2C_EnableInt(I2C_CHANNEL eCh)
{
	HW_REG32(g_aI2c[eCh].uBase, I2C_CON) |= (0x1 << 5);
}

void I2C_DisableInt(I2C_CHANNEL eCh)
{
	HW_REG32(g_aI2c[eCh].uBase, I2C_CON) &= ~(0x1 << 5);
}

bool I2C_GetIntStatus(I2C_CHANNEL eCh)
{
	if (HW_REG32(g_aI2c[eCh].uBase, I2C_CON) & (0x1 << 4))
		return TRUE;
	else
		return FALSE;
}

void I2C_ClearIntStatus(I2C_CHANNEL eCh)
{
	HW_REG32(g_aI2c[eCh].uBase, I2C_CON) &= ~(0x1 << 4);
}

void I2C_GenerateSignal(I2C_CHANNEL eCh, I2C_CONDITION eCondition)
{
	if (eCondition == START_CONDITION)
		HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) |= (0x1 << 5);
	else
		HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) &= ~(0x1 << 5);
}

bool I2C_GetBusStatus(I2C_CHANNEL eCh)
{
	return (HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) >> 5) & 0x1;
}

bool I2C_IsBusReady(I2C_CHANNEL eCh)
{
	if (HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) & (0x1 << 5))
		return FALSE;
	else
		return TRUE;
}

bool I2C_IsBusBusy(I2C_CHANNEL eCh)
{
	if (HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) & (0x1 << 5))
		return TRUE;
	else
		return FALSE;
}

bool I2C_IsMatchAddress(I2C_CHANNEL eCh)
{
	if (HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) & (0x1 << 2))
		return TRUE;
	else
		return FALSE;
}

bool I2C_IsXferAck(I2C_CHANNEL eCh)
{
	if (HW_REG32(g_aI2c[eCh].uBase, I2C_STAT) & (0x1 << 0))
		return FALSE;
	else
		return TRUE;
}

void I2C_WriteAddress(I2C_CHANNEL eCh, u8 nAddress)
{
	HW_REG8(g_aI2c[eCh].uBase, I2C_DS) = nAddress & 0xFE;
}

void I2C_WriteData(I2C_CHANNEL eCh, u8 nData)
{
	HW_REG8(g_aI2c[eCh].uBase, I2C_DS) = nData;
}

u8 I2C_ReadData(I2C_CHANNEL eCh)
{
	return HW_REG8(g_aI2c[eCh].uBase, I2C_DS);
}


