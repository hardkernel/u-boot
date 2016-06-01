
/*
 * arch/arm/cpu/armv8/txl/firmware/scp_task/hdmi_cec_arc.c
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

#ifdef CONFIG_CEC_WAKEUP
#include "secure_apb.h"
#include "cec_tx_reg.h"
#ifndef NULL
#define NULL ((void *)0)
#endif
#define CEC_DBG_PRINT
#ifdef CEC_DBG_PRINT
	#define cec_dbg_print(s,v) {uart_puts(s);uart_put_hex(v,8); _udelay(100);}
	#define cec_dbg_prints(s)  {uart_puts(s); _udelay(100);}
#else
	#define cec_dbg_print(s,v)
	#define cec_dbg_prints(s)
#endif

void cec_reset_addr(void);
struct cec_tx_msg_t {
	unsigned char buf[16];
	unsigned char retry;
	unsigned char len;
};

#define CEX_TX_MSG_BUF_NUM	  8
#define CEC_TX_MSG_BUF_MASK	 (CEX_TX_MSG_BUF_NUM - 1)

struct cec_tx_msg {
	struct cec_tx_msg_t msg[CEX_TX_MSG_BUF_NUM];
	unsigned int send_idx;
	unsigned int queue_idx;
};

struct cec_tx_msg cec_tx_msgs = {};


int cec_strlen(char *p)
{
	int i=0;

	while (*p++)
		i++;
	return i;
}

void *cec_memcpy(void *memto, const void *memfrom, unsigned int size)
{
	char *tempfrom = (char *)memfrom;
	char *tempto = (char *)memto;

	if ((memto == NULL) || (memfrom == NULL))
		return NULL;
	while (size -- > 0)
		*tempto++ = *tempfrom++;
	return memto;
}

#define waiting_aocec_free() \
	do {\
		unsigned long cnt = 0;\
		while (readl(P_AO_CEC_RW_REG) & (1<<23))\
		{\
			if (5000 == cnt++)\
			{\
				break;\
			}\
		}\
	} while(0)

unsigned long cec_rd_reg(unsigned long addr)
{
	unsigned long data32;
	waiting_aocec_free();
	data32  = 0;
	data32 |= 0    << 16;  // [16]   cec_reg_wr
	data32 |= 0    << 8;   // [15:8] cec_reg_wrdata
	data32 |= addr << 0;   // [7:0]  cec_reg_addr
	writel(data32, P_AO_CEC_RW_REG);
	waiting_aocec_free();
	data32 = ((readl(P_AO_CEC_RW_REG)) >> 24) & 0xff;
	return (data32);
} /* cec_rd_reg */

void cec_wr_reg (unsigned long addr, unsigned long data)
{
	unsigned long data32;
	waiting_aocec_free();
	data32  = 0;
	data32 |= 1    << 16;  // [16]   cec_reg_wr
	data32 |= data << 8;   // [15:8] cec_reg_wrdata
	data32 |= addr << 0;   // [7:0]  cec_reg_addr
	writel(data32, P_AO_CEC_RW_REG);
} /* aocec_wr_only_reg */

void cec_off(void)
{
	/*
	 * [2:1] cntl_clk: 0=Disable clk (Power-off mode);
	 * 1=Enable gated clock (Normal mode);
	 * 2=Enable free-run clk (Debug mode).
	 */
	writel(0x0, P_AO_CEC_GEN_CNTL);
}

void cec_rx_read_pos_plus(void)
{
	(cec_msg.rx_read_pos ==  cec_msg.rx_buf_size - 1) ?
				(cec_msg.rx_read_pos = 0) :
				(cec_msg.rx_read_pos++);
}

