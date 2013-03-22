/*
 * (C) Copyright 2009 Samsung Electronics Co. Ltd
 *
 * See file CREDITS for list of people who contributed to this
 * project.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 *
 *	File Name : gpio.h
 *  
 *	File Description : This file declares prototypes of GPIO API funcions.
 *
 *	Author : chansik.Jeon
 *	Dept. : AP Development Team
 *	Created Date : 2010/04/16
 *	Version : 0.1 
 * 
 *	History
 *	- Created(chigwan.Oh 2010/04/16)
 *
 */  

#ifndef __ASM_ARCH_GPIO_H
#define __ASM_ARCH_GPIO_H

#ifndef __ASSEMBLY__

#include <common.h>
#include <asm/arch/cpu.h>

typedef enum {
	TX, RX
} DIR;

#define		Low_Level		0x0
#define		High_Level		0x1
#define		Falling_Edge 	        0x2
#define		Rising_Edge		0x3
#define		Both_Edge		0x4

typedef enum GPIO_Id	// Address Offset                                                         
{                                                                            
									// GPIO Base Addr = 0x1100_0000      
	// GPIO_Right_Top_Block							
	eGPIO_J0 = 0x000,    		// offset : 0x0                         
	eGPIO_J1 = 0x020,    		                                     
	eGPIO_K0 = 0x040,    		                                     
	eGPIO_K1 = 0x060,    		                                     
	eGPIO_K2 = 0x080,    		                                     
	eGPIO_K3 = 0x0A0,    		                                     
	eGPIO_L0 = 0x0C0,    		                                     
	eGPIO_L1 = 0x0E0,    		                                     
	eGPIO_L2 = 0x100,    		                                     
	eGPIO_MP0_0 = 0x120,    	                                     
	eGPIO_MP0_1 = 0x140,    	                                     
	eGPIO_MP0_2 = 0x160,    	                                     
	eGPIO_MP0_3 = 0x180,    	                                     
	eGPIO_MP0_4 = 0x1A0,    	                                     
	eGPIO_MP0_5 = 0x1C0,    	                                     
	eGPIO_MP0_6 = 0x1E0,    	                                     
	eGPIO_X0 = 0xC00,    		                                     
	eGPIO_X1 = 0xC20,    		                                     
	eGPIO_X2 = 0xC40,    		                                     
	eGPIO_X3 = 0xC60,    		                                     
   	eETC6    = 0x208,    		                                     
	eETC8    = 0x228,    		                                     
	                                                                     
	// GPIO_Left_Bottom_Block	                                     
	eGPIO_A0 = 0x400000,    	// offset : 0x40_0000	             
	eGPIO_A1 = 0x400020,    	                                     
	eGPIO_B  = 0x400040,    	                                     
	eGPIO_C0 = 0x400060,    	                                     
	eGPIO_C1 = 0x400080,    	                                     
	eGPIO_D0 = 0x4000A0,    	                                     
	eGPIO_D1 = 0x4000C0,    	                                     
	eGPIO_E0 = 0x4000E0,    	                                     
	eGPIO_E1 = 0x400100,    	                                     
	eGPIO_E2 = 0x400120,    	                                     
	eGPIO_E3 = 0x400140,    	                                     
	eGPIO_E4 = 0x400160,    	                                     
	eGPIO_F0 = 0x400180,    	                                     
	eGPIO_F1 = 0x4001A0,    	                                     
	eGPIO_F2 = 0x4001C0,    	                                     
	eGPIO_F3 = 0x4001E0,    	                                     
	eETC0    = 0x400208,    	                                     
	eETC1    = 0x400228    	                                     
	                                                                     
}                                                                            
GPIO_eId;                                                                    


typedef enum GPIO_BitPos
{
	eGPIO_0	        = 0,
	eGPIO_1	        = 1,
	eGPIO_2	        = 2,
	eGPIO_3	        = 3,
	eGPIO_4	        = 4,
	eGPIO_5	        = 5,
	eGPIO_6	        = 6,
	eGPIO_7	        = 7,
	eGPIO_8	        = 8,
	eGPIO_9	        = 9,
	eGPIO_10	= 10,
	eGPIO_11	= 11,
	eGPIO_12	= 12,
	eGPIO_13	= 13,
	eGPIO_14	= 14,
	eGPIO_15	= 15
}GPIO_eBitPos;


