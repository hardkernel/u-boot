/*
 * arch/arm/include/asm/arch-gxtvbb/uart_va.h
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

#ifndef __UART_V1_H__
#define __UART_V1_H__

#include <config.h>
#include <common.h>

#include "clock.h"
#define UART_CLK_SRC    CLK81

enum uart_channel {
	   UART_A = 0,
	   UART_B,
	   UART_C,
	   UART_D,
	   UART_AO_A,
	   UART_AO_B,
};

#define CHAR_ZERO								0X30
#define CHAR_LOWER_A							0x61

#define UART_CNTL_MASK_BAUD_RATE                (0xfff)
#define UART_CNTL_MASK_TX_EN                    (1<<12)
#define UART_CNTL_MASK_RX_EN                    (1<<13)
#define UART_CNTL_MASK_2WIRE                    (1<<15)
#define UART_CNTL_MASK_STP_BITS                 (3<<16)
#define UART_CNTL_MASK_STP_1BIT                 (0<<16)
#define UART_CNTL_MASK_STP_2BIT                 (1<<16)
#define UART_CNTL_MASK_PRTY_EVEN                (0<<18)
#define UART_CNTL_MASK_PRTY_ODD                 (1<<18)
#define UART_CNTL_MASK_PRTY_TYPE                (1<<18)
#define UART_CNTL_MASK_PRTY_EN                  (1<<19)
#define UART_CNTL_MASK_CHAR_LEN                 (3<<20)
#define UART_CNTL_MASK_CHAR_8BIT                (0<<20)
#define UART_CNTL_MASK_CHAR_7BIT                (1<<20)
#define UART_CNTL_MASK_CHAR_6BIT                (2<<20)
#define UART_CNTL_MASK_CHAR_5BIT                (3<<20)
#define UART_CNTL_MASK_RST_TX                   (1<<22)
#define UART_CNTL_MASK_RST_RX                   (1<<23)
#define UART_CNTL_MASK_CLR_ERR                  (1<<24)
#define UART_CNTL_MASK_INV_RX                   (1<<25)
#define UART_CNTL_MASK_INV_TX                   (1<<26)
#define UART_CNTL_MASK_RINT_EN                  (1<<27)
#define UART_CNTL_MASK_TINT_EN                  (1<<28)
#define UART_CNTL_MASK_INV_CTS                  (1<<29)
#define UART_CNTL_MASK_MASK_ERR                 (1<<30)
#define UART_CNTL_MASK_INV_RTS                  (1<<31)

#define UART_STAT_MASK_RFIFO_CNT                (0x7f<<0)
#define UART_STAT_MASK_TFIFO_CNT                (0x7f<<8)
#define UART_STAT_MASK_PRTY_ERR                 (1<<16)
#define UART_STAT_MASK_FRAM_ERR                 (1<<17)
#define UART_STAT_MASK_WFULL_ERR                (1<<18)
#define UART_STAT_MASK_RFIFO_FULL               (1<<19)
#define UART_STAT_MASK_RFIFO_EMPTY              (1<<20)
#define UART_STAT_MASK_TFIFO_FULL               (1<<21)
#define UART_STAT_MASK_TFIFO_EMPTY              (1<<22)
#define UART_STAT_MASK_XMIT_BUSY				(1<<25)
#define UART_STAT_MASK_RECV_BUSY				(1<<26)



#ifndef CONFIG_SERIAL_STP_BITS
#define CONFIG_SERIAL_STP_BITS 1 // 1 , 2
#endif
#if CONFIG_SERIAL_STP_BITS==1
#define UART_STP_BIT UART_CNTL_MASK_STP_1BIT
#elif CONFIG_SERIAL_STP_BITS==2
#define UART_STP_BIT UART_CNTL_MASK_STP_2BIT
#else
#error CONFIG_SERIAL_STP_BITS wrong
#endif

#ifndef CONFIG_SERIAL_PRTY_TYPE
#define CONFIG_SERIAL_PRTY_TYPE 0 //0 ,2 ,3
#endif
#if CONFIG_SERIAL_PRTY_TYPE==0
#define UART_PRTY_BIT 0
#elif CONFIG_SERIAL_PRTY_TYPE==2
#define UART_PRTY_BIT    (UART_CNTL_MASK_PRTY_EN|UART_CNTL_MASK_PRTY_EVEN)
#elif CONFIG_SERIAL_PRTY_TYPE==3
#define UART_PRTY_BIT    (UART_CNTL_MASK_PRTY_EN|UART_CNTL_MASK_PRTY_ODD)
#else
#error CONFIG_SERIAL_PRTY_TYPE wrong
#endif

#ifndef CONFIG_SERIAL_CHAR_LEN
#define CONFIG_SERIAL_CHAR_LEN 8 //5,6,7,8
#endif
#if CONFIG_SERIAL_CHAR_LEN==5
#define UART_CHAR_LEN   UART_CNTL_MASK_CHAR_5BIT
#elif CONFIG_SERIAL_CHAR_LEN==6
#define UART_CHAR_LEN   UART_CNTL_MASK_CHAR_6BIT
#elif CONFIG_SERIAL_CHAR_LEN==7
#define UART_CHAR_LEN   UART_CNTL_MASK_CHAR_7BIT
#elif CONFIG_SERIAL_CHAR_LEN==8
#define UART_CHAR_LEN   UART_CNTL_MASK_CHAR_8BIT
#else
#error CONFIG_SERIAL_CHAR_LEN wrong
#endif


/* below UART0,UART1,AO_UART is gxtvbb addr*/