void cec_arbit_bit_time_set(unsigned bit_set, unsigned time_set)
{
	//11bit:bit[10:0]
	switch (bit_set) {
	case 3:
		//3 bit
		cec_wr_reg(AO_CEC_TXTIME_4BIT_BIT7_0, time_set & 0xff);
		cec_wr_reg(AO_CEC_TXTIME_4BIT_BIT10_8, (time_set >> 8) & 0x7);
		break;
		//5 bit
	case 5:
		cec_wr_reg(AO_CEC_TXTIME_2BIT_BIT7_0, time_set & 0xff);
		cec_wr_reg(AO_CEC_TXTIME_2BIT_BIT10_8, (time_set >> 8) & 0x7);
		//7 bit
	case 7:
		cec_wr_reg(AO_CEC_TXTIME_17MS_BIT7_0, time_set & 0xff);
		cec_wr_reg(AO_CEC_TXTIME_17MS_BIT10_8, (time_set >> 8) & 0x7);
		break;
	default:
		break;
	}
}

void cec_hw_buf_clear(void)
{
	cec_wr_reg(CEC_RX_MSG_CMD, RX_DISABLE);
	cec_wr_reg(CEC_TX_MSG_CMD, TX_ABORT);
	cec_wr_reg(CEC_RX_CLEAR_BUF, 1);
	cec_wr_reg(CEC_TX_CLEAR_BUF, 1);
	_udelay(100);
	cec_wr_reg(CEC_RX_CLEAR_BUF, 0);
	cec_wr_reg(CEC_TX_CLEAR_BUF, 0);
	_udelay(100);
	cec_wr_reg(CEC_RX_MSG_CMD, RX_NO_OP);
	cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
}

void remote_cec_hw_reset(void)
{
	unsigned int reg;
	cec_dbg_prints("cec reset\n");
	/*
	 * clock switch to 32k
	 */
	reg =   (0 << 31) |
		(0 << 30) |
		(1 << 28) |         /* clk_div0/clk_div1 in turn */
		((732 - 1) << 12) | /* Div_tcnt1 */
		((733 - 1) << 0);   /* Div_tcnt0 */
	writel(reg, P_AO_RTC_ALT_CLK_CNTL0);
	reg =   (0 << 13) |
		((11 - 1)  << 12) |
		( (8 - 1)  <<  0);
	writel(reg, P_AO_RTC_ALT_CLK_CNTL1);

	reg = readl(P_AO_RTC_ALT_CLK_CNTL0);
	reg |= (1 << 31);
	writel(reg, P_AO_RTC_ALT_CLK_CNTL0);

	_udelay(200);
	reg |= (1 << 30);
	writel(reg, P_AO_RTC_ALT_CLK_CNTL0);

	reg = readl(P_AO_CRT_CLK_CNTL1);
	reg |= (0x800 << 16);   /* select cts_rtc_oscin_clk */
	writel(reg, P_AO_CRT_CLK_CNTL1);

	reg = readl(P_AO_RTI_PWR_CNTL_REG0);
	reg &= ~(0x07 << 10);
	reg |=  (0x04 << 10);   /* XTAL generate 32k */
	writel(reg, P_AO_RTI_PWR_CNTL_REG0);

	/* set up pinmux */
	writel(readl(P_AO_RTI_PIN_MUX_REG) & (~(1 << 18 | 1 << 17)), P_AO_RTI_PIN_MUX_REG);
	writel(readl(P_AO_RTI_PULL_UP_REG) & (~(1 << 9)), P_AO_RTI_PULL_UP_REG);
	writel(readl(P_AO_RTI_PIN_MUX_REG) | (1 << 16), P_AO_RTI_PIN_MUX_REG);
	// Assert SW reset AO_CEC
	writel(0x1, P_AO_CEC_GEN_CNTL);
	// Enable gated clock (Normal mode).
	writel(readl(P_AO_CEC_GEN_CNTL) | (1<<1), P_AO_CEC_GEN_CNTL);
	_udelay(100);
	// Release SW reset
	writel(readl(P_AO_CEC_GEN_CNTL) & ~(1<<0), P_AO_CEC_GEN_CNTL);

	cec_arbit_bit_time_set(3, 0x118);
	cec_arbit_bit_time_set(5, 0x000);
	cec_arbit_bit_time_set(7, 0x2aa);
}

