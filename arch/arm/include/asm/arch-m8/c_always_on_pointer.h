
#ifdef  C_ALWAYS_ON_POINTER_H
#else 


#define AO_Wr(addr, data)   *(volatile unsigned long *)((0xc8100000)|((addr)<<2))=(data)
#define AO_Rd(addr)         *(volatile unsigned long *)((0xc8100000)|((addr)<<2))

// -------------------------------------------------------------------
// BASE #0
// -------------------------------------------------------------------

#define P_AO_RTI_STATUS_REG0        (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x00 << 2))
#define P_AO_RTI_STATUS_REG1        (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x01 << 2))
#define P_AO_RTI_STATUS_REG2        (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x02 << 2))

#define P_AO_RTI_PWR_CNTL_REG0      (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x04 << 2))
#define P_AO_RTI_PIN_MUX_REG        (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x05 << 2))

#define P_AO_WD_GPIO_REG            (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x06 << 2))

#define P_AO_REMAP_REG0             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x07 << 2))
#define P_AO_REMAP_REG1             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x08 << 2))
#define P_AO_GPIO_O_EN_N            (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x09 << 2))
#define P_AO_GPIO_I                 (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x0A << 2))

#define P_AO_RTI_PULL_UP_REG        (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x0B << 2))
// replaced with secure register
// #define P_AO_RTI_JTAG_CODNFIG_REG   (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x0C << 2))
#define P_AO_RTI_WD_MARK            (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x0D << 2))

#define P_AO_RTI_GEN_CNTL_REG0      (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x10 << 2))
#define P_AO_WATCHDOG_REG           (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x11 << 2))
#define P_AO_WATCHDOG_RESET         (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x12 << 2))

#define P_AO_TIMER_REG              (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x13 << 2))
#define P_AO_TIMERA_REG             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x14 << 2))
#define P_AO_TIMERE_REG             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x15 << 2))

#define P_AO_AHB2DDR_CNTL           (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x18 << 2))

#define P_AO_IRQ_MASK_FIQ_SEL       (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x20 << 2))
#define P_AO_IRQ_GPIO_REG           (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x21 << 2))
#define P_AO_IRQ_STAT               (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x22 << 2))
#define P_AO_IRQ_STAT_CLR           (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x23 << 2))

#define P_AO_DEBUG_REG0             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x28 << 2))
#define P_AO_DEBUG_REG1             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x29 << 2))
#define P_AO_DEBUG_REG2             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x2a << 2))
#define P_AO_DEBUG_REG3             (volatile unsigned long *)(0xc8100000 | (0x00 << 10) | (0x2b << 2))

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
#define P_AO_IR_DEC_LDR_ACTIVE      (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x20 << 2))
#define P_AO_IR_DEC_LDR_IDLE        (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x21 << 2))
#define P_AO_IR_DEC_LDR_REPEAT      (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x22 << 2))
#define P_AO_IR_DEC_BIT_0           (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x23 << 2))
#define P_AO_IR_DEC_REG0            (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x24 << 2))
#define P_AO_IR_DEC_FRAME           (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x25 << 2))
#define P_AO_IR_DEC_STATUS          (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x26 << 2))
#define P_AO_IR_DEC_REG1            (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x27 << 2))

// ----------------------------
// UART
// ----------------------------
#define P_AO_UART_WFIFO             (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x30 << 2))
#define P_AO_UART_RFIFO             (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x31 << 2))
#define P_AO_UART_CONTROL           (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x32 << 2))
#define P_AO_UART_STATUS            (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x33 << 2))
#define P_AO_UART_MISC              (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x34 << 2))
#define P_AO_UART_REG5              (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x35 << 2))

// ----------------------------
// UART2
// ----------------------------
#define P_AO_UART2_WFIFO             (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x38 << 2))
#define P_AO_UART2_RFIFO             (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x39 << 2))
#define P_AO_UART2_CONTROL           (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x3a << 2))
#define P_AO_UART2_STATUS            (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x3b << 2))
#define P_AO_UART2_MISC              (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x3c << 2))
#define P_AO_UART2_REG5              (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x3d << 2))

// ----------------------------
// I2C Master (8)
// ----------------------------
#define P_AO_I2C_M_0_CONTROL_REG    (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x40 << 2))
#define P_AO_I2C_M_0_SLAVE_ADDR     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x41 << 2))
#define P_AO_I2C_M_0_TOKEN_LIST0    (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x42 << 2))
#define P_AO_I2C_M_0_TOKEN_LIST1    (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x43 << 2))
#define P_AO_I2C_M_0_WDATA_REG0     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x44 << 2))
#define P_AO_I2C_M_0_WDATA_REG1     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x45 << 2))
#define P_AO_I2C_M_0_RDATA_REG0     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x46 << 2))
#define P_AO_I2C_M_0_RDATA_REG1     (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x47 << 2))
// ----------------------------
// I2C Slave (3)
// ----------------------------
#define P_AO_I2C_S_CONTROL_REG      (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x50 << 2))
#define P_AO_I2C_S_SEND_REG         (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x51 << 2))
#define P_AO_I2C_S_RECV_REG         (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x52 << 2))
#define P_AO_I2C_S_CNTL1_REG        (volatile unsigned long *)(0xc8100000 | (0x01 << 10) | (0x53 << 2))

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

#endif      // C_ALWAYS_ON_POINTER_H

