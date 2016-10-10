/*
 * (C) Copyright 2016
 * Hu Jian,Software Engineering, jian.hu@amlogic.com.
 *
 * Basic support for the uarts on gxtvbb,include three EE uarts and two AO uarts.
 * the fourth EE uart(UART_D) is different and will complete in the future.
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <config.h>
#include <asm/arch/cpu.h>
#include <asm/arch/uart_v1.h>
#include <asm/io.h>

void init_channel(unsigned baud_para, unsigned long reg_offset)
{
	writel(baud_para
		|UART_STP_BIT
		|UART_PRTY_BIT
		|UART_CHAR_LEN
		|UART_CNTL_MASK_RST_TX
		|UART_CNTL_MASK_RST_RX
		|UART_CNTL_MASK_CLR_ERR
		|UART_CNTL_MASK_TX_EN
		|UART_CNTL_MASK_RX_EN
		|UART_CNTL_MASK_2WIRE
		,(IO_BUS_BASE + reg_offset));
}

void init_ao_channel(unsigned baud_para, unsigned long reg_offset)
{
	writel(baud_para
		|UART_STP_BIT
		|UART_PRTY_BIT
		|UART_CHAR_LEN
		|UART_CNTL_MASK_RST_TX
		|UART_CNTL_MASK_RST_RX
		|UART_CNTL_MASK_CLR_ERR
		|UART_CNTL_MASK_TX_EN
		|UART_CNTL_MASK_RX_EN
		|UART_CNTL_MASK_2WIRE
		,(IO_AOBUS_BASE+ reg_offset));
}

void clrbits_le32_channel(unsigned long reg_offset)
{
	clrbits_le32((IO_BUS_BASE + reg_offset),
	UART_CNTL_MASK_RST_TX | UART_CNTL_MASK_RST_RX | UART_CNTL_MASK_CLR_ERR);

}

void clrbits_le32_ao_channel(unsigned long reg_offset)
{
	clrbits_le32((IO_AOBUS_BASE + reg_offset),
	UART_CNTL_MASK_RST_TX | UART_CNTL_MASK_RST_RX | UART_CNTL_MASK_CLR_ERR);
}

void serial_wait_tx_empty_uart_channel(unsigned long reg_offset)
{
	while ((readl((IO_BUS_BASE+ reg_offset)) & UART_STAT_MASK_TFIFO_EMPTY) == 0);
}

void serial_wait_tx_empty_uart_ao_channel(unsigned long reg_offset)
{
	while ((readl((IO_AOBUS_BASE+ reg_offset)) & UART_STAT_MASK_TFIFO_EMPTY) == 0);
}

int serial_tstc_uart_channel(unsigned long reg_offset)
{
	return (readl((IO_BUS_BASE+ reg_offset)) & UART_STAT_MASK_RFIFO_CNT);
}

int serial_tstc_uart_ao_channel(unsigned long reg_offset)
{
	return (readl((IO_AOBUS_BASE+ reg_offset)) & UART_STAT_MASK_RFIFO_CNT);
}

void serial_init_uart(unsigned set, unsigned channel)
{
	unsigned long baud_para;
	unsigned clk81=clk_get_rate(UART_CLK_SRC);
	if ( clk81 < 0 )
		return;

	/* baud rate */
	baud_para = clk81/(set*4) - 1;
	baud_para &= UART_CNTL_MASK_BAUD_RATE;

	switch (channel) {
		case UART_A:
			init_channel(baud_para, UARTA_CONTROL);
			clrbits_le32_channel(UARTA_CONTROL);
			break;
		case UART_B:
			init_channel(baud_para, UARTB_CONTROL);
			clrbits_le32_channel(UARTB_CONTROL);
			break;
		case UART_C:
			init_channel(baud_para, UARTC_CONTROL);
			clrbits_le32_channel(UARTC_CONTROL);
			break;
		case UART_D:
			break;
		case UART_AO_A:
			init_ao_channel(baud_para, AO_UARTA_CONTROL);
			clrbits_le32_ao_channel(AO_UARTA_CONTROL);
			break;
		case UART_AO_B:
			init_ao_channel(baud_para, AO_UARTB_CONTROL);
			clrbits_le32_ao_channel(AO_UARTB_CONTROL);
			break;

		default:
		break;

	}
}