unsigned char remote_cec_ll_rx(void)
{
	int i;
	int print = 1;
	unsigned char rx_msg_length = cec_rd_reg(CEC_RX_MSG_LENGTH) + 1;

	cec_dbg_prints("cec R:");
	for (i = 0; i < rx_msg_length; i++) {
		cec_msg.buf[cec_msg.rx_write_pos].msg[i] = cec_rd_reg(CEC_RX_MSG_0_HEADER + i);
		if (print) {
			cec_dbg_print(" ", cec_msg.buf[cec_msg.rx_write_pos].msg[i]);
		}
		if (i == 1 && cec_msg.buf[cec_msg.rx_write_pos].msg[i] == CEC_OC_VENDOR_COMMAND_WITH_ID) {
			/* do not print command with ID */
			print = 0;
		}
	}
	cec_msg.buf[cec_msg.rx_write_pos].msg_len = rx_msg_length;
	cec_dbg_prints("\n");

	return 0;
}
void cec_buf_clear(void)
{
	int i;

	for (i = 0; i < 16; i++)
		cec_msg.buf[cec_msg.rx_read_pos].msg[i] = 0;
}

void cec_tx_buf_init(void)
{
	int i, j;
	for (j = 0; j < CEX_TX_MSG_BUF_NUM; j++) {
		for (i = 0; i < 16; i++) {
			cec_tx_msgs.msg[j].buf[i] = 0;
		}
		cec_tx_msgs.msg[j].retry = 0;
		cec_tx_msgs.msg[j].len = 0;
	}
}

int cec_queue_tx_msg(unsigned char *msg, unsigned char len)
{
	int s_idx, q_idx;

	s_idx = cec_tx_msgs.send_idx;
	q_idx = cec_tx_msgs.queue_idx;
	if (((q_idx + 1) & CEC_TX_MSG_BUF_MASK) == s_idx) {
		cec_dbg_prints("tx buffer full, abort msg\n");
		cec_reset_addr();
		return -1;
	}
	if (len && msg) {
		cec_memcpy(cec_tx_msgs.msg[q_idx].buf, msg, len);
		cec_tx_msgs.msg[q_idx].len = len;
		cec_tx_msgs.queue_idx = (q_idx + 1) & CEC_TX_MSG_BUF_MASK;
	}
	return 0;
}

int cec_triggle_tx(unsigned char *msg, unsigned char len)
{
	int i;

	if ((TX_IDLE == cec_rd_reg(CEC_TX_MSG_STATUS)) ||
	    (TX_DONE == cec_rd_reg(CEC_TX_MSG_STATUS))) {
		cec_dbg_prints("cec T:");
		for (i = 0; i < len; i++) {
			cec_wr_reg(CEC_TX_MSG_0_HEADER + i, msg[i]);
			cec_dbg_print(" ", msg[i]);
		}
		cec_dbg_prints("\n");
		cec_wr_reg(CEC_TX_MSG_LENGTH, len-1);
		cec_wr_reg(CEC_TX_MSG_CMD, TX_REQ_CURRENT); //TX_REQ_NEXT
		return 0;
	}
	return -1;
}

int remote_cec_ll_tx(unsigned char *msg, unsigned char len)
{
	cec_queue_tx_msg(msg, len);
	cec_triggle_tx(msg, len);

	return 0;
}