// added by junon
typedef enum GPIO_Func
{
	eGPI		= 0,	// GPIO input 
	eGPO		= 1,	// GPIO output
	eGFunc_0	= 2,	// Function 0 select
	eGFunc_1	= 3,	// Function 1 select
	eGFunc_2	= 4,	// Function 2 select
	eGFunc_3	= 5,	// Function 3 select
	eGFunc_4	= 6,	// Function 4 select
	eGFunc_5	= 7,
	eGFunc_6	= 8,
	eGFunc_7	= 9,
	eGFunc_8	= 10,
	eGFunc_9	= 11,
	eGFunc_10	= 12,
	eGFunc_11	= 13,
	eGFunc_12	= 14,
	eGINT		= 15	// General external interrupt (no wake up)
} GPIO_eFunc;

typedef enum GPIO_Data
{
	eLow	= 0,	// pull-up/down disable
	eHigh	= 1	// pull-down enable
} GPIO_eData;


typedef enum GPIO_PUD
{
	// C200                                                                           
	eGPUDdis	= 0,	// pull-up/down disable
        eGPDen		= 1,	// pull-down enable
        eGPUen		= 3,	// pull-up enable
	eGPRes		= 2	// reserved
} GPIO_ePUD;




typedef enum FLT_TYPE
{
	eDisFLT	= 0x0,		// Digital Fiter Off (EINT Group 1~16, 21~29 )
	eEnFLT	= 0x1, 		// Digital Fiter On (EINT Group 1~16, 21~29 )
	eDLYFLT	= 0x2,		// EINT Group 40~43, 2'b10 => Filter On & Delay Filter
	eDIGFLT	= 0x3		// EINT Group 40~43, 2'b11 => Fiter On & Digital Filter
} FLT_eTYPE;

typedef enum PRI_TYPE
{
	eFixed	= 0x0
	//eRotate	=  0x1, 		// Spec Out
} PRI_eTYPE;

