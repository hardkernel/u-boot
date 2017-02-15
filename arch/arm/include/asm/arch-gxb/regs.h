



/* readme */

/* asm/arch/regs.h
 * registers collect from fragmented places in each drivers/files,
 * since regs changes a lot after txlx chip, all registers need
 * managed orderly.
*/


// arch/arm/include/asm/arch/i2c.h
#define I2C_M_0_CONTROL_REG                        0x2140
/*#define I2C_M_0_SLAVE_ADDR                         0x2141
#define I2C_M_0_TOKEN_LIST0                        0x2142
#define I2C_M_0_TOKEN_LIST1                        0x2143
#define I2C_M_0_WDATA_REG0                         0x2144
#define I2C_M_0_WDATA_REG1                         0x2145
#define I2C_M_0_RDATA_REG0                         0x2146
#define I2C_M_0_RDATA_REG1                         0x2147
*/
#define I2C_S_CONTROL_REG                          0x2150
#define I2C_M_1_CONTROL_REG                        0x21f0
#define I2C_M_2_CONTROL_REG 					   0x21f8
#define I2C_M_3_CONTROL_REG                        0x2348


/* spi nor flash */
#define P_SPI_FLASH_CMD     (volatile unsigned int *)0xc1108c80
#define P_SPI_FLASH_ADDR    (volatile unsigned int *)0xc1108c84
#define P_SPI_FLASH_CTRL    (volatile unsigned int *)0xc1108c88
#define P_SPI_FLASH_STATUS  (volatile unsigned int *)0xc1108c90
#define P_SPI_USER_REG      (volatile unsigned int *)0xc1108c9c
#define P_SPI_FLASH_C0      (volatile unsigned int *)0xc1108cc0
#define P_SPI_START_ADDR    (volatile unsigned int *)0xCC000000

// drivers/mtd/spi/spi_flash_amlogic.h
#if 0
#define P_PERIPHS_PIN_MUX_4		0xc88344c0
#define P_PERIPHS_PIN_MUX_5		0xc88344c4
#endif
#define SPI_FLASH_CMD                              0x2320
    #define SPI_FLASH_READ    31
    #define SPI_FLASH_WREN    30
    #define SPI_FLASH_WRDI    29
    #define SPI_FLASH_RDID    28
    #define SPI_FLASH_RDSR    27
    #define SPI_FLASH_WRSR    26
    #define SPI_FLASH_PP      25
    #define SPI_FLASH_SE      24
    #define SPI_FLASH_BE      23
    #define SPI_FLASH_CE      22
    #define SPI_FLASH_DP      21
    #define SPI_FLASH_RES     20
    #define SPI_HPM           19
    #define SPI_FLASH_USR     18
    #define SPI_FLASH_USR_ADDR 15
    #define SPI_FLASH_USR_DUMMY 14
    #define SPI_FLASH_USR_DIN   13
    #define SPI_FLASH_USR_DOUT   12
    #define SPI_FLASH_USR_DUMMY_BLEN   10
    #define SPI_FLASH_USR_CMD     0
#define SPI_FLASH_ADDR                             0x2321
    #define SPI_FLASH_BYTES_LEN 24
    #define SPI_FLASH_ADDR_START 0
#define SPI_FLASH_CTRL                             0x2322
    #define SPI_ENABLE_AHB    17
    #define SPI_SST_AAI       16
    #define SPI_RES_RID       15
    #define SPI_FREAD_DUAL    14
    #define SPI_READ_READ_EN  13
    #define SPI_CLK_DIV0      12
    #define SPI_CLKCNT_N      8
    #define SPI_CLKCNT_H      4
    #define SPI_CLKCNT_L      0
#define SPI_FLASH_CTRL1                            0x2323
#define SPI_FLASH_STATUS                           0x2324
#define SPI_FLASH_CTRL2                            0x2325
#define SPI_FLASH_CLOCK                            0x2326
#define SPI_FLASH_USER                             0x2327
#define SPI_FLASH_USER1                            0x2328
#define SPI_FLASH_USER2                            0x2329
#define SPI_FLASH_USER3                            0x232a
#define SPI_FLASH_USER4                            0x232b
#define SPI_FLASH_SLAVE                            0x232c
#define SPI_FLASH_SLAVE1                           0x232d
#define SPI_FLASH_SLAVE2                           0x232e
#define SPI_FLASH_SLAVE3                           0x232f
#define SPI_FLASH_C0                               0x2330
#define SPI_FLASH_C1                               0x2331
#define SPI_FLASH_C2                               0x2332
#define SPI_FLASH_C3                               0x2333
#define SPI_FLASH_C4                               0x2334
#define SPI_FLASH_C5                               0x2335
#define SPI_FLASH_C6                               0x2336
#define SPI_FLASH_C7                               0x2337
#define SPI_FLASH_B8                               0x2338
#define SPI_FLASH_B9                               0x2339
#define SPI_FLASH_B10                              0x233a
#define SPI_FLASH_B11                              0x233b
#define SPI_FLASH_B12                              0x233c
#define SPI_FLASH_B13                              0x233d
#define SPI_FLASH_B14                              0x233e
#define SPI_FLASH_B15                              0x233f


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

/* usb burning */



/* romboot.h */
#define P_ISA_TIMERE                 (volatile uint32_t *)0xc1109988
#define P_ASSIST_POR_CONFIG          (volatile uint32_t *)0xc1107d54
#define P_RESET1_REGISTER            (volatile uint32_t *)0xc1104408
#define P_WATCHDOG_CNTL              (volatile uint32_t *)0xc11098d0
#define P_WATCHDOG_CNTL1             (volatile uint32_t *)0xc11098d4
#define P_WATCHDOG_TCNT              (volatile uint32_t *)0xc11098d8
#define P_WATCHDOG_RESET             (volatile uint32_t *)0xc11098dc