int ping_cec_ll_tx(unsigned char *msg, unsigned char len)
{
	int i;
	int ret = 0;
	unsigned int n = 900;
	unsigned int reg;

	ret = cec_rd_reg(CEC_RX_MSG_STATUS);
	cec_dbg_print("rx stat:", ret);
	ret = cec_rd_reg(CEC_TX_MSG_STATUS);
	cec_dbg_print(", tx stat:", ret);
	cec_dbg_prints("\n");

	while (cec_rd_reg(CEC_TX_MSG_STATUS) == TX_BUSY) {
		/*
		 * waiting tx to idle if it is busy, other device may in tx state
		 */
	}
	if (cec_rd_reg(CEC_TX_MSG_STATUS) == TX_ERROR)
		cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);

	for (i = 0; i < len; i++) {
		cec_wr_reg(CEC_TX_MSG_0_HEADER + i, msg[i]);
	}
	cec_wr_reg(CEC_TX_MSG_LENGTH, len-1);
	cec_wr_reg(CEC_TX_MSG_CMD, TX_REQ_CURRENT); //TX_REQ_NEXT
	ret = cec_rd_reg(CEC_RX_MSG_STATUS);
	cec_dbg_print("rx stat:", ret);
	ret = cec_rd_reg(CEC_TX_MSG_STATUS);
	cec_dbg_print(", tx stat:", ret);
	cec_dbg_prints("\n");

	while (1) {
		reg = cec_rd_reg(CEC_TX_MSG_STATUS);
		if ( reg == TX_DONE ) {
			ret = TX_DONE;
			cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
			cec_dbg_prints("ping_cec_ll_tx:TX_DONE\n")
			break;
		}

		if (reg == TX_ERROR) {
			ret = TX_ERROR;
			cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
			cec_dbg_prints("ping_cec_ll_tx:TX_ERROR\n")
			break;
		}
		if (!(n--)) {
			cec_dbg_prints("ping_cec_ll_tx:TX_BUSY\n")
			ret = TX_BUSY;
			cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
			break;
		}
		if (reg != TX_BUSY) {
			break;
		}
		_udelay(500);
	}

	return ret;
}

void cec_imageview_on(void)
{
	unsigned char msg[2];

	msg[0] = ((cec_msg.log_addr & 0xf) << 4)| CEC_TV_ADDR;
	msg[1] = CEC_OC_IMAGE_VIEW_ON;

	ping_cec_ll_tx(msg, 2);
}

void cec_report_physical_address(void)
{
	unsigned char msg[5];
	unsigned char phy_addr_ab = (readl(P_AO_DEBUG_REG1) >> 8) & 0xff;
	unsigned char phy_addr_cd = readl(P_AO_DEBUG_REG1) & 0xff;

	msg[0] = ((cec_msg.log_addr & 0xf) << 4)| CEC_BROADCAST_ADDR;
	msg[1] = CEC_OC_REPORT_PHYSICAL_ADDRESS;
	msg[2] = phy_addr_ab;
	msg[3] = phy_addr_cd;
	msg[4] = CEC_PLAYBACK_DEVICE_TYPE;

	remote_cec_ll_tx(msg, 5);
}

void cec_report_device_power_status(void)
{
	unsigned char msg[3];

	msg[0] = ((cec_msg.log_addr & 0xf) << 4)| CEC_TV_ADDR;
	msg[1] = CEC_OC_REPORT_POWER_STATUS;
	msg[2] = cec_msg.power_status;

	remote_cec_ll_tx(msg, 3);
}

void cec_set_stream_path(void)
{
	unsigned char phy_addr_ab = (readl(P_AO_DEBUG_REG1) >> 8) & 0xff;
	unsigned char phy_addr_cd = readl(P_AO_DEBUG_REG1) & 0xff;

	if ((hdmi_cec_func_config >> CEC_FUNC_MASK) & 0x1) {
		if ((hdmi_cec_func_config >> AUTO_POWER_ON_MASK) & 0x1) {
			if ((phy_addr_ab == cec_msg.buf[cec_msg.rx_read_pos].msg[2]) &&
			    (phy_addr_cd == cec_msg.buf[cec_msg.rx_read_pos].msg[3]))  {
				cec_msg.cec_power = 0x1;
			}
		}
	}
}

