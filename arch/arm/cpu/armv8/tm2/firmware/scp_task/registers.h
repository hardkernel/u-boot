
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/registers.h
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

#ifndef _SCP_REGISTER_DEFINES_
#define _SCP_REGISTER_DEFINES_
#include "secure_apb.h"

/* CBUS Registers */
 /*TIMER*/
#define P_ISA_TIMER_MUX                              ISA_TIMER_MUX
#define P_ISA_TIMERA                                 ISA_TIMERA
#define P_ISA_TIMERB                                 ISA_TIMERB
#define P_ISA_TIMERC                                 ISA_TIMERC
#define P_ISA_TIMERD                                 ISA_TIMERD
#define P_ISA_TIMERE                                 ISA_TIMERE
#define P_ISA_TIMERE_HI                              ISA_TIMERE_HI
#define P_ISA_TIMER_MUX1                             ISA_TIMER_MUX1
#define P_ISA_TIMERF                                 ISA_TIMERF
#define P_ISA_TIMERG                                 ISA_TIMERG
#define P_ISA_TIMERH                                 ISA_TIMERH
#define P_ISA_TIMERI                                 ISA_TIMERI
/* 80K share SRAM base address, g12 is not 80k*/
#define P_SHARE_SRAM_BASE	0xfffa0000
/*Interrupt number list*/
#define IRQ_SW_INT_NUM      1
#define IRQ_TMR_INT_NUM     2
#define IRQ_AO_UART_NUM     4
#define IRQ_AO_I2C_S_NUM    5

#define IRQ_AO_I2C_M_NUM    6
#define IRQ_AO_IR_DEC_NUM   7
#define IRQ_AO_UART2_NUM    8
#define IRQ_AO_IR_BLST_NUM  9
#define IRQ_AO_CEC1_NUM     10
#define IRQ_SAR_ADC_NUM     11
#define IRQ_AO_I2C_TO_NUM   12
#define IRQ_AO_WD_NUM       13
#define IRQ_AO_CEC2_NUM     14
#define IRQ_AO_TIMERA_NUM   15
#define IRQ_AO_TIMERB_NUM   16
#define IRQ_AO_GPIO0_NUM    17
#define IRQ_AO_GPIO1_NUM    18
#define IRQ_JTGPWD_SCP_NUM  19

#define IRQ_AO_MBOX0_RECV_NUM  20
#define IRQ_AO_MBOX1_RECV_NUM  21
#define IRQ_AO_MBOX2_RECV_NUM  22
#define IRQ_AO_MBOX3_RECV_NUM  23
#define IRQ_AO_MBOX0_SEND_NUM  24
#define IRQ_AO_MBOX1_SEND_NUM  25
#define IRQ_AO_MBOX2_SEND_NUM  26
#define IRQ_AO_MBOX3_SEND_NUM  27
#define IRQ_AO_TIMERC_NUM      28

#define IRQ_FIQ0_NUM      35
#define IRQ_FIQ1_NUM      36
#define IRQ_FIQ2_NUM      37
#define IRQ_FIQ3_NUM      38
#define IRQ_STB_WFI_L2_NUM    39
#define IRQ_L2_FL_DWN_NUM     40
#define IRQ_IRQ0_NUM      41
#define IRQ_IRQ1_NUM      42
#define IRQ_IRQ2_NUM      43
#define IRQ_IRQ3_NUM      44

#define IRQ_TIMERI_NUM    45
#define IRQ_TIMERH_NUM    46
#define IRQ_TIMERG_NUM    47
#define IRQ_TIMERF_NUM    48

#define IRQ_TIMERD_NUM    50
#define IRQ_TIMERC_NUM    51
#define IRQ_TIMERB_NUM    52
#define IRQ_TIMERA_NUM    53
#define IRQ_DMA_IRQ0_NUM  54
#define IRQ_DMA_IRQ1_NUM  55
#define IRQ_DMA_IRQ2_NUM  56
#define IRQ_DMA_IRQ3_NUM  57
#define IRQ_DMA_IRQ4_NUM  58
#define IRQ_DMA_IRQ5_NUM  59
#define IRQ_DMA_TEST_NUM  60

#define IRQ_MBOX0_SEND_NUM    61
#define IRQ_MBOX1_SEND_NUM    62
#define IRQ_MBOX2_SEND_NUM    63
#define IRQ_MBOX3_RECV_NUM    64
#define IRQ_MBOX4_RECV_NUM    65
#define IRQ_MBOX5_RECV_NUM    66

#define IRQ_GPIO_NOW_0_NUM    67
#define IRQ_GPIO_NOW_1_NUM    68
#define IRQ_GPIO_NOW_2_NUM    69
#define IRQ_GPIO_NOW_3_NUM    70

#define IRQ_VIU1_VSYNC_NUM  71
#define IRQ_VIU1_LINE_NUM   72
#define IRQ_ETH_PMT_NUM     73
#define IRQ_ETH_GMAC_NUM    74
#define IRQ_ETH_PHY_NUM     75
#define IRQ_ETH_LIP_NUM     76

#define IRQ_DOLBY_NUM       77
#define IRQ_MALI_AFBC_NUM   78

#define IRQ_ASIT_MBOX0_NUM  79
#define IRQ_ASIT_MBOX1_NUM  80
#define IRQ_ASIT_MBOX2_NUM  81
#define IRQ_ASIT_MBOX3_NUM  82
#define IRQ_MBOX7_SEND_NUM  83
#define IRQ_MBOX6_RECV_NUM  84

#define IRQ_MBOX0_CPUA_NUM 85
#define IRQ_MBOX1_CPUA_NUM 86
#define IRQ_MBOX2_CPUA_NUM 87
#define IRQ_MBOX3_CPUA_NUM 88
#define IRQ_MBOX4_CPUA_NUM 89
#define IRQ_MBOX5_CPUA_NUM 90
#define IRQ_MBOX6_CPUA_NUM 91
#define IRQ_MBOX7_CPUA_NUM 92
#define IRQ_MBOX8_CPUA_NUM 93
#define IRQ_MBOX9_CPUA_NUM 94
#define IRQ_MBOX10_CPUA_NUM 95
#define IRQ_MBOX11_CPUA_NUM 96


#endif				//_SCP_REGISTER_DEFINES_