void serial_putc_uart(const char c ,unsigned channel)
{
	switch (channel) {
		case UART_A:
			if (c == '\n')
			{
				while ((readl((IO_BUS_BASE+ UARTA_STATUS)) & UART_STAT_MASK_TFIFO_FULL));
				writel('\r', (IO_BUS_BASE+ UARTA_WFIFO));
			}
			/* Wait till dataTx register is not full */
			while ((readl((IO_BUS_BASE+ UARTA_STATUS)) & UART_STAT_MASK_TFIFO_FULL));

			writel(c, (IO_BUS_BASE+ UARTA_WFIFO));
			break;
		case UART_B:
			if (c == '\n')
			{
				while ((readl((IO_BUS_BASE+ UARTB_STATUS)) & UART_STAT_MASK_TFIFO_FULL));
				writel('\r', (IO_BUS_BASE+ UARTB_WFIFO));
			}
			/* Wait till dataTx register is not full */
			while ((readl((IO_BUS_BASE+ UARTB_STATUS)) & UART_STAT_MASK_TFIFO_FULL));

			writel(c, (IO_BUS_BASE+ UARTB_WFIFO));
			break;
		case UART_C:
			if (c == '\n')
			{
				while ((readl((IO_BUS_BASE+ UARTC_STATUS)) & UART_STAT_MASK_TFIFO_FULL));
				writel('\r', (IO_BUS_BASE+ UARTC_WFIFO));
			}
			/* Wait till dataTx register is not full */
			while ((readl((IO_BUS_BASE+ UARTC_STATUS)) & UART_STAT_MASK_TFIFO_FULL));

			writel(c, (IO_BUS_BASE+ UARTC_WFIFO));
			break;
		case UART_D:
			break;
		case UART_AO_A:
			if (c == '\n')
			{
				while ((readl((IO_AOBUS_BASE+ AO_UARTA_STATUS)) & UART_STAT_MASK_TFIFO_FULL));
				writel('\r', (IO_AOBUS_BASE+ AO_UARTA_WFIFO));
			}
			/* Wait till dataTx register is not full */
			while ((readl((IO_AOBUS_BASE+ AO_UARTA_STATUS)) & UART_STAT_MASK_TFIFO_FULL));

			writel(c, (IO_AOBUS_BASE+ AO_UARTA_WFIFO));
			break;
		case UART_AO_B:
			if (c == '\n')
			{
				while ((readl((IO_AOBUS_BASE+ AO_UARTB_STATUS)) & UART_STAT_MASK_TFIFO_FULL));
				writel('\r', (IO_AOBUS_BASE+ AO_UARTB_WFIFO));
			}
			/* Wait till dataTx register is not full */
			while ((readl((IO_AOBUS_BASE+ AO_UARTB_STATUS)) & UART_STAT_MASK_TFIFO_FULL));

			writel(c, (IO_AOBUS_BASE+ AO_UARTB_WFIFO));
			break;

		default:
		break;
	}
}

void serial_wait_tx_empty_uart(unsigned channel)
{
	switch (channel) {
		case UART_A:
			serial_wait_tx_empty_uart_channel(UARTA_STATUS);
			break;
		case UART_B:
			serial_wait_tx_empty_uart_channel(UARTB_STATUS);
			break;
		case UART_C:
			serial_wait_tx_empty_uart_channel(UARTC_STATUS);
			break;
		case UART_D:
			break;
		case UART_AO_A:
			serial_wait_tx_empty_uart_ao_channel(AO_UARTA_STATUS);
			break;
		case UART_AO_B:
			serial_wait_tx_empty_uart_ao_channel(AO_UARTB_STATUS);
			break;

		default:
		break;
	}
}

/*
* Read a single byte from the serial port. Returns 1 on success, 0
* otherwise 0.
*/

void serial_tstc_uart(unsigned channel)
{
	switch (channel) {
		case UART_A:
			serial_tstc_uart_channel(UARTA_STATUS);
			break;
		case UART_B:
			serial_tstc_uart_channel(UARTB_STATUS);
			break;
		case UART_C:
			serial_tstc_uart_channel(UARTC_STATUS);
			break;
		case UART_D:
			break;
		case UART_AO_A:
			serial_tstc_uart_ao_channel(AO_UARTA_STATUS);
			break;
		case UART_AO_B:
			serial_tstc_uart_ao_channel(AO_UARTB_STATUS);
			break;

		default:
		break;
	}
}

/*
+* Read a single byte from the serial port.
+*/