void cec_device_vendor_id(void)
{
	unsigned char msg[5];

	msg[0] = ((cec_msg.log_addr & 0xf) << 4)| CEC_BROADCAST_ADDR;
	msg[1] = CEC_OC_DEVICE_VENDOR_ID;
	msg[2] = 0x00;
	msg[3] = 0x00;
	msg[4] = 0x00;

	remote_cec_ll_tx(msg, 5);
}

void cec_feature_abort(void)
{
	if (cec_msg.buf[cec_msg.rx_read_pos].msg[1] != 0xf) {
		unsigned char msg[4];

		msg[0] = ((cec_msg.log_addr & 0xf) << 4) | CEC_TV_ADDR;
		msg[1] = CEC_OC_FEATURE_ABORT;
		msg[2] = cec_msg.buf[cec_msg.rx_read_pos].msg[1];
		msg[3] = CEC_UNRECONIZED_OPCODE;

		remote_cec_ll_tx(msg, 4);
	}
}

void cec_menu_status_smp(int menu_status)
{
	unsigned char msg[3];

	msg[0] = ((cec_msg.log_addr & 0xf) << 4)| CEC_TV_ADDR;
	msg[1] = CEC_OC_MENU_STATUS;
	msg[2] = menu_status;

	remote_cec_ll_tx(msg, 3);
}

void cec_inactive_source(void)
{
	unsigned char msg[4];
	unsigned char phy_addr_ab = (readl(P_AO_DEBUG_REG1) >> 8) & 0xff;
	unsigned char phy_addr_cd = readl(P_AO_DEBUG_REG1) & 0xff;

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | CEC_TV_ADDR;
	msg[1] = CEC_OC_INACTIVE_SOURCE;
	msg[2] = phy_addr_ab;
	msg[3] = phy_addr_cd;

	remote_cec_ll_tx(msg, 4);
}

void cec_set_standby(void)
{
	unsigned char msg[2];
	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | CEC_BROADCAST_ADDR;
	msg[1] = CEC_OC_STANDBY;

	remote_cec_ll_tx(msg, 2);
}

void cec_give_deck_status(void)
{
	unsigned char msg[3];

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | CEC_TV_ADDR;
	msg[1] = CEC_OC_DECK_STATUS;
	msg[2] = 0x1a;

	remote_cec_ll_tx(msg, 3);
}

void cec_set_osd_name(void)
{
	unsigned char msg[16];
	unsigned char osd_len = cec_strlen(CONFIG_CEC_OSD_NAME);

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | CEC_TV_ADDR;
	msg[1] = CEC_OC_SET_OSD_NAME;
	cec_memcpy(&msg[2], CONFIG_CEC_OSD_NAME, osd_len);

	remote_cec_ll_tx(msg, osd_len + 2);
}

void cec_get_version(void)
{
	unsigned char dest_log_addr = cec_msg.log_addr & 0xf;
	unsigned char msg[3];

	if (0xf != dest_log_addr) {
		msg[0] = ((cec_msg.log_addr & 0xf) << 4) | CEC_TV_ADDR;
		msg[1] = CEC_OC_CEC_VERSION;
		msg[2] = CEC_VERSION_14A;
		remote_cec_ll_tx(msg, 3);
	}
}

