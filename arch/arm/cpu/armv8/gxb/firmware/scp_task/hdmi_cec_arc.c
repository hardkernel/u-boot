/**************************************************
 *           HDMI CEC uboot code                  *
 *                                                *
 **************************************************/
#ifdef CONFIG_CEC_WAKEUP
#include "secure_apb.h"
#include "cec_tx_reg.h"
#ifndef NULL
#define NULL ((void *)0)
#endif
/* #define CEC_DBG_PRINT */
#undef CEC_DBG_PRINT
#ifdef CEC_DBG_PRINT
	#define cec_dbg_print(s,v) {uart_puts(s);uart_put_hex(v,8);}
	#define cec_dbg_printx(s,v,x) {uart_puts(s);uart_put_hex(v,x);}
	#define cec_dbg_prints(s)  {uart_puts(s);wait_uart_empty();}
#else
	#define cec_dbg_print(s,v)
	#define cec_dbg_printx(s,v,x)
	#define cec_dbg_prints(s)
#endif

static int cec_strlen(char *p)
{
	int i=0;
	while (*p++)
		i++;
	return i;
}

static void *cec_memcpy(void *memto, const void *memfrom, unsigned int size)
{
	char *tempfrom = (char *)memfrom;
	char *tempto = (char *)memto;

	if ((memto == NULL) || (memfrom == NULL))
		return NULL;
	while (size -- > 0)
		*tempto++ = *tempfrom++;
	return memto;
}

static void waiting_aocec_free(void) {
	unsigned int cnt = 0;
	while (readl(P_AO_CEC_RW_REG) & (1<<23))
	{
		if (8192 <= cnt++)
		{
			cec_dbg_printx("\nWARNING: waiting_aocec_free cnt:0x", cnt, 16);
			cec_dbg_prints("\n");
			break;
		}
	}
}

static unsigned long cec_rd_reg(unsigned long addr)
{
	unsigned long data32;
	waiting_aocec_free();
	data32  = 0;
	data32 |= 0             << 16;  // [16]   cec_reg_wr
	data32 |= 0             << 8;   // [15:8] cec_reg_wrdata
	data32 |= (addr & 0xff) << 0;   // [7:0]  cec_reg_addr
	writel(data32, P_AO_CEC_RW_REG);
	waiting_aocec_free();
	data32 = ((readl(P_AO_CEC_RW_REG)) >> 24) & 0xff;
	return data32;
}

static void cec_wr_reg(unsigned long addr, unsigned long data)
{
	unsigned long data32;
	waiting_aocec_free();
	data32  = 0;
	data32 |= 1             << 16;  // [16]   cec_reg_wr
	data32 |= (data & 0xff) << 8;   // [15:8] cec_reg_wrdata
	data32 |= (addr & 0xff) << 0;   // [7:0]  cec_reg_addr
	writel(data32, P_AO_CEC_RW_REG);
	waiting_aocec_free();
}

static void cec_arbit_bit_time_set(unsigned bit_set, unsigned time_set)
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

static void cec_hw_buf_clear(void)
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
	cec_dbg_prints("\nremote_cec_hw_reset\n");

	/*
	 * clock switch to 32k
	 */
	writel(readl(P_AO_CRT_CLK_CNTL1) | (1 << 16), P_AO_CRT_CLK_CNTL1);

	writel(readl(P_AO_RTI_PIN_MUX_REG) & (~(1 << 14 | 1 << 17)), P_AO_RTI_PIN_MUX_REG);
	writel(readl(P_AO_RTI_PIN_MUX_REG2) & (~(1 << 0)), P_AO_RTI_PIN_MUX_REG2);
	writel(readl(P_AO_RTI_PULL_UP_REG) & (~(1 << 12)), P_AO_RTI_PULL_UP_REG);
	writel(readl(P_AO_RTI_PIN_MUX_REG) | (1 << 15), P_AO_RTI_PIN_MUX_REG);
	//unsigned long data32;
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

static int cec_triggle_tx(unsigned char *msg, unsigned char len)
{
	unsigned int i, cnt = 0;
	cec_dbg_print("cec_triggle_tx len:0x", len);
	cec_dbg_prints("\n");

	cec_dbg_prints(" T:");
	for (i = 0; i < len; i++) {
		cec_wr_reg(CEC_TX_MSG_0_HEADER + i, msg[i]);
		cec_dbg_print(" ", msg[i]);
	}
	cec_dbg_prints("\n");
	cec_wr_reg(CEC_TX_MSG_LENGTH, len - 1);

	do {
		cec_wr_reg(CEC_TX_MSG_CMD, TX_REQ_CURRENT);
		cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
		cnt++;
	} while (cec_rd_reg(CEC_TX_NUM_MSG));

	if (cnt > 1) {
		cec_dbg_printx("WARNING: cec_triggle_tx cnt:0x", cnt, 16);
		cec_dbg_prints("\n");
	}

	return 0;
}

