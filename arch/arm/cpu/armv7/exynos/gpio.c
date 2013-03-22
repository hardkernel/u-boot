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
 *	File Name : gpio.c
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


#include <asm/arch/gpio.h>

#define GPIO_REG	( ( volatile oGPIO_REGS * ) (GPIO_pBase) )			

//=============================================
//	Left Bottom Block = ( GPA0 Group ~ GPF3 Group, ETC0, ETC1 )
//	Right Top Block  =  ( GPJ0 Group ~ MP0 Group, ETC6, ECT8 )
//=============================================
typedef struct tag_GPIO_REGS
{

	// Start Right Top Register===================================
	int rGPIOJ0CON;			//0x11000000
	int rGPIOJ0DAT;
	int rGPIOJ0PUD;
	int rGPIOJ0DRV_SR;
	int rGPIOJ0CONPDN;
	int rGPIOJ0PUDPDN;
	int reservedJ0[2];		// 0x11000018 ~ 0x1100001C

	int rGPIOJ1CON;			//0x11000020
	int rGPIOJ1DAT;
	int rGPIOJ1PUD;
	int rGPIOJ1DRV_SR;
	int rGPIOJ1CONPDN;
	int rGPIOJ1PUDPDN;
	int reservedJ1[2];

	int rGPIOK0CON;			//0x11000040  
	int rGPIOK0DAT;                               
	int rGPIOK0PUD;                               
	int rGPIOK0DRV_SR;                            
	int rGPIOK0CONPDN;                            
	int rGPIOK0PUDPDN;                            
	int reservedK0[2];                            

	int rGPIOK1CON;			//0x11000060    
	int rGPIOK1DAT;                                 
	int rGPIOK1PUD;                                 
	int rGPIOK1DRV_SR;                              
	int rGPIOK1CONPDN;                              
	int rGPIOK1PUDPDN;                              
	int reservedK1[2];                              

	int rGPIOK2CON;			//0x11000080   
	int rGPIOK2DAT;                                
	int rGPIOK2PUD;                                
	int rGPIOK2DRV_SR;                             
	int rGPIOK2CONPDN;                             
	int rGPIOK2PUDPDN;                             
	int reservedK2[2];                             

	int rGPIOK3CON;			//0x110000A0 
	int rGPIOK3DAT;                              
	int rGPIOK3PUD;                              
	int rGPIOK3DRV_SR;                           
	int rGPIOK3CONPDN;                           
	int rGPIOK3PUDPDN;                           
	int reservedK3[2];                           

	int rGPIOL0CON;			//0x110000C0  
	int rGPIOL0DAT;                               
	int rGPIOL0PUD;                               
	int rGPIOL0DRV_SR;                            
	int rGPIOL0CONPDN;                            
	int rGPIOL0PUDPDN;                            
	int reservedL0[2];                            

	int rGPIOL1CON;			//0x110000E0  
	int rGPIOL1DAT;                               
	int rGPIOL1PUD;                               
	int rGPIOL1DRV_SR;                            
	int rGPIOL1CONPDN;                            
	int rGPIOL1PUDPDN;                            
	int reservedL1[2];                            

	int rGPIOL2CON;			//0x11000100  
	int rGPIOL2DAT;                               
	int rGPIOL2PUD;                               
	int rGPIOL2DRV_SR;                            
	int rGPIOL2CONPDN;                            
	int rGPIOL2PUDPDN;                            
	int reservedL2[2];                            

    	int rGPIOMP0CON;		//0x11000120
	int rGPIOMP0DAT;
	int rGPIOMP0PUD;
	int rGPIOMP0DRV_SR;
	int rGPIOMP0CONPDN;
	int rGPIOMP0PUDPDN;
	int reservedMP0[2];                          
		
    	int rGPIOMP1CON;		//0x11000140
	int rGPIOMP1DAT;
	int rGPIOMP1PUD;
	int rGPIOMP1DRV_SR;
	int rGPIOMP1CONPDN;
	int rGPIOMP1PUDPDN;
	int reservedMP1[2];

	int rGPIOMP2CON;		//0x11000160
	int rGPIOMP2DAT;
	int rGPIOMP2PUD;
	int rGPIOMP2DRV_SR;
	int rGPIOMP2CONPDN;
	int rGPIOMP2PUDPDN;
	int reservedMP2[2];

	int rGPIOMP3CON;		//0x11000180               
	int rGPIOMP3DAT;                                           
	int rGPIOMP3PUD;                                           
	int rGPIOMP3DRVSR;                                         
	int rGPIOMP3CONPDN;                                        
	int rGPIOMP3PUDPDN;                                        
	int reservedMP3[2];                                        
                                                                   
	int rGPIOMP4CON;		//0x110001A0               
	int rGPIOMP4DAT;                                           
	int rGPIOMP4PUD;                                           
	int rGPIOMP4DRV_SR;                                        
	int rGPIOMP4CONPDN;                                        
	int rGPIOMP4PUDPDN;                                        
	int reservedMP4[2];                                        
                                                                   
	int rGPIOMP5CON;		//0x110001C0               
	int rGPIOMP5DAT;                                           
	int rGPIOMP5PUD;                                           
	int rGPIOMP5DRV_SR;                                        
	int rGPIOMP5CONPDN;                                        
	int rGPIOMP5PUDPDN;                                        
	int reservedMP5[2];                                        
                                                                   
	int rGPIOMP6CON;		//0x110001E0               
	int rGPIOMP6DAT;                                           
	int rGPIOMP6PUD;                                           
	int rGPIOMP6DRV_SR;                                        
	int rGPIOMP6CONPDN;                                        
	int rGPIOMP6PUDPDN;                                        
	int reservedMP6[2];                                        


	int reservedETC6_1[2];
	int rGPIOETC6PUD;		//0x11000208
	int rGPIOETC6DRV_SR;
	int reservedETC6_2[4];

	int reservedETC8_1[2];
	int rGPIOETC8PUD;		//0x11000228
	int rGPIOETC8DRV_SR;
	int reservedETC8_2[4];

	int reserved1[304];		// 0x1100_0240 ~ 0x1100_06FC

	int rEINT21CON;		// 0x1100_0700                            
	int rEINT22CON;                                                   
	int rEINT23CON;                                                   
	int rEINT24CON;                                                   
	int rEINT25CON;                                                   
	int rEINT26CON;                                                   
	int rEINT27CON;                                                   
	int rEINT28CON;                                                   
	int rEINT29CON;                                                   
                                                                          
	int reservedEINTCON_1[55];                                        
                                                                          
	int rEINT21FLTCON0;	//0x1100_0800                             
	int rEINT21FLTCON1;                                               
	int rEINT22FLTCON0;                                               
	int rEINT22FLTCON1;                                               
	int rEINT23FLTCON0;                                               
	int rEINT23FLTCON1;                                               
	int rEINT24FLTCON0;                                               
	int rEINT24FLTCON1;                                               
	int rEINT25FLTCON0;                                               
	int rEINT25FLTCON1;                                               
	int rEINT26FLTCON0;                                               
	int rEINT26FLTCON1;                                               
	int rEINT27FLTCON0;                                               
	int rEINT27FLTCON1;                                               
	int rEINT28FLTCON0;                                               
	int rEINT28FLTCON1;                                               
	int rEINT29FLTCON0;                                               
	int rEINT29FLTCON1;                                               
                                                                          
	int reserveEINTFLTCON[46];                                        
                                                                          
	int rEINT21MASK;		//0x1100_0900                     
	int rEINT22MASK;                                                  
	int rEINT23MASK;                                                  
	int rEINT24MASK;                                                  
	int rEINT25MASK;                                                  
	int rEINT26MASK;                                                  
	int rEINT27MASK;                                                  
	int rEINT28MASK;                                                  
	int rEINT29MASK;                                                  
                                                                          
	int reservedEINTMASK_1[55];                                         
                                                                          
	int rEINT21PEND;	   	//0x1100_0A00                     
	int rEINT22PEND;                                                  
	int rEINT23PEND;                                                  
	int rEINT24PEND;                                                  
	int rEINT25PEND;                                                  
	int rEINT26PEND;                                                  
	int rEINT27PEND;                                                  
	int rEINT28PEND;                                                  
	int rEINT29PEND;                                                         
	int reservedEINTPEND[55];                                         
                                                                          
	int rEINTGRPPRIXB;		//0x1100_0B00                     
	int rEINTPRIORITYXB;                                                
	int rEINTSERVICEXB;                                                 
	int rEINTSERVICEPENDXB;                                            
	int rEINTGRPFIXPRIXB;  
	
	int rEINT21FIXPRI;                                                
	int rEINT22FIXPRI;                                                
	int rEINT23FIXPRI;                                                
	int rEINT24FIXPRI;                                                
	int rEINT25FIXPRI;                                                
	int rEINT26FIXPRI;                                                
	int rEINT27FIXPRI;                                                
	int rEINT28FIXPRI;                                                
	int rEINT29FIXPRI;                                                

	int reservedEINTFIXPRI[50];

	int rGPIOX0CON;	   		//0x1100_0C00      
	int rGPIOX0DAT;   
	int rGPIOX0PUD;   
	int rGPIOX0DRV_SR;
	int reservedGPIOX0[4];
	
	int rGPIOX1CON;	   		//0x1100_0C20   
	int rGPIOX1DAT;   
	int rGPIOX1PUD;   
	int rGPIOX1DRV_SR;
	int reservedGPIOX1[4];	

	int rGPIOX2CON;	   		//0x1100_0C40   
	int rGPIOX2DAT;   
	int rGPIOX2PUD;   
	int rGPIOX2DRV_SR;
	int reservedGPIOX2[4];	

	int rGPIOX3CON;	   		//0x1100_0C60   
	int rGPIOX3DAT;   
	int rGPIOX3PUD;   
	int rGPIOX3DRV_SR;
	int reservedGPIOX3_1[4];

	int reservedGPIOX3_2[96];
      
	int rEINT40CON;	   	//0x1100_0E00                 
	int rEINT41CON;                                       
	int rEINT42CON;                                       
	int rEINT43CON;                                       
	                                                      
	int reservedEINTCON_2[28];                              
	                                                      
	int rEINT40FLTCON0;	//0x1100_0E80                 
	int rEINT40FLTCON1;                                   
	int rEINT41FLTCON0;                                   
	int rEINT41FLTCON1;                                   
	int rEINT42FLTCON0;                                   
	int rEINT42FLTCON1;                                   
	int rEINT43FLTCON0;                                   
	int rEINT43FLTCON1;                                   
                                                              
	int reservedEINTFLTCON[24];                           
	                                                      
	int rEINT40MASK;		//0x1100_0F00         
	int rEINT41MASK;                                      
	int rEINT42MASK;                                      
	int rEINT43MASK;                                      
                                                              
	int reservedEINTMASK_2[12];                             
	                                                      
	int rEINT40PEND;		//0x1100_0F40         
	int rEINT41PEND;                                      
	int rEINT42PEND;                                      
	int rEINT43PEND;                                      

	int reservedRT[1047596];	// 0x1100_F50 ~ 0x113F_FFFC	


	// Start Left Bottom Register===========================================
	int rGPIOA0CON;			//0x11400000
	int rGPIOA0DAT;
	int rGPIOA0PUD;
	int rGPIOA0DRV_SR;
	int rGPIOA0CONPDN;
	int rGPIOA0PUDPDN;
	int reservedA0[2];		// 0x11400018 ~ 0x1140001C

	int rGPIOA1CON;			//0x11400020
	int rGPIOA1DAT;
	int rGPIOA1PUD;
	int rGPIOA1DRV_SR;
	int rGPIOA1CONPDN;
	int rGPIOA1PUDPDN;
	int reservedA1[2];
	
	int rGPIOBCON;			//0x11400040
	int rGPIOBDAT;
	int rGPIOBPUD;
	int rGPIOBDRV_SR;
	int rGPIOBCONPDN;
	int rGPIOBPUDPDN;	
	int reservedB[2];

	int rGPIOC0CON;			//0x11400060
	int rGPIOC0DAT;
	int rGPIOC0PUD;
	int rGPIOC0DRV_SR;
	int rGPIOC0CONPDN;
	int rGPIOC0PUDPDN;
	int reservedC0[2];

	int rGPIOC1CON;			//0x11400080
	int rGPIOC1DAT;
	int rGPIOC1PUD;
	int rGPIOC1DRV_SR;
	int rGPIOC1CONPDN;
	int rGPIOC1PUDPDN;
	int reservedC1[2];

	int rGPIOD0CON;			//0x114000A0
	int rGPIOD0DAT;
	int rGPIOD0PUD;
	int rGPIOD0DRV_SR;
	int rGPIOD0CONPDN;
	int rGPIOD0PUDPDN;
	int reservedD0[2];

	int rGPIOD1CON;			//0x114000C0
	int rGPIOD1DAT;
	int rGPIOD1PUD;
	int rGPIOD1DRV_SR;
	int rGPIOD1CONPDN;
	int rGPIOD1PUDPDN;
	int reservedD1[2];

	int rGPIOE0CON;			//0x114000E0
	int rGPIOE0DAT;
	int rGPIOE0PUD;
	int rGPIOE0DRV_SR;
	int rGPIOE0CONPDN;
	int rGPIOE0PUDPDN;
	int reservedE0[2];

	int rGPIOE1CON;			//0x11400100
	int rGPIOE1DAT;
	int rGPIOE1PUD;
	int rGPIOE1DRV_SR;
	int rGPIOE1CONPDN;
	int rGPIOE1PUDPDN;
	int reservedE1[2];

	int rGPIOE2CON;			//0x11400120
	int rGPIOE2DAT;
	int rGPIOE2PUD;
	int rGPIOE2DRV_SR;
	int rGPIOE2CONPDN;
	int rGPIOE2PUDPDN;
	int reservedE2[2];

	int rGPIOE3CON;			//0x11400140
	int rGPIOE3DAT;
	int rGPIOE3PUD;
	int rGPIOE3DRV_SR;
	int rGPIOE3CONPDN;
	int rGPIOE3PUDPDN;
	int reservedE3[2];

	int rGPIOE4CON;			//0x11400160
	int rGPIOE4DAT;
	int rGPIOE4PUD;
	int rGPIOE4DRV_SR;
	int rGPIOE4CONPDN;
	int rGPIOE4PUDPDN;
	int reservedE4[2];

	int rGPIOF0CON;			//0x11400180
	int rGPIOF0DAT;
	int rGPIOF0PUD;
	int rGPIOF0DRV_SR;
	int rGPIOF0CONPDN;
	int rGPIOF0PUDPDN;
	int reservedF0[2];

	int rGPIOF1CON;			//0x114001A0
	int rGPIOF1DAT;
	int rGPIOF1PUD;
	int rGPIOF1DRV_SR;
	int rGPIOF1CONPDN;
	int rGPIOF1PUDPDN;
	int reservedF1[2];

	int rGPIOF2CON;			//0x114001C0
	int rGPIOF2DAT;
	int rGPIOF2PUD;
	int rGPIOF2DRV_SR;
	int rGPIOF2CONPDN;
	int rGPIOF2PUDPDN;
	int reservedF2[2];

	int rGPIOF3CON;			//0x114001E0
	int rGPIOF3DAT;
	int rGPIOF3PUD;
	int rGPIOF3DRV_SR;
	int rGPIOF3CONPDN;
	int rGPIOF3PUDPDN;
	int reservedF3[2];

	int reservedETC0_1[2];
	int rGPIOETC0PUD;		//0x11400208
	int rGPIOETC0DRV_SR;
	int reservedETC0_2[4];

	int reservedETC1_1[2];
	int rGPIOETC1PUD;		//0x11400228
	int rGPIOETC1DRV_SR;
	int reservedETC1_2[4];

	int reservedETC[304];	//0x11400240 ~ 0x114006FC

	int rEINT1CON;		//0x11400700   	
	int rEINT2CON;                          
	int rEINT3CON;                          
	int rEINT4CON;                          
	int rEINT5CON;                          
	int rEINT6CON;                          
	int rEINT7CON;                          
	int rEINT8CON;                          
	int rEINT9CON;                          
	int rEINT10CON;                         
	int rEINT11CON;                         
	int rEINT12CON;                         
	int rEINT13CON;                         
	int rEINT14CON;                         
	int rEINT15CON;                         
	int rEINT16CON;                         


	int reservedEINTCON_3[48];//0x11400740 ~ 0x114007FC

	int rEINT1FLTCON0;	//0x11400800       
	int rEINT1FLTCON1;                   	   
	int rEINT2FLTCON0;                   	   
	int rEINT2FLTCON1;                         
	int rEINT3FLTCON0;                         
	int rEINT3FLTCON1;                         
	int rEINT4FLTCON0;                         
	int rEINT4FLTCON1;                         
	int rEINT5FLTCON0;                         
	int rEINT5FLTCON1;                         
	int rEINT6FLTCON0;                         
	int rEINT6FLTCON1;                         
	int rEINT7FLTCON0;                         
	int rEINT7FLTCON1;                         
	int rEINT8FLTCON0;                         
	int rEINT8FLTCON1;                         
	int rEINT9FLTCON0;                         
	int rEINT9FLTCON1;                         
	int rEINT10FLTCON0;                        
	int rEINT10FLTCON1;                        
	int rEINT11FLTCON0;                        
	int rEINT11FLTCON1;                        
	int rEINT12FLTCON0;                        
	int rEINT12FLTCON1;                        
	int rEINT13FLTCON0;                        
	int rEINT13FLTCON1;                        
	int rEINT14FLTCON0;                        
	int rEINT14FLTCON1;                        
	int rEINT15FLTCON0;                        
	int rEINT15FLTCON1;                        
	int rEINT16FLTCON0;                        
	int rEINT16FLTCON1;                        


	int reservedFLTCON[32];	//0x11400880 ~ 0x114008FC
	
	int rEINT1MASK;		//0x11400900           
	int rEINT2MASK;                                
	int rEINT3MASK;                                
	int rEINT4MASK;                                
	int rEINT5MASK;                                
	int rEINT6MASK;                                
	int rEINT7MASK;                                
	int rEINT8MASK;                                
	int rEINT9MASK;                                
	int rEINT10MASK;                               
	int rEINT11MASK;                               
	int rEINT12MASK;                               
	int rEINT13MASK;                               
	int rEINT14MASK;                               
	int rEINT15MASK;                               
	int rEINT16MASK;                               

	int reservedMASK[48];	//0x11400940 ~ 0x114009FC
	             
	int rEINT1PEND;		//0x11400A00  
	int rEINT2PEND;                       
	int rEINT3PEND;                       
	int rEINT4PEND;                       
	int rEINT5PEND;                       
	int rEINT6PEND;                       
	int rEINT7PEND;                       
	int rEINT8PEND;                       
	int rEINT9PEND;                       
	int rEINT10PEND;                      
	int rEINT11PEND;                      
	int rEINT12PEND;                      
	int rEINT13PEND;                      
	int rEINT14PEND;                      
	int rEINT15PEND;                      
	int rEINT16PEND;                      

	int reservedPEND[48];	//0x11400A40 ~ 0x11400AFC
	
	int rEINTGRPPRIXA;		// 0x11000B00         
	int rEINTPRIORITYXA;                                    
	int rEINTSERVICEXA;                                     
	int rEINTSERVICEPENDXA;                                
	int rEINTGRPFIXPRIXA;                                   
	                                                      
	int rEINT1FIXPRI;	// 0x11000B14                 
	int rEINT2FIXPRI;                                     
	int rEINT3FIXPRI;                                     
	int rEINT4FIXPRI;                                     
	int rEINT5FIXPRI;                                     
	int rEINT6FIXPRI;                                     
	int rEINT7FIXPRI;                                     
	int rEINT8FIXPRI;                                     
	int rEINT9FIXPRI;                                     
	int rEINT10FIXPRI;                                    
	int rEINT11FIXPRI;                                    
	int rEINT12FIXPRI;                                    
	int rEINT13FIXPRI;                                    
	int rEINT14FIXPRI;                                    
	int rEINT15FIXPRI;                                    
	int rEINT16FIXPRI;                                    
    
               
	int reservedFIXPRI[267];//0x11400B54 ~ 0x11400F7C                    


} 
oGPIO_REGS; 