unsigned int cec_handle_message(void)
{
	unsigned char opcode;
	unsigned char dest;

	if (((hdmi_cec_func_config>>CEC_FUNC_MASK) & 0x1) &&
		(cec_msg.buf[cec_msg.rx_read_pos].msg_len > 1)) {
		opcode = cec_msg.buf[cec_msg.rx_read_pos].msg[1];
		switch (opcode) {
		case CEC_OC_GET_CEC_VERSION:
			cec_get_version();
			break;
		case CEC_OC_GIVE_DECK_STATUS:
			cec_give_deck_status();
			break;
		case CEC_OC_GIVE_PHYSICAL_ADDRESS:
			cec_report_physical_address();
			break;
		case CEC_OC_GIVE_DEVICE_VENDOR_ID:
			cec_device_vendor_id();
			break;
		case CEC_OC_GIVE_OSD_NAME:
			cec_set_osd_name();
			break;
		case CEC_OC_SET_STREAM_PATH:
			cec_set_stream_path();
			break;
		case CEC_OC_GIVE_DEVICE_POWER_STATUS:
			cec_report_device_power_status();
			break;
		case CEC_OC_USER_CONTROL_PRESSED:
			if (((hdmi_cec_func_config >> CEC_FUNC_MASK) & 0x1) &&
			    ((hdmi_cec_func_config >> AUTO_POWER_ON_MASK) & 0x1) &&
			     (cec_msg.buf[cec_msg.rx_read_pos].msg_len == 3) &&
			    ((0x40 == cec_msg.buf[cec_msg.rx_read_pos].msg[2]) ||
			     (0x6d == cec_msg.buf[cec_msg.rx_read_pos].msg[2]) ||
			     (0x09 == cec_msg.buf[cec_msg.rx_read_pos].msg[2]) )) {
				cec_msg.cec_power = 0x1;
			}
			break;
		case CEC_OC_MENU_REQUEST:
			cec_menu_status_smp(DEVICE_MENU_INACTIVE);
			break;

		/* TV wake up by down stream devices */
		case CEC_OC_IMAGE_VIEW_ON:
		case CEC_OC_TEXT_VIEW_ON:
			dest = cec_msg.buf[cec_msg.rx_read_pos].msg[0] & 0xf;
			if (dest == CEC_TV_ADDR)
				cec_msg.cec_power = 0x1;
			break;
		default:
			break;
		}
	}
	cec_rx_read_pos_plus();
	return 0;
}

void cec_reset_addr(void)
{
	remote_cec_hw_reset();
	cec_wr_reg(CEC_LOGICAL_ADDR0, 0);
	cec_hw_buf_clear();
	cec_wr_reg(CEC_LOGICAL_ADDR0, cec_msg.log_addr & 0x0f);
	_udelay(100);
	cec_wr_reg(CEC_LOGICAL_ADDR0, (0x1 << 4) | (cec_msg.log_addr & 0x0f));
}