#define DEVICE_TV		0
#define DEVICE_RECORDER		1
#define DEVICE_RESERVED		2
#define DEVICE_TUNER		3
#define DEVICE_PLAYBACK		4
#define DEVICE_AUDIO_SYSTEM	5
#define DEVICE_PURE_CEC_SWITCH	6
#define DEVICE_VIDEO_PROCESSOR	7

static unsigned char log_addr_to_devtype(unsigned int addr)
{
	static unsigned char addr_map[] = {
		DEVICE_TV,
		DEVICE_RECORDER,
		DEVICE_RECORDER,
		DEVICE_TUNER,
		DEVICE_PLAYBACK,
		DEVICE_AUDIO_SYSTEM,
		DEVICE_TUNER,
		DEVICE_TUNER,
		DEVICE_PLAYBACK,
		DEVICE_RECORDER,
		DEVICE_TUNER,
		DEVICE_PLAYBACK,
		DEVICE_RESERVED,
		DEVICE_RESERVED,
		DEVICE_TV,
		DEVICE_PLAYBACK
	};
	return addr_map[addr & 0xf];
}

static void cec_report_physical_address(void)
{
	unsigned char msg[5];
	cec_dbg_prints("cec_report_physical_address\n");

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | CEC_BROADCAST_ADDR;
	msg[1] = CEC_OC_REPORT_PHYSICAL_ADDRESS;
	msg[2] = (cec_msg.phy_addr >> 8) & 0xff;
	msg[3] = cec_msg.phy_addr & 0xff;
	msg[4] = log_addr_to_devtype(cec_msg.log_addr);

	cec_triggle_tx(msg, 5);
}

static void cec_report_power_status(unsigned char initiator)
{
	unsigned char msg[3];
	cec_dbg_printx("cec_report_power_status initiator:0x", initiator, 4);
	cec_dbg_prints("\n");

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | (initiator & 0xf);
	msg[1] = CEC_OC_REPORT_POWER_STATUS;
	msg[2] = POWER_STANDBY;

	cec_triggle_tx(msg, 3);
}

static void cec_feature_abort(unsigned char reason, unsigned char initiator)
{
	unsigned char msg[4];
	cec_dbg_print("cec_feature_abort reason:0x", reason);
	cec_dbg_printx(", initiator:0x", initiator, 4);
	cec_dbg_prints("\n");

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | (initiator & 0xf);
	msg[1] = CEC_OC_FEATURE_ABORT;
	msg[2] = cec_msg.msg[1];
	msg[3] = reason;

	cec_triggle_tx(msg, 4);
}

static void cec_set_stream_path(void)
{
	unsigned char phy_addr_ab = (cec_msg.phy_addr >> 8) & 0xff;
	unsigned char phy_addr_cd = cec_msg.phy_addr & 0xff;
	cec_dbg_prints("cec_set_stream_path\n");

	if ((hdmi_cec_func_config >> AUTO_POWER_ON_MASK) & 0x1) {
		if ((hdmi_cec_func_config >> STREAMPATH_POWER_ON_MASK) & 0x1) {
			if ((phy_addr_ab == cec_msg.msg[2]) &&
				(phy_addr_cd == cec_msg.msg[3])) {
				cec_msg.cec_power = 0x1;
			}
		}
	}
}

static void cec_user_control_pressed(void)
{
	cec_dbg_print("cec_user_control_pressed operation:0x", cec_msg.msg[2]);
	cec_dbg_prints("\n");

	if ((hdmi_cec_func_config >> AUTO_POWER_ON_MASK) & 0x1) {
		if ((0x40 == cec_msg.msg[2]) || // Power
			(0x6b == cec_msg.msg[2]) || // Power Toggle Function
			(0x6d == cec_msg.msg[2]) || // Power On Function
			(0x09 == cec_msg.msg[2])) { // Root Menu
			cec_msg.cec_power = 0x1;
		}
	}
}

static void cec_device_vendor_id(void)
{
	unsigned char msg[5];
	cec_dbg_prints("cec_device_vendor_id\n");

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | CEC_BROADCAST_ADDR;
	msg[1] = CEC_OC_DEVICE_VENDOR_ID;
	msg[2] = 0x00;
	msg[3] = 0x00;
	msg[4] = 0x00;

	cec_triggle_tx(msg, 5);
}

