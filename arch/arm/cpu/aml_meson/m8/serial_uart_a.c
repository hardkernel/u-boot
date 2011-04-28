
#include <config.h>
#include <asm/arch/cpu.h>
#include <asm/arch/uart.h>
#include <asm/arch/io.h>


SPL_STATIC_FUNC void serial_init_uart_a(unsigned set)
{
    /* baud rate */
	writel(set
	    |UART_CNTL_MASK_RST_TX
	    |UART_CNTL_MASK_RST_RX
	    |UART_CNTL_MASK_CLR_ERR
	    |UART_CNTL_MASK_TX_EN
	    |UART_CNTL_MASK_RX_EN
	,CBUS_REG_ADDR(UART_PORT_0+UART_CONTROL));
    SET_CBUS_REG_MASK(0x2030, 0x3000);
    CLEAR_CBUS_REG_MASK(0x202f,0x3000);
    clrbits_le32(CBUS_REG_ADDR(UART_PORT_0+UART_CONTROL),
	    UART_CNTL_MASK_RST_TX | UART_CNTL_MASK_RST_RX | UART_CNTL_MASK_CLR_ERR);

}
//SPL_STATIC_FUNC
void serial_putc_uart_a(const char c)
{
    if (c == '\n')
    {
        while ((readl(CBUS_REG_ADDR(UART_PORT_0+UART_STATUS )) & UART_STAT_MASK_TFIFO_FULL));
        writel('\r', CBUS_REG_ADDR(UART_PORT_0+UART_WFIFO));
    }
    /* Wait till dataTx register is not full */
    while ((readl(CBUS_REG_ADDR(UART_PORT_0+UART_STATUS )) & UART_STAT_MASK_TFIFO_FULL));
    writel(c, CBUS_REG_ADDR(UART_PORT_0+UART_WFIFO));
    /* Wait till dataTx register is empty */
}

//SPL_STATIC_FUNC
void serial_wait_tx_empty_uart_a(void)
{
    while ((readl(CBUS_REG_ADDR(UART_PORT_0+UART_STATUS)) & UART_STAT_MASK_TFIFO_EMPTY)==0);
}
/*
 * Read a single byte from the serial port. Returns 1 on success, 0
 * otherwise 0.
 */
SPL_STATIC_FUNC
int serial_tstc_uart_a(void)
{
	return (readl(CBUS_REG_ADDR(UART_PORT_0+UART_STATUS)) & UART_STAT_MASK_RFIFO_CNT);

}

/*
 * Read a single byte from the serial port.
 */
SPL_STATIC_FUNC
int serial_getc_uart_a(void)
{
    unsigned char ch;
    /* Wait till character is placed in fifo */
  	while((readl(CBUS_REG_ADDR(UART_PORT_0+UART_STATUS)) & UART_STAT_MASK_RFIFO_CNT)==0) ;

    /* Also check for overflow errors */
    if (readl(CBUS_REG_ADDR(UART_PORT_0+UART_STATUS)) & (UART_STAT_MASK_PRTY_ERR | UART_STAT_MASK_FRAM_ERR))
	{
	    setbits_le32(CBUS_REG_ADDR(UART_PORT_0+UART_CONTROL),UART_CNTL_MASK_CLR_ERR);
	    clrbits_le32(CBUS_REG_ADDR(UART_PORT_0+UART_CONTROL),UART_CNTL_MASK_CLR_ERR);
	}

    ch = readl(CBUS_REG_ADDR(UART_PORT_0+UART_RFIFO)) & 0x00ff;
    return ((int)ch);

}

//SPL_STATIC_FUNC
void serial_puts_uart_a(const char *s)
{
    while (*s) {
        serial_putc_uart_a(*s++);
    }
	serial_wait_tx_empty_uart_a();
}
SPL_STATIC_FUNC
void serial_put_hex_uart_a(unsigned int data,unsigned bitlen)
{
	int i;
    for (i=bitlen-4;i>=0;i-=4){
        if((data>>i)==0)
        {
            serial_putc_uart_a(0x30);
            continue;
        }

        unsigned char s = (data>>i)&0xf;
        if (s<10)
            serial_putc_uart_a(0x30+s);
        else
            serial_putc_uart_a(0x61+s-10);
    }

}

SPL_STATIC_FUNC void serial_put_dec_uart_a(unsigned int data)
{
	char szTxt[10];
	szTxt[0] = 0x30;
	int i = 0;
	while(data)
	{
		szTxt[i++] = (data % 10) + 0x30;
		data = data / 10;
	}

	for(--i;i >=0;--i)	
		serial_putc_uart_a(szTxt[i]);
}







