/*
 * Copyright@ Samsung Electronics Co. LTD
 *
 * This software is proprietary of Samsung Electronics.
 * No part of this software, either material or conceptual may be copied or distributed, transmitted,
 * transcribed, stored in a retrieval system or translated into any human or computer language in any form by any means,
 * electronic, mechanical, manual or otherwise, or disclosed
 * to third parties without the express written permission of Samsung Electronics.


 * Alternatively, this program is free software in case of open source projec;
 * you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.

 */

#ifndef __UTIL_H__
#define __UTIL_H__

#define PRODUCT_ID			(0x10000000 + 0x000)
#define PKG_ID				(0x10000000 + 0x004)
#define OPR_MODE			(0x10000000 + 0x008)

#define Outp32(addr, data) (*(volatile u32 *)(addr) = (data))
#define Outp16(addr, data) (*(volatile u16 *)(addr) = (data))
#define Outp8(addr, data)  (*(volatile u8 *)(addr) = (data))

#define Inp32(addr) ((*(volatile u32 *)(addr)))
#define Inp16(addr) ((*(volatile u16 *)(addr)))
#define Inp8(addr)  ((*(volatile u8 *)(addr)))

#define max(a,b) ( ((a)>(b)) ? (a) : (b) )
#define min(a,b) ( ((a)>(b)) ? (b) : (a) )

#define Assert
#define Disp

#if defined(_FPGA_ENV)
#define SYSCLK_uS(x)		(  (x)*12  )		// x is micro-seconds(us).
#else
#define SYSCLK_uS(x)		(  (x)*400  )		// x is micro-seconds(us).
#endif

#define SetBits(uAddr, uBaseBit, uMaskValue, uSetValue) \
    Outp32(uAddr, (Inp32(uAddr) & ~((uMaskValue)<<(uBaseBit))) | (((uMaskValue)&(uSetValue))<<(uBaseBit)))
#define GetBits(uAddr, uBaseBit, uMaskValue) \
    ((Inp32(uAddr)>>(uBaseBit))&(uMaskValue))
#define Align(x, alignbyte) \
    (((x)+(alignbyte)-1)/(alignbyte)*(alignbyte))
#define max(a,b) ( ((a)>(b)) ? (a) : (b) )
#define min(a,b) ( ((a)>(b)) ? (b) : (a) )

#define GetEvtNum()			(GetBits(PRODUCT_ID, 4, 0xf))
#define GetEvtSubNum()		(GetBits(PRODUCT_ID, 0, 0xf))
#define GetPopOption()		(GetBits(PKG_ID, 4, 0xf))
#define GetDdrType()		(GetBits(PKG_ID, 14, 0x1))			// 0 : D25, 1 : D35
#define GetmDNIEStatus()	(GetBits(OPR_MODE, 23, 0x1))

void Copy1w(u32 sa, u32 da, u32 words);
#if defined(PWM_TIMER_ON)
void PWM_StartTimer(u32 uTsel);
u32 PWM_StopTimer(u32 uTsel);
#endif
#endif //__UTIL_H__
