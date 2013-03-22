#ifndef __I2C_H__
#define __I2C_H__

typedef unsigned char	bool;

/* Register Map */
#define I2C_CON         0x00
#define I2C_STAT        0x04
#define I2C_ADD         0x08
#define I2C_DS          0x0C
#define I2C_LC          0x10

/* Parameter    */
#define I2C_TX_CLOCK_125KHZ     125000
#define I2C_TX_CLOCK_200KHZ     200000
#define I2C_TX_CLOCK_300KHZ     300000
#define I2C_TX_CLOCK_DEFAULT    I2C_TX_CLOCK_300KHZ

#define I2C_TIMEOUT_INFINITY    0xFFFFFFFF
#define I2C_TIMEOUT_DEFAULT     0xFFFFF

/* Enumulation  & Structure     */
typedef enum {
    I2C_SUCCESS,
    I2C_INVALID_TX_CLOCK,
    I2C_INVALID_ADDRESS,
    I2C_TIMEOUT_BUS_READY_START,
    I2C_TIMEOUT_SLAVE_ADDRESS,
    I2C_TIMEOUT_WRITE_ADDRESS,
    I2C_TIMEOUT_WRITE_DATA,
    I2C_TIMEOUT_READ_DATA,
    I2C_TIMEOUT_BUS_READY_STOP,
} I2C_ERROR;

typedef enum
{
	DISABLE_I2C,
	MASTER_TX_MODE,
	MASTER_RX_MODE,
	SLAVE_TX_MODE,
	SLAVE_RX_MODE,
} I2C_MODE;

typedef enum
{
	START_CONDITION,
	STOP_CONDITION,
} I2C_CONDITION;


typedef enum
{
	OD_0CLK,
	OD_5CLK,
	OD_10CLK,
	OD_15CLK,
} I2C_OUTPUT_DELAY;


typedef enum
{
	PRESCALER_16 = 16,
	PRESCALER_512 = 512,
} I2C_PRESCALER;

typedef struct
{
	int uBase;
	int nOpClock;
	I2C_PRESCALER ePrescaler;
	int nPrescaler;

	int nTimeOut;
	I2C_ERROR eError; 
} I2C_CONTEXT;


typedef enum {
    I2C0,
    I2C1,
    I2C2,
    I2C3,
    I2C4,
    I2C5,
    I2C6,
    I2C7,
    I2C8,
    I2C_CHANNEL_MAX,
} I2C_CHANNEL;



/* Public Functions     */
bool I2C_InitIp(I2C_CHANNEL eCh, unsigned int nOpClock, unsigned int nTimeOut);

bool I2C_Send(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aData[], unsigned int nNumOfData);
bool I2C_Recv(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aData[], unsigned int nNumOfData);

bool I2C_SendEx(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aAddr[], unsigned int nNumOfAddr, u8 aData[], unsigned int nNumOfData);
bool I2C_RecvEx(I2C_CHANNEL eCh, u8 ucSlvAddr, u8 aAddr[], unsigned int nNumOfAddr, u8 aData[], unsigned int nNumOfData);

I2C_ERROR I2C_GetLastError(I2C_CHANNEL eCh);
void I2C_PrintErrorCase(I2C_ERROR eError);

/*
	Private Function
*/
bool I2C_InitMaster(I2C_CHANNEL eCh, I2C_PRESCALER ePrescaler, unsigned int nPrescaler);
bool I2C_InitSlave(I2C_CHANNEL eCh, unsigned int uSlaveAddr, I2C_PRESCALER ePrescaler, unsigned int nPrescaler);

bool I2C_CalculatePrescaler(unsigned int uPClk, unsigned int uOpClk, I2C_PRESCALER *pePrescaler, unsigned int *pnPrescaler);

bool I2C_WaitForBusReady(I2C_CHANNEL eCh, unsigned int nTimeOut);
bool I2C_WaitForMatchAddress(I2C_CHANNEL eCh, unsigned int nTimeOut);
bool I2C_WaitForXferAck(I2C_CHANNEL eCh, unsigned int nTimeOut);
bool I2C_WaitForXferNoAck(I2C_CHANNEL eCh, unsigned int nTimeOut);

void I2C_SetGPIO(I2C_CHANNEL eCh, bool bEnable);
void I2C_SetClock(I2C_CHANNEL eCh, I2C_PRESCALER eSource, unsigned int nPrescaler);
void I2C_SetAckGeneration(I2C_CHANNEL eCh, bool bEnable);
void I2C_SetSlaveAddress(I2C_CHANNEL eCh, u8 nSlaveAddress);
void I2C_SetFilter(I2C_CHANNEL eCh, bool bEnable);
void I2C_SetOutputDelay(I2C_CHANNEL eCh, I2C_OUTPUT_DELAY eOutputDelay);
void I2C_SetMode(I2C_CHANNEL eCh, I2C_MODE eMode);

void I2C_EnableInt(I2C_CHANNEL eCh);
void I2C_DisableInt(I2C_CHANNEL eCh);

bool I2C_GetIntStatus(I2C_CHANNEL eCh);
void I2C_ClearIntStatus(I2C_CHANNEL eCh);

void I2C_GenerateSignal(I2C_CHANNEL eCh, I2C_CONDITION eCondition);
bool I2C_GetBusStatus(I2C_CHANNEL eCh);

bool I2C_IsBusReady(I2C_CHANNEL eCh);
bool I2C_IsBusBusy(I2C_CHANNEL eCh);
bool I2C_IsMatchAddress(I2C_CHANNEL eCh);
bool I2C_IsXferAck(I2C_CHANNEL eCh);
bool I2C_IsXferNoAck(I2C_CHANNEL eCh);

void I2C_WriteAddress(I2C_CHANNEL eCh, u8 nAddress);
void I2C_WriteData(I2C_CHANNEL eCh, u8 nData);
u8 I2C_ReadData(I2C_CHANNEL eCh);


#endif /* __I2C_H__ */

