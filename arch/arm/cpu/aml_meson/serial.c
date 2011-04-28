/*******************************************************************
 * 
 *  Copyright C 2010 by Amlogic, Inc. All Rights Reserved.
 *
 *  Description: Serial driver.
 *
 *  Author: Jerry Yu
 *  Created: 2009-3-12 
 *
 *******************************************************************/

#include <config.h>
#include <asm/arch/io.h>
#include <asm/arch/cpu.h>
#include <asm/arch/uart.h>
#include <common.h>

DECLARE_GLOBAL_DATA_PTR;

SPL_STATIC_FUNC int serial_set_pin_port(unsigned port_base);
static void serial_putc_port (unsigned port_base,const char c);

//static unsigned port_base_addrs[]={UART_PORT_0,UART_PORT_1};
#if 0 // due to errror
static void serial_clr_err (unsigned port_base)
{
    /* write to the register */
	 
	if(readl(P_UART_STATUS(port_base))&(UART_STAT_MASK_PRTY_ERR|UART_STAT_MASK_FRAM_ERR))
		writel((readl(P_UART_CONTROL(port_base)) | UART_CNTL_MASK_CLR_ERR), P_UART_CONTROL(port_base));
}
#endif

/*
 * Sets baudarate
 */
static void serial_setbrg_port (unsigned port_base)
{
        
    unsigned long baud_para;
    int clk81=clk_get_rate(UART_CLK_SRC);
    if(clk81<0)
        return;
     
    
    /* baud rate */
    baud_para=clk81/(gd->baudrate*4) -1;

    baud_para &= UART_CNTL_MASK_BAUD_RATE;

    /* write to the register */ 
    writel((readl(P_UART_CONTROL(port_base)) & ~UART_CNTL_MASK_BAUD_RATE) | baud_para, P_UART_CONTROL(port_base));
}

/*
 * Sets stop bits
 * input[0]: stop_bits (1, 2)
 */
static void serial_set_stop_port (unsigned port_base,int stop_bits)
{   
    unsigned long uart_config;

    uart_config = readl(P_UART_CONTROL(port_base)) & ~UART_CNTL_MASK_STP_BITS;
    /* stop bits */
    switch(stop_bits)
    {
        case 2:
            uart_config |= UART_CNTL_MASK_STP_2BIT;
            break;
        case 1:
        default:
            uart_config |= UART_CNTL_MASK_STP_1BIT;
            break;      
    }
    
    /* write to the register */
    writel(uart_config, P_UART_CONTROL(port_base));
}

/*
 * Sets parity type
 * input[0]: 1 -- enable parity, 0 -- disable;
 * input[1]: 1 -- odd parity, 0 -- even parity;
 */
static void serial_set_parity_port(unsigned port_base,int type)
{
    unsigned long uart_config;
     

    uart_config = readl(P_UART_CONTROL(port_base)) & ~(UART_CNTL_MASK_PRTY_TYPE | UART_CNTL_MASK_PRTY_EN);
#if 0   //changed by Elvis --- disable parity
    uart_config |= UART_CNTL_MASK_PRTY_EN;
    /* parity bits */
    if(type&2)
        uart_config |= UART_CNTL_MASK_PRTY_EN;
    if(type&1)
        uart_config |= UART_CNTL_MASK_PRTY_ODD;
    else
        uart_config |= UART_CNTL_MASK_PRTY_EVEN;
 #endif   
    /* write to the register */
    writel(uart_config, P_UART_CONTROL(port_base));

}

/*
 * Sets data length
 * input[0]: Character length [5, 6, 7, 8]
 */
static void serial_set_dlen_port (unsigned port_base,int data_len)
{
    unsigned long uart_config;
     
    uart_config = readl(P_UART_CONTROL(port_base)) & ~UART_CNTL_MASK_CHAR_LEN;
    /* data bits */
    switch(data_len)
    {
        case 5:
            uart_config |= UART_CNTL_MASK_CHAR_5BIT;
            break;
        case 6:
            uart_config |= UART_CNTL_MASK_CHAR_6BIT;
            break;
        case 7:
            uart_config |= UART_CNTL_MASK_CHAR_7BIT;
            break;
        case 8:
        default:
            uart_config |= UART_CNTL_MASK_CHAR_8BIT;
            break;
    }   
    
    /* write to the register */
    writel(uart_config, P_UART_CONTROL(port_base));
}