unsigned int cec_handler(void)
{
	unsigned char s_idx;
	static int busy_count = 0;
	if (0xf == cec_rd_reg(CEC_RX_NUM_MSG)) {
		cec_wr_reg(CEC_RX_CLEAR_BUF, 0x1);
		cec_wr_reg(CEC_RX_CLEAR_BUF, 0x0);
		cec_wr_reg(CEC_RX_MSG_CMD,  RX_ACK_CURRENT);
		cec_wr_reg(CEC_RX_MSG_CMD, RX_NO_OP);
		cec_dbg_prints("error:hw_buf overflow\n");
	}

	switch (cec_rd_reg(CEC_RX_MSG_STATUS)) {
	case RX_DONE:
		if (1 == cec_rd_reg(CEC_RX_NUM_MSG)) {
			remote_cec_ll_rx();
			(cec_msg.rx_write_pos == cec_msg.rx_buf_size - 1) ? (cec_msg.rx_write_pos = 0) : (cec_msg.rx_write_pos++);
		}
		cec_wr_reg(CEC_RX_MSG_CMD, RX_ACK_CURRENT);
		cec_wr_reg(CEC_RX_MSG_CMD, RX_NO_OP);
		cec_dbg_prints("RX_OK\n");
		break;
	case RX_ERROR:
		cec_dbg_prints("RX_ERROR\n");
		if (TX_ERROR == cec_rd_reg(CEC_TX_MSG_STATUS)) {
			cec_dbg_prints("TX_ERROR\n");
			cec_reset_addr();
		} else {
			cec_dbg_prints("TX_other\n");
			cec_wr_reg(CEC_RX_MSG_CMD,  RX_ACK_CURRENT);
			cec_wr_reg(CEC_RX_MSG_CMD, RX_NO_OP);
		}
		break;
	default:
		break;
	}

	switch (cec_rd_reg(CEC_TX_MSG_STATUS)) {
	case TX_DONE:
		cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
		cec_tx_msgs.send_idx = (cec_tx_msgs.send_idx + 1) & CEC_TX_MSG_BUF_MASK;
		s_idx = cec_tx_msgs.send_idx;
		if (cec_tx_msgs.send_idx != cec_tx_msgs.queue_idx) {
			cec_dbg_prints("TX_OK\n");
			cec_triggle_tx(cec_tx_msgs.msg[s_idx].buf,
				       cec_tx_msgs.msg[s_idx].len);
		} else {
			cec_dbg_prints("TX_END\n");
		}
		busy_count = 0;
		break;

	case TX_ERROR:
		cec_dbg_prints("@TX_ERROR\n");
		if (RX_ERROR == cec_rd_reg(CEC_RX_MSG_STATUS)) {
			cec_dbg_prints("@RX_ERROR\n");
			cec_reset_addr();
		} else {
			cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
			s_idx = cec_tx_msgs.send_idx;
			if (cec_tx_msgs.msg[s_idx].retry < 5) {
				cec_tx_msgs.msg[s_idx].retry++;
				cec_triggle_tx(cec_tx_msgs.msg[s_idx].buf,
					       cec_tx_msgs.msg[s_idx].len);
			} else {
				cec_dbg_prints("TX retry too much, abort msg\n");
				cec_tx_msgs.send_idx = (cec_tx_msgs.send_idx + 1) & CEC_TX_MSG_BUF_MASK;
			}
		}
		busy_count = 0;
		break;

	 case TX_IDLE:
		s_idx = cec_tx_msgs.send_idx;
		if (cec_tx_msgs.send_idx != cec_tx_msgs.queue_idx) { // triggle tx if idle
			cec_triggle_tx(cec_tx_msgs.msg[s_idx].buf,
				       cec_tx_msgs.msg[s_idx].len);
		}
		busy_count = 0;
		break;

	case TX_BUSY:
		busy_count++;
		if (busy_count >= 2000) {
			uart_puts("busy too long, reset hw\n");
			cec_reset_addr();
			busy_count = 0;
		}
		break;

	 default:
		break;
	}
	if (cec_msg.rx_read_pos != cec_msg.rx_write_pos) {
		cec_handle_message();
	}

	return 0;
}

