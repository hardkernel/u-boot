#ifndef __ALWAYS_ON_REGS_H_
#define __ALWAYS_ON_REGS_H_

#define P_AO_RTI_STATUS_REG0	        (0xc8100000)	
#define P_AO_RTI_STATUS_REG1	        (0xc8100004)	
#define P_AO_RTI_STATUS_REG2	        (0xc8100008)	

#define P_AO_RTI_PWR_CNTL_REG0	        (0xc8100010)	
#define P_AO_RTI_PIN_MUX_REG	        (0xc8100014)	

#define P_AO_WD_GPIO_REG	            (0xc8100018)	
#define P_AO_REMAP_REG0	                (0xc810001c)	
#define P_AO_REMAP_REG1	                (0xc8100020)	

#define P_AO_GPIO_O_EN_N	            (0xc8100024)	
#define P_AO_GPIO_I	                    (0xc8100028)	
#define P_AO_RTI_PULL_UP_REG	        (0xc810002c)	

#define P_AO_RTI_WD_MARK	            (0xc8100034)	
#define P_AO_RTI_GEN_CTNL_REG0	        (0xc8100040)	

#define P_AO_WATCHDOG_REG	            (0xc8100044)	
#define P_AO_WATCHDOG_RESET	            (0xc8100048)	

#define P_AO_TIMER_REG	                (0xc810004c)	
#define P_AO_TIMERA_REG	                (0xc8100050)	
#define P_AO_TIMERE_REG	                (0xc8100054)	

#define P_AO_AHB2DDR_CNTL	            (0xc8100060)	

#define P_AO_IRQ_MASK_FIQ_SEL	        (0xc8100080)	
#define P_AO_IRQ_GPIO_REG	            (0xc8100084)	
#define P_AO_IRQ_STAT	                (0xc8100088)	
#define P_AO_IRQ_STAT_CLR	            (0xc810008c)	

#define P_AO_DEBUG_REG0	                (0xc81000a0)	
#define P_AO_DEBUG_REG1	                (0xc81000a4)	
#define P_AO_DEBUG_REG2	                (0xc81000a8)	
#define P_AO_DEBUG_REG3	                (0xc81000ac)
	
// -------------------------------------------------------------------
// BASE #0
// -------------------------------------------------------------------
#define AO_IR_BLASTER_ADDR0         0x30
#define AO_IR_BLASTER_ADDR1         0x31
#define AO_IR_BLASTER_ADDR2         0x32

#define P_AO_CEC_GEN_CNTL           (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x40 << 2))
#define P_AO_CEC_RW_REG             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x41 << 2))
#define P_AO_CEC_INTR_MASKN         (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x42 << 2))
#define P_AO_CEC_INTR_CLR           (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x43 << 2))
#define P_AO_CEC_INTR_STAT          (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x44 << 2))


// -------------------------------------------------------------------
// BASE #1
// -------------------------------------------------------------------
#define P_AO_IR_DEC_LDR_ACTIVE	        (0xc8100480)	
#define P_AO_IR_DEC_LDR_IDLE            (0xc8100484)	
#define P_AO_IR_DEC_LDR_REPEAT          (0xc8100488)	
#define P_AO_IR_DEC_BIT_0               (0xc810048c)	
#define P_AO_IR_DEC_REG0                (0xc8100490)	
#define P_AO_IR_DEC_FRAME               (0xc8100494)	
#define P_AO_IR_DEC_STATUS              (0xc8100498)	
#define P_AO_IR_DEC_REG1                (0xc810049c)
	
// ----------------------------
// UART
// ----------------------------
#define P_AO_UART_WFIFO                 (0xc81004c0)	
#define P_AO_UART_RFIFO                 (0xc81004c4)	
#define P_AO_UART_CONTROL               (0xc81004c8)	
#define P_AO_UART_STATUS                (0xc81004cc)	
#define P_AO_UART_MISC                  (0xc81004d0)	
#define P_AO_UART_REG5                  (0xc81004d4)	

// ----------------------------
// UART2
// ----------------------------
#define P_AO_UART2_WFIFO                (0xc81004e0)
#define P_AO_UART2_RFIFO                (0xc81004e4)
#define P_AO_UART2_CONTROL              (0xc81004e8)
#define P_AO_UART2_STATUS               (0xc81004ec)
#define P_AO_UART2_MISC                 (0xc81004f0)
#define P_AO_UART2_REG5                 (0xc81004f4)

// ----------------------------
// I2C Master (8)
// ----------------------------
#if 0
#define P_AO_I2C_M_0_CONTROL_REG    (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x40 << 2))
#define P_AO_I2C_M_0_SLAVE_ADDR     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x41 << 2))
#define P_AO_I2C_M_0_TOKEN_LIST0    (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x42 << 2))
#define P_AO_I2C_M_0_TOKEN_LIST1    (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x43 << 2))
#define P_AO_I2C_M_0_WDATA_REG0     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x44 << 2))
#define P_AO_I2C_M_0_WDATA_REG1     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x45 << 2))
#define P_AO_I2C_M_0_RDATA_REG0     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x46 << 2))
#define P_AO_I2C_M_0_RDATA_REG1     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x47 << 2))
#endif

#define P_I2C_CONTROL_REG	            (0xc8100500)	
#define P_I2C_SLAVE ADDRESS	            (0xc8100504)	
#define P_I2C_TOKEN_LIST_REG0	        (0xc8100508)	
#define P_I2C_TOKEN_LIST_REG1	        (0xc810050c)	
#define P_I2C_TOKEN_WDATA_REG0	        (0xc8100510)	
#define P_I2C_TOKEN_WDATA_REG1	        (0xc8100514)	
#define P_I2C_TOKEN_RDATA_REG0	        (0xc8100518)	
#define P_I2C_TOKEN_RDATA_REG1	        (0xc810051c)	


#if 0
// ----------------------------
// I2C Slave (3)
// ----------------------------
#define P_AO_I2C_S_CONTROL_REG      (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x50 << 2))
#define P_AO_I2C_S_SEND_REG         (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x51 << 2))
#define P_AO_I2C_S_RECV_REG         (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x52 << 2))
#define P_AO_I2C_S_CNTL1_REG        (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x53 << 2))
#endif

// ---------------------------
// RTC (4)
// ---------------------------
// NOTE:  These are on the Secure APB3  bus
// 
#define P_AO_RTC_ADDR0              (volatile unsigned long *)(0xDA004000 | (0xd0 << 2))
#define P_AO_RTC_ADDR1              (volatile unsigned long *)(0xDA004000 | (0xd1 << 2))
#define P_AO_RTC_ADDR2              (volatile unsigned long *)(0xDA004000 | (0xd2 << 2))
#define P_AO_RTC_ADDR3              (volatile unsigned long *)(0xDA004000 | (0xd3 << 2))
#define P_AO_RTC_ADDR4              (volatile unsigned long *)(0xDA004000 | (0xd4 << 2))

#endif