static volatile void * GPIO_pBase;

volatile int  g_IntCnt;


//////////
// Function Name : GPIO_Init
// Function Desctiption : This function initializes gpio sfr base address
// Input : NONE
// Output : NONE
// Version :
//
// Version : v0.1
void GPIO_Init(void)
{
	GPIO_pBase = (void *)GPIO_BASE;
}


//////////
// Function Name : GPIO_SetFunctionEach
// Function Desctiption : This function set each GPIO function
// Input : 	Id : GPIO port
//			eBitPos : GPIO bit
//			uFunction : Select the function
// Output : NONE
//
// Version : v0.0

void GPIO_SetFunctionEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uFunction)
{
	volatile int *pGPIOx_Reg0;
	volatile int *pGPIO_Base_Addr;
	int uMuxBit,  uOffset;
	int uConValue;

	uMuxBit = 4; // 4bit
	uOffset = Id&0xFFFFFF;  

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);

	pGPIOx_Reg0 = pGPIO_Base_Addr + uOffset/4;
	uConValue = *pGPIOx_Reg0;
	uConValue = (uConValue & ~(0xF<<(uMuxBit*eBitPos))) | (uFunction<<(uMuxBit*eBitPos));
	*pGPIOx_Reg0 = uConValue;
	
}



//////////
// Function Name : GPIO_SetFunctionAll
// Function Desctiption : This function set all GPIO function selection
// Input : 	Id : GPIO port
//			uValue0 : Write value(control register 0)
// Output : NONE
//
// Version : v0.0
void GPIO_SetFunctionAll(GPIO_eId Id, int uValue0)
{
	volatile int *pGPIOx_Reg0;
	volatile int *pGPIO_Base_Addr;
	int uConRegNum, uOffset;


	uOffset = Id&0xFFFFFF; 

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_Reg0 = pGPIO_Base_Addr + uOffset/4;
	*pGPIOx_Reg0 = uValue0;

}