static void cec_menu_status(unsigned char menu_status, unsigned char initiator)
{
	unsigned char msg[3];
	cec_dbg_print("cec_menu_status menu_status:0x", menu_status);
	cec_dbg_printx(", initiator:0x", initiator, 4);
	cec_dbg_prints("\n");

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | (initiator & 0xf);
	msg[1] = CEC_OC_MENU_STATUS;
	msg[2] = menu_status;

	cec_triggle_tx(msg, 3);
}

static void cec_deck_status(unsigned char initiator)
{
	unsigned char msg[3];
	cec_dbg_printx("cec_deck_status initiator:0x", initiator, 4);
	cec_dbg_prints("\n");

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | (initiator & 0xf);
	msg[1] = CEC_OC_DECK_STATUS;
	msg[2] = 0x1a; // DECK_STOP

	cec_triggle_tx(msg, 3);
}

static void cec_set_osd_name(unsigned char initiator)
{
	unsigned char msg[16];
	unsigned char osd_len = cec_strlen(CONFIG_CEC_OSD_NAME);
	cec_dbg_printx("cec_set_osd_name initiator:0x", initiator, 4);
	cec_dbg_prints("\n");

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | (initiator & 0xf);
	msg[1] = CEC_OC_SET_OSD_NAME;
	cec_memcpy(&msg[2], CONFIG_CEC_OSD_NAME, osd_len);

	cec_triggle_tx(msg, osd_len + 2);
}

static void cec_get_version(unsigned char initiator)
{
	unsigned char msg[3];
	cec_dbg_printx("cec_get_version initiator:0x", initiator, 4);
	cec_dbg_prints("\n");

	msg[0] = ((cec_msg.log_addr & 0xf) << 4) | (initiator & 0xf);
	msg[1] = CEC_OC_CEC_VERSION;
	msg[2] = CEC_VERSION_14A;

	cec_triggle_tx(msg, 3);
}

static unsigned int cec_handle_message(void)
{
	unsigned char initiator = (cec_msg.msg[0] >> 4) & 0xf;
	unsigned char destination = cec_msg.msg[0] & 0xf;
	unsigned char opcode = (cec_msg.msg_len > 1) ? cec_msg.msg[1] : CEC_OC_POLLING_MESSAGE;
	unsigned char directly_addressed = (destination != 0xf && destination == cec_msg.log_addr);

	cec_dbg_printx("cec_handle_message initiator:0x", initiator, 4);
	cec_dbg_printx(", destination:0x", destination, 4);
	cec_dbg_print(", opcode:0x", opcode);
	cec_dbg_prints("\n");

	switch (opcode) {
	case CEC_OC_POLLING_MESSAGE:
		break;
	case CEC_OC_GET_CEC_VERSION:
		if (directly_addressed)
			cec_get_version(initiator);
		break;
	case CEC_OC_GIVE_DECK_STATUS:
		cec_deck_status(initiator);
		break;
	case CEC_OC_GIVE_PHYSICAL_ADDRESS:
		cec_report_physical_address();
		break;
	case CEC_OC_GIVE_DEVICE_VENDOR_ID:
		cec_device_vendor_id();
		break;
	case CEC_OC_VENDOR_COMMAND:
	case CEC_OC_VENDOR_COMMAND_WITH_ID:
		break;
	case CEC_OC_GIVE_OSD_NAME:
		if (directly_addressed)
			cec_set_osd_name(initiator);
		break;
	case CEC_OC_SET_STREAM_PATH:
		cec_set_stream_path();
		break;
	case CEC_OC_GIVE_DEVICE_POWER_STATUS:
		if (directly_addressed)
			cec_report_power_status(initiator);
		break;
	case CEC_OC_USER_CONTROL_PRESSED:
		if (directly_addressed)
			cec_user_control_pressed();
		break;
	case CEC_OC_USER_CONTROL_RELEASED:
		break;
	case CEC_OC_MENU_REQUEST:
		if (directly_addressed)
			cec_menu_status(DEVICE_MENU_INACTIVE, initiator);
		break;
	case CEC_OC_ABORT_MESSAGE:
		if (directly_addressed)
			cec_feature_abort(CEC_UNRECONIZED_OPCODE, initiator);
		break;
	default:
		if (directly_addressed) {
			cec_dbg_print("WARNING: unhandled directly addressed opcode:0x", opcode);
			cec_dbg_prints("\n");
			cec_feature_abort(CEC_UNABLE_TO_DETERMINE, initiator);
		}
		break;
	}
	return 0;
}