int serial_getc_uart(unsigned channel)
{
		unsigned char ch;
		switch (channel) {
		case UART_A:
			/* Wait till character is placed in fifo */
			while ((readl((IO_BUS_BASE+ UARTA_STATUS)) & UART_STAT_MASK_RFIFO_CNT) == 0);
			/* Also check for overflow errors */
			if (readl((IO_BUS_BASE+ UARTA_STATUS)) & (UART_STAT_MASK_PRTY_ERR | UART_STAT_MASK_FRAM_ERR))
			{
				setbits_le32((IO_BUS_BASE+ UARTA_CONTROL),UART_CNTL_MASK_CLR_ERR);
				clrbits_le32((IO_BUS_BASE+ UARTA_CONTROL),UART_CNTL_MASK_CLR_ERR);
			}
			ch = readl((IO_BUS_BASE+ UARTA_RFIFO)) & 0x00ff;
			return ((int)ch);
			break;
		case UART_B:
			while ((readl((IO_BUS_BASE+ UARTB_STATUS)) & UART_STAT_MASK_RFIFO_CNT) == 0);
			if (readl((IO_BUS_BASE+ UARTB_STATUS)) & (UART_STAT_MASK_PRTY_ERR | UART_STAT_MASK_FRAM_ERR))
			{
				setbits_le32((IO_BUS_BASE+ UARTB_CONTROL),UART_CNTL_MASK_CLR_ERR);
				clrbits_le32((IO_BUS_BASE+ UARTB_CONTROL),UART_CNTL_MASK_CLR_ERR);
			}
			ch = readl((IO_BUS_BASE+ UARTB_RFIFO)) & 0x00ff;
			return ((int)ch);

			break;
		case UART_C:
			while ((readl((IO_BUS_BASE+ UARTC_STATUS)) & UART_STAT_MASK_RFIFO_CNT) == 0);
			if (readl((IO_BUS_BASE+ UARTC_STATUS)) & (UART_STAT_MASK_PRTY_ERR | UART_STAT_MASK_FRAM_ERR))
			{
				setbits_le32((IO_BUS_BASE+ UARTC_CONTROL),UART_CNTL_MASK_CLR_ERR);
				clrbits_le32((IO_BUS_BASE+ UARTC_CONTROL),UART_CNTL_MASK_CLR_ERR);
			}
			ch = readl((IO_BUS_BASE+ UARTC_RFIFO)) & 0x00ff;
			return ((int)ch);

			break;
		case UART_D:
			break;
		case UART_AO_A:
			while ((readl((IO_AOBUS_BASE+ AO_UARTA_STATUS)) & UART_STAT_MASK_RFIFO_CNT) == 0);
			if (readl((IO_AOBUS_BASE+ AO_UARTA_STATUS)) & (UART_STAT_MASK_PRTY_ERR | UART_STAT_MASK_FRAM_ERR))
			{
				setbits_le32((IO_AOBUS_BASE+ AO_UARTA_CONTROL),UART_CNTL_MASK_CLR_ERR);
				clrbits_le32((IO_AOBUS_BASE+ AO_UARTA_CONTROL),UART_CNTL_MASK_CLR_ERR);
			}
			ch = readl((IO_AOBUS_BASE+ AO_UARTA_RFIFO)) & 0x00ff;
			return ((int)ch);

			break;
		case UART_AO_B:
			while ((readl((IO_AOBUS_BASE+ AO_UARTB_STATUS)) & UART_STAT_MASK_RFIFO_CNT) == 0);
			if (readl((IO_AOBUS_BASE+ AO_UARTB_STATUS)) & (UART_STAT_MASK_PRTY_ERR | UART_STAT_MASK_FRAM_ERR))
			{
				setbits_le32((IO_AOBUS_BASE+ AO_UARTB_CONTROL),UART_CNTL_MASK_CLR_ERR);
				clrbits_le32((IO_AOBUS_BASE+ AO_UARTB_CONTROL),UART_CNTL_MASK_CLR_ERR);
			}
			ch = readl((IO_AOBUS_BASE+ AO_UARTB_RFIFO)) & 0x00ff;
			return ((int)ch);

			break;

		default:
		break;
	}
	return 0;
}


void serial_puts_uart(const char *s, unsigned channel)
{
	while (*s) {
		serial_putc_uart(*s++, channel);
	}
	serial_wait_tx_empty_uart(channel);
}

void serial_put_hex_uart(unsigned int data,unsigned bitlen, unsigned channel)
{
	int i;
	for (i=bitlen-4;i>=0;i-=4) {
		if ((data>>i) == 0)
		{
			serial_putc_uart(CHAR_ZERO,channel);
			continue;
		}
		unsigned char s = (data>>i)&0xf;
		if (s<10)
			serial_putc_uart(CHAR_ZERO+s,channel);
		else
			serial_putc_uart(CHAR_LOWER_A+s-10,channel);
	}
}


void serial_put_dec_uart(unsigned int data, unsigned channel)
{
	char szTxt[10];
	szTxt[0] = CHAR_ZERO;
	int i = 0;
	while (data)
	{
		szTxt[i++] = (data % 10) + CHAR_ZERO;
		data = data / 10;
	}
	for (--i;i >=0;--i)
		serial_putc_uart(szTxt[i], channel);
}