/*
 * reset the uart state machine
 */
static void serial_reset_port(unsigned port_base) {
	
	/* write to the register */
	writel(readl(P_UART_CONTROL(port_base)) | UART_CNTL_MASK_RST_TX | UART_CNTL_MASK_RST_RX | UART_CNTL_MASK_CLR_ERR, P_UART_CONTROL(port_base));
	writel(readl(P_UART_CONTROL(port_base)) & ~(UART_CNTL_MASK_RST_TX | UART_CNTL_MASK_RST_RX | UART_CNTL_MASK_CLR_ERR), P_UART_CONTROL(port_base));
}

/*
 * Intialise the serial port with given baudrate
 */

static int serial_init_port (unsigned port_base)
{
	int ret;

#ifdef CONFIG_M3
	while((readl(P_UART_STATUS(port_base)) & (UART_STAT_MASK_XMIT_BUSY)));
#endif

    writel(0,P_UART_CONTROL(port_base));
    ret = serial_set_pin_port(port_base);
    if (ret < 0)
    	return -1;
    
    serial_setbrg_port(port_base);
#ifndef CONFIG_SERIAL_STP_BITS
#define CONFIG_SERIAL_STP_BITS 1
#endif    
    serial_set_stop_port(port_base,CONFIG_SERIAL_STP_BITS);
#ifndef CONFIG_SERIAL_PRTY_TYPE
#define CONFIG_SERIAL_PRTY_TYPE 0
#endif

    serial_set_parity_port(port_base,CONFIG_SERIAL_PRTY_TYPE);
#ifndef CONFIG_SERIAL_CHAR_LEN
#define CONFIG_SERIAL_CHAR_LEN 8
#endif
    serial_set_dlen_port(port_base,CONFIG_SERIAL_CHAR_LEN);
    writel(readl(P_UART_CONTROL(port_base)) | UART_CNTL_MASK_TX_EN | UART_CNTL_MASK_RX_EN, P_UART_CONTROL(port_base));
    while(!(readl(P_UART_STATUS(port_base)) & UART_STAT_MASK_TFIFO_EMPTY));
    serial_reset_port(port_base);
#ifdef CONFIG_M3
	while((readl(P_UART_STATUS(port_base)) & (UART_STAT_MASK_XMIT_BUSY)));
#endif    
    serial_putc_port(port_base,'\n');
    return 0;
}

/*
 * Output a single byte to the serial port.
 */
static void serial_putc_port (unsigned port_base,const char c)
{
	
    if (c == '\n') 
        serial_putc_port(port_base,'\r');
    
    /* Wait till dataTx register is not full */
    while ((readl(P_UART_STATUS(port_base)) & UART_STAT_MASK_TFIFO_FULL));
 // while(!(readl(P_UART_STATUS(port_base)) & UART_STAT_MASK_TFIFO_EMPTY));  
    writel(c, P_UART_WFIFO(port_base));
    /* Wait till dataTx register is empty */
#if !defined (CONFIG_VLSI_EMULATOR)
    while(!(readl(P_UART_STATUS(port_base)) & UART_STAT_MASK_TFIFO_EMPTY));
#endif //CONFIG_VLSI_EMULATOR

}

/*
 * Read a single byte from the serial port. Returns 1 on success, 0
 * otherwise 0.
 */
static int serial_tstc_port (unsigned port_base)
{
	
	int i;

	i=(readl(P_UART_STATUS(port_base)) & UART_STAT_MASK_RFIFO_CNT);
	return i;

}

/*
 * Read a single byte from the serial port. 
 */