//////////
// Function Name : GPIO_SetDataEach
// Function Desctiption : This function set each GPIO data bit
// Input : 	Id : GPIO port
//			eBitPos : GPIO bit
//			uValue : value
// Output : NONE
//
// Version : v0.0
void GPIO_SetDataEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uValue)
{
	volatile int *pGPIOx_DataReg;
	volatile int *pGPIO_Base_Addr;
	int  uOffset, uConRegNum;
	int uDataValue;

	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;
	

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_DataReg = pGPIO_Base_Addr + (uOffset/4) +uConRegNum;
	uDataValue = *pGPIOx_DataReg;
	uDataValue = (uDataValue & ~(0x1<<eBitPos)) | (uValue<<eBitPos);
	*pGPIOx_DataReg = uDataValue;
}



//////////
// Function Name : GPIO_SetDataAll
// Function Desctiption : This function set all GPIO data bit
// Input : 	Id : GPIO port
//			uValue : value
// Output : NONE
//
// Version : v0.0
void GPIO_SetDataAll(GPIO_eId Id, int uValue)
{
	volatile int *pGPIOx_DataReg;
	volatile int *pGPIO_Base_Addr;
	int  uOffset, uConRegNum;

	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_DataReg = pGPIO_Base_Addr + (uOffset/4) +uConRegNum;
	*pGPIOx_DataReg = uValue;
}