static unsigned int cec_tx_irq_handler(void)
{
	unsigned int cnt = 0;
#ifdef CEC_DBG_PRINT
	unsigned int tx_msg_status = cec_rd_reg(CEC_TX_MSG_STATUS);
	unsigned int tx_num_msg = cec_rd_reg(CEC_TX_NUM_MSG);
#endif
	cec_dbg_printx("cec_tx_irq_handler tx_msg_status:0x", tx_msg_status, 4);
	cec_dbg_printx(", tx_num_msg:0x", tx_num_msg, 4);
	cec_dbg_prints("\n");

	do {
		cec_wr_reg(CEC_TX_MSG_CMD, TX_NO_OP);
		cnt++;
	} while (cec_rd_reg(CEC_TX_NUM_MSG));
	writel((1 << 1), P_AO_CEC_INTR_CLR);

	if (cnt > 1) {
		cec_dbg_printx("WARNING: cec_tx_irq_handler cnt:0x", cnt, 16);
		cec_dbg_prints("\n");
	}

	return 0;
}

static unsigned int cec_rx_irq_handler(void)
{
	unsigned int cnt = 0;
#ifdef CEC_DBG_PRINT
	unsigned int rx_msg_status = cec_rd_reg(CEC_RX_MSG_STATUS);
#endif
	unsigned int rx_num_msg = cec_rd_reg(CEC_RX_NUM_MSG);
	cec_dbg_printx("cec_rx_irq_handler rx_msg_status:0x", rx_msg_status, 4);
	cec_dbg_printx(", rx_num_msg:0x", rx_num_msg, 4);
	cec_dbg_prints("\n");

	if (rx_num_msg) {
		unsigned int i, rx_msg_length = cec_rd_reg(CEC_RX_MSG_LENGTH) + 1;
		cec_dbg_prints(" R:");
		for (i = 0; i < rx_msg_length && i < MAX_MSG; i++) {
			cec_msg.msg[i] = cec_rd_reg(CEC_RX_MSG_0_HEADER + i);
			cec_dbg_print(" ", cec_msg.msg[i]);
		}
		for (; i < MAX_MSG; i++) {
			cec_msg.msg[i] = 0x0;
		}
		cec_msg.msg_len = rx_msg_length;
		cec_dbg_prints("\n");
	}

	do {
		cec_wr_reg(CEC_RX_MSG_CMD, RX_ACK_CURRENT);
		cec_wr_reg(CEC_RX_MSG_CMD, RX_NO_OP);
		cnt++;
	} while (cec_rd_reg(CEC_RX_NUM_MSG));
	writel((1 << 2), P_AO_CEC_INTR_CLR);

	if (cnt > 2) {
		cec_dbg_printx("WARNING: cec_rx_irq_handler cnt:0x", cnt, 16);
		cec_dbg_prints("\n");
	}

	if (rx_num_msg)
		cec_handle_message();

	return 0;
}

unsigned int cec_handler(void)
{
	unsigned int intr_stat = readl(P_AO_CEC_INTR_STAT);
	if (intr_stat & (1<<1)) {
		cec_tx_irq_handler();
	}
	if (intr_stat & (1<<2)) {
		cec_rx_irq_handler();
	}
	return 0;
}

void cec_node_init(void)
{
	unsigned int phy_addr = readl(P_AO_DEBUG_REG1) & 0xffff;
	unsigned int log_addr = readl(P_AO_DEBUG_REG3) & 0xf;
	if (!log_addr)
		log_addr = 0xf;

	cec_dbg_printx("AO_DEBUG_REG0:0x", readl(P_AO_DEBUG_REG0), 32);
	cec_dbg_printx(", AO_DEBUG_REG1:0x", readl(P_AO_DEBUG_REG1), 32);
	cec_dbg_prints("\n");
	cec_dbg_printx("AO_DEBUG_REG2:0x", readl(P_AO_DEBUG_REG2), 32);
	cec_dbg_printx(", AO_DEBUG_REG3:0x", readl(P_AO_DEBUG_REG3), 32);
	cec_dbg_prints("\n");

	cec_dbg_print("cec_node_init cec_config:0x", hdmi_cec_func_config);
	cec_dbg_printx(", log_addr:0x", log_addr, 4);
	cec_dbg_printx(", phy_addr:0x", phy_addr, 16);
	cec_dbg_prints("\n");

	cec_msg.msg_len = 0;
	cec_msg.cec_power = 0;
	cec_msg.log_addr = log_addr;
	cec_msg.phy_addr = phy_addr;

	cec_wr_reg(CEC_LOGICAL_ADDR0, 0);
	cec_hw_buf_clear();
	cec_wr_reg(CEC_LOGICAL_ADDR0, log_addr);
	_udelay(100);
	cec_wr_reg(CEC_LOGICAL_ADDR0, (0x1 << 4) | log_addr);
	_udelay(100);

	cec_report_physical_address();
	_udelay(150);
	cec_device_vendor_id();
	cec_set_osd_name(CEC_TV_ADDR);
}

#endif