static int serial_getc_port (unsigned port_base)
{
    unsigned char ch;   
    
    /* Wait till character is placed in fifo */
  	while((readl(P_UART_STATUS(port_base)) & UART_STAT_MASK_RFIFO_CNT)==0) ;
  	ch = readl(P_UART_RFIFO(port_base)) & 0x00ff;
    /* Also check for overflow errors */
    if (readl(P_UART_STATUS(port_base)) & (UART_STAT_MASK_PRTY_ERR | UART_STAT_MASK_FRAM_ERR))
    {
    	writel(readl(P_UART_CONTROL(port_base)) |UART_CNTL_MASK_CLR_ERR,P_UART_CONTROL(port_base));//clear errors
        writel(readl(P_UART_CONTROL(port_base)) & (~UART_CNTL_MASK_CLR_ERR),P_UART_CONTROL(port_base));

    }
    

    return ((int)ch);

}

static void serial_puts_port (unsigned port_base,const char *s)
{
    while (*s) {
        serial_putc_port(port_base,*s++);
    }
}
#if CONFIG_SERIAL_MULTI
#include <serial.h>
#define DECLARE_UART_FUNCTIONS(port) \
    static int  uart_##port##_init (void) {\
	serial_init_port(port);	return(0);}\
    static void uart_##port##_setbrg (void) {\
	serial_setbrg_port(port);}\
    static int  uart_##port##_getc (void) {\
	return serial_getc_port(port);}\
    static int  uart_##port##_tstc (void) {\
	return serial_tstc_port(port);}\
    static void uart_##port##_putc (const char c) {\
	serial_putc_port(port, c);}\
    static void uart_##port##_puts (const char *s) {\
	serial_puts_port(port, s);}

#define INIT_UART_STRUCTURE(port,name,bus) static struct serial_device device_##port={\
	name,\
	bus,\
	uart_##port##_init,\
	NULL,\
	uart_##port##_setbrg,\
	uart_##port##_getc,\
	uart_##port##_tstc,\
	uart_##port##_putc,\
	uart_##port##_puts, }

DECLARE_UART_FUNCTIONS(UART_PORT_0);
INIT_UART_STRUCTURE(UART_PORT_0,"uart0","UART0");
DECLARE_UART_FUNCTIONS(UART_PORT_1);
INIT_UART_STRUCTURE(UART_PORT_1,"uart1","UART1");
#ifdef UART_PORT_AO
DECLARE_UART_FUNCTIONS(UART_PORT_AO);
INIT_UART_STRUCTURE(UART_PORT_AO,"uart_ao","UART_AO");
#endif
struct serial_device * default_serial_console (void)
{
#if (UART_PORT_CONS==UART_PORT_0)
    return &device_UART_PORT_0;
#elif (UART_PORT_CONS==UART_PORT_1)
    return &device_UART_PORT_1;
#else
#ifdef UART_PORT_AO
#if (UART_PORT_CONS==UART_PORT_AO)
   return &device_UART_PORT_AO;      
#else
	#error "invalid uart port index defined"
#endif
#endif
#endif    
}
void serial_aml_register(void)
{
    serial_register(&device_UART_PORT_0);
    serial_register(&device_UART_PORT_1);
#ifdef UART_PORT_AO    
    serial_register(&device_UART_PORT_AO);
#endif
}
#endif
#if !(defined CONFIG_SERIAL_MULTI)
int serial_init(void){
	return serial_init_port(UART_PORT_CONS);
}

void serial_putc(const char c){
	serial_putc_port(UART_PORT_CONS,c);
}

int serial_tstc(void){
	return serial_tstc_port(UART_PORT_CONS);
}

int serial_getc(void){
	return serial_getc_port(UART_PORT_CONS);
}

void serial_puts(const char * s){
	serial_puts_port(UART_PORT_CONS,s);
}

void serial_setbrg(void){
	serial_setbrg_port(UART_PORT_CONS);
}
#ifdef CONFIG_CMD_KGDB


#if UART_PORT_CONS==UART_PORT_0
#define DEBUG_PORT UART_PORT_1
#else
#define DEBUG_PORT UART_PORT_0
#endif

int kgdb_serial_init(void){
    int ret=serial_init_port(DEBUG_PORT);
    
	return ret;
}

int getDebugChar(void){
	return serial_getc_port(DEBUG_PORT);
}

void putDebugChar(const char c){
	serial_putc_port(DEBUG_PORT,c);
}

void putDebugStr(const char * s){
	serial_puts_port(DEBUG_PORT,s);
}

#endif  /* CONFIG_CMD_KGDB */

#endif