//////////
// Function Name : GPIO_GetDataEach
// Function Desctiption : This function get each GPIO data bit
// Input :      Id : GPIO port
//                      uValue : value
// Output :     Data register value
//
// Version : v0.0
int GPIO_GetDataEach(GPIO_eId Id, GPIO_eBitPos eBitPos)
{
	volatile int *pGPIOx_DataReg;
	volatile int *pGPIO_Base_Addr;
	int uConRegNum, uOffset;

	uOffset = Id & 0xFFFFFF;
	uConRegNum = 1;

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);

	pGPIOx_DataReg = pGPIO_Base_Addr + (uOffset / 4) + uConRegNum;
	return ((*pGPIOx_DataReg) & (1 << eBitPos)) ? 1 : 0;
}

//////////
// Function Name : GPIO_GetDataAll
// Function Desctiption : This function get all GPIO data bit
// Input : 	Id : GPIO port
//			uValue : value
// Output : 	Data register value
//
// Version : v0.0
int GPIO_GetDataAll(GPIO_eId Id)
{
	volatile int *pGPIOx_DataReg;
	volatile int *pGPIO_Base_Addr;
	int uConRegNum, uOffset;


	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;
	

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_DataReg = pGPIO_Base_Addr + (uOffset/4)+ uConRegNum;
	return (*pGPIOx_DataReg);
}


//////////
// Function Name : GPIO_SetPullUpDownEach
// Function Desctiption : This function set each GPIO Pull-up/Down bits
// Input : 	Id : GPIO port
//			eBitPos : GPIO bit
//			uValue : value(2bit)
// Output : NONE
//
// Version : v0.0
void GPIO_SetPullUpDownEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uValue)
{
	volatile int *pGPIOx_PullUDReg;
	volatile int *pGPIO_Base_Addr;
	int uConRegNum, uDataRegNum,  uOffset;
	int uPullValue;

	
	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;
	uDataRegNum = 1;
	

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_PullUDReg = pGPIO_Base_Addr + (uOffset/4) + uConRegNum+uDataRegNum;
	uPullValue = *pGPIOx_PullUDReg;
	uPullValue = (uPullValue & ~(0x3<<(0x02*eBitPos))) | (uValue<<(0x02*eBitPos));
	*pGPIOx_PullUDReg = uPullValue;
}



//////////
// Function Name : GPIO_SetPullUpDownAll
// Function Desctiption : This function set all GPIO Pull-up/Down bits
// Input : 	Id : GPIO port
//			uValue : value(32bit)
// Output : NONE
//
// Version : v0.0
void GPIO_SetPullUpDownAll(GPIO_eId Id, int uValue)
{
	volatile int *pGPIOx_PullUDReg;
	volatile int *pGPIO_Base_Addr;
	int  uConRegNum, uDataRegNum, uOffset;

	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;
	uDataRegNum = 1;
	

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_PullUDReg = pGPIO_Base_Addr + (uOffset/4) + uConRegNum+uDataRegNum;
	*pGPIOx_PullUDReg = uValue;
}


//////////
// Function Name : ETC_SetPullUpDownEach
// Function Desctiption : This function set each ETC Pull-up/Down bits
// Input : 	Id : ETC port
//			eBitPos : ETC bit
//			uValue : value(2bit)
// Output : NONE
//
// Version : v0.0
void ETC_SetPullUpDownEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uValue)
{
	volatile int *pETCx_PullUDReg;
	volatile int *pGPIO_Base_Addr;
	int uOffset;
	int uPullValue;

	
	uOffset = Id&0xFFFFFF; 
	

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pETCx_PullUDReg = pGPIO_Base_Addr + (uOffset/4) ;
	uPullValue = *pETCx_PullUDReg;
	uPullValue = (uPullValue & ~(0x3<<(0x02*eBitPos))) | (uValue<<(0x02*eBitPos));
	*pETCx_PullUDReg = uPullValue;
}


//////////
// Function Name : ETC_SetPullUpDownAll
// Function Desctiption : This function set all ETC Pull-up/Down bits
// Input : 	Id : ETC port
//			uValue : value(16bit)
// Output : NONE
//
// Version : v0.0
void ETC_SetPullUpDownAll(GPIO_eId Id, int uValue)
{
	volatile int *pETCx_PullUDReg;
	volatile int *pGPIO_Base_Addr;
	int  uOffset;

	uOffset = Id&0xFFFFFF; 
	
	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pETCx_PullUDReg = pGPIO_Base_Addr + (uOffset/4);
	*pETCx_PullUDReg = uValue;
}



//////////
// Function Name : GPIO_SetDSEach
// Function Desctiption : This function set each GPIO Driving Strength bits
// Input : 	Id : GPIO port
//			eBitPos : GPIO bit
//			uValue : value(2bit)
// Output : NONE
//
// Version : v0.0
void GPIO_SetDSEach(GPIO_eId Id, GPIO_eBitPos eBitPos, int uValue)
{
	volatile int *pGPIOx_DSReg;
	volatile int *pGPIO_Base_Addr;
	int uConRegNum, uDataRegNum,  uPullUDRegNum, uOffset;
	int uDSValue;

	
	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;
	uDataRegNum = 1;
	uPullUDRegNum = 1;
	

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_DSReg = pGPIO_Base_Addr + (uOffset/4) + uConRegNum+uDataRegNum+uPullUDRegNum;
	uDSValue = *pGPIOx_DSReg;
	uDSValue = (uDSValue & ~(0x3<<(0x02*eBitPos))) | (uValue<<(0x02*eBitPos));
	*pGPIOx_DSReg = uDSValue;
}


//////////
// Function Name : GPIO_SetDSAll
// Function Desctiption : This function set All GPIO Driving Strength bits
// Input : 	Id : GPIO port
//			uValue : value(16bit)
// Output : NONE
//
// Version : v0.0
void GPIO_SetDSAll(GPIO_eId Id, int uValue)
{
	volatile int *pGPIOx_DSReg;
	volatile int *pGPIO_Base_Addr;
	int uConRegNum, uDataRegNum,  uPullUDRegNum, uOffset;
	int uDSValue;

	
	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;
	uDataRegNum = 1;
	uPullUDRegNum = 1;
	

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_DSReg = pGPIO_Base_Addr + (uOffset/4) + uConRegNum+uDataRegNum+uPullUDRegNum;
	uDSValue = *pGPIOx_DSReg;
	uDSValue = (uDSValue & ~(0xffff)) | uValue;
	*pGPIOx_DSReg = uDSValue;
}
                                                                                               



//////////
// Function Name : GPIO_SetConRegPDNAll
// Function Desctiption : This function set all GPIO function when system enter to Power Down mode
// Input : 	Id : GPIO port
//			uValue : value(16bit)
// Output : NONE
//
// Version : v0.0
void GPIO_SetConRegPDNAll(GPIO_eId Id, int uValue)
{
	volatile int *pGPIOx_ConPDNReg;
	volatile int *pGPIO_Base_Addr;
	int uConRegNum, uDataRegNum, uPullUDRegNum, uConDSRegNum, uOffset;

	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;	
	uDataRegNum = 1;
	uPullUDRegNum = 1;
	uConDSRegNum =1;

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_ConPDNReg = pGPIO_Base_Addr + (uOffset/4) + (uConRegNum + uDataRegNum + uPullUDRegNum+uConDSRegNum);
	*pGPIOx_ConPDNReg = uValue;
}


//////////
// Function Name : GPIO_SetPullUDPDNAll
// Function Desctiption : This function set all GPIO Pull-up/down when system enter to Power Down mode
// Input : 	Id : GPIO port
//			uValue : value(16bit)
// Output : NONE
//
// Version : v0.1
void GPIO_SetPullUDPDNAll(GPIO_eId Id, int uValue)
{
	volatile int *pGPIOx_PullUDPDNReg;
	volatile int *pGPIO_Base_Addr;
	int uConRegNum, uDataRegNum, uPullUDRegNum, uConDSRegNum, uConPDNRegNum, uOffset;

	uOffset = Id&0xFFFFFF; 
	uConRegNum = 1;
	uDataRegNum = 1;
	uPullUDRegNum = 1;
	uConDSRegNum =1;
	uConPDNRegNum = 1;

	pGPIO_Base_Addr = &(GPIO_REG->rGPIOJ0CON);
	
	pGPIOx_PullUDPDNReg = pGPIO_Base_Addr + (uOffset/4) + (uConRegNum+uDataRegNum+uPullUDRegNum+uConDSRegNum+uConPDNRegNum);
	*pGPIOx_PullUDPDNReg = uValue;
}