void cec_node_init(void)
{
	static int i = 0;
	static unsigned int retry = 0;
	static int regist_devs = 0;
	static enum _cec_log_dev_addr_e *probe = NULL;

	int tx_stat;
	unsigned char msg[1];
	unsigned int kern_log_addr = (readl(P_AO_DEBUG_REG1) >> 16) & 0xf;
	enum _cec_log_dev_addr_e player_dev[3][3] =
		{{CEC_PLAYBACK_DEVICE_1_ADDR, CEC_PLAYBACK_DEVICE_2_ADDR, CEC_PLAYBACK_DEVICE_3_ADDR},
		 {CEC_PLAYBACK_DEVICE_2_ADDR, CEC_PLAYBACK_DEVICE_3_ADDR, CEC_PLAYBACK_DEVICE_1_ADDR},
		 {CEC_PLAYBACK_DEVICE_3_ADDR, CEC_PLAYBACK_DEVICE_1_ADDR, CEC_PLAYBACK_DEVICE_2_ADDR}};

	if (retry >= 12) {  // retry all device addr
		cec_msg.log_addr = 0x0f;
		uart_puts("failed on retried all possible address\n");
		return ;
	}
	if (probe == NULL) {
		cec_msg.rx_read_pos = 0;
		cec_msg.rx_write_pos = 0;
		cec_msg.rx_buf_size = 4;

		cec_msg.power_status = 1;
		cec_msg.cec_power = 0;
		cec_msg.test = 0x0;
		cec_tx_msgs.send_idx = 0;
		cec_tx_msgs.queue_idx = 0;
		cec_tx_buf_init();
		cec_buf_clear();
		cec_wr_reg(CEC_LOGICAL_ADDR0, 0);
		cec_hw_buf_clear();
		cec_wr_reg(CEC_LOGICAL_ADDR0, 0xf);
		_udelay(100);
		cec_wr_reg(CEC_LOGICAL_ADDR0, (0x1 << 4) | 0xf);
		/*
		 * use kernel cec logic address to detect which logic address is the
		 * started one to allocate.
		 */
		cec_dbg_print("kern log_addr:0x", kern_log_addr);
		uart_puts("\n");
		/* we don't need probe TV address */
		if (kern_log_addr == CEC_TV_ADDR) {
			msg[0] = (CEC_TV_ADDR << 4) | CEC_TV_ADDR;
			ping_cec_ll_tx(msg, 1);
			cec_msg.log_addr = 0x10;
			cec_wr_reg(CEC_LOGICAL_ADDR0, 0);
			cec_hw_buf_clear();
			cec_wr_reg(CEC_LOGICAL_ADDR0, 0x0);
			_udelay(100);
			cec_wr_reg(CEC_LOGICAL_ADDR0, (0x1 << 4) | 0x0);
			cec_dbg_print("Set cec log_addr:0x", cec_msg.log_addr);
			cec_dbg_print(",ADDR0:", cec_rd_reg(CEC_LOGICAL_ADDR0));
			uart_puts("\n");
			probe = NULL;
			regist_devs = 0;
			i = 0;
			retry = 0;
			return ;
		}
		for (i = 0; i < 3; i++) {
			if (kern_log_addr == player_dev[i][0]) {
				probe = player_dev[i];
				break;
			}
		}
		if (probe == NULL) {
			probe = player_dev[0];
		}
		i = 0;
	}

	msg[0] = (probe[i]<<4) | probe[i];
	tx_stat = ping_cec_ll_tx(msg, 1);
	if (tx_stat == TX_BUSY) {   // can't get cec bus
		retry++;
		remote_cec_hw_reset();
		if (!(retry & 0x03)) {
			cec_dbg_print("retry too much, log_addr:0x", probe[i]);
			uart_puts("\n");
		} else {
			i -= 1;
		}
	} else if (tx_stat == TX_ERROR) {
		cec_wr_reg(CEC_LOGICAL_ADDR0, 0);
		cec_hw_buf_clear();
		cec_wr_reg(CEC_LOGICAL_ADDR0, probe[i]);
		_udelay(100);
		cec_wr_reg(CEC_LOGICAL_ADDR0, (0x1 << 4) | probe[i]);
		cec_msg.log_addr = probe[i];
		cec_dbg_print("Set cec log_addr:0x", cec_msg.log_addr);
		cec_dbg_print(", ADDR0:", cec_rd_reg(CEC_LOGICAL_ADDR0));
		uart_puts("\n");
		probe = NULL;
		regist_devs = 0;
		i = 0;
		retry = 0;
		return ;
	} else if (tx_stat == TX_DONE) {
		cec_dbg_print("sombody takes cec log_addr:0x", probe[i]);
		uart_puts("\n");
		regist_devs |= (1 << i);
		retry += (4 - (retry & 0x03));
		if (regist_devs == 0x07) {
			// No avilable logical address
			cec_msg.log_addr = 0x0f;
			cec_wr_reg(CEC_LOGICAL_ADDR0, (0x1 << 4) | 0xf);
			uart_puts("CEC allocate logic address failed\n");
		}
	}
	i++;
	if (i == 3) {
		i = 0;
	}
}

#endif
