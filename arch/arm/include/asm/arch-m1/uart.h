/*
 *  Copyright (C) 2010 AMLOGIC, INC.
 *
 *  Y:\arch\arm\include\asm\arch-m1\serial.h
 * 
 *
 * License terms: GNU General Public License (GPL) version 2
 * Basic register address definitions in physical memory and
 * some block defintions for core devices like the timer.
 * 03/06/10
 *
 * author : jerry.yu
 */
#ifndef __MESON_FIRM_UART_H_
#define __MESON_FIRM_UART_H_
#include "registers.h"
#ifndef CONFIG_CONS_INDEX
#error Please define CONFIG_CONS_INDEX==[0|1]
#endif
#if CONFIG_CONS_INDEX==0
#define UART_PORT_CONS UART_PORT_0
#elif CONFIG_CONS_INDEX==1
#define UART_PORT_CONS UART_PORT_1
#else
#error Please define CONFIG_CONS_INDEX==[0|1]
#endif
#include "clock.h"
#define UART_CLK_SRC CLK_CLK81
#define UART_PORT_0 UART0_WFIFO
#define UART_PORT_1 UART1_WFIFO
#define UART_WFIFO      0
#define UART_RFIFO      1
#define UART_CONTROL    2
#define UART_STATUS     3
#define UART_MISC       4


#define P_UART(uart_base,reg)    	CBUS_REG_ADDR(uart_base+reg)
#define P_UART_WFIFO(uart_base)   	P_UART(uart_base,UART_WFIFO)
#define P_UART_RFIFO(uart_base)   	P_UART(uart_base,UART_RFIFO)

#define P_UART_CONTROL(uart_base)    P_UART(uart_base,UART_CONTROL)
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
#define P_UART_STATUS(uart_base)  P_UART(uart_base,UART_STATUS )
    #define UART_STAT_MASK_RFIFO_CNT                (0x7f<<0)
    #define UART_STAT_MASK_TFIFO_CNT                (0x7f<<8)
    #define UART_STAT_MASK_PRTY_ERR                 (1<<16)
    #define UART_STAT_MASK_FRAM_ERR                 (1<<17)
    #define UART_STAT_MASK_WFULL_ERR                (1<<18)
    #define UART_STAT_MASK_RFIFO_FULL               (1<<19)
    #define UART_STAT_MASK_RFIFO_EMPTY              (1<<20)
    #define UART_STAT_MASK_TFIFO_FULL               (1<<21)
    #define UART_STAT_MASK_TFIFO_EMPTY              (1<<22)
#define P_UART_MISC(uart_base)    P_UART(uart_base,UART_MISC   )

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
#define UART_CONTROL_SET(baud,clk81)                        \
                        (((clk81)/(baud*4) -1)              \
                        | UART_STP_BIT                      \
                        | UART_PRTY_BIT                     \
                        | UART_CHAR_LEN                     \
                        | UART_CNTL_MASK_TX_EN              \
                        | UART_CNTL_MASK_RX_EN              \
                        | UART_CNTL_MASK_RST_TX             \
                        | UART_CNTL_MASK_RST_RX             \
                        | UART_CNTL_MASK_CLR_ERR    )
#endif