//////////
// Function Name : GPIO_SetEint1
// Function Desctiption : This function setup Eint1[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint1(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

//	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT1CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
	uType =uEINT_No;
	pEINTx_Reg = pGPIO_EINT_Addr ; 	
	uConValue = *pEINTx_Reg;
	uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
	*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
	uGpioPort = uEINT_No;
	uFunc = 0xf;  					// EINT Function 
	GPIO_SetFunctionEach(eGPIO_A0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
	// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT1FLTCON0) ; 	    // EINT1FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No > 3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT1FLTCON1); 	    // EINT1FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT1ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint1[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT1ClrPend(int uEINT_No )
{

	volatile int *pEINT1PEND;
	int uConValue;

	pEINT1PEND = &(GPIO_REG->rEINT1PEND);

	uConValue = (1<<uEINT_No);
	*pEINT1PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT1UnMask
// Function Desctiption : UnMask the Eint1[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT1UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT1MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT1Mask
// Function Desctiption : Mask the Eint1[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT1Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT1MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}


//////////
// Function Name : GPIO_SetEint2
// Function Desctiption : This function setup Eint2[3:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint2(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT2CON);

	
	if (uEINT_No >5)
	{
		printf("Error Eint No. \n");
	}
	

	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}
	

	//  Interrupt Type 
	if( uEINT_No <= 5)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 5)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_A1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT2FLTCON0) ; 	    // EINT2FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No > 3 && uEINT_No <= 5)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT2FLTCON1); 	    // EINT2FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
	
}



//////////
// Function Name : GPIO_EINT2ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint2[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT2ClrPend(int uEINT_No )
{

	volatile int *pEINT2PEND;
	int uConValue;

	pEINT2PEND = &(GPIO_REG->rEINT2PEND);

	uConValue = (1<<uEINT_No);
	*pEINT2PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT2UnMask
// Function Desctiption : UnMask the Eint2[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT2UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT2MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT2Mask
// Function Desctiption : Mask the Eint2[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT2Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT2MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint3
// Function Desctiption : This function setup Eint3[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint3(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT3CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_B, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT3FLTCON0) ; 	    // EINT3FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT3FLTCON1); 	    // EINT3FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT3ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint3[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT3ClrPend(int uEINT_No )
{

	volatile int *pEINT3PEND;
	int uConValue;

	pEINT3PEND = &(GPIO_REG->rEINT3PEND);

	uConValue = (1<<uEINT_No);
	*pEINT3PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT3UnMask
// Function Desctiption : UnMask the Eint3[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT3UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT3MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT3Mask
// Function Desctiption : Mask the Eint3[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT3Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT3MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}




//////////
// Function Name : GPIO_SetEint4
// Function Desctiption : This function setup Eint4[4:0]=> GPC0[4:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint4(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT4CON);

	if (uEINT_No > 4)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 4)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 4)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_C0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT4FLTCON0) ; 	    // EINT4FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No == 4)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT4FLTCON1); 	    // EINT4FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT4ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint4[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT4ClrPend(int uEINT_No )
{

	volatile int *pEINT4PEND;
	int uConValue;

	pEINT4PEND = &(GPIO_REG->rEINT4PEND);

	uConValue = (1<<uEINT_No);
	*pEINT4PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT4UnMask
// Function Desctiption : UnMask the Eint4[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT4UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT4MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT4Mask
// Function Desctiption : Mask the Eint4[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT4Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT4MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint5
// Function Desctiption : This function setup Eint5[4:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint5(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT5CON);

	if (uEINT_No > 4)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 4)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 4)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_C1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT5FLTCON0) ; 	    // EINT5FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No == 4)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT5FLTCON1); 	    // EINT5FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT5ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint5[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT5ClrPend(int uEINT_No )
{

	volatile int *pEINT5PEND;
	int uConValue;

	pEINT5PEND = &(GPIO_REG->rEINT5PEND);

	uConValue = (1<<uEINT_No);
	*pEINT5PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT5UnMask
// Function Desctiption : UnMask the Eint5[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT5UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT5MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT5Mask
// Function Desctiption : Mask the Eint5[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT5Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT5MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint6
// Function Desctiption : This function setup Eint6[3:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint6(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT6CON);

	if (uEINT_No > 3)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 3)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_D0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT6FLTCON0) ; 	    // EINT6FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	
	
}



//////////
// Function Name : GPIO_EINT6ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint6[3:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT6ClrPend(int uEINT_No )
{

	volatile int *pEINT6PEND;
	int uConValue;

	pEINT6PEND = &(GPIO_REG->rEINT6PEND);

	uConValue = (1<<uEINT_No);
	*pEINT6PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT6UnMask
// Function Desctiption : UnMask the Eint6[3:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT6UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT6MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT6Mask
// Function Desctiption : Mask the Eint6[3:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT6Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT6MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint7
// Function Desctiption : This function setup Eint7[3:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint7(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT7CON);

	if (uEINT_No > 3)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 3)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_D1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT7FLTCON0) ; 	    // EINT7FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT7ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint7[3:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT7ClrPend(int uEINT_No )
{

	volatile int *pEINT7PEND;
	int uConValue;

	pEINT7PEND = &(GPIO_REG->rEINT7PEND);

	uConValue = (1<<uEINT_No);
	*pEINT7PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT7UnMask
// Function Desctiption : UnMask the Eint7[3:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT7UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT7MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT7Mask
// Function Desctiption : Mask the Eint7[3:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT7Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT7MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}




//////////
// Function Name : GPIO_SetEint8
// Function Desctiption : This function setup Eint8[4:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint8(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT8CON);

	if (uEINT_No > 4)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 4)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 4)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_E0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT8FLTCON0) ; 	    // EINT8FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No == 4)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT8FLTCON1); 	    // EINT8FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT8ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint8[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT8ClrPend(int uEINT_No )
{

	volatile int *pEINT8PEND;
	int uConValue;

	pEINT8PEND = &(GPIO_REG->rEINT8PEND);

	uConValue = (1<<uEINT_No);
	*pEINT8PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT8UnMask
// Function Desctiption : UnMask the Eint8[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT8UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT8MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT8Mask
// Function Desctiption : Mask the Eint8[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT8Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT8MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}


//////////
// Function Name : GPIO_SetEint9
// Function Desctiption : This function setup Eint9[7:0]=> GPE1[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint9(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT9CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_E1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT9FLTCON0) ; 	    // EINT9FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No > 3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT9FLTCON1); 	    // EINT9FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT9ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint9[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT9ClrPend(int uEINT_No )
{

	volatile int *pEINT9PEND;
	int uConValue;

	pEINT9PEND = &(GPIO_REG->rEINT9PEND);

	uConValue = (1<<uEINT_No);
	*pEINT9PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT9UnMask
// Function Desctiption : UnMask the Eint9[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT9UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT9MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT9Mask
// Function Desctiption : Mask the Eint9[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT9Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT9MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint10
// Function Desctiption : This function setup Eint10[5:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint10(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT10CON);

	if (uEINT_No > 5)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 5)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 5)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_E2, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT10FLTCON0) ; 	    // EINT10FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <=5)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT10FLTCON1); 	    // EINT10FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT10ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint10[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT10ClrPend(int uEINT_No )
{

	volatile int *pEINT10PEND;
	int uConValue;

	pEINT10PEND = &(GPIO_REG->rEINT10PEND);

	uConValue = (1<<uEINT_No);
	*pEINT10PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT10UnMask
// Function Desctiption : UnMask the Eint10[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT10UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT10MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT10Mask
// Function Desctiption : Mask the Eint10[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT10Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT10MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}





//////////
// Function Name : GPIO_SetEint11
// Function Desctiption : This function setup Eint11[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint11(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT11CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_E3, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT11FLTCON0) ; 	    // EINT11FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No > 3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT11FLTCON1); 	    // EINT11FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT11ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint11[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT11ClrPend(int uEINT_No )
{

	volatile int *pEINT11PEND;
	int uConValue;

	pEINT11PEND = &(GPIO_REG->rEINT11PEND);

	uConValue = (1<<uEINT_No);
	*pEINT11PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT11UnMask
// Function Desctiption : UnMask the Eint11[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT11UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT11MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT11Mask
// Function Desctiption : Mask the Eint11[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT11Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT11MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}




//////////
// Function Name : GPIO_SetEint12
// Function Desctiption : This function setup Eint12[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint12(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT12CON);

	
	if (uEINT_No >7)
	{
		printf("Error Eint No. \n");
	}
	

	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}
	

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_E4, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT12FLTCON0) ; 	    // EINT12FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No > 3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT12FLTCON1); 	    // EINT12FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
	
}



