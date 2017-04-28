
/*
 * arch/arm/include/asm/arch-txl/register.h
 *
 * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#ifndef __REGISTER_H__
#define __REGISTER_H__

#define IO_CBUS_BASE			0xFFD00000
#define IO_AXI_BUS_BASE			0xFFB00000
#define IO_AHB_BUS_BASE			0xFF500000
#define IO_APB_BUS_BASE			0xFFFC0000
#define IO_APB_HDMI_BUS_BASE	0xFFE00000
#define IO_VPU_BUS_BASE			0xFF900000

#define CBUS_REG_OFFSET(reg) ((reg) << 2)
#define CBUS_REG_ADDR(reg)	 (IO_CBUS_BASE + CBUS_REG_OFFSET(reg))

#if 0
/* below UART0,UART1,AO_UART is m8 addr,it is placed is for compiling pass */
/* -------------------------------
// UART0
// ---------------------------- */
#define UART0_WFIFO                                0x2130
#define UART0_RFIFO                                0x2131
#define UART0_CONTROL                              0x2132
#define UART0_STATUS                               0x2133
#define UART0_MISC                                 0x2134
#define UART0_REG5                                 0x2135
/* ----------------------------
// UART1
----------------------------*/
#define UART1_WFIFO                                0x2137
#define UART1_RFIFO                                0x2138
#define UART1_CONTROL                              0x2139
#define UART1_STATUS                               0x213a
#define UART1_MISC                                 0x213b
#define UART1_REG5                                 0x213c

/* ------------------------------------------------------
 The following are handled by $periphs/rtl/periphs_reg.v
  ----------------------------------------              */
#define PREG_CTLREG0_ADDR                          0x2000
#define P_PREG_CTLREG0_ADDR CBUS_REG_ADDR(PREG_CTLREG0_ADDR)

/* ----------------------------
 clock measure (4)
 ---------------------------- */
#define MSR_CLK_DUTY                               0x21d6
#define MSR_CLK_REG0                               0x21d7
#define MSR_CLK_REG1                               0x21d8
#define MSR_CLK_REG2                               0x21d9
#define P_MSR_CLK_DUTY CBUS_REG_ADDR(MSR_CLK_DUTY)
#define P_MSR_CLK_REG0 CBUS_REG_ADDR(MSR_CLK_REG0)
#define P_MSR_CLK_REG1 CBUS_REG_ADDR(MSR_CLK_REG1)
#define P_MSR_CLK_REG2 CBUS_REG_ADDR(MSR_CLK_REG2)
#endif

#if 0
/* --------------------------------
 *  AO uart
 * -------------------------------*/
#define IO_AOBUS_BASE			0xc8100000  ///1M

#define AOBUS_REG_OFFSET(reg)   ((reg) )
#define AOBUS_REG_ADDR(reg)	    (IO_AOBUS_BASE + AOBUS_REG_OFFSET(reg))

#define AO_UART_WFIFO ((0x01 << 10) | (0x30 << 2)) 	///../ucode/c_always_on_pointer.h:89
#define P_AO_UART_WFIFO 		AOBUS_REG_ADDR(AO_UART_WFIFO)
#define AO_UART_RFIFO ((0x01 << 10) | (0x31 << 2)) 	///../ucode/c_always_on_pointer.h:90
#define P_AO_UART_RFIFO 		AOBUS_REG_ADDR(AO_UART_RFIFO)
#define AO_UART_CONTROL ((0x01 << 10) | (0x32 << 2)) 	///../ucode/c_always_on_pointer.h:91
#define P_AO_UART_CONTROL 		AOBUS_REG_ADDR(AO_UART_CONTROL)
#define AO_UART_STATUS ((0x01 << 10) | (0x33 << 2)) 	///../ucode/c_always_on_pointer.h:92
#define P_AO_UART_STATUS 		AOBUS_REG_ADDR(AO_UART_STATUS)
#define AO_UART_MISC ((0x01 << 10) | (0x34 << 2)) 	///../ucode/c_always_on_pointer.h:93
#define P_AO_UART_MISC 		AOBUS_REG_ADDR(AO_UART_MISC)
#define AO_UART_REG5 ((0x01 << 10) | (0x35 << 2)) 	///../ucode/c_always_on_pointer.h:94
#define P_AO_UART_REG5 		AOBUS_REG_ADDR(AO_UART_REG5)
#endif

#endif //__REGISTER_H__