// use by Design Team : GPIO in/out L4SIM Test Code & Silicon Aging Ttest :  Write by Siyoung Kim : 2010.04.16
typedef enum GPIO_PadNum                                                         
{                                                                            
         //General  PADs							              // Group_Num		//Pad_Num        
         eGPIOA0PAD_Num = (0x00010008),		//0x0001*1000 		//0008
         eGPIOA1PAD_Num = (0x00020006),		//0x0002*1000 		//0006
         eGPIOBPAD_Num 	= (0x00030008),		//0x0003*1000		//0008
         eGPIOC0PAD_Num = (0x00040005),		//0x0004*1000		//0005
         eGPIOC1PAD_Num = (0x00050005),		//0x0005*1000		//0005
         eGPIOD0PAD_Num = (0x00060004),		//0x0006*1000		//0004
         eGPIOD1PAD_Num = (0x00070004),		//0x0007*1000		//0004
         eGPIOE0PAD_Num = (0x00080005),		//0x0008*1000		//0005
         eGPIOE1PAD_Num = (0x00090008),		//0x0009*1000		//0008
         eGPIOE2PAD_Num = (0x000A0006),		//0x000A*1000		//0006
         eGPIOE3PAD_Num = (0x000B0008),		//0x000B*1000		//0008
         eGPIOE4PAD_Num = (0x000C0008),		//0x000C*1000		//0008
         eGPIOF0PAD_Num = (0x000D0008),		//0x000D*1000		//0008
         eGPIOF1PAD_Num = (0x000E0008),		//0x000E*1000		//0008
         eGPIOF2PAD_Num = (0x000F0008),		//0x000F*1000		//0008
         eGPIOF3PAD_Num = (0x00100006),		//0x0010*1000		//0006
         eGPIOJ0PAD_Num = (0x00110008),		//0x0011*1000		//0008
         eGPIOJ1PAD_Num = (0x00120005),		//0x0012*1000		//0005
         eGPIOK0PAD_Num = (0x00130007),		//0x0013*1000		//0007
         eGPIOK1PAD_Num = (0x00140007),		//0x0014*1000		//0007
         eGPIOK2PAD_Num = (0x00150007),		//0x0015*1000		//0007
         eGPIOK3PAD_Num = (0x00160007),		//0x0016*1000		//0007
         eGPIOL0PAD_Num = (0x00170008),		//0x0017*1000		//0008
         eGPIOL1PAD_Num = (0x00180003),		//0x0018*1000		//0003
         eGPIOL2PAD_Num = (0x00190008),		//0x0019*1000		//0008
         eGPIOX0PAD_Num = (0x001A0008),		//0x001A*1000		//0008
         eGPIOX1PAD_Num = (0x001B0008),		//0x001B*1000		//0008
         eGPIOX2PAD_Num = (0x001C0008),		//0x001C*1000		//0008
         eGPIOX3PAD_Num = (0x001D0008),		//0x001D*1000		//0008
         eGPIOMP0PAD_Num        = (0x001E0006),		//0x001E*1000		//0006
         eGPIOMP1PAD_Num        = (0x001F0004),		//0x001F*1000		//0004
         eGPIOMP2PAD_Num 	= (0x00200006),		//0x0020*1000		//0006
         eGPIOMP3PAD_Num 	= (0x00210008),		//0x0021*1000		//0008
         eGPIOMP4PAD_Num 	= (0x00220008),		//0x0022*1000		//0008
         eGPIOMP5PAD_Num 	= (0x00230008),		//0x0023*1000		//0008
         eGPIOMP6PAD_Num 	= (0x00240008),		//0x0024*1000		//0008
                                                	    				     	      
         //Special  PADs                        	    				     	      
         //eGPIOETC0PAD_Num 	= (0x00250006),		//0x0025*1000		//0006
         //eGPIOETC1PAD_Num 	= (0x00260002),		//0x0026*1000		//0002
         //eGPIOETC6PAD_Num 	= (0x00270008),		//0x0027*1000		//0008
         //eGPIOETC8PAD_Num 	= (0x00280002),		//0x0028*1000		//0002

         //General  PADs	Numbers
         eGPIOGENERALPAD_Nums	= (245),

         //Special  PADs Numbers
         eGPI0SPECIALPAD_Nums	= (18),         

         //Total  PADs Numbers
         eGPIOTOTALPAD_Nums 	= (263) 
 
}                                                                            
GPIO_ePadNum;          


void GPIO_Init(void);
void GPIO_SetFunctionEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uFunction);
void GPIO_SetFunctionAll(GPIO_eId Id, int uValue0);
void GPIO_SetDataEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uValue);
void GPIO_SetDataAll(GPIO_eId Id, int uValue);
int GPIO_GetDataEach(GPIO_eId Id, GPIO_eBitPos eBitPos);
int GPIO_GetDataAll(GPIO_eId Id);
void GPIO_SetPullUpDownEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uValue);
void GPIO_SetPullUpDownAll(GPIO_eId Id, int uValue);
void ETC_SetPullUpDownEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uValue);
void ETC_SetPullUpDownAll(GPIO_eId Id, int uValue);
void GPIO_SetDSEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uValue);
void GPIO_SetDSAll(GPIO_eId Id, int uValue);
void GPIO_SetConRegPDNAll(GPIO_eId Id, int uValue);
void GPIO_SetPullUDPDNAll(GPIO_eId Id, int uValue);