//////////
// Function Name : GPIO_EINT12ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint12[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT12ClrPend(int uEINT_No )
{

	volatile int *pEINT12PEND;
	int uConValue;

	pEINT12PEND = &(GPIO_REG->rEINT12PEND);

	uConValue = (1<<uEINT_No);
	*pEINT12PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT12UnMask
// Function Desctiption : UnMask the Eint12[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT12UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT12MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT12Mask
// Function Desctiption : Mask the Eint12[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT12Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT12MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint13
// Function Desctiption : This function setup Eint13[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint13(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT13CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_F0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT13FLTCON0) ; 	    // EINT13FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 5)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT13FLTCON1); 	    // EINT13FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT13ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint13[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT13ClrPend(int uEINT_No )
{

	volatile int *pEINT13PEND;
	int uConValue;

	pEINT13PEND = &(GPIO_REG->rEINT13PEND);

	uConValue = (1<<uEINT_No);
	*pEINT13PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT13UnMask
// Function Desctiption : UnMask the Eint13[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT13UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT13MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT13Mask
// Function Desctiption : Mask the Eint13[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT13Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT13MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}




//////////
// Function Name : GPIO_SetEint14
// Function Desctiption : This function setup Eint14[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint14(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT14CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_F1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT14FLTCON0) ; 	    // EINT14FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT14FLTCON1); 	    // EINT14FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT14ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint14[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT14ClrPend(int uEINT_No )
{

	volatile int *pEINT14PEND;
	int uConValue;

	pEINT14PEND = &(GPIO_REG->rEINT14PEND);

	uConValue = (1<<uEINT_No);
	*pEINT14PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT14UnMask
// Function Desctiption : UnMask the Eint14[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT14UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT14MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT14Mask
// Function Desctiption : Mask the Eint14[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT14Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT14MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint15
// Function Desctiption : This function setup Eint15[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint15(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT15CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_F2, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT15FLTCON0) ; 	    // EINT15FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT15FLTCON1); 	    // EINT15FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT15ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint15[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT15ClrPend(int uEINT_No )
{

	volatile int *pEINT15PEND;
	int uConValue;

	pEINT15PEND = &(GPIO_REG->rEINT15PEND);

	uConValue = (1<<uEINT_No);
	*pEINT15PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT15UnMask
// Function Desctiption : UnMask the Eint15[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT15UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT15MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT15Mask
// Function Desctiption : Mask the Eint15[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT15Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT15MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint16
// Function Desctiption : This function setup Eint16[5:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint16(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT16CON);

	if (uEINT_No > 5)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 5)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 5)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_F3, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT16FLTCON0) ; 	    // EINT16FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 5)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT16FLTCON1); 	    // EINT16FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
	
}



//////////
// Function Name : GPIO_EINT16ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint16[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT16ClrPend(int uEINT_No )
{

	volatile int *pEINT16PEND;
	int uConValue;

	pEINT16PEND = &(GPIO_REG->rEINT16PEND);

	uConValue = (1<<uEINT_No);
	*pEINT16PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT16UnMask
// Function Desctiption : UnMask the Eint16[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT16UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT16MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT16Mask
// Function Desctiption : Mask the Eint16[5:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT16Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT16MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}

//=========================================================
// C200
// Don't use eint17~eint20
//=========================================================

//////////
// Function Name : GPIO_SetEint21
// Function Desctiption : This function setup Eint21[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint21(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT21CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_J0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT21FLTCON0) ; 	    // EINT21FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No > 3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT21FLTCON1); 	    // EINT21FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT21ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint21[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT21ClrPend(int uEINT_No )
{

	volatile int *pEINT21PEND;
	int uConValue;

	pEINT21PEND = &(GPIO_REG->rEINT21PEND);

	uConValue = (1<<uEINT_No);
	*pEINT21PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT21UnMask
// Function Desctiption : UnMask the Eint21[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT21UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT21MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT21Mask
// Function Desctiption : Mask the Eint21[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT21Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT21MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}




//////////
// Function Name : GPIO_SetEint22
// Function Desctiption : This function setup Eint22[4:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint22(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT22CON);

	
	if (uEINT_No >4)
	{
		printf("Error Eint No. \n");
	}
	

	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}
	

	//  Interrupt Type 
	if( uEINT_No <= 4)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 4)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_J1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT22FLTCON0) ; 	    // EINT22FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No == 4)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT22FLTCON1); 	    // EINT22FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
	
}



//////////
// Function Name : GPIO_EINT22ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint22[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT22ClrPend(int uEINT_No )
{

	volatile int *pEINT22PEND;
	int uConValue;

	pEINT22PEND = &(GPIO_REG->rEINT22PEND);

	uConValue = (1<<uEINT_No);
	*pEINT22PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT22UnMask
// Function Desctiption : UnMask the Eint22[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT22UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT22MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT22Mask
// Function Desctiption : Mask the Eint22[4:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT22Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT22MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint23
// Function Desctiption : This function setup Eint23[6:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint23(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT23CON);

	if (uEINT_No > 6)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 6)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 6)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_K0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT23FLTCON0) ; 	    // EINT23FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 6)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT23FLTCON1); 	    // EINT23FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT23ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint23[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT23ClrPend(int uEINT_No )
{

	volatile int *pEINT23PEND;
	int uConValue;

	pEINT23PEND = &(GPIO_REG->rEINT23PEND);

	uConValue = (1<<uEINT_No);
	*pEINT23PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT23UnMask
// Function Desctiption : UnMask the Eint23[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT23UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT23MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT23Mask
// Function Desctiption : Mask the Eint23[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT23Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT23MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint24
// Function Desctiption : This function setup Eint24[6:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint24(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT24CON);

	if (uEINT_No > 6)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 6)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 6)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_K1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT24FLTCON0) ; 	    // EINT24FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 6)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT24FLTCON1); 	    // EINT24FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT24ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint23[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT24ClrPend(int uEINT_No )
{

	volatile int *pEINT24PEND;
	int uConValue;

	pEINT24PEND = &(GPIO_REG->rEINT24PEND);

	uConValue = (1<<uEINT_No);
	*pEINT24PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT24UnMask
// Function Desctiption : UnMask the Eint24[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT24UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT24MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT24Mask
// Function Desctiption : Mask the Eint24[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT24Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT24MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint25
// Function Desctiption : This function setup Eint25[6:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint25(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT25CON);

	if (uEINT_No > 6)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 6)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 6)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_K2, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT25FLTCON0) ; 	    // EINT25FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 6)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT25FLTCON1); 	    // EINT25FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT25ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint25[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT25ClrPend(int uEINT_No )
{

	volatile int *pEINT25PEND;
	int uConValue;

	pEINT25PEND = &(GPIO_REG->rEINT25PEND);

	uConValue = (1<<uEINT_No);
	*pEINT25PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT25UnMask
// Function Desctiption : UnMask the Eint25[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT25UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT25MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT25Mask
// Function Desctiption : Mask the Eint25[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT25Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT25MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}




//////////
// Function Name : GPIO_SetEint26
// Function Desctiption : This function setup Eint26[6:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint26(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT26CON);

	if (uEINT_No > 6)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 6)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 6)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_K3, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT26FLTCON0) ; 	    // EINT26FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 6)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT26FLTCON1); 	    // EINT26FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT26ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint26[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT26ClrPend(int uEINT_No )
{

	volatile int *pEINT26PEND;
	int uConValue;

	pEINT26PEND = &(GPIO_REG->rEINT26PEND);

	uConValue = (1<<uEINT_No);
	*pEINT26PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT26UnMask
// Function Desctiption : UnMask the Eint26[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT26UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT26MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT26Mask
// Function Desctiption : Mask the Eint26[6:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT26Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT26MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint27
// Function Desctiption : This function setup Eint27[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint27(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT27CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_L0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT27FLTCON0) ; 	    // EINT27FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT27FLTCON1); 	    // EINT27FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT27ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint27[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT27ClrPend(int uEINT_No )
{

	volatile int *pEINT27PEND;
	int uConValue;

	pEINT27PEND = &(GPIO_REG->rEINT27PEND);

	uConValue = (1<<uEINT_No);
	*pEINT27PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT27UnMask
// Function Desctiption : UnMask the Eint27[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT27UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT27MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT27Mask
// Function Desctiption : Mask the Eint27[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT27Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT27MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}




//////////
// Function Name : GPIO_SetEint28
// Function Desctiption : This function setup Eint28[2:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint28(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT28CON);

	if (uEINT_No > 2)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 2)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 2)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_L1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 2)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT28FLTCON0) ; 	    // EINT28FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}

	
}



