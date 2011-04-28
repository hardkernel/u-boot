#ifndef __ALWAYS_ON_REGS_H_
#define __ALWAYS_ON_REGS_H_



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



#define IO_AOBUS_BASE       0xc8100000  ///1M

#define AOBUS_REG_OFFSET(reg)   ((reg) )
#define AOBUS_REG_ADDR(reg)	    (IO_AOBUS_BASE + AOBUS_REG_OFFSET(reg))

#define AO_RTI_STATUS_REG0 ((0x00 << 10) | (0x00 << 2)) 	///../ucode/c_always_on_pointer.h:13
#define P_AO_RTI_STATUS_REG0 		AOBUS_REG_ADDR(AO_RTI_STATUS_REG0)
#define AO_RTI_STATUS_REG1 ((0x00 << 10) | (0x01 << 2)) 	///../ucode/c_always_on_pointer.h:14
#define P_AO_RTI_STATUS_REG1 		AOBUS_REG_ADDR(AO_RTI_STATUS_REG1)
#define AO_RTI_STATUS_REG2 ((0x00 << 10) | (0x02 << 2)) 	///../ucode/c_always_on_pointer.h:15
#define P_AO_RTI_STATUS_REG2 		AOBUS_REG_ADDR(AO_RTI_STATUS_REG2)
#define AO_RTI_PWR_CNTL_REG1 ((0x00 << 10) | (0x03 << 2)) 	///../ucode/c_always_on_pointer.h:17
#define P_AO_RTI_PWR_CNTL_REG1 		AOBUS_REG_ADDR(AO_RTI_PWR_CNTL_REG1)
#define AO_RTI_PWR_CNTL_REG0 ((0x00 << 10) | (0x04 << 2)) 	///../ucode/c_always_on_pointer.h:18
#define P_AO_RTI_PWR_CNTL_REG0 		AOBUS_REG_ADDR(AO_RTI_PWR_CNTL_REG0)
#define AO_RTI_PIN_MUX_REG ((0x00 << 10) | (0x05 << 2)) 	///../ucode/c_always_on_pointer.h:19
#define P_AO_RTI_PIN_MUX_REG 		AOBUS_REG_ADDR(AO_RTI_PIN_MUX_REG)
#define AO_WD_GPIO_REG ((0x00 << 10) | (0x06 << 2)) 	///../ucode/c_always_on_pointer.h:21
#define P_AO_WD_GPIO_REG 		AOBUS_REG_ADDR(AO_WD_GPIO_REG)
#define AO_REMAP_REG0 ((0x00 << 10) | (0x07 << 2)) 	///../ucode/c_always_on_pointer.h:23
#define P_AO_REMAP_REG0 		AOBUS_REG_ADDR(AO_REMAP_REG0)
#define AO_REMAP_REG1 ((0x00 << 10) | (0x08 << 2)) 	///../ucode/c_always_on_pointer.h:24
#define P_AO_REMAP_REG1 		AOBUS_REG_ADDR(AO_REMAP_REG1)
#define AO_GPIO_O_EN_N ((0x00 << 10) | (0x09 << 2)) 	///../ucode/c_always_on_pointer.h:25
#define P_AO_GPIO_O_EN_N 		AOBUS_REG_ADDR(AO_GPIO_O_EN_N)
#define AO_GPIO_I ((0x00 << 10) | (0x0A << 2)) 	///../ucode/c_always_on_pointer.h:26
#define P_AO_GPIO_I 		AOBUS_REG_ADDR(AO_GPIO_I)
#define AO_RTI_PULL_UP_REG ((0x00 << 10) | (0x0B << 2)) 	///../ucode/c_always_on_pointer.h:28
#define P_AO_RTI_PULL_UP_REG 		AOBUS_REG_ADDR(AO_RTI_PULL_UP_REG)
#define AO_RTI_WD_MARK ((0x00 << 10) | (0x0D << 2)) 	///../ucode/c_always_on_pointer.h:31
#define P_AO_RTI_WD_MARK 		AOBUS_REG_ADDR(AO_RTI_WD_MARK)
#define AO_CPU_CNTL ((0x00 << 10) | (0x0E << 2)) 	///../ucode/c_always_on_pointer.h:33
#define P_AO_CPU_CNTL 		AOBUS_REG_ADDR(AO_CPU_CNTL)
#define AO_CPU_STAT ((0x00 << 10) | (0x0F << 2)) 	///../ucode/c_always_on_pointer.h:35
#define P_AO_CPU_STAT 		AOBUS_REG_ADDR(AO_CPU_STAT)
#define AO_RTI_GEN_CNTL_REG0 ((0x00 << 10) | (0x10 << 2)) 	///../ucode/c_always_on_pointer.h:38
#define P_AO_RTI_GEN_CNTL_REG0 		AOBUS_REG_ADDR(AO_RTI_GEN_CNTL_REG0)
#define AO_WATCHDOG_REG ((0x00 << 10) | (0x11 << 2)) 	///../ucode/c_always_on_pointer.h:39
#define P_AO_WATCHDOG_REG 		AOBUS_REG_ADDR(AO_WATCHDOG_REG)
#define AO_WATCHDOG_RESET ((0x00 << 10) | (0x12 << 2)) 	///../ucode/c_always_on_pointer.h:40
#define P_AO_WATCHDOG_RESET 		AOBUS_REG_ADDR(AO_WATCHDOG_RESET)
#define AO_TIMER_REG ((0x00 << 10) | (0x13 << 2)) 	///../ucode/c_always_on_pointer.h:42
#define P_AO_TIMER_REG 		AOBUS_REG_ADDR(AO_TIMER_REG)
#define AO_TIMERA_REG ((0x00 << 10) | (0x14 << 2)) 	///../ucode/c_always_on_pointer.h:43
#define P_AO_TIMERA_REG 		AOBUS_REG_ADDR(AO_TIMERA_REG)
#define AO_TIMERE_REG ((0x00 << 10) | (0x15 << 2)) 	///../ucode/c_always_on_pointer.h:44
#define P_AO_TIMERE_REG 		AOBUS_REG_ADDR(AO_TIMERE_REG)
#define AO_AHB2DDR_CNTL ((0x00 << 10) | (0x18 << 2)) 	///../ucode/c_always_on_pointer.h:46
#define P_AO_AHB2DDR_CNTL 		AOBUS_REG_ADDR(AO_AHB2DDR_CNTL)
#define AO_IRQ_MASK_FIQ_SEL ((0x00 << 10) | (0x20 << 2)) 	///../ucode/c_always_on_pointer.h:48
#define P_AO_IRQ_MASK_FIQ_SEL 		AOBUS_REG_ADDR(AO_IRQ_MASK_FIQ_SEL)
#define AO_IRQ_GPIO_REG ((0x00 << 10) | (0x21 << 2)) 	///../ucode/c_always_on_pointer.h:49
#define P_AO_IRQ_GPIO_REG 		AOBUS_REG_ADDR(AO_IRQ_GPIO_REG)
#define AO_IRQ_STAT ((0x00 << 10) | (0x22 << 2)) 	///../ucode/c_always_on_pointer.h:50
#define P_AO_IRQ_STAT 		AOBUS_REG_ADDR(AO_IRQ_STAT)
#define AO_IRQ_STAT_CLR ((0x00 << 10) | (0x23 << 2)) 	///../ucode/c_always_on_pointer.h:51
#define P_AO_IRQ_STAT_CLR 		AOBUS_REG_ADDR(AO_IRQ_STAT_CLR)
#define AO_DEBUG_REG0 ((0x00 << 10) | (0x28 << 2)) 	///../ucode/c_always_on_pointer.h:53
#define P_AO_DEBUG_REG0 		AOBUS_REG_ADDR(AO_DEBUG_REG0)
#define AO_DEBUG_REG1 ((0x00 << 10) | (0x29 << 2)) 	///../ucode/c_always_on_pointer.h:54
#define P_AO_DEBUG_REG1 		AOBUS_REG_ADDR(AO_DEBUG_REG1)
#define AO_DEBUG_REG2 ((0x00 << 10) | (0x2a << 2)) 	///../ucode/c_always_on_pointer.h:55
#define P_AO_DEBUG_REG2 		AOBUS_REG_ADDR(AO_DEBUG_REG2)
#define AO_DEBUG_REG3 ((0x00 << 10) | (0x2b << 2)) 	///../ucode/c_always_on_pointer.h:56
#define P_AO_DEBUG_REG3 		AOBUS_REG_ADDR(AO_DEBUG_REG3)
#define AO_IR_BLASTER_ADDR0 ((0x00 << 10) | (0x30 << 2)) 	///../ucode/c_always_on_pointer.h:58
#define P_AO_IR_BLASTER_ADDR0 		AOBUS_REG_ADDR(AO_IR_BLASTER_ADDR0)
#define AO_IR_BLASTER_ADDR1 ((0x00 << 10) | (0x31 << 2)) 	///../ucode/c_always_on_pointer.h:59
#define P_AO_IR_BLASTER_ADDR1 		AOBUS_REG_ADDR(AO_IR_BLASTER_ADDR1)
#define AO_IR_BLASTER_ADDR2 ((0x00 << 10) | (0x32 << 2)) 	///../ucode/c_always_on_pointer.h:60
#define P_AO_IR_BLASTER_ADDR2 		AOBUS_REG_ADDR(AO_IR_BLASTER_ADDR2)
#define AO_RTI_PWR_A9_CNTL0 ((0x00 << 10) | (0x38 << 2)) 	///../ucode/c_always_on_pointer.h:63
#define P_AO_RTI_PWR_A9_CNTL0 		AOBUS_REG_ADDR(AO_RTI_PWR_A9_CNTL0)
#define AO_RTI_PWR_A9_CNTL1 ((0x00 << 10) | (0x39 << 2)) 	///../ucode/c_always_on_pointer.h:64
#define P_AO_RTI_PWR_A9_CNTL1 		AOBUS_REG_ADDR(AO_RTI_PWR_A9_CNTL1)
#define AO_RTI_GEN_PWR_SLEEP0 ((0x00 << 10) | (0x3a << 2)) 	///../ucode/c_always_on_pointer.h:65
#define P_AO_RTI_GEN_PWR_SLEEP0 		AOBUS_REG_ADDR(AO_RTI_GEN_PWR_SLEEP0)
#define AO_RTI_GEN_PWR_ISO0 ((0x00 << 10) | (0x3b << 2)) 	///../ucode/c_always_on_pointer.h:66
#define P_AO_RTI_GEN_PWR_ISO0 		AOBUS_REG_ADDR(AO_RTI_GEN_PWR_ISO0)
#define AO_CEC_GEN_CNTL ((0x00 << 10) | (0x40 << 2)) 	///../ucode/c_always_on_pointer.h:68
#define P_AO_CEC_GEN_CNTL 		AOBUS_REG_ADDR(AO_CEC_GEN_CNTL)
#define AO_CEC_RW_REG ((0x00 << 10) | (0x41 << 2)) 	///../ucode/c_always_on_pointer.h:69
#define P_AO_CEC_RW_REG 		AOBUS_REG_ADDR(AO_CEC_RW_REG)
#define AO_CEC_INTR_MASKN ((0x00 << 10) | (0x42 << 2)) 	///../ucode/c_always_on_pointer.h:70
#define P_AO_CEC_INTR_MASKN 		AOBUS_REG_ADDR(AO_CEC_INTR_MASKN)
#define AO_CEC_INTR_CLR ((0x00 << 10) | (0x43 << 2)) 	///../ucode/c_always_on_pointer.h:71
#define P_AO_CEC_INTR_CLR 		AOBUS_REG_ADDR(AO_CEC_INTR_CLR)
#define AO_CEC_INTR_STAT ((0x00 << 10) | (0x44 << 2)) 	///../ucode/c_always_on_pointer.h:72
#define P_AO_CEC_INTR_STAT 		AOBUS_REG_ADDR(AO_CEC_INTR_STAT)
#define AO_IR_DEC_LDR_ACTIVE ((0x01 << 10) | (0x20 << 2)) 	///../ucode/c_always_on_pointer.h:77
#define P_AO_IR_DEC_LDR_ACTIVE 		AOBUS_REG_ADDR(AO_IR_DEC_LDR_ACTIVE)
#define AO_IR_DEC_LDR_IDLE ((0x01 << 10) | (0x21 << 2)) 	///../ucode/c_always_on_pointer.h:78
#define P_AO_IR_DEC_LDR_IDLE 		AOBUS_REG_ADDR(AO_IR_DEC_LDR_IDLE)
#define AO_IR_DEC_LDR_REPEAT ((0x01 << 10) | (0x22 << 2)) 	///../ucode/c_always_on_pointer.h:79
#define P_AO_IR_DEC_LDR_REPEAT 		AOBUS_REG_ADDR(AO_IR_DEC_LDR_REPEAT)
#define AO_IR_DEC_BIT_0 ((0x01 << 10) | (0x23 << 2)) 	///../ucode/c_always_on_pointer.h:80
#define P_AO_IR_DEC_BIT_0 		AOBUS_REG_ADDR(AO_IR_DEC_BIT_0)
#define AO_IR_DEC_REG0 ((0x01 << 10) | (0x24 << 2)) 	///../ucode/c_always_on_pointer.h:81
#define P_AO_IR_DEC_REG0 		AOBUS_REG_ADDR(AO_IR_DEC_REG0)
#define AO_IR_DEC_FRAME ((0x01 << 10) | (0x25 << 2)) 	///../ucode/c_always_on_pointer.h:82
#define P_AO_IR_DEC_FRAME 		AOBUS_REG_ADDR(AO_IR_DEC_FRAME)
#define AO_IR_DEC_STATUS ((0x01 << 10) | (0x26 << 2)) 	///../ucode/c_always_on_pointer.h:83
#define P_AO_IR_DEC_STATUS 		AOBUS_REG_ADDR(AO_IR_DEC_STATUS)
#define AO_IR_DEC_REG1 ((0x01 << 10) | (0x27 << 2)) 	///../ucode/c_always_on_pointer.h:84
#define P_AO_IR_DEC_REG1 		AOBUS_REG_ADDR(AO_IR_DEC_REG1)
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
#define AO_UART2_WFIFO ((0x01 << 10) | (0x38 << 2)) 	///../ucode/c_always_on_pointer.h:99
#define P_AO_UART2_WFIFO 		AOBUS_REG_ADDR(AO_UART2_WFIFO)
#define AO_UART2_RFIFO ((0x01 << 10) | (0x39 << 2)) 	///../ucode/c_always_on_pointer.h:100
#define P_AO_UART2_RFIFO 		AOBUS_REG_ADDR(AO_UART2_RFIFO)
#define AO_UART2_CONTROL ((0x01 << 10) | (0x3a << 2)) 	///../ucode/c_always_on_pointer.h:101
#define P_AO_UART2_CONTROL 		AOBUS_REG_ADDR(AO_UART2_CONTROL)
#define AO_UART2_STATUS ((0x01 << 10) | (0x3b << 2)) 	///../ucode/c_always_on_pointer.h:102
#define P_AO_UART2_STATUS 		AOBUS_REG_ADDR(AO_UART2_STATUS)
#define AO_UART2_MISC ((0x01 << 10) | (0x3c << 2)) 	///../ucode/c_always_on_pointer.h:103
#define P_AO_UART2_MISC 		AOBUS_REG_ADDR(AO_UART2_MISC)
#define AO_UART2_REG5 ((0x01 << 10) | (0x3d << 2)) 	///../ucode/c_always_on_pointer.h:104
#define P_AO_UART2_REG5 		AOBUS_REG_ADDR(AO_UART2_REG5)
#define AO_I2C_M_0_CONTROL_REG ((0x01 << 10) | (0x40 << 2)) 	///../ucode/c_always_on_pointer.h:109
#define P_AO_I2C_M_0_CONTROL_REG 		AOBUS_REG_ADDR(AO_I2C_M_0_CONTROL_REG)
#define AO_I2C_M_0_SLAVE_ADDR ((0x01 << 10) | (0x41 << 2)) 	///../ucode/c_always_on_pointer.h:110
#define P_AO_I2C_M_0_SLAVE_ADDR 		AOBUS_REG_ADDR(AO_I2C_M_0_SLAVE_ADDR)
#define AO_I2C_M_0_TOKEN_LIST0 ((0x01 << 10) | (0x42 << 2)) 	///../ucode/c_always_on_pointer.h:111
#define P_AO_I2C_M_0_TOKEN_LIST0 		AOBUS_REG_ADDR(AO_I2C_M_0_TOKEN_LIST0)
#define AO_I2C_M_0_TOKEN_LIST1 ((0x01 << 10) | (0x43 << 2)) 	///../ucode/c_always_on_pointer.h:112
#define P_AO_I2C_M_0_TOKEN_LIST1 		AOBUS_REG_ADDR(AO_I2C_M_0_TOKEN_LIST1)
#define AO_I2C_M_0_WDATA_REG0 ((0x01 << 10) | (0x44 << 2)) 	///../ucode/c_always_on_pointer.h:113
#define P_AO_I2C_M_0_WDATA_REG0 		AOBUS_REG_ADDR(AO_I2C_M_0_WDATA_REG0)
#define AO_I2C_M_0_WDATA_REG1 ((0x01 << 10) | (0x45 << 2)) 	///../ucode/c_always_on_pointer.h:114
#define P_AO_I2C_M_0_WDATA_REG1 		AOBUS_REG_ADDR(AO_I2C_M_0_WDATA_REG1)
#define AO_I2C_M_0_RDATA_REG0 ((0x01 << 10) | (0x46 << 2)) 	///../ucode/c_always_on_pointer.h:115
#define P_AO_I2C_M_0_RDATA_REG0 		AOBUS_REG_ADDR(AO_I2C_M_0_RDATA_REG0)
#define AO_I2C_M_0_RDATA_REG1 ((0x01 << 10) | (0x47 << 2)) 	///../ucode/c_always_on_pointer.h:116
#define P_AO_I2C_M_0_RDATA_REG1 		AOBUS_REG_ADDR(AO_I2C_M_0_RDATA_REG1)
#define AO_I2C_S_CONTROL_REG ((0x01 << 10) | (0x50 << 2)) 	///../ucode/c_always_on_pointer.h:120
#define P_AO_I2C_S_CONTROL_REG 		AOBUS_REG_ADDR(AO_I2C_S_CONTROL_REG)
#define AO_I2C_S_SEND_REG ((0x01 << 10) | (0x51 << 2)) 	///../ucode/c_always_on_pointer.h:121
#define P_AO_I2C_S_SEND_REG 		AOBUS_REG_ADDR(AO_I2C_S_SEND_REG)
#define AO_I2C_S_RECV_REG ((0x01 << 10) | (0x52 << 2)) 	///../ucode/c_always_on_pointer.h:122
#define P_AO_I2C_S_RECV_REG 		AOBUS_REG_ADDR(AO_I2C_S_RECV_REG)
#define AO_I2C_S_CNTL1_REG ((0x01 << 10) | (0x53 << 2)) 	///../ucode/c_always_on_pointer.h:123
#define P_AO_I2C_S_CNTL1_REG 		AOBUS_REG_ADDR(AO_I2C_S_CNTL1_REG)
#define AO_RTC_ADDR0 ((0x01 << 10) | (0xd0 << 2)) 	///../ucode/c_always_on_pointer.h:135
#define P_AO_RTC_ADDR0 		AOBUS_REG_ADDR(AO_RTC_ADDR0)
#define AO_RTC_ADDR1 ((0x01 << 10) | (0xd1 << 2)) 	///../ucode/c_always_on_pointer.h:136
#define P_AO_RTC_ADDR1 		AOBUS_REG_ADDR(AO_RTC_ADDR1)
#define AO_RTC_ADDR2 ((0x01 << 10) | (0xd2 << 2)) 	///../ucode/c_always_on_pointer.h:137
#define P_AO_RTC_ADDR2 		AOBUS_REG_ADDR(AO_RTC_ADDR2)
#define AO_RTC_ADDR3 ((0x01 << 10) | (0xd3 << 2)) 	///../ucode/c_always_on_pointer.h:138
#define P_AO_RTC_ADDR3 		AOBUS_REG_ADDR(AO_RTC_ADDR3)
#define AO_RTC_ADDR4 ((0x01 << 10) | (0xd4 << 2)) 	///../ucode/c_always_on_pointer.h:139
#define P_AO_RTC_ADDR4 		AOBUS_REG_ADDR(AO_RTC_ADDR4)
#define AO_MF_IR_DEC_LDR_ACTIVE ((0x01 << 10) | (0x60 << 2)) 	///../ucode/c_always_on_pointer.h:141
#define P_AO_MF_IR_DEC_LDR_ACTIVE 		AOBUS_REG_ADDR(AO_MF_IR_DEC_LDR_ACTIVE)
#define AO_MF_IR_DEC_LDR_IDLE ((0x01 << 10) | (0x61 << 2)) 	///../ucode/c_always_on_pointer.h:142
#define P_AO_MF_IR_DEC_LDR_IDLE 		AOBUS_REG_ADDR(AO_MF_IR_DEC_LDR_IDLE)
#define AO_MF_IR_DEC_LDR_REPEAT ((0x01 << 10) | (0x62 << 2)) 	///../ucode/c_always_on_pointer.h:143
#define P_AO_MF_IR_DEC_LDR_REPEAT 		AOBUS_REG_ADDR(AO_MF_IR_DEC_LDR_REPEAT)
#define AO_MF_IR_DEC_BIT_0 ((0x01 << 10) | (0x63 << 2)) 	///../ucode/c_always_on_pointer.h:144
#define P_AO_MF_IR_DEC_BIT_0 		AOBUS_REG_ADDR(AO_MF_IR_DEC_BIT_0)
#define AO_MF_IR_DEC_REG0 ((0x01 << 10) | (0x64 << 2)) 	///../ucode/c_always_on_pointer.h:145
#define P_AO_MF_IR_DEC_REG0 		AOBUS_REG_ADDR(AO_MF_IR_DEC_REG0)
#define AO_MF_IR_DEC_FRAME ((0x01 << 10) | (0x65 << 2)) 	///../ucode/c_always_on_pointer.h:146
#define P_AO_MF_IR_DEC_FRAME 		AOBUS_REG_ADDR(AO_MF_IR_DEC_FRAME)
#define AO_MF_IR_DEC_STATUS ((0x01 << 10) | (0x66 << 2)) 	///../ucode/c_always_on_pointer.h:147
#define P_AO_MF_IR_DEC_STATUS 		AOBUS_REG_ADDR(AO_MF_IR_DEC_STATUS)
#define AO_MF_IR_DEC_REG1 ((0x01 << 10) | (0x67 << 2)) 	///../ucode/c_always_on_pointer.h:148
#define P_AO_MF_IR_DEC_REG1 		AOBUS_REG_ADDR(AO_MF_IR_DEC_REG1)
#define AO_MF_IR_DEC_REG2 ((0x01 << 10) | (0x68 << 2)) 	///../ucode/c_always_on_pointer.h:149
#define P_AO_MF_IR_DEC_REG2 		AOBUS_REG_ADDR(AO_MF_IR_DEC_REG2)
#define AO_MF_IR_DEC_DURATN2 ((0x01 << 10) | (0x69 << 2)) 	///../ucode/c_always_on_pointer.h:150
#define P_AO_MF_IR_DEC_DURATN2 		AOBUS_REG_ADDR(AO_MF_IR_DEC_DURATN2)
#define AO_MF_IR_DEC_DURATN3 ((0x01 << 10) | (0x6a << 2)) 	///../ucode/c_always_on_pointer.h:151
#define P_AO_MF_IR_DEC_DURATN3 		AOBUS_REG_ADDR(AO_MF_IR_DEC_DURATN3)
#define AO_MF_IR_DEC_FRAME1 ((0x01 << 10) | (0x6b << 2)) 	///../ucode/c_always_on_pointer.h:152
#define P_AO_MF_IR_DEC_FRAME1 		AOBUS_REG_ADDR(AO_MF_IR_DEC_FRAME1)

#endif
