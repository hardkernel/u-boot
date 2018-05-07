
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
#define IRQ_AO_UART_NUM     1
#define IRQ_AO_I2C_S_NUM    2
#define IRQ_AO_I2C_M_NUM    3
#define IRQ_AO_IR_DEC_NUM   4
#define IRQ_AO_UART2_NUM    5
#define IRQ_AO_IR_BLST_NUM  6
#define IRQ_AO_CEC1_NUM     7
#define IRQ_SAR_ADC_NUM     8
#define IRQ_AO_I2C_TO_NUM   9
#define IRQ_AO_WD_NUM       10
#define IRQ_AO_CEC2_NUM     11
#define IRQ_AO_TIMERA_NUM   12
#define IRQ_AO_TIMERB_NUM   13
#define IRQ_AO_GPIO0_NUM    14
#define IRQ_AO_GPIO1_NUM    15
#define IRQ_JTGPWD_SCP_NUM  16

#define IRQ_AO_MBOX0_RECV_NUM  17
#define IRQ_AO_MBOX1_RECV_NUM  18
#define IRQ_AO_MBOX2_RECV_NUM  19
#define IRQ_AO_MBOX3_RECV_NUM  20
#define IRQ_AO_MBOX0_SEND_NUM  21
#define IRQ_AO_MBOX1_SEND_NUM  22
#define IRQ_AO_MBOX2_SEND_NUM  23
#define IRQ_AO_MBOX3_SEND_NUM  24
#define IRQ_AO_TIMERC_NUM      25

#define IRQ_STB_WFI0_NUM      28
#define IRQ_STB_WFI1_NUM      29
#define IRQ_STB_WFI2_NUM      30
#define IRQ_STB_WFI3_NUM      31
#define IRQ_FIQ0_NUM      32
#define IRQ_FIQ1_NUM      33
#define IRQ_FIQ2_NUM      34
#define IRQ_FIQ3_NUM      35
#define IRQ_STB_WFI_L2_NUM    36
#define IRQ_L2_FL_DWN_NUM     37
#define IRQ_IRQ0_NUM      38
#define IRQ_IRQ1_NUM      39
#define IRQ_IRQ2_NUM      40
#define IRQ_IRQ3_NUM      41

#define IRQ_TIMERI_NUM    42
#define IRQ_TIMERH_NUM    43
#define IRQ_TIMERG_NUM    44
#define IRQ_TIMERF_NUM    45

#define IRQ_TIMERD_NUM    47
#define IRQ_TIMERC_NUM    48
#define IRQ_TIMERB_NUM    49
#define IRQ_TIMERA_NUM    50
#define IRQ_DMA_IRQ0_NUM  51
#define IRQ_DMA_IRQ1_NUM  52
#define IRQ_DMA_IRQ2_NUM  53
#define IRQ_DMA_IRQ3_NUM  54
#define IRQ_DMA_IRQ4_NUM  55
#define IRQ_DMA_IRQ5_NUM  56

#define IRQ_AUDIO_IRQ0_NUM    57
#define IRQ_AUDIO_IRQ1_NUM    58
#define IRQ_AUDIO_IRQ2_NUM    59
#define IRQ_AUDIO_IRQ3_NUM    60
#define IRQ_AUDIO_IRQ4_NUM    61
#define IRQ_AUDIO_IRQ5_NUM    62
#define IRQ_AUDIO_IRQ6_NUM    63
#define IRQ_AUDIO_IRQ7_NUM    64
#define IRQ_AUDIO_IRQ8_NUM    65
#define IRQ_AUDIO_IRQ9_NUM    66
#define IRQ_DMC_TEST_NUM  67

#define IRQ_MBOX0_SEND_NUM  68
#define IRQ_MBOX1_SEND_NUM  69
#define IRQ_MBOX2_SEND_NUM  70
#define IRQ_MBOX3_RECV_NUM  71
#define IRQ_MBOX4_RECV_NUM  72
#define IRQ_MBOX5_RECV_NUM  73
#define IRQ_GPIO0_NUM    74
#define IRQ_GPIO1_NUM    75
#define IRQ_GPIO2_NUM    76
#define IRQ_GPIO3_NUM    77

#define IRQ_VIU1_VSYNC_NUM  78
#define IRQ_VIU1_LINE_NUM   79
#define IRQ_ETH_PMT_NUM     80
#define IRQ_ETH_GMAC_NUM    81
#define IRQ_ETH_PHY_NUM     82
#define IRQ_ETH_LIP_NUM     83

#define IRQ_DOLBY_NUM       84
#define IRQ_MALI_AFBC_NUM   85
#define IRQ_ASIT_MBOX0_NUM  86
#define IRQ_ASIT_MBOX1_NUM  87
#define IRQ_ASIT_MBOX2_NUM  88
#define IRQ_ASIT_MBOX3_NUM  89
#define IRQ_MBOX7_SEND_NUM  90
#define IRQ_MBOX6_RECV_NUM  91

#endif				//_SCP_REGISTER_DEFINES_