//////////
// Function Name : GPIO_EINT28ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint28[2:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT28ClrPend(int uEINT_No )
{

	volatile int *pEINT28PEND;
	int uConValue;

	pEINT28PEND = &(GPIO_REG->rEINT28PEND);

	uConValue = (1<<uEINT_No);
	*pEINT28PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT28UnMask
// Function Desctiption : UnMask the Eint28[2:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT28UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT28MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT28Mask
// Function Desctiption : Mask the Eint28[2:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT28Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT28MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint29
// Function Desctiption : This function setup Eint29[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 1~0x7F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint29(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT29CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x7f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_L2, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT29FLTCON0) ; 	    // EINT29FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 6)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT29FLTCON1); 	    // EINT29FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+7)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT29ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint29[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT29ClrPend(int uEINT_No )
{

	volatile int *pEINT29PEND;
	int uConValue;

	pEINT29PEND = &(GPIO_REG->rEINT29PEND);

	uConValue = (1<<uEINT_No);
	*pEINT29PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT29UnMask
// Function Desctiption : UnMask the Eint29[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT29UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT29MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT29Mask
// Function Desctiption : Mask the Eint29[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT29Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT29MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint40
// Function Desctiption : This function setup Eint40[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 0x1 ~ 0x3F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint40(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT40CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth > 0x3f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_X0, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT40FLTCON0) ; 	    // EINT40FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <=7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT40FLTCON1); 	    // EINT40FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT40ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint40[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT40ClrPend(int uEINT_No )
{

	volatile int *pEINT40PEND;
	int uConValue;

	pEINT40PEND = &(GPIO_REG->rEINT40PEND);

	uConValue = (1<<uEINT_No);
	*pEINT40PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT40UnMask
// Function Desctiption : UnMask the Eint40[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT40UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT40MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT40Mask
// Function Desctiption : Mask the Eint40[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT40Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT40MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint41
// Function Desctiption : This function setup Eint41[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 0x1~0x3F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint41(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT41CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x3f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_X1, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT41FLTCON0) ; 	    // EINT41FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No > 3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT41FLTCON1); 	    // EINT41FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT41ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint41[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT41ClrPend(int uEINT_No )
{

	volatile int *pEINT41PEND;
	int uConValue;

	pEINT41PEND = &(GPIO_REG->rEINT41PEND);

	uConValue = (1<<uEINT_No);
	*pEINT41PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT41UnMask
// Function Desctiption : UnMask the Eint41[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT41UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT41MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT41Mask
// Function Desctiption : Mask the Eint41[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT41Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT41MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}




//////////
// Function Name : GPIO_SetEint42
// Function Desctiption : This function setup Eint42[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 0x1~0x3F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint42(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT42CON);

	
	if (uEINT_No >7)
	{
		printf("Error Eint No. \n");
	}
	

	// Check Filter Width 
	if(uFltWidth >0x3f)
	{
		printf("Error Filter Width. \n");
	}
	

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_X2, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT42FLTCON0) ; 	    // EINT42FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No > 3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT42FLTCON1); 	    // EINT42FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	
	
}



//////////
// Function Name : GPIO_EINT42ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint42[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT42ClrPend(int uEINT_No )
{

	volatile int *pEINT42PEND;
	int uConValue;

	pEINT42PEND = &(GPIO_REG->rEINT42PEND);

	uConValue = (1<<uEINT_No);
	*pEINT42PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT42UnMask
// Function Desctiption : UnMask the Eint42[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT42UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT42MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}

//////////
// Function Name : GPIO_EINT42Mask
// Function Desctiption : Mask the Eint42[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT42Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT42MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////
// Function Name : GPIO_SetEint43
// Function Desctiption : This function setup Eint43[7:0]
// Input : 			uEINT_No: EINT No.
//					uINTType: Select EINT Type. 
//								Low, High, Falling, Rising, Both
//					uFltType :  Select Filter Type
//								DisFLT(Disable Filter), DLYFLT(Delay Filter), DIGFLT(Digital Filter)
//					uFltWidth : Digital Filter Width ( 0x1~0x3F)
// Output : NONE
//
// Version : v0.0
void GPIO_SetEint43(int uEINT_No , int uIntType, FLT_eTYPE eFltType,  int uFltWidth)
{

	volatile int *pEINTx_Reg, *pFLTx_Reg;
	volatile int *pGPIO_EINT_Addr;
	int uGpioPort, uFunc, uType ;	
	int uConValue;

	GPIO_pBase = (void *)GPIO_BASE;

	pGPIO_EINT_Addr = &(GPIO_REG->rEINT43CON);

	if (uEINT_No > 7)
	{
		printf("Error Eint No. \n");
	}
	
	// Check Filter Width 
	if(uFltWidth >0x3f)
	{
		printf("Error Filter Width. \n");
	}

	//  Interrupt Type 
	if( uEINT_No <= 7)
	{
		uType =uEINT_No;
		pEINTx_Reg = pGPIO_EINT_Addr ; 	
		uConValue = *pEINTx_Reg;
		uConValue = (uConValue & ~(0xF<<(uType*4))) | (uIntType<<(uType*4));
		*pEINTx_Reg = uConValue;
	}


	// EINT Port
	if( uEINT_No <= 7)
	{
		uGpioPort = uEINT_No;
		uFunc = 0xf;  					// EINT Function 
		GPIO_SetFunctionEach(eGPIO_X3, (GPIO_eBitPos)uGpioPort, uFunc);		// ??
		// GPIO_SetPullUpDownEach(eGPIO_N,(GPIO_eBitPos) uGpioPort, 0x0);		// disable Pull-up/dn
	}
		

	// Fliter Type & Filter Width 
	if( uEINT_No <= 3)
	{
		uType =uEINT_No;
		pFLTx_Reg = &(GPIO_REG->rEINT43FLTCON0) ; 	    // EINT43FLTCON0
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	else if(uEINT_No >3 && uEINT_No <= 7)
	{
		uType =uEINT_No-4;
		pFLTx_Reg =&(GPIO_REG->rEINT43FLTCON1); 	    // EINT43FLTCON1
		uConValue = *pFLTx_Reg;
		uConValue = (uConValue & ~(0xFF<<(uType*8))) |((uFltWidth<<(uType*8))|(eFltType<<(uType*8+6)));
		*pFLTx_Reg = uConValue;	
	}
	
}



//////////
// Function Name : GPIO_EINT43ClrPend
// Function Desctiption : Clear Eint pending bit of the Eint43[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT43ClrPend(int uEINT_No )
{

	volatile int *pEINT43PEND;
	int uConValue;

	pEINT43PEND = &(GPIO_REG->rEINT43PEND);

	uConValue = (1<<uEINT_No);
	*pEINT43PEND = uConValue;

}

//////////
// Function Name : GPIO_EINT43UnMask
// Function Desctiption : UnMask the Eint43[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT43UnMask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT43MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)));
	*pMASK_Reg = uConValue;

}


//////////
// Function Name : GPIO_EINT43Mask
// Function Desctiption : Mask the Eint43[7:0]
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void GPIO_EINT43Mask(int uEINT_No )
{

	volatile int *pMASK_Reg;
	int uConValue;

	pMASK_Reg = &(GPIO_REG->rEINT43MASK);
	
	uConValue = *pMASK_Reg;
       uConValue = (uConValue & ~(0x1<<(uEINT_No)))|(1<<uEINT_No);
	*pMASK_Reg = uConValue;

}



//////////====================================================
// Function Name : EINT_GRPPRI_XA
// Function Desctiption : EINT Group priority rotate enable/diable (Fixed)
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void EINT_GRPPRI_XA(PRI_eTYPE uPriType )
{

	volatile int *pEINT_GrpPri;
	int uConValue;

	pEINT_GrpPri = &(GPIO_REG->rEINTGRPPRIXA);
	
	uConValue = *pEINT_GrpPri;
       uConValue = (uConValue & ~(0x1))|(uPriType);
	*pEINT_GrpPri = uConValue;

}


//////////
// Function Name : EINT_GRPPRI_XB
// Function Desctiption : EINT Group priority rotate enable/diable (Fixed)
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void EINT_GRPPRI_XB(PRI_eTYPE uPriType )
{

	volatile int *pEINT_GrpPri;
	int uConValue;

	pEINT_GrpPri = &(GPIO_REG->rEINTGRPPRIXB);
	
	uConValue = *pEINT_GrpPri;
       uConValue = (uConValue & ~(0x1))|(uPriType);
	*pEINT_GrpPri = uConValue;

}



//////////
// Function Name : EINT_PRIORITY_XA
// Function Desctiption : Every EINT group priority rotate enable/diable (Fixed)
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void EINT_PRIORITY_XA(int uEINT_No )
{

	volatile int *pEINT_Priority;
	int uConValue;

	pEINT_Priority = &(GPIO_REG->rEINTPRIORITYXA);
	
	uConValue = *pEINT_Priority;
       uConValue = (uConValue & ~(0x1<<(uEINT_No-1)))|(1<<uEINT_No-1);
	*pEINT_Priority = uConValue;

}


//////////
// Function Name : EINT_PRIORITY_XB
// Function Desctiption : Every EINT group priority rotate enable/diable (Fixed)
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void EINT_PRIORITY_XB(int uEINT_No )
{

	volatile int *pEINT_Priority;
	int uConValue;

	pEINT_Priority = &(GPIO_REG->rEINTPRIORITYXB);
	
	uConValue = *pEINT_Priority;
       uConValue = (uConValue & ~(0x1<<(uEINT_No-1)))|(1<<uEINT_No-1);
	*pEINT_Priority = uConValue;

}



//////////
// Function Name : Get_EINTSVC_XA
// Function Desctiption : This function get EINT service group and interrupt number
// Input : 	None
// Output : 	Data register value
//
// Version : v0.0

int Get_EINTSVC_XA(void)
{
	volatile int *pEINT_Service;
	volatile int *pGPIO_Base_Addr;

	pEINT_Service = &(GPIO_REG->rEINTSERVICEXA);

	return (*pEINT_Service);
}


//////////
// Function Name : Get_EINTSVC_XB
// Function Desctiption : This function get EINT service group and interrupt number
// Input : 	None
// Output : 	Data register value
//
// Version : v0.0

int Get_EINTSVC_XB(void)
{
	volatile int *pEINT_Service;
	volatile int *pGPIO_Base_Addr;

	pEINT_Service = &(GPIO_REG->rEINTSERVICEXB);

	return (*pEINT_Service);
}



//////////
// Function Name : Get_EINTSVCPND_XA
// Function Desctiption : This function get pending EINT service group and interrupt number
// Input : 	None
// Output : 	Data register value
//
// Version : v0.0

int Get_EINTSVCPEND_XA(void)
{
	volatile int *pEINT_ServicePnd;
	volatile int *pGPIO_Base_Addr;

	pEINT_ServicePnd = &(GPIO_REG->rEINTSERVICEPENDXA);	
	return (*pEINT_ServicePnd);
}


//////////
// Function Name : Get_EINTSVCPND_XB
// Function Desctiption : This function get pending EINT service group and interrupt number
// Input : 	None
// Output : 	Data register value
//
// Version : v0.0

int Get_EINTSVCPEND_XB(void)
{
	volatile int *pEINT_ServicePnd;
	volatile int *pGPIO_Base_Addr;

	pEINT_ServicePnd = &(GPIO_REG->rEINTSERVICEPENDXB);	
	return (*pEINT_ServicePnd);
}



//////////
// Function Name : EINT_GRPFIXPRI_XA
// Function Desctiption : Group number of the highest priority when fixed group priority mode (EINT1 ~ 16)
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void EINT_GRPFIXPRI_XA(int uEINT_No )
{

	volatile int *pEINT_GrpFixPri;
	int uConValue;

	pEINT_GrpFixPri = &(GPIO_REG->rEINTGRPFIXPRIXA);
	
	uConValue = *pEINT_GrpFixPri;
       uConValue = (uConValue & ~(0x1))|(uEINT_No);
	*pEINT_GrpFixPri = uConValue;

}


//////////
// Function Name : EINT_GRPFIXPRI_XB
// Function Desctiption : Group number of the highest priority when fixed group priority mode (EINT21 ~ 29)
// Input : 			uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void EINT_GRPFIXPRI_XB(int uEINT_No )
{

	volatile int *pEINT_GrpFixPri;
	int uConValue;

	pEINT_GrpFixPri = &(GPIO_REG->rEINTGRPFIXPRIXB);
	
	uConValue = *pEINT_GrpFixPri;
       uConValue = (uConValue & ~(0x1))|(uEINT_No);
	*pEINT_GrpFixPri = uConValue;

}


//////////
// Function Name : EINT_FIXPRI_XA
// Function Desctiption : interrupt number of the highest priority when fixed group priority mode (0 ~ 7)
// Input :                uEINT_Grp_No			
//                           uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void EINT_FIXPRI_XA(int uEINT_Grp_No, int uEINT_No  )
{

	volatile int *pEINT_Grpx_FixPri, *pEINT_Grp1_FixPri;
	int uConValue;

	if(uEINT_Grp_No>0 && uEINT_Grp_No<17)	// EINT1 ~ EINT16
	{
		pEINT_Grp1_FixPri = &(GPIO_REG->rEINT1FIXPRI);
		pEINT_Grpx_FixPri = pEINT_Grp1_FixPri  + (uEINT_Grp_No-1);
		
		uConValue = *pEINT_Grpx_FixPri;
	       uConValue = (uConValue & ~(0x7))|(uEINT_No);
		*pEINT_Grpx_FixPri = uConValue;
	}
	else
	{
		printf(" select Fail. \n");
	}	
}


//////////
// Function Name : EINT_FIXPRI_XB
// Function Desctiption : interrupt number of the highest priority when fixed group priority mode (0 ~ 7)
// Input :                uEINT_Grp_No			
//                           uEINT_No: EINT No.
// Output : NONE
//
// Version : v0.0
void EINT_FIXPRI_XB(int uEINT_Grp_No, int uEINT_No  )
{

	volatile int *pEINT_Grpx_FixPri, *pEINT_Grp21_FixPri;
	int uConValue;

	if(uEINT_Grp_No>20 && uEINT_Grp_No<30)	// EINT21 ~ EINT29
	{
		pEINT_Grp21_FixPri = &(GPIO_REG->rEINT21FIXPRI);
		pEINT_Grpx_FixPri = pEINT_Grp21_FixPri  + (uEINT_Grp_No-1);
		
		uConValue = *pEINT_Grpx_FixPri;
	       uConValue = (uConValue & ~(0x7))|(uEINT_No);
		*pEINT_Grpx_FixPri = uConValue;
	}
	else
	{
		printf(" select Fail. \n");
	}
	
}