/*-------------------------------
*	general uart
* -------------------------------*/

#define IO_BUS_BASE									0xc1100000

/*-------------------------------
*	UART0
* -------------------------------*/
#define UARTA_WFIFO                                (0x2130 << 2)
#define UARTA_RFIFO                                (0x2131 << 2)
#define UARTA_CONTROL                              (0x2132 << 2)
#define UARTA_STATUS                               (0x2133 << 2)
#define UARTA_MISC                                 (0x2134 << 2)
#define UARTA_REG5                                 (0x2135 << 2)
/* ----------------------------
* 	UART1
*----------------------------*/
#define UARTB_WFIFO                                (0x2137 << 2)
#define UARTB_RFIFO                                (0x2138 << 2)
#define UARTB_CONTROL                              (0x2139 << 2)
#define UARTB_STATUS                               (0x213a << 2)
#define UARTB_MISC                                 (0x213b << 2)
#define UARTB_REG5                                 (0x213c << 2)

/* ----------------------------
* 	UART2
*----------------------------*/
#define UARTC_WFIFO                                (0x21c0 << 2)
#define UARTC_RFIFO                                (0x21c1 << 2)
#define UARTC_CONTROL                              (0x21c2 << 2)
#define UARTC_STATUS                               (0x21c3 << 2)
#define UARTC_MISC                                 (0x21c4 << 2)
#define UARTC_REG5                                 (0x21c5 << 2)


/* --------------------------------
 *  AO uart
 * -------------------------------*/
#define IO_AOBUS_BASE       						0xc8100000

/*-------------------------------
*	UARTAO_A
* -------------------------------*/


#define AO_UARTA_WFIFO 					((0x01 << 10) | (0x30 << 2))
#define AO_UARTA_RFIFO					((0x01 << 10) | (0x31 << 2))
#define AO_UARTA_CONTROL 				((0x01 << 10) | (0x32 << 2))
#define AO_UARTA_STATUS 				((0x01 << 10) | (0x33 << 2))
#define AO_UARTA_MISC					((0x01 << 10) | (0x34 << 2))
#define AO_UARTA_REG5					((0x01 << 10) | (0x35 << 2))

/*-------------------------------
*	UARTAO_B
* -------------------------------*/
#define AO_UARTB_WFIFO					((0x01 << 10) | (0x38 << 2))
#define AO_UARTB_RFIFO					((0x01 << 10) | (0x39 << 2))
#define AO_UARTB_CONTROL				((0x01 << 10) | (0x3a << 2))
#define AO_UARTB_STATUS 				((0x01 << 10) | (0x3b << 2))
#define AO_UARTB_MISC 					((0x01 << 10) | (0x3c << 2))
#define AO_UARTB_REG5 					((0x01 << 10) | (0x3d << 2))


void serial_init_uart(unsigned set, unsigned channel);

void serial_putc_uart(const char c ,unsigned channel);

void serial_wait_tx_empty_uart(unsigned channel);

void serial_tstc_uart(unsigned channel);

int serial_getc_uart(unsigned channel);

void serial_puts_uart(const char *s, unsigned channel);

void serial_put_hex_uart(unsigned int data,
						unsigned bitlen, unsigned channel);

void serial_put_dec_uart(unsigned int data, unsigned channel);

#endif //__UART_V1_H__