// start normal source EINT GROUP Control Function================================
void GPIO_SetEint1(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT1ClrPend(int uEINT_No );
void GPIO_EINT1UnMask(int uEINT_No );
void GPIO_EINT1Mask(int uEINT_No );


void GPIO_SetEint2(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT2ClrPend(int uEINT_No );
void GPIO_EINT2UnMask(int uEINT_No );
void GPIO_EINT2Mask(int uEINT_No );


void GPIO_SetEint3(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT3ClrPend(int uEINT_No );
void GPIO_EINT3UnMask(int uEINT_No );
void GPIO_EINT3Mask(int uEINT_No );


void GPIO_SetEint4(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT4ClrPend(int uEINT_No );
void GPIO_EINT4UnMask(int uEINT_No );
void GPIO_EINT4Mask(int uEINT_No );


void GPIO_SetEint5(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT5ClrPend(int uEINT_No );
void GPIO_EINT5UnMask(int uEINT_No );
void GPIO_EINT5Mask(int uEINT_No );


void GPIO_SetEint6(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT6ClrPend(int uEINT_No );
void GPIO_EINT6UnMask(int uEINT_No );
void GPIO_EINT6Mask(int uEINT_No );


void GPIO_SetEint7(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT7ClrPend(int uEINT_No );
void GPIO_EINT7UnMask(int uEINT_No );
void GPIO_EINT7Mask(int uEINT_No );



void GPIO_SetEint8(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT8ClrPend(int uEINT_No );
void GPIO_EINT8UnMask(int uEINT_No );
void GPIO_EINT8Mask(int uEINT_No );


void GPIO_SetEint9(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT9ClrPend(int uEINT_No );
void GPIO_EINT9UnMask(int uEINT_No );
void GPIO_EINT9Mask(int uEINT_No );



void GPIO_SetEint10(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT10ClrPend(int uEINT_No );
void GPIO_EINT10UnMask(int uEINT_No );
void GPIO_EINT10Mask(int uEINT_No );


void GPIO_SetEint11(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT11ClrPend(int uEINT_No );
void GPIO_EINT11UnMask(int uEINT_No );
void GPIO_EINT11Mask(int uEINT_No );


void GPIO_SetEint12(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT12ClrPend(int uEINT_No );
void GPIO_EINT12UnMask(int uEINT_No );
void GPIO_EINT12Mask(int uEINT_No );


void GPIO_SetEint13(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT13ClrPend(int uEINT_No );
void GPIO_EINT13UnMask(int uEINT_No );
void GPIO_EINT13Mask(int uEINT_No );


void GPIO_SetEint14(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT14ClrPend(int uEINT_No );
void GPIO_EINT14UnMask(int uEINT_No );
void GPIO_EINT14Mask(int uEINT_No );


void GPIO_SetEint15(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT15ClrPend(int uEINT_No );
void GPIO_EINT15UnMask(int uEINT_No );
void GPIO_EINT15Mask(int uEINT_No );


void GPIO_SetEint16(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT16ClrPend(int uEINT_No );
void GPIO_EINT16UnMask(int uEINT_No );
void GPIO_EINT16Mask(int uEINT_No );


void GPIO_SetEint21(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT21ClrPend(int uEINT_No );
void GPIO_EINT21UnMask(int uEINT_No );
void GPIO_EINT21Mask(int uEINT_No );


void GPIO_SetEint22(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT22ClrPend(int uEINT_No );
void GPIO_EINT22UnMask(int uEINT_No );
void GPIO_EINT22Mask(int uEINT_No );


void GPIO_SetEint23(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT23ClrPend(int uEINT_No );
void GPIO_EINT23UnMask(int uEINT_No );
void GPIO_EINT23Mask(int uEINT_No );


void GPIO_SetEint24(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT24ClrPend(int uEINT_No );
void GPIO_EINT24UnMask(int uEINT_No );
void GPIO_EINT24Mask(int uEINT_No );



void GPIO_SetEint25(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT25ClrPend(int uEINT_No );
void GPIO_EINT25UnMask(int uEINT_No );
void GPIO_EINT25Mask(int uEINT_No );


void GPIO_SetEint26(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT26ClrPend(int uEINT_No );
void GPIO_EINT26UnMask(int uEINT_No );
void GPIO_EINT26Mask(int uEINT_No );



void GPIO_SetEint27(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT27ClrPend(int uEINT_No );
void GPIO_EINT27UnMask(int uEINT_No );
void GPIO_EINT27Mask(int uEINT_No );



void GPIO_SetEint28(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT28ClrPend(int uEINT_No );
void GPIO_EINT28UnMask(int uEINT_No );
void GPIO_EINT28Mask(int uEINT_No );


void GPIO_SetEint29(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT29ClrPend(int uEINT_No );
void GPIO_EINT29UnMask(int uEINT_No );
void GPIO_EINT29Mask(int uEINT_No );


//	Left Bottom Block = ( GPA0 Group ~ GPF3 Group )
void EINT_GRPPRI_XA(PRI_eTYPE uPriType );
int Get_EINTSVC_XA(void);
int Get_EINTSVCPEND_XA(void);
void EINT_GRPFIXPRI_XA(int uEINT_No );
void EINT_FIXPRI_XA(int uEINT_Grp_No, int uEINT_No  );

//	Right Top Block  =  ( GPJ0 Group ~ GPL2 Group )
void EINT_GRPPRI_XB(PRI_eTYPE uPriType );
int Get_EINTSVC_XB(void);
int Get_EINTSVCPEND_XB(void);
void EINT_GRPFIXPRI_XB(int uEINT_No );
void EINT_FIXPRI_XB(int uEINT_Grp_No, int uEINT_No  );

// end normal source EINT GROUP Control Function==================================


// start wakeup source EINT GROUP Control Function=================================
void GPIO_SetEint40(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT40ClrPend(int uEINT_No );
void GPIO_EINT40UnMask(int uEINT_No );
void GPIO_EINT40Mask(int uEINT_No );


void GPIO_SetEint41(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT41ClrPend(int uEINT_No );
void GPIO_EINT41UnMask(int uEINT_No );
void GPIO_EINT41Mask(int uEINT_No );


void GPIO_SetEint42(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT42ClrPend(int uEINT_No );
void GPIO_EINT42UnMask(int uEINT_No );
void GPIO_EINT42Mask(int uEINT_No );


void GPIO_SetEint43(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth);
void GPIO_EINT43ClrPend(int uEINT_No );
void GPIO_EINT43UnMask(int uEINT_No );
void GPIO_EINT43Mask(int uEINT_No );
// end wakeup source EINT GROUP Control Function


	// use by Design Team : GPIO in/out L4SIM Test Code & Silicon Aging Ttest :  Write by Siyoung Kim : 2010.04.16
int gioGetNumOfPads();
void gioGetPortIdx(int i, int *pGrpNum, int *pPortIdx);
void gioConfigPad(int uGrpNum, int uPortIdx, DIR eDir, enum GPIO_PUD ePull);
void gioSetPad(int uGrpNum, int uPortIdx, int u1or0);
int  gioGetPad(int uGrpNum, int uPortIdx);
	//==============================================================================================================================


struct s5p_gpio_bank {
	unsigned int	con;
	unsigned int	dat;
	unsigned int	pull;
	unsigned int	drv;
	unsigned int	pdn_con;
	unsigned int	pdn_pull;
	unsigned char	res1[8];
};

/* functions */
void gpio_cfg_pin(struct s5p_gpio_bank *bank, int gpio, int cfg);
void gpio_direction_output(struct s5p_gpio_bank *bank, int gpio, int en);
void gpio_direction_input(struct s5p_gpio_bank *bank, int gpio);
void gpio_set_value(struct s5p_gpio_bank *bank, int gpio, int en);
unsigned int gpio_get_value(struct s5p_gpio_bank *bank, int gpio);
void gpio_set_pull(struct s5p_gpio_bank *bank, int gpio, int mode);
void gpio_set_drv(struct s5p_gpio_bank *bank, int gpio, int mode);
void gpio_set_rate(struct s5p_gpio_bank *bank, int gpio, int mode);
#endif

/* Pin configurations */
#define GPIO_INPUT	0x0
#define GPIO_OUTPUT	0x1
#define GPIO_IRQ	0xf
#define GPIO_FUNC(x)	(x)

/* Pull mode */
#define GPIO_PULL_NONE	0x0
#define GPIO_PULL_DOWN	0x1
#define GPIO_PULL_UP	0x2

/* Drive Strength level */
#define GPIO_DRV_1X	0x0
#define GPIO_DRV_2X	0x1
#define GPIO_DRV_3X	0x2
#define GPIO_DRV_4X	0x3
#define GPIO_DRV_FAST	0x0
#define GPIO_DRV_SLOW	0x1

#endif /* __ASM_ARCH_GPIO_H */

